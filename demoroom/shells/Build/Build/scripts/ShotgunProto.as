// PROTOTYPE - NOT FOR PRODUCTION
// Question: does FILO shell-order reloading (interruptible, type-selective) feel like a puzzle?
// Date: 2026-07-26 (v4: ADS, chamber inspect, typed shell models, spent hull ejection)
#include "TegeBehavior.as"
//
// Controls:
//   LMB       fire
//   RMB hold  aim down sights (tighter scatter spread + zoom)
//   T toggle  inspect: turn the gun and see what's chambered
//   R         load one shell of the selected type
//   F         Five: pump   |   Two: break open / snap shut
//   G         swap guns (The Five <-> The Two)
//   1/2/3     select shell type: SCATTER / SLUG / DRAGON

const int SHELL_NONE    = -1;
const int SHELL_SCATTER = 0;
const int SHELL_SLUG    = 1;
const int SHELL_DRAGON  = 2;

const int GUN_FIVE = 0;
const int GUN_TWO  = 1;

const int   TUBE_CAP      = 4;
const float RELOAD_TIME   = 0.7f;
const float PUMP_TIME     = 0.45f;
const float BREAK_TIME    = 0.3f;
const float BARREL_TIME   = 0.35f;
const float SNAP_TIME     = 0.25f;
const float FLASH_TIME    = 0.2f;
const float RECOIL_TIME   = 0.12f;
const float BREAK_ANGLE   = 38.0f;
const float ADS_FOV_DROP  = 14.0f;
const float HULL_FLIGHT   = 0.7f;   // seconds a spent hull stays visible

class ShotgunProto : TegeBehavior {
    int gun = GUN_FIVE;

    // The Five
    array<int> tube;
    int   chamber = SHELL_NONE;
    bool  chamberSpent = false;

    // The Two
    array<int> barrels;
    bool  broken = false;
    int   twoSpent = 0;         // fired since last break (hulls waiting in the barrels)

    // Shared
    int   selected = SHELL_SCATTER;
    int   pendingType = SHELL_SCATTER;   // type locked in when a load starts
    array<int> reserve = {10, 5, 5};

    float actionTimer = 0.0f;
    float actionDuration = 1.0f;
    int   pendingAction = 0;    // 0 none, 1 pump, 2 insert(five), 3 break, 4 insert(two), 5 snap

    // Feedback
    uint64 hudEnt = 0;
    uint64 flashLight = 0;
    float  lightDecay = 0.0f;
    uint64 flashEnt = 0;
    float  flashTimer = 0.0f;
    Vector3 flashOrigColor;

    // Viewmodel
    uint64 vmRoot = 0;
    uint64 vmBarrel = 0;
    uint64 vmTube = 0;
    uint64 vmForend = 0;
    uint64 vmTwoBarrels = 0;
    array<uint64> shellEnts;    // [SCT, SLG, DRG]
    array<uint64> hullEnts;     // 2 ejectable spent hulls
    array<Vector3> hullPos;
    array<Vector3> hullVel;
    array<float> hullTimer;
    float  recoilTimer = 0.0f;
    float  adsBlend = 0.0f;
    float  inspectBlend = 0.0f;
    bool   inspectOn = false;
    float  baseFov = 0.0f;

    // inspect display: chamber + 4 tube slots (runtime-colored generic shells)
    array<uint64> slotEnts;
    // world-space dropped shells (real physics bodies), walk over to collect
    array<uint64> pickupEnts;
    array<int> pickupTypes;
    array<float> pickupAge;
    int    nextPickup = 0;

    // containment: dynamic props that fall below the world get sent home
    array<uint64> dynEnts;
    array<Vector3> dynHomes;
    float  containTimer = 0.0f;

    void OnStart() {
        hudEnt = Scene_FindEntity("HUD_Tube");
        flashLight = Scene_FindEntity("DragonFlash");
        vmRoot       = Scene_FindEntity("VM_Root");
        vmBarrel     = Scene_FindEntity("VM_Barrel");
        vmTube       = Scene_FindEntity("VM_Tube");
        vmForend     = Scene_FindEntity("VM_Forend");
        vmTwoBarrels = Scene_FindEntity("VM_TwoBarrels");
        shellEnts.insertLast(Scene_FindEntity("VM_Shell_SCT"));
        shellEnts.insertLast(Scene_FindEntity("VM_Shell_SLG"));
        shellEnts.insertLast(Scene_FindEntity("VM_Shell_DRG"));
        hullEnts.insertLast(Scene_FindEntity("VM_Hull"));
        hullEnts.insertLast(Scene_FindEntity("VM_Hull2"));
        hullPos.resize(2); hullVel.resize(2);
        hullTimer.insertLast(0.0f); hullTimer.insertLast(0.0f);
        slotEnts.insertLast(Scene_FindEntity("VM_ChamberSlot"));
        slotEnts.insertLast(Scene_FindEntity("VM_TubeSlot0"));
        slotEnts.insertLast(Scene_FindEntity("VM_TubeSlot1"));
        slotEnts.insertLast(Scene_FindEntity("VM_TubeSlot2"));
        slotEnts.insertLast(Scene_FindEntity("VM_TubeSlot3"));
        for (int i = 0; i < 6; i++) {
            uint64 pe = Scene_FindEntity("ShellPickup" + i);
            pickupEnts.insertLast(pe);
            pickupTypes.insertLast(-1);
            pickupAge.insertLast(999.0f);
            if (pe != 0) Entity_SetVisible(pe, false);
        }

        baseFov = Camera_GetFOV(_entityId);

        // Re-home the shooting targets every play start. Play-mode changes
        // persist on Stop in this engine, so without this the targets start
        // wherever the last session's shots left them.
        uint64 sphere = Scene_FindEntity("Sphere");
        if (sphere != 0) Physics_Teleport(sphere, Vector3(1.5f, 0.55f, -5.0f));
        uint64 crate = Scene_FindEntity("Crate");
        if (crate != 0) Physics_Teleport(crate, Vector3(-1.5f, 0.52f, -5.0f));

        // register every dynamic prop for fall containment
        RegisterDyn("Sphere"); RegisterDyn("Crate");
        for (int i = 0; i < 6; i++) RegisterDyn("Range_Ball" + i);
        for (int i = 0; i < 3; i++) RegisterDyn("Noodle_Pot" + i);
        for (int i = 0; i < 3; i++) RegisterDyn("Hotel_Bowl" + i);

        tube.insertLast(SHELL_SCATTER);
        tube.insertLast(SHELL_SCATTER);
        reserve[SHELL_SCATTER] -= 2;
        ApplyGunVisibility();
        UpdateHUD("pump to chamber (F)   [G swaps gun, RMB aims, T inspects]");
        Debug_Log("[ShotgunProto v4] LMB fire, RMB aim, T inspect, R load, F pump/break, G swap, 1/2/3 shell");
    }

    void Sfx(const string &in name) {
        Audio_PlayAtPosition("assets/sfx/" + name, GetPosition());
    }

    void OnUpdate(float dt) {
        if (Input_GetKeyDown(Key::Num1)) SelectShell(SHELL_SCATTER);
        if (Input_GetKeyDown(Key::Num2)) SelectShell(SHELL_SLUG);
        if (Input_GetKeyDown(Key::Num3)) SelectShell(SHELL_DRAGON);

        if (actionTimer > 0.0f) {
            actionTimer -= dt;
            if (actionTimer <= 0.0f) FinishAction();
        }

        if (Input_GetMouseButtonDown(MouseBtn::Left)) TryFire();

        if (Input_GetKeyDown(Key::F) && actionTimer <= 0.0f) {
            if (gun == GUN_FIVE) StartPump();
            else                 ToggleBreak();
        }

        if (Input_GetKeyDown(Key::R)) {
            if (AnyCatchable()) {
                TryCatch();
            } else if (actionTimer <= 0.0f) {
                if (gun == GUN_FIVE) StartInsertFive();
                else                 StartInsertTwo();
            }
        }

        if (Input_GetKeyDown(Key::G) && actionTimer <= 0.0f) SwapGun();

        // aim down sights (hold RMB)
        float adsTarget = Input_GetMouseButton(MouseBtn::Right) ? 1.0f : 0.0f;
        adsBlend = MoveTowards(adsBlend, adsTarget, 8.0f * dt);
        if (baseFov > 0.0f) Camera_SetFOV(_entityId, baseFov - ADS_FOV_DROP * adsBlend);

        // inspect chamber (T toggles; loading/racking/firing all work while
        // inspecting - the port side is exactly where you manage the gun,
        // and the slot display updates live as shells go in and out)
        if (Input_GetKeyDown(Key::T)) inspectOn = !inspectOn;
        float inspTarget = inspectOn ? 1.0f : 0.0f;
        inspectBlend = MoveTowards(inspectBlend, inspTarget, 6.0f * dt);

        if (flashTimer > 0.0f) {
            flashTimer -= dt;
            if (flashTimer <= 0.0f && flashEnt != 0) {
                Material_SetBaseColor(flashEnt, flashOrigColor);
                flashEnt = 0;
            }
        }
        if (lightDecay > 0.0f && flashLight != 0) {
            lightDecay -= dt;
            Light_SetIntensity(flashLight, 25.0f * Max(lightDecay, 0.0f) / 0.6f);
        }

        if (recoilTimer > 0.0f) recoilTimer -= dt;
        UpdatePickups(dt);
        UpdateContainment(dt);
        AnimateViewmodel(dt);
    }

    // --------------------------------------------------------- viewmodel

    void SetAction(int act, float duration) {
        pendingAction = act;
        actionTimer = duration;
        actionDuration = duration;
    }

    float ActionProgress() {
        if (actionDuration <= 0.0f) return 1.0f;
        return Clamp(1.0f - actionTimer / actionDuration, 0.0f, 1.0f);
    }

    uint64 ShellEnt(int t) {
        if (t >= 0 && t < int(shellEnts.length())) return shellEnts[t];
        return 0;
    }

    void SelectShell(int t) {
        if (reserve[t] <= 0) {
            UpdateHUD("no " + ShellName(t) + " shells left - pick another");
            return;
        }
        selected = t;
        UpdateHUD("");
    }

    // When the selected type runs dry, force a switch to whatever remains.
    void EnsureSelectableAmmo() {
        if (reserve[selected] > 0) return;
        for (int i = 0; i < 3; i++) {
            if (reserve[i] > 0) {
                selected = i;
                UpdateHUD("pocket empty - switched to " + ShellName(i));
                return;
            }
        }
        UpdateHUD("pockets EMPTY - what's in the gun is all you have");
    }

    Vector3 ShellColor(int t) {
        if (t == SHELL_SLUG)   return Vector3(0.3f, 0.5f, 0.95f);
        if (t == SHELL_DRAGON) return Vector3(1.0f, 0.55f, 0.15f);
        return Vector3(0.9f, 0.25f, 0.2f);
    }

    void HideAllShells() {
        for (uint i = 0; i < shellEnts.length(); i++) {
            if (shellEnts[i] != 0) Entity_SetVisible(shellEnts[i], false);
        }
    }

    void ApplyGunVisibility() {
        bool five = (gun == GUN_FIVE);
        if (vmBarrel != 0)     Entity_SetVisible(vmBarrel, five);
        if (vmTube != 0)       Entity_SetVisible(vmTube, five);
        if (vmForend != 0)     Entity_SetVisible(vmForend, five);
        if (vmTwoBarrels != 0) Entity_SetVisible(vmTwoBarrels, !five);
        HideAllShells();
        for (uint i = 0; i < hullEnts.length(); i++) {
            if (hullEnts[i] != 0) Entity_SetVisible(hullEnts[i], false);
        }
        for (uint i = 0; i < slotEnts.length(); i++) {
            if (slotEnts[i] != 0) Entity_SetVisible(slotEnts[i], false);
        }
        if (vmTwoBarrels != 0) Entity_SetRotation(vmTwoBarrels, Vector3(0, 0, 0));
        if (vmForend != 0)     Entity_SetPosition(vmForend, Vector3(0.0f, -0.005f, -0.30f));
    }

    void ThrowLive(int type) {
        if (pickupEnts.length() == 0) return;
        int slot = nextPickup;
        nextPickup = (nextPickup + 1) % int(pickupEnts.length());
        uint64 pe = pickupEnts[slot];
        if (pe == 0) return;
        pickupTypes[slot] = type;
        pickupAge[slot] = 0.0f;

        // start at the ejection port in WORLD space, then it's physics' problem
        Vector3 eye = GetPosition();
        Vector3 rotDeg = Entity_GetRotation(_entityId);
        Quaternion q = Quaternion_FromEuler(Vector3(0.0f, Radians(rotDeg.y), 0.0f));
        Vector3 right = q.Rotate(Vector3(1.0f, 0.0f, 0.0f));
        Vector3 fwd = q.Rotate(Vector3(0.0f, 0.0f, -1.0f));
        Vector3 start = eye + right * 0.25f + fwd * 0.3f + Vector3(0.0f, -0.15f, 0.0f);

        Material_SetBaseColor(pe, ShellColor(type));
        Entity_SetVisible(pe, true);
        Physics_Teleport(pe, start);
        Physics_SetVelocity(pe, right * (1.2f + Random() * 0.5f)
                              + Vector3(0.0f, 2.2f, 0.0f)
                              + fwd * (0.3f + Random() * 0.3f));
    }

    void RegisterDyn(const string &in name) {
        uint64 e = Scene_FindEntity(name);
        if (e == 0) return;
        dynEnts.insertLast(e);
        dynHomes.insertLast(Entity_GetPosition(e));
    }

    void UpdateContainment(float dt) {
        containTimer += dt;
        if (containTimer < 1.0f) return;
        containTimer = 0.0f;
        for (uint i = 0; i < dynEnts.length(); i++) {
            Vector3 p = Entity_GetPosition(dynEnts[i]);
            if (p.y < -3.0f) {
                Physics_Teleport(dynEnts[i], dynHomes[i]);
            }
        }
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (pickupEnts[i] == 0 || pickupTypes[i] < 0) continue;
            Vector3 p = Entity_GetPosition(pickupEnts[i]);
            if (p.y < -3.0f) ParkPickup(i);   // fell out of the world: shell lost
        }
    }

    void ParkPickup(uint i) {
        pickupTypes[i] = -1;
        pickupAge[i] = 999.0f;
        Entity_SetVisible(pickupEnts[i], false);
        Physics_Teleport(pickupEnts[i], Vector3(20.0f + i, 0.2f, 20.0f));
    }

    void TryCatch() {
        // snatch a freshly ejected shell while it's still in the air near you
        Vector3 eye = GetPosition();
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (pickupEnts[i] == 0 || pickupTypes[i] < 0) continue;
            if (pickupAge[i] > 1.5f) continue;
            Vector3 pp = Entity_GetPosition(pickupEnts[i]);
            float dx = pp.x - eye.x;
            float dz = pp.z - eye.z;
            if (dx * dx + dz * dz < 4.0f) {
                reserve[pickupTypes[i]] += 1;
                UpdateHUD("caught the " + ShellName(pickupTypes[i]) + "!");
                Sfx("load.wav");
                ParkPickup(i);
                return;
            }
        }
    }

    bool AnyCatchable() {
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (pickupEnts[i] != 0 && pickupTypes[i] >= 0 && pickupAge[i] <= 1.5f) return true;
        }
        return false;
    }

    void UpdatePickups(float dt) {
        Vector3 eye = GetPosition();
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (pickupEnts[i] == 0 || pickupTypes[i] < 0) continue;
            pickupAge[i] += dt;
            if (pickupAge[i] <= 1.5f) continue;   // still catch-window fresh
            Vector3 pp = Entity_GetPosition(pickupEnts[i]);
            float dx = pp.x - eye.x;
            float dz = pp.z - eye.z;
            if (dx * dx + dz * dz < 0.5f) {   // walk-over pickup, ~0.7m
                reserve[pickupTypes[i]] += 1;
                UpdateHUD("picked up the " + ShellName(pickupTypes[i]));
                Sfx("load.wav");
                ParkPickup(i);
            }
        }
    }

    void EjectHull(int slot) {
        if (slot >= int(hullEnts.length()) || hullEnts[slot] == 0) return;
        hullTimer[slot] = HULL_FLIGHT;
        hullPos[slot] = Vector3(0.02f, 0.01f, -0.08f);   // ejection port
        hullVel[slot] = Vector3(0.55f + Random() * 0.2f, 0.5f, 0.15f * (Random() - 0.5f));
        Entity_SetVisible(hullEnts[slot], true);
    }

    void AnimateViewmodel(float dt) {
        if (vmRoot == 0) return;
        float p = ActionProgress();

        // root pose: hip <-> ADS, recoil kick, and the inspect turn.
        // Inspect swings the whole gun around so the ejection-port side faces
        // the camera - you read the tube like a book spine.
        float k = Max(recoilTimer, 0.0f) / RECOIL_TIME;
        float a = adsBlend;
        float ins = inspectBlend;
        Vector3 hip = Vector3(0.21f, -0.17f, -0.45f);
        // ADS: raised so the eye looks along the top of the barrel — barrel
        // sits just under the screen center line (root y + barrel offset 0.018
        // + radius 0.013 puts the barrel's top edge ~0.01 below center)
        Vector3 ads = Vector3(0.0f, -0.042f, -0.30f);
        Vector3 insp = Vector3(0.03f, -0.1f, -0.30f);
        Vector3 pos = hip + (ads - hip) * a;
        pos = pos + (insp - pos) * ins;
        pos.y += 0.01f * k;
        pos.z += 0.055f * k;
        Entity_SetPosition(vmRoot, pos);
        // Inspect turn: slot Z renders as the vertical-axis turn for these
        // camera-parented parts (slots are axis-shifted - engine bug, earmarked).
        // Positive turns the ejection-port side toward the camera. Recoil pitch
        // rides along in X (which renders correctly) so firing while inspecting
        // still kicks.
        Entity_SetRotation(vmRoot, Vector3(-6.0f * k, 0.0f, 78.0f * ins));

        // forend rack
        if (vmForend != 0 && gun == GUN_FIVE) {
            float slide = (pendingAction == 1) ? Sin(p * PI()) * 0.09f : 0.0f;
            Entity_SetPosition(vmForend, Vector3(0.0f, -0.005f, -0.30f + slide));
        }

        // break hinge
        if (vmTwoBarrels != 0 && gun == GUN_TWO) {
            float angle = broken ? BREAK_ANGLE : 0.0f;
            if (pendingAction == 3) angle = p * BREAK_ANGLE;
            else if (pendingAction == 5) angle = (1.0f - p) * BREAK_ANGLE;
            Entity_SetRotation(vmTwoBarrels, Vector3(angle, 0.0f, 0.0f));
        }

        // shell in hand during loads / chamber inspect
        HideAllShells();
        if (pendingAction == 2) {
            uint64 s = ShellEnt(pendingType);
            if (s != 0) {
                Entity_SetVisible(s, true);
                Entity_SetPosition(s, Vector3(
                    0.09f + (0.005f - 0.09f) * p,
                    -0.05f + (-0.035f + 0.05f) * p,
                    -0.05f + (-0.16f + 0.05f) * p));
            }
        } else if (pendingAction == 4) {
            uint64 s = ShellEnt(pendingType);
            if (s != 0) {
                Entity_SetVisible(s, true);
                Entity_SetPosition(s, Vector3(
                    0.03f - 0.03f * p,
                    0.09f + (0.02f - 0.09f) * p,
                    -0.20f - 0.10f * p));
            }
        }

        // (live-shell ejection is now a real physics object - see ThrowLive)

        // inspect display: chamber + tube contents as colored shells.
        // The gun is turned port-side to the camera, so these read directly.
        for (uint i = 0; i < slotEnts.length(); i++) {
            if (slotEnts[i] != 0) Entity_SetVisible(slotEnts[i], false);
        }
        if (ins > 0.3f && gun == GUN_FIVE && slotEnts.length() >= 5) {
            if (slotEnts[0] != 0 && chamber != SHELL_NONE) {
                Entity_SetVisible(slotEnts[0], true);
                Entity_SetPosition(slotEnts[0], Vector3(0.028f, 0.012f, -0.07f));
                Material_SetBaseColor(slotEnts[0],
                    chamberSpent ? Vector3(0.3f, 0.28f, 0.25f) : ShellColor(chamber));
            }
            // tube contents along the mag tube, rear (next to feed) nearest the receiver
            for (uint i = 0; i < tube.length() && i < 4; i++) {
                uint64 s = slotEnts[i + 1];
                if (s == 0) continue;
                int t = tube[tube.length() - 1 - i];
                Entity_SetVisible(s, true);
                Entity_SetPosition(s, Vector3(0.028f, -0.048f, -0.14f - 0.062f * i));
                Material_SetBaseColor(s, ShellColor(t));
            }
        }

        // spent hulls in flight (local-space arc out of the port)
        for (uint i = 0; i < hullEnts.length(); i++) {
            if (hullTimer[i] > 0.0f && hullEnts[i] != 0) {
                hullTimer[i] -= dt;
                hullVel[i].y -= 3.5f * dt;
                hullPos[i] = hullPos[i] + hullVel[i] * dt;
                Entity_SetPosition(hullEnts[i], hullPos[i]);
                if (hullTimer[i] <= 0.0f) Entity_SetVisible(hullEnts[i], false);
            } else if (hullEnts[i] != 0) {
                Entity_SetVisible(hullEnts[i], false);
            }
        }
    }

    // ------------------------------------------------------------ actions

    void FinishAction() {
        int act = pendingAction;
        pendingAction = 0;
        if (act == 1) {
            if (tube.length() > 0) {
                chamber = tube[tube.length() - 1];
                tube.removeLast();
                chamberSpent = false;
                UpdateHUD("chambered " + ShellName(chamber));
            } else {
                UpdateHUD("chamber empty, tube empty");
            }
        } else if (act == 2) {
            tube.insertLast(pendingType);
            Sfx("load.wav");
            UpdateHUD("+" + ShellName(pendingType));
            EnsureSelectableAmmo();
        } else if (act == 3) {
            broken = true;
            // spent hulls fly, live shells fall back to the pocket
            for (int h = 0; h < twoSpent && h < 2; h++) EjectHull(h);
            twoSpent = 0;
            for (uint i = 0; i < barrels.length(); i++) reserve[barrels[i]] += 1;
            barrels.resize(0);
            UpdateHUD("broken open - load (R), snap shut (F)");
        } else if (act == 4) {
            barrels.insertLast(pendingType);
            Sfx("load.wav");
            EnsureSelectableAmmo();
            if (barrels.length() >= 2) {
                SetAction(5, SNAP_TIME);
                Sfx("snap.wav");
                UpdateHUD("snapping shut...");
            } else {
                UpdateHUD("+" + ShellName(pendingType) + " - one more, or snap (F)");
            }
        } else if (act == 5) {
            broken = false;
            UpdateHUD("ready");
        }
    }

    // --------------------------------------------------------------- fire

    void TryFire() {
        if (pendingAction == 1 || pendingAction == 3 || pendingAction == 5) return;

        if (pendingAction == 2 || pendingAction == 4) {
            pendingAction = 0;
            actionTimer = 0.0f;
            reserve[pendingType] += 1;   // the shell in hand, not the current selection
            UpdateHUD("reload interrupted!");
        }

        if (gun == GUN_TWO) {
            if (broken) { UpdateHUD("snap shut first (F)"); return; }
            if (barrels.length() == 0) { Sfx("click.wav"); UpdateHUD("click. empty - break (F) + load (R)"); return; }
            int t = barrels[barrels.length() - 1];
            barrels.removeLast();
            twoSpent++;
            FireShell(t);
            return;
        }

        if (chamber == SHELL_NONE || chamberSpent) {
            Sfx("click.wav");
            UpdateHUD(chamberSpent ? "click. spent hull - pump (F)" : "click. empty - load (R) + pump (F)");
            return;
        }
        int fired = chamber;
        chamberSpent = true;
        FireShell(fired);
    }

    void FireShell(int type) {
        recoilTimer = RECOIL_TIME;

        Vector3 origin = GetPosition();
        Vector3 rotDeg = Entity_GetRotation(_entityId);
        Quaternion q = Quaternion_FromEuler(Vector3(Radians(rotDeg.x), Radians(rotDeg.y), Radians(rotDeg.z)));
        Vector3 fwd = q.Rotate(Vector3(0.0f, 0.0f, -1.0f));
        origin = origin + fwd * 0.6f;

        if (type == SHELL_SCATTER) {
            Sfx("boom.wav");
            float spread = 4.0f - 2.0f * adsBlend;   // ADS tightens the cone
            for (int i = 0; i < 8; i++) {
                float yawOff = (Random() * 2.0f - 1.0f) * spread;
                float pitchOff = (Random() * 2.0f - 1.0f) * spread;
                Quaternion jitter = Quaternion_FromEuler(Vector3(Radians(pitchOff), Radians(yawOff), 0.0f));
                Vector3 dir = q.Rotate(jitter.Rotate(Vector3(0.0f, 0.0f, -1.0f)));
                RaycastHit hit;
                if (Physics_RaycastHit(origin, dir, 60.0f, hit)) {
                    ReactToHit(hit.entity, dir, 4.0f, type, hit.point);
                }
            }
            UpdateHUD("BOOM (scatter)");
        } else {
            Sfx(type == SHELL_SLUG ? "slug.wav" : "dragon.wav");
            RaycastHit hit;
            if (Physics_RaycastHit(origin, fwd, 60.0f, hit)) {
                ReactToHit(hit.entity, fwd, type == SHELL_SLUG ? 25.0f : 6.0f, type, hit.point);
            }
            UpdateHUD(type == SHELL_SLUG ? "THUMP (slug)" : "FWOOSH (dragon)");
        }
    }

    void ReactToHit(uint64 ent, const Vector3 &in dir, float impulse, int shellType, const Vector3 &in point) {
        if (ent == 0) return;
        if (ent == vmRoot || ent == vmBarrel || ent == vmTube || ent == vmForend || ent == vmTwoBarrels) return;
        for (uint i = 0; i < shellEnts.length(); i++) if (ent == shellEnts[i]) return;
        for (uint i = 0; i < hullEnts.length(); i++) if (ent == hullEnts[i]) return;
        if (HasComponent_Rigidbody(ent)) {
            Physics_AddImpulse(ent, dir * impulse);
        }
        if (HasComponent_Material(ent)) {
            if (flashEnt != ent) {
                if (flashEnt != 0) Material_SetBaseColor(flashEnt, flashOrigColor);
                flashOrigColor = Material_GetBaseColor(ent);
                flashEnt = ent;
            }
            flashTimer = FLASH_TIME;
            if (shellType == SHELL_DRAGON)      Material_SetBaseColor(ent, Vector3(1.0f, 0.45f, 0.1f));
            else if (shellType == SHELL_SLUG)   Material_SetBaseColor(ent, Vector3(0.4f, 0.6f, 1.0f));
            else                                Material_SetBaseColor(ent, Vector3(1.0f, 0.9f, 0.3f));
        }
        if (shellType == SHELL_DRAGON && flashLight != 0) {
            Entity_SetPosition(flashLight, point + Vector3(0.0f, 0.3f, 0.0f));
            Light_SetIntensity(flashLight, 25.0f);
            lightDecay = 0.6f;
        }
    }

    // ----------------------------------------------------------- the five

    void StartPump() {
        if (chamberSpent) {
            EjectHull(0);   // the spent hull flies out of the port
            UpdateHUD("pumping (hull out)...");
        } else if (chamber != SHELL_NONE) {
            // real pump guns eject the live round too - catch it (R) or it
            // bounces away as a real object; walk over it to get it back
            ThrowLive(chamber);
            UpdateHUD("LIVE " + ShellName(chamber) + " out - CATCH IT (R)!");
        } else {
            UpdateHUD("pumping...");
        }
        chamber = SHELL_NONE;
        chamberSpent = false;
        SetAction(1, PUMP_TIME);
        Sfx("pump.wav");
    }

    void StartInsertFive() {
        if (tube.length() >= uint(TUBE_CAP)) { UpdateHUD("tube full"); return; }
        if (reserve[selected] <= 0) { EnsureSelectableAmmo(); return; }
        pendingType = selected;
        reserve[selected] -= 1;
        SetAction(2, RELOAD_TIME);
        UpdateHUD("loading " + ShellName(pendingType) + "...");
    }

    // ------------------------------------------------------------ the two

    void ToggleBreak() {
        if (!broken) {
            SetAction(3, BREAK_TIME);
            Sfx("break.wav");
            UpdateHUD("breaking open...");
        } else {
            SetAction(5, SNAP_TIME);
            Sfx("snap.wav");
            UpdateHUD("snapping shut...");
        }
    }

    void StartInsertTwo() {
        if (!broken) { UpdateHUD("break open first (F)"); return; }
        if (barrels.length() >= 2) { UpdateHUD("both barrels loaded - snap (F)"); return; }
        if (reserve[selected] <= 0) { EnsureSelectableAmmo(); return; }
        pendingType = selected;
        reserve[selected] -= 1;
        SetAction(4, BARREL_TIME);
        UpdateHUD("loading " + ShellName(pendingType) + "...");
    }

    // --------------------------------------------------------------- swap

    void SwapGun() {
        if (chamber != SHELL_NONE && !chamberSpent) reserve[chamber] += 1;
        chamber = SHELL_NONE; chamberSpent = false;
        for (uint i = 0; i < tube.length(); i++) reserve[tube[i]] += 1;
        tube.resize(0);
        for (uint i = 0; i < barrels.length(); i++) reserve[barrels[i]] += 1;
        barrels.resize(0);
        broken = false;
        twoSpent = 0;

        gun = (gun == GUN_FIVE) ? GUN_TWO : GUN_FIVE;
        ApplyGunVisibility();
        Sfx("snap.wav");
        UpdateHUD(gun == GUN_FIVE ? "THE FIVE - load (R) + pump (F)" : "THE TWO - break (F), load two, snap");
    }

    // ---------------------------------------------------------------- hud

    string ShellName(int t) {
        if (t == SHELL_SCATTER) return "SCT";
        if (t == SHELL_SLUG)    return "SLG";
        if (t == SHELL_DRAGON)  return "DRG";
        return "---";
    }

    void UpdateHUD(const string &in note) {
        if (hudEnt == 0) return;
        string s;
        if (gun == GUN_FIVE) {
            s = "THE FIVE | CHAMBER: ";
            if (chamber == SHELL_NONE)  s += "empty";
            else if (chamberSpent)      s += "spent hull";
            else                        s += ShellName(chamber);
            s += "  TUBE(mouth->): ";
            for (int i = int(tube.length()) - 1; i >= 0; i--) s += "[" + ShellName(tube[i]) + "]";
            for (uint i = tube.length(); i < uint(TUBE_CAP); i++) s += "[   ]";
        } else {
            s = "THE TWO | ";
            s += broken ? "OPEN" : "SHUT";
            s += "  BARRELS: ";
            for (int i = int(barrels.length()) - 1; i >= 0; i--) s += "[" + ShellName(barrels[i]) + "]";
            for (uint i = barrels.length(); i < 2; i++) s += "[   ]";
        }
        s += "  LOAD: " + ShellName(selected)
          + "  pocket: SCT x" + reserve[SHELL_SCATTER]
          + " SLG x" + reserve[SHELL_SLUG]
          + " DRG x" + reserve[SHELL_DRAGON];
        if (note.length() > 0) s += "\n" + note;
        HUD_SetText(hudEnt, s);
    }
}

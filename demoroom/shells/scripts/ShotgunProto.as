// PROTOTYPE - NOT FOR PRODUCTION
// Question: does FILO shell-order reloading (interruptible, type-selective) feel like a puzzle?
// Date: 2026-07-26 (v5: two-stage port-load into the chamber via half-rack; v4 had ADS, chamber inspect, typed shell models, spent hull ejection)
#include "TegeBehavior.as"
//
// Controls:
//   LMB       fire
//   RMB hold  aim down sights (tighter scatter spread + zoom)
//   T toggle  inspect: turn the gun port-side to read the chamber/tube
//   R         load one shell of the selected type (into the TUBE)
//   F         pump. In T pose it's a two-stage rack: F half-cocks the action
//             open, F again closes it. Outside T pose F is the normal full
//             cycle. If the action is open, F always closes it.
//   E         interact: tap catches an airborne live shell to the pocket;
//             HOLD after the catch to wind up a throw (arc preview with
//             ricochets grows the longer you hold, release hurls it - then
//             shoot it). Near a shopkeep with nothing to catch, E starts the
//             conversation (then E/LMB advances, 1/2/3 pick choices).
//             Live shells on the ground or in flight DETONATE when shot:
//             scatter = pellet burst, slug = mirror-angle bank shot,
//             dragon = fireball (chains nearby live shells). Barrels blow up
//             big and chain to each other.
//   G toggle  grab/carry: pick up the nearest loose prop (cage, bowl, pot),
//             carry it in front of you, G again to drop. One-handed friendly.
//   Q toggle  bullet time: drains a meter, refills when off. Cycling a LIVE
//             round out of the gun auto-dilates time for free so you can catch
//             it (E) as it flies - the shell itself lights up in the air.
//   1/2/3     normal: select shell type (SCATTER / SLUG / DRAGON)
//             half-cocked open (T then F): PORT-LOAD that type straight into
//             the chamber, bypassing the tube.

const int SHELL_NONE    = -1;
const int SHELL_SCATTER = 0;
const int SHELL_SLUG    = 1;
const int SHELL_DRAGON  = 2;

const int   TUBE_CAP      = 4;
const float RELOAD_TIME   = 0.7f;
const float PUMP_TIME     = 0.45f;
const float FLASH_TIME    = 0.2f;
const float RECOIL_TIME   = 0.12f;
const float ADS_FOV_DROP  = 14.0f;
const float HULL_FLIGHT   = 0.7f;   // seconds a spent hull stays visible
const float CATCH_TAP     = 0.25f;  // E released within this = pocket the catch
const float CATCH_WINDOW  = 1.5f;   // a live shell is catchable/glowing this long
const float CHARGE_TIME   = 1.2f;   // hold past the tap this long for max range
const float THROW_MIN     = 4.0f;   // throw speed at minimum windup
const float THROW_MAX     = 14.0f;  // throw speed at full windup
const float DET_RADIUS    = 2.5f;   // dragon shell blast radius

// bullet time / dilation
const float BT_SLOW       = 0.30f;  // global timescale while slowed
const float BT_DRAIN      = 0.50f;  // manual meter drain per real second
const float BT_REFILL     = 0.25f;  // meter refill per real second when off
const float CATCH_DILATE  = 1.10f;  // free slow-mo window (real sec) on live eject

// grab/carry
const float GRAB_REACH    = 1.9f;   // hold point distance in front of the eye
const float GRAB_PROBE    = 1.4f;   // overlap radius when looking for something to grab

// shopkeeps
const float NPC_RANGE     = 3.6f;   // how close you get before "talk" lights up

// exploding barrels
const float BARREL_RADIUS  = 4.5f;
const float BARREL_IMPULSE = 22.0f;

// jobs (help the businesses)
const int JOB_NOODLE = 0;   // shoo the pest, boil the pot (dragon)
const int JOB_RANGE  = 1;   // knock every stuck ball loose
const int JOB_HOTEL  = 2;   // herd the strays into the stalls
const int JOB_COUNT  = 3;
const int JOB_PAY    = 15;  // dollars per job done
const float SHOO_RADIUS  = 2.2f;   // a scatter pellet within this shoos a critter
const float PEN_RADIUS    = 2.5f;   // a stray inside this of the pen counts as home
const float PEST_GONE_D2  = 36.0f;  // pest this far (squared) from home = scattered off
const float SCURRY_SPEED  = 0.9f;   // critters are always scurrying at this speed
const float SCURRY_PEN    = 0.12f;  // a stray that's home settles down to this

class ShotgunProto : TegeBehavior {
    // The Five (the only gun now - anything smaller got scrapped)
    array<int> tube;
    int   chamber = SHELL_NONE;
    bool  chamberSpent = false;

    // Shared
    int   selected = SHELL_SCATTER;
    int   pendingType = SHELL_SCATTER;   // type locked in when a load starts
    array<int> reserve = {10, 5, 5};

    float actionTimer = 0.0f;
    float actionDuration = 1.0f;
    int   pendingAction = 0;    // 0 none, 1 pump, 2 insert(five), 3 break, 4 insert(two), 5 snap, 6 port-load(five)
    bool  fiveOpen = false;     // the Five is half-racked (side pose): port-load enabled, can't fire

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
    array<uint64> shellEnts;    // [SCT, SLG, DRG]
    array<uint64> hullEnts;     // 2 ejectable spent hulls
    array<Vector3> hullPos;
    array<Vector3> hullVel;
    array<float> hullTimer;
    float  recoilTimer = 0.0f;
    float  adsBlend = 0.0f;
    float  inspectBlend = 0.0f;
    float  rackBlend = 0.0f;    // 0 forend forward (closed) -> 1 held back (half-racked)
    bool   inspectOn = false;
    float  baseFov = 0.0f;

    // inspect display: chamber + 4 tube slots (runtime-colored generic shells)
    array<uint64> slotEnts;
    // world-space dropped shells (real physics bodies), walk over to collect
    array<uint64> pickupEnts;
    array<int> pickupTypes;
    array<float> pickupAge;
    // pickups are typed prefab instances: slots [type*2, type*2+1] per shell
    // type; the toggle alternates within each bank
    array<int> bankToggle = {0, 0, 0};
    uint64 catchTagEnt = 0;   // world-space "CATCH W/ E" label

    // catch-and-throw: a caught shell sits in hand while E is held; tap
    // pockets it, holding winds up a throw with a live arc preview
    int   heldShell = SHELL_NONE;
    float eCharge = 0.0f;
    array<uint64> arcDots;

    // containment: dynamic props that fall below the world get sent home
    array<uint64> dynEnts;
    array<Vector3> dynHomes;
    float  containTimer = 0.0f;

    // grab/carry: one loose prop held in front of the player at a time
    uint64 carried = 0;

    // bullet time + auto dilation on a live-round cycle
    float  btMeter = 1.0f;      // 0..1 real-time budget
    bool   btActive = false;    // manual toggle
    float  catchDilate = 0.0f;  // free slow-mo window (real sec) after a live eject
    float  curScale = 1.0f;     // last timescale we set (to recover real dt)

    // shopkeeps: NPC entities carrying a DialogueComponent tree
    array<uint64> npcs;
    uint64 activeNpc = 0;
    bool   nearNpc = false;         // in range of a shopkeep right now (drives the prompt)
    uint64 controllerEnt = 0;       // the FirstPersonController entity (Capsule), locked while talking

    // exploding barrels (found by the "Barrel" name prefix)
    array<uint64> barrelEnts;
    array<bool>   barrelDead;

    // particle FX pool (FX0..): repositioned + burst at muzzles, impacts, blasts.
    // Emitters stay PLAYING at rate 0; a burst ramps the rate up for a brief
    // window (fxStop) then back to 0, so spawned particles age out naturally
    // (stopping the emitter would freeze them instead).
    array<uint64> fxEnts;
    array<float>  fxStop;
    uint fxNext = 0;

    // jobs: the reason you're in town
    array<uint64> jobNpc;       // [noodle, range, hotel] -> the owner to thank
    array<uint64> jobSign;      // sign to light green when the job is done
    array<int>    jobStatus;    // 0 idle, 1 active, 2 done
    int money = 0;

    // noodle job
    uint64 noodlePot = 0;
    bool   potBoiled = false;
    bool   pestGone = false;
    uint64 pestEnt = 0;
    Vector3 pestHome;

    // range job (knock every stuck ball loose)
    array<uint64> ballEnts;
    array<bool>   ballLoose;

    // hotel job (herd strays into the pen)
    array<uint64> strayEnts;
    Vector3 penCenter;

    // every critter (pest + strays) scurries continuously so it reads as alive
    array<uint64> critterEnts;
    array<bool>   critterIsStray;
    array<float>  critterHeading;   // current wander heading (radians)
    array<float>  critterRepick;    // seconds until it picks a new heading
    array<float>  critterFlee;      // >0: recently shooed, let the impulse carry

    // HUD: a live tracker plus a transient note that fades
    string pendingNote = "";
    float  noteTimer = 0.0f;

    void OnStart() {
        hudEnt = Scene_FindEntity("HUD_Tube");
        flashLight = Scene_FindEntity("DragonFlash");
        vmRoot       = Scene_FindEntity("VM_Root");
        vmBarrel     = Scene_FindEntity("VM_Barrel");
        vmTube       = Scene_FindEntity("VM_Tube");
        vmForend     = Scene_FindEntity("VM_Forend");
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
        // The old floating "CATCH W/ E" label is retired: the catch cue is now the
        // auto time-dilation on a live eject plus the main HUD line. Keep it dark.
        catchTagEnt = Scene_FindEntity("HUD_CatchTag");
        if (catchTagEnt != 0) { HUD_SetSourceEntity(catchTagEnt, 0); HUD_SetText(catchTagEnt, ""); }
        for (int i = 0; i < 24; i++) {
            uint64 ad = Scene_FindEntity("ArcDot" + i);
            arcDots.insertLast(ad);
            if (ad != 0) Entity_SetVisible(ad, false);
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

        // exploding barrels: kept out of the containment list so a spent one
        // stays gone instead of being re-homed
        for (int i = 0; i < 8; i++) {
            uint64 be = Scene_FindEntity("Barrel" + i);
            if (be == 0) break;
            barrelEnts.insertLast(be);
            barrelDead.insertLast(false);
        }

        // particle FX pool: keep each emitter looping + playing at rate 0
        for (int i = 0; i < 16; i++) {
            uint64 fe = Scene_FindEntity("FX" + i);
            if (fe == 0) break;
            fxEnts.insertLast(fe);
            fxStop.insertLast(0.0f);
            Particle_SetLoop(fe, true);
            Particle_SetEmissionRate(fe, 0.0f);
            Particle_Play(fe);
        }

        // shopkeeps
        RegisterNpc("NPC_Cook");
        RegisterNpc("NPC_Keeper");
        RegisterNpc("NPC_Pro");

        // jobs: owner to thank + sign to light, one per venue
        jobNpc.insertLast(Scene_FindEntity("NPC_Cook"));    // noodle
        jobNpc.insertLast(Scene_FindEntity("NPC_Pro"));     // range
        jobNpc.insertLast(Scene_FindEntity("NPC_Keeper"));  // hotel
        jobSign.insertLast(Scene_FindEntity("Noodle_Sign"));
        jobSign.insertLast(Scene_FindEntity("Range_Board100"));
        jobSign.insertLast(Scene_FindEntity("Hotel_Sign"));
        for (int i = 0; i < JOB_COUNT; i++) jobStatus.insertLast(0);

        // noodle job targets
        noodlePot = Scene_FindEntity("Noodle_Pot0");
        pestEnt = Scene_FindEntity("Critter_Pest");
        pestHome = (pestEnt != 0) ? Entity_GetPosition(pestEnt) : Vector3(-15.0f, 0.2f, -14.0f);
        if (pestEnt != 0) RegisterDyn("Critter_Pest");

        // range job: the golf balls, knocked out into the traps to start
        for (int i = 0; i < 6; i++) {
            uint64 b = Scene_FindEntity("Range_Ball" + i);
            if (b == 0) break;
            ballEnts.insertLast(b);
            ballLoose.insertLast(false);
        }
        ScatterBallsIntoTraps();

        // hotel job: the strays and the pen they belong in
        for (int i = 0; i < 3; i++) {
            uint64 s = Scene_FindEntity("Critter_Stray" + i);
            if (s != 0) { strayEnts.insertLast(s); RegisterDyn("Critter_Stray" + i); }
        }
        penCenter = Vector3(15.0f, 0.2f, -16.0f);

        // every critter scurries; build the combined list (pest first, then strays)
        if (pestEnt != 0) AddCritter(pestEnt, false);
        for (uint i = 0; i < strayEnts.length(); i++) AddCritter(strayEnts[i], true);

        // legible HUD: modest font, warm high-contrast text (box widened in-scene)
        if (hudEnt != 0) {
            HUD_SetFontSize(hudEnt, 30.0f);
            HUD_SetTextColor(hudEnt, 1.0f, 0.96f, 0.85f);
        }

        // the movement/look controller lives on the Capsule, not this camera;
        // we lock it while a conversation is up. Make sure it starts unlocked
        // (play-mode state can persist across runs in this engine).
        controllerEnt = Scene_FindEntity("Capsule");
        if (controllerEnt != 0) Controller_SetEnabled(controllerEnt, true);
        // (subtitles are turned off at the source in the pak manifest - PlayMode
        // re-applies that to the subtitle system every frame, so a script call here
        // would just get overwritten. The native DialogueBox is the one caption.)

        // start at real time (timescale is global and persists across play)
        curScale = 1.0f;
        Time_SetTimeScale(1.0f);

        tube.insertLast(SHELL_SCATTER);
        tube.insertLast(SHELL_SCATTER);
        reserve[SHELL_SCATTER] -= 2;
        ApplyGunVisibility();
        UpdateHUD("pump to chamber (F)   [T+F half-cocks, 1/2/3 port-loads, G grabs, Q bullet-time, RMB aims]");
        Debug_Log("[ShotgunProto v6] The Five only. F pump (T+F half-cock), R load, G grab, Q bullet-time, E catch/talk, 1/2/3 select or port-load");
    }

    void RegisterNpc(const string &in name) {
        uint64 e = Scene_FindEntity(name);
        if (e != 0) npcs.insertLast(e);
    }

    void Sfx(const string &in name) {
        Audio_PlayAtPosition("assets/sfx/" + name, GetPosition());
    }

    void OnUpdate(float dt) {
        // a shopkeep conversation owns the screen while it's up. The engine's
        // native dialogue box renders it and handles advance/choose input itself
        // (Space/Enter/LMB advance, W/S or arrows + Enter pick a choice). We just
        // freeze the gun and wait for the tree to finish.
        if (activeNpc != 0) {
            if (Dialogue_IsActive(activeNpc)) return;
            OnTalkEnded(activeNpc);
            activeNpc = 0;
        }

        // bullet time / auto-dilation runs first so the rest of the frame uses
        // the slowed dt (gun and animations slow with the world; input doesn't)
        UpdateTimeDilation(dt);

        if (Input_GetKeyDown(Key::Q)) ToggleBulletTime();
        if (Input_GetKeyDown(Key::G)) ToggleGrab();

        if (Input_GetKeyDown(Key::Num1)) ShellKey(SHELL_SCATTER);
        if (Input_GetKeyDown(Key::Num2)) ShellKey(SHELL_SLUG);
        if (Input_GetKeyDown(Key::Num3)) ShellKey(SHELL_DRAGON);

        if (actionTimer > 0.0f) {
            actionTimer -= dt;
            if (actionTimer <= 0.0f) FinishAction();
        }

        if (Input_GetMouseButtonDown(MouseBtn::Left)) TryFire();

        if (Input_GetKeyDown(Key::F) && actionTimer <= 0.0f) FiveRack();

        if (Input_GetKeyDown(Key::R) && actionTimer <= 0.0f) StartInsertFive();

        // E = interact. Tap catches an airborne live shell into the pocket.
        // Hold E after the catch to wind up a throw instead: an arc preview
        // (with ricochet bounces) reaches farther the longer you hold, and
        // release hurls the shell so you can shoot it at distance.
        // With nothing to catch, E by a shopkeep opens the conversation.
        if (Input_GetKeyDown(Key::E) && heldShell == SHELL_NONE) {
            heldShell = CatchToHand();
            eCharge = 0.0f;
            if (heldShell == SHELL_NONE) {
                uint64 npc = NearestNpcInRange();
                if (npc != 0) StartTalk(npc);
            }
        }
        if (heldShell != SHELL_NONE) {
            if (Input_GetKey(Key::E)) {
                eCharge += dt;
                if (eCharge > CATCH_TAP) UpdateThrowArc();
            }
            if (Input_GetKeyUp(Key::E)) {
                if (eCharge <= CATCH_TAP) {
                    reserve[heldShell] += 1;
                    Sfx("load.wav");
                    UpdateHUD("caught the " + ShellName(heldShell) + "!");
                } else {
                    ThrowHeld();
                }
                heldShell = SHELL_NONE;
                HideArc();
            }
        }

        // aim down sights (hold RMB)
        float adsTarget = Input_GetMouseButton(MouseBtn::Right) ? 1.0f : 0.0f;
        adsBlend = MoveTowards(adsBlend, adsTarget, 8.0f * dt);
        if (baseFov > 0.0f) Camera_SetFOV(_entityId, baseFov - ADS_FOV_DROP * adsBlend);

        // inspect chamber (T toggles; loading/racking/firing all work while
        // inspecting - the port side is exactly where you manage the gun,
        // and the slot display updates live as shells go in and out)
        if (Input_GetKeyDown(Key::T)) {
            inspectOn = !inspectOn;
            if (inspectOn && !fiveOpen) {
                UpdateHUD("side pose - half-cock (F) to open the port");
            }
        }
        float inspTarget = inspectOn ? 1.0f : 0.0f;
        inspectBlend = MoveTowards(inspectBlend, inspTarget, 6.0f * dt);

        // half-rack: the forend is held back partway while the action is open
        float rackTarget = fiveOpen ? 1.0f : 0.0f;
        rackBlend = MoveTowards(rackBlend, rackTarget, 9.0f * dt);

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
        UpdateCarry(dt);
        UpdateNpcPrompt();
        UpdateJobs(dt);
        UpdateFX(dt);
        UpdateContainment(dt);
        AnimateViewmodel(dt);
        if (noteTimer > 0.0f) noteTimer -= dt;
        RefreshHUD();
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
        if (vmBarrel != 0) Entity_SetVisible(vmBarrel, true);
        if (vmTube != 0)   Entity_SetVisible(vmTube, true);
        if (vmForend != 0) Entity_SetVisible(vmForend, true);
        HideAllShells();
        for (uint i = 0; i < hullEnts.length(); i++) {
            if (hullEnts[i] != 0) Entity_SetVisible(hullEnts[i], false);
        }
        for (uint i = 0; i < slotEnts.length(); i++) {
            if (slotEnts[i] != 0) Entity_SetVisible(slotEnts[i], false);
        }
        if (vmForend != 0) Entity_SetPosition(vmForend, Vector3(0.0f, -0.005f, -0.30f));
    }

    // put a live shell into the world from this type's bank so it has the
    // right prefab silhouette; prefer a free slot, else recycle the toggle's
    int LaunchPickup(int type, const Vector3 &in start, const Vector3 &in vel, float age) {
        if (pickupEnts.length() < 6) return -1;
        int slot = type * 2;
        if (pickupTypes[slot] >= 0 && pickupTypes[slot + 1] < 0) slot += 1;
        else if (pickupTypes[slot] >= 0) { slot += bankToggle[type]; bankToggle[type] = 1 - bankToggle[type]; }
        uint64 pe = pickupEnts[slot];
        if (pe == 0) return -1;
        pickupTypes[slot] = type;
        pickupAge[slot] = age;
        Entity_SetVisible(pe, true);
        Physics_Teleport(pe, start);
        Physics_SetVelocity(pe, vel);
        return slot;
    }

    void ThrowLive(int type) {
        // ejected out the port in WORLD space, then it's physics' problem.
        // Uses the horizontal (yaw-only) basis so the shell arcs out sideways
        // regardless of where the player is pitching the view.
        Vector3 eye = GetPosition();
        Vector3 right = Entity_GetRight(_entityId);   // horizontal for a yaw*pitch camera
        Vector3 fwd = Entity_GetForward(_entityId);
        fwd.y = 0.0f;
        float fl = fwd.Length();
        fwd = (fl > 0.01f) ? fwd * (1.0f / fl) : Vector3(0.0f, 0.0f, -1.0f);
        Vector3 start = eye + right * 0.25f + fwd * 0.3f + Vector3(0.0f, -0.15f, 0.0f);
        LaunchPickup(type, start,
            right * (1.2f + Random() * 0.5f) + Vector3(0.0f, 2.2f, 0.0f) + fwd * (0.3f + Random() * 0.3f),
            0.0f);
        // cycling a LIVE round is the hero moment: dilate time (free) so the
        // player can read the glowing shell in the air and snatch it with E
        catchDilate = CATCH_DILATE;
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

    // snatch a freshly ejected shell out of the air into the hand; the E
    // handler decides whether it gets pocketed (tap) or thrown (hold)
    int CatchToHand() {
        Vector3 eye = GetPosition();
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (pickupEnts[i] == 0 || pickupTypes[i] < 0) continue;
            if (pickupAge[i] > 1.5f) continue;
            Vector3 pp = Entity_GetPosition(pickupEnts[i]);
            float dx = pp.x - eye.x;
            float dz = pp.z - eye.z;
            if (dx * dx + dz * dz < 4.0f) {
                int t = pickupTypes[i];
                ParkPickup(i);
                UpdateHUD("snagged the " + ShellName(t) + " - hold E to wind a throw");
                return t;
            }
        }
        return SHELL_NONE;
    }

    Vector3 AimDir() {
        return Entity_GetForward(_entityId);
    }

    float ThrowSpeed() {
        float t = Clamp((eCharge - CATCH_TAP) / CHARGE_TIME, 0.0f, 1.0f);
        return THROW_MIN + (THROW_MAX - THROW_MIN) * t;
    }

    void ThrowHeld() {
        Vector3 dir = AimDir();
        Vector3 start = GetPosition() + dir * 0.4f + Vector3(0.0f, -0.08f, 0.0f);
        // age past the catch window: a thrown shell is committed, it lands as
        // a walk-over pickup (or gets shot out of the air)
        LaunchPickup(heldShell, start, dir * ThrowSpeed() + Vector3(0.0f, 1.2f, 0.0f), 2.0f);
        Sfx("snap.wav");
        UpdateHUD("hurled the " + ShellName(heldShell) + " - shoot it!");
    }

    // simulate the throw and lay dots along it, bouncing off surfaces the
    // way the shell will, so ricochet placements are aimable
    void UpdateThrowArc() {
        if (arcDots.length() == 0) return;
        Vector3 dir = AimDir();
        Vector3 p = GetPosition() + dir * 0.4f + Vector3(0.0f, -0.08f, 0.0f);
        Vector3 v = dir * ThrowSpeed() + Vector3(0.0f, 1.2f, 0.0f);
        Vector3 col = ShellColor(heldShell);
        float h = 0.03f;           // fine step so bounce points land accurately
        uint dot = 0;
        int bounces = 0;
        for (int step = 0; step < 140 && dot < arcDots.length(); step++) {
            v.y -= 9.81f * h;
            Vector3 np = p + v * h;
            Vector3 seg = np - p;
            float len = seg.Length();
            RaycastHit hit;
            if (len > 0.0001f && Physics_RaycastHit(p, seg * (1.0f / len), len, hit)) {
                // physical bounce: tangential velocity survives, the normal
                // component reflects scaled by the pickup's bounciness
                float vd = v.x * hit.normal.x + v.y * hit.normal.y + v.z * hit.normal.z;
                v = v - hit.normal * (vd * 1.45f);            // 1 + restitution 0.45
                np = hit.point + hit.normal * 0.02f;          // step off the surface
                bounces++;
                if (bounces > 4) break;
            }
            p = np;
            if (v.Length() < 0.8f) break;   // rolling to a stop - arc over
            if (step % 5 == 0) {
                uint64 e = arcDots[dot];
                if (e != 0) {
                    Entity_SetVisible(e, true);
                    Entity_SetPosition(e, p);
                    Material_SetBaseColor(e, col);
                }
                dot++;
            }
        }
        for (; dot < arcDots.length(); dot++) {
            if (arcDots[dot] != 0) Entity_SetVisible(arcDots[dot], false);
        }
    }

    void HideArc() {
        for (uint i = 0; i < arcDots.length(); i++) {
            if (arcDots[i] != 0) Entity_SetVisible(arcDots[i], false);
        }
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

    // (the live-round catch cue is now the auto time-dilation + the HUD line;
    // the glowing shell halo was removed - it didn't look good)

    void UpdateNpcPrompt() {
        nearNpc = (NearestNpcInRange() != 0);   // RefreshHUD shows the [E] talk prompt
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

        // forend rack: full pump is an arc back-and-forward; the half-rack holds
        // the forend back at roughly half travel while the action stays open.
        if (vmForend != 0) {
            float pumpSlide = (pendingAction == 1) ? Sin(p * PI()) * 0.09f : 0.0f;
            float halfSlide = rackBlend * 0.05f;
            float slide = Max(pumpSlide, halfSlide);
            Entity_SetPosition(vmForend, Vector3(0.0f, -0.005f, -0.30f + slide));
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
        } else if (pendingAction == 6) {
            // drop into the ejection port; ends at the chamber slot position
            uint64 s = ShellEnt(pendingType);
            if (s != 0) {
                Entity_SetVisible(s, true);
                Entity_SetPosition(s, Vector3(
                    0.06f + (0.028f - 0.06f) * p,
                    0.04f + (0.012f - 0.04f) * p,
                    -0.04f + (-0.07f + 0.04f) * p));
            }
        } else if (heldShell != SHELL_NONE) {
            // caught shell sits in the off-hand; winds forward as the throw charges
            uint64 s = ShellEnt(heldShell);
            if (s != 0) {
                float w = Clamp((eCharge - CATCH_TAP) / CHARGE_TIME, 0.0f, 1.0f);
                Entity_SetVisible(s, true);
                Entity_SetPosition(s, Vector3(-0.07f, -0.06f + 0.02f * w, -0.20f - 0.07f * w));
            }
        }

        // (live-shell ejection is now a real physics object - see ThrowLive)

        // inspect display: chamber + tube contents as colored shells.
        // The gun is turned port-side to the camera, so these read directly.
        for (uint i = 0; i < slotEnts.length(); i++) {
            if (slotEnts[i] != 0) Entity_SetVisible(slotEnts[i], false);
        }
        if (ins > 0.3f && slotEnts.length() >= 5) {
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
        } else if (act == 6) {
            // port-loaded straight into the chamber; still open, close (T) to fire
            chamber = pendingType;
            chamberSpent = false;
            Sfx("load.wav");
            UpdateHUD(ShellName(pendingType) + " in chamber - close (F) to fire");
            EnsureSelectableAmmo();
        }
    }

    // --------------------------------------------------------------- fire

    void TryFire() {
        if (pendingAction == 1 || pendingAction == 6) return;

        if (pendingAction == 2) {
            pendingAction = 0;
            actionTimer = 0.0f;
            reserve[pendingType] += 1;   // the shell in hand, not the current selection
            UpdateHUD("reload interrupted!");
        }

        if (fiveOpen) {
            Sfx("click.wav");
            UpdateHUD("action open - close first (F)");
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

        // aim basis straight from the camera quaternion - the euler roundtrip
        // (Entity_GetRotation -> Quaternion_FromEuler) drifted near yaw +/-90
        Vector3 fwd = Entity_GetForward(_entityId);
        Vector3 right = Entity_GetRight(_entityId);
        Vector3 up = Entity_GetUp(_entityId);
        Vector3 origin = GetPosition() + fwd * 0.6f;
        MuzzleFX(type, origin + fwd * 0.3f);   // spit sparks off the muzzle

        if (type == SHELL_SCATTER) {
            Sfx("boom.wav");
            float spread = 4.0f - 2.0f * adsBlend;   // ADS tightens the cone
            for (int i = 0; i < 8; i++) {
                float yawOff = Radians((Random() * 2.0f - 1.0f) * spread);
                float pitchOff = Radians((Random() * 2.0f - 1.0f) * spread);
                Vector3 dir = (fwd + right * Sin(yawOff) + up * Sin(pitchOff)).Normalized();
                RaycastHit hit;
                if (Physics_RaycastHit(origin, dir, 60.0f, hit)) {
                    ReactToHit(hit.entity, dir, 4.0f, type, hit.point);
                    ShooCrittersNear(hit.point);   // scatter behind a critter herds it
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
        if (ent == vmRoot || ent == vmBarrel || ent == vmTube || ent == vmForend) return;
        for (uint i = 0; i < shellEnts.length(); i++) if (ent == shellEnts[i]) return;
        for (uint i = 0; i < hullEnts.length(); i++) if (ent == hullEnts[i]) return;
        // shooting a live shell (ground or airborne) sets it off
        for (uint i = 0; i < pickupEnts.length(); i++) {
            if (ent == pickupEnts[i] && pickupTypes[i] >= 0) {
                DetonateShell(i, dir);
                return;
            }
        }
        // shooting a barrel sets off a big radial blast that chains
        for (uint i = 0; i < barrelEnts.length(); i++) {
            if (ent == barrelEnts[i] && !barrelDead[i]) {
                DetonateBarrel(i);
                return;
            }
        }
        // noodle job: the cold pot wants a dragon shell to light it
        if (ent == noodlePot && jobStatus.length() > JOB_NOODLE && jobStatus[JOB_NOODLE] == 1) {
            if (shellType == SHELL_DRAGON) {
                if (!potBoiled) {
                    potBoiled = true;
                    Material_SetBaseColor(noodlePot, Vector3(1.0f, 0.5f, 0.15f));
                    UpdateHUD(pestGone ? "the pot's boiling!" : "pot's lit - now shoo the pest (scatter)");
                }
            } else {
                UpdateHUD("the pot needs FIRE - load a dragon shell (press 3)");
            }
            return;   // don't knock the job pot around
        }
        // range job: knock each stuck ball loose (then let it fly as normal)
        for (uint i = 0; i < ballEnts.length(); i++) {
            if (ent == ballEnts[i]) {
                if (jobStatus.length() > JOB_RANGE && jobStatus[JOB_RANGE] == 1 && !ballLoose[i])
                    ballLoose[i] = true;
                break;
            }
        }
        ImpactFX(shellType, point);   // sparks where the shot lands
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

    // shot shells cook off by type: scatter bursts pellets everywhere, slug
    // banks the shot at the mirror angle, dragon detonates in a fireball
    // right-handed cross product, for building an aim basis from a direction
    Vector3 CrossV(const Vector3 &in a, const Vector3 &in b) {
        return Vector3(a.y * b.z - a.z * b.y,
                       a.z * b.x - a.x * b.z,
                       a.x * b.y - a.y * b.x);
    }

    // ----------------------------------------------------------- particle FX

    // grab a pooled emitter, colour + size it, and puff ~count particles at pos
    void SpawnFX(const Vector3 &in pos, float r, float g, float b, int count, float speed, float size) {
        if (fxEnts.length() == 0) return;
        uint idx = fxNext;
        fxNext = (fxNext + 1) % fxEnts.length();
        uint64 e = fxEnts[idx];
        if (e == 0) return;
        Entity_SetPosition(e, pos);
        Particle_SetColor(e, r, g, b, r * 0.5f, g * 0.35f, b * 0.25f);
        Particle_SetSize(e, size, size * 0.1f);
        Particle_SetSpeed(e, speed);
        Particle_SetEmissionRate(e, float(count) * 22.0f);   // ~count over the 0.045s window
        fxStop[idx] = 0.045f;
    }

    // ramp finished emitters back to rate 0 (particles keep aging out)
    void UpdateFX(float dt) {
        for (uint i = 0; i < fxEnts.length(); i++) {
            if (fxStop[i] <= 0.0f) continue;
            fxStop[i] -= dt;
            if (fxStop[i] <= 0.0f && fxEnts[i] != 0) Particle_SetEmissionRate(fxEnts[i], 0.0f);
        }
    }

    void MuzzleFX(int type, const Vector3 &in pos) {
        if (type == SHELL_SLUG)        SpawnFX(pos, 0.7f, 0.85f, 1.0f, 10, 6.0f, 0.10f);
        else if (type == SHELL_DRAGON) SpawnFX(pos, 1.0f, 0.5f, 0.15f, 18, 4.5f, 0.16f);
        else                           SpawnFX(pos, 1.0f, 0.75f, 0.35f, 12, 5.5f, 0.11f);
    }

    void ImpactFX(int type, const Vector3 &in pos) {
        if (type == SHELL_SLUG)        SpawnFX(pos, 0.7f, 0.85f, 1.0f, 6, 4.0f, 0.09f);
        else if (type == SHELL_DRAGON) SpawnFX(pos, 1.0f, 0.5f, 0.15f, 10, 3.5f, 0.13f);
        else                           SpawnFX(pos, 1.0f, 0.8f, 0.4f, 6, 4.5f, 0.08f);
    }

    void DetonateShell(uint slot, const Vector3 &in dir) {
        int type = pickupTypes[slot];
        if (type < 0) return;
        Vector3 pos = Entity_GetPosition(pickupEnts[slot]);
        ParkPickup(slot);   // consume FIRST so chain reactions can't loop

        if (type == SHELL_SCATTER) {
            Sfx("boom.wav");
            SpawnFX(pos, 1.0f, 0.8f, 0.4f, 14, 5.0f, 0.12f);
            // fire the spread ALONG the shot that set it off, not randomly - so a
            // clean slug hit redirects the shell's blast exactly where you aimed
            Vector3 fwd = dir.Normalized();
            Vector3 axis = (fwd.y > 0.9f || fwd.y < -0.9f) ? Vector3(1.0f, 0.0f, 0.0f)
                                                           : Vector3(0.0f, 1.0f, 0.0f);
            Vector3 right = CrossV(fwd, axis).Normalized();
            Vector3 up = CrossV(right, fwd).Normalized();
            float spread = 0.26f;   // cone half-width around the aim line
            for (int i = 0; i < 10; i++) {
                float rx = (Random() * 2.0f - 1.0f) * spread;
                float ry = (Random() * 2.0f - 1.0f) * spread;
                Vector3 d = (fwd + right * rx + up * ry).Normalized();
                RaycastHit hit;
                if (Physics_RaycastHit(pos + d * 0.15f, d, 25.0f, hit)) {
                    ReactToHit(hit.entity, d, 4.0f, SHELL_SCATTER, hit.point);
                }
            }
        } else if (type == SHELL_SLUG) {
            // predictable bank: the incoming shot reflects off the vertical,
            // same rule every time - aim down at a slug to send the hit up
            Sfx("slug.wav");
            SpawnFX(pos, 0.7f, 0.85f, 1.0f, 10, 5.0f, 0.10f);
            Vector3 outd = Vector3(dir.x, -dir.y, dir.z);
            RaycastHit hit;
            if (Physics_RaycastHit(pos + outd * 0.15f, outd, 60.0f, hit)) {
                ReactToHit(hit.entity, outd, 25.0f, SHELL_SLUG, hit.point);
            }
        } else {
            // dragon fireball: radial shove + flash, chains other live shells
            Sfx("dragon.wav");
            SpawnFX(pos + Vector3(0.0f, 0.2f, 0.0f), 1.0f, 0.5f, 0.15f, 28, 6.0f, 0.20f);
            if (flashLight != 0) {
                Entity_SetPosition(flashLight, pos + Vector3(0.0f, 0.3f, 0.0f));
                Light_SetIntensity(flashLight, 25.0f);
                lightDecay = 0.6f;
            }
            for (uint i = 0; i < dynEnts.length(); i++) {
                Vector3 d = Entity_GetPosition(dynEnts[i]) - pos;
                float dist = d.Length();
                if (dist > DET_RADIUS) continue;
                Vector3 push = (d + Vector3(0.0f, 0.5f, 0.0f)).Normalized();
                Physics_AddImpulse(dynEnts[i], push * (12.0f * (1.0f - dist / DET_RADIUS) + 2.0f));
            }
            for (uint i = 0; i < pickupEnts.length(); i++) {
                if (pickupTypes[i] < 0) continue;
                Vector3 d = Entity_GetPosition(pickupEnts[i]) - pos;
                if (d.Length() > DET_RADIUS) continue;
                DetonateShell(i, d.Normalized());
            }
        }
    }

    // ----------------------------------------------------------- the five

    // F on the Five, three cases:
    //  - action half-cocked open: close it (works from any pose)
    //  - in the side pose (T): half-cock the action open for port-loading
    //  - otherwise: the normal full pump cycle
    void FiveRack() {
        if (fiveOpen) {
            fiveOpen = false;
            Sfx("pump.wav");
            if (chamber == SHELL_NONE && tube.length() > 0) {
                // nothing port-loaded: closing feeds the next tube round,
                // so T-pose F-F is a full pump cycle
                chamber = tube[tube.length() - 1];
                tube.removeLast();
                chamberSpent = false;
                UpdateHUD("closed - chambered " + ShellName(chamber) + " from the tube");
            } else if (chamber != SHELL_NONE && !chamberSpent) {
                UpdateHUD("closed - ready");
            } else {
                UpdateHUD("closed on an empty chamber");
            }
        } else if (inspectOn) {
            fiveOpen = true;
            Sfx("pump.wav");
            // pulling the action back extracts whatever's chambered:
            // spent hull flies out, live round ejects as a catchable
            if (chamberSpent) {
                EjectHull(0);
                UpdateHUD("half-cocked, hull out - 1/2/3 drops a shell in, F closes");
            } else if (chamber != SHELL_NONE) {
                ThrowLive(chamber);
                UpdateHUD("half-cocked, LIVE " + ShellName(chamber) + " out - CATCH IT (E)!");
            } else {
                UpdateHUD("half-cocked - 1/2/3 drops that shell in the chamber, F closes");
            }
            chamber = SHELL_NONE;
            chamberSpent = false;
        } else {
            StartPump();
        }
    }

    void StartPump() {
        if (chamberSpent) {
            EjectHull(0);   // the spent hull flies out of the port
            UpdateHUD("pumping (hull out)...");
        } else if (chamber != SHELL_NONE) {
            // real pump guns eject the live round too - catch it (R) or it
            // bounces away as a real object; walk over it to get it back
            ThrowLive(chamber);
            UpdateHUD("LIVE " + ShellName(chamber) + " out - CATCH IT (E)!");
        } else {
            UpdateHUD("pumping...");
        }
        chamber = SHELL_NONE;
        chamberSpent = false;
        SetAction(1, PUMP_TIME);
        Sfx("pump.wav");
    }

    // 1/2/3 is context-sensitive: half-racked Five port-loads the chamber,
    // everything else just picks the type for the next tube/barrel load.
    void ShellKey(int type) {
        if (fiveOpen) TryPortLoad(type);
        else          SelectShell(type);
    }

    // Two-stage direct-to-chamber load, Five only, action half-racked (T).
    // Kicks whatever's chambered out the port first, then feeds the new type.
    void TryPortLoad(int type) {
        if (actionTimer > 0.0f) return;   // mid-action, ignore
        if (reserve[type] <= 0) {
            UpdateHUD("no " + ShellName(type) + " shells left - pick another");
            return;
        }
        // clear the chamber out the ejection port
        if (chamberSpent) {
            EjectHull(0);
        } else if (chamber != SHELL_NONE) {
            ThrowLive(chamber);           // live round flies - CATCH IT (E)
        }
        chamber = SHELL_NONE;
        chamberSpent = false;

        selected = type;                  // keep tube loads in sync with intent
        pendingType = type;
        reserve[type] -= 1;
        SetAction(6, RELOAD_TIME);
        UpdateHUD("port-loading " + ShellName(type) + " into chamber...");
    }

    void StartInsertFive() {
        if (tube.length() >= uint(TUBE_CAP)) { UpdateHUD("tube full"); return; }
        if (reserve[selected] <= 0) { EnsureSelectableAmmo(); return; }
        pendingType = selected;
        reserve[selected] -= 1;
        SetAction(2, RELOAD_TIME);
        UpdateHUD("loading " + ShellName(pendingType) + "...");
    }

    // ---------------------------------------------------------- grab / carry

    bool IsGrabbable(uint64 e) {
        if (e == 0 || e == _entityId || e == carried) return false;
        if (!HasComponent_Rigidbody(e)) return false;
        for (uint i = 0; i < pickupEnts.length(); i++) if (e == pickupEnts[i]) return false;
        for (uint i = 0; i < barrelEnts.length(); i++) if (e == barrelEnts[i]) return false;
        return true;
    }

    // toggle-grab (not hold) so it stays one-handed. Grabs the nearest loose
    // prop you're looking at; carries it on a velocity spring toward a point in
    // front of the eye so it tracks the view without tunnelling through walls.
    void ToggleGrab() {
        if (carried != 0) { ReleaseCarried(); return; }
        Vector3 eye = GetPosition();
        Vector3 fwd = Entity_GetForward(_entityId);
        Vector3 probe = eye + fwd * GRAB_REACH;
        int n = Physics_OverlapSphereEntities(probe, GRAB_PROBE);
        uint64 best = 0;
        float bestd = 9999.0f;
        for (int i = 0; i < n; i++) {
            uint64 e = Physics_GetOverlapResult(i);
            if (!IsGrabbable(e)) continue;
            float dd = (Entity_GetPosition(e) - eye).Length();
            if (dd < bestd) { bestd = dd; best = e; }
        }
        if (best == 0) { UpdateHUD("nothing here to grab"); return; }
        carried = best;
        Physics_SetGravityScale(carried, 0.0f);
        Sfx("load.wav");
        UpdateHUD("carrying it - G to set down");
    }

    void ReleaseCarried() {
        if (carried == 0) return;
        Physics_SetGravityScale(carried, 1.0f);
        Physics_SetVelocity(carried, Entity_GetForward(_entityId) * 2.5f);
        carried = 0;
        Sfx("snap.wav");
        UpdateHUD("set it down");
    }

    void UpdateCarry(float dt) {
        if (carried == 0) return;
        Vector3 eye = GetPosition();
        Vector3 fwd = Entity_GetForward(_entityId);
        Vector3 hold = eye + fwd * GRAB_REACH + Vector3(0.0f, -0.25f, 0.0f);
        Vector3 to = hold - Entity_GetPosition(carried);
        Physics_SetVelocity(carried, to * 12.0f);
    }

    // --------------------------------------------------- bullet time / dilation

    void ToggleBulletTime() {
        if (!btActive) {
            if (btMeter <= 0.05f) { UpdateHUD("bullet-time meter empty"); return; }
            btActive = true;
            UpdateHUD("bullet time ON");
        } else {
            btActive = false;
            UpdateHUD("bullet time off");
        }
    }

    // One owner of the global timescale. Manual toggle drains the meter; the
    // free catch-window (set when a live round is cycled) overrides it and costs
    // nothing. dt arrives already scaled, so recover real seconds from curScale.
    void UpdateTimeDilation(float dt) {
        float realDt = dt / Max(curScale, 0.05f);
        if (catchDilate > 0.0f) catchDilate -= realDt;
        bool manual = btActive && btMeter > 0.0f;
        bool wantSlow = manual || catchDilate > 0.0f;
        if (manual) {
            btMeter -= BT_DRAIN * realDt;
            if (btMeter <= 0.0f) { btMeter = 0.0f; btActive = false; }
        } else if (!wantSlow) {
            btMeter = Min(1.0f, btMeter + BT_REFILL * realDt);
        }
        curScale = wantSlow ? BT_SLOW : 1.0f;
        Time_SetTimeScale(curScale);
    }

    // ----------------------------------------------------------- barrels

    // radial blast: shoves every dynamic prop and live shell in range, chains to
    // other barrels, then the barrel is spent and gone
    void DetonateBarrel(uint i) {
        if (i >= barrelDead.length() || barrelDead[i]) return;
        barrelDead[i] = true;
        Vector3 pos = Entity_GetPosition(barrelEnts[i]);
        Sfx("dragon.wav");
        SpawnFX(pos + Vector3(0.0f, 0.5f, 0.0f), 1.0f, 0.5f, 0.12f, 46, 8.5f, 0.30f);   // fireball
        SpawnFX(pos + Vector3(0.0f, 0.6f, 0.0f), 0.4f, 0.4f, 0.42f, 24, 3.0f, 0.35f);   // smoke puff
        if (flashLight != 0) {
            Entity_SetPosition(flashLight, pos + Vector3(0.0f, 0.6f, 0.0f));
            Light_SetIntensity(flashLight, 40.0f);
            lightDecay = 0.9f;
        }
        for (uint k = 0; k < dynEnts.length(); k++) {
            Vector3 dd = Entity_GetPosition(dynEnts[k]) - pos;
            float dist = dd.Length();
            if (dist > BARREL_RADIUS) continue;
            Vector3 push = (dd + Vector3(0.0f, 0.6f, 0.0f)).Normalized();
            Physics_AddImpulse(dynEnts[k], push * (BARREL_IMPULSE * (1.0f - dist / BARREL_RADIUS) + 4.0f));
        }
        for (uint k = 0; k < pickupEnts.length(); k++) {
            if (pickupTypes[k] < 0) continue;
            Vector3 dd = Entity_GetPosition(pickupEnts[k]) - pos;
            if (dd.Length() > BARREL_RADIUS) continue;
            DetonateShell(k, dd.Normalized());
        }
        Physics_SetGravityScale(barrelEnts[i], 0.0f);
        Physics_SetVelocity(barrelEnts[i], Vector3(0.0f, 0.0f, 0.0f));
        Entity_SetVisible(barrelEnts[i], false);
        Physics_Teleport(barrelEnts[i], Vector3(40.0f + i, -60.0f, 40.0f));
        UpdateHUD("BARREL BOOM");
        for (uint k = 0; k < barrelEnts.length(); k++) {
            if (barrelDead[k]) continue;
            Vector3 dd = Entity_GetPosition(barrelEnts[k]) - pos;
            if (dd.Length() <= BARREL_RADIUS) DetonateBarrel(k);
        }
    }

    // ---------------------------------------------------------- shopkeeps

    uint64 NearestNpcInRange() {
        Vector3 eye = GetPosition();
        uint64 best = 0;
        float bd = NPC_RANGE;
        for (uint i = 0; i < npcs.length(); i++) {
            if (npcs[i] == 0) continue;
            float dd = (Entity_GetPosition(npcs[i]) - eye).Length();
            if (dd < bd) { bd = dd; best = npcs[i]; }
        }
        return best;
    }

    void StartTalk(uint64 npc) {
        activeNpc = npc;
        // lock the player in: no walking, jumping, or looking away mid-chat
        if (controllerEnt != 0) Controller_SetEnabled(controllerEnt, false);
        // conversations run at real time, never mid bullet-time
        btActive = false;
        catchDilate = 0.0f;
        curScale = 1.0f;
        Time_SetTimeScale(1.0f);
        // tell the tree whether this owner's job is finished (drives the
        // gratitude-vs-pitch Condition node); set before Start so it reads live
        int j = JobOf(npc);
        if (j >= 0) Dialogue_SetVariable(npc, "done", jobStatus[j] == 2 ? "1" : "0");
        Dialogue_Start(npc);
        Sfx("snap.wav");
    }

    // (dialogue rendering + advance/choose input are the engine's native
    // DialogueBox now - see build_dialoguebox.py. The script only starts the tree
    // and reacts when it ends.)

    // ------------------------------------------------------------- jobs

    int JobOf(uint64 npc) {
        for (uint i = 0; i < jobNpc.length(); i++) if (jobNpc[i] == npc) return int(i);
        return -1;
    }

    // talking to an owner takes the job (the dialogue already explained it)
    void OnTalkEnded(uint64 npc) {
        // hand movement back to the player
        if (controllerEnt != 0) Controller_SetEnabled(controllerEnt, true);
        int j = JobOf(npc);
        if (j >= 0 && jobStatus.length() > uint(j) && jobStatus[j] == 0) {
            jobStatus[j] = 1;
            UpdateHUD(JobStartLine(j));
        } else {
            UpdateHUD("");
        }
    }

    string JobStartLine(int j) {
        if (j == JOB_NOODLE) return "JOB: shoo the pest (scatter), then light the pot (dragon)";
        if (j == JOB_RANGE)  return "JOB: knock every stuck ball loose downrange";
        if (j == JOB_HOTEL)  return "JOB: herd the strays into the stalls - scatter BEHIND them";
        return "";
    }

    string JobDoneLine(int j) {
        if (j == JOB_NOODLE) return "NOODLE SHOP sorted";
        if (j == JOB_RANGE)  return "DRIVING RANGE cleared";
        if (j == JOB_HOTEL)  return "ANIMAL HOTEL settled";
        return "job done";
    }

    void CompleteJob(int j) {
        if (jobStatus[j] == 2) return;
        jobStatus[j] = 2;
        money += JOB_PAY;
        if (j < int(jobNpc.length()) && jobNpc[j] != 0) Dialogue_SetVariable(jobNpc[j], "done", "1");
        if (j < int(jobSign.length()) && jobSign[j] != 0)
            Material_SetBaseColor(jobSign[j], Vector3(0.3f, 1.0f, 0.4f));   // the sign lights up
        Sfx("load.wav");
        UpdateHUD(JobDoneLine(j) + "  (+$" + JOB_PAY + ")  -  go get your thanks");
    }

    void UpdateJobs(float dt) {
        if (jobStatus.length() < uint(JOB_COUNT)) return;

        // NOODLE: pest scattered off + pot lit
        if (jobStatus[JOB_NOODLE] == 1) {
            if (!pestGone && pestEnt != 0) {
                Vector3 p = Entity_GetPosition(pestEnt);
                float dx = p.x - pestHome.x;
                float dz = p.z - pestHome.z;
                if (dx * dx + dz * dz > PEST_GONE_D2) {
                    pestGone = true;
                    UpdateHUD(potBoiled ? "pest's gone!" : "pest scattered - now light the pot (dragon)");
                }
            }
            if (potBoiled && pestGone) CompleteJob(JOB_NOODLE);
        }

        // RANGE: every ball knocked loose
        if (jobStatus[JOB_RANGE] == 1 && ballLoose.length() > 0) {
            bool all = true;
            for (uint i = 0; i < ballLoose.length(); i++) if (!ballLoose[i]) { all = false; break; }
            if (all) CompleteJob(JOB_RANGE);
        }

        // HOTEL: every stray in the pen
        if (jobStatus[JOB_HOTEL] == 1 && strayEnts.length() > 0) {
            if (StraysPenned() == int(strayEnts.length())) CompleteJob(JOB_HOTEL);
        }

        UpdateCritters(dt);
    }

    int BallsLoose() {
        int n = 0;
        for (uint i = 0; i < ballLoose.length(); i++) if (ballLoose[i]) n++;
        return n;
    }

    int StraysPenned() {
        int n = 0;
        for (uint i = 0; i < strayEnts.length(); i++) {
            Vector3 p = Entity_GetPosition(strayEnts[i]);
            float dx = p.x - penCenter.x;
            float dz = p.z - penCenter.z;
            if (dx * dx + dz * dz < PEN_RADIUS * PEN_RADIUS) n++;
        }
        return n;
    }

    // start the range balls wedged out in the traps (something to recover)
    void ScatterBallsIntoTraps() {
        array<Vector3> traps;
        traps.insertLast(Vector3(-3.0f, 0.12f, 17.0f));
        traps.insertLast(Vector3(0.6f, 0.12f, 20.0f));
        traps.insertLast(Vector3(3.0f, 0.12f, 23.0f));
        traps.insertLast(Vector3(-2.0f, 0.12f, 22.0f));
        traps.insertLast(Vector3(1.6f, 0.12f, 18.5f));
        traps.insertLast(Vector3(-4.0f, 0.12f, 24.0f));
        for (uint i = 0; i < ballEnts.length() && i < traps.length(); i++) {
            if (ballEnts[i] == 0) continue;
            Physics_Teleport(ballEnts[i], traps[i]);
            Physics_SetVelocity(ballEnts[i], Vector3(0.0f, 0.0f, 0.0f));
        }
    }

    // --------------------------------------------------------------- critters

    void AddCritter(uint64 c, bool stray) {
        critterEnts.insertLast(c);
        critterIsStray.insertLast(stray);
        critterHeading.insertLast(Random() * 6.2832f);
        critterRepick.insertLast(0.0f);
        critterFlee.insertLast(0.0f);
    }

    // critters are ALWAYS moving: each drives its own horizontal velocity along a
    // wander heading it repicks every second or so. A stray that's reached the
    // pen settles down. Recently shooed ones coast on the impulse instead.
    void UpdateCritters(float dt) {
        for (uint i = 0; i < critterEnts.length(); i++) {
            uint64 c = critterEnts[i];
            if (c == 0) continue;
            if (critterFlee[i] > 0.0f) { critterFlee[i] -= dt; continue; }
            critterRepick[i] -= dt;
            if (critterRepick[i] <= 0.0f) {
                critterHeading[i] = Random() * 6.2832f;
                critterRepick[i] = 0.5f + Random() * 1.2f;
            }
            float sp = SCURRY_SPEED;
            if (critterIsStray[i]) {
                Vector3 p = Entity_GetPosition(c);
                float dx = p.x - penCenter.x;
                float dz = p.z - penCenter.z;
                if (dx * dx + dz * dz < PEN_RADIUS * PEN_RADIUS) sp = SCURRY_PEN;
            }
            Vector3 dir = Vector3(Sin(critterHeading[i]), 0.0f, Cos(critterHeading[i]));
            Vector3 v = Physics_GetVelocity(c);
            Physics_SetVelocity(c, dir * sp + Vector3(0.0f, v.y, 0.0f));   // keep gravity
        }
    }

    // a scatter pellet near a critter shoves it away: shoo the pest off, or herd
    // a stray by aiming BEHIND it
    void ShooCrittersNear(const Vector3 &in point) {
        for (uint i = 0; i < critterEnts.length(); i++) {
            uint64 c = critterEnts[i];
            if (c == 0) continue;
            Vector3 p = Entity_GetPosition(c);
            Vector3 away = p - point;
            away.y = 0.0f;
            float dd = away.Length();
            if (dd > SHOO_RADIUS) continue;
            away = (dd < 0.001f) ? Vector3(0.0f, 0.0f, 1.0f) : away.Normalized();
            // gentle per-pellet nudge; several pellets accumulate into a hop
            Physics_AddImpulse(c, away * 1.6f + Vector3(0.0f, 0.5f, 0.0f));
            critterFlee[i] = 0.4f;              // coast on the shove before wandering again
            critterRepick[i] = 0.0f;            // then pick a fresh heading
        }
    }

    // ---------------------------------------------------------------- hud

    string ShellName(int t) {
        if (t == SHELL_SCATTER) return "SCT";
        if (t == SHELL_SLUG)    return "SLG";
        if (t == SHELL_DRAGON)  return "DRG";
        return "---";
    }

    // a note is transient (fades after a few seconds); the rest of the HUD -
    // gun state, bullet-time meter, money, and the live job tracker - refreshes
    // every frame via RefreshHUD
    void UpdateHUD(const string &in note) {
        if (note.length() > 0) { pendingNote = note; noteTimer = 3.5f; }
        RefreshHUD();
    }

    // one short thing per line so nothing wraps or stacks on itself
    void RefreshHUD() {
        if (hudEnt == 0) return;
        string s = "THE FIVE   chamber: ";
        if (chamber == SHELL_NONE)  s += "empty";
        else if (chamberSpent)      s += "spent";
        else                        s += ShellName(chamber);
        if (fiveOpen)               s += " (open)";
        s += "   tube ";
        for (int i = int(tube.length()) - 1; i >= 0; i--) s += "[" + ShellName(tube[i]) + "]";
        for (uint i = tube.length(); i < uint(TUBE_CAP); i++) s += "[ ]";

        s += "\nload " + ShellName(selected)
          + "    SCT " + reserve[SHELL_SCATTER]
          + "  SLG " + reserve[SHELL_SLUG]
          + "  DRG " + reserve[SHELL_DRAGON]
          + "     $" + money;

        s += "\nbullet-time " + BtMeterBar() + (btActive ? "  ON" : "");

        string job = JobTrackerLine();
        if (job.length() > 0) s += "\n" + job;

        if (nearNpc && activeNpc == 0 && heldShell == SHELL_NONE) s += "\n[E] talk";

        if (noteTimer > 0.0f && pendingNote.length() > 0) s += "\n> " + pendingNote;
        HUD_SetText(hudEnt, s);
    }

    // just the active job, on its own short line
    string JobTrackerLine() {
        if (jobStatus.length() < uint(JOB_COUNT)) return "";
        if (jobStatus[JOB_NOODLE] == 1)
            return "JOB noodle:  pest " + (pestGone ? "done" : "todo") + "   pot " + (potBoiled ? "done" : "todo");
        if (jobStatus[JOB_RANGE] == 1)
            return "JOB range:  balls loose " + BallsLoose() + "/" + int(ballEnts.length());
        if (jobStatus[JOB_HOTEL] == 1)
            return "JOB hotel:  in the stalls " + StraysPenned() + "/" + int(strayEnts.length());
        return "";
    }

    string BtMeterBar() {
        int filled = int(btMeter * 10.0f + 0.5f);
        string b = "[";
        for (int i = 0; i < 10; i++) b += (i < filled) ? "|" : ".";
        b += "]";
        return b;
    }
}

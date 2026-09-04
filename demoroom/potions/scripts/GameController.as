// GameController.as — whole game, one scene, one entity (the Player).
// Rooms are entity GROUPS toggled by visibility. Textures only bind on entities
// that are VISIBLE during the load render, so everything is authored visible and
// we run a short "warm-up" (a few covered frames) before hiding the non-town
// groups. Room switches use an in-world spiral fade. Nothing reloads = seamless.
#include "TegeBehavior.as"
#include "PotionData.as"

const float TALK_RANGE = 1.8f;
const float DOOR_RANGE = 2.0f;
const float CAULDRON_RANGE = 2.2f;
const float EXIT_RANGE = 2.0f;

const int MODE_TOWN = 0, MODE_BATTLE = 1, MODE_HOME = 2;
const int TR_NONE = 0, TR_OUT = 1, TR_IN = 2;
const int BST_FIGHT = 0, BST_STATS = 1;

const int   START_HP = 24, ENEMY_HP = 24, BASE_COST = 3;
const float Z_BASE = 6.0f, Z_SCALE = 0.1f;
const float TR_OUT_TIME = 0.28f, TR_IN_TIME = 0.34f;
const int   WARMUP_FRAMES = 4;

float DepthForY(float y) { return Z_BASE - y * Z_SCALE; }

class GameController : TegeBehavior {
    array<string> towns = {
        "Karada", "Sofida", "Frazeail", "Tobito", "Prala", "Gornot", "Qaytail",
        "Lesnod", "Rezaal", "Soput", "Srahal", "Wayhol", "Connel", "Rawkal",
        "Veranad", "Hadda", "Popata", "Brickle", "Martayle", "Wrostlane" };
    int townIndex = 0;

    array<string> npcNames = { "Bram", "Odette", "Milo" };
    array<int>    npcFav   = { COL_RED, COL_BLUE, COL_YELLOW };
    array<uint64> npcEnts;
    array<bool>   beaten;

    array<uint64> townEnts, homeEnts, battleEnts, enemyEnts;
    uint64 hud, fade, homeDoor, cauldron, exitDoor;
    uint64 eFill, pFill, throwP, throwE;
    Vector3 eFull, pFull;
    float   eFw, pFw;

    int hp = START_HP, maxHP = START_HP, coins = 0;
    array<int> bag = { 2, 1, 3, 1, 3, 1 };

    int mode = MODE_TOWN;
    int trans = TR_NONE, pendingMode = MODE_TOWN, pendingEnemy = -1;
    float transT = 0.0f;
    Vector3 townReturn = Vector3(0.0f, -2.0f, 0.0f);

    bool warmup = true;
    int  warmN = 0;

    uint64 nearNpc = 0;
    bool   nearHome = false;
    string lastResult = "";

    int bstate = BST_FIGHT, enemyIdx = -1, enemyFav = COL_RED, enemyHP = ENEMY_HP;
    int dealt = 0, taken = 0, turns = 0;

    bool atCauldron = false, atExit = false, mixing = false;

    // ---------------------------------------------------------------- setup
    void OnStart() {
        hud       = Scene_FindEntity("GameHUD");
        fade      = Scene_FindEntity("Fade");
        homeDoor  = Scene_FindEntity("HomeDoor");
        cauldron  = Scene_FindEntity("Cauldron");
        exitDoor  = Scene_FindEntity("ExitDoor");
        eFill     = Scene_FindEntity("EnemyHPFill");
        pFill     = Scene_FindEntity("PlayerHPFill");
        throwP    = Scene_FindEntity("ThrowPlayer");
        throwE    = Scene_FindEntity("ThrowEnemy");
        eFull = Entity_GetPosition(eFill); eFw = Entity_GetScale(eFill).x;
        pFull = Entity_GetPosition(pFill); pFw = Entity_GetScale(pFill).x;

        for (uint i = 0; i < npcNames.length(); i++) {
            npcEnts.insertLast(Scene_FindEntity("NPC_" + i));
            beaten.insertLast(false);
            enemyEnts.insertLast(Scene_FindEntity("BattleEnemy" + i));
        }
        townEnts.insertLast(Scene_FindEntity("Ground"));
        for (uint i = 0; i < npcEnts.length(); i++) townEnts.insertLast(npcEnts[i]);
        townEnts.insertLast(homeDoor);
        homeEnts.insertLast(Scene_FindEntity("FloorHome"));
        homeEnts.insertLast(cauldron);
        homeEnts.insertLast(exitDoor);
        battleEnts.insertLast(Scene_FindEntity("BattleBG"));
        battleEnts.insertLast(Scene_FindEntity("BattlePlayer"));
        battleEnts.insertLast(Scene_FindEntity("EnemyHPBg"));
        battleEnts.insertLast(eFill);
        battleEnts.insertLast(Scene_FindEntity("PlayerHPBg"));
        battleEnts.insertLast(pFill);

        // Everything is authored visible so textures bind now, under the fade
        // cover. Warm-up (below) hides the non-town groups after a few frames.
        warmup = true; warmN = 0;
    }

    void SV(uint64 e, bool v) { if (e != 0) Entity_SetVisible(e, v); }
    void SetHUD(const string &in s) { if (hud != 0) HUD_SetText(hud, s); }

    void ShowOnly(int m) {
        for (uint i = 0; i < townEnts.length(); i++) SV(townEnts[i], m == MODE_TOWN);
        for (uint i = 0; i < homeEnts.length(); i++) SV(homeEnts[i], m == MODE_HOME);
        for (uint i = 0; i < battleEnts.length(); i++) SV(battleEnts[i], m == MODE_BATTLE);
        for (uint i = 0; i < enemyEnts.length(); i++) SV(enemyEnts[i], false);   // battle shows one
        SV(_entityId, m != MODE_BATTLE);
        SV(throwP, false);
        SV(throwE, false);
        if (m == MODE_TOWN)
            for (uint i = 0; i < npcEnts.length(); i++) if (beaten[i]) SV(npcEnts[i], false);
    }

    // ------------------------------------------------------- transition FSM
    void Begin(int target, int enemy) {
        if (trans != TR_NONE) return;
        pendingMode = target;
        pendingEnemy = enemy;
        trans = TR_OUT;
        transT = 0.0f;
        if (fade != 0) {
            Entity_SetVisible(fade, true);
            Entity_SetRotation(fade, Vector3(0.0f, 0.0f, 0.0f));
            Tween_Opacity(fade, 1.0f, TR_OUT_TIME, EASE_IN_OUT_CUBIC);
            Tween_Rotation(fade, Vector3(0.0f, 0.0f, 220.0f), TR_OUT_TIME + TR_IN_TIME, EASE_IN_OUT_CUBIC);
        }
    }

    void OnUpdate(float dt) {
        if (warmup) {
            warmN++;
            if (warmN >= WARMUP_FRAMES) {
                warmup = false;
                mode = MODE_TOWN;
                ShowOnly(MODE_TOWN);
                MovePlayer(0.0f, -2.0f);
                ShowTown();
                trans = TR_IN; transT = 0.0f;      // reveal: fade the cover out
                if (fade != 0) Tween_Opacity(fade, 0.0f, TR_IN_TIME, EASE_OUT_CUBIC);
            }
            return;
        }
        if (trans != TR_NONE) { UpdateTransition(dt); return; }
        if (mode == MODE_TOWN) UpdateTown(dt);
        else if (mode == MODE_BATTLE) UpdateBattle(dt);
        else UpdateHome(dt);
    }

    void UpdateTransition(float dt) {
        transT += dt;
        if (transT > 1.0f) { trans = TR_NONE; if (fade != 0) Entity_SetVisible(fade, false); return; }
        if (trans == TR_OUT) {
            if (transT >= TR_OUT_TIME) {
                ApplyMode(pendingMode);
                trans = TR_IN; transT = 0.0f;
                if (fade != 0) Tween_Opacity(fade, 0.0f, TR_IN_TIME, EASE_OUT_CUBIC);
            }
        } else {
            if (transT >= TR_IN_TIME) { trans = TR_NONE; if (fade != 0) Entity_SetVisible(fade, false); }
        }
    }

    void ApplyMode(int m) {
        mode = m;
        ShowOnly(m);
        if (m == MODE_TOWN) { MovePlayer(townReturn.x, townReturn.y); ShowTown(); }
        else if (m == MODE_HOME) { MovePlayer(-8.0f, -3.0f); mixing = false; ShowHome(""); }
        else StartBattle(pendingEnemy);
    }

    void MovePlayer(float x, float y) { Entity_SetPosition(_entityId, Vector3(x, y, DepthForY(y))); }

    // ============================================================ TOWN =====
    void ShowTown() {
        string s = "== " + towns[townIndex % int(towns.length())] + " ==    coins " + coins
                 + "    HP " + hp + "/" + maxHP + "\n";
        if (lastResult.length() > 0) s += lastResult + "\n";
        s += "Find a challenger (press E), or your house to mix.";
        SetHUD(s);
    }

    void UpdateTown(float dt) {
        Vector3 me = GetPosition();
        MovePlayer(me.x, me.y);

        uint64 best = 0; float bd = TALK_RANGE;
        for (uint i = 0; i < npcEnts.length(); i++) {
            if (npcEnts[i] == 0 || beaten[i]) continue;
            float d = (Entity_GetPosition(npcEnts[i]) - me).Length();
            if (d < bd) { bd = d; best = npcEnts[i]; }
        }
        bool home = (homeDoor != 0) && ((Entity_GetPosition(homeDoor) - me).Length() < DOOR_RANGE);

        if (best != nearNpc || home != nearHome) {
            nearNpc = best; nearHome = home;
            if (nearNpc != 0) {
                int i = TownIndexOf(nearNpc);
                SetHUD(npcNames[i] + " wants to battle!  They favor " + ColorName(npcFav[i]) + ".\nPress E to fight.");
            } else if (nearHome) {
                SetHUD("Your house.\nPress E to go inside and mix potions.");
            } else ShowTown();
        }
        if (Input_GetKeyDown(Key::E)) {
            if (nearNpc != 0) { townReturn = Vector3(me.x, me.y, 0.0f); Begin(MODE_BATTLE, TownIndexOf(nearNpc)); }
            else if (nearHome) { townReturn = Vector3(-8.0f, -2.0f, 0.0f); Begin(MODE_HOME, -1); }
        }
    }
    int TownIndexOf(uint64 e) {
        for (uint i = 0; i < npcEnts.length(); i++) if (npcEnts[i] == e) return int(i);
        return -1;
    }

    // ========================================================== BATTLE =====
    void StartBattle(int i) {
        if (i < 0 || i >= int(npcNames.length())) i = 0;
        enemyIdx = i; enemyFav = npcFav[i];
        enemyHP = ENEMY_HP; bstate = BST_FIGHT;
        dealt = 0; taken = 0; turns = 0;
        for (uint k = 0; k < enemyEnts.length(); k++) SV(enemyEnts[k], int(k) == i);   // show this challenger
        SV(throwP, false); SV(throwE, false);
        UpdateBars();
        ShowBattleMenu(npcNames[i] + " challenges you!");
    }

    void UpdateBattle(float dt) {
        if (bstate == BST_STATS) {
            if (Input_GetKeyDown(Key::E) || Input_GetKeyDown(Key::Enter)) Begin(MODE_TOWN, -1);
            return;
        }
        for (int c = 0; c < COL_COUNT; c++) {
            if (Input_GetKeyDown(int(Key::Num1) + c)) {
                if (bag[c] > 0) ResolveRound(c);
                else ShowBattleMenu("No " + ColorName(c) + " left - pick another.");
                return;
            }
        }
    }

    void ResolveRound(int myColor) {
        bag[myColor] -= 1; turns += 1;
        int dOut = PotionDamage(myColor, enemyFav);
        int dIn  = PotionDamage(enemyFav, myColor);
        enemyHP -= dOut; dealt += dOut;
        hp -= dIn; taken += dIn;
        ShowThrow(throwP, myColor);
        ShowThrow(throwE, enemyFav);
        UpdateBars();
        string line = "You throw " + ColorName(myColor) + " " + Eff(myColor, enemyFav)
                    + "- " + dOut + " dmg.   " + npcNames[enemyIdx] + "'s "
                    + ColorName(enemyFav) + " hits for " + dIn + ".";
        if (enemyHP <= 0) { Finish(true); return; }
        if (hp <= 0) { Finish(false); return; }
        if (BagTotal() <= 0) { Finish(false); return; }
        ShowBattleMenu(line);
    }

    void ShowThrow(uint64 e, int color) {
        if (e == 0) return;
        Material_SetBaseColor(e, ColorRGB(color));   // solid quad tinted to the thrown color
        Entity_SetVisible(e, true);
    }
    string Eff(int a, int d) {
        float m = TypeMultiplier(a, d);
        if (m >= 2.0f) return "(super effective!) ";
        if (m <= 0.5f) return "(not very effective) ";
        return "";
    }
    int BagTotal() { int t = 0; for (int c = 0; c < COL_COUNT; c++) t += bag[c]; return t; }
    int Max0(int v) { return (v > 0) ? v : 0; }

    void UpdateBars() {
        SetFill(eFill, eFull, eFw, Frac(enemyHP, ENEMY_HP));
        SetFill(pFill, pFull, pFw, Frac(hp, maxHP));
    }
    float Frac(int v, int mx) {
        if (mx <= 0) return 0.0f;
        float f = float(v) / float(mx);
        return (f < 0.0f) ? 0.0f : ((f > 1.0f) ? 1.0f : f);
    }
    void SetFill(uint64 e, const Vector3 &in full, float fullW, float frac) {
        if (e == 0) return;
        float w = fullW * frac; if (w < 0.02f) w = 0.02f;
        Vector3 s = Entity_GetScale(e); s.x = w; Entity_SetScale(e, s);
        Vector3 p = full; p.x = (full.x - fullW * 0.5f) + w * 0.5f; Entity_SetPosition(e, p);
        Vector3 col = (frac > 0.5f) ? Vector3(0.30f, 0.80f, 0.35f)
                    : (frac > 0.25f) ? Vector3(0.90f, 0.80f, 0.20f)
                                     : Vector3(0.85f, 0.25f, 0.20f);
        Material_SetBaseColor(e, col);
    }

    void ShowBattleMenu(const string &in note) {
        string s = note + "\n\n";
        for (int c = 0; c < COL_COUNT; c++)
            if (bag[c] > 0) s += "[" + (c + 1) + "] " + ColorName(c) + " x" + bag[c] + "   ";
        SetHUD(s);
    }

    void Finish(bool win) {
        int reward = 0;
        if (win) {
            reward = 10 + turns;
            beaten[enemyIdx] = true;
            coins += reward;
            if (hp < 1) hp = 1;
        } else hp = maxHP;
        SV(throwP, false); SV(throwE, false);
        bstate = BST_STATS;
        string s = win ? ("* YOU WON vs " + npcNames[enemyIdx] + " *") : ("You lost to " + npcNames[enemyIdx] + "...");
        s += "\nDamage dealt " + dealt + "   taken " + taken + "   rounds " + turns + "\n";
        s += win ? ("Reward +" + reward + " coins  (total " + coins + ")\n") : ("You rest and recover to full HP.\n");
        s += "Press E to return to town.";
        lastResult = win ? ("You beat " + npcNames[enemyIdx] + "!") : (npcNames[enemyIdx] + " beat you.");
        SetHUD(s);
    }

    // ============================================================ HOME =====
    void ShowHome(const string &in note) {
        string s = "== Home ==    HP " + hp + "/" + maxHP + "    coins " + coins + "\n";
        if (note.length() > 0) s += note + "\n";
        s += "Walk to the cauldron to mix, or the door to leave.";
        SetHUD(s);
    }
    void ShowMix(const string &in note) {
        string s = "== Workbench ==    coins " + coins + "\n";
        if (note.length() > 0) s += note + "\n";
        s += "Mix:  [1] Orange (R+Y)   [2] Green (Y+B)   [3] Purple (B+R)\n";
        s += "Buy:  [5] Red  [6] Yellow  [7] Blue  (" + BASE_COST + " coins)   [4] Rest\n";
        s += "[E] step away";
        SetHUD(s);
    }

    void UpdateHome(float dt) {
        Vector3 me = GetPosition();
        MovePlayer(me.x, me.y);
        bool nc = (cauldron != 0) && ((Entity_GetPosition(cauldron) - me).Length() < CAULDRON_RANGE);
        bool nx = (exitDoor != 0) && ((Entity_GetPosition(exitDoor) - me).Length() < EXIT_RANGE);
        if (mixing) { UpdateMix(); return; }
        if (nc != atCauldron || nx != atExit) {
            atCauldron = nc; atExit = nx;
            if (atCauldron) ShowHome("Press E to use the cauldron.");
            else if (atExit) ShowHome("Press E to head back to town.");
            else ShowHome("");
        }
        if (Input_GetKeyDown(Key::E)) {
            if (atCauldron) { mixing = true; ShowMix(""); }
            else if (atExit) { townReturn = Vector3(-8.0f, -2.0f, 0.0f); Begin(MODE_TOWN, -1); }
        }
    }
    void UpdateMix() {
        if (Input_GetKeyDown(Key::E)) { mixing = false; ShowHome(""); return; }
        if (Input_GetKeyDown(Key::Num1)) Mix(COL_RED, COL_YELLOW, COL_ORANGE);
        else if (Input_GetKeyDown(Key::Num2)) Mix(COL_YELLOW, COL_BLUE, COL_GREEN);
        else if (Input_GetKeyDown(Key::Num3)) Mix(COL_BLUE, COL_RED, COL_PURPLE);
        else if (Input_GetKeyDown(Key::Num4)) { hp = maxHP; ShowMix("You rest. HP restored to full."); }
        else if (Input_GetKeyDown(Key::Num5)) Buy(COL_RED);
        else if (Input_GetKeyDown(Key::Num6)) Buy(COL_YELLOW);
        else if (Input_GetKeyDown(Key::Num7)) Buy(COL_BLUE);
    }
    void Mix(int a, int b, int r) {
        if (bag[a] <= 0 || bag[b] <= 0) { ShowMix("Need one " + ColorName(a) + " and one " + ColorName(b) + "."); return; }
        bag[a] -= 1; bag[b] -= 1; bag[r] += 1;
        ShowMix("Mixed a " + ColorName(r) + " potion!  (" + ColorName(r) + " x" + bag[r] + ")");
    }
    void Buy(int c) {
        if (coins < BASE_COST) { ShowMix("Not enough coins for " + ColorName(c) + "."); return; }
        coins -= BASE_COST; bag[c] += 1;
        ShowMix("Bought a " + ColorName(c) + " potion.  (" + ColorName(c) + " x" + bag[c] + ")");
    }
}

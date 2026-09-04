# Enjin (TEGE) AngelScript API Reference

Auto-generated from the engine binding source by `tools/gen_api_reference.py`.
Source of truth: `D:\GitHub\enjin\Engine\src\Scripting\ScriptBindings_*.cpp`. Regenerate after engine changes.

**1215 callable bindings** across 37 subsystems. Grouped by subsystem (the engine file that registers them).

All scripts inherit `TegeBehavior` (see `TegeBehavior.as`) and get lifecycle
callbacks: `OnStart`, `OnUpdate(float dt)`, `OnFixedUpdate`, `OnLateUpdate`,
`OnDestroy`, `OnCollisionEnter/Stay/Exit(uint64)`, `OnTriggerEnter/Exit(uint64)`.

## Subsystems

[Core](#core) | [FlashAPIShim](#flashapishim) | [AI](#ai) | [Accessibility](#accessibility) | [Audio](#audio) | [AudioGraph](#audiograph) | [AudioReactive](#audioreactive) | [Components](#components) | [Dialogue](#dialogue) | [Elemental](#elemental) | [Flower](#flower) | [Gameplay](#gameplay) | [GameplayComponents](#gameplaycomponents) | [HUD](#hud) | [Input](#input) | [InputAction](#inputaction) | [MIDI](#midi) | [Networking](#networking) | [Noise](#noise) | [Particles](#particles) | [Physics](#physics) | [Physics2D](#physics2d) | [Plugin](#plugin) | [Prefab](#prefab) | [Procedural](#procedural) | [Render](#render) | [Rewind](#rewind) | [Save](#save) | [Scene](#scene) | [Sprite](#sprite) | [StateMachine](#statemachine) | [Streaming](#streaming) | [Text](#text) | [Tween](#tween) | [UI](#ui) | [Water](#water) | [Weather](#weather)

---
## Core

### Types
- `Vector2`
    - float x
    - float y
    - void f()  // behaviour
    - void f(const Vector2 &in)  // behaviour
    - void f(float, float)  // behaviour
    - Vector2 opAdd(const Vector2 &in) const
    - Vector2 opSub(const Vector2 &in) const
    - Vector2 opMul(float) const
    - Vector2 opDiv(float) const
    - Vector2 opNeg() const
    - float Length() const
    - Vector2 Normalized() const
    - float Dot(const Vector2 &in) const
- `Vector3`
    - float x
    - float y
    - float z
    - void f()  // behaviour
    - void f(const Vector3 &in)  // behaviour
    - void f(float, float, float)  // behaviour
    - Vector3 opAdd(const Vector3 &in) const
    - Vector3 opSub(const Vector3 &in) const
    - Vector3 opMul(float) const
    - Vector3 opDiv(float) const
    - Vector3 opNeg() const
    - float Length() const
    - Vector3 Normalized() const
    - float Dot(const Vector3 &in) const
    - Vector3 Cross(const Vector3 &in) const
- `Vector4`
    - float x
    - float y
    - float z
    - float w
    - void f()  // behaviour
    - void f(const Vector4 &in)  // behaviour
    - void f(float, float, float, float)  // behaviour
- `Quaternion`
    - float x
    - float y
    - float z
    - float w
    - void f()  // behaviour
    - void f(const Quaternion &in)  // behaviour
    - void f(float, float, float, float)  // behaviour
    - void f(const Vector3 &in, float)  // behaviour
    - Vector3 Rotate(const Vector3 &in) const
    - Quaternion Normalized() const
    - Quaternion Inverse() const
    - Vector3 ToEuler() const
    - Quaternion opMul(const Quaternion &in) const
- `EntityHandle`
    - EntityHandle@ f()  // behaviour
    - EntityHandle@ f(uint64)  // behaviour
    - void f()  // behaviour
    - void f()  // behaviour
    - bool IsValid() const
    - uint64 GetID() const
    - Vector3 GetPosition() const
    - void SetPosition(const Vector3 &in)
    - Vector3 GetRotation() const
    - void SetRotation(const Vector3 &in)
    - Vector3 GetScale() const
    - void SetScale(const Vector3 &in)
    - string GetName() const
    - bool HasTag(const string &in) const
- `TransformProxy`
    - void f()  // behaviour
    - void f(const TransformProxy &in)  // behaviour
    - Vector3 get_position() const
    - void set_position(const Vector3 &in)
    - Vector3 get_rotation() const
    - void set_rotation(const Vector3 &in)
    - Vector3 get_scale() const
    - void set_scale(const Vector3 &in)
    - Vector3 get_forward() const
    - Vector3 get_right() const
    - Vector3 get_up() const
- `EventData`
    - EventData@ f()  // behaviour
    - void f()  // behaviour
    - void f()  // behaviour
    - void SetFloat(const string &in, float)
    - float GetFloat(const string &in)
    - void SetInt(const string &in, int)
    - int GetInt(const string &in)
    - void SetString(const string &in, const string &in)
    - string GetString(const string &in)
    - void SetEntity(const string &in, uint64)
    - uint64 GetEntity(const string &in)

### Funcdefs
- `void EventCallback(const string &in)`

### Functions
- `Quaternion Quaternion_Identity()`
- `Quaternion Quaternion_FromEuler(const Vector3 &in)`
- `Quaternion Quaternion_Slerp(const Quaternion &in, const Quaternion &in, float)`
- `float Abs(float)`
- `float Sin(float)`
- `float Cos(float)`
- `float Tan(float)`
- `float Asin(float)`
- `float Acos(float)`
- `float Atan2(float, float)`
- `float Sqrt(float)`
- `float Pow(float, float)`
- `float Floor(float)`
- `float Ceil(float)`
- `float Round(float)`
- `float Min(float, float)`
- `float Max(float, float)`
- `float Clamp(float, float, float)`
- `float Lerp(float, float, float)`
- `float MoveTowards(float, float, float)`
- `float Sign(float)`
- `float Random()`
- `float RandomRange(float, float)`
- `int   RandomInt(int, int)`
- `float Radians(float)`
- `float Degrees(float)`
- `float PI()`
- `void Time_SetScale(float)`
- `float Time_GetScale()`
- `float Time_GetDeltaTime()`
- `float Time_GetFixedDeltaTime()`
- `float Time_GetTime()`
- `float Time_GetTimeScale()`
- `void Time_SetTimeScale(float)`
- `uint Time_GetFrameCount()`
- `void Debug_Log(const string &in)`
- `void Debug_LogWarning(const string &in)`
- `void Debug_LogError(const string &in)`
- `void StartCoroutine(const string &in)`
- `void YieldSeconds(float)`
- `void YieldFrames(uint)`
- `void YieldEndOfFrame()`
- `uint Events_Listen(const string &in, EventCallback@)`
- `void Events_Send(const string &in, EventData@)`
- `void Events_Broadcast(EventData@)`
- `float Events_CurrentFloat(const string &in)`
- `int Events_CurrentInt(const string &in)`
- `string Events_CurrentString(const string &in)`
- `bool DataAsset_Load(const string &in)`
- `float DataAsset_GetFloat(const string &in, const string &in)`
- `int DataAsset_GetInt(const string &in, const string &in)`
- `bool DataAsset_GetBool(const string &in, const string &in)`
- `string DataAsset_GetString(const string &in, const string &in)`
- `Vector3 DataAsset_GetVector3(const string &in, const string &in)`
- `void VisualScript_SendEvent(uint64, const string &in)`
- `void VisualScript_SetVariable(uint64, const string &in, float)`
- `float VisualScript_GetVariable(uint64, const string &in)`


---

## FlashAPIShim

### Functions
- `float Flash_GetX(uint64)`
- `void Flash_SetX(uint64, float)`
- `float Flash_GetY(uint64)`
- `void Flash_SetY(uint64, float)`
- `float Flash_GetScaleX(uint64)`
- `void Flash_SetScaleX(uint64, float)`
- `float Flash_GetScaleY(uint64)`
- `void Flash_SetScaleY(uint64, float)`
- `float Flash_GetRotation(uint64)`
- `void Flash_SetRotation(uint64, float)`
- `float Flash_GetAlpha(uint64)`
- `void Flash_SetAlpha(uint64, float)`
- `bool Flash_GetVisible(uint64)`
- `void Flash_SetVisible(uint64, bool)`
- `void Flash_GotoAndPlay(uint64, int)`
- `void Flash_GotoAndStop(uint64, int)`
- `void Flash_Play(uint64)`
- `void Flash_Stop(uint64)`
- `int Flash_GetCurrentFrame(uint64)`
- `int Flash_GetTotalFrames(uint64)`
- `uint64 Flash_GetChildByName(uint64, const string &in)`
- `float Flash_GetStageWidth()`
- `float Flash_GetStageHeight()`
- `float Flash_GetFrameRate()`
- `float Flash_GetMouseX()`
- `float Flash_GetMouseY()`
- `bool Flash_IsKeyDown(int)`
- `void Flash_SetText(uint64, const string &in)`
- `string Flash_GetText(uint64)`
- `float Flash_MathRandom()`
- `float Flash_MathFloor(float)`
- `float Flash_MathCeil(float)`
- `float Flash_MathRound(float)`
- `float Flash_MathAbs(float)`
- `float Flash_MathSqrt(float)`
- `float Flash_MathSin(float)`
- `float Flash_MathCos(float)`
- `float Flash_MathAtan2(float, float)`
- `void Flash_PlaySound(const string &in)`
- `void Flash_StopSound(const string &in)`
- `void Flash_SetVolume(const string &in, float)`
- `uint Flash_SetTimeout(float)`
- `uint Flash_SetInterval(float)`
- `void Flash_ClearInterval(uint)`
- `void Flash_SO_Set(const string &in, const string &in, const string &in)`
- `string Flash_SO_Get(const string &in, const string &in)`
- `bool Flash_SO_Has(const string &in, const string &in)`
- `void Flash_SO_Flush(const string &in)`
- `void Flash_SO_Clear(const string &in)`
- `float Math_Random()`
- `float Math_Floor(float)`
- `float Math_Ceil(float)`
- `float Math_Round(float)`
- `float Math_Abs(float)`
- `float Math_Sqrt(float)`
- `float Math_Sin(float)`
- `float Math_Cos(float)`
- `float Math_Atan2(float, float)`


---

## AI

### Enums
- `AIState` = { AI_IDLE, AI_PATROL, AI_CHASE, AI_ATTACK, AI_FLEE, AI_DEAD }

### Functions
- `void AI_SetState(uint64, int)`
- `int AI_GetState(uint64)`
- `void AI_SetTarget(uint64, uint64)`
- `uint64 AI_GetTarget(uint64)`
- `void AI_SetTargetPosition(uint64, float, float, float)`
- `void AI_SetMoveSpeed(uint64, float)`
- `float AI_GetMoveSpeed(uint64)`
- `void AI_SetDetectionRange(uint64, float)`
- `float AI_GetDetectionRange(uint64)`
- `void AI_SetAttackRange(uint64, float)`
- `float AI_GetAttackRange(uint64)`
- `void AI_SetChaseSpeed(uint64, float)`
- `void AI_SetFleeSpeed(uint64, float)`
- `void AI_SetFieldOfView(uint64, float)`
- `void AI_SetUseNavmesh(uint64, bool)`
- `bool BT_IsEnabled(uint64)`
- `void BT_Enable(uint64)`
- `void BT_Disable(uint64)`
- `void BT_Reset(uint64)`
- `void BT_SetBlackboardFloat(uint64, const string&in, float)`
- `float BT_GetBlackboardFloat(uint64, const string&in)`
- `void BT_SetBlackboardInt(uint64, const string&in, int)`
- `int BT_GetBlackboardInt(uint64, const string&in)`
- `void BT_SetBlackboardBool(uint64, const string&in, bool)`
- `bool BT_GetBlackboardBool(uint64, const string&in)`
- `void BT_SetBlackboardString(uint64, const string&in, const string&in)`
- `string BT_GetBlackboardString(uint64, const string&in)`
- `void BT_ClearBlackboard(uint64)`
- `bool Navmesh_IsPointOnNavmesh(float, float, float)`
- `bool Navmesh_HasNavmesh()`
- `int Navmesh_FindPath(float, float, float, float, float, float)`
- `bool Navmesh_PathExists(float, float, float, float, float, float)`
- `Vector3 Navmesh_GetPathWaypoint(int)`
- `float Navmesh_GetPathCost()`


---

## Accessibility

### Enums
- `ColorblindMode` = { CB_OFF, CB_PROTANOPIA, CB_DEUTERANOPIA, CB_TRITANOPIA, CB_PROTANOMALY, CB_DEUTERANOMALY, CB_TRITANOMALY, CB_ACHROMATOPSIA, CB_ACHROMATOMALY }

### Functions
- `void Subtitle_Show(const string&in, const string&in = "", float = 3.0)`
- `void Subtitle_ShowWithColor(const string&in, const string&in, float, float, float, float = 3.0)`
- `void Subtitle_ShowCaption(const string&in, float = 2.5)`
- `void Subtitle_Clear()`
- `void Subtitle_SetEnabled(bool)`
- `bool Subtitle_IsEnabled()`
- `void Subtitle_SetFontSize(float)`
- `float Subtitle_GetFontSize()`
- `void Announcer_Announce(const string&in)`
- `void Announcer_AnnounceHighPriority(const string&in)`
- `void Announcer_Clear()`
- `void Announcer_SetEnabled(bool)`
- `bool Announcer_IsEnabled()`
- `void Colorblind_SetMode(int)`
- `int Colorblind_GetMode()`
- `void Colorblind_SetStrength(float)`
- `float Colorblind_GetStrength()`
- `void Accessibility_SetReducedMotion(bool)`
- `bool Accessibility_GetReducedMotion()`
- `void Accessibility_SetScreenShake(bool)`
- `bool Accessibility_GetScreenShake()`
- `void Accessibility_SetFlashingLights(bool)`
- `bool Accessibility_GetFlashingLights()`
- `void Accessibility_SetFontScale(float)`
- `float Accessibility_GetFontScale()`
- `void Accessibility_SetBrightness(float)`
- `float Accessibility_GetBrightness()`
- `void Accessibility_SetContrast(float)`
- `float Accessibility_GetContrast()`
- `void Accessibility_SetDyslexiaFont(bool)`
- `bool Accessibility_GetDyslexiaFont()`
- `void Accessibility_SaveSettings()`
- `void Accessibility_SetDwellClick(bool, float = 0.0)`
- `bool Accessibility_GetDwellClick()`
- `void Accessibility_SetSwitchAccess(bool, float = 0.0)`
- `bool Accessibility_GetSwitchAccess()`
- `void Accessibility_SetStickyDrag(bool)`
- `bool Accessibility_GetStickyDrag()`
- `void Accessibility_SetScreenReader(bool)`
- `bool Accessibility_GetScreenReader()`
- `void Accessibility_SetAudioIndicators(bool)`
- `bool Accessibility_GetAudioIndicators()`


---

## Audio

### Global properties
- `const uint8 AUDIO_CHANNEL_SFX`
- `const uint8 AUDIO_CHANNEL_MUSIC`
- `const uint8 AUDIO_CHANNEL_UI`
- `const uint8 AUDIO_CHANNEL_VOICE`

### Functions
- `void Audio_Play(uint64)`
- `void Audio_PlayAtPosition(const string &in, const Vector3 &in)`
- `void Audio_Stop(uint64)`
- `void Audio_StopAll()`
- `void Audio_SetVolume(uint64, float)`
- `void Audio_SetPitch(uint64, float)`
- `bool Audio_IsPlaying(uint64)`
- `void Audio_SetMasterVolume(float)`
- `float Audio_GetMasterVolume()`
- `void Audio_SetChannelVolume(uint8, float)`
- `float Audio_GetChannelVolume(uint8)`
- `void Audio_StopChannel(uint8)`


---

## AudioGraph

### Functions
- `void AudioGraph_TriggerEvent(const string &in)`
- `void AudioGraph_SetParameter(const string &in, float)`
- `float AudioGraph_GetParameter(const string &in)`
- `void AudioGraph_StopAll()`


---

## AudioReactive

### Functions
- `void RTPC_SetParameter(uint64, const string &in, float)`
- `float RTPC_GetParameter(uint64, const string &in)`
- `float BeatClock_GetBPM(uint64)`
- `void BeatClock_SetBPM(uint64, float)`
- `uint BeatClock_GetCurrentBeat(uint64)`
- `uint BeatClock_GetCurrentBar(uint64)`
- `bool BeatClock_IsBeatThisFrame(uint64)`
- `bool BeatClock_IsDownbeatThisFrame(uint64)`
- `void Conductor_SetState(uint64, int)`
- `int Conductor_GetState(uint64)`
- `void AudioReactive_SetEnabled(uint64, bool)`
- `float AudioReactive_GetCurrentValue(uint64)`
- `void Sidechain_SetEnabled(uint64, bool)`
- `bool Sidechain_IsDucking(uint64)`
- `void Morph_SetWeight(uint64, const string &in, float)`
- `float Morph_GetWeight(uint64, const string &in)`
- `int Morph_GetTargetCount(uint64)`


---

## Components

### Functions
- `float Health_Get(uint64)`
- `float Health_GetMax(uint64)`
- `void Health_SetCurrent(uint64, float)`
- `void Health_Damage(uint64, float)`
- `void GameOver_Trigger(uint64, bool)`
- `bool GameOver_IsTriggered(uint64)`
- `void GameOver_SetMessages(uint64, const string &in, const string &in)`
- `void Material_SetBaseColor(uint64, const Vector3 &in)`
- `void Material_SetBaseColorTexture(uint64, const string &in)`
- `void Material_SetEmissiveTexture(uint64, const string &in)`
- `void Material_SetNormalTexture(uint64, const string &in)`
- `Vector3 Material_GetBaseColor(uint64)`
- `void Material_SetMetallic(uint64, float)`
- `void Material_SetRoughness(uint64, float)`
- `void Material_SetTransmission(uint64, float)`
- `float Material_GetTransmission(uint64)`
- `void Material_SetIOR(uint64, float)`
- `float Material_GetIOR(uint64)`
- `void Material_SetThickness(uint64, float)`
- `float Material_GetThickness(uint64)`
- `void Material_SetSSSIntensity(uint64, float)`
- `float Material_GetSSSIntensity(uint64)`
- `void Material_SetSSSRadius(uint64, float)`
- `float Material_GetSSSRadius(uint64)`
- `void Material_SetSSSColor(uint64, const Vector3 &in)`
- `Vector3 Material_GetSSSColor(uint64)`
- `void Light_SetColor(uint64, const Vector3 &in)`
- `Vector3 Light_GetColor(uint64)`
- `void Light_SetIntensity(uint64, float)`
- `float Light_GetIntensity(uint64)`
- `void Light_SetRange(uint64, float)`
- `float Light_GetRange(uint64)`
- `void Light_SetType(uint64, int)`
- `int Light_GetType(uint64)`
- `void Light_SetCastShadows(uint64, bool)`
- `bool Light_GetCastShadows(uint64)`
- `void Light_SetSpotAngles(uint64, float, float)`
- `void Camera_SetFOV(uint64, float)`
- `float Camera_GetFOV(uint64)`
- `void Camera_ApplyPreset(uint64, int)`
- `string Camera_GetPresetName(int)`
- `void Camera_SetOrthoSize(uint64, float)`
- `float Camera_GetOrthoSize(uint64)`
- `void Camera_SetNearFar(uint64, float, float)`
- `void Camera_SetProjectionType(uint64, int)`
- `int Camera_GetProjectionType(uint64)`
- `void AudioSource_Play(uint64)`
- `void AudioSource_Stop(uint64)`
- `void AudioSource_SetClip(uint64, const string &in)`
- `void AudioSource_SetVolume(uint64, float)`
- `void Animator_Play(uint64, const string &in)`
- `void Animator_SetSpeed(uint64, float)`
- `void Animator_Stop(uint64)`
- `void Animator_Pause(uint64)`
- `void Animator_Resume(uint64)`
- `bool Animator_IsPlaying(uint64)`
- `string Animator_GetCurrentAnimation(uint64)`
- `float Animator_GetSpeed(uint64)`
- `void Animator_CrossFade(uint64, const string &in, float)`
- `void Controller_SetMoveSpeed(uint64, float)`
- `void Controller_SetIgnoreTimeScale(uint64, bool)`
- `bool Controller_GetIgnoreTimeScale(uint64)`
- `void Controller_SetEnabled(uint64, bool)`
- `void Viewmodel_Set(uint64, bool)`
- `bool Viewmodel_Get(uint64)`
- `Vector3 Controller_GetVelocity(uint64)`
- `void Controller_SetThirdPersonCamera(uint64, float, float, float)`
- `void Controller_SetCameraYaw(uint64, float)`
- `float Controller_GetCameraYaw(uint64)`
- `void Controller_SetMouseLook(uint64, bool)`
- `bool Camera_HasVCam(uint64)`
- `void Camera_SetVCamPriority(uint64, int)`
- `int Camera_GetVCamPriority(uint64)`
- `void Camera_SetVCamEnabled(uint64, bool)`
- `bool Camera_IsVCamLive(uint64)`
- `void Camera_SetVCamOffset(uint64, float, float, float)`
- `void Camera_SetVCamFOV(uint64, float)`
- `void Camera_ApplyVCamShot(uint64, int)`
- `void Camera_TakeManualControl(uint64)`
- `void Camera_ReleaseManualControl()`
- `bool Camera_IsManualControl()`
- `bool HasComponent_Health(uint64)`
- `bool HasComponent_Light(uint64)`
- `bool HasComponent_Camera(uint64)`
- `bool HasComponent_Material(uint64)`
- `bool HasComponent_AudioSource(uint64)`
- `bool HasComponent_Rigidbody(uint64)`
- `bool HasComponent_BoxCollider(uint64)`
- `bool HasComponent_Animator(uint64)`
- `void Camera2D_Shake(uint64, float, float)`
- `float Camera2D_GetZoom(uint64)`
- `void Camera2D_SetZoom(uint64, float)`
- `void Camera2D_AddTarget(uint64, uint64)`
- `void Camera2D_RemoveTarget(uint64, uint64)`
- `void Camera2D_ClearTargets(uint64)`
- `void Camera2D_SetDeadZone(uint64, float, float)`
- `void Camera2D_SetLookAhead(uint64, float, float)`
- `void Camera2D_SetFollowTarget(uint64, uint64)`
- `uint64 Camera2D_GetFollowTarget(uint64)`
- `Vector3 Rigidbody_GetVelocity(uint64)`
- `void Rigidbody_SetVelocity(uint64, float, float, float)`
- `Vector3 Rigidbody_GetAngularVelocity(uint64)`
- `void Rigidbody_SetAngularVelocity(uint64, float, float, float)`
- `float Rigidbody_GetMass(uint64)`
- `void Rigidbody_SetMass(uint64, float)`
- `bool Rigidbody_GetUseGravity(uint64)`
- `void Rigidbody_SetUseGravity(uint64, bool)`
- `bool Rigidbody_IsKinematic(uint64)`
- `void Rigidbody_SetKinematic(uint64, bool)`
- `float Rigidbody_GetDrag(uint64)`
- `void Rigidbody_SetDrag(uint64, float)`
- `float Rigidbody_GetAngularDrag(uint64)`
- `void Rigidbody_SetAngularDrag(uint64, float)`
- `bool Rigidbody_IsGrounded(uint64)`
- `float Rigidbody_GetGravityScale(uint64)`
- `void Rigidbody_SetGravityScale(uint64, float)`
- `Vector3 BoxCollider_GetSize(uint64)`
- `void BoxCollider_SetSize(uint64, float, float, float)`
- `Vector3 BoxCollider_GetCenter(uint64)`
- `void BoxCollider_SetCenter(uint64, float, float, float)`
- `bool BoxCollider_IsTrigger(uint64)`
- `void BoxCollider_SetTrigger(uint64, bool)`
- `uint BoxCollider_GetCategoryBits(uint64)`
- `void BoxCollider_SetCategoryBits(uint64, uint)`
- `uint BoxCollider_GetCollisionMask(uint64)`
- `void BoxCollider_SetCollisionMask(uint64, uint)`
- `float BoxCollider_GetFriction(uint64)`
- `void BoxCollider_SetFriction(uint64, float)`
- `float BoxCollider_GetBounciness(uint64)`
- `void BoxCollider_SetBounciness(uint64, float)`
- `bool HasComponent_SphereCollider(uint64)`
- `float SphereCollider_GetRadius(uint64)`
- `void SphereCollider_SetRadius(uint64, float)`
- `Vector3 SphereCollider_GetCenter(uint64)`
- `void SphereCollider_SetCenter(uint64, float, float, float)`
- `bool SphereCollider_IsTrigger(uint64)`
- `void SphereCollider_SetTrigger(uint64, bool)`
- `uint SphereCollider_GetCategoryBits(uint64)`
- `void SphereCollider_SetCategoryBits(uint64, uint)`
- `uint SphereCollider_GetCollisionMask(uint64)`
- `void SphereCollider_SetCollisionMask(uint64, uint)`
- `float SphereCollider_GetFriction(uint64)`
- `void SphereCollider_SetFriction(uint64, float)`
- `float SphereCollider_GetBounciness(uint64)`
- `void SphereCollider_SetBounciness(uint64, float)`
- `bool HasComponent_CapsuleCollider(uint64)`
- `float CapsuleCollider_GetRadius(uint64)`
- `void CapsuleCollider_SetRadius(uint64, float)`
- `float CapsuleCollider_GetHeight(uint64)`
- `void CapsuleCollider_SetHeight(uint64, float)`
- `Vector3 CapsuleCollider_GetCenter(uint64)`
- `void CapsuleCollider_SetCenter(uint64, float, float, float)`
- `bool CapsuleCollider_IsTrigger(uint64)`
- `void CapsuleCollider_SetTrigger(uint64, bool)`
- `float CapsuleCollider_GetFriction(uint64)`
- `void CapsuleCollider_SetFriction(uint64, float)`
- `float CapsuleCollider_GetBounciness(uint64)`
- `void CapsuleCollider_SetBounciness(uint64, float)`
- `bool HasComponent_TriggerZone(uint64)`
- `int TriggerZone_GetShape(uint64)`
- `void TriggerZone_SetShape(uint64, int)`
- `Vector3 TriggerZone_GetBoxSize(uint64)`
- `void TriggerZone_SetBoxSize(uint64, float, float, float)`
- `float TriggerZone_GetSphereRadius(uint64)`
- `void TriggerZone_SetSphereRadius(uint64, float)`
- `bool TriggerZone_GetTriggerOnce(uint64)`
- `void TriggerZone_SetTriggerOnce(uint64, bool)`
- `bool HasComponent_Interactable(uint64)`
- `string Interactable_GetPrompt(uint64)`
- `void Interactable_SetPrompt(uint64, const string &in)`
- `float Interactable_GetRange(uint64)`
- `void Interactable_SetRange(uint64, float)`
- `bool Interactable_IsEnabled(uint64)`
- `void Interactable_SetEnabled(uint64, bool)`
- `bool Interactable_HasBeenUsed(uint64)`
- `bool HasComponent_Pickup(uint64)`
- `int Pickup_GetType(uint64)`
- `void Pickup_SetType(uint64, int)`
- `float Pickup_GetValue(uint64)`
- `void Pickup_SetValue(uint64, float)`
- `string Pickup_GetCustomId(uint64)`
- `void Pickup_SetCustomId(uint64, const string &in)`
- `float Pickup_GetRange(uint64)`
- `void Pickup_SetRange(uint64, float)`
- `bool Pickup_GetDestroyOnPickup(uint64)`
- `void Pickup_SetDestroyOnPickup(uint64, bool)`
- `bool HasComponent_Inventory(uint64)`
- `int Inventory_GetItemCount(uint64, const string &in)`
- `bool Inventory_AddItem(uint64, const string &in, int)`
- `bool Inventory_RemoveItem(uint64, const string &in, int)`
- `bool Inventory_HasItem(uint64, const string &in)`
- `void Inventory_Clear(uint64)`
- `int Inventory_GetCoins(uint64)`
- `void Inventory_SetCoins(uint64, int)`
- `int Inventory_GetGems(uint64)`
- `void Inventory_SetGems(uint64, int)`
- `bool Inventory_HasKey(uint64, const string &in)`
- `void Inventory_AddKey(uint64, const string &in)`
- `bool HasComponent_Timer(uint64)`
- `float Timer_GetDuration(uint64)`
- `void Timer_SetDuration(uint64, float)`
- `float Timer_GetElapsed(uint64)`
- `void Timer_SetElapsed(uint64, float)`
- `bool Timer_IsRunning(uint64)`
- `void Timer_SetRunning(uint64, bool)`
- `bool Timer_GetLoop(uint64)`
- `void Timer_SetLoop(uint64, bool)`
- `float Timer_GetProgress(uint64)`
- `float Timer_GetRemaining(uint64)`
- `bool Timer_IsComplete(uint64)`
- `float Health_GetShield(uint64)`
- `void Health_SetShield(uint64, float)`
- `void Health_SetMaxHealth(uint64, float)`
- `bool Health_IsDead(uint64)`
- `bool Health_IsInvulnerable(uint64)`
- `void Health_SetInvulnerable(uint64, bool)`
- `float Health_GetPercent(uint64)`
- `void Health_Heal(uint64, float)`
- `bool HasComponent_Lock(uint64)`
- `bool Lock_IsLocked(uint64)`
- `void Lock_SetLocked(uint64, bool)`
- `string Lock_GetRequiredKey(uint64)`
- `bool Lock_IsOpen(uint64)`
- `void Lock_SetOpen(uint64, bool)`
- `bool HasComponent_Switch(uint64)`
- `bool Switch_IsActive(uint64)`
- `void Switch_SetActive(uint64, bool)`
- `int Switch_GetLinkedCount(uint64)`
- `uint64 Switch_GetLinkedEntity(uint64, int)`
- `string Switch_GetPrompt(uint64)`
- `bool HasComponent_GoalZone(uint64)`
- `bool GoalZone_IsSatisfied(uint64)`
- `string GoalZone_GetRequiredTag(uint64)`
- `int GoalZone_GetGoalGroup(uint64)`
- `string GoalZone_GetNextScene(uint64)`
- `bool HasComponent_Conveyor(uint64)`
- `Vector3 Conveyor_GetDirection(uint64)`
- `void Conveyor_SetDirection(uint64, float, float, float)`
- `float Conveyor_GetSpeed(uint64)`
- `void Conveyor_SetSpeed(uint64, float)`
- `bool Conveyor_IsActive(uint64)`
- `void Conveyor_SetActive(uint64, bool)`
- `bool HasComponent_Teleporter(uint64)`
- `Vector3 Teleporter_GetDestination(uint64)`
- `void Teleporter_SetDestination(uint64, float, float, float)`
- `float Teleporter_GetCooldown(uint64)`
- `void Teleporter_SetCooldown(uint64, float)`
- `bool Teleporter_GetPreserveVelocity(uint64)`
- `void Teleporter_SetPreserveVelocity(uint64, bool)`
- `bool HasComponent_MovingPlatform(uint64)`
- `float MovingPlatform_GetSpeed(uint64)`
- `void MovingPlatform_SetSpeed(uint64, float)`
- `bool MovingPlatform_IsMoving(uint64)`
- `void MovingPlatform_SetMoving(uint64, bool)`
- `int MovingPlatform_GetWaypointCount(uint64)`
- `float MovingPlatform_GetWaitTime(uint64)`
- `void MovingPlatform_SetWaitTime(uint64, float)`
- `bool HasComponent_Damage(uint64)`
- `float Damage_GetDamage(uint64)`
- `void Damage_SetDamage(uint64, float)`
- `float Damage_GetKnockback(uint64)`
- `void Damage_SetKnockback(uint64, float)`
- `float Damage_GetInterval(uint64)`
- `void Damage_SetInterval(uint64, float)`
- `bool HasComponent_Resource(uint64)`
- `float Resource_GetValue(uint64)`
- `void Resource_SetValue(uint64, float)`
- `float Resource_GetMax(uint64)`
- `void Resource_SetMax(uint64, float)`
- `float Resource_GetPercent(uint64)`
- `bool Resource_TryConsume(uint64, float)`
- `bool Resource_IsDepleted(uint64)`
- `string Resource_GetName(uint64)`
- `bool HasComponent_LOD(uint64)`
- `int LOD_GetCurrentLOD(uint64)`
- `int LOD_GetLevelCount(uint64)`
- `bool LOD_IsEnabled(uint64)`
- `void LOD_SetEnabled(uint64, bool)`
- `bool HasComponent_Layer(uint64)`
- `uint Layer_GetLayer(uint64)`
- `void Layer_SetLayer(uint64, uint)`
- `string Layer_GetName(uint64)`
- `bool HasComponent_Notes(uint64)`
- `string Notes_Get(uint64)`
- `void Notes_Set(uint64, const string &in)`
- `bool HasComponent_Tag(uint64)`
- `int Tag_GetCount(uint64)`
- `string Tag_GetAt(uint64, int)`
- `void Tag_Add(uint64, const string &in)`
- `void Tag_Remove(uint64, const string &in)`
- `bool Tag_Has(uint64, const string &in)`
- `bool HasComponent_Tilemap(uint64)`
- `int Tilemap_GetTile(uint64, int, int)`
- `void Tilemap_SetTile(uint64, int, int, int)`
- `int Tilemap_GetWidth(uint64)`
- `int Tilemap_GetHeight(uint64)`


---

## Dialogue

### Functions
- `void Dialogue_Start(uint64)`
- `void Dialogue_Advance(uint64)`
- `void Dialogue_Choose(uint64, uint)`
- `void Dialogue_SetVariable(uint64, const string&in, const string&in)`
- `string Dialogue_GetVariable(uint64, const string&in)`
- `bool Dialogue_IsActive(uint64)`
- `string Dialogue_GetCurrentSpeaker(uint64)`
- `string Dialogue_GetCurrentText(uint64)`
- `uint Dialogue_GetChoiceCount(uint64)`
- `string Dialogue_GetChoiceText(uint64, uint)`


---

## Elemental

### Functions
- `uint Elemental_SpawnFire(float, float, float, float, float)`
- `uint Elemental_SpawnWater(float, float, float, float, float, float, float)`
- `uint Elemental_SpawnEarth(float, float, float, float, float, float, float)`
- `uint Elemental_SpawnSnow(float, float, float, float)`
- `uint Elemental_SpawnSteam(float, float, float, float)`
- `void Elemental_SpawnRainBurst(float, float, float, float, int)`
- `void Elemental_SpawnDebrisBurst(float, float, float, float, float, float, int)`
- `float Elemental_GetFireIntensityAt(float, float, float, float)`
- `float Elemental_GetMoistureAt(float, float, float, float)`
- `int Elemental_GetActiveCount()`
- `int Elemental_GetFireCount()`
- `int Elemental_GetWaterCount()`
- `bool Elemental_HasEmitter(uint64)`
- `void Elemental_SetEmitterActive(uint64, bool)`
- `bool Elemental_IsEmitterActive(uint64)`
- `void Elemental_SetEmitterElement(uint64, float, float, float, float)`
- `void Elemental_SetEmitterRate(uint64, float)`
- `float Elemental_GetEmitterRate(uint64)`
- `void Elemental_SetEmitterIntensity(uint64, float)`
- `bool Elemental_HasSurface(uint64)`
- `float Elemental_GetSurfaceChar(uint64)`
- `float Elemental_GetSurfaceWetness(uint64)`
- `float Elemental_GetSurfaceSnow(uint64)`
- `float Elemental_GetSurfaceFrost(uint64)`
- `void Elemental_SetFlammability(uint64, float)`
- `float Elemental_GetFlammability(uint64)`
- `bool Elemental_HasVolume(uint64)`
- `void Elemental_SetVolumeKill(uint64, bool)`
- `void Elemental_SetVolumeTempBias(uint64, float)`


---

## Flower

### Functions
- `float Flower_GetTension(uint64)`
- `bool Flower_IsBroken(uint64)`
- `bool Flower_JustBroke(uint64)`
- `void Flower_SetMaxDistance(uint64, float)`
- `float Flower_GetMaxDistance(uint64)`
- `void Flower_SetSpringK(uint64, float)`
- `void Flower_SetDamping(uint64, float)`
- `bool Flower_IsGrabbed(uint64)`
- `void Flower_SetGrabRadius(uint64, float)`
- `float Flower_GetGrabRadius(uint64)`
- `void Flower_SetGrabSpring(uint64, float)`
- `float Flower_GetGrabSpring(uint64)`
- `float Flower_GetScore(uint64)`
- `int Flower_GetPartsRemoved(uint64)`
- `bool Flower_IsEvaluated(uint64)`
- `void Flower_SetSapColor(uint64, float, float, float)`
- `void Flower_SetLiquidIntensity(uint64, float)`
- `void Flower_SetGroundLevel(uint64, float)`
- `void Flower_SetJellyStiffness(uint64, float)`
- `void Flower_SetJellyDamping(uint64, float)`
- `bool Flower_HasTether(uint64)`
- `bool Flower_HasGrabbable(uint64)`
- `bool Flower_HasStem(uint64)`
- `bool Flower_HasJelly(uint64)`


---

## Gameplay

### Functions
- `void Quest_Start(const string &in)`
- `void Quest_CompleteObjective(const string &in, int)`
- `void Quest_Fail(const string &in)`
- `bool Quest_IsActive(const string &in)`
- `bool Quest_IsComplete(const string &in)`
- `void Cinematic_Play(uint64)`
- `void Cinematic_Stop(uint64)`
- `bool Cinematic_IsPlaying()`
- `uint64 Pool_Acquire(const string &in)`
- `void Pool_Release(const string &in, uint64)`
- `void Destructible_Destroy(uint64, float, float, float, float)`
- `void Destructible_ApplyDamage(uint64, float)`
- `void Destructible_ApplyDamageAt(uint64, float, float, float, float)`


---

## GameplayComponents

### Functions
- `void LookAt_SetTarget(uint64, uint64)`
- `void LookAt_SetTargetPosition(uint64, float, float, float)`
- `void LookAt_ClearTarget(uint64)`
- `void LookAt_SetSpeed(uint64, float)`
- `float LookAt_GetSpeed(uint64)`
- `void LookAt_SetInstant(uint64, bool)`
- `void LookAt_SetConstraints(uint64, bool, bool, bool)`
- `void DamageResist_Set(uint64, const string &in, float)`
- `float DamageResist_Get(uint64, const string &in)`
- `void Ragdoll_SetActive(uint64, bool)`
- `bool Ragdoll_IsActive(uint64)`
- `void Ragdoll_SetBlendWeight(uint64, float)`
- `void Ragdoll_SetGravityScale(uint64, float)`
- `void Pushable_SetAxes(uint64, bool, bool, bool)`
- `void Pushable_SetPushSpeed(uint64, float)`
- `bool Pushable_IsBeingPushed(uint64)`
- `void TempZone_SetTemperature(uint64, float)`
- `float TempZone_GetTemperature(uint64)`
- `void TempZone_SetPriority(uint64, int)`
- `void ReflectionProbe_SetIntensity(uint64, float)`
- `float ReflectionProbe_GetIntensity(uint64)`
- `void ReflectionProbe_SetActive(uint64, bool)`
- `bool ReflectionProbe_IsActive(uint64)`
- `void Billboard_SetFaceCamera(uint64, bool)`
- `void Billboard_SetLockY(uint64, bool)`
- `void Billboard_SetRotationOffset(uint64, float)`
- `bool Possessable_IsPossessed(uint64)`
- `void Possessable_SetPrompt(uint64, const string &in)`
- `void Possessable_SetRange(uint64, float)`
- `void Possessable_SetPlayerIndex(uint64, int)`
- `void SavePoint_SetSlot(uint64, int)`
- `void SavePoint_SetSaveOnEnter(uint64, bool)`
- `bool SavePoint_IsUsed(uint64)`
- `void SavePoint_SetRadius(uint64, float)`
- `void SavePoint_SetMessage(uint64, const string &in)`
- `void Footstep_SetVolume(uint64, float)`
- `void Footstep_SetWalkInterval(uint64, float)`
- `void Footstep_SetRunInterval(uint64, float)`
- `void Footstep_SetPitchVariance(uint64, float)`
- `void Reverb_SetActive(uint64, bool)`
- `void Reverb_SetRoomSize(uint64, float)`
- `void Reverb_SetDamping(uint64, float)`
- `void Reverb_SetWetDryMix(uint64, float)`
- `void Reverb_SetDecayTime(uint64, float)`
- `void Lens_SetEnabled(uint64, bool)`
- `void Lens_SetDistortion(uint64, float)`
- `void Lens_SetChromaticAberration(uint64, float)`
- `void Lens_SetVignette(uint64, float, float)`
- `void Lens_SetAnamorphicSqueeze(uint64, float)`
- `void SpringJoint_SetRestLength(uint64, float)`
- `void SpringJoint_SetStiffness(uint64, float)`
- `void SpringJoint_SetDamping(uint64, float)`
- `float SpringJoint_GetStress(uint64)`
- `void SliderJoint_SetMotor(uint64, bool, float, float)`
- `void SliderJoint_SetLimits(uint64, bool, float, float)`
- `float SliderJoint_GetDisplacement(uint64)`
- `void FixedJoint_SetBreakable(uint64, bool, float)`
- `void BallSocket_SetConeLimit(uint64, bool, float)`
- `void BallSocket_SetTwistLimit(uint64, bool, float, float)`


---

## HUD

### Functions
- `void HUD_SetVisible(uint64, bool)`
- `bool HUD_IsVisible(uint64)`
- `void HUD_SetText(uint64, const string &in)`
- `string HUD_GetText(uint64)`
- `void HUD_SetValue(uint64, float, float)`
- `float HUD_GetValue(uint64)`
- `float HUD_GetMaxValue(uint64)`
- `void HUD_SetFillColor(uint64, float, float, float)`
- `void HUD_SetTextColor(uint64, float, float, float)`
- `void HUD_SetPosition(uint64, float, float)`
- `void HUD_SetSize(uint64, float, float)`
- `void HUD_SetFontSize(uint64, float)`
- `void HUD_SetBindField(uint64, const string &in)`
- `void HUD_SetSourceEntity(uint64, uint64)`
- `void HUD_SetWorldOffset(uint64, const Vector3 &in)`


---

## Input

### Enums
- `GamepadAx` = { LeftX, LeftY, RightX, RightY, LeftTrigger, RightTrigger }
- `GamepadBtn` = { A, B, X, Y, LeftBumper, RightBumper, Back, Start, DPadUp, DPadRight, DPadDown, DPadLeft }
- `Key` = { A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, Num0, Num1, Num2, Num3, Num4, Num5, Num6, Num7, Num8, Num9, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, Space, Escape, Enter, Tab, Backspace, Insert, Delete, Apostrophe, Comma, Minus, Period, Slash, Semicolon, Equal, LeftBracket, Backslash, RightBracket, GraveAccent, Right, Left, Down, Up, LeftShift, LeftControl, LeftAlt, RightShift, RightControl, RightAlt }
- `MouseBtn` = { Left, Right, Middle }

### Functions
- `bool Input_GetKey(int)`
- `bool Input_GetKeyDown(int)`
- `bool Input_GetKeyUp(int)`
- `string Input_GetTextInput()`
- `int Input_GetTextInputCount()`
- `bool Input_GetMouseButton(int)`
- `bool Input_GetMouseButtonDown(int)`
- `bool Input_GetMouseButtonUp(int)`
- `Vector2 Input_GetMousePosition()`
- `Vector2 Input_GetMouseDelta()`
- `Vector2 Input_GetScrollDelta()`
- `bool Input_IsMouseCaptured()`
- `void Input_SetMouseCaptured(bool)`
- `bool Input_IsGamepadConnected(int)`
- `bool Input_GetGamepadButton(int, int)`
- `bool Input_GetGamepadButtonDown(int, int)`
- `float Input_GetGamepadAxis(int, int)`
- `Vector2 Input_GetGamepadLeftStick(int)`
- `Vector2 Input_GetGamepadRightStick(int)`
- `float Input_GetGamepadLeftTrigger(int)`
- `float Input_GetGamepadRightTrigger(int)`
- `void Touch_UsePreset(int)`
- `void Touch_ClearButtons()`
- `void Touch_AddButton(const string &in, int, float, float, float)`
- `void Touch_AddActionButton(const string &in, int, float, float, float)`
- `void Touch_SetStick(bool, int, int, int, int)`
- `void Touch_SetStickActions(bool, int, int, int, int)`
- `void Touch_SetLookRegion(bool)`


---

## InputAction

### Enums
- `GameAction` = { MoveForward, MoveBack, MoveLeft, MoveRight, Jump, Sprint, Crouch, Dash, Interact, Attack, Block, Pause, LookUp, LookDown, LookLeft, LookRight, CameraZoomIn, CameraZoomOut }

### Functions
- `bool InputAction_IsDown(int action)`
- `bool InputAction_IsPressed(int action)`
- `bool InputAction_IsReleased(int action)`
- `float InputAction_GetValue(int action)`
- `Vector2 InputAction_GetMovement()`
- `void InputAction_SetSensitivity(int action, float sensitivity)`
- `float InputAction_GetMouseSensitivity()`
- `void InputAction_SetMouseSensitivity(float sens)`
- `bool InputAction_IsSprintToggle()`
- `void InputAction_SetSprintToggle(bool toggle)`
- `bool InputAction_IsCrouchToggle()`
- `void InputAction_SetCrouchToggle(bool toggle)`
- `void InputAction_Rebind(int actionIndex, int keyCode)`
- `int InputAction_PollNextKey()`
- `int InputAction_GetCount()`
- `string InputAction_GetName(int index)`
- `string InputAction_GetBindingName(int index)`
- `void InputAction_ApplyLeftHandOnly()`
- `void InputAction_ApplyRightHandOnly()`
- `void InputAction_ApplyGamepadOnly()`
- `void InputAction_ResetDefaults()`


---

## MIDI

### Functions
- `uint32 MIDI_GetDeviceCount()`
- `string MIDI_GetDeviceName(uint32)`
- `bool MIDI_OpenDevice(uint32)`
- `void MIDI_CloseDevice()`
- `bool MIDI_IsDeviceOpen()`
- `bool MIDI_IsNoteOn(uint8, uint8 = 0xFF)`
- `bool MIDI_IsNoteOff(uint8, uint8 = 0xFF)`
- `uint8 MIDI_GetNoteVelocity(uint8, uint8 = 0xFF)`
- `uint8 MIDI_GetCC(uint8, uint8 = 0xFF)`
- `uint8 MIDI_GetCCValue(uint8, uint8 = 0)`
- `uint32 MIDI_GetEventCount()`


---

## Networking

### Enums
- `NetworkRole` = { None, Host, Client }

### Functions
- `bool Net_HostGame(int, const string &in)`
- `bool Net_JoinGame(const string &in, int, const string &in)`
- `void Net_Disconnect()`
- `bool Net_IsConnected()`
- `bool Net_IsHost()`
- `int Net_GetRole()`
- `int Net_GetLocalPlayerId()`
- `int Net_GetPlayerCount()`
- `float Net_GetPing()`
- `float Net_GetPacketLoss()`
- `void Net_SetReady(bool)`
- `int Net_GetLobbyPlayerCount()`
- `string Net_GetLobbyPlayerName(int)`
- `bool Net_GetLobbyPlayerReady(int)`
- `int Net_RegisterEntity(uint64)`
- `void Net_UnregisterEntity(int)`
- `void Net_RequestOwnership(int)`
- `void Net_CallRPC(const string &in, int, const string &in)`
- `void Net_CallRPCAll(const string &in, const string &in)`
- `void Net_RegisterRPCHandler(const string &in)`


---

## Noise

### Functions
- `float Noise_Value2D(float, float, uint)`
- `float Noise_Perlin2D(float, float, uint)`
- `float Noise_Simplex2D(float, float, uint)`
- `float Noise_Worley2D(float, float, uint)`
- `float Noise_Value3D(float, float, float, uint)`
- `float Noise_Perlin3D(float, float, float, uint)`
- `float Noise_Simplex3D(float, float, float, uint)`
- `float Noise_Worley3D(float, float, float, uint)`
- `float Noise_FBM2D(float, float, int, float, float, float, uint)`
- `float Noise_Ridged2D(float, float, int, float, float, float, uint)`
- `float Noise_Billow2D(float, float, int, float, float, float, uint)`
- `float Noise_FBM3D(float, float, float, int, float, float, float, uint)`
- `float Noise_Ridged3D(float, float, float, int, float, float, float, uint)`
- `float Noise_Billow3D(float, float, float, int, float, float, float, uint)`
- `float Noise_DomainWarp2D(float, float, float, float, uint)`
- `float Noise_DomainWarp3D(float, float, float, float, float, uint)`


---

## Particles

### Functions
- `void Particle_Play(uint64)`
- `void Particle_Stop(uint64)`
- `bool Particle_IsPlaying(uint64)`
- `void Particle_SetEmissionRate(uint64, float)`
- `float Particle_GetEmissionRate(uint64)`
- `void Particle_Burst(uint64, int)`
- `void Particle_SetLifetime(uint64, float)`
- `void Particle_SetSpeed(uint64, float)`
- `void Particle_SetSize(uint64, float, float)`
- `void Particle_SetColor(uint64, float, float, float, float, float, float)`
- `void Particle_SetAlpha(uint64, float, float)`
- `void Particle_SetLoop(uint64, bool)`
- `void Particle_SetGravity(uint64, float, float, float)`
- `void Particle_ApplyPreset(uint64, const string &in)`
- `void GPUParticle_Burst(uint64, int)`


---

## Physics

### Types
- `RaycastHit`
    - Vector3 point
    - Vector3 normal
    - float distance
    - uint64 entity
    - void f()  // behaviour
    - void f(const RaycastHit &in)  // behaviour

### Functions
- `bool Physics_Raycast(const Vector3 &in, const Vector3 &in, float)`
- `bool Physics_RaycastHit(const Vector3 &in, const Vector3 &in, float, RaycastHit &out)`
- `uint64 Physics_RaycastScreen(float, float)`
- `Vector2 Input_GetScreenSize()`
- `bool Physics_CheckSphere(const Vector3 &in, float)`
- `bool Physics_CheckBox(const Vector3 &in, const Vector3 &in)`
- `bool Physics_Raycast(const Vector3 &in, const Vector3 &in, float, uint)`
- `bool Physics_RaycastHit(const Vector3 &in, const Vector3 &in, float, uint, RaycastHit &out)`
- `bool Physics_CheckSphere(const Vector3 &in, float, uint)`
- `bool Physics_CheckBox(const Vector3 &in, const Vector3 &in, uint)`
- `void Physics_AddForce(uint64, const Vector3 &in)`
- `void Physics_AddImpulse(uint64, const Vector3 &in)`
- `void Physics_SetVelocity(uint64, const Vector3 &in)`
- `void Physics_Teleport(uint64, const Vector3 &in)`
- `Vector3 Physics_GetVelocity(uint64)`
- `void Physics_SetGravityScale(uint64, float)`
- `uint64 Physics_CreateDistanceJoint(uint64, uint64, float)`
- `uint64 Physics_CreateHingeJoint(uint64, uint64, float, float, float)`
- `void Physics_DestroyJoint(uint64)`
- `void DistanceJoint_SetRestDistance(uint64, float)`
- `float DistanceJoint_GetCurrentStress(uint64)`
- `void HingeJoint_SetLimits(uint64, float, float)`
- `void HingeJoint_SetMotor(uint64, float, float)`
- `float HingeJoint_GetCurrentAngle(uint64)`
- `int Physics_OverlapSphereEntities(const Vector3 &in, float)`
- `int Physics_OverlapSphereEntitiesMask(const Vector3 &in, float, uint)`
- `int Physics_OverlapBoxEntities(const Vector3 &in, const Vector3 &in)`
- `int Physics_OverlapBoxEntitiesMask(const Vector3 &in, const Vector3 &in, uint)`
- `uint64 Physics_GetOverlapResult(int)`


---

## Physics2D

### Functions
- `bool Physics2D_Raycast(const Vector2 &in, const Vector2 &in, float)`
- `bool Physics2D_RaycastMask(const Vector2 &in, const Vector2 &in, float, uint)`
- `uint64 Physics2D_RaycastHit(const Vector2 &in, const Vector2 &in, float)`
- `uint64 Physics2D_RaycastHitMask(const Vector2 &in, const Vector2 &in, float, uint)`
- `bool Physics2D_OverlapCircle(const Vector2 &in, float)`
- `bool Physics2D_OverlapCircleMask(const Vector2 &in, float, uint)`
- `bool Physics2D_OverlapBox(const Vector2 &in, const Vector2 &in)`
- `bool Physics2D_OverlapBoxMask(const Vector2 &in, const Vector2 &in, uint)`
- `void Physics2D_AddForce(uint64, const Vector2 &in)`
- `void Physics2D_AddImpulse(uint64, const Vector2 &in)`
- `void Physics2D_SetVelocity(uint64, const Vector2 &in)`
- `Vector2 Physics2D_GetVelocity(uint64)`
- `void Physics2D_SetGravity(const Vector2 &in)`
- `Vector2 Physics2D_GetGravity()`
- `void Physics2D_SetGravityScale(uint64, float)`
- `int Physics2D_OverlapCircleEntities(const Vector2 &in, float)`
- `int Physics2D_OverlapCircleEntitiesMask(const Vector2 &in, float, uint)`
- `int Physics2D_OverlapBoxEntities(const Vector2 &in, const Vector2 &in)`
- `int Physics2D_OverlapBoxEntitiesMask(const Vector2 &in, const Vector2 &in, uint)`
- `uint64 Physics2D_GetOverlapResult(int)`


---

## Plugin

### Functions
- `bool Plugin_IsLoaded(const string &in)`
- `string Plugin_GetVersion(const string &in)`
- `bool Plugin_Load(const string &in)`
- `void Plugin_Unload(const string &in)`


---

## Prefab

### Functions
- `uint64 Prefab_Instantiate(const string &in, float, float, float)`
- `uint64 Prefab_InstantiateEx(const string &in, float, float, float, float, float, float, float, float, float)`
- `bool Prefab_IsPrefabInstance(uint64)`
- `void Prefab_Unpack(uint64)`


---

## Procedural

### Functions
- `int WFC_Generate(uint64 self)`
- `int TerrainGen_Generate(uint64 self)`
- `int Scatter_Generate(uint64 self)`
- `int Scatter_Clear(uint64 self)`
- `int Scatter_Count(uint64 self)`
- `string RandomBag_Draw(uint64 self)`
- `int RandomBag_DrawIndex(uint64 self)`
- `void RandomBag_Reset(uint64 self)`
- `int RandomBag_Remaining(uint64 self)`
- `int RandomBag_Count(uint64 self)`
- `void ProceduralGen_CellularAutomata(uint width, uint height, uint fillPct, uint smoothPasses, uint seed)`
- `void ProceduralGen_RandomWalker(uint width, uint height, uint steps, uint seed)`
- `void ProceduralGen_BSP(uint width, uint height, uint minRoomSize, uint maxRoomSize, uint seed)`
- `void ProceduralGen_DiamondSquare(uint size, float roughness, uint seed)`
- `string ProceduralGen_LSystem(const string &in axiom, const string &in rules, uint iterations)`
- `void ProceduralGen_Voronoi(uint width, uint height, uint numPoints, uint seed)`
- `void ProceduralGen_WFC(uint width, uint height, uint tileSetSize, uint seed)`
- `string ProceduralGen_Grammar(const string &in rules, const string &in startSymbol, uint seed)`
- `int ProceduralGen_PrefabAssemble(int maxRooms, uint seed)`
- `int ProceduralGen_GetCell(int x, int y)`
- `float ProceduralGen_GetHeight(int x, int y)`
- `int ProceduralGen_GetWidth()`
- `int ProceduralGen_GetGridHeight()`
- `void ProceduralGen_SpawnGrid(float cellSize, int wallValue, int floorValue)`


---

## Render

### Functions
- `void Render_SetShadowsEnabled(bool)`
- `bool Render_IsShadowsEnabled()`
- `void Render_SetShadowDistance(float)`
- `float Render_GetShadowDistance()`
- `void Render_SetShadowStrength(float)`
- `float Render_GetShadowStrength()`
- `uint64 RenderTarget_Create(int width, int height)`
- `void RenderTarget_Destroy(uint64 handle)`
- `void RenderTarget_SetCamera(uint64 handle, uint64 cameraEntity)`
- `bool RenderTarget_BindToEntity(uint64 handle, uint64 entity)`
- `void Render_SetAmbientIntensity(float)`
- `float Render_GetAmbientIntensity()`
- `void Render_SetAmbientColor(const Vector3 &in)`
- `Vector3 Render_GetAmbientColor()`
- `void Render_SetFogDensity(float)`
- `float Render_GetFogDensity()`
- `void Render_SetFogColor(const Vector3 &in)`
- `Vector3 Render_GetFogColor()`
- `void Render_SetFogStart(float)`
- `float Render_GetFogStart()`
- `void Render_SetFogEnd(float)`
- `float Render_GetFogEnd()`
- `void Render_SetFogHeightFalloff(float)`
- `float Render_GetFogHeightFalloff()`
- `void Render_SetSnowIntensity(float)`
- `float Render_GetSnowIntensity()`
- `void Render_SetWorldCurvature(float)`
- `float Render_GetWorldCurvature()`
- `void Render_SetWireframeEnabled(bool)`
- `bool Render_IsWireframeEnabled()`
- `void Render_SetRainActive(bool)`
- `bool Render_IsRainActive()`
- `void PostProcess_SetToneMapping(int)`
- `int PostProcess_GetToneMapping()`
- `void PostProcess_SetExposure(float)`
- `float PostProcess_GetExposure()`
- `void PostProcess_SetGamma(float)`
- `float PostProcess_GetGamma()`
- `void PostProcess_SetBloomEnabled(bool)`
- `bool PostProcess_IsBloomEnabled()`
- `void PostProcess_SetBloomThreshold(float)`
- `float PostProcess_GetBloomThreshold()`
- `void PostProcess_SetBloomIntensity(float)`
- `float PostProcess_GetBloomIntensity()`
- `void PostProcess_SetVignetteEnabled(bool)`
- `bool PostProcess_IsVignetteEnabled()`
- `void PostProcess_SetVignetteIntensity(float)`
- `float PostProcess_GetVignetteIntensity()`
- `void PostProcess_SetVignetteSmoothness(float)`
- `float PostProcess_GetVignetteSmoothness()`
- `void PostProcess_SetChromaticAberrationEnabled(bool)`
- `bool PostProcess_IsChromaticAberrationEnabled()`
- `void PostProcess_SetChromaticAberrationIntensity(float)`
- `float PostProcess_GetChromaticAberrationIntensity()`
- `void PostProcess_SetColorFilter(const Vector3 &in)`
- `Vector3 PostProcess_GetColorFilter()`
- `void PostProcess_SetSaturation(float)`
- `float PostProcess_GetSaturation()`
- `void PostProcess_SetContrast(float)`
- `float PostProcess_GetContrast()`
- `void PostProcess_SetBrightness(float)`
- `float PostProcess_GetBrightness()`
- `void PostProcess_SetFilmGrainEnabled(bool)`
- `bool PostProcess_IsFilmGrainEnabled()`
- `void PostProcess_SetFilmGrainIntensity(float)`
- `float PostProcess_GetFilmGrainIntensity()`
- `void PostProcess_SetFXAAEnabled(bool)`
- `bool PostProcess_IsFXAAEnabled()`
- `void PostProcess_SetGodRaysEnabled(bool)`
- `bool PostProcess_IsGodRaysEnabled()`
- `void PostProcess_SetGodRaysIntensity(float)`
- `float PostProcess_GetGodRaysIntensity()`
- `void PostProcess_SetGodRaysSamples(int)`
- `int PostProcess_GetGodRaysSamples()`
- `void PostProcess_SetSSAOEnabled(bool)`
- `bool PostProcess_IsSSAOEnabled()`
- `void PostProcess_SetSSAORadius(float)`
- `float PostProcess_GetSSAORadius()`
- `void PostProcess_SetSSAOIntensity(float)`
- `float PostProcess_GetSSAOIntensity()`
- `void PostProcess_SetContactShadowsEnabled(bool)`
- `bool PostProcess_IsContactShadowsEnabled()`
- `void PostProcess_SetContactShadowsIntensity(float)`
- `float PostProcess_GetContactShadowsIntensity()`
- `void PostProcess_SetCausticsEnabled(bool)`
- `bool PostProcess_IsCausticsEnabled()`
- `void PostProcess_SetCausticsIntensity(float)`
- `float PostProcess_GetCausticsIntensity()`
- `void PostProcess_SetCausticsWaterY(float)`
- `float PostProcess_GetCausticsWaterY()`
- `void PostProcess_SetFogShaftsEnabled(bool)`
- `bool PostProcess_IsFogShaftsEnabled()`
- `void PostProcess_SetFogShaftsIntensity(float)`
- `float PostProcess_GetFogShaftsIntensity()`
- `void PostProcess_SetFogShaftsMaxDistance(float)`
- `float PostProcess_GetFogShaftsMaxDistance()`
- `void PPVolume_SetActive(uint64, bool)`
- `bool PPVolume_IsActive(uint64)`
- `void PPVolume_SetWeight(uint64, float)`
- `float PPVolume_GetWeight(uint64)`
- `void PPVolume_SetBlendRadius(uint64, float)`
- `float PPVolume_GetBlendRadius(uint64)`
- `void PPVolume_SetPriority(uint64, int)`
- `int PPVolume_GetPriority(uint64)`
- `void PPVolume_SetGlobal(uint64, bool)`
- `bool PPVolume_IsGlobal(uint64)`
- `void Particles_OneShot(const string &in preset, float x, float y, float z, int count)`


---

## Rewind

### Functions
- `void Rewind_StartEntity(uint64)`
- `void Rewind_StopEntity(uint64)`
- `bool Rewind_IsEntityRewinding(uint64)`
- `void Rewind_SetEntityChannels(uint64, uint)`
- `void Rewind_StartScene()`
- `void Rewind_StopScene()`
- `bool Rewind_IsSceneRewinding()`
- `void Rewind_SeekScene(float)`
- `float Rewind_GetRecordedDuration()`
- `float Rewind_GetCurrentTime()`
- `bool Rewind_IsAnyRewinding()`


---

## Save

### Functions
- `bool SaveGame_ToSlot(int)`
- `bool SaveGame_FromSlot(int)`
- `bool SaveGame_DeleteSlot(int)`
- `void SaveGame_Checkpoint()`
- `void Meta_SetFloat(const string &in, float)`
- `float Meta_GetFloat(const string &in, float)`
- `void Meta_SetInt(const string &in, int)`
- `int Meta_GetInt(const string &in, int)`
- `void Meta_SetBool(const string &in, bool)`
- `bool Meta_GetBool(const string &in, bool)`
- `void Meta_SetString(const string &in, const string &in)`
- `string Meta_GetString(const string &in, const string &in)`
- `void Meta_Save()`
- `void AutoSave_Enable(bool)`
- `void AutoSave_SetInterval(float)`


---

## Scene

### Functions
- `Vector3 Entity_GetPosition(uint64)`
- `void Entity_SetPosition(uint64, const Vector3 &in)`
- `Vector3 Entity_GetRotation(uint64)`
- `void Entity_SetRotation(uint64, const Vector3 &in)`
- `Vector3 Entity_GetForward(uint64)`
- `Vector3 Entity_GetRight(uint64)`
- `Vector3 Entity_GetUp(uint64)`
- `Vector3 Entity_GetScale(uint64)`
- `void Entity_SetScale(uint64, const Vector3 &in)`
- `string Entity_GetName(uint64)`
- `bool Entity_IsVisible(uint64)`
- `void Entity_SetVisible(uint64, bool)`
- `void Entity_SetParent(uint64, uint64)`
- `void Entity_RemoveParent(uint64)`
- `uint64 Entity_GetParent(uint64)`
- `int Entity_GetChildCount(uint64)`
- `uint64 Entity_GetChild(uint64, int)`
- `uint64 Scene_FindEntity(const string &in)`
- `uint64 Scene_FindEntityByTag(const string &in)`
- `void Scene_DestroyEntity(uint64)`
- `uint64 Scene_Instantiate()`
- `uint64 Scene_InstantiateNamed(const string &in)`
- `uint64 Scene_InstantiateAt(const Vector3 &in)`
- `bool Scene_IsValid(uint64)`
- `uint64 Scene_GetEntityCount()`
- `string Scene_GetEntityName(uint64)`
- `void Scene_SetEntityName(uint64, const string &in)`
- `void Scene_AddTag(uint64, const string &in)`
- `void Scene_RemoveTag(uint64, const string &in)`
- `bool Scene_HasTag(uint64, const string &in)`
- `void Scene_LoadScene(const string &in)`
- `string Scene_GetCurrentScene()`
- `void Flow_Advance()`
- `void Scene_Restart()`


---

## Sprite

### Functions
- `void Sprite_SetTexture(uint64, const string &in)`
- `string Sprite_GetTexture(uint64)`
- `void Sprite_SetColor(uint64, float, float, float, float)`
- `void Sprite_SetAlpha(uint64, float)`
- `void Sprite_SetFlipX(uint64, bool)`
- `void Sprite_SetFlipY(uint64, bool)`
- `void Sprite_SetSortOrder(uint64, int)`
- `void Sprite_SetVisible(uint64, bool)`
- `void SpriteAnim_Play(uint64, const string &in)`
- `void SpriteAnim_Stop(uint64)`
- `void SpriteAnim_SetSpeed(uint64, float)`
- `bool SpriteAnim_IsPlaying(uint64)`
- `uint SpriteAnim_GetCurrentFrame(uint64)`


---

## StateMachine

### Functions
- `void SM_AddState(uint64, const string&in)`
- `void SM_AddTransition(uint64, const string&in, const string&in)`
- `void SM_SetState(uint64, const string&in)`
- `string SM_GetCurrentState(uint64)`
- `string SM_GetPreviousState(uint64)`
- `float SM_GetStateTime(uint64)`
- `void SM_SendTrigger(uint64, const string&in)`
- `void SM_SetBool(uint64, const string&in, bool)`
- `bool SM_GetBool(uint64, const string&in)`
- `void SM_SetFloat(uint64, const string&in, float)`
- `float SM_GetFloat(uint64, const string&in)`
- `void SM_SetInt(uint64, const string&in, int)`
- `int SM_GetInt(uint64, const string&in)`
- `bool SM_HasState(uint64, const string&in)`
- `void SM_SetOnEnter(uint64, const string&in, const string&in)`
- `void SM_SetOnUpdate(uint64, const string&in, const string&in)`
- `void SM_SetOnExit(uint64, const string&in, const string&in)`
- `string SM_GetOnEnter(uint64, const string&in)`
- `string SM_GetOnUpdate(uint64, const string&in)`
- `string SM_GetOnExit(uint64, const string&in)`


---

## Streaming

### Enums
- `ChunkState` = { CHUNK_UNLOADED, CHUNK_LOADING, CHUNK_LOADED, CHUNK_UNLOADING }

### Functions
- `void Streaming_ForceLoad(const string &in)`
- `void Streaming_ForceUnload(const string &in)`
- `int Streaming_GetState(const string &in)`
- `bool Streaming_IsLoaded(const string &in)`
- `int Streaming_GetLoadedCount()`
- `void Streaming_SetEnabled(bool)`


---

## Text

### Functions
- `void Text_SetContent(uint64, const string &in)`
- `string Text_GetContent(uint64)`
- `void Text_SetFontSize(uint64, float)`
- `void Text_SetColor(uint64, float, float, float)`
- `void Text_SetBgColor(uint64, float, float, float)`
- `void Text_SetBgOpacity(uint64, float)`
- `void Text_SetAlignment(uint64, int)`
- `void Text_SetWrapWidth(uint64, float)`


---

## Tween

### Enums
- `EasingType` = { EASE_LINEAR, EASE_IN_QUAD, EASE_OUT_QUAD, EASE_IN_OUT_QUAD, EASE_IN_CUBIC, EASE_OUT_CUBIC, EASE_IN_OUT_CUBIC, EASE_IN_QUART, EASE_OUT_QUART, EASE_IN_OUT_QUART, EASE_IN_SINE, EASE_OUT_SINE, EASE_IN_OUT_SINE, EASE_IN_EXPO, EASE_OUT_EXPO, EASE_IN_OUT_EXPO, EASE_IN_BACK, EASE_OUT_BACK, EASE_IN_OUT_BACK, EASE_IN_ELASTIC, EASE_OUT_ELASTIC, EASE_IN_OUT_ELASTIC, EASE_IN_BOUNCE, EASE_OUT_BOUNCE, EASE_IN_OUT_BOUNCE }

### Functions
- `uint Tween_Position(uint64, const Vector3&in, float, int)`
- `uint Tween_Rotation(uint64, const Vector3&in, float, int)`
- `uint Tween_Scale(uint64, const Vector3&in, float, int)`
- `uint Tween_Color(uint64, const Vector3&in, float, int)`
- `uint Tween_Opacity(uint64, float, float, int)`
- `uint Tween_Float(uint64, float, float, float, int)`
- `void Tween_SetOnComplete(uint64, uint, const string&in)`
- `void Tween_SetDelay(uint64, uint, float)`
- `float Tween_GetValue(uint64, uint)`
- `void Tween_StopAll(uint64)`


---

## UI

### Functions
- `void UI_SetCanvasVisible(uint64, bool)`
- `bool UI_IsCanvasVisible(uint64)`
- `void UI_SetCanvasSortOrder(uint64, int)`
- `void UI_SetText(uint64, int, const string &in)`
- `string UI_GetText(uint64, int)`
- `void UI_SetElementVisible(uint64, int, bool)`
- `bool UI_IsElementVisible(uint64, int)`
- `void UI_SetElementEnabled(uint64, int, bool)`
- `void UI_SetProgress(uint64, int, float)`
- `float UI_GetProgress(uint64, int)`
- `void UI_SetSliderValue(uint64, int, float)`
- `float UI_GetSliderValue(uint64, int)`
- `void UI_SetChecked(uint64, int, bool)`
- `bool UI_IsChecked(uint64, int)`
- `void UI_SetImagePath(uint64, int, const string &in)`
- `void UI_SetImageAlpha(uint64, int, float)`
- `void UI_SetBgColor(uint64, int, float, float, float, float)`
- `void UI_SetElementOffsets(uint64, int, float, float, float, float)`
- `void UI_SetTextColor(uint64, int, float, float, float)`
- `void UI_SetFontSize(uint64, int, float)`
- `float UI_GetFontSize(uint64, int)`
- `void UI_SetCharColor(uint64, int, int, float, float, float)`
- `void UI_SetCharColorRange(uint64, int, int, int, float, float, float)`
- `void UI_ClearCharColors(uint64, int)`
- `bool UI_IsHovered(uint64, int)`
- `bool UI_IsPressed(uint64, int)`
- `void UI_SetFocus(uint64, int)`
- `void UI_ClearFocus(uint64)`
- `int UI_GetFocusedElement(uint64)`
- `bool UI_IsFocused(uint64, int)`
- `void UI_SetTabOrder(uint64, int, int)`
- `void UI_SetFocusable(uint64, int, bool)`
- `string Loc_Get(const string &in)`
- `string Loc_GetWithFallback(const string &in, const string &in)`
- `void Loc_SetLocale(const string &in)`
- `string Loc_GetLocale()`
- `bool Loc_HasString(const string &in)`


---

## Water

### Functions
- `void Water_Splash(uint64, float, float, float)`
- `void Water_Wake(uint64, float, float, float, float, float)`
- `void Water_SustainedPressure(uint64, float, float, float, float)`
- `float Water_GetHeight(uint64, float, float)`


---

## Weather

### Enums
- `WeatherType` = { WEATHER_CLEAR, WEATHER_CLOUDY, WEATHER_RAIN, WEATHER_HEAVY_RAIN, WEATHER_SNOW, WEATHER_FOG, WEATHER_STORM }

### Functions
- `void Weather_Set(int, float = 2.0)`
- `int Weather_Get()`
- `void Weather_SetRainIntensity(float)`
- `float Weather_GetRainIntensity()`
- `void Weather_SetSnowIntensity(float)`
- `float Weather_GetSnowIntensity()`
- `void Weather_SetFogDensity(float)`
- `float Weather_GetFogDensity()`
- `void Weather_SetFogColor(float, float, float)`
- `void Weather_SetFogRange(float, float)`
- `void Weather_SetWind(float, float, float, float)`
- `bool Weather_IsLightning()`
- `bool Weather_LightningJustFired()`
- `void Weather_SetLightningInterval(float, float)`


-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local BatServer = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).BatServer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local AntiCheatService = require(ServerScriptService.Controllers.AntiCheatService)
local Audio = require(ReplicatedStorage.Shared.Audio)
local Config = require(script.Parent.Config)
local BatDamagable = require(ServerScriptService.Library.Tools.Internal.BatDamagable)

require(script.Parent.Types.Interface)

local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard)

require(ReplicatedStorage.Data.Gears)

local FromTool = require(ReplicatedStorage.Shared.Util.ToolHolders).FromTool
local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local Ragdoll = require(ReplicatedStorage.Shared.Modules.Ragdoll)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SlapShared = require(ServerScriptService.Library.Tools.Internal.SlapShared)

require(ReplicatedStorage.Shared.Types.Tools)

local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "BatServerController"

local t2 = {
    0, 2, 4, 7, 9, 12
}
local v1 = Log.new()
local v2 = Random.new()

function t1.new(p1, p2) -- line: 82
    -- upvalues: Config (copy), Trove (copy), t (copy), t1 (copy)
    t.strict(t.instanceIsA("Tool"))(p1)
    assert(typeof(p2) == "table", "Bat controller data must be a table")
    assert(typeof(p2.Duration) == "number", "Bat controller duration must be a number")
    assert(typeof(p2.Force) == "number", "Bat controller force must be a number")
    assert(typeof(p2.RangeBonus) == "number", "Bat controller range bonus must be a number")

    local Handle = p1.Handle

    assert(Handle:IsA("BasePart"), "Bat.Handle must be a BasePart")

    local self = setmetatable({}, t1)

    self._tool = p1
    self._handle = Handle
    self._range = Config.Range + p2.RangeBonus
    self._slapProfile = table.freeze({
        BrainrotDamage = 0,
        MaxBrainrotTargets = 0,
        Duration = p2.Duration,
        Force = p2.Force
    })
    self._cooldownLockedUntil = 0
    self._nextDebugLogAt = 0
    self._processing = false
    self._idleTrack = nil
    self._trove = Trove.new()
    self:_init()

    return self
end

function t1:_setCooldownAttributes(p4) -- line: 125
    local _tool = self._tool
    local v8 = workspace:GetServerTimeNow() + p4

    _tool:SetAttribute("CooldownDuration", p4)
    _tool:SetAttribute("CooldownEndTime", v8)
    _tool:SetAttribute("CooldownActive", true)
    task.delay(p4, function() -- line: 133
        -- upvalues: self (copy), _tool (copy), v8 (copy)
        if not _tool.Parent or _tool:GetAttribute("CooldownEndTime") ~= v8 then
            return
        end

        _tool:SetAttribute("CooldownActive", false)
        _tool:SetAttribute("CooldownDuration", 0)
        _tool:SetAttribute("CooldownEndTime", 0)
        self._cooldownLockedUntil = 0
    end)
end

function t1:_playIdle(p6) -- line: 143
    -- upvalues: Player (copy)
    if self._idleTrack then
        return
    end

    local v9 = Player.FindHumanoid(p6)
    local _ = v9 and v9:FindFirstChildOfClass("Animator")

    self._tool:FindFirstChild("IdleAnim")
end

function t1:_stopIdle() -- line: 159
    local _idleTrack = self._idleTrack

    if not _idleTrack then
        return
    end

    self._idleTrack = nil
    _idleTrack:Stop()
    _idleTrack:Destroy()
end

function t1:_playHitAnimation(p9) -- line: 171
    -- upvalues: Player (copy)
    local v10 = Player.FindHumanoid(p9)
    local Animator = v10 and v10:FindFirstChildOfClass("Animator")
    local HitAnim = self._tool:FindFirstChild("HitAnim")

    if Animator and HitAnim then
        local track = Animator:LoadAnimation(HitAnim)

        track.Priority = Enum.AnimationPriority.Action
        track:Play()
    end
end

function t1:_applyPlayerHit(p11, p12) -- line: 186
    -- upvalues: GameplayToolGuard (copy), Player (copy), Ragdoll (copy), SlapShared (copy)
    local v11 = Player.FindCharacter(p11)
    local v12 = Player.FindRootPart(p11)

    if not v11 or not v12 or not v12:IsA("BasePart") or v11:GetAttribute("IsTrapped") == true or not GameplayToolGuard.IsPlayerInGameplayArea(p11) then
        return
    end

    GameplayToolGuard.DropHeldEggFromPlayerHit(p11)

    local v13, v14 = SlapShared.ComputeImpulse(v12, p12, self._slapProfile)

    p11:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow() + v14)
    Ragdoll.TimedRagdollAsync(v11, v14, v13)
end

function t1:_canLogDebugTrace(p14) -- line: 213
    -- upvalues: Constants (copy)
    if not Constants.IS_STUDIO or p14 < self._nextDebugLogAt then
        return false
    end

    self._nextDebugLogAt = p14 + 0.1

    return true
end

function t1:_logDecisionTrace(p16, p17, p18, p19, p20, p21, p22, p23, p24) -- line: 226
    -- upvalues: BatServer (copy), Config (copy), Player (copy), v1 (copy)
    if not self:_canLogDebugTrace(p18) then
        return
    end

    local v15 = if not (p21 and p21.Target) then p20 else p21.Target
    local v16 = if v15 then Player.FindRootPart(v15) else nil

    if not (v16 and v16:IsA("BasePart")) then
        v16 = nil
    end

    local v17 = Player.FindHumanoid(p16)
    local v18 = if p19 then p19.AssemblyLinearVelocity else Vector3.new(0, 0, 0)
    local v19 = if v16 then v16.AssemblyLinearVelocity else Vector3.new(0, 0, 0)
    local v20 = (self._range + Config.HitTolerance) * Config.GetHitboxScalar()
    local v21 = if p21 then p21.CurrentDistance elseif not p19 or not v16 then -1 else (v16.Position - p19.Position).Magnitude
    local v22 = v1:AtInfo()
    local t4 = {
        Stage = "SERVER_DECISION",
        TraceId = p17,
        Decision = p22,
        Explanation = p23,
        Action = p24,
        Accepted = p24 == "HIT_ACTION_DISPATCHED",
        ServerTime = p18,
        AttackerName = p16.Name,
        AttackerUserId = p16.UserId
    }

    if v15 then
        t4.TargetName = v15.Name
        t4.TargetUserId = v15.UserId
    else
        t4.TargetName = "None"
        t4.TargetUserId = 0
    end

    t4.MaximumRange = v20
    t4.ServerCurrentDistance = v21

    if p21 then
        t4.ServerHistoricalDistance = p21.HistoricalDistance
        t4.TargetViewAgeSeconds = p21.TargetViewAge
        t4.HistoricalTimestamp = p21.HistoricalTimestamp
        t4.HistoricalSampleIntervalSeconds = p21.HistoricalSampleInterval
    else
        t4.ServerHistoricalDistance = -1
        t4.TargetViewAgeSeconds = -1
        t4.HistoricalTimestamp = -1
        t4.HistoricalSampleIntervalSeconds = -1
    end

    t4.NetworkPingSeconds = p16:GetNetworkPing()
    t4.CooldownRemainingSeconds = math.max(0, self._cooldownLockedUntil - p18)
    t4.CooldownToApplySeconds = if p24 == "HIT_ACTION_DISPATCHED" or p24 == "MISS_COOLDOWN_APPLIED" then BatServer.PLAYER_COOLDOWN else 0
    t4.AttackerServerPosition = if p19 then p19.Position else Vector3.new(0, 0, 0)

    if p21 then
        t4.TargetCurrentServerPosition = p21.TargetServerPosition
        t4.TargetHistoricalServerPosition = p21.TargetHistoricalServerPosition
    else
        t4.TargetCurrentServerPosition = if v16 then v16.Position else Vector3.new(0, 0, 0)
        t4.TargetHistoricalServerPosition = Vector3.new(0, 0, 0)
    end

    t4.AttackerWalkSpeed = if v17 then v17.WalkSpeed else -1
    t4.AttackerHorizontalSpeed = Vector3.new(v18.X, 0, v18.Z).Magnitude
    t4.TargetHorizontalSpeed = Vector3.new(v19.X, 0, v19.Z).Magnitude
    t4.TargetServerStationary = v16 ~= nil and Vector3.new(v19.X, 0, v19.Z).Magnitude <= 1
    v22:Log("Bat hit validation trace", t4)
end

local function riderRise(p25) -- line: 300
    local PetMountSession = p25:FindFirstChild("PetMountSession")
    local HeightIncrease = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

    if typeof(HeightIncrease) == "number" and HeightIncrease > 0 then
        return HeightIncrease
    end

    return 0
end

local function reachDistance(p26, p27, p28) -- line: 306
    local Magnitude = (p27 - p26).Magnitude

    if p28 <= 0 then
        return Magnitude
    end

    return (math.min(Magnitude, (p27 - Vector3.new(0, p28, 0) - p26).Magnitude))
end

function t1:_resolveValidTarget(p30, p31, p32, p33) -- line: 314
    -- upvalues: Players (copy), AntiCheatService (copy), Config (copy), GameplayToolGuard (copy), Player (copy), Ragdoll (copy)
    local t5 = {
        Delta = nil,
        Decision = "CLIENT_NO_TARGET",
        Explanation = "The client did not nominate a player inside its rendered selection range.",
        CurrentDistance = -1,
        HistoricalDistance = -1,
        TargetViewAge = -1,
        HistoricalTimestamp = -1,
        HistoricalSampleInterval = -1,
        TargetServerPosition = Vector3.new(0, 0, 0),
        TargetHistoricalServerPosition = Vector3.new(0, 0, 0),
        Target = p31
    }

    if p31 ~= nil then
        if p31 == p30 then
            t5.Decision = "SELF_TARGET_REJECTED"
            t5.Explanation = "The nominated target was the attacker."
        elseif p31.Parent == Players then
            if not p30:GetAttribute("InBossArena") and not p31:GetAttribute("InBossArena") and not p30:GetAttribute("InScrambleArena") and not p31:GetAttribute("InScrambleArena") and not p30:GetAttribute("InPumpkinArena") and not p31:GetAttribute("InPumpkinArena") then
                if workspace:GetAttribute("PvPDisabled") == true then
                    t5.Decision = "EVENT_PVP_DISABLED"
                    t5.Explanation = "A running event has turned player hits off."
                else
                    local v24 = Player.FindCharacter(p31)
                    local v25 = Player.FindRootPart(p31)
                    local v26 = Player.FindHumanoid(p31)

                    if v24 and v25 and v25:IsA("BasePart") and v26 then
                        t5.TargetServerPosition = v25.Position

                        if v26.Health <= 0 then
                            t5.Decision = "TARGET_DEAD"
                            t5.Explanation = "The nominated target was dead when the server handled the swing."
                        elseif Ragdoll.IsRagdolled(v24) then
                            t5.Decision = "TARGET_ALREADY_RAGDOLLED"
                            t5.Explanation = "The nominated target was already ragdolled and is not eligible for another Bat hit."
                        else
                            if not GameplayToolGuard.IsPlayerInGameplayArea(p31) then
                                t5.Decision = "TARGET_IN_SAFE_ZONE"
                                t5.Explanation = "The nominated target was in the safe zone and is not eligible for a Bat hit."

                                return t5
                            end

                            local v27 = v25.Position - p32.Position
                            local PetMountSession = v24:FindFirstChild("PetMountSession")
                            local v28 = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

                            if typeof(v28) ~= "number" or not (v28 > 0) then
                                v28 = 0
                            end

                            local v29 = (self._range + Config.HitTolerance) * Config.GetHitboxScalar()
                            local Position = p32.Position
                            local Position2 = v25.Position
                            local Magnitude = (Position2 - Position).Magnitude

                            t5.CurrentDistance = if not (v28 <= 0) then math.min(Magnitude, (Position2 - Vector3.new(0, v28, 0) - Position).Magnitude) else Magnitude

                            if t5.CurrentDistance <= v29 then
                                t5.Target = p31
                                t5.Delta = v27
                                t5.Decision = "CURRENT_RANGE_ACCEPTED"
                                t5.Explanation = "The server currently sees the target inside MaximumRange; history compensation was not needed."

                                return t5
                            end

                            local v31 = math.clamp(p30:GetNetworkPing() + Config.TargetViewSamplePadding, Config.TargetViewSamplePadding, Config.MaximumTargetViewAge)
                            local v32 = p33 - v31

                            t5.TargetViewAge = v31
                            t5.HistoricalTimestamp = v32

                            local v33 = AntiCheatService.GetHistoricalPosition(p31, v32)

                            if v33 == nil then
                                t5.Decision = "HISTORY_UNAVAILABLE"
                                t5.Explanation = "Current distance exceeded MaximumRange and the server could not reconstruct the target at HistoricalTimestamp."

                                return t5
                            end

                            t5.HistoricalSampleInterval = v33.SampleInterval
                            t5.TargetHistoricalServerPosition = v33.Position

                            local Position3 = p32.Position
                            local Position4 = v33.Position
                            local Magnitude2 = (Position4 - Position3).Magnitude

                            t5.HistoricalDistance = if not (v28 <= 0) then math.min(Magnitude2, (Position4 - Vector3.new(0, v28, 0) - Position3).Magnitude) else Magnitude2

                            if v29 < t5.HistoricalDistance then
                                t5.Decision = "CURRENT_AND_HISTORY_OUT_OF_RANGE"
                                t5.Explanation = "Both ServerCurrentDistance and ServerHistoricalDistance exceeded MaximumRange."
                            else
                                t5.Target = p31
                                t5.Delta = v27
                                t5.Decision = "HISTORICAL_RANGE_ACCEPTED"
                                t5.Explanation = "Current distance exceeded MaximumRange, but server-owned history proves the target was inside range in the estimated client view."
                            end
                        end

                        return t5
                    end

                    t5.Decision = "TARGET_CHARACTER_UNAVAILABLE"
                    t5.Explanation = "The server could not resolve the nominated target's live character, root, or Humanoid."
                end

                return t5
            end

            t5.Decision = "BOSS_ARENA_PVP_DISABLED"
            t5.Explanation = "Players inside the boss arena cannot hit or be hit by bats."
        else
            t5.Decision = "TARGET_NOT_IN_SERVER"
            t5.Explanation = "The nominated player was no longer in this server."
        end
    end

    return t5
end

function t1:_playSwingNote() -- line: 465
    -- upvalues: Audio (copy), t2 (copy), v2 (copy)
    local SwingNote = self._handle:FindFirstChild("SwingNote")

    if not (SwingNote and SwingNote:IsA("Sound")) then
        return
    end

    local v35 = t2[v2:NextInteger(1, #t2)]

    Audio.Play(SwingNote, self._handle, {
        MaxDistance = SwingNote.RollOffMaxDistance,
        PlaybackSpeed = SwingNote.PlaybackSpeed * 2 ^ (v35 / 12)
    })
end

function t1._beginActivation(p35, p36) -- line: 481
    -- upvalues: GameplayToolGuard (copy), Player (copy), Ragdoll (copy)
    local v36 = Player.FindCharacter(p36)

    if not v36 then
        return nil, "ATTACKER_CHARACTER_UNAVAILABLE", "The server could not resolve the attacker's character."
    end

    local v37 = Player.FindHumanoid(p36)

    if not v37 or v37.Health <= 0 then
        return nil, "ATTACKER_DEAD", "The server rejected the swing because the attacker was dead."
    end

    if Ragdoll.IsRagdolled(v36) then
        return nil, "ATTACKER_RAGDOLLED", "The server rejected the swing because the attacker was ragdolled."
    end

    if not GameplayToolGuard.CanActivate(p36) then
        return nil, "GAMEPLAY_GUARD_REJECTED", "The gameplay tool guard rejected the swing before target validation."
    end

    p35:_playHitAnimation(p36)
    p35:_playSwingNote()

    local v38 = Player.FindRootPart(p36)

    if not (v38 and v38:IsA("BasePart")) then
        return nil, "ATTACKER_ROOT_UNAVAILABLE", "The server could not resolve the attacker's HumanoidRootPart."
    end

    return v38, "ACTIVATION_ACCEPTED", "The swing passed attacker and gameplay activation guards."
end

function t1:_finishMiss() -- line: 526
    -- upvalues: BatServer (copy)
    local Slash = self._handle:FindFirstChild("Slash")

    if Slash then
        Slash:Play()
    end

    return BatServer.PLAYER_COOLDOWN
end

function t1:_applyHits(_, p40) -- line: 536
    -- upvalues: BatServer (copy)
    if #p40 == 0 then
        return self:_finishMiss()
    end

    local Hit = self._handle:FindFirstChild("Hit")

    if Hit then
        Hit:Play()
    end

    for _, v39 in ipairs(p40) do
        self:_applyPlayerHit(v39.target, v39.delta)
    end

    return BatServer.PLAYER_COOLDOWN
end

function t1:_activate(p42, p43, p44, p45) -- line: 558
    -- upvalues: BatServer (copy), BatDamagable (copy)
    local v40, v41, v42 = self:_beginActivation(p42)

    if v40 then
        local v43 = self:_resolveValidTarget(p42, p43, v40, p44)
        local Target, Delta = v43.Target, v43.Delta
        local v44 = BatDamagable.HitWithinRange(p42, v40.Position, self._range)

        if not Target or not Delta then
            if v44 > 0 then
                local Hit = self._handle:FindFirstChild("Hit")

                if Hit then
                    Hit:Play()
                end

                self:_logDecisionTrace(p42, p45, p44, v40, p43, v43, "DAMAGABLE_HIT", ("The swing landed on %* BatDamagable hitbox(es)."):format(v44), "DAMAGABLE_HIT_DISPATCHED")

                return BatServer.PLAYER_COOLDOWN
            end

            local v45 = self:_finishMiss()

            self:_logDecisionTrace(p42, p45, p44, v40, p43, v43, v43.Decision, v43.Explanation, "MISS_COOLDOWN_APPLIED")

            return v45
        end

        local v46 = self:_applyHits(v40, {
            {
                target = Target,
                delta = Delta
            }
        })

        self:_logDecisionTrace(p42, p45, p44, v40, p43, v43, v43.Decision, v43.Explanation, "HIT_ACTION_DISPATCHED")

        return v46
    end

    self:_logDecisionTrace(p42, p45, p44, nil, p43, nil, v41, v42, "NO_ACTION")

    return nil
end

function t1:_canProcessRequest(p47) -- line: 645
    -- upvalues: FromTool (copy), Player (copy), Ragdoll (copy)
    local v47 = Player.FindCharacter(p47)

    if not v47 then
        return false, "REQUEST_CHARACTER_UNAVAILABLE", "The request arrived without a live attacker character."
    end

    if self._tool.Parent ~= v47 or FromTool(self._tool) ~= p47 then
        return false, "REQUEST_TOOL_NOT_EQUIPPED", "The server rejected the request because this Bat was not equipped and owned by the attacker."
    end

    if Ragdoll.IsRagdolled(v47) then
        return false, "REQUEST_ATTACKER_RAGDOLLED", "The server rejected the request because the attacker was ragdolled."
    end

    if self._processing then
        return false, "REQUEST_ALREADY_PROCESSING", "The previous Bat request is still being processed."
    end

    if workspace:GetServerTimeNow() < self._cooldownLockedUntil then
        return false, "REQUEST_COOLDOWN_ACTIVE", "The request arrived before the server Bat cooldown ended."
    end

    return true, "REQUEST_ACCEPTED", "The request passed equip, ownership, ragdoll, processing, and cooldown guards."
end

function t1:_runActivation(p49, p50) -- line: 686
    local v48, v49, v50 = self:_canProcessRequest(p49)

    if not v48 then
        return false, v49, v50
    end

    self._processing = true

    local v51 = p50(self, p49)

    self._processing = false

    if v51 then
        self._cooldownLockedUntil = workspace:GetServerTimeNow() + v51
        self:_setCooldownAttributes(v51)
    end

    return true, "REQUEST_PROCESSED", "The server completed the Bat activation callback."
end

function t1:_handleActivation(p52, p53, p54) -- line: 710
    -- upvalues: Player (copy), t (copy)
    t.strict(t.instanceIsA("Player"))(p52)
    t.strict(t.optional(t.instanceIsA("Player")))(p53)
    t.strict(t.string)(p54)

    local ServerTimeNow = workspace:GetServerTimeNow()
    local v52, v53, v54 = self:_runActivation(p52, function(p55, p56) -- line: 722
        -- upvalues: p53 (copy), p54 (copy), ServerTimeNow (copy)
        return p55:_activate(p56, p53, ServerTimeNow, p54)
    end)

    if not v52 then
        self:_logDecisionTrace(p52, p54, ServerTimeNow, Player.FindRootPart(p52), p53, nil, v53, v54, "NO_ACTION")
    end
end

function t1:Destroy() -- line: 746
    -- upvalues: v1 (copy)
    self:_stopIdle()
    self._trove:Destroy()
    v1:AtDebug():Log("Bat server controller destroyed")
end

function t1:_init() -- line: 756
    -- upvalues: FromTool (copy), Remotes (copy)
    local _tool = self._tool

    _tool:SetAttribute("CooldownEndTime", 0)
    _tool:SetAttribute("CooldownDuration", 0)
    _tool:SetAttribute("CooldownActive", false)
    _tool:SetAttribute("IsBat", true)
    self._trove:Connect(Remotes.BatSwing.Trigger.OnServerEvent, function(p59, p60, p61) -- line: 766
        -- upvalues: self (copy)
        self:_handleActivation(p59, p60, p61)
    end)
    self._trove:Connect(_tool.Equipped, function() -- line: 770
        -- upvalues: self (copy), _tool (copy), FromTool (copy)
        local v55 = FromTool(_tool)

        if v55 then
            self:_playIdle(v55)
        end
    end)
    self._trove:Connect(_tool.Unequipped, function() -- line: 778
        -- upvalues: self (copy)
        self:_stopIdle()
    end)
    self._trove:Connect(_tool.Destroying, function() -- line: 782
        -- upvalues: self (copy)
        self:Destroy()
    end)
end

return t1

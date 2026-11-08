-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local BatClient = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).BatClient
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Config = require(script.Parent.Config)

require(script.Parent.Types.Interface)

local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Cooldown = require(ReplicatedStorage.Shared.Utils.Cooldown)

require(ReplicatedStorage.Data.Gears)

local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Log = require(ReplicatedStorage.Packages.Log)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Player = require(ReplicatedStorage.Shared.Player)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Ragdoll = require(ReplicatedStorage.Shared.Modules.Ragdoll)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "BatClientController"

local v1 = Config.MaximumTargetViewAge + 0.1
local v2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = Color3.fromRGB(255, 0, 0)
local v4 = Color3.fromRGB(107, 0, 0)
local Inside = HalloweenDimension.PlayerAttributes.Inside
local Trapped = PumpkinBossState.TrapAttributes.Trapped
local v5 = Log.new()
local LocalPlayer = Players.LocalPlayer

function t1.new(p1, p2) -- line: 88
    -- upvalues: BatClient (copy), Config (copy), Cooldown (copy), Trove (copy), t (copy), t1 (copy)
    t.strict(t.instanceIsA("Tool"))(p1)
    assert(typeof(p2) == "table", "Bat controller data must be a table")
    assert(typeof(p2.Duration) == "number", "Bat controller duration must be a number")
    assert(typeof(p2.Force) == "number", "Bat controller force must be a number")
    assert(typeof(p2.RangeBonus) == "number", "Bat controller range bonus must be a number")

    local self = setmetatable({}, t1)

    self._tool = p1
    self._highlightAttackerHistory = {}
    self._targetRange = Config.Range + Config.HitTolerance + p2.RangeBonus
    self._targetStates = {}
    self._isEquipped = false
    self._swingRange = Config.Range + p2.RangeBonus
    self._lastSwingAt = (-1e999)
    self._nextAutoSwingCheckAt = 0
    self._traceSequence = 0
    self._tryActivate = Cooldown(BatClient.CLIENT_COOLDOWN)
    self._trove = Trove.new()
    self:_init()

    return self
end

function t1._cancelTween(_, p4) -- line: 123
    local Tween = p4.Tween

    if Tween then
        p4.Tween = nil
        Tween:Cancel()
    end
end

function t1._destroyHighlight(p5, p6) -- line: 132
    p5:_cancelTween(p6)

    local Highlight = p6.Highlight

    if Highlight then
        Highlight:Destroy()
    end

    p6.Highlight = nil
    p6.Character = nil
    p6.Visible = false
end

function t1._showHighlight(p7, p8, p9) -- line: 148
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
    if p8.Character ~= p9 then
        p7:_destroyHighlight(p8)
    end

    if p8.Visible then
        return
    end

    p8.TransitionVersion += 1
    p7:_cancelTween(p8)

    local Highlight = p8.Highlight

    if not Highlight then
        Highlight = Instance.new("Highlight")
        Highlight.Name = "BatTargetHighlight"
        Highlight.Adornee = p9
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillColor = v3
        Highlight.OutlineColor = v4
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 1
        Highlight.Parent = p9
        p8.Highlight = Highlight
    end

    p8.Character = p9
    p8.Visible = true

    local tween = TweenService:Create(assert(Highlight, "Bat target Highlight must exist before fade-in"), v2, {
        FillTransparency = 0.5,
        OutlineTransparency = 0.15
    })

    p8.Tween = tween
    tween:Play()
end

function t1._hideHighlight(p10, p11) -- line: 192
    if p11.Highlight then
        p10:_destroyHighlight(p11)
    end
end

function t1:_trackPlayer(p13) -- line: 203
    -- upvalues: LocalPlayer (copy)
    if p13 ~= LocalPlayer and not self._targetStates[p13] then
        self._targetStates[p13] = {
            Character = nil,
            Highlight = nil,
            Tween = nil,
            TransitionVersion = 0,
            Visible = false
        }
    end
end

function t1:_untrackPlayer(p15) -- line: 217
    local v12 = self._targetStates[p15]

    if v12 then
        self:_destroyHighlight(v12)
        self._targetStates[p15] = nil
    end
end

local function riderRise(p16) -- line: 228
    local PetMountSession = p16:FindFirstChild("PetMountSession")
    local HeightIncrease = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

    if typeof(HeightIncrease) == "number" and HeightIncrease > 0 then
        return HeightIncrease
    end

    return 0
end

local function reachDistance(p17, p18, p19) -- line: 234
    local Magnitude = (p18 - p17).Magnitude

    if p19 <= 0 then
        return Magnitude
    end

    return (math.min(Magnitude, (p18 - Vector3.new(0, p19, 0) - p17).Magnitude))
end

function t1._isTargetEligible(_, p21, p22, p23) -- line: 242
    -- upvalues: Player (copy), Ragdoll (copy), ToolGameplayGuard (copy), LocalPlayer (copy)
    local v13 = Player.FindCharacter(p21)
    local v14 = Player.FindRootPart(p21)
    local v15 = Player.FindHumanoid(p21)

    if not v13
        or not v14
        or not v14:IsA("BasePart")
        or not v15
        or v15.Health <= 0
        or Ragdoll.IsRagdolled(v13)
        or not ToolGameplayGuard.IsInsideArena(p21)
        or LocalPlayer:GetAttribute("InBossArena")
        or p21:GetAttribute("InBossArena")
        or LocalPlayer:GetAttribute("InScrambleArena")
        or p21:GetAttribute("InScrambleArena")
        or LocalPlayer:GetAttribute("InPumpkinArena")
        or p21:GetAttribute("InPumpkinArena")
        or workspace:GetAttribute("PvPDisabled") == true then
        return false, 1e999
    end

    local Position = p22.Position
    local Position2 = v14.Position
    local PetMountSession = v13:FindFirstChild("PetMountSession")
    local v16 = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

    if typeof(v16) ~= "number" or not (v16 > 0) then
        v16 = 0
    end

    local Magnitude = (Position2 - Position).Magnitude

    if not (v16 <= 0) then
        Magnitude = math.min(Magnitude, (Position2 - Vector3.new(0, v16, 0) - Position).Magnitude)
    end

    return Magnitude <= p23, Magnitude
end

function t1:_recordHighlightAttackerSample(p25, p26) -- line: 291
    -- upvalues: v1 (copy)
    local _highlightAttackerHistory = self._highlightAttackerHistory

    _highlightAttackerHistory[#_highlightAttackerHistory + 1] = {
        Position = p26,
        Timestamp = p25
    }

    local v17 = p25 - v1

    while #_highlightAttackerHistory > 2 and _highlightAttackerHistory[2].Timestamp < v17 do
        table.remove(_highlightAttackerHistory, 1)
    end
end

function t1:_getHighlightAttackerPositionAt(p28) -- line: 310
    local _highlightAttackerHistory = self._highlightAttackerHistory
    local v18 = _highlightAttackerHistory[1]
    local v19 = _highlightAttackerHistory[#_highlightAttackerHistory]

    if not v18 or not v19 or p28 < v18.Timestamp or v19.Timestamp < p28 then
        return nil
    end

    for i = 2, #_highlightAttackerHistory do
        local v20 = _highlightAttackerHistory[i]

        if p28 <= v20.Timestamp then
            local v21 = _highlightAttackerHistory[i - 1]
            local v22 = v20.Timestamp - v21.Timestamp

            if v22 <= 0 then
                return v20.Position
            end

            local v24 = math.clamp((p28 - v21.Timestamp) / v22, 0, 1)

            return v21.Position:Lerp(v20.Position, v24)
        end
    end

    return nil
end

function t1:_predictServerAcceptsHighlightTarget(p30, p31, p32) -- line: 347
    -- upvalues: Config (copy), Player (copy), LocalPlayer (copy)
    local v25 = self._targetRange * Config.GetHitboxScalar()

    if not self:_isTargetEligible(p30, p31, v25) then
        return false
    end

    local v26 = Player.FindRootPart(p30)

    if not (v26 and v26:IsA("BasePart")) then
        return false
    end

    local NetworkPing = LocalPlayer:GetNetworkPing()
    local v28 = self:_getHighlightAttackerPositionAt(p32 - math.clamp(0.14 + NetworkPing, 0.14, Config.MaximumTargetViewAge))

    if not v28 then
        return false
    end

    local v30 = math.clamp(NetworkPing + Config.TargetViewSamplePadding, Config.TargetViewSamplePadding, Config.MaximumTargetViewAge)
    local Position = v26.Position
    local v31 = Position + v26.AssemblyLinearVelocity * v30
    local v32 = Player.FindCharacter(p30)
    local v33

    if v32 then
        local PetMountSession = v32:FindFirstChild("PetMountSession")

        v33 = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

        if typeof(v33) ~= "number" or not (v33 > 0) then
            v33 = 0
        end
    else
        v33 = 0
    end

    local Magnitude = (Position - v28).Magnitude

    if not (v33 <= 0) then
        Magnitude = math.min(Magnitude, (Position - Vector3.new(0, v33, 0) - v28).Magnitude)
    end

    local Magnitude2 = (v31 - v28).Magnitude

    if not (v33 <= 0) then
        Magnitude2 = math.min(Magnitude2, (v31 - Vector3.new(0, v33, 0) - v28).Magnitude)
    end

    if Magnitude <= v25 then
        return true
    end

    return Magnitude2 <= v25
end

function t1:_updateHighlights() -- line: 396
    -- upvalues: Player (copy), Ragdoll (copy), LocalPlayer (copy)
    local v34 = Player.FindCharacter(LocalPlayer)
    local v35 = Player.FindRootPart(LocalPlayer)
    local _isEquipped = self._isEquipped and v34 ~= nil and v35 ~= nil and v35:IsA("BasePart") and not Ragdoll.IsRagdolled(v34)
    local v36

    if _isEquipped then
        local ServerTimeNow = workspace:GetServerTimeNow()

        self:_recordHighlightAttackerSample(ServerTimeNow, v35.Position)
        v36 = self:_selectClosestTarget()

        if not (v36 and self:_predictServerAcceptsHighlightTarget(v36, v35, ServerTimeNow)) then
            v36 = nil
        end
    else
        table.clear(self._highlightAttackerHistory)
    end

    for v37, v38 in self._targetStates do
        local v39 = if v37 == v36 then Player.FindCharacter(v37) else nil

        if v39 then
            self:_showHighlight(v38, v39)
        else
            self:_hideHighlight(v38)
        end
    end
end

function t1:_selectClosestTarget() -- line: 440
    -- upvalues: Config (copy), Player (copy), Ragdoll (copy), LocalPlayer (copy)
    local v40 = Player.FindCharacter(LocalPlayer)
    local v41 = Player.FindRootPart(LocalPlayer)

    if not v40 or not v41 or not v41:IsA("BasePart") or Ragdoll.IsRagdolled(v40) then
        return nil
    end

    local v42 = self._targetRange * Config.GetHitboxScalar()
    local n1 = 1e999
    local v43

    for v44 in self._targetStates do
        local v45, v46 = self:_isTargetEligible(v44, v41, v42)

        if v45 and v46 < n1 then
            n1 = v46
            v43 = v44
        end
    end

    return v43
end

function t1:_logActivationTrace(p36, p37, p38) -- line: 469
    -- upvalues: Config (copy), Constants (copy), Player (copy), v5 (copy), LocalPlayer (copy)
    if Constants.IS_STUDIO then
        local v47 = Player.FindHumanoid(LocalPlayer)
        local v48 = if p37 then Player.FindRootPart(p37) else nil

        if not (v48 and v48:IsA("BasePart")) then
            v48 = nil
        end

        local v49 = if v48 then v48.AssemblyLinearVelocity else Vector3.new(0, 0, 0)
        local AssemblyLinearVelocity = p38.AssemblyLinearVelocity
        local v50 = if v48 then (v48.Position - p38.Position).Magnitude else -1
        local v51 = if p37 == nil then "CLIENT_NO_TARGET: your PC did not nominate an eligible player inside ClientSelectionRange at the swing moment." elseif v48 == nil then "CLIENT_TARGET_ROOT_MISSING: the nominated player's rendered root disappeared before the swing was sent." else "CLIENT_TARGET_NOMINATED: this is the player and distance your PC rendered at the swing moment."
        local v52 = v5:AtInfo()
        local t3 = {
            Stage = "CLIENT_SWING",
            TraceId = p36,
            Interpretation = v51,
            ClientServerTime = workspace:GetServerTimeNow(),
            AttackerName = LocalPlayer.Name,
            AttackerUserId = LocalPlayer.UserId
        }

        if p37 then
            t3.TargetName = p37.Name
            t3.TargetUserId = p37.UserId
        else
            t3.TargetName = "None"
            t3.TargetUserId = 0
        end

        t3.TargetNominated = p37 ~= nil
        t3.ClientSelectionRange = self._targetRange * Config.GetHitboxScalar()
        t3.ClientVisibleDistance = v50
        t3.AttackerPosition = p38.Position
        t3.TargetPosition = if v48 then v48.Position else Vector3.new(0, 0, 0)
        t3.AttackerWalkSpeed = if v47 then v47.WalkSpeed else -1
        t3.AttackerHorizontalSpeed = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
        t3.TargetHorizontalSpeed = Vector3.new(v49.X, 0, v49.Z).Magnitude
        t3.TargetAppearsStationary = v48 ~= nil and Vector3.new(v49.X, 0, v49.Z).Magnitude <= 1
        v52:Log("Bat hit validation trace", t3)
    end
end

function t1._logLocalRejection(_, p40, p41, p42) -- line: 518
    -- upvalues: BatClient (copy), Constants (copy), Player (copy), v5 (copy), LocalPlayer (copy)
    if Constants.IS_STUDIO then
        local v53 = Player.FindRootPart(LocalPlayer)
        local v54 = Player.FindHumanoid(LocalPlayer)
        local v55 = if not (v53 and v53:IsA("BasePart")) then Vector3.new(0, 0, 0) else v53.AssemblyLinearVelocity

        v5:AtInfo():Log("Bat hit validation trace", {
            Stage = "CLIENT_LOCAL_REJECTED",
            TraceId = p40,
            Decision = p41,
            Explanation = p42,
            ClientServerTime = workspace:GetServerTimeNow(),
            AttackerName = LocalPlayer.Name,
            AttackerUserId = LocalPlayer.UserId,
            AttackerPosition = if not (v53 and v53:IsA("BasePart")) then Vector3.new(0, 0, 0) else v53.Position,
            AttackerWalkSpeed = if v54 then v54.WalkSpeed else -1,
            AttackerHorizontalSpeed = Vector3.new(v55.X, 0, v55.Z).Magnitude,
            ClientCooldownSeconds = BatClient.CLIENT_COOLDOWN
        })
    end
end

function t1:_onActivated(p44) -- line: 548
    -- upvalues: Player (copy), Ragdoll (copy), Remotes (copy), ToolGameplayGuard (copy), LocalPlayer (copy)
    self._traceSequence += 1

    local v58 = ("%*:%*:%*"):format(LocalPlayer.UserId, self._traceSequence, (math.floor(workspace:GetServerTimeNow() * 1000)))

    if self._isEquipped then
        if ToolGameplayGuard.AllowsLocalUse(self._tool) then
            if not self._tryActivate(function() -- line: 572
                -- upvalues: self (copy), p44 (copy), v58 (copy), Player (copy), Ragdoll (copy), Remotes (copy), LocalPlayer (copy)
                local v59 = Player.FindCharacter(LocalPlayer)
                local v60 = Player.FindRootPart(LocalPlayer)
                local v61 = Player.FindHumanoid(LocalPlayer)

                if not v59
                    or not v60
                    or not v60:IsA("BasePart")
                    or not v61
                    or v61.Health <= 0
                    or Ragdoll.IsRagdolled(v59) then
                    self:_logLocalRejection(v58, "CLIENT_CHARACTER_STATE_REJECTED", "The client had no usable character/root, was dead or was ragdolled when the debounced swing executed.")

                    return
                end

                self._lastSwingAt = os.clock()

                if p44 then
                    Remotes.BatSwing.Trigger:FireServer(nil, v58)
                else
                    local v62 = self:_selectClosestTarget()

                    self:_logActivationTrace(v58, v62, v60)
                    Remotes.BatSwing.Trigger:FireServer(v62, v58)
                end
            end) then
                self:_logLocalRejection(v58, "CLIENT_COOLDOWN_ACTIVE", "The client Bat cooldown rejected this click, so no server request was sent.")
            end
        else
            self:_logLocalRejection(v58, "CLIENT_GAMEPLAY_GUARD_REJECTED", "The local gameplay-area guard rejected the swing before any server request was sent.")
        end
    else
        self:_logLocalRejection(v58, "CLIENT_TOOL_NOT_EQUIPPED", "The Bat Activated signal fired while this client controller did not consider the tool equipped.")
    end
end

local function distanceToBox(p45, p46) -- line: 615
    local v63 = p45.CFrame:PointToObjectSpace(p46)
    local v64 = p45.Size * 0.5

    return (v63 - Vector3.new(math.clamp(v63.X, -v64.X, v64.X), math.clamp(v63.Y, -v64.Y, v64.Y), (math.clamp(v63.Z, -v64.Z, v64.Z)))).Magnitude
end

function t1:_hasAutoSwingTarget(p48) -- line: 627
    -- upvalues: CollectionService (copy), distanceToBox (copy)
    for _, v71 in CollectionService:GetTagged("BatDamagable") do
        if v71:IsA("BasePart") and v71:IsDescendantOf(workspace) then
            local Health = v71:GetAttribute("Health")

            if typeof(Health) == "number" and not (Health <= 0) and distanceToBox(v71, p48.Position) <= self._swingRange then
                return true
            end
        end
    end

    return false
end

function t1:_autoSwing() -- line: 647
    -- upvalues: BatClient (copy), PlatformController (copy), Player (copy), Ragdoll (copy), ToolGameplayGuard (copy), Inside (copy), Trapped (copy), LocalPlayer (copy)
    local elapsed = os.clock()
    local v72

    if not self._isEquipped or elapsed < self._nextAutoSwingCheckAt then
        return
    else
        self._nextAutoSwingCheckAt = elapsed + 0.1
        v72 = LocalPlayer:GetAttribute("InPumpkinArena") == true
    end

    local v74, v75

    if v72 then
        v74 = PlatformController.IsMobile()
    else
        v75 = LocalPlayer:GetAttribute(Inside) == true
    end

    if (v72 and v74 or not v72 and v75) and not (elapsed - self._lastSwingAt < BatClient.CLIENT_COOLDOWN) then
        local CooldownEndTime = self._tool:GetAttribute("CooldownEndTime")

        if typeof(CooldownEndTime) ~= "number" or not (workspace:GetServerTimeNow() < CooldownEndTime) then
            local v76 = Player.FindCharacter(LocalPlayer)
            local v77 = Player.FindRootPart(LocalPlayer)
            local v78 = Player.FindHumanoid(LocalPlayer)

            if v76 and v77 and v77:IsA("BasePart") and v78 and not (v78.Health <= 0) and not Ragdoll.IsRagdolled(v76) and (not v72 or v76:GetAttribute(Trapped) ~= true) then
                if not (v72 or ToolGameplayGuard.IsLocalInsideArena() and not ToolGameplayGuard.IsInsideSafeZone(LocalPlayer)) then
                    return
                end

                if self:_hasAutoSwingTarget(v77) then
                    self:_onActivated(true)
                end
            end
        end
    end
end

function t1:_onEquipped() -- line: 709
    self._isEquipped = true
end

function t1:Destroy() -- line: 717
    -- upvalues: v5 (copy)
    self._trove:Destroy()

    for v79 in self._targetStates do
        self:_untrackPlayer(v79)
    end

    v5:AtDebug():Log("Bat client controller destroyed")
end

function t1:_init() -- line: 731
    -- upvalues: Players (copy), RunService (copy), Constants (copy), Player (copy), LocalPlayer (copy)
    for _, player in ipairs(Players:GetPlayers()) do
        task.defer(function() -- line: 733
            -- upvalues: self (copy), player (copy)
            self:_trackPlayer(player)
        end)
    end

    self._trove:Connect(Players.PlayerAdded, function(p53) -- line: 738
        -- upvalues: self (copy)
        self:_trackPlayer(p53)
    end)
    self._trove:Connect(Players.PlayerRemoving, function(p54) -- line: 742
        -- upvalues: self (copy)
        self:_untrackPlayer(p54)
    end)
    self._trove:Connect(self._tool.Equipped, function() -- line: 746
        -- upvalues: self (copy)
        self:_onEquipped()
    end)
    self._trove:Connect(self._tool.Unequipped, function() -- line: 750
        -- upvalues: self (copy)
        self._isEquipped = false
        self:_updateHighlights()
    end)
    self._trove:Connect(self._tool.Activated, function() -- line: 755
        -- upvalues: self (copy)
        self:_onActivated()
    end)
    self._trove:Connect(RunService.Heartbeat, function() -- line: 759
        -- upvalues: self (copy)
        self:_autoSwing()
    end)

    if Constants.IS_MOBILE then
        self._trove:Connect(RunService.PreRender, function() -- line: 764
            -- upvalues: self (copy)
            self:_updateHighlights()
        end)
    end

    self._trove:Connect(self._tool.Destroying, function() -- line: 769
        -- upvalues: self (copy)
        self:Destroy()
    end)

    local v80 = Player.FindCharacter(LocalPlayer)

    if v80 and self._tool.Parent == v80 then
        self:_onEquipped()
    end
end

return t1

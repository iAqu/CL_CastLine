-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, ReplicatedStorage, Workspace = services.HttpService, services.ReplicatedStorage, services.Workspace
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local emitVFX = RuntimeLib.import(script, script.Parent.Parent, "vfx").emitVFX
local pinataBossLaunchingAtom = RuntimeLib.import(script, script.Parent.Parent, "pinata-boss-launching-atom").pinataBossLaunchingAtom
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectPinataBossState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossState
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pinata-boss-utils")
local computeBossLegAlpha, computeInterpolatedBossPosition, pinataBossDifficultyConfigs = v1.computeBossLegAlpha, v1.computeInterpolatedBossPosition, v1.pinataBossDifficultyConfigs
local pinataBossRunAnimations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").pinataBossRunAnimations

local function getRigAnimator(p1) -- line: 22
    local v2 = p1:FindFirstChildWhichIsA("Humanoid", true)

    if v2 == nil then
        local v3 = p1:FindFirstChildWhichIsA("AnimationController", true)

        if v3 == nil then
            return nil
        end

        local Animator = v3:FindFirstChildOfClass("Animator")

        if Animator == nil then
            Animator = Instance.new("Animator")
            Animator.Parent = v3
        end

        return Animator
    end

    local Animator = v2:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = v2
    end

    return Animator
end

local v4 = Color3.fromRGB(255, 0, 0)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 65
        return "PinataBossController"
    end
})

self.__index = self

function self.new(...) -- line: 70
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3) -- line: 74
    p2._soundController = p3
    p2._facingDirection = Vector3.new(0, 0, -1)
    p2._isDespawningAfterDeath = false
    p2._runAnimationGeneration = 0
    p2._hitFlashGeneration = 0
    p2._isLaunching = false
    p2._launchElapsed = 0
    p2._launchStartPosition = Vector3.new(0, 0, 0)
    p2._launchLandingPosition = Vector3.new(0, 0, 0)
    p2._launchPeakHeight = 0
end

function self.onStart(p4) -- line: 86
    -- upvalues: HttpService (copy), effect (copy), clientProducer (copy), events (copy), emitVFX (copy), rewardPresentationQueue (copy), reflexStateToAtom (copy), selectPinataBossState (copy)
    local v7 = reflexStateToAtom(clientProducer, function(p5) -- line: 87
        -- upvalues: selectPinataBossState (copy)
        return selectPinataBossState(p5).isActive
    end)[1]

    effect(function() -- line: 91
        -- upvalues: p4 (copy), v7 (copy)
        if v7() then
            p4:_spawnBossModel()
        elseif not p4._isDespawningAfterDeath then
            p4:_despawnBossModel()
        end
    end)
    events.pinataBossHit:connect(function() -- line: 98
        -- upvalues: p4 (copy), emitVFX (copy)
        if p4._bossModel then
            emitVFX(p4._bossModel)
        end

        p4:_flashHitHighlight()
    end)
    events.pinataBossSlapHitResult:connect(function(p6, p7) -- line: 104
        -- upvalues: clientProducer (copy)
        clientProducer.pinataBossDamagePopupAdded({
            damage = p6,
            position = p7
        })
    end)
    events.pinataBossDied:connect(function() -- line: 110
        -- upvalues: p4 (copy), HttpService (copy), clientProducer (copy)
        p4:_playDeathVfxAndDespawn()
        p4._soundController:playSound("PartyBlower")
        clientProducer.pinataBossDeathAnnounced({
            id = HttpService:GenerateGUID(false)
        })
    end)
    events.pinataBossRewardGranted:connect(function(p8) -- line: 117
        -- upvalues: HttpService (copy), rewardPresentationQueue (copy)
        rewardPresentationQueue:enqueue({
            kind = "pinataBoss",
            id = HttpService:GenerateGUID(false),
            reward = p8
        })
    end)
end

function self.onTick(p9, p10) -- line: 125
    -- upvalues: Workspace (copy), clientProducer (copy), selectPinataBossState (copy), computeBossLegAlpha (copy), computeInterpolatedBossPosition (copy)
    if not p9._bossModel then
        return nil
    end

    if p9._isLaunching then
        p9:_tickLaunch(p10)

        return nil
    end

    local v8 = selectPinataBossState(clientProducer:getState())

    if not v8.isActive then
        return nil
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v9 = computeInterpolatedBossPosition(v8, ServerTimeNow)
    local v10 = v8.targetPosition - v8.currentPosition
    local v11 = v10.Magnitude > 0
    local v12 = if not (v11 and v10.Magnitude > 0.01) then p9._facingDirection else Vector3.new(v10.X, 0, v10.Z).Unit
    local v14 = 1 - math.exp(-8 * p10)
    local v15 = p9._facingDirection:Lerp(v12, v14)

    if v15.Magnitude > 0.001 then
        p9._facingDirection = v15.Unit
    else
        p9._facingDirection = p9._facingDirection
    end

    local _facingDirection = p9._facingDirection
    local Magnitude = v10.Magnitude
    local v16 = computeBossLegAlpha(v8, ServerTimeNow) * Magnitude / 4
    local v17 = v16 - math.floor(v16)
    local v18 = 4 * v17 * (1 - v17)
    local v20 = v9 + Vector3.new(0, if v11 then v18 * 3 else 0, 0)
    local v21 = v20 + _facingDirection

    p9._bossModel:PivotTo(CFrame.lookAt(v20, v21))
end

function self._spawnBossModel(p11) -- line: 169
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), clientProducer (copy), selectPinataBossState (copy), pinataBossDifficultyConfigs (copy), getRigAnimator (copy)
    if p11._bossModel then
        return nil
    end

    local PinataBoss = ReplicatedStorage:FindFirstChild("PinataBoss")

    if not (if PinataBoss == nil then PinataBoss else PinataBoss:IsA("Model")) then
        return nil
    end

    local v22 = selectPinataBossState(clientProducer:getState())
    local sizeMultiplier = pinataBossDifficultyConfigs[v22.difficulty].sizeMultiplier
    local clone = PinataBoss:Clone()

    clone:ScaleTo(clone:GetScale() * sizeMultiplier)

    local v23 = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == v23
            descendant.CanCollide = false
        end
    end

    clone.Parent = Workspace
    p11._bossModel = clone
    p11._hitHighlight = p11:_createHitHighlight(clone)
    p11._runAnimator = getRigAnimator(clone)
    p11:_playRandomRunAnimation()
    p11:_beginLaunch(v22.currentPosition, sizeMultiplier)
end

function self._playRandomRunAnimation(p12) -- line: 203
    -- upvalues: pinataBossRunAnimations (copy)
    if not p12._runAnimator or #pinataBossRunAnimations == 0 then
        return nil
    else
        local _runAnimationTrack = p12._runAnimationTrack

        if _runAnimationTrack ~= nil then
            _runAnimationTrack:Stop()
        end
    end

    p12._runAnimationGeneration += 1

    local _runAnimationGeneration = p12._runAnimationGeneration
    local v25 = pinataBossRunAnimations[math.random(1, #pinataBossRunAnimations)]
    local Animation = Instance.new("Animation")

    Animation.AnimationId = v25

    local track = p12._runAnimator:LoadAnimation(Animation)

    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action
    p12._runAnimationTrack = track
    track:Play()
    task.delay(3, function() -- line: 221
        -- upvalues: p12 (copy), _runAnimationGeneration (copy)
        if p12._runAnimationGeneration == _runAnimationGeneration then
            p12:_playRandomRunAnimation()
        end
    end)
end

function self._despawnBossModel(p13) -- line: 227
    -- upvalues: pinataBossLaunchingAtom (copy)
    local _bossModel = p13._bossModel

    if _bossModel ~= nil then
        _bossModel:Destroy()
    end

    p13._bossModel = nil
    p13._runAnimationGeneration += 1

    local _runAnimationTrack = p13._runAnimationTrack

    if _runAnimationTrack ~= nil then
        _runAnimationTrack:Stop()
    end

    p13._runAnimationTrack = nil
    p13._runAnimator = nil
    p13._isLaunching = false
    p13._hitFlashGeneration += 1
    p13._hitHighlight = nil
    pinataBossLaunchingAtom(false)
end

function self._createHitHighlight(_, p15) -- line: 245
    -- upvalues: v4 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = v4
    Highlight.OutlineColor = v4
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Enabled = false
    Highlight.Parent = p15

    return Highlight
end

function self._flashHitHighlight(p16) -- line: 254
    local _hitHighlight = p16._hitHighlight

    if not _hitHighlight then
        return nil
    end

    p16._hitFlashGeneration += 1

    local _hitFlashGeneration = p16._hitFlashGeneration

    task.spawn(function() -- line: 261
        -- upvalues: p16 (copy), _hitHighlight (copy), _hitFlashGeneration (copy)
        for _ = 0, 2 do
            if p16._hitFlashGeneration ~= _hitFlashGeneration then
                return nil
            end

            _hitHighlight.Enabled = true
            task.wait(0.05)

            if p16._hitFlashGeneration ~= _hitFlashGeneration then
                return nil
            end

            _hitHighlight.Enabled = false
            task.wait(0.05)
        end
    end)
end

function self._beginLaunch(p17, p18, p19) -- line: 276
    -- upvalues: pinataBossLaunchingAtom (copy)
    if not p17._bossModel then
        return nil
    end

    p17._isLaunching = true
    pinataBossLaunchingAtom(true)
    p17._launchElapsed = 0
    p17._launchStartPosition = p17:_findWhirlpoolLaunchOrigin() or p18
    p17._launchLandingPosition = p18
    p17._launchPeakHeight = 20 * p19
    p17._facingDirection = Vector3.new(0, 0, -1)

    local _bossModel, _launchStartPosition, _launchStartPosition2, _facingDirection = p17._bossModel, p17._launchStartPosition, p17._launchStartPosition, p17._facingDirection

    _bossModel:PivotTo(CFrame.lookAt(_launchStartPosition, _launchStartPosition2 + _facingDirection))
end

function self._tickLaunch(p20, p21) -- line: 293
    -- upvalues: pinataBossLaunchingAtom (copy)
    if not p20._bossModel then
        return nil
    end

    p20._launchElapsed += p21

    local v26, v27

    if p20._launchElapsed < 1.2 then
        local v28 = p20._launchElapsed / 1.2

        v27 = p20._launchPeakHeight * (1 - (1 - v28) * (1 - v28))
        v26 = 0
    else
        v26 = math.clamp((p20._launchElapsed - 1.2) / 0.7, 0, 1)
        v27 = p20._launchPeakHeight * (1 - v26 * v26)
    end

    local v30 = p20._launchStartPosition:Lerp(p20._launchLandingPosition, v26)
    local v32 = Vector3.new(v30.X, p20._launchLandingPosition.Y + v27, v30.Z)
    local _bossModel, _facingDirection = p20._bossModel, p20._facingDirection

    _bossModel:PivotTo(CFrame.lookAt(v32, v32 + _facingDirection))

    if p20._launchElapsed >= 1.9 then
        p20._isLaunching = false
        pinataBossLaunchingAtom(false)
    end
end

function self._findWhirlpoolLaunchOrigin(_) -- line: 323
    -- upvalues: Workspace (copy)
    local v33 = Workspace:FindFirstChild("PinataBossSpawnPoint", true)

    if v33 ~= nil then
        v33 = v33.Parent
    end

    if v33 ~= nil then
        v33 = v33:FindFirstChild("whirlpool")
    end

    return if (if v33 == nil then v33 else v33:IsA("Model")) or (if v33 == nil then v33 else v33:IsA("BasePart")) then v33:GetPivot().Position else nil
end

function self._playDeathVfxAndDespawn(p23) -- line: 352
    -- upvalues: emitVFX (copy)
    if not p23._bossModel then
        return nil
    end

    emitVFX(p23._bossModel, 5)

    for _, descendant in p23._bossModel:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end

    p23._isDespawningAfterDeath = true
    task.delay(2, function() -- line: 363
        -- upvalues: p23 (copy)
        p23._isDespawningAfterDeath = false
        p23:_despawnBossModel()
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/pinata-boss-controller@PinataBossController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    PinataBossController = self
}

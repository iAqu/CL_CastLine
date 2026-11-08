-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.AssetBillboardController)

local AssetChatBubble = require(ReplicatedStorage.Client.UI.AssetChatBubble)
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetModels = require(ReplicatedStorage.Shared.Modules.AssetModels)

require(script.Parent.AssetMovementBatch)

local AssetRuntime = require(ReplicatedStorage.Shared.Types.AssetRuntime)
local AssetWanderSimulator = require(script.Parent.AssetWanderSimulator)
local Audio = require(ReplicatedStorage.Shared.Audio)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Player = require(ReplicatedStorage.Shared.Player)
local Rescale = require(ReplicatedStorage.Shared.Utils.VFX).Rescale
local SfxRework = require(ReplicatedStorage.Data.SfxRework)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Parent.Types)

local t1 = {}

t1.__index = t1

local GreetingRun = SfxRework.Global("GreetingRun")
local GreetingLove = SfxRework.Global("GreetingLove")
local Jump = SfxRework.Global("Jump")
local SmokeTrail = ReplicatedStorage.Assets.Particles.Pets.SmokeTrail

assert(SmokeTrail:IsA("Attachment"), "SmokeTrail pet particle template must be an Attachment")

local Love = ReplicatedStorage.Assets.Particles.Pets.Love

assert(Love:IsA("Attachment"), "Love pet particle template must be an Attachment")

function t1.new(p1, p2, p3, p4, p5, p6, p7) -- line: 131
    -- upvalues: Players (copy), t (copy), AssetChatBubble (copy), Assets (copy), AssetModels (copy), AssetRuntime (copy), AssetWanderSimulator (copy), Audio (copy), ModelBounds (copy), ItemDisplay (copy), SfxRework (copy), Trove (copy), t1 (copy)
    assert(AssetRuntime.SchemaValidation.RuntimeAssetRecord(p1), "Invalid runtime asset record")
    t.strict(t.instanceIsA("Player"))(p2)
    t.strict(t.instanceIsA("BasePart"))(p3)
    t.strict(t.Instance)(p4)

    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self._record = p1
    self._owner = p2
    self._billboards = p5
    self._movementBatch = p6
    self._hiddenTransparencySnapshot = nil
    self._hiddenDecalSnapshot = nil
    self._hiddenEffectSnapshot = nil
    self._model = ItemDisplay.CreateWanderingAssetModel(p1.OwnerUserId, p1.UID, p1.ItemData, p4)
    self._trove:Connect(self._model.DescendantAdded, function(p8) -- line: 158
        -- upvalues: self (copy)
        local _hiddenTransparencySnapshot = self._hiddenTransparencySnapshot

        if _hiddenTransparencySnapshot ~= nil and p8:IsA("BasePart") and _hiddenTransparencySnapshot[p8] == nil then
            _hiddenTransparencySnapshot[p8] = p8.Transparency
            p8.Transparency = 1
        end

        local _hiddenDecalSnapshot = self._hiddenDecalSnapshot

        if _hiddenDecalSnapshot ~= nil and p8:IsA("Decal") and _hiddenDecalSnapshot[p8] == nil then
            _hiddenDecalSnapshot[p8] = p8.Transparency
            p8.Transparency = 1
        end

        local _hiddenEffectSnapshot = self._hiddenEffectSnapshot

        if _hiddenEffectSnapshot ~= nil and (p8:IsA("ParticleEmitter") or p8:IsA("Beam") or p8:IsA("Trail")) and _hiddenEffectSnapshot[p8] == nil then
            _hiddenEffectSnapshot[p8] = p8.Enabled
            p8.Enabled = false
        end
    end)
    self._rootPart = assert(self._model.PrimaryPart, (("Asset model %* must have a PrimaryPart"):format(self._model.Name)))

    local v5 = assert(self._model:FindFirstChild("CENTER"), (("Asset model %* must contain CENTER"):format(self._model.Name)))

    assert(v5:IsA("BasePart"), (("Asset model %*.CENTER must be a BasePart"):format(self._model.Name)))
    self._centerPart = v5

    local v7, v8 = ModelBounds(self._model)
    local v9 = self._model:GetPivot():PointToObjectSpace(v7.Position).Y - v8.Y * 0.5
    local v10 = AssetModels.GetVisibleBoundsData(p1.ItemData.Category)
    local v11 = v10.Size / v10.TemplateScale
    local v12 = 2.5 + v8.Z * 0.5 * 0.8
    local v15 = (math.max(v8.Y, 4.5) / 4.5) ^ 0.7 + math.max((math.max(v8.X, v8.Z) - 5.625) / 4.5, 0) ^ 0.65 * 1.15

    self._wanderSimulator = AssetWanderSimulator.new(p1.Seed, p2, p3, p1.ItemData, p1.IsFirstPlacement == true, v12, v15)

    local v18 = assert(assert(self._model:FindFirstChild("Model"), (("Asset model %* must contain Model"):format(self._model.Name))):FindFirstChildWhichIsA("AnimationController"), (("Asset model %*.Model must contain AnimationController"):format(self._model.Name)))
    local v19 = v18:FindFirstChildWhichIsA("Animator") or Instance.new("Animator")

    v19.Parent = v18

    local v20 = Assets.Directory[p1.ItemData.Category]
    local Idle, Walk = v20.Animations.Idle, v20.Animations.Walk

    self._idleTrack = nil
    self._walkTrack = nil

    if self._model:GetAttribute("AnimationsDisabled") ~= true then
        assert(Idle ~= nil, (("Missing Idle animation for %*"):format(p1.ItemData.Category)))
        assert(Walk ~= nil, (("Missing Walk animation for %*"):format(p1.ItemData.Category)))

        local track = v19:LoadAnimation(Idle)
        local track2 = v19:LoadAnimation(Walk)

        track.Looped = true
        track2.Looped = true
        self._idleTrack = track
        self._walkTrack = track2
    end

    self._walkAnimationReferenceSpeed = v20.WalkAnimationReferenceSpeed or 8
    self._animationTransitionFadeDuration = v20.Animations.TransitionFadeDuration
    self._walkAnimationAlwaysOn = self._animationTransitionFadeDuration == 0
    self._currentTrack = nil
    self._idleTransitionRemaining = 0
    self._wasJumping = false
    self._greetingEffectsActive = false
    self._greetingEffectScale = math.clamp((math.max(v8.X, v8.Y, v8.Z) / 6) ^ 0.5, 0.7, 6)
    self._greetingSmokeAttachment = nil
    self._greetingLoveAttachment = nil
    self._greetingRunLoopSound = nil
    self._greetingLoveLoopSound = nil

    local v27 = math.max(math.max(v8.X, v8.Y, v8.Z) / 6 - 1, 0) ^ 0.5
    local v29 = math.clamp(v27 + 1, 1, 3)
    local v31 = math.clamp(v27 + 1, 1, 2)

    self._jumpSoundVolume = v29 * 0.75
    self._jumpSoundMaxDistance = v31 * 50
    self._jumpSounds = {}
    self._walkSound = nil
    self._walkSoundBasePlaybackSpeed = 1
    self._walkSoundTargetVolume = 0
    self._walkSoundFadeTween = nil
    self._walkSoundWasMoving = false
    self._simulationWasMoving = false
    self._randomIdleSound = nil
    self._randomIdleRandom = Random.new(p1.Seed)
    self._soundsSuppressed = false

    local v32 = SfxRework.Resolve(p1.ItemData.Category, "Walk", v20.WalkSound)
    local v33 = SfxRework.Resolve(p1.ItemData.Category, "Idle", v20.RandomIdleSound)

    if v32 ~= nil or v33 ~= nil then
        local Part = Instance.new("Part")

        Part.Name = "AssetWalkSoundEmitter"
        Part.Anchored = false
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Massless = true
        Part.Transparency = 1
        Part.Size = Vector3.new(0.05, 0.05, 0.05)
        Part.CFrame = self._rootPart.CFrame * CFrame.new(0, -v8.Y * 0.5, 0)
        Part.Parent = self._model

        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Name = "AssetWalkSoundEmitterWeld"
        WeldConstraint.Part0 = Part
        WeldConstraint.Part1 = self._rootPart
        WeldConstraint.Parent = Part

        local v35 = math.max(math.max(v8.X, v8.Y, v8.Z) / 6 - 1, 0) ^ 0.5
        local v37 = math.clamp(v35 + 1, 1, 5)
        local v39 = math.clamp(v35 + 1, 1, 3)

        if v32 ~= nil then
            local Sound = Instance.new("Sound")

            Sound.Name = "AssetWalkSound"
            Audio.Configure(Sound, v32)
            Sound.Looped = true
            self._walkSoundBasePlaybackSpeed = Sound.PlaybackSpeed
            self._walkSoundTargetVolume = Sound.Volume * v37
            Sound.RollOffMaxDistance = math.min(Sound.RollOffMaxDistance * v39, 120)
            Sound.Volume = 0
            Sound.Parent = Part
            self._walkSound = Sound
        end

        if v33 ~= nil then
            local Sound = Instance.new("Sound")

            Sound.Name = "AssetRandomIdleSound"
            Audio.Configure(Sound, v33)
            Sound.Volume *= v37
            Sound.RollOffMaxDistance *= v39
            Sound.Parent = Part
            self._randomIdleSound = Sound
        end

        self._trove:Add(Part)
    end

    local v41 = v11.X > 6.0229997634887695 or v11.Y > 4.925000190734863 or v11.Z > 3.3399999141693115

    self._chatBubble = AssetChatBubble.new(self._model, self._centerPart, v41)
    self._bubbleSuppressionActive = false
    p7 = p7 or t1._initialCFrame(p1, p3)
    self._model:PivotTo(p7)
    self._movementBatch:Add(self._model, {
        self._rootPart
    }, p7, v9, p3, p2 == Players.LocalPlayer, function(p9, p10) -- line: 358
        -- upvalues: self (copy)
        self:_step(p9, p10)
    end)

    local v43 = if self._walkAnimationAlwaysOn then self._walkTrack else self._idleTrack

    if v43 ~= nil then
        self:_play(v43)
    end

    return self
end

function t1:_tryPlayRandomIdleSound() -- line: 367
    local _randomIdleSound = self._randomIdleSound

    if self._soundsSuppressed or _randomIdleSound == nil or self._randomIdleRandom:NextInteger(1, 13) ~= 1 then
        return
    end

    _randomIdleSound.TimePosition = 0
    _randomIdleSound:Play()
end

function t1:_initialCFrame(p13) -- line: 385
    local v44 = Random.new(self.Seed)
    local v45 = p13.Size * 0.5
    local Position = (p13.CFrame * CFrame.new(v44:NextNumber(-v45.X, v45.X), 0, v44:NextNumber(-v45.Z, v45.Z))).Position

    return CFrame.new(Position) * CFrame.Angles(0, v44:NextNumber(0, 6.283185307179586), 0)
end

function t1:_play(p15) -- line: 399
    if self._currentTrack == p15 then
        return
    end

    if self._currentTrack ~= nil then
        self._currentTrack:Stop(self._animationTransitionFadeDuration or 0.35)
    end

    self._currentTrack = p15
    p15:Play(self._animationTransitionFadeDuration or 0.5)
end

function t1:_walkAnimationSpeed(p17) -- line: 412
    return (math.clamp(p17 / self._walkAnimationReferenceSpeed, 0.3, 5))
end

function t1:_playJumpSound(p19) -- line: 420
    -- upvalues: Players (copy), t (copy), Audio (copy), Player (copy), Jump (copy)
    t.strict(t.Vector3)(p19)

    if not self._soundsSuppressed then
        local v47 = Player.FindPrimaryPart(Players.LocalPlayer)

        if v47 ~= nil and not ((v47.Position - p19).Magnitude > self._jumpSoundMaxDistance) then
            local v48 = Audio.Play(Jump, p19, {
                Volume = self._jumpSoundVolume,
                MaxDistance = self._jumpSoundMaxDistance
            })

            if v48 ~= nil then
                self._jumpSounds[v48] = true
                v48.Destroying:Once(function() -- line: 441
                    -- upvalues: self (copy), v48 (copy)
                    self._jumpSounds[v48] = nil
                end)
            end
        end
    end
end

function t1:_setAttachmentEmittersEnabled(p21) -- line: 445
    -- upvalues: t (copy)
    t.strict(t.Instance)(self)
    t.strict(t.boolean)(p21)

    for _, descendant in ipairs(self:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p21
        end
    end
end

function t1:_prepareGreetingAttachment(p23, p24) -- line: 456
    -- upvalues: t (copy), Rescale (copy)
    t.strict(t.Instance)(self)
    t.strict(t.string)(p23)
    t.strict(t.number)(p24)

    local clone = self:Clone()

    clone.Name = p23

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            Rescale(descendant, p24)
            descendant.Enabled = false
        end
    end

    return clone
end

function t1:_isLocalPlayerNear(p26) -- line: 477
    -- upvalues: Players (copy), t (copy), Player (copy)
    t.strict(t.number)(p26)

    local v49 = Player.FindPrimaryPart(Players.LocalPlayer)

    return v49 ~= nil and (v49.Position - self._rootPart.Position).Magnitude <= p26
end

function t1:_getGreetingSmokeAttachment() -- line: 485
    -- upvalues: t1 (copy), SmokeTrail (copy)
    local _greetingSmokeAttachment = self._greetingSmokeAttachment

    if _greetingSmokeAttachment ~= nil then
        return _greetingSmokeAttachment
    end

    local v50 = t1._prepareGreetingAttachment(SmokeTrail, "AssetGreetingSmokeTrail", self._greetingEffectScale)

    v50.Parent = self._rootPart
    self._greetingSmokeAttachment = v50

    return v50
end

function t1:_getGreetingLoveAttachment() -- line: 502
    -- upvalues: t1 (copy), Love (copy)
    local _greetingLoveAttachment = self._greetingLoveAttachment

    if _greetingLoveAttachment ~= nil then
        return _greetingLoveAttachment
    end

    local v51 = t1._prepareGreetingAttachment(Love, "AssetGreetingLove", self._greetingEffectScale)

    v51.Parent = self._rootPart
    self._greetingLoveAttachment = v51

    return v51
end

function t1:_stopGreetingLoopSounds() -- line: 519
    local _greetingRunLoopSound = self._greetingRunLoopSound

    if _greetingRunLoopSound ~= nil then
        self._greetingRunLoopSound = nil
        _greetingRunLoopSound:Stop()
        _greetingRunLoopSound:Destroy()
    end

    local _greetingLoveLoopSound = self._greetingLoveLoopSound

    if _greetingLoveLoopSound == nil then
        return
    end

    self._greetingLoveLoopSound = nil
    _greetingLoveLoopSound:Stop()
    _greetingLoveLoopSound:Destroy()
end

function t1:_startGreetingLoopSounds() -- line: 535
    -- upvalues: Audio (copy), GreetingRun (copy), GreetingLove (copy)
    if not self._soundsSuppressed and self:_isLocalPlayerNear(80) then
        if self._greetingRunLoopSound == nil then
            self._greetingRunLoopSound = Audio.Play(GreetingRun, self._rootPart, {
                Volume = 0.75,
                MaxDistance = 80,
                Looped = true
            })
        end

        if self._greetingLoveLoopSound == nil then
            self._greetingLoveLoopSound = Audio.Play(GreetingLove, self._rootPart, {
                Volume = 0.75,
                MaxDistance = 80,
                Looped = true
            })
        end
    end
end

function t1:_setGreetingEffectsActive(p32) -- line: 556
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.boolean)(p32)

    if p32 then
        if not self._greetingEffectsActive then
            t1._setAttachmentEmittersEnabled(self:_getGreetingSmokeAttachment(), true)
            t1._setAttachmentEmittersEnabled(self:_getGreetingLoveAttachment(), true)
        end

        if self:_isLocalPlayerNear(80) then
            self:_startGreetingLoopSounds()
        else
            self:_stopGreetingLoopSounds()
        end
    elseif self._greetingEffectsActive then
        local _greetingSmokeAttachment = self._greetingSmokeAttachment

        if _greetingSmokeAttachment ~= nil then
            t1._setAttachmentEmittersEnabled(_greetingSmokeAttachment, false)
        end

        local _greetingLoveAttachment = self._greetingLoveAttachment

        if _greetingLoveAttachment ~= nil then
            t1._setAttachmentEmittersEnabled(_greetingLoveAttachment, false)
        end

        self:_stopGreetingLoopSounds()
    end

    self._greetingEffectsActive = p32
end

function t1:_destroyGreetingEffects() -- line: 584
    self:_setGreetingEffectsActive(false)

    local _greetingSmokeAttachment = self._greetingSmokeAttachment

    if _greetingSmokeAttachment ~= nil then
        self._greetingSmokeAttachment = nil
        _greetingSmokeAttachment:Destroy()
    end

    local _greetingLoveAttachment = self._greetingLoveAttachment

    if _greetingLoveAttachment ~= nil then
        self._greetingLoveAttachment = nil
        _greetingLoveAttachment:Destroy()
    end
end

function t1:_releaseBubbleSuppression() -- line: 598
    if self._bubbleSuppressionActive then
        self._bubbleSuppressionActive = false
        self._billboards:SetSuppressed(self._model, false)
    end
end

function t1:_displayChatBubble(p36) -- line: 607
    if not self._bubbleSuppressionActive then
        self._bubbleSuppressionActive = true
        self._billboards:SetSuppressed(self._model, true)
    end

    self._chatBubble:Say(p36, function() -- line: 612
        -- upvalues: self (copy)
        self:_releaseBubbleSuppression()
    end)
end

function t1:_setWalkSoundMoving(p38, p39) -- line: 615
    -- upvalues: Audio (copy)
    local v52 = not self._soundsSuppressed and p38
    local _walkSound = self._walkSound

    if _walkSound ~= nil then
        if v52 then
            local v54 = math.clamp(p39 / 8, 0.3, 5)

            _walkSound.PlaybackSpeed = self._walkSoundBasePlaybackSpeed * v54

            if not self._walkSoundWasMoving then
                local _walkSoundFadeTween = self._walkSoundFadeTween

                if _walkSoundFadeTween ~= nil then
                    _walkSoundFadeTween:Cancel()
                end

                _walkSound.Volume = 0

                if _walkSound.IsLoaded and _walkSound.TimeLength > 2 then
                    _walkSound.TimePosition = math.random() * (_walkSound.TimeLength - 1)
                end

                _walkSound:Play()
            end

            if not self._walkSoundWasMoving then
                local v55 = Audio.FadeTo(_walkSound, {
                    Seconds = 0.1,
                    Volume = self._walkSoundTargetVolume
                })

                self._walkSoundFadeTween = v55
                v55:Play()
            end

            self._walkSoundWasMoving = true
        elseif self._walkSoundWasMoving then
            self._walkSoundWasMoving = false

            local _walkSoundFadeTween = self._walkSoundFadeTween

            if _walkSoundFadeTween ~= nil then
                _walkSoundFadeTween:Cancel()
            end

            local v56 = Audio.FadeTo(_walkSound, {
                Volume = 0,
                Seconds = 0.1
            })

            self._walkSoundFadeTween = v56
            v56:Play()
            v56.Completed:Once(function() -- line: 666
                -- upvalues: self (copy), _walkSound (copy), v56 (copy)
                if self._walkSoundFadeTween == v56 then
                    self._walkSoundFadeTween = nil
                    _walkSound:Stop()
                end
            end)
        end
    end
end

function t1:_setSoundsSuppressed(p41) -- line: 674
    -- upvalues: t (copy)
    t.strict(t.boolean)(p41)

    if self._soundsSuppressed ~= p41 then
        self._soundsSuppressed = p41

        if p41 then
            self:_stopGreetingLoopSounds()

            for v57 in self._jumpSounds do
                v57:Stop()
            end

            table.clear(self._jumpSounds)

            local _randomIdleSound = self._randomIdleSound

            if _randomIdleSound ~= nil then
                _randomIdleSound:Stop()
            end

            self:_setWalkSoundMoving(false, 0)
        end
    end
end

function t1:_step(p43, p44) -- line: 697
    -- upvalues: MusicDirector (copy)
    local v58 = self:IsHidden()

    self:_setSoundsSuppressed(v58 or MusicDirector.HasCustomTreadmill() or p44)

    local SimulationCFrame = self._movementBatch:GetSimulationCFrame(self._model)
    local v59, v60, v61, v62, v63, v64 = self._wanderSimulator:Step(p43, SimulationCFrame)

    if v58 then
        self._simulationWasMoving = v60
        self._wasJumping = not v61
        self._movementBatch:SetGroundingEnabled(self._model, v61)
        self._movementBatch:SetTarget(self._model, v59)
    else
        local v65 = self._simulationWasMoving and not v60

        self._simulationWasMoving = v60

        if v64 ~= nil then
            self:_displayChatBubble(v64)
        end

        self:_setGreetingEffectsActive(v63 and not p44)

        local v66 = not v61

        if v66 and not self._wasJumping then
            self:_playJumpSound(SimulationCFrame.Position)
        end

        self._wasJumping = v66
        self._movementBatch:SetGroundingEnabled(self._model, v61)
        self._movementBatch:SetTarget(self._model, v59)

        if v65 then
            self:_tryPlayRandomIdleSound()
        end

        self:_setWalkSoundMoving(v60 and not p44, v62)

        local _idleTrack, _walkTrack = self._idleTrack, self._walkTrack

        if _idleTrack ~= nil and _walkTrack ~= nil then
            if self._walkAnimationAlwaysOn then
                self._idleTransitionRemaining = 0
                self:_play(_walkTrack)
                _walkTrack:AdjustSpeed(if p44 then 0 else self:_walkAnimationSpeed(v62))
            elseif p44 then
                self._idleTransitionRemaining = 0
                self:_play(_idleTrack)
                _idleTrack:AdjustSpeed(1)
            elseif v60 then
                self._idleTransitionRemaining = 0.28
                self:_play(_walkTrack)
                _walkTrack:AdjustSpeed(self:_walkAnimationSpeed(v62))
            elseif self._currentTrack ~= _walkTrack or not (self._idleTransitionRemaining > 0) then
                self:_play(_idleTrack)
            else
                self._idleTransitionRemaining = math.max(self._idleTransitionRemaining - p43, 0)
                _walkTrack:AdjustSpeed(self:_walkAnimationSpeed(v62))
            end
        end
    end
end

function t1:GetOwnerUserId() -- line: 763
    return self._record.OwnerUserId
end

function t1:GetUid() -- line: 765
    return self._record.UID
end

function t1:GetModel() -- line: 767
    return self._model
end

function t1:GetRuntimeRecord() -- line: 769
    return self._record
end

function t1:IsHidden() -- line: 773
    return self._hiddenTransparencySnapshot ~= nil
end

function t1:SetHidden(p51) -- line: 777
    -- upvalues: t (copy)
    t.strict(t.boolean)(p51)

    if self:IsHidden() ~= p51 then
        self._movementBatch:SetHidden(self._model, p51)

        if p51 then
            self:_setSoundsSuppressed(true)
            self:_setWalkSoundMoving(false, 0)

            if self._idleTrack ~= nil then
                self._idleTrack:Stop(0)
            end

            if self._walkTrack ~= nil then
                self._walkTrack:Stop(0)
            end

            self._currentTrack = nil
            self._idleTransitionRemaining = 0
            self:_setGreetingEffectsActive(false)
            self._chatBubble:Mute(true)
            self:_releaseBubbleSuppression()

            local t3 = {}
            local t4 = {}
            local t5 = {}

            self._hiddenTransparencySnapshot = t3
            self._hiddenDecalSnapshot = t4
            self._hiddenEffectSnapshot = t5

            for _, descendant in ipairs(self._model:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    t3[descendant] = descendant.Transparency
                    descendant.Transparency = 1
                elseif descendant:IsA("Decal") then
                    t4[descendant] = descendant.Transparency
                    descendant.Transparency = 1
                elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
                    t5[descendant] = descendant.Enabled
                    descendant.Enabled = false
                end
            end
        else
            local v68 = assert(self._hiddenTransparencySnapshot, "Hidden asset must own a transparency snapshot")

            self._hiddenTransparencySnapshot = nil

            for v69, v70 in pairs(v68) do
                if v69.Parent ~= nil then
                    v69.Transparency = v70
                end
            end

            table.clear(v68)

            local _hiddenDecalSnapshot = self._hiddenDecalSnapshot

            self._hiddenDecalSnapshot = nil

            if _hiddenDecalSnapshot ~= nil then
                for v71, v72 in pairs(_hiddenDecalSnapshot) do
                    if v71.Parent ~= nil then
                        v71.Transparency = v72
                    end
                end

                table.clear(_hiddenDecalSnapshot)
            end

            local _hiddenEffectSnapshot = self._hiddenEffectSnapshot

            self._hiddenEffectSnapshot = nil

            if _hiddenEffectSnapshot ~= nil then
                for v73, v74 in pairs(_hiddenEffectSnapshot) do
                    if v73.Parent ~= nil then
                        v73.Enabled = v74
                    end
                end

                table.clear(_hiddenEffectSnapshot)
            end

            self._chatBubble:Mute(false)
        end
    end
end

function t1:SetRuntimeRecord(p53) -- line: 854
    -- upvalues: AssetRuntime (copy)
    assert(AssetRuntime.SchemaValidation.RuntimeAssetRecord(p53), "Invalid runtime asset record")
    self._record = p53
    self._wanderSimulator:SetItemData(p53.ItemData, p53.IsFirstPlacement == true)
end

function t1:SetAssetArea(p55) -- line: 863
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("BasePart"))(p55)
    self._wanderSimulator:SetAssetArea(p55)
    self._movementBatch:SetAssetArea(self._model, p55)
end

function t1:Destroy() -- line: 869
    self:_destroyGreetingEffects()
    self._chatBubble:Destroy()
    self._movementBatch:Remove(self._model)
    self._trove:Destroy()
    self._model:Destroy()
end

return t1

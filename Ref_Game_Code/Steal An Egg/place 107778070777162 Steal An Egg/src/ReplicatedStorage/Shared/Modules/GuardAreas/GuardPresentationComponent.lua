-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Utils.AnimationAssets)

local Audio = require(ReplicatedStorage.Shared.Audio)

require(ReplicatedStorage.Data.Guards)

local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "GuardPresentationComponent"

function t1.new(p1, p2, p3) -- line: 46
    -- upvalues: Audio (copy), t (copy), t1 (copy)
    t.strict(t.instanceIsA("BasePart"))(p1)
    t.strict(t.Instance)(p2)
    t.strict(t.table)(p3)

    local self = setmetatable({}, t1)

    self._afterWakeSoundConfigs = t1.NormalizeAfterWakeSoundConfigs(p3.AfterWakeSound)

    if #self._afterWakeSoundConfigs > 0 then
        self._afterWakeSound = Audio.CreateConfigured(p1, t1.CreateSoundFile(self._afterWakeSoundConfigs[1]), "AfterWakeSound")
    else
        self._afterWakeSound = nil
    end

    self._afterWakeSoundAt = nil
    self._animationBaseWalkSpeed = p3.AnimationBaseWalkSpeed or 7
    assert(self._animationBaseWalkSpeed > 0, (("Guard %* animation base WalkSpeed must be greater than zero"):format(p3._id)))

    if p3.FootstepSound ~= nil then
        self._footstepSound = Audio.CreateConfigured(p1, t1.CreateSoundFile(p3.FootstepSound), "FootstepSound")
    else
        self._footstepSound = nil
    end

    if p3.FootstepSound ~= nil then
        self._footstepPlaybackSpeed = p3.FootstepSound.PlaybackSpeed or 1
    else
        self._footstepPlaybackSpeed = nil
    end

    self._hitSound = Audio.CreateConfigured(p1, t1.CreateSoundFile(p3.AttackSound), "Hit")

    if p3.AttackAnimation ~= nil then
        self._hitTrack = t1.LoadTrack(p2, p3.AttackAnimation, false)
    else
        self._hitTrack = nil
    end

    local _hitTrack = self._hitTrack

    if _hitTrack ~= nil then
        _hitTrack.Priority = Enum.AnimationPriority.Action4
    end

    self._idleTrack = t1.LoadTrack(p2, p3.IdleAnimation, true)
    self._sleepSound = Audio.CreateConfigured(p1, t1.CreateSoundFile(p3.SleepSound), "SleepSound")
    self._sleepTrack = t1.LoadTrack(p2, p3.SleepAnimation, true)
    self._random = Random.new()
    self._wakeSound = Audio.CreateConfigured(p1, t1.CreateSoundFile(p3.WakeSound), "Detected")
    self._walkTrack = t1.LoadTrack(p2, p3.WalkAnimation, true)

    return self
end

function t1:CreateSoundFile() -- line: 115
    return {
        SoundId = self.SoundIds or self.SoundId,
        Data = {
            Speed = self.PlaybackSpeed,
            Volume = self.Volume,
            MaxDistance = self.MaxDistance,
            Looped = self.Looped
        }
    }
end

function t1:NormalizeAfterWakeSoundConfigs() -- line: 129
    if self == nil then
        return {}
    end

    if typeof(self) == "table" and typeof(self.SoundId) == "string" and typeof(self.Volume) == "number" and typeof(self.MaxDistance) == "number" then
        return { self }
    end

    assert(#self > 0, "AfterWakeSound config array must not be empty")

    return self
end

function t1:LoadTrack(p7, p8) -- line: 149
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Animation"))(p7)
    t.strict(t.boolean)(p8)

    local track = self:LoadAnimation(p7)

    track.Looped = p8

    return track
end

function t1:Destroy() -- line: 165
    self._afterWakeSoundAt = nil
    self:StopWalkAnimation()
    self:StopIdleAnimation()
    self:StopFootstepSound()
    self._sleepTrack:Stop(0.1)

    local _hitTrack = self._hitTrack

    if _hitTrack ~= nil then
        _hitTrack:Stop(0.1)
    end

    if self._footstepSound ~= nil then
        self._footstepSound:Destroy()
    end

    if self._afterWakeSound ~= nil then
        self._afterWakeSound:Destroy()
    end

    self._hitSound:Destroy()
    self._sleepSound:Destroy()
    self._wakeSound:Destroy()
end

function t1:PlaySleep(p11) -- line: 186
    -- upvalues: t (copy)
    t.strict(t.number)(p11)

    if not self._sleepTrack.IsPlaying then
        self._sleepTrack:Play(p11)
    end

    if self._sleepSound.IsPlaying then
        return
    end

    self._sleepSound.Looped = true
    self._sleepSound.TimePosition = 0
    self._sleepSound:Play()
end

function t1:StopSleep(p13) -- line: 201
    -- upvalues: t (copy)
    t.strict(t.number)(p13)
    self._sleepTrack:Stop(p13)
    self._sleepSound:Stop()
end

function t1:PlayWake() -- line: 210
    self._wakeSound.TimePosition = 0
    self._wakeSound:Play()
end

function t1:PlayAfterWake() -- line: 215
    -- upvalues: Audio (copy), t1 (copy)
    local _afterWakeSound = self._afterWakeSound

    if _afterWakeSound == nil then
        return
    end

    local v5 = self._afterWakeSoundConfigs[self._random:NextInteger(1, #self._afterWakeSoundConfigs)]

    assert(v5 ~= nil, "AfterWakeSound playback requires a configured sound")
    _afterWakeSound:Stop()
    Audio.Configure(_afterWakeSound, t1.CreateSoundFile(v5))
    _afterWakeSound.TimePosition = 0
    _afterWakeSound:Play()
end

function t1:ScheduleAfterWake(p17) -- line: 229
    -- upvalues: t (copy)
    t.strict(t.number)(p17)

    if self._afterWakeSound ~= nil then
        self._afterWakeSoundAt = p17 + 1
    end
end

function t1:CancelAfterWake() -- line: 239
    self._afterWakeSoundAt = nil
end

function t1:UpdateAfterWake(p20, p21) -- line: 243
    -- upvalues: t (copy)
    t.strict(t.number)(p20)
    t.strict(t.boolean)(p21)

    local _afterWakeSoundAt = self._afterWakeSoundAt

    if _afterWakeSoundAt == nil or p20 < _afterWakeSoundAt then
        return
    end

    self._afterWakeSoundAt = nil

    if p21 then
        self:PlayAfterWake()
    end
end

function t1:PlayHit() -- line: 262
    self:StopWalkAnimation()
    self:StopFootstepSound()
    self:EnsureIdleAnimation()

    local _hitTrack = self._hitTrack
    local v7 = 0

    if _hitTrack ~= nil then
        _hitTrack.TimePosition = 0
        _hitTrack:Play(0.05)

        local Length = _hitTrack.Length
        local v9 = math.max(Length / 1.5, 1)

        _hitTrack:AdjustSpeed(v9)
        v7 = Length / v9
    end

    self._hitSound.TimePosition = 0
    self._hitSound:Play()

    return v7
end

function t1:EnsureFootstepSound(p24) -- line: 281
    -- upvalues: t (copy)
    t.strict(t.number)(p24)

    local _footstepSound, _footstepPlaybackSpeed = self._footstepSound, self._footstepPlaybackSpeed

    if _footstepSound == nil or _footstepPlaybackSpeed == nil then
        return
    end

    _footstepSound.PlaybackSpeed = _footstepPlaybackSpeed * math.max(p24 / self._animationBaseWalkSpeed, 0.01)

    if _footstepSound.IsPlaying then
        return
    end

    _footstepSound.Looped = true
    _footstepSound.TimePosition = 0
    _footstepSound:Play()
end

function t1:StopFootstepSound() -- line: 300
    local _footstepSound = self._footstepSound

    if _footstepSound ~= nil and _footstepSound.IsPlaying then
        _footstepSound:Stop()
    end
end

function t1:EnsureIdleAnimation() -- line: 307
    if not self._idleTrack.IsPlaying then
        self._idleTrack:Play(0.2)
    end
end

function t1:StopIdleAnimation() -- line: 313
    if self._idleTrack.IsPlaying then
        self._idleTrack:Stop(0.2)
    end
end

function t1:EnsureWalkAnimation(p29) -- line: 319
    -- upvalues: t (copy)
    t.strict(t.number)(p29)
    self:StopIdleAnimation()
    self:EnsureFootstepSound(p29)
    self._walkTrack:AdjustSpeed((math.max(p29 / self._animationBaseWalkSpeed, 0.01)))

    if not self._walkTrack.IsPlaying then
        self._walkTrack:Play(0.4)
    end
end

function t1:StopWalkAnimation() -- line: 332
    if self._walkTrack.IsPlaying then
        self._walkTrack:Stop(0.2)
    end
end

return t1

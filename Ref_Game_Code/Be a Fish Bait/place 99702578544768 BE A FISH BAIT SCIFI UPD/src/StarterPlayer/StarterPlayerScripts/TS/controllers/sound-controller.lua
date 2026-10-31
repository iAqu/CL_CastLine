-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local effect, subscribe = charm.effect, charm.subscribe
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContentProvider, ReplicatedStorage, SoundService, TweenService = services.ContentProvider, services.ReplicatedStorage, services.SoundService, services.TweenService
local SoundSingleton = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "singletons", "sound-singleton").SoundSingleton
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectPlayerAudioSettings = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAudioSettings
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local deluluRiftMusicAtom = RuntimeLib.import(script, script.Parent.Parent, "delulu-rift-music-atom").deluluRiftMusicAtom
local selectIsCelebrationPlace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectIsCelebrationPlace

local function getBackgroundMusicMode(p1) -- line: 23
    -- upvalues: selectCurrentWeathers (copy), localPlayerUserId (copy), selectIsCelebrationPlace (copy)
    if selectIsCelebrationPlace(localPlayerUserId)(p1) then
        return "eventIsland"
    end

    if selectCurrentWeathers(p1).Glitched == nil then
        return "lobby"
    end

    return "Glitched"
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 37
        return "SoundController"
    end,
    __index = SoundSingleton
})

self.__index = self

function self.new(...) -- line: 43
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3, p4) -- line: 47
    -- upvalues: Maid (copy), SoundSingleton (copy)
    SoundSingleton.constructor(p2, p3)
    p2._components = p3
    p2._reflexController = p4
    p2._maid = Maid.new()
    p2._backgroundMusicMaid = Maid.new()
    p2._rareFishAudioMaid = Maid.new()
    p2._flyMusicMaid = Maid.new()
    p2._flyMusicVolume = 1
    p2._sfxInstanceCache = {}
    p2._registeredSounds = {}
    p2._currentMode = "lobby"
end

function self.onStart(p5) -- line: 60
    -- upvalues: effect (copy), subscribe (copy), ContentProvider (copy), events (copy), selectCurrentWeathers (copy), reflexStateToAtom (copy), selectPlayerAudioSettings (copy), localPlayerUserId (copy), fishingMovementLockedAtom (copy), deluluRiftMusicAtom (copy), selectIsCelebrationPlace (copy)
    local v3 = p5._reflexController:getClientProducer()

    p5._maid:GiveTask(v3:subscribe(function(p6) -- line: 63
        -- upvalues: p5 (copy), selectCurrentWeathers (copy), localPlayerUserId (copy), selectIsCelebrationPlace (copy)
        local v4 = if selectIsCelebrationPlace(localPlayerUserId)(p6) then "eventIsland" elseif selectCurrentWeathers(p6).Glitched == nil then "lobby" else "Glitched"

        if v4 ~= p5._currentMode then
            p5._currentMode = v4
            p5:_switchBackgroundMusic(v4)
        end
    end))

    local musicVolume, sfxVolume
    local v5 = reflexStateToAtom(v3, selectPlayerAudioSettings(localPlayerUserId))
    local v6 = v5[1]
    local v7 = v5[2]

    p5._maid:GiveTask(v7)
    p5._maid:GiveTask(effect(function() -- line: 87
        -- upvalues: p5 (copy), musicVolume (ref), sfxVolume (ref), v6 (copy)
        local v8 = v6()

        if not v8 then
            return nil
        end

        local musicVolume2, sfxVolume2 = v8.musicVolume, v8.sfxVolume

        if musicVolume2 ~= musicVolume then
            musicVolume = musicVolume2
            p5:getSoundGroup("music").Volume = musicVolume2
        end

        if sfxVolume2 ~= sfxVolume then
            sfxVolume = sfxVolume2
            p5:getSoundGroup("sfx").Volume = sfxVolume2
        end
    end))

    local v9 = v3:getState()

    p5._currentMode = if selectIsCelebrationPlace(localPlayerUserId)(v9) then "eventIsland" elseif selectCurrentWeathers(v9).Glitched == nil then "lobby" else "Glitched"
    p5:_switchBackgroundMusic(p5._currentMode)
    p5._maid:GiveTask(subscribe(fishingMovementLockedAtom, function(p7) -- line: 98
        -- upvalues: p5 (copy)
        if p7 then
            return
        end

        p5:stopFlyMusic(0)

        local _currentBackgroundSound = p5._currentBackgroundSound

        if _currentBackgroundSound ~= nil then
            _currentBackgroundSound:Resume()
        end
    end))
    p5._maid:GiveTask(subscribe(deluluRiftMusicAtom, function(p8) -- line: 111
        -- upvalues: p5 (copy)
        if p8 then
            p5:switchToDeluluFlyMusic()
        end
    end))
    p5:warmSfxCache({
        "BubblesUp",
        "JackpotFishSuccess",
        "SkillCheckSuccess"
    })
    task.spawn(function() -- line: 120
        -- upvalues: p5 (copy), ContentProvider (copy)
        local OpenExclusiveShop = p5:getSound("OpenExclusiveShop")

        local function v11() -- line: 122
            -- upvalues: OpenExclusiveShop (copy), ContentProvider (copy)
            return ContentProvider:PreloadAsync({ OpenExclusiveShop })
        end

        pcall(v11)
    end)
    p5._maid:GiveTask(events.playSoundForPlayer:connect(function(p9, p10) -- line: 126
        -- upvalues: p5 (copy)
        local v12 = if p10 == nil then 0 else p10

        if p9 == "Mining" then
            v12 = 0.45
        elseif p9 == "Mined" then
            v12 = 0.65
        end

        p5:playSound(p9, v12)
    end))
end

function self._switchBackgroundMusic(p11, p12) -- line: 138
    if p11._currentBackgroundSound then
        p11._currentBackgroundSound:Stop()
    end

    if p11._currentBackgroundSoundSecondary then
        p11._currentBackgroundSoundSecondary:Stop()
    end

    p11._currentBackgroundSound = nil
    p11._currentBackgroundSoundSecondary = nil
    p11._backgroundMusicMaid:DoCleaning()

    if p12 ~= "Glitched" then
        if p12 == "eventIsland" then
            p11:_playBackgroundLoop("EventIslandMusic", "eventIsland")
        else
            p11:_playBackgroundLoop("LifeInAnElevator", "lobby")
        end
    end
end

function self._playBackgroundLoop(p13, p14, p15) -- line: 156
    -- upvalues: selectCurrentWeathers (copy), localPlayerUserId (copy), selectIsCelebrationPlace (copy)
    local v13 = p13:getSound(p14)

    p13._currentBackgroundSound = v13
    p13._backgroundMusicMaid:GiveTask(v13.Ended:Connect(function() -- line: 159
        -- upvalues: p13 (copy), p14 (copy), p15 (copy), selectCurrentWeathers (copy), localPlayerUserId (copy), selectIsCelebrationPlace (copy)
        local v14 = p13._reflexController:getClientProducer():getState()

        if (if selectIsCelebrationPlace(localPlayerUserId)(v14) then "eventIsland" elseif selectCurrentWeathers(v14).Glitched == nil then "lobby" else "Glitched") == p15 then
            p13:_playBackgroundLoop(p14, p15)
        end
    end))

    if not v13.IsLoaded then
        p13._backgroundMusicMaid:GiveTask(v13.Loaded:Once(function() -- line: 168
            -- upvalues: p13 (copy), v13 (copy)
            if p13._currentBackgroundSound == v13 then
                v13.TimePosition = 0
                v13:Play()
            end
        end))

        return nil
    end

    v13.TimePosition = 0
    v13:Play()
end

function self.previewVolume(p16, p17, p18) -- line: 179
    p16:getSoundGroup(p17).Volume = p18
end

function self.registerSound(p19, p20) -- line: 182
    -- upvalues: SoundService (copy)
    local v15 = p19._registeredSounds[p20]

    if v15 then
        return v15
    end

    local Sound = Instance.new("Sound")

    Sound.SoundId = p20
    Sound.SoundGroup = p19:getSoundGroup("sfx")
    Sound.Parent = SoundService
    p19._registeredSounds[p20] = Sound

    return Sound
end

function self.getRegisteredSound(p21, p22) -- line: 198
    return p21._registeredSounds[p22]
end

function self.pauseBackgroundMusic(p23) -- line: 203
    local _currentBackgroundSound = p23._currentBackgroundSound

    if _currentBackgroundSound ~= nil then
        _currentBackgroundSound = _currentBackgroundSound.IsPlaying
    end

    if _currentBackgroundSound == nil then
        _currentBackgroundSound = false
    end

    local _currentBackgroundSound2 = p23._currentBackgroundSound

    if _currentBackgroundSound2 ~= nil then
        _currentBackgroundSound2:Pause()
    end

    return _currentBackgroundSound
end

function self.resumeBackgroundMusic(p24) -- line: 219
    local _currentBackgroundSound = p24._currentBackgroundSound

    if _currentBackgroundSound ~= nil then
        _currentBackgroundSound:Resume()
    end
end

function self.playSound(p25, p26, p27) -- line: 225
    local v16 = if p27 == nil then 0 else p27
    local v17 = p25:getSound(p26)

    v17.TimePosition = v16
    v17:Play()

    return v17
end

function self.playPourLava(p28) -- line: 235
    p28:playSound("PourLava1")
    task.delay(0.5, function() -- line: 237
        -- upvalues: p28 (copy)
        p28:playSound("PourLava2")
    end)
end

function self._getMusicSound(_, p30) -- line: 241
    -- upvalues: ReplicatedStorage (copy)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild("music")
    end

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild(p30)
    end

    return if Sounds ~= nil and Sounds:IsA("Sound") then Sounds else nil
end

function self.playRareFishEncounter(p31, p32) -- line: 254
    local v18 = if p32 == nil then 1.6 else p32
    local RareFishEncounter = p31:_getMusicSound("RareFishEncounter")

    if RareFishEncounter == nil then
        warn("[SoundController] RareFishEncounter not found in Sounds.music")

        return nil
    end

    RareFishEncounter.Looped = false
    RareFishEncounter.TimePosition = 0
    RareFishEncounter:Play()
    p31._rareFishAudioMaid:GiveTask(function() -- line: 266
        -- upvalues: RareFishEncounter (copy)
        return RareFishEncounter:Stop()
    end)
    p31._rareFishAudioMaid:GiveTask(task.delay(v18, function() -- line: 269
        -- upvalues: RareFishEncounter (copy)
        return RareFishEncounter:Stop()
    end))
end

function self.playRareFishMusic(p33, p34) -- line: 273
    local v19 = if p34 == nil then 43.1 else p34
    local RareFishMusic = p33:_getMusicSound("RareFishMusic")

    if RareFishMusic == nil then
        warn("[SoundController] RareFishMusic not found in Sounds.music")

        return nil
    end

    RareFishMusic.Looped = true
    RareFishMusic.TimePosition = v19
    RareFishMusic:Play()
    p33._rareFishAudioMaid:GiveTask(function() -- line: 285
        -- upvalues: RareFishMusic (copy)
        RareFishMusic:Stop()
        RareFishMusic.Looped = false
    end)
end

function self.stopRareFishAudio(p35) -- line: 290
    p35._rareFishAudioMaid:DoCleaning()
end

function self.playFlyMusic(p36) -- line: 293
    p36:_playFlyMusicTrack("FlyMusic")
end

function self.switchToDeluluFlyMusic(p37) -- line: 296
    p37:_playFlyMusicTrack("FlyMusicDelulu")
end

function self._playFlyMusicTrack(p38, p39) -- line: 299
    local v20 = p38:_getMusicSound(p39)

    if v20 == nil then
        warn((("[SoundController] %* not found in Sounds.music"):format(p39)))

        return nil
    end

    p38._flyMusicMaid:DoCleaning()
    p38._flyMusicSound = v20
    p38._flyMusicVolume = v20.Volume
    v20.Looped = false
    v20.TimePosition = 1.5
    v20:Play()
    p38._flyMusicMaid:GiveTask(function() -- line: 315
        -- upvalues: p38 (copy), v20 (copy)
        v20:Stop()
        v20.Volume = p38._flyMusicVolume

        if p38._flyMusicSound == v20 then
            p38._flyMusicSound = nil
        end
    end)
end

function self.fadeFlyMusicVolume(p40, p41, p42) -- line: 323
    -- upvalues: TweenService (copy)
    local v21 = if p42 == nil then 0.6 else p42
    local _flyMusicSound = p40._flyMusicSound

    if _flyMusicSound == nil or not _flyMusicSound.IsPlaying then
        return nil
    end

    local v22 = p40._flyMusicVolume * p41

    if v21 <= 0 then
        _flyMusicSound.Volume = v22

        return nil
    end

    local v23 = TweenService:Create(_flyMusicSound, TweenInfo.new(v21, Enum.EasingStyle.Linear), {
        Volume = v22
    })

    p40._flyMusicMaid:GiveTask(function() -- line: 339
        -- upvalues: v23 (copy)
        return v23:Cancel()
    end)
    v23:Play()
end

function self.stopFlyMusic(p43, p44) -- line: 344
    -- upvalues: TweenService (copy)
    local v24 = if p44 == nil then 0.6 else p44
    local _flyMusicSound = p43._flyMusicSound

    if _flyMusicSound == nil or v24 <= 0 or not _flyMusicSound.IsPlaying then
        p43._flyMusicMaid:DoCleaning()

        return nil
    end

    local v25 = TweenService:Create(_flyMusicSound, TweenInfo.new(v24, Enum.EasingStyle.Linear), {
        Volume = 0
    })

    p43._flyMusicMaid:GiveTask(function() -- line: 356
        -- upvalues: v25 (copy)
        return v25:Cancel()
    end)
    v25.Completed:Once(function() -- line: 359
        -- upvalues: p43 (copy)
        return p43._flyMusicMaid:DoCleaning()
    end)
    v25:Play()
end

function self._getCachedSfx(p45, p46) -- line: 364
    -- upvalues: ReplicatedStorage (copy), SoundService (copy)
    local v26 = p45._sfxInstanceCache[p46]

    if v26 ~= nil then
        return v26
    end

    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild("sfx")
    end

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild(p46)
    end

    if Sounds == nil or not Sounds:IsA("Sound") then
        warn((("[SoundController] sfx %* not found in Sounds.sfx"):format(p46)))

        return nil
    end

    local clone = Sounds:Clone()

    clone.Parent = SoundService
    p45._sfxInstanceCache[p46] = clone

    return clone
end

function self.playSfxInstant(p47, p48) -- line: 392
    local v27 = p47:_getCachedSfx(p48)

    if v27 == nil then
        return nil
    end

    v27.TimePosition = 0
    v27:Play()
end

function self.warmSfxCache(p49, p50) -- line: 400
    for _, v28 in p50 do
        p49:_getCachedSfx(v28)
    end
end

function self.playSoundPolyphonic(p51, p52, p53, p54, p55) -- line: 405
    -- upvalues: SoundService (copy)
    local clone = p51:getSound(p52):Clone()

    if p53 ~= nil then
        clone.PlaybackSpeed = p53
    end

    if p54 ~= nil then
        clone.Volume = p54
    end

    if p55 ~= nil then
        clone.TimePosition = p55
    end

    clone.Parent = SoundService
    clone:Play()
    clone.Ended:Once(function() -- line: 419
        -- upvalues: clone (copy)
        return clone:Destroy()
    end)
end

self.defaultMusicVolume = 0.5
self.defaultSfxVolume = 0.5
Reflect.defineMetadata(self, "identifier", "client/controllers/sound-controller@SoundController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    SoundController = self
}

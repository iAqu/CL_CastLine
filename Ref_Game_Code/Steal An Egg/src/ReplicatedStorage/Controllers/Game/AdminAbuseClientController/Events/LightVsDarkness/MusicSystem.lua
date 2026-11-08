-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Preferences = require(ReplicatedStorage.Shared.Preferences)

require(ReplicatedStorage.Packages.Trove)

local Quad = Enum.EasingStyle.Quad
local InOut = Enum.EasingDirection.InOut
local v1
local t1 = {}
local v2 = false

local function resolveTrack(p1) -- line: 47
    -- upvalues: SoundService (copy)
    local v3 = script:FindFirstChild(p1)

    assert(v3 and v3:IsA("Sound"), (("LightVsDarkness.%* must be a Sound"):format(p1)))

    local AdminAbuseMusic = SoundService.Music:FindFirstChild("AdminAbuseMusic")

    assert(AdminAbuseMusic and AdminAbuseMusic:IsA("SoundGroup"), "SoundService.Music.AdminAbuseMusic must be a SoundGroup")
    v3.SoundGroup = AdminAbuseMusic
    v3.Looped = true

    return {
        Sound = v3,
        Volume = v3.Volume
    }
end

local MusicNormal = resolveTrack("MusicNormal")
local MusicIntense = resolveTrack("MusicIntense")

local function fade(p2, p3) -- line: 62
    -- upvalues: Audio (copy), Quad (copy), InOut (copy), t1 (copy)
    local Sound = p2.Sound
    local v7 = t1[Sound]

    if v7 then
        v7:Cancel()
    end

    if p3 > 0 and not Sound.IsPlaying then
        Sound.Volume = 0
        Sound:Play()
    end

    local v8 = Audio.FadeTo(Sound, {
        Seconds = 1.5,
        Volume = p3,
        Style = Quad,
        Direction = InOut
    })

    t1[Sound] = v8
    v8.Completed:Once(function(p4) -- line: 74
        -- upvalues: p3 (copy), Sound (copy), v8 (copy), t1 (copy)
        if t1[Sound] == v8 then
            t1[Sound] = nil

            if p4 == Enum.PlaybackState.Completed and p3 <= 0 then
                Sound:Stop()
            end
        end
    end)
end

local function isFinalClash() -- line: 85
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("LvdFinalClash") == true
end

local function refresh() -- line: 91
    -- upvalues: Workspace (copy), Preferences (copy), v2 (ref), MusicNormal (copy), MusicIntense (copy), fade (copy)
    local v9 = v2 and Preferences.IsOn("Music")
    local v10 = Workspace:GetAttribute("LvdFinalClash") == true

    fade(MusicNormal, if not v9 or v10 then 0 else MusicNormal.Volume)
    fade(MusicIntense, if not v9 or not v10 then 0 else MusicIntense.Volume)
end

local function stop() -- line: 98
    -- upvalues: Workspace (copy), Preferences (copy), v2 (ref), MusicNormal (copy), MusicIntense (copy), fade (copy)
    if not v2 then
        return
    end

    v2 = false

    local v13 = v2 and Preferences.IsOn("Music")
    local v14 = Workspace:GetAttribute("LvdFinalClash") == true

    fade(MusicNormal, if not v13 or v14 then 0 else MusicNormal.Volume)
    fade(MusicIntense, if not v13 or not v14 then 0 else MusicIntense.Volume)
end

local function start() -- line: 107
    -- upvalues: Workspace (copy), MusicDirector (copy), Preferences (copy), v1 (ref), v2 (ref), MusicNormal (copy), MusicIntense (copy), fade (copy), refresh (copy), stop (copy)
    local AssetTrove = v1.AssetTrove

    v2 = true
    MusicDirector.SetEventMusic(true)
    AssetTrove:Add(function() -- line: 111
        -- upvalues: MusicDirector (copy)
        MusicDirector.SetEventMusic(false)
    end)
    AssetTrove:Connect(Workspace:GetAttributeChangedSignal("LvdFinalClash"), refresh)
    AssetTrove:Add(Preferences.Observe("Music", function() -- line: 115
        -- upvalues: Workspace (copy), Preferences (copy), v2 (ref), MusicNormal (copy), MusicIntense (copy), fade (copy)
        local v17 = v2 and Preferences.IsOn("Music")
        local v18 = Workspace:GetAttribute("LvdFinalClash") == true

        fade(MusicNormal, if not v17 or v18 then 0 else MusicNormal.Volume)
        fade(MusicIntense, if not v17 or not v18 then 0 else MusicIntense.Volume)
    end))
    AssetTrove:Add(stop)
end

return function(p5) -- line: 123
    -- upvalues: v1 (ref), stop (copy), start (copy)
    v1 = p5

    return {
        Start = start,
        Stop = stop
    }
end

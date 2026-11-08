-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local MountRace = require(ReplicatedStorage.Data.MountRace)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Preferences = require(ReplicatedStorage.Shared.Preferences)

require(ReplicatedStorage.Packages.Trove)

local v1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v2 = TweenInfo.new(0.15)

local function load(p1) -- line: 31
    -- upvalues: SoundService (copy)
    local clone = p1:Clone()

    clone.Volume = 0
    clone.Parent = SoundService

    return clone
end

local function pick(p2, p3) -- line: 39
    local v3 = if p2 == nil then nil else p2:FindFirstChild(p3.Name)

    if v3 == nil then
        return p3
    end

    assert(v3:IsA("Sound"), (("%* is not a Sound"):format((v3:GetFullName()))))

    return v3
end

local t1 = {}

t1.__index = t1

function t1.Run(p4, p5) -- line: 67
    -- upvalues: Debris (copy), SoundService (copy), TweenService (copy), MountRace (copy), MusicDirector (copy), Preferences (copy), v1 (copy), t1 (copy)
    local Music = p5:FindFirstChild("Music")
    local PreRaceMusic = MountRace.Sounds.PreRaceMusic
    local v5 = if Music == nil then nil else Music:FindFirstChild(PreRaceMusic.Name)

    if v5 ~= nil then
        PreRaceMusic = v5
        assert(v5:IsA("Sound"), (("%* is not a Sound"):format((v5:GetFullName()))))
    end

    local t2 = {}

    t2.PreRace = PreRaceMusic

    local RaceMusic = MountRace.Sounds.RaceMusic
    local v7 = if Music == nil then nil else Music:FindFirstChild(RaceMusic.Name)

    if v7 ~= nil then
        RaceMusic = v7
        assert(v7:IsA("Sound"), (("%* is not a Sound"):format((v7:GetFullName()))))
    end

    t2.Race = RaceMusic

    local FinalLapMusic = MountRace.Sounds.FinalLapMusic
    local v9 = if Music == nil then nil else Music:FindFirstChild(FinalLapMusic.Name)

    if v9 ~= nil then
        FinalLapMusic = v9
        assert(v9:IsA("Sound"), (("%* is not a Sound"):format((v9:GetFullName()))))
    end

    t2.FinalLap = FinalLapMusic

    local VictoryMusic = MountRace.Sounds.VictoryMusic
    local v11 = if Music == nil then nil else Music:FindFirstChild(VictoryMusic.Name)

    if v11 ~= nil then
        VictoryMusic = v11
        assert(v11:IsA("Sound"), (("%* is not a Sound"):format((v11:GetFullName()))))
    end

    t2.Victory = VictoryMusic

    local clone = t2.Victory:Clone()

    clone.Volume = 0
    clone.Parent = SoundService

    local t3 = {
        Wanted = "Race",
        StartAt = nil,
        Playing = nil,
        Enabled = true
    }
    local t4 = {}
    local clone2 = t2.PreRace:Clone()

    clone2.Volume = 0
    clone2.Parent = SoundService
    t4.PreRace = clone2

    local clone3 = t2.Race:Clone()

    clone3.Volume = 0
    clone3.Parent = SoundService
    t4.Race = clone3

    local clone4 = t2.FinalLap:Clone()

    clone4.Volume = 0
    clone4.Parent = SoundService
    t4.FinalLap = clone4
    t4.Victory = clone
    t3.Sounds = t4
    t3.Volumes = {
        PreRace = t2.PreRace.Volume,
        Race = t2.Race.Volume,
        FinalLap = t2.FinalLap.Volume,
        Victory = t2.Victory.Volume
    }
    t3.Tweens = {}

    local v13 = setmetatable(t3, t1)

    MusicDirector.SetEventMusic(true)
    p4:Add(Preferences.Observe("Music", function(p6) -- line: 98
        -- upvalues: v13 (copy)
        v13.Enabled = p6 ~= false
        v13:Apply()
    end))
    p4:Connect(clone.Ended, function() -- line: 103
        -- upvalues: v13 (copy)
        if v13.Wanted == "Victory" then
            v13:Play("Race")
        end
    end)
    p4:Add(function() -- line: 108
        -- upvalues: v13 (copy), Debris (copy), TweenService (copy), MusicDirector (copy), v1 (copy)
        MusicDirector.SetEventMusic(false)

        for _, v14 in v13.Sounds do
            local v15 = v13.Tweens[v14]

            if v15 ~= nil then
                v15:Cancel()
            end

            TweenService:Create(v14, v1, {
                Volume = 0
            }):Play()
            Debris:AddItem(v14, v1.Time)
        end
    end)
    v13:Apply()

    return v13
end

function t1.Fade(p7, p8, p9, p10, p11) -- line: 123
    -- upvalues: TweenService (copy), v1 (copy)
    local v16 = p7.Tweens[p8]

    if v16 ~= nil then
        v16:Cancel()
    end

    if p9 > 0 and not p8.IsPlaying then
        p8.TimePosition = p10 or 0
        p8:Play()
    end

    local tween = TweenService:Create(p8, p11 or v1, {
        Volume = p9
    })

    p7.Tweens[p8] = tween
    tween.Completed:Once(function(p12) -- line: 134
        -- upvalues: p7 (copy), p8 (copy), p9 (copy), tween (copy)
        if p7.Tweens[p8] == tween then
            p7.Tweens[p8] = nil
        end

        if p12 == Enum.PlaybackState.Completed and p9 <= 0 then
            p8:Stop()
        end
    end)
    tween:Play()
end

function t1.Apply(p13) -- line: 145
    -- upvalues: v1 (copy), v2 (copy)
    local Wanted = if p13.Enabled then p13.Wanted else nil

    if Wanted == p13.Playing then
        p13.StartAt = nil
    else
        local Playing = p13.Playing

        p13.Playing = Wanted

        local v17 = if Playing == "PreRace" or Wanted == "PreRace" then v2 else v1

        if Playing ~= nil then
            p13:Fade(p13.Sounds[Playing], 0, nil, v17)
        end

        if Wanted ~= nil then
            local StartAt = if Playing == "Race" and Wanted == "FinalLap" then p13.Sounds.Race.TimePosition else p13.StartAt

            p13.StartAt = nil
            p13:Fade(p13.Sounds[Wanted], p13.Volumes[Wanted], StartAt, v17)
        end
    end
end

function t1.Play(p14, p15, p16) -- line: 167
    p14.Wanted = p15
    p14.StartAt = p16
    p14:Apply()
end

return t1

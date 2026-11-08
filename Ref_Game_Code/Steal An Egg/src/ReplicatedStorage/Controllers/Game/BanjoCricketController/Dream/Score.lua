-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)

require(ReplicatedStorage.Packages.Trove)

local v1 = NumberRange.new(0.26, 0.42)
local t1 = {
    0.5, 1, 1, 2
}
local t2 = {}

local function effect(p1, p2) -- line: 98
    if p1 then
        p2.Parent = p1
    else
        p2:Destroy()
    end
end

local function reverb(p3, p4, p5) -- line: 106
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = p3
    ReverbSoundEffect.Density = 1
    ReverbSoundEffect.Diffusion = 1
    ReverbSoundEffect.DryLevel = p4
    ReverbSoundEffect.WetLevel = p5

    return ReverbSoundEffect
end

local function equalizer(p6, p7, p8) -- line: 120
    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = p6
    EqualizerSoundEffect.MidGain = p7
    EqualizerSoundEffect.HighGain = p8

    return EqualizerSoundEffect
end

local function layer(p9, p10, p11, p12) -- line: 132
    -- upvalues: Audio (copy)
    local v2 = Audio.Play(p10, script, {
        Deferred = true,
        Volume = 0,
        Looped = p11,
        PlaybackSpeed = p12,
        SoundGroup = p9.Bus
    })

    if v2 then
        p9.Trove:Add(v2)
    end

    return v2
end

local function play(p13, p14, p15) -- line: 151
    if p13 == nil then
        return
    end

    p13.Volume = p14
    p13.TimePosition = p15 or 0
    p13:Play()
end

local function setVolume(p16, p17) -- line: 160
    if p16 then
        p16.Volume = p17
    end
end

local function setSpeed(p18, p19) -- line: 166
    if p18 then
        p18.PlaybackSpeed = p19
    end
end

local function smooth(p20) -- line: 172
    local v3 = math.clamp(p20, 0, 1)

    return v3 * v3 * (3 - v3 * 2)
end

local function bandSong() -- line: 179
    -- upvalues: CollectionService (copy), Workspace (copy), BanjoCricket (copy)
    for _, v4 in CollectionService:GetTagged(BanjoCricket.Tags.Music) do
        if v4:IsDescendantOf(Workspace) then
            for _, descendant in v4:GetDescendants() do
                if descendant:IsA("Sound") and descendant.IsPlaying and descendant.SoundId == BanjoCricket.Sounds.Band then
                    return descendant
                end
            end
        end
    end

    return nil
end

local function bus(p21) -- line: 197
    -- upvalues: SoundService (copy)
    local SoundGroup = Instance.new("SoundGroup")

    SoundGroup.Name = "BanjoDream"
    SoundGroup.Volume = 1

    local Gameplay = SoundService:FindFirstChild("Gameplay")

    SoundGroup.Parent = if not (Gameplay and Gameplay:IsA("SoundGroup")) then SoundService else Gameplay

    return p21:Add(SoundGroup)
end

local function duck(p22) -- line: 210
    -- upvalues: SoundService (copy)
    local Music = SoundService:FindFirstChild("Music")

    if Music == nil or not Music:IsA("SoundGroup") then
        return nil
    end

    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = 0
    EqualizerSoundEffect.MidGain = 0
    EqualizerSoundEffect.HighGain = 0

    local v5 = p22:Add(EqualizerSoundEffect)

    v5.Name = "BanjoDreamDuck"
    v5.Parent = Music

    return v5
end

local function fadeDuck(p23, p24, p25) -- line: 221
    -- upvalues: TweenService (copy)
    local Duck = p23.Duck

    if Duck ~= nil then
        TweenService:Create(Duck, TweenInfo.new(p25), {
            LowGain = p24,
            MidGain = p24,
            HighGain = p24
        }):Play()
    end
end

function t2.Build(p26) -- line: 233
    -- upvalues: SoundService (copy), BanjoCricket (copy), layer (copy)
    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = 0
    EqualizerSoundEffect.MidGain = 0
    EqualizerSoundEffect.HighGain = 0
    EqualizerSoundEffect.Name = "Muffle"

    local t3 = {
        NextPing = 0,
        Born = false,
        Trove = p26
    }
    local SoundGroup = Instance.new("SoundGroup")

    SoundGroup.Name = "BanjoDream"
    SoundGroup.Volume = 1

    local Gameplay = SoundService:FindFirstChild("Gameplay")

    SoundGroup.Parent = if not (Gameplay and Gameplay:IsA("SoundGroup")) then SoundService else Gameplay
    t3.Bus = p26:Add(SoundGroup)
    t3.Muffle = EqualizerSoundEffect

    local Music = SoundService:FindFirstChild("Music")
    local v6

    if Music ~= nil and Music:IsA("SoundGroup") then
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

        EqualizerSoundEffect.LowGain = 0
        EqualizerSoundEffect.MidGain = 0
        EqualizerSoundEffect.HighGain = 0
        v6 = p26:Add(EqualizerSoundEffect)
        v6.Name = "BanjoDreamDuck"
        v6.Parent = Music
    end

    t3.Duck = v6
    t3.Echoes = {}
    t3.EchoSpeeds = {}
    t3.Strings = {}
    t3.Random = Random.new()
    EqualizerSoundEffect.Parent = t3.Bus

    local CompressorSoundEffect = Instance.new("CompressorSoundEffect")

    CompressorSoundEffect.Threshold = -14
    CompressorSoundEffect.Ratio = 3
    CompressorSoundEffect.Attack = 0.01
    CompressorSoundEffect.Release = 0.25
    CompressorSoundEffect.Parent = t3.Bus
    t3.Drone = layer(t3, BanjoCricket.Sounds.BanjoLoop, true, 0.62)

    local FlangeSoundEffect = Instance.new("FlangeSoundEffect")

    FlangeSoundEffect.Depth = 0.6
    FlangeSoundEffect.Mix = 0.75
    FlangeSoundEffect.Rate = 0.35

    local Drone = t3.Drone

    if Drone then
        FlangeSoundEffect.Parent = Drone
    else
        FlangeSoundEffect:Destroy()
    end

    local TremoloSoundEffect = Instance.new("TremoloSoundEffect")

    TremoloSoundEffect.Depth = 0.55
    TremoloSoundEffect.Duty = 0.5
    TremoloSoundEffect.Frequency = 5

    local Drone2 = t3.Drone

    if Drone2 then
        TremoloSoundEffect.Parent = Drone2
    else
        TremoloSoundEffect:Destroy()
    end

    local Drone3 = t3.Drone
    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.DecayTime = 3.5
    ReverbSoundEffect.Density = 1
    ReverbSoundEffect.Diffusion = 1
    ReverbSoundEffect.DryLevel = -4
    ReverbSoundEffect.WetLevel = -2

    if Drone3 then
        ReverbSoundEffect.Parent = Drone3
    else
        ReverbSoundEffect:Destroy()
    end

    t3.Swell = layer(t3, BanjoCricket.Sounds.BanjoLoop, true, 0.8)

    local Swell = t3.Swell
    local ReverbSoundEffect2 = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect2.DecayTime = 4
    ReverbSoundEffect2.Density = 1
    ReverbSoundEffect2.Diffusion = 1
    ReverbSoundEffect2.DryLevel = -80
    ReverbSoundEffect2.WetLevel = 0

    if Swell then
        ReverbSoundEffect2.Parent = Swell
    else
        ReverbSoundEffect2:Destroy()
    end

    t3.Hole = layer(t3, "rbxassetid://125113804733808", true, 0.75)

    local FlangeSoundEffect2 = Instance.new("FlangeSoundEffect")

    FlangeSoundEffect2.Depth = 0.4
    FlangeSoundEffect2.Mix = 0.5
    FlangeSoundEffect2.Rate = 1.2

    local Hole = t3.Hole

    if Hole then
        FlangeSoundEffect2.Parent = Hole
    else
        FlangeSoundEffect2:Destroy()
    end

    t3.Shimmer = layer(t3, "rbxassetid://124699703411879", true, 1)

    local Shimmer = t3.Shimmer
    local ReverbSoundEffect3 = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect3.DecayTime = 2.5
    ReverbSoundEffect3.Density = 1
    ReverbSoundEffect3.Diffusion = 1
    ReverbSoundEffect3.DryLevel = -2
    ReverbSoundEffect3.WetLevel = -6

    if Shimmer then
        ReverbSoundEffect3.Parent = Shimmer
    else
        ReverbSoundEffect3:Destroy()
    end

    t3.Riser = layer(t3, "rbxassetid://101937236820642", false, 1.35)
    t3.Suck = layer(t3, "rbxassetid://99901482459638", false, 1.15)
    t3.Swoosh = layer(t3, "rbxassetid://3755636638", false, 0.75)

    local Swoosh = t3.Swoosh
    local ReverbSoundEffect4 = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect4.DecayTime = 2
    ReverbSoundEffect4.Density = 1
    ReverbSoundEffect4.Diffusion = 1
    ReverbSoundEffect4.DryLevel = 0
    ReverbSoundEffect4.WetLevel = -6

    if Swoosh then
        ReverbSoundEffect4.Parent = Swoosh
    else
        ReverbSoundEffect4:Destroy()
    end

    t3.Lub = layer(t3, "rbxassetid://92084213757630", false, 0.55)

    local Lub = t3.Lub
    local EqualizerSoundEffect2 = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect2.LowGain = 3
    EqualizerSoundEffect2.MidGain = -14
    EqualizerSoundEffect2.HighGain = -40

    if Lub then
        EqualizerSoundEffect2.Parent = Lub
    else
        EqualizerSoundEffect2:Destroy()
    end

    t3.Dub = layer(t3, "rbxassetid://92084213757630", false, 0.64)

    local Dub = t3.Dub
    local EqualizerSoundEffect3 = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect3.LowGain = 2
    EqualizerSoundEffect3.MidGain = -14
    EqualizerSoundEffect3.HighGain = -40

    if Dub then
        EqualizerSoundEffect3.Parent = Dub
    else
        EqualizerSoundEffect3:Destroy()
    end

    t3.Boom = layer(t3, "rbxassetid://119977062667102", false, 1)

    local Boom = t3.Boom
    local EqualizerSoundEffect4 = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect4.LowGain = 2
    EqualizerSoundEffect4.MidGain = -4
    EqualizerSoundEffect4.HighGain = -16

    if Boom then
        EqualizerSoundEffect4.Parent = Boom
    else
        EqualizerSoundEffect4:Destroy()
    end

    t3.Sparkle = layer(t3, "rbxassetid://123855152382706", false, 1)
    t3.Room = layer(t3, BanjoCricket.Sounds.Band, true, 1)

    for v7, v8 in BanjoCricket.Mushrooms do
        local v9 = layer(t3, v8.Sound, false, v8.Speed)

        if v9 then
            local EchoSoundEffect = Instance.new("EchoSoundEffect")

            EchoSoundEffect.Delay = 0.22
            EchoSoundEffect.Feedback = 0.55
            EchoSoundEffect.DryLevel = 0
            EchoSoundEffect.WetLevel = -2
            EchoSoundEffect.Parent = v9
            t3.Echoes[v7] = v9
            t3.EchoSpeeds[v7] = v8.Speed
        end

        local v10 = layer(t3, v8.Sound, false, v8.Speed)

        if v10 then
            local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

            ReverbSoundEffect.DecayTime = 2.5
            ReverbSoundEffect.Density = 1
            ReverbSoundEffect.Diffusion = 1
            ReverbSoundEffect.DryLevel = 0
            ReverbSoundEffect.WetLevel = -5
            ReverbSoundEffect.Parent = v10
            t3.Strings[v7] = v10
        end
    end

    return t3
end

function t2.Warm() -- line: 317
    -- upvalues: BanjoCricket (copy), Preload (copy)
    local t4 = {
        BanjoCricket.Sounds.BanjoLoop,
        "rbxassetid://125113804733808",
        "rbxassetid://99901482459638",
        "rbxassetid://101937236820642",
        "rbxassetid://119977062667102",
        "rbxassetid://3755636638",
        "rbxassetid://92084213757630",
        "rbxassetid://124699703411879",
        "rbxassetid://123855152382706"
    }

    for _, v11 in BanjoCricket.Mushrooms do
        table.insert(t4, v11.Sound)
    end

    task.spawn(Preload.WarmSounds, t4)
end

function t2.Fall(p27, p28) -- line: 337
    -- upvalues: BanjoCricket (copy), play (copy), fadeDuck (copy)
    fadeDuck(p27, -30, 0.5)

    local Drone = p27.Drone

    if Drone ~= nil then
        Drone.Volume = 0
        Drone.TimePosition = 0
        Drone:Play()
    end

    local Swell = p27.Swell
    local v12 = p27.Random:NextNumber(0, 9)

    if Swell ~= nil then
        Swell.Volume = 0
        Swell.TimePosition = v12 or 0
        Swell:Play()
    end

    local Suck = p27.Suck

    if Suck ~= nil then
        Suck.Volume = 0.4
        Suck.TimePosition = 0
        Suck:Play()
    end

    local Riser = p27.Riser

    if Riser then
        local v14 = math.max(3.3 - p28 * 1.35, 0)

        if Riser ~= nil then
            Riser.Volume = 0.32
            Riser.TimePosition = v14 or 0
            Riser:Play()
        end
    end

    local v15 = #BanjoCricket.Mushrooms

    for i = 0, v15 - 1 do
        local v16 = p27.Echoes[v15 - i]

        if v16 then
            p27.Trove:Add(task.delay(i * 0.09, play, v16, 0.38))
        end
    end
end

function t2.Plunge(p29) -- line: 362
    local Swoosh = p29.Swoosh

    if Swoosh ~= nil then
        Swoosh.Volume = 0.7
        Swoosh.TimePosition = 0
        Swoosh:Play()
    end

    local Swell = p29.Swell

    if Swell then
        Swell.Volume = 0
    end

    local Hole = p29.Hole

    if Hole ~= nil then
        Hole.Volume = 0
        Hole.TimePosition = 0
        Hole:Play()
    end

    local Shimmer = p29.Shimmer

    if Shimmer == nil then
        return
    end

    Shimmer.Volume = 0
    Shimmer.TimePosition = 0
    Shimmer:Play()
end

function t2.Thump(p30, p31) -- line: 369
    if p31 then
        local Lub = p30.Lub

        if Lub ~= nil then
            Lub.Volume = 0.28
            Lub.TimePosition = 0
            Lub:Play()
        end
    else
        local Dub = p30.Dub

        if Dub ~= nil then
            Dub.Volume = 0.16
            Dub.TimePosition = 0
            Dub:Play()
        end
    end
end

function t2.Wake(p32) -- line: 378
    local Swell = p32.Swell
    local v17 = p32.Random:NextNumber(0, 9)

    if Swell == nil then
        return
    end

    Swell.Volume = 0
    Swell.TimePosition = v17 or 0
    Swell:Play()
end

function t2.Birth(p33) -- line: 384
    -- upvalues: Audio (copy), play (copy), bandSong (copy), fadeDuck (copy)
    p33.Born = true

    for _, v18 in {
            p33.Drone,
            p33.Swell,
            p33.Hole,
            p33.Shimmer
        } do
        if v18 then
            v18:Stop()
        end
    end

    for _, v19 in p33.Echoes do
        v19:Stop()
    end

    local Trove = p33.Trove

    Trove:Add(task.delay(0.12, function() -- line: 395
        -- upvalues: p33 (copy), Trove (copy), play (copy)
        local Boom = p33.Boom

        if Boom ~= nil then
            Boom.Volume = 0.28
            Boom.TimePosition = 0
            Boom:Play()
        end

        local Sparkle = p33.Sparkle

        if Sparkle ~= nil then
            Sparkle.Volume = 0.45
            Sparkle.TimePosition = 0
            Sparkle:Play()
        end

        for v20, v21 in p33.Strings do
            Trove:Add(task.delay((v20 - 1) * 0.05, play, v21, 0.5))
        end
    end))
    Trove:Add(task.delay(0.35, function() -- line: 404
        -- upvalues: p33 (copy), Audio (copy), bandSong (copy)
        local Room = p33.Room

        if Room == nil then
            return
        end

        local v23 = bandSong()
        local v24 = if v23 then v23.TimePosition else 0

        if Room ~= nil then
            Room.Volume = 0
            Room.TimePosition = v24 or 0
            Room:Play()
        end

        Audio.FadeTo(Room, {
            Volume = 0.26,
            Seconds = 1.2
        })
    end))
    fadeDuck(p33, 0, 1.6)
end

function t2.Release(p34) -- line: 417
    -- upvalues: Audio (copy)
    local Room = p34.Room

    if Room then
        Audio.FadeTo(Room, {
            Volume = 0,
            Seconds = 2.2
        })
    end
end

function t2.Step(p35, p36) -- line: 424
    -- upvalues: BanjoCricket (copy), v1 (copy), t1 (copy)
    local Time = p36.Time

    if p36.Phase == "Intro" then
        local v26 = math.clamp(Time / p36.Length, 0, 1)
        local Drone = p35.Drone
        local v28 = math.clamp(Time / 0.6, 0, 1)
        local v29 = v28 * v28 * (3 - v28 * 2) * 0.6

        if Drone then
            Drone.Volume = v29
        end

        local Drone2 = p35.Drone
        local v31 = math.lerp(0.62, 0.36, v26 ^ 1.5)

        if Drone2 then
            Drone2.PlaybackSpeed = v31
        end

        local Swell = p35.Swell
        local v32 = v26 ^ 3 * 0.9

        if Swell then
            Swell.Volume = v32
        end

        p35.Muffle.HighGain = v26 * -10

        local v33 = math.lerp(1, 0.72, v26)

        for v34, v35 in p35.Echoes do
            v35.PlaybackSpeed = p35.EchoSpeeds[v34] * v33
        end
    elseif p36.Phase == "Ride" then
        local Drone = p35.Drone

        if Drone then
            Drone.Volume = 0.45
        end

        local Drone2 = p35.Drone
        local v37 = math.sin(Time * 2.3) * 0.04 + 0.46

        if Drone2 then
            Drone2.PlaybackSpeed = v37
        end

        local Hole = p35.Hole
        local v39 = math.clamp(Time / 0.35, 0, 1)
        local v40 = v39 * v39 * (3 - v39 * 2) * 1.1

        if Hole then
            Hole.Volume = v40
        end

        local Hole2 = p35.Hole
        local v42 = math.sin(Time * 1.7) * 0.05 + 0.75

        if Hole2 then
            Hole2.PlaybackSpeed = v42
        end

        local Shimmer = p35.Shimmer
        local v44 = math.clamp(Time / 0.5, 0, 1)
        local v45 = v44 * v44 * (3 - v44 * 2) * 1.4

        if Shimmer then
            Shimmer.Volume = v45
        end

        p35.Muffle.HighGain = -3

        local Random = p35.Random

        if p35.NextPing <= Time then
            p35.NextPing = Time + Random:NextNumber(v1.Min, v1.Max)

            local v46 = Random:NextInteger(1, #BanjoCricket.Mushrooms)
            local v47 = p35.Echoes[v46]

            if v47 then
                local v48 = t1[Random:NextInteger(1, #t1)]

                p35.EchoSpeeds[v46] = BanjoCricket.Mushrooms[v46].Speed * v48

                if v47 ~= nil then
                    v47.Volume = 0.30400000000000005
                    v47.TimePosition = 0
                    v47:Play()
                end
            end
        end

        local v50 = math.sin(Time * 9) * 0.03 + 1

        for v51, v52 in p35.Echoes do
            v52.PlaybackSpeed = p35.EchoSpeeds[v51] * v50
        end
    elseif p35.Born then
        p35.Muffle.HighGain = 0
    else
        local v54 = math.clamp(Time / p36.Length, 0, 1)
        local v55 = v54 * v54
        local Drone = p35.Drone
        local v56 = (1 - v54) * 0.45

        if Drone then
            Drone.Volume = v56
        end

        local Drone2 = p35.Drone
        local v57 = math.lerp(0.46, 1.25, v55)

        if Drone2 then
            Drone2.PlaybackSpeed = v57
        end

        local Hole = p35.Hole
        local v58 = (1 - v54) * 1.1

        if Hole then
            Hole.Volume = v58
        end

        local Hole2 = p35.Hole
        local v59 = math.lerp(0.75, 1.6, v55)

        if Hole2 then
            Hole2.PlaybackSpeed = v59
        end

        local Shimmer = p35.Shimmer
        local v60 = (1 - v54) * 1.4

        if Shimmer then
            Shimmer.Volume = v60
        end

        local Swell = p35.Swell
        local v61 = v54 ^ 3 * 0.9

        if Swell then
            Swell.Volume = v61
        end

        p35.Muffle.HighGain = (1 - v54) * -3
    end
end

return table.freeze(t2)

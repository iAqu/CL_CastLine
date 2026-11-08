-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)

require(ReplicatedStorage.Packages.Trove)

local v1 = table.freeze({
    Splash = "rbxassetid://83099379619955",
    Swoosh = "rbxassetid://3755636638",
    Riser = "rbxassetid://101937236820642",
    Suck = "rbxassetid://99901482459638",
    Hole = "rbxassetid://125113804733808",
    Thump = "rbxassetid://92084213757630",
    Whoosh = "rbxassetid://9113077334",
    Crash = "rbxassetid://9119476512",
    Boom = "rbxassetid://119977062667102",
    Shimmer = "rbxassetid://124699703411879",
    Gulp = "rbxassetid://131399570890370",
    Clank = "rbxassetid://99717307993581",
    Giggle = "rbxassetid://119971884687987",
    Pop = "rbxassetid://93817075797663",
    Blub = "rbxassetid://116679049118113",
    Bubbles = "rbxassetid://85713586313967",
    Drone = "rbxassetid://105183066006241",
    Pad = "rbxassetid://136332867876820",
    Gasp = "rbxassetid://80277880055735",
    Pour = "rbxassetid://72104621631194",
    ScoopLong = "rbxassetid://103136552142912",
    ScoopShort = "rbxassetid://118863852017406",
    Flush = "rbxassetid://101426935773542",
    Drip = "rbxassetid://88945982118702"
})
local t1 = {
    Ids = v1
}

local function equalizer(p1, p2, p3) -- line: 67
    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = p1
    EqualizerSoundEffect.MidGain = p2
    EqualizerSoundEffect.HighGain = p3

    return EqualizerSoundEffect
end

local function bus(p4) -- line: 75
    -- upvalues: SoundService (copy)
    local SoundGroup = Instance.new("SoundGroup")

    SoundGroup.Name = "SewerDrain"
    SoundGroup.Volume = 1

    local Gameplay = SoundService:FindFirstChild("Gameplay")

    SoundGroup.Parent = if Gameplay == nil or not Gameplay:IsA("SoundGroup") then SoundService else Gameplay

    return p4:Add(SoundGroup)
end

local function duck(p5) -- line: 84
    -- upvalues: SoundService (copy)
    local Music = SoundService:FindFirstChild("Music")

    if Music == nil or not Music:IsA("SoundGroup") then
        return nil
    end

    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = 0
    EqualizerSoundEffect.MidGain = 0
    EqualizerSoundEffect.HighGain = 0

    local v2 = p5:Add(EqualizerSoundEffect)

    v2.Name = "SewerDrainDuck"
    v2.Parent = Music

    return v2
end

local function fadeEffect(p6, p7, p8) -- line: 95
    -- upvalues: TweenService (copy)
    if p6 ~= nil then
        TweenService:Create(p6, TweenInfo.new(p8), p7):Play()
    end
end

function t1.Warm() -- line: 106
    -- upvalues: Preload (copy), v1 (copy)
    local t2 = {}

    for _, v3 in v1 do
        table.insert(t2, v3)
    end

    task.spawn(Preload.WarmSounds, t2)
end

function t1.Build(p9) -- line: 114
    -- upvalues: SoundService (copy), bus (copy)
    local v4 = bus(p9)
    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

    EqualizerSoundEffect.LowGain = 0
    EqualizerSoundEffect.MidGain = 0
    EqualizerSoundEffect.HighGain = 0
    EqualizerSoundEffect.Name = "Muffle"
    EqualizerSoundEffect.Parent = v4

    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")

    ReverbSoundEffect.Name = "Cave"
    ReverbSoundEffect.DecayTime = 2.2
    ReverbSoundEffect.Density = 1
    ReverbSoundEffect.Diffusion = 1
    ReverbSoundEffect.DryLevel = 0
    ReverbSoundEffect.WetLevel = -80
    ReverbSoundEffect.Parent = v4

    local CompressorSoundEffect = Instance.new("CompressorSoundEffect")

    CompressorSoundEffect.Threshold = -14
    CompressorSoundEffect.Ratio = 3
    CompressorSoundEffect.Attack = 0.01
    CompressorSoundEffect.Release = 0.25
    CompressorSoundEffect.Parent = v4

    local t3 = {
        Trove = p9,
        Bus = v4,
        Muffle = EqualizerSoundEffect,
        Cave = ReverbSoundEffect
    }
    local Music = SoundService:FindFirstChild("Music")
    local v5

    if Music ~= nil and Music:IsA("SoundGroup") then
        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

        EqualizerSoundEffect.LowGain = 0
        EqualizerSoundEffect.MidGain = 0
        EqualizerSoundEffect.HighGain = 0
        v5 = p9:Add(EqualizerSoundEffect)
        v5.Name = "SewerDrainDuck"
        v5.Parent = Music
    end

    t3.Duck = v5
    t3.Loops = {}
    t3.Random = Random.new()

    return t3
end

function t1.Play(p10, p11, p12, p13, p14) -- line: 144
    -- upvalues: Audio (copy), v1 (copy)
    local v6 = v1[p11]

    if v6 == nil then
        return nil
    end

    return Audio.Play(v6, script, {
        SoundGroup = p10.Bus,
        Volume = p12,
        PlaybackSpeed = p13 or 1,
        TimePosition = p14
    })
end

function t1.Loop(p15, p16, p17, p18) -- line: 163
    -- upvalues: Audio (copy), v1 (copy)
    local v7 = p15.Loops[p16]

    if v7 == nil then
        local v8 = v1[p16]

        if v8 == nil then
            return nil
        end

        local v9 = Audio.Play(v8, script, {
            Deferred = true,
            Looped = true,
            SoundGroup = p15.Bus,
            Volume = p17,
            PlaybackSpeed = p18 or 1
        })

        if v9 == nil then
            return nil
        end

        p15.Trove:Add(v9)
        p15.Loops[p16] = v9
        v9:Play()

        return v9
    end

    v7.Volume = p17
    v7.PlaybackSpeed = p18 or v7.PlaybackSpeed

    return v7
end

function t1.Level(p19, p20, p21, p22) -- line: 190
    local v10 = p19.Loops[p20]

    if v10 ~= nil then
        v10.Volume = p21

        if p22 then
            v10.PlaybackSpeed = p22
        end
    end
end

function t1.Fade(p23, p24, p25, p26) -- line: 201
    -- upvalues: TweenService (copy)
    local v11 = p23.Loops[p24]

    if v11 ~= nil then
        TweenService:Create(v11, TweenInfo.new(p26), {
            Volume = p25
        }):Play()
    end
end

function t1.Stop(p27, p28) -- line: 209
    local v12 = p27.Loops[p28]

    if v12 == nil then
        return
    end

    p27.Loops[p28] = nil
    v12:Stop()
    v12:Destroy()
end

function t1.StopAll(p29) -- line: 219
    -- upvalues: t1 (copy)
    for v13 in p29.Loops do
        t1.Stop(p29, v13)
    end

    local Riser = p29.Riser

    p29.Riser = nil

    if Riser ~= nil then
        Riser:Stop()
    end
end

function t1.Duck(p30, p31, p32) -- line: 230
    -- upvalues: TweenService (copy)
    local v14 = if p31 then -30 else 0
    local Duck = p30.Duck
    local t4 = {
        LowGain = v14,
        MidGain = v14,
        HighGain = v14
    }

    if Duck ~= nil then
        TweenService:Create(Duck, TweenInfo.new(p32), t4):Play()
    end
end

function t1.Under(p33, p34, p35) -- line: 235
    -- upvalues: TweenService (copy)
    local v16 = if p34 then -28 else 0
    local v15 = if p34 then -8 else 0
    local Muffle = p33.Muffle
    local t5 = {
        HighGain = v16,
        MidGain = v15,
        LowGain = p34 and 2 or 0
    }

    if Muffle ~= nil then
        TweenService:Create(Muffle, TweenInfo.new(p35), t5):Play()
    end
end

function t1.Echo(p36, p37) -- line: 245
    p36.Cave.WetLevel = p37 and -7 or -80
end

function t1.Rise(p38, p39, p40) -- line: 249
    -- upvalues: t1 (copy)
    local v18 = math.max(3.3 - p39 * 1.35, 0)

    p38.Riser = t1.Play(p38, "Riser", p40, 1.35, v18)
end

function t1.Hush(p41, p42, p43) -- line: 255
    p43 = p43 or {}

    for v20, v21 in p41.Loops do
        if table.find(p43, v20) == nil then
            local Volume = v21.Volume

            v21.Volume = 0
            p41.Trove:Add(task.delay(p42, function() -- line: 261
                -- upvalues: p41 (copy), v20 (copy), Volume (copy), v21 (copy)
                if p41.Loops[v20] == v21 and v21.Volume == 0 then
                    v21.Volume = Volume
                end
            end))
        end
    end
end

return table.freeze(t1)

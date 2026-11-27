-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Roll = require(Shared.Roll)
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local UIKit = require(script.Parent.UIKit)
local ScreenFx = require(script.Parent.ScreenFx)
local SoundPlayer = require(script.Parent.SoundPlayer)
local fromRGB, new = Color3.fromRGB, Vector2.new
local LocalPlayer = Players.LocalPlayer
local v1 = Random.new()
local v2 = fromRGB(255, 255, 255)
local t1 = {}

t1.HOLD_SPEED = 2.6
t1.AllowHold = false
t1.Level = 0
t1.Counts = {}
t1.ForceFakeOut = nil

local function count(p1) -- line: 41
    -- upvalues: t1 (copy)
    t1.Counts[p1] = (t1.Counts[p1] or 0) + 1
end

local function sound(p2, p3) -- line: 44
    -- upvalues: UIKit (copy)
    UIKit.sound(p2, p3)
end

local n1 = 0
local n2 = 0
local n3 = 1
local v3 = false

t1.Rush = false
t1.RUSH_SPEED = 40

function t1.Speed() -- line: 53
    -- upvalues: t1 (copy), n1 (ref), n2 (ref), n3 (ref)
    if t1.Rush then
        return t1.RUSH_SPEED
    end

    local elapsed = os.clock()

    if elapsed < n1 then
        return 0
    end

    if elapsed < n2 then
        return n3
    end

    return 1
end

function t1.HitStop(p4) -- line: 65
    -- upvalues: t1 (copy), n1 (ref)
    local v4 = n1

    n1 = math.max(v4, os.clock() + p4)
    t1.Counts.HitStop = (t1.Counts.HitStop or 0) + 1
end

function t1.SlowMo(p5, p6) -- line: 69
    -- upvalues: t1 (copy), n1 (ref), n2 (ref), n3 (ref)
    n3 = p5

    local v6 = n1

    n2 = math.max(v6, os.clock()) + p6
    t1.Counts.SlowMo = (t1.Counts.SlowMo or 0) + 1
end

local n4 = 0
local n5 = 0
local n6 = 0.001

function t1.Shake(p7, p8) -- line: 76
    -- upvalues: n4 (ref), n5 (ref), n6 (ref)
    local elapsed = os.clock()

    n4 = p7
    n5 = elapsed
    n6 = p8
end

function t1.ShakeCF() -- line: 81
    -- upvalues: n4 (ref), n5 (ref), n6 (ref)
    local v7 = 1 - (os.clock() - n5) / n6

    if v7 <= 0 then
        return CFrame.identity
    end

    local v8 = n4 * v7 * (0.35 + 0.65 * v7)
    local v9 = os.clock() * 26

    local function n(p9) -- line: 88
        -- upvalues: v9 (copy)
        return (math.clamp(math.noise(v9, p9, 0.5) * 0.9, -0.5, 0.5))
    end

    return CFrame.new(math.clamp(math.noise(v9, 1.7, 0.5) * 0.9, -0.5, 0.5) * v8, math.clamp(math.noise(v9, 8.3, 0.5) * 0.9, -0.5, 0.5) * v8, 0) * CFrame.Angles(math.clamp(math.noise(v9, 4.1, 0.5) * 0.9, -0.5, 0.5) * v8 * 0.012, math.clamp(math.noise(v9, 6.6, 0.5) * 0.9, -0.5, 0.5) * v8 * 0.012, math.clamp(math.noise(v9, 2.9, 0.5) * 0.9, -0.5, 0.5) * v8 * 0.04)
end

local t2 = {}

function t1.Haptic(p10) -- line: 96
    -- upvalues: t1 (copy), t2 (copy)
    t1.Counts.Haptic = (t1.Counts.Haptic or 0) + 1

    local function v20() -- line: 98
        -- upvalues: p10 (copy), t2 (copy)
        local v21 = if p10 >= 3 then Enum.HapticEffectType.GameplayExplosion elseif p10 >= 2 then Enum.HapticEffectType.GameplayCollision else Enum.HapticEffectType.UIClick
        local v22 = t2[v21]

        if not v22 then
            v22 = Instance.new("HapticEffect")
            v22.Type = v21
            v22.Parent = workspace
            t2[v21] = v22
        end

        v22:Play()
    end

    pcall(v20)
end

local EqualizerSoundEffect

local function sfxEq() -- line: 113
    -- upvalues: SoundService (copy), EqualizerSoundEffect (ref)
    if EqualizerSoundEffect then
        return EqualizerSoundEffect
    end

    local Sfx = SoundService:FindFirstChild("Sfx")

    if Sfx then
        EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")
        EqualizerSoundEffect.Name = "Underwater"

        local EqualizerSoundEffect2 = EqualizerSoundEffect
        local EqualizerSoundEffect3 = EqualizerSoundEffect
        local EqualizerSoundEffect4 = EqualizerSoundEffect

        EqualizerSoundEffect2.HighGain = 0
        EqualizerSoundEffect3.MidGain = 0
        EqualizerSoundEffect4.LowGain = 0
        EqualizerSoundEffect.Parent = Sfx
    end

    return EqualizerSoundEffect
end

function t1.Muffle(p11, p12) -- line: 126
    -- upvalues: SoundService (copy), TweenService (copy), t1 (copy), EqualizerSoundEffect (ref)
    if not EqualizerSoundEffect then
        local Sfx = SoundService:FindFirstChild("Sfx")

        if Sfx then
            EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")
            EqualizerSoundEffect.Name = "Underwater"

            local EqualizerSoundEffect2 = EqualizerSoundEffect
            local EqualizerSoundEffect3 = EqualizerSoundEffect
            local EqualizerSoundEffect4 = EqualizerSoundEffect

            EqualizerSoundEffect2.HighGain = 0
            EqualizerSoundEffect3.MidGain = 0
            EqualizerSoundEffect4.LowGain = 0
            EqualizerSoundEffect.Parent = Sfx
        end
    end

    local EqualizerSoundEffect2 = EqualizerSoundEffect

    if EqualizerSoundEffect2 then
        TweenService:Create(EqualizerSoundEffect2, TweenInfo.new(p12 or 0.12), {
            HighGain = p11 and -26 or 0,
            MidGain = p11 and -9 or 0,
            LowGain = p11 and 3 or 0
        }):Play()
    end

    t1.Muffled = p11
end

function t1.Duck(p13) -- line: 133
    -- upvalues: UIKit (copy)
    UIKit.DuckUntil = math.max(UIKit.DuckUntil or 0, os.clock() + p13)
end

local t4 = {
    "Heartbeat",
    "DrumRoll",
    "TensionRiser",
    "NoiseBuild",
    "ReverseSwell",
    "WaterSurge"
}

function t1.Hold(p14, p15, p16) -- line: 139
    -- upvalues: UIKit (copy), SoundPlayer (copy), t1 (copy)
    local v26 = "Hold_" .. p14

    t1.Counts[v26] = (t1.Counts[v26] or 0) + 1

    if p16 then
        SoundPlayer.PlayEndingIn(p14, p16, p15)
    else
        UIKit.sound(p14, p15)
    end
end

function t1.Bend(p17, p18, p19) -- line: 147
    -- upvalues: SoundPlayer (copy)
    SoundPlayer.Bend(p17, p18, p19)
end

function t1.Release(p20, p21) -- line: 150
    -- upvalues: UIKit (copy)
    if UIKit.SoundStopHandler then
        UIKit.SoundStopHandler(p20, p21 or 0.15)
    end
end

function t1.ReleaseAll(p22) -- line: 155
    -- upvalues: t1 (copy), t4 (copy)
    for _, v27 in ipairs(t4) do
        t1.Release(v27, p22)
    end
end

function t1.Holding(p23) -- line: 160
    -- upvalues: SoundPlayer (copy)
    return SoundPlayer.IsPlaying(p23)
end

function t1.Sting(p24) -- line: 164
    -- upvalues: UIKit (copy), t1 (copy), sound (copy)
    local v28 = "Sting" .. p24

    t1.Counts[v28] = (t1.Counts[v28] or 0) + 1
    t1.Duck(p24 >= 3 and 3.5 or 1.6)

    if p24 == 1 then
        UIKit.sound("Twinkle", 1.1)
    elseif p24 == 2 then
        UIKit.sound("Twinkle", 1)
        task.delay(0.08, sound, "MeterPerfect", 1.26)
        task.delay(0.16, sound, "MeterPerfect", 1.5)
    elseif p24 == 3 then
        UIKit.sound("StingHit", nil)
        UIKit.sound("Twinkle", 0.9)
        UIKit.sound("DeepRumble", 1.1)
        UIKit.sound("SubBoom", 1.1)
        UIKit.sound("SonicBoom", 1.15)
        task.delay(0.35, sound, "WindChime", 1.15)
    elseif p24 >= 4 then
        UIKit.sound("StingHit", 0.9)
        UIKit.sound("StingChoir", nil)
        UIKit.sound("DeepRumble", 0.8)
        UIKit.sound("SubBoom", 0.9)
        UIKit.sound("Braam", nil)
        UIKit.sound("SonicBoom", nil)
        UIKit.sound("Thunder", 0.8)
        task.delay(0.25, sound, "WindChime")
        task.delay(0.9, sound, "Twinkle", 1.2)
    end
end

function t1.IntroBegin(p25, p26) -- line: 195
    -- upvalues: UIKit (copy), t1 (copy)
    local v29 = "Intro_" .. tostring(p25)

    t1.Counts[v29] = (t1.Counts[v29] or 0) + 1

    local Bend, v30

    if p26 >= 3 and p25 ~= "legend" then
        t1.Hold("Heartbeat", 0.85)
        Bend = t1.Bend
        v30 = if p26 >= 4 then 0.8 else 0.55
        Bend("Heartbeat", 0.85, v30)
        t1.Duck(8)
    end

    if p25 == "pov" then
        UIKit.sound("DeepRumble", 0.9)
    elseif p25 == "dive" then
        UIKit.sound("DeepWhoosh", 1)
    elseif p25 == "eyes" then
        UIKit.sound("DeepRumble", 0.65)
    elseif p25 == "chase" then
        UIKit.sound("DeepWhoosh", 1.5)
    elseif p25 == "bobber" then
        UIKit.sound("Twinkle", 0.7)
    elseif p25 == "sonar" then
        UIKit.sound("Twinkle", 0.55)
    elseif p25 == "drag" then
        UIKit.sound("ReelBurst", 1.2)
        UIKit.sound("DeepWhoosh", 1.3)
    elseif p25 == "whirl" then
        UIKit.sound("DeepRumble", 0.75)
        UIKit.sound("DeepWhoosh", 0.7)
    end
end

function t1.Strike(p27) -- line: 225
    -- upvalues: UIKit (copy), ScreenFx (copy), t1 (copy)
    t1.Counts.Strike = (t1.Counts.Strike or 0) + 1
    t1.Struck = true

    local Level = t1.Level
    local v31 = if p27 == "dive" then 0.8 elseif p27 == "bobber" then 1.15 else 1

    UIKit.sound("Splash", v31)

    local v32 = if p27 == "eyes" then 0.8
        elseif p27 == "chase" then 1.15
        elseif p27 == "bobber" then 1.25
        else 1

    UIKit.sound("BiteHit", v32)

    if Level >= 2 then
        UIKit.sound("DeepRumble", 1.3)
    end

    if Level >= 3 then
        t1.Release("Heartbeat", 0.08)

        local v33 = Level >= 4 and 0.85 or 1

        UIKit.sound("OmenHit", v33)

        local v34 = Level >= 4 and 0.8 or 1.05

        UIKit.sound("SubBoom", v34)
    end

    t1.HitStop(0.07 + 0.03 * Level)
    t1.Shake(0.5 + 0.35 * Level, 0.35 + 0.1 * Level)
    t1.Haptic(1 + Level)
    ScreenFx.Flash(0.12 + 0.03 * Level)

    if not (Level >= 3) then
        return
    end

    t1.SlowMo(Level >= 4 and 0.3 or 0.5, 0.5)
    UIKit.sound("ReelBurst", 1.5)
    task.delay(0.12, t1.Haptic, 3)
end

local ColorCorrectionEffect

local function gradeFx() -- line: 252
    -- upvalues: Lighting (copy), ColorCorrectionEffect (ref)
    if ColorCorrectionEffect then
        return ColorCorrectionEffect
    end

    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "CutsceneGrade"
    ColorCorrectionEffect.Parent = Lighting

    return ColorCorrectionEffect
end

function t1.Grade(p28, p29, p30) -- line: 261
    -- upvalues: Lighting (copy), TweenService (copy), t1 (copy), v2 (copy), ColorCorrectionEffect (ref)
    if not ColorCorrectionEffect then
        ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
        ColorCorrectionEffect.Name = "CutsceneGrade"
        ColorCorrectionEffect.Parent = Lighting
    end

    local ColorCorrectionEffect2 = ColorCorrectionEffect

    ColorCorrectionEffect2.Enabled = true

    local v35 = math.clamp(p29, 0, 1)
    local v36, v37 = p28:ToHSV()
    local v38 = Color3.fromHSV(v36, v37 * 0.5, 1)

    TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(p30 or 0.3), {
        TintColor = v2:Lerp(v38, v35 * 0.55),
        Saturation = v35 * 0.25,
        Contrast = v35 * 0.12
    }):Play()
    t1.Graded = v35
end

function t1.Drain(p31) -- line: 272
    -- upvalues: Lighting (copy), TweenService (copy), t1 (copy), fromRGB (copy), ColorCorrectionEffect (ref)
    if not ColorCorrectionEffect then
        ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
        ColorCorrectionEffect.Name = "CutsceneGrade"
        ColorCorrectionEffect.Parent = Lighting
    end

    local ColorCorrectionEffect2 = ColorCorrectionEffect

    ColorCorrectionEffect2.Enabled = true
    TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(p31), {
        Saturation = -1,
        Contrast = 0.2,
        TintColor = fromRGB(225, 215, 240)
    }):Play()
    t1.Counts.Drain = (t1.Counts.Drain or 0) + 1
end

function t1.GradeOff(p32) -- line: 278
    -- upvalues: TweenService (copy), t1 (copy), v2 (copy), ColorCorrectionEffect (ref)
    if ColorCorrectionEffect then
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(p32 or 0.3), {
            Saturation = 0,
            Contrast = 0,
            TintColor = v2
        }):Play()
        t1.Graded = 0
    end
end

local ScreenGui, t5, TextLabel, Frame
local t6 = {}
local t7
local t8 = {
    coin = function(p33, _) -- coin | line: 294
        -- upvalues: v1 (copy)
        local v39 = v1:NextNumber(0.05, 0.95)
        local v40 = v1:NextNumber(-0.25, -0.02)
        local v41 = v1:NextNumber(-0.05, 0.05)
        local v42 = v1:NextNumber(0.1, 0.4)

        p33.x = v39
        p33.y = v40
        p33.vx = v41
        p33.vy = v42
        p33.ay = 0.9

        local v43 = v1:NextNumber(0.03, 0.05)
        local v44 = v1:NextNumber(-200, 200)
        local v45 = v1:NextNumber(8, 14)

        p33.size = v43
        p33.life = 2.2
        p33.vr = v44
        p33.round = true
        p33.flip = v45
    end,
    spark = function(p35, _) -- spark | line: 298
        -- upvalues: v1 (copy)
        local v46 = v1:NextNumber(0, 6.283185307179586)
        local v47 = v1:NextNumber(0.25, 0.9)
        local v48 = math.cos(v46) * v47 * 0.6
        local v49 = math.sin(v46) * v47

        p35.x = 0.5
        p35.y = 0.45
        p35.vx = v48
        p35.vy = v49
        p35.ay = 0.3

        local v50 = v1:NextNumber(0.008, 0.02)
        local v51 = v1:NextNumber(0.5, 1.1)
        local v52 = v1:NextNumber(-360, 360)

        p35.size = v50
        p35.life = v51
        p35.vr = v52
    end,
    shard = function(p37, _) -- shard | line: 303
        -- upvalues: v1 (copy)
        local v53 = v1:NextNumber(0, 6.283185307179586)
        local v54 = v1:NextNumber(0.3, 1)
        local v55 = math.cos(v53) * v54 * 0.6
        local v56 = math.sin(v53) * v54

        p37.x = 0.5
        p37.y = 0.45
        p37.vx = v55
        p37.vy = v56
        p37.ay = 0.9

        local v57 = v1:NextNumber(0.018, 0.04)
        local v58 = v1:NextNumber(0.7, 1.3)
        local v59 = v1:NextNumber(-500, 500)

        p37.size = v57
        p37.life = v58
        p37.vr = v59
    end,
    snow = function(p39) -- snow | line: 308
        -- upvalues: v1 (copy)
        local v60 = v1:NextNumber(0, 1)
        local v61 = v1:NextNumber(-0.04, 0.04)
        local v62 = v1:NextNumber(0.12, 0.3)

        p39.x = v60
        p39.y = -0.03
        p39.vx = v61
        p39.vy = v62
        p39.size = v1:NextNumber(0.006, 0.014)
        p39.life = 4
        p39.round = true
    end,
    ash = function(p40) -- ash | line: 312
        -- upvalues: v1 (copy)
        local v63 = v1:NextNumber(0, 1)
        local v64 = v1:NextNumber(-0.03, 0.03)
        local v65 = v1:NextNumber(0.05, 0.14)

        p40.x = v63
        p40.y = -0.03
        p40.vx = v64
        p40.vy = v65

        local v66 = v1:NextNumber(0.006, 0.012)
        local v67 = v1:NextNumber(-60, 60)

        p40.size = v66
        p40.life = 6
        p40.vr = v67
    end,
    ember = function(p41) -- ember | line: 316
        -- upvalues: v1 (copy)
        local v68 = v1:NextNumber(0, 1)
        local v69 = v1:NextNumber(-0.05, 0.05)
        local v70 = v1:NextNumber(-0.4, -0.15)

        p41.x = v68
        p41.y = 1.03
        p41.vx = v69
        p41.vy = v70

        local v71 = v1:NextNumber(0.006, 0.014)
        local v72 = v1:NextNumber(-120, 120)

        p41.size = v71
        p41.life = 3
        p41.vr = v72
    end,
    bubble = function(p42) -- bubble | line: 320
        -- upvalues: v1 (copy)
        local v73 = v1:NextNumber(0, 1)
        local v74 = v1:NextNumber(-0.02, 0.02)
        local v75 = v1:NextNumber(-0.3, -0.12)

        p42.x = v73
        p42.y = 1.03
        p42.vx = v74
        p42.vy = v75
        p42.size = v1:NextNumber(0.01, 0.03)
        p42.life = 4
        p42.round = true
        p42.a0 = 0.6
    end,
    leaf = function(p43) -- leaf | line: 324
        -- upvalues: v1 (copy)
        local v76 = v1:NextNumber(0, 1)
        local v77 = v1:NextNumber(-0.1, 0.1)
        local v78 = v1:NextNumber(0.1, 0.22)

        p43.x = v76
        p43.y = -0.03
        p43.vx = v77
        p43.vy = v78

        local v79 = v1:NextNumber(0.012, 0.022)
        local v80 = v1:NextNumber(-160, 160)

        p43.size = v79
        p43.life = 5
        p43.vr = v80
    end,
    rain = function(p44) -- rain | line: 328
        -- upvalues: v1 (copy)
        local v81 = v1:NextNumber(0, 1.2)
        local v82 = v1:NextNumber(1.6, 2.2)

        p44.x = v81
        p44.y = -0.05
        p44.vx = -0.25
        p44.vy = v82
        p44.size = 0.004
        p44.life = 0.8
        p44.rot = 8
        p44.tall = 14
        p44.a0 = 0.5
    end,
    pixel = function(p45) -- pixel | line: 332
        -- upvalues: v1 (copy)
        local v83 = v1:NextNumber(0, 1)
        local v84 = v1:NextNumber(0, 1)

        p45.x = v83
        p45.y = v84
        p45.vx = 0
        p45.vy = 0

        local v85 = v1:NextNumber(0.01, 0.03)
        local v86 = v1:NextNumber(0.08, 0.3)
        local v87 = v1:NextNumber(1, 6)

        p45.size = v85
        p45.life = v86
        p45.wide = v87
    end,
    star = function(p46) -- star | line: 336
        -- upvalues: v1 (copy)
        local v88 = v1:NextNumber(0, 1)
        local v89 = v1:NextNumber(0, 0.9)

        p46.x = v88
        p46.y = v89
        p46.vx = 0
        p46.vy = -0.01

        local v90 = v1:NextNumber(0.006, 0.016)
        local v91 = v1:NextNumber(0.6, 1.4)

        p46.size = v90
        p46.life = v91
        p46.rot = 45
    end,
    glow = function(p47) -- glow | line: 340
        -- upvalues: v1 (copy)
        local v92 = v1:NextNumber(0, 1)
        local v93 = v1:NextNumber(-0.02, 0.02)
        local v94 = v1:NextNumber(-0.2, -0.08)

        p47.x = v92
        p47.y = 1.03
        p47.vx = v93
        p47.vy = v94
        p47.size = v1:NextNumber(0.008, 0.02)
        p47.life = 5
        p47.round = true
    end
}
local t9 = {
    shallows = {
        fromRGB(120, 220, 255),
        "bubble",
        fromRGB(220, 245, 255)
    },
    coral_reef = {
        fromRGB(255, 150, 200),
        "bubble",
        fromRGB(255, 210, 230)
    },
    deep_sea = {
        fromRGB(20, 50, 120),
        "bubble",
        fromRGB(120, 170, 230)
    },
    kelp_forest = {
        fromRGB(60, 150, 70),
        "leaf",
        fromRGB(120, 210, 90)
    },
    mangrove_swamp = {
        fromRGB(90, 110, 50),
        "glow",
        fromRGB(225, 255, 120)
    },
    frozen_fjord = {
        fromRGB(215, 240, 255),
        "snow",
        fromRGB(255, 255, 255)
    },
    sunken_ruins = {
        fromRGB(220, 190, 110),
        "glow",
        fromRGB(255, 232, 170)
    },
    volcanic_vents = {
        fromRGB(255, 90, 20),
        "ember",
        fromRGB(255, 150, 50)
    },
    crystal_caverns = {
        fromRGB(190, 120, 255),
        "star",
        fromRGB(235, 190, 255)
    },
    shipwreck_graveyard = {
        fromRGB(110, 120, 130),
        "ash",
        fromRGB(190, 198, 204)
    },
    abyssal_trench = {
        fromRGB(8, 12, 40),
        "glow",
        fromRGB(90, 170, 255)
    },
    storm_sea = {
        fromRGB(80, 90, 120),
        "rain",
        fromRGB(200, 220, 245)
    },
    celestial_ocean = {
        fromRGB(70, 50, 160),
        "star",
        fromRGB(255, 245, 200)
    },
    toxic_lagoon = {
        fromRGB(120, 200, 40),
        "bubble",
        fromRGB(190, 255, 90)
    },
    clockwork_depths = {
        fromRGB(190, 140, 60),
        "ember",
        fromRGB(255, 205, 110)
    },
    neon_reef = {
        fromRGB(255, 60, 220),
        "pixel",
        fromRGB(60, 240, 255)
    },
    primeval_sea = {
        fromRGB(120, 160, 70),
        "leaf",
        fromRGB(200, 220, 120)
    },
    nightmare_sea = {
        fromRGB(120, 0, 20),
        "ember",
        fromRGB(255, 50, 70)
    },
    glitch_rift = {
        fromRGB(0, 255, 240),
        "pixel",
        fromRGB(255, 0, 200)
    },
    divine_throne = {
        fromRGB(255, 225, 130),
        "glow",
        fromRGB(255, 240, 180)
    },
    candy_cove = {
        fromRGB(255, 170, 210),
        "bubble",
        fromRGB(200, 245, 230)
    }
}

t1.Zones = t9

local function buildGui() -- line: 371
    -- upvalues: new (copy), LocalPlayer (copy), v2 (copy), ScreenGui (ref), t5 (ref), TextLabel (ref), Frame (ref), t6 (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CutsceneFx"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.DisplayOrder = 40

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
    t5 = {}

    local t10 = {
        {
            UDim2.new(1, 0, 0.22, 0),
            UDim2.fromScale(0, 0),
            90,
            false
        },
        {
            UDim2.new(1, 0, 0.22, 0),
            UDim2.fromScale(0, 0.78),
            90,
            true
        },
        {
            UDim2.new(0.16, 0, 1, 0),
            UDim2.fromScale(0, 0),
            0,
            false
        },
        {
            UDim2.new(0.16, 0, 1, 0),
            UDim2.fromScale(0.84, 0),
            0,
            true
        }
    }

    for v96, v97 in ipairs(t10) do
        local Frame = Instance.new("Frame")

        Frame.Name = "Edge" .. v96
        Frame.BorderSizePixel = 0

        local v98 = v97[1]
        local v99 = v97[2]

        Frame.Size = v98
        Frame.Position = v99
        Frame.BackgroundTransparency = 1
        Frame.Parent = ScreenGui

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = v97[3]

        if v97[4] then
            UIGradient.Transparency = NumberSequence.new(1, 0)
        else
            UIGradient.Transparency = NumberSequence.new(0, 1)
        end

        UIGradient.Parent = Frame

        local t11 = t5

        t11[v96] = Frame
    end

    for i = 1, 70 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Bit"
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = new(0.5, 0.5)
        Frame.Visible = false
        Frame.ZIndex = 2
        Frame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 0)
        UICorner.Parent = Frame
        t6[i] = {
            alive = false,
            frame = Frame,
            corner = UICorner
        }
    end

    Frame = Instance.new("Frame")
    Frame.Name = "Wave"
    Frame.BorderSizePixel = 0

    local Frame2 = Frame

    Frame2.Size = UDim2.fromScale(0.7, 1)
    Frame.BackgroundColor3 = v2
    Frame.Visible = false
    Frame.ZIndex = 3
    Frame.Parent = ScreenGui

    local UIGradient = Instance.new("UIGradient")
    local t12 = {}

    for i = 0, 6 do
        t12[i + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 * 0.85, 0.85, 1))
    end

    UIGradient.Color = ColorSequence.new(t12)
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame
    TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "HoldHint"
    TextLabel.BackgroundTransparency = 1

    local TextLabel2 = TextLabel

    TextLabel2.AnchorPoint = new(0.5, 1)

    local TextLabel3 = TextLabel

    TextLabel3.Position = UDim2.new(0.5, 0, 1, -18)

    local TextLabel4 = TextLabel

    TextLabel4.Size = UDim2.fromOffset(420, 26)

    local TextLabel5 = TextLabel

    TextLabel5.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 18
    TextLabel.TextColor3 = v2
    TextLabel.TextTransparency = 0.35
    TextLabel.TextStrokeTransparency = 0.6
    TextLabel.Text = "HOLD TO SPEED UP"
    TextLabel.Visible = false
    TextLabel.ZIndex = 5
    TextLabel.Parent = ScreenGui
end

local function spawn(p48, p49) -- line: 446
    -- upvalues: v1 (copy), t6 (copy), t8 (copy)
    for _, v100 in ipairs(t6) do
        if not v100.alive then
            v100.alive = true
            v100.age = 0

            local v101 = v1:NextNumber(0, 360)

            v100.ax = 0
            v100.ay = 0
            v100.rot = v101
            v100.vr = 0
            v100.round = false
            v100.flip = nil
            v100.tall = 1
            v100.wide = 1
            v100.a0 = 0.9
            t8[p48](v100, p49)
            v100.frame.BackgroundColor3 = p49
            v100.corner.CornerRadius = UDim.new(v100.round and 0.5 or 0, 0)
            v100.frame.Visible = true

            return v100
        end
    end

    return nil
end

function t1.Burst(p50, p51, p52, p53) -- line: 460
    -- upvalues: t1 (copy), spawn (copy)
    local v102 = "Burst_" .. p50

    t1.Counts[v102] = (t1.Counts[v102] or 0) + 1

    for i = 1, p52 do
        spawn(p50, if not p53 or i % 2 ~= 0 then p51 else p53)
    end
end

local function step(p54) -- line: 466
    -- upvalues: v3 (ref), TextLabel (ref), t6 (copy), t7 (ref), spawn (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize

    if t7 then
        t7.acc += p54 * t7.rate

        while t7.acc >= 1 do
            t7.acc -= 1
            spawn(t7.kind, t7.color)
        end
    end

    for _, v104 in ipairs(t6) do
        if v104.alive then
            v104.age += p54

            if v104.age >= v104.life or v104.y > 1.2 or v104.y < -0.3 then
                v104.alive = false
                v104.frame.Visible = false
            else
                v104.vx += v104.ax * p54
                v104.vy += v104.ay * p54
                v104.x += v104.vx * p54
                v104.y += v104.vy * p54
                v104.rot += v104.vr * p54

                local v105 = v104.size * ViewportSize.Y
                local v106 = if v104.flip then math.abs((math.cos(v104.age * v104.flip))) * 0.9 + 0.1 else 1
                local frame = v104.frame

                frame.Position = UDim2.fromOffset(v104.x * ViewportSize.X, v104.y * ViewportSize.Y)
                frame.Size = UDim2.fromOffset(v105 * v106 * v104.wide, v105 * v104.tall)
                frame.Rotation = v104.rot

                local v109 = v104.age / v104.life

                frame.BackgroundTransparency = 1 - v104.a0 * math.min(1, v109 * 8) * math.min(1, (1 - v109) * 3)
            end
        end
    end

    if TextLabel.Visible then
        TextLabel.Text = v3 and ">>  SPEEDING UP  >>" or "HOLD TO SPEED UP"
        TextLabel.TextTransparency = v3 and 0.05 or 0.4
    end
end

function t1.ZoneStart(p55, p56) -- line: 505
    -- upvalues: TweenService (copy), t1 (copy), fromRGB (copy), t5 (ref), t7 (ref), t9 (copy)
    local v113 = t9[p55 or ""]

    if not v113 then
        return
    end

    local v114 = "Zone_" .. p55

    t1.Counts[v114] = (t1.Counts[v114] or 0) + 1
    t1.Zone = p55

    for _, v115 in ipairs(t5) do
        v115.BackgroundColor3 = v113[1]:Lerp(fromRGB(4, 10, 30), 0.42)
        v115.BackgroundTransparency = 1
        TweenService:Create(v115, TweenInfo.new(0.6), {
            BackgroundTransparency = 0.7 - p56 * 0.06
        }):Play()
    end

    t7 = {
        acc = 0,
        kind = v113[2],
        color = v113[3],
        rate = if v113[2] == "rain" or v113[2] == "pixel" then 26 else p56 * 2 + 9
    }
end

function t1.ZoneStop() -- line: 520
    -- upvalues: TweenService (copy), t1 (copy), t5 (ref), t7 (ref)
    t7 = nil
    t1.Zone = nil

    if t5 then
        for _, v116 in ipairs(t5) do
            TweenService:Create(v116, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
end

function t1.Mutation(p57) -- line: 531
    -- upvalues: TweenService (copy), UIKit (copy), ScreenFx (copy), t1 (copy), fromRGB (copy), v2 (copy), Frame (ref)
    if p57 == "Normal" or not p57 then
        return
    end

    local v117 = "Mutation_" .. p57

    t1.Counts[v117] = (t1.Counts[v117] or 0) + 1

    if p57 == "Gold" then
        t1.Burst("coin", fromRGB(255, 215, 60), 26, fromRGB(255, 240, 150))
        UIKit.sound("Coins", nil)
    elseif p57 == "Diamond" then
        ScreenFx.Flash(0.35, fromRGB(220, 250, 255))
        t1.Burst("spark", fromRGB(220, 250, 255), 30, v2)
        t1.Burst("star", v2, 12)
        UIKit.sound("Twinkle", 1.3)
    elseif p57 == "Ruby" then
        t1.Burst("shard", fromRGB(255, 60, 90), 22, fromRGB(255, 170, 180))
        UIKit.sound("Twinkle", 0.85)
    elseif p57 == "Emerald" then
        t1.Burst("shard", fromRGB(40, 220, 110), 22, fromRGB(170, 255, 190))
        UIKit.sound("Twinkle", 0.95)
    elseif p57 == "Rainbow" then
        Frame.Visible = true
        Frame.Position = UDim2.fromScale(-0.75, 0)

        local tween = TweenService:Create(Frame, TweenInfo.new(1.1, Enum.EasingStyle.Sine), {
            Position = UDim2.fromScale(1.05, 0)
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 555
            -- upvalues: Frame (ref)
            Frame.Visible = false
        end)

        for i = 0, 5 do
            t1.Burst("spark", Color3.fromHSV(i / 6, 0.8, 1), 6)
        end

        UIKit.sound("WindChime", 1.1)
    elseif p57 == "Void" then
        ScreenFx.Flash(0.3, fromRGB(40, 0, 70))
        t1.Burst("shard", fromRGB(150, 60, 230), 26, fromRGB(20, 6, 40))
        UIKit.sound("DeepRumble", 0.6)
    end
end

function t1.Crack() -- line: 570
    -- upvalues: TweenService (copy), Debris (copy), UIKit (copy), ScreenFx (copy), t1 (copy), new (copy), v1 (copy), v2 (copy), ScreenGui (ref)
    t1.Counts.Crack = (t1.Counts.Crack or 0) + 1
    UIKit.sound("GlassBoom", nil)
    t1.Haptic(3)
    t1.Shake(1.6, 0.5)
    ScreenFx.Flash(0.22)

    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v118 = ViewportSize.X * 0.5
    local v119 = ViewportSize.Y * 0.47

    for i = 1, 11 do
        local v120 = i / 11 * 3.141592653589793 * 2 + v1:NextNumber(-0.2, 0.2)
        local v121 = v1:NextNumber(0.35, 0.8) * ViewportSize.Y
        local v122 = v118
        local v123 = v119

        for j = 1, 3 do
            local v124 = v121 / 3
            local v125 = v120 + v1:NextNumber(-0.35, 0.35)
            local Frame = Instance.new("Frame")

            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.AnchorPoint = new(0, 0.5)
            Frame.Position = UDim2.fromOffset(v122, v123)
            Frame.Size = UDim2.fromOffset(v124, (math.max(2, 5 - j)))
            Frame.Rotation = math.deg(v125)
            Frame.ZIndex = 6
            Frame.Parent = ScreenGui
            v122 += math.cos(v125) * v124
            v123 += math.sin(v125) * v124
            TweenService:Create(Frame, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            Debris:AddItem(Frame, 0.6)
        end
    end
end

function t1.FakeOutRoll() -- line: 601
    -- upvalues: t1 (copy)
    if t1.ForceFakeOut == nil then
        return math.random() < 0.5
    end

    return t1.ForceFakeOut
end

function t1.Shade(p58, p59) -- line: 612
    -- upvalues: t1 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "Shade"
    Highlight.FillColor = p59
    Highlight.FillTransparency = 0
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p58
    Highlight.Parent = p58
    t1.Counts.Shade = (t1.Counts.Shade or 0) + 1

    return Highlight
end

local Folder
local self = setmetatable({}, {
    __mode = "k"
})

function t1.EyeLight(p60, p61) -- line: 630
    -- upvalues: Folder (ref), self (copy)
    if not (Folder and Folder.Parent) then
        Folder = Instance.new("Folder")
        Folder.Name = "CutsceneEyes"
        Folder.Parent = workspace
    end

    local v127 = p60

    while v127.Parent and v127.Parent ~= workspace and v127.Parent:IsA("Model") do
        v127 = v127.Parent
    end

    local v128 = self[v127]
    local v129 = v128 == nil or v128.Parent == nil

    if v129 then
        v128 = Instance.new("Model")
        v128.Name = "EyeLight"
        self[v127] = v128
    end

    local Archivable = p60.Archivable

    p60.Archivable = true

    local clone = p60:Clone()

    p60.Archivable = Archivable
    clone:ClearAllChildren()
    clone.Name = "Glow"
    clone.Size = p60.Size * 1.05
    clone.CFrame = p60.CFrame
    clone.Transparency = 0
    clone.Anchored = false
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.CastShadow = false
    clone.Massless = true
    clone:SetAttribute("Eye", nil)
    clone:SetAttribute("NoStuds", true)

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = p60
    WeldConstraint.Part1 = clone
    WeldConstraint.Parent = clone
    clone.Parent = v128

    if v129 then
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "Lit"
        Highlight.FillColor = p61
        Highlight.FillTransparency = 0
        Highlight.OutlineColor = p61
        Highlight.OutlineTransparency = 0.4
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.Adornee = v128
        Highlight.Parent = v128
        v128.Parent = Folder
    end

    p60.AncestryChanged:Connect(function() -- line: 683
        -- upvalues: p60 (copy), v128 (ref)
        if not p60:IsDescendantOf(workspace) then
            v128:Destroy()
        end
    end)

    return clone
end

function t1.EyeColor(p62, p63) -- line: 690
    local v130 = p62.Parent and p62.Parent:FindFirstChild("Lit")

    if v130 then
        v130.FillColor = p63
        v130.OutlineColor = p63
    end
end

function t1.EyeShow(p64, p65) -- line: 697
    p64.Transparency = p65 and 0 or 1

    local v131 = p64.Parent and p64.Parent:FindFirstChild("Lit")

    if v131 then
        v131.Enabled = p65
    end
end

function t1.Silhouette(p66) -- line: 706
    -- upvalues: UIKit (copy), ScreenFx (copy), t1 (copy), fromRGB (copy)
    t1.Counts.Silhouette = (t1.Counts.Silhouette or 0) + 1

    local t18 = {}
    local v132 = t1.Shade(p66, fromRGB(4, 6, 12))
    local t19 = {}

    for _, descendant in ipairs(p66:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            if descendant:GetAttribute("Eye") then
                table.insert(t19, t1.EyeLight(descendant, fromRGB(255, 250, 220)))
            end
        elseif descendant:IsA("Texture") or descendant:IsA("Decal") then
            t18[descendant] = {
                descendant.Transparency
            }
            descendant.Transparency = 1
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Light") then
            t18[descendant] = {
                descendant.Enabled
            }
            descendant.Enabled = false
        end
    end

    return function() -- line: 724
        -- upvalues: t18 (copy), v132 (copy), t19 (copy), UIKit (copy), ScreenFx (copy), t1 (copy)
        v132:Destroy()

        for _, v133 in ipairs(t19) do
            if v133.Parent then
                v133.Parent:Destroy()
            end
        end

        for v134, v135 in pairs(t18) do
            if v134.Parent then
                if v134:IsA("Texture") or v134:IsA("Decal") then
                    v134.Transparency = v135[1]
                else
                    v134.Enabled = v135[1]
                end
            end
        end

        ScreenFx.Flash(0.18)
        UIKit.sound("Twinkle", 1.4)
        t1.Counts.LightsOn = (t1.Counts.LightsOn or 0) + 1
    end
end

function t1.Buddy(p67, p68) -- line: 746
    -- upvalues: Shared (copy), t1 (copy), fromRGB (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    local function v136() -- line: 751
        -- upvalues: Character (copy)
        Character.Archivable = true

        local clone = Character:Clone()

        Character.Archivable = false

        return clone
    end

    local ok, result = pcall(v136)

    if not ok or not result then
        return nil
    end

    t1.Counts.Buddy = (t1.Counts.Buddy or 0) + 1
    result.Name = "ScaleBuddy"

    for _, descendant in ipairs(result:GetDescendants()) do
        if descendant:IsA("BaseScript") or descendant:IsA("Sound") or descendant:IsA("BillboardGui") or descendant:IsA("ForceField") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    local Humanoid = result:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    result:PivotTo(p67)

    if p68 then
        local Part = Instance.new("Part")

        Part.Name = "Raft"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.Size = Vector3.new(7, 1, 9)
        Part.Color = fromRGB(150, 100, 55)
        Part.CFrame = p67 * CFrame.new(0, -3.4, 0)
        require(Shared.Style).studPart(Part, 1)
        Part.Parent = result
    end

    result.Parent = workspace

    return result
end

function t1.Beam(p69, p70, p71) -- line: 793
    -- upvalues: TweenService (copy), Debris (copy), UIKit (copy), t1 (copy)
    t1.Counts.Beam = (t1.Counts.Beam or 0) + 1

    local Part = Instance.new("Part")

    Part.Name = "CatchBeam"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Shape = Enum.PartType.Cylinder
    Part.Color = p70
    Part.Transparency = 1
    Part.Size = Vector3.new(500, 1, 1)
    Part.CFrame = CFrame.new(p69 + Vector3.new(0, 250, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part:SetAttribute("NoStuds", true)
    Part.Parent = workspace

    local v137 = p71 * 2 + 4

    TweenService:Create(Part, TweenInfo.new(0.25), {
        Transparency = 0.25,
        Size = Vector3.new(500, v137, v137)
    }):Play()
    task.delay(p71 * 0.3 + 1.6, function() -- line: 812
        -- upvalues: Part (copy), TweenService (copy), Debris (copy)
        TweenService:Create(Part, TweenInfo.new(0.9), {
            Transparency = 1,
            Size = Vector3.new(500, 0.5, 0.5)
        }):Play()
        Debris:AddItem(Part, 1)
    end)

    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Shape = Enum.PartType.Cylinder
    Part2.Color = p70
    Part2.Transparency = 0.3
    Part2.Size = Vector3.new(0.3, 4, 4)
    Part2.CFrame = CFrame.new(p69 + Vector3.new(0, 0.3, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2:SetAttribute("NoStuds", true)
    Part2.Parent = workspace
    TweenService:Create(Part2, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.3, 46, 46),
        Transparency = 1
    }):Play()
    Debris:AddItem(Part2, 1)

    if (workspace.CurrentCamera.CFrame.Position - p69).Magnitude < 260 then
        UIKit.sound("Twinkle", 0.8)
        UIKit.sound("MeterPerfect", 1.26)
    end
end

function t1.Thrill(p72, p73, p74) -- line: 839
    -- upvalues: Roll (copy)
    return Roll.thrill(p72, p73 or 1, p74 or 1)
end

function t1.Begin(p75, p76) -- line: 842
    -- upvalues: t1 (copy), n1 (ref), n2 (ref), TextLabel (ref)
    t1.Level = p75
    t1.Struck = false
    t1.AllowHold = false
    TextLabel.Visible = false
    n1 = 0
    n2 = 0

    if not p76 then
        t1.Muffle(true, 0.3)
    end
end

function t1.HoldOff() -- line: 852
    -- upvalues: t1 (copy), TextLabel (ref)
    t1.AllowHold = false

    if TextLabel then
        TextLabel.Visible = false
    end
end

function t1.End() -- line: 858
    -- upvalues: t1 (copy), n1 (ref), n2 (ref), TextLabel (ref), Folder (ref)
    t1.AllowHold = false

    if TextLabel then
        TextLabel.Visible = false
    end

    n1 = 0
    n2 = 0
    t1.Muffle(false, 0.2)
    t1.GradeOff(0.4)
    t1.ZoneStop()
    t1.ReleaseAll(0.3)

    if Folder then
        Folder:ClearAllChildren()
    end
end

function t1.Init() -- line: 873
    -- upvalues: Players (copy), RunService (copy), UserInputService (copy), ReplicatedStorage (copy), Fish (copy), Rarities (copy), Variants (copy), t1 (copy), LocalPlayer (copy), v3 (ref), buildGui (copy), step (copy)
    buildGui()
    RunService.RenderStepped:Connect(function(p77) -- line: 875
        -- upvalues: step (copy)
        local ok, result = pcall(step, p77)

        if not ok then
            warn("[CutsceneFx] " .. tostring(result))
        end
    end)

    local function isHold(p78) -- line: 881
        local UserInputType = p78.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p78.KeyCode == Enum.KeyCode.Space then
            return true
        end

        return p78.KeyCode == Enum.KeyCode.ButtonA
    end

    UserInputService.InputBegan:Connect(function(p79) -- line: 885
        -- upvalues: v3 (ref)
        local UserInputType = p79.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p79.KeyCode == Enum.KeyCode.Space or p79.KeyCode == Enum.KeyCode.ButtonA then
            v3 = true
        end
    end)
    UserInputService.InputEnded:Connect(function(p80) -- line: 890
        -- upvalues: v3 (ref)
        local UserInputType = p80.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p80.KeyCode == Enum.KeyCode.Space or p80.KeyCode == Enum.KeyCode.ButtonA then
            v3 = false
        end
    end)

    local v138 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CatchBeam", 10)

    if v138 then
        v138.OnClientEvent:Connect(function(p81, p82, p83, p84) -- line: 898
            -- upvalues: Players (copy), Fish (copy), Rarities (copy), Variants (copy), t1 (copy), LocalPlayer (copy)
            t1.LastBeam = p81

            if p81 == LocalPlayer.UserId then
                return
            end

            local PlayerByUserId = Players:GetPlayerByUserId(p81)

            PlayerByUserId = PlayerByUserId and PlayerByUserId.Character and PlayerByUserId.Character:FindFirstChild("HumanoidRootPart")

            local v139 = Fish.ById[p82]

            if not (PlayerByUserId and v139) then
                return
            end

            local v140 = Variants.List[p83 or 1]
            local v141 = Rarities.ById[v139.rarity]

            t1.Beam(PlayerByUserId.Position - Vector3.new(0, 2.5, 0), if v140 and v140.index >= 2 then v140.Color else v141.Color, p84 or 3)
        end)
    end
end

function t1.SetHeld(p85) -- line: 914
    -- upvalues: v3 (ref)
    v3 = p85
end

return t1

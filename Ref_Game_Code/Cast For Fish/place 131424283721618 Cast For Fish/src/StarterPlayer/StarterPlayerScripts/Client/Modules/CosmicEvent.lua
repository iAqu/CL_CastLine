-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local CosmicEvent = require(Shared.Data.CosmicEvent)
local FishModels = require(Shared.FishModels)
local EggModels = require(Shared.EggModels)
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local ScreenFx = require(script.Parent.ScreenFx)
local SoundPlayer = require(script.Parent.SoundPlayer)
local SkipButton = require(script.Parent.SkipButton)
local MoveLock = require(script.Parent.MoveLock)
local ZoneAmbience = require(script.Parent.ZoneAmbience)
local Toasts = require(script.Parent.Toasts)
local EventFx = require(script.Parent.EventFx)
local BuffHud = require(script.Parent.BuffHud)
local CosmicBattle = require(script.Parent.CosmicBattle)
local CosmicSky = require(script.Parent.CosmicSky)
local Buffs = require(Shared.Data.Buffs)
local BATTLE = CosmicEvent.BATTLE
local LocalPlayer = Players.LocalPlayer
local CurrentCamera, fromRGB, new = workspace.CurrentCamera, Color3.fromRGB, Vector3.new
local v1 = fromRGB(255, 255, 255)
local Neon = Enum.Material.Neon
local new2, new3 = NumberSequence.new, NumberSequenceKeypoint.new
local v2 = Font.fromEnum(Enum.Font.LuckiestGuy)
local t1 = {
    Phase = "off",
    Level = CosmicEvent.WATER_FROM,
    Act = "off",
    Got = {
        lucky = 0,
        potion = 0,
        egg = 0
    },
    Max = {
        lucky = CosmicEvent.DropsByKind.lucky.cap,
        potion = CosmicEvent.DropsByKind.potion.cap,
        egg = CosmicEvent.DropsByKind.egg.cap
    },
    EggsOut = 0,
    KhaosScale = 1,
    IntroCamera = false,
    IntroPlayed = 0,
    Under = false,
    Space = false,
    KhaosShown = false,
    Cards = {}
}
local CosmicEvent2
local t2 = nil
local t3, ColorCorrectionEffect, v3, v4, v5, v6, v7, v8, v9

local function now() -- line: 73
    return workspace:GetServerTimeNow()
end

local function clamp01(p1) -- line: 76
    return (math.clamp(p1, 0, 1))
end

local function smooth(p2) -- line: 79
    local v10 = math.clamp(p2, 0, 1)

    return v10 * v10 * (3 - v10 * 2)
end

local function smoother(p3) -- line: 83
    local v11 = math.clamp(p3, 0, 1)

    return v11 * v11 * v11 * (v11 * (v11 * 6 - 15) + 10)
end

local function backOut(p4) -- line: 87
    local v12 = math.clamp(p4, 0, 1)

    return (v12 - 1) ^ 3 * 2.7 + 1 + (v12 - 1) ^ 2 * 1.7
end

local function sound(p5, p6) -- line: 92
    -- upvalues: UIKit (copy)
    UIKit.sound(p5, p6)
end

local function jit(p7) -- line: 96
    return (math.clamp(math.noise(os.clock() * 22, p7 * 7.31, 0.5) * 0.9, -0.5, 0.5))
end

local function part(p8) -- line: 100
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part:SetAttribute("NoStuds", true)

    for v14, v15 in pairs(p8) do
        Part[v14] = v15
    end

    return Part
end

local function hermite(p9, p10, p11, p12, p13) -- line: 117
    local v16 = p13 * p13
    local v17 = p13 * p13 * p13

    return (v17 * 2 - v16 * 3 + 1) * p9 + (v17 - v16 * 2 + p13) * p10 + (v17 * -2 + v16 * 3) * p11 + (v17 - v16) * p12, (v16 * 6 - p13 * 6) * p9 + (v16 * 3 - p13 * 4 + 1) * p10 + (v16 * -6 + p13 * 6) * p11 + (v16 * 3 - p13 * 2) * p12
end

local function buildWater(p14) -- line: 125
    -- upvalues: CosmicEvent (copy), fromRGB (copy), new (copy), part (copy)
    local v18 = CosmicEvent.FLOOD_MAX - CosmicEvent.FLOOD_MIN
    local v19 = (CosmicEvent.FLOOD_MAX + CosmicEvent.FLOOD_MIN) / 2
    local Folder = Instance.new("Folder")

    Folder.Name = "Flood"

    local t4 = {}
    local v21 = math.ceil(v18.Z / 1500)
    local v22 = v18.Z / v21

    for i = 1, v21 do
        local v23 = part({
            Name = "FloodSurface",
            Transparency = 1,
            Reflectance = 0.05,
            Size = new(v18.X, 1, v22),
            Color = fromRGB(80, 110, 255),
            Material = Enum.Material.SmoothPlastic
        })

        v23.MaterialVariant = "Stud2"

        for _, v24 in ipairs({
                Enum.NormalId.Top,
                Enum.NormalId.Bottom
            }) do
            local Texture = Instance.new("Texture")

            Texture.Name = "Checker"
            Texture.Texture = "rbxassetid://95102314677499"
            Texture.Face = v24
            Texture.StudsPerTileU = 16
            Texture.StudsPerTileV = 16
            Texture.Color3 = fromRGB(200, 205, 255)
            Texture.Transparency = 1
            Texture.Parent = v23
        end

        v23:SetAttribute("Z", CosmicEvent.FLOOD_MAX.Z - (i - 0.5) * v22)
        v23.Parent = Folder
        t4[i] = v23
    end

    local v25 = part({
        Name = "FloodEdge",
        Transparency = 1,
        Size = new(v18.X, 1, 2),
        Color = fromRGB(70, 100, 240),
        Material = Enum.Material.SmoothPlastic
    })

    v25.Parent = Folder
    Folder.Parent = p14

    return {
        shown = false,
        folder = Folder,
        surfs = t4,
        edge = v25,
        centre = v19,
        size = v18
    }
end

local function setWater(p15, p16) -- line: 160
    -- upvalues: CosmicEvent (copy), new (copy)
    local v26 = CosmicEvent.WATER_FROM + 0.4 < p16

    if p15.shown ~= v26 then
        p15.shown = v26
        p15.edge.Transparency = v26 and 0.45 or 1

        for _, v27 in ipairs(p15.surfs) do
            v27.Transparency = v26 and 0.66 or 1

            for _, child in ipairs(v27:GetChildren()) do
                if child:IsA("Texture") then
                    child.Transparency = v26 and 0.74 or 1
                end
            end
        end
    end

    if not v26 then
        return
    end

    for _, v28 in ipairs(p15.surfs) do
        v28.CFrame = CFrame.new(p15.centre.X, p16 - 0.5, v28:GetAttribute("Z"))
    end

    local v30 = math.max(p16 - CosmicEvent.WATER_FROM, 1)

    p15.edge.Size = new(p15.size.X, v30, 2)
    p15.edge.CFrame = CFrame.new(p15.centre.X, CosmicEvent.WATER_FROM + v30 / 2, CosmicEvent.FLOOD_MIN.Z)
end

local function buildUnderwater(p17) -- line: 186
    -- upvalues: UIKit (copy), fromRGB (copy), new2 (copy), new3 (copy), part (copy)
    local v31 = part({
        Name = "CosmicBubbles",
        Size = Vector3.new(110, 50, 110),
        Transparency = 1
    })
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Bubbles"
    ParticleEmitter.Texture = UIKit.Art.Bubbles
    ParticleEmitter.Color = ColorSequence.new(fromRGB(210, 225, 255))
    ParticleEmitter.Size = new2({
        new3(0, 0.2),
        new3(1, 0.75)
    })
    ParticleEmitter.Transparency = new2({
        new3(0, 1),
        new3(0.15, 0.4),
        new3(0.85, 0.5),
        new3(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(4, 7)
    ParticleEmitter.Speed = NumberRange.new(2, 5)
    ParticleEmitter.Acceleration = Vector3.new(0, 2.5, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 70
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.LockedToPart = false
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = v31

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "Stardust"
    ParticleEmitter2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, fromRGB(170, 210, 255)),
        ColorSequenceKeypoint.new(1, fromRGB(255, 160, 240))
    })
    ParticleEmitter2.Size = new2({
        new3(0, 0),
        new3(0.3, 0.55),
        new3(0.6, 0.2),
        new3(0.8, 0.5),
        new3(1, 0)
    })
    ParticleEmitter2.Transparency = new2(0.1)
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.Lifetime = NumberRange.new(4, 7)
    ParticleEmitter2.Speed = NumberRange.new(0.3, 1.2)
    ParticleEmitter2.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter2.Rate = 38
    ParticleEmitter2.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter2.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter2.LockedToPart = false
    ParticleEmitter2.Enabled = false
    ParticleEmitter2.Parent = v31
    v31.Parent = p17

    local t7 = {}
    local v32 = part({
        Name = "CosmicRays",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    })

    for i = 1, 7 do
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v32

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = v32

        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.FaceCamera = true
        Beam.Segments = 1
        Beam.Width0 = i % 3 * 3 + 5
        Beam.Width1 = i % 4 * 4 + 11
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.Color = ColorSequence.new(fromRGB(225, 205, 255), fromRGB(170, 220, 255))
        Beam.Transparency = new2({
            new3(0, 0.84),
            new3(0.5, 0.92),
            new3(1, 1)
        })
        Beam.Enabled = false
        Beam.Parent = v32
        t7[i] = {
            beam = Beam,
            a0 = Attachment,
            a1 = Attachment2,
            x = (i - 4) * 36 + math.random(-10, 10),
            z = math.random(-90, 60),
            sway = math.random() * 6
        }
    end

    v32.Parent = p17

    return {
        box = v31,
        bubbles = ParticleEmitter,
        dust = ParticleEmitter2,
        rig = v32,
        rays = t7
    }
end

local function buildCracks(p18, p19) -- line: 248
    -- upvalues: fromRGB (copy), new (copy), Neon (copy), part (copy)
    local v33 = Random.new(p19 + 5)
    local v35 = new(v33:NextNumber(-50, 50), 260, 190)
    local t8 = {}

    for i = 1, 8 do
        local v36 = i / 8 * 3.141592653589793 * 2 + v33:NextNumber(-0.3, 0.3)
        local v39 = new(math.cos(v36), math.sin(v36) * 0.75, 0)
        local v40 = v33:NextInteger(6, 10)
        local v41 = v35

        for j = 1, v40 do
            local v42 = v33:NextNumber(20, 36)
            local Unit = (v39 + new(v33:NextNumber(-0.55, 0.55), v33:NextNumber(-0.55, 0.55), 0)).Unit
            local v45 = v41 + Unit * v42

            table.insert(t8, {
                a = v41,
                b = v45,
                w = math.max(6 - j * 0.45, 2),
                order = j + v33:NextNumber(0, 0.7)
            })

            if v33:NextNumber() < 0.4 then
                table.insert(t8, {
                    w = 2,
                    a = v41,
                    b = v41 + (Unit + new(v33:NextNumber(-1, 1), v33:NextNumber(-1, 1), 0)).Unit * v42 * 0.6,
                    order = j + 0.6
                })
            end

            v41 = v45
        end
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "SkyCracks"

    for _, v48 in ipairs(t8) do
        local v49 = (v48.b - v48.a).Magnitude + v48.w * 0.5
        local v50 = part({
            Name = "Crack",
            Transparency = 1,
            Size = new(v48.w, v48.w, v49),
            Material = Neon,
            Color = fromRGB(240, 220, 255)
        })

        v50.CFrame = CFrame.lookAt((v48.a + v48.b) / 2, v48.b)
        v50.Parent = Folder
        v48.part = v50
    end

    local v51 = part({
        Name = "Heart",
        Size = Vector3.new(30, 30, 30),
        Transparency = 1,
        Shape = Enum.PartType.Ball,
        Material = Neon,
        Color = fromRGB(255, 235, 255)
    })

    v51.Position = v35
    v51.Parent = Folder
    Folder.Parent = p18

    return {
        folder = Folder,
        segs = t8,
        heart = v51
    }
end

local function setCracks(p20, p21) -- line: 287
    local v52 = p21 * 10.5

    for _, v53 in ipairs(p20.segs) do
        local v54 = if p21 > 0 and v53.order <= v52 then math.max(0, math.noise(os.clock() * 9, v53.order)) * 0.25 + 0.05 else 1

        if v53.part.Transparency ~= v54 then
            v53.part.Transparency = v54
        end
    end

    local heart = p20.heart

    if p21 > 0 then
        heart.Transparency = 1 - p21 * 0.75
    else
        heart.Transparency = 1
    end

    p20.heart.Size = Vector3.new(1, 1, 1) * (p21 * 44 + 10)
end

local function buildSky() -- line: 300
    -- upvalues: CosmicEvent (copy)
    local Sky = Instance.new("Sky")

    Sky.Name = "CosmicSky"

    for v56, v57 in pairs(CosmicEvent.SKY) do
        Sky["Skybox" .. v56] = v57
    end

    Sky.CelestialBodiesShown = false
    Sky.StarCount = 3000

    return Sky
end

local function buildPortal(p22) -- line: 312
    -- upvalues: CosmicEvent (copy), fromRGB (copy), new (copy), Neon (copy), new2 (copy), new3 (copy), part (copy)
    local PORTAL = CosmicEvent.PORTAL
    local Model = Instance.new("Model")

    Model.Name = "CosmicPortal"

    local v58 = CFrame.new(PORTAL) * CFrame.Angles(0, 0, 1.5707963267948966)
    local v59 = part({
        Name = "Glow",
        Size = Vector3.new(1.5, 132, 132),
        Transparency = 0.35,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = fromRGB(130, 70, 255)
    })

    v59.CFrame = v58
    v59.Parent = Model

    local v60 = part({
        Name = "Core",
        Size = Vector3.new(1.5, 92, 92),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.SmoothPlastic,
        Color = fromRGB(12, 4, 32)
    })

    v60.CFrame = v58 * CFrame.new(-1, 0, 0)
    v60.Parent = Model

    local v61 = part({
        Name = "Eye",
        Size = Vector3.new(1.5, 26, 26),
        Transparency = 0.1,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = fromRGB(255, 220, 255)
    })

    v61.CFrame = v58 * CFrame.new(-1.6, 0, 0)
    v61.Parent = Model

    for i = 1, 2 do
        local v62 = if i == 1 then 70 else 80

        for j = 0, 27 do
            local v63 = (j + 0.5) / 28 * 3.141592653589793 * 2
            local v66 = part({
                Name = "Ring",
                Size = new(if i == 1 then 6 else 3, 3, 6.283185307179586 * v62 / 28 * 1.08),
                Material = Neon,
                Color = if i == 1 then fromRGB(210, 160, 255) else fromRGB(110, 220, 255)
            })

            v66.CFrame = CFrame.new(PORTAL) * CFrame.Angles(0, -v63, 0) * CFrame.new(v62, 0, 0)
            v66.Parent = Model
        end
    end

    local Model2 = Instance.new("Model")

    Model2.Name = "Arms"
    Model2.WorldPivot = CFrame.new(PORTAL)

    for i = 0, 3 do
        local v67

        for j = 0, 10 do
            local v68 = i * 3.141592653589793 / 2 + j * 0.32
            local v69 = j * 5.2 + 12
            local v72 = PORTAL + new(math.cos(v68) * v69, -2.4, math.sin(v68) * v69)

            if v67 then
                local v73 = 6 - j * 0.35
                local v75 = part({
                    Name = "Arm",
                    Size = new(v73, 1.2, (v72 - v67).Magnitude + v73 * 0.5),
                    Material = Neon,
                    Color = fromRGB(255, 255, 255):Lerp(if i % 2 == 0 then fromRGB(190, 140, 255) else fromRGB(120, 220, 255), j / 10)
                })

                v75.CFrame = CFrame.lookAt((v72 + v67) / 2, v72)
                v75.Parent = Model2
            end

            v67 = v72
        end
    end

    Model2.Parent = Model

    local v76 = part({
        Name = "Rain",
        Size = Vector3.new(120, 1, 120),
        Transparency = 1
    })

    v76.CFrame = CFrame.new(PORTAL - Vector3.new(0, 3, 0))

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(fromRGB(255, 230, 255), fromRGB(140, 200, 255))
    ParticleEmitter.Size = new2({
        new3(0, 1.6),
        new3(1, 0)
    })
    ParticleEmitter.Transparency = new2(0.1)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Lifetime = NumberRange.new(5, 8)
    ParticleEmitter.Speed = NumberRange.new(18, 34)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom
    ParticleEmitter.SpreadAngle = Vector2.new(14, 14)
    ParticleEmitter.Rate = 0
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Parent = v76
    v76.Parent = Model
    Model.PrimaryPart = v60
    Model.Parent = p22
    Model:ScaleTo(0.02)

    return {
        scale = 0.02,
        spin = 0,
        model = Model,
        arms = Model2,
        rain = ParticleEmitter
    }
end

local function setPortal(p23, p24, p25) -- line: 380
    local v77 = math.max(0.02, p24)

    if math.abs(v77 - p23.scale) > 0.004 then
        p23.scale = v77
        p23.model:ScaleTo(v77)
    end

    p23.rain.Rate = p24 > 0.5 and 45 or 0

    local v80 = p25 * (math.clamp(1 - p24, 0, 1) * 1.6 + 0.6)

    p23.spin += v80
    p23.arms:PivotTo(p23.arms:GetPivot() * CFrame.Angles(0, v80, 0))
end

local function huntAt(p26, p27) -- line: 449
    -- upvalues: CosmicEvent (copy), hermite (copy)
    local PORTAL = CosmicEvent.PORTAL

    local function pathCF(p28) -- line: 451
        -- upvalues: p26 (copy), CosmicEvent (copy)
        return CosmicEvent.KhaosCF(math.max(p28 - CosmicEvent.PATH_START, 0), p26.seed)
    end

    if p27 < 10.4 then
        return nil
    end

    if not (p27 < CosmicEvent.PATH_START) then
        return pathCF(p27)
    end

    local v82 = CosmicEvent.PATH_START - 10.4
    local v83 = (p27 - 10.4) / v82
    local PATH_START = CosmicEvent.PATH_START
    local v85 = CosmicEvent.KhaosCF(math.max(PATH_START - CosmicEvent.PATH_START, 0), p26.seed)
    local v86 = (CosmicEvent.KhaosAt(0.15, p26.seed) - CosmicEvent.KhaosAt(0, p26.seed)) / 0.15
    local v87, v88 = hermite(PORTAL + Vector3.new(0, 20, 0), Vector3.new(0, -420, -60), v85.Position, v86 * v82 * 1.4, v83)

    return CFrame.lookAt(v87, v87 + v88)
end

local function khaosPose(p29, p30, p31) -- line: 471
    -- upvalues: CosmicEvent (copy), CosmicBattle (copy), CosmicSky (copy), BATTLE (copy), hermite (copy), huntAt (copy)
    local v89 = p29.battleAt - p29.start
    local v90 = v89 + BATTLE.LEN

    local function poseAt(p32) -- line: 474
        -- upvalues: p29 (copy), v89 (copy), v90 (copy), CosmicBattle (copy), CosmicSky (copy), huntAt (copy)
        if v90 <= p32 then
            return CosmicSky.Pose(p29, p32)
        end

        if v89 <= p32 then
            return CosmicBattle.KhaosPose(p29, p32 - v89)
        end

        return huntAt(p29, p32), 1
    end

    if not (p31 >= 0) then
        return poseAt(p30)
    end

    if p31 > 4.3 then
        return nil, 1
    end

    local v91 = p29.endAt - p29.start
    local v92, v93

    if v90 <= v91 then
        v92, v93 = CosmicSky.Pose(p29, v91)
    elseif v89 <= v91 then
        v92, v93 = CosmicBattle.KhaosPose(p29, v91 - v89)
    else
        v92 = huntAt(p29, v91)
        v93 = 1
    end

    if not v92 then
        return nil, 1
    end

    local v95 = math.clamp(p31 / 4.2, 0, 1)
    local v96 = v95 * v95 * (3 - v95 * 2)
    local v97, v98 = hermite(v92.Position, v92.LookVector * 140, CosmicEvent.PORTAL + Vector3.new(0, 30, 0), Vector3.new(0, 420, 50), v96)
    local v99 = CFrame.lookAt(v97, v97 + v98)
    local v100 = 1 - v93
    local v102 = math.clamp(p31 / 3.4, 0, 1)

    return v99, v93 + v100 * (v102 * v102 * (3 - v102 * 2))
end

local t14 = {
    egg = {
        name = "Cosmic Eggs",
        glow = fromRGB(200, 150, 255),
        beam0 = fromRGB(230, 200, 255),
        beam1 = fromRGB(120, 210, 255)
    },
    lucky = {
        name = "Lucky Cast bundles",
        glow = fromRGB(120, 255, 140),
        beam0 = fromRGB(210, 255, 190),
        beam1 = fromRGB(255, 226, 110)
    },
    potion = {
        name = "potions",
        glow = fromRGB(255, 255, 255),
        beam0 = fromRGB(255, 255, 255),
        beam1 = fromRGB(255, 255, 255)
    }
}

local function dropLabel(p33, p34, p35, p36) -- line: 508
    -- upvalues: UIKit (copy), fromRGB (copy), v2 (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "Label"
    BillboardGui.Size = UDim2.fromOffset(180, 58)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 5.8, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 140
    BillboardGui.Parent = p33
    UIKit.frame(BillboardGui, {
        Name = "Back",
        Transparency = 0.3,
        Corner = 14,
        Size = UDim2.new(1, -10, 1, -2),
        Position = UDim2.fromOffset(5, 1),
        Color = fromRGB(18, 12, 40)
    }).ZIndex = 0
    UIKit.text(BillboardGui, {
        Name = "Big",
        TextSize = 30,
        Stroke = 3,
        Text = p34,
        Size = UDim2.new(1, 0, 0, 32),
        Color = p36
    }).FontFace = v2
    UIKit.text(BillboardGui, {
        Name = "Small",
        TextSize = 17,
        Stroke = 2,
        Text = p35,
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.fromOffset(0, 32),
        Color = fromRGB(235, 235, 255)
    })
end

local function buildLucky() -- line: 525
    -- upvalues: CosmicEvent (copy), fromRGB (copy), Neon (copy), part (copy), dropLabel (copy)
    local Model = Instance.new("Model")
    local v103 = part({
        Name = "Box",
        Size = Vector3.new(3.2, 3, 3.2),
        Color = fromRGB(60, 196, 92),
        Material = Enum.Material.SmoothPlastic
    })

    v103.CFrame = CFrame.new(0, 1.5, 0)
    v103.Parent = Model

    local v104 = part({
        Name = "Lid",
        Size = Vector3.new(3.6, 0.7, 3.6),
        Color = fromRGB(84, 222, 112),
        Material = Enum.Material.SmoothPlastic
    })

    v104.CFrame = CFrame.new(0, 3.1, 0)
    v104.Parent = Model

    for i = 0, 1 do
        local v105 = part({
            Name = "Ribbon",
            Size = if i == 0 then Vector3.new(3.7, 3.9, 0.7) else Vector3.new(0.7, 3.9, 3.7),
            Color = fromRGB(255, 212, 70),
            Material = Enum.Material.SmoothPlastic
        })

        v105.CFrame = CFrame.new(0, 1.85, 0)
        v105.Parent = Model
    end

    for i = 0, 3 do
        local v106 = i * 3.141592653589793 / 2 + 0.7853981633974483
        local v107 = part({
            Name = "Leaf",
            Size = Vector3.new(1.25, 1.25, 1.25),
            Shape = Enum.PartType.Ball,
            Color = fromRGB(255, 222, 90),
            Material = Neon
        })

        v107.CFrame = CFrame.new(math.cos(v106) * 0.62, 4.15, math.sin(v106) * 0.62)
        v107.Parent = Model
    end

    local v108 = part({
        Name = "Middle",
        Size = Vector3.new(0.7, 0.7, 0.7),
        Shape = Enum.PartType.Ball,
        Color = fromRGB(255, 245, 190),
        Material = Neon
    })

    v108.CFrame = CFrame.new(0, 4.2, 0)
    v108.Parent = Model

    local v109 = part({
        Name = "Stalk",
        Size = Vector3.new(0.3, 0.9, 0.3),
        Color = fromRGB(230, 180, 50),
        Material = Enum.Material.SmoothPlastic
    })

    v109.CFrame = CFrame.new(0.25, 3.65, 0.25) * CFrame.Angles(0, 0, 0.3)
    v109.Parent = Model
    Model.PrimaryPart = v103
    dropLabel(v103, "x" .. CosmicEvent.DropsByKind.lucky.amount, "LUCKY CASTS", fromRGB(150, 255, 150))

    return Model
end

local function buildPotion(p37) -- line: 557
    -- upvalues: fromRGB (copy), v1 (copy), Neon (copy), part (copy), dropLabel (copy)
    local Model = Instance.new("Model")
    local v110 = part({
        Name = "Glass",
        Size = Vector3.new(3, 3, 3),
        Transparency = 0.78,
        Shape = Enum.PartType.Ball,
        Color = fromRGB(225, 240, 255),
        Material = Enum.Material.SmoothPlastic
    })

    v110.CFrame = CFrame.new(0, 1.5, 0)
    v110.Parent = Model

    local v111 = part({
        Name = "Liquid",
        Size = Vector3.new(2.5, 2.5, 2.5),
        Shape = Enum.PartType.Ball,
        Color = p37.Color2:Lerp(p37.Color, 0.35),
        Material = Enum.Material.SmoothPlastic
    })

    v111.CFrame = CFrame.new(0, 1.42, 0)
    v111.Parent = Model

    local v112 = part({
        Name = "Shine",
        Size = Vector3.new(0.6, 0.9, 0.6),
        Transparency = 0.2,
        Shape = Enum.PartType.Ball,
        Color = v1,
        Material = Neon
    })

    v112.CFrame = CFrame.new(-0.75, 2.05, -0.95)
    v112.Parent = Model

    local v113 = part({
        Name = "Neck",
        Size = Vector3.new(1.3, 1.05, 1.05),
        Transparency = 0.5,
        Shape = Enum.PartType.Cylinder,
        Color = fromRGB(225, 240, 255),
        Material = Enum.Material.SmoothPlastic
    })

    v113.CFrame = CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    v113.Parent = Model

    local v114 = part({
        Name = "Cork",
        Size = Vector3.new(0.7, 1.2, 1.2),
        Shape = Enum.PartType.Cylinder,
        Color = fromRGB(170, 112, 62),
        Material = Enum.Material.SmoothPlastic
    })

    v114.CFrame = CFrame.new(0, 4.05, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    v114.Parent = Model
    Model.PrimaryPart = v110
    dropLabel(v110, "x2 " .. p37.short, string.upper(p37.name), p37.Color)

    return Model
end

local function addDrop(p38, p39) -- line: 581
    -- upvalues: Debris (copy), CosmicEvent (copy), EggModels (copy), UIKit (copy), Buffs (copy), t1 (copy), CurrentCamera (copy), v1 (copy), Neon (copy), new2 (copy), new3 (copy), now (copy), part (copy), t14 (copy), buildLucky (copy), buildPotion (copy)
    local kind, v115

    if type(p39) == "table" then
        if type(p39.id) ~= "number" or p38.drops[p39.id] then
            v115 = true
        else
            kind = if p39.kind == "lucky" or p39.kind == "potion" then p39.kind else "egg"
            v115 = false
        end
    else
        v115 = true
    end

    if v115 then
        return
    end

    local v116 = t14[kind]
    local glow, beam0, beam1 = v116.glow, v116.beam0, v116.beam1
    local v117

    if kind == "lucky" then
        v117 = buildLucky()
        v117.Name = "CosmicLucky"
    elseif kind == "potion" then
        local v118 = Buffs.ById[p39.sub] or Buffs.List[1]

        v117 = buildPotion(v118)
        v117.Name = "CosmicPotion"
        glow = v118.Color
        beam0 = v118.Color:Lerp(v1, 0.45)
        beam1 = v118.Color2
    else
        v117 = EggModels.Build(CosmicEvent.EGG_KEY, CFrame.new(), 0.95, true)
        v117.Name = "CosmicEgg"
    end

    v117:SetAttribute("Kind", kind)

    local PrimaryPart = v117.PrimaryPart

    for _, descendant in ipairs(v117:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant ~= PrimaryPart then
            descendant.Anchored = false
            descendant.Massless = true

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = PrimaryPart
            WeldConstraint.Part1 = descendant
            WeldConstraint.Parent = descendant
        end
    end

    PrimaryPart.Anchored = true

    local _CFrame = PrimaryPart.CFrame
    local PointLight = Instance.new("PointLight")

    PointLight.Color = glow
    PointLight.Range = 16
    PointLight.Brightness = 2
    PointLight.Shadows = false
    PointLight.Parent = PrimaryPart

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v1, glow)
    ParticleEmitter.Size = new2({
        new3(0, 0.9),
        new3(1, 0)
    })
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.4)
    ParticleEmitter.Speed = NumberRange.new(1.5, 4)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Rate = 7
    ParticleEmitter.Parent = PrimaryPart

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 3, 0)
    Attachment.Parent = PrimaryPart

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, 58, 0)
    Attachment2.Parent = PrimaryPart

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.Width0 = 3.2
    Beam.Width1 = 0.6
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Color = ColorSequence.new(beam0, beam1)
    Beam.Transparency = new2({
        new3(0, 1),
        new3(0.13, 1),
        new3(0.24, 0.3),
        new3(1, 1)
    })
    Beam.Parent = PrimaryPart
    v117.Parent = p38.folder

    local t16 = {
        asked = 0,
        data = p39,
        kind = kind,
        model = v117,
        root = PrimaryPart,
        offset = _CFrame,
        born = os.clock()
    }

    p38.drops[p39.id] = t16
    t1.EggsOut += 1

    local v119 = CosmicEvent.DropAt(p39, now())

    PrimaryPart.CFrame = CFrame.new(v119) * _CFrame

    if (CurrentCamera.CFrame.Position - v119).Magnitude < 160 then
        local v120 = 0.9 + math.random() * 0.3

        UIKit.sound("Twinkle", v120)
    end

    local v121 = part({
        Name = "Pop",
        Size = Vector3.new(2, 2, 2),
        Transparency = 0.2,
        Shape = Enum.PartType.Ball,
        Material = Neon,
        Color = glow:Lerp(v1, 0.3)
    })

    v121.Position = v119 + Vector3.new(0, 2.5, 0)
    v121.Parent = p38.folder
    UIKit.tween(v121, 0.5, {
        Size = Vector3.new(14, 14, 14),
        Transparency = 1
    })
    Debris:AddItem(v121, 0.6)
end

local function burst(p40, p41, p42) -- line: 669
    -- upvalues: Debris (copy), v1 (copy), new2 (copy), new3 (copy), part (copy)
    local v122 = part({
        Name = "Burst",
        Size = Vector3.new(2, 2, 2),
        Transparency = 1
    })

    v122.Position = p40

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v1, p41)
    ParticleEmitter.Size = new2({
        new3(0, 1.4),
        new3(1, 0)
    })
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(10, 26)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v122
    v122.Parent = workspace
    ParticleEmitter:Emit(p42)
    Debris:AddItem(v122, 1.4)
end

local function removeDrop(p43, p44, p45) -- line: 688
    -- upvalues: RunService (copy), TweenService (copy), Debris (copy), Buffs (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), burst (copy)
    local v123 = p43.drops[p44]

    if not v123 then
        return
    end

    p43.drops[p44] = nil
    t1.EggsOut = math.max(0, t1.EggsOut - 1)

    local model = v123.model
    local rootPosition = v123.root.Position
    local v125 = if v123.kind == "lucky" then fromRGB(140, 255, 150) elseif v123.kind == "potion" then (Buffs.ById[v123.data.sub] or Buffs.List[1]).Color else fromRGB(200, 150, 255)

    if p45 == LocalPlayer.UserId then
        burst(rootPosition, v125, 40)

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local _CFrame = v123.root.CFrame
        local Scale = model:GetScale()
        local Label = v123.root:FindFirstChild("Label")

        if Label then
            Label.Enabled = false
        end

        local elapsed = os.clock()
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 712
            -- upvalues: v123 (copy), model (copy), rootPosition (copy), _CFrame (copy), Scale (copy), elapsed (copy), connection (ref), HumanoidRootPart (copy)
            local v126 = (os.clock() - elapsed) / 0.35
            local v127, v128

            if v126 >= 1 then
                v128 = true
            elseif model.Parent then
                v127 = if HumanoidRootPart then HumanoidRootPart.Position else rootPosition
                v128 = false
            else
                v128 = true
            end

            if v128 then
                connection:Disconnect()
                model:Destroy()

                return
            end

            v123.root.CFrame = _CFrame:Lerp(CFrame.new(v127) * _CFrame.Rotation, v126 * v126) * CFrame.Angles(0, v126 * 8, 0)
            model:ScaleTo((math.max(0.05, Scale * (1 - v126))))
        end)
    else
        burst(rootPosition, v125, p45 and 22 or 10)
        TweenService:Create(v123.root, TweenInfo.new(0.25), {
            Size = v123.root.Size * 0.1
        }):Play()

        for _, descendant in ipairs(model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                TweenService:Create(descendant, TweenInfo.new(0.25), {
                    Transparency = 1
                }):Play()
            elseif descendant:IsA("Beam") or descendant:IsA("BillboardGui") then
                descendant.Enabled = false
            end
        end

        Debris:AddItem(model, 0.3)
    end
end

local function fullToast(p46, p47) -- line: 741
    -- upvalues: CosmicEvent (copy), Toasts (copy), t1 (copy), t14 (copy)
    if os.clock() - (p46.fullToast[p47] or 0) < 6 then
        return
    end

    p46.fullToast[p47] = os.clock()

    local v130 = CosmicEvent.DropsByKind[p47]
    local v131 = t14[p47] or t14.egg

    Toasts.Show("info", ("You've taken all the %s you can this flood (%d/%d) - leave the rest for everyone else!"):format(v131.name, t1.Got[p47] or 0, if v130 then v130.cap else 0))
end

local function stepDrops(p48, p49, p50) -- line: 751
    -- upvalues: CosmicEvent (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), new (copy), CosmicEvent2 (ref), fullToast (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local v132 = HumanoidRootPart and HumanoidRootPart.Position
    local CFramePosition = CurrentCamera.CFrame.Position
    local frame = p48.frame

    for v133, v134 in pairs(p48.drops) do
        local data = v134.data
        local v135 = CosmicEvent.DropAt(data, p49)
        local v136 = v135.Y > data.gy + 0.05

        if not ((CFramePosition - v135).Magnitude > 260) or (frame + v133) % 6 == 0 then
            local v144 = if v136 then new(math.sin(p50 * 1.3 + v133) * 0.8, 0, math.cos(p50 * 1.1 + v133) * 0.8) else new(0, math.sin(p50 * 2 + v133) * 0.35 + 0.35, 0)

            v134.root.CFrame = CFrame.new(v135 + v144) * CFrame.Angles(0, p50 * 0.9 + v133, 0) * v134.offset
        end

        if v132 and (v132 - (v135 + Vector3.new(0, 2.5, 0))).Magnitude < CosmicEvent.PICKUP - 1 and os.clock() - v134.asked > 0.6 then
            v134.asked = os.clock()

            local v151 = CosmicEvent.DropsByKind[v134.kind]

            if v151 and v151.cap and (t1.Got[v134.kind] or 0) >= v151.cap then
                fullToast(p48, v134.kind)
            else
                CosmicEvent2:FireServer("grab", v133)
            end
        end
    end
end

local function buildGui() -- line: 781
    -- upvalues: UIKit (copy), fromRGB (copy), v2 (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref)
    v3 = UIKit.screenGui("CosmicEvent", 7)
    v5 = UIKit.frame(v3, {
        Name = "Banner",
        Corner = 30,
        Stroke = 5,
        Size = UDim2.fromOffset(660, 60),
        Position = UDim2.new(0.5, 0, 0, 12),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(40, 20, 96),
        Color2 = fromRGB(16, 8, 44),
        StrokeColor = fromRGB(14, 8, 30)
    })
    require(script.Parent.BannerDodge).new(v5)
    UIKit.dress(v5, 30, fromRGB(200, 160, 255))
    v6 = UIKit.text(v5, {
        Name = "Title",
        Text = "COSMIC FLOOD",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -170, 1, 0),
        Position = UDim2.fromOffset(28, 0),
        XAlign = Enum.TextXAlignment.Left
    })
    v6.FontFace = v2
    UIKit.gradient(v6, fromRGB(255, 255, 255), fromRGB(190, 150, 255))
    v7 = UIKit.text(v5, {
        Name = "Time",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(140, 60),
        Position = UDim2.new(1, -24, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right
    })
    v8 = UIKit.text(v5, {
        Name = "Sub",
        Text = "",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(900, 28),
        Position = UDim2.new(0.5, 0, 1, 6),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v8.RichText = true
    v5.Visible = false
    v4 = UIKit.frame(v3, {
        Name = "Cards",
        Transparency = 1,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1)
    })
end

local function card(p51, p52, p53, p54, p55, p56) -- line: 797
    -- upvalues: Debris (copy), UIKit (copy), t1 (copy), v2 (copy), v4 (ref)
    table.insert(t1.Cards, p51)

    local v152 = UIKit.frame(v4, {
        Name = "Card",
        Transparency = 1,
        ZIndex = 5,
        Size = UDim2.fromOffset(1600, p54 + 24),
        Position = UDim2.new(0.5, 0, p56 or 0.34, 0),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local v153 = UIKit.text(v152, {
        Name = "Text",
        Stroke = 7,
        ZIndex = 6,
        Text = p51,
        TextSize = p54,
        Size = UDim2.fromScale(1, 1)
    })

    v153.FontFace = v2
    UIKit.gradient(v153, p52, p53)

    local UIStroke = v153:FindFirstChildOfClass("UIStroke")
    local v154 = UIKit.scaleOf(v152)

    v154.Scale = 2.4
    v153.TextTransparency = 1

    if UIStroke then
        UIStroke.Transparency = 1
    end

    UIKit.tween(v154, 0.32, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.tween(v153, 0.14, {
        TextTransparency = 0
    })

    if UIStroke then
        UIKit.tween(UIStroke, 0.14, {
            Transparency = 0
        })
    end

    task.delay(p55, function() -- line: 815
        -- upvalues: v152 (copy), v153 (copy), UIStroke (copy), v154 (copy), Debris (copy), UIKit (copy)
        UIKit.tween(v154, 0.4, {
            Scale = 0.85
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        UIKit.tween(v153, 0.4, {
            TextTransparency = 1
        })

        if UIStroke then
            UIKit.tween(UIStroke, 0.4, {
                Transparency = 1
            })
        end

        Debris:AddItem(v152, 0.45)
    end)
end

local function gotPopup(p57, p58, p59, p60) -- line: 826
    -- upvalues: Debris (copy), CosmicEvent (copy), UIKit (copy), BuffHud (copy), Buffs (copy), fromRGB (copy), v2 (copy), v4 (ref)
    local v155 = if p57 == "potion" then Buffs.ById[p58 or ""] or Buffs.List[1] else nil
    local v156, v157, v158

    if p57 == "lucky" then
        v156 = fromRGB(40, 150, 74)
        v157 = fromRGB(12, 52, 26)
        v158 = fromRGB(170, 255, 180)
    elseif v155 then
        v156 = v155.Color2:Lerp(fromRGB(0, 0, 0), 0.2)
        v157 = v155.Color2:Lerp(fromRGB(0, 0, 0), 0.75)
        v158 = v155.Color
    else
        v156 = fromRGB(70, 34, 150)
        v157 = fromRGB(24, 12, 60)
        v158 = fromRGB(210, 170, 255)
    end

    local v159 = UIKit.frame(v4, {
        Name = "Got",
        Corner = 24,
        Stroke = 5,
        ZIndex = 7,
        Size = UDim2.fromOffset(580, 96),
        Position = UDim2.new(0.5, 0, 0.74, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = v156,
        Color2 = v157,
        StrokeColor = fromRGB(14, 8, 30)
    })

    UIKit.dress(v159, 24, v158, 7)

    local v160, v161, v162

    if p57 == "lucky" then
        UIKit.image(v159, "Clover", {
            ZIndex = 8,
            Size = UDim2.fromOffset(84, 84),
            Position = UDim2.new(0, 58, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        v160 = ("+%d LUCKY CASTS!"):format(CosmicEvent.DropsByKind.lucky.amount)
        v162 = if p60 then ("%d / %d bundles this flood"):format(p59, p60) else ("%d this flood - grab as many as you can!"):format(p59)
        v161 = fromRGB(170, 255, 170)
    elseif v155 then
        local v163 = BuffHud.Bottle(v159, v155, 82, 8)

        v163.Position = UDim2.new(0, 58, 0.5, 0)
        v163.AnchorPoint = Vector2.new(0.5, 0.5)
        v160 = string.upper(v155.name) .. "!"
        v162 = ("x2 %s for %d:%02d   -   more potions add more time"):format(v155.short, math.floor(v155.seconds / 60), v155.seconds % 60)
        v161 = v155.Color
    else
        UIKit.eggPicture(v159, CosmicEvent.EGG_KEY, {
            ZIndex = 8,
            Size = UDim2.fromOffset(100, 100),
            Position = UDim2.new(0, 56, 0.5, -4)
        })
        v160 = "+1 COSMIC EGG!"
        v162 = ("%d / %d this flood  -  it's in your hotbar"):format(p59, p60)
        v161 = fromRGB(255, 232, 120)
    end

    UIKit.text(v159, {
        Name = "Big",
        TextSize = 40,
        Stroke = 4,
        ZIndex = 8,
        Text = v160,
        Size = UDim2.new(1, -124, 0, 46),
        Position = UDim2.fromOffset(114, 8),
        XAlign = Enum.TextXAlignment.Left,
        Color = v161
    }).FontFace = v2
    UIKit.text(v159, {
        Name = "Small",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 8,
        Text = v162,
        Size = UDim2.new(1, -124, 0, 26),
        Position = UDim2.fromOffset(114, 56),
        XAlign = Enum.TextXAlignment.Left,
        Color = fromRGB(225, 220, 255)
    })
    UIKit.pop(v159, 0.55)
    task.delay(2.4, function() -- line: 861
        -- upvalues: v159 (copy), Debris (copy), UIKit (copy)
        UIKit.tween(UIKit.scaleOf(v159), 0.2, {
            Scale = 0
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        Debris:AddItem(v159, 0.25)
    end)
end

local function blendCF(p61, p62, p63) -- line: 868
    local v165 = math.clamp(p63, 0, 1)

    return p61:Lerp(p62, v165 * v165 * v165 * (v165 * (v165 * 6 - 15) + 10))
end

local function introShot(p64, p65) -- line: 873
    -- upvalues: CosmicEvent (copy), huntAt (copy)
    local PORTAL, CENTER = CosmicEvent.PORTAL, CosmicEvent.CENTER

    if p65 < 4 then
        local v167 = math.clamp(p65 / 4, 0, 1)
        local v168 = v167 * v167 * (3 - v167 * 2)
        local v169 = (Vector3.new(0, 150, 660)):Lerp(Vector3.new(0, 128, 590), v168)
        local v170 = (Vector3.new(0, 105, -200)):Lerp(Vector3.new(0, 140, -330), v168)

        return CFrame.lookAt(v169, v170), 62 - v168 * 4
    end

    local function flood(p66) -- line: 883
        -- upvalues: CENTER (copy)
        local v172 = math.clamp((p66 - 4) / 5.4, 0, 1)
        local v173 = v172 * v172 * (3 - v172 * 2)
        local v174 = (Vector3.new(250, 135, 500)):Lerp(Vector3.new(160, 98, 380), v173)
        local v175 = (CENTER + Vector3.new(0, 6, 0)):Lerp(CENTER + Vector3.new(-20, 40, -10), v173)

        return CFrame.lookAt(v174, v175), v173 * 4 + 66
    end

    local function sky(p67) -- line: 890
        -- upvalues: p64 (copy), PORTAL (copy), huntAt (copy)
        local v176 = PORTAL
        local v177 = huntAt(p64, p67)

        if v177 and p67 >= 10.4 then
            local Position = v177.Position
            local v179 = math.clamp((p67 - 10.4) / 0.9, 0, 1)

            v176 = PORTAL:Lerp(Position, v179 * v179 * (3 - v179 * 2))
        end

        return CFrame.lookAt(Vector3.new(120, 96, 390), v176), 72
    end

    local function dive(p68) -- line: 900
        -- upvalues: p64 (copy), CENTER (copy), huntAt (copy)
        local v181 = math.clamp((p68 - 12.6) / 2.4, 0, 1)
        local v182 = v181 * v181 * v181 * (v181 * (v181 * 6 - 15) + 10)
        local v183 = (Vector3.new(120, 96, 390)):Lerp(Vector3.new(70, 22, 340), v182)
        local v184 = huntAt(p64, p68)
        local v185 = if v184 then v184.Position else CENTER + Vector3.new(0, 30, 0)

        return CFrame.lookAt(v183, v185), v182 * 6 + 72
    end

    if p65 < 9.4 then
        return flood(p65)
    end

    if p65 < 10 then
        local v186 = math.clamp(1, 0, 1)
        local v187 = v186 * v186 * (3 - v186 * 2)
        local v188 = (Vector3.new(250, 135, 500)):Lerp(Vector3.new(160, 98, 380), v187)
        local v189 = (CENTER + Vector3.new(0, 6, 0)):Lerp(CENTER + Vector3.new(-20, 40, -10), v187)
        local v190 = CFrame.lookAt(v188, v189)
        local v191 = v187 * 4 + 66
        local v192 = huntAt(p64, p65)
        local v193

        if v192 and p65 >= 10.4 then
            local Position = v192.Position
            local v195 = math.clamp((p65 - 10.4) / 0.9, 0, 1)

            v193 = PORTAL:Lerp(Position, v195 * v195 * (3 - v195 * 2))
        else
            v193 = PORTAL
        end

        local v196 = CFrame.lookAt(Vector3.new(120, 96, 390), v193)
        local v197 = (p65 - 9.4) / 0.6
        local v198 = math.clamp(v197, 0, 1)
        local v199 = v190:Lerp(v196, v198 * v198 * v198 * (v198 * (v198 * 6 - 15) + 10))
        local v200 = 72 - v191
        local v201 = math.clamp(v197, 0, 1)

        return v199, v191 + v200 * (v201 * v201 * v201 * (v201 * (v201 * 6 - 15) + 10))
    end

    if p65 < 12.6 then
        return sky(p65)
    end

    return dive(p65)
end

local function shakeAt(p69, p70) -- line: 921
    local v202 = if p70 > 0.4 and p70 < 4 then (p70 / 4) ^ 2 * 0.9 + 0.15
        elseif p70 >= 4 and p70 < 4.9 then (1 - (p70 - 4) / 0.9) * 2.2
        elseif p70 >= 4.5 and p70 < 9.6 then 0.5
        else 0

    if p69.splashAt then
        local v203 = os.clock() - p69.splashAt

        if v203 >= 0 and v203 < 1.2 then
            v202 = math.max(v202, 2.6 * (1 - v203 / 1.2) ^ 2)
        end
    end

    return v202
end

local function playIntroCamera(p71) -- line: 939
    -- upvalues: RunService (copy), CosmicEvent (copy), UIKit (copy), HUD (copy), ScreenFx (copy), SkipButton (copy), MoveLock (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), t2 (ref), introShot (copy), shakeAt (copy)
    t1.IntroCamera = true
    t1.IntroPlayed += 1
    HUD.SetMode("cutscene")
    MoveLock.Hold("cosmic")
    UIKit.closeAllWindows()

    local v205 = false

    SkipButton.Show("cosmic", function() -- line: 946
        -- upvalues: v205 (ref)
        v205 = true
    end)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    while t2 == p71 do
        local v206 = workspace:GetServerTimeNow() - p71.start

        if CosmicEvent.INTRO <= v206 or v205 or p71.endAt - p71.start <= v206 then
            break
        end

        local v207, v208 = introShot(p71, (math.max(v206, 0)))
        local v209 = shakeAt(p71, v206)

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = v207 * CFrame.new(math.clamp(math.noise(os.clock() * 22, 7.31, 0.5) * 0.9, -0.5, 0.5) * v209, math.clamp(math.noise(os.clock() * 22, 14.62, 0.5) * 0.9, -0.5, 0.5) * v209, 0) * CFrame.Angles(0, 0, math.clamp(math.noise(os.clock() * 22, 21.93, 0.5) * 0.9, -0.5, 0.5) * v209 * 0.02)
        CurrentCamera.FieldOfView = v208
        RunService.RenderStepped:Wait()
    end

    SkipButton.Hide("cosmic")

    if v205 then
        ScreenFx.Fade(1, 0.12, Color3.new(0, 0, 0))
        task.wait(0.14)
    else
        ScreenFx.Fade(1, 0.2, Color3.new(0, 0, 0))
        task.wait(0.22)
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Humanoid then
        CurrentCamera.CameraSubject = Humanoid
    end

    CurrentCamera.FieldOfView = 70
    MoveLock.Free("cosmic")

    if HUD.GetMode() == "cutscene" then
        HUD.SetMode("normal")
    end

    ScreenFx.Fade(0, 0.45)
    t1.IntroCamera = false
end

local t17 = {
    {
        0,
        function() -- line: 988
            -- upvalues: UIKit (copy), SoundPlayer (copy), fromRGB (copy), card (copy)
            UIKit.sound("DeepRumble", 0.8)
            SoundPlayer.Play("TensionRiser")
            card("!  WARNING  !", fromRGB(255, 120, 120), fromRGB(255, 60, 90), 70, 1.6, 0.3)
        end
    },
    {
        0.8,
        function() -- line: 993
            -- upvalues: UIKit (copy)
            UIKit.sound("OmenHit", 0.8)
        end
    },
    {
        1.9,
        function() -- line: 996
            -- upvalues: UIKit (copy), fromRGB (copy), card (copy)
            UIKit.sound("GlassBoom", 0.7)
            card("THE SKY IS TEARING OPEN...", fromRGB(235, 215, 255), fromRGB(170, 120, 255), 64, 1.8, 0.3)
        end
    },
    {
        2.7,
        function() -- line: 1000
            -- upvalues: UIKit (copy)
            UIKit.sound("EggCrack", 0.55)
        end
    },
    {
        3.3,
        function() -- line: 1003
            -- upvalues: UIKit (copy)
            UIKit.sound("EggCrack", 0.45)
        end
    },
    {
        4,
        function() -- line: 1006
            -- upvalues: UIKit (copy), ScreenFx (copy), v1 (copy)
            UIKit.SoundStopHandler("TensionRiser", 0.1)
            UIKit.sound("SubBoom", nil)
            UIKit.sound("BraamCosmic", nil)
            ScreenFx.Fade(1, 0.05, v1)
            task.delay(0.12, ScreenFx.Fade, 0, 1.4)
        end
    },
    {
        4.6,
        function() -- line: 1013
            -- upvalues: SoundPlayer (copy), fromRGB (copy), card (copy)
            SoundPlayer.Play("WaterSurge")
            card("THE SEA IS RISING!", fromRGB(170, 230, 255), fromRGB(90, 140, 255), 66, 2.4, 0.3)
        end
    },
    {
        8.9,
        function() -- line: 1017
            -- upvalues: SoundPlayer (copy)
            SoundPlayer.PlayEndingIn("ReverseSwell", 1.5)
        end
    },
    {
        10.4,
        function() -- line: 1020
            -- upvalues: UIKit (copy)
            UIKit.sound("DeepRoar", 0.85)
            UIKit.sound("SonicBoom", nil)
        end
    },
    {
        11,
        function() -- line: 1024
            -- upvalues: UIKit (copy), fromRGB (copy), card (copy)
            UIKit.sound("StingChoir", nil)
            card("KHAOS HAS ARRIVED", fromRGB(255, 210, 255), fromRGB(150, 70, 255), 104, 2.1, 0.32)
        end
    },
    {
        13.3,
        function() -- line: 1028
            -- upvalues: UIKit (copy), fromRGB (copy), card (copy)
            UIKit.sound("StingHit", nil)
            card("GRAB WHAT KHAOS DROPS!", fromRGB(255, 245, 170), fromRGB(255, 170, 60), 78, 2.4, 0.32)
        end
    }
}
local t18 = {
    {
        0,
        function() -- line: 1034
            -- upvalues: UIKit (copy), fromRGB (copy), card (copy)
            UIKit.sound("DeepRoar", 0.75)
            card("KHAOS RETURNS TO THE STARS...", fromRGB(235, 215, 255), fromRGB(150, 100, 255), 66, 2.6, 0.32)
        end
    },
    {
        2.4,
        function() -- line: 1038
            -- upvalues: CosmicEvent (copy), SoundPlayer (copy), t1 (copy)
            if t1.Level > CosmicEvent.WATER_FROM + 4 then
                SoundPlayer.Play("WaterSurge")
            end
        end
    },
    {
        2.8,
        function() -- line: 1043
            -- upvalues: CosmicEvent (copy), SoundPlayer (copy), t1 (copy)
            if t1.Level > CosmicEvent.WATER_FROM + 4 then
                SoundPlayer.PlayEndingIn("ReverseSwell", 1.4)
            end
        end
    },
    {
        4.2,
        function() -- line: 1048
            -- upvalues: UIKit (copy)
            UIKit.sound("SonicBoom", nil)
        end
    },
    {
        6.5,
        function() -- line: 1051
            -- upvalues: UIKit (copy), ScreenFx (copy), v1 (copy)
            UIKit.sound("SubBoom", nil)
            UIKit.sound("EggShine", 0.8)
            ScreenFx.Fade(1, 0.05, v1)
            task.delay(0.12, ScreenFx.Fade, 0, 1.4)
        end
    }
}

local function fireCues(p72, p73, p74) -- line: 1059
    for v215, v216 in ipairs(p72) do
        if not p73[v215] and v216[1] <= p74 then
            p73[v215] = true

            if p74 - v216[1] < 1.2 then
                local v217 = v216[2]
                local ok, result = pcall(v217)

                if not ok then
                    warn("[CosmicEvent] " .. tostring(result))
                end
            end
        end
    end
end

local function splash(p75, p76) -- line: 1073
    -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy), Neon (copy), new2 (copy), new3 (copy), part (copy)
    local v218 = p76 and 0.6 or 0.8

    UIKit.sound("Splash", v218)
    UIKit.sound("SubBoom", 0.9)

    local v219 = part({
        Name = "SplashRing",
        Size = Vector3.new(1, 10, 10),
        Transparency = 0.2,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = fromRGB(200, 220, 255)
    })

    v219.CFrame = CFrame.new(p75) * CFrame.Angles(0, 0, 1.5707963267948966)
    v219.Parent = workspace
    UIKit.tween(v219, 1.1, {
        Size = Vector3.new(1, 220, 220),
        Transparency = 1
    })
    Debris:AddItem(v219, 1.2)

    local v220 = part({
        Name = "Spray",
        Size = Vector3.new(30, 2, 30),
        Transparency = 1
    })

    v220.Position = p75

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(fromRGB(230, 240, 255))
    ParticleEmitter.Size = new2({
        new3(0, 6),
        new3(1, 16)
    })
    ParticleEmitter.Transparency = new2({
        new3(0, 0.2),
        new3(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(1, 1.8)
    ParticleEmitter.Speed = NumberRange.new(40, 80)
    ParticleEmitter.SpreadAngle = Vector2.new(30, 30)
    ParticleEmitter.Acceleration = Vector3.new(0, -60, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v220
    v220.Parent = workspace
    ParticleEmitter:Emit(p76 and 60 or 30)
    Debris:AddItem(v220, 2.2)
end

local t19 = {
    brightness = 1.6,
    exposure = 0.3,
    ambient = fromRGB(100, 90, 156),
    outdoor = fromRGB(124, 110, 190)
}
local t20 = {
    brightness = 0.9,
    exposure = -0.25,
    ambient = fromRGB(78, 68, 108),
    outdoor = fromRGB(88, 78, 120)
}

local function blendLight(p77, p78) -- line: 1103
    -- upvalues: Lighting (copy)
    Lighting.Brightness += (p77.brightness - Lighting.Brightness) * p78
    Lighting.ExposureCompensation += (p77.exposure - Lighting.ExposureCompensation) * p78
    Lighting.Ambient = Lighting.Ambient:Lerp(p77.ambient, p78)
    Lighting.OutdoorAmbient = Lighting.OutdoorAmbient:Lerp(p77.outdoor, p78)
end

local function normalLight() -- line: 1110
    -- upvalues: EventFx (copy), t3 (ref)
    local LightGoal = EventFx.LightGoal
    local ok, result = pcall(LightGoal)

    if not ok or not result then
        return t3
    end

    return result
end

local function dayClock() -- line: 1115
    -- upvalues: EventFx (copy), t3 (ref)
    local LightGoal = EventFx.LightGoal
    local ok, result = pcall(LightGoal)

    if not ok or not result then
        result = t3
    end

    local v221 = result.clock or 13.5

    if not (v221 >= 8 and v221 <= 17) then
        return 13.5
    end

    return v221
end

local function lightMix(p79, p80, p81) -- line: 1120
    return {
        brightness = p79.brightness + (p80.brightness - p79.brightness) * p81,
        exposure = p79.exposure + (p80.exposure - p79.exposure) * p81,
        ambient = p79.ambient:Lerp(p80.ambient, p81),
        outdoor = p79.outdoor:Lerp(p80.outdoor, p81)
    }
end

local function hideZoneSkies(p82) -- line: 1129
    local World = workspace:FindFirstChild("World")
    local Skies = World and World:FindFirstChild("Skies")

    if Skies then
        for _, descendant in ipairs(Skies:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p82 and 1 or 0
            end
        end
    end
end

local function setSpace(p83, p84) -- line: 1143
    -- upvalues: Lighting (copy), EventFx (copy), t1 (copy), t3 (ref), hideZoneSkies (copy)
    if p83.space == p84 then
        return
    end

    p83.space = p84
    t1.Space = p84

    if p84 then
        local Sky = Lighting:FindFirstChildOfClass("Sky")

        if Sky and Sky ~= p83.sky then
            p83.oldSky = Sky
            Sky.Parent = nil
        end

        p83.sky.Parent = Lighting

        local LightGoal = EventFx.LightGoal
        local ok, result = pcall(LightGoal)

        if not ok or not result then
            result = t3
        end

        local v222 = result.clock or 13.5

        Lighting.ClockTime = if not (v222 >= 8 and v222 <= 17) then 13.5 else v222
        hideZoneSkies(true)
    else
        p83.sky.Parent = nil

        if p83.oldSky then
            p83.oldSky.Parent = Lighting
            p83.oldSky = nil
        end

        hideZoneSkies(false)
    end
end

local function finish() -- line: 1171
    -- upvalues: Lighting (copy), TweenService (copy), CosmicEvent (copy), UIKit (copy), ZoneAmbience (copy), EventFx (copy), BuffHud (copy), CosmicBattle (copy), CosmicSky (copy), t1 (copy), v1 (copy), t2 (ref), t3 (ref), ColorCorrectionEffect (ref), v5 (ref), removeDrop (copy), hideZoneSkies (copy)
    local t21 = t2

    if not t21 then
        return
    end

    t2 = nil

    local Finish = CosmicBattle.Finish

    pcall(Finish, t21)

    local Finish2 = CosmicSky.Finish

    pcall(Finish2, t21)

    if t21.space ~= false then
        t21.space = false
        t1.Space = false
        t21.sky.Parent = nil

        if t21.oldSky then
            t21.oldSky.Parent = Lighting
            t21.oldSky = nil
        end

        hideZoneSkies(false)
    end

    ZoneAmbience.Override = nil

    if t21.loop then
        UIKit.SoundStopHandler("AmbShimmer", 1.5)
    end

    for v223 in pairs(t21.drops) do
        removeDrop(t21, v223, nil)
    end

    t21.folder:Destroy()
    t21.sky:Destroy()
    v5.Visible = false
    BuffHud.BannerUp = false
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.5), {
        Saturation = 0,
        Contrast = 0,
        Brightness = 0,
        TintColor = v1
    }):Play()

    local ReleaseSky = EventFx.ReleaseSky

    if not pcall(ReleaseSky, 2) then
        TweenService:Create(Lighting, TweenInfo.new(2), {
            Brightness = t3.brightness,
            ExposureCompensation = t3.exposure,
            Ambient = t3.ambient,
            OutdoorAmbient = t3.outdoor
        }):Play()
    end

    t1.Phase = "off"
    t1.Act = "off"
    t1.Level = CosmicEvent.WATER_FROM
    t1.EggsOut = 0
    t1.Under = false
    t1.KhaosShown = false
    t1.KhaosScale = 1
end

local function begin(p85, p86, p87, p88) -- line: 1206
    -- upvalues: ContentProvider (copy), CosmicEvent (copy), FishModels (copy), HUD (copy), ZoneAmbience (copy), EventFx (copy), CosmicBattle (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), new2 (copy), new3 (copy), CosmicEvent2 (ref), t2 (ref), v3 (ref), sound (copy), part (copy), buildWater (copy), buildUnderwater (copy), buildCracks (copy), buildPortal (copy), huntAt (copy), card (copy), playIntroCamera (copy), splash (copy), finish (copy)
    finish()

    local Folder = Instance.new("Folder")

    Folder.Name = "CosmicFlood"
    Folder.Parent = workspace

    local t22 = {
        frame = 0,
        kScale = 1,
        portalOpen = 0,
        space = false,
        splashed = false,
        rose = false,
        start = p85,
        seed = p86,
        endAt = p87,
        battleAt = if p88 > 0 then p88 else p85 + CosmicEvent.Plan(p87 - p85),
        folder = Folder,
        drops = {},
        fullToast = {},
        introDone = {},
        outroDone = {}
    }
    local Sky = Instance.new("Sky")

    Sky.Name = "CosmicSky"

    for v225, v226 in pairs(CosmicEvent.SKY) do
        Sky["Skybox" .. v225] = v226
    end

    Sky.CelestialBodiesShown = false
    Sky.StarCount = 3000
    t22.sky = Sky
    t22.water = buildWater(Folder)
    t22.under = buildUnderwater(Folder)
    t22.cracks = buildCracks(Folder, p86)
    t22.portal = buildPortal(Folder)
    t22.api = {
        gui = v3,
        remote = CosmicEvent2,
        sound = sound,
        card = card,
        splash = splash,
        level = function() -- level | line: 1223
            -- upvalues: t1 (copy)
            return t1.Level
        end,
        huntPose = function(p89) -- huntPose | line: 1226
            -- upvalues: p86 (copy), t22 (copy), CosmicEvent (copy), huntAt (copy)
            return huntAt(t22, p89) or CosmicEvent.KhaosCF(0, p86)
        end
    }
    t2 = t22
    t1.Got = {
        lucky = 0,
        potion = 0,
        egg = 0
    }
    t1.EggsOut = 0
    t1.Cards = {}
    CosmicBattle.Reset()

    local HoldSky = EventFx.HoldSky

    pcall(HoldSky)
    task.spawn(function() -- line: 1237
        -- upvalues: ContentProvider (copy), CosmicEvent (copy)
        local t24 = {}

        for _, v227 in pairs(CosmicEvent.SKY) do
            table.insert(t24, v227)
        end

        local function v228() -- line: 1242
            -- upvalues: t24 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t24)
        end

        pcall(v228)
    end)
    task.spawn(function() -- line: 395
        -- upvalues: t22 (copy), CosmicEvent (copy), FishModels (copy), fromRGB (copy), new2 (copy), new3 (copy), t2 (ref), part (copy)
        local Get = FishModels.Get
        local ok, result = pcall(Get, "khaos", 1, 1, 90)

        if ok and result then
            if t2 == t22 then
                local _, BoundingBox = result:GetBoundingBox()

                result:ScaleTo(result:GetScale() * CosmicEvent.KHAOS_LENGTH / math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 1))

                for _, descendant in ipairs(result:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                    end
                end

                local BoundingBox2, BoundingBox3 = result:GetBoundingBox()
                local v230 = result:GetPivot():ToObjectSpace(BoundingBox2)
                local v231 = part({
                    Name = "Aura",
                    Transparency = 1,
                    Size = BoundingBox3 * 0.6
                })

                v231.CFrame = BoundingBox2

                local PointLight = Instance.new("PointLight")

                PointLight.Color = fromRGB(190, 130, 255)
                PointLight.Range = 60
                PointLight.Brightness = 2.5
                PointLight.Shadows = false
                PointLight.Parent = v231

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ParticleEmitter.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.5, fromRGB(200, 140, 255)),
                    ColorSequenceKeypoint.new(1, fromRGB(110, 210, 255))
                })
                ParticleEmitter.Size = new2({
                    new3(0, 2.2),
                    new3(1, 0)
                })
                ParticleEmitter.Transparency = new2({
                    new3(0, 0.1),
                    new3(1, 1)
                })
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Lifetime = NumberRange.new(1.5, 3)
                ParticleEmitter.Speed = NumberRange.new(0.5, 3)
                ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
                ParticleEmitter.Rate = 70
                ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
                ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                ParticleEmitter.LockedToPart = false
                ParticleEmitter.Parent = v231
                v231.Parent = result
                result.Name = "CosmicKhaos"
                result:PivotTo(CFrame.new(0, -500, 0))
                result.Parent = t22.folder
                t22.khaosBase = result:GetScale()
                t22.khaosOffset = v230
                t22.khaos = result
            else
                result:Destroy()
            end
        end
    end)

    ZoneAmbience.Override = function(_) -- line: 1247
        -- upvalues: t22 (copy)
        return t22.fog
    end

    CosmicEvent2:FireServer("hello")

    if workspace:GetServerTimeNow() - p85 < CosmicEvent.INTRO - 2.5 and HUD.GetMode() == "normal" and not LocalPlayer:GetAttribute("InAquarium") then
        task.spawn(playIntroCamera, t22)
    end
end

local function step(p91) -- line: 1258
    -- upvalues: CosmicEvent (copy), FishModels (copy), UIKit (copy), HUD (copy), SoundPlayer (copy), EventFx (copy), BuffHud (copy), CosmicBattle (copy), CosmicSky (copy), BATTLE (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), fromRGB (copy), new (copy), v1 (copy), t2 (ref), t3 (ref), ColorCorrectionEffect (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), setWater (copy), setCracks (copy), setPortal (copy), khaosPose (copy), stepDrops (copy), t17 (copy), t18 (copy), fireCues (copy), splash (copy), t19 (copy), t20 (copy), blendLight (copy), lightMix (copy), setSpace (copy), finish (copy)
    local t25 = t2

    if not t25 then
        return
    end

    t25.frame += 1

    local ServerTimeNow = workspace:GetServerTimeNow()
    local v232 = ServerTimeNow - t25.start
    local v233 = t25.endAt - t25.start
    local v234 = t25.battleAt - t25.start
    local v235 = v234 + BATTLE.LEN
    local v236 = v232 - v233
    local elapsed = os.clock()
    local v237 = if v232 < 0 then "starting" elseif v236 >= 0 then "ending" else CosmicEvent.Act(v232, v234)

    t1.Act = v237
    t1.Phase = if CosmicEvent.OUTRO <= v236 then "done" else v237
    v9 = v9 or LocalPlayer.PlayerGui:FindFirstChild("Reveal")

    local v239 = v9 ~= nil and v9.Enabled

    if not t25.fight and v236 < 0 and v234 - 20 <= v232 and v232 < v235 - 1 then
        CosmicBattle.Begin(t25, t25.api)
    elseif t25.fight and (v236 >= 0 or v235 + 4 <= v232) then
        CosmicBattle.Finish(t25)
    end

    if not t25.storm and v236 < 0 and v235 - 10 <= v232 then
        CosmicSky.Begin(t25, t25.api)
    end

    local v240 = CosmicEvent.WATER_FROM
    local v241 = CosmicEvent.WATER_TO - CosmicEvent.WATER_FROM
    local v243 = math.clamp((v232 - 4.4) / 5.2, 0, 1)
    local v238 = v240 + v241 * (v243 * v243 * v243 * (v243 * (v243 * 6 - 15) + 10))

    v240 = v233 + 2.5

    local n1 = 5

    if v234 + BATTLE.ASCEND < v240 then
        v240 = v234 + BATTLE.ASCEND
        n1 = 10
    end

    local v242 = CosmicEvent.WATER_FROM - v238

    v243 = (v232 - v240) / n1

    local v244 = math.clamp(v243, 0, 1)

    v241 = v238 + v242 * (v244 * v244 * v244 * (v244 * (v244 * 6 - 15) + 10))

    local v245

    if CosmicEvent.WATER_FROM + 1 < v241 then
        v245 = elapsed * 0.8
        v241 += math.sin(v245) * 0.5
    end

    t1.Level = v241

    if not t25.drainHeard and v240 <= v232 then
        t25.drainHeard = true

        if v232 < v240 + 2 and v236 < 0 then
            SoundPlayer.Play("WaterSurge")
        end
    end

    if v239 then
        t25.water.folder.Parent = nil
    else
        t25.water.folder.Parent = t25.folder
        setWater(t25.water, v241)
    end

    local v246

    if v232 >= 1.8 and v232 < 4 and v236 < 0 then
        v246 = (v232 - 1.8) / 2
        n1 = math.clamp(v246, 0, 1)
    else
        n1 = 0
    end

    setCracks(t25.cracks, n1)
    v245 = v232 >= 4 and v236 < 6.5
    setSpace(t25, v245)

    if v236 >= 0 then
        v245 = (v236 - 4.1) / 0.5
        v246 = 1 - math.clamp(v245, 0, 1)
    elseif v233 - 2.5 <= v232 then
        v246 = 1
    elseif v234 + 111 <= v232 then
        v246 = 0
    else
        v242 = (v232 - 8.9) / 1.4
        v243 = math.clamp(v242, 0, 1)
        v246 = v243 * v243 * (3 - v243 * 2)
    end

    local v247, result, v248, v249, v250

    if v232 < CosmicEvent.INTRO then
        t25.portalOpen = v246
    else
        v250 = t25.portalOpen
        v247 = v246 - t25.portalOpen
        result = -p91
        v248 = if v236 >= 4 then 14 else 2.2
        v249 = result * v248
        t25.portalOpen = v250 + v247 * (1 - math.exp(v249))
    end

    v246 = t25.portalOpen

    if v246 > 0.98 then
        v247 = elapsed * 2
        v246 = math.sin(v247) * 0.03 + 1
    end

    setPortal(t25.portal, v246, p91)
    v250, v245 = khaosPose(t25, v232, v236)

    local khaos, kScale

    if t25.khaos then
        if v250 then
            if v245 ~= t25.kScale then
                khaos = v245 / t25.kScale - 1

                if math.abs(khaos) > 0.025 or v245 == 1 or v245 == CosmicEvent.GIANT_SCALE then
                    t25.kScale = v245
                    FishModels.Rescale(t25.khaos, t25.khaosBase * v245)
                end
            end

            v246 = t25.khaosOffset
            t25.khaos:PivotTo(v250 * (CFrame.new(v246.Position * t25.kScale) * v246.Rotation):Inverse())
            khaos = FishModels.Animate
            v244 = t25.khaos
            kScale = t25.kScale
            result = 5 / math.sqrt(kScale)
            pcall(khaos, v244, elapsed, result, 0.32)
            t1.KhaosShown = true
            t1.KhaosScale = t25.kScale
            v246 = v250.Position.Y

            if t25.lastY then
                if not t25.splashed and v241 < t25.lastY and v246 <= v241 and v236 < 0 then
                    t25.splashed = true
                    t25.splashAt = elapsed
                    v244 = v250.Position.X
                    result = v250.Position.Z
                    splash(new(v244, v241, result), true)
                elseif not t25.rose and t25.lastY < v241 and v241 <= v246 and v236 >= 0 then
                    t25.rose = true
                    v244 = v250.Position.X
                    result = v250.Position.Z
                    splash(new(v244, v241, result), false)
                end
            end

            t25.lastY = v246
        else
            t25.khaos:PivotTo(CFrame.new(0, -500, 0))
            t1.KhaosShown = false
        end
    end

    stepDrops(t25, ServerTimeNow, elapsed)
    v245 = HUD.GetMode() ~= "cutscene" and v232 >= 0 and v236 < CosmicEvent.OUTRO and v237 ~= "battle"
    v247 = v5
    v247.Visible = v245
    BuffHud.BannerUp = v245

    local result2, ok, v251, v252, v253

    if v245 then
        if v236 < 0 then
            v244 = t25.endAt - ServerTimeNow
            n1 = math.max(0, v244)
        else
            n1 = 0
        end

        v247 = v7
        khaos = string.format
        result = n1 / 60
        v249 = math.floor(result)
        v248 = n1 % 60
        v247.Text = khaos("%d:%02d", v249, (math.floor(v248)))
        n1 = v235 <= v232
        v240 = if n1 then "COSMIC STORM" else "COSMIC FLOOD"

        if v6.Text ~= v240 then
            v247 = v6
            v247.Text = v240
        end

        if v236 >= 0 then
            v247 = v8
            v247.Text = "Khaos is leaving..."
        elseif v232 < CosmicEvent.INTRO then
            v247 = v8
            v247.Text = "Something is coming..."
        elseif n1 then
            v247 = v8
            v247.Text = "Khaos's beams can turn the fish in your pen <font color=\"#C8B4FF\">COSMIC x300</font>!"
        else
            local Got, Max = t1.Got, t1.Max

            local function count(p92) -- line: 1395
                -- upvalues: Got (copy), Max (copy)
                if Max[p92] then
                    return (("%d/%d"):format(Got[p92] or 0, Max[p92]))
                end

                return (tostring(Got[p92] or 0))
            end

            result2 = v8
            ok = "Grab what Khaos drops!   <font color=\"#9CFF9C\">Lucky Casts %s</font>   <font color=\"#FFE27A\">Potions %s</font>   <font color=\"#D2B4FF\">Eggs %s</font>"

            if Max.lucky then
                v253 = ("%d/%d"):format(Got.lucky or 0, Max.lucky)
            else
                kScale = Got.lucky or 0
                v253 = tostring(kScale)
            end

            if Max.potion then
                kScale = ("%d/%d"):format(Got.potion or 0, Max.potion)
            else
                v251 = Got.potion or 0
                kScale = tostring(v251)
            end

            if Max.egg then
                v251 = ("%d/%d"):format(Got.egg or 0, Max.egg)
            else
                v252 = Got.egg or 0
                v251 = tostring(v252)
            end

            result2.Text = ok:format(v253, kScale, v251)
        end
    end

    if t25.fight then
        CosmicBattle.Step(t25, v232 - v234, v236, p91)
    end

    if t25.storm then
        v247 = CosmicSky.Step

        if v237 ~= "cosmic" then
            v250 = nil
        end

        v247(t25, ServerTimeNow, p91, v250, t25.kScale)
    end

    v245 = CurrentCamera.CFrame
    v250 = v245.Position
    v238 = not v239 and CosmicEvent.InFlood(v250) and v250.Y < v241 - 0.3
    t1.Under = v238
    v237 = t25.under

    if v238 ~= t25.wasUnder then
        t25.wasUnder = v238
        v237.bubbles.Enabled = v238
        v237.dust.Enabled = v238

        for _, v255 in ipairs(v237.rays) do
            v255.beam.Enabled = v238
        end
    end

    local v256

    if v238 then
        v234 = v245.LookVector
        khaos = v234.X
        ok = v234.Z
        v247 = new(khaos, 0, ok)

        local v257 = if v247.Magnitude > 0.01 then v247.Unit else Vector3.new(0, 0, -1)

        v237.box.CFrame = CFrame.new(v250 + v257 * 30)
        v247 = v257:Cross((Vector3.new(0, 1, 0)))

        for _, v258 in ipairs(v237.rays) do
            v253 = v250 + v247 * v258.x + v257 * (v258.z + 60)
            v256 = elapsed * 0.3 + v258.sway
            v251 = math.sin(v256) * 8
            ServerTimeNow = v253 + new(v251, 0, 0)
            kScale = ServerTimeNow.X
            v252 = ServerTimeNow.Z
            v253 = new(kScale, v241, v252)
            v258.a0.WorldPosition = v253
            v248 = v258.a1
            v256 = -(v241 + 10)
            v248.WorldPosition = v253 + new(28, v256, 18)
        end
    end

    if v239 then
        t25.fog = nil
    else
        if v238 then
            t25.fog = {
                40, 1200,
                fromRGB(50, 34, 120)
            }
        elseif not (t25.space and CosmicEvent.InFlood(v250)) then
            t25.fog = nil
        else
            t25.fog = {
                500, 4200,
                fromRGB(28, 20, 70)
            }
        end

        khaos = -p91 * 2.6
        v245 = 1 - math.exp(khaos)
        khaos = t25.space

        if not khaos or LocalPlayer:GetAttribute("InAquarium") then
            if v236 < 0 and v232 >= 0 and v232 < 4 then
                result = EventFx.LightGoal
                ok, result = pcall(result)

                if not ok or not result then
                    result = t3
                end

                v253 = v232 / 3.6
                v251 = math.clamp(v253, 0, 1)
                result2 = lightMix(result, t20, v251 * v251 * (3 - v251 * 2))
            else
                result2 = EventFx.LightGoal
                khaos, result2 = pcall(result2)

                if not khaos or not result2 then
                    result2 = t3
                end
            end
        else
            result2 = t19
        end

        blendLight(result2, v245)
        khaos = v1

        if v238 then
            khaos = fromRGB(222, 214, 255)
            result2 = 0.05
            ok = 0.06
            result = 0.02
        elseif t25.space then
            khaos = fromRGB(226, 214, 255)
            result2 = 0.12
            ok = 0.05
            result = 0
        elseif v232 >= 0 and v232 < 4 then
            v251 = fromRGB(205, 175, 255)
            v256 = v232 / 3.6

            local v259 = math.clamp(v256, 0, 1)

            khaos = v1:Lerp(v251, v259 * v259 * (3 - v259 * 2))
            result2 = -0.15
            ok = 0.06
            result = -0.02
        else
            result2 = 0
            ok = 0
            result = 0
        end

        v253 = ColorCorrectionEffect
        v253.TintColor = ColorCorrectionEffect.TintColor:Lerp(khaos, v245)
        v253 = ColorCorrectionEffect
        v253.Saturation += (result2 - ColorCorrectionEffect.Saturation) * v245
        v253 = ColorCorrectionEffect
        v253.Contrast += (ok - ColorCorrectionEffect.Contrast) * v245
        v253 = ColorCorrectionEffect
        v253.Brightness += (result - ColorCorrectionEffect.Brightness) * v245
    end

    fireCues(t17, t25.introDone, v232)

    if v236 >= 0 then
        fireCues(t18, t25.outroDone, v236)
    end

    v250 = CosmicEvent.INTRO - 1 <= v232 and v232 < v235 and v236 < 6.5

    if v250 ~= (t25.loop == true) then
        t25.loop = v250

        if v250 then
            SoundPlayer.Play("AmbShimmer")
        else
            UIKit.SoundStopHandler("AmbShimmer", 2)
        end
    end

    if CosmicEvent.OUTRO + 0.5 <= v236 then
        finish()
    end
end

local function refresh() -- line: 1496
    -- upvalues: CosmicEvent (copy), t2 (ref), finish (copy), begin (copy)
    local v260 = workspace:GetAttribute("CosmicStart") or 0
    local v261 = workspace:GetAttribute("CosmicSeed") or 0
    local v262 = workspace:GetAttribute("CosmicEndAt") or 0
    local v263 = workspace:GetAttribute("CosmicBattleAt") or 0

    if v260 > 0 then
        if not t2 or t2.start ~= v260 then
            if workspace:GetServerTimeNow() < v262 + CosmicEvent.OUTRO then
                begin(v260, v261, v262, v263)
            end
        else
            t2.endAt = v262

            if v263 > 0 then
                t2.battleAt = v263
            end
        end
    elseif t2 and workspace:GetServerTimeNow() > t2.endAt + CosmicEvent.OUTRO then
        finish()
    end
end

function t1.Init() -- line: 1518
    -- upvalues: RunService (copy), Lighting (copy), ReplicatedStorage (copy), CosmicEvent (copy), UIKit (copy), CosmicBattle (copy), CosmicSky (copy), t1 (copy), CosmicEvent2 (ref), t2 (ref), t3 (ref), ColorCorrectionEffect (ref), addDrop (copy), removeDrop (copy), fullToast (copy), buildGui (copy), gotPopup (copy), step (copy), refresh (copy)
    CosmicEvent2 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CosmicEvent")
    t3 = {
        clock = Lighting.ClockTime,
        brightness = Lighting.Brightness,
        exposure = Lighting.ExposureCompensation,
        ambient = Lighting.Ambient,
        outdoor = Lighting.OutdoorAmbient
    }
    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "CosmicTint"
    ColorCorrectionEffect.Parent = Lighting
    buildGui()
    CosmicEvent2.OnClientEvent:Connect(function(p93, p94, p95, p96, p97, p98) -- line: 1528
        -- upvalues: CosmicEvent (copy), UIKit (copy), CosmicBattle (copy), CosmicSky (copy), t1 (copy), t2 (ref), addDrop (copy), removeDrop (copy), fullToast (copy), gotPopup (copy)
        local t27 = t2

        if p93 == "drop" then
            if t27 then
                addDrop(t27, p94)
            end
        elseif p93 == "gone" then
            if t27 then
                removeDrop(t27, p94, p95)
            end
        elseif p93 == "sync" then
            if t27 and type(p94) == "table" then
                for _, v264 in ipairs(p94) do
                    addDrop(t27, v264)
                end
            end

            if type(p95) == "table" then
                for v265, v266 in pairs(p95) do
                    t1.Got[v265] = tonumber(v266) or 0
                end
            end

            CosmicBattle.OnBets(p96, p97)

            if p98 then
                CosmicBattle.OnMyBet(p98)
            end
        elseif p93 == "got" then
            local v267 = tostring(p94)

            t1.Got[v267] = tonumber(p96) or (t1.Got[v267] or 0) + 1

            local v268 = CosmicEvent.DropsByKind[v267]
            local v269 = v267 == "egg" and "EggShine" or "Twinkle"

            UIKit.sound(v269, nil)
            UIKit.sound("Coins", nil)

            local v270 = t1.Got[v267]
            local v271 = tonumber(p97)

            if not v271 then
                v271 = if v268 then v268.cap else nil
            end

            gotPopup(v267, p95, v270, v271)
        elseif p93 == "full" then
            local v272 = tostring(p94)

            t1.Got[v272] = math.max(t1.Got[v272] or 0, tonumber(p95) or 0)

            if t27 then
                fullToast(t27, v272)
            end
        elseif p93 == "bets" then
            CosmicBattle.OnBets(p94, p95)
        elseif p93 == "myBet" then
            CosmicBattle.OnMyBet(p94)
        elseif p93 == "betResult" then
            CosmicBattle.OnResult(p94, p95)
        elseif p93 == "beam" then
            if t27 then
                if not t27.storm then
                    CosmicSky.Begin(t27, t27.api)
                end

                CosmicSky.OnBeam(t27, p94)
            end
        elseif p93 == "mutated" then
            if t27 then
                if not t27.storm then
                    CosmicSky.Begin(t27, t27.api)
                end

                CosmicSky.OnMutated(t27, p94)
            end
        elseif p93 == "swept" and t27 then
            CosmicSky.OnSwept(t27)
        end
    end)

    for _, v275 in ipairs({ "CosmicStart", "CosmicEndAt", "CosmicBattleAt" }) do
        workspace:GetAttributeChangedSignal(v275):Connect(refresh)
    end

    RunService:BindToRenderStep("CosmicEvent", Enum.RenderPriority.Camera.Value + 2, function(p99) -- line: 1597
        -- upvalues: step (copy)
        local ok, result = pcall(step, p99)

        if not ok then
            warn("[CosmicEvent] " .. tostring(result))
        end
    end)
    task.defer(refresh)
end

return t1

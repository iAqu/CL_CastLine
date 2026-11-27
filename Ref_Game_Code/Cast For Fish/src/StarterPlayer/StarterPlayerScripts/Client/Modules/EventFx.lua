-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = require(Shared.Data.Events)
local Fish = require(Shared.Data.Fish)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Rarities = require(Shared.Data.Rarities)
local NumberFormat = require(Shared.NumberFormat)
local FishModels = require(Shared.FishModels)
local GameConfig = require(Shared.GameConfig)
local UIKit = require(script.Parent.UIKit)
local Toasts = require(script.Parent.Toasts)
local Sounds = require(Shared.Data.Sounds)
local SoundPlayer = require(script.Parent.SoundPlayer)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local AdminAbuseFx = require(script.Parent.AdminAbuseFx)
local t1 = {}
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1, v2, UIStroke, v3, v4, v5, v6, Part, ColorCorrectionEffect, v7
local n1 = 0
local v8 = false
local n2 = 0
local t2 = {}
local v9 = false
local v10, v11

local function weatherOn() -- line: 52
    -- upvalues: DataClient (copy)
    return (DataClient.Get("Settings") or {}).Weather ~= false
end

local function setLoop(p1) -- line: 56
    -- upvalues: SoundPlayer (copy), v10 (ref)
    if p1 == v10 then
        return
    end

    if v10 then
        SoundPlayer.Stop(v10, 1.5)
    end

    v10 = p1

    if p1 then
        SoundPlayer.Play(p1)
    end
end

t1.Active = nil
t1.CardsShown = 0

local function hex(p2) -- line: 71
    return string.format("#%02X%02X%02X", math.floor(p2.R * 255 + 0.5), math.floor(p2.G * 255 + 0.5), (math.floor(p2.B * 255 + 0.5)))
end

local function emitter(p3) -- line: 76
    -- upvalues: Part (ref)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.LockedToPart = false
    ParticleEmitter.Rotation = NumberRange.new(0)

    for v17, v18 in pairs(p3) do
        ParticleEmitter[v17] = v18
    end

    ParticleEmitter.Parent = Part

    return ParticleEmitter
end

local function fade(p4, p5) -- line: 89
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, p4),
        NumberSequenceKeypoint.new(0.8, p5),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function startWeather(p6) -- line: 93
    -- upvalues: fromRGB (copy), Part (ref), emitter (copy), fade (copy)
    Part:ClearAllChildren()

    local fall = p6.fx.fall

    if fall == "rain" then
        emitter({
            Name = "Rain",
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            LightEmission = 0.4,
            Color = ColorSequence.new(fromRGB(200, 225, 255)),
            Transparency = NumberSequence.new(0.15),
            Size = NumberSequence.new(1.8),
            Squash = NumberSequence.new(2.4),
            EmissionDirection = Enum.NormalId.Bottom,
            Speed = NumberRange.new(75, 95),
            Lifetime = NumberRange.new(0.55, 0.7),
            Rate = p6.fx.flashes and 1700 or 1100
        })
    elseif fall == "snow" then
        emitter({
            Name = "Snow",
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Rate = 240,
            Acceleration = Vector3.new(2.5, 0, 1),
            LightEmission = 0.6,
            Color = ColorSequence.new(fromRGB(255, 255, 255)),
            Transparency = fade(0, 0.15),
            Size = NumberSequence.new(0.55),
            EmissionDirection = Enum.NormalId.Bottom,
            Speed = NumberRange.new(7, 13),
            Lifetime = NumberRange.new(4, 5.5),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-60, 60)
        })
    elseif fall == "sparkle" then
        emitter({
            Name = "Sparkle",
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Rate = 110,
            LightEmission = 1,
            Color = ColorSequence.new(fromRGB(255, 255, 255), p6.Color),
            Transparency = fade(0, 0.3),
            EmissionDirection = Enum.NormalId.Bottom,
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.3, 1.3),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Speed = NumberRange.new(1.5, 4),
            Lifetime = NumberRange.new(3, 4.5),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-50, 50)
        })
    elseif fall == "meteor" then
        emitter({
            Name = "Meteors",
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            Rate = 26,
            LightEmission = 1,
            Color = ColorSequence.new(fromRGB(255, 235, 170), fromRGB(255, 110, 30)),
            Transparency = NumberSequence.new(0.05),
            Size = NumberSequence.new(3.2),
            Squash = NumberSequence.new(2.2),
            EmissionDirection = Enum.NormalId.Bottom,
            Speed = NumberRange.new(95, 125),
            Lifetime = NumberRange.new(0.5, 0.7)
        })
        emitter({
            Name = "Specks",
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Rate = 60,
            LightEmission = 1,
            Color = ColorSequence.new(fromRGB(255, 190, 120)),
            Transparency = fade(0.1, 0.4),
            EmissionDirection = Enum.NormalId.Bottom,
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.3, 0.9),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Speed = NumberRange.new(2, 5),
            Lifetime = NumberRange.new(2.5, 4),
            Rotation = NumberRange.new(0, 360)
        })
    elseif fall == "ember" then
        emitter({
            Name = "Embers",
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Rate = 150,
            Acceleration = Vector3.new(1.5, 0, 0),
            LightEmission = 1,
            Color = ColorSequence.new(fromRGB(255, 120, 90), fromRGB(255, 40, 60)),
            Transparency = fade(0, 0.3),
            EmissionDirection = Enum.NormalId.Top,
            Size = NumberSequence.new(0.6, 0.15),
            Speed = NumberRange.new(2.5, 6),
            Lifetime = NumberRange.new(3, 5),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-80, 80)
        })
    end
end

local function setWeatherEnabled(p7) -- line: 124
    -- upvalues: Part (ref)
    for _, child in ipairs(Part:GetChildren()) do
        if child:IsA("ParticleEmitter") and child.Enabled ~= p7 then
            child.Enabled = p7
        end
    end
end

local t4 = {
    rain = {
        clock = 13.5,
        lat = 35,
        brightness = 1.9,
        exposure = 0,
        bodies = false,
        ambient = fromRGB(130, 136, 148),
        outdoor = fromRGB(136, 144, 158),
        atmos = {
            Density = 0.4,
            Offset = 0.1,
            Glare = 0,
            Haze = 2.2,
            Color = fromRGB(178, 186, 198),
            Decay = fromRGB(136, 146, 162)
        },
        clouds = {
            Cover = 0.86,
            Density = 0.7,
            Color = fromRGB(160, 166, 176)
        }
    },
    snow = {
        clock = 13.5,
        lat = 35,
        brightness = 1.9,
        exposure = 0.05,
        bodies = false,
        ambient = fromRGB(176, 186, 202),
        outdoor = fromRGB(188, 198, 214),
        atmos = {
            Density = 0.44,
            Offset = 0.15,
            Glare = 0,
            Haze = 2.6,
            Color = fromRGB(226, 236, 246),
            Decay = fromRGB(186, 202, 224)
        },
        clouds = {
            Cover = 0.8,
            Density = 0.55,
            Color = fromRGB(236, 241, 248)
        }
    },
    storm = {
        clock = 13.5,
        lat = 35,
        brightness = 1.7,
        exposure = 0,
        bodies = false,
        ambient = fromRGB(112, 118, 136),
        outdoor = fromRGB(120, 128, 148),
        atmos = {
            Density = 0.42,
            Offset = 0.05,
            Glare = 0,
            Haze = 2.4,
            Color = fromRGB(150, 156, 170),
            Decay = fromRGB(100, 106, 124)
        },
        clouds = {
            Cover = 0.9,
            Density = 0.8,
            Color = fromRGB(128, 134, 148)
        }
    },
    aurora = {
        clock = 22.5,
        lat = -50,
        brightness = 1.6,
        exposure = 0.3,
        bodies = false,
        stars = 6000,
        aurora = true,
        ambient = fromRGB(82, 110, 122),
        outdoor = fromRGB(92, 132, 138),
        atmos = {
            Density = 0.22,
            Offset = 0,
            Glare = 0,
            Haze = 0.5,
            Color = fromRGB(50, 84, 104),
            Decay = fromRGB(30, 110, 100)
        }
    },
    meteor = {
        clock = 17.55,
        lat = -50,
        brightness = 1.9,
        exposure = 0.05,
        bodies = true,
        stars = 3000,
        ambient = fromRGB(156, 118, 110),
        outdoor = fromRGB(176, 128, 112),
        atmos = {
            Density = 0.32,
            Offset = 0.1,
            Glare = 0.8,
            Haze = 1.6,
            Color = fromRGB(255, 168, 120),
            Decay = fromRGB(196, 88, 96)
        },
        clouds = {
            Cover = 0.45,
            Density = 0.35,
            Color = fromRGB(255, 176, 140)
        }
    },
    bloodmoon = {
        clock = 22.5,
        lat = -50,
        brightness = 1.6,
        exposure = 0.35,
        bodies = true,
        stars = 2000,
        moon = "rbxassetid://82955550930247",
        moonSize = 34,
        ambient = fromRGB(150, 86, 92),
        outdoor = fromRGB(176, 96, 102),
        atmos = {
            Density = 0.34,
            Offset = 0.05,
            Glare = 0.4,
            Haze = 1.4,
            Color = fromRGB(140, 34, 46),
            Decay = fromRGB(90, 14, 26)
        },
        clouds = {
            Cover = 0.35,
            Density = 0.4,
            Color = fromRGB(120, 40, 48)
        }
    },
    eclipse = {
        clock = 22.5,
        lat = -50,
        brightness = 1.6,
        exposure = 0.35,
        bodies = true,
        stars = 5000,
        moon = "rbxassetid://103264914026249",
        moonSize = 40,
        ambient = fromRGB(128, 116, 166),
        outdoor = fromRGB(140, 128, 182),
        atmos = {
            Density = 0.28,
            Offset = 0,
            Glare = 0,
            Haze = 0.8,
            Color = fromRGB(70, 56, 112),
            Decay = fromRGB(40, 22, 84)
        }
    }
}
local v19 = GameConfig.WATER_Y - 0.5
local t5, Sky
local Atmosphere = nil
local Clouds = nil
local v20, NumberValue, v21
local n3 = 0
local t6 = {}
local v22 = false
local v23 = false

local function readBaseSky() -- line: 175
    -- upvalues: Lighting (copy), t5 (ref), Sky (ref), NumberValue (ref)
    Sky = Lighting:FindFirstChildOfClass("Sky")
    t5 = {
        clock = Lighting.ClockTime,
        lat = Lighting.GeographicLatitude,
        brightness = Lighting.Brightness,
        exposure = Lighting.ExposureCompensation,
        ambient = Lighting.Ambient,
        outdoor = Lighting.OutdoorAmbient,
        bodies = not Sky or Sky.CelestialBodiesShown,
        stars = if Sky then Sky.StarCount else 3000,
        moon = if Sky then Sky.MoonTextureId else "",
        moonSize = if Sky then Sky.MoonAngularSize else 11
    }
    NumberValue = Instance.new("NumberValue")

    local NumberValue2 = NumberValue

    NumberValue2.Value = t5.clock
    NumberValue.Changed:Connect(function(p8) -- line: 187
        -- upvalues: Lighting (copy)
        Lighting.ClockTime = p8 % 24
    end)
end

local function makeAurora() -- line: 193
    -- upvalues: fromRGB (copy)
    local Part = Instance.new("Part")

    Part.Name = "Aurora"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part:SetAttribute("NoStuds", true)

    local t8 = {}
    local t9 = {
        {
            z = -900,
            y = 330,
            w = 260,
            x = 720,
            a = fromRGB(90, 255, 170),
            b = fromRGB(60, 230, 255),
            c = fromRGB(150, 110, 255)
        },
        {
            z = -1100,
            y = 420,
            w = 220,
            x = 900,
            a = fromRGB(70, 255, 200),
            b = fromRGB(110, 255, 140),
            c = fromRGB(70, 200, 255)
        },
        {
            z = -760,
            y = 270,
            w = 170,
            x = 560,
            a = fromRGB(180, 120, 255),
            b = fromRGB(90, 255, 180),
            c = fromRGB(80, 255, 220)
        }
    }

    for v24, v25 in ipairs(t9) do
        local Attachment = Instance.new("Attachment")

        Attachment.Position = Vector3.new(-v25.x, v25.y, v25.z)
        Attachment.Parent = Part

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(v25.x, v25.y + 40, v25.z - 120)
        Attachment2.Parent = Part

        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.FaceCamera = true
        Beam.Segments = 48
        Beam.Width0 = v25.w * 1.6
        Beam.Width1 = v25.w * 1.35
        Beam.Texture = "rbxassetid://116698834800312"
        Beam.TextureMode = Enum.TextureMode.Wrap
        Beam.TextureLength = 340
        Beam.TextureSpeed = 0.03 + v24 * 0.012
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.Brightness = 0
        Beam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v25.a),
            ColorSequenceKeypoint.new(0.5, v25.b),
            ColorSequenceKeypoint.new(1, v25.c)
        })
        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0.35),
            NumberSequenceKeypoint.new(0.8, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Parent = Part
        t8[v24] = Beam
    end

    Part.Parent = workspace

    return {
        rig = Part,
        beams = t8
    }
end

local function stopLight() -- line: 240
    -- upvalues: t6 (copy)
    for _, v29 in ipairs(t6) do
        v29:Cancel()
    end

    table.clear(t6)
end

local function blendLight(p9, p10) -- line: 248
    -- upvalues: Lighting (copy), TweenService (copy), t5 (ref), Sky (ref), NumberValue (ref), n3 (ref), t6 (copy), v22 (ref), v23 (ref)
    if v23 and p10 > 0 then
        return
    end

    for _, v30 in ipairs(t6) do
        v30:Cancel()
    end

    table.clear(t6)

    local v31 = n3
    local t10 = {
        GeographicLatitude = p9.lat,
        Brightness = p9.brightness,
        ExposureCompensation = p9.exposure,
        Ambient = p9.ambient,
        OutdoorAmbient = p9.outdoor
    }
    local v32 = NumberValue.Value % 24
    local v33 = (p9.clock - v32) % 24
    local v34 = if v33 <= 16 then v32 + v33 else v32 - (24 - v33)

    if p10 <= 0 then
        local NumberValue2 = NumberValue

        NumberValue2.Value = p9.clock

        for v35, v36 in pairs(t10) do
            Lighting[v35] = v36
        end

        if Sky then
            local Sky2 = Sky

            Sky2.StarCount = p9.stars or t5.stars

            local Sky3 = Sky

            Sky3.MoonAngularSize = p9.moonSize or t5.moonSize

            local Sky4 = Sky

            Sky4.CelestialBodiesShown = p9.bodies ~= false

            local Sky5 = Sky

            Sky5.MoonTextureId = p9.moon or t5.moon
        end
    else
        local v37 = TweenInfo.new(p10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        NumberValue.Value = v32

        local t11 = {
            TweenService:Create(NumberValue, v37, {
                Value = v34
            }),
            TweenService:Create(Lighting, v37, t10)
        }

        if Sky then
            local Sky2 = Sky

            table.insert(t11, TweenService:Create(Sky2, v37, {
                StarCount = p9.stars or t5.stars,
                MoonAngularSize = p9.moonSize or t5.moonSize
            }))
            task.delay(p10 * 0.5, function() -- line: 282
                -- upvalues: p9 (copy), v31 (copy), t5 (ref), Sky (ref), n3 (ref), v22 (ref)
                local Sky2, v38

                if n3 ~= v31 or v22 then
                    return
                else
                    Sky2 = Sky
                    v38 = p9.bodies ~= false
                end

                Sky2.CelestialBodiesShown = v38
                Sky.MoonTextureId = p9.moon or t5.moon
            end)
        end

        for _, v40 in ipairs(t11) do
            table.insert(t6, v40)
            v40:Play()
        end
    end
end

local function setSky(p11) -- line: 295
    -- upvalues: Lighting (copy), TweenService (copy), t4 (copy), t5 (ref), Atmosphere (ref), Clouds (ref), v20 (ref), v21 (ref), n3 (ref), v22 (ref), makeAurora (copy), blendLight (copy)
    local v41, v42, v43, v44

    if p11 == v21 then
        v44 = true
    elseif t5 then
        v21 = p11
        n3 += 1
        v41 = n3
        v42 = t4[p11 or ""]
        v43 = if v42 then 5 else 7
        v44 = false
    else
        v44 = true
    end

    if v44 then
        return
    end

    local v45 = TweenInfo.new(v43, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

    if not v22 then
        blendLight(v42 or t5, v43)
    end

    if v42 and v42.atmos then
        if not Atmosphere then
            Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Name = "EventAtmosphere"
            Atmosphere.Density = 0
            Atmosphere.Offset = 0
            Atmosphere.Haze = 0
            Atmosphere.Glare = 0
            Atmosphere.Parent = Lighting
        end

        TweenService:Create(Atmosphere, v45, v42.atmos):Play()
    elseif Atmosphere then
        local Atmosphere2 = Atmosphere
        local tween = TweenService:Create(Atmosphere2, v45, {
            Density = 0,
            Haze = 0,
            Glare = 0,
            Offset = 0
        })

        tween:Play()

        local Completed = tween.Completed
        local v46 = v41

        Completed:Once(function() -- line: 325
            -- upvalues: Atmosphere2 (copy), v46 (copy), Atmosphere (ref), n3 (ref)
            if n3 == v46 and Atmosphere == Atmosphere2 then
                Atmosphere = nil
                Atmosphere2:Destroy()
            end
        end)
    end

    if v42 and v42.clouds then
        if not Clouds then
            Clouds = Instance.new("Clouds")
            Clouds.Name = "EventClouds"
            Clouds.Cover = 0
            Clouds.Density = 0

            local Clouds2 = Clouds

            Clouds2.Parent = workspace.Terrain
        end

        TweenService:Create(Clouds, v45, v42.clouds):Play()
    elseif Clouds then
        local Clouds2 = Clouds
        local tween = TweenService:Create(Clouds2, v45, {
            Cover = 0,
            Density = 0
        })

        tween:Play()

        local Completed = tween.Completed
        local v47 = v41

        Completed:Once(function() -- line: 345
            -- upvalues: Clouds2 (copy), v47 (copy), Clouds (ref), n3 (ref)
            if n3 == v47 and Clouds == Clouds2 then
                Clouds = nil
                Clouds2:Destroy()
            end
        end)
    end

    if v42 and v42.aurora then
        v20 = v20 or makeAurora()

        for _, v48 in ipairs(v20.beams) do
            TweenService:Create(v48, TweenInfo.new(v43 * 1.4, Enum.EasingStyle.Sine), {
                Brightness = 1.1
            }):Play()
        end
    elseif v20 then
        local v49 = v20

        v20 = nil

        for _, v50 in ipairs(v49.beams) do
            TweenService:Create(v50, TweenInfo.new(v43 * 0.5), {
                Brightness = 0
            }):Play()
        end

        task.delay(v43 * 0.5 + 0.1, function() -- line: 363
            -- upvalues: v49 (copy)
            v49.rig:Destroy()
        end)
    end
end

t1.SkyShown = function() -- line: 368
    -- upvalues: v21 (ref)
    return v21
end

t1.HoldSky = function() -- line: 373
    -- upvalues: t6 (copy), v23 (ref)
    for _, v51 in ipairs(t6) do
        v51:Cancel()
    end

    table.clear(t6)
    v23 = true
end

t1.ReleaseSky = function(p12) -- line: 378
    -- upvalues: t4 (copy), t5 (ref), v21 (ref), v22 (ref), v23 (ref), blendLight (copy)
    v23 = false

    local blendLight2, v52

    if t5 and not v22 then
        blendLight2 = blendLight
        v52 = t4[v21 or ""] or t5
        blendLight2(v52, p12 or 2)
    end
end

t1.LightGoal = function() -- line: 386
    -- upvalues: t4 (copy), t5 (ref), v21 (ref)
    return t4[v21 or ""] or t5
end

local function stop() -- line: 391
    -- upvalues: TweenService (copy), UIKit (copy), SoundPlayer (copy), t1 (copy), v2 (ref), Part (ref), ColorCorrectionEffect (ref), v7 (ref), n2 (ref), v10 (ref), v11 (ref), setSky (copy)
    n2 += 1
    v7 = nil
    t1.Active = nil

    if v10 ~= nil then
        if v10 then
            SoundPlayer.Stop(v10, 1.5)
        end

        v10 = nil
    end

    setSky(nil)

    if v11 then
        v11:Stop()
    end

    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2.5), {
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    }):Play()

    for _, child in ipairs(Part:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false
        end
    end

    local v53 = UIKit.scaleOf(v2)
    local v54 = UIKit.tween(v53, 0.2, {
        Scale = 0
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v55 = n2

    v54.Completed:Once(function() -- line: 409
        -- upvalues: v55 (copy), v2 (ref), Part (ref), n2 (ref)
        if n2 ~= v55 then
            return
        end

        v2.Visible = false
        Part:ClearAllChildren()
    end)
end

local function start(p13) -- line: 417
    -- upvalues: TweenService (copy), UIKit (copy), Toasts (copy), DataClient (copy), HUD (copy), AdminAbuseFx (copy), t1 (copy), v2 (ref), UIStroke (ref), v3 (ref), v5 (ref), ColorCorrectionEffect (ref), v7 (ref), n1 (ref), v8 (ref), n2 (ref), v11 (ref), startWeather (copy), v22 (ref), setSky (copy)
    n2 += 1

    local v56 = n2

    v7 = p13
    t1.Active = p13.id
    startWeather(p13)

    if v11 then
        v11:Destroy()
        v11 = nil
    end

    if p13.fx.kit then
        v11 = AdminAbuseFx.new(p13)
    end

    if (DataClient.Get("Settings") or {}).Weather ~= false then
        if not v22 then
            local ColorCorrectionEffect2 = ColorCorrectionEffect

            TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(2.5), {
                TintColor = p13.fx.tint or Color3.new(1, 1, 1),
                Brightness = p13.fx.brightness or 0,
                Saturation = p13.fx.saturation or 0
            }):Play()
        end

        setSky(if p13.fx.kit then nil else p13.id)
    end

    UIKit.sound("EventStart")

    local v58 = v3

    v58.Text = p13.icon .. " " .. string.upper(p13.name)

    local v59 = v3

    v59.TextColor3 = p13.Color

    local UIStroke2 = UIStroke

    UIStroke2.Color = p13.Color

    local v60 = v5
    local Color = p13.Color

    v60.Text = ("Fish in your pen may turn <font color=\"%s\">%s</font>  (x%d cash)"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(p13.mutation), p13.mult)
    v2.Visible = true
    n1 = os.clock() + 6
    v8 = false
    UIKit.scaleOf(v2).Scale = 1
    UIKit.pop(v2, 1.5)
    Toasts.Show("info", p13.icon .. " " .. p13.name .. " has started!")

    if p13.fx.flashes then
        task.spawn(function() -- line: 450
            -- upvalues: p13 (copy), v56 (copy), TweenService (copy), UIKit (copy), DataClient (copy), HUD (copy), ColorCorrectionEffect (ref), n2 (ref)
            local v66 = Random.new()

            while n2 == v56 do
                task.wait(v66:NextNumber(5, 11))

                if n2 ~= v56 then
                    break
                end

                if HUD.GetMode() ~= "cutscene" then
                    UIKit.sound("Thunder")
                end

                if HUD.GetMode() ~= "cutscene" and (DataClient.Get("Settings") or {}).Weather ~= false then
                    ColorCorrectionEffect.Brightness = 0.35
                    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.5), {
                        Brightness = p13.fx.brightness or 0
                    }):Play()
                    task.wait(0.16)

                    if n2 == v56 then
                        ColorCorrectionEffect.Brightness = 0.18
                        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.7), {
                            Brightness = p13.fx.brightness or 0
                        }):Play()
                    end
                end
            end
        end)
    end
end

local function refresh() -- line: 475
    -- upvalues: Events (copy), v7 (ref), stop (copy), start (copy)
    local v67 = Events.ById[workspace:GetAttribute("EventId") or ""]

    if v67 ~= v7 then
        if v67 then
            start(v67)
        else
            stop()
        end
    end
end

local function fishName(p14) -- line: 488
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy)
    local v68 = Variants.List[p14.v] or Variants.List[1]
    local v69 = Sizes.List[p14.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local v70 = if v68.index >= 2 then v68.id .. " " else ""

    if v69.index ~= Sizes.NORMAL_INDEX then
        v70 ..= v69.id .. " "
    end

    local v71 = Fish.ById[p14.fishId]

    return v70 .. (if v71 then v71.name else "fish")
end

local function showCard(p15) -- line: 502
    -- upvalues: Events (copy), Fish (copy), Rarities (copy), NumberFormat (copy), FishModels (copy), UIKit (copy), t1 (copy), Colors (copy), v6 (ref), fishName (copy)
    local v72 = Events.ById[p15.e]
    local v73 = Fish.ById[p15.fishId]

    if not (v72 and v73) then
        return
    end

    t1.CardsShown += 1
    v6:ClearAllChildren()

    local v74 = UIKit.frame(v6, {
        Name = "Card",
        Corner = 20,
        Stroke = 6,
        Size = UDim2.fromOffset(760, 112),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.Dark,
        StrokeColor = v72.Color
    })
    local v75 = Rarities.ById[v73.rarity]
    local v76 = UIKit.frame(v74, {
        Name = "Tile",
        Corner = 12,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(88, 88),
        Position = UDim2.fromOffset(12, 12),
        Color = v75.Color,
        Color2 = v75.Color2
    })
    local v77 = UIKit.frame(v76, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 2,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.fromOffset(3, 3)
    })

    if p15.more then
        UIKit.text(v76, {
            Name = "More",
            TextSize = 44,
            Stroke = 5,
            ZIndex = 4,
            Text = "+" .. p15.more
        })
    else
        FishModels.Picture(v77, p15.fishId, p15.v, false)
    end

    local v78

    if p15.more then
        local icon = v72.icon
        local Gold = Colors.Gold
        local v84 = string.format("#%02X%02X%02X", math.floor(Gold.R * 255 + 0.5), math.floor(Gold.G * 255 + 0.5), (math.floor(Gold.B * 255 + 0.5)))
        local more = p15.more
        local Color = v72.Color

        v78 = ("%s <font color=\"%s\">%d more fish</font> got <font color=\"%s\">%s!</font>"):format(icon, v84, more, string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v72.mutation))
    else
        local icon = v72.icon
        local Gold = Colors.Gold
        local v95 = string.format("#%02X%02X%02X", math.floor(Gold.R * 255 + 0.5), math.floor(Gold.G * 255 + 0.5), (math.floor(Gold.B * 255 + 0.5)))
        local v96 = fishName(p15)
        local Color = v72.Color

        v78 = ("%s Your <font color=\"%s\">%s</font> got <font color=\"%s\">%s!</font>"):format(icon, v95, v96, string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v72.mutation))
    end

    local v102 = UIKit.text(v74, {
        Name = "Line1",
        Stroke = 4,
        ZIndex = 3,
        Text = v78,
        Size = UDim2.new(1, -128, 0, 46),
        Position = UDim2.fromOffset(114, 10),
        XAlign = Enum.TextXAlignment.Left
    })

    v102.RichText = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 36
    UITextSizeConstraint.Parent = v102

    local v103 = if p15.more then ("x%d cash from each of them"):format(v72.mult) else ("x%d cash   >   %s"):format(v72.mult, NumberFormat.rate(p15.income or 0))

    UIKit.text(v74, {
        Name = "Line2",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 3,
        Text = v103,
        Size = UDim2.new(1, -128, 0, 38),
        Position = UDim2.fromOffset(114, 60),
        XAlign = Enum.TextXAlignment.Left,
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    UIKit.pop(v74, 0.5)
    UIKit.sound("EventMutate")
    task.wait(3.2)
    UIKit.tween(UIKit.scaleOf(v74), 0.18, {
        Scale = 0
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Wait()
    v74:Destroy()
end

local function pump() -- line: 539
    -- upvalues: HUD (copy), t2 (copy), v9 (ref), showCard (copy)
    if not v9 then
        v9 = true
        task.spawn(function() -- line: 544
            -- upvalues: HUD (copy), t2 (copy), v9 (ref), showCard (copy)
            while #t2 > 0 do
                while HUD.GetMode() == "cutscene" do
                    task.wait(0.3)
                end

                local v104 = table.remove(t2, 1)
                local ok, result = pcall(showCard, v104)

                if not ok then
                    warn("[EventFx] " .. tostring(result))
                end
            end

            v9 = false
        end)
    end
end

local function onMutated(p16) -- line: 560
    -- upvalues: HUD (copy), t2 (copy), v9 (ref), showCard (copy)
    if type(p16) ~= "table" then
        return
    end

    table.sort(p16, function(p17, p18) -- line: 565
        return (p17.income or 0) > (p18.income or 0)
    end)

    for v105, v106 in ipairs(p16) do
        if v105 <= 3 then
            table.insert(t2, v106)
        end
    end

    if #p16 > 3 then
        table.insert(t2, {
            v = 1,
            s = 1,
            more = #p16 - 3,
            e = p16[1].e,
            fishId = p16[1].fishId
        })
    end

    if not v9 then
        v9 = true
        task.spawn(function() -- line: 544
            -- upvalues: HUD (copy), t2 (copy), v9 (ref), showCard (copy)
            while #t2 > 0 do
                while HUD.GetMode() == "cutscene" do
                    task.wait(0.3)
                end

                local v107 = table.remove(t2, 1)
                local ok, result = pcall(showCard, v107)

                if not ok then
                    warn("[EventFx] " .. tostring(result))
                end
            end

            v9 = false
        end)
    end
end

function t1.Init() -- line: 580
    -- upvalues: RunService (copy), Lighting (copy), TweenService (copy), Remotes (copy), UIKit (copy), Sounds (copy), SoundPlayer (copy), DataClient (copy), HUD (copy), Colors (copy), v1 (ref), v2 (ref), UIStroke (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), Part (ref), ColorCorrectionEffect (ref), v7 (ref), n1 (ref), v8 (ref), v10 (ref), v11 (ref), setWeatherEnabled (copy), t4 (copy), v19 (copy), t5 (ref), Atmosphere (ref), Clouds (ref), v20 (ref), v21 (ref), v22 (ref), v23 (ref), readBaseSky (copy), blendLight (copy), setSky (copy), refresh (copy), onMutated (copy)
    v1 = UIKit.screenGui("EventHUD", 6)
    v2 = UIKit.frame(v1, {
        Name = "Banner",
        Corner = 28,
        Stroke = 5,
        Size = UDim2.fromOffset(600, 56),
        Position = UDim2.new(0.5, 0, 0, 12),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Dark
    })
    UIStroke = v2:FindFirstChildOfClass("UIStroke")
    require(script.Parent.BannerDodge).new(v2)
    v3 = UIKit.text(v2, {
        Name = "Title",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.fromOffset(24, 0),
        XAlign = Enum.TextXAlignment.Left
    })
    v4 = UIKit.text(v2, {
        Name = "Time",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(120, 56),
        Position = UDim2.new(1, -22, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right
    })
    v5 = UIKit.text(v2, {
        Name = "Sub",
        Text = "",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(900, 26),
        Position = UDim2.new(0.5, 0, 1, 6),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v5.RichText = true
    v2.Visible = false
    v6 = UIKit.frame(v1, {
        Name = "Mutations",
        Transparency = 1,
        Size = UDim2.fromOffset(780, 130),
        Position = UDim2.fromScale(0.5, 0.74),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local Position = v6.Position

    RunService.RenderStepped:Connect(function() -- line: 592
        -- upvalues: Position (copy), v1 (ref), v6 (ref)
        local Held = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Held")

        Held = Held and Held.Enabled and Held:FindFirstChild("Panel")

        local v108

        if Held and Held.Visible and #v6:GetChildren() > 0 then
            local UIScale = v1:FindFirstChildOfClass("UIScale")
            local v109 = if UIScale and UIScale.Scale > 0 then UIScale.Scale else 1
            local v110 = Held.AbsolutePosition.Y - 14 * v109

            if v110 < v1.AbsoluteSize.Y * Position.Y.Scale + v6.AbsoluteSize.Y / 2 then
                local v111 = v110 - v6.AbsoluteSize.Y / 2

                v108 = UDim2.new(0.5, 0, 0, v111 / v109)
            else
                v108 = Position
            end
        else
            v108 = Position
        end

        if v6.Position ~= v108 then
            v6.Position = v108
        end
    end)
    Part = Instance.new("Part")
    Part.Name = "EventSky"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(80, 44, 80)
    Part:SetAttribute("NoStuds", true)
    Part.Parent = workspace
    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "EventTint"
    ColorCorrectionEffect.Parent = Lighting
    readBaseSky()

    local v112

    RunService.RenderStepped:Connect(function(p19) -- line: 630
        -- upvalues: v112 (ref), Lighting (copy), TweenService (copy), UIKit (copy), Sounds (copy), SoundPlayer (copy), DataClient (copy), HUD (copy), v2 (ref), v4 (ref), Part (ref), ColorCorrectionEffect (ref), v7 (ref), n1 (ref), v8 (ref), v10 (ref), v11 (ref), setWeatherEnabled (copy), t4 (copy), v19 (copy), t5 (ref), Atmosphere (ref), Clouds (ref), v20 (ref), v21 (ref), v22 (ref), v23 (ref), blendLight (copy)
        local v113 = HUD.GetMode() == "cutscene"

        v112 = v112 or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Reveal")

        local v114 = workspace.CurrentCamera.CFrame.Position.Y < v19 or v112 ~= nil and v112.Enabled
        local v115 = v114 or v23

        if Clouds then
            Clouds.Enabled = not v115
        end

        if v20 then
            for _, v116 in ipairs(v20.beams) do
                v116.Enabled = not v115
            end
        end

        if v114 ~= v22 then
            v22 = v114

            if v114 then
                blendLight(t5, 0)

                local ColorCorrectionEffect2 = ColorCorrectionEffect
                local ColorCorrectionEffect3 = ColorCorrectionEffect
                local ColorCorrectionEffect4 = ColorCorrectionEffect

                ColorCorrectionEffect2.TintColor = Color3.new(1, 1, 1)
                ColorCorrectionEffect3.Brightness = 0
                ColorCorrectionEffect4.Saturation = 0
            elseif v21 then
                blendLight(t4[v21] or t5, 1.5)

                if v7 and (DataClient.Get("Settings") or {}).Weather ~= false then
                    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.5), {
                        TintColor = v7.fx.tint or Color3.new(1, 1, 1),
                        Brightness = v7.fx.brightness or 0,
                        Saturation = v7.fx.saturation or 0
                    }):Play()
                end
            end
        end

        if Atmosphere and Atmosphere.Parent == nil ~= v115 then
            local Atmosphere2 = Atmosphere

            if v115 then
                Atmosphere2.Parent = nil
            else
                Atmosphere2.Parent = Lighting
            end
        end

        if v20 then
            local CFramePosition = workspace.CurrentCamera.CFrame.Position

            v20.rig.CFrame = CFrame.new(CFramePosition.X, CFramePosition.Y * 0.2, CFramePosition.Z)

            local elapsed = os.clock()

            for v119, v120 in ipairs(v20.beams) do
                v120.CurveSize0 = math.sin(elapsed * 0.23 + v119 * 1.7) * 260
                v120.CurveSize1 = math.sin(elapsed * 0.17 + v119 * 2.3 + 1) * 260
            end
        end

        if v11 and not v11:Step(p19, v114 or v23 or v113 or (DataClient.Get("Settings") or {}).Weather == false, workspace.CurrentCamera) then
            v11 = nil
        end

        if not v7 then
            return
        end

        local CurrentCamera = workspace.CurrentCamera
        local LookVector = CurrentCamera.CFrame.LookVector
        local v124 = Vector3.new(LookVector.X, 0, LookVector.Z)

        if v124.Magnitude > 0.01 then
            v124 = v124.Unit
        end

        Part.CFrame = CFrame.new(CurrentCamera.CFrame.Position + v124 * 26 + Vector3.new(0, 12, 0))
        setWeatherEnabled(not v113 and (DataClient.Get("Settings") or {}).Weather ~= false)

        local v126 = if v113 then nil else Sounds.EventLoop[v7.id]

        if v126 ~= v10 then
            if v10 then
                SoundPlayer.Stop(v10, 1.5)
            end

            v10 = v126

            if v126 then
                SoundPlayer.Play(v126)
            end
        end

        if os.clock() < n1 then
            v2.Visible = not v113
        elseif v113 then
            v2.Visible = false
        elseif v2.Visible and not v8 then
            v8 = true
            UIKit.tween(UIKit.scaleOf(v2), 0.25, {
                Scale = 0
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Once(function() -- line: 697
                -- upvalues: v2 (ref), n1 (ref), v8 (ref)
                if os.clock() >= n1 then
                    v2.Visible = false
                end

                v8 = false
            end)
        end

        local v129 = math.max(0, (workspace:GetAttribute("EventEnds") or 0) - workspace:GetServerTimeNow())

        v4.Text = string.format("%d:%02d", math.floor(v129 / 60), (math.floor(v129 % 60)))
    end)
    workspace:GetAttributeChangedSignal("EventId"):Connect(refresh)
    DataClient.Observe("Settings", function() -- line: 710
        -- upvalues: TweenService (copy), DataClient (copy), ColorCorrectionEffect (ref), v7 (ref), setSky (copy)
        if not v7 then
            return
        end

        local v134 = (DataClient.Get("Settings") or {}).Weather ~= false

        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.6), {
            TintColor = v134 and v7.fx.tint or Color3.new(1, 1, 1),
            Brightness = v134 and v7.fx.brightness or 0,
            Saturation = v134 and v7.fx.saturation or 0
        }):Play()
        setSky(if not v134 or v7.fx.kit then nil else v7.id)
    end)
    task.defer(refresh)
    Remotes:WaitForChild("FishMutated").OnClientEvent:Connect(onMutated)
end

return t1

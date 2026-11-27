-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Terrain = workspace.Terrain
local t1 = {
    fogColor = Lighting.FogColor,
    fogStart = Lighting.FogStart,
    fogEnd = Lighting.FogEnd,
    waterColor = Terrain.WaterColor,
    waterTransparency = Terrain.WaterTransparency,
    ambient = Lighting.Ambient,
    outdoorAmbient = Lighting.OutdoorAmbient,
    exposure = Lighting.ExposureCompensation
}
local t2 = {
    IN = 1.2,
    OUT = 0.7,
    SURFACE = 7.5,
    FOG_START = 20,
    FOG_END = 0.7,
    CLARITY = 0.7,
    EXPOSURE = -0.55,
    SATURATION = -0.25,
    CONTRAST = 0.18,
    BRIGHTNESS = -0.02,
    FOG = Color3.fromRGB(14, 26, 48),
    WATER = Color3.fromRGB(8, 36, 52),
    AMBIENT = Color3.fromRGB(62, 66, 104),
    TINT = Color3.fromRGB(175, 185, 255)
}
local UnderwaterCC = Lighting:FindFirstChild("UnderwaterCC")
local v1 = UnderwaterCC

if not UnderwaterCC then
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    v1 = ColorCorrectionEffect
    ColorCorrectionEffect.Name = "UnderwaterCC"
    ColorCorrectionEffect.Enabled = false
    ColorCorrectionEffect.Parent = Lighting
end

local UnderwaterZone = CollectionService:GetTagged("UnderwaterZone")

CollectionService:GetInstanceAddedSignal("UnderwaterZone"):Connect(function(p1) -- line: 90
    -- upvalues: UnderwaterZone (copy)
    table.insert(UnderwaterZone, p1)
end)
CollectionService:GetInstanceRemovedSignal("UnderwaterZone"):Connect(function(p2) -- line: 93
    -- upvalues: UnderwaterZone (copy)
    local v2 = table.find(UnderwaterZone, p2)

    if v2 then
        table.remove(UnderwaterZone, v2)
    end
end)

local function pointInPart(p3, p4) -- line: 98
    local v3 = p3.CFrame:PointToObjectSpace(p4)
    local v4 = p3.Size / 2

    if math.abs(v3.X) <= v4.X then
        if not (math.abs(v3.Y) <= v4.Y) then
            return false
        end

        return math.abs(v3.Z) <= v4.Z
    end

    return false
end

local function zoneAt(p5) -- line: 104
    -- upvalues: UnderwaterZone (copy)
    for _, v5 in ipairs(UnderwaterZone) do
        if v5:IsA("BasePart") and v5.Parent then
            local v6 = v5.CFrame:PointToObjectSpace(p5)
            local v7 = v5.Size / 2

            if math.abs(v6.X) <= v7.X and math.abs(v6.Y) <= v7.Y and math.abs(v6.Z) <= v7.Z then
                return v5
            end
        end
    end

    return nil
end

local function lookOf(p6) -- line: 120
    -- upvalues: t1 (copy)
    local v8 = p6:GetAttribute("FogColor") or Color3.fromRGB(12, 62, 110)

    return {
        fogColor = v8,
        fogStart = p6:GetAttribute("FogStart") or 15,
        fogEnd = p6:GetAttribute("FogEnd") or 150,
        waterColor = p6:GetAttribute("WaterColor") or v8,
        waterTransparency = p6:GetAttribute("WaterClarity") or 0.45,
        tintColor = p6:GetAttribute("TintColor") or Color3.fromRGB(160, 205, 255),
        saturation = p6:GetAttribute("TintSaturation") or -0.15,
        contrast = p6:GetAttribute("TintContrast") or 0,
        ambient = p6:GetAttribute("Ambient") or t1.ambient,
        outdoorAmbient = p6:GetAttribute("OutdoorAmbient") or t1.outdoorAmbient
    }
end

local function deepShare(p7, p8) -- line: 137
    local DeepFrom = p7:GetAttribute("DeepFrom")
    local DeepFull = p7:GetAttribute("DeepFull")

    if type(DeepFrom) ~= "number" or type(DeepFull) ~= "number" or typeof(p7:GetAttribute("DeepColor")) ~= "Color3" then
        return 0
    end

    local v12 = math.clamp(((p7.Position.Y + p7.Size.Y / 2 - p8) / p7.Size.Y - DeepFrom) / math.max(DeepFull - DeepFrom, 0.001), 0, 1)

    return v12 * v12 * (3 - v12 * 2)
end

local function deepen(p9, p10, p11) -- line: 146
    local DeepColor = p9:GetAttribute("DeepColor")

    p10.fogColor = p10.fogColor:Lerp(DeepColor, p11)
    p10.waterColor = p10.waterColor:Lerp(DeepColor, p11)

    local DeepClarity = p9:GetAttribute("DeepClarity")

    if type(DeepClarity) == "number" then
        p10.waterTransparency += (DeepClarity - p10.waterTransparency) * p11
    end

    local DeepAmbient = p9:GetAttribute("DeepAmbient")

    if typeof(DeepAmbient) == "Color3" then
        p10.ambient = p10.ambient:Lerp(DeepAmbient, p11)
        p10.outdoorAmbient = p10.outdoorAmbient:Lerp(DeepAmbient, p11)
    end

    local DeepTint = p9:GetAttribute("DeepTint")

    if typeof(DeepTint) == "Color3" then
        p10.tintColor = p10.tintColor:Lerp(DeepTint, p11)
    end
end

local t4 = {
    saturation = 0,
    contrast = 0,
    fogColor = t1.fogColor,
    fogStart = t1.fogStart,
    fogEnd = t1.fogEnd,
    waterColor = t1.waterColor,
    waterTransparency = t1.waterTransparency,
    tintColor = Color3.new(1, 1, 1),
    ambient = t1.ambient,
    outdoorAmbient = t1.outdoorAmbient
}

local function blend(p12, p13, p14) -- line: 180
    local function n(p15, p16) -- line: 181
        -- upvalues: p14 (copy)
        return p15 + (p16 - p15) * p14
    end

    local t5 = {
        fogColor = p12.fogColor:Lerp(p13.fogColor, p14)
    }
    local fogStart = p12.fogStart

    t5.fogStart = fogStart + (p13.fogStart - fogStart) * p14

    local fogEnd = p12.fogEnd

    t5.fogEnd = fogEnd + (p13.fogEnd - fogEnd) * p14
    t5.waterColor = p12.waterColor:Lerp(p13.waterColor, p14)

    local waterTransparency = p12.waterTransparency

    t5.waterTransparency = waterTransparency + (p13.waterTransparency - waterTransparency) * p14
    t5.tintColor = p12.tintColor:Lerp(p13.tintColor, p14)

    local saturation = p12.saturation

    t5.saturation = saturation + (p13.saturation - saturation) * p14

    local contrast = p12.contrast

    t5.contrast = contrast + (p13.contrast - contrast) * p14
    t5.ambient = p12.ambient:Lerp(p13.ambient, p14)
    t5.outdoorAmbient = p12.outdoorAmbient:Lerp(p13.outdoorAmbient, p14)

    return t5
end

local function apply(p17) -- line: 196
    -- upvalues: Lighting (copy), Terrain (copy), v1 (ref)
    Lighting.FogColor = p17.fogColor
    Lighting.FogStart = p17.fogStart
    Lighting.FogEnd = p17.fogEnd
    Lighting.Ambient = p17.ambient
    Lighting.OutdoorAmbient = p17.outdoorAmbient
    Terrain.WaterColor = p17.waterColor
    Terrain.WaterTransparency = p17.waterTransparency

    local v13 = v1

    v13.TintColor = p17.tintColor
    v13.Saturation = p17.saturation
    v13.Contrast = p17.contrast
end

local function atSurface(p18) -- line: 210
    -- upvalues: t4 (copy)
    local fogColor = p18.fogColor
    local fogColor2 = t4.fogColor

    if not (math.abs(fogColor.R - fogColor2.R) < 0.004) then
        return false
    end

    if math.abs(fogColor.G - fogColor2.G) < 0.004 then
        if not (math.abs(fogColor.B - fogColor2.B) < 0.004) or not (math.abs(p18.fogEnd - t4.fogEnd) < 1) or not (math.abs(p18.saturation) < 0.004) then
            return false
        end

        return math.abs(p18.contrast) < 0.004
    end

    return false
end

local v18 = false
local _ = {
    DEEP = 0.85,
    UNDER = 0.8,
    CLARITY = 0.3,
    AMBIENT = 0.5
}
local WeatherUnderColor
local n1 = 0

local function readWeatherFog() -- line: 235
    -- upvalues: Lighting (copy), t1 (copy), t4 (copy), v18 (ref), WeatherUnderColor (ref), n1 (ref)
    local WeatherFog = Lighting:GetAttribute("WeatherFog")
    local v19 = type(WeatherFog) == "number" and math.clamp(WeatherFog, 0, 1) or 0
    local WeatherFogColor = Lighting:GetAttribute("WeatherFogColor")
    local WeatherFogStart = Lighting:GetAttribute("WeatherFogStart")
    local WeatherFogEnd = Lighting:GetAttribute("WeatherFogEnd")

    if v19 ~= 0 and typeof(WeatherFogColor) == "Color3" and type(WeatherFogStart) == "number" and type(WeatherFogEnd) == "number" then
        t4.fogColor = t1.fogColor:Lerp(WeatherFogColor, v19)
        t4.fogStart = t1.fogStart + (WeatherFogStart - t1.fogStart) * v19
        t4.fogEnd = t1.fogEnd + (WeatherFogEnd - t1.fogEnd) * v19
    else
        local fogColor, fogStart, fogEnd = t1.fogColor, t1.fogStart, t1.fogEnd

        t4.fogColor = fogColor
        t4.fogStart = fogStart
        t4.fogEnd = fogEnd
    end

    local WeatherWaterColor = Lighting:GetAttribute("WeatherWaterColor")
    local v20, v21

    if v19 > 0 and typeof(WeatherWaterColor) == "Color3" then
        local v22 = t1.waterColor:Lerp(WeatherWaterColor, v19)

        if v22 then
            v20 = v22
            v21 = true
        else
            v21 = false
        end
    else
        v21 = false
    end

    t4.waterColor = if not v21 then t1.waterColor else v20

    local WeatherUnderColor2 = Lighting:GetAttribute("WeatherUnderColor")

    if typeof(WeatherUnderColor2) ~= "Color3" or not WeatherUnderColor2 then
        WeatherUnderColor2 = nil
    end

    WeatherUnderColor = WeatherUnderColor2
    n1 = WeatherUnderColor and v19 * 0.6 or 0
    v18 = true
end

Lighting:GetAttributeChangedSignal("WeatherFog"):Connect(readWeatherFog)
readWeatherFog()

local v23
local LocalPlayer = game:GetService("Players").LocalPlayer
local FEAST_LOOK = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ThanksgivingConfig")).FEAST_LOOK
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

ColorCorrectionEffect.Name = "DreadCC"
ColorCorrectionEffect.Enabled = false
ColorCorrectionEffect.Parent = Lighting

local n2 = 0
local v24 = false
local v25 = false

local function darken(p19, p20) -- line: 274
    -- upvalues: t2 (copy)
    local function n(p21, p22) -- line: 275
        -- upvalues: p20 (copy)
        return p21 + (p22 - p21) * p20
    end

    local t6 = {
        fogColor = p19.fogColor:Lerp(t2.FOG, p20)
    }
    local fogStart = p19.fogStart

    t6.fogStart = fogStart + (math.min(p19.fogStart, t2.FOG_START) - fogStart) * p20

    local fogEnd = p19.fogEnd

    t6.fogEnd = fogEnd + (p19.fogEnd * t2.FOG_END - fogEnd) * p20
    t6.waterColor = p19.waterColor:Lerp(t2.WATER, p20)

    local waterTransparency = p19.waterTransparency

    t6.waterTransparency = waterTransparency + (p19.waterTransparency * t2.CLARITY - waterTransparency) * p20
    t6.tintColor = p19.tintColor
    t6.saturation = p19.saturation
    t6.contrast = p19.contrast
    t6.ambient = p19.ambient:Lerp(t2.AMBIENT, p20)
    t6.outdoorAmbient = p19.outdoorAmbient:Lerp(t2.AMBIENT, p20)

    return t6
end

local function stepDread(p23, p24) -- line: 290
    -- upvalues: Lighting (copy), t1 (copy), t2 (copy), LocalPlayer (copy), ColorCorrectionEffect (copy), n2 (ref), v24 (ref)
    local Dread = LocalPlayer:GetAttribute("Dread")
    local v26 = type(Dread) == "number" and math.clamp(Dread, 0, 1) or 0

    if LocalPlayer:GetAttribute("SetReduceFx") == true then
        v26 = 0
    end

    if LocalPlayer:GetAttribute("FeastLight") == true then
        v26 = 0
    end

    if not p24 or not v26 then
        v26 = 0
    end

    local v27, v28

    if n2 < v26 then
        local IN = t2.IN

        if IN then
            v27 = IN
            v28 = true
        elseif p24 then
            local OUT = t2.OUT

            if OUT then
                v27 = OUT
                v28 = true
            else
                v28 = false
            end
        else
            v28 = false
        end
    elseif p24 then
        local OUT = t2.OUT

        if OUT then
            v27 = OUT
            v28 = true
        else
            v28 = false
        end
    else
        v28 = false
    end

    if not v28 then
        v27 = t2.SURFACE
    end

    local v29 = n2

    n2 = v29 + (v26 - n2) * (1 - math.exp(-v27 * p23))

    if v26 == 0 and n2 < 0.002 then
        n2 = 0
    end

    local v32 = n2 > 0

    if v32 then
        ColorCorrectionEffect.Enabled = true
        ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1):Lerp(t2.TINT, n2)
        ColorCorrectionEffect.Saturation = t2.SATURATION * n2
        ColorCorrectionEffect.Contrast = t2.CONTRAST * n2
        ColorCorrectionEffect.Brightness = t2.BRIGHTNESS * n2
        Lighting.ExposureCompensation = t1.exposure + t2.EXPOSURE * n2
    elseif v24 then
        ColorCorrectionEffect.Enabled = false
        Lighting.ExposureCompensation = t1.exposure
    end

    return v32
end

local v33, v34, v35

local function hideMyTag(p25) -- line: 318
    -- upvalues: LocalPlayer (copy), v33 (ref), v34 (ref), v35 (ref)
    local Character = LocalPlayer.Character
    local v36 = Character and Character:FindFirstChild("HumanoidRootPart")
    local NameTag = v36 and v36:FindFirstChild("NameTag")
    local NameTagLevel = v36 and v36:FindFirstChild("NameTagLevel")

    if NameTag == v33 and NameTagLevel == v34 and p25 == v35 then
        return
    end

    v33 = NameTag
    v34 = NameTagLevel
    v35 = p25

    if NameTag then
        NameTag.Enabled = not p25
    end

    if NameTagLevel then
        NameTagLevel.Enabled = not p25
    end
end

local TweenService = game:GetService("TweenService")
local t7 = {
    0.98, 1.02
}
local v38 = Random.new()

local function diveSound(p26, p27) -- line: 341
    local Sound = Instance.new("Sound")

    Sound.Name = p26
    Sound.SoundId = "rbxassetid://" .. p27
    Sound.Volume = 0
    Sound.Parent = game:GetService("SoundService")

    return Sound
end

local Sound = Instance.new("Sound")

Sound.Name = "DiveSubmerge"
Sound.SoundId = "rbxassetid://" .. 130004878961916
Sound.Volume = 0
Sound.Parent = game:GetService("SoundService")

local Sound2 = Instance.new("Sound")

Sound2.Name = "DiveEmerge"
Sound2.SoundId = "rbxassetid://" .. 72551638688198
Sound2.Volume = 0
Sound2.Parent = game:GetService("SoundService")

local t8 = {}

local function diveFade(p28, p29, p30, p31) -- line: 352
    -- upvalues: TweenService (copy), t8 (copy)
    if t8[p28] then
        t8[p28]:Cancel()
    end

    local tween = TweenService:Create(p28, TweenInfo.new(p30, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, p31 or 0), {
        Volume = p29
    })

    t8[p28] = tween
    tween:Play()

    return tween
end

local function crossed(p32) -- line: 360
    -- upvalues: t7 (copy), v38 (copy), Sound (copy), Sound2 (copy), diveFade (copy)
    local v39 = p32 and Sound or Sound2
    local v40 = p32 and Sound2 or Sound

    if v40.IsPlaying then
        local Completed = diveFade(v40, 0, 0.15).Completed

        Completed:Connect(function(p33) -- line: 363
            -- upvalues: v40 (copy)
            if p33 == Enum.PlaybackState.Completed then
                v40:Stop()
            end
        end)
    end

    v39.PlaybackSpeed = v38:NextNumber(t7[1], t7[2])
    v39.TimePosition = 0
    v39.Volume = p32 and 0.2 or 0
    v39:Play()

    if p32 then
        diveFade(v39, 0, 1.5, 0.8)
    else
        diveFade(v39, 0.2, 0.4)
    end
end

RunService.RenderStepped:Connect(function(p34) -- line: 378
    -- upvalues: Lighting (copy), Terrain (copy), t1 (copy), v1 (ref), zoneAt (copy), lookOf (copy), deepShare (copy), deepen (copy), t4 (copy), blend (copy), atSurface (copy), v18 (ref), WeatherUnderColor (ref), n1 (ref), v23 (ref), LocalPlayer (copy), FEAST_LOOK (copy), n2 (ref), v24 (ref), v25 (ref), darken (copy), stepDread (copy), hideMyTag (copy), crossed (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v42 = CurrentCamera and zoneAt(CurrentCamera.CFrame.Position) or nil
    local v43 = v42 ~= nil and v42:GetAttribute("Air") ~= true

    hideMyTag(v43 or LocalPlayer:GetAttribute("TitanCave") == true)

    if v43 ~= v25 then
        v25 = v43
        LocalPlayer:SetAttribute("CameraUnderwater", v25 or nil)
        crossed(v25)
    end

    local v44 = stepDread(p34, v43)

    if not (v42 or v23 or v44 or v24) then
        if v18 then
            v18 = false

            local fogColor, fogStart, fogEnd = t4.fogColor, t4.fogStart, t4.fogEnd

            Lighting.FogColor = fogColor
            Lighting.FogStart = fogStart
            Lighting.FogEnd = fogEnd
            Terrain.WaterColor = t4.waterColor
        end
    else
        if v42 or v23 then
            local v45 = v43 and LocalPlayer:GetAttribute("FeastLight") == true
            local v46, v47

            if v45 then
                local v48 = table.clone(FEAST_LOOK)

                if v48 then
                    v46 = v48
                    v47 = true
                elseif v42 then
                    local v49 = lookOf(v42)

                    if v49 then
                        v46 = v49
                        v47 = true
                    else
                        v47 = false
                    end
                else
                    v47 = false
                end
            elseif v42 then
                local v50 = lookOf(v42)

                if v50 then
                    v46 = v50
                    v47 = true
                else
                    v47 = false
                end
            else
                v47 = false
            end

            if not v47 then
                v46 = t4
            end

            local v51 = not (not v43 or v45) and LocalPlayer:GetAttribute("TitanLight") or 0
            local v52, v53

            if not v42 or v45 then
                v53 = false
            else
                local v54 = deepShare(v42, CurrentCamera.CFrame.Position.Y) * (1 - 0.85 * v51)

                if v54 then
                    v52 = v54
                    v53 = true
                else
                    v53 = false
                end
            end

            if not v53 then
                v52 = 0
            end

            if v52 > 0 then
                deepen(v42, v46, v52)
            end

            local v55, v56

            if v43 and not v45 and n1 > 0 then
                local WeatherLean = v42:GetAttribute("WeatherLean")

                v55 = n1
                v56 = type(WeatherLean) == "number" and WeatherLean or 1

                local v57 = v55 * v56 * (1 - 0.8 * v51)

                v46.fogColor = v46.fogColor:Lerp(WeatherUnderColor, v57)
                v46.waterColor = v46.waterColor:Lerp(WeatherUnderColor, v57)
            end

            if v51 > 0 then
                v46.waterTransparency = v46.waterTransparency + (math.max(v46.waterTransparency, 0.3) - v46.waterTransparency) * v51
                v46.ambient = v46.ambient:Lerp(t1.ambient, 0.5 * v51)
                v46.outdoorAmbient = v46.outdoorAmbient:Lerp(t1.outdoorAmbient, 0.5 * v51)
            end

            if v23 then
                v23 = blend(v23, v46, 1 - math.exp(-7.5 * p34))
            else
                v23 = v46
                v1.Enabled = true
            end

            if not v42 and atSurface(v23) then
                v1.Enabled = false
                v23 = nil
            end
        end

        local v60 = v23 or t4
        local v61 = if v44 then darken(v60, n2) else nil

        if v44 and v61 then
            v60 = v61
        end

        Lighting.FogColor = v60.fogColor
        Lighting.FogStart = v60.fogStart
        Lighting.FogEnd = v60.fogEnd
        Lighting.Ambient = v60.ambient
        Lighting.OutdoorAmbient = v60.outdoorAmbient
        Terrain.WaterColor = v60.waterColor
        Terrain.WaterTransparency = v60.waterTransparency

        local v62 = v1

        v62.TintColor = v60.tintColor
        v62.Saturation = v60.saturation
        v62.Contrast = v60.contrast
        v24 = v44
        v18 = false
    end
end)

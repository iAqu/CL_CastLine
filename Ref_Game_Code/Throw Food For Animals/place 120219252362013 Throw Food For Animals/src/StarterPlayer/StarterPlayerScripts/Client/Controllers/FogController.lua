-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FogConfig = require(ReplicatedStorage.Config.FogConfig)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local t1 = {}
local t2 = {
    Color = {
        LeadKey = "ColorLeadTime",
        Target = "Atmosphere",
        Fields = { "Color", "Decay" }
    },
    Settings = {
        LeadKey = "SettingsLeadTime",
        Target = "Atmosphere",
        Fields = { "Density", "Offset", "Glare", "Haze" }
    },
    Grade = {
        LeadKey = "SettingsLeadTime",
        Target = "Grade",
        Fields = { "GradeTint", "GradeBrightness", "GradeContrast", "GradeSaturation" }
    },
    Sky = {
        LeadKey = "SettingsLeadTime",
        Target = "Sky",
        Fields = { "Moon", "MoonColor", "MoonClouds", "CloudColor" }
    }
}
local t3 = {}

for _, v1 in pairs(t2) do
    for _, v2 in ipairs(v1.Fields) do
        table.insert(t3, v2)
    end
end

local t4 = {
    Density = true,
    Offset = true,
    Glare = true,
    Haze = true,
    GradeBrightness = true,
    GradeContrast = true,
    GradeSaturation = true,
    Moon = true,
    MoonClouds = true
}
local t5 = {
    GradeTint = "TintColor",
    GradeBrightness = "Brightness",
    GradeContrast = "Contrast",
    GradeSaturation = "Saturation"
}
local Atmosphere, ColorCorrectionEffect
local v3 = table.clone(FogConfig.Defaults)
local t6, v4, v5, CFramePosition, elapsed
local n1 = 0
local t7 = {}

for v6 in pairs(t2) do
    t7[v6] = {}
end

local function getAtmosphere() -- line: 97
    -- upvalues: Lighting (copy), Atmosphere (ref)
    if not Atmosphere or Atmosphere.Parent ~= Lighting then
        Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

        if not Atmosphere then
            Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Parent = Lighting
        end
    end

    return Atmosphere
end

local function getGrade() -- line: 107
    -- upvalues: Lighting (copy), ColorCorrectionEffect (ref)
    if ColorCorrectionEffect and ColorCorrectionEffect.Parent == Lighting then
        return ColorCorrectionEffect
    end

    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "AreaGrade"
    ColorCorrectionEffect.Enabled = false
    ColorCorrectionEffect.Parent = Lighting

    return ColorCorrectionEffect
end

local t8 = {
    { "Glow", 0.5, 0.5, 0.92, 0.92, 0.9 },
    { "Glow", 0.5, 0.5, 0.68, 0.68, 0.8 },
    { "Glow", 0.5, 0.5, 0.52, 0.52, 0.62 },
    { "Disc", 0.5, 0.5, 0.42, 0.42, 0 },
    { "Crater", 0.44, 0.43, 0.09, 0.09, 0.55 },
    { "Crater", 0.57, 0.53, 0.07, 0.07, 0.6 },
    { "Crater", 0.47, 0.6, 0.05, 0.05, 0.62 },
    { "Cloud", 0.36, 0.6, 0.5, 0.06, 0.1 },
    { "Cloud", 0.66, 0.67, 0.48, 0.055, 0.15 },
    { "Cloud", 0.46, 0.75, 0.62, 0.065, 0.05 }
}

local function getMoon() -- line: 134
    -- upvalues: FogConfig (copy), t6 (ref), t8 (copy)
    if t6 and t6.Part.Parent then
        return t6
    end

    local Moon = FogConfig.Moon
    local Part = Instance.new("Part")

    Part.Name = "AreaMoon"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "Moon"
    BillboardGui.Size = UDim2.fromScale(Moon.Size / 0.42, Moon.Size / 0.42)
    BillboardGui.LightInfluence = 0
    BillboardGui.AlwaysOnTop = false
    BillboardGui.MaxDistance = 1e999
    BillboardGui.Enabled = false
    BillboardGui.Adornee = Part
    BillboardGui.Parent = Part

    local t9 = {}

    for v7, v8 in ipairs(t8) do
        local Frame = Instance.new("Frame")

        Frame.Name = v8[1]
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(v8[2], v8[3])
        Frame.Size = UDim2.fromScale(v8[4], v8[5])
        Frame.BorderSizePixel = 0
        Frame.BackgroundTransparency = 1
        Frame.ZIndex = v7

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame
        Frame.Parent = BillboardGui
        table.insert(t9, {
            Frame = Frame,
            Kind = v8[1],
            Base = v8[6]
        })
    end

    Part.Parent = workspace.CurrentCamera
    t6 = {
        Part = Part,
        Gui = BillboardGui,
        Items = t9,
        Direction = Moon.Direction.Unit,
        Distance = Moon.Distance
    }

    return t6
end

local function showSky() -- line: 172
    -- upvalues: v3 (copy), t6 (ref), getMoon (copy)
    local v9 = math.clamp(v3.Moon, 0, 1)

    if v9 < 0.01 and not t6 then
        return
    end

    local v10 = getMoon()

    v10.Gui.Enabled = v9 >= 0.01

    if v10.Gui.Enabled then
        local v11 = math.clamp(v3.MoonClouds, 0, 1)
        local v12 = v3.MoonColor:Lerp(Color3.new(0.45, 0.45, 0.55), 0.35)

        for _, v13 in ipairs(v10.Items) do
            local Frame, Kind = v13.Frame, v13.Kind
            local v14 = v9 * (Kind == "Cloud" and v11 or 1)

            Frame.BackgroundTransparency = 1 - (1 - v13.Base) * v14

            local CloudColor = v12

            if Kind == "Cloud" then
                CloudColor = v3.CloudColor

                if not CloudColor then
                    CloudColor = if Kind == "Crater" and v12 then v12 else v3.MoonColor
                end
            elseif Kind ~= "Crater" or not v12 then
                CloudColor = v3.MoonColor
            end

            Frame.BackgroundColor3 = CloudColor
        end
    end
end

local function readChannel(p1) -- line: 189
    -- upvalues: Lighting (copy), t5 (copy), Atmosphere (ref), ColorCorrectionEffect (ref), v3 (copy)
    local t11 = {}

    if p1.Target == "Atmosphere" then
        if not Atmosphere or Atmosphere.Parent ~= Lighting then
            Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            local Atmosphere2 = Atmosphere

            if not Atmosphere2 then
                Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Parent = Lighting
            end
        end

        local Atmosphere2 = Atmosphere

        for _, v15 in ipairs(p1.Fields) do
            t11[v15] = Atmosphere2[v15]
        end
    elseif p1.Target == "Grade" then
        if not ColorCorrectionEffect or ColorCorrectionEffect.Parent ~= Lighting then
            ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect.Name = "AreaGrade"
            ColorCorrectionEffect.Enabled = false
            ColorCorrectionEffect.Parent = Lighting
        end

        local ColorCorrectionEffect2 = ColorCorrectionEffect

        for _, v16 in ipairs(p1.Fields) do
            t11[v16] = ColorCorrectionEffect2[t5[v16]]
        end
    else
        for _, v17 in ipairs(p1.Fields) do
            t11[v17] = v3[v17]
        end
    end

    return t11
end

local function applyChannel(p2, p3) -- line: 203
    -- upvalues: Lighting (copy), FogConfig (copy), t5 (copy), Atmosphere (ref), ColorCorrectionEffect (ref), v3 (copy), showSky (copy)
    if p2.Target == "Atmosphere" then
        if not Atmosphere or Atmosphere.Parent ~= Lighting then
            Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            local Atmosphere2 = Atmosphere

            if not Atmosphere2 then
                Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Parent = Lighting
            end
        end

        local Atmosphere2 = Atmosphere

        for _, v18 in ipairs(p2.Fields) do
            Atmosphere2[v18] = p3[v18]
        end
    elseif p2.Target == "Grade" then
        if not ColorCorrectionEffect or ColorCorrectionEffect.Parent ~= Lighting then
            ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect.Name = "AreaGrade"
            ColorCorrectionEffect.Enabled = false
            ColorCorrectionEffect.Parent = Lighting
        end

        local ColorCorrectionEffect2 = ColorCorrectionEffect
        local v19 = true

        for _, v20 in ipairs(p2.Fields) do
            ColorCorrectionEffect2[t5[v20]] = p3[v20]

            if p3[v20] ~= FogConfig.Defaults[v20] then
                v19 = false
            end
        end

        ColorCorrectionEffect2.Enabled = not v19
    else
        local v21 = false

        for _, v22 in ipairs(p2.Fields) do
            if v3[v22] ~= p3[v22] then
                v21 = true
                v3[v22] = p3[v22]
            end
        end

        if v21 then
            showSky()
        end
    end
end

local function readAll() -- line: 225
    -- upvalues: t2 (copy), readChannel (copy)
    local t12 = {}

    for _, v23 in pairs(t2) do
        for v24, v25 in pairs((readChannel(v23))) do
            t12[v24] = v25
        end
    end

    return t12
end

local function lerpFields(p4, p5, p6, p7) -- line: 233
    -- upvalues: t4 (copy)
    local t13 = {}

    for _, v26 in ipairs(p4) do
        if t4[v26] then
            t13[v26] = p5[v26] + (p6[v26] - p5[v26]) * p7
        else
            t13[v26] = p5[v26]:Lerp(p6[v26], p7)
        end
    end

    return t13
end

local function fogZones() -- line: 247
    -- upvalues: FogConfig (copy), AreaUtil (copy)
    local t14 = {}

    for v27, v28 in ipairs(AreaUtil.GetAll()) do
        if FogConfig.HasSubPresets(v28.Key) then
            table.insert(t14, {
                Key = v28.Key .. ".1",
                Index = v27,
                ZStart = v28.ZStart
            })

            for v29, v30 in ipairs(AreaUtil.SubAreaLines(v27)) do
                table.insert(t14, {
                    Key = v28.Key .. "." .. v29 + 1,
                    Index = v27,
                    ZStart = v30
                })
            end
        else
            table.insert(t14, {
                Key = v28.Key,
                Index = v27,
                ZStart = v28.ZStart
            })
        end
    end

    return t14
end

local function zoneForZ(p8) -- line: 262
    -- upvalues: FogConfig (copy), AreaUtil (copy)
    local v31 = AreaUtil.GetAll()

    if not v31[1] or v31[1].ZStart < p8 then
        return "Lobby"
    end

    local v32 = AreaUtil.GetAreaIndexForZ(p8)
    local Key = v31[v32].Key

    if FogConfig.HasSubPresets(Key) then
        return Key .. "." .. AreaUtil.SubAreaForZ(v32, p8)
    end

    return Key
end

local function zoneOrdinal(p9, p10) -- line: 274
    local n2 = 0

    for v33, v34 in ipairs(p9) do
        if p10 <= v34.ZStart then
            n2 = v33
        end
    end

    return n2
end

local function presetState(p11, p12) -- line: 283
    -- upvalues: FogConfig (copy), t3 (copy)
    local v35 = FogConfig.Get(p11)
    local t18 = {}

    for _, v36 in ipairs(t3) do
        t18[v36] = v35[v36]
    end

    if p12 then
        t18.Glare = math.min(t18.Glare, FogConfig.Travel.GlareCap)
        t18.Haze = math.min(t18.Haze, FogConfig.Travel.HazeCap)
    end

    return t18
end

local function buildFlightPlan(p13, p14, p15, p16) -- line: 299
    -- upvalues: FogConfig (copy), AreaUtil (copy), t3 (copy), lerpFields (copy), fogZones (copy), zoneForZ (copy), presetState (copy)
    local Travel = FogConfig.Travel

    AreaUtil.GetAll()

    local v37 = (p13 - p14) / math.max(p15, 0.05)
    local v38 = AreaUtil.GetAreaIndexForZ(p14)
    local v39 = v38 - Travel.FullStrengthAreasBack
    local t19 = {}
    local v40 = fogZones()
    local v41 = zoneForZ(p13)
    local n3 = 0

    for v42, v43 in ipairs(v40) do
        if p13 <= v43.ZStart then
            n3 = v42
        end
    end

    local n4 = 0

    for v44, v45 in ipairs(v40) do
        if p14 <= v45.ZStart then
            n4 = v44
        end
    end

    local t20 = {
        T0 = 0,
        Key = v41
    }

    if v41 == "Lobby" then
        t20.Index = 0
    else
        t20.Index = AreaUtil.GetAreaIndexForZ(p13)
    end

    if v37 > 0.01 then
        local v46 = Travel.CameraTrail / v37

        for i = n3 + 1, n4 do
            local v47 = v40[i]

            if v47.ZStart < p13 then
                local v48 = (p13 - v47.ZStart) / v37 + v46

                t20.T1 = v48
                table.insert(t19, t20)
                t20 = {
                    Key = v47.Key,
                    Index = v47.Index,
                    T0 = v48
                }
            end
        end
    end

    t20.T1 = 1e999
    table.insert(t19, t20)

    for v49, v50 in ipairs(t19) do
        local v51 = FogConfig.Get(v50.Key)

        v50.Instant = v51 and v51.Instant or false

        local MinDwellTime = v51 and v51.MinDwellTime or Travel.MinDwellTime

        if v49 == 1 or v49 == #t19 or MinDwellTime <= v50.T1 - v50.T0 then
            v50.Stop = true
        else
            v50.Stop = v51 and v51.NeverSkip or false
        end

        if v49 == 1 then
            v50.State = p16
        else
            v50.State = presetState(v50.Key, v50.Index < v39)
        end
    end

    local t21 = {}

    local function key(p17, p18, p19) -- line: 344
        -- upvalues: t21 (copy)
        local v52 = t21[#t21]

        table.insert(t21, {
            T = if v52 and p17 < v52.T then v52.T else p17,
            State = p18,
            Linear = p19
        })
    end

    local State = t19[1].State
    local v53 = t21[#t21]

    table.insert(t21, {
        Linear = nil,
        T = if v53 and v53.T > 0 then v53.T else 0,
        State = State
    })

    local v54 = t19[1]
    local t24 = {}

    for i = 2, #t19 do
        local v55 = t19[i]

        if v55.Stop then
            if #t24 == 0 then
                local v56 = FogConfig.BlendTime(v54.Key, v55.Key)

                if v56 <= 0 then
                    local v57 = v55.T0 - 0.001
                    local State = v54.State
                    local v58 = t21[#t21]

                    if v58 and v57 < v58.T then
                        v57 = v58.T
                    end

                    table.insert(t21, {
                        Linear = nil,
                        T = v57,
                        State = State
                    })

                    local T0, State2 = v55.T0, v55.State
                    local v59 = t21[#t21]

                    if v59 and T0 < v59.T then
                        T0 = v59.T
                    end

                    table.insert(t21, {
                        Linear = nil,
                        T = T0,
                        State = State2
                    })
                else
                    local v61 = math.max(v54.T0, v55.T0 - v56 / 2)
                    local State = v54.State
                    local v62 = t21[#t21]

                    if v62 and v61 < v62.T then
                        v61 = v62.T
                    end

                    table.insert(t21, {
                        Linear = nil,
                        T = v61,
                        State = State
                    })

                    local v64 = math.min(v55.T1, v55.T0 + v56 / 2)
                    local State2 = v55.State
                    local v65 = t21[#t21]

                    if v65 and v64 < v65.T then
                        v64 = v65.T
                    end

                    table.insert(t21, {
                        Linear = nil,
                        T = v64,
                        State = State2
                    })
                end
            else
                local T1 = v54.T1
                local T0 = v55.T0
                local State = v54.Instant and t24[1].State or v54.State
                local Instant = v55.Instant
                local State2 = if Instant then t24[#t24].State else nil
                local v66 = if not Instant or not State2 then v55.State else State2
                local v67 = T1 - (if v54.Instant then 0.001 else 0)
                local State3 = v54.State
                local v68 = t21[#t21]

                if v68 and v67 < v68.T then
                    v67 = v68.T
                end

                table.insert(t21, {
                    Linear = nil,
                    T = v67,
                    State = State3
                })

                if v54.Instant then
                    local v69 = t21[#t21]

                    table.insert(t21, {
                        Linear = nil,
                        T = if v69 and T1 < v69.T then v69.T else T1,
                        State = State
                    })
                end

                local PassThroughWeight = Travel.PassThroughWeight

                for _, v70 in ipairs(t24) do
                    local v71 = (v70.T0 + v70.T1) / 2
                    local v76 = lerpFields(t3, lerpFields(t3, State, v66, (v71 - T1) / math.max(T0 - T1, 0.001)), v70.State, PassThroughWeight)
                    local v77 = t21[#t21]

                    if v77 and v71 < v77.T then
                        v71 = v77.T
                    end

                    table.insert(t21, {
                        Linear = true,
                        T = v71,
                        State = v76
                    })
                end

                if v55.Instant then
                    local v78 = T0 - 0.001
                    local v79 = t21[#t21]

                    if v79 and v78 < v79.T then
                        v78 = v79.T
                    end

                    table.insert(t21, {
                        Linear = true,
                        T = v78,
                        State = v66
                    })

                    local State = v55.State
                    local v80 = t21[#t21]

                    table.insert(t21, {
                        Linear = nil,
                        T = if v80 and T0 < v80.T then v80.T else T0,
                        State = State
                    })
                else
                    local State = v55.State
                    local v81 = t21[#t21]

                    table.insert(t21, {
                        Linear = nil,
                        T = if v81 and T0 < v81.T then v81.T else T0,
                        State = State
                    })
                end
            end

            v54 = v55
            t24 = {}
        else
            table.insert(t24, v55)
        end
    end

    return {
        Keys = t21,
        Segments = t19,
        LandingIndex = v38,
        Speed = v37
    }
end

local function sampleFlight(p20, p21) -- line: 397
    -- upvalues: TweenService (copy), FogConfig (copy), t3 (copy), lerpFields (copy)
    local Keys = p20.Keys

    if p21 <= Keys[1].T then
        return Keys[1].State
    end

    for i = 2, #Keys do
        local v82 = Keys[i]

        if p21 < v82.T then
            local v83 = Keys[i - 1]
            local v84 = v82.T - v83.T

            if v84 <= 0 then
                return v82.State
            end

            local v85 = (p21 - v83.T) / v84

            if not v83.Linear and not v82.Linear then
                v85 = TweenService:GetValue(v85, FogConfig.EasingStyle, FogConfig.EasingDirection)
            end

            return (lerpFields(t3, v83.State, v82.State, v85))
        end
    end

    return Keys[#Keys].State
end

local function printPlan(p22) -- line: 416
    local t35 = {}

    for _, v86 in ipairs(p22.Segments) do
        table.insert(t35, string.format("%s%s %.2f-%s", v86.Key, if v86.Stop then "" else "(passed)", v86.T0, if v86.T1 == 1e999 then "end" else string.format("%.2f", v86.T1)))
    end

    print(string.format("[FogController] flight plan (%.0f studs/s, %d keys): %s", p22.Speed, #p22.Keys, table.concat(t35, " | ")))
end

local function goTo(p23, p24, p25) -- line: 429
    -- upvalues: t2 (copy), t7 (copy), readChannel (copy), applyChannel (copy)
    local v89 = t2[p23]
    local v90 = t7[p23]

    if not p25 or p25 <= 0 then
        v90.Blend = nil
        applyChannel(v89, p24)
    else
        v90.Blend = {
            From = readChannel(v89),
            To = p24,
            Start = os.clock(),
            Duration = p25
        }
    end
end

local function goToAll(p26, p27) -- line: 440
    -- upvalues: t2 (copy), goTo (copy)
    for v91 in pairs(t2) do
        goTo(v91, p26, p27)
    end
end

local function zoneWithHysteresis(p28, p29) -- line: 445
    -- upvalues: FogConfig (copy), zoneForZ (copy)
    local v92 = FogConfig.Hysteresis or 0

    if v92 <= 0 or not p29 then
        return (zoneForZ(p28))
    end

    local v93 = zoneForZ(p28 - v92)

    if v93 == zoneForZ(p28 + v92) then
        return v93
    end

    return p29
end

local function updateLive(p30, p31, p32, p33) -- line: 453
    -- upvalues: TweenService (copy), FogConfig (copy), t2 (copy), n1 (ref), t7 (copy), applyChannel (copy), lerpFields (copy), zoneForZ (copy), goTo (copy)
    if p33 then
        for v94, v95 in pairs(t2) do
            local v96 = t7[v94]
            local Z = p30.Z
            local v98 = n1
            local v97 = Z + v98 * (FogConfig[v95.LeadKey] or 0)
            local Zone = v96.Zone
            local v99 = FogConfig.Hysteresis or 0
            local v100

            if v99 <= 0 then
                v100 = zoneForZ(v97)
            elseif Zone then
                v100 = zoneForZ(v97 - v99)

                if v100 ~= zoneForZ(v97 + v99) then
                    v100 = Zone
                end
            else
                v100 = zoneForZ(v97)
            end

            if v100 == v96.Zone then
                if p32 and v96.Blend then
                    local To = v96.Blend.To
                    local v101 = t2[v94]

                    t7[v94].Blend = nil
                    applyChannel(v101, To)
                end
            else
                local v102 = if p32 then 0 else FogConfig.BlendTime(v96.Zone, v100)

                v96.Zone = v100
                goTo(v94, FogConfig.Get(v100), v102)
            end
        end
    end

    for v103, v104 in pairs(t2) do
        local Blend = t7[v103].Blend

        if Blend then
            local v106 = math.clamp((p31 - Blend.Start) / Blend.Duration, 0, 1)
            local Value = TweenService:GetValue(v106, FogConfig.EasingStyle, FogConfig.EasingDirection)

            applyChannel(v104, (lerpFields(v104.Fields, Blend.From, Blend.To, Value)))

            if v106 >= 1 then
                t7[v103].Blend = nil
            end
        end
    end
end

local function update() -- line: 483
    -- upvalues: FogConfig (copy), t2 (copy), t6 (ref), v4 (ref), v5 (ref), CFramePosition (ref), elapsed (ref), n1 (ref), applyChannel (copy), sampleFlight (copy), updateLive (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local elapsed2 = os.clock()
    local CFramePosition2 = CurrentCamera.CFrame.Position
    local v107 = elapsed and math.max(elapsed2 - elapsed, 0.004166666666666667) or 0.016666666666666666
    local v109 = CFramePosition ~= nil and (CFramePosition2 - CFramePosition).Magnitude > FogConfig.TeleportDistance

    if not CFramePosition or v109 then
        n1 = 0
    else
        local v111 = 1 - math.exp(-(FogConfig.VelocitySmoothing or 6) * v107)

        n1 += ((CFramePosition2.Z - CFramePosition.Z) / v107 - n1) * v111
    end

    CFramePosition = CFramePosition2
    elapsed = elapsed2

    if v4 then
        updateLive(CFramePosition2, elapsed2, false, false)
    elseif v5 then
        local v113 = elapsed2 - v5.StartTime

        for _, v114 in pairs(t2) do
            applyChannel(v114, (sampleFlight(v5, v113 + (FogConfig[v114.LeadKey] or 0))))
        end
    else
        updateLive(CFramePosition2, elapsed2, v109, true)
    end

    if t6 and t6.Gui.Enabled then
        t6.Part.CFrame = CFrame.new(CFramePosition2 + t6.Direction * t6.Distance)
    end
end

function t1.BeginFlight(p34, p35) -- line: 521
    -- upvalues: FogConfig (copy), t2 (copy), v5 (ref), t7 (copy), readAll (copy), buildFlightPlan (copy), printPlan (copy)
    local v115 = readAll()

    v5 = buildFlightPlan(p34.Start.Z, p34.Target.Z, p34.Duration, v115)
    v5.StartTime = p35 or os.clock()

    for v117 in pairs(t2) do
        t7[v117].Blend = nil
    end

    if FogConfig.Debug then
        printPlan(v5)
    end
end

function t1.EndFlight() -- line: 530
    -- upvalues: t2 (copy), v5 (ref), t7 (copy)
    v5 = nil

    for v118 in pairs(t2) do
        t7[v118].Zone = nil
        t7[v118].Blend = nil
    end
end

function t1.GetFlightPlan() -- line: 538
    -- upvalues: v5 (ref)
    return v5
end

function t1.SampleFlight(p36) -- line: 543
    -- upvalues: v5 (ref), sampleFlight (copy)
    return v5 and sampleFlight(v5, p36)
end

function t1.GetZone() -- line: 547
    -- upvalues: t7 (copy)
    return t7.Settings.Zone
end

function t1.SetOverride(p37, p38) -- line: 551
    -- upvalues: FogConfig (copy), t2 (copy), v4 (ref), goTo (copy)
    v4 = type(p37) == "table" and FogConfig.WithDefaults(p37) or FogConfig.Get(p37)

    local v119 = v4

    p38 = p38 or FogConfig.DefaultBlendTime

    for v121 in pairs(t2) do
        goTo(v121, v119, p38)
    end
end

function t1.ClearOverride(_) -- line: 556
    -- upvalues: t2 (copy), v4 (ref), t7 (copy)
    v4 = nil

    for v122 in pairs(t2) do
        t7[v122].Zone = nil
    end
end

function t1.RefreshZone(p40) -- line: 563
    -- upvalues: FogConfig (copy), t2 (copy), v4 (ref), v5 (ref), t7 (copy), goTo (copy)
    if not v4 and not v5 then
        for v123 in pairs(t2) do
            local Zone = t7[v123].Zone

            if Zone then
                goTo(v123, FogConfig.Get(Zone), p40 or 3)
            end
        end
    end
end

function t1.Init() -- line: 571
    -- upvalues: RunService (copy), ReplicatedStorage (copy), FogConfig (copy), AreaUtil (copy), t1 (copy), t2 (copy), t7 (copy), applyChannel (copy), zoneForZ (copy), update (copy)
    task.spawn(function() -- line: 574
        -- upvalues: RunService (copy), FogConfig (copy), AreaUtil (copy), t2 (copy), t7 (copy), applyChannel (copy), zoneForZ (copy), update (copy)
        AreaUtil.GetAll()

        local CurrentCamera = workspace.CurrentCamera
        local v124 = zoneForZ(CurrentCamera and CurrentCamera.CFrame.Position.Z or 100)

        for v125 in pairs(t2) do
            t7[v125].Zone = v124
        end

        local v126 = FogConfig.Get(v124)

        for v127 in pairs(t2) do
            local v128 = t2[v127]

            t7[v127].Blend = nil
            applyChannel(v128, v126)
        end

        RunService:BindToRenderStep("BiomeFog", Enum.RenderPriority.Camera.Value + 5, update)
    end)
    require(ReplicatedStorage.Config.ReleaseConfig).OnChanged(function(_, p42) -- line: 586
        -- upvalues: t1 (copy)
        if p42 then
            task.delay(1, t1.RefreshZone, 4)
        end
    end)
end

return t1

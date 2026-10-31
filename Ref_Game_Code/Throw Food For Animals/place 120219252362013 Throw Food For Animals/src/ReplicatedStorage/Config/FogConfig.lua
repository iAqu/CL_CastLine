-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fromRGB = Color3.fromRGB
local t1 = {}

t1.DefaultBlendTime = 0.6
t1.SubBlendTime = 1.4
t1.EasingStyle = Enum.EasingStyle.Sine
t1.EasingDirection = Enum.EasingDirection.InOut
t1.TeleportDistance = 60
t1.Hysteresis = 0
t1.ColorLeadTime = 2
t1.SettingsLeadTime = 0
t1.VelocitySmoothing = 6
t1.Travel = {
    MinDwellTime = 1,
    PassThroughWeight = 0.35,
    CameraTrail = 12,
    FullStrengthAreasBack = 1,
    GlareCap = 1,
    HazeCap = 1
}
t1.Debug = false
t1.Transitions = {
    ["Lobby>Forest"] = 0.9,
    ["Desert>Jungle"] = 0.5,
    ["Winter>PrehistoricForest"] = 0.8,
    ["Hell>AncientRuins"] = 0.8,
    ["AncientRuins>MythicalParadise"] = 1,
    ["MythicalParadise>ShadowRealm"] = 1,
    ["ShadowRealm>HarvestFields"] = 1.2,
    ["HarvestFields>PhantomHarbor"] = 1
}
t1.Defaults = {
    GradeBrightness = 0,
    GradeContrast = 0,
    GradeSaturation = 0,
    Moon = 0,
    MoonClouds = 0,
    GradeTint = fromRGB(255, 255, 255),
    MoonColor = fromRGB(255, 250, 232),
    CloudColor = fromRGB(90, 80, 120)
}
t1.Moon = {
    Direction = Vector3.new(0.2, 0.42, -1),
    Distance = 95,
    Size = 10
}
t1.Presets = {
    Lobby = {
        Density = 0.25,
        Offset = 1,
        Glare = 0,
        Haze = 0,
        Color = fromRGB(0, 255, 255),
        Decay = fromRGB(0, 166, 255)
    },
    LobbyHalloween = {
        Density = 0.42,
        Offset = 0.35,
        Glare = 0.45,
        Haze = 2.4,
        GradeBrightness = -0.12,
        GradeContrast = 0.22,
        GradeSaturation = -0.22,
        Moon = 1,
        MoonClouds = 0.5,
        Color = fromRGB(255, 128, 64),
        Decay = fromRGB(112, 52, 168),
        GradeTint = fromRGB(255, 178, 150),
        MoonColor = fromRGB(255, 178, 100),
        CloudColor = fromRGB(92, 56, 120)
    },
    Forest = {
        Density = 0.25,
        Offset = 0,
        Glare = 0.3,
        Haze = 1.88,
        Color = fromRGB(0, 255, 255),
        Decay = fromRGB(0, 166, 255)
    },
    Savana = {
        Density = 0.35,
        Offset = 0,
        Glare = 1,
        Haze = 1.9,
        Color = fromRGB(255, 155, 0),
        Decay = fromRGB(255, 120, 0)
    },
    Desert = {
        Density = 0.32,
        Offset = 0,
        Glare = 1.2,
        Haze = 2.3,
        Color = fromRGB(255, 228, 160),
        Decay = fromRGB(255, 180, 100)
    },
    Jungle = {
        Density = 0.35,
        Offset = 0,
        Glare = 1,
        Haze = 2.13,
        Color = fromRGB(111, 255, 0),
        Decay = fromRGB(0, 255, 81)
    },
    Ocean = {
        Density = 0.3,
        Offset = 0,
        Glare = 5,
        Haze = 3,
        Instant = true,
        Color = fromRGB(0, 255, 255),
        Decay = fromRGB(0, 166, 255)
    },
    Mountains = {
        Density = 0.28,
        Offset = 0,
        Glare = 0.4,
        Haze = 1.6,
        Color = fromRGB(205, 228, 255),
        Decay = fromRGB(130, 165, 210)
    },
    Taiga = {
        Density = 0.4,
        Offset = 0,
        Glare = 0.5,
        Haze = 2.4,
        Color = fromRGB(175, 225, 215),
        Decay = fromRGB(95, 160, 150)
    },
    Winter = {
        Density = 0.42,
        Offset = 0,
        Glare = 0.8,
        Haze = 2.6,
        Color = fromRGB(240, 248, 255),
        Decay = fromRGB(205, 228, 255)
    },
    PrehistoricForest = {
        Density = 0.36,
        Offset = 0,
        Glare = 0.8,
        Haze = 2.4,
        Color = fromRGB(215, 255, 110),
        Decay = fromRGB(120, 200, 30)
    },
    DeepWaters = {
        Density = 0.5,
        Offset = 0,
        Glare = 3,
        Haze = 3,
        Instant = true,
        Color = fromRGB(0, 110, 255),
        Decay = fromRGB(0, 30, 120)
    },
    Hell = {
        Density = 0.46,
        Offset = 0,
        Glare = 0.9,
        Haze = 2.6,
        Color = fromRGB(190, 45, 20),
        Decay = fromRGB(70, 8, 4)
    },
    AncientRuins = {
        Density = 0.26,
        Offset = 0,
        Glare = 0.4,
        Haze = 1.4,
        Color = fromRGB(255, 246, 215),
        Decay = fromRGB(160, 205, 255)
    },
    MythicalParadise = {
        Density = 0.38,
        Offset = 0,
        Glare = 1,
        Haze = 2.6,
        Color = fromRGB(130, 105, 255),
        Decay = fromRGB(220, 85, 245)
    },
    ShadowRealm = {
        Density = 0.55,
        Offset = 0,
        Glare = 0.6,
        Haze = 2.6,
        Color = fromRGB(150, 154, 162),
        Decay = fromRGB(104, 108, 120)
    },
    HarvestFields = {
        Density = 0.45,
        Offset = 0,
        Glare = 0.5,
        Haze = 2.8,
        GradeBrightness = -0.05,
        GradeContrast = 0.14,
        GradeSaturation = 0.05,
        Moon = 1,
        MoonClouds = 0.8,
        Color = fromRGB(176, 136, 214),
        Decay = fromRGB(110, 54, 112),
        GradeTint = fromRGB(232, 218, 255),
        MoonColor = fromRGB(255, 250, 232),
        CloudColor = fromRGB(98, 74, 130)
    },
    ["PhantomHarbor.1"] = {
        Density = 0.5,
        Offset = 0,
        Glare = 0.8,
        Haze = 2.8,
        GradeBrightness = -0.05,
        GradeContrast = 0.2,
        GradeSaturation = -0.45,
        Moon = 0.9,
        MoonClouds = 1,
        Color = fromRGB(128, 124, 120),
        Decay = fromRGB(62, 58, 56),
        GradeTint = fromRGB(255, 234, 208),
        MoonColor = fromRGB(236, 236, 230),
        CloudColor = fromRGB(62, 62, 66)
    },
    ["PhantomHarbor.2"] = {
        Density = 0.55,
        Offset = 0,
        Glare = 0.3,
        Haze = 2.6,
        GradeBrightness = -0.04,
        GradeContrast = 0.24,
        GradeSaturation = -0.4,
        Moon = 0.55,
        MoonClouds = 1,
        Color = fromRGB(104, 128, 126),
        Decay = fromRGB(40, 56, 58),
        GradeTint = fromRGB(226, 242, 238),
        MoonColor = fromRGB(214, 240, 236),
        CloudColor = fromRGB(44, 56, 58)
    },
    ["PhantomHarbor.3"] = {
        Density = 0.48,
        Offset = 0,
        Glare = 0.6,
        Haze = 2.6,
        GradeBrightness = -0.03,
        GradeContrast = 0.3,
        GradeSaturation = -0.3,
        Moon = 1,
        MoonClouds = 0.7,
        Color = fromRGB(92, 84, 88),
        Decay = fromRGB(48, 24, 28),
        GradeTint = fromRGB(255, 236, 232),
        MoonColor = fromRGB(232, 112, 92),
        CloudColor = fromRGB(58, 40, 44)
    },
    PhantomHarbor = {
        Density = 0.5,
        Offset = 0,
        Glare = 0.8,
        Haze = 2.8,
        GradeBrightness = -0.06,
        GradeContrast = 0.22,
        GradeSaturation = -0.5,
        Moon = 0.9,
        MoonClouds = 1,
        Color = fromRGB(120, 123, 128),
        Decay = fromRGB(58, 60, 66),
        GradeTint = fromRGB(255, 236, 214),
        MoonColor = fromRGB(236, 236, 230),
        CloudColor = fromRGB(62, 62, 66)
    }
}

function t1.WithDefaults(p1) -- line: 219
    -- upvalues: t1 (copy)
    local v1 = table.clone(p1)

    for v2, v3 in pairs(t1.Defaults) do
        if v1[v2] == nil then
            v1[v2] = v3
        end
    end

    return v1
end

for v4, v5 in pairs(t1.Presets) do
    t1.Presets[v4] = t1.WithDefaults(v5)
end

function t1.SplitKey(p2) -- line: 232
    local v6, v7 = string.match(tostring(p2), "^(.-)%.(%d+)$")

    if v6 then
        return v6, (tonumber(v7))
    end

    return p2, nil
end

function t1.HasSubPresets(p3) -- line: 239
    -- upvalues: t1 (copy)
    return t1.Presets[tostring(p3) .. ".1"] ~= nil
end

function t1.BlendTime(p4, p5) -- line: 244
    -- upvalues: t1 (copy)
    local v8 = t1.Transitions[tostring(p4) .. ">" .. tostring(p5)]

    if v8 ~= nil then
        return v8
    end

    local v9 = t1.SplitKey(p4)
    local v10 = t1.SplitKey(p5)

    if v9 == v10 and p4 ~= p5 then
        return t1.SubBlendTime
    end

    local v11 = t1.Transitions[tostring(v9) .. ">" .. tostring(v10)]

    if v11 ~= nil then
        return v11
    end

    local v12 = t1.Get(p4)
    local v13 = t1.Get(p5)

    if not (p4 and v12.Instant) then
        local Instant = if p5 then v13.Instant else nil

        if not p5 or not Instant then
            return t1.DefaultBlendTime
        end
    end

    return 0
end

t1.LobbyThemes = {
    Halloween = "LobbyHalloween"
}

local ReleaseConfig = require(script.Parent.ReleaseConfig)

local function lobbyTheme() -- line: 265
    -- upvalues: t1 (copy), ReleaseConfig (copy)
    for v14, v15 in pairs(ReleaseConfig.Show or {}) do
        local v16 = v15.LobbyTheme and t1.Presets[t1.LobbyThemes[v15.LobbyTheme] or ""]

        if v16 and ReleaseConfig.IsUnlocked(v14) then
            return v16
        end
    end

    return nil
end

function t1.Get(p6) -- line: 273
    -- upvalues: t1 (copy), lobbyTheme (copy)
    local v17 = p6 == "Lobby"
    local v18 = if v17 then lobbyTheme() else nil

    if v17 and v18 then
        return v18
    end

    local v19 = t1.Presets[p6]

    if v19 then
        return v19
    end

    local v20 = t1.SplitKey(p6)

    return t1.Presets[v20] or t1.Get("Lobby")
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Sine = Enum.EasingStyle.Sine
local InOut = Enum.EasingDirection.InOut
local v1 = Color3.new(1, 1, 1)
local t1 = {
    "GlobalShadows",
    "ClockTime",
    "GeographicLatitude",
    "Brightness",
    "ExposureCompensation",
    "ShadowSoftness",
    "Ambient",
    "OutdoorAmbient",
    "ColorShift_Top",
    "ColorShift_Bottom",
    "EnvironmentDiffuseScale",
    "EnvironmentSpecularScale",
    "FogColor",
    "FogStart",
    "FogEnd"
}
local t2 = {
    {
        key = "Sky",
        class = "Sky",
        host = Lighting,
        props = {
            "CelestialBodiesShown",
            "SunAngularSize",
            "SunTextureId",
            "MoonAngularSize",
            "MoonTextureId",
            "StarCount",
            "SkyboxUp",
            "SkyboxDn",
            "SkyboxFt",
            "SkyboxBk",
            "SkyboxLf",
            "SkyboxRt",
            "SkyboxOrientation"
        }
    },
    {
        key = "Atmosphere",
        class = "Atmosphere",
        host = Lighting,
        props = { "Density", "Haze", "Glare", "Offset", "Color", "Decay" }
    },
    {
        key = "Clouds",
        class = "Clouds",
        host = Workspace.Terrain,
        props = { "Color", "Cover", "Density", "Enabled" }
    },
    {
        key = "SunRays",
        class = "SunRaysEffect",
        host = Lighting,
        props = { "Intensity", "Spread", "Enabled" }
    },
    {
        key = "Bloom",
        class = "BloomEffect",
        host = Lighting,
        props = { "Intensity", "Threshold", "Size", "Enabled" }
    },
    {
        key = "Blur",
        class = "BlurEffect",
        host = Lighting,
        props = { "Size", "Enabled" }
    },
    {
        key = "DepthOfField",
        class = "DepthOfFieldEffect",
        host = Lighting,
        props = { "NearIntensity", "FarIntensity", "FocusDistance", "InFocusRadius", "Enabled" }
    },
    {
        key = "ColorCorrection",
        class = "ColorCorrectionEffect",
        host = Lighting,
        props = { "Saturation", "Contrast", "Brightness", "TintColor", "Enabled" }
    }
}
local t3 = {
    ClockTime = 24,
    GeographicLatitude = 360
}
local t4 = {
    ["Sky.StarCount"] = true
}
local t5 = {
    ["Bloom.Size"] = true,
    ["Bloom.Threshold"] = true,
    ["DepthOfField.FocusDistance"] = true,
    ["DepthOfField.InFocusRadius"] = true,
    ["SunRays.Spread"] = true
}
local t6 = {}
local v2 = Signal.new()
local t7 = {}
local t8 = {}
local v3, t9, connection

local function locate(p1) -- line: 286
    local v4 = p1.host:FindFirstChild(p1.key)

    return if v4 and v4:IsA(p1.class) then v4 else nil
end

local function readProps(p2, p3) -- line: 291
    local t10 = {}

    for _, v5 in p3 do
        t10[v5] = p2[v5]
    end

    return t10
end

local function writeProps(p4, p5, p6) -- line: 300
    for _, v6 in p5 do
        local v7 = p6[v6]

        if v7 ~= nil and p4[v6] ~= v7 then
            p4[v6] = v7
        end
    end
end

local function readScene() -- line: 310
    -- upvalues: Lighting (copy), t1 (copy), t2 (copy)
    local t11 = {}

    for _, v8 in t1 do
        t11[v8] = Lighting[v8]
    end

    for _, v9 in t2 do
        local v10 = v9.host:FindFirstChild(v9.key)

        if not (v10 and v10:IsA(v9.class)) then
            v10 = nil
        end

        if v10 then
            local key = v9.key
            local t12 = {}

            for _, v11 in v9.props do
                t12[v11] = v10[v11]
            end

            t11[key] = t12
        end
    end

    return t11
end

local function materialise(p7) -- line: 321
    local v12 = Instance.new(p7.class)

    v12.Name = p7.key
    v12.Parent = p7.host

    return v12
end

local function retire(p8, p9) -- line: 329
    -- upvalues: Lighting (copy)
    if p8.host == Lighting then
        p9:Destroy()
    else
        p9.Enabled = false
    end
end

local function writeScene(p10) -- line: 338
    -- upvalues: Lighting (copy), t1 (copy), t2 (copy)
    for _, v13 in t1 do
        local v14 = p10[v13]

        if v14 ~= nil and Lighting[v13] ~= v14 then
            Lighting[v13] = v14
        end
    end

    for _, v15 in t2 do
        local v16 = p10[v15.key]
        local v17 = v15.host:FindFirstChild(v15.key)

        if not (v17 and v17:IsA(v15.class)) then
            v17 = nil
        end

        if v16 ~= nil then
            if not v17 then
                v17 = Instance.new(v15.class)
                v17.Name = v15.key
                v17.Parent = v15.host
            end

            for _, v18 in v15.props do
                local v19 = v16[v18]

                if v19 ~= nil and v17[v18] ~= v19 then
                    v17[v18] = v19
                end
            end
        elseif v17 ~= nil then
            if v15.host == Lighting then
                v17:Destroy()
            else
                v17.Enabled = false
            end
        end
    end
end

local function readAuthored(p11, p12) -- line: 354
    -- upvalues: Lighting (copy), t1 (copy), t2 (copy)
    local v20 = table.clone(p12)

    for v21, v22 in p11:GetAttributes() do
        if table.find(t1, v21) ~= nil then
            local v24 = typeof(Lighting[v21])

            if typeof(v22) ~= v24 then
                error((("%* expects a %* in attribute %*, found %*"):format(p11:GetFullName(), v24, v21, (typeof(v22)))))
            end

            v20[v21] = v22
        end
    end

    for _, v25 in t2 do
        local v26 = p11:FindFirstChildOfClass(v25.class)

        if v26 then
            local key = v25.key
            local t13 = {}

            for _, v27 in v25.props do
                t13[v27] = v26[v27]
            end

            v20[key] = t13
        end
    end

    return v20
end

local function sameProps(p13, p14, p15) -- line: 379
    for _, v28 in p15 do
        if p13[v28] ~= p14[v28] then
            return false
        end
    end

    return true
end

local function sameLook(p16, p17) -- line: 388
    -- upvalues: t1 (copy), t2 (copy)
    local v29 = false
    local v30

    for _, v31 in t1 do
        if p16[v31] ~= p17[v31] then
            v30 = false
            v29 = true
            break
        end
    end

    if not v29 then
        v30 = true
    end

    if not v30 then
        return false
    end

    for _, v32 in t2 do
        local v33 = p16[v32.key]
        local v34 = p17[v32.key]

        if v33 == nil ~= (v34 == nil) then
            return false
        end

        if v33 ~= nil then
            local v35 = false
            local v36

            for _, v37 in v32.props do
                if v33[v37] ~= v34[v37] then
                    v36 = false
                    v35 = true
                    break
                end
            end

            if not v35 then
                v36 = true
            end

            if not v36 then
                return false
            end
        end
    end

    return true
end

local function shortestTurn(p18, p19, p20, p21) -- line: 405
    local v38 = p21 / 2

    return (p18 + (v38 - (v38 - (p19 - p18)) % p21) * p20) % p21
end

local function interpolate(p22, p23, p24, p25, p26) -- line: 411
    if p25 then
        local v39 = p25 / 2

        return (p22 + (v39 - (v39 - (p23 - p22)) % p25) * p24) % p25
    end

    local v40 = typeof(p22)

    if v40 == "number" then
        local v41 = p22 + (p23 - p22) * p24

        if not p26 then
            return v41
        end

        return (math.floor(v41 + 0.5))
    end

    if v40 == "Color3" then
        return p22:Lerp(p23, p24)
    end

    if p24 < 0.7 then
        return p22
    end

    return p23
end

local function restingValue(p27, p28) -- line: 425
    -- upvalues: v1 (copy)
    local v43 = typeof(p27)

    if v43 == "number" then
        if p28 then
            return p27
        end

        return 0
    end

    if v43 == "Color3" then
        return v1
    end

    return p27
end

local function isActive(p29) -- line: 436
    return p29 ~= nil and p29.Enabled ~= false
end

local function blendBlock(p30, p31, p32, p33) -- line: 440
    -- upvalues: v1 (copy), t4 (copy), t5 (copy)
    local v44 = p31 ~= nil and p31.Enabled ~= false
    local v45 = p32 ~= nil and p32.Enabled ~= false

    if v44 or v45 then
        local t14 = {}

        for _, v46 in p30.props do
            local v47 = if v44 then p31[v46] else nil
            local v48 = if v45 then p32[v46] else nil

            if v47 ~= nil or v48 ~= nil then
                local v57 = ("%*.%*"):format(p30.key, v46)

                if v47 ~= nil then
                    if v48 == nil then
                        local v60 = t5[v57] == true
                        local v61 = typeof(v47)

                        v48 = v47

                        if v61 == "number" then
                            if not v60 then
                                v48 = 0
                            end
                        elseif v61 == "Color3" then
                            v48 = v1
                        end
                    end
                else
                    local v58 = t5[v57] == true
                    local v59 = typeof(v48)

                    v47 = v48

                    if v59 == "number" then
                        if not v58 then
                            v47 = 0
                        end
                    elseif v59 == "Color3" then
                        v47 = v1
                    end
                end

                local v62 = t4[v57]
                local v63 = typeof(v47)

                if v63 == "number" then
                    v47 += (v48 - v47) * p33

                    if v62 then
                        v47 = math.floor(v47 + 0.5)
                    end
                elseif v63 == "Color3" then
                    v47 = v47:Lerp(v48, p33)
                elseif not (p33 < 0.7) then
                    v47 = v48
                end

                t14[v46] = v47
            end
        end

        return t14
    end

    return nil
end

local function blend(p34, p35, p36) -- line: 463
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), interpolate (copy), blendBlock (copy)
    if p36 <= 0 then
        return p34
    end

    if p36 >= 1 then
        return p35
    end

    local t15 = {}

    for _, v65 in t1 do
        t15[v65] = interpolate(p34[v65], p35[v65], p36, t3[v65])
    end

    for _, v66 in t2 do
        t15[v66.key] = blendBlock(v66, p34[v66.key], p35[v66.key], p36)
    end

    return t15
end

local function byRankThenId(p37, p38) -- line: 480
    if p37.rank == p38.rank then
        return p37.id < p38.id
    end

    return p37.rank < p38.rank
end

local function resolve() -- line: 489
    -- upvalues: t7 (copy), t8 (copy), byRankThenId (copy)
    local t16 = {}

    for _, v67 in t8 do
        table.insert(t16, v67)
    end

    table.sort(t16, byRankThenId)

    local v68 = t7.Default

    for _, v69 in t16 do
        if v69.preset then
            v68 = v69.preset
        else
            v68 = table.clone(v68)

            for v70, v71 in v69.patch do
                v68[v70] = v71
            end
        end
    end

    return v68
end

local function stopStepping() -- line: 512
    -- upvalues: t9 (ref), connection (ref)
    t9 = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

local function step() -- line: 520
    -- upvalues: TweenService (copy), Sine (copy), InOut (copy), t9 (ref), connection (ref), writeScene (copy), blend (copy)
    local t17 = t9

    if t17 ~= nil then
        local v72 = (os.clock() - t17.startedAt) / t17.seconds

        if v72 >= 1 then
            t9 = nil

            if connection then
                connection:Disconnect()
                connection = nil
            end

            writeScene(t17.target)
        else
            writeScene((blend(t17.origin, t17.target, TweenService:GetValue(v72, Sine, InOut))))
        end
    else
        t9 = nil

        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

local function easeTo(p39, p40) -- line: 541
    -- upvalues: RunService (copy), t9 (ref), connection (ref), readScene (copy), writeScene (copy), step (copy)
    if p40 == p40 and not (p40 <= 0) then
        t9 = {
            origin = readScene(),
            target = p39,
            startedAt = os.clock(),
            seconds = p40
        }

        if connection == nil then
            connection = RunService.Heartbeat:Connect(step)
        end

        return
    end

    t9 = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    writeScene(p39)
end

local function refresh(p41) -- line: 558
    -- upvalues: Workspace (copy), v2 (copy), v3 (ref), sameLook (copy), resolve (copy), easeTo (copy)
    if Workspace:GetAttribute("AdminAbuseOnTop") then
        return
    end

    local v73 = resolve()

    if not sameLook(v3, v73) then
        v3 = v73

        local v74 = p41 or 1.5

        easeTo(v73, v74)
        v2:Fire(v73, v74)
    end
end

t6.Presets = t7
t6.Changed = v2

function t6.SetLayer(p42, p43, p44, p45) -- line: 586
    -- upvalues: t7 (copy), t8 (copy), refresh (copy)
    local t18 = {
        id = p42,
        rank = p44 or 0
    }

    if type(p43) == "string" then
        local v75 = t7[p43]

        if v75 == nil then
            error(("unknown lighting preset \"%*\""):format(p43), 2)
        end

        t18.preset = v75
    else
        t18.patch = p43
    end

    t8[p42] = t18
    refresh(p45)
end

function t6.SetAuthoredLayer(p46, p47, p48, p49) -- line: 602
    -- upvalues: t7 (copy), t8 (copy), readAuthored (copy), refresh (copy)
    local v76 = readAuthored(p47, t7.Default)

    t8[p46] = {
        id = p46,
        rank = p48 or 0,
        preset = v76
    }
    refresh(p49)
end

function t6.ClearLayer(p50, p51) -- line: 613
    -- upvalues: t8 (copy), refresh (copy)
    if t8[p50] ~= nil then
        t8[p50] = nil
        refresh(p51)
    end
end

function t6.Current() -- line: 622
    -- upvalues: v3 (ref)
    return v3
end

function t6.Settle() -- line: 626
    -- upvalues: Workspace (copy), v3 (ref), t9 (ref), connection (ref), writeScene (copy)
    if Workspace:GetAttribute("AdminAbuseOnTop") then
        return
    end

    t9 = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    writeScene(v3)
end

function t6.Start() -- line: 636
end

local v77 = readScene()

t7.Default = v77

for _, child in script:WaitForChild("Presets"):GetChildren() do
    if t7[child.Name] ~= nil then
        error((("duplicate lighting preset %*"):format((child:GetFullName()))))
    end

    t7[child.Name] = readAuthored(child, v77)
end

table.freeze(t7)
v3 = v77

local v78 = Workspace:GetAttribute("AdminAbuseOnTop") == true

local function refill(p52, p53) -- line: 655
    table.clear(p52)

    for v79, v80 in p53 do
        p52[v79] = v80
    end
end

Workspace:GetAttributeChangedSignal("AdminAbuseOnTop"):Connect(function() -- line: 662
    -- upvalues: Workspace (copy), t7 (copy), v3 (ref), t9 (ref), connection (ref), readScene (copy), readAuthored (copy), refresh (copy), v77 (copy), v78 (ref)
    if Workspace:GetAttribute("AdminAbuseOnTop") then
        t9 = nil

        if connection then
            connection:Disconnect()
            connection = nil
        end
    else
        if v78 then
            v78 = false

            local v81 = readScene()

            table.clear(v77)

            for v82, v83 in v81 do
                v77[v82] = v83
            end

            for _, child in script:WaitForChild("Presets"):GetChildren() do
                local v84 = t7[child.Name]
                local v85 = readAuthored(child, v81)

                table.clear(v84)

                for v86, v87 in v85 do
                    v84[v86] = v87
                end
            end
        end

        v3 = readScene()
        refresh()
    end
end)

return t6

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.new(1, 1, 1)
local v2 = table.freeze({ 0, 0.3141592653589793, 0.5934119456780721 })
local v3 = table.freeze({ 0, 0.6981317007977318, -0.6981317007977318, 1.4835298641951802, -1.4835298641951802 })
local t1 = {
    Name = "SewerDrain",
    Teal = Color3.fromRGB(52, 191, 112),
    DeepTeal = Color3.fromRGB(34, 111, 100),
    Foam = Color3.fromRGB(230, 255, 250),
    Rust = Color3.fromRGB(122, 72, 44),
    CaveGreen = Color3.fromRGB(119, 180, 123),
    Moon = Color3.fromRGB(170, 215, 255),
    Looks = table.freeze({
        Clear = table.freeze({
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            Bloom = 0,
            Blur = 0,
            Tint = v1
        }),
        MoonTeal = table.freeze({
            Brightness = 0.02,
            Contrast = 0.08,
            Saturation = 0.25,
            Bloom = 1.2,
            Blur = 0,
            Tint = Color3.fromRGB(200, 255, 240)
        }),
        Flash = table.freeze({
            Brightness = 0.6,
            Contrast = 0,
            Saturation = 0.2,
            Bloom = 2.2,
            Blur = 18,
            Tint = Color3.fromRGB(220, 255, 245)
        }),
        Drowned = table.freeze({
            Brightness = 0.02,
            Contrast = 0.1,
            Saturation = -0.1,
            Bloom = 0.9,
            Blur = 0,
            Tint = Color3.fromRGB(170, 230, 255)
        }),
        Deep = table.freeze({
            Brightness = -0.1,
            Contrast = 0.18,
            Saturation = -0.05,
            Bloom = 1.1,
            Blur = 0,
            Tint = Color3.fromRGB(130, 170, 240)
        }),
        Pipe = table.freeze({
            Brightness = -0.05,
            Contrast = 0.12,
            Saturation = 0.05,
            Bloom = 0.7,
            Blur = 0,
            Tint = Color3.fromRGB(255, 225, 190)
        }),
        Throat = table.freeze({
            Brightness = -0.06,
            Contrast = 0.2,
            Saturation = 0.12,
            Bloom = 0.9,
            Blur = 0,
            Tint = Color3.fromRGB(180, 230, 200)
        }),
        Gullet = table.freeze({
            Brightness = 0.04,
            Contrast = 0.16,
            Saturation = 0.25,
            Bloom = 1.4,
            Blur = 4,
            Tint = Color3.fromRGB(185, 255, 200)
        }),
        Under = table.freeze({
            Brightness = -0.05,
            Contrast = 0.12,
            Saturation = -0.05,
            Bloom = 0.5,
            Blur = 5,
            Tint = Color3.fromRGB(130, 210, 215)
        }),
        Swallow = table.freeze({
            Brightness = -0.34,
            Contrast = 0.24,
            Saturation = 0.05,
            Bloom = 0.4,
            Blur = 3,
            Tint = Color3.fromRGB(110, 170, 125)
        }),
        GreenGlow = table.freeze({
            Brightness = 0.3,
            Contrast = -0.05,
            Saturation = 0.1,
            Bloom = 1.6,
            Blur = 10,
            Tint = Color3.fromRGB(210, 255, 215)
        }),
        Afterglow = table.freeze({
            Brightness = 0.06,
            Contrast = 0.05,
            Saturation = 0.15,
            Bloom = 1.2,
            Blur = 10,
            Tint = Color3.fromRGB(215, 255, 235)
        }),
        Haze = table.freeze({
            Brightness = 0.08,
            Contrast = -0.05,
            Saturation = -0.1,
            Bloom = 0.6,
            Blur = 6,
            Tint = Color3.fromRGB(190, 240, 235)
        })
    })
}

function t1.Ease(p1, p2, p3) -- line: 168
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p1, 0, 1), p2, p3)
end

function t1.Smooth(p4) -- line: 172
    local v4 = math.clamp(p4, 0, 1)

    return v4 * v4 * (3 - v4 * 2)
end

function t1.Span(p5, p6, p7) -- line: 177
    if p7 <= p6 then
        if p7 <= p5 then
            return 1
        end

        return 0
    end

    return (math.clamp((p5 - p6) / (p7 - p6), 0, 1))
end

function t1.Flat(p8) -- line: 184
    return (Vector3.new(p8.X, 0, p8.Z))
end

function t1.FlatUnit(p9, p10) -- line: 188
    local v6 = Vector3.new(p9.X, 0, p9.Z)

    if v6.Magnitude > 0.01 then
        return v6.Unit
    end

    return p10
end

function t1.LowQuality() -- line: 193
    -- upvalues: UserGameSettings (copy)
    local function v7() -- line: 194
        -- upvalues: UserGameSettings (copy)
        return UserGameSettings.SavedQualityLevel.Value
    end

    local ok, result = pcall(v7)

    if ok then
        ok = result >= 1 and result <= 3
    end

    return ok
end

function t1.Mix(p11, p12, p13, p14) -- line: 200
    local v8 = math.clamp(p14, 0, 1)

    p11.Brightness = math.lerp(p12.Brightness, p13.Brightness, v8)
    p11.Contrast = math.lerp(p12.Contrast, p13.Contrast, v8)
    p11.Saturation = math.lerp(p12.Saturation, p13.Saturation, v8)
    p11.Tint = p12.Tint:Lerp(p13.Tint, v8)
    p11.Bloom = math.lerp(p12.Bloom, p13.Bloom, v8)
    p11.Blur = math.lerp(p12.Blur, p13.Blur, v8)
end

function t1.Grade(p15, p16) -- line: 210
    -- upvalues: t1 (copy)
    local v9 = p15:Add(Instance.new("ColorCorrectionEffect"))

    v9.Name = "SewerDrain"
    v9.Parent = p16

    local v10 = p15:Add(Instance.new("BloomEffect"))

    v10.Name = "SewerDrain"
    v10.Intensity = 0
    v10.Size = 40
    v10.Threshold = 0.9
    v10.Parent = p16

    local v11 = p15:Add(Instance.new("BlurEffect"))

    v11.Name = "SewerDrain"
    v11.Size = 0
    v11.Parent = p16

    local v12 = p15:Add(Instance.new("DepthOfFieldEffect"))

    v12.Name = "SewerDrain"
    v12.Enabled = false
    v12.FarIntensity = 0.25
    v12.NearIntensity = 0
    v12.InFocusRadius = 10
    v12.FocusDistance = 20
    v12.Parent = p16

    return {
        Color = v9,
        Bloom = v10,
        Blur = v11,
        Depth = v12,
        Look = table.clone(t1.Looks.Clear)
    }
end

function t1.Apply(p17, p18) -- line: 241
    local Look = p17.Look

    p17.Color.Brightness = Look.Brightness + p18 * 0.03
    p17.Color.Contrast = Look.Contrast
    p17.Color.Saturation = Look.Saturation
    p17.Color.TintColor = Look.Tint
    p17.Bloom.Intensity = Look.Bloom + p18 * 0.2
    p17.Blur.Size = Look.Blur
end

function t1.Part(p19) -- line: 251
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth

    if p19 then
        for v13, v14 in p19 do
            Part[v13] = v14
        end
    end

    return Part
end

function t1.Quiet(p20) -- line: 268
    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        elseif descendant:IsA("LuaSourceContainer") or descendant:IsA("Sound") then
            descendant:Destroy()
        end
    end
end

function t1.Emitter(p21) -- line: 282
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LockedToPart = false

    for v15, v16 in p21 do
        ParticleEmitter[v15] = v16
    end

    return ParticleEmitter
end

function t1.Beam(p22) -- line: 292
    local Beam = Instance.new("Beam")

    Beam.LightInfluence = 0
    Beam.Segments = 10

    for v17, v18 in p22 do
        Beam[v17] = v18
    end

    return Beam
end

function t1.Clamp(p23, p24, p25, p26) -- line: 302
    -- upvalues: Workspace (copy)
    local v19 = p24 - p23

    if not (v19.Magnitude < 0.05) then
        local v20 = table.clone(p25)
        local v21 = RaycastParams.new()

        v21.FilterType = Enum.RaycastFilterType.Exclude
        v21.RespectCanCollide = false

        for _ = 1, 6 do
            v21.FilterDescendantsInstances = v20

            local v22 = if p26 then Workspace:Spherecast(p23, 0.9, v19, v21) else Workspace:Raycast(p23, v19, v21)

            if v22 == nil then
                return p24
            end

            local Instance = v22.Instance

            if not (Instance:IsA("BasePart") and Instance.Transparency >= 0.9) then
                local v23 = if p26 then math.max(v22.Distance - 0.4, 0.5) else math.max((v22.Position - p23).Magnitude - 0.8, 0.5)

                return p23 + v19.Unit * v23
            end

            table.insert(v20, Instance)
        end
    end

    return p24
end

function t1.Clearance(p27, p28, p29) -- line: 332
    -- upvalues: t1 (copy)
    return (t1.Clamp(p27, p28, p29) - p27).Magnitude
end

function t1.Orbit(p30, p31, p32, p33, p34) -- line: 336
    -- upvalues: v2 (copy), v3 (copy), t1 (copy)
    local v26 = t1.FlatUnit(p31, (Vector3.new(0, 0, 1)))
    local v27 = p30
    local n1 = -1

    for _, v28 in v2 do
        local v29 = v27
        local v30 = n1

        for _, v31 in v3 do
            local v32 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v31) * v26
            local v34 = math.max(p32 - v28, 0.13962634015954636)
            local v35 = p30 + v32 * p33 * math.cos(v34) + Vector3.new(0, 1, 0) * p33 * math.sin(v34)
            local v36 = t1.Clamp(p30, v35, p34)
            local Magnitude = (v36 - p30).Magnitude

            if p33 * 0.85 <= Magnitude then
                return v36
            end

            if v30 < Magnitude then
                v30 = Magnitude
                v29 = v36
            end

            n1 = v30
            v27 = v29
        end
    end

    return v27
end

function t1.Swing(p35, p36, p37, p38, p39) -- line: 367
    -- upvalues: t1 (copy)
    local v37 = p36 - p35
    local v38 = p37 - p35
    local v39 = math.atan2(v37.X, v37.Z)
    local v40 = v39 + ((math.atan2(v38.X, v38.Z) - v39 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p38
    local Magnitude = Vector3.new(v37.X, 0, v37.Z).Magnitude
    local Magnitude2 = Vector3.new(v38.X, 0, v38.Z).Magnitude
    local v45 = math.lerp(math.atan2(v37.Y, (math.max(Magnitude, 0.01))), math.atan2(v38.Y, (math.max(Magnitude2, 0.01))), p38)
    local v47 = math.max(math.lerp(v37.Magnitude, v38.Magnitude, p38), 5)
    local v51 = Vector3.new(math.sin(v40) * math.cos(v45), math.sin(v45), math.cos(v40) * math.cos(v45))

    return t1.Clamp(p35, p35 + v51 * v47, p39, true)
end

function t1.Projected(p40, p41) -- line: 394
    local v52, v53 = p40:WorldToViewportPoint(p41)
    local ViewportSize = p40.ViewportSize

    if ViewportSize.X < 1 or ViewportSize.Y < 1 then
        return Vector2.new(0.5, 0.5), false
    end

    return Vector2.new(v52.X / ViewportSize.X, v52.Y / ViewportSize.Y), v53 and v52.Z > 0
end

return table.freeze(t1)

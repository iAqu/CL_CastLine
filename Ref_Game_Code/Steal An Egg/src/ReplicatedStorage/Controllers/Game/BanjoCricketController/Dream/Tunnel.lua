-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Shapes = require(script.Parent.Shapes)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    "rbxassetid://243331916",
    "rbxassetid://6337277439"
}
local v1 = Color3.fromRGB(255, 230, 250)
local t2 = {}

local function wall(p1, p2) -- line: 72
    -- upvalues: Shapes (copy), t1 (copy)
    local v2 = Shapes.Part(("Wall%*"):format(p2), (Vector3.new(4.8148694, 0.3, 158)))
    local v3 = (p2 - 0.5) / 14 * 3.141592653589793 * 2

    v2.CFrame = p1 * CFrame.Angles(0, 0, v3) * CFrame.new(0, 10, -71)

    local Texture = Instance.new("Texture")

    Texture.Texture = t1[p2 % #t1 + 1]
    Texture.Face = Enum.NormalId.Bottom
    Texture.StudsPerTileU = 6
    Texture.StudsPerTileV = 6
    Texture.Transparency = 0.2
    Texture.Parent = v2

    return v2, Texture
end

local function dreamer(p3, p4, p5) -- line: 94
    local clone = p3:Clone()

    clone:ScaleTo(0.42)

    local Pivot = clone:GetPivot()
    local t3 = {}
    local t4 = {}

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false

            if descendant.Name == "Cap" then
                descendant.Material = Enum.Material.Neon
                descendant.Color = p4
            elseif descendant.Name == "Spots" then
                descendant.Material = Enum.Material.Neon
            end

            table.insert(t3, descendant)
            table.insert(t4, Pivot:ToObjectSpace(descendant.CFrame))
        end
    end

    return {
        Model = clone,
        Parts = t3,
        Offsets = t4,
        Phase = p5
    }
end

local function stream(p6, p7) -- line: 121
    -- upvalues: Shapes (copy)
    local v4 = Shapes.Part(p7, (Vector3.new(17, 17, 0.5)))

    v4.Transparency = 1
    v4.CFrame = p6 * CFrame.new(0, 0, -144)

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = p7
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Disc
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.ShapePartial = 0.45
    ParticleEmitter.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter.Parent = v4

    return v4, ParticleEmitter
end

local function streaks(p8) -- line: 137
    p8.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    p8.Rate = 90
    p8.Speed = NumberRange.new(120, 170)
    p8.Lifetime = NumberRange.new(1, 1.25)
    p8.Orientation = Enum.ParticleOrientation.VelocityParallel
    p8.Squash = NumberSequence.new(2)
    p8.Size = NumberSequence.new(0.35)
    p8.Transparency = NumberSequence.new(0.1)
    p8.LightEmission = 1
    p8.Brightness = 2.5
    p8.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 200)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(80, 220, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 240, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
end

local function notes(p9, p10) -- line: 156
    local t5 = {}

    for v5, v6 in p10 do
        local v7 = if #p10 > 1 then (v5 - 1) / (#p10 - 1) else 0

        table.insert(t5, ColorSequenceKeypoint.new(v7, v6))
    end

    if #t5 == 1 then
        table.insert(t5, ColorSequenceKeypoint.new(1, t5[1].Value))
    end

    p9.Rate = 9
    p9.Speed = NumberRange.new(45, 70)
    p9.Lifetime = NumberRange.new(2.4, 3)
    p9.Size = NumberSequence.new(1.6, 2.6)
    p9.Transparency = NumberSequence.new(0)
    p9.LightEmission = 0.6
    p9.Brightness = 2
    p9.Rotation = NumberRange.new(-30, 30)
    p9.RotSpeed = NumberRange.new(-60, 60)
    p9.Color = ColorSequence.new(t5)
end

function t2.Step(p11, p12, p13, p14) -- line: 182
    -- upvalues: Workspace (copy), Shapes (copy)
    local Origin, Frames = p11.Origin, p11.Frames

    for v8, v9 in p11.Walls do
        local v10 = (v8 - 1) / 14 + p12 * 0.15

        v9.Color = Color3.fromHSV(v10 % 1, 0.85, 0.6)
        p11.Tiles[v8].OffsetStudsV = p13
    end

    local v11 = math.lerp(146, 5, p14)

    Frames[1] = Origin * CFrame.new(0, 0, -v11) * CFrame.Angles(0, 1.5707963267948966, 0)

    for v12, v13 in p11.Rings do
        local v14 = (v12 * 15 - p13) % 150

        if p11.RingDistances[v12] + 15 < v14 then
            Shapes.Paint(v13, p12 * 0.37 % 1, 0.5)
        end

        p11.RingDistances[v12] = v14

        local v15 = p12 * 1.4 * (if v12 % 2 == 0 then 1 else -1)

        Frames[v12 + 1] = Origin * CFrame.new(0, 0, -v14 - 1) * CFrame.Angles(0, 0, v15)
    end

    local v16 = #p11.Rings + 1

    for _, v17 in p11.Dreamers do
        local v18 = (v17.Phase * 150 - p13 * 0.55) % 150
        local v19 = p12 * 0.8 + v17.Phase * 3.141592653589793 * 2
        local v20 = Vector3.new(1.7, 1.1, 0.6) * (p12 + v17.Phase * 4)
        local v21 = Origin * CFrame.new(math.cos(v19) * 5.6, math.sin(v19) * 5.6, -v18 - 2) * CFrame.Angles(v20.X, v20.Y, v20.Z)

        for v22, v23 in v17.Offsets do
            Frames[v16 + v22] = v21 * v23
        end

        v16 += #v17.Offsets
    end

    Workspace:BulkMoveTo(p11.Moving, Frames, Enum.BulkMoveMode.FireCFrameChanged)
end

function t2.Build(p15, p16, p17) -- line: 236
    -- upvalues: Shapes (copy), t1 (copy), v1 (copy), t2 (copy), wall (copy), dreamer (copy), stream (copy), streaks (copy), notes (copy)
    local Origin = p17.Origin
    local t6 = {}
    local t7 = {}
    local t8 = {}

    for i = 1, 14 do
        local v24, v25 = wall(Origin, i)

        table.insert(t7, v24)
        table.insert(t8, v25)
        table.insert(t6, v24)
    end

    local v26 = Shapes.Part("EndLight", (Vector3.new(0.3, 22, 22)))

    v26.Shape = Enum.PartType.Cylinder
    v26.Color = v1
    table.insert(t6, v26)

    local t9 = {}
    local t10 = {}

    for i = 1, 10 do
        local v27 = Shapes.Circle(("Ring%*"):format(i), 8.7)

        Shapes.SetWidth(v27, 0.9)
        Shapes.Paint(v27, i / 10, 0.5)
        table.insert(t9, v27)
        table.insert(t10, 0)
        table.insert(t6, v27.Hub)
    end

    local t11 = {}
    local Mushroom = p17.Mushroom

    if Mushroom then
        for v28, v29 in p17.Palette do
            local v30 = dreamer(Mushroom, v29, (v28 - 1) / #p17.Palette)

            table.insert(t11, v30)
            table.insert(t6, v30.Model)
        end
    end

    local Streaks, Streaks2 = stream(Origin, "Streaks")

    streaks(Streaks2)
    table.insert(t6, Streaks)

    for v31, v32 in t1 do
        local v33, v34 = stream(Origin, (("Notes%*"):format(v31)))

        notes(v34, p17.Palette)
        v34.Texture = v32
        table.insert(t6, v33)
    end

    for _, v35 in t6 do
        p15:Add(v35)
        v35.Parent = p16
    end

    local t12 = {
        v26
    }

    for _, v36 in t9 do
        table.insert(t12, v36.Hub)
    end

    for _, v37 in t11 do
        for _, v38 in v37.Parts do
            table.insert(t12, v38)
        end
    end

    local t13 = {
        Origin = Origin,
        Walls = t7,
        Tiles = t8,
        Rings = t9,
        RingDistances = t10,
        Light = v26,
        Dreamers = t11,
        Moving = t12,
        Frames = table.create(#t12)
    }

    t2.Step(t13, 0, 0, 0)

    return t13
end

return table.freeze(t2)

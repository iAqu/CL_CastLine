-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Kit = require(script.Parent.Kit)

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    "Reach",
    "Grab",
    "Wave"
}
local v1 = Color3.fromRGB(52, 191, 112)
local v2 = Color3.fromRGB(120, 235, 205)
local v3 = table.freeze({ -0.55, 0, 0.55 })
local t2 = {}

local function ellipsoid(p1, p2, p3) -- line: 59
    -- upvalues: Kit (copy)
    local v4 = Kit.Part({
        Size = p1,
        Color = p2,
        Material = p3
    })
    local SpecialMesh = Instance.new("SpecialMesh")

    SpecialMesh.MeshType = Enum.MeshType.Sphere
    SpecialMesh.Parent = v4

    return v4
end

local function fingerOffsets(p4) -- line: 71
    -- upvalues: v3 (copy)
    local v5 = v3[p4]
    local v6 = CFrame.new(v5, 0.6509999799728393, 0)
    local v8 = math.rad(-v5 * 22)

    return {
        Reach = v6 * CFrame.Angles(0, 0, v8) * CFrame.new(0, 0.6075000107288361, 0),
        Grab = v6 * CFrame.Angles(-1.8325957145940461, 0, v8 * 0.3) * CFrame.new(0, 0.5670000100135802, 0),
        Wave = v6 * CFrame.Angles(0.24434609527920614, 0, v8 * 0.5) * CFrame.new(0, 0.6345000112056732, 0)
    }
end

local function thumbOffsets() -- line: 85
    local v9 = CFrame.new(0.875, -0.05, -0.1)

    return {
        Reach = v9 * CFrame.Angles(0, 0, -0.9599310885968813) * CFrame.new(0, 0.4199999809265137, 0),
        Grab = v9 * CFrame.Angles(-1.2217304763960306, 0, -0.3490658503988659) * CFrame.new(0, 0.4199999809265137, 0),
        Wave = v9 * CFrame.Angles(0, 0, -0.6981317007977318) * CFrame.new(0, 0.44099997997283935, 0)
    }
end

local function buildDrawn(p5) -- line: 96
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), ellipsoid (copy), fingerOffsets (copy), thumbOffsets (copy)
    local t3 = {}
    local v10 = ellipsoid(Vector3.new(1.75, 1.55, 0.8), v1, Enum.Material.Neon)

    v10.Name = "Palm"
    v10.Parent = p5
    table.insert(t3, {
        Part = v10,
        Offsets = {},
        Shared = CFrame.identity
    })

    local v11 = ellipsoid(Vector3.new(1.05, 3.8, 1.05), v1, Enum.Material.Neon)

    v11.Name = "Arm"
    v11.Parent = p5
    table.insert(t3, {
        Part = v11,
        Offsets = {},
        Shared = CFrame.new(0, -2.1384999632835386, 0)
    })

    local v12 = ellipsoid(Vector3.new(0.6, 2.4, 0.6), v2, Enum.Material.Neon)

    v12.Name = "Tail"
    v12.Transparency = 0.25
    v12.Parent = p5
    table.insert(t3, {
        Part = v12,
        Offsets = {},
        Shared = CFrame.new(0.25, -4.15249993801117, 0) * CFrame.Angles(0, 0, -0.4886921905584123) * CFrame.new(0, -0.9600000381469727, 0)
    })

    for i = 1, #v3 do
        local v13 = ellipsoid(Vector3.new(0.5, 1.35, 0.5), v1, Enum.Material.Neon)

        v13.Name = ("Finger%*"):format(i)
        v13.Parent = p5
        table.insert(t3, {
            Part = v13,
            Offsets = fingerOffsets(i)
        })
    end

    local v14 = ellipsoid(Vector3.new(0.55, 1.05, 0.55), v1, Enum.Material.Neon)

    v14.Name = "Thumb"
    v14.Parent = p5
    table.insert(t3, {
        Part = v14,
        Offsets = thumbOffsets()
    })

    local v15 = ellipsoid(Vector3.new(2.0649998, 1.8289999, 0.94399995), v2, Enum.Material.ForceField)

    v15.Name = "Shimmer"
    v15.Parent = p5
    table.insert(t3, {
        Part = v15,
        Offsets = {},
        Shared = CFrame.identity
    })

    return t3
end

local function buildMeshed(p6, p7) -- line: 138
    -- upvalues: Kit (copy), t1 (copy), v1 (copy), v2 (copy)
    local t10 = {}

    for _, v16 in t1 do
        local v17 = p7:FindFirstChild(v16)

        if v17 == nil or not v17:IsA("BasePart") then
            return nil
        end

        local Palm = v17:GetAttribute("Palm")
        local Turn = v17:GetAttribute("Turn")
        local v18 = if typeof(Palm) == "Vector3" then CFrame.new(-Palm) else CFrame.identity

        if typeof(Turn) ~= "CFrame" then
            Turn = CFrame.identity
        end

        local v19 = v18 * Turn
        local clone = v17:Clone()

        clone.Name = v16
        clone.Material = Enum.Material.Neon
        clone.Color = v1
        Kit.Quiet(clone)
        clone.Anchored = true
        clone.Parent = p6

        local t11 = {}

        t11[v16] = v19
        table.insert(t10, {
            Part = clone,
            Offsets = t11
        })

        local clone2 = v17:Clone()

        clone2.Name = v16 .. "Shimmer"
        clone2.Material = Enum.Material.ForceField
        clone2.Color = v2
        clone2.Size = v17.Size * 1.06
        clone2.Anchored = true
        clone2.Parent = p6

        local t13 = {}

        t13[v16] = v19
        table.insert(t10, {
            Part = clone2,
            Offsets = t13
        })
    end

    return t10
end

local function scaleOf(p8, p9) -- line: 173
    if p8.Scale == 1 then
        return p9
    end

    return p9.Rotation + p9.Position * p8.Scale
end

function t2.Build(p10, p11, p12, p13) -- line: 184
    -- upvalues: Kit (copy), v1 (copy), v2 (copy), t2 (copy), buildDrawn (copy), buildMeshed (copy)
    local v20 = p10:Add(Instance.new("Model"))

    v20.Name = "SewerDrainHands"

    local Assets = script.Parent:FindFirstChild("Assets")
    local Hands = Assets and Assets:FindFirstChild("Hands")
    local t15 = {}

    for i = 1, p12 do
        local Model = Instance.new("Model")

        Model.Name = ("Hand%*"):format(i)

        local v21 = if Hands == nil then nil else buildMeshed(Model, Hands)
        local v22 = v21 ~= nil

        if v21 == nil then
            v21 = buildDrawn(Model)
        end

        local v23 = p13 / (if v22 then 5.4 else 5.349999904632568)

        for _, v24 in v21 do
            v24.Part.Size *= v23
        end

        local Part = v21[1].Part
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "Wrist"
        Attachment.Parent = Part

        local v25 = Kit.Emitter({
            Name = "Wisps",
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            LightEmission = 0.8,
            LightInfluence = 0,
            Drag = 3,
            Color = ColorSequence.new(v2, v1),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(0.6, 0.75),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, v23 * 0.6),
                NumberSequenceKeypoint.new(1, v23 * 2.2)
            }),
            Lifetime = NumberRange.new(0.5, 0.9),
            Speed = NumberRange.new(2, 5),
            SpreadAngle = Vector2.new(60, 60),
            RotSpeed = NumberRange.new(-60, 60),
            Rotation = NumberRange.new(0, 360)
        })

        v25.Parent = Attachment
        Model.Parent = v20

        local t16 = {
            Shown = "Reach",
            Visible = true,
            Model = Model,
            Pieces = v21,
            Scale = v23,
            Frame = CFrame.identity,
            Anchor = Attachment,
            Wisps = v25
        }

        table.insert(t15, t16)
        t2.Visible(t16, false)
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "Outline"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = Color3.fromRGB(205, 255, 240)
    Highlight.OutlineTransparency = 0.15
    Highlight.Adornee = v20
    Highlight.Parent = v20

    local v26 = Kit.Part({
        Name = "Glow",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1
    })

    v26.Parent = v20

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Range = 14
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = v26
    v20.Parent = p11

    return {
        Model = v20,
        Hands = t15,
        Outline = Highlight,
        Light = PointLight,
        LightPart = v26
    }
end

function t2.Show(p14, p15) -- line: 271
    -- upvalues: t2 (copy)
    p14.Shown = p15
    t2.Place(p14, p14.Frame)
end

function t2.Visible(p16, p17) -- line: 276
    -- upvalues: t2 (copy)
    p16.Visible = p17
    t2.Place(p16, p16.Frame)
end

function t2.Place(p18, p19, p20) -- line: 281
    p18.Frame = p19
    p20 = p20 or 1

    for _, v28 in p18.Pieces do
        local v29 = v28.Shared or v28.Offsets[p18.Shown]
        local Part = v28.Part

        if v29 ~= nil then
            if not p18.Visible or p20 <= 0.01 then
                Part.Transparency = 1
                Part.CFrame = p19
            else
                Part.Transparency = Part.Name == "Tail" and 0.25 or 0

                if p18.Scale ~= 1 then
                    v29 = v29.Rotation + v29.Position * p18.Scale
                end

                Part.CFrame = p19 * (v29.Rotation + v29.Position * p20)
            end
        else
            Part.Transparency = 1
            Part.CFrame = p19
        end
    end
end

function t2.Puff(p21, p22) -- line: 298
    p21.Wisps:Emit(p22)
end

return table.freeze(t2)

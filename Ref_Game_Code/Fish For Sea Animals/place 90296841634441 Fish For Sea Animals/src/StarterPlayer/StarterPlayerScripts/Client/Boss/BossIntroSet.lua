-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local t1 = {}

local function lerp(p1, p2, p3) -- line: 13
    return p1 + (p2 - p1) * p3
end

function t1.prop(p4, p5) -- line: 17
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v1, v2 in p5 do
        Part[v1] = v2
    end

    Part.Parent = p4

    return Part
end

local function ellipsoid(p6, p7) -- line: 30
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v3, v4 in p7 do
        Part[v3] = v4
    end

    Part.Parent = p6
    Part.Size = Vector3.new(1, 1, 1)

    local SpecialMesh = Instance.new("SpecialMesh")

    SpecialMesh.MeshType = Enum.MeshType.Sphere
    SpecialMesh.Parent = Part

    return Part, SpecialMesh
end

function t1.bucket(p8) -- line: 45
    local Model = Instance.new("Model")

    Model.Name = "Bucket"

    local v5 = Color3.fromRGB(160, 170, 182)
    local v6 = Color3.fromRGB(105, 112, 122)
    local v7 = Color3.fromRGB(200, 208, 218)
    local t2 = {
        Name = "Core",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        CFrame = CFrame.identity
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v8, v9 in t2 do
        Part[v8] = v9
    end

    Part.Parent = Model

    local t3 = {
        Name = "Bottom",
        Size = Vector3.new(0.08, 1.2, 1.2),
        Shape = Enum.PartType.Cylinder,
        Color = v6,
        Material = Enum.Material.Metal,
        CFrame = CFrame.new(0, -0.71, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false

    local Smooth3, Smooth4 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part2.TopSurface = Smooth3
    Part2.BottomSurface = Smooth4

    for v10, v11 in t3 do
        Part2[v10] = v11
    end

    Part2.Parent = Model

    for i = 1, 18 do
        local v12 = i / 18 * 3.141592653589793 * 2
        local t4 = {
            Name = "Wall",
            Size = Vector3.new(0.27757716, 1.5160475, 0.06),
            Color = if i % 2 == 0 then v5 else v5:Lerp(v6, 0.15),
            Material = Enum.Material.Metal,
            CFrame = CFrame.Angles(0, v12, 0) * CFrame.new(0, 0, -0.71) * CFrame.Angles(-0.1456283805708226, 0, 0)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v13, v14 in t4 do
            Part[v13] = v14
        end

        Part.Parent = Model

        local v15 = (i + 0.5) / 18 * 3.141592653589793 * 2
        local t5 = {
            Name = "Rim",
            Size = Vector3.new(0.3291691, 0.11, 0.11),
            Color = v7,
            Material = Enum.Material.Metal,
            CFrame = CFrame.Angles(0, v15, 0) * CFrame.new(0, 0.75, -0.84)
        }
        local Part2 = Instance.new("Part")

        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.CanTouch = false

        local Smooth3, Smooth4 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part2.TopSurface = Smooth3
        Part2.BottomSurface = Smooth4

        for v16, v17 in t5 do
            Part2[v16] = v17
        end

        Part2.Parent = Model
    end

    for i = 1, 18 do
        local v18 = i / 18 * 3.141592653589793 * 2
        local t6 = {
            Name = "Band",
            Size = Vector3.new(0.27757716, 0.07, 0.05),
            Color = v6,
            Material = Enum.Material.Metal,
            CFrame = CFrame.Angles(0, v18, 0) * CFrame.new(0, -0.05, -0.74)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v19, v20 in t6 do
            Part[v19] = v20
        end

        Part.Parent = Model
    end

    for _, v21 in { -1, 1 } do
        local t7 = {
            Name = "Lug",
            Size = Vector3.new(0.08, 0.22, 0.22),
            Shape = Enum.PartType.Cylinder,
            Color = v6,
            Material = Enum.Material.Metal,
            CFrame = CFrame.new(v21 * 0.84, 0.5700000000000001, 0)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v22, v23 in t7 do
            Part[v22] = v23
        end

        Part.Parent = Model
    end

    local function arc(p9) -- line: 88
        local v24 = p9 * 3.141592653589793

        return (Vector3.new(math.cos(v24) * 0.87, math.sin(v24) * 0.87 * 1.05 + 0.5700000000000001, 0))
    end

    for i = 1, 14 do
        local v27 = (i - 1) / 14 * 3.141592653589793
        local v30 = Vector3.new(math.cos(v27) * 0.87, math.sin(v27) * 0.87 * 1.05 + 0.5700000000000001, 0)
        local v31 = i / 14 * 3.141592653589793
        local v34 = Vector3.new(math.cos(v31) * 0.87, math.sin(v31) * 0.87 * 1.05 + 0.5700000000000001, 0)
        local t8 = {
            Name = "Handle",
            Size = Vector3.new(0.07, 0.07, (v34 - v30).Magnitude + 0.03),
            Color = v6,
            Material = Enum.Material.Metal,
            CFrame = CFrame.lookAt((v30 + v34) / 2, v34)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v36, v37 in t8 do
            Part[v36] = v37
        end

        Part.Parent = Model
    end

    local t9 = {
        Name = "Grip",
        Size = Vector3.new(0.42, 0.15, 0.15),
        Shape = Enum.PartType.Cylinder,
        Color = Color3.fromRGB(120, 78, 44),
        Material = Enum.Material.Wood,
        CFrame = CFrame.new(0, 1.4835, 0)
    }
    local Part3 = Instance.new("Part")

    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanQuery = false
    Part3.CanTouch = false

    local Smooth5, Smooth6 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part3.TopSurface = Smooth5
    Part3.BottomSurface = Smooth6

    for v38, v39 in t9 do
        Part3[v38] = v39
    end

    Part3.Parent = Model
    Model.PrimaryPart = Part
    Model.Parent = p8

    return Model
end

function t1.chair(p10, p11) -- line: 105
    local Model = Instance.new("Model")

    Model.Name = "Chair"

    local v40 = Color3.fromRGB(176, 120, 72)
    local v41 = Color3.fromRGB(120, 78, 44)
    local t10 = {
        Name = "Seat",
        Size = Vector3.new(2.3, 0.22, 2.1),
        Color = v40,
        Material = Enum.Material.Wood,
        CFrame = CFrame.new(0, p11 - 0.11, 0)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v42, v43 in t10 do
        Part[v42] = v43
    end

    Part.Parent = Model

    for _, v44 in { -1, 1 } do
        for _, v45 in { -1, 1 } do
            local t11 = {
                Name = "Leg",
                Size = Vector3.new(0.2, p11 - 0.22, 0.2),
                Color = v41,
                Material = Enum.Material.Wood,
                CFrame = CFrame.new(v44 * 0.95, (p11 - 0.22) / 2, v45 * 0.85)
            }
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false

            local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

            Part.TopSurface = Smooth
            Part.BottomSurface = Smooth2

            for v47, v48 in t11 do
                Part[v47] = v48
            end

            Part.Parent = Model
        end

        local t12 = {
            Name = "Upright",
            Size = Vector3.new(0.2, 2.2, 0.2),
            Color = v41,
            Material = Enum.Material.Wood,
            CFrame = CFrame.new(v44 * 0.95, p11 + 1.1, 0.95) * CFrame.Angles(-0.13962634015954636, 0, 0)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v49, v50 in t12 do
            Part[v49] = v50
        end

        Part.Parent = Model
    end

    for i = 1, 3 do
        local t13 = {
            Name = "Slat",
            Size = Vector3.new(2.1, 0.32, 0.12),
            Color = v40,
            Material = Enum.Material.Wood,
            CFrame = CFrame.new(0, p11 + 0.5 + i * 0.5, i * 0.07 + 1) * CFrame.Angles(-0.13962634015954636, 0, 0)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v51, v52 in t13 do
            Part[v51] = v52
        end

        Part.Parent = Model
    end

    Model.WorldPivot = CFrame.identity
    Model.Parent = p10

    return Model
end

function t1.rod(p12, p13) -- line: 128
    -- upvalues: RodBuilder (copy)
    local RodModel = p13:FindFirstChild("RodModel")
    local identity = CFrame.identity
    local v53

    if RodModel then
        v53 = RodModel:Clone()

        local v54 = v53:FindFirstChild("CarryWeld", true)
        local CFrame = identity

        if v54 then
            if v53.PrimaryPart then
                CFrame = v53.PrimaryPart.CFrame * v54.C1:Inverse()
            elseif v53.PrimaryPart then
                CFrame = v53.PrimaryPart.CFrame
            end

            v54:Destroy()
        elseif v53.PrimaryPart then
            CFrame = v53.PrimaryPart.CFrame
        end

        identity = CFrame
    else
        v53 = RodBuilder.build(1)
    end

    v53.Name = "PropRod"

    for _, descendant in v53:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.LocalTransparencyModifier = 0
        end
    end

    if v53.PrimaryPart then
        v53.PrimaryPart.PivotOffset = v53.PrimaryPart.CFrame:ToObjectSpace(identity)
    else
        v53.WorldPivot = identity
    end

    local v55 = v53:FindFirstChild("Tip", true)
    local v56 = if v55 then identity:PointToObjectSpace(v55.Position).Magnitude else 7

    v53.Parent = p12

    return v53, v56
end

function t1.line(p14, p15) -- line: 168
    local t14 = {
        Name = "Bobber",
        Size = Vector3.new(0.7, 0.7, 0.7),
        Shape = Enum.PartType.Ball,
        Color = Color3.fromRGB(230, 50, 50),
        Material = Enum.Material.SmoothPlastic,
        CFrame = CFrame.new(p15)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v57, v58 in t14 do
        Part[v57] = v58
    end

    Part.Parent = p14

    local t15 = {
        Name = "Cap",
        Size = Vector3.new(0.5, 0.5, 0.5),
        Shape = Enum.PartType.Ball,
        Color = Color3.new(1, 1, 1),
        Material = Enum.Material.SmoothPlastic,
        CFrame = CFrame.new(p15 + Vector3.new(0, 0.25, 0))
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false

    local Smooth3, Smooth4 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part2.TopSurface = Smooth3
    Part2.BottomSurface = Smooth4

    for v59, v60 in t15 do
        Part2[v59] = v60
    end

    Part2.Parent = Part

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 0.4, 0)
    Attachment.Parent = Part

    local Beam = Instance.new("Beam")

    Beam.Attachment1 = Attachment
    Beam.Width0 = 0.05
    Beam.Width1 = 0.05
    Beam.Color = ColorSequence.new(Color3.fromRGB(235, 235, 235))
    Beam.LightInfluence = 0.6
    Beam.FaceCamera = true
    Beam.CurveSize0 = -1.5
    Beam.Parent = Part

    return function(p16, p17) -- line: 182
        -- upvalues: p15 (copy), Part (copy), Beam (copy)
        local v61 = p16 and p16:FindFirstChild("RodTip", true)

        Beam.Attachment0 = v61
        Beam.Enabled = v61 ~= nil

        local v63 = math.sin(p17 * 2.2 + p15.X) * 0.12

        Part.CFrame = CFrame.new(p15 + Vector3.new(0, v63, 0))
        Part.Cap.CFrame = CFrame.new(p15 + Vector3.new(0, v63 + 0.25, 0))
    end
end

function t1.eye(p18, p19, p20) -- line: 201
    local Folder = Instance.new("Folder")

    Folder.Name = "Eye"
    Folder.Parent = p18

    local v65 = CFrame.lookAt(p19, p19 + p20)
    local v66 = Color3.fromRGB(165, 245, 180)
    local v67 = Color3.fromRGB(108, 180, 126)
    local v68 = Color3.fromRGB(205, 255, 215)

    local function shade(p21, p22, p23) -- line: 212
        local v70 = math.sqrt(p22 * p22 + (p23 * 1.3) ^ 2)

        return p21:Lerp(Color3.new(0, 0, 0), (math.clamp((v70 - 6) / 15, 0, 0.95)))
    end

    local t16 = {
        Name = "Head",
        Color = Color3.fromRGB(36, 60, 42),
        Material = Enum.Material.Slate,
        CFrame = v65 * CFrame.new((Vector3.new(-4, 3, 18.5)))
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v73, v74 in t16 do
        Part[v73] = v74
    end

    Part.Parent = Folder
    Part.Size = Vector3.new(1, 1, 1)

    local SpecialMesh = Instance.new("SpecialMesh")

    SpecialMesh.MeshType = Enum.MeshType.Sphere
    SpecialMesh.Parent = Part
    SpecialMesh.Scale = Vector3.new(110, 60, 44)

    local function skin(p24, p25) -- line: 221
        return 18.5 - math.sqrt((math.max(1 - ((p24 - -4) / 55) ^ 2 - ((p25 - 3) / 30) ^ 2, 0))) * 22
    end

    local t17 = {
        Name = "Brow",
        Color = v67:Lerp(Color3.new(0, 0, 0), 0.07666666666666669),
        Material = Enum.Material.Slate,
        CFrame = v65 * CFrame.new(0.5, 6.9, -1.6) * CFrame.Angles(0, 0, -0.12217304763960307)
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false

    local Smooth3, Smooth4 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part2.TopSurface = Smooth3
    Part2.BottomSurface = Smooth4

    for v77, v78 in t17 do
        Part2[v77] = v78
    end

    Part2.Parent = Folder
    Part2.Size = Vector3.new(1, 1, 1)

    local SpecialMesh2 = Instance.new("SpecialMesh")

    SpecialMesh2.MeshType = Enum.MeshType.Sphere
    SpecialMesh2.Parent = Part2
    SpecialMesh2.Scale = Vector3.new(25, 5, 7)

    local t18 = {
        Name = "Cheek",
        Color = v67:Lerp(Color3.new(0, 0, 0), 0.07666666666666669),
        Material = Enum.Material.Slate,
        CFrame = v65 * CFrame.new(-0.5, -7.1, -2.6) * CFrame.Angles(0, 0, 0.06981317007977318)
    }
    local Part3 = Instance.new("Part")

    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanQuery = false
    Part3.CanTouch = false

    local Smooth5, Smooth6 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part3.TopSurface = Smooth5
    Part3.BottomSurface = Smooth6

    for v79, v80 in t18 do
        Part3[v79] = v80
    end

    Part3.Parent = Folder
    Part3.Size = Vector3.new(1, 1, 1)

    local SpecialMesh3 = Instance.new("SpecialMesh")

    SpecialMesh3.MeshType = Enum.MeshType.Sphere
    SpecialMesh3.Parent = Part3
    SpecialMesh3.Scale = Vector3.new(21, 3.6, 7)

    local v81 = Random.new(7)

    for i = 1, 60 do
        local v82 = i / 60 * 3.141592653589793 * 2 * 3 + v81:NextNumber(-0.15, 0.15)
        local v83 = v81:NextNumber(7.5, 22)
        local v84 = math.cos(v82) * v83 * 1.3
        local v85 = math.sin(v82) * v83 * 0.8
        local v86 = 1.1 + v83 * 0.08
        local t19 = {
            Name = "Scale"
        }
        local v87 = (if i % 3 == 0 then v68 else v66):Lerp(v67, v81:NextNumber(0, 0.4))
        local v89 = math.sqrt(v84 * v84 + (v85 * 1.3) ^ 2)

        t19.Color = v87:Lerp(Color3.new(0, 0, 0), (math.clamp((v89 - 6) / 15, 0, 0.95)))
        t19.Material = Enum.Material.Slate
        t19.CFrame = v65 * CFrame.new(v84, v85, 18.5 - math.sqrt((math.max(1 - ((v84 - -4) / 55) ^ 2 - ((v85 - 3) / 30) ^ 2, 0))) * 22 + 0.2) * CFrame.Angles(0, 0, v82 + 1.5707963267948966)

        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v94, v95 in t19 do
            Part[v94] = v95
        end

        Part.Parent = Folder
        Part.Size = Vector3.new(1, 1, 1)

        local SpecialMesh = Instance.new("SpecialMesh")

        SpecialMesh.MeshType = Enum.MeshType.Sphere
        SpecialMesh.Parent = Part
        SpecialMesh.Scale = Vector3.new(v86 * 1.6, v86, v86 * 0.7)
    end

    for i = -2, 2 do
        local v98 = i * 5 + 1
        local v99 = 11 - math.abs(i) * 0.6
        local t20 = {
            Name = "Spine"
        }
        local v101 = math.sqrt(v98 * v98 + (v99 * 1.3) ^ 2)

        t20.Color = v67:Lerp(Color3.new(0, 0, 0), (math.clamp((v101 - 6) / 15, 0, 0.95)))
        t20.Material = Enum.Material.Slate
        t20.CFrame = v65 * CFrame.new(v98, v99 + 2.5, 18.5 - math.sqrt((math.max(1 - ((v98 - -4) / 55) ^ 2 - ((v99 - 3) / 30) ^ 2, 0))) * 22 + 1.5) * CFrame.Angles(-0.4363323129985824, 0, (math.rad(-i * 6)))

        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

        Part.TopSurface = Smooth
        Part.BottomSurface = Smooth2

        for v108, v109 in t20 do
            Part[v108] = v109
        end

        Part.Parent = Folder
        Part.Size = Vector3.new(1, 1, 1)

        local SpecialMesh = Instance.new("SpecialMesh")

        SpecialMesh.MeshType = Enum.MeshType.Sphere
        SpecialMesh.Parent = Part
        SpecialMesh.Scale = Vector3.new(1.6, 7 - math.abs(i), 1.6)
    end

    local t21 = {
        Name = "Lid",
        Color = Color3.fromRGB(120, 162, 132),
        Material = Enum.Material.Slate,
        CFrame = v65
    }
    local Part4 = Instance.new("Part")

    Part4.Anchored = true
    Part4.CanCollide = false
    Part4.CanQuery = false
    Part4.CanTouch = false

    local Smooth7, Smooth8 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part4.TopSurface = Smooth7
    Part4.BottomSurface = Smooth8

    for v111, v112 in t21 do
        Part4[v111] = v112
    end

    Part4.Parent = Folder
    Part4.Size = Vector3.new(1, 1, 1)

    local SpecialMesh4 = Instance.new("SpecialMesh")

    SpecialMesh4.MeshType = Enum.MeshType.Sphere
    SpecialMesh4.Parent = Part4
    SpecialMesh4.Scale = Vector3.new(17, 12, 11)

    local t22 = {
        Name = "Rim",
        Color = Color3.fromRGB(8, 10, 8),
        Material = Enum.Material.SmoothPlastic,
        CFrame = v65 * CFrame.new(0, 0, -1.2)
    }
    local Part5 = Instance.new("Part")

    Part5.Anchored = true
    Part5.CanCollide = false
    Part5.CanQuery = false
    Part5.CanTouch = false

    local Smooth9, Smooth10 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part5.TopSurface = Smooth9
    Part5.BottomSurface = Smooth10

    for v113, v114 in t22 do
        Part5[v113] = v114
    end

    Part5.Parent = Folder
    Part5.Size = Vector3.new(1, 1, 1)

    local SpecialMesh5 = Instance.new("SpecialMesh")

    SpecialMesh5.MeshType = Enum.MeshType.Sphere
    SpecialMesh5.Parent = Part5

    local t23 = {
        Name = "Iris",
        Color = Color3.fromRGB(255, 120, 10),
        Material = Enum.Material.Neon,
        CFrame = v65 * CFrame.new(0, 0, -2)
    }
    local Part6 = Instance.new("Part")

    Part6.Anchored = true
    Part6.CanCollide = false
    Part6.CanQuery = false
    Part6.CanTouch = false

    local Smooth11, Smooth12 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part6.TopSurface = Smooth11
    Part6.BottomSurface = Smooth12

    for v115, v116 in t23 do
        Part6[v115] = v116
    end

    Part6.Parent = Folder
    Part6.Size = Vector3.new(1, 1, 1)

    local SpecialMesh6 = Instance.new("SpecialMesh")

    SpecialMesh6.MeshType = Enum.MeshType.Sphere
    SpecialMesh6.Parent = Part6

    local t24 = {
        Name = "Pupil",
        Color = Color3.new(0, 0, 0),
        Material = Enum.Material.SmoothPlastic,
        CFrame = v65 * CFrame.new(0, 0, -3)
    }
    local Part7 = Instance.new("Part")

    Part7.Anchored = true
    Part7.CanCollide = false
    Part7.CanQuery = false
    Part7.CanTouch = false

    local Smooth13, Smooth14 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part7.TopSurface = Smooth13
    Part7.BottomSurface = Smooth14

    for v117, v118 in t24 do
        Part7[v117] = v118
    end

    Part7.Parent = Folder
    Part7.Size = Vector3.new(1, 1, 1)

    local SpecialMesh7 = Instance.new("SpecialMesh")

    SpecialMesh7.MeshType = Enum.MeshType.Sphere
    SpecialMesh7.Parent = Part7

    local t25 = {
        Name = "Glow",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1,
        CFrame = v65 * CFrame.new(0, 0, -8)
    }
    local Part8 = Instance.new("Part")

    Part8.Anchored = true
    Part8.CanCollide = false
    Part8.CanQuery = false
    Part8.CanTouch = false

    local Smooth15, Smooth16 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part8.TopSurface = Smooth15
    Part8.BottomSurface = Smooth16

    for v119, v120 in t25 do
        Part8[v119] = v120
    end

    Part8.Parent = Folder

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(255, 140, 50)
    PointLight.Range = 0
    PointLight.Brightness = 3
    PointLight.Shadows = false
    PointLight.Parent = Part8

    local SurfaceLight = Instance.new("SurfaceLight")

    SurfaceLight.Face = Enum.NormalId.Front
    SurfaceLight.Color = Color3.fromRGB(255, 170, 60)
    SurfaceLight.Angle = 120
    SurfaceLight.Range = 0
    SurfaceLight.Brightness = 6
    SurfaceLight.Parent = Part6

    local t26 = {}

    for _, descendant in Folder:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= Part6 and descendant ~= Part7 then
            t26[descendant] = descendant.Color
        end
    end

    local n1 = 0

    local function open(p26, p27) -- line: 283
        -- upvalues: SpecialMesh5 (copy), Part6 (copy), SpecialMesh6 (copy), SpecialMesh7 (copy), PointLight (copy), SurfaceLight (copy), t26 (copy), n1 (ref)
        n1 = p26
        p27 = p27 or 0

        for v122, v123 in t26 do
            v122.Color = Color3.new(0, 0, 0):Lerp(v123, p26)
        end

        SpecialMesh5.Scale = Vector3.new(13, p26 * 8 + 0.5, 9.6)
        SpecialMesh6.Scale = Vector3.new(12, p26 * 7 + 0.2, 8.6)
        SpecialMesh7.Scale = Vector3.new(p27 * -1.6999999999999997 + 2.8, p26 * 5.6000000000000005 + 0.1, 7)
        PointLight.Range = p26 * 26
        SurfaceLight.Range = p26 * 30
        Part6.Transparency = p26 <= 0.001 and 1 or 0
    end

    local function look(p28) -- line: 297
        -- upvalues: v65 (copy), Part7 (copy), n1 (ref)
        Part7.CFrame = v65 * CFrame.new(p28.X, p28.Y * n1, -3)
    end

    open(0)

    return Folder, open, look
end

function t1.backdrop(p29, p30, p31) -- line: 306
    local t27 = {
        Name = "Backdrop",
        Size = Vector3.new(900, 80, 2),
        CastShadow = false,
        Color = Color3.new(0, 0, 0),
        Material = Enum.Material.SmoothPlastic,
        CFrame = CFrame.lookAt(p30, p30 + p31)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v128, v129 in t27 do
        Part[v128] = v129
    end

    Part.Parent = p29
end

function t1.specks(p32) -- line: 311
    local t28 = {
        Name = "Specks",
        Size = Vector3.new(26, 18, 10),
        Transparency = 1
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v130, v131 in t28 do
        Part[v130] = v131
    end

    Part.Parent = p32

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(190, 220, 255))
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.LightEmission = 0.4
    ParticleEmitter.Size = NumberSequence.new(0.07)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(2, 3.5)
    ParticleEmitter.Speed = NumberRange.new(0.2, 0.6)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Rate = 40
    ParticleEmitter.Parent = Part

    return Part
end

local t29, ColorCorrectionEffect

function t1.underwater(p33) -- line: 335
    -- upvalues: Lighting (copy), SoundService (copy), t29 (ref), ColorCorrectionEffect (ref)
    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    local BossArena = workspace:FindFirstChild("BossArena")
    local Sea = BossArena and BossArena:FindFirstChild("Sea")

    if not t29 then
        t29 = {
            Density = Atmosphere and Atmosphere.Density,
            Color = Atmosphere and Atmosphere.Color,
            Decay = Atmosphere and Atmosphere.Decay,
            Haze = Atmosphere and Atmosphere.Haze,
            Glare = Atmosphere and Atmosphere.Glare,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            Diffuse = Lighting.EnvironmentDiffuseScale,
            Specular = Lighting.EnvironmentSpecularScale,
            Reverb = SoundService.AmbientReverb
        }
        ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
        ColorCorrectionEffect.Name = "BossIntroTint"
        ColorCorrectionEffect.Parent = Lighting
    end

    if Sea then
        Sea.CastShadow = p33 <= 0
    end

    if p33 <= 0 then
        ColorCorrectionEffect.Enabled = false

        if Atmosphere and t29.Density then
            local Density, Color, Decay, Haze = t29.Density, t29.Color, t29.Decay, t29.Haze
            local Glare = t29.Glare

            Atmosphere.Density = Density
            Atmosphere.Color = Color
            Atmosphere.Decay = Decay
            Atmosphere.Haze = Haze
            Atmosphere.Glare = Glare
        end

        local Ambient, OutdoorAmbient = t29.Ambient, t29.OutdoorAmbient

        Lighting.Ambient = Ambient
        Lighting.OutdoorAmbient = OutdoorAmbient

        local Brightness, Diffuse, Specular = t29.Brightness, t29.Diffuse, t29.Specular

        Lighting.Brightness = Brightness
        Lighting.EnvironmentDiffuseScale = Diffuse
        Lighting.EnvironmentSpecularScale = Specular
        SoundService.AmbientReverb = t29.Reverb
    else
        SoundService.AmbientReverb = Enum.ReverbType.UnderWater

        local v132 = p33 ^ 1.4

        ColorCorrectionEffect.Enabled = true
        ColorCorrectionEffect.TintColor = Color3.fromRGB(170, 215, 255):Lerp(Color3.fromRGB(80, 120, 200), p33)
        ColorCorrectionEffect.Brightness = -0.08 - v132 * 0.12
        ColorCorrectionEffect.Contrast = p33 * 0.15 + 0.08
        ColorCorrectionEffect.Saturation = p33 * -0.1
        Lighting.Brightness = (t29.Brightness or 2) * (1 - v132)
        Lighting.EnvironmentDiffuseScale = (t29.Diffuse or 1) * (1 - v132)
        Lighting.EnvironmentSpecularScale = (t29.Specular or 1) * (1 - v132)
        Lighting.Ambient = Color3.fromRGB(110, 150, 190):Lerp(Color3.fromRGB(4, 6, 10), v132)
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 160, 200):Lerp(Color3.fromRGB(4, 6, 10), v132)

        if Atmosphere then
            Atmosphere.Density = p33 * 0.3 + 0.42
            Atmosphere.Color = Color3.fromRGB(60, 130, 175):Lerp(Color3.fromRGB(2, 5, 10), v132)
            Atmosphere.Decay = Color3.fromRGB(35, 85, 125):Lerp(Color3.fromRGB(0, 2, 6), v132)
            Atmosphere.Haze = 2
            Atmosphere.Glare = 0
        end
    end
end

function t1.eyeGlow(p34) -- line: 394
    -- upvalues: Lighting (copy), ColorCorrectionEffect (ref)
    local v133 = Color3.fromRGB(4, 6, 10):Lerp(Color3.fromRGB(150, 118, 96), p34)

    Lighting.Ambient = v133
    Lighting.OutdoorAmbient = v133

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if Atmosphere then
        local Density = Atmosphere.Density

        Atmosphere.Density = Density + (0.3 - Density) * p34

        local Haze = Atmosphere.Haze

        Atmosphere.Haze = Haze + (0 - Haze) * p34
        Atmosphere.Color = Atmosphere.Color:Lerp(Color3.new(0, 0, 0), p34)
        Atmosphere.Decay = Atmosphere.Decay:Lerp(Color3.new(0, 0, 0), p34)
    end

    if not (ColorCorrectionEffect and ColorCorrectionEffect.Enabled) then
        return
    end

    ColorCorrectionEffect.TintColor = ColorCorrectionEffect.TintColor:Lerp(Color3.fromRGB(255, 220, 190), p34)
    ColorCorrectionEffect.Brightness += p34 * 0.12
    ColorCorrectionEffect.Saturation = p34 * 0.25
    ColorCorrectionEffect.Contrast += p34 * 0.1
end

function t1.restoreLight() -- line: 412
    -- upvalues: t1 (copy), t29 (ref), ColorCorrectionEffect (ref)
    if t29 then
        t1.underwater(0)

        if ColorCorrectionEffect then
            ColorCorrectionEffect:Destroy()
            ColorCorrectionEffect = nil
        end

        t29 = nil
    end
end

return t1

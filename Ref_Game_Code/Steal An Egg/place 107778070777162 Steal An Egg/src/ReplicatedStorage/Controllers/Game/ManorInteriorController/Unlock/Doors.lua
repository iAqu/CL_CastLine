-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = table.freeze({ "Door1", "Door2" })
local v2 = Color3.fromRGB(9, 5, 7)
local v3 = Color3.fromRGB(210, 190, 200)
local v4 = Color3.fromRGB(255, 168, 86)
local v5 = table.freeze({
    {
        Up = 0.35,
        Out = 1.5,
        Range = 30,
        Brightness = 1.1
    },
    {
        Up = 0.12,
        Out = 2.5,
        Range = 18,
        Brightness = 0.5
    },
    {
        Up = 0.3,
        Out = -12,
        Range = 28,
        Brightness = 1.2
    },
    {
        Up = 0.3,
        Out = -24,
        Range = 26,
        Brightness = 1
    }
})
local v6 = Color3.fromRGB(34, 20, 30)
local v7 = Color3.fromRGB(16, 9, 14)
local v8 = Color3.fromRGB(96, 20, 26)
local v9 = Color3.fromRGB(176, 128, 52)
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local t5 = {
    OpenAngle = 1.3962634015954636
}

local function flat(p1, p2) -- line: 77
    local v12 = Vector3.new(p1.X, 0, p1.Z)

    if v12.Magnitude > 0.01 then
        return v12.Unit
    end

    return p2
end

local function closedPivot(p3) -- line: 82
    local ManorClosedPivot = p3:GetAttribute("ManorClosedPivot")

    if typeof(ManorClosedPivot) == "CFrame" then
        return ManorClosedPivot
    end

    local Pivot = p3:GetPivot()

    p3:SetAttribute("ManorClosedPivot", Pivot)

    return Pivot
end

local function measure(p4, p5) -- line: 92
    local Pivot = p4:GetPivot()

    if Pivot ~= p5 then
        p4:PivotTo(p5)
    end

    local BoundingBox, BoundingBox2 = p4:GetBoundingBox()

    if Pivot ~= p5 then
        p4:PivotTo(Pivot)
    end

    return BoundingBox, BoundingBox2
end

local function inwardOf(p6, p7, p8) -- line: 104
    local v13 = p8 == nil
    local v14, v15

    if not v13 then
        v14 = p7 - p8:GetBoundingBox().Position
        v15 = Vector3.new(v14.X, 0, v14.Z).Magnitude > 0.5
    end

    if v13 or not v15 then
        local ManorInward = p6:GetAttribute("ManorInward")

        if typeof(ManorInward) == "Vector3" then
            return ManorInward
        end

        local LookVector = p6:GetPivot().LookVector
        local v16 = Vector3.new(LookVector.X, 0, LookVector.Z)

        if v16.Magnitude > 0.01 then
            return v16.Unit
        end
    else
        local v17 = Vector3.new(v14.X, 0, v14.Z)

        if v17.Magnitude > 0.01 then
            return v17.Unit
        end
    end

    return (Vector3.new(0, 0, 1))
end

local function build(p9, p10) -- line: 119
    -- upvalues: v1 (copy), inwardOf (copy)
    local t6 = {}

    for _, v18 in v1 do
        local v19 = p9:FindFirstChild(v18)

        if v19 ~= nil and v19:IsA("Model") then
            local ManorClosedPivot = v19:GetAttribute("ManorClosedPivot")

            if typeof(ManorClosedPivot) ~= "CFrame" then
                ManorClosedPivot = v19:GetPivot()
                v19:SetAttribute("ManorClosedPivot", ManorClosedPivot)
            end

            local Pivot = v19:GetPivot()

            if Pivot ~= ManorClosedPivot then
                v19:PivotTo(ManorClosedPivot)
            end

            local BoundingBox, BoundingBox2 = v19:GetBoundingBox()

            if Pivot ~= ManorClosedPivot then
                v19:PivotTo(Pivot)
            end

            table.insert(t6, {
                Door = v19,
                Closed = ManorClosedPivot,
                Box = BoundingBox,
                Size = BoundingBox2
            })
        end
    end

    if #t6 == 0 then
        return nil
    end

    local v20 = Vector3.new(0, 0, 0)
    local n1 = 1e999
    local n2 = (-1e999)

    for _, v21 in t6 do
        v20 += v21.Box.Position
        n1 = math.min(n1, v21.Box.Position.Y - v21.Size.Y / 2)
        n2 = math.max(n2, v21.Box.Position.Y + v21.Size.Y / 2)
    end

    local v24 = v20 / #t6
    local v25 = inwardOf(p9, v24, p10)

    p9:SetAttribute("ManorInward", v25)

    local Unit = (Vector3.new(0, 1, 0)):Cross(v25).Unit
    local t8 = {}
    local n3 = 0
    local n4 = 0

    for _, v26 in t6 do
        local Box = v26.Box
        local v30 = math.abs((Box.RightVector:Dot(Unit))) * v26.Size.X + math.abs((Box.LookVector:Dot(Unit))) * v26.Size.Z
        local v34 = math.abs((Box.RightVector:Dot(v25))) * v26.Size.X + math.abs((Box.LookVector:Dot(v25))) * v26.Size.Z

        n4 = math.max(n4, v34)

        local v35 = (Box.Position - v24):Dot(Unit)

        n3 = math.max(n3, math.abs(v35) + v30 / 2)

        local v37 = if v35 >= 0 then 1 else -1
        local v38 = Box.Position + Unit * (v37 * v30 / 2) - v25 * (v34 / 2)
        local v39 = CFrame.new(v38.X, Box.Position.Y, v38.Z)
        local v40 = if ((v39 * CFrame.Angles(0, 1.3962634015954636, 0) * v39:Inverse() * Box).Position - Box.Position):Dot(v25) <= 0 then 1.3962634015954636 else -1.3962634015954636

        table.insert(t8, {
            Door = v26.Door,
            Closed = v26.Closed,
            Hinge = v39,
            Angle = v40,
            Reach = v30
        })
    end

    local v41 = Vector3.new(v24.X, n1, v24.Z)

    return {
        Doors = p9,
        Swings = t8,
        Frame = CFrame.lookAt(v41, v41 + v25),
        Width = n3 * 2,
        Height = n2 - n1,
        Depth = n4
    }
end

local function slab(p11, p12, p13, p14, p15) -- line: 181
    local Part = Instance.new("Part")

    Part.Name = p12
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.WoodPlanks
    Part.Color = p15
    Part.Size = p14
    Part.CFrame = p13
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Parent = p11

    return Part
end

local function floorLift(p16) -- line: 199
    -- upvalues: Players (copy), Workspace (copy)
    local t10 = {
        p16.Doors
    }

    for _, player in Players:GetPlayers() do
        if player.Character ~= nil then
            table.insert(t10, player.Character)
        end
    end

    local v42 = RaycastParams.new()

    v42.FilterType = Enum.RaycastFilterType.Exclude
    v42.FilterDescendantsInstances = t10
    v42.IgnoreWater = true

    local v43 = Workspace:Raycast((p16.Frame * CFrame.new(0, 15, 4)).Position, Vector3.new(-0, -30, -0, -0), v42)

    if v43 == nil then
        return 0
    end

    return (math.clamp(v43.Position.Y - p16.Frame.Position.Y, 0, 15))
end

local function hall(p17, p18) -- line: 218
    -- upvalues: v6 (copy), v7 (copy), v8 (copy), v9 (copy), slab (copy), floorLift (copy)
    local Frame, Width, Height = p18.Frame, p18.Width, p18.Height
    local v45 = floorLift(p18)

    slab(p17, "Carpet", Frame * CFrame.new(0, v45 - 0.5, -15), Vector3.new(Width, 1, 30), v8).Material = Enum.Material.Fabric

    for _, v46 in { -1, 1 } do
        slab(p17, "Trim", Frame * CFrame.new(v46 * Width * 0.18, v45 + 0.03, -15), Vector3.new(1.4, 0.06, 30), v9).Material = Enum.Material.Fabric
        slab(p17, "Wall", Frame * CFrame.new(v46 * (Width / 2 + 0.5), Height / 2, -15), Vector3.new(1, Height, 30), v6)
    end

    slab(p17, "Ceiling", Frame * CFrame.new(0, Height + 0.5, -15), Vector3.new(Width + 2, 1, 30), v7).Material = Enum.Material.SmoothPlastic
end

local function flicker(p19, p20) -- line: 258
    -- upvalues: RunService (copy)
    local v49 = math.random() * 100

    p19.Trove:Connect(RunService.Heartbeat, function() -- line: 260
        -- upvalues: p19 (copy), p20 (copy), v49 (copy)
        local v50 = os.clock() + v49
        local v53 = 0.92 + math.noise(v50 * 3.1, 0.5) * 0.12 + math.sin(v50 * 17) * 0.02

        for v54, v55 in p19.Lights do
            v55.Brightness = p20[v54] * p19.Lit * v53
        end

        p19.Room.ImageTransparency = 1 - math.clamp(p19.Lit * (0.9 + v53 * 0.1), 0, 1)
    end)
end

function t5.Rig(p21, p22) -- line: 274
    -- upvalues: self (copy), build (copy)
    local v57 = self[p21]

    if v57 ~= nil then
        return v57
    end

    local v58 = build(p21, p22)

    if v58 ~= nil then
        self[p21] = v58
    end

    return v58
end

function t5.PoseSwing(p23, p24, p25) -- line: 286
    local v59 = p23.Swings[p24]

    if v59 ~= nil then
        local v60 = v59.Hinge * CFrame.Angles(0, v59.Angle * p25, 0) * v59.Hinge:Inverse()

        v59.Door:PivotTo(v60 * v59.Closed)
    end
end

function t5.Pose(p26, p27) -- line: 295
    -- upvalues: t5 (copy)
    for v61 in p26.Swings do
        t5.PoseSwing(p26, v61, p27)
    end
end

function t5.Tip(p28, p29) -- line: 301
    local v62 = p28.Swings[p29]

    return if v62 ~= nil then v62.Door:GetBoundingBox().Position * 2 - v62.Hinge.Position else nil
end

function t5.Leaf(p30, p31) -- line: 309
    local v63 = p30.Swings[p31]

    if v63 == nil then
        return nil, nil, 0
    end

    local HingePosition = v63.Hinge.Position
    local v64 = p30.Frame.Position - HingePosition
    local RightVector = p30.Frame.RightVector
    local v65 = Vector3.new(v64.X, 0, v64.Z)

    if v65.Magnitude > 0.01 then
        RightVector = v65.Unit
    end

    local RightVector2 = p30.Frame.RightVector

    if not (RightVector:Dot(RightVector2) >= 0) then
        RightVector2 = -RightVector2
    end

    local v66 = (v63.Door:GetPivot() * v63.Closed:Inverse()).Rotation:VectorToWorldSpace(RightVector2)
    local v67 = Vector3.new(v66.X, 0, v66.Z)

    if v67.Magnitude > 0.01 then
        RightVector2 = v67.Unit
    end

    return HingePosition, RightVector2, v63.Reach
end

function t5.Point(p32, p33, p34, p35) -- line: 322
    return (p32.Frame * CFrame.new(-p33, p34, -p35)).Position
end

function t5.Inward(p36) -- line: 326
    return p36.Frame.LookVector
end

function t5.Clearing(p37, p38, p39) -- line: 330
    local Frame = p37.Frame
    local v68 = Frame:PointToObjectSpace(p38)
    local v69 = false
    local v70 = p37.Depth / 2

    for _, v71 in p37.Swings do
        local v72 = Frame:PointToObjectSpace(v71.Hinge.Position)
        local v73 = v71.Reach + p39
        local v74 = v68.X - v72.X
        local v75 = v68.Z - v72.Z

        if math.abs(v68.X) < math.abs(v72.X) + p39 and -p39 < v75 and v74 * v74 + v75 * v75 < v73 * v73 then
            v69 = true
        end

        local v77 = math.abs(v72.X)

        v70 = math.max(v70, v72.Z + math.sqrt((math.max(v73 * v73 - v77 * v77, 0))) + 0.5)
    end

    if not v69 then
        return nil
    end

    return Frame:PointToWorldSpace((Vector3.new(0, v68.Y, (math.max(v68.Z, v70)))))
end

function t5.Foyer(p40) -- line: 353
    -- upvalues: self2 (copy)
    return self2[p40.Doors]
end

function t5.SetFoyer(p41, p42) -- line: 357
    -- upvalues: RunService (copy), Trove (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), self2 (copy), slab (copy), hall (copy)
    local v82 = self2[p41.Doors]

    if p42 then
        if v82 ~= nil and v82.Folder.Parent ~= nil then
            return v82
        end

        local v83 = Trove.new()
        local v84 = v83:Add(Instance.new("Folder"))

        v84.Name = "ManorFoyer"

        local Frame = p41.Frame

        hall(v84, p41)

        local v86 = slab(v84, "Veil", Frame * CFrame.new(0, p41.Height / 2, -30), Vector3.new(p41.Width, p41.Height, 0.2), v2)

        v86.Material = Enum.Material.SmoothPlastic

        local SurfaceGui = Instance.new("SurfaceGui")

        SurfaceGui.Name = "Glow"
        SurfaceGui.Face = Enum.NormalId.Back
        SurfaceGui.LightInfluence = 0
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        SurfaceGui.PixelsPerStud = 12
        SurfaceGui.ResetOnSpawn = false
        SurfaceGui.Parent = v86

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Shade"
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v2
        Frame2.Parent = SurfaceGui

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Room"
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://77767765912332"
        ImageLabel.ImageColor3 = v3
        ImageLabel.ImageTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        ImageLabel.Parent = SurfaceGui

        local t11 = {}
        local t12 = {}

        for _, v87 in v5 do
            local v88 = slab(v84, "Candle", Frame * CFrame.new(0, p41.Height * v87.Up, v87.Out), Vector3.new(0.2, 0.2, 0.2), v4)

            v88.Transparency = 1

            local PointLight = Instance.new("PointLight")

            PointLight.Color = v4
            PointLight.Range = v87.Range
            PointLight.Brightness = v87.Brightness
            PointLight.Shadows = false
            PointLight.Parent = v88
            table.insert(t11, PointLight)
            table.insert(t12, v87.Brightness)
        end

        local t13 = {
            Lit = 1,
            Folder = v84,
            Lights = t11,
            Room = ImageLabel,
            Trove = v83
        }
        local v89 = math.random() * 100

        t13.Trove:Connect(RunService.Heartbeat, function() -- line: 260
            -- upvalues: t12 (copy), t13 (copy), v89 (copy)
            local v90 = os.clock() + v89
            local v93 = 0.92 + math.noise(v90 * 3.1, 0.5) * 0.12 + math.sin(v90 * 17) * 0.02

            for v94, v95 in t13.Lights do
                v95.Brightness = t12[v94] * t13.Lit * v93
            end

            t13.Room.ImageTransparency = 1 - math.clamp(t13.Lit * (0.9 + v93 * 0.1), 0, 1)
        end)
        v84.Parent = p41.Doors
        self2[p41.Doors] = t13
        v83:Connect(v84.Destroying, function() -- line: 435
            -- upvalues: p41 (copy), t13 (copy), self2 (copy)
            if self2[p41.Doors] == t13 then
                self2[p41.Doors] = nil
            end
        end)

        return t13
    end

    if v82 ~= nil then
        self2[p41.Doors] = nil
        v82.Trove:Destroy()
    end

    return nil
end

return table.freeze(t5)

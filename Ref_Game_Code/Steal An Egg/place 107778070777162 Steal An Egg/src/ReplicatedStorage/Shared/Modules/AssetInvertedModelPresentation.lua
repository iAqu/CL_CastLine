-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local v1 = CFrame.Angles(0, 0, 3.141592653589793)
local t1 = {
    "Size",
    "CFrame",
    "PivotOffset",
    "RootPriority",
    "CollisionGroup"
}
local t2 = {
    Transparency = 1,
    CastShadow = false,
    Anchored = true,
    CanCollide = false,
    CanQuery = false,
    CanTouch = false,
    Massless = true
}
local t3 = {}

local function childOfClass(p1, p2, p3) -- line: 39
    local v4 = assert(p1:FindFirstChild(p2), (("%* lacks %*"):format(p1:GetFullName(), p2)))

    assert(v4:IsA(p3), (("%* should have been a %*"):format(v4:GetFullName(), p3)))

    return v4
end

local function parkWelds(p4) -- line: 45
    local t4 = {}

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("WeldConstraint") then
            t4[descendant] = descendant.Enabled
            descendant.Enabled = false
        end
    end

    return t4
end

local function unparkWelds(p5) -- line: 58
    for v7, v8 in p5 do
        v7.Enabled = v8
    end
end

local function assertStill(p6, p7, p8) -- line: 64
    local v9 = p6.XVector:Dot(p7.XVector)
    local v10 = p6.YVector:Dot(p7.YVector)
    local v11 = p6.ZVector:Dot(p7.ZVector)

    assert(not ((p6.Position - p7.Position).Magnitude > 1E-05 or v9 < 0.99999 or v10 < 0.99999 or v11 < 0.99999), (("%* shifted during the flip"):format(p8)))
end

local function standInFor(p9, p10) -- line: 77
    -- upvalues: t1 (copy), t2 (copy)
    local Part = Instance.new("Part")

    Part.Name = "HumanoidRootPart"

    for _, v14 in t1 do
        Part[v14] = p9[v14]
    end

    for v15, v16 in t2 do
        Part[v15] = v16
    end

    Part.Parent = p10

    return Part
end

function t3.Invert(p11) -- line: 92
    -- upvalues: t (copy), ModelBounds (copy), v1 (copy), t1 (copy), t2 (copy), childOfClass (copy), parkWelds (copy), assertStill (copy)
    t.strict(t.instanceIsA("Model"))(p11)

    local BasePart = childOfClass(p11, "HumanoidRootPart", "BasePart")
    local BasePart2 = childOfClass(p11, "CENTER", "BasePart")
    local Model = childOfClass(p11, "Model", "Model")
    local WeldConstraint = childOfClass(BasePart, "AssetWeld", "WeldConstraint")
    local WeldConstraint2 = childOfClass(BasePart2, "CenterWeld", "WeldConstraint")
    local CFrame = BasePart.CFrame
    local CFrame2 = BasePart2.CFrame
    local v17 = ModelBounds(p11)
    local v18 = v17:ToObjectSpace(Model:GetPivot())
    local v19 = parkWelds(p11)

    assert(v19[WeldConstraint] ~= nil, "AssetWeld escaped the parking sweep")
    assert(v19[WeldConstraint2] ~= nil, "CenterWeld escaped the parking sweep")
    Model:PivotTo(v17 * v1 * v18)
    BasePart.Name = "InvertedModelOriginalRoot"

    local Part = Instance.new("Part")

    Part.Name = "HumanoidRootPart"

    for _, v22 in t1 do
        Part[v22] = BasePart[v22]
    end

    for v23, v24 in t2 do
        Part[v23] = v24
    end

    Part.Parent = p11
    BasePart.Anchored = false

    local WeldConstraint3 = Instance.new("WeldConstraint")

    WeldConstraint3.Name = "InvertedModelRootWeld"
    WeldConstraint3.Part0 = Part
    WeldConstraint3.Part1 = BasePart
    WeldConstraint3.Parent = Part
    p11.PrimaryPart = Part

    for v25, v26 in v19 do
        v25.Enabled = v26
    end

    assertStill(Part.CFrame, CFrame, "the stand-in HumanoidRootPart")
    assertStill(BasePart2.CFrame, CFrame2, "CENTER")
end

return t3

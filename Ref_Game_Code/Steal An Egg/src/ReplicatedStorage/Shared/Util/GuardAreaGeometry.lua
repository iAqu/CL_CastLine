-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.Instance)
local v2 = t.strict(t.instanceIsA("BasePart"))
local v3 = t.strict(t.Vector3)
local t1 = {}

local function depthPast(p1, p2) -- line: 19
    return p1.CFrame.LookVector:Dot(p2 - p1.Position)
end

local function checkStep(p3, p4, p5) -- line: 24
    -- upvalues: v2 (copy), v3 (copy)
    v2(p3)
    v3(p4)
    v3(p5)
end

function t1.SignedDistanceToLine(p6, p7) -- line: 30
    -- upvalues: v2 (copy), v3 (copy), depthPast (copy)
    v2(p6)
    v3(p7)

    return depthPast(p6, p7)
end

function t1.IsPastLine(p8, p9) -- line: 37
    -- upvalues: v2 (copy), v3 (copy)
    v2(p8)
    v3(p9)

    return p8.CFrame.LookVector:Dot(p9 - p8.Position) > 0
end

function t1.CrossedLineInward(p10, p11, p12) -- line: 44
    -- upvalues: v2 (copy), v3 (copy)
    v2(p10)
    v3(p11)
    v3(p12)

    if p10.CFrame.LookVector:Dot(p11 - p10.Position) <= 0 then
        return p10.CFrame.LookVector:Dot(p12 - p10.Position) > 0
    end

    return false
end

function t1.CrossedLineOutward(p13, p14, p15) -- line: 50
    -- upvalues: v2 (copy), v3 (copy)
    v2(p13)
    v3(p14)
    v3(p15)

    if p13.CFrame.LookVector:Dot(p14 - p13.Position) > 0 then
        return p13.CFrame.LookVector:Dot(p15 - p13.Position) <= 0
    end

    return false
end

function t1.IsWithinFootprint(p16, p17) -- line: 57
    -- upvalues: v2 (copy), v3 (copy)
    v2(p16)
    v3(p17)

    local v4 = p16.CFrame:PointToObjectSpace(p17)
    local v5 = p16.Size * 0.5

    if not (math.abs(v4.X) <= v5.X) then
        return false
    end

    return math.abs(v4.Z) <= v5.Z
end

function t1.ReadAreaBounds(p18) -- line: 67
    -- upvalues: v1 (copy)
    v1(p18)
    assert(p18:IsA("Folder"), "Guard areas have to be collected under a single Folder")

    local t2 = {}

    for _, child in ipairs(p18:GetChildren()) do
        assert(child:IsA("Model"), (("%* sits under GuardAreas but is not a Model"):format((child:GetFullName()))))

        local Bounds = child.Bounds

        assert(Bounds:IsA("BasePart"), (("%* has a Bounds child that is not a part"):format((child:GetFullName()))))
        table.insert(t2, {
            AreaId = child.Name,
            Bounds = Bounds
        })
    end

    assert(#t2 > 0, "GuardAreas is empty; the game needs at least one guard area")

    return t2
end

return t1

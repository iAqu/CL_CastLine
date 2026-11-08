-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CaptureTheEgg = require(ReplicatedStorage.Data.CaptureTheEgg)
local GuardAreaGeometry = require(script.Parent.GuardAreaGeometry)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.Vector3)
local v2 = t.strict(t.number)
local v3 = t.strict(t.boolean)
local v4 = t.strict(t.string)
local Areas
local t1 = {}

local function areasFolder() -- line: 44
    -- upvalues: Workspace (copy), Areas (ref)
    local Areas2 = Areas

    if Areas2 ~= nil and Areas2.Parent ~= nil then
        return Areas2
    end

    local World = Workspace:FindFirstChild("World")

    assert(World ~= nil, "Workspace.World is missing")

    local Areas3 = World:FindFirstChild("Areas")

    assert(Areas3 ~= nil and Areas3:IsA("Folder"), "Workspace.World.Areas must be a Folder")
    Areas = Areas3

    return Areas3
end

local function areaPart(p1) -- line: 61
    -- upvalues: areasFolder (copy)
    local v7 = areasFolder():FindFirstChild(p1)

    assert(v7 ~= nil and v7:IsA("BasePart"), (("Workspace.World.Areas.%* must be a BasePart"):format(p1)))

    return v7
end

local function readBox(p2) -- line: 70
    return {
        CFrame = p2.CFrame,
        HalfSize = p2.Size * 0.5
    }
end

local function depth(p3) -- line: 74
    -- upvalues: GuardAreaGeometry (copy), areasFolder (copy)
    local SignedDistanceToLine = GuardAreaGeometry.SignedDistanceToLine
    local SeparationLine = areasFolder():FindFirstChild("SeparationLine")

    assert(SeparationLine ~= nil and SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    return SignedDistanceToLine(SeparationLine, p3)
end

local function barrierBoxes(p4) -- line: 80
    -- upvalues: ReplicatedStorage (copy), areasFolder (copy)
    local WallStartCollision = areasFolder():FindFirstChild("WallStartCollision")

    assert(WallStartCollision ~= nil and WallStartCollision:IsA("BasePart"), "Workspace.World.Areas.WallStartCollision must be a BasePart")

    local t2 = {
        {
            CFrame = WallStartCollision.CFrame,
            HalfSize = WallStartCollision.Size * 0.5
        }
    }

    if p4 then
        local SpawnLock = ReplicatedStorage.Assets:FindFirstChild("SpawnLock")

        if SpawnLock ~= nil then
            if SpawnLock:IsA("BasePart") then
                table.insert(t2, {
                    CFrame = SpawnLock.CFrame,
                    HalfSize = SpawnLock.Size * 0.5
                })
            end

            for _, descendant in SpawnLock:GetDescendants() do
                if descendant:IsA("BasePart") then
                    table.insert(t2, {
                        CFrame = descendant.CFrame,
                        HalfSize = descendant.Size * 0.5
                    })
                end
            end
        end
    end

    return t2
end

local function projectedHalfExtent(p5, p6) -- line: 101
    return math.abs((p6:Dot(p5.CFrame.XVector))) * p5.HalfSize.X + math.abs((p6:Dot(p5.CFrame.YVector))) * p5.HalfSize.Y + math.abs((p6:Dot(p5.CFrame.ZVector))) * p5.HalfSize.Z
end

local function boxIntrusion(p7, p8, p9, p10) -- line: 111
    -- upvalues: GuardAreaGeometry (copy), areasFolder (copy), projectedHalfExtent (copy)
    local v17 = p7.CFrame:PointToObjectSpace(p8)
    local v18 = p7.HalfSize + Vector3.new(1, 1, 1) * p9
    local X = v17.X
    local Position, SignedDistanceToLine, SeparationLine, v19

    if math.abs(X) > v18.X or math.abs(v17.Y) > v18.Y or math.abs(v17.Z) > v18.Z then
        return nil
    else
        Position = p7.CFrame.Position
        SignedDistanceToLine = GuardAreaGeometry.SignedDistanceToLine
        SeparationLine = areasFolder():FindFirstChild("SeparationLine")
        v19 = SeparationLine ~= nil and SeparationLine:IsA("BasePart")
    end

    assert(v19, "Workspace.World.Areas.SeparationLine must be a BasePart")

    local v21 = SignedDistanceToLine(SeparationLine, Position) + projectedHalfExtent(p7, p10) + p9
    local SignedDistanceToLine2 = GuardAreaGeometry.SignedDistanceToLine
    local SeparationLine2 = areasFolder():FindFirstChild("SeparationLine")

    assert(SeparationLine2 ~= nil and SeparationLine2:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    local v23 = v21 - SignedDistanceToLine2(SeparationLine2, p8)

    return if v23 > 0 then v23 else nil
end

local function segmentHitsBox(p11, p12, p13, p14) -- line: 129
    local v24 = p11.CFrame:PointToObjectSpace(p12)
    local v25 = p11.CFrame:PointToObjectSpace(p13) - v24
    local v26 = p11.HalfSize + Vector3.new(1, 1, 1) * p14
    local t5 = {
        v24.X,
        v24.Y,
        v24.Z
    }
    local t6 = {
        v25.X,
        v25.Y,
        v25.Z
    }
    local t7 = {
        v26.X,
        v26.Y,
        v26.Z
    }
    local n1 = 0
    local n2 = 1

    for i = 1, 3 do
        local v27 = t5[i]
        local v28 = t6[i]
        local v29 = t7[i]

        if math.abs(v28) < 1E-04 then
            if v29 < math.abs(v27) then
                return false
            end
        else
            local v30 = (-v29 - v27) / v28
            local v31 = (v29 - v27) / v28

            if not (v31 < v30) then
                v31, v30 = v30, v31
            end

            n1 = math.max(n1, v31)
            n2 = math.min(n2, v30)

            if n2 < n1 then
                return false
            end
        end
    end

    return true
end

function t1.IsFencedUid(p15) -- line: 166
    -- upvalues: Workspace (copy), CaptureTheEgg (copy), v4 (copy)
    v4(p15)

    return Workspace:GetAttribute(CaptureTheEgg.EggUidAttribute) == p15
end

function t1.Depth(p16) -- line: 173
    -- upvalues: v1 (copy), depth (copy)
    v1(p16)

    return depth(p16)
end

function t1.Intrusion(p17, p18, p19, p20) -- line: 181
    -- upvalues: GuardAreaGeometry (copy), v1 (copy), v2 (copy), v3 (copy), areasFolder (copy), barrierBoxes (copy), boxIntrusion (copy)
    v1(p17)
    v2(p18)
    v3(p19)
    v1(p20)

    local v32

    local function consider(p21) -- line: 193
        -- upvalues: v32 (ref)
        if p21 ~= nil and (v32 == nil or v32 < p21) then
            v32 = p21
        end
    end

    local SignedDistanceToLine = GuardAreaGeometry.SignedDistanceToLine
    local SeparationLine = areasFolder():FindFirstChild("SeparationLine")

    assert(SeparationLine ~= nil and SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    local v34 = p18 - SignedDistanceToLine(SeparationLine, p17)

    if not (v34 > 0) then
        v34 = nil
    end

    if v34 ~= nil and (v32 == nil or v32 < v34) then
        v32 = v34
    end

    for _, v35 in barrierBoxes(p19) do
        local v36 = boxIntrusion(v35, p17, p18, p20)

        if v36 ~= nil and (v32 == nil or v32 < v36) then
            v32 = v36
        end
    end

    return v32
end

function t1.Separates(p22, p23, p24) -- line: 210
    -- upvalues: GuardAreaGeometry (copy), v1 (copy), v3 (copy), areasFolder (copy), barrierBoxes (copy), segmentHitsBox (copy)
    v1(p22)
    v1(p23)
    v3(p24)

    local SignedDistanceToLine = GuardAreaGeometry.SignedDistanceToLine
    local SeparationLine = areasFolder():FindFirstChild("SeparationLine")

    assert(SeparationLine ~= nil and SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    local v38 = SignedDistanceToLine(SeparationLine, p22) > 0
    local SignedDistanceToLine2 = GuardAreaGeometry.SignedDistanceToLine
    local SeparationLine2 = areasFolder():FindFirstChild("SeparationLine")

    assert(SeparationLine2 ~= nil and SeparationLine2:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    if v38 ~= (SignedDistanceToLine2(SeparationLine2, p23) > 0) then
        return true
    end

    for _, v40 in barrierBoxes(p24) do
        if segmentHitsBox(v40, p22, p23, 0) then
            return true
        end
    end

    return false
end

return t1

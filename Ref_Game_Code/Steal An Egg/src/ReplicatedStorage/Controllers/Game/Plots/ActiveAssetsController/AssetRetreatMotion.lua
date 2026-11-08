-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetWanderArea = require(script.Parent.AssetWanderArea)

require(ReplicatedStorage.Data.Assets)

local v1 = table.freeze({
    0, 0.6108652381980153, -0.6108652381980153, 1.2217304763960306, -1.2217304763960306, 1.8325957145940461, -1.8325957145940461, 2.443460952792061,
    -2.443460952792061, 3.141592653589793
})
local t1 = {}

local function rotateLocalFlatDirection(p1, p2) -- line: 35
    local v2 = math.cos(p2)
    local v3 = math.sin(p2)

    return (Vector3.new(p1.X * v2 - p1.Z * v3, 0, p1.X * v3 + p1.Z * v2))
end

local function distanceToAreaEdge(p3, p4, p5) -- line: 45
    -- upvalues: AssetWanderArea (copy)
    local v6, v7 = AssetWanderArea.HalfExtents(p3)

    return (math.max(math.min(if p5.X > 0 then (v6 - p4.X) / p5.X elseif p5.X < 0 then (-v6 - p4.X) / p5.X else 1e999, if p5.Z > 0 then (v7 - p4.Z) / p5.Z elseif p5.Z < 0 then (-v7 - p4.Z) / p5.Z else 1e999) - 2, 0))
end

local function ownerAwayDirection(p6, p7, p8) -- line: 68
    local v13 = Vector3.new(p8.X - p7.X, 0, p8.Z - p7.Z)

    if v13.Magnitude > 0 then
        return v13.Unit
    end

    local v16 = Vector3.new(p8.X - p6.Position.X, 0, p8.Z - p6.Position.Z)

    if v16.Magnitude > 0 then
        return v16.Unit
    end

    local LookVector = p6.CFrame.LookVector
    local v17 = Vector3.new(LookVector.X, 0, LookVector.Z)

    assert(v17.Magnitude > 0, "Asset area must provide a horizontal retreat direction")

    return v17.Unit
end

function t1.Destination(p9, p10, p11, p12, p13) -- line: 98
    -- upvalues: AssetWanderArea (copy), v1 (copy), distanceToAreaEdge (copy), ownerAwayDirection (copy)
    local v19 = p9.CFrame:PointToObjectSpace(p13)
    local v20 = ownerAwayDirection(p9, p12, p13)
    local v21 = p9.CFrame:VectorToObjectSpace(v20)
    local v22 = Vector3.new(v21.X, 0, v21.Z)

    assert(v22.Magnitude > 0, "Retreat direction must be horizontal")

    local Unit = v22.Unit
    local Unit2 = Unit
    local n1 = 0
    local n2 = (-1e999)

    for _, v24 in ipairs(v1) do
        local v25 = math.cos(v24)
        local v26 = math.sin(v24)
        local Unit3 = Vector3.new(Unit.X * v25 - Unit.Z * v26, 0, Unit.X * v26 + Unit.Z * v25).Unit
        local v29 = distanceToAreaEdge(p9, v19, Unit3)
        local v31 = v29 * (math.max(Unit3:Dot(Unit), 0) + 0.6)

        if n2 < v31 then
            n2 = v31
            Unit2 = Unit3
            n1 = v29
        end
    end

    if n1 <= 0 then
        return AssetWanderArea.RandomPoint(p9, p10)
    end

    if p11.MaxTravelDistance ~= nil then
        n1 = math.min(p11.MaxTravelDistance, n1)
    end

    local v32 = v19 + Unit2 * n1

    return (p9.CFrame * CFrame.new(v32.X, 0, v32.Z)).Position
end

return t1

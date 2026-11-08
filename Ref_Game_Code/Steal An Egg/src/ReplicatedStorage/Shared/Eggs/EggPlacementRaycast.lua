-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Input = require(ReplicatedStorage.Packages.Input)
local PlacedEggRenderer = require(script.Parent.PlacedEggRenderer)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Input.Mouse.new()
local t1 = {}

local function placementRaycastParams(p1, p2) -- line: 24
    -- upvalues: PlacedEggRenderer (copy)
    local t2 = {
        p1
    }

    PlacedEggRenderer.AppendRaycastTargets(t2, p2)

    local v2 = RaycastParams.new()

    v2.FilterType = Enum.RaycastFilterType.Include
    v2.FilterDescendantsInstances = t2
    v2.IgnoreWater = true

    return v2
end

function t1.Raycast(p3, p4) -- line: 39
    -- upvalues: t (copy), v1 (copy), placementRaycastParams (copy)
    t.strict(t.instanceIsA("BasePart"))(p3)
    t.strict(t.number)(p4)

    return v1:Raycast(placementRaycastParams(p3, p4), 500)
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Types.GuardTutorial)

local v1 = table.freeze({ "StealEgg", "HeadToPen", "EquipEgg", "PlaceEgg", "HatchEgg", "PlacePet", "ExpandPen", "TreadmillIntro" })
local t1 = {}

for v2, v3 in ipairs(v1) do
    t1[v3] = v2
end

table.freeze(t1)

local t2 = {
    GetOrderedStepIds = function() -- GetOrderedStepIds | line: 36
        -- upvalues: v1 (copy)
        return v1
    end,
    GetFirstStepId = function() -- GetFirstStepId | line: 38
        -- upvalues: v1 (copy)
        return v1[1]
    end,
    GetIndex = function(p1) -- GetIndex | line: 40
        -- upvalues: t1 (copy)
        return t1[p1]
    end
}

function t2.GetNextStepId(p2) -- line: 42
    -- upvalues: v1 (copy), t2 (copy)
    local v4 = t2.GetIndex(p2)

    return if v4 ~= nil then v1[v4 + 1] else nil
end

return t2

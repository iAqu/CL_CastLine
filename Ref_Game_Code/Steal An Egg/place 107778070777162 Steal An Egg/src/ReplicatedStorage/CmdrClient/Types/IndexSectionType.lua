-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Areas = require(ReplicatedStorage.Data.Areas)
local t1 = {}

for v1 in pairs(Areas.Directory) do
    table.insert(t1, v1)
end

table.sort(t1, function(p1, p2) -- line: 9
    -- upvalues: Areas (copy)
    local v2 = Areas.GetProgressionOrder(Areas.Directory[p1])
    local v3 = Areas.GetProgressionOrder(Areas.Directory[p2])

    if v2 == v3 then
        return p1 < p2
    end

    return v2 < v3
end)

for _, v4 in { "LimitedEgg", "LuminousEgg", "MonsterEgg", "BrainrotEgg", "Rift", "DrScramble", "HalloweenPart1" } do
    table.insert(t1, v4)
end

return function(p3) -- line: 22
    -- upvalues: t1 (copy)
    p3:RegisterType("indexSection", p3.Cmdr.Util.MakeEnumType("IndexSection", t1))
end

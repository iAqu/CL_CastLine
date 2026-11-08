-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShrineFusionRules = require(ReplicatedStorage.Shared.Util.ShrineFusionRules)
local t1 = {
    "All"
}

for _, v1 in ShrineFusionRules.Tiers do
    table.insert(t1, v1)
end

return function(p1) -- line: 10
    -- upvalues: t1 (copy)
    p1:RegisterType("shrineFusionTier", p1.Cmdr.Util.MakeEnumType("ShrineFusionTier", t1))
end

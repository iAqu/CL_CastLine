-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local t1 = {}

for v1 in pairs(Personalities.Personalities) do
    table.insert(t1, v1)
end

table.sort(t1)

return function(p1) -- line: 11
    -- upvalues: t1 (copy)
    p1:RegisterType("personality", p1.Cmdr.Util.MakeEnumType("Personality", t1))
end

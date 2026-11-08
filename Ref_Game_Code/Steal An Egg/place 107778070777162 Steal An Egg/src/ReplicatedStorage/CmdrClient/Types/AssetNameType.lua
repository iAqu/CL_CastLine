-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local t1 = {}

for v1 in pairs(Assets.Directory) do
    table.insert(t1, v1)
end

table.sort(t1)

return function(p1) -- line: 12
    -- upvalues: t1 (copy)
    p1:RegisterType("assetName", p1.Cmdr.Util.MakeEnumType("AssetName", t1))
end

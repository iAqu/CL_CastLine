-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
return {
	RequestEquip = function(p1, p2) --[[ RequestEquip | Line: 13 | Upvalues: Network (copy) ]]
		Network.FireServer("WeightEquip", p2)
	end
}
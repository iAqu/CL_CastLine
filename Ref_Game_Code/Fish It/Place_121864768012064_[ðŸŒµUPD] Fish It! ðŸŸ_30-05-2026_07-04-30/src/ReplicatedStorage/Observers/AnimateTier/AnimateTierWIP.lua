-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
Observers.observePlayer(function(p1) --[[ Line: 9 | Upvalues: Observers (copy), TierUtility (copy) ]]
	local v1 = Observers.observeAttribute(p1, "SelectedRarity", function(p1) --[[ Line: 10 | Upvalues: TierUtility (ref) ]]
		local _ = if p1 then TierUtility:GetTier(p1) else p1
	end)
	return function() --[[ Line: 19 | Upvalues: v1 (copy) ]]
		v1()
	end
end)
return {}
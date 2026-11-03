-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
return {
	ABEligible = function(p1, p2) --[[ ABEligible | Line: 11 ]]
		return p1:GetAttribute(p2) or false
	end,
	ABObserveEligibility = function(p1, p2, p3) --[[ ABObserveEligibility | Line: 15 | Upvalues: Observers (copy) ]]
		return Observers.observeAttribute(p1, p2, function(p1) --[[ Line: 16 | Upvalues: p3 (copy) ]]
			p3(p1 == true)
		end)
	end
}
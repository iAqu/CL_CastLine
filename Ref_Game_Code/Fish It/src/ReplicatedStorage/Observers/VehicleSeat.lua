-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local DrawSeatUtility = require(ReplicatedStorage.Shared.DrawSeatUtility)
Observers.observeTag("VehicleSeat", function(p1) --[[ Line: 10 | Upvalues: DrawSeatUtility (copy) ]]
	DrawSeatUtility(p1, "DRIVE")
	return function() --[[ Line: 13 ]] end
end, { workspace })
return {}
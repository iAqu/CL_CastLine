-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Net)
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Modules.ModelDownloader)
local Projection = require(ReplicatedStorage.Modules.Projection)
return {
	Start = function(p1) --[[ Start | Line: 15 | Upvalues: Observers (copy), Players (copy), Projection (copy) ]]
		Observers.observeCharacter(function(p1, p2) --[[ Line: 16 | Upvalues: Players (ref), Projection (ref) ]]
			if p1 == Players.LocalPlayer then
				return function() --[[ Line: 21 | Upvalues: Projection (ref) ]]
					Projection:Cancel()
				end
			end
		end)
		Projection:New()
	end,
	Focus = function(p1, p2, p3, p4) --[[ Focus | Line: 29 | Upvalues: Projection (copy) ]]
		Projection:Add(p2, p3, "Board", "CharmCrafting", "AMAZING", p4)
	end,
	Destroy = function(p1) --[[ Destroy | Line: 44 | Upvalues: Projection (copy) ]]
		Projection:Cancel()
	end
}
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedUpgrades = require(ReplicatedStorage.Modules.UILoader.SpeedUpgrades)
require(ReplicatedStorage.Shared.Data.Tags)
return {
	Nodes = {
		default_open = {
			text = { "Upgrade your speed here!" },
			trigger = function() --[[ trigger | Line: 32 | Upvalues: SpeedUpgrades (copy) ]]
				SpeedUpgrades:OpenFrame()
			end
		}
	},
	GetCorrectOpening = function(p1) --[[ GetCorrectOpening | Line: 38 ]]
		return "default_open"
	end
}
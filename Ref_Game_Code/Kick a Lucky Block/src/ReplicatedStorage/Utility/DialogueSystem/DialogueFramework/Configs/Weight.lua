-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeightUI = require(ReplicatedStorage.Modules.UILoader.WeightUI)
require(ReplicatedStorage.Shared.Data.Tags)
return {
	Nodes = {
		default_open = {
			text = { "Buy weights here!" },
			trigger = function() --[[ trigger | Line: 32 | Upvalues: WeightUI (copy) ]]
				WeightUI:OpenUI()
			end
		}
	},
	GetCorrectOpening = function(p1) --[[ GetCorrectOpening | Line: 38 ]]
		return "default_open"
	end
}
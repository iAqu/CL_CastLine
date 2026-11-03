-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeightsData = require(ReplicatedStorage.Shared.Data.WeightsData)
local FormatValue = require(ReplicatedStorage.Functional.FormatValue)
return {
	Styles = {
		Speed = {
			Image = "rbxassetid://86964499984867",
			Format = function(p1) --[[ Format | Line: 17 | Upvalues: FormatValue (copy) ]]
				return ("+%* Speed"):format((FormatValue(p1, true)))
			end,
			Sound = SoundService.Effects.Notification
		},
		Weight = {
			Image = function(p1) --[[ Image | Line: 23 | Upvalues: WeightsData (copy) ]]
				return WeightsData.Weights[p1] and WeightsData.Weights[p1].Image
			end,
			Sound = SoundService.Effects.Notification
		}
	}
}
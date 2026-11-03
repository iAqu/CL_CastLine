-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
return function(p1) --[[ Line: 169 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "This present can no longer be used!",
		TextColor = {
			R = 255,
			G = 50,
			B = 50
		}
	})
end
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Players.LocalPlayer.PlayerGui:WaitForChild("Exclusive Store").Main.Content.Items["Codes Frame"]
local Redeem = v1.Inputs.Redeem
local Input = v1.Inputs.Small.Input
local v2 = Net:RemoteFunction("RedeemCode")
return {
	Start = function(p1) --[[ Start | Line: 29 | Upvalues: GuiControl (copy), Redeem (copy), Input (copy), TextNotificationController (copy), v2 (copy) ]]
		GuiControl:Hook("Hold Button", Redeem).Clicked:Connect(function() --[[ Line: 30 | Upvalues: Input (ref), TextNotificationController (ref), v2 (ref) ]]
			local Text = Input.Text
			if string.len(Text) == 0 then
				return TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Please input a code!",
					TextColor = {
						R = 255,
						G = 83,
						B = 71
					}
				})
			end
			local v1, v22 = v2:InvokeServer(Text)
			if v1 then
				Input.Text = ""
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Redeemed code!",
					TextColor = {
						R = 0,
						G = 255,
						B = 0
					}
				})
				return
			end
			if not v22 then
				return
			end
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = v22,
				TextColor = {
					R = 255,
					G = 83,
					B = 71
				}
			})
		end)
	end
}
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Constants = require(ReplicatedStorage.Shared.Constants)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
local v1 = Replion.Client:WaitReplion("Data")
local v2 = Net:RemoteEvent("TradePlazaTeleport")
local function sendMessage(p1, p2) --[[ sendMessage | Line: 17 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = 5,
		Text = p1,
		TextColor = p2
	})
end
Observers.observeTag("TeleportToTradingHub", function(p1) --[[ Line: 26 | Upvalues: LocalPlayer (copy), UserPriority (copy), v1 (copy), Constants (copy), TextNotificationController (copy), v2 (copy) ]]
	local v12 = p1.Triggered:Connect(function(p1) --[[ Line: 27 | Upvalues: LocalPlayer (ref), UserPriority (ref), v1 (ref), Constants (ref), TextNotificationController (ref), v2 (ref) ]]
		if p1 ~= LocalPlayer then
			return
		end
		if UserPriority:IsTradePlaza() or not (v1:GetExpect("Level") < Constants.TradingLevel) then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Teleporting you soon!",
				TextColor = nil,
				CustomDuration = 5
			})
			v2:FireServer()
		else
			TextNotificationController:DeliverNotification({
				Type = "Text",
				CustomDuration = 5,
				Text = ("You must be level %* to go to the Trading Plaza!"):format(Constants.TradingLevel),
				TextColor = {
					R = 255,
					G = 100,
					B = 100
				}
			})
		end
	end)
	return function() --[[ Line: 46 | Upvalues: v12 (copy) ]]
		v12:Disconnect()
	end
end)
return {}
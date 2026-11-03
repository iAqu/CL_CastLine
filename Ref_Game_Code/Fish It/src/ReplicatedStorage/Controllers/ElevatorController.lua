-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Net = require(ReplicatedStorage.Packages.Net)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local PurchaseScreenBlackoutController = require(ReplicatedStorage.Controllers.PurchaseScreenBlackoutController)
local v1 = Net:RemoteEvent("ElevatorStateUpdated")
local WorldSetup = workspace:WaitForChild("WorldSetup")
return {
	Init = function(p1) --[[ Init | Line: 23 | Upvalues: v1 (copy), Soundbook (copy), TextNotificationController (copy), WorldSetup (copy), PurchaseScreenBlackoutController (copy) ]]
		v1.OnClientEvent:Connect(function(p1) --[[ Line: 24 | Upvalues: Soundbook (ref), TextNotificationController (ref), WorldSetup (ref), PurchaseScreenBlackoutController (ref) ]]
			if p1 == "PurchaseSuccess" then
				Soundbook.Sounds.CoinsChanged:Play()
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Paid for elevator!",
					TextColor = {
						R = 255,
						G = 231,
						B = 18
					}
				})
				return
			end
			if p1 == "PurchaseFail" then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Not enough coins!",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			if p1 == "TeleportFail" then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "You did not pay for the elevator!",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			if p1 ~= "TeleportUp" and p1 ~= "TeleportDown" then
				return
			end
			local v2 = WorldSetup:FindFirstChild("!!! ELEVATORS")
			local v3 = if v2 then v2:WaitForChild(if p1 == "TeleportUp" then "Down" else "Up") else v2
			if not v3 then
				return
			end
			local SpawnPart = v3:WaitForChild("SpawnPart")
			if not SpawnPart then
				return
			end
			Soundbook.Sounds.TeleportActivated:Play()
			PurchaseScreenBlackoutController.blackoutScreen(SpawnPart.CFrame)
			if p1 ~= "TeleportDown" then
				return
			end
			Soundbook.Sounds.TeleportDownFinished:Play()
		end)
	end
}
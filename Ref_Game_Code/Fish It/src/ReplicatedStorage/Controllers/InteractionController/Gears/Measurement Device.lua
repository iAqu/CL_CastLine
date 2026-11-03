-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Replion)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = false
local v2 = Net:UnreliableRemoteEvent("TakeMeasurement")
return function() --[[ Line: 19 | Upvalues: v1 (ref), TextNotificationController (copy), Soundbook (copy), TweenUtil (copy), v2 (copy) ]]
	if v1 then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "The device is on cooldown!",
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	v1 = true
	task.delay(2, function() --[[ Line: 30 | Upvalues: v1 (ref) ]]
		v1 = false
	end)
	Soundbook.Sounds["Measurement Gun"]:Play().PlaybackSpeed = 1 + math.random() * 0.3
	task.wait(0.2)
	local v12 = workspace.CosmeticFolder:FindFirstChild("!!!EQUIPPED_TOOL!!!")
	if not (v12 and v12:FindFirstChild("Screen")) then
		v2:FireServer()
		return
	end
	local v3 = math.round(math.random() * 100)
	local Label = v12.Screen.Display.Label
	TweenUtil.TweenNumber(Label, "%d", 0, v3, TweenInfo.new(0.2), true, function() --[[ Line: 44 | Upvalues: Label (copy), v3 (copy) ]]
		local v1 = Label
		v1.TextColor3 = v3 >= 70 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
		task.delay(0.5, function() --[[ Line: 46 | Upvalues: Label (ref) ]]
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.Text = "0"
		end)
	end)
	v2:FireServer()
end
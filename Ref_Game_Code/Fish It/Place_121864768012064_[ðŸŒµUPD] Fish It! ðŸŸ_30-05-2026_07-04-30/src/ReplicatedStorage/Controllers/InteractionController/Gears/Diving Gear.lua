-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("EquipOxygenTank")
local v2 = Net:RemoteFunction("UnequipOxygenTank")
local v3 = ItemUtility.GetItemDataFromItemType("Gears", "Diving Gear")
return function() --[[ Line: 22 | Upvalues: v3 (copy), Replion (copy), v2 (copy), v1 (copy), Soundbook (copy), spr (copy), Lighting (copy), TextNotificationController (copy) ]]
	if not v3 then
		return
	end
	local v12 = Replion.Client:GetReplion("Data")
	if not v12 then
		return
	end
	local v22, v32
	if v12:Get("EquippedOxygenTankId") == v3.Data.Id then
		v22, v32 = v2:InvokeServer(), true
	else
		v22, v32 = v1:InvokeServer(v3.Data.Id), false
	end
	if not v22 then
		return
	end
	Soundbook.Sounds.DivingToggle:Play().PlaybackSpeed = 1 + math.random() * 0.3
	spr.stop(Lighting)
	Lighting.ExposureCompensation = -0.5
	spr.target(Lighting, 1, 2, {
		ExposureCompensation = 0
	})
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = ("Diving Gear: %*"):format(if v32 then "Off" else "On"),
		TextColor = v32 and {
			R = 255,
			G = 0,
			B = 0
		} or {
			R = 9,
			G = 255,
			B = 0
		}
	})
end
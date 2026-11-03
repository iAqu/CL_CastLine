-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.spr)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("EquipOxygenTank")
local v2 = Net:RemoteFunction("UnequipOxygenTank")
local v3 = ItemUtility.GetItemDataFromItemType("Gears", "Hazmat Suit")
return function() --[[ Line: 22 | Upvalues: v3 (copy), Replion (copy), v2 (copy), v1 (copy), TextNotificationController (copy) ]]
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
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = ("Hazmat Suit: %*"):format(if v32 then "Off" else "On"),
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
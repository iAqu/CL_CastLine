-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local CrateController = require(ReplicatedStorage.Controllers.CrateController)
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local v1 = Net:RemoteFunction("ConsumePotion")
local v2 = Net:RemoteFunction("Pets/OpenEgg")
local v3 = Net:RemoteFunction("Pets/Equip")
local v4 = Net:RemoteFunction("Pets/Unequip")
local v5 = Net:RemoteEvent("EquipRodSkin")
local v6 = Net:RemoteEvent("UnequipRodSkin")
local v7 = Net:RemoteEvent("EquipBaitSkin")
local v8 = Net:RemoteEvent("UnequipBaitSkin")
local v9 = Net:RemoteEvent("EquipBait")
local v10 = Net:RemoteEvent("EquipCharm")
local v11 = Net:RemoteEvent("UnequipCharm")
local v12 = Net:RemoteEvent("EquipAbility")
local v13 = Net:RemoteEvent("UnequipAbility")
local v14 = Net:RemoteEvent("EquipItem")
local v15 = Net:RemoteEvent("UnequipItem")
local v16 = Net:RemoteEvent("FavoriteItem")
local t = {}
local v17 = nil
local LocalPlayer = Players.LocalPlayer
local function notify(p1, p2) --[[ notify | Line: 47 | Upvalues: TextNotificationController (copy) ]]
	local t = {
		Type = "Text",
		CustomDuration = 2,
		Text = p1
	}
	t.TextColor = if p2 then {
	R = 0,
	G = 255,
	B = 0
} else {
	R = 255,
	G = 80,
	B = 80
}
	TextNotificationController:DeliverNotification(t)
end
function t.Init(p1) --[[ Init | Line: 56 | Upvalues: v17 (ref), Replion (copy) ]]
	v17 = Replion.Client:WaitReplion("Data")
end
function t.GetEquippedUUIDs(p1, p2) --[[ GetEquippedUUIDs | Line: 61 | Upvalues: v17 (ref) ]]
	if p2 == "Abilities" then
		local v1 = v17:Get({ "Abilities", "Equipped" })
		if v1 and v1 ~= "" then
			return { v1 }
		else
			return {}
		end
	elseif p2 == "Emotes" then
		local v2 = v17:Get("EquippedEmotes")
		if typeof(v2) == "table" then
			return v2
		else
			return {}
		end
	else
		if p2 ~= "Pets" then
			return v17:GetExpect("EquippedItems")
		end
		local v3 = v17:GetExpect("EquippedPetUUID")
		if v3 == "" then
			return {}
		else
			return { v3 }
		end
	end
end
function t.TogglePet(p1, p2) --[[ TogglePet | Line: 83 | Upvalues: LocalPlayer (copy), notify (copy), FishingController (copy), v17 (ref), v4 (copy), Soundbook (copy), v3 (copy) ]]
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChildOfClass("Humanoid") else Character
	if not v1 or (v1.Health <= 0 or v1:GetState() == Enum.HumanoidStateType.Dead) then
		notify("You can\'t change pets while dead.", false)
		return
	end
	if FishingController:GetCurrentGUID() or LocalPlayer:GetAttribute("PetFishingActive") == true then
		notify("You can\'t change pets while fishing.", false)
		return
	end
	local v2, v32
	if v17:GetExpect("EquippedPetUUID") == p2 then
		local v42, v5 = v4:InvokeServer()
		if v42 then
			Soundbook.Sounds["Pet Unequip"]:Play()
		end
		v2 = v42
		v32 = v5
	else
		local v6, v7 = v3:InvokeServer(p2)
		if v6 then
			Soundbook.Sounds["Pet Equip"]:Play()
		end
		v2 = v6
		v32 = v7
	end
	if v2 then
		return
	end
	notify(v32 or "Unable to update pet.", false)
end
function t.HandleInventoryClick(p1, p2, p3, p4, p5) --[[ HandleInventoryClick | Line: 118 | Upvalues: v13 (copy), v12 (copy), v1 (copy), TextNotificationController (copy), Soundbook (copy), v16 (copy), PromptController (copy), v2 (copy), notify (copy), CrateController (copy), LocalPlayer (copy), v15 (copy), v14 (copy) ]]
	local Type = p3.Data.Type
	local v17 = p1:GetEquippedUUIDs(Type)
	if Type == "Abilities" then
		if table.find(v17, p2.UUID) then
			v13:FireServer()
		else
			v12:FireServer(p2.UUID)
		end
	else
		if Type == "Pets" then
			p1:TogglePet(p2.UUID)
			return
		end
		if Type == "Potions" then
			if not v1:InvokeServer(p2.UUID, 1) then
				return
			end
			task.spawn(function() --[[ Line: 145 | Upvalues: TextNotificationController (ref), Soundbook (ref) ]]
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Consumed potion!",
					CustomDuration = 2,
					TextColor = {
						R = 0,
						G = 255,
						B = 0
					}
				})
				Soundbook.Sounds.PotionConsumed:Play().PlaybackSpeed = 1 + math.random() * 0.2
			end)
			if not p5 then
				return
			end
			task.delay(0.15, p5)
		else
			if p4 then
				v16:FireServer(p2.UUID)
				return
			end
			if Type == "Pet Eggs" then
				local v22 = 1
				if (p2.Quantity or 1) >= 3 then
					local v3, v4 = PromptController:FireChoicePrompt(("How many <b>%*</b>s do you want to open?"):format(p3.Data.Name), "1", "3"):catch(warn):await()
					if not v3 then
						return
					end
					v22 = if v4 then 3 else 1
				else
					local v5, v6 = PromptController:FirePrompt((("Are you sure you want to open a <b>%*</b>?"):format(p3.Data.Name))):catch(warn):await()
					if not (v5 and v6) then
						return
					end
				end
				local v7 = v2:InvokeServer(p2.UUID, v22)
				if v7 and v7.Success == true then
					local v8 = v7.Data and v7.Data.Rewards
					if typeof(v8) ~= "table" or not (#v8 > 0) then
						return
					end
					CrateController:OpenPetEgg(LocalPlayer, p3.Data.Name, v8)
				else
					notify(if v7 then v7.Message or "Unable to open egg." else "Unable to open egg.", false)
				end
			else
				if table.find(v17, p2.UUID) then
					v15:FireServer(p2.UUID)
					return
				end
				if #v17 < 5 and p3.Data.Type ~= "Emotes" then
					v14:FireServer(p2.UUID, p3.Data.Type)
					return
				end
				if #v17 < 8 and p3.Data.Type == "Emotes" then
					v14:FireServer(p2.UUID, p3.Data.Type)
				else
					v15:FireServer(v17[#v17])
				end
			end
		end
	end
end
function t.EquipRod(p1, p2) --[[ EquipRod | Line: 230 | Upvalues: v17 (ref), v14 (copy) ]]
	if table.find(v17:GetExpect("EquippedItems"), p2) ~= nil then
		return
	end
	v14:FireServer(p2, "Fishing Rods")
end
function t.EquipBait(p1, p2) --[[ EquipBait | Line: 238 | Upvalues: PlayerStatsUtility (copy), v17 (ref), ItemUtility (copy), v9 (copy) ]]
	local v1 = PlayerStatsUtility:GetItemFromInventory(v17, function(p1) --[[ Line: 239 | Upvalues: p2 (copy) ]]
		return p1.UUID == p2
	end, "Baits")
	if not v1 then
		return
	end
	local v2 = ItemUtility.GetItemDataFromItemType("Baits", v1.Id)
	if not v2 then
		return
	end
	if v17:GetExpect("EquippedBaitId") == v2.Data.Id then
		return
	end
	v9:FireServer(v2.Data.Id)
end
function t.ToggleRodSkin(p1, p2) --[[ ToggleRodSkin | Line: 258 | Upvalues: v17 (ref), v6 (copy), v5 (copy) ]]
	if v17:GetExpect("EquippedSkinUUID") == p2 then
		v6:FireServer()
		return false
	else
		v5:FireServer(p2)
		return true
	end
end
function t.ToggleBaitSkin(p1, p2) --[[ ToggleBaitSkin | Line: 270 | Upvalues: PlayerStatsUtility (copy), v17 (ref), v8 (copy), v7 (copy) ]]
	local v1 = PlayerStatsUtility:GetItemFromInventory(v17, function(p1) --[[ Line: 271 | Upvalues: p2 (copy) ]]
		return p1.UUID == p2
	end, "Baits")
	if not v1 then
		v8:FireServer()
		return
	end
	if v17:GetExpect("EquippedBaitSkinId") == v1.Id then
		v8:FireServer()
		return false
	else
		v7:FireServer(v1.Id)
		return true
	end
end
function t.EquipCharm(p1, p2, p3) --[[ EquipCharm | Line: 291 | Upvalues: v17 (ref), TextNotificationController (copy), ItemUtility (copy), v10 (copy), PlayerStatsUtility (copy) ]]
	if p3 and v17:GetExpect("Level") < p3 then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			CustomDuration = 2,
			Text = ("Must be level %*!"):format(p3),
			TextColor = {
				R = 0,
				G = 255,
				B = 0
			}
		})
		return false
	end
	local v1 = ItemUtility.GetItemDataFromItemType("Charms", p2)
	if v1 then
		v10:FireServer(v1.Data.Name)
		return
	end
	local v2 = PlayerStatsUtility:GetItemFromInventory(v17, function(p1) --[[ Line: 310 | Upvalues: p2 (copy) ]]
		return p1.UUID == p2
	end, "Charms")
	if not v2 then
		return false
	end
	local v3 = ItemUtility.GetItemDataFromItemType("Charms", v2.Id)
	if v3 then
		v10:FireServer(v3.Data.Name)
		return true
	else
		return false
	end
end
function t.UnequipCharm(p1) --[[ UnequipCharm | Line: 329 | Upvalues: v17 (ref), v11 (copy) ]]
	if not (v17:GetExpect({ "EquippedCharmId" }) > 0) then
		return
	end
	v11:FireServer()
end
function t.ToggleFavorite(p1, p2) --[[ ToggleFavorite | Line: 337 | Upvalues: v16 (copy) ]]
	v16:FireServer(p2)
end
return t
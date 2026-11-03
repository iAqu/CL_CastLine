-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Promise = require(ReplicatedStorage.Packages.Promise)
require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.MarketplaceService)
local VendorUtility = require(ReplicatedStorage.Shared.VendorUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Modules.ItemStringUtility)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local SoldItemTypes = require(ReplicatedStorage.Shared.SoldItemTypes)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Shared.GamePassUtility)
require(ReplicatedStorage.Shared.GamePass)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Modules.GuiControl)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v2 = false
local v3 = Net:RemoteFunction("SellItem")
local v4 = Net:RemoteFunction("SellAllItems")
local t = {
	[5] = TierUtility:GetTier("Legendary"),
	[6] = TierUtility:GetTier("Mythic"),
	[7] = TierUtility:GetTier("SECRET")
}
local t2 = {}
local function ToggleSellLock() --[[ ToggleSellLock | Line: 56 | Upvalues: v2 (ref) ]]
	v2 = true
	task.delay(1, function() --[[ Line: 58 | Upvalues: v2 (ref) ]]
		v2 = false
	end)
end
function t2.Start(p1) --[[ Start | Line: 63 | Upvalues: v1 (ref), Client (copy), LocalPlayer (copy), t2 (copy), CollectionService (copy) ]]
	v1 = Client:WaitReplion("Data")
	local function AddSellPart(p1) --[[ AddSellPart | Line: 67 | Upvalues: LocalPlayer (ref), t2 (ref) ]]
		task.spawn(function() --[[ Line: 68 | Upvalues: p1 (copy), LocalPlayer (ref), t2 (ref) ]]
			p1:WaitForChild("SellAllPrompt"):WaitForChild("SellAllPrompt").Triggered:Connect(function(p1) --[[ Line: 72 | Upvalues: LocalPlayer (ref), t2 (ref) ]]
				if p1 ~= LocalPlayer then
					return
				end
				t2:_requestSellAll(LocalPlayer)
			end)
		end)
		task.spawn(function() --[[ Line: 79 | Upvalues: p1 (copy), LocalPlayer (ref), t2 (ref) ]]
			p1:WaitForChild("SellPrompt"):WaitForChild("SellPrompt").Triggered:Connect(function(p1) --[[ Line: 84 | Upvalues: LocalPlayer (ref), t2 (ref) ]]
				if p1 ~= LocalPlayer then
					return
				end
				t2:_requestSell(LocalPlayer)
			end)
		end)
	end
	CollectionService:GetInstanceAddedSignal("SellPrompt"):Connect(AddSellPart)
	for i, v in ipairs(CollectionService:GetTagged("SellPrompt")) do
		AddSellPart(v)
	end
end
function t2._requestSellAll(p1, p2) --[[ _requestSellAll | Line: 101 | Upvalues: t2 (copy), TextNotificationController (copy) ]]
	return t2:SellAllItems():catch(function(p1) --[[ Line: 103 | Upvalues: TextNotificationController (ref) ]]
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p1,
			TextColor = {
				R = 255,
				G = 255,
				B = 255
			}
		})
	end):await()
end
function t2._requestSell(p1, p2) --[[ _requestSell | Line: 113 | Upvalues: t2 (copy), TextNotificationController (copy) ]]
	return t2:SellEquippedItem():catch(function(p1) --[[ Line: 115 | Upvalues: TextNotificationController (ref) ]]
		p1:find("Please")
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p1,
			TextColor = {
				R = 252,
				G = 186,
				B = 3
			}
		})
	end):await()
end
function t2.SellAllItems(p1) --[[ SellAllItems | Line: 132 | Upvalues: v1 (ref), Promise (copy), v2 (ref), t (copy), ItemUtility (copy), TierUtility (copy), VendorUtility (copy), StringLibrary (copy), PromptController (copy), v4 (copy), Soundbook (copy) ]]
	if not v1 then
		return Promise.resolve(false)
	end
	if v2 then
		return Promise.resolve(false)
	end
	v2 = true
	task.delay(1, function() --[[ Line: 58 | Upvalues: v2 (ref) ]]
		v2 = false
	end)
	local v12 = v1:GetExpect({ "Inventory", "Items" })
	local v22 = t[v1.Data.AutoSellThreshold]
	if not v22 then
		return
	end
	local count = 0
	local sum = 0
	for i, v in ipairs(v12) do
		if not v.Favorited then
			local v3 = ItemUtility:GetItemData(v.Id)
			if v3 and v3.Data.Type == "Fish" then
				local v42 = v3.Probability or v3.ForcedProbability
				local v5 = nil
				if v42 then
					v5 = TierUtility:GetTierFromRarity(v42.Chance)
				elseif v3.Data.Tier then
					v5 = TierUtility:GetTierFromRarity(v3.Data.Tier)
				end
				if v5 and not (v5 and v5.Tier > v22.Tier) then
					local v8 = VendorUtility:GetSellPrice(v)
					if v8 then
						count = count + 1
						sum = sum + v8
					end
				end
			end
		end
	end
	if count == 0 then
		return Promise.reject("You have no items to sell...", true)
	end
	local v9 = ("<font color=\"rgb(255, 196, 57)\">%* Coins</font>"):format((StringLibrary:Shorten(sum)))
	return PromptController:FirePrompt((("Would you like to sell <b><font color=\"rgb(0, 255, 255)\">%* %*</font></b> for %*?"):format(StringLibrary:AddCommas(count), if count == 1 then "item" else "items", v9))):andThen(function(p1) --[[ Line: 201 | Upvalues: v4 (ref), Soundbook (ref) ]]
		if not p1 then
			return false
		end
		local v1 = v4:InvokeServer()
		if not v1 then
			return v1
		end
		local v2 = Soundbook.Sounds.CoinsChanged:Play()
		v2.Volume = 0.5
		v2.PlaybackSpeed = 1 + math.random() * 0.5
		return v1
	end)
end
function t2.SellEquippedItem(p1) --[[ SellEquippedItem | Line: 217 | Upvalues: v1 (ref), Promise (copy), t2 (copy) ]]
	if not v1 then
		return Promise.resolve(false)
	end
	local v12 = v1:GetExpect("EquippedId")
	if string.len(v12) == 0 then
		return Promise.reject("You need to hold a fish to sell!", true)
	end
	local v2 = v1:GetExpect("EquippedType")
	if v2 == "Fish" or (v2 == "Enchant Stones" or v2 == "Gears") then
		return t2:SellItem(v12)
	else
		return Promise.reject("Cannot sell this!", true)
	end
end
function t2.SellItem(p1, p2) --[[ SellItem | Line: 235 | Upvalues: v2 (ref), Promise (copy), PlayerStatsUtility (copy), v1 (ref), ItemUtility (copy), SoldItemTypes (copy), VendorUtility (copy), TierUtility (copy), StringLibrary (copy), ItemStringUtility (copy), PromptController (copy), v3 (copy), Soundbook (copy) ]]
	if v2 then
		return Promise.resolve(false)
	end
	v2 = true
	task.delay(1, function() --[[ Line: 58 | Upvalues: v2 (ref) ]]
		v2 = false
	end)
	local v12, v22 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 242 | Upvalues: p2 (copy) ]]
		return p1.UUID == p2
	end, "Items")
	if not v12 then
		return Promise.reject("No item in inventory!")
	end
	if v12.Favorited then
		return Promise.reject("Please unlock this item!")
	end
	local v32 = ItemUtility.GetItemDataFromItemType(v22.Category, v12.Id)
	if not v32 then
		return Promise.reject("No item data")
	end
	if table.find(SoldItemTypes, v32.Data.Type) == nil then
		return Promise.reject("Wrong item type")
	end
	local v4 = VendorUtility:GetSellPrice(v12)
	if not v4 then
		return Promise.reject("No sell price")
	end
	local v5 = v32.Probability or v32.ForcedProbability
	local v6 = nil
	if v5 then
		v6 = TierUtility:GetTierFromRarity(v5.Chance)
	elseif v32.Data.Tier then
		v6 = TierUtility:GetTier(v32.Data.Tier)
	end
	local v9 = if v6 then v6.TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)
	local v11 = math.ceil(v9.R * 255)
	local v13 = math.ceil(v9.G * 255)
	local v15 = math.ceil(v9.B * 255)
	local v16 = StringLibrary:Shorten(v4)
	return PromptController:FirePrompt((("Would you like to sell <b>%*</b> for %*?"):format(("<font color=\"rgb(%*, %*, %*)\">%*</font>"):format(v11, v13, v15, (ItemStringUtility.GetItemName(v12, v32))), (("<font color=\"rgb(255, 196, 57)\">%* Coins</font>"):format(v16))))):andThen(function(p1) --[[ Line: 290 | Upvalues: v3 (ref), p2 (copy), Soundbook (ref) ]]
		if not p1 then
			return false
		end
		local v1 = v3:InvokeServer(p2)
		if not v1 then
			return v1
		end
		local v2 = Soundbook.Sounds.CoinsChanged:Play()
		v2.Volume = 0.5
		v2.PlaybackSpeed = 1 + math.random() * 0.5
		return v1
	end)
end
return t2
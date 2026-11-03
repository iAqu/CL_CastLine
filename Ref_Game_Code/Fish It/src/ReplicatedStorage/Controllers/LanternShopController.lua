-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LanternShop = require(ReplicatedStorage.Shared.LanternShop)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local v2 = nil
local v3 = Net:RemoteFunction("PurchaseLantern")
local v4 = CurrencyUtility:GetCurrency("Coins")
local v5 = nil
local v6 = Players.LocalPlayer.PlayerGui:WaitForChild("LanternShop").Main.Content
local Tile = v6.Lanterns.Tile
Tile.Parent = nil
local t = {}
local function ownsItem(p1) --[[ ownsItem | Line: 36 | Upvalues: InventoryMapping (copy), PlayerStatsUtility (copy), v5 (ref), ItemUtility (copy) ]]
	local v1 = if p1.SinglePurchase then PlayerStatsUtility:GetItemFromInventory(v5, function(p12_2_2_2) --[[ Line: 41 | Upvalues: ItemUtility (ref), p1 (copy) ]]
	local v1_2 = ItemUtility.GetItemDataFromItemType(p1.RewardInfo.Type, p1.RewardInfo.Identifier)
	if not v1_2 then
		return false
	end
	return p12_2_2_2.Id == v1_2.Data.Id
end, InventoryMapping[p1.RewardInfo.Type]) == nil else true
	return v1
end
function t.Init(p1) --[[ Init | Line: 56 | Upvalues: v1 (ref), ReplicatedStorage (copy), v2 (ref) ]]
	v1 = require(ReplicatedStorage.Modules.GuiControl)
	v2 = require(ReplicatedStorage.Controllers.DialogueController)
end
function t.Start(p1) --[[ Start | Line: 61 | Upvalues: v5 (ref), Replion (copy), v2 (ref), v1 (ref), LanternShop (copy), ItemUtility (copy), Tile (copy), TierUtility (copy), StringLibrary (copy), InventoryMapping (copy), PlayerStatsUtility (copy), Trove (copy), t (copy), v6 (copy) ]]
	v5 = Replion.Client:WaitReplion("Data")
	v2:ObservePath("Hans", 1, function(p1) --[[ Line: 64 | Upvalues: v1 (ref) ]]
		if p1 == 1 then
			v1:Open("LanternShop")
			return
		end
		if p1 ~= 2 then
			return
		end
		v1:Open("Lanterns")
	end)
	for v12, v22 in LanternShop do
		local v3 = ItemUtility.GetItemDataFromItemType(v22.RewardInfo.Type, v22.RewardInfo.Identifier)
		if v3 then
			local v4 = Tile:Clone()
			local Buy = v4.Buy
			local v52 = TierUtility:GetTier(v3.Data.Tier) or TierUtility:GetTier("Legendary")
			v4.Padded.Top.RarityLabel.UIGradient.Color = v52.TierColor
			v4.Padded.Top.RarityLabel.Text = v52.Name
			if v52.Tier > 1 then
				v4.UIStroke.UIGradient.Color = v52.TierColor
				v4.BG.Glow.UIGradient.Color = v52.TierColor
				v4.BG.Glow.Visible = true
			end
			v4.Padded.Top.Label.Text = v3.Data.Name
			v4.Padded.Info.Quantity.Text = StringLibrary:AddCommas(v22.Price)
			v4.BG.Vector.Image = v3.Data.Icon or ""
			local v62 = if v22.SinglePurchase then if PlayerStatsUtility:GetItemFromInventory(v5, function(p12_2_2_2) --[[ Line: 41 | Upvalues: ItemUtility (ref), v22 (copy) ]]
	local v1_2 = ItemUtility.GetItemDataFromItemType(v22.RewardInfo.Type, v22.RewardInfo.Identifier)
	if not v1_2 then
		return false
	end
	return p12_2_2_2.Id == v1_2.Data.Id
end, InventoryMapping[v22.RewardInfo.Type]) == nil then true else false else true
			if v62 then
				local v7 = Trove.new()
				local v8 = v1:Hook("Hold Button", Buy)
				v8.Clicked:Connect(function() --[[ Line: 100 | Upvalues: t (ref), v12 (copy) ]]
					t:PurchaseItem(v12)
				end)
				local v9 = v5:OnChange("Inventory", function() --[[ Line: 104 | Upvalues: v22 (copy), InventoryMapping (ref), PlayerStatsUtility (ref), v5 (ref), ItemUtility (ref), v4 (copy), Buy (copy), v7 (copy) ]]
					task.wait(0.25)
					local v1 = v22
					local v2 = if v1.SinglePurchase then PlayerStatsUtility:GetItemFromInventory(v5, function(p12_2_2_2) --[[ Line: 41 | Upvalues: ItemUtility (ref), v1 (copy) ]]
	local v1_2 = ItemUtility.GetItemDataFromItemType(v1.RewardInfo.Type, v1.RewardInfo.Identifier)
	if not v1_2 then
		return false
	end
	return p12_2_2_2.Id == v1_2.Data.Id
end, InventoryMapping[v1.RewardInfo.Type]) == nil else true
					if v2 then
						return
					end
					v4.Padded.Info.Visible = false
					Buy.Padded.Label.Text = "Owned"
					v4.UIStroke.Enabled = true
					v7:Clean()
				end)
				v7:Add(function() --[[ Line: 116 | Upvalues: v8 (copy), v9 (copy) ]]
					v8:Destroy()
					v9:Disconnect()
				end)
			else
				v4.Padded.Info.Visible = false
				Buy.Padded.Label.Text = "Owned"
				v4.UIStroke.Enabled = true
			end
			v4.LayoutOrder = v22.Price
			v4.Parent = v6.Lanterns
		end
	end
end
function t.PurchaseItem(p1, p2) --[[ PurchaseItem | Line: 131 | Upvalues: LanternShop (copy), v5 (ref), v4 (copy), InventoryMapping (copy), PlayerStatsUtility (copy), ItemUtility (copy), v3 (copy), Soundbook (copy) ]]
	local v1 = LanternShop[p2]
	if not v1 then
		return
	end
	if (v5:Get(v4.Path) or 0) < v1.Price then
		return
	end
	local v2 = if v1.SinglePurchase then PlayerStatsUtility:GetItemFromInventory(v5, function(p12_2_2_2) --[[ Line: 41 | Upvalues: ItemUtility (ref), v1 (copy) ]]
	local v1_2 = ItemUtility.GetItemDataFromItemType(v1.RewardInfo.Type, v1.RewardInfo.Identifier)
	if not v1_2 then
		return false
	end
	return p12_2_2_2.Id == v1_2.Data.Id
end, InventoryMapping[v1.RewardInfo.Type]) == nil else true
	if not v2 then
		return
	end
	if not v3:InvokeServer(p2) then
		return
	end
	Soundbook.Sounds.StorePurchase:Play()
end
return t
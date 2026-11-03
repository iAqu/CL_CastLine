-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local BoothShop = require(ReplicatedStorage.Shared.BoothShop)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local v2 = nil
local v3 = Net:RemoteFunction("PurchaseBooth")
local v4 = CurrencyUtility:GetCurrency("Coins")
local v5 = nil
local v6 = Players.LocalPlayer.PlayerGui:WaitForChild("BoothShop").Main.Content
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
function t.Start(p1) --[[ Start | Line: 61 | Upvalues: v5 (ref), Replion (copy), BoothShop (copy), ItemUtility (copy), Tile (copy), TierUtility (copy), StringLibrary (copy), InventoryMapping (copy), PlayerStatsUtility (copy), Trove (copy), v1 (ref), t (copy), v6 (copy) ]]
	v5 = Replion.Client:WaitReplion("Data")
	local t2 = {}
	local v12
	for v2, v3 in BoothShop do
		local v4 = ItemUtility.GetItemDataFromItemType(v3.RewardInfo.Type, v3.RewardInfo.Identifier)
		if v4 then
			local v52 = if v3.ProductId == nil then false elseif v3.ProductId > 0 then true else false
			local v62 = Tile:Clone()
			local Buy = v62.Buy
			local v7 = TierUtility:GetTier(v4.Data.Tier) or TierUtility:GetTier("Legendary")
			v62.Padded.Top.RarityLabel.UIGradient.Color = v7.TierColor
			v62.Padded.Top.RarityLabel.Text = v7.Name
			if v7.Tier > 1 then
				v62.UIStroke.UIGradient.Color = v7.TierColor
				v62.BG.Glow.UIGradient.Color = v7.TierColor
				v62.BG.Glow.Visible = true
			end
			v62.Padded.Top.Label.Text = v4.Data.Name
			v62.Padded.Info.Quantity.Text = ("%*%*"):format(if v52 then "\238\128\130 " else "", (StringLibrary:AddCommas(v3.Price)))
			v62.BG.Vector.Image = v4.Data.Icon or ""
			local v10 = if v3.SinglePurchase then if PlayerStatsUtility:GetItemFromInventory(v5, function(p12_2_2_2) --[[ Line: 41 | Upvalues: ItemUtility (ref), v3 (copy) ]]
	local v1_2 = ItemUtility.GetItemDataFromItemType(v3.RewardInfo.Type, v3.RewardInfo.Identifier)
	if not v1_2 then
		return false
	end
	return p12_2_2_2.Id == v1_2.Data.Id
end, InventoryMapping[v3.RewardInfo.Type]) == nil then true else false else true
			if v10 then
				local v11 = Trove.new()
				if v52 then
					v12 = nil
				else
					v12 = v1:Hook("Hold Button", Buy)
					v12.Clicked:Connect(function() --[[ Line: 95 | Upvalues: t (ref), v2 (copy) ]]
						t:PurchaseItem(v2)
					end)
				end
				local v122 = v5:OnChange("Inventory", function() --[[ Line: 100 | Upvalues: v3 (copy), InventoryMapping (ref), PlayerStatsUtility (ref), v5 (ref), ItemUtility (ref), v62 (copy), Buy (copy), v11 (copy) ]]
					task.wait(0.25)
					local v1 = v3
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
					v62.Padded.Info.Visible = false
					Buy.Padded.Label.Text = "Owned"
					v62.UIStroke.Enabled = true
					v11:Clean()
					if not v62:HasTag("DevProductPurchase") then
						return
					end
					v62:RemoveTag("DevProductPurchase")
				end)
				v11:Add(function() --[[ Line: 116 | Upvalues: v12 (ref), v122 (copy) ]]
					if v12 then
						v12:Destroy()
					end
					v122:Disconnect()
				end)
			else
				v62.Padded.Info.Visible = false
				Buy.Padded.Label.Text = "Owned"
				v62.UIStroke.Enabled = true
			end
			local v13 = v10
			if v52 then
				v62.Padded.Info.ImageLabel.Visible = false
				v62:SetAttribute("DevProductId", v3.ProductId)
				if v13 then
					v62:AddTag("DevProductPurchase")
				end
			end
			table.insert(t2, {
				tile = v62,
				tier = v7.Tier,
				price = v3.Price,
				isProduct = v52
			})
		end
	end
	table.sort(t2, function(p1, p2) --[[ Line: 144 ]]
		if (p1.isProduct or p2.isProduct) and not (p1.isProduct and p2.isProduct) then
			return p2.isProduct
		end
		if p1.tier == p2.tier then
			return p1.price < p2.price
		else
			return p1.tier < p2.tier
		end
	end)
	for v14, v15 in t2 do
		v15.tile.LayoutOrder = v14
		v15.tile.Parent = v6.Lanterns
	end
end
function t.PurchaseItem(p1, p2) --[[ PurchaseItem | Line: 161 | Upvalues: BoothShop (copy), v5 (ref), v4 (copy), InventoryMapping (copy), PlayerStatsUtility (copy), ItemUtility (copy), v3 (copy), Soundbook (copy) ]]
	local v1 = BoothShop[p2]
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
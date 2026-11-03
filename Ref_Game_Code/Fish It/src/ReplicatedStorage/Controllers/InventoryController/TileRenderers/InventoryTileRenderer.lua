-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local v1 = Net:RemoteEvent("FavoriteStateChanged")
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 22 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2._template = p1
	v2._parentFrame = p2
	v2._tiles = {}
	return v2
end
function t.GetCacheKey(p1, p2) --[[ GetCacheKey | Line: 31 ]]
	return p2.UUID
end
function t.GetLayoutOrder(p1, p2, p3) --[[ GetLayoutOrder | Line: 36 ]]
	local v1 = p2.Metadata and p2.Metadata.Weight or 0
	local Probability = p3.Probability
	local sum = 0
	if Probability then
		sum = math.log10(Probability.Chance) * 1000000 - v1 * 100
	else
		local v2 = p3.Data and p3.Data.Tier
		if v2 then
			sum = v2 * 1000000 - v1 * 100
		end
	end
	if p2.Favorited then
		sum = sum - 100000000
	end
	return sum
end
function t.Create(p1, p2, p3, p4, p5) --[[ Create | Line: 60 | Upvalues: TierUtility (copy), ItemStringUtility (copy), ItemUtility (copy), StringLibrary (copy), ToolTip (copy), TradeData (copy), v1 (copy), Soundbook (copy) ]]
	local v12 = p1:GetCacheKey(p2)
	local v2 = p1._tiles[v12]
	if v2 then
		p1:Update(v2, p2, p3, p4, p5)
		return v2
	end
	local Metadata = p2.Metadata
	local v3 = if Metadata then Metadata.Weight else Metadata
	local v4 = p1:GetLayoutOrder(p2, p3)
	local Probability = p3.Probability
	local v5 = nil
	if Probability then
		v5 = TierUtility:GetTierFromRarity(Probability.Chance)
	else
		local v7 = p3.Data and p3.Data.Tier
		if v7 then
			v5 = TierUtility:GetTier(v7)
		end
	end
	local v9 = ItemStringUtility.GetItemName(p2, p3)
	local v10 = p1._template:Clone()
	v10.ItemName.Text = v9
	v10.Vector.Image = p3.Data.Icon or ""
	local v11 = if Metadata then Metadata.VariantId else Metadata
	local v122 = if v11 then ItemUtility:GetVariantData(v11) else v11
	if v122 then
		v10.Variant.UIGradient.Color = v122.Data.TierColor
		v10.Variant.ItemName.UIGradient.Color = v122.Data.TierColor
		v10.Variant.ItemName.Text = v122.Data.Name
		v10.Variant.Visible = true
	else
		v10.Variant.Visible = false
	end
	local Weight = p3.Weight
	if Weight and v3 then
		if (if Weight.Big.Min <= v3 then true else false) or v5.Tier == 8 then
			v10.Vector.Size = UDim2.fromScale(1.4, 1.4)
			v10.ClipsDescendants = true
		end
		v10.WeightFrame.Weight.Text = StringLibrary:AddWeight(v3)
		v10.WeightFrame.Weight.Visible = true
	elseif p2.Quantity then
		v10.WeightFrame.Weight.Text = "x" .. StringLibrary:AddCommas(p2.Quantity)
		v10.WeightFrame.Weight.Visible = true
	else
		v10.WeightFrame.Weight.Visible = false
	end
	if v5 then
		v10.Shadow.UIGradient.Color = v5.TierColor
		v10.ItemName.TextColor3 = v5.TierColor.Keypoints[1].Value
	end
	local v14 = p5.GuiControl:Hook("Hold Button", v10)
	ToolTip.observe(v10, v14.Cleaner, function() --[[ Line: 139 | Upvalues: p2 (copy), TradeData (ref), p3 (copy), p4 (copy) ]]
		local Metadata = p2.Metadata
		local v1 = TradeData.FollowTradeRules(p3, p2)
		local v2 = if p4 == "Abilities" then p2.Name else p2.Id
		local t = {}
		t.Style = if p3.Data.Type == "Pets" then "Pet" else "Object"
		t.ItemType = p4
		t.Id = v2
		t.Metadata = p2.Metadata
		t.TradeLocked = v1
		t.UUID = p2.UUID
		return t
	end)
	v14.Clicked:Connect(function() --[[ Line: 155 | Upvalues: p5 (copy), p2 (copy), p3 (copy) ]]
		if not p5.OnInteraction then
			return
		end
		p5.OnInteraction(p2, p3)
	end)
	v14.Cleaner:Add(v1.OnClientEvent:Connect(function(p12, p22) --[[ Line: 162 | Upvalues: p2 (copy), p1 (copy), v10 (copy), p3 (copy), Soundbook (ref) ]]
		if p2.UUID ~= p12 then
			return
		end
		p1:_setFavorite(v10, p22, p1:GetLayoutOrder(p2, p3))
		if not p22 then
			return
		end
		Soundbook.Sounds.Favorited:Play()
	end))
	v10.LayoutOrder = v4
	v10.Parent = p1._parentFrame
	p1._tiles[v12] = v10
	p1:Update(v10, p2, p3, p4, p5)
	return v10
end
function t.Update(p1, p2, p3, p4, p5, p6) --[[ Update | Line: 183 | Upvalues: StringLibrary (copy) ]]
	p1:_setFavorite(p2, p3.Favorited, (p1:GetLayoutOrder(p3, p4)))
	local v2
	if p4.Data.Type == "Abilities" then
		local v3 = p6.PlayerReplion:Get({ "Abilities", "Equipped" })
		v2 = if v3 and v3 ~= "" then { v3 } else {}
	elseif p4.Data.Type == "Emotes" then
		local v4 = p6.PlayerReplion:Get("EquippedEmotes")
		v2 = if typeof(v4) == "table" then v4 else {}
	else
		v2 = if p4.Data.Type == "Pets" then { (p6.PlayerReplion:GetExpect("EquippedPetUUID")) } else p6.PlayerReplion:GetExpect("EquippedItems")
	end
	p2.Equipped.Visible = table.find(v2, p3.UUID) ~= nil
	if not p3.Quantity then
		return
	end
	p2.WeightFrame.Weight.Text = "x" .. StringLibrary:AddCommas(p3.Quantity)
end
function t._setFavorite(p1, p2, p3, p4) --[[ _setFavorite | Line: 222 ]]
	local v1 = p3 and true or false
	p2.LayoutOrder = if v1 then p4 - 100000000 else p4
	p2.Star.Visible = v1
	p2.UIStroke.Enabled = v1
end
function t.GetTile(p1, p2) --[[ GetTile | Line: 230 ]]
	return p1._tiles[p2]
end
function t.GetAllTiles(p1) --[[ GetAllTiles | Line: 235 ]]
	return p1._tiles
end
function t.DestroyAll(p1) --[[ DestroyAll | Line: 240 ]]
	for v1, v2 in p1._tiles do
		v2:Destroy()
	end
	table.clear(p1._tiles)
end
return t
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local ItemStringUtility = require(ReplicatedStorage.Modules.ItemStringUtility)
local EventTags = require(ReplicatedStorage.Modules.EventTags)
local ColorUtility = require(ReplicatedStorage.Modules.ColorUtility)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
require(ReplicatedStorage.Types.Modifiers)
local v1 = script.Secret
local t = {
	vectorSize = UDim2.fromScale(0.75, 0.75),
	vectorPosition = UDim2.fromScale(0.5, 0.5),
	vectorAnchorPoint = Vector2.new(0.5, 0.5)
}
local t2 = {
	vectorSize = UDim2.fromScale(1, 1),
	vectorPosition = UDim2.fromScale(0.5, 0.5),
	vectorAnchorPoint = Vector2.new(0.5, 0.5)
}
local t3 = {
	vectorSize = UDim2.fromScale(1.5, 1.5),
	vectorPosition = UDim2.fromScale(0.5, 0.5),
	vectorAnchorPoint = Vector2.new(0.5, 0.5)
}
local t4 = {
	["Fishing Rods"] = {
		[true] = t3,
		[false] = t3
	},
	Fish = {
		[true] = t2,
		[false] = t
	},
	Boats = {
		[true] = t2,
		[false] = t2
	},
	All = {
		[true] = t,
		[false] = t
	}
}
local function filterByType(p1) --[[ filterByType | Line: 75 ]]
	return function(p12) --[[ Line: 76 | Upvalues: p1 (copy) ]]
		return p12.Data.Type == p1
	end
end
local t5 = {}
t5.__index = t5
function t5.new(p1, p2, p3, p4, p5) --[[ new | Line: 87 | Upvalues: Trove (copy), t5 (copy), Players (copy), Replion (copy), Signal (copy) ]]
	local v2 = setmetatable({
		Loaded = false,
		Scale = 1,
		Cleaner = Trove.new(),
		TileCleaner = Trove.new(),
		Tiles = {}
	}, t5)
	if p1 then
		v2.Player = p1
		v2.LocalPlayer = p1 == Players.LocalPlayer
	end
	if p3 then
		v2.Frame = p3
	end
	if p2 then
		local v3 = Replion.Client:WaitReplion(p2)
		if not v3 or v3.Destroyed then
			error("No trade replion found!")
		end
		v2.SessionToken = p2
		v2.TradeReplion = v3
	end
	if p4 then
		v2.UseFavorites = p4
	end
	if p5 then
		v2.UseFilter = p5
		v2.Refresh = Signal.new()
		v2.FilterChanged = Signal.new()
		v2:SetFilter("Fish", "")
	end
	v2:Start()
	return v2
end
function t5.SetFilter(p1, p2, p3) --[[ SetFilter | Line: 130 ]]
	if not p1.UseFilter then
		task.spawn(function() --[[ Line: 132 ]]
			warn("Stack trace:", debug.traceback())
			error("Unable to use filters!")
		end)
		return
	end
	local v1 = string.lower(p3)
	if string.len(v1) == 0 then
		function p1.Filter(p1) --[[ Line: 141 | Upvalues: p2 (copy) ]]
			return p1.Data.Type == p2
		end
	else
		function p1.Filter(p1) --[[ Line: 145 | Upvalues: p2 (copy), v1 (copy) ]]
			if p1.Data.Type ~= p2 then
				return false
			end
			return string.find(string.lower(p1.Data.Name), v1) == 1
		end
	end
	if not p1.Loaded then
		return
	end
	p1.Refresh:Fire()
end
function t5.Start(p1) --[[ Start | Line: 159 ]]
	if p1.Refresh then
		local v1 = nil
		p1.Refresh:Connect(function() --[[ Line: 163 | Upvalues: v1 (ref), p1 (copy) ]]
			if not v1 then
				v1 = task.delay(0.05, function() --[[ Line: 168 | Upvalues: v1 (ref), p1 (ref) ]]
					v1 = nil
					for v3, v4 in p1.Tiles do
						if v4.Tile:GetAttribute("InTrade") ~= true then
							local v12, v2
							if p1.UseFilter then
								v12 = if p1.Filter and p1.Filter(v4.Data) == true then true else not p1.Filter
								v2 = v12
							else
								v2 = true
							end
							v4.Tile.Visible = v2
						end
					end
					if not p1.FilterChanged then
						return
					end
					p1.FilterChanged:Fire()
				end)
				return
			end
			pcall(task.cancel, v1)
			v1 = task.delay(0.05, function() --[[ Line: 168 | Upvalues: v1 (ref), p1 (ref) ]]
				v1 = nil
				for v3, v4 in p1.Tiles do
					if v4.Tile:GetAttribute("InTrade") ~= true then
						local v12, v2
						if p1.UseFilter then
							v12 = if p1.Filter and p1.Filter(v4.Data) == true then true else not p1.Filter
							v2 = v12
						else
							v2 = true
						end
						v4.Tile.Visible = v2
					end
				end
				if not p1.FilterChanged then
					return
				end
				p1.FilterChanged:Fire()
			end)
		end)
	end
	local v2 = if p1.TradeReplion then p1.TradeReplion:BeforeDestroy(function() --[[ Line: 197 | Upvalues: p1 (copy) ]]
	p1:Destroy()
end) else nil
	p1.Cleaner:Add(function() --[[ Line: 202 | Upvalues: v2 (ref) ]]
		if not v2 then
			return
		end
		v2:Destroy()
	end)
	p1.Loaded = true
end
function t5.Destroy(p1) --[[ Destroy | Line: 211 ]]
	p1.Cleaner:Destroy()
	p1.TileCleaner:Destroy()
	if p1.Refresh then
		p1.Refresh:DisconnectAll()
		p1.Refresh:Destroy()
	end
	if p1.FilterChanged then
		p1.FilterChanged:DisconnectAll()
		p1.FilterChanged:Destroy()
	end
	table.clear(p1.Tiles)
end
function t5.DestroyTiles(p1) --[[ DestroyTiles | Line: 228 ]]
	if p1.CleaningTiles then
		return
	end
	p1.CleaningTiles = true
	p1.TileCleaner:Clean()
	p1.Tiles = {}
	if p1.UseFilter then
		p1:SetFilter("Fish", "")
	end
	p1.CleaningTiles = false
end
function t5.CleanFilteredTiles(p1) --[[ CleanFilteredTiles | Line: 244 ]]
	for v1, v2 in p1.Tiles do
		if not ((if v2.Tile:GetAttribute("InTrade") == true then true else false) or v2.Tile.Visible) then
			p1:DestroyTileFromTile(v2.Tile)
		end
	end
end
function t5.DestroyTile(p1, p2, p3, p4) --[[ DestroyTile | Line: 255 | Upvalues: ItemUtility (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v1 then
		return
	end
	local v2 = getTileId(v1, p4)
	local v3 = p1.Tiles[v2]
	if not v3 then
		return
	end
	p1.Tiles[v2] = nil
	p1.TileCleaner:Remove(v3.Tile)
end
function t5.DestroyTileFromTile(p1, p2) --[[ DestroyTileFromTile | Line: 269 ]]
	if p1.Tiles[p2.Name] then
		p1.Tiles[p2.Name] = nil
		p1.TileCleaner:Remove(p2)
	end
end
function t5.Draw(p1, p2, p3, p4, p5) --[[ Draw | Line: 278 | Upvalues: ItemUtility (copy), TradeData (copy), v1 (copy), StringLibrary (copy), ItemStringUtility (copy), t4 (copy), t2 (copy), ToolTip (copy) ]]
	local v12 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v12 then
		warn((("Unable to render item visual for type: \"%*\"\" itemId: %*!"):format(p2, p3)))
		return
	end
	local v2 = getTierData(v12)
	if not v2 then
		warn((("Unable to fetch tier for type: \"%*\"\" itemId: %*!"):format(p2, p3)))
	end
	if not TradeData.FollowTradeRules(v12, p4) then
		return
	end
	local v3 = getTileId(v12, p4.UUID)
	if p1.Tiles[v3] then
		warn("Unable to render duplicate tile!", debug.traceback())
		return
	end
	local v4 = getEventTagData(v12, p4)
	local Type = v12.Data.Type
	local v5 = v1:Clone()
	v5.Name = v3
	p1.TileCleaner:Add(v5)
	local v6 = getColorBlend(v2, v4)
	v5.UIStroke.UIGradient.Color = v6
	v5.UIGradient.Color = v6
	v5.Shadow.UIGradient.Color = v6
	if v2.Tier >= 4 then
		v5.UIGradient:AddTag("AnimateTier")
		v5.UIStroke.UIGradient:AddTag("AnimateTier")
		v5.Shadow.UIGradient:AddTag("AnimateTier")
	end
	local v7 = if p1.UseFavorites and p1.LocalPlayer then p4.Favorited else nil
	local v8 = if v7 then Color3.new(255/255, 255/255, 255/255) else Color3.new(0/255, 0/255, 0/255)
	v5.Star.Visible = v7
	v5.UIOutline.Color = v8
	v5.UIOutline.UIGradient.Enabled = v7
	local v9 = if p4.Metadata then p4.Metadata.Shiny and true or false else false
	v5.ShinyUnderlay.Visible = v9
	v5.Configuration.ShinyFrame.Visible = v9
	local v10 = if p4.Metadata then p4.Metadata.VariantId else nil
	local v11 = if v10 then ItemUtility:GetVariantData(v10) else nil
	if v11 then
		v5.Label.VariantLabel.Text = v11.Data.Name
		v5.Label.VariantLabel.UIGradient.Color = v11.Data.TierColor
		v5.Label.VariantLabel.Visible = true
	else
		v5.Label.VariantLabel.Visible = false
	end
	local Weight = v12.Weight
	local v122 = if p4.Metadata then p4.Metadata.Weight else nil
	local v13 = if Weight and v122 then if Weight.Big.Min <= v122 then true else false else false
	if v122 then
		v5.Configuration.WeightFrame.Label.Text = StringLibrary:AddWeight(v122)
		v5.Configuration.WeightFrame.Visible = true
		v5.Configuration.BigFrame.Visible = v13
	else
		v5.Configuration.BigFrame.Visible = false
		v5.Configuration.WeightFrame.Visible = false
	end
	local v14 = if Type == "Fish" then ItemStringUtility.GetItemName(p4, v12) else v12.Data.Name
	local v17 = if v2.Tier == 8 then t2 else (t4[Type] or t4.All)[if Type == "Fishing Rods" then v12.Data.NewIcon and true or false elseif v122 then v13 else false]
	v5.Vector.Size = v17.vectorSize
	v5.Vector.Position = v17.vectorPosition
	v5.Vector.AnchorPoint = v17.vectorAnchorPoint
	v5.Label.Text = v14
	v5.Vector.Image = v12.Data.Icon
	local v18 = nil
	ToolTip.observe(v5, nil, function() --[[ Line: 385 | Upvalues: p1 (copy), v3 (copy), p4 (copy), TradeData (ref), v12 (copy), v18 (ref), v5 (copy), ToolTip (ref) ]]
		p1.SelectedTileId = v3
		local Metadata = p4.Metadata
		local v1 = TradeData.FollowTradeRules(v12, p4)
		if not v18 then
			v18 = v5.Destroying:Once(function() --[[ Line: 395 | Upvalues: p1 (ref), v3 (ref), ToolTip (ref) ]]
				if p1.SelectedTileId ~= v3 then
					return
				end
				p1.SelectedTileId = nil
				ToolTip.destroyAll()
			end)
		end
		local t = {}
		t.Style = if v12.Data.Type == "Pets" then "Pet" else "Object"
		t.ItemType = v12.Data.Type
		t.Id = v12.Data.Id
		t.Metadata = p4.Metadata
		t.TradeLocked = v1
		t.UUID = p4.UUID
		return t
	end)
	local t = {
		Tile = v5,
		Data = v12,
		Item = p4,
		Type = v12.Data.Type
	}
	p1.Tiles[v3] = t
	v5.LayoutOrder = if p5 then p5 else p1:GetLayoutOrder(p4, v12, v2)
	v5.Visible = if p1.UseFilter then if p1.Filter and p1.Filter(v12) == true then true else not p1.Filter else true
	if not p1.Frame then
		return t
	end
	v5.Parent = p1.Frame
	return t
end
function t5.GetLayoutOrder(p1, p2, p3, p4) --[[ GetLayoutOrder | Line: 445 ]]
	local v2 = (if p2.Metadata then p2.Metadata.Weight else nil) or 1
	local v3 = if p1.UseFavorites and (p1.LocalPlayer and p2.Favorited) then 500000 else 0
	if not p4 then
		p4 = getTierData(p3)
	end
	return p4.Tier * -100000 - math.log(v2) * 100 - v3
end
function t5.AddInteractionFromTile(p1, p2, p3) --[[ AddInteractionFromTile | Line: 461 ]]
	if p1.Tiles[p2.Name] == nil then
		warn("Unable to add interaction to this tile!")
	else
		return p1:_bindInteraction(p2, p3)
	end
end
function t5.AddInteraction(p1, p2, p3, p4, p5) --[[ AddInteraction | Line: 470 | Upvalues: ItemUtility (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v1 then
		return
	end
	local v3 = getTileId(v1, if p4 then p4.UUID else nil)
	if not v3 then
		return
	end
	local v4 = p1.Tiles[v3]
	if not v4 then
		return
	end
	p1:_bindInteraction(v4.Tile, p5)
end
function t5.SetScale(p1, p2) --[[ SetScale | Line: 488 ]]
	p1.Scale = p2
end
function t5._bindInteraction(p1, p2, p3) --[[ _bindInteraction | Line: 492 | Upvalues: GuiControl (copy) ]]
	local v1 = GuiControl:Hook("Hold Button", p2, nil, 0.5, nil, nil, 0.9)
	v1.Clicked:Connect(function() --[[ Line: 495 | Upvalues: p3 (copy) ]]
		p3()
	end)
	return function() --[[ Line: 499 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end
end
function getTileId(p1, p2) --[[ getTileId | Line: 504 ]]
	local v1 = p1.Data.Name
	if p2 then
		return ("%*-%*"):format(v1, p2)
	else
		return ("%*-%*"):format(v1, p1.Data.Id)
	end
end
function getTierData(p1) --[[ getTierData | Line: 517 | Upvalues: TierUtility (copy) ]]
	local v1 = p1.Probability or p1.ForcedProbability
	if v1 then
		return TierUtility:GetTierFromRarity(v1.Chance)
	else
		return TierUtility:GetTier(p1.Data.Tier)
	end
end
function getEventTagData(p1, p2) --[[ getEventTagData | Line: 530 | Upvalues: EventTags (copy) ]]
	local Metadata = p2.Metadata
	local v1 = if Metadata and Metadata.EventTag then Metadata.EventTag elseif p1.EventTag then p1.EventTag else nil
	if v1 then
		return EventTags[v1]
	end
end
function getColorBlend(p1, p2) --[[ getColorBlend | Line: 544 | Upvalues: ColorUtility (copy) ]]
	local t = {}
	if p2 then
		table.insert(t, p2.TierColor)
	end
	if p1 then
		table.insert(t, p1.TierColor)
	end
	return ColorUtility:BlendColors(t)
end
t5.getTileId = getTileId
t5.getEventTagData = getEventTagData
t5.getTierData = getTierData
return t5
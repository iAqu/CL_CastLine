-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Modules.ColorUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TileInteraction = require(script.Parent.Parent.TileInteraction)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5, p6, p7, p8, p9) --[[ new | Line: 23 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	v2._tileTemplate = p1
	v2._scrollFrame = p2
	v2._focusPanel = p3
	v2._infoFrame = p4
	v2._sampleFrame = p5
	v2._fishTileTemplate = p6
	v2._fishScrollFrame = p7
	v2._perkTileTemplate = p8
	v2._perkFrame = p9
	v2.RAPTrove = Trove.new()
	v2._rapRequest = false
	v2._tiles = {}
	v2._focusTrove = Trove.new()
	v2._selectedCharmId = nil
	return v2
end
function t.GetCacheKey(p1, p2) --[[ GetCacheKey | Line: 56 | Upvalues: ItemUtility (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType("Charms", p2.Id)
	return if v1 then v1.Data.Id or 0 else 0
end
function t.Create(p1, p2, p3) --[[ Create | Line: 62 | Upvalues: ItemUtility (copy), TierUtility (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType("Charms", p2.Id)
	if not v1 then
		return nil
	end
	local v2 = v1.Data.Name
	local Id = v1.Data.Id
	local v3 = p1._tiles[Id]
	if v3 then
		return v3
	end
	local PlayerReplion = p3.PlayerReplion
	local v4 = p1._tileTemplate:Clone()
	local v5 = if v1.Modifiers and v1.Modifiers.BaseLuck then v1.Modifiers.BaseLuck * 10000 else string.len(v2)
	local v7 = TierUtility:GetTier(v1.Data.Tier)
	if v7 then
		local v8 = v7.TierColor.Keypoints[1].Value
		v4.Label.TextColor3 = v8
		v4.UIStroke.Color = v8
		v4.BG.Glow.UIGradient.Color = v7.TierColor
	end
	v4.Label.Text = v2 or ""
	v4.BG.VectorBig.Image = v1.Data.Icon or ""
	local v9 = p3.GuiControl:Hook("Hold Button", v4)
	v9.Clicked:Connect(function() --[[ Line: 104 | Upvalues: p1 (copy), v2 (copy), Id (copy), p3 (copy) ]]
		p1:_selectCharm(v2, Id, p3)
	end)
	local function refreshOutline() --[[ refreshOutline | Line: 109 | Upvalues: PlayerReplion (copy), v4 (copy), Id (copy) ]]
		v4.UIStroke.Enabled = PlayerReplion:GetExpect({ "EquippedCharmId" }) == Id
	end
	v9.Cleaner:Add(PlayerReplion:OnChange({ "EquippedCharmId" }, refreshOutline))
	v4.UIStroke.Enabled = if PlayerReplion:GetExpect({ "EquippedCharmId" }) == Id then true else false
	v4.LayoutOrder = v5
	v4.Parent = p1._scrollFrame
	p1._tiles[Id] = v4
	return v4
end
function t._selectCharm(p1, p2, p3, p4) --[[ _selectCharm | Line: 125 | Upvalues: PlayerStatsUtility (copy), ItemUtility (copy), TileInteraction (copy) ]]
	local PlayerReplion = p4.PlayerReplion
	local v1 = if (PlayerReplion:GetExpect("CharmModifiers")[p2] or 0) > 0 then {
	Quantity = 1,
	Id = p3
} else PlayerStatsUtility:GetItemFromInventory(PlayerReplion, function(p1) --[[ Line: 134 | Upvalues: p3 (copy) ]]
	return p1.Id == p3
end, "Charms")
	if not v1 then
		return
	end
	p1:FocusCharm(v1, p4)
	local v3 = ItemUtility.GetItemDataFromItemType("Charms", p2)
	TileInteraction:EquipCharm(p2, if v3 then v3.Level else v3)
end
function t.FocusCharm(p1, p2, p3) --[[ FocusCharm | Line: 150 | Upvalues: ItemUtility (copy), TierUtility (copy), PlayerStatsUtility (copy), RAPController (copy), StringLibrary (copy), TradeData (copy) ]]
	p1:DestroyFocus()
	local v1 = ItemUtility.GetItemDataFromItemType("Charms", p2.Id)
	if not v1 then
		return
	end
	if p1._rapRequest then
		p1.RAPTrove:Clean()
	end
	local PlayerReplion = p3.PlayerReplion
	local Id = v1.Data.Id
	local v2 = v1.Data.Name
	local v3 = v1.Uses or 0
	local v5 = v1.Modifiers and v1.Modifiers.BaseLuck or 0
	local v6 = if v1.Probability then TierUtility:GetTierFromRarity(v1.Probability.Chance) else TierUtility:GetTier(v1.Data.Tier)
	local Display = p1._infoFrame.Display
	Display.UIStroke.UIGradient.Color = v6.TierColor
	Display.Inner.Glow.UIGradient.Color = v6.TierColor
	Display.Inner.ItemName.Text = v2
	Display.Inner.Vector.Image = v1.Data.Icon or ""
	local function refreshQuantity() --[[ refreshQuantity | Line: 186 | Upvalues: PlayerReplion (copy), v2 (copy), PlayerStatsUtility (ref), Id (copy), Display (copy), v3 (copy) ]]
		PlayerReplion:GetExpect("EquippedCharmId")
		local v1 = PlayerReplion:GetExpect("CharmModifiers")[v2]
		local v22 = PlayerStatsUtility:GetItemFromInventory(PlayerReplion, function(p1) --[[ Line: 191 | Upvalues: Id (ref) ]]
			return p1.Id == Id
		end, "Charms")
		local v32 = if v22 then v22.Quantity or 0 else 0
		if v32 > 0 then
			Display.Inner.Quantity.Text = ("x%d"):format(v32)
			Display.Inner.Quantity.Visible = true
		else
			Display.Inner.Quantity.Visible = false
		end
		if v1 then
			Display.Inner.Remaining.Text = ("%d / %d"):format(v1, v3)
			Display.Inner.Remaining.Visible = true
		else
			Display.Inner.Remaining.Visible = false
		end
	end
	p1._focusTrove:Add(PlayerReplion:OnChange({ "CharmModifiers" }, refreshQuantity))
	p1._focusTrove:Add(PlayerReplion:OnChange({ "Inventory", "Charms" }, refreshQuantity))
	p1._focusTrove:Add(PlayerReplion:OnChange({ "EquippedCharmId" }, refreshQuantity))
	refreshQuantity()
	p1._infoFrame.Frame.Level.Counter.Text = ("%d"):format(v1.Level or 0)
	p1._infoFrame.Frame.Uses.Counter.Text = ("%d"):format(v3)
	p1._infoFrame.Frame.Luck.Counter.Text = ("%*%%"):format((math.round(v5 * 100)))
	p1._infoFrame.Frame.Luck.Visible = if v5 > 0 then true else false
	local RapCounter = p1._infoFrame.Frame.RapCounter
	if v1.TradeLocked then
		RapCounter.Visible = false
	else
		local v10 = RAPController:GetRAP(v1.Data.Type, v1.Data.Name)
		if v10 then
			RapCounter.Counter.Text = StringLibrary:AddCommas(v10)
		else
			RapCounter.Counter.Text = "Loading"
			local v11 = nil
			v11 = p1.RAPTrove:Add(task.spawn(function() --[[ Line: 235 | Upvalues: RAPController (ref), v1 (copy), StringLibrary (ref), RapCounter (copy), p1 (copy), v11 (ref) ]]
				local v12 = RAPController:GetRAPAsync(v1.Data.Type, v1.Data.Name)
				RapCounter.Counter.Text = if typeof(v12) == "number" then StringLibrary:AddCommas(v12) else "Unknown"
				p1.RAPTrove:Remove(v11)
				p1._rapRequest = false
			end))
		end
		RapCounter.Visible = true
	end
	if TradeData.FollowTradeRules(v1, p2) then
		local v12 = RAPController:GetRAP(v1.Data.Type, v1.Data.Name)
		RapCounter.Counter.Text = if v12 then StringLibrary:AddCommas(v12) else "???"
		RapCounter.Visible = true
	else
		RapCounter.Visible = false
	end
	if v1.Modifiers then
		for v15, v16 in v1.Modifiers do
			local v14
			if v15 ~= "BaseLuck" then
				local v17, v18 = PlayerStatsUtility:GetModifierDisplayName(v15)
				if v17 then
					v14 = if v17:find("Multi") or v15:find("Multiplier") then ("x%*"):format(math.round((1 + v16) * 10) / 10) else ("%*%%"):format((math.round(v16 * 100)))
					local v21 = p1._sampleFrame:Clone()
					v21.Label.Text = ("%*:"):format(v17)
					v21.Counter.Text = v14
					v21.Counter.UIGradient.Color = ColorSequence.new(v18)
					v21.LayoutOrder = math.abs(v16 * 100)
					v21.Parent = p1._infoFrame.Frame
					p1._focusTrove:Add(v21)
				end
			end
		end
	end
	local v22 = false
	if v1.FishModifiers then
		for v24, v25 in v1.FishModifiers do
			local v23
			local v26 = ItemUtility.GetItemDataFromItemType("Fish", v24)
			if v26 then
				local v27 = string.len(v24)
				if v26.Probability then
					v27 = 1 / v26.Probability.Chance
					v23 = TierUtility:GetTierFromRarity(v26.Probability.Chance)
				else
					v23 = TierUtility:GetTier(v26.Data.Tier)
				end
				local v30 = p1._fishTileTemplate:Clone()
				v30.Inner.Top.Counter.Text = ("x%* Chance"):format(math.floor((v25 + 1) * 10) / 10)
				v30.Inner.Glow.UIGradient.Color = v23.TierColor
				v30.UIStroke.UIGradient.Color = v23.TierColor
				v30.Inner.Configuration.ItemName.Text = v26.Data.Name
				v30.Inner.Vector.Image = v26.Data.Icon or ""
				v30.LayoutOrder = v27
				v30.Parent = p1._fishScrollFrame
				p1._focusTrove:Add(v30)
				v22 = true
			end
		end
	end
	local v31
	if v1.Perks then
		for v32, v33 in v1.Perks do

		end
		v31 = true
	else
		v31 = false
	end
	p1._perkFrame.Visible = v31
	p1._fishScrollFrame.Parent.Visible = v22
	p1._focusPanel.Visible = true
	p1._selectedCharmId = Id
	p1._selectedCharmUUID = p2.UUID
end
function t.DestroyFocus(p1) --[[ DestroyFocus | Line: 344 ]]
	p1._focusTrove:Clean()
	p1._focusPanel.Visible = false
	p1.RAPTrove:Clean()
	p1._rapRequest = false
	p1._selectedCharmId = nil
	p1._selectedCharmUUID = nil
end
function t.GetSelectedCharmId(p1) --[[ GetSelectedCharmId | Line: 356 ]]
	return p1._selectedCharmId
end
function t.GetTile(p1, p2) --[[ GetTile | Line: 361 ]]
	return p1._tiles[p2]
end
function t.GetAllTiles(p1) --[[ GetAllTiles | Line: 366 ]]
	return p1._tiles
end
function t.DestroyAll(p1) --[[ DestroyAll | Line: 371 ]]
	p1:DestroyFocus()
	for v1, v2 in p1._tiles do
		v2:Destroy()
	end
	table.clear(p1._tiles)
end
return t
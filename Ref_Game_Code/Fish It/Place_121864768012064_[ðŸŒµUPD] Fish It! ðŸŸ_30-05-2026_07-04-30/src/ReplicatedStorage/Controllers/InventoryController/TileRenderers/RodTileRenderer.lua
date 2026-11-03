-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ColorUtility = require(ReplicatedStorage.Modules.ColorUtility)
local TileInteraction = require(script.Parent.Parent.TileInteraction)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local t = {}
t.__index = t
function t.new(p1, p2) --[[ new | Line: 26 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2._selectedTileId = nil
	v2._template = p1
	v2._parentFrame = p2
	v2._tiles = {}
	return v2
end
function t.GetCacheKey(p1, p2) --[[ GetCacheKey | Line: 36 ]]
	return p2.UUID
end
function t.GetLayoutOrder(p1, p2, p3) --[[ GetLayoutOrder | Line: 41 | Upvalues: PlayerStatsUtility (copy) ]]
	local Tier = p3.Data.Tier
	local v2 = if p3.RollData then if p2 and (p2.Metadata and p2.Metadata.Modifiers) then PlayerStatsUtility:_mergeStats(p3.RollData, p2.Metadata.Modifiers) else p3.RollData else nil
	if v2 then
		return v2.BaseLuck * -1000 + (Tier or 0)
	end
	if p3.IsSkin then
		return 500 + (Tier or 0)
	else
		return Tier or 0
	end
end
function t.Create(p1, p2, p3, p4, p5) --[[ Create | Line: 67 | Upvalues: PlayerStatsUtility (copy), StringLibrary (copy), TradeData (copy), RAPController (copy), ToolTip (copy), TierUtility (copy), TileInteraction (copy) ]]
	local v1 = p1:GetCacheKey(p2)
	if p3.Data.Type ~= "Fishing Rods" then
		return nil
	end
	local v2 = p1._tiles[v1]
	if v2 then
		p1:Update(v2, p2, p3, p4, p5)
		return v2
	end
	local v3 = nil
	local v4
	if p2.Metadata and p2.Metadata.Modifiers then
		v3 = true
		v4 = PlayerStatsUtility:_mergeStats(p3.RollData or {}, p2.Metadata.Modifiers)
	else
		v4 = p3.RollData
	end
	local v8 = p3.IsSkin and true or false
	local Tier = p3.Data.Tier
	local v9 = p1._template:Clone()
	local EquipAsSkin = v9.Padded.Top.EquipAsSkin
	local Luck = v9.Padded.Bottom.Luck
	if p3.Data.NewIcon then
		v9.BG.Vector.Position = UDim2.fromScale(0.5, 0.5)
		v9.BG.Vector.AnchorPoint = Vector2.new(0.5, 0.5)
	end
	v9.Name = p3.Data.Name
	v9.Padded.Top.Label.Text = p3.Data.Name or ""
	v9.BG.Vector.Image = p3.Data.Icon or ""
	if v8 then
		v9.Padded.Bottom.Visible = false
	else
		if v4 then
			local v11 = math.floor((v4.BaseLuck or 1) * 100)
			local v12 = if p3.VisualClickPowerPercent then math.round(p3.VisualClickPowerPercent * 100) else math.round(((p3.ClickPower or 0.05) * 25) ^ 2.5)
			local v15 = StringLibrary:AddWeight((p3.MaxWeight or 5) + (v4.MaxWeight or 0))
			v9.Padded.Bottom.Luck.Counter.Text = ("%*%%"):format(v11)
			v9.Padded.Bottom.Speed.Counter.Text = ("%*%%"):format(v12)
			v9.Padded.Bottom.Weight.Counter.Text = v15
		end
		if p3.Modifiers then
			v3, v4 = true, PlayerStatsUtility:_mergeStats(v4, p3.Modifiers)
		end
		if v3 then
			for k, v in pairs(v4) do
				local v17
				if k ~= "BaseLuck" and k ~= "Frequency" then
					local v18, v19 = PlayerStatsUtility:GetModifierDisplayName(k)
					if v18 then
						v17 = if v18:find("Multi") or k:find("Multiplier") then ("x%*"):format(math.round((1 + v) * 10) / 10) else ("%*%%"):format((math.round(v * 100)))
						local v22 = Luck:Clone()
						v22.Label.Text = ("%*:"):format(v18)
						v22.Counter.Text = v17
						v22.Counter.TextColor3 = v19
						v22.Parent = v9.Padded.Bottom
					end
				end
			end
		end
		v9.Padded.Bottom.Visible = true
	end
	local Top = v9.Padded.Top
	local RapCounter = Top.RapCounter
	local Stack = Top.Stack
	Stack.LayoutOrder = RapCounter.LayoutOrder + 1
	if typeof(p2.Quantity) == "number" and p2.Quantity > 1 then
		Stack.Counter.Text = ("Owned Copies: x%*"):format((StringLibrary:AddCommas(p2.Quantity)))
		Stack.Visible = true
	else
		Stack.Visible = false
	end
	if p3.IsSkin and not p3.TradeLocked then
		if not TradeData.FollowTradeRules(p3, p2) then
			local v24 = script.TradeLocked:Clone()
			local Metadata = p2.Metadata
			local v25 = Metadata and Metadata.TradeLock
			if v25 and v25.Type == "Timestamp" then
				v24.Label.Text = ("\240\159\148\146 Locked (%*)"):format((formatDHMS((math.max(v25.Time - workspace:GetServerTimeNow(), 0)))))
			elseif v25 and v25.Type == "Untradable" then
				v24.Label.Text = "\240\159\148\146 Untradable"
			end
			v24.LayoutOrder = RapCounter.LayoutOrder + 2
			v24.Parent = v9.Padded.Top
		end
		local v28 = RAPController:GetRAP(p3.Data.Type, p3.Data.Name)
		RapCounter.Counter.Text = if v28 then StringLibrary:AddCommas(v28) else "???"
		RapCounter.Visible = true
		local v30 = nil
		ToolTip.observe(v9, nil, function() --[[ Line: 224 | Upvalues: p1 (copy), p2 (copy), TradeData (ref), p3 (copy), v30 (ref), v9 (copy), ToolTip (ref) ]]
			p1._selectedTileId = p2.UUID
			local Metadata = p2.Metadata
			local v1 = TradeData.FollowTradeRules(p3, p2)
			if v30 then
				return {
					Style = "Object",
					ItemType = p3.Data.Type,
					Id = p3.Data.Id,
					Metadata = p2.Metadata,
					TradeLocked = v1,
					UUID = p2.UUID
				}
			end
			v30 = v9.Destroying:Once(function() --[[ Line: 234 | Upvalues: p1 (ref), p2 (ref), ToolTip (ref) ]]
				if p1._selectedTileId ~= p2.UUID then
					return
				end
				p1._selectedTileId = nil
				ToolTip.destroyAll()
			end)
			return {
				Style = "Object",
				ItemType = p3.Data.Type,
				Id = p3.Data.Id,
				Metadata = p2.Metadata,
				TradeLocked = v1,
				UUID = p2.UUID
			}
		end)
	else
		RapCounter.Visible = false
	end
	local v31 = if Tier then TierUtility:GetTier(Tier) else Tier
	if v31 and Tier > 1 then
		v9.Padded.Top.TierLabel.Text = v31.Name
		v9.Padded.Top.TierLabel.UIGradient.Color = v31.TierColor
		v9.Padded.Top.TierLabel.Visible = true
		v9.BG.Glow.UIGradient.Color = v31.TierColor
		v9.BG.Glow.Visible = true
	else
		v9.BG.Glow.Visible = false
	end
	local GuiControl = p5.GuiControl
	if not v8 then
		GuiControl:Hook("Hold Button", v9).Clicked:Connect(function() --[[ Line: 271 | Upvalues: TileInteraction (ref), p2 (copy) ]]
			TileInteraction:EquipRod(p2.UUID)
		end)
	end
	if v8 then
		p1:_setupSkinButton(v9, EquipAsSkin, p2, p5)
	else
		EquipAsSkin:Destroy()
	end
	v9.LayoutOrder = p1:GetLayoutOrder(p2, p3)
	v9.Parent = p1._parentFrame
	p1._tiles[v1] = v9
	p1:Update(v9, p2, p3, p4, p5)
	return v9
end
function t.Update(p1, p2, p3, p4, p5, p6) --[[ Update | Line: 295 | Upvalues: ItemUtility (copy) ]]
	p2.UIStroke.Enabled = if table.find(p5, p3.UUID) == nil then false else true
	local Metadata = p3.Metadata
	local Top = p2.Padded.Top
	local EnchantGradient = p2.EnchantGradient
	if not Metadata then
		EnchantGradient.Visible = false
		Top.EnchantFrame1.Visible = false
		Top.EnchantFrame2.Visible = false
		Top.MutationFrame.Visible = false
		return
	end
	local v2 = if Metadata.VariantId then ItemUtility:GetVariantData(Metadata.VariantId) else nil
	if v2 then
		Top.MutationFrame.Label.Text = v2.Data.Name
		Top.MutationFrame.Label.UIGradient.Color = v2.Data.TierColor
		Top.MutationFrame.Visible = true
	else
		Top.MutationFrame.Visible = false
	end
	local count = 0
	for v4, v5 in { Metadata.EnchantId, Metadata.EnchantId2 } do
		local v3
		local v6 = ItemUtility:GetEnchantData(v5)
		local v7 = Top[("EnchantFrame%*"):format(v4)]
		if v6 then
			count = count + 1
			v3 = if v6.Data and v6.Data.Description then ("\"%*\""):format(v6.Data.Description) else "\"Unknown\""
			v7.Description.Text = v3
			v7.Description.UIGradient.Color = v6.Data.TierColor
			v7.Label.Text = v6.Data.Name
			v7.Label.UIGradient.Color = v6.Data.TierColor
			v7.Visible = true
		end
	end
	if count == 0 then
		Top.EnchantFrame1.Visible = false
		Top.EnchantFrame2.Visible = false
		EnchantGradient.Visible = false
		return
	end
	local v9 = p1:_combineEnchantColors(Metadata)
	if v9 then
		EnchantGradient.UIGradient.Color = v9
		EnchantGradient.Visible = true
	else
		EnchantGradient.Visible = false
	end
end
function t._setupSkinButton(p1, p2, p3, p4, p5) --[[ _setupSkinButton | Line: 366 | Upvalues: spr (copy), TileInteraction (copy) ]]
	local GuiControl = p5.GuiControl
	local PlayerReplion = p5.PlayerReplion
	local function onSkinChanged(p1) --[[ onSkinChanged | Line: 370 | Upvalues: spr (ref), p3 (copy), p4 (copy) ]]
		spr.stop(p3)
		if p1 == p4.UUID then
			p3.Label.Text = "UNEQUIP SKIN"
			spr.target(p3, 3, 10, {
				ImageColor3 = Color3.fromRGB(255, 94, 97)
			})
		else
			p3.Label.Text = "EQUIP SKIN"
			spr.target(p3, 3, 10, {
				ImageColor3 = Color3.fromRGB(123, 187, 255)
			})
		end
	end
	local v1 = GuiControl:Hook("Hold Button", p3)
	local v2 = PlayerReplion:OnChange("EquippedSkinUUID", onSkinChanged)
	v1.Cleaner:Add(function() --[[ Line: 383 | Upvalues: v2 (copy) ]]
		v2:Disconnect()
	end)
	v1.Clicked:Connect(function() --[[ Line: 387 | Upvalues: TileInteraction (ref), p4 (copy), GuiControl (copy) ]]
		if not TileInteraction:ToggleRodSkin(p4.UUID) then
			return
		end
		GuiControl:Close()
	end)
	onSkinChanged(PlayerReplion.Data.EquippedSkinUUID)
	p3.Visible = true
end
function t._combineEnchantColors(p1, p2) --[[ _combineEnchantColors | Line: 399 | Upvalues: ItemUtility (copy), ColorUtility (copy) ]]
	if not p2 then
		return nil
	end
	local t = {}
	for v1, v2 in { p2.EnchantId, p2.EnchantId2 } do
		local v3 = ItemUtility:GetEnchantData(v2)
		if v3 then
			table.insert(t, v3.Data.TierColor.Keypoints[1].Value)
		end
	end
	if #t == 0 then
		return ColorSequence.new(Color3.fromRGB(255, 255, 255))
	end
	if #t == 1 then
		return ColorSequence.new(t[1])
	else
		return ColorUtility:AddStripes(t)
	end
end
function t.GetTile(p1, p2) --[[ GetTile | Line: 424 ]]
	return p1._tiles[p2]
end
function t.GetAllTiles(p1) --[[ GetAllTiles | Line: 429 ]]
	return p1._tiles
end
function t.DestroyAll(p1) --[[ DestroyAll | Line: 434 ]]
	for v1, v2 in p1._tiles do
		v2:Destroy()
	end
	table.clear(p1._tiles)
end
function formatDHMS(p1) --[[ formatDHMS | Line: 441 ]]
	local v1 = p1 % 86400
	local v2 = math.floor(p1 / 86400)
	local v3 = math.floor(v1 / 3600)
	local v4 = math.floor(v1 % 3600 / 60)
	local v5 = math.floor(p1 % 60)
	if v2 >= 1 then
		return string.format("%02dd %02dh %02dm %02ds", v2, v3, v4, v5)
	end
	if v3 >= 1 then
		return string.format("%02dh %02dm %02ds", v3, v4, v5)
	else
		return string.format("%02dm %02ds", v4, v5)
	end
end
return t
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TileInteraction = require(script.Parent.Parent.TileInteraction)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 22 | Upvalues: t (copy) ]]
	local v2 = setmetatable({}, t)
	v2._template = p1
	v2._parentFrame = p2
	v2._tiles = {}
	v2._mobileGridSize = p3
	return v2
end
function t.SetMobileGridSize(p1, p2) --[[ SetMobileGridSize | Line: 31 ]]
	p1._mobileGridSize = p2
end
function t.GetCacheKey(p1, p2) --[[ GetCacheKey | Line: 36 | Upvalues: ItemUtility (copy) ]]
	local v1 = ItemUtility:GetBaitData(p2.Id)
	return if v1 then v1.Data.Id or 0 else 0
end
function t.GetLayoutOrder(p1, p2, p3) --[[ GetLayoutOrder | Line: 42 ]]
	if p3.Modifiers then
		return (p3.Modifiers.BaseLuck or 0) * -1000
	else
		return string.len(p3.Data.Name)
	end
end
function t.Create(p1, p2, p3) --[[ Create | Line: 50 | Upvalues: ItemUtility (copy), PlayerStatsUtility (copy), StringLibrary (copy), TradeData (copy), RAPController (copy), ToolTip (copy), TierUtility (copy), TileInteraction (copy) ]]
	local v1 = ItemUtility:GetBaitData(p2.Id)
	if not v1 then
		return nil
	end
	local v2 = p1._tiles[p2.UUID]
	if v2 then
		p1:Update(v2, p2, v1, p3)
		return v2
	end
	local Id = v1.Data.Id
	local IsSkin = v1.IsSkin
	local Modifiers = v1.Modifiers
	local v3 = p1._template:Clone()
	local Luck = v3.Padded.Bottom.Luck
	local EquipAsSkin = v3.Padded.Top.EquipAsSkin
	v3.Padded.Top.Label.Text = v1.Data.Name or ""
	v3.BG.Vector.Image = v1.Data.Icon or ""
	if Modifiers then
		local count = 0
		for v4 in Modifiers do
			count = count + 1
		end
		if p1._mobileGridSize then
			v3.Padded.Bottom.Size = UDim2.fromScale(1, 0)
			v3.Padded.Bottom.AutomaticSize = Enum.AutomaticSize.Y
			v3.Padded.Bottom.UIGridLayout.CellSize = p1._mobileGridSize
		else
			v3.Padded.Bottom.Size = UDim2.fromScale(1, count / 10)
			v3.Padded.Bottom.UIGridLayout.CellSize = UDim2.fromScale(1, 1 / count * 0.9)
		end
		for k, v in pairs(Modifiers) do
			local v5
			local v6, v7 = PlayerStatsUtility:GetModifierDisplayName(k)
			if v6 then
				v5 = if k:find("Multiplier") or k:find("Multi") then ("x%*"):format(math.round((1 + v) * 10) / 10) else ("%*%%"):format((math.round(v * 100)))
				local v10 = Luck:Clone()
				v10.Label.Text = ("%*:"):format(v6)
				v10.Counter.Text = v5
				v10.Counter.TextColor3 = v7
				v10.Parent = v3.Padded.Bottom
			end
		end
	end
	Luck:Destroy()
	local Top = v3.Padded.Top
	local RapCounter = Top.RapCounter
	local Stack = Top.Stack
	Stack.LayoutOrder = RapCounter.LayoutOrder + 1
	if typeof(p2.Quantity) == "number" and p2.Quantity > 1 then
		Stack.Counter.Text = ("Owned Copies: x%*"):format((StringLibrary:AddCommas(p2.Quantity)))
		Stack.Visible = true
	else
		Stack.Visible = false
	end
	if v1.TradeLocked or not v1.IsSkin then
		RapCounter.Visible = false
	else
		if not TradeData.FollowTradeRules(v1, p2) then
			local v12 = script.TradeLocked:Clone()
			local Metadata = p2.Metadata
			local v13 = Metadata and Metadata.TradeLock
			if v13 and v13.Type == "Timestamp" then
				v12.Label.Text = ("\240\159\148\146 Locked (%*)"):format((formatDHMS((math.max(v13.Time - workspace:GetServerTimeNow(), 0)))))
			elseif v13 and v13.Type == "Untradable" then
				v12.Label.Text = "\240\159\148\146 Untradable"
			end
			v12.LayoutOrder = RapCounter.LayoutOrder + 2
			v12.Parent = v3.Padded.Top
		end
		local v16 = RAPController:GetRAP(v1.Data.Type, v1.Data.Name)
		RapCounter.Counter.Text = if v16 then StringLibrary:AddCommas(v16) else "???"
		RapCounter.Visible = true
		local v18 = nil
		ToolTip.observe(v3, nil, function() --[[ Line: 166 | Upvalues: p1 (copy), p2 (copy), TradeData (ref), v1 (copy), v18 (ref), v3 (copy), ToolTip (ref) ]]
			p1._selectedTileId = p2.UUID
			local Metadata = p2.Metadata
			local v12 = TradeData.FollowTradeRules(v1, p2)
			if v18 then
				return {
					Style = "Object",
					ItemType = v1.Data.Type,
					Id = v1.Data.Id,
					Metadata = p2.Metadata,
					TradeLocked = v12,
					UUID = p2.UUID
				}
			end
			v18 = v3.Destroying:Once(function() --[[ Line: 176 | Upvalues: p1 (ref), p2 (ref), ToolTip (ref) ]]
				if p1._selectedTileId ~= p2.UUID then
					return
				end
				p1._selectedTileId = nil
				ToolTip.destroyAll()
			end)
			return {
				Style = "Object",
				ItemType = v1.Data.Type,
				Id = v1.Data.Id,
				Metadata = p2.Metadata,
				TradeLocked = v12,
				UUID = p2.UUID
			}
		end)
	end
	local Tier = v1.Data.Tier
	local v19 = if Tier then TierUtility:GetTier(Tier) else Tier
	if v19 and Tier > 1 then
		v3.BG.Glow.UIGradient.Color = v19.TierColor
		v3.BG.Glow.Visible = true
	else
		v3.BG.Glow.Visible = false
	end
	local GuiControl = p3.GuiControl
	local PlayerReplion = p3.PlayerReplion
	if IsSkin then
		p1:_setupSkinButton(v3, EquipAsSkin, v1, p3, p2.UUID)
		if IsSkin then
			v3.Padded.Bottom.Visible = false
		end
	else
		EquipAsSkin:Destroy()
	end
	if not IsSkin then
		GuiControl:Hook("Hold Button", v3).Clicked:Connect(function() --[[ Line: 224 | Upvalues: TileInteraction (ref), p2 (copy) ]]
			TileInteraction:EquipBait(p2.UUID)
		end)
	end
	v3.LayoutOrder = p1:GetLayoutOrder(p2, v1)
	v3.Parent = p1._parentFrame
	v3:SetAttribute("BaitId", v1.Data.Id)
	p1._tiles[p2.UUID] = v3
	p1:Update(v3, p2, v1, p3)
	return v3
end
function t.Update(p1, p2, p3, p4, p5) --[[ Update | Line: 243 ]]
	p2.UIStroke.Enabled = if p5.PlayerReplion:GetExpect("EquippedBaitId") == p4.Data.Id then true else false
end
function t._setupSkinButton(p1, p2, p3, p4, p5, p6) --[[ _setupSkinButton | Line: 249 | Upvalues: spr (copy), TileInteraction (copy) ]]
	local GuiControl = p5.GuiControl
	local PlayerReplion = p5.PlayerReplion
	local Id = p4.Data.Id
	local function onSkinChanged(p1) --[[ onSkinChanged | Line: 254 | Upvalues: spr (ref), p3 (copy), Id (copy) ]]
		spr.stop(p3)
		if p1 == Id then
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
	local v2 = PlayerReplion:OnChange("EquippedBaitSkinId", onSkinChanged)
	v1.Cleaner:Add(function() --[[ Line: 267 | Upvalues: v2 (copy) ]]
		v2:Disconnect()
	end)
	v1.Clicked:Connect(function() --[[ Line: 271 | Upvalues: TileInteraction (ref), p6 (copy), GuiControl (copy) ]]
		if not TileInteraction:ToggleBaitSkin(p6) then
			return
		end
		GuiControl:Close()
	end)
	onSkinChanged(PlayerReplion.Data.EquippedBaitSkinId)
	p3.Visible = true
end
function t.GetTile(p1, p2) --[[ GetTile | Line: 283 ]]
	return p1._tiles[p2]
end
function t.GetAllTiles(p1) --[[ GetAllTiles | Line: 288 ]]
	return p1._tiles
end
function t.DestroyAll(p1) --[[ DestroyAll | Line: 293 ]]
	for v1, v2 in p1._tiles do
		v2:Destroy()
	end
	table.clear(p1._tiles)
end
function formatDHMS(p1) --[[ formatDHMS | Line: 300 ]]
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
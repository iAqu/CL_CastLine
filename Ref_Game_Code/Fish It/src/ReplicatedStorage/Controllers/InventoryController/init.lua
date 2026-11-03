-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local Constants = require(ReplicatedStorage.Shared.Constants)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local Abilities = require(ReplicatedStorage.Abilities)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Modules.Util.FormatUtil)
local Renderer = require(ReplicatedStorage.Controllers.Trading.TradeController.Renderer)
local Device = require(ReplicatedStorage.Modules.Device)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local VendorController = require(ReplicatedStorage.Controllers.VendorController)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local InventoryPagination = require(script.InventoryPagination)
local InventoryFilter = require(script.InventoryFilter)
local TileInteraction = require(script.TileInteraction)
local InventoryTileRenderer = require(script.TileRenderers.InventoryTileRenderer)
local RodTileRenderer = require(script.TileRenderers.RodTileRenderer)
local BaitTileRenderer = require(script.TileRenderers.BaitTileRenderer)
local CharmTileRenderer = require(script.TileRenderers.CharmTileRenderer)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = PlayerGui:WaitForChild("Backpack")
local Inventory = PlayerGui:WaitForChild("Inventory")
local v2 = Net:RemoteFunction("UpdateAutoSellThreshold")
local v3 = Net:RemoteEvent("ClaimNotification")
Net:RemoteEvent("UnequipCharm")
local v4 = Net:RemoteEvent("EquipAbility")
local v5 = Net:RemoteEvent("UnequipAbility")
local Pages = Inventory.Main.Content.Pages
local Inventory_2 = Pages.Inventory
local Rods = Pages.Rods
local Baits = Pages.Baits
local Charms = Pages.Charms
local Abilities_2 = Pages.Abilities
local Pets = Pages.Pets
local None = Pages.None
local Configuration = Inventory.Main.Configuration
local GetMore = Inventory.Main:FindFirstChild("GetMore")
local Inventory_3 = Pets.Main.Inventory
local Tile = Inventory_3.Tile
Tile.Parent = nil
local EquipLabel = Pets.EquipLabel
local Main = Charms.Main
local Info = Charms.Main.Info
local Sample = Info.Frame.Sample
Sample.Parent = nil
local Fish = Charms.Main.Fish
local Tile_2 = Fish.Scroll.Tile
Tile_2.Parent = nil
local Perk = Charms.Main.Perk
local Tile_3 = Perk.Scroll.Tile
Tile_3.Parent = nil
local Scroll = Charms.List.Scroll
local Unequip = Scroll.Unequip
local Tile_4 = Scroll.Tile
Tile_4.Parent = nil
local Tile_5 = Baits.Tile
Tile_5.Parent = nil
local Tile_6 = Inventory_2.Tile
Tile_6.Parent = nil
local Tile_7 = Rods.Tile
Tile_7.Parent = nil
local Scroll_2 = Abilities_2.List.Scroll
local AbilitySelectionTemplate = Scroll_2.AbilitySelectionTemplate
AbilitySelectionTemplate.Parent = nil
local Unequip_2 = Scroll_2.Unequip
local SearchBar = Inventory.Main.Top:FindFirstChild("SearchBarFrame"):FindFirstChild("SearchBar")
local v6 = nil
local v7 = Signal.new()
local v8 = 130
local v9 = nil
local v10 = nil
local v11 = nil
local v12 = Signal.new()
local v13 = nil
local v14 = false
local v15 = false
local v16 = false
local v17 = false
local v18 = Trove.new()
local v19 = nil
local v20 = nil
local v21 = nil
local v22 = nil
local v23 = nil
local v24 = nil
local t = {}
local v25 = nil
local v26 = nil
local v27 = InventoryFilter.new()
local t2 = {
	InventoryStateChanged = v12
}
local t3 = {
	Fish = function(p1) --[[ Fish | Line: 182 | Upvalues: v11 (ref), t2 (copy), v12 (copy) ]]
		if v11 ~= "Fish" then
			t2:SetPage("Items")
			t2:SetCategory("Fish")
			v12:Fire(p1)
		end
	end,
	Inventory = function(p1) --[[ Inventory | Line: 188 | Upvalues: v11 (ref), t2 (copy), v12 (copy) ]]
		if v11 ~= "Items" then
			t2:SetPage("Items")
			t2:SetCategory("Items")
			v12:Fire(p1)
		end
	end,
	Rods = function(p1) --[[ Rods | Line: 194 | Upvalues: v10 (ref), t2 (copy), v12 (copy) ]]
		if v10 ~= "Fishing Rods" then
			t2:SetPage("Fishing Rods")
			t2:SetCategory("Fishing Rods")
			v12:Fire(p1)
		end
	end,
	Baits = function(p1) --[[ Baits | Line: 200 | Upvalues: v10 (ref), t2 (copy), v12 (copy) ]]
		if v10 ~= "Baits" then
			t2:SetPage("Baits")
			t2:SetCategory("Baits")
			v12:Fire(p1)
		end
	end,
	Charms = function(p1) --[[ Charms | Line: 206 | Upvalues: v10 (ref), t2 (copy), v12 (copy) ]]
		if v10 ~= "Charms" then
			t2:SetPage("Charms")
			t2:SetCategory("Charms")
			v12:Fire(p1)
		end
	end,
	Emotes = function(p1) --[[ Emotes | Line: 212 | Upvalues: v11 (ref), t2 (copy), v12 (copy) ]]
		if v11 ~= "Emotes" then
			t2:SetPage("Items")
			t2:SetCategory("Emotes")
			v12:Fire(p1)
		end
	end,
	Abilities = function(p1) --[[ Abilities | Line: 218 | Upvalues: v11 (ref), t2 (copy), v12 (copy) ]]
		if v11 ~= "Abilities" then
			t2:SetPage("Abilities")
			t2:SetCategory("Abilities")
			v12:Fire(p1)
		end
	end,
	Pets = function(p1) --[[ Pets | Line: 224 | Upvalues: v10 (ref), t2 (copy), v12 (copy) ]]
		if v10 ~= "Pets" then
			t2:SetPage("Pets")
			t2:SetCategory("Pets")
			v12:Fire(p1)
		end
	end
}
local function getScrollFrame() --[[ getScrollFrame | Line: 233 | Upvalues: v10 (ref), Rods (copy), Baits (copy), Scroll_2 (copy), Inventory_3 (copy), Inventory_2 (copy) ]]
	if v10 == "Fishing Rods" then
		return Rods
	end
	if v10 == "Baits" then
		return Baits
	end
	if v10 == "Abilities" then
		return Scroll_2
	end
	if v10 == "Pets" then
		return Inventory_3
	else
		return Inventory_2
	end
end
local function lockOptions() --[[ lockOptions | Line: 242 | Upvalues: v14 (ref) ]]
	v14 = true
	task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
		v14 = false
	end)
end
local function getEquippedAbilityIcon() --[[ getEquippedAbilityIcon | Line: 249 | Upvalues: Abilities (copy), v1 (ref) ]]
	local Wind = Abilities.Wind
	local v12 = if Wind then Wind.Data.Icon else ""
	if not v1 then
		return v12
	end
	local v2 = v1:Get({ "Abilities", "Equipped" })
	if v2 and v2 ~= "" then
		local v3 = v1:Get({ "Abilities", "Inventory" })
		if typeof(v3) ~= "table" then
			return v12
		end
		for i, v in ipairs(v3) do
			if v.UUID == v2 then
				local v4 = Abilities[v.Name]
				if v4 then
					return v4.Data.Icon
				else
					break
				end
			end
		end
	end
	return v12
end
local function updateAbilityOptionIcon() --[[ updateAbilityOptionIcon | Line: 279 | Upvalues: Inventory (copy), getEquippedAbilityIcon (copy) ]]
	local Abilities = Inventory.Main.Top.Options:FindFirstChild("Abilities")
	local v1 = if Abilities then Abilities:FindFirstChild("Vector") else Abilities
	if not (v1 and (v1:IsA("ImageLabel") or v1:IsA("ImageButton"))) then
		return
	end
	v1.Image = getEquippedAbilityIcon()
end
local function getAbilityTierColor(p1) --[[ getAbilityTierColor | Line: 287 | Upvalues: TierUtility (copy) ]]
	return TierUtility:GetTier(p1.Data.Tier or 1).TierColor
end
local function setTextColor(p1, p2) --[[ setTextColor | Line: 292 ]]
	if not p1 then
		return
	end
	p1.TextColor3 = p2.Keypoints[1].Value
	local v1 = p1:FindFirstChildWhichIsA("UIGradient")
	if not v1 then
		return
	end
	v1.Color = p2
end
local function setAbilityInfoValue(p1, p2, p3) --[[ setAbilityInfoValue | Line: 304 ]]
	local v1 = if p1 then p1:FindFirstChild(p2) else p1
	local v2 = if v1 then v1:FindFirstChild("Counter") else v1
	if not (v2 and v2:IsA("TextLabel")) then
		return
	end
	v2.Text = p3
end
local function updateAbilityInfo(p1) --[[ updateAbilityInfo | Line: 312 | Upvalues: Abilities_2 (copy), Abilities (copy), TierUtility (copy) ]]
	local Info = Abilities_2.Main.Info
	local v1 = if p1 then Abilities[p1] else p1
	if not v1 then
		Info.AbilityName.Text = "No Ability"
		Info.Content.Description.Label.Text = ""
		Info.Content.CastNumberTrigger.Counter.Text = "0"
		Info.Content.NumOfRollsEffectStays.Counter.Text = "0"
		Info.Display.Inner.Vector.Image = ""
		return
	end
	local TierColor = TierUtility:GetTier(v1.Data.Tier or 1).TierColor
	Info.AbilityName.Text = v1.Name
	Info.Content.Description.Label.Text = v1.Description
	Info.Display.Inner.Vector.Image = v1.Data.Icon or ""
	Info.Display.Inner.Glow.UIGradient.Color = TierColor
	Info.Display.UIStroke.UIGradient.Color = TierColor
	local AbilityName = Info.AbilityName
	if AbilityName then
		AbilityName.TextColor3 = TierColor.Keypoints[1].Value
		local v2 = AbilityName:FindFirstChildWhichIsA("UIGradient")
		if v2 then
			v2.Color = TierColor
		end
	end
	local v3 = Info.Content
	local v4 = tostring(v1.CastNumberTrigger)
	local v5 = if v3 then v3:FindFirstChild("CastNumberTrigger") else v3
	local v6 = if v5 then v5:FindFirstChild("Counter") else v5
	if v6 and v6:IsA("TextLabel") then
		v6.Text = v4
	end
	local v7 = Info.Content
	local v8 = tostring(v1.NumOfRollsEffectStays)
	local v9 = if v7 then v7:FindFirstChild("NumOfRollsEffectStays") else v7
	local v10 = if v9 then v9:FindFirstChild("Counter") else v9
	if not (v10 and v10:IsA("TextLabel")) then
		return
	end
	v10.Text = v8
end
local function setBulkFavoriting(p1) --[[ setBulkFavoriting | Line: 337 | Upvalues: v15 (ref), Inventory (copy) ]]
	v15 = p1
	Inventory.Main.Top.Favorite.Label.Text = ("Favorite: %*"):format(if p1 then "ON" else "OFF")
	local v2 = if p1 then Color3.fromRGB(59, 47, 20) else Color3.fromRGB(25, 27, 29)
	local v3 = if p1 then Color3.fromRGB(255, 207, 87) else Color3.fromRGB(0, 0, 0)
	Inventory.Main.Content.Divider.BackgroundColor3 = v2
	Inventory.Main.BackgroundColor3 = v2
	Inventory.Main.UIStroke.Color = v3
end
local function updateTileSize() --[[ updateTileSize | Line: 352 | Upvalues: Device (copy), v8 (ref), v6 (ref), Inventory_2 (copy), v7 (copy) ]]
	local ViewportSize = workspace.CurrentCamera.ViewportSize
	if Device:IsMobile() then
		local v3 = math.clamp(ViewportSize.Y * 0.035, 10, 24)
		v8 = math.clamp(ViewportSize.X / 1.7 / 4 - 14, 50, 80)
		v6 = UDim2.new(1, 0, 0, v3)
	else
		local v62 = math.clamp(ViewportSize.Y * 0.1, 20, 30)
		v8 = math.clamp(ViewportSize.X / 1.7 / 7 - 14, 70, 130)
		v6 = UDim2.new(1, 0, 0, v62)
	end
	Inventory_2.UIGridLayout.CellSize = UDim2.new(0.25, 0, 0, v8)
	v7:Fire()
end
local function updateActionButtons(p1) --[[ updateActionButtons | Line: 372 | Upvalues: Inventory (copy), v11 (ref), GetMore (copy), v1 (ref), Configuration (copy) ]]
	Inventory.Main.Top.Favorite.Visible = if p1 == "Fish" or (p1 == "Inventory" or v11 == "Fish") then true elseif v11 == "Items" then true else false
	Inventory.Main.SellAll.Visible = if p1 == "Fish" then true else v11 == "Fish"
	Inventory.Main.Top.AutoOptions.Visible = p1 == "Fish"
	if GetMore and GetMore:IsA("GuiObject") then
		GetMore.Visible = if p1 == "Abilities" then true else v11 == "Abilities"
	end
	if not v1 then
		return
	end
	Configuration.Visible = if (v1:GetExpect("Level") or 0) >= 50 then if p1 == "Fish" or p1 == "Rods" then true elseif p1 == "Baits" then true else false else false
	Configuration.Frame.Skins.Visible = if p1 == "Rods" then true elseif p1 == "Baits" then true else false
	Configuration.Frame.Favorites.Visible = not (if p1 == "Rods" then true elseif p1 == "Baits" then true else false)
	Configuration.Frame.Mutations.Visible = not (if p1 == "Rods" then true else p1 == "Baits")
end
local function updatePetEquipLabel() --[[ updatePetEquipLabel | Line: 390 | Upvalues: v1 (ref), EquipLabel (copy) ]]
	local v12 = v1 and v1:Get("EquippedPetUUID")
	EquipLabel.Text = ("Equipped Pets (%*/1)"):format(if v12 and v12 ~= "" then 1 else 0)
end
local function getContext() --[[ getContext | Line: 397 | Upvalues: v1 (ref), GuiControl (copy), v14 (ref), TileInteraction (copy), v15 (ref), v11 (ref), v21 (ref), StringLibrary (copy) ]]
	return {
		PlayerReplion = v1,
		GuiControl = GuiControl,
		OnInteraction = function(p1_2, p2_2) --[[ OnInteraction | Line: 401 | Upvalues: v14 (ref), TileInteraction (ref), v15 (ref), v11 (ref), v21 (ref), StringLibrary (ref) ]]
			if not v14 then
				v14 = true
				task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
					v14 = false
				end)
				TileInteraction:HandleInventoryClick(p1_2, p2_2, v15, function() --[[ Line: 409 | Upvalues: v11 (ref), v21 (ref), p1_2 (copy), StringLibrary (ref) ]]
					if v11 ~= "Items" then
						return
					end
					local v1 = v21:GetTile(p1_2.UUID)
					if not v1 then
						return
					end
					local v2 = (tonumber(v1.WeightFrame.Weight.Text:match("%d+")) or 1) - 1
					if v2 > 0 then
						v1.WeightFrame.Weight.Text = "x" .. StringLibrary:AddCommas(v2)
						return
					end
					v1:Destroy()
					v21:GetAllTiles()[p1_2.UUID] = nil
				end)
			end
		end
	}
end
local function destroyTiles() --[[ destroyTiles | Line: 441 | Upvalues: v18 (copy), v26 (ref), v20 (ref), v21 (ref), v22 (ref), v23 (ref), v24 (ref), t (copy), setBulkFavoriting (copy) ]]
	v18:Clean()
	if v26 then
		v26:Reset()
	end
	v20:DestroyAll()
	v21:DestroyAll()
	v22:DestroyAll()
	v23:DestroyAll()
	v24:DestroyAll()
	for v1, v2 in t do
		v2:Destroy()
	end
	table.clear(t)
	setBulkFavoriting(false)
end
local function setAbilityTileState(p1, p2, p3) --[[ setAbilityTileState | Line: 466 | Upvalues: TierUtility (copy) ]]
	local TierColor = TierUtility:GetTier(p2.Data.Tier or 1).TierColor
	local Label = p1:FindFirstChild("Label")
	if Label and Label:IsA("TextLabel") then
		Label.Text = p2.Name
		if Label then
			Label.TextColor3 = TierColor.Keypoints[1].Value
			local v1 = Label:FindFirstChildWhichIsA("UIGradient")
			if v1 then
				v1.Color = TierColor
			end
		end
	end
	local v2 = p1:FindFirstChildWhichIsA("UIStroke")
	if v2 then
		v2.Enabled = p3
	end
	local Glow = p1:FindFirstChild("Glow", true)
	local v3 = if Glow then Glow:FindFirstChildWhichIsA("UIGradient") else Glow
	if not v3 then
		return
	end
	v3.Color = TierColor
end
local function renderAbilityPage(p1) --[[ renderAbilityPage | Line: 486 | Upvalues: v1 (ref), Abilities_2 (copy), Abilities (copy), ItemUtility (copy), v27 (copy), updateAbilityInfo (copy), Unequip_2 (copy), v18 (copy), v5 (copy), v13 (ref), AbilitySelectionTemplate (copy), Scroll_2 (copy), t (copy), setAbilityTileState (copy), v14 (ref), v4 (copy) ]]
	local v12 = v1:Get({ "Abilities", "Inventory" })
	if typeof(v12) ~= "table" then
		local Info = Abilities_2.Main.Info
		Info.AbilityName.Text = "No Ability"
		Info.Content.Description.Label.Text = ""
		Info.Content.CastNumberTrigger.Counter.Text = "0"
		Info.Content.NumOfRollsEffectStays.Counter.Text = "0"
		Info.Display.Inner.Vector.Image = ""
		return false
	end
	local list = {}
	for i, v in ipairs(v12) do
		local v2 = Abilities[v.Name]
		if v2 then
			local v3 = ItemUtility.GetItemDataFromItemType("Abilities", v.Name)
			if not v3 or (not v27:IsActive() or v27:Passes(v, v3)) then
				table.insert(list, {
					Item = v,
					AbilityData = v2,
					LayoutOrder = v2.Data.Tier or 1
				})
			end
		end
	end
	local v42 = v1:Get({ "Abilities", "Equipped" })
	table.sort(list, function(p1, p2) --[[ Line: 515 | Upvalues: v42 (copy) ]]
		local v1 = if p1.Item.UUID == v42 then true else false
		if v1 ~= (if p2.Item.UUID == v42 then true else false) then
			return v1
		end
		if p1.LayoutOrder == p2.LayoutOrder then
			return p1.AbilityData.Name < p2.AbilityData.Name
		else
			return p1.LayoutOrder > p2.LayoutOrder
		end
	end)
	local v52 = nil
	for i, v in ipairs(list) do
		if v.Item.UUID == v42 then
			v52 = v.Item.Name
			break
		end
	end
	if not v52 and list[1] then
		v52 = list[1].Item.Name
	end
	updateAbilityInfo(v52)
	Unequip_2.Visible = if v42 == nil then false elseif v42 == "" then false else true
	v18:Add(Unequip_2.Activated:Connect(function() --[[ Line: 544 | Upvalues: v5 (ref), updateAbilityInfo (ref), list (copy) ]]
		v5:FireServer()
		updateAbilityInfo(if list[1] then list[1].Item.Name else nil)
	end))
	for i, v in ipairs(list) do
		if v13 ~= p1 then
			break
		end
		local Item = v.Item
		local v8 = AbilitySelectionTemplate:Clone()
		v8.Name = Item.UUID
		v8.LayoutOrder = if Item.UUID == v42 then 0 else i
		v8.Visible = true
		v8.Parent = Scroll_2
		t[Item.UUID] = v8
		v18:Add(v8)
		setAbilityTileState(v8, v.AbilityData, if Item.UUID == v42 then true else false)
		v18:Add(v8.Activated:Connect(function() --[[ Line: 566 | Upvalues: v14 (ref), updateAbilityInfo (ref), Item (copy), v4 (ref) ]]
			if not v14 then
				v14 = true
				task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
					v14 = false
				end)
				updateAbilityInfo(Item.Name)
				v4:FireServer(Item.UUID)
			end
		end))
	end
	Scroll_2.CanvasSize = UDim2.new(0, 0, 0, Scroll_2.UIListLayout.AbsoluteContentSize.Y)
	return #list > 0
end
local function drawTiles() --[[ drawTiles | Line: 579 | Upvalues: HttpService (copy), v13 (ref), updateTileSize (copy), v10 (ref), Rods (copy), Baits (copy), Scroll_2 (copy), Inventory_3 (copy), Inventory_2 (copy), v1 (ref), GuiControl (copy), v14 (ref), TileInteraction (copy), v15 (ref), v11 (ref), v21 (ref), StringLibrary (copy), renderAbilityPage (copy), ItemUtility (copy), v27 (copy), v22 (ref), v26 (ref), InventoryPagination (copy), v23 (ref), v6 (ref), PlayerStatsUtility (copy), v24 (ref), Scroll (copy), v20 (ref), InventoryMapping (copy), None (copy), Charms (copy), Abilities_2 (copy), Pets (copy) ]]
	local v12 = HttpService:GenerateGUID(false)
	v13 = v12
	updateTileSize()
	local v2 = if v10 == "Fishing Rods" then Rods elseif v10 == "Baits" then Baits elseif v10 == "Abilities" then Scroll_2 elseif v10 == "Pets" then Inventory_3 else Inventory_2
	if v2 then
		v2.CanvasPosition = Vector2.zero
	end
	local v3 = false
	local t = {
		PlayerReplion = v1,
		GuiControl = GuiControl,
		OnInteraction = function(p1_2, p2_2) --[[ OnInteraction | Line: 401 | Upvalues: v14 (ref), TileInteraction (ref), v15 (ref), v11 (ref), v21 (ref), StringLibrary (ref) ]]
			if not v14 then
				v14 = true
				task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
					v14 = false
				end)
				TileInteraction:HandleInventoryClick(p1_2, p2_2, v15, function() --[[ Line: 409 | Upvalues: v11 (ref), v21 (ref), p1_2 (copy), StringLibrary (ref) ]]
					if v11 ~= "Items" then
						return
					end
					local v1 = v21:GetTile(p1_2.UUID)
					if not v1 then
						return
					end
					local v2 = (tonumber(v1.WeightFrame.Weight.Text:match("%d+")) or 1) - 1
					if v2 > 0 then
						v1.WeightFrame.Weight.Text = "x" .. StringLibrary:AddCommas(v2)
						return
					end
					v1:Destroy()
					v21:GetAllTiles()[p1_2.UUID] = nil
				end)
			end
		end
	}
	local v4 = v1:GetExpect({ "Inventory" })
	if v10 == "Abilities" then
		v3 = not renderAbilityPage(v12)
	elseif v10 == "Fishing Rods" then
		local v62 = v1:GetExpect("EquippedItems")
		local t2 = {}
		for i, v in ipairs(v4["Fishing Rods"]) do
			local v7 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v.Id)
			if v7 and (not v27:IsActive() or v27:Passes(v, v7)) then
				table.insert(t2, {
					Category = "Fishing Rods",
					Item = v,
					LayoutOrder = v22:GetLayoutOrder(v, v7)
				})
			end
		end
		table.sort(t2, function(p1, p2) --[[ Line: 632 ]]
			return p1.LayoutOrder < p2.LayoutOrder
		end)
		v26 = InventoryPagination.new(Rods, {
			ItemsPerPage = 10,
			ScrollDirection = "Horizontal",
			OnPageLoaded = function() --[[ OnPageLoaded | Line: 637 | Upvalues: Rods (ref) ]]
				Rods.CanvasSize = UDim2.new(0, Rods.UIGridLayout.AbsoluteContentSize.X, 0, 0)
			end
		})
		v26:SetItems(t2)
		local function f8(p1, p2) --[[ Line: 643 | Upvalues: v13 (ref), v12 (copy), v22 (ref), ItemUtility (ref), v62 (copy), t (copy) ]]
			if v13 == v12 then
				v22:Create(p1.Item, ItemUtility.GetItemDataFromItemType("Fishing Rods", p1.Item.Id), v62, t)
			end
		end
		if v26:GetTotalItems() == 0 then
			v3 = true
		else
			v26:LoadNextPage(f8)
			v26:StartScrollMonitoring(f8)
		end
	elseif v10 == "Baits" then
		v23:SetMobileGridSize(v6)
		local t2 = {}
		for i, v in ipairs(v4.Baits) do
			local v9 = ItemUtility:GetBaitData(v.Id)
			if v9 and (not v27:IsActive() or v27:Passes(v, v9)) then
				table.insert(t2, {
					Category = "Baits",
					Item = v,
					LayoutOrder = v23:GetLayoutOrder(v, v9)
				})
			end
		end
		table.sort(t2, function(p1, p2) --[[ Line: 691 ]]
			return p1.LayoutOrder < p2.LayoutOrder
		end)
		v26 = InventoryPagination.new(Baits, {
			ItemsPerPage = 10,
			ScrollDirection = "Horizontal",
			OnPageLoaded = function() --[[ OnPageLoaded | Line: 696 | Upvalues: Baits (ref) ]]
				Baits.CanvasSize = UDim2.new(0, Baits.UIGridLayout.AbsoluteContentSize.X, 0, 0)
			end
		})
		v26:SetItems(t2)
		local function f10(p1, p2) --[[ Line: 702 | Upvalues: v13 (ref), v12 (copy), v23 (ref), t (copy) ]]
			if v13 == v12 then
				v23:Create(p1.Item, t)
			end
		end
		if v26:GetTotalItems() == 0 then
			v3 = true
		else
			v26:LoadNextPage(f10)
			v26:StartScrollMonitoring(f10)
		end
	elseif v10 == "Charms" then
		for i, v in ipairs((PlayerStatsUtility:GetCharmsCopy(v1))) do
			if v13 ~= v12 then
				break
			end
			v24:Create(v, t)
		end
		Scroll.CanvasSize = UDim2.new(0, 0, 0, Scroll.UIListLayout.AbsoluteContentSize.Y)
		local v122 = v1:GetExpect({ "EquippedCharmId" })
		if next(v24:GetAllTiles()) == nil and v122 <= 0 then
			v3 = true
		end
	else
		local v132 = if v11 == "Pets" then v20 else v21
		local t2 = {}
		local function getItems() --[[ getItems | Line: 734 | Upvalues: v4 (copy), ItemUtility (ref), v27 (ref), v21 (ref), t2 (copy) ]]
			for i, v in ipairs(v4.Items) do
				local v1 = ItemUtility:GetItemData(v.Id)
				if v1 and (v1.Data.Type ~= "Fish" and (not v27:IsActive() or v27:Passes(v, v1))) then
					table.insert(t2, {
						Item = v,
						Category = v1.Data.Type,
						LayoutOrder = v21:GetLayoutOrder(v, v1)
					})
				end
			end
		end
		local function collectItems(p1) --[[ collectItems | Line: 755 | Upvalues: InventoryMapping (ref), v4 (copy), ItemUtility (ref), v27 (ref), v132 (copy), t2 (copy) ]]
			local v1 = v4[InventoryMapping[p1]]
			if not v1 then
				print("NO INVENTORY CATEGORY FOR", p1)
				return
			end
			for i, v in ipairs(v1) do
				local v2 = ItemUtility.GetItemDataFromItemType(p1, v.Id)
				if v2 and (not v27:IsActive() or v27:Passes(v, v2)) then
					table.insert(t2, {
						Item = v,
						Category = p1,
						LayoutOrder = v132:GetLayoutOrder(v, v2)
					})
				end
			end
		end
		if v11 == "Items" then
			collectItems("Totems")
			collectItems("Potions")
			collectItems("Pet Eggs")
			getItems()
		elseif v11 == "Emotes" then
			collectItems("Emotes")
		elseif v11 == "Pets" then
			collectItems("Pets")
			collectItems("Pet Eggs")
			ShowAllEquipped()
		elseif v11 == "Fish" then
			for i, v in ipairs(v4.Items) do
				local v142 = ItemUtility.GetItemDataFromItemType("Fish", v.Id)
				if v142 and (v142.Data.Type == "Fish" and (not v27:IsActive() or v27:Passes(v, v142))) then
					table.insert(t2, {
						Category = "Fish",
						Item = v,
						LayoutOrder = v132:GetLayoutOrder(v, v142)
					})
				end
			end
		else
			for i, v in ipairs(v4.Items) do
				local v152 = ItemUtility.GetItemDataFromItemType(v11, v.Id)
				if v152 and (not v27:IsActive() or v27:Passes(v, v152)) then
					table.insert(t2, {
						Item = v,
						Category = v11,
						LayoutOrder = v132:GetLayoutOrder(v, v152)
					})
				end
			end
		end
		table.sort(t2, function(p1, p2) --[[ Line: 825 ]]
			return p1.LayoutOrder < p2.LayoutOrder
		end)
		v26 = InventoryPagination.new(if v11 == "Pets" then Inventory_3 else Inventory_2)
		v26:SetItems(t2)
		local function f17(p1, p2) --[[ Line: 835 | Upvalues: v13 (ref), v12 (copy), v132 (copy), ItemUtility (ref), t (copy) ]]
			if v13 ~= v12 then
				return
			end
			v132:Create(p1.Item, ItemUtility.GetItemDataFromItemType(p1.Category, if p1.Category == "Abilities" then p1.Item.Name else p1.Item.Id), p1.Category, t)
		end
		if v26:GetTotalItems() == 0 then
			v3 = true
		else
			v26:LoadNextPage(f17)
			v26:StartScrollMonitoring(f17)
		end
	end
	None.Visible = v3
	local v18 = Baits
	v18.Visible = if v10 == "Baits" then not v3 else false
	local v202 = Rods
	v202.Visible = if v10 == "Fishing Rods" then not v3 else false
	Inventory_2.Visible = if v10 == "Items" then not v3 else false
	Charms.Visible = if v10 == "Charms" then not v3 else false
	Abilities_2.Visible = if v10 == "Abilities" then not v3 else false
	Pets.Visible = if v10 == "Pets" then not v3 else false
end
local function setFilterCallback(p1) --[[ setFilterCallback | Line: 861 | Upvalues: v14 (ref), v11 (ref), t3 (copy), v10 (ref), v27 (copy) ]]
	if v14 then
		return
	end
	local v1 = v11
	if v11 == "Items" then
		v1 = "Inventory"
	elseif v11 == "Fishing Rods" then
		v1 = "Rods"
	end
	local v2 = t3[v1]
	if v2 then
		v11 = nil
		v10 = nil
		v27:SetSortCallback(p1)
		v14 = true
		task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
			v14 = false
		end)
		v2(v1)
	end
end
local function resetSorts() --[[ resetSorts | Line: 880 | Upvalues: v14 (ref), v11 (ref), t3 (copy), v10 (ref), v27 (copy) ]]
	if v14 then
		return
	end
	local v1 = v11
	if v11 == "Items" then
		v1 = "Inventory"
	elseif v11 == "Fishing Rods" then
		v1 = "Rods"
	end
	local v2 = t3[v1]
	if v2 then
		v11 = nil
		v10 = nil
		v27:SetSortCallback(nil)
		v14 = true
		task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
			v14 = false
		end)
		v2(v1)
	end
end
local function setMutations() --[[ setMutations | Line: 883 | Upvalues: v14 (ref), v11 (ref), t3 (copy), v10 (ref), v27 (copy) ]]
	local function f1(p1, p2) --[[ Line: 884 ]]
		local Metadata = p1.Metadata
		if Metadata then
			Metadata = if p1.Metadata.VariantId == nil then false else typeof(p1.Metadata.VariantId) ~= "table"
		end
		return Metadata
	end
	if v14 then
		return
	end
	local v2 = v11
	if v11 == "Items" then
		v2 = "Inventory"
	elseif v11 == "Fishing Rods" then
		v2 = "Rods"
	end
	local v3 = t3[v2]
	if v3 then
		v11 = nil
		v10 = nil
		v27:SetSortCallback(f1)
		v14 = true
		task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
			v14 = false
		end)
		v3(v2)
	end
end
local function setFavorites() --[[ setFavorites | Line: 890 | Upvalues: v14 (ref), v11 (ref), t3 (copy), v10 (ref), v27 (copy) ]]
	local function f1(p1, p2) --[[ Line: 891 ]]
		return if p1.Favorited == nil then false else p1.Favorited == true
	end
	if v14 then
		return
	end
	local v2 = v11
	if v11 == "Items" then
		v2 = "Inventory"
	elseif v11 == "Fishing Rods" then
		v2 = "Rods"
	end
	local v3 = t3[v2]
	if v3 then
		v11 = nil
		v10 = nil
		v27:SetSortCallback(f1)
		v14 = true
		task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
			v14 = false
		end)
		v3(v2)
	end
end
local function setSkins() --[[ setSkins | Line: 897 | Upvalues: v14 (ref), v11 (ref), t3 (copy), v10 (ref), v27 (copy) ]]
	local function f1(p1, p2) --[[ Line: 898 ]]
		return p2.IsSkin
	end
	if v14 then
		return
	end
	local v2 = v11
	if v11 == "Items" then
		v2 = "Inventory"
	elseif v11 == "Fishing Rods" then
		v2 = "Rods"
	end
	local v3 = t3[v2]
	if v3 then
		v11 = nil
		v10 = nil
		v27:SetSortCallback(f1)
		v14 = true
		task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
			v14 = false
		end)
		v3(v2)
	end
end
function t2.SetPage(p1, p2) --[[ SetPage | Line: 904 | Upvalues: v10 (ref) ]]
	if p2 ~= v10 then
		v10 = p2
	end
end
function t2.SetCategory(p1, p2) --[[ SetCategory | Line: 910 | Upvalues: v11 (ref) ]]
	if p2 ~= v11 then
		v11 = p2
	end
end
function t2._bindFishingRods(p1) --[[ _bindFishingRods | Line: 916 | Upvalues: Inventory (copy), GuiControl (copy), t3 (copy) ]]
	if Inventory.Enabled then
		GuiControl:Close()
	else
		t3.Rods("Rods")
		GuiControl:Open("Inventory", false)
	end
end
function t2._bindFish(p1) --[[ _bindFish | Line: 926 | Upvalues: Inventory (copy), GuiControl (copy), t3 (copy) ]]
	if Inventory.Enabled then
		GuiControl:Close()
	else
		t3.Fish("Fish")
		GuiControl:Open("Inventory", false)
	end
end
function t2.Init(p1) --[[ Init | Line: 936 | Upvalues: updateAbilityOptionIcon (copy), v21 (ref), InventoryTileRenderer (copy), Tile_6 (copy), Inventory_2 (copy), v20 (ref), Tile (copy), Inventory_3 (copy), v19 (ref), Renderer (copy), LocalPlayer (copy), Pets (copy), v22 (ref), RodTileRenderer (copy), Tile_7 (copy), Rods (copy), v23 (ref), BaitTileRenderer (copy), Tile_5 (copy), Baits (copy), v24 (ref), CharmTileRenderer (copy), Tile_4 (copy), Scroll (copy), Main (copy), Info (copy), Sample (copy), Tile_2 (copy), Fish (copy), Tile_3 (copy), Perk (copy), t3 (copy), Inventory (copy), v14 (ref), v27 (copy), SearchBar (copy), GuiControl (copy), setBulkFavoriting (copy), v15 (ref), GetMore (copy), GamePassUtility (copy), VendorController (copy), v12 (copy), v9 (ref), destroyTiles (copy), drawTiles (copy), spr (copy), updateActionButtons (copy), v10 (ref), v11 (ref), v1 (ref), v3 (copy), Backpack (copy), t2 (copy), InputControl (copy) ]]
	updateAbilityOptionIcon()
	v21 = InventoryTileRenderer.new(Tile_6, Inventory_2)
	v20 = InventoryTileRenderer.new(Tile, Inventory_3)
	v19 = Renderer.new(LocalPlayer, nil, Pets.Top, false, false)
	v19:SetScale(0.9)
	v22 = RodTileRenderer.new(Tile_7, Rods)
	v23 = BaitTileRenderer.new(Tile_5, Baits)
	v24 = CharmTileRenderer.new(Tile_4, Scroll, Main, Info, Sample, Tile_2, Fish.Scroll, Tile_3, Perk)
	local t = {}
	for v13, v2 in t3 do
		local v32 = Inventory.Main.Top.Options:FindFirstChild(v13)
		if v32 then
			t[v13] = v32
		end
	end
	for v4, v5 in t3 do
		local v6 = t[v4]
		if v6 then
			if not v6:FindFirstChildOfClass("UIScale") then
				local UIScale = Instance.new("UIScale")
				UIScale.Scale = 1
				UIScale.Parent = v6
			end
			v6.Activated:Connect(function() --[[ Line: 976 | Upvalues: v14 (ref), v27 (ref), SearchBar (ref), v5 (copy), v4 (copy) ]]
				if v14 then
					return
				end
				v14 = true
				task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
					v14 = false
				end)
				v27:ClearAll()
				if SearchBar then
					SearchBar.Text = ""
				end
				v5(v4)
			end)
		end
	end
	GuiControl:Hook("Hold Button", Pets.Top.AddTile).Clicked:Connect(function() --[[ Line: 986 | Upvalues: v14 (ref), GuiControl (ref) ]]
		if not v14 then
			GuiControl:Open("Exclusive Store")
		end
	end)
	GuiControl:Hook("Hold Button", Inventory.Main.Top.Favorite).Clicked:Connect(function() --[[ Line: 991 | Upvalues: v14 (ref), setBulkFavoriting (ref), v15 (ref) ]]
		if not v14 then
			v14 = true
			task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
				v14 = false
			end)
			setBulkFavoriting(not v15)
		end
	end)
	if GetMore and GetMore:IsA("GuiButton") then
		GuiControl:Hook("Hold Button", GetMore).Clicked:Connect(function() --[[ Line: 998 | Upvalues: v14 (ref), GuiControl (ref) ]]
			if not v14 then
				GuiControl:Open("!!!! AbilityUI")
			end
		end)
	end
	GuiControl:Hook("Hold Button", Inventory.Main.SellAll).Clicked:Connect(function() --[[ Line: 1005 | Upvalues: v14 (ref), GamePassUtility (ref), VendorController (ref), v12 (ref), v9 (ref) ]]
		if v14 then
			return
		end
		v14 = true
		if GamePassUtility:ClientPromptGamepassFromName("Sell Anywhere") then
			VendorController:SellAllItems():catch(function(p1, p2) --[[ Line: 1013 | Upvalues: VendorController (ref) ]]
				if not p2 then
					return
				end
				VendorController:_reportError(p1)
			end):await()
			v14 = false
			task.delay(0.3, function() --[[ Line: 1022 | Upvalues: v12 (ref), v9 (ref) ]]
				v12:Fire(v9)
			end)
		else
			v14 = false
		end
	end)
	if SearchBar then
		local v7 = nil
		SearchBar:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 1031 | Upvalues: v7 (ref), v27 (ref), SearchBar (ref), destroyTiles (ref), drawTiles (ref) ]]
			if v7 then
				task.cancel(v7)
			end
			v7 = task.delay(0.25, function() --[[ Line: 1037 | Upvalues: v7 (ref), v27 (ref), SearchBar (ref), destroyTiles (ref), drawTiles (ref) ]]
				v7 = nil
				v27:SetSearchText(SearchBar.Text)
				destroyTiles()
				drawTiles()
			end)
		end)
		SearchBar.FocusLost:Connect(function(p1) --[[ Line: 1047 | Upvalues: v27 (ref), SearchBar (ref), destroyTiles (ref), drawTiles (ref) ]]
			if not p1 then
				return
			end
			v27:SetSearchText(SearchBar.Text)
			destroyTiles()
			drawTiles()
		end)
	end
	v12:Connect(function(p1) --[[ Line: 1057 | Upvalues: v9 (ref), t3 (ref), Inventory (ref), spr (ref), updateActionButtons (ref) ]]
		local v1 = if p1 then p1 else v9
		v9 = v1
		local v2 = v1
		for v3, v4 in t3 do
			local v5 = Inventory.Main.Top.Options:FindFirstChild(v3)
			if v5 then
				local v6 = v5:FindFirstChildWhichIsA("UIScale")
				if v6 then
					spr.stop(v6)
					if v2 == v3 then
						spr.target(v6, 90, 325, {
							Scale = 1.2
						})
						continue
					end
					spr.target(v6, 20, 60, {
						Scale = 1
					})
				end
			end
		end
		updateActionButtons(v2)
	end)
	v12:Connect(function() --[[ Line: 1081 | Upvalues: destroyTiles (ref), drawTiles (ref), v10 (ref), v11 (ref), v1 (ref), v3 (ref) ]]
		destroyTiles()
		drawTiles()
		local v12 = if v10 == "Baits" then "Baits" elseif v10 == "Fishing Rods" then "Fishing Rods" else v11
		local v2 = v1:Get({ "InventoryNotifications", v12 })
		if not (v2 and v2 > 0) then
			return
		end
		v3:FireServer(v12)
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 1098 | Upvalues: Inventory (ref), v27 (ref), SearchBar (ref), v12 (ref), v9 (ref), updateActionButtons (ref) ]]
		if p1 ~= Inventory then
			return
		end
		v27:ClearAll()
		if SearchBar then
			SearchBar.Text = ""
		end
		v12:Fire(v9)
		updateActionButtons(v9 or "Fish")
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 1108 | Upvalues: Inventory (ref), destroyTiles (ref) ]]
		if p1 ~= Inventory then
			return
		end
		destroyTiles()
	end)
	GuiControl:Hook("Hold Button", Backpack.Display.Inventory).Clicked:Connect(function() --[[ Line: 1115 | Upvalues: t2 (ref) ]]
		t2:_bindFish()
	end)
	GuiControl:Hook("Hold Button", Backpack.Display.Rods).Clicked:Connect(function() --[[ Line: 1118 | Upvalues: t2 (ref) ]]
		t2:_bindFishingRods()
	end)
	InputControl:RegisterInput({ Enum.KeyCode.Two, Enum.KeyCode.DPadLeft }, {}, function() --[[ Line: 1123 | Upvalues: t2 (ref) ]]
		t2:_bindFishingRods()
	end)
	InputControl:RegisterInput({ Enum.KeyCode.Three, Enum.KeyCode.DPadRight }, {}, function() --[[ Line: 1126 | Upvalues: t2 (ref) ]]
		t2:_bindFish()
	end)
end
function t2.Start(p1) --[[ Start | Line: 1132 | Upvalues: v1 (ref), Replion (copy), TileInteraction (copy), updateAbilityOptionIcon (copy), v20 (ref), EquipLabel (copy), GuiControl (copy), v11 (ref), v22 (ref), v21 (ref), v12 (copy), v23 (ref), Inventory (copy), TierUtility (copy), v16 (ref), Constants (copy), PromptController (copy), v2 (copy), Configuration (copy), setFavorites (copy), setMutations (copy), resetSorts (copy), setSkins (copy), Unequip (copy), v24 (ref), Observers (copy), v6 (ref), v7 (copy), Device (copy), updateTileSize (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	TileInteraction:Init()
	updateAbilityOptionIcon()
	v1:OnChange("EquippedPetUUID", function(p1) --[[ Line: 1138 | Upvalues: v20 (ref), v1 (ref), EquipLabel (ref), GuiControl (ref), v11 (ref) ]]
		for v12, v2 in v20:GetAllTiles() do
			v2.Equipped.Visible = p1 == v12
		end
		local v4 = v1 and v1:Get("EquippedPetUUID")
		EquipLabel.Text = ("Equipped Pets (%*/1)"):format(if v4 and v4 ~= "" then 1 else 0)
		if not GuiControl:IsOpen("Inventory") or v11 ~= "Pets" then
			return
		end
		ShowAllEquipped()
	end)
	v1:OnChange("EquippedItems", function(p1, p2) --[[ Line: 1149 | Upvalues: GuiControl (ref), v22 (ref), v11 (ref), v21 (ref) ]]
		if not GuiControl:IsOpen("Inventory") then
			return
		end
		if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
			return
		end
		local v1 = p1[1]
		local v2 = p2[1]
		if v1 ~= v2 then
			local v3 = v22:GetTile(v1)
			if v3 then
				v3.UIStroke.Enabled = true
			end
			local v4 = v22:GetTile(v2)
			if v4 then
				v4.UIStroke.Enabled = false
			end
		end
		if v11 == "Emotes" or v11 == "Abilities" then
			return
		end
		for v5, v6 in v21:GetAllTiles() do
			v6.Equipped.Visible = table.find(p1, v5) ~= nil
		end
	end)
	v1:OnChange("EquippedEmotes", function(p1) --[[ Line: 1172 | Upvalues: GuiControl (ref), v11 (ref), v21 (ref) ]]
		if not GuiControl:IsOpen("Inventory") or v11 ~= "Emotes" then
			return
		end
		if typeof(p1) ~= "table" then
			return
		end
		for v1, v2 in v21:GetAllTiles() do
			v2.Equipped.Visible = table.find(p1, v1) ~= nil
		end
	end)
	v1:OnChange({ "Abilities", "Equipped" }, function(p1) --[[ Line: 1181 | Upvalues: updateAbilityOptionIcon (ref), GuiControl (ref), v11 (ref), v12 (ref) ]]
		updateAbilityOptionIcon()
		if GuiControl:IsOpen("Inventory") and v11 == "Abilities" then
			v12:Fire("Abilities")
		end
	end)
	v1:OnChange({ "Abilities", "Inventory" }, function() --[[ Line: 1187 | Upvalues: updateAbilityOptionIcon (ref), GuiControl (ref), v11 (ref), v12 (ref) ]]
		updateAbilityOptionIcon()
		if GuiControl:IsOpen("Inventory") and v11 == "Abilities" then
			v12:Fire("Abilities")
		end
	end)
	v1:OnChange("EquippedBaitId", function(p1, p2) --[[ Line: 1194 | Upvalues: v23 (ref) ]]
		if p1 == p2 then
			return
		end
		for v1, v2 in v23:GetAllTiles() do
			local v3 = v2:FindFirstChildWhichIsA("UIStroke")
			if v3 then
				v3.Enabled = v2:GetAttribute("BaitId") == p1
			end
		end
	end)
	local AutoOptions = Inventory.Main.Top.AutoOptions
	local function updateAutoSellThreshold(p1) --[[ updateAutoSellThreshold | Line: 1209 | Upvalues: TierUtility (ref), AutoOptions (copy) ]]
		if not p1 then
			return
		end
		local v1 = TierUtility:GetTier(p1)
		if v1 then
			AutoOptions.Auto.UIGradient.Color = v1.TierColor
			AutoOptions.Auto.Label.UIGradient.Color = v1.TierColor
			AutoOptions.Auto.Label.Text = ("Sell All: %*"):format(v1.Name)
		else
			AutoOptions.Auto.Label.Text = "Error Updating"
		end
	end
	GuiControl:Hook("Hold Button", AutoOptions.Auto).Clicked:Connect(function() --[[ Line: 1222 | Upvalues: v16 (ref), v1 (ref), Constants (ref), TierUtility (ref), PromptController (ref), v2 (ref) ]]
		if v16 then
			return
		end
		v16 = true
		local v22 = table.find(Constants.AutoSellTiers, (v1:GetExpect("AutoSellThreshold"))) or 1
		local v4 = TierUtility:GetTier(Constants.AutoSellTiers[if v22 + 1 > #Constants.AutoSellTiers then 1 else v22 + 1])
		if not v4 then
			v16 = false
			return
		end
		local v5, v6
		if v4.Name == "SECRET" then
			local v7, v8 = PromptController:FirePrompt((("Turn on selling all <b><font color=\"#%*\">SECRET</font></b> Tier Fish?"):format((v4.TierColor.Keypoints[1].Value:ToHex())))):catch(warn):await()
			v5 = v7
			v6 = v8
		else
			v5 = true
			v6 = true
		end
		if not (v5 and v6) then
			v16 = false
			return
		end
		v2:InvokeServer(v4.Tier)
		v16 = false
	end)
	v1:OnChange("AutoSellThreshold", updateAutoSellThreshold)
	updateAutoSellThreshold(v1:Get("AutoSellThreshold"))
	GuiControl:Hook("Hold Button", Configuration.Frame.Favorites).Clicked:Connect(setFavorites)
	GuiControl:Hook("Hold Button", Configuration.Frame.Mutations).Clicked:Connect(setMutations)
	GuiControl:Hook("Hold Button", Configuration.Frame.None).Clicked:Connect(resetSorts)
	GuiControl:Hook("Hold Button", Configuration.Frame.Skins).Clicked:Connect(setSkins)
	v1:OnChange({ "EquippedCharmId" }, function() --[[ refreshUnequipButton | Line: 1261 | Upvalues: v1 (ref), Unequip (ref) ]]
		Unequip.Visible = v1:GetExpect({ "EquippedCharmId" }) > 0
	end)
	local v13 = Unequip
	v13.Visible = v1:GetExpect({ "EquippedCharmId" }) > 0
	GuiControl:Hook("Hold Button", Unequip).Clicked:Connect(function() --[[ Line: 1270 | Upvalues: TileInteraction (ref), v24 (ref) ]]
		TileInteraction:UnequipCharm()
		v24:DestroyFocus()
	end)
	Observers.observeTag("MobileGridSize", function(p1) --[[ Line: 1276 | Upvalues: v6 (ref), v7 (ref) ]]
		if v6 then
			p1.CellSize = v6
		end
		v7:Connect(function() --[[ Line: 1278 | Upvalues: p1 (copy), v6 (ref) ]]
			p1.CellSize = v6
		end)
	end)
	Device:RegisterDeviceChanged(updateTileSize)
end
function ShowAllEquipped() --[[ ShowAllEquipped | Line: 1293 | Upvalues: v17 (ref), v19 (ref), v1 (ref), EquipLabel (copy), PlayerStatsUtility (copy), ItemUtility (copy), v25 (ref), InventoryPagination (copy), Pets (copy), v14 (ref), TileInteraction (copy) ]]
	if v17 then
		return
	end
	v17 = true
	v19:DestroyTiles()
	local v12 = v1 and v1:Get("EquippedPetUUID")
	EquipLabel.Text = ("Equipped Pets (%*/1)"):format(if v12 and v12 ~= "" then 1 else 0)
	local t = {}
	local v3 = v1:GetExpect("EquippedPetUUID")
	if string.len(v3) > 0 then
		local v4 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 1306 | Upvalues: v3 (copy) ]]
			return p1.UUID == v3
		end, "Pets")
		if v4 then
			local v5 = ItemUtility.GetItemDataFromItemType("Pets", v4.Id)
			if v5 then
				table.insert(t, {
					Category = "Pets",
					Item = v4,
					LayoutOrder = v19:GetLayoutOrder(v4, v5, nil)
				})
			end
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 1322 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	if not v25 then
		v25 = InventoryPagination.new(Pets.Top, {
			OnPageLoaded = function() --[[ OnPageLoaded | Line: 1329 ]] end
		})
	end
	v25:SetItems(t)
	local function f6(p1, p2) --[[ Line: 1337 | Upvalues: v19 (ref), v14 (ref), TileInteraction (ref) ]]
		local Item = p1.Item
		local v1 = v19:Draw(p1.Category, Item.Id, Item)
		if v1 then
			v1.Tile:SetAttribute("__originalOrder", v1.Tile.LayoutOrder)
			v19:AddInteractionFromTile(v1.Tile, function() --[[ Line: 1348 | Upvalues: v14 (ref), TileInteraction (ref), Item (copy) ]]
				if not v14 then
					v14 = true
					task.delay(0.2, function() --[[ Line: 244 | Upvalues: v14 (ref) ]]
						v14 = false
					end)
					TileInteraction:TogglePet(Item.UUID)
				end
			end)
		end
	end
	if v25:GetTotalItems() > 0 then
		v25:LoadNextPage(f6)
		v25:StartScrollMonitoring(f6)
	end
	v17 = false
end
return t2
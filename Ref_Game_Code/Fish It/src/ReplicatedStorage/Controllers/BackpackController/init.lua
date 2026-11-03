-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("GuiService")
game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Modules.ItemStringUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Shared.Soundbook)
local FishingRodModifiers = require(ReplicatedStorage.Shared.FishingRodModifiers)
local Abilities = require(ReplicatedStorage.Abilities)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Types.Modifiers)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local Device = require(ReplicatedStorage.Modules.Device)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local v2 = Net:RemoteEvent("UnequipToolFromHotbar")
local v3 = Net:RemoteEvent("EquipToolFromHotbar")
local v4 = Net:RemoteEvent("UnequipItem")
local v5 = Net:RemoteEvent("FavoriteStateChanged")
Net:RemoteEvent("RollEnchant")
PlayerGui:WaitForChild("Quest")
local Backpack = PlayerGui:WaitForChild("Backpack")
local Display = Backpack:WaitForChild("Display")
local v6 = false
local v7 = true
local v8 = nil
local Modifiers = script:WaitForChild("Modifiers")
local ModifierTiles = script:WaitForChild("ModifierTiles")
local EquipRodNotification = script:WaitForChild("EquipRodNotification")
local Tile = Backpack:WaitForChild("Display"):WaitForChild("Tile")
Tile.Parent = nil
local v9 = false
local v10 = false
local v11 = Signal.new()
local v12 = true
local function getAbilityShardCount() --[[ getAbilityShardCount | Line: 82 | Upvalues: ItemUtility (copy), v1 (ref) ]]
	local v12 = ItemUtility:GetItemData("Ability Shard")
	if not v12 then
		return 0
	end
	local v2 = v1:Get({ "Inventory", "Items" })
	if typeof(v2) ~= "table" then
		return 0
	end
	local sum = 0
	for i, v in ipairs(v2) do
		if v.Id == v12.Data.Id then
			sum = sum + (v.Quantity or 1)
		end
	end
	return sum
end
local v13 = 1
local t = { 1, 4, 5, 6, 7, 8, 9, 0 }
local t2 = {
	PC = {
		Enum.KeyCode.One,
		Enum.KeyCode.Four,
		Enum.KeyCode.Five,
		Enum.KeyCode.Six,
		Enum.KeyCode.Seven
	},
	Console = { Enum.KeyCode.ButtonX },
	Special = { Enum.KeyCode.ButtonX, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight }
}
local t3 = {
	["001"] = Display:WaitForChild("Inventory"),
	["002"] = Display:WaitForChild("Rods")
}
local t4 = {}
local t5 = {
	Resize = function(p1) --[[ Resize | Line: 143 | Upvalues: Display (copy), t3 (copy) ]]
		local v1 = Display:GetAttribute("TileSize")
		if not v1 then
			return
		end
		for v2, v3 in t3 do
			v3.Size = v1
		end
	end
}
function t5.ToggleHotbarItem(p1, p2) --[[ ToggleHotbarItem | Line: 152 | Upvalues: LocalPlayer (copy), Backpack (copy), v1 (ref), t5 (copy) ]]
	if LocalPlayer:GetAttribute("Loading") == nil then
		return
	end
	if not Backpack.Enabled then
		return
	end
	local v12 = v1:Find("EquippedItems", p2)
	if v12 ~= nil then
		t5:ToolbarInput(v12, p2, (v1:GetExpect("EquippedId")))
	end
end
function t5.ToolbarInput(p1, p2, p3, p4) --[[ ToolbarInput | Line: 170 | Upvalues: v2 (copy), v3 (copy) ]]
	if p4 == p3 then
		v2:FireServer()
	else
		v3:FireServer(p2)
	end
end
function t5.Refresh(p1) --[[ Refresh | Line: 178 | Upvalues: v9 (ref), v10 (ref), v11 (copy), t3 (copy), v1 (ref) ]]
	if v9 then
		return
	end
	if v10 then
		v11:Wait()
	end
	v10 = true
	v9 = true
	if next(t3) then
		for v12, v2 in t3 do
			if v12 ~= "001" and v12 ~= "002" then
				v2:Destroy()
				t3[v12] = nil
			end
		end
	end
	for i, v in ipairs((v1:GetExpect("EquippedItems"))) do
		DrawTile(i, v)
	end
	v11:Fire()
	task.wait()
	v9 = false
	v10 = false
end
function t5.RegisterModifierFrames(p1) --[[ RegisterModifierFrames | Line: 218 | Upvalues: Modifiers (copy), FishingRodModifiers (copy), ModifierTiles (copy), PlayerStatsUtility (copy), LocalPlayer (copy), v1 (ref), ToolTip (copy), t4 (copy), Trove (copy), Abilities (copy), getAbilityShardCount (copy), GuiControl (copy), ItemUtility (copy), v7 (ref), v8 (ref), Device (copy), TextNotificationController (ref), Backpack (copy) ]]
	local v12 = Modifiers:Clone()
	local v2 = nil
	for v3, v4 in FishingRodModifiers do
		local v5 = ModifierTiles:FindFirstChild(v3)
		if v5 then
			local t = { "Modifiers", v3 }
			local v6 = v5:Clone()
			local function f7(p1) --[[ Line: 232 | Upvalues: PlayerStatsUtility (ref), LocalPlayer (ref), v4 (copy), v3 (copy), v6 (copy), v12 (copy) ]]
				local v1 = PlayerStatsUtility:GetPlayerModifiers(LocalPlayer)
				local Requirement = v4.Requirement
				local v2 = v1.Frequency[v3]
				if v2 then
					Requirement = math.max(Requirement - v2, 1)
				end
				local v42 = math.min(p1, Requirement)
				local v5 = math.clamp(v42 / Requirement, 0, 1) * -1
				if not (v6 and v6:IsDescendantOf(v12)) then
					return
				end
				v6.Fill.UIGradient.Offset = Vector2.new(0, v5)
				v6.Label.Text = ("%*/%*"):format(v42, Requirement)
			end
			v1:OnChange(t, f7)
			v1:OnChange("EquippedId", function(p1) --[[ Line: 253 | Upvalues: f7 (copy), v1 (ref), t (copy) ]]
				if not (string.len(p1) > 0) then
					return
				end
				f7(v1:GetExpect(t))
			end)
			task.defer(function() --[[ Line: 259 | Upvalues: f7 (copy), v1 (ref), t (copy) ]]
				f7(v1:GetExpect(t))
			end)
			ToolTip.observe(v6, nil, function() --[[ Line: 263 | Upvalues: v4 (copy) ]]
				return {
					Style = "Label",
					Text = v4.Description,
					Icon = v4.Icon
				}
			end)
			v6.Visible = false
			v6.Parent = v12
			t4[v3] = v6
		end
	end
	local Ability = ModifierTiles:FindFirstChild("Ability")
	if Ability then
		local v82 = Ability:Clone()
		local v9 = Trove.new()
		local function applyAbilityTileIcon(p1) --[[ applyAbilityTileIcon | Line: 282 | Upvalues: v82 (copy) ]]
			if p1 ~= "" then
				v82.Image = p1
				v82.Fill.Image = p1
			end
		end
		local function getEquippedAbilityData() --[[ getEquippedAbilityData | Line: 291 | Upvalues: v1 (ref), Abilities (ref) ]]
			local v12 = v1:Get({ "Abilities", "Equipped" })
			if not v12 or v12 == "" then
				return nil, nil
			end
			local v2 = v1:Get({ "Abilities", "Inventory" })
			if typeof(v2) == "table" then
				for i, v in ipairs(v2) do
					if v.UUID == v12 or v.Name == v12 then
						return v, Abilities[v.Name]
					end
				end
				local v3 = Abilities[v12]
				if v3 then
					return {
						Timestamp = 0,
						UUID = v12,
						Name = v12,
						TradeLock = {
							Type = "Untradable"
						}
					}, v3
				else
					return nil, nil
				end
			else
				local v4 = Abilities[v12]
				if v4 then
					return {
						Timestamp = 0,
						UUID = v12,
						Name = v12,
						TradeLock = {
							Type = "Untradable"
						}
					}, v4
				else
					return nil, nil
				end
			end
		end
		v2 = function() --[[ Line: 335 | Upvalues: getEquippedAbilityData (copy), v1 (ref), getAbilityShardCount (ref), v82 (copy) ]]
			local v12, v2 = getEquippedAbilityData()
			if v12 and v2 then
				local v3 = v1:Get({ "Abilities", "CurrentRolls" }) or 0
				local v4 = v1:Get({ "Abilities", "Active" })
				local v5 = v1:Get({ "Abilities", "ActiveRollsRemaining" }) or 0
				local v6 = if v4 == v12.UUID then if v5 > 0 then true else false else false
				local v7 = if v6 then v2.NumOfRollsEffectStays else v2.CastNumberTrigger
				local v8 = if v6 then v5 else math.min(v3, v7)
				local v9 = math.clamp(v8 / v7, 0, 1) * -1
				local Color = v2.Color
				local Fill = v82:FindFirstChild("Fill")
				local v10 = if Fill then Fill:FindFirstChildOfClass("UIGradient") else Fill
				if v10 then
					v10.Offset = Vector2.new(0, v9)
					v10.Color = Color
				end
				local Label = v82:FindFirstChild("Label")
				if Label and Label:IsA("TextLabel") then
					Label.Text = if v6 then ("%* Left"):format(v8) else ("%*/%*"):format(v8, v7)
				end
				local ItemName = v82:FindFirstChild("ItemName", true)
				if ItemName and ItemName:IsA("TextLabel") then
					ItemName.Text = v2.Name
				end
				local v14 = v2.Data.Icon or ""
				if v14 ~= "" then
					v82.Image = v14
					v82.Fill.Image = v14
				end
				v82:SetAttribute("AbilityName", v2.Name)
				v82:SetAttribute("AbilityUUID", v12.UUID)
				v82.Visible = v1:GetExpect("EquippedType") == "Fishing Rods"
			else
				local v17 = v1:Get({ "Abilities", "FreeRolls" }) or 0
				local v18 = getAbilityShardCount()
				local Label = v82:FindFirstChild("Label")
				if Label and Label:IsA("TextLabel") then
					Label.Text = if v17 > 0 then ("Roll (%*)"):format(v17) else ("Shards %*/6"):format((math.min(v18, 6)))
				end
				local Fill = v82:FindFirstChild("Fill")
				local v22 = if Fill then Fill:FindFirstChildOfClass("UIGradient") else Fill
				if v22 then
					v22.Offset = Vector2.new(0, 0)
				end
				v82:SetAttribute("AbilityName", nil)
				v82:SetAttribute("AbilityUUID", nil)
				v82.Visible = v1:GetExpect("EquippedType") == "Fishing Rods"
			end
		end
		local function updateAbilityTooltip() --[[ updateAbilityTooltip | Line: 391 | Upvalues: v9 (copy), ToolTip (ref), v82 (copy), getEquippedAbilityData (copy) ]]
			v9:Clean()
			ToolTip.destroyAll()
			ToolTip.observe(v82, v9, function() --[[ Line: 395 | Upvalues: getEquippedAbilityData (ref) ]]
				local v1, v2 = getEquippedAbilityData()
				if v1 and v2 then
					return {
						Style = "Label",
						Text = v2.Description,
						Icon = v2.Data.Icon
					}
				else
					return {
						Style = "Label",
						Text = "No ability equipped",
						Icon = ""
					}
				end
			end)
		end
		local function updateAbilityState() --[[ updateAbilityState | Line: 413 | Upvalues: v2 (ref), v9 (copy), ToolTip (ref), v82 (copy), getEquippedAbilityData (copy) ]]
			v2()
			v9:Clean()
			ToolTip.destroyAll()
			ToolTip.observe(v82, v9, function() --[[ Line: 395 | Upvalues: getEquippedAbilityData (ref) ]]
				local v1, v2 = getEquippedAbilityData()
				if v1 and v2 then
					return {
						Style = "Label",
						Text = v2.Description,
						Icon = v2.Data.Icon
					}
				else
					return {
						Style = "Label",
						Text = "No ability equipped",
						Icon = ""
					}
				end
			end)
		end
		v1:OnChange({ "Abilities", "Equipped" }, updateAbilityState)
		v1:OnChange({ "Abilities", "CurrentRolls" }, v2)
		v1:OnChange({ "Abilities", "Active" }, v2)
		v1:OnChange({ "Abilities", "ActiveRollsRemaining" }, v2)
		v1:OnChange({ "Abilities", "Inventory" }, updateAbilityState)
		v1:OnChange({ "Abilities", "FreeRolls" }, v2)
		v1:OnChange({ "Inventory", "Items" }, v2)
		v1:OnChange("EquippedType", v2)
		task.defer(updateAbilityState)
		if v82:IsA("GuiObject") then
			v82.InputBegan:Connect(function(p1) --[[ Line: 430 | Upvalues: GuiControl (ref) ]]
				if p1.UserInputType ~= Enum.UserInputType.MouseButton1 and (p1.UserInputType ~= Enum.UserInputType.Touch and p1.KeyCode ~= Enum.KeyCode.ButtonA) then
					return
				end
				GuiControl:Open("!!!! AbilityUI")
			end)
		end
		v82.Visible = false
		v82.Parent = v12
		t4.Ability = v82
	end
	local function updateModifiers(p1) --[[ updateModifiers | Line: 444 | Upvalues: FishingRodModifiers (ref), t4 (ref), ItemUtility (ref), v2 (ref), v1 (ref), v12 (copy) ]]
		for v13, v22 in FishingRodModifiers do
			local v3 = t4[v13]
			if v3 then
				local v4 = ItemUtility.GetItemDataFromItemType("Fishing Rods", p1.Id)
				v3.Visible = if v22.RequiredTier and (v4 and v4.Data.Tier) then v4.Data.Tier >= v22.RequiredTier else true
			end
		end
		local Ability = t4.Ability
		if Ability and v2 then
			v2()
		elseif Ability then
			Ability.Visible = false
		end
		v12.Visible = v1:GetExpect("EquippedType") == "Fishing Rods"
	end
	local function hideModifiers() --[[ hideModifiers | Line: 474 | Upvalues: FishingRodModifiers (ref), t4 (ref), v1 (ref), v12 (copy) ]]
		for v13, v2 in FishingRodModifiers do
			local v3 = t4[v13]
			if v3 then
				v3.Visible = false
			end
		end
		local Ability = t4.Ability
		if Ability then
			Ability.Visible = false
		end
		v12.Visible = v1:GetExpect("EquippedType") == "Fishing Rods"
	end
	local function valueChanged() --[[ valueChanged | Line: 493 | Upvalues: v1 (ref), PlayerStatsUtility (ref), updateModifiers (copy), hideModifiers (copy) ]]
		local v12 = v1:GetExpect("EquippedItems")[1]
		local v2 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 497 | Upvalues: v12 (copy) ]]
			return p1.UUID == v12
		end, "Fishing Rods")
		if v2 then
			updateModifiers(v2)
		else
			hideModifiers()
		end
	end
	local function registerEquipNotification() --[[ registerEquipNotification | Line: 508 | Upvalues: v1 (ref), v7 (ref), v8 (ref), Device (ref), TextNotificationController (ref) ]]
		local v12 = v1:GetExpect({ "Statistics", "FishCaught" })
		local v2 = v1:GetExpect("NewPlayer")
		local v3 = v1:GetExpect("Level")
		if v2 or (v12 <= 1000 or v3 < 20) then
			v7 = true
		end
		local v4 = nil
		v4 = v1:OnChange({ "EquippedType" }, function(p1) --[[ Line: 522 | Upvalues: v7 (ref), v4 (ref), v8 (ref), v3 (copy), Device (ref), TextNotificationController (ref) ]]
			if p1 ~= "Fishing Rods" then
				return
			end
			v7 = false
			v4:Disconnect()
			if v8 then
				v8:Destroy()
				v8 = nil
			end
			if not (v3 < 20) then
				return
			end
			TextNotificationController:DeliverNotification({
				Type = "Text",
				CustomDuration = 5,
				Text = if Device:IsMobile() then "Use the TAP BUTTON to cast your rod!" elseif Device:_getDevice() == "Console" then "Press [RT] to cast your rod!" else "Click + Hold to charge your rod!",
				TextColor = {
					R = 255,
					G = 255,
					B = 255
				}
			})
		end)
	end
	v1:OnChange("EquippedType", valueChanged)
	v1:OnChange("EquippedItems", valueChanged)
	valueChanged()
	registerEquipNotification()
	v12.Parent = Backpack
end
function t5.Start(p1) --[[ Start | Line: 560 | Upvalues: v1 (ref), Replion (copy), TextNotificationController (ref), ReplicatedStorage (copy), InputControl (ref), t5 (copy), Display (copy), t3 (copy), t (copy), v5 (copy), Device (copy), CollectionService (copy), v6 (ref), LocalPlayer (copy), Backpack (copy), UserInputService (copy), GuiControl (copy), v13 (ref), v12 (ref) ]]
	v1 = Replion.Client:WaitReplion("Data")
	TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	InputControl = require(ReplicatedStorage.Modules.InputControl)
	t5:RegisterModifierFrames()
	Display:GetAttributeChangedSignal("TileSize"):Connect(function() --[[ Line: 570 | Upvalues: t5 (ref) ]]
		t5:Resize()
	end)
	local function destroyTile(p1) --[[ destroyTile | Line: 575 | Upvalues: t3 (ref) ]]
		local v1 = t3[p1]
		if not v1 then
			return
		end
		v1:Destroy()
		t3[p1] = nil
	end
	v1:OnChange("EquippedItems", function(p1, p2) --[[ Line: 593 | Upvalues: t3 (ref), t (ref) ]]
		for i, v in ipairs(p1) do
			local v1 = t3[v]
			if v1 then
				local InputVisual = v1:FindFirstChild("InputVisual")
				if InputVisual then
					InputVisual:SetAttribute("Slot", t[i])
				end
			end
		end
		for i, v in ipairs(p1) do
			if t3[v] == nil then
				DrawTile(i, v)
			end
		end
		for v2 in t3 do
			if v2 ~= "001" and (v2 ~= "002" and table.find(p1, v2) == nil) then
				local v3 = t3[v2]
				if v3 then
					v3:Destroy()
					t3[v2] = nil
				end
			end
		end
	end)
	v5.OnClientEvent:Connect(function(p1, p2) --[[ Line: 624 | Upvalues: v1 (ref), t3 (ref) ]]
		if v1:Find("EquippedItems", p1) == nil then
			return
		end
		local v12 = t3[p1]
		if not v12 then
			return
		end
		local InputVisual = v12:FindFirstChild("InputVisual")
		local v2 = if InputVisual then InputVisual:FindFirstChild("Star") else InputVisual
		if not v2 then
			return
		end
		v2.Visible = p2 and true or false
		if InputVisual.Visible then
			return
		end
		InputVisual.Position = v2.Position
	end)
	v1:OnChange("EquippedItems", function(p1, p2) --[[ Line: 647 | Upvalues: t3 (ref) ]]
		if typeof(p1) ~= "table" or typeof(p2) ~= "table" then
			return
		end
		local v1 = p1[1]
		local v2 = p2[1]
		if v1 == v2 then
			return
		end
		if v2 then
			local v3 = t3[v2]
			if v3 then
				v3:Destroy()
				t3[v2] = nil
			end
		end
		if not v1 then
			return
		end
		DrawTile(1, v1)
	end)
	task.spawn(function() --[[ Line: 666 | Upvalues: Device (ref), t5 (ref) ]]
		Device:RegisterDeviceChanged(InputChanged)
		InputChanged()
		t5:Resize()
	end)
	task.spawn(function() --[[ Line: 673 | Upvalues: CollectionService (ref), v1 (ref) ]]
		CollectionService:GetInstanceAddedSignal("RodSkinActive"):Connect(UpdateSkinLabels)
		v1:OnChange("EquippedSkinUUID", UpdateSkinLabels)
		UpdateSkinLabels()
	end)
	pcall(function() --[[ Line: 681 | Upvalues: t5 (ref), v6 (ref) ]]
		t5:Refresh()
		v6 = true
	end)
	InputControl:RegisterInput({
		Enum.KeyCode.One,
		Enum.KeyCode.Four,
		Enum.KeyCode.Five,
		Enum.KeyCode.Six,
		Enum.KeyCode.Seven,
		Enum.KeyCode.ButtonX
	}, { function() --[[ Line: 702 | Upvalues: LocalPlayer (ref) ]]
			return LocalPlayer:GetAttribute("Loading") == false
		end, function() --[[ Line: 705 | Upvalues: Backpack (ref) ]]
			return Backpack.Enabled
		end }, SuccessInput)
	UpdateTile(2, nil, Backpack.Display.Rods, false)
	UpdateTile(3, nil, Backpack.Display.Inventory, false)
	local function ClampConsolePosition(p1) --[[ ClampConsolePosition | Line: 717 | Upvalues: v1 (ref) ]]
		local v12 = #v1:GetExpect("EquippedItems")
		if v12 < p1 then
			return 1
		end
		if p1 < 1 then
			p1 = v12
		end
		return p1
	end
	UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 730 | Upvalues: GuiControl (ref), v13 (ref), v12 (ref), v1 (ref) ]]
		if p2 then
			return
		end
		if GuiControl.Gui and p1.KeyCode == Enum.KeyCode.ButtonB then
			GuiControl:Close()
			return
		end
		local v14 = if p1.KeyCode == Enum.KeyCode.ButtonR1 then 1 elseif p1.KeyCode == Enum.KeyCode.ButtonL1 then -1 else nil
		local v2 = if v14 then v13 + v14 else nil
		if not v2 then
			return
		end
		if v12 then
			v12 = false
			v2 = 1
		end
		local v3 = #v1:GetExpect("EquippedItems")
		local v4 = if v3 < v2 then 1 elseif v2 < 1 then v3 else v2
		v13 = v4
		SolveInput(v4)
	end)
	v1:OnChange("EquippedItems", function() --[[ Line: 765 | Upvalues: v13 (ref), v1 (ref) ]]
		local v12 = v13
		local v2 = #v1:GetExpect("EquippedItems")
		if v2 < v12 then
			v12 = 1
		elseif v12 < 1 then
			v12 = v2
		end
		v13 = v12
	end)
end
function DrawTile(p1, p2) --[[ DrawTile | Line: 771 | Upvalues: t3 (copy), PlayerStatsUtility (copy), v1 (ref), InventoryMapping (copy), ItemUtility (copy), Trove (copy), Tile (copy), v7 (ref), v8 (ref), EquipRodNotification (copy), spr (copy), GuiControl (copy), v4 (copy), TierUtility (copy), StringLibrary (copy), t5 (copy), Backpack (copy) ]]
	if t3[p2] then
		return
	end
	local v12, v2 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 776 | Upvalues: p2 (copy) ]]
		return p1.UUID == p2
	end)
	if not v12 then
		warn("Could not find inventory item for", p1)
		return
	end
	local v3 = v2.Category or "Items"
	local _ = InventoryMapping[v3]
	local v42 = ItemUtility.GetItemDataFromItemType(v3, v12.Id)
	if not v42 then
		warn("Unable to find item data for", v12.Id, typeof(v12.Id), v12)
		return
	end
	local Metadata = v12.Metadata
	local v6 = if Metadata and Metadata.VariantId then ItemUtility:GetVariantData(Metadata.VariantId) else nil
	local v82 = Trove.new()
	local v9 = Tile:Clone()
	local UIStroke = v9.UIStroke
	local Tags = v9.Inner.Tags
	local Configuration = v9.Inner.Configuration
	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 1
	UIScale.Parent = v9
	UpdateTile(p1, v12, v9, true)
	t3[p2] = v9
	if v42.Data.Type == "Fishing Rods" then
		v9.Inner.Tags.SkinActive:AddTag("RodSkinActive")
	end
	if v42.Data.Type == "Fishing Rods" then
		if v7 then
			if v8 then
				v8:Destroy()
			end
			local v10 = EquipRodNotification:Clone()
			v10.Visible = true
			v10.Parent = v9
			v8 = v10
		end
	else
		local v11 = Trove.new()
		local v122 = true
		local v13 = nil
		local v14 = script.Hitbox:Clone()
		local Close = v14.Close
		local function tweenButton(p1, p2) --[[ tweenButton | Line: 843 | Upvalues: spr (ref), Close (copy) ]]
			spr.stop(Close)
			spr.target(Close, 3, 15, {
				ImageTransparency = p1
			})
			if not p2 then
				return
			end
			spr.completed(Close, p2)
		end
		local function onLeave() --[[ onLeave | Line: 854 | Upvalues: v122 (ref), v13 (ref), tweenButton (copy), Close (copy) ]]
			if not v122 then
				return
			end
			local v1 = tick()
			v13 = v1
			task.wait(0.4)
			if v1 == v13 then
				tweenButton(1, function() --[[ Line: 867 | Upvalues: v1 (copy), v13 (ref), Close (ref) ]]
					if v1 == v13 then
						Close.Visible = false
					end
				end)
			end
		end
		local function onEnter() --[[ onEnter | Line: 876 | Upvalues: v122 (ref), v13 (ref), Close (copy), spr (ref) ]]
			if v122 then
				v13 = tick()
				Close.Visible = true
				spr.stop(Close)
				spr.target(Close, 3, 15, {
					ImageTransparency = 0
				})
			end
		end
		local v15 = GuiControl:Hook("Hold Button", Close, nil, nil, v11)
		v11:Add(function() --[[ Line: 888 | Upvalues: v122 (ref), v13 (ref), spr (ref), Close (copy) ]]
			v122 = false
			v13 = nil
			spr.stop(Close)
		end)
		v15.Clicked:Connect(function() --[[ Line: 894 | Upvalues: v1 (ref), p2 (copy), v4 (ref) ]]
			if v1:Find("EquippedItems", p2) ~= nil then
				v4:FireServer(p2)
			end
		end)
		v11:Add(v9.MouseEnter:Connect(onEnter))
		v11:Add(v9.MouseLeave:Connect(onLeave))
		v9.Destroying:Once(function() --[[ Line: 905 | Upvalues: v11 (copy) ]]
			v11:Destroy()
		end)
		Close.ImageTransparency = 1
		v14.Parent = v9
	end
	local v16 = nil
	if v42.Probability then
		v16 = TierUtility:GetTierFromRarity(v42.Probability.Chance)
	elseif v42.Data.Tier then
		v16 = TierUtility:GetTier(v42.Data.Tier)
	end
	if v16 then
		v9.Inner.Tags.ItemName.Text = v42.Data.Name
		v9.Inner.Tags.ItemName.UIGradient.Color = v16.TierColor
	end
	Vector2.new(0.5, 0.5)
	UDim2.fromScale(0.5, 0.525)
	local v17 = UDim2.fromScale(0.7, 0.7)
	local v18, v19
	if v42.Data.Type == "Fishing Rods" then
		if v42.Data.NewIcon then
			local v20 = UDim2.fromScale(2, 2)
			v18 = UDim2.fromScale(0.5, 0.5)
			v19 = Vector2.new(0.5, 0.5)
			v17 = v20
		else
			local v21 = UDim2.fromScale(1.05, 2.6)
			v18 = UDim2.fromScale(0.6, 1.025)
			v19 = Vector2.new(0.5, 1)
			v17 = v21
		end
		Configuration.Visible = false
	else
		local v22 = Metadata and Metadata.Shiny
		Configuration.ShinyFrame.Visible = v22
		v9.Inner.ShinyUnderlay.Visible = v22
		local Weight = v42.Weight
		local v23 = if Metadata then Metadata.Weight else Metadata
		if v23 and Weight then
			if if Weight.Big.Min <= v23 then true else false then
				local v25 = UDim2.fromScale(1.4, 1.4)
				Configuration.BigFrame.Visible = true
				v17 = v25
			end
			Configuration.WeightFrame.Label.Text = StringLibrary:AddWeight(v23)
			Configuration.WeightFrame.Visible = true
		else
			Configuration.WeightFrame.Visible = false
		end
		v18 = UDim2.fromScale(0.5, 0.525)
		v19 = Vector2.new(0.5, 0.5)
	end
	if v6 then
		Tags.Variant.Text = v6.Data.Name
		Tags.Variant.UIGradient.Color = v6.Data.TierColor
		Tags.Variant.Visible = true
	end
	local v27 = v1:Get("OnboardingStep")
	if (if v42.Data.Type == "Fish" then true else false) and (v27 and v27 < 5) then
		UIStroke.Thickness = 3
		UIStroke.UIGradient.Enabled = false
		UIStroke.Enabled = true
		task.spawn(function() --[[ Line: 985 | Upvalues: UIStroke (copy), v9 (copy) ]]
			local v1 = Color3.fromRGB(100, 255, 100)
			local v2 = Color3.fromRGB(255, 255, 255)
			local sum = 0
			local v3 = true
			while sum < 3 and UIStroke.Parent do
				UIStroke.Color = if v3 then v1 else v2
				task.wait(0.2)
				sum = sum + 0.2
				v3 = not v3
			end
			if not (v9 and v9.Parent) then
				return
			end
			UIStroke.Color = v2
			UIStroke.Thickness = 1.6
			UIStroke.UIGradient.Enabled = true
		end)
	end
	local Enchant1 = Tags.Enchant1
	Enchant1.Parent = nil
	if Metadata then
		for v29, v30 in { Metadata.EnchantId, Metadata.EnchantId2 } do
			local v31 = ItemUtility:GetEnchantData(v30)
			if v31 then
				local v32 = Enchant1:Clone()
				v32.Text = v31.Data.Name
				v32.UIGradient.Color = v31.Data.TierColor
				v32.LayoutOrder = v32.LayoutOrder + (v29 - 1)
				v32.Visible = true
			end
		end
	end
	local v33 = CombineColors(Metadata) or v6 and v6.Data.TierColor
	if v33 then
		v9.UIStroke.UIGradient.Color = v33
	end
	Enchant1:Destroy()
	local function onEquippedIdChanged(p1) --[[ onEquippedIdChanged | Line: 1044 | Upvalues: p2 (copy), spr (ref), UIScale (copy) ]]
		if p1 == p2 then
			spr.stop(UIScale)
			spr.target(UIScale, 50, 325, {
				Scale = 1.1
			})
		else
			spr.stop(UIScale)
			spr.target(UIScale, 50, 200, {
				Scale = 1
			})
		end
	end
	local v34 = v1:OnChange("EquippedId", onEquippedIdChanged)
	onEquippedIdChanged(v1:GetExpect("EquippedId"))
	v82:Add(function() --[[ Line: 1061 | Upvalues: v34 (copy) ]]
		v34:Disconnect()
	end)
	local function tileActivated() --[[ tileActivated | Line: 1066 | Upvalues: v9 (copy), t5 (ref), p2 (copy) ]]
		v9.Active = false
		task.delay(0.1, function() --[[ Line: 1068 | Upvalues: v9 (ref) ]]
			v9.Active = true
		end)
		t5:ToggleHotbarItem(p2)
	end
	v82:Add(v9.Activated:Connect(tileActivated))
	v9.Destroying:Once(function() --[[ Line: 1078 | Upvalues: v82 (copy) ]]
		v82:Destroy()
	end)
	local v36 = if v17 == UDim2.fromScale(1.05, 2.6) then Enum.ScaleType.Crop else Enum.ScaleType.Fit
	local Vector = v9.Inner.Vector
	Vector.Size = v17
	Vector.Position = v18
	Vector.AnchorPoint = v19
	Vector.ScaleType = v36
	Vector.Image = v42.Data.Icon or ""
	v9.Size = Backpack.Display:GetAttribute("TileSize")
	v9.LayoutOrder = p1
	v9.Parent = Backpack.Display
end
function InputChanged() --[[ InputChanged | Line: 1103 | Upvalues: Device (copy), Backpack (copy) ]]
	if Device:IsMobile() then
		Backpack.Display:SetAttribute("TileSize", UDim2.fromOffset(58, 58))
		Backpack.Display.Position = UDim2.fromScale(0.475, 1)
	else
		Backpack.Display:SetAttribute("TileSize", UDim2.fromOffset(80, 80))
		Backpack.Display.Position = UDim2.fromScale(0.5, 1)
	end
end
function UpdateSkinLabels() --[[ UpdateSkinLabels | Line: 1113 | Upvalues: v1 (ref), CollectionService (copy) ]]
	local v2 = string.len((v1:GetExpect("EquippedSkinUUID"))) > 0
	for i, v in ipairs(CollectionService:GetTagged("RodSkinActive")) do
		v.Visible = v2
	end
end
function CombineColors(p1) --[[ CombineColors | Line: 1122 | Upvalues: ItemUtility (copy) ]]
	if p1 == nil then
		return
	end
	local list = {}
	for v1, v2 in { p1.EnchantId, p1.EnchantId2 } do
		local v3 = ItemUtility:GetEnchantData(v2)
		if v3 then
			table.insert(list, v3.Data.TierColor)
		end
	end
	if not (#list > 0) then
		return
	end
	local v4 = #list
	local t = {}
	for i, v in ipairs(list) do
		local v5 = (i - 1) / v4
		local v6 = 1 / v4
		for i2, v2 in ipairs(v.Keypoints) do
			local v8 = ColorSequenceKeypoint.new
			table.insert(t, v8(v5 + v2.Time * v6, v2.Value))
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 1152 ]]
		return p1.Time < p2.Time
	end)
	if #t > 19 then
		local v10 = (#t - 1) / 18
		local t2 = {}
		for i = 0, 18 do
			table.insert(t2, t[math.floor(i * v10) + 1])
		end
		t = t2
	end
	if #t < 2 then
		if #t ~= 1 then
			return ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
		end
		local v12 = ColorSequenceKeypoint.new
		table.insert(t, v12(1, t[1].Value))
	end
	if t[1].Time > 0 then
		local v14 = ColorSequenceKeypoint.new
		table.insert(t, 1, v14(0, t[1].Value))
	end
	if t[#t].Time < 1 then
		local v16 = ColorSequenceKeypoint.new
		table.insert(t, v16(1, t[1].Value))
	end
	return ColorSequence.new(t)
end
function UpdateTile(p1, p2, p3, p4) --[[ UpdateTile | Line: 1195 | Upvalues: Device (copy), t2 (copy), UserInputService (copy), t (copy) ]]
	local InputVisual = p3:WaitForChild("InputVisual")
	local BG = InputVisual:WaitForChild("BG")
	local Vector = InputVisual:WaitForChild("Vector")
	local Label = InputVisual:WaitForChild("Label")
	local Star = InputVisual:WaitForChild("Star")
	local Position = Star.Position
	local function updateDeviceLabels() --[[ updateDeviceLabels | Line: 1204 | Upvalues: Device (ref), BG (copy), Vector (copy), Label (copy), InputVisual (copy), t2 (ref), p4 (copy), p1 (copy), UserInputService (ref), Star (copy), Position (copy) ]]
		local v1 = Device:IsMobile()
		local Device_2 = Device.Device
		if v1 then
			BG.Visible = false
			Vector.Visible = false
			Label.Visible = false
		else
			if Device_2 == "Console" then
				local v2 = nil
				if InputVisual:GetAttribute("Slot") then
					local v3 = if t2.Console and p4 then t2.Console[p1] elseif t2.Special then t2.Special[p1] else nil
					if v3 then
						v2 = UserInputService:GetImageForKeyCode(v3)
					end
				end
				local v5 = if typeof(v2) == "string" then if string.len(v2) > 0 then true else false else false
				if v5 then
					Vector.Image = v2
				end
				Vector.Visible = v5
				InputVisual.Visible = v5
				Label.Visible = false
			else
				Vector.Visible = false
				InputVisual.Visible = true
				Label.Visible = true
			end
			BG.Visible = true
		end
		if v1 then
			Star.AnchorPoint = Vector2.new(0.5, 0.5)
			Star.Position = UDim2.fromScale(0.5, 0.5)
		else
			Star.AnchorPoint = Vector2.new(0, 0.5)
			Star.Position = Position
		end
		local v6 = if Device_2 == "Console" then 0.3 else 0.22
		InputVisual.Size = UDim2.fromScale(v6, v6)
	end
	local function slotChanged() --[[ slotChanged | Line: 1255 | Upvalues: InputVisual (copy), Label (copy), p3 (copy) ]]
		local v1 = InputVisual:GetAttribute("Slot")
		if v1 then
			Label.Text = tostring(v1)
			p3.LayoutOrder = v1
		end
	end
	local v1 = Device:RegisterDeviceChanged(updateDeviceLabels)
	local v2 = InputVisual:GetAttributeChangedSignal("Slot"):Connect(slotChanged)
	InputVisual.Destroying:Once(function() --[[ Line: 1269 | Upvalues: v2 (copy), Device (ref), v1 (copy) ]]
		v2:Disconnect()
		Device:Remove(v1)
	end)
	InputVisual:SetAttribute("Slot", p4 and t[p1] or p1)
	if not p2 then
		pcall(function() --[[ Line: 1282 | Upvalues: updateDeviceLabels (copy), InputVisual (copy), Label (copy), p3 (copy) ]]
			updateDeviceLabels()
			local v1 = InputVisual:GetAttribute("Slot")
			if v1 then
				Label.Text = tostring(v1)
				p3.LayoutOrder = v1
			end
		end)
		InputVisual.Parent = p3
		return
	end
	Star.Visible = p2.Favorited
	pcall(function() --[[ Line: 1282 | Upvalues: updateDeviceLabels (copy), InputVisual (copy), Label (copy), p3 (copy) ]]
		updateDeviceLabels()
		local v1 = InputVisual:GetAttribute("Slot")
		if v1 then
			Label.Text = tostring(v1)
			p3.LayoutOrder = v1
		end
	end)
	InputVisual.Parent = p3
end
function SolveInput(p1) --[[ SolveInput | Line: 1290 | Upvalues: v1 (ref), t5 (copy) ]]
	local v12 = v1:GetExpect("EquippedItems")
	local v2 = v1:GetExpect("EquippedId")
	local v3 = v12[p1]
	if not v3 then
		return
	end
	t5:ToolbarInput(p1, v3, v2)
end
function SuccessInput(p1) --[[ SuccessInput | Line: 1300 | Upvalues: Device (copy), t2 (copy), v13 (ref) ]]
	local v1 = Device:_getDevice()
	local v2 = nil
	if v1 == "Console" then
		if p1.KeyCode == Enum.KeyCode.ButtonX then
			v2 = 1
		end
	else
		local v3 = t2[v1]
		if not v3 then
			return
		end
		v2 = table.find(v3, p1.KeyCode)
	end
	if not v2 then
		return
	end
	if v2 == 1 then
		if v1 == "Console" and v2 == v13 then
			SolveInput(v13)
			return
		end
		v13 = 1
	end
	SolveInput(v2)
end
return t5
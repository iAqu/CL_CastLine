local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlotPlacementUtil = require(ReplicatedStorage.Modules.PlotPlacementUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local PlotPedestalService = Knit.CreateService({
	Name = "PlotPedestalService",
	Client = {},
})

local EMPTY_ITEM_ATTRIBUTES = {
	ItemUid = "",
	ItemId = "",
	Weight = 0,
	ConditionId = "",
	Price = 0,
	MutationId = "",
}

local function result(ok: boolean, message: string)
	return { ok = ok, message = message }
end

local function getPedestals(plot: Instance): { Instance }
	local folder = plot:FindFirstChild("Pedestals")
	if not folder then
		return {}
	end

	local pedestals = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") and child.Name:match("^Pedestal_%d+$") then
			local slot = tonumber(child.Name:match("_(%d+)$"))
			if slot then
				child:SetAttribute("Slot", slot)
				table.insert(pedestals, child)
			end
		end
	end
	table.sort(pedestals, function(left, right)
		return (left:GetAttribute("Slot") or 0) < (right:GetAttribute("Slot") or 0)
	end)
	return pedestals
end

local function getPedestalBySlot(plot: Instance, slot: number): Instance?
	for _, pedestal in ipairs(getPedestals(plot)) do
		if pedestal:GetAttribute("Slot") == slot then
			return pedestal
		end
	end
	return nil
end

local function setEmpty(pedestal: Instance)
	for attribute, value in pairs(EMPTY_ITEM_ATTRIBUTES) do
		pedestal:SetAttribute(attribute, value)
	end
end

local function writeItem(pedestal: Instance, itemUid: string, itemId: string, data)
	pedestal:SetAttribute("ItemUid", itemUid)
	pedestal:SetAttribute("ItemId", itemId)
	pedestal:SetAttribute("Weight", data.Weight)
	pedestal:SetAttribute("ConditionId", data.ConditionId)
	pedestal:SetAttribute("Price", data.Price)
	pedestal:SetAttribute("MutationId", data.MutationId or "")
end

local function getHeldItemTool(player: Player, instanceId: string): Tool?
	local character = player.Character
	if not character then
		return nil
	end
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then
			return child
		end
	end
	return nil
end

local function isEmptyHanded(player: Player): boolean
	local character = player.Character
	if not character then
		return true
	end
	local heldTool = character:FindFirstChildOfClass("Tool")
	return heldTool == nil
end

local DEFAULT_CONDITION_ID = "Codition_1"

local function normalizeItemRecord(record, allowDefaultCondition: boolean?): (any?, any?)
	if typeof(record) ~= "table" or typeof(record.ItemId) ~= "string" then
		return nil, nil
	end
	local item = ItemsData[record.ItemId]
	if not item then
		return nil, nil
	end
	local weight = tonumber(record.Weight)
	local conditionId = record.ConditionId
	local condition = typeof(conditionId) == "string" and ConditionsData[conditionId] or nil
	if not condition and allowDefaultCondition then
		conditionId = DEFAULT_CONDITION_ID
		condition = ConditionsData[conditionId]
	end
	if not weight or weight <= 0 or not condition then
		return nil, nil
	end
	local mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId)
	local price = tonumber(record.Price) or ItemStatUtil.CalculatePrice(
		item,
		weight,
		condition.ValueMult,
		MutationDataUtil.GetPriceRate(mutationId)
	)
	record.Weight = weight
	record.ConditionId = conditionId
	record.Price = price
	record.MutationId = mutationId
	return item, { Weight = weight, ConditionId = conditionId, Price = price, MutationId = mutationId }
end

local function placementContains(placements, itemUid: string, ignoredSlot: number?): boolean
	for slot, placedUid in pairs(placements) do
		if tonumber(slot) ~= ignoredSlot and placedUid == itemUid then
			return true
		end
	end
	return false
end

function PlotPedestalService:_clearPlot(plot: Instance)
	for _, pedestal in ipairs(getPedestals(plot)) do
		setEmpty(pedestal)
	end
end

function PlotPedestalService:_restorePlayerPlot(player: Player)
	local plotSlotService = Knit.GetService("PlotSlotService")
	local plot = plotSlotService:GetPlayerPlot(player)
	local profile = PlayerDataService:GetProfile(player)
	if not plot or not profile then
		return
	end

	if typeof(profile.Data.PlotPlacements) ~= "table" then
		profile.Data.PlotPlacements = {}
	else
		profile.Data.PlotPlacements = PlotPlacementUtil.CoerceNumericKeys(profile.Data.PlotPlacements)
	end
	self:_clearPlot(plot)
	for _, pedestal in ipairs(getPedestals(plot)) do
		local slot = pedestal:GetAttribute("Slot")
		local itemUid = PlotPlacementUtil.GetItemUid(profile.Data.PlotPlacements, slot)
		local record = typeof(itemUid) == "string" and profile.Data.Items[itemUid] or nil
		local item, itemData = normalizeItemRecord(record, true)
		if typeof(slot) == "number" and typeof(itemUid) == "string" and item and itemData then
			writeItem(pedestal, itemUid, item.ItemID, itemData)
		elseif typeof(slot) == "number" and typeof(itemUid) == "string" and not record then
			PlotPlacementUtil.ClearSlot(profile.Data.PlotPlacements, slot)
		end
	end
end

function PlotPedestalService:placeItem(player: Player, slot: unknown, inventoryId: unknown)
	if typeof(slot) ~= "number" or slot % 1 ~= 0 or typeof(inventoryId) ~= "string" then
		return result(false, "Invalid pedestal")
	end
	local plotSlotService = Knit.GetService("PlotSlotService")
	local plot = plotSlotService:GetPlayerPlot(player)
	if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return result(false, "This is not your plot")
	end
	local pedestal = getPedestalBySlot(plot, slot)
	if not pedestal or pedestal:GetAttribute("Owned") == false then
		return result(false, "This pedestal is unavailable")
	end
	local heldTool = getHeldItemTool(player, inventoryId)
	if not heldTool then
		return result(false, "Hold an item to place")
	end

	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return result(false, "Item data is unavailable")
	end
	if typeof(profile.Data.PlotPlacements) ~= "table" then
		profile.Data.PlotPlacements = {}
	end
	if placementContains(profile.Data.PlotPlacements, inventoryId, slot) then
		return result(false, "Item is already displayed")
	end

	local item, itemData = normalizeItemRecord(profile.Data.Items[inventoryId])
	if not item or not itemData then
		return result(false, "Item data is invalid")
	end

	local oldItemUid = PlotPlacementUtil.GetItemUid(profile.Data.PlotPlacements, slot)
	local oldToolToReturn: Tool? = nil
	local oldToolBackpack: Backpack? = nil
	if typeof(oldItemUid) == "string" then
		local oldItem, oldItemData = normalizeItemRecord(profile.Data.Items[oldItemUid])
		local backpack = player:FindFirstChildOfClass("Backpack")
		if not oldItem or not oldItemData or not backpack then
			return result(false, "Could not return the displayed item")
		end
		local oldTool = ItemToolUtil.Create(oldItemUid, oldItem, oldItemData)
		if not oldTool then
			return result(false, "Could not return the displayed item")
		end
		oldToolToReturn = oldTool
		oldToolBackpack = backpack
	end

	local collectResult = Knit.GetService("PlotCashPoolService"):CollectForPlacementChange(player, slot)
	if not collectResult.ok then
		if oldToolToReturn then
			oldToolToReturn:Destroy()
		end
		return result(false, collectResult.message or "Could not collect pedestal cash")
	end
	PlotPlacementUtil.SetItemUid(profile.Data.PlotPlacements, slot, inventoryId)
	writeItem(pedestal, inventoryId, item.ItemID, itemData)
	heldTool:Destroy()
	if oldToolToReturn then
		oldToolToReturn.Parent = oldToolBackpack
	end
	Knit.GetService("PlotCashPoolService"):OnPlacementChanged(player, slot)
	Knit.GetService("CarryCapacityService"):RefreshPlayer(player)

	Knit.GetService("PlayerLuckService"):RefreshPlayerLuck(player)
	return result(true, if typeof(oldItemUid) == "string" then "Swapped" else "Placed")
end

function PlotPedestalService:pickupItem(player: Player, slot: unknown)
	if typeof(slot) ~= "number" or slot % 1 ~= 0 then
		return result(false, "Invalid pedestal")
	end
	if not isEmptyHanded(player) then
		return result(false, "Put away your held tool first")
	end
	local plotSlotService = Knit.GetService("PlotSlotService")
	local plot = plotSlotService:GetPlayerPlot(player)
	if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return result(false, "This is not your plot")
	end
	local pedestal = getPedestalBySlot(plot, slot)
	if not pedestal then
		return result(false, "This pedestal is unavailable")
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.PlotPlacements) ~= "table" then
		return result(false, "Item data is unavailable")
	end
	local itemUid = PlotPlacementUtil.GetItemUid(profile.Data.PlotPlacements, slot)
	if typeof(itemUid) ~= "string" then
		return result(false, "This pedestal is empty")
	end
	local item, itemData = normalizeItemRecord(profile.Data.Items[itemUid])
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not item or not itemData or not backpack then
		return result(false, "Could not pick up this item")
	end
	local tool = ItemToolUtil.Create(itemUid, item, itemData)
	if not tool then
		return result(false, "Could not pick up this item")
	end

	local collectResult = Knit.GetService("PlotCashPoolService"):CollectForPlacementChange(player, slot)
	if not collectResult.ok then
		tool:Destroy()
		return result(false, collectResult.message or "Could not collect pedestal cash")
	end
	PlotPlacementUtil.ClearSlot(profile.Data.PlotPlacements, slot)
	setEmpty(pedestal)
	tool.Parent = backpack
	Knit.GetService("PlotCashPoolService"):OnPlacementChanged(player, slot)
	Knit.GetService("CarryCapacityService"):RefreshPlayer(player)
	Knit.GetService("PlayerLuckService"):RefreshPlayerLuck(player)
	return result(true, "Picked up")
end

function PlotPedestalService.Client:placeItem(player: Player, slot: number, inventoryId: string)
	return PlotPedestalService:placeItem(player, slot, inventoryId)
end

function PlotPedestalService.Client:pickupItem(player: Player, slot: number)
	return PlotPedestalService:pickupItem(player, slot)
end

function PlotPedestalService:KnitStart()
	local plotSlotService = Knit.GetService("PlotSlotService")
	plotSlotService.SlotAssigned:Connect(function(player: Player)
		self:_restorePlayerPlot(player)
	end)
	plotSlotService.SlotReleased:Connect(function(plot: Instance)
		self:_clearPlot(plot)
	end)

	local function restoreWhenReady(player: Player)
		plotSlotService:EnsurePlayerSlot(player)
		self:_restorePlayerPlot(player)
	end
	PlayerDataService.ProfileLoaded:Connect(restoreWhenReady)
	for _, player in ipairs(Players:GetPlayers()) do
		if PlayerDataService:GetProfile(player) then
			restoreWhenReady(player)
		end
	end
end

return PlotPedestalService

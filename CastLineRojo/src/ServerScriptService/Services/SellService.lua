local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)
local SellShopZone = require(ReplicatedStorage.Modules.SellShopZone)

local SellService = Knit.CreateService({
	Name = "SellService",
	Client = {},
})
local selling = {}

export type SellResult = {
	success: boolean,
	errorMessage: string?,
	earnedCash: number?,
	soldCount: number?,
}

export type QuoteResult = {
	success: boolean,
	errorMessage: string?,
	price: number?,
}

local function getPlacedItemIds(playerData): { [string]: boolean }
	local placed = {}
	if typeof(playerData.PlotPlacements) ~= "table" then
		return placed
	end
	for _, instanceId in pairs(playerData.PlotPlacements) do
		if typeof(instanceId) == "string" then
			placed[instanceId] = true
		end
	end
	return placed
end

local function getRecordPrice(record): number?
	if typeof(record) ~= "table" or typeof(record.ItemId) ~= "string" then
		return nil
	end
	local item = FishInventoryData[record.ItemId]
	if not item then
		return nil
	end

	local weight = tonumber(record.Weight)
	if not weight or weight <= 0 or weight ~= weight or weight == math.huge then
		return nil
	end
	local price =
		ItemStatUtil.CalculatePrice(item, weight, MutationDataUtil.GetPriceRate(record.MutationId))
	if price ~= price or price < 0 or price == math.huge then
		return nil
	end
	record.Price = price
	return math.round(price)
end

local function getHeldItem(player: Player): (Tool?, string?)
	local character = player.Character
	if not character then
		return nil, nil
	end
	for _, child in ipairs(character:GetChildren()) do
		if ItemToolUtil.IsItemTool(child) then
			return child :: Tool, ItemToolUtil.GetInstanceId(child)
		end
	end
	return nil, nil
end

local function destroyItemTools(player: Player, soldIds: { [string]: boolean })
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				local instanceId = ItemToolUtil.GetInstanceId(child)
				if instanceId and soldIds[instanceId] then
					child:Destroy()
				end
			end
		end
	end
end

local function finishSale(player: Player, itemIds: { string }, totalCash: number): SellResult
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your item data isn't available right now." }
	end

	local soldIds, records = {}, {}
	for _, instanceId in ipairs(itemIds) do
		records[instanceId] = profile.Data.Items[instanceId]
		profile.Data.Items[instanceId] = nil
		soldIds[instanceId] = true
	end
	local earnedCash = math.round(totalCash * GamePassEffectUtil.GetSaleMultiplier(profile.Data))
	if not PlayerDataService:AdjustWins(player, earnedCash, false) then
		for id, record in records do
			profile.Data.Items[id] = record
		end
		return { success = false, errorMessage = "Could not complete the sale. Please try again." }
	end
	Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
	destroyItemTools(player, soldIds)
	Knit.GetService("HotbarLayoutService"):RemoveItemDescriptors(player, itemIds)

	return {
		success = true,
		earnedCash = earnedCash,
		soldCount = #itemIds,
	}
end

function SellService:GetSellInventory(player: Player)
	if not SellShopZone.CanSell(player, true) then
		return { success = false, errorMessage = "Visit the sell shop on your plot." }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your fish inventory is still loading." }
	end
	local data = profile.Data
	local placed = getPlacedItemIds(data)
	local multiplier = GamePassEffectUtil.GetSaleMultiplier(data)
	local bestCps = PlotFishIncome.GetBestOwnedBaseCps(data)
	local items, total = {}, 0
	for instanceId, record in data.Items do
		local price = if typeof(instanceId) == "string" and not placed[instanceId] then getRecordPrice(record) else nil
		if price ~= nil then
			local item = FishInventoryData[record.ItemId]
			total += price
			table.insert(items, {
				instanceId = instanceId,
				itemId = record.ItemId,
				weight = record.Weight,
				mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId),
				price = math.round(price * multiplier),
				income = PlotFishIncome.GetCpsPrice(
					item,
					MutationDataUtil.GetEarnCashRate(record.MutationId),
					bestCps,
					record.Weight
				),
			})
		end
	end
	table.sort(items, function(a, b)
		local orderA = FishInventoryData[a.itemId].LayoutOrder or 0
		local orderB = FishInventoryData[b.itemId].LayoutOrder or 0
		return if orderA == orderB then a.instanceId < b.instanceId else orderA < orderB
	end)
	return { success = true, items = items, totalPrice = math.round(total * multiplier) }
end

local function sellSelected(player: Player, instanceIds: unknown, expectedTotal: unknown): SellResult
	if not SellShopZone.CanSell(player, true) then
		return { success = false, errorMessage = "Visit the sell shop on your plot." }
	end
	if
		typeof(instanceIds) ~= "table"
		or typeof(expectedTotal) ~= "number"
		or expectedTotal ~= expectedTotal
		or expectedTotal < 0
		or expectedTotal == math.huge
	then
		return { success = false, errorMessage = "Invalid sale request." }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your fish inventory is still loading." }
	end
	local placed = getPlacedItemIds(profile.Data)
	local seen, ids = {}, {}
	local total, count = 0, 0
	for index, id in pairs(instanceIds) do
		if
			typeof(index) ~= "number"
			or index % 1 ~= 0
			or index < 1
			or typeof(id) ~= "string"
			or seen[id]
			or placed[id]
		then
			return { success = false, errorMessage = "Your fish inventory changed. Please try again." }
		end
		local price = getRecordPrice(profile.Data.Items[id])
		if price == nil then
			return { success = false, errorMessage = "Your fish inventory changed. Please try again." }
		end
		seen[id] = true
		count += 1
		total += price
		table.insert(ids, id)
	end
	if count == 0 or count ~= #instanceIds then
		return { success = false, errorMessage = "You don't have any fish to sell!" }
	end
	-- Reject sparse or dictionary payloads as well as duplicate IDs.
	for index = 1, count do
		if instanceIds[index] == nil then
			return { success = false, errorMessage = "Invalid sale request." }
		end
	end
	if math.round(total * GamePassEffectUtil.GetSaleMultiplier(profile.Data)) ~= expectedTotal then
		return { success = false, errorMessage = "Fish prices changed. Please review the new price." }
	end
	return finishSale(player, ids, total)
end

function SellService:SellItems(player: Player, instanceIds: unknown, expectedTotal: unknown): SellResult
	if selling[player] then
		return { success = false, errorMessage = "A sale is already in progress." }
	end
	selling[player] = true
	local ok, result = pcall(sellSelected, player, instanceIds, expectedTotal)
	selling[player] = nil
	if not ok then
		warn("SellService: sale failed", result)
		return { success = false, errorMessage = "Could not complete the sale. Please try again." }
	end
	return result
end

function SellService:GetHeldItemQuote(player: Player): QuoteResult
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your item data isn't available right now." }
	end
	local _, instanceId = getHeldItem(player)
	if not instanceId then
		return { success = false, errorMessage = "You need to be holding an item first!" }
	end
	local price = getRecordPrice(profile.Data.Items[instanceId])
	if price == nil then
		return { success = false, errorMessage = "I can't price that item right now." }
	end
	return { success = true, price = math.round(price * GamePassEffectUtil.GetSaleMultiplier(profile.Data)) }
end

function SellService:SellHeldItem(player: Player): SellResult
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your item data isn't available right now." }
	end
	local _, instanceId = getHeldItem(player)
	if not instanceId then
		return { success = false, errorMessage = "You need to be holding an item first!" }
	end
	if getPlacedItemIds(profile.Data)[instanceId] then
		return { success = false, errorMessage = "Displayed items can't be sold here." }
	end
	local price = getRecordPrice(profile.Data.Items[instanceId])
	if price == nil then
		return { success = false, errorMessage = "I can't sell that item right now." }
	end
	return self:SellItems(
		player,
		{ instanceId },
		math.round(price * GamePassEffectUtil.GetSaleMultiplier(profile.Data))
	)
end

function SellService:SellAllItems(player: Player): SellResult
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.Items) ~= "table" then
		return { success = false, errorMessage = "Your item data isn't available right now." }
	end

	local placed = getPlacedItemIds(profile.Data)
	local itemIds = {}
	local totalCash = 0
	for instanceId, record in pairs(profile.Data.Items) do
		if typeof(instanceId) == "string" and not placed[instanceId] then
			local price = getRecordPrice(record)
			if price ~= nil then
				table.insert(itemIds, instanceId)
				totalCash += price
			end
		end
	end
	if #itemIds == 0 then
		return { success = false, errorMessage = "You don't have any items to sell!" }
	end
	table.sort(itemIds)
	return self:SellItems(player, itemIds, math.round(totalCash * GamePassEffectUtil.GetSaleMultiplier(profile.Data)))
end

function SellService.Client:GetSellInventory(player: Player)
	return self.Server:GetSellInventory(player)
end

function SellService.Client:RequestSellItems(player: Player, instanceIds: unknown, expectedTotal: unknown): SellResult
	return self.Server:SellItems(player, instanceIds, expectedTotal)
end

function SellService.Client:RequestHeldItemQuote(player: Player): QuoteResult
	return self.Server:GetHeldItemQuote(player)
end

function SellService.Client:RequestSellHeldItem(player: Player): SellResult
	return self.Server:SellHeldItem(player)
end

function SellService.Client:RequestSellAllItems(player: Player): SellResult
	return self.Server:SellAllItems(player)
end

return SellService

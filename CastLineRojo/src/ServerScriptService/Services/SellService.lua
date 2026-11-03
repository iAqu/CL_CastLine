local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local SellService = Knit.CreateService({
	Name = "SellService",
	Client = {},
})

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
	local item = ItemsData[record.ItemId]
	if not item then
		return nil
	end

	local price = tonumber(record.Price)
	if not price then
		local weight = tonumber(record.Weight)
		local conditionId = record.ConditionId
		local condition = typeof(conditionId) == "string" and ConditionsData[conditionId] or nil
		if not weight or weight <= 0 or not condition then
			return nil
		end
		price = ItemStatUtil.CalculatePrice(
			item,
			weight,
			condition.ValueMult,
			MutationDataUtil.GetPriceRate(record.MutationId)
		)
	end
	if price ~= price or price < 0 or price == math.huge then
		return nil
	end
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

	local soldIds = {}
	for _, instanceId in ipairs(itemIds) do
		profile.Data.Items[instanceId] = nil
		soldIds[instanceId] = true
	end
	destroyItemTools(player, soldIds)
	Knit.GetService("HotbarLayoutService"):RemoveItemDescriptors(player, itemIds)
	Knit.GetService("CarryCapacityService"):RefreshPlayer(player)
	local earnedCash = math.round(totalCash * GamePassEffectUtil.GetSaleMultiplier(profile.Data))
	PlayerDataService:AdjustWins(player, earnedCash, false)

	return {
		success = true,
		earnedCash = earnedCash,
		soldCount = #itemIds,
	}
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
	return finishSale(player, { instanceId }, price)
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
	return finishSale(player, itemIds, totalCash)
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

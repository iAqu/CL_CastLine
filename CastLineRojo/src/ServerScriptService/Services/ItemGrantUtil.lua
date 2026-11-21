local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local GlobalLeaderboardConfig = require(ReplicatedStorage.Modules.GlobalLeaderboardConfig)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local ItemGrantUtil = {}

export type GrantOptions = {
	Random: Random?,
	Weight: number?,
	CountTowardTotalWeight: boolean?,
	RecordFishingCatch: boolean?,
	MutationId: string?,
	InstanceId: string?,
	PaidOrigin: string?,
	BeforeCommit: (() -> (boolean, string?))?,
	OnCommitted: (() -> ())?,
}

local function getBackpack(player: Player): Backpack?
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	return if backpack and backpack:IsA("Backpack") then backpack else nil
end

local function getInstanceId(items: { [string]: unknown }): string
	local instanceId = HttpService:GenerateGUID(false)
	while items[instanceId] ~= nil do
		instanceId = HttpService:GenerateGUID(false)
	end
	return instanceId
end

function ItemGrantUtil.GetOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(FishInventoryData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftItem = FishInventoryData[left]
		local rightItem = FishInventoryData[right]
		if leftItem.LayoutOrder ~= rightItem.LayoutOrder then
			return leftItem.LayoutOrder < rightItem.LayoutOrder
		end
		return left < right
	end)
	return itemIds
end

local function itemData(item, weight, mutationId, paidOrigin)
	mutationId = MutationDataUtil.NormalizeMutationId(mutationId)
	return {
		Weight = weight,
		Price = ItemStatUtil.CalculatePrice(item, weight, MutationDataUtil.GetPriceRate(mutationId)),
		MutationId = mutationId,
		PaidOrigin = paidOrigin,
	}
end

function ItemGrantUtil.GrantPaidOrder(player, profile, rewards, orderId, commit)
	local backpack = getBackpack(player)
	if not backpack or not profile:IsActive() or PlayerDataService:GetProfile(player) ~= profile then
		return false, "Backpack or profile is unavailable"
	end
	local items = profile.Data.Items
	if type(items) ~= "table" then
		items = {}
	end
	local batch = {}
	local function discard()
		for _, entry in ipairs(batch) do
			entry.Tool:Destroy()
		end
	end
	for _, reward in ipairs(rewards) do
		local config = FishInventoryData[reward.ItemId]
		if not config or items[reward.InstanceId] then
			discard()
			return false, "Paid fish is unavailable or already exists"
		end
		local record = itemData(config, reward.Weight, reward.MutationId, orderId)
		record.ItemId = reward.ItemId
		local ok, tool = pcall(ItemToolUtil.Create, reward.InstanceId, config, record, player)
		if not ok or not tool then
			discard()
			return false, "Paid fish tool could not be prepared"
		end
		table.insert(batch, { Id = reward.InstanceId, Record = record, Tool = tool })
	end
	if backpack.Parent ~= player or not profile:IsActive() or PlayerDataService:GetProfile(player) ~= profile then
		discard()
		return false, "Backpack or profile changed"
	end
	-- The entire order and its receipt are committed together before tools replicate.
	profile.Data.Items = items
	for _, entry in ipairs(batch) do
		items[entry.Id] = entry.Record
	end
	commit()
	for _, entry in ipairs(batch) do
		entry.Tool.Parent = backpack
	end
	profile.Data.NewItemTagSeenLog = profile.Data.NewItemTagSeenLog or {}
	local index = Knit.GetService("IndexService")
	for _, entry in ipairs(batch) do
		local fishId = entry.Record.ItemId
		profile.Data.NewItemTagSeenLog[fishId] = true
		index:DiscoverItem(player, fishId)
	end
	Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
	return true
end

function ItemGrantUtil.Grant(player: Player, itemId: string, options: GrantOptions?): ({ [string]: unknown }?, string?)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil, "No Profile found for player"
	end

	local item = FishInventoryData[itemId]
	if not item then
		return nil, "Unknown item: " .. tostring(itemId)
	end

	local backpack = getBackpack(player)
	if not backpack then
		return nil, "Backpack is unavailable for player"
	end

	local random = options and options.Random or nil
	local weight = options and tonumber(options.Weight) or nil
	weight = weight or ItemStatUtil.RollWeight(item, random)
	local instanceData = itemData(item, weight, options and options.MutationId, options and options.PaidOrigin)
	local price, mutationId = instanceData.Price, instanceData.MutationId
	local tool = ItemToolUtil.Create("pending", item, instanceData, player)
	if not tool then
		return nil, "Item model is unavailable: " .. tostring(item.Model)
	end
	if backpack.Parent ~= player then
		tool:Destroy()
		return nil, "Backpack is unavailable for player"
	end

	if typeof(profile.Data.Items) ~= "table" then
		profile.Data.Items = {}
	end
	-- Fishing commits its payment, pending result and pity in this same non-yielding section.
	local instanceId = (options and options.InstanceId) or getInstanceId(profile.Data.Items)
	if profile.Data.Items[instanceId] ~= nil then
		tool:Destroy()
		return nil, "Item already granted"
	end
	if PlayerDataService:GetProfile(player) ~= profile then
		tool:Destroy()
		return nil, "Profile changed before item grant"
	end
	if options and options.BeforeCommit then
		local allowed, reason = options.BeforeCommit()
		if not allowed then
			tool:Destroy()
			return nil, reason or "Item grant unavailable"
		end
	end
	tool.Name = "Item_" .. instanceId
	tool:SetAttribute(ItemToolUtil.INSTANCE_ID_ATTRIBUTE, instanceId)
	profile.Data.Items[instanceId] = {
		ItemId = itemId,
		Weight = weight,
		Price = price,
		MutationId = mutationId,
		PaidOrigin = options and options.PaidOrigin,
	}
	if options and options.RecordFishingCatch then
		GlobalLeaderboardConfig.RecordCatch(profile.Data, weight)
	end
	if options and options.OnCommitted then
		options.OnCommitted()
	end
	tool.Parent = backpack
	Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
	if typeof(profile.Data.NewItemTagSeenLog) ~= "table" then
		profile.Data.NewItemTagSeenLog = {}
	end
	local isFirstItemAcquisition = profile.Data.NewItemTagSeenLog[itemId] ~= true
	profile.Data.NewItemTagSeenLog[itemId] = true
	local isNewDiscovery = Knit.GetService("IndexService"):DiscoverItem(player, itemId)
	if options and options.CountTowardTotalWeight then
		PlayerDataService:AdjustTotalItemWeightTenths(player, math.round(weight * 10))
	end

	return {
		Item = item,
		ItemId = itemId,
		InstanceId = instanceId,
		Weight = weight,
		BasePrice = price,
		Price = price,
		IsFirstItemAcquisition = isFirstItemAcquisition,
		IsNewDiscovery = isNewDiscovery,
		MutationId = mutationId,
		PaidOrigin = options and options.PaidOrigin,
	}
end

function ItemGrantUtil.EquipCaughtFish(player: Player, character: Model, instanceId: string)
	if player.Character ~= character or player:GetAttribute("IsTraining") then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local backpack = player:FindFirstChildOfClass("Backpack")
	local tool = backpack and backpack:FindFirstChild("Item_" .. instanceId)
	local profile = PlayerDataService:GetProfile(player)
	if humanoid and humanoid.Health > 0 and tool and tool:IsA("Tool")
		and ItemToolUtil.GetInstanceId(tool) == instanceId
		and profile and profile.Data.Items and profile.Data.Items[instanceId]
	then
		humanoid:EquipTool(tool)
	end
end

return ItemGrantUtil

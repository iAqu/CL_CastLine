local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local REWARD_MULTIPLIER = 0.5

local IndexService = Knit.CreateService({
	Name = "IndexService",
	Client = {
		IndexDiscovered = Knit.CreateSignal(),
		IndexRewardClaimed = Knit.CreateSignal(),
	},
})

local function getValidDiscoveryCount(discoveryLog: unknown): number
	if typeof(discoveryLog) ~= "table" then
		return 0
	end
	local count = 0
	for itemId in pairs(FishInventoryData) do
		if discoveryLog[itemId] == true then
			count += 1
		end
	end
	return count
end

local function getTotalItemCount(): number
	local count = 0
	for _ in pairs(FishInventoryData) do
		count += 1
	end
	return count
end

local TOTAL_ITEM_COUNT = getTotalItemCount()

function IndexService:GetCollectionProgress(player: Player): { CollectedCount: number, TotalCount: number }?
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	local discoveryCount = getValidDiscoveryCount(profile.Data.IndexDiscoveryLog)
	return { CollectedCount = discoveryCount, TotalCount = TOTAL_ITEM_COUNT }
end

function IndexService:DiscoverItem(player: Player, itemId: string): boolean
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not FishInventoryData[itemId] then
		return false
	end
	if typeof(profile.Data.IndexDiscoveryLog) ~= "table" then
		profile.Data.IndexDiscoveryLog = {}
	end
	if profile.Data.IndexDiscoveryLog[itemId] == true then
		return false
	end
	profile.Data.IndexDiscoveryLog[itemId] = true
	self.Client.IndexDiscovered:Fire(player, itemId, self:GetCollectionProgress(player))
	return true
end

function IndexService:GetState(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	return {
		DiscoveryLog = table.clone(profile.Data.IndexDiscoveryLog or {}),
		RewardClaimLog = table.clone(profile.Data.IndexRewardClaimLog or {}),
		CollectionProgress = self:GetCollectionProgress(player),
	}
end

function IndexService:ClaimReward(player: Player, itemId: string)
	local profile = PlayerDataService:GetProfile(player)
	local item = FishInventoryData[itemId]
	if not profile or not item then
		return { IsSuccess = false, ResultText = "Unknown item." }
	end
	if typeof(profile.Data.IndexDiscoveryLog) ~= "table" or profile.Data.IndexDiscoveryLog[itemId] ~= true then
		return { IsSuccess = false, ResultText = "Discover this item first." }
	end
	if typeof(profile.Data.IndexRewardClaimLog) ~= "table" then
		profile.Data.IndexRewardClaimLog = {}
	end
	if profile.Data.IndexRewardClaimLog[itemId] == true then
		return { IsSuccess = false, ResultText = "Reward already claimed." }
	end

	local reward = math.round((tonumber(item.DefaultPrice) or 0) * REWARD_MULTIPLIER)
	profile.Data.IndexRewardClaimLog[itemId] = true
	PlayerDataService:AdjustWins(player, reward, false)
	self.Client.IndexRewardClaimed:Fire(player, itemId, reward)
	return { IsSuccess = true, ResultText = "Claimed $" .. NumberUtil.FormatItemPriceCompact(reward) .. "!", Reward = reward }
end

function IndexService.Client:GetIndexState(player: Player)
	return self.Server:GetState(player)
end

function IndexService.Client:ClaimIndexReward(player: Player, itemId: string)
	return self.Server:ClaimReward(player, itemId)
end

return IndexService

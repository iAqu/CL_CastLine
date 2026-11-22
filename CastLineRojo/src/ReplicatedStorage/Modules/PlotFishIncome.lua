local FishInventoryData = require(script.Parent.FishInventoryData)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local MutationDataUtil = require(script.Parent.MutationDataUtil)
local PlotPlacementUtil = require(script.Parent.PlotPlacementUtil)

local PlotFishIncome = {}

PlotFishIncome.OFFLINE_RATE = 0.5
PlotFishIncome.MAX_OFFLINE_SECONDS = 8 * 60 * 60
PlotFishIncome.BEST_CPS_ATTRIBUTE = "BestOwnedFishBaseCps"
PlotFishIncome.MULTIPLIER_ATTRIBUTE = "PlotFishIncomeMultiplier"
PlotFishIncome.BASE_RATE_ATTRIBUTE = "PlotFishBaseCashPerSecond"

local function finiteNonnegative(value): number?
	local numberValue = tonumber(value)
	return if numberValue and numberValue == numberValue and numberValue >= 0 and numberValue < math.huge
		then numberValue else nil
end

function PlotFishIncome.GetDefaultBaseCps(): number
	return finiteNonnegative(FishInventoryData.Fish_101 and FishInventoryData.Fish_101.CpsPrice) or 1
end

function PlotFishIncome.UsesPercentageCps(rarity: string?): boolean
	return rarity == "Event" or rarity == "Exclusive"
end

function PlotFishIncome.GetBestOwnedBaseCps(data): number
	local best
	for _, record in pairs(data.Items or {}) do
		local item = if typeof(record) == "table" then FishInventoryData[record.ItemId] else nil
		local cps = item and not PlotFishIncome.UsesPercentageCps(item.Rarity) and finiteNonnegative(item.CpsPrice)
		if cps and (not best or cps > best) then
			best = cps
		end
	end
	return best or PlotFishIncome.GetDefaultBaseCps()
end

function PlotFishIncome.GetCpsPrice(itemData, mutationEarnCashRate: number?, bestBaseCps: number?, actualWeight: number?): number
	local cpsPrice = tonumber(itemData and itemData.CpsPrice) or 0
	local mutationRate = math.max(0, tonumber(mutationEarnCashRate) or 1)
	if cpsPrice ~= cpsPrice or cpsPrice == math.huge or cpsPrice == -math.huge then
		return 0
	end
	if mutationRate ~= mutationRate or mutationRate == math.huge then
		mutationRate = 1
	end
	local weightRate = if itemData then ItemStatUtil.GetWeightValueMultiplier(itemData, actualWeight) else 1
	if itemData and PlotFishIncome.UsesPercentageCps(itemData.Rarity) then
		local base = finiteNonnegative(bestBaseCps) or PlotFishIncome.GetDefaultBaseCps()
		return math.max(1, math.floor(base * math.max(0, cpsPrice) * mutationRate * weightRate))
	end
	return math.max(0, math.floor(cpsPrice * mutationRate * weightRate))
end

function PlotFishIncome.ComputeOfflineCash(cpsPrice: number, offlineSeconds: number): number
	local safeRate = math.max(0, tonumber(cpsPrice) or 0)
	local safeSeconds = math.clamp(math.max(0, tonumber(offlineSeconds) or 0), 0, PlotFishIncome.MAX_OFFLINE_SECONDS)
	return math.floor(safeRate * safeSeconds * PlotFishIncome.OFFLINE_RATE)
end

function PlotFishIncome.NormalizeBalance(value: unknown): number
	local numberValue = tonumber(value) or 0
	if numberValue ~= numberValue or numberValue == math.huge or numberValue == -math.huge then
		return 0
	end
	return math.max(0, math.floor(numberValue))
end

function PlotFishIncome.GetMultiplier(data): number
	return if data.GamePasses and data.GamePasses.DoubleWins == true then 2 else 1
end

function PlotFishIncome.GetBaseRate(data): number
	local rate = 0
	local bestBaseCps = PlotFishIncome.GetBestOwnedBaseCps(data)
	local counted = {}
	for slot = 1, PlotPlacementUtil.GetCapacity(data) do
		local uid = PlotPlacementUtil.GetItemUid(data.PlotPlacements, slot)
		local record = uid and data.Items and data.Items[uid]
		if typeof(record) == "table" and not counted[uid] then
			counted[uid] = true
			rate += PlotFishIncome.GetCpsPrice(
				FishInventoryData[record.ItemId],
				MutationDataUtil.GetEarnCashRate(record.MutationId),
				bestBaseCps,
				record.Weight
			)
		end
	end
	return rate
end

function PlotFishIncome.GetRate(data): number
	return PlotFishIncome.GetBaseRate(data) * PlotFishIncome.GetMultiplier(data)
end

function PlotFishIncome.PrepareOffline(data, now: number)
	local lastOnline = tonumber(data.LastOnlineTime) or 0
	local away = if lastOnline > 0 then math.max(0, now - lastOnline) else 0
	local counted = math.min(away, PlotFishIncome.MAX_OFFLINE_SECONDS)
	data.PendingPlotOfflineCash = PlotFishIncome.NormalizeBalance(data.PendingPlotOfflineCash)
		+ PlotFishIncome.ComputeOfflineCash(PlotFishIncome.GetBaseRate(data), counted) * PlotFishIncome.GetMultiplier(data)
	data.LastOnlineTime = now
	return { away = away, counted = counted }
end

return PlotFishIncome

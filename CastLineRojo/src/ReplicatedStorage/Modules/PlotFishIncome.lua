local FishInventoryData = require(script.Parent.FishInventoryData)
local MutationDataUtil = require(script.Parent.MutationDataUtil)
local PlotPlacementUtil = require(script.Parent.PlotPlacementUtil)

local PlotFishIncome = {}

PlotFishIncome.OFFLINE_RATE = 0.5
PlotFishIncome.MAX_OFFLINE_SECONDS = 8 * 60 * 60

function PlotFishIncome.GetCpsPrice(itemData, mutationEarnCashRate: number?): number
	local cpsPrice = tonumber(itemData and itemData.CpsPrice) or 0
	local mutationRate = math.max(0, tonumber(mutationEarnCashRate) or 1)
	if cpsPrice ~= cpsPrice or cpsPrice == math.huge or cpsPrice == -math.huge then
		return 0
	end
	if mutationRate ~= mutationRate or mutationRate == math.huge then
		mutationRate = 1
	end
	return math.max(0, math.floor(cpsPrice * mutationRate))
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

function PlotFishIncome.GetRate(data): number
	local rate = 0
	local counted = {}
	for slot = 1, PlotPlacementUtil.CAPACITY do
		local uid = PlotPlacementUtil.GetItemUid(data.PlotPlacements, slot)
		local record = uid and data.Items and data.Items[uid]
		if typeof(record) == "table" and not counted[uid] then
			counted[uid] = true
			rate += PlotFishIncome.GetCpsPrice(
				FishInventoryData[record.ItemId],
				MutationDataUtil.GetEarnCashRate(record.MutationId)
			)
		end
	end
	return rate
end

function PlotFishIncome.PrepareOffline(data, now: number)
	local lastOnline = tonumber(data.LastOnlineTime) or 0
	local away = if lastOnline > 0 then math.max(0, now - lastOnline) else 0
	local counted = math.min(away, PlotFishIncome.MAX_OFFLINE_SECONDS)
	data.PendingPlotOfflineCash = PlotFishIncome.NormalizeBalance(data.PendingPlotOfflineCash)
		+ PlotFishIncome.ComputeOfflineCash(PlotFishIncome.GetRate(data), counted)
	data.LastOnlineTime = now
	return { away = away, counted = counted }
end

return PlotFishIncome

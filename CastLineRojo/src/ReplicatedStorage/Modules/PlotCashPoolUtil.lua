local PlotCashPoolUtil = {}

PlotCashPoolUtil.PRODUCTION_INTERVAL_SECONDS = 1
PlotCashPoolUtil.OFFLINE_RATE = 0.5
PlotCashPoolUtil.MAX_OFFLINE_SECONDS = 8 * 60 * 60

function PlotCashPoolUtil.GetCpsPrice(itemData, mutationEarnCashRate: number?): number
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

function PlotCashPoolUtil.ComputeOfflineCash(cpsPrice: number, offlineSeconds: number): number
	local safeRate = math.max(0, tonumber(cpsPrice) or 0)
	local safeSeconds = math.clamp(math.max(0, tonumber(offlineSeconds) or 0), 0, PlotCashPoolUtil.MAX_OFFLINE_SECONDS)
	return math.floor(safeRate * safeSeconds * PlotCashPoolUtil.OFFLINE_RATE)
end

function PlotCashPoolUtil.NormalizeBalance(value: unknown): number
	local numberValue = tonumber(value) or 0
	if numberValue ~= numberValue or numberValue == math.huge or numberValue == -math.huge then
		return 0
	end
	return math.max(0, math.floor(numberValue))
end

return PlotCashPoolUtil

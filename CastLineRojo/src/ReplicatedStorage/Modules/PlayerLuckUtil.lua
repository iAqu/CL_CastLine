local ItemStatUtil = require(script.Parent.ItemStatUtil)

local PlayerLuckUtil = {}

local function getNonNegativeNumber(value: unknown): number
	local numberValue = tonumber(value) or 0
	if numberValue ~= numberValue or numberValue <= 0 then
		return 0
	end
	return numberValue
end

local function getPositiveMultiplier(value: unknown): number
	local multiplier = tonumber(value)
	if not multiplier or multiplier ~= multiplier or multiplier <= 0 then
		return 1
	end
	return multiplier
end

function PlayerLuckUtil.GetPlacedItemLuck(playerData, itemsData): number
	if typeof(playerData) ~= "table"
		or typeof(playerData.PlotPlacements) ~= "table"
		or typeof(playerData.Items) ~= "table"
	then
		return 0
	end

	local totalLuck = 0
	local seenItemUids = {}
	for _, itemUid in pairs(playerData.PlotPlacements) do
		if typeof(itemUid) ~= "string" or seenItemUids[itemUid] then
			continue
		end
		seenItemUids[itemUid] = true
		local record = playerData.Items[itemUid]
		local itemId = typeof(record) == "table" and record.ItemId or nil
		local weight = typeof(record) == "table" and tonumber(record.Weight) or nil
		local item = typeof(itemId) == "string" and itemsData[itemId] or nil
		if item and weight and weight > 0 then
			totalLuck += ItemStatUtil.CalculateLuck(item, weight)
		end
	end
	return totalLuck
end

function PlayerLuckUtil.CombineRollLuck(
	placedItemLuck: number?,
	gamePassMultiplier: number?
): number
	local baseLuck = getNonNegativeNumber(placedItemLuck)
	return baseLuck * getPositiveMultiplier(gamePassMultiplier)
end

return PlayerLuckUtil

local PlotPlacementUtil = {}

function PlotPlacementUtil.GetCapacity(data): number
	return require(script.Parent.PlotUpgradeData).GetCapacity(data)
end

local function toSlot(slot)
	local numericSlot = tonumber(slot)
	if not numericSlot or numericSlot ~= numericSlot or numericSlot % 1 ~= 0 then
		return nil
	end
	return numericSlot
end

function PlotPlacementUtil.CoerceNumericKeys(source)
	if typeof(source) ~= "table" then
		return {}
	end

	local result = {}
	for key, value in pairs(source) do
		local slot = toSlot(key)
		if slot then
			result[slot] = value
		end
	end
	return result
end

function PlotPlacementUtil.GetItemUid(placements, slot)
	if typeof(placements) ~= "table" then
		return nil
	end

	local numericSlot = toSlot(slot)
	if not numericSlot then
		return nil
	end

	local itemUid = placements[numericSlot]
	if typeof(itemUid) ~= "string" then
		itemUid = placements[tostring(numericSlot)]
	end
	if typeof(itemUid) == "string" and itemUid ~= "" then
		return itemUid
	end
	return nil
end

function PlotPlacementUtil.SetItemUid(placements, slot, itemUid)
	if typeof(placements) ~= "table" then
		return
	end

	local numericSlot = toSlot(slot)
	if not numericSlot or typeof(itemUid) ~= "string" or itemUid == "" then
		return
	end

	placements[numericSlot] = itemUid
	placements[tostring(numericSlot)] = nil
end

function PlotPlacementUtil.ClearSlot(placements, slot)
	if typeof(placements) ~= "table" then
		return
	end

	local numericSlot = toSlot(slot)
	if not numericSlot then
		return
	end

	placements[numericSlot] = nil
	placements[tostring(numericSlot)] = nil
end

function PlotPlacementUtil.IsPlaced(placements, instanceId)
	if typeof(placements) ~= "table" or typeof(instanceId) ~= "string" then
		return false
	end

	for _, placedUid in pairs(placements) do
		if placedUid == instanceId then
			return true
		end
	end
	return false
end

return PlotPlacementUtil

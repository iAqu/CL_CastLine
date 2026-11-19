local ReplicatedFirst = game:GetService("ReplicatedFirst")
local rows = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("ZonesData"))

local levels = {}
local maxLevel = 0
for _, row in pairs(rows) do
	assert(typeof(row.Level) == "number" and row.Level >= 0 and row.Level % 1 == 0, "Invalid plot upgrade level")
	assert(not levels[row.Level], "Duplicate plot upgrade level")
	assert(typeof(row.Price) == "number" and row.Price >= 0 and row.Price < math.huge, "Invalid plot upgrade price")
	assert(typeof(row.Width) == "number" and row.Width > 0 and row.Width < math.huge, "Invalid plot width")
	assert(typeof(row.Depth) == "number" and row.Depth > 0 and row.Depth < math.huge, "Invalid plot depth")
	assert(typeof(row.Capacity) == "number" and row.Capacity > 0 and row.Capacity % 1 == 0, "Invalid plot capacity")
	levels[row.Level] = row
	maxLevel = math.max(maxLevel, row.Level)
end
for level = 0, maxLevel do
	assert(levels[level], "Missing plot upgrade level")
	if level > 0 then
		assert(
			levels[level].Width >= levels[level - 1].Width and levels[level].Capacity >= levels[level - 1].Capacity,
			"Plot upgrades must not reduce width or capacity"
		)
	end
end

local PlotUpgradeData = { MAX_LEVEL = maxLevel }

function PlotUpgradeData.NormalizeLevel(value): number
	local level = tonumber(value)
	return if level and level == level then math.clamp(math.floor(level), 0, maxLevel) else 0
end

function PlotUpgradeData.Get(level)
	return levels[PlotUpgradeData.NormalizeLevel(level)]
end

function PlotUpgradeData.GetNext(level)
	return levels[PlotUpgradeData.NormalizeLevel(level) + 1]
end

function PlotUpgradeData.GetCapacity(data): number
	return PlotUpgradeData.Get(if typeof(data) == "table" then data.PlotUpgradeLevel else data).Capacity
end

return PlotUpgradeData

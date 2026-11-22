-- Pure training progression and deterministic fish weights; shared by server and tests.
local Progress = {}
local FISH_WEIGHT_PER_STEP = 1.2 ^ 3
local levelIndexByConfig = setmetatable({}, { __mode = "k" })

local function finite(value)
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end

local function getLevelIndex(levels)
	local index = levelIndexByConfig[levels]
	if index then
		return index
	end

	-- Sheet exports can use formatted keys such as "1,000". Index by the row's numeric level.
	local byNumber = {}
	local maximum = 1
	for _, row in pairs(levels) do
		byNumber[row.Level] = row
		maximum = math.max(maximum, row.Level)
	end
	index = { byNumber = byNumber, maximum = maximum }
	levelIndexByConfig[levels] = index
	return index
end

function Progress.GetLevel(levels, level)
	return levels[tostring(level)] or levels[level] or getLevelIndex(levels).byNumber[level]
end

function Progress.GetMaxLevel(levels)
	return getLevelIndex(levels).maximum
end

function Progress.GetEquipment(items)
	local sorted = {}
	for _, row in pairs(items) do
		table.insert(sorted, row)
	end
	table.sort(sorted, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	return sorted
end

function Progress.Ensure(data, items, levels)
	local training = data.Training
	if type(training) ~= "table" then
		training = {}
		data.Training = training
	end
	local maximum = Progress.GetMaxLevel(levels)
	training.Level = if finite(training.Level) then math.clamp(math.floor(training.Level), 1, maximum) else 1
	training.Xp = if finite(training.Xp) then math.max(0, math.floor(training.Xp)) else 0
	if not items[training.TrainingID] then
		training.TrainingID = Progress.GetEquipment(items)[1].TrainingID
	end
	training.ResumeActive = training.ResumeActive == true
	training.LastActiveAt = if finite(training.LastActiveAt) then training.LastActiveAt else 0
	Progress.Advance(training, 0, levels)
	return training
end

function Progress.Advance(training, amount, levels)
	assert(finite(amount) and amount >= 0, "Training experience must be finite and nonnegative")
	local gained = 0
	training.Xp += math.floor(amount)
	local level = Progress.GetLevel(levels, training.Level)
	while level and level.XpToNextLevel > 0 and training.Xp >= level.XpToNextLevel do
		local nextLevel = Progress.GetLevel(levels, training.Level + 1)
		if not nextLevel then
			break
		end
		training.Xp -= level.XpToNextLevel
		training.Level += 1
		gained += 1
		level = nextLevel
	end
	if not level or level.XpToNextLevel <= 0 then
		training.Xp = 0
	end
	return gained
end

function Progress.CanResume(training, now, seconds)
	local elapsed = now - (training.LastActiveAt or 0)
	return training.ResumeActive == true and (training.LastActiveAt or 0) > 0 and elapsed >= 0 and elapsed <= seconds
end

function Progress.GetNextEquipment(items, currentId)
	local current = items[currentId]
	if not current then
		return nil
	end
	for _, row in ipairs(Progress.GetEquipment(items)) do
		if row.LayoutOrder > current.LayoutOrder then
			return row
		end
	end
	return nil
end

function Progress.GetMultiplier(data)
	return if data.GamePasses and data.GamePasses.DoubleTrain == true then 2 else 1
end

function Progress.CalculateFishWeight(baseWeight, maximum)
	assert(finite(baseWeight) and baseWeight > 0, "Fish base weight must be positive and finite")
	assert(finite(maximum) and maximum > 0, "Maximum catch weight must be positive and finite")
	local weight = baseWeight
	local steps = 0
	while true do
		local nextWeight = weight * FISH_WEIGHT_PER_STEP
		if nextWeight > maximum or nextWeight <= weight then
			return weight, steps
		end
		weight = nextWeight
		steps += 1
	end
end

return Progress

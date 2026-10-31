local TARGET_NAME = "Target"
local DEFAULT_SPEED = 3

local colorTable = {
	Color3.fromRGB(255, 0, 4),
	Color3.fromRGB(255, 149, 0),
	Color3.fromRGB(251, 255, 6),
	Color3.fromRGB(28, 255, 26),
	Color3.fromRGB(44, 93, 255),
	Color3.fromRGB(255, 26, 252),
}

local function sortKeypoints(keypoints)
	local sorted = {}

	for _ = 1, #keypoints do
		local candidate = nil
		for _, value in ipairs(keypoints) do
			if table.find(sorted, value) == nil then
				if candidate == nil or value.Time < candidate.Time then
					candidate = value
				end
			end
		end
		table.insert(sorted, candidate)
	end

	sorted[1] = ColorSequenceKeypoint.new(0, sorted[#sorted - 1].Value)
	sorted[#sorted] = ColorSequenceKeypoint.new(1, sorted[2].Value)
	return sorted
end

local function calc(timeNow, index, speed, valueCount)
	return (timeNow + ((speed / valueCount) * index)) % speed / speed
end

local function resolveTargetGradient()
	local targetRef = script:FindFirstChild(TARGET_NAME)
	if not targetRef or not targetRef:IsA("ObjectValue") then
		return nil
	end

	local target = targetRef.Value
	if target and target:IsA("UIGradient") then
		return target
	end

	return nil
end

local targetGradient = resolveTargetGradient()
if not targetGradient then
	warn("GUI_MovingRainbowGradient target is missing or not UIGradient:", script:GetFullName())
	return
end

task.spawn(function()
	while script.Parent and targetGradient.Parent and game:IsAncestorOf(targetGradient) do
		local keypoints = {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}

		local timeNow = tick()
		for i = 1, #colorTable do
			table.insert(keypoints, ColorSequenceKeypoint.new(calc(timeNow, i, DEFAULT_SPEED, #colorTable), colorTable[i]))
		end

		targetGradient.Color = ColorSequence.new(sortKeypoints(keypoints))
		task.wait()
	end
end)

-- Run through Studio MCP execute_luau in #CL_DEV after Rojo sync.
-- Uses unparented test instances and fresh clones of the synced modules;
-- no production script Source or resource templates are modified.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemsData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)

local instances = {}
local function track(instance)
	table.insert(instances, instance)
	return instance
end

local function freshRequire(module)
	return require(track(module:Clone()))
end

local function newSlot()
	local slot = track(Instance.new("TextButton"))
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Parent = slot
	return slot, icon
end

local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)
local checks = 0
local function assertRotation(actual, expected, context)
	-- Comparing basis vectors avoids Euler ambiguity and acos rounding near zero.
	local errorMagnitude = math.max(
		(actual.RightVector - expected.RightVector).Magnitude,
		(actual.UpVector - expected.UpVector).Magnitude,
		(actual.LookVector - expected.LookVector).Magnitude
	)
	assert(errorMagnitude < 0.002, context .. ": orientation error " .. tostring(errorMagnitude))
	checks += 1
end

local missingTemplateId = "__ItemPreviewMissingTemplateTest"
assert(ItemsData[missingTemplateId] == nil, "Test configuration key already exists")

local ok, result = xpcall(function()
	local Index = freshRequire(ReplicatedStorage.Modules.IndexItemViewport)
	local indexRotation = CFrame.Angles(math.rad(-15), math.rad(25), 0) * FRONT_FACING_ROTATION
	local modelNames = {}
	for itemId, config in pairs(ItemsData) do
		if FishingAssets.GetFish(config.Model) then
			table.insert(modelNames, itemId)
		end
	end
	table.sort(modelNames)
	while #modelNames > 7 do
		table.remove(modelNames)
	end
	assert(#modelNames > 0, "No fish models available for orientation checks")
	local orientationSpotChecks = { modelNames[1], modelNames[2], modelNames[3] }

	for _, itemId in ipairs(modelNames) do
		local config = assert(ItemsData[itemId], itemId .. ": missing configuration")
		local template = assert(FishingAssets.GetFish(config.Model), itemId .. ": missing template")
		local sourcePart = template:FindFirstChild("Handle", true) or template:FindFirstChildWhichIsA("BasePart", true)
		assert(sourcePart and sourcePart:IsA("BasePart"), itemId .. ": missing visual part")
		local originalPivot = template:GetPivot()
		local originalPartCFrame = sourcePart.CFrame
		local indexSlot, icon = newSlot()
		assert(Index.Show(indexSlot, icon, config.Model, true), itemId .. ": index render failed")
		local indexModel = indexSlot.IndexModelPreview:FindFirstChildWhichIsA("Model")
		local indexPart = assert(indexModel:FindFirstChild(sourcePart.Name, true), itemId .. ": missing index part")
		assertRotation(indexPart.CFrame, indexRotation * originalPartCFrame.Rotation, itemId .. " index")

		assert(template:GetPivot() == originalPivot and sourcePart.CFrame == originalPartCFrame, "Source asset changed")
	end

	for _, itemId in ipairs(orientationSpotChecks) do
		local config = assert(ItemsData[itemId], itemId .. ": missing configuration")
		local template = assert(FishingAssets.GetFish(config.Model), itemId .. ": missing template")
		local sourcePart = template:FindFirstChild("Handle", true) or template:FindFirstChildWhichIsA("BasePart", true)
		assert(sourcePart and sourcePart:IsA("BasePart"), itemId .. ": missing visual part")
		local originalPivot = template:GetPivot()
		local originalPartCFrame = sourcePart.CFrame
		local previewRotation = FRONT_FACING_ROTATION * originalPartCFrame.Rotation

		local conditionId = "Codition_1"
		local tool = assert(
			ItemToolUtil.Create(
				"__OrientationTest_" .. itemId,
				config,
				{
					Weight = config.DefaultWeight,
					ConditionId = conditionId,
					Price = config.DefaultPrice,
					MutationId = nil,
				}
			),
			itemId .. ": tool create failed"
		)
		track(tool)
		local handle = assert(tool:FindFirstChild("Handle"), itemId .. ": missing tool handle")
		local toolPart = tool:FindFirstChild(sourcePart.Name, true) or handle
		local grip = tool.Grip
		local equippedHandle = CFrame.new() * grip
		local heldPart = equippedHandle * handle.CFrame:ToObjectSpace(toolPart.CFrame)
		assertRotation(
			CFrame.new(heldPart.Position) * heldPart.Rotation,
			CFrame.new(heldPart.Position) * previewRotation,
			itemId .. " held"
		)

		local mountCFrame = CFrame.new(12, 8, -4) * CFrame.Angles(0, math.rad(35), 0)
		local placedModel = track(template:Clone())
		local authoredRotation = placedModel:GetPivot().Rotation
		placedModel:PivotTo(mountCFrame * authoredRotation)
		local placedPart = assert(placedModel:FindFirstChild(sourcePart.Name, true), itemId .. ": missing placed part")
		local localPart = originalPivot:ToObjectSpace(originalPartCFrame)
		assertRotation(placedPart.CFrame, mountCFrame * authoredRotation * localPart, itemId .. " pedestal")
	end

	return { models = #modelNames, orientationChecks = checks, spotChecks = #orientationSpotChecks }
end, debug.traceback)

ItemsData[missingTemplateId] = nil
for i = #instances, 1, -1 do
	instances[i]:Destroy()
end
assert(ok, result)
return result

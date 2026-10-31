-- Run through Studio MCP execute_luau in #SD_DEV after Rojo sync.
-- Uses unparented test instances and fresh clones of the synced modules;
-- no production script Source or resource templates are modified.
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)

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
	local Backpack = freshRequire(ReplicatedStorage.Modules.BackpackItemViewport)
	local indexRotation = CFrame.Angles(math.rad(-15), math.rad(25), 0) * FRONT_FACING_ROTATION
	local backpackRotation = CFrame.Angles(math.rad(15), math.rad(25), 0) * FRONT_FACING_ROTATION
	local movement = CFrame.new(31, 17, -23) * CFrame.Angles(math.rad(31), math.rad(77), math.rad(-19))
	local modelNames = {
		"Duck", "RecycleBin", "LostAngelStatue", "SteampunkJetpack",
		"DaggerOfDimensions", "TeddyTrap", "BloxyCola",
	}
	local orientationSpotChecks = { "Duck", "Bathtub", "DaggerOfDimensions" }

	for _, itemId in ipairs(modelNames) do
		local config = assert(ItemsData[itemId], itemId .. ": missing configuration")
		local template = assert(ReplicatedStorage.Models.Items:FindFirstChild(config.Model), itemId .. ": missing template")
		local sourcePart = template:FindFirstChild("Handle", true) or template:FindFirstChildWhichIsA("BasePart", true)
		assert(sourcePart and sourcePart:IsA("BasePart"), itemId .. ": missing visual part")
		local originalPivot = template:GetPivot()
		local originalPartCFrame = sourcePart.CFrame
		local indexSlot, icon = newSlot()
		assert(Index.Show(indexSlot, icon, config.Model, true), itemId .. ": index render failed")
		local indexModel = indexSlot.IndexModelPreview:FindFirstChildWhichIsA("Model")
		local indexPart = assert(indexModel:FindFirstChild(sourcePart.Name, true), itemId .. ": missing index part")
		assertRotation(indexPart.CFrame, indexRotation * originalPartCFrame.Rotation, itemId .. " index")

		-- Reproduce Create's visual split and PivotOffset contract without inventory side effects.
		local tool = track(Instance.new("Tool"))
		tool:SetAttribute(ItemToolUtil.KIND_ATTRIBUTE, "Item")
		tool:SetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE, itemId)
		local visual = template:Clone()
		local handle = visual:FindFirstChild("Handle", true) or visual:FindFirstChildWhichIsA("BasePart", true)
		handle.Name = "Handle"
		tool:SetAttribute(ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE, handle.CFrame:ToObjectSpace(visual:GetPivot()))
		visual.Parent = tool
		handle.Parent = tool
		local slot = newSlot()

		for pose = 1, 2 do
			if pose == 2 then
				for _, part in ipairs(tool:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CFrame = movement * part.CFrame
					end
				end
			end
			assert(Backpack.Show(slot, tool), itemId .. ": backpack render failed")
			local previewPart = slot.ItemModelPreview.PreviewModel.Handle
			assertRotation(previewPart.CFrame, backpackRotation * originalPartCFrame.Rotation, itemId .. " backpack pose " .. pose)
			assertRotation(backpackRotation:Inverse() * previewPart.CFrame, indexRotation:Inverse() * indexPart.CFrame, itemId .. " UI parity")
		end

		-- Missing/unknown configuration must retain the previous target Pivot.
		tool:SetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE, nil)
		assert(Backpack.Show(slot, tool), itemId .. ": missing ItemId fallback failed")
		assertRotation(slot.ItemModelPreview.PreviewModel:GetPivot(), backpackRotation, itemId .. " missing ItemId")
		tool:SetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE, "__UnknownPreviewItem")
		assert(Backpack.Show(slot, tool), itemId .. ": unknown configuration fallback failed")
		assertRotation(slot.ItemModelPreview.PreviewModel:GetPivot(), backpackRotation, itemId .. " unknown configuration")

		-- Temporary in-memory config; never rename or remove an authored template.
		ItemsData[missingTemplateId] = { Model = "__MissingPreviewTemplate" }
		assert(ReplicatedStorage.Models.Items:FindFirstChild("__MissingPreviewTemplate") == nil, "Fallback test template must not exist")
		tool:SetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE, missingTemplateId)
		assert(Backpack.Show(slot, tool), itemId .. ": missing template fallback failed")
		assertRotation(slot.ItemModelPreview.PreviewModel:GetPivot(), backpackRotation, itemId .. " missing template")
		assert(template:GetPivot() == originalPivot and sourcePart.CFrame == originalPartCFrame, "Source asset changed")
	end

	for _, itemId in ipairs(orientationSpotChecks) do
		local config = assert(ItemsData[itemId], itemId .. ": missing configuration")
		local template = assert(ReplicatedStorage.Models.Items:FindFirstChild(config.Model), itemId .. ": missing template")
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
				{ Weight = config.DefaultWeight, ConditionId = conditionId, Price = config.DefaultPrice, MutationId = nil }
			),
			itemId .. ": tool create failed"
		)
		track(tool)
		local handle = assert(tool:FindFirstChild("Handle"), itemId .. ": missing tool handle")
		local toolPart = tool:FindFirstChild(sourcePart.Name, true) or handle
		local grip = tool.Grip
		local equippedHandle = CFrame.new() * grip
		local heldPart = equippedHandle * handle.CFrame:ToObjectSpace(toolPart.CFrame)
		assertRotation(CFrame.new(heldPart.Position) * heldPart.Rotation, CFrame.new(heldPart.Position) * previewRotation, itemId .. " held")

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

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local BackpackSlotObserver = require(ReplicatedStorage.Modules.BackpackSlotObserver)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local EggToolUtil = require(ReplicatedStorage.Modules.EggToolUtil)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local HOTBAR_SLOT_COUNT = 10
local FIRST_ITEM_SLOT = 1
local LAST_ITEM_SLOT = 10
local SAVE_DELAY = 0.5
local INITIAL_RESTORE_SECONDS = 4
local PLACEHOLDER_ATTRIBUTE = "HotbarLayoutPlaceholder"
local RESTORE_MOVE_ATTRIBUTE = "HotbarLayoutRestoring"

type Descriptor = { Kind: string, Id: string }

local HotbarLayoutController = Knit.CreateController({ Name = "HotbarLayoutController" })

local restoring = false
local restoredForCharacter = false
local saveToken = 0
local initialRestoreDeadline = 0
local restoreQueued = false

local function getBackpack(): Backpack?
	return LOCAL_PLAYER:FindFirstChildOfClass("Backpack") :: Backpack?
end

local function getDescriptor(tool: Instance?): Descriptor?
	if not tool or not tool:IsA("Tool") or tool:GetAttribute(PLACEHOLDER_ATTRIBUTE) == true then return nil end
	if EggToolUtil.IsEggTool(tool) then
		return { Kind = "Egg", Id = EggToolUtil.GetInstanceId(tool) }
	end
	if PotionToolUtil.IsPotionTool(tool) then
		local id = PotionToolUtil.GetPotionId(tool)
		if id then return { Kind = "Potion", Id = id } end
	end
	if ItemToolUtil.IsItemTool(tool) then
		local id = ItemToolUtil.GetInstanceId(tool)
		if id then return { Kind = "Item", Id = id } end
	end
	return nil
end

local function descriptorKey(descriptor: Descriptor): string
	return descriptor.Kind .. "\0" .. descriptor.Id
end

local function getHotbarSlots(): { [number]: TextButton }
	local result: { [number]: TextButton } = {}
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	local backpackGui = playerGui and playerGui:FindFirstChild("BackpackGui")
	local hotbar = backpackGui and backpackGui:FindFirstChild("Hotbar", true)
	if not hotbar then return result end
	for _, descendant in ipairs(hotbar:GetDescendants()) do
		if descendant:IsA("TextButton") and descendant:FindFirstChild("ToolReference") then
			local index = tonumber(descendant.Name)
			if index and index >= FIRST_ITEM_SLOT and index <= LAST_ITEM_SLOT then result[index] = descendant end
		end
	end
	return result
end

local function captureLayout(): { [string]: Descriptor }
	local layout: { [string]: Descriptor } = {}
	for index, slot in pairs(getHotbarSlots()) do
		local reference = slot:FindFirstChild("ToolReference")
		local tool = reference and reference:IsA("ObjectValue") and reference.Value or nil
		local descriptor = getDescriptor(tool)
		if descriptor then layout[tostring(index)] = descriptor end
	end
	return layout
end

local function requestSave()
	if restoring or not restoredForCharacter then return end
	saveToken += 1
	local token = saveToken
	task.delay(SAVE_DELAY, function()
		if token ~= saveToken or restoring or not restoredForCharacter then return end
		Knit.GetService("HotbarLayoutService"):SaveHotbarLayout(captureLayout(), HOTBAR_SLOT_COUNT):catch(function(err)
			warn("HotbarLayoutController: failed to save layout:", err)
		end)
	end)
end

local function gatherPersistentTools(): { Tool }
	local result: { Tool } = {}
	local seen: { [Tool]: boolean } = {}
	for _, container in ipairs({ getBackpack(), LOCAL_PLAYER.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and not seen[child] then
					seen[child] = true
					if getDescriptor(child) then
						table.insert(result, child)
					end
				end
			end
		end
	end
	return result
end

local function makePlaceholder(): Tool
	local tool = Instance.new("Tool")
	tool.Name = "HotbarLayoutPlaceholder"
	tool.CanBeDropped = false
	tool.RequiresHandle = false
	tool:SetAttribute(PLACEHOLDER_ATTRIBUTE, true)
	return tool
end

local function parentForRestore(tool: Tool, parent: Instance?)
	tool:SetAttribute(RESTORE_MOVE_ATTRIBUTE, true)
	tool.Parent = parent
	tool:SetAttribute(RESTORE_MOVE_ATTRIBUTE, nil)
end

local function getNormalizedSavedLayout(savedLayout): { [string]: Descriptor }
	local result: { [string]: Descriptor } = {}
	for slot = FIRST_ITEM_SLOT, LAST_ITEM_SLOT do
		local descriptor = savedLayout[tostring(slot)]
		if typeof(descriptor) == "table" and (descriptor.Kind == "Item" or descriptor.Kind == "Potion" or descriptor.Kind == "Egg")
			and typeof(descriptor.Id) == "string"
		then
			if slot >= FIRST_ITEM_SLOT and slot <= LAST_ITEM_SLOT and not result[tostring(slot)] then
				result[tostring(slot)] = { Kind = descriptor.Kind, Id = descriptor.Id }
			end
		end
	end
	return result
end

local function restoreLayout(force: boolean?)
	if restoring or (restoredForCharacter and not force) then return end
	local backpack = getBackpack()
	if not backpack then return end
	local playerData = Knit.GetController("PlayerDataController"):GetData()
	local savedLayout = playerData and playerData.HotbarLayout
	if typeof(savedLayout) ~= "table" then savedLayout = {} end

	restoring = true
	restoredForCharacter = false
	task.wait()

	local tools = gatherPersistentTools()
	local available: { [string]: { Tool } } = {}
	for _, tool in ipairs(tools) do
		local descriptor = getDescriptor(tool)
		if descriptor then
			local key = descriptorKey(descriptor)
			available[key] = available[key] or {}
			table.insert(available[key], tool)
			parentForRestore(tool, nil)
		end
	end
	task.wait()

	local placeholders: { Tool } = {}
	local normalized = getNormalizedSavedLayout(savedLayout)
	for slot = FIRST_ITEM_SLOT, LAST_ITEM_SLOT do
		local descriptor = normalized[tostring(slot)]
		local queue = descriptor and available[descriptorKey(descriptor)] or nil
		local tool = queue and #queue > 0 and table.remove(queue, 1) or nil
		if tool then
			parentForRestore(tool, backpack)
		else
			local placeholder = makePlaceholder()
			table.insert(placeholders, placeholder)
			placeholder.Parent = backpack
		end
	end
	for _, placeholder in ipairs(placeholders) do placeholder:Destroy() end
	for _, queue in pairs(available) do
		for _, tool in ipairs(queue) do parentForRestore(tool, backpack) end
	end
	task.wait()
	restoring = false
	restoredForCharacter = true
	requestSave()
end

local function scheduleInitialRestore()
	if os.clock() > initialRestoreDeadline then return end
	if restoreQueued then return end
	restoreQueued = true
	task.delay(0.15, function()
		restoreQueued = false
		if os.clock() > initialRestoreDeadline then return end
		if restoring then
			scheduleInitialRestore()
			return
		end
		restoreLayout(true)
	end)
end

function HotbarLayoutController:KnitStart()
	Knit.GetController("PlayerDataController"):GetData()
	initialRestoreDeadline = os.clock() + INITIAL_RESTORE_SECONDS
	task.delay(0.5, restoreLayout)

	LOCAL_PLAYER.CharacterAdded:Connect(function()
		restoredForCharacter = false
		initialRestoreDeadline = os.clock() + INITIAL_RESTORE_SECONDS
		task.delay(0.5, restoreLayout)
	end)

	BackpackSlotObserver.new({
		player = LOCAL_PLAYER,
		playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui"),
		isRelevantTool = function(tool: Tool): boolean return getDescriptor(tool) ~= nil end,
		onSlotToolChanged = requestSave,
		onToolAdded = function(tool)
			if tool:GetAttribute(RESTORE_MOVE_ATTRIBUTE) == true then return end
			scheduleInitialRestore()
			requestSave()
		end,
		onToolRemoved = requestSave,
	})
end

return HotbarLayoutController

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local BackpackSlotObserver = require(ReplicatedStorage.Modules.BackpackSlotObserver)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local LABEL_NAME = "StackCountLabel"
local StackCountController = Knit.CreateController({ Name = "StackCountController" })

local toolsByName: { [string]: Tool } = {}
local toolConnections: { [Tool]: { RBXScriptConnection } } = {}
local slotsByToolName: { [string]: { [TextButton]: boolean } } = {}
local slotToolNames: { [TextButton]: string? } = {}
local dirtyNames: { [string]: boolean } = {}
local refreshScheduled = false

local function getSlotTool(slot: TextButton): Tool?
	local reference = slot:FindFirstChild("ToolReference")
	if reference and reference:IsA("ObjectValue") and reference.Value and reference.Value:IsA("Tool") then
		return reference.Value
	end
	local name = slot:FindFirstChild("ToolName")
	return if name and name:IsA("TextLabel") then toolsByName[name.Text] else nil
end

local function refreshSlot(slot: TextButton)
	local label = slot:FindFirstChild(LABEL_NAME)
	if not label or not label:IsA("TextLabel") then return end
	if slot:GetAttribute("MinimalSlotLabels") then
		label.Text = ""
		label.Visible = false
		return
	end
	local tool = getSlotTool(slot)
	local count = if tool and PotionToolUtil.IsPotionTool(tool) then PotionToolUtil.GetCount(tool) else nil
	label.Text = if count then "x" .. tostring(count) else ""
	label.Visible = count ~= nil
end

local function requestRefresh(name: string)
	dirtyNames[name] = true
	if refreshScheduled then return end
	refreshScheduled = true
	task.defer(function()
		refreshScheduled = false
		local pending = dirtyNames
		dirtyNames = {}
		for toolName in pairs(pending) do
			for slot in pairs(slotsByToolName[toolName] or {}) do
				if slot.Parent then refreshSlot(slot) end
			end
		end
	end)
end

local function unindexSlot(slot: TextButton)
	local name = slotToolNames[slot]
	if name then
		local slots = slotsByToolName[name]
		if slots then
			slots[slot] = nil
			if next(slots) == nil then slotsByToolName[name] = nil end
		end
		slotToolNames[slot] = nil
	end
end

local function indexSlot(slot: TextButton)
	unindexSlot(slot)
	local tool = getSlotTool(slot)
	if not tool or not PotionToolUtil.IsPotionTool(tool) then refreshSlot(slot); return end
	local name = tool.Name
	slotsByToolName[name] = slotsByToolName[name] or {}
	slotsByToolName[name][slot] = true
	slotToolNames[slot] = name
	refreshSlot(slot)
end

local function setToolName(tool: Tool, name: string)
	for oldName, current in pairs(toolsByName) do
		if current == tool and oldName ~= name then toolsByName[oldName] = nil end
	end
	toolsByName[name] = tool
end

local function addTool(tool: Tool)
	local name = tool.Name
	setToolName(tool, name)
	local connections: { RBXScriptConnection } = {}
	toolConnections[tool] = connections
	table.insert(connections, tool:GetPropertyChangedSignal("Name"):Connect(function()
		local oldName = name
		name = tool.Name
		setToolName(tool, name)
		requestRefresh(oldName)
		requestRefresh(name)
	end))
	table.insert(connections, tool:GetAttributeChangedSignal(PotionToolUtil.POTION_COUNT_ATTRIBUTE):Connect(function()
		requestRefresh(tool.Name)
	end))
	requestRefresh(name)
end

local function removeTool(tool: Tool)
	for _, connection in ipairs(toolConnections[tool] or {}) do connection:Disconnect() end
	toolConnections[tool] = nil
	for name, current in pairs(toolsByName) do
		if current == tool then toolsByName[name] = nil; requestRefresh(name) end
	end
end

function StackCountController:KnitStart()
	BackpackSlotObserver.new({
		player = LOCAL_PLAYER,
		playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui"),
		isRelevantTool = PotionToolUtil.IsPotionTool,
		onSlotAdded = indexSlot,
		onSlotTextChanged = indexSlot,
		onSlotToolChanged = indexSlot,
		onSlotRemoving = unindexSlot,
		onToolAdded = addTool,
		onToolRemoved = removeTool,
	})
end

return StackCountController

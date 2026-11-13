local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local BackpackSlotObserver = require(ReplicatedStorage.Modules.BackpackSlotObserver)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local BackpackSlotPresentation = require(ReplicatedStorage.Modules.BackpackSlotPresentation)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)

local LOCAL_PLAYER = Players.LocalPlayer
local BACKPACK_SLOT_CORNER_NAME = "PurseSlotCorner"
local BACKPACK_SLOT_EQUIPPED_STROKE_NAME = "PurseSlotEquippedStroke"
local BACKPACK_SLOT_CORNER_RADIUS = UDim.new(0.1, 0)
local BACKPACK_SLOT_EQUIPPED_STROKE_COLOR = Color3.fromRGB(90, 142, 233)
local BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_DESKTOP = 7
local BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_MOBILE = 3
local BACKPACK_SLOT_MOBILE_SIZE_CUTOFF = 60
local BACKPACK_FONT = Enum.Font.FredokaOne

local playerGui = LOCAL_PLAYER:WaitForChild("PlayerGui")
local trackedToolsByName: { [string]: Tool } = {}
local toolStyleConnections: { [Tool]: { RBXScriptConnection } } = {}
local slotsByTool: { [Tool]: { [TextButton]: boolean } } = {}
local slotTools: { [TextButton]: Tool? } = {}
local dirtySlots: { [TextButton]: boolean } = {}
local slotRefreshScheduled = false
local slotSizeConnections: { [TextButton]: RBXScriptConnection } = {}

local function getEquippedStrokeThickness(slotFrame: TextButton): number
	local size = slotFrame.AbsoluteSize.X
	if size <= 0 then
		size = slotFrame.Size.X.Offset
	end
	return if size > 0 and size < BACKPACK_SLOT_MOBILE_SIZE_CUTOFF
		then BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_MOBILE
		else BACKPACK_SLOT_EQUIPPED_STROKE_THICKNESS_DESKTOP
end

local function setDefaultBackpackEnabled(enabled: boolean)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, enabled)
	end)
end

local function ensureCoreBackpackDisabled()
	if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
		setDefaultBackpackEnabled(false)
	end
end

local function findToolByName(toolName: string): Tool?
	return trackedToolsByName[toolName]
end

local function getSlotTool(slotFrame: TextButton): Tool?
	local reference = slotFrame:FindFirstChild("ToolReference")
	if reference and reference:IsA("ObjectValue") and reference.Value and reference.Value:IsA("Tool") then
		return reference.Value
	end
	local nameLabel = slotFrame:FindFirstChild("ToolName")
	if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text ~= "" then
		return findToolByName(nameLabel.Text)
	end
	return nil
end

local function applyBackpackSlotStyle(slotFrame: TextButton)
	local corner = slotFrame:FindFirstChild(BACKPACK_SLOT_CORNER_NAME)
	if not corner or not corner:IsA("UICorner") then
		if corner then
			corner:Destroy()
		end

		corner = Instance.new("UICorner")
		corner.Name = BACKPACK_SLOT_CORNER_NAME
		corner.Parent = slotFrame
	end
	corner.CornerRadius = BACKPACK_SLOT_CORNER_RADIUS

	local equippedStroke = slotFrame:FindFirstChild(BACKPACK_SLOT_EQUIPPED_STROKE_NAME)
	if not equippedStroke or not equippedStroke:IsA("UIStroke") then
		if equippedStroke then
			equippedStroke:Destroy()
		end

		equippedStroke = Instance.new("UIStroke")
		equippedStroke.Name = BACKPACK_SLOT_EQUIPPED_STROKE_NAME
		equippedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		equippedStroke.LineJoinMode = Enum.LineJoinMode.Round
		equippedStroke.Parent = slotFrame
	end

	local equippedFrame = slotFrame:FindFirstChild("Equipped")
	if equippedFrame then
		equippedStroke.Color = BACKPACK_SLOT_EQUIPPED_STROKE_COLOR
		equippedStroke.Thickness = getEquippedStrokeThickness(slotFrame)
		equippedStroke.Transparency = 0

		for _, child in ipairs(equippedFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Name == "Edge" then
				child.BackgroundTransparency = 1
			end
		end
	else
		equippedStroke.Transparency = 1
	end

	BackpackSlotPresentation.Apply(slotFrame, getSlotTool(slotFrame), LOCAL_PLAYER)
end

local function requestSlotRefresh(slotFrame: TextButton)
	dirtySlots[slotFrame] = true
	if slotRefreshScheduled then
		return
	end
	slotRefreshScheduled = true
	task.defer(function()
		slotRefreshScheduled = false
		local pendingSlots = dirtySlots
		dirtySlots = {}
		for slot in pairs(pendingSlots) do
			if slot.Parent then
				applyBackpackSlotStyle(slot)
			end
		end
	end)
end

local function removeSlotTool(slotFrame: TextButton)
	local tool = slotTools[slotFrame]
	if not tool then
		return
	end
	local slots = slotsByTool[tool]
	if slots then
		slots[slotFrame] = nil
		if next(slots) == nil then
			slotsByTool[tool] = nil
		end
	end
	slotTools[slotFrame] = nil
end

local function updateSlotTool(slotFrame: TextButton)
	if not slotSizeConnections[slotFrame] then
		slotSizeConnections[slotFrame] = slotFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			requestSlotRefresh(slotFrame)
		end)
		slotFrame.Destroying:Once(function()
			local connection = slotSizeConnections[slotFrame]
			if connection then
				connection:Disconnect()
				slotSizeConnections[slotFrame] = nil
			end
		end)
	end
	removeSlotTool(slotFrame)
	local tool = getSlotTool(slotFrame)
	if tool then
		local slots = slotsByTool[tool] or {}
		slotsByTool[tool] = slots
		slots[slotFrame] = true
		slotTools[slotFrame] = tool
	end
	requestSlotRefresh(slotFrame)
end

local function requestToolSlotsRefresh(tool: Tool)
	local slots = slotsByTool[tool]
	if slots then
		for slotFrame in pairs(slots) do
			requestSlotRefresh(slotFrame)
		end
	end
end

LOCAL_PLAYER:GetAttributeChangedSignal(PlotFishIncome.BEST_CPS_ATTRIBUTE):Connect(function()
	for tool in pairs(slotsByTool) do
		requestToolSlotsRefresh(tool)
	end
end)

local function setTrackedToolName(tool: Tool, name: string)
	for previousName, tracked in pairs(trackedToolsByName) do
		if tracked == tool and previousName ~= name then
			trackedToolsByName[previousName] = nil
		end
	end
	trackedToolsByName[name] = tool
end

local function addTool(tool: Tool)
	setTrackedToolName(tool, tool.Name)
	local connections: { RBXScriptConnection } = {}
	toolStyleConnections[tool] = connections
	table.insert(
		connections,
		tool:GetPropertyChangedSignal("Name"):Connect(function()
			setTrackedToolName(tool, tool.Name)
			requestToolSlotsRefresh(tool)
		end)
	)
	for _, attributeName in ipairs({
		ItemToolUtil.ITEM_ID_ATTRIBUTE,
		ItemToolUtil.WEIGHT_ATTRIBUTE,
		ItemToolUtil.MUTATION_ID_ATTRIBUTE,
		ItemToolUtil.KIND_ATTRIBUTE,
	}) do
		table.insert(
			connections,
			tool:GetAttributeChangedSignal(attributeName):Connect(function()
				requestToolSlotsRefresh(tool)
			end)
		)
	end
	table.insert(
		connections,
		tool:GetPropertyChangedSignal("TextureId"):Connect(function()
			requestToolSlotsRefresh(tool)
		end)
	)
	requestToolSlotsRefresh(tool)
end

local function removeTool(tool: Tool)
	local connections = toolStyleConnections[tool]
	if connections then
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		toolStyleConnections[tool] = nil
	end
	local toolName = tool.Name
	if trackedToolsByName[toolName] == tool then
		trackedToolsByName[toolName] = nil
	end
	requestToolSlotsRefresh(tool)
end

local purseMounted = false

local function applyBackpackFont(instance: Instance)
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		instance.Font = BACKPACK_FONT
	end
end

local function applyBackpackFonts(backpackGui: Instance)
	applyBackpackFont(backpackGui)
	for _, descendant in ipairs(backpackGui:GetDescendants()) do
		applyBackpackFont(descendant)
	end
	backpackGui.DescendantAdded:Connect(applyBackpackFont)
end

LOCAL_PLAYER.CharacterAdded:Connect(function()
	if purseMounted then
		task.defer(ensureCoreBackpackDisabled)
	end
end)

task.spawn(function()
	local backpackGui = playerGui:WaitForChild("BackpackGui", 30)
	local mainFrame = backpackGui and backpackGui:WaitForChild("Backpack", 30)
	if not mainFrame then
		warn("PurseBackpack: Purse backpack UI not mounted within 30s, keeping CoreGui backpack")
		return
	end

	applyBackpackFonts(backpackGui)
	purseMounted = true
	for _ = 1, 20 do
		ensureCoreBackpackDisabled()
		task.wait(0.5)
	end
end)

BackpackSlotObserver.new({
	player = LOCAL_PLAYER,
	playerGui = playerGui,
	isRelevantTool = function(tool: Tool): boolean
		return tool:IsA("Tool")
	end,
	onSlotAdded = updateSlotTool,
	onSlotTextChanged = updateSlotTool,
	onSlotToolChanged = updateSlotTool,
	onSlotRemoving = removeSlotTool,
	onToolAdded = addTool,
	onToolRemoved = removeTool,
})

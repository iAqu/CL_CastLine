local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local EventConfig = require(ReplicatedStorage.Modules.EventConfig)
local EventStateUtil = require(ReplicatedStorage.Modules.EventStateUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local UI_UPDATE_INTERVAL = 0.1
local RAINBOW_HUE_SPEED = 0.5

local EventController = Knit.CreateController({
	Name = "EventController",
})

local stateFolder: Folder? = nil
local eventFrame: GuiObject? = nil
local eventNameLabel: TextLabel? = nil
local eventTimeLabel: TextLabel? = nil
local activeMutationId: string? = nil
local originalWaterColors: { [Instance]: Color3 } = {}
local updateElapsed = UI_UPDATE_INTERVAL
local earlyStateStarted = false
local eventFishActive = false

local function formatCountdown(seconds: number): string
	local wholeSeconds = math.max(0, math.ceil(seconds))
	return string.format("%02d:%02d", math.floor(wholeSeconds / 60), wholeSeconds % 60)
end

local function resolveUi()
	if eventFrame and eventFrame.Parent and eventNameLabel and eventNameLabel.Parent and eventTimeLabel and eventTimeLabel.Parent then
		return
	end
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	local homeGui = playerGui and playerGui:FindFirstChild("HomeGui")
	local leftFrame = homeGui and homeGui:FindFirstChild("LeftFrame")
	local frame = leftFrame and leftFrame:FindFirstChild("EventFrame")
	eventFrame = if frame and frame:IsA("GuiObject") then frame else nil
	local nameLabel = eventFrame and eventFrame:FindFirstChild("EventName")
	local timeLabel = eventFrame and eventFrame:FindFirstChild("EventTime")
	eventNameLabel = if nameLabel and nameLabel:IsA("TextLabel") then nameLabel else nil
	eventTimeLabel = if timeLabel and timeLabel:IsA("TextLabel") then timeLabel else nil
end

local function getWater(): Model?
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	return if water and water:IsA("Model") then water else nil
end

local function restoreWaterColors()
	for instance, color in originalWaterColors do
		if instance.Parent then
			if instance:IsA("BasePart") then
				instance.Color = color
			elseif instance:IsA("Decal") then
				instance.Color3 = color
			end
		end
	end
	table.clear(originalWaterColors)
end

local function applyWaterColor(color: Color3)
	local water = getWater()
	if not water then
		return
	end
	for _, descendant in water:GetDescendants() do
		if descendant:IsA("BasePart") then
			if originalWaterColors[descendant] == nil then
				originalWaterColors[descendant] = descendant.Color
			end
			descendant.Color = color
		elseif descendant:IsA("Decal") then
			if originalWaterColors[descendant] == nil then
				originalWaterColors[descendant] = descendant.Color3
			end
			descendant.Color3 = color
		end
	end
end

local function setActiveMutation(mutationId: string?)
	if activeMutationId == mutationId then
		return
	end
	if not mutationId and not eventFishActive then
		restoreWaterColors()
	end
	activeMutationId = mutationId
	if mutationId and mutationId ~= "Rainbow" and not eventFishActive then
		applyWaterColor(MutationDataUtil.GetLabelColor(mutationId))
	end
end

function EventController:SetEventFishActive(active: boolean)
	if eventFishActive == active then
		return
	end
	eventFishActive = active
	if active then
		applyWaterColor(Color3.fromHSV((Workspace:GetServerTimeNow() * RAINBOW_HUE_SPEED) % 1, 1, 1))
	else
		restoreWaterColors()
		if activeMutationId and activeMutationId ~= "Rainbow" then
			applyWaterColor(MutationDataUtil.GetLabelColor(activeMutationId))
		end
	end
end

local function updatePresentation()
	resolveUi()
	local now = Workspace:GetServerTimeNow()
	local event = EventStateUtil.GetActiveEvent(stateFolder, now)
	if event then
		if eventFrame then
			eventFrame.Visible = true
		end
		if eventNameLabel then
			eventNameLabel.Text = event.DisplayName
		end
		local endsAt = stateFolder and stateFolder:GetAttribute(EventConfig.STATE_ATTRIBUTE.ENDS_AT) or nil
		if eventTimeLabel then
			eventTimeLabel.Text = formatCountdown(if typeof(endsAt) == "number" then endsAt - now else 0)
		end
		local eventType = EventStateUtil.NormalizeEventType(event.EventType)
		setActiveMutation(if eventType == "mutation" then MutationDataUtil.NormalizeMutationId(event.MutationId) else nil)
		return
	end

	setActiveMutation(nil)
	if not EventConfig.AUTO_SCHEDULE_ENABLED then
		if eventFrame then
			eventFrame.Visible = false
		end
		return
	end
	if eventFrame then
		eventFrame.Visible = true
	end
	if eventNameLabel then
		eventNameLabel.Text = "Next Event In"
	end
	local nextStartsAt = stateFolder and stateFolder:GetAttribute(EventConfig.STATE_ATTRIBUTE.NEXT_STARTS_AT) or nil
	if eventTimeLabel then
		eventTimeLabel.Text = formatCountdown(if typeof(nextStartsAt) == "number" then nextStartsAt - now else 0)
	end
end

local function bindStateFolder(folder: Folder)
	stateFolder = folder
	folder:GetAttributeChangedSignal(EventConfig.STATE_ATTRIBUTE.REVISION):Connect(updatePresentation)
	updatePresentation()
end

function EventController:BeginEarlyState()
	if earlyStateStarted then
		return
	end
	earlyStateStarted = true
	task.spawn(function()
		resolveUi()
		local folder = ReplicatedStorage:FindFirstChild(EventConfig.STATE_FOLDER_NAME)
			or ReplicatedStorage:WaitForChild(EventConfig.STATE_FOLDER_NAME, 10)
		if folder and folder:IsA("Folder") then
			bindStateFolder(folder)
		else
			warn("EventController: ReplicatedStorage.EventState is missing")
		end
	end)

	RunService.RenderStepped:Connect(function(deltaTime)
		if eventFishActive or activeMutationId == "Rainbow" then
			applyWaterColor(Color3.fromHSV((Workspace:GetServerTimeNow() * RAINBOW_HUE_SPEED) % 1, 1, 1))
		end
		updateElapsed += deltaTime
		if updateElapsed >= UI_UPDATE_INTERVAL then
			updateElapsed = 0
			updatePresentation()
		end
	end)
end

function EventController:KnitStart()
	self:BeginEarlyState()
end

return EventController

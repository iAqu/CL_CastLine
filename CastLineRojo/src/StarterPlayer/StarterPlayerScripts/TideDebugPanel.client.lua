local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)
local TideConfig = require(ReplicatedStorage.Modules.TideConfig)

if not RunService:IsStudio() then
    return
end

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local testGui = playerGui:WaitForChild("TestGui")
local frame = testGui:WaitForChild("Frame")
local highTideButton = frame:WaitForChild("HighTideButton")
local lowTideButton = frame:WaitForChild("LowTideButton")
local pauseTideButton = frame:FindFirstChild("PauseTideButton")
local homeButton = frame:FindFirstChild("HomeButton")
local instantFullTideButton = frame:FindFirstChild("InstantFullTideButton")
local instantLowTideButton = frame:FindFirstChild("InstantLowTideButton")
local toggleButton = testGui:WaitForChild("ToggleButton")
local tideRemote = ReplicatedStorage:WaitForChild("TideDebugRemote")
local eventDebugRemote = ReplicatedStorage:WaitForChild("EventDebugRemote")

local HOME_SPAWN_OFFSET = CFrame.new(0, 4, 0)

local EVENT_BUTTONS = {
	{
		buttonName = "StartEvent_01Button",
		eventId = "Event_01",
	},
	{
		buttonName = "StartEvent_02Button",
		eventId = "Event_02",
	},
	{
		buttonName = "StartEvent_03Button",
		eventId = "Event_03",
	},
	{
		buttonName = "StartEvent_04Button",
		eventId = "Event_04",
	},
	{
		buttonName = "StartEvent_05Button",
		eventId = "Event_05",
	},
}

testGui.Enabled = true

local function setPanelCollapsed(isCollapsed: boolean)
    frame.Visible = not isCollapsed
    toggleButton.Text = isCollapsed and "<" or ">"
end

highTideButton.Activated:Connect(function()
    tideRemote:FireServer("High")
end)

lowTideButton.Activated:Connect(function()
    tideRemote:FireServer("Low")
end)

for _, eventButton in EVENT_BUTTONS do
	local button = frame:FindFirstChild(eventButton.buttonName)
	if button and button:IsA("TextButton") then
		button.Activated:Connect(function()
			eventDebugRemote:FireServer(eventButton.eventId)
		end)
	else
		warn("TideDebugPanel: TestGui.Frame." .. eventButton.buttonName .. " is missing or is not a TextButton")
	end
end

if instantFullTideButton and instantFullTideButton:IsA("TextButton") then
    instantFullTideButton.Activated:Connect(function()
        tideRemote:FireServer("InstantHigh")
    end)
else
    warn("TideDebugPanel: TestGui.Frame.InstantFullTideButton is missing or is not a TextButton")
end

if instantLowTideButton and instantLowTideButton:IsA("TextButton") then
    instantLowTideButton.Activated:Connect(function()
        tideRemote:FireServer("InstantLow")
    end)
else
    warn("TideDebugPanel: TestGui.Frame.InstantLowTideButton is missing or is not a TextButton")
end

if pauseTideButton and pauseTideButton:IsA("TextButton") then
    pauseTideButton.Activated:Connect(function()
        tideRemote:FireServer("TogglePause")
    end)

    local function updatePauseButton()
        local tideState = ReplicatedStorage:FindFirstChild(TideConfig.STATE_FOLDER_NAME)
        local isPaused = tideState and tideState:GetAttribute(TideConfig.STATE_ATTRIBUTE.IS_PAUSED) == true
        pauseTideButton.Text = isPaused and "Resume Tide" or "Pause Tide"
    end

    task.spawn(function()
        local tideState = ReplicatedStorage:WaitForChild(TideConfig.STATE_FOLDER_NAME)
        updatePauseButton()
        tideState:GetAttributeChangedSignal(TideConfig.STATE_ATTRIBUTE.IS_PAUSED):Connect(updatePauseButton)
    end)
else
    warn("TideDebugPanel: TestGui.Frame.PauseTideButton is missing or is not a TextButton")
end

if homeButton and homeButton:IsA("TextButton") then
    homeButton.Activated:Connect(function()
        local spawnLocation = Workspace:FindFirstChild("SpawnLocation")
        if not spawnLocation or not spawnLocation:IsA("BasePart") then
            warn("TideDebugPanel: Workspace.SpawnLocation is missing or is not a BasePart")
            return
        end

        local character = Players.LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not character or not rootPart or not rootPart:IsA("BasePart") then
            warn("TideDebugPanel: local character is not ready for spawn teleport")
            return
        end

        CharacterUtil.TeleportTo(character, spawnLocation.CFrame * HOME_SPAWN_OFFSET)
    end)
else
    warn("TideDebugPanel: TestGui.Frame.HomeButton is missing or is not a TextButton")
end

toggleButton.Activated:Connect(function()
    setPanelCollapsed(frame.Visible)
end)

setPanelCollapsed(false)

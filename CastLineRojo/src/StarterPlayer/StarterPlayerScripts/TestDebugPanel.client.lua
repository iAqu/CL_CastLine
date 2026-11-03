local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)

if not RunService:IsStudio() then
    return
end

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local testGui = playerGui:WaitForChild("TestGui")
local frame = testGui:WaitForChild("Frame")
local homeButton = frame:FindFirstChild("HomeButton")
local toggleButton = testGui:WaitForChild("ToggleButton")
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
}

testGui.Enabled = true

local function setPanelCollapsed(isCollapsed: boolean)
    frame.Visible = not isCollapsed
    toggleButton.Text = isCollapsed and "<" or ">"
end

for _, eventButton in EVENT_BUTTONS do
	local button = frame:FindFirstChild(eventButton.buttonName)
	if button and button:IsA("TextButton") then
		button.Activated:Connect(function()
			eventDebugRemote:FireServer(eventButton.eventId)
		end)
	else
		warn("TestDebugPanel: TestGui.Frame." .. eventButton.buttonName .. " is missing or is not a TextButton")
	end
end

if homeButton and homeButton:IsA("TextButton") then
    homeButton.Activated:Connect(function()
        local spawnLocation = Workspace:FindFirstChild("SpawnLocation")
        if not spawnLocation or not spawnLocation:IsA("BasePart") then
            warn("TestDebugPanel: Workspace.SpawnLocation is missing or is not a BasePart")
            return
        end

        local character = Players.LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not character or not rootPart or not rootPart:IsA("BasePart") then
            warn("TestDebugPanel: local character is not ready for spawn teleport")
            return
        end

        CharacterUtil.TeleportTo(character, spawnLocation.CFrame * HOME_SPAWN_OFFSET)
    end)
else
    warn("TestDebugPanel: TestGui.Frame.HomeButton is missing or is not a TextButton")
end

toggleButton.Activated:Connect(function()
    setPanelCollapsed(frame.Visible)
end)

setPanelCollapsed(false)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local showPanel = RunService:IsStudio() and Workspace:GetAttribute("ShowTestDebugPanel") == true
local HOME_SPAWN_OFFSET = CFrame.new(0, 4, 0)

local function configurePanel(testGui)
    if testGui.Name ~= "TestGui" or not testGui:IsA("ScreenGui") then
        return
    end

    testGui.Enabled = false
    if not showPanel then
        return
    end

    local frame = testGui:FindFirstChild("Frame")
    local toggleButton = testGui:FindFirstChild("ToggleButton")
    if not (frame and frame:IsA("GuiObject") and toggleButton and toggleButton:IsA("TextButton")) then
        warn("TestDebugPanel: TestGui Frame or ToggleButton is missing or has the wrong class")
        return
    end
    local homeButton = frame:FindFirstChild("HomeButton")

    for _, buttonName in { "StartEvent_01Button", "StartEvent_02Button", "StartEvent_03Button" } do
        local button = frame:FindFirstChild(buttonName)
        if button and button:IsA("GuiObject") then
            button.Visible = false
        end
    end

    local function setPanelCollapsed(isCollapsed: boolean)
        frame.Visible = not isCollapsed
        toggleButton.Text = isCollapsed and "<" or ">"
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
    testGui.Enabled = true
end

playerGui.ChildAdded:Connect(configurePanel)
for _, child in playerGui:GetChildren() do
    configurePanel(child)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")

local Signal = require(ReplicatedStorage.Packages.Signal)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local UpdateLogGui = PlayerGUI:WaitForChild("UpdateLogGui")

local SettingsGui = PlayerGUI:WaitForChild("SettingsGui")

local CloseButton = SettingsGui.Frame.CloseButton

local ScrollingFrame = SettingsGui.Frame.ScrollingFrame
local MusicButton = ScrollingFrame.MusicFrame.SwitchButton
local SoundButton = ScrollingFrame.SoundFrame.SwitchButton

-- local TradeButton = ScrollingFrame.TradingFrame.SwitchButton
local GlobalMessageButton = ScrollingFrame.ShowGlobalMessage.SwitchButton
local PerformanceModeFrame = ScrollingFrame:FindFirstChild("PerformanceModeFrame")
local PerformanceModeButton = PerformanceModeFrame and PerformanceModeFrame:FindFirstChild("SwitchButton")
local PERFORMANCE_MODE_ORDER = { "Auto", "Battery", "Quality" }

local UpdLogButton = ScrollingFrame.UpdateLogFrame.UpdLogButton

local CodeFrame = SettingsGui.Frame.CodeFrame
local RedeemButton = CodeFrame.RedeemButton
local CodeTextBox = CodeFrame.CodeTextBox

local Knit = require(ReplicatedStorage.Packages.Knit)

local SettingsGuiController = Knit.CreateController {
    Name = "SettingsGuiController",
    ToggleMusic = Signal.new(),
    ToggleSound = Signal.new(),
}

function SettingsGuiController:UpdateSettingButtons()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    self:SetButtonState(MusicButton, playerData.Settings[Constants.SETTINGS_ID.MUSIC])
    self:SetButtonState(SoundButton, playerData.Settings[Constants.SETTINGS_ID.SOUND])
    self:SetButtonState(GlobalMessageButton, playerData.Settings[Constants.SETTINGS_ID.GLOBAL_MESSAGE])
    self:SetPerformanceModeButtonState(playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE])
    for _, name in ipairs({ "ShowYourPets", "ShowOtherPets" }) do
        local row = ScrollingFrame:FindFirstChild(name)
        local button = row and row:FindFirstChild("SwitchButton")
        if button then self:SetButtonState(button, playerData.Settings[name] ~= false) end
    end
end

function SettingsGuiController:SetButtonState(button: GuiButton, isEnable: boolean)
    local on = button:FindFirstChild("ON")
    local off = button:FindFirstChild("OFF")
    if not on or not off then
        if button:IsA("TextButton") then
            button.Text = if isEnable then "On" else "Off"
            button.BackgroundColor3 = if isEnable then Color3.fromRGB(65, 170, 90) else Color3.fromRGB(100, 100, 100)
        end
        return
    end
    if isEnable then
        -- button.Text = "On"
        -- button.BackgroundColor3 = Constants.COLOR.GREEN
        -- button.UIStroke.Color = Constants.COLOR.GREEN_DARK
        button.OFF.Visible = false
        button.ON.Visible = true
    else
        button.OFF.Visible = true
        button.ON.Visible = false
        -- button.Text = "Off"
        -- button.BackgroundColor3 = Constants.COLOR.RED
        -- button.UIStroke.Color = Constants.COLOR.RED_DARK
    end
end

function SettingsGuiController:SetPerformanceModeButtonState(mode: string?)
    if not PerformanceModeButton then return end

    local modeLabel = PerformanceModeButton:FindFirstChild("ModeLabel")
    if modeLabel and modeLabel:IsA("TextLabel") then
        modeLabel.Text = mode or "Auto"
    end
end

function SettingsGuiController:ChangeSetting(settingId: string)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local isEnable = not playerData.Settings[settingId]
    playerData.Settings[settingId] = isEnable
    Knit.GetService("SettingsService").ChangeSetting:Fire(settingId, isEnable)
    self:UpdateSettingButtons()
end

function SettingsGuiController:CyclePerformanceMode()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local currentMode = playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE]
    local nextMode = PERFORMANCE_MODE_ORDER[1]

    for index, mode in PERFORMANCE_MODE_ORDER do
        if mode == currentMode then
            nextMode = PERFORMANCE_MODE_ORDER[index % #PERFORMANCE_MODE_ORDER + 1]
            break
        end
    end

    playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE] = nextMode
    Knit.GetService("SettingsService").ChangeSetting:Fire(Constants.SETTINGS_ID.PERFORMANCE_MODE, nextMode)
    self:UpdateSettingButtons()
end

function SettingsGuiController:KnitInit()
    LogHelper.Print("SettingsGuiController initialized")
end

function SettingsGuiController:KnitStart()
    LogHelper.Print("SettingsGuiController started")

    local SettingsService = Knit.GetService("SettingsService")
    for _, name in ipairs({ "ShowYourPets", "ShowOtherPets" }) do
        local row = ScrollingFrame:FindFirstChild(name)
        local button = row and row:FindFirstChild("SwitchButton")
        if button and button:IsA("GuiButton") then
            row.Visible = true
            button.Activated:Connect(function() self:ChangeSetting(name) end)
        end
    end

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(SettingsGui)
    end)
    
    MusicButton.Activated:Connect(function()
        self:ChangeSetting(Constants.SETTINGS_ID.MUSIC)
        self.ToggleMusic:Fire()
    end)

    SoundButton.Activated:Connect(function()
        self:ChangeSetting(Constants.SETTINGS_ID.SOUND)
        self.ToggleSound:Fire()
    end)

    GlobalMessageButton.Activated:Connect(function()
        self:ChangeSetting(Constants.SETTINGS_ID.GLOBAL_MESSAGE)
        self:UpdateSettingButtons()
    end)

    if PerformanceModeButton and PerformanceModeButton:IsA("GuiButton") then
        PerformanceModeButton.Activated:Connect(function()
            self:CyclePerformanceMode()
        end)
    end

    UpdLogButton.Activated:Connect(function()
        GuiAnimation.OpenGui(UpdateLogGui)
    end)

    -- TradeButton.Activated:Connect(function()
    --     local playerData = PlayerDataController:GetData()
    --     if not playerData then warn("No player data found!") return end

    --     SettingsService.ChangeSetting:Fire(Constants.SETTINGS_ID.TRADE, not playerData.Settings[Constants.SETTINGS_ID.TRADE])
    --     playerData.Settings[Constants.SETTINGS_ID.TRADE] = not playerData.Settings[Constants.SETTINGS_ID.TRADE]

    --     self:UpdateSettingButtons()
    -- end)

    RedeemButton.Activated:Connect(function()
        local codeId = CodeTextBox.Text
        if codeId == "" then return end
        local CodesService = Knit.GetService("CodesService")
        CodesService:RedeemItem(codeId):andThen(function(result)
            -- LogHelper.Print("result", result)
            if result == nil then warn("result is nil") return end
            if result.isSuccess then
                NotificationClient.SuccessNotify(result.resultText)
            else
                NotificationClient.Notify(result.resultText)
            end
            CodeTextBox.Text = ""
        end)
    end)

    self:UpdateSettingButtons()
end

return SettingsGuiController

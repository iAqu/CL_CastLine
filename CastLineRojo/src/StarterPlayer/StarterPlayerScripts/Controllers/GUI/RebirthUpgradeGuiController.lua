local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Template = require(ReplicatedStorage.PlayerData.Template)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
-- local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local RebirthUpgradesDataHelper = require(ReplicatedFirst.DataHelpers.RebirthUpgradesDataHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local CharacterController = require(StarterPlayer.StarterPlayerScripts.Controllers.CharacterController)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local RebirthUpgradeGui = PlayerGui:WaitForChild("RebirthUpgradeGui")
local CloseButton = RebirthUpgradeGui.Frame.CloseButton

local MainFrame = RebirthUpgradeGui.Frame
local ScrollingFrame = MainFrame.ScrollingFrame
local UpgradeTemplate = ScrollingFrame.Template

local RebirthUpgradeGuiController = Knit.CreateController {
    Name = "RebirthUpgradeGuiController",
}

-- local UpgradeMachineModel = workspace.Areas[Constants.AREA_NAME.Upgrade_Machine_Located_Area].Items.UpgradeMachine
local isClosing = false

-- local PROGRESS_BAR_MAX_X = 0.988
-- local PROGRESS_BAR_Y = 0.867

function RebirthUpgradeGuiController:Init()
    for _, item in pairs(ScrollingFrame:GetChildren()) do
        if item.Name == "Template" then
            item.Visible = false
        end
    end
    self:UpdateStarLabel()
end

function RebirthUpgradeGuiController:OpenGui()
    GuiAnimation.OpenGui(RebirthUpgradeGui)
end

function RebirthUpgradeGuiController:UpdateStarLabel()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    LogHelper.Print("SuperRebirthTokens: " .. playerData.SuperRebirthTokens)
    MainFrame.StarLabel.TextLabel.Text = playerData.SuperRebirthTokens
end

function RebirthUpgradeGuiController:GenerateUpgradeList()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end
    

    for upgradeId, _ in RebirthUpgradesDataHelper.GetAllData() do
        local currentUpgradeLevel = playerData.RebirthUpgrades[upgradeId] or 0
        local upgradeClone = UpgradeTemplate:Clone()
        upgradeClone.Name = upgradeId
        upgradeClone.Visible = true
        upgradeClone.Parent = ScrollingFrame
        upgradeClone.LayoutOrder = RebirthUpgradesDataHelper.GetIndex(upgradeId)
        upgradeClone.IconImage.Image = "rbxassetid://" .. RebirthUpgradesDataHelper.GetIconId(upgradeId)
        upgradeClone.NameLabel.Text = RebirthUpgradesDataHelper.GetDisplayName(upgradeId)
        upgradeClone.UpgradeButton.TextLabel.Text = RebirthUpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
        ButtonAnimation.SetUp(upgradeClone.UpgradeButton)
        upgradeClone.UpgradeButton.Activated:Connect(function()
            -- if playerData.Upgrades[upgradeId] >= UpgradesDataHelper.GetMaxLevel(upgradeId) then
            --     NotificationClient.SendNotification("Max level reached")
            --     return
            -- end
            -- if playerData.Diamonds < UpgradesDataHelper.GetPrice(upgradeId, playerData.Upgrades[upgradeId] + 1) then
            --     NotificationClient.RedNotify(Constants.NOTIFICATION_NO_ENOUGH_DIAMOND)
            --     return
            -- end
            -- Knit.GetService("UpgradeService").Upgrade:Fire(upgradeId)
            Knit.GetService("RebirthService"):SuperRebirthUpgrade(upgradeId):andThen(function(isSuccess, message)
                if isSuccess then
                    self:UpdateUpgradeItem(upgradeId)
                    NotificationClient.GreenNotify(message)
                else
                    NotificationClient.RedNotify(message)
                end
            end)
        end)

        self:UpdateUpgradeItem(upgradeId)
    end
end

function RebirthUpgradeGuiController:UpdateUpgradeItem(upgradeId: number)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local upgradeItem = ScrollingFrame:FindFirstChild(upgradeId)
    if not upgradeItem then warn("Upgrade item not found: " .. upgradeId) return end

    local currentUpgradeLevel = playerData.RebirthUpgrades[upgradeId] or 0

    if upgradeId == Constants.SUPER_REBIRTH_UPGRADE_ID.DIAMONDS then
        upgradeItem.CountFrame.Visible = false
        upgradeItem.UnlimitedTextLabel.Visible = true
    else
        upgradeItem.CountFrame.Visible = true
        upgradeItem.UnlimitedTextLabel.Visible = false
        for i = 1, 5 do
            if i > RebirthUpgradesDataHelper.GetMaxLevel(upgradeId) then 
                upgradeItem.CountFrame[i].Visible = false
            else
                upgradeItem.CountFrame[i].Visible = true
                if i <= currentUpgradeLevel then
                    upgradeItem.CountFrame[i].BackgroundColor3 = Color3.fromRGB(59, 176, 251)
                else
                    upgradeItem.CountFrame[i].BackgroundColor3 = Color3.fromRGB(211, 211, 211)
                end
            end
        end
    end

    -- local currentUpgradeLevel = playerData.Upgrades[upgradeId]
    -- upgradeItem.BoostLabel.Text = "+ " .. UpgradesDataHelper.GetPercentBoost(upgradeId, currentUpgradeLevel + 1) .. "%"
    -- upgradeItem.PriceLabel.Text = UpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
    -- if currentUpgradeLevel >= UpgradesDataHelper.GetMaxLevel(upgradeId) then
    --     upgradeItem.UpgradeButton.Visible = false
        
    --     upgradeItem.BoostLabel.Visible = false
    --     upgradeItem.DiamondImage.Visible = false
    --     upgradeItem.PriceLabel.Visible = false
    --     upgradeItem.MaxLabel.Visible = true
    -- else
    --     upgradeItem.UpgradeButton.Visible = true
    --     upgradeItem.MaxLabel.Visible = false
    -- end

    -- local maxLevel = UpgradesDataHelper.GetMaxLevel(upgradeId)
    -- local percent = if currentUpgradeLevel >= maxLevel then PROGRESS_BAR_MAX_X else currentUpgradeLevel / maxLevel * PROGRESS_BAR_MAX_X
    -- upgradeItem.ProgressFrame.ProgressBar.Size = UDim2.new(percent, 0, PROGRESS_BAR_Y, 0)
    -- upgradeItem.ProgressFrame.ProgressLabel.Text = currentUpgradeLevel .. "/" .. maxLevel
end

function RebirthUpgradeGuiController:UpdatePrice(upgradeId: string)
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local upgradeItem = ScrollingFrame:FindFirstChild(upgradeId)
    if not upgradeItem then warn("Upgrade item not found: " .. upgradeId) return end

    local currentUpgradeLevel = playerData.RebirthUpgrades[upgradeId] or 0
    upgradeItem.UpgradeButton.TextLabel.Text = RebirthUpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
end

function RebirthUpgradeGuiController:KnitInit()
    local PlayerDataService = Knit.GetService("PlayerDataService")
    PlayerDataService.SuperRebirthTokensChanged:Connect(function()
        task.delay(0, function()
            self:UpdateStarLabel()
        end)
    end)

    PlayerDataService.RebirthUpgradeChanged:Connect(function(upgradeId: string, newLevel: number)
        task.delay(0, function()
            self:UpdatePrice(upgradeId)
        end)
    end)
end

function RebirthUpgradeGuiController:KnitStart()

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(RebirthUpgradeGui)
    end)

    -- local UpgradeService = Knit.GetService("UpgradeService")
    -- UpgradeService.Upgrade:Connect(function(upgreadeId: string, isSuccess: boolean, message: string)
    --     task.delay(0, function()
    --         if isSuccess then
    --             self:UpdateUpgradeItem(upgreadeId)

    --             if upgreadeId == Constants.UPGRADE_ID.MOVE_SPEED then
    --                 CharacterController:UpdateMoveSpeed()
    --             end
    --         else
    --             NotificationClient.RedNotify(message)
    --         end
    --     end)
    -- end)
    
    self:Init()
    self:GenerateUpgradeList()
    GuiUtil.AutoResizeScrollingFrame(RebirthUpgradeGui)
end

return RebirthUpgradeGuiController

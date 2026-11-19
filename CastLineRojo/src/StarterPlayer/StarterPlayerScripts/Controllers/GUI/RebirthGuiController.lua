local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")

local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)

local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local RebirthDataHelper = require(ReplicatedFirst.DataHelpers.RebirthDataHelper)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local RebirthGui = PlayerGUI:WaitForChild("RebirthGui")
local RebirthFrame = RebirthGui:WaitForChild("Frame")
local TitleLabel = RebirthFrame:WaitForChild("TitleLabel")
local CloseButton = RebirthFrame:WaitForChild("CloseButton")

local MaxHintFrame = RebirthFrame:WaitForChild("MaxHintFrame")
local RewardsFrame = RebirthFrame:WaitForChild("RewardsFrame")
local ButtonsFrame = RebirthFrame:WaitForChild("ButtonsFrame")
local ProgressFrame = RebirthFrame:WaitForChild("ProgressFrame")

-- local RebirthCurrentLabel = RewardsFrame.RebirthFrame:WaitForChild("RebirthCurrentLabel")
-- local RebirthNextLabel = RewardsFrame.RebirthFrame:WaitForChild("RebirthNextLabel")
-- local WinsCurrentLabel = RewardsFrame.WinsFrame:WaitForChild("WinsCurrentLabel")
-- local WinsNextLabel = RewardsFrame.WinsFrame:WaitForChild("WinsNextLabel")
-- local BoostCurrentLabel = RewardsFrame.BoostFrame:WaitForChild("BoostCurrentLabel")
-- local BoostNextLabel = RewardsFrame.BoostFrame:WaitForChild("BoostNextLabel")

local ProgressBar = ProgressFrame:WaitForChild("Frame"):WaitForChild("ProgressBar")
local ProgressLabel = ProgressFrame:WaitForChild("Frame"):WaitForChild("ProgressLabel")

local RebirthButton = ButtonsFrame:WaitForChild("RebirthButton")
local SkipButton_Robux = ButtonsFrame:WaitForChild("SkipButton_Robux")
local AutoRebirthButton = ButtonsFrame.AutoRebirthButton

local Knit = require(ReplicatedStorage.Packages.Knit)

local PROGRESS_BAR_MAX_X = 0.987
local PROGRESS_BAR_Y = 0.867

local RebirthGuiController = Knit.CreateController {
    Name = "RebirthGuiController",
    -- _CurrentRebirth = nil,
    -- _CurrentWins = nil,
}

function RebirthGuiController:Init()
    MaxHintFrame.Visible = false
    RewardsFrame.Visible = true
    ProgressFrame.Visible = true
    ButtonsFrame.Visible = true

    -- self:UpdateRebirthPrice()
    self:UpdateAutoRebirthButton()
    self:UpdateRebirthNotif()
    self:UpdateSuperRebirthButton()
end

-- function RebirthGuiController:UpdateRebirthPrice()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then return end

--     if not playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME] then
--         SkipButton_Robux.PriceLabel.Text = PurchaseDataHelper.GetPrice(Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME)
--     else
--         SkipButton_Robux.PriceLabel.Text = PurchaseDataHelper.GetPrice(Constants.PURCHASE_ID.SKIP_REBIRTH)
--     end
-- end

function RebirthGuiController:UpdateSuperRebirthButton()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    -- local rebirthRequired = GameDataUtil.CalculateSuperRebirtRequired(playerData.SuperRebirths + 1)
    -- if rebirthRequired and playerData.Rebirths >= rebirthRequired then
    --     SuperRebirthButton.Normal.Visible = true
    --     SuperRebirthButton.Disabled.Visible = false
    -- else
    --     SuperRebirthButton.Normal.Visible = false
    --     SuperRebirthButton.Disabled.Visible = true
    -- end
end

function RebirthGuiController:CheckMaxRebirth(): boolean
    if not RebirthDataHelper.GetRebirthData(PlayerDataController:GetData().Rebirths + 1) then
        MaxHintFrame.Visible = true
        RewardsFrame.Visible = false
        ProgressFrame.Visible = false
        ButtonsFrame.Visible = false
        return true
    end
    return false
end

function RebirthGuiController:UpdateProgress()
    -- if not self._CurrentRebirth then return end
    -- if not self._CurrentWins then return end

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local nextRebirthCost = RebirthDataHelper.GetRebirthCost(playerData.Rebirths + 1)
    
    -- ProgressLabel.Text = NumberUtil.FormatNumberStartMWithDecimal(self._CurrentWins, 2) .. " / " .. NumberUtil.FormatNumberStartMWithDecimal(nextRebirthCost, 2)
    ProgressLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(playerData.Strength) .. " / " .. NumberUtil.FormatNumberStartKWithDecimal(nextRebirthCost)

    -- local percent = if self._CurrentWins >= nextRebirthCost then PROGRESS_BAR_MAX_X else self._CurrentWins / nextRebirthCost * PROGRESS_BAR_MAX_X
    local percent = if playerData.Strength >= nextRebirthCost then PROGRESS_BAR_MAX_X else playerData.Strength / nextRebirthCost * PROGRESS_BAR_MAX_X
    ProgressBar.Size = UDim2.new(percent, 0, PROGRESS_BAR_Y, 0)
end

-- function RebirthGuiController:UpdateRebirth(currentRebirth: number)
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("No player data found!") return end

--     -- RebirthCurrentLabel.Text = playerData.Rebirths
--     -- RebirthNextLabel.Text = playerData.Rebirths + 1

--     -- local superRebirthBoost = GameDataUtil.CalculateSuperRebirthBaseBoost(PlayerDataController:GetData().SuperRebirths)
--     -- BoostCurrentLabel.Text = math.floor(RebirthDataHelper.GetRebirthBoost(currentRebirth) + superRebirthBoost*100) .. "%"
--     -- BoostNextLabel.Text = math.floor(RebirthDataHelper.GetRebirthBoost(currentRebirth + 1) + superRebirthBoost*100) .. "%"
-- end

local function updateRebirthRewards()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!"); return end

    local currentRebirth = playerData.Rebirths
    if currentRebirth >= RebirthDataHelper.GetMaxRebirthCount() then
        return
    end

    local nextRebirth = currentRebirth + 1

    -- 体型（BodySize）系统已删除，隐藏对应奖励展示
    local content1 = RewardsFrame:FindFirstChild("Content_1")
    if content1 then
        content1.Visible = false
    end

    local currentBoost = math.round(RebirthDataHelper.GetRebirthBoost(currentRebirth)/100 + 1)
    local nextBoost = math.round(RebirthDataHelper.GetRebirthBoost(nextRebirth)/100 + 1)
    RewardsFrame.Content_2.BoostFrame.InfoLabel.Text = "Train:  x" .. currentBoost .. "  >>  x" .. nextBoost
end

-- function RebirthGuiController:UpdateWins(currentWins: number)
--     if not currentWins then return end
--     self._CurrentWins = currentWins

--     WinsCurrentLabel.Text = NumberUtil.FormatNumberStartMWithDecimal(currentWins, 2)
--     if currentWins >= RebirthDataHelper.GetRebirthCost(self._CurrentRebirth + 1) then
--         WinsNextLabel.Text = NumberUtil.FormatNumberStartMWithDecimal(currentWins - RebirthDataHelper.GetRebirthCost(self._CurrentRebirth + 1), 2)
--     else
--         WinsNextLabel.Text = 0
--     end
-- end

function RebirthGuiController:ChangeAutoRebirthState()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    local autoRebirth = not playerData.Settings[Constants.SETTINGS_ID.AUTO_REBIRTH]
    playerData.Settings[Constants.SETTINGS_ID.AUTO_REBIRTH] = autoRebirth
    Knit.GetService("SettingsService").ChangeSetting:Fire(Constants.SETTINGS_ID.AUTO_REBIRTH, autoRebirth)

    self:UpdateAutoRebirthButton()
end

function RebirthGuiController:UpdateAutoRebirthButton()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    if playerData.Settings[Constants.SETTINGS_ID.AUTO_REBIRTH] then
        -- AutoRebirthButton.Text = "AUTO REBIRTH: ON"
        -- AutoRebirthButton.BackgroundColor3 = Constants.COLOR.GREEN
        -- AutoRebirthButton.TextStroke.Color = Constants.COLOR.GREEN_DARK
        -- AutoRebirthButton.ButtonStroke.Color = Constants.COLOR.GREEN_DARK
        AutoRebirthButton.ON.Visible = true
        AutoRebirthButton.OFF.Visible = false
    else
        -- AutoRebirthButton.Text = "AUTO REBIRTH: OFF"
        -- AutoRebirthButton.BackgroundColor3 = Constants.COLOR.RED
        -- AutoRebirthButton.TextStroke.Color = Constants.COLOR.RED_DARK
        -- AutoRebirthButton.ButtonStroke.Color = Constants.COLOR.RED_DARK
        AutoRebirthButton.ON.Visible = false
        AutoRebirthButton.OFF.Visible = true
    end
end

function RebirthGuiController:UpdateRebirthNotif()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local rebirthCost = RebirthDataHelper.GetRebirthCost(playerData.Rebirths + 1)
    -- LogHelper.Print("rebirthCost: " , rebirthCost)
    if rebirthCost then
        -- if playerData.Wins >= rebirthCost then
        if playerData.Strength >= rebirthCost then
            Knit.GetController("HomeGuiController"):ShowRebirthNotif(true)
        else
            Knit.GetController("HomeGuiController"):ShowRebirthNotif(false)
        end
    else
        Knit.GetController("HomeGuiController"):ShowRebirthNotif(false)
    end
end

local function updateTitle()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local maxRebirth = RebirthDataHelper.GetMaxRebirthCount()
    if playerData.Rebirths < maxRebirth then
        TitleLabel.Text = "Rebirth " .. playerData.Rebirths + 1
    else
        TitleLabel.Text = "Max Rebirth"
    end
end

function RebirthGuiController:KnitInit()
    LogHelper.Print("RebirthGuiController initialized")
end

function RebirthGuiController:KnitStart()
    LogHelper.Print("RebirthGuiController started")

    local RebirthService = Knit.GetService("RebirthService")
    local PlayerDataService = Knit.GetService("PlayerDataService")

    PlayerDataService.StrengthChanged:Connect(function(result)
        if not self:CheckMaxRebirth() then
            self:UpdateProgress()
            
            local playerData = PlayerDataController:GetData()
            if not playerData then return end

            if playerData.GamePasses[Constants.GAMEPASS.AUTO_REBIRTH] and playerData.Settings[Constants.SETTINGS_ID.AUTO_REBIRTH] then
                if result >= RebirthDataHelper.GetRebirthCost(playerData.Rebirths + 1) then
                RebirthService:Rebirth():andThen(function(resultText)
                        NotificationClient.WhiteNotify(resultText)
                    end)
                end
            end
        end
        self:UpdateRebirthNotif()
    end)

    PlayerDataService.RebirthsChanged:Connect(function(result)
        LogHelper.Print("RebirthsChanged: ", result)
        if not self:CheckMaxRebirth() then
            -- self:UpdateWins(result)
            -- self:UpdateRebirth(result)
            updateRebirthRewards()
            self:UpdateProgress()
            updateTitle()
            -- self:UpdateSuperRebirthButton()
            LogHelper.Print("RebirthsChanged: ", result)

            local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            if not localCharacter then warn("No localCharacter"); return end
            if not localCharacter:FindFirstChild("HumanoidRootPart") then warn("No HumanoidRootPart"); return end

            SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER)
            GuiAnimationUtil.RibbonParticle()
        end

        self:UpdateRebirthNotif()
    end)
    
    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(RebirthGui)
    end)
    
    RebirthButton.Activated:Connect(function()
        if not GuiHelper.CanWorkInFight() then return end
        RebirthService:Rebirth():andThen(function(result)
            NotificationClient.WhiteNotify(result)
        end)
    end)

    SkipButton_Robux.Activated:Connect(function()
        local playerData = PlayerDataController:GetData()
        if not playerData then return end

        if not playerData.LimitedPurchaseHistory[Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME] then
            MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME))
        else
            MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.PURCHASE_ID.SKIP_REBIRTH))
        end
    end)

    -- SuperRebirthButton.Activated:Connect(function()
    --     if not GuiHelper.CanWorkInFight() then return end
    --     local playerData = PlayerDataController:GetData()
    --     local rebirthRequired = GameDataUtil.CalculateSuperRebirtRequired(playerData.SuperRebirths + 1)
    --     if not rebirthRequired then return end

    --     if playerData.Rebirths >= rebirthRequired then
    --         Knit.GetController("SuperRebirthGuiController"):OpenGui()
    --     elsehome
    --         NotificationClient.RedNotify("You need " .. rebirthRequired .. " rebirths to Super Rebirth!")
    --     end
    -- end)

    AutoRebirthButton.Activated:Connect(function()
        local playerData = PlayerDataController:GetData()
        if not playerData then return end

        if PlayerDataController:GetData().GamePasses[Constants.GAMEPASS.AUTO_REBIRTH] then
            if not GuiHelper.CanWorkInFight() then return end
            self:ChangeAutoRebirthState()
        else
            MarketplaceService:PromptGamePassPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.GAMEPASS.AUTO_REBIRTH))
        end
    end)

    Knit.GetService("PurchaseService").PurchaseLimitSuccess:Connect(function(purchaseId: string)
        task.delay(0, function()
            if purchaseId == Constants.PURCHASE_ID.SKIP_REBIRTH_FIRST_TIME then
                self:UpdateRebirthPrice()
            end
        end)
    end)

    -- init
    self:Init()
    
    if not self:CheckMaxRebirth() then
        -- self:UpdateRebirth(PlayerDataController:GetData().Rebirths)
        updateRebirthRewards()
        -- self:UpdateWins(PlayerDataController:GetData().Wins)
        self:UpdateProgress()
    end


    updateTitle()
end

return RebirthGuiController

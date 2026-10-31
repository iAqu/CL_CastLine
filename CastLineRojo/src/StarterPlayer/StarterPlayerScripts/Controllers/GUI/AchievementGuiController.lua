local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local AchievementsDataHelper = require(ReplicatedFirst.DataHelpers.AchievementsDataHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)
local HoverGuiClient = require(ReplicatedStorage.Modules.HoverGuiClient)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local HomeGui = localPlayer:WaitForChild("PlayerGui"):WaitForChild("HomeGui")

local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local AchievementGui = PlayerGUI:WaitForChild("AchievementGui")
local MainFrame = AchievementGui.Frame
local CloseButton = MainFrame.CloseButton
local AchievementsFrame = MainFrame.AchievementsFrame
local AchievementTemplate = AchievementsFrame.Template
local DetailsFrame = AchievementGui.DetailsFrame

local BottomFrame = MainFrame.BottomFrame

-- local claimButtonConnection = nil
local readyForClaimAchievements = {}    -- {achievementId: true}
-- local isReadyToClaim = false

local PROGRESS_BAR_MAX_X = 1
local PROGRESS_BAR_Y = 1
-- local DETAILS_PROGRESS_BAR_Y = 0.867

local AchievementGuiController = Knit.CreateController {
    Name = "AchievementGuiController",
}

function AchievementGuiController:InitGui()
    for _, template in pairs(AchievementsFrame:GetChildren()) do
        if template:IsA("Frame") then
            template.Visible = false
        end
    end
    DetailsFrame.Visible = false
end

function AchievementGuiController:OpenGui()
    GuiAnimation.OpenGui(AchievementGui)
end

function AchievementGuiController:CloseGui()
    GuiAnimation.CloseGui(AchievementGui)
end

function AchievementGuiController:IsOpen(): boolean
    return AchievementGui.Enabled
end

function AchievementGuiController:UpdateHomeNotif()
    local readyCount = 0
    for _, _ in pairs(readyForClaimAchievements) do
        readyCount = readyCount + 1
    end
    Knit.GetController("HomeGuiController"):ShowAchievementNotif(readyCount > 0)
end

local function claimAchievementReward(achievementId: string)
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then warn("PlayerData not found") return end

    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    local progressValue = AchievementsDataHelper.GetProgressValueByType(playerData, achievementType)
    local requirementValue = AchievementsDataHelper.GetRequirementValue(achievementId)

    local currentRank = playerData.AchievementRanks[achievementType] or 0
    local isMaxRank = currentRank >= AchievementsDataHelper.GetAchievementMaxRank(achievementType)
    if progressValue >= requirementValue and not isMaxRank then
        Knit.GetService("AchievementService").ClaimAchievementEvent:Fire(achievementId)
    end
end

local function generateAchievement(achievementType: string)
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then warn("PlayerData not found") return end

    local currentAchievementRank = playerData.AchievementRanks[achievementType] or 0

    local nextAchievementRank = 0
    if currentAchievementRank < AchievementsDataHelper.GetAchievementMaxRank(achievementType) then
        nextAchievementRank = currentAchievementRank + 1
    else
        nextAchievementRank = currentAchievementRank
    end

    LogHelper.Print("AchievementGuiController:generateAchievement", achievementType, nextAchievementRank)

    -- if nextAchievementRank == 0 then  -- TODO max rank

    -- else
        local nextAchievementId = AchievementsDataHelper.GetAchievementIdByRank(achievementType, nextAchievementRank)
        local achievementFrame = AchievementTemplate:Clone()
        achievementFrame.Name = nextAchievementId
        achievementFrame.Visible = true
        achievementFrame.Parent = AchievementsFrame
        achievementFrame.LayoutOrder = AchievementsDataHelper.GetLayoutOrder(nextAchievementId)
        achievementFrame.AchievementButton.AchieveImage.Image = "rbxassetid://" .. AchievementsDataHelper.GetImageId(nextAchievementId)
        achievementFrame.AchievementButton.NameLabel.Text = AchievementsDataHelper.GetDisplayName(nextAchievementId)
        
        AchievementGuiController:UpdateAchievement(nextAchievementId)

        ButtonAnimation.SetUp(achievementFrame.AchievementButton, 1.05)
        achievementFrame.AchievementButton.Activated:Connect(function()
            claimAchievementReward(nextAchievementId)
        end)

        HoverGuiClient.SetupInfoHover(achievementFrame, DetailsFrame, function()
            AchievementGuiController:ShowDetails(nextAchievementId)
        end)
    -- end
end

function AchievementGuiController:GenerateAchievementList()
    -- for achievementId, _ in pairs(AchievementsDataHelper.GetAllData()) do
    --     LogHelper.Print("AchievementGuiController:GenerateAchievementList", achievementId)
    --     local clone = AchievementTemplate:Clone()
    --     clone.Name = achievementId
    --     clone.Visible = true
    --     clone.Parent = AchievementsFrame
    --     clone.LayoutOrder = AchievementsDataHelper.GetLayoutOrder(achievementId)
    --     clone.AchievementButton.Image = "rbxassetid://" .. AchievementsDataHelper.GetImageId(achievementId)
    --     clone.AchievementButton.NameLabel.Text = AchievementsDataHelper.GetDisplayName(achievementId)
    --     self:UpdateAchievement(achievementId)

    --     ButtonAnimation.SetUp(clone.AchievementButton, 1.05)
    --     clone.AchievementButton.Activated:Connect(function()
    --         self:ShowDetails(achievementId)
    --     end)
    -- end
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then warn("PlayerData not found") return end

    for _, achievementType in pairs(AchievementsDataHelper.GetChievementTypes()) do
        generateAchievement(achievementType)
        -- local achievementRank = playerData.AchievementRanks[achievementType] or 0

        -- local nextAchievementRank = 0
        -- if achievementRank < AchievementsDataHelper.GetAchievementMaxRank(achievementType) then
        --     nextAchievementRank = achievementRank + 1
        -- end

        -- if nextAchievementRank == 0 then  -- TODO max rank

        -- else
            -- local nextAchievementId = AchievementsDataHelper.GetAchievementIdByRank(achievementType, nextAchievementRank)
            -- local clone = AchievementTemplate:Clone()
            -- clone.Name = nextAchievementId
            -- clone.Visible = true
            -- clone.Parent = AchievementsFrame
            -- clone.LayoutOrder = AchievementsDataHelper.GetLayoutOrder(nextAchievementId)
            -- clone.AchievementButton.AchieveImage.Image = "rbxassetid://" .. AchievementsDataHelper.GetImageId(nextAchievementId)
            -- clone.AchievementButton.NameLabel.Text = AchievementsDataHelper.GetDisplayName(nextAchievementId)
            -- self:UpdateAchievement(nextAchievementId)

            -- ButtonAnimation.SetUp(clone.AchievementButton, 1.05)
            -- clone.AchievementButton.Activated:Connect(function()
            --     claimAchievementReward(nextAchievementId)
            -- end)

            -- HoverGuiClient.SetupInfoHover(clone, DetailsFrame, function()
            --     self:ShowDetails(nextAchievementId)
            -- end)
        -- end
    end
end

function AchievementGuiController:UpdateAllAchievements()
    -- isReadyToClaim = false

    for achievementId, _ in pairs(AchievementsDataHelper.GetAllData()) do
        self:UpdateAchievement(achievementId)
    end
end

function AchievementGuiController:UpdateAchievement(achievementId: string)
    if not AchievementsDataHelper.GetData(achievementId) then return end

    local achievementFrame = AchievementsFrame:FindFirstChild(achievementId)
    if not achievementFrame then return end

    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    -- local isClaimed = playerData.AchievementClaimLog[achievementId]
    -- achievementFrame.AchievementButton.CompleteFrame.Visible = false
    achievementFrame.AchievementButton.MaxCoverFrame.Visible = false
    achievementFrame.AchievementButton.ClaimCoverFrame.Visible = false

    GuiUtil.SetRarityGradient(achievementFrame.AchievementButton, AchievementsDataHelper.GetAchievementRarity(achievementId))

    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    local currentRank = playerData.AchievementRanks[achievementType] or 0
    local maxRank = AchievementsDataHelper.GetAchievementMaxRank(achievementType)
    local isMaxRank = currentRank >= maxRank

    if isMaxRank then   -- max rank
        -- achievementFrame.AchievementButton.CompleteFrame.Visible = true
        achievementFrame.ProgressFrame.ProgressBar.Size = UDim2.new(0, 0, PROGRESS_BAR_Y, 0)
        achievementFrame.ProgressFrame.ProgressLabel.Text = "Max"
        achievementFrame.ProgressFrame.ProgressBar.Size = UDim2.new(1 * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        achievementFrame.AchievementButton.MaxCoverFrame.Visible = true
        -- achievementFrame.ProgressFrame.Dot.Visible = false
        if readyForClaimAchievements[achievementId] then
            readyForClaimAchievements[achievementId] = nil
        end
    else
        -- achievementFrame.AchievementButton.CompleteFrame.Visible = false
        -- local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
        local progressValue = AchievementsDataHelper.GetProgressValueByType(playerData, achievementType)
        local requirementValue = AchievementsDataHelper.GetRequirementValue(achievementId)

        if progressValue >= requirementValue then

            achievementFrame.ProgressFrame.ProgressBar.Size = UDim2.new(PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
            -- achievementFrame.ProgressFrame.Dot.Visible = true
            achievementFrame.ProgressFrame.ProgressLabel.Text = "Completed"
            achievementFrame.AchievementButton.ClaimCoverFrame.Visible = true

            readyForClaimAchievements[achievementId] = true
        else
            -- achievementFrame.ProgressFrame.Dot.Visible = false
            local percentage = progressValue / requirementValue
            achievementFrame.ProgressFrame.ProgressBar.Size = UDim2.new(percentage * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
            if achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.PLAY_TIME then
                achievementFrame.ProgressFrame.ProgressLabel.Text = NumberUtil.ConvertToDHM_Unit(progressValue) .. "/" .. NumberUtil.ConvertToDHM_Unit(requirementValue)
            else
                achievementFrame.ProgressFrame.ProgressLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(progressValue, 0) .. "/" .. NumberUtil.FormatNumberStartKWithDecimal(requirementValue, 0) 
            end
        end
    end

    self:UpdateHomeNotif()
end

function AchievementGuiController:ShowDetails(achievementId)
    local achievementFrame = AchievementsFrame:FindFirstChild(achievementId)
    if not achievementFrame then return end

    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then return end

    DetailsFrame.Visible = true
    local achievementRarity = AchievementsDataHelper.GetAchievementRarity(achievementId)
    GuiUtil.SetRarityGradient(DetailsFrame, achievementRarity)
    GuiUtil.SetRarityGradient(DetailsFrame.ProfitLabel, achievementRarity)
    -- local buttonAbsolutePosition = achievementFrame.AchievementButton.AbsolutePosition
    -- local adjustedButtonAbsolutePosition = buttonAbsolutePosition + Vector2.new(50, 80)
    -- local ScreenSize = game.Workspace.CurrentCamera.ViewportSize
    -- local XRatio = adjustedButtonAbsolutePosition.X / ScreenSize.X
	-- local YRatio = adjustedButtonAbsolutePosition.Y / ScreenSize.Y
    -- DetailsFrame.Position = UDim2.new(XRatio, 0, YRatio, 0)

    DetailsFrame.NameLabel.Text = AchievementsDataHelper.GetDisplayName(achievementId)
    local totalProfitValue = AchievementsDataHelper.GetTotalProfitValueByRank(achievementId)
    local profitDes = AchievementsDataHelper.GetProfitDescription(achievementId):gsub("#NUM", totalProfitValue)
    DetailsFrame.ProfitLabel.Text = profitDes
    local requirementValue_Format = NumberUtil.FormatNumberStartKWithDecimal(AchievementsDataHelper.GetRequirementValue(achievementId), 0)

    local requirementDes = ""
    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    if achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.PLAY_TIME then
        local formattedValue = NumberUtil.ConvertToDHM_Unit(AchievementsDataHelper.GetRequirementValue(achievementId))
        requirementDes = AchievementsDataHelper.GetRequirementDescription(achievementId):gsub("#NUM", formattedValue)
    else
        requirementDes = AchievementsDataHelper.GetRequirementDescription(achievementId):gsub("#NUM", requirementValue_Format)
    end

    -- local requirementDes = AchievementsDataHelper.GetRequirementDescription(achievementId):gsub("#NUM", requirementValue_Format)
    DetailsFrame.BottomFrame.RequirementLabel.Text = requirementDes

    -- if playerData.AchievementClaimLog[achievementId] then
    local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
    local currentRank = playerData.AchievementRanks[achievementType] or 0
    local maxRank = AchievementsDataHelper.GetAchievementMaxRank(achievementType)
    local isMaxRank = currentRank >= maxRank
    if isMaxRank then  -- max rank
        -- DetailsFrame.BottomFrame.ClaimButton.Visible = false
        -- DetailsFrame.BottomFrame.ProgressFrame.Visible = false
        local percentage = 1
        DetailsFrame.BottomFrame.ProgressFrame.ProgressBar.Size = UDim2.new(percentage * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
        DetailsFrame.BottomFrame.ProgressFrame.ProgressLabel.Text = "Max"

    else
        local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
        local progressValue = AchievementsDataHelper.GetProgressValueByType(playerData, achievementType)

        local requirementValue = AchievementsDataHelper.GetRequirementValue(achievementId)
        if progressValue >= requirementValue then
            -- DetailsFrame.BottomFrame.ClaimButton.Visible = true
            -- DetailsFrame.BottomFrame.ProgressFrame.Visible = false
            -- if claimButtonConnection then
            --     claimButtonConnection:Disconnect()
            -- end
            -- claimButtonConnection = DetailsFrame.BottomFrame.ClaimButton.Activated:Connect(function()
            --     Knit.GetService("AchievementService"):ClaimAchievement(achievementId):andThen(function(result)
            --         if result.isSuccess then
            --             NotificationClient.GreenNotify(result.resultText)
            --             playerData.AchievementClaimLog[achievementId] = true
            --             DetailsFrame.Visible = false
            --             self:UpdateAchievement(achievementId)

            --             Knit.GetController("PetGuiController"):UpdateStorage()
            --         else
            --             NotificationClient.RedNotify(result.resultText)
            --         end
            --     end)
            -- end)
            local percentage = 1
            DetailsFrame.BottomFrame.ProgressFrame.ProgressBar.Size = UDim2.new(percentage * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
            
            DetailsFrame.BottomFrame.ProgressFrame.ProgressLabel.Text = "Completed"
        else
            -- DetailsFrame.BottomFrame.ClaimButton.Visible = false
            DetailsFrame.BottomFrame.ProgressFrame.Visible = true

            local percentage = progressValue / requirementValue
            DetailsFrame.BottomFrame.ProgressFrame.ProgressBar.Size = UDim2.new(percentage * PROGRESS_BAR_MAX_X, 0, PROGRESS_BAR_Y, 0)
            if achievementType == AchievementsDataHelper.ACHIEVEMENT_TYPE.PLAY_TIME then
                -- DetailsFrame.BottomFrame.ProgressFrame.ProgressLabel.Text = math.floor(progressValue/3600) .. "/" .. math.floor(requirementValue/3600)
                DetailsFrame.BottomFrame.ProgressFrame.ProgressLabel.Text = NumberUtil.ConvertToDHM_Unit(progressValue) .. "/" .. NumberUtil.ConvertToDHM_Unit(requirementValue)
            else
                DetailsFrame.BottomFrame.ProgressFrame.ProgressLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(progressValue, 0) .. "/" .. NumberUtil.FormatNumberStartKWithDecimal(requirementValue, 0)
            end
        end
    end
end

local function updateStatsLabel(statType: string)
    local playerData = PlayerDataController:GetData(localPlayer)
    if not playerData then warn("PlayerData not found") return end

    local frame = BottomFrame.ScrollingFrame:FindFirstChild(statType)
    if not frame then warn("Frame not found: ", statType) return end

    if statType == "Playtime" then
        frame.ValueLabel.Text = NumberUtil.ConvertToDHM_Unit(playerData.PlayTime)
    elseif statType == "Wins" then
        local winBoost = GameDataUtil.CalculateWinsBoost(playerData)
        frame.ValueLabel.Text = "+" .. math.round((winBoost-1)*100) .. "%"
    else
        -- 旧玩法统计项（Hatch/Lap/Luck/Strength/SwingSpeed/Damage/Diamond）已删除
        frame.Visible = false
    end
end

local function updateAllStats()
    for _, statFrame in BottomFrame.ScrollingFrame:GetChildren() do
        if not statFrame:IsA("Frame") then continue end
        if not statFrame.Visible then continue end
        updateStatsLabel(statFrame.Name)
    end
end

local function onClaimAchievement(achievementId: string, isSuccess: boolean, resultText: string)
    if isSuccess then
        NotificationClient.GreenNotify(resultText)
        
        local achievementFrame = AchievementsFrame:FindFirstChild(achievementId)
        if not achievementFrame then warn("Achievement not found: ", achievementId) return end

        HoverGuiClient.RemoveHoverConnection(achievementFrame)
        achievementFrame:Destroy()

        local achievementType = AchievementsDataHelper.GetAchievementType(achievementId)
        generateAchievement(achievementType)

        readyForClaimAchievements[achievementId] = nil

        GuiAnimationUtil.RibbonParticle(HomeGui)
        SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER)
    else
        NotificationClient.RedNotify(resultText)
    end
end

function AchievementGuiController:KnitInit()
    local achievementService = Knit.GetService("AchievementService")
    achievementService.ClaimAchievementResultEvent:Connect(function(achievementId: string, isSuccess: boolean, resultText: string)
        task.delay(0, function()
            onClaimAchievement(achievementId, isSuccess, resultText)
            updateAllStats()
        end)
    end)
end

function AchievementGuiController:KnitStart()
    local playerData = PlayerDataController:GetData(localPlayer)

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(AchievementGui)
    end)

    GuiUtil.AutoResizeScrollingFrame(AchievementGui)

    AchievementGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        DetailsFrame.Visible = false
    end)

    AchievementsFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- When It changes
        DetailsFrame.Visible = false
    end)

    -- PlayerDataService.RebirthsChanged:Connect(function()
    --     task.delay(0, function()
    --         self:UpdateAllAchievements()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         self:UpdateAllAchievements()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         self:UpdateAllAchievements()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    -- local TrailService = Knit.GetService("TrailService")
    -- TrailService.EquipTrailEvent:Connect(function()
    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    -- TrailService.UnequipTrailEvent:Connect(function()
    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    -- local UpgradeService = Knit.GetService("UpgradeService")
    -- UpgradeService.Upgrade:Connect(function()
    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)

    --     task.delay(0, function()
    --         updateAllStats()
    --     end)
    -- end)


    self:InitGui()
    self:GenerateAchievementList()

    -- self:UpdateDefeatBossesLabel()
    -- self:UpdateDefeatEnemiesLabel()
    -- self:UpdateJoinBattlesLabel()
    -- self:UpdateSummonHeroesLabel()

    -- for _, statFrame in BottomFrame:GetChildren() do
    --     if not statFrame:IsA("Frame") then continue end
    --     if not statFrame.Visible then continue end
    --     updateStatsLabel(statFrame.Name)
    -- end

    updateAllStats()

    local playTimer = Timer.new(1)
    playTimer.Tick:Connect(function()
        playerData.PlayTime = playerData.PlayTime + 1
        -- self:UpdatePlayTimeLabel(playerData.PlayTime)
        -- updateStatsLabel("Playtime")
        self:UpdateAllAchievements()
        updateAllStats()
    end)
    playTimer:Start()
end

return AchievementGuiController
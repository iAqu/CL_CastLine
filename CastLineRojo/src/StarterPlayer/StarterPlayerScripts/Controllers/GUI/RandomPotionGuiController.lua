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
local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local CharacterController = require(StarterPlayer.StarterPlayerScripts.Controllers.CharacterController)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local DistanceUtil = require(ReplicatedStorage.Modules.DistanceUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local Timer = require(ReplicatedStorage.Packages.Timer)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character: Model? = localPlayer.Character
localPlayer.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
end)
localPlayer.CharacterRemoving:Connect(function(removingCharacter)
	if character == removingCharacter then
		character = nil
	end
end)
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local RandomPotionGui = PlayerGui:WaitForChild("RandomPotionGui")
local CloseButton = RandomPotionGui.Frame.CloseButton

local MainFrame = RandomPotionGui.Frame
-- local ScrollingFrame = MainFrame.ScrollingFrame
-- local UpgradeTemplate = ScrollingFrame.Template
local AvailableFrame = MainFrame.AvailableFrame
local Buy1Frame = AvailableFrame.ButtonsFrame.Buy1Frame
local Buy2Frame = AvailableFrame.ButtonsFrame.Buy2Frame
local Buy3Frame = AvailableFrame.ButtonsFrame.Buy3Frame

local UnavailableFrame = MainFrame.UnavailableFrame

local machineModels = {}
local isNearMachine = false
local RandomPotionGuiController = Knit.CreateController {
    Name = "RandomPotionGuiController",
}

-- local UpgradeMachineModel = workspace.Areas[Constants.AREA_NAME.Upgrade_Machine_Located_Area].Items.UpgradeMachine
local isClosing = false

-- local PROGRESS_BAR_MAX_X = 0.988
-- local PROGRESS_BAR_Y = 0.867

local function getCanBuyPotionNum()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    local boughtPotionNum = #playerData.RandomPotionBuyLog
    local canBuyPotionNum = Constants.MAX_RANDOM_POTION_BUY_NUM - boughtPotionNum
    return canBuyPotionNum
end

local function updateGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("Player data not found") return end

    
    -- local potionIds = TableUtil.Keys(playerData.RandomPotionBuyLog)
    local canBuyPotionNum = getCanBuyPotionNum()
    if canBuyPotionNum <= 0 then
        AvailableFrame.Visible = false
        UnavailableFrame.Visible = true

    else
        AvailableFrame.Visible = true
        UnavailableFrame.Visible = false

        Buy1Frame.Visible = canBuyPotionNum >= 1
        Buy2Frame.Visible = canBuyPotionNum >= 2
        Buy3Frame.Visible = canBuyPotionNum >= 3
    end
end

local function updateMachineGui()
    local canBuyPotionNum = getCanBuyPotionNum()
    for _, machine in machineModels do
        if machine:FindFirstChild("GuiPart") then
            local guiPart = machine.GuiPart
            guiPart.SurfaceGui.Frame.PriceLabel.Visible = canBuyPotionNum >= 1
            guiPart.SurfaceGui.Frame.SoldOutLabel.Visible = canBuyPotionNum <= 0
        else
            warn("No GuiPart in machine: " .. machine.Name)
        end
    end
end

local function init()
    -- for _, item in pairs(ScrollingFrame:GetChildren()) do
    --     if item.Name == "Template" then
    --         item.Visible = false
    --     end
    -- end
    -- self:UpdateStarLabel()
    Buy1Frame.PriceLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(Constants.RANDOM_POTION_PRICE)
    Buy2Frame.PriceLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(Constants.RANDOM_POTION_PRICE * 2)
    Buy3Frame.PriceLabel.Text = NumberUtil.FormatNumberStartKWithDecimal(Constants.RANDOM_POTION_PRICE * 3)

    local buyFrames = {Buy1Frame, Buy2Frame, Buy3Frame}
    for index, buyFrame in pairs(buyFrames) do
        buyFrame.BuyButton.Activated:Connect(function()
            local buyNum = index
            Knit.GetService("RandomPotionService").BuyPotionEvent:Fire(buyNum)
        end)
    end

    UnavailableFrame.ComfirmButton.Activated:Connect(function()
        GuiAnimation.CloseGui(RandomPotionGui)
    end)

    updateGui()
    updateMachineGui()
end

function RandomPotionGuiController:OpenGui()
    GuiAnimation.OpenGui(RandomPotionGui)
end

function RandomPotionGuiController:CloseGui()
    GuiAnimation.CloseGui(RandomPotionGui)
end

local function initMachine()
    machineModels = {}

    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local itemsFolder = areaRoot:FindFirstChild("Items")
        if not itemsFolder then return end

        for _, item in pairs(itemsFolder:GetChildren()) do
            if item.Name == "PotionMachine" then
                table.insert(machineModels, item)
            end
        end
    end)
end

local function detectMachine()
	local activeCharacter = character
	local rootPart = activeCharacter and activeCharacter:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then return end

    local detectedPotionMachine = nil
    for _, potionMachineModel in machineModels do
        if not potionMachineModel.Parent or not potionMachineModel:IsDescendantOf(workspace) then continue end
        if not potionMachineModel.PrimaryPart then warn("No primary part!", potionMachineModel.Name) continue end

		local magnitude = DistanceUtil.GetHorizontalDistance(rootPart.Position, potionMachineModel.PrimaryPart.Position)
        if magnitude <= 15 then
            detectedPotionMachine = potionMachineModel
        end
    end

    if detectedPotionMachine then
        if not isNearMachine then
            RandomPotionGuiController:OpenGui()
            isNearMachine = true
        end
    else
        if isNearMachine then
            RandomPotionGuiController:CloseGui()
            isNearMachine = false
        end
    end
end

-- function RandomPotionGuiController:UpdateStarLabel()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("Player data not found") return end

--     LogHelper.Print("SuperRebirthTokens: " .. playerData.SuperRebirthTokens)
--     MainFrame.StarLabel.TextLabel.Text = playerData.SuperRebirthTokens
-- end

-- function RandomPotionGuiController:GenerateUpgradeList()
function RandomPotionGuiController:GenerateButtonList()
    -- local playerData = PlayerDataController:GetData()
    -- if not playerData then warn("Player data not found") return end
    

    -- for upgradeId, _ in RebirthUpgradesDataHelper.GetAllData() do
    --     local currentUpgradeLevel = playerData.RebirthUpgrades[upgradeId] or 0
    --     local upgradeClone = UpgradeTemplate:Clone()
    --     upgradeClone.Name = upgradeId
    --     upgradeClone.Visible = true
    --     upgradeClone.Parent = ScrollingFrame
    --     upgradeClone.LayoutOrder = RebirthUpgradesDataHelper.GetIndex(upgradeId)
    --     upgradeClone.IconImage.Image = "rbxassetid://" .. RebirthUpgradesDataHelper.GetIconId(upgradeId)
    --     upgradeClone.NameLabel.Text = RebirthUpgradesDataHelper.GetDisplayName(upgradeId)

    --     ButtonAnimation.SetUp(upgradeClone.UpgradeButton)
    --     upgradeClone.UpgradeButton.TextLabel.Text = RebirthUpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
    --     upgradeClone.UpgradeButton.Activated:Connect(function()

    --         Knit.GetService("RebirthService"):SuperRebirthUpgrade(upgradeId):andThen(function(isSuccess, message)
    --             if isSuccess then
    --                 self:UpdateUpgradeItem(upgradeId)
    --                 NotificationClient.GreenNotify(message)
    --             else
    --                 NotificationClient.RedNotify(message)
    --             end
    --         end)
    --     end)

    --     self:UpdateUpgradeItem(upgradeId)
    -- end
end

-- function RandomPotionGuiController:UpdatePrice(upgradeId: string)
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("Player data not found") return end

--     local upgradeItem = ScrollingFrame:FindFirstChild(upgradeId)
--     if not upgradeItem then warn("Upgrade item not found: " .. upgradeId) return end

--     local currentUpgradeLevel = playerData.RebirthUpgrades[upgradeId] or 0
--     upgradeItem.UpgradeButton.TextLabel.Text = RebirthUpgradesDataHelper.GetPrice(upgradeId, currentUpgradeLevel + 1)
-- end

function RandomPotionGuiController:KnitInit()
    local RandomPotionService = Knit.GetService("RandomPotionService")
    RandomPotionService.UpdateRandomPotionBuyLogEvent:Connect(function(randomPotionBuyLog: {})
        task.delay(0, function()
            updateGui()
            updateMachineGui()
        end)
    end)

    RandomPotionService.BuyPotionResultEvent:Connect(function(isSuccess: boolean, message: string)
        if isSuccess then
            NotificationClient.GreenNotify(message)
        else
            NotificationClient.RedNotify(message)
        end
    end)

    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(function()
        initMachine()
    end)
end

function RandomPotionGuiController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		RandomPotionGui.Enabled = false
		return
	end
	CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(RandomPotionGui)
    end)

    initMachine()
    init()
    -- self:GenerateButtonList()

    -- RunService.Heartbeat:Connect(function()
    Timer.Simple(0.1, function()
        detectMachine()
    end)
end

return RandomPotionGuiController

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local ViewportModel = require(ReplicatedStorage.Libs.ViewportModel)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local RotationGradientModule = require(ReplicatedStorage.Modules.RotationGradientModule)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)

local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local SpinningWheelGui = PlayerGUI:WaitForChild("SpinningWheelGui")
local MainFrame = SpinningWheelGui.Frame
local CloseButton = MainFrame.CloseButton
local SpinButton = MainFrame.SpinButton
local TimeLabel = MainFrame.TimeLabel
local Buy3Button = MainFrame.Buy3Button
local Buy10Button = MainFrame.Buy10Button

local FuseWheelFrame = MainFrame.Progress.Center

-- local SpinningWheelModel = workspace:WaitForChild("Areas"):WaitForChild(Constants.AREA_NAME.Area_1):WaitForChild("Items"):WaitForChild("SpinningWheel")

-- local Fortune = {
--     {Stars=1000, MinPos=1352, MaxPos=1393}, {Stars=300, MinPos=1172, MaxPos=1214}, 
--     {Stars=150, MinPos=1127, MaxPos=1169}, {Stars=100, MinPos=1037, MaxPos=1078}, 
--     {Stars=50, MinPos=1082, MaxPos=1123}, {Stars=50, MinPos=1263, MaxPos=1300},
--     {Stars=25, MinPos=1219, MaxPos=1259}, {Stars=25, MinPos=1308, MaxPos=1348} 
-- }

-- local Fortune = {
--     {MinPos= 360*3 + 2, MaxPos = 360*3 + 72 - 2},
--     {MinPos= 360*3 + 72 + 2, MaxPos = 360*3 + 72*2 - 2},
--     {MinPos= 360*3 + 72*2 + 2, MaxPos = 360*3 + 72*3 - 2},
--     {MinPos= 360*3 + 72*3 + 2, MaxPos = 360*3 + 72*4 - 2},
--     {MinPos= 360*3 + 72*4 + 2, MaxPos = 360*3 + 72*5 - 2},
-- }

local SPIN_1_PRICE = 49
local WHEEL_ROTATION_BASE = 360*4
local WORLD_WHEEL_IDLE_ROTATION_SPEED = 12
local WORLD_WHEEL_HIGHLIGHT_NAME = "SpinWheelHighlight"
-- local WHEEL_ROTATION_TIME = 5
local currentWheelRotation = 0
local isInSpinProgress = false
local isCloseToWheel = false

local worldWheelModel: Model? = nil
local worldWheelPrompt: ProximityPrompt? = nil
local worldWheelHighlight: Highlight? = nil
local worldWheelConnections: { RBXScriptConnection } = {}

local SpinningWheelController = Knit.CreateController {
    Name = "SpinningWheelController",
    _CurrentRebirth = nil,
    _CurrentStrength = nil,
}

local function disconnectWorldWheelConnections()
    for _, connection in worldWheelConnections do
        connection:Disconnect()
    end
    table.clear(worldWheelConnections)
end

local function destroyWorldWheelHighlight()
    if worldWheelHighlight then
        worldWheelHighlight:Destroy()
        worldWheelHighlight = nil
    end
end

local function cleanupWorldWheel()
    disconnectWorldWheelConnections()
    destroyWorldWheelHighlight()
    worldWheelModel = nil
    worldWheelPrompt = nil
end

local function applyWorldWheelHighlight(model: Model)
    if worldWheelHighlight and worldWheelHighlight.Parent then
        return
    end

    destroyWorldWheelHighlight()

    local highlight = Instance.new("Highlight")
    highlight.Name = WORLD_WHEEL_HIGHLIGHT_NAME
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = model
    worldWheelHighlight = highlight
end

local function initWorldWheel()
    cleanupWorldWheel()

    local areas = Workspace:WaitForChild("Areas", 20)
    if not areas then
        warn("SpinningWheelController: Workspace.Areas not found")
        return
    end

    local items = areas:WaitForChild("Items", 20)
    if not items then
        warn("SpinningWheelController: Workspace.Areas.Items not found")
        return
    end

    local spinWheel = items:FindFirstChild("SpinWheel") or items:FindFirstChild("SpinningWheel")
    if not spinWheel or not spinWheel:IsA("Model") then
        warn("SpinningWheelController: SpinWheel model not found")
        return
    end

    local primaryPart = spinWheel.PrimaryPart
    if not primaryPart then
        warn("SpinningWheelController: SpinWheel has no PrimaryPart", spinWheel:GetFullName())
        return
    end

    worldWheelModel = spinWheel

    local prompt = primaryPart:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then
        prompt = Instance.new("ProximityPrompt")
        prompt.Parent = primaryPart
    end
    prompt.ActionText = "Spin"
    prompt.ObjectText = "Spin Wheel"
    prompt.MaxActivationDistance = 20
    prompt.HoldDuration = 0
    prompt.RequiresLineOfSight = false
    prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
    worldWheelPrompt = prompt

    local guiPart = spinWheel:FindFirstChild("GuiPart")
    local surfaceGui = guiPart and guiPart:FindFirstChild("SurfaceGui")
    local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
    local progress = frame and frame:FindFirstChild("Progress")
    local center = progress and progress:FindFirstChild("Center")
    if center and center:IsA("GuiObject") then
        table.insert(worldWheelConnections, RunService.Heartbeat:Connect(function(dt)
            center.Rotation += dt * WORLD_WHEEL_IDLE_ROTATION_SPEED
        end))
    else
        warn("SpinningWheelController: SpinWheel rotation UI not found", spinWheel:GetFullName())
    end

    table.insert(worldWheelConnections, prompt.Triggered:Connect(function(player)
        if player == localPlayer then
            GuiAnimation.OpenGui(SpinningWheelGui)
        end
    end))

    table.insert(worldWheelConnections, spinWheel.Destroying:Connect(function()
        if worldWheelModel == spinWheel then
            cleanupWorldWheel()
        end
    end))
end

function SpinningWheelController:Init()
    -- self:UpdateRewardNum()
    self:UpdateSpinNum()
end

-- function SpinningWheelController:UpdateRewardNum()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("No player data found!") return end

--     local strengthReward = math.floor(tonumber(playerData.Strength) * 0.5)
--     StrengthNumLabel.Text = strengthReward < 1 and "1" or NumberUtil.FormatNumberStartKWithDecimal(strengthReward)
--     local winReward = math.floor(playerData.Wins * 0.2)
--     WinNumLabel.Text = winReward < 1 and "1" or NumberUtil.FormatNumberStartKWithDecimal(winReward)
-- end

function SpinningWheelController:UpdateSpinNum()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local bonusSpins = playerData.SpinningWheelBonusSpins or 0
    local hasFreeSpin = os.time() - playerData.SpinningWheelLastCheckTime >= Constants.SPINNING_WHEEL_TIME
    local availableSpins = bonusSpins + (hasFreeSpin and 1 or 0)
    if availableSpins > 0 then
        SpinButton.TextLabel.Text = "Spin (" .. availableSpins .. ")"

        TimeLabel.Visible = false
    else
        SpinButton.TextLabel.Text = "+1 Spin [R$" .. SPIN_1_PRICE .. "]"
        TimeLabel.Visible = true
    end
end

function SpinningWheelController:UpdateNextFreeSpinTime()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local HomeGuiController = Knit.GetController("HomeGuiController")
    local bonusSpins = playerData.SpinningWheelBonusSpins or 0
    local hasFreeSpin = os.time() - playerData.SpinningWheelLastCheckTime >= Constants.SPINNING_WHEEL_TIME

    if bonusSpins > 0 or hasFreeSpin then
        -- HomeGuiController:UpdateSpinButton("Spin!")
        HomeGuiController:ShowSpinNotif(true)
        return
    else
        HomeGuiController:ShowSpinNotif(false)
    end

    local leftTime = NumberUtil.ConvertToAutoHMS(Constants.SPINNING_WHEEL_TIME - (os.time() - playerData.SpinningWheelLastCheckTime))
    TimeLabel.Text = "Next Free Spin in " .. leftTime

    -- HomeGuiController:UpdateSpinButton(leftTime)
end

function SpinningWheelController:CalucateWheelRotation(resultIndex: number)
    local currentTurns = math.floor(currentWheelRotation / 360)
    local leftRotation = 0
    if currentTurns > 0 then
        leftRotation = 360 - currentWheelRotation % 360
    else
        leftRotation = 0
    end

    local wheelRotation = WHEEL_ROTATION_BASE - (resultIndex - 1) * 72 + leftRotation + currentWheelRotation
    wheelRotation -= 36 -- center the wheel
    currentWheelRotation = wheelRotation
    return wheelRotation
end

function SpinningWheelController:SpineWheel(resultIndex: number, resultText: string)
    local wheelRotation = self:CalucateWheelRotation(resultIndex)
    local tweenInfo =  TweenInfo.new(Constants.SPINNING_WHEEL_ROTATION_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
    local tween = TweenService:Create(FuseWheelFrame, tweenInfo, {Rotation = wheelRotation})
    tween:Play()
    isInSpinProgress = true
    SoundHelper.PlaySound(Constants.SoundRes.GUI_FUSE_WHEEL)
    task.delay(Constants.SPINNING_WHEEL_ROTATION_TIME, function()
       NotificationClient.GreenNotify(resultText)
       isInSpinProgress = false
       SoundHelper.StopSound(Constants.SoundRes.GUI_FUSE_WHEEL)
       SoundHelper.PlaySound(Constants.SoundRes.GUI_FUSE_SUCCESS)
    end)
end

function SpinningWheelController:KnitInit()
end

function SpinningWheelController:KnitStart()
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		SpinningWheelGui.Enabled = false
		return
	end
    ProximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt)
        if prompt == worldWheelPrompt and worldWheelModel and worldWheelModel.Parent then
            applyWorldWheelHighlight(worldWheelModel)
        end
    end)

    ProximityPromptService.PromptHidden:Connect(function(prompt: ProximityPrompt)
        if prompt == worldWheelPrompt then
            destroyWorldWheelHighlight()
        end
    end)

    Workspace.DescendantAdded:Connect(function(instance: Instance)
        if instance:IsA("Model") and (instance.Name == "SpinWheel" or instance.Name == "SpinningWheel") then
            task.defer(initWorldWheel)
        end
    end)

    task.spawn(initWorldWheel)

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(SpinningWheelGui)
    end)

    SpinButton.Activated:Connect(function()
        local playerData = PlayerDataController:GetData()
        if not playerData then warn("No player data found!") return end

        local bonusSpins = playerData.SpinningWheelBonusSpins or 0
        local hasFreeSpin = os.time() - playerData.SpinningWheelLastCheckTime >= Constants.SPINNING_WHEEL_TIME
        if bonusSpins > 0 or hasFreeSpin then
            if isInSpinProgress then
                NotificationClient.RedNotify("In progress, try later!")
                return
            end

            local SpinningWheelService = Knit.GetService("SpinningWheelService")
            SpinningWheelService:StartSpin():andThen(function(result)
                if result.resultIndex == 0 then
                    NotificationClient.RedNotify(result.resultText)
                    return
                end
                self:SpineWheel(result.resultIndex, result.resultText)
            end)
        else
            MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId("Spinx1"))
        end
    end)

    Buy3Button.Activated:Connect(function()
        MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId("Spinx3"))
    end)

    Buy10Button.Activated:Connect(function()
        MarketplaceService:PromptProductPurchase(localPlayer, PurchaseDataHelper.GetProductId("Spinx10"))
    end)

    local SpinningWheelService = Knit.GetService("SpinningWheelService")
    SpinningWheelService.UpdateSpinningWheelCount:Connect(function(result)
        task.delay(0, function()
            self:UpdateSpinNum()
            self:UpdateNextFreeSpinTime()
        end)
    end)

    -- DistanceDetectUtil.DetectTouchAndDistance(character, SpinningWheelModel, 8, function(isTouching)
    --     if isTouching then
    --         if not isCloseToWheel then
    --             GuiAnimation.OpenGui(SpinningWheelGui)
    --             isCloseToWheel = true
    --         end
    --     else
    --         if isCloseToWheel then
    --             GuiAnimation.CloseGui(SpinningWheelGui)
    --             isCloseToWheel = false
    --         end
    --     end
    -- end)

    self:Init()

    task.spawn(function()
        while true do
            self:UpdateSpinNum()
            self:UpdateNextFreeSpinTime()
            task.wait(1)
        end
    end)
end

return SpinningWheelController

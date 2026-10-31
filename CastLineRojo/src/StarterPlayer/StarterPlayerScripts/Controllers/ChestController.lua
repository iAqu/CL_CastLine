local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local DistanceUtil = require(ReplicatedStorage.Modules.DistanceUtil)

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local dailyRewardGui = playerGui:WaitForChild("ChestDailyRewardGui")

local dailyChestTimeLabel: TextLabel? = nil
local dailyChests: { Model } = {}
local currentNearbyDailyChest: Model? = nil

local ChestController = Knit.CreateController {
    Name = "ChestController",
}

function ChestController:Init()
    dailyRewardGui.Enabled = false
end

local function initDailyChests()
    dailyChests = {}
    dailyChestTimeLabel = nil

    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local items = areaRoot:FindFirstChild("Items")
        if not items then
            return
        end

        for _, item in items:GetChildren() do
            if item.Name == "DailyChest" and item:IsA("Model") then
                local titleGui = item:FindFirstChild("TitleGui")
                local frame = titleGui and titleGui:FindFirstChild("Frame")
                local timeLabel = frame and frame:FindFirstChild("TimeLabel")
                local guiPart = item:FindFirstChild("GuiPart")
                if timeLabel and timeLabel:IsA("TextLabel") and guiPart and guiPart:IsA("BasePart") then
                    table.insert(dailyChests, item)
                    dailyChestTimeLabel = timeLabel
                    dailyRewardGui.Adornee = guiPart
                else
                    warn("ChestController: DailyChest is missing TitleGui.Frame.TimeLabel or GuiPart")
                end
            end
        end
    end)
end

local function setupGui()
    ButtonAnimation.SetUp(dailyRewardGui.Frame.ClaimButton)
    dailyRewardGui.Frame.ClaimButton.Activated:Connect(function()
        ChestController:OpenDailyChest()
    end)
end

function ChestController:UpdateDailyChestCooldown()
    local playerData = PlayerDataController:GetData()
    if not playerData then
        warn("ChestController: player data not found")
        return
    end
    if not dailyChestTimeLabel then
        return
    end

    if os.time() - playerData.DailyChestLastOpenTime > Constants.CHEST_OPEN_COOLDOWN then
        dailyChestTimeLabel.Text = "Claim!"
    else
        dailyChestTimeLabel.Text = NumberUtil.ConvertToHMS(Constants.CHEST_OPEN_COOLDOWN - (os.time() - playerData.DailyChestLastOpenTime))
    end
end

function ChestController:OpenDailyChest()
    local playerData = PlayerDataController:GetData()
    if not playerData then
        warn("ChestController: player data not found")
        return
    end

    if os.time() - playerData.DailyChestLastOpenTime > Constants.CHEST_OPEN_COOLDOWN then
        LogHelper.Print("Open daily chest:" .. os.time() - playerData.DailyChestLastOpenTime)
        Knit.GetService("ChestService"):ClaimDailyChest():andThen(function(resultTexts: { string })
            for _, text in resultTexts do
                if text then
                    NotificationClient.GreenNotify(text)
                end
            end
        end)
    else
        NotificationClient.WhiteNotify("Please wait!")
    end
end

local function detectDailyChest()
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not rootPart:IsA("BasePart") then
        return
    end

    local closestChest: Model? = nil
    local closestDistance = Constants.DETECT_RANGE.CHEST
    for _, chest in dailyChests do
        local primaryPart = chest.PrimaryPart
        if chest:IsDescendantOf(workspace) and primaryPart then
            local distance = DistanceUtil.GetHorizontalDistance(rootPart.Position, primaryPart.Position)
            if distance <= closestDistance then
                closestDistance = distance
                closestChest = chest
            end
        end
    end

    if closestChest then
        dailyRewardGui.Enabled = true
        currentNearbyDailyChest = closestChest
    elseif currentNearbyDailyChest then
        dailyRewardGui.Enabled = false
        currentNearbyDailyChest = nil
    end
end

function ChestController:KnitInit()
    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(initDailyChests)
end

function ChestController:KnitStart()
    self:Init()
    setupGui()
    initDailyChests()

    task.spawn(function()
        while true do
            self:UpdateDailyChestCooldown()
            task.wait(1)
        end
    end)
    RunService.Heartbeat:Connect(detectDailyChest)
end

return ChestController

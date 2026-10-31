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
local Knit = require(ReplicatedStorage.Packages.Knit)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

-- local HomeLeftGui = PlayerGUI:WaitForChild("HomeLeftGui")
-- local LeftFrame = HomeLeftGui:WaitForChild("Frame")
-- local OpenButton = HomeLeftGui.Frame.RebirthFrame.RebirthButton
local RebirthGui = PlayerGUI:WaitForChild("RebirthGui")

local SuperRebirthGui = PlayerGUI:WaitForChild("SuperRebirthGui")
local SuperRebirthFrame = SuperRebirthGui:WaitForChild("Frame")
local RewardsFrame = SuperRebirthFrame:WaitForChild("RewardsFrame")

local CloseButton = SuperRebirthFrame:WaitForChild("CloseButton")

local ConfirmButton = SuperRebirthFrame:WaitForChild("ConfirmButton")
local CancelButton = SuperRebirthFrame:WaitForChild("CancelButton")

local SuperRebirthGuiController = Knit.CreateController {
    Name = "SuperRebirthGuiController",
}

function SuperRebirthGuiController:Init()
end

function SuperRebirthGuiController:OpenGui()
    local playerData = PlayerDataController:GetData()
    if not playerData then return end

    RewardsFrame.StarCurrentLabel.Text = playerData.SuperRebirthTokens
    RewardsFrame.StarNextLabel.Text = playerData.SuperRebirthTokens + 1
    RewardsFrame.BoostCurrentLabel.Text = math.floor(GameDataUtil.CalculateSuperRebirthBaseBoost(playerData.SuperRebirths) * 100) .. "%"
    RewardsFrame.BoostNextLabel.Text = math.floor(GameDataUtil.CalculateSuperRebirthBaseBoost(playerData.SuperRebirths + 1) * 100) .. "%"

    GuiAnimation.OpenGui(SuperRebirthGui)
end

function SuperRebirthGuiController:KnitInit()
end

function SuperRebirthGuiController:KnitStart()
    local RebirthService = Knit.GetService("RebirthService")
    
    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(SuperRebirthGui)
    end)
    
    ConfirmButton.Activated:Connect(function()
        RebirthService:SuperRebirth():andThen(function(isSuccess, resultText)
            LogHelper.Print("SuperRebirthGuiController:KnitStart() - isSuccess: " , tostring(isSuccess) , ", resultText: " , resultText)
            if isSuccess then
                NotificationClient.GreenNotify(resultText)
                GuiAnimation.CloseGui(SuperRebirthGui)
            else
                NotificationClient.RedNotify(resultText)
            end
        end)
    end)

    CancelButton.Activated:Connect(function()
        GuiAnimation.OpenGui(RebirthGui)
    end)

    -- init
    self:Init()
end

return SuperRebirthGuiController
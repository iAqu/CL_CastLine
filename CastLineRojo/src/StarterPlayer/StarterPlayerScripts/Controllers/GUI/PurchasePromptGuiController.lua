local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")

local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local PurchasePromptGui = PlayerGUI:WaitForChild("PurchasePromptGui")
local DoubleWinsButton = PurchasePromptGui.Frame.DoubleWins

local Knit = require(ReplicatedStorage.Packages.Knit)

local PurchasePromptGuiController = Knit.CreateController {
    Name = "PurchasePromptGuiController",
}

local function init()
    PurchasePromptGui.Enabled = false
    DoubleWinsButton.Visible = false
end

local function hideButton(purchaseId: string)
    if purchaseId == Constants.GAMEPASS.DOUBLE_WINS then
        DoubleWinsButton.Visible = false
    end
end

function PurchasePromptGuiController:KnitInit()
    DoubleWinsButton.Activated:Connect(function()
        MarketplaceService:PromptGamePassPurchase(localPlayer, PurchaseDataHelper.GetProductId(Constants.GAMEPASS.DOUBLE_WINS))
    end)

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId: string)
        task.delay(0, function()
            local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
            hideButton(purchaseId)
        end)
    end)
end

function PurchasePromptGuiController:KnitStart()
    init()
end

return PurchasePromptGuiController

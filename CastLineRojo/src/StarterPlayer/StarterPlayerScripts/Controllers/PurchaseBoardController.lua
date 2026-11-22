local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")

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
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local UltraLuckDetails = require(ReplicatedStorage.Modules.UltraLuckDetails)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local PurchaseBoardController = Knit.CreateController {
    Name = "PurchaseBoardController",
}
local boundButtons = setmetatable({}, { __mode = "k" })

local DETECT_DISTANCE = 8
local isClosing = false

local function initPurchaseBoards()
    local playerData = PlayerDataController:GetData()

    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local purchaseBoards = areaRoot:FindFirstChild("PurchaseBoards")
        if not purchaseBoards then return end

        for _, model in purchaseBoards:GetChildren() do
            local purchaseId = model:GetAttribute("PurchaseId")
            if not purchaseId then warn("purchaseId not found!", model.Name) continue end
            if purchaseId == "" then warn("purchaseId is Empty!", model.Name) continue end
            if PurchaseDataHelper.IsRetired(purchaseId) then
                local surface = model:FindFirstChildOfClass("SurfaceGui")
                if surface then
                    surface.Enabled = false
                end
                continue
            end
            if not model:FindFirstChild("SurfaceGui") then warn("SurfaceGui not found!", model.Name) continue end

            if PurchaseDataHelper.GetTypeByPurchaseId(purchaseId) == "GamePass" then
                model.SurfaceGui.Frame.RightFrame.BuyButton.Visible = not playerData.GamePasses[purchaseId]
                model.SurfaceGui.Frame.RightFrame.OwnedLabel.Visible = playerData.GamePasses[purchaseId]
            end
            -- model.SurfaceGui.Frame.RightFrame.BuyButton.Visible = not playerData.LimitedPurchaseHistory[purchaseId]
            -- model.SurfaceGui.Frame.RightFrame.OwnedLabel.Visible = playerData.LimitedPurchaseHistory[purchaseId]

            local button = model.SurfaceGui.Frame.RightFrame.BuyButton
            local row = PurchaseDataHelper.GetData(purchaseId)
            if not row or boundButtons[button] then continue end
            if purchaseId == UltraLuckDetails.PurchaseId then
                local description = model.SurfaceGui:FindFirstChild("DescriptionLabel", true)
                if description and description:IsA("TextLabel") then
                    description.Text = UltraLuckDetails.Description .. "\nView Details"
                end
            end
            boundButtons[button] = true
            button.Activated:Connect(function()

                if playerData.LimitedPurchaseHistory[purchaseId] then
                    NotificationClient.RedNotify("💡 You already bought this item!")
                    return
                end

                if purchaseId == UltraLuckDetails.PurchaseId then
                    UltraLuckDetails.OpenPurchase(true)
                elseif row.Type == "GamePass" then
                    MarketplaceService:PromptGamePassPurchase(localPlayer, row.ProductId)
                else
                    Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId, true)
                end
            end)
        end
    end)
end

local function updatePurchaseBoard()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("not palyerData!") return end

    -- for index, model in pairs(vendingMachines) do
    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local purchaseBoards = areaRoot:FindFirstChild("PurchaseBoards")
        if not purchaseBoards then return end

        for _, model in purchaseBoards:GetChildren() do
            local purchaseId = model:GetAttribute("PurchaseId")
            if not purchaseId then warn("purchaseId not found!", model.Name) continue end
            if purchaseId == "" then warn("purchaseId is Empty!", model.Name) continue end
            if PurchaseDataHelper.IsRetired(purchaseId) then
                local surface = model:FindFirstChildOfClass("SurfaceGui")
                if surface then
                    surface.Enabled = false
                end
                continue
            end
            if not model:FindFirstChild("SurfaceGui") then continue end

            LogHelper.Print("PurchaseBoardController", playerData.LimitedPurchaseHistory)
            -- model.SurfaceGui.Frame.RightFrame.BuyButton.Visible = not playerData.LimitedPurchaseHistory[purchaseId]
            -- model.SurfaceGui.Frame.RightFrame.OwnedLabel.Visible = playerData.LimitedPurchaseHistory[purchaseId]
            if PurchaseDataHelper.GetTypeByPurchaseId(purchaseId) == "GamePass" then
                model.SurfaceGui.Frame.RightFrame.BuyButton.Visible = not playerData.GamePasses[purchaseId]
                model.SurfaceGui.Frame.RightFrame.OwnedLabel.Visible = playerData.GamePasses[purchaseId]
            end
        end
    end)
end

function PurchaseBoardController:KnitInit()
    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(function()
        -- self:InitPurchaseBoards(worldIndex)
        initPurchaseBoards()
        updatePurchaseBoard()
    end)
end

function PurchaseBoardController:KnitStart()
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId)
        task.delay(0, function()
            updatePurchaseBoard()
        end)
    end)

    PurchaseService.PurchaseSuccess:Connect(function(productId)
        task.delay(0, function()
            updatePurchaseBoard()
        end)
    end)

    initPurchaseBoards()
end

return PurchaseBoardController

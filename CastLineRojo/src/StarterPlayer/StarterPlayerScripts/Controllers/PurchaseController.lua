local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local CommonResultClient = require(ReplicatedStorage.Modules.CommonResultClient)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local EffectUtil = require(ReplicatedStorage.Modules.EffectUtil)

local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local HomeGui = PlayerGUI:WaitForChild("HomeGui")

local PurchaseController = Knit.CreateController {
    Name = "PurchaseController",
}

local function playRobuxPurchaseEffect()
    local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    if not localCharacter:FindFirstChild("HumanoidRootPart") then return end

    EffectUtil.PlayOnceParticle(ReplicatedStorage.Particle.RobuxPurchase, localCharacter.HumanoidRootPart.CFrame, 5)
    SoundHelper.PlaySound(ReplicatedStorage.Sound.Character.RobuxPurchase)
end

function PurchaseController:KnitInit()
end

function PurchaseController:KnitStart()

    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId, isShowResultGui: boolean)
        -- local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)

        if isShowResultGui == false then return end     -- false return， nil or true continue

        CommonResultClient.OpenResultGui(Constants.NOTIFICATION.PURCHASE_SUCCESS, playRobuxPurchaseEffect)
        SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER)
        GuiAnimationUtil.RibbonParticle(HomeGui)
    end)

    PurchaseService.PurchaseGiftSuccess:Connect(function(productId, isShowResultGui: boolean)
        if isShowResultGui == false then return end     -- false return， nil or true continue
        CommonResultClient.OpenResultGui(Constants.NOTIFICATION.PURCHASE_GIFT_SUCCESS, playRobuxPurchaseEffect)
        SoundHelper.PlaySound(Constants.SoundRes.GUI_HATCH_CHEER)
        GuiAnimationUtil.RibbonParticle(HomeGui)

        -- playRobuxPurchaseEffect()
    end)

    PurchaseService.ReceiveGiftSuccess:Connect(function(productId, senderName: string)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
        local purchaseName = PurchaseDataHelper.GetName(purchaseId)
        if senderName and purchaseName then
            NotificationClient.GreenNotify("🎉 Gift from " .. senderName .. ": " .. purchaseName)
            GuiAnimationUtil.RibbonParticle(HomeGui)
        end
    end)

    PurchaseService.PurchaseFail:Connect(function(failReason: any)
        local displayReason = if type(failReason) == "string" and failReason ~= "" then failReason else "Purchase failed!"
        CommonResultClient.OpenResultGui(Constants.NOTIFICATION.PURCHASE_FAIL:gsub("{failReason}", displayReason), nil)
    end)

    PurchaseService.PromptPurchaseFail:Connect(function(failReason: string)
        NotificationClient.RedNotify(failReason)
    end)
end

return PurchaseController

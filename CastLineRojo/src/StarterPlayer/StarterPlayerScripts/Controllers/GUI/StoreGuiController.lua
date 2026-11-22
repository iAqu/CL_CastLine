local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- local Player = require(ServerScriptService.Libs.Cmdr.BuiltInTypes.Player)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local CashPack = require(ReplicatedStorage.Modules.CashPack)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)
local PaidEggStoreView = require(ReplicatedStorage.Modules.PaidEggStoreView)

local localPlayer = Players.LocalPlayer
-- local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")

local StoreGui = PlayerGUI:WaitForChild("StoreGui")
local ScrollingFrame = StoreGui.Frame.MainFrame.ScrollingFrame
local GamePassContainer = ScrollingFrame.GamePassFrame.Container
local CodeFrame = ScrollingFrame.CodeFrame
local CodeTextBox = CodeFrame.CodeTextBox
local RedeemButton = CodeFrame.RedeemButton
-- local GamePassTemplate = GamePassContainer.GamePassTemplate
-- local VipTemplate = GamePassContainer.VipTemplate
local WinsContainer = ScrollingFrame.WinsFrame.Container
local WinsTemplate = WinsContainer.WinsTemplate
-- local GearFrame = ScrollingFrame.GearFrame
-- local GearTemplate = GearFrame.GearTemplate

local CloseButton = StoreGui.Frame.CloseButton
local GamePassTabButton = StoreGui.Frame.TopFrame.GamePass.GamePassButton
local WinsTabButton = StoreGui.Frame.TopFrame.Wins.WinsButton
local CodeTabButton = StoreGui.Frame.TopFrame.Code.CodeButton

local GiftButton = StoreGui.Frame.GiftFrame.GiftButton
local GiftedPlayerLabel = StoreGui.Frame.GiftFrame.GiftedPlayerLabel
-- local SwitchButton = StoreGui.Frame.GiftFrame.SwitchButton
local GENERATED_WINS_ATTRIBUTE = "GeneratedStoreWinsCard"

-- local selectedShopModel = nil
-- local initLimitedShopWorlds = {}
local shopModels = {}
-- local isClosingToLimitedShop = false
local isGifting = false
local giftRecipientId: number?
local isClosingToShopModel = false

local StoreGuiController = Knit.CreateController {
    Name = "StoreGuiController",
}

local function formatAssetId(assetId: string): string
    if assetId:match("^rbxassetid://") or assetId:match("^rbxasset://") or assetId:match("^https?://") then
        return assetId
    end
    return "rbxassetid://" .. assetId
end

function StoreGuiController:Init()
    GiftedPlayerLabel.Visible = false
    
    for _, frame in pairs(GamePassContainer:GetChildren()) do
        if frame:IsA("Frame") then
            frame.Visible = false
        end
    end

    for _, frame in pairs(WinsContainer:GetChildren()) do
        if frame:GetAttribute(GENERATED_WINS_ATTRIBUTE) then
            frame:Destroy()
        end
        if frame:IsA("Frame") and frame.Name == "WinsTemplate" then
            frame.Visible = false
        end
    end

    -- for _, frame in pairs(DiamondFrame:GetChildren()) do
    --     if frame:IsA("Frame") and frame.Name == "DiamondTemplate" then
    --         frame.Visible = false
    --     end
    -- end

end

local function initShopModels()
    shopModels = {}
    AreasWorkspace.forEachAreaContext(function(areaRoot)
        local items = areaRoot:FindFirstChild("Items")
        if not items then return end
        for _, item in pairs(items:GetChildren()) do
            if item.Name == "Shop" then
                table.insert(shopModels, item)
            end
        end
    end)
end

function StoreGuiController:OpenGui()
    if self._scrollTween then
        self._scrollTween:Cancel()
        self._scrollTween = nil
    end
    ScrollingFrame.CanvasPosition = Vector2.zero
    GuiAnimation.ResetNavigationFocus(StoreGui, CloseButton)
    GuiAnimation.OpenGui(StoreGui)
end

function StoreGuiController:SetGiftingState(isGiftingState: boolean, giftedPlayer: Player?)
    giftRecipientId = if isGiftingState and giftedPlayer then giftedPlayer.UserId else nil
    if isGiftingState then
        isGifting = true
        -- GiftButton.Text = "Cancel"
        GiftButton.Gift.Visible = false
        GiftButton.Cancel.Visible = true
        GiftedPlayerLabel.Visible = true
        if giftedPlayer then
            GiftedPlayerLabel.Text = "Gifting to: " .. giftedPlayer.DisplayName
        end
    else
        if isGifting then
            Knit.GetService("PurchaseService").CancelGift:Fire()
        end
        isGifting = false
        -- GiftButton.Text = "Gift"
        GiftButton.Gift.Visible = true
        GiftButton.Cancel.Visible = false
        GiftedPlayerLabel.Visible = false
    end
    if self._cashPackCards then
        self:SetCashPackRecipient(if isGifting then giftedPlayer else localPlayer)
    end
    if self._paidEggView then
        task.defer(function()
            self._paidEggView:Refresh()
        end)
    end
end

function StoreGuiController:OpenGuiFromGift(giftedPlayer: Player)
    if not giftedPlayer then warn("No gifted player found!") return end

    self:SetGiftingState(true, giftedPlayer)
    self:OpenGui()
end

-- function StoreGuiController:UpdateTokensLabel()
--     local playerData = PlayerDataController:GetData()
--     if not playerData then warn("No player data found!") return end

--     TokensLabel.Text = playerData.Tokens
-- end

function StoreGuiController:GenerateGamePassList()
    for _, card in GamePassContainer:GetChildren() do
        if card:IsA("GuiObject") and PurchaseDataHelper.IsRetired(card.Name) then
            card.Visible = false
        end
    end
    local gamePasses = PurchaseDataHelper.GetGamePassesData()
    local purchaseIds = {}
    for purchaseId in pairs(gamePasses) do
        table.insert(purchaseIds, purchaseId)
    end
    table.sort(purchaseIds, function(left, right)
        return gamePasses[left].Index < gamePasses[right].Index
    end)

    for _, purchaseId in ipairs(purchaseIds) do
        local purchaseData = gamePasses[purchaseId]
        local card = GamePassContainer:FindFirstChild(purchaseId)
        if not card or not card:IsA("Frame") then
            warn("StoreGuiController: missing GamePass card for " .. purchaseId)
            continue
        end

        local button = card:FindFirstChild("GamePassButton")
        if not button or not button:IsA("GuiButton") then
            warn("StoreGuiController: missing GamePassButton for " .. purchaseId)
            continue
        end

        card.Visible = true
        card.LayoutOrder = purchaseData.Index
        button.NameLabel.Text = purchaseData.Name
        button.GamePassImage.Image = formatAssetId(purchaseData.IconId)
        button.Frame.BuyButton.PriceLabel.Text = tostring(purchaseData.Price)
        button.DescriptionLabel.Text = PurchaseDataHelper.GetDescription(purchaseId)
        ButtonAnimation.SetUp(button)
        self:UpdateGamePass(purchaseId)

        button.Activated:Connect(function()
            local playerData = PlayerDataController:GetData()
            if not playerData then return end
            if purchaseId == Constants.GAMEPASS.MEGA_LUCK then
                Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId, not isGifting, giftRecipientId)
            elseif isGifting then
                Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId)
            elseif playerData.GamePasses[purchaseId] then
                NotificationClient.Notify(Constants.NOTIFICATION.ALREADY_OWN_GAME_PASS)
            else
                local productId = purchaseData.ProductId
                if type(productId) ~= "number" or productId <= 0 then
                    NotificationClient.RedNotify("Purchase unavailable.")
                    return
                end
                local opened, reason = pcall(MarketplaceService.PromptGamePassPurchase, MarketplaceService, localPlayer, productId)
                if not opened then
                    warn("Game pass prompt failed", purchaseId, reason)
                    NotificationClient.RedNotify("Could not open this purchase. Please try again.")
                end
            end
        end)
    end
end

function StoreGuiController:UpdateGamePass(purchaseId)
    if PurchaseDataHelper.IsRetired(purchaseId) then return end
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local frame = GamePassContainer:FindFirstChild(purchaseId)
    if not frame then
        -- if purchaseId ~= Constants.GAMEPASS.TELEPORT
        -- and purchaseId ~= Constants.GAMEPASS.AUTO_OPEN_CRATE
        -- and purchaseId ~= Constants.GAMEPASS.DOUBLE_SPEED then
        --     warn("No game pass found!", purchaseId)
        -- end
        return
    end

    if playerData.GamePasses[purchaseId] then
        -- frame.GamePassButton.BuyButton.Visible = false
        frame.GamePassButton.Frame.BuyButton.RobuxImage.Visible = false
        frame.GamePassButton.Frame.BuyButton.PriceLabel.Visible = false
        frame.GamePassButton.Frame.BuyButton.OwnedLabel.Visible = true
    else
        -- frame.GamePassButton.BuyButton.Visible = true
        frame.GamePassButton.Frame.BuyButton.RobuxImage.Visible = true
        frame.GamePassButton.Frame.BuyButton.PriceLabel.Visible = true
        frame.GamePassButton.Frame.BuyButton.OwnedLabel.Visible = false
    end
end

function StoreGuiController:GenerateWinsList()
    self._cashPackCards = {}
    local winsData = PurchaseDataHelper.GetWinsData()
    local purchaseIds = {}
    for purchaseId in pairs(winsData) do
        table.insert(purchaseIds, purchaseId)
    end
    table.sort(purchaseIds, function(left, right)
        return winsData[left].Index < winsData[right].Index
    end)

    local purchaseService = Knit.GetService("PurchaseService")
    for _, purchaseId in ipairs(purchaseIds) do
        local purchaseData = winsData[purchaseId]
        local clone = WinsTemplate:Clone()
        clone.Name = purchaseId
        clone:SetAttribute(GENERATED_WINS_ATTRIBUTE, true)
        clone.LayoutOrder = purchaseData.Index
        local button = clone.WinsButton
        button.WinsImage.Image = formatAssetId(purchaseData.IconId)
        button.Frame.BuyButton.PriceLabel.Text = tostring(purchaseData.Price)
        button.PackLabel.Text = purchaseData.Name

        if CashPack.Offers[purchaseId] then
            button.Interactable = false
            button.BuyNumLabel.Text = "Loading..."
            local card = { Button = button }
            self._cashPackCards[purchaseId] = card
            button.Activated:Connect(function()
                local recipient = self._cashPackRecipient
                if card.Amount and recipient and recipient.Parent == Players then
                    purchaseService.PromptPurchase:Fire(purchaseId, not isGifting, recipient.UserId, card.Amount)
                end
            end)
        else
            button.BuyNumLabel.Text = "+" .. NumberUtil.FormatWinsAmount(purchaseData.BuyNum)
            button.Activated:Connect(function()
                purchaseService.PromptPurchase:Fire(purchaseId)
            end)
        end
        clone.Parent = WinsTemplate.Parent
        clone.Visible = true
        ButtonAnimation.SetUp(button, 1.05)
    end
end

function StoreGuiController:RefreshCashPacks()
    local recipient = self._cashPackRecipient
    local baseRate = recipient and recipient:GetAttribute(PlotFishIncome.BASE_RATE_ATTRIBUTE)
    for purchaseId, card in self._cashPackCards do
        local amount = CashPack.GetAmount(purchaseId, baseRate)
        card.Amount = amount
        card.Button.Interactable = amount ~= nil
        card.Button.BuyNumLabel.Text = if amount then "+" .. NumberUtil.FormatWinsAmount(amount)
            elseif recipient then "Loading..." else "Unavailable"
    end
end

function StoreGuiController:SetCashPackRecipient(recipient: Player?)
    if self._cashPackRateConnection then
        self._cashPackRateConnection:Disconnect()
        self._cashPackRateConnection = nil
    end
    self._cashPackRecipient = if recipient and recipient.Parent == Players then recipient else nil
    if self._cashPackRecipient then
        self._cashPackRateConnection = recipient:GetAttributeChangedSignal(PlotFishIncome.BASE_RATE_ATTRIBUTE):Connect(function()
            self:RefreshCashPacks()
        end)
    end
    self:RefreshCashPacks()
end

function StoreGuiController:ScrollingToPosition(targetUiElement)
    if self._scrollTween then
        self._scrollTween:Cancel()
    end
    local y = ScrollingFrame.CanvasPosition.Y + targetUiElement.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y - 20
    self._scrollTween = TweenService:Create(ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, y),
    })
    self._scrollTween:Play()
end

-- function StoreGuiController:InitLimitedShop(worldIndex: number)
--     if initLimitedShopWorlds[worldIndex] then return end
--     initLimitedShopWorlds[worldIndex] = true

--     local currentWorldAreaIds = AreasDataHelper.GetAreaIdsByWorldIndex(worldIndex)
--     for _, areaId in pairs(currentWorldAreaIds) do
--         local area = Workspace.Areas:FindFirstChild(areaId)
--         if not area:FindFirstChild("Items") then continue end

--         local limitedShopModel = area.Items:FindFirstChild("LimitedShop")
--         if not limitedShopModel then continue end

--         DistanceDetectUtil.DetectTouchAndDistance(character, limitedShopModel, 12, function(isTouching)
--             if isTouching then
--                 if not isClosingToLimitedShop then
--                     task.delay(0.2, function()
--                         self:ScrollingToPosition(ScrollingFrame.LimitedLabel)
--                     end)
--                     GuiAnimation.OpenGui(StoreGui)
--                     isClosingToLimitedShop = true
--                 end
--             else
--                 if isClosingToLimitedShop == true then
--                     GuiAnimation.CloseGui(StoreGui)
--                     isClosingToLimitedShop = false
--                 end
--             end
--         end)
--     end
-- end

local function detectPlayerClosing()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    if not character then warn("No character found!") return end
    if not character:FindFirstChild("HumanoidRootPart") then return end

    local detected = nil
    for _, model in pairs(shopModels) do
        if not model.Parent or not model:IsDescendantOf(workspace) then continue end
        if not model.PrimaryPart then warn("No PrimaryPart in item = ", model.Name) continue end
        local Magnitude = (character.HumanoidRootPart.Position - model.PrimaryPart.Position).Magnitude
        if Magnitude <= 20 then
            detected = model
            break
        end
    end

    if detected then
        if not isClosingToShopModel then
            if not StoreGui.Enabled then
                StoreGuiController:OpenGui()
            end
            isClosingToShopModel = true
        end
    else
        if isClosingToShopModel then
            if StoreGui.Enabled then
                GuiAnimation.CloseGui(StoreGui)
            end
            isClosingToShopModel = false
        end
    end
end

function StoreGuiController:KnitInit()
    Knit.GetController("AreaController").LoadedNewWorldClientEvent:Connect(function(worldIndex: number)
        initShopModels()
    end)

    RedeemButton.Activated:Connect(function()
        local codeId = CodeTextBox.Text
        if codeId == "" then return end
        local CodesService = Knit.GetService("CodesService")
        CodesService:RedeemItem(codeId):andThen(function(result)
            if result == nil then warn("result is nil") return end
            if result.isSuccess then
                NotificationClient.SuccessNotify(result.resultText)
            else
                NotificationClient.Notify(result.resultText)
            end
            CodeTextBox.Text = ""
        end):catch(function(err)
            warn("StoreGuiController: code redemption failed", err)
            CodeTextBox.Text = ""
        end)
    end)
end

function StoreGuiController:KnitStart()
    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(StoreGui)
    end)

    GamePassTabButton.Activated:Connect(function()
        self:ScrollingToPosition(ScrollingFrame.GamePassFrame)
    end)

    WinsTabButton.Activated:Connect(function()
        self:ScrollingToPosition(ScrollingFrame.WinsFrame)
    end)

    CodeTabButton.Activated:Connect(function()
        self:ScrollingToPosition(ScrollingFrame.CodeFrame)
    end)

    GiftButton.Activated:Connect(function()
        if isGifting then
            -- Knit.GetService("PurchaseService").CancelGift:Fire()
            self:SetGiftingState(false)
        else
            Knit.GetController("StoreGiftMenuGuiController"):OpenGui()
        end
    end)

    -- game pass
    local PurchaseService = Knit.GetService("PurchaseService")
    PurchaseService.PurchaseSuccess:Connect(function(productId)
        task.delay(0, function()
            local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
            local purchaseType = PurchaseDataHelper.GetType(productId)
            if purchaseType == Constants.PURCHASE_TYPE.GAMEPASS then
                self:UpdateGamePass(purchaseId)
            end
        end)
    end)

    PurchaseService.ReceiveGiftSuccess:Connect(function(productId, senderName: string)
        local purchaseId = PurchaseDataHelper.GetPurchaseId(productId)
        local purchaseType = PurchaseDataHelper.GetType(productId)
        if purchaseType == Constants.PURCHASE_TYPE.GAMEPASS then
            self:UpdateGamePass(purchaseId)
        end
    end)

    local GamePassService = Knit.GetService("GamePassService")
    GamePassService.GiveGamePass:Connect(function(gamePassId: string)
        self:UpdateGamePass(gamePassId)
    end)

	StoreGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if StoreGui.Enabled == false then
                self:SetGiftingState(false)
            -- end
        end
    end)

    self:Init()
    initShopModels()
    self:GenerateGamePassList()
    self:GenerateWinsList()
    self:SetCashPackRecipient(localPlayer)
    Players.PlayerRemoving:Connect(function(player)
        if player == self._cashPackRecipient then
            self:SetCashPackRecipient(nil)
        end
    end)
    for _, frameName in ipairs({ "StarterPackFrame", "PotionFrame", "PacksFrame", "LimitedPetFrame" }) do
        local frame = ScrollingFrame:FindFirstChild(frameName)
        if frame and frame:IsA("GuiObject") then
            frame.Visible = false
        end
    end

    self._paidEggView = PaidEggStoreView.Bind(StoreGui, PurchaseService, Knit.GetService("PaidEggService"))

    RunService.Heartbeat:Connect(function()
        detectPlayerClosing()
    end)
    
end

return StoreGuiController

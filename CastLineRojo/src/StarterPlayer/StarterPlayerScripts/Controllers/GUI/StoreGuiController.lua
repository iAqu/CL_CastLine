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

function StoreGuiController:OpenGui(scrollingLabel: string?)
    -- self:SetGiftingState(false)
    GuiAnimation.OpenGui(StoreGui)
    if scrollingLabel ~= nil then
        local targetUiElement = ScrollingFrame.GamePassFrame
        if scrollingLabel == "Wins" then
            targetUiElement = ScrollingFrame.WinsFrame
        elseif scrollingLabel == "Code" then
            targetUiElement = ScrollingFrame.CodeFrame
        end

        if targetUiElement then
            task.delay(0.2, function()
                self:ScrollingToPosition(targetUiElement)
            end)
        end
    end
end

function StoreGuiController:SetGiftingState(isGiftingState: boolean, giftedPlayer: Player?)
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
end

function StoreGuiController:OpenGuiFromGift(giftedPlayer: Player)
    if not giftedPlayer then warn("No gifted player found!") return end

    StoreGuiController:SetGiftingState(true, giftedPlayer)
    GuiAnimation.OpenGui(StoreGui)
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
        button.DescriptionLabel.Text = purchaseData.Description
        ButtonAnimation.SetUp(button)
        self:UpdateGamePass(purchaseId)

        button.Activated:Connect(function()
            local playerData = PlayerDataController:GetData()
            if not playerData then return end
            if not isGifting and playerData.GamePasses[purchaseId] then
                NotificationClient.Notify(Constants.NOTIFICATION.ALREADY_OWN_GAME_PASS)
                return
            end
            Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId)
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
    local winsData = PurchaseDataHelper.GetWinsData()
    local purchaseIds = {}
    for purchaseId in pairs(winsData) do
        table.insert(purchaseIds, purchaseId)
    end
    table.sort(purchaseIds, function(left, right)
        return winsData[left].Index < winsData[right].Index
    end)

    for _, purchaseId in ipairs(purchaseIds) do
        local purchaseData = winsData[purchaseId]
        local clone = WinsTemplate:Clone()
        clone.Name = purchaseId
        clone:SetAttribute(GENERATED_WINS_ATTRIBUTE, true)
        clone.Visible = true
        clone.Parent = WinsTemplate.Parent
        clone.LayoutOrder = purchaseData.Index
        clone.WinsButton.WinsImage.Image = formatAssetId(purchaseData.IconId)
        clone.WinsButton.Frame.BuyButton.PriceLabel.Text = tostring(purchaseData.Price)
        clone.WinsButton.PackLabel.Text = purchaseData.Name
        -- clone.WinsButton.BuyNumLabel.Text = PurchaseDataHelper.GetBuyNum(purchaseId)

        ButtonAnimation.SetUp(clone.WinsButton, 1.05)
        clone.WinsButton.Activated:Connect(function()
            Knit.GetService("PurchaseService").PromptPurchase:Fire(purchaseId)
        end)
    end
    self:UpdateWins()
end

function StoreGuiController:UpdateWins()
    local playerdata = PlayerDataController:GetData()
    if not playerdata then warn("No player data found!") return end

    for _, frame in pairs(WinsContainer:GetChildren()) do
        if frame:IsA("Frame") then
            local purchaseId = frame.Name
            if not PurchaseDataHelper.GetData(purchaseId) then continue end

            -- local lastAreaId = AreasDataHelper.GetLastAreaId(playerdata)
            -- local areaIndex = AreasDataHelper.GetIndex(lastAreaId)
            -- local multiple = 1000 ^ (areaIndex - 1)
            -- local buyNum = NumberUtil.FormatNumberStartMWithDecimal(PurchaseDataHelper.GetBuyNum(purchaseId) * multiple)
            -- local buyNum = NumberUtil.FormatNumberStartKWithDecimal(GameDataUtil.CalculateWinTierCount(playerdata, purchaseId))
            local buyNum = NumberUtil.FormatWinsAmount(PurchaseDataHelper.GetBuyNum(purchaseId))
            -- if playerdata.LimitedPurchaseHistory[purchaseId] then
            --     frame.WinsButton.FirstPurchaseFrame.Visible = false
            -- else
            --     frame.WinsButton.FirstPurchaseFrame.Visible = true
            --     frame.WinsButton.FirstPurchaseFrame.MoreCountLabel.Text = "+" .. buyNum
            -- end

            frame.WinsButton.BuyNumLabel.Text = "+" .. buyNum
        end
    end
end

function StoreGuiController:ScrollingToPosition(targetUiElement)
    local y = ScrollingFrame.CanvasPosition.Y + targetUiElement.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y - 20
    -- TweenService:Create(ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, y)}):Play()
    -- local x = ScrollingFrame.CanvasPosition.X + targetUiElement.AbsolutePosition.X - ScrollingFrame.AbsolutePosition.X
    -- TweenService:Create(ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(x, 0)}):Play()
    TweenService:Create(ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, y)}):Play()
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
                GuiAnimation.OpenGui(StoreGui)
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

    PurchaseService.PurchaseLimitSuccess:Connect(function(purchaseId: string)
        task.delay(0, function()
            if PurchaseDataHelper.GetTypeByPurchaseId(purchaseId) == Constants.PURCHASE_TYPE.WINS then
                self:UpdateWins()
            end
        end)
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

    local PlayerDataService = Knit.GetService("PlayerDataService")
    -- PlayerDataService.TokensChanged:Connect(function()
    --     task.delay(0, function()
    --         self:UpdateTokensLabel()
    --     end)
    -- end)

    PlayerDataService.SuperRebirthsChanged:Connect(function()
        task.delay(0, function()
            self:UpdateWins()
        end)
    end)

    self:Init()
    initShopModels()
    self:GenerateGamePassList()
    self:GenerateWinsList()
    for _, frameName in ipairs({ "StarterPackFrame", "PotionFrame", "PacksFrame", "LimitedPetFrame", "LimitedEggFrame" }) do
        local frame = ScrollingFrame:FindFirstChild(frameName)
        if frame and frame:IsA("GuiObject") then
            frame.Visible = false
        end
    end

    RunService.Heartbeat:Connect(function()
        detectPlayerClosing()
    end)
    
end

return StoreGuiController

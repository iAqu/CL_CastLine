local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local MarketplaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local RotationGradientModule = require(ReplicatedStorage.Modules.RotationGradientModule)
local CommonResultClient = require(ReplicatedStorage.Modules.CommonResultClient)
local Timer = require(ReplicatedStorage.Packages.Timer)
local NotificationClient  = require(ReplicatedStorage.Modules.NotificationClient)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local GuiHelper = require(ReplicatedStorage.Modules.GuiHelper)
local MathUtil = require(ReplicatedStorage.Modules.MathUtil)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local HomeGui = PlayerGUI:WaitForChild("HomeGui")

local TradeGui = PlayerGUI:WaitForChild("TradeGui")
local MainFrame = TradeGui.Frame
local OtherInfoFrame = MainFrame.OtherInfoFrame
local ConfirmFrame = MainFrame.ConfirmFrame
local MyOfferFrame = MainFrame.MyOfferFrame
local OtherOfferFrame = MainFrame.OtherOfferFrame
local MyConfirmedLabel = MyOfferFrame.MyConfirmedLabel
local OtherConfirmedLabel = OtherOfferFrame.OtherConfirmedLabel
local MyOfferArrowImage = MainFrame.MyOfferArrowImage
local OtherOfferArrowImage = MainFrame.OtherOfferArrowImage
local MyDiamondTextBox = MainFrame.MyDiamondFrame.MyDiamondTextBox
-- local MyTokenTextBox = MainFrame.MyTokenFrame.MyTokenTextBox
local OtherDiamondLabel = MainFrame.OtherDiamondLabel
-- local OtherTokenLabel = MainFrame.OtherTokenLabel
local HintLabel = ConfirmFrame.HintLabel

local CloseButton = TradeGui.Frame.CloseButton

local TRADE_PROMPT_NAME = "TradePrompt"

local tradeConfirmCountDownTimer = nil
local isCountingDown = false
local tradeDiamondCount = 0

local isWaitingConfirm = false

local TradeGuiController = Knit.CreateController {
    Name = "TradeGuiController",
}

function TradeGuiController:IsTrading()
    if TradeGui.Enabled then
        return true
    else
        return false
    end
end

-- function TradeGuiController:Init()
local function Init()
end

local function Cleanup()
    isWaitingConfirm = false
    isCountingDown = false
    tradeDiamondCount = 0
    OtherDiamondLabel.Text = 0
    -- OtherTokenLabel.Text = 0
    MyDiamondTextBox.Text = "None"
    -- MyTokenTextBox.Text = "None"

    if tradeConfirmCountDownTimer then tradeConfirmCountDownTimer:Destroy() end

    MyOfferArrowImage.ImageColor3 = Constants.COLOR.BLUE
    OtherOfferArrowImage.ImageColor3 = Constants.COLOR.BLUE

    MyOfferFrame.UIStroke.Color = Constants.COLOR.BLUE
    OtherOfferFrame.UIStroke.Color = Constants.COLOR.BLUE

    -- ConfirmFrame.ConfirmButton.Text = BUTTON_CONFIRM_TEXT
    -- ConfirmFrame.ConfirmButton.BackgroundColor3 = Constants.COLOR.GREEN_LIGHT
    ConfirmFrame.ConfirmButton.Ready.Visible = true
    ConfirmFrame.ConfirmButton.Unconfirm.Visible = false
    for _, child in ConfirmFrame.ConfirmButton:GetChildren() do
        if child:IsA("UIStroke") then
            child.Color = Constants.COLOR.GREEN_DARK
        end
    end
    HintLabel.Text = Constants.TRADE_HINT.COMFIRM
end

local function UnacceptTrade()
    if tradeConfirmCountDownTimer then tradeConfirmCountDownTimer:Destroy() end
    isCountingDown = false
    MyConfirmedLabel.Visible = false
    MyOfferFrame.UIStroke.Color = Constants.COLOR.BLUE
    MyOfferArrowImage.ImageColor3 = Constants.COLOR.BLUE
    ConfirmFrame.ConfirmButton.Ready.Visible = true
    ConfirmFrame.ConfirmButton.Unconfirm.Visible = false
    HintLabel.Text = Constants.TRADE_HINT.COMFIRM
    for _, child in ConfirmFrame.ConfirmButton:GetChildren() do
        if child:IsA("UIStroke") then
            child.Color = Constants.COLOR.GREEN_DARK
        end
    end
    Knit.GetService("TradeService").TradeUnaccept:Fire()
end

local function TradeInputDiamond(count: number)
    OtherDiamondLabel.Text = count
end

-- local function TradeInputToken(count: number)
--     OtherTokenLabel.Text = count
-- end

local function UpdateOtherInfoLabel(target: Player)
    OtherInfoFrame.DisplayNameLabel.Text = target.DisplayName
    OtherInfoFrame.UserNameLabel.Text = "@" .. target.Name
    OtherInfoFrame.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(target.UserId, 60)
end

local function OpenTradeGui()
    GuiAnimation.OpenGui(TradeGui)
end

local function BeginTrade(targetId: number)
    LogHelper.Print("BeginTrade")
    local targetPlayer = Players:GetPlayerByUserId(targetId)
    if not targetPlayer then return end

    OtherConfirmedLabel.Visible = false
    MyConfirmedLabel.Visible = false

    Cleanup()
    HintLabel.Text = Constants.TRADE_HINT.COMFIRM

    UpdateOtherInfoLabel(targetPlayer)

    OpenTradeGui()
    LogHelper.Print("BeginTrade end")
end

local function Decline()
    LogHelper.Print("Decline")
    Cleanup()
    GuiAnimation.CloseGui(TradeGui)
    CommonResultClient.OpenResultGui(Constants.NOTIFICATION.TRADE_DECLINE)
end

local function TradeCompleted(isWaiting: boolean)
    isWaitingConfirm = isWaiting
    LogHelper.Print("TradeCompleted")
    if isWaiting then
         -- 显示等待确认的提示
         HintLabel.Text = "⏳ Confirming trade..."
         return
    end

    Cleanup()
    GuiAnimation.CloseGui(TradeGui)
    CommonResultClient.OpenResultGui(Constants.NOTIFICATION.TRADE_SUCCESS)
end

local function TradeFail(failText: string)
    LogHelper.Print("TradeFail")
    Cleanup()
    GuiAnimation.CloseGui(TradeGui)
    CommonResultClient.OpenResultGui(failText)
end

local function TradeAccept()
	OtherConfirmedLabel.Visible = true
    OtherOfferFrame.UIStroke.Color = Constants.COLOR.GREEN_LIGHT
    OtherOfferArrowImage.ImageColor3 = Constants.COLOR.GREEN_LIGHT
end

local function TradeUnaccept()
    isCountingDown = false
    if tradeConfirmCountDownTimer then tradeConfirmCountDownTimer:Destroy() end
    HintLabel.Text = Constants.TRADE_HINT.COMFIRM

	OtherConfirmedLabel.Visible = false
    OtherOfferFrame.UIStroke.Color = Constants.COLOR.BLUE
    OtherOfferArrowImage.ImageColor3 = Constants.COLOR.BLUE
end

local function TradeConfirmCountDown()
    isCountingDown = true
    local countDownStartTime = os.time()
    HintLabel.Text = Constants.TRADE_HINT.COUNTDOWN
    if tradeConfirmCountDownTimer then tradeConfirmCountDownTimer:Destroy() end
    tradeConfirmCountDownTimer = Timer.new(0.1)
    tradeConfirmCountDownTimer.Tick:Connect(function()
        if isWaitingConfirm then return end
        local lastTime = Constants.TRADE_TIME.CONFIRM_COOLDOWN - (os.time() - countDownStartTime)
        if (lastTime > 0) then
            HintLabel.Text = Constants.TRADE_HINT.COUNTDOWN:gsub("#TIME", lastTime)
        else
            HintLabel.Text = Constants.TRADE_HINT.COUNTDOWN:gsub("#TIME", 0)
        end
    end)
    tradeConfirmCountDownTimer:Start()
end

local function clearTradePrompts(character: Model?)
    if not character then
        return
    end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == TRADE_PROMPT_NAME then
            descendant:Destroy()
        end
    end
end

function TradeGuiController:KnitInit()
    TradeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if TradeGui.Enabled then
            HomeGui.Enabled = false
        else
            HomeGui.Enabled = true
        end
    end)
    Init()
end

function TradeGuiController:KnitStart()
    local TradeService = Knit.GetService("TradeService")

    local function closeTrade()
        if isWaitingConfirm then
            NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_WAITING_CONFIRM)
            return
        end
        TradeService.TradeDeclined:Fire()
        Decline()
    end

    GuiAnimation.SetNavigationOptions(TradeGui, nil, closeTrade)
    CloseButton.Activated:Connect(closeTrade)

    ConfirmFrame.CancelButton.Activated:Connect(closeTrade)

    TradeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if TradeGui.Enabled == false then
            LogHelper.Print("TradeGui:GetPropertyChangedSignal TradeGui.Enabled == false")
            TradeService.TradeDeclined:Fire()
            DistanceDetectUtil.EnableDetecting(true)
        else
            DistanceDetectUtil.EnableDetecting(false)
        end
    end)

    ConfirmFrame.ConfirmButton.Activated:Connect(function()
        if isWaitingConfirm then
            NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_WAITING_CONFIRM)
            return
        end
        -- if ConfirmFrame.ConfirmButton.Text == BUTTON_CONFIRM_TEXT then
        if ConfirmFrame.ConfirmButton.Ready.Visible then
            MyConfirmedLabel.Visible = true
            MyOfferFrame.UIStroke.Color = Constants.COLOR.GREEN_LIGHT
            MyOfferArrowImage.ImageColor3 =  Constants.COLOR.GREEN_LIGHT
            -- ConfirmFrame.ConfirmButton.Text = BUTTON_UNCONFIRM_TEXT
            -- ConfirmFrame.ConfirmButton.BackgroundColor3 = Constants.COLOR.RED
            ConfirmFrame.ConfirmButton.Ready.Visible = false
            ConfirmFrame.ConfirmButton.Unconfirm.Visible = true
            for _, child in ConfirmFrame.ConfirmButton:GetChildren() do
                if child:IsA("UIStroke") then
                    child.Color = Constants.COLOR.RED_DARK
                end
            end
            TradeService.TradeAccept:Fire()
        else
            UnacceptTrade()
        end
    end)

    MyDiamondTextBox.FocusLost:Connect(function()
        if isWaitingConfirm then
            NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_WAITING_CONFIRM)
            return
        end

        if isCountingDown then
            MyDiamondTextBox.Text = tradeDiamondCount
            return
        end
        -- if ConfirmFrame.ConfirmButton.Text == BUTTON_UNCONFIRM_TEXT then
        if ConfirmFrame.ConfirmButton.Unconfirm.Visible then
            UnacceptTrade()
        end
        local diamondCount = tonumber(MyDiamondTextBox.Text)
        if MathUtil.IsNaN(diamondCount) or MathUtil.IsInfinity(diamondCount) or type(diamondCount) ~= "number"
        or not MathUtil.IsInteger(diamondCount) then
            NotificationClient.RedNotify(Constants.NOTIFICATION.WRONG_INPUT)
            MyDiamondTextBox.Text = "None"
            Knit.GetService("TradeService").TradeInputDiamond:Fire(0)
            return
        end
        if diamondCount then
            if diamondCount > PlayerDataController:GetData().Diamonds then
                NotificationClient.RedNotify(Constants.NOTIFICATION_NO_ENOUGH_DIAMOND)
                MyDiamondTextBox.Text = "None"
                Knit.GetService("TradeService").TradeInputDiamond:Fire(0)
                tradeDiamondCount = 0
            elseif diamondCount < 0 then
                MyDiamondTextBox.Text = "None"
                Knit.GetService("TradeService").TradeInputDiamond:Fire(0)
                tradeDiamondCount = 0
            else
                Knit.GetService("TradeService").TradeInputDiamond:Fire(diamondCount)
                tradeDiamondCount = diamondCount
            end
        else
            MyDiamondTextBox.Text = "None"
            Knit.GetService("TradeService").TradeInputDiamond:Fire(0)
            tradeDiamondCount = 0
        end
    end)

    -- MyTokenTextBox.FocusLost:Connect(function()
    --     if isCountingDown then
    --         MyTokenTextBox.Text = tradeTokenCount
    --         return
    --     end
    --     if ConfirmFrame.ConfirmButton.Text == BUTTON_UNCONFIRM_TEXT then
    --         UnacceptTrade()
    --     end
       
    --     local tokenCount = tonumber(MyTokenTextBox.Text)
    --     if MathUtil.IsNaN(tokenCount) or MathUtil.IsInfinity(tokenCount) or type(tokenCount) ~= "number"
    --     or not MathUtil.IsInteger(tokenCount) then
    --         NotificationClient.RedNotify(Constants.NOTIFICATION.WRONG_INPUT)
    --         MyTokenTextBox.Text = "None"
    --         Knit.GetService("TradeService").TradeInputToken:Fire(0)
    --         return
    --     end
    --     if tokenCount then
    --         if tokenCount > PlayerDataController:GetData().Tokens then
    --             NotificationClient.RedNotify(Constants.NOTIFICATION.TOKENS_NOT_ENOUGH)
    --             MyTokenTextBox.Text = "None"
    --             Knit.GetService("TradeService").TradeInputToken:Fire(0)
    --         elseif tokenCount < 0 then
    --             MyTokenTextBox.Text = "None"
    --             Knit.GetService("TradeService").TradeInputToken:Fire(0)
    --         else
    --             Knit.GetService("TradeService").TradeInputToken:Fire(tokenCount)
    --         end
    --     else
    --         MyTokenTextBox.Text = "None"
    --         Knit.GetService("TradeService").TradeInputToken:Fire(0)
    --         tradeTokenCount = 0
    --     end
    -- end)

    TradeService.TradeBegan:Connect(BeginTrade)
    TradeService.TradeDeclined:Connect(Decline)
    TradeService.TradeInputDiamond:Connect(TradeInputDiamond)
    -- TradeService.TradeInputToken:Connect(TradeInputToken)
    TradeService.TradeAccept:Connect(TradeAccept)
    TradeService.TradeUnaccept:Connect(TradeUnaccept)
    TradeService.TradeCompleted:Connect(TradeCompleted)
    TradeService.TradeFail:Connect(TradeFail)
    TradeService.TradeConfirmCountDown:Connect(TradeConfirmCountDown)

    for _, player in ipairs(Players:GetPlayers()) do
        clearTradePrompts(player.Character)
        player.CharacterAdded:Connect(clearTradePrompts)
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(clearTradePrompts)
    end)

    GuiUtil.AutoResizeScrollingFrame(TradeGui)
end

return TradeGuiController

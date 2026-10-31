local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local DistanceDetectUtil = require(ReplicatedStorage.Modules.DistanceDetectUtil)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local PlayerGUI = localPlayer:WaitForChild("PlayerGui")
local TradeMenuGui = PlayerGUI:WaitForChild("TradeMenuGui")
local CloseButton = TradeMenuGui.Frame:WaitForChild("CloseButton")
local SwitchButton = TradeMenuGui.Frame.SettingsFrame.SwitchButton

local ScrollingFrame = TradeMenuGui.Frame.ScrollingFrame
local PlayerTemplate = ScrollingFrame.Template
local PlayerDisableTemplate = ScrollingFrame.Template_Disabled

-- local LockFrame = TradeMenuGui.Frame.LockFrame

local TradeMenuGuiController = Knit.CreateController {
    Name = "TradeMenuGuiController",
    _CurrentRebirth = nil,
    _CurrentStrength = nil,
}

local isUpdating = false

function TradeMenuGuiController:InitGui()
    for _, Template in pairs(ScrollingFrame:GetChildren()) do
        if Template:IsA("Frame") then
            Template.Visible = false
            if Template.Name == "Template" then
                Template.Button.SendImage.Visible = true
                Template.Button.PendingLabel.Visible = false
            end
        end
    end
end

function TradeMenuGuiController:UpdateLockState()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    -- if playerData.Rebirths >= 3 then
    --     LockFrame.Visible = false
    -- else
    --     LockFrame.Visible = true
    -- end
end

function TradeMenuGuiController:GeneratePlayer(player: Player, settingValue: boolean)
    if player == localPlayer then return end    -- Comment this line to test trade with yourself

    local clone = settingValue and PlayerTemplate:Clone() or PlayerDisableTemplate:Clone()
    clone.Parent = ScrollingFrame
    clone.LayoutOrder = settingValue and 1 or 2
    clone.Name = player.UserId
    clone.Button.DisplayNameLabel.Text = player.DisplayName
    clone.Button.UserNameLabel.Text = "@" .. player.Name
    clone.Button.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(player.UserId, 48)
    clone.Visible = true

    -- ButtonAnimation.SetUp(clone:WaitForChild("Button"), 1.05)
    if not clone:FindFirstChild("Button") then return end

    ButtonAnimation.SetUp(clone.Button, 1.05)

    clone.Button.Activated:Connect(function()
        if not settingValue then return end

        if clone.Button.SendImage.Visible == false then
            NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_REQUEST_FAIL_WAIT)
            return
        end

        local TradeService = Knit.GetService("TradeService")
        TradeService:SendTradeRequest(player.UserId):andThen(function(result)
            if result.Success then
                clone.Button.SendImage.Visible = false
                clone.Button.PendingLabel.Visible = true

                task.delay(Constants.TRADE_TIME.REQUEST_COOLDOWN, function()
                    clone.Button.SendImage.Visible = true
                    clone.Button.PendingLabel.Visible = false
                end)

                NotificationClient.GreenNotify(result.ResultText)
            else

                NotificationClient.WhiteNotify(result.ResultText)
            end
        end)
    end)
end

function TradeMenuGuiController:UpdatePending(player: Player, isPending: boolean)
    local playerTemplate = ScrollingFrame:FindFirstChild(player.UserId)
    if playerTemplate then
        playerTemplate.Button.SendImage.Visible = not isPending
        playerTemplate.Button.PendingLabel.Visible = isPending
    end
end

function TradeMenuGuiController:GenerateDisabledPlayer(player: Player)
    if player == localPlayer then return end

    local clone = PlayerDisableTemplate:Clone()
    clone.Parent = ScrollingFrame

    clone.Name = player.UserId
    clone.Button.DisplayNameLabel.Text = player.DisplayName
    clone.Button.UserNameLabel.Text = "@" .. player.Name
    clone.Button.AvatarImage.Image = PlayerThumbnailUtil.GetHeadshot(player.UserId, 48)
    clone.Visible = true

    ButtonAnimation.SetUp(clone.Button, 1.05)
    clone.Button.Activated:Connect(function()

        if clone.Button.SendImage.Visible == false then 
            NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_REQUEST_FAIL_WAIT)
            return
        end

        local TradeService = Knit.GetService("TradeService")
        TradeService:SendTradeRequest(player.UserId):andThen(function(result)
            if result.Success then
                clone.Button.SendImage.Visible = false
                clone.Button.PendingLabel.Visible = true

                task.delay(Constants.TRADE_TIME.REQUEST_COOLDOWN, function()
                    clone.Button.SendImage.Visible = true
                    clone.Button.PendingLabel.Visible = false
                end)

                NotificationClient.GreenNotify(result.ResultText)
            else

                NotificationClient.WhiteNotify(result.ResultText)
            end
        end)
    end)
end

local function UpdateTradeMenuGui(player: Player, settingValue: boolean)
    if isUpdating then return end       -- prevent ProfileLoaded event and GetAllPlayersTradeSetting function at the same time when two players join the game
    local playerTemplate = ScrollingFrame:FindFirstChild(tostring(player.UserId))
    if playerTemplate then
        playerTemplate:Destroy()
    end
    TradeMenuGuiController:GeneratePlayer(player, settingValue)
    isUpdating = false
end

function TradeMenuGuiController:UpdateSettingButtons()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    if playerData.Settings[Constants.SETTINGS_ID.TRADE] == true then
        -- SwitchButton.Text = "Trade: On"
        -- SwitchButton.BackgroundColor3 = Constants.COLOR.GREEN
        -- SwitchButton.UIStroke.Color = Constants.COLOR.GREEN_DARK
        SwitchButton.ON.Visible = true
        SwitchButton.OFF.Visible = false
    else
        -- SwitchButton.Text = "Trade: Off"
        -- SwitchButton.BackgroundColor3 = Constants.COLOR.RED
        -- SwitchButton.UIStroke.Color = Constants.COLOR.RED_DARK
        SwitchButton.ON.Visible = false
        SwitchButton.OFF.Visible = true
    end
end

function TradeMenuGuiController:KnitInit()
    self:InitGui()

    CloseButton.Activated:Connect(function()
        GuiAnimation.CloseGui(TradeMenuGui)
    end)
end

function TradeMenuGuiController:KnitStart()
    SwitchButton.Activated:Connect(function()
        local playerData = PlayerDataController:GetData()
        if not playerData then warn("No player data found!") return end

        Knit.GetService("SettingsService").ChangeSetting:Fire(Constants.SETTINGS_ID.TRADE, not playerData.Settings[Constants.SETTINGS_ID.TRADE])
        playerData.Settings[Constants.SETTINGS_ID.TRADE] = not playerData.Settings[Constants.SETTINGS_ID.TRADE]

        self:UpdateSettingButtons()
    end)

    Players.PlayerRemoving:Connect(function(player)
        local playerTemplate = ScrollingFrame:FindFirstChild(player.UserId)
        if playerTemplate then
            playerTemplate:Destroy()
        end
    end)

    local TradeService = Knit.GetService("TradeService")
    TradeService.RequestBeIgnored:Connect(function(targetPlayer: Player)
        self:UpdatePending(targetPlayer, false)
        NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_REQUEST_FAIL_BE_IGNORED:gsub("#NAME", targetPlayer.DisplayName), 6)
    end)

    local SettingsService = Knit.GetService("SettingsService")
    SettingsService.ChangeSetting:Connect(function(player: Player, settingId: string, settingValue: boolean)
        if settingId == Constants.SETTINGS_ID.TRADE then
            UpdateTradeMenuGui(player, settingValue)
        end
    end)

    -- local PlayerDataService = Knit.GetService("PlayerDataService")
    -- PlayerDataService.RebirthsChanged:Connect(function(player: Player, rebirths: number)
    --     task.delay(0, function()
    --         self:UpdateLockState()
    --     end)
    -- end)
    task.delay(1, function()    -- prevent ProfileLoaded event and GetAllPlayersTradeSetting function at the same time when two players join the game
        SettingsService:GetAllPlayersTradeSetting():andThen(function(result)
            for userId, settingValue in pairs(result) do
                UpdateTradeMenuGui(Players:GetPlayerByUserId(userId), settingValue)
            end
        end)
    end)

    self:UpdateSettingButtons()
    -- self:UpdateLockState()

    GuiUtil.AutoResizeScrollingFrame(TradeMenuGui)
end

return TradeMenuGuiController

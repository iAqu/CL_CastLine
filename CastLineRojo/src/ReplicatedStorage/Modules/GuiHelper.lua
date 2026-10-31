local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local Constants = require(ReplicatedStorage.Modules.Constants)

local GuiHelper = {}

local currentGuis = {}
local isHideMode = false

function GuiHelper.CanOpenGui(): boolean
    if Knit.GetController("TradeGuiController"):IsTrading() then
        NotificationClient.WhiteNotify(Constants.NOTIFICATION.TRADE_IN_PROGRESS)
        return false
    end

    return true
end

function GuiHelper.CanWorkInFight(): boolean
    return true
end

return GuiHelper
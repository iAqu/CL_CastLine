local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local Knit = require(ReplicatedStorage.Packages.Knit)

local TestMoneyController = Knit.CreateController {
    Name = "TestMoneyController",
}

function TestMoneyController:KnitInit()
    LogHelper.Print("TestMoneyController initialized")
end

function TestMoneyController:KnitStart()

    local function ObserveMoney(money)
        LogHelper.Print("Money: " .. money)
    end

    local TestMoneyService = Knit.GetService("TestMoneyService")
    TestMoneyService:GetMoney():andThen(ObserveMoney)
    TestMoneyService.MoneyChanged:Connect(ObserveMoney)

    LogHelper.Print("TestMoneyController started")
end

return TestMoneyController
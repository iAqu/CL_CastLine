local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local TestMoneyService = Knit.CreateService {
    Name = "TestMoneyService",
    Client = {
        MoneyChanged = Knit.CreateSignal(),
    },
    _MoneyPerPlayer = {},
    _StartingMoney = 100,
}

function TestMoneyService.Client:GetMoney(player: Player)
    return self.Server:GetMoney(player)
end

function TestMoneyService:GetMoney(player: Player)
    local money = self._MoneyPerPlayer[player] or self._StartingMoney
    return money
end

function TestMoneyService:AddMoney(player: Player, amount: number)
    local currentMoney = self:GetMoney(player)
    if amount > 0 then
        local newMoney = currentMoney + amount
        self._MoneyPerPlayer[player] = newMoney
        self.Client.MoneyChanged:Fire(player, newMoney)
    end
end

function TestMoneyService:KnitStart()
    LogHelper.Print("TestMoneyService started")

    -- This is a test to see if the service can be used to add money to players
    -- while true do
    --     task.wait(1)
    --     for _,player in ipairs(Players:GetPlayers()) do
    --         self:AddMoney(player, 1)
    --     end
    -- end
end

function TestMoneyService:KnitInit()
    LogHelper.Print("TestMoneyService initialized")
    Players.PlayerRemoving:Connect(function(player)
        self._MoneyPerPlayer[player] = nil
    end)
end

return TestMoneyService

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BalanceConfig = require(ReplicatedStorage.Shared.Flags.BalanceConfig)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(script.Parent.Parent.Internal.ProductTypes)

local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Desc = "Purchase bonus money!",
    HoldWhilePending = true
}

local function withDefaults(p1) -- line: 21
    -- upvalues: t1 (copy)
    local v1 = table.clone(t1)

    for v2, v3 in p1 do
        v1[v2] = v3
    end

    return v1
end

local function rewardAmountFrom(p2) -- line: 29
    local v4 = string.match(p2, "^Money_(%d+)$")

    if v4 == nil then
        error((("money product \"%*\" must be named Money_<amount>"):format(p2)))
    end

    local v5 = tonumber(v4)

    if v5 == nil or v5 <= 0 then
        error((("money product \"%*\" must carry a positive amount"):format(p2)))
    end

    return v5
end

local function moneyLabel(p3) -- line: 41
    -- upvalues: Simple (copy)
    return (("$%* Money"):format((Simple.FormatCompact(p3, ".#"))))
end

local function profileReady(p4) -- line: 45
    if p4 then
        return true
    end

    return false, "Player data is not loaded yet."
end

local function CreateMoneyProductConfig(p5, p6) -- line: 52
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), BalanceConfig (copy), Simple (copy), t (copy), t1 (copy), rewardAmountFrom (copy), profileReady (copy)
    t.strict(t.string)(p5)
    t.strict(t.number)(p6)

    local v6 = BalanceConfig.Bind("Game.Balance.ProductRewards." .. p5, {
        Amount = rewardAmountFrom(p5)
    }, true, false, function(p7) -- line: 64
        assert(p7.Amount > 0)
    end)

    local function authorize(p8) -- line: 69
        -- upvalues: ServerScriptService (copy), profileReady (copy)
        local v8, v9 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p8)

        if v8 then
            return profileReady(v9)
        end

        return false, "Failed to retrieve player data."
    end

    local function precheck() -- line: 78
        -- upvalues: ReplicatedStorage (copy), profileReady (copy)
        return profileReady(require(ReplicatedStorage.Shared.Save).Await())
    end

    local function grant(p9) -- line: 83
        -- upvalues: v6 (copy), ServerScriptService (copy)
        require(ServerScriptService.Controllers.MoneyService).AddMoney(p9, v6.Amount, {
            source = "DevProduct"
        })

        return true
    end

    local t2 = {
        Name = p5,
        ProductId = p6
    }
    local Amount = v6.Amount

    t2.DisplayName = ("$%* Money"):format((Simple.FormatCompact(Amount, ".#")))
    t2.Precheck = precheck
    t2.Authorize = authorize
    t2.Grant = grant

    local v10 = table.clone(t1)

    for v11, v12 in t2 do
        v10[v11] = v12
    end

    BalanceConfig.Changed:Connect(function() -- line: 99
        -- upvalues: v6 (copy), v10 (copy), Simple (copy)
        local Amount = v6.Amount

        v10.DisplayName = ("$%* Money"):format((Simple.FormatCompact(Amount, ".#")))
    end)

    return v10
end

return CreateMoneyProductConfig

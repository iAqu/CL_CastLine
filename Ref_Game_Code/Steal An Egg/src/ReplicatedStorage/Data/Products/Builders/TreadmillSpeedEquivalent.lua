-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)

local function canPurchase(p1) -- line: 23
    if p1 == nil then
        return false, "Player data is not loaded yet."
    end

    return true, nil
end

local function CreateTreadmillSpeedEquivalentProductConfig(p2, p3, p4) -- line: 31
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), TreadmillUtil (copy), t (copy), canPurchase (copy)
    t.strict(t.string)(p2)
    t.strict(t.number)(p3)
    t.strict(t.number)(p4)
    assert(p3 > 0, "Treadmill equivalent product id must be positive")
    assert(p4 > 0, "Treadmill equivalent duration must be positive")

    local v3 = require(ReplicatedStorage.Shared.Flags.BalanceConfig).Bind("Game.Balance.TreadmillProductRewards." .. tostring(p3), {
        DurationSeconds = p4
    }, true, false, function(p5) -- line: 47
        assert(p5.DurationSeconds > 0)
    end)

    local function durationLabel() -- line: 52
        -- upvalues: v3 (copy), TreadmillUtil (copy)
        return TreadmillUtil.FormatTreadmillSpeedEquivalentDuration(v3.DurationSeconds)
    end

    local function authorize(p6) -- line: 56
        -- upvalues: ServerScriptService (copy), t (copy), canPurchase (copy)
        t.strict(t.instanceIsA("Player"))(p6)

        local v5, v6 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p6)

        if v5 then
            return canPurchase(v6)
        end

        return false, "Player data is not loaded yet."
    end

    local function precheck() -- line: 69
        -- upvalues: ReplicatedStorage (copy), canPurchase (copy)
        return canPurchase(require(ReplicatedStorage.Shared.Save).Await())
    end

    local function grant(p7) -- line: 75
        -- upvalues: v3 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p7)

        local v7, v8 = require(ServerScriptService.Controllers.SpeedPowerService).AddTreadmillEquivalentSpeedPower(p7, v3.DurationSeconds)

        if not v7 then
            return false, 0
        end

        require(ServerScriptService.Library.Functions.NotifyItem)(p7, {
            Kind = "SpeedPower",
            Amount = v8
        })

        return true, v8
    end

    local t1 = {
        Desc = "Instantly gain the speed you currently earn on your treadmill.",
        HoldWhilePending = true,
        Name = p2,
        ProductId = p3,
        DisplayName = ("Speed - %*"):format((TreadmillUtil.FormatTreadmillSpeedEquivalentDuration(v3.DurationSeconds))),
        TreadmillSpeedEquivalentDurationSeconds = v3.DurationSeconds,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant
    }

    require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 103
        -- upvalues: v3 (copy), t1 (copy), TreadmillUtil (copy)
        t1.TreadmillSpeedEquivalentDurationSeconds = v3.DurationSeconds
        t1.DisplayName = ("Speed - %*"):format((TreadmillUtil.FormatTreadmillSpeedEquivalentDuration(v3.DurationSeconds)))
    end)

    return t1
end

return CreateTreadmillSpeedEquivalentProductConfig

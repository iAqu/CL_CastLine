-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)

local function canPurchaseTemporarySpeedBoost(p1) -- line: 27
    if p1 == nil then
        return false, "Data not loaded"
    end

    return true
end

local function CreateTemporarySpeedBoostProductConfig(p2, p3, p4) -- line: 35
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), TreadmillUtil (copy), t (copy), canPurchaseTemporarySpeedBoost (copy)
    t.strict(t.string)(p2)
    t.strict(t.number)(p3)
    t.strict(t.number)(p4)
    assert(p4 > 0, "Temporary speed boost duration must be positive")

    local v2 = require(ReplicatedStorage.Shared.Flags.BalanceConfig).Bind("Game.Balance.ProductRewards." .. p2, {
        DurationSeconds = p4
    }, true, false, function(p5) -- line: 50
        assert(p5.DurationSeconds > 0)
    end)

    local function durationLabel() -- line: 55
        -- upvalues: v2 (copy), TreadmillUtil (copy)
        return TreadmillUtil.FormatTemporarySpeedBoostProductDuration(v2.DurationSeconds)
    end

    local function authorize(p6) -- line: 59
        -- upvalues: ServerScriptService (copy), t (copy), canPurchaseTemporarySpeedBoost (copy)
        t.strict(t.instanceIsA("Player"))(p6)

        local v4, v5 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p6)

        if not v4 or not v5 then
            return false, "Player profile not found"
        end

        return canPurchaseTemporarySpeedBoost(v5)
    end

    local function precheck() -- line: 73
        -- upvalues: ReplicatedStorage (copy), canPurchaseTemporarySpeedBoost (copy)
        return canPurchaseTemporarySpeedBoost(require(ReplicatedStorage.Shared.Save).Await())
    end

    local function grant(p7) -- line: 79
        -- upvalues: v2 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p7)

        return require(ServerScriptService.Controllers.SpeedPowerService).AddTemporarySpeedBoostDuration(p7, v2.DurationSeconds)
    end

    local t1 = {
        HoldWhilePending = true,
        Name = p2,
        ProductId = p3,
        DisplayName = ("x2 Speed Boost (%*)"):format((TreadmillUtil.FormatTemporarySpeedBoostProductDuration(v2.DurationSeconds))),
        Desc = ("Double all speed gains for %*."):format((TreadmillUtil.FormatTemporarySpeedBoostProductDuration(v2.DurationSeconds))),
        TemporarySpeedBoostDurationSeconds = v2.DurationSeconds,
        TemporarySpeedBoostMultiplier = TreadmillUtil.GetTemporarySpeedBoostMultiplier(),
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant
    }

    require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 99
        -- upvalues: v2 (copy), t1 (copy), TreadmillUtil (copy)
        t1.TemporarySpeedBoostDurationSeconds = v2.DurationSeconds
        t1.TemporarySpeedBoostMultiplier = TreadmillUtil.GetTemporarySpeedBoostMultiplier()
        t1.DisplayName = ("x2 Speed Boost (%*)"):format((TreadmillUtil.FormatTemporarySpeedBoostProductDuration(v2.DurationSeconds)))
        t1.Desc = ("Double all speed gains for %*."):format((TreadmillUtil.FormatTemporarySpeedBoostProductDuration(v2.DurationSeconds)))
    end)

    return t1
end

return CreateTemporarySpeedBoostProductConfig

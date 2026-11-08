-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)

local function validateTier(p1, p2) -- line: 28
    -- upvalues: TreadmillUtil (copy)
    if p1 == nil then
        return false, "Data not loaded"
    end

    local v1 = TreadmillUtil.ResolveSpeedBoostTierIndex(p1)

    if TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX <= v1 then
        return false, "Max speed boost owned"
    end

    if p2 == v1 + 1 then
        return true
    end

    return false, "Purchase the previous speed boost first"
end

local function CreateSpeedBoostProductConfig(p3, p4, p5, p6) -- line: 45
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), Constants (copy), TreadmillUtil (copy), t (copy), validateTier (copy)
    t.strict(t.string)(p3)
    t.strict(t.number)(p4)
    t.strict(t.number)(p5)
    t.strict(t.number)(p6)

    if Constants.IS_STUDIO then
        assert(p5 >= 1 and p5 <= TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX, (("Invalid speed boost tier index %*"):format(p5)))
        assert(TreadmillUtil.GetSpeedBoostMultiplierForTierIndex(p5) == p6, (("Invalid speed boost multiplier %* for tier %*"):format(p6, p5)))
    end

    local v6 = TreadmillUtil.FormatSpeedMultiplierValue(p6)

    local function authorize(p7) -- line: 69
        -- upvalues: p5 (copy), ServerScriptService (copy), t (copy), validateTier (copy)
        t.strict(t.instanceIsA("Player"))(p7)

        local v7, v8 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p7)

        if not v7 or not v8 then
            return false, "Player profile not found"
        end

        return validateTier(v8, p5)
    end

    local function ResolveFailedReceipt(p8, _, _) -- line: 81
        -- upvalues: p5 (copy), ServerScriptService (copy), TreadmillUtil (copy)
        local Database = require(ServerScriptService.Library.Database)

        if not Database.IsPlayerLoaded(p8) then
            return "Retry"
        end

        local v9, v10 = Database.UnsafeGetProfileAwait(p8)

        if not v9 or not v10 then
            return "Retry"
        end

        if TreadmillUtil.ResolveSpeedBoostTierIndex(v10) >= p5 then
            return "Satisfied"
        end

        return "Credit"
    end

    local function precheck() -- line: 100
        -- upvalues: p5 (copy), ReplicatedStorage (copy), validateTier (copy)
        return validateTier(require(ReplicatedStorage.Shared.Save).Await(), p5)
    end

    local function grant(p11) -- line: 105
        -- upvalues: p5 (copy), ServerScriptService (copy), TreadmillUtil (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p11)

        local v11, v12 = require(ServerScriptService.Library.Database).UpdateProfileImmutable(p11, function(p12) -- line: 109
            -- upvalues: p5 (copy), TreadmillUtil (copy)
            local v13 = false

            if p12 ~= nil then
                local v14 = TreadmillUtil.ResolveSpeedBoostTierIndex(p12)

                v13 = not (TreadmillUtil.MAX_SPEED_BOOST_TIER_INDEX <= v14) and p5 == v14 + 1
            end

            if not v13 then
                return false
            end

            local v15 = table.clone(p12)

            v15.SpeedBoostTierIndex = p5

            return v15
        end):await()

        if not v11 or not v12 then
            return false, "Purchase the previous speed boost first"
        end

        return true
    end

    return {
        OneTime = true,
        HoldWhilePending = true,
        Name = p3,
        ProductId = p4,
        DisplayName = ("%* Speed Boost"):format(v6),
        Desc = ("Upgrade your permanent speed boost to %*."):format(v6),
        SpeedBoostTierIndex = p5,
        SpeedBoostMultiplier = p6,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateSpeedBoostProductConfig

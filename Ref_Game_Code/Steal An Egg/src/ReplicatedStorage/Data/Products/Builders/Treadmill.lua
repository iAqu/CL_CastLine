-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Treadmills = require(ReplicatedStorage.Data.Treadmills)
local t = require(ReplicatedStorage.Packages.t)

local function CreateTreadmillProductConfig(p1, p2, p3) -- line: 14
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), Treadmills (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.string)(p2)
    t.strict(t.number)(p3)

    local v1, v2 = Treadmills.TreadmillNameExists(p2)

    assert(v1, v2 or ("Treadmill \"%*\" does not exist"):format(p2))

    local v4 = Treadmills.Directory[p2]
    local v5 = Treadmills.GetUpgradeLevel(p2)

    assert(v5 ~= nil, (("Treadmill \"%*\" has no upgrade level"):format(p2)))

    local function canBuyNextUpgrade(p4) -- line: 26
        -- upvalues: v5 (copy)
        if p4 + 1 == v5 then
            return true
        end

        return false, "This is not your next treadmill upgrade"
    end

    local function authorize(p5) -- line: 33
        -- upvalues: canBuyNextUpgrade (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p5)

        local v8, v9 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p5)

        if not v8 or not v9 then
            return false, "Player profile not found"
        end

        return canBuyNextUpgrade(v9.TreadmillUpgradeLevel)
    end

    local function ResolveFailedReceipt(p6, _, _) -- line: 45
        -- upvalues: v5 (copy), ServerScriptService (copy)
        local Database = require(ServerScriptService.Library.Database)

        if not Database.IsPlayerLoaded(p6) then
            return "Retry"
        end

        local v10, v11 = Database.UnsafeGetProfileAwait(p6)

        if not v10 or not v11 then
            return "Retry"
        end

        if v11.TreadmillUpgradeLevel >= v5 then
            return "Satisfied"
        end

        return "Credit"
    end

    local function precheck() -- line: 64
        -- upvalues: canBuyNextUpgrade (copy), ReplicatedStorage (copy)
        local v12 = require(ReplicatedStorage.Shared.Save).Await()

        if v12 then
            return canBuyNextUpgrade(v12.TreadmillUpgradeLevel)
        end

        return false, "Data not loaded"
    end

    local function grant(p9) -- line: 74
        -- upvalues: p2 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p9)

        return require(ServerScriptService.Controllers.TreadmillService).UpgradeTreadmill(p9, p2, false)
    end

    return {
        OneTime = true,
        HoldWhilePending = true,
        Name = p1,
        ProductId = p3,
        DisplayName = v4.DisplayName,
        Desc = ("Upgrade to the %* treadmill."):format(v4.DisplayName),
        Icon = v4.Icon,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateTreadmillProductConfig

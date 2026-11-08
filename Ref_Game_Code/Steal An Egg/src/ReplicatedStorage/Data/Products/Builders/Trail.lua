-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local Trails = require(ReplicatedStorage.Data.Trails)
local t = require(ReplicatedStorage.Packages.t)

local function CreateTrailProductConfig(p1, p2, p3) -- line: 15
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), Trails (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.string)(p2)
    t.strict(t.number)(p3)

    local v1, v2 = Trails.TrailNameExists(p2)

    assert(v1, v2 or ("Trail \"%*\" does not exist"):format(p2))

    local v4 = Trails.Directory[p2]

    local function validateData(p4) -- line: 25
        -- upvalues: p2 (copy)
        if not p4 then
            return false, "Player data not found"
        end

        if p4.TrailInventory[p2] then
            return false, "You already own this trail"
        end

        return true
    end

    local function authorize(p5) -- line: 36
        -- upvalues: validateData (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p5)

        local v5, v6 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p5)

        if not v5 or not v6 then
            return false, "Player profile not found"
        end

        return validateData(v6)
    end

    local function ResolveFailedReceipt(p6, _, _) -- line: 48
        -- upvalues: p2 (copy), ServerScriptService (copy)
        local Database = require(ServerScriptService.Library.Database)

        if Database.IsPlayerLoaded(p6) then
            local v7, v8 = Database.UnsafeGetProfileAwait(p6)

            if v7 and v8 and v8.TrailInventory[p2] then
                return "Satisfied"
            end
        end

        return "Retry"
    end

    local function precheck() -- line: 67
        -- upvalues: validateData (copy), ReplicatedStorage (copy)
        local v9 = require(ReplicatedStorage.Shared.Save).Await()

        if v9 then
            return validateData(v9)
        end

        return false, "Data not loaded"
    end

    local function grant(p9) -- line: 77
        -- upvalues: p2 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p9)

        return require(ServerScriptService.Controllers.TrailShop).GrantOwnedTrail(p9, p2, true)
    end

    return {
        OneTime = true,
        HoldWhilePending = true,
        Name = p1,
        ProductId = p3,
        DisplayName = v4.DisplayName,
        Desc = ("Unlock the %* trail."):format(v4.DisplayName),
        Icon = v4.Icon,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateTrailProductConfig

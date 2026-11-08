-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

require(ReplicatedStorage.Packages.FormatNumber.Simple)

local t = require(ReplicatedStorage.Packages.t)
local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)
local Players = game:GetService("Players")

local function CreateSpeedPowerProductConfig(p1, p2) -- line: 22
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), t (copy), SpeedPacks (copy), Players (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)

    local v2 = assert(SpeedPacks.FindSlot(p2), "Unknown speed pack product")
    local v4 = tonumber((p1:gsub("SpeedPower_", ""):gsub("%D", "")))

    assert(v4 ~= nil, "Speed power product name must include a numeric reward amount")
    assert(v4 > 0, "Speed power reward must be positive")

    local v7 = require(ReplicatedStorage.Shared.Flags.BalanceConfig).Bind("Game.Balance.ProductRewards." .. p1, {
        Amount = v4
    }, true, false, function(p3) -- line: 38
        assert(p3.Amount > 0)
    end)

    local function ensureDataLoaded(p4) -- line: 43
        if p4 then
            return true
        end

        return false, "Player data is not loaded yet."
    end

    local function authorize(p5) -- line: 51
        -- upvalues: v2 (copy), ensureDataLoaded (copy), ServerScriptService (copy)
        local v9, v10 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p5)

        if not v9 then
            return false, "Failed to retrieve player data."
        end

        if require(ServerScriptService.Controllers.SpeedPackService).GetAmount(p5, v2) == nil then
            return false, "Speed packs are still loading."
        end

        return ensureDataLoaded(v10)
    end

    local function precheck() -- line: 66
        -- upvalues: v2 (copy), ensureDataLoaded (copy), ReplicatedStorage (copy), SpeedPacks (copy), Players (copy)
        local v11 = require(ReplicatedStorage.Shared.Save).Await()

        if SpeedPacks.GetShownAmount(Players.LocalPlayer, v2) == nil then
            return false, "Speed packs are still loading."
        end

        return ensureDataLoaded(v11)
    end

    local function grant(p6, p7) -- line: 77
        -- upvalues: v2 (copy), ServerScriptService (copy)
        return require(ServerScriptService.Controllers.SpeedPackService).Grant(p6, v2, p7)
    end

    local t1 = {
        Desc = "Purchase bonus speed!",
        HoldWhilePending = true,
        Name = p1,
        ProductId = p2,
        DisplayName = SpeedPacks.Names[v2],
        SpeedPowerReward = v7.Amount,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant
    }

    require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 92
        -- upvalues: v2 (copy), v7 (copy), t1 (copy), SpeedPacks (copy)
        t1.DisplayName = SpeedPacks.Names[v2]
        t1.SpeedPowerReward = v7.Amount
    end)

    return t1
end

return CreateSpeedPowerProductConfig

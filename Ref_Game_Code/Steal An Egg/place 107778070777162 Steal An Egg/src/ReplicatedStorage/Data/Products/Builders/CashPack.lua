-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CashPacks = require(ReplicatedStorage.Data.CashPacks)

require(script.Parent.Parent.Internal.ProductTypes)

local function CreateCashPackProductConfig(p1, p2) -- line: 10
    -- upvalues: Players (copy), ServerScriptService (copy), CashPacks (copy)
    local v1 = CashPacks.FindSlot(p2)

    assert(v1 ~= nil, (("Unknown cash pack %*"):format(p2)))

    local v4 = CashPacks.Offers[v1]

    assert(v4.Name == p1, "Cash pack catalog key does not match its product")

    local function authorize(p3) -- line: 22
        -- upvalues: v1 (copy), ServerScriptService (copy)
        if require(ServerScriptService.Controllers.CashPackService).GetAmount(p3, v1) == nil then
            return false, "Your cash packs are still loading. Please try again."
        end

        return true
    end

    local function precheck() -- line: 31
        -- upvalues: v1 (copy), Players (copy), CashPacks (copy)
        if CashPacks.GetShownAmount(Players.LocalPlayer, v1) == nil then
            return false, "Your cash packs are still loading. Please try again."
        end

        return true
    end

    local function grant(p4, p5) -- line: 38
        -- upvalues: v1 (copy), ServerScriptService (copy)
        return require(ServerScriptService.Controllers.CashPackService).Grant(p4, v1, p5)
    end

    return {
        Desc = "",
        HoldWhilePending = true,
        Silent = true,
        Name = p1,
        ProductId = p2,
        DisplayName = v4.DisplayName,
        Precheck = precheck,
        Authorize = authorize,
        Grant = grant
    }
end

return CreateCashPackProductConfig

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Marketplace = require(ReplicatedStorage.Shared.Utils.Marketplace)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local RiftMachineSchedule = require(ReplicatedStorage.Shared.Util.RiftMachineSchedule)
local t = require(ReplicatedStorage.Packages.t)

local function resolveRobuxCost(p1, p2) -- line: 16
    -- upvalues: Marketplace (copy)
    local CurrencySpent = if p2 == nil then nil else p2.CurrencySpent

    if type(CurrencySpent) == "number" and CurrencySpent > 0 then
        return CurrencySpent
    end

    local Price = Marketplace.Price
    local v1, v2, v3 = pcall(Price, p1, true)

    return if v1 and v3 and type(v2) == "number" and v2 > 0 then v2 else nil
end

local function CreateRiftRefreshProductConfig(p3, p4) -- line: 28
    -- upvalues: ServerScriptService (copy), Marketplace (copy), RiftFlags (copy), ScrambleTradeInFlags (copy), RiftMachineSchedule (copy), t (copy)
    t.strict(t.string)(p3)
    t.strict(t.number)(p4)

    local function authorize(p5, p6) -- line: 32
        -- upvalues: p4 (copy), ServerScriptService (copy), RiftMachineSchedule (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p5)

        if p4 <= 0 then
            return false, "Rift refresh is not available yet"
        end

        return (if RiftMachineSchedule.IsLaboratoryTime() then require(ServerScriptService.Controllers.ScrambleTradeInService) else require(ServerScriptService.Controllers.RiftService)).CanPurchasePaidRefresh(p5, p6 ~= nil)
    end

    local function precheck() -- line: 42
        -- upvalues: p4 (copy), RiftFlags (copy), ScrambleTradeInFlags (copy), RiftMachineSchedule (copy)
        if p4 <= 0 then
            return false, "Rift refresh is not available yet"
        end

        if (not RiftMachineSchedule.IsLaboratoryTime() or ScrambleTradeInFlags.Enabled:Get()) and (RiftMachineSchedule.IsLaboratoryTime() or not RiftFlags.Retired:Get()) then
            return true
        end

        return false, "The trade-in machine is closed"
    end

    local function ResolveFailedReceipt(p7, _, _) -- line: 52
        -- upvalues: ServerScriptService (copy)
        if require(ServerScriptService.Library.Database).IsPlayerLoaded(p7) then
            return "Credit"
        end

        return "Retry"
    end

    return {
        DisplayName = "Laboratory Refresh",
        Desc = "Instantly reroll the 3 eggs Dr. Scramble is asking for!",
        HoldWhilePending = true,
        Silent = true,
        Name = p3,
        ProductId = p4,
        Precheck = precheck,
        Authorize = authorize,
        Grant = function(p10, p11) -- grant | line: 61
            -- upvalues: p4 (copy), ServerScriptService (copy), Marketplace (copy), RiftMachineSchedule (copy), t (copy)
            t.strict(t.instanceIsA("Player"))(p10)

            local RedeemPaidRefresh = (if RiftMachineSchedule.IsLaboratoryTime() then require(ServerScriptService.Controllers.ScrambleTradeInService) else require(ServerScriptService.Controllers.RiftService)).RedeemPaidRefresh
            local v4 = if p11 == nil then nil else p11.CurrencySpent

            if type(v4) ~= "number" or not (v4 > 0) then
                local Price = Marketplace.Price
                local v5, v6

                v5, v4, v6 = pcall(Price, p4, true)

                if not v5 or not v6 or type(v4) ~= "number" or not (v4 > 0) then
                    v4 = nil
                end
            end

            return RedeemPaidRefresh(p10, v4)
        end,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateRiftRefreshProductConfig

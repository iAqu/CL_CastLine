-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Timecode = require(ReplicatedStorage.Shared.Utils.Time).Timecode
local t = require(ReplicatedStorage.Packages.t)

local function CreateEggSkipGrowthProductConfig(p1, p2, p3) -- line: 16
    -- upvalues: ReplicatedStorage (copy), ServerScriptService (copy), Timecode (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)
    t.strict(t.intersection(t.integer, t.numberPositive))(p3)

    local v1 = require(ReplicatedStorage.Shared.Flags.BalanceConfig).Bind("Game.Balance.ProductRewards." .. p1, {
        MaxRemainingSeconds = p3
    }, true, false, function(p4) -- line: 32
        assert(p4.MaxRemainingSeconds > 0 and p4.MaxRemainingSeconds % 1 == 0)
    end)

    local function authorize(p5, p6) -- line: 37
        -- upvalues: p1 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p5)

        local Eggs = require(ServerScriptService.Controllers.Eggs)

        if p6 == nil then
            return Eggs.CanPurchaseSkipGrowth(p5, p1)
        end

        return Eggs.CanRedeemSkipGrowth(p5, p1)
    end

    local function ReservePrompt(p7) -- line: 49
        -- upvalues: p1 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p7)

        return require(ServerScriptService.Controllers.Eggs).ReserveSkipGrowthPrompt(p7, p1)
    end

    local function CancelPrompt(p8) -- line: 57
        -- upvalues: p1 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p8)
        require(ServerScriptService.Controllers.Eggs).CancelSkipGrowthPrompt(p8, p1)
    end

    local function precheck() -- line: 65
        -- upvalues: ReplicatedStorage (copy)
        return require(ReplicatedStorage.Client.EggState).MayBuyChosenSkip()
    end

    local function ResolveFailedReceipt(p9, _, _) -- line: 71
        -- upvalues: ServerScriptService (copy)
        if require(ServerScriptService.Library.Database).IsPlayerLoaded(p9) then
            return "Credit"
        end

        return "Retry"
    end

    local function grant(p12) -- line: 81
        -- upvalues: p1 (copy), ServerScriptService (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p12)

        return require(ServerScriptService.Controllers.Eggs).PurchaseSkipGrowth(p12, p1)
    end

    local t1 = {
        HoldWhilePending = true,
        Silent = true,
        Name = p1,
        ProductId = p2,
        DisplayName = p1,
        Desc = ("Skip the growth of your egg by %*!"):format((Timecode(v1.MaxRemainingSeconds))),
        EggSkipGrowthMaxRemainingSeconds = v1.MaxRemainingSeconds,
        Precheck = precheck,
        Authorize = authorize,
        ReservePrompt = ReservePrompt,
        CancelPrompt = CancelPrompt,
        Grant = grant,
        ResolveFailedReceipt = ResolveFailedReceipt
    }

    require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 104
        -- upvalues: v1 (copy), t1 (copy), Timecode (copy)
        t1.EggSkipGrowthMaxRemainingSeconds = v1.MaxRemainingSeconds
        t1.Desc = ("Skip the growth of your egg by %*!"):format((Timecode(v1.MaxRemainingSeconds)))
    end)

    return t1
end

return CreateEggSkipGrowthProductConfig

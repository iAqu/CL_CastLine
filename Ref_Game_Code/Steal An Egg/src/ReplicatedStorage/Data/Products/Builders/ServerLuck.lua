-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local t = require(ReplicatedStorage.Packages.t)

local function CreateServerLuckConfig(p1, p2, p3) -- line: 12
    -- upvalues: ServerScriptService (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)
    t.strict(t.number)(p3)

    local v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.ProductRewards." .. p1 .. "", {
        Multiplier = p3
    }, true, false, function(p4) -- line: 26
        assert(p4.Multiplier > 1)
    end)

    local function authorize(_) -- line: 31
        -- upvalues: v1 (copy), ServerScriptService (copy)
        if require(ServerScriptService.Controllers.ServerLuck).GetState().Multiplier >= v1.Multiplier then
            return false, "Server already has equal or better luck"
        end

        return true
    end

    local function ResolveFailedReceipt(p6, _, _) -- line: 43
        -- upvalues: ServerScriptService (copy)
        if require(ServerScriptService.Library.Database).IsPlayerLoaded(p6) then
            return "Credit"
        end

        return "Retry"
    end

    return {
        HoldWhilePending = true,
        Silent = true,
        Name = p1,
        ProductId = p2,
        DisplayName = p1,
        Authorize = authorize,
        Grant = function(p9) -- grant | line: 53
            -- upvalues: v1 (copy), ServerScriptService (copy)
            require(ServerScriptService.Controllers.ServerLuck).HandlePurchase(v1.Multiplier, p9)

            return true
        end,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateServerLuckConfig

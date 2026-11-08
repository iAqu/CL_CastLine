-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local t = require(ReplicatedStorage.Packages.t)

local function CreateServerLuckExtensionConfig(p1, p2, p3) -- line: 12
    -- upvalues: ServerScriptService (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)
    t.strict(t.number)(p3)

    local v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.ProductRewards." .. p1 .. "", {
        Minutes = p3
    }, true, false, function(p4) -- line: 26
        assert(p4.Minutes > 0)
    end)

    local function authorize(_) -- line: 31
        -- upvalues: ServerScriptService (copy)
        return require(ServerScriptService.Controllers.ServerLuck).GetState().Multiplier > 1
    end

    local function ResolveFailedReceipt(p6, _, _) -- line: 39
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
        Grant = function(p9) -- grant | line: 49
            -- upvalues: v1 (copy), ServerScriptService (copy)
            return require(ServerScriptService.Controllers.ServerLuck).AddTime(v1.Minutes * 60, p9)
        end,
        ResolveFailedReceipt = ResolveFailedReceipt
    }
end

return CreateServerLuckExtensionConfig

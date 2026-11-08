-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Internal.ProductTypes)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local t = require(ReplicatedStorage.Packages.t)

local function CreateTreadmillAdEggBoostConfig(p1, p2) -- line: 12
    -- upvalues: ServerScriptService (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)

    return {
        Desc = "Treadmill Egg Ad Boost — 5 min x2 egg growth from rewarded video.",
        HoldWhilePending = true,
        Silent = true,
        Name = p1,
        ProductId = p2,
        DisplayName = p1,
        Authorize = function(p3) -- ServerTest | line: 16
            -- upvalues: ServerScriptService (copy)
            local v1, v2 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p3)

            if not v1 or not v2 then
                return false, "Player data is not loaded yet."
            end

            return true
        end,
        Grant = function(p4) -- Callback | line: 25
            -- upvalues: ServerScriptService (copy)
            require(ServerScriptService.Controllers.AdEggBoostServer.AdEggBoostReward).Grant(p4)

            return true
        end
    }
end

return CreateTreadmillAdEggBoostConfig

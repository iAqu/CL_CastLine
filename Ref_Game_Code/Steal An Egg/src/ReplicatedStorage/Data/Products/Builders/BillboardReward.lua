-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdRewards = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).AdRewards

require(script.Parent.Parent.Internal.ProductTypes)

local CollectionService = game:GetService("CollectionService")

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local t = require(ReplicatedStorage.Packages.t)

local function CreateBillboardRewardConfig(p1, p2) -- line: 19
    -- upvalues: AdRewards (copy), CollectionService (copy), ServerScriptService (copy), t (copy)
    t.strict(t.string)(p1)
    t.strict(t.number)(p2)

    local function authorize(p3) -- line: 23
        -- upvalues: ServerScriptService (copy)
        local v1, v2 = require(ServerScriptService.Library.Database).UnsafeGetProfileAwait(p3)

        if not v1 or not v2 then
            return false, "Player data is not loaded yet."
        end

        return true
    end

    return {
        Desc = "Rewarded video billboard cash reward.",
        Giftable = false,
        HoldWhilePending = true,
        Silent = true,
        Name = p1,
        ProductId = p2,
        DisplayName = p1,
        Authorize = authorize,
        Grant = function(p4) -- grant | line: 35
            -- upvalues: p2 (copy), AdRewards (copy), CollectionService (copy), ServerScriptService (copy)
            local leaderstats = p4:FindFirstChild("leaderstats")
            local v3 = leaderstats and leaderstats:FindFirstChild("Money/s")

            if v3 and v3:IsA("NumberValue") then
                local n1 = 0

                for _, v4 in (CollectionService:GetTagged("RVBillboard")) do
                    local ServerCode = v4:FindFirstChild("ServerCode")
                    local RewardSelector = ServerCode and ServerCode:FindFirstChild("RewardSelector")

                    if RewardSelector then
                        local _require = require
                        local ok, result = pcall(_require, RewardSelector)

                        if ok and result and result.CalculateReward then
                            n1 = result:CalculateReward(v3.Value, p2)
                            break
                        end
                    end
                end

                if n1 <= 0 then
                    n1 = v3.Value * AdRewards.FALLBACK_DURATION
                end

                if n1 <= 0 then
                    warn("[BillboardReward] Calculated reward is 0 for " .. p4.Name)

                    return false, "Reward amount is zero"
                end

                require(ServerScriptService.Controllers.MoneyService).AddMoney(p4, n1, {
                    source = "BillboardReward",
                    feature = "Ads"
                })
                require(ServerScriptService.Library.Functions.NotifyItem)(p4, {
                    Kind = "Currency",
                    Id = "Money",
                    Amount = math.round(n1)
                })

                return true
            end

            warn("[BillboardReward] No Money/s leaderstat for " .. p4.Name)

            return false, "Missing leaderstat"
        end
    }
end

return CreateBillboardRewardConfig

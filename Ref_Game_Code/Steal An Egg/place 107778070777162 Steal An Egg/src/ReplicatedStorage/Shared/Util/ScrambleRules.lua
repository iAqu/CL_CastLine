-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ScrambleBossDrop = require(game:GetService("ReplicatedStorage").Shared.Util.ScrambleBossDrop)
local t1 = {
    MAX_SAMPLES = 9E+12,
    PART_IDS = table.freeze({ "LostPart1", "LostPart2", "DronePart1", "DronePart2", "DronePart3" }),
    Blank = function() -- Blank | line: 10
        return {
            DroneParts = 0,
            Discovered = false,
            Completed = false,
            RewardUid = "",
            MutationConsumables = 0,
            ShopSequence = 0,
            LastOperation = "",
            Mastery = 0,
            InfiniteRewardsClaimed = 0,
            Wallets = {},
            LostParts = {},
            ShopPurchases = {},
            Receipts = {},
            ClaimedMilestoneIds = {}
        }
    end,
    Integer = function(p1, p2, p3) -- Integer | line: 29
        if type(p1) == "number" and p1 == p1 and p1 % 1 == 0 and p2 <= p1 then
            return p1 <= p3
        end

        return false
    end,
    Count = function(p4) -- Count | line: 37
        local n1 = 0

        for _ in p4 do
            n1 += 1
        end

        return n1
    end,
    Progress = function(p5) -- Progress | line: 45
        return (if p5.LostParts.LostPart1 then 1 else 0) + (if p5.LostParts.LostPart2 then 1 else 0), p5.DroneParts
    end,
    NextPart = function(p6) -- NextPart | line: 52
        return if not p6.Completed and not (p6.DroneParts >= 3) then "DronePart" .. tostring(p6.DroneParts + 1) else nil
    end
}

function t1.Project(p7, p8) -- line: 58
    -- upvalues: t1 (copy)
    local v2, v3 = t1.Progress(p7)

    return {
        Samples = p7.Wallets[p8] or 0,
        ShopSequence = p7.ShopSequence,
        ShopPurchases = table.clone((p7.ShopPurchases or {})[p8] or {}),
        LostParts = table.clone(p7.LostParts),
        DroneParts = v3,
        TotalParts = v2 + v3,
        Discovered = p7.Discovered,
        Completed = p7.Completed,
        Mastery = p7.Mastery or 0,
        ClaimedMilestoneIds = table.clone(p7.ClaimedMilestoneIds or {}),
        InfiniteRewardsClaimed = p7.InfiniteRewardsClaimed or 0
    }
end

function t1.Window(p9, p10, p11, p12, p13) -- line: 76
    if p10 <= 0 or p11 <= p10 or p9 < p10 or p11 <= p9 then
        return {
            Available = false,
            Active = false,
            Index = -1,
            EndsAt = p11,
            NextAt = p10
        }
    end

    local v5 = math.floor(p9 / p12)
    local v6 = v5 * p12
    local v8 = math.min(v6 + p13, p11)

    return {
        Available = true,
        Active = p9 < v8,
        Index = v5,
        StartsAt = v6,
        EndsAt = v8,
        NextAt = math.min(v6 + p12, p11)
    }
end

function t1.SplitSamples(p14, p15) -- line: 100
    -- upvalues: t1 (copy)
    assert(t1.Integer(p14, 0, t1.MAX_SAMPLES) and t1.Integer(p15, 1, 32))

    local v11 = math.min(p14, p15)
    local t4 = {}

    if v11 ~= 0 then
        local v13 = math.floor(p14 / v11)
        local v14 = p14 % v11

        for i = 1, v11 do
            t4[i] = v13 + (i <= v14 and 1 or 0)
        end
    end

    return t4
end

function t1.Apply(p16, p17, p18, p19) -- line: 117
    -- upvalues: ScrambleBossDrop (copy), t1 (copy)
    local Scramble = p16.Scramble

    if p18.OperationId and Scramble.LastOperation == p18.OperationId then
        return false, "AlreadyGranted"
    end

    local v15 = table.clone(Scramble)

    v15.LastOperation = p18.OperationId or Scramble.LastOperation

    local v16 = table.clone(p16)

    v16.Scramble = v15

    local EventId = p18.EventId

    local function credit(p20) -- line: 128
        -- upvalues: Scramble (copy), v15 (copy), EventId (copy), t1 (copy)
        if not t1.Integer(p20, 1, t1.MAX_SAMPLES) then
            return false
        end

        local v17 = Scramble.Wallets[EventId] or 0

        if t1.MAX_SAMPLES - p20 < v17 then
            return false
        end

        v15.Wallets = table.clone(Scramble.Wallets)
        v15.Wallets[EventId] = v17 + p20

        return true
    end

    local function addEggs(p21, p22, p23) -- line: 140
        -- upvalues: p16 (copy), p19 (copy), v16 (copy), t1 (copy)
        if type(p21) ~= "table" then
            return "MissingReward"
        end

        if not p23 and t1.Count(p16.EggInventory) + p22 > p19.Eggs then
            return "EggInventoryFull"
        end

        if t1.Count(p21) ~= p22 then
            return "MissingReward"
        end

        local v18 = table.clone(p16.EggInventory)

        for v19, v20 in p21 do
            if type(v19) ~= "string" or v19 == "" or type(v20) ~= "table" then
                return "MissingReward"
            end

            if v18[v19] then
                return "DuplicateReward"
            end

            v18[v19] = v20
        end

        v16.EggInventory = v18

        return nil
    end

    local Rewards

    if p17 == "Samples" then
        local Amount = p18.Amount
        local v21

        if t1.Integer(Amount, 1, t1.MAX_SAMPLES) then
            local v22 = Scramble.Wallets[EventId] or 0

            if t1.MAX_SAMPLES - Amount < v22 then
                v21 = false
            else
                v15.Wallets = table.clone(Scramble.Wallets)
                v21 = true
                v15.Wallets[EventId] = v22 + Amount
            end
        else
            v21 = false
        end

        if not v21 then
            return false, "BalanceLimit"
        end

        Rewards = nil
    elseif p17 == "Consumable" then
        local v23 = Scramble.MutationConsumables or 0

        if not t1.Integer(p18.Amount, 1, t1.MAX_SAMPLES) or t1.MAX_SAMPLES - p18.Amount < v23 then
            return false, "BalanceLimit"
        end

        Rewards = nil
        v15.MutationConsumables = v23 + p18.Amount
    elseif p17 == "Part" then
        if Scramble.Completed then
            return false, "AlreadyComplete"
        end

        if p18.Id == "LostPart1" or p18.Id == "LostPart2" then
            if Scramble.LostParts[p18.Id] then
                return false, "AlreadyCollected"
            end

            v15.LostParts = table.clone(Scramble.LostParts)
            v15.LostParts[p18.Id] = true
        else
            if p18.Id ~= t1.NextPart(Scramble) then
                return false, "WrongPart"
            end

            v15.DroneParts += 1
        end

        Rewards = nil
    elseif p17 == "Discover" then
        if Scramble.Discovered then
            return false, "AlreadyDiscovered"
        end

        Rewards = nil
        v15.Discovered = true
    elseif p17 == "Vault" then
        if Scramble.Completed then
            return false, "AlreadyComplete"
        end

        local v24, v25 = t1.Progress(Scramble)

        if not Scramble.Discovered or v24 + v25 ~= 5 then
            return false, "MissingParts"
        end

        if type(p18.Gear) ~= "string" or p18.Gear == "" or not t1.Integer(p18.Amount, 1, 100) then
            return false, "MissingReward"
        end

        v16.GearInventory = table.clone(p16.GearInventory)
        v16.GearInventory[p18.Gear] = math.max(v16.GearInventory[p18.Gear] or 0, p18.Amount)

        local v27 = "Gear:" .. p18.Gear

        v15.Completed = true
        Rewards = nil
        v15.RewardUid = v27
    elseif p17 == "Shop" then
        if not t1.Integer(p18.Sequence, 0, t1.MAX_SAMPLES - 1) or p18.Sequence ~= Scramble.ShopSequence then
            return false, "StalePurchase"
        end

        if not not not (t1.Integer(p18.Price, 1, t1.MAX_SAMPLES) and t1.Integer(p18.Quantity, 1, 25) and type(p18.Rewards) == "table") then
            return false, "MissingReward"
        end

        local v29 = Scramble.Wallets[EventId] or 0

        if v29 < p18.Price then
            return false, "NotEnoughSamples"
        end

        local v30 = ((Scramble.ShopPurchases or {})[EventId] or {})[p18.OfferId]
        local v31 = if not v30 or v30.Period ~= p18.PurchasePeriod then 0 else v30.Count

        if p18.PurchaseLimit ~= nil then
            local OfferId = p18.OfferId

            if type(OfferId) ~= "string" or type(p18.PurchasePeriod) ~= "string" or #p18.PurchasePeriod > 64 or not t1.Integer(p18.PurchaseLimit, 1, 100) or not t1.Integer(v31, 0, t1.MAX_SAMPLES) then
                return false, "MissingReward"
            end

            if v31 + p18.Quantity > p18.PurchaseLimit then
                return false, "PurchaseLimit"
            end
        end

        local v33 = p18.Kind or "Egg"
        local Rewards2

        if v33 == "Pet" then
            if t1.Count(p16.Inventory) + p18.Quantity > p19.Pets then
                return false, "PetInventoryFull"
            end

            if t1.Count(p18.Rewards) ~= p18.Quantity then
                return false, "MissingReward"
            end

            local v34 = table.clone(p16.Inventory)
            local v35 = table.clone(p16.Index)

            for v36, v37 in p18.Rewards do
                if type(v36) ~= "string" or v36 == "" or type(v37) ~= "table" then
                    return false, "MissingReward"
                end

                if v34[v36] then
                    return false, "DuplicateReward"
                end

                v34[v36] = v37
                v35[v37.Category] = true
            end

            Rewards2 = p18.Rewards
            v16.Inventory = v34
            v16.Index = v35
        else
            if v33 == "Egg" then
                local v38 = addEggs(p18.Rewards, p18.Quantity)

                if v38 then
                    return false, v38
                end
            elseif v33 == "MutationConsumable" then
                local v39 = Scramble.MutationConsumables or 0

                if not t1.Integer(v39, 0, t1.MAX_SAMPLES - p18.Quantity) then
                    return false, "BalanceLimit"
                end

                v15.MutationConsumables = v39 + p18.Quantity
            else
                if v33 ~= "CashBooster" and v33 ~= "SpeedBoost" and v33 ~= "TreadmillBoost" then
                    return false, "MissingReward"
                end

                if p18.Quantity ~= 1
                    or not t1.Integer(p18.DurationSeconds, 1, 86400)
                    or type(p18.Now) ~= "number"
                    or p18.Now ~= p18.Now
                    or p18.Now <= 0
                    or p18.Now > 4E+09 then
                    return false, "MissingReward"
                end

                local v41 = if v33 == "CashBooster" then p16.EarningsBoostExpiresAt elseif v33 == "SpeedBoost" then p16.BossMastery.SpeedBoostExpiresAt else p19.TreadmillRemaining(p16, p18.Now)

                if type(v41) ~= "number" or v41 ~= v41 or v41 < 0 or 4E+09 - p18.DurationSeconds < v41 then
                    return false, "BalanceLimit"
                end

                if v33 == "CashBooster" then
                    v16.EarningsBoostExpiresAt = math.max(p18.Now, v41) + p18.DurationSeconds
                elseif v33 == "SpeedBoost" then
                    v16.BossMastery = table.clone(p16.BossMastery)
                    v16.BossMastery.SpeedBoostExpiresAt = math.max(p18.Now, v41) + p18.DurationSeconds
                else
                    v16.TemporarySpeedBoostRemainingSeconds = v41 + p18.DurationSeconds
                    v16.TemporarySpeedBoostActiveStartedAt = p18.Now
                end
            end

            Rewards2 = nil
        end

        Rewards = Rewards2
        v15.Wallets = table.clone(Scramble.Wallets)
        v15.Wallets[EventId] = v29 - p18.Price
        v15.ShopSequence = Scramble.ShopSequence + 1

        if p18.PurchaseLimit ~= nil then
            v15.ShopPurchases = table.clone(Scramble.ShopPurchases or {})

            local v43 = table.clone(v15.ShopPurchases[EventId] or {})

            v43[p18.OfferId] = {
                Period = p18.PurchasePeriod,
                Count = v31 + p18.Quantity
            }
            v15.ShopPurchases[EventId] = v43
        end
    else
        if p17 == "Receipt" then
            if Scramble.Receipts[p18.PurchaseId] then
                if Scramble.Receipts[p18.PurchaseId].ProductId == p18.ProductId then
                    return false, "AlreadyGranted"
                end

                return false, "ReceiptMismatch"
            end

            local Amount = p18.Amount
            local v44

            if t1.Integer(Amount, 1, t1.MAX_SAMPLES) then
                local v45 = Scramble.Wallets[EventId] or 0

                if t1.MAX_SAMPLES - Amount < v45 then
                    v44 = false
                else
                    v15.Wallets = table.clone(Scramble.Wallets)
                    v44 = true
                    v15.Wallets[EventId] = v45 + Amount
                end
            else
                v44 = false
            end

            if not v44 then
                return false, "BalanceLimit"
            end

            v15.Receipts = table.clone(Scramble.Receipts)
            v15.Receipts[p18.PurchaseId] = {
                ProductId = p18.ProductId,
                EventId = EventId,
                Amount = p18.Amount
            }
            v16.MonetizationRobuxSpentTotal = (p16.MonetizationRobuxSpentTotal or 0) + (p18.RobuxSpent or 0)
        elseif p17 == "BossKill" then
            if not t1.Integer(p18.Amount, 0, t1.MAX_SAMPLES) then
                return false, "InvalidAmount"
            end

            if p18.Amount > 0 then
                local Amount = p18.Amount
                local v46

                if t1.Integer(Amount, 1, t1.MAX_SAMPLES) then
                    local v47 = Scramble.Wallets[EventId] or 0

                    if t1.MAX_SAMPLES - Amount < v47 then
                        v46 = false
                    else
                        v15.Wallets = table.clone(Scramble.Wallets)
                        v46 = true
                        v15.Wallets[EventId] = v47 + Amount
                    end
                else
                    v46 = false
                end

                if not v46 then
                    return false, "BalanceLimit"
                end
            end

            v15.Mastery = (Scramble.Mastery or 0) + 1
            v16.MechaScramblerObtained = ScrambleBossDrop.HasObtained(p16)

            if p18.Rewards ~= nil and not v16.MechaScramblerObtained then
                local v48 = addEggs(p18.Rewards, 1, true)

                if v48 then
                    return false, v48
                end

                v16.MechaScramblerObtained = true
            end
        else
            if p17 ~= "Milestone" then
                return false, "UnknownAction"
            end

            local v49 = Scramble.Mastery or 0
            local v50 = Scramble.ClaimedMilestoneIds or {}

            if p18.Infinite then
                if type(p18.FinalMilestoneId) ~= "string" or not t1.Integer(p18.FinalKills, 1, t1.MAX_SAMPLES) or not t1.Integer(p18.EveryKills, 1, t1.MAX_SAMPLES) then
                    return false, "MissingReward"
                end

                local v51 = Scramble.InfiniteRewardsClaimed or 0

                if not v50[p18.FinalMilestoneId] or (v49 - p18.FinalKills) // p18.EveryKills <= v51 then
                    return false, "MilestoneLocked"
                end

                v15.InfiniteRewardsClaimed = v51 + 1
            else
                if type(p18.MilestoneId) ~= "string" or not t1.Integer(p18.Kills, 1, t1.MAX_SAMPLES) then
                    return false, "MissingReward"
                end

                if v50[p18.MilestoneId] then
                    return false, "MilestoneClaimed"
                end

                if v49 < p18.Kills then
                    return false, "MilestoneLocked"
                end

                v15.ClaimedMilestoneIds = table.clone(v50)
                v15.ClaimedMilestoneIds[p18.MilestoneId] = true
            end

            local v52 = addEggs(p18.Rewards, 1)

            if v52 then
                return false, v52
            end
        end

        Rewards = nil
    end

    return v16, "Granted", Rewards
end

return table.freeze(t1)

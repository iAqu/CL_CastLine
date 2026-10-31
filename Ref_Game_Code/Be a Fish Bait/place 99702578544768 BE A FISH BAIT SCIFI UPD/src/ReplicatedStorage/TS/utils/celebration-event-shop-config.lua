-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UnixTimestamp = DateTime.fromUniversalTime(2026, 8, 7, 11, 0, 0).UnixTimestamp
local t1 = {
    {
        id = "aura-reroll-1",
        price = 1500
    },
    {
        id = "aura-reroll-2",
        price = 2500
    },
    {
        id = "aura-reroll-3",
        price = 4000
    }
}

local function getCelebrationAuraRerollShopItem(p1) -- line: 33
    -- upvalues: t1 (copy)
    for v1, v2 in t1 do
        local _ = v1 - 1

        if v2.id == p1 == true then
            return v2
        end
    end

    return nil
end

local t2 = {
    {
        id = "fomo-charm",
        price = 1000,
        rewardType = "charm",
        rewardId = "fomo"
    },
    {
        id = "hook-showcase-skin",
        price = 400,
        rewardType = "hologramSkin",
        rewardId = "Cake"
    }
}

local function getCelebrationCosmeticShopItem(p2) -- line: 59
    -- upvalues: t2 (copy)
    for v3, v4 in t2 do
        local _ = v3 - 1

        if v4.id == p2 == true then
            return v4
        end
    end

    return nil
end

local t3 = {
    {
        id = "time-skip-1-minute",
        minutes = 1,
        price = 40
    },
    {
        id = "time-skip-2-minutes",
        minutes = 2,
        price = 70
    },
    {
        id = "time-skip-3-minutes",
        minutes = 3,
        price = 95
    }
}
local t4 = {
    ["time-skip-1-minute"] = 1,
    ["time-skip-2-minutes"] = 1,
    ["time-skip-3-minutes"] = 1,
    ["fomo-orbit-1-hour"] = 24
}

local function getCelebrationTimeSkipShopItem(p3) -- line: 93
    -- upvalues: t3 (copy)
    for v5, v6 in t3 do
        local _ = v5 - 1

        if v6.id == p3 == true then
            return v6
        end
    end

    return nil
end

local function getCelebrationEventShopStockRemaining(p4, p5, p6, p7) -- line: 108
    -- upvalues: t4 (copy)
    local v7 = t4[p4]

    if v7 == nil then
        v7 = 0
    end

    local v8

    if p6 == p5 then
        v8 = p7[p4]

        if v8 == nil then
            v8 = 0
        end
    else
        v8 = 0
    end

    return (math.max(0, v7 - v8))
end

local t5 = {
    {
        currency = "tickets",
        id = "mark-of-the-og",
        price = 750,
        titleId = "markOfTheOg"
    },
    {
        currency = "robux",
        id = "og-prime",
        price = 69,
        titleId = "ogPrime"
    }
}

return {
    markOfTheOgShopItemId = "mark-of-the-og",
    ogPrimeShopItemId = "og-prime",
    fomoOrbitShopItemId = "fomo-orbit-1-hour",
    fomoAquariumSkinShopItemId = "fomo-aquarium-skin",
    fomoCharmShopItemId = "fomo-charm",
    fishHologramSkinShopItemId = "hook-showcase-skin",
    celebrationTimeSkipOneMinuteItemId = "time-skip-1-minute",
    celebrationTimeSkipTwoMinutesItemId = "time-skip-2-minutes",
    celebrationTimeSkipThreeMinutesItemId = "time-skip-3-minutes",
    markOfTheOgTicketPrice = 750,
    fomoAquariumSkinTicketPrice = 3500,
    fomoOrbitTicketPrice = 120,
    fomoOrbitDurationSeconds = 3600,
    fomoOrbitTicketMultiplier = 1.2,
    fomoCharmTicketPrice = 1000,
    fishHologramSkinTicketPrice = 400,
    ogPrimeRobuxPrice = 69,
    ogPrimeDeveloperProductId = 3610321859,
    premiumFomoCharmDeveloperProductId = 3610322442,
    premiumFishHologramDeveloperProductId = 3610322402,
    getCelebrationAuraRerollShopItem = getCelebrationAuraRerollShopItem,
    getCelebrationCosmeticShopItem = getCelebrationCosmeticShopItem,
    getCelebrationTimeSkipShopItem = getCelebrationTimeSkipShopItem,
    getCelebrationEventShopStockRemaining = getCelebrationEventShopStockRemaining,
    getCelebrationTitleShopItem = function(p8) -- getCelebrationTitleShopItem | line: 147
        -- upvalues: t5 (copy)
        for v10, v11 in t5 do
            local _ = v10 - 1

            if v11.id == p8 == true then
                return v11
            end
        end

        return nil
    end,
    celebrationEventShopEndTimestamp = UnixTimestamp,
    auraRerollShopItems = t1,
    celebrationCosmeticShopItems = t2,
    celebrationTimeSkipShopItems = t3,
    celebrationEventShopDailyStockLimits = t4,
    celebrationTitleShopItems = t5
}

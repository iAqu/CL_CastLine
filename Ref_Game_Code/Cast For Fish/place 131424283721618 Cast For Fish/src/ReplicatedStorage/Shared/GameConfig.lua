-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    START_CASH = 0,
    START_CAST_POWER = 18,
    START_BAIT = "worm",
    START_ROD = "bamboo",
    POWER_PER_LEVEL = 5,
    REP_INTERVAL = 0.5,
    TRAIN_RADIUS = 9,
    xpNeeded = function(p1) -- xpNeeded | line: 15
        return math.floor((p1 - 1) / 10) * 5 + 5
    end,
    CATCH_XP_REPS = 1
}

function t1.catchXpReps(p2, p3, p4) -- line: 26
    -- upvalues: t1 (copy)
    return t1.CATCH_XP_REPS * 2 ^ (p2 / 2) * ((p3 - 1) * 0.5 + 1) * (math.log(math.max(p4, 1), 2) / 2 + 1)
end

t1.METER_MIN = 1
t1.METER_MAX = 20
t1.CAST_COOLDOWN = 2
t1.DOCK_Z = -6
t1.LANE_HALF_WIDTH = 60
t1.ZONE_LENGTH = 600
t1.ZONE_COUNT = 21
t1.MAX_DISTANCE = t1.ZONE_COUNT * t1.ZONE_LENGTH - 15
t1.WATER_Y = -14
t1.SEABED_Y = -40

function t1.distanceForPower(p5) -- line: 47
    -- upvalues: t1 (copy)
    return (math.clamp(0.75 * t1.ZONE_LENGTH * math.log(p5 / 85 + 1, 2), 0.075 * t1.ZONE_LENGTH, t1.MAX_DISTANCE))
end

function t1.powerForDistance(p6) -- line: 52
    -- upvalues: t1 (copy)
    return 85 * (2 ^ (p6 / (0.75 * t1.ZONE_LENGTH)) - 1)
end

function t1.throwPower(p7, p8) -- line: 58
    if p8 and p8 > 0 then
        return (math.min(p7, p8))
    end

    return p7
end

function t1.luckForDistance(p9) -- line: 66
    -- upvalues: t1 (copy)
    return 1 + (p9 / t1.ZONE_LENGTH) ^ 2 * 4
end

t1.PITY_STEP = 0.05
t1.PITY_MAX_STACKS = 20
t1.LUCKY_CAST_LUCK = 100
t1.SELL_MULTIPLIER = 15
t1.INCOME_INTERVAL = 1
t1.BACKPACK_LIMIT = 100
t1.AQUARIUM_LIMIT = 60
t1.CAPACITY_LEVELS = { 10, 12, 14, 16, 18, 20 }
t1.CAPACITY_PRICES = { 4E+07, 2E+09, 1E+11, 5E+12, 2.5E+14 }
t1.PLOT_FRONT_Z = 94
t1.PLOT_DEPTHS = { 72, 88, 104, 120, 136, 152 }
t1.OFFLINE_RATE = 0.25
t1.OFFLINE_MAX_HOURS = 12
t1.OFFLINE_PRO_MULT = 2
t1.OFFLINE_PRO_MAX_HOURS = 24
t1.OFFLINE_MIN_SECONDS = 60
t1.ANNOUNCE_MIN_RARITY = "Mythic"
t1.ANNOUNCE_VARIANTS = {
    Rainbow = true,
    Void = true
}
t1.ADMIN_USER_IDS = { 1152736592, 12011028932, 59213512, 9345488208, 11941562355 }
t1.AFK_REJOIN_SECONDS = 1080
t1.DATASTORE_NAME = "PlayerData_v1"
t1.AUTOSAVE_INTERVAL = 90

return t1

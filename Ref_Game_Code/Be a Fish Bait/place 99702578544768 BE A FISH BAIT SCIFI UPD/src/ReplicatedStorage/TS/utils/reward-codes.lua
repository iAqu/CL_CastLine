-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local getTimeSkipSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config").getTimeSkipSeconds
local celebrationEventShopEndTimestamp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").celebrationEventShopEndTimestamp
local t1 = {
    money = true,
    timeSkip = true,
    spinWheelSpins = true,
    rerolls = true,
    tickets = true,
    title = true,
    timedBuff = true,
    aquariumShard = true
}
local v1 = t.interface({
    expiresAt = t.optional(t.number),
    liveAt = t.optional(t.number),
    rewardAmount = t.number,
    rewardBuffDurationSeconds = t.optional(t.number),
    rewardBuffKind = t.optional(t.union(t.literal("money"), t.literal("mutationLuck"), t.literal("power"))),
    rewardGemName = t.optional(t.string),
    rewardGemNodeRarity = t.optional(t.union(t.literal("common"), t.literal("rare"), t.literal("epic"), t.literal("legendary"), t.literal("mythic"))),
    rewardId = t.string,
    rewardMinimumCash = t.optional(t.number),
    rewardShardRarity = t.optional(t.union(t.literal("rare"), t.literal("epic"), t.literal("legendary"), t.literal("mythic"))),
    rewardTitleId = t.optional(t.string),
    rewardType = t.union(t.literal("money"), t.literal("gemSpawns"), t.literal("lavaBucket"), t.literal("gem"), t.literal("gemNode"), t.literal("timeSkip"), t.literal("spinWheelSpins"), t.literal("rerolls"), t.literal("tickets"), t.literal("title"), t.literal("timedBuff"), t.literal("aquariumShard"))
})
local v2 = t.map(t.string, v1)

local function getCodeTimeSkipCashAmount(p1, p2) -- line: 50
    local v4 = math.floor(p1.rewardAmount * math.max(p2, 0))
    local rewardMinimumCash = p1.rewardMinimumCash

    if rewardMinimumCash == nil then
        rewardMinimumCash = 0
    end

    return (math.max(v4, rewardMinimumCash))
end

local function getSgtUnixTimestamp(p3, p4, p5, p6, p7) -- line: 70
    local v5 = if p6 == nil then 0 else p6
    local v6 = if p7 == nil then 0 else p7

    return DateTime.fromUniversalTime(p3, p4, p5, v5 - 8, v6, 0).UnixTimestamp
end

local UnixTimestamp = DateTime.fromUniversalTime(2026, 6, 26, 8 - 8, 0, 0).UnixTimestamp
local UnixTimestamp2 = DateTime.fromUniversalTime(2026, 7, 10, 8 - 8, 0, 0).UnixTimestamp
local UnixTimestamp3 = DateTime.fromUniversalTime(2026, 7, 1, 23 - 8, 40, 0).UnixTimestamp
local UnixTimestamp4 = DateTime.fromUniversalTime(2026, 7, 13, 12 - 8, 59, 0).UnixTimestamp
local UnixTimestamp5 = DateTime.fromUniversalTime(2026, 7, 3, 18 - 8, 0, 0).UnixTimestamp
local UnixTimestamp6 = DateTime.fromUniversalTime(2026, 7, 17, 8 - 8, 0, 0).UnixTimestamp
local UnixTimestamp7 = DateTime.fromUniversalTime(2026, 7, 3, 18 - 8, 0, 0).UnixTimestamp
local UnixTimestamp8 = DateTime.fromUniversalTime(2026, 7, 13, 12 - 8, 59, 0).UnixTimestamp
local UnixTimestamp9 = DateTime.fromUniversalTime(2026, 7, 4, 21 - 8, 0, 0).UnixTimestamp
local UnixTimestamp10 = DateTime.fromUniversalTime(2026, 7, 13, 12 - 8, 59, 0).UnixTimestamp
local UnixTimestamp11 = DateTime.fromUniversalTime(2026, 7, 5, 12 - 8, 0, 0).UnixTimestamp
local UnixTimestamp12 = DateTime.fromUniversalTime(2026, 7, 13, 12 - 8, 59, 0).UnixTimestamp
local UnixTimestamp13 = DateTime.fromUniversalTime(2026, 7, 6, 18 - 8, 0, 0).UnixTimestamp
local UnixTimestamp14 = DateTime.fromUniversalTime(2026, 7, 21, 8 - 8, 0, 0).UnixTimestamp
local UnixTimestamp15 = DateTime.fromUniversalTime(2026, 7, 4, 15 - 8, 0, 0).UnixTimestamp
local UnixTimestamp16 = DateTime.fromUniversalTime(2026, 7, 13, 12 - 8, 59, 0).UnixTimestamp
local UnixTimestamp17 = DateTime.fromUniversalTime(2026, 7, 17, 22 - 8, 0, 0).UnixTimestamp
local UnixTimestamp18 = DateTime.fromUniversalTime(2026, 7, 31, 20 - 8, 0, 0).UnixTimestamp
local UnixTimestamp19 = DateTime.fromUniversalTime(2026, 8, 14, 17 - 8, 0, 0).UnixTimestamp
local UnixTimestamp20 = DateTime.fromUniversalTime(2026, 8, 28, 17 - 8, 0, 0).UnixTimestamp

return {
    officialReleaseRewardCode = "OFFICIAL",
    baitAuraRewardCode = "BAITAURA",
    likes500RewardCode = "500LIKES",
    likes1000RewardCode = "1000LIKES",
    likes1500RewardCode = "1500LIKES",
    likes2000RewardCode = "2000LIKES",
    likes4000RewardCode = "4000LIKES",
    ccu2500RewardCode = "2500CCU",
    fomoRewardCode = "SRYFORDELAY",
    shardsRewardCode = "SHARDS",
    hoolalalaRewardCode = "HOOLALALA",
    getCodeTimeSkipCashAmount = getCodeTimeSkipCashAmount,
    normalizeRewardCode = function(p8) -- normalizeRewardCode | line: 99
        return string.upper((string.gsub(p8, "%s+", "")))
    end,
    supportedCodeRewardTypes = t1,
    codeRewardGuard = v1,
    rewardCodesMapGuard = v2,
    rewardCodes = {
        HOOLALALA = {
            rewardId = "HOOLA_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 3,
            expiresAt = UnixTimestamp20,
            liveAt = UnixTimestamp19
        },
        SHARDS = {
            rewardId = "SHARDS_REWARD_CODE",
            rewardType = "aquariumShard",
            rewardShardRarity = "legendary",
            rewardAmount = 3,
            liveAt = UnixTimestamp18
        },
        SRYFORDELAY = {
            rewardId = "FOMO_REWARD_CODE",
            rewardType = "tickets",
            rewardAmount = 10,
            expiresAt = celebrationEventShopEndTimestamp,
            liveAt = UnixTimestamp17
        },
        OFFICIAL = {
            rewardId = "OFFICIAL_REWARD_CODE",
            rewardType = "timeSkip",
            rewardMinimumCash = 10000,
            expiresAt = UnixTimestamp2,
            liveAt = UnixTimestamp,
            rewardAmount = getTimeSkipSeconds(5)
        },
        ["500LIKES"] = {
            rewardId = "500_LIKES_REWARD_CODE",
            rewardType = "spinWheelSpins",
            rewardAmount = 3,
            expiresAt = UnixTimestamp4,
            liveAt = UnixTimestamp3
        },
        BAITAURA = {
            rewardId = "BAIT_AURA_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 1,
            expiresAt = UnixTimestamp6,
            liveAt = UnixTimestamp5
        },
        ["1000LIKES"] = {
            rewardId = "1000_LIKES_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 1,
            expiresAt = UnixTimestamp8,
            liveAt = UnixTimestamp7
        },
        ["1500LIKES"] = {
            rewardId = "1500_LIKES_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 1,
            expiresAt = UnixTimestamp10,
            liveAt = UnixTimestamp9
        },
        ["2000LIKES"] = {
            rewardId = "2000_LIKES_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 1,
            expiresAt = UnixTimestamp12,
            liveAt = UnixTimestamp11
        },
        ["4000LIKES"] = {
            rewardId = "4000_LIKES_REWARD_CODE",
            rewardType = "spinWheelSpins",
            rewardAmount = 3,
            expiresAt = UnixTimestamp14,
            liveAt = UnixTimestamp13
        },
        ["2500CCU"] = {
            rewardId = "2500_CCU_REWARD_CODE",
            rewardType = "rerolls",
            rewardAmount = 3,
            expiresAt = UnixTimestamp16,
            liveAt = UnixTimestamp15
        }
    }
}

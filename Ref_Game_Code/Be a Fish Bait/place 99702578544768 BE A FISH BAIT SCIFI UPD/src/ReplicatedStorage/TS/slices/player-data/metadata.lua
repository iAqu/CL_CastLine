-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local getTimeToAddToPlaytime = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getTimeToAddToPlaytime
local dailyRewardLoopStartDay = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").dailyRewardLoopStartDay
local celebrationRewardLoopStartDay = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils").celebrationRewardLoopStartDay
local maxBackpackUpgradeCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils").maxBackpackUpgradeCount
local v42 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 14
        local metadata = p2.data.metadata
        local timeJoined, timeJoined2, userId = p2.timeJoined, p2.timeJoined, p2.userId
        local v2 = table.clone(metadata)

        setmetatable(v2, nil)

        local backpackUpgradeCount = metadata.backpackUpgradeCount

        v2.backpackUpgradeCount = if backpackUpgradeCount == nil then 0 else backpackUpgradeCount

        local eventShopDailyStockDayKey = metadata.eventShopDailyStockDayKey

        v2.eventShopDailyStockDayKey = if eventShopDailyStockDayKey == nil then "" else eventShopDailyStockDayKey
        v2.eventShopPurchasesToday = metadata.eventShopPurchasesToday or {}
        v2.playTimeRewardStartTime = timeJoined2

        local powerBoostBonusMultiplier = metadata.powerBoostBonusMultiplier

        v2.powerBoostBonusMultiplier = if powerBoostBonusMultiplier == nil then 0 else powerBoostBonusMultiplier
        v2.promptedSocialEventIds = metadata.promptedSocialEventIds or {}
        v2.spinWheelStartTime = timeJoined
        v2.timeJoined = timeJoined
        v2.userId = p2.userId
        p1[userId] = v2
    end),
    beforePlayerLeft = produceWrapper(function(p3, p4) -- line: 48
        local v3 = p3[p4.userId]

        if not v3 then
            return nil
        end

        v3.timeLastLeft = p4.timeStamp
    end),
    playerLeft = produceWrapper(function(p5, p6) -- line: 57
        if not p5[p6.userId] then
            return nil
        end

        p5[p6.userId] = nil
    end),
    beforeDataSaved = produceWrapper(function(p7, p8) -- line: 68
        -- upvalues: getTimeToAddToPlaytime (copy)
        local v4 = p7[p8.userId]

        if not v4 then
            return nil
        end

        v4.timeLastSaved = p8.timeNow
        v4.savingServerJobId = p8.savingServerJobId
        v4.isFirstTime = false
        v4.playtime += getTimeToAddToPlaytime(p8.timeNow, p8.timeJoined, p8.timeLastSaved)
        v4.savedTimeForPlaytimeReward += getTimeToAddToPlaytime(p8.timeNow, v4.playTimeRewardStartTime, p8.timeLastSaved)
        v4.spinWheelSavedPlaytime += getTimeToAddToPlaytime(p8.timeNow, v4.spinWheelStartTime, p8.timeLastSaved)
    end),
    claimedDailyReward = produceWrapper(function(p9, p10) -- line: 82
        local v5 = p9[p10.userId]

        if not v5 then
            return nil
        end

        v5.dayLastClaimedDailyReward = p10.dayLastClaimedDailyReward
    end),
    resetDailyRewards = produceWrapper(function(p11, p12) -- line: 91
        -- upvalues: dailyRewardLoopStartDay (copy)
        local v6 = p11[p12.userId]

        if not v6 then
            return nil
        end

        local v7 = DateTime.now():ToUniversalTime()

        v6.dayLastClaimedDailyReward = {
            dailyRewardIndex = tostring(dailyRewardLoopStartDay),
            day = v7.Day,
            month = v7.Month,
            year = v7.Year
        }
    end),
    claimedCelebrationReward = produceWrapper(function(p13, p14) -- line: 106
        local v8 = p13[p14.userId]

        if not v8 then
            return nil
        end

        v8.dayLastClaimedCelebrationReward = p14.dayLastClaimedCelebrationReward
    end),
    resetCelebrationRewards = produceWrapper(function(p15, p16) -- line: 115
        -- upvalues: celebrationRewardLoopStartDay (copy)
        local v9 = p15[p16.userId]

        if not v9 then
            return nil
        end

        local v10 = DateTime.now():ToUniversalTime()

        v9.dayLastClaimedCelebrationReward = {
            dailyRewardIndex = tostring(celebrationRewardLoopStartDay),
            day = v10.Day,
            month = v10.Month,
            year = v10.Year
        }
    end),
    resetPlaytimeRewards = produceWrapper(function(p17, p18) -- line: 130
        local v11 = p17[p18.userId]

        if not v11 then
            return nil
        end

        v11.playTimeRewardStartTime = p18.timeNow
        v11.savedTimeForPlaytimeReward = 0
    end),
    spinWheelDailyReset = produceWrapper(function(p19, p20) -- line: 140
        local v12 = p19[p20.userId]

        if not v12 then
            return nil
        end

        v12.spinWheelDayKey = p20.dayKey
        v12.spinWheelStartTime = p20.timeNow
        v12.spinWheelSavedPlaytime = 0
        v12.spinWheelSpinsGrantedToday = 0
    end),
    spinWheelMilestoneSpinGranted = produceWrapper(function(p21, p22) -- line: 152
        local v13 = p21[p22.userId]

        if not v13 then
            return nil
        end

        v13.spinWheelSpinsGrantedToday += 1
    end),
    plotLiked = produceWrapper(function(p23, p24) -- line: 161
        local v14 = p23[p24.userId]

        if not v14 then
            return nil
        end

        v14.recentlyLikedPlots[p24.plotOwnerUserId] = p24.dayKey
    end),
    communityMemberLiked = produceWrapper(function(p25, p26) -- line: 173
        local v15 = p25[p26.userId]

        if not v15 then
            return nil
        end

        v15.likedCommunityMembers[p26.personName] = true
    end),
    preLogoutBuffClaimed = produceWrapper(function(p27, p28) -- line: 184
        local v16 = p27[p28.userId]

        if not v16 then
            return nil
        end

        local v17 = v16.preLogoutBuff[p28.buffKind]
        local v18 = if v17 == nil or not (v17.buffExpiresAt > p28.now) then p28.now else v17.buffExpiresAt

        v16.preLogoutBuff[p28.buffKind] = {
            buffExpiresAt = v18 + p28.durationSeconds,
            claimedDayKey = p28.claimedDayKey
        }
    end),
    audioSettingsUpdated = produceWrapper(function(p29, p30) -- line: 201
        local v19 = p29[p30.userId]

        if not v19 then
            return nil
        end

        if p30.soundGroup == "music" then
            v19.audioSettings.musicVolume = p30.volume
        else
            v19.audioSettings.sfxVolume = p30.volume
        end
    end),
    hapticsToggled = produceWrapper(function(p31, p32) -- line: 214
        local v20 = p31[p32.userId]

        if not v20 then
            return nil
        end

        v20.audioSettings.hapticsEnabled = p32.enabled
    end),
    cameraShakeToggled = produceWrapper(function(p33, p34) -- line: 223
        local v21 = p33[p34.userId]

        if not v21 then
            return nil
        end

        v21.audioSettings.cameraShakeEnabled = p34.enabled
    end),
    bossAutokillToggled = produceWrapper(function(p35, p36) -- line: 232
        local v22 = p35[p36.userId]

        if not v22 then
            return nil
        end

        v22.bossAutokillEnabled = p36.enabled
    end),
    celebrationEventRegistered = produceWrapper(function(p37, p38) -- line: 241
        local v23 = p37[p38.userId]

        if not v23 then
            return nil
        end

        v23.hasRegisteredForCelebrationEvent = true
    end),
    celebrationEventRegistrationReset = produceWrapper(function(p39, p40) -- line: 250
        local v24 = p39[p40.userId]

        if not v24 then
            return nil
        end

        v24.hasRegisteredForCelebrationEvent = false
    end),
    celebrationIslandVisited = produceWrapper(function(p41, p42) -- line: 259
        local v25 = p41[p42.userId]

        if not v25 then
            return nil
        end

        v25.hasVisitedCelebrationIsland = true
    end),
    celebrationFarewellSeen = produceWrapper(function(p43, p44) -- line: 268
        local v26 = p43[p44.userId]

        if not v26 then
            return nil
        end

        v26.hasSeenCelebrationFarewell = true
    end),
    celebrationFarewellReset = produceWrapper(function(p45, p46) -- line: 277
        local v27 = p45[p46.userId]

        if not v27 then
            return nil
        end

        v27.hasSeenCelebrationFarewell = false
    end),
    celebrationWelcomeRewardClaimed = produceWrapper(function(p47, p48) -- line: 286
        local v28 = p47[p48.userId]

        if not v28 then
            return nil
        end

        v28.hasClaimedCelebrationWelcomeReward = true
    end),
    fishCaughtIncremented = produceWrapper(function(p49, p50) -- line: 295
        local v29 = p49[p50.userId]

        if not v29 then
            return nil
        end

        v29.totalFishCaught += 1
    end),
    robuxSpentIncremented = produceWrapper(function(p51, p52) -- line: 304
        local v30 = p51[p52.userId]

        if not v30 then
            return nil
        end

        v30.totalRobuxSpent += p52.amount
    end),
    powerBoostGranted = produceWrapper(function(p53, p54) -- line: 313
        local v31 = p53[p54.userId]

        if not v31 then
            return nil
        end

        v31.powerBoostBonusMultiplier = math.max(v31.powerBoostBonusMultiplier, p54.bonusMultiplier)
    end),
    hoolaPityUpdated = produceWrapper(function(p55, p56) -- line: 322
        local v32 = p55[p56.userId]

        if not v32 then
            return nil
        end

        v32.hoolaPity = {
            revision = p56.revision,
            score = p56.score,
            tier = p56.tier
        }
    end),
    backpackCapacityUpgraded = produceWrapper(function(p57, p58) -- line: 335
        -- upvalues: maxBackpackUpgradeCount (copy)
        local v33 = p57[p58.userId]

        if not v33 then
            return nil
        end

        v33.backpackUpgradeCount = math.min(v33.backpackUpgradeCount + 1, maxBackpackUpgradeCount)
    end),
    backpackCapacityUpgradesCleared = produceWrapper(function(p59, p60) -- line: 344
        local v35 = p59[p60.userId]

        if not v35 then
            return nil
        end

        v35.backpackUpgradeCount = 0
    end),
    ticketCapProgressUpdated = produceWrapper(function(p61, p62) -- line: 353
        local v36 = p61[p62.userId]

        if not v36 then
            return nil
        end

        v36.ticketCapProgress[p62.source] = {
            earnedSinceReset = p62.earnedSinceReset,
            resetsAt = p62.resetsAt
        }
    end),
    eventShopDailyPurchaseRecorded = produceWrapper(function(p63, p64) -- line: 368
        local v37 = p63[p64.userId]

        if not v37 then
            return nil
        end

        if v37.eventShopDailyStockDayKey ~= p64.dayKey then
            v37.eventShopDailyStockDayKey = p64.dayKey
            v37.eventShopPurchasesToday = {}
        end

        local v38 = v37.eventShopPurchasesToday or {}

        v37.eventShopPurchasesToday = v38

        local itemId = p64.itemId
        local v39 = v38[p64.itemId]

        if v39 == nil then
            v39 = 0
        end

        v38[itemId] = v39 + 1
    end),
    challengeTierClaimed = produceWrapper(function(p65, p66) -- line: 389
        -- upvalues: includesOriginal (copy), push (copy)
        local v40 = p65[p66.userId]

        if not v40 or includesOriginal(v40.claimedChallengeTierIds, p66.tierId) then
            return nil
        end

        push(v40.claimedChallengeTierIds, p66.tierId)
    end),
    socialEventPrompted = produceWrapper(function(p67, p68) -- line: 401
        local v41 = p67[p68.userId]

        if not v41 then
            return nil
        end

        v41.promptedSocialEventIds[p68.eventId] = true
    end)
})

v42:getActions()

return {
    metadataSlice = v42
}

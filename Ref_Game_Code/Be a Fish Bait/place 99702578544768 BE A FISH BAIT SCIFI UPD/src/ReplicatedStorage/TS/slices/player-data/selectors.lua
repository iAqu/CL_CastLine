-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createSelector = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createSelector
local mapToArray = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "utils").mapToArray
local pickaxe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "pickaxe")
local getPickaxeCooldown, getPickaxeGemChance = pickaxe.getPickaxeCooldown, pickaxe.getPickaxeGemChance
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local shops = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "shops").shops
local aquariums = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums")
local allAquariumData, getAquariumData = aquariums.allAquariumData, aquariums.getAquariumData
local resolveCombinedPlayerBuffBonuses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "player-buff-utils").resolveCombinedPlayerBuffBonuses
local emoteDefinitionsById = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "emotes").emoteDefinitionsById
local getEquippedCharmCore = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").getEquippedCharmCore
local selectPlayerMetadata, selectPlayerStats, selectPlayerRewards, selectPlayerPlot, selectPlayerInventory, selectPlayerTutorialTracking, selectPlayerGamepasses, selectPlayerPurchaseHistory, selectPlayerBundlePurchaseHistory, selectPlayerAquarium, selectPlayerOfflineEarnings, selectPlayerCollectionIndex, selectPlayerRebirth, selectPlayerTitles, selectPlayerBaitAuras, selectPlayerFishDisplay, selectPlayerEmotes, selectPlayerDanceFloorAura, selectPlayerHallOfFame, selectPlayerCharms, selectPlayerFishReelbackVfx, selectPlayerMounts, selectPlayerZoneGacha, selectPlayerFishingRodSkins, selectPlayerMaterials, selectPlayerFishingContracts

local function selectPlayerData(p1) -- line: 17
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref), selectPlayerStats (ref), selectPlayerRewards (ref), selectPlayerPlot (ref), selectPlayerInventory (ref), selectPlayerTutorialTracking (ref), selectPlayerGamepasses (ref), selectPlayerPurchaseHistory (ref), selectPlayerBundlePurchaseHistory (ref), selectPlayerAquarium (ref), selectPlayerOfflineEarnings (ref), selectPlayerCollectionIndex (ref), selectPlayerRebirth (ref), selectPlayerTitles (ref), selectPlayerBaitAuras (ref), selectPlayerFishDisplay (ref), selectPlayerEmotes (ref), selectPlayerDanceFloorAura (ref), selectPlayerHallOfFame (ref), selectPlayerCharms (ref), selectPlayerFishReelbackVfx (ref), selectPlayerMounts (ref), selectPlayerZoneGacha (ref), selectPlayerFishingRodSkins (ref), selectPlayerMaterials (ref), selectPlayerFishingContracts (ref)
    return createSelector({
        selectPlayerMetadata(p1),
        selectPlayerStats(p1),
        selectPlayerRewards(p1),
        selectPlayerPlot(p1),
        selectPlayerInventory(p1),
        selectPlayerTutorialTracking(p1),
        selectPlayerGamepasses(p1),
        selectPlayerPurchaseHistory(p1),
        selectPlayerBundlePurchaseHistory(p1),
        selectPlayerAquarium(p1),
        selectPlayerOfflineEarnings(p1),
        selectPlayerCollectionIndex(p1),
        selectPlayerRebirth(p1),
        selectPlayerTitles(p1),
        selectPlayerBaitAuras(p1),
        selectPlayerFishDisplay(p1),
        selectPlayerEmotes(p1),
        selectPlayerDanceFloorAura(p1),
        selectPlayerHallOfFame(p1),
        selectPlayerCharms(p1),
        selectPlayerFishReelbackVfx(p1),
        selectPlayerMounts(p1),
        selectPlayerZoneGacha(p1),
        selectPlayerFishingRodSkins(p1),
        selectPlayerMaterials(p1),
        selectPlayerFishingContracts(p1)
    }, function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27) -- line: 18
        while p2 and p3 do
            if not p4
                or not p5
                or not p6
                or p7 == nil
                or not p8
                or not p9
                or not p10
                or not p11
                or not p12
                or not p13
                or not p14
                or not p15
                or not p16
                or not p17
                or not p18
                or not p19
                or not p20
                or not p21
                or not p22
                or not p23
                or not p24
                or not p25 then
                break
            end

            if p26 and p27 then
                return {
                    metadata = p2,
                    stats = p3,
                    rewards = p4,
                    plot = p5,
                    inventory = p6,
                    tutorialTracking = p7,
                    gamepasses = p8,
                    purchaseHistory = p9,
                    bundlePurchaseHistory = p10,
                    aquarium = p11,
                    offlineEarnings = p12,
                    collectionIndex = p13,
                    rebirth = p14,
                    titles = p15,
                    baitAuras = p16,
                    fishDisplay = p17,
                    emotes = p18,
                    danceFloorAura = p19,
                    hallOfFame = p20,
                    charms = p21,
                    fishReelbackVfx = p22,
                    mounts = p23,
                    zoneGacha = p24,
                    rodSkins = p25,
                    materials = p26,
                    fishingContracts = p27
                }
            end

            break
        end

        return nil
    end)
end

function selectPlayerMetadata(p28) -- line: 52
    return function(p29) -- line: 53
        -- upvalues: p28 (copy)
        return p29.playerData.metadata[p28]
    end
end

local function selectPlayerBackpackUpgradeCount(p30) -- line: 59
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref)
    return createSelector(selectPlayerMetadata(p30), function(p31) -- line: 60
        local v1 = if p31 == nil then p31 else p31.backpackUpgradeCount

        if v1 == nil then
            v1 = 0
        end

        return v1
    end)
end

local function selectPlayerHasLikedCommunityMember(p32, p33) -- line: 72
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref)
    return createSelector(selectPlayerMetadata(p32), function(p34) -- line: 73
        -- upvalues: p33 (copy)
        local v3 = if p34 == nil then p34 else p34.likedCommunityMembers[p33]

        if v3 == nil then
            v3 = false
        end

        return v3
    end)
end

local function selectDayLastClaimedDailyReward(p35) -- line: 88
    return function(p36) -- line: 89
        -- upvalues: p35 (copy)
        local v4 = p36.playerData.metadata[p35]

        if v4 ~= nil then
            v4 = v4.dayLastClaimedDailyReward
        end

        return v4
    end
end

local function selectDayLastClaimedCelebrationReward(p37) -- line: 100
    return function(p38) -- line: 101
        -- upvalues: p37 (copy)
        local v5 = p38.playerData.metadata[p37]

        if v5 ~= nil then
            v5 = v5.dayLastClaimedCelebrationReward
        end

        return v5
    end
end

local function selectPlayerPreLogoutBuff(p39) -- line: 111
    return function(p40) -- line: 112
        -- upvalues: p39 (copy)
        local v6 = p40.playerData.metadata[p39]

        if v6 ~= nil then
            v6 = v6.preLogoutBuff
        end

        return v6
    end
end

local function selectPlayerTicketCapProgress(p41, p42) -- line: 122
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref)
    return createSelector(selectPlayerMetadata(p41), function(p43) -- line: 123
        -- upvalues: p42 (copy)
        if p43 == nil then
            return p43
        end

        return p43.ticketCapProgress[p42]
    end)
end

local function selectPlayerClaimedChallengeTierIds(p44) -- line: 134
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref)
    return createSelector(selectPlayerMetadata(p44), function(p45) -- line: 135
        local v8 = if p45 == nil then p45 else p45.claimedChallengeTierIds

        if v8 == nil then
            v8 = {}
        end

        return v8
    end)
end

local function selectPlayerAudioSettings(p46) -- line: 147
    return function(p47) -- line: 148
        -- upvalues: p46 (copy)
        local v9 = p47.playerData.metadata[p46]

        if v9 ~= nil then
            v9 = v9.audioSettings
        end

        return v9
    end
end

local function selectPlayerBossAutokillEnabled(p48) -- line: 158
    return function(p49) -- line: 159
        -- upvalues: p48 (copy)
        local v10 = p49.playerData.metadata[p48]

        if v10 ~= nil then
            v10 = v10.bossAutokillEnabled
        end

        if v10 == nil then
            v10 = true
        end

        return v10
    end
end

function selectPlayerBaitAuras(p50) -- line: 173
    return function(p51) -- line: 174
        -- upvalues: p50 (copy)
        return p51.playerData.baitAuras[p50]
    end
end

function selectPlayerCharms(p52) -- line: 180
    return function(p53) -- line: 181
        -- upvalues: p52 (copy)
        return p53.playerData.charms[p52]
    end
end

local function selectPlayerDisplayedCharmId(p54) -- line: 187
    -- upvalues: createSelector (copy), selectPlayerCharms (ref)
    return createSelector(selectPlayerCharms(p54), function(p55) -- line: 188
        if p55 == nil then
            return p55
        end

        return p55.displayedCharmId
    end)
end

local function selectPlayerActiveCharmCore(p56) -- line: 196
    -- upvalues: createSelector (copy), getEquippedCharmCore (copy), selectPlayerCharms (ref)
    return createSelector(selectPlayerCharms(p56), function(p57) -- line: 197
        -- upvalues: getEquippedCharmCore (copy)
        return if p57 ~= nil then getEquippedCharmCore(p57.charmCoresByTier, p57.equippedCharmId) else nil
    end)
end

local function selectPlayerPendingCharmCandidate(p58) -- line: 201
    -- upvalues: createSelector (copy), selectPlayerCharms (ref)
    return createSelector(selectPlayerCharms(p58), function(p59) -- line: 202
        if p59 == nil then
            return p59
        end

        return p59.pendingCharmCandidate
    end)
end

local selectEquippedBaitAuraName

local function selectPlayerBuffBonuses(p60) -- line: 211
    -- upvalues: createSelector (copy), resolveCombinedPlayerBuffBonuses (copy), selectPlayerActiveCharmCore (copy), selectEquippedBaitAuraName (ref)
    return createSelector({
        selectEquippedBaitAuraName(p60),
        selectPlayerActiveCharmCore(p60)
    }, function(p61, p62) -- line: 212
        -- upvalues: resolveCombinedPlayerBuffBonuses (copy)
        return resolveCombinedPlayerBuffBonuses(p61, p62)
    end)
end

function selectPlayerMounts(p63) -- line: 216
    return function(p64) -- line: 217
        -- upvalues: p63 (copy)
        return p64.playerData.mounts[p63]
    end
end

local function selectPlayerActiveMountName(p65) -- line: 223
    -- upvalues: createSelector (copy), selectPlayerMounts (ref)
    return createSelector(selectPlayerMounts(p65), function(p66) -- line: 224
        if p66 == nil then
            return p66
        end

        return p66.activeMountName
    end)
end

local function selectPlayerIsMounted(p67) -- line: 232
    -- upvalues: createSelector (copy), selectPlayerMounts (ref)
    return createSelector(selectPlayerMounts(p67), function(p68) -- line: 233
        local v11 = if p68 == nil then p68 else p68.isMounted

        if v11 == nil then
            v11 = false
        end

        return v11
    end)
end

local function selectPlayerOwnedMountNames(p69) -- line: 245
    -- upvalues: createSelector (copy), selectPlayerMounts (ref)
    return createSelector(selectPlayerMounts(p69), function(p70) -- line: 246
        local v12 = if p70 == nil then p70 else p70.ownedMountNames

        if v12 == nil then
            v12 = {}
        end

        return v12
    end)
end

function selectPlayerZoneGacha(p71) -- line: 258
    return function(p72) -- line: 259
        -- upvalues: p71 (copy)
        return p72.playerData.zoneGacha[p71]
    end
end

local function selectPlayerZoneGachaOwnedItemIds(p73) -- line: 265
    -- upvalues: createSelector (copy), selectPlayerZoneGacha (ref)
    return createSelector(selectPlayerZoneGacha(p73), function(p74) -- line: 266
        local v13 = if p74 == nil then p74 else p74.ownedItemIds

        if v13 == nil then
            v13 = {}
        end

        return v13
    end)
end

function selectEquippedBaitAuraName(p75) -- line: 279
    -- upvalues: createSelector (copy), selectPlayerBaitAuras (ref)
    return createSelector(selectPlayerBaitAuras(p75), function(p76) -- line: 280
        if not p76 then
            return nil
        end

        local v14 = p76.slots[p76.equippedSlotIndex + 1]

        return if v14 ~= "" then v14 else nil
    end)
end

local function selectPlaytimeRewardEligibilityData(p77) -- line: 296
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref), selectPlayerRewards (ref)
    return createSelector({
        selectPlayerMetadata(p77),
        selectPlayerRewards(p77)
    }, function(p78, p79) -- line: 297
        return if p78 ~= nil and p79 ~= nil then {
            playTimeRewardStartTime = p78.playTimeRewardStartTime,
            savedTimeForPlaytimeReward = p78.savedTimeForPlaytimeReward,
            timeJoined = p78.timeJoined,
            timeLastSaved = p78.timeLastSaved,
            rewards = p79
        } else nil
    end)
end

function selectPlayerStats(p80) -- line: 307
    return function(p81) -- line: 308
        -- upvalues: p80 (copy)
        return p81.playerData.stats[p80]
    end
end

local function selectPlayerHighScorePosition(p82) -- line: 314
    -- upvalues: createSelector (copy), selectPlayerStats (ref)
    return createSelector(selectPlayerStats(p82), function(p83) -- line: 315
        if p83 == nil then
            return p83
        end

        return p83.highScorePosition
    end)
end

local function selectPlayerStat(p84, p85) -- line: 323
    -- upvalues: createSelector (copy), selectPlayerStats (ref)
    return createSelector(selectPlayerStats(p84), function(p86) -- line: 324
        -- upvalues: p85 (copy)
        if p86 == nil then
            return p86
        end

        return p86[p85]
    end)
end

local function selectCanAffordCost(p87, p88) -- line: 332
    return function(p89) -- line: 333
        -- upvalues: p87 (copy), p88 (copy)
        local v16 = p89.playerData.stats[p87]

        if v16 ~= nil then
            v16 = v16.money
        end

        if v16 == nil then
            v16 = 0
        end

        return p88 <= v16
    end
end

local function selectPlayerOwnsPickaxe(p90, p91) -- line: 348
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p90), function(p92) -- line: 349
        -- upvalues: p91 (copy)
        if not p92 then
            return false
        end

        for _, v18 in p92 do
            if v18.itemType == "pickaxe" and v18.itemName == p91 then
                return true
            end
        end

        return false
    end)
end

function selectPlayerRewards(p93) -- line: 361
    return function(p94) -- line: 362
        -- upvalues: p93 (copy)
        return p94.playerData.rewards[p93]
    end
end

function selectPlayerInventory(p95) -- line: 368
    return function(p96) -- line: 369
        -- upvalues: p95 (copy)
        return p96.playerData.inventory[p95]
    end
end

function selectPlayerMaterials(p97) -- line: 375
    return function(p98) -- line: 376
        -- upvalues: p97 (copy)
        return p98.playerData.materials[p97]
    end
end

function selectPlayerFishingContracts(p99) -- line: 382
    return function(p100) -- line: 383
        -- upvalues: p99 (copy)
        return p100.playerData.fishingContracts[p99]
    end
end

local function selectPlayerInventoryItem(p101, p102) -- line: 389
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p101), function(p103) -- line: 390
        -- upvalues: p102 (copy)
        if p103 == nil then
            return p103
        end

        return p103[p102]
    end)
end

local function selectInventoryFishLevel(p104, p105) -- line: 400
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(createSelector(selectPlayerInventory(p104), function(p106) -- line: 390
        -- upvalues: p105 (copy)
        if p106 == nil then
            return p106
        end

        return p106[p105]
    end), function(p107) -- line: 401
        return if (if p107 == nil then p107 else p107.itemType) == "fish" then p107.level else nil
    end)
end

local function selectInventoryFishMutations(p108, p109) -- line: 410
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(createSelector(selectPlayerInventory(p108), function(p110) -- line: 390
        -- upvalues: p109 (copy)
        if p110 == nil then
            return p110
        end

        return p110[p109]
    end), function(p111) -- line: 411
        return if (if p111 == nil then p111 else p111.itemType) == "fish" then p111.mutations else nil
    end)
end

local function selectPlayerPickaxeByItemName(p112, p113) -- line: 425
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p112), function(p114) -- line: 426
        -- upvalues: p113 (copy)
        if not p114 then
            return nil
        end

        for v23, v24 in p114 do
            if v24.itemType == "pickaxe" and v24.itemName == p113 then
                return {
                    itemId = v23,
                    isInToolbar = v24.isInToolbar
                }
            end
        end

        return nil
    end)
end

local function getOrderedPickaxeShopItems() -- line: 447
    -- upvalues: mapToArray (copy), shops (copy)
    local pickaxeShop1 = shops.pickaxeShop1

    if not pickaxeShop1 then
        return {}
    end

    local v25 = mapToArray(pickaxeShop1.shopItems)

    table.sort(v25, function(p115, p116) -- line: 453
        return p115.showOrder < p116.showOrder
    end)

    return v25
end

local function getPickaxeShopItemsByPrice() -- line: 464
    -- upvalues: mapToArray (copy), shops (copy)
    local pickaxeShop1 = shops.pickaxeShop1

    if not pickaxeShop1 then
        return {}
    end

    local v26 = mapToArray(pickaxeShop1.shopItems)

    table.sort(v26, function(p117, p118) -- line: 470
        if p117.moneyPrice == p118.moneyPrice then
            return p117.showOrder < p118.showOrder
        end

        return p117.moneyPrice < p118.moneyPrice
    end)

    return v26
end

local function selectPlayerOwnedPickaxeNamesKey(p119) -- line: 485
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p119), function(p120) -- line: 486
        local t1 = {}

        if p120 then
            for _, v27 in p120 do
                if v27.itemType == "pickaxe" then
                    table.insert(t1, v27.itemName)
                end
            end
        end

        table.sort(t1)

        return table.concat(t1, ",")
    end)
end

local function selectPlayerOwnedPickaxeNames(p121) -- line: 506
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(createSelector(selectPlayerInventory(p121), function(p122) -- line: 486
        local t2 = {}

        if p122 then
            for _, v28 in p122 do
                if v28.itemType == "pickaxe" then
                    table.insert(t2, v28.itemName)
                end
            end
        end

        table.sort(t2)

        return table.concat(t2, ",")
    end), function(p123) -- line: 507
        local t3 = {}

        if p123 ~= "" then
            for _, v29 in string.split(p123, ",") do
                t3[v29] = true
            end
        end

        return t3
    end)
end

local function selectNextPickaxeUpgrade(p124) -- line: 524
    -- upvalues: createSelector (copy), selectPlayerInventory (ref), getOrderedPickaxeShopItems (copy)
    return createSelector(createSelector(createSelector(selectPlayerInventory(p124), function(p125) -- line: 486
        local t4 = {}

        if p125 then
            for _, v30 in p125 do
                if v30.itemType == "pickaxe" then
                    table.insert(t4, v30.itemName)
                end
            end
        end

        table.sort(t4)

        return table.concat(t4, ",")
    end), function(p126) -- line: 507
        local t5 = {}

        if p126 ~= "" then
            for _, v31 in string.split(p126, ",") do
                t5[v31] = true
            end
        end

        return t5
    end), function(p127) -- line: 525
        -- upvalues: getOrderedPickaxeShopItems (copy)
        local v32 = getOrderedPickaxeShopItems()

        if #v32 ~= 0 then
            for _, v33 in v32 do
                if p127[v33.itemName] == nil then
                    return {
                        nextPickaxeName = v33.itemName,
                        shopItem = v33
                    }
                end
            end
        end

        return nil
    end)
end

local function selectNextCheapestPickaxeUpgrade(p128) -- line: 550
    -- upvalues: createSelector (copy), selectPlayerInventory (ref), getPickaxeShopItemsByPrice (copy)
    return createSelector(createSelector(createSelector(selectPlayerInventory(p128), function(p129) -- line: 486
        local t6 = {}

        if p129 then
            for _, v34 in p129 do
                if v34.itemType == "pickaxe" then
                    table.insert(t6, v34.itemName)
                end
            end
        end

        table.sort(t6)

        return table.concat(t6, ",")
    end), function(p130) -- line: 507
        local t7 = {}

        if p130 ~= "" then
            for _, v35 in string.split(p130, ",") do
                t7[v35] = true
            end
        end

        return t7
    end), function(p131) -- line: 551
        -- upvalues: getPickaxeShopItemsByPrice (copy)
        local v36 = getPickaxeShopItemsByPrice()

        if #v36 ~= 0 then
            for _, v37 in v36 do
                if p131[v37.itemName] == nil then
                    return {
                        nextPickaxeName = v37.itemName,
                        shopItem = v37
                    }
                end
            end
        end

        return nil
    end)
end

function selectPlayerPlot(p132) -- line: 569
    return function(p133) -- line: 570
        -- upvalues: p132 (copy)
        return p133.playerData.plot[p132]
    end
end

local function selectPlayerPlotLikes(p134) -- line: 576
    -- upvalues: createSelector (copy), selectPlayerPlot (ref)
    return createSelector(selectPlayerPlot(p134), function(p135) -- line: 577
        local v38 = if p135 == nil then p135 else p135.plotLikes

        if v38 == nil then
            v38 = 0
        end

        return v38
    end)
end

local function selectPlayerShowcaseFish(p136) -- line: 589
    -- upvalues: createSelector (copy), selectPlayerPlot (ref)
    return createSelector(selectPlayerPlot(p136), function(p137) -- line: 590
        if p137 == nil then
            return p137
        end

        return p137.showcaseFish
    end)
end

local function selectPlayerEquippedHologramSkin(p138) -- line: 598
    -- upvalues: createSelector (copy), selectPlayerPlot (ref)
    return createSelector(selectPlayerPlot(p138), function(p139) -- line: 599
        if p139 == nil then
            return p139
        end

        return p139.equippedHologramSkin
    end)
end

local function selectPlayerOwnedHologramSkins(p140) -- line: 607
    -- upvalues: createSelector (copy), selectPlayerPlot (ref)
    return createSelector(selectPlayerPlot(p140), function(p141) -- line: 608
        local v39 = if p141 == nil then p141 else p141.ownedHologramSkins

        if v39 == nil then
            v39 = {}
        end

        return v39
    end)
end

function selectPlayerTutorialTracking(p142) -- line: 620
    return function(p143) -- line: 621
        -- upvalues: p142 (copy)
        return p143.playerData.tutorialTracking[p142]
    end
end

function selectPlayerGamepasses(p144) -- line: 627
    return function(p145) -- line: 628
        -- upvalues: p144 (copy)
        return p145.playerData.gamepasses[p144]
    end
end

local function selectPlayerOwnsGamepass(p146, p147) -- line: 634
    -- upvalues: createSelector (copy), selectPlayerGamepasses (ref)
    return createSelector(selectPlayerGamepasses(p146), function(p148) -- line: 635
        -- upvalues: p147 (copy)
        local v41 = p148 ~= nil

        if v41 then
            v41 = false

            for v42, v43 in p148 do
                local _ = v42 - 1

                if v43.gamepassName == p147 then
                    v41 = true
                    break
                end

                v41 = false
            end
        end

        return v41
    end)
end

function selectPlayerPurchaseHistory(p149) -- line: 655
    return function(p150) -- line: 656
        -- upvalues: p149 (copy)
        return p150.playerData.purchaseHistory[p149]
    end
end

function selectPlayerBundlePurchaseHistory(p151) -- line: 662
    return function(p152) -- line: 663
        -- upvalues: p151 (copy)
        return p152.playerData.bundlePurchaseHistory[p151]
    end
end

function selectPlayerAquarium(p153) -- line: 669
    return function(p154) -- line: 670
        -- upvalues: p153 (copy)
        return p154.playerData.aquarium[p153]
    end
end

local function selectPlayerAquariumUncollectedMoney(p155) -- line: 676
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p155), function(p156) -- line: 677
        local v44 = if p156 == nil then p156 else p156.uncollectedMoney

        if v44 == nil then
            v44 = 0
        end

        return v44
    end)
end

local function selectPlayerAquariumLevel(p157) -- line: 689
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p157), function(p158) -- line: 690
        local v45 = if p158 == nil then p158 else p158.aquariumLevel

        if v45 == nil then
            v45 = 1
        end

        return v45
    end)
end

local function selectPlayerAquariumFishItems(p159) -- line: 702
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p159), function(p160) -- line: 703
        if p160 == nil then
            return p160
        end

        return p160.fishItems
    end)
end

local function selectPlayerAquariumUpgradeStartedTimestamp(p161) -- line: 711
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p161), function(p162) -- line: 712
        if p162 == nil then
            return p162
        end

        return p162.aquariumUpgradeStartedTimestamp
    end)
end

local function selectPlayerAquariumUpgradeCompleteTimestamp(p163) -- line: 720
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p163), function(p164) -- line: 721
        if p164 == nil then
            return p164
        end

        return p164.aquariumUpgradeCompleteTimestamp
    end)
end

local function selectPlayerAquariumOwnedSkins(p165) -- line: 729
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p165), function(p166) -- line: 730
        if p166 == nil then
            return p166
        end

        return p166.ownedSkins
    end)
end

local function selectPlayerAquariumCratePityCount(p167) -- line: 738
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p167), function(p168) -- line: 739
        local v46 = if p168 == nil then p168 else p168.cratePityCount

        if v46 == nil then
            v46 = 0
        end

        return v46
    end)
end

local function selectPlayerAquariumUniversalSkinShards(p169) -- line: 751
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p169), function(p170) -- line: 752
        local v47 = if p170 == nil then p170 else p170.universalSkinShards

        if v47 == nil then
            v47 = 0
        end

        return v47
    end)
end

local function selectPlayerAquariumSkinShardBalances(p171) -- line: 764
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p171), function(p172) -- line: 765
        local v48 = if p172 == nil then p172 else p172.skinShardBalances

        if v48 == nil then
            v48 = {
                rare = 0,
                epic = 0,
                legendary = 0,
                mythic = 0
            }
        end

        return v48
    end)
end

local function selectPlayerAquariumSkinShardBalance(p173, p174) -- line: 782
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p173), function(p175) -- line: 783
        -- upvalues: p174 (copy)
        local v50 = if p175 == nil then p175 else p175.skinShardBalances[p174]

        if v50 == nil then
            v50 = 0
        end

        return v50
    end)
end

local function selectPlayerAquariumLifetimeShardsEarned(p176) -- line: 795
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p176), function(p177) -- line: 796
        local v51 = if p177 == nil then p177 else p177.lifetimeShardsEarned

        if v51 == nil then
            v51 = {
                rare = 0,
                epic = 0,
                legendary = 0,
                mythic = 0,
                universal = 0
            }
        end

        return v51
    end)
end

local function selectPlayerAquariumLifetimeShardEarned(p178, p179) -- line: 814
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p178), function(p180) -- line: 815
        -- upvalues: p179 (copy)
        local lifetimeShardsEarned

        if p180 ~= nil then
            lifetimeShardsEarned = p180.lifetimeShardsEarned

            if lifetimeShardsEarned ~= nil then
                lifetimeShardsEarned = lifetimeShardsEarned[p179]
            end
        else
            lifetimeShardsEarned = p180
        end

        if lifetimeShardsEarned == nil then
            lifetimeShardsEarned = 0
        end

        return lifetimeShardsEarned
    end)
end

local function selectPlayerAquariumSkinRollCount(p181, p182) -- line: 830
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p181), function(p183) -- line: 831
        -- upvalues: p182 (copy)
        local skinRollCounts

        if p183 ~= nil then
            skinRollCounts = p183.skinRollCounts

            if skinRollCounts ~= nil then
                skinRollCounts = skinRollCounts[p182]
            end
        else
            skinRollCounts = p183
        end

        if skinRollCounts == nil then
            skinRollCounts = 0
        end

        return skinRollCounts
    end)
end

local function selectPlayerHasClaimedFreeAquariumCratePull(p184) -- line: 847
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p184), function(p185) -- line: 848
        local v54 = if p185 == nil then p185 else p185.hasClaimedFreeCratePull

        if v54 == nil then
            v54 = false
        end

        return v54
    end)
end

local function selectPlayerHasClaimedAquariumCrateFirstPurchase(p186, p187) -- line: 860
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p186), function(p188) -- line: 861
        -- upvalues: p187 (copy)
        local claimedFirstPurchaseCrateSeriesIds

        if p188 ~= nil then
            claimedFirstPurchaseCrateSeriesIds = p188.claimedFirstPurchaseCrateSeriesIds

            if claimedFirstPurchaseCrateSeriesIds ~= nil then
                claimedFirstPurchaseCrateSeriesIds = table.find(claimedFirstPurchaseCrateSeriesIds, p187) ~= nil
            end
        else
            claimedFirstPurchaseCrateSeriesIds = p188
        end

        if claimedFirstPurchaseCrateSeriesIds == nil then
            claimedFirstPurchaseCrateSeriesIds = false
        end

        return claimedFirstPurchaseCrateSeriesIds
    end)
end

local function selectPlayerPendingAquariumCrateReveals(p189) -- line: 877
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p189), function(p190) -- line: 878
        local v56 = if p190 == nil then p190 else p190.pendingCrateReveals

        if v56 == nil then
            v56 = {}
        end

        return v56
    end)
end

local function selectPlayerAquariumMoneyPerSecond(p191) -- line: 890
    -- upvalues: createSelector (copy), selectPlayerAquarium (ref)
    return createSelector(selectPlayerAquarium(p191), function(p192) -- line: 891
        local v57 = if p192 == nil then p192 else p192.moneyPerSecond

        if v57 == nil then
            v57 = 0
        end

        return v57
    end)
end

local function selectCanAffordAquariumUpgrade(p193) -- line: 903
    -- upvalues: createSelector (copy), allAquariumData (copy), getAquariumData (copy), resolveCombinedPlayerBuffBonuses (copy), selectPlayerStats (ref), selectPlayerAquarium (ref), selectPlayerActiveCharmCore (copy), selectEquippedBaitAuraName (ref)
    local v58 = selectPlayerAquarium(p193)
    local v59 = selectPlayerStats(p193)
    local v60 = "money"

    return createSelector({
        v58,
        createSelector(v59, function(p194) -- line: 324
            -- upvalues: v60 (copy)
            if p194 == nil then
                return p194
            end

            return p194[v60]
        end),
        selectEquippedBaitAuraName(p193),
        selectPlayerActiveCharmCore(p193)
    }, function(p195, p196, p197, p198) -- line: 904
        -- upvalues: allAquariumData (copy), getAquariumData (copy), resolveCombinedPlayerBuffBonuses (copy)
        local v61 = if p195 == nil then p195 else p195.aquariumLevel

        if v61 == nil then
            v61 = 1
        end

        if v61 + 1 > #allAquariumData then
            return false
        end

        local moneyDiscount = resolveCombinedPlayerBuffBonuses(p197, p198).moneyDiscount
        local v63 = math.floor(getAquariumData(v61).upgradeCost * (1 - moneyDiscount))
        local v64 = v63 > 0

        if not v64 then
            return v64
        end

        return v63 <= (if p196 == nil then 0 else p196)
    end)
end

function selectPlayerFishDisplay(p199) -- line: 931
    return function(p200) -- line: 932
        -- upvalues: p199 (copy)
        return p200.playerData.fishDisplay[p199]
    end
end

local function selectPlayerSelectedDisplayFishId(p201) -- line: 938
    -- upvalues: createSelector (copy), selectPlayerFishDisplay (ref)
    return createSelector(selectPlayerFishDisplay(p201), function(p202) -- line: 939
        if p202 == nil then
            return p202
        end

        return p202.selectedDisplayFishId
    end)
end

function selectPlayerEmotes(p203) -- line: 947
    return function(p204) -- line: 948
        -- upvalues: p203 (copy)
        return p204.playerData.emotes[p203]
    end
end

local function selectEquippedEmoteId(p205) -- line: 954
    -- upvalues: createSelector (copy), selectPlayerEmotes (ref)
    return createSelector(selectPlayerEmotes(p205), function(p206) -- line: 955
        if not p206 then
            return nil
        end

        for _, v65 in p206 do
            if v65.isEquipped then
                return v65.emoteId
            end
        end

        return nil
    end)
end

local function selectPlayerOwnsEmote(p207, p208) -- line: 967
    -- upvalues: createSelector (copy), selectPlayerEmotes (ref)
    return createSelector(selectPlayerEmotes(p207), function(p209) -- line: 968
        -- upvalues: p208 (copy)
        local v67 = if p209 == nil then p209 else p209[p208] ~= nil

        if v67 == nil then
            v67 = false
        end

        return v67
    end)
end

function selectPlayerDanceFloorAura(p210) -- line: 981
    return function(p211) -- line: 982
        -- upvalues: p210 (copy)
        return p211.playerData.danceFloorAura[p210]
    end
end

local function selectPlayerDanceFloorAuraExpiresAt(p212) -- line: 989
    -- upvalues: createSelector (copy), selectPlayerDanceFloorAura (ref)
    return createSelector(selectPlayerDanceFloorAura(p212), function(p213) -- line: 990
        local v68 = if p213 == nil then p213 else p213.buffExpiresAt

        if v68 == nil then
            v68 = 0
        end

        return v68
    end)
end

local function selectPlayerEventShopDailyStock(p214) -- line: 1002
    -- upvalues: createSelector (copy), selectPlayerMetadata (ref)
    return createSelector(selectPlayerMetadata(p214), function(p215) -- line: 1003
        local v69 = if p215 == nil then p215 else p215.eventShopDailyStockDayKey

        if v69 == nil then
            v69 = ""
        end

        local t8 = {
            dayKey = v69
        }
        local v70 = if p215 == nil then p215 else p215.eventShopPurchasesToday

        t8.purchases = if v70 == nil then {} else v70

        return t8
    end)
end

local function selectPlayerDanceFloorAuraTicketMultiplierExpiresAt(p216) -- line: 1028
    -- upvalues: createSelector (copy), selectPlayerDanceFloorAura (ref)
    return createSelector(selectPlayerDanceFloorAura(p216), function(p217) -- line: 1029
        local v71 = if p217 == nil then p217 else p217.ticketMultiplierExpiresAt

        if v71 == nil then
            v71 = 0
        end

        return v71
    end)
end

function selectPlayerHallOfFame(p218) -- line: 1041
    return function(p219) -- line: 1042
        -- upvalues: p218 (copy)
        return p219.playerData.hallOfFame[p218]
    end
end

local function selectPlayerHasLikedHallOfFameMessage(p220, p221) -- line: 1048
    -- upvalues: createSelector (copy), selectPlayerHallOfFame (ref)
    return createSelector(selectPlayerHallOfFame(p220), function(p222) -- line: 1049
        -- upvalues: p221 (copy)
        local v73 = if p222 == nil then p222 else p222.likedMessageIds[p221]

        if v73 == nil then
            v73 = false
        end

        return v73
    end)
end

function selectPlayerOfflineEarnings(p223) -- line: 1063
    return function(p224) -- line: 1064
        -- upvalues: p223 (copy)
        return p224.playerData.offlineEarnings[p223]
    end
end

local function selectPlayerPendingOfflineEarnings(p225) -- line: 1070
    return function(p226) -- line: 1071
        -- upvalues: p225 (copy)
        local v74 = p226.playerData.offlineEarnings[p225]

        if v74 ~= nil then
            v74 = v74.pendingOfflineEarnings
        end

        if v74 == nil then
            v74 = 0
        end

        return v74
    end
end

function selectPlayerCollectionIndex(p227) -- line: 1085
    return function(p228) -- line: 1086
        -- upvalues: p227 (copy)
        return p228.playerData.collectionIndex[p227]
    end
end

local function selectPlayerStatsAndBuildings(p229) -- line: 1092
    -- upvalues: createSelector (copy), selectPlayerStats (ref), selectPlayerPlot (ref)
    return createSelector({
        selectPlayerStats(p229),
        selectPlayerPlot(p229)
    }, function(p230, p231) -- line: 1093
        return if p230 and p231 then {
            stats = p230,
            plot = p231
        } else nil
    end)
end

local function selectEquippedInventoryItem(p232) -- line: 1103
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p232), function(p233) -- line: 1104
        if not p233 then
            return nil
        end

        for _, v75 in p233 do
            if v75.isEquipped then
                return v75
            end
        end

        return nil
    end)
end

local function selectEquippedItemType(p234) -- line: 1116
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p234), function(p235) -- line: 1117
        if not p235 then
            return nil
        end

        for _, v76 in p235 do
            if v76.isEquipped then
                return v76.itemType
            end
        end

        return nil
    end)
end

local function selectEquippedItemName(p236) -- line: 1129
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p236), function(p237) -- line: 1130
        if not p237 then
            return nil
        end

        for _, v77 in p237 do
            if v77.isEquipped then
                return v77.itemName
            end
        end

        return nil
    end)
end

local function selectEquippedItemId(p238) -- line: 1142
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p238), function(p239) -- line: 1143
        if not p239 then
            return nil
        end

        for _, v78 in p239 do
            if v78.isEquipped then
                return v78.itemId
            end
        end

        return nil
    end)
end

local function selectEquippedPickaxeCooldown(p240) -- line: 1161
    -- upvalues: createSelector (copy), getPickaxeCooldown (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p240), function(p241) -- line: 1162
        -- upvalues: getPickaxeCooldown (copy)
        if not p241 then
            return getPickaxeCooldown("pickaxe")
        end

        for _, v79 in p241 do
            if v79.itemType == "pickaxe" and v79.isInToolbar then
                return getPickaxeCooldown(v79.itemName)
            end
        end

        return getPickaxeCooldown("pickaxe")
    end)
end

local function selectEquippedPickaxeGemChance(p242) -- line: 1180
    -- upvalues: createSelector (copy), getPickaxeGemChance (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p242), function(p243) -- line: 1181
        -- upvalues: getPickaxeGemChance (copy)
        if not p243 then
            return getPickaxeGemChance("pickaxe")
        end

        for _, v80 in p243 do
            if v80.itemType == "pickaxe" and v80.isInToolbar then
                return getPickaxeGemChance(v80.itemName)
            end
        end

        return getPickaxeGemChance("pickaxe")
    end)
end

local function selectToolbarSlots(p244) -- line: 1205
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p244), function(p245) -- line: 1206
        if not p245 then
            return {}
        end

        local t9 = {}
        local v81, v82, v83

        for _, v84 in p245 do
            if v84.itemType == "fishingRod" and v84.isInToolbar then
                v81 = v84
            elseif v84.itemType == "trainingWeight" and v84.isInToolbar then
                v82 = v84
            elseif v84.itemType == "slapWeapon" and v84.isInToolbar then
                v83 = v84
            elseif v84.itemType == "fish" or v84.itemType == "pickaxe" and v84.isInToolbar then
                table.insert(t9, v84)
            end
        end

        table.sort(t9, function(p246, p247) -- line: 1227
            return p246.timeStampAdded > p247.timeStampAdded
        end)

        local t10 = {}

        if v81 ~= nil then
            table.insert(t10, v81)
        end

        if v82 ~= nil then
            table.insert(t10, v82)
        elseif #t9 > 0 then
            table.insert(t10, (table.remove(t9, 1)))
        end

        if v83 ~= nil then
            table.insert(t10, v83)
        end

        for _, v86 in t9 do
            if #t10 >= 9 then
                break
            end

            table.insert(t10, v86)
        end

        return t10
    end)
end

local function selectCelebrationToolbarSlots(p248) -- line: 1266
    -- upvalues: createSelector (copy), emoteDefinitionsById (copy), selectPlayerInventory (ref), selectPlayerEmotes (ref)
    return createSelector({
        selectPlayerInventory(p248),
        selectPlayerEmotes(p248)
    }, function(p249, p250) -- line: 1267
        -- upvalues: emoteDefinitionsById (copy)
        local t11 = {}
        local v87, v88

        if p249 then
            local v89, v90

            for _, v91 in p249 do
                if v91.itemType == "fishingRod" and v91.isInToolbar then
                    v89 = v91
                elseif v91.itemType == "slapWeapon" and v91.isInToolbar then
                    v90 = v91
                end

                v88 = v90
                v87 = v89
            end
        end

        if v87 ~= nil then
            table.insert(t11, v87)
        end

        if v88 ~= nil then
            table.insert(t11, v88)
        end

        if p250 then
            local t12 = {}
            local v92 = #t12

            for v93, v94 in p250 do
                v92 += 1
                t12[v92] = { v93, v94 }
            end

            table.sort(t12, function(p251, p252) -- line: 1295
                local v95 = p251[2]
                local v96 = p252[2]

                return v95.toolbarOrder < v96.toolbarOrder
            end)

            for _, v97 in t12 do
                local v98 = v97[2]
                local v99 = emoteDefinitionsById[v98.emoteId]

                if v99 then
                    table.insert(t11, {
                        itemType = "emote",
                        animationId = v99.animationId,
                        imageId = v99.imageId,
                        isEquipped = v98.isEquipped,
                        itemId = v98.emoteId,
                        itemName = v99.displayName,
                        timeStampAdded = v98.timeStampAdded
                    })
                end
            end
        end

        return t11
    end)
end

local function selectSortedPlayerInventory(p253) -- line: 1323
    -- upvalues: createSelector (copy), mapToArray (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p253), function(p254) -- line: 1324
        -- upvalues: mapToArray (copy)
        if not p254 then
            return {}
        end

        local v100 = mapToArray(p254)

        local function v101(p255) -- line: 1330
            if p255.itemType == "pickaxe" then
                return p255.isInToolbar
            end

            return false
        end

        local v102

        for v103, v104 in v100 do
            local _ = v103 - 1

            if (v104.itemType == "pickaxe" and v104.isInToolbar) == true then
                v102 = v104
                break
            end

            v102 = nil
        end

        local t14 = {}

        for _, v105 in v100 do
            local v106 = v105.itemType == "pickaxe"

            v106 = v106 and v105.itemId == (if v102 == nil then v102 else v102.itemId)

            if not v106 and v105.itemType ~= "pickaxe" then
                table.insert(t14, v105)
            end
        end

        table.sort(t14, function(p256, p257) -- line: 1360
            return p256.timeStampAdded < p257.timeStampAdded
        end)

        local t15 = {}

        if v102 then
            table.insert(t15, v102)
        end

        for _, v107 in t14 do
            table.insert(t15, v107)
        end

        return t15
    end)
end

local function selectActiveRodPowerCap(p258) -- line: 1373
    -- upvalues: createSelector (copy), fishingRodsData (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p258), function(p259) -- line: 1374
        -- upvalues: fishingRodsData (copy)
        if not p259 then
            return 1e999
        end

        for _, v108 in p259 do
            if v108.itemType == "fishingRod" and v108.isInToolbar then
                local v109 = fishingRodsData[v108.itemName]

                if v109 ~= nil then
                    v109 = v109.powerCap
                end

                if v109 == nil then
                    v109 = 1e999
                end

                return v109
            end
        end

        return 1e999
    end)
end

local function selectEquippedRodName(p260) -- line: 1395
    -- upvalues: createSelector (copy), selectPlayerInventory (ref)
    return createSelector(selectPlayerInventory(p260), function(p261) -- line: 1396
        if not p261 then
            return nil
        end

        for _, v110 in p261 do
            if v110.itemType == "fishingRod" and v110.isInToolbar then
                return v110.itemName
            end
        end

        return nil
    end)
end

function selectPlayerFishingRodSkins(p262) -- line: 1408
    return function(p263) -- line: 1409
        -- upvalues: p262 (copy)
        return p263.playerData.rodSkins[p262]
    end
end

local function selectPlayerOwnedFishingRodSkinIds(p264) -- line: 1415
    -- upvalues: createSelector (copy), selectPlayerFishingRodSkins (ref)
    return createSelector(selectPlayerFishingRodSkins(p264), function(p265) -- line: 1416
        local v111 = if p265 == nil then p265 else p265.ownedSkinIds

        if v111 == nil then
            v111 = {}
        end

        return v111
    end)
end

local function selectEquippedFishingRodSkinId(p266) -- line: 1428
    -- upvalues: createSelector (copy), selectPlayerFishingRodSkins (ref)
    return createSelector(selectPlayerFishingRodSkins(p266), function(p267) -- line: 1429
        if p267 == nil then
            return p267
        end

        return p267.equippedSkinId
    end)
end

function selectPlayerRebirth(p268) -- line: 1437
    return function(p269) -- line: 1438
        -- upvalues: p268 (copy)
        return p269.playerData.rebirth[p268]
    end
end

function selectPlayerTitles(p270) -- line: 1444
    return function(p271) -- line: 1445
        -- upvalues: p270 (copy)
        return p271.playerData.titles[p270]
    end
end

local function selectPlayerUnlockedTitles(p272) -- line: 1451
    -- upvalues: createSelector (copy), selectPlayerTitles (ref)
    return createSelector(selectPlayerTitles(p272), function(p273) -- line: 1452
        local v112 = if p273 == nil then p273 else p273.unlockedTitles

        if v112 == nil then
            v112 = {}
        end

        return v112
    end)
end

local function selectPlayerEquippedTitle(p274) -- line: 1464
    return function(p275) -- line: 1465
        -- upvalues: p274 (copy)
        local v113 = p275.playerData.titles[p274]

        if v113 ~= nil then
            v113 = v113.equippedTitle
        end

        return v113
    end
end

function selectPlayerFishReelbackVfx(p276) -- line: 1475
    return function(p277) -- line: 1476
        -- upvalues: p276 (copy)
        return p277.playerData.fishReelbackVfx[p276]
    end
end

local function selectPlayerEquippedFishReelbackVfxId(p278) -- line: 1482
    -- upvalues: createSelector (copy), selectPlayerFishReelbackVfx (ref)
    return createSelector(selectPlayerFishReelbackVfx(p278), function(p279) -- line: 1483
        if p279 == nil then
            return p279
        end

        return p279.equippedVfxId
    end)
end

local function selectPlayerOwnsFishReelbackVfx(p280, p281) -- line: 1491
    -- upvalues: createSelector (copy), selectPlayerFishReelbackVfx (ref)
    return createSelector(selectPlayerFishReelbackVfx(p280), function(p282) -- line: 1492
        -- upvalues: p281 (copy)
        local v115

        if p282 ~= nil then
            local ownedVfxIds = p282.ownedVfxIds

            v115 = table.find(ownedVfxIds, p281) ~= nil
        else
            v115 = p282
        end

        if v115 == nil then
            v115 = false
        end

        return v115
    end)
end

local function selectPlayerRebirthCount(p283) -- line: 1506
    return function(p284) -- line: 1507
        -- upvalues: p283 (copy)
        local v116 = p284.playerData.rebirth[p283]

        if v116 ~= nil then
            v116 = v116.rebirthCount
        end

        if v116 == nil then
            v116 = 0
        end

        return v116
    end
end

local function selectPlayerTotalRobuxSpent(p285) -- line: 1521
    return function(p286) -- line: 1522
        -- upvalues: p285 (copy)
        local v117 = p286.playerData.metadata[p285]

        if v117 ~= nil then
            v117 = v117.totalRobuxSpent
        end

        if v117 == nil then
            v117 = 0
        end

        return v117
    end
end

local function selectPlayerCurrentBestZone(p287) -- line: 1536
    return function(p288) -- line: 1537
        -- upvalues: p287 (copy)
        local v118 = p288.playerData.rebirth[p287]

        if v118 ~= nil then
            v118 = v118.currentBestZone
        end

        if v118 == nil then
            v118 = 0
        end

        return v118
    end
end

local function selectPlayerPreviousRebirthBestZone(p289) -- line: 1551
    return function(p290) -- line: 1552
        -- upvalues: p289 (copy)
        local v119 = p290.playerData.rebirth[p289]

        if v119 ~= nil then
            v119 = v119.previousRebirthBestZone
        end

        if v119 == nil then
            v119 = 0
        end

        return v119
    end
end

return {
    selectPlayerData = selectPlayerData,
    selectPlayerMetadata = selectPlayerMetadata,
    selectPlayerBackpackUpgradeCount = selectPlayerBackpackUpgradeCount,
    selectPlayerHasLikedCommunityMember = selectPlayerHasLikedCommunityMember,
    selectDayLastClaimedDailyReward = selectDayLastClaimedDailyReward,
    selectDayLastClaimedCelebrationReward = selectDayLastClaimedCelebrationReward,
    selectPlayerPreLogoutBuff = selectPlayerPreLogoutBuff,
    selectPlayerTicketCapProgress = selectPlayerTicketCapProgress,
    selectPlayerClaimedChallengeTierIds = selectPlayerClaimedChallengeTierIds,
    selectPlayerAudioSettings = selectPlayerAudioSettings,
    selectPlayerBossAutokillEnabled = selectPlayerBossAutokillEnabled,
    selectPlayerBaitAuras = selectPlayerBaitAuras,
    selectPlayerCharms = selectPlayerCharms,
    selectPlayerDisplayedCharmId = selectPlayerDisplayedCharmId,
    selectPlayerActiveCharmCore = selectPlayerActiveCharmCore,
    selectPlayerPendingCharmCandidate = selectPlayerPendingCharmCandidate,
    selectPlayerBuffBonuses = selectPlayerBuffBonuses,
    selectPlayerMounts = selectPlayerMounts,
    selectPlayerActiveMountName = selectPlayerActiveMountName,
    selectPlayerIsMounted = selectPlayerIsMounted,
    selectPlayerOwnedMountNames = selectPlayerOwnedMountNames,
    selectPlayerZoneGacha = selectPlayerZoneGacha,
    selectPlayerZoneGachaOwnedItemIds = selectPlayerZoneGachaOwnedItemIds,
    selectEquippedBaitAuraName = selectEquippedBaitAuraName,
    selectPlaytimeRewardEligibilityData = selectPlaytimeRewardEligibilityData,
    selectPlayerStats = selectPlayerStats,
    selectPlayerHighScorePosition = selectPlayerHighScorePosition,
    selectPlayerStat = selectPlayerStat,
    selectCanAffordCost = selectCanAffordCost,
    selectPlayerOwnsPickaxe = selectPlayerOwnsPickaxe,
    selectPlayerRewards = selectPlayerRewards,
    selectPlayerInventory = selectPlayerInventory,
    selectPlayerMaterials = selectPlayerMaterials,
    selectPlayerFishingContracts = selectPlayerFishingContracts,
    selectPlayerInventoryItem = selectPlayerInventoryItem,
    selectInventoryFishLevel = selectInventoryFishLevel,
    selectInventoryFishMutations = selectInventoryFishMutations,
    selectPlayerPickaxeByItemName = selectPlayerPickaxeByItemName,
    selectPlayerOwnedPickaxeNamesKey = selectPlayerOwnedPickaxeNamesKey,
    selectPlayerOwnedPickaxeNames = selectPlayerOwnedPickaxeNames,
    selectNextPickaxeUpgrade = selectNextPickaxeUpgrade,
    selectNextCheapestPickaxeUpgrade = selectNextCheapestPickaxeUpgrade,
    selectPlayerPlot = selectPlayerPlot,
    selectPlayerPlotLikes = selectPlayerPlotLikes,
    selectPlayerShowcaseFish = selectPlayerShowcaseFish,
    selectPlayerEquippedHologramSkin = selectPlayerEquippedHologramSkin,
    selectPlayerOwnedHologramSkins = selectPlayerOwnedHologramSkins,
    selectPlayerTutorialTracking = selectPlayerTutorialTracking,
    selectPlayerGamepasses = selectPlayerGamepasses,
    selectPlayerOwnsGamepass = selectPlayerOwnsGamepass,
    selectPlayerPurchaseHistory = selectPlayerPurchaseHistory,
    selectPlayerBundlePurchaseHistory = selectPlayerBundlePurchaseHistory,
    selectPlayerAquarium = selectPlayerAquarium,
    selectPlayerAquariumUncollectedMoney = selectPlayerAquariumUncollectedMoney,
    selectPlayerAquariumLevel = selectPlayerAquariumLevel,
    selectPlayerAquariumFishItems = selectPlayerAquariumFishItems,
    selectPlayerAquariumUpgradeStartedTimestamp = selectPlayerAquariumUpgradeStartedTimestamp,
    selectPlayerAquariumUpgradeCompleteTimestamp = selectPlayerAquariumUpgradeCompleteTimestamp,
    selectPlayerAquariumOwnedSkins = selectPlayerAquariumOwnedSkins,
    selectPlayerAquariumCratePityCount = selectPlayerAquariumCratePityCount,
    selectPlayerAquariumUniversalSkinShards = selectPlayerAquariumUniversalSkinShards,
    selectPlayerAquariumSkinShardBalances = selectPlayerAquariumSkinShardBalances,
    selectPlayerAquariumSkinShardBalance = selectPlayerAquariumSkinShardBalance,
    selectPlayerAquariumLifetimeShardsEarned = selectPlayerAquariumLifetimeShardsEarned,
    selectPlayerAquariumLifetimeShardEarned = selectPlayerAquariumLifetimeShardEarned,
    selectPlayerAquariumSkinRollCount = selectPlayerAquariumSkinRollCount,
    selectPlayerHasClaimedFreeAquariumCratePull = selectPlayerHasClaimedFreeAquariumCratePull,
    selectPlayerHasClaimedAquariumCrateFirstPurchase = selectPlayerHasClaimedAquariumCrateFirstPurchase,
    selectPlayerPendingAquariumCrateReveals = selectPlayerPendingAquariumCrateReveals,
    selectPlayerAquariumMoneyPerSecond = selectPlayerAquariumMoneyPerSecond,
    selectCanAffordAquariumUpgrade = selectCanAffordAquariumUpgrade,
    selectPlayerFishDisplay = selectPlayerFishDisplay,
    selectPlayerSelectedDisplayFishId = selectPlayerSelectedDisplayFishId,
    selectPlayerEmotes = selectPlayerEmotes,
    selectEquippedEmoteId = selectEquippedEmoteId,
    selectPlayerOwnsEmote = selectPlayerOwnsEmote,
    selectPlayerDanceFloorAura = selectPlayerDanceFloorAura,
    selectPlayerDanceFloorAuraExpiresAt = selectPlayerDanceFloorAuraExpiresAt,
    selectPlayerEventShopDailyStock = selectPlayerEventShopDailyStock,
    selectPlayerDanceFloorAuraTicketMultiplierExpiresAt = selectPlayerDanceFloorAuraTicketMultiplierExpiresAt,
    selectPlayerHallOfFame = selectPlayerHallOfFame,
    selectPlayerHasLikedHallOfFameMessage = selectPlayerHasLikedHallOfFameMessage,
    selectPlayerOfflineEarnings = selectPlayerOfflineEarnings,
    selectPlayerPendingOfflineEarnings = selectPlayerPendingOfflineEarnings,
    selectPlayerCollectionIndex = selectPlayerCollectionIndex,
    selectPlayerStatsAndBuildings = selectPlayerStatsAndBuildings,
    selectEquippedInventoryItem = selectEquippedInventoryItem,
    selectEquippedItemType = selectEquippedItemType,
    selectEquippedItemName = selectEquippedItemName,
    selectEquippedItemId = selectEquippedItemId,
    selectEquippedPickaxeCooldown = selectEquippedPickaxeCooldown,
    selectEquippedPickaxeGemChance = selectEquippedPickaxeGemChance,
    selectToolbarSlots = selectToolbarSlots,
    selectCelebrationToolbarSlots = selectCelebrationToolbarSlots,
    selectSortedPlayerInventory = selectSortedPlayerInventory,
    selectActiveRodPowerCap = selectActiveRodPowerCap,
    selectEquippedRodName = selectEquippedRodName,
    selectPlayerFishingRodSkins = selectPlayerFishingRodSkins,
    selectPlayerOwnedFishingRodSkinIds = selectPlayerOwnedFishingRodSkinIds,
    selectEquippedFishingRodSkinId = selectEquippedFishingRodSkinId,
    selectPlayerRebirth = selectPlayerRebirth,
    selectPlayerTitles = selectPlayerTitles,
    selectPlayerUnlockedTitles = selectPlayerUnlockedTitles,
    selectPlayerEquippedTitle = selectPlayerEquippedTitle,
    selectPlayerFishReelbackVfx = selectPlayerFishReelbackVfx,
    selectPlayerEquippedFishReelbackVfxId = selectPlayerEquippedFishReelbackVfxId,
    selectPlayerOwnsFishReelbackVfx = selectPlayerOwnsFishReelbackVfx,
    selectPlayerRebirthCount = selectPlayerRebirthCount,
    selectPlayerTotalRobuxSpent = selectPlayerTotalRobuxSpent,
    selectPlayerCurrentBestZone = selectPlayerCurrentBestZone,
    selectPlayerPreviousRebirthBestZone = selectPlayerPreviousRebirthBestZone
}

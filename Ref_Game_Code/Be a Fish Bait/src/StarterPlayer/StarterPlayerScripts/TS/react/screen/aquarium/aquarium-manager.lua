-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players = services.HttpService, services.Players
local default = RuntimeLib.import(script, script.Parent, "aquarium-menu").default
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-add-fish").default
local default3 = RuntimeLib.import(script, script.Parent, "aquarium-stats-panel").default
local getAquariumStatBoosts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "hoola-bonus-utils").getAquariumStatBoosts
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquarium, selectPlayerInventory, selectPlayerGamepasses, selectPlayerRewards = selectors.selectPlayerAquarium, selectors.selectPlayerInventory, selectors.selectPlayerGamepasses, selectors.selectPlayerRewards
local selectPlayerShowcaseFish, selectPlayerStat, selectPlayerAquariumMoneyPerSecond, selectPlayerBuffBonuses = selectors.selectPlayerShowcaseFish, selectors.selectPlayerStat, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerBuffBonuses
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local getAquariumData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumData
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local promptCashPurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").promptCashPurchase
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils")
local calculateAquariumFishCapacity, getLevelUpCost, maxAquariumFishLevel = v1.calculateAquariumFishCapacity, v1.getLevelUpCost, v1.maxAquariumFishLevel
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel, showcaseFishToMpsInput = v2.getAquariumFishEffectiveMoneyPerSecond, v2.getExclusiveFishEditionLabel, v2.showcaseFishToMpsInput
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local offlineEarningsConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "offline-earnings-utils").offlineEarningsConfig
local getMutationColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColor
local getFishMutationDisplayName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").getFishMutationDisplayName
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local aquariumSkinsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").aquariumSkinsData
local getIndexAquariumEarningsBonus = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "index-rewards-utils").getIndexAquariumEarningsBonus
local v3 = tostring(Players.LocalPlayer.UserId)

local function color3ToHex(p1) -- line: 53
    local v5 = math.round(p1.R * 255)
    local v7 = math.round(p1.G * 255)
    local v9 = math.round(p1.B * 255)

    return string.format("#%02X%02X%02X", v5, v7, v9)
end

local function mutationsToRichText(p2) -- line: 59
    -- upvalues: getMutationColor (copy), getFishMutationDisplayName (copy)
    if #p2 == 0 then
        return "<font color=\"#AAAAAA\">No Mutation</font>"
    end

    local v10 = table.create(#p2)

    local function v11(p3) -- line: 65
        -- upvalues: getMutationColor (copy), getFishMutationDisplayName (copy)
        local v12 = getMutationColor(p3)
        local v14 = math.round(v12.R * 255)
        local v16 = math.round(v12.G * 255)
        local v18 = math.round(v12.B * 255)

        return (("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", v14, v16, v18), (getFishMutationDisplayName(p3))))
    end

    for v19, v20 in p2 do
        local _ = v19 - 1
        local v21 = getMutationColor(v20)
        local v23 = math.round(v21.R * 255)
        local v25 = math.round(v21.G * 255)
        local v27 = math.round(v21.B * 255)

        v10[v19] = ("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", v23, v25, v27), (getFishMutationDisplayName(v20)))
    end

    return table.concat(v10, ", ")
end

local function aquariumFishToDisplayData(p4, p5, p6, p7, p8, p9) -- line: 74
    -- upvalues: fishDataByName (copy), isFishData (copy), getLevelUpCost (copy), maxAquariumFishLevel (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), getExclusiveFishConfigByFishName (copy), offlineEarningsConfig (copy), mutationsToRichText (copy)
    local v28 = fishDataByName[p4.fishSpecies]
    local v29, v30, v31, v32

    if v28 ~= nil then
        if isFishData(v28) then
            v29 = getAquariumFishEffectiveMoneyPerSecond(p4, p5, p6, nil, 0, p7, p9)
            v30 = getExclusiveFishEditionLabel(p4.fishSpecies, p4.exclusiveIndex)
            v31 = getExclusiveFishConfigByFishName(p4.fishSpecies) ~= nil
            v32 = false
        else
            v32 = true
        end
    else
        v32 = true
    end

    if v32 then
        return nil
    end

    local t1 = {
        fishId = p4.fishId
    }

    t1.fishName = if v30 == nil then v28.displayName else ("%* (%*)"):format(v28.displayName, v30)
    t1.imageId = v28.imageId
    t1.isExclusive = v31
    t1.isMaxLevel = not v31 and p4.level >= maxAquariumFishLevel

    if v31 then
        t1.level = nil
        t1.levelUpCost = nil
    else
        t1.level = p4.level
        t1.levelUpCost = math.floor(getLevelUpCost(v28.moneyPerSecond, p4.level) * (1 - p8))
    end

    t1.moneyPerSecond = v29
    t1.mutation = mutationsToRichText(p4.mutations)
    t1.offlineEarningPerSec = math.floor(v29 * offlineEarningsConfig.offlineFactor)
    t1.rarity = v28.rarity

    return t1
end

return {
    default = function(p10) -- AquariumManager | line: 97
        -- upvalues: Flamework (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), HttpService (copy), default (copy), default2 (copy), default3 (copy), getAquariumStatBoosts (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerAquarium (copy), selectPlayerInventory (copy), selectPlayerGamepasses (copy), selectPlayerRewards (copy), selectPlayerShowcaseFish (copy), selectPlayerStat (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerBuffBonuses (copy), selectCurrentWindow (copy), getAquariumData (copy), fishDataByName (copy), isFishData (copy), functions (copy), promptCashPurchase (copy), calculateAquariumFishCapacity (copy), getLevelUpCost (copy), maxAquariumFishLevel (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), showcaseFishToMpsInput (copy), getExclusiveFishConfigByFishName (copy), offlineEarningsConfig (copy), selectTutorialStep (copy), tutorialSteps (copy), useSound (copy), aquariumSkinsData (copy), getIndexAquariumEarningsBonus (copy), v3 (copy), mutationsToRichText (copy), aquariumFishToDisplayData (copy)
        local getInitialTab, onClearInitialTab, onClose, onOpenSourceWindow = p10.getInitialTab, p10.onClearInitialTab, p10.onClose, p10.onOpenSourceWindow
        local v35 = useRootProducer()
        local v36 = useRootSelector(selectPlayerAquarium(v3))
        local v37 = useRootSelector(selectPlayerInventory(v3))
        local v39 = showcaseFishToMpsInput((useRootSelector(selectPlayerShowcaseFish(v3))))
        local v40 = useRootSelector(selectPlayerStat(v3, "money"))

        if v40 == nil then
            v40 = 0
        end

        local v41 = useRootSelector(selectPlayerAquariumMoneyPerSecond(v3))
        local moneyDiscount = useRootSelector(selectPlayerBuffBonuses(v3)).moneyDiscount
        local v42 = useRootSelector(selectTutorialStep)
        local v43 = useRootSelector(selectCurrentWindow)
        local playSound = useSound("CuteLevelUp").playSound
        local v44 = useRootSelector(selectPlayerGamepasses(v3))
        local v46 = getIndexAquariumEarningsBonus((useRootSelector(selectPlayerRewards(v3))))
        local v47 = if v36 == nil then v36 else v36.aquariumLevel

        if v47 == nil then
            v47 = 1
        end

        local v48 = calculateAquariumFishCapacity(getAquariumData(v47).maxFish, v44)
        local t2 = {}

        if v36 then
            for _, v49 in v36.fishItems do
                local v50 = aquariumFishToDisplayData(v49, v36.fishItems, v44, v37, moneyDiscount, v39)

                if v50 then
                    table.insert(t2, v50)
                end
            end
        end

        table.sort(t2, function(p11, p12) -- line: 140
            return p11.moneyPerSecond > p12.moneyPerSecond
        end)

        local t3 = {}

        if v36 then
            for v51 in v36.fishItems do
                t3[v51] = true
            end
        end

        local t4 = {}

        if v37 then
            for v52, v53 in v37 do
                if v53.itemType == "fish" and t3[v52] == nil then
                    local v54 = fishDataByName[v53.itemName]

                    if v54 ~= nil and isFishData(v54) then
                        local t5 = {
                            fishId = v52,
                            fishSpecies = v53.itemName,
                            level = v53.level,
                            mutations = v53.mutations
                        }
                        local v55 = if v36 == nil then v36 else v36.fishItems

                        if v55 == nil then
                            v55 = {}
                        end

                        local v56 = getAquariumFishEffectiveMoneyPerSecond(t5, v55, v44, nil, 0, v37, v39)
                        local v57 = getExclusiveFishEditionLabel(v53.itemName, v53.exclusiveIndex)
                        local v58 = getExclusiveFishConfigByFishName(v53.itemName) ~= nil
                        local t6 = {
                            fishId = v52
                        }

                        t6.fishName = if v57 == nil then v54.displayName else ("%* (%*)"):format(v54.displayName, v57)
                        t6.imageId = v54.imageId
                        t6.isExclusive = v58
                        t6.isMaxLevel = not v58 and v53.level >= maxAquariumFishLevel

                        if v58 then
                            t6.level = nil
                            t6.levelUpCost = nil
                        else
                            t6.level = v53.level
                            t6.levelUpCost = math.floor(getLevelUpCost(v54.moneyPerSecond, v53.level) * (1 - moneyDiscount))
                        end

                        t6.moneyPerSecond = v56
                        t6.mutation = mutationsToRichText(v53.mutations)
                        t6.offlineEarningPerSec = math.floor(v56 * offlineEarningsConfig.offlineFactor)
                        t6.rarity = v54.rarity
                        table.insert(t4, t6)
                    end
                end
            end
        end

        table.sort(t4, function(p13, p14) -- line: 196
            return p13.moneyPerSecond > p14.moneyPerSecond
        end)

        local v61 = if v36 == nil then v36 else v36.ownedSkins

        if v61 == nil then
            v61 = { "Default" }
        end

        local v62 = if v36 == nil then v36 else v36.seenSkins

        if v62 == nil then
            v62 = v61
        end

        local v63 = if v36 == nil then v36 else v36.equippedSkin

        if v63 == nil then
            v63 = "Default"
        end

        local t7 = {}
        local n1 = 0

        for v64, v65 in v61 do
            local _ = v64 - 1

            if table.find(v62, v65) == nil == true then
                n1 += 1
                t7[n1] = v65
            end
        end

        local v66 = #t7
        local t8 = {}

        for _, v67 in aquariumSkinsData do
            table.insert(t8, {
                name = v67.name,
                displayName = v67.displayName,
                description = v67.description,
                imageId = v67.imageId,
                moneyBoost = v67.moneyBoost,
                moneyPrice = v67.moneyPrice,
                robuxPrice = v67.robuxPrice,
                rarity = v67.rarity,
                source = v67.source
            })
        end

        local v68, v69 = useState(false)
        local v70, v71 = useState(false)
        local v72, v73 = useState(false)
        local v74, v75 = useState(false)
        local v76, v77 = useState(0)

        if v36 ~= nil then
            v36 = v36.fishItems
        end

        local v78 = getAquariumStatBoosts(v36, v61)
        local v79 = useRef({})
        local v80 = useRef({})
        local v81 = useRef(v43)

        useEffect(function() -- line: 273
            -- upvalues: v43 (copy), v77 (copy), v81 (copy)
            if v81.current ~= "aquarium" and v43 == "aquarium" then
                v77(function(p15) -- line: 275
                    return p15 + 1
                end)
            end

            v81.current = v43
        end, { v43 })

        local function v82() -- line: 281
            -- upvalues: v68 (copy), v69 (copy), v71 (copy), v73 (copy), v75 (copy)
            if v68 then
                v69(false)
            else
                v71(true)
                v69(true)
                v73(false)
                v75(false)
            end
        end

        local function v83() -- line: 291
            -- upvalues: v69 (copy), v71 (copy), v72 (copy), v73 (copy), v75 (copy)
            if v72 then
                v73(false)
            else
                v75(true)
                v73(true)
                v69(false)
                v71(false)
            end
        end

        local function v84() -- line: 301
            -- upvalues: v35 (copy), v42 (copy), v77 (copy), HttpService (copy), functions (copy), tutorialSteps (copy)
            functions.equipBestAquariumFish():andThen(function(p16) -- line: 302
                -- upvalues: v35 (copy), v42 (copy), v77 (copy), HttpService (copy), tutorialSteps (copy)
                v35.onScreenFeedbackAdded({
                    message = "Best fishes equipped!",
                    type = "neutral",
                    id = HttpService:GenerateGUID(false)
                })
                v77(function(p17) -- line: 308
                    return p17 + 1
                end)

                if p16 and v42 == tutorialSteps.equipBestFish then
                    v35.tutorialStepUpdated({
                        step = tutorialSteps.collectMoney
                    })
                end
            end)
        end

        local function v85() -- line: 318
            -- upvalues: onClose (copy), v69 (copy), v71 (copy), v73 (copy), v75 (copy)
            onClose()
            v69(false)
            v71(false)
            v73(false)
            v75(false)
        end

        local createElement, Fragment = react.createElement, react.Fragment
        local v102 = react.createElement(default, {
            capacity = v48,
            equippedSkin = v63,
            fish = t2,
            getInitialTab = getInitialTab,
            indexEarningsBoost = v46,
            newSkinCount = v66,
            onAddFish = v82,
            onClearInitialTab = onClearInitialTab,
            onClose = v85,
            onEquipBest = v84,
            onEquipSkin = function(p18) -- onEquipSkin | line: 336
                -- upvalues: v35 (copy), HttpService (copy), functions (copy)
                functions.markAquariumSkinSeen(p18)
                functions.equipAquariumSkin(p18):catch(function() -- line: 338
                    -- upvalues: v35 (copy), HttpService (copy)
                    v35.onScreenFeedbackAdded({
                        message = "Could not equip skin",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end)
            end,
            onLevelUp = function(p19) -- onLevelUp | line: 346
                -- upvalues: v35 (copy), v40 (ref), v41 (copy), v42 (copy), playSound (copy), t2 (copy), v79 (copy), v80 (copy), HttpService (copy), functions (copy), promptCashPurchase (copy), tutorialSteps (copy)
                if v80.current[p19] ~= nil then
                    return nil
                end

                local v86

                for v87, v88 in t2 do
                    local _ = v87 - 1

                    if v88.fishId == p19 == true then
                        v86 = v88
                        break
                    end

                    v86 = nil
                end

                local v89 = if v86 == nil then v86 else v86.level

                if v89 ~= nil then
                    local v90 = if v86 == nil then v86 else v86.levelUpCost

                    if v90 == nil then
                        v90 = 0
                    end

                    if not (v90 > 0 and v40 < v90) then
                        v80.current[p19] = true

                        local v91 = functions.levelUpAquariumFish(p19)
                        local v92 = v86

                        v91:andThen(function(p20) -- line: 394
                            -- upvalues: p19 (copy), v89 (copy), v92 (copy), v35 (copy), v42 (copy), playSound (copy), v79 (copy), v80 (copy), HttpService (copy), tutorialSteps (copy)
                            v80.current[p19] = nil

                            if not p20 or v92 == nil then
                                return
                            else
                                playSound()

                                local v94 = v79.current[p19]

                                if v94 ~= nil then
                                    v35.onScreenFeedbackRemoved({
                                        id = v94
                                    })
                                    v79.current[p19] = nil
                                end
                            end

                            local v95 = HttpService:GenerateGUID(false)

                            v79.current[p19] = v95
                            v35.onScreenFeedbackAdded({
                                type = "success",
                                id = v95,
                                message = ("%* is now level %*!"):format(v92.fishName, v89 + 1)
                            })

                            if v42 == tutorialSteps.levelUpFish then
                                v35.tutorialStepUpdated({
                                    step = tutorialSteps.goToWeightsShop
                                })
                            end
                        end)

                        return
                    end

                    v35.onScreenFeedbackAdded({
                        message = "Not enough money!",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                    promptCashPurchase(v90, v41)
                end

                return nil
            end,
            onOpenSourceWindow = onOpenSourceWindow,
            onPreviewSkin = function(p21) -- onPreviewSkin | line: 429
                -- upvalues: v47 (ref), Flamework (copy)
                return Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):startPreview(p21, v47)
            end,
            onPurchaseSkin = function(p22) -- onPurchaseSkin | line: 432
                -- upvalues: v35 (copy), v40 (ref), v41 (copy), t8 (copy), HttpService (copy), functions (copy), promptCashPurchase (copy)
                local v96

                for v97, v98 in t8 do
                    local _ = v97 - 1

                    if v98.name == p22 == true then
                        v96 = v98
                        break
                    end

                    v96 = nil
                end

                if v96 ~= nil then
                    v96 = v96.moneyPrice
                end

                if v96 == nil then
                    v96 = 0
                end

                if v96 > 0 and v40 < v96 then
                    v35.onScreenFeedbackAdded({
                        message = "Not enough money!",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                    promptCashPurchase(v96, v41)

                    return nil
                end

                functions.purchaseAquariumSkin(p22):andThen(function(p23) -- line: 464
                    -- upvalues: v35 (copy), HttpService (copy)
                    v35.onScreenFeedbackAdded({
                        id = HttpService:GenerateGUID(false),
                        message = p23 and "Skin purchased!" or "Could not purchase skin",
                        type = p23 and "neutral" or "error"
                    })
                end)
            end,
            onRemove = function(p24) -- onRemove | line: 472
                -- upvalues: v35 (copy), t2 (copy), HttpService (copy), functions (copy)
                local v99

                for v100, v101 in t2 do
                    local _ = v100 - 1

                    if v101.fishId == p24 == true then
                        v99 = v101
                        break
                    end

                    v99 = nil
                end

                functions.unequipAquariumFish(p24):andThen(function(p25) -- line: 486
                    -- upvalues: v99 (ref), v35 (copy), HttpService (copy)
                    if p25 and v99 ~= nil then
                        v35.onScreenFeedbackAdded({
                            type = "neutral",
                            id = HttpService:GenerateGUID(false),
                            message = ("%* removed from aquarium!"):format(v99.fishName)
                        })
                    end
                end)
            end,
            onSkinsTab = function() -- onSkinsTab | line: 496
                -- upvalues: v69 (copy)
                return v69(false)
            end,
            onViewStats = v83,
            ownedSkins = v61,
            refreshKey = v76,
            skins = t8,
            tutorialStep = v42
        })

        v70 = v70 and react.createElement(default2, {
            fish = t4,
            isClosing = not v68,
            onClose = function() -- onClose | line: 507
                -- upvalues: v69 (copy)
                return v69(false)
            end,
            onCloseComplete = function() -- onCloseComplete | line: 510
                -- upvalues: v71 (copy)
                return v71(false)
            end,
            onSelectFish = function(p26) -- onSelectFish | line: 513
                -- upvalues: v35 (copy), v42 (copy), t4 (copy), v77 (copy), HttpService (copy), functions (copy), tutorialSteps (copy)
                local v103

                for v104, v105 in t4 do
                    local _ = v104 - 1

                    if v105.fishId == p26 == true then
                        v103 = v105
                        break
                    end

                    v103 = nil
                end

                functions.addFishToAquarium(p26):andThen(function(p27) -- line: 527
                    -- upvalues: v103 (ref), v35 (copy), v42 (copy), v77 (copy), HttpService (copy), tutorialSteps (copy)
                    local t13 = {
                        id = HttpService:GenerateGUID(false)
                    }

                    if p27 then
                        local v106 = v103

                        if v103 ~= nil then
                            v106 = v103.fishName
                        end

                        if v106 == nil then
                            v106 = "Fish"
                        end

                        t13.message = ("%* added to aquarium!"):format(v106)
                    else
                        t13.message = "Could not add fish"
                    end

                    t13.type = p27 and "neutral" or "error"
                    v35.onScreenFeedbackAdded(t13)

                    if p27 then
                        v77(function(p28) -- line: 550
                            return p28 + 1
                        end)

                        if v42 == tutorialSteps.equipBestFish then
                            v35.tutorialStepUpdated({
                                step = tutorialSteps.collectMoney
                            })
                        end
                    end
                end)
            end
        })
        v74 = v74 and react.createElement(default3, {
            boosts = v78,
            isClosing = not v72,
            moneyPerSecond = v41,
            onClose = function() -- onClose | line: 565
                -- upvalues: v73 (copy)
                return v73(false)
            end,
            onCloseComplete = function() -- onCloseComplete | line: 568
                -- upvalues: v75 (copy)
                return v75(false)
            end
        })

        return createElement(Fragment, nil, v102, v70, v74)
    end
}

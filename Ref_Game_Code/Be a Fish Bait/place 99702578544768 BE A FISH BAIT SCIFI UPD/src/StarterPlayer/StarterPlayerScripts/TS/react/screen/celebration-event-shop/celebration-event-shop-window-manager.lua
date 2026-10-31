-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, RunService, Workspace = services.HttpService, services.RunService, services.Workspace
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumOwnedSkins, selectPlayerCharms, selectPlayerEventShopDailyStock, selectPlayerOwnedHologramSkins = selectors.selectPlayerAquariumOwnedSkins, selectors.selectPlayerCharms, selectors.selectPlayerEventShopDailyStock, selectors.selectPlayerOwnedHologramSkins
local selectPlayerOwnsEmote, selectPlayerOwnsFishReelbackVfx, selectPlayerRewards, selectPlayerStat = selectors.selectPlayerOwnsEmote, selectors.selectPlayerOwnsFishReelbackVfx, selectors.selectPlayerRewards, selectors.selectPlayerStat
local selectPlayerUnlockedTitles = selectors.selectPlayerUnlockedTitles
local getDayKey = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getDayKey
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config")
local celebrationTimeSkipShopItems, fomoAquariumSkinShopItemId, fomoOrbitShopItemId, fomoOrbitTicketMultiplier = v1.celebrationTimeSkipShopItems, v1.fomoAquariumSkinShopItemId, v1.fomoOrbitShopItemId, v1.fomoOrbitTicketMultiplier
local getCelebrationEventShopStockRemaining, markOfTheOgShopItemId, ogPrimeDeveloperProductId, ogPrimeShopItemId = v1.getCelebrationEventShopStockRemaining, v1.markOfTheOgShopItemId, v1.ogPrimeDeveloperProductId, v1.ogPrimeShopItemId
local premiumFishHologramDeveloperProductId, premiumFomoCharmDeveloperProductId = v1.premiumFishHologramDeveloperProductId, v1.premiumFomoCharmDeveloperProductId
local default2 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-window").default
local getFishReelbackVfxData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish-reelback-vfx").getFishReelbackVfxData
local v2 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-catalog")
local auraRerollShopItems, celebrationEventShopComingSoonItems, celebrationEventShopCosmeticPairs, celebrationEventShopFeaturedItems = v2.auraRerollShopItems, v2.celebrationEventShopComingSoonItems, v2.celebrationEventShopCosmeticPairs, v2.celebrationEventShopFeaturedItems
local celebrationEventShopMoreRewards, fomoCharmShopItemId, hookShowcaseSkinShopItemId, premiumFomoCharmShopItemId = v2.celebrationEventShopMoreRewards, v2.fomoCharmShopItemId, v2.hookShowcaseSkinShopItemId, v2.premiumFomoCharmShopItemId
local premiumHookShowcaseSkinShopItemId, scubaEmoteShopItemId = v2.premiumHookShowcaseSkinShopItemId, v2.scubaEmoteShopItemId
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "emotes").emoteDefinitionsById[scubaEmoteShopItemId]
local v4 = if v3 == nil then v3 else v3.ticketPrice
local v5 = ("Unknown paid emote \"%*\""):format(scubaEmoteShopItemId)

assert(v4 ~= nil, v5)

local PartyFishLandingVFX = getFishReelbackVfxData("PartyFishLandingVFX")

assert(PartyFishLandingVFX, "Unknown Fish Reelback VFX \"PartyFishLandingVFX\"")

return {
    default = function() -- CelebrationEventShopWindowManager | line: 69
        -- upvalues: Flamework (copy), react (copy), useEffect (copy), useState (copy), HttpService (copy), RunService (copy), Workspace (copy), events (copy), functions (copy), attemptStorePurchase (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), default (copy), getTitleData (copy), selectPlayerAquariumOwnedSkins (copy), selectPlayerCharms (copy), selectPlayerEventShopDailyStock (copy), selectPlayerOwnedHologramSkins (copy), selectPlayerOwnsEmote (copy), selectPlayerOwnsFishReelbackVfx (copy), selectPlayerRewards (copy), selectPlayerStat (copy), selectPlayerUnlockedTitles (copy), getDayKey (copy), celebrationTimeSkipShopItems (copy), fomoAquariumSkinShopItemId (copy), fomoOrbitShopItemId (copy), fomoOrbitTicketMultiplier (copy), getCelebrationEventShopStockRemaining (copy), markOfTheOgShopItemId (copy), ogPrimeDeveloperProductId (copy), ogPrimeShopItemId (copy), premiumFishHologramDeveloperProductId (copy), premiumFomoCharmDeveloperProductId (copy), default2 (copy), auraRerollShopItems (copy), celebrationEventShopComingSoonItems (copy), celebrationEventShopCosmeticPairs (copy), celebrationEventShopFeaturedItems (copy), celebrationEventShopMoreRewards (copy), fomoCharmShopItemId (copy), hookShowcaseSkinShopItemId (copy), premiumFomoCharmShopItemId (copy), premiumHookShowcaseSkinShopItemId (copy), scubaEmoteShopItemId (copy), v3 (copy), PartyFishLandingVFX (copy)
        local v7 = useRootProducer()
        local v8 = useRootSelector(selectPlayerStat(localPlayerUserId, "tickets"))

        if v8 == nil then
            v8 = 0
        end

        local v9 = useRootSelector(selectPlayerOwnsFishReelbackVfx(localPlayerUserId, "PartyFishLandingVFX"))
        local v10 = useRootSelector(selectPlayerOwnsEmote(localPlayerUserId, scubaEmoteShopItemId))
        local v11 = useRootSelector(selectPlayerUnlockedTitles(localPlayerUserId))
        local v12 = useRootSelector(selectPlayerAquariumOwnedSkins(localPlayerUserId)) or {}
        local v13 = useRootSelector(selectPlayerCharms(localPlayerUserId))

        if v13 ~= nil then
            v13 = v13.ownedCharmIds
        end

        if v13 == nil then
            v13 = {}
        end

        local v14 = useRootSelector(selectPlayerOwnedHologramSkins(localPlayerUserId))
        local v15 = useRootSelector(selectPlayerEventShopDailyStock(localPlayerUserId))
        local v16 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v17, v18 = useState(function() -- line: 92
            -- upvalues: Workspace (copy), getDayKey (copy)
            return getDayKey(Workspace:GetServerTimeNow())
        end)
        local v19 = table.find(v11, "markOfTheOg") ~= nil
        local v20 = table.find(v11, "ogPrime") ~= nil
        local v21, v22 = useState(nil)
        local v23, v24 = useState(nil)
        local v25 = if v21 == nil then nil else getTitleData(v21)

        local function v26(p1) -- line: 100
            -- upvalues: v24 (copy), celebrationEventShopCosmeticPairs (copy), celebrationEventShopFeaturedItems (copy), celebrationEventShopMoreRewards (copy)
            local v27

            for v28, v29 in celebrationEventShopCosmeticPairs do
                local _ = v28 - 1

                if (v29.standard.id == p1 or v29.premium.id == p1) == true then
                    v27 = v29
                    break
                end

                v27 = nil
            end

            local v30 = if v27 == nil then v27 else v27.standard.id
            local v31 = if v30 == p1 then v27.standard elseif (if v27 == nil then v27 else v27.premium.id) == p1 then v27.premium else nil
            local v32

            for v33, v34 in celebrationEventShopFeaturedItems do
                local _ = v33 - 1

                if v34.id == p1 == true then
                    v32 = v34
                    break
                end

                v32 = nil
            end

            if v32 ~= nil then
                v31 = v32
            else
                local v35

                for v36, v37 in celebrationEventShopMoreRewards do
                    local _ = v36 - 1

                    if v37.id == p1 == true then
                        v35 = v37
                        break
                    end

                    v35 = nil
                end

                if v35 ~= nil then
                    v31 = v35
                end
            end

            if v31 ~= nil then
                v24(v31)
            end
        end

        useEffect(function() -- line: 165
            -- upvalues: v18 (copy), RunService (copy), Workspace (copy), getDayKey (copy)
            local v38 = getDayKey(Workspace:GetServerTimeNow())
            local connection = RunService.Heartbeat:Connect(function() -- line: 167
                -- upvalues: v38 (ref), v18 (copy), Workspace (copy), getDayKey (copy)
                local v39 = getDayKey(Workspace:GetServerTimeNow())

                if v39 == v38 then
                    return nil
                end

                v38 = v39
                v18(v39)
            end)

            return function() -- line: 175
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})
        useEffect(function() -- line: 179
            -- upvalues: events (copy)
            events.analyticsEventShopOpened:fire()
        end, {})

        local v40 = getCelebrationEventShopStockRemaining(fomoOrbitShopItemId, v17, v15.dayKey, v15.purchases)
        local v41 = table.find(v12, "FOMO") ~= nil
        local v42 = table.create(#celebrationEventShopCosmeticPairs)

        local function v43(p2) -- line: 189
            -- upvalues: v8 (ref), v13 (ref), v14 (copy), v19 (copy), v20 (copy), markOfTheOgShopItemId (copy), ogPrimeShopItemId (copy), fomoCharmShopItemId (copy), hookShowcaseSkinShopItemId (copy), premiumFomoCharmShopItemId (copy), premiumHookShowcaseSkinShopItemId (copy)
            local v44 = if p2.standard.id == markOfTheOgShopItemId and v19 then v19 else p2.standard.id == fomoCharmShopItemId and table.find(v13, "fomo") ~= nil or p2.standard.id == hookShowcaseSkinShopItemId and table.find(v14, "Cake") ~= nil
            local v46 = if p2.premium.id == ogPrimeShopItemId and v20 then v20 else p2.premium.id == premiumFomoCharmShopItemId and table.find(v13, "premiumFomo") ~= nil or p2.premium.id == premiumHookShowcaseSkinShopItemId and table.find(v14, "PremiumCake") ~= nil
            local v48 = table.clone(p2)

            setmetatable(v48, nil)

            local v49 = table.clone(p2.standard)

            setmetatable(v49, nil)

            if v44 then
                v49.purchaseState = "owned"
            elseif v8 < p2.standard.price then
                v49.purchaseState = "insufficientFunds"
            else
                v49.purchaseState = "available"
            end

            v48.standard = v49

            local v50 = table.clone(p2.premium)

            setmetatable(v50, nil)
            v50.purchaseState = v46 and "owned" or "available"
            v48.premium = v50

            return v48
        end

        for v51, v52 in celebrationEventShopCosmeticPairs do
            v42[v51] = v43(v52, v51 - 1, celebrationEventShopCosmeticPairs)
        end

        local v53 = table.create(#celebrationEventShopFeaturedItems)

        local function v54(p3) -- line: 213
            -- upvalues: v8 (ref), v9 (copy), v10 (copy), v40 (copy), v41 (copy), fomoAquariumSkinShopItemId (copy), fomoOrbitShopItemId (copy), scubaEmoteShopItemId (copy), v3 (copy), PartyFishLandingVFX (copy)
            local stockCurrent = p3.stockCurrent
            local v55 = p3.id == fomoAquariumSkinShopItemId and v41

            if p3.id == "PartyFishLandingVFX" then
                v55 = v9
            end

            if p3.id == scubaEmoteShopItemId then
                v55 = v10
            end

            if p3.id == fomoOrbitShopItemId then
                stockCurrent = v40
            end

            local v56 = table.clone(p3)

            setmetatable(v56, nil)

            if p3.id == "PartyFishLandingVFX" then
                v56.description = PartyFishLandingVFX.description
            else
                v56.description = p3.description
            end

            if p3.id == "PartyFishLandingVFX" then
                v56.name = PartyFishLandingVFX.displayName
            else
                v56.name = p3.name
            end

            if p3.id == "PartyFishLandingVFX" then
                v56.price = PartyFishLandingVFX.ticketPrice
            elseif p3.id == scubaEmoteShopItemId then
                v56.price = v3.ticketPrice
            else
                v56.price = p3.price
            end

            if v55 then
                v56.purchaseState = "owned"
            elseif stockCurrent ~= nil and stockCurrent <= 0 then
                v56.purchaseState = "limitReached"
            elseif v8 < p3.price then
                v56.purchaseState = "insufficientFunds"
            else
                v56.purchaseState = "available"
            end

            v56.stockCurrent = stockCurrent

            return v56
        end

        for v57, v58 in celebrationEventShopFeaturedItems do
            v53[v57] = v54(v58, v57 - 1, celebrationEventShopFeaturedItems)
        end

        local v59 = table.create(#celebrationEventShopMoreRewards)

        local function v60(p4) -- line: 244
            -- upvalues: v8 (ref), v15 (copy), v16 (copy), v17 (copy), celebrationTimeSkipShopItems (copy), getCelebrationEventShopStockRemaining (copy), auraRerollShopItems (copy)
            local v61

            for v62, v63 in celebrationTimeSkipShopItems do
                local _ = v62 - 1

                if v63.id == p4.id == true then
                    v61 = v63
                    break
                end

                v61 = nil
            end

            local v64

            if v61 ~= nil then
                v64 = getCelebrationEventShopStockRemaining(p4.id, v17, v15.dayKey, v15.purchases)
            else
                local v65 = false

                for v66, v67 in auraRerollShopItems do
                    local _ = v66 - 1

                    if v67.id == p4.id then
                        v65 = true
                        break
                    end
                end

                if v65 then
                    local v68 = v16

                    if v16 ~= nil then
                        v68 = v16[p4.id]
                    end

                    v64 = if v68 == true then 0 else 1
                else
                    v64 = p4.stockCurrent
                end
            end

            local v69 = table.clone(p4)

            setmetatable(v69, nil)

            if v61 ~= nil then
                v69.itemType = "Time Skip"
            else
                v69.itemType = p4.itemType
            end

            if v64 ~= nil and v64 <= 0 then
                v69.purchaseState = "limitReached"
            elseif v8 < p4.price then
                v69.purchaseState = "insufficientFunds"
            else
                v69.purchaseState = "available"
            end

            if v61 ~= nil then
                v69.showStock = true
            else
                v69.showStock = p4.showStock
            end

            v69.stockCurrent = v64

            return v69
        end

        for v70, v71 in celebrationEventShopMoreRewards do
            v59[v70] = v60(v71, v70 - 1, celebrationEventShopMoreRewards)
        end

        return react.createElement(react.Fragment, nil, react.createElement(default2, {
            eventName = "FOMO STORE",
            comingSoonItems = celebrationEventShopComingSoonItems,
            cosmeticPairs = v42,
            featuredItems = v53,
            items = v59,
            onBuyItem = function(p5) -- onBuyItem | line: 314
                -- upvalues: v7 (copy), v9 (copy), v10 (copy), v22 (copy), v26 (copy), HttpService (copy), functions (copy), celebrationTimeSkipShopItems (copy), fomoAquariumSkinShopItemId (copy), fomoOrbitShopItemId (copy), fomoOrbitTicketMultiplier (copy), auraRerollShopItems (copy), fomoCharmShopItemId (copy), hookShowcaseSkinShopItemId (copy), scubaEmoteShopItemId (copy)
                local v72

                for v73, v74 in celebrationTimeSkipShopItems do
                    local _ = v73 - 1

                    if v74.id == p5 == true then
                        v72 = v74
                        break
                    end

                    v72 = nil
                end

                if v72 ~= nil then
                    local v75 = functions.purchaseCelebrationTimeSkip(p5)
                    local v76 = v72

                    v75:andThen(function(p6) -- line: 329
                        -- upvalues: p5 (copy), v76 (copy), v7 (copy), v26 (copy), HttpService (copy)
                        if p6 == "purchased" then
                            v26(p5)

                            local v77 = ("%*-minute Time Skip used!"):format(v76.minutes)

                            v7.onScreenFeedbackAdded({
                                type = "success",
                                id = HttpService:GenerateGUID(false),
                                message = v77
                            })
                        elseif p6 == "insufficientFunds" then
                            v7.onScreenFeedbackAdded({
                                message = "Not enough event tickets.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        elseif p6 == "outOfStock" then
                            v7.onScreenFeedbackAdded({
                                message = "This Time Skip restocks tomorrow.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            v7.onScreenFeedbackAdded({
                                message = "Invalid Time Skip item.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        end
                    end)

                    return nil
                end

                if p5 == fomoAquariumSkinShopItemId then
                    functions.purchaseFomoAquariumSkin():andThen(function(p7) -- line: 344
                        -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy)
                        if p7 == "purchased" then
                            v26(p5)
                            v7.onScreenFeedbackAdded({
                                message = "FOMO Aquarium Skin unlocked with +4% Cash!",
                                type = "success",
                                id = HttpService:GenerateGUID(false)
                            })
                        elseif p7 == "insufficientFunds" then
                            v7.onScreenFeedbackAdded({
                                message = "Not enough event tickets.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            v7.onScreenFeedbackAdded({
                                message = "FOMO Aquarium Skin is already owned.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        end
                    end)

                    return nil
                end

                if p5 == fomoOrbitShopItemId then
                    functions.purchaseFomoOrbit():andThen(function(p8) -- line: 357
                        -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy), fomoOrbitTicketMultiplier (copy)
                        if p8 == "purchased" then
                            v26(p5)

                            local v78 = ("FOMO Orbit activated: x%* Tickets for 1 hour!"):format(fomoOrbitTicketMultiplier)

                            v7.onScreenFeedbackAdded({
                                type = "success",
                                id = HttpService:GenerateGUID(false),
                                message = v78
                            })
                        elseif p8 == "outOfStock" then
                            v7.onScreenFeedbackAdded({
                                message = "FOMO Orbit restocks tomorrow.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            v7.onScreenFeedbackAdded({
                                message = "Not enough event tickets.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        end
                    end)

                    return nil
                end

                if p5 == "PartyFishLandingVFX" then
                    if not v9 then
                        functions.purchaseFishReelbackVfx("PartyFishLandingVFX"):andThen(function(p9) -- line: 373
                            -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy)
                            local v79

                            if p9 then
                                v79 = "VFX purchased!"
                                v26(p5)
                            else
                                v79 = "Could not purchase VFX"
                            end

                            local v80 = p9 and "success" or "error"

                            v7.onScreenFeedbackAdded({
                                id = HttpService:GenerateGUID(false),
                                message = v79,
                                type = v80
                            })
                        end)
                    end

                    return nil
                end

                if p5 == scubaEmoteShopItemId then
                    if not v10 then
                        functions.purchaseEmote(scubaEmoteShopItemId):andThen(function(p10) -- line: 385
                            -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy)
                            if p10 == "purchased" then
                                v26(p5)
                                v7.onScreenFeedbackAdded({
                                    message = "Scuba dance animation purchased!",
                                    type = "success",
                                    id = HttpService:GenerateGUID(false)
                                })
                            elseif p10 == "insufficientFunds" then
                                v7.onScreenFeedbackAdded({
                                    message = "Not enough event tickets.",
                                    type = "error",
                                    id = HttpService:GenerateGUID(false)
                                })
                            elseif p10 == "owned" then
                                v7.onScreenFeedbackAdded({
                                    message = "Scuba dance animation already owned.",
                                    type = "error",
                                    id = HttpService:GenerateGUID(false)
                                })
                            end
                        end)
                    end

                    return nil
                end

                if p5 == fomoCharmShopItemId or p5 == hookShowcaseSkinShopItemId then
                    functions.purchaseCelebrationCosmetic(p5):andThen(function(p11) -- line: 398
                        -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy), fomoCharmShopItemId (copy)
                        if p11 == "purchased" then
                            v26(p5)

                            local v81 = p5 == fomoCharmShopItemId and "FOMO Charm purchased!" or "Fish Hologram Skin purchased!"

                            v7.onScreenFeedbackAdded({
                                type = "success",
                                id = HttpService:GenerateGUID(false),
                                message = v81
                            })
                        elseif p11 == "insufficientFunds" then
                            v7.onScreenFeedbackAdded({
                                message = "Not enough event tickets.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        elseif p11 == "owned" then
                            v7.onScreenFeedbackAdded({
                                message = "This event reward is already owned.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            v7.onScreenFeedbackAdded({
                                message = "Invalid event reward.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        end
                    end)

                    return nil
                end

                local v82 = false

                for v83, v84 in auraRerollShopItems do
                    local _ = v83 - 1

                    if v84.id == p5 then
                        v82 = true
                        break
                    end
                end

                if v82 then
                    functions.purchaseCelebrationAuraReroll(p5):andThen(function(p12) -- line: 425
                        -- upvalues: p5 (copy), v7 (copy), v26 (copy), HttpService (copy)
                        if p12 == "purchased" then
                            v26(p5)
                            v7.onScreenFeedbackAdded({
                                message = "Aura Reroll purchased!",
                                type = "success",
                                id = HttpService:GenerateGUID(false)
                            })
                        elseif p12 == "insufficientFunds" then
                            v7.onScreenFeedbackAdded({
                                message = "Not enough event tickets.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        elseif p12 == "owned" then
                            v7.onScreenFeedbackAdded({
                                message = "This Aura Reroll is already owned.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            v7.onScreenFeedbackAdded({
                                message = "Invalid Aura Reroll.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        end
                    end)

                    return nil
                end

                functions.purchaseCelebrationTitle(p5):andThen(function(p13) -- line: 439
                    -- upvalues: v7 (copy), v22 (copy), HttpService (copy)
                    if p13 == "purchased" then
                        v7.onScreenFeedbackAdded({
                            message = "Purchased Mark of The OG successfully!",
                            type = "success",
                            id = HttpService:GenerateGUID(false)
                        })
                        v22("markOfTheOg")
                    elseif p13 == "insufficientFunds" then
                        v7.onScreenFeedbackAdded({
                            message = "Not enough event tickets.",
                            type = "error",
                            id = HttpService:GenerateGUID(false)
                        })
                    elseif p13 == "owned" then
                        v7.onScreenFeedbackAdded({
                            message = "Mark of The OG is already owned.",
                            type = "error",
                            id = HttpService:GenerateGUID(false)
                        })
                    end
                end)
            end,
            onBuyPremium = function(p14) -- onBuyPremium | line: 450
                -- upvalues: v7 (copy), v13 (ref), v14 (copy), v20 (copy), HttpService (copy), attemptStorePurchase (copy), ogPrimeDeveloperProductId (copy), ogPrimeShopItemId (copy), premiumFishHologramDeveloperProductId (copy), premiumFomoCharmDeveloperProductId (copy), premiumFomoCharmShopItemId (copy), premiumHookShowcaseSkinShopItemId (copy)
                local v85

                if p14 == ogPrimeShopItemId then
                    if v20 then
                        return nil
                    end

                    v85 = ogPrimeDeveloperProductId
                elseif p14 == premiumFomoCharmShopItemId then
                    if table.find(v13, "premiumFomo") ~= nil then
                        return nil
                    end

                    v85 = premiumFomoCharmDeveloperProductId
                elseif p14 == premiumHookShowcaseSkinShopItemId then
                    if table.find(v14, "PremiumCake") ~= nil then
                        return nil
                    end

                    v85 = premiumFishHologramDeveloperProductId
                end

                if v85 == nil or v85 == 0 then
                    v7.onScreenFeedbackAdded({
                        message = "This premium event reward is not configured.",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })

                    return nil
                end

                attemptStorePurchase(v85)
            end,
            onClose = function() -- onClose | line: 474
                -- upvalues: v7 (copy)
                return v7.windowClosed({})
            end,
            onPreviewCharm = function(p15) -- onPreviewCharm | line: 477
                -- upvalues: v7 (copy), Flamework (copy)
                if not Flamework.resolveDependency("client/controllers/charm-preview-controller@CharmPreviewController"):startPreview(p15) then
                    return nil
                end

                v7.windowClosed({})
            end,
            ticketCount = v8
        }), v25 ~= nil and react.createElement(default, {
            showIcon = false,
            title = "NEW TITLE!",
            uiScale = 1,
            zIndex = 200,
            onFinished = function() -- onFinished | line: 485
                -- upvalues: v22 (copy)
                return v22(nil)
            end,
            titleReward = {
                color = v25.animatedColor or v25.color,
                displayName = v25.displayName,
                perkDescription = v25.perkDescription
            }
        }), v23 ~= nil and react.createElement(default, {
            title = "NEW REWARD!",
            uiScale = 0.9,
            zIndex = 200,
            iconImage = v23.icon,
            onFinished = function() -- onFinished | line: 499
                -- upvalues: v24 (copy)
                return v24(nil)
            end,
            rewardText = v23.name
        }))
    end
}

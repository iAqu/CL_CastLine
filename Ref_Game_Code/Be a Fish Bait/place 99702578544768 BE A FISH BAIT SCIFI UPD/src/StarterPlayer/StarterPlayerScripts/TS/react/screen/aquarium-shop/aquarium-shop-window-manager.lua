-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players = services.HttpService, services.Players
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-crate", "aquarium-crate-panel-manager").default
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local selectAquariumShopSection = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectAquariumShopSection
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumSkinShardRarities, aquariumSkinsData, getAquariumSkinExchangeCost, getAquariumSkinExchangeRarity = v1.aquariumSkinShardRarities, v1.aquariumSkinsData, v1.getAquariumSkinExchangeCost, v1.getAquariumSkinExchangeRarity
local getAquariumSkinShardUpgradeRate = v1.getAquariumSkinShardUpgradeRate
local aquariumCrateSeriesList = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").aquariumCrateSeriesList
local shards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "shards")
local shardsData, skinShardRarityToShardType = shards.shardsData, shards.skinShardRarityToShardType
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumLevel, selectPlayerAquariumOwnedSkins, selectPlayerAquariumSkinShardBalances, selectPlayerAquariumUniversalSkinShards = selectors.selectPlayerAquariumLevel, selectors.selectPlayerAquariumOwnedSkins, selectors.selectPlayerAquariumSkinShardBalances, selectors.selectPlayerAquariumUniversalSkinShards
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local default3 = RuntimeLib.import(script, script.Parent, "aquarium-shop-window").default
local v2 = tostring(Players.LocalPlayer.UserId)
local v3 = Color3.fromRGB(255, 232, 82)

return {
    default = function() -- AquariumShopWindowManager | line: 41
        -- upvalues: Flamework (copy), react (copy), useEffect (copy), useState (copy), HttpService (copy), default (copy), default2 (copy), events (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), useSound (copy), selectAquariumShopSection (copy), aquariumSkinShardRarities (copy), aquariumSkinsData (copy), getAquariumSkinExchangeCost (copy), getAquariumSkinExchangeRarity (copy), getAquariumSkinShardUpgradeRate (copy), aquariumCrateSeriesList (copy), shardsData (copy), skinShardRarityToShardType (copy), selectPlayerAquariumLevel (copy), selectPlayerAquariumOwnedSkins (copy), selectPlayerAquariumSkinShardBalances (copy), selectPlayerAquariumUniversalSkinShards (copy), rarityColors (copy), default3 (copy), v2 (copy), v3 (copy)
        local v4 = useRootProducer()
        local v5 = useScreenSizeState()
        local playSound = useSound("SkillCheckSuccess").playSound
        local v6, v7 = useState(nil)
        local v8 = useRootSelector(selectAquariumShopSection)
        local v9 = useRootSelector(selectPlayerAquariumSkinShardBalances(v2))
        local v10 = useRootSelector(selectPlayerAquariumUniversalSkinShards(v2))
        local v11 = useRootSelector(selectPlayerAquariumOwnedSkins(v2)) or { "Default" }
        local v12 = useRootSelector(selectPlayerAquariumLevel(v2))

        useEffect(function() -- line: 52
            -- upvalues: events (copy)
            events.analyticsAquariumShopWindowOpened:fire()
        end, {})

        local t1 = {}

        for _, v13 in aquariumCrateSeriesList do
            for _, v14 in v13.entries do
                t1[v14.skin.name] = true
            end
        end

        local t2 = {}

        for _, v15 in aquariumSkinsData do
            if t1[v15.name] ~= nil then
                local v16 = getAquariumSkinExchangeCost(v15.name)
                local v17 = getAquariumSkinExchangeRarity(v15.name)

                if v16 ~= nil and v17 ~= nil then
                    table.insert(t2, {
                        displayName = v15.displayName,
                        imageId = v15.imageId,
                        moneyBoost = v15.moneyBoost,
                        name = v15.name,
                        rarity = v15.rarity,
                        requiredShards = v16,
                        shardRarity = v17
                    })
                end
            end
        end

        table.sort(t2, function(p1, p2) -- line: 84
            -- upvalues: aquariumSkinShardRarities (copy)
            local shardRarity = p1.shardRarity
            local v18 = (table.find(aquariumSkinShardRarities, shardRarity) or 0) - 1
            local shardRarity2 = p2.shardRarity

            return v18 < (table.find(aquariumSkinShardRarities, shardRarity2) or 0) - 1
        end)

        local v20 = if (if v6 == nil then v6 else v6.kind) == "skin" then aquariumSkinsData[v6.skinName] else nil
        local v21 = if (if v6 == nil then v6 else v6.kind) == "shards" then shardsData[v6.shardType] else nil
        local v22 = if v5 == "sm" or v5 == "md" then 0.78 else 1
        local t4 = {}
        local v23 = table.create(#aquariumCrateSeriesList)

        local function v24(p3) -- line: 111
            -- upvalues: react (copy), default2 (copy)
            return react.createElement(default2, {
                compact = true,
                embeddedInShop = true,
                hideShardsButton = true,
                variant = "exclusiveShop",
                key = p3.id,
                seriesId = p3.id
            })
        end

        for v25, v26 in aquariumCrateSeriesList do
            local _ = v25 - 1

            v23[v25] = react.createElement(default2, {
                compact = true,
                embeddedInShop = true,
                hideShardsButton = true,
                variant = "exclusiveShop",
                key = v26.id,
                seriesId = v26.id
            })
        end

        t4.crateContent = v23
        t4.initialSection = v8

        t4.onClose = function() -- line: 127
            -- upvalues: v4 (copy)
            return v4.windowClosed({})
        end

        t4.onCraftShards = function(p4, p5) -- line: 130
            -- upvalues: v4 (copy), v7 (copy), HttpService (copy), functions (copy), skinShardRarityToShardType (copy)
            functions.craftAquariumSkinShards(p4, p5):andThen(function(p6) -- line: 131
                -- upvalues: p4 (copy), p5 (copy), v4 (copy), v7 (copy), HttpService (copy), skinShardRarityToShardType (copy)
                if p6 then
                    v7({
                        kind = "shards",
                        amount = p5,
                        shardType = skinShardRarityToShardType[p4]
                    })

                    return nil
                end

                v4.onScreenFeedbackAdded({
                    message = "You need more Wild Shards to craft that.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end):catch(function() -- line: 145
                -- upvalues: v4 (copy), HttpService (copy)
                v4.onScreenFeedbackAdded({
                    message = "Could not craft Aquarium Shards.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end)
        end

        t4.onExchangeSkin = function(p7) -- line: 153
            -- upvalues: v4 (copy), v7 (copy), HttpService (copy), functions (copy)
            functions.exchangeAquariumSkinForShards(p7):andThen(function(p8) -- line: 154
                -- upvalues: p7 (copy), v4 (copy), v7 (copy), HttpService (copy)
                if p8 then
                    v7({
                        kind = "skin",
                        skinName = p7
                    })

                    return nil
                end

                v4.onScreenFeedbackAdded({
                    message = "You need more shards to unlock this skin.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end):catch(function() -- line: 167
                -- upvalues: v4 (copy), HttpService (copy)
                v4.onScreenFeedbackAdded({
                    message = "Could not exchange shards for this skin.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end)
        end

        t4.onPreviewSkin = function(p9) -- line: 175
            -- upvalues: v12 (copy), Flamework (copy)
            return Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):startPreview(p9, v12)
        end

        t4.onUpgradeShards = function(p10, p11) -- line: 178
            -- upvalues: v4 (copy), v7 (copy), HttpService (copy), functions (copy), getAquariumSkinShardUpgradeRate (copy), skinShardRarityToShardType (copy)
            local targetRarity = getAquariumSkinShardUpgradeRate(p10).targetRarity

            functions.exchangeAquariumSkinShards(p10, p11):andThen(function(p12) -- line: 180
                -- upvalues: p10 (copy), p11 (copy), targetRarity (copy), v4 (copy), v7 (copy), HttpService (copy), skinShardRarityToShardType (copy)
                if p12 then
                    v7({
                        kind = "shards",
                        amount = p11,
                        shardType = skinShardRarityToShardType[targetRarity]
                    })

                    return nil
                end

                v4.onScreenFeedbackAdded({
                    type = "error",
                    id = HttpService:GenerateGUID(false),
                    message = ("You need more %* Shards to craft that."):format((string.upper(p10)))
                })
            end):catch(function() -- line: 194
                -- upvalues: v4 (copy), HttpService (copy)
                v4.onScreenFeedbackAdded({
                    message = "Could not upgrade Aquarium Shards.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end)
        end

        t4.ownedShards = v10
        t4.ownedSkins = v11
        t4.skinShardBalances = v9
        t4.skins = t2
        t4.universalShardBalance = v10

        local v27 = react.createElement(default3, t4)
        local v28 = (if v6 == nil then v6 else v6.kind) == "skin"
        local v29 = v28 and v20 ~= nil and react.createElement(default, {
            allowTapToAdvance = true,
            backdropTransparency = 0.12,
            circularRewardRay = true,
            showWhiteRewardRay = true,
            zIndex = 200,
            iconImage = v20.imageId,
            onFinished = function() -- onFinished | line: 219
                -- upvalues: v7 (copy)
                return v7(nil)
            end,
            onReveal = playSound,
            rewardBadgeText = string.upper(v20.rarity),
            rewardRarity = v20.rarity,
            rewardRayColor = rarityColors[v20.rarity],
            rewardText = v20.displayName,
            title = v20.rarity == "mythic" and "MYTHIC SKIN!" or "AQUARIUM SKIN!",
            uiScale = v22
        })
        local v30 = (if v6 == nil then v6 else v6.kind) == "shards"
        local v31

        if not v30 then
            v31 = v30

            return react.createElement(react.Fragment, nil, v27, v29, v31)
        end

        if v21 ~= nil then
            v31 = react.createElement(default, {
                allowTapToAdvance = true,
                backdropTransparency = 0.12,
                circularRewardRay = true,
                showWhiteRewardRay = true,
                title = "SHARDS CRAFTED!",
                zIndex = 200,
                iconImage = v21.image,
                onFinished = function() -- onFinished | line: 244
                    -- upvalues: v7 (copy)
                    return v7(nil)
                end,
                onReveal = playSound,
                rewardRayColor = v3,
                rewardText = ("+%* %*%*"):format(v6.amount, string.upper(v21.displayName), v6.amount == 1 and "" or "S"),
                uiScale = v22
            })
        else
            v31 = false
        end

        return react.createElement(react.Fragment, nil, v27, v29, v31)
    end
}

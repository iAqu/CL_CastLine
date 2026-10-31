-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local usePulseAnimation = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-pulse-animation").usePulseAnimation
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images")
local fishImages, images2, weightImages = images.fishImages, images.images, images.weightImages
local default5 = RuntimeLib.import(script, script.Parent, "long-shop-section").default
local default6 = RuntimeLib.import(script, script.Parent, "starter-pack-content").default
local v1 = RuntimeLib.import(script, script.Parent, "vip-content")
local default7, BackpackCapacityContent, BackpackStyleProductContent = v1.default, v1.BackpackCapacityContent, v1.BackpackStyleProductContent
local default8 = RuntimeLib.import(script, script.Parent, "money-pack-content").default
local default9 = RuntimeLib.import(script, script.Parent, "exclusive-shop-buy-button").default
local default10 = RuntimeLib.import(script, script.Parent, "medium-shop-section").default
local default11 = RuntimeLib.import(script, script.Parent, "exclusive-shop-section").default
local default12 = RuntimeLib.import(script, script.Parent, "small-shop-section").default
local default13 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local functions, events = network.functions, network.events
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils")
local attemptStorePurchase, attemptGiftPurchase = v2.attemptStorePurchase, v2.attemptGiftPurchase
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, MarketplaceService, Players, TweenService = services.HttpService, services.MarketplaceService, services.Players, services.TweenService
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local starterPackProductId, vipGamepassProductId, powerTrainingGamepassProductId, cashGamepassProductId = v3.starterPackProductId, v3.vipGamepassProductId, v3.powerTrainingGamepassProductId, v3.cashGamepassProductId
local fishLuckGamepassProductId, mutationLuckGamepassProductId, extraAquariumFishGamepassProductId, extraAquariumFishGamepassPrice = v3.fishLuckGamepassProductId, v3.mutationLuckGamepassProductId, v3.extraAquariumFishGamepassProductId, v3.extraAquariumFishGamepassPrice
local moneyPack40kProductId, moneyPack220kProductId, moneyPack445kProductId, timeSkip5MinProductId = v3.moneyPack40kProductId, v3.moneyPack220kProductId, v3.moneyPack445kProductId, v3.timeSkip5MinProductId
local timeSkip30MinProductId, starterPackBundleName, bossAutokillBundleName, bossAutokillProductId = v3.timeSkip30MinProductId, v3.starterPackBundleName, v3.bossAutokillBundleName, v3.bossAutokillProductId
local bossAutokillGiftProductId, bossAutokillPrice, volcanicAquariumSkinProductId, getRerollProductId = v3.bossAutokillGiftProductId, v3.bossAutokillPrice, v3.volcanicAquariumSkinProductId, v3.getRerollProductId
local serverLuck2xProductId, serverLuck4xProductId, getProductConfigurationByProductId, getPurchasePromptProductId = v3.serverLuck2xProductId, v3.serverLuck4xProductId, v3.getProductConfigurationByProductId, v3.getPurchasePromptProductId
local isGiftOnlyProductId, isPendingPurchaseConfirmedFailed, StoreProductType, backpackCapacityRobuxPrices = v3.isGiftOnlyProductId, v3.isPendingPurchaseConfirmedFailed, v3.StoreProductType, v3.backpackCapacityRobuxPrices
local getBackpackUpgradeProductId = v3.getBackpackUpgradeProductId
local getStoreProductDisplayInfo = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-display-utils").getStoreProductDisplayInfo
local v4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-giftable-owns-gamepass")
local useGiftableOwnsAquariumSkin, useGiftableOwnsBundle, useGiftableOwnsGamepass, useGiftableOwnsMountFish = v4.useGiftableOwnsAquariumSkin, v4.useGiftableOwnsBundle, v4.useGiftableOwnsGamepass, v4.useGiftableOwnsMountFish
local useIsGiftMode = v4.useIsGiftMode
local default14 = RuntimeLib.import(script, script.Parent, "store-gift-recipient-picker").default
local default15 = RuntimeLib.import(script, script.Parent, "store-purchase-confirmation-modal").default
local default16 = RuntimeLib.import(script, script.Parent, "store-pending-purchases-list").default
local v5 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish")
local mountFishData, mountFishReleased = v5.mountFishData, v5.mountFishReleased
local v6 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "server-luck-dev-prods")
local serverLuck2xDevProdPrice, serverLuck4xDevProdPrice, serverLuckDurationMinutes = v6.serverLuck2xDevProdPrice, v6.serverLuck4xDevProdPrice, v6.serverLuckDurationMinutes
local getServerLuckMultiplierForTier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "server-luck-types").getServerLuckMultiplierForTier
local selectServerLuckMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "server-luck.selectors").selectServerLuckMultiplier
local isStudioOrStaging = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "utils").isStudioOrStaging
local v7 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local vipGamepassName, powerTrainingGamepassName, cashGamepassName, fishLuckGamepassName = v7.vipGamepassName, v7.powerTrainingGamepassName, v7.cashGamepassName, v7.fishLuckGamepassName
local mutationLuckGamepassName, extraAquariumFishGamepassName = v7.mutationLuckGamepassName, v7.extraAquariumFishGamepassName
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumLevel, selectPlayerAquariumMoneyPerSecond, selectPlayerBackpackUpgradeCount, selectPlayerPurchaseHistory = selectors.selectPlayerAquariumLevel, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerBackpackUpgradeCount, selectors.selectPlayerPurchaseHistory
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v8 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "reward-codes")
local getCodeTimeSkipCashAmount, normalizeRewardCode = v8.getCodeTimeSkipCashAmount, v8.normalizeRewardCode
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local shards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "shards")
local shardsData, skinShardRarityToShardType = shards.shardsData, shards.skinShardRarityToShardType
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local default17 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local getTimeSkipMinutes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config").getTimeSkipMinutes
local default18 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "preview-icon-button").default
local default19 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event-shop", "celebration-sunburst-glow").default
local default20 = RuntimeLib.import(script, script.Parent, "exclusive-shop-purchase-buttons").default
local default21 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-crate", "aquarium-crate-panel-manager").default
local v9 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates")
local activeAquariumCrateSeries, multiverseAquariumCrateSeries = v9.activeAquariumCrateSeries, v9.multiverseAquariumCrateSeries
local t1 = {
    [1] = images2.baitAuraRerollOneX,
    [2] = images2.baitAuraRerollTwoX,
    [3] = images2.baitAuraRerollThreeX,
    [4] = images2.baitAuraRerollFourX,
    [5] = images2.baitAuraRerollFiveX,
    [10] = images2.baitAuraRerollTenX
}
local getCodeRewardShardType

local function getCodeRewardIcon(p1) -- line: 141
    -- upvalues: images2 (copy), shardsData (copy), t1 (copy), getCodeRewardShardType (ref)
    local rewardType = p1.rewardType

    if rewardType == "money" then
        return images2.moneyIcon
    end

    if rewardType == "rerolls" then
        local v10 = t1[p1.rewardAmount]

        if v10 == nil then
            v10 = images2.baitAuraRerollOneX
        end

        return v10
    end

    if rewardType == "timeSkip" then
        return images2.timeSkipIcon
    end

    if rewardType == "spinWheelSpins" then
        return images2.wheelIcon
    end

    if rewardType == "tickets" then
        return images2.celebrationTicket
    end

    if rewardType == "timedBuff" then
        if p1.rewardBuffKind == "money" then
            return images2.cash2stack
        end

        if p1.rewardBuffKind == "power" then
            return images2.strongArmIcon
        end

        return images2.serverLuckCloverIcon
    end

    if rewardType == "lavaBucket" then
        return images2.lavaBucket
    end

    local v11 = rewardType == "gem"

    if v11 or rewardType == "gemNode" then
        v11 = true
    end

    if v11 or rewardType == "gemSpawns" then
        return images2.gemIcon
    end

    if rewardType == "aquariumShard" then
        return shardsData[getCodeRewardShardType(p1)].image
    end

    return images2.coinBundle
end

function getCodeRewardShardType(p2) -- line: 199
    -- upvalues: skinShardRarityToShardType (copy)
    if p2.rewardShardRarity == nil then
        return "universalShard"
    end

    return skinShardRarityToShardType[p2.rewardShardRarity]
end

local function getCodeRewardRayColor(p3) -- line: 203
    -- upvalues: rarityColors (copy)
    return if p3.rewardType == "aquariumShard" and p3.rewardShardRarity ~= nil then rarityColors[p3.rewardShardRarity] else nil
end

local formatCodeRewardDuration

local function getCodeRewardText(p4, p5) -- line: 211
    -- upvalues: getCodeTimeSkipCashAmount (copy), abbreviate (copy), shardsData (copy), getTimeSkipMinutes (copy), getCodeRewardShardType (ref), formatCodeRewardDuration (ref)
    local v12 = if p5 == nil then 0 else p5
    local rewardType = p4.rewardType

    if rewardType == "money" then
        return (("+%* CASH"):format((abbreviate(p4.rewardAmount))))
    end

    if rewardType == "rerolls" then
        return (("+%* %*"):format(p4.rewardAmount, if p4.rewardAmount == 1 then "REROLL" else "REROLLS"))
    end

    if rewardType == "timeSkip" then
        local v13 = getCodeTimeSkipCashAmount(p4, v12)
        local v14 = getTimeSkipMinutes(p4.rewardAmount)

        return (("%* +%* CASH"):format(if v14 == nil then "TIME SKIP" else ("%*M TIME SKIP"):format(v14), (abbreviate(v13))))
    end

    if rewardType == "spinWheelSpins" then
        return (("+%* WHEEL SPINS"):format(p4.rewardAmount))
    end

    if rewardType == "tickets" then
        return (("+%* FOMO TICKETS"):format(p4.rewardAmount))
    end

    if rewardType == "timedBuff" then
        local v15 = formatCodeRewardDuration(p4.rewardBuffDurationSeconds)

        if p4.rewardBuffKind == "mutationLuck" then
            return (("X%* MUTATION LUCK\n(%*)"):format(p4.rewardAmount, v15))
        end

        if p4.rewardBuffKind == "money" then
            return (("X%* CASH\n(%*)"):format(p4.rewardAmount, v15))
        end

        if p4.rewardBuffKind == "power" then
            return (("X%* POWER\n(%*)"):format(p4.rewardAmount, v15))
        end

        return "BOOST"
    end

    if rewardType == "gemNode" then
        return (("%* GEM NODE"):format((string.upper(p4.rewardGemNodeRarity or "EPIC"))))
    end

    if rewardType == "gemSpawns" then
        return (("+%* GEM SPAWNS"):format(p4.rewardAmount))
    end

    if rewardType == "gem" then
        local rewardGemName = p4.rewardGemName

        if rewardGemName == nil then
            rewardGemName = "GEM"
        end

        return rewardGemName
    end

    if rewardType == "lavaBucket" then
        return "LAVA BUCKET"
    end

    if rewardType ~= "aquariumShard" then
        return "REWARD"
    end

    local v16 = string.upper(shardsData[getCodeRewardShardType(p4)].displayName)
    local v17 = if p4.rewardAmount == 1 then "" else "S"

    return (("+%* %*%*"):format(p4.rewardAmount, v16, v17))
end

local function getCodeRewardTimeSkipReward(p6, p7) -- line: 272
    -- upvalues: getCodeTimeSkipCashAmount (copy), getTimeSkipMinutes (copy)
    local v18 = if p7 == nil then 0 else p7

    if p6.rewardType ~= "timeSkip" then
        return nil
    end

    local v19 = getTimeSkipMinutes(p6.rewardAmount)

    return if v19 ~= nil then {
        cashAmount = getCodeTimeSkipCashAmount(p6, v18),
        minutes = v19
    } else nil
end

function formatCodeRewardDuration(p8) -- line: 288
    if p8 == nil then
        return "LIMITED TIME"
    end

    return (("%*m %*s"):format(math.floor(p8 / 60), p8 % 60))
end

local v21 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 120, 0))
})
local v22 = Color3.fromRGB(0, 0, 0)
local v23 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v24 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})
local v25 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 40, 140))
})
local v26 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 140, 230))
})
local v27 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 151, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 92, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(95, 205, 255))
})
local v28 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 170, 20))
})
local v29 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 185, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 105, 235))
})
local v30 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 170, 195)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 105, 135))
})
local v31 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 230, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 165, 30))
})
local v32 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 80)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 40)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 240, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 210, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 210))
})
local v33 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 120)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 90, 30)),
    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(180, 30, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 15, 15))
})
local v34 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 246, 135)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 158, 70)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(255, 96, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 225, 255))
})

local function HeaderNode() -- line: 316
    -- upvalues: react (copy), default3 (copy), useTheme (copy), v24 (copy)
    local v35 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.02, 0.5),
        Size = UDim2.fromScale(0.5, 0.86)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        text = "Exclusive Shop!",
        color = v24,
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            ZIndex = 21,
            Font = v35.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.04
        }
    })))
end

local function ShopNavRail(p9) -- line: 349
    -- upvalues: react (copy), default2 (copy), useScreenSizeState (copy)
    local v36 = useScreenSizeState()
    local v37 = v36 == "sm" or v36 == "md"
    local v38 = #p9.items > 5
    local v39 = if v38 then if v37 then 0.118 else 0.108 elseif v37 then 0.145 else 0.135
    local v40 = if v37 then 7 else 8
    local v41 = if v38 then 0.74 else 0.58
    local v42 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, v40),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local items = p9.items
    local v43 = table.create(#items)

    local function v44(p10, p11) -- line: 366
        -- upvalues: p9 (copy), v39 (copy), react (copy), default2 (copy)
        local v45 = p9.activeLabel == p10.label

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p11,
            Size = UDim2.fromScale(1, v39),
            ZIndex = 31 + p11,
            key = p10.label
        }, react.createElement(default2, {
            color = p10.color,
            cornerRadius = v45 and 0.075 or 0.055,
            frameSize = UDim2.fromScale(v45 and 1.04 or 0.98, v45 and 1 or 0.92),
            label = p10.label,
            onClick = p10.onClick,
            popoutColor = if v45 then Color3.fromRGB(18, 18, 18) else Color3.fromRGB(45, 45, 45),
            zIndex = 32 + p11
        }))
    end

    for v46, v47 in items do
        v43[v46] = v44(v47, v46 - 1, items)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 30,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(-0.018, 0.54),
        Size = UDim2.fromScale(0.18, v41)
    }, v42, v43)
end

local function getTimeSkipCashText(p12, p13, p14) -- line: 405
    -- upvalues: abbreviate (copy)
    local v48 = if p14 == nil then 0 else p14

    return (("+$%*"):format((abbreviate((math.max(math.floor(p12 * math.max(p13, 0)), v48))))))
end

local function ShopCard(p15) -- line: 415
    -- upvalues: react (copy)
    local t4 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }
    local clipsDescendants = p15.clipsDescendants

    t4.ClipsDescendants = clipsDescendants == nil or clipsDescendants
    t4.LayoutOrder = p15.layoutOrder

    local heightScale = p15.heightScale

    if heightScale == nil then
        heightScale = 0.45
    end

    t4.Size = UDim2.fromScale(1, heightScale)
    t4.ref = p15.frameRef

    return react.createElement("frame", t4, p15.children)
end

local t5 = {
    description = "Gain x2 Power permanently!",
    price = 499,
    title = "x2 Power",
    icon = images2.strongArmIcon,
    productId = powerTrainingGamepassProductId
}
local t6 = {
    description = "Earn x2 cash permanently",
    price = 299,
    title = "x2 Cash",
    icon = images2.cashPile,
    productId = cashGamepassProductId
}
local t7 = {
    description = "Gain a permanent x2 luck for Boss Fish!",
    price = 249,
    title = "x2 Boss Fish Luck",
    icon = images2.bossFishIcon,
    productId = fishLuckGamepassProductId
}
local t8 = {
    description = "Gain a permanent x2 mutation luck for better mutations!",
    price = 349,
    title = "x2 Mutation Luck",
    icon = images2.serverLuckCloverIcon,
    productId = mutationLuckGamepassProductId
}
local t9 = {
    description = "Add 1 more extra fish into your aquarium forever!",
    originalPrice = 999,
    title = "+1 Fish In Aquarium",
    icon = images2.fishPlusOneIcon,
    price = extraAquariumFishGamepassPrice,
    productId = extraAquariumFishGamepassProductId
}
local volcanicAquariumSkin = images2.volcanicAquariumSkin
local t10 = {
    title = "Server Luck",
    description = ("x2 + %*M"):format(serverLuckDurationMinutes),
    icon = images2.serverLuckCloverIcon,
    price = serverLuck2xDevProdPrice,
    productId = serverLuck2xProductId
}
local t11 = {
    title = "Server Luck",
    description = ("x4 + %*M"):format(serverLuckDurationMinutes),
    icon = images2.serverLuckCloverIcon,
    price = serverLuck4xDevProdPrice,
    productId = serverLuck4xProductId
}

local function ServerLuckContent(p16) -- line: 490
    -- upvalues: react (copy), default3 (copy), useTheme (copy), default9 (copy)
    local v52 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.92, 0.75)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = p16.icon,
        Position = UDim2.fromScale(0.02, 0.45),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.32, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.38, 0.49),
        Size = UDim2.fromScale(0.4, 0.86)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0.02, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = -1,
        Size = UDim2.fromScale(1, 0.43)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 10,
            Font = v52.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = p16.title
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 0.4)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0, 0.5),
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 20))
        }),
        overrideProps = {
            TextScaled = true,
            ZIndex = 4,
            Font = v52.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = p16.description
    }))), react.createElement(default9, {
        zIndex = 4,
        anchorPoint = Vector2.new(1, 1),
        disabledLabel = p16.disabledLabel,
        frameSize = UDim2.fromScale(0.19, 0.24),
        onClick = p16.onClick,
        owned = p16.owned,
        position = UDim2.fromScale(0.99, 0.9),
        price = p16.price,
        productId = p16.productId
    }))
end

local function promptPurchase(p17, p18, p19) -- line: 590
    -- upvalues: attemptStorePurchase (copy), attemptGiftPurchase (copy), clientProducer (copy), MarketplaceService (copy), Players (copy), getProductConfigurationByProductId (copy), getPurchasePromptProductId (copy), StoreProductType (copy)
    local v53 = getProductConfigurationByProductId(p17)

    if v53.kind ~= "error" then
        local data = v53.data
        local v54 = getPurchasePromptProductId(data, p18)

        if v54 ~= 0 then
            local v55 = if not p18 then data.storeProductType == StoreProductType.Gamepass else nil

            if p18 or not v55 then
                if p18 then
                    local v56 = if p19 == nil then tonumber(clientProducer:getState().storeGiftUi.recipientUserId) else p19

                    if v56 ~= nil then
                        attemptGiftPurchase(v54, v56)
                    end

                    return nil
                end

                attemptStorePurchase(v54)

                return
            end

            MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, v54)
        end
    end

    return nil
end

local function GamepassContent(p20) -- line: 618
    -- upvalues: react (copy), default3 (copy), useTheme (copy), default20 (copy)
    local v57 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.88, 0.82)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.01),
        Size = UDim2.fromScale(0.92, 0.2)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 4,
            Font = v57.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p20.title
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = p20.icon,
        Position = UDim2.fromScale(0.01, 0.58),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.52, 0.7)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1.05, 0.45),
        Size = UDim2.fromScale(0.5, 0.48)
    }, react.createElement(default3, {
        shadowYScale = 0.04,
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v57.textFont,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        },
        strokeProps = {
            Thickness = 0.03
        },
        text = p20.description
    })), react.createElement(default20, {
        zIndex = 4,
        disabledLabel = p20.disabledLabel,
        infoType = Enum.InfoType.GamePass,
        onBuy = p20.onClick,
        onGift = p20.onGift,
        owned = p20.owned,
        position = UDim2.fromScale(0.95, 0.95),
        price = p20.price,
        productId = p20.productId,
        size = UDim2.fromScale(0.62, 0.19)
    }))
end

local function LongGamepassContent(p21) -- line: 694
    -- upvalues: react (copy), default3 (copy), usePulseAnimation (copy), useTheme (copy), images2 (copy), default20 (copy), v24 (copy), v32 (copy)
    local v58 = useTheme()
    local v59 = usePulseAnimation({
        interval = 0.7,
        peakDuration = 0.28,
        peakScale = 1.18,
        enabled = p21.originalPrice ~= nil
    })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.92, 0.86)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = p21.icon,
        Position = UDim2.fromScale(0.03, 0.52),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.34, 0.76)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.99, 0.02),
        Size = UDim2.fromScale(0.24, 0.24)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        text = "OP!",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v32,
        overrideProps = {
            TextScaled = true,
            ZIndex = 10,
            Font = v58.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        position = UDim2.fromScale(0.5, 0.5),
        strokeProps = {
            Thickness = 0.08
        }
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.31, 0.45),
        Size = UDim2.fromScale(0.58, 0.86)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.025, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        ZIndex = 4,
        Size = UDim2.fromScale(1, 0.34)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v58.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p21.title
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 4,
        Size = UDim2.fromScale(0.82, 0.28)
    }, react.createElement(default3, {
        shadowYScale = 0.04,
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v58.textFont,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p21.description
    }))), if p21.originalPrice ~= nil then react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.fromScale(0.98, 0.65),
        Size = UDim2.fromScale(0.26, 0.2)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0.02, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        ZIndex = 5,
        Image = images2.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.35, 0.85)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        TextScaled = true,
        ZIndex = 5,
        Font = v58.textFont,
        Size = UDim2.fromScale(0.5, 1),
        Text = tostring(p21.originalPrice),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 0.06,
        Color = Color3.new(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))), react.createElement("frame", {
        BorderSizePixel = 0,
        Rotation = 8,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(230, 30, 30),
        Position = UDim2.fromScale(0.54, 0.5),
        Size = UDim2.fromScale(0.9, 0.16)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.15,
        Color = Color3.fromRGB(120, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))) else nil, react.createElement(default20, {
        zIndex = 4,
        infoType = Enum.InfoType.GamePass,
        onBuy = p21.onClick,
        onGift = p21.onGift,
        owned = p21.owned,
        position = UDim2.fromScale(0.98, 0.9),
        price = p21.price,
        productId = p21.productId,
        size = UDim2.fromScale(0.33, 0.24)
    }), if p21.originalPrice ~= nil then react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.88, 0.9),
        Size = v59:map(function(p22) -- line: 867
            return UDim2.fromScale(0.26 * p22, 0.15 * p22)
        end)
    }, react.createElement(default3, {
        shadowYScale = 0.05,
        text = "93% OFF!",
        color = v24,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            Font = v58.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.08
        }
    })) else nil)
end

local function BossAutokillContent(p23) -- line: 887
    -- upvalues: react (copy), images2 (copy), BackpackStyleProductContent (copy), bossAutokillProductId (copy), bossAutokillPrice (copy), default19 (copy)
    return react.createElement(BackpackStyleProductContent, {
        iconZIndex = 6,
        perkWidthScale = 1.2,
        title = "Auto-Kill Boss Fish",
        disabledLabel = if p23.available then nil else "Unavailable",
        icon = images2.bossAutokillIcon,
        iconDecoration = react.createElement(default19, {
            animated = true,
            animatedRayVisible = true,
            clipsDescendants = false,
            zIndex = 3,
            accentColor = Color3.fromRGB(120, 255, 237),
            position = UDim2.fromScale(0.14, 0.52),
            size = UDim2.fromScale(0.72, 1)
        }),
        iconPosition = UDim2.fromScale(-0.04, 0.44),
        iconSize = UDim2.fromScale(0.6, 1.19),
        infoType = Enum.InfoType.Product,
        onBuy = p23.onBuy,
        onGift = p23.onGift,
        owned = p23.owned or not p23.available,
        perks = { "- Instantly kill boss fish!", "- Can be toggled in settings" },
        price = bossAutokillPrice,
        productId = bossAutokillProductId,
        showGift = p23.giftingEnabled
    })
end

local function MountShopContent(p24) -- line: 917
    -- upvalues: react (copy), default3 (copy), useTheme (copy), useScreenSizeState (copy), default18 (copy), default19 (copy), default20 (copy), v34 (copy)
    local v68 = useTheme()
    local v69 = if useScreenSizeState() == "lg" then 44 else 26

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.92, 0.86)
    }, react.createElement(default19, {
        animated = true,
        clipsDescendants = false,
        zIndex = 3,
        accentColor = Color3.fromRGB(255, 55, 55),
        animatedRayVisible = p24.animatedRayVisible,
        position = UDim2.fromScale(0.15, 0.52),
        size = UDim2.fromScale(0.42, 0.9)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = p24.icon,
        Position = UDim2.fromScale(0.02, 0.52),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.34, 0.78)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.31, 0.47),
        Size = UDim2.fromScale(0.37, 0.72)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.03, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        ZIndex = 4,
        Size = UDim2.fromScale(1, 0.3)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        color = v34,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v68.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p24.displayName
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 4,
        Size = UDim2.fromScale(1.35, 0.24)
    }, react.createElement(default3, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            ZIndex = 4,
            Font = v68.textFont,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        },
        strokeProps = {
            Thickness = 0.07
        },
        text = p24.description
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = 4,
        Size = UDim2.fromScale(0.96, 0.18)
    }, react.createElement(default3, {
        shadowYScale = 0.05,
        color = Color3.fromRGB(255, 235, 80),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v68.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.07
        },
        text = ("+%*%% MOVEMENT SPEED"):format(p24.speedBonusPercent)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 3,
        ZIndex = 4,
        Size = UDim2.fromScale(0.96, 0.16)
    }, react.createElement(default3, {
        shadowYScale = 0.05,
        text = "Unlock this mount permanently",
        color = Color3.fromRGB(140, 255, 160),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Font = v68.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.07
        }
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.98, 0.06),
        Size = UDim2.fromScale(0.22, 0.18)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        text = "MOUNT",
        color = Color3.fromRGB(125, 245, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            Font = v68.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        strokeProps = {
            Thickness = 0.08
        }
    })), react.createElement(default20, {
        zIndex = 4,
        onBuy = p24.onBuy,
        onGift = p24.onGift,
        owned = p24.owned,
        position = UDim2.fromScale(0.98, 0.9),
        price = p24.price,
        productId = p24.productId,
        size = UDim2.fromScale(0.29, 0.24)
    }), react.createElement(default18, {
        zIndex = 6,
        anchorPoint = Vector2.new(1, 0.5),
        onClick = p24.onPreview,
        position = UDim2.fromScale(0.98, 0.45),
        size = UDim2.fromOffset(v69, v69)
    }))
end

local function MountShopCard(p25) -- line: 1081
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), default5 (copy), useGiftableOwnsMountFish (copy), ShopCard (copy), MountShopContent (copy)
    local v70 = useRef(nil)
    local v71, v72 = useState(true)
    local v73 = useGiftableOwnsMountFish(p25.mount.itemName)
    local v74 = if p25.mount.itemName == "CookedWhale" or p25.mount.itemName == "WSwordfish" then "LongOrangeSection" else "LongRainbowSectionBright"

    useEffect(function() -- line: 1086
        -- upvalues: p25 (copy), v70 (copy), v72 (copy)
        local current = v70.current
        local current2 = p25.scrollFrameRef.current

        if current == nil or current2 == nil then
            return nil
        end

        local function v75() -- line: 1092
            -- upvalues: current (copy), current2 (copy), v72 (copy)
            if current2.AbsoluteWindowSize.Y <= 0 or current.AbsoluteSize.Y <= 0 then
                return nil
            end

            local Y = current2.AbsolutePosition.Y
            local v76 = Y + current2.AbsoluteWindowSize.Y
            local Y2 = current.AbsolutePosition.Y
            local v77 = Y2 + current.AbsoluteSize.Y
            local v78 = Y2 + current.AbsoluteSize.Y * 0.13

            v72(Y < v77 and Y < v78 and Y2 < v76)
        end

        v75()

        local t18 = {
            current2:GetPropertyChangedSignal("CanvasPosition"):Connect(v75),
            current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v75),
            current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v75),
            current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v75)
        }

        return function() -- line: 1105
            -- upvalues: t18 (copy)
            local function v80(p26) -- line: 1107
                return p26:Disconnect()
            end

            for v81, v82 in t18 do
                local _ = v81 - 1

                v82:Disconnect()
            end

            return nil
        end
    end, { p25.scrollFrameRef })

    local v83 = table.clone(p25.mount)

    setmetatable(v83, nil)
    v83.animatedRayVisible = v71
    v83.onBuy = p25.onBuy
    v83.onGift = p25.onGift
    v83.onPreview = p25.onPreview
    v83.owned = v73

    return react.createElement(ShopCard, {
        clipsDescendants = false,
        frameRef = function(p27) -- frameRef | line: 1126
            -- upvalues: p25 (copy), v70 (copy)
            v70.current = p27

            if p25.frameRef ~= nil then
                p25.frameRef.current = p27
            end
        end,
        layoutOrder = p25.layoutOrder
    }, react.createElement(default5, {
        sectionType = v74,
        size = UDim2.fromScale(1, 1)
    }, react.createElement(MountShopContent, v83)))
end

local function VolcanicAquariumSkinContent(p28) -- line: 1138
    -- upvalues: react (copy), useEffect (copy), useRef (copy), default3 (copy), useTheme (copy), images2 (copy), TweenService (copy), volcanicAquariumSkinProductId (copy), useScreenSizeState (copy), default18 (copy), default20 (copy), v33 (copy), volcanicAquariumSkin (copy)
    local v84 = useTheme()
    local v85 = if useScreenSizeState() == "lg" then 44 else 26
    local v86 = useRef(nil)

    useEffect(function() -- line: 1143
        -- upvalues: v86 (copy), TweenService (copy)
        local v87 = true
        local v88

        v88 = function(p29, p30, p31) -- line: 1146
            -- upvalues: v88 (ref), v87 (ref), TweenService (copy)
            if p29 == nil or not v87 then
                return nil
            end

            p29.Rotation = p31 == 1 and 0 or 360

            local v90 = TweenService:Create(p29, TweenInfo.new(p30, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                Rotation = p31 == 1 and 360 or 0
            })

            v90.Completed:Once(function() -- line: 1157
                -- upvalues: p29 (copy), p30 (copy), p31 (copy), v88 (ref)
                return v88(p29, p30, p31)
            end)
            v90:Play()
        end

        v88(v86.current, 18, 1)

        return function() -- line: 1163
            -- upvalues: v87 (ref)
            v87 = false
        end
    end, {})

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.23, 0.45),
        Size = UDim2.fromScale(0.48, 0.98)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.46,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images2.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1.12, 1.12)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.36,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images2.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 170, 35),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.92, 0.92)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }))), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.36,
        Rotation = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images2.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.22, 0.42),
        Size = UDim2.fromScale(0.88, 1.46),
        Visible = p28.raysVisible,
        ref = v86
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.24,
        Rotation = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images2.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 185, 90),
        Position = UDim2.fromScale(0.26, 0.47),
        Size = UDim2.fromScale(0.78, 1.32),
        Visible = p28.raysVisible
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Rotation = 0,
        ZIndex = 9,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = volcanicAquariumSkin,
        Position = UDim2.fromScale(-0.01, 0.45),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.48, 0.98)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(0.95, 0.46),
        Size = UDim2.fromScale(0.48, 0.44)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 0.4)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        text = "Volcanic Aquarium Skin",
        color = v33,
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            ZIndex = 6,
            Font = v84.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.08
        }
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 5,
        Size = UDim2.fromScale(0.9, 0.34)
    }, react.createElement(default3, {
        shadowYScale = 0.04,
        text = "+10% Cash buff when owned",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 6,
            Font = v84.textFont,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        },
        strokeProps = {
            Thickness = 0.07
        }
    }))), react.createElement(default20, {
        price = 349,
        zIndex = 6,
        onBuy = p28.onBuy,
        onGift = p28.onGift,
        owned = p28.owned,
        position = UDim2.fromScale(0.94, 0.87),
        productId = volcanicAquariumSkinProductId,
        size = UDim2.fromScale(0.35, 0.22)
    }), react.createElement(default18, {
        zIndex = 6,
        anchorPoint = Vector2.new(1, 0),
        onClick = p28.onPreview,
        position = UDim2.fromScale(0.98, 0.06),
        size = UDim2.fromOffset(v85, v85)
    }))
end

local function MediumSectionRow(p32) -- line: 1322
    -- upvalues: react (copy), default10 (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = p32.layoutOrder,
        Size = UDim2.fromScale(1, 0.5),
        ref = p32.frameRef
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.015, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        Size = UDim2.fromScale(0.4925, 1)
    }, react.createElement(default10, {
        sectionType = p32.left,
        size = UDim2.fromScale(1, 1)
    }, p32.leftContent)), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Size = UDim2.fromScale(0.4925, 1)
    }, react.createElement(default10, {
        sectionType = p32.right,
        size = UDim2.fromScale(1, 1)
    }, p32.rightContent)))
end

local t21 = {
    {
        price = 9,
        title = "$40K",
        icon = images2.moneyIcon,
        productId = moneyPack40kProductId
    },
    {
        price = 49,
        title = "$220K",
        icon = images2.smallMoneyPile,
        productId = moneyPack220kProductId
    },
    {
        price = 99,
        title = "$445K",
        icon = images2.bigMoneyPile,
        productId = moneyPack445kProductId
    }
}
local t22 = {
    {
        price = 59,
        title = "1x Reroll",
        icon = images2.baitAuraRerollOneX,
        productId = getRerollProductId(1)
    },
    {
        price = 229,
        title = "5x Rerolls",
        icon = images2.baitAuraRerollFiveX,
        productId = getRerollProductId(5)
    },
    {
        price = 449,
        title = "10x Rerolls",
        icon = images2.baitAuraRerollTenX,
        productId = getRerollProductId(10)
    }
}

local function SmallPackRow(p33) -- line: 1394
    -- upvalues: react (copy), default8 (copy), default12 (copy)
    local v91 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.015, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local packs = p33.packs
    local v92 = table.create(#packs)

    local function v93(p34, p35) -- line: 1405
        -- upvalues: p33 (copy), react (copy), default8 (copy), default12 (copy)
        local t23 = {
            icon = p34.icon,
            onBuy = function() -- onBuy | line: 1408
                -- upvalues: p34 (copy), p33 (copy)
                return p33.onBuyPack(p34)
            end,
            onGift = function() -- onGift | line: 1411
                -- upvalues: p34 (copy), p33 (copy)
                return p33.onGiftPack(p34)
            end,
            price = p34.price
        }
        local productId = p34.productId

        t23.productId = if productId == nil then 0 else productId
        t23.title = p34.title

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p35,
            Size = UDim2.fromScale(0.3233333333333333, 1),
            key = tostring(p35)
        }, react.createElement(default12, {
            sectionType = p33.sectionType,
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default8, t23)))
    end

    for v94, v95 in packs do
        v92[v94] = v93(v95, v94 - 1, packs)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = p33.layoutOrder,
        Size = UDim2.fromScale(1, 0.42),
        ref = p33.frameRef
    }, v91, v92)
end

local function SmallYellowRow(p36) -- line: 1445
    -- upvalues: react (copy), t21 (copy), SmallPackRow (copy)
    return react.createElement(SmallPackRow, {
        sectionType = "SmallYellowSection",
        frameRef = p36.frameRef,
        layoutOrder = p36.layoutOrder,
        onBuyPack = p36.onBuyPack,
        onGiftPack = p36.onGiftPack,
        packs = t21
    })
end

local function SmallGreyRow(p37) -- line: 1455
    -- upvalues: react (copy), t22 (copy), SmallPackRow (copy)
    return react.createElement(SmallPackRow, {
        sectionType = "SmallGreySection",
        frameRef = p37.frameRef,
        layoutOrder = p37.layoutOrder,
        onBuyPack = p37.onBuyPack,
        onGiftPack = p37.onGiftPack,
        packs = t22
    })
end

local v96 = Color3.fromRGB(18, 23, 48)
local v97 = Color3.fromRGB(45, 55, 105)

local function CodesContent(p38) -- line: 1469
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), useTheme (copy), images2 (copy), default13 (copy), useRootProducer (copy), functions (copy), HttpService (copy), normalizeRewardCode (copy), v23 (copy), v96 (copy), v97 (copy)
    local v98 = useTheme()
    local v99 = useRootProducer()
    local v100, v101 = useState("")

    local function v102(p39) -- line: 1473
        -- upvalues: p38 (copy), v99 (copy), functions (copy), HttpService (copy), normalizeRewardCode (copy)
        local v103 = normalizeRewardCode(p39)

        functions.claimRewardCode(v103):andThen(function(p40) -- line: 1475
            -- upvalues: p38 (copy), v99 (copy), HttpService (copy)
            local v104 = HttpService:GenerateGUID(false)

            if p40.kind == "success" then
                v99.onScreenFeedbackAdded({
                    message = "Code claimed successfully!",
                    type = "success",
                    id = v104
                })
                p38.onClaimSuccess(p40.data)
            else
                local v105 = if p40.reason == "invalidCode" then "Invalid code" elseif p40.reason == "serverOutdated" then "Server outdated, try joining a new server" else "Code already claimed"

                v99.onScreenFeedbackAdded({
                    type = "error",
                    id = v104,
                    message = v105
                })
            end
        end)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.92, 0.82)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = images2.voidDeckStudios,
        Position = UDim2.fromScale(0.02, 0.42),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.47, 1)
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = v96,
        Position = UDim2.fromScale(0.5, 0.28),
        Size = UDim2.fromScale(0.46, 0.26)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.25, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.055,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.new(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }), react.createElement(default13, {
        cornerRadius = 0.25,
        transparency = 0,
        zIndex = 5,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = v97,
        position = UDim2.fromScale(0.5, 0.47),
        size = UDim2.fromScale(1, 0.88)
    }, react.createElement("textbox", {
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        PlaceholderText = "Enter Code",
        TextScaled = true,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 0.5),
        Change = {
            Text = function(p41) -- Text | line: 1542
                -- upvalues: v101 (copy), normalizeRewardCode (copy)
                v101(normalizeRewardCode(p41.Text))
            end
        },
        Font = v98.textFont,
        PlaceholderColor3 = Color3.fromRGB(170, 180, 220),
        Position = UDim2.fromScale(0.06, 0.5),
        Size = UDim2.fromScale(0.83, 0.6),
        Text = v100,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }))), react.createElement(default2, {
        label = "CLAIM",
        zIndex = 4,
        anchorPoint = Vector2.new(1, 0.5),
        color = v23,
        frameSize = UDim2.fromScale(0.3, 0.18),
        onClick = function() -- onClick | line: 1563
            -- upvalues: v100 (copy), v102 (copy)
            return v102(v100)
        end,
        popoutColor = Color3.fromRGB(10, 120, 10),
        position = UDim2.fromScale(0.96, 0.58)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(0.78, 0.2)
    }, react.createElement(default3, {
        text = "Join our Community in social links for\nexclusive OP Codes!",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 5,
            Font = v98.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        position = UDim2.fromScale(0.5, 0.6)
    })))
end

return {
    getCodeRewardIcon = getCodeRewardIcon,
    getCodeRewardRayColor = getCodeRewardRayColor,
    getCodeRewardText = getCodeRewardText,
    getCodeRewardTimeSkipReward = getCodeRewardTimeSkipReward,
    default = function(p42) -- ExclusiveShopWindowV2 | line: 1591
        -- upvalues: RuntimeLib (copy), Flamework (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), default (copy), default2 (copy), default4 (copy), fishImages (copy), images2 (copy), weightImages (copy), default5 (copy), default6 (copy), default7 (copy), BackpackCapacityContent (copy), default8 (copy), default11 (copy), useRootProducer (copy), useRootSelector (copy), functions (copy), events (copy), attemptStorePurchase (copy), attemptGiftPurchase (copy), clientProducer (copy), HttpService (copy), MarketplaceService (copy), Players (copy), TweenService (copy), starterPackProductId (copy), vipGamepassProductId (copy), timeSkip5MinProductId (copy), timeSkip30MinProductId (copy), starterPackBundleName (copy), bossAutokillBundleName (copy), bossAutokillProductId (copy), bossAutokillGiftProductId (copy), volcanicAquariumSkinProductId (copy), getProductConfigurationByProductId (copy), getPurchasePromptProductId (copy), isGiftOnlyProductId (copy), isPendingPurchaseConfirmedFailed (copy), StoreProductType (copy), backpackCapacityRobuxPrices (copy), getBackpackUpgradeProductId (copy), getStoreProductDisplayInfo (copy), useGiftableOwnsAquariumSkin (copy), useGiftableOwnsBundle (copy), useGiftableOwnsGamepass (copy), useIsGiftMode (copy), default14 (copy), default15 (copy), default16 (copy), mountFishData (copy), mountFishReleased (copy), getServerLuckMultiplierForTier (copy), selectServerLuckMultiplier (copy), isStudioOrStaging (copy), vipGamepassName (copy), powerTrainingGamepassName (copy), cashGamepassName (copy), fishLuckGamepassName (copy), mutationLuckGamepassName (copy), extraAquariumFishGamepassName (copy), selectPlayerAquariumLevel (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerBackpackUpgradeCount (copy), selectPlayerPurchaseHistory (copy), localPlayerUserId (copy), abbreviate (copy), rarityColors (copy), default17 (copy), useScreenSizeState (copy), useSound (copy), default21 (copy), activeAquariumCrateSeries (copy), multiverseAquariumCrateSeries (copy), getCodeRewardIcon (copy), getCodeRewardText (copy), getCodeRewardTimeSkipReward (copy), v21 (copy), v22 (copy), v23 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), HeaderNode (copy), ShopNavRail (copy), ShopCard (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), ServerLuckContent (copy), promptPurchase (copy), GamepassContent (copy), LongGamepassContent (copy), BossAutokillContent (copy), MountShopCard (copy), VolcanicAquariumSkinContent (copy), MediumSectionRow (copy), SmallYellowRow (copy), SmallGreyRow (copy), CodesContent (copy)
        local v110 = useRef(nil)
        local v111 = useRef(nil)
        local v112 = useRef(nil)
        local v113 = useRef(nil)
        local v114 = useRef(nil)
        local v115 = useRef(nil)
        local v116 = useRef(nil)
        local v117 = useRef(nil)
        local v118 = useRef(nil)
        local v119 = useRef(nil)
        local v120 = useScreenSizeState()
        local v121 = v120 == "sm" or v120 == "md"
        local playSound = useSound("SkillCheckSuccess").playSound
        local v122, v123 = useState(nil)
        local v124, v125 = useState(0)
        local Featured, Featured2 = useState("Featured")
        local v126, v127 = useState(true)
        local v128, v129 = useState(true)
        local v130, v131 = useState(true)

        useEffect(function() -- line: 1612
            -- upvalues: v110 (copy), v117 (copy), v118 (copy), v119 (copy), v127 (copy), v129 (copy), v131 (copy)
            local current = v110.current

            if current == nil then
                return nil
            end

            local function v132() -- line: 1617
                -- upvalues: current (copy), v117 (copy), v118 (copy), v119 (copy), v127 (copy), v129 (copy), v131 (copy)
                local Y = current.AbsolutePosition.Y
                local v133 = Y + current.AbsoluteWindowSize.Y
                local current2 = v117.current
                local current3 = v118.current
                local current4 = v119.current

                v127(current2 ~= nil and Y < current2.AbsolutePosition.Y + current2.AbsoluteSize.Y and current2.AbsolutePosition.Y < v133)
                v129(current3 ~= nil and Y < current3.AbsolutePosition.Y + current3.AbsoluteSize.Y * 0.5)
                v131(current4 ~= nil and Y < current4.AbsolutePosition.Y + current4.AbsoluteSize.Y * 0.5)
            end

            v132()

            local t30 = {
                current:GetPropertyChangedSignal("CanvasPosition"):Connect(v132),
                current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v132)
            }

            return function() -- line: 1629
                -- upvalues: t30 (copy)
                local function v137(p43) -- line: 1631
                    return p43:Disconnect()
                end

                for v138, v139 in t30 do
                    local _ = v138 - 1

                    v139:Disconnect()
                end

                return nil
            end
        end, {})

        local function v140(p44, p45) -- line: 1643
            -- upvalues: v110 (copy), TweenService (copy)
            local v141 = if p45 == nil then 0.08 else p45
            local current = v110.current

            if current == nil or p44 == nil then
                return nil
            end

            local v142 = current.AbsoluteWindowSize.Y * v141
            local v146 = math.clamp(p44.AbsolutePosition.Y - current.AbsolutePosition.Y + current.CanvasPosition.Y - v142, 0, (math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)))

            TweenService:Create(current, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, v146)
            }):Play()
        end

        local function v147() -- line: 1662
            -- upvalues: v110 (copy), TweenService (copy)
            local current = v110.current

            if current == nil then
                return nil
            end

            TweenService:Create(current, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, 0)
            }):Play()
        end

        local t31 = {
            {
                label = "Featured",
                color = v25,
                onClick = function() -- onClick | line: 1675
                    -- upvalues: Featured2 (copy), v147 (copy)
                    Featured2("Featured")
                    v147()
                end
            },
            {
                label = "Gamepass",
                color = v26,
                onClick = function() -- onClick | line: 1682
                    -- upvalues: v112 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Gamepass")
                    v140(v112.current, 0.015)
                end
            },
            {
                label = "Mounts",
                color = v27,
                onClick = function() -- onClick | line: 1689
                    -- upvalues: v111 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Mounts")
                    v140(v111.current, 0.015)
                end
            },
            {
                label = "Server Luck",
                color = v31,
                onClick = function() -- onClick | line: 1696
                    -- upvalues: v115 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Server Luck")
                    v140(v115.current, 0.015)
                end
            },
            {
                label = "Cash",
                color = v28,
                onClick = function() -- onClick | line: 1703
                    -- upvalues: v113 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Cash")
                    v140(v113.current, 0.015)
                end
            },
            {
                label = "Rerolls",
                color = v30,
                onClick = function() -- onClick | line: 1710
                    -- upvalues: v114 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Rerolls")
                    v140(v114.current, 0.015)
                end
            },
            {
                label = "Code",
                color = v29,
                onClick = function() -- onClick | line: 1717
                    -- upvalues: v116 (copy), Featured2 (copy), v140 (copy)
                    Featured2("Code")
                    v140(v116.current)
                end
            }
        }

        local v148 = function(p46) -- line: 1722
            -- upvalues: v123 (copy), v125 (copy)
            v123(p46)
            v125(function(p47) -- line: 1724
                return p47 + 1
            end)
        end

        local v149 = useRootSelector(selectServerLuckMultiplier)
        local v150 = v149 < getServerLuckMultiplierForTier(1)
        local v151 = v149 == getServerLuckMultiplierForTier(1)

        v149 = if v150 then t10 else t11

        local v152 = v150 or v151
        local v153 = useGiftableOwnsGamepass(vipGamepassName)
        local v154 = useRootSelector(selectPlayerBackpackUpgradeCount(localPlayerUserId))
        local v155 = getBackpackUpgradeProductId(v154)

        if v155 == nil then
            v155 = 0
        end

        local v158 = backpackCapacityRobuxPrices[math.min(math.floor(v154 / 10), 4) + 1]
        local v159 = useGiftableOwnsGamepass(powerTrainingGamepassName)
        local v160 = useGiftableOwnsGamepass(cashGamepassName)
        local v161 = useGiftableOwnsGamepass(fishLuckGamepassName)
        local v162 = useGiftableOwnsGamepass(mutationLuckGamepassName)
        local v157 = useGiftableOwnsGamepass(extraAquariumFishGamepassName)
        local v156 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local Volcanic = useGiftableOwnsAquariumSkin("Volcanic")
        local v163 = useRootSelector(selectPlayerAquariumLevel(localPlayerUserId))
        local v164 = useGiftableOwnsBundle(starterPackBundleName)
        local v165 = useGiftableOwnsBundle(bossAutokillBundleName)
        local v169 = ("+$%*"):format((abbreviate((math.max(math.floor(300 * math.max(v156, 0)), 5000)))))
        local v168 = 0
        local v166 = math.floor(300 * math.max(v156, 0))

        v166 = ("+$%*"):format((abbreviate((math.max(v166, v168)))))

        local v170 = ("+$%*"):format((abbreviate((math.max(math.floor(1800 * math.max(v156, 0)), 0)))))
        local t32 = {}

        if mountFishReleased then
            for _, v173 in mountFishData do
                table.insert(t32, {
                    description = v173.description,
                    displayName = v173.displayName,
                    icon = v173.shopIconImageId,
                    itemName = v173.itemName,
                    price = v173.priceRobux,
                    productId = v173.productId,
                    speedBonusPercent = math.round((v173.speedMultiplier - 1) * 100)
                })
            end
        end

        local v175 = useRootProducer()
        local v176 = useIsGiftMode()
        local v177 = useRootSelector(function(p48) -- line: 1774
            return p48.storeGiftUi.recipientUserId
        end)
        local v178 = useRootSelector(function(p49) -- line: 1777
            return p49.storeGiftUi.recipientUnavailable
        end)
        local v179, v180 = useState(nil)
        local v181, v182 = useState(false)
        local v183, v184 = useState(nil)
        local v185, v186 = useState(false)
        local v187, v188 = useState(nil)
        local v189, v190 = useState(nil)
        local v191 = useRootSelector(selectPlayerPurchaseHistory(localPlayerUserId))
        local v192 = useRootSelector(function(p50) -- line: 1789
            return p50.storePurchase.inFlightRetryProductIds
        end)
        local v193

        if v191 ~= nil then
            local v194 = false

            for v195, v196 in v191 do
                v193 = v195 - 1

                if v192[v196.productId] == nil or isPendingPurchaseConfirmedFailed(v196.timeBought) then
                    v194 = true
                    break
                end
            end

            v191 = v194
        end

        if v191 == nil then
            v191 = false
        end

        local function v197(p51, p52) -- line: 1820
            -- upvalues: v176 (copy), v188 (copy)
            if not v176 then
                p52()

                return nil
            end

            v188({
                title = p51,
                onConfirm = p52
            })
        end

        local function v198(p53) -- line: 1851
            -- upvalues: v175 (copy), v180 (copy), v182 (copy), v183 (copy), v184 (copy), v188 (copy), v189 (copy), v190 (copy), functions (copy), events (copy), attemptGiftPurchase (copy), clientProducer (copy), HttpService (copy), getProductConfigurationByProductId (copy), getPurchasePromptProductId (copy), getStoreProductDisplayInfo (copy)
            v182(false)

            if v183 ~= nil then
                v184(nil)
                v175.storePurchasePromptStarted({
                    recipientUserId = tostring(p53.UserId)
                })

                local UserId2 = p53.UserId
                local v199 = getProductConfigurationByProductId(v183)
                local v200, v201

                if v199.kind ~= "error" then
                    v200 = getPurchasePromptProductId(v199.data, true)

                    if v200 ~= 0 then
                        v201 = if UserId2 ~= nil then UserId2 else tonumber(clientProducer:getState().storeGiftUi.recipientUserId)

                        if v201 ~= nil then
                            attemptGiftPurchase(v200, v201)
                        end
                    end
                end

                return nil
            end

            events.storeGiftModeStarted(p53.UserId)
            v175.storeGiftModeStarted({
                recipientUserId = tostring(p53.UserId)
            })
            v180(p53.DisplayName)

            if v189 == nil then
                return nil
            end

            v190(nil)

            local v202 = getProductConfigurationByProductId(v189)

            v188({
                title = if v202.kind == "success" then getStoreProductDisplayInfo({
                    storeProductConfiguration = v202.data
                }).title else "Item",
                onConfirm = function() -- line: 1876
                    -- upvalues: p53 (copy), v175 (copy), v189 (copy), functions (copy), HttpService (copy)
                    task.spawn(function() -- line: 1877
                        -- upvalues: p53 (copy), v175 (copy), v189 (copy), functions (copy), HttpService (copy)
                        local v204, v205 = functions.processGiftPurchase(v189, p53.UserId):await()

                        if not v204 or v205.kind ~= "success" then
                            v175.onScreenFeedbackAdded({
                                message = "Purchase could not be completed. Please try again.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            local v206 = ("Gift sent to %*!"):format(p53.DisplayName)

                            v175.onScreenFeedbackAdded({
                                type = "success",
                                id = HttpService:GenerateGUID(false),
                                message = v206
                            })
                        end
                    end)
                end
            })
        end

        local function v207(p54) -- line: 1887
            -- upvalues: v182 (copy), v184 (copy), v190 (copy)
            v184(p54)
            v190(nil)
            v182(true)
        end

        local v208 = useRef(v176)

        v208.current = v176
        useEffect(function() -- line: 1899
            -- upvalues: v175 (copy), v208 (copy), events (copy)
            return function() -- line: 1900
                -- upvalues: v175 (copy), v208 (copy), events (copy)
                if not v208.current then
                    return nil
                end

                events.storeGiftModeStopped()
                v175.storeGiftModeStopped({})
            end
        end, {})
        useEffect(function() -- line: 1909
            -- upvalues: v175 (copy), v178 (copy), v179 (copy), v180 (copy), v188 (copy), events (copy), HttpService (copy)
            if not v178 then
                return nil
            end

            local v209 = if v179 == nil then "Recipient left the server." else ("%* left the server."):format(v179)

            v175.onScreenFeedbackAdded({
                type = "error",
                id = HttpService:GenerateGUID(false),
                message = v209
            })
            v188(nil)
            events.storeGiftModeStopped()
            v175.storeGiftModeStopped({})
            v180(nil)
        end, { v178 })

        local function v210(p55) -- line: 1920
            -- upvalues: v175 (copy), v182 (copy), v186 (copy), v188 (copy), v190 (copy), functions (copy), HttpService (copy), getProductConfigurationByProductId (copy), isGiftOnlyProductId (copy), getStoreProductDisplayInfo (copy)
            v186(false)

            local v211 = getProductConfigurationByProductId(p55)

            if v211.kind == "error" then
                return nil
            end

            local data = v211.data

            if isGiftOnlyProductId(data, p55) then
                v190(p55)
                v182(true)

                return nil
            end

            local title = getStoreProductDisplayInfo({
                storeProductConfiguration = data
            }).title

            v188({
                title = title,
                onConfirm = function() -- line: 1935
                    -- upvalues: p55 (copy), title (copy), v175 (copy), functions (copy), HttpService (copy)
                    task.spawn(function() -- line: 1936
                        -- upvalues: p55 (copy), title (copy), v175 (copy), functions (copy), HttpService (copy)
                        local v212, v213 = functions.processIndividualPurchase(p55):await()

                        if not v212 or v213.kind ~= "success" then
                            v175.onScreenFeedbackAdded({
                                message = "Purchase could not be completed. Please try again.",
                                type = "error",
                                id = HttpService:GenerateGUID(false)
                            })
                        else
                            local v214 = ("Purchased %* successfully!"):format(title)

                            v175.onScreenFeedbackAdded({
                                type = "success",
                                id = HttpService:GenerateGUID(false),
                                message = v214
                            })
                        end
                    end)
                end
            })
        end

        v193 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.2
        })

        local v215 = table.create(#t32)

        local function v216(p56, p57) -- line: 1951
            -- upvalues: p42 (copy), v110 (copy), v111 (copy), v176 (copy), v197 (copy), v207 (copy), react (copy), promptPurchase (copy), MountShopCard (copy)
            return react.createElement(MountShopCard, {
                frameRef = if p57 == 0 then v111 else nil,
                key = p56.itemName,
                layoutOrder = 3 + p57,
                mount = p56,
                onBuy = function() -- onBuy | line: 1957
                    -- upvalues: p56 (copy), v176 (copy), v197 (copy), promptPurchase (copy)
                    return v197(p56.displayName, function() -- line: 1958
                        -- upvalues: p56 (copy), v176 (copy), promptPurchase (copy)
                        return promptPurchase(p56.productId, v176)
                    end)
                end,
                onGift = function() -- onGift | line: 1962
                    -- upvalues: p56 (copy), v207 (copy)
                    return v207(p56.productId)
                end,
                onPreview = function() -- onPreview | line: 1965
                    -- upvalues: p56 (copy), p42 (copy)
                    return p42.onPreviewMount(p56.itemName)
                end,
                scrollFrameRef = v110
            })
        end

        for v217, v218 in t32 do
            v215[v217] = v216(v218, v217 - 1, t32)
        end

        v216 = react.createElement(ShopCard, {
            clipsDescendants = false,
            layoutOrder = 2,
            frameRef = v117
        }, react.createElement(default5, {
            sectionType = "LongRainbowSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement(VolcanicAquariumSkinContent, {
            onBuy = function() -- onBuy | line: 1983
                -- upvalues: v176 (copy), v197 (copy), volcanicAquariumSkinProductId (copy), promptPurchase (copy)
                return v197("Volcanic Aquarium Skin", function() -- line: 1984
                    -- upvalues: v176 (copy), volcanicAquariumSkinProductId (copy), promptPurchase (copy)
                    return promptPurchase(volcanicAquariumSkinProductId, v176)
                end)
            end,
            onGift = function() -- onGift | line: 1988
                -- upvalues: v207 (copy), volcanicAquariumSkinProductId (copy)
                return v207(volcanicAquariumSkinProductId)
            end,
            onPreview = function() -- onPreview | line: 1991
                -- upvalues: v163 (copy), Flamework (copy)
                return Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):startPreview("Volcanic", v163)
            end,
            owned = Volcanic,
            raysVisible = v126
        })))

        local v222 = react.createElement(ShopCard, {
            clipsDescendants = false,
            heightScale = 0.76,
            layoutOrder = 0,
            frameRef = v118
        }, react.createElement(default5, {
            sectionType = "XLongRainbowSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.86)
        }, react.createElement(default21, {
            compact = true,
            embeddedInShop = true,
            variant = "exclusiveShop",
            crateIconVisible = v128,
            purchasesDisabled = v176,
            seriesId = multiverseAquariumCrateSeries.id
        }))))
        local v223 = react.createElement(ShopCard, {
            clipsDescendants = false,
            heightScale = 0.76,
            layoutOrder = 1,
            frameRef = v119
        }, react.createElement(default5, {
            sectionType = "XLongRainbowSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.86)
        }, react.createElement(default21, {
            compact = true,
            embeddedInShop = true,
            variant = "exclusiveShop",
            crateIconVisible = v130,
            purchasesDisabled = v176,
            seriesId = activeAquariumCrateSeries.id
        }))))
        local v224 = react.createElement(ShopCard, {
            layoutOrder = #t32 + 3
        }, react.createElement(default5, {
            sectionType = "LongBlueSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default6, {
            originalPrice = 279,
            price = 79,
            title = "Starter Pack",
            items = {
                {
                    iconScale = 1.12,
                    label = "Anchor Barbell",
                    rarity = "rare",
                    icon = weightImages.anchorBarbell
                },
                {
                    label = "Tiger Shark",
                    rarity = "legendary",
                    icon = fishImages.tigerSharkLegendary
                },
                {
                    label = "5m Time Skip",
                    titleLabel = "5m Time Skip",
                    icon = images2.timeSkipIcon,
                    rayColor = Color3.fromRGB(255, 255, 255),
                    subtitleColor = Color3.fromRGB(100, 255, 100),
                    subtitleLabel = v169
                }
            },
            onBuy = function() -- onBuy | line: 2062
                -- upvalues: v176 (copy), v197 (copy), starterPackProductId (copy), promptPurchase (copy)
                return v197("Starter Pack", function() -- line: 2063
                    -- upvalues: v176 (copy), starterPackProductId (copy), promptPurchase (copy)
                    return promptPurchase(starterPackProductId, v176)
                end)
            end,
            onGift = function() -- onGift | line: 2067
                -- upvalues: v207 (copy), starterPackProductId (copy)
                return v207(starterPackProductId)
            end,
            owned = v164,
            productId = starterPackProductId
        })))
        local v226 = react.createElement
        local createElement = {
            frameRef = v112,
            layoutOrder = #t32 + 4
        }
        local createElement3 = react.createElement
        local createElement2 = {
            sectionType = "LongYellowSection",
            size = UDim2.fromScale(1, 1)
        }
        local v225 = react.createElement
        local t37 = {
            price = 399
        }

        function t37.onBuy() -- line: 2083
            -- upvalues: v176 (copy), v197 (copy), vipGamepassProductId (copy), promptPurchase (copy)
            return v197("VIP", function() -- line: 2084
                -- upvalues: v176 (copy), vipGamepassProductId (copy), promptPurchase (copy)
                return promptPurchase(vipGamepassProductId, v176)
            end)
        end

        function t37.onGift() -- line: 2088
            -- upvalues: v207 (copy), vipGamepassProductId (copy)
            return v207(vipGamepassProductId)
        end

        t37.owned = v153
        t37.productId = vipGamepassProductId
        v226 = v226(ShopCard, createElement, createElement3(default5, createElement2, v225(default7, t37)))

        local v227 = table.clone(t9)

        setmetatable(v227, nil)

        v227.onClick = function() -- line: 2097
            -- upvalues: v176 (copy), v197 (copy), t9 (copy), promptPurchase (copy)
            return v197(t9.title, function() -- line: 2098
                -- upvalues: v176 (copy), t9 (copy), promptPurchase (copy)
                return promptPurchase(t9.productId, v176)
            end)
        end

        v227.onGift = function() -- line: 2102
            -- upvalues: v207 (copy), t9 (copy)
            return v207(t9.productId)
        end

        v227.owned = v157
        v227 = react.createElement(ShopCard, {
            layoutOrder = #t32 + 5
        }, react.createElement(default5, {
            sectionType = "LongRedSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement(LongGamepassContent, v227)))
        v164 = {
            left = "MediumBlueSection",
            layoutOrder = #t32 + 6
        }

        local v228 = table.clone(t5)

        setmetatable(v228, nil)

        v228.onClick = function() -- line: 2118
            -- upvalues: v176 (copy), v197 (copy), t5 (copy), promptPurchase (copy)
            return v197(t5.title, function() -- line: 2119
                -- upvalues: v176 (copy), t5 (copy), promptPurchase (copy)
                return promptPurchase(t5.productId, v176)
            end)
        end

        v228.onGift = function() -- line: 2123
            -- upvalues: v207 (copy), t5 (copy)
            return v207(t5.productId)
        end

        v228.owned = v159
        v164.leftContent = react.createElement(GamepassContent, v228)
        v164.right = "MediumPurpleSection"
        v228 = table.clone(t6)
        setmetatable(v228, nil)

        v228.onClick = function() -- line: 2131
            -- upvalues: v176 (copy), v197 (copy), t6 (copy), promptPurchase (copy)
            return v197(t6.title, function() -- line: 2132
                -- upvalues: v176 (copy), t6 (copy), promptPurchase (copy)
                return promptPurchase(t6.productId, v176)
            end)
        end

        v228.onGift = function() -- line: 2136
            -- upvalues: v207 (copy), t6 (copy)
            return v207(t6.productId)
        end

        v228.owned = v160
        v164.rightContent = react.createElement(GamepassContent, v228)
        v228 = react.createElement(MediumSectionRow, v164)
        v164 = {
            left = "MediumGreenSection",
            layoutOrder = #t32 + 7
        }

        local v229 = table.clone(t7)

        setmetatable(v229, nil)

        v229.onClick = function() -- line: 2148
            -- upvalues: v176 (copy), v197 (copy), t7 (copy), promptPurchase (copy)
            return v197(t7.title, function() -- line: 2149
                -- upvalues: v176 (copy), t7 (copy), promptPurchase (copy)
                return promptPurchase(t7.productId, v176)
            end)
        end

        v229.onGift = function() -- line: 2153
            -- upvalues: v207 (copy), t7 (copy)
            return v207(t7.productId)
        end

        v229.owned = v161
        v164.leftContent = react.createElement(GamepassContent, v229)
        v164.right = "MediumPinkSection"
        v229 = table.clone(t8)
        setmetatable(v229, nil)

        v229.onClick = function() -- line: 2161
            -- upvalues: v176 (copy), v197 (copy), t8 (copy), promptPurchase (copy)
            return v197(t8.title, function() -- line: 2162
                -- upvalues: v176 (copy), t8 (copy), promptPurchase (copy)
                return promptPurchase(t8.productId, v176)
            end)
        end

        v229.onGift = function() -- line: 2166
            -- upvalues: v207 (copy), t8 (copy)
            return v207(t8.productId)
        end

        v229.owned = v162
        v164.rightContent = react.createElement(GamepassContent, v229)
        v229 = react.createElement(MediumSectionRow, v164)

        local v230 = react.createElement

        createElement = {
            clipsDescendants = false,
            layoutOrder = 1
        }
        createElement3 = react.createElement
        createElement2 = {
            sectionType = "LongRainbowSection",
            image = images2.longRainbowSection,
            size = UDim2.fromScale(1, 1)
        }
        v225 = react.createElement
        t37 = {}

        if bossAutokillProductId > 0 then
            t37.available = true
        else
            t37.available = isStudioOrStaging()
        end

        t37.giftingEnabled = bossAutokillGiftProductId > 0

        function t37.onBuy() -- line: 2182
            -- upvalues: v197 (copy), RuntimeLib (copy), functions (copy), attemptStorePurchase (copy), MarketplaceService (copy), Players (copy), bossAutokillProductId (copy), getProductConfigurationByProductId (copy), getPurchasePromptProductId (copy), StoreProductType (copy)
            return v197("Auto-Kill Boss Fish", function() -- line: 2183
                -- upvalues: RuntimeLib (copy), functions (copy), attemptStorePurchase (copy), MarketplaceService (copy), Players (copy), bossAutokillProductId (copy), getProductConfigurationByProductId (copy), getPurchasePromptProductId (copy), StoreProductType (copy)
                if bossAutokillProductId == 0 then
                    task.spawn(RuntimeLib.async(function() -- line: 2185
                        -- upvalues: RuntimeLib (copy), functions (copy)
                        RuntimeLib.await(functions.purchaseBossAutokillForTesting())
                    end))
                else
                    local v231 = getProductConfigurationByProductId(bossAutokillProductId)

                    if v231.kind ~= "error" then
                        local data = v231.data
                        local v232 = getPurchasePromptProductId(data, false)

                        if v232 ~= 0 then
                            if data.storeProductType == StoreProductType.Gamepass then
                                MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, v232)
                            else
                                attemptStorePurchase(v232)
                            end
                        end
                    end
                end
            end)
        end

        function t37.onGift() -- line: 2193
            -- upvalues: v207 (copy), bossAutokillGiftProductId (copy)
            return v207(bossAutokillGiftProductId)
        end

        t37.owned = v165
        v230 = v230(ShopCard, createElement, createElement3(default5, createElement2, v225(BossAutokillContent, t37)))

        local v233 = react.createElement

        createElement = {
            layoutOrder = #t32 + 8
        }
        createElement3 = react.createElement
        createElement2 = {
            image = "rbxassetid://94138932672237",
            sectionType = "LongYellowSection",
            size = UDim2.fromScale(1, 1)
        }
        v225 = react.createElement
        t37 = {}

        function t37.onBuy() -- line: 2205
            -- upvalues: v155 (ref), v176 (copy), v197 (copy), promptPurchase (copy)
            return v197("Backpack Capacity", function() -- line: 2206
                -- upvalues: v155 (ref), v176 (copy), promptPurchase (copy)
                return promptPurchase(v155, v176)
            end)
        end

        function t37.onGift() -- line: 2210
            -- upvalues: v155 (ref), v207 (copy)
            return v207(v155)
        end

        t37.price = v158
        t37.productId = v155
        v233 = v233(ShopCard, createElement, createElement3(default5, createElement2, v225(BackpackCapacityContent, t37)))
        v161 = {}

        local createElement4 = table.clone(v149)

        setmetatable(createElement4, nil)
        createElement4.disabledLabel = (v150 or v151) and "Locked" or "Maxed"

        createElement4.onClick = function() -- line: 2220
            -- upvalues: v176 (copy), v197 (copy), v149 (ref), promptPurchase (copy)
            return v197(v149.title, function() -- line: 2221
                -- upvalues: v176 (copy), v149 (ref), promptPurchase (copy)
                return promptPurchase(v149.productId, v176)
            end)
        end

        createElement4.owned = not v152
        v161.contentNode = react.createElement(ServerLuckContent, createElement4)
        v161.sectionType = "MediumButLongGreenSection"
        v161.size = UDim2.fromScale(1, 1)
        createElement4 = react.createElement
        createElement = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.82, 0.8)
        }

        local v220 = react.createElement

        v225 = {
            title = "",
            bodyBg = v22,
            headerBg = v21,
            headerNode = react.createElement(HeaderNode),
            onClose = p42.onClose,
            size = UDim2.fromScale(1, 1)
        }

        local v221 = react.createElement
        local v234 = {
            automaticCanvasSize = true,
            canvasHeightScale = 1,
            clipsDescendants = false,
            itemPaddingScale = 0.015,
            scrollBarThickness = 6,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            padding = {
                bottom = UDim.new(0, 8),
                left = UDim.new(0.012, 0),
                right = UDim.new(0.012, 0),
                top = UDim.new(0.015, 0)
            },
            position = UDim2.fromScale(0.5, 0.97),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            scrollFrameRef = v110,
            size = UDim2.fromScale(0.98, 0.84)
        }
        local v235 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = #t32 + 9,
            Size = UDim2.fromScale(1, 0.4),
            ref = v115
        }, react.createElement(default11, v161))
        local v236 = react.createElement(SmallYellowRow, {
            frameRef = v113,
            layoutOrder = #t32 + 10,
            onBuyPack = function(p58) -- onBuyPack | line: 2270
                -- upvalues: v176 (copy), v188 (copy), promptPurchase (copy)
                local productId = p58.productId

                if productId == nil then
                    return nil
                end

                local title = p58.title

                local function v238() -- line: 2275
                    -- upvalues: productId (copy), v176 (copy), promptPurchase (copy)
                    return promptPurchase(productId, v176)
                end

                if v176 then
                    v188({
                        title = title,
                        onConfirm = v238
                    })
                else
                    promptPurchase(productId, v176)
                end
            end,
            onGiftPack = function(p59) -- onGiftPack | line: 2279
                -- upvalues: v182 (copy), v184 (copy), v190 (copy)
                if p59.productId == nil then
                    return
                end

                v184(p59.productId)
                v190(nil)
                v182(true)
            end
        })
        local createElement5 = react.createElement
        local t38 = {
            left = "MediumYellowSection",
            right = "MediumYellowSection",
            layoutOrder = #t32 + 11
        }

        t38.leftContent = react.createElement(default8, {
            originalPrice = 119,
            price = 34,
            title = "5m Time Skip",
            icon = images2.timeSkipIcon,
            iconSize = UDim2.fromScale(0.86, 0.62),
            onBuy = function() -- onBuy | line: 2290
                -- upvalues: v176 (copy), v197 (copy), timeSkip5MinProductId (copy), promptPurchase (copy)
                return v197("5m Time Skip", function() -- line: 2291
                    -- upvalues: v176 (copy), timeSkip5MinProductId (copy), promptPurchase (copy)
                    return promptPurchase(timeSkip5MinProductId, v176)
                end)
            end,
            onGift = function() -- onGift | line: 2295
                -- upvalues: v207 (copy), timeSkip5MinProductId (copy)
                return v207(timeSkip5MinProductId)
            end,
            productId = timeSkip5MinProductId,
            subtitle = v166,
            subtitleColor = Color3.fromRGB(100, 255, 100)
        })

        local createElement6 = react.createElement
        local t39 = {
            originalPrice = 249,
            price = 179,
            title = "30m Time Skip",
            icon = images2.timeSkipBundleIcon
        }

        function t39.onBuy() -- line: 2308
            -- upvalues: v176 (copy), v197 (copy), timeSkip30MinProductId (copy), promptPurchase (copy)
            return v197("30m Time Skip", function() -- line: 2309
                -- upvalues: v176 (copy), timeSkip30MinProductId (copy), promptPurchase (copy)
                return promptPurchase(timeSkip30MinProductId, v176)
            end)
        end

        function t39.onGift() -- line: 2313
            -- upvalues: v207 (copy), timeSkip30MinProductId (copy)
            return v207(timeSkip30MinProductId)
        end

        t39.productId = timeSkip30MinProductId
        t39.subtitle = v170
        t39.subtitleColor = Color3.fromRGB(100, 255, 100)
        t38.rightContent = createElement6(default8, t39)
        createElement5 = createElement5(MediumSectionRow, t38)

        local v237 = react.createElement

        createElement6 = {
            frameRef = v114,
            layoutOrder = #t32 + 12
        }

        function createElement6.onBuyPack(p60) -- line: 2326
            -- upvalues: v176 (copy), v188 (copy), promptPurchase (copy)
            local productId = p60.productId

            if productId == nil then
                return nil
            end

            local title = p60.title

            local function v239() -- line: 2331
                -- upvalues: productId (copy), v176 (copy), promptPurchase (copy)
                return promptPurchase(productId, v176)
            end

            if v176 then
                v188({
                    title = title,
                    onConfirm = v239
                })
            else
                promptPurchase(productId, v176)
            end
        end

        function createElement6.onGiftPack(p61) -- line: 2335
            -- upvalues: v182 (copy), v184 (copy), v190 (copy)
            if p61.productId == nil then
                return
            end

            v184(p61.productId)
            v190(nil)
            v182(true)
        end

        v220 = v220(default, v225, v221(default4, v234, v215, v216, v222, v223, v224, v226, v227, v228, v229, v230, v233, v235, v236, createElement5, v237(SmallGreyRow, createElement6), react.createElement(ShopCard, {
            heightScale = 0.6,
            frameRef = v116,
            layoutOrder = #t32 + 14
        }, react.createElement(default5, {
            sectionType = "LongLightPurpleSection",
            size = UDim2.fromScale(1, 1)
        }, react.createElement(CodesContent, {
            onClaimSuccess = v148
        })))))
        createElement2 = react.createElement(ShopNavRail, {
            activeLabel = Featured,
            items = t31
        })

        if v191 then
            v191 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 30,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 1, 10),
                Size = UDim2.fromOffset(120, 50)
            }, react.createElement(default2, {
                label = "INVENTORY",
                zIndex = 30,
                color = v23,
                frameSize = UDim2.fromOffset(110, 44),
                onClick = function() -- onClick | line: 2363
                    -- upvalues: v186 (copy)
                    return v186(true)
                end,
                popoutColor = Color3.fromRGB(10, 120, 10)
            }))
        end

        v222 = createElement4("frame", createElement, v193, v220, createElement2, v191)

        local v240

        if v181 then
            v216 = (if v183 == nil then v189 else v183) ~= nil

            if v216 then
                local t41 = {
                    onClose = function() -- onClose | line: 2378
                        -- upvalues: v182 (copy), v184 (copy), v190 (copy)
                        v182(false)
                        v184(nil)
                        v190(nil)
                    end,
                    onSelect = v198
                }

                t41.productId = if v183 == nil then v189 else v183
                v240 = react.createElement(default14, t41)
            else
                v240 = v216
            end
        else
            v240 = v181
        end

        v223 = react.createElement

        local v219 = react.Fragment

        if v185 then
            createElement2 = react.createElement
            v221 = {}

            function v221.onClose() -- line: 2394
                -- upvalues: v186 (copy)
                return v186(false)
            end

            v221.onRetry = v210
            v185 = createElement2(default16, v221)
        end

        return v223(v219, nil, v222, v240, v185, v187 ~= nil and react.createElement(default15, {
            onCancel = function() -- onCancel | line: 2399
                -- upvalues: v188 (copy)
                return v188(nil)
            end,
            onConfirm = function() -- onConfirm | line: 2402
                -- upvalues: v175 (copy), v176 (copy), v177 (copy), v187 (copy), v188 (copy)
                v175.storePurchasePromptStarted({
                    recipientUserId = if v176 then v177 else nil
                })
                v187.onConfirm()
                v188(nil)
            end,
            recipientName = if v176 then v179 else nil,
            title = v187.title
        }), v122 ~= nil and react.createElement(default17, {
            title = "CODE CLAIMED!",
            zIndex = 200,
            iconImage = getCodeRewardIcon(v122),
            key = tostring(v124),
            onFinished = function() -- onFinished | line: 2414
                -- upvalues: v123 (copy)
                return v123(nil)
            end,
            onReveal = playSound,
            rewardRayColor = if v122.rewardType ~= "aquariumShard" then nil elseif v122.rewardShardRarity == nil then nil else rarityColors[v122.rewardShardRarity],
            rewardText = getCodeRewardText(v122, v156),
            timeSkipReward = getCodeRewardTimeSkipReward(v122, v156),
            uiScale = v121 and 0.78 or 1
        }))
    end
}

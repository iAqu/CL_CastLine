-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local default3 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-crate", "aquarium-crate-panel").default
local aquariumCrateSeriesList = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").aquariumCrateSeriesList
local default4 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-shop", "aquarium-shop-window").default
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors")
local selectAquariumShopSection, selectCurrentWindow = v1.selectAquariumShopSection, v1.selectCurrentWindow
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumSkinsData, getAquariumSkinExchangeCost, getAquariumSkinExchangeRarity = v2.aquariumSkinsData, v2.getAquariumSkinExchangeCost, v2.getAquariumSkinExchangeRarity
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local v3 = RuntimeLib.import(script, script.Parent, "exclusive-shop-window-v2")
local default6, getCodeRewardIcon, getCodeRewardText, getCodeRewardTimeSkipReward = v3.default, v3.getCodeRewardIcon, v3.getCodeRewardText, v3.getCodeRewardTimeSkipReward
local t1 = {
    {
        rewardId = "OFFICIAL_REWARD_CODE",
        rewardType = "timeSkip",
        rewardAmount = 300,
        rewardMinimumCash = 10000
    },
    {
        rewardId = "500_LIKES_REWARD_CODE",
        rewardType = "spinWheelSpins",
        rewardAmount = 3
    },
    {
        rewardId = "BAIT_AURA_REWARD_CODE",
        rewardType = "rerolls",
        rewardAmount = 1
    },
    {
        rewardId = "1000_LIKES_REWARD_CODE",
        rewardType = "rerolls",
        rewardAmount = 1
    }
}
local t2 = {}

for _, v4 in aquariumSkinsData do
    local v5 = getAquariumSkinExchangeCost(v4.name)
    local v6 = getAquariumSkinExchangeRarity(v4.name)

    if v5 ~= nil and v6 ~= nil then
        table.insert(t2, {
            displayName = v4.displayName,
            imageId = v4.imageId,
            moneyBoost = v4.moneyBoost,
            name = v4.name,
            rarity = v4.rarity,
            requiredShards = v5,
            shardRarity = v6
        })
    end
end

table.sort(t2, function(p1, p2) -- line: 65
    return p1.requiredShards < p2.requiredShards
end)

local function ExclusiveShopV2Showcase() -- line: 68
    -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), useRootProducer (copy), useRootSelector (copy), default3 (copy), aquariumCrateSeriesList (copy), default4 (copy), selectAquariumShopSection (copy), selectCurrentWindow (copy), default6 (copy), getCodeRewardIcon (copy), getCodeRewardText (copy), getCodeRewardTimeSkipReward (copy), t1 (copy), t2 (copy)
    local v7 = useRootProducer()
    local v8 = useRootSelector(selectCurrentWindow)
    local v9 = useRootSelector(selectAquariumShopSection)
    local v10, v11 = useState(nil)
    local v12, v13 = useState(0)
    local v14 = v8 == "exclusiveShop"
    local v15 = v8 == "aquariumShop"
    local v16 = if v10 == nil then nil else t1[v10 % #t1 + 1]
    local v17 = react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "GothamBold",
        Text = "Show Code Reward",
        TextScaled = true,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(120, 60, 200),
        Event = {
            Activated = function() -- Activated | line: 82
                -- upvalues: v11 (copy), v13 (copy)
                v11(function(p3) -- line: 83
                    if p3 == nil then
                        return 0
                    end

                    return p3 + 1
                end)
                v13(function(p4) -- line: 86
                    return p4 + 1
                end)
            end
        },
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(210, 40),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.12, 0)
    }))
    local v18 = v8 == "none" and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Exclusive Shop",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 106
                -- upvalues: v7 (copy)
                return v7.windowOpened({
                    currentWindow = "exclusiveShop"
                })
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(260, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))
    local v19 = react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v14
    }, react.createElement(default6, {
        onClose = function() -- onClose | line: 125
            -- upvalues: v7 (copy)
            return v7.windowClosed({})
        end,
        onPreviewMount = function(p5) -- onPreviewMount | line: 128
            return print((("Preview Mount: %*"):format(p5)))
        end
    }))
    local t10 = {}
    local v20 = table.create(#aquariumCrateSeriesList)

    local function v21(p6) -- line: 135
        -- upvalues: react (copy), default3 (copy)
        return react.createElement(default3, {
            compact = true,
            embeddedInShop = true,
            paidItemsAllowed = true,
            pityCount = 42,
            showShardsButton = false,
            key = p6.id,
            onPurchase = function(p7) -- onPurchase | line: 140
                -- upvalues: p6 (copy)
                return print((("Story %* purchase: %*"):format(p6.id, p7)))
            end,
            prices = {
                first = 67,
                one = 149,
                ten = 1299,
                three = 399
            },
            series = p6
        })
    end

    for v22, v23 in aquariumCrateSeriesList do
        v20[v22] = v21(v23, v22 - 1, aquariumCrateSeriesList)
    end

    t10.crateContent = v20
    t10.initialSection = v9 or "skins"

    t10.onClose = function() -- line: 161
        -- upvalues: v7 (copy)
        return v7.windowClosed({})
    end

    t10.onCraftShards = function(p8, p9) -- line: 164
        return print((("Story craft %* %* shards"):format(p9, p8)))
    end

    t10.onExchangeSkin = function(p10) -- line: 167
        return print((("Story shard exchange: %*"):format(p10)))
    end

    t10.onPreviewSkin = function(p11) -- line: 170
        return print((("Story skin preview: %*"):format(p11)))
    end

    t10.onUpgradeShards = function(p12, p13) -- line: 173
        return print((("Story upgrade %* batches of %* shards"):format(p13, p12)))
    end

    t10.ownedShards = 750
    t10.ownedSkins = { "Default" }
    t10.skinShardBalances = {
        epic = 90,
        legendary = 15,
        mythic = 5,
        rare = 180
    }
    t10.skins = t2
    t10.universalShardBalance = 750

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v17, v18, v19, react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v15
    }, react.createElement(default4, t10)), v16 ~= nil and react.createElement(default, {
        title = "CODE CLAIMED!",
        uiScale = 1,
        zIndex = 200,
        iconImage = getCodeRewardIcon(v16),
        key = ("code-reward-%*"):format(v12),
        rewardText = getCodeRewardText(v16),
        timeSkipReward = getCodeRewardTimeSkipReward(v16)
    }))
end

return storyForScreenGui(react.createElement(default5, {
    initialState = {
        currentWindow = {
            aquariumShopSection = nil,
            currentShopId = nil,
            currentWindow = "exclusiveShop",
            openShopPrompt = nil
        }
    }
}, react.createElement(ExclusiveShopV2Showcase)))

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumSkinShardRarities, aquariumSkinsData, getAquariumSkinExchangeCost, getAquariumSkinExchangeRarity = v1.aquariumSkinShardRarities, v1.aquariumSkinsData, v1.getAquariumSkinExchangeCost, v1.getAquariumSkinExchangeRarity
local getAquariumSkinShardExchangeRate, getAquariumSkinShardUpgradeRate = v1.getAquariumSkinShardExchangeRate, v1.getAquariumSkinShardUpgradeRate
local aquariumCrateSeriesList = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").aquariumCrateSeriesList
local storyForHoarcekatWindow = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForHoarcekatWindow
local default4 = RuntimeLib.import(script, script.Parent.Parent, "aquarium-crate", "aquarium-crate-panel").default
local default5 = RuntimeLib.import(script, script.Parent, "aquarium-shop-window").default
local t1 = {}

for _, v2 in aquariumCrateSeriesList do
    for _, v3 in v2.entries do
        t1[v3.skin.name] = true
    end
end

local t2 = {}

for _, v4 in aquariumSkinsData do
    if t1[v4.name] ~= nil then
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
end

table.sort(t2, function(p1, p2) -- line: 51
    -- upvalues: aquariumSkinShardRarities (copy)
    local shardRarity = p1.shardRarity
    local v7 = (table.find(aquariumSkinShardRarities, shardRarity) or 0) - 1
    local shardRarity2 = p2.shardRarity

    return v7 < (table.find(aquariumSkinShardRarities, shardRarity2) or 0) - 1
end)

local function ShardBalanceControl(p3) -- line: 58
    -- upvalues: react (copy), useEffect (copy), useState (copy)
    local v8, v9 = useState((tostring(p3.value)))

    useEffect(function() -- line: 60
        -- upvalues: p3 (copy), v9 (copy)
        v9((tostring(p3.value)))
    end, { p3.value })

    local function v10(p4) -- line: 63
        -- upvalues: p3 (copy), v9 (copy)
        local v11 = tonumber(p4)

        if v11 == nil then
            v9((tostring(p3.value)))

            return nil
        end

        local v13 = math.max(0, (math.floor(v11)))

        p3.onChange(v13)
        v9((tostring(v13)))
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(28, 39, 58),
        Size = UDim2.fromScale(1, 0.145)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0.04, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0.12, 0),
        PaddingLeft = UDim.new(0.06, 0),
        PaddingRight = UDim.new(0.06, 0),
        PaddingTop = UDim.new(0.12, 0)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 1000,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromScale(0.46, 1),
        Text = p3.label,
        TextColor3 = Color3.fromRGB(214, 234, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbox", {
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 1000,
        BackgroundColor3 = Color3.fromRGB(11, 17, 28),
        Change = {
            Text = function(p5) -- Text | line: 100
                -- upvalues: v9 (copy)
                return v9(p5.Text)
            end
        },
        Event = {
            FocusLost = function(p6) -- FocusLost | line: 105
                -- upvalues: v10 (copy)
                return v10(p6.Text)
            end
        },
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromScale(0.5, 1),
        Text = v8,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

local function AquariumShopMockControls(p7) -- line: 117
    -- upvalues: react (copy), ShardBalanceControl (copy)
    local v17 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0.06, 0)
    })
    local v18 = react.createElement("uistroke", {
        Thickness = 1,
        Color = Color3.fromRGB(85, 172, 255)
    })
    local v19 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.02, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v20 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0.035, 0),
        PaddingLeft = UDim.new(0.04, 0),
        PaddingRight = UDim.new(0.04, 0),
        PaddingTop = UDim.new(0.035, 0)
    })
    local v21 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "MOCK SHARDS",
        TextScaled = true,
        ZIndex = 1000,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromScale(1, 0.12),
        TextColor3 = Color3.fromRGB(121, 213, 255)
    })
    local v22 = react.createElement(ShardBalanceControl, {
        label = "WILD",
        onChange = p7.onUniversalShardBalanceChanged,
        value = p7.universalShardBalance
    })
    local t8 = {
        "rare",
        "epic",
        "legendary",
        "mythic"
    }
    local v23 = table.create(#t8)

    local function v24(p8) -- line: 153
        -- upvalues: p7 (copy), react (copy), ShardBalanceControl (copy)
        return react.createElement(ShardBalanceControl, {
            key = p8,
            label = string.upper(p8),
            onChange = function(p9) -- onChange | line: 157
                -- upvalues: p8 (copy), p7 (copy)
                return p7.onRarityShardBalanceChanged(p8, p9)
            end,
            value = p7.rarityShardBalances[p8]
        })
    end

    for v25, v26 in t8 do
        v23[v25] = v24(v26, v25 - 1, t8)
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(14, 22, 36),
        Position = UDim2.fromScale(0.01, 0.98),
        Size = UDim2.fromScale(0.12, 0.4)
    }, v17, v18, v19, v20, v21, v22, v23)
end

local function AquariumShopWindowShowcase() -- line: 176
    -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), getAquariumSkinShardExchangeRate (copy), getAquariumSkinShardUpgradeRate (copy), aquariumCrateSeriesList (copy), default4 (copy), default5 (copy), t2 (copy), AquariumShopMockControls (copy)
    local v27, v28 = useState(true)
    local v29, v30 = useState(750)
    local v31, v32 = useState({
        rare = 180,
        epic = 90,
        legendary = 15,
        mythic = 5
    })
    local v33, v34 = useState({ "Default" })

    local function v35(p10, p11) -- line: 186
        -- upvalues: v31 (copy), v32 (copy)
        local v36 = table.clone(v31)

        setmetatable(v36, nil)
        v36[p10] = p11
        v32(v36)
    end

    local v37 = not v27

    v37 = v37 and react.createElement(default, {
        isShiny = true,
        isStudded = true,
        label = "OPEN AQUARIUM SHOP",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 224, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 115, 239))
        }),
        frameSize = UDim2.fromScale(0.24, 0.09),
        onClick = function() -- onClick | line: 199
            -- upvalues: v28 (copy)
            return v28(true)
        end,
        position = UDim2.fromScale(0.5, 0.5)
    })

    local t11 = {}
    local v38 = table.create(#aquariumCrateSeriesList)

    local function v39(p12) -- line: 207
        -- upvalues: react (copy), default4 (copy)
        return react.createElement(default4, {
            compact = true,
            embeddedInShop = true,
            paidItemsAllowed = true,
            pityCount = 42,
            showShardsButton = false,
            variant = "exclusiveShop",
            key = p12.id,
            onPurchase = function(p13) -- onPurchase | line: 212
                -- upvalues: p12 (copy)
                return print((("Story %* purchase: %*"):format(p12.id, p13)))
            end,
            prices = {
                first = 67,
                one = 149,
                ten = 1299,
                three = 399
            },
            series = p12
        })
    end

    for v40, v41 in aquariumCrateSeriesList do
        v38[v40] = v39(v41, v40 - 1, aquariumCrateSeriesList)
    end

    t11.crateContent = v38

    t11.onClose = function() -- line: 233
        -- upvalues: v28 (copy)
        return v28(false)
    end

    t11.onCraftShards = function(p14, p15) -- line: 236
        -- upvalues: v29 (copy), v30 (copy), v31 (copy), v32 (copy), getAquariumSkinShardExchangeRate (copy)
        local v42 = getAquariumSkinShardExchangeRate(p14).universalShardsPerCraft * p15

        if v29 < v42 then
            return nil
        end

        v30(v29 - v42)

        local v43 = table.clone(v31)

        setmetatable(v43, nil)
        v43[p14] = v31[p14] + p15
        v32(v43)
    end

    t11.onExchangeSkin = function(p16) -- line: 247
        -- upvalues: v31 (copy), v32 (copy), v33 (copy), v34 (copy), t2 (copy)
        local v44

        for v45, v46 in t2 do
            local _ = v45 - 1

            if v46.name == p16 == true then
                v44 = v46
                break
            end

            v44 = nil
        end

        if v44 == nil or table.find(v33, p16) ~= nil or v31[v44.shardRarity] < v44.requiredShards then
            return nil
        end

        local v47 = table.clone(v31)

        setmetatable(v47, nil)
        v47[v44.shardRarity] = v31[v44.shardRarity] - v44.requiredShards
        v32(v47)

        local t13 = {}
        local v48 = #t13
        local v49 = #v33

        table.move(v33, 1, v49, v48 + 1, t13)
        t13[v48 + v49 + 1] = p16
        v34(t13)
    end

    t11.onPreviewSkin = function(p17) -- line: 284
        return print((("Story skin preview: %*"):format(p17)))
    end

    t11.onUpgradeShards = function(p18, p19) -- line: 287
        -- upvalues: v31 (copy), v32 (copy), getAquariumSkinShardUpgradeRate (copy)
        local v50 = getAquariumSkinShardUpgradeRate(p18)
        local v51 = v50.sourceShardsPerCraft * p19

        if v31[p18] < v51 then
            return nil
        end

        local v52 = table.clone(v31)

        setmetatable(v52, nil)
        v52[p18] = v31[p18] - v51
        v52[v50.targetRarity] = v31[v50.targetRarity] + p19
        v32(v52)
    end

    t11.ownedShards = v29
    t11.ownedSkins = v33
    t11.skinShardBalances = v31
    t11.skins = t2
    t11.universalShardBalance = v29

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, v37, react.createElement(default2, {
        enableCameraEffects = false,
        ["in"] = v27
    }, react.createElement(default5, t11)), react.createElement(AquariumShopMockControls, {
        onRarityShardBalanceChanged = v35,
        onUniversalShardBalanceChanged = v30,
        rarityShardBalances = v31,
        universalShardBalance = v29
    }))
end

return storyForHoarcekatWindow(react.createElement(default3, nil, react.createElement(AquariumShopWindowShowcase)))

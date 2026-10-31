-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local fishImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").fishImages
local aquariumSkinsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").aquariumSkinsData
local exclusiveFishConfigs = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").exclusiveFishConfigs
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-menu").default
local default3 = RuntimeLib.import(script, script.Parent, "aquarium-add-fish").default
local default4 = RuntimeLib.import(script, script.Parent, "aquarium-stats-panel").default
local getAquariumStatBoosts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "hoola-bonus-utils").getAquariumStatBoosts
local t1 = {
    {
        fishId = "mock-0",
        fishName = "Verdantus",
        rarity = "extinct",
        level = 70,
        levelUpCost = 1E+05,
        moneyPerSecond = 950000,
        offlineEarningPerSec = 9500,
        mutation = "Normal",
        imageId = fishImages.Verdantus
    },
    {
        fishId = "mock-1",
        fishName = "Leviathan",
        rarity = "cosmic",
        level = 60,
        levelUpCost = 50000,
        moneyPerSecond = 5000,
        offlineEarningPerSec = 50,
        mutation = "Normal",
        imageId = fishImages.leviathan
    },
    {
        fishId = "mock-2",
        fishName = "Abyss Whale",
        rarity = "hacked",
        level = 58,
        levelUpCost = 40000,
        moneyPerSecond = 4000,
        offlineEarningPerSec = 40,
        mutation = "Normal",
        imageId = fishImages.abyssWhale
    },
    {
        fishId = "mock-3",
        fishName = "Angler Fish",
        rarity = "secret",
        level = 55,
        levelUpCost = 30000,
        moneyPerSecond = 3000,
        offlineEarningPerSec = 30,
        mutation = "Normal",
        imageId = fishImages.anglerFish
    },
    {
        fishId = "mock-4",
        fishName = "Frost Tooth",
        rarity = "godly",
        level = 52,
        levelUpCost = 20000,
        moneyPerSecond = 2000,
        offlineEarningPerSec = 20,
        mutation = "Normal",
        imageId = fishImages.frostTooth
    },
    {
        fishId = "mock-5",
        fishName = "Berrywhal",
        rarity = "mythic",
        level = 50,
        levelUpCost = 10000,
        moneyPerSecond = 1000,
        offlineEarningPerSec = 10,
        mutation = "Normal",
        imageId = fishImages.berrywhal
    },
    {
        fishId = "mock-6",
        fishName = "Megalodon",
        rarity = "legendary",
        level = 50,
        levelUpCost = 5000,
        moneyPerSecond = 500,
        offlineEarningPerSec = 5,
        mutation = "Normal",
        imageId = fishImages.megalodon
    },
    {
        fishId = "mock-7",
        fishName = "Fish Fish",
        rarity = "epic",
        level = 38,
        levelUpCost = 1500,
        moneyPerSecond = 150,
        offlineEarningPerSec = 1.5,
        mutation = "Normal",
        imageId = fishImages.fishFish
    },
    {
        fishId = "mock-8",
        fishName = "Pepperayni",
        rarity = "rare",
        level = 25,
        levelUpCost = 500,
        moneyPerSecond = 1.1,
        offlineEarningPerSec = 0.28,
        mutation = "Normal",
        imageId = fishImages.pepperyani
    },
    {
        fishId = "mock-9",
        fishName = "Clown Fish",
        rarity = "uncommon",
        level = 20,
        levelUpCost = 200,
        moneyPerSecond = 10,
        offlineEarningPerSec = 0.25,
        mutation = "Normal",
        imageId = fishImages.clownFish
    },
    {
        fishId = "mock-10",
        fishName = "Fish Flops",
        rarity = "common",
        level = 10,
        levelUpCost = 100,
        moneyPerSecond = 4,
        offlineEarningPerSec = 0.1,
        mutation = "Normal",
        imageId = fishImages.fishFlops
    }
}
local v1 = #t1
local v2 = table.create(#exclusiveFishConfigs)

local function v3(p1, p2) -- line: 130
    return {
        rarity = "exclusive",
        isExclusive = true,
        level = 1,
        levelUpCost = 0,
        mutation = "Normal",
        fishId = `mock-exclusive-{ p2 + 1 }`,
        fishName = p1.fishName,
        imageId = p1.imageId,
        moneyPerSecond = 100 * p1.mpsMultiplier,
        offlineEarningPerSec = 1 * p1.mpsMultiplier
    }
end

for v4, v5 in exclusiveFishConfigs do
    v2[v4] = v3(v5, v4 - 1, exclusiveFishConfigs)
end

table.move(v2, 1, #v2, v1 + 1, t1)

local t2 = {
    {
        fishId = "inv-0",
        fishName = "Verdantus",
        rarity = "extinct",
        level = 65,
        levelUpCost = 90000,
        moneyPerSecond = 950000,
        offlineEarningPerSec = 9500,
        mutation = "Normal",
        imageId = fishImages.Verdantus
    },
    {
        fishId = "inv-1",
        fishName = "Light Leviathan",
        rarity = "cosmic",
        level = 62,
        levelUpCost = 55000,
        moneyPerSecond = 5500,
        offlineEarningPerSec = 55,
        mutation = "Normal",
        imageId = fishImages.lightLeviathan
    },
    {
        fishId = "inv-2",
        fishName = "Lava Whale",
        rarity = "hacked",
        level = 57,
        levelUpCost = 42000,
        moneyPerSecond = 4200,
        offlineEarningPerSec = 42,
        mutation = "Normal",
        imageId = fishImages.lavaWhale
    },
    {
        fishId = "inv-3",
        fishName = "Sky Whale",
        rarity = "secret",
        level = 54,
        levelUpCost = 28000,
        moneyPerSecond = 2800,
        offlineEarningPerSec = 28,
        mutation = "Normal",
        imageId = fishImages.skyWhale
    },
    {
        fishId = "inv-4",
        fishName = "Handsome Shark",
        rarity = "godly",
        level = 51,
        levelUpCost = 18000,
        moneyPerSecond = 1800,
        offlineEarningPerSec = 18,
        mutation = "Normal",
        imageId = fishImages.handsomeShark
    },
    {
        fishId = "inv-5",
        fishName = "Lapla",
        rarity = "mythic",
        level = 48,
        levelUpCost = 9000,
        moneyPerSecond = 900,
        offlineEarningPerSec = 9,
        mutation = "Normal",
        imageId = fishImages.lapla
    },
    {
        fishId = "inv-6",
        fishName = "Whale Shark",
        rarity = "legendary",
        level = 45,
        levelUpCost = 4200,
        moneyPerSecond = 420,
        offlineEarningPerSec = 4.2,
        mutation = "Normal",
        imageId = fishImages.whaleShark
    },
    {
        fishId = "inv-7",
        fishName = "Orca",
        rarity = "epic",
        level = 30,
        levelUpCost = 1200,
        moneyPerSecond = 120,
        offlineEarningPerSec = 1.2,
        mutation = "Normal",
        imageId = fishImages.orca
    },
    {
        fishId = "inv-8",
        fishName = "Noob Fish",
        rarity = "rare",
        level = 22,
        levelUpCost = 350,
        moneyPerSecond = 35,
        offlineEarningPerSec = 0.35,
        mutation = "Normal",
        imageId = fishImages.noobFish
    },
    {
        fishId = "inv-9",
        fishName = "HeeHee Fish",
        rarity = "uncommon",
        level = 15,
        levelUpCost = 180,
        moneyPerSecond = 18,
        offlineEarningPerSec = 0.18,
        mutation = "Normal",
        imageId = fishImages.heeHeeFish
    },
    {
        fishId = "inv-10",
        fishName = "Sun Fish",
        rarity = "common",
        level = 8,
        levelUpCost = 60,
        moneyPerSecond = 6,
        offlineEarningPerSec = 0.06,
        mutation = "Normal",
        imageId = fishImages.sunFish
    }
}
local t3 = {}
local v6 = #t3

for v7, v8 in aquariumSkinsData do
    v6 += 1
    t3[v6] = { v7, v8 }
end

local v9 = table.create(#t3)

local function v10(p3) -- line: 269
    local v11 = p3[2]

    return {
        name = v11.name,
        displayName = v11.displayName,
        description = v11.description,
        imageId = v11.imageId,
        moneyBoost = v11.moneyBoost,
        moneyPrice = v11.moneyPrice,
        robuxPrice = v11.robuxPrice,
        rarity = v11.rarity,
        source = v11.source
    }
end

for v12, v13 in t3 do
    v9[v12] = v10(v13, v12 - 1, t3)
end

local t4 = {
    0,
    tutorialSteps.equipBestFish,
    tutorialSteps.levelUpFish,
    tutorialSteps.collectMoney,
    tutorialSteps.closeAquarium
}
local t5 = {}

t5[0] = "none"
t5[tutorialSteps.equipBestFish] = "equipBestFish"
t5[tutorialSteps.levelUpFish] = "levelUpFish"
t5[tutorialSteps.collectMoney] = "collectMoney"
t5[tutorialSteps.closeAquarium] = "closeAquarium"

local t6 = {
    ["stat-fish-1"] = {
        mutations = { "hoola3" }
    },
    ["stat-fish-2"] = {
        mutations = { "hoola2" }
    }
}

local function AquariumMenuShowcase() -- line: 304
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), default4 (copy), getAquariumStatBoosts (copy), t1 (copy), t2 (copy), v9 (copy), t4 (copy), t5 (copy), t6 (copy)
    local v14, v15 = useState(true)
    local v16, v17 = useState(false)
    local v18, v19 = useState(false)
    local v20, v21 = useState(false)
    local v22, v23 = useState(false)
    local v24, v25 = useState(0)
    local v26, v27 = useState({ "Default", "Fossil" })
    local v28, v29 = useState({ "Default" })
    local Default, Default2 = useState("Default")
    local t7 = {}
    local n1 = 0

    for v30, v31 in v26 do
        local _ = v30 - 1

        if table.find(v28, v31) == nil == true then
            n1 += 1
            t7[n1] = v31
        end
    end

    local v32 = #t7
    local v33 = t4[v24 + 1]
    local v34 = getAquariumStatBoosts(t6, v26)

    local function v35() -- line: 331
        -- upvalues: v16 (copy), v17 (copy), v19 (copy)
        if v16 then
            v17(false)
        else
            v19(true)
            v17(true)
        end
    end

    local function v36() -- line: 339
        -- upvalues: v20 (copy), v21 (copy), v23 (copy)
        if v20 then
            v21(false)
        else
            v23(true)
            v21(true)
        end
    end

    local v37 = t5[v33]

    if v37 == nil then
        v37 = tostring(v33)
    end

    local createElement = react.createElement
    local t8 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v38 = react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 120),
        Event = {
            Activated = function() -- Activated | line: 360
                -- upvalues: v25 (copy), t4 (copy)
                return v25(function(p4) -- line: 361
                    -- upvalues: t4 (copy)
                    return (p4 + 1) % #t4
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.fromOffset(200, 36),
        Text = ("Tutorial: %*"):format(v37),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    }))
    local v39 = not v14

    v39 = v39 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Open Aquarium",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(50, 120, 200),
        Event = {
            Activated = function() -- Activated | line: 380
                -- upvalues: v15 (copy)
                return v15(true)
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    if not v14 then
        v22 = v14
        v18 = v14

        return createElement("frame", t8, v38, v39, v14, v18, v22)
    end

    v14 = react.createElement(default2, {
        capacity = 12,
        indexEarningsBoost = 0.06,
        refreshKey = 0,
        equippedSkin = Default,
        fish = t1,
        getInitialTab = function() -- getInitialTab | line: 396
            return nil
        end,
        newSkinCount = v32,
        onAddFish = v35,
        onClearInitialTab = function() -- onClearInitialTab | line: 402
        end,
        onClose = function() -- onClose | line: 403
            -- upvalues: v15 (copy), v17 (copy), v19 (copy), v21 (copy), v23 (copy)
            v15(false)
            v17(false)
            v19(false)
            v21(false)
            v23(false)
        end,
        onEquipBest = function() -- onEquipBest | line: 410
            return print("equip best fish")
        end,
        onEquipSkin = function(p5) -- onEquipSkin | line: 413
            -- upvalues: v29 (copy), Default2 (copy)
            v29(function(p6) -- line: 414
                -- upvalues: p5 (copy)
                if table.find(p6, p5) ~= nil then
                    return p6
                end

                local t14 = {}
                local v40 = #t14
                local v41 = #p6

                table.move(p6, 1, v41, v40 + 1, t14)
                t14[v40 + v41 + 1] = p5

                return t14
            end)
            Default2(p5)
        end,
        onLevelUp = function(p7) -- onLevelUp | line: 433
            return print((("level up fish %*"):format(p7)))
        end,
        onOpenSourceWindow = function(p8) -- onOpenSourceWindow | line: 436
            return print((("open source window: %*"):format(p8)))
        end,
        onPreviewSkin = function(p9) -- onPreviewSkin | line: 439
            return print((("preview skin %*"):format(p9)))
        end,
        onPurchaseSkin = function(p10) -- onPurchaseSkin | line: 442
            -- upvalues: v27 (copy)
            v27(function(p11) -- line: 443
                -- upvalues: p10 (copy)
                if table.find(p11, p10) ~= nil then
                    return p11
                end

                local t15 = {}
                local v42 = #t15
                local v43 = #p11

                table.move(p11, 1, v43, v42 + 1, t15)
                t15[v42 + v43 + 1] = p10

                return t15
            end)
        end,
        onRemove = function(p12) -- onRemove | line: 461
            return print((("remove fish %*"):format(p12)))
        end,
        onSkinsTab = function() -- onSkinsTab | line: 464
            -- upvalues: v17 (copy)
            return v17(false)
        end,
        onViewStats = v36,
        ownedSkins = v26,
        skins = v9,
        tutorialStep = v33
    })
    v18 = v18 and react.createElement(default3, {
        fish = t2,
        isClosing = not v16,
        onClose = function() -- onClose | line: 475
            -- upvalues: v17 (copy)
            return v17(false)
        end,
        onCloseComplete = function() -- onCloseComplete | line: 478
            -- upvalues: v19 (copy)
            return v19(false)
        end,
        onSelectFish = function(p13) -- onSelectFish | line: 481
            return print((("select inventory fish %*"):format(p13)))
        end
    })
    v22 = v22 and react.createElement(default4, {
        moneyPerSecond = 12345,
        boosts = v34,
        isClosing = not v20,
        onClose = function() -- onClose | line: 488
            -- upvalues: v21 (copy)
            return v21(false)
        end,
        onCloseComplete = function() -- onCloseComplete | line: 491
            -- upvalues: v23 (copy)
            return v23(false)
        end
    })

    return createElement("frame", t8, v38, v39, v14, v18, v22)
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(AquariumMenuShowcase)), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default2 = RuntimeLib.import(script, script.Parent, "toolbar").default
local default3 = RuntimeLib.import(script, script.Parent, "backpack-window").default
local t2 = {
    "FishFlops",
    "Catfish",
    "Dolphin",
    "Blade",
    "Berrypla",
    "Berrywhal",
    "FrostTooth",
    "AbyssWhale",
    "DevilFlare",
    "Blueflare",
    "Verdantus"
}
local v1 = HttpService:GenerateGUID(false)
local t1 = {}

t1[v1] = {
    itemName = "BambooRod",
    itemType = "fishingRod",
    isEquipped = true,
    timeStampAdded = 0,
    isInToolbar = true,
    itemId = v1
}

local t3 = {
    {},
    { "Gold" },
    { "Diamond" },
    { "Plasma" },
    { "Molten" },
    { "Radioactive" },
    { "Glitched" },
    { "Gold", "Diamond" },
    { "Plasma", "Radioactive" },
    { "Gold", "Glitched" },
    {}
}

for i = 1, #t2 do
    local v2 = HttpService:GenerateGUID(false)

    t1[v2] = {
        itemType = "fish",
        isEquipped = false,
        level = 1,
        fishObtainedTimestamp = i,
        itemId = v2,
        itemName = t2[i],
        mutations = t3[i],
        timeStampAdded = i
    }
end

local function ToolbarDragDropStory() -- line: 46
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), t1 (copy)
    local v3, v4 = useState(function() -- line: 47
        -- upvalues: t1 (copy)
        local t4 = {}

        for _, v5 in t1 do
            if v5.itemType == "fish" then
                table.insert(t4, v5)
            end
        end

        table.sort(t4, function(p1, p2) -- line: 54
            return p1.timeStampAdded < p2.timeStampAdded
        end)

        local t5 = {}

        table.insert(t5, t4[1] or false)
        table.insert(t5, t4[2] or false)
        table.insert(t5, t4[3] or false)
        table.insert(t5, t4[4] or false)
        table.insert(t5, t4[5] or false)
        table.insert(t5, t4[6] or false)
        table.insert(t5, t4[7] or false)
        table.insert(t5, t4[8] or false)
        table.insert(t5, t4[9] or false)

        return t5
    end)
    local v15, v16 = useState(function() -- line: 64
        -- upvalues: t1 (copy)
        local t6 = {}

        for _, v17 in t1 do
            if v17.itemType == "fish" then
                table.insert(t6, v17)
            end
        end

        table.sort(t6, function(p3, p4) -- line: 71
            return p3.timeStampAdded < p4.timeStampAdded
        end)

        local t7 = {}

        local function v18(_, p6) -- line: 76
            return p6 >= 9
        end

        local n1 = 0

        for v19, v20 in t6 do
            if v19 - 1 >= 9 == true then
                n1 += 1
                t7[n1] = v20
            end
        end

        return t7
    end)
    local v21, v22 = useState(false)

    local function v23(p7, p8) -- line: 90
        -- upvalues: v3 (copy), v4 (copy), v15 (copy), v16 (copy)
        local n2 = -1
        local v24 = #v3 - 1
        local n3 = -1

        for i = 0, v24 do
            local v25 = v3[i + 1]

            if v25 ~= false and v25.itemId == p7 then
                n2 = i
                n3 = i
                break
            end
        end

        local n4 = -1

        for v26, v27 in v15 do
            local _ = v26 - 1

            if v27.itemId == p7 == true then
                n4 = v26 - 1
                break
            end
        end

        if n3 ~= -1 then
            v4(function(p9) -- line: 113
                -- upvalues: p8 (copy), n2 (ref)
                local t8 = {}
                local v28 = #t8

                table.move(p9, 1, #p9, v28 + 1, t8)

                local v29 = t8[n2 + 1]
                local v30 = t8[p8 + 1]

                t8[p8 + 1] = v29
                t8[n2 + 1] = v30

                return t8
            end)

            return nil
        end

        if n4 == -1 or v3[p8 + 1] ~= false then
            return
        end

        local v31 = v15[n4 + 1]

        v16(function(p10) -- line: 128
            -- upvalues: p7 (copy)
            local t9 = {}
            local n5 = 0

            for v32, v33 in p10 do
                local _ = v32 - 1

                if v33.itemId ~= p7 == true then
                    n5 += 1
                    t9[n5] = v33
                end
            end

            return t9
        end)
        v4(function(p11) -- line: 144
            -- upvalues: p8 (copy), v31 (copy)
            local t10 = {}
            local v34 = #t10

            table.move(p11, 1, #p11, v34 + 1, t10)
            t10[p8 + 1] = v31

            return t10
        end)
    end

    local function v35(p12) -- line: 154
        -- upvalues: v3 (copy), v4 (copy), v16 (copy)
        local n6 = -1
        local v36 = #v3 - 1
        local n7 = -1

        for i = 0, v36 do
            local v37 = v3[i + 1]

            if v37 ~= false and v37.itemId == p12 then
                n6 = i
                n7 = i
                break
            end
        end

        if n7 == -1 then
            return nil
        end

        local v38 = v3[n7 + 1]

        if v38 == false then
            return nil
        end

        v4(function(p13) -- line: 170
            -- upvalues: n6 (ref)
            local t11 = {}
            local v39 = #t11

            table.move(p13, 1, #p13, v39 + 1, t11)
            t11[n6 + 1] = false

            return t11
        end)
        v16(function(p14) -- line: 178
            -- upvalues: p12 (copy), v38 (copy)
            local v40 = false

            for v41, v42 in p14 do
                local _ = v41 - 1

                if v42.itemId == p12 then
                    v40 = true
                    break
                end
            end

            if v40 then
                return p14
            end

            local t12 = {}
            local v43 = #t12
            local v44 = #p14

            table.move(p14, 1, v44, v43 + 1, t12)
            t12[v43 + v44 + 1] = v38

            return t12
        end)
    end

    local v45 = if v21 then {} else v15

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        isBackpackOpen = true,
        activeItems = v3,
        onFishDroppedOnToolbar = v23,
        onItemClick = function() -- onItemClick | line: 211
        end
    }), react.createElement(default3, {
        maxItemCount = 120,
        showMountsTab = true,
        excessItems = v45,
        onClose = function() -- onClose | line: 215
        end,
        onFishDroppedInBackpack = v35,
        totalBackpackFishCount = #v45,
        onUpgradeClick = function() -- onUpgradeClick | line: 219
            return print("Backpack upgrade clicked")
        end
    }), react.createElement("textbutton", {
        TextScaled = true,
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Event = {
            Activated = function() -- Activated | line: 226
                -- upvalues: v22 (copy)
                return v22(function(p15) -- line: 227
                    return not p15
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.02, 0.02),
        Size = UDim2.fromOffset(220, 40),
        Text = v21 and "Show fish in backpack" or "Empty the backpack",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    })))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {
        playerData = {
            fishingContracts = {},
            materials = {},
            rodSkins = {},
            tutorialTracking = {},
            emotes = {},
            danceFloorAura = {},
            fishReelbackVfx = {},
            hallOfFame = {},
            inventory = {
                [localPlayerUserId] = t1
            },
            metadata = {},
            stats = {},
            rewards = {},
            plot = {},
            gamepasses = {
                [localPlayerUserId] = {}
            },
            purchaseHistory = {
                [localPlayerUserId] = {}
            },
            bundlePurchaseHistory = {
                [localPlayerUserId] = {}
            },
            aquarium = {
                [localPlayerUserId] = {
                    aquariumLevel = 1,
                    cratePityCount = 0,
                    universalSkinShards = 0,
                    moneyPerSecond = 0,
                    uncollectedMoney = 0,
                    aquariumUpgradeCompleteTimestamp = nil,
                    aquariumUpgradeStartedTimestamp = nil,
                    equippedSkin = "Default",
                    skinShardBalances = {
                        rare = 0,
                        epic = 0,
                        legendary = 0,
                        mythic = 0
                    },
                    fishItems = {},
                    ownedSkins = { "Default" },
                    pendingCrateReveals = {},
                    resolvedCrateReveals = {},
                    seenSkins = {}
                }
            },
            offlineEarnings = {},
            collectionIndex = {
                [localPlayerUserId] = {
                    discoveredFish = {},
                    seenFishes = {}
                }
            },
            rebirth = {
                [localPlayerUserId] = {
                    rebirthCount = 0,
                    currentBestZone = 0,
                    previousRebirthBestZone = 0
                }
            },
            titles = {},
            baitAuras = {},
            charms = {
                [localPlayerUserId] = {
                    equippedCharmId = nil,
                    charmCoresByTier = {},
                    ownedCharmIds = {}
                }
            },
            mounts = {
                [localPlayerUserId] = {
                    activeMountName = nil,
                    isMounted = false,
                    ownedMountNames = {}
                }
            },
            zoneGacha = {
                [localPlayerUserId] = {
                    eyesEquippedBuffId = nil,
                    eyesEquippedSkinId = nil,
                    headEquippedBuffId = nil,
                    headEquippedSkinId = nil,
                    legendaryEquippedBuffId = nil,
                    legendaryEquippedSkinId = nil,
                    tokenA = 0,
                    tokenB = 0,
                    tokenC = 0,
                    ownedItemIds = {}
                }
            },
            fishDisplay = {}
        },
        currentWindow = {
            currentWindow = "backpack",
            currentShopId = "",
            openShopPrompt = nil
        }
    }
}, react.createElement(ToolbarDragDropStory)))

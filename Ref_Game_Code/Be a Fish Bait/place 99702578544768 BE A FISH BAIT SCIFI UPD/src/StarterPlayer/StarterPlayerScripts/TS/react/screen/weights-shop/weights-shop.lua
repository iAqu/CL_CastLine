-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils")
local promptProductPurchaseWithExtraInfo, promptCashPurchase = v1.promptProductPurchaseWithExtraInfo, v1.promptCashPurchase
local getTrainingWeightProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getTrainingWeightProductId
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerInventory, selectPlayerRebirthCount, selectPlayerStat, selectPlayerAquariumMoneyPerSecond = selectors.selectPlayerInventory, selectors.selectPlayerRebirthCount, selectors.selectPlayerStat, selectors.selectPlayerAquariumMoneyPerSecond
local selectPlayerBuffBonuses = selectors.selectPlayerBuffBonuses
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "training-weights")
local trainingWeightsData, trainingWeightOrder = v2.trainingWeightsData, v2.trainingWeightOrder
local weightRebirthRequirements = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "shops").weightRebirthRequirements
local default3 = RuntimeLib.import(script, script.Parent, "weights-shop-item").default
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local t1 = {}
local t2 = {
    common = 1,
    uncommon = 2,
    rare = 3,
    epic = 4,
    legendary = 5,
    mythic = 6,
    godly = 7,
    secret = 8,
    hacked = 9,
    cosmic = 10,
    extinct = 11,
    kaijuwu = 12,
    scifi = 13
}

local function v3(p1, p2) -- line: 50
    -- upvalues: t1 (copy)
    table.insert(t1, {
        imageId = p1.imageId,
        key = p2,
        name = p1.name,
        power = p1.powerPerTrain,
        price = p1.price,
        rarity = p1.rarity,
        robuxPrice = p1.robuxPrice,
        weightKg = p1.weightKg
    })
end

for v4, v5 in trainingWeightsData do
    table.insert(t1, {
        imageId = v5.imageId,
        key = v4,
        name = v5.name,
        power = v5.powerPerTrain,
        price = v5.price,
        rarity = v5.rarity,
        robuxPrice = v5.robuxPrice,
        weightKg = v5.weightKg
    })
end

table.sort(t1, function(p3, p4) -- line: 67
    -- upvalues: t2 (copy)
    local v6 = t2[p3.rarity]
    local v7 = t2[p4.rarity]

    if v6 == v7 then
        return p3.price < p4.price
    end

    return v6 < v7
end)

return {
    default = function(p5) -- WeightsShop | line: 75
        -- upvalues: react (copy), useMemo (copy), default (copy), useRootProducer (copy), useRootSelector (copy), default2 (copy), functions (copy), HttpService (copy), promptProductPurchaseWithExtraInfo (copy), promptCashPurchase (copy), getTrainingWeightProductId (copy), localPlayerUserId (copy), selectPlayerInventory (copy), selectPlayerRebirthCount (copy), selectPlayerStat (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerBuffBonuses (copy), trainingWeightsData (copy), trainingWeightOrder (copy), weightRebirthRequirements (copy), default3 (copy), useSound (copy), useScreenSizeState (copy), selectTutorialStep (copy), tutorialSteps (copy), t1 (copy)
        local v8 = useRootProducer()
        local v9 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v10 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v11 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

        if v11 == nil then
            v11 = 0
        end

        local v12 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local moneyDiscount = useRootSelector(selectPlayerBuffBonuses(localPlayerUserId)).moneyDiscount
        local v13 = useRootSelector(selectTutorialStep)
        local playSound = useSound("PurchaseSuccess").playSound
        local v14 = useScreenSizeState()
        local v15 = if v14 == "sm" then 4 elseif v14 == "md" then 7 else 10
        local v16 = useMemo(function() -- line: 91
            -- upvalues: v9 (copy)
            local t5 = {}

            if v9 then
                for _, v17 in v9 do
                    if v17.itemType == "trainingWeight" then
                        t5[v17.itemName] = true
                    end
                end
            end

            return t5
        end, { v9 })
        local v18 = useMemo(function() -- line: 104
            -- upvalues: v9 (copy)
            if not v9 then
                return nil
            end

            for _, v19 in v9 do
                if v19.itemType == "trainingWeight" and v19.isInToolbar then
                    return v19.itemName
                end
            end

            return nil
        end, { v9 })
        local v20 = table.create(#t1)

        local function v21(p6, p7) -- line: 128
            -- upvalues: v8 (copy), v9 (copy), v10 (copy), v11 (ref), v12 (copy), moneyDiscount (copy), v13 (copy), playSound (copy), v16 (copy), v18 (copy), react (copy), functions (copy), HttpService (copy), promptProductPurchaseWithExtraInfo (copy), promptCashPurchase (copy), getTrainingWeightProductId (copy), trainingWeightsData (copy), trainingWeightOrder (copy), weightRebirthRequirements (copy), default3 (copy), tutorialSteps (copy)
            local v23 = math.floor(p6.price * (1 - moneyDiscount))
            local t6 = {
                imageId = p6.imageId,
                isEquipped = v18 == p6.key
            }

            t6.isOwned = v16[p6.key] ~= nil
            t6.key = p6.key
            t6.layoutOrder = p7
            t6.name = p6.name

            t6.onBuy = function() -- line: 139
                -- upvalues: p6 (copy), v23 (copy), v8 (copy), v11 (ref), v12 (copy), v13 (copy), playSound (copy), v16 (copy), functions (copy), HttpService (copy), promptCashPurchase (copy), trainingWeightsData (copy), trainingWeightOrder (copy), tutorialSteps (copy)
                local key = p6.key
                local v24 = (table.find(trainingWeightOrder, key) or 0) - 1
                local v25, v26

                if v24 > 0 then
                    v25 = trainingWeightOrder[v24]

                    if v16[v25] == nil then
                        v26 = trainingWeightsData[v25]

                        if v26 ~= nil then
                            v26 = v26.name
                        end

                        if v26 ~= nil then
                            v25 = v26
                        end

                        v8.onScreenFeedbackAdded({
                            type = "error",
                            id = HttpService:GenerateGUID(false),
                            message = ("You must unlock \"%*\" first!"):format(v25)
                        })

                        return nil
                    end
                end

                if v11 < v23 then
                    v8.onScreenFeedbackAdded({
                        message = "Not enough money!",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                    promptCashPurchase(v23, v12)

                    return nil
                end

                functions.purchaseShopItem("weightsShop", p6.key):andThen(function(p8) -- line: 171
                    -- upvalues: p6 (copy), v8 (copy), v13 (copy), playSound (copy), HttpService (copy), tutorialSteps (copy)
                    if p8 then
                        playSound()
                        v8.onScreenFeedbackAdded({
                            type = "success",
                            id = HttpService:GenerateGUID(false),
                            message = ("%* purchased!"):format(p6.name)
                        })

                        if v13 == tutorialSteps.goToWeightsShop then
                            v8.tutorialStepUpdated({
                                step = tutorialSteps.trainPower
                            })
                        end
                    end
                end)
            end

            t6.onBuyWithRobux = function() -- line: 187
                -- upvalues: p6 (copy), promptProductPurchaseWithExtraInfo (copy), getTrainingWeightProductId (copy)
                local v27 = getTrainingWeightProductId(p6.key)

                if v27 == nil then
                    return nil
                end

                promptProductPurchaseWithExtraInfo(v27, {
                    kind = "trainingWeight",
                    weightId = p6.key
                })
            end

            t6.onEquip = function() -- line: 197
                -- upvalues: p6 (copy), v9 (copy), functions (copy)
                local key = p6.key
                local itemId

                if v9 then
                    local v28 = false

                    for _, v29 in v9 do
                        if v29.itemType == "trainingWeight" and v29.itemName == key then
                            itemId = v29.itemId
                            v28 = true
                            break
                        end
                    end

                    if not v28 then
                        itemId = nil
                    end
                end

                if itemId ~= nil then
                    functions.setEquipmentInToolbar(itemId)
                end
            end

            t6.playerRebirthCount = v10
            t6.power = p6.power
            t6.price = v23
            t6.rarity = p6.rarity
            t6.rebirthRequirement = weightRebirthRequirements[p6.key]
            t6.robuxPrice = p6.robuxPrice
            t6.robuxProductId = getTrainingWeightProductId(p6.key)
            t6.showTutorialPointer = v13 == tutorialSteps.goToWeightsShop and p7 == 0
            t6.weightKg = p6.weightKg

            return react.createElement(default3, t6)
        end

        for v30, v31 in t1 do
            v20[v30] = v21(v31, v30 - 1, t1)
        end

        return react.createElement(default, {
            aspectRatio = 1.4,
            title = "Weights Shop",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
                ColorSequenceKeypoint.new(0.457686, Color3.fromRGB(41, 240, 10)),
                ColorSequenceKeypoint.new(0.875648, Color3.fromRGB(23, 215, 9)),
                ColorSequenceKeypoint.new(0.993092, Color3.fromRGB(8, 193, 8)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(106, 250, 11))
            }),
            onClose = p5.onClose,
            size = UDim2.fromScale(0.8, 0.55)
        }, react.createElement(default2, {
            cellsPerRow = 1,
            listPaddingOffset = 16,
            rowsToBeVisible = 2.5,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            fillDirection = Enum.FillDirection.Vertical,
            padding = {
                all = UDim.new(0, 16)
            },
            position = UDim2.fromScale(0.5, 0.95),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            scrollBarThickness = v15,
            size = UDim2.fromScale(0.97, 0.85)
        }, v20))
    end
}

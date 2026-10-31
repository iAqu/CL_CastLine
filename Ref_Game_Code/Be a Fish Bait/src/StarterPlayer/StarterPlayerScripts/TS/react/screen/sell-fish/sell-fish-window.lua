-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useBindingListener = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useBindingListener
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo, useState = react.useMemo, react.useState
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerInventory, selectEquippedBaitAuraName = selectors.selectPlayerInventory, selectors.selectEquippedBaitAuraName
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default5 = RuntimeLib.import(script, script.Parent, "sell-fish-card").default
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local getBaitAuraBuffBonuses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils").getBaitAuraBuffBonuses
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "double-rewards-event-utils")
local doubleRewardsEventCashMultiplier, doubleRewardsEventEndTimestamp, isDoubleRewardsEventActive = v1.doubleRewardsEventCashMultiplier, v1.doubleRewardsEventEndTimestamp, v1.isDoubleRewardsEventActive
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 40, 40))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 40, 130))
})
local v4 = Color3.fromRGB(140, 20, 80)
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 190, 50))
})

local function getFishSellPrice(p1, p2) -- line: 41
    -- upvalues: fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy)
    local v6 = if p2 == nil then 1 else p2
    local v7 = fishDataByName[p1.itemName]

    if not (v7 and isFishData(v7)) then
        return 0
    end

    return (math.floor(getMutatedMoneyPerSecond(v7.moneyPerSecond, p1.level, p1.mutations) * v6))
end

return {
    default = function(p3) -- SellFishWindow | line: 52
        -- upvalues: useBindingListener (copy), react (copy), useMemo (copy), useState (copy), Workspace (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useRootProducer (copy), useRootSelector (copy), useTheme (copy), useScreenSizeState (copy), functions (copy), localPlayerUserId (copy), selectPlayerInventory (copy), selectEquippedBaitAuraName (copy), fishDataByName (copy), isFishData (copy), abbreviate (copy), HttpService (copy), default5 (copy), getMutatedMoneyPerSecond (copy), getExclusiveFishConfigByFishName (copy), getBaitAuraBuffBonuses (copy), default6 (copy), doubleRewardsEventCashMultiplier (copy), doubleRewardsEventEndTimestamp (copy), isDoubleRewardsEventActive (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
        local v9 = useTheme()
        local v10 = useRootProducer()
        local v11 = useScreenSizeState()
        local v12 = if v11 == "sm" then 4 elseif v11 == "md" then 7 else 10
        local v13 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local sellValueMultiplier = getBaitAuraBuffBonuses((useRootSelector(selectEquippedBaitAuraName(localPlayerUserId)))).sellValueMultiplier
        local rawSecondsLeftInfo = default6(doubleRewardsEventEndTimestamp).rawSecondsLeftInfo
        local v15, v16 = useState(isDoubleRewardsEventActive(Workspace:GetServerTimeNow()))

        useBindingListener(rawSecondsLeftInfo, function(p4) -- line: 63
            -- upvalues: v16 (copy), Workspace (copy), isDoubleRewardsEventActive (copy)
            local v17 = if p4 == nil then p4 else p4.timeNow

            if v17 == nil then
                v17 = Workspace:GetServerTimeNow()
            end

            v16(isDoubleRewardsEventActive(v17))
        end)

        local v18 = if v15 then doubleRewardsEventCashMultiplier else 1
        local v19 = useMemo(function() -- line: 75
            -- upvalues: v13 (copy), sellValueMultiplier (copy), v18 (copy), fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy), getExclusiveFishConfigByFishName (copy)
            if not v13 then
                return {}
            end

            local t1 = {}

            for _, v20 in v13 do
                if v20.itemType == "fish" and v20.exclusiveIndex == nil and not getExclusiveFishConfigByFishName(v20.itemName) then
                    local v21 = fishDataByName[v20.itemName]

                    if v21 and isFishData(v21) then
                        local t2 = {
                            imageId = v21.imageId,
                            itemId = v20.itemId,
                            level = v20.level,
                            name = v21.displayName,
                            rarity = v21.rarity
                        }
                        local v22 = sellValueMultiplier * v18

                        if v22 == nil then
                            v22 = 1
                        end

                        local v23 = fishDataByName[v20.itemName]

                        t2.sellPrice = if v23 and isFishData(v23) then math.floor(getMutatedMoneyPerSecond(v23.moneyPerSecond, v20.level, v20.mutations) * v22) else 0
                        table.insert(t1, t2)
                    end
                end
            end

            table.sort(t1, function(p5, p6) -- line: 102
                return p5.sellPrice > p6.sellPrice
            end)

            return t1
        end, { v18, v13, sellValueMultiplier })
        local v25 = useMemo(function() -- line: 107
            -- upvalues: v19 (copy)
            local function v26(p7, p8) -- line: 110
                return p7 + p8.sellPrice
            end

            local n1 = 0

            for i = 1, #v19 do
                local v28 = v19[i]
                local _ = i - 1

                n1 += v28.sellPrice
            end

            return n1
        end, { v19 })

        local function v29(p9) -- line: 119
            -- upvalues: v10 (copy), functions (copy), abbreviate (copy), HttpService (copy)
            functions.sellFishItems({ p9 }):andThen(function(p10) -- line: 120
                -- upvalues: v10 (copy), abbreviate (copy), HttpService (copy)
                if p10 ~= false then
                    v10.onScreenFeedbackAdded({
                        type = "success",
                        id = HttpService:GenerateGUID(false),
                        message = ("Sold for $%*!"):format((abbreviate(p10)))
                    })
                end
            end)
        end

        local function v30() -- line: 130
            -- upvalues: v10 (copy), v19 (copy), functions (copy), abbreviate (copy), HttpService (copy)
            local v31 = table.create(#v19)

            local function v32(p11) -- line: 133
                return p11.itemId
            end

            for v33, v34 in v19 do
                local _ = v33 - 1

                v31[v33] = v34.itemId
            end

            if #v31 == 0 then
                return nil
            end

            functions.sellFishItems(v31):andThen(function(p12) -- line: 144
                -- upvalues: v10 (copy), abbreviate (copy), HttpService (copy)
                if p12 ~= false then
                    v10.onScreenFeedbackAdded({
                        type = "success",
                        id = HttpService:GenerateGUID(false),
                        message = ("Sold all for $%*!"):format((abbreviate(p12)))
                    })
                end
            end)
        end

        local v35 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.14),
            Size = UDim2.fromScale(0.95, 0.13)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 3,
            Size = UDim2.fromScale(0.32, 1)
        }, react.createElement(default2, {
            text = "Total Price:",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v9.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 3,
            Size = UDim2.fromScale(0.3, 1)
        }, react.createElement(default2, {
            color = v5,
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v9.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = ("$%*"):format((abbreviate(v25)))
        })), react.createElement(default3, {
            isStudded = true,
            label = "Sell All $",
            layoutOrder = 3,
            zIndex = 3,
            anchorPoint = Vector2.new(0, 0.5),
            color = v3,
            font = v9.textFont2,
            frameSize = UDim2.fromScale(0.28, 0.85),
            onClick = v30,
            popoutColor = v4,
            position = UDim2.fromScale(0, 0.5)
        }))
        local v36 = table.create(#v19)

        local function v37(p13, p14) -- line: 214
            -- upvalues: v29 (copy), react (copy), default5 (copy)
            return react.createElement(default5, {
                imageId = p13.imageId,
                itemId = p13.itemId,
                key = p13.itemId,
                layoutOrder = p14,
                level = p13.level,
                name = p13.name,
                onSell = function() -- onSell | line: 222
                    -- upvalues: p13 (copy), v29 (copy)
                    return v29(p13.itemId)
                end,
                rarity = p13.rarity,
                sellPrice = p13.sellPrice
            })
        end

        for v38, v39 in v19 do
            v36[v38] = v37(v39, v38 - 1, v19)
        end

        return react.createElement(default, {
            aspectRatio = 1.35,
            title = "Sell Fishes",
            bodyBg = Color3.fromRGB(18, 18, 22),
            headerBg = v2,
            onClose = p3.onClose,
            size = UDim2.fromScale(0.75, 0.6)
        }, v35, react.createElement(default4, {
            cellsPerRow = 3,
            listPaddingOffset = 10,
            rowsToBeVisible = 1.5,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            fillDirection = Enum.FillDirection.Horizontal,
            padding = {
                all = UDim.new(0, 10)
            },
            position = UDim2.fromScale(0.5, 0.99),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            scrollBarThickness = v12,
            size = UDim2.fromScale(0.97, 0.68)
        }, v36))
    end
}

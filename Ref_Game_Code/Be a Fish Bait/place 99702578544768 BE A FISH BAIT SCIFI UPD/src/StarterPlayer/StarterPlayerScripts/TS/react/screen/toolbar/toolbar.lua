-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local default = RuntimeLib.import(script, script.Parent, "toolbar-item").default
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local trainingWeightsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "training-weights").trainingWeightsData
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v1 = RuntimeLib.import(script, script.Parent, "toolbar-drag-drop")
local dispatchToolbarDrop, registerToolbarDropZone = v1.dispatchToolbarDrop, v1.registerToolbarDropZone
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel, showcaseFishToMpsInput = v2.getAquariumFishEffectiveMoneyPerSecond, v2.getExclusiveFishEditionLabel, v2.showcaseFishToMpsInput
local v3 = RuntimeLib.import(script, script.Parent, "toolbar-metrics")
local getToolbarMetrics, getToolbarSlotCount = v3.getToolbarMetrics, v3.getToolbarSlotCount
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumFishItems, selectPlayerGamepasses, selectPlayerInventory, selectPlayerShowcaseFish = selectors.selectPlayerAquariumFishItems, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory, selectors.selectPlayerShowcaseFish
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId

local function v4(p1, p2) -- line: 36
    -- upvalues: fishDataByName (copy), fishingRodsData (copy), trainingWeightsData (copy)
    if p2 == "fishingRod" then
        if fishingRodsData[p1] == nil then
            return "Item"
        end

        return p1
    end

    if p2 == "trainingWeight" then
        local v5 = trainingWeightsData[p1]

        if v5 ~= nil then
            v5 = v5.name
        end

        if v5 == nil then
            v5 = p1
        end

        return v5
    end

    if p2 == "slapWeapon" then
        return "Slap"
    end

    if p2 == "fish" then
        local v6 = fishDataByName[p1]

        if v6 ~= nil then
            v6 = v6.displayName
        end

        if v6 == nil then
            v6 = p1
        end

        return v6
    end

    if p2 == "emote" then
        return p1
    end

    return "Item"
end

local function v7(p3) -- line: 73
    -- upvalues: fishDataByName (copy), fishingRodsData (copy), trainingWeightsData (copy)
    local itemType, itemName = p3.itemType, p3.itemName

    if itemType == "fishingRod" then
        local v8 = fishingRodsData[itemName]

        if v8 ~= nil then
            v8 = v8.imageId
        end

        if v8 == nil then
            v8 = ""
        end

        return v8
    end

    if itemType == "trainingWeight" then
        local v9 = trainingWeightsData[itemName]

        if v9 ~= nil then
            v9 = v9.imageId
        end

        if v9 == nil then
            v9 = ""
        end

        return v9
    end

    if itemType == "fish" then
        local v10 = fishDataByName[itemName]

        if v10 ~= nil then
            v10 = v10.imageId
        end

        if v10 == nil then
            v10 = ""
        end

        return v10
    end

    if itemType == "emote" then
        return p3.imageId
    end

    if itemType == "slapWeapon" then
        return "rbxassetid://84549113530407"
    end

    return ""
end

local function v11(p4) -- line: 117
    -- upvalues: fishDataByName (copy), isFishData (copy), fishingRodsData (copy), trainingWeightsData (copy)
    if p4.itemType == "fish" then
        local v12 = fishDataByName[p4.itemName]

        return if v12 ~= nil and isFishData(v12) then v12.rarity else nil
    end

    if p4.itemType == "fishingRod" then
        local v13 = fishingRodsData[p4.itemName]

        if v13 ~= nil then
            v13 = v13.rarity
        end

        return v13
    end

    if p4.itemType ~= "trainingWeight" then
        return nil
    end

    local v14 = trainingWeightsData[p4.itemName]

    if v14 ~= nil then
        v14 = v14.rarity
    end

    return v14
end

local function v15(p5, p6, p7, p8, p9) -- line: 141
    -- upvalues: fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishConfigByFishName (copy)
    if p5.itemType ~= "fish" then
        return nil
    end

    local v16 = fishDataByName[p5.itemName]

    if v16 == nil or not isFishData(v16) then
        return nil
    end

    if getExclusiveFishConfigByFishName(p5.itemName) == nil then
        return getMutatedMoneyPerSecond(v16.moneyPerSecond, p5.level, p5.mutations)
    end

    return getAquariumFishEffectiveMoneyPerSecond({
        fishId = p5.itemId,
        fishSpecies = p5.itemName,
        level = p5.level,
        mutations = p5.mutations
    }, p6 or {}, p7, nil, 0, p8, p9)
end

local function v17(p10) -- line: 161
    -- upvalues: fishingRodsData (copy)
    local v18 = p10.itemType == "fishingRod"
    local v19 = if v18 then fishingRodsData[p10.itemName] else nil

    return if v18 and v19 then {
        powerCap = v19.powerCap
    } else nil
end

return {
    default = function(p11) -- Toolbar | line: 173
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useRootSelector (copy), default (copy), default2 (copy), default3 (copy), fishingRodsData (copy), useScreenSizeState (copy), dispatchToolbarDrop (copy), registerToolbarDropZone (copy), getExclusiveFishEditionLabel (copy), showcaseFishToMpsInput (copy), getToolbarMetrics (copy), getToolbarSlotCount (copy), selectPlayerAquariumFishItems (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerShowcaseFish (copy), localPlayerUserId (copy), v4 (copy), v7 (copy), v11 (copy), v15 (copy)
        local v20 = useRootSelector(selectPlayerAquariumFishItems(localPlayerUserId))
        local v21 = useRootSelector(selectPlayerGamepasses(localPlayerUserId))
        local v22 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v24 = showcaseFishToMpsInput((useRootSelector(selectPlayerShowcaseFish(localPlayerUserId))))
        local v25 = useScreenSizeState()
        local v26 = v25 == "sm" or v25 == "md"
        local v27 = getToolbarSlotCount(v26)
        local v28 = if v26 then 52 else 72
        local v29 = getToolbarMetrics(v26)
        local buttonHeight, buttonWidth, toolbarHeight, toolbarWidth = v29.buttonHeight, v29.buttonWidth, v29.toolbarHeight, v29.toolbarWidth
        local unitHeight = v29.unitHeight
        local v30 = buttonHeight / unitHeight
        local v31 = buttonWidth / toolbarWidth
        local v32 = toolbarHeight / unitHeight
        local v33 = useRef({})
        local v34 = useRef()
        local v35, v36 = useState(nil)

        local function v37(p12) -- line: 198
            -- upvalues: p11 (copy)
            if p11.onItemClick then
                p11.onItemClick(p12)
            end
        end

        local t1 = {}
        local n1 = 0
        local v38 = false

        while true do
            if v38 then
                n1 += 1
            else
                v38 = true
            end

            if n1 < v27 then
                table.insert(t1, n1)
                continue
            end

            break
        end

        useEffect(function() -- line: 220
            -- upvalues: p11 (copy), v33 (copy), t1 (copy), registerToolbarDropZone (copy)
            local v39 = table.create(#t1)

            local function v40(p13) -- line: 223
                -- upvalues: p11 (copy), v33 (copy), registerToolbarDropZone (copy)
                return registerToolbarDropZone({
                    getObject = function() -- getObject | line: 225
                        -- upvalues: p13 (copy), v33 (copy)
                        return v33.current[p13 + 1]
                    end,
                    onDrop = function(p14) -- onDrop | line: 228
                        -- upvalues: p13 (copy), p11 (copy)
                        local onFishDroppedOnToolbar = p11.onFishDroppedOnToolbar

                        if onFishDroppedOnToolbar ~= nil then
                            onFishDroppedOnToolbar = onFishDroppedOnToolbar(p14, p13)
                        end

                        return onFishDroppedOnToolbar
                    end
                })
            end

            for v41, v42 in t1 do
                v39[v41] = v40(v42, v41 - 1, t1)
            end

            return function() -- line: 242
                -- upvalues: v39 (copy)
                for _, v43 in v39 do
                    v43()
                end
            end
        end, {
            v27,
            p11.onFishDroppedOnToolbar
        })

        local function v44(p15, p16) -- line: 262
            -- upvalues: v36 (copy), dispatchToolbarDrop (copy)
            v36(nil)
            dispatchToolbarDrop(p15, p16)
        end

        local v45 = not p11.isBackpackOpen

        v45 = v45 and react.createElement("textbutton", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0),
            Event = {
                Activated = function() -- Activated | line: 271
                    -- upvalues: p11 (copy)
                    local onBackpackClick = p11.onBackpackClick

                    if onBackpackClick ~= nil then
                        onBackpackClick = onBackpackClick()
                    end

                    return onBackpackClick
                end
            },
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(v31, v30)
        }, react.createElement(default3, {
            backgroundTransparency = 0.7,
            zIndex = 1,
            size = UDim2.fromScale(1, 1.3)
        }), react.createElement(default2, {
            hasStroke = true,
            overrideProps = {
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = v26 and "- Tap to open Backpack -" or "- [G] Open Backpack -",
            textColor3 = Color3.new(1, 1, 1)
        }))

        local v47 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.6867777777777777 * v27
        })
        local v48 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v49 = table.create(#t1)

        local function v50(p17) -- line: 311
            -- upvalues: p11 (copy), v20 (copy), v21 (copy), v22 (copy), v24 (copy), v33 (copy), v34 (copy), v36 (copy), v37 (copy), v44 (copy), react (copy), default (copy), fishingRodsData (copy), getExclusiveFishEditionLabel (copy), v4 (copy), v7 (copy), v11 (copy), v15 (copy)
            local v51 = p11.activeItems[p17 + 1]

            if v51 ~= nil and v51 ~= false then
                local v52

                if v51.itemType == "fishingRod" then
                    local v53 = fishingRodsData[v51.itemName]

                    if v53 then
                        v52 = {
                            powerCap = v53.powerCap
                        }
                    end
                end

                local v54 = react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1
                })
                local t6 = {
                    equipped = v51.isEquipped,
                    exclusiveEditionLabel = if v51.itemType == "fish" then getExclusiveFishEditionLabel(v51.itemName, v51.exclusiveIndex) else nil,
                    imageId = v7(v51)
                }
                local selectedItemIdsForTrash = p11.selectedItemIdsForTrash

                if selectedItemIdsForTrash ~= nil then
                    local itemId = v51.itemId

                    selectedItemIdsForTrash = table.find(selectedItemIdsForTrash, itemId) ~= nil
                end

                t6.isSelectedForTrash = selectedItemIdsForTrash
                t6.itemId = v51.itemId
                t6.itemType = v51.itemType
                t6.moneyPerSecond = v15(v51, v20, v21, v22, v24)
                t6.mutations = if v51.itemType == "fish" then v51.mutations else nil
                t6.name = v4(v51.itemName, v51.itemType)

                t6.onClick = function() -- line: 334
                    -- upvalues: p17 (copy), v37 (copy)
                    return v37(p17)
                end

                t6.onDragEnd = v44

                t6.onDragMove = function(p18) -- line: 338
                    -- upvalues: v34 (copy), v36 (copy)
                    return v36(function(p19) -- line: 339
                        -- upvalues: p18 (copy), v34 (copy)
                        if p19 == nil then
                            return nil
                        end

                        local v55 = table.clone(p19)

                        setmetatable(v55, nil)

                        local v56 = p18
                        local current = v34.current

                        v55.position = if current ~= nil then p18 - current.AbsolutePosition else v56

                        return v55
                    end)
                end

                t6.onDragStart = function(p20, p21, p22) -- line: 352
                    -- upvalues: v34 (copy), v36 (copy)
                    local t7 = {
                        imageId = p21,
                        itemId = p20
                    }
                    local current = v34.current

                    t7.position = if current == nil then p22 else p22 - current.AbsolutePosition

                    return v36(t7)
                end

                t6.powerCap = if v52 ~= nil then v52.powerCap else v52
                t6.rarity = v11(v51)

                local shouldShowTutorialPointerForSlot = p11.shouldShowTutorialPointerForSlot

                t6.shouldShowTutorialPointer = if shouldShowTutorialPointerForSlot ~= nil then shouldShowTutorialPointerForSlot(p17) else shouldShowTutorialPointerForSlot
                t6.sizeScale = 1
                t6.slotNumber = p17 + 1

                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = p17 + 1,
                    Size = UDim2.fromScale(1.5, 1.5),
                    key = ("toolbar-item-%*"):format(p17),
                    ref = function(p23) -- ref | line: 377
                        -- upvalues: p17 (copy), v33 (copy)
                        local current = v33.current
                        local v57 = p17 + 1

                        current[v57] = p23

                        return current[v57]
                    end
                }, v54, react.createElement(default, t6))
            end

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = p17 + 1,
                Size = UDim2.fromScale(1.5, 1.5),
                key = ("toolbar-slot-%*"):format(p17),
                ref = function(p24) -- ref | line: 390
                    -- upvalues: p17 (copy), v33 (copy)
                    local current = v33.current
                    local v58 = p17 + 1

                    current[v58] = p24

                    return current[v58]
                end
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }), react.createElement(default, {
                imageId = "",
                name = "",
                sizeScale = 1,
                slotNumber = p17 + 1
            }))
        end

        for v59, v60 in t1 do
            v49[v59] = v50(v60, v59 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = p11.anchorPoint or Vector2.new(0.5, 1),
            LayoutOrder = p11.layoutOrder,
            Position = p11.position or UDim2.fromScale(0.5, 0.97),
            Size = p11.size or UDim2.fromScale(toolbarWidth, unitHeight),
            ref = v34
        }, v45, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(1, v32)
        }, v47, v48, v49), v35 ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.35,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v35.imageId,
            Position = UDim2.fromOffset(v35.position.X, v35.position.Y),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(v28, v28)
        }))
    end
}

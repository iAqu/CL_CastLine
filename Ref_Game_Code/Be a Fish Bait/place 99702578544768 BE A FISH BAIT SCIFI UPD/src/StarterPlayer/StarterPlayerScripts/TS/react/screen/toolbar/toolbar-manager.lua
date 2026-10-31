-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectSortedPlayerInventory, selectToolbarSlots = selectors.selectSortedPlayerInventory, selectors.selectToolbarSlots
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "trash-mode.selectors")
local selectTrashModeEnabled, selectTrashModeSelectedItemIds = v1.selectTrashModeEnabled, v1.selectTrashModeSelectedItemIds
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local default = RuntimeLib.import(script, script.Parent, "backpack-window").default
local default2 = RuntimeLib.import(script, script.Parent, "toolbar").default
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local v2 = RuntimeLib.import(script, script.Parent, "toolbar-layout-store")
local moveToolbarItemToBackpack, moveToolbarItemToToolbarSlot, useSharedToolbarLayout = v2.moveToolbarItemToBackpack, v2.moveToolbarItemToToolbarSlot, v2.useSharedToolbarLayout
local getToolbarSlotCount = RuntimeLib.import(script, script.Parent, "toolbar-metrics").getToolbarSlotCount
local selectPlayerBackpackUpgradeCount = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerBackpackUpgradeCount
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils")
local getBackpackCapacity, maxBackpackUpgradeCount = v3.getBackpackCapacity, v3.maxBackpackUpgradeCount
local getBackpackUpgradeProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getBackpackUpgradeProductId
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local v4 = selectSortedPlayerInventory(localPlayerUserId)
local v5 = selectToolbarSlots(localPlayerUserId)

local function inventoryItemsEqual(p1, p2) -- line: 36
    if #p1 ~= #p2 then
        return false
    end

    for i = 0, #p1 - 1 do
        local v6 = p1[i + 1]
        local v7 = p2[i + 1]

        if v6.itemId ~= v7.itemId or v6.isEquipped ~= v7.isEquipped or v6.itemName ~= v7.itemName or v6.itemType ~= "fish" and v7.itemType ~= "fish" and v6.isInToolbar ~= v7.isInToolbar then
            return false
        end
    end

    return true
end

return {
    default = function(p3) -- ToolbarManager | line: 52
        -- upvalues: react (copy), useCallback (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), selectTrashModeEnabled (copy), selectTrashModeSelectedItemIds (copy), functions (copy), selectCurrentWindow (copy), default2 (copy), selectTutorialStep (copy), tutorialSteps (copy), moveToolbarItemToToolbarSlot (copy), useSharedToolbarLayout (copy), getToolbarSlotCount (copy), v4 (copy), v5 (copy), inventoryItemsEqual (copy)
        local v8 = useRootProducer()
        local v9 = useScreenSizeState()
        local v10 = v9 == "sm" or v9 == "md"
        local v13 = useSharedToolbarLayout(useRootSelector(v4, inventoryItemsEqual), useRootSelector(v5, inventoryItemsEqual), getToolbarSlotCount(v10))
        local v14 = useRootSelector(selectTrashModeEnabled)
        local v15 = useRootSelector(selectTrashModeSelectedItemIds)
        local v16 = useRootSelector(selectCurrentWindow) == "backpack"
        local v17 = useRootSelector(selectTutorialStep)
        local v18 = useCallback(function(p4) -- line: 64
            -- upvalues: v13 (copy), v17 (copy), tutorialSteps (copy)
            if v17 ~= tutorialSteps.trainPower then
                return false
            end

            local v19 = v13.toolbarSlots[p4 + 1]

            if v19 == false then
                return false
            end

            if v19.itemType == "trainingWeight" then
                return not v19.isEquipped
            end

            return false
        end, {
            v17,
            v13.toolbarSlots
        })

        local function v20() -- line: 74
            -- upvalues: p3 (copy), v8 (copy)
            if p3.onBackpackClick then
                p3.onBackpackClick()
            else
                v8.windowToggled({
                    currentWindow = "backpack"
                })
            end
        end

        local function v21(p5) -- line: 83
            -- upvalues: v8 (copy), v13 (copy), v14 (copy), functions (copy)
            local v22 = v13.toolbarSlots[p5 + 1]

            if v22 == false then
                return nil
            end

            if v14 then
                v8.itemTrashSelectionToggled({
                    itemId = v22.itemId
                })

                return nil
            end

            if v22.isEquipped then
                functions.unequipInventoryItem(v22.itemId)
            else
                functions.equipInventoryItem(v22.itemId)
            end
        end

        local function v23(p6, p7) -- line: 100
            -- upvalues: v13 (copy), functions (copy), moveToolbarItemToToolbarSlot (copy)
            local v24 = false

            for _, v25 in v13.toolbarSlots do
                if v25 ~= false and v25.itemId == p6 then
                    v24 = true
                    break
                end
            end

            if not v24 and v13.toolbarSlots[p7 + 1] ~= false then
                return nil
            end

            moveToolbarItemToToolbarSlot(p6, p7)

            local t1 = {}
            local v26 = #v13.toolbarSlots - 1
            local n1 = 0

            for i = 0, v26 do
                local v27 = v13.toolbarSlots[i + 1]
                local v29
                local v28 = n1

                if v27 == false then
                elseif v27.itemType == "fish" then
                    v29 = if i < p7 then n1 + 1 else n1
                    v28 = v29

                    if v27.itemId ~= p6 then
                        table.insert(t1, v27.itemId)
                    end
                end

                n1 = v28
            end

            table.insert(t1, n1 + 1, p6)
            functions.rearrangeFishInToolbar(t1)
        end

        return react.createElement(react.Fragment, nil, react.createElement(default2, {
            activeItems = v13.toolbarSlots,
            anchorPoint = p3.anchorPoint,
            isBackpackOpen = v16,
            layoutOrder = p3.layoutOrder,
            onBackpackClick = v20,
            onFishDroppedOnToolbar = v23,
            onItemClick = v21,
            position = p3.position,
            selectedItemIdsForTrash = v15,
            shouldShowTutorialPointerForSlot = v18,
            size = p3.size
        }))
    end,
    BackpackWindowManager = function() -- BackpackWindowManager | line: 147
        -- upvalues: react (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), localPlayerUserId (copy), functions (copy), default (copy), moveToolbarItemToBackpack (copy), useSharedToolbarLayout (copy), getToolbarSlotCount (copy), selectPlayerBackpackUpgradeCount (copy), getBackpackCapacity (copy), maxBackpackUpgradeCount (copy), getBackpackUpgradeProductId (copy), attemptStorePurchase (copy), v4 (copy), v5 (copy), inventoryItemsEqual (copy)
        local v31 = useRootProducer()
        local v32 = useScreenSizeState()
        local v33 = v32 == "sm" or v32 == "md"
        local v36 = useSharedToolbarLayout(useRootSelector(v4, inventoryItemsEqual), useRootSelector(v5, inventoryItemsEqual), getToolbarSlotCount(v33))
        local backpackItems = v36.backpackItems
        local n2 = 0

        for _, v37 in v36.toolbarSlots do
            if v37 ~= false and v37.itemType == "fish" then
                n2 += 1
            end
        end

        local v38 = #backpackItems + n2
        local v39 = useRootSelector(selectPlayerBackpackUpgradeCount(localPlayerUserId))
        local v40 = getBackpackCapacity(v39)
        local v41 = getBackpackUpgradeProductId(v39)

        local function v42() -- line: 165
            -- upvalues: v31 (copy), v41 (copy), localPlayerUserId (copy), attemptStorePurchase (copy)
            if v41 == nil or v41 == 0 then
                v31.backpackCapacityUpgraded({
                    userId = localPlayerUserId
                })

                return nil
            end

            attemptStorePurchase(v41)
        end

        local function v43(p8) -- line: 174
            -- upvalues: backpackItems (copy), functions (copy)
            local v44

            for v45, v46 in backpackItems do
                local _ = v45 - 1

                if v46.itemId == p8 == true then
                    v44 = v46
                    break
                end

                v44 = nil
            end

            if v44 == nil then
                return nil
            end

            if v44.isEquipped then
                functions.unequipInventoryItem(v44.itemId)
            else
                functions.equipInventoryItem(v44.itemId)
            end
        end

        local function v47(p9) -- line: 197
            -- upvalues: v36 (copy), functions (copy), moveToolbarItemToBackpack (copy)
            moveToolbarItemToBackpack(p9)

            local t2 = {}

            for _, v48 in v36.toolbarSlots do
                if v48 ~= false and v48.itemType == "fish" and v48.itemId ~= p9 then
                    table.insert(t2, v48.itemId)
                end
            end

            functions.rearrangeFishInToolbar(t2)
        end

        local createElement = react.createElement
        local t3 = {
            showMountsTab = true,
            excessItems = backpackItems,
            maxItemCount = v40,
            onClose = function() -- onClose | line: 211
                -- upvalues: v31 (copy)
                v31.windowClosed({})
                v31.trashModeDisabled({})
            end,
            onFishDroppedInBackpack = v47,
            onItemClick = v43
        }

        if not (v39 < maxBackpackUpgradeCount) then
            v42 = nil
        end

        t3.onUpgradeClick = v42
        t3.totalBackpackFishCount = v38

        return createElement(default, t3)
    end
}

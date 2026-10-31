-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local emoteDefinitions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "emotes").emoteDefinitions
local selectEquippedEmoteId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedEmoteId
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent, "backpack-window").default
local default2 = RuntimeLib.import(script, script.Parent, "toolbar").default
local getToolbarSlotCount = RuntimeLib.import(script, script.Parent, "toolbar-metrics").getToolbarSlotCount
local v1 = RuntimeLib.import(script, script.Parent, "celebration-toolbar-utils")
local findFirstCelebrationHotbarEmote, selectLocalCelebrationToolbarSlots, splitCelebrationToolbarSlots, swapCelebrationBackpackEmote = v1.findFirstCelebrationHotbarEmote, v1.selectLocalCelebrationToolbarSlots, v1.splitCelebrationToolbarSlots, v1.swapCelebrationBackpackEmote
local toggleCelebrationSlotEquip = v1.toggleCelebrationSlotEquip

local function celebrationSlotsEqual(p1, p2) -- line: 21
    if #p1 ~= #p2 then
        return false
    end

    for i = 0, #p1 - 1 do
        local v2 = p1[i + 1]
        local v3 = p2[i + 1]

        if v2.itemId ~= v3.itemId or v2.isEquipped ~= v3.isEquipped or v2.itemName ~= v3.itemName then
            return false
        end
    end

    return true
end

return {
    default = function(p3) -- CelebrationToolbarManager | line: 40
        -- upvalues: react (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), selectCurrentWindow (copy), default2 (copy), getToolbarSlotCount (copy), selectLocalCelebrationToolbarSlots (copy), splitCelebrationToolbarSlots (copy), toggleCelebrationSlotEquip (copy), celebrationSlotsEqual (copy)
        local v4 = useRootProducer()
        local v5 = useScreenSizeState()
        local v7 = getToolbarSlotCount(v5 == "sm" or v5 == "md")
        local v8 = useRootSelector(selectLocalCelebrationToolbarSlots, celebrationSlotsEqual)
        local v9 = useRootSelector(selectCurrentWindow) == "backpack"
        local toolbarSlots = splitCelebrationToolbarSlots(v8, v7).toolbarSlots

        local function v10() -- line: 49
            -- upvalues: p3 (copy), v4 (copy)
            if p3.onBackpackClick then
                p3.onBackpackClick()
            else
                v4.windowToggled({
                    currentWindow = "backpack"
                })
            end
        end

        local function v11(p4) -- line: 58
            -- upvalues: toolbarSlots (copy), toggleCelebrationSlotEquip (copy)
            local v12 = toolbarSlots[p4 + 1]

            if v12 == false then
                return nil
            end

            toggleCelebrationSlotEquip(v12)
        end

        return react.createElement(default2, {
            activeItems = toolbarSlots,
            anchorPoint = p3.anchorPoint,
            isBackpackOpen = v9,
            layoutOrder = p3.layoutOrder,
            onBackpackClick = v10,
            onItemClick = v11,
            position = p3.position,
            size = p3.size
        })
    end,
    CelebrationBackpackWindowManager = function() -- CelebrationBackpackWindowManager | line: 81
        -- upvalues: react (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), emoteDefinitions (copy), selectEquippedEmoteId (copy), localPlayerUserId (copy), default (copy), getToolbarSlotCount (copy), findFirstCelebrationHotbarEmote (copy), selectLocalCelebrationToolbarSlots (copy), splitCelebrationToolbarSlots (copy), swapCelebrationBackpackEmote (copy), celebrationSlotsEqual (copy)
        local v13 = useRootProducer()
        local v14 = useScreenSizeState()
        local v16 = getToolbarSlotCount(v14 == "sm" or v14 == "md")
        local v18 = splitCelebrationToolbarSlots(useRootSelector(selectLocalCelebrationToolbarSlots, celebrationSlotsEqual), v16)
        local excessItems, toolbarSlots = v18.excessItems, v18.toolbarSlots
        local v19 = useRootSelector(selectEquippedEmoteId(localPlayerUserId))

        local function v20(p5) -- line: 91
            -- upvalues: excessItems (copy), toolbarSlots (copy), v19 (copy), findFirstCelebrationHotbarEmote (copy), swapCelebrationBackpackEmote (copy)
            local v21

            for v22, v23 in excessItems do
                local _ = v22 - 1

                if v23.itemId == p5 == true then
                    v21 = v23
                    break
                end

                v21 = nil
            end

            local v24, v25

            if v21 ~= nil then
                if v21.itemType == "emote" then
                    v24 = v19

                    if v19 == nil then
                        v24 = findFirstCelebrationHotbarEmote(toolbarSlots)

                        if v24 ~= nil then
                            v24 = v24.itemId
                        end
                    end

                    v25 = false
                else
                    v25 = true
                end
            else
                v25 = true
            end

            if v25 or v24 == nil then
                return nil
            end

            swapCelebrationBackpackEmote(v21.itemId, v24, true)
        end

        return react.createElement(default, {
            emptyMessage = "All your emotes fit on the toolbar!",
            title = "Stored Emotes",
            excessItems = excessItems,
            maxItemCount = #emoteDefinitions,
            onClose = function() -- onClose | line: 126
                -- upvalues: v13 (copy)
                return v13.windowClosed({})
            end,
            onItemClick = v20,
            totalBackpackFishCount = #excessItems
        })
    end
}

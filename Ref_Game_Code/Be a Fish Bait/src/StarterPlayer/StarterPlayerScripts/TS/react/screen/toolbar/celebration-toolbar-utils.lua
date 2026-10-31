-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectCelebrationToolbarSlots(localPlayerUserId)

return {
    splitCelebrationToolbarSlots = function(p1, p2) -- splitCelebrationToolbarSlots | line: 11
        local t1 = {}
        local n1 = 0
        local v2 = false

        while true do
            if v2 then
                n1 += 1
            else
                v2 = true
            end

            if n1 < p2 then
                table.insert(t1, p1[n1 + 1] or false)
                continue
            end

            break
        end

        local t2 = {}
        local v4 = p2
        local v5 = false

        while true do
            if v5 then
                v4 += 1
            else
                v5 = true
            end

            if v4 < #p1 then
                table.insert(t2, p1[v4 + 1])
                continue
            end

            break
        end

        return {
            excessItems = t2,
            toolbarSlots = t1
        }
    end,
    findFirstCelebrationHotbarEmote = function(p3) -- findFirstCelebrationHotbarEmote | line: 51
        for _, v7 in p3 do
            if v7 ~= false and v7.itemType == "emote" then
                return v7
            end
        end

        return nil
    end,
    toggleCelebrationSlotEquip = function(p4) -- toggleCelebrationSlotEquip | line: 65
        -- upvalues: functions (copy)
        if p4.itemType == "emote" then
            if p4.isEquipped then
                functions.unequipEmote(p4.itemId)
            else
                functions.equipEmote(p4.itemId)
            end

            return nil
        end

        if p4.isEquipped then
            functions.unequipInventoryItem(p4.itemId)
        else
            functions.equipInventoryItem(p4.itemId)
        end
    end,
    equipCelebrationSlotItem = function(p5) -- equipCelebrationSlotItem | line: 84
        -- upvalues: functions (copy)
        if p5.itemType == "emote" then
            functions.equipEmote(p5.itemId)
        else
            functions.equipInventoryItem(p5.itemId)
        end
    end,
    swapCelebrationBackpackEmote = function(p6, p7, p8) -- swapCelebrationBackpackEmote | line: 95
        -- upvalues: functions (copy)
        functions.swapEmoteWithBackpack(p6, p7, p8)
    end,
    selectLocalCelebrationToolbarSlots = v1
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local maxBaitAuraSlots = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils").maxBaitAuraSlots
local v4 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 8
        p1[p2.userId] = p2.data.baitAuras or {
            equippedSlotIndex = 0,
            slots = { "", "", "" },
            unlockedSlots = { true, false, false }
        }
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 18
        p3[p4.userId] = nil
    end),
    baitAuraUnlocked = produceWrapper(function(p5, p6) -- line: 23
        -- upvalues: maxBaitAuraSlots (copy)
        local v1 = p5[p6.userId]

        if not v1 or p6.slotIndex < 0 or p6.slotIndex >= maxBaitAuraSlots then
            return nil
        end

        v1.slots[p6.slotIndex + 1] = p6.auraName
        v1.equippedSlotIndex = p6.slotIndex
    end),
    baitAuraEquipped = produceWrapper(function(p7, p8) -- line: 36
        -- upvalues: maxBaitAuraSlots (copy)
        local v2 = p7[p8.userId]

        if not v2 or p8.slotIndex < 0 or p8.slotIndex >= maxBaitAuraSlots or v2.slots[p8.slotIndex + 1] == "" then
            return nil
        end

        v2.equippedSlotIndex = p8.slotIndex
    end),
    baitAuraSlotUnlocked = produceWrapper(function(p9, p10) -- line: 51
        -- upvalues: maxBaitAuraSlots (copy)
        local v3 = p9[p10.userId]

        if not v3 or p10.slotIndex < 0 or p10.slotIndex >= maxBaitAuraSlots then
            return nil
        end

        v3.unlockedSlots[p10.slotIndex + 1] = true
    end)
})

v4:getActions()

return {
    baitAurasSlice = v4
}

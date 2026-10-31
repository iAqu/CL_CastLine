-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local filterOriginal, produceWrapper, push = v1.filterOriginal, v1.produceWrapper, v1.push
local v4 = createProducer({
    isEnabled = false,
    selectedItemIds = {}
}, {
    trashModeToggled = produceWrapper(function(p1) -- line: 13
        if p1.isEnabled then
            p1.selectedItemIds = {}
        end

        p1.isEnabled = not p1.isEnabled
    end),
    trashModeDisabled = produceWrapper(function(p2) -- line: 20
        p2.isEnabled = false
        p2.selectedItemIds = {}
    end),
    itemTrashSelectionToggled = produceWrapper(function(p3, p4) -- line: 24
        -- upvalues: filterOriginal (copy), push (copy)
        local v2 = false

        for _, v3 in p3.selectedItemIds do
            if v3 == p4.itemId then
                v2 = true
                break
            end
        end

        if v2 then
            p3.selectedItemIds = filterOriginal(p3.selectedItemIds, function(p5) -- line: 34
                -- upvalues: p4 (copy)
                return p5 ~= p4.itemId
            end)
        else
            push(p3.selectedItemIds, p4.itemId)
        end
    end),
    selectedItemsCleared = produceWrapper(function(p6) -- line: 41
        p6.selectedItemIds = {}
    end),
    trashingCompleted = produceWrapper(function(p7) -- line: 44
        p7.isEnabled = false
        p7.selectedItemIds = {}
    end)
})

v4:getActions()

return {
    trashModeSlice = v4
}

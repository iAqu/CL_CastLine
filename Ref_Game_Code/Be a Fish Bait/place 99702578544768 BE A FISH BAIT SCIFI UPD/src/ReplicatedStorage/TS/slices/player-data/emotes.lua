-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local emoteDefinitions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "emotes").emoteDefinitions
local v17 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 8
        -- upvalues: emoteDefinitions (copy)
        local t3 = {}
        local n1 = 0

        for _, v1 in p2.data.emotes do
            n1 = math.max(n1, v1.toolbarOrder + 1)
        end

        for _, v3 in emoteDefinitions do
            local v4 = p2.data.emotes[v3.emoteId]

            if v4 ~= nil then
                t3[v3.emoteId] = v4
            elseif v3.ticketPrice == nil then
                local emoteId = v3.emoteId
                local t4 = {
                    isEquipped = false,
                    timeStampAdded = 0,
                    emoteId = v3.emoteId
                }
                local v5 = n1 + 1

                t4.toolbarOrder = n1
                n1 = v5
                t3[emoteId] = t4
            end
        end

        p1[p2.userId] = t3
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 43
        p3[p4.userId] = nil
    end),
    emoteEquipped = produceWrapper(function(p5, p6) -- line: 48
        local v6 = p5[p6.userId]

        if not v6 then
            return nil
        end

        for _, v7 in v6 do
            v7.isEquipped = v7.emoteId == p6.emoteId
        end
    end),
    emoteUnequipped = produceWrapper(function(p7, p8) -- line: 59
        local v8 = p7[p8.userId]

        if not v8 then
            return nil
        end

        local v9 = v8[p8.emoteId]

        if not v9 then
            return nil
        end

        v9.isEquipped = false
    end),
    emotePurchased = produceWrapper(function(p9, p10) -- line: 73
        local v10 = p9[p10.userId]

        if not v10 or v10[p10.emoteId] ~= nil then
            return nil
        end

        local n2 = 0

        for _, v11 in v10 do
            n2 = math.max(n2, v11.toolbarOrder + 1)
        end

        v10[p10.emoteId] = {
            isEquipped = false,
            timeStampAdded = 0,
            emoteId = p10.emoteId,
            toolbarOrder = n2
        }
    end),
    emoteBackpackSwapped = produceWrapper(function(p11, p12) -- line: 97
        local v13 = p11[p12.userId]

        if not v13 then
            return nil
        end

        local v14 = v13[p12.backpackEmoteId]
        local v15 = v13[p12.targetEmoteId]

        if not v14 or not v15 then
            return nil
        end

        local toolbarOrder = v14.toolbarOrder

        v14.toolbarOrder = v15.toolbarOrder
        v15.toolbarOrder = toolbarOrder

        if not p12.equipSwappedEmote then
            return nil
        end

        for _, v16 in v13 do
            v16.isEquipped = v16.emoteId == p12.backpackEmoteId
        end
    end)
})

v17:getActions()

return {
    emotesSlice = v17
}

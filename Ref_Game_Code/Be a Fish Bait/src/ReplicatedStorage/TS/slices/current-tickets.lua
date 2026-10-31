-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    currentTicketsSlice = createProducer({}, {
        ticketSpawned = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.ticketId] = {
                isRainbow = p2.isRainbow,
                position = p2.position,
                spawnTimestamp = p2.spawnTimestamp
            }
        end),
        ticketRemoved = produceWrapper(function(p3, p4) -- line: 17
            p3[p4.ticketId] = nil
        end)
    })
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    activeSpecialEventsSlice = createProducer({}, {
        specialEventStarted = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.kind] = {
                endTimestamp = p2.endTimestamp,
                startTimestamp = p2.startTimestamp
            }
        end),
        specialEventEnded = produceWrapper(function(p3, p4) -- line: 16
            p3[p4.kind] = nil
        end)
    })
}

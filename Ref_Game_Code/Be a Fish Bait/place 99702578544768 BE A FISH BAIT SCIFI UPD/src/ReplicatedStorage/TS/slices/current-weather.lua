-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    currentWeathersSlice = createProducer({}, {
        weatherAdded = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.weather] = {
                endTimestamp = p2.endTimestamp,
                startTimestamp = p2.startTimestamp,
                weather = p2.weather
            }
        end),
        weatherEnded = produceWrapper(function(p3, p4) -- line: 17
            p3[p4.weather] = nil
        end)
    })
}

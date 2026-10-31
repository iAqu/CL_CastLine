-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    serverIssuesSlice = createProducer({}, {
        playerJoined = produceWrapper(function(p1, p2) -- line: 7
            p1[p2.userId] = {
                issue = nil
            }
        end),
        playerLeft = produceWrapper(function(p3, p4) -- line: 14
            p3[p4.userId] = nil
        end),
        playerDataLoadFailed = produceWrapper(function(p5, p6) -- line: 19
            p5[p6.userId] = {
                issue = "dataFailedToLoad"
            }
        end)
    })
}

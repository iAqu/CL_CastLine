-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    leaderboardSlice = createProducer({
        celebrationObbyRunsCompleted = {},
        celebrationReactionSticksCaught = {},
        celebrationRglRunsCompleted = {},
        money = {},
        playtime = {},
        power = {},
        totalRobuxSpent = {},
        frostwyrmCaught = {},
        uncThuluCaught = {},
        weeklyContractScore = {}
    }, {
        leaderboardUpdated = produceWrapper(function(p1, p2) -- line: 18
            p1[p2.leaderboardName] = p2.entries
        end)
    })
}

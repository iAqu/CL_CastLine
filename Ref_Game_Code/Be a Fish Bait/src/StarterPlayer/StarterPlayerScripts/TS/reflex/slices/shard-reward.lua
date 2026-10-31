-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper

return {
    shardRewardSlice = createProducer({
        pendingReward = nil
    }, {
        shardRewardReceived = produceWrapper(function(p1, p2) -- line: 9
            p1.pendingReward = {
                amount = p2.amount,
                id = p2.id,
                shardType = p2.shardType
            }
        end),
        shardRewardConsumed = produceWrapper(function(p3, p4) -- line: 16
            local pendingReward = p3.pendingReward

            if pendingReward ~= nil then
                pendingReward = pendingReward.id
            end

            if pendingReward == p4.id then
                p3.pendingReward = nil
            end
        end)
    })
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom(nil)

return {
    clearAquariumCrateReward = function(p1) -- clearAquariumCrateReward | line: 5
        -- upvalues: v1 (copy)
        local v2 = v1()

        if v2 ~= nil then
            v2 = v2.purchaseId
        end

        if v2 == p1 then
            v1(nil)
        end
    end,
    aquariumCrateRewardAtom = v1
}

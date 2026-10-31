-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local createSelector = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createSelector

return {
    selectPlaytimeRewardEligibilityData = function(p1) -- selectPlaytimeRewardEligibilityData | line: 5
        -- upvalues: createSelector (copy)
        return createSelector({
            function(p2) -- line: 6
                -- upvalues: p1 (copy)
                return p2.playerData.metadata[p1]
            end,
            function(p3) -- line: 10
                -- upvalues: p1 (copy)
                return p3.playerData.rewards[p1]
            end
        }, function(p4, p5) -- line: 14
            return if p4 ~= nil and p5 ~= nil then {
                playTimeRewardStartTime = p4.playTimeRewardStartTime,
                rewards = p5,
                savedTimeForPlaytimeReward = p4.savedTimeForPlaytimeReward,
                timeJoined = p4.timeJoined,
                timeLastSaved = p4.timeLastSaved
            } else nil
        end)
    end
}

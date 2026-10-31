-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent, "playtime-reward-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerRewards, selectPlayerMetadata = selectors.selectPlayerRewards, selectors.selectPlayerMetadata
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local playtimeRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils").playtimeRewards
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer

return {
    default = function() -- PlaytimeRewardWindowManager | line: 16
        -- upvalues: RuntimeLib (copy), react (copy), HttpService (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerRewards (copy), selectPlayerMetadata (copy), localPlayerUserId (copy), playtimeRewards (copy), functions (copy), clientProducer (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v3 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
        local t1 = {}

        for _, v4 in playtimeRewards do
            t1[v4.rewardId] = (if v2 == nil then v2 else v2[v4.rewardId]) == true
        end

        local v5 = if v3 == nil then v3 else v3.savedTimeForPlaytimeReward

        if v5 == nil then
            v5 = 0
        end

        local v6 = if v3 == nil then v3 else v3.playTimeRewardStartTime

        if v6 == nil then
            v6 = 0
        end

        if v3 ~= nil then
            v3 = v3.timeLastSaved
        end

        if v3 == nil then
            v3 = 0
        end

        local function v7(p1) -- line: 57
            -- upvalues: RuntimeLib (copy), HttpService (copy), functions (copy), clientProducer (copy)
            task.spawn(RuntimeLib.async(function() -- line: 58
                -- upvalues: p1 (copy), RuntimeLib (copy), HttpService (copy), functions (copy), clientProducer (copy)
                if RuntimeLib.await(functions.claimPlaytimeReward(p1)) == true then
                    local v8 = HttpService:GenerateGUID(false)

                    clientProducer.onScreenFeedbackAdded({
                        message = "Reward claimed!",
                        type = "success",
                        id = v8
                    })
                end
            end))
        end

        return react.createElement(default, {
            claimedRewards = t1,
            onClaim = v7,
            onClose = function() -- onClose | line: 73
                -- upvalues: v1 (copy)
                return v1.windowClosed({
                    type = "playtimeRewards"
                })
            end,
            playTimeRewardStartTime = v6,
            savedTimeForPlaytimeReward = v5,
            timeLastSaved = v3
        })
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent, "celebration-event-login-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectDayLastClaimedCelebrationReward, selectPlayerRewards = selectors.selectDayLastClaimedCelebrationReward, selectors.selectPlayerRewards
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils")
local celebrationRewards, celebrationRewardCooldownSeconds = v1.celebrationRewards, v1.celebrationRewardCooldownSeconds
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer

local function formatTimeRemaining(p1) -- line: 24
    if p1 >= 3600 then
        local v3 = math.floor(p1 / 3600)

        return (("%* hour%*"):format(v3, if v3 == 1 then "" else "s"))
    end

    if p1 >= 60 then
        local v5 = math.floor(p1 / 60)

        return (("%* min%*"):format(v5, if v5 == 1 then "" else "s"))
    end

    return (("%*s"):format(p1))
end

return {
    default = function() -- CelebrationEventLoginWindowManager | line: 35
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useMemo (copy), useState (copy), HttpService (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectDayLastClaimedCelebrationReward (copy), selectPlayerRewards (copy), localPlayerUserId (copy), celebrationRewards (copy), celebrationRewardCooldownSeconds (copy), events (copy), functions (copy), clientProducer (copy)
        local v6 = useRootProducer()
        local v7 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v8 = useRootSelector(selectDayLastClaimedCelebrationReward(localPlayerUserId))
        local v9, v10 = useState(nil)
        local v11 = useMemo(function() -- line: 40
            -- upvalues: v7 (copy), celebrationRewards (copy)
            local t1 = {}

            for _, v12 in celebrationRewards do
                local v13 = v7

                if v7 ~= nil then
                    v13 = v7[v12.rewardId]
                end

                local v14 = v13 == true

                t1[v12.rewardId] = v14
            end

            return t1
        end, { v7 })
        local v15

        if v8 then
            v15 = tonumber(v8.dailyRewardIndex)

            if v15 == nil then
                v15 = 1
            end
        else
            v15 = 1
        end

        local v16

        if not v8 or v8.day == 0 then
            v16 = true
        else
            local v17 = DateTime.fromUniversalTime(v8.year, v8.month, v8.day, 0, 0, 0)

            v16 = DateTime.now().UnixTimestamp - v17.UnixTimestamp >= celebrationRewardCooldownSeconds
        end

        useEffect(function() -- line: 73
            -- upvalues: events (copy)
            events.celebrationEventWindowOpened:fire()

            return function() -- line: 75
                -- upvalues: events (copy)
                return events.celebrationEventWindowClosed:fire()
            end
        end, {})

        local function v18(p2) -- line: 79
            -- upvalues: v10 (copy), RuntimeLib (copy), HttpService (copy), functions (copy), clientProducer (copy)
            task.spawn(RuntimeLib.async(function() -- line: 80
                -- upvalues: p2 (copy), v10 (copy), RuntimeLib (copy), HttpService (copy), functions (copy), clientProducer (copy)
                local v19 = RuntimeLib.await(functions.claimCelebrationReward(p2))
                local v20 = HttpService:GenerateGUID(false)

                if v19 == true then
                    v10(p2)
                    clientProducer.onScreenFeedbackAdded({
                        type = "success",
                        id = v20,
                        message = ("Day %* reward claimed!"):format(p2)
                    })
                elseif type(v19) == "number" and v19 > 0 then
                    local v21

                    if v19 >= 3600 then
                        local v23 = math.floor(v19 / 3600)

                        v21 = ("%* hour%*"):format(v23, if v23 == 1 then "" else "s")
                    elseif v19 >= 60 then
                        local v25 = math.floor(v19 / 60)

                        v21 = ("%* min%*"):format(v25, if v25 == 1 then "" else "s")
                    else
                        v21 = ("%*s"):format(v19)
                    end

                    clientProducer.onScreenFeedbackAdded({
                        type = "error",
                        id = v20,
                        message = ("Not available, return in %* to claim!"):format(v21)
                    })
                else
                    clientProducer.onScreenFeedbackAdded({
                        message = "Could not claim reward.",
                        type = "error",
                        id = v20
                    })
                end
            end))
        end

        return react.createElement(default, {
            canClaim = v16,
            claimableDayIndex = v15,
            claimedDayIndex = v9,
            claimedRewards = v11,
            onClaim = v18,
            onClose = function() -- onClose | line: 112
                -- upvalues: v6 (copy)
                return v6.windowClosed({})
            end
        })
    end
}

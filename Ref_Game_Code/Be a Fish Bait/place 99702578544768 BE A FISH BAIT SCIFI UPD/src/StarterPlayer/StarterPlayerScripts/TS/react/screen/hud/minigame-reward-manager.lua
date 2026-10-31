-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local selectMinigamePendingReward = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "minigame-reward.selectors").selectMinigamePendingReward
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local t1 = {
    catchSticks = "CATCH STICKS REWARD!",
    obby = "OBBY REWARD!"
}

return {
    default = function() -- MinigameRewardManager | line: 21
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), rewardPresentationQueue (copy), default (copy), selectMinigamePendingReward (copy), abbreviate (copy), images (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), t1 (copy)
        local v1 = useRootSelector(selectMinigamePendingReward)
        local v2 = useRootProducer()
        local v3 = useScreenSizeState()
        local v4 = v3 == "sm" or v3 == "md"
        local v5, v6 = useState(nil)
        local v7 = useRef(nil)

        useEffect(function() -- line: 28
            -- upvalues: v1 (copy), v2 (copy), v6 (copy), v7 (copy)
            if v1 == nil or v1.id == v7.current then
                return nil
            end

            v7.current = v1.id
            v6(v1)
            v2.minigameRewardConsumed({
                id = v1.id
            })
        end, { v1, v2 })

        if v5 == nil then
            return nil
        end

        local reward = v5.reward
        local v8 = ("+%* TICKET%*"):format(abbreviate(reward.amount), if reward.amount > 1 then "S" else "")

        return react.createElement(default, {
            zIndex = 200,
            iconImage = images.celebrationTicket,
            onFinished = function() -- onFinished | line: 46
                -- upvalues: v5 (copy), v6 (copy), rewardPresentationQueue (copy)
                local id = v5.id

                v6(nil)
                rewardPresentationQueue:presentationFinished(id)
            end,
            rewardText = v8,
            title = t1[reward.source],
            uiScale = v4 and 0.78 or 1
        })
    end
}

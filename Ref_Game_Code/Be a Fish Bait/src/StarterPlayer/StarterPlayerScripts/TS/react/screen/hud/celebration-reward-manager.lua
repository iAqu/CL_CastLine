-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local selectCelebrationPendingReward = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "celebration-reward.selectors").selectCelebrationPendingReward
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue

return {
    default = function() -- CelebrationRewardManager | line: 17
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), default (copy), useRootProducer (copy), useRootSelector (copy), useScreenSizeState (copy), selectCelebrationPendingReward (copy), abbreviate (copy), images (copy), rewardPresentationQueue (copy)
        local v1 = useRootSelector(selectCelebrationPendingReward)
        local v2 = useRootProducer()
        local v3 = useScreenSizeState()
        local v4 = v3 == "sm" or v3 == "md"
        local v5, v6 = useState(nil)
        local v7 = useRef(nil)

        useEffect(function() -- line: 24
            -- upvalues: v1 (copy), v2 (copy), v6 (copy), v7 (copy)
            if v1 == nil or v1.id == v7.current then
                return nil
            end

            v7.current = v1.id
            v6(v1)
            v2.celebrationRewardConsumed({
                id = v1.id
            })
        end, { v1, v2 })

        if v5 == nil then
            return nil
        end

        local reward = v5.reward
        local v8 = ("+%* TICKET%*"):format(abbreviate(reward.amount), if reward.amount > 1 then "S" else "")

        return react.createElement(default, {
            title = "DAILY REWARD!",
            zIndex = 200,
            iconImage = images.celebrationTicket,
            onFinished = function() -- onFinished | line: 42
                -- upvalues: v5 (copy), v6 (copy), rewardPresentationQueue (copy)
                local id = v5.id

                v6(nil)
                rewardPresentationQueue:presentationFinished(id)
            end,
            rewardText = v8,
            uiScale = v4 and 0.78 or 1
        })
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent, "celebration-reward-popup-screen").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps

return {
    default = function() -- CelebrationRewardPopupManager | line: 22
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), default (copy), useRootSelector (copy), useScreenSizeState (copy), selectTutorialStep (copy), selectCurrentWindow (copy), selectPlayerMetadata (copy), localPlayerUserId (copy), functions (copy), tutorialSteps (copy)
        local v1 = useScreenSizeState()
        local v2 = v1 == "sm" or v1 == "md"
        local v3 = useRootSelector(selectTutorialStep)
        local v4 = useRootSelector(selectCurrentWindow)
        local v5 = useRootSelector(selectPlayerMetadata(localPlayerUserId))

        if v5 ~= nil then
            v5 = v5.hasClaimedCelebrationWelcomeReward
        end

        local v6 = v5 == true
        local v7, v8 = useState(false)
        local v9 = useRef(false)
        local v10 = useRef(false)
        local v11 = useRef(tutorialSteps.completed <= v3)

        useEffect(function() -- line: 40
            -- upvalues: v4 (copy), v8 (copy), v10 (copy), v11 (copy), v6 (copy)
            if v6 or not v11.current or v10.current or v4 == "loadingScreen" then
                return nil
            end

            v10.current = true

            local v12 = task.delay(1, function() -- line: 54
                -- upvalues: v8 (copy)
                return v8(true)
            end)

            return function() -- line: 57
                -- upvalues: v12 (copy)
                return task.cancel(v12)
            end
        end, { v4, v6 })
        useEffect(function() -- line: 62
            -- upvalues: v3 (copy), v8 (copy), v9 (copy), v11 (copy), v6 (copy), tutorialSteps (copy)
            if v6 or v11.current or v9.current or v3 < tutorialSteps.completed then
                return nil
            end

            v9.current = true

            local v13 = task.delay(3, function() -- line: 76
                -- upvalues: v8 (copy)
                return v8(true)
            end)

            return function() -- line: 79
                -- upvalues: v13 (copy)
                return task.cancel(v13)
            end
        end, { v3, v6 })

        local function v14() -- line: 86
            -- upvalues: v8 (copy), RuntimeLib (copy), functions (copy)
            v8(false)
            task.spawn(RuntimeLib.async(function() -- line: 88
                -- upvalues: RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.claimCelebrationWelcomeReward())
            end))
        end

        local createElement, default2, t1, v15

        if not v7 or v6 then
            return nil
        else
            createElement = react.createElement
            default2 = default
            t1 = {
                zIndex = 200,
                onClaim = v14
            }
            v15 = if v2 then 0.78 else 1
        end

        t1.uiScale = v15

        return createElement(default2, t1)
    end
}

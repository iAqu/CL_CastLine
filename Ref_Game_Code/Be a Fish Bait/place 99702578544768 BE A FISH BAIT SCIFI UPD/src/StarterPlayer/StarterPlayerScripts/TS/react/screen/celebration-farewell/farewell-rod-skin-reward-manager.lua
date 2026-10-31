-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "exclusive-reward-screen").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerMetadata, selectPlayerRewards = selectors.selectPlayerMetadata, selectors.selectPlayerRewards
local farewellRodSkinRewardId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers").farewellRodSkinRewardId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins")
local fishingRodSkinsData, fomoRodSkinId = v1.fishingRodSkinsData, v1.fomoRodSkinId
local farewellRewardClaimRequestedAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "controllers", "celebration-event-controller").farewellRewardClaimRequestedAtom
local v2 = fishingRodSkinsData[fomoRodSkinId]

return {
    default = function() -- FarewellRodSkinRewardManager | line: 32
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), default (copy), useRootSelector (copy), useScreenSizeState (copy), functions (copy), localPlayerUserId (copy), selectCurrentWindow (copy), selectPlayerMetadata (copy), selectPlayerRewards (copy), farewellRodSkinRewardId (copy), farewellRewardClaimRequestedAtom (copy), v2 (copy)
        local v3 = useScreenSizeState()
        local v4 = useRootSelector(selectCurrentWindow)
        local v5 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
        local v6 = useRootSelector(selectPlayerRewards(localPlayerUserId))

        if v5 ~= nil then
            v5 = v5.hasSeenCelebrationFarewell
        end

        local v7 = v5 ~= true

        if v6 ~= nil then
            v6 = v6[farewellRodSkinRewardId]
        end

        local v8 = v6 == true
        local v9, v10 = useState(false)
        local v11 = useRef(false)
        local v12 = useRef(false)
        local v13 = useRef(v7)

        v13.current = v7

        local v14 = useRef(v8)

        v14.current = v8

        local function v15() -- line: 56
            -- upvalues: v10 (copy), v12 (copy), v13 (copy), v14 (copy), RuntimeLib (copy), functions (copy)
            if v12.current or v13.current or v14.current then
                return nil
            end

            v12.current = true
            task.spawn(RuntimeLib.async(function() -- line: 61
                -- upvalues: v10 (copy), v12 (copy), RuntimeLib (copy), functions (copy)
                local v16 = RuntimeLib.await(functions.claimFarewellRodSkinReward():catch(function() -- line: 62
                    return false
                end))

                v12.current = false

                if v16 then
                    v10(true)
                end
            end))
        end

        useEffect(function() -- line: 72
            -- upvalues: v15 (copy), subscribe (copy), farewellRewardClaimRequestedAtom (copy)
            return subscribe(farewellRewardClaimRequestedAtom, function() -- line: 73
                -- upvalues: v15 (copy)
                return v15()
            end)
        end, {})

        local v17 = v4 == "celebrationTicketChallenge"

        useEffect(function() -- line: 81
            -- upvalues: v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v17 (copy), RuntimeLib (copy), functions (copy)
            if v11.current and not v17 and not v12.current and not v13.current and not v14.current then
                v12.current = true
                task.spawn(RuntimeLib.async(function() -- line: 61
                    -- upvalues: v10 (copy), v12 (copy), RuntimeLib (copy), functions (copy)
                    local v18 = RuntimeLib.await(functions.claimFarewellRodSkinReward():catch(function() -- line: 62
                        return false
                    end))

                    v12.current = false

                    if v18 then
                        v10(true)
                    end
                end))
            end

            v11.current = v17
        end, { v17 })

        local createElement, default2, t1, v19

        if not v9 or v2 == nil then
            return nil
        else
            createElement = react.createElement
            default2 = default
            t1 = {
                title = "FAREWELL GIFT!",
                zIndex = 200,
                iconImage = v2.imageId
            }

            function t1.onFinished() -- line: 93
                -- upvalues: v10 (copy)
                return v10(false)
            end

            t1.rewardText = v2.name
            v19 = if v3 == "sm" or v3 == "md" then 0.78 else 1
        end

        t1.uiScale = v19

        return createElement(default2, t1)
    end
}

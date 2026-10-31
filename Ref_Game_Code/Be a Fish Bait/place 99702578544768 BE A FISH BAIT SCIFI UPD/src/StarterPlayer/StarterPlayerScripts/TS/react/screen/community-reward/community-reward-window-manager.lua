-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Workspace = services.HttpService, services.Workspace
local default = RuntimeLib.import(script, script.Parent, "community-reward-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerRewards
local selectIsInCommunityGroup = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "community-rewards-ui.selectors").selectIsInCommunityGroup
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils")
local communityRewardId, communityRewardDisplayName, communityRewardFishName, isCommunityRewardActive = v1.communityRewardId, v1.communityRewardDisplayName, v1.communityRewardFishName, v1.isCommunityRewardActive
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig

return {
    default = function() -- CommunityRewardWindowManager | line: 32
        -- upvalues: RuntimeLib (copy), react (copy), useState (copy), HttpService (copy), Workspace (copy), default (copy), default2 (copy), useScreenSizeState (copy), useSound (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerRewards (copy), selectIsInCommunityGroup (copy), localPlayerUserId (copy), communityRewardId (copy), communityRewardDisplayName (copy), communityRewardFishName (copy), isCommunityRewardActive (copy), fishDataByName (copy), isFishData (copy), functions (copy), clientProducer (copy), useConfig (copy)
        local v2 = useRootProducer()
        local v3 = useConfig()
        local v4 = useScreenSizeState()
        local v5 = v4 == "sm" or v4 == "md"
        local playSound = useSound("SkillCheckSuccess").playSound
        local v6 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v7 = useRootSelector(selectIsInCommunityGroup)
        local v8, v9 = useState(false)
        local v10 = fishDataByName[communityRewardFishName]

        if v10 == nil or not isFishData(v10) then
            v10 = nil
        end

        if v6 ~= nil then
            v6 = v6[communityRewardId]
        end

        local v11 = v6 == true
        local v12 = not isCommunityRewardActive()
        local v13, v14 = useState(false)
        local v15, v16 = useState(false)
        local v17, v18 = useState(nil)
        local t1 = {
            likeConfirmed = v13,
            favoriteConfirmed = v15,
            communityJoined = v7
        }

        local function v19() -- line: 59
            -- upvalues: v13 (copy), v14 (copy)
            if v13 then
                return nil
            end

            v14(true)
            print("[CommunityReward] Player confirmed like")
        end

        local function v20() -- line: 70
            -- upvalues: v15 (copy), v16 (copy)
            if v15 then
                return nil
            end

            v16(true)
            print("[CommunityReward] Player confirmed favorite")
        end

        local function v21() -- line: 81
            -- upvalues: v3 (copy), v7 (copy)
            if v7 then
                return nil
            end

            print("[CommunityReward] Player initiated group join prompt")
            v3.promptToJoinCommunity()
        end

        local function v22() -- line: 92
            -- upvalues: v3 (copy), v7 (copy), v9 (copy), v12 (copy), v17 (copy), v18 (copy), v11 (copy), RuntimeLib (copy), HttpService (copy), Workspace (copy), communityRewardDisplayName (copy), functions (copy), clientProducer (copy)
            if v11 or v12 then
                return nil
            end

            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v23 = v17

            if v17 == nil then
                v23 = ServerTimeNow
            end

            if v17 == nil then
                v18(ServerTimeNow)
            end

            if ServerTimeNow - v23 < 3 then
                clientProducer.onScreenFeedbackAdded({
                    message = "Please like and favorite the game first!",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
                v3.promptToFavoriteGame()
            else
                if v7 then
                    task.spawn(RuntimeLib.async(function() -- line: 133
                        -- upvalues: v9 (copy), RuntimeLib (copy), HttpService (copy), communityRewardDisplayName (copy), functions (copy), clientProducer (copy)
                        local v24 = RuntimeLib.await(functions.claimCommunityReward())
                        local v25 = HttpService:GenerateGUID(false)

                        if v24 ~= true then
                            clientProducer.onScreenFeedbackAdded({
                                message = "Could not claim reward. Please try again.",
                                type = "error",
                                id = v25
                            })

                            return
                        end

                        clientProducer.onScreenFeedbackAdded({
                            type = "success",
                            id = v25,
                            message = ("%* unlocked!"):format(communityRewardDisplayName)
                        })
                        v9(true)
                        task.delay(4.5, function() -- line: 144
                            -- upvalues: v9 (copy)
                            return v9(false)
                        end)
                    end))

                    return
                end

                clientProducer.onScreenFeedbackAdded({
                    message = "Please join the community group first!",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
                v3.promptToJoinCommunity()
            end

            return nil
        end

        local createElement, Fragment = react.createElement, react.Fragment
        local v26 = react.createElement(default, {
            isClaimed = v11,
            isExpired = v12,
            onClaim = v22,
            onClose = function() -- onClose | line: 160
                -- upvalues: v2 (copy)
                return v2.windowClosed({})
            end,
            onConfirmFavorite = v20,
            onConfirmLike = v19,
            onJoinCommunity = v21,
            taskState = t1
        })

        v8 = v8 and react.createElement(default2, {
            title = "YOU UNLOCKED!",
            zIndex = 200,
            fish = v10,
            onReveal = playSound,
            rewardText = if v10 == nil then communityRewardDisplayName else nil,
            uiScale = v5 and 0.78 or 1
        })

        return createElement(Fragment, nil, v26, v8)
    end
}

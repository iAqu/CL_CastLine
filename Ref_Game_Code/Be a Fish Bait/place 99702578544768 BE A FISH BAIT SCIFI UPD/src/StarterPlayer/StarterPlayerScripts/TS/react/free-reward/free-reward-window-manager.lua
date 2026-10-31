-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Workspace = services.HttpService, services.Workspace
local default = RuntimeLib.import(script, script.Parent, "free-reward-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectIsInGroup = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "selectors", "free-rewards-ui.selectors").selectIsInGroup
local selectPlayerRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerRewards
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local freeRewardRewardId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "free-rewards-utils").freeRewardRewardId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "producer").clientProducer
local analyticsFreeRewardFunnelSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "analytics-constants").analyticsFreeRewardFunnelSteps
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig

return {
    default = function() -- FreeRewardWindowManager | line: 19
        -- upvalues: RuntimeLib (copy), react (copy), HttpService (copy), Workspace (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectIsInGroup (copy), selectPlayerRewards (copy), localPlayerUserId (copy), freeRewardRewardId (copy), functions (copy), clientProducer (copy), analyticsFreeRewardFunnelSteps (copy), useConfig (copy)
        local v1 = useRootProducer()
        local v2 = useConfig()
        local v3 = useRootSelector(selectIsInGroup)
        local v4 = useRootSelector(selectPlayerRewards(localPlayerUserId))

        if v4 ~= nil then
            v4 = v4[freeRewardRewardId]
        end

        local v5 = v4 == true
        local v6, v7 = react.useState(nil)

        local function v8() -- line: 30
            -- upvalues: v2 (copy), v3 (copy), v6 (copy), v7 (copy), v5 (copy), RuntimeLib (copy), HttpService (copy), Workspace (copy), functions (copy), clientProducer (copy), analyticsFreeRewardFunnelSteps (copy)
            if v5 then
                return nil
            end

            functions.logFreeRewardFunnelStep(analyticsFreeRewardFunnelSteps.clickedClaim.stepName)

            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v9 = v6

            if v6 == nil then
                v9 = ServerTimeNow
            end

            if v6 == nil then
                v7(ServerTimeNow)
            end

            if ServerTimeNow - v9 < 3 then
                local v10 = HttpService:GenerateGUID(false)

                clientProducer.onScreenFeedbackAdded({
                    message = "You must like the game first!",
                    type = "error",
                    id = v10
                })
            else
                if v3 then
                    task.spawn(RuntimeLib.async(function() -- line: 77
                        -- upvalues: RuntimeLib (copy), HttpService (copy), functions (copy), clientProducer (copy)
                        local v11 = functions.claimFreeReward()

                        if RuntimeLib.await(v11) == true then
                            local v12 = HttpService:GenerateGUID(false)

                            clientProducer.onScreenFeedbackAdded({
                                message = "Free rewards claimed successfully!",
                                type = "success",
                                id = v12
                            })
                        end
                    end))

                    return
                end

                local v13 = HttpService:GenerateGUID(false)

                clientProducer.onScreenFeedbackAdded({
                    message = "You must like the game and join the group!",
                    type = "error",
                    id = v13
                })
                functions.logFreeRewardFunnelStep(analyticsFreeRewardFunnelSteps.clickedClaimButNotInGroup.stepName)
                v2.promptToJoinGroup()
            end

            return nil
        end

        return react.createElement(default, {
            isClaimed = v5,
            onClaim = v8,
            onClose = function() -- onClose | line: 96
                -- upvalues: v1 (copy)
                return v1.windowClosed({})
            end
        })
    end
}

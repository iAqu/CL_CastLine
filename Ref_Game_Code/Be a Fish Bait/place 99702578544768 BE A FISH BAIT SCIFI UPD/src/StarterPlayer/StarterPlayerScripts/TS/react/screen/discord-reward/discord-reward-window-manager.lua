-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerRewards = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerRewards
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils")
local discordRewardId, discordRewardDisplayName = v1.discordRewardId, v1.discordRewardDisplayName
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local default = RuntimeLib.import(script, script.Parent, "discord-reward-window").default

return {
    default = function() -- DiscordRewardWindowManager | line: 16
        -- upvalues: RuntimeLib (copy), react (copy), HttpService (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerRewards (copy), localPlayerUserId (copy), discordRewardId (copy), discordRewardDisplayName (copy), clientProducer (copy), default (copy)
        local v2 = useRootProducer()
        local v3 = useRootSelector(selectPlayerRewards(localPlayerUserId))

        if v3 ~= nil then
            v3 = v3[discordRewardId]
        end

        local v4 = v3 == true

        local function v5(p1) -- line: 24
            -- upvalues: RuntimeLib (copy), HttpService (copy), functions (copy), discordRewardDisplayName (copy), clientProducer (copy)
            task.spawn(RuntimeLib.async(function() -- line: 25
                -- upvalues: p1 (copy), RuntimeLib (copy), HttpService (copy), functions (copy), discordRewardDisplayName (copy), clientProducer (copy)
                local v6 = HttpService:GenerateGUID(false)

                if RuntimeLib.await(functions.verifyDiscordAndClaimMJFish(p1)) == true then
                    clientProducer.onScreenFeedbackAdded({
                        type = "success",
                        id = v6,
                        message = ("%* unlocked!"):format(discordRewardDisplayName)
                    })
                else
                    clientProducer.onScreenFeedbackAdded({
                        message = "Username not found in Discord server.",
                        type = "error",
                        id = v6
                    })
                end
            end))
        end

        return react.createElement(default, {
            isClaimed = v4,
            onClose = function() -- onClose | line: 45
                -- upvalues: v2 (copy)
                return v2.windowClosed({})
            end,
            onVerify = v5
        })
    end
}

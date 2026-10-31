-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local default = RuntimeLib.import(script, script.Parent, "celebration-ticket-challenge-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "controllers", "celebration-event-controller")
local celebrationChallengeTicketsAtom, farewellRewardClaimRequestedAtom = v1.celebrationChallengeTicketsAtom, v1.farewellRewardClaimRequestedAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerClaimedChallengeTierIds, selectPlayerMetadata, selectPlayerRewards = selectors.selectPlayerClaimedChallengeTierIds, selectors.selectPlayerMetadata, selectors.selectPlayerRewards
local farewellRodSkinRewardId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "challenge-tiers").farewellRodSkinRewardId

return {
    default = function() -- CelebrationTicketChallengeWindowManager | line: 24
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), default (copy), useRootProducer (copy), useRootSelector (copy), events (copy), functions (copy), celebrationChallengeTicketsAtom (copy), farewellRewardClaimRequestedAtom (copy), localPlayerUserId (copy), selectPlayerClaimedChallengeTierIds (copy), selectPlayerMetadata (copy), selectPlayerRewards (copy), farewellRodSkinRewardId (copy)
        local v2 = useRootProducer()
        local v3, v4 = useState(function() -- line: 26
            -- upvalues: celebrationChallengeTicketsAtom (copy)
            return celebrationChallengeTicketsAtom()
        end)
        local v5 = useRootSelector(selectPlayerClaimedChallengeTierIds(localPlayerUserId))
        local t1 = {}

        for _, v6 in v5 do
            t1[v6] = true
        end

        local v7 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
        local v8 = useRootSelector(selectPlayerRewards(localPlayerUserId))

        if v7 ~= nil then
            v7 = v7.hasSeenCelebrationFarewell
        end

        local v9 = v7 ~= true

        if v8 ~= nil then
            v8 = v8[farewellRodSkinRewardId]
        end

        local v10 = v8 == true
        local v11, v12 = useState(nil)

        useEffect(function() -- line: 54
            -- upvalues: v4 (copy), subscribe (copy), celebrationChallengeTicketsAtom (copy)
            return subscribe(celebrationChallengeTicketsAtom, v4)
        end, {})
        useEffect(function() -- line: 63
            -- upvalues: v12 (copy), events (copy)
            events.celebrationChallengeWindowOpened:fire()

            local v13 = events.celebrationChallengeTicketsUpdated:connect(function(p1) -- line: 65
                -- upvalues: v12 (copy)
                v12(function(p2) -- line: 66
                    -- upvalues: p1 (copy)
                    if p2 == nil then
                        return p1
                    end

                    return p2
                end)
            end)

            return function() -- line: 74
                -- upvalues: v13 (copy), events (copy)
                events.celebrationChallengeWindowClosed:fire()
                v13:Disconnect()
            end
        end, {})

        return react.createElement(default, {
            barTickets = v11,
            claimedTierIds = t1,
            currentTickets = v3,
            isFarewellRewardClaimed = v10,
            isFarewellRewardLocked = v9,
            onClaimFarewellReward = function() -- onClaimFarewellReward | line: 85
                -- upvalues: farewellRewardClaimRequestedAtom (copy)
                return farewellRewardClaimRequestedAtom(function(p3) -- line: 86
                    return p3 + 1
                end)
            end,
            onClaim = function(p4) -- onClaim | line: 90
                -- upvalues: functions (copy)
                return functions.claimChallengeTier(p4)
            end,
            onClose = function() -- onClose | line: 93
                -- upvalues: v2 (copy)
                return v2.windowClosed({})
            end
        })
    end
}

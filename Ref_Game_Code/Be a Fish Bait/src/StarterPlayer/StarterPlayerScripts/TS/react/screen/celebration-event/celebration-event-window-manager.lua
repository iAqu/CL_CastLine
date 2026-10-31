-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local v1 = RuntimeLib.import(script, script.Parent, "celebration-event-window")
local default, celebrationEventWindowFadeDurationSeconds = v1.default, v1.celebrationEventWindowFadeDurationSeconds
local selectIsCelebrationPlace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectIsCelebrationPlace
local useTeleportToFomoIsland = RuntimeLib.import(script, script.Parent.Parent, "hud", "teleport-to-fomo-island-button").useTeleportToFomoIsland
local events = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").events
local celebrationChallengeTicketsAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "controllers", "celebration-event-controller").celebrationChallengeTicketsAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local teleportToEventShop = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "character-utils").teleportToEventShop

return {
    default = function() -- CelebrationEventWindowManager | line: 22
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useState (copy), subscribe (copy), useRootProducer (copy), useRootSelector (copy), default (copy), celebrationEventWindowFadeDurationSeconds (copy), selectIsCelebrationPlace (copy), useTeleportToFomoIsland (copy), events (copy), celebrationChallengeTicketsAtom (copy), localPlayerUserId (copy), selectPlayerStat (copy), teleportToEventShop (copy)
        local v2 = useRootProducer()
        local v3 = useRootSelector(selectIsCelebrationPlace(localPlayerUserId))
        local handleClick = useTeleportToFomoIsland().handleClick
        local v4, v5 = useState(function() -- line: 27
            -- upvalues: celebrationChallengeTicketsAtom (copy)
            return celebrationChallengeTicketsAtom()
        end)
        local v6 = useRootSelector(selectPlayerStat(localPlayerUserId, "tickets"))

        if v6 == nil then
            v6 = 0
        end

        useEffect(function() -- line: 35
            -- upvalues: v5 (copy), subscribe (copy), celebrationChallengeTicketsAtom (copy)
            return subscribe(celebrationChallengeTicketsAtom, v5)
        end, {})
        useEffect(function() -- line: 38
            -- upvalues: events (copy)
            events.celebrationEventWindowOpened:fire()
            events.celebrationChallengeWindowOpened:fire()

            return function() -- line: 43
                -- upvalues: events (copy)
                events.celebrationEventWindowClosed:fire()
                events.celebrationChallengeWindowClosed:fire()
            end
        end, {})

        local v7 = useCallback(function() -- line: 51
            -- upvalues: v2 (copy), celebrationEventWindowFadeDurationSeconds (copy)
            v2.windowClosed({})
            task.delay(celebrationEventWindowFadeDurationSeconds, function() -- line: 53
                -- upvalues: v2 (copy)
                v2.windowOpened({
                    currentWindow = "celebrationTicketChallenge"
                })
            end)
        end, { v2 })
        local v8 = useCallback(function() -- line: 59
            -- upvalues: v2 (copy), handleClick (copy)
            handleClick()
            v2.windowClosed({})
        end, { handleClick, v2 })

        return react.createElement(default, {
            globalTicketCount = v4,
            isCelebrationPlace = v3,
            onClose = function() -- onClose | line: 66
                -- upvalues: v2 (copy)
                return v2.windowClosed({})
            end,
            onOpenStore = teleportToEventShop,
            onTeleport = v8,
            onViewChallenge = v7,
            ticketCount = v6
        })
    end
}

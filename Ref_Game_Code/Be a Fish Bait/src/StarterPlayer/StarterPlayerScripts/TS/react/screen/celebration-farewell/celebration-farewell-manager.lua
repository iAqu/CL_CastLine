-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local celebrationEventShopEndTimestamp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").celebrationEventShopEndTimestamp
local default = RuntimeLib.import(script, script.Parent, "celebration-farewell-cutscene").default

return {
    default = function() -- CelebrationFarewellManager | line: 21
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), Workspace (copy), events (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), selectCurrentWindow (copy), selectPlayerMetadata (copy), celebrationEventShopEndTimestamp (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectCurrentWindow)
        local v3 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
        local v4, v5 = useState(false)
        local v6, v7 = useState(0)
        local v8 = useRef(false)
        local v9 = useRef(false)

        useEffect(function() -- line: 29
            -- upvalues: v5 (copy), v7 (copy), v9 (copy), events (copy)
            local v10 = events.celebrationFarewellTestRequested:connect(function() -- line: 30
                -- upvalues: v5 (copy), v7 (copy), v9 (copy)
                v9.current = true
                v7(function(p1) -- line: 32
                    return p1 + 1
                end)
                v5(true)
            end)

            return function() -- line: 37
                -- upvalues: v10 (copy)
                return v10:Disconnect()
            end
        end, {})
        useEffect(function() -- line: 41
            -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), Workspace (copy), functions (copy), celebrationEventShopEndTimestamp (copy)
            if v8.current
                or v4
                or v2 == "loadingScreen"
                or v3 == nil
                or not v3.hasVisitedCelebrationIsland
                or v3.hasSeenCelebrationFarewell
                or Workspace:GetServerTimeNow() < celebrationEventShopEndTimestamp then
                return nil
            end

            v8.current = true
            functions.beginCelebrationFarewell():andThen(function(p2) -- line: 55
                -- upvalues: v5 (copy), v7 (copy), v9 (copy)
                if not p2 then
                    return
                end

                v9.current = true
                v7(function(p3) -- line: 58
                    return p3 + 1
                end)
                v5(true)
            end):catch(function() -- line: 63
                -- upvalues: v8 (copy)
                v8.current = false
            end)
        end, { v2, v3, v4 })

        local v11 = useCallback(function() -- line: 67
            -- upvalues: v1 (copy), v5 (copy), v9 (copy), functions (copy)
            v5(false)

            if not v9.current then
                return nil
            end

            v9.current = false
            functions.completeCelebrationFarewell():andThen(function(p4) -- line: 77
                -- upvalues: v1 (copy)
                if p4 then
                    v1.windowOpened({
                        currentWindow = "celebrationTicketChallenge"
                    })
                end
            end):catch(function() -- line: 83
            end)
        end, { v1 })

        return if v4 then react.createElement(default, {
            key = ("celebration-farewell-%*"):format(v6),
            onDone = v11
        }) else nil
    end
}

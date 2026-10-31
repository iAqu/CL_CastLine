-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local ExperienceNotificationService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ExperienceNotificationService
local default = RuntimeLib.import(script, script.Parent, "celebration-registration-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local network = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local celebrationEventRegisteredCountAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "controllers", "celebration-event-controller").celebrationEventRegisteredCountAtom
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig

return {
    default = function() -- CelebrationRegistrationWindowManager | line: 25
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), ExperienceNotificationService (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerMetadata (copy), localPlayerUserId (copy), events (copy), functions (copy), celebrationEventRegisteredCountAtom (copy), useConfig (copy)
        local v1 = useRootProducer()
        local getSound = useConfig().getSound
        local v2 = useRootSelector(selectPlayerMetadata(localPlayerUserId))

        if v2 ~= nil then
            v2 = v2.hasRegisteredForCelebrationEvent
        end

        local v3 = v2 == true
        local v4, v5 = useState(false)
        local v6, v7 = useState(false)
        local v8, v9 = useState(function() -- line: 40
            -- upvalues: celebrationEventRegisteredCountAtom (copy)
            return celebrationEventRegisteredCountAtom()
        end)
        local v10 = useRef(nil)
        local v11 = v3 or v4

        useEffect(function() -- line: 45
            -- upvalues: v9 (copy), subscribe (copy), celebrationEventRegisteredCountAtom (copy)
            return subscribe(celebrationEventRegisteredCountAtom, function(p1) -- line: 46
                -- upvalues: v9 (copy)
                v9(p1)
            end)
        end, {})
        useEffect(function() -- line: 52
            -- upvalues: events (copy)
            events.celebrationEventWindowOpened:fire()

            return function() -- line: 54
                -- upvalues: events (copy)
                return events.celebrationEventWindowClosed:fire()
            end
        end, {})
        useEffect(function() -- line: 58
            -- upvalues: v10 (copy)
            return function() -- line: 59
                -- upvalues: v10 (copy)
                if v10.current ~= nil then
                    task.cancel(v10.current)
                end
            end
        end, {})

        local function v12() -- line: 65
            -- upvalues: getSound (copy), v5 (copy), v7 (copy), v9 (copy), v10 (copy), v11 (copy), RuntimeLib (copy), ExperienceNotificationService (copy), functions (copy)
            if v11 then
                return nil
            end

            v5(true)
            v7(true)
            v9(function(p2) -- line: 71
                return p2 + 1
            end)

            local PartyPopper = getSound("PartyPopper")

            PartyPopper.Ended:Once(function() -- line: 77
                -- upvalues: getSound (copy)
                return getSound("PartyBlower"):Play()
            end)
            PartyPopper:Play()
            task.spawn(RuntimeLib.async(function() -- line: 81
                -- upvalues: v9 (copy), RuntimeLib (copy), functions (copy)
                local v13 = RuntimeLib.await(functions.registerForCelebrationEvent())

                if v13 ~= false then
                    v9(v13)
                end
            end))
            v10.current = task.delay(2, function() -- line: 87
                -- upvalues: ExperienceNotificationService (copy)
                local function v14() -- line: 88
                    -- upvalues: ExperienceNotificationService (copy)
                    return ExperienceNotificationService:CanPromptOptInAsync()
                end

                local ok, result = pcall(v14)

                if ok and result then
                    local function v15() -- line: 92
                        -- upvalues: ExperienceNotificationService (copy)
                        return ExperienceNotificationService:PromptOptIn()
                    end

                    pcall(v15)
                end
            end)
        end

        return react.createElement(default, {
            isRegistered = v11,
            justRegistered = v6,
            onClose = function() -- onClose | line: 101
                -- upvalues: v1 (copy)
                return v1.windowClosed({})
            end,
            onRegister = v12,
            registeredCount = v8
        })
    end
}

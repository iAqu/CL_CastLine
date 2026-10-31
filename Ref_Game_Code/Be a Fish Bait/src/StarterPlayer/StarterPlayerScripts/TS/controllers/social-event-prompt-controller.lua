-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local SocialService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").SocialService
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerMetadata, selectPlayerOfflineEarnings = selectors.selectPlayerMetadata, selectors.selectPlayerOfflineEarnings
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local isAutoPromptBlocked = RuntimeLib.import(script, script.Parent.Parent, "auto-prompt-gate-utils").isAutoPromptBlocked
local dailyRewardPromptResolvedAtom = RuntimeLib.import(script, script.Parent.Parent, "daily-reward-prompt-resolved-atom").dailyRewardPromptResolvedAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local socialEventId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "social-event-utils").socialEventId
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 22
        return "SocialEventPromptController"
    end
})

self.__index = self

function self.new(...) -- line: 27
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 31
    p1._reflexController = p2
end

function self.onStart(p3) -- line: 34
    -- upvalues: SocialService (copy), effect (copy), reflexStateToAtom (copy), selectTutorialStep (copy), selectCurrentWindow (copy), selectPlayerMetadata (copy), selectPlayerOfflineEarnings (copy), fishingMovementLockedAtom (copy), isAutoPromptBlocked (copy), dailyRewardPromptResolvedAtom (copy), localPlayerUserId (copy), events (copy), socialEventId (copy)
    local v3 = p3._reflexController:getClientProducer()
    local v4 = reflexStateToAtom(v3, selectTutorialStep)
    local v5 = v4[1]
    local v6 = v4[2]
    local v7 = reflexStateToAtom(v3, selectCurrentWindow)
    local v8 = v7[1]
    local v9 = v7[2]
    local v10 = reflexStateToAtom(v3, selectPlayerOfflineEarnings(localPlayerUserId))
    local v11 = v10[1]
    local v12 = v10[2]
    local v13 = reflexStateToAtom(v3, selectPlayerMetadata(localPlayerUserId))
    local v14 = v13[1]
    local v15 = v13[2]
    local v16 = false
    local v17

    v17 = effect(function() -- line: 50
        -- upvalues: v5 (copy), v6 (copy), v8 (copy), v9 (copy), v11 (copy), v12 (copy), v14 (copy), v15 (copy), v16 (ref), v17 (ref), SocialService (copy), fishingMovementLockedAtom (copy), isAutoPromptBlocked (copy), dailyRewardPromptResolvedAtom (copy), events (copy), socialEventId (copy)
        local v18 = v5()
        local v19 = v8()
        local v20 = fishingMovementLockedAtom()
        local v21 = v11()
        local v22 = v14()

        if v22 == nil
            or not dailyRewardPromptResolvedAtom()
            or isAutoPromptBlocked(v18, v19, v20)
            or v21 and v21.pendingOfflineEarnings > 0
            or v22.promptedSocialEventIds[socialEventId] == true
            or v16 then
            return nil
        end

        v16 = true
        task.defer(function() -- line: 80
            -- upvalues: v6 (copy), v9 (copy), v12 (copy), v15 (copy), v17 (ref)
            v17()
            v6()
            v9()
            v12()
            v15()
        end)
        task.spawn(function() -- line: 87
            -- upvalues: SocialService (copy), events (copy), socialEventId (copy)
            local function v23() -- line: 88
                -- upvalues: SocialService (copy), socialEventId (copy)
                return SocialService:GetEventRsvpStatusAsync(socialEventId)
            end

            local ok, result = pcall(v23)
            local v24

            if ok then
                v24 = result == Enum.RsvpStatus.Going
            else
                warn("[src/client/controllers/social-event-prompt-controller.ts:78]", (("[SocialEventPromptController] GetEventRsvpStatusAsync failed: %*"):format(result)))
            end

            if (not ok or v24) and ok then
                print("[SocialEventPromptController] Skipping prompt, already Going")

                return nil
            end

            local function v25() -- line: 97
                -- upvalues: SocialService (copy), socialEventId (copy)
                return SocialService:PromptRsvpToEventAsync(socialEventId)
            end

            local ok2, result2 = pcall(v25)

            if ok2 then
                events.socialEventRsvpPrompted:fire(socialEventId)
                print((("[SocialEventPromptController] Prompted successfully, RSVP status: %*"):format(result2)))
            else
                warn("[src/client/controllers/social-event-prompt-controller.ts:95]", (("[SocialEventPromptController] PromptRsvpToEventAsync failed: %*"):format(result2)))
            end
        end)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/social-event-prompt-controller@SocialEventPromptController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SocialEventPromptController = self
}

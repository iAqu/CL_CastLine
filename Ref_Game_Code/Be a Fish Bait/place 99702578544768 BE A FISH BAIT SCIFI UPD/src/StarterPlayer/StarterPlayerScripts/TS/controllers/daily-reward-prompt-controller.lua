-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectDayLastClaimedCelebrationReward, selectDayLastClaimedDailyReward, selectEquippedInventoryItem = selectors.selectDayLastClaimedCelebrationReward, selectors.selectDayLastClaimedDailyReward, selectors.selectEquippedInventoryItem
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors")
local selectIsCelebrationPlace, selectShouldAutoPromptDailyReward = v1.selectIsCelebrationPlace, v1.selectShouldAutoPromptDailyReward
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local analyticsDailyRewardFunnelSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "analytics-constants").analyticsDailyRewardFunnelSteps
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local isAutoPromptBlocked = RuntimeLib.import(script, script.Parent.Parent, "auto-prompt-gate-utils").isAutoPromptBlocked
local dailyRewardPromptResolvedAtom = RuntimeLib.import(script, script.Parent.Parent, "daily-reward-prompt-resolved-atom").dailyRewardPromptResolvedAtom
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 25
        return "DailyRewardPromptController"
    end
})

self.__index = self

function self.new(...) -- line: 30
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 34
    p1._reflexController = p2
end

function self._canClaimDailyReward(_, p4) -- line: 37
    if p4 == nil then
        return true
    end

    local v4 = DateTime.now():ToUniversalTime()

    if v4.Day == p4.day and v4.Month == p4.month then
        return v4.Year ~= p4.year
    end

    return true
end

function self._isBlocked(_, p6, p7, p8, p9) -- line: 44
    -- upvalues: isAutoPromptBlocked (copy)
    if isAutoPromptBlocked(p6, p7, p8) then
        return true
    end

    return p9 == "trainingWeight"
end

function self.onStart(p10) -- line: 53
    -- upvalues: effect (copy), selectDayLastClaimedCelebrationReward (copy), selectDayLastClaimedDailyReward (copy), selectEquippedInventoryItem (copy), localPlayerUserId (copy), selectTutorialStep (copy), selectIsCelebrationPlace (copy), selectShouldAutoPromptDailyReward (copy), selectCurrentWindow (copy), analyticsDailyRewardFunnelSteps (copy), fishingMovementLockedAtom (copy), functions (copy), reflexStateToAtom (copy), dailyRewardPromptResolvedAtom (copy)
    local v5 = p10._reflexController:getClientProducer()
    local v6 = reflexStateToAtom(v5, selectDayLastClaimedDailyReward(localPlayerUserId))
    local v7 = v6[1]
    local v8 = v6[2]
    local v9 = false
    local v10

    v10 = effect(function() -- line: 60
        -- upvalues: p10 (copy), v7 (copy), v8 (copy), v9 (ref), v10 (ref), analyticsDailyRewardFunnelSteps (copy), functions (copy)
        local v11 = v7()

        if v11 == nil or v9 then
            return nil
        end

        if p10:_canClaimDailyReward(v11) then
            local v12 = tonumber(v11.dailyRewardIndex)

            if v12 == nil then
                v12 = 1
            end

            if v12 >= 1 and v12 <= 14 then
                local v14 = analyticsDailyRewardFunnelSteps[("canClaimDay%*"):format(v12)]

                if v14 then
                    functions.logDailyRewardFunnelStep(v14.stepName)
                end
            end
        end

        v9 = true
        v10()
        v8()
    end)
    task.delay(10, function() -- line: 86
        -- upvalues: p10 (copy), v5 (copy), effect (copy), selectDayLastClaimedCelebrationReward (copy), selectDayLastClaimedDailyReward (copy), selectEquippedInventoryItem (copy), localPlayerUserId (copy), selectTutorialStep (copy), selectIsCelebrationPlace (copy), selectShouldAutoPromptDailyReward (copy), selectCurrentWindow (copy), fishingMovementLockedAtom (copy), reflexStateToAtom (copy), dailyRewardPromptResolvedAtom (copy)
        local v15 = v5:getState()
        local v16, v17

        if selectIsCelebrationPlace(localPlayerUserId)(v15) then
            v17 = "celebrationLogin"
            v16 = selectDayLastClaimedCelebrationReward(localPlayerUserId)
        else
            v17 = "dailyReward"
            v16 = selectDayLastClaimedDailyReward(localPlayerUserId)
        end

        local v18 = v16(v15)

        if not (selectShouldAutoPromptDailyReward(localPlayerUserId)(v15) and p10:_canClaimDailyReward(v18)) then
            dailyRewardPromptResolvedAtom(true)

            return nil
        end

        local v19 = reflexStateToAtom(v5, selectTutorialStep)
        local v20 = v19[1]
        local v21 = v19[2]
        local v22 = reflexStateToAtom(v5, selectCurrentWindow)
        local v23 = v22[1]
        local v24 = v22[2]
        local v25 = reflexStateToAtom(v5, selectEquippedInventoryItem(localPlayerUserId))
        local v26 = v25[1]
        local v27 = v25[2]
        local v28 = false
        local v29

        v29 = effect(function() -- line: 109
            -- upvalues: v16 (ref), v20 (copy), v21 (copy), v23 (copy), v24 (copy), v26 (copy), v27 (copy), v28 (ref), v29 (ref), v17 (ref), p10 (copy), v5 (copy), effect (copy), selectCurrentWindow (copy), fishingMovementLockedAtom (copy), reflexStateToAtom (copy), dailyRewardPromptResolvedAtom (copy)
            local v30 = v20()
            local v31 = v23()
            local v32 = fishingMovementLockedAtom()
            local v33 = v26()

            if v33 ~= nil then
                v33 = v33.itemType
            end

            if not p10:_isBlocked(v30, v31, v32, v33) and not v28 then
                v28 = true
                task.defer(function() -- line: 126
                    -- upvalues: v21 (copy), v24 (copy), v27 (copy), v29 (ref)
                    v29()
                    v21()
                    v24()
                    v27()
                end)

                if p10:_canClaimDailyReward((v16(v5:getState()))) then
                    v5.windowOpened({
                        currentWindow = v17
                    })

                    local v35 = reflexStateToAtom(v5, selectCurrentWindow)
                    local v36 = v35[1]
                    local v37 = v35[2]
                    local v38

                    v38 = effect(function() -- line: 144
                        -- upvalues: v36 (copy), v37 (copy), v38 (ref), v17 (ref), dailyRewardPromptResolvedAtom (copy)
                        if v36() == v17 then
                            return nil
                        end

                        dailyRewardPromptResolvedAtom(true)
                        task.defer(function() -- line: 149
                            -- upvalues: v37 (copy), v38 (ref)
                            v38()
                            v37()
                        end)
                    end)

                    return
                end

                dailyRewardPromptResolvedAtom(true)
            end

            return nil
        end)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/daily-reward-prompt-controller@DailyRewardPromptController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    DailyRewardPromptController = self
}

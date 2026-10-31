-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local effect, subscribe = charm.effect, charm.subscribe
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerTutorialTracking, selectPlayerStat, selectPlayerAquarium, selectPlayerInventory = selectors.selectPlayerTutorialTracking, selectors.selectPlayerStat, selectors.selectPlayerAquarium, selectors.selectPlayerInventory
local selectEquippedInventoryItem = selectors.selectEquippedInventoryItem
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local getLevelUpCost = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getLevelUpCost
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils")
local tutorialSteps, calculateTutorialStep, tutorialTrainPowerTarget = v1.tutorialSteps, v1.calculateTutorialStep, v1.tutorialTrainPowerTarget
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectIsInFishingArea = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "fishing-area-ui.selectors").selectIsInFishingArea
local selectIsNearBase = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "near-base-ui.selectors").selectIsNearBase
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local network = RuntimeLib.import(script, script.Parent.Parent, "network")
local events, functions = network.events, network.functions
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 33
        return "TutorialController"
    end
})

self.__index = self

function self.new(...) -- line: 38
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 42
    p1._reflexController = p2
end

function self.onStart(p3) -- line: 45
    -- upvalues: effect (copy), subscribe (copy), reflexStateToAtom (copy), selectPlayerTutorialTracking (copy), selectPlayerStat (copy), selectPlayerAquarium (copy), selectPlayerInventory (copy), selectEquippedInventoryItem (copy), fishDataByName (copy), getLevelUpCost (copy), localPlayerUserId (copy), tutorialSteps (copy), calculateTutorialStep (copy), tutorialTrainPowerTarget (copy), selectTutorialStep (copy), selectCurrentWindow (copy), selectIsInFishingArea (copy), selectIsNearBase (copy), fishingMovementLockedAtom (copy), events (copy), functions (copy)
    local v4 = p3._reflexController:getClientProducer()
    local v5 = reflexStateToAtom(v4, selectPlayerTutorialTracking(localPlayerUserId))[1]
    local v6 = reflexStateToAtom(v4, selectTutorialStep)[1]
    local v7 = reflexStateToAtom(v4, selectIsInFishingArea)[1]
    local v8 = reflexStateToAtom(v4, selectCurrentWindow)[1]
    local v9 = reflexStateToAtom(v4, selectIsNearBase)[1]
    local v10 = reflexStateToAtom(v4, selectPlayerStat(localPlayerUserId, "power"))[1]
    local v11 = reflexStateToAtom(v4, selectPlayerStat(localPlayerUserId, "money"))[1]

    effect(function() -- line: 62
        -- upvalues: v4 (copy), v5 (copy), v6 (copy), selectPlayerInventory (copy), localPlayerUserId (copy), tutorialSteps (copy), calculateTutorialStep (copy)
        local v12 = v5()
        local v13 = v6()

        if tutorialSteps.completed <= v13 or v12 == nil then
            return nil
        end

        local v14 = calculateTutorialStep({
            tutorialTracking = v12
        })

        if v14 == tutorialSteps.goToWeightsShop then
            local v15 = selectPlayerInventory(localPlayerUserId)(v4:getState())

            if v15 ~= nil then
                for _, v16 in v15 do
                    if v16.itemType == "trainingWeight" and v16.itemName == "SteelBarbell" then
                        v14 = tutorialSteps.trainPower
                        break
                    end
                end
            end
        end

        if v13 < v14 then
            v4.tutorialStepUpdated({
                step = v14
            })
        end
    end)

    local v17 = reflexStateToAtom(v4, selectPlayerInventory(localPlayerUserId))[1]

    effect(function() -- line: 95
        -- upvalues: v4 (copy), v6 (copy), v17 (copy), tutorialSteps (copy)
        if v6() ~= tutorialSteps.goToWeightsShop then
            return nil
        end

        local v18 = v17()

        if v18 == nil then
            return nil
        end

        for _, v19 in v18 do
            if v19.itemType == "trainingWeight" and v19.itemName == "SteelBarbell" then
                v4.tutorialStepUpdated({
                    step = tutorialSteps.trainPower
                })

                return nil
            end
        end
    end)
    effect(function() -- line: 114
        -- upvalues: v4 (copy), v6 (copy), v7 (copy), tutorialSteps (copy)
        local v20 = v7()
        local v21 = v6()

        if v20 and v21 == tutorialSteps.walkToDock then
            v4.tutorialStepUpdated({
                step = tutorialSteps.catchAFish
            })
        end
    end)
    subscribe(fishingMovementLockedAtom, function(p4, p5) -- line: 124
        -- upvalues: v4 (copy), v6 (copy), tutorialSteps (copy)
        if not p4 and p5 and v6() == tutorialSteps.catchAFish then
            v4.tutorialStepUpdated({
                step = tutorialSteps.addFishToAquarium
            })
        end
    end)

    local v22 = false
    local v23

    v23 = effect(function() -- line: 138
        -- upvalues: v6 (copy), v9 (copy), v22 (ref), v23 (ref), tutorialSteps (copy), events (copy)
        local v24 = v6()
        local v25 = v9()

        if v22 or v24 ~= tutorialSteps.addFishToAquarium or not v25 then
            return nil
        end

        v22 = true
        events.analyticsReachedBase:fire()
        v23()
    end)

    local v26 = false
    local v27

    v27 = effect(function() -- line: 157
        -- upvalues: v6 (copy), v7 (copy), v26 (ref), v27 (ref), tutorialSteps (copy), events (copy)
        if v26 or not v7() or v6() < tutorialSteps.completed then
            return nil
        end

        v26 = true
        events.analyticsSecondWalkedToDock:fire()
        v27()
    end)

    local v28 = false
    local v29

    v29 = effect(function() -- line: 174
        -- upvalues: v6 (copy), v9 (copy), v28 (ref), v29 (ref), tutorialSteps (copy), events (copy)
        if v28 or not v9() or v6() < tutorialSteps.completed then
            return nil
        end

        v28 = true
        events.analyticsSecondReachedBase:fire()
        v29()
    end)
    effect(function() -- line: 189
        -- upvalues: v4 (copy), v6 (copy), v8 (copy), tutorialSteps (copy)
        local v30 = v8()
        local v31 = v6()

        if v30 == "aquarium" and v31 == tutorialSteps.addFishToAquarium then
            v4.tutorialStepUpdated({
                step = tutorialSteps.equipBestFish
            })
        end
    end)
    effect(function() -- line: 199
        -- upvalues: v4 (copy), v6 (copy), v8 (copy), v11 (copy), selectPlayerAquarium (copy), fishDataByName (copy), getLevelUpCost (copy), localPlayerUserId (copy), tutorialSteps (copy)
        local v32 = v8()
        local v33 = v6()

        if v32 ~= "aquarium" or v33 ~= tutorialSteps.collectMoney then
            return nil
        end

        local v34 = selectPlayerAquarium(localPlayerUserId)(v4:getState())

        if v34 == nil then
            return nil
        end

        local v35

        for _, v36 in v34.fishItems do
            v35 = v36
            break
        end

        if v35 == nil then
            return nil
        end

        local v37 = fishDataByName[v35.fishSpecies]

        if v37 == nil or v37.moneyPerSecond == nil then
            return nil
        end

        local v38 = getLevelUpCost(v37.moneyPerSecond, v35.level)
        local v39 = v11()

        if v39 == nil then
            v39 = 0
        end

        if v38 <= v39 then
            v4.tutorialStepUpdated({
                step = tutorialSteps.levelUpFish
            })
        end
    end)
    effect(function() -- line: 235
        -- upvalues: v4 (copy), v6 (copy), v10 (copy), tutorialSteps (copy), tutorialTrainPowerTarget (copy)
        local v40 = v10()

        if v40 == nil then
            v40 = 0
        end

        if v6() == tutorialSteps.trainPower and tutorialTrainPowerTarget <= v40 then
            v4.tutorialStepUpdated({
                step = tutorialSteps.endWeightTraining
            })
        end
    end)

    local v41 = false

    effect(function() -- line: 252
        -- upvalues: v4 (copy), v6 (copy), v17 (copy), v41 (ref), selectEquippedInventoryItem (copy), localPlayerUserId (copy), tutorialSteps (copy)
        if v6() ~= tutorialSteps.endWeightTraining or v17() == nil then
            return nil
        end

        local v42 = selectEquippedInventoryItem(localPlayerUserId)(v4:getState())

        if (if v42 == nil then v42 else v42.itemType) == "trainingWeight" then
            v41 = true
        end

        if v41 and (v42 == nil or v42.itemType ~= "trainingWeight") then
            v4.tutorialStepUpdated({
                step = tutorialSteps.tutorialEnded
            })
        end
    end)
    subscribe(v6, function(p6, p7) -- line: 278
        -- upvalues: v4 (copy), v6 (copy), tutorialSteps (copy), functions (copy)
        if p6 == p7 or p7 == 0 then
            return nil
        end

        if tutorialSteps.walkToDock <= p6 then
            functions.updateTutorialStep(p6)
        end

        if tutorialSteps.walkToDock <= p6 and p6 <= tutorialSteps.completed then
            functions.logOnboardingFunnelStep(p6)
        end

        if p6 == tutorialSteps.tutorialEnded then
            task.delay(3, function() -- line: 292
                -- upvalues: v4 (copy), v6 (copy), tutorialSteps (copy)
                if v6() == tutorialSteps.tutorialEnded then
                    v4.tutorialStepUpdated({
                        step = tutorialSteps.completed
                    })
                end
            end)
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/tutorial-controller@TutorialController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    TutorialController = self
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, effect, peek, subscribe = charm.atom, charm.effect, charm.peek, charm.subscribe
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, TeleportService = services.ReplicatedStorage, services.TeleportService
local isAfkTeleportData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "afk-teleport-data").isAfkTeleportData
local network = RuntimeLib.import(script, script.Parent.Parent, "network")
local functions, events = network.functions, network.events
local setVFXEnabled = RuntimeLib.import(script, script.Parent.Parent, "vfx").setVFXEnabled
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "training-weights")
local barbellSoundSpeed, frenzyTrainingSpeedMultiplier, trainingAnimationSpeed, trainingIntervalSeconds = v1.barbellSoundSpeed, v1.frenzyTrainingSpeedMultiplier, v1.trainingAnimationSpeed, v1.trainingIntervalSeconds
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local vipGamepassName, vipTrainingSpeedMultiplier = v2.vipGamepassName, v2.vipTrainingSpeedMultiplier
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectEquippedInventoryItem, selectPlayerInventory, selectPlayerOwnsGamepass = selectors.selectEquippedInventoryItem, selectors.selectPlayerInventory, selectors.selectPlayerOwnsGamepass
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local trainingIsFrenzyAtom = RuntimeLib.import(script, script.Parent.Parent, "training-boost-atom").trainingIsFrenzyAtom
local isInVipTrainingAreaAtom = RuntimeLib.import(script, script.Parent.Parent, "vip-training-atom").isInVipTrainingAreaAtom
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 42
        return "WeightTrainingController"
    end
})

self.__index = self

function self.new(...) -- line: 47
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3, p4) -- line: 51
    -- upvalues: atom (copy), Maid (copy)
    p1._characterController = p2
    p1._reflexController = p3
    p1._soundController = p4
    p1._maid = Maid.new()
    p1._ownsVipAtom = atom(false)
end

function self.onInit(p5) -- line: 58
    -- upvalues: effect (copy), subscribe (copy), TeleportService (copy), isAfkTeleportData (copy), functions (copy), events (copy), vipGamepassName (copy), reflexStateToAtom (copy), selectEquippedInventoryItem (copy), selectPlayerInventory (copy), selectPlayerOwnsGamepass (copy), localPlayerUserId (copy), fishingMovementLockedAtom (copy), selectTutorialStep (copy), tutorialSteps (copy)
    local v5 = p5._reflexController:getClientProducer()
    local v6 = reflexStateToAtom(v5, selectEquippedInventoryItem(localPlayerUserId))[1]
    local v7 = reflexStateToAtom(v5, selectPlayerInventory(localPlayerUserId))[1]

    p5._ownsVipAtom = reflexStateToAtom(v5, selectPlayerOwnsGamepass(localPlayerUserId, vipGamepassName))[1]

    local LocalPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData()
    local v8 = isAfkTeleportData(LocalPlayerTeleportData) and LocalPlayerTeleportData.resumeTraining
    local v9 = false
    local v10

    v10 = effect(function() -- line: 76
        -- upvalues: v5 (copy), v6 (copy), v7 (copy), v9 (ref), v10 (ref), v8 (copy), functions (copy), selectTutorialStep (copy), tutorialSteps (copy)
        if v7() == nil then
            return nil
        end

        if v9 then
            return
        end

        v9 = true
        task.defer(function() -- line: 85
            -- upvalues: v10 (ref)
            return v10()
        end)

        local v11 = selectTutorialStep(v5:getState())
        local v12 = v6()

        if (if v12 == nil then v12 else v12.itemType) == "trainingWeight" and v11 ~= tutorialSteps.endWeightTraining and not v8 then
            functions.unequipInventoryItem(v12.itemId)
        end
    end)
    effect(function() -- line: 109
        -- upvalues: p5 (copy), v6 (copy), fishingMovementLockedAtom (copy)
        local v13 = v6()
        local v14 = fishingMovementLockedAtom()
        local v15 = p5._characterController.character()

        if v13 ~= nil then
            v13 = v13.itemType
        end

        if v13 == "trainingWeight" and not v14 and v15 then
            p5:_startTraining()

            return function() -- line: 123
                -- upvalues: p5 (copy)
                return p5:_stopTraining()
            end
        end
    end)

    local v16 = false

    subscribe(v6, function(p6, p7) -- line: 130
        -- upvalues: p5 (copy), v16 (ref), events (copy), selectTutorialStep (copy), tutorialSteps (copy)
        if v16 or (if p7 == nil then p7 else p7.itemType) ~= "trainingWeight" or (if p6 == nil then p6 else p6.itemType) == "trainingWeight" or selectTutorialStep(p5._reflexController:getClientProducer():getState()) < tutorialSteps.endWeightTraining then
            return nil
        end

        v16 = true
        events.analyticsExitedPowerTraining:fire()
    end)
    subscribe(fishingMovementLockedAtom, function(p8) -- line: 156
        -- upvalues: v6 (copy), functions (copy)
        if not p8 then
            return nil
        end

        local v17 = v6()

        if (if v17 == nil then v17 else v17.itemType) == "trainingWeight" then
            functions.unequipInventoryItem(v17.itemId)
        end
    end)

    local v18 = true

    subscribe(p5._characterController.character, function(p9, p10) -- line: 174
        -- upvalues: v5 (copy), v6 (copy), v8 (copy), v18 (ref), functions (copy), selectTutorialStep (copy), tutorialSteps (copy)
        local v19, v20

        if p9 == p10 then
            v20 = true
        elseif p9 then
            v19 = v18 and v8
            v20 = false
        else
            v20 = true
        end

        if v20 then
            return nil
        end

        v18 = false

        if v19 then
            return nil
        end

        local v21 = v6()

        if (if v21 == nil then v21 else v21.itemType) == "trainingWeight" then
            if selectTutorialStep(v5:getState()) == tutorialSteps.endWeightTraining then
                return nil
            end

            functions.unequipInventoryItem(v21.itemId)
        end
    end)
end

function self._startTraining(p11) -- line: 197
    -- upvalues: peek (copy), subscribe (copy), Maid (copy), functions (copy), animations (copy), barbellSoundSpeed (copy), frenzyTrainingSpeedMultiplier (copy), trainingAnimationSpeed (copy), trainingIntervalSeconds (copy), vipTrainingSpeedMultiplier (copy), trainingIsFrenzyAtom (copy), isInVipTrainingAreaAtom (copy)
    p11._maid:Destroy()
    p11._maid = Maid.new()

    local t4 = {
        current = nil
    }

    local function v22() -- line: 204
        -- upvalues: p11 (copy), t4 (copy), peek (copy), functions (copy), animations (copy), barbellSoundSpeed (copy), frenzyTrainingSpeedMultiplier (copy), trainingAnimationSpeed (copy), trainingIntervalSeconds (copy), vipTrainingSpeedMultiplier (copy), trainingIsFrenzyAtom (copy), isInVipTrainingAreaAtom (copy)
        if t4.current ~= nil then
            task.cancel(t4.current)
        end

        local v23 = peek(trainingIsFrenzyAtom)
        local v24 = peek(p11._ownsVipAtom)
        local v25 = peek(isInVipTrainingAreaAtom)
        local v26 = (if v23 then frenzyTrainingSpeedMultiplier else 1) * (if not v24 or not v25 then 1 else vipTrainingSpeedMultiplier)
        local v27 = trainingAnimationSpeed * v26
        local v28 = trainingIntervalSeconds / v26

        p11._characterController:playAnimation(animations.pistolSquatTraining, Enum.AnimationPriority.Action, nil, true, v27)
        t4.current = task.spawn(function() -- line: 215
            -- upvalues: v28 (copy), p11 (copy), functions (copy), barbellSoundSpeed (copy)
            while true do
                task.wait(v28)
                functions.trainingTick()
                p11._soundController:playSoundPolyphonic("BarbellSound", barbellSoundSpeed)
            end
        end)
    end

    v22()
    p11._maid:GiveTask(function() -- line: 224
        -- upvalues: t4 (copy)
        if t4.current ~= nil then
            task.cancel(t4.current)
        end
    end)

    local v29

    local function v30() -- line: 230
        -- upvalues: v29 (ref)
        if not v29 then
            return nil
        end

        for _, descendant in v29:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                descendant:Clear()
            elseif descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") then
                descendant.Enabled = false
            end
        end

        v29:Destroy()
        v29 = nil
    end

    p11._maid:GiveTask(v30)

    if peek(trainingIsFrenzyAtom) then
        v29 = p11:_attachFrenzyVfx()
    end

    p11._maid:GiveTask(subscribe(trainingIsFrenzyAtom, function(p12) -- line: 254
        -- upvalues: p11 (copy), v22 (copy), v29 (ref), v30 (copy)
        print((("[FRENZY DEBUG] weight-training-controller: trainingIsFrenzyAtom=%*, restarting runLoop"):format(p12)))
        v22()

        if not p12 then
            v30()

            return
        end

        p11._soundController:playSound("WLSScream")
        p11._soundController:playSound("AuraFarm")
        v30()
        v29 = p11:_attachFrenzyVfx()
    end))
    p11._maid:GiveTask(subscribe(p11._ownsVipAtom, function() -- line: 267
        -- upvalues: v22 (copy)
        return v22()
    end))
    p11._maid:GiveTask(subscribe(isInVipTrainingAreaAtom, function() -- line: 271
        -- upvalues: v22 (copy)
        return v22()
    end))
    p11._characterController:_disableMovement()
end

function self._attachFrenzyVfx(p13) -- line: 276
    -- upvalues: ReplicatedStorage (copy), setVFXEnabled (copy)
    local v31 = p13._characterController.character()

    if not v31 then
        return nil
    end

    local HumanoidRootPart = v31:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("TrainingWeights")

        if VFX ~= nil then
            VFX = VFX:FindFirstChild("AuraRig")
        end
    end

    if not (VFX and VFX:IsA("Model")) then
        return nil
    end

    local clone = VFX:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
            descendant.Anchored = true
            descendant.CanCollide = false
        end
    end

    clone:PivotTo(HumanoidRootPart.CFrame)
    clone.Parent = HumanoidRootPart
    setVFXEnabled(clone, true)

    return clone
end

function self._stopTraining(p14) -- line: 309
    -- upvalues: Maid (copy), animations (copy), fishingMovementLockedAtom (copy)
    p14._maid:Destroy()
    p14._maid = Maid.new()
    p14._characterController:stopAnimationsById({
        animations.pistolSquatTraining
    })

    if not fishingMovementLockedAtom() then
        p14._characterController:_enableMovement()
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/weight-training-controller@WeightTrainingController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/reflex-controller@ReflexController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    WeightTrainingController = self
}

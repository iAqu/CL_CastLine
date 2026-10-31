-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    none = 0,
    walkToDock = 1,
    catchAFish = 2,
    addFishToAquarium = 3,
    equipBestFish = 4,
    collectMoney = 5,
    levelUpFish = 6,
    closeAquarium = 7,
    goToWeightsShop = 8,
    trainPower = 9,
    endWeightTraining = 10,
    tutorialEnded = 11,
    completed = 12
}

return {
    tutorialTrainPowerTarget = 150,
    calculateTutorialStep = function(p1) -- calculateTutorialStep | line: 18
        -- upvalues: t1 (copy)
        local currentStep = p1.tutorialTracking.currentStep

        if currentStep > 0 then
            return currentStep
        end

        return t1.walkToDock
    end,
    tutorialSteps = t1
}

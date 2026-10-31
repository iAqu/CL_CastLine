-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils")
local fishingZonesList, getFishingZoneIndex = v1.fishingZonesList, v1.getFishingZoneIndex
local flightTriggerGateConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-trigger-gate-config").flightTriggerGateConfig
local t1 = {
    hoola1 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 157, 35)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 225)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 226, 64)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 157, 35))
    }),
    hoola2 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 157, 35)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 244, 130)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(225, 250, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(105, 255, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(133, 227, 255))
    }),
    hoola3 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 70)),
        ColorSequenceKeypoint.new(0.22, Color3.fromRGB(255, 250, 190)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 245)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(115, 255, 232)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 179, 222))
    })
}
local t2 = {
    enabled = true,
    tierOnePityThreshold = 300,
    tierTwoPityThreshold = 800,
    tierThreePityThreshold = 1600,
    acquisitionChanceCap = 0.6,
    tierOneWeight = 70,
    tierTwoWeight = 30,
    tierThreeWeightPerCombo = 1,
    tierThreeUnlockZone = "mythic",
    debugLogging = true,
    acquisitionChanceCapByZone = {
        epic = 0.1,
        godly = 0.35,
        cosmic = 0.65
    },
    cosmeticCashMultipliers = {
        hoola1 = 1.05,
        hoola2 = 1.05,
        hoola3 = 1.05
    },
    trainingPowerBonusByMutation = {
        hoola2 = 0.07,
        hoola3 = 0.07
    },
    mutationLuckBonusByMutation = {
        hoola3 = 0.1
    },
    displayGradients = t1,
    displayColors = {
        hoola1 = Color3.fromRGB(255, 226, 64),
        hoola2 = Color3.fromRGB(133, 227, 255),
        hoola3 = Color3.fromRGB(255, 179, 222)
    }
}

return {
    getHoolaMaximumRingCount = function() -- getHoolaMaximumRingCount | line: 50
        -- upvalues: fishingZonesList (copy), getFishingZoneIndex (copy), flightTriggerGateConfig (copy)
        return (math.max(0, #fishingZonesList - getFishingZoneIndex(flightTriggerGateConfig.firstZone)))
    end,
    getHoolaTierThreeMinimumCombo = function() -- getHoolaTierThreeMinimumCombo | line: 54
        -- upvalues: getFishingZoneIndex (copy), flightTriggerGateConfig (copy), t2 (copy)
        return (math.max(0, getFishingZoneIndex(t2.tierThreeUnlockZone) - getFishingZoneIndex(flightTriggerGateConfig.firstZone)))
    end,
    hoolaMutationDisplayGradients = t1,
    hoolaSystemConfig = t2
}

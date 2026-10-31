-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local weightImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").weightImages
local t1 = {
    equippedScale = 1,
    imageId = weightImages.steelBarbell
}
local TrainingWeights = ReplicatedStorage:FindFirstChild("TrainingWeights")

t1.model = if TrainingWeights ~= nil then TrainingWeights:FindFirstChild("SteelBarbell") else TrainingWeights
t1.name = "Steel Barbell"
t1.powerPerTrain = 3
t1.price = 0
t1.rarity = "common"
t1.robuxPrice = 0
t1.weightKg = 5

local t2 = {
    "SteelBarbell",
    t1
}
local t3 = {
    equippedScale = 1.1,
    imageId = weightImages.pufferFishBarbell
}
local TrainingWeights2 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t3.model = if TrainingWeights2 ~= nil then TrainingWeights2:FindFirstChild("PufferfishBarbell") else TrainingWeights2
t3.name = "Pufferfish Barbell"
t3.powerPerTrain = 100
t3.price = 50000
t3.rarity = "uncommon"
t3.robuxPrice = 29
t3.weightKg = 25

local t4 = {
    "PufferfishBarbell",
    t3
}
local t5 = {
    equippedScale = 1.2,
    imageId = weightImages.anchorBarbell
}
local TrainingWeights3 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t5.model = if TrainingWeights3 ~= nil then TrainingWeights3:FindFirstChild("AnchorBarbell") else TrainingWeights3
t5.name = "Anchor Barbell"
t5.powerPerTrain = 3000
t5.price = 3E+05
t5.rarity = "rare"
t5.robuxPrice = 49
t5.weightKg = 50

local t6 = {
    "AnchorBarbell",
    t5
}
local t7 = {
    equippedScale = 1.3,
    imageId = weightImages.shipWreckBarbell
}
local TrainingWeights4 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t7.model = if TrainingWeights4 ~= nil then TrainingWeights4:FindFirstChild("ShipwreckBarbell") else TrainingWeights4
t7.name = "Shipwreck Barbell"
t7.powerPerTrain = 30000
t7.price = 5E+06
t7.rarity = "epic"
t7.robuxPrice = 79
t7.weightKg = 100

local t8 = {
    "ShipwreckBarbell",
    t7
}
local t9 = {
    equippedScale = 1.4,
    imageId = weightImages.cardsBarbell
}
local TrainingWeights5 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t9.model = if TrainingWeights5 ~= nil then TrainingWeights5:FindFirstChild("CardsBarbell") else TrainingWeights5
t9.name = "Cards Barbell"
t9.powerPerTrain = 1E+05
t9.price = 2E+07
t9.rarity = "legendary"
t9.robuxPrice = 149
t9.weightKg = 300

local t10 = {
    "CardsBarbell",
    t9
}
local t11 = {
    equippedScale = 1.5,
    imageId = weightImages.krakenBarbell
}
local TrainingWeights6 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t11.model = if TrainingWeights6 ~= nil then TrainingWeights6:FindFirstChild("KrakenBarbell") else TrainingWeights6
t11.name = "Kraken Barbell"
t11.powerPerTrain = 1E+06
t11.price = 3.5E+07
t11.rarity = "mythic"
t11.robuxPrice = 299
t11.weightKg = 500

local t12 = {
    "KrakenBarbell",
    t11
}
local t13 = {
    equippedScale = 1.6,
    imageId = weightImages.poseidonBarbell
}
local TrainingWeights7 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t13.model = if TrainingWeights7 ~= nil then TrainingWeights7:FindFirstChild("PoseidonBarbell") else TrainingWeights7
t13.name = "Poseidon Barbell"
t13.powerPerTrain = 3E+06
t13.price = 8E+07
t13.rarity = "godly"
t13.robuxPrice = 399
t13.weightKg = 1000

local t14 = {
    "PoseidonBarbell",
    t13
}
local t15 = {
    equippedScale = 1.7,
    imageId = weightImages.diamondBarbell
}
local TrainingWeights8 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t15.model = if TrainingWeights8 ~= nil then TrainingWeights8:FindFirstChild("DiamondBarbell") else TrainingWeights8
t15.name = "Diamond Barbell"
t15.powerPerTrain = 5E+06
t15.price = 2E+08
t15.rarity = "secret"
t15.robuxPrice = 699
t15.weightKg = 3000

local t16 = {
    "DiamondBarbell",
    t15
}
local t17 = {
    equippedScale = 1.8,
    imageId = weightImages.blackholeBarbell
}
local TrainingWeights9 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t17.model = if TrainingWeights9 ~= nil then TrainingWeights9:FindFirstChild("BlackholeBarbell") else TrainingWeights9
t17.name = "Blackhole Barbell"
t17.powerPerTrain = 3E+07
t17.price = 1.2E+09
t17.rarity = "hacked"
t17.robuxPrice = 999
t17.weightKg = 10000

local t18 = {
    "BlackholeBarbell",
    t17
}
local t19 = {
    equippedScale = 2,
    imageId = weightImages.judgementBarbell
}
local TrainingWeights10 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t19.model = if TrainingWeights10 ~= nil then TrainingWeights10:FindFirstChild("JudgementBarbell") else TrainingWeights10
t19.name = "Judgement Barbell"
t19.powerPerTrain = 1E+08
t19.price = 3.75E+10
t19.rarity = "cosmic"
t19.robuxPrice = 1999
t19.weightKg = 50000

local t20 = {
    "JudgementBarbell",
    t19
}
local t21 = {
    equippedScale = 2.1,
    imageId = weightImages.primalBarbell
}
local TrainingWeights11 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t21.model = if TrainingWeights11 ~= nil then TrainingWeights11:FindFirstChild("PrimalBarbell") else TrainingWeights11
t21.name = "Primal Barbell"
t21.powerPerTrain = 3E+08
t21.price = 1E+12
t21.rarity = "extinct"
t21.robuxPrice = 2999
t21.weightKg = 2E+05

local t22 = {
    "PrimalBarbell",
    t21
}
local t23 = {
    equippedScale = 2.2,
    imageId = weightImages.uwuBarbell
}
local TrainingWeights12 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t23.model = if TrainingWeights12 ~= nil then TrainingWeights12:FindFirstChild("UwUBarbell") else TrainingWeights12
t23.name = "UwU Barbell"
t23.powerPerTrain = 1.2E+09
t23.price = 32445682451253
t23.rarity = "kaijuwu"
t23.robuxPrice = 4999
t23.weightKg = 1E+06

local t24 = {
    "UwuBarbell",
    t23
}
local t25 = {
    equippedScale = 2.3,
    imageId = weightImages.scifiBarbell
}
local TrainingWeights13 = ReplicatedStorage:FindFirstChild("TrainingWeights")

t25.model = if TrainingWeights13 ~= nil then TrainingWeights13:FindFirstChild("ScifiBarbell") else TrainingWeights13
t25.name = "SciFi Barbell"
t25.powerPerTrain = 4.8E+09
t25.price = 129782729805012
t25.rarity = "scifi"
t25.robuxPrice = 4999
t25.weightKg = 4E+06

local t26 = {}

for _, v1 in {
        t2,
        t4,
        t6,
        t8,
        t10,
        t12,
        t14,
        t16,
        t18,
        t20,
        t22,
        t24,
        { "ScifiBarbell", t25 }
    } do
    t26[v1[1]] = v1[2]
end

return {
    trainingIntervalSeconds = 0.5,
    trainingAnimationSpeed = 2,
    barbellSoundSpeed = 1,
    frenzyTrainingSpeedMultiplier = 2,
    trainingFrenzyDurationSeconds = 5,
    trainingFrenzyMinRefillSeconds = 1.5,
    trainingWeightsData = t26,
    trainingWeightOrder = {
        "SteelBarbell",
        "PufferfishBarbell",
        "AnchorBarbell",
        "ShipwreckBarbell",
        "CardsBarbell",
        "KrakenBarbell",
        "PoseidonBarbell",
        "DiamondBarbell",
        "BlackholeBarbell",
        "JudgementBarbell",
        "PrimalBarbell",
        "UwuBarbell",
        "ScifiBarbell"
    }
}

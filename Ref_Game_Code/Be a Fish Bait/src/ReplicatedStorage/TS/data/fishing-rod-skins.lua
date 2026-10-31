-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FishingRods = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage:FindFirstChild("FishingRods")

if FishingRods ~= nil then
    FishingRods = FishingRods:FindFirstChild("RodSkins")
end

local t1 = {
    imageId = "rbxassetid://84147411472326"
}

t1.model = if FishingRods == nil then FishingRods else FishingRods:FindFirstChild("FOMORodSkin")
t1.name = "FOMO Rod Skin"
t1.rarity = "legendary"

local t2 = {
    "FOMORodSkin",
    t1
}
local t3 = {
    imageId = "rbxassetid://127553234042745"
}

t3.model = if FishingRods == nil then FishingRods else FishingRods:FindFirstChild("MagmaRod")
t3.name = "Magma Rod"
t3.rarity = "godly"
t3.robuxPrice = 599

local t4 = {
    "MagmaRod",
    t3
}
local t5 = {
    imageId = "rbxassetid://76554592884663"
}

t5.model = if FishingRods == nil then FishingRods else FishingRods:FindFirstChild("ThunderchordRod")
t5.name = "Thunderchord Rod"
t5.rarity = "mythic"
t5.robuxPrice = 499

local t6 = {
    "ThunderchordRod",
    t5
}
local t7 = {
    imageId = "rbxassetid://104308451066150"
}

t7.model = if FishingRods ~= nil then FishingRods:FindFirstChild("ScifiRod") else FishingRods
t7.moneyPrice = 1E+06
t7.name = "Scifi Rod"
t7.rarity = "legendary"

local t8 = {}

for _, v1 in {
        t2,
        t4,
        t6,
        { "ScifiRod", t7 }
    } do
    t8[v1[1]] = v1[2]
end

return {
    fomoRodSkinId = "FOMORodSkin",
    magmaRodSkinId = "MagmaRod",
    thunderchordRodSkinId = "ThunderchordRod",
    scifiRodSkinId = "ScifiRod",
    fishingRodSkinsData = t8,
    fishingRodSkinOrder = { "MagmaRod", "ThunderchordRod", "ScifiRod", "FOMORodSkin" }
}

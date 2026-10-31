-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t1 = {
    equippedScale = 1,
    imageId = "rbxassetid://107751287391457"
}
local FishingRods = ReplicatedStorage:FindFirstChild("FishingRods")

t1.model = if FishingRods ~= nil then FishingRods:FindFirstChild("BambooRod") else FishingRods
t1.name = "Bamboo Rod"
t1.powerCap = 6000
t1.price = 0
t1.rarity = "common"
t1.robuxPrice = 0

local t2 = {
    "BambooRod",
    t1
}
local t3 = {
    equippedScale = 1.2,
    imageId = "rbxassetid://78210160075264"
}
local FishingRods2 = ReplicatedStorage:FindFirstChild("FishingRods")

t3.model = if FishingRods2 ~= nil then FishingRods2:FindFirstChild("GoldRod") else FishingRods2
t3.name = "Gold Rod"
t3.powerCap = 2E+05
t3.price = 45000
t3.rarity = "uncommon"
t3.robuxPrice = 29

local t4 = {
    "GoldRod",
    t3
}
local t5 = {
    equippedScale = 1.6,
    imageId = "rbxassetid://116655612250435"
}
local FishingRods3 = ReplicatedStorage:FindFirstChild("FishingRods")

t5.model = if FishingRods3 ~= nil then FishingRods3:FindFirstChild("AnchorRod") else FishingRods3
t5.name = "Anchor Rod"
t5.powerCap = 7E+06
t5.price = 270000
t5.rarity = "rare"
t5.robuxPrice = 49

local t6 = {
    "AnchorRod",
    t5
}
local t7 = {
    equippedScale = 1.42,
    imageId = "rbxassetid://83730727638973"
}
local FishingRods4 = ReplicatedStorage:FindFirstChild("FishingRods")

t7.model = if FishingRods4 ~= nil then FishingRods4:FindFirstChild("BassRod") else FishingRods4
t7.name = "Bass Rod"
t7.powerCap = 1E+08
t7.price = 4500000
t7.rarity = "epic"
t7.robuxPrice = 79

local t8 = {
    "BassRod",
    t7
}
local t9 = {
    equippedScale = 2.69,
    imageId = "rbxassetid://77350208662359"
}
local FishingRods5 = ReplicatedStorage:FindFirstChild("FishingRods")

t9.model = if FishingRods5 ~= nil then FishingRods5:FindFirstChild("TridentRod") else FishingRods5
t9.name = "Trident Rod"
t9.powerCap = 1.9E+09
t9.price = 1.8E+07
t9.rarity = "legendary"
t9.robuxPrice = 149

local t10 = {
    "TridentRod",
    t9
}
local t11 = {
    equippedScale = 1.84,
    imageId = "rbxassetid://111683731370990"
}
local FishingRods6 = ReplicatedStorage:FindFirstChild("FishingRods")

t11.model = if FishingRods6 ~= nil then FishingRods6:FindFirstChild("BloodthornRod") else FishingRods6
t11.name = "Bloodthorn Rod"
t11.powerCap = 2E+10
t11.price = 31500000
t11.rarity = "mythic"
t11.robuxPrice = 299

local t12 = {
    "BloodthornRod",
    t11
}
local t13 = {
    equippedScale = 2.27,
    imageId = "rbxassetid://114615975289991"
}
local FishingRods7 = ReplicatedStorage:FindFirstChild("FishingRods")

t13.model = if FishingRods7 ~= nil then FishingRods7:FindFirstChild("LavaCrystalRod") else FishingRods7
t13.name = "Lava Crystal Rod"
t13.powerCap = 2E+11
t13.price = 7.2E+07
t13.rarity = "godly"
t13.robuxPrice = 399

local t14 = {
    "LavaCrystalRod",
    t13
}
local t15 = {
    equippedScale = 3.11,
    imageId = "rbxassetid://87915678596016"
}
local FishingRods8 = ReplicatedStorage:FindFirstChild("FishingRods")

t15.model = if FishingRods8 ~= nil then FishingRods8:FindFirstChild("AngelRod") else FishingRods8
t15.name = "Angel Rod"
t15.powerCap = 2E+12
t15.price = 1.8E+08
t15.rarity = "secret"
t15.robuxPrice = 699

local t16 = {
    "AngelRod",
    t15
}
local t17 = {
    equippedScale = 3.5,
    imageId = "rbxassetid://77492207141648"
}
local FishingRods9 = ReplicatedStorage:FindFirstChild("FishingRods")

t17.model = if FishingRods9 ~= nil then FishingRods9:FindFirstChild("CosmicRod") else FishingRods9
t17.name = "Galactic Rod"
t17.powerCap = 2E+13
t17.price = 4.8E+09
t17.rarity = "hacked"
t17.robuxPrice = 999

local t18 = {
    "CosmicRod",
    t17
}
local t19 = {
    equippedScale = 3.8,
    imageId = "rbxassetid://124392113178679"
}
local FishingRods10 = ReplicatedStorage:FindFirstChild("FishingRods")

t19.model = if FishingRods10 ~= nil then FishingRods10:FindFirstChild("ExcaliburRod") else FishingRods10
t19.name = "Excalibur Rod"
t19.powerCap = 5E+14
t19.price = 1.5E+11
t19.rarity = "cosmic"
t19.robuxPrice = 1999

local t20 = {
    "ExcaliburRod",
    t19
}
local t21 = {
    equippedScale = 4.2,
    imageId = "rbxassetid://108833890495018"
}
local FishingRods11 = ReplicatedStorage:FindFirstChild("FishingRods")

t21.model = if FishingRods11 ~= nil then FishingRods11:FindFirstChild("PrimalRod") else FishingRods11
t21.name = "Primal Rod"
t21.powerCap = 5859340772225014
t21.price = 5E+12
t21.rarity = "extinct"
t21.robuxPrice = 2999

local t22 = {
    "PrimalRod",
    t21
}
local t23 = {
    equippedScale = 4.6,
    imageId = "rbxassetid://115396817838108"
}
local FishingRods12 = ReplicatedStorage:FindFirstChild("FishingRods")

t23.model = if FishingRods12 ~= nil then FishingRods12:FindFirstChild("UwURod") else FishingRods12
t23.name = "UwU Rod"
t23.powerCap = 7.23E+17
t23.price = 162228412256267
t23.rarity = "kaijuwu"
t23.robuxPrice = 4999

local t24 = {
    "UwuRod",
    t23
}
local t25 = {
    equippedScale = 4.1,
    imageId = "rbxassetid://80113095856270"
}
local FishingRods13 = ReplicatedStorage:FindFirstChild("FishingRods")

t25.model = if FishingRods13 ~= nil then FishingRods13:FindFirstChild("SaberRod") else FishingRods13
t25.name = "Saber Rod"
t25.powerCap = 4352832508179538000
t25.price = 324456824512534
t25.rarity = "scifi"
t25.robuxPrice = 4999

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
        { "SaberRod", t25 }
    } do
    t26[v1[1]] = v1[2]
end

return {
    fishingRodsData = t26,
    fishingRodOrder = {
        "BambooRod",
        "GoldRod",
        "AnchorRod",
        "BassRod",
        "TridentRod",
        "BloodthornRod",
        "LavaCrystalRod",
        "AngelRod",
        "CosmicRod",
        "ExcaliburRod",
        "PrimalRod",
        "UwuRod",
        "SaberRod"
    }
}

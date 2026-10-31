-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local charmTierConfigs = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").charmTierConfigs
local charmImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").charmImages
local premiumFomoCharmDeveloperProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").premiumFomoCharmDeveloperProductId

local function resolveCharmModelAtPath(p1) -- line: 8
    -- upvalues: ReplicatedStorage (copy)
    local v1 = ReplicatedStorage

    for _, v2 in p1 do
        v1 = v1:FindFirstChild(v2)

        if v1 == nil then
            return nil
        end
    end

    return if v1:IsA("Model") then v1 else nil
end

local t1 = {
    id = "fomo",
    displayName = "FOMO Charm",
    description = "A bright floating FOMO companion that follows you everywhere.",
    imageId = charmImages.fomo
}
local Charms = ReplicatedStorage:FindFirstChild("Charms")

t1.model = if Charms ~= nil then Charms:FindFirstChild("FOMOCharm") else Charms
t1.productId = 3605367452
t1.rarity = "rare"
t1.robuxPrice = 100
t1.followOffset = Vector3.new(0, 6, 5)
t1.followResponsiveness = 8
t1.hoverAmplitude = 0.3
t1.hoverSpeed = 2.2
t1.rotationSpeed = 0.35
t1.teleportDistance = 24

local t2 = {
    "fomo",
    t1
}
local t3 = {
    id = "premiumFomo",
    displayName = "Premium FOMO Charm",
    description = "A premium FOMO companion with a mythic presentation.",
    imageId = charmImages.premiumFomo
}
local Charms2 = ReplicatedStorage:FindFirstChild("Charms")

t3.model = if Charms2 ~= nil then Charms2:FindFirstChild("PremiumFOMOCharm") else Charms2
t3.productId = premiumFomoCharmDeveloperProductId
t3.rarity = "mythic"
t3.robuxPrice = 329
t3.followOffset = Vector3.new(0, 6, 5)
t3.followResponsiveness = 9
t3.hoverAmplitude = 0.36
t3.hoverSpeed = 2.4
t3.rotationSpeed = 0.45
t3.teleportDistance = 24

local t4 = {}

for _, v3 in {
        t2,
        { "premiumFomo", t3 },
        {
            "pearlfinPup",
            {
                id = "pearlfinPup",
                displayName = "Pearlfin Pup",
                description = "The Tier I Charm Attribute visual, unlocked at Rebirth 2.",
                productId = 0,
                rarity = "rare",
                robuxPrice = 0,
                followOffset = Vector3.new(0, 5, 5),
                followResponsiveness = 8,
                hoverAmplitude = 0.25,
                hoverSpeed = 2,
                rotationSpeed = 0.3,
                teleportDistance = 24,
                imageId = charmImages.pearlfinPup,
                model = resolveCharmModelAtPath(charmTierConfigs[1].charmModelPath)
            }
        },
        {
            "diamondShark",
            {
                id = "diamondShark",
                displayName = "Diamond Shark",
                description = "The Tier II Charm Attribute visual, unlocked at Rebirth 4.",
                productId = 0,
                rarity = "epic",
                robuxPrice = 0,
                followOffset = Vector3.new(0, 6, 5),
                followResponsiveness = 8,
                hoverAmplitude = 0.3,
                hoverSpeed = 2.2,
                rotationSpeed = 0.35,
                teleportDistance = 24,
                imageId = charmImages.diamondShark,
                model = resolveCharmModelAtPath(charmTierConfigs[2].charmModelPath)
            }
        },
        {
            "prismaticMegalodon",
            {
                id = "prismaticMegalodon",
                displayName = "Prismatic Megalodon",
                description = "The Tier III Charm Attribute visual, unlocked at Rebirth 6.",
                productId = 0,
                rarity = "legendary",
                robuxPrice = 0,
                followOffset = Vector3.new(0, 6, 6),
                followResponsiveness = 9,
                hoverAmplitude = 0.35,
                hoverSpeed = 2.3,
                rotationSpeed = 0.4,
                teleportDistance = 24,
                imageId = charmImages.prismaticMegalodon,
                model = resolveCharmModelAtPath(charmTierConfigs[3].charmModelPath)
            }
        },
        {
            "astralLeviathan",
            {
                id = "astralLeviathan",
                displayName = "Astral Leviathan",
                description = "The Tier IV Charm Attribute visual, unlocked at Rebirth 8.",
                productId = 0,
                rarity = "mythic",
                robuxPrice = 0,
                followOffset = Vector3.new(0, 6.5, 6),
                followResponsiveness = 9,
                hoverAmplitude = 0.4,
                hoverSpeed = 2.4,
                rotationSpeed = 0.45,
                teleportDistance = 24,
                imageId = charmImages.astralLeviathan,
                model = resolveCharmModelAtPath(charmTierConfigs[4].charmModelPath)
            }
        },
        {
            "eclipseWorldeater",
            {
                id = "eclipseWorldeater",
                displayName = "Eclipse Worldeater",
                description = "The Tier V Charm Attribute capstone visual, unlocked at Rebirth 10.",
                productId = 0,
                rarity = "godly",
                robuxPrice = 0,
                followOffset = Vector3.new(0, 7, 6),
                followResponsiveness = 10,
                hoverAmplitude = 0.45,
                hoverSpeed = 2.5,
                rotationSpeed = 0.5,
                teleportDistance = 24,
                imageId = charmImages.eclipseWorldeater,
                model = resolveCharmModelAtPath(charmTierConfigs[5].charmModelPath)
            }
        }
    } do
    t4[v3[1]] = v3[2]
end

local t5 = {
    "fomo",
    "premiumFomo",
    "pearlfinPup",
    "diamondShark",
    "prismaticMegalodon",
    "astralLeviathan",
    "eclipseWorldeater"
}

return {
    resolveCharmModelAtPath = resolveCharmModelAtPath,
    isCharmEquipSlot = function(p2) -- isCharmEquipSlot | line: 150
        if p2 == "skin" then
            return true
        end

        return p2 == "attributes"
    end,
    charmData = t4,
    charmOrder = t5
}

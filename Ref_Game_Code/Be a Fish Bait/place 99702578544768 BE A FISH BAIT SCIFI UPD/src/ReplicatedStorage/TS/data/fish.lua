-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, Workspace = services.ReplicatedStorage, services.Workspace
local fishImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").fishImages
local Fishes = ReplicatedStorage:FindFirstChild("Fishes")

local function getFishModel(p1, p2) -- line: 8
    -- upvalues: Fishes (copy)
    return Fishes:FindFirstChild(p1):FindFirstChild(p2)
end

local function getOptionalExclusiveFishModel(p3, p4) -- line: 11
    -- upvalues: Workspace (copy), Fishes (copy)
    local v1 = if p4 == nil then p3 else p4
    local v2 = Fishes

    if Fishes ~= nil then
        v2 = Fishes:FindFirstChild("Exclusive")
    end

    local v3 = if v2 == nil then v2 else v2:FindFirstChild(p3)
    local v4 = if v3 ~= nil then v3 elseif v2 == nil then v2 else v2:FindFirstChild(v1)

    if if v4 == nil then v4 else v4:IsA("Model") then
        return v4
    end

    local Mounts = Workspace:FindFirstChild("Mounts")
    local v5 = if Mounts == nil then Mounts else Mounts:FindFirstChild(p3)
    local v6 = if v5 ~= nil then v5 elseif Mounts == nil then Mounts else Mounts:FindFirstChild(v1)

    return if if v6 == nil then v6 else v6:IsA("Model") then v6 else nil
end

local t1 = {
    {
        name = "FishFlops",
        displayName = "Fish Flops",
        holdType = "normal",
        rarity = "common",
        despawnDurationSeconds = 180,
        moneyPerSecond = 9,
        model = Fishes:FindFirstChild("Common"):FindFirstChild("FishFlops"),
        imageId = fishImages.fishFlops
    },
    {
        name = "CardboardEel",
        displayName = "Cardboard Eel",
        holdType = "above",
        rarity = "common",
        despawnDurationSeconds = 180,
        moneyPerSecond = 11,
        model = Fishes:FindFirstChild("Common"):FindFirstChild("CardboardEel"),
        imageId = fishImages.cardboardEel
    },
    {
        name = "CardboardFish",
        displayName = "Cardboard Fish",
        holdType = "normal",
        rarity = "common",
        despawnDurationSeconds = 180,
        moneyPerSecond = 8,
        model = Fishes:FindFirstChild("Common"):FindFirstChild("CardboardFish"),
        imageId = fishImages.cardboardFish
    },
    {
        name = "CardboardRay",
        displayName = "Cardboard Ray",
        holdType = "normal",
        rarity = "common",
        despawnDurationSeconds = 180,
        moneyPerSecond = 12,
        model = Fishes:FindFirstChild("Common"):FindFirstChild("CardboardRay"),
        imageId = fishImages.cardboardRay
    },
    {
        name = "Catfish",
        displayName = "Catfish",
        holdType = "normal",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 100,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("Catfish"),
        imageId = fishImages.catfish
    },
    {
        name = "CatfishKing",
        displayName = "Catfish King",
        holdType = "normal",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 115,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("CatfishKing"),
        imageId = fishImages.catfishKing
    },
    {
        name = "ClownFish",
        displayName = "Clown Fish",
        holdType = "normal",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 116,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("ClownFish"),
        imageId = fishImages.clownFish
    },
    {
        name = "NoobFish",
        displayName = "Noob Fish",
        holdType = "normal",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 118,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("NoobFish"),
        imageId = fishImages.noobFish
    },
    {
        name = "Pepperayni",
        displayName = "Pepperayni",
        holdType = "above",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 120,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("Pepperayni"),
        imageId = fishImages.pepperyani
    },
    {
        name = "TacoEel",
        displayName = "Taco Eel",
        holdType = "above",
        rarity = "uncommon",
        despawnDurationSeconds = 120,
        moneyPerSecond = 110,
        model = Fishes:FindFirstChild("Uncommon"):FindFirstChild("TacoEel"),
        imageId = fishImages.tacoEel
    },
    {
        name = "Dolphin",
        displayName = "Dolphin",
        holdType = "above",
        rarity = "rare",
        despawnDurationSeconds = 90,
        moneyPerSecond = 285,
        model = Fishes:FindFirstChild("Rare"):FindFirstChild("Dolphin"),
        imageId = fishImages.dolphin
    },
    {
        name = "PinkDolphin",
        displayName = "Pink Dolphin",
        holdType = "above",
        rarity = "rare",
        despawnDurationSeconds = 90,
        moneyPerSecond = 293,
        model = Fishes:FindFirstChild("Rare"):FindFirstChild("PinkDolphin"),
        imageId = fishImages.pinkDolphin
    },
    {
        name = "SeahorseWarrior",
        displayName = "Seahorse Warrior",
        holdType = "normal",
        rarity = "rare",
        despawnDurationSeconds = 90,
        moneyPerSecond = 300,
        model = Fishes:FindFirstChild("Rare"):FindFirstChild("SeahorseWarrior"),
        imageId = fishImages.seahorseWarrior
    },
    {
        name = "Wavy",
        displayName = "Wavy",
        holdType = "above",
        rarity = "rare",
        despawnDurationSeconds = 90,
        moneyPerSecond = 308,
        model = Fishes:FindFirstChild("Rare"):FindFirstChild("Wavy"),
        imageId = fishImages.wavy
    },
    {
        name = "Cat",
        displayName = "Cat",
        holdType = "normal",
        rarity = "rare",
        despawnDurationSeconds = 90,
        moneyPerSecond = 315,
        model = Fishes:FindFirstChild("Rare"):FindFirstChild("Cat"),
        imageId = fishImages.cat
    },
    {
        name = "Blade",
        displayName = "Blade",
        holdType = "above",
        rarity = "epic",
        despawnDurationSeconds = 60,
        moneyPerSecond = 750,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("Blade"),
        imageId = fishImages.blade
    },
    {
        name = "CrimsonBlade",
        displayName = "Crimson Blade",
        holdType = "above",
        rarity = "epic",
        despawnDurationSeconds = 60,
        moneyPerSecond = 800,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("CrimsonBlade"),
        imageId = fishImages.crimsonBlade
    },
    {
        name = "Duck",
        displayName = "Duck",
        holdType = "normal",
        rarity = "epic",
        despawnDurationSeconds = 60,
        moneyPerSecond = 810,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("Duck"),
        imageId = fishImages.duck
    },
    {
        name = "FishFish",
        displayName = "Fish Fish",
        holdType = "above",
        rarity = "epic",
        despawnDurationSeconds = 60,
        moneyPerSecond = 815,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("FishFish"),
        imageId = fishImages.fishFish
    },
    {
        name = "Orca",
        displayName = "Orca",
        holdType = "above",
        rarity = "epic",
        despawnDurationSeconds = 60,
        moneyPerSecond = 825,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("Orca"),
        imageId = fishImages.orca
    },
    {
        name = "SeahorseGhost",
        displayName = "Seahorse Ghost",
        holdType = "normal",
        rarity = "epic",
        noNaturalSpawn = true,
        despawnDurationSeconds = 60,
        moneyPerSecond = 835,
        model = Fishes:FindFirstChild("Epic"):FindFirstChild("SeahorseGhost"),
        imageId = fishImages.seahorseGhost
    },
    {
        name = "Blueflare",
        displayName = "Blueflare",
        holdType = "above",
        rarity = "cosmic",
        despawnDurationSeconds = 30,
        moneyPerSecond = 325000,
        model = Fishes:FindFirstChild("Cosmic"):FindFirstChild("Blueflare"),
        imageId = fishImages.blueflare
    },
    {
        name = "DemonShark",
        displayName = "Demon Shark",
        holdType = "above",
        rarity = "cosmic",
        despawnDurationSeconds = 30,
        moneyPerSecond = 310000,
        model = Fishes:FindFirstChild("Cosmic"):FindFirstChild("DemonShark"),
        imageId = fishImages.demonShark
    },
    {
        name = "Leviathan",
        displayName = "Leviathan",
        holdType = "above",
        rarity = "cosmic",
        despawnDurationSeconds = 30,
        moneyPerSecond = 3E+05,
        model = Fishes:FindFirstChild("Cosmic"):FindFirstChild("Leviathan"),
        imageId = fishImages.leviathan
    },
    {
        name = "PoppyShark",
        displayName = "Poppy Shark",
        holdType = "above",
        rarity = "cosmic",
        despawnDurationSeconds = 30,
        moneyPerSecond = 350000,
        model = Fishes:FindFirstChild("Cosmic"):FindFirstChild("PoppyShark"),
        imageId = fishImages.poppyShark
    },
    {
        name = "Devourer",
        displayName = "Devourer",
        holdType = "above",
        rarity = "cosmic",
        despawnDurationSeconds = 30,
        moneyPerSecond = 4E+05,
        model = Fishes:FindFirstChild("Cosmic"):FindFirstChild("Devourer"),
        imageId = fishImages.devourer
    },
    {
        name = "DevilFlare",
        displayName = "Devil Flare",
        holdType = "above",
        rarity = "hacked",
        despawnDurationSeconds = 30,
        moneyPerSecond = 140000,
        model = Fishes:FindFirstChild("Hacked"):FindFirstChild("DevilFlare"),
        imageId = fishImages.devilFlare
    },
    {
        name = "EnviReynard",
        displayName = "EnviReynard",
        holdType = "above",
        rarity = "hacked",
        despawnDurationSeconds = 30,
        moneyPerSecond = 125000,
        model = Fishes:FindFirstChild("Hacked"):FindFirstChild("EnviReynard"),
        imageId = fishImages.enviReynard
    },
    {
        name = "LightLeviathan",
        displayName = "Light Leviathan",
        holdType = "above",
        rarity = "hacked",
        despawnDurationSeconds = 30,
        moneyPerSecond = 130000,
        model = Fishes:FindFirstChild("Hacked"):FindFirstChild("LightLeviathan"),
        imageId = fishImages.lightLeviathan
    },
    {
        name = "Reynard",
        displayName = "Reynard",
        holdType = "above",
        rarity = "hacked",
        despawnDurationSeconds = 30,
        moneyPerSecond = 120000,
        model = Fishes:FindFirstChild("Hacked"):FindFirstChild("Reynard"),
        imageId = fishImages.reynard
    },
    {
        name = "WarKiller",
        displayName = "War Killer",
        holdType = "above",
        rarity = "hacked",
        despawnDurationSeconds = 30,
        moneyPerSecond = 135000,
        model = Fishes:FindFirstChild("Hacked"):FindFirstChild("WarKiller"),
        imageId = fishImages.warKiller
    },
    {
        name = "Berrywhal",
        displayName = "Berrywhal",
        holdType = "above",
        rarity = "mythic",
        despawnDurationSeconds = 45,
        moneyPerSecond = 7250,
        model = Fishes:FindFirstChild("Mythic"):FindFirstChild("Berrywhal"),
        imageId = fishImages.berrywhal
    },
    {
        name = "Lapla",
        displayName = "Lapla",
        holdType = "above",
        rarity = "mythic",
        despawnDurationSeconds = 45,
        moneyPerSecond = 7450,
        model = Fishes:FindFirstChild("Mythic"):FindFirstChild("Lapla"),
        imageId = fishImages.lapla
    },
    {
        name = "Megaladon",
        displayName = "Megaladon",
        holdType = "above",
        rarity = "mythic",
        despawnDurationSeconds = 45,
        moneyPerSecond = 8000,
        model = Fishes:FindFirstChild("Mythic"):FindFirstChild("Megaladon"),
        imageId = fishImages.megaladon
    },
    {
        name = "Plesiosaur",
        displayName = "Plesiosaur",
        holdType = "above",
        rarity = "mythic",
        despawnDurationSeconds = 45,
        moneyPerSecond = 7650,
        model = Fishes:FindFirstChild("Mythic"):FindFirstChild("Plesiosaur"),
        imageId = fishImages.plesiosaur
    },
    {
        name = "Cow",
        displayName = "Cow",
        holdType = "above",
        rarity = "mythic",
        despawnDurationSeconds = 45,
        moneyPerSecond = 7800,
        model = Fishes:FindFirstChild("Mythic"):FindFirstChild("Cow"),
        imageId = fishImages.cow
    },
    {
        name = "Berrypla",
        displayName = "Berrypla",
        holdType = "above",
        rarity = "legendary",
        despawnDurationSeconds = 45,
        moneyPerSecond = 2500,
        model = Fishes:FindFirstChild("Legendary"):FindFirstChild("Berrypla"),
        imageId = fishImages.berrypla
    },
    {
        name = "GreyShark",
        displayName = "Grey Shark",
        holdType = "above",
        rarity = "legendary",
        despawnDurationSeconds = 45,
        moneyPerSecond = 2550,
        model = Fishes:FindFirstChild("Legendary"):FindFirstChild("GreyShark"),
        imageId = fishImages.greyShark
    },
    {
        name = "MJFish",
        displayName = "MJ Fish",
        holdType = "above",
        rarity = "legendary",
        despawnDurationSeconds = 45,
        moneyPerSecond = 2800,
        model = Fishes:FindFirstChild("Legendary"):FindFirstChild("MJFish"),
        imageId = fishImages.mjFish
    },
    {
        name = "Narwhal",
        displayName = "Narwhal",
        holdType = "above",
        rarity = "legendary",
        despawnDurationSeconds = 45,
        moneyPerSecond = 2400,
        model = Fishes:FindFirstChild("Legendary"):FindFirstChild("Narwhal"),
        imageId = fishImages.narwhal
    },
    {
        name = "TigerShark",
        displayName = "Tiger Shark",
        holdType = "above",
        rarity = "legendary",
        despawnDurationSeconds = 45,
        moneyPerSecond = 2500,
        model = Fishes:FindFirstChild("Legendary"):FindFirstChild("TigerShark"),
        imageId = fishImages.tigerSharkLegendary
    },
    {
        name = "FrostTooth",
        displayName = "Frost Tooth",
        holdType = "above",
        rarity = "godly",
        despawnDurationSeconds = 35,
        moneyPerSecond = 19000,
        model = Fishes:FindFirstChild("Godly"):FindFirstChild("FrostTooth"),
        imageId = fishImages.frostTooth
    },
    {
        name = "HandsomeShark",
        displayName = "Handsome Shark",
        holdType = "above",
        rarity = "godly",
        despawnDurationSeconds = 35,
        moneyPerSecond = 20000,
        model = Fishes:FindFirstChild("Godly"):FindFirstChild("HandsomeShark"),
        imageId = fishImages.handsomeShark
    },
    {
        name = "MechShark",
        displayName = "Mech Shark",
        holdType = "above",
        rarity = "godly",
        despawnDurationSeconds = 35,
        moneyPerSecond = 23000,
        model = Fishes:FindFirstChild("Godly"):FindFirstChild("MechShark"),
        imageId = fishImages.mechShark
    },
    {
        name = "Sunfish",
        displayName = "Sunfish",
        holdType = "above",
        rarity = "godly",
        despawnDurationSeconds = 35,
        moneyPerSecond = 22000,
        model = Fishes:FindFirstChild("Godly"):FindFirstChild("Sunfish"),
        imageId = fishImages.sunfish
    },
    {
        name = "AbyssWhale",
        displayName = "Abyss Whale",
        holdType = "above",
        rarity = "secret",
        despawnDurationSeconds = 30,
        moneyPerSecond = 51000,
        model = Fishes:FindFirstChild("Secret"):FindFirstChild("AbyssWhale"),
        imageId = fishImages.abyssWhale
    },
    {
        name = "AnglerFish",
        displayName = "Angler Fish",
        holdType = "above",
        rarity = "secret",
        despawnDurationSeconds = 30,
        moneyPerSecond = 46000,
        model = Fishes:FindFirstChild("Secret"):FindFirstChild("AnglerFish"),
        imageId = fishImages.anglerFish
    },
    {
        name = "LavaWhale",
        displayName = "Lava Whale",
        holdType = "above",
        rarity = "secret",
        despawnDurationSeconds = 30,
        moneyPerSecond = 50000,
        model = Fishes:FindFirstChild("Secret"):FindFirstChild("LavaWhale"),
        imageId = fishImages.lavaWhale
    },
    {
        name = "SkyWhale",
        displayName = "Sky Whale",
        holdType = "above",
        rarity = "secret",
        despawnDurationSeconds = 30,
        moneyPerSecond = 47500,
        model = Fishes:FindFirstChild("Secret"):FindFirstChild("SkyWhale"),
        imageId = fishImages.skyWhale
    },
    {
        name = "CapybaraSecret",
        displayName = "Capybara",
        holdType = "above",
        rarity = "secret",
        despawnDurationSeconds = 30,
        moneyPerSecond = 52500,
        model = Fishes:FindFirstChild("Secret"):FindFirstChild("Capybara"),
        imageId = fishImages.capybaraSecret
    },
    {
        name = "Verdantus",
        displayName = "Verdantus",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 950000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Verdantus"),
        imageId = fishImages.Verdantus
    },
    {
        name = "Velociraptor",
        displayName = "Velociraptor",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 980000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Velociraptor"),
        imageId = fishImages.velociraptor
    },
    {
        name = "Torter",
        displayName = "Torter",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1E+06,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Torter"),
        imageId = fishImages.torter
    },
    {
        name = "Stegosaurus",
        displayName = "Stegosaurus",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1020000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Stegosaurus"),
        imageId = fishImages.stegosaurus
    },
    {
        name = "Stalker",
        displayName = "Stalker",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1050000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Stalker"),
        imageId = fishImages.stalker
    },
    {
        name = "ArmyRex",
        displayName = "Army Rex",
        holdType = "above",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1080000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("ArmyRex"),
        imageId = fishImages.armyRex
    },
    {
        name = "Ankylosaurus",
        displayName = "Ankylosaurus",
        holdType = "normal",
        rarity = "extinct",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1100000,
        model = Fishes:FindFirstChild("Extinct"):FindFirstChild("Ankylosaurus"),
        imageId = fishImages.ankylosaurus
    },
    {
        name = "Cthuwu",
        displayName = "CthUwU",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 15400000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Cthuwu"),
        imageId = fishImages.cthuWu
    },
    {
        name = "Gigachonk",
        displayName = "Gigachonk",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 16100000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Gigachonk"),
        imageId = fishImages.gigachonk
    },
    {
        name = "LilMenace",
        displayName = "Lil Menace",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 1.4E+07,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("LilMenace"),
        imageId = fishImages.lilMenace
    },
    {
        name = "Goatzilla",
        displayName = "Goatzilla",
        holdType = "above",
        rarity = "kaijuwu",
        nonExclusiveBossOnly = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 19600000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Goatzilla"),
        imageId = fishImages.goatzilla
    },
    {
        name = "Squidweird",
        displayName = "Squidweird",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 18200000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Squidweird"),
        imageId = fishImages.squidweird
    },
    {
        name = "Yapviathan",
        displayName = "Yapviathan",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 16800000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Yapviathan"),
        imageId = fishImages.yapviathan
    },
    {
        name = "Chillagator",
        displayName = "Chillagator",
        holdType = "above",
        rarity = "kaijuwu",
        despawnDurationSeconds = 30,
        moneyPerSecond = 16380000,
        model = Fishes:FindFirstChild("Kaijuwu"):FindFirstChild("Chillagator"),
        imageId = fishImages.chillagator
    },
    {
        name = "Piranha",
        displayName = "Plasma Piranha",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 7E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("Piranha"),
        imageId = fishImages.piranha
    },
    {
        name = "ScifiFiot2",
        displayName = "Neon Ray",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 7.7E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("Scifi Fiot2"),
        imageId = fishImages.scifiFiot2
    },
    {
        name = "MedusaColor",
        displayName = "Prism Jellyfish",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 80500000,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("MedusaColor"),
        imageId = fishImages.medusaColor
    },
    {
        name = "Peixe1",
        displayName = "Quantum Koi",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 8.4E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("Peixe1"),
        imageId = fishImages.peixe1
    },
    {
        name = "ScifiShark",
        displayName = "Voidfin Shark",
        holdType = "above",
        rarity = "scifi",
        nonExclusiveBossOnly = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 9.8E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("ScifiShark"),
        imageId = fishImages.shark
    },
    {
        name = "SuperPiranha",
        displayName = "Titan Piranha",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 87500000,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("SuperPiranha"),
        imageId = fishImages.superPiranha
    },
    {
        name = "Saberfish",
        displayName = "Ion Saberfish",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 9.1E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("Saberfish"),
        imageId = fishImages.saberfish
    },
    {
        name = "CyborgShark",
        displayName = "Cybernetic Shark",
        holdType = "above",
        rarity = "scifi",
        despawnDurationSeconds = 30,
        moneyPerSecond = 8.4E+07,
        model = Fishes:FindFirstChild("Scifi"):FindFirstChild("Cyborg Shark"),
        imageId = fishImages.cyborgShark
    },
    {
        name = "Phoenix",
        displayName = "Phoenix",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = Fishes:FindFirstChild("Exclusive"):FindFirstChild("Phoenix"),
        imageId = fishImages.phoenix
    },
    {
        name = "ApexTyrant",
        displayName = "Apex Tyrant",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = Fishes:FindFirstChild("Exclusive"):FindFirstChild("ApexTyrant"),
        imageId = fishImages.apexTyrant
    },
    {
        name = "FlameLord",
        displayName = "Flame Lord",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = Fishes:FindFirstChild("Exclusive"):FindFirstChild("FlameLord"),
        imageId = fishImages.flameLord
    },
    {
        name = "Frostwyrm",
        displayName = "Frostwyrm",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = Fishes:FindFirstChild("Exclusive"):FindFirstChild("Frostwyrm"),
        imageId = fishImages.frostwyrm
    },
    {
        name = "UncThulu",
        displayName = "Unc-thulu",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = getOptionalExclusiveFishModel("UncThulu", "Unc-thulu"),
        imageId = fishImages.uncThulu
    },
    {
        name = "AuraMaximus",
        displayName = "Aura Maximus",
        holdType = "normal",
        rarity = "exclusive",
        noNaturalSpawn = true,
        despawnDurationSeconds = 30,
        moneyPerSecond = 0,
        model = getOptionalExclusiveFishModel("AuraMaximus"),
        imageId = fishImages.auraMaximus
    }
}
local t2 = {
    common = {},
    uncommon = {},
    rare = {},
    epic = {},
    legendary = {},
    mythic = {},
    godly = {},
    secret = {},
    hacked = {},
    cosmic = {},
    extinct = {},
    kaijuwu = {},
    scifi = {},
    exclusive = {}
}

for _, v7 in t1 do
    if not v7.noNaturalSpawn and not v7.nonExclusiveBossOnly then
        table.insert(t2[v7.rarity], v7)
    end
end

local t3 = {
    {
        name = "BonusFish",
        displayName = "Bonus Fish",
        rarity = "bonusFish",
        model = Fishes:FindFirstChild("Bonus"):FindFirstChild("BonusFish"),
        imageId = fishImages.bonusFish
    }
}

local function isFishData(p5) -- line: 803
    return p5.rarity ~= "bonusFish"
end

local t4 = {}
local v9 = #t4
local v10 = table.create(#t1)

local function v11(p6) -- line: 810
    return {
        p6.name,
        p6
    }
end

for v12, v13 in t1 do
    local _ = v12 - 1

    v10[v12] = {
        v13.name,
        v13
    }
end

local v14 = #v10

table.move(v10, 1, v14, v9 + 1, t4)

local v15 = v9 + v14
local v16 = table.create(#t3)

local function v17(p7) -- line: 822
    return {
        p7.name,
        p7
    }
end

for v18, v19 in t3 do
    local _ = v18 - 1

    v16[v18] = {
        v19.name,
        v19
    }
end

table.move(v16, 1, #v16, v15 + 1, t4)

local t5 = {}

for _, v20 in t4 do
    t5[v20[1]] = v20[2]
end

return {
    minFishPerZone = 5,
    maxFishPerZone = 5,
    apexFishNaturalSpawnChance = 0.05,
    isFishData = isFishData,
    allFishData = t1,
    fishDataByRarity = t2,
    bonusFishData = t3,
    fishDataByName = t5
}

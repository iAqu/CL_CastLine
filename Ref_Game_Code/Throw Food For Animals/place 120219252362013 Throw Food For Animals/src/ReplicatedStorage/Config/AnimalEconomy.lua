-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    List = {
        Snail = {
            Area = "Forest",
            Rank = 1,
            Rarity = "Common",
            Income = 1,
            Weight = 0.025
        },
        Frog = {
            Area = "Forest",
            Rank = 2,
            Rarity = "Common",
            Income = 2,
            Weight = 0.03
        },
        Bunny = {
            Area = "Forest",
            Rank = 3,
            Rarity = "Common",
            Income = 3,
            Weight = 1.8
        },
        Owl = {
            Area = "Forest",
            Rank = 4,
            Rarity = "Uncommon",
            Income = 5,
            Weight = 1.4
        },
        Kookaburra = {
            Area = "Forest",
            Rank = 5,
            Rarity = "Uncommon",
            Income = 8,
            Weight = 0.35
        },
        Badger = {
            Area = "Forest",
            Rank = 6,
            Rarity = "Uncommon",
            Income = 12,
            Weight = 12
        },
        Cow = {
            Area = "Forest",
            Rank = 7,
            Rarity = "Rare",
            Income = 18,
            Weight = 700
        },
        Pony = {
            Area = "Forest",
            Rank = 8,
            Rarity = "Epic",
            Income = 25,
            Weight = 300
        },
        Ostrich = {
            Area = "Savana",
            Rank = 1,
            Rarity = "Common",
            Income = 40,
            Weight = 110
        },
        Quokka = {
            Area = "Savana",
            Rank = 2,
            Rarity = "Common",
            Income = 80,
            Weight = 3
        },
        Giraffee = {
            Area = "Savana",
            Rank = 3,
            Rarity = "Uncommon",
            Income = 120,
            Weight = 1100
        },
        Hyena = {
            Area = "Savana",
            Rank = 4,
            Rarity = "Uncommon",
            Income = 200,
            Weight = 60
        },
        Zebra = {
            Area = "Savana",
            Rank = 5,
            Rarity = "Uncommon",
            Income = 320,
            Weight = 350
        },
        Aardvark = {
            Area = "Savana",
            Rank = 6,
            Rarity = "Rare",
            Income = 480,
            Weight = 60
        },
        Elephant = {
            Area = "Savana",
            Rank = 7,
            Rarity = "Rare",
            Income = 720,
            Weight = 5000
        },
        Lion = {
            Area = "Savana",
            Rank = 8,
            Rarity = "Epic",
            Income = 1000,
            Weight = 190
        },
        Hamster = {
            Area = "Desert",
            Rank = 1,
            Rarity = "Common",
            Income = 1500,
            Weight = 0.12
        },
        StymphalianBird = {
            Area = "Desert",
            Rank = 2,
            Rarity = "Uncommon",
            Income = 3000,
            Weight = 4
        },
        Emu = {
            Area = "Desert",
            Rank = 3,
            Rarity = "Uncommon",
            Income = 4500,
            Weight = 40
        },
        Snake = {
            Area = "Desert",
            Rank = 4,
            Rarity = "Uncommon",
            Income = 7500,
            Weight = 2.5
        },
        Dingo = {
            Area = "Desert",
            Rank = 5,
            Rarity = "Rare",
            Income = 12000,
            Weight = 16
        },
        Jackal = {
            Area = "Desert",
            Rank = 6,
            Rarity = "Rare",
            Income = 18000,
            Weight = 10
        },
        Horse = {
            Area = "Desert",
            Rank = 7,
            Rarity = "Epic",
            Income = 27000,
            Weight = 500
        },
        Kangaroo = {
            Area = "Desert",
            Rank = 8,
            Rarity = "Epic",
            Income = 38000,
            Weight = 60
        },
        Lizard = {
            Area = "Jungle",
            Rank = 1,
            Rarity = "Uncommon",
            Income = 60000,
            Weight = 0.3
        },
        Bat = {
            Area = "Jungle",
            Rank = 2,
            Rarity = "Uncommon",
            Income = 120000,
            Weight = 0.05
        },
        Parrot = {
            Area = "Jungle",
            Rank = 3,
            Rarity = "Uncommon",
            Income = 180000,
            Weight = 0.9
        },
        Koala = {
            Area = "Jungle",
            Rank = 4,
            Rarity = "Rare",
            Income = 3E+05,
            Weight = 9
        },
        Cobra = {
            Area = "Jungle",
            Rank = 5,
            Rarity = "Rare",
            Income = 480000,
            Weight = 6
        },
        Crocodile = {
            Area = "Jungle",
            Rank = 6,
            Rarity = "Epic",
            Income = 720000,
            Weight = 500
        },
        Tiger = {
            Area = "Jungle",
            Rank = 7,
            Rarity = "Epic",
            Income = 1100000,
            Weight = 220
        },
        Gorilla = {
            Area = "Jungle",
            Rank = 8,
            Rarity = "Legendary",
            Income = 1500000,
            Weight = 160
        },
        Crab = {
            Area = "Ocean",
            Rank = 1,
            Rarity = "Uncommon",
            Income = 2500000,
            Weight = 0.5
        },
        Turtle = {
            Area = "Ocean",
            Rank = 2,
            Rarity = "Uncommon",
            Income = 5E+06,
            Weight = 150
        },
        Jellyfish = {
            Area = "Ocean",
            Rank = 3,
            Rarity = "Rare",
            Income = 7500000,
            Weight = 2
        },
        GoblinShark = {
            Area = "Ocean",
            Rank = 4,
            Rarity = "Rare",
            Income = 1.2E+07,
            Weight = 200
        },
        Seahorse = {
            Area = "Ocean",
            Rank = 5,
            Rarity = "Epic",
            Income = 2E+07,
            Weight = 0.008
        },
        MantisShrimp = {
            Area = "Ocean",
            Rank = 6,
            Rarity = "Epic",
            Income = 3E+07,
            Weight = 0.1
        },
        LeafySeaDragon = {
            Area = "Ocean",
            Rank = 7,
            Rarity = "Legendary",
            Income = 4.5E+07,
            Weight = 0.08
        },
        Seal = {
            Area = "Ocean",
            Rank = 8,
            Rarity = "Legendary",
            Income = 6.2E+07,
            Weight = 120
        },
        Llama = {
            Area = "Mountains",
            Rank = 1,
            Rarity = "Uncommon",
            Income = 1E+08,
            Weight = 130
        },
        GuiennaPig = {
            Area = "Mountains",
            Rank = 2,
            Rarity = "Rare",
            Income = 2E+08,
            Weight = 1
        },
        Roc = {
            Area = "Mountains",
            Rank = 3,
            Rarity = "Rare",
            Income = 3E+08,
            Weight = 1500
        },
        Capybara = {
            Area = "Mountains",
            Rank = 4,
            Rarity = "Epic",
            Income = 5E+08,
            Weight = 50
        },
        Thunderbird = {
            Area = "Mountains",
            Rank = 5,
            Rarity = "Epic",
            Income = 8E+08,
            Weight = 400
        },
        Bull = {
            Area = "Mountains",
            Rank = 6,
            Rarity = "Legendary",
            Income = 1.2E+09,
            Weight = 900
        },
        Yak = {
            Area = "Mountains",
            Rank = 7,
            Rarity = "Legendary",
            Income = 1.8E+09,
            Weight = 700
        },
        Griffin = {
            Area = "Mountains",
            Rank = 8,
            Rarity = "Mythic",
            Income = 2.5E+09,
            Weight = 600
        },
        HoneyBadger = {
            Area = "Taiga",
            Rank = 1,
            Rarity = "Rare",
            Income = 4E+09,
            Weight = 10
        },
        Cockatrice = {
            Area = "Taiga",
            Rank = 2,
            Rarity = "Rare",
            Income = 8E+09,
            Weight = 30
        },
        Caracal = {
            Area = "Taiga",
            Rank = 3,
            Rarity = "Epic",
            Income = 1.2E+10,
            Weight = 14
        },
        Wolf = {
            Area = "Taiga",
            Rank = 4,
            Rarity = "Epic",
            Income = 2E+10,
            Weight = 45
        },
        Jackalope = {
            Area = "Taiga",
            Rank = 5,
            Rarity = "Legendary",
            Income = 3.2E+10,
            Weight = 3
        },
        Bear = {
            Area = "Taiga",
            Rank = 6,
            Rarity = "Legendary",
            Income = 4.8E+10,
            Weight = 300
        },
        Kitsune = {
            Area = "Taiga",
            Rank = 7,
            Rarity = "Mythic",
            Income = 7.2E+10,
            Weight = 8
        },
        Fenrir = {
            Area = "Taiga",
            Rank = 8,
            Rarity = "Mythic",
            Income = 1E+11,
            Weight = 800
        },
        GoldenRetriver = {
            Area = "Winter",
            Rank = 1,
            Rarity = "Rare",
            Income = 1.5E+11,
            Weight = 32
        },
        Goat = {
            Area = "Winter",
            Rank = 2,
            Rarity = "Epic",
            Income = 3E+11,
            Weight = 60
        },
        Tanuki = {
            Area = "Winter",
            Rank = 3,
            Rarity = "Epic",
            Income = 4.5E+11,
            Weight = 6
        },
        Caladrius = {
            Area = "Winter",
            Rank = 4,
            Rarity = "Legendary",
            Income = 7.5E+11,
            Weight = 2
        },
        ["Polar Bear"] = {
            Area = "Winter",
            Rank = 5,
            Rarity = "Legendary",
            Income = 1.2E+12,
            Weight = 450
        },
        Mamoth = {
            Area = "Winter",
            Rank = 6,
            Rarity = "Mythic",
            Income = 1.8E+12,
            Weight = 6000
        },
        Lindworm = {
            Area = "Winter",
            Rank = 7,
            Rarity = "Mythic",
            Income = 2.7E+12,
            Weight = 900
        },
        SaberToothedTiger = {
            Area = "Winter",
            Rank = 8,
            Rarity = "Secret",
            Income = 3.8E+12,
            Weight = 300
        },
        Pterodactyl = {
            Area = "PrehistoricForest",
            Rank = 1,
            Rarity = "Epic",
            Income = 6E+12,
            Weight = 20
        },
        Triceratops = {
            Area = "PrehistoricForest",
            Rank = 2,
            Rarity = "Epic",
            Income = 1.2E+13,
            Weight = 8000
        },
        Dimetrodon = {
            Area = "PrehistoricForest",
            Rank = 3,
            Rarity = "Legendary",
            Income = 1.8E+13,
            Weight = 200
        },
        Gallimimus = {
            Area = "PrehistoricForest",
            Rank = 4,
            Rarity = "Legendary",
            Income = 3E+13,
            Weight = 450
        },
        Brachiosaurus = {
            Area = "PrehistoricForest",
            Rank = 5,
            Rarity = "Mythic",
            Income = 4.8E+13,
            Weight = 40000
        },
        Spinosaurus = {
            Area = "PrehistoricForest",
            Rank = 6,
            Rarity = "Mythic",
            Income = 7.2E+13,
            Weight = 7000
        },
        ["T-Rex"] = {
            Area = "PrehistoricForest",
            Rank = 7,
            Rarity = "Secret",
            Income = 1.1E+14,
            Weight = 8000
        },
        Velicoraptor = {
            Area = "PrehistoricForest",
            Rank = 8,
            Rarity = "Secret",
            Income = 1.5E+14,
            Weight = 15
        },
        Anglerfish = {
            Area = "DeepWaters",
            Rank = 1,
            Rarity = "Epic",
            Income = 2.5E+14,
            Weight = 25
        },
        Swordfish = {
            Area = "DeepWaters",
            Rank = 2,
            Rarity = "Legendary",
            Income = 5E+14,
            Weight = 200
        },
        Shark = {
            Area = "DeepWaters",
            Rank = 3,
            Rarity = "Legendary",
            Income = 7.5E+14,
            Weight = 1000
        },
        Whale = {
            Area = "DeepWaters",
            Rank = 4,
            Rarity = "Mythic",
            Income = 1.2E+15,
            Weight = 40000
        },
        Megalodon = {
            Area = "DeepWaters",
            Rank = 5,
            Rarity = "Mythic",
            Income = 2E+15,
            Weight = 50000
        },
        Mosasaurus = {
            Area = "DeepWaters",
            Rank = 6,
            Rarity = "Secret",
            Income = 3E+15,
            Weight = 15000
        },
        Kraken = {
            Area = "DeepWaters",
            Rank = 7,
            Rarity = "Secret",
            Income = 4.5E+15,
            Weight = 20000
        },
        Plesiosaur = {
            Area = "DeepWaters",
            Rank = 8,
            Rarity = "Divine",
            Income = 6.2E+15,
            Weight = 700
        },
        Mothman = {
            Area = "Hell",
            Rank = 1,
            Rarity = "Legendary",
            Income = 1E+16,
            Weight = 80
        },
        Bunyip = {
            Area = "Hell",
            Rank = 2,
            Rarity = "Legendary",
            Income = 2E+16,
            Weight = 250
        },
        GargoyleBat = {
            Area = "Hell",
            Rank = 3,
            Rarity = "Mythic",
            Income = 3E+16,
            Weight = 60
        },
        WingedImp = {
            Area = "Hell",
            Rank = 4,
            Rarity = "Mythic",
            Income = 5E+16,
            Weight = 25
        },
        Manticore = {
            Area = "Hell",
            Rank = 5,
            Rarity = "Secret",
            Income = 8E+16,
            Weight = 300
        },
        Chupacabra = {
            Area = "Hell",
            Rank = 6,
            Rarity = "Secret",
            Income = 1.2E+17,
            Weight = 30
        },
        Dullahan = {
            Area = "Hell",
            Rank = 7,
            Rarity = "Divine",
            Income = 1.8E+17,
            Weight = 650
        },
        Cerberus = {
            Area = "Hell",
            Rank = 8,
            Rarity = "Divine",
            Income = 2.5E+17,
            Weight = 200
        },
        TripleCobra = {
            Area = "AncientRuins",
            Rank = 1,
            Rarity = "Legendary",
            Income = 4E+17,
            Weight = 25
        },
        Leviathan = {
            Area = "AncientRuins",
            Rank = 2,
            Rarity = "Mythic",
            Income = 8E+17,
            Weight = 80000
        },
        Microraptor = {
            Area = "AncientRuins",
            Rank = 3,
            Rarity = "Mythic",
            Income = 1.2E+18,
            Weight = 1
        },
        Archaeopteryx = {
            Area = "AncientRuins",
            Rank = 4,
            Rarity = "Secret",
            Income = 2E+18,
            Weight = 0.8
        },
        Qilin = {
            Area = "AncientRuins",
            Rank = 5,
            Rarity = "Secret",
            Income = 3.2E+18,
            Weight = 350
        },
        Sphinx = {
            Area = "AncientRuins",
            Rank = 6,
            Rarity = "Divine",
            Income = 4.8E+18,
            Weight = 400
        },
        Minotaur = {
            Area = "AncientRuins",
            Rank = 7,
            Rarity = "Divine",
            Income = 7.2E+18,
            Weight = 350
        },
        Hydra = {
            Area = "AncientRuins",
            Rank = 8,
            Rarity = "Celestial",
            Income = 1E+19,
            Weight = 6000
        },
        Raiju = {
            Area = "MythicalParadise",
            Rank = 1,
            Rarity = "Mythic",
            Income = 1.5E+19,
            Weight = 20
        },
        Unicorn = {
            Area = "MythicalParadise",
            Rank = 2,
            Rarity = "Mythic",
            Income = 3E+19,
            Weight = 450
        },
        Pegasus = {
            Area = "MythicalParadise",
            Rank = 3,
            Rarity = "Secret",
            Income = 4.5E+19,
            Weight = 500
        },
        Simurgh = {
            Area = "MythicalParadise",
            Rank = 4,
            Rarity = "Secret",
            Income = 7.5E+19,
            Weight = 900
        },
        Amphiptere = {
            Area = "MythicalParadise",
            Rank = 5,
            Rarity = "Divine",
            Income = 1.2E+20,
            Weight = 150
        },
        Wyvern = {
            Area = "MythicalParadise",
            Rank = 6,
            Rarity = "Divine",
            Income = 1.8E+20,
            Weight = 1200
        },
        ClassicDragon = {
            Area = "MythicalParadise",
            Rank = 7,
            Rarity = "Celestial",
            Income = 2.7E+20,
            Weight = 5000
        },
        FirePhoenix = {
            Area = "MythicalParadise",
            Rank = 8,
            Rarity = "Celestial",
            Income = 3.8E+20,
            Weight = 25
        },
        BlackCat = {
            Area = "ShadowRealm",
            Rank = 1,
            Rarity = "Mythic",
            Income = 2.5E+23,
            Weight = 4.5
        },
        CursedRaven = {
            Area = "ShadowRealm",
            Rank = 2,
            Rarity = "Secret",
            Income = 5E+23,
            Weight = 1.5
        },
        CursedOwl = {
            Area = "ShadowRealm",
            Rank = 3,
            Rarity = "Secret",
            Income = 1E+24,
            Weight = 2.5
        },
        ShadowWolf = {
            Area = "ShadowRealm",
            Rank = 4,
            Rarity = "Divine",
            Income = 2E+24,
            Weight = 70
        },
        PhantomDog = {
            Area = "ShadowRealm",
            Rank = 5,
            Rarity = "Divine",
            Income = 4E+24,
            Weight = 35
        },
        Hellhound = {
            Area = "ShadowRealm",
            Rank = 6,
            Rarity = "Celestial",
            Income = 8E+24,
            Weight = 350
        },
        ShadowDemon = {
            Area = "ShadowRealm",
            Rank = 7,
            Rarity = "Celestial",
            Income = 1.6E+25,
            Weight = 300
        },
        Nightmare = {
            Area = "ShadowRealm",
            Rank = 8,
            Rarity = "Eternal",
            Income = 3.2E+25,
            Weight = 700
        },
        RavenHalloween = {
            Area = "HarvestFields",
            Rank = 1,
            Rarity = "Secret",
            Income = 2.5000000000000002E+28,
            Weight = 1.5
        },
        ZombieCrow = {
            Area = "HarvestFields",
            Rank = 2,
            Rarity = "Secret",
            Income = 5.0000000000000005E+28,
            Weight = 1.2
        },
        Scarecrow = {
            Area = "HarvestFields",
            Rank = 3,
            Rarity = "Divine",
            Income = 1.0000000000000001E+29,
            Weight = 25
        },
        WitchFamiliarCat = {
            Area = "HarvestFields",
            Rank = 4,
            Rarity = "Divine",
            Income = 2.0000000000000002E+29,
            Weight = 4.5
        },
        JackOLantern = {
            Area = "HarvestFields",
            Rank = 5,
            Rarity = "Celestial",
            Income = 4.0000000000000004E+29,
            Weight = 60
        },
        Witch = {
            Area = "HarvestFields",
            Rank = 6,
            Rarity = "Celestial",
            Income = 8.000000000000001E+29,
            Weight = 60
        },
        Golem = {
            Area = "HarvestFields",
            Rank = 7,
            Rarity = "Eternal",
            Income = 1.6000000000000001E+30,
            Weight = 900
        },
        Horseman = {
            Area = "HarvestFields",
            Rank = 8,
            Rarity = "Eternal",
            Income = 3.2000000000000003E+30,
            Weight = 650
        },
        Ghost = {
            Area = "PhantomHarbor",
            Rank = 1,
            Rarity = "Secret",
            Income = 2E+33,
            Weight = 0.5
        },
        Poltergeist = {
            Area = "PhantomHarbor",
            Rank = 2,
            Rarity = "Divine",
            Income = 4E+33,
            Weight = 0.8
        },
        Wraith = {
            Area = "PhantomHarbor",
            Rank = 3,
            Rarity = "Divine",
            Income = 8E+33,
            Weight = 1
        },
        Specter = {
            Area = "PhantomHarbor",
            Rank = 4,
            Rarity = "Celestial",
            Income = 1.6E+34,
            Weight = 1.2
        },
        Banshee = {
            Area = "PhantomHarbor",
            Rank = 5,
            Rarity = "Celestial",
            Income = 3.2E+34,
            Weight = 2
        },
        GhostlyHorse = {
            Area = "PhantomHarbor",
            Rank = 6,
            Rarity = "Eternal",
            Income = 6.4E+34,
            Weight = 300
        },
        Lich = {
            Area = "PhantomHarbor",
            Rank = 7,
            Rarity = "Eternal",
            Income = 1.28E+35,
            Weight = 80
        },
        GhostPirate = {
            Area = "PhantomHarbor",
            Rank = 8,
            Rarity = "Cosmic",
            Income = 2.56E+35,
            Weight = 90
        },
        LivingPumpkin = {
            Area = "Shop",
            Rarity = "Divine",
            Income = 0,
            Weight = 350
        },
        GiantSquid = {
            Area = "Shop",
            Rarity = "Celestial",
            Income = 0,
            Weight = 275
        },
        WoollyMammoth = {
            Area = "Shop",
            Rarity = "Mythic",
            Income = 0,
            Weight = 6000
        },
        Skeleton = {
            Area = "Shop",
            Rarity = "Rare",
            Income = 0,
            Weight = 15
        },
        SkeletonHorse = {
            Area = "Shop",
            Rarity = "Epic",
            Income = 0,
            Weight = 120
        },
        Demon = {
            Area = "Shop",
            Rarity = "Legendary",
            Income = 0,
            Weight = 300
        },
        ReaperSteed = {
            Area = "Shop",
            Rarity = "Mythic",
            Income = 0,
            Weight = 500
        },
        Reaper = {
            Area = "Shop",
            Rarity = "Celestial",
            Income = 0,
            Weight = 70
        }
    }
}

function t1.Get(p1) -- line: 192
    -- upvalues: t1 (copy)
    return t1.List[p1]
end

function t1.GetAreaAnimals(p2) -- line: 197
    return require(game:GetService("ReplicatedStorage"):WaitForChild("AnimalsData"))[p2]
end

return t1

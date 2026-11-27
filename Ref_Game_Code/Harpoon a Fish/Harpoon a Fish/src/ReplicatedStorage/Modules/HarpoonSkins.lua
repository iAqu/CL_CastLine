-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function rgb(p1, p2, p3) -- line: 19
    return Color3.fromRGB(p1, p2, p3)
end

t1.DEFAULT = "Steel"
t1.LIST = {
    {
        id = "SteelRope",
        name = "Steel Rope Harpoon",
        crate = nil,
        rarity = "Common",
        rope = Color3.fromRGB(150, 105, 60)
    },
    {
        id = "Wooden",
        name = "Wooden Harpoon",
        crate = "Wood",
        rarity = "Common",
        weight = 4,
        rope = Color3.fromRGB(120, 80, 45)
    },
    {
        id = "Bronze",
        name = "Bronze Harpoon",
        crate = "Wood",
        rarity = "Common",
        weight = 3,
        rope = Color3.fromRGB(205, 127, 50)
    },
    {
        id = "Iron",
        name = "Iron Harpoon",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(110, 110, 115)
    },
    {
        id = "Steel",
        name = "Steel Harpoon",
        crate = "Wood",
        rarity = "Common",
        weight = 1,
        rope = Color3.fromRGB(185, 190, 200)
    },
    {
        id = "IronRope",
        name = "Iron Rope Harpoon",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 4,
        rope = Color3.fromRGB(95, 90, 85)
    },
    {
        id = "FullBronze",
        name = "Full Bronze Harpoon",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 3,
        rope = Color3.fromRGB(176, 110, 50)
    },
    {
        id = "Frozen",
        name = "Frozen Harpoon",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(150, 220, 255)
    },
    {
        id = "FullSteel",
        name = "Full Steel Harpoon",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 1,
        rope = Color3.fromRGB(220, 225, 235)
    },
    {
        id = "Gold",
        name = "Gold Harpoon",
        crate = "Gold",
        rarity = "Rare",
        weight = 4,
        rope = Color3.fromRGB(255, 200, 40)
    },
    {
        id = "SteelGold",
        name = "Steel Gold Harpoon",
        crate = "Gold",
        rarity = "Rare",
        weight = 3,
        rope = Color3.fromRGB(230, 190, 80)
    },
    {
        id = "Obsidian",
        name = "Shadow Harpoon",
        reward = "Group",
        crate = "Ruby",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(70, 35, 105)
    },
    {
        id = "CupidArrow",
        name = "Love Harpoon",
        reward = "Group",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(255, 90, 160)
    },
    {
        id = "Knight",
        name = "Knight Harpoon",
        crate = "Gold",
        rarity = "Rare",
        weight = 1,
        rope = Color3.fromRGB(255, 170, 0)
    },
    {
        id = "Ruby",
        name = "Ruby Harpoon",
        crate = "Ruby",
        rarity = "Epic",
        weight = 5,
        rope = Color3.fromRGB(220, 30, 50)
    },
    {
        id = "Emerald",
        name = "Emerald Harpoon",
        crate = "Ruby",
        rarity = "Epic",
        weight = 3,
        rope = Color3.fromRGB(40, 200, 100)
    },
    {
        id = "Toxic",
        name = "Toxic Harpoon",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(110, 255, 30)
    },
    {
        id = "Crystal",
        name = "Crystal Harpoon",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 5,
        rope = Color3.fromRGB(255, 140, 255)
    },
    {
        id = "GoldDiamond",
        name = "Gold Diamond Harpoon",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 3,
        rope = Color3.fromRGB(255, 215, 90)
    },
    {
        id = "Disco",
        name = "Disco Harpoon",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 60, 60)),
            ColorSequenceKeypoint.new(0.25, rgb(255, 240, 60)),
            ColorSequenceKeypoint.new(0.5, rgb(70, 255, 110)),
            ColorSequenceKeypoint.new(0.75, rgb(60, 170, 255)),
            ColorSequenceKeypoint.new(1, rgb(190, 80, 255))
        })
    },
    {
        id = "Galaxy",
        name = "Galaxy Harpoon",
        crate = "Secret",
        rarity = "Mythic",
        weight = 5,
        rope = Color3.fromRGB(150, 60, 255)
    },
    {
        id = "Angel",
        name = "Angel Harpoon",
        crate = "Secret",
        rarity = "Mythic",
        weight = 3,
        rope = Color3.fromRGB(255, 240, 200)
    },
    {
        id = "UFO",
        name = "UFO Harpoon",
        crate = "Secret",
        rarity = "Mythic",
        weight = 2,
        rope = Color3.fromRGB(85, 255, 127)
    },
    {
        id = "Plunger",
        name = "Plunger",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(220, 40, 40)
    },
    {
        id = "Pencil",
        name = "Pencil",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(255, 205, 40)
    },
    {
        id = "DinnerFork",
        name = "Dinner Fork",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(215, 220, 230)
    },
    {
        id = "CandyCane",
        name = "Candy Cane",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(235, 20, 30)),
            ColorSequenceKeypoint.new(0.24, rgb(235, 20, 30)),
            ColorSequenceKeypoint.new(0.25, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(0.49, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, rgb(235, 20, 30)),
            ColorSequenceKeypoint.new(0.74, rgb(235, 20, 30)),
            ColorSequenceKeypoint.new(0.75, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 255, 255))
        })
    },
    {
        id = "KnightSword",
        name = "Knight's Sword",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(175, 190, 220)
    },
    {
        id = "Coralfang",
        name = "Coralfang",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(255, 110, 130)
    },
    {
        id = "Tidecaller",
        name = "Tidecaller Trident",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(0, 200, 255)
    },
    {
        id = "Crescent",
        name = "Crescent Moon",
        crate = "Secret",
        rarity = "Mythic",
        weight = 2,
        rope = Color3.fromRGB(160, 100, 255)
    },
    {
        id = "Baguette",
        name = "Baguette",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(200, 150, 80)
    },
    {
        id = "Carrot",
        name = "Carrot",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(255, 130, 20)
    },
    {
        id = "Toothbrush",
        name = "Toothbrush",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(60, 140, 255)
    },
    {
        id = "Lollipop",
        name = "Lollipop",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 80, 160)),
            ColorSequenceKeypoint.new(0.24, rgb(255, 80, 160)),
            ColorSequenceKeypoint.new(0.25, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(0.49, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, rgb(255, 80, 160)),
            ColorSequenceKeypoint.new(0.74, rgb(255, 80, 160)),
            ColorSequenceKeypoint.new(0.75, rgb(255, 255, 255)),
            ColorSequenceKeypoint.new(1, rgb(255, 255, 255))
        })
    },
    {
        id = "RubberDuck",
        name = "Rubber Duck",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(255, 215, 40)
    },
    {
        id = "Cutlass",
        name = "Pirate Cutlass",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(150, 110, 60)
    },
    {
        id = "Anchor",
        name = "Anchor",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(190, 160, 110)
    },
    {
        id = "Spatula",
        name = "Golden Spatula",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(230, 170, 40)
    },
    {
        id = "FishSkeleton",
        name = "Fish Skeleton",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(120, 255, 140)
    },
    {
        id = "Lightning",
        name = "Lightning Bolt",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(255, 230, 60)
    },
    {
        id = "WizardStaff",
        name = "Wizard Staff",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(110, 140, 255)
    },
    {
        id = "Narwhal",
        name = "Narwhal Horn",
        crate = "Secret",
        rarity = "Mythic",
        weight = 2,
        rope = Color3.fromRGB(200, 235, 255)
    },
    {
        id = "SpearLeaf",
        name = "Bronze Leaf Spear",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(205, 127, 50)
    },
    {
        id = "SpearBarbed",
        name = "Barbed Spear",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(110, 100, 90)
    },
    {
        id = "GrabberHand",
        name = "Grabber Hand",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(60, 140, 255)
    },
    {
        id = "SpearGig",
        name = "Fishing Gig",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(180, 150, 100)
    },
    {
        id = "SpearToggle",
        name = "Whaler's Toggle",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(190, 160, 110)
    },
    {
        id = "Dentures",
        name = "Chattering Teeth",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(255, 150, 170)
    },
    {
        id = "NetGun",
        name = "Net Launcher",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(255, 150, 30)
    },
    {
        id = "SpearNeedle",
        name = "Needle Spear",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(40, 40, 50)
    },
    {
        id = "SpearSerrated",
        name = "Serrated Spear",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(50, 50, 60)
    },
    {
        id = "GrapplingHook",
        name = "Grappling Hook",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(90, 95, 105)
    },
    {
        id = "Magnet",
        name = "Magnet",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(220, 30, 30)
    },
    {
        id = "SharkTooth",
        name = "Shark Tooth",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(200, 170, 120)
    },
    {
        id = "SeaUrchin",
        name = "Sea Urchin",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(150, 60, 190)
    },
    {
        id = "ArcadeClaw",
        name = "Arcade Claw",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(230, 40, 40)
    },
    {
        id = "Antler",
        name = "Antler",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(150, 110, 70)
    },
    {
        id = "SharkJaw",
        name = "Shark Jaw",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(230, 230, 220)
    },
    {
        id = "SpearOrnate",
        name = "Royal Spear",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(200, 20, 30)
    },
    {
        id = "BoneLance",
        name = "Bone Lance",
        crate = "Secret",
        rarity = "Mythic",
        weight = 2,
        rope = Color3.fromRGB(235, 225, 200)
    },
    {
        id = "TipSpike",
        name = "Steel Spike",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(190, 200, 215)
    },
    {
        id = "TipLeaf",
        name = "Steel Leaf",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(170, 185, 205)
    },
    {
        id = "TipHook",
        name = "Jade Hook",
        crate = "Wood",
        rarity = "Common",
        weight = 2,
        rope = Color3.fromRGB(60, 200, 90)
    },
    {
        id = "Drill",
        name = "Drill",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(130, 135, 145)
    },
    {
        id = "TipLeafCamo",
        name = "Camo Leaf",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(90, 110, 50)
    },
    {
        id = "TipSpikeCarbon",
        name = "Carbon Spike",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(45, 46, 52)
    },
    {
        id = "Cactus",
        name = "Cactus",
        crate = "Stone",
        rarity = "Uncommon",
        weight = 2,
        rope = Color3.fromRGB(80, 170, 70)
    },
    {
        id = "TipLeafCrystal",
        name = "Crystal Leaf",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(150, 210, 255)
    },
    {
        id = "TipHookCircuit",
        name = "Circuit Hook",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(60, 220, 100)
    },
    {
        id = "IceCream",
        name = "Ice Cream",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(255, 160, 190)
    },
    {
        id = "TeddyBear",
        name = "Teddy Bear",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(170, 110, 70)
    },
    {
        id = "GoldenGrabber",
        name = "Golden Grabber",
        crate = "Gold",
        rarity = "Rare",
        weight = 2,
        rope = Color3.fromRGB(240, 180, 40)
    },
    {
        id = "TipLeafLava",
        name = "Lava Leaf",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(255, 100, 20)
    },
    {
        id = "TipHookPolygon",
        name = "Polygon Hook",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(60, 180, 255)
    },
    {
        id = "TipSpikeElectric",
        name = "Electric Spike",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(150, 110, 255)
    },
    {
        id = "Megalodon",
        name = "Megalodon Tooth",
        crate = "Ruby",
        rarity = "Epic",
        weight = 2,
        rope = Color3.fromRGB(110, 120, 135)
    },
    {
        id = "TipSpikeGalaxy",
        name = "Galaxy Spike",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(170, 80, 255)
    },
    {
        id = "DrillGold",
        name = "Golden Drill",
        crate = "Diamond",
        rarity = "Legendary",
        weight = 2,
        rope = Color3.fromRGB(255, 200, 50)
    },
    {
        id = "TipHookRainbow",
        name = "Rainbow Hook",
        crate = "Secret",
        rarity = "Mythic",
        weight = 2,
        rope = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 60, 60)),
            ColorSequenceKeypoint.new(0.25, rgb(255, 240, 60)),
            ColorSequenceKeypoint.new(0.5, rgb(70, 255, 110)),
            ColorSequenceKeypoint.new(0.75, rgb(60, 170, 255)),
            ColorSequenceKeypoint.new(1, rgb(190, 80, 255))
        })
    },
    {
        id = "DevilKnife",
        name = "Devilknife",
        crate = "Secret",
        rarity = "Secret",
        weight = 2,
        rope = Color3.fromRGB(200, 20, 20)
    },
    {
        id = "ZeusBolt",
        name = "Zeus's Lightning Bolt",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://113794954166722",
        hitFx = "ZeusZap",
        rope = Color3.fromRGB(214, 116, 4)
    },
    {
        id = "RainbowBolt",
        name = "True Harpooner's Rainbow Bolt",
        reward = "Achievement",
        rarity = "Exclusive",
        icon = "rbxassetid://97582099916158",
        rope = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 60, 60)),
            ColorSequenceKeypoint.new(0.2, rgb(255, 160, 40)),
            ColorSequenceKeypoint.new(0.4, rgb(255, 240, 60)),
            ColorSequenceKeypoint.new(0.6, rgb(70, 255, 110)),
            ColorSequenceKeypoint.new(0.8, rgb(60, 170, 255)),
            ColorSequenceKeypoint.new(1, rgb(190, 80, 255))
        })
    },
    {
        id = "Icicle",
        name = "Icicle",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://109899799777174",
        rope = Color3.fromRGB(150, 215, 255)
    },
    {
        id = "OwnersHarpoon",
        name = "Owner's Harpoon",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://118407200667306",
        rope = Color3.fromRGB(235, 30, 34)
    },
    {
        id = "Tealeaf",
        name = "Nature Harpoon",
        reward = "Shop",
        rarity = "Mythic",
        icon = "rbxassetid://106965580886658",
        rope = Color3.fromRGB(70, 220, 100)
    },
    {
        id = "VoidstormHarpoon",
        name = "Voidstorm Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://140337955642188",
        rope = Color3.fromRGB(150, 50, 230)
    },
    {
        id = "HellfireHarpoon",
        name = "Hellfire Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://130914047887930",
        rope = Color3.fromRGB(255, 90, 15)
    },
    {
        id = "VoidsparkHarpoon",
        name = "Voidspark Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://140062634969725",
        rope = Color3.fromRGB(200, 120, 255)
    },
    {
        id = "PinkMoonHarpoon",
        name = "Pink Moon Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://95656585903647",
        rope = Color3.fromRGB(255, 90, 205)
    },
    {
        id = "MeteorShowerHarpoon",
        name = "Meteor Shower Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://84696576395758",
        rope = Color3.fromRGB(255, 110, 20)
    },
    {
        id = "FossilStormHarpoon",
        name = "Fossil Storm Harpoon",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://83397100113618",
        rope = Color3.fromRGB(225, 190, 120)
    },
    {
        id = "HallowedHarpoon",
        name = "HALLOWED HARPOON",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://109031471603829",
        rope = Color3.fromRGB(255, 120, 20),
        perks = {
            luck = 1.66,
            hits = 1
        }
    },
    {
        id = "GratefulHarpoon",
        name = "GRATEFUL HARPOON",
        reward = "Index",
        rarity = "Secret",
        icon = "rbxassetid://99194600563950",
        equipQuip = "5% Double Catch Chance and +50% Mutation Chance!",
        rope = Color3.fromRGB(235, 165, 55),
        perks = {
            luck = 1.5,
            double = 0.05
        }
    },
    {
        id = "AdminHarpoon",
        name = "ADMIN HARPOON",
        reward = "Trader",
        rarity = "Mythic",
        rope = Color3.fromRGB(255, 25, 30)
    },
    {
        id = "BoneHarpoon",
        name = "Bone Harpoon",
        reward = "Shop",
        rarity = "Legendary",
        icon = "rbxassetid://83796023072956",
        rope = Color3.fromRGB(235, 225, 200)
    },
    {
        id = "Boneknife",
        name = "Boneknife",
        reward = "Shop",
        rarity = "Mythic",
        icon = "rbxassetid://136553704037913",
        rope = Color3.fromRGB(215, 200, 170)
    },
    {
        id = "DeathScythe",
        name = "Death Scythe",
        reward = "Shop",
        rarity = "Secret",
        icon = "rbxassetid://71208569221839",
        rope = Color3.fromRGB(40, 30, 50)
    },
    {
        id = "Katana",
        name = "Katana",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://138950556579235",
        hitFx = "KatanaSlash",
        equipQuip = "-1 Hit, 20% Extra Life Chance, 15% Slower Minigame and +60% Mutation Chance!",
        rope = Color3.fromRGB(120, 230, 255),
        perks = {
            luck = 1.6,
            hits = 1,
            reel = 0.85,
            life = 0.2
        }
    },
    {
        id = "WitchBroom",
        name = "Witch's Broom",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://92953098656575",
        hitFx = "WitchHex",
        equipQuip = "-2 Hits, 10% Double Catch Chance, 15% Slower Minigame and +75% Mutation Chance!",
        rope = Color3.fromRGB(140, 255, 90),
        perks = {
            luck = 1.75,
            hits = 2,
            reel = 0.85,
            double = 0.1
        }
    },
    {
        id = "StickyHand",
        name = "Sticky Hand",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://83169814924894",
        hitFx = "StickySplat",
        equipQuip = "-1 Hit, 30% Slower Minigame and +60% Mutation Chance!",
        rope = Color3.fromRGB(255, 90, 180),
        perks = {
            luck = 1.6,
            hits = 1,
            reel = 0.7
        }
    },
    {
        id = "PoolNoodle",
        name = "Pool Noodle",
        reward = "Shop",
        rarity = "Mythic",
        icon = "rbxassetid://83781203063129",
        hitFx = "NoodleSplash",
        equipQuip = "15% Slower Minigame and +30% Mutation Chance!",
        rope = Color3.fromRGB(255, 120, 20),
        perks = {
            luck = 1.3,
            reel = 0.85
        }
    },
    {
        id = "Drumstick",
        name = "Dino Drumstick",
        reward = "Shop",
        rarity = "Mythic",
        icon = "rbxassetid://91954121367323",
        hitFx = "DrumstickChomp",
        equipQuip = "15% Slower Minigame and +30% Mutation Chance!",
        rope = Color3.fromRGB(200, 110, 50),
        perks = {
            luck = 1.3,
            reel = 0.85
        }
    },
    {
        id = "PlasmaSaber",
        name = "Plasma Saber",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://116021607009921",
        hitFx = "PlasmaSlash",
        equipQuip = "-2 Hits, 25% Extra Life Chance, 15% Slower Minigame and +75% Mutation Chance!",
        rope = Color3.fromRGB(255, 50, 45),
        perks = {
            luck = 1.75,
            hits = 2,
            reel = 0.85,
            life = 0.25
        }
    },
    {
        id = "MeteoriteSpear",
        name = "Godly Meteorite Spear",
        reward = "Shop",
        rarity = "Exclusive",
        icon = "rbxassetid://133635478147358",
        hitFx = "MeteorImpact",
        equipQuip = "-2 Hits, 15% Instant Catch Chance, 5% Double Catch Chance and +75% Mutation Chance!",
        rope = Color3.fromRGB(255, 120, 30),
        perks = {
            luck = 1.75,
            hits = 2,
            double = 0.05,
            instantChance = 0.15
        }
    }
}

local t2 = {
    { "TipSpike", "Spike" },
    { "TipLeaf", "Leaf" },
    { "TipHook", "Hook" },
    { "Drill", "Drill" }
}
local t3 = {
    {
        "Camo",
        "Stone",
        "Uncommon",
        rgb(90, 110, 50)
    },
    {
        "Carbon",
        "Stone",
        "Uncommon",
        rgb(45, 46, 52)
    },
    {
        "Crystal",
        "Gold",
        "Rare",
        rgb(150, 210, 255)
    },
    {
        "Circuit",
        "Gold",
        "Rare",
        rgb(60, 220, 100)
    },
    {
        "Lava",
        "Ruby",
        "Epic",
        rgb(255, 100, 20)
    },
    {
        "Polygon",
        "Ruby",
        "Epic",
        rgb(60, 180, 255)
    },
    {
        "Electric",
        "Ruby",
        "Epic",
        rgb(150, 110, 255)
    },
    {
        "Galaxy",
        "Diamond",
        "Legendary",
        rgb(170, 80, 255)
    },
    {
        "Gold",
        "Diamond",
        "Legendary",
        rgb(255, 200, 50)
    },
    {
        "Rainbow",
        "Secret",
        "Mythic",
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 60, 60)),
            ColorSequenceKeypoint.new(0.25, rgb(255, 240, 60)),
            ColorSequenceKeypoint.new(0.5, rgb(70, 255, 110)),
            ColorSequenceKeypoint.new(0.75, rgb(60, 170, 255)),
            ColorSequenceKeypoint.new(1, rgb(190, 80, 255))
        })
    },
    {
        "Red",
        "Wood",
        "Common",
        rgb(235, 40, 40)
    },
    {
        "Blue",
        "Wood",
        "Common",
        rgb(50, 120, 255)
    },
    {
        "Green",
        "Wood",
        "Common",
        rgb(60, 220, 80)
    },
    {
        "Purple",
        "Wood",
        "Common",
        rgb(160, 70, 255)
    },
    {
        "Pink",
        "Wood",
        "Common",
        rgb(255, 120, 200)
    },
    {
        "Black",
        "Wood",
        "Common",
        rgb(30, 30, 34)
    },
    {
        "Checker",
        "Stone",
        "Uncommon",
        rgb(235, 235, 235)
    },
    {
        "Cow",
        "Stone",
        "Uncommon",
        rgb(240, 240, 240)
    },
    {
        "Brick",
        "Stone",
        "Uncommon",
        rgb(190, 70, 45)
    },
    {
        "Watermelon",
        "Stone",
        "Uncommon",
        rgb(70, 170, 60)
    },
    {
        "Zebra",
        "Gold",
        "Rare",
        rgb(240, 240, 240)
    },
    {
        "Bubblegum",
        "Gold",
        "Rare",
        rgb(255, 150, 200)
    },
    {
        "Chocolate",
        "Gold",
        "Rare",
        rgb(110, 60, 30)
    },
    {
        "Honeycomb",
        "Gold",
        "Rare",
        rgb(240, 170, 30)
    },
    {
        "Splotch",
        "Gold",
        "Rare",
        rgb(255, 90, 120)
    },
    {
        "Tiger",
        "Ruby",
        "Epic",
        rgb(255, 140, 20)
    },
    {
        "Leopard",
        "Ruby",
        "Epic",
        rgb(210, 160, 80)
    },
    {
        "Slime",
        "Ruby",
        "Epic",
        rgb(120, 230, 60)
    },
    {
        "Donut",
        "Ruby",
        "Epic",
        rgb(255, 150, 200)
    },
    {
        "Aurora",
        "Diamond",
        "Legendary",
        rgb(80, 230, 180)
    },
    {
        "NeonGrid",
        "Diamond",
        "Legendary",
        rgb(60, 230, 255)
    },
    {
        "Graffiti",
        "Diamond",
        "Legendary",
        rgb(60, 120, 255)
    },
    {
        "Void",
        "Secret",
        "Secret",
        rgb(150, 90, 255)
    }
}
local t4 = {
    NeonGrid = "Neon Grid",
    Splotch = "Paint Splotch"
}
local t5 = {}

for _, v1 in ipairs(t1.LIST) do
    t5[v1.id] = true
end

for _, v2 in ipairs(t2) do
    for _, v3 in ipairs(t3) do
        local v4 = v2[1] .. v3[1]

        if not t5[v4] then
            table.insert(t1.LIST, {
                weight = 1,
                id = v4,
                name = (t4[v3[1]] or v3[1]) .. " " .. v2[2],
                crate = v3[2],
                rarity = v3[3],
                rope = v3[4]
            })
        end
    end
end

local t7 = {
    "Wood",
    "Stone",
    "Gold",
    "Ruby",
    "Diamond",
    "Secret"
}

t1.CRATE_MIX = {
    Wood = {
        Common = 75,
        Uncommon = 22,
        Rare = 3
    },
    Stone = {
        Common = 45,
        Uncommon = 40,
        Rare = 13,
        Epic = 2
    },
    Gold = {
        Uncommon = 45,
        Rare = 40,
        Epic = 13,
        Legendary = 2
    },
    Ruby = {
        Rare = 45,
        Epic = 40,
        Legendary = 13,
        Mythic = 2
    },
    Diamond = {
        Epic = 45,
        Legendary = 40,
        Mythic = 13,
        Secret = 2
    },
    Secret = {
        Legendary = 50,
        Mythic = 42,
        Secret = 8
    }
}

local t8 = {
    SteelRope = "Common",
    Wooden = "Common",
    Bronze = "Common",
    Iron = "Common",
    Steel = "Common",
    IronRope = "Common",
    FullBronze = "Uncommon",
    Frozen = "Epic",
    FullSteel = "Rare",
    Gold = "Rare",
    SteelGold = "Epic",
    Obsidian = "Epic",
    Knight = "Rare",
    Ruby = "Epic",
    Emerald = "Epic",
    Toxic = "Legendary",
    Crystal = "Epic",
    GoldDiamond = "Rare",
    Disco = "Rare",
    Galaxy = "Legendary",
    Angel = "Mythic",
    UFO = "Mythic",
    Plunger = "Legendary",
    Pencil = "Common",
    DinnerFork = "Common",
    CandyCane = "Uncommon",
    KnightSword = "Secret",
    Coralfang = "Legendary",
    Tidecaller = "Secret",
    Crescent = "Epic",
    Baguette = "Common",
    Carrot = "Common",
    Toothbrush = "Uncommon",
    Lollipop = "Uncommon",
    RubberDuck = "Epic",
    Cutlass = "Legendary",
    Anchor = "Rare",
    Spatula = "Epic",
    FishSkeleton = "Epic",
    Lightning = "Uncommon",
    WizardStaff = "Secret",
    Narwhal = "Legendary",
    SpearLeaf = "Common",
    SpearBarbed = "Uncommon",
    GrabberHand = "Epic",
    SpearGig = "Epic",
    SpearToggle = "Legendary",
    Dentures = "Rare",
    NetGun = "Rare",
    SpearNeedle = "Rare",
    SpearSerrated = "Rare",
    GrapplingHook = "Legendary",
    Magnet = "Mythic",
    SharkTooth = "Rare",
    SeaUrchin = "Uncommon",
    ArcadeClaw = "Mythic",
    Antler = "Common",
    SharkJaw = "Rare",
    SpearOrnate = "Rare",
    BoneLance = "Legendary",
    TipSpike = "Common",
    TipLeaf = "Common",
    TipHook = "Common",
    Drill = "Common",
    Cactus = "Uncommon",
    IceCream = "Legendary",
    TeddyBear = "Mythic",
    GoldenGrabber = "Mythic",
    Megalodon = "Mythic",
    DevilKnife = "Secret"
}
local t9 = {
    Red = "Common",
    Blue = "Common",
    Green = "Common",
    Purple = "Common",
    Pink = "Common",
    Black = "Common",
    Camo = "Uncommon",
    Carbon = "Uncommon",
    Checker = "Mythic",
    Cow = "Rare",
    Brick = "Uncommon",
    Watermelon = "Uncommon",
    Crystal = "Uncommon",
    Circuit = "Uncommon",
    Zebra = "Rare",
    Bubblegum = "Uncommon",
    Chocolate = "Uncommon",
    Honeycomb = "Uncommon",
    Splotch = "Uncommon",
    Lava = "Common",
    Polygon = "Common",
    Electric = "Common",
    Tiger = "Mythic",
    Leopard = "Epic",
    Slime = "Common",
    Donut = "Common",
    Galaxy = "Rare",
    Gold = "Rare",
    Aurora = "Common",
    NeonGrid = "Common",
    Graffiti = "Legendary",
    Rainbow = "Epic",
    Void = "Secret"
}
local t10 = {
    Tidecaller = "Poseidon's Trident"
}

for _, v5 in ipairs(t1.LIST) do
    local v6 = v5.id:match("^(TipSpike)%u") or v5.id:match("^(TipLeaf)%u") or v5.id:match("^(TipHook)%u") or v5.id:match("^(Drill)%u")
    local v7 = v6 and t9[v5.id:sub(#v6 + 1)] or t8[v5.id]

    if v7 then
        v5.rarity = v7
    end

    if t10[v5.id] then
        v5.name = t10[v5.id]
    end
end

local t11 = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret"
}
local t12 = {}
local t13 = {}

for _, v8 in ipairs(t1.LIST) do
    if v8.reward then
        if v8.crate then
            table.insert(t13, v8)
        end
    else
        v8.crate = nil
    end

    if v8.id ~= t1.DEFAULT and not v8.reward then
        local v9 = v8.id:match("^(TipSpike)%u") or v8.id:match("^(TipLeaf)%u") or v8.id:match("^(TipHook)%u") or v8.id:match("^(Drill)%u")
        local v10 = v9 and "skin:" .. v8.id:sub(#v9 + 1) or v8.id
        local v11 = t12[v8.rarity] or {
            count = 0,
            list = {},
            of = {}
        }

        t12[v8.rarity] = v11

        local v12 = v11.of[v10]

        if not v12 then
            v12 = {
                first = #v11.list + 1
            }
            v11.of[v10] = v12
            table.insert(v11.list, v12)
        end

        table.insert(v12, v8)
        v11.count += 1
    end
end

local t14 = {}
local t15 = {}

for _, v13 in ipairs(t7) do
    t14[v13] = 0
end

local function put(p4, p5, p6) -- line: 422
    -- upvalues: t14 (copy), t15 (copy)
    p6.placed = true
    t14[p4] += #p6
    t15[p4 .. p5] = (t15[p4 .. p5] or 0) + #p6

    for _, v14 in ipairs(p6) do
        v14.crate = p4
    end
end

for _, v15 in ipairs(t13) do
    local crate, rarity = v15.crate, v15.rarity
    local t16 = {
        v15
    }

    t16.placed = true
    t14[crate] += #t16
    t15[crate .. rarity] = (t15[crate .. rarity] or 0) + #t16

    for _, v16 in ipairs(t16) do
        v16.crate = crate
    end
end

for i = #t7, 1, -1 do
    local v17 = t7[i]

    for _, v18 in ipairs(t11) do
        if t1.CRATE_MIX[v17][v18] and t12[v18] then
            local v19

            for _, v20 in ipairs(t12[v18].list) do
                if not v20.placed and (not v19 or #v20 < #v19) then
                    v19 = v20
                end
            end

            if v19 then
                v19.placed = true
                t14[v17] += #v19
                t15[v17 .. v18] = (t15[v17 .. v18] or 0) + #v19

                for _, v21 in ipairs(v19) do
                    v21.crate = v17
                end
            end
        end
    end
end

for _, v22 in ipairs(t11) do
    local v23 = t12[v22]

    if v23 then
        local n1 = 0

        for _, v24 in ipairs(t7) do
            n1 += t1.CRATE_MIX[v24][v22] or 0
        end

        table.sort(v23.list, function(p7, p8) -- line: 449
            if #p7 == #p8 then
                return p7.first < p8.first
            end

            return #p7 > #p8
        end)

        for _, v25 in ipairs(v23.list) do
            if not v25.placed then
                local v26, v27, v28

                for _, v29 in ipairs(t7) do
                    local v30 = t1.CRATE_MIX[v29][v22]

                    if v30 then
                        local v31 = v23.count * v30 / n1 - (t15[v29 .. v22] or 0)

                        if t14[v29] + #v25 <= 45 and (not v26 or v27 < v31) then
                            v27 = v31
                            v26 = v29
                        end

                        if not v28 or t14[v29] < t14[v28] then
                            v28 = v29
                        end
                    end
                end

                local v32 = v26 or v28

                v25.placed = true
                t14[v32] += #v25
                t15[v32 .. v22] = (t15[v32 .. v22] or 0) + #v25

                for _, v33 in ipairs(v25) do
                    v33.crate = v32
                end
            end
        end
    end
end

t1.BY_ID = {}

for v34, v35 in ipairs(t1.LIST) do
    v35.order = v34
    t1.BY_ID[v35.id] = v35
end

function t1.Get(p9) -- line: 477
    -- upvalues: t1 (copy)
    return t1.BY_ID[p9]
end

function t1.RopeColor(p10) -- line: 482
    -- upvalues: t1 (copy)
    local rope = (t1.BY_ID[p10] or t1.BY_ID[t1.DEFAULT]).rope

    if typeof(rope) ~= "ColorSequence" or not rope then
        rope = ColorSequence.new(rope)
    end

    return rope
end

function t1.Model(p11) -- line: 489
    local Harpoons = game:GetService("ReplicatedStorage"):FindFirstChild("Harpoons")

    return Harpoons and Harpoons:FindFirstChild(p11)
end

t1.SHOP_ICON = {
    ZeusBolt = "rbxassetid://113794954166722",
    Icicle = "rbxassetid://109899799777174",
    Tealeaf = "rbxassetid://106965580886658",
    PoolNoodle = "rbxassetid://119227728986212",
    Katana = "rbxassetid://77033990480066",
    StickyHand = "rbxassetid://116239204631802",
    WitchBroom = "rbxassetid://118627480711325",
    PlasmaSaber = "rbxassetid://137245580485673",
    Drumstick = "rbxassetid://77384746346676",
    MeteoriteSpear = "rbxassetid://92933394697803"
}

function t1.ShopIcon(p12) -- line: 509
    -- upvalues: t1 (copy)
    return p12 and t1.SHOP_ICON[p12]
end

return t1

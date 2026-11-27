-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdminAbuseConfig = require(script.Parent:WaitForChild("AdminAbuseConfig"))
local v1 = Color3.fromRGB(255, 140, 40)

Color3.fromRGB(170, 95, 255)
Color3.fromRGB(70, 200, 95)
Color3.fromRGB(60, 150, 255)

return {
    {
        id = 10,
        title = "THE JURASSIC TITAN UPDATE!",
        rarity = "JurassicTitan",
        date = "November 28, 2026",
        opens = 1795888500,
        sections = {
            {
                kind = "JURASSIC",
                rows = {
                    {
                        name = "JURASSIC TITANS RISE",
                        text = "At the top of every hour, the sky goes dark over Jurassic Island and a Titan bursts up out of the bottom of Extinction. Harpoon it as it passes your zone and hold on: it drags you down into its underwater cave to fight!"
                    },
                    {
                        name = "5 JURASSIC TITANS",
                        text = "Ammonarch, Spinosauron, Dunkeltorian, Plessiomother and Bagosaurus. Which one rises is random every hour, Plessiomother and Bagosaurus being the rarest, and every rise has a 1 in 100 chance to be SHINY!"
                    },
                    {
                        name = "NEW TITAN BONUSES",
                        text = "Ammonarch gives up to 3x the FOSSILIZED chance in the Fossil Storm, Spinosauron up to 3x the METEORITE chance in the Meteor Shower, and Dunkeltorian up to +65% EXTRA LIFE chance.",
                        mutations = { "Fossilized", "Meteorite" }
                    },
                    {
                        name = "MORE SPACE",
                        text = "Plessiomother gives up to +5 aquarium space, and Bagosaurus up to +5 bag space!"
                    },
                    {
                        name = "TITAN GUARDIANS",
                        text = "Put a Jurassic Titan in your Titan slot back home and it guards your aquarium, floating on the water next to it."
                    }
                }
            },
            {
                kind = "NEW",
                rows = {
                    {
                        name = "TITAN INDEX",
                        text = "The Index's Titans tab now has two parts: ORIGIN TITANS and JURASSIC TITANS."
                    }
                }
            },
            {
                kind = "CHANGES",
                rows = {
                    {
                        name = "EQUIP BEST",
                        text = "Equip Best no longer swaps out the Titan in your Titan slot."
                    }
                }
            },
            {
                kind = "FIXES",
                rows = {
                    {
                        name = "AND MANY MORE",
                        text = "Plus lots of smaller fixes behind the scenes!"
                    }
                }
            }
        }
    },
    {
        id = 9,
        title = "THE BLACK MARKET UPDATE!",
        date = "November 21, 2026",
        tab = "BLACK MARKET +",
        tab2 = "THANKSGIVING",
        color = Color3.fromRGB(255, 196, 70),
        tab2Color = Color3.fromRGB(230, 130, 45),
        sections = {
            {
                kind = "BLACKMARKET",
                rows = {
                    {
                        name = "THE LIGHTHOUSE",
                        text = "Something is going on inside the old lighthouse. Vladimir guards the door: pay him $1B once and you're in the Black Market for good."
                    },
                    {
                        name = "TOKENS",
                        text = "The Black Market's own money. Duplicate harpoons from crates are kept as spares: put them in the Compactor and it crushes them into tokens, even while you're away. Level it up with cash to crush faster, or grab tokens at the Token Stash."
                    },
                    {
                        name = "HATS",
                        text = "3 new hats every day, 15 to collect. Buy one with tokens and put it on the fish in your hand."
                    },
                    {
                        name = "TICKETS",
                        text = "Pick your server's next weather or next Titan, or open the treasure chest of any zone you've reached. The tickets change every hour."
                    },
                    {
                        name = "GUN CRATES",
                        text = "Open crates with tokens for new looks for your harpoon station: Rare, Legendary and Mythical skins. A crate can drop the key to the next one!"
                    },
                    {
                        name = "KEY FISH",
                        text = "Every 30 to 60 minutes a KEY FISH appears somewhere in the sea. Catch it for a Rare Key!"
                    },
                    {
                        name = "TANK DECOR",
                        text = "Decorate your own aquarium: rocks, plants, coral and ruins for cash, and big Black Market pieces for tokens. ADVANCED lets you move, turn and size every piece freely."
                    },
                    {
                        name = "POTION DEALER",
                        text = "The man in the top hat brews potions for tokens: Body, Bag and Fat potions every day, plus 5 rare brews that change every hour."
                    },
                    {
                        name = "HIGH ROLLER",
                        text = "$1T opens the gold doors. Inside, the bench upgrades your harpoon: boost its own perks, or roll new ones onto it."
                    }
                }
            },
            {
                kind = "THANKSGIVING",
                rows = {
                    {
                        name = "THANKSGIVING MUTATION",
                        text = "For 2 weeks, until December 5, any hit has a 1 in 20 chance to turn a fish THANKSGIVING for 16x money!",
                        mutations = { "Thanksgiving" }
                    },
                    {
                        name = "TURKEY FEAST",
                        text = "Every THANKSGIVING mutation you land also gives you a ticket. Use it and a giant turkey bursts open with a Thanksgiving fish. Catch it, then keep it, or throw it back in as bait for a better one."
                    },
                    {
                        name = "THE THROW",
                        text = "Land green for better fish! Land yellow to stay alive. Land red and the run is over and you lose it all!"
                    },
                    {
                        name = "15 THANKSGIVING FISH",
                        text = "From Legendaries up to the Celestial Mayflounder and Maple Seadragon, and the Feasted Leviathan. Find them all in the new THANKSGIVING 2026 Index tab!"
                    },
                    {
                        name = "TURKEY SHOP",
                        text = "1 in 15 fish wear a turkey hat. Trade them at the Giant Turkey for hats, then spend them on the TURKEY fish (+100% money for your whole aquarium), 2x Thanksgiving luck and more."
                    }
                }
            },
            {
                kind = "NEW",
                rows = {
                    {
                        name = "FISH SHOP",
                        text = "Serial exclusives for 2 weeks: Wishbone Wyrm and Pecan Pike. When they leave they're gone for good!"
                    },
                    {
                        name = "CODE: SECRET",
                        text = "Use code SECRET for a Secret key and 3,000 XP. Ends November 28!"
                    },
                    {
                        name = "CODE: THANKSGIVING",
                        text = "Use code THANKSGIVING for a Bag Potion and a Fat Potion. Ends December 5!"
                    },
                    {
                        name = "CODE: BLACKMARKET",
                        text = "Use code BLACKMARKET for 10 Gold keys. Ends November 28!"
                    }
                }
            },
            {
                kind = "CHANGES",
                rows = {
                    {
                        name = "EGGS",
                        text = "The Aurora Egg moved to the Eggs tab, and the MASSIVE Fish Egg is back on top of Popular."
                    },
                    {
                        name = "CONTROLLER",
                        text = "More button pictures and smoother menus when you play with a controller."
                    }
                }
            },
            {
                kind = "FIXES",
                rows = {
                    {
                        name = "AND MANY MORE",
                        text = "Plus lots of smaller fixes behind the scenes!"
                    }
                }
            }
        }
    },
    {
        id = 8,
        title = "THE WEATHER UPDATE!",
        date = "November 14, 2026",
        tab = "WEATHER UPDATE +",
        tab2 = "EXTINCTION ZONE",
        color = Color3.fromRGB(90, 200, 255),
        tab2Color = Color3.fromRGB(230, 70, 80),
        sections = {
            {
                kind = "WEATHERS",
                rows = {
                    {
                        name = "3 NEW WEATHERS",
                        text = "The Pink Moon rises over Origins, and Jurassic Island gets the Meteor Shower and the Fossil Storm. For the first 3 days they come every 15 minutes. After that they're rare!"
                    },
                    {
                        name = "PINK MOON",
                        text = "The sky turns pink and gravity is cut in half: jump twice as high! 14 new Pink Moon fish come out, and any hit can turn a fish PINK MOON for 18x money.",
                        mutations = { "PinkMoon" }
                    },
                    {
                        name = "METEOR SHOWER",
                        text = "Meteors rain down on Jurassic Island and crash into the sea. 17 new meteorite fish come out, and any hit can turn a fish METEORITE for 14x money.",
                        mutations = { "Meteorite" }
                    },
                    {
                        name = "FOSSIL STORM",
                        text = "A sandstorm of bones: fossil tornados spin across the sea. 15 new fossil fish come out, and any hit can turn a fish FOSSILIZED for 18x money.",
                        mutations = { "Fossilized" }
                    },
                    {
                        name = "STORM CHESTS",
                        text = "During a storm, treasure chests can hold that weather's fish. Open them before it ends!"
                    }
                }
            },
            {
                kind = "EXTINCTION",
                rows = {
                    {
                        name = "ZONE 3: EXTINCTION",
                        text = "The deepest zone on Jurassic Island is open: a dark sea of bones under Meteorite. 47 new monsters, from Legendaries all the way up to Celestials."
                    },
                    {
                        name = "APEX RARITY",
                        text = "A brand new rarity above Celestial. There is only one Apex in the game: the Endling. Good luck!"
                    },
                    {
                        name = "COMPLETIONIST X",
                        text = "Extinction counts now: up to Completionist X and +10 bag slots."
                    }
                }
            },
            {
                kind = "NEW",
                rows = {
                    {
                        name = "AURORA EGG",
                        text = "A limited egg at the top of the shop, for 14 days only. 5 aurora monsters hatch from it, up to the Celestial Dreammaw at $750M/s!"
                    },
                    {
                        name = "FISH SHOP",
                        text = "This week's serial exclusives: Hydrax, Tricerosaurus and Fossilshark. When the week ends they're gone for good!"
                    },
                    {
                        name = "GLOBAL RANK",
                        text = "Your aquarium's glass now shows your global $/s rank."
                    },
                    {
                        name = "CODE: EXTINCT",
                        text = "Use code EXTINCT for 3,000 XP, a Fat Potion and a Bag Potion!"
                    }
                }
            },
            {
                kind = "CHANGES",
                rows = {
                    {
                        name = "SMOOTHER STORMS",
                        text = "Weather effects were rebuilt to run smoother, especially on phones."
                    },
                    {
                        name = "EGGS TAB",
                        text = "The MASSIVE Fish Egg moved to the Eggs tab."
                    }
                }
            },
            {
                kind = "FIXES",
                rows = {
                    {
                        name = "TITANS",
                        text = "Select Worst and Sell All no longer pick your Titans."
                    },
                    {
                        name = "STEALS",
                        text = "Fixed the reel ring vanishing when another player joined your fight."
                    },
                    {
                        name = "FISH ROLL",
                        text = "Fixed the roll getting stuck on one weather fish."
                    },
                    {
                        name = "AND MANY MORE",
                        text = "Plus lots of smaller fixes behind the scenes!"
                    }
                }
            }
        }
    },
    {
        id = 7,
        title = "THE JURASSIC UPDATE!",
        date = "November 7, 2026",
        color = Color3.fromRGB(95, 185, 60),
        sections = {
            {
                kind = "JURASSIC",
                rows = {
                    {
                        name = "ESCAPE THE ISLAND",
                        text = "Find the 7 lost map pieces: one in every zone, the last one in Cosmic. Bring the whole map to Captain Whiskers on his boat and he'll sail you somewhere new!"
                    },
                    {
                        name = "JURASSIC ISLAND",
                        text = "A whole new island with its own servers. Your table, upgrades, harpoon, fat and money come with you. Dive into 2 new zones, PRIMAL and METEORITE. Extinction is coming soon!"
                    },
                    {
                        name = "78 PREHISTORIC ANIMALS",
                        text = "39 new animals in each zone, from the Helicoprion to the Tyrannosaurus, with Epics all the way up to Celestials. They're the best $/s fish in the game!"
                    },
                    {
                        name = "BRING THEM HOME",
                        text = "There's no aquarium on Jurassic Island (it didn't fit on the boat). Your catches go to your inventory: talk to Captain Whiskers, TRAVEL home and put them in your aquarium."
                    },
                    {
                        name = "THUNDERSTORMS",
                        text = "Jurassic Island has its own weather: thunderstorms, where every fish is 15% bigger."
                    }
                }
            },
            {
                kind = "NEW",
                rows = {
                    {
                        name = "3 NEW TABLES",
                        text = "Amber, Meteor and Time Machine: the three biggest tables yet."
                    },
                    {
                        name = "QUESTS REWORKED",
                        text = "Every quest in one list. 3 daily quests (finish all 3 for a Massive egg) and weekly quests for 20 minutes of fat, a Secret key and a Voidspark egg."
                    },
                    {
                        name = "MOST FAT LEADERBOARD",
                        text = "A new leaderboard for the most fat ever eaten."
                    },
                    {
                        name = "CODE: JURASSIC",
                        text = "Use code JURASSIC for 5,000 XP, 3 Fat Potions and 5 minutes of fat. Ends November 21!"
                    }
                }
            },
            {
                kind = "CHANGES",
                rows = {
                    {
                        name = "FAVORITE FISH",
                        text = "Press Favorite in your inventory and tap your fish to star them. Favorites stay at the top and can't be sold, fed or traded by accident."
                    },
                    {
                        name = "SELL BY RARITY",
                        text = "The trash can's sell panel has a By Rarity list to pick a whole rarity at once, and selling now asks you to confirm."
                    },
                    {
                        name = "FEEDING",
                        text = "New Select Worst Base $/s button: it picks your cheapest fish, just enough to make your fish ready to grow. The feed list also has a big scroll bar for phones."
                    },
                    {
                        name = "INVENTORY SORT",
                        text = "New Best Base $/s sort, and your favorites always come first."
                    },
                    {
                        name = "INDEX ISLANDS",
                        text = "Switch between ORIGINS and JURASSIC in the Index to see each island's zones."
                    },
                    {
                        name = "COMPLETIONIST",
                        text = "Primal and Meteorite count now: up to Completionist IX and +9 bag slots."
                    }
                }
            },
            {
                kind = "FIXES",
                rows = {
                    {
                        name = "EATING",
                        text = "Fixed getting pushed off your table, or not gaining fat, while eating."
                    },
                    {
                        name = "AND MANY MORE",
                        text = "Plus lots of smaller fixes behind the scenes!"
                    }
                }
            }
        }
    },
    {
        id = 6,
        title = "THE TITAN UPDATE!",
        rarity = "Titan",
        date = "October 31, 2026",
        sections = {
            {
                kind = "TITANS",
                rows = {
                    {
                        name = "TITANS RISE",
                        text = "At the 30 minute mark of every hour, the sky goes dark and a giant Titan bursts out of the cosmic pit and rises up through every zone. Harpoon it as it passes your zone and hold on: it drags everyone it caught down into its cave!"
                    },
                    {
                        name = "THE TITAN FIGHT",
                        text = "In the cave everyone fights the Titan at the same time. The first player to fill their bar captures it and takes it home! Losing hearts stuns you, so stay sharp. Didn't win? You get a chance to recover the Titan after the fight."
                    },
                    {
                        name = "5 TITANS",
                        text = "Charybdis (FAT), Jörmungandr (MONEY), Karkinos (XP), Aspidochelone (GROW) and Umibōzu (LUCK). Which one rises is random every hour, Jörmungandr being the rarest, and every rise has a 1 in 100 chance to be SHINY!"
                    },
                    {
                        name = "TITAN SLOT",
                        text = "Put your Titan in the new Titan slot at the top of your aquarium panel. While it's there you get its bonus (rolled when you capture it: up to +100% and beyond, or up to 40% less GROW time) and it guards your aquarium on the water. Titans can also be sold or fed like any fish."
                    },
                    {
                        name = "WATCH THE PIT",
                        text = "Titans sometimes swim by under the planks of the cosmic pit between rises. Keep an eye out!"
                    }
                }
            }
        }
    },
    {
        id = 5,
        title = "THE HALLOWEEN UPDATE!",
        date = "October 24, 2026",
        tab = "HALLOWEEN UPDATE +",
        tab2 = "COSMIC ZONE +",
        tab3 = "CELESTIAL",
        color = v1,
        tab2Color = Color3.fromRGB(255, 105, 200),
        tab3Color = Color3.fromRGB(255, 224, 138),
        sections = {
            {
                kind = "HALLOWEEN",
                rows = {
                    {
                        name = "HALLOWEEN EVENT",
                        text = "For the first 20 minutes of every hour, the whole sea goes Halloween: orange fog, orange water, spooky music and ghosts of the players in your server flying overhead. It runs every hour until November 7!"
                    },
                    {
                        name = "GHOST & HALLOWED MUTATIONS",
                        text = "While Halloween is on, any hit can turn your fish GHOST for 10x money (about 1 in 10 hits). The even rarer HALLOWED mutation is 24x money (about 1 in 50)!",
                        mutations = { "Ghost", "Hallowed" }
                    },
                    {
                        name = "PUMPKIN CHESTS",
                        text = "When Halloween starts, every zone's treasure chest turns into a glowing pumpkin chest. Open them for 11 brand new Halloween fish (each zone has its own) and collect them all in the new Halloween Index tab!"
                    },
                    {
                        name = "WITCH HATS",
                        text = "All event long, some fish spawn wearing a witch hat: 1 in 9 during Halloween, 1 in 20 the rest of the time. Catch them and trade them in at the Pumpkin Shop!"
                    },
                    {
                        name = "PUMPKIN SHOP",
                        text = "Find the giant pumpkin in the middle of the map. Trade your hatted fish for hats, then spend them on the Hallowed Leviathan (it copies your best fish's $/s), the Pumpkin Guppy, Ghost and Hallowed luck boosts, or summon your zone's pumpkin chest!"
                    }
                }
            },
            {
                kind = "COSMIC",
                rows = {
                    {
                        name = "ZONE 7: COSMIC",
                        text = "Dive past zone 6 into deep space! Over 30 new cosmic fish: Epics, Legendaries and Mythics swim around, and the zone's roll gives Exotics, Secrets and Celestials."
                    }
                }
            },
            {
                kind = "CELESTIAL",
                rows = {
                    {
                        name = "CELESTIAL RARITY",
                        text = "There is only 1 Celestial in the game and it is currently the rarest and highest $/s fish."
                    }
                }
            },
            {
                kind = "ACHIEVEMENTS",
                rows = {
                    {
                        name = "ACHIEVEMENTS",
                        text = "A new tab in the XP menu: 7 achievement tracks, each with 10 tiers (I to X). Every tier you reach gives you a bonus that lasts forever, plus a title you can show over your head and in chat. Titles are just for show: you always get every bonus!"
                    },
                    {
                        name = "THE 7 TRACKS",
                        text = "Completionist: finish a zone's Index for +1 bag slot each.\nDeadeye: catch fish without losing a heart, and your hit zone stops shrinking, then grows.\nThief: steal fish in VS for up to +50% second chance in VS. (Second chance re-hooks a fish when you run out of hearts)\nCaretaker: fully grow fish (Primordial) for up to +50% grow speed.\nGlutton: eat for up to +50% fat.\nExtinctionist: catch fish for up to +50% mutation chance.\nHigh Roller: support the game for up to 5x money."
                    },
                    {
                        name = "TRUE HARPOONER",
                        text = "Reach the top tier of every track except High Roller to unlock the rainbow TRUE HARPOONER title!"
                    }
                }
            },
            {
                kind = "CHANGES",
                rows = {
                    {
                        name = "ECONOMY REWORK",
                        text = "Rarer fish matter way more now: Epics and up in zones 4 to 6 earn up to 7.8x more, and every fish's base $/s is 2.6x higher. Size still matters, but a huge fish no longer beats a much rarer one. Egg jackpots (Hell Hydra, Jawspark, Dreadspark) and crafted Unknowns pay a lot more, and the Voidstorm mutation is now 14x. Fish you already own were updated too!"
                    },
                    {
                        name = "HARPOON SHOP",
                        text = "Every week the Harpoons tab gets a new lineup next to Zeus's Lightning Bolt: one harpoon at 99, one at 599 and one at 1,249 Robux. 5 new harpoons join the rotation: Pool Noodle, Katana, Sticky Hand, Witch's Broom and Plasma Saber!"
                    },
                    {
                        name = "NEW HARPOON PERKS",
                        text = "Double Catch: a chance to reel in two of the same fish (Witch's Broom). Extra Life: a chance to keep your last heart when you miss, once a fight (Katana, Plasma Saber, Death Scythe)."
                    },
                    {
                        name = "ROTATING FISH SHOP",
                        text = "The Fish tab now changes every week with new exclusive fish. Limited fish get their own serial number, so the first buyer owns #1 forever! Starting with the Jesterwraith and the new Mummified Mosasaur."
                    },
                    {
                        name = "BAITS",
                        text = "7 new limited-time Unknown baits to summon your own monster, plus Bait Bundles on the Popular tab: big packs of baits that work in any zone."
                    },
                    {
                        name = "INVENTORY SORT",
                        text = "Sorting by Best $/s now puts your 3x and 2x fish first, then your % boost fish, then everything else."
                    },
                    {
                        name = "DEATH SCYTHE",
                        text = "Now +50% mutation chance and a 33% Extra Life chance."
                    },
                    {
                        name = "QUALITY OF LIFE",
                        text = "Shop tabs now go Popular, Fish, Harpoons, Eggs. Chest openings are less dark under the water, and names in the Aquarium, Feed and Bait lists are sharp again."
                    }
                }
            },
            {
                kind = "FIXES",
                rows = {
                    {
                        name = "BOUGHT FISH",
                        text = "Fish you buy in the shop now go straight to your hand and hotbar instead of hiding in your inventory."
                    },
                    {
                        name = "AND MANY MORE",
                        text = "A lot more I forgot to write down, but hopefully less lag!"
                    }
                }
            }
        }
    },
    {
        id = 4,
        title = "THE VOIDSTORM UPDATE!",
        rarity = "Unknown",
        date = "October 17, 2026",
        opens = AdminAbuseConfig.END + AdminAbuseConfig.UPDATE.LOG,
        features = {
            {
                title = "WEATHER EVENTS",
                text = "A 5 minute storm every 15 minutes, in every server!",
                image = "rbxassetid://115022898840421",
                color = Color3.fromRGB(90, 200, 255)
            },
            {
                title = "15 VOIDSTORM FISH",
                text = "They only come out during the Voidstorm. Catch them all!",
                image = "rbxassetid://99448077423306",
                big = true,
                color = Color3.fromRGB(170, 95, 255)
            },
            {
                title = "VOID MUTATION",
                text = "In a Voidstorm any hit can turn a fish VOID! 2x the hits to catch.",
                image = "rbxassetid://136858219747701",
                color = Color3.fromRGB(170, 95, 255)
            },
            {
                title = "THUNDERSTORMS",
                text = "Every fish 15% bigger in the rain. Coming soon!",
                image = "rbxassetid://93814292603804",
                color = Color3.fromRGB(120, 170, 255)
            },
            {
                title = "NEW INDEX TABS",
                text = "Weather and Special! Finish the Voidstorm tab for a harpoon.",
                image = "rbxassetid://90238293883566",
                color = Color3.fromRGB(60, 160, 255)
            }
        }
    },
    {
        id = 3,
        title = "FAT MULTIPLIERS REWORKED!",
        rarity = "Exclusive",
        date = "October 12, 2026",
        features = {
            {
                title = "EXCLUSIVE FATTY FISH!",
                text = "Your fat multipliers turned into Fatty!\n1 spent = +1% money",
                rarity = "Exclusive",
                image = "rbxassetid://95601767067233",
                big = true
            },
            {
                title = "2X FAT GAMEPASS",
                text = "Double the fat from every bite, forever!",
                image = "rbxassetid://135825676122341",
                color = Color3.fromRGB(255, 150, 40)
            },
            {
                title = "DEPTHS REWORKED",
                text = "Deep zones are way easier to reach. Feeding is stronger too!",
                image = "rbxassetid://87230583877443",
                big = true,
                color = Color3.fromRGB(60, 160, 255)
            },
            {
                title = "NEW UNKNOWN FISH",
                text = "Megalodon and Poisoned Hexjaw! New baits summon them.",
                rarity = "Unknown",
                image = "rbxassetid://86746546721729"
            },
            {
                title = "5 NEW TABLES",
                text = "Virus, Shadow, Rainbow, Cloud and Atlantis!",
                image = "rbxassetid://79121430385949",
                color = Color3.fromRGB(255, 80, 190)
            },
            {
                title = "SELL FISH",
                text = "Sell fish at the trash can on your plot!",
                image = "rbxassetid://117252679272986",
                color = Color3.fromRGB(90, 220, 110)
            },
            {
                title = "GHOST MEGALODON",
                text = "Limited! Only 300 will ever exist. Up to +400% money!",
                image = "rbxassetid://95986407466942",
                color = Color3.fromRGB(110, 200, 255)
            }
        }
    },
    {
        id = 2,
        title = "BAITS AND UNKNOWN FISH",
        rarity = "Unknown",
        date = "October 7, 2026",
        features = {
            {
                title = "MEET BONZO!",
                text = "The chef on your raft. Bring him fish to craft baits!",
                image = "rbxassetid://131538496093272",
                big = true,
                color = Color3.fromRGB(255, 176, 40)
            },
            {
                title = "BAITS",
                text = "Throw a bait in the sea to summon your own monster!",
                image = "rbxassetid://97433166170129",
                color = Color3.fromRGB(80, 205, 90)
            },
            {
                title = "UNKNOWN RARITY",
                text = "A brand new rarity! Summon the Kraken while you can.",
                rarity = "Unknown",
                glyph = "?"
            },
            {
                title = "INDEX REWARDS",
                text = "Discover fish to claim keys and potions!",
                image = "rbxassetid://90238293883566",
                color = Color3.fromRGB(60, 160, 255)
            },
            {
                title = "POTIONS",
                text = "Fat Potions: x3 fat. Bag Potions: carry more fish!",
                image = "rbxassetid://95689780794934",
                color = Color3.fromRGB(255, 50, 150)
            }
        }
    },
    {
        id = 1,
        title = "GAME RELEASED!",
        date = "October 3, 2026",
        popup = false
    }
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        version = "7.0",
        mainName = "HOOLA UPDATE! 🌺",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 8, 14),
        categories = { "Free Rerolls", "Flight Hoops", "HOOLA Mutations", "Developer Notes" },
        details = {
            {
                text = "Use Code \"HOOLALALA\" for 3 FREE REROLLS!"
            },
            {
                text = "NEW: Flight Hoops",
                highlight = "feature",
                children = { "Hoops are here - fly through them and don't fumble! 😭", "Keep hitting Hoops to stack your Combo.", "Higher Combo = more HOOLA Luck = better shot at a HOOLA Mutation! 👀" }
            },
            {
                text = "NEW: HOOLA Mutations",
                highlight = "feature",
                children = { "3 Hoola Mutation tiers to unlock - stacks with existing Mutations.", "Hoola I — 💰 +$/s", "Hoola II — 💰 +$/s + ???", "Hoola III — 💰 +$/s + ??? + ???" }
            },
            {
                text = "Developer Notes",
                children = { "Various fixes and improvements.", "Min-Max Update Part 2 next week...?" }
            },
            {
                text = "Thanks for sticking with us! 💙",
                highlight = "major"
            }
        }
    },
    {
        version = "6.5",
        mainName = "Multiverse Crate & FOMO Finale",
        date = DateTime.fromUniversalTime(2026, 8, 7),
        categories = { "Aquarium Skins", "FOMO Island", "Community", "Min-Max" },
        details = {
            {
                text = "The new Multiverse Crate has arrived!",
                highlight = "feature",
                children = { "Collect the full skin set for +20% mutation luck." }
            },
            {
                text = "FOMO Island has come to an end.",
                highlight = "feature",
                children = { "A mystery reward awaits!" }
            },
            {
                text = "Thank you for reaching the community goals - enjoy your new reward!",
                highlight = "major"
            },
            {
                text = "Min-Max Part 2 is still in the works - keep a lookout for it!",
                highlight = "major"
            }
        }
    },
    {
        version = "6.1",
        mainName = "Auto-Kill & Lucky Block Fixes",
        date = DateTime.fromUniversalTime(2026, 7, 31),
        categories = { "Gamepasses", "Boss Fish", "Lucky Blocks", "Bug Fixes" },
        details = {
            {
                text = "Auto-Kill Boss Fish gamepass is now available!",
                highlight = "feature",
                children = { "Automatically defeat Boss Fish without the skill check." }
            },
            {
                text = "Fixed Lucky Blocks sometimes spawning in the air."
            }
        }
    },
    {
        version = "6.0",
        mainName = "Shards Update: Min-Max Part 1",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 7, 31),
        categories = { "Shards", "Lucky Blocks", "Aquarium Skins", "Code" },
        details = {
            {
                text = "Min-Max Part 1 is here!",
                highlight = "major"
            },
            {
                text = "Fish for Aquarium Skin Shards.",
                highlight = "feature",
                children = { "25 shards = 1 Mythic Skin." }
            },
            {
                text = "Lucky Blocks fall near spawn every 5-10 mins.",
                highlight = "feature",
                children = { "Grab shards, boosts, or timeskips first!" }
            },
            {
                text = "New Aquarium Skin Crates - 4 skins each.",
                highlight = "feature",
                children = { "Each skin boosts earnings.", "Full set: +15% cash & +20% mutation luck." }
            },
            {
                text = "x2 Shards: Friday 23:00 - Saturday 23:00 UTC.",
                highlight = "feature",
                children = { "SGT: Saturday 7 AM - Sunday 7 AM." }
            },
            {
                text = "Use Code \"SHARDS\" for rewards!"
            },
            {
                text = "Stay tuned for Min-Max Part 2 - more upgrades coming soon!",
                highlight = "major"
            }
        }
    },
    {
        version = "5.0",
        mainName = "KaijUwU Zone Update",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 7, 24),
        categories = { "New Zone", "Weather Event", "Fish Mounts", "Exclusive Fish" },
        details = {
            {
                text = "Explore the new KaijUwU Zone",
                children = { "7 new fish", "UwU Weight & Rod" }
            },
            {
                text = "New Unc's Calling weather event."
            },
            {
                text = "New Fish Mounts.",
                highlight = "feature"
            },
            {
                text = "New exclusive fish: Unc-thulu & Aura Maximus."
            },
            {
                text = "Server Luck added to the Exclusive Shop."
            }
        }
    },
    {
        version = "4.1",
        mainName = "FOMO Event Adjustments",
        date = DateTime.fromUniversalTime(2026, 7, 21),
        categories = { "FOMO Island", "Obby", "Ticket Caps" },
        details = {
            {
                text = "FOMO Community Milestone adjustments."
            },
            {
                text = "FOMO Obby changes."
            },
            {
                text = "New Ticket Cap UI."
            },
            {
                text = "Bug fixes."
            }
        }
    },
    {
        version = "4.0",
        mainName = "FOMO Event Celebration",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 7, 17),
        categories = { "FOMO Event", "Minigames", "New Rewards" },
        details = {
            {
                text = "FOMO Event Celebration Island."
            },
            {
                text = "New Minigames."
            },
            {
                text = "New Charms."
            },
            {
                text = "New Pinata Boss."
            },
            {
                text = "New Fish Reel Back Effects!"
            },
            {
                text = "New Fish Holograms."
            },
            {
                text = "New Titles."
            }
        }
    },
    {
        version = "3.1",
        mainName = "Leaderboard Titles & Player Stats",
        date = DateTime.fromUniversalTime(2026, 7, 12),
        categories = { "Titles", "Player Stats", "Fixes" },
        details = {
            {
                text = "New Global Leaderboard Titles",
                children = { "Top 5 Global Cash", "Top 5 Power" }
            },
            {
                text = "New player stats in Settings."
            },
            {
                text = "Bug fixes."
            }
        }
    },
    {
        version = "3.0",
        mainName = "Delulu & Frostwyrm",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 7, 10),
        categories = { "Weather Event", "Exclusive Fish", "Mysteries" },
        details = {
            {
                text = "New DELULU weather event."
            },
            {
                text = "New Exclusive Frostwyrm (0.0009%)."
            },
            {
                text = "Champion mutation buffed (1.15x → 3x)."
            },
            {
                text = "New ??? Mystery Title."
            },
            {
                text = "What's that in the sky...?"
            }
        }
    },
    {
        version = "2.2",
        mainName = "Polish & Fixes",
        date = DateTime.fromUniversalTime(2026, 7, 8),
        categories = { "Settings", "Data", "VIP" },
        details = {
            {
                text = "Fixed data loading issues."
            },
            {
                text = "New responsive Music and SFX sliders."
            },
            {
                text = "VIP Training Speed more prominent."
            },
            {
                text = "Minor Bug fixes."
            }
        }
    },
    {
        version = "2.1",
        mainName = "Bug Fixes & Adjustments",
        date = DateTime.fromUniversalTime(2026, 7, 6),
        categories = { "Bug Fixes", "Spin Wheel", "Community" },
        details = {
            {
                text = "Bug fixes."
            },
            {
                text = "Adjusted Spin Wheel rewards."
            },
            {
                text = "Increased chance for glitched mutation."
            },
            {
                text = "Stay tuned for future updates coming your way!"
            }
        }
    },
    {
        version = "2.0",
        mainName = "Bait Auras",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 7, 3),
        categories = { "Bait Auras", "Code", "Daily Rewards" },
        details = {
            {
                text = "New Bait Auras: Roll for powerful new Bait Auras and equip them to gain special perks."
            },
            {
                text = "Use Code BAITAURA for rewards!"
            },
            {
                text = "New Daily Rewards."
            },
            {
                text = "Minor Bug fixes."
            }
        }
    },
    {
        version = "1.2",
        mainName = "VIP & Console Update",
        date = DateTime.fromUniversalTime(2026, 7, 2),
        categories = { "VIP", "Console", "Training" },
        details = {
            {
                text = "New VIP x1.5 Training Speed Area"
            },
            {
                text = "Added Console support!"
            },
            {
                text = "Minor Bug fixes."
            }
        }
    },
    {
        version = "1.1",
        mainName = "Performance Update",
        date = DateTime.fromUniversalTime(2026, 6, 29),
        categories = { "SALE", "Performance", "Bug Fixes" },
        details = {
            {
                text = "93% OFF → +1 Aquarium Fish gamepass!"
            },
            {
                text = "Optimized FPS performance."
            },
            {
                text = "Minor Bug fixes."
            }
        }
    },
    {
        version = "1.0",
        mainName = "Official Launch",
        isMajor = true,
        date = DateTime.fromUniversalTime(2026, 6, 26),
        categories = { "Launch", "Free Rewards", "Community" },
        details = {
            {
                text = "The game is officially launched!"
            },
            {
                text = "Use code \"OFFICIAL\" for rewards!"
            },
            {
                text = "Like, favourite the game, and join our channels for free community rewards!"
            },
            {
                text = "Send us bug reports and suggestions to help shape future updates!"
            }
        }
    }
}
local v1 = t1[1]

if v1 ~= nil then
    v1 = v1.version
end

return {
    getChangelogReadRewardId = function(p1) -- getChangelogReadRewardId | line: 260
        return (("changelog-read-%*"):format(p1))
    end,
    isValidChangelogVersion = function(p2) -- isValidChangelogVersion | line: 263
        -- upvalues: t1 (copy)
        for v2, v3 in t1 do
            local _ = v2 - 1

            if v3.version == p2 then
                return true
            end
        end

        return false
    end,
    changelogEntries = t1,
    latestChangelogVersion = v1
}

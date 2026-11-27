-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    ORDER = { "Wood", "Stone", "Gold", "Ruby", "Diamond", "Secret" },
    KEYS = {
        Wood = {
            image = "rbxassetid://73603668354456",
            rect = { 91, 69, 948, 966 }
        },
        Stone = {
            image = "rbxassetid://122122418521376",
            rect = { 93, 69, 949, 967 }
        },
        Gold = {
            image = "rbxassetid://100531081219639",
            rect = { 93, 68, 948, 966 }
        },
        Ruby = {
            image = "rbxassetid://122506641557110",
            rect = { 93, 67, 948, 966 }
        },
        Diamond = {
            image = "rbxassetid://137383621608033",
            rect = { 93, 69, 949, 967 }
        },
        Secret = {
            image = "rbxassetid://136430358000106",
            rect = { 92, 68, 950, 967 }
        }
    },
    INDEX = {
        Common = "Wood",
        Uncommon = "Stone",
        Rare = "Gold",
        Epic = "Ruby",
        Legendary = "Ruby",
        Mythic = "Ruby",
        Exotic = "Diamond",
        Secret = "Secret",
        Unknown = "Secret",
        Celestial = "Secret",
        Apex = "Secret"
    },
    Attr = function(p1) -- Attr | line: 26
        return "Key" .. p1
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    DisplayName = "Jungle",
    Emoji = "😬",
    GuardId = "Jungle",
    Icon = "rbxassetid://114796463507768",
    IndexBatGearId = "Jungle Bat",
    _id = "Jungle",
    Color = Color3.fromRGB(150, 220, 60),
    DropTable = {
        {
            "Chimpanzee",
            26.006779
        },
        {
            "Toucan",
            20.005214
        },
        {
            "Crocodile",
            17.004432
        },
        {
            "Gorilla",
            13.003389
        },
        {
            "Orangutini Ananassini",
            11.002868
        },
        {
            "Spider",
            7.852047
        },
        {
            "Tiger",
            5.001304
        },
        {
            "Warden",
            0.123968
        }
    },
    Rarity = require(game:GetService("ReplicatedStorage").Data.Rarity).Rarities.Epic
}

return table.freeze(t1)

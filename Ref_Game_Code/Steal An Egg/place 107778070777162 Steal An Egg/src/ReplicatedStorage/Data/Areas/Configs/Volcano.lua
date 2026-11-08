-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    DisplayName = "Volcano",
    Emoji = "😰",
    GuardId = "Volcano",
    Icon = "rbxassetid://114058528069937",
    IndexBatGearId = "Volcano Bat",
    _id = "Volcano",
    Color = Color3.fromRGB(255, 105, 55),
    DropTable = {
        {
            "Ash Gecko",
            26.848869
        },
        {
            "Lava frog",
            22.040116
        },
        {
            "Flaming Bull",
            18.032822
        },
        {
            "Lava Iguana",
            15.027352
        },
        {
            "Chillin Chilli",
            17.030999
        },
        {
            "Cerberus",
            0.61984
        },
        {
            "Ascended Vermilion Phoenix",
            0.222224
        },
        {
            "Dragon",
            0.177779
        }
    },
    Rarity = require(game:GetService("ReplicatedStorage").Data.Rarity).Rarities.Mythic
}

return table.freeze(t1)

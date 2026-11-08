-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Parent.Types)

local t1 = {
    DisplayName = "Titan Temple",
    Emoji = "🦖",
    GuardId = "Titan Temple",
    Icon = "rbxassetid://112788249655110",
    IndexBatGearId = "Titan Axe",
    Lighting = nil,
    _id = "Titan Temple",
    Color = Color3.fromRGB(90, 255, 210),
    DropTable = {
        {
            "Kaiju Spider",
            37.51
        },
        {
            "Crab",
            26.27
        },
        {
            "Blade Head",
            16.83
        },
        {
            "Mantis",
            13.96
        },
        {
            "Rhino",
            4.36
        },
        {
            "Shark",
            0.74
        },
        {
            "King Kong",
            0.31
        },
        {
            "Godzilla",
            0.02
        }
    },
    Rarity = require(game:GetService("ReplicatedStorage").Data.Rarity).Rarities.Titan
}

return table.freeze(t1)

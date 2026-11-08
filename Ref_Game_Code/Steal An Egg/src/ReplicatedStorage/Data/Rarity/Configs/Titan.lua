-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = game:GetService("ReplicatedStorage").Assets.UI.RarityGradients:FindFirstChild(script.Name)

assert(v1, (("RarityGradients has no \"%*\" folder"):format(script.Name)))

return table.freeze({
    DisplayName = "Titan",
    Rank = 11,
    _id = script.Name,
    Color = Color3.fromRGB(255, 64, 64),
    RarityGradient = v1.RarityGradient,
    ItemTemplate = v1.ItemTemplate
})

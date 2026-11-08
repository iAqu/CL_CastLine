-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

return {
    SchemaValidation = t.interface({
        FadeInTime = t.optional(t.number),
        FadeOutTime = t.numberConstrainedExclusive(0, 1e999),
        Magnitude = t.number,
        PosInfluence = t.optional(t.Vector3),
        RotInfluence = t.optional(t.Vector3),
        Roughness = t.number
    })
}

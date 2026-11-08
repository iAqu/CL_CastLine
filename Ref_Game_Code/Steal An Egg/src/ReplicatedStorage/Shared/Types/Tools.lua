-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    SlapControllerProfile = t.interface({
        Duration = t.number,
        Force = t.number,
        BrainrotDamage = t.number,
        MaxBrainrotTargets = t.optional(t.number)
    })
}

t1.SlapControllerData = t.interface({
    Player = t1.SlapControllerProfile,
    Brainrot = t1.SlapControllerProfile,
    PlayerCooldown = t.optional(t.number),
    MobCooldown = t.optional(t.number)
})

return t1

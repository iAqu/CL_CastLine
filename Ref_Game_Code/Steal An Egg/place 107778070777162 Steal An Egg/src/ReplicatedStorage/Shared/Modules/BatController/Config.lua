-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local v1 = {
    Range = 15,
    HitTolerance = 2,
    TargetViewSamplePadding = 0.05,
    MaximumTargetViewAge = 0.35,
    DragonEggEventHitboxScalar = 2.5,
    DragonEggEventActiveAttribute = "DragonEggEventActive"
}

function v1.GetHitboxScalar() -- line: 14
    -- upvalues: Workspace (copy), v1 (ref)
    if Workspace:GetAttribute(v1.DragonEggEventActiveAttribute) == true then
        return v1.DragonEggEventHitboxScalar
    end

    return 1
end

v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.BatCombat", v1, {
    Range = true,
    HitTolerance = true,
    DragonEggEventHitboxScalar = true
}, false)

return v1

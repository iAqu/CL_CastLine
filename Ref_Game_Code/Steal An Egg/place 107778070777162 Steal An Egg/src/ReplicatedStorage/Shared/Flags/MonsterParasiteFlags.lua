-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t1 = {
    Enabled = FastFlags.Replicated("Game.MonsterParasite.Enabled", Asserts.Boolean, true),
    SpawnChanceByArea = FastFlags.Replicated("Game.MonsterParasite.SpawnChanceByArea", Asserts.Map(Asserts.String, Asserts.Range(0, 100)), {}),
    RewardWeights = FastFlags.Replicated("Game.MonsterParasite.RewardWeights", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {})
}

return table.freeze(t1)

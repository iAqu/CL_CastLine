-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function isEnabledByDefault() -- line: 12
    -- upvalues: RunService (copy), Environment (copy)
    return Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
end

local function flag(p1, p2, p3) -- line: 16
    -- upvalues: FastFlags (copy)
    return FastFlags.Replicated(("Game.FishingLoot.%*"):format(p1), p2, p3)
end

local freeze = table.freeze
local Boolean = Asserts.Boolean
local v1 = Environment.IsDevPlace() or Environment.IsTestPlace() or RunService:IsStudio()
local t1 = {}

t1.Enabled = FastFlags.Replicated("Game.FishingLoot.Enabled", Boolean, v1)

local v2 = Asserts.Range(0, 1E+06)

t1.TokensWeight = FastFlags.Replicated("Game.FishingLoot.TokensWeight", v2, 76.5667)

local v3 = Asserts.Range(0, 1E+06)

t1.EggWeight = FastFlags.Replicated("Game.FishingLoot.EggWeight", v3, 20)

local v4 = Asserts.Range(0, 1E+06)

t1.MutationWeight = FastFlags.Replicated("Game.FishingLoot.MutationWeight", v4, 3.3333)

local v5 = Asserts.Range(0, 1E+06)

t1.PetWeight = FastFlags.Replicated("Game.FishingLoot.PetWeight", v5, 0.1)

local v6 = Asserts.IntegerRange(1, 1E+06)

t1.TokensMin = FastFlags.Replicated("Game.FishingLoot.TokensMin", v6, 18)

local v7 = Asserts.IntegerRange(1, 1E+06)

t1.TokensMax = FastFlags.Replicated("Game.FishingLoot.TokensMax", v7, 45)

local v8 = Asserts.IntegerRange(1, 100)

t1.MutationAmount = FastFlags.Replicated("Game.FishingLoot.MutationAmount", v8, 1)

local String = Asserts.String

t1.PetId = FastFlags.Replicated("Game.FishingLoot.PetId", String, "Ghost Fish")

local v9 = Asserts.Range(1, 100)

t1.LuckMax = FastFlags.Replicated("Game.FishingLoot.LuckMax", v9, 3)

local v10 = Asserts.IntegerRange(1, 20)

t1.EggLuckMinRank = FastFlags.Replicated("Game.FishingLoot.EggLuckMinRank", v10, 8)

local v11 = Asserts.Map(Asserts.String, Asserts.Range(0, 1E+06))
local t2 = {}

t1.EggZoneWeights = FastFlags.Replicated("Game.FishingLoot.EggZoneWeights", v11, t2)

return freeze(t1)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)

local function toggle(p1, p2) -- line: 10
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(p1, Asserts.Boolean, p2)
end

local function bounded(p3, p4, p5, p6) -- line: 14
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(p3, Asserts.Range(p4, p5), p6)
end

local function nonNegative(p7, p8) -- line: 18
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(p7, Asserts.FiniteNonNegative, p8)
end

local function wholeNumber(p9, p10) -- line: 22
    -- upvalues: Asserts (copy), FastFlags (copy)
    return FastFlags.Replicated(p9, Asserts.IntegerNonNegative, p10)
end

local t1 = {
    PetMounts = require(script.Parent.PetMountFlags),
    StorefrontOpen = FastFlags.Replicated("Game.Storefront.Open", Asserts.Boolean, true),
    OneTimeRepeatGuard = FastFlags.Replicated("Game.Storefront.OneTimeRepeatGuard", Asserts.Boolean, true),
    ClientSidePrompts = FastFlags.Replicated("Game.Storefront.ClientSidePrompts", Asserts.Boolean, false),
    SoundEffects = FastFlags.Replicated("Game.Audio.SoundEffects", Asserts.Boolean, true),
    WorldOverlaysHidden = FastFlags.Replicated("Game.World.OverlaysHidden", Asserts.Boolean, false),
    ForbiddenIslandEnabled = FastFlags.Replicated("Game.ForbiddenIsland.Enabled", Asserts.Boolean, true),
    GreatBloomEnabled = FastFlags.Replicated("Game.GreatBloom.Enabled", Asserts.Boolean, false),
    FriendBoostCap = FastFlags.Replicated("Game.FriendBoost.Cap", Asserts.IntegerNonNegative, 4),
    FriendBoostPercentPerFriend = FastFlags.Replicated("Game.FriendBoost.PercentPerFriend", Asserts.FiniteNonNegative, 10),
    PetUpdateSchedulingEnabled = FastFlags.Replicated("ClientPerformance.Pets.SchedulingEnabled", Asserts.Boolean, true),
    DistantPetUpdateDistance = FastFlags.Replicated("ClientPerformance.Pets.DistantUpdateDistance", Asserts.Range(128, 4096), 300),
    DistantPetUpdateInterval = FastFlags.Replicated("ClientPerformance.Pets.DistantUpdateInterval", Asserts.Range(0, 0.25), 0.1),
    HiddenPetUpdateInterval = FastFlags.Replicated("ClientPerformance.Pets.HiddenUpdateInterval", Asserts.Range(0, 0.25), 0.1)
}

return table.freeze(t1)

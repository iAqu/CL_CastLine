-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)

require(ReplicatedStorage.Shared.Types.HalloweenDimension)

local t1 = {
    PetId = "Headless Horseman",
    PetScale = 1,
    Goal = function() -- Goal | line: 26
        -- upvalues: HalloweenDimensionFlags (copy)
        return HalloweenDimensionFlags.HeadlessHorsemanBattlepassGoal:Get()
    end,
    EndsAt = function() -- EndsAt | line: 30
        -- upvalues: HalloweenDimensionFlags (copy)
        return HalloweenDimensionFlags.HeadlessHorsemanBattlepassEndsAt:Get()
    end,
    IsOpen = function(p1) -- IsOpen | line: 35
        -- upvalues: HalloweenDimensionFlags (copy)
        return HalloweenDimensionFlags.ContentEnabled:Get() and HalloweenDimensionFlags.HeadlessHorsemanBattlepassEnabled:Get() and HalloweenDimensionFlags.HeadlessHorsemanBattlepassStartsAt:Get() <= p1 and p1 < HalloweenDimensionFlags.HeadlessHorsemanBattlepassEndsAt:Get()
    end
}

function t1.IsComplete(p2) -- line: 42
    -- upvalues: t1 (copy)
    return p2.TokensCollected >= t1.Goal()
end

function t1.IsClaimable(p3) -- line: 46
    -- upvalues: t1 (copy)
    return not p3.Claimed and t1.IsComplete(p3)
end

assert(Assets.Directory["Headless Horseman"] ~= nil, "Headless Horseman is not in Data.Assets")

return table.freeze(t1)

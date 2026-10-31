-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    PartyFishLandingVFX = {
        name = "PartyFishLandingVFX",
        description = "A confetti-and-smoke burst when your fish lands.",
        displayName = "FOMO Party",
        ticketPrice = 500
    }
}

return {
    getFishReelbackVfxData = function(p1) -- getFishReelbackVfxData | line: 10
        -- upvalues: t1 (copy)
        return t1[p1]
    end,
    fishReelbackVfxData = t1
}

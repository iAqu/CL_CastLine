-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectIsInFishingArea = function(p1) -- selectIsInFishingArea | line: 2
        return p1.fishingArea.isInFishingArea
    end,
    selectFishingAreaCenter = function(p2) -- selectFishingAreaCenter | line: 5
        return p2.fishingArea.fishingAreaCenter
    end
}

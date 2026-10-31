-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectLuckyBlockActiveDrop = function(p1) -- selectLuckyBlockActiveDrop | line: 2
        return p1.luckyBlockDrop.activeDrop
    end,
    selectLuckyBlockNextDropTimestamp = function(p2) -- selectLuckyBlockNextDropTimestamp | line: 5
        return p2.luckyBlockDrop.nextDropTimestamp
    end,
    selectLuckyBlockReveal = function(p3) -- selectLuckyBlockReveal | line: 8
        return p3.luckyBlockDrop.reveal
    end,
    selectLuckyBlockBanner = function(p4) -- selectLuckyBlockBanner | line: 11
        return p4.luckyBlockDrop.banner
    end
}

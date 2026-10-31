-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectCurrentWindow = function(p1) -- selectCurrentWindow | line: 2
        return p1.currentWindow.currentWindow
    end,
    selectCurrentShopId = function(p2) -- selectCurrentShopId | line: 5
        return p2.currentWindow.currentShopId
    end,
    selectCharmAttributesTierId = function(p3) -- selectCharmAttributesTierId | line: 8
        return p3.currentWindow.charmTierId
    end,
    selectAquariumShopSection = function(p4) -- selectAquariumShopSection | line: 11
        return p4.currentWindow.aquariumShopSection
    end,
    selectOpenShopPrompt = function(p5) -- selectOpenShopPrompt | line: 14
        return p5.currentWindow.openShopPrompt
    end
}

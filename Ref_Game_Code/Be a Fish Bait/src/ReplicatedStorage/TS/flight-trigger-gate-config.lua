-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    flightTriggerGateConfig = {
        assetFolderName = "SubwaySurf",
        assetModelName = "FlightTriggerGate",
        detectableAreaName = "DetectableArea",
        firstZone = "rare",
        minPowerZoneGate = "epic",
        smallestRingSizeScale = 0.5,
        comboToSmallestRingSize = 7,
        zonePositionAlpha = 0.2,
        gateOffsetMin = 10,
        gateOffsetMax = 48,
        lateralLeeway = 10,
        boundaryPadding = 1,
        sideWeightingDeadzone = 30,
        sideWeightingMaxBiasWallDistance = 30,
        sideWeightingMinimumChance = 0.2,
        detectorPadding = 1,
        debugLogging = true,
        passVfxName = "FlightTriggeredVFX",
        passVfxDuration = 1,
        passSfxName = "FlightTriggeredSFX"
    }
}

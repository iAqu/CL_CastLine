-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local combineProducers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local metadataSlice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "metadata").metadataSlice
local statsSlice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "stats").statsSlice
local rewardsSlice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "rewards").rewardsSlice
local plotSlice = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "plot").plotSlice

return {
    playerDataSlice = combineProducers({
        metadata = metadataSlice,
        stats = statsSlice,
        inventory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "inventory").inventorySlice,
        rewards = rewardsSlice,
        plot = plotSlice,
        tutorialTracking = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "tutorial-tracking").tutorialTrackingSlice,
        gamepasses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "gamepasses").gamepassesSlice,
        purchaseHistory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "purchase-history").purchaseHistorySlice,
        bundlePurchaseHistory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "bundle-purchase-history").bundlePurchaseHistorySlice,
        aquarium = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "aquarium").aquariumSlice,
        offlineEarnings = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "offline-earnings").offlineEarningsSlice,
        collectionIndex = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "collection-index").collectionIndexSlice,
        rebirth = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "rebirth").rebirthSlice,
        titles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "titles").titlesSlice,
        baitAuras = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "bait-auras").baitAurasSlice,
        fishDisplay = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "fish-display").fishDisplaySlice,
        fishReelbackVfx = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "fish-reelback-vfx").fishReelbackVfxSlice,
        emotes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "emotes").emotesSlice,
        danceFloorAura = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "dance-floor-aura").danceFloorAuraSlice,
        hallOfFame = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "hall-of-fame").hallOfFameSlice,
        charms = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "charms").charmsSlice,
        mounts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "mounts").mountsSlice,
        zoneGacha = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "zone-gacha").zoneGachaSlice,
        rodSkins = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "rod-skins").fishingRodSkinsSlice,
        materials = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "materials").materialsSlice,
        fishingContracts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "fishing-contracts").fishingContractsSlice
    })
}

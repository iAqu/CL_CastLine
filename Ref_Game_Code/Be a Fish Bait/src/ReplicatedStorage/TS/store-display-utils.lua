-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getServerLuckMultiplierForTier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "server-luck-types").getServerLuckMultiplierForTier
local StoreProductType = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").StoreProductType
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local fishingRodSkinsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins").fishingRodSkinsData
local getMountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishData

return {
    getStoreProductDisplayInfo = function(p1) -- getStoreProductDisplayInfo | line: 8
        -- upvalues: getServerLuckMultiplierForTier (copy), StoreProductType (copy), abbreviate (copy), fishingRodSkinsData (copy), getMountFishData (copy)
        local storeProductConfiguration = p1.storeProductConfiguration
        local storeProductType = storeProductConfiguration.storeProductType

        if storeProductType == StoreProductType.AquariumCrate then
            return {
                title = ("%*x Aquarium Skin Crate%*"):format(storeProductConfiguration.quantity, storeProductConfiguration.quantity == 1 and "" or "s")
            }
        end

        if storeProductType == StoreProductType.Gamepass then
            return {
                title = storeProductConfiguration.gamepassTitle
            }
        end

        if storeProductType == StoreProductType.Bundle then
            return {
                title = storeProductConfiguration.bundleTitle
            }
        end

        if storeProductType == StoreProductType.Title then
            return {
                title = "OG Prime"
            }
        end

        if storeProductType == StoreProductType.Charm then
            return {
                title = "FOMO Charm"
            }
        end

        if storeProductType == StoreProductType.HologramSkin then
            return {
                title = "Fish Hologram Skin"
            }
        end

        if storeProductType == StoreProductType.ServerLuck then
            local tier = storeProductConfiguration.tier
            local v1 = getServerLuckMultiplierForTier(tier)

            return {
                title = ("%*x > %*x Server Luck"):format(if tier == 1 then 1 else getServerLuckMultiplierForTier(1), v1)
            }
        end

        if storeProductType == StoreProductType.MoneyPack then
            return {
                title = ("$%*"):format((abbreviate(storeProductConfiguration.cashAmount)))
            }
        end

        if storeProductType == StoreProductType.Reroll then
            local rerolls = storeProductConfiguration.rerolls

            return {
                title = ("%*x Reroll%*"):format(rerolls, rerolls == 1 and "" or "s")
            }
        end

        if storeProductType == StoreProductType.AquariumSkin then
            return {
                title = ("%* Aquarium Skin"):format(storeProductConfiguration.skinName)
            }
        end

        if storeProductType == StoreProductType.MountFish then
            local v2 = getMountFishData(storeProductConfiguration.mountFishName)

            if v2 ~= nil then
                v2 = v2.displayName
            end

            if v2 == nil then
                v2 = storeProductConfiguration.mountFishName
            end

            return {
                title = v2
            }
        end

        if storeProductType == StoreProductType.TimeSkip then
            return {
                title = `{ storeProductConfiguration.seconds / 60 }m Time Skip`
            }
        end

        if storeProductType == StoreProductType.PlaytimeWheelExtraSpin then
            local spinCount = storeProductConfiguration.spinCount

            return {
                title = ("%*x Wheel Spin%*"):format(spinCount, spinCount == 1 and "" or "s")
            }
        end

        if storeProductType == StoreProductType.SkipRebirth then
            return {
                title = ("Skip Rebirth %*"):format(storeProductConfiguration.level)
            }
        end

        if storeProductType == StoreProductType.SkipAquariumUpgrade then
            return {
                title = ("Skip Aquarium Upgrade Tier %*"):format(storeProductConfiguration.tier)
            }
        end

        if storeProductType == StoreProductType.PowerBoost then
            return {
                title = `+{ storeProductConfiguration.bonusMultiplier * 100 }% Power Boost`
            }
        end

        if storeProductType == StoreProductType.BaitAuraSlot then
            return {
                title = `Bait Aura Slot { storeProductConfiguration.slotIndex + 1 }`
            }
        end

        if storeProductType == StoreProductType.BackpackCapacity then
            return {
                title = "+20 Backpack Slots"
            }
        end

        if storeProductType == StoreProductType.TrainingWeight then
            return {
                title = storeProductConfiguration.weightId
            }
        end

        if storeProductType == StoreProductType.FishingRod then
            return {
                title = storeProductConfiguration.rodId
            }
        end

        if storeProductType == StoreProductType.FishingRodSkin then
            local t5 = {}
            local v3 = fishingRodSkinsData[storeProductConfiguration.skinId]

            if v3 ~= nil then
                v3 = v3.name
            end

            if v3 ~= nil then
                t5.title = v3

                return t5
            end

            t5.title = storeProductConfiguration.skinId

            return t5
        end

        if storeProductType == StoreProductType.ExclusiveFish then
            return {
                title = storeProductConfiguration.fishName
            }
        end

        if storeProductType == StoreProductType.OfflineEarningsMultiplier then
            return {
                title = "Offline Earnings x10"
            }
        end

        return {
            title = "Item"
        }
    end
}

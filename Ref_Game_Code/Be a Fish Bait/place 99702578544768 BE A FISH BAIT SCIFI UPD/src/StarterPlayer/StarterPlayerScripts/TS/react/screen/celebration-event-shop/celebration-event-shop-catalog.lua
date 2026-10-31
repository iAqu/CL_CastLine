-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config")
local auraRerollShopItems, celebrationTimeSkipShopItems, fomoAquariumSkinShopItemId, fomoAquariumSkinTicketPrice = v1.auraRerollShopItems, v1.celebrationTimeSkipShopItems, v1.fomoAquariumSkinShopItemId, v1.fomoAquariumSkinTicketPrice
local fomoCharmShopItemId, fomoCharmTicketPrice, fomoOrbitShopItemId, fomoOrbitTicketMultiplier = v1.fomoCharmShopItemId, v1.fomoCharmTicketPrice, v1.fomoOrbitShopItemId, v1.fomoOrbitTicketMultiplier
local fomoOrbitTicketPrice, fishHologramSkinShopItemId, fishHologramSkinTicketPrice, markOfTheOgShopItemId = v1.fomoOrbitTicketPrice, v1.fishHologramSkinShopItemId, v1.fishHologramSkinTicketPrice, v1.markOfTheOgShopItemId
local markOfTheOgTicketPrice, ogPrimeDeveloperProductId, ogPrimeRobuxPrice, ogPrimeShopItemId = v1.markOfTheOgTicketPrice, v1.ogPrimeDeveloperProductId, v1.ogPrimeRobuxPrice, v1.ogPrimeShopItemId
local premiumFomoCharmDeveloperProductId, premiumFishHologramDeveloperProductId = v1.premiumFomoCharmDeveloperProductId, v1.premiumFishHologramDeveloperProductId
local FOMO = getAquariumSkinData("FOMO")

assert(FOMO, "Unknown Aquarium Skin \"FOMO\"")

local t1 = {
    {
        id = "mark-of-the-og-pair",
        standard = {
            currency = "tickets",
            itemType = "Title",
            name = "Player Title",
            stockCurrent = 1,
            stockMax = 1,
            titleId = "markOfTheOg",
            icon = images.eventCalendarIcon,
            id = markOfTheOgShopItemId,
            price = markOfTheOgTicketPrice
        },
        premium = {
            currency = "robux",
            itemType = "Premium Title",
            name = "Player Title",
            stockCurrent = 1,
            stockMax = 1,
            titleId = "ogPrime",
            icon = images.vipCrownIcon,
            id = ogPrimeShopItemId,
            price = ogPrimeRobuxPrice,
            productId = ogPrimeDeveloperProductId
        }
    },
    {
        id = "fomo-charm-pair",
        standard = {
            currency = "tickets",
            itemType = "Charm",
            name = "FOMO Charm",
            previewCharmId = "fomo",
            stockCurrent = 1,
            stockMax = 1,
            icon = images.fomoCharm,
            id = fomoCharmShopItemId,
            price = fomoCharmTicketPrice
        },
        premium = {
            currency = "robux",
            id = "fomo-charm-vip",
            itemType = "Premium Charm",
            name = "FOMO Charm",
            price = 329,
            priceText = "329 R$",
            previewCharmId = "premiumFomo",
            stockCurrent = 1,
            stockMax = 1,
            icon = images.premFomoCharm,
            productId = premiumFomoCharmDeveloperProductId
        }
    },
    {
        id = "hook-showcase-pair",
        standard = {
            currency = "tickets",
            itemType = "Hook Showcase",
            name = "Fish Hologram Skin",
            stockCurrent = 1,
            stockMax = 1,
            icon = images.CakeFishHologram,
            id = fishHologramSkinShopItemId,
            price = fishHologramSkinTicketPrice
        },
        premium = {
            currency = "robux",
            id = "hook-showcase-skin-vip",
            itemType = "Premium Hook Showcase",
            name = "Fish Hologram Skin",
            price = 199,
            stockCurrent = 1,
            stockMax = 1,
            icon = images.FOMOCakeFishHologram,
            productId = premiumFishHologramDeveloperProductId
        }
    }
}
local t2 = {}
local t3 = {
    {
        animatedIconGlow = true,
        currency = "tickets",
        description = "+4% Cash boost when owned.",
        iconPositionX = 0.2,
        iconScale = 1.5,
        itemType = "Aquarium Skin",
        longSectionType = "LongRainbowSection",
        name = "FOMO Aquarium Skin",
        icon = FOMO.imageId,
        id = fomoAquariumSkinShopItemId,
        price = fomoAquariumSkinTicketPrice
    },
    {
        currency = "tickets",
        description = "Party-themed enhanced visuals whenever your fish reels back.",
        id = "PartyFishLandingVFX",
        itemType = "Reelback VFX",
        name = "FOMO Fish Reelback VFX",
        price = 500,
        stockCurrent = 1,
        stockMax = 1,
        icon = images.reelbackVfxIcon
    },
    {
        animatedIconGlow = true,
        currency = "tickets",
        description = "Dance animation you can use on the dance floor.",
        id = "Scuba",
        itemType = "Dance Animation",
        name = "Scubaaa Scubaaa",
        price = 300,
        stockCurrent = 1,
        stockMax = 1,
        icon = images.scubaEmoteIcon
    },
    {
        currency = "tickets",
        name = "FOMO Disco Blaze",
        resetsDaily = true,
        showStock = true,
        stockCurrent = 24,
        stockMax = 24,
        description = ("A disco ball orbits you & gives you x%* FOMO Tickets for 1 hour."):format(fomoOrbitTicketMultiplier),
        descriptionRichText = ("A disco ball orbits you & gives you <font color=\"#FF4FD8\">x%* FOMO Tickets for 1 hour.</font>"):format(fomoOrbitTicketMultiplier),
        icon = images.discoOrbitIcon,
        id = fomoOrbitShopItemId,
        price = fomoOrbitTicketPrice
    }
}
local t4 = {}
local v2 = #t4
local v3 = table.create(#celebrationTimeSkipShopItems)

local function v4(p1) -- line: 162
    -- upvalues: images (copy)
    return {
        currency = "tickets",
        resetsDaily = true,
        stockCurrent = 1,
        stockMax = 1,
        icon = images.timeSkipIcon,
        id = p1.id,
        name = ("Time Skip (%* Min)"):format(p1.minutes),
        price = p1.price
    }
end

for v5, v6 in celebrationTimeSkipShopItems do
    local _ = v5 - 1

    v3[v5] = {
        currency = "tickets",
        resetsDaily = true,
        stockCurrent = 1,
        stockMax = 1,
        icon = images.timeSkipIcon,
        id = v6.id,
        name = ("Time Skip (%* Min)"):format(v6.minutes),
        price = v6.price
    }
end

local v7 = #v3

table.move(v3, 1, v7, v2 + 1, t4)

local v8 = v2 + v7
local v9 = table.create(#auraRerollShopItems)

local function v10(p2, p3) -- line: 183
    -- upvalues: images (copy)
    return {
        currency = "tickets",
        stockCurrent = 1,
        stockMax = 1,
        icon = images.baitAuraRerollOneX,
        id = p2.id,
        name = ("Aura Reroll (%*%*)"):format(p3 + 1, if p3 == 0 then "st" elseif p3 == 1 then "nd" else "rd"),
        price = p2.price
    }
end

for v11, v12 in auraRerollShopItems do
    v9[v11] = v10(v12, v11 - 1, auraRerollShopItems)
end

table.move(v9, 1, #v9, v8 + 1, t4)

return {
    premiumFomoCharmShopItemId = "fomo-charm-vip",
    premiumHookShowcaseSkinShopItemId = "hook-showcase-skin-vip",
    scubaEmoteShopItemId = "Scuba",
    fomoCharmShopItemId = fomoCharmShopItemId,
    hookShowcaseSkinShopItemId = fishHologramSkinShopItemId,
    auraRerollShopItems = auraRerollShopItems,
    celebrationEventShopCosmeticPairs = t1,
    celebrationEventShopComingSoonItems = t2,
    celebrationEventShopFeaturedItems = t3,
    celebrationEventShopMoreRewards = t4
}

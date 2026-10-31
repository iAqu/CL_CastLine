-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumMultiverseSkinMutationLuckSet, aquariumMultiverseSkinMutationLuckSetBonus, aquariumSkinMutationLuckSet, aquariumSkinMutationLuckSetBonus = v1.aquariumMultiverseSkinMutationLuckSet, v1.aquariumMultiverseSkinMutationLuckSetBonus, v1.aquariumSkinMutationLuckSet, v1.aquariumSkinMutationLuckSetBonus
local getAquariumSkinData = v1.getAquariumSkinData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        isFirstPurchase = true,
        productId = 3612312753,
        quantity = 1,
        seriesId = "sports-crate"
    },
    {
        productId = 3612312909,
        quantity = 1,
        seriesId = "sports-crate"
    },
    {
        productId = 3612312944,
        quantity = 3,
        seriesId = "sports-crate"
    },
    {
        productId = 3612313092,
        quantity = 10,
        seriesId = "sports-crate"
    },
    {
        isFirstPurchase = true,
        productId = 3628095091,
        quantity = 1,
        seriesId = "multiverse-crate"
    },
    {
        productId = 3628092414,
        quantity = 1,
        seriesId = "multiverse-crate"
    },
    {
        productId = 3628090956,
        quantity = 3,
        seriesId = "multiverse-crate"
    },
    {
        productId = 3628089304,
        quantity = 10,
        seriesId = "multiverse-crate"
    }
}
local t2 = {
    rare = 7300,
    epic = 2300,
    legendary = 300,
    mythic = 100
}

local function createAquariumCrateEntry(p1) -- line: 77
    -- upvalues: getAquariumSkinData (copy), t2 (copy)
    local v2 = getAquariumSkinData(p1)

    assert(v2 ~= nil, (("Aquarium crate skin \"%*\" is not configured"):format(p1)))

    local v5 = t2[v2.rarity]

    assert(v5 ~= nil, (("Aquarium crate skin \"%*\" has unsupported rarity \"%*\""):format(p1, v2.rarity)))

    return {
        skin = v2,
        weightBasisPoints = v5
    }
end

local t3 = {
    displayName = "Sports",
    id = "sports-crate",
    crateImageId = images.sportsCrateIcon,
    entries = {
        createAquariumCrateEntry(aquariumSkinMutationLuckSet[1]),
        createAquariumCrateEntry(aquariumSkinMutationLuckSet[2]),
        createAquariumCrateEntry(aquariumSkinMutationLuckSet[3]),
        (createAquariumCrateEntry(aquariumSkinMutationLuckSet[4]))
    }
}
local t4 = {
    displayName = "Multiverse",
    id = "multiverse-crate",
    crateImageId = images.multiverseCrateImage,
    entries = {
        createAquariumCrateEntry(aquariumMultiverseSkinMutationLuckSet[1]),
        createAquariumCrateEntry(aquariumMultiverseSkinMutationLuckSet[2]),
        createAquariumCrateEntry(aquariumMultiverseSkinMutationLuckSet[3]),
        (createAquariumCrateEntry(aquariumMultiverseSkinMutationLuckSet[4]))
    }
}
local t5 = {
    t4,
    t3
}
local t6 = {
    [t3.id] = true,
    [t4.id] = true
}

local function getAquariumCrateSeriesById(p2) -- line: 115
    -- upvalues: t5 (copy)
    for v8, v9 in t5 do
        local _ = v8 - 1

        if v9.id == p2 == true then
            return v9
        end
    end

    return nil
end

local function isAquariumCrateSeriesReleased(p3) -- line: 130
    -- upvalues: t6 (copy)
    local v10 = t6[p3]

    if v10 == nil then
        v10 = false
    end

    return v10
end

local t7 = {
    [t3.id] = aquariumSkinMutationLuckSetBonus,
    [t4.id] = aquariumMultiverseSkinMutationLuckSetBonus
}

return {
    aquariumCrateHardPity = 75,
    aquariumSkinCratesReleased = true,
    aquariumMultiverseCrateReleased = true,
    firstAquariumCratePriceRobux = 67,
    singleAquariumCratePriceRobux = 149,
    threeAquariumCratesPriceRobux = 399,
    tenAquariumCratesPriceRobux = 1299,
    getAquariumCrateSeriesById = getAquariumCrateSeriesById,
    isAquariumCrateSeriesReleased = isAquariumCrateSeriesReleased,
    getAquariumCrateSeriesMutationLuckBonus = function(p4) -- getAquariumCrateSeriesMutationLuckBonus | line: 142
        -- upvalues: t7 (copy)
        local v11 = t7[p4]

        if v11 == nil then
            v11 = 0
        end

        return v11
    end,
    getAquariumCrateProduct = function(p5) -- getAquariumCrateProduct | line: 150
        -- upvalues: t1 (copy)
        if p5 <= 0 then
            return nil
        end

        for v12, v13 in t1 do
            local _ = v12 - 1

            if v13.productId == p5 == true then
                return v13
            end
        end

        return nil
    end,
    getAquariumCrateProductForQuantity = function(p6, p7, p8) -- getAquariumCrateProductForQuantity | line: 168
        -- upvalues: t1 (copy)
        local v14 = p8

        if p8 == nil then
            v14 = false
        end

        local v15

        for v16, v17 in t1 do
            local _ = v16 - 1

            if (v17.seriesId == p6 and v17.quantity == p7 and v17.isFirstPurchase == true == v14) == true then
                v15 = v17
                break
            end

            v15 = nil
        end

        return v15
    end,
    getAquariumCrateConfigurationErrors = function() -- getAquariumCrateConfigurationErrors | line: 186
        -- upvalues: t1 (copy), t5 (copy), t6 (copy)
        local t8 = {}

        for _, v18 in t5 do
            local entries = v18.entries

            if #entries ~= 4 then
                table.insert(t8, (("Aquarium crate series \"%*\" must contain exactly 4 entries"):format(v18.id)))
            end

            local t9 = {}
            local n1 = 0
            local n2 = 0

            for _, v20 in entries do
                if t9[v20.skin.name] ~= nil then
                    table.insert(t8, (("Duplicate aquarium crate skin \"%*\""):format(v20.skin.name)))
                end

                t9[v20.skin.name] = true

                if v20.weightBasisPoints <= 0 then
                    table.insert(t8, (("Aquarium crate skin \"%*\" must have a positive weight"):format(v20.skin.name)))
                end

                n1 += v20.weightBasisPoints

                if v20.skin.rarity == "mythic" then
                    n2 += 1

                    if v20.weightBasisPoints ~= 100 then
                        table.insert(t8, (("Mythic chase skin \"%*\" must have exactly 1%% weight"):format(v20.skin.name)))
                    end
                end
            end

            if n1 ~= 10000 then
                table.insert(t8, (("Aquarium crate series \"%*\" weights total %*, expected 10000"):format(v18.id, n1)))
            end

            if n2 ~= 1 then
                table.insert(t8, (("Aquarium crate series \"%*\" must contain exactly one mythic chase entry"):format(v18.id)))
            end
        end

        local t10 = {}

        for _, v26 in t1 do
            if v26.productId <= 0 then
                local v27 = t6[v26.seriesId]

                if v27 ~= nil and v27 then
                    table.insert(t8, (("Aquarium crate \"%*\" x%* Developer Product ID is not set"):format(v26.seriesId, v26.quantity)))
                end
            else
                if t10[v26.productId] ~= nil then
                    table.insert(t8, (("Duplicate Aquarium crate Developer Product ID %*"):format(v26.productId)))
                end

                t10[v26.productId] = true
            end
        end

        return t8
    end,
    aquariumCrateProducts = t1,
    activeAquariumCrateSeries = t3,
    multiverseAquariumCrateSeries = t4,
    aquariumCrateSeriesList = t5
}

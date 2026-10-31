-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local fishImages = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").fishImages
local t1 = {
    {
        fishName = "ApexTyrant",
        acquisitionMethod = "robux",
        availabilityStatus = "available",
        displayName = "ApexTyrant",
        indexVisible = true,
        mapDisplayEnabled = true,
        mapDisplayPromptEnabled = true,
        mpsMultiplier = 1.5,
        productId = 3606460430,
        robuxPrice = 499,
        stock = 999,
        unlockSource = "Robux",
        imageId = fishImages.apexTyrant
    },
    {
        fishName = "Phoenix",
        acquisitionMethod = "robux",
        availabilityStatus = "available",
        displayName = "Phoenix",
        indexVisible = true,
        mapDisplayEnabled = true,
        mapDisplayPromptEnabled = true,
        mpsMultiplier = 2.5,
        productId = 3606460406,
        robuxPrice = 2499,
        stock = 99,
        unlockSource = "Robux",
        imageId = fishImages.phoenix
    },
    {
        fishName = "FlameLord",
        acquisitionMethod = "dailyReward",
        availabilityStatus = "available",
        displayName = "Flame Lord",
        indexVisible = true,
        mapDisplayEnabled = false,
        mpsMultiplier = 1.25,
        unlockSource = "Day 7 Reward",
        imageId = fishImages.flameLord
    },
    {
        fishName = "Frostwyrm",
        acquisitionMethod = "wildEncounter",
        availabilityStatus = "available",
        bossFight = true,
        displayName = "Frostwyrm",
        indexVisible = true,
        isUnlimitedIndexed = true,
        mapDisplayEnabled = false,
        mpsMultiplier = 2,
        unlockSource = "ANY Zones (0.0009%)",
        imageId = fishImages.frostwyrm
    },
    {
        fishName = "UncThulu",
        acquisitionMethod = "wildEncounter",
        availabilityStatus = "modelPending",
        baseEncounterChance = 1E-04,
        bossFight = true,
        displayName = "Unc-thulu",
        indexVisible = true,
        isUnlimitedIndexed = true,
        mapDisplayEnabled = true,
        mapDisplayPromptEnabled = false,
        maxBuffedCatchChance = 0.000125,
        mpsMultiplier = 1.1,
        requiredWeather = "Unc's Calling",
        unlockSource = "ANY Zones (0.01%)",
        weatherEncounterChance = 0.001,
        imageId = fishImages.uncThulu
    },
    {
        fishName = "AuraMaximus",
        acquisitionMethod = "robux",
        availabilityStatus = "available",
        displayName = "Aura Maximus",
        indexVisible = true,
        mapDisplayEnabled = true,
        mapDisplayPromptEnabled = true,
        mpsMultiplier = 1.75,
        productId = 3611068058,
        robuxPrice = 999,
        stock = 2999,
        stockBackendMode = "existingDataStore",
        unlockSource = "Robux",
        imageId = fishImages.auraMaximus
    }
}

return {
    validateExclusiveFishConfigs = function() -- validateExclusiveFishConfigs | line: 87
        -- upvalues: t1 (copy)
        local t2 = {}
        local t3 = {}

        for _, v1 in t1 do
            if t3[v1.fishName] ~= nil then
                table.insert(t2, (("duplicate fishName %*"):format(v1.fishName)))
            end

            t3[v1.fishName] = true

            if v1.mpsMultiplier <= 0 then
                table.insert(t2, (("%* has invalid mpsMultiplier"):format(v1.fishName)))
            end

            if v1.maxBuffedCatchChance ~= nil and v1.maxBuffedCatchChance <= 0 then
                table.insert(t2, (("%* has invalid maxBuffedCatchChance"):format(v1.fishName)))
            end

            if v1.weatherEncounterChance ~= nil and v1.requiredWeather == nil then
                table.insert(t2, (("%* has weather odds without requiredWeather"):format(v1.fishName)))
            end

            if v1.stock ~= nil and v1.stock <= 0 then
                table.insert(t2, (("%* has invalid stock"):format(v1.fishName)))
            end
        end

        return t2
    end,
    getExclusiveFishConfigByProductId = function(p1) -- getExclusiveFishConfigByProductId | line: 117
        -- upvalues: t1 (copy)
        for v7, v8 in t1 do
            local _ = v7 - 1

            if (v8.productId == p1 and p1 ~= 0) == true then
                return v8
            end
        end

        return nil
    end,
    getExclusiveFishConfigByFishName = function(p2) -- getExclusiveFishConfigByFishName | line: 132
        -- upvalues: t1 (copy)
        for v9, v10 in t1 do
            local _ = v9 - 1

            if v10.fishName == p2 == true then
                return v10
            end
        end

        return nil
    end,
    exclusiveFishConfigs = t1
}

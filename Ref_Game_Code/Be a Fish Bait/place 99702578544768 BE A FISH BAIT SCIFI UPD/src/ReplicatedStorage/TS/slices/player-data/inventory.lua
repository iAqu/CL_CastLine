-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local hasSpaceInBackpack = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils").hasSpaceInBackpack
local slapWeaponItemId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "slap-weapon-utils").slapWeaponItemId
local v51 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 15
        p1[p2.userId] = p2.data.inventory
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 21
        p3[p4.userId] = nil
    end),
    pickaxeObtained = produceWrapper(function(p5, p6) -- line: 26
        -- upvalues: Workspace (copy)
        local v1 = p5[p6.userId]

        if not v1 then
            return nil
        end

        for _, v2 in v1 do
            if v2.itemType == "pickaxe" then
                v2.isEquipped = false
                v2.isInToolbar = false
            end
        end

        v1[p6.itemId] = {
            itemType = "pickaxe",
            isInToolbar = true,
            isEquipped = true,
            itemId = p6.itemId,
            itemName = p6.pickaxeName,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    fishingRodObtained = produceWrapper(function(p7, p8) -- line: 50
        -- upvalues: Workspace (copy)
        local v3 = p7[p8.userId]

        if not v3 then
            return nil
        end

        for _, v4 in v3 do
            if v4.itemType == "fishingRod" then
                v4.isEquipped = false
                v4.isInToolbar = false
            end
        end

        v3[p8.itemId] = {
            itemType = "fishingRod",
            isEquipped = true,
            isInToolbar = true,
            itemId = p8.itemId,
            itemName = p8.rodName,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    trainingWeightObtained = produceWrapper(function(p9, p10) -- line: 81
        -- upvalues: Workspace (copy)
        local v5 = p9[p10.userId]

        if not v5 then
            return nil
        end

        for _, v6 in v5 do
            if v6.itemType == "trainingWeight" then
                v6.isEquipped = false
                v6.isInToolbar = false
            end
        end

        v5[p10.itemId] = {
            itemType = "trainingWeight",
            isEquipped = false,
            isInToolbar = true,
            itemId = p10.itemId,
            itemName = p10.weightName,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    inventoryItemEquipped = produceWrapper(function(p11, p12) -- line: 112
        local v7 = p11[p12.userId]

        if not v7 then
            return nil
        end

        for _, v8 in v7 do
            if v8.itemId == p12.itemId then
                v8.isEquipped = true
            else
                v8.isEquipped = false
            end
        end
    end),
    inventoryItemUnequipped = produceWrapper(function(p13, p14) -- line: 127
        local v9 = p13[p14.userId]

        if not v9 then
            return nil
        end

        local v10 = v9[p14.itemId]

        if not v10 then
            return nil
        end

        v10.isEquipped = false
    end),
    fishObtained = produceWrapper(function(p15, p16) -- line: 141
        -- upvalues: Workspace (copy), hasSpaceInBackpack (copy)
        local v11 = p15[p16.userId]

        if not v11 or not hasSpaceInBackpack(v11, p16.backpackCapacity) then
            return nil
        end

        for _, v12 in v11 do
            v12.isEquipped = false
        end

        v11[p16.itemId] = {
            itemType = "fish",
            isEquipped = true,
            exclusiveIndex = p16.exclusiveIndex,
            fishObtainedTimestamp = p16.fishObtainedTimestamp,
            itemId = p16.itemId,
            itemName = p16.fishName,
            level = p16.level,
            mutations = p16.mutations,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    aquariumFishReturned = produceWrapper(function(p17, p18) -- line: 168
        -- upvalues: Workspace (copy), hasSpaceInBackpack (copy)
        local v13 = p17[p18.userId]

        if not v13 or not hasSpaceInBackpack(v13, p18.backpackCapacity) then
            return nil
        end

        v13[p18.itemId] = {
            itemType = "fish",
            isEquipped = false,
            exclusiveIndex = p18.exclusiveIndex,
            fishObtainedTimestamp = p18.fishObtainedTimestamp,
            itemId = p18.itemId,
            itemName = p18.fishName,
            level = p18.level,
            mutations = p18.mutations,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    aquariumFishUnequipped = produceWrapper(function(p19, p20) -- line: 192
        -- upvalues: Workspace (copy)
        local v14 = p19[p20.userId]

        if not v14 then
            return nil
        end

        v14[p20.fishId] = {
            isEquipped = false,
            itemType = "fish",
            exclusiveIndex = p20.exclusiveIndex,
            fishObtainedTimestamp = p20.fishObtainedTimestamp,
            itemId = p20.fishId,
            itemName = p20.fishSpecies,
            level = p20.level,
            mutations = p20.mutations,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    equipBestFishApplied = produceWrapper(function(p21, p22) -- line: 213
        -- upvalues: Workspace (copy)
        local v15 = p21[p22.userId]

        if not v15 then
            return nil
        end

        for _, v16 in p22.toRemove do
            v15[v16.fishId] = {
                isEquipped = false,
                itemType = "fish",
                exclusiveIndex = v16.exclusiveIndex,
                fishObtainedTimestamp = v16.fishObtainedTimestamp,
                itemId = v16.fishId,
                itemName = v16.fishSpecies,
                level = v16.level,
                mutations = v16.mutations,
                timeStampAdded = Workspace:GetServerTimeNow()
            }
        end

        for _, v17 in p22.toAdd do
            v15[v17.fishId] = nil
        end
    end),
    fishMutationSet = produceWrapper(function(p23, p24) -- line: 240
        local v18 = p23[p24.userId]

        if not v18 then
            return nil
        end

        local v19 = v18[p24.itemId]

        if not v19 or v19.itemType ~= "fish" then
            return nil
        end

        v19.mutations = p24.mutations
    end),
    fishRearranged = produceWrapper(function(p25, p26) -- line: 254
        local v20 = p25[p26.userId]

        if not v20 then
            return nil
        end

        local t3 = {}

        for v21, v22 in v20 do
            if v22.itemType == "fish" then
                table.insert(t3, {
                    v21,
                    v22
                })
            end
        end

        table.sort(t3, function(p27, p28) -- line: 268
            return p27[2].timeStampAdded < p28[2].timeStampAdded
        end)

        local t5 = {}

        for _, v23 in p26.preferredFishIds do
            t5[v23] = true
        end

        local t6 = {}
        local t7 = {}

        for _, v24 in t3 do
            if t5[v24[2].itemId] ~= nil then
                table.insert(t6, v24)
            else
                table.insert(t7, v24)
            end
        end

        table.sort(t6, function(p29, p30) -- line: 287
            -- upvalues: p26 (copy)
            local preferredFishIds = p26.preferredFishIds
            local itemId = p29[2].itemId
            local v25 = (table.find(preferredFishIds, itemId) or 0) - 1
            local preferredFishIds2 = p26.preferredFishIds
            local itemId2 = p30[2].itemId

            return v25 < (table.find(preferredFishIds2, itemId2) or 0) - 1
        end)

        local n1 = 0

        for _, v26 in t6 do
            local v27 = v26[2]
            local v28 = n1 + 1

            v27.timeStampAdded = n1
            n1 = v28
        end

        for _, v29 in t7 do
            local v30 = v29[2]
            local v31 = n1 + 1

            v30.timeStampAdded = n1
            n1 = v31
        end
    end),
    pickaxeSetInToolbar = produceWrapper(function(p31, p32) -- line: 309
        local v32 = p31[p32.userId]

        if not v32 then
            return nil
        end

        for _, v33 in v32 do
            if v33.itemType == "pickaxe" then
                v33.isInToolbar = false
                v33.isEquipped = false
            end
        end

        local v34 = v32[p32.itemId]

        if v34 and v34.itemType == "pickaxe" then
            v34.isInToolbar = true
            v34.isEquipped = true
        end
    end),
    equipmentSetInToolbar = produceWrapper(function(p33, p34) -- line: 329
        local v35 = p33[p34.userId]

        if not v35 then
            return nil
        end

        local v36 = v35[p34.itemId]

        if not v36 or v36.itemType ~= "fishingRod" and v36.itemType ~= "trainingWeight" then
            return nil
        end

        for _, v37 in v35 do
            if v37.itemType == v36.itemType then
                v37.isInToolbar = false
            end

            if v37.itemType == "fishingRod" or v37.itemType == "trainingWeight" then
                v37.isEquipped = false
            end
        end

        v36.isInToolbar = true
        v36.isEquipped = true
    end),
    slapWeaponGranted = produceWrapper(function(p35, p36) -- line: 355
        -- upvalues: Workspace (copy), slapWeaponItemId (copy)
        local v38 = p35[p36.userId]

        if not v38 then
            return nil
        end

        for _, v39 in v38 do
            v39.isEquipped = false
        end

        v38[slapWeaponItemId] = {
            itemType = "slapWeapon",
            isEquipped = true,
            isInToolbar = true,
            itemId = slapWeaponItemId,
            itemName = slapWeaponItemId,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    inventoryItemsRemoved = produceWrapper(function(p37, p38) -- line: 375
        local v40 = p37[p38.userId]

        if not v40 then
            return nil
        end

        for _, v41 in p38.itemIds do
            v40[v41] = nil
        end
    end),
    fishSold = produceWrapper(function(p39, p40) -- line: 386
        local v42 = p39[p40.userId]

        if not v42 then
            return nil
        end

        for _, v43 in p40.fishItemIds do
            v42[v43] = nil
        end
    end),
    aquariumFishAdded = produceWrapper(function(p41, p42) -- line: 397
        local v44 = p41[p42.userId]

        if not v44 then
            return nil
        end

        v44[p42.fishId] = nil
    end),
    showcaseFishSet = produceWrapper(function(p43, p44) -- line: 407
        local v45 = p43[p44.userId]

        if not v45 then
            return nil
        end

        v45[p44.itemId] = nil
    end),
    showcaseFishRetrieved = produceWrapper(function(p45, p46) -- line: 417
        -- upvalues: Workspace (copy), hasSpaceInBackpack (copy)
        local v46 = p45[p46.userId]

        if not v46 or not hasSpaceInBackpack(v46, p46.backpackCapacity) then
            return nil
        end

        v46[p46.itemId] = {
            isEquipped = false,
            itemType = "fish",
            exclusiveIndex = p46.exclusiveIndex,
            fishObtainedTimestamp = p46.fishObtainedTimestamp,
            itemId = p46.itemId,
            itemName = p46.fishSpecies,
            level = p46.level,
            mutations = p46.mutations,
            timeStampAdded = Workspace:GetServerTimeNow()
        }
    end),
    itemGifted = produceWrapper(function(p47, p48) -- line: 441
        -- upvalues: Workspace (copy)
        local v47 = p47[p48.gifterUserId]
        local v48 = p47[p48.receiverUserId]

        if v47 then
            v47[p48.item.itemId] = nil
        end

        if not v48 then
            return
        end

        for _, v49 in v48 do
            v49.isEquipped = false
        end

        local itemId = p48.item.itemId
        local v50 = table.clone(p48.item)

        setmetatable(v50, nil)
        v50.isEquipped = true
        v50.timeStampAdded = Workspace:GetServerTimeNow()
        v48[itemId] = v50
    end)
})

v51:getActions()

return {
    inventorySlice = v51
}

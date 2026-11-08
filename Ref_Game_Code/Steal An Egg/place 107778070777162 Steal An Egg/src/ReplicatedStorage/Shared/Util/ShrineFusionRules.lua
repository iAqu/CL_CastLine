-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FusionShrines = require(ReplicatedStorage.Shared.FusionShrines)
local t1 = {
    Tiers = FusionShrines.Tiers
}
local v1 = table.freeze({
    ["Light 8"] = "ArchAngel",
    ["Dark 8"] = "World Burner",
    ["Light 7"] = "Pegasus",
    ["Dark 7"] = "Skeleton Horse"
})

local function matchesInput(p1, p2) -- line: 16
    -- upvalues: v1 (copy)
    if p1 == p2 then
        return true
    end

    return v1[p1] == p2
end

function t1.Same(p3, p4) -- line: 20
    -- upvalues: t1 (copy)
    if type(p3) ~= "table" or type(p4) ~= "table" then
        return p3 == p4
    end

    for v2, v3 in p3 do
        if not t1.Same(v3, p4[v2]) then
            return false
        end
    end

    for v4 in p4 do
        if p3[v4] == nil then
            return false
        end
    end

    return true
end

function t1.Completed(p5, p6) -- line: 37
    return type(p5.ShrineFusion[p6]) == "table"
end

function t1.ResolveRecipes(p7, p8) -- line: 41
    -- upvalues: FusionShrines (copy)
    local t2 = {}
    local t3 = {}
    local t4 = {}

    for _, v6 in FusionShrines.Tiers do
        local v7 = FusionShrines.KindOfTier(v6)
        local v8 = p7[v6]
        local v9 = type(v8) == "table"
        local t5 = {}
        local v10 = table.clone(v7.Sides)

        table.insert(v10, "Fused")

        for _, v11 in v10 do
            local v12 = if v9 then v8[v11] else nil
            local v13 = if type(v12) == "string" then p8[v12] else nil

            if not v13 or v12 == "" or t5[v12] then
                v9 = false
            elseif not v7.RarityLocked or v13.Rarity._id == v6 then
                t5[v12] = true
            else
                v9 = false
            end
        end

        if v9 then
            t2[v6] = table.clone(v8)
            t4[v7.Id] = t4[v7.Id] or {}

            for v14 in t5 do
                local v15 = t4[v7.Id][v14]

                if v15 then
                    t3[v6] = "Ambiguous recipe"
                    t3[v15] = "Ambiguous recipe"
                end

                t4[v7.Id][v14] = v6
            end
        else
            t3[v6] = v7.RarityLocked and "Configure three distinct, registered animals with the correct rarity" or "Configure distinct, registered animals for every pad and the reward"
        end
    end

    for v16 in t3 do
        t2[v16] = nil
    end

    return t2, t3
end

function t1.EggCount(p9) -- line: 87
    local n1 = 0

    for _ in p9.EggInventory do
        n1 += 1
    end

    if type(p9.FusionEggReward) == "table" then
        n1 += 1
    end

    if p9.Rift and type(p9.Rift.PendingReward) == "table" then
        n1 += 1
    end

    return n1
end

function t1.CheckInput(p10, p11, p12, p13, p14, p15) -- line: 102
    -- upvalues: FusionShrines (copy), t1 (copy), v1 (copy)
    local v17, v18

    if p10 then
        if type(p10.ShrineFusion) == "table" then
            if p11 then
                v17 = p10.Inventory[p11]
            end

            v18 = false
        else
            v18 = true
        end
    else
        v18 = true
    end

    if v18 then
        return nil, "DATA_LOADING", "Loading your data. Please wait."
    end

    if not v17 then
        return nil, "HOLD_PET", p15.Copy.Hold(p12, p13)
    end

    local v19, v20

    for _, v21 in p15.Tiers do
        local v22 = p13[v21]

        if v22 then
            for _, v25 in p15.Sides do
                local Category = v17.Category
                local v26 = v22[v25]

                if Category == v26 or v1[Category] == v26 then
                    v20 = v25
                    v19 = v21
                end
            end
        end
    end

    if not v19 then
        return nil, "WRONG_ANIMAL", p15.Copy.Hold(p12, p13)
    end

    if t1.Completed(p10, v19) then
        return nil, "COMPLETED", p15.Copy.Done(v19)
    end

    if v20 ~= p12 then
        return nil, "WRONG_PAD", p15.Copy.WrongPad(v20)
    end

    if v17.IsFavorite then
        return nil, "FAVORITE", "Unfavorite this pet first. It will be used up."
    end

    if v17.InFuse or table.find(p10.FusionSlots or {}, p11) or table.find(p10.VIPFusionSlots or {}, p11) or table.find(p10.PrivateFusionSlots or {}, p11) then
        return nil, "RESERVED", "Take this pet out of the other fuse machine."
    end

    if table.find(p10.EquippedAssets or {}, p11) then
        return nil, "IN_PEN", "Remove this pet from your pen, then hold it."
    end

    if v17.SpecialLuckyBlockColumn or v17.PendingEggName then
        return nil, "RESERVED", "This pet is busy. Use another pet."
    end

    if v17.IsStolenDNA and not p14.AllowStolenDNA then
        return nil, "STOLEN_DNA", "Use a pet that isn't Stolen DNA."
    end

    if type(v17.Scale) ~= "number" or v17.Scale ~= v17.Scale or v17.Scale <= 0 or v17.Scale == 1e999 then
        return nil, "INVALID_PET", "Pet error. Rejoin and try again."
    end

    if t1.EggCount(p10) >= p14.EggLimit then
        return nil, "EGG_FULL", "Your egg inventory is full. Make room first."
    end

    return v19, "READY", p15.Copy.Ready(FusionShrines.Others(p15, p12), p13[v19])
end

function t1.BuildPatches(p16, p17, p18) -- line: 173
    -- upvalues: t1 (copy)
    local Sides, Placement = p18.Kind.Sides, p18.Kind.Placement
    local v27 = if Placement then Placement.Players else #Sides
    local t6 = {}

    for _, v28 in p17 do
        t6[v28] = true
    end

    local n2 = 0

    for _ in t6 do
        n2 += 1
    end

    if #p17 ~= v27 or n2 ~= v27 then
        return false, "TWO_PLAYERS", "One player on each pad."
    end

    local t7 = {}
    local t8 = {}

    for v29, v30 in p17 do
        local v31 = p18.Inputs[v29]
        local v32 = p16[v30]
        local v33 = v31.Pets or {
            [Sides[v29]] = v31
        }

        t8[v29] = {}

        for v34, v35 in v33 do
            local v36, v37, v38 = t1.CheckInput(v32, v35.Uid, v34, p18.Recipes, p18.Options, p18.Kind)

            if not v36 then
                return false, v37, v38
            end

            if v36 ~= p18.Tier then
                return false, "MISMATCH", p18.Kind.Copy.Mismatch
            end

            if not t1.Same(v32.Inventory[v35.Uid], v35.Snapshot) then
                return false, "PET_CHANGED", "Pet changed. Hold it and try again."
            end

            local v39 = v32.Inventory[v35.Uid]

            table.insert(t7, v39 ~= nil and (v39.CreatorTemporary == true or v32.CreatorProfile ~= nil))
            t8[v29][v35.Uid] = true
        end

        local v41 = p18.Grants[v29]

        if v32.EggInventory[v41.Uid] or v41.Record.AssetCategory ~= p18.Recipes[p18.Tier].Fused then
            return false, "INVALID_REWARD", "Reward check failed."
        end
    end

    if table.find(t7, not t7[1]) then
        return false, "TEMPORARY_MISMATCH", "Both pets must be temporary creator pets, or neither."
    end

    local t9 = {}

    for v42, v43 in p17 do
        local v44 = p18.Grants[v42]

        if t7[1] then
            v44.Record.CreatorTemporary = true
        end

        t9[v43] = {
            Remove = t8[v42],
            MutateStore = function(p19) -- MutateStore | line: 242
                -- upvalues: p18 (copy), t7 (copy), v44 (copy)
                local v45 = table.clone(p19.EggInventory)

                v45[v44.Uid] = v44.Record
                p19.EggInventory = v45

                if t7[1] and p18.MarkTemporary then
                    p18.MarkTemporary(p19)
                end

                local v46 = table.clone(p19.ShrineFusion)

                v46[p18.Tier] = {
                    TransactionId = p18.Id,
                    EggUid = v44.Uid,
                    CompletedAt = p18.CompletedAt
                }
                p19.ShrineFusion = v46
            end
        }
    end

    return t9
end

return table.freeze(t1)

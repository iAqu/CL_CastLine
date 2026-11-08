-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggSkins = require(ReplicatedStorage.Data.EggSkins)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local t1 = {
    {
        Id = "Verdant",
        DisplayName = "Riftborn",
        EggSkin = "Riftborn",
        Weight = 55,
        From = "Volcano",
        To = "Abyss Ocean",
        Pets = {
            {
                AssetId = "Rift Eye",
                Weight = 45
            },
            {
                AssetId = "Voidmaw",
                Weight = 36
            },
            {
                AssetId = "Ventinal",
                Weight = 15
            },
            {
                AssetId = "Wendigo",
                Weight = 3.5
            },
            {
                AssetId = "World Eater",
                Weight = 0.5
            }
        }
    },
    {
        Id = "Umbral",
        DisplayName = "Riftbeasts",
        EggSkin = "Riftbeasts",
        Weight = 40,
        From = "Prehistoric",
        To = "Cosmic",
        Pets = {
            {
                AssetId = "Void Angler",
                Weight = 45
            },
            {
                AssetId = "Riftwing",
                Weight = 36
            },
            {
                AssetId = "Dreadclaw",
                Weight = 15
            },
            {
                AssetId = "Mawbreaker",
                Weight = 3.5
            },
            {
                AssetId = "Void Serpent",
                Weight = 0.5
            }
        }
    },
    {
        Id = "Radiant",
        DisplayName = "Shattered Rift",
        EggSkin = "ShatteredRift",
        Weight = 5,
        From = "Cherry Blossom",
        To = "Titan Temple",
        Pets = {
            {
                AssetId = "Shardling",
                Weight = 45
            },
            {
                AssetId = "Shattered Ram",
                Weight = 36
            },
            {
                AssetId = "Shardwing",
                Weight = 15
            },
            {
                AssetId = "Shattered Drake",
                Weight = 3.5
            },
            {
                AssetId = "Shattered Colossus",
                Weight = 0.5
            }
        }
    }
}
local t2 = {
    {
        Biomes = 4,
        TargetSpawn = 30,
        SpawnSpread = 9
    },
    {
        Biomes = 3,
        TargetSpawn = 16,
        SpawnSpread = 9
    },
    {
        Biomes = 2,
        TargetSpawn = 14,
        SpawnSpread = 9
    }
}
local t3 = {}

for _, v1 in t1 do
    t3[v1.Id] = v1
end

local t4 = {}

function t4.RotationSeconds() -- line: 93
    -- upvalues: RiftFlags (copy)
    return RiftFlags.RotationSeconds:Get()
end

t4.RequirementCount = #t2
t4.RecipeSlots = t2
t4.Banners = t1

function t4.GetBanner(p1) -- line: 100
    -- upvalues: t3 (copy)
    return t3[p1]
end

function t4.BannerIds() -- line: 104
    -- upvalues: t1 (copy)
    local t5 = {}

    for _, v2 in t1 do
        table.insert(t5, v2.Id)
    end

    return t5
end

function t4.GetBannerDisplayName(p2) -- line: 112
    -- upvalues: t3 (copy)
    local v3 = t3[p2]

    if v3 then
        return v3.DisplayName
    end

    return p2
end

function t4.GetBannerEggSkin(p3) -- line: 118
    -- upvalues: t3 (copy)
    local v4 = t3[p3]

    return if v4 then v4.EggSkin else nil
end

function t4.GetBannerEggIcon(p4) -- line: 123
    -- upvalues: EggSkins (copy), t4 (copy)
    local v5 = EggSkins.Get(t4.GetBannerEggSkin(p4))

    return if v5 then v5.Icon else nil
end

function t4.GetBannerWeight(p5) -- line: 130
    -- upvalues: RiftFlags (copy), t3 (copy)
    local v6 = RiftFlags.BannerWeights:Get()[p5]

    if v6 ~= nil then
        return v6
    end

    local v7 = t3[p5]

    if v7 then
        return v7.Weight
    end

    return 0
end

function t4.GetBannerRange(p6) -- line: 140
    -- upvalues: RiftFlags (copy), t3 (copy)
    local v8 = t3[p6]

    assert(v8 ~= nil, (("unknown rift banner %*"):format(p6)))

    local v11 = RiftFlags.BannerRanges:Get()[p6]
    local From = if v11 == nil or v11.From == nil then v8.From else v11.From

    if v11 == nil or v11.To == nil then
        return From, v8.To
    end

    return From, v11.To
end

function t4.GetRecipeSlot(p7) -- line: 153
    -- upvalues: RiftFlags (copy), t2 (copy)
    local v12 = t2[p7]

    assert(v12 ~= nil, (("the Rift has no recipe slot %*"):format(p7)))

    local v15 = RiftFlags.SlotOverrides:Get()[tostring(p7)]

    if v15 == nil then
        return v12
    end

    return {
        Biomes = v15.Biomes or v12.Biomes,
        TargetSpawn = v15.TargetSpawn or v12.TargetSpawn,
        SpawnSpread = v15.SpawnSpread or v12.SpawnSpread
    }
end

function t4.PetOverrideKey(p8, p9) -- line: 167
    return p8 .. ":" .. p9
end

function t4.GetPetWeight(p10, p11) -- line: 171
    -- upvalues: RiftFlags (copy), t3 (copy), t4 (copy)
    local v16 = RiftFlags.PetWeights:Get()[t4.PetOverrideKey(p10, p11)]

    if v16 ~= nil then
        return v16
    end

    local v17 = t3[p10]

    if v17 ~= nil then
        for _, v18 in v17.Pets do
            if v18.AssetId == p11 then
                return v18.Weight
            end
        end
    end

    return 0
end

function t4.BannerContainsPet(p12, p13) -- line: 189
    -- upvalues: t3 (copy)
    local v19 = t3[p12]

    if v19 ~= nil then
        for _, v20 in v19.Pets do
            if v20.AssetId == p13 then
                return true
            end
        end
    end

    return false
end

function t4.RollPet(p14, p15) -- line: 202
    -- upvalues: t3 (copy), t4 (copy)
    local v21 = t3[p14]

    if v21 == nil then
        return nil
    end

    local t7 = {}
    local n1 = 0

    for v22, v23 in v21.Pets do
        local v24 = t4.GetPetWeight(p14, v23.AssetId)

        t7[v22] = v24

        if v24 > 0 then
            n1 += v24
        end
    end

    if n1 <= 0 then
        return nil
    end

    local v25 = p15:NextNumber() * n1
    local n2 = 0
    local AssetId

    for v26, v27 in v21.Pets do
        local v28 = t7[v26]

        if not (v28 <= 0) then
            n2 += v28
            AssetId = v27.AssetId

            if v25 <= n2 then
                return v27.AssetId
            end
        end
    end

    return AssetId
end

local function petsByWeight(p16) -- line: 239
    -- upvalues: t3 (copy), t4 (copy)
    local v29 = t3[p16]

    if v29 == nil then
        return {}
    end

    local t8 = {}

    for _, v30 in v29.Pets do
        local v31 = t4.GetPetWeight(p16, v30.AssetId)

        if v31 > 0 then
            table.insert(t8, {
                AssetId = v30.AssetId,
                Weight = v31
            })
        end
    end

    table.sort(t8, function(p17, p18) -- line: 251
        if p17.Weight == p18.Weight then
            return p17.AssetId < p18.AssetId
        end

        return p17.Weight > p18.Weight
    end)

    return t8
end

function t4.ChasePetId(p19) -- line: 260
    -- upvalues: petsByWeight (copy)
    local v32 = petsByWeight(p19)
    local v33 = v32[#v32]

    return if v33 then v33.AssetId else nil
end

function t4.PityPool(p20) -- line: 268
    -- upvalues: RiftFlags (copy), petsByWeight (copy)
    local v34 = petsByWeight(p20)
    local v35 = RiftFlags.PityWeights:Get()
    local v38 = math.min(#v35, #v34)
    local t10 = {}

    for i = 1, v38 do
        table.insert(t10, {
            AssetId = v34[#v34 - v38 + i].AssetId,
            Weight = v35[i]
        })
    end

    return t10
end

function t4.RollPityPet(p21, p22) -- line: 280
    -- upvalues: t4 (copy)
    local v39 = t4.PityPool(p21)
    local n3 = 0

    for _, v40 in v39 do
        if v40.Weight > 0 then
            n3 += v40.Weight
        end
    end

    if n3 <= 0 then
        return t4.ChasePetId(p21)
    end

    local v41 = p22:NextNumber() * n3
    local n4 = 0
    local AssetId

    for _, v42 in v39 do
        if not (v42.Weight <= 0) then
            n4 += v42.Weight
            AssetId = v42.AssetId

            if v41 <= n4 then
                return v42.AssetId
            end
        end
    end

    return AssetId
end

function t4.CurrentPeriod() -- line: 312
    -- upvalues: Workspace (copy), t4 (copy)
    return (math.floor(Workspace:GetServerTimeNow() / t4.RotationSeconds()))
end

function t4.BannerIdForPeriod(p23) -- line: 316
    -- upvalues: t1 (copy), t4 (copy)
    local n5 = 0

    for _, v44 in t1 do
        n5 += t4.GetBannerWeight(v44.Id)
    end

    if n5 <= 0 then
        return t1[1].Id
    end

    local v45 = Random.new(p23):NextNumber() * n5
    local n6 = 0

    for _, v46 in t1 do
        n6 += t4.GetBannerWeight(v46.Id)

        if v45 <= n6 then
            return v46.Id
        end
    end

    return t1[#t1].Id
end

function t4.CurrentBannerId() -- line: 336
    -- upvalues: t4 (copy)
    return t4.BannerIdForPeriod(t4.CurrentPeriod())
end

function t4.SecondsUntilRotation() -- line: 340
    -- upvalues: Workspace (copy), t4 (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v47 = t4.RotationSeconds()

    return v47 - ServerTimeNow % v47
end

return table.freeze(t4)

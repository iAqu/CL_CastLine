-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggSkins = require(ReplicatedStorage.Data.EggSkins)
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local t1 = {
    {
        Id = "Biohazard",
        DisplayName = "Biohazard Pets",
        EggSkin = "Biohazard",
        Weight = 42.5,
        From = "Cosmic",
        To = "Cherry Blossom",
        Pets = {
            {
                AssetId = "Toxic Rat",
                Weight = 45
            },
            {
                AssetId = "Radcoon",
                Weight = 36
            },
            {
                AssetId = "Toucax",
                Weight = 15
            },
            {
                AssetId = "Nuceodille",
                Weight = 3.5
            },
            {
                AssetId = "Nuclear Mantis",
                Weight = 0.5
            }
        }
    },
    {
        Id = "Experimental",
        DisplayName = "Experimental Pets",
        EggSkin = "Experimental",
        Weight = 35.5,
        From = "Cherry Blossom",
        To = "Titan Temple",
        Pets = {
            {
                AssetId = "Wheel Hamster",
                Weight = 45
            },
            {
                AssetId = "Stacked Turtle",
                Weight = 36
            },
            {
                AssetId = "Three Headed Chicken",
                Weight = 15
            },
            {
                AssetId = "Eyeball Crab",
                Weight = 3.5
            },
            {
                AssetId = "Dreadstinger",
                Weight = 0.5
            }
        }
    },
    {
        Id = "UnstableDNA",
        DisplayName = "Unstable DNA",
        EggSkin = "UnstableDNA",
        Weight = 22,
        From = "Titan Temple",
        To = "Light Dark",
        Pets = {
            {
                AssetId = "Frogfly",
                Weight = 45
            },
            {
                AssetId = "Spiderpig",
                Weight = 36
            },
            {
                AssetId = "Sharkodile",
                Weight = 15
            },
            {
                AssetId = "Rhinobear",
                Weight = 3.5
            },
            {
                AssetId = "Octophant",
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

local t4 = {
    RotationOverrideAttribute = "ScrambleTradeInRotationOverride"
}

function t4.RotationSeconds() -- line: 79
    -- upvalues: ScrambleTradeInFlags (copy)
    return ScrambleTradeInFlags.RotationSeconds:Get()
end

t4.RequirementCount = #t2
t4.RecipeSlots = t2
t4.Banners = t1

function t4.GetBanner(p1) -- line: 86
    -- upvalues: t3 (copy)
    return t3[p1]
end

function t4.BannerIds() -- line: 90
    -- upvalues: t1 (copy)
    local t5 = {}

    for _, v2 in t1 do
        table.insert(t5, v2.Id)
    end

    return t5
end

function t4.GetBannerDisplayName(p2) -- line: 98
    -- upvalues: t3 (copy)
    local v3 = t3[p2]

    if v3 then
        return v3.DisplayName
    end

    return p2
end

function t4.GetBannerEggSkin(p3) -- line: 103
    -- upvalues: t3 (copy)
    local v4 = t3[p3]

    return if v4 then v4.EggSkin else nil
end

function t4.GetBannerEggIcon(p4) -- line: 108
    -- upvalues: EggSkins (copy), t4 (copy)
    local v5 = EggSkins.Get(t4.GetBannerEggSkin(p4))

    return if v5 then v5.Icon else nil
end

local function effectiveBannerWeights() -- line: 113
    -- upvalues: ScrambleTradeInFlags (copy), t1 (copy)
    local v6 = ScrambleTradeInFlags.BannerWeights:Get()
    local t6 = {}
    local n1 = 0

    for _, v7 in t1 do
        local v8 = v6[v7.Id] or v7.Weight

        t6[v7.Id] = v8
        n1 += v8
    end

    if n1 <= 0 then
        for _, v9 in t1 do
            t6[v9.Id] = v9.Weight
        end
    else
        for _, v10 in t1 do
            if n1 < t6[v10.Id] * 2 then
                for _, v11 in t1 do
                    t6[v11.Id] = v11.Weight
                end

                return t6
            end
        end
    end

    return t6
end

function t4.GetBannerWeight(p5) -- line: 137
    -- upvalues: effectiveBannerWeights (copy)
    return effectiveBannerWeights()[p5] or 0
end

function t4.GetBannerRange(p6) -- line: 141
    -- upvalues: ScrambleTradeInFlags (copy), t3 (copy)
    local v12 = t3[p6]

    assert(v12 ~= nil, (("unknown rift banner %*"):format(p6)))

    local v15 = ScrambleTradeInFlags.BannerRanges:Get()[p6]
    local From = if v15 == nil or v15.From == nil then v12.From else v15.From

    if v15 == nil or v15.To == nil then
        return From, v12.To
    end

    return From, v15.To
end

function t4.GetRecipeSlot(p7) -- line: 154
    -- upvalues: ScrambleTradeInFlags (copy), t2 (copy)
    local v16 = t2[p7]

    assert(v16 ~= nil, (("the Rift has no recipe slot %*"):format(p7)))

    local v19 = ScrambleTradeInFlags.SlotOverrides:Get()[tostring(p7)]

    if v19 == nil then
        return v16
    end

    return {
        Biomes = v19.Biomes or v16.Biomes,
        TargetSpawn = v19.TargetSpawn or v16.TargetSpawn,
        SpawnSpread = v19.SpawnSpread or v16.SpawnSpread
    }
end

function t4.PetOverrideKey(p8, p9) -- line: 168
    return p8 .. ":" .. p9
end

function t4.GetPetWeight(p10, p11) -- line: 172
    -- upvalues: ScrambleTradeInFlags (copy), t3 (copy), t4 (copy)
    local v20 = ScrambleTradeInFlags.PetWeights:Get()[t4.PetOverrideKey(p10, p11)]

    if v20 ~= nil then
        return v20
    end

    local v21 = t3[p10]

    if v21 ~= nil then
        for _, v22 in v21.Pets do
            if v22.AssetId == p11 then
                return v22.Weight
            end
        end
    end

    return 0
end

function t4.BannerContainsPet(p12, p13) -- line: 190
    -- upvalues: t3 (copy)
    local v23 = t3[p12]

    if v23 ~= nil then
        for _, v24 in v23.Pets do
            if v24.AssetId == p13 then
                return true
            end
        end
    end

    return false
end

function t4.RollPet(p14, p15) -- line: 203
    -- upvalues: t3 (copy), t4 (copy)
    local v25 = t3[p14]

    if v25 == nil then
        return nil
    end

    local t8 = {}
    local n2 = 0

    for v26, v27 in v25.Pets do
        local v28 = t4.GetPetWeight(p14, v27.AssetId)

        t8[v26] = v28

        if v28 > 0 then
            n2 += v28
        end
    end

    if n2 <= 0 then
        return nil
    end

    local v29 = p15:NextNumber() * n2
    local n3 = 0
    local AssetId

    for v30, v31 in v25.Pets do
        local v32 = t8[v30]

        if not (v32 <= 0) then
            n3 += v32
            AssetId = v31.AssetId

            if v29 <= n3 then
                return v31.AssetId
            end
        end
    end

    return AssetId
end

function t4.ChasePetId(p16) -- line: 239
    -- upvalues: t3 (copy)
    local v33 = t3[p16]
    local v34 = v33 and v33.Pets[#v33.Pets]

    return if v34 then v34.AssetId else nil
end

function t4.PityPool(p17) -- line: 245
    -- upvalues: t4 (copy)
    local v35 = t4.ChasePetId(p17)

    if v35 then
        return {
            {
                Weight = 1,
                AssetId = v35
            }
        }
    end

    return {}
end

function t4.RollPityPet(p18, _) -- line: 250
    -- upvalues: t4 (copy)
    return t4.ChasePetId(p18)
end

local function rotationOverride() -- line: 254
    -- upvalues: Workspace (copy), t3 (copy), t4 (copy)
    local Attribute = Workspace:GetAttribute(t4.RotationOverrideAttribute)

    if typeof(Attribute) == "string" then
        local v36, v37 = string.match(Attribute, "^([%d%.]+)|([%w]+)$")
        local v38 = tonumber(v36)

        if v38 ~= nil and not (v38 <= 0) and t3[v37] ~= nil then
            return v38, v37
        end
    end

    return nil, nil
end

function t4.CurrentPeriod() -- line: 267
    -- upvalues: Workspace (copy), t3 (copy), t4 (copy)
    local v39 = t4.RotationSeconds()
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Attribute = Workspace:GetAttribute(t4.RotationOverrideAttribute)
    local v40

    if typeof(Attribute) == "string" then
        local v41, v42 = string.match(Attribute, "^([%d%.]+)|([%w]+)$")

        v40 = tonumber(v41)

        if v40 == nil or v40 <= 0 or t3[v42] == nil then
            v40 = nil
        end
    end

    if v40 == nil or not (v40 <= ServerTimeNow) then
        return (math.floor(ServerTimeNow / v39))
    end

    return math.floor(v40 / v39) + math.floor((ServerTimeNow - v40) / v39)
end

local t9 = {}
local v47 = ""
local n4 = -1
local n5 = 0

function t4.BannerIdForPeriod(p20) -- line: 282
    -- upvalues: Workspace (copy), t1 (copy), t3 (copy), t4 (copy), t9 (copy), v47 (ref), n4 (ref), n5 (ref)
    local v48 = t4.RotationSeconds()
    local t10 = {
        t4.GetBannerWeight(t1[1].Id),
        t4.GetBannerWeight(t1[2].Id),
        t4.GetBannerWeight(t1[3].Id)
    }
    local Attribute = Workspace:GetAttribute(t4.RotationOverrideAttribute)
    local v49, v50

    if typeof(Attribute) == "string" then
        local v51

        v51, v49 = string.match(Attribute, "^([%d%.]+)|([%w]+)$")
        v50 = tonumber(v51)

        if v50 == nil or v50 <= 0 or t3[v49] == nil then
            v50 = nil
            v49 = nil
        end
    end

    local v52 = if v50 ~= nil then math.floor(v50 / v48) else nil
    local v54 = string.format("%d:%.9g:%.9g:%.9g:%s:%s", v48, t10[1], t10[2], t10[3], tostring(v50), (tostring(v49)))

    if v54 ~= v47 then
        v47 = v54
        table.clear(t9)
        n5 = math.floor(DateTime.fromUniversalTime(2026, 9, 1, 0, 0, 0).UnixTimestamp / v48)
        n4 = n5 - 1
    end

    if p20 < n5 then
        return t1[p20 % #t1 + 1].Id
    end

    for i = n4 + 1, p20 do
        local v56 = Random.new(i)
        local v57

        if v52 ~= nil and i == v52 then
            v57 = table.find(t4.BannerIds(), v49)
        elseif i == n5 then
            local v58 = t10[1] + t10[2] + t10[3]
            local v59 = v56:NextNumber() * v58

            v57 = if v59 < t10[1] then 1 elseif v59 < t10[1] + t10[2] then 2 else 3
        else
            local v60 = table.find(t4.BannerIds(), t9[i - 1])
            local t11 = {}

            if v60 ~= 1 then
                table.insert(t11, 1)
            end

            if v60 ~= 2 then
                table.insert(t11, 2)
            end

            if v60 ~= 3 then
                table.insert(t11, 3)
            end

            v57 = t11[1]

            local v61 = t11[2]
            local v62 = t10[v57] + t10[v61]

            if not (v62 <= 0 or v56:NextNumber() < t10[v57] / v62) then
                v57 = v61
            end
        end

        t9[i] = t1[v57].Id
    end

    n4 = math.max(n4, p20)

    return t9[p20]
end

function t4.CurrentBannerId() -- line: 330
    -- upvalues: t4 (copy)
    return t4.BannerIdForPeriod(t4.CurrentPeriod())
end

function t4.SecondsUntilRotation() -- line: 334
    -- upvalues: Workspace (copy), t3 (copy), t4 (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v64 = t4.RotationSeconds()
    local Attribute = Workspace:GetAttribute(t4.RotationOverrideAttribute)
    local v65

    if typeof(Attribute) == "string" then
        local v66, v67 = string.match(Attribute, "^([%d%.]+)|([%w]+)$")

        v65 = tonumber(v66)

        if v65 == nil or v65 <= 0 or t3[v67] == nil then
            v65 = nil
        end
    end

    if v65 == nil or not (v65 <= ServerTimeNow) then
        return v64 - ServerTimeNow % v64
    end

    return v64 - (ServerTimeNow - v65) % v64
end

return table.freeze(t4)

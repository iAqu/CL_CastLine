-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Areas = require(ReplicatedStorage.Data.Areas)
local Log = require(ReplicatedStorage.Packages.Log)
local RollWeighted = require(ReplicatedStorage.Shared.Utils.Numeric).RollWeighted
local ScrambleTradeIn = require(ReplicatedStorage.Data.ScrambleTradeIn)
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local RiftZoneLadder = require(ReplicatedStorage.Shared.Modules.RiftZoneLadder)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Easy = "E",
    Medium = "M",
    Hard = "H",
    Excluded = "X"
}
local t2 = {
    E = 1,
    M = 2,
    H = 3,
    X = 4,
    ["?"] = 5
}
local v1 = Log.new()
local v2 = Random.new()
local t3 = {}

local function gaussian(p1, p2, p3) -- line: 69
    if p3 <= 0 then
        if p1 == p2 then
            return 1
        end

        return 0
    end

    local v3 = p1 - p2

    return (math.exp(-(v3 * v3 / (p3 * 2 * p3))))
end

function t3.ResolveConfig() -- line: 77
    -- upvalues: ScrambleTradeIn (copy), ScrambleTradeInFlags (copy)
    local t4 = {}

    for _, v5 in ScrambleTradeInFlags.ExcludedPets:Get() do
        t4[v5] = true
    end

    local t5 = {}

    for i = 1, ScrambleTradeIn.RequirementCount do
        t5[i] = ScrambleTradeIn.GetRecipeSlot(i)
    end

    return {
        MinSpawnChance = ScrambleTradeInFlags.MinSpawnChance:Get(),
        MaxSpawnChance = ScrambleTradeInFlags.MaxSpawnChance:Get(),
        EasyBand = ScrambleTradeInFlags.EasyBand:Get(),
        MediumBand = ScrambleTradeInFlags.MediumBand:Get(),
        HardPenalty = ScrambleTradeInFlags.HardPenalty:Get(),
        ExtendBelow = ScrambleTradeInFlags.ExtendBelow:Get(),
        Slots = t5,
        RequireEasyPet = ScrambleTradeInFlags.RequireEasyPet:Get(),
        MaxEasyPets = ScrambleTradeInFlags.MaxEasyPets:Get(),
        MaxHardPets = ScrambleTradeInFlags.MaxHardPets:Get(),
        MaxNonEasyPets = ScrambleTradeInFlags.MaxNonEasyPets:Get(),
        AllowDuplicatePets = ScrambleTradeInFlags.AllowDuplicatePets:Get(),
        MaxRecipeAttempts = ScrambleTradeInFlags.MaxRecipeAttempts:Get(),
        Excluded = t4
    }
end

function t3.GetDifficulty(p4, p5) -- line: 104
    if p4 < p5.MinSpawnChance or p5.MaxSpawnChance < p4 then
        return "Excluded"
    end

    if p5.EasyBand <= p4 then
        return "Easy"
    end

    if p5.MediumBand <= p4 then
        return "Medium"
    end

    return "Hard"
end

function t3.ZonePets(p6) -- line: 117
    -- upvalues: Areas (copy)
    local t6 = {}
    local v6 = Areas.Directory[p6]

    if v6 ~= nil then
        for _, v7 in v6.DropTable do
            table.insert(t6, {
                AssetId = v7[1],
                SpawnChance = v7[2]
            })
        end
    end

    return t6
end

function t3.SpawnChanceOf(p7) -- line: 129
    -- upvalues: Areas (copy), t3 (copy)
    local v8, v9

    for v10 in Areas.Directory do
        for _, v13 in t3.ZonePets(v10) do
            if v13.AssetId == p7 and (v8 == nil or v8 < v13.SpawnChance) then
                v9 = v10
                v8 = v13.SpawnChance
            end
        end
    end

    return v8, v9
end

function t3.IsZonePet(p8) -- line: 143
    -- upvalues: t3 (copy)
    return t3.SpawnChanceOf(p8) ~= nil
end

function t3.IsEligible(p9, p10) -- line: 147
    -- upvalues: t3 (copy)
    if p10.Excluded[p9.AssetId] == true then
        return false
    end

    return t3.GetDifficulty(p9.SpawnChance, p10) ~= "Excluded"
end

function t3.DifficultyOf(p11, p12) -- line: 154
    -- upvalues: t3 (copy)
    local v14 = t3.SpawnChanceOf(p11)

    if v14 == nil then
        return nil
    end

    return t3.GetDifficulty(v14, p12 or t3.ResolveConfig())
end

local function newContext(p13, p14) -- line: 162
    -- upvalues: ScrambleTradeIn (copy), RiftZoneLadder (copy), t3 (copy)
    local v15, v16 = ScrambleTradeIn.GetBannerRange(p13)
    local v17 = RiftZoneLadder.Get()
    local v18, v19

    for v20, v21 in v17 do
        if v21.Id == v15 then
            v18 = v20
        end

        if v21.Id == v16 then
            v19 = v20
        end
    end

    assert(v18 ~= nil, (("Rift banner %* names an unknown From zone: %*"):format(p13, v15)))
    assert(v19 ~= nil, (("Rift banner %* names an unknown To zone: %*"):format(p13, v16)))
    assert(v18 <= v19, (("Rift banner %* runs backwards (%* -> %*)"):format(p13, v15, v16)))

    local t8 = {}

    for v28, v29 in v17 do
        t8[v28] = t3.ZonePets(v29.Id)
    end

    return {
        BannerId = p13,
        Config = p14,
        Ladder = v17,
        Bottom = math.max(1, v18 - p14.ExtendBelow),
        Top = v19,
        PetsByRung = t8
    }
end

local function buildSlotPool(p15, p16, p17) -- line: 193
    -- upvalues: t3 (copy)
    local Config = p15.Config
    local v31 = Config.Slots[p16]
    local v33 = math.max(p15.Bottom, p15.Top - (v31.Biomes - 1))
    local t10 = {}

    for i = v33, p15.Top do
        local v34 = p15.Ladder[i]

        for _, v35 in p15.PetsByRung[i] do
            if t3.IsEligible(v35, Config) and (Config.AllowDuplicatePets or not p17[v35.AssetId]) then
                local v36 = t3.GetDifficulty(v35.SpawnChance, Config)
                local v37 = if v36 == "Hard" then Config.HardPenalty else 1
                local v38 = math.sqrt(v35.SpawnChance)
                local SpawnChance2 = v35.SpawnChance
                local TargetSpawn, SpawnSpread = v31.TargetSpawn, v31.SpawnSpread
                local v39

                if SpawnSpread <= 0 then
                    v39 = if SpawnChance2 == TargetSpawn then 1 else 0
                else
                    local v40 = SpawnChance2 - TargetSpawn

                    v39 = math.exp(-(v40 * v40 / (SpawnSpread * 2 * SpawnSpread)))
                end

                local v42 = v38 * v39 * v37

                if v42 > 0 then
                    table.insert(t10, {
                        {
                            AssetId = v35.AssetId,
                            SpawnChance = v35.SpawnChance,
                            ZoneId = v34.Id,
                            ZoneIndex = i,
                            Difficulty = v36
                        },
                        v42
                    })
                end
            end
        end
    end

    return t10
end

local function isValidRecipe(p18, p19) -- line: 232
    if #p18 ~= #p19.Slots then
        return false
    end

    local t13 = {
        Easy = 0,
        Medium = 0,
        Hard = 0,
        Excluded = 0
    }
    local t14 = {}

    for _, v43 in p18 do
        if not p19.AllowDuplicatePets and t14[v43.AssetId] then
            return false
        end

        t14[v43.AssetId] = true
        t13[v43.Difficulty] += 1
    end

    if p19.RequireEasyPet and t13.Easy < 1 or t13.Easy > p19.MaxEasyPets or t13.Hard > p19.MaxHardPets then
        return false
    end

    return not (t13.Medium + t13.Hard > p19.MaxNonEasyPets)
end

local function rollRecipe(p20, p21) -- line: 260
    -- upvalues: RollWeighted (copy), buildSlotPool (copy), isValidRecipe (copy)
    local Config = p20.Config

    for _ = 1, Config.MaxRecipeAttempts do
        local t15 = {}
        local t16 = {}
        local v45 = true

        for i = 1, #Config.Slots do
            local v46 = RollWeighted(buildSlotPool(p20, i, t16), p21)

            if v46 == nil then
                v45 = false
                break
            end

            table.insert(t15, v46)
            t16[v46.AssetId] = true
        end

        if v45 and isValidRecipe(t15, Config) then
            return t15
        end
    end

    return nil
end

function t3.GenerateRecipe(p22, p23, p24) -- line: 282
    -- upvalues: t (copy), v2 (copy), t3 (copy), newContext (copy), rollRecipe (copy)
    t.strict(t.string)(p22)
    p24 = p24 or t3.ResolveConfig()

    local ok, result = pcall(newContext, p22, p24)

    if not ok then
        return nil, (tostring(result))
    end

    local v48 = rollRecipe(result, p23 or v2)

    if v48 == nil then
        return nil, (("no valid recipe for %* after %* attempts"):format(p22, p24.MaxRecipeAttempts))
    end

    return v48, nil
end

local function fallbackAssetIds(p25, p26, p27) -- line: 300
    -- upvalues: v1 (copy), t3 (copy), newContext (copy)
    local ok, result = pcall(newContext, p25, p27)

    if ok then
        local t17 = {}

        for i = result.Bottom, result.Top do
            for _, v49 in result.PetsByRung[i] do
                if t3.IsEligible(v49, p27) then
                    table.insert(t17, v49.AssetId)
                end
            end
        end

        local t18 = {}

        for _ = 1, math.min(#p27.Slots, #t17) do
            local v52 = p26:NextInteger(1, #t17)

            table.insert(t18, t17[v52])
            table.remove(t17, v52)
        end

        return t18
    end

    v1:AtError():Log((("Rift fallback recipe unavailable for %*: %*"):format(p25, result)))

    return {}
end

function t3.RollAssetIds(p28, p29) -- line: 324
    -- upvalues: ScrambleTradeInFlags (copy), t (copy), v1 (copy), v2 (copy), t3 (copy), fallbackAssetIds (copy)
    t.strict(t.string)(p28)
    p29 = p29 or v2

    local v55 = t3.ResolveConfig()

    if ScrambleTradeInFlags.RecipesEnabled:Get() then
        local v56, v57 = t3.GenerateRecipe(p28, p29, v55)

        if v56 ~= nil then
            local t19 = {}

            for _, v58 in v56 do
                table.insert(t19, v58.AssetId)
            end

            return t19
        end

        v1:AtWarning():Log((("Rift recipe engine fell back for %*: %*"):format(p28, v57)))
    end

    return (fallbackAssetIds(p28, p29, v55))
end

function t3.Describe(p30, p31) -- line: 342
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    p31 = p31 or t3.ResolveConfig()

    local t20 = {}

    for _, v60 in p30 do
        local v61 = t3.DifficultyOf(v60, p31)

        table.insert(t20, if v61 then t1[v61] else "?")
    end

    table.sort(t20, function(p32, p33) -- line: 349
        -- upvalues: t2 (copy)
        return t2[p32] < t2[p33]
    end)

    return table.concat(t20)
end

function t3.DescribeCandidates(p34) -- line: 355
    -- upvalues: t1 (copy), t2 (copy)
    local t21 = {}

    for _, v63 in p34 do
        table.insert(t21, t1[v63.Difficulty])
    end

    table.sort(t21, function(p35, p36) -- line: 360
        -- upvalues: t2 (copy)
        return t2[p35] < t2[p36]
    end)

    return table.concat(t21)
end

function t3.Simulate(p37, p38, p39) -- line: 366
    -- upvalues: t (copy), t3 (copy), newContext (copy), rollRecipe (copy)
    t.strict(t.string)(p37)
    t.strict(t.numberPositive)(p38)

    local v65 = t3.ResolveConfig()
    local t22 = {
        Failures = 0,
        NonZonePicks = 0,
        Distinct = 0,
        PoolBottom = nil,
        PoolTop = nil,
        PoolSize = 0,
        Error = nil,
        BannerId = p37,
        Runs = p38,
        Patterns = {},
        SlotPicks = {},
        Bands = {
            Easy = 0,
            Medium = 0,
            Hard = 0,
            Excluded = 0
        }
    }

    for i = 1, #v65.Slots do
        t22.SlotPicks[i] = {}
    end

    local ok, result = pcall(newContext, p37, v65)

    if not ok then
        t22.Error = tostring(result)

        return t22
    end

    t22.PoolBottom = result.Ladder[result.Bottom].Id
    t22.PoolTop = result.Ladder[result.Top].Id

    for i = result.Bottom, result.Top do
        for _, v66 in result.PetsByRung[i] do
            local v67 = if v65.Excluded[v66.AssetId] == true then "Excluded" else t3.GetDifficulty(v66.SpawnChance, v65)

            t22.Bands[v67] += 1
            t22.PoolSize += 1
        end
    end

    local v68 = if p39 == nil then Random.new() else Random.new(p39)
    local t23 = {}

    for _ = 1, p38 do
        local v69 = rollRecipe(result, v68)

        if v69 ~= nil then
            local v70 = t3.DescribeCandidates(v69)

            t22.Patterns[v70] = (t22.Patterns[v70] or 0) + 1

            local t24 = {}

            for v71, v72 in v69 do
                local v73 = t22.SlotPicks[v71]

                v73[v72.AssetId] = (v73[v72.AssetId] or 0) + 1
                table.insert(t24, v72.AssetId)

                if not t3.IsZonePet(v72.AssetId) then
                    t22.NonZonePicks += 1
                end
            end

            table.sort(t24)
            t23[table.concat(t24, "|")] = true
        else
            t22.Failures += 1
        end
    end

    for _ in t23 do
        t22.Distinct += 1
    end

    return t22
end

return table.freeze(t3)

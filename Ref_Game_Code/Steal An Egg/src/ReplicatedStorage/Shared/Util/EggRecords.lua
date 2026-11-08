-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local Eggs = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Eggs
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)
local Areas = require(ReplicatedStorage.Data.Areas)
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local Assets = require(ReplicatedStorage.Data.Assets)
local HalloweenPets = require(ReplicatedStorage.Data.HalloweenPets)

require(ReplicatedStorage.Shared.Util.AssetGender)

local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local AssetLottery = require(ReplicatedStorage.Shared.Util.AssetLottery)
local AssetPalette = require(ReplicatedStorage.Shared.Util.AssetPalette)

require(ReplicatedStorage.Shared.Types.AssetItem)

local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local Eggs2 = require(ReplicatedStorage.Shared.Types.Eggs)
local EggSkins = require(ReplicatedStorage.Data.EggSkins)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v2 = t.intersection(t.numberMin(0), t.numberMaxExclusive(1e999))
local v3 = t.intersection(t.integer, t.numberMin(0))
local v4 = t.strict(t.boolean)
local v5 = t.strict(v1)
local v6 = t.strict(t.optional(v2))
local v7 = t.strict(t.optional(v3))
local v8 = t.strict(v2)
local v9 = t.strict(t.string)
local v10 = t.strict(v3)
local v11 = t.strict(t.optional(t.callback))
local v12 = t.strict(t.optional(t.number))
local v13 = t.strict(t.number)
local v14 = t.strict(t.table)
local t1 = {
    ScaleHardCap = Eggs.SCALE_HARD_CAP
}

require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 79
    -- upvalues: Eggs (copy), t1 (copy)
    t1.ScaleHardCap = Eggs.SCALE_HARD_CAP
end)

local v15 = Random.new()
local v16 = {}

local function reloadGrowthBoosts() -- line: 86
    -- upvalues: HttpService (copy), v16 (ref)
    local TemporaryGrowthBoosts = workspace:GetAttribute("TemporaryGrowthBoosts")

    if type(TemporaryGrowthBoosts) ~= "string" or TemporaryGrowthBoosts == "" then
        return
    end

    local function v17() -- line: 93
        -- upvalues: TemporaryGrowthBoosts (copy), HttpService (copy), v16 (ref)
        v16 = HttpService:JSONDecode(TemporaryGrowthBoosts)
    end

    local function v18() -- line: 95
        -- upvalues: v16 (ref)
        v16 = {}
    end

    xpcall(v17, v18)
end

workspace:GetAttributeChangedSignal("TemporaryGrowthBoosts"):Connect(reloadGrowthBoosts)
task.spawn(reloadGrowthBoosts)

local function bandBias(p1, p2) -- line: 103
    -- upvalues: v5 (copy)
    local v19 = if p2 then p2(p1.min, p1.max) else 1

    v5(v19)
    assert(v19 > 0, "A scale band bias has to be a positive multiplier")

    return v19
end

local function growthCurve(p3) -- line: 112
    -- upvalues: Eggs (copy)
    if p3 <= Eggs.FLAT_GROWTH_MAX_SCALE then
        return 1
    end

    if p3 <= Eggs.STEEP_GROWTH_MAX_SCALE then
        return (p3 / Eggs.FLAT_GROWTH_MAX_SCALE) ^ Eggs.STEEP_GROWTH_POWER
    end

    return (math.min(Eggs.TAIL_GROWTH_COEFFICIENT * (p3 / Eggs.STEEP_GROWTH_MAX_SCALE) ^ Eggs.TAIL_GROWTH_POWER, Eggs.TAIL_GROWTH_CAP))
end

local function boostedSecondsFor(p4) -- line: 128
    -- upvalues: ServerClock (copy), v16 (ref)
    local JoinTick = if p4 then p4:GetAttribute("JoinTick") else nil

    if type(JoinTick) ~= "number" then
        return 0
    end

    local n1 = 0

    for _, v22 in v16 do
        local v23 = math.max(v22.StartedAt, JoinTick)

        n1 += math.floor((math.min(ServerClock.Now(), v22.EndsAt) - v23) * v22.Multiplier)
    end

    return n1
end

local function eggConfig(p5) -- line: 147
    -- upvalues: Assets (copy)
    local v26 = Assets.Directory[p5]

    assert(v26 ~= nil, (("Asset catalog carries no entry named %*"):format(p5)))

    return v26
end

local function adminScaleBias() -- line: 155
    -- upvalues: Eggs (copy), AdminBoosts (copy)
    local v29 = AdminBoosts.ReadMultiplier(AdminBoosts.EGG_SIZE)

    return if not (v29 <= 1) then function(p6, p7) -- line: 162
        -- upvalues: v29 (copy), Eggs (copy)
        if Eggs.ADMIN_GROWS_BANDS_FROM <= p6 then
            return v29
        end

        if p7 <= Eggs.ADMIN_SHRINKS_BANDS_UNTIL then
            return 1 / v29
        end

        return 1
    end else nil
end

local function requireSchema(p8) -- line: 170
    -- upvalues: Eggs2 (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p8), "Saved egg failed its schema check")
end

local function copyTiming(p9) -- line: 176
    return {
        LocalCFrame = nil,
        PlacedAt = p9.PlacedAt,
        ReadyAt = p9.ReadyAt,
        GrowthDuration = p9.GrowthDuration,
        GrowthCreditSeconds = p9.GrowthCreditSeconds,
        NightGrowthPeriodIndex = p9.NightGrowthPeriodIndex,
        NightGrowthCreditSeconds = p9.NightGrowthCreditSeconds
    }
end

local function copyIdentity(p10) -- line: 188
    return {
        Placement = nil,
        AssetCategory = p10.AssetCategory,
        AssetScale = p10.AssetScale,
        AssetEyeColor = p10.AssetEyeColor,
        AssetColorSeed = p10.AssetColorSeed,
        AssetColorIndex = p10.AssetColorIndex,
        AssetGender = p10.AssetGender,
        AssetPersonality = p10.AssetPersonality,
        BaseMutation = p10.BaseMutation,
        Mutations = if p10.Mutations then table.clone(p10.Mutations) else nil,
        IsStolenDNA = p10.IsStolenDNA,
        CreatorTemporary = p10.CreatorTemporary,
        HasParasite = p10.HasParasite,
        ParasiteRemovedForHatch = p10.ParasiteRemovedForHatch,
        MechaRerollDone = p10.MechaRerollDone,
        PurchaseId = p10.PurchaseId,
        EggSkin = p10.EggSkin
    }
end

local function slotOf(p11) -- line: 210
    return p11.Placement
end

local function cframeToComponents(p12) -- line: 216
    return { p12:GetComponents() }
end

local function componentsToCFrame(p13) -- line: 220
    return CFrame.new(table.unpack(p13, 1, 12))
end

function t1.DrawAssetScale(p14, p15) -- line: 226
    -- upvalues: Eggs (copy), v5 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy)
    v14(Eggs.SCALE_BANDS)
    v12(Eggs.SCALE_HARD_CAP)
    v12(Eggs.SCALE_DOUBLING_ODDS)
    v11(p15)
    p14 = p14 or Random.new()

    local n2 = 0

    for _, v32 in ipairs(Eggs.SCALE_BANDS) do
        v13(v32.min)
        v13(v32.max)
        v13(v32.weight)
        assert(v32.max >= v32.min, "A scale band cannot end below where it starts")
        assert(v32.weight > 0, "A scale band needs a weight above zero to be reachable")

        local weight = v32.weight
        local v35 = if p15 then p15(v32.min, v32.max) else 1

        v5(v35)
        assert(v35 > 0, "A scale band bias has to be a positive multiplier")
        n2 += weight * v35
    end

    assert(n2 > 0, "No scale band is reachable: the weights total zero")

    local v38 = Eggs.SCALE_BANDS[1]
    local v39 = p14:NextNumber() * n2
    local n3 = 0

    for _, v40 in ipairs(Eggs.SCALE_BANDS) do
        local weight = v40.weight
        local v41 = if p15 then p15(v40.min, v40.max) else 1

        v5(v41)
        assert(v41 > 0, "A scale band bias has to be a positive multiplier")
        n3 += weight * v41

        if v39 <= n3 then
            v38 = v40
            break
        end
    end

    local v43 = v38.min + p14:NextNumber() * (v38.max - v38.min)

    while v43 * 2 <= Eggs.SCALE_HARD_CAP and p14:NextNumber() <= Eggs.SCALE_DOUBLING_ODDS do
        v43 *= 2
    end

    return v43
end

function t1.EggModelName(p16, p17, p18, p19) -- line: 276
    -- upvalues: Assets (copy), EggSkins (copy), Mutations (copy), v9 (copy)
    v9(p16)

    local v44 = EggSkins.Get(p19)

    if v44 ~= nil then
        return v44.ModelName
    end

    local v45 = Assets.Directory[p16]

    assert(v45 ~= nil, (("Asset catalog carries no entry named %*"):format(p16)))

    local ModelName = v45.Egg.ModelName

    if ModelName == nil then
        return Mutations.EggModelName(p17, p18) or p16
    end

    return ModelName
end

function t1.EggModelTemplate(p20, p21, p22, p23) -- line: 301
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v48 = t1.EggModelName(p20, p21, p22, p23)
    local v49 = ReplicatedStorage.Assets.Models.Eggs:FindFirstChild(v48)

    assert(v49 ~= nil, (("Egg model \"%*\" for asset %* is missing from ReplicatedStorage.Assets.Models.Eggs"):format(v48, p20)))
    assert(v49:IsA("Model"), (("Egg model \"%*\" must be a Model"):format(v48)))

    return v49
end

function t1.Normalize(p24) -- line: 321
    -- upvalues: AssetPalette (copy)
    local v53 = AssetPalette.SettleFields(p24.AssetCategory, p24.AssetEyeColor, p24.AssetColorSeed, p24.AssetColorIndex)
    local v54 = table.clone(p24)

    v54.AssetEyeColor = v53.EyeColor
    v54.AssetColorSeed = v53.ColorSeed
    v54.AssetColorIndex = v53.ColorIndex

    return v54
end

function t1.EncodePlacement(p25) -- line: 337
    local t3 = {
        LocalCFrame = nil,
        PlacedAt = p25.PlacedAt,
        ReadyAt = p25.ReadyAt,
        GrowthDuration = p25.GrowthDuration,
        GrowthCreditSeconds = p25.GrowthCreditSeconds,
        NightGrowthPeriodIndex = p25.NightGrowthPeriodIndex,
        NightGrowthCreditSeconds = p25.NightGrowthCreditSeconds
    }

    t3.LocalCFrame = { p25.LocalCFrame:GetComponents() }

    return t3
end

function t1.DecodePlacement(p26) -- line: 345
    local t4 = {
        LocalCFrame = nil,
        PlacedAt = p26.PlacedAt,
        ReadyAt = p26.ReadyAt,
        GrowthDuration = p26.GrowthDuration,
        GrowthCreditSeconds = p26.GrowthCreditSeconds,
        NightGrowthPeriodIndex = p26.NightGrowthPeriodIndex,
        NightGrowthCreditSeconds = p26.NightGrowthCreditSeconds
    }
    local LocalCFrame = p26.LocalCFrame

    t4.LocalCFrame = CFrame.new(table.unpack(LocalCFrame, 1, 12))

    return t4
end

function t1.Encode(p27) -- line: 353
    -- upvalues: t1 (copy), copyIdentity (copy)
    local v55 = t1.Normalize(p27)
    local v56 = copyIdentity(v55)
    local Placement = v55.Placement

    if Placement then
        v56.Placement = t1.EncodePlacement(Placement)
    else
        v56.Placement = nil
    end

    return v56
end

function t1.Decode(p28) -- line: 363
    -- upvalues: t1 (copy), copyIdentity (copy)
    local v57 = copyIdentity(p28)
    local Placement = p28.Placement

    if Placement then
        v57.Placement = t1.DecodePlacement(Placement)
    else
        v57.Placement = nil
    end

    return t1.Normalize(v57)
end

function t1.GrowthSpeedMultiplier(p29) -- line: 372
    -- upvalues: Eggs (copy), v4 (copy)
    v4(p29)

    if p29 then
        return 1 + Eggs.X2_GROWTH_BONUS
    end

    return 1
end

function t1.GrowthDuration(p30) -- line: 378
    -- upvalues: Eggs (copy), Assets (copy), Eggs2 (copy), v5 (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p30), "Saved egg failed its schema check")

    local v59 = assert(p30.Placement, "Growth duration is only defined for a placed egg")

    if v59.GrowthDuration ~= nil then
        return v59.GrowthDuration
    end

    v5(p30.AssetScale)
    assert(p30.AssetScale > 0, "Growth duration needs a positive asset scale")

    local AssetCategory = p30.AssetCategory
    local v61 = Assets.Directory[AssetCategory]

    assert(v61 ~= nil, (("Asset catalog carries no entry named %*"):format(AssetCategory)))

    local Egg = v61.Egg

    if Egg.IgnoreSizeGrowthMultiplier then
        return Egg.GrowthTime
    end

    local GrowthTime = Egg.GrowthTime
    local AssetScale = p30.AssetScale
    local v64 = if AssetScale <= Eggs.FLAT_GROWTH_MAX_SCALE then 1 elseif AssetScale <= Eggs.STEEP_GROWTH_MAX_SCALE then (AssetScale / Eggs.FLAT_GROWTH_MAX_SCALE) ^ Eggs.STEEP_GROWTH_POWER else math.min(Eggs.TAIL_GROWTH_COEFFICIENT * (AssetScale / Eggs.STEEP_GROWTH_MAX_SCALE) ^ Eggs.TAIL_GROWTH_POWER, Eggs.TAIL_GROWTH_CAP)

    return GrowthTime * v64
end

function t1.GrowthCredit(p31) -- line: 397
    -- upvalues: v8 (copy)
    local Placement = p31.Placement
    local v66 = Placement ~= nil and Placement.GrowthCreditSeconds or 0

    v8(v66)

    return v66
end

function t1.GrowthAlpha(p32, p33, p34, p35, p36) -- line: 406
    -- upvalues: v5 (copy), v6 (copy), t1 (copy), boostedSecondsFor (copy)
    v5(p33)
    v5(p34)
    v6(p35)
    assert(p34 > 0, "The growth speed multiplier has to be above zero")

    local Placement = p32.Placement

    if Placement == nil then
        return 0
    end

    if Placement.ReadyAt ~= nil then
        return 1
    end

    local v68 = t1.GrowthDuration(p32)

    if v68 <= 0 then
        return 1
    end

    local v69 = t1.GrowthCredit(p32) + (p35 or 0) + boostedSecondsFor(p36)

    return (math.clamp(((p33 - Placement.PlacedAt) * p34 + v69) / v68, 0, 1))
end

function t1.GrowthSecondsRemaining(p37, p38, p39, p40, p41) -- line: 442
    -- upvalues: v5 (copy), v6 (copy), t1 (copy), boostedSecondsFor (copy)
    v5(p38)
    v5(p39)
    v6(p40)
    assert(p39 > 0, "The growth speed multiplier has to be above zero")

    local v72 = assert(p37.Placement, "Remaining growth is only defined for a placed egg")

    if v72.ReadyAt ~= nil then
        return 0
    end

    local v73 = t1.GrowthCredit(p37) + (p40 or 0) + boostedSecondsFor(p41)
    local v74 = (p38 - v72.PlacedAt) * p39

    return (math.max(0, t1.GrowthDuration(p37) - v74 - v73))
end

function t1.WallSecondsRemaining(p42, p43, p44, p45) -- line: 469
    -- upvalues: t1 (copy)
    local v76 = t1.GrowthSecondsRemaining(p42, p43, p44, p45)

    if v76 <= 0 then
        return 0
    end

    return v76 / p44
end

function t1.IsGrown(p46, p47, p48, p49, p50) -- line: 480
    -- upvalues: t1 (copy)
    return t1.GrowthAlpha(p46, p47, p48, p49, p50) >= 1
end

function t1.CommittedNightCredit(p51, p52) -- line: 490
    -- upvalues: v7 (copy), v8 (copy), v10 (copy)
    v10(p52)

    local Placement = p51.Placement

    if Placement == nil then
        return 0
    end

    v7(Placement.NightGrowthPeriodIndex)

    local v77 = Placement.NightGrowthPeriodIndex == p52 and Placement.NightGrowthCreditSeconds or 0

    v8(v77)

    return v77
end

function t1.NightCreditAt(p53, p54, p55, p56, p57) -- line: 510
    -- upvalues: AreaEggCycle (copy), v5 (copy), v10 (copy), t1 (copy)
    v5(p54)
    v5(p55)
    v5(p56)
    v10(p57)
    assert(p55 > 0, "The growth speed multiplier has to be above zero")

    local Placement = p53.Placement

    if Placement == nil or Placement.ReadyAt ~= nil or p56 < Placement.PlacedAt then
        return 0
    end

    local v79 = t1.CommittedNightCredit(p53, p57)
    local v80 = t1.GrowthSecondsRemaining(p53, p56, p55) + v79

    return (math.max(0, math.min(AreaEggCycle.NightGrowthCreditAt(p54, p56), v80) - v79))
end

function t1.CurrentNightCredit(p58, p59, p60) -- line: 536
    -- upvalues: AreaEggCycle (copy), t1 (copy)
    if not AreaEggCycle.IsNightPhase(p59) then
        return 0
    end

    local v83 = AreaEggCycle.NightStartTime(p59)
    local v84 = v83 + AreaEggCycle.NightLengthSeconds()
    local v85 = AreaEggCycle.PeriodIndexAt(v84)

    return t1.NightCreditAt(p58, p59, p60, v83, v85)
end

function t1.ServerGrowthBoostMultiplier() -- line: 548
    -- upvalues: v16 (ref)
    local n4 = 0

    for _, v86 in v16 do
        n4 += v86.Multiplier
    end

    return n4
end

function t1.ServerGrowthBoostEndsAt() -- line: 562
    -- upvalues: v16 (ref)
    local n5 = 0

    for _, v87 in v16 do
        n5 = math.max(n5, v87.EndsAt)
    end

    return n5
end

function t1.NewEgg(p61, p62) -- line: 573
    -- upvalues: Eggs (copy), AdminBoosts (copy), AssetLottery (copy), AssetPalette (copy), Eggs2 (copy), v9 (copy), t1 (copy), v15 (copy)
    v9(p61)
    p62 = p62 or v15

    local v89 = AssetLottery.DrawMutations(nil, nil, p62, AdminBoosts.ReadMultiplier(AdminBoosts.MUTATION_LUCK) * AdminBoosts.ReadMultiplier(AdminBoosts.VIDEO_LUCK))
    local v90 = AssetPalette.DrawFields(p61, p62)
    local DrawAssetScale = t1.DrawAssetScale
    local v91 = AdminBoosts.ReadMultiplier(AdminBoosts.EGG_SIZE)
    local v92

    if not (v91 <= 1) then
        v92 = function(p63, p64) -- line: 162
            -- upvalues: v91 (copy), Eggs (copy)
            if Eggs.ADMIN_GROWS_BANDS_FROM <= p63 then
                return v91
            end

            if p64 <= Eggs.ADMIN_SHRINKS_BANDS_UNTIL then
                return 1 / v91
            end

            return 1
        end
    end

    local t5 = {
        AssetCategory = p61,
        AssetScale = DrawAssetScale(p62, v92),
        AssetEyeColor = v90.EyeColor,
        AssetColorSeed = v90.ColorSeed,
        AssetColorIndex = v90.ColorIndex,
        Mutations = v89,
        BaseMutation = v89[1]
    }
    local v93, v94 = Eggs2.SchemaValidation.SavedEgg(t5)

    assert(v93, v94)

    return t5
end

function t1.ToAssetItemData(p65) -- line: 603
    -- upvalues: Eggs2 (copy), Personalities (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p65), "Saved egg failed its schema check")

    local t6 = {
        Category = p65.AssetCategory,
        Scale = p65.AssetScale,
        EyeColor = p65.AssetEyeColor,
        ColorSeed = p65.AssetColorSeed,
        ColorIndex = p65.AssetColorIndex,
        Mutations = p65.Mutations or {},
        BaseMutation = p65.BaseMutation,
        Gender = p65.AssetGender,
        Personality = p65.AssetPersonality,
        IsStolenDNA = p65.IsStolenDNA,
        CreatorTemporary = p65.CreatorTemporary
    }

    return (Personalities.CreateNewItemData(t6))
end

function t1.SellPrice(p66) -- line: 624
    -- upvalues: Eggs (copy), AssetItems (copy), Eggs2 (copy), t1 (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p66), "Saved egg failed its schema check")

    local v97 = table.clone(t1.ToAssetItemData(p66))

    v97.Mutations = {}
    v97.BaseMutation = nil

    return AssetItems.SalePrice(v97) * Eggs.SELL_PRICE_SHARE
end

function t1.WeightKgForScale(p67, p68) -- line: 635
    -- upvalues: AssetItems (copy), v5 (copy), v9 (copy)
    v9(p67)
    v5(p68)

    return AssetItems.WeightKg({
        Category = p67,
        Scale = p68,
        Mutations = {}
    })
end

function t1.WeightKg(p69) -- line: 644
    -- upvalues: Eggs2 (copy), t1 (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p69), "Saved egg failed its schema check")

    return t1.WeightKgForScale(p69.AssetCategory, p69.AssetScale)
end

function t1.WeightLabel(p70) -- line: 650
    -- upvalues: AddCommas (copy), t1 (copy)
    return (("%*Kg"):format((AddCommas(t1.WeightKg(p70)))))
end

function t1.EggIcon(p71) -- line: 655
    -- upvalues: Assets (copy), EggSkins (copy), Mutations (copy)
    local v99 = EggSkins.Get(p71.EggSkin)

    if v99 ~= nil then
        return v99.Icon
    end

    local v100 = Mutations.EggIcon(p71.Mutations, p71.BaseMutation)

    if v100 then
        return v100
    end

    local AssetCategory = p71.AssetCategory
    local v101 = Assets.Directory[AssetCategory]

    assert(v101 ~= nil, (("Asset catalog carries no entry named %*"):format(AssetCategory)))

    return v101.Egg.Icon
end

function t1.DisplayName(p72) -- line: 668
    -- upvalues: Areas (copy), Assets (copy), HalloweenPets (copy), Eggs2 (copy), EggSkins (copy), Mutations (copy)
    assert(Eggs2.SchemaValidation.SavedEgg(p72), "Saved egg failed its schema check")

    local v105 = EggSkins.Get(p72.EggSkin)

    if v105 ~= nil then
        return v105.DisplayName
    end

    local v106 = Mutations.EggDisplayName(p72.Mutations, p72.BaseMutation)

    if v106 then
        return v106
    end

    if HalloweenPets.Specs[p72.AssetCategory] then
        return Assets.Directory[p72.AssetCategory].Egg.DisplayName
    end

    local AssetCategory = p72.AssetCategory
    local v107 = Assets.Directory[AssetCategory]

    assert(v107 ~= nil, (("Asset catalog carries no entry named %*"):format(AssetCategory)))

    local _id = v107.Rarity._id

    for _, v110 in pairs(Areas.Directory) do
        for _, v111 in ipairs(v110.DropTable) do
            local v112 = v111[1]

            if v112 == p72.AssetCategory or v112 == _id then
                return (("%* Egg"):format(v110.DisplayName))
            end
        end
    end

    return "Egg"
end

function t1.DisplayNameWithWeight(p73) -- line: 702
    -- upvalues: t1 (copy)
    return (("%* (%*)"):format(t1.DisplayName(p73), (t1.WeightLabel(p73))))
end

return t1

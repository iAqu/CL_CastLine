-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ShopConfig = require(script.Parent:WaitForChild("ShopConfig"))
local GrowthDisplay = require(script.Parent:WaitForChild("GrowthDisplay"))
local AchievementConfig = require(script.Parent:WaitForChild("AchievementConfig"))
local t1 = {}

function t1.AchBonus(p1, p2) -- line: 45
    -- upvalues: AchievementConfig (copy)
    local v1 = p1 and p1:GetAttribute("Ach_" .. p2)

    return type(v1) == "number" and AchievementConfig.Bonus(p2, v1) or 0
end

local function achMul(p3, p4) -- line: 49
    -- upvalues: t1 (copy)
    return 1 + t1.AchBonus(p3, p4) / 100
end

t1.VIP_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 248, 210)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 216, 74)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 20))
})
t1.VIP_STROKE = Color3.fromRGB(90, 40, 0)
t1.VIP_NAME_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 210, 70)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(245, 170, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 110, 0))
})

function t1.Owns(p5, p6) -- line: 61
    -- upvalues: ShopConfig (copy)
    return p5 ~= nil and p5:GetAttribute(ShopConfig.PassAttr(p6)) == true
end

local function owned(p7, p8) -- line: 66
    -- upvalues: ShopConfig (copy), t1 (copy)
    local t2 = {}

    for _, v2 in ipairs(ShopConfig.PASSES) do
        local v3 = v2.perks and v2.perks[p8]

        if v3 ~= nil and t1.Owns(p7, v2.key) then
            t2[#t2 + 1] = v3
        end
    end

    return t2
end

function t1.CashMul(p9) -- line: 75
    -- upvalues: t1 (copy), owned (copy)
    local cash = owned(p9, "cash")
    local n1 = 0

    for _, v4 in ipairs(cash) do
        n1 += v4
    end

    local v5
    local v6 = n1

    if p9 ~= nil and p9:GetAttribute("Cash4x") == true then
        v5 = if t1.Owns(p9, "Cash2x") then 2 else 4
        v6 = n1 + v5
        cash[#cash + 1] = 4
    end

    local HighRoller = t1.AchBonus(p9, "HighRoller")

    if not (HighRoller > 0) or not HighRoller then
        HighRoller = 1
    end

    local v7 = 1 + (tonumber(p9 and p9:GetAttribute("TitanMoney")) or 0) / 100

    if #cash == 0 then
        return HighRoller * v7
    end

    return v6 * HighRoller * v7
end

function t1.BagBonus(p10) -- line: 94
    -- upvalues: t1 (copy), owned (copy)
    local n2 = 0

    for _, v8 in ipairs((owned(p10, "bag"))) do
        n2 += v8
    end

    return n2 + t1.AchBonus(p10, "Completionist") + (tonumber(p10 and p10:GetAttribute("TitanBag")) or 0)
end

function t1.Hearts(p11) -- line: 101
    -- upvalues: owned (copy)
    local n3 = 0

    for _, v10 in ipairs((owned(p11, "hearts"))) do
        n3 += v10
    end

    return n3
end

function t1.GrowSpeed(_) -- line: 107
    -- upvalues: GrowthDisplay (copy)
    return GrowthDisplay.ONLINE_SPEED
end

function t1.GrowMul(p13) -- line: 111
    -- upvalues: t1 (copy), owned (copy)
    local n4 = 1

    for _, v11 in ipairs((owned(p13, "grow"))) do
        n4 *= v11
    end

    return n4 * (1 - math.clamp((tonumber(p13 and p13:GetAttribute("TitanGrow")) or 0) / 100, 0, 0.9)) / t1.GrowSpeed(p13) / (1 + t1.AchBonus(p13, "Caretaker") / 100)
end

local function product(p14, p15) -- line: 120
    -- upvalues: owned (copy)
    local n5 = 1

    for _, v13 in ipairs((owned(p14, p15))) do
        n5 *= v13
    end

    return n5
end

function t1.FeedMul(p16) -- line: 125
    -- upvalues: owned (copy)
    local n6 = 1

    for _, v14 in ipairs((owned(p16, "feed"))) do
        n6 *= v14
    end

    return n6
end

t1.HARPOON_RARITY_LUCK = {
    Common = 1.01,
    Uncommon = 1.03,
    Rare = 1.05,
    Epic = 1.1,
    Legendary = 1.15,
    Mythic = 1.3,
    Secret = 1.5
}

local HarpoonSkins = require(script.Parent:WaitForChild("HarpoonSkins"))

function t1.HarpoonPerks(p17) -- line: 139
    -- upvalues: ShopConfig (copy), t1 (copy), HarpoonSkins (copy)
    for _, v15 in ipairs({
            ShopConfig.LIMITED,
            ShopConfig.BONE_PACK
        }) do
        for _, v16 in ipairs(v15) do
            if v16.harpoon == p17 and v16.perks then
                return {
                    luck = v16.perks.luck or 1,
                    reel = v16.perks.reel or 1,
                    instant = v16.perks.instant == true,
                    hits = v16.perks.hits or 0,
                    life = v16.perks.life or 0,
                    double = v16.perks.double or 0,
                    instantChance = v16.perks.instantChance or 0
                }
            end
        end
    end

    local v17 = p17 and HarpoonSkins.Get(p17)

    if v17 and v17.perks then
        return {
            luck = v17.perks.luck or 1,
            reel = v17.perks.reel or 1,
            instant = v17.perks.instant == true,
            hits = v17.perks.hits or 0,
            life = v17.perks.life or 0,
            double = v17.perks.double or 0,
            instantChance = v17.perks.instantChance or 0
        }
    end

    return {
        reel = 1,
        hits = 0,
        life = 0,
        double = 0,
        instantChance = 0,
        luck = v17 and t1.HARPOON_RARITY_LUCK[v17.rarity] or 1
    }
end

local function harpoonPerk(p18, p19) -- line: 155
    -- upvalues: t1 (copy)
    local Harpoon = p18 and p18:GetAttribute("Harpoon")

    return t1.HarpoonPerks(Harpoon)[p19] or 1
end

local function hupAmp(p20) -- line: 162
    return tonumber(p20 and p20:GetAttribute("HUpAmp")) or 0
end

local function hup(p21, p22) -- line: 163
    return tonumber(p21 and p21:GetAttribute("HUp_" .. p22)) or 0
end

local function ownPerk(p23, p24) -- line: 165
    -- upvalues: t1 (copy)
    local Harpoon = p23 and p23:GetAttribute("Harpoon")
    local v19 = t1.HarpoonPerks(Harpoon)[p24] or 1
    local v20 = 1 + (tonumber(p23 and p23:GetAttribute("HUpAmp")) or 0)

    if p24 == "luck" or p24 == "reel" then
        return 1 + (v19 - 1) * v20
    end

    return v19 * v20
end

local v21

function t1.MyHarpoonPerks(p25, p26) -- line: 175
    -- upvalues: t1 (copy), v21 (ref)
    local v22 = table.clone(t1.HarpoonPerks(p26))

    v22.size = 0

    local function v23() -- line: 178
        -- upvalues: p25 (copy)
        return game:GetService("HttpService"):JSONDecode(p25 and p25:GetAttribute("HarpoonUps") or "{}")
    end

    local ok, result = pcall(v23)

    if ok then
        ok = type(result) == "table" and result[p26]
    end

    if type(ok) == "table" then
        v21 = v21 or require(script.Parent:WaitForChild("HarpoonUpgradeConfig"))

        local v24 = 1 + v21.Value(ok.amp or 0)
        local v25 = 1 + (v22.luck - 1) * v24
        local v26 = 1 + (v22.reel - 1) * v24

        v22.luck = v25
        v22.reel = v26
        v22.hits = math.floor(v22.hits * v24 + 1E-09)

        local v28 = v22.life * v24
        local v29 = v22.double * v24
        local v30 = v22.instantChance * v24

        v22.life = v28
        v22.double = v29
        v22.instantChance = v30

        local t4 = {
            reel = 0,
            size = 0,
            life = 0,
            double = 0,
            instant = 0
        }

        for _, v31 in ipairs({
                ok.s1,
                ok.s2
            }) do
            if type(v31) == "table" and t4[v31.k] then
                t4[v31.k] += v21.Value(v31.lv)
            end
        end

        v22.reel *= 1 - t4.reel
        v22.size = t4.size
        v22.life += t4.life
        v22.double += t4.double
        v22.instantChance += t4.instant
    end

    return v22
end

local v32

local function potionNum(p27, p28, p29, p30) -- line: 200
    -- upvalues: v32 (ref)
    local v33 = p27 and p27:GetAttribute(p28 .. "PotionEnd")
    local v34

    if not v33 or v33 <= workspace:GetServerTimeNow() then
        return p30
    else
        v34 = v32 or require(script.Parent:WaitForChild("PotionConfig"))
    end

    v32 = v34

    local v36 = v32.Get(p27:GetAttribute(p28 .. "PotionTier"))

    return v36 and v36[p29] or p30
end

function t1.LuckMul(p31) -- line: 208
    -- upvalues: t1 (copy), owned (copy), potionNum (copy)
    local n7 = 1

    for _, v37 in ipairs((owned(p31, "luck"))) do
        n7 *= v37
    end

    local Harpoon = p31 and p31:GetAttribute("Harpoon")
    local v38 = t1.HarpoonPerks(Harpoon).luck or 1
    local v39 = 1 + (tonumber(p31 and p31:GetAttribute("HUpAmp")) or 0)

    return n7 * (1 + (v38 - 1) * v39) * (1 + t1.AchBonus(p31, "Extinctionist") / 100) * (1 + (tonumber(p31 and p31:GetAttribute("TitanLuck")) or 0) / 100) * potionNum(p31, "Mutation", "luck", 1)
end

local t5 = {
    Fossilized = "TitanFossilized",
    Meteorite = "TitanMeteorite"
}

function t1.WeatherMutMul(p32, p33) -- line: 217
    -- upvalues: t5 (copy)
    local v41 = t5[p33]
    local v42, v43

    if v41 then
        local v45 = tonumber(p32 and p32:GetAttribute(v41))

        if v45 then
            v42 = v45
            v43 = true
        else
            v43 = false
        end
    else
        v43 = false
    end

    if not v43 then
        v42 = 0
    end

    return v42 > 0 and v42 / 10 or 1
end

function t1.ReelMul(p34) -- line: 223
    -- upvalues: t1 (copy), potionNum (copy)
    local Harpoon = p34 and p34:GetAttribute("Harpoon")
    local v46 = t1.HarpoonPerks(Harpoon).reel or 1
    local v47 = 1 + (tonumber(p34 and p34:GetAttribute("HUpAmp")) or 0)

    return (1 + (v46 - 1) * v47) * (1 - (tonumber(p34 and p34:GetAttribute("HUp_reel")) or 0)) * potionNum(p34, "Slow", "needle", 1)
end

function t1.HitsCut(p35) -- line: 227
    -- upvalues: t1 (copy)
    local Harpoon = p35 and p35:GetAttribute("Harpoon")

    return (math.floor((t1.HarpoonPerks(Harpoon).hits or 1) * (1 + (tonumber(p35 and p35:GetAttribute("HUpAmp")) or 0)) + 1E-09))
end

function t1.ExtraLife(p36) -- line: 235
    -- upvalues: t1 (copy)
    local Harpoon = p36 and p36:GetAttribute("Harpoon")

    return (t1.HarpoonPerks(Harpoon).life or 1) * (1 + (tonumber(p36 and p36:GetAttribute("HUpAmp")) or 0)) + (tonumber(p36 and p36:GetAttribute("HUp_life")) or 0) + (tonumber(p36 and p36:GetAttribute("TitanLife")) or 0) / 100
end

function t1.DoubleCatch(p37) -- line: 241
    -- upvalues: t1 (copy), potionNum (copy)
    local Harpoon = p37 and p37:GetAttribute("Harpoon")

    return (t1.HarpoonPerks(Harpoon).double or 1) * (1 + (tonumber(p37 and p37:GetAttribute("HUpAmp")) or 0)) + (tonumber(p37 and p37:GetAttribute("HUp_double")) or 0) + potionNum(p37, "Catch", "double", 0)
end

function t1.SizeMul(p38) -- line: 247
    -- upvalues: potionNum (copy)
    return (potionNum(p38, "Size", "size", 1) + potionNum(p38, "MegaSize", "size", 1) - 1) * (1 + (tonumber(p38 and p38:GetAttribute("HUp_size")) or 0))
end

function t1.MutationBoosts(p39) -- line: 252
    -- upvalues: v32 (ref), potionNum (copy)
    local t6 = {}

    if p39 then
        v32 = v32 or require(script.Parent:WaitForChild("PotionConfig"))

        for _, v57 in ipairs(v32.RUSH or {}) do
            local v58 = potionNum(p39, v57, "mutation", nil)

            if v58 then
                t6[#t6 + 1] = {
                    name = v58,
                    mul = potionNum(p39, v57, "mul", 1)
                }
            end
        end
    end

    return t6
end

function t1.InstantCatch(p40) -- line: 262
    -- upvalues: t1 (copy)
    return t1.HarpoonPerks(p40 and p40:GetAttribute("Harpoon")).instant == true
end

function t1.InstantChance(p41) -- line: 267
    -- upvalues: t1 (copy)
    local Harpoon = p41 and p41:GetAttribute("Harpoon")

    return (t1.HarpoonPerks(Harpoon).instantChance or 1) * (1 + (tonumber(p41 and p41:GetAttribute("HUpAmp")) or 0)) + (tonumber(p41 and p41:GetAttribute("HUp_instant")) or 0)
end

function t1.XPMul(p42) -- line: 271
    -- upvalues: owned (copy), potionNum (copy)
    local n8 = 1

    for _, v61 in ipairs((owned(p42, "xp"))) do
        n8 *= v61
    end

    return n8 * (1 + (tonumber(p42 and p42:GetAttribute("TitanXP")) or 0) / 100) * potionNum(p42, "XP", "xp", 1)
end

function t1.FatMul(p43) -- line: 276
    -- upvalues: t1 (copy), owned (copy)
    local n9 = 1

    for _, v62 in ipairs((owned(p43, "fat"))) do
        n9 *= v62
    end

    return n9 * (1 + t1.AchBonus(p43, "Glutton") / 100) * (1 + (tonumber(p43 and p43:GetAttribute("TitanFat")) or 0) / 100)
end

function t1.VipTag(p44) -- line: 280
    -- upvalues: owned (copy)
    return #owned(p44, "tag") > 0
end

return t1

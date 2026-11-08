-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TestName = "ScaledCashPacks",
    AttributeKey = "Economy.CashPacks.Group",
    GroupAttribute = "CashPackGroup",
    ReadyAttribute = "CashPacksReady",
    RevisionAttribute = "CashPackQuoteRevision",
    AmountAttributePrefix = "CashPackAmount",
    Offers = {
        {
            Name = "CashPack1",
            FixedProductName = "Money_24000",
            ProductId = 3714500805,
            DisplayName = "Cash Pack I",
            Minutes = 40,
            Floor = 24000
        },
        {
            Name = "CashPack2",
            FixedProductName = "Money_200000",
            ProductId = 3714500817,
            DisplayName = "Cash Pack II",
            Minutes = 120,
            Floor = 2E+05
        },
        {
            Name = "CashPack3",
            FixedProductName = "Money_800000",
            ProductId = 3714500825,
            DisplayName = "Cash Pack III",
            Minutes = 360,
            Floor = 8E+05
        },
        {
            Name = "CashPack4",
            FixedProductName = "Money_4000000",
            ProductId = 3714500832,
            DisplayName = "Cash Pack IV",
            Minutes = 1080,
            Floor = 4E+06
        },
        {
            Name = "CashPack5",
            FixedProductName = "Money_8000000",
            ProductId = 3714500837,
            DisplayName = "Cash Pack V",
            Minutes = 2880,
            Floor = 8E+06
        }
    }
}
local t2 = {
    1, 1.2, 1.5, 2, 2.5, 3, 4, 5,
    6, 8, 10
}

function t1.RoundNice(p1) -- line: 77
    -- upvalues: t2 (copy)
    if p1 <= 0 then
        return 0
    end

    assert(p1 < 1e999, "Cash pack amount must be finite")

    local v3 = 10 ^ math.floor((math.log10(p1)))
    local v4 = p1 / v3
    local v5 = t2[1]
    local n1 = 1e999

    for _, v6 in t2 do
        local v8 = math.abs(math.log10(v6) - math.log10(v4))

        if v8 < n1 then
            n1 = v8
            v5 = v6
        end
    end

    return v5 * v3
end

function t1.Amount(p2, p3) -- line: 94
    -- upvalues: t1 (copy)
    return (math.max(p2.Floor, t1.RoundNice(p2.Minutes * 60 * p3)))
end

function t1.RefreshQuote(p4, p5) -- line: 98
    -- upvalues: t1 (copy)
    if p5.Day < p4.Day or p5.Day == p4.Day and p5.AllowSameDay ~= true then
        return p4
    end

    local v10 = table.clone(p4)

    v10.Day = p5.Day

    local v11 = p5.PeakBaseRate >= p4.PeakBaseRate * p5.GrowthMultiplier

    if #p4.Amounts == 0 or v11 then
        v10.PeakBaseRate = math.max(p4.PeakBaseRate, p5.PeakBaseRate)
        v10.Amounts = {}

        for v12, v13 in p5.Offers do
            v10.Amounts[v12] = math.max(p4.Amounts[v12] or 0, t1.Amount(v13, v10.PeakBaseRate))
        end
    end

    return v10
end

function t1.FindSlot(p6) -- line: 118
    -- upvalues: t1 (copy)
    for v15, v16 in t1.Offers do
        if v16.ProductId == p6 then
            return v15
        end
    end

    return nil
end

function t1.NormalizeGroup(p7) -- line: 127
    if p7 == "VariantA" or p7 == "VariantB" then
        return p7
    end

    return "Control"
end

function t1.GetCanBuyProduct(p8, p9) -- line: 131
    local v17 = string.sub(p9, 1, 10) == "Treadmill_"
    local v18 = string.sub(p9, 1, 6) == "Trail_"

    if v17 or v18 then
        if p8 == nil then
            return false
        end

        if p8 ~= "VariantB" or p9 == "Treadmill_AstralTreadmill" or p9 == "Treadmill_GuardianTreadmill" then
            return true
        end

        return p9 == "Trail_MoonbloomTrail"
    end

    return true
end

function t1.GetPlayerGroup(p10) -- line: 146
    -- upvalues: t1 (copy)
    if p10:GetAttribute(t1.ReadyAttribute) == true then
        return t1.NormalizeGroup(p10:GetAttribute(t1.GroupAttribute))
    end

    return nil
end

function t1.GetShownAmount(p11, p12) -- line: 153
    -- upvalues: t1 (copy)
    if p11:GetAttribute(t1.ReadyAttribute) == true then
        local Attribute = p11:GetAttribute(t1.AmountAttributePrefix .. p12)

        if type(Attribute) == "number" then
            return Attribute
        end
    end

    return nil
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    TestName = "SpeedPackSizingTest",
    AttributeKey = "Economy.SpeedPacks.Group",
    ReadyAttribute = "SpeedPacksReady",
    RevisionAttribute = "SpeedPackQuoteRevision",
    MaxAttribute = "SpeedPackAtMax",
    AmountPrefix = "SpeedPackAmount",
    Static = { 150000, 1E+06, 1E+07, 5E+07, 5E+08, 1E+09 },
    Prices = { 79, 249, 699, 1499, 1999, 2999 },
    ProductIds = { 3611606545, 3611606516, 3611606528, 3611606552, 3611606562, 3611606539 },
    Names = { "Speed Pack I", "Speed Pack II", "Speed Pack III", "Speed Pack IV", "Speed Pack V", "Speed Pack VI" }
}

function t1.FindSlot(p1) -- line: 15
    -- upvalues: t1 (copy)
    return table.find(t1.ProductIds, p1)
end

function t1.GetShownAmount(p2, p3) -- line: 18
    -- upvalues: t1 (copy)
    if p2:GetAttribute(t1.ReadyAttribute) == true then
        local Attribute = p2:GetAttribute(t1.AmountPrefix .. p3)

        if type(Attribute) == "number" then
            return Attribute
        end
    end

    return nil
end

function t1.ObserveShownAmount(p4, p5, p6) -- line: 27
    -- upvalues: t1 (copy)
    local t2 = {}

    for _, v1 in {
            t1.ReadyAttribute,
            t1.RevisionAttribute,
            t1.AmountPrefix .. p5
        } do
        table.insert(t2, p4:GetAttributeChangedSignal(v1):Connect(p6))
    end

    p6()

    return function() -- line: 33
        -- upvalues: t2 (copy)
        for _, v2 in t2 do
            v2:Disconnect()
        end
    end
end

return t1

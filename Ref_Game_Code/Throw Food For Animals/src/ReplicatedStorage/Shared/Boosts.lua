-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local NumberFormat = require(script.Parent.NumberFormat)
local t1 = {
    TagColor = "#FFD84A",
    Cash = function(p1) -- Cash | line: 25
        return p1 and p1:GetAttribute("CashMultiplier") or 1
    end,
    Xp = function(p2) -- Xp | line: 29
        return p2 and p2:GetAttribute("XpMultiplier") or 1
    end
}

local function tag(p3) -- line: 33
    -- upvalues: t1 (copy)
    return string.format(" <font color=\"%s\">(x%s)</font>", t1.TagColor, (tostring(p3)))
end

function t1.IncomeText(p4, p5) -- line: 37
    -- upvalues: NumberFormat (copy), t1 (copy)
    local v1 = t1.Cash(p5)

    if v1 > 1 then
        return NumberFormat.PerSecond(p4 * v1) .. string.format(" <font color=\"%s\">(x%s)</font>", t1.TagColor, (tostring(v1)))
    end

    return NumberFormat.PerSecond(p4)
end

function t1.AnimalIncomeText(p6, p7, p8, p9) -- line: 45
    -- upvalues: NumberFormat (copy), t1 (copy)
    if not p8 then
        return t1.IncomeText(p6, p7)
    end

    if not p9 then
        return NumberFormat.OfBest(p8)
    end

    local v2 = t1.Cash(p7)

    return NumberFormat.OfBest(p8, p6 * v2) .. (v2 > 1 and string.format(" <font color=\"%s\">(x%s)</font>", t1.TagColor, (tostring(v2))) or "")
end

function t1.XpText(p10, p11, p12) -- line: 52
    -- upvalues: NumberFormat (copy), t1 (copy)
    local v3 = t1.Xp(p11)
    local v4 = "+" .. NumberFormat.Xp(p10 * v3) .. (p12 or " XP")

    if v3 > 1 then
        v4 ..= string.format(" <font color=\"%s\">(x%s)</font>", t1.TagColor, (tostring(v3)))
    end

    return v4
end

return t1

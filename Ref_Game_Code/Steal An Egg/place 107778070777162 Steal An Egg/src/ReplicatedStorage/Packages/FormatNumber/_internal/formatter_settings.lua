-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local enums = require(script.Parent.enums)
local t1 = {
    MAX_PRECISION = 2147483647
}

function t1.resolve_min_max_sig(p1, p2) -- line: 5
    -- upvalues: enums (copy), t1 (copy)
    if p1.type == enums._Internal.PrecisionType.SIGNFICANT then
        return p1.min, p1.max
    end

    if p1.type == enums._Internal.PrecisionType.FRACTION then
        return p2 + p1.min, p2 + p1.max
    end

    local v1, v2

    if p1.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT then
        local v3 = p2 + p1.minFractionDigits
        local v4 = p2 + p1.maxFractionDigits
        local minSignificantDigits, maxSignificantDigits = p1.minSignificantDigits, p1.maxSignificantDigits

        if p1.roundingPriority == enums.RoundingPriority.RELAXED then
            v1 = math.max(v3, minSignificantDigits)
            v2 = math.max(v4, maxSignificantDigits)
        else
            v1 = math.min(v3, minSignificantDigits)
            v2 = math.min(v4, maxSignificantDigits)
        end

        if not p1.sourcedWithSignificantDigits then
            return v3, v2
        end
    elseif p1.type == enums._Internal.PrecisionType.UNLIMITED then
        v1 = 1
        v2 = t1.MAX_PRECISION
    end

    return v1, v2
end

local v5 = table.freeze({
    [enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] = ".",
    [enums.ENumberFormatSymbols.kGroupingSeparatorSymbol] = ",",
    [enums.ENumberFormatSymbols.kMinusSignSymbol] = "-",
    [enums.ENumberFormatSymbols.kPlusSignSymbol] = "+",
    [enums.ENumberFormatSymbols.kExponentialSymbol] = "E",
    [enums.ENumberFormatSymbols.kInfinitySymbol] = "∞",
    [enums.ENumberFormatSymbols.kNaNSymbol] = "NaN"
})

function t1.generate_from_sign_enum(p3) -- line: 49
    -- upvalues: enums (copy)
    local v6, v7, v8, v9

    if p3 == enums.SignDisplay.AUTO then
        v6 = true
        v7 = true
        v8 = false
        v9 = false
    elseif p3 == enums.SignDisplay.ALWAYS then
        v6 = true
        v7 = true
        v8 = true
        v9 = true
    elseif p3 == enums.SignDisplay.NEVER then
        v6 = false
        v7 = false
        v8 = false
        v9 = false
    elseif p3 == enums.SignDisplay.NEGATIVE then
        v6 = true
        v7 = false
        v8 = false
        v9 = false
    elseif p3 == enums.SignDisplay.EXCEPT_ZERO then
        v6 = true
        v7 = false
        v8 = false
        v9 = true
    end

    return table.freeze({
        negative = v6,
        negativeZero = v7,
        positiveZero = v8,
        positive = v9
    })
end

function t1.linked_list_to_dict(p4) -- line: 77
    local t2 = {}
    local v10 = p4

    while v10 do
        if not t2[v10.key] then
            t2[v10.key] = v10.value
        end

        v10 = v10.parent
    end

    return table.freeze(t2)
end

function t1.resolve_settings(p5) -- line: 90
    -- upvalues: enums (copy), t1 (copy), v5 (copy)
    local t3 = {}

    t3.notation = p5.notation or table.freeze({
        type = enums._Internal.NotationType.SIMPLE
    })

    local v11 = t3.notation.type == enums._Internal.NotationType.COMPACT

    t3.precision = if p5.precision then p5.precision
        elseif v11 then table.freeze({
            minFractionDigits = 0,
            maxFractionDigits = 0,
            minSignificantDigits = 1,
            maxSignificantDigits = 2,
            type = enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
            roundingPriority = enums.RoundingPriority.RELAXED
        })
        else table.freeze({
            min = 0,
            max = 6,
            type = enums._Internal.PrecisionType.FRACTION
        })
    t3.roundingMode = if p5.roundingMode then p5.roundingMode elseif v11 or t3.notation.type == enums._Internal.NotationType.SCIENTIFIC then enums.RoundingMode.DOWN else enums.RoundingMode.HALF_EVEN

    if p5.grouping then
        local grouping = p5.grouping

        t3.minGrouping = if grouping == enums.GroupingStrategy.MIN2 then 5 elseif grouping == enums.GroupingStrategy.ON_ALIGNED then 4 else nil
    else
        t3.minGrouping = v11 and 5 or 4
    end

    t3.integerWidth = p5.integerWidth or table.freeze({
        min = 1,
        max = -1
    })
    t3.symbols = p5.symbols or v5
    t3.displaySignAt = if p5.sign then t1.generate_from_sign_enum(p5.sign) else t1.generate_from_sign_enum(enums.SignDisplay.AUTO)
    t3.alwaysDisplayDecimal = p5.decimal == enums.DecimalSeparatorDisplay.ALWAYS

    return table.freeze(t3)
end

return table.freeze(t1)

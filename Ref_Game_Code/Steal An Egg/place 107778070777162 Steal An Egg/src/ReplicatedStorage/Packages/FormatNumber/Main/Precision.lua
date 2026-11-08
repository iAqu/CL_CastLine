-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _internal = require(script.Parent.Parent._internal)
local t1 = {}
local t2 = {}
local v1 = _internal.class.create_init_function("Precision", nil, t2, nil, _internal.class.ImmutabilityType.DEFAULT)
local t3 = {}
local v2 = _internal.class.create_init_function("FractionPrecision", "Precision", t3, t2, _internal.class.ImmutabilityType.DEFAULT)

function t3.WithMinDigits(p1, p2) -- line: 22
    -- upvalues: _internal (copy), v1 (copy)
    local FractionPrecision = _internal.class.try_coerce(1, p1, "FractionPrecision")
    local v3 = _internal.class.try_coerce_range(2, p2, 1, 999)

    return v1({
        minSignificantDigits = 1,
        sourcedWithSignificantDigits = false,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = FractionPrecision.min,
        maxFractionDigits = FractionPrecision.max,
        maxSignificantDigits = v3,
        roundingPriority = _internal.enums.RoundingPriority.RELAXED
    })
end

function t3.WithMaxDigits(p3, p4) -- line: 37
    -- upvalues: _internal (copy), v1 (copy)
    local FractionPrecision = _internal.class.try_coerce(1, p3, "FractionPrecision")
    local v4 = _internal.class.try_coerce_range(2, p4, 1, 999)

    return v1({
        minSignificantDigits = 1,
        sourcedWithSignificantDigits = false,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = FractionPrecision.min,
        maxFractionDigits = FractionPrecision.max,
        maxSignificantDigits = v4,
        roundingPriority = _internal.enums.RoundingPriority.STRICT
    })
end

function t3.WithSignificantDigits(p5, p6, p7, p8) -- line: 52
    -- upvalues: _internal (copy), v1 (copy)
    local FractionPrecision = _internal.class.try_coerce(1, p5, "FractionPrecision")
    local v5 = _internal.class.try_coerce_range(2, p6, 1, 999)
    local v6 = _internal.class.try_coerce_range(3, p7, 1, 999)
    local v7 = _internal.class.try_coerce_enum(4, p8, _internal.enums.RoundingPriority)

    return v1({
        sourcedWithSignificantDigits = true,
        type = _internal.enums._Internal.PrecisionType.FRACTION_SIGNIFICANT,
        minFractionDigits = FractionPrecision.min,
        maxFractionDigits = FractionPrecision.max,
        minSignificantDigits = v5,
        maxSignificantDigits = v6,
        roundingPriority = v7
    })
end

local t4 = {}
local v8 = _internal.class.create_init_function("SignificantDigitsPrecision", "Precision", t4, t2, _internal.class.ImmutabilityType.DEFAULT)

function t1.unlimited() -- line: 84
    -- upvalues: _internal (copy), v1 (copy)
    return v1({
        type = _internal.enums._Internal.PrecisionType.UNLIMITED
    })
end

function t1.integer() -- line: 90
    -- upvalues: _internal (copy), v2 (copy)
    return v2({
        min = 0,
        max = 0,
        type = _internal.enums._Internal.PrecisionType.FRACTION
    })
end

function t1.fixedFraction(p9) -- line: 98
    -- upvalues: _internal (copy), v2 (copy)
    local v9 = _internal.class.try_coerce_range(1, p9, 0, 999)

    return v2({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v9,
        max = v9
    })
end

function t1.minFraction(p10) -- line: 108
    -- upvalues: _internal (copy), v2 (copy)
    local v10 = _internal.class.try_coerce_range(1, p10, 0, 999)

    return v2({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v10,
        max = _internal.formatter_settings.MAX_PRECISION
    })
end

function t1.maxFraction(p11) -- line: 118
    -- upvalues: _internal (copy), v2 (copy)
    local v11 = _internal.class.try_coerce_range(1, p11, 0, 999)

    return v2({
        min = 0,
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        max = v11
    })
end

function t1.minMaxFraction(p12, p13) -- line: 128
    -- upvalues: _internal (copy), v2 (copy)
    local v12 = _internal.class.try_coerce_range(1, p12, 0, 999)
    local v13 = _internal.class.try_coerce_range(2, p13, v12, 999)

    return v2({
        type = _internal.enums._Internal.PrecisionType.FRACTION,
        min = v12,
        max = v13
    })
end

function t1.fixedSignificantDigits(p14) -- line: 139
    -- upvalues: _internal (copy), v8 (copy)
    local v14 = _internal.class.try_coerce_range(1, p14, 1, 999)

    return v8({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v14,
        max = v14
    })
end

function t1.minSignificantDigits(p15) -- line: 149
    -- upvalues: _internal (copy), v8 (copy)
    local v15 = _internal.class.try_coerce_range(1, p15, 1, 999)

    return v8({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v15,
        max = _internal.formatter_settings.MAX_PRECISION
    })
end

function t1.maxSignificantDigits(p16) -- line: 159
    -- upvalues: _internal (copy), v8 (copy)
    local v16 = _internal.class.try_coerce_range(1, p16, 1, 999)

    return v8({
        min = 1,
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        max = v16
    })
end

function t1.minMaxSignificantDigits(p17, p18) -- line: 169
    -- upvalues: _internal (copy), v8 (copy)
    local v17 = _internal.class.try_coerce_range(1, p17, 1, 999)
    local v18 = _internal.class.try_coerce_range(2, p18, v17, 999)

    return v8({
        type = _internal.enums._Internal.PrecisionType.SIGNFICANT,
        min = v17,
        max = v18
    })
end

return table.freeze(t1)

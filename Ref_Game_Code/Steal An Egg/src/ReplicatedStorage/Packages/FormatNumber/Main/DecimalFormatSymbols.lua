-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _internal = require(script.Parent.Parent._internal)
local t1 = {}
local t2 = {}
local v1 = _internal.class.create_init_function("DecimalFormatSymbols", nil, t2, nil, _internal.class.ImmutabilityType.SYMBOLS)

function t2.GetSymbol(p1, p2) -- line: 13
    -- upvalues: _internal (copy)
    return _internal.class.try_coerce(1, p1, "DecimalFormatSymbols")[_internal.class.try_coerce_enum(2, p2, _internal.enums.ENumberFormatSymbols)]
end

function t2.SetSymbol(p3, p4, p5) -- line: 20
    -- upvalues: _internal (copy)
    _internal.class.try_coerce(1, p3, "DecimalFormatSymbols")[_internal.class.try_coerce_enum(2, p4, _internal.enums.ENumberFormatSymbols)] = _internal.class.try_coerce(3, p5, "string")
end

function t1.createWithLastResortData() -- line: 28
    -- upvalues: _internal (copy), v1 (copy)
    return v1({
        [_internal.enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] = ".",
        [_internal.enums.ENumberFormatSymbols.kGroupingSeparatorSymbol] = "",
        [_internal.enums.ENumberFormatSymbols.kMinusSignSymbol] = "-",
        [_internal.enums.ENumberFormatSymbols.kPlusSignSymbol] = "+",
        [_internal.enums.ENumberFormatSymbols.kExponentialSymbol] = "E",
        [_internal.enums.ENumberFormatSymbols.kInfinitySymbol] = "∞",
        [_internal.enums.ENumberFormatSymbols.kNaNSymbol] = "�"
    })
end

return table.freeze(t1)

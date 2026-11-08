-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _internal = require(script.Parent._internal)
local Notation = require(script.Notation)
local Precision = require(script.Precision)
local IntegerWidth = require(script.IntegerWidth)
local DecimalFormatSymbols = require(script.DecimalFormatSymbols)
local enums = _internal.enums
local t1 = {}
local t2 = {}
local v1 = _internal.class.create_init_function("NumberFormatter", nil, t2, nil, _internal.class.ImmutabilityType.NUMBER_FORMATTER)

function t2.Notation(p1, p2) -- line: 26
    -- upvalues: _internal (copy), v1 (copy)
    _internal.class.try_coerce(1, p1, "NumberFormatter")

    return v1({
        key = "notation",
        value = _internal.class.try_coerce(2, p2, "Notation"),
        parent = _internal.class.get_data(p1)
    })
end

function t2.Precision(p3, p4) -- line: 36
    -- upvalues: _internal (copy), v1 (copy)
    _internal.class.try_coerce(1, p3, "NumberFormatter")

    return v1({
        key = "precision",
        value = _internal.class.try_coerce(2, p4, "Precision"),
        parent = _internal.class.get_data(p3)
    })
end

function t2.RoundingMode(p5, p6) -- line: 46
    -- upvalues: _internal (copy), enums (copy), v1 (copy)
    _internal.class.try_coerce(1, p5, "NumberFormatter")

    return v1({
        key = "roundingMode",
        value = _internal.class.try_coerce_enum(2, p6, enums.RoundingMode),
        parent = _internal.class.get_data(p5)
    })
end

function t2.Grouping(p7, p8) -- line: 56
    -- upvalues: _internal (copy), enums (copy), v1 (copy)
    _internal.class.try_coerce(1, p7, "NumberFormatter")

    return v1({
        key = "grouping",
        value = _internal.class.try_coerce_enum(2, p8, enums.GroupingStrategy),
        parent = _internal.class.get_data(p7)
    })
end

function t2.IntegerWidth(p9, p10) -- line: 66
    -- upvalues: _internal (copy), v1 (copy)
    _internal.class.try_coerce(1, p9, "NumberFormatter")

    return v1({
        key = "integerWidth",
        value = _internal.class.try_coerce(2, p10, "IntegerWidth"),
        parent = _internal.class.get_data(p9)
    })
end

function t2.Symbols(p11, p12) -- line: 76
    -- upvalues: _internal (copy), v1 (copy)
    _internal.class.try_coerce(1, p11, "NumberFormatter")

    return v1({
        key = "symbols",
        value = _internal.class.try_coerce(2, p12, "DecimalFormatSymbols"),
        parent = _internal.class.get_data(p11)
    })
end

function t2.Sign(p13, p14) -- line: 86
    -- upvalues: _internal (copy), enums (copy), v1 (copy)
    _internal.class.try_coerce(1, p13, "NumberFormatter")

    return v1({
        key = "sign",
        value = _internal.class.try_coerce_enum(2, p14, enums.SignDisplay),
        parent = _internal.class.get_data(p13)
    })
end

function t2.Decimal(p15, p16) -- line: 96
    -- upvalues: _internal (copy), enums (copy), v1 (copy)
    _internal.class.try_coerce(1, p15, "NumberFormatter")

    return v1({
        key = "decimal",
        value = _internal.class.try_coerce_enum(2, p16, enums.DecimalSeparatorDisplay),
        parent = _internal.class.get_data(p15)
    })
end

local function resolve_nf_data(p17) -- line: 107
    -- upvalues: _internal (copy)
    return _internal.formatter_settings.resolve_settings(_internal.formatter_settings.linked_list_to_dict(p17))
end

function t2.Format(p18, p19) -- line: 111
    -- upvalues: _internal (copy), enums (copy), resolve_nf_data (copy)
    _internal.class.try_coerce(1, p18, "NumberFormatter")

    if type(p19) == "string" then
        error("Argument #2 as a string interpreted as decimal is not currently supported, please cast the argument to a double if you want the string to be interpreted as a double", 2)
    end

    local number = _internal.class.try_coerce(2, p19, "number")
    local v6 = _internal.class.get_resolved_data(p18, resolve_nf_data)
    local symbols = v6.symbols
    local v7, v8, v9

    if number == number then
        if number == 1e999 or number == (-1e999) then
            local v10 = number < 0

            v8 = symbols[enums.ENumberFormatSymbols.kInfinitySymbol]
            v7 = v10
            v9 = false
        else
            local v11, v12, v13

            if number == 0 then
                v7 = math.atan2(number, -1) < 0
                v12 = 0
                v13 = 1
            else
                v7 = number < 0
                v11, v12, v13 = _internal.decimal_conversion.from_double((math.abs(number)))
            end

            v8, v9 = _internal.format.format_unsigned_finite(v11, v12, v13, v7, v6)
        end
    else
        local v14 = string.byte(string.pack(">d", number)) >= 128

        v8 = symbols[enums.ENumberFormatSymbols.kNaNSymbol]
        v7 = v14
        v9 = true
    end

    return (_internal.format.display_sign(v8, v7, v9, v6.displaySignAt, v6.symbols))
end

function t2.ToSkeleton(p20) -- line: 168
    -- upvalues: _internal (copy)
    local NumberFormatter = _internal.class.try_coerce(1, p20, "NumberFormatter")

    return _internal.skeleton.settings_to_skeleton(_internal.formatter_settings.linked_list_to_dict(NumberFormatter))
end

function t1.with() -- line: 174
    -- upvalues: v1 (copy)
    return v1(nil)
end

function t1.forSkeleton(p21) -- line: 178
    -- upvalues: _internal (copy), v1 (copy)
    local string = _internal.class.try_coerce(1, p21, "string")
    local v15, v16 = _internal.skeleton.to_option_linked_list(string)

    if v15 then
        return v15, (v1(v16))
    end

    return v15, v16
end

return table.freeze({
    NumberFormatter = table.freeze(t1),
    Notation = Notation,
    Precision = Precision,
    RoundingPriority = enums.RoundingPriority,
    RoundingMode = enums.RoundingMode,
    GroupingStrategy = enums.GroupingStrategy,
    IntegerWidth = IntegerWidth,
    DecimalFormatSymbols = DecimalFormatSymbols,
    ENumberFormatSymbols = enums.ENumberFormatSymbols,
    SignDisplay = enums.SignDisplay,
    DecimalSeparatorDisplay = enums.DecimalSeparatorDisplay
})

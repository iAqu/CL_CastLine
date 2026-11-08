-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _internal = require(script.Parent.Parent._internal)
local t1 = {}
local t2 = {}
local v1 = _internal.class.create_init_function("Notation", nil, t1, nil, _internal.class.ImmutabilityType.DEFAULT)
local t3 = {}
local v2 = _internal.class.create_init_function("ScientificNotation", "Notation", t3, t2, _internal.class.ImmutabilityType.DEFAULT)

function t3.WithMinExponentDigits(p1, p2) -- line: 17
    -- upvalues: _internal (copy), v2 (copy)
    local ScientificNotation = _internal.class.try_coerce(1, p1, "ScientificNotation")
    local v3 = _internal.class.try_coerce_range(2, p2, 1, 999)
    local v4 = table.clone(ScientificNotation)

    v4.minExponentDigits = v3

    return v2(v4)
end

function t3.WithExponentSignDisplay(p3, p4) -- line: 30
    -- upvalues: _internal (copy), v2 (copy)
    local ScientificNotation = _internal.class.try_coerce(1, p3, "ScientificNotation")
    local v5 = _internal.class.try_coerce_enum(2, p4, _internal.enums.SignDisplay)
    local v6 = table.clone(ScientificNotation)

    v6.exponentSignDisplay = v5
    v6.displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(v5)

    return v2(v6)
end

local t4 = {}

_internal.class.create_init_function("CompactNotation", "Notation", t4, t2, _internal.class.ImmutabilityType.DEFAULT)

local t5 = {}

_internal.class.create_init_function("SimpleNotation", "Notation", t5, t2, _internal.class.ImmutabilityType.DEFAULT)

function t1.scientific() -- line: 64
    -- upvalues: _internal (copy), v2 (copy)
    return v2({
        power10Scale = 1,
        minExponentDigits = 1,
        type = _internal.enums._Internal.NotationType.SCIENTIFIC,
        exponentSignDisplay = _internal.enums.SignDisplay.AUTO,
        displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(_internal.enums.SignDisplay.AUTO)
    })
end

function t1.engineering() -- line: 74
    -- upvalues: _internal (copy), v2 (copy)
    return v2({
        power10Scale = 3,
        minExponentDigits = 1,
        type = _internal.enums._Internal.NotationType.SCIENTIFIC,
        exponentSignDisplay = _internal.enums.SignDisplay.AUTO,
        displayExponentSignAt = _internal.formatter_settings.generate_from_sign_enum(_internal.enums.SignDisplay.AUTO)
    })
end

function t1.compactWithSuffixThousands(p5) -- line: 84
    -- upvalues: _internal (copy), v1 (copy)
    local v7 = _internal.class.try_coerce(1, p5, "{string}")
    local v8 = table.find(v7, "")

    if v8 then
        error(string.format("Index %d is an empty string, please double check the suffixes", v8), 2)
    elseif #v7 == 0 then
        error("Suffixes is empty", 2)
    end

    return v1({
        power10Scale = 3,
        type = _internal.enums._Internal.NotationType.COMPACT,
        suffixes = v7,
        suffixesLength = #v7
    })
end

function t1.simple() -- line: 104
    -- upvalues: _internal (copy), v1 (copy)
    return v1({
        type = _internal.enums._Internal.NotationType.SIMPLE
    })
end

return table.freeze(t1)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _internal = require(script.Parent.Parent._internal)
local t1 = {}
local t2 = {}
local v1 = _internal.class.create_init_function("IntegerWidth", nil, t2, nil, _internal.class.ImmutabilityType.DEFAULT)

function t2.TruncateAt(p1, p2) -- line: 13
    -- upvalues: _internal (copy), v1 (copy)
    local IntegerWidth = _internal.class.try_coerce(1, p1, "IntegerWidth")
    local v2 = if not tonumber(p2) or math.ceil(p2) ~= -1 then _internal.class.try_coerce_range(1, p2, IntegerWidth.min, 999) else -1

    return v1({
        min = IntegerWidth.min,
        max = v2
    })
end

function t1.zeroFillTo(p3) -- line: 29
    -- upvalues: _internal (copy), v1 (copy)
    return v1({
        max = -1,
        min = _internal.class.try_coerce_range(1, p3, 0, 999)
    })
end

return table.freeze(t1)

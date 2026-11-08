-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {}
local self = setmetatable({}, {
    __mode = "k"
})

local function proxy_tostring(p1) -- line: 5
    -- upvalues: self (copy)
    return self[p1].type_name .. ": " .. self[p1].as_string
end

local v2 = table.freeze({
    DEFAULT = 0,
    NUMBER_FORMATTER = 1,
    SYMBOLS = 2
})

t1.ImmutabilityType = v2

function t1.create_init_function(p2, p3, p4, p5, p6) -- line: 16
    -- upvalues: t2 (copy), self (copy), proxy_tostring (copy), v2 (copy)
    local v3 = if p5 then setmetatable(table.clone(p5), {
        __index = p4
    }) else p4

    t2[p2] = p3 or "FormatNumberObject"

    return function(p7, p8) -- line: 33
        -- upvalues: p2 (copy), p6 (copy), v3 (copy), self (copy), proxy_tostring (copy), v2 (copy)
        local v5 = newproxy(true)
        local mt = getmetatable(v5)

        if p6 ~= v2.SYMBOLS and type(p7) == "table" then
            table.freeze(p7)
        end

        mt.data = p7
        mt.resolved_data = nil
        mt.type_name = p2

        if p8 then
            mt.as_string = p8
        else
            mt.as_string = string.sub(tostring(v5), 11)
        end

        mt.__index = v3
        mt.__tostring = proxy_tostring
        mt.__metatable = "The metatable is locked"

        if p6 ~= v2.NUMBER_FORMATTER then
            table.freeze(mt)
        end

        self[v5] = mt

        return v5
    end
end

function t1.is_a(p9, p10) -- line: 59
    -- upvalues: t2 (copy), self (copy)
    local v7 = self[p9]
    local v8 = v7 and v7.type_name

    if v8 == p10 then
        return true
    end

    local v9

    if not v8 then
        v9 = false

        return v9
    end

    repeat
        v8 = t2[v8]
        v9 = v8 == p10
    until not v8 or v9

    return v9
end

function t1.get_data(p11) -- line: 77
    -- upvalues: self (copy)
    return self[p11].data
end

function t1.get_resolved_data(p12, p13) -- line: 81
    -- upvalues: self (copy)
    local v10 = self[p12]
    local resolved_data = v10.resolved_data

    if not resolved_data then
        resolved_data = p13(v10.data)
        v10.resolved_data = resolved_data

        if resolved_data then
            table.freeze(v10)
        end
    end

    return resolved_data
end

function t1.try_coerce(p14, p15, p16, p17) -- line: 96
    -- upvalues: t1 (copy), self (copy)
    local v11, v12
    local v13 = p16

    if p15 ~= nil or p17 == nil then
        if p16 == "string" then
            if type(p15) == "string" then
                v12 = true
                v11 = p15
            elseif type(p15) == "number" then
                v12 = true
                v11 = tostring(p15)
            else
                v12 = false
            end
        elseif p16 == "number" then
            v11 = tonumber(p15)

            if v11 then
                v12 = true
            else
                v13 = p16 .. " object"
                v12 = false
            end
        elseif string.sub(p16, 1, 1) == "{" then
            local v14 = string.sub(p16, 2, -2)

            if type(p15) == "table" then
                v11 = table.move(p15, 1, rawlen(p15), 1, table.create((rawlen(p15))))

                for v15, v16 in v11 do
                    if type(v16) ~= v14 then
                        error(string.format("Values inside the table argument must be a %s, index %d got %s", v14, v15, (type(v16))), 3)
                    end
                end

                v13 = p16
                v12 = true
            else
                v13 = "table"
                v12 = false
            end
        elseif t1.is_a(p15, p16) then
            v12 = true
            v11 = self[p15].data
        else
            v12 = false
        end
    else
        v12 = true
        v11 = p17
    end

    if not v12 then
        error(string.format("Argument #%d provided must be a %s", p14, v13), 3)
    end

    return v11
end

function t1.try_coerce_range(p18, p19, p20, p21, p22) -- line: 151
    -- upvalues: t1 (copy)
    local v17

    if p19 ~= nil then
        local v18 = tonumber(p19)

        if v18 then
            v17 = t1.double_to_int32(v18)

            if not (p20 <= v17 and v17 <= p21) then
                v17 = nil
            end
        end
    else
        v17 = p22
    end

    return v17 or error(string.format("Argument #%d provided must be an integer that is in the range of %d to (and including) %d", p18, p20, p21), 3)
end

function t1.try_coerce_enum(p23, p24, p25, p26) -- line: 179
    -- upvalues: t1 (copy)
    local v19

    if p24 ~= nil then
        if tonumber(p24) then
            local v20 = t1.double_to_int32(p24)

            for _, v21 in p25 do
                if v20 == v21 then
                    v19 = v21
                    break
                end
            end
        end
    else
        v19 = p26
    end

    return v19 or error(string.format("Argument #%d provided is out of range", p23), 3)
end

function t1.double_to_int32(p27) -- line: 200
    if p27 > -2147483649 and p27 < 2147483648 then
        if p27 <= -1 then
            return (math.ceil(p27))
        end

        if p27 >= 1 then
            return (math.floor(p27))
        end

        return 0
    end

    return UDim.new(nil, p27).Offset
end

return table.freeze(t1)

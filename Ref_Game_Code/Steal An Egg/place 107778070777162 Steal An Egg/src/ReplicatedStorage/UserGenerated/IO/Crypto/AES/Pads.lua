-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local copy, create, fill, len = buffer.copy, buffer.create, buffer.fill, buffer.len
local readu8, writeu8, random = buffer.readu8, buffer.writeu8, math.random
local t1 = {}

local function nonPad(p1) -- line: 26
    return p1
end

t1.None = table.freeze({
    Overwrite = false,
    Pad = nonPad,
    Unpad = nonPad
})

local function anxPad(p2, p3, p4) -- line: 41
    -- upvalues: copy (copy), create (copy), fill (copy), len (copy), writeu8 (copy)
    local v1 = len(p2)
    local v2 = v1 - v1 % p4

    if p3 then
        assert(len(p3) >= v1 + p4, "Output buffer out of bounds")

        local v4 = p4 - v1 % p4

        copy(p3, 0, p2, 0, v1)
        fill(p3, v1, 0, v4 - 1)
        writeu8(p3, v2 + p4 - 1, v4)

        return p3
    end

    local v6 = v2 + p4
    local v7 = create(v6)

    copy(v7, 0, p2, 0, v1)
    writeu8(v7, v6 - 1, p4 - v1 % p4)

    return v7
end

local function anxUnpad(p5, p6, p7) -- line: 59
    -- upvalues: copy (copy), create (copy), len (copy), readu8 (copy)
    local v10 = len(p5)
    local v12 = readu8(p5, v10 - 1)
    local v13 = v10 - v12

    assert(v12 > 0 and v12 <= p7, "Got unexpected padding")

    for i = v13, v10 - 2 do
        if readu8(p5, i) ~= 0 then
            error("Got unexpected padding")
        end
    end

    local v15

    if p6 then
        assert(v13 <= len(p6), "Output buffer out of bounds")
        v15 = p6
    else
        v15 = create(v13)
    end

    copy(v15, 0, p5, 0, v13)

    return v15
end

local function i10Pad(p8, p9, p10) -- line: 82
    -- upvalues: copy (copy), create (copy), len (copy), writeu8 (copy), random (copy)
    local v17 = len(p8)
    local v18 = v17 - v17 % p10
    local v19

    if p9 then
        assert(len(p9) >= v17 + p10, "Output buffer out of bounds")
        v19 = p9
    else
        v19 = create(v18 + p10)
    end

    copy(v19, 0, p8, 0, v17)

    for i = v17, v18 + p10 - 2 do
        writeu8(v19, i, (random(0, 255)))
    end

    writeu8(v19, v18 + p10 - 1, p10 - v17 % p10)

    return v19
end

local function i10Unpad(p11, p12, p13) -- line: 97
    -- upvalues: copy (copy), create (copy), len (copy), readu8 (copy)
    local v24 = len(p11)
    local v26 = readu8(p11, v24 - 1)
    local v27 = v24 - v26

    assert(v26 > 0 and v26 <= p13, "Got unexpected padding")

    local v29

    if p12 then
        assert(v27 <= len(p12), "Output buffer out of bounds")
        v29 = p12
    else
        v29 = create(v27)
    end

    copy(v29, 0, p11, 0, v27)

    return v29
end

local function pksPad(p14, p15, p16) -- line: 115
    -- upvalues: copy (copy), create (copy), fill (copy), len (copy)
    local v31 = len(p14)
    local v32 = v31 - v31 % p16
    local v33

    if p15 then
        assert(len(p15) >= v31 + p16, "Output buffer out of bounds")
        v33 = p15
    else
        v33 = create(v32 + p16)
    end

    local v35 = p16 - v31 % p16

    copy(v33, 0, p14, 0, v31)
    fill(v33, v31, v35, v35)

    return v33
end

local function pksUnpad(p17, p18, p19) -- line: 128
    -- upvalues: copy (copy), create (copy), len (copy), readu8 (copy)
    local v36 = len(p17)
    local v38 = readu8(p17, v36 - 1)
    local v39 = v36 - v38

    assert(v38 > 0 and v38 <= p19, "Got unexpected padding")

    for i = v39, v36 - 2 do
        if readu8(p17, i) ~= v38 then
            error("Got unexpected padding")
        end
    end

    local v41

    if p18 then
        assert(v39 <= len(p18), "Output buffer out of bounds")
        v41 = p18
    else
        v41 = create(v39)
    end

    copy(v41, 0, p17, 0, v39)

    return v41
end

local function ii7Pad(p20, p21, p22) -- line: 151
    -- upvalues: copy (copy), create (copy), fill (copy), len (copy), writeu8 (copy)
    local v43 = len(p20)
    local v44

    if p21 then
        assert(len(p21) >= v43 + p22, "Output buffer out of bounds")
        fill(p21, v43 + 1, 0, p22 - v43 % p22 - 1)
        v44 = p21
    else
        v44 = create(v43 + p22 - v43 % p22)
    end

    copy(v44, 0, p20, 0, v43)
    writeu8(v44, v43, 128)

    return v44
end

local function ii7Unpad(p23, p24, p25) -- line: 163
    -- upvalues: copy (copy), create (copy), len (copy), readu8 (copy)
    local v46 = len(p23) - 1

    for i = v46, v46 - p25, -1 do
        local v47 = readu8(p23, i)

        if v47 == 128 then
            local v48

            if p24 then
                assert(i <= len(p24), "Output buffer out of bounds")
                v48 = p24
            else
                v48 = create(i)
            end

            copy(v48, 0, p23, 0, i)

            return v48
        end

        assert(v47 == 0, "Got unexpected padding")
    end

    error("Got unexpected padding")

    return create(0)
end

local function zroPad(p26, p27, p28) -- line: 188
    -- upvalues: copy (copy), create (copy), fill (copy), len (copy)
    local v51 = len(p26)
    local v52

    if p27 then
        assert(len(p27) >= v51 + p28, "Output buffer out of bounds")
        fill(p27, v51, 0, p28 - v51 % p28)
        v52 = p27
    else
        v52 = create(v51 + p28 - v51 % p28)
    end

    copy(v52, 0, p26, 0, v51)

    return v52
end

local function zroUnpad(p29, p30, p31) -- line: 199
    -- upvalues: copy (copy), create (copy), len (copy), readu8 (copy)
    local v54 = len(p29) - 1

    for i = v54, v54 - p31, -1 do
        if readu8(p29, i) == 0 then
            local v55 = i + 1
            local v56

            if p30 then
                assert(v55 <= len(p30), "Output buffer out of bounds")
                v56 = p30
            else
                v56 = create(v55)
            end

            copy(v56, 0, p29, 0, v55)

            return v56
        end
    end

    copy(p30, 0, p29, 0, v54 - p31 - 1)

    return p30
end

local t2 = {
    __index = function(_, p33) -- __index | line: 220
        -- upvalues: anxPad (copy), i10Pad (copy), i10Unpad (copy), pksPad (copy), pksUnpad (copy), ii7Pad (copy), ii7Unpad (copy), zroPad (copy), zroUnpad (copy)
        if p33 == "AnsiX923" then
            return {
                Overwrite = nil,
                Pad = anxPad,
                Unpad = anxPad
            }
        end

        if p33 == "Iso10126" then
            return {
                Overwrite = nil,
                Pad = i10Pad,
                Unpad = i10Unpad
            }
        end

        if p33 == "Pkcs7" then
            return {
                Overwrite = nil,
                Pad = pksPad,
                Unpad = pksUnpad
            }
        end

        if p33 == "Iso7816_4" then
            return {
                Overwrite = nil,
                Pad = ii7Pad,
                Unpad = ii7Unpad
            }
        end

        return if p33 == "Zero" then {
            Overwrite = nil,
            Pad = zroPad,
            Unpad = zroUnpad
        } else nil
    end,
    __newindex = function() -- __newindex | line: 249
    end
}

setmetatable(t1, t2)
t1.AnsiX923 = {}
t1.Iso10126 = {}
t1.Pkcs7 = {}
t1.Iso7816_4 = {}
t1.Zero = {}
table.freeze(t1)
t2.__metatable = "This metatable is locked"

return t1

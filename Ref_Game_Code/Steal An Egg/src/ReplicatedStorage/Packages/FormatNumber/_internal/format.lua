-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local enums = require(script.Parent.enums)
local formatter_settings = require(script.Parent.formatter_settings)
local t1 = {}

local function internal_get_digits(p1, p2, p3, p4) -- line: 5
    local v1, v2

    if p3 <= 0 then
        v1 = 1
        v2 = string.rep("0", -p3 + 1)
    else
        v1 = p3
        v2 = ""
    end

    local v4 = p4 - math.max(p2, v1 - 1)
    local v5, v6

    if v4 <= 0 then
        v5 = p4
        v6 = ""
    else
        v5 = p2
        v6 = string.rep("0", v4)
    end

    return v2 .. (if p2 < v1 then "" else string.char(table.unpack(p1, v1, v5))) .. v6
end

function t1.strip_trailing_zero(p5, p6) -- line: 32
    if p6 < 0 then
        return 0
    end

    local v8 = p6

    while p5[v8] == 0 do
        v8 -= 1
    end

    return v8
end

function t1.round_sig(p7, p8, p9, p10, p11) -- line: 43
    -- upvalues: enums (copy), t1 (copy)
    local v9, v10

    if not (p9 < p8) then
        v9 = p8
        v10 = 0

        return v9, v10
    end

    local v11 = if p9 < 0 then -1
        elseif p7[p9 + 1] > 5 then 1
        elseif p7[p9 + 1] ~= 5 then -1
        elseif p9 + 1 < p8 then 1
        else 0
    local v12

    if p11 == enums.RoundingMode.CEILING then
        v12 = if p10 then 1 else -2
    elseif p11 == enums.RoundingMode.FLOOR then
        v12 = if p10 then -2 else 1
    elseif p11 == enums.RoundingMode.UP then
        v12 = -2
    elseif p11 == enums.RoundingMode.DOWN then
        v12 = 1
    elseif p11 == enums.RoundingMode.HALF_EVEN then
        v12 = if p9 <= 0 then 0 else p7[p9] % -2
    elseif p11 == enums.RoundingMode.HALF_DOWN then
        v12 = 0
    elseif p11 == enums.RoundingMode.HALF_UP then
        v12 = -1
    end

    local v13 = p9

    if v12 < v11 then
        while p7[v13] == 9 and v13 > 0 do
            v13 -= 1
        end

        if v13 <= 0 then
            p7[1] = 1
            v13, v10 = 1, 1 - v13
        else
            p7[v13] += 1
            v10 = 0
        end
    else
        v10 = 0
    end

    return t1.strip_trailing_zero(p7, v13), v10
end

function t1.resolve_int_frac(p12, p13, p14, p15, p16, p17, p18) -- line: 108
    -- upvalues: internal_get_digits (copy)
    for i = 1, p13 do
        p12[i] += 48
    end

    local v14, v15

    if not (p14 < p15 and p16 < p14 + 1) then
        v14 = internal_get_digits(p12, p13, p15, p14)
        v15 = internal_get_digits(p12, p13, p14 + 1, p16)
    else
        v14 = "0"
        v15 = ""
    end

    if p17 and p17 <= p14 - p15 + 1 then
        local v16 = if p18 == "%" then "%0%%" elseif #p18 > 1 then "%0" .. string.reverse(p18) else "%0" .. p18

        v14 = string.reverse((string.gsub(string.reverse(v14), "...", v16, (p14 - p15) / 3)))
    end

    return v14, v15
end

function t1.format_expt(p19, p20, p21, p22) -- line: 148
    -- upvalues: enums (copy)
    local v17, v18

    if p19 < 0 then
        v17 = tostring(-p19)
        v18 = if p22.negative then p20[enums.ENumberFormatSymbols.kMinusSignSymbol] else ""
    elseif p19 == 0 then
        v18 = if p22.positiveZero then p20[enums.ENumberFormatSymbols.kPlusSignSymbol] else ""
        v17 = "0"
    else
        v17 = tostring(p19)
        v18 = if p22.positive then p20[enums.ENumberFormatSymbols.kPlusSignSymbol] else ""
    end

    local v20 = string.rep("0", p21 - #v17) .. v17

    return p20[enums.ENumberFormatSymbols.kExponentialSymbol] .. v18 .. v20
end

function t1.resolve_with_notation(_, p24, p25, p26, p27) -- line: 173
    -- upvalues: enums (copy), t1 (copy)
    local power10Scale, v21, v22, v23

    if p24 <= 0 then
        v21 = p25

        if p26.type == enums._Internal.NotationType.SCIENTIFIC then
            v22 = t1.format_expt(0, p27, p26.minExponentDigits, p26.displayExponentSignAt)
        end
    elseif p26.type == enums._Internal.NotationType.SIMPLE then
        v22 = nil
        power10Scale = nil
        v23 = nil
        v21 = p25 + p24
    else
        power10Scale = p26.power10Scale

        local v24 = p25 + p24 - 1
        local v26 = math.floor(v24 / power10Scale)

        v21 = v24 - v26 * power10Scale + 1

        if p26.type == enums._Internal.NotationType.COMPACT then
            local suffixesLength = p26.suffixesLength
            local v27

            if suffixesLength < v26 then
                v27 = v21 + (v26 - suffixesLength) * power10Scale
                v22 = p26.suffixes[suffixesLength]
            elseif v26 < 0 then
                v22 = nil
                v27 = v21 + v26 * power10Scale
            else
                v27 = v21

                if v26 ~= 0 then
                    v22 = p26.suffixes[v26]
                end
            end

            v21 = v27

            if v26 >= 0 and v26 < suffixesLength then
                v23 = p26.suffixes[v26 + 1]
            else
                power10Scale = nil
            end
        else
            v22 = t1.format_expt(v26 * power10Scale, p27, p26.minExponentDigits, p26.displayExponentSignAt)
            v23 = t1.format_expt((v26 + 1) * power10Scale, p27, p26.minExponentDigits, p26.displayExponentSignAt)
        end
    end

    return v21, v22, power10Scale, v23
end

function t1.format_unsigned_finite(p28, p29, p30, p31, p32) -- line: 230
    -- upvalues: enums (copy), formatter_settings (copy), t1 (copy)
    local min, max = p32.integerWidth.min, p32.integerWidth.max
    local notation, symbols = p32.notation, p32.symbols
    local v28, v29, v30, v31 = t1.resolve_with_notation(p28, p29, p30, notation, symbols)
    local v32, v33 = formatter_settings.resolve_min_max_sig(p32.precision, v28)
    local v34, v35 = t1.round_sig(p28, p29, v33, p31, p32.roundingMode)
    local v36 = v34 == 0

    if v35 > 0 then
        local v37, v38

        if v28 == v30 then
            v38 = v31

            local v39 = v35 == 1

            v37 = 1
            assert(v39)
        else
            v38 = v29
            v37 = v28 + v35
        end

        v29 = v38
        v32 = formatter_settings.resolve_min_max_sig(p32.precision, v37)
        v28 = v37
    elseif v36 then
        v32 = formatter_settings.resolve_min_max_sig(p32.precision, 1)
        v28 = 1
    end

    if not (v28 < min) then
        min = if max == -1 or not (max < v28) then v28 else max
    end

    local v40, v41 = t1.resolve_int_frac(p28, v34, v28, math.max(v28, 0) - min + 1, math.max(v34, v32), p32.minGrouping, symbols[enums.ENumberFormatSymbols.kGroupingSeparatorSymbol])

    if p32.alwaysDisplayDecimal or v41 ~= "" then
        v40 ..= symbols[enums.ENumberFormatSymbols.kDecimalSeparatorSymbol] .. v41
    end

    if v29 then
        v40 ..= v29
    end

    return v40, v36
end

function t1.display_sign(p33, p34, p35, p36, p37) -- line: 298
    -- upvalues: enums (copy)
    local v42, v43

    if p34 then
        v42 = p37[enums.ENumberFormatSymbols.kMinusSignSymbol]
        v43 = if p35 then p36.negativeZero else p36.negative
    else
        v42 = p37[enums.ENumberFormatSymbols.kPlusSignSymbol]
        v43 = if p35 then p36.positiveZero else p36.positive
    end

    if v43 then
        return v42 .. p33
    end

    return p33
end

return table.freeze(t1)

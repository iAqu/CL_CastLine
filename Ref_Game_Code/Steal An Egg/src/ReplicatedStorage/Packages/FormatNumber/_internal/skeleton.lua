-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local formatter_settings = require(script.Parent.formatter_settings)
local enums = require(script.Parent.enums)
local t1 = {}
local t2 = {
    [enums.SignDisplay.AUTO] = nil,
    [enums.SignDisplay.ALWAYS] = "sign-always",
    [enums.SignDisplay.NEVER] = "sign-never",
    [enums.SignDisplay.EXCEPT_ZERO] = "sign-except-zero",
    [enums.SignDisplay.NEGATIVE] = "sign-negative"
}

local function notation_to_skeleton(p1) -- line: 14
    -- upvalues: enums (copy), t2 (copy)
    local v1, v2

    if p1.type == enums._Internal.NotationType.SCIENTIFIC then
        v2 = if p1.power10Scale == 3 then "engineering" else "scientific"

        if p1.minExponentDigits ~= 1 then
            v2 ..= "/*" .. string.rep("e", p1.minExponentDigits)
        end

        if p1.exponentSignDisplay ~= enums.SignDisplay.AUTO then
            return true, v2 .. "/" .. t2[p1.exponentSignDisplay]
        end

        v1 = true
    else
        if p1.type == enums._Internal.NotationType.SIMPLE then
            return true, nil
        end

        v1 = false
        v2 = "Compact notation skeleton is not supported for being represented as a skeleton string in this module"
    end

    return v1, v2
end

local function precision_to_skeleton(p2) -- line: 39
    -- upvalues: formatter_settings (copy), enums (copy)
    local minFractionDigits, maxFractionDigits, v3, v4, v5

    if p2.type == enums._Internal.PrecisionType.FRACTION then
        v5 = nil
        minFractionDigits = p2.min
        maxFractionDigits = p2.max
        v3 = nil
        v4 = nil
    elseif p2.type == enums._Internal.PrecisionType.SIGNFICANT then
        v5 = nil
        minFractionDigits = nil
        maxFractionDigits = nil
        v3 = p2.min
        v4 = p2.max
    elseif p2.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT then
        minFractionDigits = p2.minFractionDigits
        maxFractionDigits = p2.maxFractionDigits
        v5 = nil

        if p2.sourcedWithSignificantDigits then
            v3 = p2.minSignificantDigits
            v4 = p2.maxSignificantDigits
        elseif p2.roundingPriority == enums.RoundingPriority.RELAXED then
            v3 = p2.maxSignificantDigits
            v4 = formatter_settings.MAX_PRECISION
        else
            v3 = 1
            v4 = p2.maxSignificantDigits
        end
    else
        v5 = "precision-unlimited"
    end

    local v6

    if minFractionDigits then
        if maxFractionDigits == 0 then
            v6 = "precision-integer"
        else
            local v7 = "." .. string.rep("0", minFractionDigits)

            v6 = if maxFractionDigits == formatter_settings.MAX_PRECISION then v7 .. "*" else v7 .. string.rep("#", maxFractionDigits - minFractionDigits)
        end
    end

    local v8

    if v3 then
        local v9 = string.rep("@", v3)

        v8 = if v4 == formatter_settings.MAX_PRECISION then v9 .. "*" else v9 .. string.rep("#", v4 - v3)
    end

    if v6 then
        if v8 then
            v6 ..= "/" .. v8

            if p2.type == enums._Internal.PrecisionType.FRACTION_SIGNIFICANT and p2.sourcedWithSignificantDigits then
                if p2.roundingPriority == enums.RoundingPriority.RELAXED then
                    return v6 .. "r"
                end

                return v6 .. "s"
            end
        end
    else
        v6 = v8 or v5
    end

    return v6
end

local t3 = {
    [enums.RoundingMode.CEILING] = "rounding-mode-ceiling",
    [enums.RoundingMode.FLOOR] = "rounding-mode-floor",
    [enums.RoundingMode.DOWN] = "rounding-mode-down",
    [enums.RoundingMode.UP] = "rounding-mode-up",
    [enums.RoundingMode.HALF_EVEN] = "rounding-mode-half-even",
    [enums.RoundingMode.HALF_DOWN] = "rounding-mode-half-down",
    [enums.RoundingMode.HALF_UP] = "rounding-half-up"
}
local t4 = {
    [enums.GroupingStrategy.OFF] = "group-off",
    [enums.GroupingStrategy.MIN2] = "group-min2",
    [enums.GroupingStrategy.ON_ALIGNED] = "group-on-aligned"
}

local function int_width_to_skeleton(p3) -- line: 123
    if p3.max == -1 then
        return "integer-width/*" .. string.rep("0", p3.min)
    end

    if p3.max ~= 0 or p3.min ~= 0 then
        return "integer-width/" .. string.rep("#", p3.max - p3.min) .. string.rep("0", p3.min)
    end

    return "integer-width-trunc"
end

local t5 = {
    [enums.DecimalSeparatorDisplay.AUTO] = nil,
    [enums.DecimalSeparatorDisplay.ALWAYS] = "decimal-always"
}

function t1.settings_to_skeleton(p4) -- line: 142
    -- upvalues: notation_to_skeleton (copy), precision_to_skeleton (copy), t3 (copy), t4 (copy), int_width_to_skeleton (copy), t5 (copy)
    local t6 = {}
    local v10, v11

    if p4.notation then
        v10, v11 = notation_to_skeleton(p4.notation)

        if v10 then
            table.insert(t6, v11)
            v11 = nil
        end
    else
        v10 = true
    end

    if v10 then
        if p4.precision then
            table.insert(t6, (precision_to_skeleton(p4.precision)))
        end

        if p4.roundingMode then
            table.insert(t6, t3[p4.roundingMode])
        end

        if p4.grouping then
            table.insert(t6, t4[p4.grouping])
        end

        if p4.integerWidth then
            table.insert(t6, (int_width_to_skeleton(p4.integerWidth)))
        end

        if p4.decimal then
            table.insert(t6, t5[p4.decimal])
        end

        v11 = table.concat(t6, " ")
    end

    return v10, v11
end

local t7 = {
    ["notation-simple"] = "notation",
    ["precision-unlimited"] = "precision",
    [".+"] = "precision",
    ["rounding-mode-ceiling"] = "roundingMode",
    ["rounding-mode-floor"] = "roundingMode",
    ["rounding-mode-down"] = "roundingMode",
    ["rounding-mode-up"] = "roundingMode",
    ["rounding-mode-half-even"] = "roundingMode",
    ["rounding-mode-half-down"] = "roundingMode",
    ["rounding-mode-half-up"] = "roundingMode",
    ["group-off"] = "grouping",
    ["group-min2"] = "grouping",
    ["group-on-aligned"] = "grouping",
    [",_"] = "grouping",
    [",?"] = "grouping",
    [",!"] = "grouping",
    ["sign-auto"] = "sign",
    ["sign-always"] = "sign",
    ["sign-never"] = "sign",
    ["sign-except-zero"] = "sign",
    ["sign-negative"] = "sign",
    ["+!"] = "sign",
    ["+_"] = "sign",
    ["+?"] = "sign",
    ["+-"] = "sign",
    ["decimal-auto"] = "decimal",
    ["decimal-always"] = "decimal"
}
local t8 = {
    ["notation-simple"] = table.freeze({
        type = enums._Internal.NotationType.SIMPLE
    }),
    ["precision-unlimited"] = table.freeze({
        type = enums._Internal.PrecisionType.UNLIMITED
    }),
    [".+"] = table.freeze({
        type = enums._Internal.PrecisionType.UNLIMITED
    }),
    ["rounding-mode-ceiling"] = enums.RoundingMode.CEILING,
    ["rounding-mode-floor"] = enums.RoundingMode.FLOOR,
    ["rounding-mode-down"] = enums.RoundingMode.DOWN,
    ["rounding-mode-up"] = enums.RoundingMode.UP,
    ["rounding-mode-half-even"] = enums.RoundingMode.HALF_EVEN,
    ["rounding-mode-half-down"] = enums.RoundingMode.HALF_DOWN,
    ["rounding-mode-half-up"] = enums.RoundingMode.HALF_UP,
    ["group-off"] = enums.GroupingStrategy.OFF,
    ["group-min2"] = enums.GroupingStrategy.MIN2,
    ["group-on-aligned"] = enums.GroupingStrategy.ON_ALIGNED,
    [",_"] = enums.GroupingStrategy.OFF,
    [",?"] = enums.GroupingStrategy.MIN2,
    [",!"] = enums.GroupingStrategy.ON_ALIGNED,
    ["sign-auto"] = enums.SignDisplay.AUTO,
    ["sign-always"] = enums.SignDisplay.ALWAYS,
    ["sign-never"] = enums.SignDisplay.NEVER,
    ["sign-except-zero"] = enums.SignDisplay.EXCEPT_ZERO,
    ["sign-negative"] = enums.SignDisplay.NEGATIVE,
    ["+!"] = enums.SignDisplay.ALWAYS,
    ["+_"] = enums.SignDisplay.NEVER,
    ["+?"] = enums.SignDisplay.EXCEPT_ZERO,
    ["+-"] = enums.SignDisplay.NEGATIVE,
    ["decimal-auto"] = enums.DecimalSeparatorDisplay.AUTO,
    ["decimal-always"] = enums.DecimalSeparatorDisplay.ALWAYS
}

local function skeleton_to_scientific_notation(p5) -- line: 257
    -- upvalues: formatter_settings (copy), enums (copy), t8 (copy)
    local v17, v18, v19 = string.match(p5, "^(%a+)/?([^/]*)/?([^/]*)$")
    local AUTO = enums.SignDisplay.AUTO

    if v17 ~= "scientific" and v17 ~= "engineering" then
        return nil
    end

    local n1 = 1

    if string.match(v18, "^[%*%+]e+$") then
        n1 = #v18 - 1
    elseif string.match(v19, "^[%*%+]e+$") then
        v19, n1 = v18, #v19 - 1
    else
        v19 = v18
    end

    if v19 ~= "" then
        if string.sub(v19, 1, 5) ~= "sign-" then
            return nil
        end

        AUTO = t8[v19]
    end

    if n1 > 999 then
        return nil
    end

    return table.freeze({
        type = enums._Internal.NotationType.SCIENTIFIC,
        power10Scale = v17 == "engineering" and 3 or 1,
        minExponentDigits = n1,
        exponentSignDisplay = AUTO,
        displayExponentSignAt = formatter_settings.generate_from_sign_enum(AUTO)
    })
end

local function skeleton_to_scientific_notation_concise(p6) -- line: 295
    -- upvalues: formatter_settings (copy), enums (copy), t8 (copy)
    local v20, v21 = string.match(p6, "^(EE?)(.+)$")

    if not v20 then
        return nil
    end

    local v22, v23 = string.match(v21, "^(%+[!%?])(.+)$")
    local v24

    if v22 then
        v24 = t8[v22]
    else
        v23 = v21
        v24 = enums.SignDisplay.AUTO
    end

    if not string.match(v23, "^0+$") or #v23 > 999 then
        return nil
    end

    return table.freeze({
        type = enums._Internal.NotationType.SCIENTIFIC,
        power10Scale = v20 == "EE" and 3 or 1,
        minExponentDigits = #v23,
        exponentSignDisplay = v24,
        displayExponentSignAt = formatter_settings.generate_from_sign_enum(v24)
    })
end

local function skeleton_to_precision(p7) -- line: 334
    -- upvalues: formatter_settings (copy), enums (copy)
    local v25, v26, v27 = string.match(p7, "^%.((0*)#*)(.*)$")

    if not v25 then
        v25, v27 = string.match(p7, "^(precision%-integer)(.*)$")
    end

    if v25 then
        local v28, v29

        if v25 == "precision-integer" then
            v28 = 0
            v29 = 0
        else
            v28 = #v26
            v29 = #v25
        end

        if string.match(v27, "^[%*%+]") and v26 == v25 then
            v27 = string.sub(v27, 2)
            v29 = -1
        end

        if v28 > 999 or v29 > 999 then
            return nil
        end

        local v30 = if v29 == -1 then formatter_settings.MAX_PRECISION else v29

        if string.sub(v27, 1, 1) == "/" then
            local v31, v32, v33 = string.match(v27, "^/((@+)#*)([%*%+rs]?)$")

            if v31 and (v33 ~= "" or v32 == "@") then
                local v34, v35, freeze, t11, v36

                if v33 ~= "*" and v33 ~= "+" or v32 == v31 then
                    if v33 == "" then
                        v34 = #v31
                        v33 = "s"
                        v35 = 1
                        v36 = false
                    elseif v33 == "*" or v33 == "+" then
                        v34 = #v32
                        v33 = "r"
                        v35 = 1
                        v36 = false
                    else
                        v35 = #v32
                        v34 = #v31
                        v36 = true
                    end

                    if v35 > 999 or v34 > 999 then
                        return nil
                    end

                    freeze = table.freeze
                    t11 = {}
                    t11.type = enums._Internal.PrecisionType.FRACTION_SIGNIFICANT
                    t11.minFractionDigits = v28
                    t11.maxFractionDigits = v30
                    t11.minSignificantDigits = v35
                    t11.maxSignificantDigits = v34

                    if v33 == "r" then
                        t11.roundingPriority = enums.RoundingPriority.RELAXED
                    else
                        t11.roundingPriority = enums.RoundingPriority.STRICT
                    end

                    t11.sourcedWithSignificantDigits = v36

                    return freeze(t11)
                end
            end
        elseif v27 == "" then
            return table.freeze({
                type = enums._Internal.PrecisionType.FRACTION,
                min = v28,
                max = v30
            })
        end
    else
        local v37, v38, v39 = string.match(p7, "^((@+)#*)([%*%+]?)$")

        if v37 then
            local v40 = #v38
            local v41 = #v37

            if v39 ~= "" then
                if v40 ~= v41 then
                    return nil
                end

                v41 = -1
                string.sub(v39, 2)
            end

            if not (v40 > 999 or v41 > 999) then
                local v42 = if v41 == -1 then formatter_settings.MAX_PRECISION else v41

                return table.freeze({
                    type = enums._Internal.PrecisionType.SIGNFICANT,
                    min = v40,
                    max = v42
                })
            end
        end
    end

    return nil
end

local function skeleton_to_int_width(p8) -- line: 451
    if p8 == "integer-width-trunc" then
        return table.freeze({
            min = 0,
            max = 0
        })
    end

    local v43 = string.match(p8, "^integer%-width/[%*%+](0*)$")

    if v43 then
        if #v43 > 999 then
            return nil
        end

        return table.freeze({
            max = -1,
            min = #v43
        })
    end

    local v44, v45 = string.match(p8, "^integer%-width/(#*(0*))$")

    if v44 and v44 ~= "" and not (#v44 > 999) and not (#v45 > 999) then
        return table.freeze({
            min = #v45,
            max = #v44
        })
    end

    return nil
end

local function skeleton_to_int_width_concise(p9) -- line: 481
    return if string.match(p9, "^0+$") and #p9 < 1000 then table.freeze({
        max = -1,
        min = #p9
    }) else nil
end

function t1.to_option_linked_list(p10) -- line: 490
    -- upvalues: t7 (copy), t8 (copy), skeleton_to_scientific_notation (copy), skeleton_to_scientific_notation_concise (copy), skeleton_to_precision (copy), skeleton_to_int_width (copy), skeleton_to_int_width_concise (copy)
    local t12 = {}
    local t13

    for match, v46 in string.gmatch(p10, "()(%S+)") do
        local v47 = t7[v46]
        local v48 = if v47 then t8[v46] else nil

        if not v48 then
            v48 = skeleton_to_scientific_notation(v46) or skeleton_to_scientific_notation_concise(v46)

            if v48 then
                v47 = "notation"
            end
        end

        if not v48 then
            v48 = skeleton_to_precision(v46)

            if v48 then
                v47 = "precision"
            end
        end

        if not v48 then
            v48 = skeleton_to_int_width(v46) or skeleton_to_int_width_concise(v46)

            if v48 then
                v47 = "integerWidth"
            end
        end

        if not v47 or t12[v47] then
            return false, string.format("number skeleton syntax error near '%*' at position %d", string.gsub(v46, "'", "\\'"), match)
        end

        t12[v47] = true
        t13 = {
            key = v47,
            value = v48,
            parent = t13
        }
    end

    return true, t13
end

return t1

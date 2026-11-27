-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TextService = game:GetService("TextService")
local t1 = {
    MakeDictionary = function(p1) -- MakeDictionary | line: 5
        local t2 = {}

        for i = 1, #p1 do
            t2[p1[i]] = true
        end

        return t2
    end,
    DictionaryKeys = function(p2) -- DictionaryKeys | line: 15
        local t3 = {}

        for v1 in pairs(p2) do
            table.insert(t3, v1)
        end

        return t3
    end
}

local function transformInstanceSet(p3) -- line: 25
    local t4 = {}

    for i = 1, #p3 do
        t4[i] = p3[i].Name
    end

    return t4, p3
end

function t1.MakeFuzzyFinder(p4) -- line: 35
    local v2
    local v3 = {}
    local v4 = if typeof(p4) == "Enum" then p4:GetEnumItems() else p4

    if typeof(v4) == "Instance" then
        local Children = v4:GetChildren()
        local t5 = {}

        for i = 1, #Children do
            t5[i] = Children[i].Name
        end

        v2 = t5
        v3 = Children
    elseif typeof(v4) == "table" then
        local v5 = v4[1]

        if typeof(v5) ~= "Instance" and typeof(v4[1]) ~= "EnumItem" and (typeof(v4[1]) ~= "table" or typeof(v4[1].Name) ~= "string") then
            if type(v4[1]) == "string" then
                v2 = v4
            elseif v4[1] ~= nil then
                error("MakeFuzzyFinder only accepts tables of instances or strings.")
            else
                v2 = {}
            end
        else
            local t6 = {}

            for i = 1, #v4 do
                t6[i] = v4[i].Name
            end

            v2 = t6
            v3 = v4
        end
    else
        error("MakeFuzzyFinder only accepts a table, Enum, or Instance.")
    end

    return function(p5, p6) -- line: 62
        -- upvalues: v2 (ref), v3 (ref)
        local t7 = {}

        for v10, v11 in pairs(v2) do
            local v12 = v3 and v3[v10] or v11

            if v11:lower() == p5:lower() then
                if p6 then
                    return v12
                end

                table.insert(t7, 1, v12)
            elseif v11:lower():find(p5:lower(), 1, true) then
                t7[#t7 + 1] = v12
            end
        end

        if p6 then
            return t7[1]
        end

        return t7
    end
end

function t1.GetNames(p7) -- line: 87
    local t8 = {}

    for i = 1, #p7 do
        local Name = p7[i].Name

        if not Name then
            Name = tostring(p7[i])
        end

        t8[i] = Name
    end

    return t8
end

function t1.SplitStringSimple(p8, p9) -- line: 97
    local v14 = if p9 == nil then "%s" else p9
    local t9 = {}
    local n1 = 1

    for match in string.gmatch(p8, "([^" .. v14 .. "]+)") do
        t9[n1] = match
        n1 += 1
    end

    return t9
end

local function charCode(p10) -- line: 110
    return utf8.char((tonumber(p10, 16)))
end

function t1.ParseEscapeSequences(p11) -- line: 114
    -- upvalues: charCode (copy)
    return p11:gsub("\\(.)", {
        t = "\t",
        n = "\n"
    }):gsub("\\u(%x%x%x%x)", charCode):gsub("\\x(%x%x)", charCode)
end

function t1.EncodeEscapedOperator(p12, p13) -- line: 123
    local v15 = p13:sub(1, 1)
    local v16 = p13:gsub(".", "%%%1")

    return p12:gsub("(" .. ("%" .. v15) .. "+)(" .. v16 .. ")", function(p14, p15) -- line: 128
        return (p14:sub(1, #p14 - 1) .. p15):gsub(".", function(p16) -- line: 129
            return "\\u" .. string.format("%04x", string.byte(p16), 16)
        end)
    end)
end

local t10 = { "&&", "||", ";" }

function t1.EncodeEscapedOperators(p17) -- line: 136
    -- upvalues: t1 (copy), t10 (copy)
    for _, v18 in ipairs(t10) do
        p17 = t1.EncodeEscapedOperator(p17, v18)
    end

    return p17
end

local function encodeControlChars(p18) -- line: 144
    return (p18:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___"))
end

local function decodeControlChars(p19) -- line: 154
    return (p19:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n"))
end

function t1.SplitString(p20, p21) -- line: 163
    -- upvalues: t1 (copy)
    local v19 = p20:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___")

    p21 = p21 or 1e999

    local t11 = {}
    local v21, v22

    for match in v19:gmatch("[^ ]+") do
        local v23 = t1.ParseEscapeSequences(match)
        local v24 = v23:match("^(['\"])")
        local v25 = v23:match("(['\"])$")
        local v26 = v23:match("(\\*)['\"]$")

        if not v24 or v22 or v25 then
            if v21 then
                if v25 == v22 and #v26 % 2 == 0 then
                    v23 = v21 .. " " .. v23
                    v21 = nil
                    v22 = nil
                else
                    v21 ..= " " .. v23
                end
            end
        else
            v22 = v24
            v21 = v23
        end

        if not v21 then
            t11[#t11 + (p21 < #t11 and 0 or 1)] = v23:gsub("^(['\"])", ""):gsub("(['\"])$", ""):gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n")
        end
    end

    if v21 then
        t11[#t11 + (p21 < #t11 and 0 or 1)] = v21:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n")
    end

    return t11
end

function t1.MashExcessArguments(p22, p23) -- line: 193
    local t12 = {}

    for i = 1, #p22 do
        if p23 < i then
            t12[p23] = ("%s %s"):format(t12[p23] or "", p22[i])
        else
            t12[i] = p22[i]
        end
    end

    return t12
end

function t1.TrimString(p24) -- line: 205
    local _, v27 = string.find(p24, "^%s*")

    if v27 == #p24 then
        return ""
    end

    return (string.match(p24, ".*%S", v27 + 1))
end

function t1.GetTextSize(p25, p26, p27) -- line: 210
    -- upvalues: TextService (copy)
    return TextService:GetTextSize(p25, p26.TextSize, p26.Font, p27 or Vector2.new(p26.AbsoluteSize.X, 0))
end

function t1.MakeEnumType(p28, p29) -- line: 214
    -- upvalues: t1 (copy)
    local v28 = t1.MakeFuzzyFinder(p29)

    return {
        Validate = function(p30) -- Validate | line: 217
            -- upvalues: p28 (copy), v28 (copy)
            return v28(p30, true) ~= nil, ("Value %q is not a valid %s."):format(p30, p28)
        end,
        Autocomplete = function(p31) -- Autocomplete | line: 220
            -- upvalues: v28 (copy), t1 (copy)
            local v29 = v28(p31)
            local v31 = type(v29[1]) == "string"
            local v32 = if not v31 then t1.GetNames(v29) else nil

            if not v31 and v32 then
                v29 = v32
            end

            return v29
        end,
        Parse = function(p32) -- Parse | line: 224
            -- upvalues: v28 (copy)
            return v28(p32, true)
        end
    }
end

function t1.ParsePrefixedUnionType(p33, p34) -- line: 230
    -- upvalues: t1 (copy)
    local v33 = t1.SplitStringSimple(p33)
    local t14 = {}

    for i = 1, #v33, 2 do
        t14[#t14 + 1] = {
            prefix = v33[i - 1] or "",
            type = v33[i]
        }
    end

    table.sort(t14, function(p35, p36) -- line: 243
        return #p35.prefix > #p36.prefix
    end)

    for i = 1, #t14 do
        local v34 = t14[i]

        if p34:sub(1, #v34.prefix) == v34.prefix then
            return v34.type, p34:sub(#v34.prefix + 1), v34.prefix
        end
    end
end

function t1.MakeListableType(p37, p38) -- line: 257
    local t15 = {
        Listable = true,
        Transform = p37.Transform,
        Validate = p37.Validate,
        ValidateOnce = p37.ValidateOnce,
        Autocomplete = p37.Autocomplete,
        Default = p37.Default,
        ArgumentOperatorAliases = p37.ArgumentOperatorAliases,
        Parse = function(...) -- Parse | line: 266
            -- upvalues: p37 (copy)
            return { p37.Parse(...) }
        end
    }

    if p38 then
        for v35, v36 in pairs(p38) do
            t15[v35] = v36
        end
    end

    return t15
end

local function encodeCommandEscape(p39) -- line: 280
    return (p39:gsub("\\%$", "___!CMDR_DOLLAR!___"))
end

local function decodeCommandEscape(p40) -- line: 284
    return (p40:gsub("___!CMDR_DOLLAR!___", "$"))
end

function t1.RunCommandString(p41, p42) -- line: 288
    -- upvalues: t1 (copy)
    local v37 = t1.ParseEscapeSequences(p42)
    local v38 = t1.EncodeEscapedOperators(v37):split("&&")
    local v39 = ""

    for v40, v41 in ipairs(v38) do
        local v42 = v39:gsub("%$", "\\x24"):gsub("%%", "%%%%")

        if v39:find("%s") then
            v42 = ("%q"):format(v42) or v42
        end

        local v43 = v41:gsub("||", v42)

        v39 = tostring(p41:EvaluateAndRun((t1.RunEmbeddedCommands(p41, v43))))

        if v40 == #v38 then
            return v39
        end
    end
end

function t1.RunEmbeddedCommands(p43, p44) -- line: 313
    -- upvalues: t1 (copy)
    local v45 = p44:gsub("\\%$", "___!CMDR_DOLLAR!___")
    local t16 = {}

    for match in v45:gmatch("$(%b{})") do
        local v46 = match:sub(2, #match - 1)
        local v47

        if v46:match("^{.+}$") then
            v47 = false
            v46 = v46:sub(2, #v46 - 1)
        else
            v47 = true
        end

        t16[match] = t1.RunCommandString(p43, v46)

        if v47 and (t16[match]:find("%s") or t16[match] == "") then
            t16[match] = string.format("%q", t16[match])
        end
    end

    return (v45:gsub("$(%b{})", t16):gsub("___!CMDR_DOLLAR!___", "$"))
end

function t1.SubstituteArgs(p45, p46) -- line: 338
    local v48 = p45:gsub("\\%$", "___!CMDR_DOLLAR!___")

    if type(p46) == "table" then
        for i = 1, #p46 do
            local v49 = tostring(i)

            p46[v49] = p46[i]

            if p46[v49]:find("%s") then
                p46[v49] = string.format("%q", p46[v49])
            end
        end
    end

    return (v48:gsub("($%d+)%b{}", "%1"):gsub("$(%w+)", p46):gsub("___!CMDR_DOLLAR!___", "$"))
end

function t1.MakeAliasCommand(p47, p48) -- line: 353
    -- upvalues: t1 (copy)
    local v50 = p48
    local v51, v52 = unpack(p47:split("|"))
    local t17 = {}
    local v53 = t1.EncodeEscapedOperators(p48)

    v50 = v53

    local t18 = {}

    for match in v53:gmatch("$(%d+)") do
        if t18[match] == nil then
            t18[match] = true

            local v54 = v53:match((("$%*(%%b{})"):format(match)))
            local v55, v56, v57

            if v54 then
                v55, v56, v57 = unpack(v54:sub(2, #v54 - 1):split("|"))
            end

            local v59, v60

            if v55 then
                v59 = not not v55:match("%?$")
                v60 = v55:match("^%w+")
            else
                v59 = v55
                v60 = "string"
            end

            table.insert(t17, {
                Type = v60,
                Name = v56 or ("Argument %*"):format(match),
                Description = v57 or "",
                Optional = v59
            })
        end
    end

    return {
        Group = "UserAlias",
        Name = v51,
        Aliases = {},
        Description = ("<Alias> %*"):format(v52 or v53),
        Args = t17,
        Run = function(p49) -- Run | line: 392
            -- upvalues: v50 (ref), t1 (copy)
            return t1.RunCommandString(p49.Dispatcher, t1.SubstituteArgs(v50, p49.RawArguments))
        end
    }
end

function t1.MakeSequenceType(p50) -- line: 398
    -- upvalues: t1 (copy)
    local v61 = p50

    p50 = p50 or {}
    v61 = p50
    assert(p50.Parse ~= nil or p50.Constructor ~= nil, "MakeSequenceType: Must provide one of: Constructor, Parse")
    p50.TransformEach = p50.TransformEach or function(...) -- line: 403
        return ...
    end
    p50.ValidateEach = p50.ValidateEach or function() -- line: 407
        return true
    end

    return {
        Prefixes = p50.Prefixes,
        Transform = function(p51) -- Transform | line: 414
            -- upvalues: v61 (ref), t1 (copy)
            return t1.Map(t1.SplitPrioritizedDelimeter(p51, { ",", "%s" }), function(p52) -- line: 415
                -- upvalues: v61 (ref)
                return v61.TransformEach(p52)
            end)
        end,
        Validate = function(p53) -- Validate | line: 420
            -- upvalues: v61 (ref)
            if v61.Length and #p53 > v61.Length then
                return false, ("Maximum of %d values allowed in sequence"):format(v61.Length)
            end

            for i = 1, v61.Length or #p53 do
                local v64, v65 = v61.ValidateEach(p53[i], i)

                if not v64 then
                    return false, v65
                end
            end

            return true
        end,
        Parse = v61.Parse or function(p54) -- line: 436
            -- upvalues: v61 (ref)
            return v61.Constructor(unpack(p54))
        end
    }
end

function t1.SplitPrioritizedDelimeter(p55, p56) -- line: 442
    -- upvalues: t1 (copy)
    for v66, v67 in ipairs(p56) do
        if p55:find(v67) or v66 == #p56 then
            return t1.SplitStringSimple(p55, v67)
        end
    end
end

function t1.Map(p57, p58) -- line: 450
    local t21 = {}

    for v68, v69 in ipairs(p57) do
        t21[v68] = p58(v69, v68)
    end

    return t21
end

function t1.Each(p59, ...) -- line: 460
    local t22 = {}

    for v70, v71 in ipairs({ ... }) do
        t22[v70] = p59(v71)
    end

    return unpack(t22)
end

function t1.EmulateTabstops(p60, p61) -- line: 468
    local v72 = #p60
    local v73 = table.create(v72)
    local n2 = 0

    for i = 1, v72 do
        local v74 = string.sub(p60, i, i)

        if v74 == "\t" then
            local v75 = p61 - n2 % p61

            table.insert(v73, string.rep(" ", v75))
            n2 += v75
        else
            table.insert(v73, v74)

            if v74 == "\n" then
                n2 = 0
            elseif v74 ~= "\r" then
                n2 += 1
            end
        end
    end

    return table.concat(v73)
end

function t1.Mutex() -- line: 490
    local t23 = {}
    local v76 = false

    return function() -- line: 494
        -- upvalues: t23 (copy), v76 (ref)
        if not v76 then
            v76 = true

            return function() -- line: 502
                -- upvalues: t23 (copy), v76 (ref)
                if #t23 > 0 then
                    coroutine.resume(table.remove(t23, 1))
                else
                    v76 = false
                end
            end
        end

        table.insert(t23, coroutine.running())
        coroutine.yield()

        return function() -- line: 502
            -- upvalues: t23 (copy), v76 (ref)
            if #t23 > 0 then
                coroutine.resume(table.remove(t23, 1))
            else
                v76 = false
            end
        end
    end
end

return t1

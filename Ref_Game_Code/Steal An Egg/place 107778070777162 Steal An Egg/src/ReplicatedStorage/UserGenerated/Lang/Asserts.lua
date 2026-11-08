-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function IsEqual(p1, p2) -- line: 23
    if rawequal(p1, p2) then
        return true
    end

    return type(p1) == "number" and type(p2) == "number" and p1 ~= p1 and p2 ~= p2
end

local function IsASCII(p3) -- line: 37
    for i = 1, string.len(p3) do
        local v1 = string.byte(p3, i)

        if v1 < 32 or v1 > 126 then
            return false
        end
    end

    return true
end

local function IsFinite(p4) -- line: 49
    if p4 ~= p4 or p4 == 1e999 then
        return false
    end

    return p4 ~= (-1e999)
end

local function IsInteger(p5) -- line: 55
    if math.floor(p5) ~= p5 or p5 == 1e999 then
        return false
    end

    return p5 ~= (-1e999)
end

local function IsCFrameFinite(p6) -- line: 59
    local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p6:GetComponents()
    local v2 = Components + Components2 + Components3 + Components4 + Components5 + Components6 + Components7 + Components8 + Components9 + Components10 + Components11 + Components12

    if v2 ~= v2 or v2 == 1e999 then
        return false
    end

    return v2 ~= (-1e999)
end

local function IsVector2Finite(p7) -- line: 64
    local v3 = p7.X + p7.Y

    if v3 ~= v3 or v3 == 1e999 then
        return false
    end

    return v3 ~= (-1e999)
end

local function IsVector3Finite(p8) -- line: 68
    local v4 = p8.X + p8.Y + p8.Z

    if v4 ~= v4 or v4 == 1e999 then
        return false
    end

    return v4 ~= (-1e999)
end

local function LuaString(p9) -- line: 72
    return (string.format("%q", p9):gsub("\n", "n"))
end

local function StringRep(p10) -- line: 77
    if type(p10) == "string" then
        return (string.format("%q", p10):gsub("\n", "n"))
    end

    if typeof(p10) == "Instance" then
        return p10:GetFullName()
    end

    return (tostring(p10))
end

local function SafeKeyStringRep(p11) -- line: 86
    if type(p11) == "number" or type(p11) == "boolean" then
        return (("%*"):format(p11))
    end

    if type(p11) == "string" then
        local v5 = utf8.len(p11)

        if not v5 then
            return "InvalidUTF8"
        end

        local v7 = false
        local v8

        for i = 1, string.len(p11) do
            local v9 = string.byte(p11, i)

            if v9 < 32 or v9 > 126 then
                v8 = false
                v7 = true
                break
            end
        end

        if not v7 then
            v8 = true
        end

        if not v8 then
            return "NonASCII"
        end

        if not (v5 > 30) then
            return (string.format("%q", p11):gsub("\n", "n"))
        end

        local v10 = string.sub(p11, 1, 30)

        return (("%*...%*"):format(string.format("%q", v10):gsub("\n", "n"), v5 - 30))
    end

    if typeof(p11) == "Instance" then
        return p11:GetFullName()
    end

    return (("UnknownType(%*)"):format((typeof(p11))))
end

local function StripErrorSource(p12) -- line: 107
    local v11 = tostring(p12)
    local v12, v13 = string.match(v11, "^(.*:%d+): (.+)$")

    return v12 and v13 or v11
end

local function ParseError(p13) -- line: 118
    local v14 = tostring(p13)
    local v15, v16 = string.match(v14, "^(.*:%d+): (.+)$")

    if v15 then
        v14 = v16 or v14
    end

    local v17, v18 = string.match(v14, "^(.+) $(%[.+)$")

    if not (v17 and v18) then
        v17 = v14
    end

    return v17, v18
end

local function MakeError(p14, p15) -- line: 130
    return (("%* $%*"):format(p14, p15))
end

local t1 = {
    IsCFrameFinite = IsCFrameFinite,
    IsVector2Finite = IsVector2Finite,
    IsVector3Finite = IsVector3Finite
}

function t1.Array(p16) -- line: 140
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p16)

    return function(p17) -- line: 142
        -- upvalues: p16 (copy), SafeKeyStringRep (copy)
        if type(p17) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p17) ~= nil then
            error("metatable", 2)
        end

        local v19 = rawlen(p17)
        local n1 = 0

        for v20, v21 in pairs(p17) do
            n1 += 1

            if v20 ~= n1 then
                error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v20))))), 2)
            end

            if v19 < n1 then
                error(("IndexOverflow $%*"):format((("[%*]"):format(n1))), 2)
            end

            local ok, result = pcall(p16, v21)

            if not ok then
                local v22 = tostring(result)
                local v23, v24 = string.match(v22, "^(.*:%d+): (.+)$")

                if v23 then
                    v22 = v24 or v22
                end

                local v25, v26 = string.match(v22, "^(.+) $(%[.+)$")

                if not (v25 and v26) then
                    v25 = v22
                end

                error(("%* $%*"):format(v25, (("[%*]%*"):format(n1, v26 or ""))), 2)
            end
        end

        if v19 ~= n1 then
            error("LengthMismatch", 2)
        end

        return p17
    end
end

function t1.ArrayCoerce(p18) -- line: 172
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p18)

    return function(p19) -- line: 174
        -- upvalues: p18 (copy), SafeKeyStringRep (copy)
        if type(p19) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p19) ~= nil then
            error("metatable", 2)
        end

        local v27 = rawlen(p19)
        local t2 = {}
        local n2 = 0

        for v28, v29 in pairs(p19) do
            n2 += 1

            if v28 ~= n2 then
                error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v28))))), 2)
            end

            if v27 < n2 then
                error(("IndexOverflow $%*"):format((("[%*]"):format(n2))), 2)
            end

            local ok, result = pcall(p18, v29)

            if not ok then
                local v30 = tostring(result)
                local v31, v32 = string.match(v30, "^(.*:%d+): (.+)$")

                if v31 then
                    v30 = v32 or v30
                end

                local v33, v34 = string.match(v30, "^(.+) $(%[.+)$")

                if not (v33 and v34) then
                    v33 = v30
                end

                error(("%* $%*"):format(v33, (("[%*]%*"):format(n2, v34 or ""))), 2)
            end

            t2[v28] = result
        end

        if v27 ~= n2 then
            error("LengthMismatch", 2)
        end

        return t2
    end
end

function t1.UniqueArray(p20) -- line: 206
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p20)

    return function(p21) -- line: 208
        -- upvalues: p20 (copy), SafeKeyStringRep (copy)
        if type(p21) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p21) ~= nil then
            error("metatable", 2)
        end

        local t3 = {}
        local v35 = rawlen(p21)
        local n3 = 0

        for v36, v37 in pairs(p21) do
            n3 += 1

            if v36 ~= n3 then
                error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v36))))), 2)
            end

            if v35 < n3 then
                error(("IndexOverflow $%*"):format((("[%*]"):format(n3))), 2)
            end

            if t3[v37] then
                error(("UniqueArray $%*"):format((("[%*]"):format(n3))), 2)
            end

            t3[v37] = true

            if not t3[v37] then
                error(("InvalidKey $%*"):format((("[%*]"):format(n3))), 2)
            end

            local ok, result = pcall(p20, v37)

            if not ok then
                local v38 = tostring(result)
                local v39, v40 = string.match(v38, "^(.*:%d+): (.+)$")

                if v39 then
                    v38 = v40 or v38
                end

                local v41, v42 = string.match(v38, "^(.+) $(%[.+)$")

                if not (v41 and v42) then
                    v41 = v38
                end

                error(("%* $%*"):format(v41, (("[%*]%*"):format(n3, v42 or ""))), 2)
            end
        end

        if v35 ~= n3 then
            error("LengthMismatch", 2)
        end

        return p21
    end
end

function t1.UniqueArrayCoerce(p22) -- line: 246
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p22)

    return function(p23) -- line: 248
        -- upvalues: p22 (copy), SafeKeyStringRep (copy)
        if type(p23) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p23) ~= nil then
            error("metatable", 2)
        end

        local t4 = {}
        local v43 = rawlen(p23)
        local t5 = {}
        local n4 = 0

        for v44, v45 in pairs(p23) do
            n4 += 1

            if v44 ~= n4 then
                error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v44))))), 2)
            end

            if v43 < n4 then
                error(("IndexOverflow $%*"):format((("[%*]"):format(n4))), 2)
            end

            if t4[v45] then
                error(("UniqueArray $%*"):format((("[%*]"):format(n4))), 2)
            end

            t4[v45] = true

            if not t4[v45] then
                error(("InvalidKey $%*"):format((("[%*]"):format(n4))), 2)
            end

            local ok, result = pcall(p22, v45)

            if not ok then
                local v46 = tostring(result)
                local v47, v48 = string.match(v46, "^(.*:%d+): (.+)$")

                if v47 then
                    v46 = v48 or v46
                end

                local v49, v50 = string.match(v46, "^(.+) $(%[.+)$")

                if not (v49 and v50) then
                    v49 = v46
                end

                error(("%* $%*"):format(v49, (("[%*]%*"):format(n4, v50 or ""))), 2)
            end

            t5[v44] = result
        end

        if v43 ~= n4 then
            error("LengthMismatch", 2)
        end

        return t5
    end
end

function t1.Map(p24, p25, p26) -- line: 289
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p24)
    t1.Function(p25)
    t1.Optional(t1.IntegerPositive)(p26)

    local v51 = p26 or 1e999

    return function(p27) -- line: 295
        -- upvalues: p24 (copy), p25 (copy), v51 (copy), SafeKeyStringRep (copy)
        if type(p27) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p27) ~= nil then
            error("metatable", 2)
        end

        local n5 = 0

        for v52, v53 in pairs(p27) do
            n5 += 1

            if v51 < n5 then
                error(("LengthLimit(%*)"):format(v51), 2)
            end

            local ok, result = pcall(p24, v52)

            if not ok then
                local v54 = tostring(result)
                local v55, v56 = string.match(v54, "^(.*:%d+): (.+)$")

                if v55 then
                    v54 = v56 or v54
                end

                local v57, v58 = string.match(v54, "^(.+) $(%[.+)$")

                if not (v57 and v58) then
                    v57 = v54
                end

                error(("%* $%*"):format(v57, (("<%*>%*"):format(SafeKeyStringRep(v52), v58 or ""))), 2)
            end

            local ok2, result2 = pcall(p25, v53)

            if not ok2 then
                local v59 = tostring(result2)
                local v60, v61 = string.match(v59, "^(.*:%d+): (.+)$")

                if v60 then
                    v59 = v61 or v59
                end

                local v62, v63 = string.match(v59, "^(.+) $(%[.+)$")

                if not (v62 and v63) then
                    v62 = v59
                end

                error(("%* $%*"):format(v62, (("[%*]%*"):format(SafeKeyStringRep(v52), v63 or ""))), 2)
            end
        end

        return p27
    end
end

function t1.MapCoerce(p28, p29, p30) -- line: 324
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    t1.Function(p28)
    t1.Function(p29)
    t1.Optional(t1.IntegerPositive)(p30)

    local v64 = p30 or 1e999

    return function(p31) -- line: 334
        -- upvalues: p28 (copy), p29 (copy), v64 (copy), SafeKeyStringRep (copy)
        if type(p31) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p31) ~= nil then
            error("metatable", 2)
        end

        local t6 = {}
        local n6 = 0

        for v65, v66 in pairs(p31) do
            n6 += 1

            if v64 < n6 then
                error(("LengthLimit(%*)"):format(v64), 2)
            end

            local ok, result = pcall(p28, v65)

            if not ok then
                local v67 = tostring(result)
                local v68, v69 = string.match(v67, "^(.*:%d+): (.+)$")

                if v68 then
                    v67 = v69 or v67
                end

                local v70, v71 = string.match(v67, "^(.+) $(%[.+)$")

                if not (v70 and v71) then
                    v70 = v67
                end

                error(("%* $%*"):format(v70, (("<%*>%*"):format(SafeKeyStringRep(v65), v71 or ""))), 2)
            end

            local ok2, result2 = pcall(p29, v66)

            if not ok2 then
                local v72 = tostring(result2)
                local v73, v74 = string.match(v72, "^(.*:%d+): (.+)$")

                if v73 then
                    v72 = v74 or v72
                end

                local v75, v76 = string.match(v72, "^(.+) $(%[.+)$")

                if not (v75 and v76) then
                    v75 = v72
                end

                error(("%* $%*"):format(v75, (("[%*]%*"):format(SafeKeyStringRep(v65), v76 or ""))), 2)
            end

            t6[result] = result2
        end

        return t6
    end
end

function t1.Table(p32) -- line: 365
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    local v77 = p32

    t1.NoMetatable(p32)

    for _, v78 in pairs(p32) do
        t1.Function(v78)
    end

    v77 = table.clone(p32)

    return function(p33) -- line: 372
        -- upvalues: v77 (ref), SafeKeyStringRep (copy)
        if type(p33) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p33) ~= nil then
            error("metatable", 2)
        end

        if rawlen(v77) ~= rawlen(p33) then
            error("LengthMismatch", 2)
        end

        for v80, _ in pairs(p33) do
            if not v77[v80] then
                error(("UnknownKey $%*"):format((("[%*]"):format((SafeKeyStringRep(v80))))), 2)
            end
        end

        for v81, v82 in pairs(v77) do
            local v83 = p33[v81]
            local ok, result = pcall(v82, v83)

            if not ok then
                local v84 = tostring(result)
                local v85, v86 = string.match(v84, "^(.*:%d+): (.+)$")

                if v85 then
                    v84 = v86 or v84
                end

                local v87, v88 = string.match(v84, "^(.+) $(%[.+)$")

                if not (v87 and v88) then
                    v87 = v84
                end

                error(("%* $%*"):format(v87, (("[%*]%*"):format(if type(v81) == "string" then string.format("%q", v81):gsub("\n", "n") elseif typeof(v81) == "Instance" then v81:GetFullName() else tostring(v81), v88 or ""))), 2)
            end
        end

        return p33
    end
end

function t1.TablePermissive(p34) -- line: 399
    -- upvalues: t1 (copy)
    local v89 = p34

    t1.NoMetatable(p34)

    for _, v90 in pairs(p34) do
        t1.Function(v90)
    end

    v89 = table.clone(p34)

    return function(p35) -- line: 406
        -- upvalues: v89 (ref)
        if type(p35) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p35) ~= nil then
            error("metatable", 2)
        end

        if rawlen(v89) ~= rawlen(p35) then
            error("LengthMismatch", 2)
        end

        for v92, v93 in pairs(v89) do
            local v94 = p35[v92]
            local ok, result = pcall(v93, v94)

            if not ok then
                local v95 = tostring(result)
                local v96, v97 = string.match(v95, "^(.*:%d+): (.+)$")

                if v96 then
                    v95 = v97 or v95
                end

                local v98, v99 = string.match(v95, "^(.+) $(%[.+)$")

                if not (v98 and v99) then
                    v98 = v95
                end

                error(("%* $%*"):format(v98, (("[%*]%*"):format(if type(v92) == "string" then string.format("%q", v92):gsub("\n", "n") elseif typeof(v92) == "Instance" then v92:GetFullName() else tostring(v92), v99 or ""))), 2)
            end
        end

        return p35
    end
end

function t1.TableCoerce(p36) -- line: 434
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    local v100 = p36

    t1.NoMetatable(p36)

    for _, v101 in pairs(p36) do
        t1.Function(v101)
    end

    v100 = table.clone(p36)

    return function(p37) -- line: 441
        -- upvalues: v100 (ref), SafeKeyStringRep (copy)
        if type(p37) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p37) ~= nil then
            error("metatable", 2)
        end

        if rawlen(v100) ~= rawlen(p37) then
            error("LengthMismatch", 2)
        end

        local t7 = {}

        for v103, _ in pairs(p37) do
            if not v100[v103] then
                error(("UnknownKey $%*"):format((("[%*]"):format((SafeKeyStringRep(v103))))), 2)
            end
        end

        for v104, v105 in pairs(v100) do
            local v106 = p37[v104]
            local ok, result = pcall(v105, v106)

            if not ok then
                local v107 = tostring(result)
                local v108, v109 = string.match(v107, "^(.*:%d+): (.+)$")

                if v108 then
                    v107 = v109 or v107
                end

                local v110, v111 = string.match(v107, "^(.+) $(%[.+)$")

                if not (v110 and v111) then
                    v110 = v107
                end

                error(("%* $%*"):format(v110, (("[%*]%*"):format(if type(v104) == "string" then string.format("%q", v104):gsub("\n", "n") elseif typeof(v104) == "Instance" then v104:GetFullName() else tostring(v104), v111 or ""))), 2)
            end

            t7[v104] = result
        end

        return t7
    end
end

function t1.IsASCII(p38) -- line: 470
    if type(p38) ~= "string" then
        return false
    end

    for i = 1, string.len(p38) do
        local v112 = string.byte(p38, i)

        if v112 < 32 or v112 > 126 then
            return false
        end
    end

    return true
end

function t1.IsFinite(p39) -- line: 473
    if type(p39) ~= "number" or p39 ~= p39 or p39 == 1e999 then
        return false
    end

    return p39 ~= (-1e999)
end

function t1.IsInteger(p40) -- line: 476
    if type(p40) ~= "number" or math.floor(p40) ~= p40 or p40 == 1e999 then
        return false
    end

    return p40 ~= (-1e999)
end

function t1.IsCFrameFinite(p41) -- line: 479
    if typeof(p41) ~= "CFrame" then
        return false
    end

    local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p41:GetComponents()
    local v113 = Components + Components2 + Components3 + Components4 + Components5 + Components6 + Components7 + Components8 + Components9 + Components10 + Components11 + Components12

    if v113 ~= v113 or v113 == 1e999 then
        return false
    end

    return v113 ~= (-1e999)
end

function t1.IsVector2Finite(p42) -- line: 482
    if typeof(p42) ~= "Vector2" then
        return false
    end

    local v114 = p42.X + p42.Y

    if v114 ~= v114 or v114 == 1e999 then
        return false
    end

    return v114 ~= (-1e999)
end

function t1.Optional(p43) -- line: 486
    if type(p43) ~= "function" then
        error("function", 2)
    end

    return function(p44) -- line: 490
        -- upvalues: p43 (copy)
        if p44 == nil then
            return nil
        end

        local ok, result = pcall(p43, p44)

        if not ok then
            local _error = error
            local v115 = tostring(result)
            local v116, v117 = string.match(v115, "^(.*:%d+): (.+)$")

            _error(v116 and v117 or v115, 2)
        end

        return result
    end
end

function t1.Default(p45, p46) -- line: 502
    if type(p45) ~= "function" then
        error("function", 2)
    end

    local v118 = p45(p46)

    return function(p47) -- line: 507
        -- upvalues: p45 (copy), v118 (copy)
        if p47 == nil then
            return v118
        end

        local ok, result = pcall(p45, p47)

        if not ok then
            local _error = error
            local v119 = tostring(result)
            local v120, v121 = string.match(v119, "^(.*:%d+): (.+)$")

            _error(v120 and v121 or v119, 2)
        end

        return result
    end
end

function t1.AnyOf(...) -- line: 519
    local v122 = table.pack(...)

    for i = 1, v122.n do
        assert(type(v122[i]) == "function", "function")
    end

    assert(v122.n > 0)

    return function(p48) -- line: 525
        -- upvalues: v122 (copy)
        for i = 1, v122.n do
            local v126 = v122[i]
            local ok, result = pcall(v126, p48)

            if ok then
                return result
            end
        end

        error("AnyOf", 2)
    end
end

function t1.AllOf(...) -- line: 536
    local v127 = table.pack(...)

    for i = 1, v127.n do
        assert(type(v127[i]) == "function", "function")
    end

    assert(v127.n > 0)

    return function(p49) -- line: 542
        -- upvalues: v127 (copy)
        for i = 1, v127.n do
            local v131 = v127[i]
            local ok, result = pcall(v131, p49)

            if not ok then
                local _error = error
                local v132 = tostring(result)
                local v133, v134 = string.match(v132, "^(.*:%d+): (.+)$")

                _error(v133 and v134 or v132, 2)
            end
        end

        return p49
    end
end

function t1.AnyTable(p50) -- line: 554
    if type(p50) ~= "table" then
        error("table", 2)
    end

    return p50
end

function t1.Number(p51) -- line: 560
    if type(p51) ~= "number" then
        error("number", 2)
    end

    return p51
end

function t1.Boolean(p52) -- line: 566
    if type(p52) ~= "boolean" then
        error("boolean", 2)
    end

    return p52
end

function t1.Buffer(p53) -- line: 572
    if type(p53) ~= "buffer" then
        error("buffer", 2)
    end

    return p53
end

function t1.Function(p54) -- line: 578
    if type(p54) ~= "function" then
        error("function", 2)
    end

    return p54
end

function t1.Thread(p55) -- line: 584
    if type(p55) ~= "thread" then
        error("thread", 2)
    end

    return p55
end

function t1.String(p56) -- line: 591
    if type(p56) ~= "string" then
        error("string", 2)
    end

    if not utf8.len(p56) then
        error("UTF8", 2)
    end

    return p56
end

function t1.RawString(p57) -- line: 601
    if type(p57) ~= "string" then
        error("string", 2)
    end

    return p57
end

function t1.Any(p58) -- line: 608
    return p58
end

function t1.Equals(p59) -- line: 612
    return function(p60) -- line: 613
        -- upvalues: p59 (copy)
        if not rawequal(p60, p59) and not (type(p60) == "number" and type(p59) == "number" and p60 ~= p60 and p59 ~= p59) then
            error("Equals", 2)
        end

        return p60
    end
end

function t1.Set(p61) -- line: 621
    -- upvalues: t1 (copy)
    t1.Array(t1.Any)

    local t8 = {}

    for _, v135 in ipairs(p61) do
        if v135 ~= v135 then
            error("InvalidKeyNaN", 2)
        end

        t8[v135] = true

        if not t8[v135] then
            error("InvalidKey", 2)
        end
    end

    return function(p62) -- line: 633
        -- upvalues: t8 (copy)
        if not t8[p62] then
            error("Set", 2)
        end

        return p62
    end
end

function t1.Pattern(p63) -- line: 641
    -- upvalues: t1 (copy)
    t1.String(p63)

    return function(p64) -- line: 643
        -- upvalues: p63 (copy)
        if type(p64) ~= "string" then
            error("string", 2)
        end

        if not utf8.len(p64) then
            error("UTF8", 2)
        end

        if not string.find(p64, p63) then
            error("Pattern", 2)
        end

        return p64
    end
end

function t1.NoMetatable(p65) -- line: 657
    if type(p65) ~= "table" then
        error("table", 2)
    end

    if getmetatable(p65) ~= nil then
        error("metatable", 2)
    end

    return p65
end

function t1.Finite(p66) -- line: 668
    if type(p66) ~= "number" then
        error("number", 2)
    end

    if p66 ~= p66 or p66 == 1e999 or p66 == (-1e999) then
        error("Finite", 2)
    end

    return p66
end

function t1.FinitePositive(p67) -- line: 679
    if type(p67) ~= "number" then
        error("number", 2)
    end

    if p67 ~= p67 or p67 == 1e999 or p67 == (-1e999) then
        error("Finite", 2)
    end

    if not (p67 > 0) then
        error("Positive", 2)
    end

    return p67
end

function t1.FiniteNonNegative(p68) -- line: 693
    if type(p68) ~= "number" then
        error("number", 2)
    end

    if p68 ~= p68 or p68 == 1e999 or p68 == (-1e999) then
        error("Finite", 2)
    end

    if not (p68 >= 0) then
        error("NonNegative", 2)
    end

    return p68
end

function t1.Positive(p69) -- line: 707
    if type(p69) ~= "number" then
        error("number", 2)
    end

    if not (p69 > 0) then
        error("Positive", 2)
    end

    return p69
end

function t1.NonNegative(p70) -- line: 718
    if type(p70) ~= "number" then
        error("number", 2)
    end

    if not (p70 >= 0) then
        error("NonNegative", 2)
    end

    return p70
end

function t1.Real(p71) -- line: 729
    if type(p71) ~= "number" then
        error("number", 2)
    end

    if p71 ~= p71 then
        error("Real", 2)
    end

    return p71
end

function t1.Range(p72, p73) -- line: 740
    -- upvalues: t1 (copy)
    t1.Real(p72)
    t1.Real(p73)

    if not (p72 <= p73) then
        error("a<=b", 2)
    end

    return function(p74) -- line: 746
        -- upvalues: p72 (copy), p73 (copy)
        if type(p74) ~= "number" then
            error("number", 2)
        end

        if not (p72 <= p74 and p74 <= p73) then
            error(("Range(%*,%*)"):format(p72, p73), 2)
        end

        return p74
    end
end

function t1.Integer(p75) -- line: 758
    if type(p75) ~= "number" then
        error("number", 2)
    end

    if math.floor(p75) ~= p75 or p75 == 1e999 or p75 == (-1e999) then
        error("Integer", 2)
    end

    return p75
end

function t1.Unsigned32(p76) -- line: 769
    if bit32.bor(p76, 0) ~= p76 then
        error("Unsigned32", 2)
    end

    return p76
end

function t1.IntegerPositive(p77) -- line: 778
    if type(p77) ~= "number" then
        error("number", 2)
    end

    if math.floor(p77) ~= p77 or p77 == 1e999 or p77 == (-1e999) then
        error("Integer", 2)
    end

    if not (p77 >= 1) then
        error("Positive", 2)
    end

    return p77
end

function t1.Index(p78) -- line: 792
    if type(p78) ~= "number" then
        error("number", 2)
    end

    if math.floor(p78) ~= p78 or p78 == 1e999 or p78 == (-1e999) then
        error("Integer", 2)
    end

    if not (p78 >= 1) then
        error("Positive", 2)
    end

    return p78
end

function t1.IntegerNonNegative(p79) -- line: 806
    if type(p79) ~= "number" then
        error("number", 2)
    end

    if math.floor(p79) ~= p79 or p79 == 1e999 or p79 == (-1e999) then
        error("Integer", 2)
    end

    if not (p79 >= 0) then
        error("NonNegative", 2)
    end

    return p79
end

function t1.IntegerRange(p80, p81) -- line: 820
    -- upvalues: t1 (copy)
    t1.Integer(p80)
    t1.Integer(p81)

    if not (p80 <= p81) then
        error("a<=b", 2)
    end

    return function(p82) -- line: 826
        -- upvalues: p80 (copy), p81 (copy)
        if type(p82) ~= "number" then
            error("number", 2)
        end

        if math.floor(p82) ~= p82 or p82 == 1e999 or p82 == (-1e999) then
            error("Integer", 2)
        end

        if not (p80 <= p82 and p82 <= p81) then
            error(("Range(%*,%*)"):format(p80, p81), 2)
        end

        return p82
    end
end

function t1.UInt32() -- line: 840
    return function(p83) -- line: 841
        if type(p83) ~= "number" then
            error("number", 2)
        end

        if bit32.bor(p83, 0) ~= p83 then
            error("UInt32", 2)
        end

        return p83
    end
end

function t1.StringRange(p84, p85) -- line: 853
    -- upvalues: t1 (copy)
    t1.Integer(p84)
    t1.Integer(p85)

    if not (p84 <= p85) then
        error("a<=b", 2)
    end

    return function(p86) -- line: 859
        -- upvalues: p84 (copy), p85 (copy)
        if type(p86) ~= "string" then
            error("string", 2)
        end

        local v136 = utf8.len(p86)

        if not v136 then
            error("UTF8", 2)
        end

        if not (p84 <= v136 and v136 <= p85) then
            error(("StringRange(%*,%*)"):format(p84, p85), 2)
        end

        return p86
    end
end

function t1.ASCII(p87) -- line: 874
    if type(p87) ~= "string" then
        error("string", 2)
    end

    for i = 1, string.len(p87) do
        local v137 = string.byte(p87, i)

        if v137 < 32 or v137 > 126 then
            error("ASCII", 2)
        end
    end

    return p87
end

function t1.ASCIIRange(p88, p89) -- line: 888
    -- upvalues: t1 (copy)
    t1.Integer(p88)
    t1.Integer(p89)

    if not (p88 <= p89) then
        error("a<=b", 2)
    end

    return function(p90) -- line: 894
        -- upvalues: p88 (copy), p89 (copy)
        if type(p90) ~= "string" then
            error("string", 2)
        end

        local v138 = string.len(p90)

        if not (p88 <= v138 and v138 <= p89) then
            error(("ASCIIRange(%*,%*)"):format(p88, p89), 2)
        end

        for i = 1, v138 do
            local v139 = string.byte(p90, i)

            if v139 < 32 or v139 > 126 then
                error("ASCII", 2)
            end
        end

        return p90
    end
end

function t1.CFrame(p91) -- line: 912
    if typeof(p91) ~= "CFrame" then
        error("CFrame", 2)
    end

    return p91
end

function t1.CFrameFinite(p92) -- line: 918
    if typeof(p92) ~= "CFrame" then
        error("CFrame", 2)
    end

    local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p92:GetComponents()
    local v140 = Components + Components2 + Components3 + Components4 + Components5 + Components6 + Components7 + Components8 + Components9 + Components10 + Components11 + Components12

    if v140 ~= v140 or v140 == 1e999 or v140 == (-1e999) then
        error("CFrameFinite", 2)
    end

    return p92
end

function t1.Vector2(p93) -- line: 927
    if typeof(p93) ~= "Vector2" then
        error("Vector2", 2)
    end

    return p93
end

function t1.Vector2Finite(p94) -- line: 933
    if typeof(p94) ~= "Vector2" then
        error("Vector2", 2)
    end

    local v141 = p94.X + p94.Y

    if v141 ~= v141 or v141 == 1e999 or v141 == (-1e999) then
        error("Vector2Finite", 2)
    end

    return p94
end

function t1.Vector2Unit(p95) -- line: 942
    if typeof(p95) ~= "Vector2" then
        error("Vector2", 2)
    end

    local v142 = p95.X + p95.Y

    if v142 ~= v142 or v142 == 1e999 or v142 == (-1e999) then
        error("Vector2Finite", 2)
    end

    if math.abs(p95.Magnitude - 1) > 1E-06 then
        error("Vector2Unit", 2)
    end

    return p95
end

function t1.Vector3(p96) -- line: 954
    if typeof(p96) ~= "Vector3" then
        error("Vector3", 2)
    end

    return p96
end

function t1.Vector3Finite(p97) -- line: 960
    if typeof(p97) ~= "Vector3" then
        error("Vector3", 2)
    end

    local v144 = p97.X + p97.Y + p97.Z

    if v144 ~= v144 or v144 == 1e999 or v144 == (-1e999) then
        error("Vector3Finite", 2)
    end

    return p97
end

function t1.Vector3Unit(p98) -- line: 969
    if typeof(p98) ~= "Vector3" then
        error("Vector3", 2)
    end

    local v145 = p98.X + p98.Y + p98.Z

    if v145 ~= v145 or v145 == 1e999 or v145 == (-1e999) then
        error("Vector3Finite", 2)
    end

    if math.abs(p98.Magnitude - 1) > 1E-06 then
        error("Vector3Unit", 2)
    end

    return p98
end

function t1.Vector3Positive(p99) -- line: 981
    if typeof(p99) ~= "Vector3" then
        error("Vector3", 2)
    end

    local v147 = p99.X + p99.Y + p99.Z

    if v147 ~= v147 or v147 == 1e999 or v147 == (-1e999) then
        error("Vector3Finite", 2)
    end

    if p99.X <= 0 or p99.Y <= 0 or p99.Z <= 0 then
        error("Vector3Positive")
    end

    return p99
end

function t1.Vector3int16(p100) -- line: 993
    if typeof(p100) ~= "Vector3int16" then
        error("Vector3int16", 2)
    end

    return p100
end

function t1.Vector2int16(p101) -- line: 999
    if typeof(p101) ~= "Vector2int16" then
        error("Vector2int16", 2)
    end

    return p101
end

function t1.Region3(p102) -- line: 1005
    if typeof(p102) ~= "Region3" then
        error("Region3", 2)
    end

    return p102
end

function t1.Region3int16(p103) -- line: 1011
    if typeof(p103) ~= "Region3int16" then
        error("Region3int16", 2)
    end

    return p103
end

function t1.UDim(p104) -- line: 1017
    if typeof(p104) ~= "UDim" then
        error("UDim", 2)
    end

    return p104
end

function t1.UDim2(p105) -- line: 1023
    if typeof(p105) ~= "UDim2" then
        error("UDim2", 2)
    end

    return p105
end

function t1.Rect(p106) -- line: 1029
    if typeof(p106) ~= "Rect" then
        error("Rect", 2)
    end

    return p106
end

function t1.PhysicalProperties(p107) -- line: 1035
    if typeof(p107) ~= "PhysicalProperties" then
        error("PhysicalProperties", 2)
    end

    return p107
end

function t1.Storable(p108, p109) -- line: 1044
    -- upvalues: SafeKeyStringRep (copy), t1 (copy)
    if type(p108) == "boolean" or type(p108) == "number" then
        return p108
    end

    if type(p108) == "string" then
        if not utf8.len(p108) then
            error("UTF8", 2)

            return p108
        end
    else
        if type(p108) == "buffer" then
            return p108
        end

        if type(p108) == "table" then
            if type(p108) ~= "table" then
                error("table", 2)
            end

            if getmetatable(p108) ~= nil then
                error("metatable", 2)
            end

            local v148 = p109 or {}

            if v148[p108] then
                error("Loop", 2)
            end

            v148[p108] = true

            local v149 = rawlen(p108)

            if not (v149 > 0) then
                for v150, v151 in pairs(p108) do
                    if type(v150) ~= "string" then
                        error(("KeyString $%*"):format((("[%*]"):format((SafeKeyStringRep(v150))))), 2)
                    end

                    if not utf8.len(v150) then
                        error(("KeyUTF8 $%*"):format((("[%*]"):format((SafeKeyStringRep(v150))))), 2)
                    end

                    local Storable = t1.Storable
                    local ok, result = pcall(Storable, v151, v148)

                    if not ok then
                        local v152 = tostring(result)
                        local v153, v154 = string.match(v152, "^(.*:%d+): (.+)$")

                        if v153 then
                            v152 = v154 or v152
                        end

                        local v155, v156 = string.match(v152, "^(.+) $(%[.+)$")

                        if not (v155 and v156) then
                            v155 = v152
                        end

                        error(("%* $%*"):format(v155, (("[%*]%*"):format(SafeKeyStringRep(v150), v156 or ""))), 2)
                    end
                end

                return p108
            end

            local n7 = 0

            for v157, v158 in pairs(p108) do
                n7 += 1

                if v157 ~= n7 then
                    error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v157))))), 2)
                end

                if v149 < n7 then
                    error(("IndexOverflow $%*"):format((("[%*]"):format(n7))), 2)
                end

                local Storable = t1.Storable
                local ok, result = pcall(Storable, v158, v148)

                if not ok then
                    local v159 = tostring(result)
                    local v160, v161 = string.match(v159, "^(.*:%d+): (.+)$")

                    if v160 then
                        v159 = v161 or v159
                    end

                    local v162, v163 = string.match(v159, "^(.+) $(%[.+)$")

                    if not (v162 and v163) then
                        v162 = v159
                    end

                    error(("%* $%*"):format(v162, (("[%*]%*"):format(n7, v163 or ""))), 2)
                end
            end

            if v149 ~= n7 then
                error("LengthMismatch", 2)

                return p108
            end
        else
            error("Storable", 2)
        end
    end

    return p108
end

local t9 = {
    boolean = true,
    number = true,
    string = true,
    buffer = true,
    Color3 = true,
    Instance = true,
    NumberRange = true,
    Rect = true,
    Region3 = true,
    Region3int16 = true,
    UDim = true,
    UDim2 = true,
    CFrame = true,
    Vector2 = true,
    Vector2int16 = true,
    Vector3 = true,
    Vector3int16 = true,
    EnumItem = true
}

table.freeze(t9)

function t1.Networkable(p110, p111) -- line: 1150
    -- upvalues: SafeKeyStringRep (copy), t1 (copy), t9 (copy)
    if type(p110) == "string" then
        if not utf8.len(p110) then
            error("UTF8", 2)

            return p110
        end
    elseif type(p110) == "table" then
        if type(p110) ~= "table" then
            error("table", 2)
        end

        if getmetatable(p110) ~= nil then
            error("metatable", 2)
        end

        local v164 = p111 or {}

        if v164[p110] then
            error("Loop", 2)
        end

        v164[p110] = true

        local v165 = rawlen(p110)

        if not (v165 > 0) then
            for v166, v167 in pairs(p110) do
                if type(v166) ~= "string" then
                    error(("KeyString $%*"):format((("[%*]"):format((SafeKeyStringRep(v166))))), 2)
                end

                if not utf8.len(v166) then
                    error(("KeyUTF8 $%*"):format((("[%*]"):format((SafeKeyStringRep(v166))))), 2)
                end

                local Networkable = t1.Networkable
                local ok, result = pcall(Networkable, v167, v164)

                if not ok then
                    local v168 = tostring(result)
                    local v169, v170 = string.match(v168, "^(.*:%d+): (.+)$")

                    if v169 then
                        v168 = v170 or v168
                    end

                    local v171, v172 = string.match(v168, "^(.+) $(%[.+)$")

                    if not (v171 and v172) then
                        v171 = v168
                    end

                    error(("%* $%*"):format(v171, (("[%*]%*"):format(SafeKeyStringRep(v166), v172 or ""))), 2)
                end
            end

            return p110
        end

        local n8 = 0

        for v173, v174 in pairs(p110) do
            n8 += 1

            if v173 ~= n8 then
                error(("IndexMismatch $%*"):format((("[%*]"):format((SafeKeyStringRep(v173))))), 2)
            end

            if v165 < n8 then
                error(("IndexOverflow $%*"):format((("[%*]"):format(n8))), 2)
            end

            local Networkable = t1.Networkable
            local ok, result = pcall(Networkable, v174, v164)

            if not ok then
                local v175 = tostring(result)
                local v176, v177 = string.match(v175, "^(.*:%d+): (.+)$")

                if v176 then
                    v175 = v177 or v175
                end

                local v178, v179 = string.match(v175, "^(.+) $(%[.+)$")

                if not (v178 and v179) then
                    v178 = v175
                end

                error(("%* $%*"):format(v178, (("[%*]%*"):format(n8, v179 or ""))), 2)
            end
        end

        if v165 ~= n8 then
            error("LengthMismatch", 2)

            return p110
        end
    elseif not t9[typeof(p110)] then
        error("Networkable", 2)
    end

    return p110
end

function t1.Enum(p112) -- line: 1210
    if typeof(p112) ~= "Enum" then
        error("Enum", 2)
    end

    return function(p113) -- line: 1214
        -- upvalues: p112 (copy)
        if typeof(p113) ~= "EnumItem" then
            error("EnumItem", 2)
        end

        if p113.EnumType ~= p112 then
            error(tostring(p112), 2)
        end

        return p113
    end
end

function t1.EnumValue(p114) -- line: 1225
    if typeof(p114) ~= "Enum" then
        error("Enum", 2)
    end

    local t10 = {}

    for _, v180 in ipairs(p114:GetEnumItems()) do
        t10[v180.Value] = v180
    end

    return function(p115) -- line: 1233
        -- upvalues: t10 (copy)
        if typeof(p115) ~= "number" then
            error("number", 2)
        end

        if not t10[p115] then
            error("EnumValue", 2)
        end

        return p115
    end
end

function t1.Player(p116) -- line: 1244
    if typeof(p116) ~= "Instance" or not p116:IsA("Player") then
        error("Player", 2)
    end

    return p116
end

function t1.BasePart(p117) -- line: 1250
    if typeof(p117) ~= "Instance" or not p117:IsA("BasePart") then
        error("BasePart", 2)
    end

    return p117
end

function t1.Part(p118) -- line: 1256
    if typeof(p118) ~= "Instance" or not p118:IsA("Part") then
        error("Part", 2)
    end

    return p118
end

function t1.MeshPart(p119) -- line: 1262
    if typeof(p119) ~= "Instance" or not p119:IsA("MeshPart") then
        error("MeshPart", 2)
    end

    return p119
end

function t1.Model(p120) -- line: 1268
    if typeof(p120) ~= "Instance" or not p120:IsA("Model") then
        error("Model", 2)
    end

    return p120
end

function t1.Animation(p121) -- line: 1274
    if typeof(p121) ~= "Instance" or not p121:IsA("Animation") then
        error("Animation", 2)
    end

    return p121
end

function t1.Humanoid(p122) -- line: 1280
    if typeof(p122) ~= "Instance" or not p122:IsA("Humanoid") then
        error("Humanoid", 2)
    end

    return p122
end

function t1.ParticleEmitter(p123) -- line: 1286
    if typeof(p123) ~= "Instance" or not p123:IsA("ParticleEmitter") then
        error("ParticleEmitter", 2)
    end

    return p123
end

function t1.Sound(p124) -- line: 1292
    if typeof(p124) ~= "Instance" or not p124:IsA("Sound") then
        error("Sound", 2)
    end

    return p124
end

function t1.Instance(p125) -- line: 1298
    if typeof(p125) ~= "Instance" then
        error("Instance", 2)
    end

    return p125
end

function t1.InstanceOf(p126) -- line: 1306
    -- upvalues: t1 (copy)
    t1.String(p126)

    return function(p127) -- line: 1308
        -- upvalues: p126 (copy)
        if typeof(p127) ~= "Instance" then
            error("Instance", 2)
        end

        if not p127:IsA(p126) then
            error(p126, 2)
        end

        return p127
    end
end

function t1.InstanceClass(p128) -- line: 1319
    -- upvalues: t1 (copy)
    t1.String(p128)

    return function(p129) -- line: 1321
        -- upvalues: p128 (copy)
        if typeof(p129) ~= "Instance" then
            error("Instance", 2)
        end

        if p129.ClassName ~= p128 then
            error(p128, 2)
        end

        return p129
    end
end

function t1.HexLower(p130) -- line: 1332
    if type(p130) ~= "string" then
        error("string", 2)
    end

    for i = 1, string.len(p130) do
        local v181 = string.byte(p130, i)

        if not (v181 >= 48 and v181 <= 57 or v181 >= 97 and v181 <= 102) then
            error("HexLower", 2)
        end
    end

    return p130
end

function t1.HexUpper(p131) -- line: 1346
    if type(p131) ~= "string" then
        error("string", 2)
    end

    for i = 1, string.len(p131) do
        local v182 = string.byte(p131, i)

        if not (v182 >= 48 and v182 <= 57 or v182 >= 65 and v182 <= 70) then
            error("HexUpper", 2)
        end
    end

    return p131
end

function t1.UUIDStripped(p132) -- line: 1360
    if type(p132) ~= "string" then
        error("string", 2)
    end

    local v183 = string.len(p132)

    if v183 ~= 32 then
        error("Length32", 2)
    end

    for i = 1, v183 do
        local v184 = string.byte(p132, i)

        if not (v184 >= 48 and v184 <= 57 or v184 >= 97 and v184 <= 102) then
            error("HexLower", 2)
        end
    end

    return p132
end

function t1.UUID(p133) -- line: 1378
    if type(p133) ~= "string" then
        error("string", 2)
    end

    if string.len(p133) ~= 36 then
        error("Length36", 2)
    end

    if not p133:find("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
        error("UUID", 2)
    end

    return p133
end

function t1.Base64(p134) -- line: 1391
    if type(p134) ~= "string" then
        error("string", 2)
    end

    if string.len(p134) % 4 ~= 0 then
        error("Base64Length", 2)
    end

    if not string.match(p134, "^[A-Za-z0-9+/]*=?=?$") or string.match(p134, "[^=]=+[^=]") then
        error("Base64", 2)
    end

    return p134
end

function t1.ToNumber(p135) -- line: 1404
    return function(p136) -- line: 1405
        -- upvalues: p135 (copy)
        local v185 = tonumber(p136)

        if not v185 then
            error("tonumber", 2)
        end

        local ok, result = pcall(p135, v185)

        if not ok then
            local _error = error
            local v186 = tostring(result)
            local v187, v188 = string.match(v186, "^(.*:%d+): (.+)$")

            _error(v187 and v188 or v186, 2)
        end

        return result
    end
end

function t1.IsoDate(p137) -- line: 1418
    if not DateTime.fromIsoDate(p137) then
        error("IsoDate", 2)
    end

    return p137
end

return table.freeze(t1)

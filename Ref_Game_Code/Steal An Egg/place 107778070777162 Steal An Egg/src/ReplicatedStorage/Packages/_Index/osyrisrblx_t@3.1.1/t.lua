-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    type = function(p1) -- type | line: 7
        return function(p2) -- line: 8
            -- upvalues: p1 (copy)
            local v1 = type(p2)

            if v1 == p1 then
                return true
            end

            return false, string.format("%s expected, got %s", p1, v1)
        end
    end,
    typeof = function(p3) -- typeof | line: 18
        return function(p4) -- line: 19
            -- upvalues: p3 (copy)
            local v2 = typeof(p4)

            if v2 == p3 then
                return true
            end

            return false, string.format("%s expected, got %s", p3, v2)
        end
    end,
    any = function(p5) -- any | line: 36
        if p5 == nil then
            return false, "any expected, got nil"
        end

        return true
    end
}

t1.boolean = t1.typeof("boolean")
t1.buffer = t1.typeof("buffer")
t1.thread = t1.typeof("thread")
t1.callback = t1.typeof("function")
t1["function"] = t1.callback
t1.none = t1.typeof("nil")
t1["nil"] = t1.none
t1.string = t1.typeof("string")
t1.table = t1.typeof("table")
t1.userdata = t1.type("userdata")
t1.vector = t1.type("vector")

function t1.number(p6) -- line: 118
    local v3 = typeof(p6)

    if v3 ~= "number" then
        return false, string.format("number expected, got %s", v3)
    end

    if p6 == p6 then
        return true
    end

    return false, "unexpected NaN value"
end

function t1.nan(p7) -- line: 138
    local v4 = typeof(p7)

    if v4 ~= "number" then
        return false, string.format("number expected, got %s", v4)
    end

    if p7 == p7 then
        return false, "unexpected non-NaN value"
    end

    return true
end

t1.Axes = t1.typeof("Axes")
t1.BrickColor = t1.typeof("BrickColor")
t1.CatalogSearchParams = t1.typeof("CatalogSearchParams")
t1.CFrame = t1.typeof("CFrame")
t1.Color3 = t1.typeof("Color3")
t1.ColorSequence = t1.typeof("ColorSequence")
t1.ColorSequenceKeypoint = t1.typeof("ColorSequenceKeypoint")
t1.DateTime = t1.typeof("DateTime")
t1.DockWidgetPluginGuiInfo = t1.typeof("DockWidgetPluginGuiInfo")
t1.Enum = t1.typeof("Enum")
t1.EnumItem = t1.typeof("EnumItem")
t1.Enums = t1.typeof("Enums")
t1.Faces = t1.typeof("Faces")
t1.FloatCurveKey = t1.typeof("FloatCurveKey")
t1.Font = t1.typeof("Font")
t1.Instance = t1.typeof("Instance")
t1.NumberRange = t1.typeof("NumberRange")
t1.NumberSequence = t1.typeof("NumberSequence")
t1.NumberSequenceKeypoint = t1.typeof("NumberSequenceKeypoint")
t1.OverlapParams = t1.typeof("OverlapParams")
t1.PathWaypoint = t1.typeof("PathWaypoint")
t1.PhysicalProperties = t1.typeof("PhysicalProperties")
t1.Random = t1.typeof("Random")
t1.Ray = t1.typeof("Ray")
t1.RaycastParams = t1.typeof("RaycastParams")
t1.RaycastResult = t1.typeof("RaycastResult")
t1.RBXScriptConnection = t1.typeof("RBXScriptConnection")
t1.RBXScriptSignal = t1.typeof("RBXScriptSignal")
t1.Rect = t1.typeof("Rect")
t1.Region3 = t1.typeof("Region3")
t1.Region3int16 = t1.typeof("Region3int16")
t1.TweenInfo = t1.typeof("TweenInfo")
t1.UDim = t1.typeof("UDim")
t1.UDim2 = t1.typeof("UDim2")
t1.Vector2 = t1.typeof("Vector2")
t1.Vector2int16 = t1.typeof("Vector2int16")
t1.Vector3 = t1.typeof("Vector3")
t1.Vector3int16 = t1.typeof("Vector3int16")

function t1.literal(...) -- line: 426
    -- upvalues: t1 (copy)
    local v5 = select("#", ...)

    if v5 == 1 then
        local v6 = ...

        return function(p8) -- line: 430
            -- upvalues: v6 (copy)
            if p8 == v6 then
                return true
            end

            return false, string.format("expected %s, got %s", tostring(v6), (tostring(p8)))
        end
    end

    local t2 = {}

    for i = 1, v5 do
        local v7 = select(i, ...)

        t2[i] = t1.literal(v7)
    end

    return t1.union(table.unpack(t2, 1, v5))
end

t1.exactly = t1.literal

function t1.keyOf(p9) -- line: 461
    -- upvalues: t1 (copy)
    local t3 = {}
    local n1 = 0

    for v8 in pairs(p9) do
        n1 += 1
        t3[n1] = v8
    end

    return t1.literal(table.unpack(t3, 1, n1))
end

function t1.valueOf(p10) -- line: 479
    -- upvalues: t1 (copy)
    local t4 = {}
    local n2 = 0

    for _, v9 in pairs(p10) do
        n2 += 1
        t4[n2] = v9
    end

    return t1.literal(table.unpack(t4, 1, n2))
end

function t1.integer(p11) -- line: 497
    -- upvalues: t1 (copy)
    local v10, v11 = t1.number(p11)

    if not v10 then
        return false, v11 or ""
    end

    if p11 % 1 == 0 then
        return true
    end

    return false, string.format("integer expected, got %s", p11)
end

function t1.numberMin(p12) -- line: 517
    -- upvalues: t1 (copy)
    return function(p13) -- line: 518
        -- upvalues: p12 (copy), t1 (copy)
        local v12, v13 = t1.number(p13)

        if not v12 then
            return false, v13 or ""
        end

        if p12 <= p13 then
            return true
        end

        return false, string.format("number >= %s expected, got %s", p12, p13)
    end
end

function t1.numberMax(p14) -- line: 539
    -- upvalues: t1 (copy)
    return function(p15) -- line: 540
        -- upvalues: p14 (copy), t1 (copy)
        local v14, v15 = t1.number(p15)

        if not v14 then
            return false, v15
        end

        if p15 <= p14 then
            return true
        end

        return false, string.format("number <= %s expected, got %s", p14, p15)
    end
end

function t1.numberMinExclusive(p16) -- line: 561
    -- upvalues: t1 (copy)
    return function(p17) -- line: 562
        -- upvalues: p16 (copy), t1 (copy)
        local v16, v17 = t1.number(p17)

        if not v16 then
            return false, v17 or ""
        end

        if p16 < p17 then
            return true
        end

        return false, string.format("number > %s expected, got %s", p16, p17)
    end
end

function t1.numberMaxExclusive(p18) -- line: 583
    -- upvalues: t1 (copy)
    return function(p19) -- line: 584
        -- upvalues: p18 (copy), t1 (copy)
        local v18, v19 = t1.number(p19)

        if not v18 then
            return false, v19 or ""
        end

        if p19 < p18 then
            return true
        end

        return false, string.format("number < %s expected, got %s", p18, p19)
    end
end

t1.numberPositive = t1.numberMinExclusive(0)
t1.numberNegative = t1.numberMaxExclusive(0)

function t1.numberConstrained(p20, p21) -- line: 620
    -- upvalues: t1 (copy)
    assert(t1.number(p20))
    assert(t1.number(p21))

    local v20 = t1.numberMin(p20)
    local v21 = t1.numberMax(p21)

    return function(p22) -- line: 626
        -- upvalues: v20 (copy), v21 (copy)
        local v22, v23 = v20(p22)

        if not v22 then
            return false, v23 or ""
        end

        local v24, v25 = v21(p22)

        if v24 then
            return true
        end

        return false, v25 or ""
    end
end

function t1.numberConstrainedExclusive(p23, p24) -- line: 649
    -- upvalues: t1 (copy)
    assert(t1.number(p23))
    assert(t1.number(p24))

    local v26 = t1.numberMinExclusive(p23)
    local v27 = t1.numberMaxExclusive(p24)

    return function(p25) -- line: 655
        -- upvalues: v26 (copy), v27 (copy)
        local v28, v29 = v26(p25)

        if not v28 then
            return false, v29 or ""
        end

        local v30, v31 = v27(p25)

        if v30 then
            return true
        end

        return false, v31 or ""
    end
end

function t1.match(p26) -- line: 677
    -- upvalues: t1 (copy)
    assert(t1.string(p26))

    return function(p27) -- line: 679
        -- upvalues: p26 (copy), t1 (copy)
        local v32, v33 = t1.string(p27)

        if not v32 then
            return false, v33
        end

        if string.match(p27, p26) == nil then
            return false, string.format("%q failed to match pattern %q", p27, p26)
        end

        return true
    end
end

function t1.optional(p28) -- line: 700
    -- upvalues: t1 (copy)
    assert(t1.callback(p28))

    return function(p29) -- line: 702
        -- upvalues: p28 (copy)
        if p29 == nil then
            return true
        end

        local v34, v35 = p28(p29)

        if v34 then
            return true
        end

        return false, string.format("(optional) %s", v35 or "")
    end
end

function t1.except(p30) -- line: 728
    -- upvalues: t1 (copy)
    assert(t1.callback(p30))

    return function(p31) -- line: 730
        -- upvalues: p30 (copy)
        if p30(p31) then
            return false, "(expect) checker to fail, but it succeeded."
        end

        return true
    end
end

function t1.tuple(...) -- line: 747
    local t5 = { ... }

    return function(...) -- line: 749
        -- upvalues: t5 (copy)
        local t6 = { ... }

        for v36, v37 in ipairs(t5) do
            local v38, v39 = v37(t6[v36])

            if v38 == false then
                return false, string.format("Bad tuple index #%s:\n\t%s", v36, v39 or "")
            end
        end

        return true
    end
end

function t1.keys(p32) -- line: 769
    -- upvalues: t1 (copy)
    assert(t1.callback(p32))

    return function(p33) -- line: 771
        -- upvalues: p32 (copy), t1 (copy)
        local v40, v41 = t1.table(p33)

        if v40 == false then
            return false, v41 or ""
        end

        for v42 in pairs(p33) do
            local v43, v44 = p32(v42)

            if v43 == false then
                return false, string.format("bad key %s:\n\t%s", tostring(v42), v44 or "")
            end
        end

        return true
    end
end

function t1.values(p34) -- line: 795
    -- upvalues: t1 (copy)
    assert(t1.callback(p34))

    return function(p35) -- line: 797
        -- upvalues: p34 (copy), t1 (copy)
        local v45, v46 = t1.table(p35)

        if v45 == false then
            return false, v46 or ""
        end

        for v47, v48 in pairs(p35) do
            local v49, v50 = p34(v48)

            if v49 == false then
                return false, string.format("bad value for key %s:\n\t%s", tostring(v47), v50 or "")
            end
        end

        return true
    end
end

function t1.map(p36, p37) -- line: 822
    -- upvalues: t1 (copy)
    assert(t1.callback(p36))
    assert(t1.callback(p37))

    local v51 = t1.keys(p36)
    local v52 = t1.values(p37)

    return function(p38) -- line: 828
        -- upvalues: v51 (copy), v52 (copy)
        local v53, v54 = v51(p38)

        if not v53 then
            return false, v54 or ""
        end

        local v55, v56 = v52(p38)

        if v55 then
            return true
        end

        return false, v56 or ""
    end
end

function t1.set(p39) -- line: 850
    -- upvalues: t1 (copy)
    return t1.map(p39, t1.literal(true))
end

local v57 = t1.keys(t1.integer)

function t1.array(p40) -- line: 863
    -- upvalues: t1 (copy), v57 (copy)
    assert(t1.callback(p40))

    local v58 = t1.values(p40)

    return function(p41) -- line: 867
        -- upvalues: v58 (copy), v57 (copy)
        local v59, v60 = v57(p41)

        if v59 == false then
            return false, string.format("[array] %s", v60 or "")
        end

        local n3 = 0

        for _ in ipairs(p41) do
            n3 += 1
        end

        for v61 in pairs(p41) do
            if v61 < 1 or n3 < v61 then
                return false, string.format("[array] key %s must be sequential", (tostring(v61)))
            end
        end

        local v62, v63 = v58(p41)

        if v62 then
            return true
        end

        return false, string.format("[array] %s", v63 or "")
    end
end

function t1.strictArray(...) -- line: 903
    -- upvalues: t1 (copy), v57 (copy)
    local t7 = { ... }

    assert(t1.array(t1.callback)(t7))

    return function(p42) -- line: 907
        -- upvalues: t7 (copy), v57 (copy)
        local v65, v66 = v57(p42)

        if v65 == false then
            return false, string.format("[strictArray] %s", v66 or "")
        end

        if #t7 < #p42 then
            return false, string.format("[strictArray] Array size exceeds limit of %d", #t7)
        end

        for v67, v68 in pairs(t7) do
            local v69, v70 = v68(p42[v67])

            if not v69 then
                return false, string.format("[strictArray] Array index #%d - %s", v67, v70)
            end
        end

        return true
    end
end

local v71 = t1.array(t1.callback)

function t1.union(...) -- line: 939
    -- upvalues: v71 (copy)
    local t8 = { ... }

    assert(v71(t8))

    return function(p43) -- line: 943
        -- upvalues: t8 (copy)
        for _, v72 in ipairs(t8) do
            if v72(p43) then
                return true
            end
        end

        return false, "bad type for union"
    end
end

t1.some = t1.union

function t1.intersection(...) -- line: 966
    -- upvalues: v71 (copy)
    local t9 = { ... }

    assert(v71(t9))

    return function(p44) -- line: 970
        -- upvalues: t9 (copy)
        for _, v73 in ipairs(t9) do
            local v74, v75 = v73(p44)

            if not v74 then
                return false, v75 or ""
            end
        end

        return true
    end
end

t1.every = t1.intersection

local v76 = t1.map(t1.any, t1.callback)

function t1.interface(p45) -- line: 997
    -- upvalues: t1 (copy), v76 (copy)
    assert(v76(p45))

    return function(p46) -- line: 999
        -- upvalues: p45 (copy), t1 (copy)
        local v77, v78 = t1.table(p46)

        if v77 == false then
            return false, v78 or ""
        end

        for v79, v80 in pairs(p45) do
            local v81, v82 = v80(p46[v79])

            if v81 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(v79), v82 or "")
            end
        end

        return true
    end
end

function t1.strictInterface(p47) -- line: 1023
    -- upvalues: t1 (copy), v76 (copy)
    assert(v76(p47))

    return function(p48) -- line: 1025
        -- upvalues: p47 (copy), t1 (copy)
        local v83, v84 = t1.table(p48)

        if v83 == false then
            return false, v84 or ""
        end

        for v85, v86 in pairs(p47) do
            local v87, v88 = v86(p48[v85])

            if v87 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(v85), v88 or "")
            end
        end

        for v89 in pairs(p48) do
            if not p47[v89] then
                return false, string.format("[interface] unexpected field %q", (tostring(v89)))
            end
        end

        return true
    end
end

function t1.instanceOf(p49, p50) -- line: 1056
    -- upvalues: t1 (copy)
    assert(t1.string(p49))

    local v90 = if p50 ~= nil then t1.children(p50) else nil

    return function(p51) -- line: 1064
        -- upvalues: p49 (copy), v90 (copy), t1 (copy)
        local v91, v92 = t1.Instance(p51)

        if not v91 then
            return false, v92 or ""
        end

        if p51.ClassName ~= p49 then
            return false, string.format("%s expected, got %s", p49, p51.ClassName)
        end

        local v93, v94

        if v90 then
            v93, v94 = v90(p51)
        end

        if not v90 or v93 then
            return true
        end

        return false, v94
    end
end

t1.instance = t1.instanceOf

function t1.instanceIsA(p52, p53) -- line: 1094
    -- upvalues: t1 (copy)
    assert(t1.string(p52))

    local v95 = if p53 ~= nil then t1.children(p53) else nil

    return function(p54) -- line: 1102
        -- upvalues: p52 (copy), v95 (copy), t1 (copy)
        local v96, v97 = t1.Instance(p54)

        if not v96 then
            return false, v97 or ""
        end

        if not p54:IsA(p52) then
            return false, string.format("%s expected, got %s", p52, p54.ClassName)
        end

        local v98, v99

        if v95 then
            v98, v99 = v95(p54)
        end

        if not v95 or v98 then
            return true
        end

        return false, v99
    end
end

function t1.enum(p55) -- line: 1128
    -- upvalues: t1 (copy)
    assert(t1.Enum(p55))

    return function(p56) -- line: 1130
        -- upvalues: p55 (copy), t1 (copy)
        local v100, v101 = t1.EnumItem(p56)

        if not v100 then
            return false, v101
        end

        if p56.EnumType == p55 then
            return true
        end

        return false, string.format("enum of %s expected, got enum of %s", tostring(p55), (tostring(p56.EnumType)))
    end
end

local v103 = t1.tuple(t1.callback, t1.callback)

function t1.wrap(p57, p58) -- line: 1155
    -- upvalues: v103 (copy)
    assert(v103(p57, p58))

    return function(...) -- line: 1157
        -- upvalues: p57 (copy), p58 (copy)
        assert(p58(...))

        return p57(...)
    end
end

function t1.strict(p59) -- line: 1171
    return function(...) -- line: 1172
        -- upvalues: p59 (copy)
        assert(p59(...))
    end
end

local v104 = t1.map(t1.string, t1.callback)

function t1.children(p60) -- line: 1191
    -- upvalues: t1 (copy), v104 (copy)
    assert(v104(p60))

    return function(p61) -- line: 1194
        -- upvalues: p60 (copy), t1 (copy)
        local v105, v106 = t1.Instance(p61)

        if not v105 then
            return false, v106 or ""
        end

        local t10 = {}

        for _, child in ipairs(p61:GetChildren()) do
            local Name = child.Name

            if p60[Name] then
                if t10[Name] then
                    return false, string.format("Cannot process multiple children with the same name %q", Name)
                end

                t10[Name] = child
            end
        end

        for v107, v108 in pairs(p60) do
            local v109, v110 = v108(t10[v107])

            if not v109 then
                return false, string.format("[%s.%s] %s", p61:GetFullName(), v107, v110 or "")
            end
        end

        return true
    end
end

return t1

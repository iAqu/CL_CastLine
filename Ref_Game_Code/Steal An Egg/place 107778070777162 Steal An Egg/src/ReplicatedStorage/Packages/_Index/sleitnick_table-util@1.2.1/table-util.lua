-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local v1 = Random.new()

local function Copy(p1, p2) -- line: 39
    if not p2 then
        return (table.clone(p1))
    end

    local function DeepCopy(p3) -- line: 43
        -- upvalues: DeepCopy (copy)
        local v2 = table.clone(p3)

        for v3, v4 in v2 do
            if type(v4) == "table" then
                v2[v3] = DeepCopy(v4)
            end
        end

        return v2
    end

    return (DeepCopy(p1))
end

local function CopySafe(p4, p5, p6) -- line: 55
    if not p5 then
        return (table.clone(p4))
    end

    local t1 = {}

    local function DeepCopy(p7) -- line: 61
        -- upvalues: p6 (copy), t1 (ref), DeepCopy (copy)
        local v5 = t1[p7]

        if v5 then
            return v5
        end

        local v6 = table.clone(p7)
        local mt = if p6 then getmetatable(p7) else nil
        local t2 = t1

        t2[p7] = v6

        if mt then
            setmetatable(v6, mt)
        end

        for v7, v8 in v6 do
            if type(v8) == "table" then
                v6[v7] = DeepCopy(v8)
            end
        end

        return v6
    end

    local v9 = DeepCopy(p4)

    t1 = nil

    return v9
end

local function Sync(p8, p9) -- line: 119
    -- upvalues: Sync (copy)
    assert(type(p8) == "table", "First argument must be a table")
    assert(type(p9) == "table", "Second argument must be a table")

    local v12 = table.clone(p8)

    for v13, v14 in pairs(v12) do
        local v15 = p9[v13]

        if v15 ~= nil then
            if type(v14) == type(v15) then
                if type(v14) == "table" then
                    v12[v13] = Sync(v14, v15)
                end
            elseif type(v15) == "table" then
                local function DeepCopy(p10) -- line: 43
                    -- upvalues: DeepCopy (copy)
                    local v16 = table.clone(p10)

                    for v17, v18 in v16 do
                        if type(v18) == "table" then
                            v16[v17] = DeepCopy(v18)
                        end
                    end

                    return v16
                end

                v12[v13] = DeepCopy(v15)
            else
                v12[v13] = v15
            end
        else
            v12[v13] = nil
        end
    end

    for v19, v20 in pairs(p9) do
        if v12[v19] == nil then
            if type(v20) == "table" then
                local function DeepCopy(p11) -- line: 43
                    -- upvalues: DeepCopy (copy)
                    local v21 = table.clone(p11)

                    for v22, v23 in v21 do
                        if type(v23) == "table" then
                            v21[v22] = DeepCopy(v23)
                        end
                    end

                    return v21
                end

                v12[v19] = DeepCopy(v20)
            else
                v12[v19] = v20
            end
        end
    end

    return v12
end

local function Reconcile(p12, p13) -- line: 191
    -- upvalues: Reconcile (copy)
    assert(type(p12) == "table", "First argument must be a table")
    assert(type(p13) == "table", "Second argument must be a table")

    local v26 = table.clone(p12)

    for v27, v28 in p13 do
        local v29 = p12[v27]

        if v29 ~= nil then
            if type(v29) == "table" then
                if type(v28) == "table" then
                    v26[v27] = Reconcile(v29, v28)
                else
                    local function DeepCopy(p15) -- line: 43
                        -- upvalues: DeepCopy (copy)
                        local v33 = table.clone(p15)

                        for v34, v35 in v33 do
                            if type(v35) == "table" then
                                v33[v34] = DeepCopy(v35)
                            end
                        end

                        return v33
                    end

                    v26[v27] = DeepCopy(v29)
                end
            end
        elseif type(v28) == "table" then
            local function DeepCopy(p14) -- line: 43
                -- upvalues: DeepCopy (copy)
                local v30 = table.clone(p14)

                for v31, v32 in v30 do
                    if type(v32) == "table" then
                        v30[v31] = DeepCopy(v32)
                    end
                end

                return v30
            end

            v26[v27] = DeepCopy(v28)
        else
            v26[v27] = v28
        end
    end

    return v26
end

local function HardReconcile(p16, p17) -- line: 217
    -- upvalues: Reconcile (copy)
    assert(type(p16) == "table", "First argument must be a table")
    assert(type(p17) == "table", "Second argument must be a table")

    for v38, v39 in p17 do
        local v40 = p16[v38]

        if v40 ~= nil then
            if type(v40) == "table" then
                if type(v39) == "table" then
                    p16[v38] = Reconcile(v40, v39)
                else
                    local function DeepCopy(p19) -- line: 43
                        -- upvalues: DeepCopy (copy)
                        local v44 = table.clone(p19)

                        for v45, v46 in v44 do
                            if type(v46) == "table" then
                                v44[v45] = DeepCopy(v46)
                            end
                        end

                        return v44
                    end

                    p16[v38] = DeepCopy(v40)
                end
            end
        elseif type(v39) == "table" then
            local function DeepCopy(p18) -- line: 43
                -- upvalues: DeepCopy (copy)
                local v41 = table.clone(p18)

                for v42, v43 in v41 do
                    if type(v43) == "table" then
                        v41[v42] = DeepCopy(v43)
                    end
                end

                return v41
            end

            p16[v38] = DeepCopy(v39)
        else
            p16[v38] = v39
        end
    end

    return p16
end

local function ShallowReconcile(p20, p21) -- line: 241
    assert(type(p20) == "table", "First argument must be a table")
    assert(type(p21) == "table", "Second argument must be a table")

    local v49 = table.clone(p20)

    for v50, v51 in p21 do
        if p20[v50] == nil then
            if type(v51) == "table" then
                local function DeepCopy(p22) -- line: 43
                    -- upvalues: DeepCopy (copy)
                    local v52 = table.clone(p22)

                    for v53, v54 in v52 do
                        if type(v54) == "table" then
                            v52[v53] = DeepCopy(v54)
                        end
                    end

                    return v52
                end

                v49[v50] = DeepCopy(v51)
            else
                v49[v50] = v51
            end
        end
    end

    return v49
end

local function HardShallowReconcile(p23, p24) -- line: 261
    assert(type(p23) == "table", "First argument must be a table")
    assert(type(p24) == "table", "Second argument must be a table")

    for v57, v58 in p24 do
        if p23[v57] == nil then
            if type(v58) == "table" then
                local function DeepCopy(p25) -- line: 43
                    -- upvalues: DeepCopy (copy)
                    local v59 = table.clone(p25)

                    for v60, v61 in v59 do
                        if type(v61) == "table" then
                            v59[v60] = DeepCopy(v61)
                        end
                    end

                    return v59
                end

                p23[v57] = DeepCopy(v58)
            else
                p23[v57] = v58
            end
        end
    end

    return p23
end

local function SwapRemove(p26, p27) -- line: 306
    local v62 = #p26

    p26[p27] = p26[v62]
    p26[v62] = nil
end

local function SwapRemoveFirstValue(p28, p29) -- line: 331
    local v63 = table.find(p28, p29)

    if v63 then
        local v64 = #p28

        p28[v63] = p28[v64]
        p28[v64] = nil
    end

    return v63
end

local function Map(p30, p31) -- line: 359
    assert(type(p30) == "table", "First argument must be a table")
    assert(type(p31) == "function", "Second argument must be a function")

    local v67 = table.create(#p30)

    for v68, v69 in p30 do
        v67[v68] = p31(v69, v68, p30)
    end

    return v67
end

local function Filter(p32, p33) -- line: 389
    assert(type(p32) == "table", "First argument must be a table")
    assert(type(p33) == "function", "Second argument must be a function")

    local v72 = table.create(#p32)

    if #p32 > 0 then
        local n1 = 0

        for v73, v74 in p32 do
            if p33(v74, v73, p32) then
                n1 += 1
                v72[n1] = v74
            end
        end
    else
        for v75, v76 in p32 do
            if p33(v76, v75, p32) then
                v72[v75] = v76
            end
        end
    end

    return v72
end

local function Reduce(p34, p35, p36) -- line: 432
    assert(type(p34) == "table", "First argument must be a table")
    assert(type(p35) == "function", "Second argument must be a function")

    local v79 = p36

    if #p34 > 0 then
        local n2 = 1

        if p36 == nil then
            v79 = p34[1]
            n2 = 2
        end

        for i = n2, #p34 do
            v79 = p35(v79, p34[i], i, p34)
        end
    else
        local v80

        if p36 == nil then
            v79 = next(p34)
            v80 = v79
        end

        for v82, v83 in next, p34, v80 do
            v79 = p35(v79, v83, v82, p34)
        end
    end

    return v79
end

local function Assign(p37, ...) -- line: 475
    local v84 = table.clone(p37)

    for _, v85 in { ... } do
        for v86, v87 in v85 do
            v84[v86] = v87
        end
    end

    return v84
end

local function Extend(p38, p39) -- line: 504
    local v88 = table.clone(p38)

    for _, v89 in p39 do
        table.insert(v88, v89)
    end

    return v88
end

local function Reverse(p40) -- line: 529
    local v90 = #p40
    local v91 = table.create(v90)

    for i = 1, v90 do
        v91[i] = p40[v90 - i + 1]
    end

    return v91
end

local function Shuffle(p41, p42) -- line: 556
    -- upvalues: v1 (copy)
    assert(type(p41) == "table", "First argument must be a table")

    local v93 = table.clone(p41)
    local v94 = if typeof(p42) == "Random" then p42 else v1

    for i = #p41, 2, -1 do
        local v95 = v94:NextInteger(1, i)
        local v96 = v93[v95]
        local v97 = v93[i]

        v93[i] = v96
        v93[v95] = v97
    end

    return v93
end

local function Sample(p43, p44, p45) -- line: 586
    -- upvalues: v1 (copy)
    assert(type(p43) == "table", "First argument must be a table")
    assert(type(p44) == "number", "Second argument must be a number")

    local v100 = #p43

    if v100 == 0 then
        return {}
    end

    local v101 = table.clone(p43)
    local v102 = table.create(p44)
    local v103 = if typeof(p45) == "Random" then p45 else v1
    local v104 = math.clamp(p44, 1, v100)

    for i = 1, v104 do
        local v105 = v103:NextInteger(i, v100)
        local v106 = v101[v105]
        local v107 = v101[i]

        v101[i] = v106
        v101[v105] = v107
    end

    table.move(v101, 1, v104, 1, v102)

    return v102
end

local function Flat(p46, p47) -- line: 634
    local v108 = if type(p47) == "number" then p47 else 1
    local v109 = table.create(#p46)

    local function Scan(p48, p49) -- line: 637
        -- upvalues: v109 (copy), v108 (copy), Scan (copy)
        for _, v110 in p48 do
            if type(v110) == "table" and p49 < v108 then
                Scan(v110, p49 + 1)
            else
                table.insert(v109, v110)
            end
        end
    end

    Scan(p46, 0)

    return v109
end

local function FlatMap(p50, p51) -- line: 671
    -- upvalues: Map (copy)
    local v111 = Map(p50, p51)
    local v112 = table.create(#v111)
    local n3 = 1

    local function Scan(p52, p53) -- line: 637
        -- upvalues: v112 (copy), n3 (copy), Scan (copy)
        for _, v113 in p52 do
            if type(v113) == "table" and p53 < n3 then
                Scan(v113, p53 + 1)
            else
                table.insert(v112, v113)
            end
        end
    end

    Scan(v111, 0)

    return v112
end

local function Keys(p54) -- line: 697
    local v114 = table.create(#p54)

    for v115 in p54 do
        table.insert(v114, v115)
    end

    return v114
end

local function Values(p55) -- line: 727
    local v116 = table.create(#p55)

    for _, v117 in p55 do
        table.insert(v116, v117)
    end

    return v116
end

local function Find(p56, p57) -- line: 766
    for v118, v119 in p56 do
        if p57(v119, v118, p56) then
            return v119, v118
        end
    end

    return nil, nil
end

local function Every(p58, p59) -- line: 795
    for v120, v121 in p58 do
        if not p59(v121, v120, p58) then
            return false
        end
    end

    return true
end

local function Some(p60, p61) -- line: 824
    for v122, v123 in p60 do
        if p61(v123, v122, p60) then
            return true
        end
    end

    return false
end

local function Truncate(p62, p63) -- line: 850
    local v124 = #p62
    local v125 = math.clamp(p63, 1, v124)

    if v125 == v124 then
        return (table.clone(p62))
    end

    return (table.move(p62, 1, v125, 1, table.create(v125)))
end

local function Zip(...) -- line: 883
    assert(select("#", ...) > 0, "Must supply at least 1 table")

    local function ZipIteratorArray(p64, p65) -- line: 885
        local v127 = p65 + 1
        local t3 = {}

        for v128, v129 in p64 do
            local v130 = v129[v127]

            if v130 == nil then
                return nil, nil
            end

            t3[v128] = v130
        end

        return v127, t3
    end

    local function ZipIteratorMap(p66, p67) -- line: 898
        local t4 = {}

        for v131, v132 in p66 do
            local v133 = next(v132, p67)

            if v133 == nil then
                return nil, nil
            end

            t4[v131] = v133
        end

        return p67, t4
    end

    local t5 = { ... }

    if #t5[1] > 0 then
        return ZipIteratorArray, t5, 0
    end

    return ZipIteratorMap, t5, nil
end

local function Lock(p68) -- line: 936
    local function Freeze(p69) -- line: 937
        -- upvalues: Freeze (copy)
        for v134, v135 in pairs(p69) do
            if type(v135) == "table" then
                p69[v134] = Freeze(v135)
            end
        end

        return table.freeze(p69)
    end

    return Freeze(p68)
end

local function IsEmpty(p70) -- line: 966
    return next(p70) == nil
end

local function EncodeJSON(p71) -- line: 978
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode(p71)
end

return {
    Copy = Copy,
    Sync = Sync,
    Reconcile = Reconcile,
    SwapRemove = SwapRemove,
    SwapRemoveFirstValue = SwapRemoveFirstValue,
    Map = Map,
    Filter = Filter,
    Reduce = Reduce,
    Assign = Assign,
    Extend = Extend,
    Reverse = Reverse,
    Shuffle = Shuffle,
    Sample = Sample,
    Flat = Flat,
    FlatMap = FlatMap,
    Keys = Keys,
    Values = Values,
    Find = Find,
    Every = Every,
    Some = Some,
    Truncate = Truncate,
    Zip = Zip,
    Lock = Lock,
    IsEmpty = IsEmpty,
    EncodeJSON = EncodeJSON,
    DecodeJSON = function(p72) -- DecodeJSON | line: 990
        -- upvalues: HttpService (copy)
        return HttpService:JSONDecode(p72)
    end,
    ShallowReconcile = ShallowReconcile,
    HardShallowReconcile = HardShallowReconcile,
    CopySafe = CopySafe,
    HardReconcile = HardReconcile
}

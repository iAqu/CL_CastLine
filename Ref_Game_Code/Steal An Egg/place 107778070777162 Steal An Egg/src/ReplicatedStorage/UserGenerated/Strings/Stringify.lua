-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Pretty = true,
    IndentChar = " ",
    IndentSize = 2
}

local function isInt(p1) -- line: 68
    return math.abs(p1 - math.round(p1)) < 1E-06
end

local function roundTo(p2, p3) -- line: 72
    return math.round(p2 * p3) / p3
end

local function formatNum(p4, p5) -- line: 76
    local v3 = 10 ^ p5
    local v5 = math.round(p4 * v3) / v3

    if v5 == 0 and p4 ~= 0 then
        return (tostring(p4))
    end

    local v6 = string.format("%." .. p5 .. "f", v5):gsub("%.?0+$", "")

    if v6 == "" or v6 == "-" then
        return "0"
    end

    return v6
end

local function isValidId(p6) -- line: 86
    return p6:match("^[a-zA-Z_][a-zA-Z0-9_]*$") == p6
end

local function makeIndent(p7, p8, p9) -- line: 90
    return string.rep(p7, p8 * p9)
end

local t2 = {}

local function serialize(p10, p11) -- line: 100
    -- upvalues: t2 (copy)
    local v7 = t2[typeof(p10)]

    if v7 then
        return v7(p10, p11)
    end

    return (("[%*]"):format((typeof(p10))))
end

t2["nil"] = function(_, _) -- line: 113
    return "nil"
end

t2.boolean = function(p14, _) -- line: 117
    if p14 then
        return "true"
    end

    return "false"
end

t2.number = function(p16, p17) -- line: 121
    if p16 == 1e999 then
        return "math.huge"
    end

    if p16 == (-1e999) then
        return "-math.huge"
    end

    if p16 ~= p16 then
        return "0/0"
    end

    local v8, v9

    if p17.cfg.Pretty then
        local v11 = math.round(p16 * 1E+06) / 1E+06

        if v11 ~= 0 or p16 == 0 then
            local v14 = string.format("%." .. 6 .. "f", v11):gsub("%.?0+$", "")

            if v14 == "" or v14 == "-" then
                v8 = "0"
                v9 = true
            elseif v14 then
                v8 = v14
                v9 = true
            else
                v9 = false
            end
        else
            local v13 = tostring(p16)

            if v13 then
                v8 = v13
                v9 = true
            else
                v9 = false
            end
        end
    else
        v9 = false
    end

    if not v9 then
        v8 = tostring(p16)
    end

    return v8
end

t2.string = function(p18, _) -- line: 134
    return string.format("%q", p18)
end

t2["function"] = function(_) -- line: 138
    return "[function]"
end

t2.Instance = function(p21) -- line: 142
    if p21.Parent then
        return (("[%* %*]"):format(p21.ClassName, (p21:GetFullName())))
    end

    return (("[%*]"):format(p21.ClassName))
end

t2.table = function(p22, p23) -- line: 153
    -- upvalues: t2 (copy)
    local mt = getmetatable(p22)

    if not (mt and mt.__tostring) then
        if p23.seen[p22] then
            return "{...}"
        end

        p23.seen[p22] = true

        local t3 = {}
        local n1 = 0

        for v15 in pairs(p22) do
            if typeof(v15) == "number" and math.abs(v15 - math.round(v15)) < 1E-06 and v15 > 0 then
                n1 = math.max(n1, v15)
            end

            table.insert(t3, v15)
        end

        local v17 = #t3 == n1 and #t3 > 0

        for i = 1, n1 do
            if p22[i] == nil then
                v17 = false
                break
            end
        end

        p23.depth += 1

        local Pretty = p23.cfg.Pretty
        local v18, v19

        if Pretty then
            local IndentChar, IndentSize = p23.cfg.IndentChar, p23.cfg.IndentSize
            local depth = p23.depth

            v18 = "\n" .. string.rep(IndentChar, IndentSize * depth) or ""

            local IndentChar2, IndentSize2 = p23.cfg.IndentChar, p23.cfg.IndentSize
            local depth2 = p23.depth

            v19 = ",\n" .. string.rep(IndentChar2, IndentSize2 * depth2) or ","
        else
            v18 = ""
            v19 = ","
        end

        local t4 = {}

        if v17 then
            for i = 1, n1 do
                local v20 = p22[i]
                local v21 = t2[typeof(v20)]

                if v21 then
                    t4[i] = v21(v20, p23)
                else
                    t4[i] = ("[%*]"):format((typeof(v20)))
                end
            end
        else
            local order = p23.order
            local t5 = {}

            for v22, v23 in ipairs(t3) do
                t5[v23] = v22
            end

            local t6 = {}

            for _, v24 in ipairs(t3) do
                table.insert(t6, {
                    v24,
                    p22[v24]
                })
            end

            if order then
                table.sort(t6, function(p24, p25) -- line: 205
                    -- upvalues: order (copy), t5 (copy)
                    local Index = order[p24[1]] and order[p24[1]].Index or 1e999
                    local Index2 = order[p25[1]] and order[p25[1]].Index or 1e999

                    if Index == Index2 or not (Index < Index2) then
                        return t5[p24[1]] < t5[p25[1]]
                    end

                    return true
                end)
            end

            for _, v27 in ipairs(t6) do
                local v28 = v27[1]
                local v29 = v27[2]
                local v30 = order and order[v28] and order[v28].Child or nil
                local order2 = p23.order

                p23.order = v30

                if typeof(v28) ~= "string" or v28:match("^[a-zA-Z_][a-zA-Z0-9_]*$") ~= v28 or not v28 then
                    local v31 = t2[typeof(v28)]

                    v28 = ("[%*]"):format(if v31 then v31(v28, p23) else ("[%*]"):format((typeof(v28))))
                end

                local v32 = t2[typeof(v29)]
                local v33 = if v32 then v32(v29, p23) else ("[%*]"):format((typeof(v29)))

                table.insert(t4, Pretty and ("%* = %*"):format(v28, v33) or ("%*=%*"):format(v28, v33))
                p23.order = order2
            end
        end

        p23.depth -= 1
        p23.seen[p22] = nil

        if #t4 == 0 then
            return "{}"
        end

        if not Pretty then
            return "{" .. table.concat(t4, v19) .. "}"
        end

        local IndentChar, IndentSize = p23.cfg.IndentChar, p23.cfg.IndentSize
        local depth = p23.depth
        local v35 = "\n" .. string.rep(IndentChar, IndentSize * depth)

        return "{" .. v18 .. table.concat(t4, v19) .. "," .. v35 .. "}"
    end

    local v36 = tostring(p22)
    local IndentChar, IndentSize = p23.cfg.IndentChar, p23.cfg.IndentSize
    local depth = p23.depth

    return v36:gsub("\n", "\n" .. string.rep(IndentChar, IndentSize * depth))
end

t2.Color3 = function(p26, p27) -- line: 243
    -- upvalues: t2 (copy)
    local v37 = p26.R * 255
    local v38 = p26.G * 255
    local v39 = p26.B * 255
    local v40 = v37 - math.round(v37)
    local v41 = false

    if math.abs(v40) < 1E-06 and math.abs(v38 - math.round(v38)) < 1E-06 then
        v41 = math.abs(v39 - math.round(v39)) < 1E-06
    end

    local v44, v45, v46, v47

    if v41 then
        v44 = math.round(v37)
        v46 = math.round(v38)
        v47 = math.round(v39)
        v45 = "fromRGB"
    else
        v44 = p26.R
        v46 = p26.G
        v47 = p26.B
        v45 = "new"
    end

    if p27.cfg.Pretty then
        local v48 = t2[typeof(v44)]
        local v49 = if v48 then v48(v44, p27) else ("[%*]"):format((typeof(v44)))
        local v50 = t2[typeof(v46)]
        local v51 = if v50 then v50(v46, p27) else ("[%*]"):format((typeof(v46)))
        local v52 = t2[typeof(v47)]

        return (("Color3.%*(%*, %*, %*)"):format(v45, v49, v51, if v52 then v52(v47, p27) else ("[%*]"):format((typeof(v47)))))
    end

    local v53 = t2[typeof(v44)]
    local v54 = if v53 then v53(v44, p27) else ("[%*]"):format((typeof(v44)))
    local v55 = t2[typeof(v46)]
    local v56 = if v55 then v55(v46, p27) else ("[%*]"):format((typeof(v46)))
    local v57 = t2[typeof(v47)]

    return (("Color3.%*(%*,%*,%*)"):format(v45, v54, v56, if v57 then v57(v47, p27) else ("[%*]"):format((typeof(v47)))))
end

t2.Vector3 = function(p28, p29) -- line: 257
    -- upvalues: t2 (copy)
    if p28 == Vector3.new(0, 0, 0) then
        return "Vector3.zero"
    end

    if p28 == Vector3.new(1, 1, 1) then
        return "Vector3.one"
    end

    if p28 == Vector3.new(1, 0, 0) then
        return "Vector3.xAxis"
    end

    if p28 == Vector3.new(0, 1, 0) then
        return "Vector3.yAxis"
    end

    if p28 == Vector3.new(0, 0, 1) then
        return "Vector3.zAxis"
    end

    if p29.cfg.Pretty then
        local X = p28.X
        local v58 = t2[typeof(X)]
        local v59 = if v58 then v58(X, p29) else ("[%*]"):format((typeof(X)))
        local Y = p28.Y
        local v60 = t2[typeof(Y)]
        local v61 = if v60 then v60(Y, p29) else ("[%*]"):format((typeof(Y)))
        local Z = p28.Z
        local v62 = t2[typeof(Z)]

        return (("Vector3.new(%*, %*, %*)"):format(v59, v61, if v62 then v62(Z, p29) else ("[%*]"):format((typeof(Z)))))
    end

    local X = p28.X
    local v63 = t2[typeof(X)]
    local v64 = if v63 then v63(X, p29) else ("[%*]"):format((typeof(X)))
    local Y = p28.Y
    local v65 = t2[typeof(Y)]
    local v66 = if v65 then v65(Y, p29) else ("[%*]"):format((typeof(Y)))
    local Z = p28.Z
    local v67 = t2[typeof(Z)]

    return (("Vector3.new(%*,%*,%*)"):format(v64, v66, if v67 then v67(Z, p29) else ("[%*]"):format((typeof(Z)))))
end

t2.Vector2 = function(p30, p31) -- line: 279
    -- upvalues: t2 (copy)
    if p30 == Vector2.zero then
        return "Vector2.zero"
    end

    if p30 == Vector2.one then
        return "Vector2.one"
    end

    if p30 == Vector2.xAxis then
        return "Vector2.xAxis"
    end

    if p30 == Vector2.yAxis then
        return "Vector2.yAxis"
    end

    if p31.cfg.Pretty then
        local X = p30.X
        local v68 = t2[typeof(X)]
        local v69 = if v68 then v68(X, p31) else ("[%*]"):format((typeof(X)))
        local Y = p30.Y
        local v70 = t2[typeof(Y)]

        return (("Vector2.new(%*, %*)"):format(v69, if v70 then v70(Y, p31) else ("[%*]"):format((typeof(Y)))))
    end

    local X = p30.X
    local v71 = t2[typeof(X)]
    local v72 = if v71 then v71(X, p31) else ("[%*]"):format((typeof(X)))
    local Y = p30.Y
    local v73 = t2[typeof(Y)]

    return (("Vector2.new(%*,%*)"):format(v72, if v73 then v73(Y, p31) else ("[%*]"):format((typeof(Y)))))
end

t2.CFrame = function(p32, p33) -- line: 298
    -- upvalues: t2 (copy)
    if p32 == CFrame.identity then
        return "CFrame.identity"
    end

    local Position = p32.Position
    local v74, v75, v76 = p32:ToOrientation()
    local Magnitude = Position.Magnitude
    local _, _, _, Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9 = p32:GetComponents()
    local v77 = Components - 1
    local v78 = math.abs(v77) > 1E-06
        or math.abs(Components5 - 1) > 1E-06
        or math.abs(Components9 - 1) > 1E-06
        or math.abs(Components2) > 1E-06
        or math.abs(Components3) > 1E-06
        or math.abs(Components4) > 1E-06
        or math.abs(Components6) > 1E-06
        or math.abs(Components7) > 1E-06
        or math.abs(Components8) > 1E-06
    local v81 = Magnitude > 1E-06
    local Pretty = p33.cfg.Pretty
    local v82, v83

    if Pretty then
        local v85 = math.round(Position.X * 1E+06) / 1E+06
        local v86 = t2[typeof(v85)]
        local v87 = if v86 then v86(v85, p33) else ("[%*]"):format((typeof(v85)))
        local v89 = math.round(Position.Y * 1E+06) / 1E+06
        local v90 = t2[typeof(v89)]
        local v91 = if v90 then v90(v89, p33) else ("[%*]"):format((typeof(v89)))
        local v93 = math.round(Position.Z * 1E+06) / 1E+06
        local v94 = t2[typeof(v93)]
        local v95 = ("CFrame.new(%*, %*, %*)"):format(v87, v91, if v94 then v94(v93, p33) else ("[%*]"):format((typeof(v93))))

        if v95 then
            v82 = v95
            v83 = true
        else
            v83 = false
        end
    else
        v83 = false
    end

    if not v83 then
        local X = Position.X
        local v96 = t2[typeof(X)]
        local v97 = if v96 then v96(X, p33) else ("[%*]"):format((typeof(X)))
        local Y = Position.Y
        local v98 = t2[typeof(Y)]
        local v99 = if v98 then v98(Y, p33) else ("[%*]"):format((typeof(Y)))
        local Z = Position.Z
        local v100 = t2[typeof(Z)]

        v82 = ("CFrame.new(%*,%*,%*)"):format(v97, v99, if v100 then v100(Z, p33) else ("[%*]"):format((typeof(Z))))
    end

    local v101, v102

    if Pretty then
        local v104 = math.round(math.deg(v74) * 1E+06) / 1E+06
        local v105 = t2[typeof(v104)]
        local v106 = if v105 then v105(v104, p33) else ("[%*]"):format((typeof(v104)))
        local v108 = math.round(math.deg(v75) * 1E+06) / 1E+06
        local v109 = t2[typeof(v108)]
        local v110 = if v109 then v109(v108, p33) else ("[%*]"):format((typeof(v108)))
        local v112 = math.round(math.deg(v76) * 1E+06) / 1E+06
        local v113 = t2[typeof(v112)]
        local v114 = ("CFrame.fromOrientation(math.rad(%*), math.rad(%*), math.rad(%*))"):format(v106, v110, if v113 then v113(v112, p33) else ("[%*]"):format((typeof(v112))))

        if v114 then
            v101 = v114
            v102 = true
        else
            v102 = false
        end
    else
        v102 = false
    end

    if not v102 then
        local v115 = t2[typeof(v74)]
        local v116 = if v115 then v115(v74, p33) else ("[%*]"):format((typeof(v74)))
        local v117 = t2[typeof(v75)]
        local v118 = if v117 then v117(v75, p33) else ("[%*]"):format((typeof(v75)))
        local v119 = t2[typeof(v76)]

        v101 = ("CFrame.fromOrientation(%*,%*,%*)"):format(v116, v118, if v119 then v119(v76, p33) else ("[%*]"):format((typeof(v76))))
    end

    if not v81 then
        return v101
    end

    local v120, v121

    if v78 then
        local v122 = v82 .. (if Pretty then " * " else "*") .. v101

        if v122 then
            v120 = v122
            v121 = true
        else
            v121 = false
        end
    else
        v121 = false
    end

    if not v121 then
        v120 = v82
    end

    return v120
end

t2.EnumItem = function(p34, _) -- line: 341
    return (("Enum.%*.%*"):format(tostring(p34.EnumType), p34.Name))
end

local t8 = {
    DEFAULT_CONFIG = t1
}

function t8.Pretty(p36, p37) -- line: 353
    -- upvalues: t1 (copy), serialize (copy)
    local t9 = {
        Pretty = p37 and p37.Pretty or t1.Pretty,
        IndentChar = p37 and p37.IndentChar or t1.IndentChar,
        IndentSize = p37 and p37.IndentSize or t1.IndentSize,
        Order = p37 and p37.Order or t1.Order
    }

    return serialize(p36, {
        depth = 0,
        cfg = t9,
        order = t9.Order,
        seen = {}
    })
end

function t8.Serialize(p38, p39) -- line: 369
    -- upvalues: serialize (copy)
    return serialize(p38, {
        depth = 0,
        cfg = p39,
        order = p39.Order,
        seen = {}
    })
end

function t8.Default(p40) -- line: 378
    -- upvalues: t1 (copy), serialize (copy)
    return serialize(p40, {
        depth = 0,
        cfg = t1,
        order = t1.Order,
        seen = {}
    })
end

function t8.DefaultArgs(...) -- line: 388
    -- upvalues: t8 (copy)
    local v123 = table.pack(...)
    local t10 = {}

    for i = 1, v123.n do
        if i > 1 then
            table.insert(t10, ", ")
        end

        table.insert(t10, t8.Default(v123[i]))
    end

    return table.concat(t10)
end

function t8.DefaultArgsPrefix(...) -- line: 400
    -- upvalues: t8 (copy)
    local v125 = table.pack(...)
    local t11 = {}

    for i = 1, v125.n do
        table.insert(t11, ", ")
        table.insert(t11, t8.Default(v125[i]))
    end

    return table.concat(t11)
end

function t8.CompileOrder(p41) -- line: 410
    -- upvalues: t8 (copy)
    assert(type(p41) == "table")
    assert(#p41 ~= 0 or next(p41) == nil)

    local t12 = {}

    for v129, v130 in ipairs(p41) do
        if type(v130) == "table" then
            local Key = v130.Key

            assert(type(Key) == "string")
            t12[Key] = {
                Index = v129,
                Child = t8.CompileOrder(v130.Value)
            }
        else
            t12[v130] = {
                Index = v129
            }
        end
    end

    return t12
end

return table.freeze(t8)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Types)

local function SampleCurve(p1, p2, p3, p4) -- line: 20
    return ((p1 * p4 + p2) * p4 + p3) * p4
end

local function SampleDerivative(p5, p6, p7, p8) -- line: 24
    return (p5 * 3 * p8 + p6 * 2) * p8 + p7
end

local function SolveCubicBezier(p9, p10, p11, p12, p13) -- line: 28
    if p13 <= 0 then
        return 0
    end

    if p13 >= 1 then
        return 1
    end

    if p9 == p10 and p11 == p12 then
        return p13
    end

    local v1 = p9 * 3
    local v2 = (p11 - p9) * 3 - v1
    local v3 = 1 - v1 - v2
    local v4 = p10 * 3
    local v5 = (p12 - p10) * 3 - v4
    local v6 = 1 - v4 - v5
    local v7 = p13

    for _ = 1, 8 do
        local v8 = ((v3 * v7 + v2) * v7 + v1) * v7 - p13

        if math.abs(v8) < 1E-07 then
            return ((v6 * v7 + v5) * v7 + v4) * v7
        end

        local v9 = (v3 * 3 * v7 + v2 * 2) * v7 + v1

        if math.abs(v9) < 1E-07 then
            break
        end

        v7 -= v8 / v9
    end

    local v10 = p13
    local n1 = 0
    local n2 = 1

    for _ = 1, 16 do
        local v11 = ((v3 * v10 + v2) * v10 + v1) * v10 - p13

        if math.abs(v11) < 1E-07 then
            break
        end

        if v11 > 0 then
            n2 = v10
        else
            n1 = v10
        end

        v10 = (n1 + n2) * 0.5
    end

    return ((v6 * v10 + v5) * v10 + v4) * v10
end

local function NormalizeHandle(p14, p15) -- line: 80
    if type(p14) == "number" then
        return p14
    end

    return p14[p15 or 1] or 0
end

local function LerpScalar(p16, p17, p18) -- line: 90
    return p16 + (p17 - p16) * p18
end

local function LerpArray(p19, p20, p21) -- line: 94
    local v12 = table.create(#p19)

    for i = 1, #p19 do
        v12[i] = p19[i] + ((p20[i] or p19[i]) - p19[i]) * p21
    end

    return v12
end

local function LerpBezierShape(p22, p23, p24) -- line: 102
    local v13 = table.create(#p22.v)
    local v14 = table.create(#p22.i)
    local v15 = table.create(#p22.o)

    for i = 1, #p22.v do
        local v16 = p22.v[i]
        local v17 = p23.v[i]
        local v18 = p22.i[i]
        local v19 = p23.i[i]
        local v20 = p22.o[i]
        local v21 = p23.o[i]

        v13[i] = {
            v16[1] + (v17[1] - v16[1]) * p24,
            v16[2] + (v17[2] - v16[2]) * p24
        }
        v14[i] = {
            v18[1] + (v19[1] - v18[1]) * p24,
            v18[2] + (v19[2] - v18[2]) * p24
        }
        v15[i] = {
            v20[1] + (v21[1] - v20[1]) * p24,
            v20[2] + (v21[2] - v20[2]) * p24
        }
    end

    return {
        v = v13,
        i = v14,
        o = v15,
        c = p22.c
    }
end

local function FindKeyframes(p25, p26) -- line: 119
    local v22 = #p25

    if v22 == 0 then
        return nil, nil, 0
    end

    if v22 == 1 then
        return p25[1], nil, 0
    end

    local v23 = p25[1]

    if p26 <= v23.t then
        return v23, nil, 0
    end

    for i = 2, v22 do
        local v24 = p25[i]

        if p26 < v24.t then
            return p25[i - 1], v24, i - 1
        end
    end

    return p25[v22], nil, v22
end

local function ExtractValue(p27) -- line: 145
    if p27 == nil or #p27 == 0 then
        return nil
    end

    if type(p27[1]) == "table" then
        return p27[1]
    end

    return p27
end

local function Evaluate(p28, p29) -- line: 161
    -- upvalues: SolveCubicBezier (copy), LerpArray (copy), LerpBezierShape (copy), FindKeyframes (copy)
    local a, k = p28.a, p28.k

    if a == nil or a == 0 then
        if type(k) == "number" then
            return k
        end

        if type(k) ~= "table" then
            return nil
        end

        if not (#k > 0 and type(k[1]) == "table") then
            return k
        end

        return k[1]
    end

    local v29, v30 = FindKeyframes(k, p29)

    if v29 == nil then
        return nil
    end

    if v30 == nil then
        local s = v29.s

        if s == nil or #s == 0 then
            s = nil
        elseif type(s[1]) == "table" then
            s = s[1]
        end

        if s ~= nil then
            return s
        end

        local e = v29.e

        if e == nil or #e == 0 then
            return nil
        end

        if type(e[1]) == "table" then
            return e[1]
        end

        return e
    end

    if v29.h == 1 then
        local s = v29.s

        if s == nil or #s == 0 then
            return nil
        end

        if type(s[1]) == "table" then
            return s[1]
        end

        return s
    end

    local t = v29.t
    local v34 = v30.t - t

    if v34 <= 0 then
        local s = v29.s

        if s == nil or #s == 0 then
            return nil
        end

        if type(s[1]) == "table" then
            return s[1]
        end

        return s
    end

    local v37 = math.clamp((p29 - t) / v34, 0, 1)
    local s = v29.s

    if s == nil or #s == 0 then
        s = nil
    elseif type(s[1]) == "table" then
        s = s[1]
    end

    local s2 = v30.s

    if s2 == nil or #s2 == 0 then
        s2 = nil
    elseif type(s2[1]) == "table" then
        s2 = s2[1]
    end

    if not s2 then
        s2 = v29.e

        if s2 == nil or #s2 == 0 then
            s2 = nil
        elseif type(s2[1]) == "table" then
            s2 = s2[1]
        end
    end

    local v41 = false
    local v42 = false
    local v43 = false
    local v44 = false

    if s ~= nil then
        v41 = true
    else
        v44 = true
    end

    if v41 then
        if s2 ~= nil then
            v42 = true
        else
            v44 = true
        end
    end

    v41 = false

    local o, i, v45

    if v42 then
        o = v29.o
        i = v29.i

        if o then
            v41 = true
        else
            v45 = v37
            v44 = false
        end
    end

    v42 = false

    if v41 then
        if i then
            v42 = true
        else
            v45 = v37
            v44 = false
        end
    end

    v41 = false

    local SolveCubicBezier2, x

    if v42 then
        SolveCubicBezier2 = SolveCubicBezier
        x = o.x

        if type(x) == "number" then
            v43 = true
        else
            v41 = true
        end
    end

    v42 = false

    local v46

    if v41 then
        v46 = x[1] or 0
        v42 = true
    end

    v41 = false

    if v43 then
        v46 = x
        v42 = true
    end

    v43 = false

    local y

    if v42 then
        y = o.y

        if type(y) == "number" then
            v41 = true
        else
            v43 = true
        end
    end

    v42 = false

    local v47

    if v43 then
        v47 = y[1] or 0
        v42 = true
    end

    v43 = false

    if v41 then
        v47 = y
        v42 = true
    end

    v41 = false

    local x2

    if v42 then
        x2 = i.x

        if type(x2) == "number" then
            v43 = true
        else
            v41 = true
        end
    end

    v42 = false

    local v48

    if v41 then
        v48 = x2[1] or 0
        v42 = true
    end

    v41 = false

    if v43 then
        v48 = x2
        v42 = true
    end

    v43 = false

    local y2

    if v42 then
        y2 = i.y

        if type(y2) == "number" then
            v41 = true
        else
            v43 = true
        end
    end

    v42 = false

    local v49

    if v43 then
        v49 = y2[1] or 0
        v42 = true
    end

    if v41 then
        v49 = y2
        v42 = true
    end

    if v42 then
        v45 = SolveCubicBezier2(v46, v47, v48, v49, v37)
        v44 = false
    end

    if v44 then
        return s or s2
    end

    if type(s) == "number" then
        return s + (s2 - s) * v45
    end

    if type(s) ~= "table" then
        return s
    end

    if not (#s > 0 and type(s[1]) == "number") then
        return (LerpBezierShape(s, s2, v45))
    end

    return (LerpArray(s, s2, v45))
end

local function EvaluateScalar(p30, p31) -- line: 242
    -- upvalues: Evaluate (copy)
    if p30 == nil then
        return p31
    end

    local v53 = Evaluate(p30, 0)

    if v53 == nil then
        return p31
    end

    if type(v53) == "number" then
        return v53
    end

    return type(v53) == "table" and v53[1] or p31
end

local function EvaluateScalarAtFrame(p32, p33, p34) -- line: 259
    -- upvalues: Evaluate (copy)
    if p32 == nil then
        return p34
    end

    local v54 = Evaluate(p32, p33)

    if v54 == nil then
        return p34
    end

    if type(v54) == "number" then
        return v54
    end

    return type(v54) == "table" and v54[1] or p34
end

local function EvaluateVector(p35, p36, p37) -- line: 276
    -- upvalues: Evaluate (copy)
    if p35 ~= nil then
        local v55 = Evaluate(p35, p36)

        if v55 ~= nil then
            if type(v55) == "table" then
                return v55
            end

            if type(v55) == "number" then
                return { v55 }
            end
        end
    end

    return p37
end

local function EvaluateColor(p38, p39) -- line: 293
    -- upvalues: Evaluate (copy)
    if p38 ~= nil then
        local v56 = Evaluate(p38, p39)

        if v56 ~= nil and type(v56) == "table" then
            return Color3.new(v56[1] or 1, v56[2] or 1, v56[3] or 1)
        end
    end

    return Color3.new(1, 1, 1)
end

local function EvaluateBezierShape(p40, p41) -- line: 308
    -- upvalues: Evaluate (copy)
    if p40 ~= nil then
        local v57 = Evaluate(p40, p41)

        if v57 ~= nil and type(v57) == "table" and #v57 > 0 and type(v57[1]) ~= "number" then
            return v57
        end
    end

    return nil
end

return (table.freeze({
    SolveCubicBezier = SolveCubicBezier,
    Evaluate = Evaluate,
    EvaluateScalar = EvaluateScalar,
    EvaluateScalarAtFrame = EvaluateScalarAtFrame,
    EvaluateVector = EvaluateVector,
    EvaluateColor = EvaluateColor,
    EvaluateBezierShape = EvaluateBezierShape,
    LerpArray = LerpArray
}))

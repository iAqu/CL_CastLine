-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

assert(not game:GetService("RunService"):IsClient())

local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local EncodingService = game:GetService("EncodingService")

require(script.Types)

local Easing = require(script.Easing)
local v2 = Rect.new(64, 64, 192, 192)
local v3 = UDim2.fromScale(0, 0)
local v4 = UDim2.fromScale(1, 1)
local result
local _require = require
local PNG = script.PNG
local ok, result2 = pcall(_require, PNG)

if ok then
    result = result2
end

local function HexToColor3(p1) -- line: 90
    local v6 = tonumber(string.sub(p1, 2, 3), 16) or 0
    local v8 = tonumber(string.sub(p1, 4, 5), 16) or 0
    local v10 = tonumber(string.sub(p1, 6, 7), 16) or 0

    return Color3.fromRGB(v6, v8, v10)
end

local function IsPropertyAnimated(p2) -- line: 97
    return p2 ~= nil and p2.a == 1
end

local function HasAnimatedOpacity(p3) -- line: 104
    if p3 == nil then
        return false
    end

    local o = p3.o

    return o ~= nil and o.a == 1
end

local function SubdivideCubicBezier(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 113
    for i = 1, p12 do
        local v11 = i / p12
        local v12 = 1 - v11
        local v13 = v12 * v12
        local v14 = v13 * v12
        local v15 = v11 * v11
        local v16 = v15 * v11

        table.insert(p13, {
            v14 * p4 + v13 * 3 * v11 * p6 + v12 * 3 * v15 * p8 + v16 * p10,
            v14 * p5 + v13 * 3 * v11 * p7 + v12 * 3 * v15 * p9 + v16 * p11
        })
    end
end

local function BezierShapeToPolyline(p14) -- line: 139
    -- upvalues: SubdivideCubicBezier (copy)
    local v, i, o = p14.v, p14.i, p14.o
    local v17 = #v

    if v17 == 0 then
        return {}
    end

    local t2 = {
        {
            v[1][1],
            v[1][2]
        }
    }

    for v18 = 1, if p14.c then v17 else v17 - 1 do
        local v19 = if v18 < v17 then v18 + 1 else 1
        local v20 = v[v18]
        local v21 = v[v19]
        local v22 = o[v18]
        local v23 = i[v19]
        local v24 = v20[1]
        local v25 = v20[2]
        local v26 = v24 + v22[1]
        local v27 = v25 + v22[2]
        local v28 = v21[1] + v23[1]
        local v29 = v21[2] + v23[2]
        local v30 = v21[1]
        local v31 = v21[2]
        local v32 = v22[1]

        if math.abs(v32) < 0.01 and math.abs(v22[2]) < 0.01 and math.abs(v23[1]) < 0.01 and math.abs(v23[2]) < 0.01 then
            table.insert(t2, {
                v30,
                v31
            })
        else
            SubdivideCubicBezier(v24, v25, v26, v27, v28, v29, v30, v31, 12, t2)
        end
    end

    return t2
end

local function Cross2D(p15, p16, p17, p18, p19, p20) -- line: 180
    return (p17 - p15) * (p20 - p16) - (p18 - p16) * (p19 - p15)
end

local function PointInTriangle(p21, p22, p23, p24, p25, p26, p27, p28) -- line: 184
    local v37 = (p23 - p21) * (p26 - p22) - (p24 - p22) * (p25 - p21)
    local v38 = (p25 - p21) * (p28 - p22) - (p26 - p22) * (p27 - p21)
    local v39 = (p27 - p21) * (p24 - p22) - (p28 - p22) * (p23 - p21)
    local v40 = v37 < 0 or v38 < 0 or v39 < 0
    local v41 = v37 > 0 or v38 > 0 or v39 > 0

    return not (v40 and v41)
end

local function IsConvexPolygon(p29) -- line: 202
    local v42 = #p29

    if v42 < 3 then
        return false
    end

    local n1 = 0

    for i = 1, v42 do
        local v43 = if i < v42 then i + 1 else 1
        local v44 = if v43 < v42 then v43 + 1 else 1
        local v45 = p29[i][1]
        local v46 = p29[i][2]
        local v47 = p29[v43][1]
        local v48 = p29[v43][2]
        local v49 = p29[v44][1]
        local v50 = p29[v44][2]
        local v51 = (v47 - v45) * (v50 - v46) - (v48 - v46) * (v49 - v45)

        if v51 ~= 0 then
            if n1 == 0 then
                n1 = if v51 > 0 then 1 else -1
            elseif v51 > 0 and n1 < 0 or v51 < 0 and n1 > 0 then
                return false
            end
        end
    end

    return true
end

local function TriangulateFan(p30) -- line: 223
    local t4 = {}

    for i = 2, #p30 - 1 do
        table.insert(t4, {
            p30[1],
            p30[i],
            p30[i + 1]
        })
    end

    return t4
end

local function TriangulateEarClip(p31) -- line: 231
    -- upvalues: PointInTriangle (copy), IsConvexPolygon (copy), TriangulateFan (copy)
    local v52 = #p31

    if v52 < 3 then
        return {}
    end

    if v52 == 3 then
        return {
            {
                p31[1],
                p31[2],
                p31[3]
            }
        }
    end

    if IsConvexPolygon(p31) then
        return (TriangulateFan(p31))
    end

    local v53 = table.create(v52)
    local n2 = 0

    for i = 1, v52 do
        v53[i] = i

        local v54 = if i < v52 then i + 1 else 1

        n2 += (p31[v54][1] - p31[i][1]) * (p31[v54][2] + p31[i][2])
    end

    local v55 = v53

    if n2 > 0 then
        v55 = table.create(v52)

        for i = 1, v52 do
            v55[i] = v53[v52 - i + 1]
        end
    end

    local t6 = {}
    local v56 = #v55
    local v57 = v56 * v56
    local n3 = 0
    local n4 = 1

    while v56 > 2 and n3 < v57 do
        local v58 = n3 + 1
        local v59 = if v56 < n4 then 1 else n4
        local v60 = if v59 > 1 then v59 - 1 else v56
        local v61 = if v59 < v56 then v59 + 1 else 1
        local v62 = p31[v55[v60]]
        local v63 = p31[v55[v59]]
        local v64 = p31[v55[v61]]
        local v65 = v62[1]
        local v66 = v62[2]
        local v67 = v63[1]
        local v68 = v63[2]
        local v69 = v64[1]
        local v70 = v64[2]
        local v71 = (v67 - v65) * (v70 - v66) - (v68 - v66) * (v69 - v65) > 0
        local v72

        if v71 then
            v72 = true

            for i = 1, v56 do
                if i ~= v60 and i ~= v59 and i ~= v61 and PointInTriangle(p31[v55[i]][1], p31[v55[i]][2], v62[1], v62[2], v63[1], v63[2], v64[1], v64[2]) then
                    v72 = false
                    break
                end
            end
        end

        n3 = v58

        if not v71 or not v72 then
            n4 = v59 + 1
        else
            table.insert(t6, {
                v62,
                v63,
                v64
            })
            table.remove(v55, v59)
            v56 -= 1
            n4 = if v56 < v59 then 1 else v59
        end
    end

    return t6
end

local function CreateWedge(p32) -- line: 317
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Image = "rbxassetid://83051256678409"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Parent = p32

    return ImageLabel
end

local function UpdateTriangle(p33, p34, p35, p36, p37, p38, p39, p40, p41) -- line: 327
    local v73 = p36 - p34
    local v74 = p37 - p35
    local v75 = p38 - p34
    local v76 = p39 - p35

    if v73 * v76 - v74 * v75 < 0 then
        v73 = p38 - p34
        v74 = p39 - p35
        v75 = p36 - p34
        v76 = p37 - p35
    end

    local v78 = math.sqrt(v73 * v73 + v74 * v74)
    local v80 = math.sqrt(v75 * v75 + v76 * v76)

    if v78 < 1E-06 or v80 < 1E-06 then
        p33.A.Visible = false
        p33.B.Visible = false

        return
    end

    local v81 = v73 / v78
    local v82 = v74 / v78
    local v83 = v75 * v81 + v76 * v82
    local v84 = v75 - v81 * v83
    local v85 = v76 - v82 * v83
    local v87 = math.sqrt(v84 * v84 + v85 * v85)

    if v87 < 1E-06 then
        p33.A.Visible = false
        p33.B.Visible = false
    else
        local v88 = math.atan2(v82, v81) * 57.29577951308232
        local A = p33.A

        A.Visible = true
        A.Position = UDim2.fromScale(p34, p35)
        A.Size = UDim2.fromScale(math.max(v83, 1E-04), v87)
        A.Rotation = v88
        A.AnchorPoint = Vector2.zero
        A.ImageColor3 = p40
        A.ImageTransparency = p41

        local B = p33.B
        local v89 = v78 - v83

        B.Visible = v89 > 1E-06

        if B.Visible then
            local v90 = p34 + v81 * v78
            local v91 = p35 + v82 * v78

            B.Position = UDim2.fromScale(v90, v91)
            B.Size = UDim2.fromScale(math.max(v89, 1E-04), v87)
            B.Rotation = v88 + 180
            B.AnchorPoint = Vector2.zero
            B.ImageColor3 = p40
            B.ImageTransparency = p41
        end
    end
end

local function CreateTrianglePair(p42) -- line: 395
    local t8 = {}
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Image = "rbxassetid://83051256678409"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Parent = p42
    t8.A = ImageLabel

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Image = "rbxassetid://83051256678409"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.Parent = p42
    t8.B = ImageLabel2

    return t8
end

local function BuildFilledPath(p43, p44, p45, p46, p47, p48, p49) -- line: 404
    -- upvalues: BezierShapeToPolyline (copy), TriangulateEarClip (copy), UpdateTriangle (copy)
    local v92 = BezierShapeToPolyline(p44)

    if #v92 < 3 then
        return
    end

    local v93 = table.create(#v92)

    for v94, v95 in v92 do
        v93[v94] = {
            v95[1] / p46,
            v95[2] / p47
        }
    end

    local v96 = TriangulateEarClip(v93)
    local v97 = p43.Triangles or {}

    for v98, v99 in v96 do
        local v100

        if v98 <= #v97 then
            v100 = v97[v98]
        else
            v100 = {}

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Image = "rbxassetid://83051256678409"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Size = UDim2.fromScale(1, 1)
            ImageLabel.Parent = p45
            v100.A = ImageLabel

            local ImageLabel2 = Instance.new("ImageLabel")

            ImageLabel2.Image = "rbxassetid://83051256678409"
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.BorderSizePixel = 0
            ImageLabel2.Size = UDim2.fromScale(1, 1)
            ImageLabel2.Parent = p45
            v100.B = ImageLabel2
            table.insert(v97, v100)
        end

        UpdateTriangle(v100, v99[1][1], v99[1][2], v99[2][1], v99[2][2], v99[3][1], v99[3][2], p48, p49)
    end

    for i = #v96 + 1, #v97 do
        v97[i].A.Visible = false
        v97[i].B.Visible = false
    end

    p43.Triangles = v97
end

local function BuildStrokedPath(p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61) -- line: 455
    -- upvalues: Easing (copy), BezierShapeToPolyline (copy)
    local v101 = BezierShapeToPolyline(p51)

    if #v101 < 2 then
        return
    end

    local v102 = p50.Segments or {}

    p59 = p59 or 0
    p60 = p60 or 100
    p61 = p61 or 0

    local t9 = {
        0
    }
    local n5 = 0

    for i = 2, #v101 do
        local v107 = v101[i][1] - v101[i - 1][1]
        local v108 = v101[i][2] - v101[i - 1][2]

        n5 += math.sqrt(v107 * v107 + v108 * v108)
        t9[i] = n5
    end

    local t10

    if p58 then
        t10 = {}

        for _, v110 in p58 do
            if v110.v then
                table.insert(t10, Easing.EvaluateScalar(v110.v, 0))
            end
        end

        if not (#t10 > 0) then
            t10 = nil
        end
    end

    local v111 = p57 / math.min(p53, p54)
    local n6 = 0

    for i = 2, #v101 do
        local v113 = v101[i - 1]
        local v114 = v101[i]
        local v115 = v114[1] - v113[1]
        local v116 = v114[2] - v113[2]
        local v118 = math.sqrt(v115 * v115 + v116 * v116)

        if not (v118 < 0.01) then
            local v119 = ((t9[i - 1] + t9[i]) * 0.5 / math.max(n5, 1E-06) * 100 + p61) % 100

            if not (v119 < p59 or p60 < v119) then
                local v120

                if t10 then
                    local v121 = t9[i - 1]
                    local n7 = 0

                    for _, v122 in t10 do
                        n7 += v122
                    end

                    if n7 > 0 then
                        local v123 = v121 % n7
                        local n8 = 0

                        v120 = true

                        for v124, v125 in t10 do
                            n8 += v125

                            if v123 < n8 then
                                v120 = v124 % 2 == 1
                                break
                            end

                            v120 = true
                        end
                    else
                        v120 = true
                    end
                else
                    v120 = true
                end

                n6 += 1

                local Frame

                if n6 <= #v102 then
                    Frame = v102[n6]
                else
                    Frame = Instance.new("Frame")
                    Frame.BorderSizePixel = 0
                    Frame.AnchorPoint = Vector2.new(0, 0.5)
                    Frame.Parent = p52
                    table.insert(v102, Frame)
                end

                Frame.Visible = v120

                if v120 then
                    local v126 = math.atan2(v116, v115) * 57.29577951308232
                    local v127 = v118 / p53

                    Frame.Position = UDim2.fromScale(v113[1] / p53, v113[2] / p54)
                    Frame.Size = UDim2.fromScale(v127, v111)
                    Frame.Rotation = v126
                    Frame.BackgroundColor3 = p55
                    Frame.BackgroundTransparency = p56
                end
            end
        end
    end

    for i = n6 + 1, #v102 do
        v102[i].Visible = false
    end

    p50.Segments = v102
end

local function BuildLinearGradient(p62, p63, p64, p65, p66) -- line: 572
    -- upvalues: Easing (copy)
    local UIGradient = Instance.new("UIGradient")
    local p, k = p63.p, p63.k
    local v128 = Easing.EvaluateVector(k, p66, {})
    local t11 = {}

    for i = 0, p - 1 do
        local v129 = i * 4
        local v130 = v128[v129 + 1]

        if not v130 then
            v130 = i / math.max(p - 1, 1)
        end

        local v132 = v128[v129 + 2] or 1
        local v133 = v128[v129 + 3] or 1
        local v134 = v128[v129 + 4] or 1

        table.insert(t11, ColorSequenceKeypoint.new(math.clamp(v130, 0, 1), Color3.new(v132, v133, v134)))
    end

    if #t11 < 2 then
        t11 = {
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }
    end

    UIGradient.Color = ColorSequence.new(t11)

    local v136 = Easing.EvaluateVector(p64, p66, { 0, 0 })
    local v137 = Easing.EvaluateVector(p65, p66, { 1, 0 })
    local v138 = v137[1] - v136[1]

    UIGradient.Rotation = math.atan2(v137[2] - v136[2], v138) * 57.29577951308232
    UIGradient.Parent = p62

    return UIGradient
end

local function BuildRadialGradientApprox(p67, p68, p69, p70, p71, p72, p73) -- line: 612
    -- upvalues: Easing (copy)
    local p = p68.p
    local v140 = Easing.EvaluateVector(p68.k, p71, {})
    local v141 = Easing.EvaluateVector(p69, p71, {
        p72 / 2,
        p73 / 2
    })
    local v142 = Easing.EvaluateVector(p70, p71, {
        p72,
        p73 / 2
    })
    local v143 = v141[1]
    local v144 = v141[2]
    local v145 = v142[1] - v143
    local v146 = v142[2] - v144
    local v148 = math.sqrt(v145 * v145 + v146 * v146)
    local t12 = {}
    local v149 = math.min(p, 6)

    for i = v149, 1, -1 do
        local v150 = i / v149
        local v154 = math.min(math.floor(v150 * (p - 1)), p - 1) * 4
        local v155 = v140[v154 + 2] or 1
        local v156 = v140[v154 + 3] or 1
        local v157 = v140[v154 + 4] or 1
        local v158 = v148 * 2 * v150
        local Frame = Instance.new("Frame")

        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(v143 / p72, v144 / p73)
        Frame.Size = UDim2.fromScale(v158 / p72, v158 / p73)
        Frame.BackgroundColor3 = Color3.new(v155, v156, v157)
        Frame.BackgroundTransparency = 0
        Frame.BorderSizePixel = 0

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame
        Frame.Parent = p67
        table.insert(t12, Frame)
    end

    return t12
end

local function ApplyTransform(p74, p75, p76, p77, p78, p79, p80, p81) -- line: 662
    -- upvalues: Easing (copy)
    if p75 == nil then
        return
    end

    local v159 = {
        0, 0
    }
    local p = p75.p

    if p ~= nil and type(p) == "table" then
        if p.s == true then
            v159 = {
                Easing.EvaluateScalarAtFrame(p.x, p76, 0),
                (Easing.EvaluateScalarAtFrame(p.y, p76, 0))
            }
        else
            v159 = Easing.EvaluateVector(p, p76, { 0, 0 })
        end
    end

    local v160 = Easing.EvaluateVector(p75.s, p76, { 100, 100 })
    local v161 = Easing.EvaluateScalarAtFrame(p75.r, p76, 0)
    local v162 = Easing.EvaluateScalarAtFrame(p75.o, p76, 100)
    local v163 = Easing.EvaluateVector(p75.a, p76, { 0, 0 })
    local v164 = v160[1] / 100
    local v165 = v160[2] / 100

    p74.Position = UDim2.fromScale(v159[1] / p77, v159[2] / p78)
    p74.Rotation = v161
    p74.Size = UDim2.fromScale(p80 * v164, p81 * v165)

    if p79 then
        p74.GroupTransparency = 1 - v162 / 100
    end

    local v166 = p80 * v164 * p77
    local v167 = p81 * v165 * p78

    if (v163[1] ~= 0 or v163[2] ~= 0) and v166 > 0 and v167 > 0 then
        p74.AnchorPoint = Vector2.new(math.clamp(v163[1] / v166, 0, 1), (math.clamp(v163[2] / v167, 0, 1)))
    end
end

local function CollectShapeInfo(p82) -- line: 716
    local c, o, c2, o2, w, ks, da, s, e, o3, m, v171, mm

    for _, v172 in p82 do
        if not v172.hd then
            local ty = v172.ty

            if ty == "fl" then
                c = v172.c
                o = v172.o
            elseif ty == "st" then
                c2 = v172.c
                o2 = v172.o
                w = v172.w
                da = v172.da
            elseif ty == "sh" then
                ks = v172.ks
            elseif ty == "tr" then
                v171 = v172
            elseif ty == "tm" then
                s = v172.s
                e = v172.e
                o3 = v172.o
                m = v172.m
            elseif ty == "mm" then
                mm = v172.mm
            end
        end
    end

    return c, o, c2, o2, w, ks, da, s, e, o3, m, v171, mm
end

local function BuildShapeGroup(p83, p84, p85, p86, p87) -- line: 782
    -- upvalues: Easing (copy), v3 (copy), v4 (copy), BuildFilledPath (copy), BuildStrokedPath (copy), BuildLinearGradient (copy), BuildRadialGradientApprox (copy), ApplyTransform (copy), CollectShapeInfo (copy), BuildShapeGroup (copy)
    local v173 = p83.it or {}
    local v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, _, v184 = CollectShapeInfo(v173)
    local v185 = false

    for _, v186 in v173 do
        if v186.ty == "tr" then
            local o = v186.o

            if o ~= nil and o.a == 1 then
                v185 = true
                break
            end
        end
    end

    local v187 = if v185 then Instance.new("CanvasGroup") else Instance.new("Frame")

    v187.BackgroundTransparency = 1
    v187.BorderSizePixel = 0
    v187.Size = v4
    v187.Position = v3
    v187.Parent = p84

    if v184 then
        ApplyTransform(v187, {
            a = v184.a,
            p = v184.p,
            s = v184.s,
            r = v184.r,
            o = v184.o
        }, p87, p85, p86, v185, 1, 1)
    end

    local t14 = {
        Shape = p83,
        Frame = v187,
        Children = {},
        FillColor = v174,
        FillOpacity = v175,
        StrokeColor = v176,
        StrokeOpacity = v177,
        StrokeWidth = v178,
        PathData = v179,
        IsAnimatedPath = v179 ~= nil and v179.a == 1
    }
    local v188 = Easing.EvaluateColor(v174, p87)
    local v189 = 1 - Easing.EvaluateScalarAtFrame(v175, p87, 100) / 100
    local v190 = Easing.EvaluateColor(v176, p87)
    local v191 = 1 - Easing.EvaluateScalarAtFrame(v177, p87, 100) / 100
    local v192 = Easing.EvaluateScalarAtFrame(v178, p87, 0)
    local v193 = Easing.EvaluateScalarAtFrame(v181, p87, 0)
    local v194 = Easing.EvaluateScalarAtFrame(v182, p87, 100)
    local v195 = Easing.EvaluateScalarAtFrame(v183, p87, 0)
    local n9 = 0

    for _, v196 in v173 do
        if v196.ty == "op" and v196.a then
            n9 = Easing.EvaluateScalarAtFrame(v196.a, p87, 0)
        end
    end

    for _, v197 in v173 do
        if not v197.hd then
            local ty = v197.ty

            if ty == "sh" then
                local v198 = Easing.EvaluateBezierShape(v197.ks, p87)

                if v198 and n9 ~= 0 then
                    local n10 = 0
                    local n11 = 0

                    for _, v199 in v198.v do
                        n10 += v199[1]
                        n11 += v199[2]
                    end

                    local v200 = n10 / #v198.v
                    local v201 = n11 / #v198.v
                    local v204 = n9 / math.max(math.sqrt((v198.v[1][1] - v200) ^ 2 + (v198.v[1][2] - v201) ^ 2), 1) + 1
                    local v205 = table.create(#v198.v)

                    for v206, v207 in v198.v do
                        v205[v206] = {
                            v200 + (v207[1] - v200) * v204,
                            v201 + (v207[2] - v201) * v204
                        }
                    end

                    v198 = {
                        v = v205,
                        i = v198.i,
                        o = v198.o,
                        c = v198.c
                    }
                end

                if v198 then
                    if v174 then
                        BuildFilledPath(t14, v198, v187, p85, p86, v188, v189)
                    end

                    if v176 and v192 > 0 then
                        BuildStrokedPath(t14, v198, v187, p85, p86, v190, v191, v192, v180, v193, v194, v195)
                    end
                end
            elseif ty == "rc" then
                local Frame = Instance.new("Frame")

                Frame.BorderSizePixel = 0

                local v208 = Easing.EvaluateVector(v197.s, p87, { 100, 100 })
                local v209 = Easing.EvaluateVector(v197.p, p87, { 0, 0 })
                local v210 = Easing.EvaluateScalarAtFrame(v197.r, p87, 0)

                Frame.Size = UDim2.fromScale(v208[1] / p85, v208[2] / p86)
                Frame.Position = UDim2.fromScale(v209[1] / p85, v209[2] / p86)
                Frame.AnchorPoint = Vector2.new(0.5, 0.5)

                if v174 then
                    Frame.BackgroundColor3 = v188
                    Frame.BackgroundTransparency = v189
                else
                    Frame.BackgroundTransparency = 1
                end

                if v210 > 0 then
                    local UICorner = Instance.new("UICorner")

                    UICorner.CornerRadius = UDim.new(0, v210)
                    UICorner.Parent = Frame
                    t14.UICorner = UICorner
                end

                if v176 and v192 > 0 then
                    local UIStroke = Instance.new("UIStroke")

                    UIStroke.Color = v190
                    UIStroke.Transparency = v191
                    UIStroke.Thickness = v192 / math.min(p85, p86)
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                    local function v211() -- line: 928
                        -- upvalues: UIStroke (copy)
                        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
                    end

                    if not pcall(v211) then
                        UIStroke.Thickness = v192
                    end

                    UIStroke.Parent = Frame
                    t14.UIStroke = UIStroke
                end

                Frame.Parent = v187
                t14.Frame = Frame
            elseif ty == "el" then
                local Frame = Instance.new("Frame")

                Frame.BorderSizePixel = 0

                local v212 = Easing.EvaluateVector(v197.s, p87, { 100, 100 })
                local v213 = Easing.EvaluateVector(v197.p, p87, { 0, 0 })

                Frame.Size = UDim2.fromScale(v212[1] / p85, v212[2] / p86)
                Frame.Position = UDim2.fromScale(v213[1] / p85, v213[2] / p86)
                Frame.AnchorPoint = Vector2.new(0.5, 0.5)

                if v174 then
                    Frame.BackgroundColor3 = v188
                    Frame.BackgroundTransparency = v189
                else
                    Frame.BackgroundTransparency = 1
                end

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0.5, 0)
                UICorner.Parent = Frame
                t14.UICorner = UICorner

                if v176 and v192 > 0 then
                    local UIStroke = Instance.new("UIStroke")

                    UIStroke.Color = v190
                    UIStroke.Transparency = v191
                    UIStroke.Thickness = v192 / math.min(p85, p86)
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                    local function v214() -- line: 968
                        -- upvalues: UIStroke (copy)
                        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
                    end

                    pcall(v214)
                    UIStroke.Parent = Frame
                    t14.UIStroke = UIStroke
                end

                Frame.Parent = v187
                t14.Frame = Frame
            elseif ty == "gf" or ty == "gs" then
                local v215 = v197.t or 1

                if v197.g then
                    if v215 == 1 then
                        t14.UIGradient = BuildLinearGradient(v187, v197.g, v197.s, v197.e, p87)
                    elseif v215 == 2 then
                        BuildRadialGradientApprox(v187, v197.g, v197.s, v197.e, p87, p85, p86)
                    end
                end
            elseif ty == "gr" then
                local v216 = BuildShapeGroup(v197, v187, p85, p86, p87)

                if t14.Children then
                    table.insert(t14.Children, v216)
                end
            elseif ty == "rp" then
                local v217 = Easing.EvaluateScalarAtFrame(v197.c, p87, 1)
                local tr = v197.tr

                if tr and v217 > 1 then
                    local v218 = Easing.EvaluateScalarAtFrame(tr.so, p87, 100)
                    local v219 = Easing.EvaluateScalarAtFrame(tr.eo, p87, 100)

                    for i = 0, math.floor(v217) - 1 do
                        local Frame = Instance.new("Frame")

                        Frame.BackgroundTransparency = 1
                        Frame.BorderSizePixel = 0
                        Frame.Size = v4
                        Frame.BackgroundTransparency = 1 - math.lerp(v218, v219, i / math.max(v217 - 1, 1)) / 100

                        local _ = {
                            p = tr.p,
                            s = tr.s,
                            r = tr.r,
                            a = tr.a,
                            o = tr.o
                        }
                        local v222 = Easing.EvaluateVector(tr.p, p87, { 0, 0 })

                        Easing.EvaluateVector(tr.s, p87, { 100, 100 })

                        local v223 = Easing.EvaluateScalarAtFrame(tr.r, p87, 0)

                        Frame.Position = UDim2.fromScale(v222[1] * i / p85, v222[2] * i / p86)
                        Frame.Rotation = v223 * i
                        Frame.Parent = v187

                        for _, v224 in v173 do
                            if v224.ty == "gr" and v224 ~= p83 then
                                BuildShapeGroup(v224, Frame, p85, p86, p87)
                            end
                        end
                    end
                end
            end
        end
    end

    return t14
end

local function BuildShapeLayer(p88, p89, p90, p91, p92) -- line: 1038
    -- upvalues: BuildShapeGroup (copy)
    local shapes = p88.shapes

    if shapes == nil then
        return {}
    end

    local t15 = {}

    for i = #shapes, 1, -1 do
        local v225 = shapes[i]

        if not v225.hd and v225.ty == "gr" then
            table.insert(t15, (BuildShapeGroup(v225, p89, p90, p91, p92)))
        end
    end

    return t15
end

local function BuildTextLayer(p93, p94, _, p96, p97) -- line: 1059
    -- upvalues: v4 (copy)
    local t = p93.t

    if t == nil then
        return nil
    end

    local d = t.d

    if d == nil then
        return nil
    end

    local k = d.k

    if k == nil or #k == 0 then
        return nil
    end

    local s, s2

    for _, v227 in k do
        if v227.t == nil or v227.t <= p97 then
            s2 = v227.s
            s = s2
        end
    end

    if s2 == nil then
        s2 = k[1].s
        s = s2
    end

    if s2 == nil then
        return nil
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = v4
    TextLabel.Text = s2.t or ""
    TextLabel.TextScaled = false
    TextLabel.RichText = false
    TextLabel.TextSize = (s2.s or 24) / p96 * 100

    if s2.fc then
        local fc = s2.fc

        TextLabel.TextColor3 = Color3.new(fc[1] or 1, fc[2] or 1, fc[3] or 1)
    end

    local v228 = s2.j or 0

    if v228 == 0 then
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    elseif v228 == 1 then
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    else
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    TextLabel.TextYAlignment = Enum.TextYAlignment.Top

    if s2.f then
        local function v229() -- line: 1115
            -- upvalues: s (ref)
            return Enum.Font[s.f]
        end

        local ok, result = pcall(v229)

        if not ok or not result then
            TextLabel.Font = Enum.Font.GothamMedium
        else
            TextLabel.Font = result
        end
    end

    TextLabel.Parent = p94

    return TextLabel
end

local function BuildImageLayer(p98, p99, p100, _, _) -- line: 1129
    -- upvalues: AssetService (copy), EncodingService (copy), v4 (copy), result (ref)
    local refId = p98.refId

    if refId == nil then
        return nil
    end

    local v230 = p100[refId]

    if v230 == nil then
        return nil
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Size = v4
    ImageLabel.ScaleType = Enum.ScaleType.Stretch

    if v230.e ~= 1 or not v230.p then
        if v230.p and not v230.e then
            ImageLabel.Image = v230.p
        end
    else
        local p = v230.p

        if string.sub(p, 1, 22) == "data:image/png;base64," then
            local v231 = string.sub(p, 23)

            if result then
                local function v232() -- line: 1160
                    -- upvalues: v231 (copy), EncodingService (copy), result (ref)
                    local v233 = EncodingService:Base64Decode(buffer.fromstring(v231))

                    return result.decode(v233)
                end

                local ok, result2 = pcall(v232)

                if ok and result2 then
                    local function v234() -- line: 1167
                        -- upvalues: result2 (copy), AssetService (copy)
                        return AssetService:CreateEditableImage({
                            Size = Vector2.new(result2.width, result2.height)
                        })
                    end

                    local ok, result = pcall(v234)

                    if ok and result then
                        local function v235() -- line: 1171
                            -- upvalues: result2 (copy), result (copy)
                            result:WritePixelsBuffer(Vector2.zero, Vector2.new(result2.width, result2.height), result2.pixels)
                        end

                        if pcall(v235) then
                            ImageLabel.ImageContent = Content.fromObject(result)
                        end
                    end
                end
            end
        elseif string.sub(p, 1, 23) == "data:image/jpeg;base64," then
            warn("[Lottie] Embedded JPEG not supported, skipping image layer:", p98.nm or "")
        end
    end

    ImageLabel.Parent = p99

    return ImageLabel
end

local function BuildDropShadow(p103, p104, p105, p106, p107) -- line: 1195
    -- upvalues: Easing (copy), v2 (copy)
    local ef = p103.ef

    if ef ~= nil then
        for _, v236 in ef do
            if v236.ty == 25 then
                local ef = v236.ef

                if ef ~= nil then
                    local v237 = Color3.new(0, 0, 0)
                    local n12 = 0.5
                    local n13 = 0
                    local n14 = 5
                    local n15 = 5

                    for _, v238 in ef do
                        local ty = v238.ty

                        if ty ~= nil then
                            if ty == 1 then
                                v237 = Easing.EvaluateColor(v238.v, p107)
                            elseif ty == 0 then
                                n12 = Easing.EvaluateScalarAtFrame(v238.v, p107, 128) / 255
                            elseif ty == 3 then
                                n13 = Easing.EvaluateScalarAtFrame(v238.v, p107, 0)
                            elseif ty == 2 then
                                n14 = Easing.EvaluateScalarAtFrame(v238.v, p107, 5)
                            elseif ty == 4 then
                                n15 = Easing.EvaluateScalarAtFrame(v238.v, p107, 5)
                            end
                        end
                    end

                    local v240 = math.rad(n13 + 180)
                    local v241 = math.cos(v240) * n14 / p105
                    local v242 = math.sin(v240) * n14 / p106
                    local v243 = (n15 * 2 + math.max(p105, p106)) / math.max(p105, p106)
                    local ImageLabel = Instance.new("ImageLabel")

                    ImageLabel.Image = "rbxassetid://100849323991833"
                    ImageLabel.ScaleType = Enum.ScaleType.Slice
                    ImageLabel.SliceCenter = v2
                    ImageLabel.ImageColor3 = v237
                    ImageLabel.ImageTransparency = 1 - n12
                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.BorderSizePixel = 0
                    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    ImageLabel.Position = UDim2.fromScale(v241 + 0.5, v242 + 0.5)
                    ImageLabel.Size = UDim2.fromScale(v243, v243)
                    ImageLabel.ZIndex = -1
                    ImageLabel.Parent = p104

                    return
                end
            end
        end
    end
end

local function BuildLayers(p108, p109, p110, p111, p112, p113) -- line: 1260
    -- upvalues: Easing (copy), v4 (copy), ApplyTransform (copy), BuildShapeLayer (copy), BuildTextLayer (copy), BuildImageLayer (copy), BuildDropShadow (copy), BuildLayers (copy)
    local t16 = {}
    local t17 = {}

    for i = #p108, 1, -1 do
        local v244 = p108[i]

        if not v244.hd then
            local ty, ks = v244.ty, v244.ks
            local v245 = false

            if ks ~= nil then
                local o = ks.o

                v245 = o ~= nil and o.a == 1
            end

            local CanvasGroup

            if ty == 1 then
                local Frame = Instance.new("Frame")

                CanvasGroup = Frame
                Frame.BorderSizePixel = 0

                if v244.sc then
                    local sc = v244.sc
                    local v247 = tonumber(string.sub(sc, 2, 3), 16) or 0
                    local v249 = tonumber(string.sub(sc, 4, 5), 16) or 0
                    local v251 = tonumber(string.sub(sc, 6, 7), 16) or 0

                    Frame.BackgroundColor3 = Color3.fromRGB(v247, v249, v251)
                else
                    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                end

                Frame.BackgroundTransparency = 0
                Frame.Size = UDim2.fromScale((v244.sw or p111) / p111, (v244.sh or p112) / p112)
            else
                CanvasGroup = if v245 then Instance.new("CanvasGroup") else Instance.new("Frame")
                CanvasGroup.BackgroundTransparency = 1
                CanvasGroup.BorderSizePixel = 0
                CanvasGroup.Size = v4
            end

            CanvasGroup.Name = v244.nm or ("Layer_%*"):format(v244.ind or i)

            local Scale = CanvasGroup.Size.X.Scale
            local Scale2 = CanvasGroup.Size.Y.Scale
            local t18 = {
                Layer = v244,
                Frame = CanvasGroup,
                BaseSizeX = Scale,
                BaseSizeY = Scale2
            }

            if v244.ind then
                t17[v244.ind] = t18
            end

            if ty == 4 then
                t18.Shapes = BuildShapeLayer(v244, CanvasGroup, p111, p112, p113)
            elseif ty == 5 then
                t18.TextLabel = BuildTextLayer(v244, CanvasGroup, p111, p112, p113)
            elseif ty == 2 then
                t18.ImageLabel = BuildImageLayer(v244, CanvasGroup, p110, p111, p112)
            else
                local v252, w

                if ty == 0 then
                    local refId = v244.refId

                    if refId and p110[refId] then
                        v252 = p110[refId]

                        if v252.layers then
                            w = v244.w or v252.w or p111

                            local h = v244.h or v252.h or p112

                            CanvasGroup.ClipsDescendants = true
                            CanvasGroup.Size = UDim2.fromScale(w / p111, h / p112)
                            t18.Children = BuildLayers(v252.layers, CanvasGroup, p110, w, h, p113)
                        end
                    end
                end
            end

            BuildDropShadow(v244, CanvasGroup, p111, p112, p113)

            if v244.masksProperties then
                for _, v253 in v244.masksProperties do
                    if v253.mode == "a" or v253.mode == nil then
                        local v254 = Easing.EvaluateBezierShape(v253.pt, p113)

                        if v254 then
                            local n16 = 1e999
                            local n17 = 1e999
                            local n18 = (-1e999)
                            local n19 = (-1e999)

                            for _, v255 in v254.v do
                                n16 = math.min(n16, v255[1])
                                n17 = math.min(n17, v255[2])
                                n18 = math.max(n18, v255[1])
                                n19 = math.max(n19, v255[2])
                            end

                            local Frame = Instance.new("Frame")

                            Frame.BackgroundTransparency = 1
                            Frame.BorderSizePixel = 0
                            Frame.ClipsDescendants = true
                            Frame.Position = UDim2.fromScale(n16 / p111, n17 / p112)
                            Frame.Size = UDim2.fromScale((n18 - n16) / p111, (n19 - n17) / p112)
                            Frame.Parent = p109
                            CanvasGroup.Parent = Frame
                            t18.MatteClip = Frame
                        end
                    end
                end
            end

            ApplyTransform(CanvasGroup, v244.ks, p113, p111, p112, v245, Scale, Scale2)

            local v260 = p113 - (v244.st or 0)

            if v244.ip <= v260 then
                CanvasGroup.Visible = v260 < v244.op
            else
                CanvasGroup.Visible = false
            end

            table.insert(t16, t18)
        end
    end

    for _, v261 in t16 do
        local Layer = v261.Layer

        if Layer.parent and t17[Layer.parent] then
            local v262 = t17[Layer.parent]

            v261.Frame.Parent = v262.Frame
        elseif v261.MatteClip == nil then
            v261.Frame.Parent = p109
        end
    end

    for i = 1, #t16 - 1 do
        local v263 = t16[i]
        local v264 = t16[i + 1]

        if v264.Layer.tt then
            local v265

            for _, v266 in v263.Shapes or {} do
                if v266.PathData then
                    v265 = Easing.EvaluateBezierShape(v266.PathData, p113)
                    break
                end
            end

            if v265 then
                local n20 = 1e999
                local n21 = 1e999
                local n22 = (-1e999)
                local n23 = (-1e999)

                for _, v267 in v265.v do
                    n20 = math.min(n20, v267[1])
                    n21 = math.min(n21, v267[2])
                    n22 = math.max(n22, v267[1])
                    n23 = math.max(n23, v267[2])
                end

                local Frame = Instance.new("Frame")

                Frame.BackgroundTransparency = 1
                Frame.BorderSizePixel = 0
                Frame.ClipsDescendants = true
                Frame.Position = UDim2.fromScale(n20 / p111, n21 / p112)
                Frame.Size = UDim2.fromScale((n22 - n20) / p111, (n23 - n21) / p112)
                Frame.Parent = p109
                v264.Frame.Parent = Frame
                v264.MatteClip = Frame
                v263.Frame.Visible = false
            end
        end
    end

    return t16
end

local v272, RenderLayerNodes

local function RenderLayerNodes2(p114, p115, p116, p117) -- line: 1429
    -- upvalues: Easing (copy), ApplyTransform (copy), v272 (ref), RenderLayerNodes (ref)
    for _, v273 in p114 do
        local Layer = v273.Layer
        local v274 = p115 - (Layer.st or 0)
        local v275 = Layer.ip <= v274 and v274 < Layer.op

        v273.Frame.Visible = v275

        if v275 then
            local CanvasGroup = v273.Frame:IsA("CanvasGroup")

            ApplyTransform(v273.Frame, Layer.ks, v274, p116, p117, CanvasGroup, v273.BaseSizeX, v273.BaseSizeY)

            if v273.Shapes then
                for _, v276 in v273.Shapes do
                    v272(v276, v274, p116, p117)
                end
            end

            if v273.Children then
                local v277 = Layer.w or p116
                local v278 = Layer.h or p117
                local v279 = if Layer.tm then Easing.EvaluateScalarAtFrame(Layer.tm, v274, 0) * (Layer.op - Layer.ip) else v274

                RenderLayerNodes(v273.Children, v279, v277, v278)
            end

            if v273.TextLabel and Layer.t then
                local d = Layer.t.d

                if d and d.k then
                    local s

                    for _, v280 in d.k do
                        if v280.t == nil or v280.t <= v274 then
                            s = v280.s
                        end
                    end

                    if s then
                        v273.TextLabel.Text = s.t or ""

                        if s.fc then
                            v273.TextLabel.TextColor3 = Color3.new(s.fc[1] or 1, s.fc[2] or 1, s.fc[3] or 1)
                        end
                    end
                end
            end
        end
    end
end

RenderLayerNodes = RenderLayerNodes2

v272 = function(p118, p119, p120, p121) -- line: 1482
    -- upvalues: Easing (copy), BuildFilledPath (copy), BuildStrokedPath (copy), v272 (ref)
    if p118.Children then
        for _, v281 in p118.Children do
            v272(v281, p119, p120, p121)
        end
    end

    if not (p118.IsAnimatedPath and p118.PathData) then
        if p118.FillColor then
            local FillColor = p118.FillColor

            if FillColor ~= nil and FillColor.a == 1 then
                local v282 = Easing.EvaluateColor(p118.FillColor, p119)
                local v283 = 1 - Easing.EvaluateScalarAtFrame(p118.FillOpacity, p119, 100) / 100

                if p118.Triangles then
                    for _, v284 in p118.Triangles do
                        if v284.A.Visible then
                            v284.A.ImageColor3 = v282
                            v284.A.ImageTransparency = v283
                        end

                        if v284.B.Visible then
                            v284.B.ImageColor3 = v282
                            v284.B.ImageTransparency = v283
                        end
                    end
                end

                if p118.Frame and p118.Frame.BackgroundTransparency < 1 then
                    p118.Frame.BackgroundColor3 = v282
                    p118.Frame.BackgroundTransparency = v283
                end
            end
        end
    else
        local v285 = Easing.EvaluateBezierShape(p118.PathData, p119)

        if v285 and p118.Frame then
            local v286 = Easing.EvaluateColor(p118.FillColor, p119)
            local v287 = Easing.EvaluateScalarAtFrame(p118.FillOpacity, p119, 100)

            if p118.FillColor then
                BuildFilledPath(p118, v285, p118.Frame, p120, p121, v286, 1 - v287 / 100)
            end

            if p118.StrokeColor then
                local v288 = Easing.EvaluateColor(p118.StrokeColor, p119)
                local v289 = Easing.EvaluateScalarAtFrame(p118.StrokeOpacity, p119, 100)
                local v290 = Easing.EvaluateScalarAtFrame(p118.StrokeWidth, p119, 0)

                if v290 > 0 then
                    BuildStrokedPath(p118, v285, p118.Frame, p120, p121, v288, 1 - v289 / 100, v290)
                end
            end
        end
    end

    if p118.StrokeColor then
        local StrokeColor = p118.StrokeColor

        if StrokeColor ~= nil and StrokeColor.a == 1 then
            local v291 = Easing.EvaluateColor(p118.StrokeColor, p119)
            local v292 = Easing.EvaluateScalarAtFrame(p118.StrokeOpacity, p119, 100)

            if p118.Segments then
                for _, v293 in p118.Segments do
                    if v293.Visible then
                        v293.BackgroundColor3 = v291
                        v293.BackgroundTransparency = 1 - v292 / 100
                    end
                end
            end

            if p118.UIStroke then
                p118.UIStroke.Color = v291
                p118.UIStroke.Transparency = 1 - v292 / 100
            end
        end
    end
end

local function Parse(p122) -- line: 1551
    -- upvalues: HttpService (copy)
    return (HttpService:JSONDecode(p122))
end

local function Create(p123) -- line: 1555
    -- upvalues: v4 (copy), BuildLayers (copy)
    local w, h, ip, op = p123.w, p123.h, p123.ip, p123.op
    local fr = p123.fr
    local Frame = Instance.new("Frame")

    Frame.Name = p123.nm or "LottieAnimation"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Size = v4

    local t19 = {}

    if p123.assets then
        for _, v294 in p123.assets do
            t19[v294.id] = v294
        end
    end

    return {
        Animation = p123,
        Root = Frame,
        Layers = BuildLayers(p123.layers, Frame, t19, w, h, ip),
        AssetMap = t19,
        Duration = (op - ip) / fr,
        Width = w,
        Height = h
    }
end

local function Render(p124, p125) -- line: 1590
    -- upvalues: RenderLayerNodes2 (copy)
    local Animation = p124.Animation
    local ip, op, fr = Animation.ip, Animation.op, Animation.fr
    local v295 = op - ip
    local v296 = ip + p125 * fr % v295

    RenderLayerNodes2(p124.Layers, v296, p124.Width, p124.Height)
end

local function Destroy(p126) -- line: 1601
    p126.Root:Destroy()
    table.clear(p126.Layers)
    table.clear(p126.AssetMap)
end

return (table.freeze({
    Parse = Parse,
    Create = Create,
    Render = Render,
    Destroy = Destroy
}))

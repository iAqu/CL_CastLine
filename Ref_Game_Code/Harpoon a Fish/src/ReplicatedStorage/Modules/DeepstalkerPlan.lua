-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    REACH = 2.9,
    EMERGE = 0.9,
    LOAD = 0.45,
    HEAD_IN0 = 22,
    HEAD_IN1 = -5,
    HEAD_OUT = -15,
    HEAD_LOAD = -11,
    V_LAUNCH = 130,
    V_END = 40,
    RAMP = 0.1,
    DRAG = 1.2,
    V_BORE = 22,
    LIMBS = { "TentL", "TentR", "Arm3", "Arm2", "Arm4", "Arm1", "Arm5" },
    DELAY = {
        TentL = 0,
        TentR = 0.18,
        Arm3 = 0.55,
        Arm2 = 0.75,
        Arm4 = 0.9,
        Arm1 = 1.05,
        Arm5 = 1.2
    },
    DUR = {
        TentL = 1.55,
        TentR = 1.55,
        Arm3 = 1.35,
        Arm2 = 1.3,
        Arm4 = 1.3,
        Arm1 = 1.25,
        Arm5 = 1.2
    },
    LET_GO = {
        Arm5 = 0,
        Arm1 = 0,
        Arm2 = 0,
        Arm3 = 0,
        Arm4 = 0,
        TentR = 0.06,
        TentL = 0.08
    },
    GRIP_ARM = 5,
    GRIP_TENT = 8,
    N_ANG = 36,
    smooth = function(p1) -- smooth | line: 44
        local v1 = math.clamp(p1, 0, 1)

        return v1 * v1 * (3 - 2 * v1)
    end,
    smoother = function(p2) -- smoother | line: 49
        local v2 = math.clamp(p2, 0, 1)

        return v2 * v2 * v2 * (v2 * (v2 * 6 - 15) + 10)
    end,
    coveFrame = function(p3) -- coveFrame | line: 55
        local Unit = p3.Unit
        local Unit2 = (Vector3.new(0, 1, 0) - Unit * (Vector3.new(0, 1, 0)):Dot(Unit)).Unit

        return Unit, Unit:Cross(Unit2).Unit, Unit2
    end
}

function t1.launch() -- line: 63
    -- upvalues: t1 (copy)
    return t1.REACH + t1.EMERGE + t1.LOAD
end

function t1.headDepth(p4) -- line: 69
    -- upvalues: t1 (copy)
    if p4 <= t1.REACH then
        return t1.HEAD_IN0 + (t1.HEAD_IN1 - t1.HEAD_IN0) * t1.smooth(p4 / t1.REACH)
    end

    if p4 <= t1.REACH + t1.EMERGE then
        return t1.HEAD_IN1 + (t1.HEAD_OUT - t1.HEAD_IN1) * t1.smoother((p4 - t1.REACH) / t1.EMERGE)
    end

    return t1.HEAD_OUT + (t1.HEAD_LOAD - t1.HEAD_OUT) * t1.smooth((p4 - t1.REACH - t1.EMERGE) / t1.LOAD)
end

function t1.flightSpeed(p5) -- line: 80
    -- upvalues: t1 (copy)
    return (t1.V_END + (t1.V_LAUNCH - t1.V_END) * math.exp(-p5 * t1.DRAG)) * t1.smooth(p5 / t1.RAMP)
end

function t1.slerpDir(p6, p7, p8) -- line: 86
    if (p6 - p7).Magnitude < 1E-06 then
        return p6
    end

    local v5 = p6:Lerp(p7, p8)

    return v5.Magnitude > 1E-06 and v5.Unit or p6
end

function t1.bezier(p9, p10, p11, p12, p13) -- line: 92
    local v6 = 1 - p13

    return p9 * (v6 * v6 * v6) + p10 * (3 * v6 * v6 * p13) + p11 * (3 * v6 * p13 * p13) + p12 * (p13 * p13 * p13)
end

function t1.catmull(p14, p15) -- line: 98
    local t2 = {}
    local v7 = #p14
    local t3 = {
        p14[1] + (p14[1] - p14[2])
    }

    for i = 1, v7 do
        t3[i + 1] = p14[i]
    end

    t3[v7 + 2] = p14[v7] + (p14[v7] - p14[v7 - 1])

    for i = 2, v7 do
        local v8 = t3[i - 1]
        local v9 = t3[i]
        local v10 = t3[i + 1]
        local v11 = t3[i + 2]

        for j = 0, p15 - 1 do
            local v12 = j / p15
            local v13 = v12 * v12
            local v14 = v12 * v12 * v12

            t2[#t2 + 1] = 0.5 * (2 * v9 + (-v8 + v10) * v12 + (2 * v8 - 5 * v9 + 4 * v10 - v11) * v13 + (-v8 + 3 * v9 - 3 * v10 + v11) * v14)
        end
    end

    t2[#t2 + 1] = p14[v7]

    return t2
end

function t1.walk(p16, p17, p18) -- line: 117
    local t4 = {
        p16
    }
    local n1 = 1

    for _, v15 in ipairs(p18) do
        local v16 = t4[#t4]
        local v17

        while true do
            if n1 <= #p17 then
                if v15 <= (p17[n1] - v16).Magnitude then
                    v17 = p17[n1]
                    break
                end

                n1 += 1
                continue
            end

            v17 = nil
            break
        end

        local v18

        if v17 then
            v18 = (v17 - v16).Unit
        else
            local v19 = p17[#p17] - v16

            v18 = if v19.Magnitude > 1E-06 then v19.Unit elseif #t4 > 1 then (t4[#t4] - t4[#t4 - 1]).Unit else Vector3.new(-0, -1, -0)
        end

        t4[#t4 + 1] = v16 + v18 * v15
    end

    return t4
end

local function bezPts(p19, p20, p21, p22, p23, p24) -- line: 148
    -- upvalues: t1 (copy)
    for i = if #p24 > 0 then 1 else 0, p23 do
        p24[#p24 + 1] = t1.bezier(p19, p20, p21, p22, i / p23)
    end
end

local function polyLen(p25) -- line: 154
    local n2 = 0

    for i = 2, #p25 do
        n2 += (p25[i] - p25[i - 1]).Magnitude
    end

    return n2
end

function t1.arcLimb(p26, p27) -- line: 163
    -- upvalues: bezPts (copy)
    local function build(p28) -- line: 165
        -- upvalues: p26 (copy), bezPts (copy)
        local t5 = {}

        for i = 1, #p26 - 1 do
            local v21 = p26[i][1]
            local v22 = p26[i][2]
            local v23 = p26[i + 1][1]
            local v24 = p26[i + 1][2]
            local Magnitude = (v23 - v21).Magnitude

            bezPts(v21, v21 + v22 * (p28 * Magnitude), v23 - v24 * (p28 * Magnitude), v23, 12, t5)
        end

        return t5
    end

    local v25 = build(0)
    local n3 = 0

    for i = 2, #v25 do
        n3 += (v25[i] - v25[i - 1]).Magnitude
    end

    if p27 <= n3 then
        return v25, true
    end

    local v27 = build(1.4)
    local n4 = 0

    for i = 2, #v27 do
        n4 += (v27[i] - v27[i - 1]).Magnitude
    end

    if n4 < p27 then
        return v27, false
    end

    local n5 = 0
    local n6 = 1.4

    for _ = 1, 12 do
        local v29 = (n5 + n6) / 2
        local v30 = build(v29)
        local n7 = 0

        for i = 2, #v30 do
            n7 += (v30[i] - v30[i - 1]).Magnitude
        end

        if n7 < p27 then
            n5 = v29
        else
            n6 = v29
        end
    end

    return build((n5 + n6) / 2), false
end

function t1.rimScan(p29, p30, p31, p32) -- line: 190
    local n8 = 3
    local v32, v33, v34

    while true do
        if not (n8 <= 40) then
            return nil
        end

        v32, v33 = p32(p29 - p30 * 20 + p31 * n8, p30 * 40)

        local v35

        if v32 then
            v34 = (v32 - p29):Dot(p30)
            v35 = v34 < 18
        end

        if not v32 or not v35 then
            n8 += 1
            continue
        end

        break
    end

    return {
        r = n8,
        depth = v34,
        hit = v32,
        normal = v33
    }
end

function t1.grip(p33, p34, p35, p36, p37, p38) -- line: 204
    local v36, v37 = p38(p33 - p34 * 20 + p35 * (p36.r + p37), p34 * 40)

    if not v36 then
        v36 = p36.hit + p35 * p37
        v37 = p36.normal
    end

    return v36 + v37 * 0.6, v37, p33 + p35 * (p36.r - 1.2) + p34 * (p36.depth - 1.6)
end

function t1.assign(p39, p40, p41, p42, p43, p44) -- line: 215
    -- upvalues: t1 (copy)
    local N_ANG = t1.N_ANG
    local v38 = table.clone(p39)

    table.sort(v38, function(p45, p46) -- line: 218
        -- upvalues: p40 (copy)
        return p40[p45] < p40[p46]
    end)

    local v39 = #v38
    local v40 = N_ANG - 1
    local v41, t6

    for i = 0, v40 do
        for _, v42 in ipairs({ 1, -1 }) do
            local t7 = {}
            local n9 = 0

            for v43, v44 in ipairs(v38) do
                local v46 = (i + v42 * math.floor((v43 - 1) * N_ANG / v39 + 0.5)) % N_ANG

                if p43[v46 + 1] then
                    local v47 = p44[v46 + 1]
                    local v48 = (v47.lip - p42[v44]).Magnitude + (v47.a - v47.lip).Magnitude

                    n9 += 1 - math.cos(6.283185307179586 * v46 / N_ANG - p40[v44]) + math.max(0, v48 * 1.12 - p41[v44]) * 4 / p41[v44]
                    t7[v44] = v46
                else
                    n9 += 50
                end
            end

            if not v41 or n9 < v41 then
                t6 = t7
                v41 = n9
            end
        end
    end

    local v52 = table.clone(t6)
    local v53 = table.clone(p39)

    table.sort(v53, function(p47, p48) -- line: 241
        -- upvalues: p41 (copy)
        return p41[p47] > p41[p48]
    end)

    for _, v54 in ipairs(v53) do
        local v55 = v52[v54]

        if v55 then
            local v56 = v55
            local v57

            for j = -2, 2 do
                local v58 = (v55 + j) % N_ANG
                local v59 = p43[v58 + 1] ~= nil

                if v59 and v58 ~= v55 then
                    for v60, v61 in pairs(v52) do
                        if v60 ~= v54 and math.min((v58 - v61) % N_ANG, (v61 - v58) % N_ANG) < 3 then
                            v59 = false
                            break
                        end
                    end
                end

                local v64
                local v65 = v57
                local v66 = v56

                if v59 then
                    local v68 = p44[v58 + 1]

                    v64 = math.max(0, ((v68.lip - p42[v54]).Magnitude + (v68.a - v68.lip).Magnitude) * 1.12 - p41[v54]) / p41[v54] + math.abs(j) * 0.08

                    if not v57 or v64 < v57 then
                        v65 = v64
                        v66 = v58
                    end
                end

                v57 = v65
                v56 = v66
            end

            v52[v54] = v56
        end
    end

    return v52
end

return t1

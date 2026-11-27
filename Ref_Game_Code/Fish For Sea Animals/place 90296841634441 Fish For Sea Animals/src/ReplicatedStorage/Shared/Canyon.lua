-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    SEGMENT = 120,
    GROW = 40,
    RAMP = 18,
    SURFACE = -10
}

t1.WORLDS = {
    {
        Name = "Surface",
        First = 1,
        Count = 13,
        S = 0,
        Surface = t1.SURFACE
    },
    {
        Name = "Deep Sea",
        First = 14,
        Count = 10,
        S = 6000,
        Surface = -1000
    }
}
t1.COUNT = 0

for _, v1 in t1.WORLDS do
    t1.COUNT += v1.Count
end

t1.starts = {}
t1.lengths = {}

local t2 = {}
local t3 = {}
local n1 = 0
local v2 = t1.SURFACE

for v3, v4 in t1.WORLDS do
    if v3 > 1 then
        local v5 = (n1 + v4.S) / 2

        table.insert(t3, {
            gap = true,
            s0 = n1,
            s1 = v5,
            y0 = v2,
            y1 = v2,
            biome = v4.First - 1
        })
        table.insert(t3, {
            gap = true,
            s0 = v5,
            s1 = v4.S,
            y0 = v4.Surface,
            y1 = v4.Surface,
            biome = v4.First
        })
    end

    local S = v4.S

    n1 = S
    v2 = v4.Surface

    for i = 1, v4.Count do
        local v6 = v4.First + i - 1
        local v7 = t1.SEGMENT + t1.GROW * (i - 1)
        local v8 = (i - 1) * 0.006
        local v9 = (i - 1) * 1 + 3
        local starts, lengths = t1.starts, t1.lengths

        starts[v6] = n1
        lengths[v6] = v7

        local t6 = {}
        local v10 = n1 + v7
        local n2 = 1

        while t1.SEGMENT * n2 + t1.RAMP <= v7 - 20 do
            local v11 = t1.starts[v6] + t1.SEGMENT * n2
            local v12 = (v11 - n1) * v8

            if n1 + 1E-06 < v11 then
                S = v11
                table.insert(t6, {
                    ramp = false,
                    s0 = n1,
                    s1 = v11,
                    y0 = v2,
                    y1 = v2 - v12
                })
                n1 = v11
                v2 -= v12
            end

            S = v11 + t1.RAMP

            if n1 + 1E-06 < S then
                table.insert(t6, {
                    ramp = true,
                    s0 = n1,
                    s1 = S,
                    y0 = v2,
                    y1 = v2 - v9
                })
                n1 = S
                v2 -= v9
            end

            n2 += 1
        end

        local v13 = (v10 - n1) * v8

        if n1 + 1E-06 < v10 then
            S = v10
            table.insert(t6, {
                ramp = false,
                s0 = n1,
                s1 = v10,
                y0 = v2,
                y1 = v2 - v13
            })
            n1 = v10
            v2 -= v13
        end

        t2[v6] = t6
    end

    v4.Last = v4.First + v4.Count - 1
    v4.End = n1
    v4.EndY = v2
end

t1.END = n1

local t10 = {}
local n3 = 0
local COUNT = t1.COUNT
local n4 = 0
local n5 = 1

for i = 1, COUNT do
    while t3[n5] and t3[n5].s0 <= t1.starts[i] do
        local v14 = t3[n5]

        v14.area = n4
        n4 += v14.y0 * (v14.s1 - v14.s0)
        n3 = n4
        table.insert(t10, v14)
        n5 += 1
    end

    for _, v15 in t2[i] do
        v15.area = n4
        n4 += (v15.y0 + v15.y1) / 2 * (v15.s1 - v15.s0)
        n3 = n4
        table.insert(t10, v15)
    end
end

local function gapAt(p1) -- line: 101
    -- upvalues: t3 (copy)
    for _, v16 in t3 do
        if v16.s0 < p1 and p1 < v16.s1 then
            return v16
        end
    end

    return nil
end

local function integral(p2) -- line: 111
    -- upvalues: t1 (copy), t10 (copy), n3 (ref)
    if p2 <= 0 then
        return p2 * t1.SURFACE
    end

    for _, v17 in t10 do
        if p2 <= v17.s1 then
            local v18 = p2 - v17.s0
            local v19 = v17.y0 + (v17.y1 - v17.y0) * v18 / (v17.s1 - v17.s0)

            return v17.area + v18 * (v17.y0 + v19) / 2
        end
    end

    return n3 + (p2 - t1.END) * t10[#t10].y1
end

function t1.worldAt(p3) -- line: 126
    -- upvalues: t1 (copy)
    local n6 = 1

    for v20, v21 in t1.WORLDS do
        if v20 > 1 and (t1.WORLDS[v20 - 1].End + v21.S) / 2 <= p3 then
            n6 = v20
        end
    end

    return n6
end

function t1.worldOfBiome(p4) -- line: 137
    -- upvalues: t1 (copy)
    for v22, v23 in t1.WORLDS do
        if p4 <= v23.Last then
            return v22
        end
    end

    return #t1.WORLDS
end

function t1.pieces(p5) -- line: 146
    -- upvalues: t2 (copy)
    return t2[p5]
end

function t1.biomeAt(p6) -- line: 151
    -- upvalues: t1 (copy), t3 (copy)
    local v24 = false
    local v25

    for _, v26 in t3 do
        if v26.s0 < p6 and p6 < v26.s1 then
            v25 = v26
            v24 = true
            break
        end
    end

    if not v24 then
        v25 = nil
    end

    if v25 then
        return v25.biome
    end

    local n7 = 1

    for v27, v28 in t1.starts do
        if v28 <= p6 then
            n7 = v27
        end
    end

    return n7
end

function t1.surface(p7) -- line: 166
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v29 = false
    local v30

    for _, v31 in t3 do
        if v31.s0 < p7 and p7 < v31.s1 then
            v30 = v31
            v29 = true
            break
        end
    end

    if not v29 then
        v30 = nil
    end

    if v30 then
        return v30.y0
    end

    local v32 = t2[t1.biomeAt(p7)]

    for _, v33 in v32 do
        if p7 <= v33.s1 then
            local v35 = math.clamp((p7 - v33.s0) / (v33.s1 - v33.s0), 0, 1)

            return v33.y0 + (v33.y1 - v33.y0) * v35
        end
    end

    return v32[#v32].y1
end

function t1.glide(p8, p9) -- line: 184
    -- upvalues: t1 (copy), integral (copy)
    if p9 < 1 then
        return t1.surface(p8)
    end

    return (integral(p8) - integral(p8 - p9)) / p9
end

local t11 = {}

for i = 1, t1.COUNT do
    t11[t2[i][1]] = true
end

local t12 = {}

for _, v36 in t10 do
    if v36.gap or v36.ramp or t11[v36] then
        local v37 = t12[#t12]
        local v38 = if v37 then v37.area + (v37.y + v36.y0) / 2 * (v36.s0 - v37.s) else 0

        table.insert(t12, {
            s = v36.s0,
            y = v36.y0,
            area = v38
        })
    end
end

local function lipArea(p10, p11) -- line: 210
    -- upvalues: t1 (copy), t12 (copy)
    if p10 <= 0 then
        return p10 * t1.SURFACE
    end

    local n8 = 0
    local v39 = t1.SURFACE
    local n9 = 0

    local function upTo(p12, p13) -- line: 215
        -- upvalues: p10 (copy), n8 (ref), v39 (ref), n9 (ref)
        local v40 = v39 + (p13 - v39) * (p10 - n8) / (p12 - n8)

        return n9 + (p10 - n8) * (v39 + v40) / 2
    end

    for _, v41 in t12 do
        if p11 <= v41.s then
            break
        end

        if p10 <= v41.s then
            local s = v41.s
            local v42 = (v41.y - v39) * (p10 - n8) / (s - n8)
            local v43 = v39 + v42
            local v44 = (p10 - n8) * (v39 + v43) / 2

            return n9 + v44
        end

        n8 = v41.s
        v39 = v41.y
        n9 = v41.area
    end

    local v45 = t1.surface(p11)

    if p10 <= p11 then
        local v46 = (v45 - v39) * (p10 - n8) / (p11 - n8)
        local v47 = v39 + v46
        local v48 = (p10 - n8) * (v39 + v47) / 2

        return n9 + v48
    end

    local v49 = (p11 - n8) * (v39 + v45) / 2

    return n9 + v49 + (p10 - p11) * v45
end

function t1.flightLine(p14, p15, p16) -- line: 238
    -- upvalues: lipArea (copy)
    local v51 = math.clamp(p15 - p14, 0, p16)

    if v51 < 0.01 then
        v51 = 0.01
    end

    return (lipArea(p14, p15) - lipArea(p14 - v51, p15)) / v51
end

function t1.progress(p17) -- line: 248
    -- upvalues: t1 (copy)
    local v52 = t1.biomeAt(p17)

    return v52 - 1 + math.clamp((p17 - t1.starts[v52]) / t1.lengths[v52], 0, 1)
end

function t1.studsAt(p18) -- line: 253
    -- upvalues: t1 (copy)
    local v56 = math.clamp(math.floor(p18) + 1, 1, t1.COUNT)

    return t1.starts[v56] + math.clamp(p18 - (v56 - 1), 0, 1) * t1.lengths[v56]
end

function t1.dockS(p19) -- line: 259
    -- upvalues: t1 (copy)
    return t1.WORLDS[t1.worldAt(p19)].S
end

function t1.worldProgress(p20) -- line: 265
    -- upvalues: t1 (copy)
    local v59 = t1.WORLDS[t1.worldAt(p20)]

    return (math.max(t1.progress(p20) - (v59.First - 1), 0))
end

function t1.middle(p21) -- line: 271
    -- upvalues: t1 (copy)
    return t1.starts[p21] + t1.SEGMENT * 0.45
end

function t1.clearView(p22, p23) -- line: 280
    -- upvalues: t1 (copy), t10 (copy)
    local v61 = -p22.Z
    local v62 = -p23.Z
    local v64 = math.max(p22.Y, t1.surface(v61) + 3)

    if math.abs(v62 - v61) > 1 then
        local v66 = math.min(v61, v62)
        local v67 = math.max(v61, v62)

        for _, v69 in t10 do
            if v66 < v69.s0 and v69.s0 < v67 then
                local v70 = (v62 - v69.s0) / (v62 - v61)

                v64 = math.max(v64, p23.Y + (v69.y0 + 1.5 - p23.Y) / v70)
            end
        end
    end

    return (Vector3.new(p22.X, v64, p22.Z))
end

function t1.landing(p24) -- line: 302
    -- upvalues: t1 (copy), t2 (copy)
    local v72 = t1.WORLDS[t1.worldAt(p24)]
    local v74 = math.clamp(p24, v72.S, v72.End - 76)
    local v75 = t1.biomeAt(v74)
    local v76 = t1.starts[v75] + t1.lengths[v75] - 1

    for _, v77 in t2[v75] do
        if v77.ramp then
            local v78 = v77.s0 - 32
            local v79 = v77.s1 + 28

            if v78 < v74 and v74 < v79 then
                if not (v74 - v78 < v79 - v74) and not (v76 < v79) then
                    return v79
                end

                return v78
            end
        end
    end

    return v74
end

return t1

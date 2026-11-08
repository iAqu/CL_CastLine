-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function mixColour(p1, p2, p3) -- line: 18
    return Color3.new(p1.R + (p2.R - p1.R) * p3, p1.G + (p2.G - p1.G) * p3, p1.B + (p2.B - p1.B) * p3)
end

local function mixAlpha(p4, p5, p6) -- line: 26
    return p4 + (p5 - p4) * p6
end

local function earlierStop(p7, p8) -- line: 30
    return p7.Time < p8.Time
end

t1.Colour = {
    Blend = mixColour,
    Stop = function(p9, p10) -- Stop | line: 34
        return ColorSequenceKeypoint.new(p9, p10)
    end,
    Wrap = function(p11, p12) -- Wrap | line: 35
        return (p11 + p12) % 1
    end
}
t1.Alpha = {
    Blend = mixAlpha,
    Stop = function(p13, p14) -- Stop | line: 42
        return NumberSequenceKeypoint.new(p13, p14)
    end,
    Wrap = function(p15, p16) -- Wrap | line: 43
        local v1 = p15 + p16

        if v1 < 0 or v1 > 1 then
            return v1 % 1
        end

        return v1
    end
}

function t1.Sample(p17, p18, p19) -- line: 54
    local t2 = {}
    local v2 = p18 + 1

    for i = 0, 2 do
        for _, v3 in p17 do
            t2[#t2 + 1] = {
                Time = v3.Time + i,
                Value = v3.Value
            }
        end
    end

    for v4, v5 in t2 do
        local v6 = t2[v4 + 1]

        if not v6 then
            break
        end

        if v5.Time <= v2 and v2 < v6.Time then
            local v7 = (v2 - v5.Time) / (v6.Time - v5.Time)

            return p19.Blend(v5.Value, v6.Value, v7)
        end
    end

    return nil
end

function t1.Drift(p20, p21, p22, p23, p24) -- line: 82
    -- upvalues: t1 (copy), earlierStop (copy)
    local t3 = {}
    local v8 = p23
    local v9 = p24

    for _, v10 in p20 do
        local v11 = p21.Stop(p21.Wrap(v10.Time, p22), v10.Value)

        if v11.Time <= v9 then
            v8 -= 1
            t3[v8] = v11
            v9 = v11.Time
        else
            t3[#t3 + 1] = v11
        end
    end

    local t4 = {}

    for _, v12 in t3 do
        t4[#t4 + 1] = v12
    end

    table.sort(t4, earlierStop)

    if t4[1].Time ~= 0 then
        table.insert(t4, 1, p21.Stop(0, t1.Sample(t4, 0, p21)))
    end

    if t4[#t4].Time ~= 1 then
        t4[#t4 + 1] = p21.Stop(1, t1.Sample(t4, 1, p21))
    end

    return t4
end

function t1.Restripe(p25, p26, p27, p28) -- line: 125
    -- upvalues: t1 (copy)
    local t5 = {}
    local v13 = #p25 == #p26

    for _, v14 in p25 do
        local v15 = t1.Sample(p26, v14.Time, p28)

        if v13 then
            v15 = v15:Lerp(v14.Value, p27)
        end

        t5[#t5 + 1] = p28.Stop(v14.Time, v15)
    end

    return t5
end

return table.freeze(t1)

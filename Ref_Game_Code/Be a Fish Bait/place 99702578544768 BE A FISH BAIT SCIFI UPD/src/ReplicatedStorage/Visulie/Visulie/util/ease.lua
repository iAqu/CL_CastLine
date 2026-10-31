-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    InConst = function(p1) -- InConst | line: 22
        if p1 < 1 then
            return 0
        end

        return 1
    end,
    OutConst = function(p2) -- OutConst | line: 25
        if p2 < 1 then
            return 0
        end

        return 1
    end,
    InOutConst = function(p3) -- InOutConst | line: 28
        if p3 < 1 then
            return 0
        end

        return 1
    end,
    InLinear = function(p4) -- InLinear | line: 32
        return p4
    end,
    OutLinear = function(p5) -- OutLinear | line: 35
        return p5
    end,
    InOutLinear = function(p6) -- InOutLinear | line: 38
        return p6
    end,
    InQuad = function(p7) -- InQuad | line: 42
        return p7 * p7
    end,
    OutQuad = function(p8) -- OutQuad | line: 45
        return 1 - (1 - p8) * (1 - p8)
    end,
    InOutQuad = function(p9) -- InOutQuad | line: 48
        local v1 = p9 < 0.5
        local v2 = if v1 then p9 * 2 * p9 else nil

        if not v1 or not v2 then
            v2 = 1 - math.pow(p9 * -2 + 2, 2) / 2
        end

        return v2
    end,
    InCubic = function(p10) -- InCubic | line: 52
        return (math.pow(p10, 3))
    end,
    OutCubic = function(p11) -- OutCubic | line: 55
        return 1 - math.pow(1 - p11, 3)
    end,
    InOutCubic = function(p12) -- InOutCubic | line: 58
        local v5 = p12 < 0.5
        local v6 = if v5 then math.pow(p12, 3) * 4 else nil

        if not v5 or not v6 then
            v6 = 1 - math.pow(p12 * -2 + 2, 3) / 2
        end

        return v6
    end,
    InQuart = function(p13) -- InQuart | line: 62
        return (math.pow(p13, 4))
    end,
    OutQuart = function(p14) -- OutQuart | line: 65
        return 1 - math.pow(1 - p14, 4)
    end,
    InOutQuart = function(p15) -- InOutQuart | line: 68
        local v9 = p15 < 0.5
        local v10 = if v9 then math.pow(p15, 4) * 8 else nil

        if not v9 or not v10 then
            v10 = 1 - math.pow(p15 * -2 + 2, 4) / 2
        end

        return v10
    end,
    InQuint = function(p16) -- InQuint | line: 72
        return (math.pow(p16, 5))
    end,
    OutQuint = function(p17) -- OutQuint | line: 75
        return 1 - math.pow(1 - p17, 5)
    end,
    InOutQuint = function(p18) -- InOutQuint | line: 78
        local v13 = p18 < 0.5
        local v14 = if v13 then math.pow(p18, 5) * 16 else nil

        if not v13 or not v14 then
            v14 = 1 - math.pow(p18 * -2 + 2, 5) / 2
        end

        return v14
    end,
    InHexic = function(p19) -- InHexic | line: 82
        return (math.pow(p19, 6))
    end,
    OutHexic = function(p20) -- OutHexic | line: 85
        return 1 - math.pow(1 - p20, 6)
    end,
    InOutHexic = function(p21) -- InOutHexic | line: 88
        local v17 = p21 < 0.5
        local v18 = if v17 then math.pow(p21, 6) * 32 else nil

        if not v17 or not v18 then
            v18 = 1 - math.pow(p21 * -2 + 2, 6) / 2
        end

        return v18
    end,
    InSeptic = function(p22) -- InSeptic | line: 92
        return (math.pow(p22, 7))
    end,
    OutSeptic = function(p23) -- OutSeptic | line: 95
        return 1 - math.pow(1 - p23, 7)
    end,
    InOutSeptic = function(p24) -- InOutSeptic | line: 98
        local v21 = p24 < 0.5
        local v22 = if v21 then math.pow(p24, 7) * 64 else nil

        if not v21 or not v22 then
            v22 = 1 - math.pow(p24 * -2 + 2, 7) / 2
        end

        return v22
    end,
    InOctic = function(p25) -- InOctic | line: 102
        return (math.pow(p25, 8))
    end,
    OutOctic = function(p26) -- OutOctic | line: 105
        return 1 - math.pow(1 - p26, 8)
    end,
    InOutOctic = function(p27) -- InOutOctic | line: 108
        local v25 = p27 < 0.5
        local v26 = if v25 then math.pow(p27, 8) * 128 else nil

        if not v25 or not v26 then
            v26 = 1 - math.pow(p27 * -2 + 2, 8) / 2
        end

        return v26
    end,
    InCirc = function(p28) -- InCirc | line: 112
        return 1 - math.sqrt(1 - math.pow(p28, 2))
    end,
    OutCirc = function(p29) -- OutCirc | line: 115
        return (math.sqrt(1 - math.pow(p29 - 1, 2)))
    end,
    InOutCirc = function(p30) -- InOutCirc | line: 118
        local v31 = p30 < 0.5
        local v32 = if v31 then (1 - math.sqrt(1 - math.pow(p30 * 2, 2))) / 2 else nil

        if not v31 or not v32 then
            v32 = (math.sqrt(1 - math.pow(p30 * -2 + 2, 2)) + 1) / 2
        end

        return v32
    end,
    InExpo = function(p31) -- InExpo | line: 124
        if p31 == 0 then
            return 0
        end

        return (math.pow(2, p31 * 10 - 10))
    end,
    OutExpo = function(p32) -- OutExpo | line: 127
        if p32 == 1 then
            return 1
        end

        return 1 - math.pow(2, p32 * -10)
    end,
    InOutExpo = function(p33) -- InOutExpo | line: 130
        if p33 == 0 then
            return 0
        end

        if p33 == 1 then
            return 1
        end

        local v39 = p33 < 0.5
        local v40 = if v39 then math.pow(2, p33 * 20 - 10) / 2 else nil

        if not v39 or not v40 then
            v40 = (2 - math.pow(2, p33 * -20 + 10)) / 2
        end

        return v40
    end,
    InSine = function(p34) -- InSine | line: 139
        return 1 - math.cos(p34 * 3.141592653589793 / 2)
    end,
    OutSine = function(p35) -- OutSine | line: 142
        return (math.sin(p35 * 3.141592653589793 / 2))
    end,
    InOutSine = function(p36) -- InOutSine | line: 145
        return -(math.cos(3.141592653589793 * p36) - 1) / 2
    end,
    InBack = function(p37) -- InBack | line: 149
        return math.pow(p37, 3) * 2.70158 - math.pow(p37, 2) * 1.70158
    end,
    OutBack = function(p38) -- OutBack | line: 155
        return math.pow(p38 - 1, 3) * 2.70158 + 1 + math.pow(p38 - 1, 2) * 1.70158
    end,
    InOutBack = function(p39) -- InOutBack | line: 161
        local v49 = p39 < 0.5
        local v50 = if v49 then math.pow(p39 * 2, 2) * (p39 * 7.189819 - 2.5949095) / 2 else nil

        if not v49 or not v50 then
            v50 = (math.pow(p39 * 2 - 2, 2) * ((p39 * 2 - 2) * 3.5949095 + 2.5949095) + 2) / 2
        end

        return v50
    end
}

function t1.InBounce(p40) -- line: 170
    -- upvalues: t1 (copy)
    return 1 - t1.OutBounce(1 - p40)
end

function t1.OutBounce(p41) -- line: 173
    if p41 < 0.36363636363636365 then
        return math.pow(p41, 2) * 7.5625
    end

    if p41 < 0.7272727272727273 then
        return math.pow(p41 - 0.5454545454545454, 2) * 7.5625 + 0.75
    end

    if p41 < 0.9090909090909091 then
        return math.pow(p41 - 0.8181818181818182, 2) * 7.5625 + 0.9375
    end

    return math.pow(p41 - 0.9545454545454546, 2) * 7.5625 + 0.984375
end

function t1.InOutBounce(p42) -- line: 190
    -- upvalues: t1 (copy)
    return p42 < 0.5 and (1 - t1.OutBounce(1 - p42 * 2)) / 2 or (1 + t1.OutBounce(p42 * 2 - 1)) / 2
end

function t1.InElastic(p43) -- line: 197
    if p43 == 0 then
        return 0
    end

    if p43 == 1 then
        return 1
    end

    return -math.pow(2, p43 * 10 - 10) * math.sin((p43 * 10 - 10.75) * 2.0943951023931953)
end

function t1.OutElastic(p44) -- line: 206
    if p44 == 0 then
        return 0
    end

    if p44 == 1 then
        return 1
    end

    return math.pow(2, p44 * -10) * math.sin((p44 * 10 - 0.75) * 2.0943951023931953) + 1
end

function t1.InOutElastic(p45) -- line: 215
    if p45 == 0 then
        return 0
    end

    if p45 == 1 then
        return 1
    end

    local v62 = p45 < 0.5
    local v63 = if v62 then -(math.pow(2, p45 * 20 - 10) * math.sin((p45 * 20 - 11.125) * 1.3962634015954636)) / 2 else nil

    if not v62 or not v63 then
        v63 = math.pow(2, p45 * -20 + 10) * math.sin((p45 * 20 - 11.125) * 1.3962634015954636) / 2 + 1
    end

    return v63
end

return t1

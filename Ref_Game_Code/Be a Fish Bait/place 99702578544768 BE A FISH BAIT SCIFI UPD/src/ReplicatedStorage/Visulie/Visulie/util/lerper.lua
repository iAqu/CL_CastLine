-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function evalNumberSequence(p1, p2) -- line: 7
    if p2 == 0 then
        return p1.Keypoints[1].Value, p1.Keypoints[1].Envelope
    end

    if p2 == 1 then
        return p1.Keypoints[#p1.Keypoints].Value, p1.Keypoints[#p1.Keypoints].Envelope
    end

    for i = 1, #p1.Keypoints - 1 do
        local v1 = p1.Keypoints[i]
        local v2 = p1.Keypoints[i + 1]

        if v1.Time <= p2 and p2 < v2.Time then
            local v3 = (p2 - v1.Time) / (v2.Time - v1.Time)

            return v1.Value + (v2.Value - v1.Value) * v3, v1.Envelope + (v2.Envelope - v1.Envelope) * v3
        end
    end

    return 1, 1
end

local function evalColorSequence(p3, p4) -- line: 27
    if p4 == 0 then
        return p3.Keypoints[1].Value
    end

    if p4 == 1 then
        return p3.Keypoints[#p3.Keypoints].Value
    end

    for i = 1, #p3.Keypoints - 1 do
        local v4 = p3.Keypoints[i]
        local v5 = p3.Keypoints[i + 1]

        if v4.Time <= p4 and p4 < v5.Time then
            local v6 = (p4 - v4.Time) / (v5.Time - v4.Time)

            return v4.Value:Lerp(v5.Value, v6)
        end
    end

    return Color3.new(1, 1, 1)
end

local function constant(p5, p6, p7) -- line: 46
    if p7 < 1 then
        return p5
    end

    return p6
end

return {
    Axes = constant,
    BrickColor = constant,
    CFrame = function(p8, p9, p10) -- CFrame | line: 55
        return p8:Lerp(p9, p10)
    end,
    Color3 = function(p11, p12, p13) -- Color3 | line: 58
        return p11:Lerp(p12, p13)
    end,
    ColorSequence = function(p14, p15, p16) -- ColorSequence | line: 61
        -- upvalues: evalColorSequence (copy)
        local t2 = {}

        for _, v7 in p14.Keypoints do
            table.insert(t2, v7.Time)
        end

        for _, v8 in p15.Keypoints do
            if not table.find(t2, v8.Time) then
                table.insert(t2, v8.Time)
            end
        end

        table.sort(t2)

        local t3 = {}

        for _, v9 in t2 do
            table.insert(t3, ColorSequenceKeypoint.new(v9, evalColorSequence(p14, v9):Lerp(evalColorSequence(p15, v9), p16)))
        end

        return ColorSequence.new(t3)
    end,
    EnumItem = constant,
    Faces = constant,
    Instance = constant,
    NumberRange = function(p17, p18, p19) -- NumberRange | line: 90
        return NumberRange.new(math.lerp(p17.Min, p18.Min, p19), (math.lerp(p17.Max, p18.Max, p19)))
    end,
    NumberSequence = function(p20, p21, p22) -- NumberSequence | line: 96
        -- upvalues: evalNumberSequence (copy)
        local t4 = {}

        for _, v13 in p20.Keypoints do
            table.insert(t4, v13.Time)
        end

        for _, v14 in p21.Keypoints do
            if not table.find(t4, v14.Time) then
                table.insert(t4, v14.Time)
            end
        end

        table.sort(t4)

        local t5 = {}

        for _, v15 in t4 do
            local v16, v17 = evalNumberSequence(p20, v15)
            local v18, v19 = evalNumberSequence(p21, v15)

            table.insert(t5, NumberSequenceKeypoint.new(v15, math.lerp(v16, v18, p22), (math.lerp(v17, v19, p22))))
        end

        return NumberSequence.new(t5)
    end,
    Ray = constant,
    Rect = function(p23, p24, p25) -- Rect | line: 126
        return Rect.new(p23.Min:Lerp(p24.Min, p25), p23.Max:Lerp(p24.Max, p25))
    end,
    UDim = function(p26, p27, p28) -- UDim | line: 132
        return UDim.new(math.lerp(p26.Scale, p27.Scale, p28), (math.lerp(p26.Offset, p27.Offset, p28)))
    end,
    UDim2 = function(p29, p30, p31) -- UDim2 | line: 138
        return p29:Lerp(p30, p31)
    end,
    Vector2 = function(p32, p33, p34) -- Vector2 | line: 141
        return p32:Lerp(p33, p34)
    end,
    Vector3 = function(p35, p36, p37) -- Vector3 | line: 144
        return p35:Lerp(p36, p37)
    end,
    boolean = constant,
    number = math.lerp,
    ["nil"] = constant,
    string = constant
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function constant(p1) -- line: 7
    return p1
end

return {
    Axes = constant,
    BrickColor = constant,
    CFrame = function(p2, p3) -- CFrame | line: 16
        return p2 + p2.Position * (p3 - 1)
    end,
    Color3 = constant,
    ColorSequence = constant,
    EnumItem = constant,
    Faces = constant,
    Instance = constant,
    NumberRange = function(p4, p5) -- NumberRange | line: 24
        return NumberRange.new(p4.Min * p5, p4.Max * p5)
    end,
    NumberSequence = function(p6, p7) -- NumberSequence | line: 30
        local t1 = {}

        for _, v1 in p6.Keypoints do
            table.insert(t1, NumberSequenceKeypoint.new(v1.Time, v1.Value * p7, v1.Envelope * p7))
        end

        return NumberSequence.new(t1)
    end,
    Ray = constant,
    Rect = function(p8, p9) -- Rect | line: 45
        return Rect.new(p8.Min * p9, p8.Max * p9)
    end,
    UDim = function(p10, p11) -- UDim | line: 51
        return UDim.new(p10.Scale, p10.Offset * p11)
    end,
    UDim2 = function(p12, p13) -- UDim2 | line: 57
        return UDim2.new(p12.X.Scale, p12.X.Offset * p13, p12.Y.Scale, p12.Y.Offset * p13)
    end,
    Vector2 = function(p14, p15) -- Vector2 | line: 65
        return p14 * p15
    end,
    Vector3 = function(p16, p17) -- Vector3 | line: 68
        return p16 * p17
    end,
    boolean = constant,
    number = function(p18, p19) -- number | line: 74
        return p18 * p19
    end,
    ["nil"] = constant,
    string = constant
}

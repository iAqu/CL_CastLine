-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Loc = require(script.Parent:WaitForChild("Loc"))
local t1 = {
    stages = {
        "Baby",
        "Juvenile",
        "Adult",
        "Elder",
        "Ancient",
        "Archaic",
        "Eternal",
        "Primordial",
        "Primordial+"
    },
    colors = {
        Color3.fromRGB(150, 220, 255),
        Color3.fromRGB(110, 235, 110),
        Color3.fromRGB(255, 225, 80),
        Color3.fromRGB(255, 150, 60),
        Color3.fromRGB(240, 70, 70),
        Color3.fromRGB(190, 100, 255),
        Color3.fromRGB(255, 90, 190),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255)
    }
}

t1.ONLINE_SPEED = 1.2

local function hex(p1) -- line: 31
    return string.format("#%02X%02X%02X", math.floor(p1.R * 255 + 0.5), math.floor(p1.G * 255 + 0.5), (math.floor(p1.B * 255 + 0.5)))
end

function t1.Hex(p2) -- line: 35
    -- upvalues: t1 (copy), hex (copy)
    return hex(t1.colors[p2] or Color3.new(1, 1, 1))
end

local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 170, 40)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 240, 60)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 230, 90)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(70, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 80, 255))
})

t1.gradients = {
    [8] = v6,
    [9] = v6
}

local function sample(p3, p4) -- line: 55
    local Keypoints = p3.Keypoints

    for i = 1, #Keypoints - 1 do
        local v7 = Keypoints[i]
        local v8 = Keypoints[i + 1]

        if p4 <= v8.Time then
            return v7.Value:Lerp(v8.Value, (p4 - v7.Time) / math.max(v8.Time - v7.Time, 1E-06))
        end
    end

    return Keypoints[#Keypoints].Value
end

function t1.InfWord(p5) -- line: 70
    -- upvalues: Loc (copy)
    return Loc.T("INFINITE") .. " x" .. tostring(p5)
end

function t1.Span(p6, p7, p8) -- line: 71
    -- upvalues: Loc (copy), t1 (copy), sample (copy)
    local v11, v12

    if p8 and p8 > 0 then
        local v13 = t1.InfWord(p8)

        if v13 then
            v11 = v13
            v12 = true
        else
            v12 = false
        end
    else
        v12 = false
    end

    if not v12 then
        v11 = Loc.T(t1.stages[p6] or "")
    end

    local v14 = t1.gradients[p6]

    if not v14 then
        return string.format("<font color=\"%s\">%s</font>", t1.Hex(p6), v11)
    end

    if not p7 then
        return v11
    end

    local v15 = Loc.Letters(v11)

    if v15 then
        local t2 = {}
        local v16 = #v15

        for i = 1, v16 do
            local format = string.format
            local v17 = v16 > 1
            local v18 = if v17 then (i - 1) / (v16 - 1) else nil
            local v20 = sample(v14, if not v17 or not v18 then 0 else v18)

            t2[i] = format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.floor(v20.R * 255 + 0.5), math.floor(v20.G * 255 + 0.5), (math.floor(v20.B * 255 + 0.5))), v15[i])
        end

        return table.concat(t2)
    end

    local format = string.format
    local v26 = sample(v14, 0.5)

    return format("<font color=\"%s\">%s</font>", string.format("#%02X%02X%02X", math.floor(v26.R * 255 + 0.5), math.floor(v26.G * 255 + 0.5), (math.floor(v26.B * 255 + 0.5))), v11)
end

return t1

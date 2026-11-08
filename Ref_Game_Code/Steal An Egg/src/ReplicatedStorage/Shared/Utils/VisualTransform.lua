-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "Transparency"
}
local t2 = {
    BasePart = t1,
    Beam = t1,
    Decal = t1,
    GuiObject = { "BackgroundTransparency", "ImageTransparency", "TextStrokeTransparency", "TextTransparency" },
    ParticleEmitter = t1,
    Trail = t1,
    UIStroke = t1
}
local t3 = {}

for v1 in t2 do
    table.insert(t3, v1)
end

table.sort(t3)

local t4 = {}

local function channelsOf(p1) -- line: 40
    -- upvalues: t2 (copy), t3 (copy), t4 (copy)
    local v2 = t4[p1.ClassName]

    if v2 then
        return v2
    end

    local t5 = {}

    for _, v3 in t3 do
        if p1:IsA(v3) then
            for _, v4 in t2[v3] do
                local function v5() -- line: 49
                    -- upvalues: p1 (copy), v4 (copy)
                    return p1[v4]
                end

                if pcall(v5) then
                    table.insert(t5, v4)
                end
            end

            break
        end
    end

    t4[p1.ClassName] = t5

    return t5
end

local function asOpacity(p2) -- line: 63
    if typeof(p2) ~= "NumberSequence" then
        return 1 - p2
    end

    local t6 = {}

    for _, v6 in p2.Keypoints do
        table.insert(t6, {
            at = v6.Time,
            opacity = 1 - v6.Value,
            spread = v6.Envelope
        })
    end

    return t6
end

local function toward(p3, p4, p5) -- line: 74
    return p3 + (p4 - p3) * p5
end

local function transparencyOf(p6, p7, p8) -- line: 78
    if type(p6) == "number" then
        return 1 - (p6 + (p7 - p6) * p8)
    end

    local v7 = table.create(#p6)

    for v8, v9 in p6 do
        local opacity = v9.opacity
        local v10 = opacity + (p7 - opacity) * p8
        local v13 = math.max(0, (math.min(v10, 1 - v10)))

        v7[v8] = NumberSequenceKeypoint.new(v9.at, 1 - v10, (math.clamp(v9.spread, 0, v13)))
    end

    return NumberSequence.new(v7)
end

local t8 = {}

t8.__index = t8

local function looksOf(p9, p10) -- line: 94
    -- upvalues: channelsOf (copy), asOpacity (copy)
    local v15 = p9.looks[p10]

    if v15 == nil then
        v15 = {}

        for _, v16 in channelsOf(p10) do
            table.insert(v15, {
                property = v16,
                opacity = asOpacity(p10[v16])
            })
        end

        p9.looks[p10] = v15
    end

    return v15
end

local function skipped(p11, p12, p13) -- line: 106
    if p13 == nil then
        return false
    end

    local v17 = p11

    while true do
        if v17 == nil then
            return false
        end

        if table.find(p13, v17.ClassName) == nil then
            if v17 == p12 then
                return false
            end

            v17 = v17.Parent
            continue
        end

        break
    end

    return true
end

local function subjectsUnder(p14, p15) -- line: 123
    -- upvalues: skipped (copy)
    local t10 = {}

    if not skipped(p14, p14, p15) then
        table.insert(t10, p14)
    end

    for _, descendant in p14:GetDescendants() do
        if not skipped(descendant, p14, p15) then
            table.insert(t10, descendant)
        end
    end

    return t10
end

function t8.Blend(p16, p17, p18, p19, p20) -- line: 136
    -- upvalues: transparencyOf (copy), looksOf (copy), subjectsUnder (copy)
    for _, v18 in subjectsUnder(p17, p20) do
        for _, v19 in looksOf(p16, v18) do
            v18[v19.property] = transparencyOf(v19.opacity, p18, p19)
        end
    end
end

function t8.Hide(p21, p22, p23, p24) -- line: 144
    -- upvalues: t8 (copy)
    t8.Blend(p21, p22, 0, p23, p24)
end

local t11 = {
    Fader = function() -- Fader | line: 150
        -- upvalues: t8 (copy)
        return (setmetatable({
            looks = setmetatable({}, {
                __mode = "k"
            })
        }, t8))
    end
}

return table.freeze(t11)

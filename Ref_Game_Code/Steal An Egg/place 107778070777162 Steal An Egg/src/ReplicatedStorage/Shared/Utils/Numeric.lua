-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function isFinite(p1) -- line: 15
    return math.abs(p1) < 1e999
end

local function isFiniteVector(p2) -- line: 19
    return math.abs(math.abs(p2.X) + math.abs(p2.Y) + math.abs(p2.Z)) < 1e999
end

local function weightAt(p3, p4) -- line: 23
    local v4 = p3[p4][2]

    if type(v4) ~= "number" then
        error((("weighted entry #%* carries a %* where a numeric weight belongs"):format(p4, (typeof(v4)))))
    end

    if v4 > 0 and v4 < 1e999 then
        return v4
    end

    return 0
end

local function cumulativeWeights(p5) -- line: 31
    local v5 = table.create(#p5)
    local n1 = 0

    for i = 1, #p5 do
        local v7 = p5[i][2]

        if type(v7) ~= "number" then
            error((("weighted entry #%* carries a %* where a numeric weight belongs"):format(i, (typeof(v7)))))
        end

        if not (v7 > 0 and v7 < 1e999) then
            v7 = 0
        end

        n1 += v7
        v5[i] = n1
    end

    return v5, n1
end

local function positionAbove(p6, p7) -- line: 41
    local v8 = 1
    local v9 = #p6

    while v8 < v9 do
        local v10 = (v8 + v9) // 2

        if p7 < p6[v10] then
            v9 = v10
        else
            v8 = v10 + 1
        end
    end

    return v8
end

function t1.IsFiniteCFrame(p8) -- line: 54
    local Position = p8.Position
    local v14 = math.abs(math.abs(Position.X) + math.abs(Position.Y) + math.abs(Position.Z)) < 1e999

    if not v14 then
        return v14
    end

    local XVector = p8.XVector
    local v18 = math.abs(math.abs(XVector.X) + math.abs(XVector.Y) + math.abs(XVector.Z)) < 1e999

    if not v18 then
        return v18
    end

    local YVector = p8.YVector
    local v22 = math.abs(math.abs(YVector.X) + math.abs(YVector.Y) + math.abs(YVector.Z)) < 1e999

    if not v22 then
        return v22
    end

    local ZVector = p8.ZVector

    return math.abs(math.abs(ZVector.X) + math.abs(ZVector.Y) + math.abs(ZVector.Z)) < 1e999
end

function t1.DrawWeighted(p9, p10) -- line: 61
    -- upvalues: cumulativeWeights (copy), positionAbove (copy)
    local v26, v27 = cumulativeWeights(p9)

    if v27 <= 0 then
        return nil
    end

    local v29 = positionAbove(v26, (p10 or Random.new()):NextNumber() * v27)
    local t2 = {
        Value = p9[v29][1],
        Index = v29
    }
    local v30 = p9[v29][2]

    if type(v30) ~= "number" then
        error((("weighted entry #%* carries a %* where a numeric weight belongs"):format(v29, (typeof(v30)))))
    end

    t2.Weight = if not (v30 > 0 and v30 < 1e999) then 0 else v30

    return t2
end

function t1.RollWeighted(p11, p12) -- line: 75
    -- upvalues: t1 (copy)
    local v31 = t1.DrawWeighted(p11, p12)

    return if v31 ~= nil then v31.Value else nil
end

function t1.Shuffle(p13, p14) -- line: 80
    (p14 or Random.new()):Shuffle(p13)

    return p13
end

return table.freeze(t1)

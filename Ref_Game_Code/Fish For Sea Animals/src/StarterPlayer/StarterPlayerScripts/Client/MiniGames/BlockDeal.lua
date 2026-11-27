-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local BlockPieces = require(script.Parent.BlockPieces)
local t1 = {}
local t2 = {}

local function randomShape(p1) -- line: 15
    -- upvalues: BlockPieces (copy)
    local v1 = BlockPieces[math.random(p1 or #BlockPieces)]

    return v1[math.random(#v1)]
end

local function maskOf(p2) -- line: 20
    -- upvalues: t2 (copy)
    local v2 = t2[p2]

    if not v2 then
        local n1 = 0
        local n2 = 0

        for _, v3 in p2 do
            n1 = math.max(n1, v3[1] + 1)
            n2 = math.max(n2, v3[2] + 1)
        end

        v2 = {
            rows = table.create(n1, 0),
            h = n1,
            w = n2
        }

        for _, v6 in p2 do
            v2.rows[v6[1] + 1] = bit32.bor(v2.rows[v6[1] + 1], (bit32.lshift(1, v6[2])))
        end

        t2[p2] = v2
    end

    return v2
end

local function drop(p3, p4, p5, p6) -- line: 39
    for i = 1, p4.h do
        if bit32.band(p3[p5 + i - 1], (bit32.lshift(p4.rows[i], p6 - 1))) ~= 0 then
            return nil
        end
    end

    local v15 = table.clone(p3)

    for i = 1, p4.h do
        v15[p5 + i - 1] = bit32.bor(v15[p5 + i - 1], (bit32.lshift(p4.rows[i], p6 - 1)))
    end

    local v36 = bit32.band(bit32.band(bit32.band(bit32.band(bit32.band(bit32.band(bit32.band(bit32.band(255, v15[1]), v15[2]), v15[3]), v15[4]), v15[5]), v15[6]), v15[7]), v15[8])

    for i = 1, 8 do
        if v15[i] == 255 then
            v15[i] = 0
        else
            v15[i] = bit32.band(v15[i], (bit32.bnot(v36)))
        end
    end

    return v15
end

local function placeable(p7, p8, p9) -- line: 60
    -- upvalues: drop (copy), placeable (copy)
    if #p8 == 0 then
        return true
    end

    local t3 = {}

    for v39, v40 in p8 do
        if not t3[v40] then
            t3[v40] = true

            local v41 = table.clone(p8)

            table.remove(v41, v39)

            for i = 1, 8 - v40.h + 1 do
                for j = 1, 8 - v40.w + 1 do
                    local v42 = drop(p7, v40, i, j)

                    if v42 then
                        p9.left -= 1

                        if p9.left <= 0 then
                            return false
                        end

                        if placeable(v42, v41, p9) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

function t1.deal(p10) -- line: 91
    -- upvalues: BlockPieces (copy), maskOf (copy), placeable (copy)
    for i = 1, 40 do
        local v43 = if i > 25 then 6 else nil
        local v44 = BlockPieces[math.random(v43 or #BlockPieces)]
        local v45 = v44[math.random(#v44)]
        local v46 = BlockPieces[math.random(v43 or #BlockPieces)]
        local v47 = v46[math.random(#v46)]
        local v48 = BlockPieces[math.random(v43 or #BlockPieces)]
        local t4 = {
            v45,
            v47,
            v48[math.random(#v48)]
        }

        if placeable(p10, {
            maskOf(t4[1]),
            maskOf(t4[2]),
            (maskOf(t4[3]))
        }, {
            left = 4000
        }) then
            return t4
        end
    end

    local v50 = BlockPieces[1][1]

    return { v50, v50, v50 }
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function MatClone(p1) -- line: 23
    local v1 = table.clone(p1)

    for i = 1, #v1 do
        v1[i] = table.clone(v1[i])
    end

    return v1
end

local function MatZero(p2) -- line: 31
    local v2 = table.create(p2)

    for i = 1, p2 do
        v2[i] = table.create(p2, 0)
    end

    return v2
end

local function MatIdent(p3) -- line: 39
    -- upvalues: MatZero (copy)
    local v3 = MatZero(p3)

    for i = 1, p3 do
        v3[i][i] = 1
    end

    return v3
end

local function MatMul(p4, p5) -- line: 47
    local t1 = {}
    local v4 = #p4
    local v5 = #p4[1]
    local v6 = #p5[1]

    for i = 1, v4 do
        local v7 = table.create(v6, 0)

        for j = 1, v6 do
            local n1 = 0

            for k = 1, v5 do
                n1 = bit32.bxor(n1, (bit32.band(p4[i][k], p5[k][j])))
            end

            v7[j] = n1
        end

        t1[i] = v7
    end

    return t1
end

local function MatMulVec(p6, p7) -- line: 64
    local v11 = #p6
    local v12 = #p6[1]
    local v13 = table.create(v11, 0)

    for i = 1, v11 do
        local n2 = 0

        for j = 1, v12 do
            n2 = bit32.bxor(n2, (bit32.band(p6[i][j], p7[j])))
        end

        v13[i] = n2
    end

    return v13
end

local function MatSum(p8, p9) -- line: 77
    -- upvalues: MatZero (copy)
    local v17 = #p8
    local v18 = #p8[1]
    local v19 = MatZero(v17)

    for i = 1, v17 do
        for j = 1, v18 do
            v19[i][j] = bit32.bxor(p8[i][j], p9[i][j])
        end
    end

    return v19
end

local function MatInverse(p10) -- line: 88
    -- upvalues: MatClone (copy), MatZero (copy)
    local v23 = #p10
    local v24 = MatClone(p10)
    local v25 = MatZero(v23)

    for i = 1, v23 do
        v25[i][i] = 1
    end

    for i = 1, v23 do
        local v26

        for j = i, v23 do
            if v24[j][i] == 1 then
                v26 = j
                break
            end
        end

        assert(v26, "not invertible")

        local v27 = v24[v26]
        local v28 = v24[i]

        v24[i] = v27
        v24[v26] = v28

        local v29 = v25[v26]
        local v30 = v25[i]

        v25[i] = v29
        v25[v26] = v30

        for k = 1, v23 do
            if k ~= i and v24[k][i] == 1 then
                for n = 1, v23 do
                    v24[k][n] = bit32.bxor(v24[k][n], v24[i][n])
                    v25[k][n] = bit32.bxor(v25[k][n], v25[i][n])
                end
            end
        end
    end

    return v25
end

local function MatPow(p11, p12) -- line: 115
    -- upvalues: MatClone (copy), MatZero (copy), MatMul (copy), MatInverse (copy)
    local v37 = #p11
    local v38 = MatZero(v37)

    for i = 1, v37 do
        v38[i][i] = 1
    end

    local v39 = if p12 < 0 then MatInverse(p11) else MatClone(p11)
    local v40 = math.abs(p12)

    while v40 > 0 do
        if math.fmod(v40, 2) >= 0.5 then
            v38 = MatMul(v38, v39)
        end

        v39 = MatMul(v39, v39)
        v40 = math.floor(v40 / 2)
    end

    return v38
end

local function L(p13, p14) -- line: 130
    -- upvalues: MatZero (copy)
    local v42 = MatZero(p14)

    for i = 1, p14 - p13 do
        v42[i][i + p13] = 1
    end

    return v42
end

local function R(p15, p16) -- line: 138
    -- upvalues: MatZero (copy)
    local v43 = MatZero(p16)

    for i = p15 + 1, p16 do
        v43[i][i - p15] = 1
    end

    return v43
end

local function Embed(p17, p18, p19, p20) -- line: 146
    -- upvalues: MatZero (copy)
    local v44 = MatZero(p18)

    for i = 1, #p17 do
        for j = 1, #p17[1] do
            v44[p19 + i][p20 + j] = p17[i][j]
        end
    end

    return v44
end

local function ToColumnVector128(p21, p22, p23, p24) -- line: 156
    local v45 = table.create(128, 0)

    for i = 0, 31 do
        local v46 = bit32.rshift(p21, i)

        v45[32 - i] = bit32.band(v46, 1)

        local v47 = bit32.rshift(p22, i)

        v45[64 - i] = bit32.band(v47, 1)

        local v48 = bit32.rshift(p23, i)

        v45[96 - i] = bit32.band(v48, 1)

        local v49 = bit32.rshift(p24, i)

        v45[128 - i] = bit32.band(v49, 1)
    end

    return v45
end

local function FromColumnVector128(p25) -- line: 167
    local n3 = 0
    local n4 = 0
    local n5 = 0
    local n6 = 0

    for i = 0, 31 do
        n3 = bit32.bor(n3, (bit32.lshift(p25[32 - i], i)))
        n4 = bit32.bor(n4, (bit32.lshift(p25[64 - i], i)))
        n5 = bit32.bor(n5, (bit32.lshift(p25[96 - i], i)))
        n6 = bit32.bor(n6, (bit32.lshift(p25[128 - i], i)))
    end

    return n3, n4, n5, n6
end

local v67 = (function() -- BuildMatTransform | line: 178
    -- upvalues: MatIdent (copy), MatMul (copy), MatSum (copy), L (copy), R (copy), Embed (copy)
    local v58 = MatIdent(32)
    local v59 = MatIdent(128)
    local v61 = MatMul(MatSum(v59, (Embed(L(11, 32), 128, 0, 0))), v59)
    local v63 = MatMul(MatSum(v59, (Embed(R(8, 32), 128, 0, 0))), v61)
    local v64 = MatMul(MatSum(v59, (Embed(v58, 128, 0, 96))), v63)
    local v66 = MatMul(MatSum(v59, (Embed(R(19, 32), 128, 0, 96))), v64)

    return (MatMul(MatSum(L(32, 128), (R(96, 128))), v66))
end)()

local function MatTransform() -- line: 211
    -- upvalues: MatClone (copy), v67 (copy)
    return (MatClone(v67))
end

local t2 = {
    ToColumnVector128 = ToColumnVector128,
    FromColumnVector128 = FromColumnVector128,
    MatTransform = MatTransform,
    Transform = function(p26, p27, p28, p29, p30) -- Transform | line: 215
        -- upvalues: MatClone (copy), MatMulVec (copy), MatPow (copy), ToColumnVector128 (copy), FromColumnVector128 (copy), v67 (copy)
        local v68 = ToColumnVector128(p26, p27, p28, p29)

        return FromColumnVector128((MatMulVec(MatPow(MatClone(v67), p30), v68)))
    end
}

return table.freeze(t2)

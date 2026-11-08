-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local bxor, copy, create, len = bit32.bxor, buffer.copy, buffer.create, buffer.len
local readu8, readu32, _, writestring = buffer.readu8, buffer.readu32, buffer.tostring, buffer.writestring
local writeu8, writeu32, _, random = buffer.writeu8, buffer.writeu32, math.floor, math.random
local pack = string.pack
local v1 = create(16)

local function addByteCtr(p1, p2, p3, p4, p5) -- line: 44
    -- upvalues: readu8 (copy), writeu8 (copy)
    if p5 then
        local v2 = readu8(p1, p3) + p2

        writeu8(p1, p3, v2)

        if v2 >= 256 then
            for i = p3 + 1, p4 do
                local v3 = readu8(p1, i) + 1

                writeu8(p1, i, v3)

                if v3 < 256 then
                    break
                end
            end
        end
    else
        local v4 = readu8(p1, p4) + p2

        writeu8(p1, p4, v4)

        if v4 >= 256 then
            for i = p4 - 1, p3, -1 do
                local v5 = readu8(p1, i) + 1

                writeu8(p1, i, v5)

                if v5 < 256 then
                    break
                end
            end
        end
    end
end

local t1 = {}

t1.ECB = {
    FwdMode = function(p6, _, p8, p9) -- FwdMode | line: 81
        -- upvalues: len (copy)
        local v6 = len(p8) - 16

        assert(v6 % 16 == 0, "Input length must be a multiple of 16 bytes")

        for i = 0, v6, 16 do
            p6(p8, i, p9, i)
        end
    end,
    InvMode = function(_, p11, p12, p13) -- InvMode | line: 88
        -- upvalues: len (copy)
        local v8 = len(p12) - 16

        assert(v8 % 16 == 0, "Input length must be a multiple of 16 bytes")

        for i = 0, v8, 16 do
            p11(p12, i, p13, i)
        end
    end
}
table.freeze(t1.ECB)
t1.CBC = {
    FwdMode = function(p14, _, p16, p17, _, p19) -- FwdMode | line: 105
        -- upvalues: bxor (copy), len (copy), readu32 (copy), writeu32 (copy), v1 (copy)
        local v10 = len(p16) - 16

        assert(v10 % 16 == 0, "Input length must be a multiple of 16 bytes")
        p19 = p19 or v1
        assert(len(p19) == 16, "Initialization vector must be 16 bytes long")
        writeu32(p17, 0, (bxor(readu32(p16, 0), (readu32(p19, 0)))))
        writeu32(p17, 4, (bxor(readu32(p16, 4), (readu32(p19, 4)))))
        writeu32(p17, 8, (bxor(readu32(p16, 8), (readu32(p19, 8)))))
        writeu32(p17, 12, (bxor(readu32(p16, 12), (readu32(p19, 12)))))
        p14(p17, 0, p17, 0)

        for i = 16, v10, 16 do
            writeu32(p17, i, (bxor(readu32(p16, i), (readu32(p17, i - 16)))))

            local v31 = bxor(readu32(p16, i + 4), (readu32(p17, i - 12)))

            writeu32(p17, i + 4, v31)

            local v34 = bxor(readu32(p16, i + 8), (readu32(p17, i - 8)))

            writeu32(p17, i + 8, v34)

            local v37 = bxor(readu32(p16, i + 12), (readu32(p17, i - 4)))

            writeu32(p17, i + 12, v37)
            p14(p17, i, p17, i)
        end
    end,
    InvMode = function(_, p21, p22, p23, _, p25) -- InvMode | line: 123
        -- upvalues: bxor (copy), len (copy), readu32 (copy), writeu32 (copy), v1 (copy)
        local v38 = len(p22) - 16

        assert(v38 % 16 == 0, "Input length must be a multiple of 16 bytes")
        p25 = p25 or v1
        assert(len(p25) == 16, "Initialization vector must be 16 bytes long")

        local v42 = readu32(p22, 0)
        local v43 = readu32(p22, 4)
        local v44 = readu32(p22, 8)
        local v45 = readu32(p22, 12)

        p21(p22, 0, p23, 0)
        writeu32(p23, 0, (bxor(readu32(p23, 0), (readu32(p25, 0)))))
        writeu32(p23, 4, (bxor(readu32(p23, 4), (readu32(p25, 4)))))
        writeu32(p23, 8, (bxor(readu32(p23, 8), (readu32(p25, 8)))))
        writeu32(p23, 12, (bxor(readu32(p23, 12), (readu32(p25, 12)))))

        for i = 16, v38, 16 do
            local v58 = readu32(p22, i)
            local v59 = readu32(p22, i + 4)
            local v60 = readu32(p22, i + 8)
            local v61 = readu32(p22, i + 12)

            p21(p22, i, p23, i)
            writeu32(p23, i, (bxor(readu32(p23, i), v42)))

            local v65 = bxor(readu32(p23, i + 4), v43)

            writeu32(p23, i + 4, v65)

            local v67 = bxor(readu32(p23, i + 8), v44)

            writeu32(p23, i + 8, v67)

            local v68 = i + 12
            local v70 = bxor(readu32(p23, i + 12), v45)

            v45 = v61
            writeu32(p23, v68, v70)
            v42 = v58
            v43 = v59
            v44 = v60
        end
    end
}
table.freeze(t1.CBC)
t1.PCBC = {
    FwdMode = function(p26, _, p28, p29, _, p31) -- FwdMode | line: 161
        -- upvalues: bxor (copy), len (copy), readu32 (copy), writeu32 (copy), v1 (copy)
        local v71 = len(p28) - 16

        assert(v71 % 16 == 0, "Input length must be a multiple of 16 bytes")
        p31 = p31 or v1
        assert(len(p31) == 16, "Initialization vector must be 16 bytes long")

        local v75 = readu32(p28, 0)
        local v76 = readu32(p28, 4)
        local v77 = readu32(p28, 8)
        local v78 = readu32(p28, 12)

        writeu32(p29, 0, (bxor(v75, (readu32(p31, 0)))))
        writeu32(p29, 4, (bxor(v76, (readu32(p31, 4)))))
        writeu32(p29, 8, (bxor(v77, (readu32(p31, 8)))))
        writeu32(p29, 12, (bxor(v78, (readu32(p31, 12)))))
        p26(p29, 0, p29, 0)

        for i = 16, v71, 16 do
            local v87 = readu32(p28, i)
            local v88 = readu32(p28, i + 4)
            local v89 = readu32(p28, i + 8)
            local v90 = readu32(p28, i + 12)

            writeu32(p29, i, (bxor(v75, v87, (readu32(p29, i - 16)))))

            local v94 = bxor(v76, v88, (readu32(p29, i - 12)))

            writeu32(p29, i + 4, v94)

            local v96 = bxor(v77, v89, (readu32(p29, i - 8)))

            writeu32(p29, i + 8, v96)

            local v97 = i + 12
            local v99 = bxor(v78, v90, (readu32(p29, i - 4)))

            v78 = v90
            writeu32(p29, v97, v99)
            p26(p29, i, p29, i)
            v75 = v87
            v76 = v88
            v77 = v89
        end
    end,
    InvMode = function(_, p33, p34, p35, _, p37) -- InvMode | line: 189
        -- upvalues: bxor (copy), len (copy), readu32 (copy), writeu32 (copy), v1 (copy)
        local v100 = len(p34) - 16

        assert(v100 % 16 == 0, "Input length must be a multiple of 16 bytes")
        p37 = p37 or v1
        assert(len(p37) == 16, "Initialization vector must be 16 bytes long")

        local v104 = readu32(p34, 0)
        local v105 = readu32(p34, 4)
        local v106 = readu32(p34, 8)
        local v107 = readu32(p34, 12)

        p33(p34, 0, p35, 0)

        local v110 = bxor(readu32(p35, 0), (readu32(p37, 0)))
        local v113 = bxor(readu32(p35, 4), (readu32(p37, 4)))
        local v116 = bxor(readu32(p35, 8), (readu32(p37, 8)))
        local v119 = bxor(readu32(p35, 12), (readu32(p37, 12)))

        writeu32(p35, 0, v110)
        writeu32(p35, 4, v113)
        writeu32(p35, 8, v116)
        writeu32(p35, 12, v119)

        local n1 = 0
        local n2 = 4
        local n3 = 8
        local n4 = 12

        for i = 16, v100, 16 do
            n1 += 16
            n2 += 16
            n3 += 16
            n4 += 16

            local v120 = readu32(p34, n1)
            local v121 = readu32(p34, n2)
            local v122 = readu32(p34, n3)
            local v123 = readu32(p34, n4)

            p33(p34, i, p35, i)
            v110 = bxor(v104, v110, (readu32(p35, n1)))
            v113 = bxor(v105, v113, (readu32(p35, n2)))
            v116 = bxor(v106, v116, (readu32(p35, n3)))
            v119 = bxor(v107, v119, (readu32(p35, n4)))
            v107 = v123
            writeu32(p35, n1, v110)
            writeu32(p35, n2, v113)
            writeu32(p35, n3, v116)
            writeu32(p35, n4, v119)
            v104 = v120
            v105 = v121
            v106 = v122
        end
    end
}
table.freeze(t1.PCBC)

local function cfbFwd(p38, _, p40, p41, p42, p43) -- line: 243
    -- upvalues: bxor (copy), copy (copy), create (copy), len (copy), readu8 (copy), writeu8 (copy), v1 (copy)
    local SegmentSize = p42.SegmentSize
    local v128 = len(p40)

    assert(v128 % SegmentSize == 0, "Input length must be a multiple of segment size")
    p43 = p43 or v1
    assert(len(p43) == 16, "Initialization vector must be 16 bytes long")

    local v132 = p42.CommonTemp or create(31)

    if v128 == SegmentSize then
        p38(p43, 0, v132, 0)

        for i = 0, SegmentSize - 1 do
            writeu8(p41, i, (bxor(readu8(p40, i), (readu8(v132, i)))))
        end
    else
        local v136 = v128 - SegmentSize
        local v137 = 16 - SegmentSize

        p38(p43, 0, v132, 0)

        for i = 0, SegmentSize - 1 do
            writeu8(p41, i, (bxor(readu8(p40, i), (readu8(v132, i)))))
        end

        copy(v132, 0, p43, SegmentSize, v137)
        copy(v132, v137, p41, 0, SegmentSize)

        for i = SegmentSize, v136 - SegmentSize, SegmentSize do
            copy(v132, 16, v132, SegmentSize, v137)
            p38(v132, 0, v132, 0)

            local v141 = i + SegmentSize - 1
            local n5 = 0

            for j = i, v141 do
                writeu8(p41, j, (bxor(readu8(p40, j), (readu8(v132, n5)))))
                n5 += 1
            end

            copy(v132, 0, v132, 16, v137)
            copy(v132, v137, p41, i, SegmentSize)
        end

        p38(v132, 0, v132, 0)

        local v145 = v128 - 1
        local n6 = 0

        for i = v136, v145 do
            writeu8(p41, i, (bxor(readu8(p40, i), (readu8(v132, n6)))))
            n6 += 1
        end
    end
end

local function cfbInv(p44, _, p46, p47, p48, p49) -- line: 284
    -- upvalues: bxor (copy), copy (copy), create (copy), len (copy), readu8 (copy), writeu8 (copy), v1 (copy)
    local v149 = len(p46)
    local SegmentSize = p48.SegmentSize

    assert(v149 % SegmentSize == 0, "Input length must be a multiple of segment size")
    p49 = p49 or v1
    assert(len(p49) == 16, "Initialization vector must be 16 bytes long")

    local v153 = p48.CommonTemp or create(31)

    if v149 == SegmentSize then
        p44(p49, 0, v153, 0)

        for i = 0, SegmentSize - 1 do
            writeu8(p47, i, (bxor(readu8(p46, i), (readu8(v153, i)))))
        end
    else
        local v157 = v149 - SegmentSize
        local v158 = 16 - SegmentSize

        p44(p49, 0, v153, 0)

        for i = 0, SegmentSize - 1 do
            writeu8(p47, i, (bxor(readu8(p46, i), (readu8(v153, i)))))
        end

        copy(v153, 0, p49, SegmentSize, v158)
        copy(v153, v158, p46, 0, SegmentSize)

        for i = SegmentSize, v157 - SegmentSize, SegmentSize do
            copy(v153, 16, v153, SegmentSize, v158)
            p44(v153, 0, v153, 0)

            local v162 = i + SegmentSize - 1
            local n7 = 0

            for j = i, v162 do
                writeu8(p47, j, (bxor(readu8(p46, j), (readu8(v153, n7)))))
                n7 += 1
            end

            copy(v153, 0, v153, 16, v158)
            copy(v153, v158, p46, i, SegmentSize)
        end

        p44(v153, 0, v153, 0)

        local v166 = v149 - 1
        local n8 = 0

        for i = v157, v166 do
            writeu8(p47, i, (bxor(readu8(p46, i), (readu8(v153, n8)))))
            n8 += 1
        end
    end
end

local function ofbMode(p50, _, p52, p53, _, p55) -- line: 334
    -- upvalues: bxor (copy), len (copy), readu32 (copy), writeu32 (copy), v1 (copy)
    local v170 = len(p52) - 16

    assert(v170 % 16 == 0, "Input length must be a multiple of 16 bytes")
    p55 = p55 or v1
    assert(len(p55) == 16, "Initialization vector must be 16 bytes long")

    local v174 = readu32(p52, 0)
    local v175 = readu32(p52, 4)
    local v176 = readu32(p52, 8)
    local v177 = readu32(p52, 12)

    p50(p55, 0, p53, 0)

    local v179 = bxor(v174, (readu32(p53, 0)))
    local v181 = bxor(v175, (readu32(p53, 4)))
    local v183 = bxor(v176, (readu32(p53, 8)))
    local v185 = bxor(v177, (readu32(p53, 12)))

    for i = 16, v170, 16 do
        local v186 = readu32(p52, i)
        local v187 = readu32(p52, i + 4)
        local v188 = readu32(p52, i + 8)
        local v189 = readu32(p52, i + 12)

        p50(p53, i - 16, p53, i)
        writeu32(p53, i - 16, v179)
        writeu32(p53, i - 12, v181)
        writeu32(p53, i - 8, v183)
        writeu32(p53, i - 4, v185)
        v179 = bxor(v186, (readu32(p53, i)))
        v181 = bxor(v187, (readu32(p53, i + 4)))
        v183 = bxor(v188, (readu32(p53, i + 8)))
        v185 = bxor(v189, (readu32(p53, i + 12)))
    end

    writeu32(p53, v170, v179)
    writeu32(p53, v170 + 4, v181)
    writeu32(p53, v170 + 8, v183)
    writeu32(p53, v170 + 12, v185)
end

t1.OFB = {
    FwdMode = ofbMode,
    InvMode = ofbMode
}
table.freeze(t1.OFB)

local function ctrMode(p56, _, p58, p59, p60) -- line: 391
    -- upvalues: bxor (copy), len (copy), readu32 (copy), writestring (copy), writeu32 (copy), addByteCtr (copy)
    local v197 = len(p58) - 16

    assert(v197 % 16 == 0, "Input length must be a multiple of 16 bytes")

    local CommonTemp, InitValue, Prefix, Suffix = p60.CommonTemp, p60.InitValue, p60.Prefix, p60.Suffix
    local Step, LittleEndian = p60.Step, p60.LittleEndian
    local v199 = #Prefix
    local v200 = v199 + #InitValue - 1

    writestring(CommonTemp, 0, Prefix)
    writestring(CommonTemp, v199, InitValue)
    writestring(CommonTemp, v200 + 1, Suffix)

    local v201 = readu32(p58, 0)
    local v202 = readu32(p58, 4)
    local v203 = readu32(p58, 8)
    local v204 = readu32(p58, 12)

    p56(CommonTemp, 0, p59, 0)
    writeu32(p59, 0, (bxor(readu32(p59, 0), v201)))
    writeu32(p59, 4, (bxor(readu32(p59, 4), v202)))
    writeu32(p59, 8, (bxor(readu32(p59, 8), v203)))
    writeu32(p59, 12, (bxor(readu32(p59, 12), v204)))

    for i = 16, v197, 16 do
        local v213 = readu32(p58, i)
        local v214 = readu32(p58, i + 4)
        local v215 = readu32(p58, i + 8)
        local v216 = readu32(p58, i + 12)

        addByteCtr(CommonTemp, Step, v199, v200, LittleEndian)
        p56(CommonTemp, 0, p59, i)
        writeu32(p59, i, (bxor(v213, (readu32(p59, i)))))

        local v220 = bxor(v214, (readu32(p59, i + 4)))

        writeu32(p59, i + 4, v220)

        local v222 = bxor(v215, (readu32(p59, i + 8)))

        writeu32(p59, i + 8, v222)

        local v224 = bxor(v216, (readu32(p59, i + 12)))

        writeu32(p59, i + 12, v224)
    end
end

local t5 = {
    __index = function(_, p62) -- __index | line: 442
        -- upvalues: create (copy), random (copy), pack (copy), cfbFwd (copy), cfbInv (copy), ctrMode (copy)
        if p62 == "CFB" then
            return {
                SegmentSize = 16,
                FwdMode = cfbFwd,
                InvMode = cfbInv,
                CommonTemp = create(31)
            }
        end

        return if p62 == "CTR" then {
            Prefix = "",
            Suffix = "",
            Step = 1,
            LittleEndian = false,
            FwdMode = ctrMode,
            InvMode = ctrMode,
            InitValue = pack("I2I2I2I2I2I2I2I2", random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535), random(0, 65535)),
            CommonTemp = create(16)
        } else nil
    end,
    __newindex = function() -- __newindex | line: 472
    end
}

setmetatable(t1, t5)
t1.CFB = {}
t1.CTR = {}
table.freeze(t1)
t5.__metatable = "This metatable is locked"

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local bxor, rrotate, copy, create = bit32.bxor, bit32.rrotate, buffer.copy, buffer.create
local fromstring, len, readu8, readu16 = buffer.fromstring, buffer.len, buffer.readu8, buffer.readu16
local readu32, tostring, writestring, writeu8 = buffer.readu32, buffer.tostring, buffer.writestring, buffer.writeu8
local writeu16, writeu32, floor, sub = buffer.writeu16, buffer.writeu32, math.floor, string.sub
local v1 = create(131072)
local v2 = create(65536)
local v3 = create(65536)
local v4 = create(65536)
local v5 = create(65536)
local v6 = create(65536)

local function keySchedule(p1, p2, p3, p4) -- line: 159
    -- upvalues: bxor (copy), rrotate (copy), copy (copy), readu16 (copy), readu32 (copy), writestring (copy), writeu32 (copy), floor (copy), v1 (copy)
    if p4 then
        copy(p3, 0, p1, 0, p2)
    else
        writestring(p3, 0, p1, p2)
    end

    local v9 = rrotate(readu32(p3, p2 - 4), 8)

    if p2 == 32 then
        local n1 = 0.5

        for i = 32, 192, 32 do
            n1 = n1 * 2 % 229

            local v16 = bxor(readu32(p3, i - 32), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), n1)

            writeu32(p3, i, v16)

            local v18 = bxor(readu32(p3, i - 28), v16)

            writeu32(p3, i + 4, v18)

            local v20 = bxor(readu32(p3, i - 24), v18)

            writeu32(p3, i + 8, v20)

            local v22 = bxor(readu32(p3, i - 20), v20)

            writeu32(p3, i + 12, v22)

            local v29 = bxor(readu32(p3, i - 16), readu16(v1, floor(v22 / 65536) * 2) * 65536 + readu16(v1, v22 % 65536 * 2))

            writeu32(p3, i + 16, v29)

            local v31 = bxor(readu32(p3, i - 12), v29)

            writeu32(p3, i + 20, v31)

            local v33 = bxor(readu32(p3, i - 8), v31)

            writeu32(p3, i + 24, v33)

            local v35 = bxor(readu32(p3, i - 4), v33)

            writeu32(p3, i + 28, v35)
            v9 = rrotate(v35, 8)
        end

        local v42 = bxor(readu32(p3, 192), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), 64)

        writeu32(p3, 224, v42)

        local v44 = bxor(readu32(p3, 196), v42)

        writeu32(p3, 228, v44)

        local v46 = bxor(readu32(p3, 200), v44)

        writeu32(p3, 232, v46)
        writeu32(p3, 236, (bxor(readu32(p3, 204), v46)))
    elseif p2 == 24 then
        local n2 = 0.5

        for i = 24, 168, 24 do
            n2 = n2 * 2 % 229

            local v55 = bxor(readu32(p3, i - 24), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), n2)

            writeu32(p3, i, v55)

            local v57 = bxor(readu32(p3, i - 20), v55)

            writeu32(p3, i + 4, v57)

            local v59 = bxor(readu32(p3, i - 16), v57)

            writeu32(p3, i + 8, v59)

            local v61 = bxor(readu32(p3, i - 12), v59)

            writeu32(p3, i + 12, v61)

            local v63 = bxor(readu32(p3, i - 8), v61)

            writeu32(p3, i + 16, v63)

            local v65 = bxor(readu32(p3, i - 4), v63)

            writeu32(p3, i + 20, v65)
            v9 = rrotate(v65, 8)
        end

        local v72 = bxor(readu32(p3, 168), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), 128)

        writeu32(p3, 192, v72)

        local v74 = bxor(readu32(p3, 172), v72)

        writeu32(p3, 196, v74)

        local v76 = bxor(readu32(p3, 176), v74)

        writeu32(p3, 200, v76)
        writeu32(p3, 204, (bxor(readu32(p3, 180), v76)))
    else
        local n3 = 0.5

        for i = 16, 144, 16 do
            n3 = n3 * 2 % 229

            local v85 = bxor(readu32(p3, i - 16), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), n3)

            writeu32(p3, i, v85)

            local v87 = bxor(readu32(p3, i - 12), v85)

            writeu32(p3, i + 4, v87)

            local v89 = bxor(readu32(p3, i - 8), v87)

            writeu32(p3, i + 8, v89)

            local v91 = bxor(readu32(p3, i - 4), v89)

            writeu32(p3, i + 12, v91)
            v9 = rrotate(v91, 8)
        end

        local v98 = bxor(readu32(p3, 144), readu16(v1, floor(v9 / 65536) * 2) * 65536 + readu16(v1, v9 % 65536 * 2), 54)

        writeu32(p3, 160, v98)

        local v100 = bxor(readu32(p3, 148), v98)

        writeu32(p3, 164, v100)

        local v102 = bxor(readu32(p3, 152), v100)

        writeu32(p3, 168, v102)
        writeu32(p3, 172, (bxor(readu32(p3, 156), v102)))
    end

    return p3
end

local function encryptBlock(p5, p6, p7, p8, p9, p10) -- line: 284
    -- upvalues: bxor (copy), readu8 (copy), readu16 (copy), readu32 (copy), writeu32 (copy), v1 (copy), v2 (copy), v3 (copy)
    local v107 = bxor(readu8(p7, p8), (readu8(p5, 0)))
    local v105 = bxor(readu8(p7, p8 + 1), (readu8(p5, 1)))
    local v106 = bxor(readu8(p7, p8 + 2), (readu8(p5, 2)))
    local v109 = bxor(readu8(p7, p8 + 3), (readu8(p5, 3)))
    local v108 = bxor(readu8(p7, p8 + 4), (readu8(p5, 4)))
    local v110 = bxor(readu8(p7, p8 + 5), (readu8(p5, 5)))
    local v111 = bxor(readu8(p7, p8 + 6), (readu8(p5, 6)))
    local v112 = bxor(readu8(p7, p8 + 7), (readu8(p5, 7)))
    local v113 = bxor(readu8(p7, p8 + 8), (readu8(p5, 8)))
    local v114 = bxor(readu8(p7, p8 + 9), (readu8(p5, 9)))
    local v115 = bxor(readu8(p7, p8 + 10), (readu8(p5, 10)))
    local v116 = bxor(readu8(p7, p8 + 11), (readu8(p5, 11)))
    local v117 = bxor(readu8(p7, p8 + 12), (readu8(p5, 12)))
    local v118 = bxor(readu8(p7, p8 + 13), (readu8(p5, 13)))
    local v119 = bxor(readu8(p7, p8 + 14), (readu8(p5, 14)))
    local v120 = bxor(readu8(p7, p8 + 15), (readu8(p5, 15)))
    local v121 = v107 * 256 + v110
    local v122 = v110 * 256 + v115
    local v123 = v115 * 256 + v120
    local v124 = v120 * 256 + v107
    local v125 = v108 * 256 + v114
    local v127 = v114 * 256 + v119
    local v126 = v119 * 256 + v109
    local v128 = v109 * 256 + v108
    local v129 = v113 * 256 + v118
    local v131 = v118 * 256 + v106
    local v130 = v106 * 256 + v112
    local v132 = v112 * 256 + v113
    local v133 = v117 * 256 + v105
    local v135 = v105 * 256 + v111
    local v134 = v111 * 256 + v116
    local v136 = v116 * 256 + v117
    local v137, v138, v139, v140

    for i = 16, p6, 16 do
        v138 = readu8(v2, v121)
        v140 = readu8(v3, v123)
        v137 = bxor(v138, v140, (readu8(p5, i)))
        v138 = readu8(v2, v122)
        v140 = readu8(v3, v124)
        v139 = i + 1

        local v142 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v123)
        v140 = readu8(v3, v121)
        v139 = i + 2

        local v143 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v124)
        v140 = readu8(v3, v122)
        v139 = i + 3

        local v144 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v125)
        v140 = readu8(v3, v126)
        v139 = i + 4

        local v145 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v127)
        v140 = readu8(v3, v128)
        v139 = i + 5

        local v146 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v126)
        v140 = readu8(v3, v125)
        v139 = i + 6

        local v147 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v128)
        v140 = readu8(v3, v127)
        v139 = i + 7

        local v148 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v129)
        v140 = readu8(v3, v130)
        v139 = i + 8

        local v149 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v131)
        v140 = readu8(v3, v132)
        v139 = i + 9

        local v150 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v130)
        v140 = readu8(v3, v129)
        v139 = i + 10

        local v151 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v132)
        v140 = readu8(v3, v131)
        v139 = i + 11

        local v152 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v133)
        v140 = readu8(v3, v134)
        v139 = i + 12

        local v153 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v135)
        v140 = readu8(v3, v136)
        v139 = i + 13

        local v154 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v134)
        v140 = readu8(v3, v133)
        v139 = i + 14

        local v155 = bxor(v138, v140, (readu8(p5, v139)))

        v138 = readu8(v2, v136)
        v140 = readu8(v3, v135)
        v139 = i + 15

        local v156 = bxor(v138, v140, (readu8(p5, v139)))

        v121 = v137 * 256 + v146
        v122 = v146 * 256 + v151
        v123 = v151 * 256 + v156
        v124 = v156 * 256 + v137
        v125 = v145 * 256 + v150
        v127 = v150 * 256 + v155
        v126 = v155 * 256 + v144
        v128 = v144 * 256 + v145
        v129 = v149 * 256 + v154
        v131 = v154 * 256 + v143
        v130 = v143 * 256 + v148
        v132 = v148 * 256 + v149
        v133 = v153 * 256 + v142
        v135 = v142 * 256 + v147
        v134 = v147 * 256 + v152
        v136 = v152 * 256 + v153
    end

    writeu32(p9, p10, (bxor(readu16(v1, bxor(readu8(v2, v136), readu8(v3, v135), (readu8(p5, p6 + 31))) * 512 + bxor(readu8(v2, v130), readu8(v3, v129), (readu8(p5, p6 + 26))) * 2) * 65536 + readu16(v1, bxor(readu8(v2, v127), readu8(v3, v128), (readu8(p5, p6 + 21))) * 512 + bxor(readu8(v2, v121), readu8(v3, v123), (readu8(p5, p6 + 16))) * 2), (readu32(p5, p6 + 32)))))
    writeu32(p9, p10 + 4, (bxor(readu16(v1, bxor(readu8(v2, v124), readu8(v3, v122), (readu8(p5, p6 + 19))) * 512 + bxor(readu8(v2, v134), readu8(v3, v133), (readu8(p5, p6 + 30))) * 2) * 65536 + readu16(v1, bxor(readu8(v2, v131), readu8(v3, v132), (readu8(p5, p6 + 25))) * 512 + bxor(readu8(v2, v125), readu8(v3, v126), (readu8(p5, p6 + 20))) * 2), (readu32(p5, p6 + 36)))))
    writeu32(p9, p10 + 8, (bxor(readu16(v1, bxor(readu8(v2, v128), readu8(v3, v127), (readu8(p5, p6 + 23))) * 512 + bxor(readu8(v2, v123), readu8(v3, v121), (readu8(p5, p6 + 18))) * 2) * 65536 + readu16(v1, bxor(readu8(v2, v135), readu8(v3, v136), (readu8(p5, p6 + 29))) * 512 + bxor(readu8(v2, v129), readu8(v3, v130), (readu8(p5, p6 + 24))) * 2), (readu32(p5, p6 + 40)))))
    writeu32(p9, p10 + 12, (bxor(readu16(v1, bxor(readu8(v2, v132), readu8(v3, v131), (readu8(p5, p6 + 27))) * 512 + bxor(readu8(v2, v126), readu8(v3, v125), (readu8(p5, p6 + 22))) * 2) * 65536 + readu16(v1, bxor(readu8(v2, v122), readu8(v3, v124), (readu8(p5, p6 + 17))) * 512 + bxor(readu8(v2, v133), readu8(v3, v134), (readu8(p5, p6 + 28))) * 2), (readu32(p5, p6 + 44)))))
end

local function decryptBlock(p11, p12, p13, p14, p15, p16) -- line: 477
    -- upvalues: bxor (copy), readu8 (copy), writeu32 (copy), v4 (copy), v5 (copy), v6 (copy)
    local v171 = bxor(readu8(v4, readu8(p13, p14) * 256 + readu8(p11, p12 + 32)), (readu8(p11, p12 + 16)))
    local v169 = bxor(readu8(v4, readu8(p13, p14 + 13) * 256 + readu8(p11, p12 + 45)), (readu8(p11, p12 + 17)))
    local v170 = bxor(readu8(v4, readu8(p13, p14 + 10) * 256 + readu8(p11, p12 + 42)), (readu8(p11, p12 + 18)))
    local v168 = bxor(readu8(v4, readu8(p13, p14 + 7) * 256 + readu8(p11, p12 + 39)), (readu8(p11, p12 + 19)))
    local v166 = bxor(readu8(v4, readu8(p13, p14 + 4) * 256 + readu8(p11, p12 + 36)), (readu8(p11, p12 + 20)))
    local v173 = bxor(readu8(v4, readu8(p13, p14 + 1) * 256 + readu8(p11, p12 + 33)), (readu8(p11, p12 + 21)))
    local v175 = bxor(readu8(v4, readu8(p13, p14 + 14) * 256 + readu8(p11, p12 + 46)), (readu8(p11, p12 + 22)))
    local v167 = bxor(readu8(v4, readu8(p13, p14 + 11) * 256 + readu8(p11, p12 + 43)), (readu8(p11, p12 + 23)))
    local v172 = bxor(readu8(v4, readu8(p13, p14 + 8) * 256 + readu8(p11, p12 + 40)), (readu8(p11, p12 + 24)))
    local v174 = bxor(readu8(v4, readu8(p13, p14 + 5) * 256 + readu8(p11, p12 + 37)), (readu8(p11, p12 + 25)))
    local v176 = bxor(readu8(v4, readu8(p13, p14 + 2) * 256 + readu8(p11, p12 + 34)), (readu8(p11, p12 + 26)))
    local v177 = bxor(readu8(v4, readu8(p13, p14 + 15) * 256 + readu8(p11, p12 + 47)), (readu8(p11, p12 + 27)))
    local v178 = bxor(readu8(v4, readu8(p13, p14 + 12) * 256 + readu8(p11, p12 + 44)), (readu8(p11, p12 + 28)))
    local v179 = bxor(readu8(v4, readu8(p13, p14 + 9) * 256 + readu8(p11, p12 + 41)), (readu8(p11, p12 + 29)))
    local v180 = bxor(readu8(v4, readu8(p13, p14 + 6) * 256 + readu8(p11, p12 + 38)), (readu8(p11, p12 + 30)))
    local v181 = bxor(readu8(v4, readu8(p13, p14 + 3) * 256 + readu8(p11, p12 + 35)), (readu8(p11, p12 + 31)))
    local v182 = v171 * 256 + v169
    local v183 = v169 * 256 + v170
    local v184 = v170 * 256 + v168
    local v185 = v168 * 256 + v171
    local v186 = v166 * 256 + v173
    local v187 = v173 * 256 + v175
    local v188 = v175 * 256 + v167
    local v193 = v167 * 256 + v166
    local v192 = v172 * 256 + v174
    local v197 = v174 * 256 + v176
    local v191 = v176 * 256 + v177
    local v196 = v177 * 256 + v172
    local v195 = v178 * 256 + v179
    local v189 = v179 * 256 + v180
    local v194 = v180 * 256 + v181
    local v190 = v181 * 256 + v178
    local v198, v199, v200, v201, v202

    for i = p12, 16, -16 do
        v200 = readu8(v5, v182) * 256 + readu8(v6, v184)
        v201 = readu8(v4, v200)
        v202 = readu8(p11, i)
        v198 = bxor(v201, v202)
        v200 = readu8(v5, v189) * 256 + readu8(v6, v190)
        v201 = readu8(v4, v200)
        v199 = i + 1
        v202 = readu8(p11, v199)

        local v203 = bxor(v201, v202)

        v200 = readu8(v5, v191) * 256 + readu8(v6, v192)
        v201 = readu8(v4, v200)
        v199 = i + 2
        v202 = readu8(p11, v199)

        local v204 = bxor(v201, v202)

        v200 = readu8(v5, v193) * 256 + readu8(v6, v187)
        v201 = readu8(v4, v200)
        v199 = i + 3
        v202 = readu8(p11, v199)

        local v205 = bxor(v201, v202)

        v200 = readu8(v5, v186) * 256 + readu8(v6, v188)
        v201 = readu8(v4, v200)
        v199 = i + 4
        v202 = readu8(p11, v199)

        local v206 = bxor(v201, v202)

        v200 = readu8(v5, v183) * 256 + readu8(v6, v185)
        v201 = readu8(v4, v200)
        v199 = i + 5
        v202 = readu8(p11, v199)

        local v207 = bxor(v201, v202)

        v200 = readu8(v5, v194) * 256 + readu8(v6, v195)
        v201 = readu8(v4, v200)
        v199 = i + 6
        v202 = readu8(p11, v199)

        local v208 = bxor(v201, v202)

        v200 = readu8(v5, v196) * 256 + readu8(v6, v197)
        v201 = readu8(v4, v200)
        v199 = i + 7
        v202 = readu8(p11, v199)

        local v209 = bxor(v201, v202)

        v200 = readu8(v5, v192) * 256 + readu8(v6, v191)
        v201 = readu8(v4, v200)
        v199 = i + 8
        v202 = readu8(p11, v199)

        local v210 = bxor(v201, v202)

        v200 = readu8(v5, v187) * 256 + readu8(v6, v193)
        v201 = readu8(v4, v200)
        v199 = i + 9
        v202 = readu8(p11, v199)

        local v211 = bxor(v201, v202)

        v200 = readu8(v5, v184) * 256 + readu8(v6, v182)
        v201 = readu8(v4, v200)
        v199 = i + 10
        v202 = readu8(p11, v199)

        local v212 = bxor(v201, v202)

        v200 = readu8(v5, v190) * 256 + readu8(v6, v189)
        v201 = readu8(v4, v200)
        v199 = i + 11
        v202 = readu8(p11, v199)

        local v213 = bxor(v201, v202)

        v200 = readu8(v5, v195) * 256 + readu8(v6, v194)
        v201 = readu8(v4, v200)
        v199 = i + 12
        v202 = readu8(p11, v199)

        local v214 = bxor(v201, v202)

        v200 = readu8(v5, v197) * 256 + readu8(v6, v196)
        v201 = readu8(v4, v200)
        v199 = i + 13
        v202 = readu8(p11, v199)

        local v215 = bxor(v201, v202)

        v200 = readu8(v5, v188) * 256 + readu8(v6, v186)
        v201 = readu8(v4, v200)
        v199 = i + 14
        v202 = readu8(p11, v199)

        local v216 = bxor(v201, v202)

        v200 = readu8(v5, v185) * 256 + readu8(v6, v183)
        v201 = readu8(v4, v200)
        v199 = i + 15
        v202 = readu8(p11, v199)

        local v217 = bxor(v201, v202)

        v182 = v198 * 256 + v203
        v183 = v203 * 256 + v204
        v184 = v204 * 256 + v205
        v185 = v205 * 256 + v198
        v186 = v206 * 256 + v207
        v187 = v207 * 256 + v208
        v188 = v208 * 256 + v209
        v193 = v209 * 256 + v206
        v192 = v210 * 256 + v211
        v197 = v211 * 256 + v212
        v191 = v212 * 256 + v213
        v196 = v213 * 256 + v210
        v195 = v214 * 256 + v215
        v189 = v215 * 256 + v216
        v194 = v216 * 256 + v217
        v190 = v217 * 256 + v214
    end

    writeu32(p15, p16, bxor(readu8(v4, readu8(v5, v193) * 256 + readu8(v6, v187)), (readu8(p11, 3))) * 16777216 + bxor(readu8(v4, readu8(v5, v191) * 256 + readu8(v6, v192)), (readu8(p11, 2))) * 65536 + bxor(readu8(v4, readu8(v5, v189) * 256 + readu8(v6, v190)), (readu8(p11, 1))) * 256 + bxor(readu8(v4, readu8(v5, v182) * 256 + readu8(v6, v184)), (readu8(p11, 0))))
    writeu32(p15, p16 + 4, bxor(readu8(v4, readu8(v5, v196) * 256 + readu8(v6, v197)), (readu8(p11, 7))) * 16777216 + bxor(readu8(v4, readu8(v5, v194) * 256 + readu8(v6, v195)), (readu8(p11, 6))) * 65536 + bxor(readu8(v4, readu8(v5, v183) * 256 + readu8(v6, v185)), (readu8(p11, 5))) * 256 + bxor(readu8(v4, readu8(v5, v186) * 256 + readu8(v6, v188)), (readu8(p11, 4))))
    writeu32(p15, p16 + 8, bxor(readu8(v4, readu8(v5, v190) * 256 + readu8(v6, v189)), (readu8(p11, 11))) * 16777216 + bxor(readu8(v4, readu8(v5, v184) * 256 + readu8(v6, v182)), (readu8(p11, 10))) * 65536 + bxor(readu8(v4, readu8(v5, v187) * 256 + readu8(v6, v193)), (readu8(p11, 9))) * 256 + bxor(readu8(v4, readu8(v5, v192) * 256 + readu8(v6, v191)), (readu8(p11, 8))))
    writeu32(p15, p16 + 12, bxor(readu8(v4, readu8(v5, v185) * 256 + readu8(v6, v183)), (readu8(p11, 15))) * 16777216 + bxor(readu8(v4, readu8(v5, v188) * 256 + readu8(v6, v186)), (readu8(p11, 14))) * 65536 + bxor(readu8(v4, readu8(v5, v197) * 256 + readu8(v6, v196)), (readu8(p11, 13))) * 256 + bxor(readu8(v4, readu8(v5, v195) * 256 + readu8(v6, v194)), (readu8(p11, 12))))
end

local v223 = create(256)
local v224 = create(256)
local v225 = create(256)
local v226 = create(256)
local v227 = create(256)

local function gfmul(p17, p18) -- line: 748
    -- upvalues: bxor (copy), floor (copy)
    local v229 = p18
    local n4 = 0

    for _ = 0, 7 do
        if v229 % 2 == 1 then
            n4 = bxor(n4, p17)
        end

        p17 = if p17 >= 128 then bxor(p17 * 2 % 256, 27) else p17 * 2 % 256
        v229 = floor(v229 / 2)
    end

    return n4
end

writeu8(v223, 0, 99)

local n5 = 1
local n6 = 1

for _ = 1, 255 do
    n5 = bxor(n5, n5 * 2, if n5 < 128 then 0 else 27) % 256

    local v234 = bxor(n6, n6 * 2)
    local v235 = bxor(v234, v234 * 4)

    n6 = bxor(v235, v235 * 16) % 256

    if n6 >= 128 then
        n6 = bxor(n6, 9)
    end

    local v236 = bxor(n6, n6 % 128 * 2 + n6 / 128, n6 % 64 * 4 + n6 / 64, n6 % 32 * 8 + n6 / 32, n6 % 16 * 16 + n6 / 16, 99)

    writeu8(v223, n5, v236)
    writeu8(v224, v236, n5)
    writeu8(v225, n5, (gfmul(3, n5)))
    writeu8(v226, n5, (gfmul(9, n5)))
    writeu8(v227, n5, (gfmul(11, n5)))
end

local n7 = 0

for i = 0, 255 do
    local v237 = readu8(v223, i)
    local v238 = v237 * 256
    local v239 = gfmul(2, v237)
    local v240 = gfmul(13, i)
    local v241 = gfmul(14, i)

    for j = 0, 255 do
        local v242 = readu8(v223, j)

        writeu16(v1, n7 * 2, v238 + v242)
        writeu8(v4, n7, (readu8(v224, (bxor(i, j)))))
        writeu8(v2, n7, (bxor(v239, (readu8(v225, v242)))))
        writeu8(v3, n7, (bxor(v237, v242)))
        writeu8(v5, n7, (bxor(v241, (readu8(v227, j)))))
        writeu8(v6, n7, (bxor(v240, (readu8(v226, j)))))
        n7 += 1
    end
end

local function newidx(_, p20) -- line: 845
    return error((("%* cannot be assigned to"):format(p20)))
end

local function tostr() -- line: 848
    return "AesCipher"
end

local Modes = require(script.Modes)
local Pads = require(script.Pads)

local function expandKey(p21, p22) -- line: 854
    -- upvalues: create (copy), len (copy), keySchedule (copy)
    local v243 = typeof(p21) == "buffer"
    local v244 = if v243 then len(p21) else #p21
    local v245 = if v244 == 32 then 240
        elseif v244 == 24 then 208
        elseif v244 == 16 then 176
        else error("Key must be either 16, 24 or 32 bytes long")

    return (keySchedule(p21, v244, p22 or create(v245), v243))
end

local function fromKey(p23, p24, p25) -- line: 864
    -- upvalues: create (copy), fromstring (copy), len (copy), tostring (copy), sub (copy), encryptBlock (copy), decryptBlock (copy), newidx (copy), tostr (copy), Modes (copy), Pads (copy)
    local v246 = len(p23)
    local v247 = v246
    local v248, v249
    local v250 = tostring(p23)
    local v251 = v250

    if v246 == 240 then
        v248 = 192
        v249 = sub(v250, 1, 32)
    elseif v246 == 208 then
        v248 = 160
        v249 = sub(v250, 1, 24)
    elseif v246 == 176 then
        v248 = 128
        v249 = sub(v250, 1, 16)
    else
        error("Round keys must be either 240, 208 or 128 bytes long")
    end

    local v252 = p23
    local v253 = p24
    local ECB

    if p24 then
        ECB = p24
    else
        ECB = Modes.ECB
        v253 = ECB
    end

    local FwdMode, InvMode = ECB.FwdMode, ECB.InvMode
    local v254 = ECB.SegmentSize or 16
    local v255 = p25
    local Pkcs7

    if p25 then
        Pkcs7 = p25
    else
        Pkcs7 = Pads.Pkcs7
        v255 = Pkcs7
    end

    local Pad, Unpad = Pkcs7.Pad, Pkcs7.Unpad
    local v256 = newproxy(true)
    local mt = getmetatable(v256)

    local function encp(p26, p27, p28, p29) -- line: 894
        -- upvalues: v248 (ref), v252 (ref), encryptBlock (copy)
        encryptBlock(v252, v248, p26, p27, p28, p29)
    end

    local function decp(p30, p31, p32, p33) -- line: 897
        -- upvalues: v248 (ref), v252 (ref), decryptBlock (copy)
        decryptBlock(v252, v248, p30, p31, p32, p33)
    end

    local function enc(p34, p35, p36, ...) -- line: 900
        -- upvalues: v248 (ref), v253 (ref), FwdMode (ref), v254 (copy), v255 (ref), Pad (copy), v256 (copy), encp (copy), decp (copy), create (copy), fromstring (copy)
        local v257 = if typeof(p35) == "buffer" then p35 elseif typeof(p35) == "string" then fromstring(p35) else error((("Unable to cast %* to buffer"):format((typeof(p35)))))
        local v258 = typeof(p36) == "buffer" and p36

        if p34 ~= v256 then
            return p34:Encrypt(v257, v258, ...)
        end

        if v248 then
            local v259 = Pad(v257, v258, v254)
            local FwdMode2 = FwdMode

            if v255.Overwrite ~= false then
                v257 = v259
            end

            FwdMode2(encp, decp, v257, v259, v253, ...)

            return v259
        end

        error("AesCipher object's already destroyed")

        return create(0)
    end

    local function encb(p37, p38, p39, p40, p41) -- line: 917
        -- upvalues: v248 (ref), v252 (ref), v256 (copy), encryptBlock (copy)
        if p37 == v256 then
            if v248 then
                encryptBlock(v252, v248, p38, p39, p40 or p38, p41 or p39)
            else
                error("AesCipher object's already destroyed")
            end
        else
            p37:EncryptBlock(p38, p39, p40, p41)
        end
    end

    local function dec(p42, p43, p44, ...) -- line: 926
        -- upvalues: v248 (ref), v253 (ref), InvMode (ref), v254 (copy), v255 (ref), Unpad (copy), v256 (copy), encp (copy), decp (copy), create (copy), fromstring (copy), len (copy)
        local v260 = if typeof(p43) == "buffer" then p43 elseif typeof(p43) == "string" then fromstring(p43) else error((("Unable to cast %* to buffer"):format((typeof(p43)))))
        local v261 = typeof(p44) == "buffer" and p44

        if p42 ~= v256 then
            return p42:Decrypt(v260, v261, ...)
        end

        if v248 then
            local Overwrite = v255.Overwrite
            local v262 = if Overwrite == nil then create(len(v260)) elseif Overwrite then v260 else v261 or create(len(v260))

            InvMode(encp, decp, v260, v262, v253, ...)

            return (Unpad(v262, v261, v254))
        end

        error("AesCipher object's already destroyed")

        return create(0)
    end

    local function decb(p45, p46, p47, p48, p49) -- line: 947
        -- upvalues: v248 (ref), v252 (ref), v256 (copy), decryptBlock (copy)
        if p45 == v256 then
            if v248 then
                decryptBlock(v252, v248, p46, p47, p48 or p46, p49 or p47)
            else
                error("AesCipher object's already destroyed")
            end
        else
            p45:DecryptBlock(p46, p47, p48, p49)
        end
    end

    local function destroy(p50) -- line: 956
        -- upvalues: v247 (ref), v248 (ref), v249 (ref), v251 (ref), v252 (ref), v253 (ref), FwdMode (ref), InvMode (ref), v255 (ref), v256 (copy)
        if p50 ~= v256 then
            p50:Destroy()

            return
        end

        if not v248 then
            error("AesCipher object's already destroyed")

            return
        end

        v251 = nil
        v252 = nil
        v248 = nil
        FwdMode = nil
        InvMode = nil
        v253 = nil
        v255 = nil
        v249 = nil
        v247 = nil
    end

    mt.__index = function(_, p52) -- line: 967
        -- upvalues: v247 (ref), v248 (ref), v249 (ref), v251 (ref), v253 (ref), v255 (ref), enc (copy), encb (copy), dec (copy), decb (copy), destroy (copy)
        if p52 == "Encrypt" then
            return enc
        end

        if p52 == "Decrypt" then
            return dec
        end

        if p52 == "EncryptBlock" then
            return encb
        end

        if p52 == "DecryptBlock" then
            return decb
        end

        if p52 == "Destroy" then
            return destroy
        end

        if not v248 then
            return (error("AesCipher object's already destroyed"))
        end

        if p52 == "Key" then
            return v249
        end

        if p52 == "RoundKeys" then
            return v251
        end

        if p52 == "Mode" then
            return v253
        end

        if p52 == "Padding" then
            return v255
        end

        if p52 == "Length" then
            return v247
        end

        return (error((("%* is not a valid member of AesCipher"):format(p52))))
    end

    mt.__newindex = newidx
    mt.__tostring = tostr

    mt.__len = function() -- line: 985
        -- upvalues: v247 (ref)
        return v247 or error("AesCipher object's destroyed")
    end

    mt.__metatable = "AesCipher object: Metatable's locked"

    return v256
end

return table.freeze({
    new = function(p53, p54, p55) -- new | line: 993
        -- upvalues: expandKey (copy), fromKey (copy)
        return (fromKey(expandKey(p53), p54, p55))
    end,
    expandKey = expandKey,
    fromKey = fromKey,
    modes = Modes,
    pads = Pads
})

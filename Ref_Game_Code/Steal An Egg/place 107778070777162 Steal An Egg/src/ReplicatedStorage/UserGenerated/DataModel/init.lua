-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Encode = require(script.Encode)
local Reflection = require(script.Reflection)

local function v1() -- line: 49
    return workspace[nil]
end

local function v2() -- line: 51
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 55
        return p1[p2]
    end
end

local t1 = {
    "Workspace",
    "Players",
    "Lighting",
    "MaterialService",
    "ReplicatedFirst",
    "ReplicatedStorage",
    "SoundService",
    "StarterGui",
    "StarterPack",
    "StarterPlayer",
    "Teams",
    "TextChatService"
}
local t2 = {
    "ServerScriptService",
    "ServerStorage"
}

local function encodeId(p3) -- line: 92
    local t3 = {}
    local v5 = p3

    repeat
        t3[#t3 + 1] = string.char(v5 % 256)
        v5 //= 256
    until v5 == 0

    return table.concat(t3)
end

return {
    capture = function(p4, p5) -- capture | line: 103
        -- upvalues: RunService (copy), Encode (copy), Reflection (copy), v4 (ref), t1 (copy), t2 (copy), encodeId (copy)
        p4 = p4 or {}

        local v9 = p4.properties == true
        local v10 = p4.yielding ~= false
        local v11 = (if not (p5 and p5 > 0) then 0.016666666666666666 else p5) * 0.33
        local v12 = os.clock() + 30
        local t5 = {}
        local t6 = {}

        local function classIdx(p6) -- line: 114
            -- upvalues: t5 (copy), t6 (copy)
            local v13 = t6[p6]

            if v13 then
                return v13
            end

            local v14 = #t5

            t5[v14 + 1] = p6
            t6[p6] = v14

            return v14
        end

        local t7 = {}
        local t8 = {}

        local function propIdx(p7) -- line: 127
            -- upvalues: t7 (copy), t8 (copy)
            local v15 = t8[p7]

            if v15 then
                return v15
            end

            local v16 = #t7

            t7[v16 + 1] = p7
            t8[p7] = v16

            return v16
        end

        local t9 = {}
        local n1 = 0
        local t10 = {}

        local function assign(p8) -- line: 144
            -- upvalues: t9 (copy), n1 (ref), t10 (copy), encodeId (copy)
            local v17 = t9[p8]

            if v17 then
                return v17
            end

            n1 += 1

            local v18 = encodeId(n1)

            t9[p8] = v18
            t10[#t10 + 1] = p8

            return v18
        end

        local _game = game
        local v19

        if t9[_game] then
            v19 = 0
        else
            v19 = n1 + 1
            n1 = v19
            t9[_game] = encodeId(n1)
            t10[#t10 + 1] = _game
        end

        local v20 = table.clone(t1)

        if RunService:IsServer() then
            for _, v21 in t2 do
                table.insert(v20, v21)
            end
        end

        for _, v22 in v20 do
            local function v23() -- line: 165
                -- upvalues: v22 (copy)
                return game:GetService(v22)
            end

            local ok, result = pcall(v23)

            if ok and result then
                if not t9[result] then
                    v19 = n1 + 1
                    n1 = v19
                    t9[result] = encodeId(n1)
                    t10[#t10 + 1] = result
                end

                local function v24() -- line: 172
                    -- upvalues: result (copy)
                    return result:GetDescendants()
                end

                local ok, result2 = pcall(v24)

                if ok and result2 then
                    for _, v26 in result2 do
                        if not t9[v26] then
                            v19 = n1 + 1
                            n1 = v19
                            t9[v26] = encodeId(n1)
                            t10[#t10 + 1] = v26
                        end
                    end
                end
            end
        end

        local v27 = Encode.newWriter(262144)

        v27:u8(68)
        v27:u8(1)
        v27:u8(v9 and 1 or 0)

        local v28 = 0
        local elapsed = os.clock()
        local v29 = false

        for _, v30 in t10 do
            if v30 == game then
                local v31 = ""
                local v32 = v4
                local ClassName, ClassName2 = pcall(v32, v30, "ClassName")

                if ClassName and type(ClassName2) == "string" then
                    local v33 = v4
                    local Name, Name2 = pcall(v33, v30, "Name")

                    if not Name or type(Name2) ~= "string" then
                        Name2 = ClassName2
                    end

                    v27:strU8(t9[v30])
                    v27:strU8(v31)

                    local v34 = t6[ClassName2]

                    if not v34 then
                        v34 = #t5
                        t5[v34 + 1] = ClassName2
                        t6[ClassName2] = v34
                    end

                    v27:u16(v34)
                    v27:strU16(Name2)

                    if v9 then
                        local v35 = Reflection.getReadProperties(ClassName2)
                        local len = v27.len

                        v27:u16(0)

                        local n2 = 0

                        for _, v36 in v35 do
                            local v37 = v4
                            local ok, result = pcall(v37, v30, v36)

                            if ok then
                                local v38 = t8[v36]

                                if not v38 then
                                    v38 = #t7
                                    t7[v38 + 1] = v36
                                    t8[v36] = v38
                                end

                                v27:u16(v38)
                                Encode.writeValue(v27, result)
                                n2 += 1
                            end
                        end

                        v27:patchU16(len, n2)
                    end

                    v28 += 1

                    if v27.len >= 50331648 then
                        v29 = true
                        break
                    end

                    if v10 and v28 >= 20 then
                        local elapsed2 = os.clock()

                        if v12 <= elapsed2 then
                            return {
                                TimedOut = true
                            }
                        end

                        if v11 <= elapsed2 - elapsed then
                            task.wait()
                            elapsed = os.clock()
                            v28 = 0
                        end
                    end
                end
            else
                local v39 = v4
                local Parent, Parent2 = pcall(v39, v30, "Parent")

                if Parent and Parent2 ~= nil then
                    local v40 = t9[Parent2] or ""

                    if v40 ~= "" then
                        local v41 = v4
                        local ClassName, ClassName2 = pcall(v41, v30, "ClassName")

                        if ClassName and type(ClassName2) == "string" then
                            local v42 = v4
                            local Name, Name2 = pcall(v42, v30, "Name")

                            if not Name or type(Name2) ~= "string" then
                                Name2 = ClassName2
                            end

                            v27:strU8(t9[v30])
                            v27:strU8(v40)

                            local v43 = t6[ClassName2]

                            if not v43 then
                                v43 = #t5
                                t5[v43 + 1] = ClassName2
                                t6[ClassName2] = v43
                            end

                            v27:u16(v43)
                            v27:strU16(Name2)

                            if v9 then
                                local v44 = Reflection.getReadProperties(ClassName2)
                                local len = v27.len

                                v27:u16(0)

                                local n3 = 0

                                for _, v45 in v44 do
                                    local v46 = v4
                                    local ok, result = pcall(v46, v30, v45)

                                    if ok then
                                        local v47 = t8[v45]

                                        if not v47 then
                                            v47 = #t7
                                            t7[v47 + 1] = v45
                                            t8[v45] = v47
                                        end

                                        v27:u16(v47)
                                        Encode.writeValue(v27, result)
                                        n3 += 1
                                    end
                                end

                                v27:patchU16(len, n3)
                            end

                            v28 += 1

                            if v27.len >= 50331648 then
                                v29 = true
                                break
                            end

                            if v10 and v28 >= 20 then
                                local elapsed2 = os.clock()

                                if v12 <= elapsed2 then
                                    return {
                                        TimedOut = true
                                    }
                                end

                                if v11 <= elapsed2 - elapsed then
                                    task.wait()
                                    elapsed = os.clock()
                                    v28 = 0
                                end
                            end
                        end
                    end
                end
            end
        end

        return {
            Buffer = v27:finish(),
            Classes = t5,
            Props = t7,
            Truncated = v29
        }
    end
}

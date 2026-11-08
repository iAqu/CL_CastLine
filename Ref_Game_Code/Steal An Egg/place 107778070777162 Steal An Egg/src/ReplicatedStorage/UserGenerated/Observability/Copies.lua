-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op, TemplateNext = Observability.Op, Observability.TemplateNext
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 63
    -- upvalues: t1 (copy)
    return (setmetatable({
        PathCount = 0,
        NextKey = 1,
        TemplateCount = 0,
        LastAddId = 0,
        LastOffset = 0,
        ClassStride = p1 + 1,
        KeyOf = {},
        Paths = {},
        Templates = {}
    }, t1))
end

function t1.refValue(p2, p3) -- line: 82
    if p2 then
        return p2 - p3
    end

    return false
end

function t1.differs(p4, p5, p6, p7, p8, p9) -- line: 89
    if p5 then
        local v2 = p5[p7]

        p5[p7] = p9

        local v1

        if p4 then
            v1 = v2 ~= p9

            return v1
        end
    end

    return not (p6 and p6[p7] == p8)
end

local function closest(p10, p11) -- line: 110
    local v3 = p10[#p10]

    if not p11 then
        return v3, -1
    end

    local v4 = #p10
    local n1 = 1e999

    for i = v4, 1, -1 do
        local Values = p10[i].Values
        local n2 = 0

        for v5, v6 in p11 do
            if Values[v5] ~= v6 then
                n2 += 1

                if n1 <= n2 then
                    break
                end
            end
        end

        if n2 < n1 then
            v3 = p10[i]

            if n2 == 0 then
                n1 = n2
                break
            end

            n1 = n2
        end
    end

    return v3, n1
end

local function writeDrop(p12, p13) -- line: 138
    -- upvalues: Codec (copy), Op (copy)
    p12:u8(Op.DropTemplates)

    if not p13 then
        Codec.varuint(p12, 0)

        return
    end

    Codec.varuint(p12, #p13)

    for _, v7 in p13 do
        Codec.varuint(p12, v7.Id)
    end
end

function t1.WriteHead(p14, p15, p16, p17, p18, p19, p20, p21) -- line: 156
    -- upvalues: Codec (copy), Op (copy), TemplateNext (copy), closest (copy), writeDrop (copy)
    local v8 = (p14.KeyOf[p17] or -(p17 + 1)) * p14.ClassStride + p18
    local v9 = p14.Paths[v8]
    local v10 = v9 and v9[p19]
    local v11 = v10 ~= nil
    local NextKey

    if v10 then
        NextKey = v10
    else
        if p14.PathCount >= 65536 then
            if p14.TemplateCount > 0 then
                p15:u8(Op.DropTemplates)
                Codec.varuint(p15, 0)
            end

            table.clear(p14.Paths)
            table.clear(p14.Templates)
            p14.PathCount = 0
            p14.TemplateCount = 0
        end

        local v12 = p14.Paths[v8]

        if not v12 then
            v12 = {}
            p14.Paths[v8] = v12
        end

        NextKey = p14.NextKey
        p14.NextKey += 1
        p14.PathCount += 1
        v12[p19] = NextKey
    end

    p14.KeyOf[p16] = NextKey

    local v13 = if not p20 or not v11 then nil else p14.Templates[NextKey]

    if v13 and p17 < p16 then
        local v14, v15 = closest(v13, p21)
        local v16 = v15 > 0 and v14.ParentId == p17 and #v13 < 8 and p14.TemplateCount < 8192

        if v16 then
            p15:u8(Op.TemplateNext)
            p15:u8(TemplateNext.Keep)
        end

        local v17 = p16 - v14.Id
        local v18 = v17 - p14.LastOffset

        p15:u8(Op.Copy)
        Codec.varuint(p15, p16 - p14.LastAddId)
        Codec.varuint(p15, p16 - p17)
        Codec.varuint(p15, if v18 >= 0 then v18 * 2 else -v18 * 2 - 1)
        p14.LastOffset = v17
        p14.LastAddId = p16

        if not v16 then
            v14.Id = p16
            v14.ParentId = p17

            local v19 = table.find(v13, v14)

            if v19 ~= #v13 then
                table.remove(v13, v19)
                table.insert(v13, v14)
            end

            return v14, v14.Values
        end

        local t3 = {
            Id = p16,
            ParentId = p17,
            Values = table.clone(v14.Values)
        }

        table.insert(v13, t3)
        p14.TemplateCount += 1

        return t3, t3.Values
    end

    local v20 = p20 and v11

    if v20 then
        local v21 = p14.Templates[NextKey]

        if v21 then
            p14.TemplateCount -= #v21
        end

        if p14.TemplateCount >= 8192 then
            p15:u8(Op.DropTemplates)
            Codec.varuint(p15, 0)
            table.clear(p14.Templates)
            p14.TemplateCount = 0
        elseif v21 then
            writeDrop(p15, v21)
        end

        p15:u8(Op.TemplateNext)
        p15:u8(TemplateNext.Add)
    end

    p15:u8(Op.Add)
    Codec.varuint(p15, p16)
    Codec.varuint(p15, p17)
    Codec.varuint(p15, p18)
    Codec.str(p15, p19)
    p14.LastAddId = p16

    if not v20 then
        return nil, nil
    end

    p14.TemplateCount += 1

    local t4 = {}

    p14.Templates[NextKey] = {
        {
            Id = p16,
            ParentId = p17,
            Values = t4
        }
    }

    return nil, t4
end

function t1.Forget(p22, p23) -- line: 260
    p22.KeyOf[p23] = nil
end

return t1

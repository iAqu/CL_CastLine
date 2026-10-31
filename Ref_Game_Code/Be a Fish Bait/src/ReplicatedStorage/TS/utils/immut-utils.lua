-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local src = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "immut", "src")
local original, produce = src.original, src.produce

return {
    produceWrapper = function(p1) -- produceWrapper | line: 14
        -- upvalues: produce (copy)
        return function(p2, p3) -- line: 15
            -- upvalues: p1 (copy), produce (copy)
            return produce(p2, function(p4) -- line: 16
                -- upvalues: p3 (copy), p1 (copy)
                return p1(p4, p3)
            end)
        end
    end,
    push = function(p5, ...) -- push | line: 21
        -- upvalues: src (copy)
        local t1 = { ... }

        for i = 0, #t1 - 1 do
            src.table.insert(p5, t1[i + 1])
        end
    end,
    pop = function(p6) -- pop | line: 28
        -- upvalues: src (copy)
        if #p6 == 0 then
            return nil
        end

        return src.table.remove(p6)
    end,
    remove = function(p7, p8) -- remove | line: 34
        -- upvalues: src (copy)
        return src.table.remove(p7, p8 + 1)
    end,
    filterOriginal = function(p9, p10) -- filterOriginal | line: 37
        -- upvalues: original (copy)
        local v1 = original(p9)
        local t2 = {}
        local n1 = 0

        for v2, v3 in v1 do
            if p10(v3, v2 - 1, v1) == true then
                n1 += 1
                t2[n1] = v3
            end
        end

        return t2
    end,
    includesOriginal = function(p11, p12) -- includesOriginal | line: 52
        -- upvalues: original (copy)
        local v4 = original(p11)

        return table.find(v4, p12) ~= nil
    end
}

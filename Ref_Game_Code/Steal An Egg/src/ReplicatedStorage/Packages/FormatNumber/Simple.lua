-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "Oc",
    "No",
    "Dc",
    "Ud",
    "Dd",
    "Td",
    "Qad",
    "Qid",
    "Sxd",
    "Spd",
    "Ocd",
    "Nod",
    "Vg",
    "Uvg",
    "Dvg",
    "Tvg",
    "Qavg",
    "Qivg",
    "Sxvg",
    "Spvg",
    "Ocvg",
    "Novg",
    "Tg"
}
local Main = require(script.Parent.Main)
local t3 = {}
local t4 = {}
local t2 = {
    Format = function(p1, p2) -- Format | line: 45
        -- upvalues: Main (copy), t4 (copy)
        assert(type(p1) == "number", "Value provided must be a number")

        local v2 = if p2 == nil then "" else p2

        assert(type(v2) == "string", "Skeleton provided must be a string")

        local v4 = t4[v2]

        if not v4 then
            local v5

            v5, v4 = Main.NumberFormatter.forSkeleton(v2)
            assert(v5, v4)
            t4[v2] = v4
        end

        return v4:Format(p1)
    end,
    FormatCompact = function(p3, p4) -- FormatCompact | line: 72
        -- upvalues: t1 (copy), Main (copy), t3 (copy)
        assert(type(p3) == "number", "Value provided must be a number")

        local v7 = if p4 == nil then "" else p4

        assert(type(v7) == "string", "Skeleton provided must be a string")

        local v9 = t3[v7]

        if not v9 then
            local v10, v11 = Main.NumberFormatter.forSkeleton(v7)

            assert(v10, v11)
            v9 = v11:Notation(Main.Notation.compactWithSuffixThousands(t1))
            t3[v7] = v9
        end

        assert(#t1 ~= 0, "Please provide the suffix abbreviations for FormatCompact at the top of the Simple ModuleScript")

        return v9:Format(p3)
    end
}

return table.freeze(t2)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Sample = function(p1, p2, p3) -- Sample | line: 7
        if type(p1) == "table" then
            assert(#p1 == 2, "a random range needs exactly two bounds")

            return p3:NextNumber(p1[1], p1[2])
        end

        if p1 == nil then
            return p2
        end

        return p1
    end,
    Scale = function(p4, p5) -- Scale | line: 15
        if type(p4) == "number" then
            return p4 * p5
        end

        return if type(p4) == "table" then {
            p4[1] * p5,
            p4[2] * p5
        } else nil
    end,
    FromRange = function(p6, p7) -- FromRange | line: 25
        return {
            p6.Min * p7,
            p6.Max * p7
        }
    end
}

return table.freeze(t1)

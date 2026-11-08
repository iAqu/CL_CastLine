-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1) -- line: 1
    p1:RegisterType("mathOperator", p1.Cmdr.Util.MakeEnumType("Math Operator", {
        {
            Name = "+",
            Perform = function(p2, p3) -- Perform | line: 5
                return p2 + p3
            end
        },
        {
            Name = "-",
            Perform = function(p4, p5) -- Perform | line: 11
                return p4 - p5
            end
        },
        {
            Name = "*",
            Perform = function(p6, p7) -- Perform | line: 17
                return p6 * p7
            end
        },
        {
            Name = "/",
            Perform = function(p8, p9) -- Perform | line: 23
                return p8 / p9
            end
        },
        {
            Name = "**",
            Perform = function(p10, p11) -- Perform | line: 29
                return p10 ^ p11
            end
        },
        {
            Name = "%",
            Perform = function(p12, p13) -- Perform | line: 35
                return p12 % p13
            end
        }
    }))
end

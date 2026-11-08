-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)

return function(p1) -- line: 3
    -- upvalues: Util (copy)
    local t1 = {
        Transform = function(p2) -- Transform | line: 5
            -- upvalues: p1 (copy), Util (copy)
            return Util.MakeFuzzyFinder(p1:GetCommandNames())(p2)
        end,
        Validate = function(p3) -- Validate | line: 11
            return #p3 > 0, "No command with that name could be found."
        end,
        Autocomplete = function(p4) -- Autocomplete | line: 15
            return p4
        end,
        Parse = function(p5) -- Parse | line: 19
            return p5[1]
        end
    }

    p1:RegisterType("command", t1)
    p1:RegisterType("commands", Util.MakeListableType(t1))
end

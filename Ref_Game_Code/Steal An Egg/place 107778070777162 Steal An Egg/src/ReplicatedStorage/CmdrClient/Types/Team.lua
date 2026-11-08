-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Teams = game:GetService("Teams")
local Util = require(script.Parent.Parent.Shared.Util)
local t1 = {}

function t1.Transform(p1) -- line: 5
    -- upvalues: Teams (copy), Util (copy)
    return Util.MakeFuzzyFinder(Teams:GetTeams())(p1)
end

function t1.Validate(p2) -- line: 11
    return #p2 > 0, "No team with that name could be found."
end

function t1.Autocomplete(p3) -- line: 15
    -- upvalues: Util (copy)
    return Util.GetNames(p3)
end

function t1.Parse(p4) -- line: 19
    return p4[1]
end

local t2 = {
    Listable = true,
    Transform = t1.Transform,
    Validate = t1.Validate,
    Autocomplete = t1.Autocomplete,
    Parse = function(p5) -- Parse | line: 30
        return p5[1]:GetPlayers()
    end
}
local t3 = {
    Transform = t1.Transform,
    Validate = t1.Validate,
    Autocomplete = t1.Autocomplete,
    Parse = function(p6) -- Parse | line: 40
        return p6[1].TeamColor
    end
}

return function(p7) -- line: 45
    -- upvalues: Util (copy), t1 (copy), t2 (copy), t3 (copy)
    p7:RegisterType("team", t1)
    p7:RegisterType("teams", Util.MakeListableType(t1))
    p7:RegisterType("teamPlayers", t2)
    p7:RegisterType("teamColor", t3)
    p7:RegisterType("teamColors", Util.MakeListableType(t3))
end

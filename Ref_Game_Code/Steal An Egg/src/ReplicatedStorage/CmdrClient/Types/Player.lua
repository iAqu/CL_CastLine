-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local Players = game:GetService("Players")
local t1 = {}

function t1.Transform(p1) -- line: 5
    -- upvalues: Util (copy), Players (copy)
    return Util.MakeFuzzyFinder(Players:GetPlayers())(p1)
end

function t1.Validate(p2) -- line: 11
    return #p2 > 0, "No player with that name could be found."
end

function t1.Autocomplete(p3) -- line: 15
    -- upvalues: Util (copy)
    return Util.GetNames(p3)
end

function t1.Parse(p4) -- line: 19
    return p4[1]
end

function t1.Default(p5) -- line: 23
    return p5.Name
end

t1.ArgumentOperatorAliases = {
    me = ".",
    all = "*",
    others = "**",
    random = "?"
}

return function(p6) -- line: 35
    -- upvalues: Util (copy), t1 (copy)
    p6:RegisterType("player", t1)
    p6:RegisterType("players", Util.MakeListableType(t1, {
        Prefixes = "% teamPlayers"
    }))
end

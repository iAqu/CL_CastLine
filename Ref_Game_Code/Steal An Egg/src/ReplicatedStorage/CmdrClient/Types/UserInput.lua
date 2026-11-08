-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local EnumItems = Enum.UserInputType:GetEnumItems()

for _, v1 in pairs(Enum.KeyCode:GetEnumItems()) do
    EnumItems[#EnumItems + 1] = v1
end

local t1 = {}

function t1.Transform(p1) -- line: 10
    -- upvalues: Util (copy), EnumItems (copy)
    return Util.MakeFuzzyFinder(EnumItems)(p1)
end

function t1.Validate(p2) -- line: 16
    return #p2 > 0
end

function t1.Autocomplete(p3) -- line: 20
    -- upvalues: Util (copy)
    return Util.GetNames(p3)
end

function t1.Parse(p4) -- line: 24
    return p4[1]
end

return function(p5) -- line: 29
    -- upvalues: Util (copy), t1 (copy)
    p5:RegisterType("userInput", t1)
    p5:RegisterType("userInputs", Util.MakeListableType(t1))
end

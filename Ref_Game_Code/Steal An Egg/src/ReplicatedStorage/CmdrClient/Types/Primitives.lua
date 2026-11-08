-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local t1 = {
    Validate = function(p1) -- Validate | line: 4
        return p1 ~= nil
    end,
    Parse = function(p2) -- Parse | line: 8
        return (tostring(p2))
    end
}
local t2 = {
    Transform = function(p3) -- Transform | line: 14
        return (tonumber(p3))
    end,
    Validate = function(p4) -- Validate | line: 18
        return p4 ~= nil
    end,
    Parse = function(p5) -- Parse | line: 22
        return p5
    end
}
local t3 = {
    Transform = function(p6) -- Transform | line: 28
        return (tonumber(p6))
    end,
    Validate = function(p7) -- Validate | line: 32
        return p7 ~= nil and p7 == math.floor(p7), "Only whole numbers are valid."
    end,
    Parse = function(p8) -- Parse | line: 36
        return p8
    end
}
local t4 = {
    Transform = function(p9) -- Transform | line: 42
        return (tonumber(p9))
    end,
    Validate = function(p10) -- Validate | line: 46
        return p10 ~= nil and p10 == math.floor(p10) and p10 > 0, "Only positive whole numbers are valid."
    end,
    Parse = function(p11) -- Parse | line: 50
        return p11
    end
}
local t5 = {
    Transform = function(p12) -- Transform | line: 56
        return (tonumber(p12))
    end,
    Validate = function(p13) -- Validate | line: 60
        return p13 ~= nil and p13 == math.floor(p13) and p13 >= 0, "Only non-negative whole numbers are valid."
    end,
    Parse = function(p14) -- Parse | line: 64
        return p14
    end
}
local t6 = {
    Transform = function(p15) -- Transform | line: 70
        return (tonumber(p15))
    end,
    Validate = function(p16) -- Validate | line: 74
        return p16 ~= nil and p16 == math.floor(p16) and p16 >= 0 and p16 <= 255, "Only bytes are valid."
    end,
    Parse = function(p17) -- Parse | line: 78
        return p17
    end
}
local t7 = {
    Transform = function(p18) -- Transform | line: 84
        return (tonumber(p18))
    end,
    Validate = function(p19) -- Validate | line: 88
        return p19 ~= nil and p19 == math.floor(p19) and p19 >= 0 and p19 <= 9, "Only digits are valid."
    end,
    Parse = function(p20) -- Parse | line: 92
        return p20
    end
}
local v1 = Util.MakeDictionary({
    "true",
    "t",
    "yes",
    "y",
    "on",
    "enable",
    "enabled",
    "1",
    "+"
})
local v2 = Util.MakeDictionary({
    "false",
    "f",
    "no",
    "n",
    "off",
    "disable",
    "disabled",
    "0",
    "-"
})
local t8 = {
    Transform = function(p21) -- Transform | line: 102
        return p21:lower()
    end,
    Validate = function(p22) -- Validate | line: 106
        -- upvalues: v1 (copy), v2 (copy)
        return v1[p22] ~= nil or v2[p22] ~= nil, "Please use true/yes/on or false/no/off."
    end,
    Parse = function(p23) -- Parse | line: 110
        -- upvalues: v1 (copy), v2 (copy)
        if v1[p23] then
            return true
        end

        return if v2[p23] then false else nil
    end
}

return function(p24) -- line: 122
    -- upvalues: Util (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy)
    p24:RegisterType("string", t1)
    p24:RegisterType("number", t2)
    p24:RegisterType("integer", t3)
    p24:RegisterType("positiveInteger", t4)
    p24:RegisterType("nonNegativeInteger", t5)
    p24:RegisterType("byte", t6)
    p24:RegisterType("digit", t7)
    p24:RegisterType("boolean", t8)
    p24:RegisterType("strings", Util.MakeListableType(t1))
    p24:RegisterType("numbers", Util.MakeListableType(t2))
    p24:RegisterType("integers", Util.MakeListableType(t3))
    p24:RegisterType("positiveIntegers", Util.MakeListableType(t4))
    p24:RegisterType("nonNegativeIntegers", Util.MakeListableType(t5))
    p24:RegisterType("bytes", Util.MakeListableType(t6))
    p24:RegisterType("digits", Util.MakeListableType(t7))
    p24:RegisterType("booleans", Util.MakeListableType(t8))
end

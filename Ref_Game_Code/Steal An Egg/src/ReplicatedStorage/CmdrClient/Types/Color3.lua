-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local v1 = Util.MakeSequenceType({
    Prefixes = "# hexColor3 ! brickColor3",
    Length = 3,
    ValidateEach = function(p1, p2) -- ValidateEach | line: 5
        if p1 == nil then
            return false, ("Invalid or missing number at position %d in Color3 type."):format(p2)
        end

        if p1 < 0 or p1 > 255 then
            return false, ("Number out of acceptable range 0-255 at position %d in Color3 type."):format(p2)
        end

        if p1 % 1 == 0 then
            return true
        end

        return false, ("Number is not an integer at position %d in Color3 type."):format(p2)
    end,
    TransformEach = tonumber,
    Constructor = Color3.fromRGB
})

local function parseHexDigit(p3) -- line: 21
    return (tonumber(if #p3 == 1 then p3 .. p3 else p3, 16))
end

local t1 = {}

function t1.Transform(p4) -- line: 30
    -- upvalues: Util (copy), parseHexDigit (copy)
    local v3, v4, v5 = p4:match("^#?(%x%x?)(%x%x?)(%x%x?)$")

    return Util.Each(parseHexDigit, v3, v4, v5)
end

function t1.Validate(p5, p6, p7) -- line: 35
    return p5 ~= nil and p6 ~= nil and p7 ~= nil, "Invalid hex color"
end

function t1.Parse(...) -- line: 39
    return Color3.fromRGB(...)
end

return function(p8) -- line: 44
    -- upvalues: Util (copy), v1 (copy), t1 (copy)
    p8:RegisterType("color3", v1)
    p8:RegisterType("color3s", Util.MakeListableType(v1, {
        Prefixes = "# hexColor3s ! brickColor3s"
    }))
    p8:RegisterType("hexColor3", t1)
    p8:RegisterType("hexColor3s", Util.MakeListableType(t1))
end

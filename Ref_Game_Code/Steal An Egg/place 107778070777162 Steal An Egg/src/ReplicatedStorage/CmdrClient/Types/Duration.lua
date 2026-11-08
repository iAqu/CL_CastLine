-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local t1 = {
    Years = 31556926,
    Months = 2629744,
    Weeks = 604800,
    Days = 86400,
    Hours = 3600,
    Minutes = 60,
    Seconds = 1
}
local t2 = {}

for v1, _ in pairs(t1) do
    table.insert(t2, v1)
end

local v2 = Util.MakeFuzzyFinder(t2)

local function stringToSecondDuration(p1) -- line: 19
    -- upvalues: t1 (copy), v2 (copy)
    if p1 == nil or p1 == "" then
        return nil
    end

    local v3 = tonumber(p1)

    if v3 and v3 == 0 then
        return 0, 0, true
    end

    local v4 = p1:gsub("-?%d+%a+", ""):match("-?%d+")

    if v4 then
        return nil, tonumber(v4), true
    end

    local v5, v6

    for match in p1:gmatch("-?%d+%a+") do
        local v7

        v6, v7 = match:match("(-?%d+)(%a+)")

        local v8 = v2(v7)

        if #v8 == 0 then
            return nil, (tonumber(v6))
        end

        if v5 == nil then
            v5 = 0
        end

        v5 += (if v7:lower() == "m" then 60 else t1[v8[1]]) * tonumber(v6)
    end

    if v5 == nil then
        return nil
    end

    return v5, (tonumber(v6))
end

local function mapUnits(p2, p3, p4, p5) -- line: 58
    p5 = p5 or 1

    local t3 = {}

    for v10, v11 in pairs(p2) do
        if p4 == 1 then
            t3[v10] = p3 .. v11:sub(p5, #v11 - 1)
        else
            t3[v10] = p3 .. v11:sub(p5)
        end
    end

    return t3
end

local t4 = {}

function t4.Transform(p6) -- line: 72
    -- upvalues: stringToSecondDuration (copy)
    return p6, stringToSecondDuration(p6)
end

function t4.Validate(_, p8) -- line: 76
    return p8 ~= nil
end

function t4.Autocomplete(p9, p10, p11, p12, p13) -- line: 80
    -- upvalues: v2 (copy), mapUnits (copy)
    local t5 = {}

    if not (p12 or p13) then
        local v12

        if p10 ~= nil then
            local v13 = p9:match("^.*-?%d+(%a+)%s?$")

            v12 = mapUnits(v2(v13), p9, p11, #v13 + 1)
            table.sort(v12)
        else
            v12 = t5
        end

        return v12
    end

    local v15 = p12 == true and v2("") or p13

    if p12 == true then
        return (mapUnits(v15, p9, p11))
    end

    return (mapUnits(v15, p9, p9:match("^.*(%a+)$"):len() + 1))
end

function t4.Parse(_, p15) -- line: 104
    return p15
end

return function(p16) -- line: 109
    -- upvalues: Util (copy), t4 (copy)
    p16:RegisterType("duration", t4)
    p16:RegisterType("durations", Util.MakeListableType(t4))
end

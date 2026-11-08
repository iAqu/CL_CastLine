-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Expectation = require(script.Parent.Expectation)
local checkMatcherNameCollisions = Expectation.checkMatcherNameCollisions

local function copy(p1) -- line: 4
    local t1 = {}

    for v1, v2 in pairs(p1) do
        t1[v1] = v2
    end

    return t1
end

local t2 = {}

t2.__index = t2

function t2.new(p2) -- line: 17
    -- upvalues: t2 (copy)
    local t4

    if p2 then
        local _extensions = p2._extensions

        t4 = {}

        for v3, v4 in pairs(_extensions) do
            t4[v3] = v4
        end
    end

    if not p2 or not t4 then
        t4 = {}
    end

    return (setmetatable({
        _extensions = t4
    }, t2))
end

function t2.startExpectationChain(p3, ...) -- line: 25
    -- upvalues: Expectation (copy)
    return Expectation.new(...):extend(p3._extensions)
end

function t2.extend(p4, p5) -- line: 29
    -- upvalues: checkMatcherNameCollisions (copy)
    for v5, v6 in pairs(p5) do
        assert(p4._extensions[v5] == nil, string.format("Cannot reassign %q in expect.extend", v5))
        assert(checkMatcherNameCollisions(v5), string.format("Cannot overwrite matcher %q; it already exists", v5))
        p4._extensions[v5] = v6
    end
end

return t2

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestEnum = require(script.Parent.TestEnum)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 6
    -- upvalues: t1 (copy)
    return (setmetatable({
        _stack = {}
    }, t1))
end

function t1.getBeforeEachHooks(p1) -- line: 16
    -- upvalues: TestEnum (copy)
    local BeforeEach = TestEnum.NodeType.BeforeEach
    local t3 = {}

    for _, v1 in ipairs(p1._stack) do
        for _, v2 in ipairs(v1[BeforeEach]) do
            table.insert(t3, v2)
        end
    end

    return t3
end

function t1.getAfterEachHooks(p2) -- line: 32
    -- upvalues: TestEnum (copy)
    local AfterEach = TestEnum.NodeType.AfterEach
    local t4 = {}

    for _, v3 in ipairs(p2._stack) do
        for _, v4 in ipairs(v3[AfterEach]) do
            table.insert(t4, 1, v4)
        end
    end

    return t4
end

function t1.popHooks(p3) -- line: 48
    table.remove(p3._stack, #p3._stack)
end

function t1.pushHooksFrom(p4, p5) -- line: 52
    -- upvalues: TestEnum (copy)
    assert(p5 ~= nil)
    table.insert(p4._stack, {
        [TestEnum.NodeType.BeforeAll] = p4:_getHooksOfType(p5.children, TestEnum.NodeType.BeforeAll),
        [TestEnum.NodeType.AfterAll] = p4:_getHooksOfType(p5.children, TestEnum.NodeType.AfterAll),
        [TestEnum.NodeType.BeforeEach] = p4:_getHooksOfType(p5.children, TestEnum.NodeType.BeforeEach),
        [TestEnum.NodeType.AfterEach] = p4:_getHooksOfType(p5.children, TestEnum.NodeType.AfterEach)
    })
end

function t1.getBeforeAllHooks(p6) -- line: 66
    -- upvalues: TestEnum (copy)
    return p6._stack[#p6._stack][TestEnum.NodeType.BeforeAll]
end

function t1.getAfterAllHooks(p7) -- line: 73
    -- upvalues: TestEnum (copy)
    return p7._stack[#p7._stack][TestEnum.NodeType.AfterAll]
end

function t1._getHooksOfType(_, p9, p10) -- line: 77
    local t6 = {}

    for _, v6 in ipairs(p9) do
        if v6.type == p10 then
            table.insert(t6, v6.callback)
        end
    end

    return t6
end

return t1

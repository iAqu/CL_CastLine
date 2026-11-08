-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestEnum = require(script.Parent.TestEnum)
local Expectation = require(script.Parent.Expectation)

local function newEnvironment(p1, p2) -- line: 11
    -- upvalues: TestEnum (copy), Expectation (copy)
    local t1 = {}

    if p2 then
        if type(p2) ~= "table" then
            error(("Bad argument #2 to newEnvironment. Expected table, got %s"):format((typeof(p2))), 2)
        end

        for v1, v2 in pairs(p2) do
            t1[v1] = v2
        end
    end

    local function addChild(p3, p4, p5, p6) -- line: 24
        -- upvalues: p1 (copy), TestEnum (copy)
        local v3 = p1:addChild(p3, p5, p6)

        v3.callback = p4

        if p5 == TestEnum.NodeType.Describe then
            v3:expand()
        end

        return v3
    end

    function t1.describeFOCUS(p7, p8) -- line: 33
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p7, p8, TestEnum.NodeType.Describe, TestEnum.NodeModifier.Focus)
    end

    function t1.describeSKIP(p9, p10) -- line: 37
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p9, p10, TestEnum.NodeType.Describe, TestEnum.NodeModifier.Skip)
    end

    function t1.describe(p11, p12, _) -- line: 41
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p11, p12, TestEnum.NodeType.Describe, TestEnum.NodeModifier.None)
    end

    function t1.itFOCUS(p14, p15) -- line: 45
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p14, p15, TestEnum.NodeType.It, TestEnum.NodeModifier.Focus)
    end

    function t1.itSKIP(p16, p17) -- line: 49
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p16, p17, TestEnum.NodeType.It, TestEnum.NodeModifier.Skip)
    end

    function t1.itFIXME(p18, p19) -- line: 53
        -- upvalues: addChild (copy), TestEnum (copy)
        local v4 = addChild(p18, p19, TestEnum.NodeType.It, TestEnum.NodeModifier.Skip)

        warn("FIXME: broken test", v4:getFullName())
    end

    function t1.it(p20, p21, _) -- line: 58
        -- upvalues: addChild (copy), TestEnum (copy)
        addChild(p20, p21, TestEnum.NodeType.It, TestEnum.NodeModifier.None)
    end

    local n1 = 0
    local t2 = {
        [TestEnum.NodeType.BeforeAll] = "beforeAll",
        [TestEnum.NodeType.AfterAll] = "afterAll",
        [TestEnum.NodeType.BeforeEach] = "beforeEach",
        [TestEnum.NodeType.AfterEach] = "afterEach"
    }

    for v5, v6 in pairs(t2) do
        t1[v6] = function(p23) -- line: 73
            -- upvalues: addChild (copy), n1 (ref), v6 (copy), v5 (copy), TestEnum (copy)
            addChild(v6 .. "_" .. tostring(n1), p23, v5, TestEnum.NodeModifier.None)
            n1 += 1
        end
    end

    function t1.FIXME(p24) -- line: 79
        -- upvalues: p1 (copy), TestEnum (copy)
        warn("FIXME: broken test", p1:getFullName(), p24 or "")
        p1.modifier = TestEnum.NodeModifier.Skip
    end

    function t1.FOCUS() -- line: 85
        -- upvalues: p1 (copy), TestEnum (copy)
        p1.modifier = TestEnum.NodeModifier.Focus
    end

    function t1.SKIP() -- line: 89
        -- upvalues: p1 (copy), TestEnum (copy)
        p1.modifier = TestEnum.NodeModifier.Skip
    end

    function t1.HACK_NO_XPCALL() -- line: 97
        warn("HACK_NO_XPCALL is deprecated. It is now safe to yield in an xpcall, so this is no longer necessary. It can be safely deleted.")
    end

    t1.fit = t1.itFOCUS
    t1.xit = t1.itSKIP
    t1.fdescribe = t1.describeFOCUS
    t1.xdescribe = t1.describeSKIP
    t1.expect = setmetatable({
        extend = function(...) -- extend | line: 110
            error("Cannot call \"expect.extend\" from within a \"describe\" node.")
        end
    }, {
        __call = function(_, ...) -- __call | line: 114
            -- upvalues: Expectation (copy)
            return Expectation.new(...)
        end
    })

    return t1
end

local t5 = {}

t5.__index = t5

function t5.new(p26, p27, p28, p29) -- line: 130
    -- upvalues: TestEnum (copy), newEnvironment (copy), t5 (copy)
    local t6 = {
        callback = nil,
        parent = nil,
        plan = p26,
        phrase = p27,
        type = p28,
        modifier = p29 or TestEnum.NodeModifier.None,
        children = {}
    }

    t6.environment = newEnvironment(t6, p26.extraEnvironment)

    return (setmetatable(t6, t5))
end

local function getModifier(p30, p31, p32) -- line: 147
    -- upvalues: TestEnum (copy)
    if not p31 or p32 ~= nil and p32 ~= TestEnum.NodeModifier.None then
        return p32
    end

    if p30:match(p31) then
        return TestEnum.NodeModifier.Focus
    end

    return TestEnum.NodeModifier.Skip
end

function t5.addChild(p33, p34, p35, p36) -- line: 158
    -- upvalues: TestEnum (copy), t5 (copy), getModifier (copy)
    if p35 == TestEnum.NodeType.It then
        for _, v8 in pairs(p33.children) do
            if v8.phrase == p34 then
                error("Duplicate it block found: " .. v8:getFullName())
            end
        end
    end

    local v10 = getModifier(p33:getFullName() .. " " .. p34, p33.plan.testNamePattern, p36)
    local v11 = t5.new(p33.plan, p34, p35, v10)

    v11.parent = p33
    table.insert(p33.children, v11)

    return v11
end

function t5.getFullName(p37) -- line: 178
    local parent = p37.parent
    local v12 = if parent then p37.parent:getFullName() else nil

    if not parent or not v12 then
        return p37.phrase
    end

    return v12 .. " " .. p37.phrase
end

function t5.expand(p38) -- line: 192
    local v13 = getfenv(p38.callback)
    local self = setmetatable({}, {
        __index = v13
    })

    for v15, v16 in pairs(p38.environment) do
        self[v15] = v16
    end

    self.script = v13.script
    setfenv(p38.callback, self)

    local callback = p38.callback

    local function v17(p39) -- line: 203
        return debug.traceback(tostring(p39), 2)
    end

    local v18, v19 = xpcall(callback, v17)

    if not v18 then
        p38.loadError = v19
    end
end

local t9 = {}

t9.__index = t9

function t9.new(p40, p41) -- line: 218
    -- upvalues: t9 (copy)
    return (setmetatable({
        children = {},
        testNamePattern = p40,
        extraEnvironment = p41
    }, t9))
end

function t9.addChild(p42, p43, p44, p45) -- line: 231
    -- upvalues: t5 (copy), getModifier (copy)
    local v20 = getModifier(p43, p42.testNamePattern, p45)
    local v21 = t5.new(p42, p43, p44, v20)

    table.insert(p42.children, v21)

    return v21
end

function t9.addRoot(p46, p47, p48) -- line: 242
    -- upvalues: TestEnum (copy)
    local v22 = #p47
    local v23 = p46

    for i = v22, 1, -1 do
        local v24

        for _, v25 in ipairs(v23.children) do
            if v25.phrase == p47[i] then
                v24 = v25
                break
            end
        end

        v23 = if v24 ~= nil then v24 else v23:addChild(p47[i], TestEnum.NodeType.Describe)
    end

    v23.callback = p48
    v23:expand()
end

function t9.visitAllNodes(p49, p50, p51, p52) -- line: 268
    p51 = p51 or p49
    p52 = p52 or 0

    for _, v28 in ipairs(p51.children) do
        p50(v28, p52)
        p49:visitAllNodes(p50, v28, p52 + 1)
    end
end

function t9.visualize(p53) -- line: 283
    local t11 = {}

    p53:visitAllNodes(function(p54, p55) -- line: 285
        -- upvalues: t11 (copy)
        table.insert(t11, (" "):rep(3 * p55) .. p54.phrase)
    end)

    return table.concat(t11, "\n")
end

function t9.findNodes(p56, p57) -- line: 295
    local t12 = {}

    p56:visitAllNodes(function(p58) -- line: 297
        -- upvalues: p57 (copy), t12 (copy)
        if p57(p58) then
            table.insert(t12, p58)
        end
    end)

    return t12
end

return t9

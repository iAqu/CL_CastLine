-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestEnum = require(script.Parent.TestEnum)
local TestSession = require(script.Parent.TestSession)
local LifecycleHooks = require(script.Parent.LifecycleHooks)
local t1 = {
    environment = {}
}

local function wrapExpectContextWithPublicApi(p1) -- line: 19
    return (setmetatable({
        extend = function(...) -- extend | line: 21
            -- upvalues: p1 (copy)
            p1:extend(...)
        end
    }, {
        __call = function(_, ...) -- __call | line: 25
            -- upvalues: p1 (copy)
            return p1:startExpectationChain(...)
        end
    }))
end

function t1.runPlan(p3) -- line: 35
    -- upvalues: TestEnum (copy), TestSession (copy), LifecycleHooks (copy), t1 (copy)
    local v1 = TestSession.new(p3)
    local v2 = LifecycleHooks.new()

    v1.hasFocusNodes = #p3:findNodes(function(p4) -- line: 39
        -- upvalues: TestEnum (copy)
        return p4.modifier == TestEnum.NodeModifier.Focus
    end) > 0
    t1.runPlanNode(v1, p3, v2)

    return v1:finalize()
end

function t1.runPlanNode(p5, p6, p7) -- line: 54
    -- upvalues: TestEnum (copy), t1 (copy), wrapExpectContextWithPublicApi (copy)
    local function runCallback(p8, p9) -- line: 55
        -- upvalues: p5 (copy), t1 (copy), wrapExpectContextWithPublicApi (copy)
        local v3 = p9
        local v4 = true
        local v5

        _G.__TESTEZ_RUNNING_TEST__ = true
        v3 = p9 or ""

        local v6 = getfenv(p8)

        for v7, v8 in pairs(t1.environment) do
            v6[v7] = v8
        end

        v6.fail = function(p10) -- line: 71
            -- upvalues: v3 (ref), v4 (ref), v5 (ref)
            local v9 = if p10 == nil then "fail() was called." else p10

            v4 = false
            v5 = v3 .. debug.traceback(tostring(v9), 2)
        end

        v6.expect = wrapExpectContextWithPublicApi(p5:getExpectationContext())

        local v10 = p5:getContext()

        local function v11() -- line: 84
            -- upvalues: p8 (copy), v10 (copy)
            p8(v10)
        end

        local function v12(p11) -- line: 86
            -- upvalues: v3 (ref)
            return v3 .. debug.traceback(tostring(p11), 2)
        end

        local v13, v14 = xpcall(v11, v12)

        if not v13 then
            v4 = false
            v5 = v14
        end

        _G.__TESTEZ_RUNNING_TEST__ = nil

        return v4, v5
    end

    local function runNode(p12) -- line: 102
        -- upvalues: p7 (copy), runCallback (copy)
        for _, v15 in ipairs(p7:getBeforeEachHooks()) do
            local v16, v17 = runCallback(v15, "beforeEach hook: ")

            if not v16 then
                return false, v17
            end
        end

        local v18, v19 = runCallback(p12.callback)

        for _, v20 in ipairs(p7:getAfterEachHooks()) do
            local v21, v22 = runCallback(v20, "afterEach hook: ")

            if not v21 then
                if v18 then
                    return false, v22
                end

                return false, v19 .. "\nWhile cleaning up the failed test another error was found:\n" .. v22
            end
        end

        if v18 then
            return true, nil
        end

        return false, v19
    end

    p7:pushHooksFrom(p6)

    local v23 = false

    for _, v24 in ipairs(p7:getBeforeAllHooks()) do
        local v25, v26 = runCallback(v24, "beforeAll hook: ")

        if not v25 then
            v23 = true
            p5:addDummyError("beforeAll", v26)
        end
    end

    if not v23 then
        for _, v27 in ipairs(p6.children) do
            if v27.type == TestEnum.NodeType.It then
                p5:pushNode(v27)

                if p5:shouldSkip() then
                    p5:setSkipped()
                else
                    local v28, v29 = runNode(v27)

                    if v28 then
                        p5:setSuccess()
                    else
                        p5:setError(v29)
                    end
                end

                p5:popNode()
            elseif v27.type == TestEnum.NodeType.Describe then
                p5:pushNode(v27)
                t1.runPlanNode(p5, v27, p7)

                if v27.loadError then
                    p5:setError("Error during planning: " .. v27.loadError)
                else
                    p5:setStatusFromChildren()
                end

                p5:popNode()
            end
        end
    end

    for _, v30 in ipairs(p7:getAfterAllHooks()) do
        local v31, v32 = runCallback(v30, "afterAll hook: ")

        if not v31 then
            p5:addDummyError("afterAll", v32)
        end
    end

    p7:popHooks()
end

return t1

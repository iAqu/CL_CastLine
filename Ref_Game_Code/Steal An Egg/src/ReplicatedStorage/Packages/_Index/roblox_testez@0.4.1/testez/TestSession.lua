-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestEnum = require(script.Parent.TestEnum)
local TestResults = require(script.Parent.TestResults)
local Context = require(script.Parent.Context)
local ExpectationContext = require(script.Parent.ExpectationContext)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 24
    -- upvalues: TestResults (copy), t1 (copy)
    local t2 = {
        hasFocusNodes = false,
        results = TestResults.new(p1),
        nodeStack = {},
        contextStack = {},
        expectationContextStack = {}
    }

    setmetatable(t2, t1)

    return t2
end

function t1.calculateTotals(p2) -- line: 42
    -- upvalues: TestEnum (copy)
    local results = p2.results

    results.successCount = 0
    results.failureCount = 0
    results.skippedCount = 0
    results:visitAllNodes(function(p3) -- line: 49
        -- upvalues: results (copy), TestEnum (copy)
        local status = p3.status

        if p3.planNode.type ~= TestEnum.NodeType.It then
            return
        end

        if status == TestEnum.TestStatus.Success then
            results.successCount += 1
        elseif status == TestEnum.TestStatus.Failure then
            results.failureCount += 1
        elseif status == TestEnum.TestStatus.Skipped then
            results.skippedCount += 1
        end
    end)
end

function t1.gatherErrors(p4) -- line: 68
    local results = p4.results

    results.errors = {}
    results:visitAllNodes(function(p5) -- line: 73
        -- upvalues: results (copy)
        if not (#p5.errors > 0) then
            return
        end

        for _, v1 in ipairs(p5.errors) do
            table.insert(results.errors, v1)
        end
    end)
end

function t1.finalize(p6) -- line: 85
    if #p6.nodeStack ~= 0 then
        error("Cannot finalize TestResults with nodes still on the stack!", 2)
    end

    p6:calculateTotals()
    p6:gatherErrors()

    return p6.results
end

function t1.pushNode(p7, p8) -- line: 99
    -- upvalues: TestResults (copy), Context (copy), ExpectationContext (copy)
    local v2 = TestResults.createNode(p8)

    table.insert((p7.nodeStack[#p7.nodeStack] or p7.results).children, v2)
    table.insert(p7.nodeStack, v2)

    local v3 = p7.contextStack[#p7.contextStack]
    local v4 = Context.new(v3)

    table.insert(p7.contextStack, v4)

    local v5 = p7.expectationContextStack[#p7.expectationContextStack]
    local v6 = ExpectationContext.new(v5)

    table.insert(p7.expectationContextStack, v6)
end

function t1.popNode(p9) -- line: 117
    assert(#p9.nodeStack > 0, "Tried to pop from an empty node stack!")
    table.remove(p9.nodeStack, #p9.nodeStack)
    table.remove(p9.contextStack, #p9.contextStack)
    table.remove(p9.expectationContextStack, #p9.expectationContextStack)
end

function t1.getContext(p10) -- line: 127
    assert(#p10.contextStack > 0, "Tried to get context from an empty stack!")

    return p10.contextStack[#p10.contextStack]
end

function t1.getExpectationContext(p11) -- line: 132
    assert(#p11.expectationContextStack > 0, "Tried to get expectationContext from an empty stack!")

    return p11.expectationContextStack[#p11.expectationContextStack]
end

function t1.shouldSkip(p12) -- line: 140
    -- upvalues: TestEnum (copy)
    if p12.hasFocusNodes then
        for i = #p12.nodeStack, 1, -1 do
            local v10 = p12.nodeStack[i]

            if v10.planNode.modifier == TestEnum.NodeModifier.Skip then
                return true
            end

            if v10.planNode.modifier == TestEnum.NodeModifier.Focus then
                return false
            end
        end

        return true
    end

    for i = #p12.nodeStack, 1, -1 do
        if p12.nodeStack[i].planNode.modifier == TestEnum.NodeModifier.Skip then
            return true
        end
    end

    return false
end

function t1.setSuccess(p13) -- line: 174
    -- upvalues: TestEnum (copy)
    assert(#p13.nodeStack > 0, "Attempting to set success status on empty stack")
    p13.nodeStack[#p13.nodeStack].status = TestEnum.TestStatus.Success
end

function t1.setSkipped(p14) -- line: 182
    -- upvalues: TestEnum (copy)
    assert(#p14.nodeStack > 0, "Attempting to set skipped status on empty stack")
    p14.nodeStack[#p14.nodeStack].status = TestEnum.TestStatus.Skipped
end

function t1.setError(p15, p16) -- line: 191
    -- upvalues: TestEnum (copy)
    assert(#p15.nodeStack > 0, "Attempting to set error status on empty stack")

    local v14 = p15.nodeStack[#p15.nodeStack]

    v14.status = TestEnum.TestStatus.Failure
    table.insert(v14.errors, p16)
end

function t1.addDummyError(p17, p18, p19) -- line: 203
    -- upvalues: TestEnum (copy)
    p17:pushNode({
        type = TestEnum.NodeType.It,
        phrase = p18
    })
    p17:setError(p19)
    p17:popNode()
    p17.nodeStack[#p17.nodeStack].status = TestEnum.TestStatus.Failure
end

function t1.setStatusFromChildren(p20) -- line: 215
    -- upvalues: TestEnum (copy)
    assert(#p20.nodeStack > 0, "Attempting to set status from children on empty stack")

    local v16 = p20.nodeStack[#p20.nodeStack]
    local v17 = TestEnum.TestStatus.Success
    local v18 = true

    for _, v19 in ipairs(v16.children) do
        if v19.status ~= TestEnum.TestStatus.Skipped then
            if v19.status == TestEnum.TestStatus.Failure then
                v17 = TestEnum.TestStatus.Failure
            end

            v18 = false
        end
    end

    v16.status = if v18 then TestEnum.TestStatus.Skipped else v17
end

return t1

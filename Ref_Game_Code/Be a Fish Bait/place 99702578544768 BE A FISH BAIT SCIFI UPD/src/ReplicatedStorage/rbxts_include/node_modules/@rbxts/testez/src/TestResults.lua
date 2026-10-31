-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestEnum = require(script.Parent.TestEnum)
local t1 = {
    [TestEnum.TestStatus.Success] = "+",
    [TestEnum.TestStatus.Failure] = "-",
    [TestEnum.TestStatus.Skipped] = "~"
}
local t2 = {}

t2.__index = t2

function t2.new(p1) -- line: 25
    -- upvalues: t2 (copy)
    local t3 = {
        successCount = 0,
        failureCount = 0,
        skippedCount = 0,
        planNode = p1,
        children = {},
        errors = {}
    }

    setmetatable(t3, t2)

    return t3
end

function t2.createNode(p2) -- line: 43
    return {
        status = nil,
        planNode = p2,
        children = {},
        errors = {}
    }
end

function t2.visitAllNodes(p3, p4, p5) -- line: 57
    p5 = p5 or p3

    for _, v2 in ipairs(p5.children) do
        p4(v2)
        p3:visitAllNodes(p4, v2)
    end
end

function t2.visualize(p6, p7, p8) -- line: 70
    -- upvalues: TestEnum (copy), t1 (copy)
    p7 = p7 or p6
    p8 = p8 or 0

    local t4 = {}

    for _, v5 in ipairs(p7.children) do
        if v5.planNode.type == TestEnum.NodeType.It then
            local v6 = t1[v5.status] or "?"
            local v7 = ("%s[%s] %s"):format((" "):rep(3 * p8), v6, v5.planNode.phrase)

            if v5.messages and #v5.messages > 0 then
                v7 ..= "\n " .. (" "):rep(3 * p8) .. table.concat(v5.messages, "\n " .. (" "):rep(3 * p8))
            end

            table.insert(t4, v7)
        else
            local v8 = ("%s%s"):format((" "):rep(3 * p8), v5.planNode.phrase or "")

            if v5.status then
                v8 ..= (" (%s)"):format(v5.status)
            end

            table.insert(t4, v8)

            if #v5.children > 0 then
                table.insert(t4, (p6:visualize(v5, p8 + 1)))
            end
        end
    end

    return table.concat(t4, "\n")
end

return t2

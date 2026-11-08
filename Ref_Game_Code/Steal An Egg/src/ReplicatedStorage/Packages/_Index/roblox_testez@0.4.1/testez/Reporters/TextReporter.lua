-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestService = game:GetService("TestService")
local TestEnum = require(script.Parent.Parent.TestEnum)
local v1 = (" "):rep(3)
local t1 = {
    [TestEnum.TestStatus.Success] = "+",
    [TestEnum.TestStatus.Failure] = "-",
    [TestEnum.TestStatus.Skipped] = "~"
}
local t2 = {}

local function compareNodes(p1, p2) -- line: 20
    return p1.planNode.phrase:lower() < p2.planNode.phrase:lower()
end

local function reportNode(p3, p4, p5) -- line: 24
    -- upvalues: TestEnum (copy), v1 (copy), t1 (copy), compareNodes (copy), reportNode (copy)
    p4 = p4 or {}
    p5 = p5 or 0

    if p3.status ~= TestEnum.TestStatus.Skipped then
        local v4

        if p3.status then
            local v5 = t1[p3.status] or "?"

            v4 = ("%s[%s] %s"):format(v1:rep(p5), v5, p3.planNode.phrase)
        else
            v4 = ("%s%s"):format(v1:rep(p5), p3.planNode.phrase)
        end

        table.insert(p4, v4)
        table.sort(p3.children, compareNodes)

        for _, v6 in ipairs(p3.children) do
            reportNode(v6, p4, p5 + 1)
        end
    end

    return p4
end

local function reportRoot(p6) -- line: 52
    -- upvalues: compareNodes (copy), reportNode (copy)
    local t3 = {}

    table.sort(p6.children, compareNodes)

    for _, v7 in ipairs(p6.children) do
        reportNode(v7, t3, 0)
    end

    return t3
end

local function report(p7) -- line: 63
    -- upvalues: reportRoot (copy)
    local v8 = reportRoot(p7)

    return table.concat(v8, "\n")
end

function t2.report(p8) -- line: 69
    -- upvalues: TestService (copy), reportRoot (copy)
    local v9 = reportRoot(p8)
    local t4 = {
        "Test results:",
        table.concat(v9, "\n"),
        ("%d passed, %d failed, %d skipped"):format(p8.successCount, p8.failureCount, p8.skippedCount)
    }

    print(table.concat(t4, "\n"))

    if p8.failureCount > 0 then
        print(("%d test nodes reported failures."):format(p8.failureCount))
    end

    if not (#p8.errors > 0) then
        return
    end

    print("Errors reported by tests:")
    print("")

    for _, v10 in ipairs(p8.errors) do
        TestService:Error(v10)
        print("")
    end
end

return t2

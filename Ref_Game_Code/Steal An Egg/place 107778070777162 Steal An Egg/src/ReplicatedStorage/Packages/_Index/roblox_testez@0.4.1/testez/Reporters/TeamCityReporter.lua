-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestService = game:GetService("TestService")
local TestEnum = require(script.Parent.Parent.TestEnum)
local t1 = {}

local function teamCityEscape(p1) -- line: 7
    local v1 = string.gsub(p1, "([]|'[])", "|%1")
    local v2 = string.gsub(v1, "\r", "|r")

    return (string.gsub(v2, "\n", "|n"))
end

local function teamCityEnterSuite(p2) -- line: 14
    local format = string.format
    local v3 = string.gsub(p2, "([]|'[])", "|%1")
    local v4 = string.gsub(v3, "\r", "|r")

    return format("##teamcity[testSuiteStarted name='%s']", (string.gsub(v4, "\n", "|n")))
end

local function teamCityLeaveSuite(p3) -- line: 18
    local format = string.format
    local v5 = string.gsub(p3, "([]|'[])", "|%1")
    local v6 = string.gsub(v5, "\r", "|r")

    return format("##teamcity[testSuiteFinished name='%s']", (string.gsub(v6, "\n", "|n")))
end

local function teamCityEnterCase(p4) -- line: 22
    local format = string.format
    local v7 = string.gsub(p4, "([]|'[])", "|%1")
    local v8 = string.gsub(v7, "\r", "|r")

    return format("##teamcity[testStarted name='%s']", (string.gsub(v8, "\n", "|n")))
end

local function teamCityLeaveCase(p5) -- line: 26
    local format = string.format
    local v9 = string.gsub(p5, "([]|'[])", "|%1")
    local v10 = string.gsub(v9, "\r", "|r")

    return format("##teamcity[testFinished name='%s']", (string.gsub(v10, "\n", "|n")))
end

local function teamCityFailCase(p6, p7) -- line: 30
    local format = string.format
    local v11 = string.gsub(p6, "([]|'[])", "|%1")
    local v12 = string.gsub(v11, "\r", "|r")
    local v13 = string.gsub(v12, "\n", "|n")
    local v14 = string.gsub(p7, "([]|'[])", "|%1")
    local v15 = string.gsub(v14, "\r", "|r")

    return format("##teamcity[testFailed name='%s' message='%s']", v13, (string.gsub(v15, "\n", "|n")))
end

local function reportNode(p8, p9, p10) -- line: 38
    -- upvalues: TestEnum (copy), teamCityEnterSuite (copy), teamCityLeaveSuite (copy), teamCityEnterCase (copy), teamCityLeaveCase (copy), teamCityFailCase (copy), reportNode (copy)
    p9 = p9 or {}
    p10 = p10 or 0

    if p8.status == TestEnum.TestStatus.Skipped then
        return p9
    end

    if p8.planNode.type == TestEnum.NodeType.Describe then
        table.insert(p9, teamCityEnterSuite(p8.planNode.phrase))

        for _, v18 in ipairs(p8.children) do
            reportNode(v18, p9, p10 + 1)
        end

        table.insert(p9, teamCityLeaveSuite(p8.planNode.phrase))
    else
        table.insert(p9, teamCityEnterCase(p8.planNode.phrase))

        if p8.status == TestEnum.TestStatus.Failure then
            table.insert(p9, teamCityFailCase(p8.planNode.phrase, table.concat(p8.errors, "\n")))
        end

        table.insert(p9, teamCityLeaveCase(p8.planNode.phrase))
    end
end

local function reportRoot(p11) -- line: 59
    -- upvalues: reportNode (copy)
    local t2 = {}

    for _, v19 in ipairs(p11.children) do
        reportNode(v19, t2, 0)
    end

    return t2
end

local function report(p12) -- line: 69
    -- upvalues: reportRoot (copy)
    local v20 = reportRoot(p12)

    return table.concat(v20, "\n")
end

function t1.report(p13) -- line: 75
    -- upvalues: TestService (copy), reportRoot (copy)
    local v21 = reportRoot(p13)
    local t3 = {
        "Test results:",
        table.concat(v21, "\n"),
        ("%d passed, %d failed, %d skipped"):format(p13.successCount, p13.failureCount, p13.skippedCount)
    }

    print(table.concat(t3, "\n"))

    if p13.failureCount > 0 then
        print(("%d test nodes reported failures."):format(p13.failureCount))
    end

    if not (#p13.errors > 0) then
        return
    end

    print("Errors reported by tests:")
    print("")

    for _, v22 in ipairs(p13.errors) do
        TestService:Error(v22)
        print("")
    end
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestPlanner = require(script.Parent.TestPlanner)
local TestRunner = require(script.Parent.TestRunner)
local TextReporter = require(script.Parent.Reporters.TextReporter)
local t1 = {}

local function stripSpecSuffix(p1) -- line: 11
    return (p1:gsub("%.spec$", ""))
end

local function isSpecScript(p2) -- line: 14
    return p2:IsA("ModuleScript") and p2.Name:match("%.spec$")
end

local function getPath(p3, p4) -- line: 18
    p4 = p4 or game

    local t2 = {}
    local v2 = if p3.Name == "init.spec" then p3.Parent else p3

    while v2 ~= nil and v2 ~= p4 do
        table.insert(t2, (v2.Name:gsub("%.spec$", "")))
        v2 = v2.Parent
    end

    table.insert(t2, (p4.Name:gsub("%.spec$", "")))

    return t2
end

local function toStringPath(p5) -- line: 38
    local v5 = ""
    local v6 = true

    for _, v7 in ipairs(p5) do
        if v6 then
            v5 = v7
            v6 = false
        else
            v5 = v7 .. " " .. v5
        end
    end

    return v5
end

function t1.getModulesImpl(_, p7, p8, p9) -- line: 52
    -- upvalues: getPath (copy)
    p8 = p8 or {}
    p9 = p9 or p7

    if p9:IsA("ModuleScript") and p9.Name:match("%.spec$") then
        local v10 = require(p9)
        local v11 = getPath(p9, p7)
        local v12 = ""
        local v13 = true

        for _, v14 in ipairs(v11) do
            if v13 then
                v12 = v14
                v13 = false
            else
                v12 = v14 .. " " .. v12
            end
        end

        table.insert(p8, {
            method = v10,
            path = v11,
            pathStringForSorting = v12:lower()
        })
    end
end

function t1.getModules(p10, p11) -- line: 72
    local t4 = {}

    p10:getModulesImpl(p11, t4)

    for _, descendant in ipairs(p11:GetDescendants()) do
        p10:getModulesImpl(p11, t4, descendant)
    end

    return t4
end

function t1.run(p12, p13, p14, p15) -- line: 99
    -- upvalues: TestPlanner (copy), TestRunner (copy), TextReporter (copy)
    p14 = p14 or TextReporter
    p15 = p15 or {}

    local v17 = p15.showTimingInfo or false
    local testNamePattern = p15.testNamePattern
    local v18 = p15.extraEnvironment or {}

    if type(p13) ~= "table" then
        error(("Bad argument #1 to TestBootstrap:run. Expected table, got %s"):format((typeof(p13))), 2)
    end

    local v19 = tick()
    local t5 = {}

    for _, v20 in ipairs(p13) do
        local v21 = p12:getModules(v20)

        for _, v22 in ipairs(v21) do
            table.insert(t5, v22)
        end
    end

    local v23 = tick()
    local v24 = TestPlanner.createPlan(t5, testNamePattern, v18)
    local v25 = tick()
    local v26 = TestRunner.runPlan(v24)
    local v27 = tick()

    p14.report(v26)

    local v28 = tick()

    if v17 then
        local t6 = {
            ("Took %f seconds to locate test modules"):format(v23 - v19),
            ("Took %f seconds to create test plan"):format(v25 - v23),
            ("Took %f seconds to run tests"):format(v27 - v25),
            ("Took %f seconds to report tests"):format(v28 - v27)
        }

        print(table.concat(t6, "\n"))
    end

    return v26
end

return t1

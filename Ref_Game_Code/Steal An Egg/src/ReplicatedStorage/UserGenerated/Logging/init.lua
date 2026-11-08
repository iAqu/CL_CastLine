-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Keys = require(game.ReplicatedStorage.UserGenerated.Lang.Keys)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local Stringify = require(game.ReplicatedStorage.UserGenerated.Strings.Stringify)
local t1 = {
    Pretty = true,
    IndentChar = " ",
    IndentSize = 2
}

local function GetPrefix(p1) -- line: 39
    p1 = p1 or 0

    local sln, sln2, sln3 = debug.info(p1 + 2, "sln")
    local v2 = ("%*:%*"):format(sln, sln2)

    if sln3 then
        v2 ..= (" %*"):format(sln3)
    end

    return (("[%*]"):format(v2))
end

local function Format(p2) -- line: 49
    -- upvalues: Stringify (copy), t1 (copy)
    if type(p2) == "string" then
        return p2
    end

    if typeof(p2) == "Instance" then
        return (("%*[%*]"):format(p2.ClassName, (p2:GetFullName())))
    end

    return Stringify.Serialize(p2, t1)
end

local function FormatArgs(...) -- line: 59
    -- upvalues: Stringify (copy), t1 (copy)
    local v3 = table.pack(...)

    for i = 1, v3.n do
        local v4 = v3[i]

        if type(v4) ~= "string" then
            v4 = if typeof(v4) == "Instance" then ("%*[%*]"):format(v4.ClassName, (v4:GetFullName())) else Stringify.Serialize(v4, t1)
        end

        v3[i] = v4
    end

    return table.unpack(v3)
end

local function v5(...) -- line: 67
    -- upvalues: FormatArgs (copy)
    local spawn = task.spawn

    local function v6(p3, ...) -- line: 68
        -- upvalues: FormatArgs (copy)
        print(p3, FormatArgs(...))
    end

    local sln, sln2, sln3 = debug.info(2, "sln")
    local v7 = ("%*:%*"):format(sln, sln2)

    if sln3 then
        v7 ..= (" %*"):format(sln3)
    end

    spawn(v6, ("[%*]"):format(v7), ...)
end

local function v8(...) -- line: 72
    -- upvalues: FormatArgs (copy)
    local spawn = task.spawn

    local function v9(p4, ...) -- line: 73
        -- upvalues: FormatArgs (copy)
        warn(p4, FormatArgs(...))
    end

    local sln, sln2, sln3 = debug.info(2, "sln")
    local v10 = ("%*:%*"):format(sln, sln2)

    if sln3 then
        v10 ..= (" %*"):format(sln3)
    end

    spawn(v9, ("[%*]"):format(v10), ...)
end

if RunService:IsStudio() then
    v5, v8 = print, warn
end

local function v11() -- line: 85
end

local t2 = {
    Trace = 1,
    Debug = 2,
    Info = 3,
    Warn = 4,
    Error = 5,
    Critical = 6,
    Off = 7
}

table.freeze(t2)

local t3 = {
    Trace = v5,
    Debug = v5,
    Info = v5,
    Warn = v8,
    Error = v8,
    Critical = v8,
    Off = v11
}

table.freeze(t3)

local v12 = Asserts.Set(Keys(t2))
local v13 = table.clone(t3)
local v14 = "Info"

local function SetLevel(p5, p6) -- line: 113
    -- upvalues: v11 (copy), t2 (copy), t3 (copy), v13 (copy), v14 (ref)
    assert(t2[p5])
    assert(p6 == nil or type(p6) == "boolean")

    if v14 ~= p5 or p6 then
        v14 = p5

        local v18 = assert(t2[p5])

        for v19, v20 in pairs(t2) do
            if v18 <= v20 then
                v13[v19] = t3[v19]
            else
                v13[v19] = v11
            end
        end
    end
end

SetLevel(v14, true)

local t4 = {
    Levels = t2,
    AssertLevel = v12
}

setmetatable(t4, {
    __index = v13
})

function t4.GetLevel() -- line: 138
    -- upvalues: v14 (ref)
    return v14
end

function t4.SetLevel(p7) -- line: 142
    -- upvalues: SetLevel (copy)
    SetLevel(p7)
end

function t4.Sink(p8) -- line: 146
    -- upvalues: v13 (copy)
    return assert(v13[p8])
end

return table.freeze(t4)

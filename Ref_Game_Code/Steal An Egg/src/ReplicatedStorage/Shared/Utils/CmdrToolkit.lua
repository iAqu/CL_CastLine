-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {}

t2.__index = t2

function t1.Arg(p1, p2, p3, p4) -- line: 29
    return {
        Type = p1,
        Name = p2,
        Description = p3 or "",
        Optional = p4
    }
end

function t1.Manifest() -- line: 34
    -- upvalues: t2 (copy)
    local v1 = setmetatable({
        _actions = {}
    }, t2)

    return v1, function(...) -- line: 36
        -- upvalues: v1 (copy)
        return v1:Define(...)
    end
end

function t2.Define(p5, p6, p7, p8, p9) -- line: 41
    assert(type(p6) == "string" and p6 ~= "", "[CmdrToolkit] action name must be a non-empty string")
    assert(p5._actions[p6] == nil, (("[CmdrToolkit] duplicate action '%*'"):format(p6)))
    assert(type(p9) == "function", (("[CmdrToolkit] action '%*' needs a Run function"):format(p6)))
    p8 = p8 or {}

    for v8, v9 in ipairs(p8) do
        local v10 = false

        if type(v9) == "table" and (type(v9.Type) == "string" or type(v9.Type) == "table") then
            v10 = type(v9.Name) == "string"
        end

        assert(v10, (("[CmdrToolkit] action '%*' argument #%* needs a Type and a Name"):format(p6, v8)))
    end

    p5._actions[p6] = {
        Name = p6,
        Description = p7 or "",
        Args = p8,
        Run = p9
    }

    return p5
end

function t2.Get(p10, p11) -- line: 58
    return p10._actions[p11]
end

function t2.Names(p12) -- line: 62
    local t4 = {}

    for v12 in p12._actions do
        table.insert(t4, v12)
    end

    table.sort(t4)

    return t4
end

function t2.MaxArgs(p13) -- line: 72
    local n1 = 0

    for _, v13 in p13._actions do
        n1 = math.max(n1, #v13.Args)
    end

    return n1
end

function t1.Enum(p14, p15, p16) -- line: 83
    local function names() -- line: 84
        -- upvalues: p15 (copy)
        local v15 = table.clone(if type(p15) == "function" then p15() else p15)

        table.sort(v15)

        return v15
    end

    return {
        Name = p14,
        DisplayName = p14,
        Transform = function(p17) -- matching | line: 90
            -- upvalues: p15 (copy)
            local v16 = p17:lower()
            local t6 = {}
            local v17 = table.clone(if type(p15) == "function" then p15() else p15)

            table.sort(v17)

            local v18

            for _, v19 in v17 do
                if v19:lower() == v16 then
                    v18 = v19
                end

                if v19:lower():sub(1, #v16) == v16 then
                    table.insert(t6, v19)
                end
            end

            if v18 then
                return { v18 }
            end

            return t6
        end,
        Validate = function(p18) -- Validate | line: 111
            -- upvalues: p16 (copy)
            if #p18 == 1 then
                return true
            end

            if #p18 == 0 then
                return false, (("No %* by that name."):format(p16 or "value"))
            end

            return false, (("Ambiguous - matches %*: %*"):format(#p18, (table.concat(p18, ", "))))
        end,
        Autocomplete = function(p19) -- Autocomplete | line: 122
            return p19
        end,
        Parse = function(p20) -- Parse | line: 125
            return p20[1]
        end
    }
end

local function trailingArg(p21, p22, p23) -- line: 133
    return function(p24) -- line: 134
        -- upvalues: p21 (copy), p22 (copy), p23 (copy)
        local function v20() -- line: 135
            -- upvalues: p24 (copy), p22 (copy)
            local Argument = p24:GetArgument(p22)

            return Argument and Argument:GetValue()
        end

        local ok, result = pcall(v20)
        local v21 = ok and result and p21:Get(result)
        local v22 = v21 and v21.Args[p23]

        if v22 then
            return {
                Type = v22.Type,
                Name = v22.Name,
                Description = v22.Description,
                Optional = v22.Optional
            }
        end

        return {
            Type = "string",
            Name = "unused",
            Description = "(this action takes no further arguments)",
            Optional = true
        }
    end
end

function t1.Command(p25, p26) -- line: 155
    -- upvalues: t1 (copy)
    assert(type(p26) == "table", "[CmdrToolkit] Command needs an options table")
    assert(type(p26.Name) == "string", "[CmdrToolkit] Command needs a Name")

    local t7 = {}

    if p26.Scoped then
        table.insert(t7, {
            Type = "scope",
            Name = "scope",
            Description = p26.ScopeDescription or "global (all servers) or local (this one)"
        })
    end

    if p26.Subject then
        table.insert(t7, p26.Subject)
    end

    local v25 = #t7 + 1

    table.insert(t7, {
        Name = "action",
        Type = t1.Enum(("%*Action"):format(p26.Name), function() -- line: 173
            -- upvalues: p25 (copy)
            return p25:Names()
        end, "action"),
        Description = p26.ActionDescription or "The action to run"
    })

    for i = 1, p25:MaxArgs() do
        table.insert(t7, function(p27) -- line: 134
            -- upvalues: p25 (copy), v25 (copy), i (copy)
            local function v27() -- line: 135
                -- upvalues: v25 (copy), p27 (copy)
                local Argument = p27:GetArgument(v25)

                return Argument and Argument:GetValue()
            end

            local ok, result = pcall(v27)
            local v28 = ok and result and p25:Get(result)
            local v29 = v28 and v28.Args[i]

            if v29 then
                return {
                    Type = v29.Type,
                    Name = v29.Name,
                    Description = v29.Description,
                    Optional = v29.Optional
                }
            end

            return {
                Type = "string",
                Name = "unused",
                Description = "(this action takes no further arguments)",
                Optional = true
            }
        end)
    end

    return {
        Name = p26.Name,
        Aliases = p26.Aliases,
        Description = p26.Description,
        Group = p26.Group or "DefaultAdmin",
        Args = t7
    }
end

function t1.Executor(p28, p29) -- line: 195
    assert(type(p29) == "table", "[CmdrToolkit] Executor needs an options table")
    assert(type(p29.Context) == "function", "[CmdrToolkit] Executor needs a Context builder")

    local v32 = p29.Scoped == true
    local v33 = p29.Subject == true

    return function(p30, ...) -- line: 202
        -- upvalues: p28 (copy), p29 (copy), v33 (copy), v32 (copy)
        local v34 = table.pack(...)
        local v35, v36

        if v32 then
            v36 = v34[1]
            v35 = 1 + 1
        else
            v35 = 1
        end

        local v37

        if v33 then
            v37 = v34[v35]
            v35 += 1
        end

        local v38 = v34[v35]
        local v39 = v35 + 1
        local v40 = p28:Get(v38)

        if not v40 then
            return (("Unknown action '%*'"):format((tostring(v38))))
        end

        local v41, v42 = p29.Context(p30, v37)

        if not v41 then
            return v42 or "Command context unavailable"
        end

        if v32 then
            v41.scope = v36
        end

        local t10 = {
            v41
        }
        local v43

        if v33 then
            v43 = 1 + 1
            t10[v43] = v37
        else
            v43 = 1
        end

        for i = 1, #v40.Args do
            v43 += 1
            t10[v43] = v34[v39 + i - 1]
        end

        local Run = v40.Run
        local unpack = table.unpack
        local ok, result = pcall(Run, unpack(t10, 1, v43))

        if ok then
            return result
        end

        return (("%* failed: %*"):format(v38, result))
    end
end

return t1

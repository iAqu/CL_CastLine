-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {
    "fatal",
    "error",
    "warn",
    "info",
    "debug",
    "trace"
}
local t2 = {
    error = true,
    fatal = true
}
local t3 = {}
local t4

local function discard() -- line: 39
end

local function merged(p1, p2) -- line: 41
    local v1 = table.clone(p1)

    for v2, v3 in p2 or {} do
        v1[v2] = v3
    end

    return v1
end

local function describe(p3) -- line: 51
    if typeof(p3) == "Instance" then
        local Parent = p3.Parent

        return (("%*/%*"):format(Parent and Parent.Name or "?", p3.Name))
    end

    if typeof(p3) == "string" then
        return p3
    end

    return "UNKNOWN"
end

local function escalate(p4, p5) -- line: 62
    -- upvalues: t2 (copy)
    local v4 = t2[p4.level]

    if v4 then
        warn(debug.traceback(p5 or "a record was escalated without a headline"))
    end

    return v4
end

t4 = {
    __index = {
        log = function(p6, p7, p8, p9) -- log | line: 72
            -- upvalues: t1 (copy)
            if table.find(t1, p7) > table.find(t1, p6.threshold) then
                return
            end

            local t6 = {
                level = p7,
                message = p8
            }
            local bindings = p6.bindings
            local v5 = table.clone(bindings)

            for v6, v7 in p9 or {} do
                v5[v6] = v7
            end

            t6.context = v5

            local emit = p6.emit
            local ok, result = pcall(emit, t6)

            if not ok then
                warn((("the log sink raised while taking a record: %*"):format(result)))
            end
        end,
        extend = function(p10, p11) -- extend | line: 89
            -- upvalues: t4 (ref)
            local t7 = {
                emit = p10.emit
            }
            local bindings = p10.bindings
            local v8 = table.clone(bindings)

            for v9, v10 in p11 or {} do
                v8[v9] = v10
            end

            t7.bindings = v8
            t7.threshold = p10.threshold

            return (setmetatable(t7, t4))
        end,
        setLevel = function(p12, p13) -- setLevel | line: 99
            -- upvalues: t1 (copy)
            if table.find(t1, p13) == nil then
                error((("%* is not a severity this logger knows"):format(p13)))
            end

            p12.threshold = p13

            return p12
        end
    }
}

function t3.createLogger(p14, p15) -- line: 112
    -- upvalues: t4 (ref), discard (copy)
    return (setmetatable({
        threshold = "info",
        emit = if typeof(p14) == "function" then p14 else discard,
        bindings = p15 or {}
    }, t4))
end

function t3.createDefaultCallback(p16) -- line: 119
    -- upvalues: RunService (copy), t2 (copy)
    local v11 = "UNKNOWN"

    if typeof(p16) == "Instance" then
        local Parent = p16.Parent

        v11 = ("%*/%*"):format(Parent and Parent.Name or "?", p16.Name)
    elseif typeof(p16) == "string" then
        v11 = p16
    end

    local v12 = RunService:IsStudio()

    return function(p17) -- line: 125
        -- upvalues: v12 (copy), v11 (ref), t2 (copy)
        local v13 = if v12 then ("[%*][%*] %*"):format(v11, p17.level, p17.message) else ("[%*] %*"):format(v11, p17.message)

        if v12 and p17.context then
            print(("[%*] bound context ->"):format(v11), p17.context)
        end

        if t2[p17.level] then
            warn(debug.traceback(v13 or "a record was escalated without a headline"))
        else
            local v14

            if v12 then
                v14 = if p17.level == "warn" then warn else print
                v14(v13)
            end
        end
    end
end

return t3

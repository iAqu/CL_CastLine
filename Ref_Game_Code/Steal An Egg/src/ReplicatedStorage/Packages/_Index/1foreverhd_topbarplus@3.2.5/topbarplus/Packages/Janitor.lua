-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Heartbeat = game:GetService("RunService").Heartbeat

local function getPromiseReference() -- line: 24
    return false
end

local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 29
    return "IndicesReference"
end

local v2 = newproxy(true)

getmetatable(v2).__tostring = function() -- line: 34
    return "LinkToInstanceIndex"
end

local t1 = {
    IGNORE_MEMORY_DEBUG = true,
    ClassName = "Janitor",
    __index = {
        CurrentlyCleaning = true,
        [v1] = nil
    }
}
local t3 = {
    ["function"] = true,
    Promise = "cancel",
    RBXScriptConnection = "Disconnect"
}

function t1.new() -- line: 56
    -- upvalues: v1 (copy), t1 (copy)
    return (setmetatable({
        CurrentlyCleaning = false,
        [v1] = nil
    }, t1))
end

function t1.Is(p1) -- line: 63
    -- upvalues: t1 (copy)
    if type(p1) == "table" then
        return getmetatable(p1) == t1
    end

    return false
end

t1.is = t1.Is

function t1.__index.Add(p2, p3, p4, p5) -- line: 69
    -- upvalues: v1 (copy), t3 (copy)
    if p5 then
        p2:Remove(p5)

        local v3 = p2[v1]

        if not v3 then
            v3 = {}
            p2[v1] = v3
        end

        v3[p5] = p3
    end

    local v4 = typeof(p3)

    if v4 == "table" and string.match(tostring(p3), "Promise") then
        v4 = "Promise"
    end

    p4 = p4 or t3[v4] or "Destroy"

    if type(p3) ~= "function" and not p3[p4] then
        warn(string.format("Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s", tostring(p3), tostring(p4), debug.traceback(nil, 2)))
    end

    p2[p3] = {
        p4,
        (debug.traceback(""))
    }

    return p3
end

t1.__index.Give = t1.__index.Add

function t1.__index.AddPromise(_, p7) -- line: 108
    return p7
end

t1.__index.GivePromise = t1.__index.AddPromise

function t1.__index.AddObject(p8, p9) -- line: 142
    local v6 = newproxy(false)

    return p8:Add(p9, false, v6), v6
end

t1.__index.GiveObject = t1.__index.AddObject

function t1.__index.Remove(p10, p11) -- line: 160
    -- upvalues: v1 (copy)
    local v7 = p10[v1]
    local v8, v9

    if v7 then
        v8 = v7[p11]

        if v8 then
            local v10 = p10[v8]

            v9 = v10 and v10[1]

            if v9 then
                if v9 == true then
                    v8()
                else
                    local v11 = v8[v9]

                    if v11 then
                        v11(v8)
                    end
                end

                p10[v8] = nil
            end

            v7[p11] = nil
        end
    end

    return p10
end

function t1.__index.Get(p12, p13) -- line: 189
    -- upvalues: v1 (copy)
    local v12 = p12[v1]

    return if v12 then v12[p13] else nil
end

function t1.__index.Cleanup(p14) -- line: 197
    -- upvalues: v1 (copy)
    if p14.CurrentlyCleaning then
        return
    end

    p14.CurrentlyCleaning = nil

    for v13, v14 in next, p14 do
        if v13 ~= v1 then
            local v15 = type(v13)

            if v15 ~= "string" and v15 ~= "number" then
                local v16 = v14[1]
                local v17 = v14[2]

                local function warnUser(p15) -- line: 214
                    -- upvalues: v17 (copy)
                    local v18 = debug.traceback("", 3)

                    warn("-------- Janitor Error --------" .. "\n" .. tostring(p15) .. "\n" .. v18 .. "" .. v17)
                end

                if v16 == true then
                    local ok, result = pcall(v13)

                    if not ok then
                        local v19 = debug.traceback("", 3)

                        warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. v19 .. "" .. v17)
                    end
                else
                    local v20 = v13[v16]

                    if v20 then
                        local ok, result = pcall(v20, v13)
                        local v21 = typeof(v13) == "Instance" and v20 == "Destroy"

                        if not ok and not v21 then
                            local v22 = debug.traceback("", 3)

                            warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. v22 .. "" .. v17)
                        end
                    end
                end
            end

            p14[v13] = nil
        end
    end

    local v23 = p14[v1]

    if v23 then
        for v24 in next, v23 do
            v23[v24] = nil
        end

        p14[v1] = {}
    end

    p14.CurrentlyCleaning = false
end

t1.__index.Clean = t1.__index.Cleanup

function t1.__index.Destroy(p16) -- line: 261
    p16:Cleanup()
end

t1.__call = t1.__index.Cleanup

local t5 = {
    Connected = true
}

t5.__index = t5

function t5.Disconnect(p17) -- line: 271
    if p17.Connected then
        p17.Connected = false
        p17.Connection:Disconnect()
    end
end

function t5.__tostring(p18) -- line: 278
    return "Disconnect<" .. tostring(p18.Connected) .. ">"
end

function t1.__index.LinkToInstance(p19, p20, p21) -- line: 282
    -- upvalues: Heartbeat (copy), v2 (copy), t5 (copy)
    local connection
    local v25 = p21 and newproxy(false) or v2
    local v26 = p20.Parent == nil
    local self = setmetatable({}, t5)

    local function ChangedFunction(_, p23) -- line: 288
        -- upvalues: p19 (copy), connection (ref), v26 (ref), self (copy), Heartbeat (copy)
        if self.Connected then
            v26 = p23 == nil

            if v26 then
                coroutine.wrap(function() -- line: 294
                    -- upvalues: p19 (copy), connection (ref), v26 (ref), self (copy), Heartbeat (copy)
                    Heartbeat:Wait()

                    if self.Connected then
                        if connection.Connected then
                            while v26 and connection.Connected and self.Connected do
                                Heartbeat:Wait()
                            end

                            if self.Connected and v26 then
                                p19:Cleanup()
                            end
                        else
                            p19:Cleanup()
                        end
                    end
                end)()
            end
        end
    end

    connection = p20.AncestryChanged:Connect(ChangedFunction)
    self.Connection = connection

    if v26 then
        local Parent = p20.Parent

        if self.Connected then
            v26 = Parent == nil

            if v26 then
                coroutine.wrap(function() -- line: 294
                    -- upvalues: p19 (copy), connection (ref), v26 (ref), self (copy), Heartbeat (copy)
                    Heartbeat:Wait()

                    if self.Connected then
                        if connection.Connected then
                            while v26 and connection.Connected and self.Connected do
                                Heartbeat:Wait()
                            end

                            if self.Connected and v26 then
                                p19:Cleanup()
                            end
                        else
                            p19:Cleanup()
                        end
                    end
                end)()
            end
        end
    end

    return p19:Add(self, "Disconnect", v25)
end

function t1.__index.LinkToInstances(p24, ...) -- line: 325
    -- upvalues: t1 (copy)
    local v28 = t1.new()

    for _, v29 in ipairs({ ... }) do
        v28:Add(p24:LinkToInstance(v29, true), "Disconnect")
    end

    return v28
end

for v30, v31 in next, t1.__index do
    local v33 = string.sub(string.lower(v30), 1, 1) .. string.sub(v30, 2)

    t1.__index[v33] = v31
end

return t1

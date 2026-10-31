-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Promise = require(script.Parent.Promise)
local RunService = game:GetService("RunService")
local t1 = {
    Promise = Promise
}

local function isPlugin(p1) -- line: 13
    -- upvalues: RunService (copy)
    return RunService:IsStudio() and p1:FindFirstAncestorWhichIsA("Plugin") ~= nil
end

function t1.getModule(p2, p3, p4) -- line: 17
    -- upvalues: RunService (copy)
    local v1, v2

    if p4 ~= nil then
        v1 = p3
        v2 = p4
    else
        v1 = "@rbxts"
        v2 = p3
    end

    if RunService:IsRunning() and RunService:IsClient() and (not RunService:IsStudio() or p2:FindFirstAncestorWhichIsA("Plugin") == nil) and not game:IsLoaded() then
        game.Loaded:Wait()
    end

    local v3 = p2
    local v4

    while true do
        local node_modules = v3:FindFirstChild("node_modules")

        if node_modules then
            local v5 = node_modules:FindFirstChild(v1)

            if v5 then
                v4 = v5:FindFirstChild(v2)

                if not not v4 then
                    break
                end
            end
        end

        v3 = v3.Parent

        if v3 == nil then
            error("roblox-ts: " .. "Could not find module: " .. v2, 2)

            return
        end
    end

    return v4
end

local t2 = {}
local t3 = {}

function t1.import(p5, p6, ...) -- line: 51
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v6 = select("#", ...)
    local v7 = p6

    for i = 1, v6 do
        v7 = v7:WaitForChild((select(i, ...)))
    end

    if v7.ClassName ~= "ModuleScript" then
        error("roblox-ts: " .. "Failed to import! Expected ModuleScript, got " .. v7.ClassName, 2)
    end

    t3[p5] = v7

    local v8 = v7
    local n1 = 0

    while v8 do
        n1 += 1
        v8 = t3[v8]

        if v8 == v7 then
            local v9 = v8.Name

            for _ = 1, n1 do
                v8 = t3[v8]
                v9 ..= "  ⇒ " .. v8.Name
            end

            error("roblox-ts: " .. "Failed to import! Detected a circular dependency chain: " .. v9, 2)
        end
    end

    if not t2[v7] then
        if _G[v7] then
            error("roblox-ts: " .. "Invalid module access! Do you have multiple TS runtimes trying to import this? " .. v7:GetFullName(), 2)
        end

        _G[v7] = t1
        t2[v7] = true
    end

    local v10 = require(v7)

    if t3[p5] == v7 then
        t3[p5] = nil
    end

    return v10
end

function t1.instanceof(p7, p8) -- line: 111
    local v11 = type(p8) == "table"
    local v12 = if v11 then type(p8.instanceof) == "function" else nil

    if v11 and v12 then
        return p8.instanceof(p7)
    end

    if type(p7) ~= "table" then
        return false
    end

    local mt = getmetatable(p7)

    while true do
        if mt == nil then
            return false
        end

        if mt == p8 then
            break
        end

        local mt2 = getmetatable(mt)

        mt = if mt2 then mt2.__index else nil
    end

    return true
end

function t1.async(p9) -- line: 136
    -- upvalues: Promise (copy)
    return function(...) -- line: 137
        -- upvalues: p9 (copy), Promise (copy)
        local v13 = select("#", ...)
        local t4 = { ... }

        return Promise.new(function(p10, p11) -- line: 140
            -- upvalues: v13 (copy), t4 (copy), p9 (copy)
            coroutine.wrap(function() -- line: 141
                -- upvalues: p10 (copy), p11 (copy), v13 (copy), t4 (copy), p9 (copy)
                local _unpack = unpack
                local ok, result = pcall(p9, _unpack(t4, 1, v13))

                if ok then
                    p10(result)
                else
                    p11(result)
                end
            end)()
        end)
    end
end

function t1.await(p12) -- line: 153
    -- upvalues: Promise (copy)
    if not Promise.is(p12) then
        return p12
    end

    local v14, v15 = p12:awaitStatus()

    if v14 == Promise.Status.Resolved then
        return v15
    end

    if v14 == Promise.Status.Rejected then
        error(v15, 2)
    else
        error("The awaited Promise was cancelled", 2)
    end
end

local function bit_sign(p13) -- line: 170
    if bit32.btest(p13, 2147483648) then
        return p13 - 4294967296
    end

    return p13
end

function t1.bit_lrsh(p14, p15) -- line: 179
    local v16 = bit32.arshift(p14, p15)

    if bit32.btest(v16, 2147483648) then
        return v16 - 4294967296
    end

    return v16
end

t1.TRY_RETURN = 1
t1.TRY_BREAK = 2
t1.TRY_CONTINUE = 3

function t1.try(p16, p17, p18) -- line: 187
    -- upvalues: t1 (copy)
    local v17, v18, v19 = pcall(p16)
    local v20, v21, v22, v23, v24, v25, v26, v27
    local v28 = v19

    if v17 then
        v24 = v18
        v25 = true
    else
        v18, v23 = nil, v18
        v24 = v18

        if p17 then
            v20, v21, v22 = pcall(p17, v23)

            if not v20 then
                v26 = v21
                v21 = nil
            end

            v27 = v26

            if v21 then
                v24 = v21
                v28 = v22
            end

            v25 = v20
        else
            v25 = true
        end
    end

    local v29 = v24
    local v30 = v28

    if p18 then
        v29, v30 = p18()

        if not v29 then
            v29 = v24
            v30 = v28
        end
    end

    if v29 ~= t1.TRY_RETURN and v29 ~= t1.TRY_BREAK and v29 ~= t1.TRY_CONTINUE then
        if not v25 then
            error(v27, 2)
        end

        if not v17 and not p17 then
            error(v23, 2)
        end
    end

    return v29, v30
end

function t1.generator(p19) -- line: 240
    local v31 = coroutine.create(p19)

    return {
        next = function(...) -- next | line: 243
            -- upvalues: v31 (copy)
            if coroutine.status(v31) == "dead" then
                return {
                    done = true
                }
            end

            local v32, v33 = coroutine.resume(v31, ...)

            if v32 == false then
                error(v33, 2)
            end

            return {
                value = v33,
                done = coroutine.status(v31) == "dead"
            }
        end
    }
end

return t1

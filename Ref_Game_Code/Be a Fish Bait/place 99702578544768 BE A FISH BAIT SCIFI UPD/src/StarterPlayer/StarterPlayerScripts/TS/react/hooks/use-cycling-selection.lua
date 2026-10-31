-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace

return {
    useCyclingSelection = function(p1) -- useCyclingSelection | line: 16
        -- upvalues: useEffect (copy), useRef (copy), useState (copy), RunService (copy), Workspace (copy)
        local items, isActive, expireTimestamp, baseInterval = p1.items, p1.isActive, p1.expireTimestamp, p1.baseInterval
        local v1 = baseInterval

        if baseInterval == nil then
            v1 = 0.1
        end

        local maxInterval = p1.maxInterval
        local v2 = maxInterval

        if maxInterval == nil then
            v2 = 0.5
        end

        local onComplete = p1.onComplete
        local v3, v4 = useState(0)
        local v5 = useRef(nil)
        local v6 = useRef(false)
        local v7 = useRef(nil)
        local v8 = useRef(onComplete)
        local v9 = useRef(false)

        useEffect(function() -- line: 37
            -- upvalues: onComplete (copy), v8 (copy)
            v8.current = onComplete
        end, { onComplete })
        useEffect(function() -- line: 41
            -- upvalues: items (copy), isActive (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v9 (copy), Workspace (copy)
            if not v6.current and isActive and #items > 0 then
                local ServerTimeNow = Workspace:GetServerTimeNow()

                v5.current = ServerTimeNow
                v7.current = ServerTimeNow
                v4(0)
                v9.current = false
            end

            v6.current = isActive
        end, { isActive, #items })
        useEffect(function() -- line: 55
            -- upvalues: items (copy), isActive (copy), expireTimestamp (copy), v1 (ref), v2 (ref), v3 (copy), v4 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), RunService (copy), Workspace (copy)
            if not isActive or #items == 0 then
                v7.current = nil
                v9.current = false

                return nil
            end

            local connection = RunService.Heartbeat:Connect(function() -- line: 61
                -- upvalues: items (copy), expireTimestamp (copy), v1 (ref), v2 (ref), v3 (copy), v4 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), Workspace (copy)
                local ServerTimeNow = Workspace:GetServerTimeNow()

                if v5.current == nil or v7.current == nil then
                    return
                end

                local current = v5.current
                local v10 = expireTimestamp - current
                local v11 = ServerTimeNow - current

                if ServerTimeNow < expireTimestamp and v10 > 0 then
                    local v12 = v11 / v10
                    local v13 = v12 * v12

                    if v1 + (v2 - v1) * v13 <= ServerTimeNow - v7.current then
                        v4(function(p2) -- line: 73
                            -- upvalues: items (copy)
                            return (p2 + 1) % #items
                        end)
                        v7.current = ServerTimeNow
                    end
                else
                    if not v9.current and v8.current then
                        v9.current = true
                        v8.current(v3)
                    end

                    v7.current = nil
                end
            end)

            return function() -- line: 87
                -- upvalues: connection (copy)
                connection:Disconnect()
            end
        end, { isActive, items, expireTimestamp, v1, v2, v3 })

        return v3
    end
}

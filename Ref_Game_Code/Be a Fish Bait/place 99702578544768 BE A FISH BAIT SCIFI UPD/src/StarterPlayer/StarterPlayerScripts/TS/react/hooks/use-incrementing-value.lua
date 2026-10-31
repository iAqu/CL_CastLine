-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useRef = react.useBinding, react.useEffect, react.useRef
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate

return {
    default = function(p1, p2, p3) -- useIncrementingValue | line: 14
        -- upvalues: useBinding (copy), useEffect (copy), useRef (copy), RunService (copy), Workspace (copy), abbreviate (copy)
        local v1, v2 = useBinding("$0/s")
        local v3 = useRef(nil)

        useEffect(function() -- line: 17
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), v2 (copy), v3 (copy), RunService (copy), Workspace (copy), abbreviate (copy)
            if p3 then
                v3.current = Workspace:GetServerTimeNow()

                local connection

                connection = RunService.Heartbeat:Connect(function() -- line: 25
                    -- upvalues: connection (ref), p1 (copy), p2 (copy), v2 (copy), v3 (copy), Workspace (copy), abbreviate (copy)
                    local current = v3.current

                    if current == nil then
                        return nil
                    end

                    local v5 = math.min((Workspace:GetServerTimeNow() - current) / p2, 1)

                    v2((("$%*/s"):format((abbreviate((math.floor(p1 * v5)))))))

                    if v5 >= 1 then
                        connection:Disconnect()
                    end
                end)

                return function() -- line: 38
                    -- upvalues: connection (ref)
                    return connection:Disconnect()
                end
            end

            v3.current = nil
            v2("$0/s")

            return nil
        end, { p3, p1, p2, v2 })

        return v1
    end
}

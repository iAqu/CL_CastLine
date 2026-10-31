-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local useBindingListener = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useBindingListener
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect, useState = react.useBinding, react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace

return {
    default = function(p1) -- useCountdown | line: 12
        -- upvalues: Maid (copy), useBindingListener (copy), useBinding (copy), useEffect (copy), useState (copy), RunService (copy), Workspace (copy)
        local v1, v2 = useState(p1 ~= nil)
        local v3, v4 = useBinding(nil)
        local v5 = v3:map(function(p2) -- line: 16
            if p2 then
                return (math.max(0, (math.ceil(math.floor(p2.timestamp) - p2.timeNow))))
            end

            return 0
        end)

        useEffect(function() -- line: 19
            -- upvalues: p1 (copy), v2 (copy)
            if p1 ~= nil then
                v2(true)
            else
                v2(false)
            end
        end, { p1 })
        useEffect(function() -- line: 26
            -- upvalues: p1 (copy), v1 (copy), v4 (copy), Maid (copy), RunService (copy), Workspace (copy)
            if not v1 or p1 == nil then
                return nil
            end

            local function updateSecondsLeftBinding(p3) -- line: 33
                -- upvalues: v4 (copy), Workspace (copy)
                v4({
                    timeNow = Workspace:GetServerTimeNow(),
                    timestamp = p3
                })
            end

            local v8 = Maid.new()

            v4({
                timeNow = Workspace:GetServerTimeNow(),
                timestamp = p1
            })
            v8:GiveTask(RunService.Heartbeat:Connect(function() -- line: 41
                -- upvalues: updateSecondsLeftBinding (copy), p1 (copy)
                return updateSecondsLeftBinding(p1)
            end))

            return function() -- line: 44
                -- upvalues: v8 (copy)
                return v8:Destroy()
            end
        end, { p1, v4, v1 })
        useBindingListener(v3, function(p4) -- line: 48
            -- upvalues: v1 (copy), v2 (copy)
            local v9 = if p4 then p4.timestamp - p4.timeNow else 0

            if v9 <= 0 and v1 then
                v2(false)
            elseif v9 > 0 and not v1 then
                v2(true)
            end
        end)

        return {
            secondsLeft = v5,
            isCountdownOngoing = v1,
            rawSecondsLeftInfo = v3
        }
    end
}

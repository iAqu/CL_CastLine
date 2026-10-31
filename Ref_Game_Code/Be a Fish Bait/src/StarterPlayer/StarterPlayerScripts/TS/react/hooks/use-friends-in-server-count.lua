-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players

return {
    useFriendsInServerCount = function() -- useFriendsInServerCount | line: 14
        -- upvalues: useEffect (copy), useRef (copy), useState (copy), Players (copy)
        local v1, v2 = useState(0)
        local v3 = useRef(nil)

        useEffect(function() -- line: 17
            -- upvalues: v2 (copy), v3 (copy), Players (copy)
            local function v4() -- line: 18
                -- upvalues: v2 (copy), v3 (copy), Players (copy)
                if v3.current ~= nil then
                    task.cancel(v3.current)
                    v3.current = nil
                end

                v3.current = task.spawn(function() -- line: 23
                    -- upvalues: v2 (copy), v3 (copy), Players (copy)
                    local LocalPlayer = Players.LocalPlayer
                    local n1 = 0

                    for _, player in (Players:GetPlayers()) do
                        if player ~= LocalPlayer and LocalPlayer:IsFriendsWithAsync(player.UserId) then
                            n1 += 1
                        end
                    end

                    v2(n1)
                    v3.current = nil
                end)
            end

            if v3.current ~= nil then
                task.cancel(v3.current)
                v3.current = nil
            end

            v3.current = task.spawn(function() -- line: 23
                -- upvalues: v2 (copy), v3 (copy), Players (copy)
                local LocalPlayer = Players.LocalPlayer
                local n2 = 0

                for _, player in (Players:GetPlayers()) do
                    if player ~= LocalPlayer and LocalPlayer:IsFriendsWithAsync(player.UserId) then
                        n2 += 1
                    end
                end

                v2(n2)
                v3.current = nil
            end)

            local connection = Players.PlayerAdded:Connect(v4)
            local connection2 = Players.PlayerRemoving:Connect(v4)

            return function() -- line: 42
                -- upvalues: connection (copy), connection2 (copy), v3 (copy)
                if v3.current ~= nil then
                    task.cancel(v3.current)
                    v3.current = nil
                end

                connection:Disconnect()
                connection2:Disconnect()
            end
        end, {})

        return v1
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect, useState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useState
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players

return {
    usePlayer = function(p1) -- usePlayer | line: 6
        -- upvalues: Players (copy)
        return if p1 ~= nil then Players:GetPlayerByUserId(p1) else nil
    end,
    usePlayers = function() -- usePlayers | line: 9
        -- upvalues: useEffect (copy), useState (copy), Players (copy)
        local v1, v2 = useState(Players:GetPlayers())

        useEffect(function() -- line: 11
            -- upvalues: v2 (copy), Players (copy)
            local connection = Players.PlayerAdded:Connect(function() -- line: 12
                -- upvalues: v2 (copy), Players (copy)
                v2(Players:GetPlayers())
            end)
            local connection2 = Players.PlayerRemoving:Connect(function() -- line: 15
                -- upvalues: v2 (copy), Players (copy)
                v2(Players:GetPlayers())
            end)

            v2(Players:GetPlayers())

            return function() -- line: 19
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, {})

        return v1
    end
}

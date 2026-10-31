-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players

return {
    useFreePurchaseModeEnabled = function() -- useFreePurchaseModeEnabled | line: 16
        -- upvalues: useEffect (copy), useState (copy), Players (copy)
        local v1, v2 = useState(function() -- line: 17
            -- upvalues: Players (copy)
            return Players.LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true
        end)

        useEffect(function() -- line: 20
            -- upvalues: v2 (copy), Players (copy)
            local LocalPlayer = Players.LocalPlayer

            v2(LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true)

            local connection = LocalPlayer:GetAttributeChangedSignal("QaFreePurchaseModeEnabled"):Connect(function() -- line: 23
                -- upvalues: LocalPlayer (copy), v2 (copy)
                v2(LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true)
            end)

            return function() -- line: 26
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        return v1
    end
}

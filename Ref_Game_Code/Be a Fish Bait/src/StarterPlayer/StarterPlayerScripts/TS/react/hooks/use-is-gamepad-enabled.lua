-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")

return {
    useIsGamepadEnabled = function() -- useIsGamepadEnabled | line: 8
        -- upvalues: UserInputService (copy), useEffect (copy), useState (copy), Maid (copy)
        local v1, v2 = useState(function() -- line: 9
            -- upvalues: UserInputService (copy)
            return UserInputService.GamepadEnabled
        end)

        useEffect(function() -- line: 12
            -- upvalues: v2 (copy), UserInputService (copy), Maid (copy)
            local v3 = Maid.new()

            v3:GiveTask(UserInputService.GamepadConnected:Connect(function() -- line: 14
                -- upvalues: v2 (copy)
                return v2(true)
            end))
            v3:GiveTask(UserInputService.GamepadDisconnected:Connect(function() -- line: 17
                -- upvalues: v2 (copy), UserInputService (copy)
                v2(UserInputService.GamepadEnabled)
            end))

            return function() -- line: 20
                -- upvalues: v3 (copy)
                return v3:Destroy()
            end
        end, {})

        return v1
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local t1 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
}

return {
    useIsUsingGamepad = function() -- useIsUsingGamepad | line: 18
        -- upvalues: UserInputService (copy), useEffect (copy), useState (copy), Maid (copy), t1 (copy)
        local v1, v2 = useState(function() -- line: 19
            -- upvalues: UserInputService (copy), t1 (copy)
            return t1[UserInputService:GetLastInputType()] ~= nil
        end)

        useEffect(function() -- line: 23
            -- upvalues: v2 (copy), UserInputService (copy), Maid (copy), t1 (copy)
            local v3 = Maid.new()

            v3:GiveTask(UserInputService.LastInputTypeChanged:Connect(function(p1) -- line: 25
                -- upvalues: v2 (copy), t1 (copy)
                v2(t1[p1] ~= nil)
            end))

            return function() -- line: 29
                -- upvalues: v3 (copy)
                return v3:Destroy()
            end
        end, {})

        return v1
    end
}

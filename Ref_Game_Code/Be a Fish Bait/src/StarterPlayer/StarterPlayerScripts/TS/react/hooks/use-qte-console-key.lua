-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local t1 = {
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY
}

local function pickRandomKeyCode() -- line: 10
    -- upvalues: t1 (copy)
    return t1[math.random(0, #t1 - 1) + 1]
end

return {
    useQteConsoleKey = function(p1) -- useQteConsoleKey | line: 19
        -- upvalues: UserInputService (copy), useEffect (copy), useRef (copy), useState (copy), pickRandomKeyCode (copy)
        local v1 = useState(pickRandomKeyCode)
        local v2 = useRef(p1)

        v2.current = p1
        useEffect(function() -- line: 23
            -- upvalues: v1 (copy), v2 (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p2, p3) -- line: 24
                -- upvalues: v1 (copy), v2 (copy)
                if p3 or p2.KeyCode ~= v1 then
                    return nil
                end

                v2.current()
            end)

            return function() -- line: 33
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v1 })

        return v1
    end
}

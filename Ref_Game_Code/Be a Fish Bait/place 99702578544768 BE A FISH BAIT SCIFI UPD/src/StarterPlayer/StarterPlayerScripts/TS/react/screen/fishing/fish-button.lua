-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-key-image").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(81, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(135, 235, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(57, 180, 0))
})

return {
    default = function(p1) -- FishButton | line: 12
        -- upvalues: react (copy), useEffect (copy), UserInputService (copy), default (copy), default2 (copy), useTheme (copy), useIsUsingGamepad (copy), v1 (copy)
        local onClick = p1.onClick
        local v2 = useTheme()
        local v3 = useIsUsingGamepad()

        useEffect(function() -- line: 16
            -- upvalues: onClick (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p2, p3) -- line: 17
                -- upvalues: onClick (copy)
                if p3 or p2.KeyCode ~= Enum.KeyCode.ButtonB then
                    return nil
                end

                if onClick ~= nil then
                    onClick()
                end
            end)

            return function() -- line: 29
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { onClick })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.75),
            Size = UDim2.fromScale(0.2, 0.1)
        }, react.createElement(default, {
            isShiny = true,
            isStudded = true,
            label = "FISH!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v1,
            font = v2.textFont2,
            frameSize = UDim2.fromScale(1, 1),
            onClick = onClick or function() -- line: 46
            end,
            popoutColor = Color3.fromRGB(46, 140, 0),
            position = UDim2.fromScale(0.5, 0.5)
        }), v3 and react.createElement(default2, {
            size = 48,
            keyCode = Enum.KeyCode.ButtonB,
            position = UDim2.fromScale(0.5, 0.7)
        }))
    end
}

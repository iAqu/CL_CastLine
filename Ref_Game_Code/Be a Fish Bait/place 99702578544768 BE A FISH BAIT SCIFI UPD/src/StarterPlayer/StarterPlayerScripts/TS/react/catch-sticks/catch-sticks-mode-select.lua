-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad

local function ModeButton(p1) -- line: 14
    -- upvalues: react (copy), default3 (copy), default4 (copy), default5 (copy)
    local color, keyCode, popoutColor, strokeColor = p1.color, p1.keyCode, p1.popoutColor, p1.strokeColor
    local label, subtitle, layoutOrder, showConsoleKey = p1.label, p1.subtitle, p1.layoutOrder, p1.showConsoleKey
    local onActivated = p1.onActivated
    local createElement = react.createElement
    local t1 = {
        cornerRadius = 0.25,
        isStudded = true,
        zIndex = 952,
        color = color,
        frameSize = UDim2.fromScale(0.8, 0.26),
        label = label,
        layoutOrder = layoutOrder,
        onClick = onActivated,
        popoutColor = popoutColor,
        strokeColor = strokeColor
    }
    local createElement2 = react.createElement
    local t2 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v1 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.02, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v2 = react.createElement(default3, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 957,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.9, 0.45)
        },
        strokeProps = {
            Thickness = 0.12,
            Color = strokeColor
        },
        text = label
    })
    local v3 = subtitle ~= nil and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        TextScaled = true,
        ZIndex = 957,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromScale(0.9, 0.28),
        Text = subtitle,
        TextColor3 = Color3.fromRGB(240, 240, 240)
    }, react.createElement("uistroke", {
        Thickness = 1.5,
        Color = strokeColor
    }))

    if showConsoleKey then
        showConsoleKey = keyCode ~= nil and react.createElement(default5, {
            size = 36,
            keyCode = keyCode,
            position = UDim2.fromScale(0.12, 0.3)
        })
    end

    return createElement(default4, t1, createElement2("frame", t2, v1, v2, v3, showConsoleKey))
end

return {
    default = function(p2) -- CatchSticksModeSelect | line: 75
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), UserInputService (copy), default (copy), default2 (copy), default3 (copy), useIsUsingGamepad (copy), ModeButton (copy)
        local onClose, onSelect, uiScale = p2.onClose, p2.onSelect, p2.uiScale
        local v4, v5 = useMotion(0)
        local v6 = useIsUsingGamepad()

        useEffect(function() -- line: 81
            -- upvalues: v5 (copy)
            v5:spring(1, {
                frequency = 1,
                damping = 0.85
            })
        end, { v5 })
        useEffect(function() -- line: 87
            -- upvalues: onSelect (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p3, p4) -- line: 88
                -- upvalues: onSelect (copy)
                if p4 then
                    return nil
                end

                if p3.KeyCode == Enum.KeyCode.ButtonX then
                    onSelect("normal")
                elseif p3.KeyCode == Enum.KeyCode.ButtonB then
                    onSelect("insane")
                end
            end)

            return function() -- line: 98
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { onSelect })

        return react.createElement("frame", {
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 950,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            cornerRadius = 0.06,
            isStudded = true,
            zIndex = 951,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 132, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 74, 180))
            }),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromOffset(500 * uiScale, 420 * uiScale)
        }, react.createElement("uiscale", {
            Scale = v4
        }), react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.035, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default3, {
            text = "CATCH STICKS",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 226, 120),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 952,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.9, 0.16)
            },
            strokeProps = {
                Thickness = 0.1,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }), react.createElement(ModeButton, {
            label = "NORMAL MODE",
            layoutOrder = 2,
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 240, 140)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 190, 84))
            }),
            keyCode = Enum.KeyCode.ButtonX,
            onActivated = function() -- onActivated | line: 143
                -- upvalues: onSelect (copy)
                return onSelect("normal")
            end,
            popoutColor = Color3.fromRGB(24, 92, 32),
            showConsoleKey = v6,
            strokeColor = Color3.fromRGB(24, 92, 32)
        }), react.createElement(ModeButton, {
            label = "INSANE MODE",
            layoutOrder = 3,
            subtitle = "x2 Reward",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 40, 40))
            }),
            keyCode = Enum.KeyCode.ButtonB,
            onActivated = function() -- onActivated | line: 154
                -- upvalues: onSelect (copy)
                return onSelect("insane")
            end,
            popoutColor = Color3.fromRGB(110, 12, 12),
            showConsoleKey = v6,
            strokeColor = Color3.fromRGB(110, 12, 12)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 953,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(500 * uiScale, 420 * uiScale)
        }, react.createElement("uiscale", {
            Scale = v4
        }), react.createElement(default2, {
            aspectRatio = 1,
            cornerRadius = 0.2,
            zIndex = 953,
            anchorPoint = Vector2.new(1, 0),
            color = Color3.fromRGB(255, 43, 43),
            onClick = onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(1, 0),
            size = UDim2.fromScale(0.11, 0.11),
            strokeColor = Color3.fromRGB(255, 179, 179)
        }, react.createElement(default3, {
            text = "X",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 956,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.8, 0.8)
            },
            position = UDim2.fromScale(0.5, 0.5)
        }))))
    end
}

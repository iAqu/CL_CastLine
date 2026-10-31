-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad

return {
    default = function(p1) -- CatchSticksResults | line: 13
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), UserInputService (copy), default (copy), default2 (copy), default3 (copy), useIsUsingGamepad (copy)
        local score, total, ticketsAwarded, onClose = p1.score, p1.total, p1.ticketsAwarded, p1.onClose
        local uiScale = p1.uiScale
        local v1, v2 = useMotion(0)
        local v3 = useIsUsingGamepad()

        useEffect(function() -- line: 21
            -- upvalues: v2 (copy)
            v2:spring(1, {
                frequency = 1,
                damping = 0.7
            })
        end, { v2 })
        useEffect(function() -- line: 27
            -- upvalues: onClose (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p2, p3) -- line: 28
                -- upvalues: onClose (copy)
                if p3 or p2.KeyCode ~= Enum.KeyCode.ButtonY then
                    return nil
                end

                onClose()
            end)

            return function() -- line: 37
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { onClose })

        return react.createElement("frame", {
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 950,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            cornerRadius = 0.08,
            isStudded = true,
            strokeThickness = 0.045,
            zIndex = 951,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 132, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 74, 180))
            }),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromOffset(460 * uiScale, 320 * uiScale),
            strokeColor = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uiscale", {
            Scale = v1
        }), react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            text = "RESULTS",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 226, 120),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 952,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.85, 0.2)
            },
            strokeProps = {
                Thickness = 0.1,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                ZIndex = 952,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.85, 0.28)
            },
            strokeProps = {
                Thickness = 0.08,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = ("Caught %* / %*"):format(score, total)
        }), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 226, 120),
            overrideProps = {
                LayoutOrder = 3,
                TextScaled = true,
                ZIndex = 952,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.85, 0.16)
            },
            strokeProps = {
                Thickness = 0.08,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = if ticketsAwarded > 0 then ("+%* Ticket%*!"):format(ticketsAwarded, ticketsAwarded == 1 and "" or "s") else "No Tickets Earned"
        }), react.createElement("textbutton", {
            AutoButtonColor = true,
            BorderSizePixel = 0,
            LayoutOrder = 4,
            Text = "",
            ZIndex = 952,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(96, 214, 108),
            Event = {
                Activated = onClose
            },
            Size = UDim2.fromScale(0.5, 0.18)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.3, 0)
        }), react.createElement("uistroke", {
            Thickness = 2,
            Color = Color3.fromRGB(24, 92, 32)
        }), react.createElement(default2, {
            text = "DONE",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 953,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.9, 0.6)
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.12,
                Color = Color3.fromRGB(24, 92, 32)
            }
        }), v3 and react.createElement(default3, {
            size = 36,
            keyCode = Enum.KeyCode.ButtonY,
            position = UDim2.fromScale(0.14, 0.2)
        }))))
    end
}

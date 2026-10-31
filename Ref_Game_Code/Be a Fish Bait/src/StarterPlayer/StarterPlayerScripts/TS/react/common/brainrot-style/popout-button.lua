-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding = react.useBinding
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound

local function darkenColor(p1, p2) -- line: 10
    return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2)
end

return {
    default = function(p3) -- PopoutButton | line: 13
        -- upvalues: react (copy), useBinding (copy), useBindingListener (copy), useMotion (copy), useSound (copy)
        local playSound = useSound("ButtonClick").playSound
        local playSound2 = useSound("ButtonHover").playSound
        local v1, v2 = useBinding(false)
        local v3, v4 = useBinding(false)
        local v5, v6 = useMotion(1)
        local v7, v8 = useMotion(1)

        useBindingListener(v1, function(p4) -- line: 22
            -- upvalues: v6 (copy), v8 (copy)
            if p4 then
                v6:spring(1.08, {
                    frequency = 0.1
                })
                v8:spring(0.82, {
                    frequency = 0.1
                })
            else
                v6:spring(1, {
                    frequency = 0.1
                })
                v8:spring(1, {
                    frequency = 0.1
                })
            end
        end)
        useBindingListener(v3, function(p5) -- line: 39
            -- upvalues: v1 (copy), v6 (copy)
            if p5 then
                v6:spring(0.92, {
                    frequency = 0.1
                })
            else
                v6:spring(v1:getValue() and 1.08 or 1, {
                    frequency = 0.1
                })
            end
        end)

        local cornerRadius = p3.cornerRadius

        if cornerRadius == nil then
            cornerRadius = 0.1
        end

        local popoutColor = p3.popoutColor

        if not popoutColor then
            local color = p3.color

            popoutColor = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
        end

        local zIndex = p3.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v10 = p3.size or UDim2.fromOffset(44, 44)
        local v11 = v5:map(function(p6) -- line: 62
            -- upvalues: v10 (copy)
            return UDim2.new(v10.X.Scale * p6, v10.X.Offset * p6, v10.Y.Scale * p6, v10.Y.Offset * p6)
        end)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p3.anchorPoint or Vector2.new(0.5, 0.5),
            Position = p3.position,
            Size = v11,
            ZIndex = zIndex
        }, p3.aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
            AspectRatio = p3.aspectRatio
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = popoutColor,
            Position = UDim2.fromScale(0.5, 0.51),
            Size = UDim2.fromScale(1.15, 1.2),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        })), react.createElement("imagebutton", {
            AutoButtonColor = false,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p3.color,
            Event = {
                Activated = function() -- Activated | line: 89
                    -- upvalues: p3 (copy), playSound (copy)
                    playSound()
                    p3.onClick()
                end,
                MouseEnter = function() -- MouseEnter | line: 93
                    -- upvalues: playSound2 (copy), v2 (copy)
                    playSound2()
                    v2(true)
                end,
                MouseLeave = function() -- MouseLeave | line: 97
                    -- upvalues: v2 (copy)
                    return v2(false)
                end,
                MouseButton1Down = function() -- MouseButton1Down | line: 100
                    -- upvalues: v4 (copy)
                    return v4(true)
                end,
                MouseButton1Up = function() -- MouseButton1Up | line: 103
                    -- upvalues: v4 (copy)
                    return v4(false)
                end,
                MouseButton2Down = function() -- MouseButton2Down | line: 106
                    -- upvalues: v4 (copy)
                    return v4(true)
                end,
                MouseButton2Up = function() -- MouseButton2Up | line: 109
                    -- upvalues: v4 (copy)
                    return v4(false)
                end
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 1
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.03,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = p3.strokeColor or Color3.new(1, 1, 1),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = v7,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 2
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        })), p3.children))
    end
}

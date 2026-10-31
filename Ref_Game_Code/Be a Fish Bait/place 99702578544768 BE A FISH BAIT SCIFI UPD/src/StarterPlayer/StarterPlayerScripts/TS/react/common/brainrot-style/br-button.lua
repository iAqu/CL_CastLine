-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding = react.useBinding
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local default = RuntimeLib.import(script, script.Parent, "br-frame").default

return {
    default = function(p1) -- BRButton | line: 11
        -- upvalues: react (copy), useBinding (copy), useBindingListener (copy), useMotion (copy), useSound (copy), default (copy)
        local anchorPoint, backgroundColor, children, cornerRadius = p1.anchorPoint, p1.backgroundColor, p1.children, p1.cornerRadius
        local isStudded, isStuddedTransparency, layoutOrder, minimumSize = p1.isStudded, p1.isStuddedTransparency, p1.layoutOrder, p1.minimumSize
        local onClick, position, size, strokeColor = p1.onClick, p1.position, p1.size, p1.strokeColor
        local strokeThickness, textureTransparency, transparency, zIndex = p1.strokeThickness, p1.textureTransparency, p1.transparency, p1.zIndex
        local playSound = useSound("ButtonClick").playSound
        local playSound2 = useSound("ButtonHover").playSound
        local v1, v2 = useBinding(false)
        local v3, v4 = useBinding(false)
        local v5, v6 = useMotion(1)
        local v7, v8 = useMotion(1)

        useBindingListener(v1, function(p2) -- line: 36
            -- upvalues: v6 (copy), v8 (copy)
            if p2 then
                v6:spring(1.04, {
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
        useBindingListener(v3, function(p3) -- line: 53
            -- upvalues: v1 (copy), v6 (copy)
            if p3 then
                v6:spring(0.96, {
                    frequency = 0.1
                })
            else
                v6:spring(v1:getValue() and 1.04 or 1, {
                    frequency = 0.1
                })
            end
        end)

        if zIndex == nil then
            zIndex = 1
        end

        if cornerRadius == nil then
            cornerRadius = 0.15
        end

        local v10 = size or UDim2.fromScale(1, 1)
        local v11 = v5:map(function(p4) -- line: 75
            -- upvalues: v10 (copy)
            return UDim2.new(v10.X.Scale * p4, v10.X.Offset * p4, v10.Y.Scale * p4, v10.Y.Offset * p4)
        end)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = anchorPoint or Vector2.new(0.5, 0.5),
            LayoutOrder = layoutOrder,
            Position = position,
            Size = v11,
            ZIndex = zIndex
        }, minimumSize ~= nil and react.createElement("uisizeconstraint", {
            MinSize = minimumSize
        }), react.createElement(default, {
            backgroundColor = backgroundColor,
            cornerRadius = cornerRadius,
            isStudded = isStudded,
            isStuddedTransparency = isStuddedTransparency,
            size = UDim2.fromScale(1, 1),
            strokeColor = strokeColor,
            strokeThickness = strokeThickness,
            textureTransparency = textureTransparency,
            transparency = transparency,
            zIndex = zIndex + 1
        }, react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Event = {
                Activated = function() -- Activated | line: 104
                    -- upvalues: onClick (copy), playSound (copy)
                    playSound()
                    onClick()
                end,
                MouseEnter = function() -- MouseEnter | line: 108
                    -- upvalues: playSound2 (copy), v2 (copy)
                    playSound2()
                    v2(true)
                end,
                MouseLeave = function() -- MouseLeave | line: 112
                    -- upvalues: v2 (copy)
                    return v2(false)
                end,
                MouseButton1Down = function() -- MouseButton1Down | line: 115
                    -- upvalues: v4 (copy)
                    return v4(true)
                end,
                MouseButton1Up = function() -- MouseButton1Up | line: 118
                    -- upvalues: v4 (copy)
                    return v4(false)
                end,
                MouseButton2Down = function() -- MouseButton2Down | line: 121
                    -- upvalues: v4 (copy)
                    return v4(true)
                end,
                MouseButton2Up = function() -- MouseButton2Up | line: 124
                    -- upvalues: v4 (copy)
                    return v4(false)
                end
            },
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 2
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = v7,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 3
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(cornerRadius, 0)
        })), children))
    end
}

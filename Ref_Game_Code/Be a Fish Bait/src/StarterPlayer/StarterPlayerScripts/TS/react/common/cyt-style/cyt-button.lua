-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding = react.useBinding
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState

return {
    default = function(p1) -- CYTButton | line: 11
        -- upvalues: react (copy), useBinding (copy), useBindingListener (copy), useMotion (copy), useSound (copy), useScreenSizeState (copy)
        local bounceOnClick = p1.bounceOnClick

        if bounceOnClick == nil then
            bounceOnClick = true
        end

        local darkenOnHover = p1.darkenOnHover

        if darkenOnHover == nil then
            darkenOnHover = true
        end

        local growOnHover = p1.growOnHover

        if growOnHover == nil then
            growOnHover = true
        end

        local playSound = useSound("ButtonClick").playSound
        local playSound2 = useSound("ButtonHover").playSound
        local v1 = useScreenSizeState()
        local v2, v3 = useBinding(false)
        local v4, v5 = useBinding(false)
        local v6, v7 = useMotion(1)
        local v8, v9 = useMotion(1)

        useBindingListener(v2, function(p2) -- line: 36
            -- upvalues: growOnHover (ref), v7 (copy), v9 (copy)
            if not (p2 and growOnHover) then
                v7:spring(1, {
                    frequency = 0.1
                })
                v9:spring(1, {
                    frequency = 0.1
                })
            else
                v7:spring(1.1, {
                    frequency = 0.1
                })
                v9:spring(0.85, {
                    frequency = 0.1
                })
            end
        end)
        useBindingListener(v4, function(p3) -- line: 53
            -- upvalues: bounceOnClick (ref), v2 (copy), v7 (copy)
            if not (p3 and bounceOnClick) then
                v7:spring(v2:getValue() and 1.1 or 1, {
                    frequency = 0.1
                })
            else
                v7:spring(0.9, {
                    frequency = 0.1
                })
            end
        end)

        local Scale = p1.size.X.Scale
        local Scale2 = p1.size.Y.Scale
        local v11 = v6:map(function(p4) -- line: 67
            -- upvalues: Scale (copy), Scale2 (copy)
            local v12 = Scale * p4
            local v13 = Scale2 * p4

            return UDim2.new(v12, 0, v13, 0)
        end)
        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            Text = "",
            AnchorPoint = p1.anchorPoint
        }
        local t2

        if not p1.disabled then
            t2 = {}

            function t2.Activated() -- line: 76
                -- upvalues: p1 (copy), playSound (copy)
                playSound()

                local onClick = p1.onClick

                if onClick ~= nil then
                    onClick()
                end
            end

            function t2.MouseEnter() -- line: 83
                -- upvalues: p1 (copy), playSound2 (copy), v1 (copy), v3 (copy)
                if v1 ~= "sm" then
                    playSound2()
                end

                v3(true)

                local onMouseEnter = p1.onMouseEnter

                if onMouseEnter ~= nil then
                    onMouseEnter()
                end
            end

            function t2.MouseLeave() -- line: 93
                -- upvalues: p1 (copy), v3 (copy)
                v3(false)

                local onMouseLeave = p1.onMouseLeave

                if onMouseLeave ~= nil then
                    onMouseLeave()
                end
            end

            function t2.TouchLongPress() -- line: 100
                -- upvalues: playSound (copy)
                playSound()
            end

            function t2.MouseButton2Click() -- line: 103
                -- upvalues: playSound (copy)
                playSound()
            end

            function t2.MouseButton1Down() -- line: 106
                -- upvalues: p1 (copy), v5 (copy)
                v5(true)

                local onMouseButton1Down = p1.onMouseButton1Down

                if onMouseButton1Down ~= nil then
                    onMouseButton1Down()
                end
            end

            function t2.MouseButton1Up() -- line: 113
                -- upvalues: p1 (copy), v5 (copy)
                v5(false)

                local onMouseButton1Up = p1.onMouseButton1Up

                if onMouseButton1Up ~= nil then
                    onMouseButton1Up()
                end
            end

            function t2.MouseButton2Down() -- line: 120
                -- upvalues: v5 (copy)
                v5(true)
            end

            function t2.MouseButton2Up() -- line: 123
                -- upvalues: v5 (copy)
                v5(false)
            end
        end

        t1.Event = t2
        t1.LayoutOrder = p1.layoutOrder
        t1.Position = p1.position
        t1.Size = v11
        t1.ZIndex = p1.zIndex

        return createElement("textbutton", t1, if p1.uiAspectRatio == nil then nil else react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.uiAspectRatio
        }), if p1.cornerRadius == nil then nil else react.createElement("uicorner", {
            CornerRadius = UDim.new(0, p1.cornerRadius)
        }), if p1.borderThickness ~= nil then react.createElement("uistroke", {
            Color = p1.borderColor or Color3.fromRGB(0, 0, 0),
            Thickness = p1.borderThickness
        }) else nil, p1.children, if darkenOnHover then react.createElement("frame", {
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v8,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, if p1.cornerRadius == nil then nil else react.createElement("uicorner", {
            CornerRadius = UDim.new(0, p1.cornerRadius)
        })) else nil, if p1.disabled then react.createElement("frame", {
            BackgroundTransparency = 0.65,
            ZIndex = 1,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.fromScale(1, 1)
        }, if p1.cornerRadius == nil then nil else react.createElement("uicorner", {
            CornerRadius = UDim.new(0, p1.cornerRadius)
        })) else nil)
    end
}

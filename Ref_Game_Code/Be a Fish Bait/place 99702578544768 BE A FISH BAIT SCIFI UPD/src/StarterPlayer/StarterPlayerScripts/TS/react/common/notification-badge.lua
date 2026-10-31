-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local default = RuntimeLib.import(script, script.Parent, "styled-text-label").default

return {
    default = function(p1) -- NotificationBadge | line: 11
        -- upvalues: useMotion (copy), react (copy), useEffect (copy), default (copy)
        local anchorPoint = p1.anchorPoint

        if anchorPoint == nil then
            anchorPoint = Vector2.new(1, 0)
        end

        local aspectRatio, position = p1.aspectRatio, p1.position

        if position == nil then
            position = UDim2.fromScale(0.3, -0.05)
        end

        local size = p1.size
        local v1 = size

        if size == nil then
            v1 = UDim2.fromScale(0.4, 0.4)
        end

        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 12
        end

        local text = p1.text

        if text == nil then
            text = "!"
        end

        local v2, v3 = useMotion(1)
        local v4, v5 = useMotion(0)
        local v6, v7 = useMotion(1)
        local v8, v9 = useMotion(0)
        local v10, v11 = useMotion(1)

        useEffect(function() -- line: 38
            -- upvalues: v3 (copy), v5 (copy), v7 (copy), v9 (copy), v11 (copy)
            local function v12(p2, p3) -- line: 39
                -- upvalues: v3 (copy)
                v3:tween(1.15, {
                    time = 0.15
                })
                task.delay(0.15, function() -- line: 43
                    -- upvalues: v3 (copy)
                    v3:tween(1, {
                        time = 0.35
                    })
                end)
                p2:immediate(0)
                p3:immediate(0)
                p2:tween(1, {
                    time = 0.5
                })
                p3:tween(1, {
                    time = 0.5
                })
            end

            local t1 = {}
            local v13

            v13 = function() -- line: 59
                -- upvalues: v13 (ref), v12 (copy), t1 (copy), v5 (copy), v7 (copy), v9 (copy), v11 (copy)
                v12(v5, v7)
                table.insert(t1, (task.delay(0.3, function() -- line: 61
                    -- upvalues: v12 (copy), v9 (copy), v11 (copy)
                    v12(v9, v11)
                end)))
                table.insert(t1, (task.delay(2.8, v13)))
            end

            table.insert(t1, (task.delay(2, v13)))

            return function() -- line: 70
                -- upvalues: t1 (copy)
                local function v17(p4) -- line: 72
                    return task.cancel(p4)
                end

                for v18, v19 in t1 do
                    local _ = v18 - 1

                    task.cancel(v19)
                end
            end
        end, { v3, v5, v7, v9, v11 })

        local v20 = v2:map(function(p5) -- line: 81
            -- upvalues: v1 (ref)
            local v21 = v1

            return UDim2.new(v21.X.Scale * p5, v21.X.Offset, v21.Y.Scale * p5, v21.Y.Offset)
        end)

        local function v22(p6) -- line: 85
            return p6:map(function(p7) -- line: 86
                return UDim2.fromScale(1 + p7 * 2, 1 + p7 * 2)
            end)
        end

        local function v23(p8) -- line: 91
            return p8:map(function(p9) -- line: 92
                return 0.4 + p9 * 0.6
            end)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = anchorPoint,
            BackgroundColor3 = Color3.fromRGB(180, 20, 20),
            Position = position,
            Size = v20,
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }), aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
            AspectRatio = aspectRatio
        }), react.createElement("uistroke", {
            Thickness = 0.1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(100, 10, 10),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(200, 30, 30),
            BackgroundTransparency = v6:map(function(p10) -- line: 92
                return 0.4 + p10 * 0.6
            end),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v4:map(function(p11) -- line: 86
                return UDim2.fromScale(1 + p11 * 2, 1 + p11 * 2)
            end),
            ZIndex = zIndex - 1
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        })), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(200, 30, 30),
            BackgroundTransparency = v10:map(function(p12) -- line: 92
                return 0.4 + p12 * 0.6
            end),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v8:map(function(p13) -- line: 86
                return UDim2.fromScale(1 + p13 * 2, 1 + p13 * 2)
            end),
            ZIndex = zIndex - 1
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        })), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(240, 60, 60),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.75, 0.75),
            ZIndex = zIndex + 1
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        })), react.createElement(default, {
            hasStroke = true,
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 2
            },
            strokeProps = {
                Thickness = 0.08,
                Color = Color3.fromRGB(120, 10, 10)
            },
            text = text,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }))
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = Color3.fromRGB(30, 35, 55)
local v2 = Color3.fromRGB(70, 80, 110)

local function formatPercent(p1) -- line: 13
    return (("+%*%%"):format((math.round(p1 * 100))))
end

local function StatRow(p2) -- line: 16
    -- upvalues: react (copy), default (copy), v1 (copy), v2 (copy)
    local layoutOrder, title, value, valueColor = p2.layoutOrder, p2.title, p2.value, p2.valueColor

    return react.createElement(default, {
        cornerRadius = 0.2,
        strokeThickness = 0.008,
        transparency = 0.5,
        zIndex = 5,
        backgroundColor = v1,
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(1, 0.075),
        strokeColor = v2
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 0.5),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.06, 0.5),
        Size = UDim2.fromScale(0.64, 0.6),
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 6,
        AnchorPoint = Vector2.new(1, 0.5),
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.94, 0.5),
        Size = UDim2.fromScale(0.3, 0.6),
        Text = value,
        TextColor3 = valueColor,
        TextXAlignment = Enum.TextXAlignment.Right
    }))
end

return {
    default = function(p3) -- AquariumStatsPanel | line: 54
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), abbreviate (copy), StatRow (copy)
        local boosts, isClosing, moneyPerSecond, onClose = p3.boosts, p3.isClosing, p3.moneyPerSecond, p3.onClose
        local onCloseComplete = p3.onCloseComplete
        local v4, v5 = useMotion(0)
        local v6, v7 = useMotion(0)

        useEffect(function() -- line: 63
            -- upvalues: isClosing (copy), onCloseComplete (copy), v5 (copy), v7 (copy)
            if isClosing then
                v5:tween(0, {
                    time = 0.35,
                    style = Enum.EasingStyle.Exponential,
                    direction = Enum.EasingDirection.In
                })

                local v8 = task.delay(0.105, function() -- line: 70
                    -- upvalues: v7 (copy)
                    v7:tween(0, {
                        time = 0.24499999999999997,
                        style = Enum.EasingStyle.Linear
                    })
                end)
                local v9 = task.delay(0.35, function() -- line: 76
                    -- upvalues: onCloseComplete (copy)
                    return onCloseComplete()
                end)

                return function() -- line: 79
                    -- upvalues: v8 (copy), v9 (copy)
                    task.cancel(v8)
                    task.cancel(v9)
                end
            end

            v5:tween(1, {
                time = 0.35,
                style = Enum.EasingStyle.Exponential,
                direction = Enum.EasingDirection.Out
            })
            v7:tween(1, {
                time = 0.24499999999999997,
                style = Enum.EasingStyle.Linear
            })
        end, { isClosing, v5, v7, onCloseComplete })

        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            AnchorPoint = Vector2.new(1, 0.5),
            GroupTransparency = v6:map(function(p4) -- line: 99
                return 1 - p4
            end),
            Position = v4:map(function(p5) -- line: 102
                return UDim2.fromScale(0.9785 - 0.29 * p5, 0.55)
            end),
            Size = UDim2.fromScale(0.238, 0.65)
        }
        local v10 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.65,
            DominantAxis = Enum.DominantAxis.Width
        })
        local createElement2 = react.createElement
        local t2 = {
            clipsDescendants = true,
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.005,
            textureTransparency = 0.9,
            transparency = 0.5,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(55, 65, 90),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.99, 0.99),
            strokeColor = Color3.fromRGB(80, 95, 130)
        }
        local v11 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.015),
            Size = UDim2.fromScale(0.94, 0.13)
        }, react.createElement(default3, {
            text = "AQUARIUM STATS",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.82, 0.5),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.12, 0.85)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default2, {
            cornerRadius = 0.15,
            zIndex = 7,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 43, 43),
            onClick = onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 179, 179)
        }, react.createElement(default3, {
            shadowYScale = 0.08,
            text = "X",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7)
            }
        }))))
        local createElement3 = react.createElement
        local t3 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.16),
            Size = UDim2.fromScale(0.94, 0.81)
        }
        local v12 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0.015, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v13 = react.createElement(StatRow, {
            layoutOrder = 0,
            title = "Total MPS",
            value = ("$%*/s"):format((abbreviate(moneyPerSecond))),
            valueColor = Color3.fromRGB(80, 255, 80)
        })
        local v14 = boosts.trainingPower.total > 0 and react.createElement(StatRow, {
            layoutOrder = 1,
            title = "Training Power",
            value = ("+%*%%"):format((math.round(boosts.trainingPower.total * 100))),
            valueColor = Color3.fromRGB(255, 220, 60)
        })

        if not (boosts.mutationLuck.total > 0) then
            local v16 = false

            return createElement("canvasgroup", t1, v10, createElement2(default, t2, v11, createElement3("frame", t3, v12, v13, v14, v16)), react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 15,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.99, 0.99)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.025, 0)
            }), react.createElement("uistroke", {
                Thickness = 0.005,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(59, 59, 59),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            })))
        end

        return createElement("canvasgroup", t1, v10, createElement2(default, t2, v11, createElement3("frame", t3, v12, v13, v14, (react.createElement(StatRow, {
            layoutOrder = 2,
            title = "Mutation Luck",
            value = ("+%*%%"):format((math.round(boosts.mutationLuck.total * 100))),
            valueColor = Color3.fromRGB(255, 220, 60)
        })))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.99, 0.99)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(59, 59, 59),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })))
    end
}

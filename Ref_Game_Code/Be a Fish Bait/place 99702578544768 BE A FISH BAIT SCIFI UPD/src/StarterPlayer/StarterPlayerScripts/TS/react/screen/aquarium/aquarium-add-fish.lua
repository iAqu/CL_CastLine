-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default5 = RuntimeLib.import(script, script.Parent, "aquarium-fish-item").default

local function AddFishChoosePanel(p1) -- line: 14
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), default2 (copy), default3 (copy)
    local isClosing, layoutOrder, onChoose, onCloseComplete = p1.isClosing, p1.layoutOrder, p1.onChoose, p1.onCloseComplete
    local v1, v2 = useMotion(0)
    local v3 = useRef(onCloseComplete)

    v3.current = onCloseComplete
    useEffect(function() -- line: 22
        -- upvalues: isClosing (copy), v2 (copy), v3 (copy)
        if isClosing then
            v2:tween(0, {
                time = 0.25,
                style = Enum.EasingStyle.Linear
            })

            local v4 = task.delay(0.25, function() -- line: 28
                -- upvalues: v3 (copy)
                return v3.current()
            end)

            return function() -- line: 31
                -- upvalues: v4 (copy)
                return task.cancel(v4)
            end
        end

        v2:tween(1, {
            time = 0.25,
            style = Enum.EasingStyle.Linear
        })
    end, { isClosing, v2 })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uipadding", {
        PaddingBottom = UDim.new(0.05, 0),
        PaddingLeft = UDim.new(0.04, 0),
        PaddingRight = UDim.new(0.04, 0),
        PaddingTop = UDim.new(0.05, 0)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        LayoutOrder = 0,
        Size = v1:map(function(p2) -- line: 60
            return UDim2.fromScale(1, 0.8 * p2)
        end)
    }, react.createElement(default2, {
        cornerRadius = 0.08,
        isStudded = true,
        isStuddedTransparency = 0.2,
        strokeThickness = 0.04,
        textureTransparency = 0.75,
        zIndex = 3,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(41, 240, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
        }),
        onClick = onChoose,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(180, 255, 120)
    }, react.createElement(default3, {
        text = "CHOOSE",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.8, 0.4)
        }
    }))))
end

return {
    default = function(p3) -- AquariumAddFish | line: 89
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), AddFishChoosePanel (copy)
        local fish, isClosing, onClose, onCloseComplete = p3.fish, p3.isClosing, p3.onClose, p3.onCloseComplete
        local onSelectFish = p3.onSelectFish
        local v7, v8 = useState(nil)
        local v9, v10 = useState(nil)
        local v11 = useRef(v7)

        v11.current = v7

        local v12 = useRef(onCloseComplete)

        v12.current = onCloseComplete

        local v13, v14 = useMotion(0)
        local v15, v16 = useMotion(0)

        useEffect(function() -- line: 104
            -- upvalues: isClosing (copy), v12 (copy), v14 (copy), v16 (copy)
            if isClosing then
                v14:tween(0, {
                    time = 0.35,
                    style = Enum.EasingStyle.Exponential,
                    direction = Enum.EasingDirection.In
                })

                local v17 = task.delay(0.105, function() -- line: 113
                    -- upvalues: v16 (copy)
                    v16:tween(0, {
                        time = 0.24499999999999997,
                        style = Enum.EasingStyle.Linear
                    })
                end)
                local v18 = task.delay(0.35, function() -- line: 119
                    -- upvalues: v12 (copy)
                    return v12.current()
                end)

                return function() -- line: 122
                    -- upvalues: v17 (copy), v18 (copy)
                    task.cancel(v17)
                    task.cancel(v18)
                end
            end

            v14:tween(1, {
                time = 0.35,
                style = Enum.EasingStyle.Exponential,
                direction = Enum.EasingDirection.Out
            })
            v16:tween(1, {
                time = 0.24499999999999997,
                style = Enum.EasingStyle.Linear
            })
        end, { isClosing, v14, v16 })

        local function v19(p4) -- line: 140
            -- upvalues: v7 (copy), v8 (copy), v9 (copy), v10 (copy)
            local v20 = if v7 == p4 then nil else p4

            v8(v20)

            if v9 == nil and v20 ~= nil then
                v10(v20)
            end
        end

        local function v21() -- line: 147
            -- upvalues: v10 (copy), v11 (copy)
            v10(v11.current)
        end

        local t3 = {}

        local function v22(p5, p6) -- line: 152
            -- upvalues: onSelectFish (copy), v7 (copy), v8 (copy), v9 (copy), v19 (copy), v21 (copy), t3 (copy), react (copy), default5 (copy), AddFishChoosePanel (copy)
            table.insert(t3, (react.createElement(default5, {
                detailsPosition = UDim2.fromScale(0.32, 0.5),
                detailsSize = UDim2.fromScale(0.65, 0.9),
                fishId = p5.fishId,
                fishName = p5.fishName,
                imageId = p5.imageId,
                key = p5.fishId,
                layoutOrder = p6 * 2,
                level = p5.level,
                levelUpCost = p5.levelUpCost,
                moneyPerSecond = p5.moneyPerSecond,
                mutation = p5.mutation,
                offlineEarningPerSec = p5.offlineEarningPerSec,
                onClick = function() -- onClick | line: 166
                    -- upvalues: p6 (copy), v19 (copy)
                    return v19(p6)
                end,
                rarity = p5.rarity
            })))

            if v9 ~= p6 then
                return
            end

            table.insert(t3, (react.createElement(AddFishChoosePanel, {
                isClosing = v7 ~= p6,
                key = ("choose-%*"):format(p5.fishId),
                layoutOrder = p6 * 2 + 1,
                onChoose = function() -- onChoose | line: 177
                    -- upvalues: p5 (copy), onSelectFish (copy), v8 (copy)
                    onSelectFish(p5.fishId)
                    v8(nil)
                end,
                onCloseComplete = v21
            })))
        end

        for v25, v26 in fish do
            v22(v26, v25 - 1, fish)
        end

        return react.createElement("canvasgroup", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            AnchorPoint = Vector2.new(1, 0.5),
            GroupTransparency = v15:map(function(p7) -- line: 194
                return 1 - p7
            end),
            Position = v13:map(function(p8) -- line: 197
                return UDim2.fromScale(0.9785 - 0.29 * p8, 0.55)
            end),
            Size = UDim2.fromScale(0.238, 0.65)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.65,
            DominantAxis = Enum.DominantAxis.Width
        }), react.createElement(default, {
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
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.015),
            Size = UDim2.fromScale(0.94, 0.13)
        }, react.createElement(default3, {
            text = "CHOOSE FISH",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                AnchorPoint = Vector2.new(0, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(1, 0.5),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        })), react.createElement(default4, {
            cellsPerRow = 1,
            listPaddingOffset = 6,
            rowsToBeVisible = 3.5,
            scrollBarThickness = 4,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0),
            fillDirection = Enum.FillDirection.Horizontal,
            position = UDim2.fromScale(0.5, 0.16),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            size = UDim2.fromScale(0.94, 0.73),
            verticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        }, t3), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.985),
            Size = UDim2.fromScale(0.94, 0.08)
        }, react.createElement(default2, {
            cornerRadius = 0.08,
            isStudded = true,
            isStuddedTransparency = 0.2,
            strokeThickness = 0.04,
            textureTransparency = 0.75,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(200, 40, 40),
            onClick = onClose,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 160, 160)
        }, react.createElement(default3, {
            text = "CLOSE",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.6)
            }
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

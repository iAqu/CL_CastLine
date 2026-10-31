-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local useLoopMotion = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-loop-motion").useLoopMotion
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 255, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 220, 10))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 254, 86)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 186, 13))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 200, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 160, 10))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 140, 10))
})
local v6 = Color3.fromRGB(40, 40, 40)
local v7 = Color3.fromRGB(100, 210, 40)
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 110, 10))
})

local function formatTimeRemaining(p1) -- line: 23
    local v10 = math.max(0, (math.ceil(p1)))

    if v10 >= 3600 then
        return (("%*h %*m"):format(math.floor(v10 / 3600), (math.floor(v10 % 3600 / 60))))
    end

    if not (v10 >= 60) then
        return (("%*s"):format(v10))
    end

    return (("%*m %*s"):format(math.floor(v10 / 60), v10 % 60))
end

return {
    default = function(p2) -- UpgradeSignSurfaceGui | line: 36
        -- upvalues: react (copy), useEffect (copy), useState (copy), RunService (copy), Workspace (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), useLoopMotion (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), formatTimeRemaining (copy)
        local adornPart, title, currentValue, newValue = p2.adornPart, p2.title, p2.currentValue, p2.newValue
        local price, onUpgrade, onConfirm, onSkipWait = p2.price, p2.onUpgrade, p2.onConfirm, p2.onSkipWait
        local isMaxed, isGlowing, aquariumUpgradeStartedTimestamp, aquariumUpgradeCompleteTimestamp = p2.isMaxed, p2.isGlowing, p2.aquariumUpgradeStartedTimestamp, p2.aquariumUpgradeCompleteTimestamp
        local v15 = useTheme()
        local v16, v17 = useState(function() -- line: 51
            -- upvalues: Workspace (copy)
            return Workspace:GetServerTimeNow()
        end)
        local v18 = aquariumUpgradeStartedTimestamp ~= nil and aquariumUpgradeCompleteTimestamp ~= nil

        useEffect(function() -- line: 55
            -- upvalues: v17 (copy), v18 (copy), RunService (copy), Workspace (copy)
            if not v18 then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function() -- line: 59
                -- upvalues: v17 (copy), Workspace (copy)
                v17(Workspace:GetServerTimeNow())
            end)

            return function() -- line: 62
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v18 })

        local v19, v20, v21, v22

        if v18 then
            v19 = aquariumUpgradeCompleteTimestamp ~= nil and aquariumUpgradeCompleteTimestamp <= v16

            if aquariumUpgradeStartedTimestamp == nil or aquariumUpgradeCompleteTimestamp == nil then
                v21 = 0
                v22 = 0
            else
                local v23 = aquariumUpgradeCompleteTimestamp - aquariumUpgradeStartedTimestamp
                local v24 = v16 - aquariumUpgradeStartedTimestamp

                v20 = if v23 > 0 then math.clamp(v24 / v23, 0, 1) else 1
                v21 = v20
                v22 = aquariumUpgradeCompleteTimestamp - v16
            end
        else
            v19 = v18
            v21 = 0
            v22 = 0
        end

        local v26 = useLoopMotion({
            max = 1,
            min = 0,
            motionType = "linear",
            linearOptions = {
                speed = 0.8
            }
        })[1]
        local v27 = v26:map(function(p3) -- line: 84
            return 0.6 + p3 * 0.3
        end)
        local v28 = v26:map(function(p4) -- line: 87
            return 0.2 + p4 * 0.5
        end)
        local v29 = v26:map(function(p5) -- line: 90
            return UDim2.fromScale(1 + p5 * 0.06, 1 + p5 * 0.06)
        end)
        local v30 = v26:map(function(p6) -- line: 93
            return 3 + p6 * 2
        end)
        local createElement = react.createElement
        local t1 = {
            LightInfluence = 0,
            PixelsPerStud = 20,
            ResetOnSpawn = false,
            Adornee = adornPart,
            Face = Enum.NormalId.Left,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }

        isGlowing = isGlowing and not isMaxed and react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 236, 80),
            BackgroundTransparency = v27,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = v29
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.05, 0)
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(255, 255, 120),
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = v30,
            Transparency = v28
        }))

        local v31 = if isMaxed then react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            shadowYScale = 0.05,
            text = "MAXED OUT",
            color = v2,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v15.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.4),
                TextXAlignment = Enum.TextXAlignment.Center
            }
        }))
            elseif v19 then react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.04, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("uipadding", {
                PaddingBottom = UDim.new(0.05, 0),
                PaddingLeft = UDim.new(0.04, 0),
                PaddingRight = UDim.new(0.04, 0),
                PaddingTop = UDim.new(0.05, 0)
            }), react.createElement(default2, {
                shadowYScale = 0.05,
                text = "COMPLETE!",
                color = v5,
                overrideProps = {
                    LayoutOrder = 1,
                    TextScaled = true,
                    ZIndex = 5,
                    Font = v15.textFont2,
                    Size = UDim2.fromScale(1, 0.3),
                    TextXAlignment = Enum.TextXAlignment.Center
                }
            }), react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromScale(0.88, 0.32)
            }, react.createElement(default3, {
                cornerRadius = 0.15,
                isStudded = true,
                isStuddedTransparency = 0.2,
                strokeThickness = 0.06,
                textureTransparency = 0.75,
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = v4,
                onClick = function() -- onClick | line: 170
                    -- upvalues: onConfirm (copy)
                    local v35 = onConfirm

                    if onConfirm ~= nil then
                        v35 = onConfirm()
                    end

                    return v35
                end,
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(150, 230, 80)
            }, react.createElement(default2, {
                shadowYScale = 0.05,
                text = "Reveal Aquarium",
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 100,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = v15.textFont2,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.85, 0.65),
                    TextXAlignment = Enum.TextXAlignment.Center
                }
            }))))
            elseif v18 then react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.03, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("uipadding", {
                PaddingBottom = UDim.new(0.05, 0),
                PaddingLeft = UDim.new(0.04, 0),
                PaddingRight = UDim.new(0.04, 0),
                PaddingTop = UDim.new(0.05, 0)
            }), react.createElement(default2, {
                shadowYScale = 0.05,
                text = "UPGRADING...",
                color = v2,
                overrideProps = {
                    LayoutOrder = 1,
                    TextScaled = true,
                    ZIndex = 5,
                    Font = v15.textFont2,
                    Size = UDim2.fromScale(1, 0.28),
                    TextXAlignment = Enum.TextXAlignment.Center
                }
            }), react.createElement("frame", {
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                LayoutOrder = 2,
                BackgroundColor3 = v6,
                Size = UDim2.fromScale(0.9, 0.18)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.3, 0)
            }), react.createElement("frame", {
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                BackgroundColor3 = v7,
                Size = UDim2.fromScale(v21, 1)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.3, 0)
            }))), react.createElement(default, {
                overrideProps = {
                    LayoutOrder = 3,
                    TextScaled = true,
                    Font = v15.textFont2,
                    Size = UDim2.fromScale(1, 0.16),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = formatTimeRemaining(v22),
                textColor3 = v1
            }), react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 4,
                Size = UDim2.fromScale(0.88, 0.22)
            }, react.createElement(default3, {
                cornerRadius = 0.15,
                isStudded = true,
                isStuddedTransparency = 0.2,
                strokeThickness = 0.06,
                textureTransparency = 0.75,
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = v8,
                onClick = function() -- onClick | line: 257
                    -- upvalues: onSkipWait (copy)
                    local v41 = onSkipWait

                    if onSkipWait ~= nil then
                        v41 = onSkipWait()
                    end

                    return v41
                end,
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(255, 210, 80)
            }, react.createElement(default2, {
                shadowYScale = 0.05,
                text = "SKIP WAIT!",
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 100,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = v15.textFont2,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.85, 0.65),
                    TextXAlignment = Enum.TextXAlignment.Center
                }
            }))))
            else react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.03, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("uipadding", {
                PaddingBottom = UDim.new(0.05, 0),
                PaddingLeft = UDim.new(0.04, 0),
                PaddingRight = UDim.new(0.04, 0),
                PaddingTop = UDim.new(0.05, 0)
            }), react.createElement(default2, {
                shadowYScale = 0.05,
                color = v2,
                overrideProps = {
                    LayoutOrder = 1,
                    TextScaled = true,
                    ZIndex = 5,
                    Font = v15.textFont2,
                    Size = UDim2.fromScale(1, 0.28),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = title
            }), react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromScale(1, 0.38)
            }, react.createElement(default, {
                overrideProps = {
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.225, 0.5),
                    Size = UDim2.fromScale(0.25, 0.75),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = {
                    Thickness = 0.075
                },
                text = tostring(currentValue),
                textColor3 = v1
            }), react.createElement(default, {
                text = ">",
                overrideProps = {
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.15, 0.6),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                textColor3 = v1
            }), react.createElement(default2, {
                shadowYScale = 0.05,
                color = v3,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 5,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.775, 0.5),
                    Size = UDim2.fromScale(0.32, 0.8),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = tostring(newValue)
            })), react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.fromScale(0.88, 0.28)
            }, react.createElement(default3, {
                cornerRadius = 0.15,
                isStudded = true,
                isStuddedTransparency = 0.2,
                strokeThickness = 0.06,
                textureTransparency = 0.75,
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = v4,
                onClick = function() -- onClick | line: 358
                    -- upvalues: onUpgrade (copy)
                    local v46 = onUpgrade

                    if onUpgrade ~= nil then
                        v46 = onUpgrade()
                    end

                    return v46
                end,
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(150, 230, 80)
            }, react.createElement(default2, {
                shadowYScale = 0.05,
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 100,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = v15.textFont2,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.85, 0.65),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = price
            }))))

        return createElement("surfacegui", t1, isGlowing, v31)
    end
}

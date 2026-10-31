-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState

return {
    default = function(p1) -- PlayerStatsWindow | line: 11
        -- upvalues: react (copy), useBindingState (copy), useViewport (copy), default (copy), default2 (copy), default3 (copy), useScreenSizeState (copy)
        local v1 = useScreenSizeState()
        local v2 = useBindingState(useViewport())
        local v3 = v1 == "sm"
        local v4 = v3 and v2.X > v2.Y
        local v5 = if v4 then UDim2.fromScale(0.55, 0.88) elseif v3 then UDim2.fromScale(0.9, 0.72) else UDim2.fromScale(0.42, 0.62)
        local t2 = {
            {
                label = "Fishes Caught",
                value = tostring(p1.fishesCaught)
            },
            {
                label = "Play Time",
                value = p1.playtime
            },
            {
                label = "Date Joined",
                value = p1.dateJoined
            },
            {
                label = "Power",
                value = p1.power
            },
            {
                label = "Charm Core",
                value = p1.charmCore
            },
            {
                label = "Best Fish MPS",
                value = ("$%*/s"):format(p1.bestFishMps)
            },
            {
                label = "Total MPS",
                value = ("$%*/s"):format(p1.totalMps)
            }
        }
        local v6 = react.createElement("uilistlayout", {
            Padding = UDim.new(0.012, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v7 = react.createElement(default3, {
            shadowYScale = 0.055,
            color = Color3.fromRGB(255, 246, 92),
            overrideProps = {
                LayoutOrder = 0,
                TextScaled = true,
                ZIndex = 10,
                Size = UDim2.fromScale(1, 0.12)
            },
            popoutColor = Color3.fromRGB(18, 59, 72),
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(18, 59, 72)
            },
            text = p1.username
        })
        local v8 = table.create(#t2)

        local function v9(p2, p3) -- line: 61
            -- upvalues: react (copy), default (copy), default3 (copy)
            return react.createElement(default, {
                cornerRadius = 0.045,
                isStudded = true,
                strokeThickness = 0.008,
                textureTransparency = 0.82,
                transparency = 0.08,
                zIndex = 5,
                backgroundColor = Color3.fromRGB(48, 116, 139),
                key = p2.label,
                layoutOrder = p3 + 1,
                size = UDim2.fromScale(1, 0.11),
                strokeColor = Color3.fromRGB(18, 64, 78)
            }, react.createElement(default3, {
                shadowYScale = 0.05,
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 10,
                    Position = UDim2.fromScale(0.045, 0.2),
                    Size = UDim2.fromScale(0.44, 0.6),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                popoutColor = Color3.fromRGB(18, 59, 72),
                strokeProps = {
                    Thickness = 0.035,
                    Color = Color3.fromRGB(18, 59, 72)
                },
                text = p2.label
            }), react.createElement(default3, {
                shadowYScale = 0.05,
                anchorPoint = Vector2.new(1, 0),
                color = Color3.fromRGB(255, 246, 92),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 10,
                    Position = UDim2.fromScale(0, 0.1),
                    Size = UDim2.fromScale(0.42, 0.8),
                    TextXAlignment = Enum.TextXAlignment.Right
                },
                popoutColor = Color3.fromRGB(18, 59, 72),
                position = UDim2.fromScale(0.96, 0.1),
                strokeProps = {
                    Thickness = 0.035,
                    Color = Color3.fromRGB(18, 59, 72)
                },
                text = p2.value
            }))
        end

        for v10, v11 in t2 do
            v8[v10] = v9(v11, v10 - 1, t2)
        end

        return react.createElement(default2, {
            title = "Player Stats",
            aspectRatio = (not v3 or v4) and 1.05 or 0.9,
            bodyBg = Color3.fromRGB(30, 91, 107),
            closeButtonPosition = UDim2.fromScale(0.95, 0.5),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(71, 199, 238)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(35, 155, 218)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 109, 181))
            }),
            onClose = p1.onClose,
            size = v5
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.565),
            Size = UDim2.fromScale(0.88, 0.84)
        }, v6, v7, v8))
    end
}

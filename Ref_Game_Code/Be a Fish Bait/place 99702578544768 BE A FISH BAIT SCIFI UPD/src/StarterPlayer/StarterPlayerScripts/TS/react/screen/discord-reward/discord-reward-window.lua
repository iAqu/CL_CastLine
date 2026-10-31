-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images")
local fishImages, images2 = images.fishImages, images.images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils")
local discordRewardDisplayName, discordRewardRarityLabel = v1.discordRewardDisplayName, v1.discordRewardRarityLabel
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(51, 66, 240))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(180, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 240, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 190, 20))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 90))
})
local certifiedBait = getTitleData("certifiedBait")

local function HeaderContent() -- line: 25
    -- upvalues: react (copy), default3 (copy), useTheme (copy)
    local v7 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.03, 0.5),
        Size = UDim2.fromScale(0.84, 0.85)
    }, react.createElement(default3, {
        text = "Discord Rewards!",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 21,
            Font = v7.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.04,
            Color = Color3.fromRGB(0, 50, 130)
        }
    }))
end

return {
    default = function(p1) -- DiscordRewardWindow | line: 49
        -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useTheme (copy), fishImages (copy), images2 (copy), discordRewardDisplayName (copy), discordRewardRarityLabel (copy), getRarityColor (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), certifiedBait (copy), HeaderContent (copy)
        local v8 = useTheme()
        local v9, v10 = useState("")

        local function v11() -- line: 52
            -- upvalues: p1 (copy), v9 (copy)
            if p1.isClaimed or #v9 == 0 then
                return nil
            end

            p1.onVerify(v9)
        end

        local v12 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.03, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v21 = react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.55, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.3)
        }, react.createElement(default3, {
            shadowYScale = 0.025,
            text = "Join our discord community through the link on our game's page",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 2,
                Font = v8.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = 0.03,
                Color = Color3.fromRGB(0, 30, 100)
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            LayoutOrder = 2,
            ZIndex = 2,
            BackgroundColor3 = Color3.fromRGB(15, 15, 20),
            Size = UDim2.fromScale(0.96, 0.34)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.08, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.02,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images2.discordRewardGuide,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.96, 0.96)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.22)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.06, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 3,
            BackgroundColor3 = Color3.fromRGB(18, 23, 48),
            Size = UDim2.fromScale(0.57, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 4,
            DominantAxis = Enum.DominantAxis.Width
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.25, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.055,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement(default2, {
            cornerRadius = 0.25,
            transparency = 0,
            zIndex = 4,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(45, 55, 105),
            position = UDim2.fromScale(0.5, 0.47),
            size = UDim2.fromScale(1, 0.88)
        }, react.createElement("textbox", {
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            PlaceholderText = "Enter Username",
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Change = {
                Text = function(p2) -- Text | line: 161
                    -- upvalues: v10 (copy)
                    v10(p2.Text)
                end
            },
            Font = v8.textFont,
            PlaceholderColor3 = Color3.fromRGB(170, 180, 220),
            Position = UDim2.fromScale(0.09, 0.45),
            Size = UDim2.fromScale(0.82, 0.6),
            Text = v9,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }))), react.createElement(default4, {
            aspectRatio = 2.4,
            cornerRadius = 0.25,
            layoutOrder = 2,
            zIndex = 3,
            color = if p1.isClaimed then v6 else v5,
            frameSize = UDim2.fromScale(0.35, 1),
            label = p1.isClaimed and "Claimed!" or "Verify",
            onClick = v11,
            popoutColor = if p1.isClaimed then Color3.fromRGB(60, 60, 60) else Color3.fromRGB(10, 120, 10)
        })))
        local v22 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.75
        })
        local v23 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.18,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images2.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 232, 82),
            Position = UDim2.fromScale(0.5, 0.3),
            Size = UDim2.fromScale(1.05, 1.05)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v24 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = fishImages.narwhal,
            Position = UDim2.fromScale(0.5, 0.31),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.74, 0.4)
        })
        local v25 = react.createElement("frame", {
            BackgroundTransparency = 1,
            Rotation = -15,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(-0.05, -0.06),
            Size = UDim2.fromScale(0.5, 0.22)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.4
        }), react.createElement(default3, {
            text = "OP!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.8),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }))
        local v26 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.58),
            Size = UDim2.fromScale(0.85, 0.09)
        }, react.createElement(default3, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = getRarityColor("legendary"),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = discordRewardRarityLabel
        }))
        local v27 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.655),
            Size = UDim2.fromScale(0.9, 0.095)
        }, react.createElement(default3, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = discordRewardDisplayName
        }))
        local v28 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.715),
            Size = UDim2.fromScale(0.16, 0.08)
        }, react.createElement(default3, {
            text = "+",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }))
        local v29 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.86),
            Size = UDim2.fromScale(0.92, 0.09)
        }, react.createElement(default3, {
            text = "NEW TITLE!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 232, 82),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }))
        local t8 = {
            anchorPoint = Vector2.new(0.5, 0.5)
        }
        local v30 = certifiedBait

        if certifiedBait ~= nil then
            v30 = certifiedBait.animatedColor
        end

        if v30 ~= nil then
            t8.color = v30
        else
            local v31 = certifiedBait

            if certifiedBait ~= nil then
                v31 = certifiedBait.color
            end

            t8.color = if v31 == nil then Color3.fromRGB(88, 101, 242) else v31
        end

        t8.overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            Font = v8.textFont2,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        }
        t8.strokeProps = {
            Thickness = 0.04,
            Color = Color3.fromRGB(0, 0, 0)
        }

        local v32 = certifiedBait

        if certifiedBait ~= nil then
            v32 = certifiedBait.displayName
        end

        if v32 == nil then
            v32 = "Fanbait"
        end

        t8.text = ("\"%*\""):format(v32)

        return react.createElement(default, {
            aspectRatio = 1.55,
            bodyTransparency = 0.45,
            title = "",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v2,
            headerNode = react.createElement(HeaderContent),
            onClose = p1.onClose,
            size = UDim2.fromScale(0.52, 0.55)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.56),
            Size = UDim2.fromScale(0.94, 0.8)
        }, v12, v21, react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(0.35, 1)
        }, v22, react.createElement(default2, {
            cornerRadius = 0.06,
            transparency = 1,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, v23, v24, v25, v26, v27, v28, v29, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.95),
            Size = UDim2.fromScale(0.92, 0.095)
        }, react.createElement(default3, t8)), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1.055),
            Size = UDim2.fromScale(0.7, 0.095)
        }, react.createElement(default3, {
            text = "FREE!!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v4,
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v8.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.05,
                Color = Color3.fromRGB(0, 60, 0)
            }
        }))))))
    end
}

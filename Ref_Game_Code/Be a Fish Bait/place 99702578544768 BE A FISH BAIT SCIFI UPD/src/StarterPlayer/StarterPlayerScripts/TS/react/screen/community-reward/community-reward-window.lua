-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils")
local communityRewardDisplayName, communityRewardRarityLabel = v1.communityRewardDisplayName, v1.communityRewardRarityLabel
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 227, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 117, 176))
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
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 50, 20))
})
local v5 = Color3.fromRGB(255, 255, 255)
local v6 = Color3.fromRGB(255, 255, 255)

local function TaskCard(p1) -- line: 18
    -- upvalues: react (copy), default2 (copy), useTheme (copy), v5 (copy), v6 (copy)
    local v7 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        BackgroundColor3 = v5,
        Size = UDim2.fromScale(1, 0.95)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.06, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.015,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = v6,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.03),
        Size = UDim2.fromScale(0.9, 0.22)
    }, react.createElement(default2, {
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 2,
            Font = v7.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.04,
            Color = Color3.fromRGB(0, 80, 0)
        },
        text = p1.label
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(1, 0.72)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.06, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Image = p1.guideImage,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1, 1)
    })))
end

local function HeaderContent() -- line: 74
    -- upvalues: react (copy), default2 (copy), useTheme (copy)
    local v8 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.03, 0.5),
        Size = UDim2.fromScale(0.84, 0.85)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0.015, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        ZIndex = 21,
        Size = UDim2.fromScale(0.87, 1)
    }, react.createElement(default2, {
        text = "FREE FISH!",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 21,
            Font = v8.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.04,
            Color = Color3.fromRGB(0, 50, 130)
        }
    })))
end

return {
    default = function(p2) -- CommunityRewardWindow | line: 109
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), communityRewardDisplayName (copy), communityRewardRarityLabel (copy), images (copy), v2 (copy), v3 (copy), v4 (copy), TaskCard (copy), HeaderContent (copy)
        local v9 = useTheme()
        local v10 = if p2.isClaimed then "Claimed!" elseif p2.isExpired then "Expired" else "Claim"

        return react.createElement(default, {
            aspectRatio = 1.35,
            bodyTransparency = 0.45,
            title = "",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v2,
            headerNode = react.createElement(HeaderContent),
            onClose = p2.onClose,
            size = UDim2.fromScale(0.58, 0.65)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.56),
            Size = UDim2.fromScale(0.98, 0.98)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.02, 0),
            PaddingTop = UDim.new(0.04, 0)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.92, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.03, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.38, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.3,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(200, 220, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.4, 1.4)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.communityRewardIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Rotation = -15,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(-0.1, -0.25),
            Size = UDim2.fromScale(0.6, 0.42)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.4
        }), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v9.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.8),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = communityRewardRarityLabel
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(0.97, 0.97),
            Size = UDim2.fromScale(0.55, 0.26)
        }, react.createElement(default2, {
            text = "$500/s",
            anchorPoint = Vector2.new(1, 1),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 240, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 190, 20))
            }),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v9.textFont2,
                Position = UDim2.fromScale(1, 1),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            strokeProps = {
                Thickness = 0.05,
                Color = Color3.fromRGB(0, 60, 0)
            }
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(0.56, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.28)
        }, react.createElement(default2, {
            text = "~ LIMITED TIME ~",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v4,
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v9.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.95, 0.95),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04,
                Color = Color3.fromRGB(0, 0, 0)
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.8)
        }, react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v9.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = string.upper(communityRewardDisplayName)
        }), react.createElement("uigradient", {
            Rotation = 90,
            Color = v3
        })))), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.04)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.35)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.015, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.31, 0.97)
        }, react.createElement(TaskCard, {
            label = "Like The Game!",
            guideImage = images.likeTheGroup
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(0.31, 0.97)
        }, react.createElement(TaskCard, {
            label = "Favorite The Game!",
            guideImage = images.favouriteTheGame
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            ZIndex = 2,
            Size = UDim2.fromScale(0.31, 0.97)
        }, react.createElement(TaskCard, {
            label = "Join The Community!",
            guideImage = images.joinTheCommunity
        }))), react.createElement(default3, {
            layoutOrder = 5,
            zIndex = 4,
            color = if p2.isClaimed or p2.isExpired then ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 90))
            }) else ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
            }),
            frameSize = UDim2.fromScale(0.3, 0.15),
            label = v10,
            onClick = p2.onClaim,
            popoutColor = if p2.isClaimed or p2.isExpired then Color3.fromRGB(60, 60, 60) else Color3.fromRGB(10, 120, 10)
        })))
    end
}

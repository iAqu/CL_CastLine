-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "og-prime-title-effects").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, script.Parent, "celebration-placeholder-image")
local LabeledImageSlot, PlaceholderImageFrame = v1.LabeledImageSlot, v1.PlaceholderImageFrame
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})

local function OgPrimeCardContent() -- line: 26
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), default2 (copy), getTitleData (copy), images (copy)
    local v4, v5 = useMotion(0)
    local ogPrime = getTitleData("ogPrime")

    useEffect(function() -- line: 29
        -- upvalues: v5 (copy)
        v5:linear(360, {
            speed = 45
        })

        return (v5:onComplete(function() -- line: 36
            -- upvalues: v5 (copy)
            v5:immediate(0)
            v5:linear(360, {
                speed = 45
            })
        end))
    end, { v5 })

    if ogPrime == nil then
        return nil
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiscale", {
        Scale = v4:map(function(p1) -- line: 49
            return math.sin((math.rad(p1))) * 0.025 + 1
        end)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Rotation = -12,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.eventIcon,
        Position = UDim2.fromScale(0.08, 0.47),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.13, 0.72)
    }), react.createElement(default, {
        zIndex = 2,
        animationProgress = v4
    }), react.createElement(default2, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = ogPrime.animatedColor or ogPrime.color,
        gradientOffset = v4:map(function(p2) -- line: 66
            return Vector2.new(math.sin((math.rad(p2))) * 0.22, 0)
        end),
        overrideProps = {
            TextScaled = true,
            Font = Enum.Font.GothamBlack,
            Size = UDim2.fromScale(0.8, 0.2),
            TextTruncate = Enum.TextTruncate.AtEnd
        },
        position = UDim2.fromScale(0.54, 0.5),
        strokeProps = {
            Thickness = 0.09
        },
        text = ogPrime.displayName
    }))
end

local t4 = {
    {
        label = "FOMO Charm",
        image = images.premFomoCharm,
        imageSize = UDim2.fromScale(0.85, 0.85),
        scaleType = Enum.ScaleType.Fit
    },
    {
        label = "OG Prime",
        content = react.createElement(OgPrimeCardContent)
    },
    {
        label = "Scuba Emote",
        image = images.scubaEmoteIcon,
        imageSize = UDim2.fromScale(0.7, 0.7),
        scaleType = Enum.ScaleType.Fit
    },
    {
        label = "Fomo Reelback",
        image = images.reelbackVfxIcon,
        imageSize = UDim2.fromScale(0.8, 0.8),
        scaleType = Enum.ScaleType.Fit
    },
    {
        label = "Fish Hologram Skin",
        image = images.FOMOCakeFishHologram,
        imageSize = UDim2.fromScale(0.85, 0.85),
        scaleType = Enum.ScaleType.Fit
    },
    {
        label = "FOMO Aquarium",
        image = images.fomoAquariumIcon,
        imageSize = UDim2.fromScale(0.7, 0.7),
        scaleType = Enum.ScaleType.Fit
    }
}

return {
    default = function(p3) -- CelebrationRewardsStorePage | line: 125
        -- upvalues: react (copy), default2 (copy), default3 (copy), useTheme (copy), images (copy), LabeledImageSlot (copy), PlaceholderImageFrame (copy), v2 (copy), v3 (copy), t4 (copy)
        local isCelebrationPlace, onOpenStore = p3.isCelebrationPlace, p3.onOpenStore
        local v11 = useTheme()
        local v12 = react.createElement(default2, {
            text = "Limited-Time & Premium Rewards in the FOMO Store",
            anchorPoint = Vector2.new(0.5, 0),
            color = v2,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v11.textFont2,
                Size = UDim2.fromScale(0.72, 0.065)
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0.5, 0.06),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            }
        })
        local v13 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.1, 0.25),
            Size = UDim2.fromScale(0.34, 0.79)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(PlaceholderImageFrame, {
            image = images.ticketShopImage,
            size = UDim2.fromScale(1, 0.76)
        }), react.createElement(default2, {
            shadowYScale = 0.06,
            text = "Your Tickets, Your Picks",
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 3,
                Font = v11.textFont,
                Size = UDim2.fromScale(1, 0.2)
            },
            position = UDim2.fromScale(0.5, 0.8)
        }))
        local v14 = react.createElement("uigridlayout", {
            FillDirectionMaxCells = 3,
            CellPadding = UDim2.fromScale(0.04, 0.06),
            CellSize = UDim2.fromScale(0.255, 0.44),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v15 = table.create(#t4)

        local function v16(p4, p5) -- line: 179
            -- upvalues: react (copy), LabeledImageSlot (copy)
            return react.createElement(LabeledImageSlot, {
                aspectRatio = 1,
                showSunburst = true,
                content = p4.content,
                description = p4.description,
                image = p4.image,
                imageSize = p4.imageSize,
                key = p4.label,
                label = p4.label,
                layoutOrder = p5,
                scaleType = p4.scaleType
            })
        end

        for v17, v18 in t4 do
            v15[v17] = v16(v18, v17 - 1, t4)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v12, v13, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.48, 0.2),
            Size = UDim2.fromScale(0.46, 0.65)
        }, v14, v15), isCelebrationPlace and react.createElement(default3, {
            cornerRadius = 0.15,
            label = "Open event store!",
            shadowYScale = 0.06,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 1),
            color = v3,
            frameSize = UDim2.fromScale(0.221, 0.09),
            onClick = onOpenStore,
            popoutColor = Color3.fromRGB(10, 120, 10),
            position = UDim2.fromScale(0.675, 0.95)
        }))
    end
}

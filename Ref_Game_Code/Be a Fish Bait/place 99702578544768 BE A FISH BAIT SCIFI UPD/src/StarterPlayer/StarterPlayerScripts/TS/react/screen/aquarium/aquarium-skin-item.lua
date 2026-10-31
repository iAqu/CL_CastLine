-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "preview-icon-button").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityColor, getRarityBorderColor = v1.getRarityColor, v1.getRarityBorderColor
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function getButtonConfig(p1, p2, p3) -- line: 15
    -- upvalues: abbreviate (copy)
    if p1 == "equip" then
        return {
            label = "Equip",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
            }),
            popoutColor = Color3.fromRGB(30, 100, 10)
        }
    end

    if p1 == "purchase-robux" then
        return {
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
            }),
            label = if p3 == nil then "Buy" else ("R$ %*"):format(p3),
            popoutColor = Color3.fromRGB(0, 60, 140)
        }
    end

    if p1 == "source-daily-reward" then
        return {
            label = "Daily Reward",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 20))
            }),
            popoutColor = Color3.fromRGB(110, 10, 5)
        }
    end

    if p1 == "source-exclusive-shop" then
        return {
            label = "Exclusive Shop",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 60, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 10, 200))
            }),
            popoutColor = Color3.fromRGB(60, 0, 110)
        }
    end

    if p1 == "source-event-shop" then
        return {
            label = "Event Shop",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 89, 214)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 66, 255))
            }),
            popoutColor = Color3.fromRGB(78, 20, 125)
        }
    end

    if p1 == "source-spin-wheel" then
        return {
            label = "Spin Wheel",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 155, 0))
            }),
            popoutColor = Color3.fromRGB(110, 70, 0)
        }
    end

    if p1 == "source-index" then
        return {
            label = "Index",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 160, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 90, 210))
            }),
            popoutColor = Color3.fromRGB(5, 40, 120)
        }
    end

    return {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 195, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 140, 0))
        }),
        label = if p2 == nil then "Buy" else ("$%*"):format((abbreviate(p2))),
        popoutColor = Color3.fromRGB(120, 70, 0)
    }
end

local t3 = {
    common = "Common",
    uncommon = "Uncommon",
    rare = "Rare",
    epic = "Epic",
    legendary = "Legendary",
    mythic = "Mythic",
    godly = "Godly",
    secret = "Secret",
    hacked = "Hacked",
    cosmic = "Cosmic",
    extinct = "Extinct",
    kaijuwu = "KaijUwU",
    scifi = "Scifi",
    exclusive = "Exclusive"
}

return {
    default = function(p4) -- AquariumSkinItem | line: 87
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), getRarityColor (copy), getRarityBorderColor (copy), images (copy), getButtonConfig (copy), t3 (copy)
        local buttonState, description, displayName, imageId = p4.buttonState, p4.description, p4.displayName, p4.imageId
        local layoutOrder, moneyBoost, moneyPrice, _ = p4.layoutOrder, p4.moneyBoost, p4.moneyPrice, p4.name
        local onAction, onPreview, rarity = p4.onAction, p4.onPreview, p4.rarity
        local v2 = getButtonConfig(buttonState, moneyPrice, p4.robuxPrice)
        local createElement = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder,
            Size = UDim2.fromScale(1, 1)
        }
        local v3 = react.createElement(default, {
            cornerRadius = 0.06,
            strokeThickness = 0.006,
            transparency = 0.5,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(30, 35, 55),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(70, 80, 110)
        })
        local v10 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.015, 0.5),
            Size = UDim2.fromScale(0.86, 0.82)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }), react.createElement(default2, {
            backgroundTransparency = 0.6,
            cornerRadius = 8,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            backgroundTransparency = 0.5,
            cornerRadius = 8,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(41, 41, 41),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.92, 0.92)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.8,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.glowIcon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.1, 1.1)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }), moneyBoost ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.98),
            Size = UDim2.fromScale(0.9, 0.14)
        }, react.createElement(default6, {
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = ("SKIN: +%*%% MONEY"):format((math.round(moneyBoost * 100))),
            textColor3 = Color3.fromRGB(46, 255, 5)
        }))), react.createElement(default5, {
            zIndex = 8,
            anchorPoint = Vector2.new(1, 0),
            onClick = onPreview,
            position = UDim2.fromScale(1, 0),
            size = UDim2.fromOffset(28, 28)
        }))
        local createElement4 = react.createElement
        local t9 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.475, 0.525),
            Size = UDim2.fromScale(0.5, 0.97)
        }
        local v11 = react.createElement(default3, {
            shadowYScale = 0.06,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0, 0),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0, 0.02),
                Size = UDim2.fromScale(0.9, 0.18),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.06,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = displayName
        })
        local v12 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0),
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0, 0.2),
            Size = UDim2.fromScale(0.9, 0.12),
            Text = t3[rarity],
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = getRarityColor(rarity)
        }), react.createElement("uistroke", {
            Thickness = 0.03,
            Color = getRarityBorderColor(rarity),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))
        local v13 = description ~= "" and react.createElement(default6, {
            overrideProps = {
                ZIndex = 4,
                AnchorPoint = Vector2.new(0, 0),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0, 0.345),
                Size = UDim2.fromScale(1, 0.22),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 0.05
            },
            text = description,
            textColor3 = Color3.fromRGB(180, 185, 200)
        })
        local v14 = if buttonState == "equipped" then react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, 0.9),
            Size = UDim2.fromScale(1, 0.16)
        }, react.createElement(default3, {
            shadowYScale = 0.05,
            text = "Equipped!",
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
            }),
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.04
            }
        }))
            elseif buttonState ~= "none" then react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.fromScale(0, 0.925),
                Size = UDim2.fromScale(1, 0.22)
            }, react.createElement(default4, {
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                color = v2.color,
                frameSize = UDim2.fromScale(0.9, 1),
                label = v2.label,
                onClick = onAction,
                popoutColor = v2.popoutColor,
                position = UDim2.fromScale(0.5, 0.5)
            }))
            else nil

        return createElement("frame", t4, v3, v10, createElement4("frame", t9, v11, v12, v13, v14))
    end
}

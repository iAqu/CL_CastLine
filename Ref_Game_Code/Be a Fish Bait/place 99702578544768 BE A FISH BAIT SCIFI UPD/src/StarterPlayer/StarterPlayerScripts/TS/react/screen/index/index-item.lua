-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-badge").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, getRarityDisplayName = v1.getRarityBorderColor, v1.getRarityColor, v1.getRarityDisplayName

return {
    default = function(p1) -- IndexItem | line: 16
        -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), abbreviate (copy), images (copy), getRarityBorderColor (copy), getRarityColor (copy), getRarityDisplayName (copy)
        local v2, v3 = useState(false)
        local v4 = useTheme()
        local v5 = getRarityColor(p1.rarity)
        local v6 = getRarityBorderColor(p1.rarity)
        local name = p1.name
        local v7 = if p1.isUnlocked then v6 else Color3.fromRGB(55, 80, 105)
        local mutationColor = if p1.isUnlocked then p1.mutationColor else nil
        local v8 = p1.mutationBadgeLabel ~= nil
        local unlockSourceLabel = p1.unlockSourceLabel
        local v9 = v2 and unlockSourceLabel ~= nil
        local v10 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Width
        })
        local v12 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.045, 0)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = v7,
            ImageTransparency = p1.isUnlocked and 0.03 or 0.18,
            Position = UDim2.fromScale(0.5, 0.52),
            Size = UDim2.fromScale(1.28, 1.18)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })))
        local v13 = mutationColor ~= nil and not v8 and react.createElement("frame", {
            BackgroundTransparency = 0.14,
            BorderSizePixel = 0,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = mutationColor,
            Position = UDim2.fromScale(0.05, 0.05),
            Size = UDim2.fromScale(0.14, 0.14)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.08,
            Transparency = 0.28,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))

        if mutationColor == nil then
            v8 = false
        end

        if v8 then
            local t3 = {
                shadowYScale = 0.04,
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 8,
                    Font = v4.textFont2,
                    Position = UDim2.fromScale(0.11, 0.035),
                    Size = UDim2.fromScale(0.2, 0.2)
                },
                strokeProps = {
                    Thickness = 0.05
                }
            }
            local mutationBadgeLabel = p1.mutationBadgeLabel

            t3.text = if mutationBadgeLabel == nil then "" else mutationBadgeLabel
            v8 = react.createElement(default3, t3)
        end

        local t4 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local imageId = p1.imageId

        t4.Image = if imageId == nil then images.testGem else imageId
        t4.ImageColor3 = if p1.isUnlocked then Color3.new(1, 1, 1) else Color3.fromRGB(0, 0, 0)
        t4.ImageTransparency = p1.isUnlocked and 0 or 0.04
        t4.Position = UDim2.fromScale(0.5, 0.51)
        t4.ScaleType = Enum.ScaleType.Fit
        t4.Size = UDim2.fromScale(0.9, 0.62)
        t4.ZIndex = 2

        local v14 = react.createElement("imagelabel", t4)
        local t5 = {
            shadowYScale = 0.05,
            color = Color3.fromRGB(100, 220, 80),
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v4.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            strokeProps = {
                Thickness = 0.045
            }
        }
        local moneyPerSecondLabel = p1.moneyPerSecondLabel

        t5.text = if moneyPerSecondLabel == nil then ("$%*/s"):format((abbreviate(p1.moneyPerSecond))) else moneyPerSecondLabel

        return react.createElement(default, {
            clipsDescendants = true,
            cornerRadius = 0.045,
            isStudded = true,
            strokeThickness = 0.03,
            tileSize = 64,
            backgroundColor = p1.cardBackgroundColor or v5,
            layoutOrder = p1.layoutOrder,
            strokeColor = if not p1.isUnlocked then Color3.fromRGB(20, 20, 20) else v6,
            textureTransparency = p1.isUnlocked and 0.86 or 0.72,
            transparency = p1.isUnlocked and 0 or 0.18
        }, v10, v12, v13, v8, v14, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(0.965, 0.03),
            Size = UDim2.fromScale(0.56, 0.16)
        }, react.createElement(default3, t5)), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.205),
            Size = UDim2.fromScale(0.9, 0.16)
        }, react.createElement(default3, {
            shadowYScale = 0.05,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v4.textFont,
                Size = UDim2.fromScale(1, 1)
            },
            strokeProps = {
                Thickness = 0.04
            },
            text = name
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 1),
            Font = v4.textFont,
            Position = UDim2.fromScale(0.5, 0.94),
            Size = UDim2.fromScale(0.9, 0.15),
            Text = getRarityDisplayName(p1.rarity),
            TextColor3 = Color3.new(1, 1, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v5
        }), react.createElement("uistroke", {
            Thickness = 0.085,
            Color = Color3.fromRGB(10, 10, 10),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), p1.isNew == true and react.createElement(default2, {
            zIndex = 10,
            anchorPoint = Vector2.new(1, 0),
            position = UDim2.fromScale(0.98, 0.02),
            size = UDim2.fromScale(0.26, 0.26)
        }), v9 and react.createElement("frame", {
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            ZIndex = 18,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            Position = UDim2.fromScale(0.5, 0.98),
            Size = UDim2.fromScale(0.9, 0.27)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.16, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.035,
            Transparency = 0.1,
            Color = Color3.fromRGB(255, 225, 85),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement(default3, {
            shadowYScale = 0.04,
            text = "Unlocked from:",
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 19,
                Font = v4.textFont2,
                Position = UDim2.fromScale(0.05, 0.08),
                Size = UDim2.fromScale(0.9, 0.36)
            },
            strokeProps = {
                Thickness = 0.04
            }
        }), react.createElement(default3, {
            shadowYScale = 0.04,
            color = Color3.fromRGB(255, 230, 95),
            overrideProps = {
                TextScaled = true,
                ZIndex = 19,
                Font = v4.textFont2,
                Position = UDim2.fromScale(0.05, 0.48),
                Size = UDim2.fromScale(0.9, 0.38)
            },
            strokeProps = {
                Thickness = 0.04
            },
            text = unlockSourceLabel
        })), unlockSourceLabel ~= nil and react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            ZIndex = 20,
            Event = {
                MouseEnter = function() -- MouseEnter | line: 233
                    -- upvalues: v3 (copy)
                    return v3(true)
                end,
                MouseLeave = function() -- MouseLeave | line: 236
                    -- upvalues: v3 (copy)
                    return v3(false)
                end
            },
            Size = UDim2.fromScale(1, 1)
        }))
    end
}

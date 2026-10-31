-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, getRarityDisplayName = v1.getRarityBorderColor, v1.getRarityColor, v1.getRarityDisplayName
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 170))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 130, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
})

return {
    default = function(p1) -- WeightsShopItem | line: 23
        -- upvalues: react (copy), useRootProducer (copy), useTheme (copy), images (copy), getRarityBorderColor (copy), getRarityColor (copy), getRarityDisplayName (copy), HttpService (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), abbreviate (copy), useProductPrice (copy), useFreePurchaseModeEnabled (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
        local v6 = useTheme()
        local v7 = useFreePurchaseModeEnabled()
        local v8 = useProductPrice(p1.robuxProductId, Enum.InfoType.Product)

        if v8 == nil then
            v8 = p1.robuxPrice
        end

        local v9 = if v7 then "FREE" else ("R$%*"):format(v8)
        local rarity = p1.rarity
        local v10 = getRarityColor(rarity)
        local v11 = getRarityBorderColor(rarity)
        local showTutorialPointer = p1.showTutorialPointer

        if showTutorialPointer == nil then
            showTutorialPointer = false
        end

        local v12 = p1.rebirthRequirement ~= nil
        local v13

        if v12 then
            local playerRebirthCount = p1.playerRebirthCount

            if playerRebirthCount == nil then
                playerRebirthCount = 0
            end

            v13 = playerRebirthCount < p1.rebirthRequirement and not p1.isOwned
        else
            v13 = v12
        end

        local v14 = useRootProducer()

        local function v15() -- line: 54
            -- upvalues: p1 (copy), v14 (copy), HttpService (copy)
            v14.onScreenFeedbackAdded({
                type = "error",
                id = HttpService:GenerateGUID(false),
                message = ("Rebirth %* required!"):format(p1.rebirthRequirement)
            })
        end

        local function v16() -- line: 61
            -- upvalues: p1 (copy), v6 (copy), v13 (ref), v15 (copy), v9 (copy), react (copy), default2 (copy), default3 (copy), abbreviate (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
            if p1.isEquipped then
                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.fromScale(0.5, 0.97),
                    Size = UDim2.fromScale(0.7, 0.13)
                }, react.createElement("uilistlayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0.05, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                }), react.createElement("frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    ZIndex = 4,
                    Size = UDim2.fromScale(0.75, 1)
                }, react.createElement(default3, {
                    shadowYScale = 0.05,
                    text = "Equipped!",
                    color = v2,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 4,
                        Font = v6.textFont2,
                        Size = UDim2.fromScale(1, 1),
                        TextXAlignment = Enum.TextXAlignment.Center
                    },
                    strokeProps = {
                        Thickness = 0.04
                    }
                })))
            end

            if p1.isOwned then
                return react.createElement(default2, {
                    label = "Equip",
                    zIndex = 4,
                    anchorPoint = Vector2.new(0.5, 1),
                    color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 213, 15)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(209, 153, 0))
                    }),
                    frameSize = UDim2.fromScale(0.5, 0.13),
                    onClick = p1.onEquip,
                    popoutColor = Color3.fromRGB(150, 110, 0),
                    position = UDim2.fromScale(0.5, 0.97)
                })
            end

            if v13 then
                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.fromScale(0.5, 0.97),
                    Size = UDim2.fromScale(0.9, 0.13)
                }, react.createElement("uilistlayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0.04, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                }), react.createElement(default2, {
                    zIndex = 4,
                    color = v5,
                    frameSize = UDim2.fromScale(0.47, 1),
                    label = ("%*$"):format((abbreviate(p1.price))),
                    onClick = v15,
                    popoutColor = Color3.fromRGB(50, 50, 50)
                }), react.createElement(default2, {
                    zIndex = 4,
                    color = v4,
                    frameSize = UDim2.fromScale(0.47, 1),
                    label = v9,
                    onClick = p1.onBuyWithRobux or function() -- line: 135
                    end,
                    popoutColor = Color3.fromRGB(80, 20, 130)
                }))
            end

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 0.97),
                Size = UDim2.fromScale(0.9, 0.13)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.04, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement(default2, {
                zIndex = 4,
                color = v3,
                frameSize = UDim2.fromScale(0.47, 1),
                label = ("%*$"):format((abbreviate(p1.price))),
                onClick = p1.onBuy or function() -- line: 157
                end,
                popoutColor = Color3.fromRGB(10, 120, 10)
            }), react.createElement(default2, {
                zIndex = 4,
                color = v4,
                frameSize = UDim2.fromScale(0.47, 1),
                label = v9,
                onClick = p1.onBuyWithRobux or function() -- line: 164
                end,
                popoutColor = Color3.fromRGB(80, 20, 130)
            }))
        end

        local t6 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local imageId = p1.imageId

        t6.Image = if imageId == nil then images.testGem else imageId
        t6.Position = UDim2.fromScale(0.5, 0.46)
        t6.Size = UDim2.fromScale(0.95, 0.55)
        t6.ZIndex = 2

        return react.createElement(default, {
            cornerRadius = 0.01,
            isStudded = true,
            strokeThickness = 0.01,
            textureTransparency = 0.6,
            tileSize = 80,
            transparency = 0.65,
            backgroundColor = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(193, 193, 193)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(193, 193, 193)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(193, 193, 193)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55))
            }),
            layoutOrder = p1.layoutOrder,
            strokeColor = Color3.fromRGB(64, 64, 64)
        }, react.createElement("imagelabel", t6, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.07, 0.03),
            Size = UDim2.fromScale(0.86, 0.1)
        }, react.createElement(default3, {
            shadowYScale = 0.05,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v6.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.03
            },
            text = p1.name
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0),
            Font = v6.textFont,
            Position = UDim2.fromScale(0.07, 0.13),
            Size = UDim2.fromScale(1, 0.08),
            Text = getRarityDisplayName(p1.rarity),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v10
        }), react.createElement("uistroke", {
            Thickness = 0.03,
            Color = v11,
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.65),
            Size = UDim2.fromScale(0.86, 0.18)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 4,
            Size = UDim2.fromScale(1, 0.5)
        }, react.createElement(default3, {
            color = Color3.fromRGB(255, 220, 60),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = ("%* kg"):format((abbreviate(p1.weightKg)))
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextScaled = true,
            ZIndex = 4,
            Font = v6.textFont2,
            Size = UDim2.fromScale(1, 0.5),
            Text = ("Power: %*"):format((abbreviate(p1.power))),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 0.075,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))), v13 and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.76),
            Size = UDim2.fromScale(1, 0.075)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 4,
            Image = images.lockIcon,
            Size = UDim2.fromScale(0.15, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextScaled = true,
            ZIndex = 4,
            Font = v6.textFont2,
            Size = UDim2.fromScale(0.6, 1),
            Text = ("REBIRTH: %*"):format(p1.rebirthRequirement),
            TextColor3 = Color3.fromRGB(220, 60, 60),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 0.075,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))), v16(), showTutorialPointer and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.225, 0.85),
            Size = UDim2.fromScale(0.3, 0.3)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }), react.createElement(default4, {
            direction = "down",
            color = Color3.new(1, 1, 1),
            size = UDim2.fromScale(1, 1)
        })))
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default4 = RuntimeLib.import(script, script.Parent.Parent, "celebration-event-shop", "celebration-sunburst-glow").default
local default5 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "exclusive-shop-purchase-buttons").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates")
local aquariumCrateHardPity, firstAquariumCratePriceRobux, getAquariumCrateProductForQuantity, getAquariumCrateSeriesMutationLuckBonus = v1.aquariumCrateHardPity, v1.firstAquariumCratePriceRobux, v1.getAquariumCrateProductForQuantity, v1.getAquariumCrateSeriesMutationLuckBonus
local isAquariumCrateSeriesReleased, singleAquariumCratePriceRobux = v1.isAquariumCrateSeriesReleased, v1.singleAquariumCratePriceRobux
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local robuxIconPrefix = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").robuxIconPrefix
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, rarityColors = v2.getRarityBorderColor, v2.getRarityColor, v2.rarityColors
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(63, 13, 117)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(163, 28, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(43, 8, 87))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(195, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(116, 68, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 130, 255))
})
local t1 = {
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 255, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 215, 10))
    }),
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 255, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 215, 10))
    }),
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 151, 20)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 74, 148)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(228, 42, 196))
    })
}
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 232, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(42, 151, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 81, 228))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 213, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 132, 8))
})
local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 170))
})
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 47, 4)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(180, 112, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 199, 42))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 76, 63)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 76, 63)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 232, 204)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 76, 63)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 76, 63))
})
local v10 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 181, 35)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 181, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 218)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 181, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 181, 35))
})
local v11 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 255, 68)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(90, 255, 68)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(225, 255, 214)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(90, 255, 68)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 255, 68))
})

local function getCratePreviewRarityOrder(p1) -- line: 37
    if p1 == "rare" then
        return 0
    end

    if p1 == "epic" then
        return 1
    end

    if p1 == "legendary" then
        return 2
    end

    if p1 == "mythic" then
        return 3
    end

    return 4
end

local function getOrderedAquariumCrateEntries(p2) -- line: 55
    local t2 = {}
    local v12 = #t2
    local entries = p2.entries

    table.move(entries, 1, #entries, v12 + 1, t2)
    table.sort(t2, function(p3, p4) -- line: 61
        local rarity = p3.skin.rarity
        local v13 = if rarity == "rare" then 0
            elseif rarity == "epic" then 1
            elseif rarity == "legendary" then 2
            elseif rarity == "mythic" then 3
            else 4
        local rarity2 = p4.skin.rarity

        return v13 < (if rarity2 == "rare" then 0
            elseif rarity2 == "epic" then 1
            elseif rarity2 == "legendary" then 2
            elseif rarity2 == "mythic" then 3
            else 4)
    end)

    return t2
end

local function getExclusiveShopPreviewEntries(p5) -- line: 66
    -- upvalues: getOrderedAquariumCrateEntries (copy)
    local v14 = getOrderedAquariumCrateEntries(p5)
    local v15 = table.create(#v14)

    local function v16(p6) -- line: 70
        local skin = p6.skin
        local t3 = {
            chancePercent = p6.weightBasisPoints / 100,
            displayName = skin.displayName,
            imageId = skin.imageId
        }
        local moneyBoost = skin.moneyBoost

        t3.moneyBoost = if moneyBoost == nil then 0 else moneyBoost
        t3.rarity = skin.rarity

        return t3
    end

    for v17, v18 in v14 do
        local _ = v17 - 1
        local skin = v18.skin
        local t4 = {
            chancePercent = v18.weightBasisPoints / 100,
            displayName = skin.displayName,
            imageId = skin.imageId
        }
        local moneyBoost = skin.moneyBoost

        t4.moneyBoost = if moneyBoost == nil then 0 else moneyBoost
        t4.rarity = skin.rarity
        v15[v17] = t4
    end

    return v15
end

local t5 = {
    Vector2.new(0.08, 0.28),
    Vector2.new(0.18, 0.1),
    Vector2.new(0.34, 0.37),
    Vector2.new(0.49, 0.16),
    Vector2.new(0.63, 0.33),
    Vector2.new(0.79, 0.13),
    Vector2.new(0.91, 0.38)
}

local function getChanceText(p7) -- line: 94
    return (`{ p7 / 100 }%`)
end

local function getPurchaseCaptionColor(p8) -- line: 98
    if p8 == 1 then
        return Color3.fromRGB(112, 255, 72)
    end

    if p8 == 3 then
        return Color3.fromRGB(255, 205, 60)
    end

    return Color3.fromRGB(220, 105, 255)
end

local function CrossedRobuxPrice() -- line: 107
    -- upvalues: react (copy), default3 (copy), useTheme (copy), singleAquariumCratePriceRobux (copy), images (copy)
    local v19 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 15,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, -0.01),
        Size = UDim2.fromScale(0.62, 0.36)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 15,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.01, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        ZIndex = 15,
        Image = images.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.3, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    })), react.createElement(default3, {
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 15,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = v19.textFont,
            Size = UDim2.fromScale(0, 0.9),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.05
        },
        text = tostring(singleAquariumCratePriceRobux)
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        Rotation = 8,
        ZIndex = 16,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(235, 35, 35),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromScale(0.72, 0.1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.14,
        Color = Color3.fromRGB(105, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    })))
end

local function ExclusiveShopAquariumCratePanel(p9) -- line: 170
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), default4 (copy), default5 (copy), aquariumCrateHardPity (copy), firstAquariumCratePriceRobux (copy), getAquariumCrateProductForQuantity (copy), getAquariumCrateSeriesMutationLuckBonus (copy), isAquariumCrateSeriesReleased (copy), images (copy), getRarityColor (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), getExclusiveShopPreviewEntries (copy), getPurchaseCaptionColor (copy), CrossedRobuxPrice (copy)
    local v22 = useTheme()
    local v23, v24 = useMotion(-1)
    local v25 = v23:map(function(p10) -- line: 173
        return Vector2.new(p10, 0)
    end)
    local v26 = getExclusiveShopPreviewEntries(p9.series)
    local v27 = isAquariumCrateSeriesReleased(p9.series.id)
    local v28 = getAquariumCrateSeriesMutationLuckBonus(p9.series.id)
    local v30 = math.min(math.max(p9.pityCount, 0), aquariumCrateHardPity)
    local v31 = v30 / aquariumCrateHardPity
    local v32 = p9.purchasesDisabled == true or not p9.paidItemsAllowed or not v27
    local v33 = if v27 then "UNAVAILABLE" else "COMING SOON"

    useEffect(function() -- line: 183
        -- upvalues: v24 (copy)
        v24:linear(1, {
            speed = 1.4
        })

        local v34 = v24:onComplete(function() -- line: 190
            -- upvalues: v24 (copy)
            v24:immediate(-1)
            v24:linear(1, {
                speed = 1.4
            })
        end)

        return function() -- line: 194
            -- upvalues: v34 (copy)
            return v34()
        end
    end, { v24 })

    local v35 = react.createElement(default3, {
        shadowYScale = 0.06,
        text = "NEW!",
        anchorPoint = Vector2.new(0, 0),
        color = Color3.fromRGB(255, 35, 35),
        overrideProps = {
            Rotation = -12,
            TextScaled = true,
            ZIndex = 13,
            Font = v22.textFont2,
            Size = UDim2.fromScale(0.17, 0.13),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        position = UDim2.fromScale(-0.06, -0.07),
        strokeProps = {
            Thickness = 0.08
        }
    })
    local v36 = react.createElement(default3, {
        shadowYScale = 0.055,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 12,
            Font = v22.textFont2,
            Position = UDim2.fromScale(0.14, 0.015),
            Size = UDim2.fromScale(0.72, 0.15),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.085
        },
        text = string.upper(p9.series.displayName)
    })
    local v37 = p9.showShardsButton ~= false and react.createElement(default2, {
        isShiny = true,
        isStudded = true,
        label = "SHARDS",
        zIndex = 14,
        anchorPoint = Vector2.new(0.5, 0),
        color = v5,
        disabled = p9.onShards == nil,
        font = v22.textFont2,
        frameSize = UDim2.fromScale(0.17, 0.115),
        onClick = function() -- onClick | line: 241
            -- upvalues: p9 (copy)
            local onShards = p9.onShards

            if onShards ~= nil then
                onShards = onShards()
            end

            return onShards
        end,
        popoutColor = Color3.fromRGB(18, 66, 151),
        position = UDim2.fromScale(0.89, 0.025),
        size = UDim2.fromScale(0.88, 0.58),
        strokeColor = Color3.fromRGB(5, 21, 58)
    })
    local v38 = p9.crateIconVisible ~= false and react.createElement(react.Fragment, nil, react.createElement(default4, {
        animated = true,
        clipsDescendants = false,
        zIndex = 1,
        accentColor = Color3.fromRGB(121, 84, 255),
        position = UDim2.fromScale(0.085, 0.37),
        size = UDim2.fromScale(0.43, 1.18)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Rotation = -5,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = p9.series.crateImageId,
        Position = UDim2.fromScale(0.085, 0.37),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.34, 0.72)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    })))
    local v39 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.018, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v40 = table.create(#v26)

    local function v41(p11, p12) -- line: 283
        -- upvalues: v22 (copy), v25 (copy), react (copy), default (copy), default3 (copy), images (copy), getRarityColor (copy), v8 (copy), v9 (copy)
        return react.createElement(default, {
            cornerRadius = 0.06,
            backgroundColor = if p11.rarity == "mythic" then v8 else Color3.fromRGB(0, 0, 0),
            key = p11.displayName,
            layoutOrder = p12,
            size = UDim2.fromScale(p11.rarity == "mythic" and 0.26 or 0.225, p11.rarity == "mythic" and 1.04 or 0.91),
            strokeColor = if p11.rarity == "mythic" then Color3.fromRGB(8, 8, 8) else Color3.fromRGB(12, 12, 12),
            strokeThickness = p11.rarity == "mythic" and 0.025 or 0.018,
            transparency = p11.rarity == "mythic" and 0.08 or 0.32,
            zIndex = p11.rarity == "mythic" and 7 or 5
        }, react.createElement(default3, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0.15, 0.45),
            color = if p11.rarity == "mythic" then Color3.fromRGB(255, 232, 77) else Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 12,
                Font = v22.textFont2,
                Position = UDim2.fromScale(0.015, -0.015),
                Size = UDim2.fromScale(0.5, 0.22),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.065
            },
            text = ("%*%%"):format(p11.chancePercent)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = if p11.rarity == "mythic" then Color3.fromRGB(255, 230, 97) else Color3.fromRGB(255, 255, 255),
            ImageTransparency = p11.rarity == "mythic" and 0.25 or 0.48,
            Position = UDim2.fromScale(0.5, 0.42),
            Size = UDim2.fromScale(1.08, 0.92)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = p11.imageId,
            Position = UDim2.fromScale(0.5, p11.rarity == "mythic" and 0.015 or 0.035),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(p11.rarity == "mythic" and 1.5 or 1.38, p11.rarity == "mythic" and 0.88 or 0.82)
        }), react.createElement(default3, {
            shadowYScale = 0.045,
            color = if p11.rarity == "mythic" then v9 else getRarityColor(p11.rarity),
            gradientOffset = if p11.rarity == "mythic" then v25 else nil,
            gradientRotation = if p11.rarity == "mythic" then 0 else nil,
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                Font = v22.textFont2,
                Position = UDim2.fromScale(0.04, 0.65),
                Size = UDim2.fromScale(0.92, 0.16),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.075
            },
            text = string.upper(p11.displayName)
        }), react.createElement(default3, {
            shadowYScale = 0.045,
            color = Color3.fromRGB(91, 255, 72),
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                Font = v22.textFont2,
                Position = UDim2.fromScale(0.06, 0.81),
                Size = UDim2.fromScale(0.88, 0.12),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.055
            },
            text = ("+%*%% Cash"):format((math.round(p11.moneyBoost * 100)))
        }))
    end

    for v47, v48 in v26 do
        v40[v47] = v41(v48, v47 - 1, v26)
    end

    local v53 = react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        Position = UDim2.fromScale(0.245, 0.18),
        Size = UDim2.fromScale(0.73, 0.79)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Position = UDim2.fromScale(0, 0.085),
        Size = UDim2.fromScale(1, 0.46)
    }, v39, v40), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 8,
        Position = UDim2.fromScale(0.015, 0.56),
        Size = UDim2.fromScale(0.97, 0.17)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 8,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(0.72, 1)
    }, react.createElement(default3, {
        gradientRotation = 0,
        shadowYScale = 0.055,
        text = "COLLECT ALL 4",
        color = v10,
        gradientOffset = v25,
        overrideProps = {
            TextScaled = true,
            ZIndex = 9,
            Font = v22.textFont2,
            Position = UDim2.fromScale(0, 0.2),
            Size = UDim2.fromScale(0.41, 0.58),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        strokeProps = {
            Thickness = 0.08
        }
    }), react.createElement(default3, {
        shadowYScale = 0.04,
        text = "•",
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 9,
            Font = v22.textFont2,
            Position = UDim2.fromScale(0.41, 0.2),
            Size = UDim2.fromScale(0.055, 0.58),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.05,
            Color = Color3.fromRGB(0, 0, 0)
        }
    }), react.createElement(default3, {
        gradientRotation = 0,
        shadowYScale = 0.055,
        color = v11,
        gradientOffset = v25,
        overrideProps = {
            TextScaled = true,
            ZIndex = 9,
            Font = v22.textFont2,
            Position = UDim2.fromScale(0.465, 0.2),
            Size = UDim2.fromScale(0.535, 0.58),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = ("+%*%% MUTATION LUCK"):format((math.round(v28 * 100)))
    })), react.createElement(default, {
        cornerRadius = 0.15,
        isStudded = true,
        isStuddedTransparency = 0.24,
        strokeThickness = 0.025,
        textureTransparency = 0.88,
        zIndex = 8,
        backgroundColor = Color3.fromRGB(17, 5, 32),
        position = UDim2.fromScale(0.75, 0.25),
        size = UDim2.fromScale(0.26, 0.5),
        strokeColor = Color3.fromRGB(10, 3, 24)
    }, react.createElement(default, {
        cornerRadius = 0.15,
        zIndex = 9,
        backgroundColor = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(103, 255, 37)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 78, 183))
        }),
        position = UDim2.fromScale(0.015, 0.14),
        size = UDim2.fromScale(v31 * 0.97, 0.72)
    }), react.createElement(default3, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 10,
            Font = v22.textFont2,
            Position = UDim2.fromScale(0.04, 0.08),
            Size = UDim2.fromScale(0.92, 0.82),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.055
        },
        text = ("MYTHIC PITY  %*/%*"):format(v30, aquariumCrateHardPity)
    }))))
    local v54 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.012, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local t20 = {
        1, 3, 10
    }
    local v55 = table.create(#t20)

    local function v56(p13) -- line: 484
        -- upvalues: p9 (copy), v22 (copy), v32 (copy), v33 (copy), react (copy), default3 (copy), default5 (copy), firstAquariumCratePriceRobux (copy), getAquariumCrateProductForQuantity (copy), v6 (copy), v7 (copy), getPurchaseCaptionColor (copy), CrossedRobuxPrice (copy)
        local v57 = p13 == 1 and p9.hasPurchasedFirstCrate ~= true
        local v58 = getAquariumCrateProductForQuantity(p9.series.id, p13, v57)
        local v59 = if v57 then p9.prices.first
            elseif p13 == 1 then p9.prices.one
            elseif p13 == 3 then p9.prices.three
            else p9.prices.ten
        local v60 = v58 ~= nil and v58.productId > 0
        local v61 = v32 or not v60
        local v62 = if v32 then v33 elseif v60 then "LOADING" else "COMING SOON"
        local v63 = if v57 then react.createElement(CrossedRobuxPrice) else nil
        local t21 = {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = if p13 == 3 then v6 elseif p13 == 10 then v7 else nil,
            disabledLabel = v62,
            onBuy = function() -- onBuy | line: 496
                -- upvalues: p13 (copy), p9 (copy)
                return p9.onPurchase(p13)
            end,
            onGift = function() -- onGift | line: 499
            end,
            owned = v61,
            popoutColor = if p13 == 3 then Color3.fromRGB(171, 83, 0) elseif p13 == 10 then Color3.fromRGB(80, 20, 130) else nil,
            position = UDim2.fromScale(0.5, 0.39)
        }

        t21.price = if v59 == nil then 0 else v59

        local first

        if v57 then
            first = p9.prices.first

            if first == nil then
                first = firstAquariumCratePriceRobux
            end
        end

        t21.priceOverride = first

        if v58 ~= nil then
            v58 = v58.productId
        end

        t21.productId = if v58 == nil then 0 else v58
        t21.showGift = false
        t21.size = UDim2.fromScale(0.96, 0.78)
        t21.zIndex = 10

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            LayoutOrder = p13,
            Size = UDim2.fromScale(0.32, 1),
            key = p13
        }, v63, react.createElement(default5, t21), react.createElement(default3, {
            shadowYScale = 0.055,
            color = getPurchaseCaptionColor(p13),
            overrideProps = {
                TextScaled = true,
                ZIndex = 14,
                Font = v22.textFont2,
                Position = UDim2.fromScale(0.06, 0.6),
                Size = UDim2.fromScale(0.88, 0.36),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.075
            },
            text = ("BUY %*"):format(p13)
        }))
    end

    for v64, v65 in t20 do
        v55[v64] = v56(v65, v64 - 1, t20)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    }, v35, v36, v37, v38, v53, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.825),
        Size = UDim2.fromScale(0.76, 0.175)
    }, v54, v55))
end

return {
    default = function(p14) -- AquariumCratePanel | line: 573
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), aquariumCrateHardPity (copy), getAquariumCrateProductForQuantity (copy), isAquariumCrateSeriesReleased (copy), robuxIconPrefix (copy), getRarityBorderColor (copy), getRarityColor (copy), rarityColors (copy), v3 (copy), v4 (copy), t1 (copy), v5 (copy), getOrderedAquariumCrateEntries (copy), t5 (copy), ExclusiveShopAquariumCratePanel (copy)
        local v66 = useTheme()

        if p14.variant == "exclusiveShop" then
            local v67 = table.clone(p14)

            setmetatable(v67, nil)

            return react.createElement(ExclusiveShopAquariumCratePanel, v67)
        end

        local v68 = p14.embeddedInShop == true
        local v69 = p14.pityCount >= aquariumCrateHardPity - 1
        local v70 = p14.showTitle ~= false
        local v71 = isAquariumCrateSeriesReleased(p14.series.id)
        local v72 = p14.purchasesDisabled == true or not p14.paidItemsAllowed or not v71
        local v73

        if v71 then
            if p14.purchasesDisabled then
            end

            v73 = "UNAVAILABLE"
        else
            v73 = "COMING SOON"
        end

        local v74, v75

        if v70 then
            v74 = if p14.compact then 0.22 else 0.2
            v75 = if p14.compact then 0.42 else 0.44
        else
            v74 = 0.08
            v75 = 0.51
        end

        local v77 = math.min(math.max(p14.pityCount, 0), aquariumCrateHardPity)
        local v78 = if v70 then 0.645 else 0.595
        local v79 = if v70 then 0.73 else 0.685
        local v80 = getOrderedAquariumCrateEntries(p14.series)
        local v81 = not v68

        if v81 then
            v81 = table.create(#t5)

            local function v82(p15, p16) -- line: 596
                -- upvalues: react (copy)
                return react.createElement("frame", {
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = p16 % 2 == 0 and 0.28 or 0.52,
                    Position = UDim2.fromScale(p15.X, p15.Y),
                    Size = UDim2.fromScale(p16 % 3 == 0 and 0.008 or 0.005, 0.012),
                    key = p16
                }, react.createElement("uicorner", {
                    CornerRadius = UDim.new(1, 0)
                }))
            end

            for v83, v84 in t5 do
                v81[v83] = v82(v84, v83 - 1, t5)
            end
        end

        local v85 = v70 and react.createElement(default3, {
            shadowYScale = 0.055,
            color = v4,
            overrideProps = {
                TextScaled = true,
                ZIndex = 8,
                Font = v66.textFont2,
                Position = if v68 then UDim2.fromScale(0.04, 0.015) else UDim2.fromScale(0.025, p14.compact and 0.015 or -0.015),
                Size = if v68 then UDim2.fromScale(0.7, 0.17) else UDim2.fromScale(0.95, p14.compact and 0.17 or 0.2),
                TextXAlignment = if v68 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.085
            },
            text = string.upper(p14.series.displayName)
        })
        local v86 = p14.showShardsButton ~= false and react.createElement(default2, {
            isShiny = true,
            isStudded = true,
            label = "SHARDS",
            zIndex = 7,
            anchorPoint = Vector2.new(1, 0),
            color = v5,
            disabled = p14.onShards == nil,
            font = v66.textFont2,
            frameSize = UDim2.fromScale(0.15, 0.12),
            onClick = function() -- onClick | line: 641
                -- upvalues: p14 (copy)
                local onShards = p14.onShards

                if onShards ~= nil then
                    onShards = onShards()
                end

                return onShards
            end,
            popoutColor = Color3.fromRGB(18, 66, 151),
            position = UDim2.fromScale(0.96, if v68 then 0.035 elseif v70 then 0.145 else 0.012),
            size = UDim2.fromScale(0.8, 0.8),
            strokeColor = Color3.fromRGB(5, 21, 58)
        })
        local v87 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.012, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v88 = table.create(#v80)

        local function v89(p17, p18) -- line: 663
            -- upvalues: v66 (copy), v69 (copy), react (copy), default3 (copy), getRarityBorderColor (copy), getRarityColor (copy), rarityColors (copy)
            local skin = p17.skin
            local v90 = getRarityColor(skin.rarity)
            local v91 = getRarityBorderColor(skin.rarity)
            local v92 = skin.rarity == "mythic"
            local v93 = if not v69 then p17.weightBasisPoints elseif v92 then 10000 else 0

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 3,
                LayoutOrder = p18,
                Size = UDim2.fromScale(0.23, 1),
                key = skin.name
            }, react.createElement(default3, {
                shadowYScale = 0.05,
                color = v90,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 7,
                    Font = v66.textFont2,
                    Position = UDim2.fromScale(0.08, 0),
                    Size = UDim2.fromScale(0.84, 0.19),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                text = ("%* %*"):format(string.upper(skin.rarity), (`{ v93 / 100 }%`))
            }), v92 and react.createElement("frame", {
                BackgroundTransparency = 0.67,
                BorderSizePixel = 0,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = rarityColors[skin.rarity],
                Position = UDim2.fromScale(0.5, 0.53),
                Size = UDim2.fromScale(0.94, 0.68)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.25, 0)
            }), react.createElement("uistroke", {
                Thickness = 0.025,
                Transparency = 0.15,
                Color = v91,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            })), react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = skin.imageId,
                Position = UDim2.fromScale(0.5, 0.52),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromScale(v92 and 1 or 0.88, 0.65)
            }), react.createElement(default3, {
                shadowYScale = 0.045,
                color = v90,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 7,
                    Font = v66.textFont4,
                    Position = UDim2.fromScale(0.02, 0.82),
                    Size = UDim2.fromScale(0.96, 0.16),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = {
                    Thickness = 0.06
                },
                text = skin.displayName
            }))
        end

        for v96, v97 in v80 do
            v88[v96] = v89(v97, v96 - 1, v80)
        end

        local v98 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            Position = UDim2.fromScale(0.025, v74),
            Size = UDim2.fromScale(0.95, v75)
        }, v87, v88)
        local v99 = react.createElement(default, {
            cornerRadius = 0.12,
            isStudded = true,
            isStuddedTransparency = 0.2,
            strokeThickness = 0.02,
            textureTransparency = 0.85,
            zIndex = 5,
            backgroundColor = Color3.fromRGB(17, 5, 32),
            position = UDim2.fromScale(0.17, v78),
            size = UDim2.fromScale(0.66, 0.06),
            strokeColor = Color3.fromRGB(10, 3, 24)
        }, react.createElement(default, {
            cornerRadius = 0.12,
            zIndex = 6,
            backgroundColor = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(103, 255, 37)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 78, 183))
            }),
            position = UDim2.fromScale(0, 0.1),
            size = UDim2.fromScale(v77 / aquariumCrateHardPity * 0.98, 0.8)
        }), react.createElement(default3, {
            shadowYScale = 0.04,
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v66.textFont2,
                Position = UDim2.fromScale(0.05, 0.05),
                Size = UDim2.fromScale(0.9, 0.9),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.05
            },
            text = ("PITY: %*/%*"):format(v77, aquariumCrateHardPity)
        }))
        local v100 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local t28 = {
            1, 3, 10
        }
        local v101 = table.create(#t28)

        local function v102(p19, p20) -- line: 781
            -- upvalues: p14 (copy), v66 (copy), v72 (copy), v73 (ref), react (copy), default2 (copy), default3 (copy), getAquariumCrateProductForQuantity (copy), robuxIconPrefix (copy), t1 (copy)
            local v103 = p19 == 1 and p14.hasPurchasedFirstCrate ~= true
            local v104 = getAquariumCrateProductForQuantity(p14.series.id, p19, v103)
            local v105 = if v103 then p14.prices.first
                elseif p19 == 1 then p14.prices.one
                elseif p19 == 3 then p14.prices.three
                else p14.prices.ten
            local v106 = v104 ~= nil and v104.productId > 0
            local v107 = v72 or not v106 or v105 == nil
            local v108 = if v72 then v73
                elseif not v106 then "COMING SOON"
                elseif v105 == nil then "LOADING"
                else ("%*%*"):format(robuxIconPrefix, v105)

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 5,
                LayoutOrder = p19,
                Size = UDim2.fromScale(0.31, 1),
                key = p19
            }, react.createElement(default2, {
                isStudded = true,
                zIndex = 6,
                anchorPoint = Vector2.new(0.5, 0),
                color = t1[p20 + 1],
                disabled = v107,
                font = v66.textFont2,
                frameSize = UDim2.fromScale(0.94, 0.68),
                isShiny = p19 == 10,
                label = v108,
                onClick = function() -- onClick | line: 803
                    -- upvalues: p19 (copy), p14 (copy)
                    return p14.onPurchase(p19)
                end,
                position = UDim2.fromScale(0.5, 0),
                size = UDim2.fromScale(0.9, 0.58),
                strokeColor = Color3.fromRGB(16, 5, 25)
            }), react.createElement(default3, {
                shadowYScale = 0.05,
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 7,
                    Font = v66.textFont2,
                    Position = UDim2.fromScale(0.08, 0.72),
                    Size = UDim2.fromScale(0.84, 0.24),
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = {
                    Thickness = 0.065
                },
                text = ("%* %*"):format(p19, p19 == 1 and "CRATE" or "CRATES")
            }))
        end

        for v110, v111 in t28 do
            v101[v110] = v102(v111, v110 - 1, t28)
        end

        return react.createElement(default, {
            cornerRadius = 0.045,
            strokeThickness = 0.012,
            textureTransparency = 0.72,
            backgroundColor = if v68 then Color3.fromRGB(255, 255, 255) else v3,
            isStudded = not v68,
            size = UDim2.fromScale(1, 1),
            strokeColor = if v68 then nil else Color3.fromRGB(10, 3, 24),
            transparency = v68 and 1 or 0
        }, v81, v85, v86, v98, v99, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            Position = UDim2.fromScale(0.035, v79),
            Size = UDim2.fromScale(0.93, 0.22)
        }, v100, v101), not v70 and react.createElement(default3, {
            shadowYScale = 0.04,
            color = Color3.fromRGB(255, 235, 100),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v66.textFont4,
                Position = UDim2.fromScale(0.15, 0.94),
                Size = UDim2.fromScale(0.7, 0.045),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.05
            },
            text = ("VOLCANIC SKIN GUARANTEED BY DRAW %*"):format(aquariumCrateHardPity)
        }))
    end
}

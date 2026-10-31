-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default6 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "long-shop-section").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumSkinShardRarities, aquariumSkinShardUpgradeSourceRarities, aquariumSkinMutationLuckSetBonus, getAquariumSkinShardExchangeRate = v1.aquariumSkinShardRarities, v1.aquariumSkinShardUpgradeSourceRarities, v1.aquariumSkinMutationLuckSetBonus, v1.getAquariumSkinShardExchangeRate
local getAquariumSkinShardUpgradeRate = v1.getAquariumSkinShardUpgradeRate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default7 = RuntimeLib.import(script, script.Parent, "aquarium-shard-exchange-card").default
local default8 = RuntimeLib.import(script, script.Parent, "aquarium-shop-skin-card").default
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(166, 95, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(76, 50, 222))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 229, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 128, 242))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(217, 84, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 48, 230))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 185, 54)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 98, 28))
})

local function AquariumShopSectionHeader(p1) -- line: 29
    -- upvalues: react (copy), default3 (copy), useTheme (copy)
    local v6 = useTheme()
    local v7 = if p1.subtitle == nil then 0.5 else 0.28
    local v8 = if p1.wideTitle == true then 0.131 else 0.22
    local v9 = if p1.wideTitle == true then 0.18 else 0.265
    local v10 = if p1.wideTitle == true then 0.82 else 0.735

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = p1.layoutOrder,
        Size = UDim2.fromScale(1, 0.19),
        ref = p1.frameRef
    }, react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.04, v7),
        Size = UDim2.fromScale(v8, 0.018)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uigradient", {
        Color = p1.color
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        Rotation = 45,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(v9, v7),
        Size = UDim2.fromScale(0.018, 0.065)
    }, react.createElement("uistroke", {
        Thickness = 0.1,
        Color = p1.decorationStrokeColor,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }), react.createElement("uigradient", {
        Color = p1.color
    })), react.createElement(default3, {
        shadowYScale = 0.06,
        color = p1.color,
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            Font = v6.textFont,
            Position = UDim2.fromScale(0.22, v7 - 0.2),
            Size = UDim2.fromScale(0.56, 0.4),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p1.title
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        Rotation = 45,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(v10, v7),
        Size = UDim2.fromScale(0.018, 0.065)
    }, react.createElement("uistroke", {
        Thickness = 0.1,
        Color = p1.decorationStrokeColor,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }), react.createElement("uigradient", {
        Color = p1.color
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.96, v7),
        Size = UDim2.fromScale(v8, 0.018)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uigradient", {
        Color = p1.color
    })), p1.subtitle ~= nil and react.createElement(default3, {
        shadowYScale = 0.04,
        color = Color3.fromRGB(235, 246, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            Font = v6.textFont,
            Position = UDim2.fromScale(0.06, 0.65),
            Size = UDim2.fromScale(0.88, 0.23),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = p1.subtitle
    }))
end

local function AquariumShopSummaryPanel(p2) -- line: 123
    -- upvalues: react (copy), default (copy), default3 (copy), aquariumSkinMutationLuckSetBonus (copy), images (copy)
    local t1 = {
        {
            label = "wild",
            amount = p2.universalShards,
            image = images.universalShard
        },
        {
            label = "rare",
            amount = p2.shardBalances.rare,
            image = images.rareShard
        },
        {
            label = "epic",
            amount = p2.shardBalances.epic,
            image = images.epicShard
        },
        {
            label = "legendary",
            amount = p2.shardBalances.legendary,
            image = images.legendaryShard
        },
        {
            label = "mythic",
            amount = p2.shardBalances.mythic,
            image = images.mythicShard
        }
    }
    local v11 = react.createElement(default3, {
        shadowYScale = 0.05,
        text = "YOUR SHARDS",
        color = Color3.fromRGB(106, 224, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 57,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.06, 0.035),
            Size = UDim2.fromScale(0.88, 0.09)
        },
        strokeProps = {
            Thickness = 0.065
        }
    })
    local v12 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.018, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v13 = table.create(#t1)

    local function v14(p3, p4) -- line: 168
        -- upvalues: react (copy), default3 (copy)
        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 57,
            LayoutOrder = p4,
            Size = UDim2.fromScale(1, 0.18),
            key = p3.label
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 58,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = p3.image,
            Position = UDim2.fromScale(0.15, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.27, 0.9)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        })), react.createElement(default3, {
            shadowYScale = 0.04,
            color = Color3.fromRGB(235, 247, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 58,
                Font = Enum.Font.FredokaOne,
                Position = UDim2.fromScale(0.45, 0.08),
                Size = UDim2.fromScale(0.48, 0.84),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.05
            },
            text = tostring(p3.amount)
        }))
    end

    for v16, v17 in t1 do
        v13[v16] = v14(v17, v16 - 1, t1)
    end

    return react.createElement(default, {
        cornerRadius = 0.055,
        isStudded = true,
        isStuddedTransparency = 0.2,
        strokeThickness = 0.025,
        textureTransparency = 0.82,
        zIndex = 55,
        anchorPoint = Vector2.new(0, 0),
        backgroundColor = Color3.fromRGB(8, 20, 37),
        position = UDim2.fromScale(1.01, 0.13),
        size = UDim2.fromScale(0.15, 0.66),
        strokeColor = Color3.fromRGB(75, 205, 255)
    }, v11, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 56,
        Position = UDim2.fromScale(0.08, 0.14),
        Size = UDim2.fromScale(0.84, 0.48)
    }, v12, v13), react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 57,
        BackgroundColor3 = Color3.fromRGB(71, 184, 233),
        Position = UDim2.fromScale(0.08, 0.65),
        Size = UDim2.fromScale(0.84, 0.006)
    }), react.createElement(default3, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 58,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.69),
            Size = UDim2.fromScale(0.84, 0.07)
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = ("SKINS %*/%*"):format(p2.ownedSkins, p2.totalSkins)
    }), react.createElement(default3, {
        color = Color3.fromRGB(118, 255, 126),
        overrideProps = {
            TextScaled = true,
            ZIndex = 58,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.78),
            Size = UDim2.fromScale(0.84, 0.07)
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = ("CASH +%*%%"):format((math.round(p2.cashBonus * 100)))
    }), react.createElement(default3, {
        color = Color3.fromRGB(255, 218, 83),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 58,
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.08, 0.86),
            Size = UDim2.fromScale(0.84, 0.1)
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = ("COMPLETE SET:\n+%*%% MUTATION LUCK"):format((math.round(aquariumSkinMutationLuckSetBonus * 100)))
    }))
end

local function AquariumShopNavRail(p5) -- line: 274
    -- upvalues: react (copy), default4 (copy)
    local v24 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.04, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local items = p5.items
    local v25 = table.create(#items)

    local function v26(p6, p7) -- line: 285
        -- upvalues: p5 (copy), react (copy), default4 (copy)
        local v27 = p5.activeSection == p6.section

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p7,
            Size = UDim2.fromScale(1, 0.22),
            ZIndex = 51 + p7,
            key = p6.section
        }, react.createElement(default4, {
            isStudded = true,
            color = p6.color,
            cornerRadius = v27 and 0.085 or 0.06,
            font = Enum.Font.FredokaOne,
            frameSize = UDim2.fromScale(v27 and 1.06 or 0.96, v27 and 1 or 0.9),
            isShiny = v27,
            label = p6.label,
            onClick = p6.onClick,
            popoutColor = if v27 then Color3.fromRGB(14, 34, 76) else Color3.fromRGB(28, 40, 76),
            size = UDim2.fromScale(0.82, 0.62),
            zIndex = 52 + p7
        }))
    end

    for v28, v29 in items do
        v25[v28] = v26(v29, v28 - 1, items)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 50,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(0.055, 0.37),
        Size = UDim2.fromScale(0.15, 0.4)
    }, v24, v25)
end

return {
    default = function(p8) -- AquariumShopWindow | line: 321
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), TweenService (copy), default2 (copy), default5 (copy), useTheme (copy), default6 (copy), aquariumSkinShardRarities (copy), aquariumSkinShardUpgradeSourceRarities (copy), getAquariumSkinShardExchangeRate (copy), getAquariumSkinShardUpgradeRate (copy), default7 (copy), default8 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), AquariumShopSectionHeader (copy), AquariumShopSummaryPanel (copy), AquariumShopNavRail (copy)
        local v30 = useTheme()
        local v31 = useRef(nil)
        local v32 = useRef(nil)
        local v33 = useRef(nil)
        local v34 = useRef(nil)
        local v35 = useRef(nil)
        local v36, v37 = useState(p8.initialSection or "crates")
        local skins = p8.skins
        local t9 = {}
        local n1 = 0

        for v38, v39 in skins do
            local _ = v38 - 1
            local ownedSkins = p8.ownedSkins
            local name = v39.name

            if table.find(ownedSkins, name) ~= nil == true then
                n1 += 1
                t9[n1] = v39
            end
        end

        local v40 = table.create(#t9)

        local function v41(p9) -- line: 347
            return p9.name
        end

        for v42, v43 in t9 do
            local _ = v42 - 1

            v40[v42] = v43.name
        end

        local skins2 = p8.skins
        local n2 = 0

        for i = 1, #skins2 do
            local v45 = skins2[i]
            local _ = i - 1
            local ownedSkins = p8.ownedSkins
            local name = v45.name

            if table.find(ownedSkins, name) ~= nil and v45.moneyBoost ~= nil then
                n2 += v45.moneyBoost
            end
        end

        local v46 = #p8.skins + 3
        local v47 = v46 + #aquariumSkinShardUpgradeSourceRarities + 1

        local function v48(p10) -- line: 377
            -- upvalues: v31 (copy), TweenService (copy)
            local current = v31.current

            if current == nil or p10 == nil then
                return nil
            end

            local v49 = current.AbsoluteWindowSize.Y * 0.025
            local v53 = math.clamp(p10.AbsolutePosition.Y - current.AbsolutePosition.Y + current.CanvasPosition.Y - v49, 0, (math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)))

            TweenService:Create(current, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, v53)
            }):Play()
        end

        useEffect(function() -- line: 390
            -- upvalues: p8 (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), v37 (copy), v48 (copy)
            local v54 = p8.initialSection or "crates"

            v37(v54)

            local v55 = task.defer(function() -- line: 393
                -- upvalues: v54 (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), v48 (copy)
                v48(if v54 == "crates" then v32.current
                    elseif v54 == "skins" then v33.current
                    elseif v54 == "wild" then v34.current
                    else v35.current)
            end)

            return function() -- line: 396
                -- upvalues: v55 (copy)
                return task.cancel(v55)
            end
        end, { p8.initialSection })

        local t14 = {
            {
                label = "CRATES",
                section = "crates",
                color = v2,
                onClick = function() -- onClick | line: 404
                    -- upvalues: v32 (copy), v37 (copy), v48 (copy)
                    v37("crates")
                    v48(v32.current)
                end
            },
            {
                label = "SKINS",
                section = "skins",
                color = v3,
                onClick = function() -- onClick | line: 412
                    -- upvalues: v33 (copy), v37 (copy), v48 (copy)
                    v37("skins")
                    v48(v33.current)
                end
            },
            {
                label = "SHARDS",
                section = "shards",
                color = v4,
                onClick = function() -- onClick | line: 420
                    -- upvalues: v35 (copy), v37 (copy), v48 (copy)
                    v37("shards")
                    v48(v35.current)
                end
            },
            {
                label = "WILD",
                section = "wild",
                color = v5,
                onClick = function() -- onClick | line: 428
                    -- upvalues: v34 (copy), v37 (copy), v48 (copy)
                    v37("wild")
                    v48(v34.current)
                end
            }
        }
        local v57 = math.max(#p8.crateContent, 1)
        local v58 = v57 * 0.84 + (v57 - 1) * 0.04
        local v59 = 0.84 / v58
        local v60 = 0.04 / v58
        local v61 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.28
        })
        local v62 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(v60, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local crateContent = p8.crateContent
        local v63 = table.create(#crateContent)

        local function v64(p11, p12) -- line: 455
            -- upvalues: v59 (copy), react (copy), default6 (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = p12,
                Size = UDim2.fromScale(1, v59),
                key = p12
            }, react.createElement(default6, {
                sectionType = "XLongRainbowSection",
                zIndex = 4,
                size = UDim2.fromScale(1, 1)
            }, react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.92, 0.86)
            }, p11)))
        end

        for v65, v66 in crateContent do
            v63[v65] = v64(v66, v65 - 1, crateContent)
        end

        local v67 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, v58),
            ref = v32
        }, v62, v63)
        local v68 = react.createElement(AquariumShopSectionHeader, {
            layoutOrder = 2,
            subtitle = "DUPLICATES GIVE WILD SHARDS",
            title = "AQUARIUM SKINS",
            color = v3,
            decorationStrokeColor = Color3.fromRGB(14, 77, 154),
            frameRef = v33
        })
        local skins3 = p8.skins
        local v69 = table.create(#skins3)

        local function v70(p13, p14) -- line: 497
            -- upvalues: p8 (copy), react (copy), default8 (copy)
            local t15 = {
                data = p13,
                key = p13.name,
                layoutOrder = 3 + p14,
                onPreview = p8.onPreviewSkin,
                onPurchase = p8.onExchangeSkin
            }
            local ownedSkins = p8.ownedSkins
            local name = p13.name

            t15.owned = table.find(ownedSkins, name) ~= nil
            t15.ownedRarityShards = p8.skinShardBalances[p13.shardRarity]

            return react.createElement(default8, t15)
        end

        for v71, v72 in skins3 do
            v69[v71] = v70(v72, v71 - 1, skins3)
        end

        local v73 = react.createElement(AquariumShopSectionHeader, {
            title = "SHARD EXCHANGE",
            color = v4,
            decorationStrokeColor = Color3.fromRGB(76, 25, 143),
            frameRef = v35,
            layoutOrder = v46
        })
        local v74 = table.create(#aquariumSkinShardUpgradeSourceRarities)

        local function v75(p15, p16) -- line: 524
            -- upvalues: p8 (copy), v46 (copy), react (copy), getAquariumSkinShardUpgradeRate (copy), default7 (copy)
            local v76 = getAquariumSkinShardUpgradeRate(p15)

            return react.createElement(default7, {
                key = p15,
                layoutOrder = v46 + p16 + 1,
                onCraft = function(p17) -- onCraft | line: 529
                    -- upvalues: p15 (copy), p8 (copy)
                    return p8.onUpgradeShards(p15, p17)
                end,
                source = p15,
                sourceBalance = p8.skinShardBalances[p15],
                sourceShardsPerCraft = v76.sourceShardsPerCraft,
                targetRarity = v76.targetRarity
            })
        end

        for v77, v78 in aquariumSkinShardUpgradeSourceRarities do
            v74[v77] = v75(v78, v77 - 1, aquariumSkinShardUpgradeSourceRarities)
        end

        local v79 = react.createElement(AquariumShopSectionHeader, {
            title = "WILD SHARD EXCHANGE",
            wideTitle = true,
            color = v5,
            decorationStrokeColor = Color3.fromRGB(132, 52, 10),
            frameRef = v34,
            layoutOrder = v47
        })
        local v80 = table.create(#aquariumSkinShardRarities)

        local function v81(p18, p19) -- line: 552
            -- upvalues: p8 (copy), v47 (copy), react (copy), getAquariumSkinShardExchangeRate (copy), default7 (copy)
            return react.createElement(default7, {
                source = "wild",
                key = p18,
                layoutOrder = v47 + p19 + 1,
                onCraft = function(p20) -- onCraft | line: 556
                    -- upvalues: p18 (copy), p8 (copy)
                    return p8.onCraftShards(p18, p20)
                end,
                sourceBalance = p8.universalShardBalance,
                sourceShardsPerCraft = getAquariumSkinShardExchangeRate(p18).universalShardsPerCraft,
                targetRarity = p18
            })
        end

        for v82, v83 in aquariumSkinShardRarities do
            v80[v82] = v81(v83, v82 - 1, aquariumSkinShardRarities)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.48, 0.5),
            Size = UDim2.fromScale(0.78, 0.82)
        }, v61, react.createElement(default2, {
            title = "AQUARIUM SHOP",
            bodyBg = Color3.fromRGB(8, 24, 48),
            headerBg = v30.colorSequences.blueGradient,
            onClose = p8.onClose,
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default5, {
            automaticCanvasSize = true,
            canvasHeightScale = 1,
            itemPaddingScale = 0.025,
            scrollBarThickness = 6,
            zIndex = 4,
            anchorPoint = Vector2.new(0.5, 1),
            padding = {
                bottom = UDim.new(0.025, 0),
                left = UDim.new(0.025, 0),
                right = UDim.new(0.025, 0),
                top = UDim.new(0.02, 0)
            },
            position = UDim2.fromScale(0.5, 0.97),
            scrollBarColor = Color3.fromRGB(66, 185, 239),
            scrollFrameRef = v31,
            size = UDim2.fromScale(0.94, 0.84)
        }, v67, v68, v69, v73, v74, v79, v80, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = v47 + #aquariumSkinShardRarities + 1,
            Size = UDim2.fromScale(1, 0.08)
        }))), react.createElement(AquariumShopSummaryPanel, {
            cashBonus = n2,
            ownedSkins = #v40,
            shardBalances = p8.skinShardBalances,
            totalSkins = #p8.skins,
            universalShards = p8.universalShardBalance
        }), react.createElement(AquariumShopNavRail, {
            activeSection = v36,
            items = t14
        }))
    end
}

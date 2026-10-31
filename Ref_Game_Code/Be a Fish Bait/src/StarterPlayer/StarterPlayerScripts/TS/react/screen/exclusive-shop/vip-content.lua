-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent, "exclusive-shop-purchase-buttons").default
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 20, 20))
})
local t1 = {
    "- x1.5 Mutation Luck",
    "- x1.5 Cash",
    "- Exclusive VIP Title/Tag",
    "- x1.5 Training Speed Area"
}
local t2 = {
    "- Increase your backpack size!",
    "- Max backpack size: 1000"
}

local function BackpackStyleProductContent(p1) -- line: 15
    -- upvalues: react (copy), useTheme (copy), default (copy), default2 (copy), v1 (copy)
    local v3 = useTheme()
    local iconDecoration = p1.iconDecoration
    local t3 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = p1.icon,
        Position = p1.iconPosition or UDim2.fromScale(0.025, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = p1.iconSize or UDim2.fromScale(0.36, 0.82)
    }
    local iconZIndex = p1.iconZIndex

    t3.ZIndex = if iconZIndex == nil then 4 else iconZIndex

    local v4 = react.createElement("imagelabel", t3, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }))
    local v5 = if p1.badgeText == nil then nil else react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.99, 0.02),
        Size = UDim2.fromScale(0.18, 0.17)
    }, react.createElement(default, {
        shadowYScale = 0.06,
        color = Color3.fromRGB(255, 35, 35),
        overrideProps = {
            TextScaled = true,
            ZIndex = 10,
            Font = v3.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        strokeProps = {
            Thickness = 0.08
        },
        text = p1.badgeText
    }))
    local v6 = react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1.2, 0.33)
    }, react.createElement(default, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0, 0.5),
        color = v1,
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            ZIndex = 10,
            Font = v3.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = p1.title
    }))
    local perks = p1.perks
    local v7 = table.create(#perks)

    local function v8(p2, p3) -- line: 82
        -- upvalues: p1 (copy), v3 (copy), react (copy), default (copy)
        local t4 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, p3 == 0 and 0.31 or 0.49)
        }
        local perkWidthScale = p1.perkWidthScale

        if perkWidthScale == nil then
            perkWidthScale = if p3 == 0 then 1.14 else 1
        end

        t4.Size = UDim2.fromScale(perkWidthScale, 0.19)
        t4.key = p2

        return react.createElement("frame", t4, react.createElement(default, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                TextWrapped = false,
                ZIndex = 4,
                Font = v3.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.5),
            strokeProps = {
                Thickness = 0.06
            },
            text = p2
        }))
    end

    for v9, v10 in perks do
        v7[v9] = v8(v10, v9 - 1, perks)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.94, 0.88)
    }, iconDecoration, v4, v5, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.3, 0.49),
        Size = UDim2.fromScale(0.39, 0.86)
    }, v6, v7), react.createElement(default2, {
        zIndex = 4,
        disabledLabel = p1.disabledLabel,
        infoType = p1.infoType,
        onBuy = p1.onBuy,
        onGift = p1.onGift,
        owned = p1.owned,
        position = UDim2.fromScale(0.99, 0.9),
        price = p1.price,
        productId = p1.productId,
        showGift = p1.showGift,
        size = UDim2.fromScale(0.29, 0.24)
    }))
end

local function BackpackCapacityContent(p4) -- line: 145
    -- upvalues: react (copy), images (copy), t2 (copy), BackpackStyleProductContent (copy)
    return react.createElement(BackpackStyleProductContent, {
        badgeText = "NEW!",
        title = "Backpack Upgrade",
        icon = images.backpackUpgradeIcon,
        infoType = Enum.InfoType.Product,
        onBuy = p4.onBuy,
        onGift = p4.onGift,
        perks = t2,
        price = p4.price,
        productId = p4.productId
    })
end

return {
    BackpackStyleProductContent = BackpackStyleProductContent,
    BackpackCapacityContent = BackpackCapacityContent,
    default = function(p5) -- VipContent | line: 158
        -- upvalues: react (copy), useTheme (copy), images (copy), default (copy), default2 (copy), v1 (copy), v2 (copy), t1 (copy)
        local v11 = useTheme()
        local v12 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = images.vipCrownIcon,
            Position = UDim2.fromScale(0.02, 0.55),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.32, 0.72)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local v13 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(0.99, 0.02),
            Size = UDim2.fromScale(0.32, 0.2)
        }, react.createElement(default, {
            shadowYScale = 0.06,
            text = "BEST SELLER!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v2,
            overrideProps = {
                TextScaled = true,
                ZIndex = 10,
                Font = v11.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            }
        }))
        local v14 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v15 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = -1,
            Size = UDim2.fromScale(0.9, 0.3)
        }, react.createElement(default, {
            shadowYScale = 0.06,
            text = "V.I.P",
            anchorPoint = Vector2.new(0, 0.5),
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 10,
                Font = v11.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.5),
            strokeProps = {
                Thickness = 0.08
            }
        }))
        local v16 = table.create(#t1)

        local function v17(p6, p7) -- line: 226
            -- upvalues: v11 (copy), react (copy), default (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = p7,
                Size = UDim2.fromScale(0.88, 0.16),
                key = tostring(p7)
            }, react.createElement(default, {
                shadowYScale = 0.05,
                anchorPoint = Vector2.new(0, 0.5),
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextSize = 18,
                    TextScaled = true,
                    ZIndex = 4,
                    Font = v11.textFont,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                position = UDim2.fromScale(0, 0.5),
                strokeProps = {
                    Thickness = 0.06
                },
                text = p6
            }))
        end

        for v18, v19 in t1 do
            v16[v18] = v17(v19, v18 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.94, 0.88)
        }, v12, v13, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.28, 0.49),
            Size = UDim2.fromScale(0.41, 0.86)
        }, v14, v15, v16), react.createElement(default2, {
            zIndex = 4,
            infoType = Enum.InfoType.GamePass,
            onBuy = p5.onBuy,
            onGift = p5.onGift,
            owned = p5.owned,
            position = UDim2.fromScale(0.99, 0.9),
            price = p5.price,
            productId = p5.productId,
            size = UDim2.fromScale(0.29, 0.24)
        }))
    end
}

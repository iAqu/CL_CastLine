-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default3 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "medium-shop-section").default
local default4 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "small-shop-section").default
local default5 = RuntimeLib.import(script, script.Parent, "celebration-shop-price-label").default
local default6 = RuntimeLib.import(script, script.Parent, "celebration-sunburst-glow").default
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "og-prime-title-effects").default
local default8 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "preview-icon-button").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 206, 54)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(222, 125, 18))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 205)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 205, 55)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 210)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(165, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 245, 185))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 128, 135)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(67, 70, 78))
})

local function getStateLabel(p1, p2) -- line: 24
    if p1 == "owned" then
        return "OWNED"
    end

    if p1 == "soldOut" then
        return "SOLD OUT"
    end

    if p1 == "limitReached" then
        if p2 then
            return "AVAILABLE TOMORROW"
        end

        return "OWNED"
    end

    if p1 == "insufficientFunds" or p1 == "available" then
        return nil
    end
end

local function ShopItemContent(p3) -- line: 43
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), useTheme (copy), default5 (copy), default6 (copy), getTitleData (copy), images (copy), default7 (copy), default8 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), getStateLabel (copy)
    local currency, icon, iconScale = p3.currency, p3.icon, p3.iconScale

    if iconScale == nil then
        iconScale = 1
    end

    local itemType, name, onBuy, onPreview = p3.itemType, p3.name, p3.onBuy, p3.onPreview
    local price, priceText, previewCharmId, productId = p3.price, p3.priceText, p3.previewCharmId, p3.productId
    local purchaseState = p3.purchaseState

    if purchaseState == nil then
        purchaseState = "available"
    end

    local resetsDaily = p3.resetsDaily

    if resetsDaily == nil then
        resetsDaily = false
    end

    local scrollFrameRef, sectionStyle = p3.scrollFrameRef, p3.sectionStyle

    if sectionStyle == nil then
        sectionStyle = "small"
    end

    local stockCurrent, stockMax, titleId = p3.stockCurrent, p3.stockMax, p3.titleId
    local v5 = useTheme()
    local v6 = sectionStyle == "medium"
    local v7 = currency == "robux"
    local v8 = purchaseState ~= "available"
    local v9 = getStateLabel(purchaseState, resetsDaily)
    local v10 = stockCurrent ~= nil and stockMax ~= nil
    local v11 = if titleId == nil then nil else getTitleData(titleId)

    if v11 ~= nil then
        name = "Player Title"
    end

    if v6 then
        iconScale = 1
    end

    local v12, v13 = useMotion(0)
    local v14 = useRef(nil)
    local v15, v16 = useState(false)

    useEffect(function() -- line: 86
        -- upvalues: scrollFrameRef (copy), v14 (copy), v16 (copy), v6 (copy), v7 (copy)
        if not (v6 and v7) then
            return nil
        end

        local current = v14.current
        local v17 = scrollFrameRef

        if scrollFrameRef ~= nil then
            v17 = scrollFrameRef.current
        end

        if current ~= nil and v17 ~= nil then
            local v18 = v17

            local function v19() -- line: 100
                -- upvalues: current (copy), v18 (copy), v16 (copy)
                local Y = v18.AbsolutePosition.Y
                local v20 = Y + v18.AbsoluteWindowSize.Y
                local Y2 = current.AbsolutePosition.Y
                local v21 = Y2 + current.AbsoluteSize.Y
                local v23 = math.max(2, v18.AbsoluteWindowSize.Y * 0.01)

                v16(Y + v23 <= Y2 and v21 <= v20 - v23)
            end

            local Y = v17.AbsolutePosition.Y
            local v25 = Y + v17.AbsoluteWindowSize.Y
            local Y2 = current.AbsolutePosition.Y
            local v26 = Y2 + current.AbsoluteSize.Y
            local v28 = math.max(2, v17.AbsoluteWindowSize.Y * 0.01)

            v16(Y + v28 <= Y2 and v26 <= v25 - v28)

            local t1 = {
                v17:GetPropertyChangedSignal("CanvasPosition"):Connect(v19),
                v17:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v19),
                current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v19),
                current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v19)
            }

            return function() -- line: 110
                -- upvalues: t1 (copy)
                local function v30(p4) -- line: 112
                    return p4:Disconnect()
                end

                for v31, v32 in t1 do
                    local _ = v31 - 1

                    v32:Disconnect()
                end

                return nil
            end
        end

        v16(true)

        return nil
    end, { v6, v7, scrollFrameRef })
    useEffect(function() -- line: 122
        -- upvalues: v11 (copy), v13 (copy), v7 (copy)
        local v34 = not v7

        if v34 then
            local v35 = v11

            if v11 ~= nil then
                v35 = v11.animatedColor
            end

            v34 = v35 == nil
        end

        if v34 then
            return nil
        end

        v13:linear(360, {
            speed = 45
        })

        return (v13:onComplete(function() -- line: 140
            -- upvalues: v13 (copy)
            v13:immediate(0)
            v13:linear(360, {
                speed = 45
            })
        end))
    end, {
        v13,
        v7,
        if v11 == nil then v11 else v11.animatedColor,
        if v11 == nil then v11 else v11.visualTier
    })

    local createElement = react.createElement
    local t2 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(v6 and 0.94 or 0.92, v6 and 0.92 or 0.9),
        ref = v14
    }
    local v39 = react.createElement(default, {
        shadowYScale = 0.055,
        anchorPoint = Vector2.new(0.5, 0),
        color = if v7 then v3 else Color3.new(1, 1, 1),
        gradientOffset = if v7 then v12:map(function(p5) -- line: 166
            return Vector2.new(math.sin((math.rad(p5))) * 0.35, 0)
        end) else nil,
        gradientRotation = v7 and -12 or 90,
        overrideProps = {
            TextScaled = true,
            ZIndex = 8,
            Font = v5.textFont2,
            Size = UDim2.fromScale(v6 and 0.94 or 0.9, v6 and 0.145 or 0.17),
            TextTruncate = Enum.TextTruncate.AtEnd
        },
        popoutColor = if v7 then Color3.fromRGB(80, 28, 72) else nil,
        position = UDim2.fromScale(0.5, 0.015),
        strokeProps = {
            Color = if v7 then Color3.fromRGB(70, 22, 66) else Color3.new(0, 0, 0),
            Thickness = v7 and 0.085 or 0.075
        },
        text = name
    })
    local v40 = if not v6 and itemType ~= nil then react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        TextStrokeTransparency = 0.25,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = v5.textFont,
        Position = UDim2.fromScale(0.5, 0.22),
        Size = UDim2.fromScale(0.5, 0.075),
        Text = string.upper(itemType),
        TextColor3 = Color3.fromRGB(255, 236, 164),
        TextTruncate = Enum.TextTruncate.AtEnd
    }) else nil
    local v41 = v6 and react.createElement(default6, {
        zIndex = 4,
        animated = v7,
        position = UDim2.fromScale(0.5, 0.48),
        size = UDim2.fromScale(0.7, 0.62),
        visible = not v7 or v15
    })
    local v42 = if v11 == nil then react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = icon,
        Position = UDim2.fromScale(0.5, if v6 then 0.48 else 0.49 - (iconScale - 1) * 0.25),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale((v6 and 0.56 or 0.68) * iconScale, (v6 and 0.46 or 0.5) * iconScale)
    }) else react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, v6 and 0.49 or 0.51),
        Size = UDim2.fromScale(v6 and 0.82 or 0.78, v6 and 0.27 or 0.25)
    }, react.createElement("uiscale", {
        Scale = v12:map(function(p6) -- line: 211
            -- upvalues: v11 (copy)
            return (if v11.visualTier == "premiumEvent" then math.sin((math.rad(p6))) * 0.025 else 0) + 1
        end)
    }), v11.visualTier == "premiumEvent" and react.createElement(react.Fragment, nil, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Rotation = -12,
        ZIndex = 9,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.eventIcon,
        Position = UDim2.fromScale(0.08, 0.47),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.13, 0.72)
    }), react.createElement(default7, {
        zIndex = 9,
        animationProgress = v12
    })), react.createElement(default, {
        gradientRotation = 0,
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v11.animatedColor or v11.color,
        gradientOffset = v12:map(function(p7) -- line: 229
            return Vector2.new(math.sin((math.rad(p7))) * 0.22, 0)
        end),
        overrideProps = {
            TextScaled = true,
            ZIndex = 8,
            Font = Enum.Font.GothamBlack,
            Size = UDim2.fromScale(v11.visualTier == "premiumEvent" and 0.78 or 0.9, 0.7),
            TextTruncate = Enum.TextTruncate.AtEnd
        },
        position = UDim2.fromScale(v11.visualTier == "premiumEvent" and 0.54 or 0.5, 0.47),
        strokeProps = {
            Thickness = 0.09
        },
        text = v11.displayName
    }))

    v10 = v10 and react.createElement("frame", {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(95, 54, 12),
        Position = UDim2.fromScale(0.965, v6 and 0.66 or 0.235),
        Size = UDim2.fromScale(v6 and 0.23 or 0.18, v6 and 0.105 or 0.08)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.22, 0)
    }), react.createElement("uistroke", {
        Thickness = 1.5,
        Transparency = 0.08,
        Color = Color3.fromRGB(255, 225, 126)
    }), react.createElement(default, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 11,
            Font = v5.textFont,
            Size = UDim2.fromScale(0.82, 0.72)
        },
        position = UDim2.fromScale(0.5, 0.46),
        strokeProps = {
            Thickness = 0.07
        },
        text = ("%*/%*"):format(stockCurrent, stockMax)
    }))

    return createElement("frame", t2, v39, v40, v41, v42, v10, react.createElement(default2, {
        cornerRadius = 0.12,
        zIndex = 9,
        anchorPoint = Vector2.new(0.5, 1),
        color = if v8 then v4 elseif v7 then v2 else v1,
        disabled = v8,
        frameSize = UDim2.fromScale(0.9, v6 and 0.18 or 0.2),
        label = v9 or "",
        onClick = onBuy,
        popoutColor = if v8 then Color3.fromRGB(50, 53, 60) elseif v7 then Color3.fromRGB(135, 72, 8) else Color3.fromRGB(10, 120, 10),
        position = UDim2.fromScale(0.5, 0.94)
    }, if v9 == nil then react.createElement(default5, {
        zIndex = 13,
        currency = currency,
        muted = v8,
        price = price,
        priceText = priceText,
        productId = productId
    }) else nil), previewCharmId ~= nil and onPreview ~= nil and react.createElement(default8, {
        zIndex = 12,
        anchorPoint = Vector2.new(0, 0.5),
        onClick = onPreview,
        position = UDim2.fromScale(0.05, 0.64)
    }))
end

return {
    default = function(p8) -- CelebrationEventShopItem | line: 307
        -- upvalues: react (copy), default3 (copy), default4 (copy), ShopItemContent (copy)
        local v49 = table.clone(p8)

        setmetatable(v49, nil)

        local v50 = react.createElement(ShopItemContent, v49)

        if p8.sectionStyle == "medium" then
            return (react.createElement(default3, {
                sectionType = "MediumYellowSection",
                zIndex = 3,
                layoutOrder = p8.layoutOrder,
                size = p8.size or UDim2.fromScale(1, 1)
            }, v50))
        end

        return (react.createElement(default4, {
            sectionType = "SmallYellowSection",
            zIndex = 3,
            layoutOrder = p8.layoutOrder,
            size = p8.size or UDim2.fromScale(1, 1)
        }, v50))
    end
}

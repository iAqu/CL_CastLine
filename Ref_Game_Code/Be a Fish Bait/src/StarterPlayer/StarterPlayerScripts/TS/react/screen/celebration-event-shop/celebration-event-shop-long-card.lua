-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default3 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "long-shop-section").default
local default4 = RuntimeLib.import(script, script.Parent, "celebration-shop-price-label").default
local default5 = RuntimeLib.import(script, script.Parent, "celebration-sunburst-glow").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 134, 143)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 69, 78))
})

local function getDisabledLabel(p1, p2) -- line: 17
    if p1 == "owned" then
        return "OWNED"
    end

    if p1 == "soldOut" then
        return "SOLD OUT"
    end

    if p1 ~= "limitReached" then
        return nil
    end

    if p2 then
        return "AVAILABLE TOMORROW"
    end

    return "OWNED"
end

return {
    default = function(p3) -- CelebrationEventShopLongCard | line: 34
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), default (copy), default2 (copy), useTheme (copy), default3 (copy), default4 (copy), default5 (copy), v1 (copy), v2 (copy), getDisabledLabel (copy)
        local comingSoon = p3.comingSoon

        if comingSoon == nil then
            comingSoon = false
        end

        local item, layoutOrder, onBuy, sectionType = p3.item, p3.layoutOrder, p3.onBuy, p3.sectionType
        local silhouette = p3.silhouette

        if silhouette == nil then
            silhouette = false
        end

        local scrollFrameRef = p3.scrollFrameRef
        local v3 = useTheme()
        local v4 = useRef(nil)
        local v5, v6 = useState(item.animatedIconGlow == true)
        local purchaseState, resetsDaily = item.purchaseState, item.resetsDaily

        if resetsDaily == nil then
            resetsDaily = false
        end

        local v7 = getDisabledLabel(purchaseState, resetsDaily)
        local v8 = comingSoon or item.purchaseState ~= nil and item.purchaseState ~= "available"
        local iconScale = item.iconScale

        if iconScale == nil then
            iconScale = 1
        end

        local iconPositionX = item.iconPositionX

        if iconPositionX == nil then
            iconPositionX = math.max(0.2, 0.16 * iconScale)
        end

        useEffect(function() -- line: 68
            -- upvalues: item (copy), scrollFrameRef (copy), v4 (copy), v6 (copy), RunService (copy)
            if item.animatedIconGlow ~= true then
                return nil
            end

            local current = v4.current
            local v10 = scrollFrameRef

            if scrollFrameRef ~= nil then
                v10 = scrollFrameRef.current
            end

            if current ~= nil and v10 ~= nil then
                local v11 = v10

                local function v12() -- line: 82
                    -- upvalues: current (copy), v11 (copy), v6 (copy)
                    if v11.AbsoluteWindowSize.Y <= 0 or current.AbsoluteSize.Y <= 0 then
                        return nil
                    end

                    local Y = v11.AbsolutePosition.Y
                    local v13 = Y + v11.AbsoluteWindowSize.Y
                    local Y2 = current.AbsolutePosition.Y
                    local v14 = Y2 + current.AbsoluteSize.Y
                    local v16 = math.max(2, v11.AbsoluteWindowSize.Y * 0.01)
                    local v18 = math.max(Y2, Y + v16)

                    v6(math.max(0, math.min(v14, v13 - v16) - v18) >= current.AbsoluteSize.Y * 0.5)
                end

                local t1 = {
                    RunService.Heartbeat:Once(v12),
                    v10:GetPropertyChangedSignal("CanvasPosition"):Connect(v12),
                    v10:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v12),
                    current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v12),
                    current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v12)
                }

                return function() -- line: 100
                    -- upvalues: t1 (copy)
                    local function v22(p4) -- line: 102
                        return p4:Disconnect()
                    end

                    for v23, v24 in t1 do
                        local _ = v23 - 1

                        v24:Disconnect()
                    end

                    return nil
                end
            end

            v6(true)

            return nil
        end, {
            item.animatedIconGlow,
            scrollFrameRef
        })

        local v25 = item.animatedIconGlow == true and react.createElement(default5, {
            animated = true,
            zIndex = 4,
            position = UDim2.fromScale(iconPositionX, 0.5),
            size = UDim2.fromScale(0.38 * iconScale, 0.82 * iconScale),
            visible = v5
        })
        local v26 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = item.icon,
            ImageColor3 = if silhouette then Color3.fromRGB(18, 20, 28) else Color3.new(1, 1, 1),
            ImageTransparency = silhouette and 0.08 or 0,
            Position = UDim2.fromScale(iconPositionX, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.32 * iconScale, 0.78 * iconScale),
            ZIndex = item.animatedIconGlow == true and 7 or 5
        })
        local v27 = not comingSoon and item.showStock == true and item.stockCurrent ~= nil and item.stockMax ~= nil and react.createElement("frame", {
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            ZIndex = 9,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(95, 54, 12),
            Position = UDim2.fromScale(0.69, 0.795),
            Size = UDim2.fromScale(0.14, 0.11)
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
                ZIndex = 10,
                Font = v3.textFont,
                Size = UDim2.fromScale(0.82, 0.72)
            },
            position = UDim2.fromScale(0.5, 0.46),
            strokeProps = {
                Thickness = 0.07
            },
            text = ("%*/%*"):format(item.stockCurrent, item.stockMax)
        }))
        local v28 = react.createElement(default, {
            shadowYScale = 0.055,
            anchorPoint = Vector2.new(0, 0),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v3.textFont2,
                Size = UDim2.fromScale(0.58, 0.24),
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0.37, 0.12),
            strokeProps = {
                Thickness = 0.075
            },
            text = item.name
        })
        local t3 = {
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.fromRGB(255, 238, 166),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 6,
                Font = v3.textFont,
                RichText = item.descriptionRichText ~= nil,
                Size = UDim2.fromScale(0.58, 0.22),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0.38, 0.52),
            shadowText = if comingSoon then "COMING SOON" else item.description,
            strokeProps = {
                Thickness = 0.06
            }
        }
        local descriptionRichText

        if comingSoon then
            descriptionRichText = "COMING SOON"
        else
            descriptionRichText = item.descriptionRichText

            if descriptionRichText == nil then
                descriptionRichText = item.description

                if descriptionRichText == nil then
                    descriptionRichText = item.itemType

                    if descriptionRichText ~= nil then
                        descriptionRichText = string.upper(descriptionRichText)
                    end

                    if descriptionRichText == nil then
                        descriptionRichText = "EVENT REWARD"
                    end
                end
            end
        end

        t3.text = descriptionRichText

        local createElement2 = react.createElement
        local t4 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            LayoutOrder = layoutOrder,
            Size = UDim2.fromScale(0.974, 0.44),
            ref = v4
        }
        local createElement3 = react.createElement
        local t5 = {
            zIndex = 3,
            sectionType = sectionType,
            size = UDim2.fromScale(1, 1)
        }
        local createElement4 = react.createElement
        local t6 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.94, 0.88)
        }
        local v29 = react.createElement(default, t3)
        local v30 = not comingSoon

        v30 = v30 and react.createElement(default2, {
            cornerRadius = 0.12,
            zIndex = 7,
            anchorPoint = Vector2.new(1, 1),
            color = if v8 then v2 else v1,
            disabled = v8,
            frameSize = UDim2.fromScale(0.25, 0.23),
            label = v7 or "",
            onClick = function() -- onClick | line: 241
                -- upvalues: item (copy), onBuy (copy)
                local v31 = onBuy

                if onBuy ~= nil then
                    v31 = onBuy(item.id)
                end

                return v31
            end,
            popoutColor = if v8 then Color3.fromRGB(55, 58, 66) else Color3.fromRGB(10, 120, 10),
            position = UDim2.fromScale(0.97, 0.91)
        }, if not v8 or item.purchaseState == "insufficientFunds" then react.createElement(default4, {
            zIndex = 11,
            currency = item.currency,
            muted = v8,
            price = item.price,
            priceText = item.priceText,
            productId = item.productId
        }) else nil)

        return createElement2("frame", t4, createElement3(default3, t5, createElement4("frame", t6, v25, v26, v27, v28, v29, v30)))
    end
}

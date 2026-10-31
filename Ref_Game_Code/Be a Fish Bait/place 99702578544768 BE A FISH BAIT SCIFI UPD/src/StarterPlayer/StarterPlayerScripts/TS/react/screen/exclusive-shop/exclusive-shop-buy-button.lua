-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 130, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 90))
})

return {
    default = function(p1) -- ExclusiveShopBuyButton | line: 15
        -- upvalues: react (copy), useTheme (copy), images (copy), default (copy), default2 (copy), useProductPrice (copy), useFreePurchaseModeEnabled (copy), v1 (copy), v2 (copy)
        local v3 = useTheme()
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 4
        end

        local v4 = p1.owned == true
        local v5 = p1.infoType == Enum.InfoType.GamePass
        local v6 = useFreePurchaseModeEnabled() and not v5
        local v7 = useProductPrice(p1.productId, p1.infoType or Enum.InfoType.Product)
        local priceOverride = p1.priceOverride

        if priceOverride ~= nil then
            v7 = priceOverride
        elseif v7 == nil then
            v7 = p1.price
        end

        local v8

        if v4 then
            local t1 = {
                anchorPoint = Vector2.new(0.5, 0.5),
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    Font = v3.textFont2,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = zIndex + 4
                },
                position = UDim2.fromScale(0.5, 0.5),
                strokeProps = {
                    Thickness = 0.05
                }
            }
            local disabledLabel = p1.disabledLabel

            t1.text = if disabledLabel == nil then "Owned" else disabledLabel
            v8 = react.createElement(default, t1)
        else
            local t2, labelOverride

            if p1.labelOverride ~= nil or v6 then
                t2 = {}
                t2.anchorPoint = Vector2.new(0.5, 0.5)
                t2.color = Color3.new(1, 1, 1)
                t2.overrideProps = {
                    TextScaled = true,
                    Font = v3.textFont2,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = zIndex + 4
                }
                t2.position = UDim2.fromScale(0.5, 0.5)
                t2.strokeProps = {
                    Thickness = 0.05
                }
                labelOverride = p1.labelOverride

                if labelOverride == nil then
                    labelOverride = "FREE"
                end

                t2.text = labelOverride
                v8 = react.createElement(default, t2)
            else
                v8 = react.createElement(react.Fragment, nil, react.createElement("uilistlayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0.01, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                }), react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 0,
                    Image = images.robuxIcon,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(0.36, 1),
                    ZIndex = zIndex + 4
                }, react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Height
                })), react.createElement(default, {
                    anchorPoint = Vector2.new(0, 0.5),
                    color = Color3.new(1, 1, 1),
                    overrideProps = {
                        LayoutOrder = 1,
                        TextScaled = true,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Font = v3.textFont,
                        Size = UDim2.fromScale(0, 1),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = zIndex + 4
                    },
                    position = UDim2.fromScale(0, 0.5),
                    strokeProps = {
                        Thickness = 0.05
                    },
                    text = tostring(v7)
                }))
            end
        end

        local createElement = react.createElement
        local t5 = {
            label = ""
        }

        t5.anchorPoint = p1.anchorPoint or Vector2.new(1, 1)
        t5.color = if v4 then v2 else p1.color or v1
        t5.frameSize = p1.frameSize
        t5.layoutOrder = p1.layoutOrder

        if v4 then
            t5.onClick = function() -- line: 128
            end

            t5.popoutColor = Color3.fromRGB(60, 60, 60)
        else
            t5.onClick = p1.onClick
            t5.popoutColor = p1.popoutColor or Color3.fromRGB(10, 120, 10)
        end

        t5.position = p1.position
        t5.zIndex = zIndex

        return createElement(default2, t5, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.92, 0.78),
            ZIndex = zIndex + 4
        }, v8))
    end
}

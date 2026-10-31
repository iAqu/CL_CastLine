-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "exclusive-shop-buy-button").default
local default2 = RuntimeLib.import(script, script.Parent, "exclusive-shop-gift-button").default

return {
    default = function(p1) -- ExclusiveShopPurchaseButtons | line: 6
        -- upvalues: react (copy), default (copy), default2 (copy)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 4
        end

        local showGift = p1.showGift

        if showGift == nil then
            showGift = true
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint or Vector2.new(1, 1),
            Position = p1.position,
            Size = p1.size,
            ZIndex = zIndex
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0.035, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), if showGift then react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            Size = UDim2.fromScale(0.25, 1),
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            frameSize = UDim2.fromScale(1, 1),
            onClick = p1.onGift,
            position = UDim2.fromScale(0.5, 0.5),
            zIndex = zIndex
        })) else nil, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            Size = UDim2.fromScale(showGift and 0.715 or 1, 1),
            ZIndex = zIndex
        }, react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = p1.color,
            disabledLabel = p1.disabledLabel,
            frameSize = UDim2.fromScale(1, 1),
            infoType = p1.infoType,
            labelOverride = p1.labelOverride,
            onClick = p1.onBuy,
            owned = p1.owned,
            popoutColor = p1.popoutColor,
            position = UDim2.fromScale(0.5, 0.5),
            price = p1.price,
            priceOverride = p1.priceOverride,
            productId = p1.productId,
            zIndex = zIndex
        })))
    end
}

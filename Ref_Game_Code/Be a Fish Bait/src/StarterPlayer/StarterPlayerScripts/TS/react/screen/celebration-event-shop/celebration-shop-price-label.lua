-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled

return {
    default = function(p1) -- CelebrationShopPriceLabel | line: 9
        -- upvalues: react (copy), default (copy), useTheme (copy), images (copy), useProductPrice (copy), useFreePurchaseModeEnabled (copy)
        local currency, muted = p1.currency, p1.muted

        if muted == nil then
            muted = false
        end

        local price, priceText, productId, zIndex = p1.price, p1.priceText, p1.productId, p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v1 = useTheme()
        local v2 = useFreePurchaseModeEnabled() and currency == "robux"

        if currency ~= "robux" then
            productId = nil
        end

        local v3 = useProductPrice(productId, Enum.InfoType.Product)

        if v3 ~= nil then
            price = v3
        end

        local v4 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.035, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v5 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Image = if currency == "robux" then images.robuxIcon else images.celebrationTicket,
            ImageColor3 = if muted then Color3.fromRGB(180, 180, 180) else Color3.new(1, 1, 1),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.3, 1),
            ZIndex = zIndex + 1
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }))
        local t2 = {
            anchorPoint = Vector2.new(0, 0.5),
            color = if muted then Color3.fromRGB(205, 205, 205) else Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                AutomaticSize = Enum.AutomaticSize.X,
                Font = v1.textFont,
                Size = UDim2.fromScale(0, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = zIndex + 1
            },
            position = UDim2.fromScale(0, 0.5),
            strokeProps = {
                Thickness = 0.05
            },
            text = if v2 then "FREE" elseif priceText == nil then tostring(price) else priceText
        }

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.82, 0.7),
            ZIndex = zIndex
        }, v4, v5, react.createElement(default, t2))
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent, "celebration-event-shop-item").default

return {
    default = function(p1) -- CelebrationEventShopCosmeticPair | line: 6
        -- upvalues: react (copy), images (copy), default (copy)
        local layoutOrder, onBuyItem, onBuyPremium, onPreviewCharm = p1.layoutOrder, p1.onBuyItem, p1.onBuyPremium, p1.onPreviewCharm
        local premium, scrollFrameRef, standard = p1.premium, p1.scrollFrameRef, p1.standard
        local previewCharmId = standard.previewCharmId
        local previewCharmId2 = premium.previewCharmId
        local v1 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.012, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v2 = table.clone(standard)

        setmetatable(v2, nil)
        v2.layoutOrder = 1

        v2.onBuy = function() -- line: 26
            -- upvalues: onBuyItem (copy), standard (copy)
            return onBuyItem(standard.id)
        end

        if previewCharmId ~= nil then
            v2.onPreview = function() -- line: 29
                -- upvalues: onPreviewCharm (copy), previewCharmId (copy)
                return onPreviewCharm(previewCharmId)
            end
        else
            v2.onPreview = nil
        end

        v2.scrollFrameRef = scrollFrameRef
        v2.sectionStyle = "medium"
        v2.size = UDim2.fromScale(0.445, 1)

        local v3 = react.createElement(default, v2)
        local v4 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 9,
            Size = UDim2.fromScale(0.06, 0.25)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Rotation = 90,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.arrowBeam,
            ImageColor3 = Color3.fromRGB(255, 213, 76),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.1, 0.72)
        }))
        local v5 = table.clone(premium)

        setmetatable(v5, nil)
        v5.layoutOrder = 3

        v5.onBuy = function() -- line: 56
            -- upvalues: onBuyPremium (copy), premium (copy)
            return onBuyPremium(premium.id)
        end

        if previewCharmId2 ~= nil then
            v5.onPreview = function() -- line: 59
                -- upvalues: onPreviewCharm (copy), previewCharmId2 (copy)
                return onPreviewCharm(previewCharmId2)
            end
        else
            v5.onPreview = nil
        end

        v5.scrollFrameRef = scrollFrameRef
        v5.sectionStyle = "medium"
        v5.size = UDim2.fromScale(0.445, 1)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder,
            Size = UDim2.fromScale(1, 0.49)
        }, v1, v3, v4, react.createElement(default, v5))
    end
}

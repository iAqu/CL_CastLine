-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local starterPackProductId, vipGamepassProductId, powerTrainingGamepassProductId, cashGamepassProductId = v1.starterPackProductId, v1.vipGamepassProductId, v1.powerTrainingGamepassProductId, v1.cashGamepassProductId
local fishLuckGamepassProductId, mutationLuckGamepassProductId, extraAquariumFishGamepassProductId, timeSkip5MinProductId = v1.fishLuckGamepassProductId, v1.mutationLuckGamepassProductId, v1.extraAquariumFishGamepassProductId, v1.timeSkip5MinProductId
local timeSkip30MinProductId, volcanicAquariumSkinProductId = v1.timeSkip30MinProductId, v1.volcanicAquariumSkinProductId
local t1 = {
    {
        name = "Starter Pack",
        icon = images.starterPackFeatured,
        productId = starterPackProductId
    },
    {
        name = "VIP",
        icon = images.vipCrownIcon,
        productId = vipGamepassProductId
    },
    {
        name = "Volcanic Aquarium Skin",
        icon = images.volcanicAquariumSkin,
        productId = volcanicAquariumSkinProductId
    },
    {
        name = "+1 Fish In Aquarium",
        icon = images.fishPlusOneIcon,
        productId = extraAquariumFishGamepassProductId
    },
    {
        name = "x2 Power",
        icon = images.strongArmIcon,
        productId = powerTrainingGamepassProductId
    },
    {
        name = "x2 Cash",
        icon = images.cashPile,
        productId = cashGamepassProductId
    },
    {
        name = "x2 Boss Fish Luck",
        icon = images.bossFishIcon,
        productId = fishLuckGamepassProductId
    },
    {
        name = "x2 Mutation Luck",
        icon = images.serverLuckCloverIcon,
        productId = mutationLuckGamepassProductId
    },
    {
        name = "5m Time Skip",
        icon = images.timeSkipIcon,
        productId = timeSkip5MinProductId
    },
    {
        name = "30m Time Skip",
        icon = images.timeSkipBundleIcon,
        productId = timeSkip30MinProductId
    }
}

local function NotificationCard(p1) -- line: 58
    -- upvalues: react (copy)
    local product = p1.product

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Size = UDim2.new(1, 0, 0, 90)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.fromOffset(74, 74)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = product.icon,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.82, 0.82)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(92, 0),
        Size = UDim2.new(1, -170, 1, 0)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Text = "Get stronger now!",
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 22),
        TextColor3 = Color3.fromRGB(255, 210, 60),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 18),
        Text = ("Buy %*"):format(product.name),
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 14),
        Text = ("ID: %*"):format(product.productId),
        TextColor3 = Color3.fromRGB(110, 110, 110),
        TextXAlignment = Enum.TextXAlignment.Left
    })), react.createElement("frame", {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(50, 180, 50),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(64, 30)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "Buy",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.9, 0.8),
        TextColor3 = Color3.new(1, 1, 1)
    })))
end

local function ExclusiveStoreNotificationStory() -- line: 141
    -- upvalues: react (copy), t1 (copy), NotificationCard (copy)
    local v2 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "Exclusive Store Notifications — all prompts",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(0, 10),
        Size = UDim2.new(1, 0, 0, 28),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    local v3 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8)
    })
    local v4 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v5 = table.create(#t1)

    local function v6(p2) -- line: 166
        -- upvalues: react (copy), NotificationCard (copy)
        return react.createElement(NotificationCard, {
            key = p2.name,
            product = p2
        })
    end

    for v7, v8 in t1 do
        local _ = v7 - 1

        v5[v7] = react.createElement(NotificationCard, {
            key = v8.name,
            product = v8
        })
    end

    return react.createElement("frame", {
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        Size = UDim2.fromScale(1, 1)
    }, v2, react.createElement("scrollingframe", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        AnchorPoint = Vector2.new(0.5, 1),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, 0, 1, -50)
    }, v3, v4, v5))
end

return storyForScreenGui(react.createElement(ExclusiveStoreNotificationStory), {
    disableOtherScreenGuis = true
})

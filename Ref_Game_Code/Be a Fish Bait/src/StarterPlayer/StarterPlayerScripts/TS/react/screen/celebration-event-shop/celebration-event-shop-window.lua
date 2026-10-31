-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRef = react.useRef
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "ticket-counter-badge").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local commify = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").commify
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local celebrationEventShopEndTimestamp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").celebrationEventShopEndTimestamp
local default6 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-cosmetic-pair").default
local default7 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-item").default
local default8 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-long-card").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 75, 85)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 176, 46)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 226, 72)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(54, 221, 116)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(62, 154, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(191, 85, 255))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 53, 76)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 27, 42))
})

local function formatEventCountdown(p1) -- line: 22
    local v4 = math.max(0, (math.floor(p1)))
    local v6 = math.floor(v4 / 86400)
    local v8 = math.floor(v4 % 86400 / 3600)
    local v10 = math.floor(v4 % 3600 / 60)
    local v11 = v4 % 60
    local v12 = string.format("%02d:%02d:%02d", v8, v10, v11)

    if v6 > 0 then
        return (("%*D %*"):format(v6, v12))
    end

    return v12
end

local function ShopHeaderNode(p2) -- line: 31
    -- upvalues: react (copy), default3 (copy), default4 (copy), default5 (copy), useTheme (copy), commify (copy), images (copy), celebrationEventShopEndTimestamp (copy), formatEventCountdown (copy)
    local eventName, ticketCount = p2.eventName, p2.ticketCount
    local v13 = useTheme()
    local v14 = default5(celebrationEventShopEndTimestamp).secondsLeft:map(function(p3) -- line: 37
        -- upvalues: formatEventCountdown (copy)
        if p3 > 0 then
            return (("ENDS IN: %*"):format((formatEventCountdown(p3))))
        end

        return "EVENT ENDED"
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromScale(0.04, 0.08),
        Size = UDim2.fromScale(0.58, 0.55)
    }, react.createElement(default3, {
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 23,
            Font = v13.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.05
        },
        text = eventName
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        TextStrokeTransparency = 0.15,
        ZIndex = 23,
        Font = v13.textFont2,
        Position = UDim2.fromScale(0.04, 0.65),
        Size = UDim2.fromScale(0.58, 0.24),
        Text = v14,
        TextColor3 = Color3.fromRGB(255, 246, 164),
        TextStrokeColor3 = Color3.fromRGB(75, 36, 20),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement(default4, {
        width = 0.17,
        icon = images.celebrationTicket,
        position = UDim2.fromScale(0.67, 0.5),
        text = commify(ticketCount)
    }))
end

local function RewardRow(p4) -- line: 83
    -- upvalues: react (copy), default7 (copy)
    local items, layoutOrder, onBuyItem = p4.items, p4.layoutOrder, p4.onBuyItem
    local v15 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.022, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v16 = table.create(#items)

    local function v17(p5, p6) -- line: 96
        -- upvalues: onBuyItem (copy), react (copy), default7 (copy)
        local v18 = table.clone(p5)

        setmetatable(v18, nil)
        v18.key = p5.id
        v18.layoutOrder = p6

        v18.onBuy = function() -- line: 101
            -- upvalues: p5 (copy), onBuyItem (copy)
            return onBuyItem(p5.id)
        end

        v18.sectionStyle = "small"
        v18.size = UDim2.fromScale(0.31, 1)

        return react.createElement(default7, v18)
    end

    for v19, v20 in items do
        v16[v19] = v17(v20, v19 - 1, items)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 0.43)
    }, v15, v16)
end

return {
    default = function(p7) -- CelebrationEventShopWindow | line: 119
        -- upvalues: react (copy), useRef (copy), default (copy), default2 (copy), useScreenSizeState (copy), default6 (copy), default8 (copy), v1 (copy), v2 (copy), ShopHeaderNode (copy), RewardRow (copy)
        local v21 = useRef(nil)
        local v22 = useScreenSizeState()
        local v23 = v22 == "sm"
        local t1 = {}
        local v24 = #t1
        local cosmeticPairs = p7.cosmeticPairs

        table.move(cosmeticPairs, 1, #cosmeticPairs, v24 + 1, t1)
        table.sort(t1, function(p8, p9) -- line: 129
            return p8.standard.price < p9.standard.price
        end)

        local v26 = math.ceil(#p7.items / 3)
        local v27 = #p7.featuredItems + #p7.cosmeticPairs + v26 + #p7.comingSoonItems
        local v30 = #p7.featuredItems * 0.44 + #p7.cosmeticPairs * 0.49 + v26 * 0.43 + #p7.comingSoonItems * 0.44 + math.max(0, v27 - 1) * 0.015 + 0.01
        local t2 = {}
        local n1 = 0
        local v31 = false

        while true do
            local v32 = n1

            if v31 then
                n1 += 1
                v32 = n1
            else
                v31 = true
            end

            if n1 < v26 then
                local items = p7.items
                local t3 = {}
                local n2 = 0

                for v33, v34 in items do
                    local v35 = v33 - 1

                    if (v32 * 3 <= v35 and v35 < (v32 + 1) * 3) == true then
                        n2 += 1
                        t3[n2] = v34
                    end
                end

                table.insert(t2, t3)
                n1 = v32
                continue
            end

            break
        end

        local v36 = 1 + #p7.featuredItems
        local v37 = v36 + #p7.cosmeticPairs
        local v38 = v37 + v26
        local featuredItems = p7.featuredItems
        local v39 = table.create(#featuredItems)

        for v40, v41 in featuredItems do
            local v42 = v40 - 1

            v39[v40] = react.createElement(default8, {
                item = v41,
                key = v41.id,
                layoutOrder = 1 + v42,
                onBuy = p7.onBuyItem,
                scrollFrameRef = v21,
                sectionType = v41.longSectionType or "LongRainbowSectionBright"
            })
        end

        local v43 = table.create(#t1)

        for v44, v45 in t1 do
            local v46 = v44 - 1
            local v47 = table.clone(v45)

            setmetatable(v47, nil)
            v47.key = v45.id
            v47.layoutOrder = v36 + v46
            v47.onBuyItem = p7.onBuyItem
            v47.onBuyPremium = p7.onBuyPremium
            v47.onPreviewCharm = p7.onPreviewCharm
            v47.scrollFrameRef = v21
            v43[v44] = react.createElement(default6, v47)
        end

        local v48 = table.create(#t2)

        for v49, v50 in t2 do
            local v51 = v49 - 1

            v48[v49] = react.createElement(RewardRow, {
                items = v50,
                key = ("reward-row-%*"):format(v51),
                layoutOrder = v37 + v51,
                onBuyItem = p7.onBuyItem
            })
        end

        local comingSoonItems = p7.comingSoonItems
        local v52 = table.create(#comingSoonItems)

        for v53, v54 in comingSoonItems do
            local v55 = v53 - 1

            v52[v53] = react.createElement(default8, {
                comingSoon = true,
                sectionType = "LongRedSection",
                silhouette = true,
                item = v54,
                key = v54.id,
                layoutOrder = v38 + v55
            })
        end

        return react.createElement(default, {
            aspectRatio = 1.5,
            bodyTransparency = 0.04,
            headerGradientRotation = 28,
            bodyBg = v2,
            headerBg = v1,
            headerNode = react.createElement(ShopHeaderNode, {
                eventName = p7.eventName,
                ticketCount = p7.ticketCount
            }),
            onClose = p7.onClose,
            size = UDim2.fromScale(v23 and 0.96 or 0.9, v23 and 0.92 or 0.86),
            title = p7.eventName
        }, react.createElement(default2, {
            itemPaddingScale = 0.015,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            canvasHeightScale = math.max(1, v30),
            padding = {
                bottom = UDim.new(0.005, 0),
                left = UDim.new(v23 and 0.022 or 0.015, 0),
                right = UDim.new(v23 and 0.022 or 0.015, 0),
                top = UDim.new(0.012, 0)
            },
            position = UDim2.fromScale(0.5, 0.975),
            scrollBarColor = Color3.fromRGB(255, 190, 45),
            scrollBarThickness = if v23 then 4 elseif v22 == "md" then 7 else 10,
            scrollFrameRef = v21,
            size = UDim2.fromScale(0.975, 0.855)
        }, v39, v43, v48, v52))
    end
}

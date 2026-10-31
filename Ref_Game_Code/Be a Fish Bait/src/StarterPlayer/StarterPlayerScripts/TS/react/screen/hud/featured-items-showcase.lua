-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useMotion, useViewport = out.useBindingState, out.useMotion, out.useViewport
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local timeSkip5MinProductId, timeSkip30MinProductId, starterPackProductId, starterPackBundleName = v1.timeSkip5MinProductId, v1.timeSkip30MinProductId, v1.starterPackProductId, v1.starterPackBundleName
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerBundlePurchaseHistory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerBundlePurchaseHistory
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local t1 = {
    {
        label = "TIME SKIP (30M)",
        price = 179,
        icon = images.timeSkipBundleIcon,
        productId = timeSkip30MinProductId,
        shineColor = Color3.fromRGB(255, 220, 60)
    },
    {
        label = "TIME SKIP (5M)",
        price = 34,
        icon = images.timeSkipIcon,
        productId = timeSkip5MinProductId,
        shineColor = Color3.fromRGB(100, 220, 255)
    },
    {
        label = "STARTER PACK",
        price = 79,
        icon = images.starterPackFeatured,
        productId = starterPackProductId,
        shineColor = Color3.fromRGB(180, 100, 255)
    }
}
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 80)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 40)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 240, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 210, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 210))
})

local function FeaturedTile(p1) -- line: 48
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy), attemptStorePurchase (copy), useSound (copy), useTheme (copy), images (copy), useProductPrice (copy), useFreePurchaseModeEnabled (copy), v2 (copy)
    local item, tileSize = p1.item, p1.tileSize
    local v3 = useTheme()
    local playSound = useSound("ButtonClick").playSound
    local playSound2 = useSound("ButtonHover").playSound
    local v4 = useFreePurchaseModeEnabled()
    local v5 = useProductPrice(item.productId, Enum.InfoType.Product)

    if v5 == nil then
        v5 = item.price
    end

    local v6, v7 = useMotion(0)

    useEffect(function() -- line: 65
        -- upvalues: v7 (copy)
        v7:linear(360, {
            speed = 24
        })

        return (v7:onComplete(function() -- line: 72
            -- upvalues: v7 (copy)
            v7:immediate(0)
            v7:linear(360, {
                speed = 24
            })
        end))
    end, { v7 })

    local v8, v9 = useMotion(0)

    useEffect(function() -- line: 80
        -- upvalues: v9 (copy)
        v9:linear(360, {
            speed = 100
        })

        return (v9:onComplete(function() -- line: 87
            -- upvalues: v9 (copy)
            v9:immediate(0)
            v9:linear(360, {
                speed = 100
            })
        end))
    end, { v9 })

    local v10, v11 = useMotion(1)

    useEffect(function() -- line: 95
        -- upvalues: v11 (copy)
        local v12 = false
        local v13 = true
        local v14

        v14 = function() -- line: 99
            -- upvalues: v14 (ref), v12 (ref), v13 (ref), v11 (copy)
            if v12 then
                return nil
            end

            v11:spring(v13 and 1.2 or 1, {
                tension = 140,
                friction = 7
            })
            v13 = not v13
            task.delay(1.1, v14)
        end

        v14()

        return function() -- line: 111
            -- upvalues: v12 (ref)
            v12 = true
        end
    end, { v11 })

    local v16, v17 = useMotion(0)

    useEffect(function() -- line: 117
        -- upvalues: v17 (copy)
        local v18 = false
        local v19 = true
        local v20

        v20 = function() -- line: 121
            -- upvalues: v20 (ref), v18 (ref), v19 (ref), v17 (copy)
            if v18 then
                return nil
            end

            v17:spring(v19 and 45 or 0, {
                tension = 200,
                friction = 10
            })
            v19 = not v19
            task.delay(1, v20)
        end

        v20()

        return function() -- line: 133
            -- upvalues: v18 (ref)
            v18 = true
        end
    end, { v17 })

    local function v22() -- line: 137
        -- upvalues: item (copy), playSound (copy), attemptStorePurchase (copy)
        if item.productId == 0 then
            return nil
        end

        playSound()
        attemptStorePurchase(item.productId)
    end

    local v24 = math.round(tileSize * 0.68)
    local v26 = math.round(tileSize * 0.22)
    local v28 = math.round(tileSize * 0.18)
    local v30 = math.round(tileSize * 0.04)
    local v31 = v24 + v26 + v30 + v28
    local v33 = math.round(v24 * 1.55)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        Size = UDim2.new(0, tileSize, 0, v31)
    }, react.createElement("imagebutton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 12,
        Event = {
            Activated = v22,
            MouseEnter = playSound2
        },
        Size = UDim2.fromScale(1, 1)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.38,
        ZIndex = 9,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.shineBackground,
        ImageColor3 = item.shineColor,
        Position = UDim2.new(0.5, 0, 0, (math.round(v24 * 0.5))),
        Rotation = v6,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.new(0, v33, 0, v33)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = item.icon,
        Position = UDim2.fromScale(0.5, 0),
        Rotation = v16,
        ScaleType = Enum.ScaleType.Fit,
        Size = v10:map(function(p2) -- line: 183
            -- upvalues: v24 (copy)
            return UDim2.new(0, math.round(v24 * p2), 0, (math.round(v24 * p2)))
        end)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, v24),
        Size = UDim2.new(0, tileSize, 0, v26)
    }, react.createElement(default, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v2,
        gradientRotation = v8,
        overrideProps = {
            TextScaled = true,
            ZIndex = 11,
            Font = v3.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        position = UDim2.fromScale(0.5, 0.5),
        strokeProps = {
            Thickness = 0.1
        },
        text = item.label
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, v24 + v26 + v30),
        Size = UDim2.new(0, tileSize, 0, v28)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        ZIndex = 11,
        Image = images.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.new(0, v28, 0, v28)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 11,
        Size = UDim2.new(0, math.round(v28 * 1.8), 0, v28)
    }, react.createElement(default, {
        shadowYScale = 0.05,
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(100, 255, 100),
        overrideProps = {
            TextScaled = true,
            ZIndex = 12,
            Font = v3.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = if v4 then "FREE" else tostring(v5)
    }))))
end

return {
    default = function() -- FeaturedItemsShowcase | line: 259
        -- upvalues: react (copy), useEffect (copy), useState (copy), useBindingState (copy), useViewport (copy), starterPackProductId (copy), starterPackBundleName (copy), useRootSelector (copy), selectPlayerBundlePurchaseHistory (copy), localPlayerUserId (copy), t1 (copy), FeaturedTile (copy)
        local v45 = useBindingState(useViewport())
        local v46 = useRootSelector(selectPlayerBundlePurchaseHistory(localPlayerUserId))
        local v47 = v46 ~= nil

        if v47 then
            local function v48(p3) -- line: 266
                -- upvalues: starterPackBundleName (copy)
                return p3.bundleName == starterPackBundleName
            end

            v47 = false

            for v49, v50 in v46 do
                local _ = v49 - 1

                if v50.bundleName == starterPackBundleName then
                    v47 = true
                    break
                end

                v47 = false
            end
        end

        local t8

        if v47 then
            t8 = {}

            local function v51(p4) -- line: 283
                -- upvalues: starterPackProductId (copy)
                return p4.productId ~= starterPackProductId
            end

            local n1 = 0

            for v52, v53 in t1 do
                local _ = v52 - 1

                if v53.productId ~= starterPackProductId == true then
                    n1 += 1
                    t8[n1] = v53
                end
            end
        else
            t8 = t1
        end

        local v54 = #t8
        local v55, v56 = useState(0)

        useEffect(function() -- line: 301
            -- upvalues: v54 (copy), v56 (copy)
            v56(0)

            local v57 = false
            local v58, v59

            v59 = function() -- line: 306
                -- upvalues: v59 (ref), v57 (ref), v58 (ref), v54 (copy), v56 (copy)
                v58 = task.delay(10, function() -- line: 307
                    -- upvalues: v59 (ref), v57 (ref), v54 (copy), v56 (copy)
                    if v57 then
                        return nil
                    end

                    v56(function(p5) -- line: 311
                        -- upvalues: v54 (copy)
                        return (p5 + 1) % v54
                    end)
                    v59()
                end)
            end

            v59()

            return function() -- line: 318
                -- upvalues: v57 (ref), v58 (ref)
                v57 = true

                if v58 ~= nil then
                    task.cancel(v58)
                end
            end
        end, { v54 })

        local v60 = v45.X < 1000 and v45.Y < 600
        local v61 = v45.X < 1600
        local v62 = if v60 then math.clamp(math.floor(v45.Y * 0.22), 70, 120) elseif v61 then math.clamp(math.floor(v45.Y * 0.18), 80, 140) else math.clamp(math.floor(v45.Y * 0.22), 90, 170)
        local v70 = math.round(v62 * 0.68)
        local v72 = math.round(v62 * 0.22)
        local v74 = math.round(v62 * 0.18)
        local v76 = math.round(v62 * 0.04)
        local v77 = v70 + v72 + v76 + v74
        local v78 = t8[v55 + 1]

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0.04, 0.45),
            Size = UDim2.new(0, v62, 0, v77)
        }, v78 ~= nil and react.createElement(FeaturedTile, {
            item = v78,
            key = v78.label,
            tileSize = v62
        }))
    end,
    featuredItems = t1
}

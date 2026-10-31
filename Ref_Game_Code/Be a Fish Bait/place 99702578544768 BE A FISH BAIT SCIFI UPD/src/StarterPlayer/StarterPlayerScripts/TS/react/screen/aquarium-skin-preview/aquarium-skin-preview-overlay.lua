-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players = services.HttpService, services.Players
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local aquariumSkinPreviewNameAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "aquarium-skin-preview-atom").aquariumSkinPreviewNameAtom
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "exclusive-shop-buy-button").default
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils")
local attemptStorePurchase, promptCashPurchase = v1.attemptStorePurchase, v1.promptCashPurchase
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local AquariumSkinSource, getAquariumSkinData = v2.AquariumSkinSource, v2.getAquariumSkinData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquarium, selectPlayerAquariumMoneyPerSecond, selectPlayerStat = selectors.selectPlayerAquarium, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerStat
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local volcanicAquariumSkinProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").volcanicAquariumSkinProductId
local v3 = tostring(Players.LocalPlayer.UserId)
local t1 = {
    Volcanic = {
        price = 349,
        productId = volcanicAquariumSkinProductId
    }
}
local t2 = {
    [AquariumSkinSource.CelebrationEventShop] = "celebrationEventShop",
    [AquariumSkinSource.DailyReward] = "dailyReward",
    [AquariumSkinSource.ExclusiveShop] = "exclusiveShop",
    [AquariumSkinSource.SkinCrate] = "aquariumShop",
    [AquariumSkinSource.SpinWheel] = "playtimeSpinWheel",
    [AquariumSkinSource.Index] = "index"
}
local t3 = {
    [AquariumSkinSource.CelebrationEventShop] = {
        label = "Event Shop",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 89, 214)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 66, 255))
        }),
        popoutColor = Color3.fromRGB(78, 20, 125)
    },
    [AquariumSkinSource.DailyReward] = {
        label = "Daily Reward",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 20))
        }),
        popoutColor = Color3.fromRGB(110, 10, 5)
    },
    [AquariumSkinSource.ExclusiveShop] = {
        label = "Exclusive Shop",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 60, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 10, 200))
        }),
        popoutColor = Color3.fromRGB(60, 0, 110)
    },
    [AquariumSkinSource.SkinCrate] = {
        label = "Open Crate Shop",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
        }),
        popoutColor = Color3.fromRGB(0, 60, 140)
    },
    [AquariumSkinSource.SpinWheel] = {
        label = "Spin Wheel",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 155, 0))
        }),
        popoutColor = Color3.fromRGB(110, 70, 0)
    },
    [AquariumSkinSource.Index] = {
        label = "Index",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 90, 210))
        }),
        popoutColor = Color3.fromRGB(5, 40, 120)
    }
}

local function getPurchaseLabel(p1) -- line: 86
    -- upvalues: abbreviate (copy)
    if p1.robuxPrice ~= nil then
        return (("R$ %*"):format(p1.robuxPrice))
    end

    if p1.moneyPrice == nil then
        return "Buy"
    end

    return (("$%*"):format((abbreviate(p1.moneyPrice))))
end

local function AquariumSkinPreviewActionButton(p2) -- line: 95
    -- upvalues: useBindingState (copy), useViewport (copy), react (copy), default2 (copy)
    local v4 = useBindingState(useViewport())
    local v5 = v4.X < 1000 and v4.Y < 600
    local v6 = if v5 then math.clamp(math.floor(v4.Y * 0.13), 52, 64) else 92
    local v10 = math.round(v6 * 3.4782608695652173)

    return react.createElement(default2, {
        zIndex = 1E+05,
        anchorPoint = Vector2.new(0.5, 1),
        color = p2.color,
        frameSize = UDim2.fromOffset(v10, v6),
        label = p2.label,
        onClick = p2.onClick,
        popoutColor = p2.popoutColor,
        position = UDim2.new(0.5, 0, 1, v5 and -22 or -36)
    })
end

return {
    default = function() -- AquariumSkinPreviewOverlay | line: 111
        -- upvalues: Flamework (copy), subscribe (copy), HttpService (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), aquariumSkinPreviewNameAtom (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), default (copy), default3 (copy), attemptStorePurchase (copy), promptCashPurchase (copy), abbreviate (copy), AquariumSkinSource (copy), getAquariumSkinData (copy), selectPlayerAquarium (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerStat (copy), images (copy), v3 (copy), t1 (copy), t2 (copy), t3 (copy), AquariumSkinPreviewActionButton (copy)
        local v11, v12 = useState(aquariumSkinPreviewNameAtom())
        local v13 = useRef()
        local v14 = useRootProducer()
        local v15 = useRootSelector(selectPlayerAquarium(v3))
        local v16 = useRootSelector(selectPlayerStat(v3, "money"))

        if v16 == nil then
            v16 = 0
        end

        local v17 = useRootSelector(selectPlayerAquariumMoneyPerSecond(v3))
        local v18 = if v11 == nil then nil else getAquariumSkinData(v11)

        if v15 ~= nil then
            v15 = v15.ownedSkins
        end

        if v15 == nil then
            v15 = { "Default" }
        end

        local v19 = v18 ~= nil

        if v19 then
            local name = v18.name

            v19 = table.find(v15, name) ~= nil
        end

        local v20 = if v18 == nil or v18.source ~= AquariumSkinSource.ExclusiveShop then nil else t1[v18.name]

        useEffect(function() -- line: 139
            -- upvalues: v12 (copy), subscribe (copy), aquariumSkinPreviewNameAtom (copy)
            return subscribe(aquariumSkinPreviewNameAtom, v12)
        end, {})
        useEffect(function() -- line: 142
            -- upvalues: v13 (copy)
            if v13.current ~= nil then
                v13.current.Name = "AquariumSkinPreviewOverlay"
            end
        end, {})

        local createElement = react.createElement
        local t5 = {
            DisplayOrder = 1E+05,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            Enabled = v11 ~= nil,
            ScreenInsets = Enum.ScreenInsets.None,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ref = v13
        }
        local v21 = react.createElement(default, {
            cornerRadius = 0.22,
            zIndex = 1E+05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(235, 66, 76),
            onClick = function() -- onClick | line: 159
                -- upvalues: Flamework (copy)
                return Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):closePreview()
            end,
            popoutColor = Color3.fromRGB(120, 24, 32),
            position = UDim2.new(1, -42, 0, 42),
            size = UDim2.fromOffset(62, 62),
            strokeColor = Color3.new(1, 1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 100003,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.crossIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.48, 0.48)
        }))
        local v22

        if v18 ~= nil and not v19 and v20 ~= nil then
            v22 = react.createElement(default3, {
                zIndex = 1E+05,
                anchorPoint = Vector2.new(0.5, 1),
                frameSize = UDim2.fromOffset(320, 92),
                onClick = function() -- onClick | line: 178
                    -- upvalues: v20 (copy), Flamework (copy), attemptStorePurchase (copy)
                    Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):stopPreview()
                    task.defer(function() -- line: 180
                        -- upvalues: v20 (copy), attemptStorePurchase (copy)
                        return attemptStorePurchase(v20.productId)
                    end)
                end,
                position = UDim2.new(0.5, 0, 1, -36),
                price = v20.price,
                productId = v20.productId
            })
        elseif v18 ~= nil and not v19 and v18.source ~= nil then
            v22 = react.createElement(AquariumSkinPreviewActionButton, {
                color = t3[v18.source].color,
                label = t3[v18.source].label,
                onClick = function() -- onClick | line: 191
                    -- upvalues: v14 (copy), v18 (copy), Flamework (copy), AquariumSkinSource (copy), t2 (copy)
                    local source = v18.source

                    Flamework.resolveDependency("client/controllers/aquarium-skin-preview-controller@AquariumSkinPreviewController"):closePreview()
                    task.defer(function() -- line: 194
                        -- upvalues: source (copy), v14 (copy), AquariumSkinSource (copy), t2 (copy)
                        return v14.windowOpened({
                            aquariumShopSection = if source == AquariumSkinSource.SkinCrate then "crates" else nil,
                            currentWindow = t2[source]
                        })
                    end)
                end,
                popoutColor = t3[v18.source].popoutColor
            })
        elseif v18 ~= nil and not v19 then
            local createElement = react.createElement
            local t9 = {
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 195, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 140, 0))
                })
            }

            t9.label = if v18.robuxPrice ~= nil then ("R$ %*"):format(v18.robuxPrice) elseif v18.moneyPrice == nil then "Buy" else ("$%*"):format((abbreviate(v18.moneyPrice)))

            local v23 = v16

            function t9.onClick() -- line: 205
                -- upvalues: v14 (copy), v17 (copy), v23 (copy), v18 (copy), HttpService (copy), functions (copy), promptCashPurchase (copy)
                local moneyPrice = v18.moneyPrice

                if moneyPrice == nil then
                    moneyPrice = 0
                end

                if moneyPrice > 0 and v23 < moneyPrice then
                    v14.onScreenFeedbackAdded({
                        message = "Not enough money!",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                    promptCashPurchase(moneyPrice, v17)

                    return nil
                end

                functions.purchaseAquariumSkin(v18.name):andThen(function(p3) -- line: 220
                    -- upvalues: v14 (copy), HttpService (copy)
                    v14.onScreenFeedbackAdded({
                        id = HttpService:GenerateGUID(false),
                        message = p3 and "Skin purchased!" or "Could not purchase skin",
                        type = p3 and "neutral" or "error"
                    })
                end)
            end

            t9.popoutColor = Color3.fromRGB(120, 70, 0)
            v22 = createElement(AquariumSkinPreviewActionButton, t9)
        end

        return createElement("screengui", t5, v21, v22)
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils")
local attemptStorePurchase, promptCashPurchase = v1.attemptStorePurchase, v1.promptCashPurchase
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins")
local fishingRodSkinOrder, fishingRodSkinsData = v2.fishingRodSkinOrder, v2.fishingRodSkinsData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectEquippedFishingRodSkinId, selectPlayerAquariumMoneyPerSecond, selectPlayerOwnedFishingRodSkinIds, selectPlayerStat = selectors.selectEquippedFishingRodSkinId, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerOwnedFishingRodSkinIds, selectors.selectPlayerStat
local getFishingRodSkinProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getFishingRodSkinProductId
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, getRarityDisplayName = v3.getRarityBorderColor, v3.getRarityColor, v3.getRarityDisplayName
local default6 = RuntimeLib.import(script, script.Parent, "rod-shop-tabs").default
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 170, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 85, 10))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 145, 0))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 35, 30))
})
local v7 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 145, 145)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
})
local v8 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v9 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 170))
})
local RodSkinItem

local function RodSkins(p1) -- line: 44
    -- upvalues: react (copy), HttpService (copy), default2 (copy), default5 (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), useSound (copy), attemptStorePurchase (copy), promptCashPurchase (copy), localPlayerUserId (copy), fishingRodSkinOrder (copy), fishingRodSkinsData (copy), selectEquippedFishingRodSkinId (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerOwnedFishingRodSkinIds (copy), selectPlayerStat (copy), getFishingRodSkinProductId (copy), default6 (copy), v4 (copy), RodSkinItem (ref)
    local v10 = useRootProducer()
    local v11 = useRootSelector(selectPlayerOwnedFishingRodSkinIds(localPlayerUserId))
    local v12 = useRootSelector(selectEquippedFishingRodSkinId(localPlayerUserId))
    local v13 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

    if v13 == nil then
        v13 = 0
    end

    local v14 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
    local playSound = useSound("PurchaseSuccess").playSound
    local v15 = react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.4
    })
    local v16 = table.create(#fishingRodSkinOrder)

    local function v17(p2, p3) -- line: 61
        -- upvalues: v10 (copy), v11 (copy), v12 (copy), v13 (ref), v14 (copy), playSound (copy), react (copy), HttpService (copy), functions (copy), attemptStorePurchase (copy), promptCashPurchase (copy), fishingRodSkinsData (copy), getFishingRodSkinProductId (copy), RodSkinItem (ref)
        local v18 = fishingRodSkinsData[p2]

        if v18 == nil then
            return nil
        end

        local t1 = {
            data = v18,
            isEquipped = v12 == p2
        }

        t1.isOwned = table.find(v11, p2) ~= nil
        t1.key = p2
        t1.layoutOrder = p3

        t1.onBuyCoins = function() -- line: 75
            -- upvalues: p2 (copy), v18 (copy), v10 (copy), v13 (ref), v14 (copy), playSound (copy), HttpService (copy), functions (copy), promptCashPurchase (copy)
            local moneyPrice = v18.moneyPrice

            if moneyPrice == nil then
                return nil
            end

            if v13 < moneyPrice then
                v10.onScreenFeedbackAdded({
                    message = "Not enough money!",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
                promptCashPurchase(moneyPrice, v14)

                return nil
            end

            functions.purchaseFishingRodSkin(p2):andThen(function(p4) -- line: 89
                -- upvalues: v18 (copy), v10 (copy), playSound (copy), HttpService (copy)
                if not p4 then
                    return nil
                end

                playSound()
                v10.onScreenFeedbackAdded({
                    type = "success",
                    id = HttpService:GenerateGUID(false),
                    message = ("%* purchased!"):format(v18.name)
                })
            end):catch(function(p5) -- line: 99
                warn("[src/client/react/screen/rods-shop/rod-skins.tsx:143]", (("Fishing rod skin purchase request failed: %*"):format(p5)))
            end)
        end

        t1.onBuyRobux = function() -- line: 103
            -- upvalues: p2 (copy), attemptStorePurchase (copy), getFishingRodSkinProductId (copy)
            local v19 = getFishingRodSkinProductId(p2)

            if v19 == nil then
                return nil
            end

            attemptStorePurchase(v19)
        end

        t1.onEquip = function() -- line: 110
            -- upvalues: p2 (copy), functions (copy)
            functions.setFishingRodSkin(p2):catch(function(p6) -- line: 111
                warn("[src/client/react/screen/rods-shop/rod-skins.tsx:155]", (("Fishing rod skin equip request failed: %*"):format(p6)))
            end)
        end

        t1.onUnequip = function() -- line: 115
            -- upvalues: functions (copy)
            functions.setFishingRodSkin(nil):catch(function(p7) -- line: 116
                warn("[src/client/react/screen/rods-shop/rod-skins.tsx:160]", (("Fishing rod skin unequip request failed: %*"):format(p7)))
            end)
        end

        t1.robuxProductId = getFishingRodSkinProductId(p2)

        return react.createElement(RodSkinItem, t1)
    end

    for v20, v21 in fishingRodSkinOrder do
        v16[v20] = v17(v21, v20 - 1, fishingRodSkinOrder)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.8, 0.55)
    }, v15, react.createElement(default2, {
        title = "Rod Skins",
        bodyBg = Color3.fromRGB(0, 0, 0),
        headerBg = v4,
        onClose = p1.onClose,
        size = UDim2.fromScale(1, 1)
    }, react.createElement(default5, {
        cellsPerRow = 1,
        listPaddingOffset = 16,
        rowsToBeVisible = 2.5,
        scrollBarThickness = 7,
        anchorPoint = Vector2.new(0.5, 1),
        fillDirection = Enum.FillDirection.Vertical,
        padding = {
            all = UDim.new(0, 16)
        },
        position = UDim2.fromScale(0.5, 0.95),
        scrollBarColor = Color3.fromRGB(10, 10, 10),
        size = UDim2.fromScale(0.97, 0.85)
    }, v16)), react.createElement(default6, {
        activeTab = "skin",
        onSelectTab = p1.onSelectTab
    }))
end

function RodSkinItem(p8) -- line: 158
    -- upvalues: react (copy), default (copy), default3 (copy), default4 (copy), useProductPrice (copy), useFreePurchaseModeEnabled (copy), useTheme (copy), abbreviate (copy), getRarityBorderColor (copy), getRarityColor (copy), getRarityDisplayName (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy)
    local data, isEquipped, isOwned, layoutOrder = p8.data, p8.isEquipped, p8.isOwned, p8.layoutOrder
    local onBuyCoins, onBuyRobux, onEquip, onUnequip = p8.onBuyCoins, p8.onBuyRobux, p8.onEquip, p8.onUnequip
    local robuxProductId = p8.robuxProductId
    local v22 = useTheme()
    local v23 = useFreePurchaseModeEnabled()
    local v24 = useProductPrice(robuxProductId, Enum.InfoType.Product)
    local v25 = getRarityColor(data.rarity)
    local v26 = getRarityBorderColor(data.rarity)
    local v27 = data.moneyPrice ~= nil
    local v28 = data.robuxPrice ~= nil
    local v29 = not v27 and not v28
    local v30, v31, v32

    if isOwned then
        if isEquipped then
            onBuyRobux = onUnequip
            v30 = "Unequip"
            v31 = v6
        else
            onBuyRobux = onEquip
            v30 = "Equip"
            v31 = v5
        end

        v32 = false
    elseif v27 then
        local moneyPrice = data.moneyPrice

        if moneyPrice == nil then
            moneyPrice = 0
        end

        v30 = ("%*$"):format((abbreviate(moneyPrice)))
        v31 = v8
        onBuyRobux = onBuyCoins
        v32 = false
    elseif v28 then
        local robuxPrice = v24

        if v24 == nil then
            robuxPrice = data.robuxPrice

            if robuxPrice == nil then
                robuxPrice = 0
            end
        end

        v30 = if v23 then "FREE" else ("R$%*"):format(robuxPrice)
        v31 = v9
        v32 = false
    else
        v31 = v7

        onBuyRobux = function() -- line: 208
        end

        v30 = "Unobtainable"
        v32 = true
    end

    return react.createElement(default, {
        cornerRadius = 0.01,
        isStudded = true,
        strokeThickness = 0.01,
        textureTransparency = 0.6,
        backgroundColor = Color3.fromRGB(120, 120, 120),
        layoutOrder = layoutOrder,
        strokeColor = Color3.fromRGB(64, 64, 64)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = data.imageId,
        Position = UDim2.fromScale(0.5, 0.46),
        Size = UDim2.fromScale(0.95, 0.55)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), v29 and react.createElement(default3, {
        text = "Event-Only",
        color = Color3.fromRGB(255, 205, 45),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.42, 0.07),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0.05, 0.02),
        strokeProps = {
            Thickness = 0.04
        }
    }), react.createElement(default3, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.75, 0.12)
        },
        position = UDim2.fromScale(0.07, 0.1),
        strokeProps = {
            Thickness = 0.04
        },
        text = data.name
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 4,
        Font = v22.textFont,
        Position = UDim2.fromScale(0.07, 0.21),
        Size = UDim2.fromScale(0.8, 0.08),
        Text = getRarityDisplayName(data.rarity),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uigradient", {
        Rotation = 90,
        Color = v25
    }), react.createElement("uistroke", {
        Thickness = 0.03,
        Color = v26,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    })), react.createElement(default4, {
        anchorPoint = Vector2.new(0.5, 1),
        color = v31,
        disabled = v32,
        frameSize = UDim2.fromScale(0.5, 0.14),
        label = v30,
        onClick = onBuyRobux,
        position = UDim2.fromScale(0.5, 0.94)
    }))
end

return {
    default = RodSkins
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local default4 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-window").default
local v1 = RuntimeLib.import(script, script.Parent, "celebration-event-shop-catalog")
local celebrationEventShopComingSoonItems, celebrationEventShopCosmeticPairs, celebrationEventShopFeaturedItems, celebrationEventShopMoreRewards = v1.celebrationEventShopComingSoonItems, v1.celebrationEventShopCosmeticPairs, v1.celebrationEventShopFeaturedItems, v1.celebrationEventShopMoreRewards

local function CelebrationEventShopShowcase() -- line: 17
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy), getTitleData (copy), default4 (copy), celebrationEventShopComingSoonItems (copy), celebrationEventShopCosmeticPairs (copy), celebrationEventShopFeaturedItems (copy), celebrationEventShopMoreRewards (copy)
    local v2, v3 = useState(true)
    local v4, v5 = useState(10000)
    local v6, v7 = useState({})
    local v8, v9 = useState({})
    local v10, v11 = useState(nil)

    local function v12(p1) -- line: 23
        -- upvalues: v6 (copy), v7 (copy)
        if table.find(v6, p1) ~= nil then
            return
        end

        local t1 = {}
        local v13 = #t1
        local v14 = #v6

        table.move(v6, 1, v14, v13 + 1, t1)
        t1[v13 + v14 + 1] = p1
        v7(t1)
    end

    local function v15(p2) -- line: 35
        -- upvalues: v4 (copy), v5 (copy), v8 (copy), v9 (copy), v11 (copy), v12 (copy), celebrationEventShopCosmeticPairs (copy), celebrationEventShopFeaturedItems (copy), celebrationEventShopMoreRewards (copy)
        local t2 = {}
        local v16 = #t2
        local v17 = #celebrationEventShopFeaturedItems

        table.move(celebrationEventShopFeaturedItems, 1, v17, v16 + 1, t2)

        local v18 = v16 + v17
        local v19 = table.create(#celebrationEventShopCosmeticPairs)

        local function v20(p3) -- line: 43
            return p3.standard
        end

        for v21, v22 in celebrationEventShopCosmeticPairs do
            local _ = v21 - 1

            v19[v21] = v22.standard
        end

        local v23 = #v19

        table.move(v19, 1, v23, v18 + 1, t2)

        local v24 = v18 + v23

        table.move(celebrationEventShopMoreRewards, 1, #celebrationEventShopMoreRewards, v24 + 1, t2)

        local v25

        for v26, v27 in t2 do
            local _ = v26 - 1

            if v27.id == p2 == true then
                v25 = v27
                break
            end

            v25 = nil
        end

        local v28 = v8[p2]

        if v28 == nil then
            v28 = 0
        end

        if v25 == nil or v4 < v25.price or v25.stockMax ~= nil and v25.stockMax <= v28 then
            return nil
        end

        v5(v4 - v25.price)

        local v29 = false

        for v30, v31 in celebrationEventShopFeaturedItems do
            local _ = v30 - 1

            if v31.id == p2 then
                v29 = true
                break
            end
        end

        if v29 then
            local t3 = {}

            for v32, v33 in v8 do
                t3[v32] = v33
            end

            t3[p2] = v28 + 1
            v9(t3)
        else
            v12(p2)
        end

        v11(v25)
    end

    local function v34(p4) -- line: 112
        -- upvalues: v6 (copy), v11 (copy), v12 (copy), celebrationEventShopCosmeticPairs (copy)
        local v35 = table.create(#celebrationEventShopCosmeticPairs)

        local function v36(p5) -- line: 115
            return p5.premium
        end

        for v37, v38 in celebrationEventShopCosmeticPairs do
            local _ = v37 - 1

            v35[v37] = v38.premium
        end

        local v39

        for v40, v41 in v35 do
            local _ = v40 - 1

            if v41.id == p4 == true then
                v39 = v41
                break
            end

            v39 = nil
        end

        if v39 == nil or table.find(v6, p4) ~= nil then
            return nil
        end

        v12(p4)
        v11(v39)
    end

    local v42 = table.create(#celebrationEventShopCosmeticPairs)

    local function v43(p6) -- line: 148
        -- upvalues: v4 (copy), v6 (copy)
        local v44 = table.clone(p6)

        setmetatable(v44, nil)

        local v45 = table.clone(p6.premium)

        setmetatable(v45, nil)

        local id = p6.premium.id

        v45.purchaseState = table.find(v6, id) == nil and "available" or "owned"
        v44.premium = v45

        local v46 = table.clone(p6.standard)

        setmetatable(v46, nil)

        local id2 = p6.standard.id

        if table.find(v6, id2) ~= nil then
            v46.purchaseState = "owned"
        elseif v4 < p6.standard.price then
            v46.purchaseState = "insufficientFunds"
        else
            v46.purchaseState = "available"
        end

        v44.standard = v46

        return v44
    end

    for v47, v48 in celebrationEventShopCosmeticPairs do
        v42[v47] = v43(v48, v47 - 1, celebrationEventShopCosmeticPairs)
    end

    local v49 = table.create(#celebrationEventShopMoreRewards)

    for v50, v51 in celebrationEventShopMoreRewards do
        local _ = v50 - 1
        local v52 = table.clone(v51)

        setmetatable(v52, nil)

        local id = v51.id

        if table.find(v6, id) ~= nil then
            v52.purchaseState = "limitReached"
        elseif v4 < v51.price then
            v52.purchaseState = "insufficientFunds"
        else
            v52.purchaseState = "available"
        end

        v49[v50] = v52
    end

    local v53 = table.create(#celebrationEventShopFeaturedItems)

    local function v54(p7) -- line: 189
        -- upvalues: v4 (copy), v8 (copy)
        local v55 = v8[p7.id]

        if v55 == nil then
            v55 = 0
        end

        local stockMax = p7.stockMax

        if stockMax == nil then
            stockMax = 1
        end

        local v56 = table.clone(p7)

        setmetatable(v56, nil)

        if stockMax <= v55 then
            v56.purchaseState = "limitReached"
        elseif v4 < p7.price then
            v56.purchaseState = "insufficientFunds"
        else
            v56.purchaseState = "available"
        end

        v56.stockCurrent = math.max(0, stockMax - v55)

        return v56
    end

    for v58, v59 in celebrationEventShopFeaturedItems do
        v53[v58] = v54(v59, v58 - 1, celebrationEventShopFeaturedItems)
    end

    local v60 = if (if v10 == nil then v10 else v10.titleId) == nil then nil else getTitleData(v10.titleId)
    local createElement = react.createElement
    local t4 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v61 = not v2

    v61 = v61 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open FOMO Store",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 225
                -- upvalues: v3 (copy)
                return v3(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(220, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    local v62 = react.createElement(default, {
        enableCameraEffects = true,
        ["in"] = v2
    }, react.createElement(default4, {
        eventName = "FOMO STORE",
        comingSoonItems = celebrationEventShopComingSoonItems,
        cosmeticPairs = v42,
        featuredItems = v53,
        items = v49,
        onBuyItem = v15,
        onBuyPremium = v34,
        onClose = function() -- onClose | line: 248
            -- upvalues: v3 (copy)
            return v3(false)
        end,
        onPreviewCharm = function(p8) -- onPreviewCharm | line: 251
            return print((("Preview Charm: %*"):format(p8)))
        end,
        ticketCount = v4
    }))
    local v63 = false

    if v10 ~= nil then
        local createElement = react.createElement
        local t9 = {
            title = "NEW REWARD!",
            uiScale = 0.9,
            zIndex = 200,
            iconImage = v10.icon,
            onFinished = function() -- onFinished | line: 257
                -- upvalues: v11 (copy)
                return v11(nil)
            end,
            rewardText = if v60 == nil then v10.name else nil,
            showIcon = v60 == nil
        }
        local t10

        if v60 ~= nil then
            t10 = {}
            t10.color = v60.animatedColor or v60.color
            t10.displayName = v60.displayName
            t10.perkDescription = v60.perkDescription
        end

        t9.titleReward = t10
        v63 = createElement(default3, t9)
    end

    return createElement("frame", t4, v61, v62, v63)
end

return storyForScreenGui(react.createElement(default2, nil, react.createElement(CelebrationEventShopShowcase)), {
    zIndexBehavior = Enum.ZIndexBehavior.Global
})

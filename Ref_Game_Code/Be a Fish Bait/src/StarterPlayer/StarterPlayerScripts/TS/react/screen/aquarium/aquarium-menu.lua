-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef, useState = react.useEffect, react.useMemo, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default8 = RuntimeLib.import(script, script.Parent, "aquarium-fish-item").default
local default9 = RuntimeLib.import(script, script.Parent, "aquarium-skin-item").default
local default10 = RuntimeLib.import(script, script.Parent, "glow-sparkle").default
local default11 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-badge").default
local default12 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local AquariumSkinSource = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").AquariumSkinSource

local function AquariumActionPanel(p1) -- line: 26
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), default2 (copy), default4 (copy), default12 (copy), tutorialSteps (copy), abbreviate (copy)
    local isClosing, canLevelUp, isExclusive, isMaxLevel = p1.isClosing, p1.canLevelUp, p1.isExclusive, p1.isMaxLevel
    local v1 = isMaxLevel

    if isMaxLevel == nil then
        v1 = false
        isMaxLevel = false
    end

    local layoutOrder, levelUpCost, onCloseComplete, onLevelUp = p1.layoutOrder, p1.levelUpCost, p1.onCloseComplete, p1.onLevelUp
    local onRemove, tutorialStep = p1.onRemove, p1.tutorialStep
    local v2, v3 = useMotion(0)
    local v4 = useRef(onCloseComplete)

    v4.current = onCloseComplete
    useEffect(function() -- line: 43
        -- upvalues: isClosing (copy), v3 (copy), v4 (copy)
        if isClosing then
            v3:tween(0, {
                time = 0.25,
                style = Enum.EasingStyle.Linear
            })

            local v5 = task.delay(0.25, function() -- line: 49
                -- upvalues: v4 (copy)
                return v4.current()
            end)

            return function() -- line: 52
                -- upvalues: v5 (copy)
                return task.cancel(v5)
            end
        end

        v3:tween(1, {
            time = 0.25,
            style = Enum.EasingStyle.Linear
        })
    end, { isClosing, v3 })

    local v6 = canLevelUp

    if canLevelUp then
        v6 = not isExclusive

        if v6 then
            v6 = not isMaxLevel

            if v6 then
                v6 = levelUpCost ~= nil and tutorialStep == tutorialSteps.levelUpFish
            end
        end
    end

    local v7 = isExclusive or isMaxLevel or canLevelUp and levelUpCost ~= nil
    local v8 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0.05, 0),
        PaddingLeft = UDim.new(0.04, 0),
        PaddingRight = UDim.new(0.04, 0),
        PaddingTop = UDim.new(0.05, 0)
    })
    local v9 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.15, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    if v7 then
        local t1 = {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.6)
            }
        }

        if isExclusive then
            t1.text = "CANNOT LEVEL UP"
        elseif isMaxLevel then
            t1.text = "MAX LEVEL"
        else
            if levelUpCost == nil then
                levelUpCost = 0
            end

            t1.text = ("LEVEL UP ($%*)"):format((abbreviate(levelUpCost)))
        end

        v7 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            LayoutOrder = 0,
            Size = v2:map(function(p2) -- line: 110
                return UDim2.fromScale(1, 0.42 * p2)
            end),
            Transparency = v2:map(function(p3) -- line: 113
                return 1 - p3
            end)
        }, react.createElement(default2, {
            cornerRadius = 0.08,
            isStudded = true,
            isStuddedTransparency = 0.2,
            strokeThickness = 0.04,
            textureTransparency = 0.75,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = if isExclusive then ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 85, 95)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 55))
            }) else ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
            }),
            onClick = function() -- onClick | line: 122
                -- upvalues: isExclusive (copy), v1 (ref), onLevelUp (copy)
                if not isExclusive and not v1 then
                    onLevelUp()
                end
            end,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = if isExclusive then Color3.fromRGB(160, 160, 170) else Color3.fromRGB(180, 255, 120)
        }, react.createElement(default4, t1)), v6 and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.425, 0),
            Size = UDim2.fromScale(0.3, 1)
        }, react.createElement(default12, {
            direction = "down",
            size = UDim2.fromScale(1.5, 1.5)
        })))
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }, v8, v9, v7, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        LayoutOrder = 1,
        Size = v2:map(function(p4) -- line: 156
            return UDim2.fromScale(1, 0.42 * p4)
        end)
    }, react.createElement(default2, {
        cornerRadius = 0.08,
        isStudded = true,
        isStuddedTransparency = 0.2,
        strokeThickness = 0.04,
        textureTransparency = 0.75,
        zIndex = 3,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = Color3.fromRGB(200, 40, 40),
        onClick = onRemove,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 160, 160)
    }, react.createElement(default4, {
        text = "TAKE OUT",
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.8, 0.6)
        }
    }))))
end

local function TabButton(p5) -- line: 185
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default5 (copy), default10 (copy), default11 (copy)
    local isActive, label, newCount, onClick = p5.isActive, p5.label, p5.newCount, p5.onClick
    local v11, v12 = useMotion(if isActive then 1.05 else 1)

    useEffect(function() -- line: 191
        -- upvalues: isActive (copy), v12 (copy)
        v12:tween(isActive and 1.05 or 1, {
            time = 0.2,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })
    end, { isActive, v12 })

    local v14 = UDim2.fromScale(0.35, 1)
    local v15 = v11:map(function(p6) -- line: 199
        -- upvalues: v14 (copy)
        return UDim2.new(v14.X.Scale * p6, 0, v14.Y.Scale * p6, 0)
    end)
    local v16 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 224, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 99, 227))
    })
    local v17 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(161, 8, 247)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 222))
    })
    local v18 = label == "SKINS"
    local v19

    if v18 then
        v19 = Color3.fromRGB(70, 10, 130)
    else
        v17 = v16
        v19 = Color3.fromRGB(30, 35, 55)
    end

    local v20 = UDim2.fromScale(0.8, 0.8)
    local v21 = UDim2.fromScale(0.6, 0.6)
    local createElement = react.createElement
    local t6 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = v15
    }
    local v22 = react.createElement(default5, {
        zIndex = 20,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v17,
        frameSize = UDim2.fromScale(1, 1),
        label = label,
        onClick = onClick,
        popoutColor = v19,
        position = UDim2.fromScale(0.5, 0.5),
        strokeColor = if v18 then Color3.new(1, 1, 1) else nil
    })

    v18 = v18 and react.createElement(react.Fragment, nil, react.createElement(default10, {
        zIndex = 25,
        position = UDim2.fromScale(0.98, 0.05),
        size = v20
    }), react.createElement(default10, {
        zIndex = 25,
        position = UDim2.fromScale(0.015, 0.925),
        size = v21
    }), newCount ~= nil and newCount > 0 and react.createElement(default11, {
        aspectRatio = 1,
        zIndex = 30,
        anchorPoint = Vector2.new(0, 0),
        position = UDim2.fromScale(-0.035, -0.1),
        size = UDim2.fromScale(0.55, 0.55),
        text = tostring(newCount)
    }))

    return createElement("frame", t6, v22, v18)
end

return {
    default = function(p7) -- AquariumMenu | line: 242
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), default7 (copy), images (copy), default8 (copy), default9 (copy), default12 (copy), tutorialSteps (copy), AquariumSkinSource (copy), AquariumActionPanel (copy), TabButton (copy)
        local capacity, equippedSkin, fish, getInitialTab = p7.capacity, p7.equippedSkin, p7.fish, p7.getInitialTab
        local indexEarningsBoost, onClearInitialTab, newSkinCount, onAddFish = p7.indexEarningsBoost, p7.onClearInitialTab, p7.newSkinCount, p7.onAddFish
        local onClose, onEquipBest, onEquipSkin, onLevelUp = p7.onClose, p7.onEquipBest, p7.onEquipSkin, p7.onLevelUp
        local onOpenSourceWindow, onPreviewSkin, onPurchaseSkin, onRemove = p7.onOpenSourceWindow, p7.onPreviewSkin, p7.onPurchaseSkin, p7.onRemove
        local onSkinsTab, onViewStats, ownedSkins, refreshKey = p7.onSkinsTab, p7.onViewStats, p7.ownedSkins, p7.refreshKey
        local skins, tutorialStep = p7.skins, p7.tutorialStep
        local v23, v24 = useState(function() -- line: 266
            -- upvalues: getInitialTab (copy), onClearInitialTab (copy)
            local v25 = getInitialTab()

            onClearInitialTab()

            return v25 or "fishes"
        end)
        local v26, v27 = useState(nil)
        local v28, v29 = useState(nil)
        local v30 = useRef(v26)

        v30.current = v26

        local v31 = useRef(nil)
        local v32, v33 = useState(function() -- line: 276
            -- upvalues: fish (copy)
            local v34 = table.create(#fish)

            local function v35(p8) -- line: 279
                return p8.fishId
            end

            for v36, v37 in fish do
                local _ = v36 - 1

                v34[v36] = v37.fishId
            end

            return v34
        end)
        local v38 = useRef(refreshKey)
        local v39

        if v38.current ~= refreshKey then
            v38.current = refreshKey

            local v40 = table.create(#fish)

            v39 = function(p9) -- line: 293
                return p9.fishId
            end

            for v41, v42 in fish do
                local _ = v41 - 1

                v40[v41] = v42.fishId
            end

            v33(v40)
        end

        local v43 = useMemo(function() -- line: 302
            -- upvalues: fish (copy)
            local t8 = {}

            for v44, v45 in fish do
                local _ = v44 - 1

                t8[v45.fishId] = v45
            end

            return t8
        end, { fish })
        local v46 = useMemo(function() -- line: 317
            -- upvalues: fish (copy), v32 (copy), v43 (copy)
            local t9 = {}
            local t10 = {}

            for v47, v48 in v32 do
                local _ = v47 - 1
                local v49 = v43[v48]

                if v49 ~= nil then
                    table.insert(t9, v49)
                    t10[v48] = true
                end
            end

            for v50, v51 in fish do
                local _ = v50 - 1

                if t10[v51.fishId] == nil then
                    table.insert(t9, v51)
                end
            end

            return t9
        end, { fish, v43, v32 })

        if v26 ~= nil and v43[v26] == nil then
            v27(nil)
            v29(nil)
        end

        useEffect(function() -- line: 352
            -- upvalues: tutorialStep (copy), v26 (copy), v27 (copy), v29 (copy), v46 (copy), tutorialSteps (copy)
            if tutorialStep ~= tutorialSteps.levelUpFish or not (#v46 > 0) or v26 ~= nil then
                return
            end

            local fishId = v46[1].fishId

            v27(fishId)
            v29(fishId)
        end, { tutorialStep, v46, v26 })

        local function v52(p10) -- line: 359
            -- upvalues: v26 (copy), v27 (copy), v28 (copy), v29 (copy), v31 (copy), v46 (copy)
            local v53 = if v26 == p10 then nil else p10

            v27(v53)

            if v28 == nil and v53 ~= nil then
                v29(v53)
            end

            if v53 == nil then
                return
            end

            local n1 = -1

            for v54, v55 in v46 do
                local _ = v54 - 1

                if v55.fishId == v53 == true then
                    n1 = v54 - 1
                    break
                end

                n1 = -1
            end

            task.delay(0, function() -- line: 379
                -- upvalues: n1 (ref), v31 (copy), v46 (copy)
                local current = v31.current

                if current and current.AbsoluteSize.Y ~= 0 then
                    local v56 = #v46 + 1
                    local v57 = current.AbsoluteCanvasSize.Y / v56
                    local v58 = (n1 + 2) * v57

                    if current.CanvasPosition.Y + current.AbsoluteSize.Y < v58 then
                        current.CanvasPosition = Vector2.new(0, v58 - current.AbsoluteSize.Y)
                    end

                    return
                end

                return nil
            end)
        end

        local function v59() -- line: 394
            -- upvalues: v29 (copy), v30 (copy)
            v29(v30.current)
        end

        v39 = v23 == "fishes"
        v23 = if v39 then ("%*/%* Max"):format(#v46, capacity) else ("%*/%* Owned"):format(#ownedSkins, #skins)

        local t11 = {}

        local function v60(p11, p12) -- line: 402
            -- upvalues: onLevelUp (copy), onRemove (copy), tutorialStep (copy), v26 (copy), v28 (copy), v52 (copy), v59 (copy), t11 (copy), react (copy), default8 (copy), AquariumActionPanel (copy)
            table.insert(t11, (react.createElement(default8, {
                fishId = p11.fishId,
                fishName = p11.fishName,
                imageId = p11.imageId,
                isActive = v26 == p11.fishId,
                key = p11.fishId,
                layoutOrder = p12 * 2,
                level = p11.level,
                levelUpCost = p11.levelUpCost,
                moneyPerSecond = p11.moneyPerSecond,
                mutation = p11.mutation,
                offlineEarningPerSec = p11.offlineEarningPerSec,
                onClick = function() -- onClick | line: 415
                    -- upvalues: p11 (copy), v52 (copy)
                    return v52(p11.fishId)
                end,
                rarity = p11.rarity
            })))

            if v28 ~= p11.fishId then
                return
            end

            table.insert(t11, (react.createElement(AquariumActionPanel, {
                canLevelUp = p11.levelUpCost ~= nil,
                isClosing = v26 ~= p11.fishId,
                isExclusive = p11.isExclusive,
                isMaxLevel = p11.isMaxLevel,
                key = ("action-%*"):format(p11.fishId),
                layoutOrder = p12 * 2 + 1,
                levelUpCost = p11.levelUpCost,
                onCloseComplete = v59,
                onLevelUp = function() -- onLevelUp | line: 431
                    -- upvalues: p11 (copy), onLevelUp (copy)
                    return onLevelUp(p11.fishId)
                end,
                onRemove = function() -- onRemove | line: 434
                    -- upvalues: p11 (copy), onRemove (copy)
                    return onRemove(p11.fishId)
                end,
                tutorialStep = tutorialStep
            })))
        end

        for v63, v64 in v46 do
            v60(v64, v63 - 1, v46)
        end

        local t14 = {
            common = 0,
            uncommon = 1,
            rare = 2,
            epic = 3,
            legendary = 4,
            mythic = 5,
            godly = 6,
            secret = 7,
            hacked = 8,
            cosmic = 9
        }
        local t15 = {}
        local v65 = {}
        local v66 = #v65

        table.move(skins, 1, #skins, v66 + 1, v65)
        table.sort(v65, function(p13, p14) -- line: 463
            -- upvalues: t14 (copy)
            local v67 = t14[p13.rarity]

            if v67 == nil then
                v67 = 0
            end

            local v68 = t14[p14.rarity]

            if v68 == nil then
                v68 = 0
            end

            return v67 < v68
        end)

        v66 = function(p15, p16) -- line: 476
            -- upvalues: equippedSkin (copy), onEquipSkin (copy), onOpenSourceWindow (copy), onPreviewSkin (copy), onPurchaseSkin (copy), ownedSkins (copy), t15 (copy), react (copy), default9 (copy), AquariumSkinSource (copy)
            local name = p15.name
            local v69 = table.find(ownedSkins, name) ~= nil
            local v70 = equippedSkin == p15.name
            local v71 = if v69 and v70 then "equipped"
                elseif v69 then "equip"
                elseif p15.name == "FOMO" then "none"
                elseif p15.source == AquariumSkinSource.DailyReward then "source-daily-reward"
                elseif p15.source == AquariumSkinSource.CelebrationEventShop then "source-event-shop"
                elseif p15.source == AquariumSkinSource.ExclusiveShop then "source-exclusive-shop"
                elseif p15.source == AquariumSkinSource.SpinWheel then "source-spin-wheel"
                elseif p15.source == AquariumSkinSource.Index then "source-index"
                elseif p15.robuxPrice == nil then "purchase-money"
                else "purchase-robux"

            table.insert(t15, (react.createElement(default9, {
                buttonState = v71,
                description = p15.description,
                displayName = p15.displayName,
                imageId = p15.imageId,
                key = p15.name,
                layoutOrder = p16,
                moneyBoost = p15.moneyBoost,
                moneyPrice = p15.moneyPrice,
                name = p15.name,
                onAction = function() -- onAction | line: 512
                    -- upvalues: p15 (copy), v69 (copy), v70 (copy), onEquipSkin (copy), onOpenSourceWindow (copy), onPurchaseSkin (copy), AquariumSkinSource (copy)
                    local v72

                    if v69 then
                        v72 = v70
                    else
                        if p15.source == AquariumSkinSource.DailyReward then
                            onOpenSourceWindow(AquariumSkinSource.DailyReward)

                            return
                        end

                        if p15.source == AquariumSkinSource.CelebrationEventShop then
                            onOpenSourceWindow(AquariumSkinSource.CelebrationEventShop)

                            return
                        end

                        if p15.source == AquariumSkinSource.ExclusiveShop then
                            onOpenSourceWindow(AquariumSkinSource.ExclusiveShop)

                            return
                        end

                        if p15.source == AquariumSkinSource.SpinWheel then
                            onOpenSourceWindow(AquariumSkinSource.SpinWheel)

                            return
                        end

                        if p15.source == AquariumSkinSource.Index then
                            onOpenSourceWindow(AquariumSkinSource.Index)

                            return
                        end

                        if p15.source == AquariumSkinSource.SkinCrate then
                            onOpenSourceWindow(AquariumSkinSource.SkinCrate)

                            return
                        end

                        onPurchaseSkin(p15.name)
                    end

                    if not (v69 and v72 or not v69) then
                        onEquipSkin(p15.name)
                    end
                end,
                onPreview = function() -- onPreview | line: 533
                    -- upvalues: p15 (copy), onPreviewSkin (copy)
                    return onPreviewSkin(p15.name)
                end,
                rarity = p15.rarity,
                robuxPrice = p15.robuxPrice,
                source = p15.source
            })))
        end

        for v74, v75 in v65 do
            v66(v75, v74 - 1, v65)
        end

        local createElement = #skins

        v66 = 0

        local v76, createElement2

        for i = 1, createElement do
            v76 = skins[i]
            createElement2 = i - 1
            createElement2 = v76.name

            if table.find(ownedSkins, createElement2) ~= nil and v76.moneyBoost ~= nil then
                v66 += v76.moneyBoost
            end
        end

        v66 = math.round((v66 + indexEarningsBoost) * 100)

        if v39 then
            v65 = UDim2.fromScale(0.94, 0.58)
            indexEarningsBoost = 3.25
        else
            v65 = UDim2.fromScale(0.94, 0.78)
            indexEarningsBoost = 2.5
        end

        createElement = react.createElement

        local t17 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.841, 0.55),
            Size = UDim2.fromScale(0.275, 0.75)
        }
        local v77 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.65,
            DominantAxis = Enum.DominantAxis.Width
        })

        v76 = react.createElement

        local v78 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, -0.025),
            Size = UDim2.fromScale(1, 0.06)
        }
        local v79 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
        local v80 = react.createElement(TabButton, {
            label = "FISHES",
            isActive = v39,
            onClick = function() -- onClick | line: 595
                -- upvalues: v24 (copy)
                return v24("fishes")
            end
        })

        v76 = v76("frame", v78, v79, v80, react.createElement(TabButton, {
            label = "SKINS",
            isActive = not v39,
            newCount = newSkinCount,
            onClick = function() -- onClick | line: 602
                -- upvalues: onSkinsTab (copy), v24 (copy), v26 (copy), v27 (copy)
                if v26 ~= nil then
                    v27(nil)
                end

                if onSkinsTab ~= nil then
                    onSkinsTab()
                end

                v24("skins")
            end
        }))
        createElement2 = react.createElement
        v79 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }
        v80 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        })

        local createElement3 = react.createElement
        local t19 = {
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.005,
            textureTransparency = 0.9,
            transparency = 0.5,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(55, 65, 90),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(80, 95, 130)
        }
        local createElement4 = react.createElement
        local v81 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.015),
            Size = UDim2.fromScale(0.94, 0.13)
        }
        local createElement5 = react.createElement
        local t20 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0.5)
        }

        if v39 then
            t20.Position = UDim2.fromScale(0, 0.5)
        else
            t20.Position = UDim2.fromScale(0, 0.65)
        end

        t20.Size = UDim2.fromScale(0.82, 1)

        local v82 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v83 = react.createElement(default4, {
            text = "AQUARIUM",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 0,
                TextScaled = true,
                ZIndex = 6,
                Font = Enum.Font.GothamBlack,
                Size = UDim2.fromScale(1, 0.52),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        })
        local createElement6 = react.createElement
        local t21 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 6,
            Size = UDim2.fromScale(0.75, 0.32)
        }
        local createElement7 = react.createElement
        local t22 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(0.62, 1),
            Text = v23
        }

        if not v39 or #fish ~= capacity then
            local v84 = if not v39 then #ownedSkins == #skins else nil

            t22.TextColor3 = if v39 or not v84 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(80, 255, 80)
        else
            t22.TextColor3 = Color3.fromRGB(255, 60, 60)
        end

        t22.TextXAlignment = Enum.TextXAlignment.Left
        createElement4 = createElement4("frame", v81, createElement5("frame", t20, v82, v83, createElement6("frame", t21, createElement7("textlabel", t22, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.fromRGB(0, 0, 0)
        })), v39 and react.createElement(default5, {
            cornerRadius = 0.25,
            label = "VIEW STATS",
            zIndex = 6,
            anchorPoint = Vector2.new(1, 0.5),
            color = Color3.fromRGB(148, 61, 237),
            frameSize = UDim2.fromScale(0.42, 1),
            onClick = onViewStats,
            popoutColor = Color3.fromRGB(60, 25, 95),
            position = UDim2.fromScale(0.9, 0.5)
        })), not v39 and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 6,
            Size = UDim2.fromScale(1, 0.28)
        }, react.createElement(default7, {
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = Enum.Font.GothamBold,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = ("TOTAL: +%*%% MONEY"):format(v66),
            textColor3 = Color3.fromRGB(80, 255, 80)
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.12, 0.85)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default3, {
            cornerRadius = 0.15,
            zIndex = 7,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 43, 43),
            onClick = onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 179, 179)
        }, react.createElement(default4, {
            shadowYScale = 0.08,
            text = "X",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7)
            }
        }))))

        local v85

        if v39 then
            v85 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.165),
                Size = UDim2.fromScale(0.94, 0.09)
            }, react.createElement(default2, {
                cornerRadius = 0.08,
                isStudded = true,
                isStuddedTransparency = 0.2,
                strokeThickness = 0.04,
                textureTransparency = 0.75,
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(41, 240, 10)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
                }),
                onClick = onEquipBest,
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(180, 255, 120)
            }, react.createElement(default4, {
                text = "EQUIP BEST FISH",
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 8,
                    TextXAlignment = "Center",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = Enum.Font.GothamBlack,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.8, 0.6)
                }
            })))
            v81 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.28),
                Size = UDim2.fromScale(0.94, 0.09)
            }, react.createElement(default2, {
                cornerRadius = 0.08,
                isStudded = true,
                isStuddedTransparency = 0.2,
                strokeThickness = 0.04,
                textureTransparency = 0.75,
                zIndex = 5,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = Color3.fromRGB(55, 55, 55),
                onClick = onAddFish,
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(100, 100, 100)
            }, react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                ZIndex = 8,
                AnchorPoint = Vector2.new(0, 0.5),
                Image = images.fishIcon,
                Position = UDim2.fromScale(0.22, 0.5),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromScale(0.85, 0.85)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1,
                DominantAxis = Enum.DominantAxis.Height
            })), react.createElement(default4, {
                text = "ADD FISH",
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 8,
                    TextXAlignment = "Center",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = Enum.Font.GothamBlack,
                    Position = UDim2.fromScale(0.55, 0.5),
                    Size = UDim2.fromScale(0.8, 0.6)
                }
            })))
        else
            v81 = v39
            v85 = v39
        end

        createElement5 = react.createElement
        t20 = {
            cellsPerRow = 1,
            listPaddingOffset = 6,
            scrollBarThickness = 4,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 1),
            fillDirection = Enum.FillDirection.Horizontal,
            position = UDim2.fromScale(0.5, 0.98)
        }

        if v39 then
            t20.ref = v31
        else
            t20.ref = nil
        end

        t20.rowsToBeVisible = indexEarningsBoost
        t20.scrollBarColor = Color3.fromRGB(10, 10, 10)
        t20.size = v65
        t20.verticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        v82 = if v39 then t11 else t15
        createElement2 = createElement2("frame", v79, v80, createElement3(default, t19, createElement4, v85, v81, createElement5(default6, t20, v82)))
        v78 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(59, 59, 59),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))
        v79 = tutorialStep == tutorialSteps.equipBestFish and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.475, 0.15),
            Size = UDim2.fromScale(0.08, 0.1)
        }, react.createElement(default12, {
            direction = "down",
            size = UDim2.fromScale(1.5, 1.5)
        }))
        v80 = tutorialStep == tutorialSteps.levelUpFish and v26 == nil and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.475, 0.4),
            Size = UDim2.fromScale(0.16, 0.2)
        }, react.createElement(default12, {
            direction = "down",
            size = UDim2.fromScale(1.5, 1.5)
        }))
        createElement3 = tutorialStep == tutorialSteps.collectMoney and react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.915, 0.085),
            Size = UDim2.fromScale(0.08, 0.1)
        }, react.createElement(default12, {
            direction = "up",
            size = UDim2.fromScale(1.5, 1.5)
        }))

        return createElement("frame", t17, v77, v76, createElement2, v78, v79, v80, createElement3)
    end
}

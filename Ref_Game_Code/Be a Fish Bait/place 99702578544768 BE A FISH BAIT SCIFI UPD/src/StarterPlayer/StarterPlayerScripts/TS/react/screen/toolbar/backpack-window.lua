-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext, useEffect, useRef, useState = react.useContext, react.useEffect, react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local default3 = RuntimeLib.import(script, script.Parent, "backpack-item").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "trash-mode.selectors")
local selectTrashModeEnabled, selectTrashModeSelectedItemIds = v1.selectTrashModeEnabled, v1.selectTrashModeSelectedItemIds
local maxBackpackCapacity = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "inventory-utils").maxBackpackCapacity
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local trainingWeightsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "training-weights").trainingWeightsData
local default4 = RuntimeLib.import(script, script.Parent, "tooltip").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default6 = RuntimeLib.import(script, script.Parent.Parent, "hud", "search-bar").default
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default8 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default9 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v2 = RuntimeLib.import(script, script.Parent, "toolbar-drag-drop")
local dispatchToolbarDrop, registerToolbarDropZone = v2.dispatchToolbarDrop, v2.registerToolbarDropZone
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel, showcaseFishToMpsInput = v3.getAquariumFishEffectiveMoneyPerSecond, v3.getExclusiveFishEditionLabel, v3.showcaseFishToMpsInput
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumFishItems, selectPlayerGamepasses, selectPlayerInventory, selectPlayerMounts = selectors.selectPlayerAquariumFishItems, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory, selectors.selectPlayerMounts
local selectPlayerShowcaseFish = selectors.selectPlayerShowcaseFish
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local default10 = RuntimeLib.import(script, script.Parent, "mounts-tab").default
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish")
local getMountFishData, mountFishData = v4.getMountFishData, v4.mountFishData
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local mountsTabOpenRequestedAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "mount-backpack-tab-request-atom").mountsTabOpenRequestedAtom
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase

local function v5(p1) -- line: 58
    -- upvalues: fishDataByName (copy), isFishData (copy), trainingWeightsData (copy), fishingRodsData (copy)
    if p1.itemType == "fish" then
        local v6 = fishDataByName[p1.itemName]

        return if v6 ~= nil and isFishData(v6) then v6.rarity else nil
    end

    if p1.itemType == "fishingRod" then
        local v7 = fishingRodsData[p1.itemName]

        if v7 ~= nil then
            v7 = v7.rarity
        end

        return v7
    end

    if p1.itemType ~= "trainingWeight" then
        return nil
    end

    local v8 = trainingWeightsData[p1.itemName]

    if v8 ~= nil then
        v8 = v8.rarity
    end

    return v8
end

local function v9(p2) -- line: 82
    -- upvalues: fishDataByName (copy), fishingRodsData (copy)
    if p2.itemType == "fishingRod" then
        local v10 = fishingRodsData[p2.itemName]

        if v10 ~= nil then
            v10 = v10.imageId
        end

        if v10 == nil then
            v10 = ""
        end

        return v10
    end

    if p2.itemType == "fish" then
        local v11 = fishDataByName[p2.itemName]

        if v11 ~= nil then
            v11 = v11.imageId
        end

        if v11 == nil then
            v11 = ""
        end

        return v11
    end

    if p2.itemType == "emote" then
        return p2.imageId
    end

    return ""
end

local function BackpackUpgradeButton(p3) -- line: 111
    -- upvalues: react (copy), default3 (copy)
    return react.createElement(default3, {
        imageId = "rbxassetid://18619915727",
        imageSizeScale = 0.6,
        isDraggable = false,
        isSelectedForDeletion = false,
        itemId = "backpack-capacity-upgrade",
        itemName = "Backpack Capacity Upgrade",
        itemType = "fish",
        layoutOrder = p3.layoutOrder,
        onClick = p3.onClick,
        size = p3.size
    })
end

local v12 = Color3.fromRGB(90, 170, 245)
local v13 = Color3.fromRGB(245, 195, 70)
local v14 = Color3.fromRGB(170, 90, 245)
local v15 = Color3.fromRGB(90, 220, 130)
local v16 = Color3.fromRGB(245, 150, 60)
local t1 = {
    "fishes",
    "mounts",
    "placeholderPurple",
    "placeholderGreen",
    "placeholderOrange"
}

local function getBackpackTabColor(p4) -- line: 132
    -- upvalues: v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy)
    if p4 == "fishes" then
        return v12
    end

    if p4 == "mounts" then
        return v13
    end

    if p4 == "placeholderPurple" then
        return v14
    end

    if p4 == "placeholderGreen" then
        return v15
    end

    if p4 == "placeholderOrange" then
        return v16
    end
end

local function getBackpackTabLabel(p5) -- line: 151
    if p5 == "fishes" then
        return "Fishes"
    end

    if p5 == "mounts" then
        return "Mounts"
    end

    return "Placeholder"
end

local function getBackpackHeaderTitle(p6, p7, p8, p9, p10, p11) -- line: 165
    if p6 == "fishes" then
        return (("%* [%*/%*]"):format(p7, p8, p9))
    end

    if p6 == "mounts" then
        return (("Fish Mounts [%*/%*]"):format(p10, p11))
    end

    return "Placeholder"
end

local function isPlaceholderTab(p12) -- line: 176
    if p12 == "placeholderPurple" or p12 == "placeholderGreen" then
        return true
    end

    return p12 == "placeholderOrange"
end

local function getTabRowFadeGradient(p13, p14, p15) -- line: 199
    local v18 = math.min(0.45, 28 / math.max(p15, 1))

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, if p13 then 1 else 0),
        NumberSequenceKeypoint.new(v18, 0),
        NumberSequenceKeypoint.new(1 - v18, 0),
        NumberSequenceKeypoint.new(1, if p14 then 1 else 0)
    })
end

return {
    default = function(p16) -- BackpackWindow | line: 212
        -- upvalues: Flamework (copy), react (copy), useContext (copy), useEffect (copy), useRef (copy), useState (copy), default (copy), default2 (copy), ThemeContext (copy), default3 (copy), useRootProducer (copy), useRootSelector (copy), selectTrashModeEnabled (copy), selectTrashModeSelectedItemIds (copy), maxBackpackCapacity (copy), fishDataByName (copy), isFishData (copy), default4 (copy), default5 (copy), default6 (copy), fishingRodsData (copy), default7 (copy), default8 (copy), default9 (copy), useScreenSizeState (copy), dispatchToolbarDrop (copy), registerToolbarDropZone (copy), getMutatedMoneyPerSecond (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), showcaseFishToMpsInput (copy), selectPlayerAquariumFishItems (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerMounts (copy), selectPlayerShowcaseFish (copy), localPlayerUserId (copy), getExclusiveFishConfigByFishName (copy), functions (copy), default10 (copy), getMountFishData (copy), mountFishData (copy), subscribe (copy), mountsTabOpenRequestedAtom (copy), attemptStorePurchase (copy), v5 (copy), BackpackUpgradeButton (copy), t1 (copy), getBackpackTabColor (copy), getBackpackHeaderTitle (copy), getTabRowFadeGradient (copy)
        local v19 = useContext(ThemeContext)
        local v20 = useScreenSizeState()
        local v21, v22, v23, v24, v25, v26

        if v20 == "sm" or v20 == "md" then
            v20 = 0.65
            v26 = 1.25
            v21 = 52
            v24 = 100
            v22 = 8
            v23 = 5
            v25 = 40
        else
            v20 = 0.69
            v26 = 1
            v21 = 72
            v24 = 160
            v22 = 12
            v23 = 8
            v25 = 68
        end

        local totalBackpackFishCount = p16.totalBackpackFishCount
        local maxItemCount = p16.maxItemCount

        if maxItemCount == nil then
            maxItemCount = maxBackpackCapacity
        end

        local title = p16.title

        if title == nil then
            title = "Stored Fishes"
        end

        local v27 = useRootProducer()
        local v28 = useRootSelector(selectTrashModeEnabled)
        local v29 = useRootSelector(selectTrashModeSelectedItemIds)
        local v30 = useRootSelector(selectPlayerAquariumFishItems(localPlayerUserId))
        local v31 = useRootSelector(selectPlayerGamepasses(localPlayerUserId))
        local v32 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v34 = showcaseFishToMpsInput((useRootSelector(selectPlayerShowcaseFish(localPlayerUserId))))
        local v35 = useRootSelector(selectPlayerMounts(localPlayerUserId))
        local showMountsTab = p16.showMountsTab

        if showMountsTab == nil then
            showMountsTab = false
        end

        local v36, v37 = useState(function() -- line: 254
            -- upvalues: showMountsTab (ref), mountsTabOpenRequestedAtom (copy)
            if showMountsTab and mountsTabOpenRequestedAtom() then
                mountsTabOpenRequestedAtom(false)

                return "mounts"
            end

            return "fishes"
        end)

        useEffect(function() -- line: 261
            -- upvalues: showMountsTab (ref), v37 (copy), subscribe (copy), mountsTabOpenRequestedAtom (copy)
            if showMountsTab then
                return subscribe(mountsTabOpenRequestedAtom, function(p17) -- line: 265
                    -- upvalues: v37 (copy), mountsTabOpenRequestedAtom (copy)
                    if not p17 then
                        return nil
                    end

                    mountsTabOpenRequestedAtom(false)
                    v37("mounts")
                end)
            end

            return nil
        end, { showMountsTab })

        local v38 = useRef()
        local v39, v40 = useState({
            canScrollLeft = false,
            canScrollRight = false,
            viewportWidthPixels = 112
        })

        useEffect(function() -- line: 279
            -- upvalues: showMountsTab (ref), v38 (copy), v40 (copy)
            if not showMountsTab then
                return nil
            end

            local current = v38.current

            if current == nil then
                return nil
            end

            local function v41() -- line: 287
                -- upvalues: current (copy), v40 (copy)
                local X = current.AbsoluteCanvasSize.X
                local X2 = current.AbsoluteWindowSize.X
                local X3 = current.CanvasPosition.X

                v40({
                    canScrollLeft = X3 > 1,
                    canScrollRight = X3 < X - X2 - 1,
                    viewportWidthPixels = X2
                })
            end

            local X = current.AbsoluteCanvasSize.X
            local X2 = current.AbsoluteWindowSize.X
            local X3 = current.CanvasPosition.X

            v40({
                canScrollLeft = X3 > 1,
                canScrollRight = X3 < X - X2 - 1,
                viewportWidthPixels = X2
            })

            local t2 = {
                current:GetPropertyChangedSignal("CanvasPosition"):Connect(v41),
                current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v41),
                current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(v41)
            }

            return function() -- line: 299
                -- upvalues: t2 (copy)
                local function v42(p18) -- line: 301
                    return p18:Disconnect()
                end

                for v43, v44 in t2 do
                    local _ = v43 - 1

                    v44:Disconnect()
                end
            end
        end, { showMountsTab })

        local function v45(p19) -- line: 310
            -- upvalues: functions (copy)
            functions.equipMount(p19):catch(function(p20) -- line: 311
                warn("[src/client/react/screen/toolbar/backpack-window.tsx:329]", (("Mount equip request failed: %*"):format(p20)))
            end)
        end

        local function v46(p21) -- line: 315
            -- upvalues: getMountFishData (copy), attemptStorePurchase (copy)
            local v47 = getMountFishData(p21)

            if v47 == nil then
                return nil
            end

            attemptStorePurchase(v47.productId)
        end

        local function v48(p22) -- line: 322
            -- upvalues: p16 (copy), Flamework (copy)
            p16.onClose()
            Flamework.resolveDependency("client/controllers/mount-fish-preview-controller@MountFishPreviewController"):startPreview(p22)
        end

        local v49 = useRef()
        local v50, v51 = useState(nil)
        local v52, v53 = useState("")
        local v54, v55 = useState(nil)

        local function v56(p23, p24, p25, p26, p27, p28) -- line: 330
            -- upvalues: v30 (copy), v31 (copy), v32 (copy), v34 (copy), v49 (copy), v51 (copy), fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishConfigByFishName (copy)
            local v57 = if p26 == nil then 1 else p26

            if p24 ~= "fish" then
                return nil
            end

            local v58 = fishDataByName[p23]

            if not (v58 and isFishData(v58)) then
                return nil
            end

            local current = v49.current

            if current == nil then
                return nil
            end

            local AbsolutePosition, AbsoluteSize = current.AbsolutePosition, current.AbsoluteSize
            local AbsolutePosition2, AbsoluteSize2 = p25.AbsolutePosition, p25.AbsoluteSize
            local v59 = (AbsolutePosition2.X + AbsoluteSize2.X * 0.5 - AbsolutePosition.X) / AbsoluteSize.X
            local v60 = (AbsolutePosition2.Y - AbsolutePosition.Y) / AbsoluteSize.Y
            local v61 = if getExclusiveFishConfigByFishName(p23) == nil then getMutatedMoneyPerSecond(v58.moneyPerSecond, v57, p27 or {}) else getAquariumFishEffectiveMoneyPerSecond({
                fishId = p23,
                fishSpecies = p23,
                level = v57,
                mutations = p27 or {}
            }, v30 or {}, v31, nil, 0, v32, v34)

            v51({
                exclusiveEditionLabel = p28,
                itemName = v58.displayName,
                moneyPerSecond = v61,
                mutations = p27,
                rarity = v58.rarity,
                tooltipX = v59,
                tooltipY = v60
            })
        end

        local function v62(p29) -- line: 368
            -- upvalues: p16 (copy), v27 (copy), v28 (copy)
            if v28 then
                print("[src/client/react/screen/toolbar/backpack-window.tsx:415] \"item Trash selected\" =", "item Trash selected")
                v27.itemTrashSelectionToggled({
                    itemId = p29
                })
            else
                print("[src/client/react/screen/toolbar/backpack-window.tsx:418] \"item clicked\" =", "item clicked")

                local onItemClick = p16.onItemClick

                if onItemClick ~= nil then
                    onItemClick(p29)
                end
            end
        end

        useEffect(function() -- line: 391
            -- upvalues: p16 (copy), v49 (copy), registerToolbarDropZone (copy)
            local v63 = registerToolbarDropZone({
                getObject = function() -- getObject | line: 393
                    -- upvalues: v49 (copy)
                    return v49.current
                end,
                onDrop = function(p30) -- onDrop | line: 396
                    -- upvalues: p16 (copy)
                    local onFishDroppedInBackpack = p16.onFishDroppedInBackpack

                    if onFishDroppedInBackpack ~= nil then
                        onFishDroppedInBackpack = onFishDroppedInBackpack(p30)
                    end

                    return onFishDroppedInBackpack
                end
            })

            return function() -- line: 404
                -- upvalues: v63 (copy)
                v63()
            end
        end, { p16.onFishDroppedInBackpack })

        local function v64(p31, p32) -- line: 408
            -- upvalues: p16 (copy), v55 (copy), dispatchToolbarDrop (copy)
            v55(nil)

            local onFishDragEnd = p16.onFishDragEnd

            if onFishDragEnd ~= nil then
                onFishDragEnd(p31, p32)
            end

            dispatchToolbarDrop(p31, p32)
        end

        local v65, v66, v67

        if v52 == "" then
            v65 = p16.excessItems
        else
            local excessItems = p16.excessItems

            v65 = {}
            v66 = 0

            for v68, v69 in excessItems do
                local v70 = v68 - 1

                v70 = string.lower(v69.itemName)
                v67 = string.lower(v52)

                if string.find(v70, v67) ~= nil == true then
                    v66 += 1
                    v65[v66] = v69
                end
            end
        end

        local v71 = if showMountsTab then 0.28 else 0.18
        local v72 = 0.98 - v71
        local v73 = v71 + v72 / 2

        v66 = react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })

        local v74 = react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ref = v49
        })
        local v75 = v54 ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.35,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v54.imageId,
            Position = UDim2.fromOffset(v54.position.X, v54.position.Y),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(v21, v21)
        })
        local v76 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 5)
        })

        v21 = {
            hasStroke = true,
            overrideProps = {
                ZIndex = 2,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.02, 0.5),
                Size = UDim2.fromScale(0.96, 0.6),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        }

        local v77 = if v35 == nil then v35 else #v35.ownedMountNames

        if v77 == nil then
            v77 = 0
        end

        local n1 = 0

        for _ in mountFishData do
            n1 += 1
        end

        v21.text = getBackpackHeaderTitle(v36, title, totalBackpackFishCount, maxItemCount, v77, n1)

        local v78 = react.createElement
        local v79 = {
            backgroundTransparency = 0.7,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.fromScale(1, 0.18)
        }

        v78 = v78(default, v79, v76, react.createElement(default2, v21), v36 == "fishes" and p16.onUpgradeClick ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.435, 0.6),
            Size = UDim2.fromScale(0.075, 0.72)
        }, react.createElement(BackpackUpgradeButton, {
            onClick = p16.onUpgradeClick,
            size = UDim2.fromScale(0.8, 0.8)
        })), react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(0.97, 0, 0, 2)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.99, 0.5),
            Size = UDim2.fromScale(0.38, 0.65)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0.03, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 22,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(0.18, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default7, {
            aspectRatio = 1,
            cornerRadius = 0.1,
            zIndex = 22,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 43, 43),
            onClick = p16.onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 179, 179)
        }, react.createElement(default8, {
            shadowYScale = 0.075,
            text = "X",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 25,
                Font = v19.textFont2,
                Size = UDim2.fromScale(0.8, 0.8)
            },
            position = UDim2.fromScale(0.5, 0.5)
        }))), react.createElement(default6, {
            layoutOrder = 1,
            zIndex = 3,
            anchorPoint = Vector2.new(0, 0.5),
            onQueryChanged = v53,
            position = UDim2.fromScale(0, 0.5),
            size = UDim2.fromScale(0.69, 1)
        })))

        if showMountsTab then
            local v81 = react.createElement("uigradient", {
                Transparency = getTabRowFadeGradient(v39.canScrollLeft, v39.canScrollRight, v39.viewportWidthPixels)
            })
            local v82 = react.createElement("uipadding", {
                PaddingLeft = UDim.new(0, v23),
                PaddingRight = UDim.new(0, v23)
            })
            local v83 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, v22),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local t4 = {}

            v21 = function(p33) -- line: 588
                return not (p33 == "placeholderPurple" or p33 == "placeholderGreen" or p33 == "placeholderOrange")
            end

            totalBackpackFishCount = 0

            for v84, v85 in t1 do
                local v86 = v84 - 1

                v86 = v85 == "placeholderPurple" or v85 == "placeholderGreen" or v85 == "placeholderOrange"

                if not v86 == true then
                    totalBackpackFishCount += 1
                    t4[totalBackpackFishCount] = v85
                end
            end

            local v87 = table.create(#t4)
            local v88 = v24

            totalBackpackFishCount = function(p34, p35) -- line: 601
                -- upvalues: v19 (copy), v36 (copy), v37 (copy), v88 (copy), react (copy), default9 (copy), getBackpackTabColor (copy)
                local v89 = v36 == p34

                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = p35,
                    Size = UDim2.new(0, v88, 1, 0),
                    key = p34
                }, react.createElement(default9, {
                    cornerRadius = 0.22,
                    zIndex = 4,
                    color = getBackpackTabColor(p34),
                    font = v19.textFont2,
                    frameSize = if v89 then UDim2.fromScale(0.92, 0.82) else UDim2.fromScale(0.86, 0.72),
                    label = if p34 == "fishes" then "Fishes" elseif p34 == "mounts" then "Mounts" else "Placeholder",
                    onClick = function() -- onClick | line: 614
                        -- upvalues: p34 (copy), v37 (copy)
                        return v37(p34)
                    end,
                    position = UDim2.fromScale(0.5, 0.5),
                    strokeColor = if v89 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(25, 25, 25)
                }))
            end

            for v90, v91 in t4 do
                v87[v90] = totalBackpackFishCount(v91, v90 - 1, t4)
            end

            v76 = react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 6,
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.new(0, 0, 0, -(v25 + 6)),
                Size = UDim2.new(1, 0, 0, v25)
            }, react.createElement("canvasgroup", {
                BackgroundTransparency = 1,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1)
            }, v81, react.createElement("scrollingframe", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 0,
                AutomaticCanvasSize = Enum.AutomaticSize.X,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.X,
                Size = UDim2.fromScale(1, 1),
                ref = v38
            }, v82, v83, v87)))
        else
            v76 = showMountsTab
        end

        v39 = v50 ~= nil

        local v92, v93

        if v39 then
            local t7 = {
                anchorPoint = Vector2.new(0.5, 1),
                exclusiveEditionLabel = v50.exclusiveEditionLabel,
                itemName = v50.itemName,
                moneyPerSecond = v50.moneyPerSecond,
                mutations = v50.mutations,
                position = UDim2.fromScale(v50.tooltipX, v50.tooltipY),
                rarity = v50.rarity
            }

            v92 = if v50.exclusiveEditionLabel ~= nil then 0.05 else 0
            v23 = v92 + 0.19
            v22 = if v50.moneyPerSecond ~= nil then 1 else 0
            v92 = v50.mutations

            if v92 ~= nil then
                v92 = #v92
            end

            if v92 == nil then
                v92 = 0
            end

            t7.size = UDim2.fromScale(0.22, v23 + (v22 + v92) * 0.05)
            v93 = react.createElement(default4, t7)
        else
            v93 = v39
        end

        v50 = not showMountsTab or v36 == "fishes"

        if v50 then
            v92 = table.create(#v65)

            v79 = function(p36, p37) -- line: 675
                -- upvalues: p16 (copy), v29 (copy), v49 (copy), v51 (copy), v55 (copy), v56 (copy), v62 (copy), v64 (copy), react (copy), default3 (copy), fishDataByName (copy), fishingRodsData (copy), getExclusiveFishEditionLabel (copy), v5 (copy)
                local t8 = {
                    equipped = p36.isEquipped
                }
                local v94

                if p36.itemType == "fishingRod" then
                    local v95 = fishingRodsData[p36.itemName]

                    if v95 ~= nil then
                        v95 = v95.imageId
                    end

                    v94 = if v95 ~= nil then v95 else ""
                elseif p36.itemType == "fish" then
                    v94 = fishDataByName[p36.itemName]

                    if v94 ~= nil then
                        v94 = v94.imageId
                    end

                    if v94 == nil then
                        v94 = ""
                    end
                else
                    v94 = if p36.itemType == "emote" then p36.imageId else ""
                end

                t8.imageId = v94

                local itemId = p36.itemId

                t8.isSelectedForDeletion = table.find(v29, itemId) ~= nil
                t8.itemId = p36.itemId
                t8.itemName = p36.itemName
                t8.itemType = p36.itemType
                t8.key = ("backpack-item-%*"):format(p37)
                t8.layoutOrder = p37

                t8.onClick = function() -- line: 687
                    -- upvalues: p36 (copy), v62 (copy)
                    return v62(p36.itemId)
                end

                t8.onDragEnd = v64

                t8.onDragMove = function(p38) -- line: 691
                    -- upvalues: p16 (copy), v49 (copy), v55 (copy)
                    local current = v49.current
                    local v96 = if current == nil then p38 else p38 - current.AbsolutePosition

                    v55(function(p39) -- line: 693
                        -- upvalues: v96 (copy)
                        if p39 == nil then
                            return nil
                        end

                        local v97 = table.clone(p39)

                        setmetatable(v97, nil)
                        v97.position = v96

                        return v97
                    end)

                    local onFishDragMove = p16.onFishDragMove

                    if onFishDragMove ~= nil then
                        onFishDragMove(p38)
                    end
                end

                t8.onDragStart = function(p40, p41, p42) -- line: 710
                    -- upvalues: p16 (copy), v49 (copy), v55 (copy)
                    local t9 = {
                        itemId = p40,
                        imageId = p41
                    }
                    local current = v49.current

                    t9.position = if current == nil then p42 else p42 - current.AbsolutePosition
                    v55(t9)

                    local onFishDragStart = p16.onFishDragStart

                    if onFishDragStart ~= nil then
                        onFishDragStart(p40, p41, p42)
                    end
                end

                t8.onHoverEnd = function() -- line: 721
                    -- upvalues: v51 (copy)
                    return v51(nil)
                end

                t8.onHoverStart = function(p43) -- line: 724
                    -- upvalues: p36 (copy), v56 (copy), getExclusiveFishEditionLabel (copy)
                    return v56(p36.itemName, p36.itemType, p43, if p36.itemType == "fish" then p36.level else 1, if p36.itemType == "fish" then p36.mutations else nil, if p36.itemType == "fish" then getExclusiveFishEditionLabel(p36.itemName, p36.exclusiveIndex) else nil)
                end

                t8.rarity = v5(p36)
                t8.sizeScale = 1

                return react.createElement(default3, t8)
            end

            for v100, v101 in v65 do
                v92[v100] = v79(v101, v100 - 1, v65)
            end

            v50 = react.createElement(default5, {
                cellsPerRow = 9,
                rowsToBeVisible = 3,
                scrollBarThickness = 5,
                zIndex = 1,
                anchorPoint = Vector2.new(0.5, 0),
                fillDirection = Enum.FillDirection.Horizontal,
                horizontalAlignment = Enum.HorizontalAlignment.Left,
                listPaddingScale = Vector2.new(0.016, 0),
                padding = {
                    bottom = UDim.new(0, 0),
                    left = UDim.new(0.02, 0),
                    right = UDim.new(0.017, 0),
                    top = UDim.new(0.015, 0)
                },
                position = UDim2.fromScale(0.5, v71),
                scrollBarColor = Color3.fromRGB(255, 255, 255),
                size = UDim2.fromScale(1, v72)
            }, v92)
        end

        v92 = (not showMountsTab or v36 == "fishes") and #v65 == 0

        if v92 then
            local t10 = {
                hasStroke = true,
                overrideProps = {
                    TextWrapped = true,
                    ZIndex = 2,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, v73),
                    Size = UDim2.fromScale(0.7, 0.15)
                }
            }
            local emptyMessage

            if v52 == "" then
                emptyMessage = p16.emptyMessage

                if emptyMessage == nil then
                    emptyMessage = "Your backpack is empty, drag a fish here to store it!"
                end
            else
                emptyMessage = "No items match your search."
            end

            t10.text = emptyMessage
            v92 = react.createElement(default2, t10)
        end

        v73 = showMountsTab and v36 == "mounts"

        if v73 then
            local t11 = {}

            t11.activeMountName = if v35 == nil then v35 else v35.activeMountName
            t11.onBuy = v46
            t11.onEquip = v45
            t11.onPreview = v48

            if v35 ~= nil then
                v35 = v35.ownedMountNames
            end

            if v35 == nil then
                v35 = {}
            end

            t11.ownedMountNames = v35
            v73 = react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 1,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, v71),
                Size = UDim2.fromScale(1, v72)
            }, react.createElement(default10, t11))
        end

        return react.createElement(default, {
            aspectRatio = 2.4,
            backgroundTransparency = 0.7,
            cornerRadius = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, v20),
            size = UDim2.fromScale(v26 * 0.55, 0.375)
        }, v66, v74, v75, v78, v76, v93, v50, v92, v73)
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef = react.useEffect, react.useMemo, react.useRef
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent, "sidebar-item").default
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerRebirthCount, selectPlayerCollectionIndex, selectPlayerRewards = selectors.selectPlayerStat, selectors.selectPlayerRebirthCount, selectors.selectPlayerCollectionIndex, selectors.selectPlayerRewards
local selectPlayerTitles, selectPlayerMetadata, selectDayLastClaimedCelebrationReward = selectors.selectPlayerTitles, selectors.selectPlayerMetadata, selectors.selectDayLastClaimedCelebrationReward
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils")
local getRebirthEntry, isMaxRebirth = v1.getRebirthEntry, v1.isMaxRebirth
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local getClaimableIndexRewardMilestones = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "index-rewards-utils").getClaimableIndexRewardMilestones
local titlesData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").titlesData
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getPowerBoostProductIds, powerBoostPrices = v2.getPowerBoostProductIds, v2.powerBoostPrices
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local teleportToEventShop = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "character-utils").teleportToEventShop
local celebrationRewardCooldownSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils").celebrationRewardCooldownSeconds
local isFishingContractsEnabled = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-contracts").isFishingContractsEnabled
local t1 = {}
local t2 = {}

local function v3(p1) -- line: 50
    return p1.obtainable
end

local n1 = 0

for v4, v5 in titlesData do
    local _ = v4 - 1

    if v5.obtainable == true then
        n1 += 1
        t2[n1] = v5
    end
end

local v6 = table.create(#t2)

local function v7(p2) -- line: 63
    return p2.id
end

for v8, v9 in t2 do
    local _ = v8 - 1

    v6[v8] = v9.id
end

for _, v10 in v6 do
    t1[v10] = true
end

local t3 = {
    label = "Orders",
    targetWindow = "fishingContracts",
    variant = "event",
    icon = images.eventIcon
}
local t4 = {
    {
        icon = "rbxassetid://90069769903104",
        label = "Index",
        targetWindow = "index",
        variant = "index"
    },
    {
        label = "STORE",
        targetWindow = "exclusiveShop",
        variant = "store",
        icon = images.shopIcon
    },
    {
        label = "Auras",
        targetWindow = "baitAuras",
        variant = "aura",
        icon = images.baitAuraIcon
    },
    {
        label = "Charms",
        targetWindow = "charm",
        variant = "charm",
        icon = images.charmIcon
    },
    {
        aquariumShopSection = "shards",
        label = "Shards",
        targetWindow = "aquariumShop",
        variant = "shards",
        icon = images.universalShard
    },
    {
        label = "Rebirth",
        targetWindow = "rebirth",
        variant = "rebirth",
        icon = images.rebirthIcon
    }
}
local v11 = #t4
local t5 = if isFishingContractsEnabled then { t3 } else {}

table.move(t5, 1, #t5, v11 + 1, t4)

local t6 = {
    {
        label = "Daily",
        targetWindow = "celebrationLogin",
        variant = "daily",
        icon = images.eventCalendarIcon
    },
    {
        label = "Event Shop",
        targetWindow = "celebrationEventShop",
        variant = "eventStore",
        icon = images.eventBagIcon,
        onClickOverride = teleportToEventShop
    },
    {
        label = "Challenge",
        targetWindow = "celebrationTicketChallenge",
        variant = "challenge",
        icon = images.ticketJarIcon
    },
    {
        label = "STORE",
        targetWindow = "exclusiveShop",
        variant = "store",
        icon = images.shopIcon
    },
    {
        label = "Charms",
        targetWindow = "charm",
        variant = "charm",
        icon = images.charmIcon
    },
    {
        label = "Auras",
        targetWindow = "baitAuras",
        variant = "aura",
        icon = images.baitAuraIcon
    }
}
local t7 = {
    label = "Event",
    targetWindow = "celebrationEvent",
    variant = "event",
    icon = images.eventIcon
}
local v12 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 80)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 190, 40)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 240, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 210, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 90, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 210))
})

local function PowerBoostButton(p3) -- line: 160
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useRootSelector (copy), images (copy), RunService (copy), localPlayerUserId (copy), attemptStorePurchase (copy), useFreePurchaseModeEnabled (copy), selectPlayerMetadata (copy), useSound (copy), getPowerBoostProductIds (copy), powerBoostPrices (copy), default2 (copy), default3 (copy), useTheme (copy), v12 (copy)
    local gridSize, gap, topOffset = p3.gridSize, p3.gap, p3.topOffset
    local v13 = useTheme()
    local v14 = useRootSelector(selectPlayerMetadata(localPlayerUserId))
    local playSound = useSound("ButtonClick").playSound
    local playSound2 = useSound("ButtonHover").playSound
    local v15 = useFreePurchaseModeEnabled()

    if v14 ~= nil then
        v14 = v14.powerBoostBonusMultiplier
    end

    if v14 == nil then
        v14 = 0
    end

    local v16 = v14 >= 5
    local v17 = getPowerBoostProductIds()
    local v18

    for v19, v20 in v17 do
        local _ = v19 - 1

        if v14 < v20.bonusMultiplier == true then
            v18 = v20
            break
        end

        v18 = nil
    end

    local v21 = v17[#v17]
    local v22

    if v16 or v18 == nil then
        local v23 = if v21 == nil then v21 else v21.bonusMultiplier

        if v23 == nil then
            v23 = 5
        end

        v22 = `+{ v23 * 100 }% POWER`
    else
        v22 = `+{ v18.bonusMultiplier * 100 }% POWER`
    end

    local v25 = if v16 or v18 == nil then nil else powerBoostPrices[v18.bonusMultiplier]
    local v27 = math.round((gridSize - gap) / 3.5)
    local v28 = if v25 == nil then 0 else math.round(v27 * 0.6)
    local v32 = v27 + (if v25 == nil then 0 else math.round(gap * 0.15)) + v28
    local v33 = useRef()

    useEffect(function() -- line: 232
        -- upvalues: v33 (copy), v16 (copy), RunService (copy)
        if v16 then
            return nil
        end

        local connection = RunService.Heartbeat:Connect(function() -- line: 236
            -- upvalues: v33 (copy)
            local current = v33.current

            if current then
                current.Rotation = os.clock() * 90 % 360
            end
        end)

        return function() -- line: 242
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { v16 })

    local function v34() -- line: 246
        -- upvalues: playSound (copy), v18 (ref), v16 (copy), attemptStorePurchase (copy)
        if v16 or v18 == nil or v18.productId == 0 then
            return nil
        end

        playSound()
        attemptStorePurchase(v18.productId)
    end

    local t8 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0)
    }

    if topOffset == nil then
        topOffset = gridSize + gap
    end

    t8.Position = UDim2.new(0.5, 0, 0, topOffset)
    t8.Size = UDim2.new(0, gridSize, 0, v32)
    t8.ZIndex = 10

    return react.createElement("frame", t8, react.createElement("imagebutton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Event = {
            Activated = v34,
            MouseEnter = function() -- MouseEnter | line: 272
                -- upvalues: playSound2 (copy), v16 (copy)
                if not v16 then
                    playSound2()
                end
            end
        },
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.new(0, gridSize, 0, v27)
    }, react.createElement(default2, {
        cornerRadius = 0.18,
        strokeThickness = 0.055,
        transparency = 0,
        zIndex = 10,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = if v16 then Color3.fromRGB(80, 80, 80) else Color3.fromRGB(255, 255, 255),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, not v16 and react.createElement("uigradient", {
        Rotation = 90,
        Color = v12,
        ref = v33
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 11,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.9, 0.7)
    }, react.createElement(default3, {
        shadowYScale = 0.06,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            ZIndex = 12,
            Font = v13.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextSize = math.round(v27 * 0.38),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        position = UDim2.fromScale(0.5, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = v22
    })))), v25 ~= nil and react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 11,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.55, 0.85),
        Size = UDim2.new(0, gridSize, 0, v28)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        ZIndex = 12,
        Image = images.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.new(0, v28, 0, v28)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 12,
        Size = UDim2.new(0, math.round(v28 * 1.6), 0, v28)
    }, react.createElement(default3, {
        shadowYScale = 0.05,
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(100, 255, 100),
        overrideProps = {
            TextScaled = true,
            ZIndex = 12,
            Font = v13.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0, 0.5),
        strokeProps = {
            Thickness = 0.08
        },
        text = if v15 then "FREE" else tostring(v25)
    }))))
end

return {
    default = function(p4) -- Sidebar | line: 375
        -- upvalues: react (copy), useMemo (copy), useBindingState (copy), useViewport (copy), useRootProducer (copy), useRootSelector (copy), selectCurrentWindow (copy), default (copy), localPlayerUserId (copy), selectPlayerStat (copy), selectPlayerRebirthCount (copy), selectPlayerCollectionIndex (copy), selectPlayerRewards (copy), selectPlayerTitles (copy), selectPlayerMetadata (copy), selectDayLastClaimedCelebrationReward (copy), getRebirthEntry (copy), isMaxRebirth (copy), useSound (copy), getClaimableIndexRewardMilestones (copy), celebrationRewardCooldownSeconds (copy), t1 (copy), t4 (copy), t6 (copy), t7 (copy), PowerBoostButton (copy)
        local isCelebrationPlace = (if p4 == nil then {} else p4).isCelebrationPlace

        if isCelebrationPlace == nil then
            isCelebrationPlace = false
        end

        local v42 = useRootProducer()
        local v43 = useRootSelector(selectCurrentWindow)
        local v44 = useBindingState(useViewport())
        local playSound = useSound("OpenExclusiveShop", nil, 0.5).playSound
        local v45 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v45 == nil then
            v45 = 0
        end

        local v46 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v47 = useRootSelector(selectPlayerMetadata(localPlayerUserId))

        if v47 ~= nil then
            v47 = v47.hasRegisteredForCelebrationEvent
        end

        local v48 = v47 == true
        local v49 = isMaxRebirth(v46)
        local v50 = not v49 and getRebirthEntry(v46).powerCost <= v45
        local v51 = if v49 then 100 else math.min(v45 / getRebirthEntry(v46).powerCost * 100, 100)
        local v53 = useRootSelector(selectPlayerCollectionIndex(localPlayerUserId))
        local v54 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v55 = useRootSelector(selectPlayerTitles(localPlayerUserId))
        local v56 = useMemo(function() -- line: 410
            -- upvalues: v55 (copy), t1 (copy)
            if v55 == nil then
                return false
            end

            local t18 = {}

            for _, v57 in v55.seenTitleIds do
                t18[v57] = true
            end

            for v58, v59 in v55.unlockedTitles do
                local _ = v58 - 1

                if t1[v59] ~= nil and t18[v59] == nil then
                    return true
                end
            end

            return false
        end, { v55 })
        local v60 = #getClaimableIndexRewardMilestones(v53, v54) > 0
        local v61 = useRootSelector(selectDayLastClaimedCelebrationReward(localPlayerUserId))
        local v62 = not v61 or v61.day == 0 or DateTime.now().UnixTimestamp - DateTime.fromUniversalTime(v61.year, v61.month, v61.day, 0, 0, 0).UnixTimestamp >= celebrationRewardCooldownSeconds
        local v63 = useMemo(function() -- line: 445
            -- upvalues: v53 (copy)
            if v53 == nil then
                return false
            end

            for v64, v65 in v53.discoveredFish do
                local v66 = v53.seenFishes[v64]

                if v66 == nil then
                    return true
                end

                local t19 = {}

                for _, v67 in v66 do
                    t19[v67] = true
                end

                ({})[1] = t19

                local v68 = false

                for v69, v70 in v65 do
                    local _ = v69 - 1

                    if t19[v70] == nil then
                        v68 = true
                        break
                    end
                end

                if v68 then
                    return true
                end
            end

            return false
        end, { v53 })
        local v71 = v44.X < 1000 and v44.Y < 600
        local v72 = v44.X < 1600
        local v73 = if v71 then math.round(math.clamp(math.floor(v44.Y * 0.115), 46, 61) * 0.8) elseif v72 then math.clamp(math.floor(v44.Y * 0.102), 54, 76) else math.clamp(math.floor(v44.Y * 0.153), 54, 102)
        local v84 = math.clamp(math.floor(v73 * 0.22), 10, if v71 then 18 elseif v72 then 22 else 30)
        local v85 = v73 * 2 + v84
        local v86 = if isCelebrationPlace then t6 else t4
        local v88 = math.ceil(#v86 / 2)
        local v89 = v73 * v88 + v84 * (v88 - 1)
        local v91 = math.round((v85 - v84) / 2)
        local v93 = math.round(v91 * 0.32)
        local v95 = math.round(v84 * 0.35)
        local v97 = math.round(v84 * 1.75)
        local v98 = v91 + v95 + v93
        local v100 = math.round(v73 * 0.8)
        local v101, v102

        if isCelebrationPlace then
            v102 = v100 + v84
            v101 = v100 + v84 + v89
        else
            v102 = 0
            v101 = v89 + v97 + v98
        end

        local v103 = react.createElement("uisizeconstraint", {
            MaxSize = Vector2.new(v85, v101),
            MinSize = Vector2.new(v85, v101)
        })
        local v104 = isCelebrationPlace and react.createElement(default, {
            square = false,
            active = v43 == t7.targetWindow,
            bannerIconSize = UDim2.fromScale(0.5, 0.5),
            bannerLabelSize = UDim2.fromScale(0.4, 0.48),
            eventRegistered = v48,
            icon = t7.icon,
            label = t7.label,
            onClick = function() -- onClick | line: 510
                -- upvalues: v42 (copy), t7 (copy)
                return v42.windowToggled({
                    currentWindow = t7.targetWindow
                })
            end,
            position = UDim2.fromOffset(v85 / 2, v100 / 2),
            size = UDim2.fromOffset(v85, v100),
            variant = t7.variant
        })
        local v105 = table.create(#v86)

        local function v106(p5, p6) -- line: 522
            -- upvalues: v42 (copy), v43 (copy), playSound (copy), v49 (copy), v56 (copy), v63 (copy), v73 (copy), v84 (copy), v48 (copy), v50 (copy), v51 (copy), v60 (copy), v62 (copy), react (copy), default (copy)
            local v107

            if p5.targetWindow == "rebirth" then
                v107 = v50
            elseif p5.targetWindow == "index" then
                v107 = v63

                if not v63 then
                    v107 = v56 or v60
                end
            else
                v107 = p5.targetWindow == "celebrationLogin" and v62
            end

            local v109 = math.floor(p6 / 2)
            local v110 = p6 % 2
            local v111 = v73 / 2 + v110 * (v73 + v84)
            local v112 = v73 / 2 + v109 * (v73 + v84)

            return react.createElement(default, {
                active = v43 == p5.targetWindow,
                eventRegistered = if p5.variant == "event" then v48 else nil,
                icon = p5.icon,
                isMaxRebirth = if p5.variant == "rebirth" then v49 else nil,
                key = p5.label,
                label = p5.label,
                layoutOrder = p6,
                onClick = p5.onClickOverride or function() -- line: 536
                    -- upvalues: p5 (copy), v42 (copy), v43 (copy), playSound (copy)
                    if p5.targetWindow == "exclusiveShop" and v43 ~= "exclusiveShop" then
                        playSound()
                    end

                    if p5.aquariumShopSection ~= nil then
                        v42.windowOpened({
                            aquariumShopSection = p5.aquariumShopSection,
                            currentWindow = if v43 == p5.targetWindow then "none" else p5.targetWindow
                        })
                    else
                        v42.windowToggled({
                            currentWindow = p5.targetWindow
                        })
                    end
                end,
                position = UDim2.fromOffset(v111, v112),
                rebirthPercent = if p5.variant == "rebirth" then v51 else nil,
                showNotification = v107,
                size = UDim2.fromOffset(v73, v73),
                variant = p5.variant
            })
        end

        for v113, v114 in v86 do
            v105[v113] = v106(v114, v113 - 1, v86)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.975, v71 and 0.5 or 0.55),
            Size = UDim2.fromOffset(v85, v101)
        }, v103, v104, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromOffset(0, v102),
            Size = UDim2.fromOffset(v85, v89)
        }, v105), not isCelebrationPlace and react.createElement(PowerBoostButton, {
            gap = v84,
            gridSize = v85,
            topOffset = v89 + v97
        }))
    end
}

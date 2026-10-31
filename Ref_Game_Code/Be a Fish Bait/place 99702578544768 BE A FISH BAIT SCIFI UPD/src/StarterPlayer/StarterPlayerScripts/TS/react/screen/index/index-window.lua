-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef, useState = react.useEffect, react.useMemo, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-badge").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default8 = RuntimeLib.import(script, script.Parent, "index-item").default
local default9 = RuntimeLib.import(script, script.Parent, "titles-panel").default
local titlesData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").titlesData
local fishMutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").fishMutations
local hoolaMutationDisplayGradients = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config").hoolaMutationDisplayGradients
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils")
local getMutationColor, getMutationColorGradient = v1.getMutationColor, v1.getMutationColorGradient
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerCollectionIndex, selectPlayerRewards, selectPlayerTitles = selectors.selectPlayerCollectionIndex, selectors.selectPlayerRewards, selectors.selectPlayerTitles
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "collection-index-utils")
local getCollectionItems, getCollectionIndexState, getCollectionItemsForHoola, getCollectionItemsForVariant = v2.getCollectionItems, v2.getCollectionIndexState, v2.getCollectionItemsForHoola, v2.getCollectionItemsForVariant
local getDiscoveredFishCount, getTotalCollectionFishCount, hoolaCollectionVariants, isCollectionItemUnlocked = v2.getDiscoveredFishCount, v2.getTotalCollectionFishCount, v2.hoolaCollectionVariants, v2.isCollectionItemUnlocked
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "index-rewards-utils")
local getIndexRewardProgressPercent, indexRewardMilestones = v3.getIndexRewardProgressPercent, v3.indexRewardMilestones
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 190, 245)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(42, 155, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 125, 190))
})
local t1 = {
    "Normal",
    "Gold",
    "Diamond",
    "Plasma",
    "Glitched",
    "Molten",
    "Radioactive",
    "Delulu",
    "Champion"
}
local t2 = {
    "Exclusive"
}
local v5 = #t2
local v6 = #t1

table.move(t1, 1, v6, v5 + 1, t2)
t2[v5 + v6 + 1] = "Hoola"

local t3 = {}
local t4 = {}

local function v7(p1) -- line: 63
    return p1.obtainable
end

local n1 = 0

for v8, v9 in titlesData do
    local _ = v8 - 1

    if v9.obtainable == true then
        n1 += 1
        t4[n1] = v9
    end
end

local v10 = table.create(#t4)

local function v11(p2) -- line: 76
    return p2.id
end

for v12, v13 in t4 do
    local _ = v12 - 1

    v10[v12] = v13.id
end

for _, v14 in v10 do
    t3[v14] = true
end

local n2 = 0

for _ in t3 do
    n2 += 1
end

local v15 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
})
local hoola3 = hoolaMutationDisplayGradients.hoola3
local t5 = {
    hoola1 = Color3.fromRGB(255, 219, 61),
    hoola2 = Color3.fromRGB(20, 227, 255),
    hoola3 = Color3.fromRGB(255, 36, 105)
}
local t6 = {
    hoola1 = "I",
    hoola2 = "II",
    hoola3 = "III"
}

local function getFilterVariants(p3) -- line: 109
    -- upvalues: hoolaCollectionVariants (copy)
    if p3 == "Exclusive" then
        return { "Normal" }
    end

    if p3 == "Hoola" then
        return hoolaCollectionVariants
    end

    return { p3 }
end

local function getHoolaCardBackground(p4) -- line: 118
    -- upvalues: t5 (copy)
    return if p4 == "hoola1" or p4 == "hoola2" or p4 == "hoola3" then t5[p4] else nil
end

local function getHoolaBadgeColor(p5) -- line: 121
    -- upvalues: t5 (copy)
    local v16 = if p5 ~= "hoola1" and p5 ~= "hoola2" and p5 ~= "hoola3" then nil else t5[p5]

    if v16 == nil then
        return nil
    end

    local v17, v18, v19 = v16:ToHSV()

    return Color3.fromHSV(v17, math.min(v18 * 1.15, 1), v19 * 0.82)
end

local function getHoolaBadgeLabel(p6) -- line: 129
    -- upvalues: t6 (copy)
    return if p6 == "hoola1" or p6 == "hoola2" or p6 == "hoola3" then t6[p6] else nil
end

local function getMutationButtonColor(p7) -- line: 132
    -- upvalues: getMutationColorGradient (copy), getRarityColor (copy), v15 (copy), hoola3 (copy)
    if p7 == "Exclusive" then
        return getRarityColor("exclusive")
    end

    if p7 == "Hoola" then
        return hoola3
    end

    if p7 == "Normal" then
        return v15
    end

    return (getMutationColorGradient(p7))
end

local function getVariantMoneyPerSecond(p8, p9) -- line: 141
    -- upvalues: getMutatedMoneyPerSecond (copy)
    if p9 == "Normal" then
        return p8
    end

    return (getMutatedMoneyPerSecond(p8, 1, { p9 }))
end

local function getMutationBonusLabel(p10) -- line: 145
    -- upvalues: fishMutations (copy)
    if p10 == "Normal" or p10 == "Exclusive" or p10 == "Hoola" then
        return nil
    end

    local v21 = fishMutations[p10]

    return if v21 ~= nil then ("+%*%% MPS"):format((math.round((v21.mutationCashMultiplier - 1) * 100))) else nil
end

local function getMutationInfoLabel(_) -- line: 156
    return nil
end

local function getMutationStackingInfoLabel(p12) -- line: 162
    if p12 == "Champion" then
        return "Champion STACKS with other mutations"
    end

    if p12 == "Delulu" then
        return "Delulu STACKS with other mutations"
    end

    return if p12 == "Hoola" then "Hoola STACKS with other mutations" else nil
end

local function getMutationStackingChanceLabel(p13) -- line: 174
    if p13 == "Champion" then
        return "30% chance to obtain on a BOSS-FISH"
    end

    if p13 == "Delulu" then
        return "Obtainable in the Delulu dimension"
    end

    return if p13 == "Hoola" then "tier II gives 7% training boost and tier III 10% mutation luck" else nil
end

local v23 = table.create(#indexRewardMilestones)

local function v24(p14) -- line: 188
    local v25 = table.clone(p14)

    setmetatable(v25, nil)
    v25.bonusLabel = ("+%*%%"):format(p14.earningsBonusPercent)
    v25.rewardLabel = p14.kind == "goldAquariumSkin" and "Aquarium Skin" or "Aquarium Earnings"

    if p14.kind == "goldAquariumSkin" then
        v25.rewardTitle = "GOLD"
    else
        v25.rewardTitle = nil
    end

    return v25
end

for v26, v27 in indexRewardMilestones do
    local _ = v26 - 1
    local v28 = table.clone(v27)

    setmetatable(v28, nil)
    v28.bonusLabel = ("+%*%%"):format(v27.earningsBonusPercent)
    v28.rewardLabel = v27.kind == "goldAquariumSkin" and "Aquarium Skin" or "Aquarium Earnings"

    if v27.kind == "goldAquariumSkin" then
        v28.rewardTitle = "GOLD"
    else
        v28.rewardTitle = nil
    end

    v23[v26] = v28
end

local Gold = getAquariumSkinData("Gold")

if Gold ~= nil then
    Gold = Gold.imageId
end

if Gold == nil then
    Gold = images.cash6stack
end

local function FishDiscoveryRewardProgress(p15) -- line: 211
    -- upvalues: react (copy), default3 (copy), default4 (copy), default5 (copy), useTheme (copy), images (copy), v23 (copy), Gold (ref)
    local v29 = useTheme()
    local zIndex = p15.zIndex

    if zIndex == nil then
        zIndex = 35
    end

    local v31 = math.clamp(p15.rewardProgressPercent / 100, 0, 1)
    local v32 = math.floor(p15.rewardProgressPercent)
    local v33 = react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.018, 0.5),
        Size = UDim2.fromScale(0.16, 0.88),
        ZIndex = zIndex + 1
    }, react.createElement(default5, {
        text = "Fishes Discovered",
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            TextWrapped = false,
            Font = v29.textFont2,
            Size = UDim2.fromScale(1.35, 0.3),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = zIndex + 2
        }
    }))
    local v34 = react.createElement("frame", {
        BackgroundTransparency = 0.28,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0.095, 0.51),
        Size = UDim2.fromScale(0.845, 0.2),
        ZIndex = zIndex + 1
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.22, 0)
    }), react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(42, 42, 42)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 42, 42))
        })
    }), react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(150, 255, 0),
        Size = UDim2.fromScale(v31, 1),
        ZIndex = zIndex + 2
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.22, 0)
    }), react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 255, 0))
        })
    })))
    local v35 = react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.fishIcon,
        Position = UDim2.fromScale(0.095, 0.56),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.08, 0.51),
        ZIndex = zIndex + 20
    })
    local v36 = react.createElement(default5, {
        anchorPoint = Vector2.new(0.5, 0),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Font = v29.textFont2,
            Position = UDim2.fromScale(0.095, 0.78),
            Size = UDim2.fromScale(0.11, 0.18),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = zIndex + 21
        },
        text = ("%*/%* (%*%%)"):format(p15.discoveredCount, p15.totalCount, v32)
    })
    local v37 = table.create(#v23)

    local function v38(p16, p17) -- line: 289
        -- upvalues: p15 (copy), v29 (copy), zIndex (ref), v32 (copy), react (copy), default4 (copy), default5 (copy), images (copy), Gold (ref)
        local v39 = 0.095 + 0.845 * (p16.percent / 100)
        local v40 = v32 >= p16.percent
        local v41 = p16.percent == 100
        local rewards = p15.rewards

        if rewards ~= nil then
            rewards = rewards[p16.rewardId]
        end

        local v42 = rewards == true
        local v43 = v40 and not v42
        local v44 = if v42 then Color3.fromRGB(145, 145, 145) else Color3.fromRGB(255, 255, 255)
        local createElement = react.createElement
        local t7 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(v39, 0.44),
            Size = UDim2.fromScale(0.14, 0.82),
            ZIndex = zIndex + 3 + p17,
            key = ("%*"):format(p16.percent)
        }
        local v45 = v41 and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.03,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.42),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.4, 1.22),
            ZIndex = zIndex + 4
        }, react.createElement("uigradient", {
            Rotation = 35,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 55)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 220, 45)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(70, 255, 80)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 210, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(145, 85, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 220))
            })
        }))
        local v46 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = if v41 then Gold else images.cash6stack,
            ImageColor3 = if v42 then Color3.fromRGB(145, 145, 145) else Color3.fromRGB(255, 255, 255),
            ImageTransparency = if v41 then if v42 then 0.18 else 0
                elseif v42 then 0.22
                elseif v40 then 0
                else 0.18,
            Position = UDim2.fromScale(0.5, v41 and 0.34 or 0.36),
            ScaleType = Enum.ScaleType.Fit,
            Size = if v41 then UDim2.fromScale(1.18, 0.82) else UDim2.fromScale(1.05, 0.72),
            ZIndex = zIndex + 8 + p17
        })
        local v47 = react.createElement(default5, {
            color = v44,
            overrideProps = {
                TextScaled = true,
                Font = v29.textFont2,
                Position = UDim2.fromScale(0.57, 0.02),
                Size = UDim2.fromScale(0.4, 0.22),
                ZIndex = zIndex + 14 + p17
            },
            text = p16.bonusLabel
        })
        local v48 = react.createElement(default5, {
            color = v44,
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                Font = v29.textFont2,
                Position = UDim2.fromScale(0.08, p16.rewardTitle == nil and 0.58 or 0.65),
                Size = UDim2.fromScale(0.84, 0.28),
                ZIndex = zIndex + 14 + p17
            },
            text = p16.rewardLabel
        })
        local v49 = p16.rewardTitle ~= nil and react.createElement(default5, {
            color = if v42 then Color3.fromRGB(145, 145, 145) else ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 210)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 225, 70)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 130, 10))
            }),
            overrideProps = {
                TextScaled = true,
                Font = v29.textFont2,
                Position = UDim2.fromScale(0.16, 0.5),
                Size = UDim2.fromScale(0.68, 0.22),
                ZIndex = zIndex + 15 + p17
            },
            text = p16.rewardTitle
        })
        local createElement4, default, t12, v50, v51

        if v43 then
            createElement4 = react.createElement
            default = default4
            t12 = {
                cornerRadius = 0.18
            }
            v50 = if v42 then ColorSequence.new(Color3.fromRGB(110, 110, 110)) else ColorSequence.new(Color3.fromRGB(255, 205, 50))
            v51 = false
        elseif v42 then
            createElement4 = react.createElement
            default = default4
            t12 = {
                cornerRadius = 0.18
            }
            v50 = ColorSequence.new(Color3.fromRGB(110, 110, 110))
            v51 = false
        else
            v51 = true
        end

        local v52

        if v51 then
            v52 = react.createElement(default5, {
                color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 245, 120)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 185, 35))
                }),
                overrideProps = {
                    TextScaled = true,
                    Font = v29.textFont2,
                    Position = UDim2.fromScale(0.08, 0.9),
                    Size = UDim2.fromScale(0.84, 0.26),
                    ZIndex = zIndex + 6 + p17
                },
                text = ("%*%%"):format(p16.percent)
            })
        else
            t12.color = v50
            t12.frameSize = UDim2.fromScale(0.78, 0.25)
            t12.label = v42 and "CLAIMED" or "CLAIM"

            function t12.onClick() -- line: 368
                -- upvalues: p16 (copy), v42 (copy), p15 (copy)
                if not v42 then
                    local onClaimReward = p15.onClaimReward

                    if onClaimReward ~= nil then
                        onClaimReward(p16)
                    end
                end
            end

            t12.position = UDim2.fromScale(0.5, 1.03)
            t12.zIndex = zIndex + 16 + p17
            v52 = createElement4(default, t12)
        end

        return createElement("frame", t7, v45, v46, v47, v48, v49, v52)
    end

    for v53, v54 in v23 do
        v37[v53] = v38(v54, v53 - 1, v23)
    end

    return react.createElement(default3, {
        cornerRadius = 0.08,
        isStudded = true,
        strokeThickness = 0.005,
        textureTransparency = 0.9,
        transparency = 0.35,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = Color3.fromRGB(0, 0, 0),
        position = UDim2.fromScale(0.5, 1.015),
        size = UDim2.fromScale(1, 0.23),
        strokeColor = Color3.fromRGB(80, 80, 80),
        zIndex = zIndex
    }, v33, v34, v35, v36, v37)
end

local function getExclusiveStatLabel(p18) -- line: 408
    -- upvalues: getExclusiveFishConfigByFishName (copy)
    local v55 = getExclusiveFishConfigByFishName(p18)

    return if v55 ~= nil then ("%*%%"):format((math.round(v55.mpsMultiplier * 100))) else nil
end

local function getExclusiveMpsMultiplier(p19) -- line: 415
    -- upvalues: getExclusiveFishConfigByFishName (copy)
    local v57 = getExclusiveFishConfigByFishName(p19)

    if v57 ~= nil then
        v57 = v57.mpsMultiplier
    end

    if v57 == nil then
        v57 = 0
    end

    return v57
end

local function getExclusiveUnlockSourceLabel(p20) -- line: 426
    -- upvalues: getExclusiveFishConfigByFishName (copy)
    local v58 = getExclusiveFishConfigByFishName(p20)

    if v58 ~= nil then
        v58 = v58.unlockSource
    end

    return v58
end

local function getUnlockSourceLabel(p21, p22) -- line: 434
    -- upvalues: getExclusiveFishConfigByFishName (copy)
    if p21 == "Goatzilla" then
        return "KaijUwU Zone apex fish encounter (1 in 3)"
    end

    local v59 = p22 == "Exclusive"
    local v60, v61

    if v59 then
        v60 = getExclusiveFishConfigByFishName(p21)
        v61 = v60 == nil
    end

    if v59 and v61 or not v59 then
        if not v59 then
            v60 = nil
        end

        return v60
    end

    return v60.unlockSource
end

return {
    default = function(p23) -- IndexWindow | line: 440
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), default2 (copy), default4 (copy), default5 (copy), default6 (copy), default7 (copy), useRootSelector (copy), functions (copy), useScreenSizeState (copy), useTheme (copy), localPlayerUserId (copy), default8 (copy), default9 (copy), fishMutations (copy), images (copy), getExclusiveFishConfigByFishName (copy), getMutatedMoneyPerSecond (copy), getMutationColor (copy), getMutationColorGradient (copy), getRarityColor (copy), selectPlayerCollectionIndex (copy), selectPlayerRewards (copy), selectPlayerTitles (copy), getCollectionItems (copy), getCollectionIndexState (copy), getCollectionItemsForHoola (copy), getCollectionItemsForVariant (copy), getDiscoveredFishCount (copy), getTotalCollectionFishCount (copy), hoolaCollectionVariants (copy), isCollectionItemUnlocked (copy), getIndexRewardProgressPercent (copy), v4 (copy), t2 (copy), t3 (copy), v15 (copy), hoola3 (copy), t5 (copy), t6 (copy), Gold (ref), FishDiscoveryRewardProgress (copy), n2 (ref)
        local Exclusive, Exclusive2 = useState("Exclusive")
        local v62, v63 = useState(false)
        local v64, v65 = useState(nil)
        local v66, v67 = useMotion(0)
        local v68 = useRootSelector(selectPlayerCollectionIndex(localPlayerUserId))
        local v69 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v70 = p23.previewRewards or v69
        local v71 = useRootSelector(selectPlayerTitles(localPlayerUserId))
        local v72 = useMemo(function() -- line: 449
            -- upvalues: v71 (copy), t3 (copy)
            local t13 = {}
            local v73 = v71

            if v71 ~= nil then
                v73 = v71.unlockedTitles
            end

            if v73 == nil then
                v73 = {}
            end

            for _, v74 in v73 do
                if t3[v74] ~= nil then
                    t13[v74] = true
                end
            end

            local t14 = {}
            local v75 = #t14

            for v76 in t13 do
                v75 += 1
                t14[v75] = v76
            end

            return t14
        end, { v71 })
        local v77 = #v72
        local v78 = useMemo(function() -- line: 473
            -- upvalues: v71 (copy), t3 (copy)
            local v79 = v71

            if v71 ~= nil then
                v79 = v71.seenTitleIds
            end

            if v79 == nil then
                v79 = {}
            end

            local t15 = {}

            local function v80(p24) -- line: 484
                -- upvalues: t3 (copy)
                return t3[p24] ~= nil
            end

            local n3 = 0

            for v81, v82 in v79 do
                local _ = v81 - 1

                if t3[v82] ~= nil == true then
                    n3 += 1
                    t15[n3] = v82
                end
            end

            return t15
        end, { v71 })
        local v83 = useRef(false)
        local v84 = false

        for v85, v86 in v72 do
            local _ = v85 - 1

            if (table.find(v78, v86) or 0) - 1 == -1 then
                v84 = true
                break
            end

            v84 = false
        end

        local previewHasNewTitlesBadge = p23.previewHasNewTitlesBadge

        if previewHasNewTitlesBadge == nil then
            previewHasNewTitlesBadge = v84
        end

        useEffect(function() -- line: 520
            -- upvalues: v67 (copy)
            v67:linear(360, {
                speed = 85
            })

            return (v67:onComplete(function() -- line: 527
                -- upvalues: v67 (copy)
                v67:immediate(0)
                v67:linear(360, {
                    speed = 85
                })
            end))
        end, { v67 })
        useEffect(function() -- line: 533
            -- upvalues: v62 (copy), v72 (copy), v83 (copy), v84 (ref), functions (copy)
            if not v62 then
                v83.current = false

                return nil
            end

            if v83.current or not v84 then
                return nil
            end

            v83.current = true
            functions.markTitlesSeen(v72)
        end, { v62, v84, v72 })

        local v87 = useScreenSizeState()
        local v88 = useTheme()
        local v89 = if v68 == nil then v68 else v68.discoveredFish
        local v90 = if v68 == nil then v68 else v68.seenFishes
        local v91 = useRef(v90)

        useEffect(function() -- line: 561
            -- upvalues: v90 (copy), v91 (copy)
            v91.current = v90
        end, { Exclusive })

        local v92 = useMemo(function() -- line: 565
            -- upvalues: getCollectionItems (copy)
            local t16 = {}

            for _, v93 in getCollectionItems() do
                if v93.rarity == "exclusive" then
                    t16[v93.id] = true
                end
            end

            return t16
        end, {})
        local v94 = useMemo(function() -- line: 577
            -- upvalues: v89 (copy), v90 (copy), v92 (copy), getCollectionItemsForHoola (copy), getCollectionItemsForVariant (copy), hoolaCollectionVariants (copy)
            return function(p25) -- line: 578
                -- upvalues: v89 (copy), v90 (copy), v92 (copy), getCollectionItemsForHoola (copy), getCollectionItemsForVariant (copy), hoolaCollectionVariants (copy)
                if v89 == nil then
                    return false
                end

                local v95 = if p25 == "Exclusive" then { "Normal" } elseif p25 == "Hoola" then hoolaCollectionVariants else { p25 }
                local v96

                if p25 == "Exclusive" then
                    v96 = v92
                else
                    v96 = {}

                    local v97 = if p25 == "Hoola" then getCollectionItemsForHoola() else getCollectionItemsForVariant(p25)
                    local v98 = table.create(#v97)

                    local function v99(p26) -- line: 591
                        return p26.id
                    end

                    for v100, v101 in v97 do
                        local _ = v100 - 1

                        v98[v100] = v101.id
                    end

                    for _, v102 in v98 do
                        v96[v102] = true
                    end
                end

                for v103, v104 in v89 do
                    if v96[v103] ~= nil then
                        local v105 = v90

                        if v90 ~= nil then
                            v105 = v90[v103]
                        end

                        if v105 == nil then
                            v105 = {}
                        end

                        for _, v106 in v95 do
                            if table.find(v104, v106) ~= nil and table.find(v105, v106) == nil then
                                return true
                            end
                        end
                    end
                end

                return false
            end
        end, { v89, v92, v90 })
        local v107 = useMemo(function() -- line: 628
            -- upvalues: v89 (copy), v91 (copy)
            local current = v91.current

            return function(p27, p28) -- line: 630
                -- upvalues: current (copy), v89 (copy)
                local v108 = v89

                if v89 ~= nil then
                    v108 = v89[p27]
                end

                if v108 == nil or table.find(v108, p28) == nil then
                    return false
                end

                local v109 = current

                if current ~= nil then
                    v109 = current[p27]
                end

                if v109 == nil then
                    v109 = {}
                end

                return table.find(v109, p28) == nil
            end
        end, { v89, Exclusive })
        local v110 = useMemo(function() -- line: 660
            -- upvalues: v68 (copy), getCollectionIndexState (copy)
            return getCollectionIndexState(v68)
        end, { v68 })
        local v111 = useMemo(function() -- line: 663
            -- upvalues: Exclusive (copy), getCollectionItems (copy), getCollectionItemsForHoola (copy), getCollectionItemsForVariant (copy), hoolaCollectionVariants (copy)
            if Exclusive == "Exclusive" then
                local v112 = getCollectionItems()
                local t17 = {}

                local function v113(p29) -- line: 668
                    return p29.rarity == "exclusive"
                end

                local n4 = 0

                for v114, v115 in v112 do
                    local _ = v114 - 1

                    if v115.rarity == "exclusive" == true then
                        n4 += 1
                        t17[n4] = v115
                    end
                end

                local v116 = table.create(#t17)

                local function v117(p30) -- line: 681
                    return {
                        variant = "Normal",
                        item = p30
                    }
                end

                for v118, v119 in t17 do
                    local _ = v118 - 1

                    v116[v118] = {
                        variant = "Normal",
                        item = v119
                    }
                end

                return v116
            end

            if Exclusive == "Hoola" then
                local t18 = {}

                for _, v120 in getCollectionItemsForHoola() do
                    for _, v121 in hoolaCollectionVariants do
                        table.insert(t18, {
                            item = v120,
                            variant = v121
                        })
                    end
                end

                return t18
            end

            local v122 = getCollectionItemsForVariant(Exclusive)
            local t20 = {}

            local function v123(p31) -- line: 709
                return p31.rarity ~= "exclusive"
            end

            local n5 = 0

            for v124, v125 in v122 do
                local _ = v124 - 1

                if v125.rarity ~= "exclusive" == true then
                    n5 += 1
                    t20[n5] = v125
                end
            end

            local v126 = table.create(#t20)

            for v127, v128 in t20 do
                local _ = v127 - 1

                v126[v127] = {
                    item = v128,
                    variant = Exclusive
                }
            end

            return v126
        end, { Exclusive })
        local v129 = useMemo(function() -- line: 734
            -- upvalues: p23 (copy), v68 (copy), getDiscoveredFishCount (copy)
            if p23.previewDiscoveredFishCount == nil then
                return getDiscoveredFishCount(v68)
            end

            return p23.previewDiscoveredFishCount
        end, {
            v68,
            p23.previewDiscoveredFishCount
        })
        local previewTotalFishCount = p23.previewTotalFishCount

        if previewTotalFishCount == nil then
            previewTotalFishCount = getTotalCollectionFishCount()
        end

        local v130 = useMemo(function() -- line: 745
            -- upvalues: v68 (copy), getIndexRewardProgressPercent (copy)
            return getIndexRewardProgressPercent(v68)
        end, { v68 })
        local v131 = useMemo(function() -- line: 748
            -- upvalues: Exclusive (copy), v111 (copy), getExclusiveFishConfigByFishName (copy), getMutatedMoneyPerSecond (copy)
            local t21 = {}
            local v132 = #t21

            table.move(v111, 1, #v111, v132 + 1, t21)

            if Exclusive ~= "Hoola" then
                table.sort(t21, function(p32, p33) -- line: 756
                    -- upvalues: Exclusive (copy), getExclusiveFishConfigByFishName (copy), getMutatedMoneyPerSecond (copy)
                    if Exclusive == "Exclusive" then
                        local v133 = getExclusiveFishConfigByFishName(p32.item.id)

                        if v133 ~= nil then
                            v133 = v133.mpsMultiplier
                        end

                        if v133 == nil then
                            v133 = 0
                        end

                        local v134 = getExclusiveFishConfigByFishName(p33.item.id)

                        if v134 ~= nil then
                            v134 = v134.mpsMultiplier
                        end

                        if v134 == nil then
                            v134 = 0
                        end

                        if v133 == v134 then
                            return p32.item.name < p33.item.name
                        end

                        return v134 < v133
                    end

                    local moneyPerSecond = p32.item.moneyPerSecond
                    local variant = p32.variant

                    if variant ~= "Normal" then
                        moneyPerSecond = getMutatedMoneyPerSecond(moneyPerSecond, 1, { variant })
                    end

                    local moneyPerSecond2 = p33.item.moneyPerSecond
                    local variant2 = p33.variant

                    if variant2 ~= "Normal" then
                        moneyPerSecond2 = getMutatedMoneyPerSecond(moneyPerSecond2, 1, { variant2 })
                    end

                    if moneyPerSecond == moneyPerSecond2 then
                        return p32.item.name < p33.item.name
                    end

                    return moneyPerSecond < moneyPerSecond2
                end)
            end

            return t21
        end, { v111, Exclusive })
        local v135, v136

        if Exclusive ~= "Normal" and Exclusive ~= "Exclusive" and Exclusive ~= "Hoola" then
            local v137 = fishMutations[Exclusive]

            if v137 ~= nil then
                v136 = (v137.mutationCashMultiplier - 1) * 100
                v135 = ("+%*%% MPS"):format((math.round(v136)))
            end
        end

        local v138 = if Exclusive == "Champion" then "Champion STACKS with other mutations"
            elseif Exclusive == "Delulu" then "Delulu STACKS with other mutations"
            elseif Exclusive == "Hoola" then "Hoola STACKS with other mutations"
            else nil
        local v139 = if Exclusive == "Champion" then "30% chance to obtain on a BOSS-FISH"
            elseif Exclusive == "Delulu" then "Obtainable in the Delulu dimension"
            elseif Exclusive == "Hoola" then "tier II gives 7% training boost and tier III 10% mutation luck"
            else nil
        local v140 = v138 ~= nil

        v136 = v138 ~= nil

        local v141 = if Exclusive ~= "Normal" and Exclusive ~= "Exclusive" and Exclusive ~= "Hoola" then getMutationColor(Exclusive) else nil
        local v142 = v87 == "sm"
        local v143 = v87 ~= "lg"
        local v144 = if v142 then 4 elseif v87 == "md" then 7 else 10
        local n6 = 2.75

        if Exclusive == "Champion" or Exclusive == "Delulu" then
            n6 = 2.55
        end

        local v145 = useRef()

        local function v146() -- line: 791
            -- upvalues: v89 (copy), v90 (copy), v107 (copy), v131 (copy), v145 (copy), functions (copy)
            local current = v145.current

            if current == nil or v89 == nil then
                return nil
            end

            local v148 = math.ceil(#v131 / 5)

            if v148 <= 0 then
                return nil
            end

            local v149 = current.AbsoluteCanvasSize.Y / v148

            if v149 <= 0 then
                return nil
            end

            local Y = current.CanvasPosition.Y
            local v150 = Y + current.AbsoluteWindowSize.Y
            local v153 = math.max(0, (math.floor(Y / v149)))
            local v157 = math.min(v148 - 1, (math.floor(v150 / v149)))
            local v158 = false
            local t22

            while true do
                if v158 then
                    v153 += 1
                else
                    v158 = true
                end

                if v153 <= v157 then
                    for i = 0, 4 do
                        local v160 = v131[v153 * 5 + i + 1]

                        if v160 ~= nil and v107(v160.item.id, v160.variant) then
                            if t22 == nil then
                                t22 = {}

                                if v90 ~= nil then
                                    for v161, v162 in v90 do
                                        local t23 = {}
                                        local v163 = #t23

                                        table.move(v162, 1, #v162, v163 + 1, t23)
                                        t22[v161] = t23
                                    end
                                end
                            end

                            local v164 = t22[v160.item.id]

                            if v164 == nil then
                                v164 = {}
                            end

                            local variant = v160.variant

                            if table.find(v164, variant) == nil then
                                local id = v160.item.id
                                local t24 = {}
                                local v165 = #t24
                                local v166 = #v164

                                table.move(v164, 1, v166, v165 + 1, t24)
                                t24[v165 + v166 + 1] = v160.variant
                                t22[id] = t24
                            end
                        end
                    end

                    continue
                end

                break
            end

            if t22 ~= nil then
                functions.markFishCollectionSeen(t22)
            end
        end

        useEffect(function() -- line: 871
            -- upvalues: v146 (copy)
            v146()
        end, { Exclusive, v131 })

        local v167 = if v143 then UDim2.fromScale(0.5, 0.475) else UDim2.fromScale(0.535, 0.475)
        local v168, v169, v170, v171, v172, v173

        if v142 then
            v143 = UDim2.fromScale(0.74, 0.66)
            v172 = 0.23
            v173 = UDim2.fromScale(0.145, 0.62)
            v170 = 0.1
            v171 = 7
            v168 = 6
            v169 = 10
        else
            v172 = UDim2.fromScale
            v173 = if v87 == "md" then 0.64 else 0.57
            v143 = v172(v173, 0.68)
            v172 = if v87 == "md" then 0.21 else 0.24
            v173 = UDim2.fromScale(0.125, 0.62)
            v170 = 0.094
            v171 = 8
            v168 = 6
            v169 = if v87 == "md" then 10 else 20
        end

        local v174, v175

        if v136 then
            v174 = 1.015
            v175 = 0.745
        elseif v140 then
            v174 = 1.005
            v175 = 0.78
        else
            v174 = 0.965
            v175 = 0.82
        end

        v136 = if v142 then UDim2.fromScale(0.18, 0.11) else UDim2.fromScale(0.19, 0.11)

        local v176 = UDim2.fromScale(1.115, 0.95)
        local v177, v178

        if v142 then
            v177 = UDim2.fromOffset(18, 18)
            v178 = 18
        else
            v177 = UDim2.fromOffset(26, 26)
            v178 = if v87 == "md" then 20 else 24
        end

        local function v179(p34) -- line: 891
            -- upvalues: p23 (copy), v65 (copy), RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 892
                -- upvalues: p34 (copy), p23 (copy), v65 (copy), RuntimeLib (copy), functions (copy)
                if (if p23.previewClaimIndexReward == nil then RuntimeLib.await(functions.claimIndexReward(p34.rewardId)) else p23.previewClaimIndexReward(p34)) ~= true then
                    return nil
                end

                v65(p34)
                task.delay(4.5, function() -- line: 898
                    -- upvalues: v65 (copy)
                    return v65(nil)
                end)
            end))
        end

        local v180 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.55
        })
        local v181, v182, v183, v184, v185, createElement, v186, v187, v188, v189, v190

        if v62 then
            v190 = react.createElement(default9)
        else
            v187 = v135 ~= nil and react.createElement(default5, {
                anchorPoint = Vector2.new(0.5, 0),
                color = getMutationColorGradient(Exclusive),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 4,
                    Font = v88.textFont2,
                    Size = UDim2.fromScale(0.5, 0.06)
                },
                position = UDim2.fromScale(0.5, 0.045),
                strokeProps = {
                    Color = Color3.fromRGB(0, 0, 0)
                },
                text = v135
            })
            v188 = false

            local v191 = v138 ~= nil

            if v191 then
                v181 = react.createElement("uicorner", {
                    CornerRadius = UDim.new(0.28, 0)
                })
                v182 = react.createElement("uistroke", {
                    Thickness = 0.055,
                    Transparency = 0.08,
                    Color = Color3.fromRGB(255, 225, 85),
                    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
                })
                v183 = react.createElement("uipadding", {
                    PaddingBottom = UDim.new(0.035, 0),
                    PaddingLeft = UDim.new(0.055, 0),
                    PaddingRight = UDim.new(0.055, 0),
                    PaddingTop = UDim.new(0.08, 0)
                })
                v184 = react.createElement(default5, {
                    shadowYScale = 0.035,
                    color = Color3.fromRGB(255, 235, 120),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 5,
                        Font = v88.textFont2,
                        Position = UDim2.fromScale(0, 0.08),
                        Size = UDim2.fromScale(1, 0.44)
                    },
                    strokeProps = {
                        Thickness = 0.05,
                        Color = Color3.fromRGB(0, 0, 0)
                    },
                    text = v138
                })
                v185 = {
                    shadowYScale = 0.025,
                    color = Color3.fromRGB(170, 255, 155),
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 5,
                        Font = v88.textFont2,
                        Position = UDim2.fromScale(0, 0.52),
                        Size = UDim2.fromScale(1, 0.36)
                    },
                    strokeProps = {
                        Thickness = 0.04,
                        Color = Color3.fromRGB(0, 0, 0)
                    }
                }

                if v139 ~= nil then
                    v185.text = v139
                else
                    v185.text = ""
                end

                createElement = react.createElement
                v186 = {
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(54, 38, 92),
                    Position = UDim2.fromScale(0.5, 0.13)
                }
                v186.Size = UDim2.fromScale(v142 and 0.78 or 0.66, 0.12)
                v189 = createElement("frame", v186, v181, v182, v183, v184, react.createElement(default5, v185))
            else
                v189 = v191
            end

            v181 = table.create(#v131)

            v182 = function(p35, p36) -- line: 1023
                -- upvalues: Exclusive (copy), v107 (copy), v110 (copy), v141 (copy), react (copy), default8 (copy), getExclusiveFishConfigByFishName (copy), getMutatedMoneyPerSecond (copy), isCollectionItemUnlocked (copy), t5 (copy), t6 (copy)
                local createElement = react.createElement
                local variant = p35.variant
                local t25 = {}

                t25.cardBackgroundColor = if variant ~= "hoola1" and variant ~= "hoola2" and variant ~= "hoola3" then nil else t5[variant]
                t25.imageId = p35.item.imageId
                t25.isNew = v107(p35.item.id, p35.variant)
                t25.isUnlocked = isCollectionItemUnlocked(p35.item, v110, p35.variant)
                t25.key = ("%*:%*"):format(p35.item.id, p35.variant)
                t25.layoutOrder = p36

                local moneyPerSecond = p35.item.moneyPerSecond
                local variant2 = p35.variant

                t25.moneyPerSecond = if variant2 ~= "Normal" then getMutatedMoneyPerSecond(moneyPerSecond, 1, { variant2 }) else moneyPerSecond

                if Exclusive == "Exclusive" then
                    local v192 = getExclusiveFishConfigByFishName(p35.item.id)

                    t25.moneyPerSecondLabel = if v192 == nil then nil else ("%*%%"):format((math.round(v192.mpsMultiplier * 100)))
                else
                    t25.moneyPerSecondLabel = nil
                end

                local variant3 = p35.variant

                t25.mutationBadgeLabel = if variant3 ~= "hoola1" and variant3 ~= "hoola2" and variant3 ~= "hoola3" then nil else t6[variant3]

                if Exclusive == "Hoola" then
                    local variant = p35.variant
                    local v194 = if variant == "hoola1" or variant == "hoola2" or variant == "hoola3" then t5[variant] else nil

                    if v194 ~= nil then
                        local v195, v196, v197 = v194:ToHSV()

                        t25.mutationColor = Color3.fromHSV(v195, math.min(v196 * 1.15, 1), v197 * 0.82)
                    else
                        t25.mutationColor = nil
                    end
                else
                    t25.mutationColor = v141
                end

                t25.name = p35.item.name
                t25.rarity = p35.item.rarity

                local id = p35.item.id
                local v199

                if id == "Goatzilla" then
                    v199 = "KaijUwU Zone apex fish encounter (1 in 3)"
                elseif Exclusive == "Exclusive" then
                    v199 = getExclusiveFishConfigByFishName(id)

                    if v199 ~= nil then
                        v199 = v199.unlockSource
                    end
                end

                t25.unlockSourceLabel = v199

                return createElement(default8, t25)
            end

            for v200, v201 in v131 do
                v181[v200] = v182(v201, v200 - 1, v131)
            end

            v183 = react.createElement
            v184 = react.Fragment
            v186 = react.createElement

            local t26 = {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, v174),
                Size = UDim2.fromScale(v142 and 0.96 or 0.95, v175)
            }
            local createElement2 = react.createElement(default7, {
                cellsPerRow = 5,
                clipsDescendants = true,
                zIndex = 3,
                anchorPoint = Vector2.new(0.5, 0.5),
                changed = {
                    AbsoluteCanvasSize = function() -- AbsoluteCanvasSize | line: 1056
                        -- upvalues: v146 (copy)
                        return v146()
                    end,
                    CanvasPosition = function() -- CanvasPosition | line: 1059
                        -- upvalues: v146 (copy)
                        return v146()
                    end
                },
                fillDirection = Enum.FillDirection.Horizontal,
                horizontalAlignment = if Exclusive == "Exclusive" then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center,
                listPaddingOffset = v169,
                padding = {
                    all = UDim.new(0, v168)
                },
                position = UDim2.fromScale(0.5, 0.5),
                ref = v145,
                rowsToBeVisible = n6,
                scrollBarColor = Color3.fromRGB(10, 10, 10),
                scrollBarThickness = v144,
                size = UDim2.fromScale(1, 1),
                verticalAlignment = Enum.VerticalAlignment.Top
            }, v181)

            v190 = v183(v184, nil, v187, v188, v189, v186("frame", t26, createElement2, #v131 == 0 and react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.62),
                Size = UDim2.fromScale(0.42, 0.08)
            }, react.createElement(default5, {
                text = "Nothing here yet",
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 5,
                    Font = v88.textFont2,
                    Size = UDim2.fromScale(1, 1)
                }
            }))))
        end

        v187 = react.createElement
        v189 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v167,
            Size = v143
        }
        v182 = react.createElement
        v184 = {
            aspectRatio = 1.55,
            title = "Index",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v4,
            onClose = p23.onClose,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }
        v185 = react.createElement
        createElement = {
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 21,
                Font = v88.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            }
        }

        if v62 then
            createElement.text = ("%*/%* Titles"):format(v77, n2)
        else
            createElement.text = ("%*/%* Fishes"):format(v129, previewTotalFishCount)
        end

        v184.titleNode = v185(default5, createElement)
        v182 = v182(default2, v184, v190)
        v183 = not v62 and react.createElement(FishDiscoveryRewardProgress, {
            discoveredCount = v129,
            onClaimReward = v179,
            rewardProgressPercent = v130,
            rewards = v70,
            totalCount = previewTotalFishCount
        })
        v184 = react.createElement

        local t29 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 40,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v176,
            Size = v136
        }

        createElement = react.createElement
        v186 = {
            cornerRadius = 0.25,
            zIndex = 40,
            anchorPoint = Vector2.new(0.5, 0.5)
        }

        if v62 then
            v186.color = ColorSequence.new(Color3.fromRGB(90, 170, 245))
        else
            v186.color = ColorSequence.new(Color3.fromRGB(245, 195, 70))
        end

        v186.frameSize = UDim2.fromScale(1, 1)
        v186.label = v62 and "Fishes" or "Titles"

        function v186.onClick() -- line: 1140
            -- upvalues: v63 (copy)
            return v63(function(p37) -- line: 1141
                return not p37
            end)
        end

        v186.position = UDim2.fromScale(0.5, 0.5)
        v187 = v187("frame", v189, v180, v182, v183, v184("frame", t29, createElement(default4, v186), previewHasNewTitlesBadge and not v62 and react.createElement(default, {
            zIndex = 50,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromOffset(4, 4),
            size = v177
        })))
        v190 = not v62

        if v190 then
            local v202 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, v171),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local v203 = table.create(#t2)
            local v204 = v170
            local v205 = v178

            v177 = function(p38, p39) -- line: 1164
                -- upvalues: Exclusive (copy), Exclusive2 (copy), v66 (copy), v94 (copy), v204 (copy), v205 (copy), react (copy), default (copy), default4 (copy), getMutationColorGradient (copy), getRarityColor (copy), v15 (copy), hoola3 (copy)
                local v206 = Exclusive == p38
                local v207 = v94(p38)
                local createElement = react.createElement
                local t30 = {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale(1, v204),
                    ZIndex = 31 + p39,
                    key = p38
                }
                local v208 = react.createElement(default4, {
                    color = if p38 == "Exclusive" then getRarityColor("exclusive")
                        elseif p38 == "Hoola" then hoola3
                        elseif p38 == "Normal" then v15
                        else getMutationColorGradient(p38),
                    cornerRadius = v206 and 0.075 or 0.055,
                    frameSize = UDim2.fromScale(v206 and 1.04 or 0.98, v206 and 1 or 0.92),
                    gradientRotation = if p38 == "Exclusive" then v66 else nil,
                    label = p38,
                    onClick = function() -- onClick | line: 1179
                        -- upvalues: p38 (copy), Exclusive2 (copy)
                        return Exclusive2(p38)
                    end,
                    popoutColor = if v206 then Color3.fromRGB(18, 18, 18) else Color3.fromRGB(45, 45, 45),
                    zIndex = 32 + p39
                })

                v207 = v207 and react.createElement(default, {
                    anchorPoint = Vector2.new(0.5, 0.5),
                    position = UDim2.fromScale(v206 and -0.52 or -0.49, v206 and -0.5 or -0.46),
                    size = UDim2.fromOffset(v205, v205),
                    zIndex = 33 + p39
                })

                return createElement("frame", t30, v208, v207)
            end

            for v209, v210 in t2 do
                v203[v209] = v177(v210, v209 - 1, t2)
            end

            v190 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 30,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(v172, 0.6),
                Size = v173
            }, v202, v203)
        end

        return react.createElement(react.Fragment, nil, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v187, v190), v64 ~= nil and react.createElement(default6, {
            title = "INDEX REWARD!",
            zIndex = 200,
            iconImage = if v64.kind == "goldAquariumSkin" then Gold else images.cash6stack,
            rewardText = v64.rewardText,
            uiScale = if v87 == "sm" or v87 == "md" then 0.78 else 1
        }))
    end
}

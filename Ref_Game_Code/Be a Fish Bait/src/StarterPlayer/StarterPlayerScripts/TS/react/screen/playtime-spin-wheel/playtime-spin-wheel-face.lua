-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "timeskip-reward").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local getSpinWheelSegmentDisplay, getTimeSkipMinutes, playtimeSpinWheelAssets, playtimeSpinWheelSegmentAngle = v1.getSpinWheelSegmentDisplay, v1.getTimeSkipMinutes, v1.playtimeSpinWheelAssets, v1.playtimeSpinWheelSegmentAngle
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function named(p1) -- line: 21
    return function(p2) -- line: 22
        -- upvalues: p1 (copy)
        if p2 then
            p2.Name = p1
        end
    end
end

local function getPolarPosition(p3, p4) -- line: 28
    local v2 = math.rad(p3)
    local v3 = math.sin(v2) * p4 * 0.5
    local v4 = -math.cos(v2) * p4 * 0.5

    return UDim2.fromScale(0.5 + v3, 0.5 + v4)
end

local t1 = {
    title_monarch = "MonarchTitleContent",
    cash_1b = "OneBCashContent",
    skin_jurassic = "JurassicSkinContent",
    cash_10b = "TenBCashContent",
    cash_50m = "FiftyMCashContent",
    cash_250m = "TwoFiftyMCashContent"
}
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 0))
})
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 235, 70))
})

local function ChunkyLabel(p5) -- line: 48
    -- upvalues: react (copy), default2 (copy)
    local t2 = {
        color = p5.color or Color3.fromRGB(255, 255, 255)
    }
    local t3 = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.FredokaOne,
        Position = p5.position,
        Size = p5.size,
        TextScaled = p5.fontSize == nil,
        TextSize = p5.fontSize
    }
    local textWrapped = p5.textWrapped

    t3.TextWrapped = textWrapped == nil or textWrapped
    t3.ZIndex = p5.zIndex
    t2.overrideProps = t3
    t2.shadowYScale = 0.08
    t2.strokeProps = {
        Thickness = 0.15,
        Color = Color3.fromRGB(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }
    t2.text = p5.text

    return react.createElement(default2, t2)
end

local function AnimatedChunkyLabel(p6) -- line: 77
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default2 (copy)
    local v7, v8 = useMotion(0)

    useEffect(function() -- line: 79
        -- upvalues: v8 (copy)
        v8:linear(360, {
            speed = 100
        })

        return (v8:onComplete(function() -- line: 86
            -- upvalues: v8 (copy)
            v8:immediate(0)
            v8:linear(360, {
                speed = 100
            })
        end))
    end, { v8 })

    return react.createElement(default2, {
        shadowYScale = 0.08,
        color = p6.color,
        gradientRotation = v7,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.FredokaOne,
            Position = p6.position,
            Size = p6.size,
            ZIndex = p6.zIndex
        },
        strokeProps = {
            Thickness = 0.15,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = p6.text
    })
end

local function MysteryRewardIcon(p7) -- line: 113
    -- upvalues: react (copy)
    local createElement = react.createElement
    local t4 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 19,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = p7.position,
        Size = p7.iconSize
    }
    local v9 = "RewardIcon"

    t4.ref = function(p8) -- line: 22
        -- upvalues: v9 (copy)
        if p8 then
            p8.Name = v9
        end
    end

    return createElement("frame", t4, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 19,
        Image = p7.iconImage,
        ImageColor3 = Color3.fromRGB(12, 12, 14),
        ImageTransparency = p7.iconImage == "" and 1 or 0,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "???",
        TextScaled = true,
        TextStrokeTransparency = 0,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1.28, 0.66),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    }))
end

local function RewardShine(p9) -- line: 144
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), images (copy)
    local v10, v11 = useMotion(0)

    useEffect(function() -- line: 146
        -- upvalues: v11 (copy)
        v11:linear(360, {
            speed = 24
        })

        return (v11:onComplete(function() -- line: 153
            -- upvalues: v11 (copy)
            v11:immediate(0)
            v11:linear(360, {
                speed = 24
            })
        end))
    end, { v11 })

    local createElement = react.createElement
    local t6 = {
        BackgroundTransparency = 1,
        ImageTransparency = 0.38,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = p9.position,
        Rotation = v10,
        ScaleType = Enum.ScaleType.Fit,
        Size = p9.size,
        ZIndex = p9.zIndex
    }
    local v12 = "RewardShine"

    t6.ref = function(p10) -- line: 22
        -- upvalues: v12 (copy)
        if p10 then
            p10.Name = v12
        end
    end

    return createElement("imagelabel", t6)
end

local function SliceContent(p11) -- line: 173
    -- upvalues: react (copy), default (copy), getSpinWheelSegmentDisplay (copy), getTimeSkipMinutes (copy), playtimeSpinWheelAssets (copy), getRarityColor (copy), getTitleData (copy), getAquariumSkinData (copy), t1 (copy), v5 (copy), v6 (copy), ChunkyLabel (copy), AnimatedChunkyLabel (copy), MysteryRewardIcon (copy), RewardShine (copy)
    local v13 = getSpinWheelSegmentDisplay(p11.segment, p11.totalMps)
    local v14 = if p11.segment.reward.kind == "title" then UDim2.fromScale(0.36, 0.095) else UDim2.fromScale(0.28, 0.06)
    local v15 = if p11.segment.reward.kind == "title" then UDim2.fromScale(0.27, 0.055) else UDim2.fromScale(0.22, 0.05)
    local v16 = UDim2.fromScale(0.15, 0.045)
    local v17 = UDim2.fromScale(0.12, 0.12)
    local v18 = p11.segment.reward.kind == "timeSkip"
    local v19 = p11.segment.reward.kind == "aquariumSkin"
    local v20 = if p11.segment.reward.kind == "title" then getTitleData(p11.segment.reward.titleId) else nil
    local v21 = if p11.segment.reward.kind == "aquariumSkin" then getAquariumSkinData(p11.segment.reward.skinName) else nil

    if v20 ~= nil then
        v20 = v20.animatedColor
    end

    local v22 = if p11.segment.reward.kind == "timeSkip" then getTimeSkipMinutes(p11.segment.reward.seconds) else nil
    local v23 = if v18 then Color3.fromRGB(255, 255, 255) else getRarityColor(p11.segment.rarity)
    local v24 = if p11.segment.rarity == "legendary" then playtimeSpinWheelAssets.LegendaryMysteryIcon
        elseif p11.segment.rarity == "mythic" then playtimeSpinWheelAssets.MythicMysteryIcon
        elseif p11.segment.rarity == "godly" then playtimeSpinWheelAssets.GodlyMysteryIcon
        else ""
    local v25 = t1[p11.segment.id]

    if v25 == nil then
        v25 = ("%*Content"):format(p11.segment.id)
    end

    local v26 = if p11.segment.reward.kind == "title" then 0.71 else 0.74
    local v27 = 0 * v26 * 0.5
    local v28 = -1 * v26 * 0.5
    local v29 = UDim2.fromScale(0.5 + v27, 0.5 + v28)
    local v30 = UDim2.fromScale(0.5, 0.28)
    local v31 = if p11.segment.reward.kind == "title" then 0.48 else 0.6
    local v32 = 0 * v31 * 0.5
    local v33 = -1 * v31 * 0.5
    local v34 = UDim2.fromScale(0.5 + v32, 0.5 + v33)
    local v35 = UDim2.fromScale(0.5, 0.36)
    local createElement = react.createElement
    local t7 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 18,
        Rotation = p11.segment.centerAngle,
        Size = UDim2.fromScale(1, 1),
        key = v25,
        ref = function(p12) -- line: 22
            -- upvalues: v25 (ref)
            if p12 then
                p12.Name = v25
            end
        end
    }
    local createElement2 = react.createElement
    local t8 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v29,
        Size = v14
    }
    local v36 = "RewardTitle"

    t8.ref = function(p13) -- line: 22
        -- upvalues: v36 (copy)
        if p13 then
            p13.Name = v36
        end
    end

    local v37 = createElement2("frame", t8, react.createElement(ChunkyLabel, {
        zIndex = 20,
        color = v23,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        text = v13.title
    }))
    local createElement3, RewardShine2, t9, v38, v39, v40

    if p11.segment.reward.kind == "title" then
        createElement3 = react.createElement
        RewardShine2 = RewardShine
        t9 = {
            zIndex = 18
        }
        v38 = if p11.segment.reward.kind == "title" then UDim2.fromScale(0.5, 0.25) else v30
        v40 = false
    elseif v21 ~= nil then
        createElement3 = react.createElement
        RewardShine2 = RewardShine
        t9 = {
            zIndex = 18
        }
        v38 = if p11.segment.reward.kind == "title" then UDim2.fromScale(0.5, 0.25) else v30
        v40 = false
    else
        v39 = false
        v40 = true
    end

    if not v40 then
        t9.position = v38

        if p11.segment.reward.kind == "title" then
            t9.size = UDim2.fromScale(0.26, 0.26)
        else
            t9.size = UDim2.fromScale(0.25, 0.25)
        end

        v39 = createElement3(RewardShine2, t9)
    end

    local v41

    if not v18 or v22 == nil then
        local v42 = if v18 then playtimeSpinWheelAssets.TimeSkipIcon == "" else nil

        if not v18 or v42 then
            if p11.segment.reward.kind ~= "title" then
                if v21 ~= nil then
                    local createElement = react.createElement
                    local t11 = {
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ZIndex = 19,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = v30,
                        Size = UDim2.fromScale(0.18, 0.18)
                    }
                    local v44 = "RewardIcon"

                    t11.ref = function(p15) -- line: 22
                        -- upvalues: v44 (copy)
                        if p15 then
                            p15.Name = v44
                        end
                    end

                    v41 = createElement("frame", t11, react.createElement("imagelabel", {
                        BackgroundTransparency = 1,
                        ZIndex = 19,
                        Image = v21.imageId,
                        ScaleType = Enum.ScaleType.Fit,
                        Size = UDim2.fromScale(1, 1)
                    }), react.createElement("frame", {
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ZIndex = 22,
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.fromScale(1.05, 0.1),
                        Size = UDim2.fromScale(0.56, 0.25)
                    }, react.createElement(ChunkyLabel, {
                        text = "+8%",
                        zIndex = 22,
                        color = v6,
                        position = UDim2.fromScale(0.5, 0.75),
                        size = UDim2.fromScale(0.7, 0.7)
                    })))
                elseif v24 == "" then
                    local createElement = react.createElement
                    local t10 = {
                        BackgroundTransparency = 0.08,
                        BorderSizePixel = 0,
                        TextScaled = true,
                        TextStrokeTransparency = 0,
                        ZIndex = 19,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = if v18 then Color3.fromRGB(31, 170, 61) elseif v19 then Color3.fromRGB(255, 114, 64) else Color3.fromRGB(255, 212, 46),
                        Font = Enum.Font.FredokaOne,
                        Position = v30,
                        Size = v17,
                        Text = if v18 then "$" elseif v19 then "SKIN" else "?",
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    }
                    local v43 = "RewardIcon"

                    t10.ref = function(p14) -- line: 22
                        -- upvalues: v43 (copy)
                        if p14 then
                            p14.Name = v43
                        end
                    end

                    v41 = createElement("textlabel", t10, react.createElement("uicorner", {
                        CornerRadius = UDim.new(1, 0)
                    }), react.createElement("uistroke", {
                        Thickness = 3,
                        Color = Color3.fromRGB(0, 0, 0)
                    }))
                else
                    v41 = react.createElement(MysteryRewardIcon, {
                        iconImage = v24,
                        iconSize = v17,
                        position = v30
                    })
                end
            end
        else
            local createElement = react.createElement
            local t12 = {
                BackgroundTransparency = 1,
                ZIndex = 19,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = playtimeSpinWheelAssets.TimeSkipIcon,
                Position = v30,
                ScaleType = Enum.ScaleType.Fit,
                Size = v17
            }
            local v45 = "RewardIcon"

            t12.ref = function(p16) -- line: 22
                -- upvalues: v45 (copy)
                if p16 then
                    p16.Name = v45
                end
            end

            v41 = createElement("imagelabel", t12)
        end
    else
        v41 = react.createElement(default, {
            showMinutes = false,
            zIndex = 19,
            minutes = v22,
            position = UDim2.fromScale(0.5, 0.275),
            size = UDim2.fromScale(0.24, 0.24),
            totalMps = p11.totalMps
        })
    end

    local v46 = not v18

    if v46 then
        local createElement = react.createElement
        local t13 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v34,
            Size = v15
        }
        local v47 = "RewardAmount"

        t13.ref = function(p17) -- line: 22
            -- upvalues: v47 (copy)
            if p17 then
                p17.Name = v47
            end
        end

        v46 = createElement("frame", t13, if v20 == nil then react.createElement(ChunkyLabel, {
            zIndex = 20,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            text = v13.shortText
        }) else react.createElement(AnimatedChunkyLabel, {
            zIndex = 20,
            color = v20,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            text = v13.shortText
        }))
    end

    local createElement4 = react.createElement
    local t14 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v35,
        Size = v16
    }
    local v48 = "ChanceLabel"

    t14.ref = function(p18) -- line: 22
        -- upvalues: v48 (copy)
        if p18 then
            p18.Name = v48
        end
    end

    return createElement("frame", t7, v37, v39, v41, v46, createElement4("frame", t14, react.createElement(ChunkyLabel, {
        zIndex = 20,
        color = v5,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        text = ("%*%%"):format(p11.segment.chance)
    })))
end

local function WheelFace(p19) -- line: 333
    -- upvalues: react (copy), playtimeSpinWheelAssets (copy), SliceContent (copy)
    local createElement = react.createElement
    local t15 = {
        BackgroundTransparency = 1,
        ZIndex = 10,
        Image = playtimeSpinWheelAssets.WheelFace,
        Position = UDim2.fromScale(0, 0),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1)
    }
    local v49 = "WheelFaceImage"

    t15.ref = function(p20) -- line: 22
        -- upvalues: v49 (copy)
        if p20 then
            p20.Name = v49
        end
    end

    local v50 = createElement("imagelabel", t15)
    local segments = p19.segments
    local v51 = table.create(#segments)

    for v52, v53 in segments do
        local _ = v52 - 1

        v51[v52] = react.createElement(SliceContent, {
            key = ("slice-content-%*"):format(v53.id),
            segment = v53,
            totalMps = p19.totalMps
        })
    end

    local createElement2, Fragment, createElement3 = react.createElement, react.Fragment, react.createElement
    local t16 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 18,
        Size = UDim2.fromScale(1, 1)
    }
    local v54 = "SliceContentLayer"

    t16.ref = function(p21) -- line: 22
        -- upvalues: v54 (copy)
        if p21 then
            p21.Name = v54
        end
    end

    return createElement2(Fragment, nil, v50, createElement3("frame", t16, v51))
end

local function Pointer(p22) -- line: 365
    -- upvalues: react (copy), playtimeSpinWheelAssets (copy)
    local createElement = react.createElement
    local t17 = {
        BackgroundTransparency = 1,
        ZIndex = 40,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = p22.position,
        Rotation = p22.rotation,
        Size = p22.size
    }
    local v55 = "PointerArrow"

    t17.ref = function(p23) -- line: 22
        -- upvalues: v55 (copy)
        if p23 then
            p23.Name = v55
        end
    end

    return createElement("frame", t17, react.createElement("uiscale", {
        Scale = p22.scale
    }), if playtimeSpinWheelAssets.Pointer == "" then react.createElement(react.Fragment, nil, react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 40,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(176, 238, 255),
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromScale(0.58, 0.66)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.22, 0)
    }), react.createElement("uistroke", {
        Thickness = 4,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 195, 240))
        })
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "▼",
        TextScaled = true,
        TextStrokeTransparency = 0,
        ZIndex = 41,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, 0.62),
        TextColor3 = Color3.fromRGB(176, 238, 255),
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    })) else react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 40,
        Image = playtimeSpinWheelAssets.Pointer,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1)
    }))
end

return {
    getSliceIndexUnderPointer = function(p24) -- getSliceIndexUnderPointer | line: 414
        -- upvalues: playtimeSpinWheelSegmentAngle (copy)
        return math.floor(((-p24 % 360 + 360) % 360 + playtimeSpinWheelSegmentAngle / 2) / playtimeSpinWheelSegmentAngle) % 6
    end,
    default = function(p25) -- PlaytimeSpinWheelFace | line: 418
        -- upvalues: react (copy), WheelFace (copy), Pointer (copy)
        local v57 = UDim2.fromScale(if p25.isSmall then 0.12 else 0.11, if p25.isSmall then 0.12 else 0.11)
        local v58 = UDim2.fromScale(0.5, 0.11)
        local v59 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v60 = react.createElement("uiscale", {
            Scale = p25.wheelScale
        })
        local v61 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local t18 = {
            segments = p25.segments
        }
        local totalMps = p25.totalMps

        t18.totalMps = if totalMps == nil then 0 else totalMps

        local createElement = react.createElement
        local t19 = {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = p25.position or UDim2.fromScale(0.5, 0.5),
            Size = p25.size
        }
        local v62 = "WheelStack"

        t19.ref = function(p26) -- line: 22
            -- upvalues: v62 (copy)
            if p26 then
                p26.Name = v62
            end
        end

        local createElement2 = react.createElement
        local t20 = {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Rotation = p25.rotation,
            Size = UDim2.fromScale(1, 1)
        }
        local v63 = "WheelRotator"

        t20.ref = function(p27) -- line: 22
            -- upvalues: v63 (copy)
            if p27 then
                p27.Name = v63
            end
        end

        return createElement("frame", t19, v59, v60, createElement2("frame", t20, v61, react.createElement(WheelFace, t18)), react.createElement(Pointer, {
            position = v58,
            rotation = p25.pointerRotation,
            scale = p25.pointerScale,
            size = v57
        }))
    end,
    playtimeSpinWheelSegmentAngle = playtimeSpinWheelSegmentAngle,
    segmentContentNames = t1
}

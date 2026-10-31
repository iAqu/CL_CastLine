-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "radial-background").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "sun-burst-background").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-badge").default
local useLoopMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-loop-motion").useLoopMotion
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getTextSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getTextSize
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function darken(p1, p2) -- line: 23
    return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2)
end

local function lighten(p3, p4) -- line: 26
    return Color3.new(math.min(p3.R * p4, 1), math.min(p3.G * p4, 1), (math.min(p3.B * p4, 1)))
end

local function makeInnerGradient(p5) -- line: 30
    -- upvalues: darken (copy), lighten (copy)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, darken(p5, 0.5)),
        ColorSequenceKeypoint.new(1, lighten(p5, 0.9))
    })
end

local function makeOuterGradient(p6) -- line: 36
    -- upvalues: lighten (copy)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, lighten(p6, 1)),
        ColorSequenceKeypoint.new(1, lighten(p6, 1.2))
    })
end

local t1 = {}
local t2 = {
    iconRotation = -7,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(236, 91, 72)),
    outerGradient = makeOuterGradient(Color3.fromRGB(236, 91, 72)),
    popoutColor = Color3.fromRGB(41, 20, 18)
}
local v6 = Color3.fromRGB(236, 91, 72)

t2.shadowColor = Color3.new(v6.R * 0.4, v6.G * 0.4, v6.B * 0.4)
t1.store = t2

local t3 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(235, 151, 46)),
    outerGradient = makeOuterGradient(Color3.fromRGB(255, 188, 56)),
    popoutColor = Color3.fromRGB(58, 35, 10)
}
local v7 = Color3.fromRGB(235, 151, 46)

t3.shadowColor = Color3.new(v7.R * 0.4, v7.G * 0.4, v7.B * 0.4)
t1.aura = t3
t1.charm = {
    iconRotation = -5,
    iconScale = 0.62,
    innerGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 225, 241)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 38, 64))
    }),
    outerGradient = makeOuterGradient(Color3.fromRGB(73, 223, 239)),
    popoutColor = Color3.fromRGB(72, 21, 33),
    shadowColor = Color3.fromRGB(77, 23, 37)
}

local t4 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 251, 248)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(81, 239, 251))
    }),
    outerGradient = makeOuterGradient(Color3.fromRGB(160, 251, 248)),
    popoutColor = Color3.fromRGB(54, 153, 161)
}
local v8 = Color3.fromRGB(81, 239, 251)

t4.shadowColor = Color3.new(v8.R * 0.4, v8.G * 0.4, v8.B * 0.4)
t1.event = t4

local t5 = {
    iconRotation = 0,
    innerGradient = makeInnerGradient(Color3.fromRGB(197, 55, 78)),
    outerGradient = makeOuterGradient(Color3.fromRGB(197, 55, 78)),
    popoutColor = Color3.fromRGB(39, 25, 22)
}
local v9 = Color3.fromRGB(197, 55, 78)

t5.shadowColor = Color3.new(v9.R * 0.4, v9.G * 0.4, v9.B * 0.4)
t1.rebirth = t5

local t6 = {
    iconRotation = 0,
    innerGradient = makeInnerGradient(Color3.fromRGB(76, 178, 116)),
    outerGradient = makeOuterGradient(Color3.fromRGB(76, 178, 116)),
    popoutColor = Color3.fromRGB(27, 22, 50)
}
local v10 = Color3.fromRGB(76, 178, 116)

t6.shadowColor = Color3.new(v10.R * 0.4, v10.G * 0.4, v10.B * 0.4)
t1.index = t6

local t7 = {
    iconRotation = 0,
    innerGradient = makeInnerGradient(Color3.fromRGB(100, 140, 220)),
    outerGradient = makeOuterGradient(Color3.fromRGB(100, 140, 220)),
    popoutColor = Color3.fromRGB(20, 25, 50)
}
local v11 = Color3.fromRGB(100, 140, 220)

t7.shadowColor = Color3.new(v11.R * 0.4, v11.G * 0.4, v11.B * 0.4)
t1.feedback = t7

local t8 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(150, 90, 230)),
    outerGradient = makeOuterGradient(Color3.fromRGB(150, 90, 230)),
    popoutColor = Color3.fromRGB(40, 20, 55)
}
local v12 = Color3.fromRGB(150, 90, 230)

t8.shadowColor = Color3.new(v12.R * 0.4, v12.G * 0.4, v12.B * 0.4)
t1.daily = t8

local t9 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(240, 140, 30)),
    outerGradient = makeOuterGradient(Color3.fromRGB(240, 140, 30)),
    popoutColor = Color3.fromRGB(70, 35, 10)
}
local v13 = Color3.fromRGB(240, 140, 30)

t9.shadowColor = Color3.new(v13.R * 0.4, v13.G * 0.4, v13.B * 0.4)
t1.challenge = t9

local t10 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(235, 195, 40)),
    outerGradient = makeOuterGradient(Color3.fromRGB(235, 195, 40)),
    popoutColor = Color3.fromRGB(70, 55, 10)
}
local v14 = Color3.fromRGB(235, 195, 40)

t10.shadowColor = Color3.new(v14.R * 0.4, v14.G * 0.4, v14.B * 0.4)
t1.eventStore = t10

local t11 = {
    iconRotation = 0,
    iconScale = 0.7,
    innerGradient = makeInnerGradient(Color3.fromRGB(120, 110, 255)),
    outerGradient = makeOuterGradient(Color3.fromRGB(120, 110, 255)),
    popoutColor = Color3.fromRGB(35, 25, 70)
}
local v15 = Color3.fromRGB(120, 110, 255)

t11.shadowColor = Color3.new(v15.R * 0.4, v15.G * 0.4, v15.B * 0.4)
t1.shards = t11

local function buildShineSequence(p7) -- line: 134
    local t12 = {
        {
            t = 0,
            v = 1
        }
    }

    for _, v16 in p7 do
        local v17 = v16.width / 2

        table.insert(t12, {
            v = 1,
            t = v16.center - v17
        })
        table.insert(t12, {
            t = v16.center,
            v = v16.transparency
        })
        table.insert(t12, {
            v = 1,
            t = v16.center + v17
        })
    end

    table.insert(t12, {
        t = 1,
        v = 1
    })

    for _, v18 in t12 do
        v18.t = math.clamp(v18.t, 0, 1)
    end

    table.sort(t12, function(p8, p9) -- line: 166
        return p8.t < p9.t
    end)

    local t17 = {}
    local n1 = -1

    for _, v19 in t12 do
        local t = v19.t

        n1 = if t <= n1 then math.min(n1 + 1E-04, 1) else t
        table.insert(t17, (NumberSequenceKeypoint.new(n1, v19.v)))
    end

    return NumberSequence.new(t17)
end

local function LegacySidebarItem(p10) -- line: 183
    -- upvalues: react (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), useLoopMotion (copy), useScreenSizeState (copy), getTextSize (copy), images (copy)
    local v22 = useScreenSizeState()
    local v23 = useLoopMotion({
        min = -0.05,
        max = 0.05,
        motionType = "linear",
        linearOptions = {
            speed = 0.75
        }
    })[1]
    local v24

    if p10.floating then
        v24 = v23:map(function(p11) -- line: 196
            -- upvalues: p10 (copy)
            local imageXScale = p10.imageXScale

            if imageXScale == nil then
                imageXScale = 0.5
            end

            return UDim2.fromScale(imageXScale, 0.5 + p11)
        end)
    else
        local imageXScale = p10.imageXScale

        if imageXScale == nil then
            imageXScale = 0.5
        end

        v24 = UDim2.fromScale(imageXScale, 0.5)
    end

    local v25

    if p10.radialSizeScale ~= nil and p10.radialSizeScale ~= 0 then
        local t18 = {
            anchorPoint = Vector2.new(0.5, 0.5),
            imageId = images.radialBackground2,
            position = UDim2.fromScale(0.5, 0.5)
        }
        local radialSizeScale = p10.radialSizeScale

        if radialSizeScale == nil then
            radialSizeScale = 1.2
        end

        local radialSizeScale2 = p10.radialSizeScale

        if radialSizeScale2 == nil then
            radialSizeScale2 = 1.2
        end

        t18.size = UDim2.fromScale(radialSizeScale, radialSizeScale2)
        t18.zIndex = 0
        v25 = react.createElement(default4, t18)
    end

    local v26

    if p10.sunBurstSizeScale ~= nil and p10.sunBurstSizeScale ~= 0 then
        local t19 = {
            doRotate = true,
            anchorPoint = Vector2.new(0.5, 0.5),
            imageColor3 = Color3.fromRGB(255, 255, 255)
        }
        local imageXScale = p10.imageXScale

        if imageXScale == nil then
            imageXScale = 0.5
        end

        t19.position = UDim2.fromScale(imageXScale, 0.5)

        local sunBurstSizeScale = p10.sunBurstSizeScale

        if sunBurstSizeScale == nil then
            sunBurstSizeScale = 1.2
        end

        local sunBurstSizeScale2 = p10.sunBurstSizeScale

        if sunBurstSizeScale2 == nil then
            sunBurstSizeScale2 = 1.2
        end

        t19.size = UDim2.fromScale(sunBurstSizeScale, sunBurstSizeScale2)
        t19.zIndex = 0
        v26 = react.createElement(default5, t19)
    end

    local t20 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = p10.imageId,
        ImageColor3 = p10.imageColor or nil,
        Position = v24,
        ScaleType = Enum.ScaleType.Fit
    }
    local imageSizeScale = p10.imageSizeScale

    if imageSizeScale == nil then
        imageSizeScale = 1
    end

    local imageSizeScale2 = p10.imageSizeScale

    if imageSizeScale2 == nil then
        imageSizeScale2 = 1
    end

    t20.Size = UDim2.fromScale(imageSizeScale, imageSizeScale2)

    local v27 = react.createElement("imagelabel", t20)
    local t21 = {}
    local t22 = {
        TextSize = getTextSize(v22, p10.textSize or "md"),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }
    local titleXPosition = p10.titleXPosition

    if titleXPosition == nil then
        titleXPosition = 0.5
    end

    local titleYScale = p10.titleYScale

    if titleYScale == nil then
        titleYScale = 1
    end

    t22.Position = UDim2.fromScale(titleXPosition, titleYScale)
    t22.TextScaled = false

    local richText = p10.richText

    t22.RichText = richText ~= nil and richText
    t21.overrideProps = t22
    t21.text = p10.title
    t21.textColor3 = Color3.fromRGB(255, 255, 255)

    return react.createElement(default3, {
        darkenOnHover = false,
        uiAspectRatio = 1,
        anchorPoint = Vector2.new(0.5, 0.5),
        onClick = p10.onClick,
        position = UDim2.fromScale(0.5, 0.5),
        size = p10.size
    }, v25, v26, v27, react.createElement(default6, t21))
end

local function RobloxTileSidebarItem(p12) -- line: 310
    -- upvalues: react (copy), useBinding (copy), useEffect (copy), useBindingListener (copy), useMotion (copy), default (copy), default2 (copy), useSound (copy), useTheme (copy), default7 (copy), useLoopMotion (copy), t1 (copy), buildShineSequence (copy)
    local bannerIconInset = p12.bannerIconInset

    if bannerIconInset == nil then
        bannerIconInset = 0.13
    end

    local bannerIconSize = p12.bannerIconSize

    if bannerIconSize == nil then
        bannerIconSize = UDim2.fromScale(0.5, 0.7)
    end

    local bannerLabelSize = p12.bannerLabelSize

    if bannerLabelSize == nil then
        bannerLabelSize = UDim2.fromScale(0.5, 0.6)
    end

    local eventRegistered, icon, isMaxRebirth, label = p12.eventRegistered, p12.icon, p12.isMaxRebirth, p12.label
    local layoutOrder, onClick, position, rebirthPercent = p12.layoutOrder, p12.onClick, p12.position, p12.rebirthPercent
    local showNotification, size, square = p12.showNotification, p12.size, p12.square

    if square == nil then
        square = true
    end

    local variant = p12.variant
    local v28 = t1[variant]
    local v29 = useTheme()
    local v30 = size or UDim2.fromOffset(88, 88)
    local v31 = variant == "store"
    local v32 = variant == "aura"
    local v33 = variant == "event"
    local v34, v35, v36

    if v31 then
        v34 = "SALE!"
        v35 = UDim2.fromScale(0.86, 0.04)
        v36 = 12
    else
        if v32 then
            v34 = "NEW!"
        end

        v35 = UDim2.fromScale(0.14, 0.04)
        v36 = -12
    end

    local v37 = if v32 then ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 255, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 190, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 108, 255))
    }) else ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 54, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(227, 31, 31))
    })
    local playSound = useSound("ButtonClick").playSound
    local playSound2 = useSound("ButtonHover").playSound
    local v38, v39 = useBinding(false)
    local v40, v41 = useBinding(false)
    local v42, v43 = useMotion(1)
    local v44 = variant == "rebirth"

    v44 = v44 and (if rebirthPercent == nil then 0 else rebirthPercent) >= 100

    local v45 = v33 and eventRegistered ~= true
    local v46 = v44 or v32 or v45
    local v47 = Color3.fromRGB(33, 33, 33)
    local v48 = if v32 then Color3.fromRGB(140, 199, 247) else Color3.fromRGB(255, 230, 80)
    local v49 = useLoopMotion({
        min = 0,
        max = 1,
        motionType = "linear",
        linearOptions = {
            speed = 0.6
        }
    })[1]:map(function(p13) -- line: 377
        -- upvalues: v47 (copy), v48 (copy)
        return v47:Lerp(v48, p13)
    end)

    if not v46 then
        v49 = v47
    end

    local v50, v51 = useMotion(0)
    local v52, v53 = useMotion(0)

    useEffect(function() -- line: 385
        -- upvalues: v51 (copy), v53 (copy), v34 (ref)
        if v34 == nil then
            return nil
        end

        local v54 = true

        task.spawn(function() -- line: 390
            -- upvalues: v54 (ref), v51 (copy), v53 (copy)
            while v54 do
                task.wait(3 + math.random() * 3)

                if v54 then
                    v51:spring(1, {
                        frequency = 7,
                        damping = 0.7
                    })
                    task.wait(0.12)

                    for _, v55 in {
                            16, -14, 12, -10, 8, -6, 4, -2,
                            0
                        } do
                        if not v54 then
                            break
                        end

                        v53:immediate(v55)
                        task.wait(0.035)
                    end

                    v51:spring(0, {
                        frequency = 5,
                        damping = 0.8
                    })
                    continue
                end

                break
            end
        end)

        return function() -- line: 418
            -- upvalues: v54 (ref)
            v54 = false
        end
    end, { v34, v51, v53 })
    useBindingListener(v38, function(p14) -- line: 422
        -- upvalues: v43 (copy)
        v43:spring(p14 and 1.05 or 1, {
            frequency = 0.1
        })
    end)
    useBindingListener(v40, function(p15) -- line: 427
        -- upvalues: v38 (copy), v43 (copy)
        if p15 then
            v43:spring(0.93, {
                frequency = 0.1
            })
        else
            v43:spring(v38:getValue() and 1.05 or 1, {
                frequency = 0.1
            })
        end
    end)

    local v58 = v42:map(function(p16) -- line: 438
        -- upvalues: v30 (copy)
        return UDim2.new(v30.X.Scale * p16, v30.X.Offset * p16, v30.Y.Scale * p16, v30.Y.Offset * p16)
    end)
    local v59, v60

    if square then
        v60 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        v59 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
    else
        v59 = square
        v60 = square
    end

    local v61 = react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 12,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = v28.shadowColor,
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(1, 0.05)
    })
    local v62 = react.createElement(default, {
        cornerRadius = 0,
        isStudded = true,
        isStuddedTransparency = 0.2,
        strokeThickness = 0.045,
        textureTransparency = 0.5,
        zIndex = 11,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = v28.outerGradient,
        position = UDim2.fromScale(0.5, 0),
        size = UDim2.fromScale(1, 1.02),
        strokeColor = v49
    }, react.createElement(default, {
        cornerRadius = 0,
        isStudded = true,
        isStuddedTransparency = 0.4,
        strokeThickness = 0,
        textureTransparency = 0.4,
        zIndex = 12,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = v28.innerGradient,
        position = UDim2.fromScale(0.5, 0.04),
        size = UDim2.fromScale(0.92, 0.86),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, react.createElement("frame", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 15,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uigradient", {
        Rotation = -45,
        Transparency = buildShineSequence({
            {
                center = 0.1,
                width = 0.3,
                transparency = 0.9
            },
            {
                center = 0.6,
                width = 0.2,
                transparency = 0.86
            },
            {
                center = 0.35,
                width = 0.12,
                transparency = 0.86
            },
            {
                center = 0.78,
                width = 0.1,
                transparency = 0.86
            }
        })
    }))))
    local v63

    if square then
        local t23 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            Position = v50:map(function(p17) -- line: 513
                return UDim2.fromScale(0.5, 0.38 - p17 * 0.1)
            end),
            Rotation = v52:map(function(p18) -- line: 516
                -- upvalues: v28 (copy)
                local iconRotation = v28.iconRotation

                if iconRotation == nil then
                    iconRotation = 0
                end

                return iconRotation + p18
            end),
            ScaleType = Enum.ScaleType.Fit
        }
        local iconScale = v28.iconScale

        if iconScale == nil then
            iconScale = 0.65
        end

        local iconScale2 = v28.iconScale

        if iconScale2 == nil then
            iconScale2 = 0.65
        end

        t23.Size = UDim2.fromScale(iconScale, iconScale2)
        t23.ZIndex = 20
        v63 = react.createElement("imagelabel", t23, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
    else
        local t24 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            Position = UDim2.fromScale(bannerIconInset, 0.5)
        }
        local iconRotation = v28.iconRotation

        t24.Rotation = if iconRotation == nil then 0 else iconRotation
        t24.ScaleType = Enum.ScaleType.Fit
        t24.Size = bannerIconSize
        t24.ZIndex = 20

        local v64 = react.createElement("imagelabel", t24, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))
        local t25 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            Position = UDim2.fromScale(1 - bannerIconInset, 0.5)
        }
        local iconRotation2 = v28.iconRotation

        t25.Rotation = if iconRotation2 == nil then 0 else iconRotation2
        t25.ScaleType = Enum.ScaleType.Fit
        t25.Size = bannerIconSize
        t25.ZIndex = 20
        v63 = react.createElement(react.Fragment, nil, v64, react.createElement("imagelabel", t25, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })))
    end

    local createElement = react.createElement
    local t26 = {
        BackgroundTransparency = 1,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0.5),
        LayoutOrder = layoutOrder,
        Position = position,
        Size = v30
    }
    local createElement2 = react.createElement
    local t27 = {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Event = {
            Activated = function() -- Activated | line: 587
                -- upvalues: onClick (copy), playSound (copy)
                playSound()
                onClick()
            end,
            MouseEnter = function() -- MouseEnter | line: 591
                -- upvalues: playSound2 (copy), v39 (copy)
                playSound2()
                v39(true)
            end,
            MouseLeave = function() -- MouseLeave | line: 595
                -- upvalues: v39 (copy)
                return v39(false)
            end,
            MouseButton1Down = function() -- MouseButton1Down | line: 598
                -- upvalues: v41 (copy)
                return v41(true)
            end,
            MouseButton1Up = function() -- MouseButton1Up | line: 601
                -- upvalues: v41 (copy)
                return v41(false)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = v58
    }
    local v65 = false

    if v34 ~= nil then
        local createElement = react.createElement
        local t29 = {
            BackgroundTransparency = 1,
            ZIndex = 22,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = v35
        }
        local v66 = v36

        t29.Rotation = v52:map(function(p19) -- line: 612
            -- upvalues: v66 (copy)
            return v66 + p19
        end)
        t29.Size = UDim2.fromScale(0.7, 0.38)
        v65 = createElement("frame", t29, react.createElement(default2, {
            shadowYScale = 0.12,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v37,
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                ZIndex = 22,
                Font = v29.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1)
            },
            popoutColor = Color3.fromRGB(0, 0, 0),
            strokeProps = {
                Thickness = 0.14,
                Color = Color3.fromRGB(0, 0, 0),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = v34
        }))
    end

    local createElement3 = react.createElement
    local t30 = {
        shadowYScale = 0.15
    }

    t30.anchorPoint = Vector2.new(0.5, square and 1 or 0.5)
    t30.color = Color3.fromRGB(255, 255, 255)

    local t31 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 21,
        Font = v29.textFont2
    }

    if square then
        t31.Position = UDim2.fromScale(0.5, 0.93)
        bannerLabelSize = UDim2.fromScale(0.95, 0.26)
    else
        t31.Position = UDim2.fromScale(0.5, 0.5)
    end

    t31.Size = bannerLabelSize
    t30.overrideProps = t31
    t30.strokeProps = {
        Thickness = 0.1,
        Color = Color3.fromRGB(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }
    t30.text = label

    return createElement("frame", t26, v60, createElement2("imagebutton", t27, v59, v61, v62, v63, v65, createElement3(default2, t30)), showNotification and react.createElement(default7, {
        zIndex = 25,
        anchorPoint = Vector2.new(0.5, 0.5),
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(0.35, 0.35)
    }), rebirthPercent ~= nil and react.createElement(default2, {
        shadowYScale = 0.15,
        anchorPoint = Vector2.new(0.5, 0),
        color = if isMaxRebirth then Color3.fromRGB(255, 0, 0) elseif rebirthPercent >= 100 then Color3.fromRGB(3, 247, 3) else Color3.fromRGB(255, 255, 255),
        overrideProps = {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 21,
            Font = v29.textFont2,
            Position = UDim2.fromScale(0.5, 1.04),
            Size = UDim2.fromScale(1, 0.22)
        },
        strokeProps = {
            Thickness = 0.12,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = if isMaxRebirth then "MAXED" elseif rebirthPercent >= 100 then "READY" else ("%*%%"):format((math.floor((math.min(rebirthPercent, 100)))))
    }))
end

return {
    default = function(p20) -- SidebarItem | line: 679
        -- upvalues: react (copy), LegacySidebarItem (copy), RobloxTileSidebarItem (copy)
        if p20.imageId == nil then
            local v71 = table.clone(p20)

            setmetatable(v71, nil)

            return react.createElement(RobloxTileSidebarItem, v71)
        end

        local v72 = table.clone(p20)

        setmetatable(v72, nil)

        return react.createElement(LegacySidebarItem, v72)
    end
}

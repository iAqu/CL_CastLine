-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers
local selectWeatherLastEnded = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "weather-last-ended.selectors").selectWeatherLastEnded
local weathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "weathers").weathers
local currentRollChance = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "weather-roll-utils").currentRollChance
local default = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-countdown").default
local useChild = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-child").useChild
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default

local function formatHms(p1) -- line: 22
    local v2 = math.max(0, (math.floor(p1)))
    local v4 = math.floor(v2 / 3600)
    local v6 = math.floor(v2 % 3600 / 60)
    local v7 = v2 % 60

    local function v8(p2) -- line: 27
        if p2 < 10 then
            return (("0%*"):format(p2))
        end

        return (tostring(p2))
    end

    return (("%*:%*:%*"):format(if v4 < 10 then ("0%*"):format(v4) else tostring(v4), if v6 < 10 then ("0%*"):format(v6) else tostring(v6), if v7 < 10 then ("0%*"):format(v7) else tostring(v7)))
end

local function formatRelativeTimeAgo(p3) -- line: 32
    local v10 = math.max(0, (math.floor(p3)))

    if v10 < 60 then
        return (("%* %* Ago"):format(v10, if v10 == 1 then "Second" else "Seconds"))
    end

    local v12 = math.floor(v10 / 60)

    if v12 < 60 then
        return (("%* %* Ago"):format(v12, if v12 == 1 then "Min" else "Mins"))
    end

    local v14 = math.floor(v12 / 60)

    if v14 < 24 then
        return (("%* %* Ago"):format(v14, if v14 == 1 then "hour" else "hours"))
    end

    local v16 = math.floor(v14 / 24)

    return (("%* %* Ago"):format(v16, if v16 == 1 then "day" else "days"))
end

local function getNextSlotTimestamp(p4) -- line: 48
    -- upvalues: Workspace (copy)
    local v17 = p4.cooldown * 60

    return math.floor(Workspace:GetServerTimeNow() / v17) * v17 + v17
end

local function useElapsedSeconds(p5) -- line: 54
    -- upvalues: useEffect (copy), useState (copy), RunService (copy), Workspace (copy)
    local v20, v21 = useState(if p5 == nil then 0 else Workspace:GetServerTimeNow() - p5)

    useEffect(function() -- line: 56
        -- upvalues: p5 (copy), v21 (copy), RunService (copy), Workspace (copy)
        if p5 == nil then
            return nil
        end

        local connection = RunService.Heartbeat:Connect(function() -- line: 60
            -- upvalues: p5 (copy), v21 (copy), Workspace (copy)
            v21(Workspace:GetServerTimeNow() - p5)
        end)

        return function() -- line: 63
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { p5 })

    if p5 == nil then
        return 0
    end

    return v20
end

local t1 = {
    Delulu = {
        nameGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 170))
        }),
        rowGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 90, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 40, 130))
        }),
        timerColor = Color3.fromRGB(255, 190, 240)
    },
    Glitched = {
        nameGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 60, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 20, 180))
        }),
        rowGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 120))
        }),
        timerColor = Color3.fromRGB(200, 140, 255)
    },
    ["Unc's Calling"] = {
        nameGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 130, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 79, 79))
        }),
        rowGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 105, 105)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 79, 79))
        }),
        timerColor = Color3.fromRGB(180, 230, 230)
    }
}
local t2 = {
    nameGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 100, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 50, 10))
    }),
    rowGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 10))
    }),
    timerColor = Color3.fromRGB(255, 200, 100)
}

local function getWeatherStyle(p6) -- line: 92
    -- upvalues: t1 (copy), t2 (copy)
    return t1[p6] or t2
end

local v22 = Color3.fromRGB(255, 255, 255)
local v23 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 255, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 10))
})

local function WeatherRow(p7) -- line: 98
    -- upvalues: react (copy), currentRollChance (copy), default (copy), default2 (copy), default3 (copy), formatHms (copy), formatRelativeTimeAgo (copy), useElapsedSeconds (copy), v22 (copy), v23 (copy)
    local secondsLeft = default(p7.countdownTarget).secondsLeft
    local v24 = useElapsedSeconds(p7.elapsedSinceTarget)
    local v25 = p7.buffText ~= nil
    local v26 = if p7.elapsedSinceTarget == nil then if p7.countdownTarget == nil then "00:00:00" else secondsLeft:map(function(p8) -- line: 103
        -- upvalues: formatHms (copy)
        return (formatHms(p8))
    end)
        elseif p7.useWordsAgoFormat then formatRelativeTimeAgo(v24)
        else formatHms(v24)
    local v27 = if p7.isActive or p7.rollSchedule == nil then nil else currentRollChance(p7.rollSchedule, v24)
    local v28 = if v25 then 0.22 elseif v27 == nil then 0.54 else 0.26
    local v29 = react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.015, 0.5),
        Size = UDim2.fromScale(0.3, 0.82)
    }, react.createElement(default2, {
        cornerRadius = 0,
        isStudded = true,
        isStuddedTransparency = 0,
        strokeThickness = 0.04,
        textureTransparency = 0.6,
        tileSize = 45,
        backgroundColor = p7.style.nameGradient,
        position = UDim2.fromScale(0, 0),
        size = UDim2.fromScale(1, p7.secondaryLabel == nil and 1 or 0.46),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, react.createElement(default3, {
        shadowYScale = 0.07,
        color = v22,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.9),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        text = string.upper(p7.label)
    })), p7.secondaryLabel ~= nil and react.createElement(default2, {
        cornerRadius = 0,
        isStudded = true,
        isStuddedTransparency = 0,
        strokeThickness = 0.04,
        textureTransparency = 0.6,
        tileSize = 45,
        backgroundColor = p7.secondaryStyle.nameGradient,
        position = UDim2.fromScale(0, 0.54),
        size = UDim2.fromScale(1, 0.46),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, react.createElement(default3, {
        shadowYScale = 0.07,
        color = v22,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.9),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        text = string.upper(p7.secondaryLabel)
    })))
    local t5 = {
        shadowYScale = 0.07,
        color = v22,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.335, 0.5),
            Size = UDim2.fromScale(0.09, 0.9),
            TextXAlignment = Enum.TextXAlignment.Center
        }
    }
    local prefix = p7.prefix

    if prefix == nil then
        prefix = if p7.isActive then "IS" else "IN"
    end

    t5.text = prefix

    return react.createElement(default2, {
        isStudded = true,
        isStuddedTransparency = 0,
        strokeThickness = 0.03,
        textureTransparency = 0.5,
        tileSize = 55,
        backgroundColor = p7.style.rowGradient,
        layoutOrder = p7.layoutOrder,
        size = UDim2.fromScale(1, 0.48),
        strokeColor = Color3.fromRGB(0, 0, 0)
    }, v29, react.createElement(default3, t5), if p7.isActive then react.createElement(default3, {
        shadowYScale = 0.07,
        text = "AVAILABLE!",
        color = v23,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.44, 0.5),
            Size = UDim2.fromScale(v28, 0.9),
            TextXAlignment = Enum.TextXAlignment.Left
        }
    }) else react.createElement(default3, {
        shadowYScale = 0.07,
        color = p7.style.timerColor,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.44, 0.5),
            Size = UDim2.fromScale(v28, 0.9),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = v26
    }), v27 ~= nil and react.createElement(default3, {
        shadowYScale = 0.07,
        color = v23,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(1, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.98, 0.5),
            Size = UDim2.fromScale(0.2, 0.5),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        text = ("%*%% CHANCE"):format((math.floor(v27 * 100)))
    }), v25 and react.createElement(default3, {
        shadowYScale = 0.07,
        color = v23,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(1, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.98, 0.5),
            Size = UDim2.fromScale(0.3, 0.9),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        text = p7.buffText
    }))
end

local function WeatherTimerSurfaceGui(p9) -- line: 249
    -- upvalues: react (copy), createPortal (copy), Workspace (copy), useRootSelector (copy), selectCurrentWeathers (copy), selectWeatherLastEnded (copy), weathers (copy), useChild (copy), t1 (copy), t2 (copy), WeatherRow (copy)
    local BasePart = useChild(p9.component.instance, "Board", "BasePart")
    local v34 = useRootSelector(selectCurrentWeathers)
    local v35 = useRootSelector(selectWeatherLastEnded)
    local n1 = 1e999
    local v37, v38
    local v36

    for _, v39 in weathers do
        if not v39.rollSchedule then
            if v34[v39.name] ~= nil then
                if v37 ~= nil then
                    if v39.name == "Unc's Calling" then
                        v37, v38 = v39, v37
                    else
                        v38 = v39
                    end
                else
                    v37 = v39
                end
            end

            local v40 = v39.cooldown * 60
            local v42 = math.floor(Workspace:GetServerTimeNow() / v40) * v40 + v40

            if v42 < n1 then
                n1 = v42
                v36 = v39
            end
        end
    end

    local v43 = v37 or v36
    local n2 = 1e999
    local v44

    for _, v45 in weathers do
        if v45.rollSchedule then
            local v46 = v35[v45.name]

            if v46 ~= nil and v46 < n2 then
                v44 = v45
                n2 = v46
            end
        end
    end

    local v47 = if v43 then v34[v43.name] else nil
    local v48 = if v44 then v34[v44.name] else nil

    if not BasePart then
        return nil
    end

    local v49 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.04, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    if v43 then
        local t8 = {
            layoutOrder = 1,
            buffText = v43.buffText,
            countdownTarget = if v47 then v47.endTimestamp else n1,
            isActive = v47 ~= nil,
            label = v43.title,
            secondaryLabel = if v38 == nil then v38 else v38.title,
            secondaryStyle = if v38 then t1[v38.name] or t2 else nil,
            style = t1[v43.name] or t2
        }

        v43 = react.createElement(WeatherRow, t8)
    end

    local createElement = react.createElement
    local t9 = {
        LightInfluence = 0,
        PixelsPerStud = 10,
        ResetOnSpawn = false,
        Adornee = BasePart,
        Face = Enum.NormalId.Front,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    }
    local createElement2 = react.createElement
    local t10 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.96, 0.92)
    }

    if v44 then
        local createElement = react.createElement
        local t11 = {
            layoutOrder = 2,
            buffText = v44.buffText
        }

        if v48 then
            n2 = nil
            t11.countdownTarget = v48.endTimestamp
        else
            t11.countdownTarget = nil
        end

        t11.elapsedSinceTarget = n2
        t11.isActive = v48 ~= nil
        t11.label = v44.title
        t11.prefix = if v48 then nil else "SINCE"
        t11.rollSchedule = v44.rollSchedule
        t11.style = t1[v44.name] or t2
        t11.useWordsAgoFormat = v44.name == "Delulu"
        v44 = createElement(WeatherRow, t11)
    end

    return createPortal(createElement("surfacegui", t9, createElement2("frame", t10, v49, v43, v44)), p9.component.instance)
end

return {
    default = function() -- WeatherTimerDisplayManager | line: 374
        -- upvalues: react (copy), useFlameworkComponents (copy), WeatherTimerSurfaceGui (copy)
        local v50 = useFlameworkComponents(function() -- line: 375
            return true
        end, "client/components/weather-timer-display-component@WeatherTimerDisplayComponent")
        local v51 = table.create(#v50)

        local function v52(p10) -- line: 380
            -- upvalues: react (copy), WeatherTimerSurfaceGui (copy)
            return react.createElement(WeatherTimerSurfaceGui, {
                component = p10,
                key = tostring(p10.instance)
            })
        end

        for v53, v54 in v50 do
            local _ = v53 - 1

            v51[v53] = react.createElement(WeatherTimerSurfaceGui, {
                component = v54,
                key = tostring(v54.instance)
            })
        end

        return react.createElement(react.Fragment, nil, v51)
    end
}

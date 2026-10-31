-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useBindingListener = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useBindingListener
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectCurrentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather.selectors").selectCurrentWeathers
local weathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "weathers").weathers
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Lighting, Workspace = services.HttpService, services.Lighting, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerDanceFloorAuraExpiresAt, selectPlayerDanceFloorAuraTicketMultiplierExpiresAt, selectPlayerEquippedTitle, selectPlayerPreLogoutBuff = selectors.selectPlayerDanceFloorAuraExpiresAt, selectors.selectPlayerDanceFloorAuraTicketMultiplierExpiresAt, selectors.selectPlayerEquippedTitle, selectors.selectPlayerPreLogoutBuff
local fomoOrbitTicketMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-event-shop-config").fomoOrbitTicketMultiplier
local topbarCenterY = RuntimeLib.import(script, script.Parent, "topbar-fishing").topbarCenterY
local default4 = RuntimeLib.import(script, script.Parent, "effect-hud").default
local selectActiveSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event.selectors").selectActiveSpecialEvents
local specialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "special-events").specialEvents
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "server-luck.selectors")
local selectServerLuckInfo, selectServerLuckMultiplier = v1.selectServerLuckInfo, v1.selectServerLuckMultiplier
local selectShardChanceBuffInfo = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "shard-chance-buff.selectors").selectShardChanceBuffInfo
local shardChanceBuffMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "shard-chance-buff-utils").shardChanceBuffMultiplier
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "double-rewards-event-utils")
local debugDoubleRewardsEventEndTimestampAttribute, doubleRewardsEventEndTimestamp, isDoubleRewardsEventActive = v2.debugDoubleRewardsEventEndTimestampAttribute, v2.doubleRewardsEventEndTimestamp, v2.isDoubleRewardsEventActive

local function getSafeServerTimeNow() -- line: 41
    -- upvalues: Workspace (copy)
    local function v3() -- line: 42
        -- upvalues: Workspace (copy)
        return Workspace:GetServerTimeNow()
    end

    local ok, result = pcall(v3)

    if ok then
        return result
    end

    return (os.time())
end

local function getDebugDoubleRewardsEventEndTimestamp() -- line: 47
    -- upvalues: Workspace (copy), debugDoubleRewardsEventEndTimestampAttribute (copy)
    local Attribute = Workspace:GetAttribute(debugDoubleRewardsEventEndTimestampAttribute)

    return if type(Attribute) == "number" then Attribute else nil
end

local function WeatherIndicator(p1) -- line: 51
    -- upvalues: react (copy), useEffect (copy), useState (copy), weathers (copy), default (copy), default2 (copy), default3 (copy), HttpService (copy), Lighting (copy), Workspace (copy), clientProducer (copy)
    local weatherState, layoutOrder = p1.weatherState, p1.layoutOrder
    local secondsLeft = default(weatherState.endTimestamp).secondsLeft
    local v4, v5 = useState(false)
    local v6 = weathers[weatherState.weather]
    local v7 = if v6 == nil then v6 else v6.weatherIcon

    if v7 == nil then
        v7 = ""
    end

    local v8 = if v6 == nil then v6 else v6.description

    if v8 == nil then
        v8 = ""
    end

    useEffect(function() -- line: 80
        -- upvalues: v6 (copy), Lighting (copy), Workspace (copy)
        local v9 = v6

        if v6 ~= nil then
            v9 = v6.skybox
        end

        if not v9 then
            return nil
        end

        local clone = v6.skybox:Clone()

        if clone then
            clone.Parent = Lighting
        end

        local clone2

        if v6.vfxModel then
            local clone = v6.vfxModel:Clone()

            clone2 = clone

            if clone then
                clone.Parent = Workspace
            end
        end

        local lightingOverride = v6.lightingOverride
        local t1

        if lightingOverride then
            t1 = {
                ambient = Lighting.Ambient,
                brightness = Lighting.Brightness,
                colorShiftBottom = Lighting.ColorShift_Bottom,
                colorShiftTop = Lighting.ColorShift_Top,
                fogColor = Lighting.FogColor,
                fogEnd = Lighting.FogEnd,
                fogStart = Lighting.FogStart,
                outdoorAmbient = Lighting.OutdoorAmbient
            }
            Lighting.Ambient = lightingOverride.ambient
            Lighting.Brightness = lightingOverride.brightness
            Lighting.ColorShift_Bottom = lightingOverride.colorShiftBottom
            Lighting.ColorShift_Top = lightingOverride.colorShiftTop
            Lighting.FogColor = lightingOverride.fogColor
            Lighting.FogEnd = lightingOverride.fogEnd
            Lighting.FogStart = lightingOverride.fogStart
            Lighting.OutdoorAmbient = lightingOverride.outdoorAmbient
        end

        local v10

        if lightingOverride and (lightingOverride.atmosphereColor ~= nil or lightingOverride.atmosphereDensity ~= nil or lightingOverride.atmosphereOffset ~= nil) then
            local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            local Atmosphere2

            if Atmosphere then
                Atmosphere2 = Atmosphere
            else
                Atmosphere2 = Instance.new("Atmosphere")
                Atmosphere2.Parent = Lighting
            end

            local Color, Density, Offset = Atmosphere2.Color, Atmosphere2.Density, Atmosphere2.Offset

            if lightingOverride.atmosphereColor ~= nil then
                Atmosphere2.Color = lightingOverride.atmosphereColor
            end

            if lightingOverride.atmosphereDensity ~= nil then
                Atmosphere2.Density = lightingOverride.atmosphereDensity
            end

            if lightingOverride.atmosphereOffset ~= nil then
                Atmosphere2.Offset = lightingOverride.atmosphereOffset
            end

            v10 = function() -- line: 140
                -- upvalues: Atmosphere (copy), Color (copy), Density (copy), Offset (copy), Atmosphere2 (ref)
                if not Atmosphere then
                    Atmosphere2:Destroy()

                    return
                end

                Atmosphere2.Color = Color
                Atmosphere2.Density = Density
                Atmosphere2.Offset = Offset
            end
        end

        return function() -- line: 151
            -- upvalues: clone (copy), clone2 (ref), v10 (ref), t1 (ref), Lighting (copy)
            if clone ~= nil then
                clone:Destroy()
            end

            local clone3 = clone2

            if clone3 ~= nil then
                clone3:Destroy()
            end

            local v11 = v10

            if v11 ~= nil then
                v11()
            end

            if not t1 then
                return
            end

            Lighting.Ambient = t1.ambient
            Lighting.Brightness = t1.brightness
            Lighting.ColorShift_Bottom = t1.colorShiftBottom
            Lighting.ColorShift_Top = t1.colorShiftTop
            Lighting.FogColor = t1.fogColor
            Lighting.FogEnd = t1.fogEnd
            Lighting.FogStart = t1.fogStart
            Lighting.OutdoorAmbient = t1.outdoorAmbient
        end
    end, { v6 })
    useEffect(function() -- line: 177
        -- upvalues: v6 (copy), HttpService (copy), clientProducer (copy)
        if not v6 then
            return nil
        end

        clientProducer.onScreenFeedbackAdded({
            type = "success",
            id = HttpService:GenerateGUID(false),
            message = ("%* has begun!"):format(v6.title)
        })
    end, { v6 })
    useEffect(function() -- line: 188
        -- upvalues: v4 (copy), v5 (copy)
        if not v4 then
            return nil
        end

        local v12 = task.delay(2.5, function() -- line: 192
            -- upvalues: v5 (copy)
            v5(false)
        end)

        return function() -- line: 195
            -- upvalues: v12 (copy)
            task.cancel(v12)
        end
    end, { v4 })

    if not v6 then
        return nil
    end

    local v13 = secondsLeft:map(function(p2) -- line: 203
        if p2 >= 60 then
            local v15 = math.floor(p2 / 60)
            local v16 = p2 % 60

            if v16 > 0 then
                return (("%*m %*s"):format(v15, v16))
            end

            return (("%*m"):format(v15))
        end

        return (("%*s"):format(p2))
    end)

    local function v17() -- line: 214
        -- upvalues: v4 (copy), v5 (copy)
        if v4 then
            return nil
        end

        v5(true)
    end

    local t2 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5)
    }

    t2.LayoutOrder = if layoutOrder == nil then 0 else layoutOrder
    t2.Position = UDim2.fromScale(0.5, 0.5)
    t2.Size = UDim2.fromScale(1, 1)

    return react.createElement("frame", t2, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = v17
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = v7,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v13,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v4 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default3, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextWrapped = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        position = UDim2.fromScale(0.5, 0.5),
        text = v8
    })))
end

local function SpecialEventIndicator(p3) -- line: 298
    -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), default3 (copy), HttpService (copy), clientProducer (copy), specialEvents (copy)
    local kind, specialEventState, layoutOrder = p3.kind, p3.specialEventState, p3.layoutOrder
    local secondsLeft = default(specialEventState.endTimestamp).secondsLeft
    local v18, v19 = useState(false)
    local v20 = specialEvents[kind]

    useEffect(function() -- line: 308
        -- upvalues: v20 (copy), HttpService (copy), clientProducer (copy)
        if not v20 then
            return nil
        end

        local t3 = {
            id = HttpService:GenerateGUID(false)
        }
        local feedbackMessage = v20.feedbackMessage

        t3.message = if feedbackMessage == nil then ("%* has begun!"):format(v20.title) else feedbackMessage
        t3.type = "success"
        clientProducer.onScreenFeedbackAdded(t3)
    end, { v20 })
    useEffect(function() -- line: 324
        -- upvalues: v18 (copy), v19 (copy)
        if not v18 then
            return nil
        end

        local v21 = task.delay(2.5, function() -- line: 328
            -- upvalues: v19 (copy)
            return v19(false)
        end)

        return function() -- line: 331
            -- upvalues: v21 (copy)
            return task.cancel(v21)
        end
    end, { v18 })

    if not v20 then
        return nil
    end

    local v22 = secondsLeft:map(function(p4) -- line: 338
        if p4 >= 60 then
            local v24 = math.floor(p4 / 60)
            local v25 = p4 % 60

            if v25 > 0 then
                return (("%*m %*s"):format(v24, v25))
            end

            return (("%*m"):format(v24))
        end

        return (("%*s"):format(p4))
    end)
    local t4 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5)
    }

    t4.LayoutOrder = if layoutOrder == nil then 0 else layoutOrder
    t4.Position = UDim2.fromScale(0.5, 0.5)
    t4.Size = UDim2.fromScale(1, 1)

    return react.createElement("frame", t4, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = function() -- Activated | line: 365
                -- upvalues: v18 (copy), v19 (copy)
                if not v18 then
                    v19(true)
                end
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = v20.icon,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v22,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v18 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default3, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextWrapped = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        position = UDim2.fromScale(0.5, 0.5),
        text = v20.description
    })))
end

local function ServerLuckIndicator() -- line: 428
    -- upvalues: react (copy), useEffect (copy), useState (copy), useRootSelector (copy), default (copy), default2 (copy), images (copy), selectServerLuckInfo (copy)
    local v27 = useRootSelector(selectServerLuckInfo)
    local v28, v29 = useState(false)
    local v30 = default(v27.expiresAt).secondsLeft:map(function(p5) -- line: 433
        if p5 >= 3600 then
            local v32 = math.floor(p5 / 3600)
            local v34 = math.floor(p5 % 3600 / 60)

            if v34 > 0 then
                return (("%*h %*m"):format(v32, v34))
            end

            return (("%*h"):format(v32))
        end

        if p5 >= 60 then
            local v36 = math.floor(p5 / 60)
            local v37 = p5 % 60

            if v37 > 0 then
                return (("%*m %*s"):format(v36, v37))
            end

            return (("%*m"):format(v36))
        end

        return (("%*s"):format(p5))
    end)

    useEffect(function() -- line: 449
        -- upvalues: v28 (copy), v29 (copy)
        if not v28 then
            return nil
        end

        local v38 = task.delay(2.5, function() -- line: 453
            -- upvalues: v29 (copy)
            return v29(false)
        end)

        return function() -- line: 456
            -- upvalues: v38 (copy)
            return task.cancel(v38)
        end
    end, { v28 })

    if v27.multiplier <= 1 then
        return nil
    end

    local function v39() -- line: 463
        -- upvalues: v28 (copy), v29 (copy)
        if not v28 then
            v29(true)
        end
    end

    local v40 = ("%*x Server Luck"):format(v27.multiplier)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = v39
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.serverLuckCloverIcon,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v30,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v28 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default2, {
        overrideProps = {
            TextWrap = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        text = v40,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })))
end

local function ShardChanceBuffIndicator(p6) -- line: 538
    -- upvalues: react (copy), useEffect (copy), useState (copy), useRootSelector (copy), default (copy), default2 (copy), images (copy), selectShardChanceBuffInfo (copy), shardChanceBuffMultiplier (copy)
    local layoutOrder = p6.layoutOrder

    if layoutOrder == nil then
        layoutOrder = 0
    end

    local v41 = useRootSelector(selectShardChanceBuffInfo)
    local v42, v43 = useState(false)
    local v44 = default(v41.expiresAt)
    local secondsLeft, isCountdownOngoing = v44.secondsLeft, v44.isCountdownOngoing

    useEffect(function() -- line: 548
        -- upvalues: v42 (copy), v43 (copy)
        if not v42 then
            return nil
        end

        local v45 = task.delay(2.5, function() -- line: 552
            -- upvalues: v43 (copy)
            return v43(false)
        end)

        return function() -- line: 555
            -- upvalues: v45 (copy)
            return task.cancel(v45)
        end
    end, { v42 })

    if not isCountdownOngoing then
        return nil
    end

    local v46 = secondsLeft:map(function(p7) -- line: 562
        if p7 >= 3600 then
            local v48 = math.floor(p7 / 3600)
            local v50 = math.floor(p7 % 3600 / 60)

            if v50 > 0 then
                return (("%*h %*m"):format(v48, v50))
            end

            return (("%*h"):format(v48))
        end

        if p7 >= 60 then
            local v52 = math.floor(p7 / 60)
            local v53 = p7 % 60

            if v53 > 0 then
                return (("%*m %*s"):format(v52, v53))
            end

            return (("%*m"):format(v52))
        end

        return (("%*s"):format(p7))
    end)

    local function v54() -- line: 578
        -- upvalues: v42 (copy), v43 (copy)
        if not v42 then
            v43(true)
        end
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = v54
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.universalShard,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v46,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v42 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default2, {
        overrideProps = {
            TextWrap = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        text = ("x%* Shard Chance"):format(shardChanceBuffMultiplier),
        textColor3 = Color3.fromRGB(255, 255, 255)
    })))
end

local function DanceFloorAuraIndicator(p8) -- line: 652
    -- upvalues: react (copy), useEffect (copy), useState (copy), useRootSelector (copy), default (copy), default2 (copy), Workspace (copy), images (copy), localPlayerUserId (copy), selectPlayerDanceFloorAuraExpiresAt (copy), selectPlayerDanceFloorAuraTicketMultiplierExpiresAt (copy), fomoOrbitTicketMultiplier (copy)
    local layoutOrder = p8.layoutOrder

    if layoutOrder == nil then
        layoutOrder = 0
    end

    local v55 = useRootSelector(selectPlayerDanceFloorAuraExpiresAt(localPlayerUserId))
    local v56 = useRootSelector(selectPlayerDanceFloorAuraTicketMultiplierExpiresAt(localPlayerUserId))
    local v57 = default(v55)
    local secondsLeft, isCountdownOngoing = v57.secondsLeft, v57.isCountdownOngoing
    local v58, v59 = useState(false)

    local function v60() -- line: 42
        -- upvalues: Workspace (copy)
        return Workspace:GetServerTimeNow()
    end

    local ok, result = pcall(v60)

    if not ok then
        result = os.time()
    end

    local v61 = result < v56

    useEffect(function() -- line: 664
        -- upvalues: v58 (copy), v59 (copy)
        if not v58 then
            return nil
        end

        local v62 = task.delay(2.5, function() -- line: 668
            -- upvalues: v59 (copy)
            return v59(false)
        end)

        return function() -- line: 671
            -- upvalues: v62 (copy)
            return task.cancel(v62)
        end
    end, { v58 })

    if not isCountdownOngoing then
        return nil
    end

    local v63 = secondsLeft:map(function(p9) -- line: 678
        if p9 >= 60 then
            local v65 = math.floor(p9 / 60)
            local v66 = p9 % 60

            if v66 > 0 then
                return (("%*m %*s"):format(v65, v66))
            end

            return (("%*m"):format(v65))
        end

        return (("%*s"):format(p9))
    end)
    local createElement = react.createElement
    local t7 = {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }
    local v67 = react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    })
    local v68 = react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = if v61 then Color3.fromRGB(110, 75, 10) else Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = function() -- Activated | line: 701
                -- upvalues: v58 (copy), v59 (copy)
                if not v58 then
                    v59(true)
                end
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.danceFloorAuraIcon,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), v61 and react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.02),
            Size = UDim2.fromScale(0.82, 0.3)
        },
        text = ("x%* TICKETS"):format(fomoOrbitTicketMultiplier),
        textColor3 = Color3.fromRGB(255, 230, 80)
    }), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v63,
        textColor3 = Color3.fromRGB(255, 255, 255)
    }))

    if not v58 then
        return createElement("frame", t7, v67, v68, v58)
    end

    return createElement("frame", t7, v67, v68, (react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default2, {
        overrideProps = {
            TextWrap = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        text = if v61 then ("Disco Blaze (1 Hr): x%* FOMO Tickets"):format(fomoOrbitTicketMultiplier) else "Disco Blaze (10 Min): visual effect only — no ticket buff",
        textColor3 = Color3.fromRGB(255, 255, 255)
    }))))
end

local t12 = {
    "money",
    "mutationLuck",
    "power"
}

local function PreLogoutBuffIndicator(p10) -- line: 773
    -- upvalues: react (copy), useEffect (copy), useState (copy), useRootSelector (copy), default (copy), default2 (copy), images (copy), localPlayerUserId (copy), selectPlayerPreLogoutBuff (copy)
    local kind, layoutOrder = p10.kind, p10.layoutOrder

    if layoutOrder == nil then
        layoutOrder = 0
    end

    local v73 = useRootSelector(selectPlayerPreLogoutBuff(localPlayerUserId))

    if v73 ~= nil then
        v73 = v73[kind]
    end

    local v75 = default(if v73 == nil then v73 else v73.buffExpiresAt)
    local secondsLeft, isCountdownOngoing = v75.secondsLeft, v75.isCountdownOngoing
    local v76, v77 = useState(false)

    useEffect(function() -- line: 793
        -- upvalues: v76 (copy), v77 (copy)
        if not v76 then
            return nil
        end

        local v78 = task.delay(2.5, function() -- line: 797
            -- upvalues: v77 (copy)
            return v77(false)
        end)

        return function() -- line: 800
            -- upvalues: v78 (copy)
            return task.cancel(v78)
        end
    end, { v76 })

    local v79, v80

    if v73 ~= nil then
        if isCountdownOngoing then
            v79 = kind == "mutationLuck"
            v80 = false
        else
            v80 = true
        end
    else
        v80 = true
    end

    if v80 then
        return nil
    end

    local v81 = kind == "power"
    local v82, v83

    if v79 then
        v82 = images.serverLuckCloverIcon
        v83 = "x2 Mutation Luck"
    elseif v81 then
        v82 = images.strongArmIcon
        v83 = "x2 Power"
    else
        v82 = images.cash2stack
        v83 = "x2 Cash"
    end

    local v84 = secondsLeft:map(function(p11) -- line: 811
        if p11 >= 60 then
            local v86 = math.floor(p11 / 60)
            local v87 = p11 % 60

            if v87 > 0 then
                return (("%*m %*s"):format(v86, v87))
            end

            return (("%*m"):format(v86))
        end

        return (("%*s"):format(p11))
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = function() -- Activated | line: 834
                -- upvalues: v76 (copy), v77 (copy)
                if not v76 then
                    v77(true)
                end
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = v82,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "x2",
        TextScaled = true,
        ZIndex = 4,
        AnchorPoint = Vector2.new(1, 1),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.98, 0.86),
        Size = UDim2.fromScale(0.62, 0.38),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0)
    }))), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v84,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v76 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.2
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default2, {
        overrideProps = {
            TextWrap = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        text = v83,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })))
end

local function DoubleRewardsEventIndicator(p12) -- line: 908
    -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), images (copy)
    local endTimestamp, layoutOrder = p12.endTimestamp, p12.layoutOrder

    if layoutOrder == nil then
        layoutOrder = 0
    end

    local secondsLeft = default(endTimestamp).secondsLeft
    local v89, v90 = useState(false)

    useEffect(function() -- line: 917
        -- upvalues: v89 (copy), v90 (copy)
        if not v89 then
            return nil
        end

        local v91 = task.delay(2.5, function() -- line: 921
            -- upvalues: v90 (copy)
            return v90(false)
        end)

        return function() -- line: 924
            -- upvalues: v91 (copy)
            return task.cancel(v91)
        end
    end, { v89 })

    local v92 = secondsLeft:map(function(p13) -- line: 928
        return (("%*m %*s"):format(math.floor(p13 / 60), p13 % 60))
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagebutton", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Event = {
            Activated = function() -- Activated | line: 945
                -- upvalues: v89 (copy), v90 (copy)
                if not v89 then
                    v90(true)
                end
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.cash2stack,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.9, 0.9)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.strongArmIcon,
        Position = UDim2.fromScale(0.25, 0.28),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.42, 0.42)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "x2",
        TextScaled = true,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 1),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.98, 0.86),
        Size = UDim2.fromScale(0.62, 0.38),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0)
    }))), react.createElement(default2, {
        overrideProps = {
            TextWrap = false,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.7),
            Size = UDim2.fromScale(1.05, 0.6)
        },
        text = v92,
        textColor3 = Color3.fromRGB(255, 255, 255)
    })), v89 and react.createElement("frame", {
        BackgroundTransparency = 0.3,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Position = UDim2.fromScale(0.5, 1.2),
        Size = UDim2.fromScale(1.35, 0.8)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.2,
        Color = Color3.fromRGB(0, 0, 0)
    }), react.createElement(default2, {
        text = "Double Cash & Power",
        overrideProps = {
            TextWrap = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.8)
        },
        textColor3 = Color3.fromRGB(255, 255, 255)
    })))
end

return {
    default = function(p14) -- WeatherIndicators | line: 1025
        -- upvalues: useBindingListener (copy), react (copy), useEffect (copy), useState (copy), useRootSelector (copy), selectCurrentWeathers (copy), default (copy), Workspace (copy), localPlayerUserId (copy), selectPlayerDanceFloorAuraExpiresAt (copy), selectPlayerEquippedTitle (copy), selectPlayerPreLogoutBuff (copy), topbarCenterY (copy), default4 (copy), selectActiveSpecialEvents (copy), selectServerLuckMultiplier (copy), selectShardChanceBuffInfo (copy), debugDoubleRewardsEventEndTimestampAttribute (copy), doubleRewardsEventEndTimestamp (copy), isDoubleRewardsEventActive (copy), getDebugDoubleRewardsEventEndTimestamp (copy), WeatherIndicator (copy), SpecialEventIndicator (copy), ServerLuckIndicator (copy), ShardChanceBuffIndicator (copy), DanceFloorAuraIndicator (copy), t12 (copy), PreLogoutBuffIndicator (copy), DoubleRewardsEventIndicator (copy)
        local visible = p14.visible

        if visible == nil then
            visible = true
        end

        local v95 = useRootSelector(selectCurrentWeathers)
        local v96 = useRootSelector(selectActiveSpecialEvents)
        local v97 = useRootSelector(selectPlayerPreLogoutBuff(localPlayerUserId))
        local v98 = useRootSelector(selectPlayerEquippedTitle(localPlayerUserId))
        local v99 = useRootSelector(selectPlayerDanceFloorAuraExpiresAt(localPlayerUserId))
        local v100 = useRootSelector(selectServerLuckMultiplier)
        local v101 = useRootSelector(selectShardChanceBuffInfo)

        local function v102() -- line: 42
            -- upvalues: Workspace (copy)
            return Workspace:GetServerTimeNow()
        end

        local ok, result = pcall(v102)

        if not ok then
            result = os.time()
        end

        local v103, v104 = useState(getDebugDoubleRewardsEventEndTimestamp)
        local v105 = if v103 == nil then 0 else v103
        local v106 = if result < v105 then v105 else doubleRewardsEventEndTimestamp
        local rawSecondsLeftInfo = default(v106).rawSecondsLeftInfo

        local function v107() -- line: 42
            -- upvalues: Workspace (copy)
            return Workspace:GetServerTimeNow()
        end

        local ok2, result2 = pcall(v107)

        if not ok2 then
            result2 = os.time()
        end

        local v108, v109 = useState(isDoubleRewardsEventActive(result2))

        useBindingListener(rawSecondsLeftInfo, function(p15) -- line: 1048
            -- upvalues: v103 (copy), v109 (copy), Workspace (copy), isDoubleRewardsEventActive (copy)
            local result = if p15 == nil then p15 else p15.timeNow

            if result == nil then
                local function v110() -- line: 42
                    -- upvalues: Workspace (copy)
                    return Workspace:GetServerTimeNow()
                end

                local ok

                ok, result = pcall(v110)

                if not ok then
                    result = os.time()
                end
            end

            local v111 = isDoubleRewardsEventActive(result)

            if not v111 then
                local v112 = v103

                if v103 == nil then
                    v112 = 0
                end

                local result = if p15 == nil then p15 else p15.timeNow

                if result == nil then
                    local function v113() -- line: 42
                        -- upvalues: Workspace (copy)
                        return Workspace:GetServerTimeNow()
                    end

                    local ok

                    ok, result = pcall(v113)

                    if not ok then
                        result = os.time()
                    end
                end

                v111 = result < v112
            end

            v109(v111)
        end)
        useEffect(function() -- line: 1075
            -- upvalues: v104 (copy), Workspace (copy), debugDoubleRewardsEventEndTimestampAttribute (copy)
            local connection = Workspace:GetAttributeChangedSignal(debugDoubleRewardsEventEndTimestampAttribute):Connect(function() -- line: 1076
                -- upvalues: v104 (copy), Workspace (copy), debugDoubleRewardsEventEndTimestampAttribute (copy)
                local Attribute = Workspace:GetAttribute(debugDoubleRewardsEventEndTimestampAttribute)

                if type(Attribute) ~= "number" then
                    Attribute = nil
                end

                return v104(Attribute)
            end)

            return function() -- line: 1079
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        local v114 = v100 > 1
        local n1 = 0

        for _ in v95 do
            n1 += 1
        end

        local v115 = n1 > 0
        local n2 = 0

        for _ in v96 do
            n2 += 1
        end

        local v116 = n2 > 0
        local t19 = {}
        local n3 = 0

        for v117, v118 in t12 do
            local _ = v117 - 1
            local v119

            if v97 ~= nil then
                v119 = v97[v118]

                if v119 ~= nil then
                    v119 = v119.buffExpiresAt
                end
            else
                v119 = v97
            end

            if v119 == nil then
                v119 = 0
            end

            if result < v119 == true then
                n3 += 1
                t19[n3] = v118
            end
        end

        local v120 = v98 == "icyFingers"
        local v121 = result < v99
        local v122 = #t19 > 0
        local v123 = result < v101.expiresAt
        local v124 = v108 or result < v105

        if not v114 and not v123 and not v115 and not v122 and not v120 and not v121 and not v124 and not v116 then
            return nil
        end

        local v125 = (if v120 then 1 else 0) + (if v121 then 1 else 0) + (if v123 then 1 else 0) + (if v124 then 1 else 0)
        local t20 = {}

        for v126, v127 in v95 do
            table.insert(t20, {
                v126,
                v127
            })
        end

        local t22 = {}

        for v128, v129 in v96 do
            table.insert(t22, {
                v128,
                v129
            })
        end

        local v130 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v131 = v114 and react.createElement(ServerLuckIndicator)
        local v132 = v120 and react.createElement(default4, {
            layoutOrder = v114 and 1 or 0
        })
        local v133 = v123 and react.createElement(ShardChanceBuffIndicator, {
            layoutOrder = (v114 and 1 or 0) + (v120 and 1 or 0)
        })
        local v134 = v121 and react.createElement(DanceFloorAuraIndicator, {
            layoutOrder = (v114 and 1 or 0) + (v120 and 1 or 0) + (v123 and 1 or 0)
        })

        v124 = v124 and react.createElement(DoubleRewardsEventIndicator, {
            endTimestamp = v106,
            layoutOrder = (v114 and 1 or 0) + (v120 and 1 or 0) + (v123 and 1 or 0) + (v121 and 1 or 0)
        })

        local v135 = table.create(#t19)

        for v136, v137 in t19 do
            local v138 = v136 - 1

            v135[v136] = react.createElement(PreLogoutBuffIndicator, {
                key = v137,
                kind = v137,
                layoutOrder = (v114 and 1 or 0) + v125 + v138
            })
        end

        local v139 = table.create(#t20)

        for v140, v141 in t20 do
            local v142 = v140 - 1
            local v143 = v141[1]
            local v144 = v141[2]

            v139[v140] = react.createElement(WeatherIndicator, {
                key = v143,
                layoutOrder = (v114 and 1 or 0) + v125 + #t19 + v142,
                weatherState = v144
            })
        end

        local v145 = table.create(#t22)

        local function v146(p16, p17) -- line: 1193
            -- upvalues: t19 (copy), v125 (copy), t20 (copy), v114 (copy), react (copy), SpecialEventIndicator (copy)
            local v147 = p16[1]
            local v148 = p16[2]

            return react.createElement(SpecialEventIndicator, {
                key = v147,
                kind = v147,
                layoutOrder = (v114 and 1 or 0) + v125 + #t19 + #t20 + p17,
                specialEventState = v148
            })
        end

        for v149, v150 in t22 do
            v145[v149] = v146(v150, v149 - 1, t22)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.87, topbarCenterY),
            Size = UDim2.fromScale(0.125, 0.07),
            Visible = visible
        }, v130, v131, v132, v133, v134, v124, v135, v139, v145)
    end
}

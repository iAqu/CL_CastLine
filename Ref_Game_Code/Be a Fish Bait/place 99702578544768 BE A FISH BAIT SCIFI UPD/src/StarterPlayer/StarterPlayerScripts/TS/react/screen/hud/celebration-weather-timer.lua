-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectActiveSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event.selectors").selectActiveSpecialEvents
local selectPinataBossScheduleOverride = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss-schedule-override.selectors").selectPinataBossScheduleOverride
local selectPinataBossState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossState
local selectTicketRainLocation = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "ticket-rain-location.selectors").selectTicketRainLocation
local getNextSpecialEventSlotStart = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "special-event-utils").getNextSpecialEventSlotStart
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, script.Parent, "topbar-fishing")
local topbarHeight, topbarOffscreenY, topbarRestY, topbarWidth = v1.topbarHeight, v1.topbarOffscreenY, v1.topbarRestY, v1.topbarWidth

local function formatMmSs(p1) -- line: 22
    local v3 = math.max(0, (math.floor(p1)))
    local v5 = math.floor(v3 / 60)
    local v6 = v3 % 60

    local function v7(p2) -- line: 26
        if p2 < 10 then
            return (("0%*"):format(p2))
        end

        return (tostring(p2))
    end

    return (("%*:%*"):format(if v5 < 10 then ("0%*"):format(v5) else tostring(v5), if v6 < 10 then ("0%*"):format(v6) else tostring(v6)))
end

local function getCountdownInfo(p3, p4, p5, p6) -- line: 33
    -- upvalues: Workspace (copy), getNextSpecialEventSlotStart (copy)
    local v8 = p4[p3]
    local v9 = p3 == "PinataBoss" and p6 and v8 ~= nil

    if v8 ~= nil and not v9 then
        return {
            isActive = true,
            target = v8.endTimestamp
        }
    end

    return {
        isActive = false,
        target = getNextSpecialEventSlotStart(if v9 then v8.endTimestamp else Workspace:GetServerTimeNow(), p3, if p3 == "PinataBoss" then p5 else nil)
    }
end

local function useShakeRotation(p7, p8) -- line: 57
    -- upvalues: useEffect (copy), useMotion (copy)
    local v12 = p7
    local v13 = p8

    if p7 == nil then
        v12 = 8
    end

    if p8 == nil then
        v13 = 0.3
    end

    local v14, v15 = useMotion(0)

    useEffect(function() -- line: 65
        -- upvalues: v12 (ref), v13 (ref), v15 (copy)
        local v16 = false
        local v17

        v17 = function(p9) -- line: 68
            -- upvalues: v17 (ref), v16 (ref), v12 (ref), v13 (ref), v15 (copy)
            if v16 then
                return nil
            end

            v15:tween(if p9 then v12 else -v12, {
                time = v13,
                style = Enum.EasingStyle.Sine
            })
            task.delay(v13, function() -- line: 76
                -- upvalues: p9 (copy), v17 (ref)
                return v17(not p9)
            end)
        end

        v17(true)

        return function() -- line: 81
            -- upvalues: v16 (ref), v15 (copy)
            v16 = true
            v15:immediate(0)
        end
    end, { v15, v12, v13 })

    return v14
end

local function SpecialEventCountdownLabel(p10) -- line: 88
    -- upvalues: react (copy), default (copy), default2 (copy), useRootSelector (copy), selectActiveSpecialEvents (copy), selectPinataBossScheduleOverride (copy), selectPinataBossState (copy), selectTicketRainLocation (copy), formatMmSs (copy), getCountdownInfo (copy), useShakeRotation (copy)
    local heightScale, icon, kind, label = p10.heightScale, p10.icon, p10.kind, p10.label
    local layoutOrder = p10.layoutOrder
    local v19 = useShakeRotation()
    local v20 = useRootSelector(selectActiveSpecialEvents)
    local v21 = useRootSelector(selectPinataBossScheduleOverride)
    local v22 = not useRootSelector(selectPinataBossState).isActive
    local v23 = useRootSelector(selectTicketRainLocation)
    local v24 = getCountdownInfo(kind, v20, v21, v22)
    local isActive = v24.isActive
    local secondsLeft = default2(v24.target).secondsLeft

    if kind == "TicketRain" and v23 ~= nil then
        label = ("%* at %*"):format(label, v23)
    end

    local v25 = secondsLeft:map(function(p11) -- line: 108
        -- upvalues: label (ref), isActive (copy), formatMmSs (copy)
        if isActive then
            return (("%* NOW! (%*)"):format(label, (formatMmSs(p11))))
        end

        return (("%* in %*"):format(label, (formatMmSs(p11))))
    end)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, heightScale)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.9, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.03, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Height
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = icon,
        Position = UDim2.fromScale(0.5, 0.5),
        Rotation = v19,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1)
    })), react.createElement(default, {
        shadowYScale = 0.1,
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(0, 0.7)
        },
        position = UDim2.fromScale(0, 0.5),
        text = v25
    })))
end

local function Divider(p12) -- line: 158
    -- upvalues: react (copy)
    local layoutOrder = p12.layoutOrder

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        LayoutOrder = layoutOrder,
        Size = UDim2.new(0.9, 0, 0, 2)
    })
end

return {
    default = function(p13) -- CelebrationWeatherTimer | line: 169
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), useRootSelector (copy), selectActiveSpecialEvents (copy), selectPinataBossScheduleOverride (copy), selectPinataBossState (copy), images (copy), topbarHeight (copy), topbarOffscreenY (copy), topbarRestY (copy), topbarWidth (copy), getCountdownInfo (copy), SpecialEventCountdownLabel (copy), Divider (copy)
        local visible = p13.visible
        local v26 = visible

        if visible == nil then
            v26 = true
            visible = true
        end

        local v27 = useRootSelector(selectActiveSpecialEvents)
        local v28 = useRootSelector(selectPinataBossScheduleOverride)
        local v29 = not useRootSelector(selectPinataBossState).isActive
        local v31, v32 = useMotion(UDim2.fromScale(0.5, if visible then topbarOffscreenY else topbarRestY))

        useEffect(function() -- line: 178
            -- upvalues: v26 (ref), v32 (copy), topbarOffscreenY (copy), topbarRestY (copy)
            v32:tween(UDim2.fromScale(0.5, if v26 then topbarRestY else topbarOffscreenY), {
                time = 0.3,
                style = Enum.EasingStyle.Back,
                direction = if v26 then Enum.EasingDirection.Out else Enum.EasingDirection.In
            })
        end, { v26, v32 })

        local v34 = getCountdownInfo("PinataBoss", v27, v28, v29).target <= getCountdownInfo("TicketRain", v27, v28, v29).target

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = v31,
            Size = UDim2.fromScale(topbarWidth, topbarHeight)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        }), react.createElement(SpecialEventCountdownLabel, {
            kind = "PinataBoss",
            label = "Pinata Bash",
            heightScale = v34 and 1 or 0.8,
            icon = images.pinataBossIcon,
            layoutOrder = v34 and 1 or 3
        }), react.createElement(Divider, {
            layoutOrder = 2
        }), react.createElement(SpecialEventCountdownLabel, {
            kind = "TicketRain",
            label = "Ticket Rain",
            heightScale = v34 and 0.8 or 1,
            icon = images.ticketRainIcon,
            layoutOrder = v34 and 3 or 1
        }))
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local default2 = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-countdown").default
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local selectPinataBossHp = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossHp
local selectActiveSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event.selectors").selectActiveSpecialEvents
local selectPinataBossScheduleOverride = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss-schedule-override.selectors").selectPinataBossScheduleOverride
local specialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "special-events").specialEvents
local getSoonestUpcomingSpecialEvent = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "special-event-utils").getSoonestUpcomingSpecialEvent
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 255, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 10))
})

local function formatMmSs(p1) -- line: 22
    local v4 = math.max(0, (math.floor(p1)))
    local v6 = math.floor(v4 / 60)
    local v7 = v4 % 60

    local function v8(p2) -- line: 26
        if p2 < 10 then
            return (("0%*"):format(p2))
        end

        return (tostring(p2))
    end

    return (("%*:%*"):format(if v6 < 10 then ("0%*"):format(v6) else tostring(v6), if v7 < 10 then ("0%*"):format(v7) else tostring(v7)))
end

local function useUpcomingSpecialEvent() -- line: 33
    -- upvalues: useEffect (copy), useState (copy), RunService (copy), Workspace (copy), useRootSelector (copy), selectPinataBossScheduleOverride (copy), getSoonestUpcomingSpecialEvent (copy)
    local v9 = useRootSelector(selectPinataBossScheduleOverride)
    local v10, v11 = useState(function() -- line: 35
        -- upvalues: v9 (copy), Workspace (copy), getSoonestUpcomingSpecialEvent (copy)
        return getSoonestUpcomingSpecialEvent(Workspace:GetServerTimeNow(), v9)
    end)

    useEffect(function() -- line: 38
        -- upvalues: v9 (copy), v11 (copy), RunService (copy), Workspace (copy), getSoonestUpcomingSpecialEvent (copy)
        local n1 = 0
        local connection = RunService.Heartbeat:Connect(function(p3) -- line: 40
            -- upvalues: n1 (ref), v9 (copy), v11 (copy), Workspace (copy), getSoonestUpcomingSpecialEvent (copy)
            n1 += p3

            if n1 < 1 then
                return nil
            end

            n1 = 0
            v11(getSoonestUpcomingSpecialEvent(Workspace:GetServerTimeNow(), v9))
        end)

        return function() -- line: 48
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { v9 })

    return v10
end

local function SpecialEventBillboard(p4) -- line: 54
    -- upvalues: react (copy), createPortal (copy), default (copy), useRootSelector (copy), default2 (copy), selectPinataBossHp (copy), selectActiveSpecialEvents (copy), specialEvents (copy), v1 (copy), v2 (copy), formatMmSs (copy), useUpcomingSpecialEvent (copy)
    local isActive = useRootSelector(selectPinataBossHp).isActive
    local v12 = useRootSelector(selectActiveSpecialEvents)
    local v13 = useUpcomingSpecialEvent()
    local v14

    for v15 in v12 do
        if v15 ~= "PinataBoss" then
            v14 = v15
            break
        end
    end

    local v16 = v14 ~= nil
    local title = specialEvents[v14 or v13.kind].title
    local slotStart, v18

    if v16 then
        v18 = ("%*!!!"):format((string.upper(title)))
    else
        v18 = ("%* SOON"):format((string.upper(title)))
        slotStart = v13.slotStart
    end

    local secondsLeft = default2(slotStart).secondsLeft

    if isActive then
        return nil
    end

    return createPortal(react.createElement("billboardgui", {
        AlwaysOnTop = true,
        LightInfluence = 0,
        MaxDistance = 150,
        Adornee = p4.component.instance,
        Size = UDim2.fromOffset(300, 80),
        StudsOffsetWorldSpace = Vector3.new(0, p4.component.instance.Size.Y / 2 + 2, 0)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default, {
        shadowYScale = 0.07,
        color = v1,
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(1, 0.4),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        text = v18
    }), if v16 then react.createElement(default, {
        shadowYScale = 0.07,
        text = "LIVE NOW!",
        color = v2,
        overrideProps = {
            LayoutOrder = 2,
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(1, 0.55),
            TextXAlignment = Enum.TextXAlignment.Center
        }
    }) else react.createElement(default, {
        shadowYScale = 0.07,
        color = v1,
        overrideProps = {
            LayoutOrder = 2,
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(1, 0.55),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        text = secondsLeft:map(function(p5) -- line: 130
            -- upvalues: formatMmSs (copy)
            return (formatMmSs(p5))
        end)
    }))), p4.component.instance)
end

return {
    default = function() -- SpecialEventBillboardManager | line: 135
        -- upvalues: react (copy), useFlameworkComponents (copy), SpecialEventBillboard (copy)
        local v23 = useFlameworkComponents(function() -- line: 136
            return true
        end, "client/components/special-event-timer-billboard-component@SpecialEventTimerBillboardComponent")
        local v24 = table.create(#v23)

        local function v25(p6) -- line: 141
            -- upvalues: react (copy), SpecialEventBillboard (copy)
            return react.createElement(SpecialEventBillboard, {
                component = p6,
                key = tostring(p6.instance)
            })
        end

        for v26, v27 in v23 do
            local _ = v26 - 1

            v24[v26] = react.createElement(SpecialEventBillboard, {
                component = v27,
                key = tostring(v27.instance)
            })
        end

        return react.createElement(react.Fragment, nil, v24)
    end
}

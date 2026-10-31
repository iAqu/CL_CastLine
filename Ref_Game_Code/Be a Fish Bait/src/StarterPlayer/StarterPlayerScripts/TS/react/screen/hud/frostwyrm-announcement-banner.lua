-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService, Players, RunService = services.GuiService, services.Players, services.RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectFrostwyrmAnnouncement = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "frostwyrm-announcement.selectors").selectFrostwyrmAnnouncement
local selectPlayerIsFishing = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerIsFishing
local apexSkillCheckAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom").apexSkillCheckAtom
local secretFrostwyrmActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "secret-frostwyrm-active-atom").secretFrostwyrmActiveAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "faded-background").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "use-transition-motion").useTransitionMotion
local v1 = tostring(Players.LocalPlayer.UserId)
local t1 = {
    time = 0.3
}
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 115, 255)),
    ColorSequenceKeypoint.new(0.234888, Color3.fromRGB(64, 115, 255)),
    ColorSequenceKeypoint.new(0.500864, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.784111, Color3.fromRGB(64, 115, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 115, 255))
})
local t2 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 140, 0),
    Color3.fromRGB(242, 255, 0),
    Color3.fromRGB(47, 255, 0),
    Color3.fromRGB(0, 255, 247),
    Color3.fromRGB(17, 0, 255),
    Color3.fromRGB(170, 0, 255)
}

local function sampleFrostwyrmRainbow(p1) -- line: 39
    -- upvalues: t2 (copy)
    local v3 = p1 - math.floor(p1)
    local v4 = #t2
    local v5 = v3 * v4
    local v6 = math.floor(v5)
    local v7 = v5 - v6

    return t2[v6 % v4 + 1]:Lerp(t2[(v6 + 1) % v4 + 1], v7)
end

local function buildFrostwyrmRainbowGradient(p2) -- line: 52
    -- upvalues: sampleFrostwyrmRainbow (copy)
    local t3 = {}

    for i = 0, 15 do
        local v8 = i / 15

        table.insert(t3, (ColorSequenceKeypoint.new(v8, sampleFrostwyrmRainbow(p2 + v8))))
    end

    return ColorSequence.new(t3)
end

local t4 = {
    TextScaled = true,
    ZIndex = 93,
    AutomaticSize = Enum.AutomaticSize.X,
    Font = Enum.Font.Fondamento,
    Size = UDim2.fromScale(0, 1),
    TextXAlignment = Enum.TextXAlignment.Center
}

local function FrostwyrmAnnouncementDisplay(p3) -- line: 69
    -- upvalues: react (copy), useEffect (copy), useState (copy), GuiService (copy), RunService (copy), default (copy), default2 (copy), useTransitionMotion (copy), t1 (copy), v2 (copy), buildFrostwyrmRainbowGradient (copy), t4 (copy)
    local exclusiveIndex, playerName = p3.exclusiveIndex, p3.playerName
    local v10, v11 = useState(0)

    useEffect(function() -- line: 73
        -- upvalues: v11 (copy), RunService (copy)
        local v12 = tick()
        local connection = RunService.Heartbeat:Connect(function() -- line: 75
            -- upvalues: v12 (ref), v11 (copy)
            local v13 = tick()
            local v14 = v13 - v12

            v12 = v13
            v11(function(p4) -- line: 79
                -- upvalues: v14 (copy)
                return (p4 + v14 * 1) % 1
            end)
        end)

        return function() -- line: 83
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, {})

    local v15 = buildFrostwyrmRainbowGradient(v10)
    local v16 = useTransitionMotion({
        whenIn = 0,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v17 = useTransitionMotion({
        whenIn = 0.4,
        whenOut = 1
    }, {
        motionType = "tween",
        tweenOptions = t1
    })[1]
    local v18 = ("%* HAS THAWED THE MIGHTY"):format((string.upper(playerName)))
    local v19 = if exclusiveIndex == nil then "FROSTWYRM!" else ("FROSTWYRM! (#%*)"):format(exclusiveIndex)
    local t5 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0)
    }

    t5.Position = UDim2.fromScale(0.5, 0.1) + UDim2.fromOffset(0, GuiService:GetGuiInset().Y)
    t5.Size = UDim2.fromScale(0.6, 0.07)
    t5.ZIndex = 92

    local v20 = react.createElement(default2, {
        zIndex = 92,
        backgroundTransparency = v17,
        cornerRadius = UDim.new(0.35, 0)
    })
    local v21 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local t6 = {
        color = v2
    }
    local v22 = table.clone(t4)

    setmetatable(v22, nil)
    v22.LayoutOrder = 1
    t6.overrideProps = v22
    t6.strokeProps = {
        Color = Color3.fromRGB(0, 10, 60)
    }
    t6.text = v18
    t6.textTransparency = v16

    local v23 = react.createElement(default, t6)
    local t7 = {
        gradientRotation = 0,
        color = v15
    }
    local v24 = table.clone(t4)

    setmetatable(v24, nil)
    v24.LayoutOrder = 2
    t7.overrideProps = v24
    t7.strokeProps = {
        Color = Color3.fromRGB(0, 10, 60)
    }
    t7.text = v19
    t7.textTransparency = v16

    return react.createElement("frame", t5, v20, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 93,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.95, 0.85)
    }, v21, v23, react.createElement(default, t7)))
end

return {
    default = function() -- FrostwyrmAnnouncementBanner | line: 161
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), subscribe (copy), useRootSelector (copy), selectFrostwyrmAnnouncement (copy), selectPlayerIsFishing (copy), apexSkillCheckAtom (copy), secretFrostwyrmActiveAtom (copy), default3 (copy), v1 (copy), FrostwyrmAnnouncementDisplay (copy)
        local v25 = useRootSelector(selectFrostwyrmAnnouncement)
        local v26 = useRootSelector(selectPlayerIsFishing(v1))
        local v27, v28 = useState(function() -- line: 164
            -- upvalues: apexSkillCheckAtom (copy), secretFrostwyrmActiveAtom (copy)
            if apexSkillCheckAtom() == nil then
                return (secretFrostwyrmActiveAtom())
            end

            return true
        end)
        local v29, v30 = useState(nil)
        local v31, v32 = useState(false)
        local v33 = v26 or v27
        local v34 = useRef(nil)

        useEffect(function() -- line: 171
            -- upvalues: v28 (copy), subscribe (copy), apexSkillCheckAtom (copy), secretFrostwyrmActiveAtom (copy)
            local v35 = subscribe(apexSkillCheckAtom, function(p5) -- line: 172
                -- upvalues: v28 (copy), secretFrostwyrmActiveAtom (copy)
                return v28(p5 ~= nil or secretFrostwyrmActiveAtom())
            end)
            local v37 = subscribe(secretFrostwyrmActiveAtom, function(p6) -- line: 175
                -- upvalues: v28 (copy), apexSkillCheckAtom (copy)
                return v28(p6 or apexSkillCheckAtom() ~= nil)
            end)

            return function() -- line: 178
                -- upvalues: v35 (copy), v37 (copy)
                v35()
                v37()
            end
        end, {})
        useEffect(function() -- line: 183
            -- upvalues: v25 (copy), v30 (copy), v32 (copy), v33 (copy), v34 (copy)
            if v25 == nil or v25.id == v34.current then
                return nil
            end

            v34.current = v25.id

            if v33 then
                return nil
            end

            v30(v25)
            v32(true)

            local v38 = task.delay(3, function() -- line: 193
                -- upvalues: v32 (copy)
                v32(false)
            end)

            return function() -- line: 196
                -- upvalues: v38 (copy)
                return task.cancel(v38)
            end
        end, { v25, v33 })
        useEffect(function() -- line: 200
            -- upvalues: v31 (copy), v32 (copy), v33 (copy)
            if v31 and v33 then
                v32(false)
            end
        end, { v31, v33 })

        if v29 == nil then
            return nil
        end

        return react.createElement(default3, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = v31
        }, react.createElement(FrostwyrmAnnouncementDisplay, {
            exclusiveIndex = v29.exclusiveIndex,
            playerName = v29.playerName
        }))
    end
}

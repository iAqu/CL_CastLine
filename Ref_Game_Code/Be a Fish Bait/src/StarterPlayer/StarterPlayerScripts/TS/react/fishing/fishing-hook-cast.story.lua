-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, subscribe = charm.atom, charm.subscribe
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local castDistanceFromPower, castDuration, castEndYFromPower, castLaunchSpeedFromPower = v1.castDistanceFromPower, v1.castDuration, v1.castEndYFromPower, v1.castLaunchSpeedFromPower
local bounceDistA, bounceDistB, bounceInitialDistanceFromSpeed, defaultBounceDiminishFactor = v1.bounceDistA, v1.bounceDistB, v1.bounceInitialDistanceFromSpeed, v1.defaultBounceDiminishFactor
local defaultBounceInitialHeight, defaultBounceGravity, defaultCameraBack, defaultCameraUp = v1.defaultBounceInitialHeight, v1.defaultBounceGravity, v1.defaultCameraBack, v1.defaultCameraUp
local defaultPeakBias, drag, peakHeightA, peakHeightB = v1.defaultPeakBias, v1.drag, v1.peakHeightA, v1.peakHeightB
local peakHeightFromSpeed = v1.peakHeightFromSpeed
local storyForWorkspaceWithScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForWorkspaceWithScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local currentFishingZoneAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom").currentFishingZoneAtom
local FishingHookCast = RuntimeLib.import(script, script.Parent, "fishing-hook-cast").FishingHookCast
local t1 = {
    "common",
    "uncommon",
    "rare",
    "epic",
    "legendary",
    "mythic"
}
local v2 = atom({
    castIndex = 0,
    power = 1,
    startY = 108.99600219726563,
    bounceDistA = bounceDistA,
    bounceDistB = bounceDistB,
    bounceGravity = defaultBounceGravity,
    bounceDiminishFactor = defaultBounceDiminishFactor,
    bounceInitialHeight = defaultBounceInitialHeight,
    drag = drag,
    peakBias = defaultPeakBias,
    peakHeightA = peakHeightA,
    peakHeightB = peakHeightB
})

local function updateCastState(p1) -- line: 50
    -- upvalues: v2 (copy)
    v2(function(p2) -- line: 51
        -- upvalues: p1 (copy)
        local v3 = table.clone(p2)

        setmetatable(v3, nil)

        for v4, v5 in p1 do
            v3[v4] = v5
        end

        return v3
    end)
end

local function useCastState() -- line: 60
    -- upvalues: useEffect (copy), useState (copy), subscribe (copy), v2 (copy)
    local v6, v7 = useState(v2)

    useEffect(function() -- line: 62
        -- upvalues: v7 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v7)
    end, {})

    return v6
end

local function SectionHeader(p3) -- line: 67
    -- upvalues: react (copy)
    local title = p3.title

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(45, 75, 110),
        Size = UDim2.new(1, 0, 0, 22)
    }, react.createElement("uipadding", {
        PaddingLeft = UDim.new(0, 8)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(160, 210, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }))
end

local function NumberControl(p4) -- line: 85
    -- upvalues: react (copy), useState (copy)
    local label, onChange, step, value = p4.label, p4.onChange, p4.step, p4.value
    local v8, v9 = useState((tostring(value)))

    local function commit(p5) -- line: 91
        -- upvalues: onChange (copy), value (copy), v9 (copy)
        local v10 = tonumber(p5)

        if v10 ~= nil then
            onChange(v10)
            v9((tostring(v10)))
        else
            v9((tostring(value)))
        end
    end

    return react.createElement("frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 36)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 82, 1, 0),
        Text = label,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "-",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 126
                -- upvalues: onChange (copy), step (copy), value (copy), v9 (copy)
                local v14 = value - step

                onChange(v14)
                v9((tostring(v14)))
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbox", {
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Change = {
            Text = function(p6) -- Text | line: 141
                -- upvalues: v9 (copy)
                return v9(p6.Text)
            end
        },
        Event = {
            FocusLost = function(p7) -- FocusLost | line: 146
                -- upvalues: commit (copy)
                return commit(p7.Text)
            end
        },
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -150, 1, 0),
        Text = v8,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "+",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 159
                -- upvalues: onChange (copy), step (copy), value (copy), v9 (copy)
                local v17 = value + step

                onChange(v17)
                v9((tostring(v17)))
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

local function Controls() -- line: 172
    -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), castDistanceFromPower (copy), castDuration (copy), castEndYFromPower (copy), castLaunchSpeedFromPower (copy), currentFishingZoneAtom (copy), t1 (copy), v2 (copy), SectionHeader (copy), NumberControl (copy)
    local v18, v19 = useState(v2)

    useEffect(function() -- line: 62
        -- upvalues: v19 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v19)
    end, {})

    local bounceDistA, bounceDistB, bounceGravity, bounceDiminishFactor = v18.bounceDistA, v18.bounceDistB, v18.bounceGravity, v18.bounceDiminishFactor
    local bounceInitialHeight, castIndex, drag, peakBias = v18.bounceInitialHeight, v18.castIndex, v18.drag, v18.peakBias
    local peakHeightA, peakHeightB, power, startY = v18.peakHeightA, v18.peakHeightB, v18.power, v18.startY
    local v20, v21 = useState(0)

    useEffect(function() -- line: 187
        -- upvalues: currentFishingZoneAtom (copy)
        return function() -- line: 188
            -- upvalues: currentFishingZoneAtom (copy)
            currentFishingZoneAtom(nil)
        end
    end, {})

    local function cycleZone(p8) -- line: 192
        -- upvalues: v20 (copy), v21 (copy), currentFishingZoneAtom (copy), t1 (copy)
        local v22 = (v20 + p8 + #t1) % #t1

        v21(v22)
        currentFishingZoneAtom(t1[v22 + 1])
    end

    local function v23(p9) -- line: 197
        -- upvalues: castIndex (copy), v21 (copy), currentFishingZoneAtom (copy), v2 (copy)
        v21(0)
        currentFishingZoneAtom("common")

        local v24 = table.clone(p9)

        setmetatable(v24, nil)
        v24.castIndex = castIndex + 1
        v2(function(p10) -- line: 51
            -- upvalues: v24 (copy)
            local v25 = table.clone(p10)

            setmetatable(v25, nil)

            for v26, v27 in v24 do
                v25[v26] = v27
            end

            return v25
        end)
    end

    local v28 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 3)
    })
    local v29 = react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Remount",
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(40, 110, 40),
        Event = {
            Activated = function() -- Activated | line: 213
                -- upvalues: v23 (copy)
                return v23({})
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 34),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    local v30 = react.createElement(SectionHeader, {
        title = "ZONE"
    })
    local v36 = react.createElement("frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(1, 0, 0, 36)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "zone",
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 82, 1, 0),
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "<",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 252
                -- upvalues: cycleZone (copy)
                return cycleZone(-1)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -150, 1, 0),
        Text = t1[v20 + 1],
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = ">",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 272
                -- upvalues: cycleZone (copy)
                return cycleZone(1)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
    local v37 = react.createElement(SectionHeader, {
        title = "CAST"
    })
    local v38 = react.createElement(NumberControl, {
        label = "power",
        step = 100,
        onChange = function(p11) -- onChange | line: 287
            -- upvalues: v23 (copy)
            return v23({
                power = p11
            })
        end,
        value = power
    })
    local v39 = react.createElement(NumberControl, {
        label = "drag",
        step = 0.1,
        onChange = function(p12) -- onChange | line: 297
            -- upvalues: v23 (copy)
            return v23({
                drag = p12
            })
        end,
        value = drag
    })
    local v40 = react.createElement(NumberControl, {
        label = "startY",
        step = 1,
        onChange = function(p13) -- onChange | line: 307
            -- upvalues: v23 (copy)
            return v23({
                startY = p13
            })
        end,
        value = startY
    })
    local v41 = react.createElement(NumberControl, {
        label = "peakBias",
        step = 0.05,
        onChange = function(p14) -- onChange | line: 317
            -- upvalues: v23 (copy)
            return v23({
                peakBias = p14
            })
        end,
        value = peakBias
    })
    local v42 = react.createElement(NumberControl, {
        label = "peakHeightA",
        step = 0.1,
        onChange = function(p15) -- onChange | line: 327
            -- upvalues: v23 (copy)
            return v23({
                peakHeightA = p15
            })
        end,
        value = peakHeightA
    })
    local v43 = react.createElement(NumberControl, {
        label = "peakHeightB",
        step = 0.01,
        onChange = function(p16) -- onChange | line: 337
            -- upvalues: v23 (copy)
            return v23({
                peakHeightB = p16
            })
        end,
        value = peakHeightB
    })
    local v44 = react.createElement(SectionHeader, {
        title = "BOUNCE"
    })
    local v45 = react.createElement(NumberControl, {
        label = "bounceInitialHeight",
        step = 1,
        onChange = function(p17) -- onChange | line: 350
            -- upvalues: v23 (copy)
            return v23({
                bounceInitialHeight = p17
            })
        end,
        value = bounceInitialHeight
    })
    local v46 = react.createElement(NumberControl, {
        label = "bounceDiminishFactor",
        step = 0.05,
        onChange = function(p18) -- onChange | line: 360
            -- upvalues: v23 (copy)
            return v23({
                bounceDiminishFactor = p18
            })
        end,
        value = bounceDiminishFactor
    })
    local v47 = react.createElement(NumberControl, {
        label = "bounceGravity",
        step = 5,
        onChange = function(p19) -- onChange | line: 370
            -- upvalues: v23 (copy)
            return v23({
                bounceGravity = p19
            })
        end,
        value = bounceGravity
    })
    local v48 = react.createElement(NumberControl, {
        label = "bounceDistA",
        step = 0.1,
        onChange = function(p20) -- onChange | line: 380
            -- upvalues: v23 (copy)
            return v23({
                bounceDistA = p20
            })
        end,
        value = bounceDistA
    })
    local v49 = react.createElement(NumberControl, {
        label = "bounceDistB",
        step = 0.05,
        onChange = function(p21) -- onChange | line: 390
            -- upvalues: v23 (copy)
            return v23({
                bounceDistB = p21
            })
        end,
        value = bounceDistB
    })
    local v50 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 2)
    })
    local v51 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6)
    })
    local t31 = {
        {
            "Speed",
            (("%* st/s"):format((math.round((castLaunchSpeedFromPower(power))))))
        },
        {
            "End Y",
            (("%* st"):format(math.round(castEndYFromPower(power) * 10) / 10))
        },
        {
            "Duration",
            (("%* s"):format(math.round(castDuration(power) * 100) / 100))
        },
        {
            "Distance",
            (("%* st"):format((math.round((castDistanceFromPower(power))))))
        }
    }
    local v56 = table.create(#t31)

    local function v57(p22) -- line: 410
        -- upvalues: react (copy)
        local v58 = p22[1]
        local v59 = p22[2]

        return react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            key = v58,
            Size = UDim2.new(1, 0, 0, 14),
            Text = ("%*: %*"):format(v58, v59),
            TextColor3 = Color3.fromRGB(180, 220, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    for v60, v61 in t31 do
        v56[v60] = v57(v61, v60 - 1, t31)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 12, 0, 12),
        Size = UDim2.new(0, 270, 0, 660)
    }, v28, v29, v30, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, react.createElement("frame", {
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Size = UDim2.new(1, 0, 0, 72)
    }, v50, v51, v56))
end

local function WorkspaceCast() -- line: 440
    -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), castLaunchSpeedFromPower (copy), bounceInitialDistanceFromSpeed (copy), defaultCameraBack (copy), defaultCameraUp (copy), peakHeightFromSpeed (copy), FishingHookCast (copy), v2 (copy)
    local v62, v63 = useState(v2)

    useEffect(function() -- line: 62
        -- upvalues: v63 (copy), subscribe (copy), v2 (copy)
        return subscribe(v2, v63)
    end, {})

    local bounceDistA, bounceDistB, bounceGravity, bounceDiminishFactor = v62.bounceDistA, v62.bounceDistB, v62.bounceGravity, v62.bounceDiminishFactor
    local bounceInitialHeight, castIndex, drag, peakBias = v62.bounceInitialHeight, v62.castIndex, v62.drag, v62.peakBias
    local peakHeightA, peakHeightB, power, startY = v62.peakHeightA, v62.peakHeightB, v62.power, v62.startY

    return react.createElement(FishingHookCast, {
        direction = Vector3.new(0, 0, 1),
        showHook = true,
        bounceDiminishFactor = bounceDiminishFactor,
        bounceGravity = bounceGravity,
        bounceInitialDistance = bounceInitialDistanceFromSpeed(castLaunchSpeedFromPower(power), bounceDistA, bounceDistB),
        bounceInitialHeight = bounceInitialHeight,
        cameraBackDistance = defaultCameraBack,
        cameraUpDistance = defaultCameraUp,
        drag = drag,
        key = tostring(castIndex),
        peakBias = peakBias,
        peakHeight = peakHeightFromSpeed(castLaunchSpeedFromPower(power), peakHeightA, peakHeightB),
        power = power,
        startPosition = Vector3.new(-798.4940185546875, startY, -784.3469848632813)
    })
end

return storyForWorkspaceWithScreenGui({
    screenGui = react.createElement(default, nil, react.createElement(Controls)),
    workspace = react.createElement(default, nil, react.createElement(WorkspaceCast))
})

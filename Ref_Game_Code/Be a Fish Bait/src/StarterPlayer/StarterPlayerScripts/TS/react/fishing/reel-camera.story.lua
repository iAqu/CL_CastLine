-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, subscribe = charm.atom, charm.subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, TweenService, Workspace = services.Players, services.TweenService, services.Workspace
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local waterSurfaceY, reelPhase1Speed, reelPhase1SpeedPerFishDim, computeReelCameraCutTime = v1.waterSurfaceY, v1.reelPhase1Speed, v1.reelPhase1SpeedPerFishDim, v1.computeReelCameraCutTime
local reelDropDuration, computeReelPhase1Studs, computeReelStartPos = v1.reelDropDuration, v1.computeReelPhase1Studs, v1.computeReelStartPos
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "reel-camera")
local defaultReelCameraConfig, playReelCamera = v2.defaultReelCameraConfig, v2.playReelCamera
local v3 = atom({
    animKey = 0,
    fishIndex = 0,
    fishSize = 0,
    peakHeight = 20,
    hookDepth = 15,
    hookDistance = 80,
    skipToLanding = false,
    config = defaultReelCameraConfig
})

local function useStoryState() -- line: 46
    -- upvalues: useEffect (copy), useState (copy), subscribe (copy), v3 (copy)
    local v4, v5 = useState(v3)

    useEffect(function() -- line: 48
        -- upvalues: v5 (copy), subscribe (copy), v3 (copy)
        return subscribe(v3, v5)
    end, {})

    return v4
end

local function patch(p1) -- line: 53
    -- upvalues: v3 (copy)
    v3(function(p2) -- line: 54
        -- upvalues: p1 (copy)
        local v6 = table.clone(p2)

        setmetatable(v6, nil)

        for v7, v8 in p1 do
            v6[v7] = v8
        end

        return v6
    end)
end

local function SectionHeader(p3) -- line: 64
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

local function NumberControl(p4) -- line: 82
    -- upvalues: react (copy), useState (copy)
    local label, value, step, onChange = p4.label, p4.value, p4.step, p4.onChange
    local v9, v10 = useState((tostring(value)))

    local function commit(p5) -- line: 88
        -- upvalues: value (copy), onChange (copy), v10 (copy)
        local v11 = tonumber(p5)

        if v11 ~= nil then
            onChange(v11)
            v10((tostring(v11)))
        else
            v10((tostring(value)))
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
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 90, 1, 0),
        Text = label,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "-",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 123
                -- upvalues: value (copy), step (copy), onChange (copy), v10 (copy)
                local v15 = value - step

                onChange(v15)
                v10((tostring(v15)))
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
            Text = function(p6) -- Text | line: 138
                -- upvalues: v10 (copy)
                return v10(p6.Text)
            end
        },
        Event = {
            FocusLost = function(p7) -- FocusLost | line: 143
                -- upvalues: commit (copy)
                return commit(p7.Text)
            end
        },
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -150, 1, 0),
        Text = v9,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "+",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 156
                -- upvalues: value (copy), step (copy), onChange (copy), v10 (copy)
                local v18 = value + step

                onChange(v18)
                v10((tostring(v18)))
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

local function ReelAnimation(p8) -- line: 170
    -- upvalues: react (copy), useEffect (copy), Players (copy), TweenService (copy), Workspace (copy), waterSurfaceY (copy), reelPhase1Speed (copy), reelPhase1SpeedPerFishDim (copy), computeReelCameraCutTime (copy), reelDropDuration (copy), computeReelPhase1Studs (copy), computeReelStartPos (copy), playReelCamera (copy), v3 (copy)
    local fishData, peakHeight, hookDepth, hookDistance = p8.fishData, p8.peakHeight, p8.hookDepth, p8.hookDistance
    local skipToLanding, config = p8.skipToLanding, p8.config

    useEffect(function() -- line: 177
        -- upvalues: fishData (copy), peakHeight (copy), hookDepth (copy), hookDistance (copy), skipToLanding (copy), config (copy), Players (copy), TweenService (copy), Workspace (copy), waterSurfaceY (copy), reelPhase1Speed (copy), reelPhase1SpeedPerFishDim (copy), computeReelCameraCutTime (copy), reelDropDuration (copy), computeReelPhase1Studs (copy), computeReelStartPos (copy), playReelCamera (copy), v3 (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer

        if not CurrentCamera then
            return nil
        end

        local model = fishData.model

        if model == nil then
            return nil
        end

        local clone = model:Clone()

        clone.Parent = Workspace

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
            end
        end

        local v21 = Vector3.new(0, waterSurfaceY - hookDepth, 0 + hookDistance)
        local _, BoundingBox = clone:GetBoundingBox()
        local v22 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)
        local v23 = BoundingBox.Y / 2
        local t9 = {
            fishSize = math.round(v22 * 10) / 10
        }

        v3(function(p9) -- line: 54
            -- upvalues: t9 (copy)
            local v25 = table.clone(p9)

            setmetatable(v25, nil)

            for v26, v27 in t9 do
                v25[v26] = v27
            end

            return v25
        end)

        local v28 = Vector3.new(0, 0, 0) + (Vector3.new(0, 0, 1)).Unit * 8
        local v30 = Vector3.new(v28.X, 99 + v23, v28.Z)
        local v31 = Vector3.new(v28.X, 111, v28.Z)
        local v32 = computeReelStartPos(v21, Vector3.new(0, 0, 1), v22)
        local v33 = computeReelPhase1Studs(v22)
        local v34 = v33 / (reelPhase1Speed + v22 * reelPhase1SpeedPerFishDim)
        local v37 = Vector3.new(0 - v21.X, 0, 0 - v21.Z)
        local v39 = v32 + (if v37.Magnitude > 0.01 then Vector3.new(v37.X, v37.Magnitude, v37.Z).Unit else Vector3.new(0, 1, 0)) * v33
        local elapsed = os.clock()
        local v40 = false
        local v41, v42, v43

        local function v44() -- line: 224
            -- upvalues: clone (copy), v30 (copy), v31 (copy), elapsed (copy), v40 (ref), v42 (ref), TweenService (copy), Workspace (copy), reelDropDuration (copy)
            clone:PivotTo(CFrame.new(v31))

            local Vector3Value = Instance.new("Vector3Value")

            Vector3Value.Value = v31
            Vector3Value.Parent = Workspace

            local connection = Vector3Value:GetPropertyChangedSignal("Value"):Connect(function() -- line: 229
                -- upvalues: Vector3Value (copy), clone (copy), v40 (ref)
                if not v40 then
                    clone:PivotTo(CFrame.new(Vector3Value.Value))
                end
            end)

            v42 = TweenService:Create(Vector3Value, TweenInfo.new(reelDropDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Value = v30
            })
            v42.Completed:Connect(function() -- line: 237
                -- upvalues: Vector3Value (copy), connection (copy), elapsed (copy), v40 (ref)
                connection:Disconnect()
                Vector3Value:Destroy()

                if v40 then
                    return
                end

                print((`[story] fish landed at +{ math.round((os.clock() - elapsed) * 100) / 100 }s`))
            end)
            v42:Play()
        end

        local v46

        if skipToLanding then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local v48 = Vector3.new(0, 102, 0) + (Vector3.new(-0, 0, -1)).Unit * config.landingCamBackOffset + Vector3.new(0, config.landingCamHeight, 0)
            local v49 = Vector3.new(0, 102, 0) + (Vector3.new(0, 0, 1)).Unit * 8

            CurrentCamera.CFrame = CFrame.lookAt(v48, v49)

            v46 = function() -- line: 258
                -- upvalues: CurrentCamera (copy), LocalPlayer (copy)
                local Character = LocalPlayer.Character

                if Character ~= nil then
                    Character = Character:FindFirstChildOfClass("Humanoid")
                end

                if Character then
                    CurrentCamera.CameraSubject = Character
                end

                CurrentCamera.CameraType = Enum.CameraType.Custom
            end

            v44()
        else
            local v50 = computeReelCameraCutTime(v34)

            print((("[story] cutAt=%*s  drop=%*  total=%*s"):format(math.round(v50 * 100) / 100, reelDropDuration, math.round((v50 + reelDropDuration) * 100) / 100)))
            clone:PivotTo(CFrame.new(v32))

            local Vector3Value = Instance.new("Vector3Value")

            Vector3Value.Value = v32
            Vector3Value.Parent = clone

            local connection = Vector3Value:GetPropertyChangedSignal("Value"):Connect(function() -- line: 277
                -- upvalues: clone (copy), Vector3Value (copy)
                clone:PivotTo(CFrame.new(Vector3Value.Value))
            end)

            v41 = TweenService:Create(Vector3Value, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Value = v39
            })
            v43 = task.delay(v50, function() -- line: 283
                -- upvalues: v40 (ref), v41 (ref), v44 (copy), Vector3Value (copy), connection (copy)
                if v40 then
                    return nil
                end

                local v54 = v41

                if v54 ~= nil then
                    v54:Cancel()
                end

                connection:Disconnect()
                Vector3Value:Destroy()
                v44()
            end)
            v41:Play()
            v46 = playReelCamera(CurrentCamera, LocalPlayer, v21, Vector3.new(0, 102, 0), Vector3.new(0, 0, 1), peakHeight, v22, function() -- line: 296
            end, function() -- line: 296
            end, config)
        end

        return function() -- line: 298
            -- upvalues: clone (copy), v40 (ref), v41 (ref), v42 (ref), v43 (ref), v46 (ref)
            v40 = true
            v46()

            if v43 ~= nil then
                task.cancel(v43)
            end

            local v57 = v41

            if v57 ~= nil then
                v57:Cancel()
            end

            local v58 = v42

            if v58 ~= nil then
                v58:Cancel()
            end

            clone:Destroy()
        end
    end, {})

    return react.createElement(react.Fragment)
end

local function Controls() -- line: 318
    -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), allFishData (copy), v3 (copy), patch (copy), SectionHeader (copy), NumberControl (copy)
    local v59, v60 = useState(v3)

    useEffect(function() -- line: 48
        -- upvalues: v60 (copy), subscribe (copy), v3 (copy)
        return subscribe(v3, v60)
    end, {})

    local animKey, fishIndex, fishSize, peakHeight = v59.animKey, v59.fishIndex, v59.fishSize, v59.peakHeight
    local hookDepth, hookDistance, skipToLanding, config = v59.hookDepth, v59.hookDistance, v59.skipToLanding, v59.config
    local v61 = allFishData[fishIndex + 1]
    local v63 = math.clamp(fishSize / 40, 0.6, 1)
    local v65 = math.round(config.overheadCamSideOffset * v63 * 10) / 10
    local v67 = math.round(config.overheadCamCastOffset * v63 * 10) / 10
    local v69 = math.round(config.overheadCamLookCast * v63 * 10) / 10

    local function play(p10) -- line: 335
        -- upvalues: animKey (copy), v3 (copy)
        local t10 = {}

        if p10 then
            for v70, v71 in p10 do
                t10[v70] = v71
            end
        end

        t10.animKey = animKey + 1
        v3(function(p11) -- line: 54
            -- upvalues: t10 (copy)
            local v72 = table.clone(p11)

            setmetatable(v72, nil)

            for v73, v74 in t10 do
                v72[v73] = v74
            end

            return v72
        end)
    end

    local function cycleFish(p12) -- line: 345
        -- upvalues: animKey (copy), fishIndex (copy), allFishData (copy), v3 (copy)
        local t11 = {
            fishIndex = (fishIndex + p12 + #allFishData) % #allFishData
        }
        local t12 = {}

        if t11 then
            for v75, v76 in t11 do
                t12[v75] = v76
            end
        end

        t12.animKey = animKey + 1
        v3(function(p13) -- line: 54
            -- upvalues: t12 (copy)
            local v77 = table.clone(p13)

            setmetatable(v77, nil)

            for v78, v79 in t12 do
                v77[v78] = v79
            end

            return v77
        end)
    end

    local function setConfig(p14) -- line: 351
        -- upvalues: config (copy), v3 (copy)
        local t13 = {}
        local v80 = table.clone(config)

        setmetatable(v80, nil)

        for v81, v82 in p14 do
            v80[v81] = v82
        end

        t13.config = v80
        v3(function(p15) -- line: 54
            -- upvalues: t13 (copy)
            local v83 = table.clone(p15)

            setmetatable(v83, nil)

            for v84, v85 in t13 do
                v83[v84] = v85
            end

            return v83
        end)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 12, 0, 12),
        Size = UDim2.new(0, 270, 0, 720)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 3)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Play",
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(40, 110, 40),
        Event = {
            Activated = function() -- Activated | line: 374
                -- upvalues: play (copy)
                return play()
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 34),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = if skipToLanding then Color3.fromRGB(140, 60, 20) else Color3.fromRGB(50, 50, 50),
        Event = {
            Activated = function() -- Activated | line: 387
                -- upvalues: skipToLanding (copy), patch (copy)
                return patch({
                    skipToLanding = not skipToLanding
                })
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 26),
        Text = skipToLanding and "Skip: ON (pier only)" or "Skip: OFF (full arc)",
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement(SectionHeader, {
        title = "FISH"
    }), react.createElement("frame", {
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
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "<",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 418
                -- upvalues: cycleFish (copy)
                return cycleFish(-1)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -64, 1, 0),
        Text = ("%* (%*)"):format(v61.displayName, v61.rarity),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = ">",
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Event = {
            Activated = function() -- Activated | line: 438
                -- upvalues: cycleFish (copy)
                return cycleFish(1)
            end
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 28, 1, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })), react.createElement(SectionHeader, {
        title = "ARC"
    }), react.createElement(NumberControl, {
        label = "hookDistance",
        step = 5,
        value = hookDistance,
        onChange = function(p16) -- onChange | line: 453
            -- upvalues: patch (copy)
            return patch({
                hookDistance = p16
            })
        end
    }), react.createElement(NumberControl, {
        label = "hookDepth",
        step = 1,
        value = hookDepth,
        onChange = function(p17) -- onChange | line: 462
            -- upvalues: patch (copy)
            return patch({
                hookDepth = p17
            })
        end
    }), react.createElement(NumberControl, {
        label = "peakHeight",
        step = 5,
        value = peakHeight,
        onChange = function(p18) -- onChange | line: 471
            -- upvalues: patch (copy)
            return patch({
                peakHeight = p18
            })
        end
    }), react.createElement(SectionHeader, {
        title = "CAMERA"
    }), react.createElement(NumberControl, {
        label = "overheadH",
        step = 1,
        value = config.overheadCamHeight,
        onChange = function(p19) -- onChange | line: 482
            -- upvalues: setConfig (copy)
            return setConfig({
                overheadCamHeight = p19
            })
        end
    }), react.createElement(NumberControl, {
        label = "overheadSide",
        step = 1,
        value = config.overheadCamSideOffset,
        onChange = function(p20) -- onChange | line: 491
            -- upvalues: setConfig (copy)
            return setConfig({
                overheadCamSideOffset = p20
            })
        end
    }), react.createElement(NumberControl, {
        label = "overheadCast",
        step = 1,
        value = config.overheadCamCastOffset,
        onChange = function(p21) -- onChange | line: 500
            -- upvalues: setConfig (copy)
            return setConfig({
                overheadCamCastOffset = p21
            })
        end
    }), react.createElement(NumberControl, {
        label = "overheadLookY",
        step = 1,
        value = config.overheadCamLookY,
        onChange = function(p22) -- onChange | line: 509
            -- upvalues: setConfig (copy)
            return setConfig({
                overheadCamLookY = p22
            })
        end
    }), react.createElement(NumberControl, {
        label = "overheadLookCast",
        step = 1,
        value = config.overheadCamLookCast,
        onChange = function(p23) -- onChange | line: 518
            -- upvalues: setConfig (copy)
            return setConfig({
                overheadCamLookCast = p23
            })
        end
    }), react.createElement(NumberControl, {
        label = "landCamH",
        step = 1,
        value = config.landingCamHeight,
        onChange = function(p24) -- onChange | line: 527
            -- upvalues: setConfig (copy)
            return setConfig({
                landingCamHeight = p24
            })
        end
    }), react.createElement(NumberControl, {
        label = "landCamBack",
        step = 1,
        value = config.landingCamBackOffset,
        onChange = function(p25) -- onChange | line: 536
            -- upvalues: setConfig (copy)
            return setConfig({
                landingCamBackOffset = p25
            })
        end
    }), react.createElement(NumberControl, {
        label = "diagCamH",
        step = 1,
        value = config.diagonalCamHeight,
        onChange = function(p26) -- onChange | line: 545
            -- upvalues: setConfig (copy)
            return setConfig({
                diagonalCamHeight = p26
            })
        end
    }), react.createElement(NumberControl, {
        label = "diagCamBack",
        step = 1,
        value = config.diagonalCamBackOffset,
        onChange = function(p27) -- onChange | line: 554
            -- upvalues: setConfig (copy)
            return setConfig({
                diagonalCamBackOffset = p27
            })
        end
    }), react.createElement(NumberControl, {
        label = "diagTween",
        step = 0.05,
        value = config.diagonalTweenDuration,
        onChange = function(p28) -- onChange | line: 563
            -- upvalues: setConfig (copy)
            return setConfig({
                diagonalTweenDuration = p28
            })
        end
    }), react.createElement(SectionHeader, {
        title = "EFFECTIVE"
    }), react.createElement("textlabel", {
        BackgroundTransparency = 0,
        TextSize = 11,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 18),
        Text = ("fishSize: %*  scale: %*%%"):format(fishSize, (math.round(v63 * 100))),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 0,
        TextSize = 11,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 18),
        Text = ("side: %*  cast: %*  lookCast: %*"):format(v65, v67, v69),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    }))
end

local function Story() -- line: 591
    -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), allFishData (copy), v3 (copy), ReelAnimation (copy), Controls (copy)
    local v112, v113 = useState(v3)

    useEffect(function() -- line: 48
        -- upvalues: v113 (copy), subscribe (copy), v3 (copy)
        return subscribe(v3, v113)
    end, {})

    local animKey, fishIndex, peakHeight, hookDepth = v112.animKey, v112.fishIndex, v112.peakHeight, v112.hookDepth
    local hookDistance, skipToLanding, config = v112.hookDistance, v112.skipToLanding, v112.config

    return react.createElement(react.Fragment, nil, react.createElement(Controls), react.createElement(ReelAnimation, {
        key = tostring(animKey),
        fishData = allFishData[fishIndex + 1],
        peakHeight = peakHeight,
        hookDepth = hookDepth,
        hookDistance = hookDistance,
        skipToLanding = skipToLanding,
        config = config
    }))
end

return storyForScreenGui(react.createElement(Story))

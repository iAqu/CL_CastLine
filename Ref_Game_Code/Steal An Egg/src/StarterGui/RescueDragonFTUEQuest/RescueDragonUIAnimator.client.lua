-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if ReplicatedStorage:WaitForChild("Data"):FindFirstChild("OnboardingQuestline") == nil then
    script.Parent.Enabled = false
else
    local _ = {
        OpenTime = 0.34,
        OpenScaleFrom = 0.66,
        OpenFadeTime = 0.22,
        CloseTime = 0.18,
        CloseScaleTo = 0.8,
        RowStagger = 0.075,
        RowTime = 0.36,
        RowDelay = 0.1,
        RowScaleFrom = 0.84,
        RowRotationFrom = -5,
        HoverScale = 1.07,
        PressScale = 0.93,
        HoverTime = 0.12,
        ClaimPulseScale = 1.05,
        ClaimPulseTime = 0.55,
        CheckmarkTime = 0.34,
        CheckmarkSpin = 25,
        ButtonSwapTime = 0.18,
        RowBarTime = 0.28,
        KeyBarTime = 0.35,
        KeyIconPunch = 1.22,
        KeyIconPunchTime = 0.18,
        KeyFlightTime = 0.75,
        KeyFlightArc = -0.3,
        KeyFlightSpin = 540,
        KeyFlightPop = 0.55,
        KeyFlightZIndex = 500,
        KeyHatchTime = 0.18,
        LockPunchScale = 1.3,
        LockPunchTime = 0.12,
        LockFadeOutTime = 0.28,
        LockFadeOutScale = 1.45,
        PostUnlockDelay = 0.15,
        DisableGuiWhenClosed = true,
        KeyIconFloat = true,
        KeyIconFloatAmount = 0.006,
        KeyIconFloatSpeed = 1.6,
        ViewportModelName = nil,
        ViewportFieldOfView = 40,
        ViewportFit = 1.25,
        ViewportYaw = 180,
        ViewportElevation = 6,
        ViewportHeightOffset = 0.1,
        ViewportSway = 7,
        ViewportSwaySpeed = 0.5,
        ViewportBob = 0.012,
        ViewportBobSpeed = 1.1,
        PlaceholderRows = 3
    }
    local Parent = script.Parent
    local FTUEQuestMain = Parent:WaitForChild("FTUEQuestMain")
    local Content = FTUEQuestMain:WaitForChild("Content")
    local QuestHolder = Content:WaitForChild("QuestHolder")
    local Template = QuestHolder:WaitForChild("Template")
    local KeyProgressHolder = Content:WaitForChild("KeyProgressHolder")
    local ProgressBar = KeyProgressHolder:WaitForChild("ProgressBar")
    local ProgressLabel = KeyProgressHolder:WaitForChild("ProgressLabel")
    local Icon = Content:WaitForChild("Icon")
    local Close = FTUEQuestMain:WaitForChild("Close")
    local ViewportFrame = FTUEQuestMain:FindFirstChild("ViewportFrame")
    local LockUnlocked = Parent:WaitForChild("Assets"):WaitForChild("LockUnlocked")
    local v1 = ProgressBar:GetAttribute("FullScale") or 1
    local v2 = Template.ProgressHolder.ProgressBar:GetAttribute("FullScale") or 1
    local IconPosition = Icon.Position
    local t1 = {
        Frame = { "BackgroundTransparency" },
        ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
        ImageButton = { "BackgroundTransparency", "ImageTransparency" },
        TextLabel = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
        TextButton = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
        ViewportFrame = { "BackgroundTransparency", "ImageTransparency" },
        ScrollingFrame = { "BackgroundTransparency", "ScrollBarImageTransparency" },
        CanvasGroup = { "BackgroundTransparency", "GroupTransparency" },
        UIStroke = { "Transparency" }
    }

    local function newFadeGroup(p1) -- line: 169
        -- upvalues: t1 (copy)
        local t2 = {}

        local function record(p2) -- line: 172
            -- upvalues: t2 (copy), t1 (copy)
            local v3 = t1[p2.ClassName]

            if v3 then
                for _, v4 in ipairs(v3) do
                    t2[#t2 + 1] = {
                        inst = p2,
                        prop = v4,
                        base = p2[v4]
                    }
                end
            end
        end

        record(p1)

        for _, descendant in ipairs(p1:GetDescendants()) do
            record(descendant)
        end

        return {
            apply = function(p3) -- apply | line: 190
                -- upvalues: t2 (copy)
                for _, v5 in ipairs(t2) do
                    if v5.inst.Parent then
                        v5.inst[v5.prop] = v5.base + (1 - v5.base) * p3
                    end
                end
            end
        }
    end

    local function tweenNumber(p4, p5, p6, p7) -- line: 201
        -- upvalues: TweenService (copy)
        local NumberValue = Instance.new("NumberValue")

        NumberValue.Value = p4
        p7(p4)

        local connection = NumberValue.Changed:Connect(p7)
        local tween = TweenService:Create(NumberValue, p6, {
            Value = p5
        })

        tween.Completed:Connect(function() -- line: 208
            -- upvalues: NumberValue (copy), connection (copy)
            connection:Disconnect()
            NumberValue:Destroy()
        end)
        tween:Play()

        return tween
    end

    local function getScale(p8) -- line: 216
        local AnimScale = p8:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = p8
        end

        return AnimScale
    end

    local function tweenTo(p9, p10, p11) -- line: 226
        -- upvalues: TweenService (copy)
        local tween = TweenService:Create(p9, p10, p11)

        tween:Play()

        return tween
    end

    local t4 = {}
    local connection

    local function startAmbient() -- line: 237
        -- upvalues: RunService (copy), t4 (copy), connection (ref)
        if not connection and #t4 ~= 0 then
            connection = RunService.RenderStepped:Connect(function(p12) -- line: 241
                -- upvalues: t4 (copy)
                for _, v6 in ipairs(t4) do
                    v6(p12)
                end
            end)
        end
    end

    local function stopAmbient() -- line: 248
        -- upvalues: connection (ref)
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    local Sounds = require(ReplicatedStorage.Data.OnboardingQuestline).Sounds
    local Audio = require(ReplicatedStorage.Shared.Audio)

    local function playCue(p13) -- line: 260
        -- upvalues: Sounds (copy), Audio (copy)
        local v7 = Sounds[p13]

        assert(v7 ~= nil, ("no sound slot named %q in OnboardingQuestline.Sounds"):format((tostring(p13))))

        if v7 ~= 0 then
            Audio.Play(v7, script, {})
        end
    end

    local function centreInParent(p14, p15) -- line: 269
        local v10 = p14.AbsolutePosition + p14.AbsoluteSize * 0.5
        local AbsolutePosition, AbsoluteSize = p15.AbsolutePosition, p15.AbsoluteSize

        return Vector2.new((v10.X - AbsolutePosition.X) / math.max(AbsoluteSize.X, 1), (v10.Y - AbsolutePosition.Y) / math.max(AbsoluteSize.Y, 1))
    end

    local function safeDivide(p16, p17) -- line: 279
        if not p17 or p17 <= 0 then
            return 0
        end

        return (math.clamp(p16 / p17, 0, 1))
    end

    local v16 = (function() -- collectLocks | line: 290
        -- upvalues: FTUEQuestMain (copy)
        local t5 = {}

        for _, child in ipairs(FTUEQuestMain:GetChildren()) do
            local v15 = child.Name:match("^Lock(%d+)$")

            if v15 and child:IsA("GuiObject") then
                t5[#t5 + 1] = {
                    index = tonumber(v15),
                    frame = child
                }
            end
        end

        table.sort(t5, function(p18, p19) -- line: 298
            return p18.index < p19.index
        end)

        return t5
    end)()

    for _, v17 in ipairs(v16) do
        v17.fade = newFadeGroup(v17.frame)
    end

    local t6 = {
        "Open",
        "Close",
        "LoadQuestSet",
        "SetQuest",
        "ClaimQuest",
        "SetKeyProgress",
        "UnlockNextLock",
        "ResetAll"
    }
    local t7 = {
        "ClaimClicked",
        "GoNowClicked",
        "CloseClicked",
        "LockUnlocked",
        "AllLocksUnlocked"
    }
    local RescueDragonAPI = Parent:FindFirstChild("RescueDragonAPI")

    if not RescueDragonAPI then
        RescueDragonAPI = Instance.new("Folder")
        RescueDragonAPI.Name = "RescueDragonAPI"
        RescueDragonAPI.Parent = Parent
    end

    local function getEvent(p20) -- line: 325
        -- upvalues: RescueDragonAPI (ref)
        local v18 = RescueDragonAPI:FindFirstChild(p20)

        if not v18 then
            v18 = Instance.new("BindableEvent")
            v18.Name = p20
            v18.Parent = RescueDragonAPI
        end

        return v18
    end

    local t8 = {}
    local v19

    for _, v20 in ipairs(t6) do
        v19 = RescueDragonAPI:FindFirstChild(v20)

        if not v19 then
            v19 = Instance.new("BindableEvent")
            v19.Name = v20
            v19.Parent = RescueDragonAPI
        end

        t8[v20] = v19
    end

    for _, v21 in ipairs(t7) do
        v19 = RescueDragonAPI:FindFirstChild(v21)

        if not v19 then
            v19 = Instance.new("BindableEvent")
            v19.Name = v21
            v19.Parent = RescueDragonAPI
        end

        t8[v21] = v19
    end

    local t9 = {
        isOpen = false,
        keyCurrent = 0,
        keyTotal = 0,
        locksUnlocked = 0,
        flightRunning = false,
        introToken = 0,
        generation = 0,
        rows = {}
    }

    local function bindHover(p21, p22) -- line: 362
        -- upvalues: TweenService (copy), playCue (copy)
        local AnimScale = p21:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = p21
        end

        local v22 = false
        local v23 = false

        local function refresh() -- line: 367
            -- upvalues: AnimScale (ref), v22 (ref), v23 (ref), TweenService (copy)
            local v24 = if v23 then 0.93 elseif v22 then 1.07 else 1
            local v25 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local t10 = {
                Scale = v24
            }

            TweenService:Create(AnimScale, v25, t10):Play()
        end

        p21.MouseEnter:Connect(function() -- line: 380
            -- upvalues: v22 (ref), refresh (copy), playCue (copy)
            v22 = true
            playCue("ButtonHover")
            refresh()
        end)
        p21.MouseLeave:Connect(function() -- line: 385
            -- upvalues: v22 (ref), v23 (ref), refresh (copy)
            v22 = false
            v23 = false
            refresh()
        end)
        p21.MouseButton1Down:Connect(function() -- line: 390
            -- upvalues: p22 (copy), v23 (ref), refresh (copy), playCue (copy)
            v23 = true
            playCue(p22 or "ButtonClick")
            refresh()
        end)
        p21.MouseButton1Up:Connect(function() -- line: 395
            -- upvalues: v23 (ref), refresh (copy)
            v23 = false
            refresh()
        end)
    end

    local function stopPulse(p23) -- line: 405
        if p23.pulseTween then
            p23.pulseTween:Cancel()
            p23.pulseTween = nil
        end

        local claim = p23.claim
        local AnimScale = claim:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = claim
        end

        AnimScale.Scale = 1
    end

    local function startPulse(p24) -- line: 413
        -- upvalues: TweenService (copy)
        if p24.pulseTween then
            p24.pulseTween:Cancel()
            p24.pulseTween = nil
        end

        local claim = p24.claim
        local AnimScale = claim:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = claim
        end

        AnimScale.Scale = 1

        local claim2 = p24.claim
        local AnimScale2 = claim2:FindFirstChild("AnimScale")

        if not AnimScale2 then
            AnimScale2 = Instance.new("UIScale")
            AnimScale2.Name = "AnimScale"
            AnimScale2.Parent = claim2
        end

        AnimScale2.Scale = 1

        local tween = TweenService:Create(AnimScale2, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Scale = 1.05
        })

        tween:Play()
        p24.pulseTween = tween
    end

    local function setRowBar(p25, p26, p27, p28) -- line: 421
        -- upvalues: TweenService (copy), v2 (copy), t9 (copy)
        local v27 = if not p27 or p27 <= 0 then 0 else math.clamp(p26 / p27, 0, 1)
        local v29 = UDim2.new(v2 * v27, 0, p25.bar.Size.Y.Scale, p25.bar.Size.Y.Offset)

        if not (p28 and t9.isOpen) then
            p25.bar.Size = v29
        else
            TweenService:Create(p25.bar, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = v29
            }):Play()
        end

        if p25.barLabel then
            p25.barLabel.Text = p25.data.ProgressText or string.format("%d/%d", p26, p27)
        end
    end

    local function setRowState(p29, p30, p31) -- line: 440
        -- upvalues: TweenService (copy), t9 (copy), startPulse (copy)
        p29.state = p30

        local v31 = p30 == "Claimable"
        local Visible

        if v31 then
            p29.inProgress.Visible = false
            p29.checkmark.Visible = false
            Visible = p29.claim.Visible
        else
            if p30 == "Claimed" then
                if p29.pulseTween then
                    p29.pulseTween:Cancel()
                    p29.pulseTween = nil
                end

                local claim = p29.claim
                local AnimScale = claim:FindFirstChild("AnimScale")

                if not AnimScale then
                    AnimScale = Instance.new("UIScale")
                    AnimScale.Name = "AnimScale"
                    AnimScale.Parent = claim
                end

                AnimScale.Scale = 1
                p29.claim.Visible = false
                p29.inProgress.Visible = false
                p29.checkmark.Visible = true

                local checkmark = p29.checkmark
                local AnimScale2 = checkmark:FindFirstChild("AnimScale")

                if not AnimScale2 then
                    AnimScale2 = Instance.new("UIScale")
                    AnimScale2.Name = "AnimScale"
                    AnimScale2.Parent = checkmark
                end

                local isOpen = if p31 then t9.isOpen else nil

                if not p31 or not isOpen then
                    AnimScale2.Scale = 1
                    p29.checkmark.Rotation = 0
                else
                    AnimScale2.Scale = 0
                    p29.checkmark.Rotation = -25

                    local v32 = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                    TweenService:Create(AnimScale2, v32, {
                        Scale = 1
                    }):Play()
                    TweenService:Create(p29.checkmark, v32, {
                        Rotation = 0
                    }):Play()
                end

                return
            end

            if p29.pulseTween then
                p29.pulseTween:Cancel()
                p29.pulseTween = nil
            end

            local claim = p29.claim
            local AnimScale = claim:FindFirstChild("AnimScale")

            if not AnimScale then
                AnimScale = Instance.new("UIScale")
                AnimScale.Name = "AnimScale"
                AnimScale.Parent = claim
            end

            AnimScale.Scale = 1
            p29.claim.Visible = false
            p29.checkmark.Visible = false
            p29.inProgress.Visible = true

            local inProgress = p29.inProgress
            local AnimScale2 = inProgress:FindFirstChild("AnimScale")

            if not AnimScale2 then
                AnimScale2 = Instance.new("UIScale")
                AnimScale2.Name = "AnimScale"
                AnimScale2.Parent = inProgress
            end

            AnimScale2.Scale = 1
        end

        if v31 and Visible or not v31 then
            return
        end

        p29.claim.Visible = true

        if not p31 or not t9.isOpen then
            startPulse(p29)

            return
        end

        local claim = p29.claim
        local AnimScale = claim:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = claim
        end

        AnimScale.Scale = 0.4

        local tween = TweenService:Create(AnimScale, TweenInfo.new(0.288, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        })

        tween:Play()
        tween.Completed:Connect(function() -- line: 452
            -- upvalues: p29 (copy), startPulse (copy)
            if p29.state == "Claimable" then
                startPulse(p29)
            end
        end)
    end

    local function applyQuestData(p32, p33, p34) -- line: 487
        -- upvalues: setRowBar (copy), setRowState (copy)
        for v34, v35 in pairs(p33) do
            p32.data[v34] = v35
        end

        local data = p32.data

        data.Goal = data.Goal or 1
        data.Current = data.Current or 0

        if data.Title then
            p32.title.Text = data.Title
        end

        if not data.State then
            data.State = data.Current >= data.Goal and "Claimable" or "InProgress"
        end

        setRowBar(p32, data.Current, data.Goal, p34)

        if p32.state ~= data.State then
            setRowState(p32, data.State, p34)
        end
    end

    local function destroyRows() -- line: 510
        -- upvalues: t9 (copy)
        for _, v36 in ipairs(t9.rows) do
            if v36.pulseTween then
                v36.pulseTween:Cancel()
                v36.pulseTween = nil
            end

            local claim = v36.claim
            local AnimScale = claim:FindFirstChild("AnimScale")

            if not AnimScale then
                AnimScale = Instance.new("UIScale")
                AnimScale.Name = "AnimScale"
                AnimScale.Parent = claim
            end

            AnimScale.Scale = 1
            v36.frame:Destroy()
        end

        table.clear(t9.rows)
    end

    local function buildRow(p35) -- line: 518
        -- upvalues: QuestHolder (copy), Template (copy), newFadeGroup (copy), t8 (copy), bindHover (copy)
        local clone = Template:Clone()

        clone.Name = "Quest" .. p35
        clone.LayoutOrder = p35
        clone.Visible = true

        local t16 = {
            state = nil,
            index = p35,
            frame = clone,
            title = clone:WaitForChild("Info1"),
            claim = clone:WaitForChild("Claim"),
            inProgress = clone:WaitForChild("InProgress"),
            checkmark = clone:WaitForChild("CompletedCheckmark"),
            bar = clone.ProgressHolder:WaitForChild("ProgressBar"),
            barLabel = clone.ProgressHolder:FindFirstChild("ProgressLabel"),
            data = {}
        }

        t16.checkmark.Visible = false
        t16.claim.Visible = false
        t16.inProgress.Visible = true
        clone.Parent = QuestHolder
        t16.fade = newFadeGroup(clone)
        bindHover(t16.claim)
        bindHover(t16.inProgress)
        t16.claim.MouseButton1Click:Connect(function() -- line: 547
            -- upvalues: t16 (copy), t8 (copy)
            t8.ClaimClicked:Fire(t16.index)
        end)
        t16.inProgress.MouseButton1Click:Connect(function() -- line: 550
            -- upvalues: t16 (copy), t8 (copy)
            t8.GoNowClicked:Fire(t16.index)
        end)

        return t16
    end

    local function hideRowsForIntro() -- line: 561
        -- upvalues: t9 (copy)
        for _, v37 in ipairs(t9.rows) do
            v37.fade.apply(1)

            local frame = v37.frame
            local AnimScale = frame:FindFirstChild("AnimScale")

            if not AnimScale then
                AnimScale = Instance.new("UIScale")
                AnimScale.Name = "AnimScale"
                AnimScale.Parent = frame
            end

            AnimScale.Scale = 0.84
            v37.frame.Rotation = -5
        end
    end

    local function playRowIntro() -- line: 569
        -- upvalues: TweenService (copy), tweenNumber (copy), t9 (copy), hideRowsForIntro (copy)
        t9.introToken += 1

        local introToken = t9.introToken

        hideRowsForIntro()
        task.spawn(function() -- line: 575
            -- upvalues: introToken (copy), TweenService (copy), tweenNumber (copy), t9 (copy)
            task.wait(0.1)

            for v38, v39 in ipairs(t9.rows) do
                if introToken ~= t9.introToken then
                    return
                end

                task.spawn(function() -- line: 582
                    -- upvalues: v39 (copy), TweenService (copy), tweenNumber (copy)
                    local v40 = TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v41 = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                    tweenNumber(1, 0, v40, function(p36) -- line: 585
                        -- upvalues: v39 (copy)
                        v39.fade.apply(p36)
                    end)

                    local frame = v39.frame
                    local AnimScale = frame:FindFirstChild("AnimScale")

                    if not AnimScale then
                        AnimScale = Instance.new("UIScale")
                        AnimScale.Name = "AnimScale"
                        AnimScale.Parent = frame
                    end

                    TweenService:Create(AnimScale, v41, {
                        Scale = 1
                    }):Play()
                    TweenService:Create(v39.frame, v41, {
                        Rotation = 0
                    }):Play()
                end)

                if v38 < #t9.rows then
                    task.wait(0.075)
                end
            end
        end)
    end

    local function punchKeyIcon() -- line: 603
        -- upvalues: TweenService (copy), Icon (copy)
        local AnimScale = Icon:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = Icon
        end

        AnimScale.Scale = 1.22
        TweenService:Create(AnimScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    local function refreshKeyBar(p37) -- line: 609
        -- upvalues: TweenService (copy), ProgressBar (copy), ProgressLabel (copy), v1 (copy), t9 (copy)
        local keyCurrent, keyTotal = t9.keyCurrent, t9.keyTotal
        local v43 = if not keyTotal or keyTotal <= 0 then 0 else math.clamp(keyCurrent / keyTotal, 0, 1)
        local v45 = UDim2.new(v1 * v43, 0, ProgressBar.Size.Y.Scale, ProgressBar.Size.Y.Offset)

        if not (p37 and t9.isOpen) then
            ProgressBar.Size = v45
        else
            TweenService:Create(ProgressBar, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = v45
            }):Play()
        end

        ProgressLabel.Text = string.format("%d/%d", t9.keyCurrent, t9.keyTotal)
    end

    local function isKeyBarFull() -- line: 622
        -- upvalues: t9 (copy)
        if t9.keyTotal > 0 then
            return t9.keyCurrent >= t9.keyTotal
        end

        return false
    end

    local function nextLock() -- line: 630
        -- upvalues: v16 (copy), t9 (copy)
        return v16[t9.locksUnlocked + 1]
    end

    local function clearUnlockSprite(p38) -- line: 634
        local LockUnlockedAnim = p38:FindFirstChild("LockUnlockedAnim")

        if LockUnlockedAnim then
            LockUnlockedAnim:Destroy()
        end
    end

    local function playUnlockSprite(p39) -- line: 642
        -- upvalues: LockUnlocked (copy)
        local LockIdle = p39:FindFirstChild("LockIdle")
        local clone = LockUnlocked:Clone()

        clone.Name = "LockUnlockedAnim"

        local v47 = clone:GetAttribute("Cells") or Vector2.new(1, 1)
        local v48 = clone:GetAttribute("FPS") or 15

        if LockIdle then
            clone.AnchorPoint = LockIdle.AnchorPoint
            clone.Position = LockIdle.Position
            clone.Size = LockIdle.Size
            clone.ScaleType = LockIdle.ScaleType
            clone.SizeConstraint = LockIdle.SizeConstraint
            clone.ZIndex = LockIdle.ZIndex + 1
        else
            clone.AnchorPoint = Vector2.new(0.5, 0.5)
            clone.Position = UDim2.fromScale(0.5, 0.5)
            clone.Size = UDim2.fromScale(1, 1)
        end

        clone.ImageRectOffset = Vector2.zero
        clone.Parent = p39

        if LockIdle then
            LockIdle.Visible = false
        end

        local v51 = math.max(1, (math.floor(v47.X * v47.Y)))
        local v52 = 1 / math.max(v48, 1)

        for i = 0, v51 - 1 do
            local v53 = i % v47.X
            local v55 = math.floor(i / v47.X)

            clone.ImageRectOffset = Vector2.new(clone.ImageRectSize.X * v53, clone.ImageRectSize.Y * v55)
            task.wait(v52)
        end

        return clone
    end

    local function flyKeyTo(p40) -- line: 683
        -- upvalues: TweenService (copy), RunService (copy), FTUEQuestMain (copy), Icon (copy), punchKeyIcon (copy)
        local v56 = Icon.AbsolutePosition + Icon.AbsoluteSize * 0.5
        local AbsolutePosition, AbsoluteSize = FTUEQuestMain.AbsolutePosition, FTUEQuestMain.AbsoluteSize
        local v60 = Vector2.new((v56.X - AbsolutePosition.X) / math.max(AbsoluteSize.X, 1), (v56.Y - AbsolutePosition.Y) / math.max(AbsoluteSize.Y, 1))
        local v61 = p40.AbsolutePosition + p40.AbsoluteSize * 0.5
        local AbsolutePosition2, AbsoluteSize2 = FTUEQuestMain.AbsolutePosition, FTUEQuestMain.AbsoluteSize
        local v65 = Vector2.new((v61.X - AbsolutePosition2.X) / math.max(AbsoluteSize2.X, 1), (v61.Y - AbsolutePosition2.Y) / math.max(AbsoluteSize2.Y, 1))
        local clone = Icon:Clone()

        clone.Name = "FlyingKey"
        clone:ClearAllChildren()
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.ZIndex = 500
        clone.Size = UDim2.fromScale(Icon.AbsoluteSize.X / math.max(FTUEQuestMain.AbsoluteSize.X, 1), Icon.AbsoluteSize.Y / math.max(FTUEQuestMain.AbsoluteSize.Y, 1))
        clone.Position = UDim2.fromScale(v60.X, v60.Y)
        clone.Rotation = Icon.Rotation
        clone.Parent = FTUEQuestMain

        local UIScale = Instance.new("UIScale")

        UIScale.Name = "AnimScale"
        UIScale.Scale = 0.4
        UIScale.Parent = clone
        TweenService:Create(UIScale, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
        punchKeyIcon()

        local v68 = (v60 + v65) * 0.5 + Vector2.new(0, -0.3)
        local Rotation = clone.Rotation
        local n1 = 0
        local connection

        connection = RunService.RenderStepped:Connect(function(p41) -- line: 716
            -- upvalues: v60 (copy), v65 (copy), clone (copy), UIScale (copy), v68 (copy), Rotation (copy), n1 (ref), connection (ref), TweenService (copy)
            n1 += p41

            local v70 = math.clamp(n1 / 0.75, 0, 1)
            local Value = TweenService:GetValue(v70, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local v71 = 1 - Value
            local v72 = v60 * (v71 * v71) + v68 * (2 * v71 * Value) + v65 * (Value * Value)

            clone.Position = UDim2.fromScale(v72.X, v72.Y)
            clone.Rotation = Rotation + 540 * Value
            UIScale.Scale = 1 + 0.55 * math.sin(3.141592653589793 * Value)

            if v70 >= 1 then
                connection:Disconnect()
            end
        end)
        task.wait(0.75)

        local v74 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(UIScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0.2
        }):Play()
        TweenService:Create(clone, v74, {
            ImageTransparency = 1,
            Rotation = clone.Rotation + 90
        }):Play()
        task.wait(0.18)
        clone:Destroy()
    end

    local function unlockLock(p42, p43) -- line: 743
        -- upvalues: TweenService (copy), tweenNumber (copy), v16 (copy), t8 (copy), t9 (copy), playUnlockSprite (copy)
        local frame = p42.frame
        local AnimScale = frame:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = frame
        end

        local fade = p42.fade
        local v76 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        TweenService:Create(AnimScale, v76, {
            Scale = 1.3
        }):Play()
        task.wait(0.12)

        if p43 ~= t9.generation then
            return false
        end

        TweenService:Create(AnimScale, v76, {
            Scale = 1
        }):Play()

        local LockUnlockedAnim = frame:FindFirstChild("LockUnlockedAnim")

        if LockUnlockedAnim then
            LockUnlockedAnim:Destroy()
        end

        local v77 = playUnlockSprite(frame)

        if p43 ~= t9.generation then
            return false
        end

        TweenService:Create(AnimScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 1.45
        }):Play()
        TweenService:Create(v77, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ImageTransparency = 1
        }):Play()
        tweenNumber(0, 1, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p44) -- line: 770
            -- upvalues: fade (copy)
            fade.apply(p44)
        end)
        task.wait(0.28)

        if p43 ~= t9.generation then
            return false
        end

        frame.Visible = false
        AnimScale.Scale = 1
        fade.apply(0)
        t9.locksUnlocked += 1
        t8.LockUnlocked:Fire(p42.index)

        if t9.locksUnlocked >= #v16 then
            t8.AllLocksUnlocked:Fire()
        end

        return true
    end

    local function runKeyFlight() -- line: 791
        -- upvalues: v16 (copy), t8 (copy), t9 (copy), flyKeyTo (copy), unlockLock (copy)
        if t9.flightRunning then
            return
        end

        local v81 = v16[t9.locksUnlocked + 1]

        if v81 then
            t9.flightRunning = true

            local generation = t9.generation

            if t9.isOpen then
                flyKeyTo(v81.frame)

                if generation ~= t9.generation then
                    t9.flightRunning = false

                    return
                end

                if unlockLock(v81, generation) then
                    task.wait(0.15)
                end
            else
                local LockIdle = v81.frame:FindFirstChild("LockIdle")

                if LockIdle then
                    LockIdle.Visible = false
                end

                v81.frame.Visible = false
                t9.locksUnlocked += 1
                t8.LockUnlocked:Fire(v81.index)

                if t9.locksUnlocked >= #v16 then
                    t8.AllLocksUnlocked:Fire()
                end
            end

            t9.flightRunning = false
        end
    end

    local AnimScale = FTUEQuestMain:FindFirstChild("AnimScale")

    if not AnimScale then
        AnimScale = Instance.new("UIScale")
        AnimScale.Name = "AnimScale"
        AnimScale.Parent = FTUEQuestMain
    end

    local v82 = newFadeGroup(FTUEQuestMain)

    local function openMenu() -- line: 837
        -- upvalues: TweenService (copy), RunService (copy), Parent (copy), FTUEQuestMain (copy), tweenNumber (copy), t4 (copy), connection (ref), t9 (copy), hideRowsForIntro (copy), AnimScale (ref), v82 (copy)
        if t9.isOpen then
            return
        end

        t9.isOpen = true
        Parent.Enabled = true

        if not connection and #t4 ~= 0 then
            connection = RunService.RenderStepped:Connect(function(p45) -- line: 241
                -- upvalues: t4 (copy)
                for _, v83 in ipairs(t4) do
                    v83(p45)
                end
            end)
        end

        FTUEQuestMain.Visible = true
        AnimScale.Scale = 0.66
        v82.apply(1)
        hideRowsForIntro()

        local v84 = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local t28 = {
            Scale = 1
        }

        TweenService:Create(AnimScale, v84, t28):Play()
        tweenNumber(1, 0, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), function(p46) -- line: 854
            -- upvalues: v82 (copy)
            v82.apply(p46)
        end)
        t9.introToken += 1

        local introToken = t9.introToken

        hideRowsForIntro()
        task.spawn(function() -- line: 575
            -- upvalues: introToken (copy), TweenService (copy), tweenNumber (copy), t9 (copy)
            task.wait(0.1)

            for v85, v86 in ipairs(t9.rows) do
                if introToken ~= t9.introToken then
                    return
                end

                task.spawn(function() -- line: 582
                    -- upvalues: TweenService (copy), tweenNumber (copy), v86 (copy)
                    local v87 = TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v88 = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                    tweenNumber(1, 0, v87, function(p47) -- line: 585
                        -- upvalues: v86 (copy)
                        v86.fade.apply(p47)
                    end)

                    local frame = v86.frame
                    local AnimScale = frame:FindFirstChild("AnimScale")

                    if not AnimScale then
                        AnimScale = Instance.new("UIScale")
                        AnimScale.Name = "AnimScale"
                        AnimScale.Parent = frame
                    end

                    TweenService:Create(AnimScale, v88, {
                        Scale = 1
                    }):Play()
                    TweenService:Create(v86.frame, v88, {
                        Rotation = 0
                    }):Play()
                end)

                if v85 < #t9.rows then
                    task.wait(0.075)
                end
            end
        end)
    end

    local function closeMenu() -- line: 861
        -- upvalues: TweenService (copy), Parent (copy), FTUEQuestMain (copy), tweenNumber (copy), connection (ref), t9 (copy), AnimScale (ref), v82 (copy)
        if t9.isOpen then
            t9.isOpen = false
            t9.introToken += 1

            local v89 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local t31 = {
                Scale = 0.8
            }

            TweenService:Create(AnimScale, v89, t31):Play()
            tweenNumber(0, 1, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p48) -- line: 871
                -- upvalues: v82 (copy)
                v82.apply(p48)
            end)
            task.delay(0.18, function() -- line: 875
                -- upvalues: Parent (copy), FTUEQuestMain (copy), connection (ref), t9 (copy), AnimScale (ref), v82 (copy)
                if t9.isOpen then
                    return
                end

                FTUEQuestMain.Visible = false
                v82.apply(0)
                AnimScale.Scale = 1

                if connection then
                    connection:Disconnect()
                    connection = nil
                end

                Parent.Enabled = false
            end)
        end
    end

    local function loadQuestSet(p49) -- line: 888
        -- upvalues: TweenService (copy), ProgressBar (copy), ProgressLabel (copy), v1 (copy), tweenNumber (copy), t9 (copy), applyQuestData (copy), destroyRows (copy), buildRow (copy), hideRowsForIntro (copy)
        p49 = p49 or {}
        destroyRows()

        for v91, v92 in ipairs(p49) do
            local v93 = buildRow(v91)

            t9.rows[v91] = v93
            applyQuestData(v93, v92, false)
        end

        t9.keyTotal = #t9.rows
        t9.keyCurrent = 0

        for _, v94 in ipairs(t9.rows) do
            if v94.state == "Claimed" then
                t9.keyCurrent += 1
            end
        end

        local keyCurrent, keyTotal = t9.keyCurrent, t9.keyTotal
        local v95 = if not keyTotal or keyTotal <= 0 then 0 else math.clamp(keyCurrent / keyTotal, 0, 1)

        ProgressBar.Size = UDim2.new(v1 * v95, 0, ProgressBar.Size.Y.Scale, ProgressBar.Size.Y.Offset)
        ProgressLabel.Text = string.format("%d/%d", t9.keyCurrent, t9.keyTotal)

        if not t9.isOpen then
            hideRowsForIntro()

            return
        end

        t9.introToken += 1

        local introToken = t9.introToken

        hideRowsForIntro()
        task.spawn(function() -- line: 575
            -- upvalues: introToken (copy), TweenService (copy), tweenNumber (copy), t9 (copy)
            task.wait(0.1)

            for v98, v99 in ipairs(t9.rows) do
                if introToken ~= t9.introToken then
                    return
                end

                task.spawn(function() -- line: 582
                    -- upvalues: TweenService (copy), tweenNumber (copy), v99 (copy)
                    local v100 = TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v101 = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                    tweenNumber(1, 0, v100, function(p50) -- line: 585
                        -- upvalues: v99 (copy)
                        v99.fade.apply(p50)
                    end)

                    local frame = v99.frame
                    local AnimScale = frame:FindFirstChild("AnimScale")

                    if not AnimScale then
                        AnimScale = Instance.new("UIScale")
                        AnimScale.Name = "AnimScale"
                        AnimScale.Parent = frame
                    end

                    TweenService:Create(AnimScale, v101, {
                        Scale = 1
                    }):Play()
                    TweenService:Create(v99.frame, v101, {
                        Rotation = 0
                    }):Play()
                end)

                if v98 < #t9.rows then
                    task.wait(0.075)
                end
            end
        end)
    end

    local function claimQuest(p51) -- line: 915
        -- upvalues: TweenService (copy), t9 (copy), setRowBar (copy), setRowState (copy), punchKeyIcon (copy), refreshKeyBar (copy), runKeyFlight (copy)
        local v102 = t9.rows[p51]

        if not v102 or v102.state == "Claimed" then
            return
        elseif v102.pulseTween then
            v102.pulseTween:Cancel()
            v102.pulseTween = nil
        end

        local claim = v102.claim
        local AnimScale = claim:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = claim
        end

        AnimScale.Scale = 1

        if v102.claim.Visible and t9.isOpen then
            local claim = v102.claim
            local AnimScale = claim:FindFirstChild("AnimScale")

            if not AnimScale then
                AnimScale = Instance.new("UIScale")
                AnimScale.Name = "AnimScale"
                AnimScale.Parent = claim
            end

            TweenService:Create(AnimScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0
            }):Play()
            task.wait(0.18)
        end

        v102.data.Current = v102.data.Goal or v102.data.Current
        setRowBar(v102, v102.data.Current, v102.data.Goal, true)
        setRowState(v102, "Claimed", true)
        v102.data.State = "Claimed"
        t9.keyCurrent = math.min(t9.keyCurrent + 1, t9.keyTotal)
        punchKeyIcon()
        refreshKeyBar(true)

        if t9.keyTotal > 0 and t9.keyCurrent >= t9.keyTotal then
            task.wait(0.35)
            runKeyFlight()
        end
    end

    local function resetAll() -- line: 946
        -- upvalues: TweenService (copy), FTUEQuestMain (copy), ProgressBar (copy), ProgressLabel (copy), Icon (copy), v1 (copy), IconPosition (copy), tweenNumber (copy), v16 (copy), t9 (copy), applyQuestData (copy), destroyRows (copy), buildRow (copy), hideRowsForIntro (copy)
        t9.introToken += 1
        t9.generation += 1
        t9.flightRunning = false
        t9.locksUnlocked = 0
        t9.keyCurrent = 0

        for _, v106 in ipairs(v16) do
            local LockUnlockedAnim = v106.frame:FindFirstChild("LockUnlockedAnim")

            if LockUnlockedAnim then
                LockUnlockedAnim:Destroy()
            end

            local LockIdle = v106.frame:FindFirstChild("LockIdle")

            if LockIdle then
                LockIdle.Visible = true
            end

            v106.frame.Visible = true

            local frame = v106.frame
            local AnimScale = frame:FindFirstChild("AnimScale")

            if not AnimScale then
                AnimScale = Instance.new("UIScale")
                AnimScale.Name = "AnimScale"
                AnimScale.Parent = frame
            end

            AnimScale.Scale = 1
            v106.fade.apply(0)
        end

        for _, child in ipairs(FTUEQuestMain:GetChildren()) do
            if child.Name == "FlyingKey" then
                child:Destroy()
            end
        end

        destroyRows()

        for i = 1, 3 do
            local v107 = buildRow(i)

            t9.rows[i] = v107
            applyQuestData(v107, {
                Current = 0,
                Goal = 1,
                State = "InProgress"
            }, false)
        end

        t9.keyTotal = #t9.rows

        local keyCurrent, keyTotal = t9.keyCurrent, t9.keyTotal
        local v108 = if not keyTotal or keyTotal <= 0 then 0 else math.clamp(keyCurrent / keyTotal, 0, 1)

        ProgressBar.Size = UDim2.new(v1 * v108, 0, ProgressBar.Size.Y.Scale, ProgressBar.Size.Y.Offset)
        ProgressLabel.Text = string.format("%d/%d", t9.keyCurrent, t9.keyTotal)
        Icon.Position = IconPosition

        local AnimScale = Icon:FindFirstChild("AnimScale")

        if not AnimScale then
            AnimScale = Instance.new("UIScale")
            AnimScale.Name = "AnimScale"
            AnimScale.Parent = Icon
        end

        AnimScale.Scale = 1

        if not t9.isOpen then
            hideRowsForIntro()

            return
        end

        t9.introToken += 1

        local introToken = t9.introToken

        hideRowsForIntro()
        task.spawn(function() -- line: 575
            -- upvalues: introToken (copy), TweenService (copy), tweenNumber (copy), t9 (copy)
            task.wait(0.1)

            for v111, v112 in ipairs(t9.rows) do
                if introToken ~= t9.introToken then
                    return
                end

                task.spawn(function() -- line: 582
                    -- upvalues: TweenService (copy), tweenNumber (copy), v112 (copy)
                    local v113 = TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v114 = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

                    tweenNumber(1, 0, v113, function(p52) -- line: 585
                        -- upvalues: v112 (copy)
                        v112.fade.apply(p52)
                    end)

                    local frame = v112.frame
                    local AnimScale = frame:FindFirstChild("AnimScale")

                    if not AnimScale then
                        AnimScale = Instance.new("UIScale")
                        AnimScale.Name = "AnimScale"
                        AnimScale.Parent = frame
                    end

                    TweenService:Create(AnimScale, v114, {
                        Scale = 1
                    }):Play()
                    TweenService:Create(v112.frame, v114, {
                        Rotation = 0
                    }):Play()
                end)

                if v111 < #t9.rows then
                    task.wait(0.075)
                end
            end
        end)
    end

    local n2 = 0

    t4[#t4 + 1] = function(p53) -- line: 998
        -- upvalues: Icon (copy), IconPosition (copy), n2 (ref)
        n2 += p53 * 1.6

        local v118 = math.sin(n2) * 0.006

        Icon.Position = UDim2.new(IconPosition.X.Scale, IconPosition.X.Offset, IconPosition.Y.Scale + v118, IconPosition.Y.Offset)
    end

    local function setupViewport() -- line: 1014
        -- upvalues: RunService (copy), ReplicatedStorage (copy), ViewportFrame (copy), t4 (copy), connection (ref), t9 (copy)
        if not ViewportFrame then
            return
        end

        local RewardAssetId = require(ReplicatedStorage.Data.OnboardingQuestline).RewardAssetId
        local v119 = ReplicatedStorage:WaitForChild("AssetModels", 15)
        local v120 = v119 and v119:FindFirstChild(RewardAssetId) or workspace:FindFirstChild(RewardAssetId)

        if not v120 then
            warn(("[RescueDragonUIAnimator] No model named %q in AssetModels or Workspace, viewport left empty."):format(RewardAssetId))

            return
        end

        local WorldModel = ViewportFrame:FindFirstChildOfClass("WorldModel")

        if WorldModel then
            WorldModel:Destroy()
        end

        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.Ambient = Color3.fromRGB(150, 150, 165)
        ViewportFrame.LightColor = Color3.fromRGB(255, 250, 240)
        ViewportFrame.LightDirection = Vector3.new(-0.35, -1, -0.5)

        local WorldModel2 = Instance.new("WorldModel")

        WorldModel2.Name = "DisplayWorld"
        WorldModel2.Parent = ViewportFrame

        local clone = v120:Clone()

        clone.Name = "DisplayModel"

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("LuaSourceContainer") then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        clone.Parent = WorldModel2
        clone:PivotTo(CFrame.new())

        local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
        local BoundingBoxPosition = BoundingBox.Position
        local v121 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)
        local Camera = Instance.new("Camera")

        Camera.Name = "DisplayCamera"
        Camera.FieldOfView = 40
        Camera.Parent = ViewportFrame
        ViewportFrame.CurrentCamera = Camera

        local v124 = v121 * 1.25 / (math.tan(math.rad(Camera.FieldOfView) * 0.5) * 2)
        local n3 = 0

        local function place(p54) -- line: 1080
            -- upvalues: BoundingBox2 (copy), BoundingBoxPosition (copy), Camera (copy), v124 (copy), n3 (ref)
            n3 += p54

            local v126 = 180 + math.sin(n3 * 0.5) * 7
            local v128 = math.sin(n3 * 1.1) * 0.012 * BoundingBox2.Y
            local v130 = BoundingBoxPosition + Vector3.new(0, 0.1 * BoundingBox2.Y + v128, 0)
            local v131 = CFrame.Angles(0, math.rad(v126), 0) * CFrame.Angles(-0.10471975511965978, 0, 0)

            Camera.CFrame = CFrame.lookAt(v130 + v131 * Vector3.new(0, 0, v124), v130)
        end

        place(0)
        t4[#t4 + 1] = place

        if t9.isOpen and not connection and #t4 ~= 0 then
            connection = RunService.RenderStepped:Connect(function(p55) -- line: 241
                -- upvalues: t4 (copy)
                for _, v132 in ipairs(t4) do
                    v132(p55)
                end
            end)
        end
    end

    task.spawn(setupViewport)
    bindHover(Close, "CancelPress")
    Close.MouseButton1Click:Connect(function() -- line: 1105
        -- upvalues: t8 (copy), closeMenu (copy)
        t8.CloseClicked:Fire()
        closeMenu()
    end)
    t8.Open.Event:Connect(openMenu)
    t8.Close.Event:Connect(closeMenu)
    t8.LoadQuestSet.Event:Connect(loadQuestSet)
    t8.ResetAll.Event:Connect(resetAll)
    t8.UnlockNextLock.Event:Connect(function() -- line: 1115
        -- upvalues: runKeyFlight (copy)
        task.spawn(runKeyFlight)
    end)
    t8.SetQuest.Event:Connect(function(p56, p57) -- line: 1119
        -- upvalues: t9 (copy), applyQuestData (copy)
        local v133 = t9.rows[p56]

        if v133 and p57 then
            applyQuestData(v133, p57, true)
        end
    end)
    t8.ClaimQuest.Event:Connect(function(p58) -- line: 1126
        -- upvalues: claimQuest (copy)
        task.spawn(claimQuest, p58)
    end)
    t8.SetKeyProgress.Event:Connect(function(p59, p60) -- line: 1130
        -- upvalues: t9 (copy), refreshKeyBar (copy)
        t9.keyTotal = p60 or #t9.rows
        t9.keyCurrent = math.clamp(p59 or 0, 0, t9.keyTotal)
        refreshKeyBar(true)
    end)
    Template.Visible = false
    FTUEQuestMain.Visible = false
    v82.apply(0)
    resetAll()
    Parent.Enabled = false
    RescueDragonAPI:SetAttribute("Ready", true)
end

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local t1 = {}
local t2 = {
    tile = 0.828,
    corner = 0.15,
    buttonScale = 1.08,
    iconScale = 1.1,
    iconTilt = -20,
    inTime = 0.18,
    outTime = 0.15,
    shineTime = 0.25,
    shineWidth = 0.07,
    shineFade = 0.15,
    shine = true,
    highlight = false,
    highlightFade = 0.6,
    highlightCorner = 0.2,
    pressScale = 1.15,
    pressUp = 0.07,
    pressSettle = 0.16,
    sounds = { "Hover1", "Hover2", "Hover3" }
}
local v1 = Random.new()
local _ = {
    AMP = 0.12,
    SPEED = 6.3
}
local t3 = {}
local t4 = {}
local t5 = {}

local function scaleOf(p1) -- line: 81
    local HoverScale = p1:FindFirstChild("HoverScale")

    if not HoverScale then
        HoverScale = Instance.new("UIScale")
        HoverScale.Name = "HoverScale"
        HoverScale.Parent = p1
    end

    return HoverScale
end

local function buildShine(p2, p3) -- line: 91
    local Frame = Instance.new("Frame")

    Frame.Name = "Shine"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(p3.tile, p3.tile)
    Frame.ZIndex = 2

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Window"
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.ClipsDescendants = true
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.fromScale(-0.1, 0)
    Frame2.Size = UDim2.fromScale(p3.shineWidth, 1)
    Frame2.ZIndex = 2
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Fill"
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame3.BackgroundTransparency = p3.shineFade
    Frame3.BorderSizePixel = 0
    Frame3.Size = UDim2.fromScale(1 / p3.shineWidth, 1)
    Frame3.ZIndex = 2
    Frame3.Parent = Frame2

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(p3.corner, 0)
    UICorner.Parent = Frame3
    Frame.Parent = p2

    return Frame, Frame2, Frame3
end

function t1.Attach(p4, p5) -- line: 125
    -- upvalues: TweenService (copy), SoundService (copy), t2 (copy), v1 (copy), t3 (copy), t4 (copy), t5 (copy), buildShine (copy)
    local v2 = table.clone(t2)

    for v3, v4 in pairs(p5 or {}) do
        v2[v3] = v4
    end

    local icon = v2.icon
    local HoverScale = p4:FindFirstChild("HoverScale")

    if not HoverScale then
        HoverScale = Instance.new("UIScale")
        HoverScale.Name = "HoverScale"
        HoverScale.Parent = p4
    end

    local HoverScale2

    if icon then
        HoverScale2 = icon:FindFirstChild("HoverScale")

        if not HoverScale2 then
            HoverScale2 = Instance.new("UIScale")
            HoverScale2.Name = "HoverScale"
            HoverScale2.Parent = icon
        end
    else
        HoverScale2 = icon
    end

    local t6 = {
        hovered = false,
        scale = v2.buttonScale
    }

    t5[p4] = t6

    local Frame

    if v2.highlight then
        local Frame2 = Instance.new("Frame")

        Frame = Frame2
        Frame2.Name = "Highlight"
        Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame2.BackgroundTransparency = 1
        Frame2.BorderSizePixel = 0
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.ZIndex = p4.ZIndex

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(v2.highlightCorner, 0)
        UICorner.Parent = Frame2
        Frame2.Parent = p4
    end

    local v5, v6, v7

    local function fillX(p6) -- line: 148
        -- upvalues: v2 (copy)
        return (v2.shineWidth / 2 - p6) / v2.shineWidth
    end

    local v8

    if v2.shine then
        local v9, v10, v11 = buildShine(p4, v2)

        v8 = v9
        v5 = v9
        v6 = v10
        v7 = v11
        v11.Position = UDim2.fromScale((v2.shineWidth / 2 - -0.1) / v2.shineWidth, 0)
    end

    local v12 = TweenInfo.new(v2.inTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v13 = TweenInfo.new(v2.outTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v14 = TweenInfo.new(v2.shineTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

    local function sweepShine(p7) -- line: 159
        -- upvalues: v2 (copy), v6 (ref), v7 (ref), v14 (copy), TweenService (copy)
        p7 = p7 or v14

        local v16 = v6

        v16.Position = UDim2.fromScale(-0.1, 0)

        local v17 = v7

        v17.Position = UDim2.fromScale((v2.shineWidth / 2 - -0.1) / v2.shineWidth, 0)
        TweenService:Create(v6, p7, {
            Position = UDim2.fromScale(1.1, 0)
        }):Play()
        TweenService:Create(v7, p7, {
            Position = UDim2.fromScale((v2.shineWidth / 2 - 1.1) / v2.shineWidth, 0)
        }):Play()
    end

    if v8 then
        t4[p4] = sweepShine
    end

    local function hoverIn() -- line: 168
        -- upvalues: p4 (copy), v2 (copy), icon (copy), HoverScale (ref), HoverScale2 (ref), t6 (copy), Frame (ref), v5 (ref), v12 (copy), sweepShine (copy), TweenService (copy), SoundService (copy), v1 (copy), t3 (copy)
        t6.hovered = true

        if not t3[p4] then
            TweenService:Create(HoverScale, v12, {
                Scale = v2.buttonScale
            }):Play()

            if Frame then
                TweenService:Create(Frame, v12, {
                    BackgroundTransparency = v2.highlightFade
                }):Play()
            end
        end

        if icon then
            TweenService:Create(HoverScale2, v12, {
                Scale = v2.iconScale
            }):Play()
            TweenService:Create(icon, v12, {
                Rotation = v2.iconTilt
            }):Play()
        end

        if v5 then
            sweepShine()
        end

        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local v18 = HarpoonSFX and HarpoonSFX:FindFirstChild(v2.sounds[v1:NextInteger(1, #v2.sounds)])

        if v18 then
            v18:Play()
        end
    end

    local function hoverOut() -- line: 183
        -- upvalues: p4 (copy), icon (copy), HoverScale (ref), HoverScale2 (ref), t6 (copy), Frame (ref), v13 (copy), TweenService (copy), t3 (copy)
        t6.hovered = false

        if not t3[p4] then
            TweenService:Create(HoverScale, v13, {
                Scale = 1
            }):Play()

            if Frame then
                TweenService:Create(Frame, v13, {
                    BackgroundTransparency = 1
                }):Play()
            end
        end

        if icon then
            TweenService:Create(HoverScale2, v13, {
                Scale = 1
            }):Play()
            TweenService:Create(icon, v13, {
                Rotation = 0
            }):Play()
        end
    end

    local function beckon() -- line: 195
        -- upvalues: p4 (copy), v2 (copy), HoverScale (ref), Frame (ref), v13 (copy), TweenService (copy), t3 (copy)
        if p4:GetAttribute("TutorialBeckon") and not t3[p4] then
            t3[p4] = true
            task.spawn(function() -- line: 198
                -- upvalues: p4 (copy), v2 (copy), HoverScale (ref), Frame (ref), v13 (copy), TweenService (copy), t3 (copy)
                local elapsed = os.clock()

                while p4.Parent and p4:GetAttribute("TutorialBeckon") do
                    local v20 = math.sin((os.clock() - elapsed) * 6.3) * 0.5 + 0.5

                    HoverScale.Scale = 1 + 0.12 * v20

                    if Frame then
                        Frame.BackgroundTransparency = 1 - (1 - v2.highlightFade) * v20
                    end

                    game:GetService("RunService").Heartbeat:Wait()
                end

                t3[p4] = nil
                TweenService:Create(HoverScale, v13, {
                    Scale = 1
                }):Play()

                if Frame then
                    TweenService:Create(Frame, v13, {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end)
        end
    end

    local t7 = {
        p4.MouseEnter:Connect(hoverIn),
        p4.MouseLeave:Connect(hoverOut),
        p4:GetAttributeChangedSignal("TutorialBeckon"):Connect(beckon),
        p4.SelectionGained:Connect(hoverIn),
        p4.SelectionLost:Connect(hoverOut)
    }

    if p4:GetAttribute("TutorialBeckon") and not t3[p4] then
        t3[p4] = true

        local spawn = task.spawn
        local HoverScale2 = HoverScale

        spawn(function() -- line: 198
            -- upvalues: p4 (copy), v2 (copy), Frame (ref), v13 (copy), HoverScale2 (copy), TweenService (copy), t3 (copy)
            local elapsed = os.clock()

            while p4.Parent and p4:GetAttribute("TutorialBeckon") do
                local v22 = math.sin((os.clock() - elapsed) * 6.3) * 0.5 + 0.5

                HoverScale2.Scale = 1 + 0.12 * v22

                if Frame then
                    local Frame2 = Frame

                    Frame2.BackgroundTransparency = 1 - (1 - v2.highlightFade) * v22
                end

                game:GetService("RunService").Heartbeat:Wait()
            end

            t3[p4] = nil
            TweenService:Create(HoverScale2, v13, {
                Scale = 1
            }):Play()

            if Frame then
                TweenService:Create(Frame, v13, {
                    BackgroundTransparency = 1
                }):Play()
            end
        end)
    end

    return function() -- line: 218
        -- upvalues: p4 (copy), icon (copy), HoverScale (ref), HoverScale2 (ref), Frame (ref), v5 (ref), t7 (copy), t4 (copy), t5 (copy)
        for _, v23 in ipairs(t7) do
            v23:Disconnect()
        end

        t4[p4] = nil
        t5[p4] = nil

        if v5 then
            v5:Destroy()
        end

        if Frame then
            Frame:Destroy()
        end

        HoverScale:Destroy()

        if HoverScale2 then
            HoverScale2:Destroy()
        end

        if icon then
            icon.Rotation = 0
        end
    end
end

function t1.Sweep(p8, p9) -- line: 231
    -- upvalues: t4 (copy)
    local v24 = t4[p8]

    if v24 then
        v24(p9 and TweenInfo.new(p9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    end
end

function t1.Rest(p10) -- line: 238
    -- upvalues: t5 (copy)
    local v25 = t5[p10]
    local v26, v27

    if v25 and v25.hovered then
        local scale = v25.scale

        if scale then
            v26 = scale
            v27 = true
        else
            v27 = false
        end
    else
        v27 = false
    end

    if not v27 then
        v26 = 1
    end

    return v26
end

function t1.Press(p11) -- line: 250
    -- upvalues: TweenService (copy), t2 (copy), t3 (copy), t5 (copy)
    if t3[p11] then
        return
    end

    local HoverScale = p11:FindFirstChild("HoverScale")

    if not HoverScale then
        HoverScale = Instance.new("UIScale")
        HoverScale.Name = "HoverScale"
        HoverScale.Parent = p11
    end

    local v28 = t5[p11]
    local scale

    if v28 then
        local hovered = v28.hovered

        if hovered then
            scale = v28.scale
        end

        if not hovered or not scale then
            scale = 1
        end
    else
        scale = HoverScale.Scale
    end

    local tween = TweenService:Create(HoverScale, TweenInfo.new(t2.pressUp, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = t2.pressScale
    })

    tween.Completed:Once(function() -- line: 256
        -- upvalues: HoverScale (ref), scale (ref), TweenService (copy), t2 (copy)
        TweenService:Create(HoverScale, TweenInfo.new(t2.pressSettle, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = scale
        }):Play()
    end)
    tween:Play()
end

local t8 = {
    HOLD = 0.12,
    SPIN = 90,
    EVERY = { 0.35, 0.8 },
    SIZE = { 0.32, 0.55 },
    X = { 0.06, 0.94 },
    Y = { 0.12, 0.88 },
    IN = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    OUT = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}

local function range(p12) -- line: 270
    -- upvalues: v1 (copy)
    return v1:NextNumber(p12[1], p12[2])
end

function t1.Sparkle(p13, p14) -- line: 271
    -- upvalues: TweenService (copy), v1 (copy), t8 (copy), range (copy)
    local t9 = {}

    for _, child in ipairs(p13:GetChildren()) do
        if child.Name:match("^Sparkle%d") and child:FindFirstChild("Pop") then
            t9[#t9 + 1] = {
                busy = false,
                gui = child,
                pop = child.Pop
            }
        end
    end

    if #t9 ~= 0 then
        task.spawn(function() -- line: 277
            -- upvalues: p14 (copy), t9 (copy), TweenService (copy), v1 (copy), t8 (copy), range (copy)
            while p14() do
                local v29 = nil
                local v30

                for _, v31 in ipairs(t9) do
                    if not v31.busy then
                        v29 = v31
                        v30 = v31
                        break
                    end
                end

                if v30 then
                    v30.busy = true

                    local gui = v30.gui
                    local fromScale = UDim2.fromScale
                    local X = t8.X

                    gui.Position = fromScale(v1:NextNumber(X[1], X[2]), range(t8.Y))
                    gui.Size = UDim2.fromScale(1, range(t8.SIZE))
                    gui.Rotation = v1:NextNumber(0, 90)
                    gui.ImageTransparency = 0
                    v30.pop.Scale = 0
                    gui.Visible = true

                    local v32 = t8.IN.Time + t8.HOLD + t8.OUT.Time
                    local v33 = (if v1:NextInteger(0, 1) == 0 then -1 else 1) * t8.SPIN

                    TweenService:Create(gui, TweenInfo.new(v32, Enum.EasingStyle.Linear), {
                        Rotation = gui.Rotation + v33
                    }):Play()
                    TweenService:Create(v30.pop, t8.IN, {
                        Scale = 1
                    }):Play()
                    task.delay(t8.IN.Time + t8.HOLD, function() -- line: 296
                        -- upvalues: v29 (ref), gui (copy), TweenService (copy), t8 (copy)
                        TweenService:Create(gui, t8.OUT, {
                            ImageTransparency = 1
                        }):Play()

                        local tween = TweenService:Create(v29.pop, t8.OUT, {
                            Scale = 0.4
                        })

                        tween.Completed:Once(function() -- line: 299
                            -- upvalues: v29 (ref), gui (copy)
                            gui.Visible = false
                            v29.busy = false
                        end)
                        tween:Play()
                    end)
                end

                task.wait(range(t8.EVERY))
            end
        end)
    end
end

return t1

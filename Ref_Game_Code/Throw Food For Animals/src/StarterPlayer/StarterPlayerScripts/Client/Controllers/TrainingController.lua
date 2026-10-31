-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local LevelConfig = require(ReplicatedStorage.Config.LevelConfig)
local StandsConfig = require(ReplicatedStorage.Config.StandsConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local UIScaler = require(Parent.UIScaler)
local Sounds = require(Parent.Sounds)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local HUDController = require(Parent.HUDController)
local ClientState = require(Parent.ClientState)
local Movement = require(Parent.Movement)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = false
local v2 = false
local n1 = 0
local v3
local v4 = false
local v5 = false
local n2 = 0
local v6 = false
local onCircle, elapsed

local function confetti(p1, p2, p3) -- line: 67
    -- upvalues: TweenService (copy), UIKit (copy), Colors (copy)
    local t2 = {
        Colors.GreenA,
        Colors.BlueA,
        Colors.YellowA,
        Colors.HeaderA,
        Colors.RedA,
        Color3.new(1, 1, 1)
    }

    for _ = 1, p3 do
        local Frame = Instance.new("Frame")

        Frame.Size = UDim2.fromOffset(math.random(8, 14), math.random(8, 14))
        Frame.Position = p2
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.BackgroundColor3 = t2[math.random(1, #t2)]
        Frame.BorderSizePixel = 0
        Frame.Rotation = math.random(0, 360)
        Frame.ZIndex = 60
        UIKit.Corner(Frame, 3)
        Frame.Parent = p1

        local v8 = math.rad((math.random(200, 340)))
        local v9 = math.random(120, 320)
        local v10 = p2 + UDim2.fromOffset(math.cos(v8) * v9, math.sin(v8) * v9 + 120)
        local v11 = 0.9 + math.random() * 0.5

        TweenService:Create(Frame, TweenInfo.new(v11, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1,
            Position = v10,
            Rotation = Frame.Rotation + math.random(-360, 360)
        }):Play()
        task.delay(v11 + 0.1, function() -- line: 85
            -- upvalues: Frame (copy)
            Frame:Destroy()
        end)
    end
end

local t3 = {}

local function worldPopup(p4, p5, p6) -- line: 100
    -- upvalues: TweenService (copy), UIKit (copy), Colors (copy), t3 (copy)
    p6 = p6 or {}

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui:SetAttribute("UIScaleIgnore", true)
    BillboardGui.Name = "TrainingPopup"
    BillboardGui.Size = UDim2.fromScale(p6.Width or 4.6, p6.Height or 1.25)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 400
    BillboardGui.Adornee = p4

    local v13 = p6.Offset or Vector3.new(0, 0, 0)

    BillboardGui.StudsOffsetWorldSpace = v13

    local v14 = UIKit.Text({
        Name = "Text",
        Stroke = 3,
        Parent = BillboardGui,
        Text = p5,
        Color = p6.Color or Colors.Text,
        Rich = p6.Rich
    })

    if p6.Gradient then
        UIKit.Gradient(v14, p6.Gradient[1], p6.Gradient[2], 90)
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.3
    UIScale.Parent = v14
    BillboardGui.Parent = p4
    t3[v14] = true

    local v15 = p6.Duration or 0.9

    TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    local Direction = p6.Direction

    if not Direction then
        Direction = Vector3.new(0, p6.Rise or 2, 0)
    end

    TweenService:Create(BillboardGui, TweenInfo.new(v15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        StudsOffsetWorldSpace = v13 + Direction
    }):Play()
    task.delay(v15 * 0.55, function() -- line: 122
        -- upvalues: v14 (copy), v15 (copy), TweenService (copy)
        if v14.Parent then
            TweenService:Create(v14, TweenInfo.new(v15 * 0.45), {
                TextTransparency = 1
            }):Play()

            local TextStroke = v14:FindFirstChild("TextStroke")

            if TextStroke then
                TweenService:Create(TextStroke, TweenInfo.new(v15 * 0.45), {
                    Transparency = 1
                }):Play()
            end
        end
    end)
    task.delay(v15 + 0.2, function() -- line: 128
        -- upvalues: BillboardGui (copy), v14 (copy), t3 (copy)
        t3[v14] = nil
        BillboardGui:Destroy()
    end)

    return BillboardGui
end

RunService.RenderStepped:Connect(function() -- line: 137
    -- upvalues: t3 (copy)
    for v17 in pairs(t3) do
        if v17.Parent then
            local TextStroke = v17:FindFirstChild("TextStroke")

            if TextStroke then
                TextStroke.Thickness = math.clamp(v17.AbsoluteSize.Y * 0.07, 1, 4)
            end
        else
            t3[v17] = nil
        end
    end
end)

local TapBonus = GameConfig.Training.TapBonus
local v19 = Color3.fromRGB(236, 190, 255)

local function backOut(p7) -- line: 155
    local v20 = p7 - 1

    return v20 * v20 * (2.70158 * v20 + 1.70158) + 1
end

local function round(p8) -- line: 161
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = p8
end

local function tapSparks(p9, p10, p11, p12) -- line: 168
    -- upvalues: TweenService (copy), UIScaler (copy), TapBonus (copy), v19 (copy)
    local t5 = {
        TapBonus.Color,
        v19,
        Color3.fromRGB(255, 120, 230),
        Color3.new(1, 1, 1)
    }
    local v21 = UIScaler.Factor()

    for i = 1, p11 do
        local Frame = Instance.new("Frame")
        local v22 = math.random(7, 13) * v21

        Frame.Size = UDim2.fromOffset(v22, v22)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromOffset(p10.X, p10.Y)
        Frame.BackgroundColor3 = t5[math.random(1, #t5)]
        Frame.BorderSizePixel = 0
        Frame.Rotation = 45
        Frame.ZIndex = 25

        if i % 2 == 0 then
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = Frame
        end

        Frame.Parent = p9

        local v23 = i / p11 * 3.141592653589793 * 2 + math.random() * 0.5
        local v24 = p12 * (0.55 + math.random() * 0.6)
        local v25 = UDim2.fromOffset(p10.X + math.cos(v23) * v24, p10.Y + math.sin(v23) * v24)
        local v26 = 0.45 + math.random() * 0.3

        TweenService:Create(Frame, TweenInfo.new(v26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1,
            Position = v25,
            Rotation = 45 + math.random(-180, 180),
            Size = UDim2.fromOffset(v22 * 0.3, v22 * 0.3)
        }):Play()
        task.delay(v26 + 0.05, function() -- line: 188
            -- upvalues: Frame (copy)
            Frame:Destroy()
        end)
    end
end

local function tapRing(p13, p14, p15) -- line: 193
    -- upvalues: TweenService (copy), UIScaler (copy), v19 (copy)
    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromOffset(p14.X, p14.Y)
    Frame.Size = UDim2.fromOffset(p15, p15)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 24

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v19
    UIStroke.Thickness = 6 * UIScaler.Factor()
    UIStroke.Parent = Frame
    Frame.Parent = p13

    local v27 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(Frame, v27, {
        Size = UDim2.fromOffset(p15 * 2.4, p15 * 2.4)
    }):Play()
    TweenService:Create(UIStroke, v27, {
        Transparency = 1,
        Thickness = 1
    }):Play()
    task.delay(0.5, function() -- line: 209
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local function tapHighlight(p16, p17) -- line: 214
    -- upvalues: TweenService (copy), ClientState (copy), TapBonus (copy), v19 (copy)
    if not (p16 and p16.Parent) then
        return nil
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "TapBonusHighlight"
    Highlight.FillColor = TapBonus.Color
    Highlight.OutlineColor = v19
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p16
    Highlight.Parent = p16
    ClientState.Spotlight = true
    Highlight.Destroying:Once(function() -- line: 227
        -- upvalues: ClientState (copy)
        ClientState.Spotlight = false
    end)
    TweenService:Create(Highlight, TweenInfo.new(0.08), {
        FillTransparency = 0.2,
        OutlineTransparency = 0
    }):Play()

    local v28 = false

    local function fade(p18) -- line: 230
        -- upvalues: Highlight (copy), v28 (ref), TweenService (copy)
        if v28 or not Highlight.Parent then
            return
        end

        v28 = true

        local tween = TweenService:Create(Highlight, TweenInfo.new(p18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            FillTransparency = 1,
            OutlineTransparency = 1
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 235
            -- upvalues: Highlight (copy)
            Highlight:Destroy()
        end)
    end

    task.delay(p17, fade, 0.5)

    return fade
end

local function makeTapButton(p19) -- line: 242
    -- upvalues: UIKit (copy), UIScaler (copy), TapBonus (copy)
    local ImageButton = Instance.new("ImageButton")

    ImageButton.Name = "TapBonus"
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageButton.Size = UDim2.fromScale(TapBonus.Size, TapBonus.Size)
    ImageButton.BackgroundTransparency = 1
    ImageButton.AutoButtonColor = false
    ImageButton.Image = TapBonus.Image
    ImageButton.ZIndex = 20

    if TapBonus.Image == "" then
        local Frame = Instance.new("Frame")

        Frame.Name = "Disc"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.46, 0.46)
        Frame.Size = UDim2.fromScale(0.86, 0.86)
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame.ZIndex = 20

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame
        UIKit.Gradient(Frame, Color3.fromRGB(240, 165, 255), Color3.fromRGB(165, 40, 225), 90)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(35, 10, 50)
        UIStroke.Thickness = 4 * UIScaler.Factor()
        UIStroke.Parent = Frame
        Frame.Parent = ImageButton

        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TextLabel.Position = UDim2.fromScale(0.5, 0.52)
        TextLabel.Size = UDim2.fromScale(0.62, 0.62)
        TextLabel.Text = utf8.char(128070)
        TextLabel.TextScaled = true
        TextLabel.ZIndex = 21
        TextLabel.Parent = Frame

        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.BackgroundTransparency = 1
        TextLabel2.AnchorPoint = Vector2.new(1, 1)
        TextLabel2.Position = UDim2.fromScale(1, 1)
        TextLabel2.Size = UDim2.fromScale(0.5, 0.36)
        TextLabel2.Font = Enum.Font.FredokaOne
        TextLabel2.Text = "x2"
        TextLabel2.TextColor3 = Color3.new(1, 1, 1)
        TextLabel2.TextScaled = true
        TextLabel2.ZIndex = 22

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Color = Color3.fromRGB(35, 10, 50)
        UIStroke2.Thickness = 3 * UIScaler.Factor()
        UIStroke2.Parent = TextLabel2
        TextLabel2.Parent = ImageButton
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = ImageButton
    ImageButton.Parent = p19

    return ImageButton, UIScale
end

local function startTapBonus(p20, p21, p22, p23) -- line: 300
    -- upvalues: RunService (copy), TweenService (copy), GameConfig (copy), StandsConfig (copy), Remotes (copy), Boosts (copy), DataController (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), ClientState (copy), LocalPlayer (copy), worldPopup (copy), TapBonus (copy), v19 (copy), tapSparks (copy), tapRing (copy), tapHighlight (copy), makeTapButton (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "TapBonusLayer"
    Frame:SetAttribute("UIScaleIgnore", true)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 20
    Frame.Parent = p20
    p23:Add(Frame)

    local t6 = nil

    p23:Add(function() -- line: 311
        -- upvalues: ClientState (copy)
        ClientState.Spotlight = false
    end)

    local function clear(p24) -- line: 313
        -- upvalues: t6 (ref), TweenService (copy)
        local t7 = t6

        t6 = nil

        if t7 then
            if t7.Conn then
                t7.Conn:Disconnect()
            end

            if p24 then
                t7.Button:Destroy()
            else
                local tween = TweenService:Create(t7.Scale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Scale = 0
                })

                tween:Play()
                tween.Completed:Once(function() -- line: 324
                    -- upvalues: t7 (copy)
                    t7.Button:Destroy()
                end)
            end
        end
    end

    p23:Add(function() -- line: 326
        -- upvalues: t6 (ref)
        local t8 = t6

        t6 = nil

        if t8 then
            if t8.Conn then
                t8.Conn:Disconnect()
            end

            t8.Button:Destroy()
        end
    end)

    local function claim(p25) -- line: 328
        -- upvalues: p21 (copy), p22 (copy), Frame (copy), t6 (ref), TweenService (copy), GameConfig (copy), StandsConfig (copy), Remotes (copy), Boosts (copy), DataController (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), LocalPlayer (copy), worldPopup (copy), TapBonus (copy), v19 (copy), tapSparks (copy), tapRing (copy), tapHighlight (copy)
        local v29 = true

        if p25.Claimed then
        elseif t6 == p25 then
            p25.Claimed = true
            t6 = nil

            if p25.Conn then
                p25.Conn:Disconnect()
            end

            v29 = false
        end

        if v29 then
            return
        end

        local Button, Scale = p25.Button, p25.Scale

        Button.Active = false
        Button.ImageTransparency = 0

        local v30 = Button.AbsolutePosition + Button.AbsoluteSize / 2 - Frame.AbsolutePosition

        Sounds.Play("TapBonusClaim")
        Sounds.Play("TapBonusBurst")
        tapRing(Frame, v30, Button.AbsoluteSize.Y * 0.8)
        tapSparks(Frame, v30, 22, Button.AbsoluteSize.Y * 1.3)
        ScreenFX.Flash(TapBonus.Color, 0.16, 0.35)
        CameraRig.PunchFOV(4, 0.05, 0.35)
        TweenService:Create(Scale, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1.3
        }):Play()
        task.delay(0.09, function() -- line: 345
            -- upvalues: Button (copy), Scale (copy), TweenService (copy)
            if Button.Parent then
                TweenService:Create(Scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Scale = 0
                }):Play()
                TweenService:Create(Button, TweenInfo.new(0.16), {
                    ImageTransparency = 1
                }):Play()
                task.delay(0.2, function() -- line: 349
                    -- upvalues: Button (copy)
                    Button:Destroy()
                end)
            end
        end)

        local RepInterval = GameConfig.Training.RepInterval
        local v31 = tapHighlight(p21, RepInterval + 0.2)

        worldPopup(p22, "x2!", {
            Width = 3.6,
            Height = 1.5,
            Offset = Vector3.new(0, 2.4, 0),
            Rise = 1.4,
            Duration = 1.1,
            Color = Color3.new(1, 1, 1),
            Gradient = {
                v19,
                TapBonus.Color
            }
        })
        task.spawn(function() -- line: 354
            -- upvalues: p25 (copy), RepInterval (copy), v31 (copy), p22 (copy), StandsConfig (copy), Remotes (copy), Boosts (copy), DataController (copy), Sounds (copy), LocalPlayer (copy), worldPopup (copy), v19 (copy)
            local v32 = Remotes.Invoke("Training_TapBonus", p25.Id)

            if v32.Ok then
                local v33 = (v32.Start or 0) + (v32.Duration or RepInterval) - workspace:GetServerTimeNow()

                task.delay(math.max(0, v33), function() -- line: 362
                    -- upvalues: v32 (copy), p22 (copy), StandsConfig (copy), Boosts (copy), DataController (copy), Sounds (copy), LocalPlayer (copy), worldPopup (copy), v19 (copy)
                    if p22.Parent then
                        local v35 = StandsConfig.Get((math.clamp(DataController:Get("Stand") or 0, 1, StandsConfig.Count())))
                        local CFrame = workspace.CurrentCamera.CFrame
                        local v36 = math.random() * 3.141592653589793 * 2
                        local v37 = CFrame.RightVector * math.cos(v36) + CFrame.UpVector * math.sin(v36)
                        local v38 = Boosts.Xp(LocalPlayer) > 1

                        worldPopup(p22, Boosts.XpText(v35.XpPerRep * (v32.ExtraReps or 1), LocalPlayer), {
                            Height = 0.95,
                            Duration = 0.95,
                            Rich = true,
                            Width = v38 and 4.8 or 3.6,
                            Offset = v37 * 0.6,
                            Direction = v37 * 3,
                            Color = v19
                        })
                        Sounds.Play("TapBonusXp")
                    end
                end)
            elseif v31 then
                v31(0.2)
            end
        end)
    end

    local function show(p26, p27) -- line: 375
        -- upvalues: Frame (copy), t6 (ref), clear (copy), claim (copy), RunService (copy), TweenService (copy), Sounds (copy), ClientState (copy), TapBonus (copy), makeTapButton (copy)
        if ClientState.TutorialActive then
            return
        end

        local v40 = (p27 or 0) - workspace:GetServerTimeNow()

        if not (v40 < 0.5) then
            local t10 = t6

            t6 = nil

            if t10 then
                if t10.Conn then
                    t10.Conn:Disconnect()
                end

                t10.Button:Destroy()
            end

            local v41, v42 = makeTapButton(Frame)

            v41.Position = UDim2.fromScale(0.5 + (math.random() * 2 - 1) * TapBonus.SpreadX, 0.5 + (math.random() * 2 - 1) * TapBonus.SpreadY)
            v41.Rotation = -14

            local t11 = {
                Id = p26,
                Button = v41,
                Scale = v42
            }

            t6 = t11
            Sounds.Play("TapBonusAppear")
            TweenService:Create(v41, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play()

            local elapsed = os.clock()
            local v43 = elapsed + v40

            t11.Conn = RunService.RenderStepped:Connect(function() -- line: 389
                -- upvalues: v41 (copy), v42 (copy), t11 (copy), elapsed (copy), v43 (copy), t6 (ref), clear (copy)
                local elapsed2 = os.clock()
                local v44 = elapsed2 - elapsed
                local v45 = v43 - elapsed2

                if v45 <= 0 then
                    if t6 == t11 then
                        clear(false)
                    end
                else
                    local v46 = 1

                    if v44 < 0.35 then
                        local v47 = v44 / 0.35 - 1

                        v46 = v47 * v47 * (2.70158 * v47 + 1.70158) + 1 or 1
                    end

                    v42.Scale = v46 * (math.sin(v44 * 8) * 0.06 + 1)

                    local v49 = v45 < 1.5
                    local v50 = if v49 then math.floor(v45 * 8) % 2 == 0 else nil

                    v41.ImageTransparency = (not v49 or not v50) and 0 or 0.45
                end
            end)
            v41.Activated:Connect(function() -- line: 401
                -- upvalues: t11 (copy), claim (copy)
                claim(t11)
            end)
        end
    end

    p23:Add(Remotes.Event("Training_Bonus").OnClientEvent:Connect(show))
end

local function startFreeCamera(p28, p29) -- line: 416
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera
    local Part = Instance.new("Part")

    Part.Name = "TrainingCameraFocus"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p28 - Vector3.new(0, 2.2, 0))
    Part.Parent = workspace
    p29:Add(Part)
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = Part

    local v53 = Part.Position + Vector3.new(4.648801, 2, 9.969386)

    CurrentCamera.CFrame = CFrame.lookAt(v53, Part.Position)

    local CameraMinZoomDistance, CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

    LocalPlayer.CameraMaxZoomDistance = math.max(11, CameraMinZoomDistance)
    LocalPlayer.CameraMinZoomDistance = 11
    task.delay(0.15, function() -- line: 437
        -- upvalues: CameraMinZoomDistance (copy), CameraMaxZoomDistance (copy), LocalPlayer (copy)
        LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
        LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance
    end)

    return Part
end

local function restoreCamera() -- line: 445
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Custom

    local v54 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v54 then
        CurrentCamera.CameraSubject = v54
    end
end

local function runSequence(p30) -- line: 452
    -- upvalues: RunService (copy), TweenService (copy), GameConfig (copy), LevelConfig (copy), StandsConfig (copy), NumberFormat (copy), Remotes (copy), Janitor (copy), Boosts (copy), DataController (copy), UIKit (copy), UIScaler (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), Movement (copy), Colors (copy), LocalPlayer (copy), PlayerGui (copy), v1 (ref), v2 (ref), confetti (copy), worldPopup (copy), startTapBonus (copy), startFreeCamera (copy), restoreCamera (copy)
    local v55 = Janitor.new()
    local Character = LocalPlayer.Character

    if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
        return
    end

    Movement.Lock()
    v55:Add(function() -- line: 459
        -- upvalues: Movement (copy)
        Movement.Unlock()
    end)
    Sounds.Play("CameraWhoosh", {
        Volume = 0.45
    })
    HUDController.SetGameplayVisible(false, {
        StatsGui = true
    })
    v55:Add(function() -- line: 464
        -- upvalues: HUDController (copy)
        HUDController.SetGameplayVisible(true)
    end)
    ScreenFX.Cover(Color3.new(0, 0, 0))

    local v56 = workspace.Plots:FindFirstChild((tostring(p30.PlotIndex)))
    local v57 = v56 and v56:FindFirstChild("Server")

    v57 = v57 and (v57:FindFirstChild(p30.RigName) or v57:WaitForChild(p30.RigName, 5))

    local BarPosition = p30.BarPosition

    startFreeCamera(BarPosition, v55)
    v55:Add(restoreCamera)

    local Part = Instance.new("Part")

    Part.Name = "TrainingPopupAnchor"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(BarPosition - Vector3.new(0, 1.6, 0))
    Part.Parent = workspace
    v55:Add(Part)

    local TrainingGui = PlayerGui:FindFirstChild("TrainingGui")
    local v58 = UIKit.ScreenGui("TrainingSequence", 140, false)

    v55:Add(v58)

    local XPBar, v59, v60, v61

    if TrainingGui then
        TrainingGui.Enabled = true
        TrainingGui.DisplayOrder = 141
        v55:Add(function() -- line: 497
            -- upvalues: TrainingGui (copy)
            TrainingGui.Enabled = false
        end)

        local XPBar2 = TrainingGui:FindFirstChild("XPBar")

        XPBar = XPBar2
        v59 = XPBar2 and XPBar2.Track.Fill

        if XPBar2 then
            local v64 = math.max(4, (math.round(10 * UIScaler.Factor())))

            XPBar2.Track.Size = UDim2.new(1, -v64, 1, -v64)
        end

        v60 = XPBar2 and XPBar2.LevelLabel
        v61 = XPBar2 and XPBar2.XPLabel
    end

    UIKit.Button({
        Text = "STOP",
        ZIndex = 10,
        Ratio = 3.2,
        Parent = v58,
        Size = UDim2.fromScale(0.11, 0.065),
        Position = UDim2.fromScale(0.5, 0.86),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        OnClick = function() -- OnClick | line: 509
            -- upvalues: v2 (ref)
            v2 = true
        end
    }).Size = UDim2.fromScale(0.11, 0.065)

    local function refreshBar(p31) -- line: 514
        -- upvalues: v59 (ref), v60 (ref), v61 (ref), TweenService (copy), LevelConfig (copy), NumberFormat (copy), DataController (copy)
        if not v59 then
            return
        end

        local v65 = DataController:Get("Level") or 1
        local v66 = DataController:Get("Xp") or 0
        local v67 = LevelConfig.XpForLevel(v65)
        local v68 = v60

        v68.Text = "Level " .. v65

        local v69 = v61

        v69.Text = NumberFormat.Xp(v66) .. "/" .. NumberFormat.Xp(v67)

        local v71 = UDim2.fromScale(math.clamp(v66 / v67, 0, 1), 1)

        if p31 then
            v59.Size = v71
        else
            TweenService:Create(v59, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = v71
            }):Play()
        end
    end

    if v59 then
        local v72 = DataController:Get("Level") or 1
        local v73 = DataController:Get("Xp") or 0
        local v74 = LevelConfig.XpForLevel(v72)
        local v75 = "Level " .. v72

        v60.Text = v75

        local v76 = NumberFormat.Xp(v73) .. "/" .. NumberFormat.Xp(v74)

        v61.Text = v76

        local v78 = UDim2.fromScale(math.clamp(v73 / v74, 0, 1), 1)

        v59.Size = v78
    end

    local v79 = DataController:Get("Level") or 1
    local v80 = false

    v55:Add(DataController:Observe("Xp", function() -- line: 533
        -- upvalues: refreshBar (copy)
        refreshBar(false)
    end))
    v55:Add(DataController:Observe("Level", function(p32) -- line: 534
        -- upvalues: Part (copy), v58 (copy), XPBar (ref), refreshBar (copy), v79 (ref), v80 (ref), LevelConfig (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), Colors (copy), confetti (copy), worldPopup (copy)
        if v79 < p32 and v80 then
            v79 = p32
        elseif v79 < p32 then
            v79 = p32
            Sounds.Play("LevelUp")
            CameraRig.PunchFOV(7, 0.06, 0.5)
            ScreenFX.Flash(Colors.BlueA, 0.25, 0.5)
            worldPopup(Part, "LEVEL UP!", {
                Width = 6.8,
                Height = 1.7,
                Offset = Vector3.new(0, 4.2, 0),
                Rise = 1.3,
                Duration = 1.6,
                Color = Color3.new(1, 1, 1),
                Gradient = {
                    Colors.YellowA,
                    Colors.YellowB
                }
            })
            worldPopup(Part, "Throw Power +" .. LevelConfig.PowerPerLevel, {
                Width = 5.2,
                Height = 0.9,
                Offset = Vector3.new(0, 3.1, 0),
                Rise = 1.3,
                Duration = 1.6,
                Color = Colors.Power
            })

            if XPBar then
                UIKit.Punch(XPBar, 0.12, 0.5)

                local v82 = XPBar.AbsolutePosition + XPBar.AbsoluteSize / 2

                confetti(v58, UDim2.fromOffset(v82.X, v82.Y), 26)
            end
        end

        refreshBar(false)
    end))
    ScreenFX.FadeIn(0.4)

    local RepInterval = GameConfig.Training.RepInterval
    local StartTime = p30.StartTime
    local n3 = 0

    v55:Add((RunService.Heartbeat:Connect(function() -- line: 560
        -- upvalues: Part (copy), v59 (ref), RepInterval (copy), StartTime (copy), n3 (ref), StandsConfig (copy), Boosts (copy), DataController (copy), UIKit (copy), Sounds (copy), Colors (copy), LocalPlayer (copy), worldPopup (copy)
        local v84 = math.floor((workspace:GetServerTimeNow() - StartTime) / RepInterval)

        if not (n3 < v84) then
            return
        end

        n3 = v84

        local v86 = StandsConfig.Get((math.clamp(DataController:Get("Stand") or 0, 1, StandsConfig.Count())))
        local v87 = Boosts.Xp(LocalPlayer) > 1
        local CFrame = workspace.CurrentCamera.CFrame
        local v88 = math.random() * 3.141592653589793 * 2
        local v89 = CFrame.RightVector * math.cos(v88) + CFrame.UpVector * math.sin(v88)
        local v90 = 2.2 + math.random() * 1.2

        worldPopup(Part, Boosts.XpText(v86.XpPerRep, LocalPlayer), {
            Height = 0.85,
            Duration = 0.85,
            Rich = true,
            Width = v87 and 4.4 or 3.2,
            Offset = v89 * 0.6,
            Direction = v89 * v90,
            Color = Colors.Xp
        })
        Sounds.Play("XpTick")

        if v59 then
            UIKit.Punch(v59.Parent, 0.03, 0.25)
        end
    end)))
    startTapBonus(v58, v57, Part, v55)

    while not v2 do
        if LocalPlayer:GetAttribute("Training") ~= false and v1 then
            task.wait(0.1)

            if LocalPlayer.Character and LocalPlayer.Character.Parent then
                continue
            end
        end

        break
    end

    v80 = true
    Sounds.Play("CameraWhoosh", {
        Volume = 0.45,
        Pitch = 1.1
    })
    ScreenFX.FadeOut(Color3.new(0, 0, 0), 0.3)
    Remotes.Invoke("Training_Stop")
    v55:Cleanup()
    task.wait(0.1)

    local CurrentCamera, CurrentCamera2 = workspace.CurrentCamera, workspace.CurrentCamera

    CurrentCamera2.CameraType = Enum.CameraType.Custom

    local v92 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v92 then
        CurrentCamera2.CameraSubject = v92
    end

    local v93 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v93 then
        CurrentCamera.CFrame = CFrame.lookAt(v93.Position + Vector3.new(6, 6, 8), v93.Position)
    end

    ScreenFX.FadeIn(0.45)
end

local thread

function t1.Start() -- line: 608
    -- upvalues: Remotes (copy), DataController (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), ClientState (copy), Movement (copy), LocalPlayer (copy), PlayerGui (copy), v1 (ref), v2 (ref), n1 (ref), v5 (ref), n2 (ref), onCircle (ref), elapsed (ref), runSequence (copy), thread (ref)
    if v1 or ClientState.Busy or ClientState.OfflineOpen then
        return
    end

    v1 = true
    thread = coroutine.running()
    v2 = false
    ClientState.Busy = "Training"

    if (DataController:Get("Stand") or 0) < 1 then
        v1 = false
        ClientState.Busy = nil
    else
        ScreenFX.FadeOut(Color3.new(0, 0, 0), 0.3)

        local Training_Start = Remotes.Invoke("Training_Start")

        if Training_Start.Ok then
            elapsed = os.clock()

            local ok, result = pcall(runSequence, Training_Start)

            elapsed = nil

            if not ok then
                warn("[TrainingController] " .. tostring(result))
                ScreenFX.Reset()
                CameraRig.Release()

                local CurrentCamera = workspace.CurrentCamera

                CurrentCamera.CameraType = Enum.CameraType.Custom

                local Character = LocalPlayer.Character

                if Character then
                    Character = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

                    if Character then
                        CurrentCamera.CameraSubject = Character
                    end
                end

                HUDController.SetGameplayVisible(true)
                Movement.Unlock()
                Remotes.Invoke("Training_Stop")

                local TrainingGui = PlayerGui:FindFirstChild("TrainingGui")

                if TrainingGui then
                    TrainingGui.Enabled = false
                end

                local TrainingSequence = PlayerGui:FindFirstChild("TrainingSequence")

                if TrainingSequence then
                    TrainingSequence:Destroy()
                end
            end

            v1 = false
            thread = nil
            ClientState.Busy = nil
            n1 = os.clock()
            v5 = onCircle()
        else
            ScreenFX.FadeIn(0.3)
            v1 = false
            ClientState.Busy = nil
            n1 = os.clock()
            n2 = os.clock() + 1.5
        end
    end
end

local function checkDeadTraining() -- line: 659
    -- upvalues: Remotes (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), ClientState (copy), Movement (copy), PlayerGui (copy), v1 (ref), n1 (ref), elapsed (ref), restoreCamera (copy), thread (ref)
    if v1 and thread and coroutine.status(thread) == "dead" then
        warn("[TrainingController] The training's script died half way - cleaning up")
        thread = nil
        elapsed = nil

        local Reset = ScreenFX.Reset

        pcall(Reset)

        local Release = CameraRig.Release

        pcall(Release)
        pcall(restoreCamera)

        local SetGameplayVisible = HUDController.SetGameplayVisible

        pcall(SetGameplayVisible, true)

        local Unlock = Movement.Unlock

        pcall(Unlock)

        local TrainingGui = PlayerGui:FindFirstChild("TrainingGui")

        if TrainingGui then
            TrainingGui.Enabled = false
        end

        local TrainingSequence = PlayerGui:FindFirstChild("TrainingSequence")

        if TrainingSequence then
            TrainingSequence:Destroy()
        end

        task.spawn(Remotes.Invoke, "Training_Stop")
        v1 = false

        if ClientState.Busy == "Training" then
            ClientState.Busy = nil
        end

        n1 = os.clock()
    end
end

function t1.Stop() -- line: 681
    -- upvalues: v1 (ref), v2 (ref)
    if v1 then
        v2 = true
    end
end

function t1.IsRunning() -- line: 685
    -- upvalues: v1 (ref)
    return v1
end

function t1.GetStopButton() -- line: 690
    -- upvalues: PlayerGui (copy)
    local TrainingSequence = PlayerGui:FindFirstChild("TrainingSequence")

    return TrainingSequence and TrainingSequence:FindFirstChild("Button")
end

function t1.GetTrainingTime() -- line: 696
    -- upvalues: v1 (ref), elapsed (ref)
    local v94, v95

    if v1 and elapsed then
        local v96 = os.clock() - elapsed

        if v96 then
            v94 = v96
            v95 = true
        else
            v95 = false
        end
    else
        v95 = false
    end

    if not v95 then
        v94 = 0
    end

    return v94
end

function onCircle() -- line: 701
    -- upvalues: LocalPlayer (copy), v3 (ref)
    local Character = LocalPlayer.Character
    local v97 = Character

    if Character then
        v97 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if v97 and Character and not (Character.Health <= 0) and v3 and v3.Parent then
        local v99 = math.min(v3.Size.Y, v3.Size.Z) / 2
        local v100 = v97.Position - v3.Position
        local v98 = Vector3.new(v100.X, 0, v100.Z).Magnitude <= v99 and v100.Y > -2 and v100.Y < 8

        return v98
    end

    return false
end

local function pollCircle() -- line: 711
    -- upvalues: DataController (copy), HUDController (copy), ClientState (copy), t1 (copy), v1 (ref), v4 (ref), v5 (ref), n2 (ref), v6 (ref), onCircle (ref)
    local v101 = onCircle()

    if v101 then
        if not v4 then
            v6 = false
        end
    else
        v5 = false
    end

    v4 = v101

    if v101 and not v5 and not v1 and not ClientState.Busy and not ClientState.OfflineOpen and not (os.clock() < n2) then
        if (DataController:Get("Stand") or 0) < 1 then
            if not v6 then
                v6 = true

                if not ClientState.TutorialActive then
                    HUDController.Notify("Buy a pull-up bar at the button first!", "Info")
                end
            end
        else
            task.spawn(t1.Start)
        end
    end
end

function t1.BindSpot(p33) -- line: 734
    -- upvalues: v3 (ref)
    v3 = p33
    p33.CanTouch = false
end

function t1.Init() -- line: 739
    -- upvalues: RunService (copy), checkDeadTraining (copy), pollCircle (copy)
    RunService.Heartbeat:Connect(checkDeadTraining)
    RunService.Heartbeat:Connect(pollCircle)
end

return t1

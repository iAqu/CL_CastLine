-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Controls = require(script.Parent.Parent.Character.Controls)
local BossFx = require(script.Parent.BossFx)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(215, 240, 255)
local ScreenGui, Folder, v3
local tween = nil
local t2

local function camera() -- line: 38
    return workspace.CurrentCamera
end

local function tween2(p1, p2, p3, p4, p5) -- line: 42
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function part(p6) -- line: 48
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v4, v5 in p6 do
        Part[v4] = v5
    end

    Part.Parent = Folder

    return Part
end

local function emit(p7, p8, p9) -- line: 59
    -- upvalues: Debris (copy), Folder (ref)
    local t3 = {
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new(p7)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v6, v7 in t3 do
        Part[v6] = v7
    end

    Part.Parent = Folder

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightInfluence = 0

    for v8, v9 in p9 do
        ParticleEmitter[v8] = v9
    end

    if ParticleEmitter.Texture == "rbxassetid://16676544947" or ParticleEmitter.Texture == "rbxassetid://16669188960" then
        ParticleEmitter.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        ParticleEmitter.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p8)
    Debris:AddItem(Part, 4)

    return Part
end

local function seq(p10, p11, p12) -- line: 77
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p10),
        NumberSequenceKeypoint.new(0.4, p11),
        NumberSequenceKeypoint.new(1, p12 or 0)
    })
end

local function shakeOk() -- line: 81
    -- upvalues: Settings (copy)
    return Settings.get("Shake") == true
end

function t1.impactFrame(p13, p14, p15) -- line: 88
    -- upvalues: Debris (copy), TweenService (copy), Kit (copy), v1 (copy), ScreenGui (ref)
    local v10 = Kit.frame(ScreenGui, {
        ZIndex = 50,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = p13 or v1,
        BackgroundTransparency = 1 - (p14 or 0.7)
    })

    v10.Interactable = false
    task.delay(0.05, function() -- line: 91
        -- upvalues: p15 (copy), v10 (copy), TweenService (copy)
        local v11 = p15 or 0.25
        local t5 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(v10, TweenInfo.new(v11, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()
    end)
    Debris:AddItem(v10, (p15 or 0.25) + 0.2)
end

function t1.fovPunch(p16, p17) -- line: 98
    -- upvalues: TweenService (copy), v3 (ref), tween (ref), t2 (ref)
    local CurrentCamera = workspace.CurrentCamera

    if t2 then
        return
    end

    if tween then
        tween:Cancel()
    end

    v3 = v3 or CurrentCamera.FieldOfView
    CurrentCamera.FieldOfView = math.max(20, v3 - p16)

    local v13 = p17 or 0.3
    local t6 = {
        FieldOfView = v3
    }
    local Back = Enum.EasingStyle.Back
    local tween2 = TweenService:Create(CurrentCamera, TweenInfo.new(v13, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6)

    tween2:Play()
    tween = tween2

    local tween3 = tween

    task.delay((p17 or 0.3) + 0.05, function() -- line: 110
        -- upvalues: tween3 (copy), v3 (ref), tween (ref)
        if tween == tween3 then
            tween = nil
            v3 = nil
        end
    end)
end

function t1.hitStop(p18) -- line: 119
    -- upvalues: RunService (copy)
    local CFrame = workspace.CurrentCamera.CFrame

    RunService:UnbindFromRenderStep("BossHitStop")
    RunService:BindToRenderStep("BossHitStop", Enum.RenderPriority.Camera.Value + 20, function() -- line: 123
        -- upvalues: CFrame (copy)
        workspace.CurrentCamera.CFrame = CFrame
    end)
    task.delay(p18, function() -- line: 126
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("BossHitStop")
    end)
end

function t1.stamp(p19, p20, p21, p22, p23) -- line: 132
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), Kit (copy), ScreenGui (ref)
    local v15 = Kit.frame(ScreenGui, {
        BackgroundTransparency = 1,
        ZIndex = 45,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, p22),
        Size = UDim2.fromOffset(1100, p21)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v15

    local v17 = Kit.text(v15, p19, {
        ZIndex = 46,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = p20,
        StrokeThickness = math.max(4, p21 / 12)
    })
    local v18 = UIUtil.scale or 1

    UIScale.Scale = v18 * 2.8
    v17.TextTransparency = 1

    local t8 = {
        TextTransparency = 0
    }

    TweenService:Create(v17, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t8):Play()

    local t9 = {
        Scale = v18 * 0.92
    }
    local Quad = Enum.EasingStyle.Quad
    local In = Enum.EasingDirection.In

    TweenService:Create(UIScale, TweenInfo.new(0.16, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t9):Play()
    task.delay(0.16, function() -- line: 142
        -- upvalues: p20 (copy), p21 (copy), v15 (copy), UIScale (copy), v18 (copy), TweenService (copy), Kit (copy)
        local t10 = {
            Scale = v18
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale, TweenInfo.new(0.25, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
        Kit.shake(v15, 10, 0.25)
        Kit.ring(v15, Vector2.new(550, p21 / 2), p20, 520)
    end)
    task.delay(p23 or 1.6, function() -- line: 147
        -- upvalues: UIScale (copy), v17 (copy), v18 (copy), TweenService (copy)
        local t11 = {
            TextTransparency = 1
        }

        TweenService:Create(v17, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()

        local UIStroke = v17:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            local t12 = {
                Transparency = 1
            }

            TweenService:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()
        end

        local t13 = {
            Scale = v18 * 1.3
        }

        TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t13):Play()
    end)
    Debris:AddItem(v15, (p23 or 1.6) + 0.4)

    return v17
end

local function shakeFrom(p24, p25, p26) -- line: 161
    -- upvalues: Settings (copy), LocalPlayer (copy)
    local v19 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v20 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v19 and v20 and Settings.get("Shake") == true then
        local v22 = p25 * math.clamp(1 - (v20.Position - p24).Magnitude / p26, 0.2, 1)

        task.spawn(function() -- line: 168
            -- upvalues: v22 (copy), v19 (copy)
            for i = 1, 14 do
                v19.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 2 * v22 * (1 - i / 15)
                task.wait(0.03)
            end

            v19.CameraOffset = Vector3.new(0, 0, 0)
        end)
    end
end

function t1.explosion(p27, p28, p29) -- line: 179
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), v1 (copy), Folder (ref), emit (copy), seq (copy), shakeFrom (copy)
    local t14 = {
        Transparency = 0.1,
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(4, 4, 4) * p28,
        CFrame = CFrame.new(p27),
        Color = v1
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v26, v27 in t14 do
        Part[v26] = v27
    end

    Part.Parent = Folder

    local t15 = {
        Size = Vector3.new(18, 18, 18) * p28
    }

    TweenService:Create(Part, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
    task.delay(0.05, function() -- line: 183
        -- upvalues: Part (copy), TweenService (copy)
        local t16 = {
            Transparency = 1
        }

        TweenService:Create(Part, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t16):Play()
    end)
    Debris:AddItem(Part, 0.4)

    local t17 = {
        Transparency = 0.05,
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(6, 6, 6) * p28,
        CFrame = CFrame.new(p27),
        Color = Color3.fromRGB(255, 170, 50)
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon

    for v28, v29 in t17 do
        Part2[v28] = v29
    end

    Part2.Parent = Folder

    local t18 = {
        Size = Vector3.new(24, 24, 24) * p28,
        Color = Color3.fromRGB(200, 40, 20)
    }

    TweenService:Create(Part2, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t18):Play()

    local t19 = {
        Transparency = 1
    }
    local Quad = Enum.EasingStyle.Quad
    local In = Enum.EasingDirection.In

    TweenService:Create(Part2, TweenInfo.new(0.6, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t19):Play()
    Debris:AddItem(Part2, 0.7)
    emit(p27, math.floor(math.min(p28, 2) * 22), {
        Texture = "rbxassetid://16676544947",
        LightEmission = 1,
        Drag = 4,
        Color = ColorSequence.new(Color3.fromRGB(255, 230, 140), Color3.fromRGB(255, 80, 20)),
        Size = seq(p28 * 5, p28 * 11, p28 * 4),
        Transparency = NumberSequence.new(0, 1),
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(p28 * 18, p28 * 45),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-90, 90)
    })
    emit(p27, math.floor(math.min(p28, 2) * 16), {
        Texture = "rbxassetid://16669188960",
        LightEmission = 0,
        LightInfluence = 0.6,
        Drag = 3,
        Color = ColorSequence.new(Color3.fromRGB(90, 80, 80), Color3.fromRGB(30, 25, 30)),
        Size = seq(p28 * 7, p28 * 15, p28 * 20),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.2, 2),
        Speed = NumberRange.new(p28 * 10, p28 * 25),
        Acceleration = Vector3.new(0, p28 * 8, 0),
        SpreadAngle = Vector2.new(180, 180),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-40, 40)
    })
    emit(p27, math.floor(math.min(p28, 2) * 40), {
        LightEmission = 1,
        Drag = 1.5,
        Acceleration = Vector3.new(0, -60, 0),
        Color = ColorSequence.new(v1, Color3.fromRGB(255, 200, 60)),
        Size = seq(p28 * 1.2, p28 * 0.8, 0),
        Lifetime = NumberRange.new(0.6, 1.1),
        Speed = NumberRange.new(p28 * 60, p28 * 110),
        SpreadAngle = Vector2.new(180, 180)
    })

    for _ = 1, math.floor(math.min(p28, 2) * 8) do
        local t21 = {
            Material = Enum.Material.SmoothPlastic,
            Size = Vector3.new(math.random(10, 22), math.random(10, 22), math.random(10, 22)) / 10 * p28,
            CFrame = CFrame.new(p27) * CFrame.Angles(math.random() * 6, math.random() * 6, math.random() * 6),
            Color = if math.random() < 0.5 then Color3.fromRGB(30, 70, 55) else Color3.fromRGB(255, 120, 40)
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon

        for v38, v39 in t21 do
            Part[v38] = v39
        end

        Part.Parent = Folder
        Part.Anchored = false
        Part.Massless = true
        Part.AssemblyLinearVelocity = Vector3.new(math.random() - 0.5, math.random() * 0.8 + 0.4, math.random() - 0.5).Unit * (50 + math.random() * 50) * math.sqrt(p28)
        Part.AssemblyAngularVelocity = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 20

        local t22 = {
            Transparency = 1,
            Size = Part.Size * 0.4
        }
        local Quad = Enum.EasingStyle.Quad
        local In = Enum.EasingDirection.In

        TweenService:Create(Part, TweenInfo.new(1.4, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t22):Play()
        Debris:AddItem(Part, 1.5)
    end

    for v46, v47 in { true, false } do
        emit(p27, 1, {
            Texture = "rbxassetid://8271495905",
            LightEmission = 1,
            Brightness = 2,
            Color = ColorSequence.new(if v46 == 1 then v1 else Color3.fromRGB(255, 220, 120)),
            Orientation = if v47 then Enum.ParticleOrientation.VelocityPerpendicular else Enum.ParticleOrientation.FacingCamera,
            EmissionDirection = Enum.NormalId.Top,
            Speed = NumberRange.new(0.01),
            Size = NumberSequence.new(p28 * 6, p28 * 60),
            Transparency = NumberSequence.new(0.1, 1),
            Lifetime = NumberRange.new(0.55)
        })
    end

    shakeFrom(p27, math.min(p28, 2) * 1.4, 500)

    if p29 == false then
        return
    end

    UIUtil.sound("BossExplosion", math.clamp(p28 * 0.3 + 0.7, 0.7, 1), 0.95 + math.random() * 0.1, 8)
end

function t1.eruption(p30) -- line: 269
    -- upvalues: Debris (copy), RunService (copy), TweenService (copy), UIUtil (copy), BossFx (copy), v1 (copy), v2 (copy), Folder (ref), emit (copy), seq (copy), shakeFrom (copy)
    local Y = p30.Y
    local t24 = {
        Size = Vector3.new(4, 20, 20),
        Transparency = 0.5,
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.SmoothPlastic,
        CFrame = CFrame.new(p30) * CFrame.Angles(0, 0, 1.5707963267948966),
        Color = Color3.fromRGB(150, 205, 240)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v49, v50 in t24 do
        Part[v49] = v50
    end

    Part.Parent = Folder

    local t25 = {
        Size = Vector3.new(70, 24, 24),
        CFrame = CFrame.new(p30 + Vector3.new(0, 35, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    }

    TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t25):Play()
    task.delay(0.3, function() -- line: 275
        -- upvalues: p30 (copy), Part (copy), TweenService (copy)
        local t26 = {
            Size = Vector3.new(8, 34, 34),
            Transparency = 1,
            CFrame = CFrame.new(p30 + Vector3.new(0, 4, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        }
        local Quad = Enum.EasingStyle.Quad
        local In = Enum.EasingDirection.In

        TweenService:Create(Part, TweenInfo.new(0.9, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t26):Play()
    end)
    Debris:AddItem(Part, 1.3)
    emit(p30, 140, {
        LightEmission = 0.2,
        Acceleration = Vector3.new(0, -75, 0),
        Color = ColorSequence.new(v1, Color3.fromRGB(150, 205, 240)),
        Size = seq(5, 4, 1.5),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.4, 2.2),
        Speed = NumberRange.new(50, 95),
        SpreadAngle = Vector2.new(14, 14),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360)
    })

    for i = 0, 7 do
        task.delay(i * 0.07, function() -- line: 292
            -- upvalues: p30 (copy), i (copy), BossFx (copy)
            local v51 = i / 8 * 3.141592653589793 * 2

            BossFx.splash(p30 + Vector3.new(math.cos(v51) * 16, 1, math.sin(v51) * 16), 18)
        end)
    end

    BossFx.splash(p30 + Vector3.new(0, 2, 0), 34)

    for i = 0, 2 do
        task.delay(i * 0.4 + 0.15, function() -- line: 300
            -- upvalues: p30 (copy), Y (copy), i (copy), RunService (copy), v1 (copy), v2 (copy), Folder (ref), seq (copy)
            local t27 = {}

            for i = 1, 28 do
                local t28 = {
                    Size = Vector3.new(4, 4, 2),
                    Transparency = 0.45,
                    Material = Enum.Material.SmoothPlastic,
                    Color = v2
                }
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Material = Enum.Material.Neon

                for v54, v55 in t28 do
                    Part[v54] = v55
                end

                Part.Parent = Folder

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Color = ColorSequence.new(v2, v1)
                ParticleEmitter.LightEmission = 0.3
                ParticleEmitter.LightInfluence = 0
                ParticleEmitter.Size = seq(2.5, 1.6, 0.4)
                ParticleEmitter.Transparency = NumberSequence.new(0.2, 1)
                ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.7)
                ParticleEmitter.Speed = NumberRange.new(10, 18)
                ParticleEmitter.SpreadAngle = Vector2.new(25, 25)
                ParticleEmitter.Acceleration = Vector3.new(0, -40, 0)
                ParticleEmitter.EmissionDirection = Enum.NormalId.Top
                ParticleEmitter.Rate = 14
                ParticleEmitter.Parent = Part
                t27[i] = Part
            end

            local elapsed = os.clock()
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 323
                -- upvalues: t27 (copy), elapsed (copy), connection (ref), p30 (copy), Y (copy), i (copy)
                local v56 = (os.clock() - elapsed) / 3.2

                if v56 >= 1 then
                    connection:Disconnect()

                    for _, v57 in t27 do
                        v57:Destroy()
                    end
                else
                    local v58 = 12 + (1 - (1 - v56) ^ 2) * 190
                    local v59 = (1 - v56) * (4.5 - i) + 0.4

                    for v60, v61 in t27 do
                        local v62 = v60 / 28 * 3.141592653589793 * 2
                        local v66 = Vector3.new(p30.X + math.cos(v62) * v58, Y + v59 / 2 - 0.4, p30.Z + math.sin(v62) * v58)

                        v61.Size = Vector3.new(v58 * 2 * 3.141592653589793 / 28 + 1.5, v59, 2.5 + v59 * 0.3)
                        v61.CFrame = CFrame.lookAt(v66, (Vector3.new(p30.X, v66.Y, p30.Z)))
                        v61.Transparency = 0.45 + v56 * 0.55
                    end
                end
            end)
        end)
    end

    local t29 = {
        Size = Vector3.new(60, 1, 60),
        Transparency = 1,
        CFrame = CFrame.new(p30 + Vector3.new(0, 70, 0))
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon

    for v69, v70 in t29 do
        Part2[v69] = v70
    end

    Part2.Parent = Folder

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(v2)
    ParticleEmitter.LightEmission = 0.2
    ParticleEmitter.Size = NumberSequence.new(0.9, 0.5)
    ParticleEmitter.Transparency = NumberSequence.new(0.2, 0.6)
    ParticleEmitter.Lifetime = NumberRange.new(1.2, 1.6)
    ParticleEmitter.Speed = NumberRange.new(0)
    ParticleEmitter.Acceleration = Vector3.new(0, -60, 0)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Rate = 260
    ParticleEmitter.Parent = Part2
    task.delay(1.6, function() -- line: 359
        -- upvalues: ParticleEmitter (copy)
        ParticleEmitter.Enabled = false
    end)
    Debris:AddItem(Part2, 3.5)
    emit(p30 + Vector3.new(0, 8, 0), 14, {
        Texture = "rbxassetid://16669188960",
        LightEmission = 0.3,
        Drag = 2,
        Color = ColorSequence.new(v1, v2),
        Size = seq(16, 30, 38),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.5, 2.4),
        Speed = NumberRange.new(10, 30),
        SpreadAngle = Vector2.new(70, 70),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360)
    })
    shakeFrom(p30, 1.3, 400)
    UIUtil.sound("BigSplash", 1, 0.75)
    task.delay(0.25, UIUtil.sound, "Splash", 1, 0.6)
    task.delay(0.6, UIUtil.sound, "Splash", 0.8, 0.8)
end

local function headOf(p31) -- line: 384
    return (p31:FindFirstChild("Nessie_Head", true))
end

function t1.killCam(p32, p33) -- line: 390
    -- upvalues: TweenService (copy), Kit (copy), Controls (copy), ScreenGui (ref), v3 (ref), tween (ref), t2 (ref)
    local v71 = p32:FindFirstChild("Nessie_Head", true)
    local CurrentCamera = workspace.CurrentCamera

    if not v71 then
        return
    end

    if tween then
        tween:Cancel()
        tween = nil
    end

    if v3 then
        CurrentCamera.FieldOfView = v3
        v3 = nil
    end

    local CFramePosition = CurrentCamera.CFrame.Position
    local v74 = Vector3.new(CFramePosition.X - v71.Position.X, 0, CFramePosition.Z - v71.Position.Z)
    local v75 = if v74.Magnitude > 1 then v74.Unit else Vector3.new(1, 0, 0)

    t2 = {
        model = p32,
        untilAt = os.clock() + p33,
        startedAt = os.clock(),
        side = v75,
        fov = CurrentCamera.FieldOfView,
        focus = v71.Position
    }
    Controls.lock("BossKillCam")
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    for _, v76 in { true, false } do
        local v77 = Kit.frame(ScreenGui, {
            Name = "KillBar",
            ZIndex = 40,
            AnchorPoint = Vector2.new(0, v76 and 1 or 0),
            Position = UDim2.fromScale(0, v76 and 0 or 1),
            Size = UDim2.fromScale(1, 0.1),
            BackgroundColor3 = Color3.new(0, 0, 0)
        })
        local t31 = {
            AnchorPoint = Vector2.new(0, v76 and 0 or 1)
        }

        TweenService:Create(v77, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t31):Play()
    end
end

local function updateKillCam() -- line: 417
    -- upvalues: Debris (copy), TweenService (copy), Controls (copy), ScreenGui (ref), t2 (ref)
    local t32 = t2

    if not t32 then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local v78 = os.clock() - t32.startedAt
    local v79 = t32.model.Parent and t32.model:FindFirstChild("Nessie_Head", true)

    if not (os.clock() >= t32.untilAt) and v79 then
        t32.focus = t32.focus:Lerp(v79.Position, 0.15)

        local v80 = v78 * 0.12
        local v81 = CFrame.Angles(0, v80, 0) * t32.side
        local v84 = 95 - math.min(v78, 2.6) * 12 + math.max(v78 - 2.6, 0) * 22
        local v87 = t32.focus + v81 * v84 + Vector3.new(0, 14 - math.min(v78, 2.6) * 3, 0)

        CurrentCamera.CFrame = CFrame.lookAt(v87, t32.focus)
        CurrentCamera.FieldOfView = t32.fov - math.min(v78, 2.6) * 4
    else
        t2 = nil
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = t32.fov
        Controls.unlock("BossKillCam")

        for _, child in ScreenGui:GetChildren() do
            if child.Name == "KillBar" then
                local v88 = child.AnchorPoint.Y < 0.5
                local t33 = {
                    AnchorPoint = Vector2.new(0, v88 and 1 or 0)
                }

                TweenService:Create(child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t33):Play()
                Debris:AddItem(child, 0.4)
            end
        end
    end
end

function t1.finalBlow(p34, p35, p36) -- line: 450
    -- upvalues: UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (copy)
    local v89 = p36

    t1.hitStop(0.22)
    t1.impactFrame(v1, 0.95, 0.5)

    local v90 = p34:FindFirstChild("Nessie_Head", true)

    if v90 then
        t1.explosion(v90.Position, 1.4)
    end

    UIUtil.sound("SubBoom", 1, 0.8)
    UIUtil.sound("BossScreech", 0.5, 0.85, 8)
    v89 = p36 or workspace:GetAttribute("BossFinalBlow")
    task.delay(0.25, function() -- line: 460
        -- upvalues: v89 (ref), p34 (copy), p35 (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (copy)
        t1.stamp("FINAL BLOW!", Color3.fromRGB(255, 225, 90), 120, 0.3, 2.2)

        if type(v89) == "string" then
            task.delay(0.2, function() -- line: 463
                -- upvalues: v89 (ref), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (copy)
                local v92 = v89 == LocalPlayer.DisplayName
                local stamp = t1.stamp
                local v94 = if v92 then "by YOU! +50% cash" else ("by %*"):format(v89)
                local v93 = if v92 then Color3.fromRGB(120, 255, 90) else v1

                stamp(v94, v93, 52, 0.4, 2)
                UIUtil.sound("GoodCast", 0.8, 1.2)
            end)
        end

        t1.killCam(p34, p35)
    end)
end

function t1.deathChain(p37) -- line: 474
    -- upvalues: UIUtil (copy), t1 (copy), v1 (copy)
    local t34 = {}

    for _, descendant in p37:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            table.insert(t34, descendant)
        end
    end

    if #t34 == 0 then
        return
    end

    local n1 = 0

    for i = 1, 9 do
        n1 += 0.24 - i * 0.017
        task.delay(n1, function() -- line: 487
            -- upvalues: t34 (copy), i (copy), t1 (copy), v1 (copy)
            local v95 = t34[math.random(1, #t34)]

            if v95.Parent then
                local v99 = v95.Position + Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * v95.Size * 0.6

                t1.explosion(v99, 0.6 + math.random() * 0.3, i % 2 == 1)
                t1.impactFrame(v1, 0.25, 0.15)
            end
        end)
    end

    task.delay(n1 + 0.25, function() -- line: 496
        -- upvalues: p37 (copy), UIUtil (copy), t1 (copy), v1 (copy)
        local v100 = p37:FindFirstChild("Nessie_Head", true)
        local BoundingBox, BoundingBox2 = p37:GetBoundingBox()
        local v101 = if v100 then v100.Position:Lerp(BoundingBox.Position, 0.5) else BoundingBox.Position

        t1.hitStop(0.15)
        t1.impactFrame(v1, 1, 0.6)
        t1.explosion(v101, (math.clamp(BoundingBox2.Magnitude / 60, 2, 3.5)))
        UIUtil.sound("SubBoom", 1, 0.6)
    end)
end

function t1.isKillCam() -- line: 507
    -- upvalues: t2 (ref)
    return t2 ~= nil
end

function t1.init() -- line: 511
    -- upvalues: RunService (copy), LocalPlayer (copy), ScreenGui (ref), Folder (ref), updateKillCam (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BossJuice"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.DisplayOrder = 25
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    Folder = Instance.new("Folder")
    Folder.Name = "BossJuiceFx"
    Folder.Parent = workspace
    RunService:BindToRenderStep("BossKillCam", Enum.RenderPriority.Camera.Value + 15, updateKillCam)
end

return t1

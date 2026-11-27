-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local BossFx = require(script.Parent.BossFx)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(120, 255, 70)
local v2 = Color3.new(1, 1, 1)
local Folder

local function now() -- line: 27
    return workspace:GetServerTimeNow()
end

local function part(p1) -- line: 31
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v3, v4 in p1 do
        Part[v3] = v4
    end

    Part.Parent = Folder

    return Part
end

local function tween(p2, p3, p4, p5) -- line: 42
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p2, TweenInfo.new(p3, p5 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p4)

    tween:Play()

    return tween
end

local function emitter(p6, p7) -- line: 48
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v5, v6 in p7 do
        ParticleEmitter[v5] = v6
    end

    ParticleEmitter.Parent = p6

    return ParticleEmitter
end

local function burst(p8, p9, p10) -- line: 58
    -- upvalues: Debris (copy), Folder (ref)
    local t2 = {
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new(p8)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v7, v8 in t2 do
        Part[v7] = v8
    end

    Part.Parent = Folder
    p10.Rate = 0

    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v9, v10 in p10 do
        ParticleEmitter[v9] = v10
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p9)
    Debris:AddItem(Part, 3)
end

local function cameraShake(p11, p12) -- line: 66
    -- upvalues: Settings (copy), LocalPlayer (copy)
    local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v11 and Settings.get("Shake") and not (p11 <= 0.02) then
        task.spawn(function() -- line: 71
            -- upvalues: p11 (copy), p12 (copy), v11 (copy)
            local v13 = math.floor((p12 or 0.3) / 0.03)

            for i = 1, v13 do
                v11.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * p11 * (1 - i / (v13 + 1))
                task.wait(0.03)
            end

            v11.CameraOffset = Vector3.new(0, 0, 0)
        end)
    end
end

local function shakeFrom(p13, p14, p15) -- line: 82
    -- upvalues: LocalPlayer (copy), cameraShake (copy)
    local v17 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v17 then
        cameraShake(p14 * math.clamp(1 - (v17.Position - p13).Magnitude / p15, 0.15, 1), 0.45)
    end
end

local function waterY() -- line: 89
    local BossArena = workspace:FindFirstChild("BossArena")

    return BossArena and BossArena:GetAttribute("WaterY") or 0
end

local function bossModel() -- line: 94
    return if workspace:FindFirstChild("BossArena") then require(script.Parent.BossSkin).monster() else nil
end

local function headOf(p16) -- line: 100
    return p16 and p16:FindFirstChild("Nessie_Head", true)
end

local function mouthOf(p17) -- line: 105
    local v19 = p17 and p17:FindFirstChild("Nessie_Head", true)
    local v20 = p17:FindFirstChild("Nessie_Jaw", true)

    if not v19 then
        return nil
    end

    local ZVector = p17:GetPivot().ZVector
    local Position = if v20 then v20.Position else v19.Position
    local Z = if v20 then v20.Size.Z else v19.Size.Z

    return Position + ZVector * (Z * 0.5)
end

local function ring(p18, p19, p20, p21, p22, p23, p24) -- line: 117
    -- upvalues: Debris (copy), TweenService (copy), Folder (ref)
    local t3 = {
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.4, p20, p20),
        CFrame = CFrame.lookAt(p18, p18 + p19) * CFrame.Angles(0, 1.5707963267948966, 0),
        Color = p23,
        Transparency = p24 or 0.35
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v21, v22 in t3 do
        Part[v21] = v22
    end

    Part.Parent = Folder

    local t4 = {
        Transparency = 1,
        Size = Vector3.new(0.2, p21, p21)
    }

    TweenService:Create(Part, TweenInfo.new(p22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t4):Play()
    Debris:AddItem(Part, p22 + 0.1)
end

local function roar(p25, _) -- line: 132
    -- upvalues: UIUtil (copy), LocalPlayer (copy), t1 (copy), v2 (copy), burst (copy), cameraShake (copy), mouthOf (copy), ring (copy)
    local v23 = p25 and p25:FindFirstChild("Nessie_Head", true)

    if not v23 then
        return
    end

    local v24 = mouthOf(p25) or v23.Position
    local ZVector = p25:GetPivot().ZVector

    for i = 0, 2 do
        task.delay(i * 0.16, function() -- line: 140
            -- upvalues: ZVector (copy), i (copy), v24 (copy), v2 (copy), ring (copy)
            ring(v24 + ZVector * (i * 2 + 2), ZVector, 6, 70, 0.7, v2, 0.55)
        end)
    end

    burst(v24, 30, {
        Color = ColorSequence.new(Color3.fromRGB(220, 240, 255)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
        }),
        Transparency = NumberSequence.new(0.3, 1),
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(30, 55),
        SpreadAngle = Vector2.new(25, 25),
        EmissionDirection = Enum.NormalId.Front
    })
    t1.onRoar()
    UIUtil.sound("BossRoar", 0.85, 1)

    local Position = v23.Position
    local v25 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v25 then
        cameraShake(math.clamp(1 - (v25.Position - Position).Magnitude / 260, 0.15, 1) * 0.5, 0.45)
    end
end

local function spit(p27, p28, p29) -- line: 159
    -- upvalues: Debris (copy), RunService (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), Folder (ref), burst (copy), cameraShake (copy), mouthOf (copy)
    local v27 = mouthOf(p27)

    if not v27 then
        return
    end

    local t5 = {
        Size = Vector3.new(1, 1, 1),
        Shape = Enum.PartType.Ball,
        CFrame = CFrame.new(v27),
        Color = v1
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v28, v29 in t5 do
        Part[v28] = v29
    end

    Part.Parent = Folder

    local t6 = {
        Size = Vector3.new(5, 5, 5)
    }

    TweenService:Create(Part, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6):Play()
    UIUtil.sound("Spit", 0.7, 0.8)
    task.delay(0.18, function() -- line: 168
        -- upvalues: p28 (copy), p29 (copy), Part (copy), Debris (copy), RunService (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), Folder (ref), burst (copy), cameraShake (copy)
        local PartPosition = Part.Position

        Part:Destroy()

        local t7 = {
            Size = Vector3.new(4, 4, 4),
            Shape = Enum.PartType.Ball,
            CFrame = CFrame.new(PartPosition),
            Color = v1
        }
        local Part2 = Instance.new("Part")

        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.CanTouch = false
        Part2.CastShadow = false
        Part2.Material = Enum.Material.Neon

        for v30, v31 in t7 do
            Part2[v30] = v31
        end

        Part2.Parent = Folder

        local Attachment = Instance.new("Attachment")
        local Attachment2 = Instance.new("Attachment")

        Attachment.Position = Vector3.new(0, 1.5, 0)
        Attachment2.Position = Vector3.new(0, -1.5, 0)
        Attachment.Parent = Part2
        Attachment2.Parent = Part2

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Color = ColorSequence.new(v1, Color3.fromRGB(40, 120, 20))
        Trail.Transparency = NumberSequence.new(0.1, 1)
        Trail.Lifetime = 0.35
        Trail.LightEmission = 1
        Trail.Parent = Part2

        local t8 = {
            LightEmission = 1,
            Rate = 60,
            Color = ColorSequence.new(v1),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.4),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.3, 0.5),
            Speed = NumberRange.new(1, 3),
            SpreadAngle = Vector2.new(180, 180)
        }
        local ParticleEmitter = Instance.new("ParticleEmitter")

        for v32, v33 in t8 do
            ParticleEmitter[v32] = v33
        end

        ParticleEmitter.Parent = Part2

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v1
        PointLight.Range = 14
        PointLight.Brightness = 2
        PointLight.Parent = Part2

        local ServerTimeNow = workspace:GetServerTimeNow()
        local v35 = math.max(p29 - ServerTimeNow, 0.25)
        local v37 = math.max(20, (p28 - PartPosition).Magnitude * 0.25)
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 198
            -- upvalues: PartPosition (copy), Part2 (copy), ServerTimeNow (copy), v35 (copy), v37 (copy), connection (ref), p28 (copy), Debris (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), Folder (ref), burst (copy), cameraShake (copy)
            local v39 = math.clamp((workspace:GetServerTimeNow() - ServerTimeNow) / v35, 0, 1)

            Part2.CFrame = CFrame.new(PartPosition:Lerp(p28, v39) + Vector3.new(0, math.sin(v39 * 3.141592653589793) * v37, 0))

            if not (v39 >= 1) then
                return
            end

            connection:Disconnect()
            Part2:Destroy()
            burst(p28 + Vector3.new(0, 1, 0), 40, {
                LightEmission = 0.6,
                Acceleration = Vector3.new(0, -60, 0),
                Color = ColorSequence.new(v1, Color3.fromRGB(60, 160, 30)),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1.6),
                    NumberSequenceKeypoint.new(1, 0.3)
                }),
                Transparency = NumberSequence.new(0, 1),
                Lifetime = NumberRange.new(0.4, 0.8),
                Speed = NumberRange.new(14, 28),
                SpreadAngle = Vector2.new(70, 70),
                EmissionDirection = Enum.NormalId.Top
            })

            local t9 = {
                Size = Vector3.new(0.1, 4, 4),
                Transparency = 0.25,
                Shape = Enum.PartType.Cylinder,
                CFrame = CFrame.new(p28 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
                Color = v1
            }
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon

            for v43, v44 in t9 do
                Part[v43] = v44
            end

            Part.Parent = Folder

            local t10 = {
                Size = Vector3.new(0.1, 11, 11)
            }

            TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
            task.delay(0.8, function() -- line: 218
                -- upvalues: Part (copy), TweenService (copy)
                local t11 = {
                    Transparency = 1
                }

                TweenService:Create(Part, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
            end)

            local t12 = {
                Rate = 25,
                Color = ColorSequence.new(Color3.fromRGB(200, 255, 160)),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.8),
                    NumberSequenceKeypoint.new(1, 2.5)
                }),
                Transparency = NumberSequence.new(0.5, 1),
                Lifetime = NumberRange.new(0.6, 1),
                Speed = NumberRange.new(2, 4),
                EmissionDirection = Enum.NormalId.Right,
                Shape = Enum.ParticleEmitterShape.Disc
            }
            local ParticleEmitter = Instance.new("ParticleEmitter")

            for v45, v46 in t12 do
                ParticleEmitter[v45] = v46
            end

            ParticleEmitter.Parent = Part
            Debris:AddItem(Part, 2.2)
            UIUtil.sound("Splat", 0.9, 0.8)

            local v47 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if v47 then
                cameraShake(math.clamp(1 - (v47.Position - p28).Magnitude / 30, 0.15, 1) * 0.5, 0.45)
            end
        end)
    end)
end

local function splinters(p30, p31) -- line: 240
    -- upvalues: Debris (copy), Folder (ref)
    for _ = 1, p31 do
        local Part = Instance.new("Part")

        Part.Size = Vector3.new(math.random() * 0.8 + 0.4, 0.3, math.random() * 1.6 + 0.6)
        Part.Color = Color3.fromRGB(150, 100, 60)
        Part.Material = Enum.Material.Wood
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CFrame = CFrame.new(p30 + Vector3.new(math.random() - 0.5, 0.5, math.random() - 0.5) * 3) * CFrame.Angles(math.random() * 6, math.random() * 6, 0)
        Part.AssemblyLinearVelocity = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5) * 50 + Vector3.new(0, 35 + math.random() * 25, 0)
        Part.AssemblyAngularVelocity = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 30
        Part.Parent = Folder
        Debris:AddItem(Part, 2)
    end
end

local function slam(p32, p33, p34) -- line: 256
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), Folder (ref), cameraShake (copy), ring (copy), splinters (copy)
    task.delay(math.max(0, p34 - workspace:GetServerTimeNow() - 0.3), function() -- line: 258
        -- upvalues: p32 (copy), p33 (copy), Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), Folder (ref), cameraShake (copy), ring (copy), splinters (copy)
        local t13 = {
            Transparency = 0.3,
            Shape = Enum.PartType.Cylinder,
            Size = Vector3.new(60, p33 * 1.3, p33 * 1.3),
            CFrame = CFrame.new(p32 + Vector3.new(0, 90, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
            Color = Color3.fromRGB(110, 190, 240),
            Material = Enum.Material.Glass
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon

        for v63, v64 in t13 do
            Part[v63] = v64
        end

        Part.Parent = Folder

        local t14 = {
            CFrame = CFrame.new(p32 + Vector3.new(0, 30, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        }
        local Quad = Enum.EasingStyle.Quad

        TweenService:Create(Part, TweenInfo.new(0.3, Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()
        task.delay(0.3, function() -- line: 268
            -- upvalues: Part (copy), p32 (copy), p33 (copy), Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), cameraShake (copy), ring (copy), splinters (copy)
            local t15 = {
                Transparency = 1,
                Size = Vector3.new(10, p33 * 2.6, p33 * 2.6),
                CFrame = CFrame.new(p32 + Vector3.new(0, 5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
            }

            TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
            Debris:AddItem(Part, 0.4)
            ring(p32 + Vector3.new(0, 0.6, 0), Vector3.new(0, 1, 0), p33, p33 * 3.2, 0.55, v2, 0.2)
            ring(p32 + Vector3.new(0, 0.4, 0), Vector3.new(0, 1, 0), p33 * 0.5, p33 * 2.2, 0.4, Color3.fromRGB(140, 210, 255), 0.3)
            BossFx.splash(p32 + Vector3.new(0, 1, 0), p33 * 1.6)
            splinters(p32, 10)
            UIUtil.sound("BigSplash", 1, 0.55)
            UIUtil.sound("SubBoom", 0.8, 0.5)

            local v67 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if not v67 then
                return
            end

            cameraShake(math.clamp(1 - (v67.Position - p32).Magnitude / 60, 0.15, 1) * 1.6, 0.45)
        end)
    end)
end

local function lunge(p35, p36, p37, p38) -- line: 283
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v2 (copy), Folder (ref), burst (copy), cameraShake (copy)
    task.delay(math.max(0, p38 - workspace:GetServerTimeNow()), function() -- line: 284
        -- upvalues: p35 (copy), p36 (copy), p37 (copy), Debris (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v2 (copy), Folder (ref), burst (copy), cameraShake (copy)
        local Magnitude = (p36 - p35).Magnitude
        local t16 = {
            Transparency = 0.2,
            Size = Vector3.new(p37 * 0.9, 0.4, Magnitude),
            CFrame = CFrame.lookAt((p35 + p36) / 2 + Vector3.new(0, 1, 0), p36 + Vector3.new(0, 1, 0)),
            Color = v2
        }
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon

        for v71, v72 in t16 do
            Part[v71] = v72
        end

        Part.Parent = Folder

        local t17 = {
            Transparency = 1,
            Size = Vector3.new(p37 * 1.4, 0.2, Magnitude)
        }

        TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t17):Play()
        Debris:AddItem(Part, 0.45)

        for i = 0, 6 do
            task.delay(i * 0.03, function() -- line: 290
                -- upvalues: i (copy), p35 (copy), p36 (copy), v2 (copy), burst (copy)
                burst(p35:Lerp(p36, i / 6) + Vector3.new(0, 1, 0), 12, {
                    Acceleration = Vector3.new(0, -80, 0),
                    Color = ColorSequence.new(Color3.fromRGB(150, 210, 250), v2),
                    Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 2.5),
                        NumberSequenceKeypoint.new(1, 0.6)
                    }),
                    Transparency = NumberSequence.new(0.1, 1),
                    Lifetime = NumberRange.new(0.5, 0.8),
                    Speed = NumberRange.new(20, 40),
                    SpreadAngle = Vector2.new(30, 30),
                    EmissionDirection = Enum.NormalId.Top
                })
            end)
        end

        UIUtil.sound("Whoosh", 0.9, 0.5)
        UIUtil.sound("SubBoom", 0.7, 0.7)

        local v75 = (p35 + p36) / 2
        local v76 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not v76 then
            return
        end

        cameraShake(math.clamp(1 - (v76.Position - v75).Magnitude / 50, 0.15, 1) * 1.2, 0.45)
    end)
end

function t1.attack(p39) -- line: 311
    -- upvalues: UIUtil (copy), roar (copy)
    local v78 = if workspace:FindFirstChild("BossArena") then require(script.Parent.BossSkin).monster() else nil

    if v78 and type(p39) == "table" then
        local Kind = p39.Kind

        roar(v78, if Kind == "Spit" then 1 elseif Kind == "Wave" then 0.8 else 0.9)

        if Kind == "Wave" then
            task.delay(0.6, function() -- line: 320
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Rumble", 0.7, 1.2, 4)
            end)
        end
    end
end

function t1.warn(p40) -- line: 327
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), Folder (ref), burst (copy), cameraShake (copy), ring (copy), spit (copy), splinters (copy)
    local v80 = if workspace:FindFirstChild("BossArena") then require(script.Parent.BossSkin).monster() else nil

    if v80 and type(p40) == "table" then
        if p40.Kind == "Spit" then
            spit(v80, p40.At, p40.HitAt)
        elseif p40.Kind == "Slam" then
            local At, Radius, HitAt = p40.At, p40.Radius, p40.HitAt

            task.delay(math.max(0, HitAt - workspace:GetServerTimeNow() - 0.3), function() -- line: 258
                -- upvalues: At (copy), Radius (copy), Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), Folder (ref), cameraShake (copy), ring (copy), splinters (copy)
                local t18 = {
                    Transparency = 0.3,
                    Shape = Enum.PartType.Cylinder,
                    Size = Vector3.new(60, Radius * 1.3, Radius * 1.3),
                    CFrame = CFrame.new(At + Vector3.new(0, 90, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
                    Color = Color3.fromRGB(110, 190, 240),
                    Material = Enum.Material.Glass
                }
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Material = Enum.Material.Neon

                for v84, v85 in t18 do
                    Part[v84] = v85
                end

                Part.Parent = Folder

                local t19 = {
                    CFrame = CFrame.new(At + Vector3.new(0, 30, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                }
                local Quad = Enum.EasingStyle.Quad

                TweenService:Create(Part, TweenInfo.new(0.3, Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t19):Play()
                task.delay(0.3, function() -- line: 268
                    -- upvalues: At (copy), Radius (copy), Debris (copy), TweenService (copy), UIUtil (copy), BossFx (copy), LocalPlayer (copy), v2 (copy), cameraShake (copy), ring (copy), splinters (copy), Part (copy)
                    local t20 = {
                        Transparency = 1,
                        Size = Vector3.new(10, Radius * 2.6, Radius * 2.6),
                        CFrame = CFrame.new(At + Vector3.new(0, 5, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                    }

                    TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t20):Play()
                    Debris:AddItem(Part, 0.4)
                    ring(At + Vector3.new(0, 0.6, 0), Vector3.new(0, 1, 0), Radius, Radius * 3.2, 0.55, v2, 0.2)
                    ring(At + Vector3.new(0, 0.4, 0), Vector3.new(0, 1, 0), Radius * 0.5, Radius * 2.2, 0.4, Color3.fromRGB(140, 210, 255), 0.3)
                    BossFx.splash(At + Vector3.new(0, 1, 0), Radius * 1.6)
                    splinters(At, 10)
                    UIUtil.sound("BigSplash", 1, 0.55)
                    UIUtil.sound("SubBoom", 0.8, 0.5)

                    local v88 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if not v88 then
                        return
                    end

                    cameraShake(math.clamp(1 - (v88.Position - At).Magnitude / 60, 0.15, 1) * 1.6, 0.45)
                end)
            end)
        elseif p40.Kind == "Lunge" then
            local From, To, Width, HitAt = p40.From, p40.To, p40.Width, p40.HitAt

            task.delay(math.max(0, HitAt - workspace:GetServerTimeNow()), function() -- line: 284
                -- upvalues: From (copy), To (copy), Width (copy), Debris (copy), TweenService (copy), UIUtil (copy), LocalPlayer (copy), v2 (copy), Folder (ref), burst (copy), cameraShake (copy)
                local Magnitude = (To - From).Magnitude
                local t21 = {
                    Transparency = 0.2,
                    Size = Vector3.new(Width * 0.9, 0.4, Magnitude),
                    CFrame = CFrame.lookAt((From + To) / 2 + Vector3.new(0, 1, 0), To + Vector3.new(0, 1, 0)),
                    Color = v2
                }
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Material = Enum.Material.Neon

                for v92, v93 in t21 do
                    Part[v92] = v93
                end

                Part.Parent = Folder

                local t22 = {
                    Transparency = 1,
                    Size = Vector3.new(Width * 1.4, 0.2, Magnitude)
                }

                TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t22):Play()
                Debris:AddItem(Part, 0.45)

                for i = 0, 6 do
                    task.delay(i * 0.03, function() -- line: 290
                        -- upvalues: From (copy), To (copy), v2 (copy), burst (copy), i (copy)
                        burst(From:Lerp(To, i / 6) + Vector3.new(0, 1, 0), 12, {
                            Acceleration = Vector3.new(0, -80, 0),
                            Color = ColorSequence.new(Color3.fromRGB(150, 210, 250), v2),
                            Size = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 2.5),
                                NumberSequenceKeypoint.new(1, 0.6)
                            }),
                            Transparency = NumberSequence.new(0.1, 1),
                            Lifetime = NumberRange.new(0.5, 0.8),
                            Speed = NumberRange.new(20, 40),
                            SpreadAngle = Vector2.new(30, 30),
                            EmissionDirection = Enum.NormalId.Top
                        })
                    end)
                end

                UIUtil.sound("Whoosh", 0.9, 0.5)
                UIUtil.sound("SubBoom", 0.7, 0.7)

                local v96 = (From + To) / 2
                local v97 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if not v97 then
                    return
                end

                cameraShake(math.clamp(1 - (v97.Position - v96).Magnitude / 50, 0.15, 1) * 1.2, 0.45)
            end)
        elseif p40.Kind == "Wave" then
            task.delay(math.max(0, p40.StartAt - workspace:GetServerTimeNow()), function() -- line: 339
                -- upvalues: v80 (copy), UIUtil (copy), BossFx (copy)
                UIUtil.sound("BigSplash", 1, 0.5)

                local v101 = v80 and v80:FindFirstChild("Nessie_Head", true)

                if not v101 then
                    return
                end

                local splash = BossFx.splash
                local X = v101.Position.X
                local BossArena = workspace:FindFirstChild("BossArena")

                splash(Vector3.new(X, (BossArena and BossArena:GetAttribute("WaterY") or 0) + 1, v101.Position.Z), 30)
            end)
        end
    end
end

function t1.onRoar() -- line: 349
end

function t1.clear() -- line: 351
    -- upvalues: Folder (ref)
    for _, child in Folder:GetChildren() do
        if not child:IsA("Highlight") then
            child:Destroy()
        end
    end
end

function t1.init() -- line: 359
    -- upvalues: Folder (ref)
    Folder = Instance.new("Folder")
    Folder.Name = "BossAttackFx"
    Folder.Parent = workspace
end

t1.kit = {
    part = part,
    tween = tween,
    emitter = emitter,
    burst = burst,
    ring = ring,
    headOf = headOf,
    waterY = waterY,
    roar = roar,
    shakeFrom = shakeFrom,
    folder = function() -- folder | line: 375
        -- upvalues: Folder (ref)
        return Folder
    end
}

return t1

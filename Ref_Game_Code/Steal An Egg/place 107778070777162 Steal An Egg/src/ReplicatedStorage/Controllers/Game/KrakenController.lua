-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local KrakenRig = require(ReplicatedStorage.Shared.Modules.KrakenRig)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    3, 5, 8
}
local t2 = {
    2, 3, 4.5
}
local Timing, Raise = KrakenRig.Timing, KrakenRig.Raise
local v1 = Timing.Windup + Timing.Hold
local v2 = v1 + Timing.Strike
local v3 = v2 + Timing.Settle
local v4 = v3 + Timing.Down
local v5 = v4 + Timing.Recover
local v6 = Color3.fromRGB(255, 45, 45)
local t3 = {
    5, 16
}
local DrillaWarn = ReplicatedStorage.Assets.MountRace.PowerUps.Sounds.DrillaWarn
local v7 = Color3.fromRGB(214, 240, 255)
local v8 = Color3.fromRGB(245, 252, 255)
local v9 = Color3.fromRGB(196, 186, 168)
local t4 = {
    {
        Name = "Column",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Count = 34,
        Spread = 11,
        Acceleration = -150,
        Drag = 0.9,
        Flat = false,
        Light = 0.15,
        Delay = 0,
        Lifetime = NumberRange.new(1.1, 1.6),
        Speed = NumberRange.new(120, 210),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 22),
            NumberSequenceKeypoint.new(0.4, 46),
            NumberSequenceKeypoint.new(1, 64)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.55, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v8
    },
    {
        Name = "Droplets",
        Texture = "rbxasset://textures/particles/explosion01_core_main.dds",
        Count = 70,
        Spread = 42,
        Acceleration = -196,
        Drag = 0.2,
        Flat = false,
        Light = 0.3,
        Delay = 0,
        Lifetime = NumberRange.new(1.4, 2.1),
        Speed = NumberRange.new(80, 175),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 5),
            NumberSequenceKeypoint.new(1, 2.5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v7
    },
    {
        Name = "Ring",
        Texture = "rbxasset://textures/particles/explosion01_shockwave_main.dds",
        Count = 1,
        Spread = 0,
        Acceleration = 0,
        Drag = 0,
        Flat = true,
        Light = 0.4,
        Delay = 0,
        Lifetime = NumberRange.new(1.2, 1.2),
        Speed = NumberRange.new(0.01, 0.01),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 30),
            NumberSequenceKeypoint.new(0.35, 170),
            NumberSequenceKeypoint.new(1, 260)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v8
    },
    {
        Name = "Echo",
        Texture = "rbxasset://textures/particles/explosion01_shockwave_main.dds",
        Count = 1,
        Spread = 0,
        Acceleration = 0,
        Drag = 0,
        Flat = true,
        Light = 0.2,
        Delay = 0.28,
        Lifetime = NumberRange.new(1.5, 1.5),
        Speed = NumberRange.new(0.01, 0.01),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 20),
            NumberSequenceKeypoint.new(1, 190)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v7
    },
    {
        Name = "Mist",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Count = 16,
        Spread = 80,
        Acceleration = 4,
        Drag = 1.4,
        Flat = false,
        Light = 0,
        Delay = 0.05,
        Lifetime = NumberRange.new(2, 3),
        Speed = NumberRange.new(25, 60),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 50),
            NumberSequenceKeypoint.new(1, 130)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v8
    }
}
local t5 = {
    {
        Name = "Burst",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Count = 26,
        Spread = 70,
        Acceleration = -20,
        Drag = 1.6,
        Flat = false,
        Light = 0,
        Delay = 0,
        Lifetime = NumberRange.new(1.2, 1.9),
        Speed = NumberRange.new(50, 110),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 30),
            NumberSequenceKeypoint.new(1, 90)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v9
    },
    {
        Name = "Ring",
        Texture = "rbxasset://textures/particles/explosion01_shockwave_main.dds",
        Count = 1,
        Spread = 0,
        Acceleration = 0,
        Drag = 0,
        Flat = true,
        Light = 0,
        Delay = 0,
        Lifetime = NumberRange.new(0.9, 0.9),
        Speed = NumberRange.new(0.01, 0.01),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 30),
            NumberSequenceKeypoint.new(1, 220)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Color = v9
    }
}
local v10 = Random.new()

local function easeInOut(p1) -- line: 306
    return -(math.cos(3.141592653589793 * math.clamp(p1, 0, 1)) - 1) / 2
end

local function easeIn(p2) -- line: 310
    local v12 = math.clamp(p2, 0, 1)

    return v12 * v12 * v12
end

local function springOut(p3) -- line: 315
    local v13 = math.clamp(p3, 0, 1) - 1

    return v13 * 2.4 * v13 * v13 + 1 + v13 * 1.4 * v13
end

local function smoothstep(p4, p5, p6) -- line: 320
    local v15 = math.clamp((p6 - p4) / (p5 - p4), 0, 1)

    return v15 * v15 * (3 - v15 * 2)
end

local function flatten(p7) -- line: 325
    return (Vector3.new(p7.X, 0, p7.Z))
end

local function findTrackParts(p8, p9) -- line: 329
    -- upvalues: MountRace (copy)
    if p9 then
        while p8:GetAttribute(MountRace.TrackAttributes.Phase) == nil and p8:FindFirstChild(MountRace.HeatsFolder) == nil do
            task.wait(0.25)
        end
    end

    local v16 = p8:WaitForChild("Map", 30)

    return if v16 == nil then nil else v16:WaitForChild("Creatures", 30), p8:WaitForChild("Track", 30)
end

local function listenerPosition() -- line: 344
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    return if CurrentCamera then CurrentCamera.CFrame.Position else nil
end

local function rumblePad(p10) -- line: 349
    -- upvalues: HapticService (copy), UserInputService (copy)
    if UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil then
        local Gamepad1 = Enum.UserInputType.Gamepad1

        if HapticService:IsVibrationSupported(Gamepad1) and HapticService:IsMotorSupported(Gamepad1, Enum.VibrationMotor.Large) then
            HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, p10)
            task.delay(0.35, function() -- line: 362
                -- upvalues: Gamepad1 (copy), HapticService (copy)
                HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, 0)
            end)
        end
    end
end

local function emitBurst(p11, p12, p13, p14) -- line: 367
    -- upvalues: Workspace (copy)
    local v17 = p11:Add(Instance.new("Attachment"))

    v17.WorldCFrame = CFrame.new(p12)
    v17.Parent = Workspace.Terrain

    for _, v18 in p13 do
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Name = v18.Name
        ParticleEmitter.Texture = v18.Texture
        ParticleEmitter.Enabled = false
        ParticleEmitter.Rate = 0
        ParticleEmitter.Lifetime = v18.Lifetime
        ParticleEmitter.Speed = v18.Speed
        ParticleEmitter.SpreadAngle = Vector2.new(v18.Spread, v18.Spread)
        ParticleEmitter.Size = v18.Size
        ParticleEmitter.Transparency = v18.Transparency
        ParticleEmitter.Color = ColorSequence.new(v18.Color)
        ParticleEmitter.Acceleration = Vector3.new(0, v18.Acceleration, 0)
        ParticleEmitter.Drag = v18.Drag
        ParticleEmitter.LightEmission = v18.Light
        ParticleEmitter.EmissionDirection = Enum.NormalId.Top
        ParticleEmitter.Rotation = NumberRange.new(0, 360)
        ParticleEmitter.RotSpeed = if v18.Flat then NumberRange.new(-20, 20) else NumberRange.new(-40, 40)
        ParticleEmitter.Orientation = if v18.Flat then Enum.ParticleOrientation.VelocityPerpendicular else Enum.ParticleOrientation.FacingCamera
        ParticleEmitter.LockedToPart = v18.Flat
        ParticleEmitter.TimeScale = p14
        ParticleEmitter.Parent = v17

        if v18.Delay > 0 then
            task.delay(v18.Delay / p14, function() -- line: 397
                -- upvalues: ParticleEmitter (copy), v18 (copy)
                if ParticleEmitter.Parent then
                    ParticleEmitter:Emit(v18.Count)
                end
            end)
        else
            ParticleEmitter:Emit(v18.Count)
        end
    end
end

local function markDisc(p15, p16, p17, p18) -- line: 408
    -- upvalues: Workspace (copy), v6 (copy)
    local v22 = p15:Add(Instance.new("Part"))

    v22.Name = p18
    v22.Shape = Enum.PartType.Cylinder
    v22.Size = Vector3.new(0.2, p17, p17)
    v22.CFrame = CFrame.new(p16 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    v22.Material = Enum.Material.Neon
    v22.Color = v6
    v22.Anchored = true
    v22.CanCollide = false
    v22.CanQuery = false
    v22.CanTouch = false
    v22.CastShadow = false
    v22.Transparency = 1
    v22.Parent = Workspace.CurrentCamera

    return v22
end

local t6 = {}

local function bindTrack(p19, p20) -- line: 429
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
    task.spawn(function() -- line: 430
        -- upvalues: p19 (copy), p20 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
        local v23, v24 = findTrackParts(p19, p20)

        if v23 ~= nil and v24 ~= nil then
            local v25 = Trove.new()
            local v26 = CameraShaker.new()

            CameraShakerDriver.Start(v26, Enum.RenderPriority.Last.Value)
            v25:Add(function() -- line: 439
                -- upvalues: v26 (copy), CameraShakerDriver (copy)
                CameraShakerDriver.Stop(v26)
            end)

            local t7 = {}
            local t8, t9

            for _, child in v23:GetChildren() do
                if child:IsA("Model") then
                    local v27 = KrakenRig.Head(child)

                    if v27 then
                        t9 = {
                            Tilt = Vector3.new(0, 0, 0),
                            TiltSpeed = Vector3.new(0, 0, 0),
                            Joint = v27,
                            Center = v27.Motor.Part1.Position
                        }
                        t8 = t9
                    else
                        local function poseOf() -- line: 461
                            -- upvalues: child (copy), KrakenRig (copy)
                            return KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 }
                        end

                        local v28 = KrakenRig.Arm(child, v24, {
                            v23
                        }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                        if v28 ~= nil then
                            local v29 = v28.Segments[#v28.Segments]
                            local v30 = v25:Add(Instance.new("Attachment"))

                            v30.Name = "KrakenTip"
                            v30.WorldPosition = v28.Tip
                            v30.Parent = v29

                            local v31 = v25:Add(Instance.new("Attachment"))

                            v31.Name = "KrakenTipTail"
                            v31.WorldPosition = v28.Tip + (v29.Position - v28.Tip).Unit * 22
                            v31.Parent = v29

                            local v32 = v25:Add(Instance.new("Trail"))

                            v32.Attachment0 = v30
                            v32.Attachment1 = v31
                            v32.Lifetime = 0.22
                            v32.MinLength = 0.5
                            v32.FaceCamera = true
                            v32.LightEmission = 0.35
                            v32.Color = ColorSequence.new(v8)
                            v32.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.35),
                                NumberSequenceKeypoint.new(1, 1)
                            })
                            v32.Enabled = false
                            v32.Parent = v29

                            local t11 = {
                                Swing = nil,
                                Rig = v28,
                                Sway = v28.Heading,
                                Phase = v10:NextNumber(0, 6.283185307179586),
                                Tip = v30,
                                Trail = v32
                            }

                            t7[child] = t11
                            v25:Connect(child:GetAttributeChangedSignal(KrakenRig.Attribute), function() -- line: 503
                                -- upvalues: v23 (copy), v24 (copy), child (copy), t11 (copy), KrakenRig (copy)
                                local v33 = KrakenRig.Arm(child, v24, {
                                    v23
                                }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                                if v33 ~= nil then
                                    t11.Rig = v33
                                end
                            end)
                        end
                    end
                end
            end

            if next(t7) == nil and t9 == nil then
                v25:Destroy()

                return
            end

            local v34 = if t9 then t9.Center else next(t7):GetPivot().Position
            local n1 = 0
            local n2 = 1
            local v35 = true

            local function gainAt(p21) -- line: 520
                -- upvalues: Workspace (copy)
                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                if Position == nil then
                    return 0
                end

                local v37 = math.clamp(((Position - p21).Magnitude - 150) / 800, 0, 1)

                return 1 - v37 * v37 * (3 - v37 * 2)
            end

            local function shakeFor(p22, p23, p24) -- line: 528
                -- upvalues: v26 (copy), GuiService (copy), Workspace (copy), Timing (copy), rumblePad (copy)
                if GuiService.ReducedMotionEnabled then
                    return
                end

                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                local v38 = 0

                if Position ~= nil then
                    local v40 = math.clamp(((Position - p22).Magnitude - 150) / 800, 0, 1)

                    v38 = 1 - v40 * v40 * (3 - v40 * 2)
                end

                if not (v38 <= 0.02) then
                    if p23 then
                        v26:ShakeOnce(v38 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                    else
                        v26:ShakeOnce(v38 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                        v26:ShakeOnce(v38 * 2.6, 2.5, 0.05, 1.8)

                        if p24 and v38 >= 0.5 then
                            rumblePad((math.clamp(v38, 0, 1)))
                        end
                    end
                end
            end

            local function land(p25) -- line: 555
                -- upvalues: v26 (copy), t8 (ref), n2 (ref), GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), t4 (copy), t5 (copy), rumblePad (copy), emitBurst (copy)
                local Rig = p25.Rig
                local v41 = Trove.new()

                emitBurst(v41, Rig.Impact, if Rig.Wet then t4 else t5, n2)
                task.delay(4.5 / n2, function() -- line: 559
                    -- upvalues: v41 (copy)
                    v41:Destroy()
                end)
                Audio.Play(Rig.Wet and 9119476512 or 9114036511, Rig.Impact, {
                    MaxDistance = 2400,
                    Volume = { 1.1, 1.3 },
                    PlaybackSpeed = { 0.82, 0.92 }
                })
                Audio.Play(9114036511, Rig.Impact, {
                    MaxDistance = 2400,
                    Volume = { 0.7, 0.85 },
                    PlaybackSpeed = { 0.7, 0.8 }
                })

                local Impact2 = Rig.Impact
                local v43 = #Rig.Crossings > 0

                if not GuiService.ReducedMotionEnabled then
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v44 = 0

                    if Position ~= nil then
                        local v46 = math.clamp(((Position - Impact2).Magnitude - 150) / 800, 0, 1)

                        v44 = 1 - v46 * v46 * (3 - v46 * 2)
                    end

                    if not (v44 <= 0.02) then
                        v26:ShakeOnce(v44 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                        v26:ShakeOnce(v44 * 2.6, 2.5, 0.05, 1.8)

                        if v43 and v44 >= 0.5 then
                            rumblePad((math.clamp(v44, 0, 1)))
                        end
                    end
                end

                if not t8 then
                    return
                end

                local v47 = Rig.Impact - t8.Center
                local v48 = Vector3.new(v47.X, 0, v47.Z)

                if v48.Magnitude > 1 then
                    local t12 = t8

                    t12.TiltSpeed += v48.Unit * 0.18
                end
            end

            local function endSwing(p26) -- line: 581
                local Swing = p26.Swing

                if Swing then
                    Swing.Trove:Destroy()
                end

                p26.Swing = nil
                p26.Trail.Enabled = false
            end

            local function beginSwing(p27, p28) -- line: 590
                -- upvalues: v26 (copy), n1 (ref), GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), Timing (copy), v1 (copy), v2 (copy), DrillaWarn (copy), markDisc (copy)
                local Swing = p27.Swing

                if Swing then
                    Swing.Trove:Destroy()
                end

                p27.Swing = nil
                p27.Trail.Enabled = false

                local v49 = Trove.new()
                local t13 = {
                    Started = n1 - p28,
                    Trove = v49,
                    Marks = {},
                    Fills = {},
                    Whooshed = v1 <= p28,
                    Landed = v2 <= p28
                }

                p27.Swing = t13

                if v2 <= p28 then
                    return
                end

                for _, v50 in p27.Rig.Crossings do
                    local v51 = Vector3.new(v50.Point.X, v50.Surface, v50.Point.Z)
                    local v52 = v50.Radius * 2.5

                    table.insert(t13.Marks, (markDisc(v49, v51, v52, "KrakenMark")))
                    table.insert(t13.Fills, (markDisc(v49, v51 + Vector3.new(0, 0.05, 0), v52, "KrakenFill")))
                end

                if #t13.Marks > 0 then
                    local Impact = p27.Rig.Impact
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v53 = 0

                    if Position ~= nil then
                        local v55 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                        v53 = 1 - v55 * v55 * (3 - v55 * 2)
                    end

                    if v53 > 0 then
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                        if Position and (Position - p27.Rig.Impact).Magnitude <= 700 then
                            Audio.Play(DrillaWarn, p27.Rig.Impact, {
                                MaxDistance = 700
                            })
                        end
                    end
                end

                local Impact = p27.Rig.Impact

                if GuiService.ReducedMotionEnabled then
                    return
                end

                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                local v56 = 0

                if Position ~= nil then
                    local v58 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                    v56 = 1 - v58 * v58 * (3 - v58 * 2)
                end

                if not (v56 <= 0.02) then
                    v26:ShakeOnce(v56 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                end
            end

            local function paintMarks(p29, p30) -- line: 623
                -- upvalues: v2 (copy), t3 (copy)
                if #p29.Marks == 0 then
                    return
                end

                if v2 + 0.15 <= p30 then
                    for _, v59 in p29.Marks do
                        v59:Destroy()
                    end

                    for _, v60 in p29.Fills do
                        v60:Destroy()
                    end

                    table.clear(p29.Marks)
                    table.clear(p29.Fills)
                else
                    local v62 = math.clamp(p30 / v2, 0, 1)
                    local v65 = math.lerp(t3[1], t3[2], v62)
                    local v66 = if v2 < p30 then (p30 - v2) / 0.15 else 0
                    local v69 = math.lerp(0.72, 0.45, v62) + math.sin(p30 * v65) * 0.12

                    for v70, v71 in p29.Marks do
                        v71.Transparency = math.lerp(math.clamp(v69, 0, 1), 1, v66)

                        local v73 = p29.Fills[v70]
                        local v75 = math.max(v71.Size.Y * v62, 0.2)

                        v73.Size = Vector3.new(0.2, v75, v75)
                        v73.Transparency = math.lerp(0.35, 1, v66)
                    end
                end
            end

            local function swingAngles(p31, p32) -- line: 652
                -- upvalues: KrakenRig (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                local Rig = p31.Rig
                local v76 = table.create(#Rig.Joints, 0)

                for i = 1, #Rig.Joints do
                    local v78 = Raise[math.min(i, #Raise)]
                    local v79 = KrakenRig.StrikeAngle(Rig, i)

                    if p32 < Timing.Windup then
                        v79 = v78 * (-(math.cos(3.141592653589793 * math.clamp(p32 / Timing.Windup, 0, 1)) - 1) / 2)
                    elseif p32 < v1 then
                        local v82 = (p32 - Timing.Windup) / Timing.Hold

                        v79 = v78 * (1 + 0.06000000000000005 * v82) + math.sin(p32 * 46 + i) * 0.7 * v82
                    elseif p32 < v2 + (i - 1) * 0.04 then
                        local v85 = (p32 - v1 - (i - 1) * 0.04) / Timing.Strike
                        local v86 = v78 * 1.06
                        local v87 = math.clamp(v85, 0, 1)

                        v79 = math.lerp(v86, v79, v87 * v87 * v87)
                    elseif p32 < v3 then
                        local v90 = math.clamp((p32 - v2) / Timing.Settle, 0, 1)

                        if i == 1 then
                            v79 -= math.sin(v90 * 3.141592653589793) * 3
                        else
                            v79 += math.sin(v90 * 3.141592653589793 * 2) * 7 * (1 - v90)
                        end
                    elseif not (p32 < v4) then
                        local v94 = math.clamp((p32 - v4) / Timing.Recover, 0, 1) - 1

                        v79 *= 1 - (v94 * 2.4 * v94 * v94 + 1 + v94 * 1.4 * v94)
                    end

                    v76[i] = v79
                end

                return v76
            end

            local function poseArm(p33) -- line: 685
                -- upvalues: n1 (ref), land (copy), paintMarks (copy), swingAngles (copy), Audio (copy), KrakenRig (copy), t1 (copy), t2 (copy), Timing (copy), v1 (copy), v2 (copy), v5 (copy)
                local Rig, Swing = p33.Rig, p33.Swing
                local v95, v96

                if Swing then
                    local v98 = n1
                    local v97 = v98 - Swing.Started

                    if v5 <= v97 then
                        local Swing = p33.Swing

                        if Swing then
                            Swing.Trove:Destroy()
                        end

                        p33.Swing = nil
                        v96 = 1
                        p33.Trail.Enabled = false
                    else
                        v95 = swingAngles(p33, v97)
                        v96 = math.lerp(1, 0.2, (math.clamp(math.min(v97 / Timing.Windup, (v5 - v97) / Timing.Recover, 1), 0, 1)))
                        paintMarks(Swing, v97)

                        if not Swing.Whooshed and v1 <= v97 then
                            Swing.Whooshed = true
                            p33.Trail.Enabled = true
                            Audio.Play(9113077334, p33.Tip, {
                                MaxDistance = 2400,
                                Volume = 0.9,
                                PlaybackSpeed = { 0.75, 0.85 }
                            })
                        end

                        if not Swing.Landed and v2 <= v97 then
                            Swing.Landed = true
                            land(p33)
                        end

                        if p33.Trail.Enabled and v2 + 0.2 <= v97 then
                            p33.Trail.Enabled = false
                        end
                    end
                else
                    v96 = 1
                end

                for v103, v104 in Rig.Joints do
                    local v105 = n1 * 3.141592653589793 * 2 / 5.6 + p33.Phase - v103 * 0.75
                    local v106 = n1 * 3.141592653589793 * 2 / 7.3 + p33.Phase * 1.7 - v103 * 0.75
                    local v108 = t1[math.min(v103, #t1)] * math.sin(v105) * v96
                    local v110 = t2[math.min(v103, #t2)] * math.sin(v106) * v96

                    if v95 then
                        v108 += v95[v103]
                    end

                    local v111 = CFrame.fromAxisAngle(Rig.Curl, (math.rad(v108))) * CFrame.fromAxisAngle(p33.Sway, (math.rad(v110)))

                    KrakenRig.Drive(v104, KrakenRig.About(v104.Pivot, v111))
                end
            end

            local function poseHead(p34) -- line: 734
                -- upvalues: t8 (ref), n1 (ref), KrakenRig (copy)
                local t14 = t8

                if t14 == nil then
                    return
                end

                local v112 = -t14.Tilt * 18 - t14.TiltSpeed * 4.5

                t14.TiltSpeed += v112 * p34
                t14.Tilt += t14.TiltSpeed * p34

                local v113 = n1 * 3.141592653589793 * 2
                local v115 = math.sin(v113 / 6.4) * 3.5
                local v124 = CFrame.Angles(math.rad(math.sin(v113 / 8.32) * 1.1), math.rad(math.sin(v113 / 13.440000000000001 + 1) * 1.6), (math.rad(math.sin(v113 / 10.88 + 2) * 1.1)))
                local identity = CFrame.identity

                if t14.Tilt.Magnitude > 1E-04 then
                    identity = CFrame.fromAxisAngle((Vector3.new(0, 1, 0)):Cross(t14.Tilt.Unit), t14.Tilt.Magnitude)
                end

                KrakenRig.Drive(t14.Joint, CFrame.new(0, v115, 0) * KrakenRig.About(t14.Joint.Pivot, identity * v124))
            end

            local function rest() -- line: 761
                -- upvalues: t7 (copy), t8 (ref)
                for _, v125 in t7 do
                    local Swing = v125.Swing

                    if Swing then
                        Swing.Trove:Destroy()
                    end

                    v125.Swing = nil
                    v125.Trail.Enabled = false

                    for _, v126 in v125.Rig.Joints do
                        v126.Motor.Transform = CFrame.identity
                    end
                end

                if t8 then
                    t8.Joint.Motor.Transform = CFrame.identity
                end
            end

            local function nearby() -- line: 773
                -- upvalues: v34 (copy), Workspace (copy)
                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                return Position ~= nil and (Position - v34).Magnitude <= 2800
            end

            v25:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p35, p36, p37) -- line: 780
                -- upvalues: t7 (copy), beginSwing (copy), v34 (copy), Workspace (copy), v5 (copy)
                if p35 ~= "Kraken" or typeof(p36) ~= "Instance" or type(p37) ~= "number" then
                    return
                end

                local v127 = t7[p36]

                if v127 == nil then
                    return
                end

                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                if Position ~= nil and (Position - v34).Magnitude <= 2800 then
                    local v129 = math.max(0, Workspace:GetServerTimeNow() - p37)

                    if v129 < v5 then
                        beginSwing(v127, v129)
                    end
                end
            end)
            v25:Connect(RunService.PreSimulation, function(p38) -- line: 799
                -- upvalues: v23 (copy), t7 (copy), n1 (ref), n2 (ref), v35 (ref), poseArm (copy), poseHead (copy), rest (copy), v34 (copy), Workspace (copy)
                local CurrentCamera = Workspace.CurrentCamera
                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                if Position ~= nil and (Position - v34).Magnitude <= 2800 then
                    v35 = false

                    local KrakenSpeed = v23:GetAttribute("KrakenSpeed")

                    if type(KrakenSpeed) ~= "number" or not (KrakenSpeed > 0) then
                        KrakenSpeed = 1
                    end

                    n2 = KrakenSpeed

                    local v130 = p38 * n2

                    n1 += v130

                    for _, v131 in t7 do
                        poseArm(v131)
                    end

                    poseHead((math.min(v130, 0.05)))
                elseif not v35 then
                    v35 = true
                    rest()
                end
            end)
            v25:AttachToInstance(v23)
        end
    end)
end

function t6.Start() -- line: 822
    -- upvalues: CollectionService (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), MountRace (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
    local t15 = {}

    local function onTrack(p39, p40) -- line: 824
        -- upvalues: t15 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
        if t15[p39] ~= nil or not p39:IsDescendantOf(Workspace) then
            return
        end

        t15[p39] = true
        task.spawn(function() -- line: 430
            -- upvalues: p39 (copy), p40 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
            local v132, v133 = findTrackParts(p39, p40)

            if v132 ~= nil and v133 ~= nil then
                local v134 = Trove.new()
                local v135 = CameraShaker.new()

                CameraShakerDriver.Start(v135, Enum.RenderPriority.Last.Value)
                v134:Add(function() -- line: 439
                    -- upvalues: CameraShakerDriver (copy), v135 (copy)
                    CameraShakerDriver.Stop(v135)
                end)

                local t16 = {}
                local t17, t18

                for _, child in v132:GetChildren() do
                    if child:IsA("Model") then
                        local v136 = KrakenRig.Head(child)

                        if v136 then
                            t18 = {
                                Tilt = Vector3.new(0, 0, 0),
                                TiltSpeed = Vector3.new(0, 0, 0),
                                Joint = v136,
                                Center = v136.Motor.Part1.Position
                            }
                            t17 = t18
                        else
                            local function poseOf() -- line: 461
                                -- upvalues: KrakenRig (copy), child (copy)
                                return KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 }
                            end

                            local v137 = KrakenRig.Arm(child, v133, {
                                v132
                            }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                            if v137 ~= nil then
                                local v138 = v137.Segments[#v137.Segments]
                                local v139 = v134:Add(Instance.new("Attachment"))

                                v139.Name = "KrakenTip"
                                v139.WorldPosition = v137.Tip
                                v139.Parent = v138

                                local v140 = v134:Add(Instance.new("Attachment"))

                                v140.Name = "KrakenTipTail"
                                v140.WorldPosition = v137.Tip + (v138.Position - v137.Tip).Unit * 22
                                v140.Parent = v138

                                local v141 = v134:Add(Instance.new("Trail"))

                                v141.Attachment0 = v139
                                v141.Attachment1 = v140
                                v141.Lifetime = 0.22
                                v141.MinLength = 0.5
                                v141.FaceCamera = true
                                v141.LightEmission = 0.35
                                v141.Color = ColorSequence.new(v8)
                                v141.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.35),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                                v141.Enabled = false
                                v141.Parent = v138

                                local t20 = {
                                    Swing = nil,
                                    Rig = v137,
                                    Sway = v137.Heading,
                                    Phase = v10:NextNumber(0, 6.283185307179586),
                                    Tip = v139,
                                    Trail = v141
                                }

                                t16[child] = t20
                                v134:Connect(child:GetAttributeChangedSignal(KrakenRig.Attribute), function() -- line: 503
                                    -- upvalues: KrakenRig (copy), v132 (copy), v133 (copy), child (copy), t20 (copy)
                                    local v142 = KrakenRig.Arm(child, v133, {
                                        v132
                                    }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                                    if v142 ~= nil then
                                        t20.Rig = v142
                                    end
                                end)
                            end
                        end
                    end
                end

                if next(t16) == nil and t18 == nil then
                    v134:Destroy()

                    return
                end

                local v143 = if t18 then t18.Center else next(t16):GetPivot().Position
                local n3 = 0
                local n4 = 1
                local v144 = true

                local function gainAt(p41) -- line: 520
                    -- upvalues: Workspace (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position == nil then
                        return 0
                    end

                    local v146 = math.clamp(((Position - p41).Magnitude - 150) / 800, 0, 1)

                    return 1 - v146 * v146 * (3 - v146 * 2)
                end

                local function shakeFor(p42, p43, p44) -- line: 528
                    -- upvalues: GuiService (copy), Workspace (copy), Timing (copy), rumblePad (copy), v135 (copy)
                    if GuiService.ReducedMotionEnabled then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v147 = 0

                    if Position ~= nil then
                        local v149 = math.clamp(((Position - p42).Magnitude - 150) / 800, 0, 1)

                        v147 = 1 - v149 * v149 * (3 - v149 * 2)
                    end

                    if not (v147 <= 0.02) then
                        if p43 then
                            v135:ShakeOnce(v147 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                        else
                            v135:ShakeOnce(v147 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                            v135:ShakeOnce(v147 * 2.6, 2.5, 0.05, 1.8)

                            if p44 and v147 >= 0.5 then
                                rumblePad((math.clamp(v147, 0, 1)))
                            end
                        end
                    end
                end

                local function land(p45) -- line: 555
                    -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), t4 (copy), t5 (copy), rumblePad (copy), emitBurst (copy), v135 (copy), t17 (ref), n4 (ref)
                    local Rig = p45.Rig
                    local v150 = Trove.new()

                    emitBurst(v150, Rig.Impact, if Rig.Wet then t4 else t5, n4)
                    task.delay(4.5 / n4, function() -- line: 559
                        -- upvalues: v150 (copy)
                        v150:Destroy()
                    end)
                    Audio.Play(Rig.Wet and 9119476512 or 9114036511, Rig.Impact, {
                        MaxDistance = 2400,
                        Volume = { 1.1, 1.3 },
                        PlaybackSpeed = { 0.82, 0.92 }
                    })
                    Audio.Play(9114036511, Rig.Impact, {
                        MaxDistance = 2400,
                        Volume = { 0.7, 0.85 },
                        PlaybackSpeed = { 0.7, 0.8 }
                    })

                    local Impact2 = Rig.Impact
                    local v152 = #Rig.Crossings > 0

                    if not GuiService.ReducedMotionEnabled then
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v153 = 0

                        if Position ~= nil then
                            local v155 = math.clamp(((Position - Impact2).Magnitude - 150) / 800, 0, 1)

                            v153 = 1 - v155 * v155 * (3 - v155 * 2)
                        end

                        if not (v153 <= 0.02) then
                            v135:ShakeOnce(v153 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                            v135:ShakeOnce(v153 * 2.6, 2.5, 0.05, 1.8)

                            if v152 and v153 >= 0.5 then
                                rumblePad((math.clamp(v153, 0, 1)))
                            end
                        end
                    end

                    if not t17 then
                        return
                    end

                    local v156 = Rig.Impact - t17.Center
                    local v157 = Vector3.new(v156.X, 0, v156.Z)

                    if v157.Magnitude > 1 then
                        local t21 = t17

                        t21.TiltSpeed += v157.Unit * 0.18
                    end
                end

                local function endSwing(p46) -- line: 581
                    local Swing = p46.Swing

                    if Swing then
                        Swing.Trove:Destroy()
                    end

                    p46.Swing = nil
                    p46.Trail.Enabled = false
                end

                local function beginSwing(p47, p48) -- line: 590
                    -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), Timing (copy), v1 (copy), v2 (copy), DrillaWarn (copy), markDisc (copy), v135 (copy), n3 (ref)
                    local Swing = p47.Swing

                    if Swing then
                        Swing.Trove:Destroy()
                    end

                    p47.Swing = nil
                    p47.Trail.Enabled = false

                    local v158 = Trove.new()
                    local t22 = {
                        Started = n3 - p48,
                        Trove = v158,
                        Marks = {},
                        Fills = {},
                        Whooshed = v1 <= p48,
                        Landed = v2 <= p48
                    }

                    p47.Swing = t22

                    if v2 <= p48 then
                        return
                    end

                    for _, v159 in p47.Rig.Crossings do
                        local v160 = Vector3.new(v159.Point.X, v159.Surface, v159.Point.Z)
                        local v161 = v159.Radius * 2.5

                        table.insert(t22.Marks, (markDisc(v158, v160, v161, "KrakenMark")))
                        table.insert(t22.Fills, (markDisc(v158, v160 + Vector3.new(0, 0.05, 0), v161, "KrakenFill")))
                    end

                    if #t22.Marks > 0 then
                        local Impact = p47.Rig.Impact
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v162 = 0

                        if Position ~= nil then
                            local v164 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                            v162 = 1 - v164 * v164 * (3 - v164 * 2)
                        end

                        if v162 > 0 then
                            local CurrentCamera = Workspace.CurrentCamera
                            local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                            if Position and (Position - p47.Rig.Impact).Magnitude <= 700 then
                                Audio.Play(DrillaWarn, p47.Rig.Impact, {
                                    MaxDistance = 700
                                })
                            end
                        end
                    end

                    local Impact = p47.Rig.Impact

                    if GuiService.ReducedMotionEnabled then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v165 = 0

                    if Position ~= nil then
                        local v167 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                        v165 = 1 - v167 * v167 * (3 - v167 * 2)
                    end

                    if not (v165 <= 0.02) then
                        v135:ShakeOnce(v165 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                    end
                end

                local function paintMarks(p49, p50) -- line: 623
                    -- upvalues: v2 (copy), t3 (copy)
                    if #p49.Marks == 0 then
                        return
                    end

                    if v2 + 0.15 <= p50 then
                        for _, v168 in p49.Marks do
                            v168:Destroy()
                        end

                        for _, v169 in p49.Fills do
                            v169:Destroy()
                        end

                        table.clear(p49.Marks)
                        table.clear(p49.Fills)
                    else
                        local v171 = math.clamp(p50 / v2, 0, 1)
                        local v174 = math.lerp(t3[1], t3[2], v171)
                        local v175 = if v2 < p50 then (p50 - v2) / 0.15 else 0
                        local v178 = math.lerp(0.72, 0.45, v171) + math.sin(p50 * v174) * 0.12

                        for v179, v180 in p49.Marks do
                            v180.Transparency = math.lerp(math.clamp(v178, 0, 1), 1, v175)

                            local v182 = p49.Fills[v179]
                            local v184 = math.max(v180.Size.Y * v171, 0.2)

                            v182.Size = Vector3.new(0.2, v184, v184)
                            v182.Transparency = math.lerp(0.35, 1, v175)
                        end
                    end
                end

                local function swingAngles(p51, p52) -- line: 652
                    -- upvalues: KrakenRig (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                    local Rig = p51.Rig
                    local v185 = table.create(#Rig.Joints, 0)

                    for i = 1, #Rig.Joints do
                        local v187 = Raise[math.min(i, #Raise)]
                        local v188 = KrakenRig.StrikeAngle(Rig, i)

                        if p52 < Timing.Windup then
                            v188 = v187 * (-(math.cos(3.141592653589793 * math.clamp(p52 / Timing.Windup, 0, 1)) - 1) / 2)
                        elseif p52 < v1 then
                            local v191 = (p52 - Timing.Windup) / Timing.Hold

                            v188 = v187 * (1 + 0.06000000000000005 * v191) + math.sin(p52 * 46 + i) * 0.7 * v191
                        elseif p52 < v2 + (i - 1) * 0.04 then
                            local v194 = (p52 - v1 - (i - 1) * 0.04) / Timing.Strike
                            local v195 = v187 * 1.06
                            local v196 = math.clamp(v194, 0, 1)

                            v188 = math.lerp(v195, v188, v196 * v196 * v196)
                        elseif p52 < v3 then
                            local v199 = math.clamp((p52 - v2) / Timing.Settle, 0, 1)

                            if i == 1 then
                                v188 -= math.sin(v199 * 3.141592653589793) * 3
                            else
                                v188 += math.sin(v199 * 3.141592653589793 * 2) * 7 * (1 - v199)
                            end
                        elseif not (p52 < v4) then
                            local v203 = math.clamp((p52 - v4) / Timing.Recover, 0, 1) - 1

                            v188 *= 1 - (v203 * 2.4 * v203 * v203 + 1 + v203 * 1.4 * v203)
                        end

                        v185[i] = v188
                    end

                    return v185
                end

                local function poseArm(p53) -- line: 685
                    -- upvalues: Audio (copy), KrakenRig (copy), t1 (copy), t2 (copy), Timing (copy), v1 (copy), v2 (copy), v5 (copy), n3 (ref), land (copy), paintMarks (copy), swingAngles (copy)
                    local Rig, Swing = p53.Rig, p53.Swing
                    local v204, v205

                    if Swing then
                        local v207 = n3
                        local v206 = v207 - Swing.Started

                        if v5 <= v206 then
                            local Swing = p53.Swing

                            if Swing then
                                Swing.Trove:Destroy()
                            end

                            p53.Swing = nil
                            v205 = 1
                            p53.Trail.Enabled = false
                        else
                            v204 = swingAngles(p53, v206)
                            v205 = math.lerp(1, 0.2, (math.clamp(math.min(v206 / Timing.Windup, (v5 - v206) / Timing.Recover, 1), 0, 1)))
                            paintMarks(Swing, v206)

                            if not Swing.Whooshed and v1 <= v206 then
                                Swing.Whooshed = true
                                p53.Trail.Enabled = true
                                Audio.Play(9113077334, p53.Tip, {
                                    MaxDistance = 2400,
                                    Volume = 0.9,
                                    PlaybackSpeed = { 0.75, 0.85 }
                                })
                            end

                            if not Swing.Landed and v2 <= v206 then
                                Swing.Landed = true
                                land(p53)
                            end

                            if p53.Trail.Enabled and v2 + 0.2 <= v206 then
                                p53.Trail.Enabled = false
                            end
                        end
                    else
                        v205 = 1
                    end

                    for v212, v213 in Rig.Joints do
                        local v214 = n3 * 3.141592653589793 * 2 / 5.6 + p53.Phase - v212 * 0.75
                        local v215 = n3 * 3.141592653589793 * 2 / 7.3 + p53.Phase * 1.7 - v212 * 0.75
                        local v217 = t1[math.min(v212, #t1)] * math.sin(v214) * v205
                        local v219 = t2[math.min(v212, #t2)] * math.sin(v215) * v205

                        if v204 then
                            v217 += v204[v212]
                        end

                        local v220 = CFrame.fromAxisAngle(Rig.Curl, (math.rad(v217))) * CFrame.fromAxisAngle(p53.Sway, (math.rad(v219)))

                        KrakenRig.Drive(v213, KrakenRig.About(v213.Pivot, v220))
                    end
                end

                local function poseHead(p54) -- line: 734
                    -- upvalues: KrakenRig (copy), t17 (ref), n3 (ref)
                    local t23 = t17

                    if t23 == nil then
                        return
                    end

                    local v221 = -t23.Tilt * 18 - t23.TiltSpeed * 4.5

                    t23.TiltSpeed += v221 * p54
                    t23.Tilt += t23.TiltSpeed * p54

                    local v222 = n3 * 3.141592653589793 * 2
                    local v224 = math.sin(v222 / 6.4) * 3.5
                    local v233 = CFrame.Angles(math.rad(math.sin(v222 / 8.32) * 1.1), math.rad(math.sin(v222 / 13.440000000000001 + 1) * 1.6), (math.rad(math.sin(v222 / 10.88 + 2) * 1.1)))
                    local identity = CFrame.identity

                    if t23.Tilt.Magnitude > 1E-04 then
                        identity = CFrame.fromAxisAngle((Vector3.new(0, 1, 0)):Cross(t23.Tilt.Unit), t23.Tilt.Magnitude)
                    end

                    KrakenRig.Drive(t23.Joint, CFrame.new(0, v224, 0) * KrakenRig.About(t23.Joint.Pivot, identity * v233))
                end

                local function rest() -- line: 761
                    -- upvalues: t16 (copy), t17 (ref)
                    for _, v234 in t16 do
                        local Swing = v234.Swing

                        if Swing then
                            Swing.Trove:Destroy()
                        end

                        v234.Swing = nil
                        v234.Trail.Enabled = false

                        for _, v235 in v234.Rig.Joints do
                            v235.Motor.Transform = CFrame.identity
                        end
                    end

                    if t17 then
                        t17.Joint.Motor.Transform = CFrame.identity
                    end
                end

                local function nearby() -- line: 773
                    -- upvalues: Workspace (copy), v143 (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    return Position ~= nil and (Position - v143).Magnitude <= 2800
                end

                v134:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p55, p56, p57) -- line: 780
                    -- upvalues: Workspace (copy), v5 (copy), t16 (copy), v143 (copy), beginSwing (copy)
                    if p55 ~= "Kraken" or typeof(p56) ~= "Instance" or type(p57) ~= "number" then
                        return
                    end

                    local v236 = t16[p56]

                    if v236 == nil then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position ~= nil and (Position - v143).Magnitude <= 2800 then
                        local v238 = math.max(0, Workspace:GetServerTimeNow() - p57)

                        if v238 < v5 then
                            beginSwing(v236, v238)
                        end
                    end
                end)
                v134:Connect(RunService.PreSimulation, function(p58) -- line: 799
                    -- upvalues: Workspace (copy), v132 (copy), t16 (copy), v143 (copy), n3 (ref), n4 (ref), v144 (ref), poseArm (copy), poseHead (copy), rest (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position ~= nil and (Position - v143).Magnitude <= 2800 then
                        v144 = false

                        local KrakenSpeed = v132:GetAttribute("KrakenSpeed")

                        if type(KrakenSpeed) ~= "number" or not (KrakenSpeed > 0) then
                            KrakenSpeed = 1
                        end

                        n4 = KrakenSpeed

                        local v239 = p58 * n4

                        n3 += v239

                        for _, v240 in t16 do
                            poseArm(v240)
                        end

                        poseHead((math.min(v239, 0.05)))
                    elseif not v144 then
                        v144 = true
                        rest()
                    end
                end)
                v134:AttachToInstance(v132)
            end
        end)
    end

    CollectionService:GetInstanceAddedSignal(MountRace.TrackTag):Connect(function(p59) -- line: 830
        -- upvalues: t15 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
        if t15[p59] ~= nil or not p59:IsDescendantOf(Workspace) then
            return
        end

        t15[p59] = true

        local spawn = task.spawn
        local v241 = true

        spawn(function() -- line: 430
            -- upvalues: p59 (copy), v241 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
            local v242, v243 = findTrackParts(p59, v241)

            if v242 ~= nil and v243 ~= nil then
                local v244 = Trove.new()
                local v245 = CameraShaker.new()

                CameraShakerDriver.Start(v245, Enum.RenderPriority.Last.Value)
                v244:Add(function() -- line: 439
                    -- upvalues: CameraShakerDriver (copy), v245 (copy)
                    CameraShakerDriver.Stop(v245)
                end)

                local t24 = {}
                local t25, t26

                for _, child in v242:GetChildren() do
                    if child:IsA("Model") then
                        local v246 = KrakenRig.Head(child)

                        if v246 then
                            t26 = {
                                Tilt = Vector3.new(0, 0, 0),
                                TiltSpeed = Vector3.new(0, 0, 0),
                                Joint = v246,
                                Center = v246.Motor.Part1.Position
                            }
                            t25 = t26
                        else
                            local function poseOf() -- line: 461
                                -- upvalues: KrakenRig (copy), child (copy)
                                return KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 }
                            end

                            local v247 = KrakenRig.Arm(child, v243, {
                                v242
                            }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                            if v247 ~= nil then
                                local v248 = v247.Segments[#v247.Segments]
                                local v249 = v244:Add(Instance.new("Attachment"))

                                v249.Name = "KrakenTip"
                                v249.WorldPosition = v247.Tip
                                v249.Parent = v248

                                local v250 = v244:Add(Instance.new("Attachment"))

                                v250.Name = "KrakenTipTail"
                                v250.WorldPosition = v247.Tip + (v248.Position - v247.Tip).Unit * 22
                                v250.Parent = v248

                                local v251 = v244:Add(Instance.new("Trail"))

                                v251.Attachment0 = v249
                                v251.Attachment1 = v250
                                v251.Lifetime = 0.22
                                v251.MinLength = 0.5
                                v251.FaceCamera = true
                                v251.LightEmission = 0.35
                                v251.Color = ColorSequence.new(v8)
                                v251.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.35),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                                v251.Enabled = false
                                v251.Parent = v248

                                local t28 = {
                                    Swing = nil,
                                    Rig = v247,
                                    Sway = v247.Heading,
                                    Phase = v10:NextNumber(0, 6.283185307179586),
                                    Tip = v249,
                                    Trail = v251
                                }

                                t24[child] = t28
                                v244:Connect(child:GetAttributeChangedSignal(KrakenRig.Attribute), function() -- line: 503
                                    -- upvalues: KrakenRig (copy), v242 (copy), v243 (copy), child (copy), t28 (copy)
                                    local v252 = KrakenRig.Arm(child, v243, {
                                        v242
                                    }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                                    if v252 ~= nil then
                                        t28.Rig = v252
                                    end
                                end)
                            end
                        end
                    end
                end

                if next(t24) == nil and t26 == nil then
                    v244:Destroy()

                    return
                end

                local v253 = if t26 then t26.Center else next(t24):GetPivot().Position
                local n5 = 0
                local n6 = 1
                local v254 = true

                local function gainAt(p60) -- line: 520
                    -- upvalues: Workspace (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position == nil then
                        return 0
                    end

                    local v256 = math.clamp(((Position - p60).Magnitude - 150) / 800, 0, 1)

                    return 1 - v256 * v256 * (3 - v256 * 2)
                end

                local function shakeFor(p61, p62, p63) -- line: 528
                    -- upvalues: GuiService (copy), Workspace (copy), Timing (copy), rumblePad (copy), v245 (copy)
                    if GuiService.ReducedMotionEnabled then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v257 = 0

                    if Position ~= nil then
                        local v259 = math.clamp(((Position - p61).Magnitude - 150) / 800, 0, 1)

                        v257 = 1 - v259 * v259 * (3 - v259 * 2)
                    end

                    if not (v257 <= 0.02) then
                        if p62 then
                            v245:ShakeOnce(v257 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                        else
                            v245:ShakeOnce(v257 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                            v245:ShakeOnce(v257 * 2.6, 2.5, 0.05, 1.8)

                            if p63 and v257 >= 0.5 then
                                rumblePad((math.clamp(v257, 0, 1)))
                            end
                        end
                    end
                end

                local function land(p64) -- line: 555
                    -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), t4 (copy), t5 (copy), rumblePad (copy), emitBurst (copy), v245 (copy), t25 (ref), n6 (ref)
                    local Rig = p64.Rig
                    local v260 = Trove.new()

                    emitBurst(v260, Rig.Impact, if Rig.Wet then t4 else t5, n6)
                    task.delay(4.5 / n6, function() -- line: 559
                        -- upvalues: v260 (copy)
                        v260:Destroy()
                    end)
                    Audio.Play(Rig.Wet and 9119476512 or 9114036511, Rig.Impact, {
                        MaxDistance = 2400,
                        Volume = { 1.1, 1.3 },
                        PlaybackSpeed = { 0.82, 0.92 }
                    })
                    Audio.Play(9114036511, Rig.Impact, {
                        MaxDistance = 2400,
                        Volume = { 0.7, 0.85 },
                        PlaybackSpeed = { 0.7, 0.8 }
                    })

                    local Impact2 = Rig.Impact
                    local v262 = #Rig.Crossings > 0

                    if not GuiService.ReducedMotionEnabled then
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v263 = 0

                        if Position ~= nil then
                            local v265 = math.clamp(((Position - Impact2).Magnitude - 150) / 800, 0, 1)

                            v263 = 1 - v265 * v265 * (3 - v265 * 2)
                        end

                        if not (v263 <= 0.02) then
                            v245:ShakeOnce(v263 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                            v245:ShakeOnce(v263 * 2.6, 2.5, 0.05, 1.8)

                            if v262 and v263 >= 0.5 then
                                rumblePad((math.clamp(v263, 0, 1)))
                            end
                        end
                    end

                    if not t25 then
                        return
                    end

                    local v266 = Rig.Impact - t25.Center
                    local v267 = Vector3.new(v266.X, 0, v266.Z)

                    if v267.Magnitude > 1 then
                        local t29 = t25

                        t29.TiltSpeed += v267.Unit * 0.18
                    end
                end

                local function endSwing(p65) -- line: 581
                    local Swing = p65.Swing

                    if Swing then
                        Swing.Trove:Destroy()
                    end

                    p65.Swing = nil
                    p65.Trail.Enabled = false
                end

                local function beginSwing(p66, p67) -- line: 590
                    -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), Timing (copy), v1 (copy), v2 (copy), DrillaWarn (copy), markDisc (copy), v245 (copy), n5 (ref)
                    local Swing = p66.Swing

                    if Swing then
                        Swing.Trove:Destroy()
                    end

                    p66.Swing = nil
                    p66.Trail.Enabled = false

                    local v268 = Trove.new()
                    local t30 = {
                        Started = n5 - p67,
                        Trove = v268,
                        Marks = {},
                        Fills = {},
                        Whooshed = v1 <= p67,
                        Landed = v2 <= p67
                    }

                    p66.Swing = t30

                    if v2 <= p67 then
                        return
                    end

                    for _, v269 in p66.Rig.Crossings do
                        local v270 = Vector3.new(v269.Point.X, v269.Surface, v269.Point.Z)
                        local v271 = v269.Radius * 2.5

                        table.insert(t30.Marks, (markDisc(v268, v270, v271, "KrakenMark")))
                        table.insert(t30.Fills, (markDisc(v268, v270 + Vector3.new(0, 0.05, 0), v271, "KrakenFill")))
                    end

                    if #t30.Marks > 0 then
                        local Impact = p66.Rig.Impact
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v272 = 0

                        if Position ~= nil then
                            local v274 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                            v272 = 1 - v274 * v274 * (3 - v274 * 2)
                        end

                        if v272 > 0 then
                            local CurrentCamera = Workspace.CurrentCamera
                            local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                            if Position and (Position - p66.Rig.Impact).Magnitude <= 700 then
                                Audio.Play(DrillaWarn, p66.Rig.Impact, {
                                    MaxDistance = 700
                                })
                            end
                        end
                    end

                    local Impact = p66.Rig.Impact

                    if GuiService.ReducedMotionEnabled then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                    local v275 = 0

                    if Position ~= nil then
                        local v277 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                        v275 = 1 - v277 * v277 * (3 - v277 * 2)
                    end

                    if not (v275 <= 0.02) then
                        v245:ShakeOnce(v275 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                    end
                end

                local function paintMarks(p68, p69) -- line: 623
                    -- upvalues: v2 (copy), t3 (copy)
                    if #p68.Marks == 0 then
                        return
                    end

                    if v2 + 0.15 <= p69 then
                        for _, v278 in p68.Marks do
                            v278:Destroy()
                        end

                        for _, v279 in p68.Fills do
                            v279:Destroy()
                        end

                        table.clear(p68.Marks)
                        table.clear(p68.Fills)
                    else
                        local v281 = math.clamp(p69 / v2, 0, 1)
                        local v284 = math.lerp(t3[1], t3[2], v281)
                        local v285 = if v2 < p69 then (p69 - v2) / 0.15 else 0
                        local v288 = math.lerp(0.72, 0.45, v281) + math.sin(p69 * v284) * 0.12

                        for v289, v290 in p68.Marks do
                            v290.Transparency = math.lerp(math.clamp(v288, 0, 1), 1, v285)

                            local v292 = p68.Fills[v289]
                            local v294 = math.max(v290.Size.Y * v281, 0.2)

                            v292.Size = Vector3.new(0.2, v294, v294)
                            v292.Transparency = math.lerp(0.35, 1, v285)
                        end
                    end
                end

                local function swingAngles(p70, p71) -- line: 652
                    -- upvalues: KrakenRig (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                    local Rig = p70.Rig
                    local v295 = table.create(#Rig.Joints, 0)

                    for i = 1, #Rig.Joints do
                        local v297 = Raise[math.min(i, #Raise)]
                        local v298 = KrakenRig.StrikeAngle(Rig, i)

                        if p71 < Timing.Windup then
                            v298 = v297 * (-(math.cos(3.141592653589793 * math.clamp(p71 / Timing.Windup, 0, 1)) - 1) / 2)
                        elseif p71 < v1 then
                            local v301 = (p71 - Timing.Windup) / Timing.Hold

                            v298 = v297 * (1 + 0.06000000000000005 * v301) + math.sin(p71 * 46 + i) * 0.7 * v301
                        elseif p71 < v2 + (i - 1) * 0.04 then
                            local v304 = (p71 - v1 - (i - 1) * 0.04) / Timing.Strike
                            local v305 = v297 * 1.06
                            local v306 = math.clamp(v304, 0, 1)

                            v298 = math.lerp(v305, v298, v306 * v306 * v306)
                        elseif p71 < v3 then
                            local v309 = math.clamp((p71 - v2) / Timing.Settle, 0, 1)

                            if i == 1 then
                                v298 -= math.sin(v309 * 3.141592653589793) * 3
                            else
                                v298 += math.sin(v309 * 3.141592653589793 * 2) * 7 * (1 - v309)
                            end
                        elseif not (p71 < v4) then
                            local v313 = math.clamp((p71 - v4) / Timing.Recover, 0, 1) - 1

                            v298 *= 1 - (v313 * 2.4 * v313 * v313 + 1 + v313 * 1.4 * v313)
                        end

                        v295[i] = v298
                    end

                    return v295
                end

                local function poseArm(p72) -- line: 685
                    -- upvalues: Audio (copy), KrakenRig (copy), t1 (copy), t2 (copy), Timing (copy), v1 (copy), v2 (copy), v5 (copy), n5 (ref), land (copy), paintMarks (copy), swingAngles (copy)
                    local Rig, Swing = p72.Rig, p72.Swing
                    local v314, v315

                    if Swing then
                        local v317 = n5
                        local v316 = v317 - Swing.Started

                        if v5 <= v316 then
                            local Swing = p72.Swing

                            if Swing then
                                Swing.Trove:Destroy()
                            end

                            p72.Swing = nil
                            v315 = 1
                            p72.Trail.Enabled = false
                        else
                            v314 = swingAngles(p72, v316)
                            v315 = math.lerp(1, 0.2, (math.clamp(math.min(v316 / Timing.Windup, (v5 - v316) / Timing.Recover, 1), 0, 1)))
                            paintMarks(Swing, v316)

                            if not Swing.Whooshed and v1 <= v316 then
                                Swing.Whooshed = true
                                p72.Trail.Enabled = true
                                Audio.Play(9113077334, p72.Tip, {
                                    MaxDistance = 2400,
                                    Volume = 0.9,
                                    PlaybackSpeed = { 0.75, 0.85 }
                                })
                            end

                            if not Swing.Landed and v2 <= v316 then
                                Swing.Landed = true
                                land(p72)
                            end

                            if p72.Trail.Enabled and v2 + 0.2 <= v316 then
                                p72.Trail.Enabled = false
                            end
                        end
                    else
                        v315 = 1
                    end

                    for v322, v323 in Rig.Joints do
                        local v324 = n5 * 3.141592653589793 * 2 / 5.6 + p72.Phase - v322 * 0.75
                        local v325 = n5 * 3.141592653589793 * 2 / 7.3 + p72.Phase * 1.7 - v322 * 0.75
                        local v327 = t1[math.min(v322, #t1)] * math.sin(v324) * v315
                        local v329 = t2[math.min(v322, #t2)] * math.sin(v325) * v315

                        if v314 then
                            v327 += v314[v322]
                        end

                        local v330 = CFrame.fromAxisAngle(Rig.Curl, (math.rad(v327))) * CFrame.fromAxisAngle(p72.Sway, (math.rad(v329)))

                        KrakenRig.Drive(v323, KrakenRig.About(v323.Pivot, v330))
                    end
                end

                local function poseHead(p73) -- line: 734
                    -- upvalues: KrakenRig (copy), t25 (ref), n5 (ref)
                    local t31 = t25

                    if t31 == nil then
                        return
                    end

                    local v331 = -t31.Tilt * 18 - t31.TiltSpeed * 4.5

                    t31.TiltSpeed += v331 * p73
                    t31.Tilt += t31.TiltSpeed * p73

                    local v332 = n5 * 3.141592653589793 * 2
                    local v334 = math.sin(v332 / 6.4) * 3.5
                    local v343 = CFrame.Angles(math.rad(math.sin(v332 / 8.32) * 1.1), math.rad(math.sin(v332 / 13.440000000000001 + 1) * 1.6), (math.rad(math.sin(v332 / 10.88 + 2) * 1.1)))
                    local identity = CFrame.identity

                    if t31.Tilt.Magnitude > 1E-04 then
                        identity = CFrame.fromAxisAngle((Vector3.new(0, 1, 0)):Cross(t31.Tilt.Unit), t31.Tilt.Magnitude)
                    end

                    KrakenRig.Drive(t31.Joint, CFrame.new(0, v334, 0) * KrakenRig.About(t31.Joint.Pivot, identity * v343))
                end

                local function rest() -- line: 761
                    -- upvalues: t24 (copy), t25 (ref)
                    for _, v344 in t24 do
                        local Swing = v344.Swing

                        if Swing then
                            Swing.Trove:Destroy()
                        end

                        v344.Swing = nil
                        v344.Trail.Enabled = false

                        for _, v345 in v344.Rig.Joints do
                            v345.Motor.Transform = CFrame.identity
                        end
                    end

                    if t25 then
                        t25.Joint.Motor.Transform = CFrame.identity
                    end
                end

                local function nearby() -- line: 773
                    -- upvalues: Workspace (copy), v253 (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    return Position ~= nil and (Position - v253).Magnitude <= 2800
                end

                v244:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p74, p75, p76) -- line: 780
                    -- upvalues: Workspace (copy), v5 (copy), t24 (copy), v253 (copy), beginSwing (copy)
                    if p74 ~= "Kraken" or typeof(p75) ~= "Instance" or type(p76) ~= "number" then
                        return
                    end

                    local v346 = t24[p75]

                    if v346 == nil then
                        return
                    end

                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position ~= nil and (Position - v253).Magnitude <= 2800 then
                        local v348 = math.max(0, Workspace:GetServerTimeNow() - p76)

                        if v348 < v5 then
                            beginSwing(v346, v348)
                        end
                    end
                end)
                v244:Connect(RunService.PreSimulation, function(p77) -- line: 799
                    -- upvalues: Workspace (copy), v242 (copy), t24 (copy), v253 (copy), n5 (ref), n6 (ref), v254 (ref), poseArm (copy), poseHead (copy), rest (copy)
                    local CurrentCamera = Workspace.CurrentCamera
                    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                    if Position ~= nil and (Position - v253).Magnitude <= 2800 then
                        v254 = false

                        local KrakenSpeed = v242:GetAttribute("KrakenSpeed")

                        if type(KrakenSpeed) ~= "number" or not (KrakenSpeed > 0) then
                            KrakenSpeed = 1
                        end

                        n6 = KrakenSpeed

                        local v349 = p77 * n6

                        n5 += v349

                        for _, v350 in t24 do
                            poseArm(v350)
                        end

                        poseHead((math.min(v349, 0.05)))
                    elseif not v254 then
                        v254 = true
                        rest()
                    end
                end)
                v244:AttachToInstance(v242)
            end
        end)
    end)

    for _, v351 in CollectionService:GetTagged(MountRace.TrackTag) do
        if t15[v351] == nil and v351:IsDescendantOf(Workspace) then
            t15[v351] = true

            local spawn = task.spawn
            local v352 = false

            spawn(function() -- line: 430
                -- upvalues: v351 (copy), v352 (copy), GuiService (copy), RunService (copy), Workspace (copy), Audio (copy), CameraShaker (copy), CameraShakerDriver (copy), KrakenRig (copy), Remotes (copy), Trove (copy), t1 (copy), t2 (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy), DrillaWarn (copy), v8 (copy), t4 (copy), t5 (copy), v10 (copy), findTrackParts (copy), rumblePad (copy), emitBurst (copy), markDisc (copy)
                local v353, v354 = findTrackParts(v351, v352)

                if v353 ~= nil and v354 ~= nil then
                    local v355 = Trove.new()
                    local v356 = CameraShaker.new()

                    CameraShakerDriver.Start(v356, Enum.RenderPriority.Last.Value)
                    v355:Add(function() -- line: 439
                        -- upvalues: CameraShakerDriver (copy), v356 (copy)
                        CameraShakerDriver.Stop(v356)
                    end)

                    local t32 = {}
                    local t33, t34

                    for _, child in v353:GetChildren() do
                        if child:IsA("Model") then
                            local v357 = KrakenRig.Head(child)

                            if v357 then
                                t34 = {
                                    Tilt = Vector3.new(0, 0, 0),
                                    TiltSpeed = Vector3.new(0, 0, 0),
                                    Joint = v357,
                                    Center = v357.Motor.Part1.Position
                                }
                                t33 = t34
                            else
                                local function poseOf() -- line: 461
                                    -- upvalues: KrakenRig (copy), child (copy)
                                    return KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 }
                                end

                                local v358 = KrakenRig.Arm(child, v354, {
                                    v353
                                }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                                if v358 ~= nil then
                                    local v359 = v358.Segments[#v358.Segments]
                                    local v360 = v355:Add(Instance.new("Attachment"))

                                    v360.Name = "KrakenTip"
                                    v360.WorldPosition = v358.Tip
                                    v360.Parent = v359

                                    local v361 = v355:Add(Instance.new("Attachment"))

                                    v361.Name = "KrakenTipTail"
                                    v361.WorldPosition = v358.Tip + (v359.Position - v358.Tip).Unit * 22
                                    v361.Parent = v359

                                    local v362 = v355:Add(Instance.new("Trail"))

                                    v362.Attachment0 = v360
                                    v362.Attachment1 = v361
                                    v362.Lifetime = 0.22
                                    v362.MinLength = 0.5
                                    v362.FaceCamera = true
                                    v362.LightEmission = 0.35
                                    v362.Color = ColorSequence.new(v8)
                                    v362.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0.35),
                                        NumberSequenceKeypoint.new(1, 1)
                                    })
                                    v362.Enabled = false
                                    v362.Parent = v359

                                    local t36 = {
                                        Swing = nil,
                                        Rig = v358,
                                        Sway = v358.Heading,
                                        Phase = v10:NextNumber(0, 6.283185307179586),
                                        Tip = v360,
                                        Trail = v362
                                    }

                                    t32[child] = t36
                                    v355:Connect(child:GetAttributeChangedSignal(KrakenRig.Attribute), function() -- line: 503
                                        -- upvalues: KrakenRig (copy), v353 (copy), v354 (copy), child (copy), t36 (copy)
                                        local v363 = KrakenRig.Arm(child, v354, {
                                            v353
                                        }, KrakenRig.Decode(child:GetAttribute(KrakenRig.Attribute)) or { 0, 0, 0 })

                                        if v363 ~= nil then
                                            t36.Rig = v363
                                        end
                                    end)
                                end
                            end
                        end
                    end

                    if next(t32) == nil and t34 == nil then
                        v355:Destroy()

                        return
                    end

                    local v364 = if t34 then t34.Center else next(t32):GetPivot().Position
                    local n7 = 0
                    local n8 = 1
                    local v365 = true

                    local function gainAt(p78) -- line: 520
                        -- upvalues: Workspace (copy)
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                        if Position == nil then
                            return 0
                        end

                        local v367 = math.clamp(((Position - p78).Magnitude - 150) / 800, 0, 1)

                        return 1 - v367 * v367 * (3 - v367 * 2)
                    end

                    local function shakeFor(p79, p80, p81) -- line: 528
                        -- upvalues: GuiService (copy), Workspace (copy), Timing (copy), rumblePad (copy), v356 (copy)
                        if GuiService.ReducedMotionEnabled then
                            return
                        end

                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v368 = 0

                        if Position ~= nil then
                            local v370 = math.clamp(((Position - p79).Magnitude - 150) / 800, 0, 1)

                            v368 = 1 - v370 * v370 * (3 - v370 * 2)
                        end

                        if not (v368 <= 0.02) then
                            if p80 then
                                v356:ShakeOnce(v368 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                            else
                                v356:ShakeOnce(v368 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                                v356:ShakeOnce(v368 * 2.6, 2.5, 0.05, 1.8)

                                if p81 and v368 >= 0.5 then
                                    rumblePad((math.clamp(v368, 0, 1)))
                                end
                            end
                        end
                    end

                    local function land(p82) -- line: 555
                        -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), t4 (copy), t5 (copy), rumblePad (copy), emitBurst (copy), v356 (copy), t33 (ref), n8 (ref)
                        local Rig = p82.Rig
                        local v371 = Trove.new()

                        emitBurst(v371, Rig.Impact, if Rig.Wet then t4 else t5, n8)
                        task.delay(4.5 / n8, function() -- line: 559
                            -- upvalues: v371 (copy)
                            v371:Destroy()
                        end)
                        Audio.Play(Rig.Wet and 9119476512 or 9114036511, Rig.Impact, {
                            MaxDistance = 2400,
                            Volume = { 1.1, 1.3 },
                            PlaybackSpeed = { 0.82, 0.92 }
                        })
                        Audio.Play(9114036511, Rig.Impact, {
                            MaxDistance = 2400,
                            Volume = { 0.7, 0.85 },
                            PlaybackSpeed = { 0.7, 0.8 }
                        })

                        local Impact2 = Rig.Impact
                        local v373 = #Rig.Crossings > 0

                        if not GuiService.ReducedMotionEnabled then
                            local CurrentCamera = Workspace.CurrentCamera
                            local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                            local v374 = 0

                            if Position ~= nil then
                                local v376 = math.clamp(((Position - Impact2).Magnitude - 150) / 800, 0, 1)

                                v374 = 1 - v376 * v376 * (3 - v376 * 2)
                            end

                            if not (v374 <= 0.02) then
                                v356:ShakeOnce(v374 * 6.5, 9, 0, 0.9, Vector3.new(0.35, 0.5, 0.35), (Vector3.new(1, 0.55, 0.45)))
                                v356:ShakeOnce(v374 * 2.6, 2.5, 0.05, 1.8)

                                if v373 and v374 >= 0.5 then
                                    rumblePad((math.clamp(v374, 0, 1)))
                                end
                            end
                        end

                        if not t33 then
                            return
                        end

                        local v377 = Rig.Impact - t33.Center
                        local v378 = Vector3.new(v377.X, 0, v377.Z)

                        if v378.Magnitude > 1 then
                            local t37 = t33

                            t37.TiltSpeed += v378.Unit * 0.18
                        end
                    end

                    local function endSwing(p83) -- line: 581
                        local Swing = p83.Swing

                        if Swing then
                            Swing.Trove:Destroy()
                        end

                        p83.Swing = nil
                        p83.Trail.Enabled = false
                    end

                    local function beginSwing(p84, p85) -- line: 590
                        -- upvalues: GuiService (copy), Workspace (copy), Audio (copy), Trove (copy), Timing (copy), v1 (copy), v2 (copy), DrillaWarn (copy), markDisc (copy), v356 (copy), n7 (ref)
                        local Swing = p84.Swing

                        if Swing then
                            Swing.Trove:Destroy()
                        end

                        p84.Swing = nil
                        p84.Trail.Enabled = false

                        local v379 = Trove.new()
                        local t38 = {
                            Started = n7 - p85,
                            Trove = v379,
                            Marks = {},
                            Fills = {},
                            Whooshed = v1 <= p85,
                            Landed = v2 <= p85
                        }

                        p84.Swing = t38

                        if v2 <= p85 then
                            return
                        end

                        for _, v380 in p84.Rig.Crossings do
                            local v381 = Vector3.new(v380.Point.X, v380.Surface, v380.Point.Z)
                            local v382 = v380.Radius * 2.5

                            table.insert(t38.Marks, (markDisc(v379, v381, v382, "KrakenMark")))
                            table.insert(t38.Fills, (markDisc(v379, v381 + Vector3.new(0, 0.05, 0), v382, "KrakenFill")))
                        end

                        if #t38.Marks > 0 then
                            local Impact = p84.Rig.Impact
                            local CurrentCamera = Workspace.CurrentCamera
                            local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                            local v383 = 0

                            if Position ~= nil then
                                local v385 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                                v383 = 1 - v385 * v385 * (3 - v385 * 2)
                            end

                            if v383 > 0 then
                                local CurrentCamera = Workspace.CurrentCamera
                                local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                                if Position and (Position - p84.Rig.Impact).Magnitude <= 700 then
                                    Audio.Play(DrillaWarn, p84.Rig.Impact, {
                                        MaxDistance = 700
                                    })
                                end
                            end
                        end

                        local Impact = p84.Rig.Impact

                        if GuiService.ReducedMotionEnabled then
                            return
                        end

                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil
                        local v386 = 0

                        if Position ~= nil then
                            local v388 = math.clamp(((Position - Impact).Magnitude - 150) / 800, 0, 1)

                            v386 = 1 - v388 * v388 * (3 - v388 * 2)
                        end

                        if not (v386 <= 0.02) then
                            v356:ShakeOnce(v386 * 0.8, 3, Timing.Windup * 0.8, 0.4)
                        end
                    end

                    local function paintMarks(p86, p87) -- line: 623
                        -- upvalues: v2 (copy), t3 (copy)
                        if #p86.Marks == 0 then
                            return
                        end

                        if v2 + 0.15 <= p87 then
                            for _, v389 in p86.Marks do
                                v389:Destroy()
                            end

                            for _, v390 in p86.Fills do
                                v390:Destroy()
                            end

                            table.clear(p86.Marks)
                            table.clear(p86.Fills)
                        else
                            local v392 = math.clamp(p87 / v2, 0, 1)
                            local v395 = math.lerp(t3[1], t3[2], v392)
                            local v396 = if v2 < p87 then (p87 - v2) / 0.15 else 0
                            local v399 = math.lerp(0.72, 0.45, v392) + math.sin(p87 * v395) * 0.12

                            for v400, v401 in p86.Marks do
                                v401.Transparency = math.lerp(math.clamp(v399, 0, 1), 1, v396)

                                local v403 = p86.Fills[v400]
                                local v405 = math.max(v401.Size.Y * v392, 0.2)

                                v403.Size = Vector3.new(0.2, v405, v405)
                                v403.Transparency = math.lerp(0.35, 1, v396)
                            end
                        end
                    end

                    local function swingAngles(p88, p89) -- line: 652
                        -- upvalues: KrakenRig (copy), Timing (copy), Raise (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                        local Rig = p88.Rig
                        local v406 = table.create(#Rig.Joints, 0)

                        for i = 1, #Rig.Joints do
                            local v408 = Raise[math.min(i, #Raise)]
                            local v409 = KrakenRig.StrikeAngle(Rig, i)

                            if p89 < Timing.Windup then
                                v409 = v408 * (-(math.cos(3.141592653589793 * math.clamp(p89 / Timing.Windup, 0, 1)) - 1) / 2)
                            elseif p89 < v1 then
                                local v412 = (p89 - Timing.Windup) / Timing.Hold

                                v409 = v408 * (1 + 0.06000000000000005 * v412) + math.sin(p89 * 46 + i) * 0.7 * v412
                            elseif p89 < v2 + (i - 1) * 0.04 then
                                local v415 = (p89 - v1 - (i - 1) * 0.04) / Timing.Strike
                                local v416 = v408 * 1.06
                                local v417 = math.clamp(v415, 0, 1)

                                v409 = math.lerp(v416, v409, v417 * v417 * v417)
                            elseif p89 < v3 then
                                local v420 = math.clamp((p89 - v2) / Timing.Settle, 0, 1)

                                if i == 1 then
                                    v409 -= math.sin(v420 * 3.141592653589793) * 3
                                else
                                    v409 += math.sin(v420 * 3.141592653589793 * 2) * 7 * (1 - v420)
                                end
                            elseif not (p89 < v4) then
                                local v424 = math.clamp((p89 - v4) / Timing.Recover, 0, 1) - 1

                                v409 *= 1 - (v424 * 2.4 * v424 * v424 + 1 + v424 * 1.4 * v424)
                            end

                            v406[i] = v409
                        end

                        return v406
                    end

                    local function poseArm(p90) -- line: 685
                        -- upvalues: Audio (copy), KrakenRig (copy), t1 (copy), t2 (copy), Timing (copy), v1 (copy), v2 (copy), v5 (copy), n7 (ref), land (copy), paintMarks (copy), swingAngles (copy)
                        local Rig, Swing = p90.Rig, p90.Swing
                        local v425, v426

                        if Swing then
                            local v428 = n7
                            local v427 = v428 - Swing.Started

                            if v5 <= v427 then
                                local Swing = p90.Swing

                                if Swing then
                                    Swing.Trove:Destroy()
                                end

                                p90.Swing = nil
                                v426 = 1
                                p90.Trail.Enabled = false
                            else
                                v425 = swingAngles(p90, v427)
                                v426 = math.lerp(1, 0.2, (math.clamp(math.min(v427 / Timing.Windup, (v5 - v427) / Timing.Recover, 1), 0, 1)))
                                paintMarks(Swing, v427)

                                if not Swing.Whooshed and v1 <= v427 then
                                    Swing.Whooshed = true
                                    p90.Trail.Enabled = true
                                    Audio.Play(9113077334, p90.Tip, {
                                        MaxDistance = 2400,
                                        Volume = 0.9,
                                        PlaybackSpeed = { 0.75, 0.85 }
                                    })
                                end

                                if not Swing.Landed and v2 <= v427 then
                                    Swing.Landed = true
                                    land(p90)
                                end

                                if p90.Trail.Enabled and v2 + 0.2 <= v427 then
                                    p90.Trail.Enabled = false
                                end
                            end
                        else
                            v426 = 1
                        end

                        for v433, v434 in Rig.Joints do
                            local v435 = n7 * 3.141592653589793 * 2 / 5.6 + p90.Phase - v433 * 0.75
                            local v436 = n7 * 3.141592653589793 * 2 / 7.3 + p90.Phase * 1.7 - v433 * 0.75
                            local v438 = t1[math.min(v433, #t1)] * math.sin(v435) * v426
                            local v440 = t2[math.min(v433, #t2)] * math.sin(v436) * v426

                            if v425 then
                                v438 += v425[v433]
                            end

                            local v441 = CFrame.fromAxisAngle(Rig.Curl, (math.rad(v438))) * CFrame.fromAxisAngle(p90.Sway, (math.rad(v440)))

                            KrakenRig.Drive(v434, KrakenRig.About(v434.Pivot, v441))
                        end
                    end

                    local function poseHead(p91) -- line: 734
                        -- upvalues: KrakenRig (copy), t33 (ref), n7 (ref)
                        local t39 = t33

                        if t39 == nil then
                            return
                        end

                        local v442 = -t39.Tilt * 18 - t39.TiltSpeed * 4.5

                        t39.TiltSpeed += v442 * p91
                        t39.Tilt += t39.TiltSpeed * p91

                        local v443 = n7 * 3.141592653589793 * 2
                        local v445 = math.sin(v443 / 6.4) * 3.5
                        local v454 = CFrame.Angles(math.rad(math.sin(v443 / 8.32) * 1.1), math.rad(math.sin(v443 / 13.440000000000001 + 1) * 1.6), (math.rad(math.sin(v443 / 10.88 + 2) * 1.1)))
                        local identity = CFrame.identity

                        if t39.Tilt.Magnitude > 1E-04 then
                            identity = CFrame.fromAxisAngle((Vector3.new(0, 1, 0)):Cross(t39.Tilt.Unit), t39.Tilt.Magnitude)
                        end

                        KrakenRig.Drive(t39.Joint, CFrame.new(0, v445, 0) * KrakenRig.About(t39.Joint.Pivot, identity * v454))
                    end

                    local function rest() -- line: 761
                        -- upvalues: t32 (copy), t33 (ref)
                        for _, v455 in t32 do
                            local Swing = v455.Swing

                            if Swing then
                                Swing.Trove:Destroy()
                            end

                            v455.Swing = nil
                            v455.Trail.Enabled = false

                            for _, v456 in v455.Rig.Joints do
                                v456.Motor.Transform = CFrame.identity
                            end
                        end

                        if t33 then
                            t33.Joint.Motor.Transform = CFrame.identity
                        end
                    end

                    local function nearby() -- line: 773
                        -- upvalues: Workspace (copy), v364 (copy)
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                        return Position ~= nil and (Position - v364).Magnitude <= 2800
                    end

                    v355:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p92, p93, p94) -- line: 780
                        -- upvalues: Workspace (copy), v5 (copy), t32 (copy), v364 (copy), beginSwing (copy)
                        if p92 ~= "Kraken" or typeof(p93) ~= "Instance" or type(p94) ~= "number" then
                            return
                        end

                        local v457 = t32[p93]

                        if v457 == nil then
                            return
                        end

                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                        if Position ~= nil and (Position - v364).Magnitude <= 2800 then
                            local v459 = math.max(0, Workspace:GetServerTimeNow() - p94)

                            if v459 < v5 then
                                beginSwing(v457, v459)
                            end
                        end
                    end)
                    v355:Connect(RunService.PreSimulation, function(p95) -- line: 799
                        -- upvalues: Workspace (copy), v353 (copy), t32 (copy), v364 (copy), n7 (ref), n8 (ref), v365 (ref), poseArm (copy), poseHead (copy), rest (copy)
                        local CurrentCamera = Workspace.CurrentCamera
                        local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

                        if Position ~= nil and (Position - v364).Magnitude <= 2800 then
                            v365 = false

                            local KrakenSpeed = v353:GetAttribute("KrakenSpeed")

                            if type(KrakenSpeed) ~= "number" or not (KrakenSpeed > 0) then
                                KrakenSpeed = 1
                            end

                            n8 = KrakenSpeed

                            local v460 = p95 * n8

                            n7 += v460

                            for _, v461 in t32 do
                                poseArm(v461)
                            end

                            poseHead((math.min(v460, 0.05)))
                        elseif not v365 then
                            v365 = true
                            rest()
                        end
                    end)
                    v355:AttachToInstance(v353)
                end
            end)
        end
    end
end

return t6

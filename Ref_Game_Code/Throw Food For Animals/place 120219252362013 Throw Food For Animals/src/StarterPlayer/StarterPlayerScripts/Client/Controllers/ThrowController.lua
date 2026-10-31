-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local FoodsConfig = require(ReplicatedStorage.Config.FoodsConfig)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local ProjectileMath = require(ReplicatedStorage.Shared.ProjectileMath)
local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)
local RigDresser = require(ReplicatedStorage.Shared.RigDresser)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Signal = require(ReplicatedStorage.Shared.Signal)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local HUDController = require(Parent.HUDController)
local ThrowMeter = require(Parent.ThrowMeter)
local SuperThrow = require(Parent.SuperThrow)
local LuckMeter = require(Parent.LuckMeter)
local AreaBanner = require(Parent.AreaBanner)
local RevealSequence = require(Parent.RevealSequence)
local ClientState = require(Parent.ClientState)
local Movement = require(Parent.Movement)
local FogController = require(Parent.FogController)
local MusicController = require(Parent.MusicController)
local t1 = {
    Finished = Signal.new()
}
local LocalPlayer = Players.LocalPlayer
local v1 = false
local StarterArea, v2
local n1 = 0

local function setOtherPlayersVisible(p1) -- line: 90
    -- upvalues: Players (copy), RigDresser (copy), LocalPlayer (copy)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            RigDresser.SetCharacterVisible(player.Character, p1, true)
        end
    end
end

local function makeDust(p2, p3, p4, p5, p6) -- line: 98
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Position = p2
    Part.Parent = p6 or workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(p3 or Color3.fromRGB(200, 190, 170))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p5 or 1.5),
        NumberSequenceKeypoint.new(1, (p5 or 1.5) * 2.2)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(6, 14)
    ParticleEmitter.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p4 or 25)
    task.delay(2, function() -- line: 119
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function statRowRect(p7) -- line: 125
    -- upvalues: LocalPlayer (copy)
    local StatsGui = LocalPlayer.PlayerGui:FindFirstChild("StatsGui")
    local Container = StatsGui and StatsGui:FindFirstChild("Container")
    local v3 = Container and Container:FindFirstChild(p7 or "ThrowPowerDisplay")

    if v3 and v3.Visible and not (v3.AbsoluteSize.X < 1) then
        local zero = StatsGui.IgnoreGuiInset and Vector2.zero or game:GetService("GuiService"):GetGuiInset()

        return {
            Row = v3,
            Position = v3.AbsolutePosition + zero,
            Size = v3.AbsoluteSize
        }
    end

    return nil
end

local function makeStatDisplay(p8, p9, p10, p11) -- line: 136
    if not p9 then
        return nil
    end

    local clone = p9.Row:Clone()

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant.Name == "PowerCog" or descendant.Name == "BoostBadge" or descendant:IsA("UIScale") then
            descendant:Destroy()
        end
    end

    clone.Name = p11 or "ThrowPower"
    clone.AnchorPoint = Vector2.zero
    clone.Position = UDim2.fromOffset(p9.Position.X, p9.Position.Y)
    clone.Size = UDim2.fromOffset(p9.Size.X, p9.Size.Y)
    clone.Visible = true

    local ValueLabel = clone:FindFirstChild("ValueLabel")

    if ValueLabel then
        ValueLabel.Text = tostring(p10)
    end

    clone.Parent = p8

    return clone
end

local function landingRing(p12, p13) -- line: 153
    -- upvalues: TweenService (copy)
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.new(1, 1, 1)
    Part.Transparency = 0.2
    Part.Size = Vector3.new(0.2, 1, 1)
    Part.CFrame = CFrame.new(p12 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = p13 or workspace
    TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, 14, 14),
        Transparency = 1
    }):Play()
    task.delay(0.7, function() -- line: 166
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function runSequence(p14) -- line: 173
    -- upvalues: RunService (copy), TweenService (copy), ReplicatedStorage (copy), GameConfig (copy), FoodsConfig (copy), AnimalUtil (copy), AreaUtil (copy), ProjectileMath (copy), AnimationLibrary (copy), RigDresser (copy), Remotes (copy), Janitor (copy), DataController (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), ThrowMeter (copy), SuperThrow (copy), LuckMeter (copy), AreaBanner (copy), RevealSequence (copy), Movement (copy), FogController (copy), t1 (copy), LocalPlayer (copy), setOtherPlayersVisible (copy), makeDust (copy), statRowRect (copy), makeStatDisplay (copy), landingRing (copy)
    local v4 = Janitor.new()
    local Character = LocalPlayer.Character
    local v5 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v6 = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (v5 and v6) then
        return false, "NoCharacter"
    end

    local v7 = UIKit.ScreenGui("ThrowSequence", 150, true)

    v4:Add(v7)

    local Folder = Instance.new("Folder")

    Folder.Name = "ThrowSequence_" .. LocalPlayer.Name
    Folder.Parent = workspace
    v4:Add(Folder)
    Movement.Lock()
    v4:Add(function() -- line: 188
        -- upvalues: Movement (copy)
        Movement.Unlock()
    end)

    local ThrowPowerDisplay = statRowRect("ThrowPowerDisplay")
    local v11 = math.max(0, (math.floor(tonumber(p14.Saved) or 0)))
    local v12 = v11 > 0 and statRowRect("LuckyThrowsDisplay") or nil

    HUDController.SetGameplayVisible(false, {
        ServerLuckHUD = true
    })
    v4:Add(function() -- line: 195
        -- upvalues: HUDController (copy)
        HUDController.SetGameplayVisible(true)
    end)
    ScreenFX.Cover(Color3.new(0, 0, 0))

    local v13 = AreaUtil.GetLaunchPosition()
    local v9 = v6.HipHeight + v5.Size.Y / 2
    local lookAt = CFrame.lookAt(v13 + Vector3.new(0, v9 + 0.1, 0), v13 + Vector3.new(0, v9 + 0.1, -10))

    v5.Anchored = true
    v5.CFrame = lookAt
    RigDresser.SetCharacterVisible(Character, false, true)
    setOtherPlayersVisible(false)
    v4:Add(function() -- line: 206
        -- upvalues: Character (copy), RigDresser (copy), setOtherPlayersVisible (copy)
        RigDresser.SetCharacterVisible(Character, true, true)
        setOtherPlayersVisible(true)
    end)
    v9 = ReplicatedStorage.Rigs.ThrowRig:Clone()
    RigDresser.PrepareRig(v9)
    RigDresser.Dress(v9, Character)
    v9:PivotTo((CFrame.lookAt(v13 + Vector3.new(0, 3, 0), v13 + Vector3.new(0, 3, -10))))
    v9.Parent = Folder

    local HumanoidRootPart = v9.HumanoidRootPart
    local v16 = v9:FindFirstChild("Right Arm")
    local v8 = FoodsConfig.Get(p14.FoodIndex) or FoodsConfig.Get(1)
    local v17 = AnimalUtil.CreateFood(v8.ModelName)
    local connection, ThrowPower, v18, v19

    if v17 then
        AnimalUtil.ScaleFoodToLongest(v17, GameConfig.Plot.HandFoodSize)
        v19 = AnimalUtil.GetFoodLongest(v17) / 2
        ThrowPower = v16 and v16:FindFirstChild("RightGripAttachment")

        if ThrowPower then
            v18 = ThrowPower.CFrame
        end

        if not ThrowPower or not v18 then
            v18 = CFrame.new(0, -1, 0)
        end

        local v20 = v18 * CFrame.new(0, -0.2, -0.3) * CFrame.Angles(-0.3490658503988659, 0.6108652381980153, 0)

        v17:PivotTo(v16.CFrame * v20)
        v17.Parent = Folder
        connection = RunService.Heartbeat:Connect(function() -- line: 235
            -- upvalues: v16 (copy), v17 (copy), v20 (copy)
            if v16 and v16.Parent and v17.Parent then
                v17:PivotTo(v16.CFrame * v20)
            end
        end)
        v4:Add(connection)
    else
        v19 = 0.8
    end

    CameraRig.Take()
    v4:Add(function() -- line: 245
        -- upvalues: CameraRig (copy)
        CameraRig.Release()
    end)
    CameraRig.SetHandheld(0.7)

    local function shotBehind(p15) -- line: 247
        -- upvalues: HumanoidRootPart (copy)
        local _CFrame = HumanoidRootPart.CFrame
        local v21 = _CFrame * CFrame.new(3.2 - p15 * 0.05, 2.4, 7.5)
        local v22 = _CFrame.Position + _CFrame.LookVector * 14 + Vector3.new(0, 0.5, 0)

        return CFrame.lookAt(v21.Position, v22), 62
    end

    CameraRig.SetShot(shotBehind)
    ScreenFX.FadeIn(GameConfig.Sequence.FadeIn)
    ThrowPower = makeStatDisplay(v7, ThrowPowerDisplay, p14.Power or 0, "ThrowPower")

    if ThrowPower then
        UIKit.PopIn(ThrowPower, 0.35, 0.6)
    end

    local LuckyThrows = makeStatDisplay(v7, v12, v11, "LuckyThrows")
    local LuckyThrows2 = LuckyThrows

    if LuckyThrows then
        UIKit.PopIn(LuckyThrows, 0.35, 0.6)
    end

    local v23 = ThrowMeter.new(v7)
    local v24 = SuperThrow.Begin({
        Gui = v7,
        Meter = v23,
        Rig = v9,
        Food = v17,
        Folder = Folder,
        Launch = v13,
        Start = p14
    })

    v4:Add(function() -- line: 265
        -- upvalues: v24 (copy)
        v24:Destroy()
    end)

    v24.OnUsedSaved = function() -- line: 267
        -- upvalues: v11 (copy), LuckyThrows2 (ref), UIKit (copy)
        local LuckyThrows = LuckyThrows2
        local ValueLabel = LuckyThrows and LuckyThrows:FindFirstChild("ValueLabel")

        if not ValueLabel then
            return
        end

        ValueLabel.Text = tostring((math.max(0, v11 - 1)))
        UIKit.Punch(LuckyThrows, 0.2, 0.5)
    end

    local v27 = v23:Run()

    v24:MeterDone()
    v18 = Remotes.Invoke("Throw_Resolve", v27)

    if not v18.Ok then
        v23:Destroy()
        v4:Cleanup()

        return false, v18.Reason
    end

    v24:Resolved(v18)
    task.spawn(AnimationLibrary.EnsureAnimalClips, v18.ModelName)
    CameraRig.SetHandheld(0.5)
    task.delay(0.45, function() -- line: 287
        -- upvalues: v23 (copy)
        v23:Hide()
    end)
    ScreenFX.ShowBars(0.4)
    task.wait(0.35)

    local v28 = AnimationLibrary.Play(v9, AnimationLibrary.GetThrowId(), {
        Looped = false,
        FadeTime = 0.05,
        Priority = Enum.AnimationPriority.Action
    })
    local n2 = 0
    local v29 = false

    local function shotFront(p16) -- line: 297
        -- upvalues: HumanoidRootPart (copy)
        local _CFrame = HumanoidRootPart.CFrame
        local v30 = _CFrame * CFrame.new(-2.2 + p16 * 0.4, 0.9 + p16 * 0.2, -7.5)

        return CFrame.lookAt(v30.Position, _CFrame.Position + Vector3.new(0, 0.6, 0)), 60
    end

    local function shotOrbit(p17) -- line: 303
        -- upvalues: HumanoidRootPart (copy)
        local _CFrame = HumanoidRootPart.CFrame
        local v31 = -2.6179938779914944 + p17 * 4.2
        local v32 = 7.5 - math.min(p17, 0.5) * 1.5
        local v35 = _CFrame:VectorToWorldSpace((Vector3.new(math.sin(v31) * v32, 2.6, math.cos(v31) * v32)))

        return CFrame.lookAt(_CFrame.Position + v35, _CFrame.Position + Vector3.new(0, 1.2, 0)), 66
    end

    if v28 then
        v4:Add(v28:GetMarkerReachedSignal("Smash"):Connect(function() -- line: 312
            -- upvalues: Folder (copy), v13 (copy), HumanoidRootPart (copy), n2 (ref), shotFront (copy), shotOrbit (copy), Sounds (copy), CameraRig (copy), makeDust (copy)
            n2 += 1

            if n2 == 1 then
                CameraRig.BlendTo(shotFront, 0.28, Enum.EasingStyle.Quart)
                CameraRig.Shake(1.1, 0.45, 20)
                Sounds.Play("GroundSmash")
                Sounds.Play("CameraWhoosh", {
                    Volume = 0.4
                })
                makeDust(v13 + HumanoidRootPart.CFrame.LookVector * 1.5, nil, 30, 1.6, Folder)
                CameraRig.PunchFOV(-6, 0.05, 0.35)
            else
                CameraRig.Shake(0.6, 0.3, 22)
                Sounds.Play("GroundSmash", {
                    Volume = 0.6,
                    Pitch = 1.15
                })
                makeDust(v13 + HumanoidRootPart.CFrame.LookVector * 1.2, nil, 16, 1.2, Folder)
                task.delay(0.05, function() -- line: 325
                    -- upvalues: shotOrbit (copy), Sounds (copy), CameraRig (copy)
                    CameraRig.BlendTo(shotOrbit, 0.3, Enum.EasingStyle.Sine)
                    Sounds.Play("SpinWhoosh")
                end)
            end
        end))
        v4:Add(v28:GetMarkerReachedSignal("Throw"):Connect(function() -- line: 331
            -- upvalues: v29 (ref)
            v29 = true
        end))
    end

    local identity = os.clock()

    while not v29 and os.clock() - identity < 1.15 do
        task.wait()
    end

    local Completed

    for _, v36 in ipairs({
            ThrowPower or false,
            LuckyThrows2 or false
        }) do
        if v36 then
            Completed = UIKit.PopOut(v36, 0.22, 0.5).Completed
            Completed:Once(function() -- line: 344
                -- upvalues: v36 (copy)
                v36:Destroy()
            end)
        end
    end

    LuckyThrows2 = nil

    local LandingPosition = v18.LandingPosition

    if connection then
        connection:Disconnect()
    end

    local Position = v17 and v17:GetPivot().Position or v13 + Vector3.new(0, 4, -2)

    identity = CFrame.identity

    local Smash, Angles, Attachment, Trail

    if v8.Rest then
        Angles = CFrame.Angles
        Attachment = v8.Rest[1] or 0
        Smash = math.rad(Attachment)
        Trail = v8.Rest[2] or 0
        Attachment = math.rad(Trail)
        Completed = v8.Rest[3] or 0
        identity = Angles(Smash, Attachment, (math.rad(Completed)))
    end

    local v14 = v19 * 1.8

    if v17 then
        Angles = v17:GetExtentsSize()
        Trail = identity.XVector.Y
        Smash = math.abs(Trail) * Angles.X
        Completed = identity.YVector.Y

        local v37 = Smash + math.abs(Completed) * Angles.Y

        Trail = identity.ZVector.Y
        v14 = v37 + math.abs(Trail) * Angles.Z
    end

    Attachment = v14 / 2 + 0.05

    local v38 = LandingPosition + Vector3.new(0, Attachment, 0)

    v14 = v18.FlightTime or ProjectileMath.FlightTime(v18.Distance or 55)

    local v39 = ProjectileMath.CreateArc(Position, v38, v14)

    if v17 then
        v14 = v17.PrimaryPart
        Smash = Instance.new("Attachment")
        Completed = v19 * 0.5
        Smash.Position = Vector3.new(0, Completed, 0)
        Smash.Parent = v14
        Attachment = Instance.new("Attachment")
        Attachment.Position = Vector3.new(0, -v19 * 0.5, 0)
        Attachment.Parent = v14
        Trail = Instance.new("Trail")
        Trail.Attachment0 = Smash
        Trail.Attachment1 = Attachment
        Trail.Lifetime = 0.35
        Trail.LightEmission = 0.6
        Trail.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 240, 180))
        Trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        Trail.WidthScale = NumberSequence.new(1, 0)
        Trail.Parent = v14
    else
        Trail = nil
    end

    v24:Released(Trail)
    Sounds.Play("ThrowWhoosh")
    CameraRig.PunchFOV(10, 0.05, 0.5)
    CameraRig.Shake(0.5, 0.25, 24)
    ScreenFX.HideBars(0.45)

    local v41 = Sounds.Loop("WindLoop", {
        Volume = 0
    })

    v4:Add(function() -- line: 397
        -- upvalues: v41 (copy)
        if v41 then
            v41:Stop(0.2)
        end
    end)

    local v42 = LuckMeter.new(v7)

    v4:Add(function() -- line: 400
        -- upvalues: v42 (copy)
        v42:Destroy()
    end)

    local v43 = AreaBanner.new(v7)

    v4:Add(function() -- line: 403
        -- upvalues: v43 (copy)
        v43:Destroy()
    end)

    local ZStart = AreaUtil.Get(1).ZStart
    local v44 = CameraRig.GetCFrame().Position
    local elapsed = os.clock()

    FogController.BeginFlight(v39, elapsed)
    v4:Add(function() -- line: 411
        -- upvalues: FogController (copy)
        FogController.EndFlight()
    end)

    local n3 = 0

    local function shotChase(_) -- line: 413
        -- upvalues: v39 (copy), v44 (ref), elapsed (copy)
        local v46 = math.clamp(os.clock() - elapsed, 0, v39.Duration)
        local v47 = v39:PositionAt(v46)
        local v48 = v39:VelocityAt(v46)
        local Unit = v48.Magnitude > 0.01 and v48.Unit or Vector3.new(0, 0, -1)
        local v49 = Vector3.new(Unit.X, 0, Unit.Z)

        if v49.Magnitude < 0.01 then
            v49 = Vector3.new(0, 0, -1)
        end

        local Unit2 = v49.Unit
        local v50 = v46 / v39.Duration
        local v51 = 9 + v50 * 6
        local v52 = 3.5 + v50 * 3
        local v53 = v47 - Unit2 * v51 + Vector3.new(0, v52, 0) - Unit * 2

        v44 = v44:Lerp(v53, 0.49930672382821006)

        return CFrame.lookAt(v44, v47 + Unit * 4), math.clamp(v48.Magnitude * 0.12, 0, 16) + 66
    end

    CameraRig.BlendTo(shotChase, 0.35, Enum.EasingStyle.Sine)

    local n4 = 0
    local v56

    while true do
        local v57 = os.clock() - elapsed

        if v39.Duration <= v57 then
            break
        end

        v56 = v39:PositionAt(v57)

        if v17 then
            n4 += 0.11666666666666667
            n3 = n4
            v17:PivotTo(CFrame.new(v56) * CFrame.Angles(n4 * 0.7, n4, n4 * 0.3))
        end

        v42:SetDistance(v13.Z - v56.Z)

        if v56.Z <= ZStart then
            v43:SetArea(AreaUtil.GetAreaIndexForZ(v56.Z))
        end

        if v41 then
            v56 = v39:VelocityAt(v57).Magnitude
            v41:SetVolume((math.clamp(v56 / 90, 0.1, 0.7)))
            v41:SetPitch(math.clamp(v56 / 120, 0, 0.5) + 0.85)
        end

        task.wait()
    end

    if v17 then
        v17:PivotTo(CFrame.new(v38) * CFrame.Angles(0, n4, 0) * identity)

        if Trail then
            Trail.Enabled = false
        end
    end

    if v41 then
        v41:Stop(0.3)
    end

    v42:SetDistance(v18.ForwardDistance or v13.Z - LandingPosition.Z)
    v42:Lock()
    v43:SetArea(v18.AreaIndex)
    v56 = math.clamp((v18.Distance or 55) / 400, 0, 1)
    Sounds.Play("LandingHard", {
        Volume = v56 * 0.4 + 0.8,
        Pitch = 0.95 - v56 * 0.25
    })
    Sounds.Play("FOVImpact", {
        Volume = 0.5
    })
    CameraRig.Shake(v56 * 0.6 + 0.9, 0.5, 18)
    CameraRig.PunchFOV(-8, 0.05, 0.4)
    makeDust(LandingPosition, nil, 35, 1.8, Folder)
    landingRing(LandingPosition, Folder)
    v56 = v24:Landed(LandingPosition)

    if v17 then
        task.spawn(function() -- line: 473
            -- upvalues: v17 (copy), identity (ref), v38 (copy), n3 (ref), TweenService (copy)
            local v61 = CFrame.new(v38) * CFrame.Angles(0, n3, 0) * identity
            local v62 = CFrame.new(v38 + Vector3.new(0, 1.6, 0)) * CFrame.Angles(0, n3 + 0.6, 0.3) * identity
            local v63 = CFrame.new(v38) * CFrame.Angles(0, n3 + 0.9, 0) * identity

            local function ease(p19, p20, p21, p22, p23) -- line: 477
                -- upvalues: v17 (copy), TweenService (copy)
                local elapsed = os.clock()

                while v17.Parent do
                    local v65 = math.clamp((os.clock() - elapsed) / p21, 0, 1)

                    v17:PivotTo(p19:Lerp(p20, TweenService:GetValue(v65, p22, p23)))

                    if v65 >= 1 then
                        break
                    end

                    task.wait()
                end
            end

            ease(v61, v62, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            ease(v62, v63, 0.22, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        end)
    end

    local v66 = CameraRig.GetCFrame()

    CameraRig.BlendTo(function(p24) -- line: 492
        -- upvalues: LandingPosition (copy), v66 (copy)
        local v67 = LandingPosition + Vector3.new(0, 0.5, 0)
        local v69 = v66.Position + Vector3.new(0, p24 * 0.4, 0)

        return CFrame.lookAt(v69, v67), 60
    end, 0.4, Enum.EasingStyle.Sine)
    task.wait(0.75 + v56)
    v42:FadeOut(0.25)
    v43:FadeOut(0.25)
    ScreenFX.FadeOut(Color3.new(0, 0, 0), 0.3)
    Trail = false
    HUDController.HideKept("ServerLuckHUD")

    for _, v70 in pairs(DataController:Get("Animals") or {}) do
        if v70.ModelName == v18.ModelName then
            Trail = true
            break
        end

        Trail = false
    end

    RevealSequence.Run({
        Gui = v7,
        Folder = Folder,
        Result = v18,
        FoodPart = v17,
        FoodPosition = LandingPosition,
        Area = AreaUtil.Get(v18.AreaIndex),
        CanSkip = v18.CanSkip == true,
        Owned = Trail
    })
    Sounds.Play("CameraWhoosh", {
        Volume = 0.6,
        Pitch = 0.9
    })
    CameraRig.PunchFOV(14, 0.25, 0.1)
    ScreenFX.FadeOut(Color3.new(1, 1, 1), 0.35)
    ScreenFX.SetVignette(0, 0.1)
    ScreenFX.SetTint(Color3.new(0, 0, 0), 0, 0.1)
    v56 = LocalPlayer:GetAttribute("PlotIndex")
    Trail = v56 and workspace.Plots:FindFirstChild((tostring(v56)))
    v5.Anchored = false

    if Trail then
        v56 = Trail.Position + GameConfig.Plot.EntranceOffset
        Character:PivotTo(CFrame.lookAt(v56, v56 + Vector3.new(0, 0, 1)))
    end

    local v60 = Remotes.Invoke("Throw_Complete")

    v4:Cleanup()
    CameraRig.Release()
    v4 = workspace.CurrentCamera
    v4.CameraType = Enum.CameraType.Custom

    if Trail then
        v4.CFrame = CFrame.lookAt(v5.Position + Vector3.new(0, 6, -12), v5.Position + Vector3.new(0, 2, 10))
    end

    task.wait(0.15)
    ScreenFX.FadeIn(0.6)
    t1.Finished:Fire(v18)

    return true, v60
end

local function pushBack(p25, p26) -- line: 559
    -- upvalues: StarterArea (ref), v2 (ref)
    if not (StarterArea and v2) then
        return
    end

    local Position = StarterArea.Position
    local v71 = StarterArea.Size / 2
    local v77 = Vector3.new(math.clamp(p25.Position.X, Position.X - v71.X + 2, Position.X + v71.X - 2), Position.Y + v71.Y + p26.HipHeight + p25.Size.Y / 2 + 0.1, v2 + 4)

    p25.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    p25.CFrame = CFrame.lookAt(v77, v77 + Vector3.new(0, 0, 1))
end

local function cleanupFailedThrow() -- line: 571
    -- upvalues: RigDresser (copy), Remotes (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), SuperThrow (copy), Movement (copy), FogController (copy), LocalPlayer (copy), setOtherPlayersVisible (copy)
    local Abort = SuperThrow.Abort

    pcall(Abort)

    local Reset = ScreenFX.Reset

    pcall(Reset)

    local Release = CameraRig.Release

    pcall(Release)

    local EndFlight = FogController.EndFlight

    pcall(EndFlight)

    local SetGameplayVisible = HUDController.SetGameplayVisible

    pcall(SetGameplayVisible, true)

    local Unlock = Movement.Unlock

    pcall(Unlock)

    local Character = LocalPlayer.Character

    if Character then
        local SetCharacterVisible = RigDresser.SetCharacterVisible

        pcall(SetCharacterVisible, Character, true, true)

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = false
        end
    end

    pcall(setOtherPlayersVisible, true)

    local v78 = workspace:FindFirstChild("ThrowSequence_" .. LocalPlayer.Name)

    if v78 then
        v78:Destroy()
    end

    local ThrowSequence = LocalPlayer.PlayerGui:FindFirstChild("ThrowSequence")

    if ThrowSequence then
        ThrowSequence:Destroy()
    end

    local LuckyCatch = LocalPlayer.PlayerGui:FindFirstChild("LuckyCatch")

    if LuckyCatch then
        LuckyCatch:Destroy()
    end

    Remotes.Invoke("Throw_Cancel")
end

local thread

function t1.Start() -- line: 596
    -- upvalues: GameConfig (copy), Remotes (copy), Sounds (copy), ScreenFX (copy), HUDController (copy), ClientState (copy), Movement (copy), MusicController (copy), LocalPlayer (copy), v1 (ref), n1 (ref), runSequence (copy), pushBack (copy), cleanupFailedThrow (copy), thread (ref)
    if v1 or ClientState.Busy or ClientState.OfflineOpen then
        return
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (HumanoidRootPart and Humanoid) then
        return
    end

    v1 = true
    thread = coroutine.running()
    ClientState.Busy = "Throw"
    Movement.Lock()
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    HumanoidRootPart.Anchored = true
    Sounds.Play("CameraWhoosh", {
        Volume = 0.5
    })
    MusicController.Play("Throw")

    local v79

    task.spawn(function() -- line: 613
        -- upvalues: v79 (ref), Remotes (copy)
        v79 = Remotes.Invoke("Throw_Start")
    end)
    ScreenFX.FadeOut(Color3.new(0, 0, 0), GameConfig.Sequence.FadeOut)

    local elapsed = os.clock()

    while not v79 and os.clock() - elapsed < 10 do
        task.wait()
    end

    if not v79 then
        task.spawn(Remotes.Invoke, "Throw_Cancel")
        v79 = {
            Ok = false,
            Reason = "Timeout"
        }
    end

    if v79.Ok then
        local v80 = v79
        local v81, v82, v83 = pcall(runSequence, v80)
        local _warn, v84, v85, v86

        if v81 then
            if v82 == false then
                _warn = warn
                v84 = "[ThrowController] Sequence failed: "
                v85 = v83 or v82
                v86 = false
            else
                v86 = true
            end
        else
            _warn = warn
            v84 = "[ThrowController] Sequence failed: "
            v85 = v82
            v86 = false
        end

        if not v86 then
            _warn(v84 .. tostring(v85))
            cleanupFailedThrow()
        end

        v1 = false
        thread = nil
        ClientState.Busy = nil
    else
        HumanoidRootPart.Anchored = false

        if Character.Parent then
            pushBack(HumanoidRootPart, Humanoid)
        end

        Movement.Unlock()
        v1 = false
        ClientState.Busy = nil
        n1 = os.clock() + 1

        if v79.Reason == "Training" then
            HUDController.Notify("Finish training first!", "Info")
        end

        ScreenFX.FadeIn(0.25)
    end
end

local function checkDeadThrow() -- line: 654
    -- upvalues: ClientState (copy), v1 (ref), cleanupFailedThrow (copy), thread (ref)
    if v1 and thread and coroutine.status(thread) == "dead" then
        warn("[ThrowController] The throw's script died half way - cleaning up")
        thread = nil
        task.spawn(function() -- line: 658
            -- upvalues: ClientState (copy), v1 (ref), cleanupFailedThrow (copy)
            cleanupFailedThrow()
            v1 = false

            if ClientState.Busy == "Throw" then
                ClientState.Busy = nil
            end
        end)
    end
end

local v87

local function checkStuckHatch() -- line: 668
    -- upvalues: CameraRig (copy), HUDController (copy), ClientState (copy), Movement (copy), LocalPlayer (copy), v87 (ref)
    if ClientState.Busy ~= "Hatch" then
        v87 = nil

        return
    end

    v87 = v87 or os.clock()

    if not (os.clock() - v87 < 45) and not LocalPlayer.PlayerGui:FindFirstChild("EggHatch") then
        warn("[ThrowController] A hatch stayed busy without its screen - freeing the player")
        v87 = nil
        ClientState.Busy = nil

        local Release = CameraRig.Release

        pcall(Release)

        local Unlock = Movement.Unlock

        pcall(Unlock)

        local SetGameplayVisible = HUDController.SetGameplayVisible

        pcall(SetGameplayVisible, true)
    end
end

local function pollLine() -- line: 684
    -- upvalues: ClientState (copy), t1 (copy), LocalPlayer (copy), v1 (ref), StarterArea (ref), v2 (ref), n1 (ref), pushBack (copy), checkDeadThrow (copy), checkStuckHatch (copy)
    checkDeadThrow()
    checkStuckHatch()

    local Character, HumanoidRootPart, v88

    if v1 then
        v88 = true
    elseif StarterArea and v2 then
        Character = LocalPlayer.Character
        HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        v88 = false
    else
        v88 = true
    end

    if v88 then
        return
    end

    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) and not HumanoidRootPart.Anchored then
        local Position = HumanoidRootPart.Position

        if not (Position.Z >= v2) then
            local Position2 = StarterArea.Position
            local v89 = StarterArea.Size / 2

            if math.abs(Position.X - Position2.X) <= v89.X + 0.5 and Position.Z >= Position2.Z - v89.Z - 0.5 and Position.Y >= Position2.Y + v89.Y - 3 and not ClientState.Busy and not ClientState.OfflineOpen and not (os.clock() < n1) then
                task.spawn(t1.Start)
            else
                pushBack(HumanoidRootPart, Humanoid)
            end
        end
    end
end

function t1.Init() -- line: 705
    -- upvalues: RunService (copy), StarterArea (ref), v2 (ref), pollLine (copy)
    task.spawn(function() -- line: 706
        -- upvalues: RunService (copy), StarterArea (ref), v2 (ref), pollLine (copy)
        StarterArea = workspace:WaitForChild("StarterArea")

        local v91 = StarterArea:WaitForChild("CrossLine", 10)

        v2 = v91 and v91.Position.Z or StarterArea.Position.Z + StarterArea.Size.Z / 2

        if v91 then
            v91.CanTouch = false
        end

        RunService.Heartbeat:Connect(pollLine)
    end)
end

return t1

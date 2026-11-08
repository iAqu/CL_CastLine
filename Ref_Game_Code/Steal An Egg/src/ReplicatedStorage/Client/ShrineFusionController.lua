-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local FusionShrines = require(ReplicatedStorage.Shared.FusionShrines)
local ShrinePadPets = require(ReplicatedStorage.Client.ShrinePadPets)
local ShrineFusion = require(ReplicatedStorage.Shared.Remotes).ShrineFusion
local ShrineFusionStatus = require(ReplicatedStorage.Client.ShrineFusionStatus)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ShrinePadZone = require(ReplicatedStorage.Shared.Util.ShrinePadZone)
local ShrineFusionSequences = ReplicatedStorage.Client:WaitForChild("ShrineFusionSequences")
local Cinematic = ReplicatedStorage.Assets.UI:WaitForChild("FusionShrine"):WaitForChild("Cinematic")
local FusionShrineHint = ReplicatedStorage.Assets.Billboards:WaitForChild("FusionShrineHint")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t1 = {
    DiscDiameter = 15.6,
    DiscLift = 0.07,
    OrbCount = 3,
    OrbRadius = 7.2,
    OrbSize = 0.7,
    OrbSpeed = 1.3,
    OrbBob = 0.5,
    OrbHeight = 1.3,
    AnimDistance = 180,
    Approach = 6,
    Breathe = 1.7,
    FieldSize = 46,
    ArcCurve = 9,
    ArcWidth = 0.9
}
local t2 = {}
local v1 = {
    Ready = false
}
local v2 = false
local n1 = 0
local t3, v3, t4, t5

local function sequenceOf(p1) -- line: 100
    -- upvalues: ShrineFusionSequences (copy)
    return require((ShrineFusionSequences:WaitForChild(p1.Sequence)))
end

local function layoutOf(p2) -- line: 104
    -- upvalues: FusionShrines (copy)
    local v4 = FusionShrines.Of(p2)

    if v4 then
        return v4, FusionShrines.PadsOf(p2, v4)
    end

    return nil, nil
end

local function centerOf(p3) -- line: 112
    local v5 = Vector3.new(0, 0, 0)
    local n2 = 0

    for _, v6 in p3 do
        v5 += v6.Position
        n2 += 1
    end

    return v5 / math.max(n2, 1)
end

local function mix(p4, p5, p6) -- line: 121
    return p4 + (p5 - p4) * p6
end

local function smooth(p7) -- line: 125
    local v7 = math.clamp(p7, 0, 1)

    return v7 * v7 * (3 - v7 * 2)
end

local function localRoot() -- line: 130
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.Position else nil
end

local function shotRig(p8) -- line: 136
    -- upvalues: LocalPlayer (copy)
    local Sides = p8.Kind.Sides
    local Position = p8.Pads[Sides[1]].Position
    local Position2 = p8.Pads[Sides[2]].Position
    local v8 = Position - Position2
    local v9 = if v8.Magnitude > 0.01 then v8.Unit else Vector3.new(1, 0, 0)
    local v10 = (Vector3.new(0, 1, 0)):Cross(v9)
    local v11 = (Position + Position2) / 2 + Vector3.new(0, 5.5, 0)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil
    local Position3 = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position
    local v12 = if Position3 then (v11 - Position3) * Vector3.new(1, 0, 1) else Vector3.new(0, 0, 0)

    return {
        Focus = v11,
        Axis = v9,
        Front = v10,
        Light = Position,
        Dark = Position2,
        Span = math.max(18, v8.Magnitude * 1.25),
        Root = Position3,
        Approach = if v12.Magnitude > 0.01 then v12.Unit else v10
    }
end

local function camFrame(p9, p10, p11, p12) -- line: 157
    local Cam = p9.Cam

    if not Cam then
        Cam = {
            Dist = 1.26,
            Height = 9.4,
            FOV = 56,
            Angle = 0.34,
            Drift = 1,
            Shot = 1
        }
        p9.Cam = Cam
    end

    local v14 = p9.Sequence.FlightFocus()
    local v16 = 1 - math.exp(-p12 * 2.8)
    local v18 = 1 - math.exp(-p12 * 5.2)
    local v20 = math.max(p9.EndsAt - p9.StartedAt, 1)
    local v22 = math.clamp(v20 * 0.24, 0.5, 1.3)
    local v23 = p9.EndsAt - v22
    local v25 = math.clamp((p11 - p9.StartedAt) / v20, 0, 1)
    local v26, v27, v28, v29, v30

    if p9.PayoffAt then
        local v32 = math.clamp((p11 - p9.PayoffAt - 1.1) / 3.4, 0, 1)
        local v33 = v32 * v32 * (3 - v32 * 2)

        v26 = 0
        v27 = v33 * 0.24 + 0.6
        v28 = v33 * 1.1999999999999993 + 4.4
        v29 = v33 * 3 + 46
        v30 = 0
    elseif v23 <= p11 then
        local v35 = math.clamp((p11 - v23) / v22, 0, 1)
        local v36 = v35 * v35 * (3 - v35 * 2)

        v26 = 0
        v27 = v36 * -0.06000000000000005 + 0.56
        v28 = v36 * -0.3999999999999999 + 3.6
        v29 = v36 * -2.5 + 46
        v30 = 0
    elseif v25 < 0.38 then
        local v38 = math.clamp(v25 / 0.38, 0, 1)
        local v39 = v38 * v38 * (3 - v38 * 2)

        v26 = 0.34
        v27 = v39 * -0.24 + 1.26
        v28 = v39 * -2.2 + 9.4
        v29 = v39 * -3 + 56
        v30 = 1
    else
        local v41 = math.max((v23 - p9.StartedAt) / v20, 0.43)
        local v43 = math.clamp((v25 - 0.38) / (v41 - 0.38), 0, 1)
        local v44 = v43 * v43 * (3 - v43 * 2)

        v26 = v44 * 0.55 + -0.55
        v27 = v44 * -0.32999999999999996 + 0.95
        v28 = v44 * -0.6000000000000005 + 4.4
        v29 = v44 * -4 + 50

        if Cam.Shot == 1 then
            Cam.Shot = 2
            Cam.Angle = v26
            Cam.Dist = v27
            Cam.Height = v28
            Cam.FOV = v29
            Cam.Drift = 0.5
        end

        v30 = 0.5
    end

    local Dist = Cam.Dist

    Cam.Dist = Dist + (v27 - Dist) * v16

    local Height = Cam.Height

    Cam.Height = Height + (v28 - Height) * v16

    local FOV = Cam.FOV

    if v14 then
        v29 = 51
    end

    Cam.FOV = FOV + (v29 - FOV) * v16

    local Angle = Cam.Angle

    Cam.Angle = Angle + (v26 - Angle) * v18

    local Drift = Cam.Drift

    Cam.Drift = Drift + (v30 - Drift) * v18

    local v46 = Cam.Angle + math.sin((p11 - p9.StartedAt) * 0.33) * 0.05 * Cam.Drift
    local Unit = (p10.Front * math.cos(v46) + p10.Axis * math.sin(v46)).Unit
    local v48 = p10.Focus + Unit * p10.Span * Cam.Dist + Vector3.new(0, Cam.Height, 0)

    if v14 and not Cam.Anchor then
        Cam.Anchor = v48
        Cam.AnchorFrom = v48
        Cam.AnchorTo = p10.Focus + Unit * p10.Span * 0.78 + Vector3.new(0, 5.6, 0)
        Cam.AnchorAt = p11
        Cam.AimPoint = p10.Focus
        Cam.AimGoal = p10.Focus
        Cam.AimVelocity = Vector3.new(0, 0, 0)
    end

    if not Cam.Anchor then
        return CFrame.lookAt(v48, p10.Focus), Cam.FOV
    end

    local AnchorFrom, AnchorTo = Cam.AnchorFrom, Cam.AnchorTo
    local v50 = math.clamp((p11 - Cam.AnchorAt) / 0.55, 0, 1)

    Cam.Anchor = AnchorFrom:Lerp(AnchorTo, v50 * v50 * (3 - v50 * 2))

    if v14 then
        Cam.AimGoal = p10.Focus:Lerp(v14, 0.42)
    else
        Cam.AimGoal = p10.Focus
    end

    local v51 = math.min(p12, 0.03333333333333333)

    Cam.AimVelocity += ((Cam.AimGoal - Cam.AimPoint) * 30.25 - Cam.AimVelocity * 6.6) * v51
    Cam.AimPoint += Cam.AimVelocity * v51

    return CFrame.lookAt(Cam.Anchor, Cam.AimPoint), Cam.FOV
end

local function cinematicGui() -- line: 250
    -- upvalues: TweenService (copy), Cinematic (copy), PlayerGui (copy)
    local clone = Cinematic:Clone()

    clone.ResetOnSpawn = false

    local TopBar = clone:WaitForChild("TopBar")
    local BottomBar = clone:WaitForChild("BottomBar")
    local Help = clone:WaitForChild("Help")
    local v52 = clone:GetAttribute("BarHeight") or 0.115

    clone.Parent = PlayerGui

    for _, v53 in { TopBar, BottomBar } do
        v53.Size = UDim2.fromScale(1, 0)
        TweenService:Create(v53, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, v52)
        }):Play()
    end

    return clone, TopBar, BottomBar, Help
end

local function setBillboards(p13, p14) -- line: 269
    if p13.BillboardsOn == p14 then
        return
    end

    p13.BillboardsOn = p14

    for _, v54 in p13.Billboards do
        if v54.Parent then
            v54.Enabled = p14
        end
    end
end

local function refresh() -- line: 281
    -- upvalues: ShrineFusion (copy), v1 (ref), v2 (ref)
    if not v2 then
        v2 = true
        task.spawn(function() -- line: 286
            -- upvalues: ShrineFusion (copy), v1 (ref), v2 (ref)
            local function v55() -- line: 287
                -- upvalues: ShrineFusion (copy)
                return ShrineFusion.AskState:InvokeServer()
            end

            local v56, v57, v58 = pcall(v55)

            if v56 and v57 and type(v58) == "table" then
                v1 = v58
            end

            v2 = false
        end)
    end
end

local function completed(p15) -- line: 297
    -- upvalues: v1 (ref)
    local Ready = v1.Ready
    local v59 = if Ready then type(v1.Status) == "table" else nil
    local Status = if not Ready or not v59 then nil else v1.Status

    if not Status then
        return false
    end

    for _, v60 in p15.Tiers do
        if Status[v60] ~= "COMPLETED" then
            return false
        end
    end

    return true
end

local function settle(p16, p17) -- line: 310
    -- upvalues: ShrineFusionSequences (copy), v1 (ref)
    local Kind = p16.Kind
    local v61 = require((ShrineFusionSequences:WaitForChild(Kind.Sequence)))

    if not v61.Settle or p17 or not v1.Ready then
        return
    end

    if p16.Settled ~= v1 then
        p16.Settled = v1

        local Kind = p16.Kind
        local Status = if v1.Ready and type(v1.Status) == "table" then v1.Status else nil
        local v62

        if Status then
            local v63 = false

            for _, v64 in Kind.Tiers do
                if Status[v64] ~= "COMPLETED" then
                    v62 = false
                    v63 = true
                    break
                end
            end

            if not v63 then
                v62 = true
            end
        else
            v62 = false
        end

        p16.Cleared = v62
    end

    v61.Settle(p16.Model, p16.Cleared == true)
end

local function characterOf(p18) -- line: 322
    -- upvalues: Players (copy)
    local v65 = if type(p18) == "number" then Players:GetPlayerByUserId(p18) else nil

    return if v65 then v65.Character else nil
end

local function recipeOf(p19) -- line: 327
    -- upvalues: v1 (ref)
    return if v1.Ready and type(v1.Recipes) == "table" then v1.Recipes[p19] else nil
end

local function play(p20, p21) -- line: 331
    -- upvalues: v3 (ref)
    if v3 and v3 ~= p20 then
        v3.Cancel()
    end

    v3 = p20

    return p20.Begin(p21)
end

local function beginContext(p22, p23, p24, p25, p26, p27) -- line: 339
    -- upvalues: Players (copy), v1 (ref)
    local t7 = {}

    for _, v67 in p23.Sides do
        local v68 = if type(p26) == "table" then p26[v67] else nil
        local v69 = if type(v68) == "number" then Players:GetPlayerByUserId(v68) else nil

        if v69 then
            t7[v67] = v69.Character
        else
            t7[v67] = nil
        end
    end

    local Tier = p25.Tier
    local Ready = v1.Ready
    local v70 = if Ready then type(v1.Recipes) == "table" else nil
    local v71 = if not Ready or not v70 then nil else v1.Recipes[Tier]
    local Seats = p25.Seats
    local t8

    if type(Seats) == "table" then
        t8 = {}

        for _, v72 in p25.Seats do
            if type(v72) == "table" then
                local UserId = v72.UserId
                local v73 = if type(UserId) == "number" then Players:GetPlayerByUserId(UserId) else nil
                local t9 = {
                    Character = if v73 then v73.Character else nil
                }

                for _, v74 in p23.Sides do
                    local v75 = v72[v74]

                    if typeof(v75) ~= "Instance" or not v75:IsA("BasePart") then
                        v75 = nil
                    end

                    t9[v74] = v75
                end

                table.insert(t8, t9)
            end
        end
    end

    return {
        Shrine = p22,
        Kind = p23,
        Pads = p24,
        Seats = t8,
        Characters = t7,
        LightCharacter = t7.Light,
        DarkCharacter = t7.Dark,
        EndsAt = p25.EndsAt,
        Tier = p25.Tier,
        Recipe = v71,
        FusedCategory = if v71 then v71.Fused else nil,
        Participant = p27 ~= nil,
        Gui = p27
    }
end

local function releaseCamera(p28, p29) -- line: 385
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera ~= p28.Camera or CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
        return
    end

    CurrentCamera.CameraType = p28.Type
    CurrentCamera.FieldOfView = p28.FOV

    if p29 then
        CurrentCamera.CFrame = p29
    end

    CurrentCamera.CameraSubject = p28.Subject
end

local function dropBars(p30) -- line: 397
    -- upvalues: TweenService (copy)
    local v76 = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    for _, v77 in {
            p30.Top,
            p30.Bottom
        } do
        TweenService:Create(v77, v76, {
            Size = UDim2.fromScale(1, 0)
        }):Play()
    end

    task.delay(0.5, function() -- line: 402
        -- upvalues: p30 (copy)
        p30.Gui:Destroy()
    end)
end

local function hideHud(p31) -- line: 407
    -- upvalues: PlayerGui (copy)
    p31.HiddenHud = {}

    if p31.Kind.HideHud then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= p31.Gui and child.Enabled and child.DisplayOrder < p31.Gui.DisplayOrder then
                child.Enabled = false
                table.insert(p31.HiddenHud, child)
            end
        end
    end
end

local function showHud(p32) -- line: 425
    for _, v78 in p32.HiddenHud or {} do
        if v78.Parent then
            v78.Enabled = true
        end
    end

    p32.HiddenHud = nil
end

local function stopCutscene(p33) -- line: 434
    -- upvalues: LocalPlayer (copy), t3 (ref), t4 (ref), dropBars (copy)
    local t11 = t3

    t3 = nil

    if t11 then
        for _, v79 in t11.HiddenHud or {} do
            if v79.Parent then
                v79.Enabled = true
            end
        end

        t11.HiddenHud = nil
        t11.Help.Visible = false

        local CurrentCamera = workspace.CurrentCamera
        local Character = LocalPlayer.Character
        local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil
        local Position = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position

        if p33 ~= true and CurrentCamera == t11.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable and Position and not ((Position - CurrentCamera.CFrame.Position).Magnitude > 140) then
            t4 = {
                T = 0,
                Camera = t11.Camera,
                Type = t11.Type,
                FOV = t11.FOV,
                Subject = t11.Subject,
                Gui = t11.Gui,
                Top = t11.Top,
                Bottom = t11.Bottom,
                From = CurrentCamera.CFrame,
                FromFOV = CurrentCamera.FieldOfView,
                Offset = t11.CamOffset
            }
        else
            local CFrame = t11.CFrame
            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera == t11.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                CurrentCamera.CameraType = t11.Type
                CurrentCamera.FieldOfView = t11.FOV

                if CFrame then
                    CurrentCamera.CFrame = CFrame
                end

                CurrentCamera.CameraSubject = t11.Subject
            end

            if p33 == true then
                t11.Gui:Destroy()
            else
                dropBars(t11)
            end
        end
    elseif p33 == true and t4 then
        local t12 = t4

        t4 = nil

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera == t12.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = t12.Type
            CurrentCamera.FieldOfView = t12.FOV
            CurrentCamera.CameraSubject = t12.Subject
        end

        t12.Gui:Destroy()
    end
end

local function startCutscene(p34) -- line: 482
    -- upvalues: FusionShrines (copy), ShrineFusionSequences (copy), LocalPlayer (copy), t2 (copy), t3 (ref), v3 (ref), t4 (ref), cinematicGui (copy), beginContext (copy), hideHud (copy)
    local t13 = t3

    t3 = nil

    if t13 then
        for _, v80 in t13.HiddenHud or {} do
            if v80.Parent then
                v80.Enabled = true
            end
        end

        t13.HiddenHud = nil
        t13.Help.Visible = false

        local _ = workspace.CurrentCamera
        local Character = LocalPlayer.Character
        local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local _ = HumanoidRootPart.Position
        end

        local CFrame = t13.CFrame
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera == t13.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = t13.Type
            CurrentCamera.FieldOfView = t13.FOV

            if CFrame then
                CurrentCamera.CFrame = CFrame
            end

            CurrentCamera.CameraSubject = t13.Subject
        end

        t13.Gui:Destroy()
    elseif t4 then
        local t14 = t4

        t4 = nil

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera == t14.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            CurrentCamera.CameraType = t14.Type
            CurrentCamera.FieldOfView = t14.FOV
            CurrentCamera.CameraSubject = t14.Subject
        end

        t14.Gui:Destroy()
    end

    local Shrine = p34.Shrine
    local CurrentCamera = workspace.CurrentCamera

    if typeof(Shrine) == "Instance" and Shrine:IsDescendantOf(workspace) and CurrentCamera then
        local v81 = FusionShrines.Of(Shrine)
        local v82

        if v81 then
            v82 = FusionShrines.PadsOf(Shrine, v81)
        else
            v81 = nil
        end

        if v81 and v82 then
            local v83 = require((ShrineFusionSequences:WaitForChild(v81.Sequence)))
            local v84, v85, v86, v87 = cinematicGui()

            v87.Visible = type(p34.Seats) ~= "table"

            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil
            local Position = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position

            t3 = {
                Id = p34.SessionId,
                Tier = p34.Tier,
                Model = Shrine,
                Kind = v81,
                Pads = v82,
                Sequence = v83,
                EndsAt = p34.EndsAt,
                StartedAt = workspace:GetServerTimeNow(),
                Camera = CurrentCamera,
                Type = CurrentCamera.CameraType,
                FOV = CurrentCamera.FieldOfView,
                CFrame = CurrentCamera.CFrame,
                Subject = CurrentCamera.CameraSubject,
                CamOffset = if Position then CurrentCamera.CFrame.Position - Position else CurrentCamera.CFrame.LookVector * -12 + Vector3.new(0, 4, 0),
                Gui = v84,
                Help = v87,
                Top = v85,
                Bottom = v86
            }
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.FieldOfView = 56
            hideHud(t3)

            local v88 = t2[Shrine]

            if v88 and v88.BillboardsOn ~= false then
                v88.BillboardsOn = false

                for _, v89 in v88.Billboards do
                    if v89.Parent then
                        v89.Enabled = false
                    end
                end
            end

            local v90 = beginContext(Shrine, v81, v82, p34, p34.Participants, v84)

            if v3 and v3 ~= v83 then
                v3.Cancel()
            end

            v3 = v83
            v83.Begin(v90)
        end
    end
end

local function cleanup(p35) -- line: 529
    -- upvalues: t2 (copy), t3 (ref), stopCutscene (copy)
    local v91 = t2[p35]

    if not v91 then
        return
    end

    t2[p35] = nil
    v91.Trove:Destroy()

    if t3 and t3.Model == p35 then
        stopCutscene()
    end
end

local function padVisual(p36, p37, p38, p39) -- line: 541
    local Vfx = p36.Vfx
    local v92 = p36.Kind.Colors[p37]
    local v93 = p38.Position.Y + p38.Size.Y / 2
    local Part = Instance.new("Part")

    Part.Name = "FusionGlowDisc" .. p37
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.18, Vfx.DiscDiameter, Vfx.DiscDiameter)
    Part.CFrame = CFrame.new(p38.Position.X, v93 + Vfx.DiscLift, p38.Position.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = v92
    Part.Transparency = 1
    Part.Parent = p36.Model
    p36.Trove:Add(Part)

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v92
    PointLight.Range = 16
    PointLight.Brightness = 0
    PointLight.Enabled = false
    PointLight.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v92)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Lifetime = NumberRange.new(1.1, 2.2)
    ParticleEmitter.Speed = NumberRange.new(2, 4.5)
    ParticleEmitter.SpreadAngle = Vector2.new(24, 24)
    ParticleEmitter.Acceleration = Vector3.new(0, 1.5, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Right
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = false
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Parent = Part

    local t16 = {}

    for _ = 1, Vfx.OrbCount do
        local Part = Instance.new("Part")

        Part.Name = "FusionGlowOrb" .. p37
        Part.Shape = Enum.PartType.Ball
        Part.Size = Vector3.new(1, 1, 1) * Vfx.OrbSize
        Part.CFrame = CFrame.new(p38.Position.X, v93 + Vfx.OrbHeight, p38.Position.Z)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Color = v92
        Part.Transparency = 1
        Part.Parent = p36.Model
        p36.Trove:Add(Part)
        table.insert(t16, Part)
    end

    return {
        DiscT = 1,
        LightT = 0,
        OrbA = 0,
        Pad = p38,
        Disc = Part,
        Glow = PointLight,
        Embers = ParticleEmitter,
        Orbs = t16,
        Top = v93,
        Offset = (p39 - 1) * 2.1,
        Goal = {
            Disc = 0.62,
            Breathe = 0.16,
            Light = 0.7,
            Orb = 0
        }
    }
end

local function register(p40) -- line: 615
    -- upvalues: FusionShrines (copy), ShrinePadPets (copy), ShrineFusion (copy), ShrineFusionStatus (copy), Trove (copy), FusionShrineHint (copy), PlayerGui (copy), t1 (copy), t2 (copy), v1 (ref), v2 (ref), t3 (ref), stopCutscene (copy), padVisual (copy)
    local v94, v95

    if not t2[p40] and p40:IsA("Model") and p40:IsDescendantOf(workspace) then
        v94 = FusionShrines.Of(p40)

        if v94 then
            v95 = FusionShrines.PadsOf(p40, v94)
        else
            v94 = nil
        end

        if v94 and v95 then
            local v96 = FusionShrines.SlotsOf(p40, v94)

            if not v94.Placement or v96 then
                local v97 = table.clone(t1)

                for v98, v99 in v94.PadVfx do
                    v97[v98] = v99
                end

                local v100 = Vector3.new(0, 0, 0)
                local n3 = 0

                for _, v101 in v95 do
                    v100 += v101.Position
                    n3 += 1
                end

                local v102 = v100 / math.max(n3, 1)
                local n4 = 0

                for _, v103 in v95 do
                    n4 = math.max(n4, (v103.Position - v102).Magnitude)
                end

                local v104 = v95[v94.Sides[1]]
                local v105 = v95[v94.Sides[2]]
                local t17 = {
                    BillboardsOn = true,
                    Model = p40,
                    Kind = v94,
                    Pads = v95,
                    Vfx = v97,
                    Trove = Trove.new(),
                    Visuals = {},
                    Billboards = {},
                    Reach = n4 + 100,
                    Anim = {
                        Center = v102
                    }
                }

                t2[p40] = t17

                local Attachment = Instance.new("Attachment")

                Attachment.Name = "FusionStatusAnchor"
                Attachment.Position = v104.CFrame:PointToObjectSpace(v102)
                Attachment.Parent = v104
                t17.Trove:Add(Attachment)
                t17.Status = ShrineFusionStatus.new(v94, v95, Attachment, PlayerGui, v96)
                t17.Trove:Add(t17.Status)

                for _, v106 in t17.Status.Guis do
                    table.insert(t17.Billboards, v106)
                end

                local clone = FusionShrineHint:Clone()

                clone.Name = "PersonalFusionHint"
                clone.Adornee = Attachment
                clone.ResetOnSpawn = false
                clone.Enabled = false

                if v97.HintHeight then
                    clone.StudsOffsetWorldSpace = Vector3.new(0, v97.HintHeight, 0)
                end

                clone.Parent = PlayerGui
                t17.Trove:Add(clone)
                t17.Hint = clone
                t17.Message = clone:WaitForChild("Guidance")

                local t18 = {}

                if v96 then
                    for v107, v108 in v96 do
                        t17.Visuals[v108.Name] = padVisual(t17, v108.Side, v108.Pad, v107)
                        table.insert(t18, v108.Name)
                    end

                    t17.PadPets = ShrinePadPets.new(p40, v94, v96, v102)
                    t17.Trove:Add(t17.PadPets)
                else
                    for v109, v110 in v94.Sides do
                        t17.Visuals[v110] = padVisual(t17, v110, v95[v110], v109)
                        table.insert(t18, v110)
                    end
                end

                local Attachment2 = Instance.new("Attachment")

                Attachment2.Parent = t17.Visuals[t18[1]].Disc

                local Attachment3 = Instance.new("Attachment")

                Attachment3.Parent = t17.Visuals[t18[2]].Disc

                local Beam = Instance.new("Beam")

                Beam.Attachment0 = Attachment2
                Beam.Attachment1 = Attachment3
                Beam.CurveSize0 = v97.ArcCurve
                Beam.CurveSize1 = v97.ArcCurve
                Beam.Width0 = v97.ArcWidth
                Beam.Width1 = v97.ArcWidth
                Beam.Segments = 24
                Beam.FaceCamera = true
                Beam.LightEmission = 1
                Beam.LightInfluence = 0
                Beam.Color = ColorSequence.new(v94.Colors[v94.Sides[1]], v94.Colors[v94.Sides[2]])
                Beam.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.75),
                    NumberSequenceKeypoint.new(0.5, 0.45),
                    NumberSequenceKeypoint.new(1, 0.75)
                })
                Beam.Parent = t17.Visuals[t18[1]].Disc
                t17.Arc = Beam

                local Part = Instance.new("Part")

                Part.Name = "FusionGlowField"
                Part.Size = Vector3.new(v97.FieldSize, 0.2, v97.FieldSize)
                Part.CFrame = CFrame.new(v102.X, math.min(v104.Position.Y, v105.Position.Y) + v104.Size.Y / 2 - 0.4, v102.Z)
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
                Part.CastShadow = false
                Part.Transparency = 1
                Part.Parent = p40
                t17.Trove:Add(Part)

                for _, v111 in v94.Sides do
                    local ParticleEmitter = Instance.new("ParticleEmitter")

                    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    ParticleEmitter.Color = ColorSequence.new(v94.Colors[v111])
                    ParticleEmitter.LightEmission = 1
                    ParticleEmitter.LightInfluence = 0
                    ParticleEmitter.Lifetime = NumberRange.new(4, 7)
                    ParticleEmitter.Speed = NumberRange.new(0.6, 1.8)
                    ParticleEmitter.Rate = 3.5
                    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
                    ParticleEmitter.Size = NumberSequence.new(0.22)
                    ParticleEmitter.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.15, 0.3),
                        NumberSequenceKeypoint.new(0.8, 0.4),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    ParticleEmitter.Parent = Part
                end

                t17.Trove:Connect(p40.AncestryChanged, function() -- line: 744
                    -- upvalues: p40 (copy), t2 (copy), t3 (ref), stopCutscene (copy)
                    if p40:IsDescendantOf(workspace) then
                        return
                    end

                    local v112 = t2[p40]

                    if not v112 then
                        return
                    end

                    t2[p40] = nil
                    v112.Trove:Destroy()

                    if t3 and t3.Model == p40 then
                        stopCutscene()
                    end
                end)

                if not v2 then
                    v2 = true
                    task.spawn(function() -- line: 286
                        -- upvalues: ShrineFusion (copy), v1 (ref), v2 (ref)
                        local function v113() -- line: 287
                            -- upvalues: ShrineFusion (copy)
                            return ShrineFusion.AskState:InvokeServer()
                        end

                        local v114, v115, v116 = pcall(v113)

                        if v114 and v115 and type(v116) == "table" then
                            v1 = v116
                        end

                        v2 = false
                    end)
                end
            end
        end
    end
end

ShrineFusion.Feedback.OnClientEvent:Connect(function(p41) -- line: 752
    -- upvalues: t5 (ref)
    if type(p41) == "table" and type(p41.Message) == "string" then
        t5 = {
            Message = p41.Message,
            Until = os.clock() + 4
        }
    end
end)
ShrineFusion.Ritual.OnClientEvent:Connect(function(p42) -- line: 758
    -- upvalues: ShrineFusion (copy), t2 (copy), v1 (ref), v2 (ref), t3 (ref), v3 (ref), stopCutscene (copy), startCutscene (copy)
    if type(p42) ~= "table" then
        return
    end

    if p42.Phase == "Started" then
        startCutscene(p42)
    elseif not t3 or t3.Id == p42.SessionId then
        if p42.Phase == "Completed" then
            local v117 = if t3 then t2[t3.Model] else nil

            if v117 then
                v117.Cleared = true
            end

            if not v2 then
                v2 = true
                task.spawn(function() -- line: 286
                    -- upvalues: ShrineFusion (copy), v1 (ref), v2 (ref)
                    local function v118() -- line: 287
                        -- upvalues: ShrineFusion (copy)
                        return ShrineFusion.AskState:InvokeServer()
                    end

                    local v119, v120, v121 = pcall(v118)

                    if v119 and v120 and type(v121) == "table" then
                        v1 = v121
                    end

                    v2 = false
                end)
            end

            if t3 then
                t3.PayoffAt = workspace:GetServerTimeNow()
                t3.Help.Visible = false
            end

            if not (v3 and v3.Payoff(stopCutscene)) then
                stopCutscene()
            end
        else
            if v3 then
                v3.Cancel()
            end

            stopCutscene()
        end
    end
end)
ShrineFusion.StateChanged.OnClientEvent:Connect(function(p43, p44) -- line: 787
    -- upvalues: FusionShrines (copy), ShrineFusionSequences (copy), t3 (ref), v3 (ref), beginContext (copy)
    local v122 = p44

    if type(p44) == "table" and typeof(p43) == "Instance" then
        if p44.Phase == "Ritual" then
            task.defer(function() -- line: 792
                -- upvalues: v122 (ref), p43 (copy), FusionShrines (copy), ShrineFusionSequences (copy), t3 (ref), v3 (ref), beginContext (copy)
                if not t3 and (not v3 or not v3.IsPlaying()) and p43:IsDescendantOf(workspace) then
                    local v123 = FusionShrines.Of(p43)
                    local v124

                    if v123 then
                        v124 = FusionShrines.PadsOf(p43, v123)
                    else
                        v123 = nil
                    end

                    if not v123 or not v124 then
                        return
                    end

                    local t21 = {}

                    for v125, v126 in v124 do
                        t21[v125] = v126:GetAttribute("FusionUserId")
                    end

                    local v127 = FusionShrines.SlotsOf(p43, v123)

                    if v127 then
                        local t22 = {}
                        local t23 = {}

                        for _, v128 in v127 do
                            local PlacedUserId = v128.Pad:GetAttribute("PlacedUserId")

                            if type(PlacedUserId) == "number" then
                                if not t22[PlacedUserId] then
                                    t22[PlacedUserId] = {
                                        UserId = PlacedUserId
                                    }
                                    table.insert(t23, t22[PlacedUserId])
                                end

                                t22[PlacedUserId][v128.Side] = v128.Pad
                            end
                        end

                        v122 = table.clone(v122)
                        v122.Seats = t23
                    end

                    local v130 = require((ShrineFusionSequences:WaitForChild(v123.Sequence)))
                    local v131 = beginContext(p43, v123, v124, v122, t21, nil)

                    if v3 and v3 ~= v130 then
                        v3.Cancel()
                    end

                    v3 = v130
                    v130.Begin(v131)
                end
            end)
        elseif p44.Phase == "Committing" then
            if not t3 and v3 and v3.IsPlaying() then
                v3.Payoff()
            end
        elseif p44.Phase == "Idle" and not t3 and v3 and v3.IsPlaying() and not v3.IsResolving() then
            v3.Cancel()
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 841
    -- upvalues: v3 (ref), stopCutscene (copy)
    if v3 then
        v3.Cancel()
    end

    stopCutscene()
end)

local function stepPads(p45, p46, p47) -- line: 848
    local Vfx = p45.Vfx
    local v133 = 1 - math.exp(-p47 * Vfx.Approach)

    for _, v134 in p45.Visuals do
        local Goal = v134.Goal
        local v136 = (math.sin(p46 * Vfx.Breathe + v134.Offset) + 1) * 0.5
        local DiscT = v134.DiscT

        v134.DiscT = DiscT + (Goal.Disc + Goal.Breathe * v136 - DiscT) * v133
        v134.Disc.Transparency = v134.DiscT

        local LightT = v134.LightT

        v134.LightT = LightT + (Goal.Light - LightT) * v133
        v134.Glow.Brightness = v134.LightT
        v134.Glow.Enabled = v134.LightT > 0.05

        local OrbA = v134.OrbA

        v134.OrbA = OrbA + (Goal.Orb - OrbA) * v133

        local v137 = v134.OrbA > 0.02

        for v138, v139 in v134.Orbs do
            if v137 then
                local v140 = p46 * Vfx.OrbSpeed + v134.Offset + v138 * (6.283185307179586 / #v134.Orbs)
                local v141 = Vfx.OrbRadius * (0.55 + 0.45 * v134.OrbA)

                v139.CFrame = CFrame.new(v134.Pad.Position.X + math.cos(v140) * v141, v134.Top + Vfx.OrbHeight + math.sin(p46 * 2.3 + v138 * 1.7) * Vfx.OrbBob, v134.Pad.Position.Z + math.sin(v140) * v141)
            end

            v139.Transparency = 1 - v134.OrbA * 0.85
        end
    end
end

local function padGoals(p48, p49, p50) -- line: 878
    local v145 = p49 ~= "Disabled"

    for _, v146 in p48.Visuals do
        local v147 = v146.Pad:GetAttribute("FusionActive") == true
        local v148 = v147 and (p49 == "Ritual" or p49 == "Committing")
        local Goal = v146.Goal

        if p50 then
            Goal.Disc = 0.75
            Goal.Breathe = 0.08
            Goal.Light = 0.5
            Goal.Orb = 0
            v146.Embers.Rate = 0
        elseif v145 then
            if v148 then
                Goal.Disc = 0.12
                Goal.Breathe = 0.05
                Goal.Light = 3
                Goal.Orb = 1
                v146.Embers.Rate = 26
            elseif v147 then
                Goal.Disc = 0.3
                Goal.Breathe = 0.08
                Goal.Light = 1.8
                Goal.Orb = 1
                v146.Embers.Rate = 15
            else
                Goal.Disc = 0.62
                Goal.Breathe = 0.16
                Goal.Light = 0.7
                Goal.Orb = 0
                v146.Embers.Rate = 4
            end
        else
            Goal.Disc = 0.93
            Goal.Breathe = 0.03
            Goal.Light = 0
            Goal.Orb = 0
            v146.Embers.Rate = 0
        end

        v146.Embers.Enabled = v146.Embers.Rate > 0
    end
end

local function guidanceFor(p51, p52, p53) -- line: 904
    -- upvalues: ShrinePadZone (copy), v1 (ref), t5 (ref)
    if p51.PadPets then
        if p53 == nil or not ((p53.Position - p51.Anim.Center).Magnitude < p51.Reach) then
            return nil
        end

        if v1.Ready and not v1.Enabled then
            return "Shrine unavailable. Try again later."
        end

        if p52 == "Mismatch" then
            return p51.Kind.Copy.Mismatch
        end

        return if t5 and t5.Until > os.clock() then t5.Message else nil
    end

    local v149

    if p53 then
        for _, v150 in p51.Kind.Sides do
            if ShrinePadZone.ContainsPoint(p51.Pads[v150], p53.Position) then
                v149 = v150
                break
            end
        end
    end

    if v1.Ready and not v1.Enabled then
        return "Shrine unavailable. Try again later."
    end

    if v1.Ready and next(v1.Recipes or {}) == nil then
        return "Shrine not ready. Try again later."
    end

    if p52 == "Mismatch" then
        return p51.Kind.Copy.Mismatch
    end

    if not v149 then
        return nil
    end

    if t5 and t5.Until > os.clock() then
        return t5.Message
    end

    return p51.Kind.Copy.Hold(v149, v1.Recipes)
end

local function intact(p54, p55) -- line: 941
    if not p54:IsDescendantOf(workspace) then
        return false
    end

    for _, v151 in p55.Pads do
        if not v151:IsDescendantOf(p54) then
            return false
        end
    end

    return true
end

local n5 = 0

RunService.RenderStepped:Connect(function(p56) -- line: 954
    -- upvalues: ShrineFusion (copy), ShrineFusionSequences (copy), LocalPlayer (copy), t2 (copy), v1 (ref), v2 (ref), n1 (ref), t3 (ref), v3 (ref), t4 (ref), shotRig (copy), camFrame (copy), dropBars (copy), stopCutscene (copy), stepPads (copy), padGoals (copy), guidanceFor (copy), intact (copy), n5 (ref)
    if t3 then
        local CurrentCamera = workspace.CurrentCamera
        local ServerTimeNow = workspace:GetServerTimeNow()

        if CurrentCamera == t3.Camera and t3.Model:IsDescendantOf(workspace) and (not (t3.EndsAt + 5 < ServerTimeNow) or t3.Sequence.IsResolving()) then
            local v152, v153

            if t3.Sequence.Camera then
                v152, v153 = t3.Sequence.Camera(ServerTimeNow, p56)
            end

            if not v152 then
                v152, v153 = camFrame(t3, shotRig(t3), ServerTimeNow, p56)
            end

            CurrentCamera.CFrame = v152
            CurrentCamera.FieldOfView = v153
        else
            stopCutscene()
        end
    end

    if t4 then
        local t24 = t4
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera == t24.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            t24.T += p56

            local v156 = math.clamp(math.clamp(t24.T / 0.9, 0, 1), 0, 1)
            local v157 = v156 * v156 * (3 - v156 * 2)
            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil
            local v158 = (if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position) or t24.From.Position - t24.Offset
            local v159 = CFrame.lookAt(v158 + t24.Offset, v158 + Vector3.new(0, 2.2, 0))

            CurrentCamera.CFrame = t24.From:Lerp(v159, v157)

            local FromFOV = t24.FromFOV

            CurrentCamera.FieldOfView = FromFOV + (t24.FOV - FromFOV) * v157

            if v157 >= 1 then
                t4 = nil

                local CurrentCamera = workspace.CurrentCamera

                if CurrentCamera == t24.Camera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                    CurrentCamera.CameraType = t24.Type
                    CurrentCamera.FieldOfView = t24.FOV
                    CurrentCamera.CameraSubject = t24.Subject
                end

                dropBars(t24)
            end
        else
            t4 = nil
            dropBars(t24)
        end
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local elapsed = os.clock()
        local CFramePosition = CurrentCamera.CFrame.Position

        for _, v160 in t2 do
            if v160.PadPets then
                v160.PadPets:SetHidden(v3 ~= nil and v3.ActiveShrine() == v160.Model)
            end

            if (CFramePosition - v160.Anim.Center).Magnitude <= v160.Vfx.AnimDistance + v160.Reach - 100 then
                stepPads(v160, elapsed, p56)

                if v160.PadPets then
                    v160.PadPets:Step(elapsed, p56)
                end
            end
        end
    end

    n5 += p56

    if n5 < 0.2 then
        return
    end

    n5 = 0

    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    local v161 = false

    for v162, v163 in t2 do
        if intact(v162, v163) then
            local v164 = v3 ~= nil and v3.ActiveShrine() == v162
            local v165 = not v164

            if v163.BillboardsOn ~= v165 then
                v163.BillboardsOn = v165

                for _, v166 in v163.Billboards do
                    if v166.Parent then
                        v166.Enabled = v165
                    end
                end
            end

            local FusionPhase = v162:GetAttribute("FusionPhase")
            local Arc = v163.Arc

            if v163.Vfx.ArcWidth > 0 then
                Arc.Enabled = not v164 and FusionPhase ~= "Disabled"
            else
                Arc.Enabled = false
            end

            padGoals(v163, FusionPhase, v164)

            if v163.PadPets then
                v163.PadPets:UpdatePrompts(v1, v164 or FusionPhase == "Ritual" or FusionPhase == "Committing" or FusionPhase == "Disabled")
            end

            v163.Status:Update(v1)

            local Kind = v163.Kind
            local v169 = require((ShrineFusionSequences:WaitForChild(Kind.Sequence)))

            if v169.Settle and not v164 and v1.Ready then
                if v163.Settled ~= v1 then
                    v163.Settled = v1

                    local Kind = v163.Kind
                    local Status = if v1.Ready and type(v1.Status) == "table" then v1.Status else nil
                    local v170

                    if Status then
                        local v171 = false

                        for _, v172 in Kind.Tiers do
                            if Status[v172] ~= "COMPLETED" then
                                v170 = false
                                v171 = true
                                break
                            end
                        end

                        if not v171 then
                            v170 = true
                        end
                    else
                        v170 = false
                    end

                    v163.Cleared = v170
                end

                v169.Settle(v163.Model, v163.Cleared == true)
            end

            local v173 = guidanceFor(v163, FusionPhase, HumanoidRootPart)

            v163.Message.Text = v173 or ""
            v163.Hint.Enabled = v163.BillboardsOn and v173 ~= nil

            if HumanoidRootPart and (HumanoidRootPart.Position - v163.Anim.Center).Magnitude < v163.Reach then
                v161 = true
            end
        else
            local v174 = t2[v162]

            if v174 then
                t2[v162] = nil
                v174.Trove:Destroy()

                if t3 and t3.Model == v162 then
                    stopCutscene()
                end
            end
        end
    end

    if not (v161 and os.clock() >= n1) then
        return
    end

    n1 = os.clock() + 5

    if v2 then
        return
    end

    v2 = true
    task.spawn(function() -- line: 286
        -- upvalues: ShrineFusion (copy), v1 (ref), v2 (ref)
        local function v175() -- line: 287
            -- upvalues: ShrineFusion (copy)
            return ShrineFusion.AskState:InvokeServer()
        end

        local v176, v177, v178 = pcall(v175)

        if v176 and v177 and type(v178) == "table" then
            v1 = v178
        end

        v2 = false
    end)
end)
CollectionService:GetInstanceAddedSignal("ShrineFusion"):Connect(register)
CollectionService:GetInstanceRemovedSignal("ShrineFusion"):Connect(cleanup)
workspace.DescendantAdded:Connect(function(p57) -- line: 1058
    -- upvalues: CollectionService (copy), register (copy)
    local Parent = p57.Parent

    if p57:IsA("BasePart") and Parent and CollectionService:HasTag(Parent, "ShrineFusion") then
        task.defer(register, Parent)
    end
end)

for _, v179 in CollectionService:GetTagged("ShrineFusion") do
    register(v179)
end

return table.freeze({})

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local RaceTrackPath = require(ReplicatedStorage.Shared.Modules.RaceTrackPath)
local Signal = require(ReplicatedStorage.Packages.Signal)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local t1 = {
    -0.8, 0, 0.8
}
local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
local Controls = require(PlayerModule):GetControls()

local function flatten(p1, p2) -- line: 89
    local v1 = p1 - p2 * p1:Dot(p2)

    return if v1.Magnitude > 0.001 then v1.Unit else nil
end

local function approach(p3, p4, p5) -- line: 94
    if p3 < p4 then
        return (math.min(p3 + p5, p4))
    end

    return (math.max(p3 - p5, p4))
end

local function lerp(p6, p7, p8) -- line: 101
    return p6 + (p7 - p6) * p8
end

local t2 = {}

t2.__index = t2

function t2.new(p9, p10, p11) -- line: 159
    -- upvalues: ContextActionService (copy), RunService (copy), UserInputService (copy), MountRaceFlags (copy), MountRace (copy), RaceTrackPath (copy), Signal (copy), t2 (copy)
    local Root = p10.Root
    local v4 = RaycastParams.new()

    v4.FilterType = Enum.RaycastFilterType.Include
    v4.FilterDescendantsInstances = {
        p11.Track,
        p11.Map
    }
    v4.RespectCanCollide = true

    local v5 = RaycastParams.new()

    v5.FilterType = Enum.RaycastFilterType.Exclude
    v5.FilterDescendantsInstances = { p10.Character }
    v5.RespectCanCollide = true
    v5.CollisionGroup = p10.Mount.Hitbox.CollisionGroup

    local v6 = p9:Add(Instance.new("Attachment"))

    v6.Name = "MountDrive"
    v6.Parent = Root

    local v7 = p9:Add(Instance.new("LinearVelocity"))

    v7.Attachment0 = v6
    v7.RelativeTo = Enum.ActuatorRelativeTo.World
    v7.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    v7.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    v7.MaxForce = Root.AssemblyMass * 600
    v7.PlaneVelocity = Vector2.zero
    v7.Parent = Root

    local v8 = p9:Add(Instance.new("AlignOrientation"))

    v8.Mode = Enum.OrientationAlignmentMode.OneAttachment
    v8.Attachment0 = v6
    v8.Responsiveness = 35
    v8.MaxTorque = 1e999
    v8.MaxAngularVelocity = 1e999
    v8.CFrame = Root.CFrame.Rotation
    v8.Parent = Root

    local v9 = p9:Add(Instance.new("VectorForce"))

    v9.Attachment0 = v6
    v9.RelativeTo = Enum.ActuatorRelativeTo.World
    v9.ApplyAtCenterOfMass = true
    v9.Force = Vector3.new(0, 0, 0)
    v9.Parent = Root

    local v10 = setmetatable({
        Rig = p10,
        Path = RaceTrackPath.new(p11.AttachmentTrack),
        Params = v4,
        Drive = v7,
        Align = v8,
        Push = v9,
        Speed = 0,
        Heading = Root.CFrame.LookVector,
        TravelDirection = Root.CFrame.LookVector,
        Up = Vector3.new(0, 1, 0),
        Grounded = false,
        AirSeconds = 0,
        Launched = false,
        Handbrake = false,
        Touch = UserInputService:GetLastInputType() == Enum.UserInputType.Touch,
        AssistProgress = 0,
        Holds = {},
        BoostScale = 1,
        BoostUntil = 0,
        SpeedScales = {},
        StickMinRatio = nil,
        IgnoreGroundUntil = 0,
        LastJumpAt = 0,
        LastWallAt = 0,
        Commanded = Vector3.new(0, 0, 0),
        LastPlanarSpeed = 0,
        LastNormalSpeed = 0,
        GhostUntil = 0,
        GhostParams = v5,
        PopLimit = MountRace.NumberAttribute(p10.Mount, "GroundPopLimit", -1),
        BuriedSeconds = 0,
        StalledSeconds = 0,
        LastUnstickAt = 0,
        UnstickGhostUntil = 0,
        HitboxCollides = p10.Mount.Hitbox.CanCollide,
        WallHit = p9:Add(Signal.new()),
        Landed = p9:Add(Signal.new()),
        Boosted = p9:Add(Signal.new()),
        Override = nil,
        JumpTrack = nil
    }, t2)

    p10.Humanoid.PlatformStand = true
    p9:Add(function() -- line: 245
        -- upvalues: p10 (copy), Root (copy)
        p10.Humanoid.PlatformStand = false
        Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    p9:Add(function() -- line: 250
        -- upvalues: v10 (copy)
        v10:EndUnstickGhost()
    end)

    local Animator = p10.Humanoid:FindFirstChildOfClass("Animator")

    assert(Animator ~= nil, (("%* needs an Animator"):format((p10.Character:GetFullName()))))

    local v13

    if MountRaceFlags.RiderAnimationsEnabled:Get() then
        v13 = p9:Add(Instance.new("Animation"))
        v13.AnimationId = MountRace.RiderAnimations.Ride

        local v14 = p9:Add(Instance.new("Animation"))

        v14.AnimationId = MountRace.RiderAnimations.Jump

        local track = Animator:LoadAnimation(v14)

        track.Priority = Enum.AnimationPriority.Action2
        track.Looped = false
        v10.JumpTrack = track
        p9:Connect(v10.Landed, function() -- line: 267
            -- upvalues: track (copy)
            track:Stop(0.15)
        end)
        p9:Add(function() -- line: 270
            -- upvalues: track (copy)
            track:Stop()
        end)
    else
        local Animate = p10.Character:FindFirstChild("Animate")
        local sit = if Animate == nil then nil else Animate:FindFirstChild("sit")

        if sit ~= nil then
            v13 = sit:FindFirstChildOfClass("Animation")
        end

        assert(v13 ~= nil, (("%* needs Animate.sit"):format((p10.Character:GetFullName()))))
    end

    local track = Animator:LoadAnimation(v13)

    track.Priority = Enum.AnimationPriority.Action
    track.Looped = true
    track:Play()
    p9:Add(function() -- line: 284
        -- upvalues: track (copy)
        track:Stop()
    end)
    ContextActionService:BindActionAtPriority("MountRaceHandbrake", function(_, p13) -- line: 291
        -- upvalues: v10 (copy)
        v10.Handbrake = p13 == Enum.UserInputState.Begin

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.ButtonB)
    p9:Add(function() -- line: 301
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("MountRaceHandbrake")
    end)
    p9:Connect(UserInputService.LastInputTypeChanged, function(p14) -- line: 305
        -- upvalues: v10 (copy)
        v10.Touch = p14 == Enum.UserInputType.Touch
    end)
    p9:Connect(UserInputService.JumpRequest, function() -- line: 308
        -- upvalues: v10 (copy)
        v10:Jump()
    end)
    p9:Connect(RunService.PreSimulation, function(p15) -- line: 311
        -- upvalues: v10 (copy)
        v10:Step(p15)
    end)

    return v10
end

function t2.SetHold(p16, p17, p18) -- line: 317
    local Holds = p16.Holds

    if p18 then
        Holds[p17] = true
    else
        Holds[p17] = nil
    end
end

function t2.IsHeld(p19) -- line: 321
    return next(p19.Holds) ~= nil
end

function t2.ApplyBoost(p20, p21, p22) -- line: 325
    -- upvalues: MountRaceFlags (copy)
    p20.BoostScale = p21
    p20.BoostUntil = os.clock() + p22
    p20.Speed = math.max(p20.Speed, MountRaceFlags.TopSpeed:Get() * p21)
    p20.Boosted:Fire(p21)
end

function t2.SetSpeedScale(p23, p24, p25) -- line: 333
    p23.SpeedScales[p24] = p25
end

function t2.SetStickMode(p26, p27) -- line: 338
    p26.StickMinRatio = p27
end

function t2.Launch(p28, p29) -- line: 342
    p28.Rig.Root.AssemblyLinearVelocity = p29
    p28.IgnoreGroundUntil = os.clock() + 0.3
    p28.Grounded = false
    p28.Launched = true
end

function t2.Place(p30, p31) -- line: 350
    local Root = p30.Rig.Root

    Root.CFrame = p31
    Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    p30.Align.CFrame = p31.Rotation
    p30.Speed = 0
    p30.Heading = p31.LookVector
    p30.TravelDirection = p31.LookVector
    p30.Up = p31.UpVector
    p30.AirSeconds = 0
    p30.Launched = false
    p30.StickMinRatio = nil
    p30.BoostUntil = 0
    p30.Commanded = Vector3.new(0, 0, 0)
    p30.GhostUntil = 0
    p30.BuriedSeconds = 0
    p30.StalledSeconds = 0
    p30:EndUnstickGhost()

    local JumpTrack = p30.JumpTrack

    if JumpTrack ~= nil then
        JumpTrack:Stop(0)
    end
end

function t2.SpeedRatio(p32) -- line: 375
    -- upvalues: MountRaceFlags (copy)
    return math.abs(p32.Speed) / MountRaceFlags.TopSpeed:Get()
end

function t2.TopSpeedScale(p33) -- line: 379
    local v18 = if os.clock() < p33.BoostUntil then p33.BoostScale else 1

    for _, v19 in p33.SpeedScales do
        v18 *= v19
    end

    return v18
end

function t2.Jump(p34) -- line: 387
    -- upvalues: MountRaceFlags (copy)
    local elapsed = os.clock()

    if p34.Override ~= nil or p34:IsHeld() or not p34.Grounded or elapsed - p34.LastJumpAt < 0.35 then
        return
    end

    p34.LastJumpAt = elapsed
    p34.IgnoreGroundUntil = elapsed + 0.15
    p34.Grounded = false
    p34.Rig.Root.AssemblyLinearVelocity += p34.Up * MountRaceFlags.JumpPower:Get()
    p34:PlayJumpAnimation()
end

function t2.PlayJumpAnimation(p35) -- line: 401
    local JumpTrack = p35.JumpTrack

    if JumpTrack ~= nil then
        JumpTrack:Play(0.15)
    end
end

function t2.ProbeGround(p36) -- line: 408
    -- upvalues: Workspace (copy), MountRaceFlags (copy), t1 (copy)
    local Hitbox = p36.Rig.Mount.Hitbox
    local Up = p36.Up
    local v20 = Hitbox.Size.Y / 2 + 3
    local v23 = math.cos((math.rad((MountRaceFlags.MaxGroundAngle:Get()))))
    local v24 = Vector3.new(0, 0, 0)
    local n1 = 0

    for _, v25 in t1 do
        local v28 = Workspace:Raycast(Hitbox.CFrame:PointToWorldSpace((Vector3.new(0, 0, v25 * Hitbox.Size.Z / 2))), -Up * v20, p36.Params)

        if v28 ~= nil and v23 <= v28.Normal:Dot(Up) then
            v24 += v28.Normal
            n1 += 1
        end
    end

    if n1 == 0 then
        return false, Up
    end

    return true, v24.Unit
end

function t2.ProbeLoopEdge(p37, p38) -- line: 429
    -- upvalues: Workspace (copy)
    local Hitbox = p37.Rig.Mount.Hitbox
    local Up = p37.Up
    local v29 = p38:Cross(Up)
    local v30 = Hitbox.Size.Y / 2 + 3
    local v31 = Hitbox.Size.X / 2 + 1
    local v32 = Workspace:Raycast(Hitbox.Position - v29 * v31, -Up * v30, p37.Params) ~= nil
    local v33 = Workspace:Raycast(Hitbox.Position + v29 * v31, -Up * v30, p37.Params) ~= nil

    if v32 and not v33 then
        return -1
    end

    if not v33 or v32 then
        return 0
    end

    return 1
end

function t2.RoadBelow(p39) -- line: 445
    -- upvalues: Workspace (copy)
    local Hitbox = p39.Rig.Mount.Hitbox

    return Workspace:Raycast(Hitbox.Position, -p39.Up * (Hitbox.Size.Y / 2 + 12), p39.Params) ~= nil
end

function t2.AssistYaw(p40, p41, p42, p43) -- line: 451
    -- upvalues: MountRaceFlags (copy)
    local v34 = MountRaceFlags.TouchSteerAssistDegrees:Get()

    if v34 <= 0 then
        return 0
    end

    local Path = p40.Path
    local RootPosition = p40.Rig.Root.Position
    local v35, v36 = Path:Project(RootPosition, p40.AssistProgress, 80, 80)

    if v36 > 60 then
        v35 = Path:Project(RootPosition, 0, Path.Length, Path.Length)
    end

    p40.AssistProgress = v35

    local v37 = Path:FrameAt(v35 + 45).Position - RootPosition
    local v38 = v37 - p42 * v37:Dot(p42)
    local Unit = if v38.Magnitude > 0.001 then v38.Unit else nil

    if Unit == nil or p41:Dot(Unit) < 0.5 then
        return 0
    end

    local v41 = math.atan2(p41:Cross(Unit):Dot(p42), (p41:Dot(Unit)))
    local v42 = math.rad(v34) * p43

    return (math.clamp(v41, -v42, v42))
end

function t2.CheckWall(p44, p45, p46) -- line: 473
    -- upvalues: Workspace (copy), MountRaceFlags (copy)
    if math.abs(p44.Speed) < 1 then
        return
    end

    local Hitbox = p44.Rig.Mount.Hitbox
    local Up = p44.Up
    local v44 = if p44.Speed >= 0 then 1 else -1
    local v45 = p44.TravelDirection * v44
    local v48 = Workspace:Blockcast(Hitbox.CFrame + Up * 1, Hitbox.Size * Vector3.new(0.9, 0.6, 0.9), v45 * (math.abs(p44.Speed) * p46 + 2), p44.Params)
    local v49 = v48 == nil
    local v50 = if not v49 then v48.Normal:Dot(Up) >= math.cos((math.rad((MountRaceFlags.MaxGroundAngle:Get())))) else nil

    if not (v49 or v50) then
        local v54 = -v45:Dot(v48.Normal)

        if not (v54 <= 0) then
            local v55 = math.abs(p44.Speed) * v54
            local v56 = v45 - v48.Normal * v45:Dot(v48.Normal)
            local v57 = v56 - Up * v56:Dot(Up)
            local Unit = if v57.Magnitude > 0.001 then v57.Unit else nil

            if Unit == nil or v54 > 0.75 then
                p44.Speed = -v44 * 12

                local Unit2

                if Unit then
                    Unit2 = Unit
                else
                    local v58 = v48.Normal:Cross(Up)
                    local v59 = v58 - Up * v58:Dot(Up)

                    if v59.Magnitude > 0.001 then
                        Unit2 = v59.Unit
                    end
                end

                local v60 = if Unit2 == nil then p45 else p45:Lerp(Unit2 * v44, 0.6)

                if v60.Magnitude > 0.001 then
                    p44.Heading = v60.Unit
                end
            else
                p44.Speed *= (MountRaceFlags.WallSpeedKeep:Get() - 1) * v54 + 1
                p44.TravelDirection = Unit * v44
                p44.Heading = p45:Lerp(Unit * v44, 0.6).Unit
            end

            local elapsed = os.clock()

            if MountRaceFlags.WallJoltMinSpeed:Get() <= v55 and elapsed - p44.LastWallAt >= 0.25 then
                p44.LastWallAt = elapsed
                p44.WallHit:Fire(v55)
            end
        end
    end
end

function t2.SmoothGhostContact(p47, p48, p49) -- line: 519
    -- upvalues: Workspace (copy), MountRaceFlags (copy)
    if not MountRaceFlags.GhostContactSmoothing:Get() or p47.Launched or p49 - p47.LastWallAt < 0.25 then
        return
    end

    local Commanded = p47.Commanded
    local Magnitude = Commanded.Magnitude

    if Magnitude < 30 then
        return
    end

    local Root = p47.Rig.Root
    local Up = p47.Up
    local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
    local v61 = AssemblyLinearVelocity:Dot(Up)
    local v62 = Commanded / Magnitude
    local v63 = (AssemblyLinearVelocity - Up * v61):Dot(v62)

    if not (Magnitude * 0.75 <= v63 or p47.LastPlanarSpeed * 0.75 <= v63) then
        local Hitbox = p47.Rig.Mount.Hitbox
        local v64 = Workspace:Blockcast(Hitbox.CFrame + Up * 1, Hitbox.Size * Vector3.new(0.9, 0.6, 0.9), v62 * (Magnitude * p48 + 2), p47.GhostParams)
        local v65 = v64 == nil
        local v66 = if not v65 then v64.Normal:Dot(Up) < math.cos((math.rad((MountRaceFlags.MaxGroundAngle:Get())))) else nil

        if v65 or not v66 then
            Root.AssemblyLinearVelocity = Commanded + Up * math.min(v61, p47.LastNormalSpeed)
            p47.GhostUntil = p49 + 0.4
        end
    end
end

function t2.ClampGroundPop(p50, p51, p52) -- line: 552
    local Root = p50.Rig.Root
    local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
    local v70 = AssemblyLinearVelocity:Dot(p51)

    if p52 < v70 then
        Root.AssemblyLinearVelocity = AssemblyLinearVelocity - p51 * (v70 - p52)
    end
end

function t2.ProbeBury(p53) -- line: 561
    -- upvalues: Workspace (copy), MountRaceFlags (copy), t1 (copy)
    local Hitbox = p53.Rig.Mount.Hitbox
    local CFrame = Hitbox.CFrame
    local UpVector = CFrame.UpVector
    local Size = Hitbox.Size
    local v71 = Size.Y + 2
    local v74 = math.cos((math.rad((MountRaceFlags.MaxGroundAngle:Get()))))
    local v75

    for _, v76 in t1 do
        local v79 = CFrame:PointToWorldSpace((Vector3.new(0, -Size.Y / 2, v76 * Size.Z / 2)))
        local v80 = Workspace:Raycast(v79 + UpVector * v71, -UpVector * (v71 + 3), p53.Params)

        if v80 ~= nil and v74 <= v80.Normal:Dot(UpVector) then
            local v81 = (v80.Position - v79):Dot(UpVector)

            if v75 == nil or v75 < v81 then
                v75 = v81
            end
        end
    end

    return v75
end

function t2.WallAhead(p54, p55) -- line: 582
    -- upvalues: Workspace (copy), MountRaceFlags (copy)
    local Hitbox = p54.Rig.Mount.Hitbox
    local UpVector = Hitbox.CFrame.UpVector
    local v82 = if p54.Speed >= 0 then 1 else -1
    local v86 = Workspace:Blockcast(Hitbox.CFrame + UpVector * 1, Hitbox.Size * Vector3.new(0.9, 0.6, 0.9), p54.TravelDirection * v82 * (math.abs(p54.Speed) * p55 + 2), p54.GhostParams)

    return v86 ~= nil and v86.Normal:Dot(UpVector) < math.cos((math.rad((MountRaceFlags.MaxGroundAngle:Get()))))
end

function t2.EndUnstickGhost(p56) -- line: 595
    p56.UnstickGhostUntil = 0
    p56.Rig.Mount.Hitbox.CanCollide = p56.HitboxCollides
end

function t2.Unstick(p57, p58, p59, p60) -- line: 600
    -- upvalues: RunService (copy), MountRaceFlags (copy)
    local Root = p57.Rig.Root
    local Hitbox = p57.Rig.Mount.Hitbox
    local v90 = p58 + MountRaceFlags.UnstickLift:Get()

    Root.CFrame += Hitbox.CFrame.UpVector * v90
    Root.AssemblyLinearVelocity = p57.TravelDirection * p57.Speed
    Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    p57.LastUnstickAt = p59
    p57.BuriedSeconds = 0
    p57.StalledSeconds = 0

    local v91 = MountRaceFlags.UnstickGhostSeconds:Get()

    if v91 > 0 and not p57:WallAhead(v91) then
        Hitbox.CanCollide = false
        p57.UnstickGhostUntil = p59 + v91
    end

    if RunService:IsStudio() then
        print((("[MountRace] unstuck (%*): lifted %* studs"):format(p60, (string.format("%.2f", v90)))))
    end
end

function t2.UpdateUnstick(p61, p62, p63, p64, p65, p66) -- line: 620
    -- upvalues: MountRaceFlags (copy)
    if p61.UnstickGhostUntil > 0 and p61.UnstickGhostUntil <= p63 then
        p61:EndUnstickGhost()
    end

    local v92, v93

    if p65 then
        v93 = true
    elseif not MountRaceFlags.UnstickEnabled:Get() or p63 - p61.LastUnstickAt < MountRaceFlags.UnstickCooldownSeconds:Get() then
        v93 = true
    else
        v92 = p61:ProbeBury()

        if v92 ~= nil then
            if MountRaceFlags.UnstickBuryStuds:Get() < v92 then
                p61.BuriedSeconds += p62
            else
                p61.BuriedSeconds = 0
            end
        else
            p61.BuriedSeconds = 0
        end

        v93 = false
    end

    if v93 then
        p61.BuriedSeconds = 0
        p61.StalledSeconds = 0

        return
    end

    local AssemblyLinearVelocity = p61.Rig.Root.AssemblyLinearVelocity
    local v94 = (AssemblyLinearVelocity - p61.Up * AssemblyLinearVelocity:Dot(p61.Up)):Dot(p61.TravelDirection)

    if p66 and not p61.Launched and p64 > 0.05 and p61.Speed > 10 and v94 < MountRaceFlags.UnstickStallSpeed:Get() then
        p61.StalledSeconds += p62
    else
        p61.StalledSeconds = 0
    end

    if v92 ~= nil then
        if p61.BuriedSeconds > MountRaceFlags.UnstickSeconds:Get() then
            p61:Unstick(v92, p63, "buried")
        elseif p61.StalledSeconds > MountRaceFlags.UnstickStallSeconds:Get() and not p61:WallAhead(0) then
            p61:Unstick(math.max(v92, 0), p63, "stalled")
        end
    end
end

function t2.Step(p67, p68) -- line: 668
    -- upvalues: Workspace (copy), MountRaceFlags (copy), Controls (copy)
    local Override = p67.Override

    if Override ~= nil then
        p67.Commanded = Vector3.new(0, 0, 0)
        Override(p67, p68)
    else
        local Root = p67.Rig.Root
        local elapsed = os.clock()
        local v95 = p67:IsHeld()
        local v96 = MountRaceFlags.TopSpeed:Get()

        if not v95 and (p67.Grounded or elapsed < p67.GhostUntil) then
            p67:SmoothGhostContact(p68, elapsed)
        end

        local Up = p67.Up
        local v97

        if p67.IgnoreGroundUntil <= elapsed then
            v97, Up = p67:ProbeGround()
        else
            v97 = false
        end

        local Grounded = p67.Grounded

        p67.Grounded = v97

        if v97 then
            p67.AirSeconds = 0
        else
            p67.AirSeconds += p68
        end

        if p67.StickMinRatio ~= nil and not (v97 or not (p67.AirSeconds > 0.3) and p67:RoadBelow()) then
            p67.StickMinRatio = nil
        end

        local v98 = p67.StickMinRatio ~= nil
        local v99 = if v97 then Up elseif v98 then p67.Up else Vector3.new(0, 1, 0)
        local v100 = if v97 or v98 then 14 else 2

        p67.Up = p67.Up:Lerp(v99, (math.min(1, v100 * p68))).Unit

        local Up3, PopLimit = p67.Up, p67.PopLimit

        if PopLimit >= 0 and v97 and not v95 and not v98 and not p67.Launched and elapsed - p67.LastJumpAt >= 0.6 then
            p67:ClampGroundPop(Up, PopLimit)
        end

        local Heading = p67.Heading
        local v102 = Heading - Up3 * Heading:Dot(Up3)
        local v103 = if v102.Magnitude > 0.001 then v102.Unit else nil

        if not v103 then
            local LookVector = Root.CFrame.LookVector
            local v104 = LookVector - Up3 * LookVector:Dot(Up3)

            v103 = (if v104.Magnitude > 0.001 then v104.Unit else nil) or p67.TravelDirection
        end

        if v95 then
            local LookVector = Root.CFrame.LookVector
            local v105 = LookVector - Up3 * LookVector:Dot(Up3)

            v103 = (if v105.Magnitude > 0.001 then v105.Unit else nil) or v103
            p67.TravelDirection = v103
        end

        if v97 and not Grounded then
            local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
            local v106 = AssemblyLinearVelocity - Up3 * AssemblyLinearVelocity:Dot(Up3)

            if v106.Magnitude > 1 and p67.GhostUntil <= elapsed then
                p67.Speed = v106:Dot(v103)
                p67.TravelDirection = v106.Unit * (p67.Speed >= 0 and 1 or -1)
            end

            p67.Launched = false
            p67.Landed:Fire()
        end

        local v107 = if v95 then Vector3.new(0, 0, 0) else Controls:GetMoveVector()
        local v108 = -v107.Z
        local X = v107.X

        if p67.Touch and not v95 then
            X = math.clamp(X * MountRaceFlags.TouchSteerGain:Get(), -1, 1)

            if MountRaceFlags.TouchAutoThrottle:Get() and v108 > -0.5 then
                v108 = 1
            end
        end

        local v110 = if v98 and v97 and not v95 then p67:ProbeLoopEdge(v103) else 0

        if v110 ~= 0 and X * v110 < 0 then
            X = 0
        end

        local v112 = math.clamp(math.abs(p67.Speed) / v96, 0, 1)
        local v115 = math.max(math.clamp(math.abs(p67.Speed) / 10, 0, 1), 0.35) * ((MountRaceFlags.HighSpeedSteerScale:Get() - 1) * v112 + 1)

        if p67.Handbrake then
            v115 *= MountRaceFlags.HandbrakeSteerScale:Get()
        end

        if not v97 then
            v115 *= 0.3
        end

        if v98 then
            v115 *= 0.35
        end

        local v116 = if not (p67.Speed < -1 and v108 < -0.05) then 1 else -1
        local v119 = -X * math.rad((MountRaceFlags.SteerDegreesPerSecond:Get())) * v115 * v116 * p68 - v110 * 1.2217304763960306 * p68

        if p67.Touch and v97 and not (v98 or v95) and math.abs(X) < 0.05 and p67.Speed > 10 then
            v119 += p67:AssistYaw(v103, Up3, p68)
        end

        local v120 = CFrame.fromAxisAngle(Up3, v119):VectorToWorldSpace(v103)

        p67.Heading = v120

        if v95 then
            p67.Speed = 0
        elseif v97 then
            local v121 = v96 * p67:TopSpeedScale()
            local v122 = v96 / MountRaceFlags.AccelSeconds:Get()

            if v121 < p67.Speed then
                p67.Speed = math.max(v121, p67.Speed - v122 * p68)
            elseif v108 > 0.05 then
                p67.Speed = math.min(v121, p67.Speed + v122 * v108 * p68)
            elseif v108 < -0.05 then
                if p67.Speed > 0 then
                    p67.Speed = math.max(0, p67.Speed + v96 / MountRaceFlags.BrakeSeconds:Get() * v108 * p68)
                else
                    p67.Speed = math.max(-MountRaceFlags.ReverseSpeed:Get(), p67.Speed + v122 * v108 * p68)
                end
            else
                local Speed = p67.Speed
                local v128 = v96 / MountRaceFlags.CoastSeconds:Get() * p68

                if Speed < 0 then
                    p67.Speed = math.min(Speed + v128, 0)
                else
                    p67.Speed = math.max(Speed - v128, 0)
                end
            end

            if p67.Handbrake then
                p67.Speed -= p67.Speed * MountRaceFlags.HandbrakeSpeedBleed:Get() * p68
            end

            local StickMinRatio = p67.StickMinRatio

            if StickMinRatio ~= nil then
                p67.Speed = math.max(p67.Speed, v96 * StickMinRatio)
            end
        end

        local v132 = 12 * (if p67.Handbrake then MountRaceFlags.HandbrakeGrip:Get() else 1)
        local TravelDirection = p67.TravelDirection
        local v133 = TravelDirection - Up3 * TravelDirection:Dot(Up3)
        local v136 = ((if v133.Magnitude > 0.001 then v133.Unit else nil) or v120):Lerp(v120, (math.min(1, v132 * p68)))
        local v137 = v136 - Up3 * v136:Dot(Up3)

        p67.TravelDirection = (if v137.Magnitude > 0.001 then v137.Unit else nil) or v120
        p67:UpdateUnstick(p68, elapsed, v108, v95 or v98 or elapsed < p67.IgnoreGroundUntil, v97 or p67.AirSeconds < 0.3)

        local v138 = elapsed < p67.UnstickGhostUntil

        if v97 and not v95 then
            p67:CheckWall(v120, p68)
            v120 = p67.Heading
        end

        local v139 = v120:Cross(Up3)

        p67.Drive.Enabled = v97 or v95 or v138 or elapsed < p67.GhostUntil
        p67.Drive.PrimaryTangentAxis = v120
        p67.Drive.SecondaryTangentAxis = v139

        local v140 = p67.TravelDirection * p67.Speed + v139 * v110 * 18

        p67.Drive.PlaneVelocity = Vector2.new(v140:Dot(v120), v140:Dot(v139))

        local AssemblyMass = Root.AssemblyMass
        local Gravity = Workspace.Gravity

        if v98 then
            p67.Push.Force = Vector3.new(0, 1, 0) * AssemblyMass * Gravity - Up3 * AssemblyMass * Gravity * 1.6
        elseif v138 then
            p67.Push.Force = Vector3.new(0, 1, 0) * AssemblyMass * Gravity
        elseif v97 then
            p67.Push.Force = -Up3 * AssemblyMass * Gravity * 0.4
        else
            p67.Push.Force = Vector3.new(0, 0, 0)
        end

        p67.Align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v120, Up3)
        p67.Commanded = if not p67.Drive.Enabled or v95 then Vector3.new(0, 0, 0) else v140

        local AssemblyLinearVelocity = Root.AssemblyLinearVelocity

        p67.LastNormalSpeed = AssemblyLinearVelocity:Dot(Up3)
        p67.LastPlanarSpeed = (AssemblyLinearVelocity - Up3 * p67.LastNormalSpeed).Magnitude
    end
end

return t2

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local BeanstalkEventFlags = require(ReplicatedStorage.Shared.Flags.BeanstalkEventFlags)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Juice = require(script.Parent.Parent.Parent.ScrambleBoss.Juice)
local RailRide = require(script.Parent.Parent.RailRide)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local RockFall = require(script.Parent.Parent.RockFall)
local SpeedLines = require(script.Parent.Parent.SpeedLines)

require(ReplicatedStorage.Packages.Trove)

local UISystem = require(script.Parent.Parent.UISystem)
local WhaleHearts = require(script.Parent.Parent.WhaleHearts)
local LocalPlayer = Players.LocalPlayer
local BeanstalkEventAssets = ReplicatedStorage.Assets.BeanstalkEventAssets
local BeanstalkEvent2 = ReplicatedStorage.Assets.Sounds.BeanstalkEvent
local MoonWhale = BeanstalkEventAssets.Stage3.MoonWhale
local Stage = BeanstalkEvent.Stage
local v1 = Color3.fromRGB(255, 60, 80)
local v2 = Random.new()

local function stage() -- line: 145
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

    return if typeof(Attribute) == "number" then Attribute else nil
end

local function waitUntilOver(p1, p2) -- line: 150
    -- upvalues: BeanstalkEvent (copy)
    while not BeanstalkEvent.IsOverFloor(p2, p1.Position, 60) do
        task.wait(0.2)
    end
end

local function nestApproach(p3, p4) -- line: 156
    local v3 = p3.Size * 0.5
    local v4 = p3.CFrame:PointToObjectSpace(p4)
    local v9 = p3.CFrame:PointToWorldSpace((Vector3.new(math.clamp(v4.X, -v3.X, v3.X), v3.Y, (math.clamp(v4.Z, -v3.Z, v3.Z)))))
    local v10 = (p4 - v9) * Vector3.new(1, 0, 1)

    return v9 + (if v10.Magnitude > 0.1 then v10.Unit else Vector3.new(1, 0, 0)) * 60 + Vector3.new(0, 14, 0)
end

local function buildRoute(p5, p6, p7, p8, p9) -- line: 171
    local v11 = (p6 - p5) * Vector3.new(1, 0, 1)
    local v12 = if v11.Magnitude > 0.01 then v11.Unit else Vector3.new(0, 0, 1)
    local v13 = Vector3.new(p7.X, 0, p7.Z)
    local v14 = (p5 - v13) * Vector3.new(1, 0, 1)
    local v15 = math.max(v14.Magnitude, 120)
    local v16 = if v14.Magnitude > 0.01 then v14.Unit else -v12
    local v17 = (Vector3.new(0, 1, 0)):Cross(v16)
    local v18 = p6.Y - p5.Y
    local v19 = 6.283185307179586 * p8

    local function reach(p10) -- line: 188
        -- upvalues: p9 (copy), v15 (copy)
        return v15 * (p9 * math.sin(3.141592653589793 * p10) + 1)
    end

    local function circle(p11) -- line: 192
        -- upvalues: p9 (copy), v13 (copy), v15 (copy), v16 (copy), v17 (copy), v19 (copy)
        local v21 = v19 * p11

        return v13 + (v16 * math.cos(v21) + v17 * math.sin(v21)) * (v15 * (p9 * math.sin(3.141592653589793 * p11) + 1))
    end

    local v24 = v19 * 1
    local v25 = (p6 - (v13 + (v16 * math.cos(v24) + v17 * math.sin(v24)) * (v15 * (p9 * 1.2246467991473532E-16 + 1)))) * Vector3.new(1, 0, 1)
    local v26 = v19 * 0
    local v27 = v25 - (p5 - (v13 + (v16 * math.cos(v26) + v17 * math.sin(v26)) * (v15 * (p9 * 0 + 1)))) * Vector3.new(1, 0, 1)
    local v28 = v19 * 0
    local v29 = (p5 - (v13 + (v16 * math.cos(v28) + v17 * math.sin(v28)) * (v15 * (p9 * 0 + 1)))) * Vector3.new(1, 0, 1)

    local function point(p12) -- line: 201
        -- upvalues: p5 (copy), p9 (copy), v13 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v27 (copy), v29 (copy)
        local v30 = v19 * p12

        return v13 + (v16 * math.cos(v30) + v17 * math.sin(v30)) * (v15 * (p9 * math.sin(3.141592653589793 * p12) + 1)) + v29 + v27 * p12 + Vector3.new(0, 1, 0) * (p5.Y + v18 * p12)
    end

    local function velocity(p13) -- line: 205
        -- upvalues: p9 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v27 (copy)
        local v33 = v19 * p13

        return (-v16 * math.sin(v33) + v17 * math.cos(v33)) * (v15 * (p9 * math.sin(3.141592653589793 * p13) + 1) * v19) + (v16 * math.cos(v33) + v17 * math.sin(v33)) * (v15 * p9 * 3.141592653589793 * math.cos(3.141592653589793 * p13)) + v27 + Vector3.new(0, 1, 0) * v18
    end

    local t1 = {
        0
    }
    local v40 = v19 * 0
    local v41 = v13 + (v16 * math.cos(v40) + v17 * math.sin(v40)) * (v15 * (p9 * 0 + 1)) + v29 + v27 * 0 + Vector3.new(0, 1, 0) * (p5.Y + v18 * 0)

    for i = 1, 480 do
        local v42 = i / 480
        local v43 = v19 * v42
        local v46 = v13 + (v16 * math.cos(v43) + v17 * math.sin(v43)) * (v15 * (p9 * math.sin(3.141592653589793 * v42) + 1)) + v29 + v27 * v42 + Vector3.new(0, 1, 0) * (p5.Y + v18 * v42)

        t1[i + 1] = t1[i] + (v46 - v41).Magnitude
        v41 = v46
    end

    local v47 = t1[481]

    local function timeAt(p14) -- line: 222
        -- upvalues: t1 (copy), v47 (copy)
        local v48 = math.clamp(p14, 0, v47)
        local n1 = 1
        local n2 = 481

        while n2 - n1 > 1 do
            local v49 = (n1 + n2) // 2

            if t1[v49] <= v48 then
                n1 = v49
            else
                n2 = v49
            end
        end

        local v50 = t1[n2] - t1[n1]
        local v51 = if v50 > 0 then (v48 - t1[n1]) / v50 else 0

        return (n1 - 1 + v51) / 480
    end

    local function path(p15) -- line: 239
        -- upvalues: p5 (copy), p9 (copy), v13 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v27 (copy), v29 (copy), velocity (copy), timeAt (copy)
        local v52 = timeAt(p15)
        local v53 = v19 * v52
        local v56 = v13 + (v16 * math.cos(v53) + v17 * math.sin(v53)) * (v15 * (p9 * math.sin(3.141592653589793 * v52) + 1)) + v29 + v27 * v52 + Vector3.new(0, 1, 0) * (p5.Y + v18 * v52)

        return CFrame.lookAt(v56, v56 + velocity(v52).Unit, (Vector3.new(0, 1, 0)))
    end

    return {
        Length = v47,
        Facing = v12,
        Path = path,
        Curve = function(p16) -- curve | line: 245
            -- upvalues: p5 (copy), p9 (copy), v13 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v27 (copy), v29 (copy), velocity (copy), timeAt (copy)
            local v58 = timeAt(p16 - 6)
            local v59 = v19 * v58
            local v62 = v13 + (v16 * math.cos(v59) + v17 * math.sin(v59)) * (v15 * (p9 * math.sin(3.141592653589793 * v58) + 1)) + v29 + v27 * v58 + Vector3.new(0, 1, 0) * (p5.Y + v18 * v58)
            local LookVector = CFrame.lookAt(v62, v62 + velocity(v58).Unit, (Vector3.new(0, 1, 0))).LookVector
            local v64 = timeAt(p16 + 6)
            local v65 = v19 * v64
            local v68 = v13 + (v16 * math.cos(v65) + v17 * math.sin(v65)) * (v15 * (p9 * math.sin(3.141592653589793 * v64) + 1)) + v29 + v27 * v64 + Vector3.new(0, 1, 0) * (p5.Y + v18 * v64)
            local v69 = CFrame.lookAt(v68, v68 + velocity(v64).Unit, (Vector3.new(0, 1, 0))).LookVector - LookVector
            local v70 = timeAt(p16)
            local v71 = v19 * v70
            local v74 = v13 + (v16 * math.cos(v71) + v17 * math.sin(v71)) * (v15 * (p9 * math.sin(3.141592653589793 * v70) + 1)) + v29 + v27 * v70 + Vector3.new(0, 1, 0) * (p5.Y + v18 * v70)

            return v69:Dot(CFrame.lookAt(v74, v74 + velocity(v70).Unit, (Vector3.new(0, 1, 0))).RightVector) / 12
        end
    }
end

local function playWhaleAnimation(p17) -- line: 254
    local track = p17:FindFirstChildOfClass("AnimationController"):FindFirstChildOfClass("Animator"):LoadAnimation((p17:FindFirstChildOfClass("Animation")))

    track.Looped = true
    track:Play()
end

local function spring(p18, p19, p20, p21, p22) -- line: 263
    local v76 = p19
    local v77 = math.min(p22, 0.1)

    while v77 > 0 do
        local v78 = math.min(v77, 0.008333333333333333)

        v76 += ((p20 - p18) * (p21 * p21) - v76 * (p21 * 1.8)) * v78
        p18 += v76 * v78
        v77 -= v78
    end

    return p18, v76
end

local function partsOf(p23) -- line: 282
    local t2 = {}

    for _, descendant in p23:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t2, descendant)
        end
    end

    return t2
end

local function punchFieldOfView(p24) -- line: 292
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.FieldOfView = math.max(CurrentCamera.FieldOfView - p24, 40)
end

return {
    Run = function(p25, p26, p27, _) -- Run | line: 301
        -- upvalues: Lighting (copy), SoundService (copy), TweenService (copy), Workspace (copy), BeanstalkEvent (copy), BeanstalkEventFlags (copy), Flash (copy), Juice (copy), RailRide (copy), Remotes (copy), RockFall (copy), SpeedLines (copy), UISystem (copy), WhaleHearts (copy), LocalPlayer (copy), BeanstalkEvent2 (copy), MoonWhale (copy), Stage (copy), v1 (copy), v2 (copy), waitUntilOver (copy), nestApproach (copy), buildRoute (copy), spring (copy), partsOf (copy)
        local Stage3 = p26.Sections.Stage3

        UISystem.SetFlightProgress(0)

        local v80 = BeanstalkEventFlags.FlightHearts:Get()

        WhaleHearts.Show(p25, v80)
        waitUntilOver(p27.Root, Stage3.Floor)

        local v81 = Stage3.FlyingSectionStart.Position + Vector3.new(0, 3, 0)
        local v84 = buildRoute(v81, nestApproach(p26.Sections.Stage4.Floor, Stage3.FlyingSectionEnd.Position), p26.Beanstalk:GetPivot().Position, BeanstalkEventFlags.FlightSpiralTurns:Get(), BeanstalkEventFlags.FlightSpiralBulge:Get())
        local Length, Facing, Path = v84.Length, v84.Facing, v84.Path
        local v85 = BeanstalkEventFlags.RideLateralStuds:Get()
        local v86 = BeanstalkEventFlags.FlightRockSpacingStuds:Get()
        local v87 = BeanstalkEventFlags.FlightRockFallStuds:Get()
        local v88 = v80
        local v89 = Length / BeanstalkEventFlags.FlightSeconds:Get()

        local function turnBefore(p29) -- line: 330
            -- upvalues: v84 (copy)
            for i = p29 - 110, p29, 15 do
                if math.abs((v84.Curve(i))) > 0.012 then
                    return true
                end
            end

            return false
        end

        local function attempt(p30) -- line: 339
            -- upvalues: p26 (copy), p27 (copy), Stage3 (copy), v81 (copy), v84 (copy), Length (copy), Facing (copy), Path (copy), v85 (copy), v86 (copy), v87 (copy), v88 (ref), v89 (copy), turnBefore (copy), Lighting (copy), SoundService (copy), TweenService (copy), Workspace (copy), BeanstalkEventFlags (copy), Flash (copy), Juice (copy), RailRide (copy), RockFall (copy), SpeedLines (copy), UISystem (copy), WhaleHearts (copy), BeanstalkEvent2 (copy), MoonWhale (copy), v1 (copy), v2 (copy), spring (copy), partsOf (copy)
            local v91 = p30:Add(Instance.new("Folder"))

            p30:Add(function() -- line: 341
                -- upvalues: p27 (copy), Workspace (copy)
                local CurrentCamera = Workspace.CurrentCamera

                CurrentCamera.FieldOfView = 70
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.CameraSubject = p27.Humanoid
            end)
            v91.Name = "BeanstalkWhaleFlight"
            v91.Parent = Workspace

            local clone = p30:Clone(MoonWhale)
            local v92 = clone:FindFirstChild("PlayerSitPosition", true)
            local Pivot = clone:GetPivot()
            local v93 = (Pivot.Rotation + v92.WorldPosition):Inverse() * Pivot

            local function poseWhale(p31) -- line: 356
                -- upvalues: clone (copy), v93 (copy)
                clone:PivotTo(p31 * CFrame.new(0, -2.5, 0) * v93)
            end

            local function seated(p32) -- line: 360
                -- upvalues: v92 (copy)
                return p32.Rotation + v92.WorldPosition + p32.UpVector * 2.5
            end

            local CurrentCamera = Stage3.Floor.Position.Y + Stage3.Floor.Size.Y * 0.5
            local Pivot2
            local v96 = Vector3.new(v81.X, CurrentCamera + 45, v81.Z)

            CurrentCamera = Path(0).LookVector * Vector3.new(1, 0, 1)
            Pivot2 = if CurrentCamera.Magnitude > 0.01 then CurrentCamera.Unit else Facing

            local v94 = CFrame.lookAt(v96, v96 + Pivot2)

            clone:PivotTo(v94 * CFrame.new(0, -2.5, 0) * v93)
            Pivot2 = clone:GetPivot()
            clone:ScaleTo(0.01)
            clone.Parent = v91

            local v95 = clone:FindFirstChildOfClass("AnimationController"):FindFirstChildOfClass("Animator"):LoadAnimation((clone:FindFirstChildOfClass("Animation")))

            v95.Looped = true
            v95:Play()

            local elapsed = os.clock()
            local v97

            while true do
                v97 = (os.clock() - elapsed) / 2
                v95 = math.min(v97, 1)
                v97 = (1 - TweenService:GetValue(v95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)) * 2 * 2 * 3.141592653589793
                clone:ScaleTo((math.max(TweenService:GetValue(v95, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 0.01)))
                clone:PivotTo(CFrame.new(Pivot2.Position) * CFrame.Angles(0, v97, 0) * Pivot2.Rotation)

                if v95 >= 1 then
                    break
                end

                task.wait()
            end

            p27.Humanoid.PlatformStand = true
            p30:Add(function() -- line: 400
                -- upvalues: p27 (copy)
                p27.Humanoid.PlatformStand = false
            end)
            elapsed = p27.Root.CFrame
            v95 = os.clock()

            while true do
                v97 = (os.clock() - v95) / 1

                local v98 = math.min(v97, 1)

                p27.Root.CFrame = elapsed:Lerp(v94.Rotation + v92.WorldPosition + v94.UpVector * 2.5, v98 * v98 * (3 - v98 * 2))
                p27.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                if v98 >= 1 then
                    break
                end

                task.wait()
            end

            local v99 = p30:Add(Instance.new("Highlight"))

            v99.Name = "HitFlash"
            v99.FillColor = Color3.new(1, 1, 1)
            v99.FillTransparency = 1
            v99.OutlineTransparency = 1
            v99.DepthMode = Enum.HighlightDepthMode.Occluded
            v99.Adornee = clone
            v99.Parent = clone

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Color.G > descendant.Color.R and descendant.Color.G > descendant.Color.B then
                    descendant.LocalTransparencyModifier = 0.6
                end
            end

            local v100 = RockFall.new(p30, v91, Path, v85)

            v95 = p30:Extend()

            local n3 = 1

            SpeedLines.Run(v95, function() -- line: 437
                -- upvalues: n3 (ref)
                return (n3 - 0.4) / 1.4
            end)

            local n4 = 0
            local n5 = 0
            local n6 = 0
            local elapsed2 = os.clock()
            local n7 = (-1e999)
            local v101 = Length * 0.06
            local v102 = false
            local v103 = Path(0)
            local v104 = false
            local elapsed3 = os.clock()
            local t4 = {}

            t4[1] = Vector3.new(0, 0, 0)

            local v105 = Vector3.new(0, 0, 0)
            local v106 = Vector3.new(0, 0, 1)
            local v107 = Vector3.new(0, 0, 0)
            local v108 = Vector3.new(0, 1, 0)
            local v109 = Vector3.new(0, 0, 0)

            local function flinch() -- line: 455
                -- upvalues: n7 (ref)
                local v110 = os.clock() - n7

                if v110 >= 0.7 then
                    return 0
                end

                local v111 = 1 - v110 / 0.7

                return math.sin(v110 / 0.7 * 2.5 * 2 * 3.141592653589793) * 0.4537856055185257 * v111 * v111
            end

            local function swimAway(p33, p34, p35) -- line: 467
                -- upvalues: clone (copy), v93 (copy), n4 (ref), n5 (ref), n6 (ref), Path (copy), TweenService (copy)
                local v114 = math.min(p35 / 1.1, 1)
                local v116 = n6
                local v115 = v116 + p34 * p35
                local v117 = Path(v115) + Path(v115).RightVector * n5
                local v119 = math.sin(v114 * 3.141592653589793 * 3) * 0.6981317007977318 * (1 - v114)

                clone:PivotTo(v117 * CFrame.Angles(0, 0, n4 + v119) * CFrame.new(0, -2.5, 0) * v93)

                local Value = TweenService:GetValue(v114, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                for _, v121 in p33 do
                    v121.LocalTransparencyModifier = Value
                end
            end

            local function onRockHit(p36) -- line: 480
                -- upvalues: v99 (copy), v100 (copy), n7 (ref), v102 (ref), v88 (ref), SoundService (copy), Workspace (copy), Flash (copy), RailRide (copy), RockFall (copy), WhaleHearts (copy), BeanstalkEvent2 (copy), v1 (copy)
                n7 = os.clock()
                v88 -= 1
                RockFall.Shatter(v100, p36)
                SoundService:PlayLocalSound(BeanstalkEvent2.WhaleRockHit)
                RailRide.Shake(9)

                local CurrentCamera = Workspace.CurrentCamera

                CurrentCamera.FieldOfView = math.max(CurrentCamera.FieldOfView - 12, 40)
                Flash.Play({
                    Attack = 0.02,
                    Decay = 0.4,
                    Tint = v1,
                    Opacity = v88 <= 0 and 0.6 or 0.4
                })
                v99.FillTransparency = 0
                WhaleHearts.Lose((math.max(v88, 0)))

                if v88 <= 0 then
                    v102 = true
                end
            end

            local Run = RailRide.Run
            local v124 = {
                SteerSpeed = 62,
                KeepCamera = true,
                BlendSeconds = 2.5,
                FieldOfView = 80,
                FieldOfViewPerSpeed = 20,
                Rig = p27,
                Path = Path,
                Length = Length,
                Seconds = BeanstalkEventFlags.FlightSeconds:Get(),
                Lateral = v85,
                BumpSeconds = BeanstalkEventFlags.BumpSlowdownSeconds:Get(),
                Obstacles = {},
                Mount = function(p37) -- Mount | line: 512
                    -- upvalues: clone (copy), v92 (copy), v93 (copy), n4 (ref), n7 (ref)
                    local Angles = CFrame.Angles
                    local v125 = n4
                    local v126 = os.clock() - n7
                    local v127

                    if v126 >= 0.7 then
                        v127 = 0
                    else
                        local v128 = 1 - v126 / 0.7

                        v127 = math.sin(v126 / 0.7 * 2.5 * 2 * 3.141592653589793) * 0.4537856055185257 * v128 * v128
                    end

                    local v130 = p37 * Angles(0, 0, v125 + v127)

                    clone:PivotTo(v130 * CFrame.new(0, -2.5, 0) * v93)

                    return v130.Rotation + v92.WorldPosition + v130.UpVector * 2.5
                end,
                Camera = function(p38, p39) -- Camera | line: 518
                    -- upvalues: v104 (ref), elapsed3 (ref), t4 (copy), v105 (ref), v106 (ref), v107 (ref), v108 (ref), v109 (ref), Workspace (copy), spring (copy)
                    local elapsed = os.clock()
                    local v131 = elapsed - elapsed3

                    elapsed3 = elapsed

                    if not v104 then
                        v104 = true

                        local CFrame = Workspace.CurrentCamera.CFrame

                        t4[1] = p39.Position
                        v106 = CFrame.LookVector
                        v108 = CFrame.UpVector
                    end

                    local v132, v133 = spring(t4[1], v105, p39.Position, 10, v131)

                    t4[1] = v132
                    v105 = v133
                    v106, v107 = spring(v106, v107, p38.LookVector, 4.5, v131)
                    v108, v109 = spring(v108, v109, p38.UpVector, 4.5, v131)

                    local v134 = if v106.Magnitude > 0.01 then v106.Unit else p38.LookVector
                    local v135 = if v108.Magnitude > 0.01 then v108.Unit else p38.UpVector
                    local v136 = t4[1] - v134 * 118 + v135 * 42

                    return CFrame.lookAt(v136, t4[1] + v134 * 45, v135)
                end,
                SpeedScale = function(p40) -- SpeedScale | line: 542
                    if p40 >= 0.88 then
                        return 1.8
                    end

                    return 1
                end,
                SteerLocked = function(p41) -- SteerLocked | line: 545
                    return p41 >= 0.9
                end,
                Probe = function(p42, p43) -- Probe | line: 548
                    -- upvalues: v99 (copy), v100 (copy), n4 (ref), n5 (ref), n6 (ref), elapsed2 (ref), n7 (ref), v101 (ref), v102 (ref), v103 (ref), onRockHit (copy), v84 (copy), Length (copy), Path (copy), v86 (copy), v87 (copy), v89 (copy), turnBefore (copy), SoundService (copy), RailRide (copy), RockFall (copy), BeanstalkEvent2 (copy)
                    local elapsed = os.clock()
                    local v138 = math.min(elapsed - elapsed2, 0.1)

                    elapsed2 = elapsed

                    local v139 = Path(p42)

                    v103 = v139

                    local v140 = v139.RightVector:Dot(p43.Position - v139.Position)
                    local v141 = if v138 > 0 then (v140 - n5) / v138 else 0

                    n5 = v140
                    n6 = p42

                    local v143 = math.clamp(-(v84.Curve(p42) * 8 + v141 * 0.0045), -0.5585053606381855, 0.5585053606381855)
                    local v144 = n4

                    n4 = v144 + (v143 - n4) * math.min(v138 * 5, 1)

                    local v147 = elapsed - n7

                    if v147 < 1.1 then
                        local v149 = math.floor(v147 * 12) % 2 == 0

                        v99.FillTransparency = if v147 < 0.12 then v147 / 0.12 * 0.4 elseif v149 then 0.55 else 1
                    elseif v99.FillTransparency < 1 then
                        v99.FillTransparency = 1
                    end

                    local v151 = p42 / Length

                    if v151 >= 0.06 and p42 + 450 <= Length * 0.84 and v101 <= p42 then
                        local v152 = p42 + 450
                        local v153 = v87 * (v152 - p42) / v89

                        v101 = if turnBefore(v152) then p42 + 20 else p42 + RockFall.Wave(v100, v152, v151, v87, v153, v87 / v89, v86)
                    end

                    local v155, v156 = RockFall.Step(v100, v138, p42, v140, v147 >= 1.1 and not v102)

                    if v156 then
                        SoundService:PlayLocalSound(BeanstalkEvent2.WhaleNearMiss)
                        RailRide.Shake(1.6)
                    end

                    if not v155 then
                        return nil
                    end

                    local Position = v155.Position

                    onRockHit(v155)

                    return Position
                end,
                Stop = function() -- Stop | line: 617
                    -- upvalues: v102 (ref)
                    return v102
                end,
                OnStep = function(p44, _, p46) -- OnStep | line: 620
                    -- upvalues: n3 (ref), Length (copy), UISystem (copy)
                    n3 = p46
                    UISystem.SetFlightProgress(p44 / Length)
                end
            }

            Run(p30, v124)
            v95:Clean()

            local v157, v158, v159, v160, v161, v162, v163, _CFrame, v164, v165, v166, v167, v168, v169, v170, v171, v172

            if v102 then
                RockFall.Clear(v100)
                Run = Workspace.CurrentCamera
                Run.CameraType = Enum.CameraType.Scriptable
                p27.Humanoid.PlatformStand = true
                _CFrame = Run.CFrame
                v124 = p27.Root.CFrame
                v157 = clone:GetPivot()
                v164 = os.clock() + 0.14

                while os.clock() < v164 do
                    Run.CFrame = _CFrame
                    p27.Root.CFrame = v124
                    p27.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    clone:PivotTo(v157)
                    task.wait()
                end

                SoundService:PlayLocalSound(BeanstalkEvent2.WhaleKnockedOff)
                UISystem.SetPrompt("Knocked off!")
                v164 = p30:Add(Instance.new("ColorCorrectionEffect"))
                v164.Name = "WhaleKnockedOff"
                v164.Parent = Lighting
                TweenService:Create(v164, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    Saturation = -0.7,
                    Contrast = 0.15
                }):Play()
                TweenService:Create(Run, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                    FieldOfView = 62
                }):Play()
                v157 = if n5 >= 0 then 1 else -1
                v165 = v103.UpVector * 38 + Vector3.new(0, 34, 0) + v103.RightVector * (v157 * 14)
                v157 = (v103.RightVector + v2:NextUnitVector() * 0.35).Unit
                v166 = v89 * 0.7
                v167 = partsOf(clone)
                v158 = _CFrame.Position
                v159 = v124.Position
                v161 = os.clock()
                v171 = Vector3.new(0, 0, 0)
                v160 = Vector3.new(0, 0, 0)
                v168 = v161
                v172 = false

                while true do
                    v162 = os.clock()
                    v163 = v162 - v161
                    v169 = v162 - v168
                    v170 = v124.Position + v165 * v163 - Vector3.new(0, 1, 0) * (35 * v163 * v163)
                    p27.Root.CFrame = CFrame.new(v170) * CFrame.fromAxisAngle(v157, 5.585053606381854 * v163) * v124.Rotation
                    p27.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    p27.Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    swimAway(v167, v166, v163)
                    v158, v171 = spring(v158, v171, _CFrame.Position + (v170 - v124.Position) * 0.55, 3, v169)
                    v159, v160 = spring(v159, v160, v170, 6, v169)
                    Run.CFrame = CFrame.lookAt(v158, v159)

                    if not v172 and v163 >= 1.15 then
                        v172 = true
                        Flash.Play({
                            Attack = 0.35,
                            Decay = 0.9,
                            Opacity = 1,
                            Tint = Color3.new(1, 1, 1)
                        })
                    end

                    if v163 >= 1.5 then
                        break
                    end

                    v168 = v162
                    task.wait()
                end

                v164.Saturation = 0
                v164.Contrast = 0
                Run.FieldOfView = 70
                p27.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                p27.Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                p27.Root.CFrame = Stage3.SpawnLocation.CFrame + Vector3.new(0, 4, 0)
                p27.Humanoid.PlatformStand = false
                Run.CameraType = Enum.CameraType.Custom
                Run.CameraSubject = p27.Humanoid
                UISystem.SetPrompt(nil)
                UISystem.SetFlightProgress(0)

                return false
            end

            CurrentCamera = Workspace.CurrentCamera
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            Run = CurrentCamera.CFrame.Position
            _CFrame = p26.Sections.Stage4.SpawnLocation.Position + Vector3.new(0, 3, 0)
            v124 = (_CFrame - p27.Root.Position) * Vector3.new(1, 0, 1)
            v157 = if v124.Magnitude > 0.1 then v124.Unit else Facing
            p27.Root.CFrame = CFrame.lookAt(p27.Root.Position, p27.Root.Position + v157)
            Juice.Throw(p27.Root, p27.Humanoid, _CFrame, 1.8)
            v164 = partsOf(clone)

            local v173 = v89 * 0.7

            v162 = p27.Root.Position
            v167 = p27.Root.Position
            v158 = os.clock()
            v163 = Vector3.new(0, 0, 0)
            v171 = v158

            local Position

            while true do
                v159 = os.clock()
                v160 = v159 - v158
                v161 = v159 - v171
                swimAway(v164, v173, v160)
                Position = p27.Root.Position
                v168 = if v161 > 0 then (Position - v167) / v161 else Vector3.new(0, 0, 0)
                v172 = Position:Lerp(_CFrame, 0.2) + v168 * 0.18
                v162, v163 = spring(v162, v163, v172, 10, v161)
                v170 = (p27.Root.Position - Run).Magnitude
                v169 = math.atan(24 / math.max(v170, 1)) * 2

                local v176 = math.clamp(math.deg(v169), 14, 70)

                v170 = CurrentCamera.FieldOfView
                v169 = v176 - CurrentCamera.FieldOfView
                CurrentCamera.FieldOfView = v170 + v169 * math.min(4 * v161, 1)
                CurrentCamera.CFrame = CFrame.lookAt(Run, v162)

                if v160 >= 1.8 then
                    break
                end

                v171 = v159
                task.wait()
                v167 = Position
            end

            SoundService:PlayLocalSound(BeanstalkEvent2.SlideHit)
            v171 = CurrentCamera.FieldOfView
            v159 = os.clock()

            while true do
                v160 = (os.clock() - v159) / 0.35
                Position = math.min(v160, 1)
                v161 = Position * 3.141592653589793
                v166 = math.sin(v161) * (1 - Position * 0.5) * 1.6
                v168 = Position * 3.141592653589793
                CurrentCamera.FieldOfView = v171 - math.sin(v168) * 4
                CurrentCamera.CFrame = CFrame.lookAt(Run - Vector3.new(0, 1, 0) * v166, v162 - Vector3.new(0, 1, 0) * v166 * 0.4)

                if Position >= 1 then
                    break
                end

                task.wait()
            end

            v171 = _CFrame - v157 * 14 + Vector3.new(0, 7, 0)
            v158 = _CFrame + v157 * 6
            v165 = CurrentCamera.CFrame.Position
            v164 = CurrentCamera.FieldOfView
            v159 = os.clock()

            while true do
                v160 = (os.clock() - v159) / 1.8
                Position = math.min(v160, 1)

                local Value = TweenService:GetValue(Position, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local v177 = v165:Lerp(v171, Value)

                v162 = Value * 3.141592653589793
                Run = v177 + Vector3.new(0, 1, 0) * (math.sin(v162) * 30)
                v177 = p27.Root.Position:Lerp(v158, Value)
                CurrentCamera.CFrame = CFrame.lookAt(Run, v177)
                CurrentCamera.FieldOfView = v164 + (70 - v164) * Value

                if Position >= 1 then
                    break
                end

                task.wait()
            end

            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = p27.Humanoid

            return true
        end

        while true do
            local v178 = p25:Extend()

            if attempt(v178) then
                break
            end

            v178:Clean()
            v88 = v80
            WhaleHearts.Refill(v80)
        end

        while true do
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            if Attribute == Stage.WhaleFlight then
                Remotes.BeanstalkEvent.AskFinishFlight:FireServer()
                task.wait(2)
                continue
            end

            break
        end
    end
}

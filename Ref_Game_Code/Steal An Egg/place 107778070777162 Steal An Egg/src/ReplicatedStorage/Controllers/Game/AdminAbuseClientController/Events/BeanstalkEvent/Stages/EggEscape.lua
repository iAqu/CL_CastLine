-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local BeanstalkEventFlags = require(ReplicatedStorage.Shared.Flags.BeanstalkEventFlags)
local BeanstalkGrowth = require(script.Parent.Parent.BeanstalkGrowth)
local Music = require(script.Parent.Parent.Music)
local RailRide = require(script.Parent.Parent.RailRide)
local SpeedLines = require(script.Parent.Parent.SpeedLines)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local UISystem = require(script.Parent.Parent.UISystem)
local WhaleHearts = require(script.Parent.Parent.WhaleHearts)
local LocalPlayer = Players.LocalPlayer
local BeanstalkEventAssets = ReplicatedStorage.Assets.BeanstalkEventAssets
local Egg, CosmicLion = BeanstalkEventAssets.Stage4.Egg, BeanstalkEventAssets.Stage4.CosmicLion
local SlideObstacles = BeanstalkEventAssets.SlideObstacles
local BeanstalkEvent2 = ReplicatedStorage.Assets.Sounds.BeanstalkEvent
local Roar, Step, Swoosh = ReplicatedStorage.Assets.Sounds.ScrambleBoss.Roar, ReplicatedStorage.Assets.Sounds.ScrambleBoss.Step, ReplicatedStorage.Assets.Sounds.ScrambleBoss.Swoosh
local Stage = BeanstalkEvent.Stage
local v1 = CFrame.new(0, 1, -2.5)
local VineTrack = BeanstalkEventAssets.VineTrack
local v2 = Random.new()
local t1 = {}

for _, child in SlideObstacles.Hazards:GetChildren() do
    assert(child:IsA("Model"), (("SlideObstacles.Hazards.%* must be a Model"):format(child.Name)))

    local BoundingBox, BoundingBox2 = child:GetBoundingBox()

    table.insert(t1, {
        Template = child,
        Across = (if BoundingBox2.X >= BoundingBox2.Z then CFrame.identity else CFrame.Angles(0, 1.5707963267948966, 0)) * BoundingBox:ToObjectSpace(child:GetPivot()),
        HalfLength = math.max(BoundingBox2.X, BoundingBox2.Z) * 0.5,
        HalfHeight = BoundingBox2.Y * 0.5
    })
end

assert(#t1 > 0, "SlideObstacles.Hazards is empty")

local t3 = {}

for v5, v6 in {
        Straight = 0,
        Left45 = 1,
        Right45 = -1
    } do
    local v7 = VineTrack:FindFirstChild(v5)

    assert(v7 ~= nil and v7:IsA("Model"), (("VineTrack.%* must be a Model"):format(v5)))

    local v10 = v7:FindFirstChild("End", true)

    assert(v10 ~= nil and v10:IsA("Attachment"), (("VineTrack.%* needs an End attachment"):format(v5)))

    local v13 = v7:GetPivot():ToObjectSpace(v10.WorldCFrame)
    local v14 = -v6 * 3.141592653589793 / 4

    assert(math.abs(math.atan2(-v13.YVector.X, v13.YVector.Y) - v14) < 0.017453292519943295 and v13.ZVector.Z > 0.999, (("VineTrack.%*'s End must be a level %* degree turn"):format(v5, v6 * 45)))

    local Position = v13.Position
    local v19 = if v6 == 0 then 0 else Position.Y / 0.7071067811865475
    local v20 = if v6 == 0 then Position.Y else v19 * 3.141592653589793 / 4

    t3[v5] = {
        Template = v7,
        Turn = v6,
        Offset = CFrame.new(Position) * CFrame.Angles(0, 0, v14),
        Radius = v19,
        Length = math.sqrt(v20 ^ 2 + Position.Z ^ 2)
    }
end

local Straight, Left45, Right45 = t3.Straight, t3.Left45, t3.Right45
local t5 = {
    { Straight },
    { Straight, Straight },
    { Straight, Straight, Straight },
    { Left45, Straight },
    { Right45, Straight },
    { Left45, Left45, Straight },
    { Right45, Right45, Straight },
    { Straight, Left45, Right45, Straight },
    { Straight, Right45, Left45, Straight }
}

local function stage() -- line: 236
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

    return if typeof(Attribute) == "number" then Attribute else nil
end

local function stealCounted() -- line: 242
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

    if typeof(Attribute) == "number" then
        return Attribute >= 1
    end

    return false
end

local function floorTop(p1) -- line: 247
    return p1.Position.Y + p1.Size.Y * 0.5
end

local function waitUntilOver(p2, p3) -- line: 251
    -- upvalues: BeanstalkEvent (copy)
    while not BeanstalkEvent.IsOverFloor(p3, p2.Position, 60) do
        task.wait(0.2)
    end
end

local function flat(p4) -- line: 257
    return (Vector3.new(p4.X, 0, p4.Z))
end

local function isInside(p5, p6) -- line: 261
    local v22 = p5.CFrame:PointToObjectSpace(p6)

    if math.abs(v22.X) <= p5.Half.X then
        if not (math.abs(v22.Y) <= p5.Half.Y) then
            return false
        end

        return math.abs(v22.Z) <= p5.Half.Z
    end

    return false
end

local function paddedBox(p7, p8) -- line: 266
    local BoundingBox, BoundingBox2 = p7:GetBoundingBox()

    return {
        CFrame = BoundingBox,
        Half = BoundingBox2 * 0.5 + Vector3.new(1, 1, 1) * p8
    }
end

local function pieceLocal(p9, p10) -- line: 272
    local OffsetPosition = p9.Offset.Position

    if p9.Turn == 0 then
        return OffsetPosition * p10, OffsetPosition.Unit
    end

    local Turn, Radius = p9.Turn, p9.Radius

    local function arc(p11) -- line: 278
        -- upvalues: Turn (copy), Radius (copy)
        return (Vector3.new(Turn * Radius * (1 - math.cos(p11)), Radius * math.sin(p11), 0))
    end

    local v25 = p10 * 3.141592653589793 / 4
    local v29 = Vector3.new(OffsetPosition.X, OffsetPosition.Y, 0) - Vector3.new(Turn * Radius * 0.2928932188134524, Radius * 0.7071067811865475, 0)

    return Vector3.new(Turn * Radius * (1 - math.cos(v25)), Radius * math.sin(v25), 0) + v29 * p10 + Vector3.new(0, 0, OffsetPosition.Z * p10), (Vector3.new(Turn * math.sin(v25), math.cos(v25), 0) * (Radius * 3.141592653589793 / 4) + Vector3.new(0, 0, OffsetPosition.Z)).Unit
end

local function cellKey(p12, p13) -- line: 289
    return (("%*,%*"):format(math.floor(p12 / 50), (math.floor(p13 / 50))))
end

local function randomWaypoint(p14, p15) -- line: 293
    local v41 = p14.Bounds.Half * 0.85
    local v44 = p14.Bounds.CFrame:PointToWorldSpace((Vector3.new(p15:NextNumber(-v41.X, v41.X), 0, p15:NextNumber(-v41.Z, v41.Z))))

    return (Vector3.new(v44.X, 0, v44.Z))
end

local function tryGenerate(p16, p17, p18) -- line: 300
    -- upvalues: Straight (copy), Left45 (copy), Right45 (copy), t5 (copy), pieceLocal (copy), randomWaypoint (copy)
    local t6 = {}
    local t7 = {}
    local v45 = p16
    local n1 = 0
    local n2 = 0

    local function fits(p19, p20, p21) -- line: 308
        -- upvalues: p17 (copy), t7 (copy), pieceLocal (copy)
        local t8 = {}
        local v47 = math.ceil(p19.Length / 10)

        for i = 1, v47 do
            local v48 = p20:PointToWorldSpace((pieceLocal(p19, i / v47)))
            local v49 = v48 - p17.Axis

            if Vector3.new(v49.X, 0, v49.Z).Magnitude < 65 then
                return nil
            end

            local v50 = p17.Bounds.CFrame:PointToObjectSpace(v48)
            local v51 = math.abs(v50.X) > p17.Bounds.Half.X
            local v52 = if not v51 then math.abs(v50.Z) > p17.Bounds.Half.Z else nil

            if v51 or v52 then
                return nil
            end

            if p21 > 2 then
                for _, v53 in p17.Boxes do
                    local v54 = v53.CFrame:PointToObjectSpace(v48)

                    if math.abs(v54.X) <= v53.Half.X and math.abs(v54.Y) <= v53.Half.Y and math.abs(v54.Z) <= v53.Half.Z then
                        return nil
                    end
                end
            end

            local v56 = math.floor(v48.X / 50)
            local v58 = math.floor(v48.Z / 50)

            for j = -1, 1 do
                for k = -1, 1 do
                    for _, v59 in t7[("%*,%*"):format(v56 + j, v58 + k)] or {} do
                        if v59.Index < p21 - 2 then
                            local v60 = v59.Position - v48

                            if Vector3.new(v60.X, 0, v60.Z).Magnitude < 50 and math.abs(v59.Position.Y - v48.Y) < 60 then
                                return nil
                            end
                        end
                    end
                end
            end

            table.insert(t8, v48)
        end

        return t8
    end

    local function nextRun(p22, p23) -- line: 347
        if p23.Turn == 0 then
            return 0
        end

        if p22 * p23.Turn > 0 then
            return p22 + p23.Turn
        end

        return p23.Turn
    end

    local function commit(p24, p25) -- line: 354
        -- upvalues: t6 (copy), t7 (copy), v45 (ref), n1 (ref), n2 (ref)
        table.insert(t6, {
            Piece = p24,
            Joint = v45,
            StartDistance = n1
        })

        for _, v62 in p25 do
            local X, Z = v62.X, v62.Z
            local v66 = ("%*,%*"):format(math.floor(X / 50), (math.floor(Z / 50)))
            local v67 = t7[v66]

            if v67 == nil then
                v67 = {}
                t7[v66] = v67
            end

            table.insert(v67, {
                Position = v62,
                Index = #t6
            })
        end

        local v68 = v45

        v45 = v68 * p24.Offset

        local v69 = n1

        n1 = v69 + p24.Length

        local v70 = n2

        n2 = if p24.Turn == 0 then 0 elseif v70 * p24.Turn > 0 then v70 + p24.Turn else p24.Turn
    end

    local function uncommit(p26) -- line: 371
        -- upvalues: t6 (copy), t7 (copy)
        for _, v71 in p26 do
            local X, Z = v71.X, v71.Z
            local v75 = t7[("%*,%*"):format(math.floor(X / 50), (math.floor(Z / 50)))]

            v75[#v75] = nil
        end

        table.remove(t6)
    end

    local function tryMove(p27) -- line: 380
        -- upvalues: t6 (copy), v45 (ref), n2 (ref), fits (copy)
        local t11 = {}
        local v76 = v45
        local v77 = n2

        for v78, v79 in p27 do
            if v79.Turn == 0 then
                v77 = 0
            elseif v77 * v79.Turn > 0 then
                v77 += v79.Turn
            else
                v77 = v79.Turn
            end

            local v80 = if math.abs(v77) <= 2 then fits(v79, v76, #t6 + v78) else nil

            if v80 == nil then
                return nil, v76
            end

            table.insert(t11, v80)
            v76 *= v79.Offset
        end

        return t11, v76
    end

    for _ = 1, 2 do
        local v81 = fits(Straight, v45, #t6 + 1)

        if v81 == nil then
            return nil
        end

        commit(Straight, v81)
    end

    local LandingPosition = p17.Landing.Position
    local v82 = Vector3.new(LandingPosition.X, 0, LandingPosition.Z)
    local v83 = p18:NextNumber(p17.MinLength, p17.MaxLength)
    local t12

    for _ = 1, 400 do
        t12 = {}

        local Position = v45.Position
        local v84 = Vector3.new(Position.X, 0, Position.Z)
        local n3 = 0
        local v85 = true

        for _ = 1, 3 do
            local v86 = randomWaypoint(p17, p18)

            n3 += (v86 - v84).Magnitude
            v84 = v86
            v85 = v85 and (v86 - v82).Magnitude > 400
            table.insert(t12, v86)
        end

        local v87 = (n3 + (v82 - v84).Magnitude) * 1.08
        local v88 = (n1 + v87) / v83

        if v88 > 0.92 and v88 < 1.04 and v85 then
            table.insert(t12, v82)
            break
        end

        t12 = nil
    end

    if t12 ~= nil then
        local n4 = 1

        while true do
            local v89 = t12[n4]
            local v90 = v89 - v45.Position
            local Magnitude = Vector3.new(v90.X, 0, v90.Z).Magnitude

            if n4 < #t12 and Magnitude < 200 then
                n4 += 1
                continue
            end

            if n4 ~= #t12 or not (Magnitude < 300) then
                if p17.MaxLength < n1 then
                    return nil
                end

                local v91, v92
                local n5 = (-1e999)

                for _, v93 in t5 do
                    local v94, v95 = tryMove(v93)

                    if v94 ~= nil then
                        local n6 = 0

                        for _, v96 in v93 do
                            n6 += v96.Length
                        end

                        local v97 = v89 - v95.Position
                        local v98 = Vector3.new(v97.X, 0, v97.Z)
                        local v99 = (Magnitude - v98.Magnitude) / n6
                        local v100 = 1

                        if v98.Magnitude > 1 then
                            local YVector = v95.YVector

                            v100 = Vector3.new(YVector.X, 0, YVector.Z).Unit:Dot(v98.Unit)
                        end

                        local v101 = v99 + v100 * 0.5 + p18:NextNumber() * 0.6

                        if n5 < v101 then
                            n5 = v101
                            v91 = v93
                            v92 = v94
                        end
                    end
                end

                if v91 == nil or v92 == nil then
                    return nil
                end

                for v102, v103 in v91 do
                    commit(v103, v92[v102])
                end

                continue
            end

            break
        end

        local Landing = p17.Landing
        local n7 = 6000

        local function search(p28) -- line: 475
            -- upvalues: v45 (ref), n1 (ref), n2 (ref), commit (copy), uncommit (copy), tryMove (copy), Landing (copy), n7 (ref), search (copy), Straight (copy), Left45 (copy), Right45 (copy)
            local v104 = Landing.CFrame:PointToObjectSpace(v45.Position)
            local v105 = math.abs(v104.X) <= Landing.Size.X * 0.5
            local v106 = if v105 then math.abs(v104.Z) <= Landing.Size.Z * 0.5 else nil

            if v105 and v106 then
                return true
            end

            if p28 ~= 0 and not (n7 <= 0) then
                local t13 = {}

                for _, v107 in { Straight, Left45, Right45 } do
                    local v108, v109 = tryMove({ v107 })

                    if v108 ~= nil then
                        local t14 = {
                            Piece = v107,
                            Points = v108[1]
                        }
                        local v110 = Landing.Position - v109.Position

                        t14.Distance = Vector3.new(v110.X, 0, v110.Z).Magnitude
                        table.insert(t13, t14)
                    end
                end

                table.sort(t13, function(p29, p30) -- line: 489
                    return p29.Distance < p30.Distance
                end)

                for _, v111 in t13 do
                    n7 -= 1

                    local v112 = v45
                    local v113 = n1
                    local v114 = n2

                    commit(v111.Piece, v111.Points)

                    if search(p28 - 1) then
                        return true
                    end

                    uncommit(v111.Points)
                    v45 = v112
                    n1 = v113
                    n2 = v114
                end
            end

            return false
        end

        if search(8) and not (p17.MinLength > n1) and not (p17.MaxLength < n1) and not (v45.Position.Y < p17.MinEndHeight) then
            return t6
        end
    end

    return nil
end

local function buildSlide(p31, p32, p33) -- line: 514
    -- upvalues: BeanstalkEventFlags (copy), BeanstalkGrowth (copy), Straight (copy), pieceLocal (copy), tryGenerate (copy)
    local Sections = p33.Sections
    local SlideEntrance = Sections.Stage4.SlideEntrance
    local LookVector = SlideEntrance.CFrame.LookVector
    local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
    local v116 = CFrame.fromMatrix(SlideEntrance.Position + Vector3.new(0, SlideEntrance.Size.Y * 0.5, 0), (Vector3.new(0, 1, 0)):Cross(Unit), Unit)
    local v117 = BeanstalkGrowth.Axis(0)
    local BoundingBox, BoundingBox2 = Sections.Stage2:GetBoundingBox()
    local t15 = {
        CFrame = BoundingBox,
        Half = BoundingBox2 * 0.5 + Vector3.new(50, 50, 50)
    }
    local v118 = BeanstalkEventFlags.SlideSeconds:Get()
    local BoundingBox3, BoundingBox4 = Sections.Stage3:GetBoundingBox()
    local t17 = {
        CFrame = BoundingBox3,
        Half = BoundingBox4 * 0.5 + Vector3.new(50, 50, 50)
    }
    local BoundingBox5, BoundingBox6 = Sections.Stage4:GetBoundingBox()
    local t16 = {
        Boxes = {
            t15,
            t17,
            {
                CFrame = BoundingBox5,
                Half = BoundingBox6 * 0.5 + Vector3.new(40, 40, 40)
            }
        },
        Axis = v117,
        Bounds = {
            Half = Vector3.new(1400, 0, 1400),
            CFrame = CFrame.new(v117)
        },
        Landing = Sections.Stage1.SlideLanding,
        MinLength = (v118 - 2) * 75 - 78.125,
        MaxLength = (v118 + 2) * 75 - 78.125,
        MinEndHeight = t15.CFrame.Position.Y + t15.Half.Y + 100
    }
    local v119 = Random.new()
    local v120, v121

    for _ = 1, 60 do
        local v122 = tryGenerate(v116, t16, v119)

        v120 = v122

        if v122 ~= nil then
            v121 = v122
            break
        end

        v121 = v122
    end

    assert(v121 ~= nil, (`No vine track fit in {60} attempts; check the map layout and SlideLanding`))

    local t18 = {}

    for _, v125 in v121 do
        local clone = p31:Clone(v125.Piece.Template)

        clone:PivotTo(v125.Joint)
        clone.Parent = p32

        if v125.Piece.Turn == 0 then
            table.insert(t18, v125.StartDistance + v125.Piece.Length * 0.5)
        end
    end

    local v127 = v121[#v121]

    return {
        Path = function(p34) -- path | line: 553
            -- upvalues: v120 (ref), pieceLocal (copy)
            local v128 = 1
            local v129 = #v120

            while v128 < v129 do
                local v130 = (v128 + v129 + 1) // 2

                if v120[v130].StartDistance <= p34 then
                    v128 = v130
                else
                    v129 = v130 - 1
                end
            end

            local v131 = v120[v128]
            local v133 = math.clamp((p34 - v131.StartDistance) / v131.Piece.Length, 0, 1)
            local v134, v135 = pieceLocal(v131.Piece, v133)
            local v136 = v131.Joint:PointToWorldSpace(v134) + Vector3.new(0, 3, 0)

            return CFrame.lookAt(v136, v136 + v131.Joint:VectorToWorldSpace(v135))
        end,
        Length = v127.StartDistance + v127.Piece.Length,
        EntryLength = 2 * Straight.Length,
        StraightMiddles = t18
    }
end

local function standOn(p35, p36) -- line: 579
    local BoundingBox, BoundingBox2 = p35:GetBoundingBox()

    return p36 * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(p35:GetPivot())
end

local function onMarker(p37, p38) -- line: 585
    local _CFrame = p38.CFrame
    local BoundingBox, BoundingBox2 = p37:GetBoundingBox()

    return _CFrame * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(p37:GetPivot())
end

local function isNear(p39, p40, p41, p42) -- line: 589
    local v137 = p39.Position - p40

    if not (Vector3.new(v137.X, 0, v137.Z).Magnitude <= p41) then
        return false
    end

    return math.abs(v137.Y) <= p42
end

local function placeObstacles(p43, p44, p45) -- line: 594
    -- upvalues: v2 (copy), t1 (copy)
    local t19 = {}
    local n8 = 250

    while n8 < p45.Length - 150 do
        local v138 = if v2:NextNumber() < 0.5 then -1 else 1
        local v139 = p45.Path(n8)
        local v140 = t1[v2:NextInteger(1, #t1)]
        local v143 = math.max(10 - v140.HalfLength, v140.HalfLength - 6)
        local clone = p43:Clone(v140.Template)

        clone:PivotTo(v139 * CFrame.new(v138 * v143, v140.HalfHeight + -3, 0) * v140.Across)
        clone.Parent = p44
        table.insert(t19, clone)
        n8 += 140
    end

    return t19
end

local function punchCamera(p46) -- line: 612
    -- upvalues: TweenService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView

    p46:Add(function() -- line: 615
        -- upvalues: CurrentCamera (copy), FieldOfView (copy)
        CurrentCamera.FieldOfView = FieldOfView
    end)
    TweenService:Create(CurrentCamera, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FieldOfView = 50
    }):Play()
    task.delay(0.25, function() -- line: 619
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), TweenService (copy)
        TweenService:Create(CurrentCamera, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            FieldOfView = FieldOfView
        }):Play()
    end)
end

local function dropLion(p47, p48) -- line: 625
    -- upvalues: SoundService (copy), RailRide (copy), Roar (copy)
    local v144 = p48 + Vector3.new(0, 250, 0)
    local elapsed = os.clock()

    while true do
        local v146 = math.min((os.clock() - elapsed) / 1.2, 1)

        p47:PivotTo(v144:Lerp(p48, v146 * v146))

        if v146 >= 1 then
            break
        end

        task.wait()
    end

    SoundService:PlayLocalSound(Roar)
    RailRide.Shake(8)
end

local function playLionRun(p49, p50) -- line: 640
    local track = p50:FindFirstChildWhichIsA("AnimationController", true):FindFirstChildOfClass("Animator"):LoadAnimation((p50:FindFirstChildOfClass("Animation")))

    track.Looped = true
    track:Play()
    p49:Add(function() -- line: 646
        -- upvalues: track (copy)
        track:Stop()
        track:Destroy()
    end)

    return track
end

local function carryEgg(p51, p52, p53) -- line: 655
    -- upvalues: v1 (copy)
    local v147 = p51:Extend()
    local Animator = p52.Humanoid:FindFirstChildOfClass("Animator")
    local v148 = v147:Add(Instance.new("Animation"))

    v148.AnimationId = "rbxassetid://102039335618606"

    local track = Animator:LoadAnimation(v148)

    track.Looped = true
    track:Play()
    v147:Add(function() -- line: 663
        -- upvalues: track (copy)
        track:Stop()
    end)

    local Scale = p53:GetScale()
    local elapsed = os.clock()
    local v149 = false

    v147:BindToRenderStep("BeanstalkEggCarry", Enum.RenderPriority.Camera.Value + 3, function() -- line: 670
        -- upvalues: p52 (copy), p53 (copy), Scale (copy), elapsed (copy), v149 (ref), v1 (copy)
        if not v149 then
            local v151 = math.min((os.clock() - elapsed) / 0.3, 1)

            p53:ScaleTo(Scale + (0.55 - Scale) * v151)
            v149 = v151 >= 1
        end

        p53:PivotTo(p52.Root.CFrame * v1)
    end)
end

local function nearestDistance(p54, p55) -- line: 681
    local Length = p54.Length
    local n9 = 0
    local n10 = 1e999

    for i = 0, Length, 10 do
        local Magnitude = (p54.Path(i).Position - p55).Magnitude

        if Magnitude < n10 then
            n10 = Magnitude
            n9 = i
        end
    end

    return n9
end

local function newChase() -- line: 693
    return {
        CloseUntil = (-1e999),
        PounceAt = (-1e999),
        ImpactAt = (-1e999),
        RecoverUntil = (-1e999),
        LastHit = (-1e999)
    }
end

local function canCrash(p56, p57) -- line: 697
    if p56.PounceAt == (-1e999) and p56.RecoverUntil <= p57 then
        return p57 - p56.LastHit >= 0.65
    end

    return false
end

local function hitChase(p58, p59) -- line: 701
    if p58.PounceAt ~= (-1e999) or not (p58.RecoverUntil <= p59) or not (p59 - p58.LastHit >= 0.65) then
        return nil
    end

    p58.LastHit = p59

    if p59 < p58.CloseUntil then
        p58.PounceAt = p59

        return "Pounce"
    end

    p58.CloseUntil = p59 + 5

    return "Close"
end

local function impactChase(p60, p61) -- line: 714
    if p60.PounceAt == (-1e999) or p61 - p60.PounceAt < 0.7 then
        return false
    end

    p60.PounceAt = (-1e999)
    p60.CloseUntil = (-1e999)
    p60.ImpactAt = p61
    p60.RecoverUntil = p61 + 1.5

    return true
end

local function chaseSpeed(p62, p63) -- line: 725
    local v152 = p63 - p62.ImpactAt

    if v152 < 1.1 then
        return math.max(v152, 0) * 0.55 / 1.1 + 0.45
    end

    return 1
end

local function playMovementAnimation(p64, p65, p66) -- line: 730
    local Animator = p65.Humanoid:FindFirstChildOfClass("Animator")

    if Animator ~= nil and not (p65.Humanoid.Health <= 0) then
        local v153 = p64:Add(Instance.new("Animation"))

        v153.AnimationId = p66

        local track = Animator:LoadAnimation(v153)

        track.Priority = Enum.AnimationPriority.Action2
        track.Looped = true

        local v154 = false

        local function stop() -- line: 741
            -- upvalues: track (copy), v154 (ref)
            if v154 then
                return
            end

            v154 = true
            track:Stop(0)
            track:Destroy()
        end

        p64:Add(stop)
        p64:Connect(p65.Humanoid.Died, stop)
        track:Play(0.2)
    end
end

local function addRunDust(p67, p68) -- line: 754
    local v155 = p67:Add(Instance.new("Attachment"))

    v155.Name = "BeanstalkRunDust"
    v155.Position = Vector3.new(0, -2.7, 0)
    v155.Parent = p68.Root

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Dust"
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(193, 210, 134))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.2, 0.4)
    ParticleEmitter.Speed = NumberRange.new(1, 3)
    ParticleEmitter.SpreadAngle = Vector2.new(25, 25)
    ParticleEmitter.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter.Rate = 14
    ParticleEmitter.Parent = v155

    return ParticleEmitter
end

return {
    Run = function(p69, p70, p71, _) -- Run | line: 778
        -- upvalues: Lighting (copy), RunService (copy), SoundService (copy), Workspace (copy), Audio (copy), BeanstalkEvent (copy), BeanstalkEventFlags (copy), Music (copy), RailRide (copy), SpeedLines (copy), Remotes (copy), TutorialBeam (copy), UISystem (copy), WhaleHearts (copy), LocalPlayer (copy), Egg (copy), CosmicLion (copy), BeanstalkEvent2 (copy), Roar (copy), Step (copy), Swoosh (copy), Stage (copy), waitUntilOver (copy), buildSlide (copy), placeObstacles (copy), punchCamera (copy), dropLion (copy), playLionRun (copy), carryEgg (copy), nearestDistance (copy), playMovementAnimation (copy), addRunDust (copy)
        local n11 = 2
        local Stage4 = p70.Sections.Stage4

        UISystem.SetTask("STEAL THE GIANT EGG")
        waitUntilOver(p71.Root, Stage4.Floor)

        local v156 = p69:Add(Instance.new("Folder"))

        v156.Name = "BeanstalkEggEscape"
        v156.Parent = Workspace

        local clone = p69:Clone(Egg)
        local _CFrame = Stage4.EggSpot.CFrame
        local BoundingBox, BoundingBox2 = Egg:GetBoundingBox()

        clone:PivotTo(_CFrame * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(Egg:GetPivot()))
        clone.Parent = v156

        local v157 = buildSlide(p69, v156, p70)

        while true do
            local Root = p71.Root
            local EggSpotPosition = Stage4.EggSpot.Position
            local v158 = Root.Position - EggSpotPosition

            if Vector3.new(v158.X, 0, v158.Z).Magnitude <= 26 and math.abs(v158.Y) <= 15 then
                break
            end

            RunService.Heartbeat:Wait()
        end

        p69:Add(task.spawn(function() -- line: 798
            -- upvalues: BeanstalkEvent (copy), Remotes (copy), LocalPlayer (copy)
            while true do
                local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

                if typeof(Attribute) == "number" and Attribute >= 1 then
                    break
                end

                Remotes.BeanstalkEvent.AskStealEgg:FireServer()
                task.wait(1)
            end
        end))
        Music.Play("Stage4TrackB")
        carryEgg(p69, p71, clone)
        punchCamera(p69)
        RailRide.Shake(6)

        local v159 = p69:Extend()

        UISystem.SetPrompt("Escape down the slide!")

        local v160 = TutorialBeam.Attach(Stage4.SlideEntrance)

        v159:Add(function() -- line: 813
            -- upvalues: v160 (copy), TutorialBeam (copy), UISystem (copy)
            TutorialBeam.Destroy(v160)
            UISystem.SetPrompt(nil)
        end)

        local clone2 = p69:Clone(CosmicLion)

        clone2:ScaleTo(clone2:GetScale() * 0.33)

        local GriffinSpotPosition = Stage4.GriffinSpot.Position
        local v161 = Vector3.new(p71.Root.Position.X, GriffinSpotPosition.Y, p71.Root.Position.Z)
        local v162 = CFrame.lookAt(GriffinSpotPosition, v161)
        local BoundingBox3, BoundingBox4 = clone2:GetBoundingBox()
        local v163 = v162 * (BoundingBox3 * CFrame.new(0, -BoundingBox4.Y * 0.5, 0)):ToObjectSpace(clone2:GetPivot())

        clone2:PivotTo(v163 + Vector3.new(0, 250, 0))
        clone2.Parent = v156
        dropLion(clone2, v163)

        local Floor = Stage4.Floor
        local v164 = Floor.Position.Y + Floor.Size.Y * 0.5

        while true do
            local Root = p71.Root
            local SlideEntrancePosition = Stage4.SlideEntrance.Position
            local v165 = Root.Position - SlideEntrancePosition

            if not (Vector3.new(v165.X, 0, v165.Z).Magnitude <= 8 and math.abs(v165.Y) <= 10) and p71.Root.Position.Y > v164 - 10 then
                RunService.Heartbeat:Wait()
                continue
            end

            break
        end

        v159:Clean()

        while true do
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) == "number" and Attribute >= 1 then
                break
            end

            RunService.Heartbeat:Wait()
        end

        local v167 = if p71.Root.Position.Y > v164 - 10 then 0 else nearestDistance(v157, p71.Root.Position)
        local v168 = p69:Extend()
        local n12 = 0

        SpeedLines.Run(v168, function() -- line: 843
            -- upvalues: p71 (copy), n11 (ref), n12 (ref), LocalPlayer (copy)
            if not (n11 <= 0) and not (p71.Humanoid.Health <= 0) and LocalPlayer.Character == p71.Character then
                return n12
            end

            return 0
        end)
        WhaleHearts.Show(v168, n11, UISystem.ShowSlideHearts(v168))

        local v169 = Audio.Play(BeanstalkEvent2.SlideLoop, SoundService, {
            Looped = true
        })

        if v169 then
            v168:Add(v169)
        end

        playMovementAnimation(v168, p71, "rbxassetid://98935124024246")

        local v170 = addRunDust(v168, p71)
        local Unit
        local elapsed = os.clock()
        local elapsed2 = elapsed
        local _CFrame2 = Workspace.CurrentCamera.CFrame
        local v171 = placeObstacles(p69, v156, v157)
        local t21 = {
            CloseUntil = (-1e999),
            PounceAt = (-1e999),
            ImpactAt = (-1e999),
            RecoverUntil = (-1e999),
            LastHit = (-1e999)
        }
        local v172 = v167 + 150
        local v173
        local Pivot = clone2:GetPivot()
        local n13 = (-1e999)
        local v174 = clone2:GetPivot()
        local n14 = 28
        local elapsed3 = os.clock()
        local n15 = (-1e999)
        local n16 = 0

        local function cue(p73, p74, p75) -- line: 872
            -- upvalues: clone2 (copy), v168 (copy), Audio (copy)
            local v175 = Audio.Play(p73, clone2, {
                MaxDistance = 200,
                SoundGroup = "SFX",
                Volume = p74,
                PlaybackSpeed = p75 or 1
            })

            if v175 then
                v168:Add(v175)
            end
        end

        local function stepLion(p76, p77, p78) -- line: 879
            -- upvalues: n11 (ref), v157 (copy), clone2 (copy), v168 (copy), n12 (ref), v169 (copy), v170 (copy), t21 (copy), v172 (copy), v173 (ref), Pivot (copy), n13 (ref), v174 (ref), n14 (ref), elapsed3 (ref), n15 (ref), n16 (ref), Audio (copy), RailRide (copy), BeanstalkEvent2 (copy), Step (copy), playLionRun (copy)
            n12 = p78

            local elapsed = os.clock()
            local v176 = elapsed - elapsed3

            elapsed3 = elapsed

            if t21.PounceAt ~= (-1e999) and not (elapsed - t21.PounceAt < 0.7) then
                t21.PounceAt = (-1e999)
                t21.CloseUntil = (-1e999)
                t21.ImpactAt = elapsed
                t21.RecoverUntil = elapsed + 1.5

                local SlideHit = BeanstalkEvent2.SlideHit
                local v177 = Audio.Play(SlideHit, clone2, {
                    Volume = 0.7,
                    PlaybackSpeed = 0.85,
                    MaxDistance = 200,
                    SoundGroup = "SFX"
                })

                if v177 then
                    v168:Add(v177)
                end

                RailRide.Shake(5)
                v170:Emit(12)
            end

            local v178 = elapsed < t21.CloseUntil
            local v179 = if v178 then 1 else 0

            v170.Rate = p78 * 14 + v179 * 8

            if v169 then
                v169.PlaybackSpeed = BeanstalkEvent2.SlideLoop.PlaybackSpeed * (p78 * 0.15 + 0.85 + v179 * 0.08)
                v169.Volume = BeanstalkEvent2.SlideLoop.Volume * (p78 * 0.25 + 0.75 + v179 * 0.15)
            end

            if p76 < v172 then
                return
            end

            if v173 == nil then
                v173 = playLionRun(v168, clone2)
                n13 = elapsed
            end

            local v180 = v173

            v180:AdjustSpeed((math.clamp(p78 + v179 * 0.35, 0.7, 1.5)))

            local v182 = if v178 then 18 else 28
            local v183 = n14

            n14 = v183 + (v182 - n14) * math.min(v176 * 5, 1)

            local v187 = v157.Path((math.max(p76 - n14, 0)))
            local v188 = v157.Path(p76)
            local v189 = v188.RightVector:Dot(p77.Position - v188.Position)

            n16 = -8 * v189 / 10

            local v190 = v187 * CFrame.new(v189 * 0.5, -4.98, 0)
            local BoundingBox, BoundingBox2 = clone2:GetBoundingBox()
            local v191 = v190 * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(clone2:GetPivot())

            if n11 <= 0 and elapsed - t21.LastHit >= 0.7 then
                local v192 = p77 * CFrame.new(0, -4.98, 0)
                local BoundingBox, BoundingBox2 = clone2:GetBoundingBox()

                v191 = v192 * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(clone2:GetPivot())
            elseif t21.PounceAt == (-1e999) then
                if elapsed - n13 < 0.6 then
                    local v193 = (elapsed - n13) / 0.6

                    v191 = Pivot:Lerp(v191, v193) + Vector3.new(0, 1, 0) * (56 * v193 * (1 - v193))
                end
            else
                local v194 = elapsed - t21.PounceAt

                if v194 < 0.12 then
                    local v195 = v174

                    v191 = v195 - Vector3.new(0, 1, 0) * (2 * v194 / 0.12)
                else
                    local v197 = math.clamp((v194 - 0.12) / 0.58, 0, 1)
                    local v198 = p77 * CFrame.new(0, -4.98, 0)
                    local BoundingBox, BoundingBox2 = clone2:GetBoundingBox()
                    local v199 = v198 * (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(clone2:GetPivot())

                    v191 = v174:Lerp(v199, v197) + Vector3.new(0, 1, 0) * (v197 * 24 * (1 - v197))
                    n14 = 12
                end
            end

            clone2:PivotTo(v191)

            if not (elapsed - n15 >= (if v178 then 0.24 else 0.38)) or t21.PounceAt ~= (-1e999) then
                return
            end

            n15 = elapsed

            local v201 = if v178 then 0.55 else 0.22
            local v200 = if v178 then 1.1 else 0.95
            local v202 = Audio.Play(Step, clone2, {
                MaxDistance = 200,
                SoundGroup = "SFX",
                Volume = v201,
                PlaybackSpeed = v200 or 1
            })

            if v202 then
                v168:Add(v202)
            end
        end

        local elapsed4 = os.clock()

        RailRide.Run(v168, {
            Lateral = 10,
            BumpSpeedScale = 0.55,
            HitCooldownSeconds = 0.65,
            FieldOfView = 72,
            FieldOfViewPerSpeed = 8,
            Rig = p71,
            Path = v157.Path,
            Length = v157.Length,
            StartDistance = v167,
            Seconds = v157.Length / 100,
            Lift = function(p79) -- Lift | line: 942
                return (p79 / 10) ^ 2 * 3
            end,
            BumpSeconds = BeanstalkEventFlags.BumpSlowdownSeconds:Get(),
            CanHit = function() -- CanHit | line: 948
                -- upvalues: t21 (copy)
                local elapsed = os.clock()

                if t21.PounceAt == (-1e999) and t21.RecoverUntil <= elapsed then
                    return elapsed - t21.LastHit >= 0.65
                end

                return false
            end,
            SpeedScale = function() -- SpeedScale | line: 951
                -- upvalues: n11 (ref), t21 (copy), elapsed4 (copy)
                if n11 <= 0 then
                    return 0
                end

                local elapsed = os.clock()
                local v204 = math.clamp((elapsed - elapsed4) / 5, 0, 1)
                local v205 = (v204 * v204 * (3 - v204 * 2) * 31.25 + 43.75) / 100
                local v206 = elapsed - t21.ImpactAt

                return v205 * (if v206 < 1.1 then math.max(v206, 0) * 0.55 / 1.1 + 0.45 else 1)
            end,
            Obstacles = v171,
            SteerLocked = function(p80) -- SteerLocked | line: 962
                -- upvalues: v157 (copy)
                return p80 * v157.Length < v157.EntryLength
            end,
            Mount = function(p81) -- Mount | line: 965
                -- upvalues: t21 (copy), n16 (ref)
                local v208 = math.clamp(1 - (os.clock() - t21.ImpactAt) / 1.1, 0, 1)
                local v210 = math.clamp(1 - (os.clock() - t21.LastHit) / 0.35, 0, 1)

                return p81 * CFrame.Angles(math.rad(-8 - v208 * 18 - v210 * 10), 0, (math.rad(n16)))
            end,
            Camera = function(p82, p83) -- Camera | line: 971
                -- upvalues: Unit (ref), elapsed (copy), elapsed2 (ref), _CFrame2 (copy), t21 (copy)
                local elapsed3 = os.clock()
                local v215 = math.max(elapsed3 - elapsed2, 0)
                local LookVector = p82.LookVector
                local Unit2 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
                local Unit3 = Unit

                if Unit3 then
                    Unit2 = Unit3:Lerp(Unit2, 1 - math.exp(-v215 * 9)).Unit
                end

                Unit = Unit2
                elapsed2 = elapsed3

                local v217 = p82.Position:Lerp(p83.Position, 0.35) + Vector3.new(0, 2, 0)
                local v218 = v217 - Unit2 * 44 + Vector3.new(0, 46, 0)
                local v219 = if elapsed3 < t21.CloseUntil then Vector3.new(math.sin(elapsed3 * 27) * 0.06, math.sin(elapsed3 * 33) * 0.04, 0) else Vector3.new(0, 0, 0)
                local v224 = CFrame.lookAt(v218, v217 + Unit2 * 6) * CFrame.new(v219)
                local v226 = math.clamp((elapsed3 - elapsed) / 0.6, 0, 1)

                return (_CFrame2:Lerp(v224, v226 * v226 * (3 - v226 * 2)))
            end,
            OnHit = function() -- OnHit | line: 988
                -- upvalues: p71 (copy), n11 (ref), clone2 (copy), v168 (copy), t21 (copy), v174 (ref), Audio (copy), Remotes (copy), WhaleHearts (copy), BeanstalkEvent2 (copy), Roar (copy), Swoosh (copy)
                local elapsed = os.clock()
                local v227

                if t21.PounceAt ~= (-1e999) or not (t21.RecoverUntil <= elapsed) or not (elapsed - t21.LastHit >= 0.65) or n11 <= 0 then
                    return
                else
                    n11 -= 1
                    t21.LastHit = elapsed

                    if n11 == 0 then
                        t21.PounceAt = elapsed
                        v227 = "Pounce"
                        t21.CloseUntil = elapsed + 0.7
                    else
                        v227 = "Close"
                        t21.CloseUntil = elapsed + 5
                    end
                end

                WhaleHearts.Lose(n11)
                Remotes.BeanstalkEvent.AskSlideCrash:FireServer(p71.Character)

                if v227 == "Pounce" then
                    v174 = clone2:GetPivot()

                    local v229 = Audio.Play(Roar, clone2, {
                        Volume = 0.65,
                        PlaybackSpeed = 1.1,
                        MaxDistance = 200,
                        SoundGroup = "SFX"
                    })

                    if v229 then
                        v168:Add(v229)
                    end

                    local v230 = Audio.Play(Swoosh, clone2, {
                        Volume = 0.5,
                        PlaybackSpeed = 1,
                        MaxDistance = 200,
                        SoundGroup = "SFX"
                    })

                    if v230 then
                        v168:Add(v230)
                    end
                elseif v227 == "Close" then
                    local SlideHit = BeanstalkEvent2.SlideHit
                    local v231 = Audio.Play(SlideHit, clone2, {
                        Volume = 0.5,
                        PlaybackSpeed = 1,
                        MaxDistance = 200,
                        SoundGroup = "SFX"
                    })

                    if v231 then
                        v168:Add(v231)
                    end

                    local v232 = Audio.Play(Roar, clone2, {
                        Volume = 0.5,
                        PlaybackSpeed = 0.9,
                        MaxDistance = 200,
                        SoundGroup = "SFX"
                    })

                    if v232 then
                        v168:Add(v232)
                    end
                end
            end,
            OnStep = stepLion
        })
        v168:Clean()

        if n11 <= 0 or p71.Humanoid.Health <= 0 or LocalPlayer.Character ~= p71.Character then
            return
        end

        playMovementAnimation(p69, p71, "rbxassetid://88564428092864")

        local CurrentCamera = Workspace.CurrentCamera
        local FieldOfView = CurrentCamera.FieldOfView

        p69:Add(function() -- line: 1023
            -- upvalues: CurrentCamera (copy), FieldOfView (copy)
            CurrentCamera.FieldOfView = FieldOfView
        end)

        local v233 = p69:Add(Instance.new("ColorCorrectionEffect"))

        v233.Parent = Lighting

        local Y2 = p71.Root.Position.Y
        local Floor2 = p70.Sections.Stage1.Floor
        local v234 = (Y2 + (Floor2.Position.Y + Floor2.Size.Y * 0.5)) * 0.5
        local v236 = math.sqrt(1600 + 120 * (Y2 - v234))
        local n17 = 40
        local v237 = p69:Extend()

        v237:Connect(RunService.Heartbeat, function(p84) -- line: 1033
            -- upvalues: p71 (copy), CurrentCamera (copy), FieldOfView (copy), v233 (copy), v236 (copy), n17 (ref)
            n17 += p84 * 60
            p71.Root.AssemblyLinearVelocity = Vector3.new(0, -n17, 0)

            local v241 = math.clamp((n17 - 40) / (v236 - 40), 0, 1)

            CurrentCamera.FieldOfView = FieldOfView + v241 * 30
            v233.Brightness = v241 * 0.3
        end)

        local elapsed5 = os.clock()

        while v234 < p71.Root.Position.Y and os.clock() - elapsed5 < 5 do
            RunService.Heartbeat:Wait()
        end

        v237:Clean()
        p69:Connect(RunService.Heartbeat, function() -- line: 1048
            -- upvalues: p71 (copy)
            p71.Root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)

        while true do
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            if Attribute == Stage.EggEscape then
                Remotes.BeanstalkEvent.AskFinishEscape:FireServer()
                task.wait(0.5)
                continue
            end

            break
        end
    end
}

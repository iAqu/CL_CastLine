-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local TrexRunHerd = require(ReplicatedStorage.Shared.Modules.TrexRunHerd)
local v1 = Color3.fromRGB(255, 72, 40)
local v2 = CFrame.new(0, -5000, 0)
local t1 = {
    "Particles",
    "ScrambleBossVFX",
    "MechBoss",
    "Slam"
}
local t2 = {}

local function byDistance(p1, p2) -- line: 97
    return p1.Distance < p2.Distance
end

local function prepare(p3) -- line: 105
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy()
        end
    end
end

local function loadTrack(p4, p5) -- line: 118
    local v3 = p4:FindFirstChildWhichIsA("Animator", true)

    if v3 == nil or p5 == nil or not p5:IsA("Animation") then
        return nil
    end

    local function v4() -- line: 125
        -- upvalues: p5 (copy), v3 (copy)
        return v3:LoadAnimation(p5)
    end

    local ok, result = pcall(v4)

    if not ok or result == nil then
        return nil
    end

    result.Looped = true

    return result
end

local function newWarning(p6) -- line: 138
    -- upvalues: v1 (copy)
    local Part = Instance.new("Part")

    Part.Name = "Warning"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Transparency = 1
    Part.Size = Vector3.new(p6.Course.LaneWidth * 0.7, 0.2, 70)
    Part.Parent = p6.Folder

    return Part
end

local function newSlot(p7) -- line: 156
    -- upvalues: v1 (copy), prepare (copy), loadTrack (copy)
    local clone = p7.Template:Clone()

    prepare(clone)
    clone.Parent = p7.Folder

    local PrimaryPart = clone.PrimaryPart
    local v6 = loadTrack(clone, p7.Visuals:FindFirstChild("Run"))
    local Steps = p7.Visuals:FindFirstChild("Steps")

    if v6 ~= nil then
        v6:Play(0)
        v6.TimePosition = math.random() * math.max(v6.Length, 0.1)
    end

    local clone2, v8, clone3

    if Steps ~= nil and Steps:IsA("Sound") then
        clone2 = Steps:Clone()
        clone3 = clone2
        clone2.Looped = true
        v8 = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)
        clone2.Parent = v8
    end

    local t3 = {
        RunSpeed = 1,
        WarningShown = false,
        StepsPlaying = false,
        Key = 0,
        Model = clone
    }

    t3.Root = if PrimaryPart == nil or not PrimaryPart.Anchored then nil else PrimaryPart
    t3.Run = v6

    local Part = Instance.new("Part")

    Part.Name = "Warning"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Transparency = 1
    Part.Size = Vector3.new(p7.Course.LaneWidth * 0.7, 0.2, 70)
    Part.Parent = p7.Folder
    t3.Warning = Part
    t3.Steps = clone3
    t3.Y = p7.Course.FloorY

    return t3
end

local function acquire(p8, p9) -- line: 194
    -- upvalues: newSlot (copy)
    local v10 = table.remove(p8.Free) or newSlot(p8)

    v10.Key = p9
    v10.Y = p8.Course.FloorY
    p8.Slots[p9] = v10

    return v10
end

local function release(p10, p11) -- line: 204
    -- upvalues: v2 (copy)
    p10.Slots[p11.Key] = nil
    p11.Key = 0

    if p11.Root ~= nil then
        p11.Root.CFrame = v2
    else
        p11.Model:PivotTo(v2)
    end

    p11.Warning.Transparency = 1
    p11.WarningShown = false

    if p11.Steps ~= nil and p11.StepsPlaying then
        p11.Steps.Playing = false
        p11.StepsPlaying = false
    end

    table.insert(p10.Free, p11)
end

local function ground(p12, p13, p14) -- line: 225
    -- upvalues: Workspace (copy), TrexRunHerd (copy)
    local v12 = math.floor(p13 / 4 + 0.5)
    local v14 = math.floor(p14 / 4 + 0.5)
    local v15 = v12 * 1024 + v14 + 512
    local v16 = p12.Ground[v15]

    if v16 == nil then
        local Course = p12.Course
        local v18 = Workspace:Raycast(TrexRunHerd.Point(Course, v12 * 4, v14 * 4) + Vector3.new(0, 60, 0), Vector3.new(0, -160, 0), p12.Raycast)

        v16 = v18 ~= nil and v18.Position.Y
        p12.Ground[v15] = v16
    end

    return if v16 ~= false then v16 else nil
end

local function facing(p15, p16, p17) -- line: 247
    -- upvalues: TrexRunHerd (copy)
    local v20 = TrexRunHerd.Forward(p15.Course) * p16.Direction
    local v21 = TrexRunHerd.TurnAlpha(p16, p17)
    local v22 = if p16.Id % 2 == 0 then 1 else -1

    return CFrame.lookAt(Vector3.new(0, 0, 0), v20) * CFrame.Angles(0, 3.141592653589793 * (1 - v21) * v22, 0)
end

local function move(p18, p19, p20) -- line: 255
    local Root = p19.Root

    if Root ~= nil then
        table.insert(p18.MoveParts, Root)
        table.insert(p18.MoveFrames, p20 * p18.RootOffset)
    else
        p19.Model:PivotTo(p20)
    end
end

local function place(p21, p22, p23, p24) -- line: 267
    -- upvalues: ground (copy)
    local Wave, Position = p23.Wave, p23.Position
    local v24 = ground(p21, p23.Depth, p23.Lateral)
    local v26 = math.min(1, p24 * 12)
    local Moving, Rotation = p23.Moving, p23.Rotation

    p22.Y += ((v24 or p22.Y) - p22.Y) * v26

    local v28 = Vector3.new(Position.X, p22.Y + p21.Size.Y * 0.5, Position.Z)
    local v29 = CFrame.new(v28) * Rotation
    local Root = p22.Root

    if Root ~= nil then
        table.insert(p21.MoveParts, Root)
        table.insert(p21.MoveFrames, v29 * p21.RootOffset)
    else
        p22.Model:PivotTo(v29)
    end

    local Run = p22.Run

    if Run ~= nil then
        local n1 = 0

        if Moving then
            n1 = math.clamp(Wave.Speed / 32, 1, 2.4)
        elseif p23.Turning then
            n1 = 1
        end

        if math.abs(n1 - p22.RunSpeed) > 0.02 then
            p22.RunSpeed = n1
            Run:AdjustSpeed(n1)
        end
    end

    local Steps = p22.Steps

    if Steps ~= nil then
        local v33 = Moving and p23.Distance <= p21.StepsRange

        if v33 ~= p22.StepsPlaying then
            p22.StepsPlaying = v33
            Steps.Playing = v33
        end
    end

    if Moving then
        local LookVector = Rotation.LookVector
        local v35 = (math.sin(p21.Clock * 9 + Wave.Id) + 1) * 0.5
        local v37 = Vector3.new(Position.X, p22.Y + 0.35, Position.Z) + LookVector * (p21.Size.Z * 0.5 + 35)

        table.insert(p21.MoveParts, p22.Warning)
        table.insert(p21.MoveFrames, CFrame.lookAt(v37, v37 + LookVector))
        p22.WarningShown = true
        p22.Warning.Transparency = v35 * 0.45 + 0.25
    elseif p22.WarningShown then
        p22.WarningShown = false
        p22.Warning.Transparency = 1
    end
end

local function inPath(p25, p26, p27, p28) -- line: 326
    -- upvalues: TrexRunHerd (copy)
    for v39 in p26.Lanes do
        if math.abs(p27 - TrexRunHerd.TrexLateral(p25, p26, v39)) <= p28 then
            return true
        end
    end

    return false
end

local function updateAlpha(p29, p30) -- line: 341
    local v41 = os.clock() - p29.RoarStartedAt
    local v42 = 0

    if v41 < 1.3 then
        v42 = math.sin(v41 / 1.3 * 3.141592653589793) * p29.RoarStrength
    elseif not p30 and not p29.Lifted then
        return
    end

    p29.Lifted = v42 ~= 0
    p29.Model:PivotTo(p29.Base * CFrame.Angles(v42 * 0.24434609527920614, 0, 0))
end

function t2.new(p31, p32) -- line: 361
    -- upvalues: Workspace (copy)
    local Trex = p32:FindFirstChild("Trex")

    if Trex ~= nil and Trex:IsA("Model") then
        local Hitbox = Trex:FindFirstChild("Hitbox")
        local ExtentsSize = if Hitbox == nil then Trex:GetExtentsSize() elseif Hitbox:IsA("BasePart") then Hitbox.Size else Trex:GetExtentsSize()
        local PrimaryPart = Trex.PrimaryPart
        local Steps = p32:FindFirstChild("Steps")
        local Folder = Instance.new("Folder")
        local v44 = RaycastParams.new()
        local t4 = {
            Workspace.Terrain
        }
        local World = Workspace:FindFirstChild("World")
        local Build = if World == nil then nil else World:FindFirstChild("Build")

        if Build ~= nil then
            table.insert(t4, Build)
        end

        v44.FilterType = Enum.RaycastFilterType.Include
        v44.FilterDescendantsInstances = t4
        v44.RespectCanCollide = true
        Folder.Name = "TrexRunHerd"
        Folder.Parent = Workspace

        return {
            Alpha = nil,
            Clock = 0,
            Course = p31,
            Visuals = p32,
            Template = Trex,
            Size = ExtentsSize,
            Folder = Folder,
            Waves = {},
            Slots = {},
            Free = {},
            Exited = {},
            Raycast = v44,
            RootOffset = if PrimaryPart == nil then CFrame.identity else PrimaryPart.PivotOffset:Inverse(),
            StepsRange = if Steps == nil or not Steps:IsA("Sound") then 650 else Steps.RollOffMaxDistance,
            KeyStride = p31.Lanes + 1,
            Ground = {},
            Records = {},
            Candidates = {},
            Wanted = {},
            MoveParts = {},
            MoveFrames = {}
        }
    end

    warn("[TrexRun] Assets.TrexRunVisuals.Trex is missing")

    return nil
end

function t2.Set(p33, p34) -- line: 418
    table.clear(p33.Waves)

    for _, v45 in p34 do
        if type(v45) == "table" and type(v45.Id) == "number" then
            p33.Waves[v45.Id] = v45
        end
    end
end

function t2.Add(p35, p36) -- line: 428
    local v46 = type(p36) == "table"
    local v47 = if v46 then type(p36.Id) == "number" else nil

    if v46 and v47 then
        p35.Waves[p36.Id] = p36
    end
end

function t2.Dust(p37, p38) -- line: 436
    -- upvalues: Fx (copy), t1 (copy)
    local v48 = Fx.Resolve(t1)

    if v48 == nil then
        return
    end

    local clone = v48:Clone()

    if clone:IsA("BasePart") then
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
        clone.Transparency = 1
        clone.CFrame = CFrame.new(p37)
    end

    Fx.Scale(clone, p38)
    clone.Parent = Fx.Folder()
    Fx.Burst(clone, 0.6)
    task.delay(4, function() -- line: 457
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

function t2.RowDust(p39, p40, p41, p42) -- line: 462
    -- upvalues: Fx (copy), TrexRunHerd (copy), t2 (copy)
    local Course = p39.Course
    local v49 = TrexRunHerd.Point(Course, p41, 0)

    if not ((v49 - p42).Magnitude > 975) then
        for v50 in p40.Lanes do
            t2.Dust(TrexRunHerd.Point(Course, p41, TrexRunHerd.TrexLateral(Course, p40, v50)), 1.4)
        end

        Fx.Sound({ "Sounds", "ScrambleBoss", "Stomp" }, v49, 0.9, 0.7, 500)
    end
end

function t2.Update(p43, p44, p45, p46) -- line: 480
    -- upvalues: Workspace (copy), TrexRunHerd (copy), t2 (copy), byDistance (copy), newSlot (copy), release (copy), facing (copy), place (copy), updateAlpha (copy)
    local Course = p43.Course
    local v51 = TrexRunHerd.Locate(Course, p46)
    local KeyStride, Records, Candidates, Wanted = p43.KeyStride, p43.Records, p43.Candidates, p43.Wanted

    p43.Clock += p44
    table.clear(Candidates)
    table.clear(Wanted)
    table.clear(p43.MoveParts)
    table.clear(p43.MoveFrames)

    local n2 = 0

    for v52, v53 in p43.Waves do
        if TrexRunHerd.IsExpired(v53, Course, p45) then
            if not p43.Exited[v52] then
                p43.Exited[v52] = true

                if v53.Direction < 0 then
                    t2.RowDust(p43, v53, Course.Near, p46)
                end
            end

            p43.Waves[v52] = nil
        else
            local v54 = TrexRunHerd.DepthAt(v53, p45)

            if not (math.abs(v54 - v51) > 650) then
                local v56 = TrexRunHerd.IsMoving(v53, p45)
                local v57 = n2
                local v58

                for v59, v60 in v53.Lanes do
                    local v61 = TrexRunHerd.TrexLateral(Course, v53, v59)
                    local v62 = TrexRunHerd.Point(Course, v54, v61)
                    local Magnitude = (v62 - p46).Magnitude

                    if not (Magnitude > 650) then
                        if v58 == nil then
                            v58 = facing(p43, v53, p45)
                        end

                        v57 += 1

                        local v63 = Records[v57]

                        if v63 == nil then
                            v63 = {
                                Key = 0,
                                Moving = false,
                                Turning = false,
                                Wave = v53,
                                Position = v62,
                                Depth = v54,
                                Lateral = v61,
                                Distance = Magnitude,
                                Rotation = CFrame.identity
                            }
                            Records[v57] = v63
                        end

                        v63.Key = v52 * KeyStride + v60
                        v63.Wave = v53
                        v63.Position = v62
                        v63.Depth = v54
                        v63.Lateral = v61
                        v63.Distance = Magnitude
                        v63.Rotation = v58
                        v63.Moving = v56

                        if v53.TurnFrom ~= nil then
                            v63.Turning = not v56
                        else
                            v63.Turning = false
                        end

                        Candidates[v57] = v63
                    end

                    n2 = v57
                end
            end
        end
    end

    if n2 > 28 then
        table.sort(Candidates, byDistance)

        for i = n2, 29, -1 do
            Candidates[i] = nil
        end
    end

    for _, v64 in Candidates do
        Wanted[v64.Key] = v64
    end

    for v65, v66 in p43.Slots do
        if Wanted[v65] == nil then
            release(p43, v66)
        end
    end

    for v67, v68 in Wanted do
        local v69 = p43.Slots[v67]

        if not v69 then
            v69 = table.remove(p43.Free) or newSlot(p43)
            v69.Key = v67
            v69.Y = p43.Course.FloorY
            p43.Slots[v67] = v69
        end

        place(p43, v69, v68, p44)
    end

    if #p43.MoveParts > 0 then
        Workspace:BulkMoveTo(p43.MoveParts, p43.MoveFrames, Enum.BulkMoveMode.FireCFrameChanged)
    end

    local Alpha = p43.Alpha

    if Alpha ~= nil then
        updateAlpha(Alpha)
    end
end

function t2.Danger(p47, p48, p49, p50) -- line: 598
    -- upvalues: TrexRunHerd (copy), inPath (copy)
    local Course = p47.Course
    local v70, v71 = TrexRunHerd.Locate(Course, p49)
    local v72 = Course.LaneWidth * 0.5
    local n3 = 0

    for _, v73 in p47.Waves do
        if TrexRunHerd.IsMoving(v73, p48) and inPath(Course, v73, v71, v72) then
            local v74 = (v70 - TrexRunHerd.DepthAt(v73, p48)) * v73.Direction

            if v74 > 0 and v74 < p50 then
                n3 = math.max(n3, 1 - v74 / p50)
            end
        end
    end

    return n3
end

function t2.MountAlpha(p51, p52) -- line: 619
    -- upvalues: prepare (copy), loadTrack (copy), updateAlpha (copy)
    local clone = p51.Template:Clone()

    prepare(clone)
    clone:ScaleTo(clone:GetScale() * 2)
    clone.Name = "Alpha"
    clone.Parent = p51.Folder

    local v76 = p51.Size * 2
    local v77 = p52 * CFrame.new(0, v76.Y * 0.5, 0)
    local v78 = loadTrack(clone, p51.Visuals:FindFirstChild("Idle"))

    if v78 ~= nil then
        v78:Play(0)
    end

    clone:PivotTo(v77)

    local t6 = {
        RoarStartedAt = (-1e999),
        RoarStrength = 1,
        Lifted = false,
        Model = clone,
        Base = v77,
        Idle = v78
    }

    p51.Alpha = t6
    updateAlpha(t6, true)

    return t6
end

function t2.Roar(p53, p54) -- line: 652
    -- upvalues: Fx (copy), t2 (copy)
    local Alpha = p53.Alpha

    if Alpha == nil then
        return
    end

    Alpha.RoarStartedAt = os.clock()
    Alpha.RoarStrength = p54

    local v79 = Alpha.Base * CFrame.new(0, p53.Size.Y, -p53.Size.Z * 2 * 0.4)
    local Roar = p53.Visuals:FindFirstChild("Roar")

    if Roar ~= nil and Roar:IsA("Sound") then
        local clone = Roar:Clone()

        clone.RollOffMaxDistance = 6000
        clone.Volume *= p54 + 1
        clone.PlaybackSpeed = 0.75
        clone.Parent = Fx.Holder(v79.Position, "AlphaRoar")
        clone:Play()
        task.delay(6, function() -- line: 673
            -- upvalues: clone (copy)
            if clone.Parent ~= nil then
                clone.Parent:Destroy()
            end
        end)
    end

    Fx.Sound({ "Sounds", "MonsterParasite", "Roar" }, v79.Position, p54 * 0.4 + 0.6, 0.6, 6000)
    t2.Dust(Alpha.Base.Position, p54 * 3)
end

function t2.AlphaHead(p55) -- line: 690
    local Alpha = p55.Alpha

    return if Alpha ~= nil then (Alpha.Base * CFrame.new(0, p55.Size.Y * 0.9, -p55.Size.Z * 2 * 0.38)).Position else nil
end

function t2.Destroy(p56) -- line: 700
    p56.Folder:Destroy()
    table.clear(p56.Waves)
    table.clear(p56.Slots)
    table.clear(p56.Free)
    table.clear(p56.Ground)
    table.clear(p56.Records)
    table.clear(p56.Candidates)
    table.clear(p56.Wanted)
    table.clear(p56.MoveParts)
    table.clear(p56.MoveFrames)
    p56.Alpha = nil
end

return table.freeze(t2)

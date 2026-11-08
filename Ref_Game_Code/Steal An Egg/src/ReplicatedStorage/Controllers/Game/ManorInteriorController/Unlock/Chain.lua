-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Sfx = require(script.Parent.Sfx)

require(ReplicatedStorage.Packages.Trove)

local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v3 = nil
local t1 = {}

local function template() -- line: 104
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local ManorInterior = Assets and Assets:FindFirstChild("ManorInterior")
    local ChainLinks = ManorInterior and ManorInterior:FindFirstChild("ChainLinks")

    return if ChainLinks ~= nil and ChainLinks:IsA("Model") then ChainLinks else nil
end

local function lockParts(p1) -- line: 111
    local t2 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t2, descendant)
        end
    end

    return t2
end

local function quietClone(p2, p3) -- line: 121
    local Archivable = p2.Archivable

    p2.Archivable = true

    local clone = p2:Clone()

    p2.Archivable = Archivable

    for _, child in clone:GetChildren() do
        if not child:IsA("SurfaceAppearance") and not child:IsA("Decal") then
            child:Destroy()
        end
    end

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.Transparency = 0
    clone.Parent = p3

    return clone
end

local function emitters(p4, p5) -- line: 140
    local Part = Instance.new("Part")

    Part.Name = "Sparks"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p5)
    Part.Parent = p4

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Spark"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 236, 170), Color3.fromRGB(255, 120, 40))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.25, 0.5)
    ParticleEmitter.Speed = NumberRange.new(14, 26)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 4
    ParticleEmitter.Acceleration = Vector3.new(0, -30, 0)
    ParticleEmitter.Parent = Attachment

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "Dust"
    ParticleEmitter2.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.LightInfluence = 0.6
    ParticleEmitter2.Color = ColorSequence.new(Color3.fromRGB(150, 135, 150), Color3.fromRGB(95, 85, 100))
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 6)
    })
    ParticleEmitter2.Lifetime = NumberRange.new(0.6, 1.1)
    ParticleEmitter2.Speed = NumberRange.new(6, 12)
    ParticleEmitter2.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter2.Drag = 3
    ParticleEmitter2.Rotation = NumberRange.new(0, 360)
    ParticleEmitter2.RotSpeed = NumberRange.new(-60, 60)
    ParticleEmitter2.Parent = Attachment

    return Attachment, ParticleEmitter, ParticleEmitter2
end

local function middle(p6) -- line: 194
    local Center = p6:GetAttribute("Center")

    if typeof(Center) == "Vector3" then
        return p6.CFrame:PointToWorldSpace(Center)
    end

    return p6.Position
end

local function launch(p7, p8, p9, p10, p11) -- line: 202
    local Center = p8:GetAttribute("Center")
    local v4 = if typeof(Center) == "Vector3" then p8.CFrame:PointToWorldSpace(Center) else p8.Position
    local Size = p8.Size

    table.insert(p7.Movers, {
        Resting = false,
        Plowed = false,
        Part = p8,
        Center = v4,
        Rel = CFrame.new(v4):ToObjectSpace(p8.CFrame),
        Turned = CFrame.identity,
        Velocity = p9,
        Turn = p10,
        Half = math.min(Size.X, Size.Y, Size.Z) / 2 * 0.8,
        Radius = math.max(Size.X, Size.Y, Size.Z) * 0.3,
        Loud = p11
    })
end

local function move(p12, p13, p14) -- line: 220
    -- upvalues: Sfx (copy)
    if p13.Resting or p13.Part.Parent == nil then
        return
    end

    local v5 = p13.Velocity - Vector3.new(0, 1, 0) * (p14 * 196)
    local v6 = p13.Center + v5 * p14
    local v7 = p12.Ground + p13.Half

    if v6.Y <= v7 then
        v6 = Vector3.new(v6.X, v7, v6.Z)

        if v5.Y < -6 then
            if p13.Loud then
                Sfx.At("PadlockClunk", v6, math.clamp(-v5.Y / 40, 0.2, 0.7), 0.9)
            end

            v5 = Vector3.new(v5.X * 0.55, -v5.Y * 0.3, v5.Z * 0.55)
            p13.Turn *= 0.5
        else
            p13.Turn = Vector3.new(0, 0, 0)
            p13.Resting = true
            v5 = Vector3.new(0, 0, 0)
        end
    end

    p13.Velocity = v5
    p13.Center = v6

    local Turn = p13.Turn

    if Turn.Magnitude > 0.001 then
        p13.Turned = CFrame.fromAxisAngle(Turn.Unit, Turn.Magnitude * p14) * p13.Turned
    end

    p13.Part.CFrame = CFrame.new(v6) * p13.Turned * p13.Rel
end

local function release(p15, p16, p17, p18) -- line: 250
    -- upvalues: launch (copy)
    if p16.Released then
        return
    end

    p16.Released = true

    local Part = p16.Part
    local Random = p15.Random
    local Center = Part:GetAttribute("Center")
    local v12 = if typeof(Center) == "Vector3" then Part.CFrame:PointToWorldSpace(Center) else Part.Position
    local v13 = v12 - p15.Center
    local v15 = Vector3.new(v13.X, v13.Y * 0.6, v13.Z)
    local v16 = if v15.Magnitude > 0.1 then v15.Unit else Vector3.new(0, 1, 0)

    if p18 then
        launch(p15, Part, p17, Vector3.new(0, 0, 0), false)
    else
        local Unit = (Vector3.new(0, 1, 0)):Cross(p17).Unit
        local v17 = if (v12 - p15.Center):Dot(Unit) >= 0 then 1 else -1

        launch(p15, Part, p17 * Random:NextNumber(0, 0.5) + Unit * (v17 * Random:NextNumber(13, 20)) + v16 * Random:NextNumber(1, 2.5) + Vector3.new(0, 1, 0) * Random:NextNumber(-4, 1), p17:Cross(v16) * Random:NextNumber(2, 5) + Vector3.new(Random:NextNumber(-2, 2), Random:NextNumber(-2, 2), Random:NextNumber(-2, 2)), false)
        p15.Sparks.WorldPosition = v12
        p15.Emitter:Emit(4)
    end
end

local function place(p19) -- line: 286
    p19.Part.CFrame = CFrame.new(p19.Center) * p19.Turned * p19.Rel
end

local function groundBelow(p20, p21, p22) -- line: 290
    -- upvalues: Players (copy), Workspace (copy)
    local t4 = {
        p20
    }
    local Parent = p20.Parent

    if Parent ~= nil then
        table.insert(t4, Parent)
    end

    for _, player in Players:GetPlayers() do
        if player.Character ~= nil then
            table.insert(t4, player.Character)
        end
    end

    local v22 = RaycastParams.new()

    v22.FilterType = Enum.RaycastFilterType.Exclude
    v22.FilterDescendantsInstances = t4
    v22.IgnoreWater = true

    local v23 = Workspace:Raycast(p21, Vector3.new(-0, -60, -0, -0), v22)

    if v23 ~= nil and not (v23.Instance.Transparency >= 1) and not (v23.Position.Y < p22) then
        return v23.Position.Y
    end

    return p22
end

local function drop(p23, p24, p25, p26) -- line: 312
    -- upvalues: Sfx (copy), launch (copy), release (copy)
    local Random, Padlock, Shackle = p23.Random, p23.Padlock, p23.Shackle
    local v24 = Padlock or Shackle

    if v24 ~= nil then
        if p25 then
            launch(p23, v24, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), false)
        else
            local Unit = (Vector3.new(0, 1, 0)):Cross(p24).Unit
            local v25 = if Random:NextNumber() < 0.5 then -1 else 1

            if p26 ~= nil and p26:Dot(Unit) ~= 0 then
                v25 = if p26:Dot(Unit) > 0 then 1 else -1
            end

            launch(p23, v24, p24 * Random:NextNumber(0.3, 0.8) + Unit * (v25 * Random:NextNumber(18, 23)) + Vector3.new(0, 1, 0) * Random:NextNumber(3, 5), Vector3.new(Random:NextNumber(-3, 3), Random:NextNumber(-2, 2), Random:NextNumber(-3, 3)), true)
        end

        if Padlock ~= nil and Shackle ~= nil then
            table.insert(p23.Riders, {
                Part = Shackle,
                Base = Padlock,
                Rel = Padlock.CFrame:ToObjectSpace(Shackle.CFrame)
            })
        end
    end

    local v29 = #p23.Pieces
    local v30 = if v29 > 0 then p23.Pieces[v29].Distance else 1
    local n1 = 0

    for v31, v32 in p23.Pieces do
        local v33 = if p25 then 0 else v32.Distance / math.max(v30, 1) * 0.18

        p23.Trove:Add(task.delay(v33, function() -- line: 353
            -- upvalues: p23 (copy), p24 (copy), p25 (copy), v29 (copy), n1 (ref), v31 (copy), v32 (copy), Sfx (copy), release (copy)
            release(p23, v32, p24, p25)

            local At, v34, v35

            if p25 then
                v35 = true
            elseif n1 < 12 and v31 % 2 == 1 then
                n1 += 1
                At = Sfx.At

                local Part = v32.Part
                local Center = Part:GetAttribute("Center")

                v34 = if typeof(Center) == "Vector3" then Part.CFrame:PointToWorldSpace(Center) else Part.Position
                v35 = false
            else
                v35 = true
            end

            if v35 then
                return
            end

            At("LinkClink", v34, 0.5, v31 / math.max(v29, 1) * 0.6 + 1)
        end))
    end
end

function t1.Hide(p27, p28) -- line: 367
    -- upvalues: lockParts (copy)
    for _, v36 in lockParts(p27) do
        if p28 then
            if v36:GetAttribute("ManorHidden") == nil then
                v36:SetAttribute("ManorHidden", v36.Transparency)
            end

            v36.Transparency = 1
            v36.CanCollide = false
            v36.CanQuery = false
            v36.CanTouch = false
        else
            local ManorHidden = v36:GetAttribute("ManorHidden")

            v36.Transparency = if type(ManorHidden) ~= "number" then 0 else ManorHidden
            v36:SetAttribute("ManorHidden", nil)
            v36.CanCollide = true
            v36.CanQuery = true
            v36.CanTouch = true
        end
    end
end

function t1.Prepare(p29, p30) -- line: 388
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), t1 (copy), lockParts (copy), quietClone (copy), emitters (copy), move (copy), groundBelow (copy)
    t1.Sweep()

    local v37 = p29:Add(Instance.new("Folder"))

    v37.Name = "ManorChainBurst"

    local v38 = p30:FindFirstChild("Cube.003", true)
    local v39 = p30:FindFirstChild("Cube.004", true)
    local Position = if v38 == nil or not v38:IsA("BasePart") then p30:GetBoundingBox().Position else v38.Position
    local t6 = {}
    local t7 = {}

    for _, v40 in lockParts(p30) do
        t7[v40] = v40.CFrame

        if string.sub(v40.Name, 1, 8) == "Cylinder" then
            table.insert(t6, v40)
        end
    end

    local t8 = {}
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local ManorInterior = Assets and Assets:FindFirstChild("ManorInterior")
    local ChainLinks = ManorInterior and ManorInterior:FindFirstChild("ChainLinks")

    if ChainLinks == nil or not ChainLinks:IsA("Model") then
        ChainLinks = nil
    end

    if ChainLinks ~= nil then
        local clone = ChainLinks:Clone()

        clone:PivotTo(p30:GetPivot())

        for _, child in clone:GetChildren() do
            if child:IsA("BasePart") then
                child.Anchored = true
                child.CanCollide = false
                child.CanQuery = false
                child.CanTouch = false
                child.Transparency = 1

                local Distance = child:GetAttribute("Distance")
                local t9 = {
                    Released = false,
                    Part = child
                }

                if type(Distance) ~= "number" then
                    local Center = child:GetAttribute("Center")

                    Distance = ((if typeof(Center) == "Vector3" then child.CFrame:PointToWorldSpace(Center) else child.Position) - Position).Magnitude
                end

                t9.Distance = Distance
                table.insert(t8, t9)
                child.Parent = v37
            end
        end

        clone:Destroy()
    end

    table.sort(t8, function(p31, p32) -- line: 430
        return p31.Distance < p32.Distance
    end)

    local v41 = if v38 == nil or not v38:IsA("BasePart") then nil else quietClone(v38, v37)
    local v42 = if v39 == nil or not v39:IsA("BasePart") then nil else quietClone(v39, v37)

    if v41 ~= nil then
        v41.Transparency = 1
    end

    if v42 ~= nil then
        v42.Transparency = 1
    end

    local v43, v44, v45 = emitters(v37, Position)

    v37.Parent = Workspace

    local t10 = {
        Snapped = false,
        Trove = p29,
        Lock = p30,
        Folder = v37,
        Pieces = t8,
        Padlock = v41,
        Shackle = v42,
        PadlockSource = if v38 == nil or not v38:IsA("BasePart") then nil else v38,
        ShackleSource = if v39 == nil or not v39:IsA("BasePart") then nil else v39,
        Chains = t6,
        Rest = t7,
        Sparks = v43,
        Emitter = v44,
        Dust = v45,
        Random = Random.new(),
        Center = Position,
        Ground = groundBelow(p30, Position, p30:GetBoundingBox().Position.Y - p30:GetExtentsSize().Y / 2),
        Movers = {},
        Riders = {}
    }

    p29:Connect(RunService.Heartbeat, function(p33) -- line: 476
        -- upvalues: t10 (copy), Workspace (copy), move (copy)
        for _, v46 in t10.Movers do
            move(t10, v46, p33)
        end

        for _, v47 in t10.Riders do
            if v47.Part.Parent ~= nil then
                v47.Part.CFrame = v47.Base.CFrame * v47.Rel
            end
        end

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            local CFramePosition = CurrentCamera.CFrame.Position

            for _, v48 in t10.Movers do
                local v49 = (v48.Part.Position - CFramePosition).Magnitude - v48.Part.Size.Magnitude * 0.35

                v48.Part.LocalTransparencyModifier = math.clamp((6 - v49) / 2.5, 0, 1)
            end
        end
    end)
    p29:Add(function() -- line: 496
        -- upvalues: t7 (copy)
        for v51, v52 in t7 do
            if v51.Parent ~= nil then
                v51.CFrame = v52
            end
        end
    end)

    return t10
end

function t1.Rattle(p34, p35, p36) -- line: 506
    if p34.Snapped then
        return
    end

    for v53, v54 in p34.Chains do
        local v55 = p34.Rest[v54]

        if v55 ~= nil then
            local v57 = math.sin(p36 * 70 + v53 * 1.7) * 0.15 * p35

            v54.CFrame = v55 * CFrame.new(v57, v57 * 0.5, 0)
        end
    end
end

function t1.Nudge(p37, p38, p39) -- line: 519
    if p38 ~= nil then
        local v58 = p37.Rest[p38]

        if v58 ~= nil then
            p38.CFrame = v58 + p39
        end
    end
end

function t1.Settle(p40) -- line: 529
    for v59, v60 in p40.Rest do
        if v59.Parent ~= nil then
            v59.CFrame = v60
        end
    end
end

function t1.Snap(p41, p42, p43, p44, p45) -- line: 537
    -- upvalues: TweenService (copy), Sfx (copy), v1 (copy), t1 (copy), quietClone (copy), drop (copy)
    if p41.Snapped then
        return
    end

    p41.Snapped = true

    if p41.Padlock ~= nil and p41.PadlockSource ~= nil then
        p41.Padlock.CFrame = p41.PadlockSource.CFrame
    end

    if p41.Shackle ~= nil and p41.ShackleSource ~= nil then
        p41.Shackle.CFrame = p41.ShackleSource.CFrame
    end

    t1.Settle(p41)

    for _, v61 in p41.Pieces do
        v61.Part.Transparency = 0
    end

    if p41.Padlock ~= nil then
        p41.Padlock.Transparency = 0
    end

    if p41.Shackle ~= nil then
        p41.Shackle.Transparency = 0
    end

    t1.Hide(p41.Lock, true)

    if #p41.Pieces == 0 then
        for _, v62 in p41.Chains do
            TweenService:Create(quietClone(v62, p41.Folder), v1, {
                Transparency = 1
            }):Play()
        end
    end

    p41.Sparks.WorldPosition = p41.Center

    if not p43 then
        p41.Emitter:Emit(24)
    end

    p41.Dust:Emit(10)

    local Random = p41.Random

    p41.Trove:Add(task.delay(p44, function() -- line: 571
        -- upvalues: p41 (copy), p42 (copy), p43 (copy), p45 (copy), drop (copy)
        drop(p41, p42, p43, p45)
    end))

    for i = 1, 2 do
        p41.Trove:Add(task.delay(p44 + 0.45 + i * 0.28, function() -- line: 575
            -- upvalues: p41 (copy), i (copy), Sfx (copy)
            local Padlock = p41.Padlock
            local v64 = if Padlock == nil then p41.Center else Padlock.Position

            Sfx.At("PadlockClunk", v64, 0.7 / i, i * 0.08 + 0.9)
        end))
    end

    for i = 1, 6 do
        p41.Trove:Add(task.delay(p44 + 0.3 + i * 0.11 + Random:NextNumber(0, 0.06), function() -- line: 582
            -- upvalues: p41 (copy), Random (copy), Sfx (copy)
            local v65 = #p41.Pieces
            local v66 = p41.Pieces[Random:NextInteger(1, (math.max(v65, 1)))]
            local v67

            if v66 ~= nil then
                local Part = v66.Part
                local Center = Part:GetAttribute("Center")

                v67 = if typeof(Center) == "Vector3" then Part.CFrame:PointToWorldSpace(Center) else Part.Position
            else
                v67 = p41.Center
            end

            Sfx.At("LinkClink", v67, 0.35, Random:NextNumber(0.7, 0.95))
        end))
    end
end

function t1.Plow(p46, p47, p48) -- line: 591
    -- upvalues: Sfx (copy)
    if p46.Snapped then
        for _, v68 in p46.Movers do
            if v68.Part.Parent ~= nil then
                for _, v69 in p47 do
                    local Along = v69.Along
                    local v70 = (Vector3.new(0, 1, 0)):Cross(Along)

                    if v70:Dot(p48) < 0 then
                        v70 = -v70
                    end

                    local v71 = v68.Center - v69.Hinge
                    local v72 = Vector3.new(v71.X, 0, v71.Z)
                    local v73 = v72:Dot(Along)
                    local v74 = v72:Dot(v70)
                    local Radius = v68.Radius

                    if not (v73 < 0) and not (v69.Reach + Radius * 0.5 < v73) and not (Radius <= v74) and not (v74 <= -1.5) and not (v72:Dot(p48) < -1.5) then
                        v68.Center += v70 * (Radius - v74)
                        v68.Part.CFrame = CFrame.new(v68.Center) * v68.Turned * v68.Rel

                        if v68.Loud and not v68.Plowed then
                            Sfx.At("PadlockClunk", v68.Center, 0.3, 0.65)
                        end

                        v68.Plowed = true
                    end
                end
            end
        end
    end
end

function t1.Tidy(p49, p50, p51, p52) -- line: 626
    -- upvalues: TweenService (copy), v2 (copy)
    local t11 = {}

    for _, v75 in p49.Movers do
        local Part = v75.Part

        if Part.Parent ~= nil and not (Part.Transparency >= 1) and math.abs(((v75.Center - p50):Dot(p51))) < p52 + v75.Radius then
            v75.Resting = true
            t11[Part] = true
            TweenService:Create(Part, v2, {
                Transparency = 1,
                CFrame = Part.CFrame - Vector3.new(0, 1.6, 0)
            }):Play()
        end
    end

    for _, v77 in p49.Riders do
        if t11[v77.Base] and v77.Part.Parent ~= nil then
            TweenService:Create(v77.Part, v2, {
                Transparency = 1
            }):Play()
        end
    end

    return next(t11) ~= nil
end

function t1.Keep(p53) -- line: 650
    -- upvalues: v3 (ref), t1 (copy)
    v3 = p53
    p53.Trove:Add(task.delay(1, function() -- line: 652
        -- upvalues: p53 (copy), v3 (ref), t1 (copy)
        if v3 == p53 then
            t1.Sweep()
        end
    end))
end

function t1.Sweep() -- line: 659
    -- upvalues: TweenService (copy), v1 (copy), v3 (ref)
    local v78 = v3

    v3 = nil

    if v78 == nil then
        return
    end

    for _, descendant in v78.Folder:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local t12 = {
                Transparency = 1
            }

            if descendant.Anchored then
                t12.CFrame = descendant.CFrame - Vector3.new(0, 1.6, 0)
            end

            TweenService:Create(descendant, v1, t12):Play()
        end
    end

    task.delay(v1.Time, function() -- line: 675
        -- upvalues: v78 (copy)
        v78.Trove:Destroy()
    end)
end

function t1.Clear() -- line: 680
    -- upvalues: v3 (ref)
    local v79 = v3

    v3 = nil

    if v79 ~= nil then
        v79.Trove:Destroy()
    end
end

return table.freeze(t1)

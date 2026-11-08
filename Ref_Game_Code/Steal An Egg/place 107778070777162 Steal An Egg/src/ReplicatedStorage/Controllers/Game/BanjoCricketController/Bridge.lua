-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local BanjoCricketFlags = require(ReplicatedStorage.Shared.Flags.BanjoCricketFlags)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Quart = Enum.EasingStyle.Quart
local BanjoCricket2 = ReplicatedStorage.Assets.VFX.BanjoCricket
local Notes = BanjoCricket2.Notes

assert(Notes:IsA("Attachment"), "Assets.VFX.BanjoCricket.Notes must be an Attachment")

local NoteFlyer = BanjoCricket2.NoteFlyer

assert(NoteFlyer:FindFirstChild("Head") and NoteFlyer:FindFirstChild("Tail"), "Assets.VFX.BanjoCricket.NoteFlyer needs a Head and a Tail attachment")

local Block = BanjoCricket2.Block

assert(Block:IsA("BasePart"), "Assets.VFX.BanjoCricket.Block must be a BasePart")

local Spark = BanjoCricket2.Spark
local v2

assert(Spark:IsA("Attachment") and Spark:FindFirstChildOfClass("ParticleEmitter") and Spark:FindFirstChildOfClass("PointLight"), "Assets.VFX.BanjoCricket.Spark must be an Attachment with a ParticleEmitter and a PointLight")

local t1 = {}

for _, child in Notes:GetChildren() do
    if child:IsA("ParticleEmitter") then
        table.insert(t1, child.Texture)
    end
end

local v1 = NoteFlyer:FindFirstChildWhichIsA("Trail", true)

v2 = if v1 then v1.Lifetime else 0

local t2 = {}
local t3 = {}
local v3 = false
local LocalPlayer = Players.LocalPlayer
local v4
local t4 = {}
local v5 = Trove.new()
local v6 = false
local v7 = Random.new()
local t5
local t6 = {}

local function pieceOf(p1) -- line: 203
    return {
        Part = p1,
        Transparency = p1.Transparency,
        CanCollide = p1.CanCollide
    }
end

local function strandOf(p2, p3) -- line: 211
    local t7 = {
        FarIsZero = false,
        Beam = p2,
        Enabled = p2.Enabled,
        Width0 = p2.Width0,
        Width1 = p2.Width1,
        Brightness = p2.Brightness
    }
    local Attachment0, Attachment1 = p2.Attachment0, p2.Attachment1

    if Attachment0 and Attachment1 then
        local v8 = (Attachment0.WorldPosition - p3).Magnitude > (Attachment1.WorldPosition - p3).Magnitude

        if v8 then
            t7.Near = Attachment1
        else
            t7.Near = Attachment0
            Attachment0 = Attachment1
        end

        t7.Far = Attachment0
        t7.FarIsZero = v8
    end

    return t7
end

local function setFar(p4, p5) -- line: 231
    if p4.FarIsZero then
        p4.Beam.Attachment0 = p5
    else
        p4.Beam.Attachment1 = p5
    end
end

local function setNotes(p6, p7) -- line: 239
    for _, child in p6:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = p7
        end
    end
end

local function scaled(p8, p9) -- line: 247
    local t8 = {}

    for _, v9 in p8.Keypoints do
        table.insert(t8, NumberSequenceKeypoint.new(v9.Time, v9.Value * p9, v9.Envelope * p9))
    end

    return NumberSequence.new(t8)
end

local function lock(p10) -- line: 262
    p10.Barrier.Part.CanCollide = true

    for _, v12 in p10.Pieces do
        v12.Part.Transparency = 1
        v12.Part.CanCollide = false
    end

    for _, v13 in p10.Strands do
        v13.Beam.Enabled = false
    end
end

local function restore(p11) -- line: 273
    p11.Barrier.Part.CanCollide = p11.Barrier.CanCollide

    for _, v14 in p11.Pieces do
        v14.Part.Transparency = v14.Transparency
        v14.Part.CanCollide = v14.CanCollide
    end

    for _, v15 in p11.Strands do
        local Far = v15.Far

        if Far then
            if v15.FarIsZero then
                v15.Beam.Attachment0 = Far
            else
                v15.Beam.Attachment1 = Far
            end
        end

        v15.Beam.Width0 = v15.Width0
        v15.Beam.Width1 = v15.Width1
        v15.Beam.Brightness = v15.Brightness
        v15.Beam.Enabled = v15.Enabled
    end
end

local function sparkOf(p12, p13) -- line: 291
    -- upvalues: Workspace (copy), Spark (copy)
    local clone = p12:Clone(Spark)

    clone.Position = p13
    clone.Parent = Workspace.Terrain

    return {
        Attachment = clone,
        Sparkles = clone:FindFirstChildOfClass("ParticleEmitter"),
        Glow = clone:FindFirstChildOfClass("PointLight")
    }
end

local function lanesOf(p14, p15, p16) -- line: 302
    local t9 = {}
    local t10 = {}

    for _, v16 in p14 do
        local Near, Far = v16.Near, v16.Far

        if Near and Far and not t10[Far] then
            t10[Far] = true
            table.insert(t9, {
                Near = Near.WorldPosition,
                Far = Far.WorldPosition
            })
        end
    end

    if #t9 == 0 then
        table.insert(t9, {
            Near = p15.Position,
            Far = p16.Position
        })
    end

    return t9
end

local function floorAt(p17, p18) -- line: 318
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local v17 = RaycastParams.new()

    v17.FilterType = Enum.RaycastFilterType.Exclude

    local t13 = {
        p17
    }

    if LocalPlayer.Character then
        table.insert(t13, LocalPlayer.Character)
    end

    v17.FilterDescendantsInstances = t13
    v17.RespectCanCollide = true

    local v18 = Workspace:Raycast(p18 + Vector3.new(0, 20, 0), Vector3.new(-0, -40, -0, -0), v17)

    if v18 then
        return v18.Position.Y
    end

    return (-1e999)
end

local function unbind(p19) -- line: 335
    -- upvalues: t2 (copy)
    local v19 = t2[p19]

    if v19 then
        t2[p19] = nil
        v19.Trove:Destroy()
    end
end

local function bind(p20) -- line: 343
    -- upvalues: Workspace (copy), Trove (copy), Notes (copy), t2 (copy), strandOf (copy), setNotes (copy), scaled (copy), lock (copy), restore (copy), sparkOf (copy), lanesOf (copy), floorAt (copy)
    if not t2[p20] and p20:IsDescendantOf(Workspace) then
        local Start = p20:FindFirstChild("Start")
        local Barrier = p20:FindFirstChild("Barrier")

        if Start == nil or not Start:IsA("BasePart") or Barrier == nil or not Barrier:IsA("BasePart") then
            return
        end

        local t14 = {}
        local t15 = {}

        for _, descendant in p20:GetDescendants() do
            if descendant ~= Start and descendant ~= Barrier then
                if descendant:IsA("BasePart") then
                    table.insert(t14, {
                        Part = descendant,
                        Transparency = descendant.Transparency,
                        CanCollide = descendant.CanCollide
                    })
                elseif descendant:IsA("Beam") then
                    table.insert(t15, (strandOf(descendant, Start.Position)))
                end
            end
        end

        local v21 = Trove.new()
        local v22 = lanesOf(t15, Start, Barrier)
        local v23 = Vector3.new(0, 0, 0)
        local v24 = Vector3.new(0, 0, 0)
        local n1 = (-1e999)

        for _, v25 in v22 do
            v23 += v25.Near / #v22
            v24 += v25.Far / #v22
            n1 = math.max(n1, v25.Near.Y, v25.Far.Y)
        end

        local v28 = Vector3.new(v24.X - v23.X, 0, v24.Z - v23.Z)
        local v29 = if v28.Magnitude > 0.001 then v28.Unit else Vector3.new(1, 0, 0)
        local v30 = v29:Cross((Vector3.new(0, 1, 0)))
        local n2 = 0

        for _, v31 in v22 do
            n2 = math.max(n2, math.abs(((v31.Near - v23):Dot(v30))) * 2)
        end

        local v35 = math.max(n1, (floorAt(p20, Start.Position)))
        local clone = v21:Clone(Notes)

        clone.Name = "BanjoBridgeConfetti"

        for _, child in clone:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child.Size = scaled(child.Size, 3)
            end
        end

        setNotes(clone, false)
        clone.Position = v23
        clone.Parent = Workspace.Terrain

        local t17 = {
            Phase = "Sealed",
            NextNoteAt = 0,
            Start = Start,
            Barrier = {
                Part = Barrier,
                Transparency = Barrier.Transparency,
                CanCollide = Barrier.CanCollide
            },
            Pieces = t14,
            Strands = t15,
            Trove = v21,
            Lanes = v22,
            Near = v23,
            Far = v24,
            DeckTop = n1,
            Width = math.max(8, n2 + 5),
            Direction = v29,
            Side = v30,
            Length = v28.Magnitude,
            Anchor = sparkOf(v21, (Vector3.new(v23.X, v35 + 3, v23.Z))),
            Burst = sparkOf(v21, v23),
            Confetti = clone,
            Blocks = {}
        }

        t2[p20] = t17
        lock(t17)
        v21:Add(function() -- line: 419
            -- upvalues: t17 (copy), restore (copy)
            restore(t17)
        end)
        v21:Connect(p20.Destroying, function() -- line: 422
            -- upvalues: p20 (copy), t2 (copy)
            local v38 = t2[p20]

            if v38 then
                t2[p20] = nil
                v38.Trove:Destroy()
            end
        end)
    end
end

local function makePassable(p21) -- line: 427
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

local function swing(p22) -- line: 435
    -- upvalues: TweenService (copy), makePassable (copy)
    makePassable(p22.Model)

    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = p22.Closed
    CFrameValue.Changed:Connect(function(p23) -- line: 439
        -- upvalues: p22 (copy)
        if p22.Model.Parent ~= nil then
            p22.Model:PivotTo(p23)
        end
    end)

    local tween = TweenService:Create(CFrameValue, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Value = p22.Opened
    })

    tween.Completed:Once(function() -- line: 449
        -- upvalues: CFrameValue (copy)
        CFrameValue:Destroy()
    end)
    tween:Play()
end

local function bindGate(p24) -- line: 455
    -- upvalues: Workspace (copy), BanjoCricket (copy), t3 (copy), v3 (ref), makePassable (copy)
    local Pivot, Attribute, v39

    if t3[p24] then
        v39 = true
    elseif p24:IsA("Model") and p24:IsDescendantOf(Workspace) then
        Pivot = p24:GetPivot()
        Attribute = p24:GetAttribute(BanjoCricket.Attributes.DoorOpenAngle)

        if typeof(Attribute) ~= "number" then
            Attribute = 100
        end

        v39 = false
    else
        v39 = true
    end

    if v39 then
        return
    end

    local t18 = {
        Model = p24,
        Closed = Pivot,
        Opened = Pivot * CFrame.Angles(0, math.rad(Attribute), 0)
    }

    t3[p24] = t18

    if v3 then
        p24:PivotTo(t18.Opened)
        makePassable(p24)
    end
end

local function openGates() -- line: 474
    -- upvalues: t3 (copy), v3 (ref), swing (copy)
    if v3 then
        return
    end

    v3 = true

    for _, v40 in t3 do
        swing(v40)
    end
end

local function pluck(p25, p26, p27) -- line: 484
    -- upvalues: Audio (copy), BanjoCricket (copy)
    local v41 = #BanjoCricket.Mushrooms
    local v42 = BanjoCricket.Mushrooms[p25 % v41 + 1]

    Audio.Play(v42.Sound, p26, {
        MaxDistance = 90,
        PlaybackSpeed = v42.Speed * 2 ^ (p25 // v41),
        Volume = p27
    })
end

local function noteColor(p28) -- line: 494
    -- upvalues: BanjoCricket (copy)
    local v43 = #BanjoCricket.Mushrooms

    return BanjoCricket.Mushrooms[p28 % v43 + 1].Color
end

local function fadeLight(p29, p30, p31) -- line: 499
    -- upvalues: TweenService (copy)
    p29.Brightness = p30
    TweenService:Create(p29, TweenInfo.new(p31, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 0
    }):Play()
end

local function burst(p32, p33, p34, p35) -- line: 508
    local Burst = p32.Burst

    Burst.Attachment.WorldPosition = p33
    Burst.Sparkles:Emit(p34)

    if p35 > 0 then
        p32.Confetti.WorldPosition = p33

        for _, child in p32.Confetti:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(p35)
            end
        end
    end
end

local function bezier(p36, p37) -- line: 522
    local v44 = 1 - p37

    return p36[1] * (v44 * v44 * v44) + p36[2] * (v44 * 3 * v44 * p37) + p36[3] * (v44 * 3 * p37 * p37) + p36[4] * (p37 * p37 * p37)
end

local function arc(p38, p39) -- line: 530
    -- upvalues: v7 (copy)
    local v45 = p39 - p38
    local Magnitude = v45.Magnitude
    local v47 = math.max(3, Magnitude * 0.35)
    local v48 = Vector3.new(v45.X, 0, v45.Z)
    local v49 = if v48.Magnitude > 0.001 then v48.Unit:Cross((Vector3.new(0, 1, 0))) else Vector3.new(1, 0, 0)
    local v50 = Magnitude * 0.3

    return {
        p38,
        p38 + v45 * 0.25 + Vector3.new(0, 1, 0) * v47 * v7:NextNumber(0.8, 1.3) + v49 * v7:NextNumber(-v50, v50),
        p39 - v45 * 0.15 + Vector3.new(0, 1, 0) * v47 * v7:NextNumber(0.4, 0.9) + v49 * v7:NextNumber(-v50, v50) * 0.5,
        p39
    }
end

local function moveFlyer(p40, p41) -- line: 551
    p40.Head.WorldPosition = p41 + Vector3.new(0, 0.25, 0)
    p40.Tail.WorldPosition = p41 - Vector3.new(0, 0.25, 0)
end

local function stepFlyer(p42, p43) -- line: 556
    -- upvalues: TweenService (copy)
    local v52 = math.clamp((p43 - p42.StartedAt) / p42.Seconds, 0, 1)
    local Points = p42.Points
    local v53 = 1 - v52
    local v54 = Points[1] * (v53 * v53 * v53) + Points[2] * (v53 * 3 * v53 * v52) + Points[3] * (v53 * 3 * v52 * v52) + Points[4] * (v52 * v52 * v52)

    p42.Head.WorldPosition = v54 + Vector3.new(0, 0.25, 0)
    p42.Tail.WorldPosition = v54 - Vector3.new(0, 0.25, 0)

    local Value = TweenService:GetValue(math.min(1, v52 / 0.2), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v57 = math.min(1, (1 - v52) / 0.25)
    local v58 = 2.2 * Value * (v57 * 0.7 + 0.3)

    p42.Gui.Size = UDim2.fromScale(v58, v58)
    p42.Image.Rotation = p42.Tilt + math.sin(p43 * p42.Wobble) * 25

    return v52 >= 1
end

local function retire(p44) -- line: 571
    if not p44.Dead then
        p44.Owner:Remove(p44.Trove)
    end
end

local function land(p45) -- line: 577
    -- upvalues: retire (copy), v2 (ref)
    p45.Gui.Enabled = false
    p45.Landed()
    task.delay(v2, retire, p45)
end

local function stopCharge(p46) -- line: 583
    -- upvalues: fadeLight (copy)
    if p46.StartedAt == nil then
        return
    end

    p46.StartedAt = nil
    p46.Anchor.Sparkles.Rate = 0
    fadeLight(p46.Anchor.Glow, p46.Anchor.Glow.Brightness, 0.4)
end

local function launch(p47, p48, p49, p50, p51, p52) -- line: 592
    -- upvalues: Workspace (copy), BanjoCricket (copy), NoteFlyer (copy), t1 (copy), t4 (copy), v7 (copy), arc (copy)
    local v60 = p47.Trove:Extend()
    local clone = v60:Clone(NoteFlyer)
    local Head = clone:FindFirstChild("Head")
    local Tail = clone:FindFirstChild("Tail")
    local v61 = Head:FindFirstChildWhichIsA("BillboardGui", true)
    local v62 = v61:FindFirstChildWhichIsA("ImageLabel", true)
    local v63 = Head:FindFirstChildWhichIsA("Trail", true)
    local v64 = #BanjoCricket.Mushrooms
    local Color = BanjoCricket.Mushrooms[p51 % v64 + 1].Color

    v60:Add(Head)
    v60:Add(Tail)

    if #t1 > 0 then
        v62.Image = t1[p51 % #t1 + 1]
    end

    v62.ImageColor3 = Color

    if v63 then
        v63.Color = ColorSequence.new(Color)
    end

    v61.Size = UDim2.fromScale(0, 0)

    local t19 = {
        Dead = false,
        Head = Head,
        Tail = Tail,
        Gui = v61,
        Image = v62,
        Trove = v60,
        Owner = p47.Trove,
        Points = arc(p48, p49),
        StartedAt = os.clock(),
        Seconds = p50,
        Tilt = v7:NextNumber(-15, 15),
        Wobble = v7:NextNumber(8, 14),
        Landed = p52
    }

    v60:Add(function() -- line: 633
        -- upvalues: t19 (copy)
        t19.Dead = true
    end)
    Head.Position = p48 + Vector3.new(0, 0.25, 0)
    Tail.Position = p48 - Vector3.new(0, 0.25, 0)
    Head.Parent = Workspace.Terrain
    Tail.Parent = Workspace.Terrain
    table.insert(t4, t19)
end

local function chargeStep(p53, p54) -- line: 643
    -- upvalues: BanjoCricket (copy), BanjoCricketFlags (copy), v4 (ref), v7 (copy), pluck (copy), launch (copy)
    local StartedAt = p53.StartedAt
    local v65 = v4
    local v66

    if p53.Phase ~= "Sealed" then
        v66 = true

        return not v66
    end

    if StartedAt == nil or v65 == nil or v65.Parent == nil then
        v66 = true
    else
        local v68 = math.clamp((p54 - StartedAt) / BanjoCricketFlags.BridgePlaySeconds:Get(), 0, 1)
        local Anchor = p53.Anchor

        Anchor.Glow.Brightness = v68 * 3
        Anchor.Glow.Range = (v68 * 0.6 + 0.4) * 16
        Anchor.Sparkles.Rate = v68 * 35

        if p53.NextNoteAt <= p54 then
            p53.NextNoteAt = p54 + 0.16 + v68 * -0.11

            local v70 = math.floor(v68 * (#BanjoCricket.Mushrooms - 0.001))
            local WorldPosition = Anchor.Attachment.WorldPosition

            launch(p53, v65.WorldPosition, WorldPosition, v7:NextNumber(0.45, 0.7), v70, function() -- line: 664
                -- upvalues: Anchor (copy), v70 (copy), WorldPosition (copy), pluck (copy)
                Anchor.Sparkles:Emit(3)
                pluck(v70, WorldPosition, 0.14)
            end)
        end

        v66 = false
    end

    return not v66
end

local function eased(p55) -- line: 673
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p55, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
end

local function endShot() -- line: 681
    -- upvalues: Workspace (copy), t5 (ref)
    local t20 = t5

    if t20 == nil then
        return
    end

    t5 = nil

    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.FieldOfView = t20.Fov
    CurrentCamera.CFrame = t20.From
    CurrentCamera.CameraType = t20.FromType
end

local function shotAlive() -- line: 693
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    return Humanoid ~= nil and Humanoid.Health > 0
end

local function stepShot(p56) -- line: 699
    -- upvalues: Workspace (copy), LocalPlayer (copy), t5 (ref), eased (copy)
    local t21 = t5

    if t21 ~= nil then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid ~= nil and Humanoid.Health > 0 then
            local CurrentCamera = Workspace.CurrentCamera
            local v72 = p56 - t21.StartedAt
            local EndsAt = t21.EndsAt
            local v73

            if EndsAt == nil or p56 < EndsAt then
                if v72 < 1 then
                    v73 = t21.From:Lerp(t21.Open, eased(v72 / 1))
                else
                    local v74 = (v72 - 1) / t21.DollySeconds

                    v73 = t21.Open:Lerp(t21.Close, eased(v74))
                end

                t21.Held = v73
            else
                local v75 = (p56 - EndsAt) / 0.9

                if v75 >= 1 then
                    local t22 = t5

                    if t22 ~= nil then
                        t5 = nil

                        local CurrentCamera = Workspace.CurrentCamera

                        CurrentCamera.FieldOfView = t22.Fov
                        CurrentCamera.CFrame = t22.From
                        CurrentCamera.CameraType = t22.FromType
                    end

                    return false
                end

                v73 = t21.Held:Lerp(t21.From, eased(v75))
            end

            t21.Kick = t21.Kick * math.exp(-9 * (p56 - t21.SteppedAt))
            t21.SteppedAt = p56
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = v73
            CurrentCamera.FieldOfView = t21.Fov + t21.Kick

            return true
        end

        local t23 = t5

        if t23 ~= nil then
            t5 = nil

            local CurrentCamera = Workspace.CurrentCamera

            CurrentCamera.FieldOfView = t23.Fov
            CurrentCamera.CFrame = t23.From
            CurrentCamera.CameraType = t23.FromType
        end
    end

    return false
end

local function kick(p57) -- line: 736
    -- upvalues: t5 (ref)
    local t24 = t5

    if t24 then
        t24.Kick += p57
    end
end

local function step() -- line: 743
    -- upvalues: t2 (copy), t4 (copy), v5 (copy), v6 (ref), stepFlyer (copy), retire (copy), v2 (ref), chargeStep (copy), stepShot (copy)
    local elapsed = os.clock()

    for i = #t4, 1, -1 do
        local v77 = t4[i]

        if v77.Dead then
            table.remove(t4, i)
        elseif stepFlyer(v77, elapsed) then
            table.remove(t4, i)
            v77.Gui.Enabled = false
            v77.Landed()
            task.delay(v2, retire, v77)
        end
    end

    local v78 = false

    for _, v79 in t2 do
        if chargeStep(v79, elapsed) then
            v78 = true
        end
    end

    local v80 = stepShot(elapsed)

    if #t4 == 0 and not v78 and not v80 then
        v6 = false
        v5:Clean()
    end
end

local function startStepping() -- line: 767
    -- upvalues: RunService (copy), v5 (copy), v6 (ref), step (copy)
    if v6 then
        return
    end

    v6 = true
    v5:Connect(RunService.PreRender, step)
end

local function origin(p58) -- line: 775
    -- upvalues: v4 (ref)
    local v81 = v4

    if not (v81 and v81.Parent) then
        return p58.Start.Position
    end

    return v81.WorldPosition
end

local function deckPoint(p59, p60) -- line: 783
    local v82 = p59.Near:Lerp(p59.Far, p60)

    return (Vector3.new(v82.X, p59.DeckTop, v82.Z))
end

local function film(p61, p62) -- line: 788
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), v5 (copy), v6 (ref), t5 (ref), step (copy)
    if t5 or GuiService.ReducedMotionEnabled then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v83 = p61.Near:Lerp(p61.Far, 0)
    local v84 = Vector3.new(v83.X, p61.DeckTop, v83.Z)
    local v85 = (CurrentCamera.CFrame.Position - v84):Dot(p61.Side)
    local v86 = p61.Side * (if v85 >= 0 then 1 else -1)
    local Length, Direction = p61.Length, p61.Direction
    local v87 = v84 - Direction * 16 + Vector3.new(0, 12, 0) + v86 * 8
    local v88 = v84 + Direction * Length * 0.3 + Vector3.new(0, 16, 0) + v86 * 22
    local elapsed = os.clock()

    t5 = {
        Kick = 0,
        Crossing = p61,
        From = CurrentCamera.CFrame,
        FromType = CurrentCamera.CameraType,
        Fov = CurrentCamera.FieldOfView,
        Open = CFrame.lookAt(v87, v84 + Direction * Length * 0.45),
        Close = CFrame.lookAt(v88, v84 + Direction * Length * 0.62),
        StartedAt = elapsed,
        DollySeconds = p62,
        Held = CurrentCamera.CFrame,
        SteppedAt = elapsed
    }
    p61.Trove:Add(function() -- line: 817
        -- upvalues: p61 (copy), Workspace (copy), t5 (ref)
        local t25 = t5

        if not t25 or t25.Crossing ~= p61 then
            return
        end

        local t26 = t5

        if t26 == nil then
            return
        end

        t5 = nil

        local CurrentCamera = Workspace.CurrentCamera

        CurrentCamera.FieldOfView = t26.Fov
        CurrentCamera.CFrame = t26.From
        CurrentCamera.CameraType = t26.FromType
    end)

    if v6 then
        return
    end

    v6 = true
    v5:Connect(RunService.PreRender, step)
end

local function celebrate(p63) -- line: 826
    -- upvalues: TweenService (copy), BanjoCricket (copy), t5 (ref), pluck (copy), fadeLight (copy), burst (copy)
    local v89 = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    for _, v90 in p63.Strands do
        local Beam = v90.Beam

        Beam.Width0 = v90.Width0 * 1.7
        Beam.Width1 = v90.Width1 * 1.7
        Beam.Brightness = v90.Brightness * 2.5
        TweenService:Create(Beam, v89, {
            Width0 = v90.Width0,
            Width1 = v90.Width1,
            Brightness = v90.Brightness
        }):Play()
    end

    local v91 = #BanjoCricket.Mushrooms
    local v92 = p63.Near:Lerp(p63.Far, 0.5)

    pluck(0, v92, 0.45)

    for i = 0, v91 - 1 do
        p63.Trove:Add(task.delay(i * 0.035, pluck, v91 + i, v92, 0.45))
    end

    for i = 0, 5 do
        local v93 = (i + 0.5) / 6
        local v94 = p63.Near:Lerp(p63.Far, v93)

        burst(p63, Vector3.new(v94.X, p63.DeckTop, v94.Z), 20, 4)
    end

    p63.Burst.Attachment.WorldPosition = v92
    fadeLight(p63.Burst.Glow, 8, 0.9)

    local t27 = t5

    if t27 then
        t27.Kick += 5
    end

    local t28 = t5

    if t28 and t28.Crossing == p63 then
        t28.EndsAt = os.clock() + 0.8
    end
end

local function sweep(p64) -- line: 860
    -- upvalues: TweenService (copy)
    for v96, v97 in p64.Blocks do
        local Size = v97.Size
        local tween = TweenService:Create(v97, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, (v96 - 1) * 0.035), {
            Transparency = 0,
            Color = Color3.new(1, 1, 1)
        })
        local tween2 = TweenService:Create(v97, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1,
            Size = Size * Vector3.new(1.1, 0.3, 1.1)
        })

        tween.Completed:Once(function() -- line: 880
            -- upvalues: v97 (copy), tween2 (copy)
            if v97.Parent then
                tween2:Play()
            end
        end)
        tween2.Completed:Once(function() -- line: 885
            -- upvalues: v97 (copy)
            v97:Destroy()
        end)
        tween:Play()
    end

    table.clear(p64.Blocks)
end

local function settle(p65) -- line: 893
    -- upvalues: TweenService (copy), t3 (copy), v3 (ref), swing (copy), celebrate (copy), sweep (copy)
    p65.Phase = "Open"

    if not v3 then
        v3 = true

        for _, v98 in t3 do
            swing(v98)
        end
    end

    for _, v99 in p65.Strands do
        local Far = v99.Far

        if Far then
            if v99.FarIsZero then
                v99.Beam.Attachment0 = Far
            else
                v99.Beam.Attachment1 = Far
            end
        end
    end

    p65.Barrier.Part.CanCollide = p65.Barrier.CanCollide
    sweep(p65)

    local v100 = TweenInfo.new(0.35, Enum.EasingStyle.Quad)

    for _, v101 in p65.Pieces do
        v101.Part.CanCollide = v101.CanCollide
        p65.Trove:Add(TweenService:Create(v101.Part, v100, {
            Transparency = v101.Transparency
        })):Play()
    end

    celebrate(p65)
end

local function makeTip(p66, p67) -- line: 916
    -- upvalues: Workspace (copy), Notes (copy), setNotes (copy), scaled (copy)
    local v102 = p66.Trove:Add(Notes:Clone())

    v102.Name = "BanjoBridgeTip"

    for _, child in v102:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Size = scaled(child.Size, 3)
        end
    end

    setNotes(v102, true)
    v102.Parent = Workspace.Terrain
    v102.WorldPosition = p67

    return v102
end

local function sprout(p68, p69) -- line: 930
    -- upvalues: TweenService (copy), Quart (copy), makeTip (copy)
    local t29 = {}
    local t30 = {}

    for _, v103 in p68.Strands do
        local Near, Far = v103.Near, v103.Far

        if Near and Far then
            local v104 = t30[Far]

            if v104 == nil then
                v104 = makeTip(p68, Near.WorldPosition)
                t30[Far] = v104
                table.insert(t29, {
                    Attachment = v104,
                    Lane = {
                        Near = Near.WorldPosition,
                        Far = Far.WorldPosition
                    }
                })
            end

            if v103.FarIsZero then
                v103.Beam.Attachment0 = v104
            else
                v103.Beam.Attachment1 = v104
            end
        end

        local Beam = v103.Beam

        Beam.Width0 = v103.Width0 * 0.12
        Beam.Width1 = v103.Width1 * 0.12
        Beam.Enabled = v103.Enabled
        p68.Trove:Add(TweenService:Create(Beam, TweenInfo.new(p69, Quart, Enum.EasingDirection.Out), {
            Width0 = v103.Width0,
            Width1 = v103.Width1
        })):Play()
    end

    return t29
end

local function advance(p70, p71, p72) -- line: 965
    -- upvalues: TweenService (copy)
    local v105 = TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    for _, v106 in p71 do
        p70.Trove:Add(TweenService:Create(v106.Attachment, v105, {
            WorldPosition = v106.Lane.Near:Lerp(v106.Lane.Far, p72)
        })):Play()
    end
end

local function slam(p73, p74) -- line: 976
    -- upvalues: TweenService (copy), Workspace (copy), BanjoCricket (copy), Block (copy), t5 (ref), pluck (copy), fadeLight (copy), burst (copy)
    local v107 = p73.Length / 12
    local v108 = (p74 + 0.5) / 12
    local v109 = p73.Near:Lerp(p73.Far, v108)
    local v110 = Vector3.new(v109.X, p73.DeckTop, v109.Z) - Vector3.new(0, 0.25, 0)
    local v112 = Vector3.new(p73.Width, 0.5, v107 * 0.86)
    local clone = p73.Trove:Clone(Block)

    clone.CFrame = CFrame.lookAt(v110, v110 + p73.Direction)
    clone.Size = v112 * Vector3.new(1.35, 2.7, 1.35)
    clone.Transparency = 0
    clone.Parent = Workspace
    table.insert(p73.Blocks, clone)

    local v113 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.06)
    local t32 = {
        Transparency = 0.55
    }
    local v114 = #BanjoCricket.Mushrooms

    t32.Color = BanjoCricket.Mushrooms[p74 % v114 + 1].Color

    local tween = TweenService:Create(clone, v113, t32)
    local tween2 = TweenService:Create(clone, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = v112
    })

    tween2.Completed:Once(function() -- line: 1004
        -- upvalues: clone (copy), tween (copy)
        if clone.Parent then
            tween:Play()
        end
    end)
    tween2:Play()

    local v115 = v110 + Vector3.new(0, 0.5, 0)

    burst(p73, v115, 14, 2)
    p73.Burst.Attachment.WorldPosition = v115
    fadeLight(p73.Burst.Glow, 4, 0.3)
    pluck(p74, v110, 0.5)

    local t33 = t5

    if t33 then
        t33.Kick += 1.6
    end
end

local function open(p75) -- line: 1018
    -- upvalues: RunService (copy), v4 (ref), v5 (copy), v6 (ref), setNotes (copy), fadeLight (copy), launch (copy), step (copy), film (copy), settle (copy), sprout (copy), advance (copy), slam (copy)
    if p75.StartedAt ~= nil then
        p75.StartedAt = nil
        p75.Anchor.Sparkles.Rate = 0
        fadeLight(p75.Anchor.Glow, p75.Anchor.Glow.Brightness, 0.4)
    end

    p75.Phase = "Forming"

    local Anchor = p75.Anchor

    Anchor.Sparkles:Emit(20)
    fadeLight(Anchor.Glow, 8, 0.9)
    film(p75, 4.11)

    local v116 = sprout(p75, 4.96)

    for i = 0, 11 do
        local v117 = i * 0.36 + 1
        local v118 = (i + 0.5) / 12
        local v119 = p75.Near:Lerp(p75.Far, v118)
        local v120 = Vector3.new(v119.X, p75.DeckTop, v119.Z) + Vector3.new(0, 0.4, 0)

        p75.Trove:Add(task.delay(v117 - 0.55, function() -- line: 1031
            -- upvalues: p75 (copy), v116 (copy), i (copy), v120 (copy), RunService (copy), v4 (ref), v5 (copy), v6 (ref), launch (copy), step (copy), advance (copy), slam (copy)
            local v121 = v4

            launch(p75, if not (v121 and v121.Parent) then p75.Start.Position else v121.WorldPosition, v120, 0.55, i, function() -- line: 1032
                -- upvalues: p75 (copy), v116 (copy), i (copy), advance (copy), slam (copy)
                slam(p75, i)
                advance(p75, v116, (i + 1) / 12)
            end)

            if v6 then
                return
            end

            v6 = true
            v5:Connect(RunService.PreRender, step)
        end))
    end

    p75.Trove:Add(task.delay(5.11, function() -- line: 1040
        -- upvalues: p75 (copy), v116 (copy), setNotes (copy), settle (copy)
        settle(p75)

        for _, v123 in v116 do
            setNotes(v123.Attachment, false)
        end
    end))
    p75.Trove:Add(task.delay(6.3100000000000005, function() -- line: 1046
        -- upvalues: v116 (copy)
        for _, v124 in v116 do
            v124.Attachment:Destroy()
        end
    end))
end

local function banjoNotes(p76) -- line: 1053
    -- upvalues: Notes (copy), setNotes (copy)
    local BasePart = p76:FindFirstChildWhichIsA("BasePart")

    if BasePart == nil then
        return nil
    end

    local BanjoBridgeNotes = BasePart:FindFirstChild("BanjoBridgeNotes")

    if BanjoBridgeNotes and BanjoBridgeNotes:IsA("Attachment") then
        return BanjoBridgeNotes
    end

    local clone = Notes:Clone()

    clone.Name = "BanjoBridgeNotes"
    setNotes(clone, false)
    clone.Parent = BasePart

    return clone
end

local function play(p77) -- line: 1069
    -- upvalues: v4 (ref), setNotes (copy)
    local v125 = v4

    if v125 == p77 then
        return
    end

    if v125 then
        setNotes(v125, false)
    end

    v4 = p77

    if p77 then
        setNotes(p77, true)
    end
end

local function update() -- line: 1082
    -- upvalues: RunService (copy), BanjoCricket (copy), BanjoCricketFlags (copy), t2 (copy), LocalPlayer (copy), v4 (ref), v5 (copy), v6 (ref), setNotes (copy), fadeLight (copy), step (copy), open (copy), banjoNotes (copy)
    local Character = LocalPlayer.Character
    local v126, v127

    if Character then
        v126 = Character:FindFirstChild("HumanoidRootPart")
        v127 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChildOfClass("Tool")
    else
        v127 = Character
        v126 = Character
    end

    if BanjoCricketFlags.Enabled:Get() and v126 ~= nil and v126:IsA("BasePart") and v127 ~= nil and not (v127.Health <= 0) and Character ~= nil and Character:GetAttribute("GearName") == BanjoCricket.GearId then
        local elapsed = os.clock()
        local v128 = false

        for _, v129 in t2 do
            if v129.Phase == "Forming" then
                v128 = true
            elseif v129.Phase ~= "Open" then
                if (v126.Position - v129.Start.Position).Magnitude > BanjoCricketFlags.BridgeReach:Get() then
                    if v129.StartedAt ~= nil then
                        v129.StartedAt = nil
                        v129.Anchor.Sparkles.Rate = 0
                        fadeLight(v129.Anchor.Glow, v129.Anchor.Glow.Brightness, 0.4)
                    end
                else
                    local StartedAt = v129.StartedAt

                    if StartedAt == nil then
                        StartedAt = elapsed
                        v129.StartedAt = elapsed
                        v129.NextNoteAt = elapsed

                        if not v6 then
                            v6 = true
                            v5:Connect(RunService.PreRender, step)
                        end
                    end

                    if elapsed - StartedAt >= BanjoCricketFlags.BridgePlaySeconds:Get() then
                        open(v129)
                    end

                    v128 = true
                end
            end
        end

        Character:SetAttribute("BanjoBridgePlaying", v128)

        local v130 = if v128 then banjoNotes(Character) else nil
        local v131 = v4

        if v131 ~= v130 then
            if v131 then
                setNotes(v131, false)
            end

            v4 = v130

            if v130 then
                setNotes(v130, true)
            end
        end
    else
        for _, v132 in t2 do
            if v132.StartedAt ~= nil then
                v132.StartedAt = nil
                v132.Anchor.Sparkles.Rate = 0
                fadeLight(v132.Anchor.Glow, v132.Anchor.Glow.Brightness, 0.4)
            end
        end

        if Character and Character:GetAttribute("GearName") == BanjoCricket.GearId then
            Character:SetAttribute("BanjoBridgePlaying", false)
        end

        local v133 = v4

        if v133 ~= nil then
            if v133 then
                setNotes(v133, false)
            end

            v4 = nil
        end
    end
end

function t6.Start() -- line: 1138
    -- upvalues: CollectionService (copy), BanjoCricket (copy), Timer (copy), t3 (copy), unbind (copy), bind (copy), bindGate (copy), update (copy)
    local Bridge = BanjoCricket.Tags.Bridge

    CollectionService:GetInstanceAddedSignal(Bridge):Connect(bind)
    CollectionService:GetInstanceRemovedSignal(Bridge):Connect(unbind)

    for _, v134 in CollectionService:GetTagged(Bridge) do
        bind(v134)
    end

    local Gate = BanjoCricket.Tags.Gate

    CollectionService:GetInstanceAddedSignal(Gate):Connect(bindGate)
    CollectionService:GetInstanceRemovedSignal(Gate):Connect(function(p78) -- line: 1147
        -- upvalues: t3 (copy)
        t3[p78] = nil
    end)

    for _, v135 in CollectionService:GetTagged(Gate) do
        bindGate(v135)
    end

    Timer.Simple(0.3, update)
end

return table.freeze(t6)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local CursedIslandWarsFlags = require(ReplicatedStorage.Shared.Flags.CursedIslandWarsFlags)
local State = require(script.Parent.State)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Assets = CursedIslandWars.Assets
local VFX, UI = Assets.VFX, Assets.UI
local Sounds = ReplicatedStorage.Assets.Sounds
local v1 = Color3.fromRGB(190, 70, 255)
local t1 = {
    Landmine = Color3.fromRGB(255, 140, 30),
    JumpPad = Color3.fromRGB(120, 255, 80)
}
local v2 = Color3.fromRGB(255, 214, 70)
local t2 = {
    Prep = true,
    Match = true,
    SuddenDeath = true
}
local v3 = Trove.new()
local v4
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}
local t10 = {}
local t11 = {}
local t12 = {}
local t13 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local t16 = {}
local self2 = setmetatable({}, {
    __mode = "k"
})
local Model
local v7 = false
local n1 = 0
local v8, v9
local v10 = false
local n2 = 0
local n3 = 0
local v11 = Random.new()
local t19 = {}

local function stage() -- line: 84
    -- upvalues: Workspace (copy), v4 (ref)
    local v12 = v4

    if v12 and v12.Parent then
        return v12
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "CursedIslandWarsFx"
    Folder.Parent = Workspace
    v4 = Folder

    return Folder
end

local function holders(p1, p2) -- line: 96
    local t20 = {}

    for _, descendant in p1:GetDescendants() do
        if (descendant:IsA("Attachment") or descendant:IsA("BasePart")) and descendant:GetAttribute("Phase") == p2 then
            table.insert(t20, descendant)
        end
    end

    return t20
end

function t19.Burst(p3, p4) -- line: 106
    -- upvalues: holders (copy)
    for _, v13 in holders(p3, p4) do
        for _, child in v13:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 1)
            end
        end
    end
end

function t19.Loop(p5, p6, p7, p8) -- line: 116
    -- upvalues: t12 (copy), holders (copy)
    for _, v14 in holders(p5, p6) do
        for _, descendant in v14:GetDescendants() do
            if descendant:IsA("ParticleEmitter") and descendant.Rate > 0 and descendant.Rate < 4 then
                descendant.Enabled = false

                if p7 then
                    if t12[descendant] == nil then
                        descendant:Emit(1)
                        t12[descendant] = os.clock() + 1 / descendant.Rate
                    end
                else
                    t12[descendant] = nil
                end

                if p8 then
                    descendant:Clear()
                end
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
                descendant.Enabled = p7

                if p8 and descendant:IsA("ParticleEmitter") then
                    descendant:Clear()
                end
            end
        end
    end
end

local function stepSteady() -- line: 140
    -- upvalues: t12 (copy)
    local elapsed = os.clock()

    for v15, v16 in t12 do
        if v15.Parent ~= nil then
            if v16 <= elapsed then
                v15:Emit(1)
                t12[v15] = elapsed + 1 / math.max(v15.Rate, 0.05)
            end
        else
            t12[v15] = nil
        end
    end
end

function t19.Tint(p9, p10) -- line: 152
    for _, descendant in p9:GetDescendants() do
        if descendant:GetAttribute("TeamTint") and (descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail")) then
            descendant.Color = ColorSequence.new(p10)
        end
    end
end

function t19.Anchored(p11, p12, p13) -- line: 160
    -- upvalues: Workspace (copy), v4 (ref), t19 (copy)
    local clone = p11:Clone()

    clone:PivotTo(p12)

    if p13 then
        t19.Tint(clone, p13)
    end

    local v17 = v4

    if not (v17 and v17.Parent) then
        v17 = Instance.new("Folder")
        v17.Name = "CursedIslandWarsFx"
        v17.Parent = Workspace
        v4 = v17
    end

    clone.Parent = v17

    return clone
end

function t19.Welded(p14, p15, p16, p17) -- line: 170
    -- upvalues: t19 (copy)
    local clone = p14:Clone()

    clone:PivotTo(p16 or p15.CFrame)

    if p17 then
        t19.Tint(clone, p17)
    end

    local Root = clone.Root

    Root.Anchored = false

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = Root
    WeldConstraint.Part1 = p15
    WeldConstraint.Parent = Root
    clone.Parent = p15

    return clone
end

function t19.Once(p18, p19, p20, p21, p22) -- line: 186
    -- upvalues: Debris (copy), t19 (copy)
    local v18 = t19.Anchored(p18, p20, p22)

    for _, v19 in p19 do
        t19.Burst(v18, v19)
    end

    Debris:AddItem(v18, p21 + 0.3)

    return v18
end

function t19.Sound(p23, p24, p25, p26) -- line: 195
    -- upvalues: Audio (copy)
    Audio.Play(p23, p24, {
        PlaybackSpeed = p25,
        Volume = p26
    })
end

function t19.Ui(p27, p28, p29) -- line: 199
    -- upvalues: Workspace (copy), Audio (copy)
    Audio.Play(p27, Workspace.CurrentCamera, {
        PlaybackSpeed = p28,
        Volume = p29
    })
end

local function teamColor(p30) -- line: 203
    -- upvalues: CursedIslandWars (copy)
    return CursedIslandWars.Teams[p30].FxColor
end

local function fling(p31, p32, p33) -- line: 207
    -- upvalues: Debris (copy), TweenService (copy), Workspace (copy), v4 (ref), v11 (copy)
    p31.Anchored = false
    p31.CanCollide = false
    p31.CanQuery = false
    p31.CanTouch = false

    local v20 = v4

    if not (v20 and v20.Parent) then
        v20 = Instance.new("Folder")
        v20.Name = "CursedIslandWarsFx"
        v20.Parent = Workspace
        v4 = v20
    end

    p31.Parent = v20
    p31.AssemblyLinearVelocity = p32
    p31.AssemblyAngularVelocity = v11:NextUnitVector() * 10
    TweenService:Create(p31, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, p33 - 0.4), {
        Transparency = 1
    }):Play()
    Debris:AddItem(p31, p33)
end

local function neon(p34, p35, p36, p37) -- line: 221
    -- upvalues: Workspace (copy), v4 (ref)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = p37
    Part.Size = p34
    Part.CFrame = p35
    Part.Transparency = p36
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v21 = v4

    if not (v21 and v21.Parent) then
        v21 = Instance.new("Folder")
        v21.Name = "CursedIslandWarsFx"
        v21.Parent = Workspace
        v4 = v21
    end

    Part.Parent = v21

    return Part
end

local function ripple(p38, p39, p40, p41, p42) -- line: 238
    -- upvalues: Debris (copy), TweenService (copy), Workspace (copy), v4 (ref)
    local v22 = Vector3.new(0.2, p40, p40)
    local v23 = p38 * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = p39
    Part.Size = v22
    Part.CFrame = v23
    Part.Transparency = 0.3
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v24 = v4

    if not (v24 and v24.Parent) then
        v24 = Instance.new("Folder")
        v24.Name = "CursedIslandWarsFx"
        v24.Parent = Workspace
        v4 = v24
    end

    Part.Parent = v24
    Part.Shape = Enum.PartType.Cylinder
    TweenService:Create(Part, TweenInfo.new(p42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.2, p41, p41)
    }):Play()
    Debris:AddItem(Part, p42)
end

function t19.Launch(p43, p44, p45, p46, p47) -- line: 250
    -- upvalues: Workspace (copy), CursedIslandWars (copy), Assets (copy), VFX (copy), Sounds (copy), v4 (ref), t3 (copy), t19 (copy)
    local clone = Assets.Projectiles.Pumpkin:Clone()

    clone:PivotTo(CFrame.lookAt(p44, p44 + p45))

    local v25 = v4

    if not (v25 and v25.Parent) then
        v25 = Instance.new("Folder")
        v25.Name = "CursedIslandWarsFx"
        v25.Parent = Workspace
        v4 = v25
    end

    clone.Parent = v25

    local Body = clone.Body
    local v26 = t19.Welded(VFX.V4_PumpkinTrail, Body, Body.Trail.WorldCFrame, CursedIslandWars.Teams[p47].FxColor)

    t19.Loop(v26, "Trail", true)
    t3[p43] = {
        Model = clone,
        Position = p44,
        Velocity = p45,
        Stepped = p46,
        Launched = p46
    }
    t19.Sound(Sounds.ScrambleBoss.Swoosh, p44, 0.7, 1)
end

function t19.Lock(p48, p49, p50) -- line: 262
    -- upvalues: t3 (copy)
    local v27 = t3[p48]

    if v27 then
        v27.Velocity = p49
        v27.Target = p50
    end
end

function t19.Land(p51) -- line: 270
    -- upvalues: t3 (copy)
    local v28 = t3[p51]

    t3[p51] = nil

    if v28 then
        v28.Model:Destroy()
    end
end

local function stepFlights() -- line: 278
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsFlags (copy), State (copy), t3 (copy), t19 (copy)
    local v29 = State.Now()
    local v30 = CursedIslandWarsFlags.LauncherRange:Get() / CursedIslandWarsFlags.LauncherSpeed:Get()
    local v32 = math.rad((CursedIslandWarsFlags.LauncherTurnRate:Get()))

    for v33, v34 in t3 do
        local v35 = v29 - v34.Launched

        if v30 + 0.5 < v35 then
            t19.Land(v33)
        else
            local v36 = v29 - v34.Stepped

            if v36 > 0 then
                v34.Stepped = v29
                v34.Position += v34.Velocity * v36

                local Target = v34.Target

                if Target and Target.Parent then
                    v34.Velocity = CursedIslandWars.Steer(v34.Velocity, v34.Position, Target.Position, v32 * v36)
                end
            end

            v34.Model:PivotTo(CFrame.lookAt(v34.Position, v34.Position + v34.Velocity) * CFrame.Angles(0, 0, v35 * 9))
        end
    end
end

local function scaleFx(p52, p53) -- line: 302
    for _, descendant in p52:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local t21 = {}

            for _, v37 in descendant.Size.Keypoints do
                table.insert(t21, NumberSequenceKeypoint.new(v37.Time, v37.Value * p53, v37.Envelope * p53))
            end

            descendant.Size = NumberSequence.new(t21)
            descendant.Speed = NumberRange.new(descendant.Speed.Min * p53, descendant.Speed.Max * p53)
        elseif descendant:IsA("BasePart") then
            descendant.Size *= p53
        end
    end
end

function t19.Explode(p54, p55) -- line: 317
    -- upvalues: Debris (copy), CursedIslandWarsFlags (copy), VFX (copy), Sounds (copy), v11 (copy), t19 (copy), scaleFx (copy)
    if p54 ~= "Pumpkin" then
        t19.Once(VFX.V5_Landmine, { "Burst", "Linger" }, CFrame.new(p55), 2.2)
        t19.Sound(Sounds.Explosion, p55, v11:NextNumber(0.95, 1.05), 1)

        return
    end

    local v40 = t19.Anchored(VFX.V4_PumpkinImpact, CFrame.new(p55))

    scaleFx(v40, CursedIslandWarsFlags.LauncherRadius:Get() / 8)
    t19.Burst(v40, "Impact")
    Debris:AddItem(v40, 1.1)
    t19.Sound(Sounds.ImpactBoom, p55, v11:NextNumber(1.25, 1.45), 0.6)
end

function t19.Mine(p56, p57) -- line: 332
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsFlags (copy), VFX (copy), Sounds (copy), t10 (copy), t19 (copy)
    if p56 == nil then
        return
    end

    local Body = p56.Body
    local WorldCFrame = Body.Base.WorldCFrame
    local FxColor = CursedIslandWars.Teams[p57].FxColor

    t19.Once(VFX.V5_Landmine, { "Arm" }, WorldCFrame, 0.7, FxColor)
    t19.Sound(Sounds.ScrambleBoss.Tick, Body, 1.3, 0.8)

    local v41 = t19.Welded(VFX.V5_Landmine, Body, WorldCFrame, FxColor)

    t10[p56] = {
        Tripped = false,
        Fx = v41,
        Glow = p56.Glow
    }
    task.delay(CursedIslandWarsFlags.MineArmSeconds:Get(), function() -- line: 343
        -- upvalues: p56 (copy), v41 (copy), t10 (copy), t19 (copy)
        local v42 = t10[p56]

        if v42 and v42.Fx == v41 and not v42.Tripped then
            t19.Loop(v41, "Armed", true)
        end
    end)
end

function t19.MineTrigger(p58) -- line: 351
    -- upvalues: Sounds (copy), t10 (copy), t19 (copy)
    local v43 = if p58 then t10[p58] else nil

    if v43 == nil then
        return
    end

    v43.Tripped = true
    t19.Loop(v43.Fx, "Armed", false, true)
    t19.Burst(v43.Fx, "Trigger")
    t19.Sound(Sounds.ScrambleBoss.TargetLock, v43.Glow, 1.2, 1)
end

local function stepMines() -- line: 363
    -- upvalues: t10 (copy)
    local elapsed = os.clock()

    for v44, v45 in t10 do
        if v44.Parent ~= nil then
            v45.Glow.Transparency = math.sin(elapsed * (if v45.Tripped then 40 else 5)) > 0 and 0 or 0.7
        else
            t10[v44] = nil
        end
    end
end

function t19.Built(p59, p60) -- line: 376
    -- upvalues: CursedIslandWars (copy), VFX (copy), Sounds (copy), v11 (copy), t19 (copy)
    for v47, v48 in p59 do
        t19.Once(VFX.V6_Brick, { "Build" }, v48, 0.9, CursedIslandWars.Teams[p60].FxColor)

        if v47 == 1 then
            t19.Sound(Sounds.ScrambleBoss.Pop, v48, v11:NextNumber(1.3, 1.6), 0.7)
        end
    end
end

function t19.Bricks(p61) -- line: 385
    -- upvalues: Assets (copy), VFX (copy), Sounds (copy), n1 (ref), v11 (copy), t19 (copy), fling (copy)
    local v49 = false

    for _, v50 in p61 do
        local v51 = v50[1]
        local v52 = v50[2]

        if v51 == "Crack" then
            t19.Once(VFX.V6_Brick, { "Crack" }, v52, 0.9)
        else
            t19.Once(VFX.V6_Brick, { "Break" }, v52, 0.9)

            if not v49 then
                v49 = true
                t19.Sound(Sounds.BeanstalkEvent.WhaleRockHit, v52, v11:NextNumber(1.1, 1.3), 0.8)
            end

            for _, child in Assets.BrickDebris:GetChildren() do
                if n1 >= 80 then
                    break
                end

                n1 += 1

                local clone = child:Clone()

                clone.CFrame = v52 * CFrame.new(v11:NextNumber(-1, 1), v11:NextNumber(-1, 1), v11:NextNumber(-1, 1))
                fling(clone, (v11:NextUnitVector() + Vector3.new(0, 1, 0)) * v11:NextNumber(18, 32), 2.2)
                task.delay(2.2, function() -- line: 406
                    -- upvalues: n1 (ref)
                    n1 -= 1
                end)
            end
        end
    end
end

function t19.Pad(p62, p63) -- line: 415
    -- upvalues: CursedIslandWars (copy), VFX (copy), v3 (ref), t9 (copy), t19 (copy)
    if p62 == nil then
        return
    end

    local Base = p62.Base
    local v53 = t19.Welded(VFX.V7_JumpPad, Base, Base.Launch.WorldCFrame, CursedIslandWars.Teams[p63].FxColor)

    t19.Loop(v53, "Loop", true)
    t9[p62] = v53
    v3:Add(p62.Destroying:Connect(function() -- line: 423
        -- upvalues: p62 (copy), t9 (copy)
        t9[p62] = nil
    end))
end

function t19.PadLaunch(p64, p65, p66) -- line: 428
    -- upvalues: Debris (copy), TweenService (copy), CursedIslandWars (copy), VFX (copy), Sounds (copy), t9 (copy), v11 (copy), t19 (copy)
    if p64 == nil then
        return
    end

    local v55 = t9[p64]

    if v55 then
        t19.Burst(v55, "Launch")
    end

    local Plate = p64.Plate
    local v56 = p64:GetPivot().UpVector * -0.25

    for _, v57 in {
            Plate,
            p64.Chevrons
        } do
        local CFrame = v57.CFrame

        v57.CFrame = CFrame + v56
        TweenService:Create(v57, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            CFrame = CFrame
        }):Play()
    end

    t19.Sound(Sounds.BeanstalkEvent.TrampolineJump, Plate, v11:NextNumber(0.95, 1.1), 1)

    local HumanoidRootPart = if p65 then p65:FindFirstChild("HumanoidRootPart") else nil

    if not HumanoidRootPart then
        return
    end

    local v58 = t19.Welded(VFX.V7_Airborne, HumanoidRootPart, nil, CursedIslandWars.Teams[p66].FxColor)

    t19.Loop(v58, "Airborne", true)
    task.delay(2.4, function() -- line: 448
        -- upvalues: v58 (copy), Debris (copy), t19 (copy)
        t19.Loop(v58, "Airborne", false)
        Debris:AddItem(v58, 0.5)
    end)
end

function t19.PadLand(p67) -- line: 455
    -- upvalues: VFX (copy), Sounds (copy), t19 (copy)
    t19.Once(VFX.V7_JumpPad, { "Land" }, CFrame.new(p67), 1)
    t19.Sound(Sounds.ScrambleBoss.HeavyLand, p67, 1.3, 0.4)
end

function t19.Hit(p68) -- line: 462
    -- upvalues: VFX (copy), Sounds (copy), v11 (copy), t19 (copy)
    local HumanoidRootPart = if p68 then p68:FindFirstChild("HumanoidRootPart") else nil

    if HumanoidRootPart then
        t19.Once(VFX.V9_PlayerFX, { "HitSpark" }, HumanoidRootPart.CFrame, 0.95)
        t19.Sound(Sounds.ScrambleBoss.BatHit, HumanoidRootPart, v11:NextNumber(1.1, 1.3), 0.6)
    end
end

function t19.Knockout(p69) -- line: 470
    -- upvalues: VFX (copy), Sounds (copy), t19 (copy)
    if p69 then
        t19.Once(VFX.V9_PlayerFX, { "Knockout" }, CFrame.new(p69), 0.95)
        t19.Sound(Sounds.ScrambleBoss.Swoosh, p69, 0.55, 1.2)
    end
end

function t19.EndShield(p70) -- line: 477
    -- upvalues: Debris (copy), t7 (copy), t19 (copy)
    local v59 = t7[p70]

    t7[p70] = nil

    if v59 then
        t19.Loop(v59, "Shell", false, true)
        Debris:AddItem(v59, 0.5)
    end
end

function t19.Respawn(p71, p72, p73, p74) -- line: 486
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsFlags (copy), VFX (copy), Sounds (copy), t7 (copy), t19 (copy)
    t19.Once(VFX.V10_RespawnBurst, { "Burst" }, p72 * CFrame.new(0, -4, 0), 0.9, CursedIslandWars.Teams[p74].FxColor)
    t19.Sound(Sounds.MountRace.Respawn, p72.Position, 1, 0.8)

    local HumanoidRootPart = if p73 then p73:FindFirstChild("HumanoidRootPart") else nil

    if HumanoidRootPart == nil then
        return
    end

    t19.EndShield(p71)

    local v60 = t19.Welded(VFX.V10_SpawnShell, HumanoidRootPart, nil, CursedIslandWars.Teams[p74].FxColor)

    t19.Loop(v60, "Shell", true)
    t7[p71] = v60
    task.delay(CursedIslandWarsFlags.SpawnShieldSeconds:Get(), function() -- line: 497
        -- upvalues: p71 (copy), v60 (copy), t7 (copy), t19 (copy)
        if t7[p71] == v60 then
            t19.EndShield(p71)
        end
    end)
end

local function refreshSkulls() -- line: 504
    -- upvalues: State (copy), VFX (copy), t8 (copy), t19 (copy)
    local Snapshot = State.Snapshot
    local t22 = {}

    if Snapshot then
        for _, v61 in Snapshot.Entries do
            local v62 = Snapshot.Crystals[v61.Team]

            if v61.State == "Alive" and v62 and v62.Health <= 0 and v61.Model then
                t22[v61.Id] = v61.Model
            end
        end
    end

    for v63, v64 in t8 do
        local v65 = t22[v63]

        if v65 == nil or v64.Parent == nil or not v64:IsDescendantOf(v65) then
            v64:Destroy()
            t8[v63] = nil
        end
    end

    for v66, v67 in t22 do
        local HumanoidRootPart = v67:FindFirstChild("HumanoidRootPart")

        if t8[v66] == nil and HumanoidRootPart then
            local v68 = t19.Welded(VFX.V9_PlayerFX, HumanoidRootPart)

            t19.Loop(v68, "LastLife", true)
            t8[v66] = v68
        end
    end
end

local function mountCrystal(p75, p76) -- line: 534
    -- upvalues: CursedIslandWars (copy), VFX (copy), t4 (copy), v7 (ref), t19 (copy)
    local v69 = t4[p75]

    if v69 and v69.Model == p76 then
        return
    end

    local Pivot = p76.Crystal.Pivot
    local v70 = t19.Welded(VFX.V8_CursedCrystal, Pivot, Pivot.CFrame, CursedIslandWars.Teams[p75].FxColor)

    t19.Loop(v70, "Loop", true)
    t19.Loop(v70, "Pillar", v7)
    t4[p75] = {
        Model = p76,
        Pivot = Pivot,
        Base = Pivot.CFrame,
        Fx = v70
    }
end

function t19.Pillars(p77) -- line: 546
    -- upvalues: t4 (copy), v7 (ref), t19 (copy)
    if v7 == p77 then
        return
    end

    v7 = p77

    for _, v71 in t4 do
        t19.Loop(v71.Fx, "Pillar", p77)
    end
end

local function stepCrystals() -- line: 556
    -- upvalues: t4 (copy)
    local elapsed = os.clock()

    for _, v72 in t4 do
        if v72.Pivot.Parent then
            v72.Pivot.CFrame = v72.Base * CFrame.new(0, math.sin(elapsed * 1.4) * 0.6, 0) * CFrame.Angles(0, elapsed * 0.5, 0)
        end
    end
end

function t19.CrystalHit(p78, p79) -- line: 565
    -- upvalues: Sounds (copy), t4 (copy), t19 (copy)
    local v74 = t4[p78]

    if v74 ~= nil then
        t19.Burst(v74.Fx, "Hit")
        t19.Sound(Sounds.ScrambleBoss.GlassCrack, v74.Pivot, p79 * 0.7 + 0.8, 0.35)
    end
end

function t19.CrystalStage(p80, p81) -- line: 574
    -- upvalues: CursedIslandWars (copy), Sounds (copy), t4 (copy), v11 (copy), t19 (copy), fling (copy)
    local v75 = t4[p80]

    if v75 == nil then
        return
    end

    t19.Burst(v75.Fx, "Stage")

    local v76 = CursedIslandWars.Tuning.Crystal.Stages[p81]
    local v78 = v75.Model.Crystal.Shell:FindFirstChild((("Chunk%*"):format((math.floor(v76 * 100)))))

    if v78 then
        local clone = v78:Clone()

        clone:ClearAllChildren()
        clone.Transparency = 0.3
        fling(clone, (v11:NextUnitVector() + Vector3.new(0, 1.5, 0)) * 25, 2.5)
    end

    t19.Sound(Sounds.BossEventSounds["Crystal Break SFX"], v75.Pivot, 1.3, 0.5)
end

function t19.CrystalShattered(p82) -- line: 591
    -- upvalues: Sounds (copy), t4 (copy), v11 (copy), t19 (copy), fling (copy)
    local v79 = t4[p82]

    if v79 == nil then
        return
    end

    t4[p82] = nil
    t19.Loop(v79.Fx, "Loop", false, true)
    t19.Loop(v79.Fx, "Pillar", false)
    t19.Burst(v79.Fx, "Implode")
    task.delay(0.32, function() -- line: 600
        -- upvalues: v79 (copy), Sounds (copy), v11 (copy), t19 (copy), fling (copy)
        t19.Burst(v79.Fx, "Shatter")
        t19.Loop(v79.Fx, "Dead", true)
        t19.Sound(Sounds.BossEventSounds["Crystal Break SFX"], v79.Pivot, 0.9, 1)
        t19.Sound(Sounds.CinematicBoom, v79.Pivot, 1, 4)

        for _, descendant in v79.Model.Crystal:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant.Name == "Core" or descendant.Parent and descendant.Parent.Name == "Shell") then
                local clone = descendant:Clone()

                clone:ClearAllChildren()
                clone.Transparency = descendant.Name == "Core" and 0 or 0.3

                local v80 = descendant.Position - v79.Pivot.Position

                fling(clone, ((if v80.Magnitude > 0.1 then v80.Unit else v11:NextUnitVector()) + Vector3.new(0, 0.6, 0)) * v11:NextNumber(40, 70), 2.5)
            end
        end
    end)
end

local function upright(p83) -- line: 621
    return CFrame.new(p83) * CFrame.Angles(0, 0, 1.5707963267948966)
end

function t19.PickupDrop(p84, p85) -- line: 625
    -- upvalues: Debris (copy), TweenService (copy), Workspace (copy), VFX (copy), Sounds (copy), t1 (copy), v4 (ref), t19 (copy), ripple (copy)
    if p85 == nil then
        return
    end

    local v82 = t1[p84]
    local Position = p85:GetPivot().Position
    local v83 = Position + Vector3.new(0, 120, 0)
    local v84 = CFrame.new(v83) * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = v82
    Part.Size = Vector3.new(80, 6, 6)
    Part.CFrame = v84
    Part.Transparency = 0.1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v85 = v4

    if not (v85 and v85.Parent) then
        v85 = Instance.new("Folder")
        v85.Name = "CursedIslandWarsFx"
        v85.Parent = Workspace
        v4 = v85
    end

    Part.Parent = v85
    Part.Shape = Enum.PartType.Cylinder

    local v86 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v87 = Position + Vector3.new(0, 40, 0)

    TweenService:Create(Part, v86, {
        CFrame = CFrame.new(v87) * CFrame.Angles(0, 0, 1.5707963267948966)
    }):Play()
    task.delay(0.22, function() -- line: 636
        -- upvalues: v82 (copy), Position (copy), Part (copy), TweenService (copy), VFX (copy), Sounds (copy), t19 (copy), ripple (copy)
        TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(80, 0.2, 0.2),
            Transparency = 1
        }):Play()
        ripple(CFrame.new(Position - Vector3.new(0, 2.5, 0)), v82, 4, 30, 0.6)
        t19.Once(VFX.V10_RespawnBurst, { "Burst" }, CFrame.new(Position), 1.5, v82)
        t19.Sound(Sounds.ScrambleBoss.Pop, Position, 0.8, 1)
    end)
    Debris:AddItem(Part, 0.7)
end

function t19.PickupTaken(p86, p87) -- line: 648
    -- upvalues: Debris (copy), TweenService (copy), Workspace (copy), VFX (copy), Sounds (copy), t1 (copy), v4 (ref), t19 (copy), ripple (copy)
    local v88 = t1[p86]

    ripple(CFrame.new(p87 - Vector3.new(0, 2.5, 0)), v88, 4, 22, 0.45)

    local v89 = p87 + Vector3.new(0, 12, 0)
    local v90 = CFrame.new(v89) * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = v88
    Part.Size = Vector3.new(30, 5, 5)
    Part.CFrame = v90
    Part.Transparency = 0.2
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v91 = v4

    if not (v91 and v91.Parent) then
        v91 = Instance.new("Folder")
        v91.Name = "CursedIslandWarsFx"
        v91.Parent = Workspace
        v4 = v91
    end

    Part.Parent = v91
    Part.Shape = Enum.PartType.Cylinder
    TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(30, 0.2, 0.2),
        Transparency = 1
    }):Play()
    Debris:AddItem(Part, 0.4)
    t19.Once(VFX.V7_JumpPad, { "Land" }, CFrame.new(p87), 1)
    t19.Sound(Sounds.ScrambleBoss.Pop, p87, 1.4, 0.8)
end

local function mountPickup(p88, p89) -- line: 662
    -- upvalues: TweenService (copy), Workspace (copy), CursedIslandWars (copy), State (copy), UI (copy), t1 (copy), v4 (ref)
    local v92 = t1[p88.Name]
    local v93 = RaycastParams.new()

    v93.FilterType = Enum.RaycastFilterType.Include
    v93.FilterDescendantsInstances = { (State.Island()) }

    local v94 = Workspace:Raycast(p89.Position, Vector3.new(-0, -12, -0, -0), v93)
    local v95 = CFrame.new(if v94 then v94.Position else p89.Position - Vector3.new(0, 3, 0))
    local Model = Instance.new("Model")

    Model.Name = ("%*Look"):format(p88.Name)

    local v96 = v4

    if not (v96 and v96.Parent) then
        v96 = Instance.new("Folder")
        v96.Name = "CursedIslandWarsFx"
        v96.Parent = Workspace
        v4 = v96
    end

    Model.Parent = v96

    local v97 = v95.Position + Vector3.new(0, 18, 0)
    local v98 = CFrame.new(v97) * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = v92
    Part.Size = Vector3.new(36, 0.8, 0.8)
    Part.CFrame = v98
    Part.Transparency = 0.6
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v99 = v4

    if not (v99 and v99.Parent) then
        v99 = Instance.new("Folder")
        v99.Name = "CursedIslandWarsFx"
        v99.Parent = Workspace
        v4 = v99
    end

    Part.Parent = v99
    Part.Shape = Enum.PartType.Cylinder
    Part.Parent = Model
    TweenService:Create(Part, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.85
    }):Play()

    local v100 = v95.Position + Vector3.new(0, 0.15, 0)
    local v101 = CFrame.new(v100) * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part2 = Instance.new("Part")

    Part2.Material = Enum.Material.Neon
    Part2.Color = v92
    Part2.Size = Vector3.new(0.2, 9, 9)
    Part2.CFrame = v101
    Part2.Transparency = 0.55
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false

    local v102 = v4

    if not (v102 and v102.Parent) then
        v102 = Instance.new("Folder")
        v102.Name = "CursedIslandWarsFx"
        v102.Parent = Workspace
        v4 = v102
    end

    Part2.Parent = v102
    Part2.Shape = Enum.PartType.Cylinder
    Part2.Parent = Model

    local t24 = {}

    for i = 1, 6 do
        local Part = Instance.new("Part")

        Part.Material = Enum.Material.Neon
        Part.Color = v92
        Part.Size = Vector3.new(1.4, 0.3, 0.5)
        Part.CFrame = v95
        Part.Transparency = 0.1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false

        local v103 = v4

        if not (v103 and v103.Parent) then
            v103 = Instance.new("Folder")
            v103.Name = "CursedIslandWarsFx"
            v103.Parent = Workspace
            v4 = v103
        end

        Part.Parent = v103
        Part.Parent = Model
        t24[i] = Part
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part2
    Attachment.WorldPosition = p89.Position + Vector3.new(0, 1, 0) * (p88:GetExtentsSize().Y / 2 + 5)

    local clone = UI.PickupMarker:Clone()

    clone.Title.Text = string.upper(CursedIslandWars.ToolNames[p88.Name])
    clone.Title.TextColor3 = v92
    clone.Adornee = Attachment
    clone.Parent = Attachment

    local Highlight = Instance.new("Highlight")

    Highlight.Adornee = p88
    Highlight.FillColor = v92
    Highlight.FillTransparency = 0.55
    Highlight.OutlineColor = v92
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Parent = Model

    return {
        NextRipple = 0,
        Look = Model,
        Ground = v95,
        Marks = t24,
        Color = v92
    }
end

local function stepPickups() -- line: 705
    -- upvalues: State (copy), self (copy), t16 (copy), self2 (copy), ripple (copy), mountPickup (copy)
    for v104, v105 in t16 do
        if v104.Parent == nil or self2[v104] then
            t16[v104] = nil
            v105.Look:Destroy()
        end
    end

    local v106 = State.Island()
    local Pickups = if not (v106 and v106.Parent) then nil else v106.Parent:FindFirstChild("Pickups")

    if Pickups ~= nil then
        local elapsed = os.clock()

        for _, child in Pickups:GetChildren() do
            if child:IsA("Model") and not self2[child] then
                local v107 = self[child]

                if v107 == nil then
                    v107 = child:GetPivot()
                    self[child] = v107
                end

                child:PivotTo(v107 * CFrame.new(0, math.sin(elapsed * 2 + v107.X) * 0.6, 0) * CFrame.Angles(0, elapsed * 1.5, 0))

                local v109 = t16[child]

                if v109 == nil then
                    v109 = mountPickup(child, v107)
                    t16[child] = v109
                end

                for v110, v111 in v109.Marks do
                    local v112 = elapsed * 2 + v110 * 3.141592653589793 * 2 / #v109.Marks

                    v111.CFrame = v109.Ground * CFrame.Angles(0, v112, 0) * CFrame.new(5.3, 0.3, 0)
                end

                if v109.NextRipple <= elapsed then
                    v109.NextRipple = elapsed + 1.2
                    ripple(v109.Ground * CFrame.new(0, 0.2, 0), v109.Color, 9, 21.599999999999998, 1.2)
                end
            end
        end
    end
end

local function mountBarrier(p90, p91, p92) -- line: 746
    -- upvalues: CursedIslandWars (copy), VFX (copy), t5 (copy), t19 (copy)
    local v113 = t5[p90]

    if v113 and v113.Model == p91 then
        return
    end

    local v114 = t19.Anchored(VFX.V13_CrystalBarrier, p91:GetPivot(), CursedIslandWars.Teams[p90].FxColor)

    t19.Loop(v114, "Loop", true)

    local v115 = p92 <= 0.25

    t19.Loop(v114, "Unstable", v115)
    t5[p90] = {
        Model = p91,
        Fx = v114,
        Unstable = v115
    }
end

function t19.BarrierHit(p93, p94, p95) -- line: 758
    -- upvalues: Sounds (copy), t5 (copy), t19 (copy), holders (copy)
    local v116 = t5[p93]

    if v116 == nil then
        return
    end

    holders(v116.Fx, "Hit")[1].WorldPosition = p95
    t19.Burst(v116.Fx, "Hit")

    if p94 <= 0.25 and not v116.Unstable then
        v116.Unstable = true
        t19.Loop(v116.Fx, "Unstable", true)
    end

    t19.Sound(Sounds.ScrambleBoss.GlassCrack, p95, p94 * 0.4 + 1, 0.4)
end

function t19.BarrierStage(p96, p97) -- line: 772
    -- upvalues: Sounds (copy), t5 (copy), t19 (copy)
    local v117 = t5[p96]

    if v117 ~= nil then
        t19.Burst(v117.Fx, (("Break%*"):format(p97)))
        t19.Sound(Sounds.BossEventSounds["Crystal Break SFX"], v117.Model.Hitbox, 1.1, 0.6)
    end
end

function t19.BarrierBroken(p98) -- line: 781
    -- upvalues: Debris (copy), Sounds (copy), t5 (copy), t19 (copy)
    local v118 = t5[p98]

    if v118 == nil then
        return
    end

    t5[p98] = nil
    t19.Loop(v118.Fx, "Loop", false, true)
    t19.Loop(v118.Fx, "Unstable", false, true)
    t19.Burst(v118.Fx, "Shatter")
    Debris:AddItem(v118.Fx, 4)

    local Hitbox = v118.Model.Hitbox

    t19.Sound(Sounds.CinematicBoom, Hitbox, 1.1, 3)
    t19.Sound(Sounds.ScrambleBoss.GlassCrack, Hitbox, 0.7, 2)
end

local function eyes() -- line: 798
    -- upvalues: State (copy)
    local v119 = State.Island()
    local Parent = if v119 then v119.Parent else nil
    local Pieces = if Parent then Parent:FindFirstChild("Pieces") else nil

    return if Pieces then Pieces:FindFirstChild("SkyEyes") else nil
end

local function portalCrack(p99) -- line: 805
    return p99.Cloud.Crack
end

local function showFace(p100, p101) -- line: 809
    local n4 = 0

    for _, child in p100.Cloud.Crack[p101]:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(1)
            n4 = math.max(n4, child.Lifetime.Max)
        end
    end

    return n4
end

local function clearFace(p102) -- line: 820
    local Crack = p102.Cloud.Crack

    for _, v120 in {
            Crack.EYES,
            Crack.EYES2
        } do
        for _, child in v120:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Clear()
            end
        end
    end
end

local function burstCrack(p103) -- line: 831
    for _, child in p103.Cloud.Crack:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 1)
        end
    end
end

local function setPortal(p104, p105) -- line: 839
    -- upvalues: clearFace (copy)
    local Crack = p104.Cloud.Crack

    for _, v121 in {
            Crack,
            Crack.Portal
        } do
        for _, child in v121:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child.Enabled = p105
            end
        end
    end

    if not p105 then
        clearFace(p104)
    end
end

local function getSkyPortalTemplate() -- line: 854
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage.CutsceneAssets.CursedIslandWarsCutsceneAssets.IntroCutscene.CursedIntroVFX.Crack.Cloud
end

local function mountPortal(p106) -- line: 858
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), v4 (ref), setPortal (copy)
    for _, descendant in p106:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end

    local Pivot = p106:GetPivot()
    local Model = Instance.new("Model")

    Model.Name = "SkyPortal"

    local clone = ReplicatedStorage.CutsceneAssets.CursedIslandWarsCutsceneAssets.IntroCutscene.CursedIntroVFX.Crack.Cloud:Clone()

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false

    for _, child in clone:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Destroy()
        end
    end

    local Crack = clone.Crack

    for _, v122 in {
            Crack.EYES,
            Crack.EYES2
        } do
        for _, child in v122:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child.Orientation = Enum.ParticleOrientation.FacingCamera
            end
        end
    end

    clone.CFrame = Pivot * clone.CFrame:ToObjectSpace(Crack.Portal.WorldCFrame):Inverse()
    clone.Parent = Model
    Model.WorldPivot = Pivot
    Model:ScaleTo(1.8)
    setPortal(Model, false)

    local v123 = v4

    if not (v123 and v123.Parent) then
        v123 = Instance.new("Folder")
        v123.Name = "CursedIslandWarsFx"
        v123.Parent = Workspace
        v4 = v123
    end

    Model.Parent = v123

    return Model
end

function t19.Eyes(p107) -- line: 894
    -- upvalues: v9 (ref), v10 (ref), n2 (ref), n3 (ref), showFace (copy), clearFace (copy), burstCrack (copy), setPortal (copy)
    local v124 = v10

    v10 = p107 ~= "Closed"

    local v125 = v9

    if v125 ~= nil then
        if v10 then
            if not v124 then
                setPortal(v125, true)
                burstCrack(v125)
                n2 = 0
            end

            local elapsed = os.clock()

            if p107 == "Flare" or p107 == "Narrow" and n3 <= elapsed then
                clearFace(v125)
                n2 = elapsed + showFace(v125, "EYES")
                n3 = n2 + 6

                if p107 == "Flare" then
                    burstCrack(v125)
                end
            end
        else
            setPortal(v125, false)
        end
    end
end

local function stepEyes() -- line: 921
    -- upvalues: v9 (ref), v10 (ref), n2 (ref), showFace (copy)
    local v126 = v9

    if v126 ~= nil and v10 then
        local elapsed = os.clock()

        if n2 <= elapsed then
            n2 = elapsed + showFace(v126, "EYES2")
        end
    end
end

function t19.WallsOpen(p108) -- line: 935
    -- upvalues: Debris (copy), RunService (copy), TweenService (copy), Workspace (copy), VFX (copy), Sounds (copy), v1 (copy), v3 (ref), v4 (ref), v11 (copy), t19 (copy), fling (copy)
    local Collision = p108.Collision
    local t25 = {}

    for _, child in p108:GetChildren() do
        if child:IsA("BasePart") and child.Transparency < 1 then
            t25[child] = child.Transparency
        end
    end

    local _CFrame, Size = Collision.CFrame, Collision.Size
    local v127 = Vector3.new(0.4, Size.Y, Size.Z)
    local Part = Instance.new("Part")

    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Size = v127
    Part.CFrame = _CFrame
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    local v128 = v4

    if not (v128 and v128.Parent) then
        v128 = Instance.new("Folder")
        v128.Name = "CursedIslandWarsFx"
        v128.Parent = Workspace
        v4 = v128
    end

    Part.Parent = v128
    TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 0.25
    }):Play()
    t19.Sound(Sounds.ScrambleBoss.Rumble, Collision, 1.6, 1.5)

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 949
        -- upvalues: t25 (copy), elapsed (copy), connection (ref), v11 (copy)
        local v129 = os.clock() - elapsed >= 0.4

        for v130, v131 in t25 do
            if v129 then
                v130.Transparency = 1
            elseif v11:NextNumber() < 0.5 then
                v130.Transparency = v131
            else
                v130.Transparency = 0.85
            end
        end

        if v129 then
            connection:Disconnect()
        end
    end)
    v3:Add(connection)
    task.delay(0.4, function() -- line: 959
        -- upvalues: Collision (copy), _CFrame (copy), Size (copy), Part (copy), Debris (copy), TweenService (copy), Workspace (copy), VFX (copy), Sounds (copy), v1 (copy), v4 (ref), v11 (copy), t19 (copy), fling (copy)
        TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(14, Size.Y * 1.05, Size.Z)
        }):Play()
        Debris:AddItem(Part, 0.4)

        local v134 = Size.Y / 4
        local v135 = Size.Z / 24

        for i = 1, 4 do
            for j = 1, 24 do
                local v138 = Vector3.new(0, (i - 0.5) * v134 - Size.Y / 2, (j - 0.5) * v135 - Size.Z / 2)
                local v141 = Vector3.new(0.3, v134 * v11:NextNumber(0.4, 0.8), v135 * v11:NextNumber(0.4, 0.8))
                local v142 = _CFrame * CFrame.new(v138) * CFrame.Angles(v11:NextNumber(-0.6, 0.6), 0, v11:NextNumber(-0.6, 0.6))
                local Part = Instance.new("Part")

                Part.Material = Enum.Material.Neon
                Part.Color = v1
                Part.Size = v141
                Part.CFrame = v142
                Part.Transparency = 0.2
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false

                local v143 = v4

                if not (v143 and v143.Parent) then
                    v143 = Instance.new("Folder")
                    v143.Name = "CursedIslandWarsFx"
                    v143.Parent = Workspace
                    v4 = v143
                end

                Part.Parent = v143
                fling(Part, _CFrame.RightVector * (if v11:NextNumber() < 0.5 then 1 else -1) * v11:NextNumber(30, 70) + Vector3.new(0, 1, 0) * v11:NextNumber(5, 30), v11:NextNumber(1, 1.6))
            end
        end

        for i = 1, 5 do
            local v145 = (i / 6 - 0.5) * Size.Z

            t19.Once(VFX.V3_RulesWall, { "Burst" }, _CFrame * CFrame.new(0, 0, v145) * CFrame.Angles(0, 1.5707963267948966, 0), 0.9)
        end

        local v146 = _CFrame.Position - Vector3.new(0, 1, 0) * (Size.Y / 2 - 0.4)
        local v147 = CFrame.new(v146) * CFrame.Angles(0, 0, 1.5707963267948966)
        local Part2 = Instance.new("Part")

        Part2.Material = Enum.Material.Neon
        Part2.Color = v1
        Part2.Size = Vector3.new(0.4, 4, 4)
        Part2.CFrame = v147
        Part2.Transparency = 0.15
        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.CanTouch = false
        Part2.CastShadow = false

        local v148 = v4

        if not (v148 and v148.Parent) then
            v148 = Instance.new("Folder")
            v148.Name = "CursedIslandWarsFx"
            v148.Parent = Workspace
            v4 = v148
        end

        Part2.Parent = v148
        Part2.Shape = Enum.PartType.Cylinder
        TweenService:Create(Part2, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.4, 600, 600),
            Transparency = 1
        }):Play()
        Debris:AddItem(Part2, 1.2)
        t19.Sound(Sounds.ScrambleBoss.GlassCrack, Collision, 0.7, 2)
        t19.Sound(Sounds.CinematicBoom, Collision, 1.1, 3)
        t19.Sound(Sounds.Explosion, Collision, 0.8, 1.5)
    end)
end

local function sizeCollapse(p109, p110) -- line: 997
    -- upvalues: holders (copy)
    local BoundingBox, BoundingBox2 = p110:GetBoundingBox()

    for _, v149 in { "Warn", "Fall", "Break" } do
        for _, v150 in holders(p109, v149) do
            if v150:IsA("BasePart") then
                v150.CFrame = BoundingBox
                v150.Size = BoundingBox2
            end
        end
    end
end

local function glow(p111, p112, p113, p114) -- line: 1009
    -- upvalues: TweenService (copy)
    p111.Transparency = p112
    TweenService:Create(p111, TweenInfo.new(p114, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = p113
    }):Play()
end

function t19.SafeZone(p115) -- line: 1016
    -- upvalues: Workspace (copy), State (copy), v2 (copy), v4 (ref), Model (ref), glow (copy)
    local Model2 = Model

    if p115 then
        local v151 = State.Island()
        local v152 = if not Model2 then v151 == nil else nil

        if not (Model2 or v152) then
            local Top = v151.Centre.Top
            local Model2 = Instance.new("Model")

            Model2.Name = "SafeZone"

            for _, v153 in {
                    { Vector3.new(420, 10, 10), Vector3.new(0, 210, 0), 0.5, 0.75 },
                    { Vector3.new(0.3, 54, 54), Vector3.new(0, 0.4, 0), 0.55, 0.85 }
                } do
                local Part = Instance.new("Part")

                Part.Shape = Enum.PartType.Cylinder
                Part.Material = Enum.Material.Neon
                Part.Color = v2
                Part.Size = v153[1]
                Part.CFrame = CFrame.new(Top.Position + v153[2]) * CFrame.Angles(0, 0, 1.5707963267948966)
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Parent = Model2
                glow(Part, v153[3], v153[4], 0.9)
            end

            local v154 = v4

            if not (v154 and v154.Parent) then
                v154 = Instance.new("Folder")
                v154.Name = "CursedIslandWarsFx"
                v154.Parent = Workspace
                v4 = v154
            end

            Model2.Parent = v154
            Model = Model2
        end
    else
        Model = nil

        if Model2 then
            Model2:Destroy()
        end
    end
end

function t19.CollapseWarn(p116, p117) -- line: 1054
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy), Sounds (copy), v4 (ref), t11 (copy), t13 (copy), t19 (copy), sizeCollapse (copy)
    for _, v155 in p116 do
        local Highlight = Instance.new("Highlight")

        Highlight.Adornee = v155
        Highlight.FillColor = Color3.fromRGB(255, 30, 20)
        Highlight.OutlineColor = Color3.fromRGB(255, 70, 40)
        Highlight.FillTransparency = 0.8
        Highlight.OutlineTransparency = 0.2
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded

        local v156 = v4

        if not (v156 and v156.Parent) then
            v156 = Instance.new("Folder")
            v156.Name = "CursedIslandWarsFx"
            v156.Parent = Workspace
            v4 = v156
        end

        Highlight.Parent = v156
        TweenService:Create(Highlight, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            FillTransparency = 0.35
        }):Play()
        t13[v155] = Highlight

        local v157 = t19.Anchored(VFX.V11_Collapse, v155:GetPivot())

        sizeCollapse(v157, v155)
        t19.Loop(v157, "Warn", true)
        t11[v155] = v157

        for _, descendant in v155:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.Name == "Cracks" then
                TweenService:Create(descendant, TweenInfo.new(p117), {
                    Color = Color3.fromRGB(255, 30, 10)
                }):Play()
            end
        end

        t19.Sound(Sounds.ScrambleBoss.Rumble, v155:GetPivot().Position, 1, 2)
    end
end

function t19.CollapseDrop(p118, p119, p120) -- line: 1081
    -- upvalues: Debris (copy), Sounds (copy), t6 (copy), t11 (copy), t13 (copy), self2 (copy), v11 (copy), t19 (copy)
    local t27 = {}

    for _, v158 in p118 do
        t27[v158] = { v158 }
    end

    for v159, v160 in p119 do
        if v160:IsA("Model") then
            self2[v160] = true
            table.insert(t27[p120[v159]], v160)
        end
    end

    local elapsed = os.clock()

    for _, v162 in p118 do
        local v163 = t13[v162]

        t13[v162] = nil

        if v163 then
            v163:Destroy()
        end

        local v164 = t27[v162]
        local v165 = t11[v162]

        t11[v162] = nil

        if v165 then
            t19.Loop(v165, "Warn", false)
            t19.Burst(v165, "Break")
            t19.Loop(v165, "Fall", true)
            table.insert(v164, v165)
            Debris:AddItem(v165, 3.4)
        end

        local t28 = {}

        for v166, v167 in v164 do
            t28[v166] = v167:GetPivot()
        end

        table.insert(t6, {
            Models = v164,
            Bases = t28,
            Origin = v162:GetPivot(),
            Spin = Vector3.new(v11:NextNumber(-0.35, 0.35), 0, v11:NextNumber(-0.35, 0.35)),
            Start = elapsed
        })
        t19.Sound(Sounds.ImpactBoom, v162:GetPivot().Position, 0.6, 2)
    end
end

local function stepFallings() -- line: 1124
    -- upvalues: t6 (copy), v11 (copy)
    local elapsed = os.clock()

    for i = #t6, 1, -1 do
        local v169 = t6[i]
        local v170 = elapsed - v169.Start

        if v170 > 2.4 then
            for _, v171 in v169.Models do
                if v171.Parent then
                    v171.Parent = nil
                end
            end

            table.remove(t6, i)
        else
            local v172 = if v170 < 0 then CFrame.new(v11:NextNumber(-0.4, 0.4), 0, v11:NextNumber(-0.4, 0.4)) else CFrame.new(0, -(12 * v170 + 100 * v170 * v170), 0) * CFrame.Angles(v169.Spin.X * v170, 0, v169.Spin.Z * v170)
            local v173 = v169.Origin * v172 * v169.Origin:Inverse()

            for v174, v175 in v169.Models do
                if v175.Parent then
                    v175:PivotTo(v173 * v169.Bases[v174])
                end
            end
        end
    end
end

function t19.Victory(p121) -- line: 1151
    -- upvalues: VFX (copy), Sounds (copy), t19 (copy)
    for i = -1, 1 do
        t19.Once(VFX.V12_Victory, { "Burst" }, p121 * CFrame.new(i * 8, -3, -6), 4)
    end

    t19.Ui(Sounds.ScrambleBoss.Pop, 1, 1.5)
end

function t19.SuddenDeath() -- line: 1158
    -- upvalues: v8 (ref), t19 (copy)
    local v176 = v8

    if v176 then
        t19.Loop(v176, "SuddenDeath", true)
    end
end

function t19.Start(p122) -- line: 1165
    -- upvalues: RunService (copy), State (copy), VFX (copy), t2 (copy), v3 (ref), v4 (ref), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), t12 (copy), t13 (copy), t16 (copy), Model (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n2 (ref), n3 (ref), t19 (copy), stepSteady (copy), stepFlights (copy), stepMines (copy), refreshSkulls (copy), mountCrystal (copy), stepCrystals (copy), stepPickups (copy), mountBarrier (copy), showFace (copy), mountPortal (copy), stepFallings (copy)
    v3 = p122:Extend()
    v10 = false
    n2 = 0
    n3 = 0
    v3:Add(function() -- line: 1170
        -- upvalues: v4 (ref), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), t12 (copy), t13 (copy), t16 (copy), Model (ref), v7 (ref), v8 (ref), v9 (ref), t19 (copy)
        for v178 in t3 do
            t19.Land(v178)
        end

        table.clear(t4)
        table.clear(t5)
        table.clear(t6)

        for _, v179 in { t7, t8 } do
            for _, v180 in v179 do
                v180:Destroy()
            end

            table.clear(v179)
        end

        table.clear(t9)
        table.clear(t10)
        table.clear(t16)
        table.clear(t11)
        table.clear(t12)
        table.clear(t13)
        Model = nil
        v7 = false
        v8 = nil
        v9 = nil

        local v181 = v4

        v4 = nil

        if v181 then
            v181:Destroy()
        end
    end)

    local t30 = {}

    local function mount(p123) -- line: 1201
        -- upvalues: t30 (copy), State (copy), VFX (copy), t2 (copy), v8 (ref), v9 (ref), v10 (ref), t19 (copy), refreshSkulls (copy), mountCrystal (copy), mountBarrier (copy), mountPortal (copy)
        if p123 == nil or p123.Island == nil then
            return
        end

        local Island = p123.Island

        if v8 == nil then
            local v182 = t19.Anchored(VFX.V1_CursedSky.WorldFX, Island:GetPivot())

            t19.Loop(v182, "Ambient", true)
            v8 = v182

            for _, child in Island.FloatingDebris:GetChildren() do
                t30[child] = child:GetPivot()
            end
        end

        local v183 = State.Island()
        local Parent = if v183 then v183.Parent else nil
        local Pieces = if Parent then Parent:FindFirstChild("Pieces") else nil
        local SkyEyes = if Pieces then Pieces:FindFirstChild("SkyEyes") else nil

        if v9 == nil and SkyEyes then
            v9 = mountPortal(SkyEyes)

            if v10 or t2[p123.Phase] then
                v10 = false
                t19.Eyes("Open")
            end
        end

        for v184, v185 in p123.Crystals do
            if v185.Health > 0 then
                mountCrystal(v184, v185.Model)
            end
        end

        for v186, v187 in p123.Barriers do
            if v187.Health > 0 then
                mountBarrier(v186, v187.Model, v187.Health / v187.MaxHealth)
            end
        end

        refreshSkulls()
    end

    v3:Add(State.Changed:Connect(mount))
    mount(State.Snapshot)
    v3:Add(RunService.RenderStepped:Connect(function(_) -- line: 1238
        -- upvalues: t30 (copy), v9 (ref), v10 (ref), n2 (ref), stepSteady (copy), stepFlights (copy), stepMines (copy), stepCrystals (copy), stepPickups (copy), showFace (copy), stepFallings (copy)
        stepSteady()
        stepFlights()
        stepMines()
        stepCrystals()

        local v190 = v9

        if v190 ~= nil and v10 then
            local elapsed = os.clock()

            if n2 <= elapsed then
                n2 = elapsed + showFace(v190, "EYES2")
            end
        end

        stepFallings()
        stepPickups()

        local elapsed = os.clock()

        for v191, v192 in t30 do
            if v191.Parent then
                v191:PivotTo(v192 * CFrame.new(0, math.sin(elapsed * 0.8 + v192.X) * 1.5, 0))
            end
        end
    end))
end

return t19

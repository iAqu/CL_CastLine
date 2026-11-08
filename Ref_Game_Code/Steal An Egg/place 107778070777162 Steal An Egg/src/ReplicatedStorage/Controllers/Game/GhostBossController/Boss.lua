-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Burst = require(script.Parent.Burst)
local GhostBossFlags = require(ReplicatedStorage.Shared.Flags.GhostBossFlags)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local Shake = require(ReplicatedStorage.Client.Shake)
local SuckFX = require(ReplicatedStorage.Controllers.Game.TrainGhostVisuals.SuckFX)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Attributes, Phases, AttackPhases = GhostBoss.Attributes, GhostBoss.Phases, GhostBoss.AttackPhases
local v1 = Color3.fromRGB(80, 255, 210)
local v2 = Color3.new(1, 1, 1)
local DisplayName = GhostBoss.DisplayName
local v3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2)
local t1 = {}

t1.__index = t1

local function now() -- line: 131
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function ease(p1, p2, p3, p4) -- line: 135
    return p1 + (p2 - p1) * (1 - math.exp(-p3 * p4))
end

local function easeAngle(p5, p6, p7, p8) -- line: 139
    return p5 + ((p6 - p5 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - math.exp(-p7 * p8))
end

local function sound(...) -- line: 144
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v9 in { ... } do
        Assets = if Assets then Assets:FindFirstChild(v9) else nil
    end

    return if Assets and Assets:IsA("Sound") then Assets else nil
end

local function play(p9, p10, p11, p12) -- line: 152
    -- upvalues: Audio (copy)
    if p9 then
        Audio.Play(p9, p10, {
            MaxDistance = 260,
            Volume = p11,
            PlaybackSpeed = p12 or 1
        })
    end
end

local function numberAttribute(p13, p14, p15) -- line: 162
    local Attribute = p13:GetAttribute(p14)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p15
end

local function vectorAttribute(p16, p17) -- line: 167
    local Attribute = p16:GetAttribute(p17)

    return if typeof(Attribute) == "Vector3" then Attribute else nil
end

local function predictedGround(p18, p19) -- line: 172
    -- upvalues: Workspace (copy), Attributes (copy)
    local Attribute = p18:GetAttribute(Attributes.Ground)

    if typeof(Attribute) ~= "Vector3" then
        Attribute = nil
    end

    local v10 = Attribute or p19
    local Attribute2 = p18:GetAttribute(Attributes.Velocity)

    if typeof(Attribute2) ~= "Vector3" then
        Attribute2 = nil
    end

    if Attribute2 == nil then
        return v10
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Attribute3 = p18:GetAttribute(Attributes.MovedAt)

    if type(Attribute3) ~= "number" then
        Attribute3 = ServerTimeNow
    end

    return v10 + Attribute2 * math.clamp(ServerTimeNow - Attribute3, 0, 0.3)
end

local function nozzleOf(p20) -- line: 184
    -- upvalues: Players (copy), GhostBoss (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p20)
    local v12 = PlayerByUserId and PlayerByUserId.Character

    if v12 ~= nil then
        for _, child in v12:GetChildren() do
            if GhostBoss.IsVacuum(child) then
                local v13 = child:FindFirstChild("Nozzle", true)

                if v13 and v13:IsA("Attachment") then
                    return v13
                end
            end
        end
    end

    return nil
end

local function captorPoint(p21) -- line: 201
    -- upvalues: Players (copy), nozzleOf (copy)
    local v14 = nozzleOf(p21)

    if v14 then
        return v14.WorldPosition
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p21)
    local v15 = PlayerByUserId and PlayerByUserId.Character
    local HumanoidRootPart = v15 and v15:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then (HumanoidRootPart.CFrame * CFrame.new(0, 1, -2.5)).Position else nil
end

local function bindHealthBar(p22) -- line: 215
    -- upvalues: DisplayName (copy)
    local v16 = p22:FindFirstChildWhichIsA("BillboardGui", true)

    if v16 ~= nil then
        local BarBG = v16:FindFirstChild("BarBG")
        local Bar2 = BarBG and BarBG:FindFirstChild("Bar")
        local PhantomBar = BarBG and BarBG:FindFirstChild("PhantomBar")
        local HPLabel = v16:FindFirstChild("HPLabel")
        local Title = v16:FindFirstChild("Title")

        if Bar2 ~= nil and PhantomBar ~= nil and HPLabel ~= nil and Bar2:IsA("GuiObject") and PhantomBar:IsA("GuiObject") and HPLabel:IsA("TextLabel") then
            if Title and Title:IsA("TextLabel") then
                Title.Text = DisplayName
            end

            return {
                Gui = v16,
                Bar = Bar2,
                Phantom = PhantomBar,
                Label = HPLabel,
                BaseSize = v16.Size,
                BaseOffset = v16.StudsOffset
            }
        end
    end

    return nil
end

local function attachEmitters(p23, p24) -- line: 248
    -- upvalues: ReplicatedStorage (copy), GhostBoss (copy)
    local t2 = {}
    local v18 = ReplicatedStorage:FindFirstChild(GhostBoss.AssetsName)
    local VFX = v18 and v18:FindFirstChild("VFX")
    local v19 = VFX and VFX:FindFirstChild(p24)

    if v19 ~= nil then
        for _, child in v19:GetChildren() do
            if child:IsA("ParticleEmitter") then
                local clone = child:Clone()

                clone.Enabled = true
                clone.Parent = p23
                table.insert(t2, clone)
            end
        end
    end

    return t2
end

local function loadTrack(p25, p26, p27) -- line: 267
    local v20 = p26:FindFirstChild(p27)

    if p25 == nil or v20 == nil or not v20:IsA("Animation") then
        return nil
    end

    local function v21() -- line: 272
        -- upvalues: p25 (copy), v20 (copy)
        return p25:LoadAnimation(v20)
    end

    local ok, result = pcall(v21)

    return if ok then result else nil
end

function t1.new(p28, p29, p30) -- line: 282
    -- upvalues: Workspace (copy), GhostBossFlags (copy), GhostBoss (copy), Trove (copy), Attributes (copy), Phases (copy), AttackPhases (copy), v1 (copy), t1 (copy), bindHealthBar (copy), attachEmitters (copy), loadTrack (copy)
    local v22 = Trove.new()
    local v23 = v22:Add(p29:Clone())
    local v24 = v23.PrimaryPart or v23:FindFirstChild("RootPart")

    assert(v24 and v24:IsA("BasePart"), "Ghost Boss template needs a RootPart")

    local Position = v23:GetBoundingBox().Position

    v24.PivotOffset = CFrame.new(v24.CFrame:PointToObjectSpace(Position))
    v23.PrimaryPart = v24

    local t3 = {}

    for _, descendant in v23:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == v24
            descendant.Massless = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.CastShadow = false
            t3[descendant] = descendant.Transparency
        end
    end

    local v26 = v24

    for v27 in t3 do
        if v27.Transparency < 1 and v27.Size.Magnitude > v26.Size.Magnitude then
            v26 = v27
        end
    end

    local Aura = attachEmitters(v26, "Aura")
    local PointLight = Instance.new("PointLight")

    PointLight.Name = "GhostBossLight"
    PointLight.Color = v1
    PointLight.Brightness = 1.6
    PointLight.Range = 22
    PointLight.Shadows = false
    PointLight.Parent = v24

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "GhostBossGlow"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v1
    Highlight.OutlineColor = v1
    Highlight.FillTransparency = 0.85
    Highlight.OutlineTransparency = 0.35
    Highlight.Parent = v23

    local v28 = v23:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v28

    if v28 then
        Animator = v28:FindFirstChildOfClass("Animator")

        if Animator == nil then
            Animator = Instance.new("Animator")
            Animator.Parent = v28
        end
    end

    local t4 = {
        State = p28,
        Trove = v22,
        Model = v23,
        Root = v24,
        Parts = t3,
        Animator = Animator,
        Idle = nil,
        Attack = nil,
        Bar = bindHealthBar(v24),
        Glow = Highlight,
        Aura = Aura,
        HalfHeight = GhostBoss.TemplateHalfHeight(p29)
    }
    local Attribute = p28:GetAttribute(Attributes.Ground)

    if typeof(Attribute) ~= "Vector3" then
        Attribute = nil
    end

    t4.Ground = Attribute or v23:GetPivot().Position
    t4.Struggle = 0
    t4.Lean = 0
    t4.AttackPhase = AttackPhases.None

    local ScaleFor = GhostBoss.ScaleFor
    local Attribute2 = p28:GetAttribute(Attributes.Health)

    if type(Attribute2) ~= "number" then
        Attribute2 = 1
    end

    local Attribute3 = p28:GetAttribute(Attributes.MaxHealth)

    if type(Attribute3) ~= "number" then
        Attribute3 = 1
    end

    t4.Scale = ScaleFor(Attribute2 / math.max(Attribute3, 1), GhostBossFlags.CaptureHealthFraction:Get(), GhostBossFlags.StartScale:Get())
    t4.AppliedScale = 1

    local Attribute4 = p28:GetAttribute(Attributes.Yaw)

    t4.Yaw = if type(Attribute4) ~= "number" then 0 else Attribute4
    t4.Clock = 0

    local Attribute5 = p28:GetAttribute(Attributes.Health)

    t4.ShownHealth = if type(Attribute5) ~= "number" then 1 else Attribute5
    t4.PunchAt = (-1e999)

    local Attribute6 = p28:GetAttribute(Attributes.AttackSerial)

    t4.AttackSerial = if type(Attribute6) ~= "number" then 0 else Attribute6
    t4.Beams = {}
    t4.Phase = Phases.None
    t4.PhaseAt = Workspace:GetServerTimeNow()
    t4.CaptureFrom = nil
    t4.CaptureScale = 1
    t4.RuptureFrom = nil
    t4.RuptureScale = 1
    t4.RuptureAt = 0
    t4.RupturePoint = Vector3.new(0, 0, 0)
    t4.Exploded = false
    t4.Finished = false
    t4.SpawnPuffed = false
    t4.SpawnRoared = false
    t4.LocalSucking = false

    local v29 = setmetatable(t4, t1)
    local Attribute7 = p28:GetAttribute(Attributes.SpawnedAt)

    if type(Attribute7) ~= "number" then
        Attribute7 = 0
    end

    local Attribute8 = p28:GetAttribute(Attributes.SpawnSeconds)

    if type(Attribute8) ~= "number" then
        Attribute8 = 0
    end

    if Attribute8 < Workspace:GetServerTimeNow() - Attribute7 then
        v29.SpawnPuffed = true
        v29.SpawnRoared = true
    end

    v23.Parent = p30
    v29.Idle = loadTrack(Animator, v23, "Idle")
    v29.Attack = loadTrack(Animator, v23, "Attack")

    local Idle = v29.Idle

    if Idle then
        Idle.Looped = true
        Idle.Priority = Enum.AnimationPriority.Idle
        Idle:Play(0.2)
    end

    local Attack = v29.Attack

    if Attack then
        Attack.Looped = false
        Attack.Priority = Enum.AnimationPriority.Action
    end

    v29:SetHealth(true)
    v29:ApplyScale(v29.Scale, 0)
    v29.Model:PivotTo(v29:RestingFrame())

    if not v29.SpawnRoared then
        v29:SetFade(1)
    end

    v22:Add(function() -- line: 407
        -- upvalues: v29 (copy)
        for _, v30 in v29.Beams do
            v30.FX:Destroy()
        end

        table.clear(v29.Beams)
    end)

    return v29
end

function t1.RestingFrame(p31) -- line: 416
    -- upvalues: GhostBossFlags (copy), GhostBoss (copy)
    local v31 = GhostBoss.Center(p31.Ground, p31.Scale, p31.HalfHeight, GhostBossFlags.HoverStuds:Get())

    return CFrame.new(v31) * CFrame.Angles(0, p31.Yaw + 0, 0)
end

function t1.SetLocalSucking(p32, p33) -- line: 422
    p32.LocalSucking = p33
end

function t1.InReach(p34, p35) -- line: 426
    -- upvalues: GhostBossFlags (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        local Position = p34.Model:GetPivot().Position
        local v33 = p34.HalfHeight * p34.AppliedScale
        local v32 = (Position - HumanoidRootPart.Position).Magnitude - v33 <= GhostBossFlags.VacuumReachStuds:Get() * (p35 or 1)

        return v32
    end

    return false
end

function t1.InCone(p36, p37) -- line: 438
    -- upvalues: GhostBossFlags (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        return false
    end

    local v34 = (p36.Model:GetPivot().Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

    if v34.Magnitude < p36.HalfHeight * p36.AppliedScale then
        return true
    end

    local v37 = math.cos((math.rad(GhostBossFlags.VacuumConeDegrees:Get() / 2)))

    for _, v38 in {
            HumanoidRootPart.CFrame.LookVector,
            p37 or Vector3.new(0, 0, 0)
        } do
        local v39 = v38 * Vector3.new(1, 0, 1)

        if v39.Magnitude >= 0.001 and v37 <= v39.Unit:Dot(v34.Unit) then
            return true
        end
    end

    return false
end

function t1.IsFinished(p38) -- line: 458
    return p38.Finished
end

function t1.GetPhase(p39) -- line: 462
    return p39.Phase
end

function t1.SetPhase(p40, p41) -- line: 466
    -- upvalues: Workspace (copy), Audio (copy), Shake (copy), Phases (copy), sound (copy)
    if p41 == p40.Phase then
        return
    end

    local Phase = p40.Phase

    p40.Phase = p41
    p40.PhaseAt = Workspace:GetServerTimeNow()

    if p41 == Phases.Capturing then
        p40.CaptureFrom = p40.Model:GetPivot()
        p40.CaptureScale = p40.AppliedScale
        p40:PlayAttack(1.25)

        local Roar = sound("Sounds", "ScrambleBoss", "Roar")
        local Position = p40.Model:GetPivot().Position

        if Roar then
            Audio.Play(Roar, Position, {
                Volume = 0.8,
                PlaybackSpeed = 1.35,
                MaxDistance = 260
            })
        end

        Shake.Play({
            Seconds = 0.5,
            Magnitude = 0.5,
            Shape = "Pulse",
            Range = {
                Near = 40,
                Far = 160,
                Center = p40.Model:GetPivot().Position
            }
        })
    elseif p41 == Phases.Defeated then
        if Phase ~= Phases.Capturing then
            p40.CaptureFrom = p40.Model:GetPivot()
            p40.CaptureScale = p40.AppliedScale
        end

        p40:Explode()
    elseif p41 == Phases.Escaped then
        p40:StopAura()
        p40:PlayAttack(0.8)

        local Swoosh = sound("Sounds", "ScrambleBoss", "Swoosh")
        local Position = p40.Model:GetPivot().Position

        if Swoosh then
            Audio.Play(Swoosh, Position, {
                Volume = 0.9,
                PlaybackSpeed = 0.7,
                MaxDistance = 260
            })
        end
    end
end

function t1.StopAura(p42) -- line: 497
    for _, v40 in p42.Aura do
        v40.Enabled = false
    end
end

function t1.PlayAttack(p43, p44) -- line: 503
    local Attack = p43.Attack

    if Attack then
        Attack:Play(0.1, 1, p44)
    end
end

function t1.SetHealth(p45, p46) -- line: 510
    -- upvalues: TweenService (copy), Attributes (copy), v3 (copy), v4 (copy)
    local Bar = p45.Bar
    local Attribute = p45.State:GetAttribute(Attributes.Health)

    if type(Attribute) ~= "number" then
        Attribute = 0
    end

    local Attribute2 = p45.State:GetAttribute(Attributes.MaxHealth)

    if type(Attribute2) ~= "number" then
        Attribute2 = 1
    end

    local v41 = math.max(Attribute2, 1)

    if Attribute < p45.ShownHealth - 0.01 then
        p45.PunchAt = os.clock()
    end

    p45.ShownHealth = Attribute

    if Bar == nil then
        return
    end

    local v43 = math.clamp(Attribute / v41, 0, 1)
    local v44 = UDim2.fromScale(v43, Bar.Bar.Size.Y.Scale)

    Bar.Label.Text = ("%*/%*"):format(math.max(math.ceil(Attribute), 0), (math.ceil(v41)))

    if p46 then
        Bar.Bar.Size = v44
        Bar.Phantom.Size = UDim2.fromScale(v43, Bar.Phantom.Size.Y.Scale)
    else
        TweenService:Create(Bar.Bar, v3, {
            Size = v44
        }):Play()
        TweenService:Create(Bar.Phantom, v4, {
            Size = UDim2.fromScale(v43, Bar.Phantom.Size.Y.Scale)
        }):Play()
    end
end

function t1.ApplyScale(p47, p48, p49) -- line: 535
    if math.abs(p48 - p47.AppliedScale) > 0.004 then
        p47.Model:ScaleTo((math.max(p48, 0.01)))
        p47.AppliedScale = p48
    end

    local Bar = p47.Bar

    if not Bar then
        return
    end

    local v47 = p48 * (p49 + 1)

    Bar.Gui.Size = UDim2.new(Bar.BaseSize.X.Scale * v47, 0, Bar.BaseSize.Y.Scale * v47, 0)
    Bar.Gui.StudsOffset = Bar.BaseOffset * p48
end

function t1.SetFade(p50, p51) -- line: 548
    for v48, v49 in p50.Parts do
        v48.Transparency = v49 + (1 - v49) * p51
    end

    local Bar = p50.Bar

    if not Bar then
        return
    end

    Bar.Gui.Enabled = p51 < 0.95
end

function t1.StepBeams(p52, p53, p54, p55) -- line: 558
    -- upvalues: GhostBoss (copy), SuckFX (copy), LocalPlayer (copy), Attributes (copy), nozzleOf (copy)
    local elapsed = os.clock()
    local v50 = {}

    if p55 then
        table.insert(v50, p55)
    else
        v50 = GhostBoss.DecodeSuckers(p52.State:GetAttribute(Attributes.Suckers))

        if p52.LocalSucking and not table.find(v50, LocalPlayer.UserId) and p52:InReach() then
            table.insert(v50, LocalPlayer.UserId)
        end
    end

    for v51, v52 in v50 do
        if v51 > 6 then
            break
        end

        local v53 = nozzleOf(v52)

        if v53 ~= nil then
            local v54 = p52.Beams[v52]

            if v54 == nil then
                v54 = {
                    FX = SuckFX.new(p52.Model),
                    SeenAt = elapsed
                }
                p52.Beams[v52] = v54
            end

            v54.SeenAt = elapsed
            v54.FX:Update(v53, p54, p53)
        end
    end

    for v55, v56 in p52.Beams do
        if v56.SeenAt ~= elapsed then
            v56.FX:Update(nil, 0, p53)

            if elapsed - v56.SeenAt > 1.2 then
                v56.FX:Destroy()
                p52.Beams[v55] = nil
            end
        end
    end
end

function t1.Explode(p56) -- line: 596
    -- upvalues: Workspace (copy), Burst (copy), SuckFX (copy), Attributes (copy), nozzleOf (copy)
    if p56.Exploded then
        return
    end

    p56.Exploded = true

    local Attribute = p56.State:GetAttribute(Attributes.CaptureUserId)

    if type(Attribute) ~= "number" then
        Attribute = 0
    end

    local v57 = if Attribute > 0 then nozzleOf(Attribute) else nil

    if v57 then
        SuckFX.Burst(v57)
    end

    p56:StopAura()

    for _, v58 in p56.Beams do
        v58.FX:Destroy()
    end

    table.clear(p56.Beams)

    if p56.Bar then
        p56.Bar.Gui.Enabled = false
    end

    local State = p56.State
    local DefeatAt = Attributes.DefeatAt
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Attribute2 = State:GetAttribute(DefeatAt)

    if type(Attribute2) ~= "number" then
        Attribute2 = ServerTimeNow
    end

    if Workspace:GetServerTimeNow() - Attribute2 > 1.5 then
        p56:SetFade(1)
        p56.Finished = true
    else
        local Attribute = p56.State:GetAttribute(Attributes.ExplodePosition)

        if typeof(Attribute) ~= "Vector3" then
            Attribute = nil
        end

        p56.RupturePoint = Attribute or p56.Model:GetPivot().Position
        p56.RuptureFrom = p56.Model:GetPivot()
        p56.RuptureScale = p56.AppliedScale
        p56.RuptureAt = os.clock()
        Burst.Rupture(p56.RupturePoint)
    end
end

function t1.StepRupture(p57) -- line: 628
    -- upvalues: TweenService (copy), Burst (copy), Attributes (copy), v1 (copy), v2 (copy)
    local RuptureFrom = p57.RuptureFrom

    if RuptureFrom == nil then
        return
    end

    local v60 = math.clamp((os.clock() - p57.RuptureAt) / Burst.RuptureSeconds, 0, 1)
    local Value = TweenService:GetValue(v60, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local Value2 = TweenService:GetValue(v60, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local v62 = math.max(p57.RuptureScale + (0.6 - p57.RuptureScale) * Value, 0.01)
    local v63 = p57.Clock * 40
    local v66 = Vector3.new(math.noise(v63, 1.3), math.noise(v63, 2.9), math.noise(v63, 4.7)) * 0.9 * v60 * v62
    local v67 = RuptureFrom.Position:Lerp(p57.RupturePoint + Vector3.new(0, 1.5, 0), Value2)

    p57:ApplyScale(v62, 0)
    p57.Glow.FillColor = v1:Lerp(v2, v60)
    p57.Glow.FillTransparency = (1 - v60) * 0.6
    p57.Glow.OutlineTransparency = (1 - v60) * 0.35
    p57.Model:PivotTo(CFrame.new(v67 + v66) * RuptureFrom.Rotation * CFrame.Angles(0, Value * 0.6, math.sin(p57.Clock * 35) * 0.12 * v60))

    if v60 < 1 then
        return
    end

    p57.RuptureFrom = nil
    Burst.Shatter(p57.Model, p57.Model:GetPivot().Position, v62)

    local Explode = Burst.Explode
    local RupturePoint = p57.RupturePoint
    local Attribute = p57.State:GetAttribute(Attributes.DropPosition)

    if typeof(Attribute) ~= "Vector3" then
        Attribute = nil
    end

    Explode(RupturePoint, Attribute)
    p57:SetFade(1)
    p57.Glow.Enabled = false
    p57.Finished = true
end

function t1.Step(p58, p59) -- line: 663
    -- upvalues: Workspace (copy), Audio (copy), Burst (copy), GhostBossFlags (copy), GhostBoss (copy), Shake (copy), SuckFX (copy), LocalPlayer (copy), Attributes (copy), Phases (copy), AttackPhases (copy), v1 (copy), v2 (copy), sound (copy), captorPoint (copy)
    if p58.Finished and p58.Phase ~= Phases.Escaped then
        return
    end

    p58.Clock += p59

    local State = p58.State
    local Attribute = State:GetAttribute(Attributes.Health)

    if type(Attribute) ~= "number" then
        Attribute = 0
    end

    if math.abs(Attribute - p58.ShownHealth) > 0.01 then
        p58:SetHealth()
    end

    local Attribute2 = State:GetAttribute(Attributes.AttackPhase)

    if type(Attribute2) ~= "string" then
        Attribute2 = AttackPhases.None
    end

    if Attribute2 ~= p58.AttackPhase then
        p58.AttackPhase = Attribute2

        if Attribute2 == AttackPhases.Windup then
            p58:PlayAttack(0.35)
        end
    end

    local Attribute3 = State:GetAttribute(Attributes.AttackSerial)

    if type(Attribute3) ~= "number" then
        Attribute3 = 0
    end

    if p58.AttackSerial < Attribute3 then
        p58.AttackSerial = Attribute3

        if p58.Attack then
            p58.Attack:Stop(0)
        end

        p58:PlayAttack(1)

        local v72 = GhostBoss.DecodeSuckers(State:GetAttribute(Attributes.AttackHits))

        if table.find(v72, LocalPlayer.UserId) then
            Shake.Play({
                Seconds = 0.4,
                Magnitude = 0.8,
                Shape = "Fade"
            })
        end
    end

    local v73 = Attribute2 ~= AttackPhases.None
    local Lean = p58.Lean

    p58.Lean = Lean + ((if Attribute2 == AttackPhases.Windup then 0.35 elseif Attribute2 == AttackPhases.Charge then -0.22 else 0) - Lean) * (1 - math.exp(p59 * -10))

    local Ground = p58.Ground
    local Attribute4 = State:GetAttribute(Attributes.Ground)

    if typeof(Attribute4) ~= "Vector3" then
        Attribute4 = nil
    end

    local v76 = Attribute4 or Ground
    local Attribute5 = State:GetAttribute(Attributes.Velocity)

    if typeof(Attribute5) ~= "Vector3" then
        Attribute5 = nil
    end

    if Attribute5 ~= nil then
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local Attribute = State:GetAttribute(Attributes.MovedAt)

        if type(Attribute) ~= "number" then
            Attribute = ServerTimeNow
        end

        v76 += Attribute5 * math.clamp(ServerTimeNow - Attribute, 0, 0.3)
    end

    p58.Ground = if not ((v76 - p58.Ground).Magnitude > 40) then p58.Ground:Lerp(v76, 1 - math.exp(p59 * -8)) else v76

    local Ground2 = p58.Ground
    local Attribute6 = State:GetAttribute(Attributes.Suckers)
    local v79 = type(Attribute6) == "string" and Attribute6 ~= ""
    local Struggle = p58.Struggle

    p58.Struggle = Struggle + ((if v79 then 1 else 0) - Struggle) * (1 - math.exp(p59 * -6))

    local Attribute7 = State:GetAttribute(Attributes.MaxHealth)

    if type(Attribute7) ~= "number" then
        Attribute7 = 1
    end

    local v82 = math.max(Attribute7, 1)
    local v83 = GhostBossFlags.CaptureHealthFraction:Get()
    local v84 = GhostBossFlags.StartScale:Get()
    local v85 = GhostBossFlags.HoverStuds:Get()
    local v87 = math.clamp(Attribute / v82, 0, 1)
    local v88 = GhostBoss.ScaleFor(v87, v83, v84)
    local v89 = GhostBoss.CaptureProgress(v87, v83)
    local Yaw = p58.Yaw
    local Yaw2 = Attributes.Yaw
    local Yaw3 = p58.Yaw
    local Attribute8 = State:GetAttribute(Yaw2)

    if type(Attribute8) ~= "number" then
        Attribute8 = Yaw3
    end

    local v90 = if v73 then 12 else 3

    p58.Yaw = Yaw + ((Attribute8 - Yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - math.exp(-v90 * p59))

    local v93 = os.clock() - p58.PunchAt
    local v94 = if v93 < 0.18 then 0.12 * (1 - v93 / 0.18) else 0
    local v96 = math.sin(p58.Clock * 1.7) * 0.7
    local v98 = math.sin(p58.Clock * 0.9) * 0.08
    local Phase = p58.Phase

    if Phase == Phases.Spawning or Phase == Phases.Alive then
        local Attribute = State:GetAttribute(Attributes.SpawnedAt)

        if type(Attribute) ~= "number" then
            Attribute = 0
        end

        local Attribute2 = State:GetAttribute(Attributes.SpawnSeconds)

        if type(Attribute2) ~= "number" then
            Attribute2 = 1
        end

        local v99 = math.max(Attribute2, 0.1)
        local v101 = math.clamp((Workspace:GetServerTimeNow() - Attribute) / v99, 0, 1)

        if not p58.SpawnPuffed and v101 < 0.5 then
            p58.SpawnPuffed = true
            Burst.SpawnPuff(Ground2)
        end

        if not p58.SpawnRoared and v101 >= 0.55 then
            p58.SpawnRoared = true
            p58:PlayAttack(1)

            local Roar = sound("Sounds", "MonsterParasite", "Roar")

            if Roar then
                Audio.Play(Roar, Ground2, {
                    Volume = 0.75,
                    PlaybackSpeed = 1.15,
                    MaxDistance = 260
                })
            end
        end

        local v102 = (1 - v101) ^ 2 * 14
        local v103 = 1 - (1 - v101) ^ 3

        if v101 < 1 then
            p58.Scale = v88 * (v103 * 0.85 + 0.15)
        else
            local Scale = p58.Scale

            p58.Scale = Scale + (v88 - Scale) * (1 - math.exp(p59 * -6))
        end

        p58:ApplyScale(p58.Scale, v94)
        p58:SetFade(1 - math.clamp(v101 * 1.6, 0, 1))
        p58.Glow.FillTransparency = 0.85 - (1 - v101) * 0.6 - 0.25 * v89 - math.max(p58.Lean, 0) * 0.3 / 0.35

        local v108 = GhostBoss.Center(Ground2, p58.Scale, p58.HalfHeight, v85)
        local v109 = p58.Clock * 9
        local v111 = Vector3.new(math.noise(v109, 4.1), 0, math.noise(v109, 5.3)) * 0.6 * p58.Struggle * p58.Scale

        p58.Model:PivotTo(CFrame.new(v108 + v111 + Vector3.new(0, v96 * p58.Scale - v102, 0)) * CFrame.Angles(0, p58.Yaw + 0, 0) * CFrame.Angles(p58.Lean, 0, v98 * (1 + p58.Struggle)))
        p58:StepBeams(p59, 0.25 + 0.75 * v89, nil)
    elseif Phase == Phases.Capturing then
        local Attribute = State:GetAttribute(Attributes.CaptureUserId)

        if type(Attribute) ~= "number" then
            Attribute = 0
        end

        local Attribute2 = State:GetAttribute(Attributes.CaptureSeconds)

        if type(Attribute2) ~= "number" then
            Attribute2 = 1
        end

        local v114 = math.max(Attribute2, 0.1)
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local CaptureAt = Attributes.CaptureAt
        local ServerTimeNow2 = Workspace:GetServerTimeNow()
        local Attribute3 = State:GetAttribute(CaptureAt)

        if type(Attribute3) ~= "number" then
            Attribute3 = ServerTimeNow2
        end

        local v116 = math.clamp((ServerTimeNow - Attribute3) / v114, 0, 1)
        local v117 = p58.CaptureFrom or p58.Model:GetPivot()
        local v118 = if Attribute > 0 then captorPoint(Attribute) else nil
        local v120 = math.clamp((v116 - 0.22) / 0.78, 0, 1)
        local v121 = v120 * v120 * v120
        local v122 = p58.CaptureScale + (0.04 - p58.CaptureScale) * v121
        local v123 = if v118 then v117.Position:Lerp(v118, v121) else v117.Position
        local v124 = (1 - v120) * 0.6 * p58.CaptureScale
        local v125 = p58.Clock * 18
        local v128 = v123 + Vector3.new(math.noise(v125, 1.1), math.noise(v125, 2.3), math.noise(v125, 3.7)) * v124

        p58:ApplyScale(v122, 0)
        p58.Glow.FillColor = v1:Lerp(v2, v121)
        p58.Glow.FillTransparency = 0.6 - v121 * 0.5
        p58.Model:PivotTo(CFrame.new(v128) * v117.Rotation * CFrame.Angles(0, SuckFX.CaptureSpin(v121), math.sin(p58.Clock * 30) * 0.15 * (1 - v120)))

        if p58.Bar then
            p58.Bar.Gui.Enabled = v120 < 0.15
        end

        if not (Attribute > 0) then
            Attribute = nil
        end

        p58:StepBeams(p59, 1, Attribute)
    elseif Phase == Phases.Escaped then
        local v133 = math.clamp((Workspace:GetServerTimeNow() - p58.PhaseAt) / 1.6, 0, 1)
        local v134 = GhostBoss.Center(Ground2, p58.Scale, p58.HalfHeight, v85)

        p58:SetFade(v133)
        p58:ApplyScale(p58.Scale * (v133 * 0.3 + 1), 0)
        p58.Model:PivotTo(CFrame.new(v134 + Vector3.new(0, v133 * v133 * 36, 0)) * CFrame.Angles(0, p58.Yaw + 0 + v133 * 6.283185307179586, 0))
        p58:StepBeams(p59, 0, nil)

        if v133 >= 1 then
            p58.Finished = true
        end
    elseif Phase == Phases.Defeated then
        p58:StepRupture()
    end
end

function t1.Destroy(p60) -- line: 824
    p60.Trove:Destroy()
end

return t1

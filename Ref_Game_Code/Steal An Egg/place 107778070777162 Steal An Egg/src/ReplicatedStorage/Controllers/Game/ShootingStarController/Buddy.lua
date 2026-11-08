-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CalmLoop = require(script.Parent.CalmLoop)
local Fx = require(script.Parent.Fx)
local ShootingStarFlags = require(ReplicatedStorage.Shared.Flags.ShootingStarFlags)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    0.8, 1.62
}
local LocalPlayer = Players.LocalPlayer
local t2 = {}

t2.__index = t2

local function now() -- line: 79
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function legPace(p1) -- line: 83
    -- upvalues: ShootingStarFlags (copy)
    local v1 = p1.ArriveAt - p1.StartAt

    if v1 <= 0 then
        return 0
    end

    return Vector3.new(p1.To.X - p1.From.X, 0, p1.To.Z - p1.From.Z).Magnitude / v1 / math.max(ShootingStarFlags.WalkSpeedStuds:Get(), 1)
end

local function legPosition(p2, p3) -- line: 92
    local v6 = p2.ArriveAt - p2.StartAt

    if v6 <= 0 then
        return p2.To
    end

    return p2.From:Lerp(p2.To, (math.clamp((p3 - p2.StartAt) / v6, 0, 1)))
end

local function angleTowards(p4, p5, p6) -- line: 100
    return p4 + ((p5 - p4 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p6
end

local function yawOf(p7) -- line: 105
    local v8 = Vector3.new(p7.X, 0, p7.Z)

    return if not (v8.Magnitude < 0.001) then math.atan2(-v8.X, -v8.Z) else nil
end

local function hopCurve(p8, p9, p10) -- line: 113
    local v12 = math.clamp(p8 / p9, 0, 1)

    return v12 * 4 * (1 - v12) * p10
end

local function playerRoot() -- line: 118
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function kitChild(p11) -- line: 124
    -- upvalues: Fx (copy)
    return (Fx.Kit():FindFirstChild(p11))
end

function t2.Spawn(p12, p13) -- line: 133
    -- upvalues: Fx (copy)
    local clone = Fx.Kit():FindFirstChild("Buddy"):Clone()

    clone:PivotTo(p13)
    clone.Parent = p12

    return clone
end

function t2.Tracks(p14) -- line: 140
    local t3 = {}
    local AnimationController = p14:FindFirstChildOfClass("AnimationController")
    local Animator = AnimationController and AnimationController:FindFirstChildOfClass("Animator")
    local Animations = p14:FindFirstChild("Animations")

    if Animator == nil or Animations == nil then
        return t3
    end

    for _, child in Animations:GetChildren() do
        if child:IsA("Animation") then
            local function v13() -- line: 150
                -- upvalues: Animator (copy), child (copy)
                return Animator:LoadAnimation(child)
            end

            local ok, result = pcall(v13)

            if ok and result then
                result.Looped = true
                t3[child.Name] = result
            end
        end
    end

    return t3
end

function t2.CalmIdle(p15) -- line: 162
    -- upvalues: CalmLoop (copy)
    local AnimationController = p15:FindFirstChildOfClass("AnimationController")
    local Animator = AnimationController and AnimationController:FindFirstChildOfClass("Animator")
    local Animations = p15:FindFirstChild("Animations")
    local Idle = Animations and Animations:FindFirstChild("Idle")

    if Animator == nil or Idle == nil or not Idle:IsA("Animation") then
        return nil
    end

    local new = CalmLoop.new
    local ok, result = pcall(new, Animator, Idle, 3)

    return if ok then result else nil
end

function t2.new(p16, p17, p18, p19, p20) -- line: 174
    -- upvalues: RunService (copy), Trove (copy), t2 (copy)
    local v14 = Trove.new()
    local v15 = t2.Spawn(p16, CFrame.new(p17.To))
    local PrimaryPart = v15.PrimaryPart
    local Core = PrimaryPart:FindFirstChild("Core")
    local v16 = t2.Tracks(v15)
    local t4 = {}

    for _, v17 in { "Eyebalck", "eye" } do
        local v18 = v15:FindFirstChild(v17)

        if v18 and v18:IsA("BasePart") then
            t4[v18] = v18.Size
        end
    end

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = "CatchPrompt"
    ProximityPrompt.ActionText = "Catch"
    ProximityPrompt.ObjectText = "Little Star"
    ProximityPrompt.HoldDuration = p19
    ProximityPrompt.MaxActivationDistance = 11
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.Enabled = false
    ProximityPrompt.Parent = PrimaryPart
    v14:Connect(ProximityPrompt.PromptButtonHoldBegan, function() -- line: 206
        -- upvalues: p20 (copy)
        p20.HoldBegan()
    end)
    v14:Connect(ProximityPrompt.PromptButtonHoldEnded, function() -- line: 209
        -- upvalues: p20 (copy)
        p20.HoldEnded()
    end)
    v14:Connect(ProximityPrompt.Triggered, function() -- line: 212
        -- upvalues: p20 (copy)
        p20.Triggered()
    end)

    local v19 = RaycastParams.new()

    v19.FilterType = Enum.RaycastFilterType.Exclude
    v19.RespectCanCollide = true
    v19.IgnoreWater = false

    local v20 = setmetatable({
        Model = v15,
        Root = PrimaryPart,
        Leg = p17,
        Noticed = p18,
        Prompt = ProximityPrompt,
        _trove = v14,
        _core = Core,
        _tracks = v16,
        _eyes = t4,
        _params = v19,
        _parent = p16,
        _scale = v15:GetScale(),
        _groundOffset = v15:GetAttribute("GroundOffset") or -1.7,
        _groundY = p17.To.Y,
        _probeAt = 0,
        _probeX = 1e999,
        _probeZ = 1e999,
        _yaw = 0,
        _lookYaw = nil,
        _lookAt = 0,
        _hopAt = (-1e999),
        _hopHeight = 0,
        _hopSeconds = 0.35,
        _wobbleAt = (-1e999),
        _charge = 0,
        _lift = 0,
        _blinkAt = os.clock() + 2,
        _chatterAt = os.clock() + 4,
        _lastWalkTime = 0,
        _stepSide = 1,
        _override = nil,
        _moving = false,
        _running = false,
        _popping = false,
        _tug = nil,
        _gone = false,
        _detached = false,
        _idle = t2.CalmIdle(v15)
    }, t2)

    if v20._idle then
        v20._idle:Play(0)
    end

    v14:Connect(RunService.RenderStepped, function(p21) -- line: 265
        -- upvalues: v20 (copy)
        v20:_step(p21)
    end)
    v20:_refreshPrompt()

    return v20
end

function t2._refreshFilter(p22) -- line: 272
    -- upvalues: Players (copy)
    local t6 = {
        p22._parent
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t6, player.Character)
        end
    end

    p22._params.FilterDescendantsInstances = t6
end

function t2._ground(p23, p24) -- line: 282
    -- upvalues: Workspace (copy)
    local elapsed = os.clock()
    local v24 = math.abs(p24.X - p23._probeX) + math.abs(p24.Z - p23._probeZ)

    if elapsed - p23._probeAt < 0.08 and v24 < 0.6 then
        return p23._groundY
    end

    p23._probeAt = elapsed
    p23._probeX = p24.X
    p23._probeZ = p24.Z
    p23:_refreshFilter()

    local v27 = Workspace:Raycast(Vector3.new(p24.X, p24.Y + 20, p24.Z), Vector3.new(0, -60, 0), p23._params)

    if v27 then
        return v27.Position.Y
    end

    return p24.Y
end

function t2._blink(p25) -- line: 297
    for v28, v29 in p25._eyes do
        if v28.Parent then
            v28.Size = Vector3.new(v29.X, v29.Y * 0.12, v29.Z)
        end
    end

    task.delay(0.11, function() -- line: 303
        -- upvalues: p25 (copy)
        for v31, v32 in p25._eyes do
            if v31.Parent then
                v31.Size = v32
            end
        end
    end)
end

function t2._footprint(p26, p27, p28) -- line: 312
    -- upvalues: TweenService (copy), Fx (copy)
    local clone = Fx.Kit():FindFirstChild("Footprint"):Clone()
    local v33 = CFrame.Angles(0, p28, 0).RightVector * 0.3 * p26._stepSide * p26._scale

    clone.Size = Vector3.new(1.4, 0.05, 1.4) * p26._scale
    clone.CFrame = CFrame.new(p27 + v33 + Vector3.new(0, 0.06, 0)) * CFrame.Angles(0, p28 + math.rad((math.random(-25, 25))), 0)
    clone.Parent = p26._parent

    local Decal = clone:FindFirstChildOfClass("Decal")

    if Decal then
        TweenService:Create(Decal, TweenInfo.new(2.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play()
    end

    task.delay(2.7, function() -- line: 328
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

function t2._hop(p29, p30, p31) -- line: 333
    p29._hopAt = os.clock()
    p29._hopHeight = p30 * p29._scale
    p29._hopSeconds = p31
end

function t2._refreshPrompt(p32) -- line: 339
    p32.Prompt.Enabled = p32.Noticed and not p32._popping and not p32._gone
end

function t2._step(p33, p34) -- line: 343
    -- upvalues: Workspace (copy), Fx (copy), ShootingStarFlags (copy), t1 (copy), LocalPlayer (copy)
    local elapsed = os.clock()
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Leg = p33.Leg
    local v36 = Leg.ArriveAt - Leg.StartAt
    local v37 = if v36 <= 0 then Leg.To else Leg.From:Lerp(Leg.To, (math.clamp((ServerTimeNow - Leg.StartAt) / v36, 0, 1)))
    local v39 = ServerTimeNow < Leg.ArriveAt and (Leg.To - Leg.From).Magnitude > 0.1
    local _scale = p33._scale

    if p33._override then
        p33.Root.CFrame = p33._override
    else
        local v40 = p33:_ground(v37)

        if math.abs(v40 - p33._groundY) > 12 then
            p33._groundY = v40
        else
            p33._groundY = p33._groundY + (v40 - p33._groundY) * (1 - math.exp(p34 * -14))
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        local v44

        if v39 then
            local v45 = Leg.To - Leg.From
            local v46 = Vector3.new(v45.X, 0, v45.Z)

            if not (v46.Magnitude < 0.001) then
                v44 = math.atan2(-v46.X, -v46.Z)
            end

            p33._lookYaw = nil
        elseif p33.Noticed and HumanoidRootPart then
            local v49 = HumanoidRootPart.Position - v37
            local v50 = Vector3.new(v49.X, 0, v49.Z)

            if not (v50.Magnitude < 0.001) then
                v44 = math.atan2(-v50.X, -v50.Z)
            end
        else
            if p33._lookAt < elapsed then
                p33._lookAt = elapsed + math.random() * 2 + 1.6
                p33._lookYaw = p33._yaw + (math.random() * 2 - 1) * 0.9599310885968813
            end

            v44 = p33._lookYaw
        end

        if v44 then
            local _yaw = p33._yaw
            local v54 = 1 - math.exp(p34 * -9)

            p33._yaw = _yaw + ((v44 - _yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v54
        end

        local Walk = p33._tracks.Walk
        local _idle = p33._idle

        if v39 ~= p33._moving then
            p33._moving = v39

            if Walk and _idle then
                if v39 then
                    Walk:Play(0.2)
                    _idle:Stop(0.2)
                else
                    _idle:Play(0.25)
                    Walk:Stop(0.25)
                end
            end
        end

        if v39 and Walk then
            local v55 = Leg.ArriveAt - Leg.StartAt

            Walk:AdjustSpeed((math.clamp(if v55 <= 0 then 0 else Vector3.new(Leg.To.X - Leg.From.X, 0, Leg.To.Z - Leg.From.Z).Magnitude / v55 / math.max(ShootingStarFlags.WalkSpeedStuds:Get(), 1), 1, 2.4)))

            local TimePosition = Walk.TimePosition

            for _, v61 in t1 do
                if p33._lastWalkTime < v61 and v61 <= TimePosition then
                    p33._stepSide = -p33._stepSide
                    Fx.Sound(p33._stepSide > 0 and "BuddyStep1" or "BuddyStep2", p33.Root, nil, 0.9 + math.random() * 0.35)
                    p33:_footprint(Vector3.new(v37.X, p33._groundY, v37.Z), p33._yaw)
                end
            end

            p33._lastWalkTime = TimePosition
        end

        if _idle then
            _idle:SetSpeed(1 + p33._charge * 1.6)
            _idle:Step(p33.Noticed or p33._charge > 0)
        end

        if p33._blinkAt < elapsed then
            p33._blinkAt = elapsed + 2.2 + math.random() * 3
            p33:_blink()
        end

        local Sound, v62

        if not v39 and HumanoidRootPart and p33._chatterAt < elapsed and p33._charge <= 0 then
            p33._chatterAt = elapsed + 5 + math.random() * 5

            if (HumanoidRootPart.Position - v37).Magnitude < 45 then
                Sound = Fx.Sound
                v62 = if math.random() < 0.5 then "BuddyChatter1" else "BuddyChatter2"
                Sound(v62, p33.Root, nil, 1.45 + math.random() * 0.25)
                p33:_hop(0.9, 0.3)
            end
        end

        local v63 = elapsed - p33._hopAt
        local _hopSeconds, _hopHeight = p33._hopSeconds, p33._hopHeight
        local v65 = math.clamp(v63 / _hopSeconds, 0, 1)
        local v66 = v65 * 4 * (1 - v65) * _hopHeight
        local v67 = elapsed - p33._wobbleAt
        local v68 = if v67 < 0.6 then math.sin(v67 * 30) * (1 - v67 / 0.6) * 0.24434609527920614 else 0
        local _charge = p33._charge
        local identity = CFrame.identity
        local v70

        if _charge > 0 then
            local v71 = elapsed * 47
            local v72 = (_charge * 0.28 + 0.05) * _scale

            v70 = Vector3.new(math.noise(v71, 1.3), math.noise(v71, 2.7) * 0.5, math.noise(v71, 3.1)) * v72
            identity = CFrame.Angles(0, 0, math.noise(v71, 4.2) * math.rad(_charge * 10 + 4))
        else
            v70 = Vector3.new(0, 0, 0)
        end

        local v77 = _charge ^ 1.4 * 4.5 * _scale / 0.72
        local v78 = if p33._lift < v77 then 10 else 4

        p33._lift = p33._lift + (v77 - p33._lift) * (1 - math.exp(-v78 * p34))

        local v83 = math.sin(elapsed * 3.2) * 0.18 * math.min(p33._lift, 1)
        local v85 = Vector3.new(v37.X, p33._groundY + p33._groundOffset * _scale + v66 + p33._lift + v83, v37.Z)

        p33.Root.CFrame = CFrame.new(v85 + v70) * CFrame.Angles(0, p33._yaw, 0) * CFrame.Angles(0, 0, v68) * identity
    end
end

function t2.Position(p35) -- line: 470
    return p35.Root.Position
end

function t2.SetLeg(p36, p37, p38) -- line: 474
    -- upvalues: Fx (copy), ShootingStarFlags (copy)
    local Noticed = p36.Noticed

    p36.Leg = p37
    p36.Noticed = p38

    local v86 = not p38

    if v86 then
        local v87 = p37.ArriveAt - p37.StartAt

        v86 = (if v87 <= 0 then 0 else Vector3.new(p37.To.X - p37.From.X, 0, p37.To.Z - p37.From.Z).Magnitude / v87 / math.max(ShootingStarFlags.WalkSpeedStuds:Get(), 1)) >= 1.3
    end

    local v93 = v86 and not p36._running

    p36._running = v86

    if v93 and not p36._popping and not p36._gone then
        Fx.Sound("BuddyHuh", p36.Root, nil, 1.7 + math.random() * 0.15)
        p36:_hop(1.1, 0.28)
    elseif p38 and not Noticed and not p36._popping then
        Fx.Sound("BuddyNotice", p36.Root, nil, 1.15 + math.random() * 0.15)
        p36:_hop(1.6, 0.36)
        p36:_mark()
    elseif Noticed and not p38 and not p36._gone then
        Fx.Sound("BuddyHuh", p36.Root, nil, 1.4)
        p36._wobbleAt = os.clock()
    end

    p36:_refreshPrompt()
end

function t2._mark(p39) -- line: 495
    -- upvalues: TweenService (copy), Fx (copy)
    local clone = Fx.Kit():FindFirstChild("Ui"):FindFirstChild("Notice"):Clone()

    clone.Adornee = p39.Root
    clone.StudsOffsetWorldSpace = Vector3.new(0, 6 * p39._scale / 0.72, 0)
    clone.Enabled = true
    clone.Parent = p39.Model

    local Mark = clone:FindFirstChild("Mark")
    local UIScale = Mark:FindFirstChildOfClass("UIScale")

    UIScale.Scale = 0
    TweenService:Create(UIScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    task.delay(1.1, function() -- line: 510
        -- upvalues: clone (copy), Mark (copy), UIScale (copy), TweenService (copy)
        if clone.Parent == nil then
            return
        end

        local tween = TweenService:Create(Mark, TweenInfo.new(0.3), {
            TextTransparency = 1
        })

        tween:Play()
        TweenService:Create(UIScale, TweenInfo.new(0.3), {
            Scale = 0.6
        }):Play()
        tween.Completed:Wait()
        clone:Destroy()
    end)
end

function t2.PopOut(p40) -- line: 522
    -- upvalues: RunService (copy), Fx (copy)
    p40._popping = true
    p40:_refreshPrompt()

    local elapsed = os.clock()
    local To = p40.Leg.To
    local _scale = p40._scale
    local v95 = if math.random() < 0.5 then -1 else 1
    local t7 = {}
    local _trove = p40._trove

    Fx.Sound("BuddyPop", To, 0.9)
    p40.Model:ScaleTo(_scale * 0.25)

    local function makeDizzy() -- line: 534
        -- upvalues: p40 (copy), t7 (copy), _trove (copy)
        for i = 1, 3 do
            local Part = Instance.new("Part")

            Part.Name = "Dizzy"
            Part.Size = Vector3.new(0.2, 0.2, 0.2)
            Part.Transparency = 1
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false

            local BillboardGui = Instance.new("BillboardGui")

            BillboardGui.Size = UDim2.fromScale(0.9, 0.9)
            BillboardGui.LightInfluence = 0
            BillboardGui.Parent = Part

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Size = UDim2.fromScale(1, 1)
            ImageLabel.Image = "rbxassetid://97372292402278"

            if i == 2 then
                ImageLabel.ImageColor3 = Color3.fromRGB(255, 190, 220)
            else
                ImageLabel.ImageColor3 = Color3.fromRGB(255, 226, 110)
            end

            ImageLabel.Parent = BillboardGui
            Part.Parent = p40._parent
            _trove:Add(Part)
            table.insert(t7, Part)
        end
    end

    local connection
    local v96 = false
    local v97 = false

    connection = _trove:Connect(RunService.RenderStepped, function() -- line: 565
        -- upvalues: p40 (copy), elapsed (copy), To (copy), _scale (copy), t7 (copy), makeDizzy (copy), connection (ref), v96 (ref), v97 (ref), v95 (copy), Fx (copy)
        local v98 = os.clock() - elapsed
        local _groundY = p40._groundY

        if v98 < 0.75 then
            local v99 = v98 / 0.75
            local v101 = math.min(v99 * 1.6, 1) * 0.75 + 0.25

            p40.Model:ScaleTo(_scale * v101)

            local v102 = _scale * 6.5
            local v104 = math.clamp(v98 / 0.75, 0, 1)
            local v105 = v104 * 4 * (1 - v104) * v102

            p40._override = CFrame.new(To.X, _groundY + p40._groundOffset * _scale * v101 + v105, To.Z) * CFrame.Angles(0, p40._yaw + v95 * v99 * 3.141592653589793 * 4, 0)
        else
            if not v96 then
                v96 = true
                p40._override = nil
                p40.Model:ScaleTo(_scale)
                Fx.Sound("BuddyBoing", p40.Root, 0.5, 1.15)
                Fx.Emit("Collect", Vector3.new(To.X, _groundY + 0.5, To.Z), 0.8)
                p40:_footprint(Vector3.new(To.X, _groundY, To.Z), p40._yaw)
                p40._wobbleAt = os.clock() + 0.05
                makeDizzy()
            end

            local v107 = v98 - 0.75
            local v109 = p40.Root.Position + Vector3.new(0, _scale * 5.6 / 0.72, 0)

            for v110, v111 in t7 do
                local v112 = v107 * 6 + v110 * 3.141592653589793 * 2 / 3

                v111.CFrame = CFrame.new(v109 + Vector3.new(math.cos(v112) * 1.3, math.sin(v112 * 2) * 0.15, math.sin(v112) * 1.3) * _scale / 0.72)
            end

            if v107 < 1.5 then
                p40._wobbleAt = math.max(p40._wobbleAt, os.clock() - 0.3)
            else
                if not v97 then
                    v97 = true

                    for _, v118 in t7 do
                        Fx.Emit("Collect", v118.Position, 0.35)
                        v118:Destroy()
                    end

                    table.clear(t7)
                    Fx.Sound("BuddyGiggle", p40.Root, nil, 1.2)
                    p40:_hop(1.2, 0.32)
                    p40._wobbleAt = os.clock()
                end

                if v107 > 1.9 then
                    connection:Disconnect()
                    p40._popping = false
                    p40:_refreshPrompt()
                end
            end
        end
    end)
end

function t2.Charge(p41, p42) -- line: 628
    -- upvalues: Fx (copy)
    local v119 = math.clamp(p42, 0, 1)

    p41._charge = v119

    local Charge = p41.Model:FindFirstChild("Charge")

    if Charge then
        Charge.Enabled = v119 > 0
        Charge.FillTransparency = 1 - v119 * 0.3
        Charge.OutlineTransparency = 1 - v119 * 0.6
    end

    local _core = p41._core

    if _core then
        local Glow = _core:FindFirstChild("Glow")

        if Glow then
            Glow.Brightness = v119 * 0.6 + 1.2
            Glow.Range = v119 * 2 + 9
        end

        local Twinkles = _core:FindFirstChild("Twinkles")

        if Twinkles then
            Twinkles.Rate = v119 * 30 + 10
        end
    end

    if v119 > 0 and p41._tug == nil then
        p41._tug = Fx.Sound("BuddyTug", p41.Root, nil, 0.9)

        if p41._tug then
            p41._tug.Looped = true
            p41._trove:Add(p41._tug)
        end
    end

    if p41._tug then
        p41._tug.PlaybackSpeed = v119 * 0.55 + 0.9
    end
end

function t2.Release(p43, p44) -- line: 661
    -- upvalues: TweenService (copy), Fx (copy)
    local _tug = p43._tug

    p43._tug = nil

    if _tug then
        local tween = TweenService:Create(_tug, TweenInfo.new(0.15), {
            Volume = 0
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 667
            -- upvalues: _tug (copy)
            _tug:Destroy()
        end)
    end

    local v120 = p43._charge > 0.05

    p43:Charge(0)

    if not p44 and v120 then
        Fx.Sound("BuddyHuh", p43.Root, nil, 1.55)
        p43._wobbleAt = os.clock()
    end
end

function t2.Leave(p45) -- line: 679
    -- upvalues: RunService (copy), Fx (copy)
    if p45._gone then
        return
    end

    p45._gone = true
    p45:_refreshPrompt()
    p45:Release(true)

    local elapsed = os.clock()
    local _CFrame = p45.Root.CFrame
    local _core = p45._core

    if _core then
        local Twinkles = _core:FindFirstChild("Twinkles")

        if Twinkles then
            Twinkles.Rate = 50
        end
    end

    Fx.Sound("BuddyGiggle", p45.Root, nil, 1.05)
    p45:_hop(1.4, 0.34)
    task.delay(0.55, function() -- line: 697
        -- upvalues: p45 (copy), Fx (copy)
        Fx.Sound("BuddyOrbit", p45.Root, nil, 0.85)
    end)

    local _scale = p45._scale
    local connection

    connection = p45._trove:Connect(RunService.RenderStepped, function() -- line: 702
        -- upvalues: p45 (copy), elapsed (copy), _CFrame (copy), _scale (copy), connection (ref), Fx (copy)
        local v121 = os.clock() - elapsed - 0.55

        if v121 < 0 then
            return
        end

        local v123 = math.clamp(v121 / 2.4, 0, 1)
        local v124 = v123 * v123
        local v125 = v123 * 3.141592653589793 * 5
        local v129 = Vector3.new(math.cos(v125) * 3 * (1 - v123), v124 * 140, math.sin(v125) * 3 * (1 - v123))

        p45._override = CFrame.new(_CFrame.Position + v129) * CFrame.Angles(0, v125 * 2, 0)
        p45.Model:ScaleTo((math.max(_scale * (1 - v123 * 0.85), 0.05)))

        if not (v123 >= 1) then
            return
        end

        connection:Disconnect()
        Fx.Emit("Collect", p45.Root.Position, 0.6)
        p45:Destroy()
    end)
end

function t2.Detach(p46) -- line: 722
    local Model = p46.Model

    p46._detached = true
    p46._gone = true
    p46.Prompt:Destroy()
    p46:Release(true)
    p46._trove:Destroy()

    for _, v131 in p46._tracks do
        v131:Stop(0.1)
    end

    if p46._idle then
        p46._idle:Stop(0.1)
    end

    return Model
end

function t2.Destroy(p47) -- line: 738
    p47._gone = true
    p47._trove:Destroy()

    if not p47._detached then
        p47.Model:Destroy()
    end
end

return t2

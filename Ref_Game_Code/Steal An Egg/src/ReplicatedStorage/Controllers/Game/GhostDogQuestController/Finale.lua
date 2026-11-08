-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Cast = require(script.Parent.Cast)
local Cine = require(script.Parent.Cine)
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Hud = require(script.Parent.Hud)
local Npcs = require(script.Parent.Npcs)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Speech = require(script.Parent.Speech)
local Swim = require(script.Parent.Swim)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local GhostDogQuest2, Sounds = ReplicatedStorage.Assets.GhostDogQuest, ReplicatedStorage.Assets.Sounds
local ChestOpen, Chomp = Sounds.MonsterParasite.ChestOpen, Sounds.MonsterParasite.Chomp
local Rumble, Pop, Swoosh, HeavyLand = Sounds.ScrambleBoss.Rumble, Sounds.ScrambleBoss.Pop, Sounds.ScrambleBoss.Swoosh, Sounds.ScrambleBoss.HeavyLand
local Legendary = Sounds.PrizeSounds.Legendary
local CollectSecretRing = Sounds.LightVsDarknessSounds.CollectSecretRing
local SlideLoop, SlideHit = Sounds.BeanstalkEvent.SlideLoop, Sounds.BeanstalkEvent.SlideHit
local v1 = Color3.fromRGB(255, 214, 120)
local v2 = Color3.fromRGB(14, 52, 64)
local t1 = {}

local function bezier(p1, p2, p3, p4, p5) -- line: 79
    local v3 = 1 - p5

    return p1 * (v3 * v3 * v3) + p2 * (v3 * 3 * v3 * p5) + p3 * (v3 * 3 * p5 * p5) + p4 * (p5 * p5 * p5)
end

local function run(p6, p7) -- line: 84
    local elapsed = os.clock()
    local elapsed2 = elapsed

    while true do
        local elapsed3 = os.clock()
        local v5 = math.min((elapsed3 - elapsed) / p6, 1)

        p7(v5, elapsed3 - elapsed2)

        if v5 >= 1 then
            break
        end

        elapsed2 = elapsed3
        task.wait()
    end
end

local function puppet(p8, p9, p10) -- line: 99
    local v6 = p9.CFrame
    local v7 = true

    p8:BindToRenderStep(p10, Enum.RenderPriority.Character.Value, function() -- line: 102
        -- upvalues: p9 (copy), v6 (ref), v7 (ref)
        if not v7 then
            return
        end

        p9.CFrame = v6
        p9.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        p9.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)

    return {
        Set = function(p11) -- Set | line: 110
            -- upvalues: p9 (copy), v6 (ref), v7 (ref)
            v6 = p11

            if v7 then
                p9.CFrame = p11
            end
        end,
        Get = function() -- Get | line: 116
            -- upvalues: v6 (ref)
            return v6
        end,
        Stop = function() -- Stop | line: 119
            -- upvalues: v7 (ref)
            v7 = false
        end
    }
end

local function fishLevel(p12, p13) -- line: 125
    -- upvalues: Workspace (copy)
    local v8 = RaycastParams.new()

    v8.FilterType = Enum.RaycastFilterType.Exclude
    v8.FilterDescendantsInstances = p13

    local v9 = Workspace:Raycast(p12 + Vector3.new(0, 30, 0), Vector3.new(0, -90, 0), v8)
    local v10 = if v9 then v9.Position.Y else p12.Y - 3

    return (Vector3.new(p12.X, math.max(p12.Y, v10 + 10), p12.Z))
end

local function flatUnit(p14, p15) -- line: 134
    local v13 = p14 * Vector3.new(1, 0, 1)

    if v13.Magnitude > 0.05 then
        return v13.Unit
    end

    return p15
end

local function chaseAlong(p16) -- line: 139
    -- upvalues: GhostDogQuest (copy)
    local Chase = GhostDogQuest.Chase
    local v14 = p16 - Chase.Center

    return (math.atan2(v14.Z, v14.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius
end

local function fishFacing(p17, p18) -- line: 146
    return CFrame.lookAt(p17, (Vector3.new(p18.X, p17.Y, p18.Z))) * CFrame.new(0, -8, 0)
end

local function exclaim(p19, p20) -- line: 150
    -- upvalues: Fx (copy), LocalPlayer (copy), Pop (copy)
    local Head = p20:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        local v15 = p19:Add(Instance.new("BillboardGui"))

        v15.Size = UDim2.fromScale(3, 3)
        v15.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
        v15.AlwaysOnTop = true
        v15.Adornee = Head

        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.Text = "!"
        TextLabel.TextScaled = true
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
        TextLabel.TextColor3 = Color3.fromRGB(255, 225, 90)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 4
        UIStroke.Parent = TextLabel

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = TextLabel
        TextLabel.Parent = v15
        v15.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        Fx.Punch(UIScale, 2.2, 0.35)
        Fx.Play(Pop, {
            Volume = 0.7,
            PlaybackSpeed = 1.5
        })
        task.delay(1.4, function() -- line: 176
            -- upvalues: v15 (copy)
            v15:Destroy()
        end)
    end
end

local function partsOf(p21) -- line: 181
    local t3 = {}

    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t3, descendant)
        end
    end

    return t3
end

local function playAnimation(p22, p23, p24, p25) -- line: 191
    local v16 = p22:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v16 and v16:FindFirstChildOfClass("Animator")
    local Animations = p22:FindFirstChild("Animations")
    local v17 = Animations and Animations:FindFirstChild(p23)

    if Animator and v17 and v17:IsA("Animation") then
        local track = Animator:LoadAnimation(v17)

        track.Looped = p24
        track:Play(0.1, 1, p25 or 1)

        return track
    end

    return nil
end

local function swimTrack(p26, p27) -- line: 210
    -- upvalues: playAnimation (copy)
    local v18 = p26:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v18 and v18:FindFirstChildOfClass("Animator")

    if Animator then
        for _, v19 in Animator:GetPlayingAnimationTracks() do
            if v19.Animation and v19.Animation.Name == "GhostFish_Swim" then
                v19:AdjustSpeed(p27)

                return v19
            end
        end
    end

    return (playAnimation(p26, "GhostFish_Swim", true, p27))
end

local function lidParts(p28) -- line: 224
    local Lid = p28:FindFirstChild("Lid")
    local Pivot = Lid:GetAttribute("Pivot")
    local _CFrame = p28.PrimaryPart and p28.PrimaryPart.CFrame or p28:GetPivot()
    local v20 = if typeof(Pivot) == "Vector3" then Pivot - Vector3.new(0, 0.5, 0) else Vector3.new(0, 0, 0)
    local v21 = _CFrame * CFrame.new(v20)
    local t4 = {}
    local t5 = {}

    for _, descendant in Lid:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t4, descendant)
            table.insert(t5, v21:ToObjectSpace(descendant.CFrame))
        end
    end

    return t4, t5, v21
end

local function poseLid(p29, p30, p31, p32) -- line: 243
    -- upvalues: Workspace (copy)
    local v22 = p31 * CFrame.Angles(math.rad(p32), 0, 0)
    local v23 = table.create(#p29)

    for v24, v25 in p30 do
        v23[v24] = v22 * v25
    end

    Workspace:BulkMoveTo(p29, v23, Enum.BulkMoveMode.FireCFrameChanged)
end

local function shaft(p33, p34, p35, p36, p37) -- line: 252
    -- upvalues: Workspace (copy)
    local v26 = p33:Add(Instance.new("Part"))

    v26.Anchored = true
    v26.CanCollide = false
    v26.CanQuery = false
    v26.CanTouch = false
    v26.Transparency = 1
    v26.Size = Vector3.new(1, 1, 1)
    v26.CFrame = CFrame.new(p34)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v26

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, p35, 0)
    Attachment2.Parent = v26

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Width0 = p37
    Beam.Width1 = p37 * 2.2
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.Color = ColorSequence.new(p36)
    Beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    Beam.Parent = v26
    v26.Parent = Workspace

    return Beam
end

local function setBeamAlpha(p38, p39, p40) -- line: 289
    p38.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p39),
        NumberSequenceKeypoint.new(1, p40)
    })
end

local function ticketModel(p41, p42) -- line: 296
    -- upvalues: Workspace (copy), GhostDogQuest2 (copy)
    local v27 = p41:Add(GhostDogQuest2.Ticket:Clone())

    v27.Name = "GhostDogTicket"
    v27:PivotTo(CFrame.new(p42))
    v27.Parent = Workspace

    return v27
end

local function sizeTicket(p43, p44) -- line: 304
    p43:ScaleTo((math.max(p44 * 1.4, 0.01)))
end

local function textAlpha(p45, p46, p47) -- line: 308
    -- upvalues: Fx (copy)
    local UIStroke = p45:FindFirstChildOfClass("UIStroke")

    if p46 <= 0 then
        p45.TextTransparency = p47

        if UIStroke then
            UIStroke.Transparency = p47
        end
    else
        Fx.Tween(p45, p46, {
            TextTransparency = p47
        })

        if UIStroke then
            Fx.Tween(UIStroke, p46, {
                Transparency = p47
            })
        end
    end
end

local function stageTicketView(p48) -- line: 323
    -- upvalues: GhostDogQuest2 (copy)
    for _, child in p48:GetChildren() do
        if child:IsA("Model") or child:IsA("Camera") then
            child:Destroy()
        end
    end

    local clone = GhostDogQuest2.Ticket:Clone()

    clone:PivotTo(CFrame.identity)

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    local v29 = CFrame.new(-BoundingBox.Position)

    clone:PivotTo(v29)
    clone.Parent = p48

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30

    local UIAspectRatioConstraint = p48:FindFirstChildOfClass("UIAspectRatioConstraint")
    local v30 = if UIAspectRatioConstraint then UIAspectRatioConstraint.AspectRatio else 2.2
    local v33 = math.tan((math.rad(Camera.FieldOfView / 2)))
    local v36 = math.max(BoundingBox2.X * 0.5 / (v33 * v30), BoundingBox2.Y * 0.5 / v33) * 1.12 + BoundingBox2.Z * 0.5

    Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, -v36), (Vector3.new(0, 0, 0)))
    Camera.Parent = p48
    p48.CurrentCamera = Camera

    return clone, v29
end

local function revealTicket() -- line: 349
    -- upvalues: UserInputService (copy), Fx (copy), Hud (copy), Legendary (copy), CollectSecretRing (copy), textAlpha (copy), stageTicketView (copy)
    local v38 = Hud.Ticket()

    if v38 == nil then
        return
    end

    local View = v38:FindFirstChild("View")
    local Title, UIScale, v39

    if View ~= nil then
        if View:IsA("ViewportFrame") then
            Title = v38.Title
            v38.Card.Visible = false
            UIScale = View:FindFirstChildOfClass("UIScale")

            if UIScale == nil then
                UIScale = Instance.new("UIScale")
                UIScale.Parent = View
            end

            v39 = false
        else
            v39 = true
        end
    else
        v39 = true
    end

    if v39 then
        warn("GhostDogQuest: Ticket.View ViewportFrame is missing from GhostDogQuestUI")

        return
    end

    local v40, v41 = stageTicketView(View)
    local ViewPosition = View.Position

    v38.Visible = true
    View.Visible = true
    v38.Dim.BackgroundTransparency = 1

    local Tap = v38.Tap
    local UIStroke = Tap:FindFirstChildOfClass("UIStroke")

    Tap.TextTransparency = 1

    if UIStroke then
        UIStroke.Transparency = 1
    end

    local UIStroke2 = Title:FindFirstChildOfClass("UIStroke")

    Title.TextTransparency = 1

    if UIStroke2 then
        UIStroke2.Transparency = 1
    end

    local Sub = v38.Sub
    local UIStroke3 = Sub:FindFirstChildOfClass("UIStroke")

    Sub.TextTransparency = 1

    if UIStroke3 then
        UIStroke3.Transparency = 1
    end

    v38.Rays.ImageTransparency = 1
    Fx.Tween(v38.Dim, 0.3, {
        BackgroundTransparency = 0.35
    })
    View.Position = UDim2.fromScale(ViewPosition.X.Scale, -0.4)
    View.Rotation = -25
    UIScale.Scale = 1

    local elapsed = os.clock()

    task.spawn(function() -- line: 380
        -- upvalues: v38 (copy), v40 (copy), v41 (copy), elapsed (copy)
        while v38.Visible and v40.Parent do
            local v42 = os.clock() - elapsed
            local v44 = math.max(0, 1 - v42 / 0.9)

            v40:PivotTo(CFrame.Angles(math.sin(v42 * 1.3) * 0.10471975511965978, v44 * v44 * 3.141592653589793 * 4 + math.sin(v42 * 0.9) * 0.3141592653589793, 0) * v41 + Vector3.new(0, math.sin(v42 * 2) * 0.04, 0))
            task.wait()
        end
    end)
    Fx.Tween(View, 0.55, {
        Rotation = 4,
        Position = ViewPosition
    }, Enum.EasingStyle.Back)
    Fx.Play(Legendary, {
        Volume = 0.6
    })
    task.wait(0.5)
    Fx.Tween(View, 0.3, {
        Rotation = 0
    }, Enum.EasingStyle.Sine)
    Fx.Tween(v38.Rays, 0.5, {
        ImageTransparency = 0.25
    })
    task.spawn(function() -- line: 401
        -- upvalues: v38 (copy)
        while v38.Visible do
            v38.Rays.Rotation += 0.6
            task.wait()
        end
    end)
    task.wait(0.4)
    Fx.Play(CollectSecretRing, {
        Volume = 0.6
    })
    Fx.Punch(UIScale, 1.08, 0.3)

    local UIScale2 = Title:FindFirstChildOfClass("UIScale")
    local UIStroke4 = Title:FindFirstChildOfClass("UIStroke")

    Title.TextTransparency = 0

    if UIStroke4 then
        UIStroke4.Transparency = 0
    end

    if UIScale2 then
        Fx.Punch(UIScale2, 1.5, 0.4)
    end

    textAlpha(v38.Sub, 0.4, 0)
    task.wait(0.6)
    textAlpha(v38.Tap, 0.4, 0.45)

    local v52 = false
    local connection = v38.Catch.Activated:Connect(function() -- line: 419
        -- upvalues: v52 (ref)
        v52 = true
    end)
    local connection2 = UserInputService.InputBegan:Connect(function(p49) -- line: 422
        -- upvalues: v52 (ref)
        if p49.KeyCode == Enum.KeyCode.E or p49.KeyCode == Enum.KeyCode.ButtonA or p49.KeyCode == Enum.KeyCode.Space then
            v52 = true
        end
    end)
    local elapsed2 = os.clock()

    while not v52 and os.clock() - elapsed2 < 2.6 do
        task.wait()
    end

    connection:Disconnect()
    connection2:Disconnect()
    Fx.Tween(View, 0.35, {
        Rotation = 15,
        Position = UDim2.fromScale(ViewPosition.X.Scale, 1.4)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Fx.Tween(v38.Dim, 0.35, {
        BackgroundTransparency = 1
    })
    textAlpha(Title, 0.3, 1)
    textAlpha(v38.Sub, 0.3, 1)
    textAlpha(v38.Tap, 0.3, 1)
    Fx.Tween(v38.Rays, 0.3, {
        ImageTransparency = 1
    })
    task.wait(0.4)
    v38.Visible = false
    View.Position = ViewPosition
    View.Rotation = 0
    v40:Destroy()
end

local function claim() -- line: 456
    -- upvalues: Remotes (copy)
    for _ = 1, 4 do
        local function v53() -- line: 458
            -- upvalues: Remotes (copy)
            return Remotes.GhostDogQuest.Claim:InvokeServer()
        end

        local ok, result = pcall(v53)

        if ok and result == true then
            return true
        end

        task.wait(0.7)
    end

    return false
end

function t1.Play(p50, p51, p52, _, p54, p55) -- line: 469
    -- upvalues: Lighting (copy), RunService (copy), Workspace (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Remotes (copy), Swim (copy), LocalPlayer (copy), GhostDogQuest2 (copy), ChestOpen (copy), Chomp (copy), Rumble (copy), Pop (copy), Swoosh (copy), Legendary (copy), CollectSecretRing (copy), SlideLoop (copy), v1 (copy), v2 (copy), run (copy), puppet (copy), fishLevel (copy), exclaim (copy), partsOf (copy), playAnimation (copy), swimTrack (copy), lidParts (copy), poseLid (copy), shaft (copy), setBeamAlpha (copy), claim (copy)
    local function stillAlive() -- line: 477
        -- upvalues: p54 (copy)
        if p54 == nil then
            return true
        end

        return (p54())
    end

    local v54 = Hud.Get()
    local Character = LocalPlayer.Character
    local v55 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v56 = Character and Character:FindFirstChildOfClass("Humanoid")
    local CurrentCamera, v57, FieldOfView, GhostDogFinalePuppet, Swim2, t6, Pivot, LookVector, v58, RightVector, v59, v60, v61, v62

    if v54 == nil or Character == nil or v55 == nil then
        v62 = true
    elseif not v55:IsA("BasePart") or v56 == nil then
        v62 = true
    else
        CurrentCamera = Workspace.CurrentCamera
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        v57 = Cine.RestingFov()
        FieldOfView = CurrentCamera.FieldOfView
        GhostDogFinalePuppet = puppet(p50, v55, "GhostDogFinalePuppet")
        Swim2 = Swim.Start(p50, Character, "Swim")
        t6 = {}
        t6[1] = nil
        task.spawn(((function(p56)
            return function() -- line: 500
                -- upvalues: p56 (copy), claim (copy)
                p56[1] = claim()
            end
        end)(t6)))
        Pivot = p52:GetPivot()
        LookVector = Pivot.LookVector

        local lookAt = v56.HipHeight + v55.Size.Y * 0.5

        v56 = Pivot.Position + LookVector * 7.5 + Vector3.new(0, lookAt, 0)
        lookAt = CFrame.lookAt

        local X = Pivot.X
        local Y = v56.Y

        v58 = lookAt(v56, (Vector3.new(X, Y, Pivot.Z)))
        RightVector = v58.RightVector
        v59 = Pivot.Position + LookVector * 13 + RightVector * 8 + Vector3.new(0, 4.5, 0)
        v60 = Pivot.Position + Vector3.new(0, 2, 0)

        local Z = v58.LookVector * Vector3.new(1, 0, 1)

        v61 = if Z.Magnitude > 0.05 then Z.Unit else Vector3.new(0, 0, 1)
        v62 = false
    end

    if v62 then
        return false
    end

    local v63
    local t7 = {}
    local v64, v65, v66, v67, v68, Y, Z, v69, Y2, ChaseFrame

    if p55 and p55.Parent then
        v64 = p55
        v69 = p55:GetPivot()

        local v70 = v69.LookVector * Vector3.new(1, 0, 1)

        v63 = if v70.Magnitude > 0.05 then v70.Unit else v61
        t7[1] = (v69 * CFrame.new(0, 8, 0)).Position
        v65 = 16
        v66 = 16
        v67 = swimTrack(p55, 0.6)
        v68 = p55
    else
        v68 = p50:Clone(GhostDogQuest2.GhostFish)
        v64 = v68
        v63 = v61

        local Position = fishLevel(Pivot.Position + v61 * 30 + RightVector * 6, { Character, v68 })

        t7[1] = Position
        v65 = 16
        v66 = 4.5

        local v71 = Position + v61

        Y2 = CFrame.lookAt
        ChaseFrame = v71.X
        Y = Position.Y
        Z = v71.Z
        v68:PivotTo(Y2(Position, (Vector3.new(ChaseFrame, Y, Z))) * CFrame.new(0, -8, 0))
        v68.Parent = Workspace
        v67 = playAnimation(v68, "GhostFish_Swim", true, 0.6)
    end

    v69 = {
        Character,
        v68
    }

    local v72 = true

    local function chaseY(p57) -- line: 543
        -- upvalues: p51 (copy), GhostDogQuest (copy)
        local ChaseFrame, Chase = GhostDogQuest.ChaseFrame, GhostDogQuest.Chase
        local v73 = p57 - Chase.Center

        return ChaseFrame(p51, (math.atan2(v73.Z, v73.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius).Y
    end

    Y2 = t7[1].Y

    local v74 = t7[1]

    ChaseFrame = GhostDogQuest.ChaseFrame

    local Chase = GhostDogQuest.Chase
    local v75 = v74 - Chase.Center
    local Z2 = v75.Z
    local v77 = Y2 - ChaseFrame(p51, (math.atan2(Z2, v75.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius).Y

    for _, descendant in v68:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name == "EyeGlow" and descendant:FindFirstChildOfClass("PointLight") == nil then
            descendant.Color = Color3.fromRGB(255, 60, 70)
            Z = Instance.new("PointLight")
            Z.Color = Color3.fromRGB(255, 50, 60)
            Z.Range = 12
            Z.Brightness = 4
            Z.Parent = descendant
        end
    end

    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = Color3.fromRGB(255, 40, 60)
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = Color3.fromRGB(255, 70, 80)
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = v68
    p50:Connect(RunService.RenderStepped, function(p58) -- line: 571
        -- upvalues: p51 (copy), v58 (ref), v64 (ref), v63 (ref), t7 (copy), v65 (ref), v66 (ref), v67 (ref), v72 (ref), v77 (copy), GhostDogQuest (copy)
        if not v72 then
            return
        end

        local v79 = math.clamp((210 - ((t7[1] - v58.Position) * Vector3.new(1, 0, 1)).Magnitude) / 60, 0.3, 1)
        local ChaseFrame = GhostDogQuest.ChaseFrame
        local v80 = t7[1]
        local Chase = GhostDogQuest.Chase
        local v81 = v80 - Chase.Center
        local LookVector = ChaseFrame(p51, (math.atan2(v81.Z, v81.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius).LookVector
        local v82 = v63
        local v83 = LookVector * Vector3.new(1, 0, 1)

        if v83.Magnitude > 0.05 then
            v82 = v83.Unit
        end

        if v82:Dot(v63) > 0 then
            v63 = v63:Lerp(v82, (math.min(p58 * 1.5, 1))).Unit
        end

        v66 += (v65 * v79 - v66) * math.min(p58 * 2, 1)
        t7[1] += v63 * v66 * p58

        local v89 = t7[1]
        local ChaseFrame2, Chase2 = GhostDogQuest.ChaseFrame, GhostDogQuest.Chase
        local v90 = v89 - Chase2.Center
        local v91 = ChaseFrame2(p51, (math.atan2(v90.Z, v90.X) - Chase2.StartAngle) % 6.283185307179586 * Chase2.Radius).Y + v77

        t7[1] = Vector3.new(t7[1].X, t7[1].Y + (v91 - t7[1].Y) * math.min(p58 * 3, 1), t7[1].Z)

        if v67 then
            v67:AdjustSpeed(v66 * 0.09 + 0.35)
        end

        local v96 = v64
        local v97 = t7[1]
        local v98 = t7[1] + v63

        v96:PivotTo(CFrame.lookAt(v97, (Vector3.new(v98.X, v97.Y, v98.Z))) * CFrame.new(0, -8, 0) * CFrame.Angles(0, 0, math.sin(os.clock() * 2.2) * 0.06))
    end)

    local v101 = shaft(p50, Pivot.Position + Vector3.new(0, 1, 0), 60, Color3.fromRGB(170, 230, 255), 6)
    local v102 = p52:FindFirstChild("Glow", true)
    local v103 = p52:FindFirstChild("Light", true)

    Y = p52:FindFirstChild("Burst", true)

    local Sparkle = Y and Y:FindFirstChild("Sparkle")
    local v104 = GhostDogFinalePuppet.Get()
    local CFramePosition = CurrentCamera.CFrame.Position
    local v105 = CFramePosition + CurrentCamera.CFrame.LookVector * 20
    local v106 = CFramePosition + Vector3.new(0, 6, 0)
    local v107 = v59 + LookVector * 6 + Vector3.new(0, 4, 0)

    run(2.1, function(p59) -- line: 618
        -- upvalues: CurrentCamera (ref), v57 (ref), FieldOfView (ref), GhostDogFinalePuppet (ref), v58 (ref), v59 (ref), v60 (ref), v101 (copy), v104 (copy), CFramePosition (copy), v105 (copy), v106 (copy), v107 (copy), Fx (copy), setBeamAlpha (copy)
        local v108 = Fx.Ease(p59, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v110 = math.sin(p59 * 18) * (1 - p59) * 0.12

        GhostDogFinalePuppet.Set(v104:Lerp(v58, v108) * CFrame.Angles(math.sin(p59 * 3.141592653589793) * -0.6108652381980153 + v110, 0, 0))

        local lookAt = CFrame.lookAt
        local v113 = 1 - v108

        CurrentCamera.CFrame = lookAt(CFramePosition * (v113 * v113 * v113) + v106 * (v113 * 3 * v113 * v108) + v107 * (v113 * 3 * v108 * v108) + v59 * (v108 * v108 * v108), v105:Lerp(v60, v108))
        CurrentCamera.FieldOfView = FieldOfView + (v57 - FieldOfView) * v108
        setBeamAlpha(v101, 1 - v108 * 0.6, 1)
    end)

    if Swim2 then
        Swim2.Set("Idle")
    end

    local v76 = os.clock()

    while t6[1] == nil and os.clock() - v76 < 6 do
        task.wait()
    end

    if t6[1] == true and (p54 == nil or p54()) then
        if p52:FindFirstChild("Lid") == nil then
            GhostDogFinalePuppet.Stop()

            return false
        end

        local v114, v115, v116 = lidParts(p52)
        local v117 = Fx.Play(Rumble, {
            Volume = 0.7,
            Looped = true,
            PlaybackSpeed = 0.8
        })

        if v117 then
            p50:Add(v117)
        end

        local v118 = partsOf(p52)
        local t8 = {}

        for v119, v120 in v118 do
            t8[v119] = Pivot:ToObjectSpace(v120.CFrame)
        end

        local v121 = p52:FindFirstChild("Lock", true)
        local v122 = false
        local v123 = v59:Lerp(v60, 0.35)
        local Pivot2 = Pivot
        local CurrentCamera2 = CurrentCamera
        local v124 = v59
        local v125 = v60
        local v126 = v57
        local LookVector2 = LookVector

        run(2.4, function(p60) -- line: 662
            -- upvalues: v102 (copy), v103 (copy), v114 (copy), v115 (copy), v116 (copy), v117 (copy), v118 (copy), t8 (copy), v121 (copy), v122 (ref), v123 (copy), Pivot2 (copy), CurrentCamera2 (copy), v124 (copy), v125 (copy), v126 (copy), LookVector2 (copy), Sparkle (copy), Workspace (copy), Fx (copy), Pop (copy), v1 (copy), run (copy), poseLid (copy)
            local v127 = p60 * p60 * 0.35
            local v130 = CFrame.new(math.noise(os.clock() * 25, 1) * v127, math.abs((math.noise(os.clock() * 30, 2))) * v127, math.noise(os.clock() * 25, 3) * v127) * CFrame.Angles(0, 0, math.noise(os.clock() * 20, 4) * v127 * 0.2)
            local v131 = table.create(#v118)

            for v132, v133 in t8 do
                v131[v132] = Pivot2 * v130 * v133
            end

            Workspace:BulkMoveTo(v118, v131, Enum.BulkMoveMode.FireCFrameChanged)
            poseLid(v114, v115, Pivot2 * v130 * Pivot2:ToObjectSpace(v116), math.max(0, (math.sin(os.clock() * 40))) * p60 * 6)

            if v102 then
                v102.Color = v1:Lerp(Color3.new(1, 1, 1), p60 * 0.5)
            end

            if v103 then
                v103.Brightness = p60 * 4
                v103.Range = p60 * 14 + 10
            end

            if Sparkle then
                Sparkle.Rate = p60 * 30
            end

            if v117 then
                v117.Volume = p60 * 0.6 + 0.3
            end

            local v137 = Fx.Ease(p60, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            CurrentCamera2.CFrame = CFrame.lookAt(v124:Lerp(v123, v137), v125) * CFrame.Angles(0, 0, math.noise(os.clock() * 12, 9) * p60 * 0.02)
            CurrentCamera2.FieldOfView = v126 - v137 * 16

            local v138 = true

            if v122 then
            elseif p60 >= 0.72 and v121 then
                v122 = true

                local v139 = table.find(v118, v121)

                if v139 then
                    table.remove(v118, v139)
                    table.remove(t8, v139)
                end

                v138 = false
            end

            if v138 then
                return
            end

            Fx.Play(Pop, {
                Volume = 0.8,
                PlaybackSpeed = 0.7
            })
            Fx.Burst(v121.Position, v1, 16, 14, 0.6)

            local _CFrame = v121.CFrame
            local v140 = LookVector2 * 6 + Vector3.new(0, 7, 0)

            task.spawn(function() -- line: 708
                -- upvalues: _CFrame (copy), v140 (copy), v121 (copy), run (copy)
                run(0.7, function(p61) -- line: 709
                    -- upvalues: _CFrame (copy), v140 (copy), v121 (copy)
                    v121.CFrame = (_CFrame + v140 * p61 - Vector3.new(0, p61 * 14 * p61, 0)) * CFrame.Angles(p61 * 9, p61 * 5, 0)
                    v121.Transparency = math.max(0, p61 - 0.6) / 0.4
                end)
            end)
        end)

        if v117 then
            v117:Destroy()
        end

        local v144 = table.create(#v118)

        for v145, v146 in t8 do
            v144[v145] = Pivot * v146
        end

        Workspace:BulkMoveTo(v118, v144, Enum.BulkMoveMode.FireCFrameChanged)
        Fx.Play(ChestOpen, {
            Volume = 1
        })
        Fx.Play(Legendary, {
            Volume = 0.7
        })
        Fx.Flash(v1, 0.7, 0.02, 0.6)
        Fx.Shake(2.2, 0.45)

        if Sparkle then
            Sparkle.Rate = 0
            Sparkle:Emit(90)
        end

        Fx.Burst(Pivot.Position + Vector3.new(0, 3.5, 0), v1, 50, 26, 1.1)

        local v147 = shaft(p50, Pivot.Position + Vector3.new(0, 3, 0), 22, v1, 2.5)

        setBeamAlpha(v147, 0.05, 1)
        task.spawn(function() -- line: 736
            -- upvalues: v101 (copy), v147 (copy), run (copy), setBeamAlpha (copy)
            run(0.7, function(p62) -- line: 737
                -- upvalues: v101 (copy), v147 (copy), setBeamAlpha (copy)
                setBeamAlpha(v147, p62 * 0.95 + 0.05, 1)
                setBeamAlpha(v101, p62 * 0.6 + 0.4, 1)
            end)
        end)

        local FieldOfView = CurrentCamera.FieldOfView

        run(0.55, function(p63) -- line: 743
            -- upvalues: v114 (copy), v115 (copy), v116 (copy), CurrentCamera2 (copy), FieldOfView (copy), Fx (copy), poseLid (copy)
            poseLid(v114, v115, v116, Fx.Ease(p63, Enum.EasingStyle.Back, Enum.EasingDirection.Out) * 108)
            CurrentCamera2.FieldOfView = FieldOfView + math.sin(p63 * 3.141592653589793) * 10 + p63 * 6
        end)

        if v102 then
            Fx.Tween(v102, 0.6, {
                Color = v1
            })
        end

        local v150 = Pivot.Position + Vector3.new(0, 3, 0)
        local v151 = p50:Add(GhostDogQuest2.Ticket:Clone())

        v151.Name = "GhostDogTicket"
        v151:PivotTo(CFrame.new(v150))
        v151.Parent = Workspace
        v151:ScaleTo(0.27999999999999997)

        local v152 = Pivot.Position + LookVector * 2.5 + Vector3.new(0, 7.5, 0)
        local v153 = Pivot.Position + Vector3.new(0, 3, 0)
        local v154 = v152 + LookVector * 6.5 + RightVector * 1.2 + Vector3.new(0, 0.4, 0)
        local new = Lighting:FindFirstChild("GhostDogUnderwaterBlur")

        if new and new:IsA("BlurEffect") then
            Fx.Tween(new, 0.4, {
                Size = 0
            })
        end

        new = Lighting:FindFirstChild("GhostDogUnderwater")

        if new and new:IsA("ColorCorrectionEffect") then
            Fx.Tween(new, 0.4, {
                Contrast = 0.05,
                TintColor = Color3.fromRGB(215, 240, 255)
            })
        end

        local CFramePosition = CurrentCamera.CFrame.Position
        local FieldOfView2 = CurrentCamera.FieldOfView

        run(1.4, function(p64) -- line: 771
            -- upvalues: CurrentCamera2 (copy), v125 (copy), v151 (copy), v152 (copy), v153 (copy), v154 (copy), CFramePosition (copy), FieldOfView2 (copy), Fx (copy)
            local v155 = Fx.Ease(p64, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local v156 = v153:Lerp(v152, v155)

            v151:ScaleTo((math.max((0.2 + v155 * 0.8) * 1.4, 0.01)))
            v151:PivotTo(CFrame.lookAt(v156, CurrentCamera2.CFrame.Position) * CFrame.Angles(0, (1 - v155) * 3.141592653589793 * 6, 0))
            CurrentCamera2.CFrame = CFrame.lookAt(CFramePosition:Lerp(v154, v155), v125:Lerp(v152, v155))
            CurrentCamera2.FieldOfView = FieldOfView2 + (50 - FieldOfView2) * v155
        end)
        Fx.Play(CollectSecretRing, {
            Volume = 0.7
        })
        Fx.Burst(v152, Color3.fromRGB(150, 255, 190), 30, 12, 0.7)
        Hud.Caption(GhostDogQuest.Captions.Ticket)

        local _CFrame = CurrentCamera.CFrame

        run(2.2, function(p65) -- line: 786
            -- upvalues: CurrentCamera2 (copy), v151 (copy), v152 (copy), _CFrame (copy), Fx (copy)
            v151:PivotTo(CFrame.lookAt(v152 + Vector3.new(0, math.sin(p65 * 3.141592653589793 * 2) * 0.25, 0), _CFrame.Position) * CFrame.Angles(0, math.sin(p65 * 3.141592653589793 * 2) * 0.17453292519943295, math.sin(p65 * 3.141592653589793 * 3) * 0.04))
            CurrentCamera2.CFrame = _CFrame * CFrame.new(0, 0, -p65 * 0.8)

            if not (math.random() < 0.05) then
                return
            end

            Fx.Burst(v152 + Vector3.new(math.random() * 4 - 2, math.random() * 2 - 1, 0), Color3.fromRGB(255, 245, 200), 3, 4, 0.35)
        end)
        Hud.Caption(nil)

        local Pivot3 = v151:GetPivot()
        local _CFrame2, FieldOfView3 = CurrentCamera.CFrame, CurrentCamera.FieldOfView
        local v166 = CFrame.lookAt(v58.Position + RightVector * 6 + LookVector * 2.5 + Vector3.new(0, 2, 0), (v152 + v58.Position) * 0.5)

        run(0.4, function(p66) -- line: 817
            -- upvalues: CurrentCamera2 (copy), v126 (copy), _CFrame2 (copy), FieldOfView3 (copy), v166 (copy), Fx (copy)
            local v167 = Fx.Ease(p66, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

            CurrentCamera2.CFrame = _CFrame2:Lerp(v166, v167)
            CurrentCamera2.FieldOfView = FieldOfView3 + (v126 - FieldOfView3) * v167
        end)

        local function catchAt() -- line: 822
            -- upvalues: v55 (copy)
            return v55.Position + Vector3.new(0, 0.6, 0) + v55.CFrame.LookVector * 0.6
        end

        local v169 = (Pivot3.Position + (v55.Position + Vector3.new(0, 0.6, 0) + v55.CFrame.LookVector * 0.6)) * 0.5 + Vector3.new(0, 3, 0)

        Fx.Play(Swoosh, {
            Volume = 0.6,
            PlaybackSpeed = 1.2
        })
        run(0.55, function(p67) -- line: 827
            -- upvalues: CurrentCamera2 (copy), v151 (copy), Pivot3 (copy), v169 (copy), v55 (copy), Fx (copy)
            local v170 = Fx.Ease(p67, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v171 = v55.Position + Vector3.new(0, 0.6, 0) + v55.CFrame.LookVector * 0.6
            local v172 = 1 - v170
            local v173 = Pivot3.Position * (v172 * v172) + v169 * (2 * v172 * v170) + v171 * (v170 * v170)

            v151:PivotTo(CFrame.lookAt(v173, CurrentCamera2.CFrame.Position) * CFrame.Angles(0, v170 * 3.141592653589793 * 4, 0))
            v151:ScaleTo((math.max((1 - v170 * 0.85) * 1.4, 0.01)))
        end)
        v151:Destroy()
        Fx.Play(Pop, {
            Volume = 0.9,
            PlaybackSpeed = 1.3
        })
        Fx.Burst(v55.Position + Vector3.new(0, 0.6, 0) + v55.CFrame.LookVector * 0.6, Color3.fromRGB(150, 255, 190), 34, 16, 0.8)
        Fx.Flash(Color3.fromRGB(190, 255, 215), 0.3, 0.02, 0.3)
        Fx.Shake(0.8, 0.2)

        if p54 ~= nil and not p54() then
            GhostDogFinalePuppet.Stop()

            return false
        end

        local GhostDogChaseMusic = game:GetService("SoundService"):FindFirstChild("GhostDogChaseMusic")

        if GhostDogChaseMusic ~= nil and not GhostDogChaseMusic:IsA("Sound") then
            GhostDogChaseMusic = nil
        end

        if GhostDogChaseMusic then
            local Volume = GhostDogChaseMusic.Volume

            Fx.Tween(GhostDogChaseMusic, 0.6, {
                Volume = 0
            })

            local GhostDogChaseMusic2 = GhostDogChaseMusic

            p50:Add(function() -- line: 854
                -- upvalues: Volume (copy), GhostDogChaseMusic2 (copy)
                if GhostDogChaseMusic2.Parent then
                    GhostDogChaseMusic2.Volume = Volume
                end
            end)
        end

        local v175 = p50:Add(Instance.new("ColorCorrectionEffect"))

        v175.Parent = Lighting

        local v176 = Fx.Play(GhostDogQuest.Sounds.GrowlLong, {
            Volume = 0.3
        })

        if v176 then
            p50:Add(v176)
        end

        local Position = v58.Position

        Position = (t7[1] - Position) * Vector3.new(1, 0, 1)

        if Position.Magnitude > 0.05 then
            v61 = Position.Unit
        end

        local v177 = v58
        local v178 = v61
        local RightVector2 = RightVector
        local _CFrame3, FieldOfView4 = CurrentCamera.CFrame, CurrentCamera.FieldOfView

        run(1.3, function(p68) -- line: 880
            -- upvalues: t7 (copy), Highlight (copy), CurrentCamera2 (copy), v126 (copy), v175 (copy), v176 (copy), v177 (copy), v178 (copy), RightVector2 (copy), _CFrame3 (copy), FieldOfView4 (copy), Fx (copy)
            local v179 = Fx.Ease(p68, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v181 = Fx.Ease(math.clamp((((t7[1] - v177.Position) * Vector3.new(1, 0, 1)).Magnitude - 42) / 168, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) * v179
            local v182 = v177.Position - v178 * 6 + RightVector2 * 3.5 + Vector3.new(0, 2.5, 0)

            CurrentCamera2.CFrame = _CFrame3:Lerp(CFrame.lookAt(v182, t7[1]:Lerp(v177.Position, 0.2)), v179)
            CurrentCamera2.FieldOfView = FieldOfView4 + (v126 - 8 - FieldOfView4) * v179 - v181 * 14
            v175.Brightness = -0.06 * v179
            v175.Saturation = -0.12 * v179
            Highlight.OutlineTransparency = 1 - v181 * 0.4

            if v176 then
                v176.Volume = 0.3 + v181 * 0.3
            end
        end)
        run(0.45, function(p69) -- line: 892
            -- upvalues: t7 (copy), Highlight (copy), CurrentCamera2 (copy), v126 (copy), v176 (copy), v177 (copy), v178 (copy), RightVector2 (copy), Fx (copy)
            local v183 = Fx.Ease(p69, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v185 = Fx.Ease(math.clamp((((t7[1] - v177.Position) * Vector3.new(1, 0, 1)).Magnitude - 42) / 168, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v186 = v177.Position - v178 * 6 + RightVector2 * 3.5 + Vector3.new(0, 2.5, 0)

            CurrentCamera2.CFrame = CFrame.lookAt(v186, t7[1]:Lerp(v177.Position, 0.2)) * CFrame.new(0, 0, -v183 * 1.2)
            CurrentCamera2.FieldOfView = v126 - 8 - v185 * 14
            Highlight.OutlineTransparency = 1 - v185 * 0.4

            if v176 then
                v176.Volume = v185 * 0.3 + 0.3
            end
        end)
        v72 = false

        if p54 ~= nil and not p54() then
            GhostDogFinalePuppet.Stop()

            return false
        end

        local v187 = fishLevel(v58.Position + v61 * 11, v69)
        local Unit = (v187 - t7[1]) * Vector3.new(1, 0, 1)

        Unit = if Unit.Magnitude > 0.1 then Unit.Unit else -v63

        local v190 = math.acos((math.clamp(v63:Dot(Unit), -1, 1)))
        local v191 = if v63:Cross(Unit).Y >= 0 then 1 else -1
        local v192 = GhostDogFinalePuppet.Get()
        local v193 = v63
        local t9 = {}

        t9[1] = v193

        local v194 = v66
        local v195 = false
        local OutlineTransparency = Highlight.OutlineTransparency

        Fx.Play(GhostDogQuest.Sounds.FishTurn, {
            Volume = 0.8
        })

        local GhostDogFinalePuppet2 = GhostDogFinalePuppet

        run(0.5, function(p70, p71) -- line: 918
            -- upvalues: p50 (copy), Character (copy), v64 (ref), v63 (ref), t7 (copy), v67 (ref), Highlight (copy), CurrentCamera2 (copy), v175 (copy), v176 (copy), v177 (copy), v178 (copy), RightVector2 (copy), v190 (copy), v192 (copy), t9 (copy), v194 (copy), v195 (ref), OutlineTransparency (copy), v191 (copy), GhostDogFinalePuppet2 (copy), Fx (copy), exclaim (copy)
            local v196 = Fx.Ease(p70, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

            t9[1] = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v190 * v191 * v196):VectorToWorldSpace(v63)
            t7[1] += t9[1] * (v194 * (1 - v196) + 12 * v196) * p71

            local v197 = v64
            local v198 = t7[1]
            local v199 = t7[1] + t9[1]

            v197:PivotTo(CFrame.lookAt(v198, (Vector3.new(v199.X, v198.Y, v199.Z))) * CFrame.new(0, -8, 0) * CFrame.Angles(0, 0, -v191 * math.sin(p70 * 3.141592653589793) * 0.45))

            if v67 then
                local v203 = v67

                v203:AdjustSpeed(1.1 + v196 * 0.9)
            end

            Highlight.FillTransparency = 1 - 0.15 * v196
            Highlight.OutlineTransparency = OutlineTransparency + (0.3 - OutlineTransparency) * v196
            v175.Brightness = -0.06 - 0.12 * v196
            v175.Saturation = -0.12 - 0.23 * v196
            v175.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(255, 200, 200), v196)

            if v176 then
                v176.Volume = 0.6 + v196 * 0.4
            end

            local v205 = Fx.Ease((math.clamp((p70 - 0.3) / 0.5, 0, 1)))

            if p70 > 0.4 and not v195 then
                v195 = true
                exclaim(p50, Character)
            end

            GhostDogFinalePuppet2.Set(v192 * CFrame.new(0, 0, 0.6 * v205) * CFrame.Angles(0.17453292519943295 * v205, 0, 0))

            local v206 = v177.Position - v178 * 6 + RightVector2 * 3.5 + Vector3.new(0, 2.5, 0)

            CurrentCamera2.CFrame = CFrame.lookAt(v206, t7[1]:Lerp(v177.Position, 0.2)) * CFrame.new(0, 0, -1.2) * CFrame.Angles(0, 0, math.noise(os.clock() * 6, 11) * v196 * 0.02)
        end)

        if v176 then
            Fx.Tween(v176, 0.35, {
                Volume = 0
            })
        end

        Fx.Play(GhostDogQuest.Sounds.GrowlShort, {
            Volume = 1
        })
        Fx.Shake(1.6, 0.5)
        playAnimation(v64, "GhostFish_Bite", false, 0.9)

        if v67 then
            v67:AdjustSpeed(2.4)
        end

        local v207 = v58.Position + RightVector * 14 + v61 * 10 + Vector3.new(0, 4, 0)
        local v208 = t7[1]
        local _CFrame4, FieldOfView5 = CurrentCamera.CFrame, CurrentCamera.FieldOfView
        local v210 = math.clamp((v187 - v208).Magnitude / 90, 0.5, 3)
        local Y = v208.Y
        local v211, Chase = GhostDogQuest.ChaseFrame, GhostDogQuest.Chase
        local Chase2 = v208 - Chase.Center
        local Z = Chase2.Z
        local v212 = Y - v211(p51, (math.atan2(Z, Chase2.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius).Y

        v211 = v187.Y

        local ChaseFrame = GhostDogQuest.ChaseFrame

        Chase2 = GhostDogQuest.Chase

        local v213 = v187 - Chase2.Center
        local Z2 = v213.Z
        local X = v213.X
        local v214 = v211 - ChaseFrame(p51, (math.atan2(Z2, X) - Chase2.StartAngle) % 6.283185307179586 * Chase2.Radius).Y

        run(v210, function(p72) -- line: 967
            -- upvalues: p51 (copy), v64 (ref), CurrentCamera2 (copy), v126 (copy), v177 (copy), v187 (copy), Unit (ref), v207 (copy), v208 (copy), _CFrame4 (copy), FieldOfView5 (copy), v212 (copy), v214 (copy), Fx (copy), GhostDogQuest (copy)
            local v215 = p72 * 0.25 + p72 * p72 * 0.75
            local v216 = v208:Lerp(v187, v215)
            local X = v216.X
            local ChaseFrame, Chase = GhostDogQuest.ChaseFrame, GhostDogQuest.Chase
            local v217 = v216 - Chase.Center
            local v219 = Vector3.new(X, ChaseFrame(p51, (math.atan2(v217.Z, v217.X) - Chase.StartAngle) % 6.283185307179586 * Chase.Radius).Y + v212 + (v214 - v212) * v215, v216.Z)
            local v220 = v64
            local v221 = v219 + Unit

            v220:PivotTo(CFrame.lookAt(v219, (Vector3.new(v221.X, v219.Y, v221.Z))) * CFrame.new(0, -8, 0))

            local v223 = Fx.Ease(math.min(p72 / 0.55, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

            CurrentCamera2.CFrame = _CFrame4:Lerp(CFrame.lookAt(v207, v219:Lerp(v177.Position, 0.35)), v223) * CFrame.Angles(0, 0, math.noise(os.clock() * 16, 5) * p72 * 0.03)
            CurrentCamera2.FieldOfView = FieldOfView5 + (v126 - 16 - FieldOfView5) * p72

            if p72 > 0.7 and math.random() < 0.12 then
                Fx.Shake(p72 + 0.5, 0.12)
            end
        end)
        Fx.Play(Chomp, {
            Volume = 1
        })
        Fx.Play(GhostDogQuest.Sounds.PulledUnder, {
            Volume = 1
        })
        Fx.Flash(Color3.fromRGB(160, 255, 225), 0.6, 0.02, 0.4)
        Fx.Shake(3.5, 0.6)
        v211 = v64:FindFirstChild("MouthGlow", true)

        if v211 then
            local Attachment = Instance.new("Attachment")

            Attachment.Parent = v211
            ChaseFrame = p50:Add(Instance.new("Attachment"))
            ChaseFrame.Parent = v55

            local Beam = Instance.new("Beam")

            Beam.Attachment0 = Attachment
            Beam.Attachment1 = ChaseFrame
            Beam.Width0 = 0.35
            Beam.Width1 = 0.35
            Beam.LightEmission = 1
            Beam.FaceCamera = true
            Beam.Color = ColorSequence.new(Fx.Ghost)
            Beam.Parent = v211
        end

        task.wait(0.25)

        local v224 = p50:Add(Instance.new("BlurEffect"))

        v224.Size = 0
        v224.Parent = Lighting

        local v225 = GhostDogFinalePuppet.Get()
        local Pivot4 = v64:GetPivot()
        local v226 = v225.Position + Unit * 40 + Vector3.new(0, 55, 0)

        Chase = Fx.Play(SlideLoop, {
            Volume = 0.7,
            Looped = true,
            PlaybackSpeed = 1.6
        })

        if Chase then
            p50:Add(Chase)
        end

        Hud.Bubbles(1.6, 70)

        if Swim2 then
            Swim2.Set("Swim", 1.8)
        end

        local v227 = Hud.FadeFrame()

        if v227 then
            v227.BackgroundColor3 = v2
        end

        run(2, function(p73) -- line: 1027
            -- upvalues: v64 (ref), CurrentCamera2 (copy), v126 (copy), v175 (copy), Unit (ref), GhostDogFinalePuppet2 (copy), v207 (copy), v224 (copy), v225 (copy), Pivot4 (copy), v226 (copy), v227 (copy), Fx (copy)
            local v228 = Fx.Ease(p73, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v229 = v225.Position:Lerp(v226, v228)

            GhostDogFinalePuppet2.Set(CFrame.lookAt(v229, v229 + (v226 - v225.Position).Unit) * CFrame.Angles(-1.3962634015954636, 0, p73 * 9))

            local v230 = v64

            v230:PivotTo(Pivot4 + (v229 - v225.Position) * 1.08 + Unit * 4 * v228)
            CurrentCamera2.CFrame = CFrame.lookAt(v207:Lerp(v229 - Vector3.new(0, 6, 0) - Unit * 8, v228 * 0.6), v229)
            CurrentCamera2.FieldOfView = v126 + v228 * 30
            v224.Size = v228 * 18
            v175.Brightness = -0.18 * (1 - v228)

            if v227 then
                v227.BackgroundTransparency = 1 - math.clamp((p73 - 0.8) / 0.2, 0, 1)
            end
        end)

        if Chase then
            Chase:Destroy()
        end

        Chase = false
        GhostDogFinalePuppet.Stop()

        for _ = 1, 3 do
            X = function() -- line: 1052
                -- upvalues: Remotes (copy)
                return Remotes.GhostDogQuest.Surface:InvokeServer()
            end

            Z2, X = pcall(X)

            if Z2 and X == true then
                Chase = true
                break
            end

            Chase = false
            task.wait(0.5)
        end

        return Chase
    end

    GhostDogFinalePuppet.Stop()

    return false
end

function t1.Rescue(p74, p75, p76) -- line: 1064
    -- upvalues: Workspace (copy), Cast (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Npcs (copy), Speech (copy), Swim (copy), LocalPlayer (copy), Swoosh (copy), HeavyLand (copy), SlideLoop (copy), SlideHit (copy), v2 (copy), run (copy), puppet (copy), revealTicket (copy)
    local v232 = Hud.Get()
    local Character = LocalPlayer.Character
    local v233, v234

    if Character then
        v233 = Character:FindFirstChild("HumanoidRootPart")
        v234 = Character:FindFirstChildOfClass("Humanoid")
    else
        v234 = Character
        v233 = Character
    end

    local ReturnSpot = p75:FindFirstChild("ReturnSpot")
    local CastTarget = p75:FindFirstChild("CastTarget")

    if v232 == nil
        or Character == nil
        or v233 == nil
        or not v233:IsA("BasePart")
        or v234 == nil
        or ReturnSpot == nil
        or not ReturnSpot:IsA("BasePart")
        or CastTarget == nil
        or not CastTarget:IsA("BasePart") then
        return
    end

    local function stillAlive() -- line: 1084
        -- upvalues: p76 (copy)
        if p76 == nil then
            return true
        end

        return (p76())
    end

    local v235 = p74:Extend()

    Cast.LockControls(v235)

    local v236 = Cine.Take(p74)

    p74:Add(function() -- line: 1090
        -- upvalues: v236 (copy), LocalPlayer (copy)
        if v236.CameraType ~= Enum.CameraType.Scriptable then
            return
        end

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        v236.CameraType = Enum.CameraType.Custom

        if Humanoid then
            v236.CameraSubject = Humanoid
        end
    end)
    v236.FieldOfView = Cine.RestingFov()

    local _CFrame = ReturnSpot.CFrame
    local CastTargetPosition = CastTarget.Position
    local v237 = Npcs.Fisherman()
    local v238 = Npcs.Dog()

    Npcs.SetRodVisible(true)

    local v239 = Hud.FadeFrame()

    if v239 == nil then
        return
    end

    v239.BackgroundColor3 = v2
    v239.BackgroundTransparency = 0
    Hud.Caption(GhostDogQuest.Captions.Rescue)

    local elapsed = os.clock()

    while (v233.Position - _CFrame.Position).Magnitude > 25 and os.clock() - elapsed < 6 do
        task.wait()
    end

    if (v233.Position - _CFrame.Position).Magnitude > 25 or p76 ~= nil and not p76() then
        Hud.Caption(nil)
        Fx.Tween(v239, 0.4, {
            BackgroundTransparency = 1
        })

        return
    end

    v234.PlatformStand = true

    local v240 = v234

    p74:Add(function() -- line: 1123
        -- upvalues: v239 (copy), v240 (copy), Hud (copy)
        v240.PlatformStand = false
        v239.BackgroundColor3 = Color3.new(0, 0, 0)
        Hud.Caption(nil)
    end)

    local GhostDogRescuePuppet = puppet(p74, v233, "GhostDogRescuePuppet")
    local Idle = Swim.Start(p74, Character, "Idle")
    local v241 = CastTargetPosition.Y + 0.3
    local v242 = CFrame.new(CastTargetPosition - Vector3.new(0, 6, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)
    local v243 = CFrame.new(CastTargetPosition - Vector3.new(0, 1.6, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)

    GhostDogRescuePuppet.Set(v242)

    local CFramePosition = _CFrame.Position
    local v244 = (CastTargetPosition - CFramePosition) * Vector3.new(1, 0, 1)
    local v245 = if v244.Magnitude > 0.1 then v244.Unit else -_CFrame.LookVector
    local Unit = (Vector3.new(0, 1, 0)):Cross(v245).Unit
    local v246 = if v237 then v237.Rig.Root.Position else CFramePosition - v245 * 4
    local t10 = {}

    if v237 then
        table.insert(t10, v237.Model)
    end

    if v238 then
        table.insert(t10, v238.Model)
    end

    local v247 = v234.HipHeight + v233.Size.Y * 0.5
    local v248 = RaycastParams.new()

    v248.FilterType = Enum.RaycastFilterType.Exclude

    local t11 = {
        Character
    }

    for _, v249 in t10 do
        table.insert(t11, v249)
    end

    v248.FilterDescendantsInstances = t11
    v248.RespectCanCollide = true

    local v250 = CFramePosition + Vector3.new(0, 3, 0)

    if not ((CastTargetPosition - (v246 + Unit)).Magnitude < (CastTargetPosition - (v246 - Unit)).Magnitude) then
        Unit = -Unit
    end

    for _, v251 in { Unit, -Unit, -v245 } do
        local v253 = Workspace:Raycast(v246 + v251 * 4.5 + Vector3.new(0, 6, 0), Vector3.new(0, -16, 0), v248)

        if v253 and v253.Material ~= Enum.Material.Water then
            v250 = v253.Position + Vector3.new(0, v247, 0)
            break
        end
    end

    local v254 = (v246 - v250) * Vector3.new(1, 0, 1)
    local v255 = if v254.Magnitude > 0.1 then v254.Unit else _CFrame.LookVector
    local v256 = CFrame.lookAt(v250, v250 + v255)
    local v257 = Vector3.new(CastTargetPosition.X, v241, CastTargetPosition.Z)
    local v258 = v250 - v257
    local v259 = -v245
    local v260 = v258 * Vector3.new(1, 0, 1)

    if v260.Magnitude > 0.05 then
        v259 = v260.Unit
    end

    local Unit2 = (Vector3.new(0, 1, 0)):Cross(v259).Unit
    local v261 = v257 + Vector3.new(0, 6, 0)
    local v262 = v257 + Vector3.new(0, 11, 0)
    local v263 = v257:Lerp(v250, 0.6) + Vector3.new(0, 2, 0)
    local v264 = Cine.Unclip(v263, v257 - v259 * 7 + Unit2 * 5 + Vector3.new(0, 4.5, 0), t10)
    local v265 = v262 - v259 * 2 + Vector3.new(0, 1.5, 0)
    local v266 = v264 + Vector3.new(0, 4, 0) + Unit2 * 1.5
    local v267 = Cine.SpeedLens(0.3, 22)
    local v268 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.3141592653589793)

    local function topDown(p77, p78) -- line: 1189
        -- upvalues: v257 (copy), v259 (ref), v268 (copy)
        local v269 = v268:Lerp(CFrame.identity, p78):VectorToWorldSpace(v259)

        return CFrame.lookAt(p77, v257, v269)
    end

    local Cut = Cine.Cut
    local v270 = v268:Lerp(CFrame.identity, 0):VectorToWorldSpace(v259)

    Cut(CFrame.lookAt(v261, v257, v270), 60)

    local v271, Root, v272

    if v237 then
        local Root2 = v237.Rig.Root
        local v273 = Vector3.new(v257.X, Root2.Y, v257.Z)
        local v274

        if (v273 - Root2.Position).Magnitude > 0.5 then
            v274 = CFrame.lookAt(Root2.Position, v273)
        else
            Root2 = nil
        end

        v272 = v274
        v237.Rig:SetMood("Reel")

        local v275 = v237.Model:FindFirstChild("RodTip", true)

        if v275 and v275:IsA("Attachment") then
            local v276 = p74:Add(Instance.new("Attachment"))

            v276.Parent = v233
            v271 = p74:Add(Instance.new("Beam"))
            v271.Attachment0 = v275
            v271.Attachment1 = v276
            v271.Width0 = 0.14
            v271.Width1 = 0.14
            v271.LightEmission = 1
            v271.FaceCamera = true
            v271.Color = ColorSequence.new(Fx.Ghost)
            v271.Parent = Workspace
        end

        Root = Root2
    end

    if v238 then
        v238.Rig:SetMood("Happy")
    end

    local v277 = Fx.Play(SlideLoop, {
        Volume = 0.6,
        Looped = true,
        PlaybackSpeed = 1.9
    })

    if v277 then
        p74:Add(v277)
    end

    Fx.Tween(v239, 0.45, {
        BackgroundTransparency = 1
    })

    local elapsed2 = os.clock()
    local elapsed3 = elapsed2

    while true do
        local elapsed = os.clock()
        local v279 = math.min(elapsed - elapsed2, 2.1500000000000004)
        local v280 = elapsed - elapsed3
        local v281 = v279 / 2.1500000000000004

        if v237 and Root and v272 then
            v237.Rig:SetRoot(Root:Lerp(v272, Fx.Ease((math.min(v279 / 0.4, 1)))))
        end

        GhostDogRescuePuppet.Set(v242:Lerp(v243, v281 * v281) * CFrame.Angles(0, 0, math.sin(v281 * 25) * 0.15))

        if math.random() < 0.15 then
            Fx.Ripple(v257, v281 + 0.5)
        end

        if v271 then
            v271.CurveSize0 = math.sin(elapsed * 30) * (1 - v281) * 1.5
        end

        local v286

        if v279 < 1.1 then
            local v287 = v279 / 1.1
            local v288 = Fx.Ease(v287, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v289 = v261:Lerp(v262, v288)
            local v290 = v268:Lerp(CFrame.identity, v288):VectorToWorldSpace(v259)

            v286 = CFrame.lookAt(v289, v257, v290)
        else
            local v291 = (v279 - 1.1) / 1.05
            local v292 = Fx.Ease(v291, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v293 = 1 - v292
            local v294 = v262 * (v293 * v293 * v293) + v265 * (v293 * 3 * v293 * v292) + v266 * (v293 * 3 * v292 * v292) + v264 * (v292 * v292 * v292)
            local v295 = v259:Lerp(Vector3.new(0, 1, 0), v292)

            v286 = CFrame.lookAt(v294, v257:Lerp(v263, v292), v295.Unit)
        end

        v236.CFrame = v286 * CFrame.Angles(0, 0, math.noise(elapsed * 10, 7) * v281 * 0.01)
        v236.FieldOfView = v267(v286.Position, v280, 60)

        if v279 >= 2.1500000000000004 then
            break
        end

        elapsed3 = elapsed
        task.wait()
    end

    Hud.Caption(nil)

    if v277 then
        v277:Destroy()
    end

    Fx.Splash(v257, 2)
    Fx.Play(GhostDogQuest.Sounds.Splash, {
        Volume = 1
    })
    Fx.Play(Swoosh, {
        Volume = 0.8,
        PlaybackSpeed = 0.9
    })
    Fx.Shake(1.6, 0.3)

    if Idle then
        Idle.Set("Swim", 2)
    end

    if v237 then
        v237.Rig:SetMood("Reel")
    end

    local v297 = Vector3.new(CastTargetPosition.X, v241 + 1, CastTargetPosition.Z)
    local v299 = math.clamp((v250 - v297).Magnitude * 0.15, 2.5, 5)
    local Rotation = v243.Rotation
    local v300 = v264 + v259 * 2.5 + Vector3.new(0, 1, 0)

    run(0.85, function(p79, p80) -- line: 1290
        -- upvalues: v236 (copy), GhostDogRescuePuppet (copy), v250 (ref), v256 (copy), v263 (copy), v264 (copy), v267 (copy), v297 (copy), v299 (copy), Rotation (copy), v300 (copy), Fx (copy)
        local v301 = Fx.Ease(p79, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v305 = v297:Lerp(v250, v301) + Vector3.new(0, math.sin(p79 * 3.141592653589793) * v299, 0)

        GhostDogRescuePuppet.Set(CFrame.new(v305) * Rotation:Lerp(v256.Rotation, v301))

        local v306 = v264:Lerp(v300, Fx.Ease(p79, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

        v236.CFrame = CFrame.lookAt(v306, v263:Lerp(v305, 0.55))
        v236.FieldOfView = v267(v306, p80, 60 - math.sin(p79 * 3.141592653589793) * 4)
    end)
    GhostDogRescuePuppet.Set(v256)
    Swim.Stop()

    if v271 then
        v271:Destroy()
    end

    Fx.Play(SlideHit, {
        Volume = 0.6
    })
    Fx.Play(HeavyLand, {
        Volume = 0.3,
        PlaybackSpeed = 1.3
    })
    Fx.Shake(0.8, 0.25)

    local Burst = Fx.Burst
    local v308 = Vector3.new(0, v247, 0)

    Burst(v250 - v308, Color3.fromRGB(200, 255, 240), 14, 8, 0.6)

    if v237 then
        v237.Rig:SetMood("Pet")
    end

    if v238 then
        v238.Rig:SetMood("Spin")
    end

    local v309 = v246 + Vector3.new(0, 5.8, 0)

    Cine.Blend(Cine.TwoShot(v250, v309, 1, 11, 3, t10), 0.6, 55)
    task.wait(0.5)

    if v238 then
        v238.Rig:SetMood("Happy")
    end

    GhostDogRescuePuppet.Stop()
    v233.CFrame = v256
    v234.PlatformStand = false

    if p76 == nil or p76() then
        Cine.Release(v234, v233)
        v235:Clean()

        if v237 then
            Npcs.FacePlayer(v237)
            v237.Rig:SetMood("Talk")
            task.wait(0.35)
            Speech.Say(v237.Model, v237.Head, GhostDogQuest.Lines.Rescue, {
                WalkAway = 40,
                Voice = v237.Voice,
                OnLine = function(p81) -- OnLine | line: 1338
                    -- upvalues: v238 (copy)
                    if v238 and p81 == 3 then
                        v238.Rig:SetMood("Happy")
                    end
                end
            })
            v237.Rig:SetMood("Idle")
        end

        revealTicket()

        if v237 then
            v237.Rig:SetMood("Cheer")
            task.delay(2.5, function() -- line: 1349
                -- upvalues: v237 (copy)
                if v237.Model.Parent then
                    v237.Rig:SetMood("Idle")
                end
            end)
        end

        if v238 then
            v238.Rig:SetMood("Happy")
        end
    end
end

return table.freeze(t1)

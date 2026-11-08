-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GhostDogQuestFlags = require(ReplicatedStorage.Shared.Flags.GhostDogQuestFlags)
local Cine = require(script.Parent.Cine)
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Hud = require(script.Parent.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Swim = require(script.Parent.Swim)

require(ReplicatedStorage.Packages.Trove)

local WhaleHearts = require(ReplicatedStorage.Controllers.Game.AdminAbuseClientController.Events.BeanstalkEvent.WhaleHearts)
local LocalPlayer = Players.LocalPlayer
local GhostDogQuest2, Sounds = ReplicatedStorage.Assets.GhostDogQuest, ReplicatedStorage.Assets.Sounds
local Chase = GhostDogQuest.Chase
local t1 = {
    -1, 0, 1
}
local Stage3 = Sounds.BeanstalkEvent.Music.Stage3
local Explosion = Sounds.Explosion
local WhaleHeartBreak, WhaleNearMiss = Sounds.BeanstalkEvent.WhaleHeartBreak, Sounds.BeanstalkEvent.WhaleNearMiss
local Swoosh, Shatter = Sounds.ScrambleBoss.Swoosh, Sounds.ScrambleBoss.Shatter
local v1 = Color3.fromRGB(110, 240, 255)
local v2 = Color3.fromRGB(255, 60, 70)
local v3 = Color3.fromRGB(190, 230, 255)
local v4 = Color3.fromRGB(255, 60, 80)
local t2 = {}

local function seabedPart(p1, p2, p3, p4, p5, p6) -- line: 100
    local Part = Instance.new("Part")

    Part.Name = p2
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Size = p3
    Part.CFrame = p4
    Part.Color = p5
    Part.Material = p6
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Parent = p1

    return Part
end

local function buildScene(p7, p8, p9, p10) -- line: 125
    -- upvalues: Workspace (copy), Fx (copy), GhostDogQuest (copy), GhostDogQuest2 (copy), v1 (copy)
    local v5 = p7:Add(Instance.new("Folder"))

    v5.Name = "GhostDogChaseScene"

    local v6 = Random.new(p8 * 977 + 13)
    local v7 = p9 + 22 + 300
    local n1 = 0

    for i = -40, v7, 30 do
        local v8 = GhostDogQuest.ChaseFrame(p8, i + 15) * CFrame.new(0, -11, 0)
        local v9 = v8 * CFrame.new(0, -1.5, 0)
        local v10 = Color3.fromRGB(46, 66, 84)
        local Sand = Enum.Material.Sand
        local Part = Instance.new("Part")

        Part.Name = "Seabed"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Size = Vector3.new(84, 3, 32)
        Part.CFrame = v9
        Part.Color = v10
        Part.Material = Sand
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Parent = v5

        for _, v11 in { -1, 1 } do
            local v12 = v8 * CFrame.new(v11 * 15, 0.12, 0)
            local Neon = Enum.Material.Neon
            local Part = Instance.new("Part")

            Part.Name = "Edge"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Size = Vector3.new(0.9, 0.25, 30.5)
            Part.CFrame = v12
            Part.Color = v1
            Part.Material = Neon
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Parent = v5
            Part.Transparency = 0.15
        end

        local v13 = v8 * CFrame.new(0, 0.12, 0)
        local Neon = Enum.Material.Neon
        local Part2 = Instance.new("Part")

        Part2.Name = "Spine"
        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.CanTouch = false
        Part2.CastShadow = false
        Part2.Size = Vector3.new(0.5, 0.2, 13.5)
        Part2.CFrame = v13
        Part2.Color = v1
        Part2.Material = Neon
        Part2.TopSurface = Enum.SurfaceType.Smooth
        Part2.BottomSurface = Enum.SurfaceType.Smooth
        Part2.Parent = v5
        Part2.Transparency = 0.55

        local v14 = v8 * CFrame.new(0, 0.06, 0)
        local v15 = Color3.fromRGB(40, 120, 150)
        local Neon2 = Enum.Material.Neon
        local Part3 = Instance.new("Part")

        Part3.Name = "Track"
        Part3.Anchored = true
        Part3.CanCollide = false
        Part3.CanQuery = false
        Part3.CanTouch = false
        Part3.CastShadow = false
        Part3.Size = Vector3.new(30, 0.1, 30.5)
        Part3.CFrame = v14
        Part3.Color = v15
        Part3.Material = Neon2
        Part3.TopSurface = Enum.SurfaceType.Smooth
        Part3.BottomSurface = Enum.SurfaceType.Smooth
        Part3.Parent = v5
        Part3.Transparency = 0.82

        for _, v16 in { -1, 1 } do
            for _ = 1, 2 do
                local v17 = v6:NextNumber(7, 18)
                local v19 = Vector3.new(v17, v17 * v6:NextNumber(0.8, 1.8), v17)
                local v20 = v8 * CFrame.new(v16 * (34 + v6:NextNumber(0, 12)), v17 * 0.35, v6:NextNumber(-15, 15)) * CFrame.Angles(v6:NextNumber(-0.5, 0.5), v6:NextNumber(0, 6), v6:NextNumber(-0.5, 0.5))
                local v21 = Color3.fromRGB(38 + v6:NextInteger(0, 18), 50 + v6:NextInteger(0, 18), 72 + v6:NextInteger(0, 18))
                local Slate = Enum.Material.Slate
                local Part = Instance.new("Part")

                Part.Name = "Rock"
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Size = v19
                Part.CFrame = v20
                Part.Color = v21
                Part.Material = Slate
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Parent = v5
                Part.Transparency = 0
            end

            if v6:NextNumber() < 0.75 then
                local v22 = v8 * CFrame.new(v16 * v6:NextNumber(18, 28), 0, v6:NextNumber(-12, 12))
                local v23 = v6:NextInteger(4, 7)
                local v24 = v6:NextNumber(-0.25, 0.25)

                for j = 1, v23 do
                    local v25 = v22 * CFrame.new(0, 1.6, 0)
                    local v26 = Color3.fromRGB(40, j * 8 + 120, 90)
                    local Grass = Enum.Material.Grass
                    local Part = Instance.new("Part")

                    Part.Name = "Kelp"
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanQuery = false
                    Part.CanTouch = false
                    Part.CastShadow = false
                    Part.Size = Vector3.new(0.6, 3.2, 1.3)
                    Part.CFrame = v25
                    Part.Color = v26
                    Part.Material = Grass
                    Part.TopSurface = Enum.SurfaceType.Smooth
                    Part.BottomSurface = Enum.SurfaceType.Smooth
                    Part.Parent = v5
                    Part.Transparency = 0.1
                    v22 = v22 * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0, v24)
                end

                local v27 = Color3.fromRGB(150, 255, 200)
                local Neon = Enum.Material.Neon
                local Part = Instance.new("Part")

                Part.Name = "KelpGlow"
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Size = Vector3.new(1.2, 1.2, 1.2)
                Part.CFrame = v22
                Part.Color = v27
                Part.Material = Neon
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Parent = v5
                Part.Shape = Enum.PartType.Ball
            end

            if v6:NextNumber() < 0.35 then
                local v28 = v8 * CFrame.new(v16 * v6:NextNumber(10, 16), 0.6, v6:NextNumber(-12, 12))
                local v29 = if v6:NextNumber() < 0.5 then Color3.fromRGB(255, 120, 220) else Color3.fromRGB(180, 140, 255)
                local Neon = Enum.Material.Neon
                local Part = Instance.new("Part")

                Part.Name = "Anemone"
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Size = Vector3.new(2.4, 1.6, 2.4)
                Part.CFrame = v28
                Part.Color = v29
                Part.Material = Neon
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Parent = v5
                Part.Shape = Enum.PartType.Ball
                Part.Transparency = 0.2
            end
        end

        if v6:NextNumber() < 0.18 then
            local v30 = if v6:NextNumber() < 0.5 then -1 else 1
            local v31 = v6:NextNumber(12, 22)
            local v32 = Vector3.new(3.4, v31, 3.4)
            local v33 = v8 * CFrame.new(v30 * 22, v31 * 0.5 - 1, 0) * CFrame.Angles(0, 0, v30 * v6:NextNumber(0.05, 0.25))
            local v34 = Color3.fromRGB(86, 96, 110)
            local Cobblestone = Enum.Material.Cobblestone
            local Part = Instance.new("Part")

            Part.Name = "Ruin"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Size = v32
            Part.CFrame = v33
            Part.Color = v34
            Part.Material = Cobblestone
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Parent = v5
            Part.Transparency = 0
        end

        n1 += 1

        if n1 % 8 == 0 then
            task.wait()
        end
    end

    local clone

    if p10 then
        local v35 = GhostDogQuest.ChaseFrame(p8, p9 + 22)

        clone = p7:Clone(GhostDogQuest2.SunkenChest)
        clone:PivotTo(v35 * CFrame.new(0, -11, 0) * CFrame.Angles(0, 3.141592653589793, 0))
        clone.Parent = v5
    end

    local Part = Instance.new("Part")

    Part.Name = "Snow"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(60, 1, 60)
    Part.Parent = v5

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "MarineSnow"
    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(190, 240, 255))
    ParticleEmitter.LightEmission = 0.6
    ParticleEmitter.Rate = 60
    ParticleEmitter.Lifetime = NumberRange.new(2, 4)
    ParticleEmitter.Speed = NumberRange.new(0.5, 2)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Size = NumberSequence.new(0.18, 0)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Parent = Part
    v5.Parent = Workspace

    return v5, clone
end

local function underwater(p11) -- line: 307
    -- upvalues: Lighting (copy)
    local v36 = p11:Add(Instance.new("ColorCorrectionEffect"))

    v36.Name = "GhostDogUnderwater"
    v36.TintColor = Color3.fromRGB(150, 225, 255)
    v36.Saturation = 0.1
    v36.Contrast = 0.12
    v36.Brightness = 0.02
    v36.Parent = Lighting

    local v37 = p11:Add(Instance.new("BlurEffect"))

    v37.Name = "GhostDogUnderwaterBlur"
    v37.Size = 2
    v37.Parent = Lighting

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if not Atmosphere then
        return
    end

    local Density, Color, Decay, Haze = Atmosphere.Density, Atmosphere.Color, Atmosphere.Decay, Atmosphere.Haze

    Atmosphere.Density = 0.55
    Atmosphere.Color = Color3.fromRGB(40, 110, 140)
    Atmosphere.Decay = Color3.fromRGB(10, 40, 70)
    Atmosphere.Haze = 2
    p11:Add(function() -- line: 327
        -- upvalues: Atmosphere (copy), Density (copy), Color (copy), Decay (copy), Haze (copy)
        Atmosphere.Density = Density
        Atmosphere.Color = Color
        Atmosphere.Decay = Decay
        Atmosphere.Haze = Haze
    end)
end

local function playFish(p12, p13, p14, p15) -- line: 336
    local v38 = p12:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v38 and v38:FindFirstChildOfClass("Animator")
    local Animations = p12:FindFirstChild("Animations")
    local v39 = Animations and Animations:FindFirstChild(p13)

    if Animator == nil or v39 == nil or not v39:IsA("Animation") then
        return nil
    end

    local track = Animator:LoadAnimation(v39)

    track.Looped = p14
    track:Play(0.15, 1, p15 or 1)

    return track
end

local function spawnMine(p16, p17, p18, p19) -- line: 350
    -- upvalues: GhostDogQuest (copy), GhostDogQuest2 (copy), v2 (copy), v3 (copy)
    local clone = GhostDogQuest2.SeaMine:Clone()

    clone:PivotTo(GhostDogQuest.ChaseFrame(p17, p19) * CFrame.new(p18, 0, 0))

    local Part = Instance.new("Part")

    Part.Name = "Tether"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Material = Enum.Material.Metal
    Part.Color = Color3.fromRGB(50, 60, 78)
    Part.Size = Vector3.new(0.35, 9, 0.35)
    Part.CFrame = clone:GetPivot() * CFrame.new(0, -6, 0)
    Part.Parent = clone

    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = v3
    Highlight.FillTransparency = 0.88
    Highlight.OutlineColor = v3
    Highlight.OutlineTransparency = 0.5
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = clone

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Range = 10
    PointLight.Brightness = 0
    PointLight.Parent = clone:FindFirstChild("Body") or clone.PrimaryPart
    clone.Parent = p16

    return {
        Hit = false,
        Passed = false,
        Model = clone,
        Offset = p18,
        Distance = p19,
        Phase = math.random() * 6,
        Glow = Highlight,
        Light = PointLight
    }
end

local function planRows(p20, p21, p22) -- line: 390
    -- upvalues: GhostDogQuestFlags (copy), GhostDogQuest (copy), t1 (copy)
    local t3 = {}
    local v40 = Random.new()
    local v41 = p21 * GhostDogQuestFlags.ChaseGraceSeconds:Get()
    local v42 = p21 * GhostDogQuestFlags.ChaseMineGapSeconds:Get() * p22
    local v43 = p20 - p21 * 2.6
    local v44 = v41
    local n2 = 0
    local n3 = 0

    while v44 < v43 do
        n3 += 1

        local v47 = (v44 - v41) / math.max(v43 - v41, 1)
        local t4 = {}
        local v48 = v40:NextNumber()

        if v47 < 0.22 or v48 < 0.25 then
            t4 = { t1[v40:NextInteger(1, 3)] }
        else
            local v49 = t1[v40:NextInteger(1, 3)]

            if v49 == n2 and v40:NextNumber() < 0.7 then
                v49 = if v49 ~= 0 then 0 elseif v40:NextNumber() < 0.5 then -1 else 1
            end

            n2 = v49

            for _, v50 in t1 do
                if v50 ~= v49 then
                    table.insert(t4, v50)
                end
            end
        end

        for _, v51 in t4 do
            local v52 = v40:NextNumber(-2.5, 2.5)

            table.insert(t3, {
                Offset = math.clamp(GhostDogQuest.LaneOffset(v51) + v52, -13, 13),
                Distance = v44
            })
        end

        v44 += v42 * (1 - v47 * 0.25) * (if #t4 == 2 then 1.15 else 0.9)
    end

    return t3
end

local function banner(p23, p24, p25, p26) -- line: 439
    -- upvalues: Fx (copy)
    local Banner = p23.Chase.Banner

    Banner.Text = p24
    Banner.TextTransparency = 0

    local UIStroke = Banner:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Transparency = 0
    end

    local UIScale = Banner:FindFirstChildOfClass("UIScale")

    if UIScale then
        Fx.Punch(UIScale, 1.6, 0.35)
    end

    p23.Chase.Sub.Text = p25 or ""

    if p26 then
        task.delay(p26, function() -- line: 453
            -- upvalues: p23 (copy), p24 (copy), Banner (copy), UIStroke (copy), Fx (copy)
            if Banner.Text ~= p24 then
                return
            end

            Fx.Tween(Banner, 0.3, {
                TextTransparency = 1
            })

            if UIStroke then
                Fx.Tween(UIStroke, 0.3, {
                    Transparency = 1
                })
            end

            p23.Chase.Sub.Text = ""
        end)
    end
end

local function popText(p27, p28, p29) -- line: 465
    -- upvalues: Fx (copy)
    local Pop = p27.Chase.Pop

    Pop.Text = p28
    Pop.TextColor3 = p29
    Pop.Visible = true
    Pop.TextTransparency = 0
    Pop.Rotation = math.random(-8, 8)

    local UIScale = Pop:FindFirstChildOfClass("UIScale")

    if UIScale then
        Fx.Punch(UIScale, 1.8, 0.25)
    end

    local UIStroke = Pop:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Transparency = 0
    end

    task.delay(0.5, function() -- line: 480
        -- upvalues: Pop (copy), UIStroke (copy), Fx (copy)
        Fx.Tween(Pop, 0.25, {
            TextTransparency = 1
        })

        if UIStroke then
            Fx.Tween(UIStroke, 0.25, {
                Transparency = 1
            })
        end
    end)
end

local function keysText() -- line: 488
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Hold the joystick left or right to steer"
    end

    if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
        return "Hold <b>A</b> or <b>D</b> to steer"
    end

    return "Hold the left stick left or right to steer"
end

local function waitForArrival(p30, p31, p32) -- line: 498
    -- upvalues: GhostDogQuest (copy), LocalPlayer (copy)
    local Position = GhostDogQuest.ChaseFrame(p31, 0).Position
    local elapsed = os.clock()

    while true do
        if not (os.clock() - elapsed < p32) then
            return false
        end

        if p30.Parent ~= nil and LocalPlayer:GetAttribute(GhostDogQuest.ChaseAttribute) == p31 and (p30.Position - Position).Magnitude < 40 then
            break
        end

        task.wait()
    end

    return true
end

function t2.Run(p33, p34, p35, p36, p37) -- line: 511
    -- upvalues: UserInputService (copy), Workspace (copy), GhostDogQuestFlags (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Remotes (copy), Swim (copy), WhaleHearts (copy), LocalPlayer (copy), GhostDogQuest2 (copy), Chase (copy), Stage3 (copy), Explosion (copy), WhaleHeartBreak (copy), WhaleNearMiss (copy), Swoosh (copy), Shatter (copy), v2 (copy), v3 (copy), v4 (copy), buildScene (copy), underwater (copy), playFish (copy), spawnMine (copy), planRows (copy), banner (copy), popText (copy), waitForArrival (copy)
    local Character = LocalPlayer.Character
    local v54 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v55 = Character and Character:FindFirstChildOfClass("Humanoid")
    local v56 = Hud.Get()
    local v57, v58

    if Character == nil or v54 == nil then
        v58 = true
    elseif not v54:IsA("BasePart") or v55 == nil or v56 == nil then
        v58 = true
    else
        v57 = p37 ~= nil and p37.Ending == "Catch"
        v58 = false
    end

    if v58 then
        return "Aborted", nil, nil, nil
    end

    local v59 = if v57 then GhostDogQuestFlags.FishChaseSeconds:Get() else GhostDogQuestFlags.ChaseSeconds:Get()
    local v60 = GhostDogQuestFlags.ChaseSpeed:Get()
    local v61 = v59 * v60
    local v62 = GhostDogQuestFlags.ChaseHearts:Get()
    local v63, v64 = buildScene(p33, p34, v61, not v57)

    underwater(p33)

    local Snow = v63:FindFirstChild("Snow")
    local CurrentCamera = Workspace.CurrentCamera

    v55.PlatformStand = true
    p33:Add(function() -- line: 541
        -- upvalues: CurrentCamera (copy), v54 (copy), v55 (copy), LocalPlayer (copy)
        v55.PlatformStand = false
        v54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v54.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        CurrentCamera.CameraType = Enum.CameraType.Custom

        local Character = LocalPlayer.Character

        CurrentCamera.CameraSubject = Character and Character:FindFirstChildOfClass("Humanoid") or v55
    end)

    local v65 = GhostDogQuest.ChaseFrame(p34, 0)
    local v66 = true

    p33:BindToRenderStep("GhostDogChaseHold", Enum.RenderPriority.Character.Value, function() -- line: 552
        -- upvalues: v65 (ref), v66 (ref), v54 (copy)
        if v66 and (v54.Position - v65.Position).Magnitude < 60 then
            v54.CFrame = v65 * CFrame.Angles(-1.2566370614359172, 0, 0)
            v54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)

    if p36 then
        p36:Clean()
        v55.PlatformStand = true
    end

    Swim.Start(p33, Character, "Swim")

    if not waitForArrival(v54, p34, 20) then
        warn("[GhostDogQuest] Chase arrival timed out", p34, v54.Position, LocalPlayer:GetAttribute(GhostDogQuest.ChaseAttribute))

        return "Aborted", nil, nil, nil
    end

    local clone = p33:Clone(GhostDogQuest2.GhostFish)

    clone:PivotTo(GhostDogQuest.ChaseFrame(p34, 30) * CFrame.new(0, -8.5, 0))
    clone.Parent = v63
    playFish(clone, "GhostFish_Swim", true, 1.4)

    local v67 = clone:FindFirstChild("MouthGlow", true)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Hook"

    if v67 then
        Attachment.Parent = v67
    end

    v67 = nil

    for _, child in Character:GetChildren() do
        if child:IsA("Tool") then
            local v68 = child:FindFirstChild("RodTip", true)

            if v68 and v68:IsA("Attachment") then
                v67 = v68
            end
        end
    end

    local Value = Instance.new("Attachment")

    Value.Name = "GhostDogLineHand"
    Value.Parent = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm") or v54
    p33:Add(Value)

    local v69 = p33:Add(Instance.new("Beam"))

    v69.Attachment0 = v67 or Value
    v69.Attachment1 = Attachment
    v69.Width0 = 0.12
    v69.Width1 = 0.22
    v69.LightEmission = 1
    v69.FaceCamera = true
    v69.Segments = 12
    v69.Color = ColorSequence.new(Fx.Ghost, Color3.fromRGB(150, 235, 255))
    v69.Parent = v63

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "GhostDogBubbles"
    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(210, 250, 255))
    ParticleEmitter.Rate = 18
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2)
    ParticleEmitter.Speed = NumberRange.new(2, 5)
    ParticleEmitter.Acceleration = Vector3.new(0, 6, 0)
    ParticleEmitter.Size = NumberSequence.new(0.35, 0)
    ParticleEmitter.SpreadAngle = Vector2.new(60, 60)
    ParticleEmitter.Parent = Value

    local v70 = p33:Add(Instance.new("Highlight"))

    v70.FillColor = Color3.new(1, 1, 1)
    v70.FillTransparency = 1
    v70.OutlineTransparency = 1
    v70.Adornee = Character
    v70.Parent = Character

    local Keys = Fx.Play(Stage3, {
        Volume = 0.45,
        Looped = true,
        PlaybackSpeed = 0.92,
        SoundGroup = "Music"
    })

    if Keys then
        Keys.Name = "GhostDogChaseMusic"
        p33:Add(Keys)

        local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

        EqualizerSoundEffect.HighGain = -18
        EqualizerSoundEffect.MidGain = -4
        EqualizerSoundEffect.LowGain = 4
        EqualizerSoundEffect.Parent = Keys
    end

    v56.Chase.Visible = true
    p33:Add(function() -- line: 633
        -- upvalues: v56 (copy)
        v56.Chase.Visible = false
    end)
    Keys = v56.Chase.Keys

    if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
        if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
            Keys.Text = "Hold <b>A</b> or <b>D</b> to steer"
        else
            Keys.Text = "Hold the left stick left or right to steer"
        end
    else
        Keys.Text = "Hold the joystick left or right to steer"
    end

    v56.Chase.Keys.TextTransparency = 0
    v56.Chase.Keys.Position = UDim2.fromScale(0.5, 0.8)
    Keys = v56.Chase.Keys:FindFirstChildOfClass("UIStroke")

    if Keys then
        Keys.Transparency = 0
    end

    v56.Chase.Lanes.Visible = false
    v56.Chase.Progress.Position = UDim2.fromScale(0.5, 0.03)

    local Progress = v56.Chase.Progress
    local Bar = Progress.BarHolder.BarBG.Bar

    if v57 then
        local Goal = Progress.Goal
        local Visible = Goal.Visible

        Goal.Visible = false
        p33:Add(function() -- line: 651
            -- upvalues: Goal (copy), Visible (copy)
            Goal.Visible = Visible
        end)
    end

    WhaleHearts.Show(p33, v62, Progress)

    local v71 = v62
    local n4 = 0
    local v72, v73, v74, v75, v76, v77, v78, v79, v80, v81

    while true do
        n4 += 1
        v73 = p33:Extend()

        local t6 = {}

        v74 = if n4 >= 3 then 1.25 else 1

        local v82 = planRows(v61, v60, v74)
        local t7 = {}

        t7[1] = 1

        local n5 = 0
        local n6 = 0
        local n7 = 0
        local n8 = 0
        local n9 = 0
        local v83 = false
        local n10 = (-1e999)
        local n11 = 0
        local n12 = 0
        local v84 = false
        local v85 = false

        Bar.Size = UDim2.fromScale(0, 1)
        Progress.Fish.Position = UDim2.fromScale(0.06, 0.48)
        v71 = v62 + (n4 >= 3 and 1 or 0)

        if n4 == 3 then
            WhaleHearts.Show(p33, v71, Progress)
        end

        v66 = true
        v75 = GhostDogQuest.ChaseFrame(p34, 0)
        v76 = CFrame.lookAt(v75.Position - v75.LookVector * 20 + v75.UpVector * 7, v75.Position + v75.LookVector * 18)

        local result, v86, UIStroke, UIScale

        if n4 == 1 then
            task.spawn(function() -- line: 693
                -- upvalues: Hud (copy)
                Hud.Fade(0, 0.6)

                local v87 = Hud.FadeFrame()

                if v87 then
                    v87.BackgroundColor3 = Color3.new(0, 0, 0)
                end
            end)
            Hud.Bubbles(1.2, 50)
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            v77 = v75.Position - v75.LookVector * 4 + v75.RightVector * 5 + v75.UpVector * 1.5
            v78 = v75.Position + v75.RightVector * 11 + v75.UpVector * 5 - v75.LookVector * 3
            v79 = v75.Position - v75.LookVector * 22 + v75.UpVector * 11 + v75.RightVector * 6

            local Position = GhostDogQuest.ChaseFrame(p34, 30).Position
            local v88 = v75.Position + v75.LookVector * 18

            v80 = Cine.SpeedLens(0.25, 18)
            v81 = Cine.RestingFov()
            Fx.Play(GhostDogQuest.Sounds.Surfaced, {
                Volume = 0.8
            })

            local v89 = Fx.Play(GhostDogQuest.Sounds.UnderwaterDrone, {
                Volume = 0,
                Looped = true
            })

            if v89 then
                v89.Name = "GhostDogUnderwaterDrone"
                Fx.Tween(v89, 1.2, {
                    Volume = 0.8
                })
                p33:Add(function() -- line: 724
                    -- upvalues: v89 (copy), Fx (copy)
                    if v89.Parent ~= nil then
                        Fx.Tween(v89, 0.6, {
                            Volume = 0
                        })
                        task.delay(0.6, function() -- line: 729
                            -- upvalues: v89 (copy)
                            v89:Destroy()
                        end)
                    end
                end)
            end

            result = os.clock()

            local v90 = result
            local v91 = false

            while true do
                local elapsed = os.clock()
                local v93 = math.min((elapsed - result) / 2.1, 1)
                local v92 = Fx.Ease(v93, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local v94 = 1 - v92
                local v95 = v77 * (v94 * v94 * v94) + v78 * (3 * v94 * v94 * v92) + v79 * (3 * v94 * v92 * v92) + v76.Position * (v92 * v92 * v92)
                local v96 = Fx.Ease(math.clamp((v93 - 0.2) / 0.35, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local Ease = Fx.Ease
                local v97 = (v93 - 0.55) / 0.45

                Ease = Ease(math.clamp(v97, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                v96 = v54.Position:Lerp(Position, v96):Lerp(v88, Ease)
                CurrentCamera.CFrame = CFrame.lookAt(v95, v96)
                CurrentCamera.FieldOfView = v80(v95, elapsed - v90, v81)

                local v99
                local v98 = v91

                if v91 then
                elseif v93 >= 0.35 then
                    Fx.Play(GhostDogQuest.Sounds.GrowlShort, {
                        Volume = 0.9
                    })
                    playFish(clone, "GhostFish_Roar", false)
                    Fx.Shake(2, 0.6)
                    v99 = if v57 then "Dodge the sea mines and wear it out" else "Dodge the sea mines"
                    v96 = v56.Chase.Banner
                    v96.Text = "IT'S DRAGGING YOU DOWN!"
                    v96.TextTransparency = 0
                    v97 = v96:FindFirstChildOfClass("UIStroke")

                    if v97 then
                        v97.Transparency = 0
                    end

                    v97 = v96:FindFirstChildOfClass("UIScale")

                    if v97 then
                        Fx.Punch(v97, 1.6, 0.35)
                    end

                    v98 = true
                    v56.Chase.Sub.Text = v99 or ""
                end

                if v93 >= 1 then
                    break
                end

                v91 = v98
                task.wait()
                v90 = elapsed
            end

            CurrentCamera.FieldOfView = v81
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = v55
            CurrentCamera.CFrame = v76
            task.wait(0.3)
        else
            Hud.Fade(0, 0.45)
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = v55
            CurrentCamera.CFrame = v76
            v86 = ("Attempt %*"):format(n4)

            local Banner = v56.Chase.Banner

            Banner.Text = "HOLD ON TIGHT!"
            Banner.TextTransparency = 0
            UIStroke = Banner:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Transparency = 0
            end

            UIScale = Banner:FindFirstChildOfClass("UIScale")

            if UIScale then
                Fx.Punch(UIScale, 1.6, 0.35)
            end

            v56.Chase.Sub.Text = v86 or ""
            task.wait(0.8)
        end

        local Sub

        for i = 3, 1, -1 do
            UIScale = tostring(i)
            v76 = v56.Chase.Banner
            v76.Text = UIScale
            v76.TextTransparency = 0
            Sub = v76:FindFirstChildOfClass("UIStroke")

            if Sub then
                Sub.Transparency = 0
            end

            Sub = v76:FindFirstChildOfClass("UIScale")

            if Sub then
                Fx.Punch(Sub, 1.6, 0.35)
            end

            v56.Chase.Sub.Text = ""
            Fx.Play(GhostDogQuest.Sounds.CountdownTick, {
                Volume = 0.6
            })
            task.wait(n4 > 1 and 0.35 or 0.55)
        end

        banner(v56, "GO!", nil, 0.6)
        Fx.Play(GhostDogQuest.Sounds.CountdownGo, {
            Volume = 0.7
        })
        v66 = false
        v73:Add((task.delay(5, function() -- line: 800
            -- upvalues: v56 (copy), Fx (copy)
            Fx.Tween(v56.Chase.Keys, 0.5, {
                TextTransparency = 1
            })

            local UIStroke = v56.Chase.Keys:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                Fx.Tween(UIStroke, 0.5, {
                    Transparency = 1
                })
            end
        end)))

        local function steer() -- line: 809
            -- upvalues: p34 (copy), n5 (ref), v55 (copy), UserInputService (copy), GhostDogQuest (copy)
            local v101 = GhostDogQuest.ChaseFrame(p34, n5)
            local MoveDirection = v55.MoveDirection
            local v102 = if MoveDirection.Magnitude > 0.05 then math.clamp(MoveDirection:Dot(v101.RightVector) * 1.4, -1, 1) else 0
            local v104 = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
            local v105 = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)

            if v104 and not v105 then
                return -1
            end

            if v105 and not v104 then
                v102 = 1
            end

            return v102
        end

        local function onHit(p38) -- line: 827
            -- upvalues: p34 (copy), v56 (copy), v70 (copy), v71 (ref), n5 (ref), n10 (ref), n11 (ref), v84 (ref), Fx (copy), GhostDogQuest (copy), WhaleHearts (copy), Explosion (copy), WhaleHeartBreak (copy), v4 (copy), popText (copy)
            p38.Hit = true
            n10 = os.clock()
            n11 = os.clock() + 0.08
            v71 -= 1

            local Position = p38.Model:GetPivot().Position

            p38.Model:Destroy()
            Fx.Burst(Position, Color3.fromRGB(255, 170, 90), 40, 30, 2.2)
            Fx.Burst(Position, Color3.fromRGB(255, 255, 255), 20, 18, 1.2)
            Fx.Ring(CFrame.lookAt(Position, Position + GhostDogQuest.ChaseFrame(p34, n5).LookVector) * CFrame.Angles(0, 1.5707963267948966, 0), Color3.fromRGB(255, 160, 80), 3, 26, 0.5)
            Fx.Play(Explosion, {
                Volume = 0.8
            })
            Fx.Play(WhaleHeartBreak, {
                Volume = 0.6
            })
            Fx.Shake(3.2, 0.5)
            Fx.Flash(v4, v71 <= 0 and 0.6 or 0.42, 0.02, 0.4)
            v70.FillTransparency = 0
            popText(v56, "OUCH!", v4)
            WhaleHearts.Lose((math.max(v71, 0)))

            if v71 == 1 then
                task.delay(0.35, function() -- line: 852
                    -- upvalues: v56 (copy), Fx (copy), v4 (copy), popText (copy)
                    popText(v56, "LAST HEART!", v4)
                    Fx.Flash(v4, 0.25, 0.05, 0.6)
                end)
            end

            if v71 <= 0 then
                v84 = true
            end
        end

        local v107 = Enum.RenderPriority.Camera.Value + 1

        v73:BindToRenderStep("GhostDogChase", v107, function(p39) -- line: 865
            -- upvalues: p34 (copy), p35 (copy), v56 (copy), v60 (copy), v61 (copy), v63 (copy), Snow (copy), CurrentCamera (copy), clone (copy), v69 (copy), ParticleEmitter (copy), v70 (copy), Progress (copy), Bar (copy), t6 (copy), v82 (copy), t7 (copy), n5 (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref), v83 (ref), n10 (ref), n11 (ref), n12 (ref), v84 (ref), v85 (ref), steer (copy), onHit (copy), v54 (copy), Fx (copy), GhostDogQuest (copy), Chase (copy), WhaleNearMiss (copy), Swoosh (copy), v2 (copy), v3 (copy), spawnMine (copy), popText (copy)
            local function v109() -- line: 866
                -- upvalues: p39 (copy), p34 (copy), p35 (copy), v56 (copy), v60 (copy), v61 (copy), v63 (copy), Snow (copy), CurrentCamera (copy), clone (copy), v69 (copy), ParticleEmitter (copy), v70 (copy), Progress (copy), Bar (copy), t6 (copy), v82 (copy), t7 (copy), n5 (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref), v83 (ref), n10 (ref), n11 (ref), n12 (ref), v84 (ref), v85 (ref), steer (copy), onHit (copy), v54 (copy), Fx (copy), GhostDogQuest (copy), Chase (copy), WhaleNearMiss (copy), Swoosh (copy), v2 (copy), v3 (copy), spawnMine (copy), popText (copy)
                local elapsed = os.clock()

                if not (elapsed < n11) and not v85 and not v84 then
                    local v110 = math.min(p39, 0.1)
                    local v111 = n5
                    local LookVector = GhostDogQuest.ChaseFrame(p34, n5).LookVector
                    local v113 = n5

                    n5 = math.min(v113 + v60 * v110, v61)

                    local v114 = GhostDogQuest.ChaseFrame(p34, n5)
                    local v115 = steer()
                    local v116 = math.abs(v115) > 0.2

                    if v116 and not v83 then
                        Fx.Play(Swoosh, {
                            Volume = 0.25,
                            PlaybackSpeed = 1.3 + math.random() * 0.2
                        })
                        ParticleEmitter:Emit(8)
                    end

                    v83 = v116

                    local v117 = v115 * 75

                    n7 += (v117 - n7) * math.min(v110 * 16, 1)
                    n6 += n7 * v110

                    if math.abs(n6) >= 13 then
                        n6 = math.clamp(n6, -13, 13)
                        n7 = 0
                    end

                    n12 = n7 / 75

                    local v124 = elapsed - n10
                    local v125 = if v124 < 0.5 then math.sin(v124 * 40) * (0.5 - v124) * 0.8 else 0
                    local v128 = math.sin(elapsed * 9) * 0.05
                    local v131 = v114 * CFrame.new(n6, math.sin(elapsed * 2.4) * 0.3, 0)

                    v54.CFrame = v131 * CFrame.Angles(v128 + -1.2566370614359172, 0, -n12 * 0.45 + v125)
                    v54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v54.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    Snow.CFrame = v131 * CFrame.new(0, 10, -20)

                    local v132 = n5 + 30
                    local v134 = math.sin(elapsed * 1.3) * 3 + n6 * 0.25
                    local v135 = n8
                    local n13 = 1e999

                    for i = -15, 15, 1.5 do
                        local v139 = math.abs(i - v134) * 0.35 + math.abs(i - n8) * 0.25

                        for _, v140 in t6 do
                            local v141 = v140.Distance - v132

                            if v141 > -8 and v141 < 55 and not v140.Hit then
                                local v143 = math.abs(v140.Offset - i)

                                if v143 < 9 then
                                    local v145 = 1 - math.clamp(v141 / 55, 0, 1)

                                    v139 += (9 - v143) * (v145 * 10 + 4)
                                end
                            end
                        end

                        if v139 < n13 then
                            n13 = v139
                            v135 = i
                        end
                    end

                    local v146 = (v135 - n8) * 28 - n9 * 9

                    n9 += v146 * v110
                    n8 += n9 * v110

                    local v150 = math.clamp(-n9 * 0.035, -0.6, 0.6)
                    local v152 = math.clamp(-n9 * 0.012, -0.3, 0.3)

                    clone:PivotTo(GhostDogQuest.ChaseFrame(p34, v132) * CFrame.new(n8, math.sin(elapsed * 3) * 0.6 + -8.5, 0) * CFrame.Angles(0, v152 + math.sin(elapsed * 2.2) * 0.05, v150))
                    v69.CurveSize0 = math.sin(elapsed * 5) * 1.2
                    v69.CurveSize1 = -math.sin(elapsed * 5) * 1.2

                    local v165 = (math.atan2(-v114.LookVector.X, -v114.LookVector.Z) - math.atan2(-LookVector.X, -LookVector.Z) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    local Position = v54.Position

                    CurrentCamera.CFrame = CFrame.new(Position) * CFrame.Angles(0, v165, 0) * CFrame.new(-Position) * CurrentCamera.CFrame

                    if v124 < 1.2 then
                        local v167 = math.floor(v124 * 12) % 2 == 0

                        if v124 < 0.12 then
                            v70.FillTransparency = v124 / 0.12 * 0.4
                        elseif v167 then
                            v70.FillTransparency = 0.55
                        else
                            v70.FillTransparency = 1
                        end
                    elseif v70.FillTransparency < 1 then
                        v70.FillTransparency = 1
                    end

                    while t7[1] <= #v82 and v82[t7[1]].Distance <= n5 + 260 do
                        local v168 = v82[t7[1]]

                        table.insert(t6, (spawnMine(v63, p34, v168.Offset, v168.Distance)))
                        t7[1] += 1
                    end

                    for i = #t6, 1, -1 do
                        local v170 = t6[i]

                        if v170.Hit then
                            table.remove(t6, i)
                        else
                            local v171 = v170.Distance - n5
                            local v172 = GhostDogQuest.ChaseFrame(p34, v170.Distance)
                            local v174 = math.sin(elapsed * 2 + v170.Phase) * 0.6

                            v170.Model:PivotTo(v172 * CFrame.new(v170.Offset, v174, 0) * CFrame.Angles(0, elapsed * 0.6 + v170.Phase, 0))

                            local v175 = math.max(v171, 0) / v60
                            local v177 = n6
                            local v178 = n7
                            local v179 = math.clamp(v177 + v178 * math.min(v175, 0.25), -13, 13)

                            if v171 < 70 and v171 > -2.6 and math.abs(v170.Offset - v179) < 4.6 then
                                local v183 = (math.sin(elapsed * 16) + 1) * 0.5
                                local v185 = 1 - math.clamp(v171 / 70, 0, 1)

                                v170.Glow.FillColor = v2
                                v170.Glow.OutlineColor = v2
                                v170.Glow.OutlineTransparency = 0
                                v170.Glow.FillTransparency = 0.75 - (v185 * 0.25 + 0.3) * v183
                                v170.Light.Brightness = v185 * 3 * v183 + 1
                            elseif v170.Glow.FillColor ~= v3 then
                                v170.Glow.FillColor = v3
                                v170.Glow.OutlineColor = v3
                                v170.Glow.OutlineTransparency = 0.5
                                v170.Glow.FillTransparency = 0.88
                                v170.Light.Brightness = 0
                            end

                            if v171 < -30 then
                                v170.Model:Destroy()
                                table.remove(t6, i)
                            elseif not v170.Passed and v171 <= 2.6 and v170.Distance - v111 >= -2.6 then
                                local v187 = math.abs(v170.Offset - n6)

                                if v187 < 4.6 then
                                    if v124 >= 1.2 then
                                        onHit(v170)
                                    else
                                        v170.Passed = true
                                    end
                                elseif v187 < Chase.LaneSpacing + 1 and v171 < 0 then
                                    v170.Passed = true
                                    Fx.Play(WhaleNearMiss, {
                                        Volume = 0.35
                                    })
                                    Fx.Shake(0.8, 0.15)

                                    if math.random() < 0.35 then
                                        popText(v56, "CLOSE!", Color3.fromRGB(255, 225, 90))
                                    end
                                end
                            end
                        end
                    end

                    local v188 = n5 / v61

                    Bar.Size = UDim2.fromScale(v188, 1)
                    Progress.Fish.Position = UDim2.fromScale(0.06 + v188 * 0.88, 0.48)

                    if n5 >= v61 then
                        v85 = true
                    end

                    if not p35() then
                        v84 = true
                    end
                end
            end

            local ok, result = pcall(v109)

            if not ok then
                warn((("[GhostDogQuest] chase step failed: %*"):format(result)))
                v84 = true
            end
        end)
        UIStroke = os.clock() + v59 + 20

        while not v85 and not v84 and p35() and os.clock() < UIStroke do
            task.wait()
        end

        if not v85 and not v84 then
            v84 = true
        end

        v73:Clean()

        for _, v189 in t6 do
            v189.Model:Destroy()
        end

        if p35() then
            if v85 then
                v72 = "Won"
            else
                UIScale = ("You got %*%% of the way!"):format((math.floor(n5 / v61 * 100)))
                UIStroke = v56.Chase.Banner
                UIStroke.Text = "OOF! Try again!"
                UIStroke.TextTransparency = 0
                Sub = UIStroke:FindFirstChildOfClass("UIStroke")

                if Sub then
                    Sub.Transparency = 0
                end

                Sub = UIStroke:FindFirstChildOfClass("UIScale")

                if Sub then
                    Fx.Punch(Sub, 1.6, 0.35)
                end

                v56.Chase.Sub.Text = UIScale or ""
                Fx.Play(Shatter, {
                    Volume = 0.7,
                    PlaybackSpeed = 0.8
                })
                Fx.Flash(Color3.new(1, 1, 1), 0.4, 0.02, 0.35)
                Fx.Shake(2.6, 0.5)
                task.wait(0.9)
                UIScale = false
                Hud.Fade(1, 0.35)

                for _ = 1, 3 do
                    result = function() -- line: 1086
                        -- upvalues: Remotes (copy)
                        return Remotes.GhostDogQuest.Restart:InvokeServer()
                    end

                    local ok

                    ok, result = pcall(result)

                    if ok and result == true then
                        UIScale = true
                        break
                    end

                    UIScale = false
                    task.wait(0.6)
                end

                if UIScale then
                    v66 = true
                    v65 = GhostDogQuest.ChaseFrame(p34, 0)
                    waitForArrival(v54, p34, 5)
                    WhaleHearts.Refill(v62 + (n4 + 1 >= 3 and 1 or 0))
                    continue
                end

                v72 = "Aborted"
            end
        else
            v72 = "Aborted"
        end

        break
    end

    if v72 == "Won" then
        v56.Chase.Keys.TextTransparency = 1
        v66 = false

        if v57 then
            return "Won", nil, v63, clone, v69
        end

        v73 = p33:Extend()

        local v191 = v54.CFrame
        local _CFrame = Enum.RenderPriority.Character.Value

        v73:BindToRenderStep("GhostDogChaseEnd", _CFrame, function() -- line: 1116
            -- upvalues: v191 (ref), v54 (copy)
            v54.CFrame = v191
            v54.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            v54.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        v72 = CurrentCamera.CFrame

        local _CFrame2 = clone:GetPivot().Position + Vector3.new(0, 8.5, 0)

        playFish(clone, "GhostFish_Thrash", false, 1.4)
        Fx.Play(GhostDogQuest.Sounds.GrowlShort, {
            Volume = 1,
            PlaybackSpeed = 0.95
        })
        v69.Color = ColorSequence.new(Color3.new(1, 1, 1), Fx.Ghost)

        local elapsed = os.clock()
        local v193, Rotation

        while os.clock() - elapsed < 0.7 do
            v57 = (os.clock() - elapsed) / 0.7
            Rotation = v57 * 40
            v193 = math.sin(Rotation)
            v69.Width0 = 0.12 + math.abs(v193) * 0.3 * v57
            v69.Width1 = v69.Width0 + 0.1
            v69.CurveSize0 = 0
            v69.CurveSize1 = 0
            CurrentCamera.CFrame = v72:Lerp(CFrame.lookAt(v72.Position:Lerp(_CFrame2, 0.12), _CFrame2), Fx.Ease(v57)) * CFrame.Angles(0, 0, math.noise(os.clock() * 20, 3) * v57 * 0.04)

            if math.random() < 0.3 then
                Fx.Shake(0.6 * v57, 0.1)
            end

            task.wait()
        end

        task.wait(0.12)
        v72 = v69.Attachment0.WorldPosition
        _CFrame2 = Attachment.WorldPosition

        for i = 1, 5 do
            Fx.Burst(v72:Lerp(_CFrame2, i / 6), Color3.fromRGB(220, 255, 240), 10, 18, 0.5)
        end

        v69:Destroy()
        Fx.Play(GhostDogQuest.Sounds.LineSnap, {
            Volume = 0.9
        })
        Fx.Flash(Color3.new(1, 1, 1), 0.65, 0.02, 0.4)
        Fx.Shake(4.5, 0.8)
        banner(v56, "SNAP!", nil, 0.9)

        local v194 = GhostDogQuest.ChaseFrame(p34, v61)
        local Pivot = clone:GetPivot()

        _CFrame2 = v54.CFrame
        elapsed = GhostDogQuest.ChaseFrame(p34, v61 + 8) * CFrame.new(0, -6, 0)

        local Position = v64:GetPivot().Position
        local v195 = elapsed.Position - v194.LookVector * 16 + v194.UpVector * 9 + v194.RightVector * 6

        _CFrame = CurrentCamera.CFrame
        v74 = GhostDogQuest.ChaseFrame(p34, v61 + 30).LookVector * Vector3.new(1, 0, 1)
        v193 = if v74.Magnitude > 0.05 then v74.Unit else v194.LookVector
        v74 = (Pivot * CFrame.new(0, 8.5, 0)).Position
        v72 = CFrame.lookAt(v74, v74 + v193).Rotation
        Rotation = Pivot.Rotation

        local elapsed2 = os.clock()

        Attachment = elapsed2

        while true do
            local elapsed3 = os.clock()
            local v197 = math.min((elapsed3 - elapsed2) / 1.6, 1)
            local v196 = elapsed3 - Attachment
            local v198 = Fx.Ease(v197, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local Ease = Fx.Ease(math.min(v197 / 0.4, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

            v74 += v193 * (22 + -6 * Fx.Ease(v197, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)) * v196
            v77 = CFrame.new(v74) * Rotation:Lerp(v72, Ease) * CFrame.new(0, -8.5, 0)
            v78 = CFrame.Angles
            v81 = elapsed3 * 2.2
            clone:PivotTo(v77 * v78(0, 0, math.sin(v81) * 0.06))
            v75 = v197 * 3.141592653589793

            local v200 = math.sin(v75) * 0.5

            v76 = CFrame.lookAt
            v77 = elapsed.Position
            v79 = Position * Vector3.new(1, 0, 1)
            v80 = elapsed.Y
            v191 = _CFrame2:Lerp(v76(v77, v79 + Vector3.new(0, v80, 0)), v198) * CFrame.Angles(-1.2566370614359172 * (1 - v198) * 0.8 + v200 * 0.3, 0, v200 * 0.4)
            CurrentCamera.CFrame = _CFrame:Lerp(CFrame.lookAt(v195, Position + Vector3.new(0, 2, 0)), v198)

            if v197 >= 1 then
                break
            end

            Attachment = elapsed3
            task.wait()
        end

        v56.Chase.Visible = false
        v73:Clean()

        return "Won", v64, v63, clone
    end

    v66 = false

    return v72, nil, v63, nil
end

return table.freeze(t2)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Cast = require(script.Parent.Cast)
local Cine = require(script.Parent.Cine)
local GhostDogQuestFlags = require(ReplicatedStorage.Shared.Flags.GhostDogQuestFlags)
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local Hud = require(script.Parent.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Swim = require(script.Parent.Swim)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local GhostDogQuest2, Sounds = ReplicatedStorage.Assets.GhostDogQuest, ReplicatedStorage.Assets.Sounds
local v1 = CFrame.new(0, 0.25, -2.2)
local v2 = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.Angles(0, 0, -0.20943951023931956)
local t1 = {
    "MouthCore",
    "MouthGlow",
    "EyeGlow"
}
local v3 = Color3.fromRGB(255, 214, 120)
local v4 = Color3.fromRGB(220, 255, 250)
local v5 = Color3.fromRGB(170, 235, 245)
local Swoosh, Pop, HeavyLand = Sounds.ScrambleBoss.Swoosh, Sounds.ScrambleBoss.Pop, Sounds.ScrambleBoss.HeavyLand
local CollectSecretRing = Sounds.LightVsDarknessSounds.CollectSecretRing
local SlideLoop, SlideHit = Sounds.BeanstalkEvent.SlideLoop, Sounds.BeanstalkEvent.SlideHit
local t2 = {}

local function run(p1, p2) -- line: 72
    local elapsed = os.clock()
    local elapsed2 = elapsed

    while true do
        local elapsed3 = os.clock()
        local v7 = math.min((elapsed3 - elapsed) / p1, 1)

        p2(v7, elapsed3 - elapsed2)

        if v7 >= 1 then
            break
        end

        elapsed2 = elapsed3
        task.wait()
    end
end

local function puppet(p3, p4, p5) -- line: 87
    local v8 = p4.CFrame
    local v9 = true

    p3:BindToRenderStep(p5, Enum.RenderPriority.Character.Value, function() -- line: 90
        -- upvalues: p4 (copy), v8 (ref), v9 (ref)
        if not v9 then
            return
        end

        p4.CFrame = v8
        p4.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        p4.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    p3:Add(function() -- line: 97
        -- upvalues: v9 (ref)
        v9 = false
    end)

    return {
        Set = function(p6) -- Set | line: 101
            -- upvalues: p4 (copy), v8 (ref), v9 (ref)
            v8 = p6

            if v9 then
                p4.CFrame = p6
            end
        end,
        Get = function() -- Get | line: 107
            -- upvalues: v8 (ref)
            return v8
        end,
        Stop = function() -- Stop | line: 110
            -- upvalues: v9 (ref)
            v9 = false
        end
    }
end

local function hold(p7, p8, p9, p10) -- line: 116
    -- upvalues: v1 (copy), v2 (copy)
    local t4 = {
        Holding = false,
        Fish = p9,
        Center = p9:GetPivot():PointToObjectSpace(p9:GetBoundingBox().Position) / p9:GetScale(),
        Scale = p9:GetScale()
    }

    p7:BindToRenderStep(p10, Enum.RenderPriority.Character.Value + 1, function() -- line: 124
        -- upvalues: p8 (copy), p9 (copy), t4 (copy), v1 (copy), v2 (copy)
        if t4.Holding and p9.Parent ~= nil then
            p9:PivotTo(p8.CFrame * v1 * v2 * CFrame.new(-t4.Center * t4.Scale))
        end
    end)

    return t4
end

local function fishTracks(p11) -- line: 134
    local v10 = p11:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v10 and v10:FindFirstChildOfClass("Animator")

    if Animator == nil then
        return {}
    end

    return Animator:GetPlayingAnimationTracks()
end

local function playFish(p12, p13, p14, p15) -- line: 143
    local v11 = p12:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v11 and v11:FindFirstChildOfClass("Animator")
    local Animations = p12:FindFirstChild("Animations")
    local v12 = Animations and Animations:FindFirstChild(p13)

    if Animator == nil or v12 == nil or not v12:IsA("Animation") then
        return nil
    end

    local track = Animator:LoadAnimation(v12)

    track.Looped = p14
    track:Play(0.15, 1, p15 or 1)

    return track
end

local function glowParts(p16) -- line: 157
    -- upvalues: t1 (copy)
    local t5 = {}

    for _, v13 in t1 do
        local v14 = p16:FindFirstChild(v13, true)

        if v14 and v14:IsA("BasePart") then
            t5[v14] = v14.Transparency
        end
    end

    return t5
end

local function flicker(p17, p18) -- line: 168
    for v15, v16 in p17 do
        v15.Transparency = math.clamp(v16 + (if math.random() < p18 then 0.55 + math.random() * 0.4 else 0), 0, 1)
    end
end

local function exclaim(p19, p20) -- line: 175
    -- upvalues: Fx (copy), LocalPlayer (copy)
    local Head = p20:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        local v18 = p19:Add(Instance.new("BillboardGui"))

        v18.Size = UDim2.fromScale(3, 3)
        v18.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
        v18.AlwaysOnTop = true
        v18.Adornee = Head

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
        TextLabel.Parent = v18
        v18.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        Fx.Punch(UIScale, 2.2, 0.35)
        task.delay(0.9, function() -- line: 200
            -- upvalues: v18 (copy)
            if v18.Parent ~= nil then
                v18:Destroy()
            end
        end)
    end
end

local function banner(p21, p22, p23, p24) -- line: 207
    -- upvalues: Fx (copy)
    local Banner = p21.Chase.Banner

    Banner.Text = p22
    Banner.TextTransparency = 0

    local UIStroke = Banner:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Transparency = 0
    end

    local UIScale = Banner:FindFirstChildOfClass("UIScale")

    if UIScale then
        Fx.Punch(UIScale, 1.6, 0.35)
    end

    p21.Chase.Sub.Text = p23 or ""
    task.delay(p24, function() -- line: 220
        -- upvalues: p21 (copy), p22 (copy), Banner (copy), UIStroke (copy), Fx (copy)
        if Banner.Text ~= p22 then
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

        p21.Chase.Sub.Text = ""
    end)
end

local function invoke(p25, p26) -- line: 231
    for _ = 1, p26 do
        local function v19() -- line: 233
            -- upvalues: p25 (copy)
            return p25:InvokeServer()
        end

        local ok, result = pcall(v19)

        if ok and result == true then
            return true
        end

        task.wait(0.6)
    end

    return false
end

local function flat(p27, p28) -- line: 244
    local v20 = p27 * Vector3.new(1, 0, 1)

    if v20.Magnitude > 0.05 then
        return v20.Unit
    end

    return p28
end

function t2.Play(p29, p30, p31, p32, p33) -- line: 249
    -- upvalues: Workspace (copy), Cine (copy), GhostDogQuestFlags (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Remotes (copy), LocalPlayer (copy), v1 (copy), v4 (copy), v5 (copy), Swoosh (copy), Pop (copy), CollectSecretRing (copy), SlideLoop (copy), run (copy), puppet (copy), hold (copy), fishTracks (copy), playFish (copy), glowParts (copy), flicker (copy), exclaim (copy), banner (copy), invoke (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local v21 = Hud.Get()

    if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") or v21 == nil then
        return false
    end

    local v22 = p29:Extend()
    local GhostFishCatchPuppet = puppet(v22, HumanoidRootPart, "GhostFishCatchPuppet")
    local GhostFishCatchHold = hold(v22, HumanoidRootPart, p31, "GhostFishCatchHold")
    local v23 = Cine.Take(v22)
    local Progress = v21.Chase.Progress

    Progress.Visible = false
    v22:Add(function() -- line: 268
        -- upvalues: Progress (copy)
        Progress.Visible = true
    end)

    local v24 = GhostDogQuestFlags.FishChaseSeconds:Get() * GhostDogQuestFlags.ChaseSpeed:Get()
    local v25 = GhostFishCatchPuppet.Get()
    local X = GhostDogQuest.ChaseFrame(p30, v24):ToObjectSpace(v25).Position.X
    local Pivot = p31:GetPivot()
    local X2 = GhostDogQuest.ChaseFrame(p30, v24 + 30):ToObjectSpace(Pivot).Position.X
    local v26 = glowParts(p31)

    for _, v27 in fishTracks(p31) do
        v27:AdjustSpeed(0.9)
    end

    Fx.Play(GhostDogQuest.Sounds.GrowlLong, {
        Volume = 0.55,
        PlaybackSpeed = 0.7
    })

    local _CFrame, FieldOfView = v23.CFrame, v23.FieldOfView
    local v28 = Cine.RestingFov()
    local n1 = 0
    local v29 = false
    local v30 = v25
    local t6 = {}

    t6[1] = Pivot
    run(1.6, function(p34) -- line: 290
        -- upvalues: p30 (copy), p31 (copy), p32 (copy), v21 (copy), GhostFishCatchPuppet (copy), v23 (copy), v24 (copy), X (copy), X2 (copy), v26 (copy), _CFrame (copy), FieldOfView (copy), v28 (copy), n1 (ref), v29 (ref), v30 (ref), t6 (copy), Fx (copy), GhostDogQuest (copy), v4 (copy), fishTracks (copy), flicker (copy), banner (copy)
        local v31 = Fx.Ease(p34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local elapsed = os.clock()
        local v32 = GhostDogQuest.ChaseFrame(p30, v24 + 26 * v31)
        local v33 = Fx.Ease(p34, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        v30 = v32 * CFrame.new(X, math.sin(elapsed * 2.4) * 0.3, 0) * CFrame.Angles(-1.2566370614359172 * (1 - v33), 0, 0)
        GhostFishCatchPuppet.Set(v30)

        local v35 = GhostDogQuest.ChaseFrame(p30, v24 + 30 + 17 * v31)
        local v36 = X2 + (X - X2) * v33
        local v38 = math.sin(elapsed * 7) * 0.28 * p34

        t6[1] = v35 * CFrame.new(v36, math.sin(elapsed * 3) * (p34 + 0.6) + -8.5, 0) * CFrame.Angles(math.sin(elapsed * 4.5) * 0.08 * p34, 0, v38)
        p31:PivotTo(t6[1])
        flicker(v26, p34 * 0.45 + 0.15)

        for _, v43 in fishTracks(p31) do
            v43:AdjustSpeed(1.4 - p34 * 1.05)
        end

        if p32 then
            p32.CurveSize0 = p34 * 3 + 0.5
            p32.CurveSize1 = -(p34 * 2 + 0.5)
        end

        if n1 <= elapsed then
            n1 = elapsed + 0.3

            local v44 = p31:FindFirstChild("MouthGlow", true)

            if v44 and v44:IsA("BasePart") then
                Fx.Burst(v44.Position, v4, 5, 6, 0.45)
            end
        end

        if not v29 and p34 >= 0.45 then
            v29 = true
            banner(v21, "IT'S WORN OUT!", "Grab it!", 1.6)
        end

        local v45 = v30.Position:Lerp((t6[1] * CFrame.new(0, 8.5, 0)).Position, 0.5)
        local v46 = v45 + v32.RightVector * 17 + v32.UpVector * 4 - v32.LookVector * 3
        local v47 = Fx.Ease(p34, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        v23.CFrame = _CFrame:Lerp(CFrame.lookAt(v46, v45), v47)
        v23.FieldOfView = FieldOfView + (v28 - FieldOfView) * v47
    end)

    if not p33() then
        return false
    end

    local v48 = CFrame.new(GhostFishCatchHold.Center * GhostFishCatchHold.Scale)
    local Position = (t6[1] * v48).Position
    local v49 = v30.Position - Position
    local v50 = -v30.LookVector
    local v51 = v49 * Vector3.new(1, 0, 1)

    if v51.Magnitude > 0.05 then
        v50 = v51.Unit
    end

    local Rotation = t6[1].Rotation
    local Rotation2 = CFrame.lookAt(Position, Position + v50).Rotation
    local v52 = CFrame.lookAt(v30.Position, (Vector3.new(Position.X, v30.Position.Y, Position.Z)))
    local v53 = v30
    local v54 = v52.Position - v52.LookVector * 7 + v52.RightVector * 3 + Vector3.new(0, 2.5, 0)
    local _CFrame2 = v23.CFrame

    Fx.Play(GhostDogQuest.Sounds.FishTurn, {
        Volume = 0.8,
        PlaybackSpeed = 0.85
    })
    playFish(p31, "GhostFish_Idle", true, 0.5)
    run(0.75, function(p35) -- line: 349
        -- upvalues: p31 (copy), GhostFishCatchPuppet (copy), GhostFishCatchHold (copy), v23 (copy), v26 (copy), Position (copy), Rotation (copy), Rotation2 (copy), v52 (copy), v53 (copy), v54 (copy), _CFrame2 (copy), Fx (copy), flicker (copy)
        local v55 = Fx.Ease(p35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local elapsed = os.clock()

        p31:PivotTo(CFrame.new(Position + Vector3.new(0, math.sin(elapsed * 3) * 0.6, 0)) * Rotation:Lerp(Rotation2, v55) * CFrame.Angles(0, 0, math.sin(elapsed * 7) * 0.2) * CFrame.new(-GhostFishCatchHold.Center * GhostFishCatchHold.Scale))
        flicker(v26, 0.55)
        GhostFishCatchPuppet.Set(v53:Lerp(v52, v55))
        v23.CFrame = _CFrame2:Lerp(CFrame.lookAt(v54, Position), Fx.Ease(p35, Enum.EasingStyle.Sine))
    end)
    exclaim(v22, Character)
    Fx.Play(GhostDogQuest.Sounds.GrowlShort, {
        Volume = 0.6,
        PlaybackSpeed = 0.8
    })
    Fx.Shake(0.8, 0.2)
    task.wait(0.3)

    if not p33() then
        return false
    end

    local v60 = Position + v50 * 2.6
    local v61 = CFrame.lookAt(v60, (Vector3.new(Position.X, v60.Y, Position.Z)))
    local _CFrame3 = v23.CFrame
    local v62 = v60 - v52.LookVector * 6 + v52.RightVector * 2.2 + Vector3.new(0, 1.6, 0)
    local Scale = GhostFishCatchHold.Scale

    Fx.Play(Swoosh, {
        Volume = 0.9,
        PlaybackSpeed = 1.1
    })
    Fx.Shake(1.2, 0.3)
    run(0.45, function(p36) -- line: 382
        -- upvalues: p31 (copy), GhostFishCatchPuppet (copy), GhostFishCatchHold (copy), v23 (copy), v28 (copy), Position (copy), Rotation2 (copy), v52 (copy), v61 (copy), _CFrame3 (copy), v62 (copy), Scale (copy), Fx (copy)
        local v63 = Fx.Ease(p36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v65 = math.sin(p36 * 3.141592653589793)

        GhostFishCatchPuppet.Set(v52:Lerp(v61, v63) * CFrame.Angles(v65 * -0.4886921905584123, 0, 0))

        local v67 = Fx.Ease(math.clamp((p36 - 0.35) / 0.65, 0, 1), Enum.EasingStyle.Back)
        local v68 = Scale + (0.22 - Scale) * v67

        if math.abs(p31:GetScale() - v68) > 0.001 then
            p31:ScaleTo((math.max(v68, 0.05)))
        end

        GhostFishCatchHold.Scale = p31:GetScale()
        p31:PivotTo(CFrame.new(Position) * Rotation2 * CFrame.new(-GhostFishCatchHold.Center * GhostFishCatchHold.Scale))
        v23.CFrame = _CFrame3:Lerp(CFrame.lookAt(v62, Position), v63)
        v23.FieldOfView = v28 - 18 * v63
    end)
    p31:ScaleTo(0.22)
    GhostFishCatchHold.Scale = p31:GetScale()
    GhostFishCatchHold.Holding = true
    GhostFishCatchPuppet.Set(v61)

    for v70 in v26 do
        v70.Transparency = v26[v70]
    end

    local Position3 = (HumanoidRootPart.CFrame * v1).Position

    Fx.Flash(Color3.new(1, 1, 1), 0.7, 0.02, 0.45)
    Fx.Burst(Position3, v4, 40, 26, 1.3)
    Fx.Burst(Position3, Fx.Ghost, 28, 18, 1)
    Fx.Ring(CFrame.new(Position3) * CFrame.Angles(0, 0, 1.5707963267948966), Fx.Ghost, 2, 18, 0.45)
    Fx.Shake(2.4, 0.4)
    Fx.Play(Pop, {
        Volume = 1
    })
    Fx.Play(CollectSecretRing, {
        Volume = 0.8
    })
    Hud.Bubbles(1, 40)
    playFish(p31, "GhostFish_Thrash", false, 1.6)
    banner(v21, "CAUGHT!", "Ghost Fish", 1.4)

    local v71 = false
    local v72 = task.spawn(function() -- line: 415
        -- upvalues: v71 (ref), Remotes (copy), invoke (copy)
        v71 = invoke(Remotes.GhostDogQuest.Claim, 4)
    end)

    v22:Add(function() -- line: 418
        -- upvalues: v72 (copy)
        if coroutine.status(v72) == "suspended" then
            task.cancel(v72)
        end
    end)

    local v73 = v61.Position + v61.LookVector * 6.5 + v61.RightVector * 2 + Vector3.new(0, 1.4, 0)

    Cine.Blend(CFrame.lookAt(v73, Position3 + Vector3.new(0, 0.6, 0)), 0.25, v28 - 14)
    task.wait(0.8)

    if not p33() then
        return false
    end

    local Attachment0 = if p32 then p32.Attachment0 else nil
    local v74 = v22:Add(Instance.new("Part"))

    v74.Name = "GhostFishHaulAnchor"
    v74.Anchored = true
    v74.CanCollide = false
    v74.CanQuery = false
    v74.CanTouch = false
    v74.Transparency = 1
    v74.Size = Vector3.new(1, 1, 1)
    v74.CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(0, 140, 0))
    v74.Parent = Workspace

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v74

    if p32 and Attachment0 then
        p32.Attachment1 = Attachment
        p32.CurveSize0 = 0
        p32.CurveSize1 = 0
        p32.Width0 = 0.2
        p32.Width1 = 0.2
        p32.Color = ColorSequence.new(Color3.new(1, 1, 1), Fx.Ghost)
    end

    local LineTug = GhostDogQuest.Sounds.LineTug

    Fx.Play(LineTug[#LineTug], {
        Volume = 0.9
    })
    Fx.Shake(1.6, 0.25)

    local v75 = v22:Add(Instance.new("Attachment"))

    v75.Parent = HumanoidRootPart

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(v4)
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.Size = NumberSequence.new(0.5, 0.1)
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(2, 6)
    ParticleEmitter.SpreadAngle = Vector2.new(60, 60)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom
    ParticleEmitter.Rate = 70
    ParticleEmitter.Parent = v75

    local v76 = Fx.Play(SlideLoop, {
        Volume = 0.7,
        Looped = true,
        PlaybackSpeed = 1.8
    })

    if v76 then
        v22:Add(v76)
    end

    Fx.Play(GhostDogQuest.Sounds.Surfaced, {
        Volume = 0.6
    })
    Hud.Bubbles(1.5, 80)

    local v77 = Hud.FadeFrame()

    if v77 then
        v77.BackgroundColor3 = v5
        v77.BackgroundTransparency = 1
    end

    local v78 = v61.LookVector * Vector3.new(1, 0, 1)
    local v79 = if v78.Magnitude > 0.05 then v78.Unit else Vector3.new(0, 0, 1)
    local v80 = v79:Cross((Vector3.new(0, 1, 0)))
    local v81 = Cine.SpeedLens(0.2, 26)
    local _CFrame4 = v23.CFrame

    run(1.5, function(p37, p38) -- line: 485
        -- upvalues: GhostFishCatchPuppet (copy), v23 (copy), v28 (copy), v61 (copy), v74 (copy), v77 (copy), v79 (copy), v80 (copy), v81 (copy), _CFrame4 (copy), Fx (copy)
        local v82 = Fx.Ease(p37, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local elapsed = os.clock()
        local v84 = v61.Position + Vector3.new(0, 75 * v82, 0)

        GhostFishCatchPuppet.Set(CFrame.lookAt(v84, v84 + v79) * CFrame.Angles(0.17453292519943295 * v82, 0, math.sin(elapsed * 9) * 0.08 * (1 - v82)))
        v74.CFrame = CFrame.new(v84 + Vector3.new(0, 140, 0))

        local v89 = v84 - Vector3.new(0, 9 + 4 * v82, 0) + v80 * 7 - v79 * 5

        v23.CFrame = _CFrame4:Lerp(CFrame.lookAt(v89, v84 + Vector3.new(0, 3, 0)), (math.min(p37 * 3, 1)))
        v23.FieldOfView = v81(v89, p38, v28 - 6)

        if not v77 then
            return
        end

        v77.BackgroundTransparency = 1 - Fx.Ease(math.clamp((p37 - 0.6) / 0.4, 0, 1), Enum.EasingStyle.Sine)
    end)

    if v77 then
        v77.BackgroundTransparency = 0
    end

    ParticleEmitter.Rate = 0

    if v76 then
        v76:Destroy()
    end

    GhostFishCatchHold.Holding = false
    GhostFishCatchPuppet.Stop()

    while coroutine.status(v72) ~= "dead" and p33() do
        task.wait()
    end

    if not (v71 and p33()) then
        return false
    end

    return (invoke(Remotes.GhostDogQuest.Surface, 3))
end

function t2.Breach(p39, p40, p41, p42) -- line: 523
    -- upvalues: Workspace (copy), Cast (copy), Cine (copy), Fx (copy), GhostDogQuest (copy), Hud (copy), Swim (copy), LocalPlayer (copy), GhostDogQuest2 (copy), v1 (copy), v3 (copy), v4 (copy), Swoosh (copy), HeavyLand (copy), CollectSecretRing (copy), SlideLoop (copy), SlideHit (copy), run (copy), puppet (copy), hold (copy), playFish (copy)
    local Character = LocalPlayer.Character
    local v93, v94

    if Character then
        v93 = Character:FindFirstChild("HumanoidRootPart")
        v94 = Character:FindFirstChildOfClass("Humanoid")
    else
        v94 = Character
        v93 = Character
    end

    local v95 = Hud.FadeFrame()

    if Character ~= nil and v93 ~= nil and v93:IsA("BasePart") and v94 ~= nil then
        local elapsed = os.clock()

        while (v93.Position - p41.Position).Magnitude > 25 and os.clock() - elapsed < 6 and p42() do
            task.wait()
        end

        local v96, v97, v98, v99, v100, v101

        if (v93.Position - p41.Position).Magnitude > 25 then
            v101 = true
        elseif p42() then
            v96 = p39:Extend()
            Cast.LockControls(v96)
            v97 = Cine.Take(p39)

            local v102 = v97

            p39:Add(function() -- line: 545
                -- upvalues: v102 (copy), LocalPlayer (copy)
                if v102.CameraType ~= Enum.CameraType.Scriptable then
                    return
                end

                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                v102.CameraType = Enum.CameraType.Custom

                if Humanoid then
                    v102.CameraSubject = Humanoid
                end
            end)
            v94.PlatformStand = true

            local v103 = v94

            p39:Add(function() -- line: 556
                -- upvalues: v103 (copy)
                v103.PlatformStand = false
            end)
            v98 = Cine.RestingFov()

            local v104 = p40.Y + 0.3

            v99 = Vector3.new(p40.X, v104, p40.Z)

            local v105 = p41.Position - v99

            v100 = -p41.LookVector

            local v106 = v105 * Vector3.new(1, 0, 1)

            if v106.Magnitude > 0.05 then
                v100 = v106.Unit
            end

            v101 = false
        else
            v101 = true
        end

        if v101 then
            return
        end

        local Unit = (Vector3.new(0, 1, 0)):Cross(v100).Unit
        local v107 = CFrame.lookAt(v99 - Vector3.new(0, 7, 0), v99 - Vector3.new(0, 7, 0) + v100)
        local v108 = v107 + Vector3.new(0, 5.4, 0)
        local GhostFishBreachPuppet = puppet(p39, v93, "GhostFishBreachPuppet")

        GhostFishBreachPuppet.Set(v107)

        local clone = p39:Clone(GhostDogQuest2.GhostFish)

        clone:ScaleTo(0.22)
        clone.Parent = Workspace

        local GhostFishBreachHold = hold(p39, v93, clone, "GhostFishBreachHold")

        GhostFishBreachHold.Holding = true
        playFish(clone, "GhostFish_Idle", true, 0.8)

        local Swim2 = Swim.Start(p39, Character, "Swim")
        local v109 = v99:Lerp(p41.Position, 0.5) + Vector3.new(0, 2, 0)
        local v110 = Cine.Unclip(v109, v99 - v100 * 9 + Unit * 9 + Vector3.new(0, 6, 0))
        local v111 = v99 - v100 * 6 + Unit * 4 + Vector3.new(0, 3.5, 0)

        Cine.Cut(CFrame.lookAt(v111, v99), v98)

        if v95 then
            Fx.Tween(v95, 0.35, {
                BackgroundTransparency = 1
            })
        end

        local v112 = Fx.Play(SlideLoop, {
            Volume = 0.6,
            Looped = true,
            PlaybackSpeed = 2
        })

        if v112 then
            p39:Add(v112)
        end

        run(0.55, function(p43) -- line: 590
            -- upvalues: v97 (ref), v99 (ref), v107 (copy), v108 (copy), GhostFishBreachPuppet (copy), v111 (copy), Fx (copy)
            local v113 = Fx.Ease(p43, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            GhostFishBreachPuppet.Set(v107:Lerp(v108, v113) * CFrame.Angles(0, 0, math.sin(p43 * 30) * 0.1))

            if math.random() < 0.35 then
                Fx.Ripple(v99, p43 + 0.6)
            end

            v97.CFrame = CFrame.lookAt(v111, v99) * CFrame.Angles(0, 0, math.noise(os.clock() * 12, 3) * 0.02)
        end)

        if v112 then
            v112:Destroy()
        end

        Fx.Splash(v99, 2.6)
        Fx.Burst(v99 + Vector3.new(0, 1, 0), v4, 30, 22, 0.9)
        Fx.Play(GhostDogQuest.Sounds.Splash, {
            Volume = 1,
            PlaybackSpeed = 0.9
        })
        Fx.Play(Swoosh, {
            Volume = 0.8,
            PlaybackSpeed = 0.95
        })
        Fx.Shake(1.8, 0.35)

        if Swim2 then
            Swim2.Set("Swim", 2)
        end

        local v116 = v99 + Vector3.new(0, 1, 0)
        local Position = p41.Position
        local v118 = math.clamp((Position - v116).Magnitude * 0.3, 5, 11)
        local v119 = v110 + v100 * 2 + Vector3.new(0, 1.5, 0)
        local v120 = Cine.SpeedLens(0.3, 20)

        run(1, function(p44, p45) -- line: 615
            -- upvalues: p41 (copy), v97 (ref), v98 (ref), v99 (ref), v108 (copy), GhostFishBreachPuppet (copy), v111 (copy), v116 (copy), Position (copy), v118 (copy), v119 (copy), v120 (copy), Fx (copy)
            local v121 = Fx.Ease(p44, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v125 = v116:Lerp(Position, v121) + Vector3.new(0, math.sin(p44 * 3.141592653589793) * v118, 0)
            local v126 = CFrame.Angles(0, 6.283185307179586 * Fx.Ease(p44, Enum.EasingStyle.Quad), 0)

            GhostFishBreachPuppet.Set(CFrame.new(v125) * v108.Rotation:Lerp(p41.Rotation, v121) * v126)

            local v127 = v111:Lerp(v119, Fx.Ease(p44, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

            v97.CFrame = CFrame.lookAt(v127, v99:Lerp(v125, 0.7))
            v97.FieldOfView = v120(v127, p45, v98)
        end)
        GhostFishBreachPuppet.Set(p41)
        Swim.Stop()

        local v128 = v94.HipHeight + v93.Size.Y * 0.5

        Fx.Play(SlideHit, {
            Volume = 0.6
        })
        Fx.Play(HeavyLand, {
            Volume = 0.3,
            PlaybackSpeed = 1.3
        })
        Fx.Shake(0.8, 0.25)
        Fx.Burst(Position - Vector3.new(0, v128, 0), v4, 14, 8, 0.6)

        local Position2 = (p41 * v1).Position
        local v129 = p41.Position + p41.LookVector * 8 + p41.RightVector * 2.5 + Vector3.new(0, 1.8, 0)

        Cine.Blend(CFrame.lookAt(Cine.Unclip(Position2, v129), Position2 + Vector3.new(0, 0.8, 0)), 0.4, v98 - 10)
        playFish(clone, "GhostFish_Thrash", false, 1.4)
        task.wait(0.6)
        GhostFishBreachHold.Holding = false
        Fx.Burst(Position2, Fx.Ghost, 30, 16, 1.1)
        Fx.Burst(Position2, v3, 18, 12, 0.8)
        Fx.Play(CollectSecretRing, {
            Volume = 0.7,
            PlaybackSpeed = 1.1
        })
        clone:Destroy()
        GhostFishBreachPuppet.Stop()
        v93.CFrame = p41
        v93.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v94.PlatformStand = false

        if p42() then
            Cine.Release(v94, v93)
            v96:Clean()
        end
    end
end

return table.freeze(t2)

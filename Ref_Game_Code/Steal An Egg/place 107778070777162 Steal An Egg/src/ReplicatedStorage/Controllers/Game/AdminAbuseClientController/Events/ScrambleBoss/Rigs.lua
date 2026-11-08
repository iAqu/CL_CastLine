-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ScrambleBossHazards = require(ReplicatedStorage.Shared.Util.ScrambleBossHazards)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local rad = math.rad
local v1 = Color3.fromRGB(30, 40, 30)
local v2 = NumberRange.new(0.35, 0.75)
local v3 = Color3.fromRGB(120, 220, 255)
local v4 = Color3.fromRGB(235, 250, 255)
local v5 = NumberRange.new(0.35, 0.8)
local v6 = Color3.fromRGB(80, 255, 60)
local v7 = Color3.fromRGB(255, 45, 45)
local t1 = {
    Idle = 120484795823977,
    Walk = 107270328959157,
    Spawn = 105745907093338,
    Summon = 95582559814590,
    SpikesAttack = 79479910863027,
    SpikesStrike = 79479910863027,
    SpikeSlam = 115149678962464,
    GrabThrow = 112978654814407,
    SlamDown = 140381763957066,
    Leap = 136703401677693,
    Overheat = 116934559155212,
    Eject = 108503440344107,
    Death = 73457528876079
}
local t2 = {
    Idle = {},
    Recover = {
        Fade = 0.8
    },
    Walk = {
        Clip = "Walk",
        Loop = true,
        Walk = true
    },
    Rush = {
        Clip = "Walk",
        Loop = true,
        Walk = true,
        Speed = 1.8
    },
    SpawnDrop = {
        Clip = "Spawn",
        Speed = 2.3,
        HoldAt = 2.9
    },
    SpawnLand = {
        Clip = "Spawn",
        From = 2.9,
        Speed = 1.3,
        Hold = true
    },
    Drop = {
        Clip = "Leap",
        From = 0.7,
        Speed = 2,
        HoldAt = 2.85
    },
    Land = {
        Clip = "Leap",
        From = 2.85
    },
    SlamCharge = {
        Clip = "SlamDown",
        Speed = 0.6666666666666666,
        HoldAt = 1.43
    },
    Slam = {
        Clip = "SlamDown",
        From = 1.43
    },
    Pound = {
        Clip = "SpikeSlam"
    },
    Swipe = {
        Clip = "SpikesAttack",
        Speed = 0.5,
        HoldAt = 0.45
    },
    SwipeStrike = {
        Clip = "SpikesStrike",
        From = 0.73,
        Speed = 0.7,
        HoldAt = 1.6
    },
    Barrage = {
        Clip = "SpikesAttack",
        Loop = true
    },
    Grab = {
        Clip = "GrabThrow",
        Speed = 0.68,
        HoldAt = 1
    },
    Hold = {
        Clip = "GrabThrow",
        From = 1,
        Speed = 0.4,
        HoldAt = 1.75
    },
    Throw = {
        Clip = "GrabThrow",
        From = 1.75,
        Speed = 1.6
    },
    Summon = {
        Clip = "Summon",
        Hold = true
    },
    Laser = {
        Clip = "GrabThrow",
        Speed = 0.68,
        HoldAt = 1
    },
    Call = {
        Clip = "Summon",
        Hold = true
    },
    Laugh = {
        Clip = "Summon",
        Hold = true
    },
    Roar = {
        Clip = "Spawn",
        Speed = 2.2
    },
    Overheat = {
        Clip = "Overheat",
        Hold = true
    },
    Eject = {
        Clip = "Eject",
        Hold = true
    },
    Fall = {
        Clip = "Death",
        Hold = true
    },
    Dead = {
        Clip = "Death",
        From = 1e999,
        Hold = true
    }
}

local function a(p1, p2, p3) -- line: 110
    -- upvalues: rad (copy)
    return CFrame.Angles(rad(p1), rad(p2 or 0), (rad(p3 or 0)))
end

local function clipAnimation(p4) -- line: 114
    local Animation = Instance.new("Animation")

    Animation.AnimationId = "rbxassetid://" .. p4

    return Animation
end

local function preloadClips() -- line: 120
    -- upvalues: ContentProvider (copy), t1 (copy)
    local v12 = table.clone(t1)

    for i = 1, 3 do
        local t3 = {}

        for _, v13 in v12 do
            local Animation = Instance.new("Animation")

            Animation.AnimationId = "rbxassetid://" .. v13
            table.insert(t3, Animation)
        end

        local t4 = {}

        local function v14() -- line: 129
            -- upvalues: t3 (copy), t4 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t3, function(p5, p6) -- line: 132
                -- upvalues: t4 (copy)
                local v15 = tonumber(string.match(p5, "(%d+)%D*$"))

                if v15 and p6 == Enum.AssetFetchStatus.Success then
                    t4[v15] = true
                end
            end)
        end

        pcall(v14)

        for _, v16 in t3 do
            v16:Destroy()
        end

        for v17, v18 in v12 do
            if t4[v18] then
                v12[v17] = nil
            end
        end

        if next(v12) == nil then
            return
        end

        task.wait(i * 2)
    end

    for v19, v20 in v12 do
        warn(string.format("[ScrambleBoss] mech clip %s (%d) failed to preload", v19, v20))
    end
end

local function holdPoint(p7, p8) -- line: 161
    if p7.HoldAt then
        return (math.min(p7.HoldAt, p8.Length - 0.04))
    end

    return if p7.Hold then math.max(p8.Length - 0.04, 0) else nil
end

local t5 = {}

function t5.Mech(p9, p10) -- line: 173
    -- upvalues: RunService (copy), Workspace (copy), ScrambleBossHazards (copy), Kit (copy), rad (copy), v1 (copy), v7 (copy), t1 (copy), t2 (copy)
    local v23 = os.clock() + 5

    while p10:GetAttribute("AnimAt") == nil and os.clock() < v23 do
        task.wait()
    end

    if p10.Parent == nil then
        return nil
    end

    local v24 = p10.PrimaryPart or p10:WaitForChild("RootPart")
    local t6 = {}

    for _, descendant in v24:GetDescendants() do
        if descendant:IsA("Bone") then
            t6[descendant.Name] = descendant
        end
    end

    local UpperTorso1 = t6.UpperTorso1

    p9:Connect(p10:GetAttributeChangedSignal("Anim"), function() -- line: 190
        -- upvalues: p10 (copy), v24 (copy), Kit (copy)
        if p10:GetAttribute("Anim") == "Laugh" then
            Kit.Sound("DrScrambleLaughing", v24, 1)
        end
    end)

    local AnimationController = p10:FindFirstChildWhichIsA("AnimationController")

    if not AnimationController then
        AnimationController = p10:WaitForChild("AnimationController", 5)
    end

    if AnimationController == nil then
        AnimationController = Instance.new("AnimationController")
        AnimationController.Parent = p10
        p9:Add(AnimationController)
    end

    p9:Connect(p10.ChildAdded, function(p11) -- line: 203
        -- upvalues: p10 (copy), AnimationController (ref)
        if p11 ~= AnimationController and p11:IsA("AnimationController") then
            task.defer(function() -- line: 205
                -- upvalues: p11 (copy), p10 (copy)
                if p11.Parent == p10 then
                    p11.Parent = nil
                end
            end)
        end
    end)

    local Animator = AnimationController:FindFirstChildWhichIsA("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = AnimationController
        p9:Add(Animator)
    end

    local t7 = {}
    local t8 = {}
    local t9 = {}
    local t10 = {}

    local function load(p12) -- line: 223
        -- upvalues: Animator (ref), t7 (copy), t8 (copy), t9 (copy), t1 (copy)
        local v25 = t1[p12]
        local Animation = Instance.new("Animation")

        Animation.AnimationId = "rbxassetid://" .. v25

        local track = Animator:LoadAnimation(Animation)

        Animation:Destroy()
        t7[p12] = track
        t8[p12] = os.clock()
        t9[p12] = (t9[p12] or 0) + 1

        return track
    end

    for v26 in t1 do
        local v27 = t1[v26]
        local Animation = Instance.new("Animation")

        Animation.AnimationId = "rbxassetid://" .. v27

        local track = Animator:LoadAnimation(Animation)

        Animation:Destroy()
        t7[v26] = track
        t8[v26] = os.clock()
        t9[v26] = (t9[v26] or 0) + 1
    end

    t7.Idle.Looped = true
    t7.Idle:Play(0)
    p9:Add(function() -- line: 238
        -- upvalues: t7 (copy)
        for _, v28 in t7 do
            v28:Stop(0)
            v28:Destroy()
        end
    end)

    local t11 = {}
    local t12

    for _, descendant in p10:GetDescendants() do
        local FollowBone = descendant:GetAttribute("FollowBone")
        local v29 = FollowBone and t6[FollowBone]

        if v29 ~= nil then
            if descendant:IsA("BasePart") then
                local Follow = descendant:FindFirstChild("Follow")

                if Follow then
                    local t13 = {
                        Motor = Follow,
                        Bone = v29,
                        Offset = v29.WorldCFrame:ToObjectSpace(descendant.CFrame)
                    }

                    table.insert(t11, t13)

                    if descendant.Name == "ClawR" then
                        t12 = t13
                    end
                end
            elseif descendant:IsA("Attachment") then
                table.insert(t11, {
                    Attachment = descendant,
                    Bone = v29,
                    Offset = v29.WorldCFrame:ToObjectSpace(descendant.WorldCFrame)
                })
            end
        end
    end

    local v30 = p10:WaitForChild("Pilot", 5)

    if v30 then
        local v31 = v30:GetAttribute("Parts") or 0
        local v32 = os.clock() + 5

        while os.clock() < v32 do
            local n1 = 0

            for _, descendant in v30:GetDescendants() do
                if descendant:IsA("BasePart") then
                    n1 += 1
                end
            end

            if v31 <= n1 then
                break
            end

            task.wait(0.1)
        end
    end

    local clone
    local v33 = CFrame.identity

    if v30 and UpperTorso1 then
        local clone2 = v30:Clone()
        local PrimaryPart = clone2.PrimaryPart

        for _, descendant in clone2:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = descendant == PrimaryPart
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
                descendant.Massless = true
            elseif descendant:IsA("WeldConstraint") then
                if descendant.Part0 and not descendant.Part0:IsDescendantOf(clone2) or descendant.Part1 and not descendant.Part1:IsDescendantOf(clone2) then
                    descendant:Destroy()
                end
            elseif descendant:IsA("BallSocketConstraint") then
                descendant.Enabled = false
            elseif descendant:IsA("Humanoid") then
                descendant.EvaluateStateMachine = false
                descendant.PlatformStand = true
            end
        end

        for _, descendant in clone2:GetDescendants() do
            if descendant:IsA("AnimationConstraint") then
                local Attachment0, Attachment1 = descendant.Attachment0, descendant.Attachment1
                local v34 = Attachment0 and Attachment0.Parent
                local v35 = Attachment1 and Attachment1.Parent

                if Attachment0 and Attachment1 and v34 and v35 and v34:IsA("BasePart") and v35:IsA("BasePart") then
                    local Motor6D = Instance.new("Motor6D")

                    Motor6D.Name = descendant.Name
                    Motor6D.Part0 = v34
                    Motor6D.Part1 = v35
                    Motor6D.C0 = Attachment0.CFrame
                    Motor6D.C1 = Attachment1.CFrame
                    Motor6D.Parent = v35
                end

                descendant:Destroy()
            end
        end

        local v36 = v30:FindFirstChild("Animations") and v30.Animations:FindFirstChild("Drive")
        local v37 = clone2:FindFirstChildWhichIsA("Humanoid") or clone2:FindFirstChildWhichIsA("AnimationController")

        for _, descendant in v30:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 1
            end
        end

        v33 = UpperTorso1.WorldCFrame:ToObjectSpace(v30:GetPivot())
        clone2.Name = "PilotView"
        clone2.Parent = p10
        p9:Add(clone2)

        if v36 and v36:IsA("Animation") and v36.AnimationId ~= "" and v37 then
            local v38 = v37:FindFirstChildWhichIsA("Animator") or Instance.new("Animator")

            v38.Parent = v37

            local track = v38:LoadAnimation(v36)

            track.Looped = true
            track:Play(0)
        end

        p9:Connect(v30.AncestryChanged, function() -- line: 366
            -- upvalues: p10 (copy), v30 (copy), clone (ref), clone2 (copy)
            if not v30:IsDescendantOf(p10) then
                clone2:Destroy()
                clone = nil
            end
        end)
        clone = clone2
    end

    local t15 = {}
    local t16 = {}

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("Eye") then
            t15[descendant] = descendant.Color
        elseif descendant:IsA("Attachment") and descendant:GetAttribute("OverheatFx") then
            for _, descendant in descendant:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Light") then
                    descendant.Enabled = false
                    table.insert(t16, descendant)
                end
            end
        end
    end

    local t17 = {
        Jiggle = 0,
        Key = "",
        Clip = nil,
        Track = nil,
        StartedAt = 0,
        Pending = false,
        Overheated = false,
        WalkRate = 1,
        GrabFree = 0,
        GrabShake = 0,
        HitFlash = 0,
        Spec = t2.Idle,
        LastPosition = v24.Position
    }
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "HitFlash"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v7
    Highlight.OutlineColor = v7
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Enabled = false
    Highlight.Adornee = p10
    Highlight.Parent = p10
    p9:Add(Highlight)

    local function enter(p13, p14) -- line: 418
        -- upvalues: t7 (copy), t17 (copy), t2 (copy)
        local v39 = t2[p13] or t2.Idle
        local v40 = if v39.Clip then t7[v39.Clip] else nil
        local Track = t17.Track

        if Track and Track ~= v40 then
            Track:Stop(v39.Fade or 0.25)
        end

        t17.Spec = v39
        t17.Clip = v39.Clip
        t17.Track = v40
        t17.StartedAt = p14
        t17.Pending = v40 ~= nil

        if v40 then
            v40.Looped = v39.Loop == true
        end
    end

    local function start(p15, p16) -- line: 436
        -- upvalues: t17 (copy), Workspace (copy)
        local v41 = p16.Speed or 1
        local v43 = math.max(Workspace:GetServerTimeNow() - t17.StartedAt, 0)
        local v44 = (p16.From or 0) + v43 * v41

        if p16.Loop then
            v44 %= p15.Length
        end

        local v45 = if p16.HoldAt then math.min(p16.HoldAt, p15.Length - 0.04) elseif p16.Hold then math.max(p15.Length - 0.04, 0) else nil
        local v49 = math.min(v44, v45 or p15.Length - 0.04)

        p15.Looped = p16.Loop == true

        if not p15.IsPlaying then
            p15:Play(0.25)
        end

        p15.TimePosition = math.max(v49, 0)

        if v45 and v45 <= v49 then
            v41 = 0
        end

        p15:AdjustSpeed(v41)
    end

    local function retryMissing() -- line: 453
        -- upvalues: Animator (ref), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t17 (copy), t1 (copy)
        local elapsed = os.clock()

        for v50, v51 in t7 do
            if not (v51.Length > 0) and not t10[v50] and not (elapsed - t8[v50] < 4) then
                if t9[v50] >= 5 then
                    t10[v50] = true
                    warn(string.format("[ScrambleBoss] mech clip %s (%d) never loaded", v50, t1[v50]))
                else
                    v51:Destroy()

                    local v52 = t1[v50]
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = "rbxassetid://" .. v52

                    local track = Animator:LoadAnimation(Animation)

                    Animation:Destroy()
                    t7[v50] = track
                    t8[v50] = os.clock()
                    t9[v50] = (t9[v50] or 0) + 1

                    if t17.Clip == v50 then
                        t17.Track = track
                        t17.Pending = true
                    end
                end
            end
        end
    end

    local function keepIdle() -- line: 481
        -- upvalues: t7 (copy)
        local Idle = t7.Idle

        if not (Idle.Length <= 0) then
            if not Idle.Looped then
                Idle.Looped = true
            end

            if not Idle.IsPlaying then
                Idle:Play(0.25)
            end
        end
    end

    local function drive(p17) -- line: 495
        -- upvalues: p10 (copy), v24 (copy), t7 (copy), t17 (copy), enter (copy), start (copy), retryMissing (copy)
        local v53 = p10:GetAttribute("Anim") or "Idle"
        local v54 = p10:GetAttribute("AnimAt") or 0
        local v55 = v53 .. "@" .. v54

        if v55 ~= t17.Key then
            t17.Key = v55
            enter(v53, v54)
        end

        retryMissing()

        local Idle = t7.Idle

        if not (Idle.Length <= 0) then
            if not Idle.Looped then
                Idle.Looped = true
            end

            if not Idle.IsPlaying then
                Idle:Play(0.25)
            end
        end

        local Position = v24.Position
        local v58 = Vector3.new(Position.X - t17.LastPosition.X, 0, Position.Z - t17.LastPosition.Z)

        t17.LastPosition = Position

        if p17 > 0 then
            local v60 = math.clamp(v58.Magnitude / p17 / 20, 0.4, 1.6)

            t17.WalkRate = t17.WalkRate + (v60 - t17.WalkRate) * (1 - math.exp(-p17 * 2))
        end

        local Track, Spec = t17.Track, t17.Spec

        if Track ~= nil and not (Track.Length <= 0) then
            if t17.Pending then
                t17.Pending = false
                start(Track, Spec)
            elseif not Spec.Loop or Track.IsPlaying then
                if Spec.Walk then
                    Track:AdjustSpeed((Spec.Speed or 1) * t17.WalkRate)
                else
                    local v63 = if Spec.HoldAt then math.min(Spec.HoldAt, Track.Length - 0.04) elseif Spec.Hold then math.max(Track.Length - 0.04, 0) else nil

                    if v63 ~= nil then
                        if Track.IsPlaying then
                            if Track.Speed ~= 0 and v63 <= Track.TimePosition then
                                Track.TimePosition = v63
                                Track:AdjustSpeed(0)
                            end
                        else
                            Track:Play(0)
                            Track.TimePosition = v63
                            Track:AdjustSpeed(0)
                        end
                    end
                end
            else
                start(Track, Spec)
            end
        end
    end

    p9:Connect(RunService.PreAnimation, function(p18) -- line: 552
        -- upvalues: p10 (copy), drive (copy)
        if p10.Parent ~= nil then
            drive(p18)
        end
    end)
    p9:Connect(RunService.PreSimulation, function(p19) -- line: 558
        -- upvalues: p10 (copy), v24 (copy), UpperTorso1 (copy), t11 (copy), t12 (ref), clone (ref), v33 (ref), t15 (copy), t16 (copy), t17 (copy), Highlight (copy), ScrambleBossHazards (copy), Kit (copy), rad (copy), v1 (copy)
        if p10.Parent == nil then
            return
        end

        t17.Jiggle = math.max(0, t17.Jiggle - p19 * 5)
        t17.HitFlash = math.max(0, t17.HitFlash - p19 / 0.18)

        local HitFlash = t17.HitFlash

        Highlight.Enabled = HitFlash > 0
        Highlight.FillTransparency = 1 - 0.6 * HitFlash
        Highlight.OutlineTransparency = 1 - HitFlash

        local Jiggle = t17.Jiggle

        if Jiggle > 0 and UpperTorso1 then
            local Transform = UpperTorso1.Transform
            local v69 = math.sin(os.clock() * 70) * 3.5 * Jiggle
            local v71 = math.cos(os.clock() * 53) * 3 * Jiggle
            local v73 = math.sin(os.clock() * 61) * 2.5 * Jiggle

            UpperTorso1.Transform = Transform * CFrame.Angles(rad(v69), rad(v71 or 0), (rad(v73 or 0)))
        end

        local _CFrame = v24.CFrame
        local v78

        for _, v79 in t11 do
            local v80 = v79.Bone.TransformedWorldCFrame * v79.Offset

            if v79 == t12 then
                v78 = v80
            end

            if v79.Motor then
                local Motor = v79.Motor

                Motor.Transform = Motor.C0:Inverse() * _CFrame:ToObjectSpace(v80) * Motor.C1
            else
                v79.Attachment.WorldCFrame = v80
            end
        end

        if clone and UpperTorso1 then
            clone:PivotTo(UpperTorso1.TransformedWorldCFrame * v33)
        end

        local GrabFree = p10.Parent and p10.Parent:GetAttribute("GrabFree") or 0

        if t17.GrabFree < GrabFree then
            t17.GrabShake = 1
        end

        t17.GrabFree = GrabFree
        t17.GrabShake = math.max(0, t17.GrabShake - p19 * 4)

        local ScrambleGrab = v24:FindFirstChild("ScrambleGrab")

        if v78 and ScrambleGrab and ScrambleGrab:IsA("Weld") then
            local v82 = t17.GrabShake * 0.3

            ScrambleGrab.C0 = ScrambleBossHazards.GripCFrame(_CFrame:PointToObjectSpace(v78.Position)) * CFrame.Angles(math.sin(os.clock() * 38) * v82, 0, math.cos(os.clock() * 31) * v82)
        end

        local v87 = p10:GetAttribute("Overheated") == true

        if v87 ~= t17.Overheated then
            t17.Overheated = v87

            for _, v88 in t16 do
                v88.Enabled = v87
            end
        end

        local v89 = p10:GetAttribute("Anim") or "Idle"
        local v91 = (math.sin(os.clock() * 14) + 1) / 2
        local v92 = v89 == "Fall" or v89 == "Dead" or v89 == "Eject"

        for v93, v94 in t15 do
            if v92 then
                v93.Color = v1:Lerp(Kit.Red, if v89 == "Eject" then v91 else 0)
            else
                v93.Color = v94
            end
        end
    end)

    return {
        Hit = function(p20) -- Hit | line: 633
            -- upvalues: t17 (copy)
            t17.Jiggle = p20 and 1 or 0.6
            t17.HitFlash = 1
        end
    }
end

function t5.Ball(p21, p22, _) -- line: 640
    -- upvalues: RunService (copy), Kit (copy), Vfx (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
    local Animations = p22:FindFirstChild("Animations")
    local v96 = p22:FindFirstChildWhichIsA("Humanoid", true)
    local v97 = p22:FindFirstChild("DrScrambleBall", true)
    local v98 = v97 and v97:FindFirstChildWhichIsA("AnimationController", true)
    local t19 = {}

    if Animations and v96 then
        local v99 = v96:FindFirstChildWhichIsA("Animator") or Instance.new("Animator")

        v99.Parent = v96

        local PilotDrive = Animations:FindFirstChild("PilotDrive")

        if PilotDrive and PilotDrive:IsA("Animation") and PilotDrive.AnimationId ~= "" then
            table.insert(t19, v99:LoadAnimation(PilotDrive))
        end
    end

    if Animations and v98 then
        local v100 = v98:FindFirstChildWhichIsA("Animator") or Instance.new("Animator")

        v100.Parent = v98

        local BallDrive = Animations:FindFirstChild("BallDrive")

        if BallDrive and BallDrive:IsA("Animation") and BallDrive.AnimationId ~= "" then
            table.insert(t19, v100:LoadAnimation(BallDrive))
        end
    end

    for _, v101 in t19 do
        v101.Looped = true
        v101:Play(0)
    end

    p21:Add(function() -- line: 666
        -- upvalues: t19 (copy)
        for _, v102 in t19 do
            v102:Stop(0)
            v102:Destroy()
        end
    end)

    local PrimaryPart = p22.PrimaryPart
    local v103
    local n2 = 0

    if PrimaryPart then
        local v104, v105 = Kit.Loop("BallDriving", PrimaryPart)

        v103 = v104
        n2 = v105

        if v104 then
            p21:Add(v104)
        end
    end

    local v106 = if PrimaryPart then PrimaryPart.Position else Vector3.new(0, 0, 0)
    local v107 = p22:GetAttribute("Stunned") == true
    local t20 = {}
    local t21 = {}

    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("DamageGlow") then
            t20[descendant] = descendant.Color
        elseif descendant:IsA("ParticleEmitter") and descendant.Name == "DamageSmoke" then
            descendant.Enabled = false
            table.insert(t21, descendant)
        end
    end

    local Visor = p22:FindFirstChild("Visor")
    local Glass = Visor and Visor:FindFirstChild("Glass")
    local VisorFollow = Glass and Glass:FindFirstChild("VisorFollow")
    local v108 = if not Glass or not v97 then nil else v97:FindFirstChild(Glass:GetAttribute("FollowBone") or "", true)
    local FollowOffset = Glass and Glass:GetAttribute("FollowOffset")
    local t22 = {}
    local n3 = -1

    if Visor then
        for _, descendant in Visor:GetDescendants() do
            if descendant:IsA("BasePart") and descendant:GetAttribute("CrackAt") then
                table.insert(t22, descendant)
            end
        end
    end

    local PrimaryPart2 = p22.PrimaryPart
    local _, BoundingBox = p22:GetBoundingBox()

    for _, v109 in Vfx.Trail(PrimaryPart2, BoundingBox.X) do
        p21:Add(v109)
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "CoreHighlight"
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillColor = v3
    Highlight.OutlineColor = v6
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 0.3
    Highlight.Adornee = p22
    Highlight.Parent = p22
    p21:Add(Highlight)

    local n4 = 0
    local n5 = 0
    local n6 = 0

    p21:Connect(RunService.RenderStepped, function(p24) -- line: 733
        -- upvalues: p22 (copy), PrimaryPart (copy), v103 (ref), n2 (ref), v106 (ref), v107 (ref), t20 (copy), t21 (copy), t22 (copy), n3 (ref), Highlight (copy), n4 (ref), n5 (ref), n6 (ref), FollowOffset (copy), VisorFollow (copy), v108 (copy), Kit (copy), v4 (copy), v5 (copy), v6 (copy)
        local v111 = math.clamp(p22:GetAttribute("DamageRatio") or 0, 0, 1)
        local v112 = p22:GetAttribute("Stunned") == true
        local v114 = (math.sin(os.clock() * (v111 * 28 + 12)) + 1) * 0.5
        local v115 = math.noise(os.clock() * (v111 * 18 + 8), 0, 0) * 0.5 + 0.5
        local v117 = math.clamp(v111 * (v114 * 0.35 + 0.35 + v115 * 0.3), 0, 0.9)

        if v112 then
            v117 = math.max(v117, v114 * 0.8)
        end

        for v119, v120 in t20 do
            v119.Color = v120:Lerp(Color3.fromRGB(8, 35, 12), v117)
        end

        if VisorFollow and v108 and typeof(FollowOffset) == "CFrame" then
            local v121 = v108.TransformedWorldCFrame * FollowOffset
            local CFrame = VisorFollow.Part0.CFrame

            VisorFollow.Transform = VisorFollow.C0:Inverse() * CFrame:ToObjectSpace(v121) * VisorFollow.C1
        end

        if v111 ~= n3 then
            n3 = v111

            for _, v122 in t22 do
                v122.Transparency = (v122:GetAttribute("CrackAt") or 2) <= v111 and 0.1 or 1
            end
        end

        for _, v123 in t21 do
            v123.Enabled = v111 >= 0.28
            v123.Rate = v111 * 5 + 1
        end

        local Sound, v124

        if v112 and not v107 then
            Sound = Kit.Sound
            v124 = PrimaryPart or p22
            Sound("DrivingStunned", v124, 1)
        end

        v107 = v112

        if v103 and PrimaryPart then
            local v125 = (PrimaryPart.Position - v106).Magnitude / math.max(p24, 0.004166666666666667)

            v106 = PrimaryPart.Position

            local v126 = if v112 then 0 else math.clamp(v125 / 45, 0.25, 1)
            local v129 = math.min(1, p24 * 5)

            v103.Volume += (v126 * n2 - v103.Volume) * v129
        end

        local v131 = if v112 then 1 else 0

        n4 += (v131 - n4) * math.min(1, p24 * 6)

        if os.clock() >= n6 then
            n6 = os.clock() + 0.05
            n5 = math.random()
        end

        Highlight.FillTransparency = 1 - (1 - (v5.Min + (v5.Max - v5.Min) * n5)) * n4
        Highlight.OutlineColor = v6:Lerp(v4, n4)
        Highlight.OutlineTransparency = (n5 * 0.6 - 0.3) * n4 + 0.3
    end)
end

local function waitForDroneParts(p25) -- line: 793
    local v136 = p25:WaitForChild("Hitbox", 10)
    local elapsed = os.clock()

    while p25.PrimaryPart == nil and p25.Parent ~= nil and os.clock() - elapsed < 10 do
        task.wait()
    end

    return v136, p25.PrimaryPart
end

local function attachDroneBar(p26, p27, p28) -- line: 807
    -- upvalues: TweenService (copy), Workspace (copy), waitForDroneParts (copy)
    local v137, v138 = waitForDroneParts(p27)
    local Y, v139

    if v137 == nil or v138 == nil then
        v139 = true
    elseif p27:IsDescendantOf(Workspace) then
        local VisualSize = p27:GetAttribute("VisualSize")

        Y = if typeof(VisualSize) == "Vector3" then VisualSize.Y else select(2, p27:GetBoundingBox()).Y
        v139 = false
    else
        v139 = true
    end

    if v139 then
        return
    end

    local clone = p28:Clone()

    clone.Adornee = v138
    clone.StudsOffsetWorldSpace = Vector3.new(0, Y / 2 + 2, 0)
    clone.Enabled = true
    clone.Parent = v138
    p26:Add(clone)

    local HealthProgress = clone:FindFirstChild("HealthProgress")
    local v141

    if HealthProgress then
        v141 = HealthProgress:FindFirstChild("Fill")
        HealthProgress = HealthProgress:FindFirstChild("TextLabel")
    else
        v141 = HealthProgress
    end

    local function refresh() -- line: 828
        -- upvalues: v137 (copy), HealthProgress (ref), v141 (ref), TweenService (copy)
        local v142 = v137:GetAttribute("Health") or 0
        local v144 = math.max(v137:GetAttribute("MaxHealth") or 1, 1)
        local v146 = math.clamp(v142 / v144, 0, 1)

        if HealthProgress then
            local format = string.format
            local v147 = math.ceil(v142)

            HealthProgress.Text = format("%d / %d HP", math.max(0, v147), v144)
        end

        if not v141 then
            return
        end

        local v148 = v146 > 0

        v141.Visible = v148
        TweenService:Create(v141, TweenInfo.new(0.15), {
            Size = UDim2.fromScale(v146, 1)
        }):Play()
    end

    p26:Connect(v137:GetAttributeChangedSignal("Health"), refresh)
    p26:Connect(v137:GetAttributeChangedSignal("MaxHealth"), refresh)
    refresh()
end

function t5.Drone(p29, p30) -- line: 846
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Kit (copy), v2 (copy), attachDroneBar (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.FillColor = Kit.Red
    Highlight.OutlineColor = Kit.Red
    Highlight.FillTransparency = 0.9
    Highlight.OutlineTransparency = v2.Min
    Highlight.Adornee = p30
    Highlight.Parent = p30
    p29:Add(Highlight)

    local ScrambleBoss = ReplicatedStorage.Assets.UI:FindFirstChild("ScrambleBoss")
    local DroneHealth = ScrambleBoss and ScrambleBoss:FindFirstChild("DroneHealth")

    if DroneHealth then
        p29:Add(task.spawn(attachDroneBar, p29, p30, DroneHealth))
    end

    local elapsed

    p29:Connect(RunService.RenderStepped, function() -- line: 863
        -- upvalues: p30 (copy), Highlight (copy), elapsed (ref), Kit (copy), v2 (copy)
        if p30.Parent ~= nil then
            if p30:GetAttribute("Armed") then
                if elapsed == nil then
                    elapsed = os.clock()
                    Kit.Sound("DroneFuse", p30.PrimaryPart, 1)
                end

                local v149 = os.clock() - elapsed

                Highlight.FillTransparency = math.floor(v149 * (if v149 < 1.86 then 2 else 11)) % 2 == 0 and 0.3 or 0.85
                Highlight.OutlineTransparency = 0
            else
                if elapsed then
                    elapsed = nil

                    local v152 = p30.PrimaryPart and p30.PrimaryPart:FindFirstChild("DroneFuse")

                    if v152 then
                        v152:Destroy()
                    end
                end

                local v154 = (math.sin(os.clock() * 3) + 1) / 2

                Highlight.FillTransparency = 0.9
                Highlight.OutlineTransparency = v2.Min + (v2.Max - v2.Min) * v154
            end
        end
    end)
end

task.spawn(preloadClips)

return t5

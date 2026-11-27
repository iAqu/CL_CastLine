-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local HarpoonConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HarpoonConfig"))
local VFXBurst = require(ReplicatedStorage.Modules:WaitForChild("VFXBurst"))
local WaterBoom = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("WaterBoom")
local JumpBurst = ReplicatedStorage.VFX:WaitForChild("JumpBurst")
local Dive, Leave = HarpoonConfig.Dive, HarpoonConfig.Leave
local Folder = Instance.new("Folder")

Folder.Name = "DiveSFX"
Folder.Parent = SoundService

local t1 = {}

for _, v1 in ipairs({ "rbxassetid://83673781452193", "rbxassetid://76105899921199", "rbxassetid://126105529228330" }) do
    local Sound = Instance.new("Sound")

    Sound.SoundId = v1
    Sound.Volume = 1
    Sound.RollOffMaxDistance = 200
    Sound.Parent = Folder
    t1[v1] = Sound
end

local t2 = {
    "Root",
    "Waist",
    "Neck",
    "LeftShoulder",
    "RightShoulder",
    "LeftElbow",
    "RightElbow",
    "LeftHip",
    "RightHip",
    "LeftKnee",
    "RightKnee"
}
local t3 = {
    0, 0, 0
}
local t4 = {
    RootPos = Vector3.new(0, -1, 0),
    Root = { -22, 0, 0 },
    Waist = { 12, 0, 0 },
    Neck = { 18, 0, 0 },
    LeftShoulder = { -70, 0, -12 },
    RightShoulder = { -70, 0, 12 },
    LeftElbow = { 25, 0, 0 },
    RightElbow = { 25, 0, 0 },
    LeftHip = { 95, 0, 0 },
    RightHip = { 95, 0, 0 },
    LeftKnee = { -160, 0, 0 },
    RightKnee = { -160, 0, 0 }
}
local t5 = {
    RootPos = Vector3.new(0, 0.3, 0),
    Root = { 6, 0, 0 },
    Waist = { 4, 0, 0 },
    Neck = { -6, 0, 0 },
    LeftShoulder = { 55, 0, -10 },
    RightShoulder = { 55, 0, 10 },
    LeftElbow = { 10, 0, 0 },
    RightElbow = { 10, 0, 0 },
    LeftHip = { -15, 0, 0 },
    RightHip = { -15, 0, 0 },
    LeftKnee = { -8, 0, 0 },
    RightKnee = { -8, 0, 0 }
}
local t6 = {
    Root = { 14, 0, 0 },
    Waist = { 5, 0, 0 },
    Neck = { 4, 0, 0 },
    LeftShoulder = { 110, 0, -25 },
    RightShoulder = { 110, 0, 25 },
    LeftElbow = { 20, 0, 0 },
    RightElbow = { 20, 0, 0 },
    LeftHip = { 35, 0, 0 },
    RightHip = { 35, 0, 0 },
    LeftKnee = { -25, 0, 0 },
    RightKnee = { -25, 0, 0 }
}
local t7 = {
    Root = { 24, 0, 0 },
    Waist = { 8, 0, 0 },
    Neck = { 8, 0, 0 },
    LeftShoulder = { 150, 0, -30 },
    RightShoulder = { 150, 0, 30 },
    LeftElbow = { 25, 0, 0 },
    RightElbow = { 25, 0, 0 },
    LeftHip = { 55, 0, 0 },
    RightHip = { 55, 0, 0 },
    LeftKnee = { -35, 0, 0 },
    RightKnee = { -35, 0, 0 }
}
local t8 = {
    Root = { 22, 0, 0 },
    Waist = { 6, 0, 0 },
    Neck = { 12, 0, 0 },
    LeftShoulder = { 175, 0, -40 },
    RightShoulder = { 175, 0, 40 },
    LeftElbow = { 30, 0, 0 },
    RightElbow = { 30, 0, 0 },
    LeftHip = { 70, 0, 0 },
    RightHip = { 70, 0, 0 },
    LeftKnee = { -60, 0, 0 },
    RightKnee = { -60, 0, 0 }
}
local t9 = {
    Root = { 0, 0, 0 },
    Waist = { 0, 0, 0 },
    Neck = { 0, 0, 0 },
    LeftShoulder = { 30, 0, -15 },
    RightShoulder = { 30, 0, 15 },
    LeftElbow = { 40, 0, 0 },
    RightElbow = { 40, 0, 0 },
    LeftHip = { 90, 0, 0 },
    RightHip = { 90, 0, 0 },
    LeftKnee = { -90, 0, 0 },
    RightKnee = { -90, 0, 0 }
}
local t10 = {
    {
        t = 0,
        ease = "soft",
        pose = {}
    },
    {
        t = 0.12,
        ease = "snap",
        pose = t4
    },
    {
        ease = "soft",
        t = Dive.Charge,
        pose = t4
    },
    {
        ease = "snap",
        t = Dive.Charge + 0.12,
        pose = t5
    },
    {
        ease = "soft",
        t = Dive.Charge + Dive.Air * 0.42,
        pose = t6
    },
    {
        ease = "soft",
        t = Dive.Charge + Dive.Air * 0.68,
        pose = t7
    },
    {
        ease = "soft",
        flail = true,
        t = Dive.Charge + Dive.Air * 0.92,
        pose = t8
    },
    {
        ease = "snap",
        t = Dive.Charge + Dive.Air + Dive.LandSnap,
        pose = t9
    }
}
local v2 = Dive.Charge + Dive.Air + Dive.LandSnap
local v3 = (v2 - Dive.Charge) / Leave.Speed

local function returnDiveTime(p1) -- line: 116
    -- upvalues: Leave (copy), v2 (copy)
    return v2 - p1 * Leave.Speed
end

local v4 = (Dive.LandSnap + Dive.Air / 2) / Leave.Speed

local function returnPoseWeight(p2) -- line: 122
    -- upvalues: Leave (copy), v4 (copy)
    local v6 = math.clamp((p2 - v4) / Leave.Blend, 0, 1)

    return 1 - v6 * v6 * (3 - v6 * 2)
end

local function ease(p3, p4) -- line: 127
    if p3 == "snap" then
        return 1 - (1 - p4) ^ 2
    end

    return p4 * p4 * (3 - 2 * p4)
end

local function lerp3(p5, p6, p7) -- line: 132
    return p5[1] + (p6[1] - p5[1]) * p7, p5[2] + (p6[2] - p5[2]) * p7, p5[3] + (p6[3] - p5[3]) * p7
end

local function poseAt(p8, p9) -- line: 137
    local v7 = p8[1]
    local v8 = p8[1]

    for i = 2, #p8 do
        if p9 < p8[i].t then
            v8 = p8[i]
            v7 = p8[i - 1]
            break
        end

        v7 = p8[i]
        v8 = p8[i]
    end

    local v9 = if v8 == v7 then 1 else math.clamp((p9 - v7.t) / (v8.t - v7.t), 0, 1)
    local v11 = if v8.ease == "snap" then 1 - (1 - v9) ^ 2 else v9 * v9 * (3 - 2 * v9)
    local v12, v13

    if v8.flail or v7.flail and v8 == v7 then
        local v15 = math.sin(p9 * 24) * 12 * v11

        if v15 then
            v12 = v15
            v13 = true
        else
            v13 = false
        end
    else
        v13 = false
    end

    if not v13 then
        v12 = 0
    end

    return v7.pose, v8.pose, v11, v12
end

local function apply(p10, p11, p12, p13) -- line: 150
    -- upvalues: t2 (copy), t3 (copy), poseAt (copy)
    local v16, v17, v18, v19 = poseAt(p11, p12)

    for _, v20 in ipairs(t2) do
        local v21 = p10.joints[v20]

        if v21 then
            local v22 = v16[v20] or t3
            local v23 = v17[v20] or t3
            local v24 = v22[1] + (v23[1] - v22[1]) * v18
            local v25 = v22[2] + (v23[2] - v22[2]) * v18
            local v26 = v22[3] + (v23[3] - v22[3]) * v18

            if v19 ~= 0 then
                if v20 == "LeftShoulder" then
                    v24 += v19
                elseif v20 == "RightShoulder" then
                    v24 -= v19
                end
            end

            local v27 = CFrame.Angles(math.rad(v24), math.rad(v25), (math.rad(v26)))

            if v20 == "Root" then
                local v28 = (v16.RootPos or Vector3.new(0, 0, 0)):Lerp(v17.RootPos or Vector3.new(0, 0, 0), v18)

                v27 = CFrame.new(v28) * v27
            end

            v21.Transform = if p13 and p13 < 1 then CFrame.identity:Lerp(v27, p13) else v27
        end
    end
end

local function clearJoints(p14) -- line: 170
    for _, v29 in pairs(p14.joints) do
        v29.Transform = CFrame.identity
    end
end

local function jointsOf(p15) -- line: 174
    -- upvalues: t2 (copy)
    local t11 = {}

    for _, descendant in ipairs(p15:GetDescendants()) do
        if (descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint")) and table.find(t2, descendant.Name) then
            t11[descendant.Name] = descendant
        end
    end

    return t11
end

local function burstWithSound(p16, p17, p18, p19) -- line: 182
    -- upvalues: VFXBurst (copy), t1 (copy)
    local v30 = VFXBurst.Play(p16, p17, p18)
    local clone = t1[p19]:Clone()

    clone.Parent = v30
    clone:Play()
end

local function splash(p20) -- line: 188
    -- upvalues: VFXBurst (copy), WaterBoom (copy), t1 (copy)
    local v31 = CFrame.new(p20)
    local v32 = VFXBurst.Play(WaterBoom, v31, 1.2)
    local clone = t1["rbxassetid://83673781452193"]:Clone()

    clone.Parent = v32
    clone:Play()
end

local function breach(p21) -- line: 191
    -- upvalues: VFXBurst (copy), WaterBoom (copy), t1 (copy)
    local v33 = CFrame.new(p21)
    local v34 = VFXBurst.Play(WaterBoom, v33, 1.2)
    local clone = t1["rbxassetid://126105529228330"]:Clone()

    clone.Parent = v34
    clone:Play()
end

local function launchBurst(p22, p23) -- line: 197
    -- upvalues: VFXBurst (copy), JumpBurst (copy), t1 (copy)
    local Humanoid = p22:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p22:FindFirstChild("HumanoidRootPart")
    local v35 = (Humanoid and Humanoid.HipHeight or 2) + (HumanoidRootPart and HumanoidRootPart.Size.Y / 2 or 1)
    local v36 = p23.Position - Vector3.new(0, v35, 0)
    local v37 = CFrame.new(v36) * p23.Rotation
    local v38 = VFXBurst.Play(JumpBurst, v37, 1)
    local clone = t1["rbxassetid://76105899921199"]:Clone()

    clone.Parent = v38
    clone:Play()
end

local function arcCF(p24, p25, p26, p27, p28) -- line: 207
    local v42 = p24.Position:Lerp(p25.Position, p26) + Vector3.new(0, p27 * (1 - math.abs(2 * p26 - 1) ^ p28), 0)

    return CFrame.new(v42) * p24.Rotation:Lerp(p25.Rotation, (math.min(1, p26 * 2)))
end

local function returnCF(p29, p30, p31, p32, p33) -- line: 217
    local v48 = p29.Position:Lerp(p30.Position, p31) + Vector3.new(0, p32 * (1 - math.abs(2 * p31 - 1) ^ p33), 0)
    local _, v49 = p30:ToOrientation()
    local _, v50 = p29:ToOrientation()
    local v51 = (v50 - v49 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
    local v52 = v51 + (if v51 < 0 then -2 else 2) * 3.141592653589793
    local v53 = 1 - p31
    local v54 = v53 * v53 * (3 - 2 * v53)

    return CFrame.new(v48) * CFrame.fromOrientation(0, v49 + v52 * v54, 0)
end

local t12 = {}

local function freshCamera(p34) -- line: 248
    -- upvalues: RunService (copy)
    if p34.CameraType ~= Enum.CameraType.Custom then
        return
    end

    p34.CameraType = Enum.CameraType.Scriptable
    task.spawn(function() -- line: 251
        -- upvalues: p34 (copy), RunService (copy)
        RunService.Heartbeat:Wait()

        if p34.CameraType == Enum.CameraType.Scriptable then
            p34.CameraType = Enum.CameraType.Custom
        end
    end)
end

local function yawOf(p35) -- line: 256
    return (math.atan2(-p35.X, -p35.Z))
end

local function cameraFollowsReturn(p36, p37) -- line: 259
    -- upvalues: RunService (copy), Dive (copy), Leave (copy), v2 (copy), t12 (copy)
    local CurrentCamera = workspace.CurrentCamera
    local ret = p37.ret
    local _, v57 = ret.from:ToOrientation()
    local LookVector = CurrentCamera.CFrame.LookVector
    local v60 = math.atan2(-LookVector.X, -LookVector.Z)
    local v61 = (v57 - v60 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

    RunService:BindToRenderStep("DiveReturnCamera", Enum.RenderPriority.Camera.Value + 1, function() -- line: 265
        -- upvalues: p36 (copy), p37 (copy), CurrentCamera (copy), ret (copy), v60 (copy), v61 (copy), RunService (copy), Dive (copy), Leave (copy), v2 (copy), t12 (copy)
        local v64 = v2 - (workspace:GetServerTimeNow() - ret.t0) * Leave.Speed
        local v65 = v64 < Dive.Charge or t12[p36] ~= p37
        local v66 = if v65 then 1 else math.clamp(1 - (v64 - Dive.Charge) / Dive.Air, 0, 1)
        local v68 = v60 + v61 * v66 * v66 * (3 - 2 * v66)
        local LookVector = CurrentCamera.CFrame.LookVector
        local v71 = (v68 - math.atan2(-LookVector.X, -LookVector.Z) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        local FocusPosition = CurrentCamera.Focus.Position

        CurrentCamera.CFrame = CFrame.new(FocusPosition) * CFrame.Angles(0, v71, 0) * CFrame.new(-FocusPosition) * CurrentCamera.CFrame

        if not v65 then
            return
        end

        RunService:UnbindFromRenderStep("DiveReturnCamera")

        if CurrentCamera.CameraType ~= Enum.CameraType.Custom then
            return
        end

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        task.spawn(function() -- line: 251
            -- upvalues: CurrentCamera (copy), RunService (copy)
            RunService.Heartbeat:Wait()

            if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        end)
    end)
end

local function watch(p38) -- line: 280
    -- upvalues: Players (copy), jointsOf (copy), t12 (copy), cameraFollowsReturn (copy)
    local function update() -- line: 281
        -- upvalues: p38 (copy), Players (copy), jointsOf (copy), t12 (copy), cameraFollowsReturn (copy)
        local DiveT0 = p38:GetAttribute("DiveT0")
        local ReturnT0 = p38:GetAttribute("ReturnT0")
        local v72 = t12[p38]

        if DiveT0 and not v72 then
            v72 = {
                joints = jointsOf(p38),
                hrp = p38:FindFirstChild("HumanoidRootPart")
            }
            t12[p38] = v72
        end

        if not v72 then
            return
        end

        if DiveT0 then
            v72.t0 = DiveT0

            local DiveFrom = p38:GetAttribute("DiveFrom")
            local DiveTo = p38:GetAttribute("DiveTo")

            v72.from = DiveFrom
            v72.to = DiveTo
        else
            v72.t0 = nil
        end

        if ReturnT0 and not v72.ret then
            v72.ret = {
                landed = false,
                t0 = ReturnT0,
                from = p38:GetAttribute("ReturnFrom"),
                to = p38:GetAttribute("ReturnTo")
            }

            if p38 == Players.LocalPlayer.Character and typeof(v72.ret.from) == "CFrame" then
                cameraFollowsReturn(p38, v72)
            end
        end

        if not DiveT0 and not v72.ret then
            for _, v73 in pairs(v72.joints) do
                v73.Transform = CFrame.identity
            end

            t12[p38] = nil
        end
    end

    p38:GetAttributeChangedSignal("DiveT0"):Connect(update)
    p38:GetAttributeChangedSignal("ReturnT0"):Connect(update)
    p38.AncestryChanged:Connect(function() -- line: 307
        -- upvalues: p38 (copy), t12 (copy)
        if not p38.Parent then
            t12[p38] = nil
        end
    end)
    update()
end

local function watchPlayer(p39) -- line: 313
    -- upvalues: watch (copy)
    if p39.Character then
        watch(p39.Character)
    end

    p39.CharacterAdded:Connect(watch)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        watch(player.Character)
    end

    player.CharacterAdded:Connect(watch)
end

Players.PlayerAdded:Connect(watchPlayer)

local _ = {
    AMP = 0.35,
    PERIOD = 5.5,
    TILT = 1.6,
    RANGE = 450,
    BLEND = 0.5
}
local t13 = {}

local function bobCF(p40, p41, p42) -- line: 332
    local v74 = p40:GetAttribute("BobAmplitude") or 0.35
    local v75 = p40:GetAttribute("BobPeriod") or 5.5
    local v77 = math.rad(p40:GetAttribute("TiltDegrees") or 1.6)
    local v78 = 6.283185307179586 / v75 * p42 + p41
    local v81 = v74 * (math.sin(v78) * 0.7 + math.sin(v78 * 1.71 + 1.3) * 0.3)
    local v83 = v77 * math.sin(v78 * 0.83 + 0.7)
    local v86 = v77 * 0.6 * math.sin(v78 * 1.13 + 2.1)

    return CFrame.new(0, v81, 0) * CFrame.Angles(v86, 0, v83)
end

local function drawBob(p43, p44, p45, p46, p47) -- line: 343
    -- upvalues: t13 (copy), bobCF (copy)
    p44.blend = math.clamp(p44.blend + (if p44.on and p46 then p46 else -p46) / 0.5, 0, 1)

    if p44.blend <= 0 then
        if not p44.parked then
            p44.floaty:PivotTo(p44.restF)
            p43:PivotTo(p44.restH)
            p44.parked = true
        end

        if not p44.on then
            t13[p43] = nil
        end
    elseif (p44.floaty:GetAttribute("FloatRange") or 450) < (p44.restF.Position - p47).Magnitude then
        if not p44.parked then
            p44.floaty:PivotTo(p44.restF)
            p43:PivotTo(p44.restH)
            p44.parked = true
        end
    else
        local v88 = bobCF(p44.floaty, p44.phase, p45)
        local v89 = p44.blend * p44.blend * (3 - 2 * p44.blend)
        local v90 = p44.restF * CFrame.identity:Lerp(v88, v89)

        p44.floaty:PivotTo(v90)
        p43:PivotTo(v90 * p44.rel)
        p44.parked = false
    end
end

local function watchAfloat(p48) -- line: 370
    -- upvalues: t13 (copy)
    p48.DescendantAdded:Connect(function(p49) -- line: 374
        -- upvalues: p48 (copy)
        if not p49:IsA("BasePart") then
            return
        end

        local Rel = p49:GetAttribute("Rel")
        local Host = p49:GetAttribute("Host")

        if typeof(Rel) == "CFrame" and type(Host) == "string" and p49:FindFirstAncestor("GunSkin") then
            local Spear = p48:FindFirstChild("Spear")

            for _, descendant in ipairs(p48:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant.Name == Host and not descendant:FindFirstAncestor("GunSkin") and (not Spear or not descendant:IsDescendantOf(Spear)) then
                    p49.CFrame = descendant.CFrame * Rel

                    return
                end
            end
        end
    end)

    local function update() -- line: 386
        -- upvalues: p48 (copy), t13 (copy)
        local v91 = p48:GetAttribute("Afloat") == true
        local v92 = t13[p48]

        if v91 then
            local v93 = p48.Parent and p48.Parent:FindFirstChild("Floaty")

            if v93 then
                if v92 then
                    v92.on = true
                else
                    local Pivot = v93:GetPivot()
                    local Pivot2 = p48:GetPivot()

                    t13[p48] = {
                        blend = 0,
                        on = true,
                        parked = true,
                        floaty = v93,
                        restF = Pivot,
                        restH = Pivot2,
                        rel = Pivot:Inverse() * Pivot2,
                        phase = (Pivot.Position.X * 0.37 + Pivot.Position.Z * 0.61) % 6.283185307179586
                    }
                end
            end
        elseif v92 then
            v92.on = false
        end
    end

    p48:GetAttributeChangedSignal("Afloat"):Connect(update)
    update()
end

local t14 = {}
local t15 = {}

local function sinkDy(p50, p51, p52, p53, p54, p55) -- line: 428
    if p50 < p51 then
        local v94 = p50 / p51

        return p53 * (v94 * v94 * v94 - 2 * v94 * v94 + v94) + p54 * (3 * v94 * v94 - 2 * v94 * v94 * v94)
    end

    local v96 = math.clamp((p50 - p51) / p55, 0, 1)

    return p54 + (p52 - p54) * (v96 * v96 * (3 - v96 * 2))
end

local function riseDy(p56, p57, p58, p59, p60, p61) -- line: 442
    local v98 = math.clamp(p56 / p57, 0, 1)
    local v99 = v98 * v98
    local v100 = v98 * v98 * v98

    return p58 * (v100 * 2 - v99 * 3 + 1) + p59 * (v100 - v99 * 2 + v98) + p60 * (v99 * 3 - v100 * 2) + p61 * (v100 - v99)
end

local function drawMove(p62, p63, p64) -- line: 447
    -- upvalues: VFXBurst (copy), WaterBoom (copy), t1 (copy)
    local v102 = math.max(0, p64 - p63.t0)
    local v103 = p63.dy(v102)
    local v104 = Vector3.new(0, v103, 0)

    p62:PivotTo(p63.base + v104)

    if p63.floaty then
        p63.floaty:PivotTo(p63.floatyBase + v104)
    end

    if p63.hrp and p63.hrp.Parent and p63.seat then
        local v105 = p63.seat + Vector3.new(0, p63.seatDy, 0) + v104

        p63.hrp.CFrame = v105

        if p63.kind == "rise" and not p63.broke and v105.Position.Y >= 0 then
            p63.broke = true

            local v106 = Vector3.new(v105.Position.X, 0, v105.Position.Z)
            local v107 = CFrame.new(v106)
            local v108 = VFXBurst.Play(WaterBoom, v107, 1.2)
            local clone = t1["rbxassetid://126105529228330"]:Clone()

            clone.Parent = v108
            clone:Play()
        end

        if p63.kind == "sink" and not p63.broke and p63.lastY and p63.lastY >= 0 and v105.Position.Y < 0 then
            p63.broke = true

            local v109 = Vector3.new(v105.Position.X, 0, v105.Position.Z)
            local v110 = CFrame.new(v109)
            local v111 = VFXBurst.Play(WaterBoom, v110, 1.2)
            local clone = t1["rbxassetid://83673781452193"]:Clone()

            clone.Parent = v111
            clone:Play()
        end

        p63.lastY = v105.Position.Y
    end

    if p63.restBase then
        p62:SetAttribute("RestTop", p63.restBase + v104)
    end

    if p63.lastAt then
        p63.lastV = (v103 - p63.lastDy) / math.max(p64 - p63.lastAt, 0.001)
    end

    p63.lastDy = v103
    p63.lastAt = p64
end

local function startMove(p65, p66, p67, p68, p69, p70) -- line: 478
    -- upvalues: Players (copy), t13 (copy), t14 (copy)
    local Parent = p65.Parent
    local Floaty = Parent and Parent:FindFirstChild("Floaty")
    local PlayerByUserId = Players:GetPlayerByUserId(p65:GetAttribute("OccupantUserId") or 0)
    local v114 = PlayerByUserId and PlayerByUserId.Character
    local v115 = t14[p65]
    local v116 = t13[p65]

    if v116 then
        t13[p65] = nil
    end

    local t16 = {
        lastDy = 0,
        lastV = 0,
        lastAt = nil,
        broke = false,
        kind = p66,
        t0 = p67,
        dy = p68,
        total = p69,
        seatDy = p70 or 0
    }
    local v117, v118

    if v115 then
        local base = v115.base

        if base then
            v117 = base
            v118 = true
        elseif v116 then
            local restH = v116.restH

            if restH then
                v117 = restH
                v118 = true
            else
                v118 = false
            end
        else
            v118 = false
        end
    elseif v116 then
        local restH = v116.restH

        if restH then
            v117 = restH
            v118 = true
        else
            v118 = false
        end
    else
        v118 = false
    end

    t16.base = if not v118 then p65:GetPivot() else v117
    t16.floaty = Floaty

    local v119, v120

    if v115 then
        local floatyBase = v115.floatyBase

        if floatyBase then
            v119 = floatyBase
            v120 = true
        elseif v116 then
            local restF = v116.restF

            if restF then
                v119 = restF
                v120 = true
            else
                v120 = false
            end
        else
            v120 = false
        end
    elseif v116 then
        local restF = v116.restF

        if restF then
            v119 = restF
            v120 = true
        else
            v120 = false
        end
    else
        v120 = false
    end

    t16.floatyBase = if not v120 then Floaty and Floaty:GetPivot() else v119
    t16.restBase = v115 and v115.restBase or p65:GetAttribute("RestTop")

    local HumanoidRootPart, v121

    if not v114 or v114:GetAttribute("TitanRider") then
        v121 = false
    else
        local HumanoidRootPart2 = v114:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart2 then
            HumanoidRootPart = HumanoidRootPart2
            v121 = true
        else
            v121 = false
        end
    end

    t16.hrp = if not v121 then nil else HumanoidRootPart
    t16.seat = v114 and v114:GetAttribute("DiveTo")
    t14[p65] = t16
end

local function stopMove(p71) -- line: 501
    -- upvalues: t14 (copy)
    local v122 = t14[p71]

    t14[p71] = nil

    if not (v122 and workspace:GetServerTimeNow() - v122.t0 < v122.total - 0.05) then
        return
    end

    p71:PivotTo(v122.base)

    if v122.floaty then
        v122.floaty:PivotTo(v122.floatyBase)
    end

    if v122.hrp and v122.hrp.Parent and v122.seat then
        v122.hrp.CFrame = v122.seat + Vector3.new(0, v122.seatDy, 0)
    end

    if v122.restBase then
        p71:SetAttribute("RestTop", v122.restBase)
    end
end

local DepthEase = HarpoonConfig.DepthEase
local LocalPlayer = Players.LocalPlayer
local t17 = {}

local function depthGoalOf(p72) -- line: 525
    -- upvalues: LocalPlayer (copy)
    local v123 = p72:GetAttribute("OccupantUserId") == LocalPlayer.UserId
    local DepthGoalLocal = if v123 then p72:GetAttribute("DepthGoalLocal") else nil

    if not v123 or not DepthGoalLocal then
        return p72:GetAttribute("DepthGoal")
    end

    return DepthGoalLocal
end

local function startDepth(p73) -- line: 532
    -- upvalues: t14 (copy), LocalPlayer (copy), t17 (copy)
    if not t17[p73] and not t14[p73] then
        local SurfaceY = p73:GetAttribute("SurfaceY")
        local DepthGoalLocal = p73:GetAttribute("OccupantUserId") == LocalPlayer.UserId and p73:GetAttribute("DepthGoalLocal") or p73:GetAttribute("DepthGoal")

        if type(SurfaceY) == "number" and DepthGoalLocal then
            t17[p73] = {
                v = 0,
                dy = p73:GetPivot().Position.Y - SurfaceY,
                last = DepthGoalLocal
            }
        end
    end
end

local function drawDepth(p74, p75, p76) -- line: 539
    -- upvalues: Players (copy), DepthEase (copy), LocalPlayer (copy), t17 (copy)
    local SurfaceY = p74:GetAttribute("SurfaceY")
    local SurfaceTop = p74:GetAttribute("SurfaceTop")

    if type(SurfaceY) ~= "number" or typeof(SurfaceTop) ~= "CFrame" then
        t17[p74] = nil

        return
    end

    local DepthGoalLocal = p74:GetAttribute("OccupantUserId") == LocalPlayer.UserId and p74:GetAttribute("DepthGoalLocal") or p74:GetAttribute("DepthGoal")

    if DepthGoalLocal then
        p75.last = DepthGoalLocal
    end

    local v126 = p75.dy + (p75.last - p75.dy) * (1 - math.exp(-DepthEase * p76))

    if math.abs(p75.last - v126) < 0.05 then
        v126 = p75.last
    end

    p75.v = (v126 - p75.dy) / math.max(p76, 0.001)
    p75.dy = v126

    local Pivot = p74:GetPivot()

    p74:PivotTo(CFrame.new(Pivot.X, SurfaceY + v126, Pivot.Z) * Pivot.Rotation)

    local v128 = p74.Parent and p74.Parent:FindFirstChild("Floaty")
    local FloatySurface = p74:GetAttribute("FloatySurface")

    if v128 and typeof(FloatySurface) == "CFrame" then
        v128:PivotTo(FloatySurface + Vector3.new(0, v126, 0))
    end

    p74:SetAttribute("RestTop", SurfaceTop + Vector3.new(0, v126, 0))

    local PlayerByUserId = Players:GetPlayerByUserId(p74:GetAttribute("OccupantUserId") or 0)
    local v129 = PlayerByUserId and PlayerByUserId.Character
    local v130, v131

    if v129 then
        v130 = v129:FindFirstChild("HumanoidRootPart")
        v131 = v129:GetAttribute("DiveTo")
    else
        v131 = v129
        v130 = v129
    end

    if v130 and typeof(v131) == "CFrame" and not v129:GetAttribute("TitanRider") then
        v130.CFrame = v131 + Vector3.new(0, v126, 0)
    end

    local PoseDy = p74:GetAttribute("PoseDy")

    if not DepthGoalLocal and v126 == p75.last and (type(PoseDy) ~= "number" or math.abs(PoseDy - p75.last) < 0.05) then
        t17[p74] = nil
    end
end

local function startSink(p77, p78) -- line: 564
    -- upvalues: sinkDy (copy), startMove (copy)
    local v134 = p77:GetAttribute("SinkTime") or 1
    local v135 = p77:GetAttribute("SinkDist") or 0
    local v136 = p77:GetAttribute("SinkDeep") or v135
    local v137 = p77:GetAttribute("SinkM0") or 0
    local v138 = p77:GetAttribute("SinkPop") or 0.01

    startMove(p77, "sink", p78, function(p79) -- line: 567
        -- upvalues: v134 (copy), v135 (copy), v136 (copy), v137 (copy), v138 (copy), sinkDy (copy)
        return (sinkDy(p79, v134, v135, v137, v136, v138))
    end, v134 + v138)
end

local function watchStation(p80) -- line: 569
    -- upvalues: t14 (copy), t15 (copy), startMove (copy), stopMove (copy), t17 (copy), startDepth (copy)
    p80:GetAttributeChangedSignal("DepthGoal"):Connect(function() -- line: 570
        -- upvalues: p80 (copy), startDepth (copy)
        startDepth(p80)
    end)
    p80:GetAttributeChangedSignal("DepthGoalLocal"):Connect(function() -- line: 571
        -- upvalues: p80 (copy), startDepth (copy)
        startDepth(p80)
    end)
    startDepth(p80)
    p80:GetAttributeChangedSignal("SinkT0"):Connect(function() -- line: 573
        -- upvalues: p80 (copy), t14 (copy), t15 (copy), stopMove (copy)
        local SinkT0 = p80:GetAttribute("SinkT0")

        if SinkT0 then
            t15[p80] = SinkT0
        else
            t15[p80] = nil

            local v139 = t14[p80]

            if not v139 or v139.kind ~= "rise" then
                stopMove(p80)
            end
        end
    end)
    p80:GetAttributeChangedSignal("RiseT0"):Connect(function() -- line: 584
        -- upvalues: p80 (copy), t14 (copy), startMove (copy), stopMove (copy), t17 (copy)
        local RiseT0 = p80:GetAttribute("RiseT0")

        if not RiseT0 then
            stopMove(p80)

            return
        end

        local v140 = p80:GetAttribute("RiseTime") or 1
        local v141 = p80:GetAttribute("RiseTo") or 0
        local v142 = p80:GetAttribute("RiseM1") or 0
        local v143 = t14[p80]
        local v144, v145

        if v143 and v143.kind == "sink" then
            local lastDy = v143.lastDy

            v144 = lastDy
            v145 = not not lastDy
        else
            v145 = false
        end

        if not v145 then
            v144 = 0
        end

        local v146, v147

        if v143 and v143.kind == "sink" then
            local v148 = v143.lastV * v140

            v146 = v148
            v147 = not not v148
        else
            v147 = false
        end

        if not v147 then
            v146 = 0
        end

        local v149 = t17[p80]
        local SurfaceY = p80:GetAttribute("SurfaceY")
        local v150, SurfaceTop, v151

        if not v149 or v143 then
            v151 = true
        elseif type(SurfaceY) == "number" then
            t17[p80] = nil
            v144 = v149.dy + v141
            v146 = v149.v * v140
            startMove(p80, "rise", RiseT0, function(p81) -- line: 602
                -- upvalues: v144 (ref), v146 (ref), v140 (copy), v141 (copy), v142 (copy)
                local v152 = v144
                local v153 = v146
                local v155 = math.clamp(p81 / v140, 0, 1)
                local v156 = v155 * v155
                local v157 = v155 * v155 * v155

                return v152 * (v157 * 2 - v156 * 3 + 1) + v153 * (v157 - v156 * 2 + v155) + v141 * (v156 * 3 - v157 * 2) + v142 * (v157 - v156)
            end, v140, -v141)
            v150 = t14[p80]

            local Pivot = p80:GetPivot()

            v150.base = CFrame.new(Pivot.X, SurfaceY - v141, Pivot.Z) * Pivot.Rotation

            local FloatySurface = p80:GetAttribute("FloatySurface")

            SurfaceTop = p80:GetAttribute("SurfaceTop")

            if v150.floaty and typeof(FloatySurface) == "CFrame" then
                v150.floatyBase = FloatySurface + Vector3.new(0, -v141, 0)
            end

            v151 = false
        else
            v151 = true
        end

        if v151 then
            startMove(p80, "rise", RiseT0, function(p82) -- line: 612
                -- upvalues: v144 (ref), v146 (ref), v140 (copy), v141 (copy), v142 (copy)
                local v159 = v144
                local v160 = v146
                local v162 = math.clamp(p82 / v140, 0, 1)
                local v163 = v162 * v162
                local v164 = v162 * v162 * v162

                return v159 * (v164 * 2 - v163 * 3 + 1) + v160 * (v164 - v163 * 2 + v162) + v141 * (v163 * 3 - v164 * 2) + v142 * (v164 - v163)
            end, v140, -v141)
        elseif typeof(SurfaceTop) == "CFrame" then
            v150.restBase = SurfaceTop + Vector3.new(0, -v141, 0)
        end
    end)
end

local function watchPlot(p83) -- line: 615
    -- upvalues: watchAfloat (copy), watchStation (copy)
    local Harpoon = p83:FindFirstChild("Harpoon")

    if Harpoon then
        watchStation(Harpoon)
        watchAfloat(Harpoon)
    else
        p83.ChildAdded:Connect(function(p84) -- line: 621
            -- upvalues: watchAfloat (copy), watchStation (copy)
            if p84.Name == "Harpoon" then
                watchStation(p84)
                watchAfloat(p84)
            end
        end)
    end
end

local Plots = workspace:WaitForChild("Plots")

for _, child in ipairs(Plots:GetChildren()) do
    watchPlot(child)
end

Plots.ChildAdded:Connect(watchPlot)
task.spawn(function() -- line: 631
    -- upvalues: VFXBurst (copy), WaterBoom (copy), JumpBurst (copy), t1 (copy)
    local v166 = VFXBurst.Emitters(WaterBoom)

    for _, v167 in ipairs(VFXBurst.Emitters(JumpBurst)) do
        v166[#v166 + 1] = v167
    end

    for _, v168 in pairs(t1) do
        v166[#v166 + 1] = v168
    end

    local function v169() -- line: 635
        -- upvalues: v166 (copy)
        game:GetService("ContentProvider"):PreloadAsync(v166)
    end

    pcall(v169)
end)
RunService.Stepped:Connect(function() -- line: 640
    -- upvalues: Leave (copy), t10 (copy), v2 (copy), v3 (copy), v4 (copy), apply (copy), t12 (copy)
    if next(t12) == nil then
        return
    end

    local ServerTimeNow = workspace:GetServerTimeNow()

    for v170, v171 in pairs(t12) do
        if v170.Parent then
            if v171.ret then
                local v172 = ServerTimeNow - v171.ret.t0

                if v3 <= v172 then
                    if not v171.ret.faded then
                        for _, v173 in pairs(v171.joints) do
                            v173.Transform = CFrame.identity
                        end
                    end

                    t12[v170] = nil
                elseif not v171.ret.faded then
                    local v175 = math.clamp((v172 - v4) / Leave.Blend, 0, 1)
                    local v176 = 1 - v175 * v175 * (3 - v175 * 2)

                    if v176 <= 0 then
                        for _, v177 in pairs(v171.joints) do
                            v177.Transform = CFrame.identity
                        end

                        v171.ret.faded = true
                    else
                        apply(v171, t10, v2 - v172 * Leave.Speed, v176)
                    end
                end
            elseif v171.t0 and v171.t0 <= ServerTimeNow and not v170:GetAttribute("TitanRider") then
                apply(v171, t10, ServerTimeNow - v171.t0)
            end
        else
            t12[v170] = nil
        end
    end
end)
RunService.Heartbeat:Connect(function(p85) -- line: 670
    -- upvalues: Dive (copy), Leave (copy), v2 (copy), launchBurst (copy), arcCF (copy), returnCF (copy), t12 (copy), t13 (copy), drawBob (copy), t14 (copy), t15 (copy), drawMove (copy), t17 (copy), drawDepth (copy), startSink (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local CurrentCamera = workspace.CurrentCamera
    local Position = CurrentCamera and CurrentCamera.CFrame.Position or Vector3.new(0, 0, 0)

    for v178, v179 in pairs(t13) do
        if v178.Parent and v179.floaty.Parent then
            drawBob(v178, v179, ServerTimeNow, p85, Position)
        else
            t13[v178] = nil
        end
    end

    for v180, v181 in pairs(t12) do
        local hrp = v181.hrp

        if v180.Parent and hrp and hrp.Parent then
            if v181.ret and v181.ret.from and v181.ret.to then
                local v183 = v2 - (ServerTimeNow - v181.ret.t0) * Leave.Speed

                if Dive.Charge <= v183 and v183 < Dive.Charge + Dive.Air then
                    hrp.CFrame = returnCF(v181.ret.from, v181.ret.to, (v183 - Dive.Charge) / Dive.Air, Dive.Height * Leave.HeightScale, Dive.Hang)
                elseif v183 < Dive.Charge and not v181.ret.landed then
                    v181.ret.landed = true
                    hrp.CFrame = v181.ret.from
                end
            elseif v181.t0 and v181.from and v181.to and not v180:GetAttribute("TitanRider") then
                local v184 = ServerTimeNow - v181.t0

                if Dive.Charge <= v184 and v184 < Dive.Charge + Dive.Air then
                    if not v181.launched then
                        v181.launched = true

                        if v184 < Dive.Charge + 0.5 then
                            launchBurst(v180, v181.from)
                        end
                    end

                    hrp.CFrame = arcCF(v181.from, v181.to, (v184 - Dive.Charge) / Dive.Air, Dive.Height, Dive.Hang)
                elseif Dive.Charge + Dive.Air <= v184 and not v181.seated then
                    v181.seated = true
                    hrp.CFrame = v181.to
                end
            end
        end
    end

    for v186, v187 in pairs(t15) do
        if v186.Parent then
            if v187 <= ServerTimeNow then
                t15[v186] = nil
                startSink(v186, v187)
            end
        else
            t15[v186] = nil
        end
    end

    for v188, v189 in pairs(t14) do
        if v188.Parent then
            drawMove(v188, v189, ServerTimeNow)
        else
            t14[v188] = nil
        end
    end

    for v190, v191 in pairs(t17) do
        if not v190.Parent or t14[v190] then
            t17[v190] = nil
        else
            drawDepth(v190, v191, p85)
        end
    end
end)

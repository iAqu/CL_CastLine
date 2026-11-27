-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local Director = require(script.Parent.Director)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    COMIC = Font.fromEnum(Enum.Font.Bangers)
}
local v1 = Color3.fromRGB(18, 18, 26)
local v2 = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(0.8726646259971648, 0, 0)
local Folder
local t2 = {}
local v3

function t1.folder() -- line: 31
    -- upvalues: Folder (ref)
    if Folder then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "Intro"
    Folder.Parent = workspace

    return Folder
end

function t1.part(p1) -- line: 40
    -- upvalues: t1 (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Material = Enum.Material.SmoothPlastic

    for v4, v5 in p1 do
        Part[v4] = v5
    end

    if not p1.Parent then
        Part.Parent = t1.folder()
    end

    return Part
end

local function joints(p2) -- line: 60
    local function motor(p3, p4) -- line: 61
        -- upvalues: p2 (copy)
        local v6 = p2:FindFirstChild(p3)
        local v7 = v6 and v6:FindFirstChild(p4)

        if v7 and v7:IsA("AnimationConstraint") then
            v7.IsKinematic = true

            return v7
        end

        return if v7 and v7:IsA("Motor6D") then v7 else nil
    end

    if p2:FindFirstChild("UpperTorso") then
        local RightUpperArm = p2:FindFirstChild("RightUpperArm")
        local RightShoulder = RightUpperArm and RightUpperArm:FindFirstChild("RightShoulder")

        if not (RightShoulder and RightShoulder:IsA("AnimationConstraint")) then
            local Motor6D = if RightShoulder then RightShoulder:IsA("Motor6D") else nil

            if not RightShoulder or not Motor6D then
                RightShoulder = nil
            end
        else
            RightShoulder.IsKinematic = true
        end

        local t3 = {}

        t3.RS = RightShoulder

        local RightLowerArm = p2:FindFirstChild("RightLowerArm")
        local RightElbow = RightLowerArm and RightLowerArm:FindFirstChild("RightElbow")

        if not (RightElbow and RightElbow:IsA("AnimationConstraint")) then
            local Motor6D = if RightElbow then RightElbow:IsA("Motor6D") else nil

            if not RightElbow or not Motor6D then
                RightElbow = nil
            end
        else
            RightElbow.IsKinematic = true
        end

        t3.RE = RightElbow

        local LeftUpperArm = p2:FindFirstChild("LeftUpperArm")
        local LeftShoulder = LeftUpperArm and LeftUpperArm:FindFirstChild("LeftShoulder")

        if not (LeftShoulder and LeftShoulder:IsA("AnimationConstraint")) then
            local Motor6D = if LeftShoulder then LeftShoulder:IsA("Motor6D") else nil

            if not LeftShoulder or not Motor6D then
                LeftShoulder = nil
            end
        else
            LeftShoulder.IsKinematic = true
        end

        t3.LS = LeftShoulder

        local LeftLowerArm = p2:FindFirstChild("LeftLowerArm")
        local LeftElbow = LeftLowerArm and LeftLowerArm:FindFirstChild("LeftElbow")

        if not (LeftElbow and LeftElbow:IsA("AnimationConstraint")) then
            local Motor6D = if LeftElbow then LeftElbow:IsA("Motor6D") else nil

            if not LeftElbow or not Motor6D then
                LeftElbow = nil
            end
        else
            LeftElbow.IsKinematic = true
        end

        t3.LE = LeftElbow

        local UpperTorso = p2:FindFirstChild("UpperTorso")
        local Waist = UpperTorso and UpperTorso:FindFirstChild("Waist")

        if not (Waist and Waist:IsA("AnimationConstraint")) then
            local Motor6D = if Waist then Waist:IsA("Motor6D") else nil

            if not Waist or not Motor6D then
                Waist = nil
            end
        else
            Waist.IsKinematic = true
        end

        t3.Waist = Waist

        local Head = p2:FindFirstChild("Head")
        local Neck = Head and Head:FindFirstChild("Neck")

        if not (Neck and Neck:IsA("AnimationConstraint")) then
            local Motor6D = if Neck then Neck:IsA("Motor6D") else nil

            if not Neck or not Motor6D then
                Neck = nil
            end
        else
            Neck.IsKinematic = true
        end

        t3.Neck = Neck

        local LowerTorso = p2:FindFirstChild("LowerTorso")
        local Root = LowerTorso and LowerTorso:FindFirstChild("Root")

        if not (Root and Root:IsA("AnimationConstraint")) then
            local Motor6D = if Root then Root:IsA("Motor6D") else nil

            if not Root or not Motor6D then
                Root = nil
            end
        else
            Root.IsKinematic = true
        end

        t3.Root = Root

        local RightUpperLeg = p2:FindFirstChild("RightUpperLeg")
        local RightHip = RightUpperLeg and RightUpperLeg:FindFirstChild("RightHip")

        if not (RightHip and RightHip:IsA("AnimationConstraint")) then
            local Motor6D = if RightHip then RightHip:IsA("Motor6D") else nil

            if not RightHip or not Motor6D then
                RightHip = nil
            end
        else
            RightHip.IsKinematic = true
        end

        t3.RH = RightHip

        local RightLowerLeg = p2:FindFirstChild("RightLowerLeg")
        local RightKnee = RightLowerLeg and RightLowerLeg:FindFirstChild("RightKnee")

        if not (RightKnee and RightKnee:IsA("AnimationConstraint")) then
            local Motor6D = if RightKnee then RightKnee:IsA("Motor6D") else nil

            if not RightKnee or not Motor6D then
                RightKnee = nil
            end
        else
            RightKnee.IsKinematic = true
        end

        t3.RK = RightKnee

        local LeftUpperLeg = p2:FindFirstChild("LeftUpperLeg")
        local LeftHip = LeftUpperLeg and LeftUpperLeg:FindFirstChild("LeftHip")

        if not (LeftHip and LeftHip:IsA("AnimationConstraint")) then
            local Motor6D = if LeftHip then LeftHip:IsA("Motor6D") else nil

            if not LeftHip or not Motor6D then
                LeftHip = nil
            end
        else
            LeftHip.IsKinematic = true
        end

        t3.LH = LeftHip

        local LeftLowerLeg = p2:FindFirstChild("LeftLowerLeg")
        local LeftKnee = LeftLowerLeg and LeftLowerLeg:FindFirstChild("LeftKnee")

        if not (LeftKnee and LeftKnee:IsA("AnimationConstraint")) then
            local Motor6D = if LeftKnee then LeftKnee:IsA("Motor6D") else nil

            if not LeftKnee or not Motor6D then
                LeftKnee = nil
            end
        else
            LeftKnee.IsKinematic = true
        end

        t3.LK = LeftKnee

        return t3, false
    end

    local Torso = p2:FindFirstChild("Torso")
    local v8 = Torso and Torso:FindFirstChild("Right Shoulder")

    if not (v8 and v8:IsA("AnimationConstraint")) then
        local Motor6D = if v8 then v8:IsA("Motor6D") else nil

        if not v8 or not Motor6D then
            v8 = nil
        end
    else
        v8.IsKinematic = true
    end

    local t4 = {}

    t4.RS = v8

    local Torso2 = p2:FindFirstChild("Torso")
    local v9 = Torso2 and Torso2:FindFirstChild("Left Shoulder")

    if not (v9 and v9:IsA("AnimationConstraint")) then
        local Motor6D = if v9 then v9:IsA("Motor6D") else nil

        if not v9 or not Motor6D then
            v9 = nil
        end
    else
        v9.IsKinematic = true
    end

    t4.LS = v9

    local Torso3 = p2:FindFirstChild("Torso")
    local Neck = Torso3 and Torso3:FindFirstChild("Neck")

    if not (Neck and Neck:IsA("AnimationConstraint")) then
        local Motor6D = if Neck then Neck:IsA("Motor6D") else nil

        if not Neck or not Motor6D then
            Neck = nil
        end
    else
        Neck.IsKinematic = true
    end

    t4.Neck = Neck

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart")
    local RootJoint = HumanoidRootPart and HumanoidRootPart:FindFirstChild("RootJoint")

    if not (RootJoint and RootJoint:IsA("AnimationConstraint")) then
        local Motor6D = if RootJoint then RootJoint:IsA("Motor6D") else nil

        if not RootJoint or not Motor6D then
            RootJoint = nil
        end
    else
        RootJoint.IsKinematic = true
    end

    t4.Root = RootJoint

    local Torso4 = p2:FindFirstChild("Torso")
    local v10 = Torso4 and Torso4:FindFirstChild("Right Hip")

    if not (v10 and v10:IsA("AnimationConstraint")) then
        local Motor6D = if v10 then v10:IsA("Motor6D") else nil

        if not v10 or not Motor6D then
            v10 = nil
        end
    else
        v10.IsKinematic = true
    end

    t4.RH = v10

    local Torso5 = p2:FindFirstChild("Torso")
    local v11 = Torso5 and Torso5:FindFirstChild("Left Hip")

    if not (v11 and v11:IsA("AnimationConstraint")) then
        local Motor6D = if v11 then v11:IsA("Motor6D") else nil

        if not v11 or not Motor6D then
            v11 = nil
        end
    else
        v11.IsKinematic = true
    end

    t4.LH = v11

    return t4, true
end

local function toTransform(p5, p6) -- line: 98
    local v14 = CFrame.Angles(math.rad(p6.X), math.rad(p6.Y), (math.rad(p6.Z)))
    local identity = CFrame.identity

    if p5:IsA("Motor6D") then
        identity = p5.C0.Rotation
    elseif p5.Attachment0 then
        identity = p5.Attachment0.CFrame.Rotation
    end

    return identity:Inverse() * v14 * identity
end

local function target(p7, p8) -- line: 109
    -- upvalues: Director (copy)
    local v15 = p7.targets[p8]
    local v16 = if v15 then Vector3.new(v15[1], v15[2], v15[3]) else Vector3.new(0, 0, 0)
    local v20 = v16

    if p7.isR6 and (p8 == "RS" or p8 == "LS") then
        local v21 = p7.targets[if p8 == "RS" then "RE" else "LE"]

        if v21 then
            v20 = v16 + Vector3.new(v21[1], v21[2], v21[3]) * 0.6
        end
    end

    if p8 ~= "Waist" and (not p7.isR6 or p8 ~= "Root") then
        if p8 == "Neck" then
            v20 -= Vector3.new(math.sin(Director.now() * 2.4 - 0.4) * p7.breath * 0.6, 0, 0)
        end

        return v20
    end

    return v20 + Vector3.new(math.sin(Director.now() * 2.4) * p7.breath, 0, 0)
end

local function spring(p9, p10, p11, p12, p13, p14) -- line: 129
    local v29 = p10 + ((p11 - p9) * (p12 * p12) - p10 * (p13 * 2 * p12)) * p14

    return p9 + v29 * p14, v29
end

local function update(p15) -- line: 134
    -- upvalues: Director (copy), t2 (copy), toTransform (copy), target (copy)
    local v30 = p15 * Director.rate()

    if v30 <= 0 then
        return
    end

    local v33 = math.min(math.ceil(v30 / 0.004166666666666667), 32)
    local v34 = v30 / v33

    for _, v35 in t2 do
        if v35.model.Parent then
            for v36, v37 in v35.joints do
                local v38 = target(v35, v36)
                local v39 = v35.angle[v36] or Vector3.new(0, 0, 0)
                local v40 = v35.vel[v36] or Vector3.new(0, 0, 0)

                for _ = 1, v33 do
                    local speed, damping = v35.speed, v35.damping

                    v40 += ((v38 - v39) * (speed * speed) - v40 * (damping * 2 * speed)) * v34
                    v39 += v40 * v34
                end

                local angle, vel = v35.angle, v35.vel

                angle[v36] = v39
                vel[v36] = v40
                v37.Transform = toTransform(v37, v39)
            end

            if v35.snapOffset then
                local goalPos, goalRot = v35.goalPos, v35.goalRot

                v35.pos = goalPos
                v35.rot = goalRot
                v35.posVel = Vector3.new(0, 0, 0)
                v35.rotVel = Vector3.new(0, 0, 0)
            else
                for _ = 1, v33 do
                    local pos, posVel, goalPos, leanSpeed = v35.pos, v35.posVel, v35.goalPos, v35.leanSpeed
                    local leanDamping = v35.leanDamping
                    local v41 = posVel + ((goalPos - pos) * (leanSpeed * leanSpeed) - posVel * (leanDamping * 2 * leanSpeed)) * v34

                    v35.pos = pos + v41 * v34
                    v35.posVel = v41

                    local rot, rotVel, goalRot, leanSpeed2 = v35.rot, v35.rotVel, v35.goalRot, v35.leanSpeed
                    local leanDamping2 = v35.leanDamping
                    local v42 = rotVel + ((goalRot - rot) * (leanSpeed2 * leanSpeed2) - rotVel * (leanDamping2 * 2 * leanSpeed2)) * v34

                    v35.rot = rot + v42 * v34
                    v35.rotVel = v42
                end
            end

            local rot = v35.rot

            v35.root.CFrame = v35.base * CFrame.new(v35.pos) * CFrame.fromEulerAnglesYXZ(rot.X, rot.Y, rot.Z)

            if v35.after then
                v35.after(v35)
            end
        end
    end
end

local function prepare(p16, p17) -- line: 173
    -- upvalues: RunService (copy), t1 (copy), t2 (copy), v3 (ref), joints (copy), update (copy)
    p16.Name = p17

    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("BaseScript") or descendant:IsA("ForceField") or descendant:IsA("Sound") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Anchored = false
        end
    end

    for _, v43 in { "RodModel", "HeldAnimal" } do
        local v44 = p16:FindFirstChild(v43)

        if v44 then
            v44:Destroy()
        end
    end

    local Humanoid = p16:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.EvaluateStateMachine = false
        Humanoid.PlatformStand = true
    end

    local HumanoidRootPart = p16:FindFirstChild("HumanoidRootPart")

    HumanoidRootPart.Anchored = true
    HumanoidRootPart.Transparency = 1

    local Head = p16:FindFirstChild("Head")
    local v45, v46 = joints(p16)
    local t5 = {
        speed = 14,
        damping = 0.7,
        breath = 1.6,
        pos = Vector3.new(0, 0, 0),
        posVel = Vector3.new(0, 0, 0),
        rot = Vector3.new(0, 0, 0),
        rotVel = Vector3.new(0, 0, 0),
        goalPos = Vector3.new(0, 0, 0),
        goalRot = Vector3.new(0, 0, 0),
        leanSpeed = 12,
        leanDamping = 0.7,
        snapOffset = false,
        model = p16,
        root = HumanoidRootPart,
        head = Head,
        headHeight = if Head then Head.Position.Y - HumanoidRootPart.Position.Y else 1.5,
        humanoid = Humanoid,
        joints = v45,
        isR6 = v46,
        targets = {},
        angle = {},
        vel = {},
        base = HumanoidRootPart.CFrame
    }

    p16.Parent = t1.folder()
    table.insert(t2, t5)
    v3 = v3 or RunService.PreSimulation:Connect(update)

    return t5
end

local function rivalTemplate() -- line: 237
    -- upvalues: ReplicatedStorage (copy)
    return (ReplicatedStorage:WaitForChild("IntroRival", 5))
end

function t1.hero() -- line: 242
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), prepare (copy)
    local Character = LocalPlayer.Character
    local clone

    if Character then
        local Archivable = Character.Archivable

        Character.Archivable = true
        clone = Character:Clone()
        Character.Archivable = Archivable
    end

    if not clone or not clone:FindFirstChild("HumanoidRootPart") then
        local v47 = ReplicatedStorage:WaitForChild("IntroRival", 5)

        clone = v47 and v47:Clone()
    end

    return if clone then prepare(clone, "IntroHero") else nil
end

function t1.rival() -- line: 262
    -- upvalues: ReplicatedStorage (copy), t1 (copy), v1 (copy), prepare (copy)
    local v48 = ReplicatedStorage:WaitForChild("IntroRival", 5)

    if not v48 then
        return nil
    end

    local IntroRival = prepare(v48:Clone(), "IntroRival")
    local head = IntroRival.head

    if head then
        local function onHead(p18, p19, p20) -- line: 271
            -- upvalues: IntroRival (copy), head (copy), t1 (copy)
            p18.Anchored = false
            p18.Massless = true
            p18.Parent = IntroRival.model

            local v49 = t1.part(p18)

            v49.CFrame = head.CFrame * p19

            if p20 then
                local SpecialMesh = Instance.new("SpecialMesh")

                SpecialMesh.MeshType = Enum.MeshType.Sphere
                SpecialMesh.Parent = v49
            end

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = head
            WeldConstraint.Part1 = v49
            WeldConstraint.Parent = v49
        end

        local X, Y, Z = head.Size.X, head.Size.Y, head.Size.Z
        local v50 = Color3.fromRGB(235, 50, 70)

        onHead({
            Name = "Cap",
            Size = Vector3.new(X * 1.12, Y * 0.66, Z * 1.12),
            Color = v50
        }, CFrame.new(0, Y * 0.3, 0), true)

        local t7 = {
            Name = "Peak",
            Shape = Enum.PartType.Cylinder,
            Size = Vector3.new(0.1, X * 0.95, X * 0.95),
            Color = v50:Lerp(Color3.new(0, 0, 0), 0.15)
        }
        local v56 = CFrame.new(0, Y * 0.22, Z * 0.25) * CFrame.Angles(0, 0, 1.5707963267948966)

        t7.Anchored = false
        t7.Massless = true
        t7.Parent = IntroRival.model

        local v57 = t1.part(t7)

        v57.CFrame = head.CFrame * v56

        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Part0 = head
        WeldConstraint.Part1 = v57
        WeldConstraint.Parent = v57

        for _, v58 in { -1, 1 } do
            onHead({
                Name = "Lens",
                Reflectance = 0.5,
                Size = Vector3.new(X * 0.4, Y * 0.24, 0.12),
                Color = v1,
                Material = Enum.Material.Glass
            }, CFrame.new(v58 * X * 0.22, Y * 0.08, -Z / 2 - 0.04), true)
        end

        onHead({
            Name = "Bridge",
            Size = Vector3.new(X * 0.9, 0.06, 0.06),
            Color = v1
        }, CFrame.new(0, Y * 0.14, -Z / 2 - 0.05))
    end

    return IntroRival
end

function t1.place(p21, p22) -- line: 300
    p21.base = p22
end

function t1.show(p23, p24) -- line: 305
    -- upvalues: t1 (copy)
    local model = p23.model

    if p24 then
        model.Parent = t1.folder()
    else
        model.Parent = nil
    end
end

function t1.pose(p25, p26, p27, p28) -- line: 311
    p25.targets = p26
    p25.speed = p27 or 14
    p25.damping = p28 or 0.7
end

function t1.with(p29, p30) -- line: 318
    local v62 = table.clone(p29)

    for v63, v64 in p30 do
        v62[v63] = v64
    end

    return v62
end

function t1.standY(p31, p32) -- line: 327
    return p32 + (if p31.isR6 then 2 elseif p31.humanoid then p31.humanoid.HipHeight else 2) + p31.root.Size.Y / 2
end

function t1.lean(p33, p34, p35, p36, p37) -- line: 334
    local v65, v66, v67 = p34:ToEulerAnglesYXZ()
    local Position = p34.Position
    local v68 = Vector3.new(v65, v66, v67)

    p33.goalPos = Position
    p33.goalRot = v68
    p33.snapOffset = p35 == true
    p33.leanSpeed = p36 or 12
    p33.leanDamping = p37 or 0.7
end

function t1.at(p38, p39) -- line: 343
    -- upvalues: t1 (copy)
    t1.lean(p38, p38.base:ToObjectSpace(p39), true)
end

function t1.hand(p40) -- line: 347
    local RightHand = p40.model:FindFirstChild("RightHand")

    if RightHand then
        return RightHand, CFrame.new(0, -0.15, 0)
    end

    return p40.model:FindFirstChild("Right Arm"), CFrame.new(0, -0.9, 0)
end

function t1.giveRod(p41, p42, p43) -- line: 356
    -- upvalues: RodBuilder (copy), t1 (copy), v2 (copy)
    local v69 = RodBuilder.build(p42, p43)
    local v70, v71 = t1.hand(p41)
    local Weld = Instance.new("Weld")
    local v72 = v71 * v2

    Weld.Part0 = v70
    Weld.C0 = v72
    Weld.Part1 = v69.PrimaryPart
    Weld.C1 = v69.PrimaryPart.CFrame
    Weld.Parent = v69.PrimaryPart
    v69.Parent = p41.model

    return v69, (v69:FindFirstChild("RodTip", true))
end

function t1.seat(p44) -- line: 369
    local model = p44.model
    local v73 = model:FindFirstChild("LowerTorso") or model:FindFirstChild("Torso")
    local v74 = p44.root.Position.Y - (v73.Position.Y - v73.Size.Y / 2)
    local RightUpperLeg = model:FindFirstChild("RightUpperLeg")
    local RightFoot = model:FindFirstChild("RightFoot")

    if RightUpperLeg and RightFoot then
        return RightUpperLeg.Position.Y - RightUpperLeg.Size.Y / 2 - (RightFoot.Position.Y - RightFoot.Size.Y / 2), v74
    end

    return 1.6, v74
end

function t1.chair(p45, p46, p47) -- line: 379
    -- upvalues: t1 (copy)
    local Model = Instance.new("Model")

    Model.Name = "Chair"

    local v75 = CFrame.lookAt(p45, p45 + p46)
    local v76 = Color3.fromRGB(150, 100, 60)
    local v77 = Color3.fromRGB(40, 120, 200)
    local v78 = p47 - p45.Y

    t1.part({
        Name = "Seat",
        Size = Vector3.new(2.6, 0.25, 2.3),
        Color = v77,
        Material = Enum.Material.Fabric,
        CFrame = v75 * CFrame.new(0, v78 - 0.125, 0),
        Parent = Model
    })

    for _, v79 in { -1.15, 1.15 } do
        for _, v80 in { -1, 1 } do
            t1.part({
                Name = "Leg",
                Size = Vector3.new(0.25, v78, 0.25),
                Color = v76,
                CFrame = v75 * CFrame.new(v79, v78 / 2 - 0.1, v80),
                Parent = Model
            })
        end

        t1.part({
            Name = "Post",
            Size = Vector3.new(0.25, 2.6, 0.25),
            Color = v76,
            CFrame = v75 * CFrame.new(v79, v78 + 1.2, 1.15) * CFrame.Angles(-0.17453292519943295, 0, 0),
            Parent = Model
        })
    end

    t1.part({
        Name = "Back",
        Size = Vector3.new(2.4, 1.6, 0.15),
        Color = v77,
        Material = Enum.Material.Fabric,
        CFrame = v75 * CFrame.new(0, v78 + 1.5, 1.2) * CFrame.Angles(-0.17453292519943295, 0, 0),
        Parent = Model
    })
    Model.Parent = t1.folder()

    return Model
end

function t1.shoe() -- line: 398
    -- upvalues: t1 (copy)
    local Model = Instance.new("Model")

    Model.Name = "Shoe"

    local v81 = Color3.fromRGB(110, 70, 40)
    local v82 = Color3.fromRGB(35, 30, 30)
    local v83 = t1.part({
        Name = "Sole",
        Size = Vector3.new(1, 0.25, 2.3),
        Color = v82,
        CFrame = CFrame.new(0, -0.6, 0),
        Parent = Model
    })

    t1.part({
        Name = "Upper",
        Size = Vector3.new(0.95, 1.1, 1.3),
        Color = v81,
        CFrame = CFrame.new(0, 0.05, 0.45),
        Parent = Model
    })
    t1.part({
        Name = "Toe",
        Size = Vector3.new(0.95, 0.55, 1.05),
        Color = v81,
        CFrame = CFrame.new(0, -0.22, -0.65),
        Parent = Model
    })
    t1.part({
        Name = "Shaft",
        Size = Vector3.new(0.9, 0.9, 0.95),
        Color = v81:Lerp(Color3.new(0, 0, 0), 0.15),
        CFrame = CFrame.new(0, 0.95, 0.55),
        Parent = Model
    })

    for i = 0, 2 do
        t1.part({
            Name = "Lace",
            Size = Vector3.new(0.75, 0.08, 0.1),
            Color = Color3.fromRGB(235, 230, 215),
            CFrame = CFrame.new(0, i * 0.22 + 0.14, -0.18 - i * 0.02) * CFrame.Angles(-1.0471975511965976, 0, 0),
            Parent = Model
        })
    end

    t1.part({
        Name = "Weed",
        Size = Vector3.new(0.12, 1.1, 0.35),
        Color = Color3.fromRGB(70, 140, 60),
        Material = Enum.Material.Grass,
        CFrame = CFrame.new(0.5, -0.2, -0.3) * CFrame.Angles(0, 0, 0.20943951023931956),
        Parent = Model
    })

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(150, 200, 255))
    ParticleEmitter.Size = NumberSequence.new(0.16, 0.05)
    ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.7)
    ParticleEmitter.Speed = NumberRange.new(0, 1)
    ParticleEmitter.Acceleration = Vector3.new(0, -50, 0)
    ParticleEmitter.Rate = 22
    ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom
    ParticleEmitter.Parent = v83
    Model.PrimaryPart = v83
    Model.Parent = t1.folder()

    return Model
end

function t1.line(p48, p49, p50) -- line: 426
    local Beam = Instance.new("Beam")

    Beam.Attachment0 = p48
    Beam.Attachment1 = p49
    Beam.Width0 = 0.035
    Beam.Width1 = 0.035
    Beam.Color = ColorSequence.new(Color3.fromRGB(240, 240, 240))
    Beam.FaceCamera = true
    Beam.LightInfluence = 0
    Beam.Segments = 12
    Beam.CurveSize0 = p50 or 0
    Beam.Parent = p49.Parent

    return Beam
end

function t1.bobber(p51, p52) -- line: 440
    -- upvalues: t1 (copy)
    local v84 = t1.part({
        Name = "Bobber",
        Size = Vector3.new(0.9, 0.9, 0.9),
        Shape = Enum.PartType.Ball,
        Color = p52 or Color3.fromRGB(235, 45, 45),
        Position = p51
    })
    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 0.4, 0)
    Attachment.Parent = v84

    return v84, Attachment
end

function t1.cleanup() -- line: 448
    -- upvalues: Folder (ref), t2 (copy), v3 (ref)
    if v3 then
        v3:Disconnect()
        v3 = nil
    end

    table.clear(t2)

    if Folder then
        Folder:Destroy()
        Folder = nil
    end
end

return t1

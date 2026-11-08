-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Packages.Trove)

local v1 = table.freeze({
    Waist = { "Waist", "RootJoint" },
    Neck = { "Neck" },
    LShoulder = { "LeftShoulder", "Left Shoulder" },
    RShoulder = { "RightShoulder", "Right Shoulder" },
    LElbow = { "LeftElbow" },
    RElbow = { "RightElbow" },
    LHip = { "LeftHip", "Left Hip" },
    RHip = { "RightHip", "Right Hip" },
    LKnee = { "LeftKnee" },
    RKnee = { "RightKnee" }
})
local v2 = table.freeze({ "LuaSourceContainer", "Sound", "ForceField", "BillboardGui", "ProximityPrompt", "Animator", "BodyMover", "Tool" })
local t1 = {
    Poses = table.freeze({
        Rest = table.freeze({}),
        Trip = table.freeze({
            Waist = Vector3.new(25, 0, 0),
            Neck = Vector3.new(10, 0, 0),
            LShoulder = Vector3.new(20, 0, -130),
            RShoulder = Vector3.new(20, 0, 130),
            LElbow = Vector3.new(30, 0, 0),
            RElbow = Vector3.new(30, 0, 0),
            LHip = Vector3.new(35, 0, 0),
            RHip = Vector3.new(10, 0, 0),
            LKnee = Vector3.new(-20, 0, 0),
            RKnee = Vector3.new(-30, 0, 0)
        }),
        Surf = table.freeze({
            Waist = Vector3.new(-8, 12, 0),
            Neck = Vector3.new(-5, -12, 0),
            LShoulder = Vector3.new(0, 0, -88),
            RShoulder = Vector3.new(0, 0, 88),
            LElbow = Vector3.new(18, 0, 0),
            RElbow = Vector3.new(18, 0, 0),
            LHip = Vector3.new(18, 0, -8),
            RHip = Vector3.new(-14, 0, 8),
            LKnee = Vector3.new(-32, 0, 0),
            RKnee = Vector3.new(-28, 0, 0)
        }),
        Flail = table.freeze({
            Waist = Vector3.new(10, 0, 0),
            Neck = Vector3.new(18, 0, 0),
            LShoulder = Vector3.new(0, 0, -150),
            RShoulder = Vector3.new(0, 0, 150),
            LElbow = Vector3.new(35, 0, 0),
            RElbow = Vector3.new(35, 0, 0),
            LHip = Vector3.new(30, 0, 0),
            RHip = Vector3.new(-20, 0, 0),
            LKnee = Vector3.new(-40, 0, 0),
            RKnee = Vector3.new(-20, 0, 0)
        }),
        Teeter = table.freeze({
            Waist = Vector3.new(-22, 0, 0),
            Neck = Vector3.new(-20, 0, 0),
            LShoulder = Vector3.new(60, 0, -100),
            RShoulder = Vector3.new(-60, 0, 100),
            LHip = Vector3.new(-25, 0, 0),
            RHip = Vector3.new(5, 0, 0),
            LKnee = Vector3.new(-35, 0, 0)
        }),
        Grabbed = table.freeze({
            Waist = Vector3.new(8, 0, 0),
            Neck = Vector3.new(24, 0, 0),
            LShoulder = Vector3.new(15, 0, -168),
            RShoulder = Vector3.new(15, 0, 168),
            LElbow = Vector3.new(20, 0, 0),
            RElbow = Vector3.new(20, 0, 0),
            LHip = Vector3.new(0, 0, 4),
            RHip = Vector3.new(0, 0, -4)
        }),
        Dive = table.freeze({
            Neck = Vector3.new(30, 0, 0),
            LShoulder = Vector3.new(0, 0, -172),
            RShoulder = Vector3.new(0, 0, 172),
            LElbow = Vector3.new(8, 0, 0),
            RElbow = Vector3.new(8, 0, 0),
            LKnee = Vector3.new(-12, 0, 0),
            RKnee = Vector3.new(-12, 0, 0)
        }),
        Cannonball = table.freeze({
            Waist = Vector3.new(-28, 0, 0),
            Neck = Vector3.new(-18, 0, 0),
            LShoulder = Vector3.new(70, 0, -18),
            RShoulder = Vector3.new(70, 0, 18),
            LElbow = Vector3.new(85, 0, 0),
            RElbow = Vector3.new(85, 0, 0),
            LHip = Vector3.new(112, 0, -6),
            RHip = Vector3.new(112, 0, 6),
            LKnee = Vector3.new(-128, 0, 0),
            RKnee = Vector3.new(-128, 0, 0)
        }),
        Squash = table.freeze({
            Waist = Vector3.new(-18, 0, 0),
            Neck = Vector3.new(-6, 0, 0),
            LShoulder = Vector3.new(10, 0, -55),
            RShoulder = Vector3.new(10, 0, 55),
            LElbow = Vector3.new(30, 0, 0),
            RElbow = Vector3.new(30, 0, 0),
            LHip = Vector3.new(48, 0, -10),
            RHip = Vector3.new(48, 0, 10),
            LKnee = Vector3.new(-70, 0, 0),
            RKnee = Vector3.new(-70, 0, 0)
        }),
        Slide = table.freeze({
            Neck = Vector3.new(35, 0, 0),
            LShoulder = Vector3.new(0, 0, -165),
            RShoulder = Vector3.new(0, 0, 165),
            LKnee = Vector3.new(-25, 0, 0),
            RKnee = Vector3.new(-10, 0, 0)
        })
    })
}

local function strip(p1) -- line: 166
    -- upvalues: v2 (copy)
    for _, descendant in p1:GetDescendants() do
        for _, v3 in v2 do
            if descendant:IsA(v3) then
                descendant:Destroy()
                break
            end
        end
    end
end

local function findMotor(p2, p3) -- line: 177
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("Motor6D") and table.find(p3, descendant.Name) ~= nil then
            return descendant
        end
    end

    return nil
end

local function toRadians(p4) -- line: 186
    return CFrame.Angles(math.rad(p4.X), math.rad(p4.Y), (math.rad(p4.Z)))
end

function t1.Build(p5, p6, p7) -- line: 194
    -- upvalues: v1 (copy), strip (copy), findMotor (copy)
    local Humanoid = p6:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart")

    if Humanoid == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        return nil
    end

    local Archivable = p6.Archivable

    p6.Archivable = true

    local function v6() -- line: 202
        -- upvalues: p6 (copy)
        return p6:Clone()
    end

    local ok, result = pcall(v6)

    p6.Archivable = Archivable

    if not ok or result == nil or not result:IsA("Model") then
        return nil
    end

    local v7 = p5:Add(result)

    v7.Name = "SewerDrainDouble"
    strip(v7)

    local HumanoidRootPart2 = v7:FindFirstChild("HumanoidRootPart")
    local Humanoid2 = v7:FindFirstChildOfClass("Humanoid")

    if HumanoidRootPart2 == nil or Humanoid2 == nil then
        return nil
    end

    Humanoid2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    Humanoid2.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    Humanoid2.BreakJointsOnDeath = false
    Humanoid2.RequiresNeck = false
    Humanoid2.EvaluateStateMachine = false

    local t2 = {}

    for _, descendant in v7:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == HumanoidRootPart2
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
            table.insert(t2, descendant)
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = false
        end
    end

    HumanoidRootPart2.Transparency = 1

    local t3 = {}

    for v8, v9 in v1 do
        local v10 = findMotor(v7, v9)

        if v10 ~= nil then
            v10.Transform = CFrame.identity
            t3[v8] = {
                Motor = v10,
                Rotation = v10.C0.Rotation
            }
        end
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "Grip"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = Color3.fromRGB(80, 220, 190)
    Highlight.OutlineColor = Color3.fromRGB(200, 255, 240)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Adornee = v7
    Highlight.Parent = v7
    v7.Parent = p7
    HumanoidRootPart2.CFrame = HumanoidRootPart.CFrame

    local Head = v7:FindFirstChild("Head")

    return {
        Model = v7,
        Root = HumanoidRootPart2,
        Head = if Head == nil or not Head:IsA("BasePart") then nil else Head,
        Joints = t3,
        Stance = if Humanoid.RigType == Enum.HumanoidRigType.R6 then 3 else Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2,
        Parts = t2,
        Glow = Highlight
    }
end

function t1.Blend(p8, p9, p10) -- line: 269
    -- upvalues: v1 (copy)
    local t5 = {}

    for v11 in v1 do
        t5[v11] = (p8[v11] or Vector3.new(0, 0, 0)):Lerp(p9[v11] or Vector3.new(0, 0, 0), p10)
    end

    return t5
end

function t1.Pose(p11, p12, p13) -- line: 279
    for v12, v13 in p11.Joints do
        local v14 = p12[v12] or Vector3.new(0, 0, 0)

        if p13 and p13[v12] then
            v14 += p13[v12]
        end

        local Rotation = v13.Rotation

        v13.Motor.Transform = Rotation:Inverse() * CFrame.Angles(math.rad(v14.X), math.rad(v14.Y), (math.rad(v14.Z))) * Rotation
    end
end

function t1.Place(p14, p15) -- line: 290
    p14.Root.CFrame = p15
end

function t1.Visible(p16, p17) -- line: 294
    local v18 = if p17 then 0 else 1

    for _, v19 in p16.Parts do
        if v19 ~= p16.Root then
            v19.LocalTransparencyModifier = v18
        end
    end

    for _, descendant in p16.Model:GetDescendants() do
        if descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = v18
        end
    end
end

function t1.Cloak(p18, p19) -- line: 308
    -- upvalues: Players (copy)
    local t6 = {}
    local t7 = {}
    local t8 = {}

    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t6, descendant)
        elseif descendant:IsA("Decal") then
            table.insert(t7, descendant)
        elseif descendant:IsA("BillboardGui") then
            t8[descendant] = descendant.Enabled
            descendant.Enabled = false
        end
    end

    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        for _, descendant in PlayerGui:GetDescendants() do
            if descendant:IsA("BillboardGui") and descendant.Enabled then
                local Adornee = descendant.Adornee

                if Adornee ~= nil and Adornee:IsDescendantOf(p19) then
                    t8[descendant] = true
                    descendant.Enabled = false
                end
            end
        end
    end

    local v20 = false

    local function step() -- line: 335
        -- upvalues: t6 (copy), t7 (copy), v20 (ref)
        if v20 then
            return
        end

        for _, v21 in t6 do
            v21.LocalTransparencyModifier = 1
        end

        for _, v22 in t7 do
            v22.LocalTransparencyModifier = 1
        end
    end

    local function lift() -- line: 346
        -- upvalues: t6 (copy), t7 (copy), t8 (copy), v20 (ref)
        if v20 then
            return
        end

        v20 = true

        for _, v23 in t6 do
            v23.LocalTransparencyModifier = 0
        end

        for _, v24 in t7 do
            v24.LocalTransparencyModifier = 0
        end

        for v25, v26 in t8 do
            if v25.Parent ~= nil then
                v25.Enabled = v26
            end
        end
    end

    p18:Add(lift)

    if not v20 then
        for _, v27 in t6 do
            v27.LocalTransparencyModifier = 1
        end

        for _, v28 in t7 do
            v28.LocalTransparencyModifier = 1
        end
    end

    return {
        Step = step,
        Lift = lift
    }
end

return table.freeze(t1)

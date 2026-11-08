-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MountRace = require(ReplicatedStorage.Data.MountRace)
local TheHollowFlags = require(ReplicatedStorage.Shared.Flags.TheHollowFlags)
local v1 = NumberRange.new(0.6, 3)
local t1 = {}

local function findRider(p1, p2, p3) -- line: 63
    for _, descendant in p1:GetDescendants() do
        if not descendant:IsDescendantOf(p3) then
            if descendant:IsA("Motor6D") and descendant.Part0 == p2 then
                return descendant
            end

            if descendant:IsA("AnimationConstraint") then
                local Attachment0 = descendant.Attachment0

                if Attachment0 ~= nil and Attachment0.Parent == p2 then
                    return Attachment0
                end
            end
        end
    end

    return nil
end

local function riderFrame(p4) -- line: 85
    if p4:IsA("Motor6D") then
        return p4.C0
    end

    return p4.CFrame
end

local function setRiderFrame(p5, p6) -- line: 92
    if p5:IsA("Motor6D") then
        p5.C0 = p6
    else
        p5.CFrame = p6
    end
end

local function findRiderBone(p7, p8, p9) -- line: 100
    local RiderBone = p7:GetAttribute("RiderBone")

    if type(RiderBone) == "string" then
        local v2 = p8:FindFirstChild(RiderBone, true)

        if v2 ~= nil and v2:IsA("Bone") and v2:FindFirstAncestorWhichIsA("BasePart") == p9 then
            return v2
        end
    end

    return nil
end

local function boneMotion(p10) -- line: 116
    local v3, v4 = CFrame.identity, CFrame.identity
    local v5 = p10

    while v5 ~= nil and v5:IsA("Bone") do
        v3 = v5.CFrame * v3
        v4 = v5.CFrame * v5.Transform * v4
        v5 = v5.Parent
    end

    return v4 * v3:Inverse()
end

local function setupLean(p11, p12) -- line: 128
    -- upvalues: MountRace (copy), findRider (copy), findRiderBone (copy)
    local Parent = p11.Parent
    local HumanoidRootPart = if Parent == nil then nil else Parent:FindFirstChild("HumanoidRootPart")
    local HumanoidRootPart2 = p11:FindFirstChild("HumanoidRootPart")
    local Hitbox = p11:FindFirstChild("Hitbox")
    local PrimaryPart = p12.PrimaryPart

    if p11.Name ~= MountRace.MountName
        or HumanoidRootPart == nil
        or not HumanoidRootPart:IsA("BasePart")
        or HumanoidRootPart2 == nil
        or not HumanoidRootPart2:IsA("BasePart")
        or Hitbox == nil
        or not Hitbox:IsA("BasePart")
        or PrimaryPart == nil then
        return nil
    end

    local descendant

    for _, descendant2 in p11:GetDescendants() do
        if descendant2:IsA("WeldConstraint") and descendant2.Enabled then
            if descendant2.Part0 == HumanoidRootPart2 and descendant2.Part1 == PrimaryPart then
                descendant = descendant2
                break
            end

            if descendant2.Part0 == PrimaryPart and descendant2.Part1 == HumanoidRootPart2 then
                descendant = descendant2
                break
            end
        end

        descendant = nil
    end

    if descendant == nil then
        return nil
    end

    local v6 = findRider(Parent, HumanoidRootPart, p11)
    local v8 = Hitbox.CFrame:PointToWorldSpace((Vector3.new(0, -Hitbox.Size.Y / 2, 0)))
    local v9 = HumanoidRootPart2.CFrame:ToObjectSpace(PrimaryPart.CFrame)
    local Weld = Instance.new("Weld")

    Weld.Name = "LeanWeld"
    Weld.Part0 = HumanoidRootPart2
    Weld.Part1 = PrimaryPart
    Weld.C0 = v9
    Weld.Parent = HumanoidRootPart2
    descendant.Enabled = false

    return {
        Angle = 0,
        CharacterRoot = HumanoidRootPart,
        Asset = descendant,
        Weld = Weld,
        MountOffset = v9,
        MountFrame = HumanoidRootPart.CFrame:ToObjectSpace(HumanoidRootPart2.CFrame),
        MountPivot = HumanoidRootPart2.CFrame:PointToObjectSpace(v8),
        MountAxis = HumanoidRootPart2.CFrame:VectorToObjectSpace(HumanoidRootPart.CFrame.LookVector),
        Rider = v6,
        RiderRest = if v6 == nil then CFrame.identity elseif v6:IsA("Motor6D") then v6.C0 else v6.CFrame,
        RiderPivot = HumanoidRootPart.CFrame:PointToObjectSpace(v8),
        RiderBone = findRiderBone(p11, p12, PrimaryPart),
        Look = HumanoidRootPart.CFrame.LookVector
    }
end

local function releaseLean(p13) -- line: 192
    p13.Weld:Destroy()

    if p13.Asset.Parent ~= nil then
        p13.Asset.Enabled = true
    end

    local Rider = p13.Rider

    if Rider == nil or Rider.Parent == nil then
        return
    end

    local RiderRest = p13.RiderRest

    if Rider:IsA("Motor6D") then
        Rider.C0 = RiderRest
    else
        Rider.CFrame = RiderRest
    end
end

local function stepLean(p14, p15) -- line: 203
    -- upvalues: GuiService (copy), TheHollowFlags (copy), boneMotion (copy)
    local _CFrame = p14.CharacterRoot.CFrame
    local UpVector = _CFrame.UpVector
    local v10 = _CFrame.LookVector - UpVector * _CFrame.LookVector:Dot(UpVector)
    local v11 = p14.Look - UpVector * p14.Look:Dot(UpVector)

    if v10.Magnitude < 0.001 or v11.Magnitude < 0.001 then
        return
    end

    local Unit = v10.Unit
    local Unit2 = v11.Unit

    p14.Look = Unit

    local v14 = math.asin((math.clamp(UpVector:Dot(Unit2:Cross(Unit)), -1, 1))) / math.max(p15, 0.001)
    local v16 = math.clamp(p14.CharacterRoot.AssemblyLinearVelocity.Magnitude / 50, 0, 1)
    local v18 = math.clamp(-v14 * 0.18, -0.2792526803190927, 0.2792526803190927) * v16

    if GuiService.ReducedMotionEnabled then
        v18 *= 0.4
    end

    p14.Angle = p14.Angle + (v18 - p14.Angle) * math.min(1, p15 * 8)

    local MountPivot = p14.MountPivot

    p14.Weld.C0 = CFrame.new(MountPivot) * CFrame.fromAxisAngle(p14.MountAxis, p14.Angle) * CFrame.new(-MountPivot) * p14.MountOffset

    local Rider = p14.Rider

    if Rider == nil then
        return
    end

    local RiderPivot = p14.RiderPivot
    local v21 = CFrame.new(RiderPivot) * CFrame.fromAxisAngle(Vector3.new(0, 0, -1), p14.Angle) * CFrame.new(-RiderPivot) * p14.RiderRest
    local RiderBone = p14.RiderBone

    if RiderBone ~= nil and TheHollowFlags.RiderFollowsDeck:Get() then
        local v22 = p14.MountFrame * p14.Weld.C0

        v21 = v22 * boneMotion(RiderBone) * v22:Inverse() * v21
    end

    if Rider:IsA("Motor6D") then
        Rider.C0 = v21
    else
        Rider.CFrame = v21
    end
end

local function addMount(p16) -- line: 243
    -- upvalues: t1 (copy), setupLean (copy)
    local v23 = p16:WaitForChild("Model", 10)
    local v24 = p16:WaitForChild("Idle", 10)
    local v25 = p16:WaitForChild("Walk", 10)
    local v26 = p16:WaitForChild("HumanoidRootPart", 10)

    if v23 ~= nil and v24 ~= nil and v25 ~= nil and v26 ~= nil and p16.Parent ~= nil then
        local Animator = v23:WaitForChild("AnimationController"):WaitForChild("Animator")
        local track = Animator:LoadAnimation(v24)
        local track2 = Animator:LoadAnimation(v25)

        track.Looped = true
        track2.Looped = true
        track:Play()
        t1[p16] = {
            Walking = false,
            Root = p16.HumanoidRootPart,
            Idle = track,
            Walk = track2,
            Lean = setupLean(p16, v23)
        }
    end
end

local function removeMount(p17) -- line: 273
    -- upvalues: t1 (copy)
    local v27 = t1[p17]

    if v27 == nil then
        return
    end

    t1[p17] = nil
    v27.Idle:Stop(0)
    v27.Walk:Stop(0)

    local Lean = v27.Lean

    if Lean == nil then
        return
    end

    Lean.Weld:Destroy()

    if Lean.Asset.Parent ~= nil then
        Lean.Asset.Enabled = true
    end

    local Rider = Lean.Rider

    if Rider ~= nil and Rider.Parent ~= nil then
        local RiderRest = Lean.RiderRest

        if Rider:IsA("Motor6D") then
            Rider.C0 = RiderRest
        else
            Rider.CFrame = RiderRest
        end
    end
end

local function step(p18) -- line: 287
    -- upvalues: v1 (copy), t1 (copy), stepLean (copy)
    for _, v28 in t1 do
        local Lean = v28.Lean

        if Lean ~= nil then
            stepLean(Lean, p18)
        end

        local Magnitude = v28.Root.AssemblyLinearVelocity.Magnitude
        local v29 = Magnitude > 3

        if v29 ~= v28.Walking then
            v28.Walking = v29

            if v29 then
                v28.Idle:Stop(0.2)
                v28.Walk:Play(0.2)
            else
                v28.Walk:Stop(0.2)
                v28.Idle:Play(0.2)
            end
        end

        if v29 then
            v28.Walk:AdjustSpeed((math.clamp(Magnitude / 40, v1.Min, v1.Max)))
        end
    end
end

return {
    Start = function() -- Start | line: 317
        -- upvalues: CollectionService (copy), RunService (copy), MountRace (copy), addMount (copy), removeMount (copy), step (copy)
        CollectionService:GetInstanceAddedSignal(MountRace.MountTag):Connect(addMount)
        CollectionService:GetInstanceRemovedSignal(MountRace.MountTag):Connect(removeMount)

        for _, v31 in CollectionService:GetTagged(MountRace.MountTag) do
            addMount(v31)
        end

        RunService.Heartbeat:Connect(step)
    end
}

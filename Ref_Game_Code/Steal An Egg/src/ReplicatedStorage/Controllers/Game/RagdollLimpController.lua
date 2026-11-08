-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll = require(ReplicatedStorage.Shared.Flags.GameplayBalance).Ragdoll
local Physics = Enum.HumanoidStateType.Physics
local t1 = {
    Root = true,
    Neck = true
}
local t2 = {
    "HumanoidRootPart",
    "LowerTorso",
    "UpperTorso",
    "Torso"
}
local LocalPlayer = Players.LocalPlayer
local t3 = {}

local function joinsTool(p1) -- line: 21
    local Part1 = p1.Part1

    if p1:FindFirstAncestorOfClass("Tool") ~= nil then
        return true
    end

    return Part1 ~= nil and Part1:FindFirstAncestorOfClass("Tool") ~= nil
end

local function pin(p2, p3, p4) -- line: 27
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "RagdollLocalLimp"
    Attachment.Parent = p2
    Attachment.CFrame = p3
    table.insert(p4, Attachment)

    return Attachment
end

local function limp(p5) -- line: 36
    -- upvalues: t1 (copy)
    local t4 = {
        Created = {},
        Disabled = {}
    }

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("Motor6D") and descendant.Enabled then
            local Part1 = descendant.Part1

            if descendant:FindFirstAncestorOfClass("Tool") == nil and (Part1 == nil or Part1:FindFirstAncestorOfClass("Tool") == nil) then
                local Part0, Part1 = descendant.Part0, descendant.Part1

                if Part0 and Part1 then
                    local C0 = descendant.C0
                    local Created = t4.Created
                    local Attachment = Instance.new("Attachment")

                    Attachment.Name = "RagdollLocalLimp"
                    Attachment.Parent = Part0
                    Attachment.CFrame = C0
                    table.insert(Created, Attachment)

                    local C1 = descendant.C1
                    local Created2 = t4.Created
                    local Attachment2 = Instance.new("Attachment")

                    Attachment2.Name = "RagdollLocalLimp"
                    Attachment2.Parent = Part1
                    Attachment2.CFrame = C1
                    table.insert(Created2, Attachment2)

                    local HingeConstraint

                    if t1[descendant.Name] then
                        HingeConstraint = Instance.new("HingeConstraint")
                        HingeConstraint.LimitsEnabled = true
                    else
                        HingeConstraint = Instance.new("BallSocketConstraint")
                        HingeConstraint.LimitsEnabled = true
                        HingeConstraint.TwistLimitsEnabled = true
                    end

                    HingeConstraint.Name = "RagdollLocalLimp"
                    HingeConstraint.Parent = descendant.Parent
                    HingeConstraint.Attachment0 = Attachment
                    HingeConstraint.Attachment1 = Attachment2
                    table.insert(t4.Created, HingeConstraint)
                    descendant.Enabled = false
                    table.insert(t4.Disabled, descendant)
                end
            end
        end
    end

    return t4
end

local function tumble(p6, p7) -- line: 68
    -- upvalues: Ragdoll (copy), t2 (copy)
    local v1 = tonumber(Ragdoll.LOCAL_LIMP_TUMBLE) or 0
    local v2 = tonumber(Ragdoll.LOCAL_LIMP_FLAIL) or 0
    local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart")

    if v1 == v1 and v2 == v2 and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        local v3 = math.clamp(v1, 0, 30)
        local v4 = math.clamp(v2, 0, 30)

        if v3 <= 0 and v4 <= 0 then
            return
        end

        local v5 = HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
        local v6 = (Vector3.new(0, 1, 0)):Cross(if v5.Magnitude > 1 then v5.Unit else -HumanoidRootPart.CFrame.LookVector)

        if not (v6.Magnitude < 0.001) then
            local v7 = v6.Unit * v3
            local t5 = {}

            for _, v8 in t2 do
                local v9 = p6:FindFirstChild(v8)

                if v9 and v9:IsA("BasePart") then
                    v9.AssemblyAngularVelocity = v7
                    t5[v9] = true
                end
            end

            if not (v4 <= 0) then
                local v10 = Random.new()

                for _, v11 in p7.Disabled do
                    local Part1 = v11.Part1

                    if Part1 and not t5[Part1] then
                        Part1.AssemblyAngularVelocity = v7 + v10:NextUnitVector() * v4
                    end
                end
            end
        end
    end
end

local function restore(p8) -- line: 107
    for _, v12 in p8.Created do
        v12:Destroy()
    end

    for _, v13 in p8.Disabled do
        if v13.Parent then
            v13.Enabled = true
        end
    end
end

local function watch(p9) -- line: 118
    -- upvalues: RunService (copy), Ragdoll (copy), Physics (copy), limp (copy), tumble (copy), restore (copy)
    local v14 = p9:WaitForChild("Humanoid", 10)

    if v14 == nil or not v14:IsA("Humanoid") then
        return
    end

    local v15
    local n1 = 0

    local function settle() -- line: 125
        -- upvalues: v15 (ref), n1 (ref), restore (copy)
        n1 += 1

        if v15 then
            restore(v15)
            v15 = nil
        end
    end

    v14.StateChanged:Connect(function(_, p11) -- line: 132
        -- upvalues: p9 (copy), v14 (copy), v15 (ref), n1 (ref), RunService (copy), Ragdoll (copy), Physics (copy), limp (copy), tumble (copy), restore (copy)
        if p11 == Physics then
            n1 += 1

            local v16 = n1
            local v18 = math.clamp(math.floor(Ragdoll.LOCAL_LIMP_FRAMES), 0, 30)

            if not (v18 <= 0 or v15) then
                task.spawn(function() -- line: 143
                    -- upvalues: v16 (copy), v18 (copy), p9 (copy), v14 (copy), v15 (ref), n1 (ref), RunService (copy), Physics (copy), limp (copy), tumble (copy)
                    for _ = 1, v18 do
                        RunService.PostSimulation:Wait()
                    end

                    if v16 == n1 and not v15 and p9.Parent ~= nil and v14:GetState() == Physics then
                        local v19 = limp(p9)

                        v15 = v19
                        tumble(p9, v19)
                    end
                end)
            end
        else
            n1 += 1

            if v15 then
                restore(v15)
                v15 = nil
            end
        end
    end)
    p9.AncestryChanged:Connect(function() -- line: 155
        -- upvalues: p9 (copy), v15 (ref), n1 (ref), restore (copy)
        if p9.Parent == nil then
            n1 += 1

            if v15 then
                restore(v15)
                v15 = nil
            end
        end
    end)
end

function t3.Start() -- line: 162
    -- upvalues: LocalPlayer (copy), watch (copy)
    LocalPlayer.CharacterAdded:Connect(watch)

    if LocalPlayer.Character then
        task.spawn(watch, LocalPlayer.Character)
    end
end

return t3

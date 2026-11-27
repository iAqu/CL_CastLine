-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Plots = workspace:WaitForChild("Plots")
local Eat = ReplicatedStorage:WaitForChild("Animations"):WaitForChild("Eat")
local EatBite = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EatBite")
local t1 = {
    0.36, 0.86
}
local n1 = 0
local track, Humanoid, Animator, track2, WalkSpeed, AutoRotate, connection, t2, connection2
local v1 = true

local function letGo() -- line: 63
    -- upvalues: t2 (ref)
    if not t2 then
        return
    end

    for _, v2 in ipairs(t2.parts) do
        v2:Destroy()
    end

    t2 = nil
end

local function holdAt(p1) -- line: 69
    -- upvalues: t2 (ref)
    if t2 then
        for _, v3 in ipairs(t2.parts) do
            v3:Destroy()
        end

        t2 = nil
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "EatHold"
    Attachment.Parent = p1

    local AlignPosition = Instance.new("AlignPosition")

    AlignPosition.Name = "EatHoldPosition"
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
    AlignPosition.Attachment0 = Attachment
    AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    AlignPosition.ForceRelativeTo = Enum.ActuatorRelativeTo.World
    AlignPosition.MaxAxesForce = Vector3.new(1e999, 1e999, 1e999)
    AlignPosition.Responsiveness = 200
    AlignPosition.Position = p1.Position
    AlignPosition.Parent = p1

    local AlignOrientation = Instance.new("AlignOrientation")

    AlignOrientation.Name = "EatHoldTurn"
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.RigidityEnabled = true
    AlignOrientation.CFrame = p1.CFrame.Rotation
    AlignOrientation.Parent = p1
    t2 = {
        root = p1,
        at = p1.Position,
        pos = AlignPosition,
        parts = { AlignOrientation, AlignPosition, Attachment }
    }
end

local function myPlot() -- line: 94
    -- upvalues: LocalPlayer (copy), Plots (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child
        end
    end

    return nil
end

local function onPodium(p2) -- line: 101
    -- upvalues: LocalPlayer (copy)
    local Pedestal = p2 and p2:FindFirstChild("Pedestal")
    local PodiumTop = Pedestal and Pedestal:FindFirstChild("PodiumTop")
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if PodiumTop and HumanoidRootPart then
        local v4 = HumanoidRootPart.Position - PodiumTop.Position

        if Vector3.new(v4.X, 0, v4.Z).Magnitude <= 2.6 and v4.Y > 0 then
            return v4.Y < 6
        end

        return false
    end

    return false
end

local function standAt(p3, p4, p5) -- line: 112
    local Pedestal = p3:FindFirstChild("Pedestal")
    local PodiumTop = Pedestal and Pedestal:FindFirstChild("PodiumTop")

    return if PodiumTop then PodiumTop.Position + Vector3.new(0, PodiumTop.Size.Y / 2 + p4.HipHeight + p5.Size.Y / 2, 0) else nil
end

local function snapToPodium(p6, p7) -- line: 121
    -- upvalues: LocalPlayer (copy)
    local Table = p6:FindFirstChild("Table")
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local v6

    if HumanoidRootPart then
        local Pedestal = p6:FindFirstChild("Pedestal")
        local PodiumTop = Pedestal and Pedestal:FindFirstChild("PodiumTop")

        if PodiumTop then
            v6 = PodiumTop.Position + Vector3.new(0, PodiumTop.Size.Y / 2 + p7.HipHeight + HumanoidRootPart.Size.Y / 2, 0)
        end
    else
        v6 = HumanoidRootPart
    end

    if Table and v6 then
        local Position = Table:GetPivot().Position

        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.CFrame = CFrame.lookAt(v6, (Vector3.new(Position.X, v6.Y, Position.Z)))
    end
end

local stopEating

local function startEating(p8) -- line: 133
    -- upvalues: UserInputService (copy), LocalPlayer (copy), Eat (copy), n1 (ref), track (ref), Humanoid (ref), Animator (ref), track2 (ref), WalkSpeed (ref), AutoRotate (ref), connection (ref), connection2 (ref), v1 (ref), holdAt (copy), snapToPodium (copy), stopEating (ref)
    local Character = LocalPlayer.Character
    local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")
    local Animator2 = Humanoid2 and Humanoid2:FindFirstChildOfClass("Animator")

    if not Animator2 or Eat.AnimationId == "" then
        return
    elseif Animator ~= Animator2 then
        if track2 then
            track2:Destroy()
        end

        local track = Animator2:LoadAnimation(Eat)

        Animator = Animator2
        track2 = track
    end

    track = track2
    Humanoid = Humanoid2

    local track3 = track

    track3.Priority = Enum.AnimationPriority.Action
    track.Looped = true
    track:Play(0.15, 1, 1.75)
    n1 = 0
    snapToPodium(p8, Humanoid2)

    local WalkSpeed2, AutoRotate2 = Humanoid2.WalkSpeed, Humanoid2.AutoRotate

    WalkSpeed = WalkSpeed2
    AutoRotate = AutoRotate2
    Humanoid2.WalkSpeed = 0
    Humanoid2.AutoRotate = false
    connection = Humanoid2.Jumping:Connect(function(p9) -- line: 152
        -- upvalues: v1 (ref), stopEating (ref)
        if p9 then
            v1 = false
            stopEating()
        end
    end)

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        holdAt(HumanoidRootPart)
    end

    connection2 = UserInputService.JumpRequest:Connect(function() -- line: 160
        -- upvalues: track (ref), Humanoid (ref), v1 (ref), stopEating (ref)
        if not track then
            return
        end

        v1 = false

        local Humanoid2 = Humanoid

        stopEating()

        if Humanoid2 and Humanoid2.Parent then
            Humanoid2.Jump = true
        end
    end)
end

function stopEating() -- line: 169
    -- upvalues: track (ref), Humanoid (ref), WalkSpeed (ref), AutoRotate (ref), connection (ref), t2 (ref), connection2 (ref)
    if track then
        track:Stop(0.2)
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection2 then
        connection2:Disconnect()
        connection2 = nil
    end

    if t2 then
        for _, v9 in ipairs(t2.parts) do
            v9:Destroy()
        end

        t2 = nil
    end

    if Humanoid and Humanoid.Parent then
        Humanoid.WalkSpeed = WalkSpeed or 16
        Humanoid.AutoRotate = AutoRotate ~= false
    end

    track = nil
    Humanoid = nil
end

local n2 = 0

RunService.Heartbeat:Connect(function(p10) -- line: 182
    -- upvalues: LocalPlayer (copy), EatBite (copy), t1 (copy), n1 (ref), track (ref), Humanoid (ref), t2 (ref), connection2 (ref), v1 (ref), myPlot (copy), onPodium (copy), stopEating (ref), startEating (copy), n2 (ref)
    if track and track.IsPlaying then
        local v10 = track.Length > 0 and track.Length or 1
        local v11 = track.TimePosition % v10

        for _, v12 in ipairs(t1) do
            if n1 < v12 and v12 <= v11 then
                EatBite:FireServer()
            elseif v11 < n1 and (n1 <= v12 or v12 < v11) then
                EatBite:FireServer()
            end
        end

        n1 = v11
    end

    n2 += p10

    if n2 < 0.2 then
        return
    end

    n2 = 0

    local Character = LocalPlayer.Character
    local Humanoid2 = Character and Character:FindFirstChildOfClass("Humanoid")

    if track and (Humanoid2 ~= Humanoid or not Humanoid2 or Humanoid2.Health <= 0) then
        track = nil
        Humanoid = nil

        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        if t2 then
            for _, v15 in ipairs(t2.parts) do
                v15:Destroy()
            end

            t2 = nil
        end
    end

    local v16 = myPlot()
    local v17 = v16 ~= nil and Humanoid2 ~= nil and Humanoid2.Health > 0 and onPodium(v16)

    if not v17 then
        v1 = true
    end

    if v17 and v1 and not track then
        startEating(v16)
    elseif not v17 and track then
        stopEating()
    end

    if t2 and track and v17 then
        local root = t2.root
        local Pedestal = v16:FindFirstChild("Pedestal")
        local PodiumTop = Pedestal and Pedestal:FindFirstChild("PodiumTop")
        local v18 = if PodiumTop then PodiumTop.Position + Vector3.new(0, PodiumTop.Size.Y / 2 + Humanoid2.HipHeight + root.Size.Y / 2, 0) else nil

        if v18 then
            t2.pos.Position = Vector3.new(t2.at.X, v18.Y, t2.at.Z)
        end
    end

    local v20 = track ~= nil

    if LocalPlayer:GetAttribute("LocalEating") ~= v20 then
        LocalPlayer:SetAttribute("LocalEating", v20)
    end
end)
RunService.PreSimulation:Connect(function() -- line: 229
    -- upvalues: track (ref), t2 (ref), stopEating (ref)
    if not t2 then
        return
    end

    local root = t2.root
    local v21 = root.Position - t2.at

    if not (root.Parent and Vector3.new(v21.X, 0, v21.Z).Magnitude <= 3) then
        if track then
            stopEating()
        elseif t2 then
            for _, v23 in ipairs(t2.parts) do
                v23:Destroy()
            end

            t2 = nil
        end
    end
end)

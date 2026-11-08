-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Parent = script.Parent
local Humanoid = Parent:WaitForChild("Humanoid")

Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid.AutoJumpEnabled = false

local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart")

local function onPostSimulation(p1) -- line: 15
    -- upvalues: Humanoid (copy), HumanoidRootPart (copy)
    local State = Humanoid:GetState()

    if not ((State == Enum.HumanoidStateType.Running or State == Enum.HumanoidStateType.RunningNoPhysics) and Humanoid.WalkSpeed >= 50 and HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 10) then
        return
    end

    HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity + Vector3.new(0, -50 * p1, 0)
end

local connection = RunService.PostSimulation:Connect(onPostSimulation)

Humanoid.Died:Connect(function() -- line: 24
    -- upvalues: connection (copy)
    connection:Disconnect()
end)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local t1 = {
    TestDelayAttribute = "RiftMachineTestDelaySeconds",
    TestSwapAtAttribute = "RiftMachineTestSwapAtUnix",
    ActiveSwapAtAttribute = "RiftMachineActiveSwapAt",
    EmergencyLabAttribute = "RiftMachineEmergencyLab"
}

function t1.GetSwapAt() -- line: 15
    -- upvalues: RunService (copy), Workspace (copy), RiftFlags (copy), t1 (copy)
    if RunService:IsStudio() then
        local Attribute2 = Workspace:GetAttribute(t1.TestDelayAttribute)
        local Attribute = Workspace:GetAttribute(t1.ActiveSwapAtAttribute)
        local Attribute3 = Workspace:GetAttribute(t1.TestSwapAtAttribute)

        if (type(Attribute2) == "number" and Attribute2 > 0 or type(Attribute3) == "number") and type(Attribute) == "number" then
            return Attribute
        end
    end

    return RiftFlags.SwapAtUnix:Get()
end

function t1.IsLaboratoryTime() -- line: 27
    -- upvalues: RunService (copy), Workspace (copy), Environment (copy), t1 (copy)
    if Workspace:GetAttribute(t1.EmergencyLabAttribute) == true then
        return true
    end

    if RunService:IsStudio() then
        local Attribute = Workspace:GetAttribute(t1.TestDelayAttribute)
        local Attribute2 = Workspace:GetAttribute(t1.TestSwapAtAttribute)

        if (type(Attribute) ~= "number" or Attribute <= 0) and type(Attribute2) ~= "number" then
            return true
        end
    elseif Environment.GetEnvironmentName() == "test" or Environment.GetEnvironmentName() == "dev" then
        return true
    end

    return Workspace:GetServerTimeNow() >= t1.GetSwapAt()
end

return table.freeze(t1)

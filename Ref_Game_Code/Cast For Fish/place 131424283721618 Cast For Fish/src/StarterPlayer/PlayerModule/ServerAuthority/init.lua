-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local ControlModule = require(script.Parent:WaitForChild("ControlModule"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"))
local FlagUtil = CommonUtils.get("FlagUtil")
local PlayerModuleEventBus = CommonUtils.get("PlayerModuleEventBus")
local UserDisableForceLocalHumanoidPrediction = FlagUtil.getUserFlag("UserDisableForceLocalHumanoidPrediction")
local _ = {
    SERVER_AUTHORITY_CHANGED = "SERVER_AUTHORITY_CHANGED",
    INPUTS_SETUP = "INPUTS_SETUP"
}
local v1 = false

function t1.PredictLocalHumanoid() -- line: 27
    -- upvalues: Players (copy), RunService (copy)
    local function v2(p1) -- line: 28
        -- upvalues: RunService (copy)
        RunService:SetPredictionMode(p1:WaitForChild("HumanoidRootPart"), Enum.PredictionMode.On)
    end

    if Players.LocalPlayer.Character then
        RunService:SetPredictionMode(Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Enum.PredictionMode.On)
    else
        Players.LocalPlayer.CharacterAdded:Connect(v2)
    end
end

function t1.initialize(p2) -- line: 39
    -- upvalues: v1 (ref)
    p2.isServerAuthority = v1
end

function t1.Initialize() -- line: 43
    -- upvalues: t1 (copy), ControlModule (copy), RunService (copy), PlayerModuleEventBus (copy), UserDisableForceLocalHumanoidPrediction (copy), v1 (ref)
    if not UserDisableForceLocalHumanoidPrediction and RunService:IsClient() then
        t1.PredictLocalHumanoid()
    end

    if not PlayerModuleEventBus.data.inputsSetupComplete and RunService:IsServer() then
        PlayerModuleEventBus:subscribe("INPUTS_SETUP"):Wait()
    end

    ControlModule:InitializeServerAuthority()
    v1 = true
end

return t1

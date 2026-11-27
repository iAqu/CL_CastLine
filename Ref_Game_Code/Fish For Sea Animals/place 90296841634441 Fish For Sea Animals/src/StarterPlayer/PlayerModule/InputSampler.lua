-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"))

require(script.Parent.Types)

local FlagUtil = CommonUtils.get("FlagUtil")
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local v2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2") or FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2GA")
local UserAbilitiesUserInterfaceB = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceB")
local UserControlModuleDisabledUpdate = FlagUtil.getUserFlag("UserControlModuleDisabledUpdate")
local UserPlayerModuleEngineAPI = FlagUtil.getUserFlag("UserPlayerModuleEngineAPI")
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("ControlModule"):WaitForChild("AvatarAbilitiesInterface"))
local v3 = if v1 then AvatarAbilitiesInterface.get(Players.LocalPlayer) else nil
local v4 = if UserAbilitiesUserInterfaceB then "ControlState" else "PlayerControlState"
local t1 = {}

t1.__index = t1

function t1.new() -- line: 53
    -- upvalues: t1 (copy)
    return (setmetatable({
        controlData = {
            enabled = true,
            isJumping = false,
            worldMoveVector = Vector3.new(0, 0, 0)
        }
    }, t1))
end

function t1.Update(p1, p2) -- line: 65
    -- upvalues: Workspace (copy), UserGameSettings (copy), UserAbilitiesUserInterfaceB (copy), UserControlModuleDisabledUpdate (copy), UserPlayerModuleEngineAPI (copy), v4 (copy), v2 (copy), v3 (copy)
    if not UserControlModuleDisabledUpdate then
        return
    end

    local player = p2.engineInterface.player

    if player then
        if v2 then
            local v5 = if UserPlayerModuleEngineAPI then p2.engineInterface.character else player.Character

            if v5 then
                local v6 = if UserAbilitiesUserInterfaceB then v5:FindFirstChildOfClass(v4) else v5:FindFirstChild(v4)

                if v6 and (if UserPlayerModuleEngineAPI then p2.engineInterface.humanoid else v5:FindFirstChildOfClass("Humanoid")) then
                    local v7 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    local LookVector = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
                    local v8 = Vector3.new(LookVector.X, 0, LookVector.Z)
                    local t3 = {
                        RotateToLookDirection = v7,
                        LookDirection = if v8.Magnitude > 0.001 then v8.Unit else Vector3.new(0, 0, 1)
                    }

                    if p2.controlModule.enabled or p1.controlData.enabled then
                        t3.Move = p2.controlModule.worldMoveVector

                        if not v3 or not v3:isEnabled() then
                            t3.Jump = p2.controlModule.isJumping
                        end
                    end

                    p1.controlData.enabled = p2.controlModule.enabled
                    p1.controlData.isJumping = p2.controlModule.isJumping
                    p1.controlData.worldMoveVector = p2.controlModule.worldMoveVector
                    v6:UpdateFields(t3)
                end
            end
        elseif p2.isServerAuthority then
            local InputContexts = player:FindFirstChild("InputContexts")

            if not InputContexts then
                return
            end

            local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

            if not CharacterContext then
                return
            end

            local RotationAction = CharacterContext:FindFirstChild("RotationAction")
            local RotationScriptableBinding, v9

            if RotationAction then
                RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding")

                if RotationScriptableBinding then
                    v9 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    RotationScriptableBinding:Fire(v9)
                end
            end
        end
    end
end

return t1

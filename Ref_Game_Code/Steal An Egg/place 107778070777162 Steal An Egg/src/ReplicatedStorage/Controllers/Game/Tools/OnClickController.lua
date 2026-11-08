-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Globals.Constants)

local Gears = require(ReplicatedStorage.Data.Gears)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local t1 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true
}
local t2 = {
    [Enum.KeyCode.ButtonR2] = true
}
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 30
        -- upvalues: UserInputService (copy), t (copy), Gears (copy), Remotes (copy), ToolGameplayGuard (copy), t1 (copy), t2 (copy), LocalPlayer (copy)
        local function isBatTool(p1) -- line: 35
            -- upvalues: t (copy), Gears (copy)
            local GearName = p1:GetAttribute("GearName")

            t.strict(t.optional(t.string))(GearName)

            return GearName ~= nil and Gears.GearNameExists(GearName) and Gears.Directory[GearName].BatControllerData ~= nil
        end

        local function isActivationInput(p2) -- line: 46
            -- upvalues: t1 (copy), t2 (copy)
            if t1[p2.UserInputType] == true then
                return true
            end

            return t2[p2.KeyCode] == true
        end

        local function trySendActivation() -- line: 51
            -- upvalues: isBatTool (copy), Remotes (copy), ToolGameplayGuard (copy), LocalPlayer (copy)
            if LocalPlayer then
                local Character = LocalPlayer.Character

                if Character then
                    local Tool = Character:FindFirstChildWhichIsA("Tool")

                    if Tool and ToolGameplayGuard.AllowsLocalUse(Tool) and Tool:GetAttribute("BanjoBridgePlaying") ~= true and not isBatTool(Tool) then
                        Remotes.ToolTrigger.Trigger:FireServer(Tool)
                    end
                end
            end
        end

        UserInputService.InputBegan:Connect(function(p3) -- line: 83
            -- upvalues: trySendActivation (copy), t1 (copy), t2 (copy)
            if t1[p3.UserInputType] == true or t2[p3.KeyCode] == true then
                trySendActivation()
            end
        end)
    end
}

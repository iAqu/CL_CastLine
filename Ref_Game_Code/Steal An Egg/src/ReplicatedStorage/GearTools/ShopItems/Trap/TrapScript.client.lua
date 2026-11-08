-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Parent = script.Parent

require(ReplicatedStorage.Shared.Globals.Constants)

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local n1 = 0

local function onActivated() -- line: 14
    -- upvalues: LocalPlayer (copy), Parent (copy), Remotes (copy), ToolGameplayGuard (copy), n1 (ref)
    if not ToolGameplayGuard.AllowsLocalUse(Parent) then
        return
    end

    local v1 = tick()

    if not (v1 - n1 < 1) and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        n1 = v1

        local Character = LocalPlayer.Character
        local PrimaryPart = Character.PrimaryPart
        local LookVector = PrimaryPart.CFrame.LookVector
        local v2 = PrimaryPart.Position + LookVector * 4
        local v3 = RaycastParams.new()

        v3.FilterType = Enum.RaycastFilterType.Exclude
        v3.FilterDescendantsInstances = { Character }

        if not workspace:Raycast(PrimaryPart.Position, LookVector * 4, v3) then
            local v5 = Vector3.new(v2.X, v2.Y + 5, v2.Z)
            local v6 = workspace:Raycast(v5, Vector3.new(0, -100, 0), v3)

            if v6 then
                v2 = v6.Position
            end

            local GearName = Parent:GetAttribute("GearName")

            if typeof(GearName) ~= "string" then
                GearName = Parent.Name
            end

            Remotes.TrapPlacement.AskPlace:FireServer(GearName, v2)
        end
    end
end

Parent.Activated:Connect(onActivated)

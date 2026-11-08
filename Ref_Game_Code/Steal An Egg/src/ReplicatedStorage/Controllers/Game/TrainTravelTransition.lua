-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Transition = require(script.Parent.HalloweenDimensionController.Transition)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local TrainRideCamera = require(script.Parent.TrainRideCamera)
local TrainTownLighting = require(script.Parent.TrainTownLighting)
local TrainVisuals = require(script.Parent.TrainVisuals)
local t1 = {
    Core = Color3.fromRGB(5, 122, 98),
    Edge = Color3.fromRGB(4, 38, 31),
    Shade = Color3.fromRGB(69, 242, 195),
    Embers = {
        Color3.fromRGB(125, 255, 210),
        Color3.fromRGB(69, 242, 195),
        Color3.fromRGB(205, 255, 238)
    },
    Veil = Color3.fromRGB(4, 38, 31),
    VeilTint = ColorSequence.new(Color3.fromRGB(14, 163, 131), Color3.new(1, 1, 1)),
    PuffTint = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(140, 170, 160))
}
local LocalPlayer = Players.LocalPlayer
local n1 = 0
local Position
local v3 = false
local v4 = false
local t2 = {}

local function rootPosition() -- line: 53
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v5 = Player.FindRootPart(LocalPlayer)

    return if v5 then v5.Position else nil
end

local function cameraModule() -- line: 58
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else nil

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    return require(PlayerModule):GetCameras()
end

local function faceForward() -- line: 67
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy), cameraModule (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v6 = Player.FindRootPart(LocalPlayer)

    if CurrentCamera == nil or v6 == nil or CurrentCamera.CameraType ~= Enum.CameraType.Custom then
        return
    end

    local LookVector = v6.CFrame.LookVector
    local v7 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v7.Magnitude < 0.01 then
        return
    end

    local v8 = cameraModule()
    local v9 = (if v8 then v8:GetCameraSubjectPosition() else nil) or v6.Position + Vector3.new(0, 1.5, 0)
    local v11 = math.max((if v8 then v8:GetCameraToSubjectDistance() else nil) or (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 0.5)
    local v12 = v7.Unit * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0, -0)
    local v13 = CFrame.lookAt(v9 - v12 * v11, v9)

    CurrentCamera.CFrame = v13

    if v8 then
        v8:CommitCameraCFrame(v13, Enum.CameraType.Custom)
    end
end

function t2.Cover(p1) -- line: 98
    -- upvalues: Transition (copy), Player (copy), t1 (copy), LocalPlayer (copy), n1 (ref), Position (ref), v3 (ref)
    n1 += 1

    local v14 = Player.FindRootPart(LocalPlayer)

    Position = if v14 then v14.Position else nil
    v3 = true
    Transition.Cover(t1, p1)
end

function t2.Reveal() -- line: 105
    -- upvalues: Transition (copy), v3 (ref)
    v3 = false
    Transition.Reveal()
end

function t2.RevealAfterMove(p2, p3, p4) -- line: 110
    -- upvalues: Transition (copy), Player (copy), LocalPlayer (copy), n1 (ref), Position (ref), t2 (copy), faceForward (copy)
    local v15 = n1
    local Position2 = Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 114
        -- upvalues: p2 (copy), p3 (copy), p4 (copy), v15 (copy), Position2 (copy), elapsed (copy), Transition (copy), Player (copy), LocalPlayer (copy), n1 (ref), t2 (copy), faceForward (copy)
        if p2 then
            local v16

            while true do
                if os.clock() - elapsed < 20 then
                    if n1 ~= v15 or not Transition.IsCovering() then
                        break
                    end

                    local v17 = Player.FindRootPart(LocalPlayer)
                    local Position = if v17 then v17.Position else nil
                    local Character = LocalPlayer.Character
                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                    if Character == p3 and Humanoid ~= nil and Humanoid.Health > 0 and Position ~= nil and (Position - p2).Magnitude <= 24 then
                        local v18 = v16 or os.clock()

                        if os.clock() - v18 >= (p4 or 0.12) then
                            faceForward()
                            t2.Reveal()

                            return
                        end

                        v16 = v18
                    else
                        v16 = nil
                    end

                    task.wait()
                    continue
                end

                return
            end
        else
            while true do
                if os.clock() - elapsed < 1 then
                    if n1 == v15 then
                        local v19 = Player.FindRootPart(LocalPlayer)
                        local Position = if v19 then v19.Position else nil

                        if Position2 == nil or Position and (Position - Position2).Magnitude > 12 then
                            break
                        end

                        task.wait()
                        continue
                    end

                    return
                end

                break
            end

            task.wait(0.12)

            if n1 == v15 then
                faceForward()
                t2.Reveal()
            end
        end
    end)
end

function t2.Start() -- line: 165
    -- upvalues: Remotes (copy), TrainRideCamera (copy), TrainTownLighting (copy), TrainVisuals (copy), LocalPlayer (copy), n1 (ref), v3 (ref), v4 (ref), t2 (copy)
    if v4 then
        return
    end

    v4 = true
    TrainRideCamera.Start()
    TrainTownLighting.Start()
    TrainVisuals.Start()
    LocalPlayer.CharacterRemoving:Connect(function() -- line: 173
        -- upvalues: LocalPlayer (copy), n1 (ref), v3 (ref), t2 (copy)
        n1 += 1

        if LocalPlayer:GetAttribute("TrainEventPhase") == "Respawning" then
            t2.Cover(20)
        elseif v3 then
            t2.Reveal()
        end
    end)
    Remotes.TrainEvent.Travel.OnClientEvent:Connect(function(p5, p6) -- line: 181
        -- upvalues: TrainRideCamera (copy), t2 (copy)
        local v20 = if typeof(p6) == "table" then p6 else nil

        if p5 == "RideStart" then
            TrainRideCamera.Begin(v20)
        elseif p5 == "RideEnd" then
            TrainRideCamera.Stop(v20 and v20.Id)
        elseif p5 == "Cover" then
            t2.Cover(v20 and v20.TimeoutSeconds)
        elseif p5 == "Reveal" then
            t2.RevealAfterMove(v20 and v20.Destination, v20 and v20.Character, v20 and v20.HoldSeconds)
        end
    end)
end

return t2

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Controls = require(PlayerScripts:WaitForChild("PlayerModule")):GetControls()
local t1 = nil
local v1 = false
local v2 = false
local t2 = {}

function t2.SetTrainCameraActive(p1) -- line: 41
    -- upvalues: t1 (ref), v2 (ref)
    v2 = p1

    if not (p1 and t1) then
        return
    end

    local t3 = t1

    if t1 ~= t3 then
        return
    end

    t1 = nil
    t3.Trove:Destroy()
end

function t2.Start() -- line: 48
    -- upvalues: LocalPlayer (copy), t1 (ref), v1 (ref)
    if v1 then
        return
    end

    v1 = true
    LocalPlayer.CharacterRemoving:Connect(function(p2) -- line: 54
        -- upvalues: t1 (ref)
        local t4 = t1

        if t4 and t4.Character == p2 then
            if t1 ~= t4 then
                return
            end

            t1 = nil
            t4.Trove:Destroy()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 60
        -- upvalues: LocalPlayer (copy), t1 (ref)
        local t5 = t1

        if t5 and t5.Character ~= LocalPlayer.Character then
            if t1 ~= t5 then
                return
            end

            t1 = nil
            t5.Trove:Destroy()
        end
    end)
end

function t2.Apply(p3, p4) -- line: 68
    -- upvalues: Lighting (copy), ReplicatedStorage (copy), Workspace (copy), Timer (copy), Trove (copy), LocalPlayer (copy), Controls (copy), t1 (ref), v2 (ref), t2 (copy)
    t2.Start()

    local Humanoid = p3:FindFirstChildOfClass("Humanoid")

    if not v2 and LocalPlayer:GetAttribute("TrainEventPhase") ~= "Departing" and LocalPlayer:GetAttribute("TrainEventPhase") ~= "Returning" and p3 == LocalPlayer.Character and p3:IsDescendantOf(Workspace) and Humanoid and not (Humanoid.Health <= 0) and not (p4 <= 0) then
        local elapsed = os.clock()
        local t6 = t1

        if not t6 or t6.Character ~= p3 then
            if t6 and t1 == t6 then
                t1 = nil
                t6.Trove:Destroy()
            end

            local v3 = Trove.new()
            local v4 = Timer.new(p4)
            local t7 = {
                Character = p3,
                ExpiresAt = elapsed + p4,
                Timer = v4,
                Trove = v3
            }

            t1 = t7
            v3:Add(v4)
            v3:Connect(v4.Tick, function() -- line: 108
                -- upvalues: t7 (copy), t1 (ref)
                if not (os.clock() >= t7.ExpiresAt) or t1 ~= t7 then
                    return
                end

                t1 = nil
                t7.Trove:Destroy()
            end)
            v3:Connect(Humanoid.Died, function() -- line: 113
                -- upvalues: t7 (copy), t1 (ref)
                if t1 == t7 then
                    t1 = nil
                    t7.Trove:Destroy()
                end
            end)
            v3:Connect(p3.Destroying, function() -- line: 116
                -- upvalues: t7 (copy), t1 (ref)
                if t1 == t7 then
                    t1 = nil
                    t7.Trove:Destroy()
                end
            end)

            local moveFunction = Controls.moveFunction

            local function invertedMove(p5, p6, p7) -- line: 121
                -- upvalues: moveFunction (copy)
                moveFunction(p5, -p6, p7)
            end

            Controls.moveFunction = invertedMove
            v3:Add(function() -- line: 129
                -- upvalues: moveFunction (copy), invertedMove (copy), Controls (copy)
                if Controls.moveFunction == invertedMove then
                    Controls.moveFunction = moveFunction
                end
            end)

            local CurrentCamera
            local n1 = 0

            local function restoreCamera() -- line: 137
                -- upvalues: CurrentCamera (ref), n1 (ref)
                if not CurrentCamera then
                    return
                end

                CurrentCamera.FieldOfView = n1
                CurrentCamera = nil
            end

            local function updateCamera() -- line: 143
                -- upvalues: t7 (copy), CurrentCamera (ref), n1 (ref), Workspace (copy), t1 (ref)
                if t1 ~= t7 or Workspace.CurrentCamera == CurrentCamera then
                    return
                elseif CurrentCamera then
                    CurrentCamera.FieldOfView = n1
                    CurrentCamera = nil
                end

                local CurrentCamera2 = Workspace.CurrentCamera

                CurrentCamera = CurrentCamera2

                if CurrentCamera2 then
                    n1 = CurrentCamera2.FieldOfView
                    CurrentCamera2.FieldOfView = n1 / 2.4
                end
            end

            v3:Add(restoreCamera)
            v3:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), updateCamera)

            if t1 == t7 and Workspace.CurrentCamera ~= CurrentCamera then
                if CurrentCamera then
                    CurrentCamera.FieldOfView = n1
                    CurrentCamera = nil
                end

                local CurrentCamera2 = Workspace.CurrentCamera

                CurrentCamera = CurrentCamera2

                if CurrentCamera2 then
                    n1 = CurrentCamera2.FieldOfView
                    CurrentCamera2.FieldOfView = n1 / 2.4
                end
            end

            local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

            v3:Add(ColorCorrectionEffect)
            ColorCorrectionEffect.Name = "BeeEffect"
            ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 0)
            ColorCorrectionEffect.Saturation = 0.5
            ColorCorrectionEffect.Parent = Lighting

            local Head = p3:FindFirstChild("Head")

            if Head and Head:IsA("BasePart") then
                local clone = ReplicatedStorage.Assets.ToolEffects.BeeToolEffect:Clone()

                v3:Add(clone)
                clone.CFrame = Head.CFrame

                local WeldConstraint = Instance.new("WeldConstraint")

                WeldConstraint.Part0 = Head
                WeldConstraint.Part1 = clone
                WeldConstraint.Parent = clone
                clone.Parent = Head
            end

            v4:Start()
        else
            t6.ExpiresAt = math.max(t6.ExpiresAt, elapsed + p4)
            t6.Timer:Stop()
            t6.Timer.Interval = t6.ExpiresAt - elapsed
            t6.Timer:Start()
        end
    end
end

return table.freeze(t2)

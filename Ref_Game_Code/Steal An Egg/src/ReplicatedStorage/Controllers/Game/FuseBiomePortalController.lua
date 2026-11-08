-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

return {
    Start = function() -- Start | line: 24
        -- upvalues: Players (copy), RunService (copy), TweenService (copy), Workspace (copy), GUI (copy), Remotes (copy)
        local v1 = GUI.FadeFrame()
        local LocalPlayer = Players.LocalPlayer
        local n1 = 0
        local t2, v2

        local function characterRoot() -- line: 32
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

            return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
        end

        local function waitForArrival(p1) -- line: 38
            -- upvalues: LocalPlayer (copy), RunService (copy)
            local v3 = os.clock() + 2

            while true do
                if os.clock() < v3 then
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                        HumanoidRootPart = nil
                    end

                    if HumanoidRootPart == nil or not ((HumanoidRootPart.Position - p1).Magnitude >= 200) then
                        RunService.Heartbeat:Wait()
                        continue
                    end

                    break
                end

                return
            end
        end

        local function faceCameraForward() -- line: 49
            -- upvalues: LocalPlayer (copy), Workspace (copy)
            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            local CurrentCamera = Workspace.CurrentCamera

            if HumanoidRootPart ~= nil and CurrentCamera ~= nil then
                local LookVector = HumanoidRootPart.CFrame.LookVector

                CurrentCamera.CFrame = CFrame.lookAt(HumanoidRootPart.Position - LookVector * 12 + Vector3.new(0, 5, 0), HumanoidRootPart.Position)
            end
        end

        Remotes.FuseBiome.PortalTransition.OnClientEvent:Connect(function(p2, p3, p4) -- line: 62
            -- upvalues: v1 (copy), LocalPlayer (copy), n1 (ref), t2 (ref), v2 (ref), waitForArrival (copy), RunService (copy), TweenService (copy), Workspace (copy), Remotes (copy)
            if p4 then
                if t2 and t2.Id == p3 then
                    t2.Complete = true
                end
            else
                if v2 then
                    v2:Cancel()
                end

                n1 += 1

                local v4 = n1
                local Character = LocalPlayer.Character
                local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                    HumanoidRootPart = nil
                end

                if HumanoidRootPart ~= nil then
                    local t3 = if p3 then {
                        Complete = false,
                        Id = p3
                    } else nil

                    t2 = t3

                    local Position = HumanoidRootPart.Position
                    local tween = TweenService:Create(v1, TweenInfo.new(p2, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0
                    })

                    v2 = tween
                    tween:Play()
                    tween.Completed:Wait()

                    if v4 == n1 then
                        if t3 then
                            if not t3.Complete then
                                Remotes.FuseBiome.PortalTransition:FireServer(t3.Id)
                            end

                            local v5 = os.clock() + 5

                            while not t3.Complete and os.clock() < v5 and v4 == n1 do
                                RunService.Heartbeat:Wait()
                            end

                            if v4 ~= n1 then
                                return
                            end

                            local v6 = os.clock() + 2

                            while t3.Complete do
                                if os.clock() < v6 and v4 == n1 then
                                    local Character = LocalPlayer.Character
                                    local HumanoidRootPart2 = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")
                                    local HumanoidRootPart3 = if HumanoidRootPart2 == nil or not HumanoidRootPart2:IsA("BasePart") then nil else HumanoidRootPart2

                                    if HumanoidRootPart3 and HumanoidRootPart3 == HumanoidRootPart then
                                        if (HumanoidRootPart3.Position - Position).Magnitude >= 1 then
                                            break
                                        end

                                        RunService.Heartbeat:Wait()
                                        continue
                                    end
                                end

                                break
                            end
                        else
                            waitForArrival(Position)
                        end

                        task.wait(0.1)

                        if v4 == n1 then
                            local Character = LocalPlayer.Character
                            local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

                            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                                HumanoidRootPart = nil
                            end

                            local CurrentCamera = Workspace.CurrentCamera

                            if HumanoidRootPart ~= nil and CurrentCamera ~= nil then
                                local LookVector = HumanoidRootPart.CFrame.LookVector

                                CurrentCamera.CFrame = CFrame.lookAt(HumanoidRootPart.Position - LookVector * 12 + Vector3.new(0, 5, 0), HumanoidRootPart.Position)
                            end

                            t2 = nil
                            v2 = TweenService:Create(v1, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {
                                BackgroundTransparency = 1
                            })
                            v2:Play()
                        end
                    end
                else
                    v1.BackgroundTransparency = 1
                    t2 = nil
                end
            end
        end)
    end
}

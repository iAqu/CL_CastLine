-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TrainEvent = require(ReplicatedStorage.Shared.Remotes).TrainEvent
local t1 = {}
local v1 = false
local v2, t2

local function restoreJump() -- line: 11
    -- upvalues: t2 (ref)
    local t3 = t2

    t2 = nil

    if t3 and t3.Humanoid.Parent then
        t3.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, t3.Enabled)
    end
end

function t1.Start() -- line: 17
    -- upvalues: Players (copy), RunService (copy), Workspace (copy), TrainEvent (copy), v1 (ref), v2 (ref), t2 (ref)
    if v1 then
        return
    end

    v1 = true

    local LocalPlayer = Players.LocalPlayer

    TrainEvent.Travel.OnClientEvent:Connect(function(p1, p2) -- line: 21
        -- upvalues: LocalPlayer (copy), Players (copy), RunService (copy), Workspace (copy), TrainEvent (copy), v2 (ref), t2 (ref)
        if p1 == "ServerTravelEnd" then
            if typeof(p2) == "table" and v2 and v2.Id == p2.Id then
                v2 = nil

                local t4 = t2

                t2 = nil

                if t4 and t4.Humanoid.Parent then
                    t4.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, t4.Enabled)
                end
            end
        elseif p1 == "ServerTravel" and typeof(p2) == "table" and typeof(p2.Id) == "string" and (p2.Stage == "Prepare" or p2.Stage == "Authorized") and typeof(p2.Target) == "CFrame" and typeof(p2.FloorPath) == "table" and typeof(p2.Timeout) == "number" and LocalPlayer.Character == p2.Character then
            v2 = p2

            local v3 = os.clock() + math.clamp(p2.Timeout, 1, 12)
            local v4

            while true do
                RunService.PostSimulation:Wait()

                if v2 == p2 and LocalPlayer.Character == p2.Character then
                    local Character = p2.Character
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) then
                        local v5 = RaycastParams.new()

                        v5.FilterType = Enum.RaycastFilterType.Exclude

                        local t5 = {}

                        for _, player in Players:GetPlayers() do
                            if player.Character then
                                table.insert(t5, player.Character)
                            end
                        end

                        v5.FilterDescendantsInstances = t5
                        v5.RespectCanCollide = true

                        local v6 = Workspace:Raycast(p2.Target.Position + Vector3.new(0, 3, 0), Vector3.new(0, -32, 0), v5)

                        if not t2 then
                            t2 = {
                                Humanoid = Humanoid,
                                Enabled = Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
                            }
                            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                            Humanoid.Jump = false
                        end

                        local v7 = Character:FindFirstChild("TrainTravelWeld", true) == nil and Humanoid.WalkSpeed == 0

                        if v6 then
                            v6 = typeof(p2.FloorPosition) == "Vector3" and (v6.Position - p2.FloorPosition).Magnitude <= 4
                        end

                        local v8 = p2.Stage == "Prepare" or (HumanoidRootPart.Position - p2.Target.Position).Magnitude <= 12

                        if v7 and v6 and v8 then
                            v4 = v4 or os.clock()

                            if os.clock() - v4 >= 0.1 then
                                TrainEvent.TravelReady:FireServer(p2.Id, p2.Stage, Character)

                                return
                            end
                        else
                            v4 = nil
                        end

                        if v3 <= os.clock() then
                            return
                        end

                        continue
                    end

                    return
                end

                break
            end
        end
    end)
    LocalPlayer.CharacterRemoving:Connect(function() -- line: 68
        -- upvalues: v2 (ref), t2 (ref)
        v2 = nil

        local t6 = t2

        t2 = nil

        if t6 and t6.Humanoid.Parent then
            t6.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, t6.Enabled)
        end
    end)
end

return t1

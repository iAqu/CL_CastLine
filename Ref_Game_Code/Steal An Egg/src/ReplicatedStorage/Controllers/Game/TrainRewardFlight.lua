-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t1 = {
    Point = function(p1, p2, p3, p4) -- Point | line: 6
        local v1 = 1 - p4

        return p1 * (v1 * v1) + p2 * (2 * v1 * p4) + p3 * (p4 * p4)
    end
}

function t1.Play(p5, p6) -- line: 10
    -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), t1 (copy)
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local v2 = p5.AbsolutePosition + p5.AbsoluteSize * 0.5
    local AbsoluteSize = p5.AbsoluteSize

    task.spawn(function() -- line: 15
        -- upvalues: p5 (copy), p6 (copy), LocalPlayer (copy), Character (copy), v2 (copy), AbsoluteSize (copy), ReplicatedStorage (copy), RunService (copy), t1 (copy)
        local Main = require(ReplicatedStorage.Controllers.GUI.BackpackController.Main)
        local MutationRewardTarget = Main:GetMutationRewardTarget(p6)
        local v3 = os.clock() + 0.6

        while true do
            local v4 = if MutationRewardTarget then MutationRewardTarget.Name == "Hotbar" else nil

            if (not MutationRewardTarget or v4) and os.clock() < v3 then
                RunService.Heartbeat:Wait()
                MutationRewardTarget = Main:GetMutationRewardTarget(p6)
                continue
            end

            break
        end

        if LocalPlayer.Character == Character and MutationRewardTarget and MutationRewardTarget.Parent and not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
            local ScreenGui = Instance.new("ScreenGui")

            ScreenGui.Name = "TrainRewardFlight"
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 200

            local clone = p5:Clone()

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("LuaSourceContainer") then
                    descendant:Destroy()
                elseif descendant:IsA("UIScale") then
                    descendant:Destroy()
                elseif descendant:IsA("UIAspectRatioConstraint") then
                    descendant:Destroy()
                elseif descendant:IsA("UISizeConstraint") then
                    descendant:Destroy()
                end
            end

            clone:SetAttribute("UIEffectsPaused", true)
            clone.AnchorPoint = Vector2.new(0.5, 0.5)
            clone.Position = UDim2.fromOffset(v2.X, v2.Y)
            clone.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
            clone.Visible = true
            clone.Parent = ScreenGui
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local v5 = false
            local connection, connection2

            local function cleanup() -- line: 35
                -- upvalues: ScreenGui (copy), v5 (ref), connection (ref), connection2 (ref)
                if v5 then
                    return
                end

                v5 = true

                if connection then
                    connection:Disconnect()
                end

                if connection2 then
                    connection2:Disconnect()
                end

                ScreenGui:Destroy()
            end

            connection2 = LocalPlayer.CharacterRemoving:Connect(cleanup)

            local elapsed = os.clock()

            connection = RunService.RenderStepped:Connect(function() -- line: 43
                -- upvalues: MutationRewardTarget (ref), ScreenGui (copy), clone (copy), v5 (ref), connection (ref), connection2 (ref), elapsed (copy), v2 (copy), AbsoluteSize (copy), t1 (copy)
                if not (MutationRewardTarget.Parent and ScreenGui.Parent) then
                    if not v5 then
                        v5 = true

                        if connection then
                            connection:Disconnect()
                        end

                        if connection2 then
                            connection2:Disconnect()
                        end

                        ScreenGui:Destroy()
                    end
                else
                    local v7 = math.clamp((os.clock() - elapsed) / 0.7, 0, 1)
                    local v8 = MutationRewardTarget.AbsolutePosition + MutationRewardTarget.AbsoluteSize * 0.5
                    local v10 = Vector2.new((v2.X + v8.X) * 0.5, math.min(v2.Y, v8.Y) - 130)
                    local v11 = t1.Point(v2, v10, v8, v7)
                    local v12 = math.min(MutationRewardTarget.AbsoluteSize.X, MutationRewardTarget.AbsoluteSize.Y, 56)
                    local v13 = AbsoluteSize:Lerp(Vector2.new(v12, v12), v7)

                    clone.Position = UDim2.fromOffset(v11.X, v11.Y)
                    clone.Size = UDim2.fromOffset(v13.X, v13.Y)
                    clone.Rotation = math.sin(3.141592653589793 * v7) * -12

                    if v7 >= 1 then
                        if v5 then
                            return
                        end

                        v5 = true

                        if connection then
                            connection:Disconnect()
                        end

                        if connection2 then
                            connection2:Disconnect()
                        end

                        ScreenGui:Destroy()
                    end
                end
            end)
            task.delay(1.5, cleanup)
        end
    end)
end

return t1

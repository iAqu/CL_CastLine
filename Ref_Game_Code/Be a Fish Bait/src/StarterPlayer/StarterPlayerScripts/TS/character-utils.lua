-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace

return {
    orientToFishingArea = function() -- orientToFishingArea | line: 7
        -- upvalues: CollectionService (copy), Players (copy), Workspace (copy)
        local v1 = CollectionService:GetTagged("FishingArea")[1]

        if v1 ~= nil and v1:IsA("Model") then
            local DetectableArea = v1:FindFirstChild("DetectableArea")
            local Character, v2

            if DetectableArea ~= nil then
                if DetectableArea:IsA("BasePart") then
                    Character = Players.LocalPlayer.Character

                    if Character ~= nil then
                        Character = Character:FindFirstChild("HumanoidRootPart")
                    end

                    v2 = false
                else
                    v2 = true
                end
            else
                v2 = true
            end

            if v2 then
                return nil
            end

            if Character ~= nil and Character:IsA("BasePart") then
                local v3 = DetectableArea.CFrame.LookVector * -1

                Character.CFrame = CFrame.new(Character.Position, Character.Position + v3)

                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil then
                    local v4 = Character.Position - v3 * 16 + Vector3.new(0, 6, 0)
                    local v5 = CFrame.lookAt(v4, Character.Position + v3)

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = v5
                    task.wait(0.1)
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                end

                return
            end
        end

        return nil
    end,
    teleportToEventShop = function() -- teleportToEventShop | line: 48
        -- upvalues: CollectionService (copy), Players (copy), Workspace (copy)
        local v6 = CollectionService:GetTagged("EventShopTeleport")[1]

        if v6 ~= nil and v6:IsA("Attachment") then
            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    local WorldPosition = v6.WorldPosition
                    local LookVector = v6.WorldCFrame.LookVector

                    HumanoidRootPart.CFrame = CFrame.new(WorldPosition, WorldPosition + LookVector)

                    local CurrentCamera = Workspace.CurrentCamera

                    if CurrentCamera ~= nil then
                        local v7 = WorldPosition - LookVector * 16 + Vector3.new(0, 6, 0)

                        CurrentCamera.CFrame = CFrame.lookAt(v7, WorldPosition + LookVector)
                    end

                    return
                end
            end
        end

        return nil
    end,
    listenForCharacter = function(p1, p2) -- listenForCharacter | line: 76
        p2(p1.Character)

        local connection = p1.CharacterAdded:Connect(function(p3) -- line: 79
            -- upvalues: p2 (copy)
            p2(p3)
        end)
        local connection2 = p1.CharacterRemoving:Connect(function() -- line: 82
            -- upvalues: p2 (copy)
            p2(nil)
        end)

        return function() -- line: 85
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end,
    listenForHumanoid = function(p4, p5) -- listenForHumanoid | line: 90
        if not p4 then
            return nil
        end

        local v8 = p4:WaitForChild("Humanoid", 10)

        if if v8 == nil then v8 else v8:IsA("Humanoid") then
            p5(v8)
        end

        if v8 then
            return
        end

        local connection = p4.ChildAdded:Connect(function(p6) -- line: 104
            -- upvalues: p5 (copy)
            if p6:IsA("Humanoid") then
                p5(p6)
            end
        end)

        return function() -- line: 109
            -- upvalues: connection (copy)
            connection:Disconnect()
        end
    end
}

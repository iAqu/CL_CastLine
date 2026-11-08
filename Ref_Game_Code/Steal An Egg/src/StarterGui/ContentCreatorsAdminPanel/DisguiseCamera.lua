-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

return {
    Start = function() -- Start | line: 6
        -- upvalues: Players (copy), RunService (copy)
        local LocalPlayer = Players.LocalPlayer
        local Cameras = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetCameras()
        local t2
        local v1 = Vector2.zero
        local n1 = 0
        local Zoom

        local function restore() -- line: 22
            -- upvalues: LocalPlayer (copy), t2 (ref), Zoom (ref)
            if not t2 then
                return
            end

            if t2.Humanoid.Parent then
                t2.Humanoid.CameraOffset = t2.Offset
            end

            LocalPlayer.CameraMaxZoomDistance = t2.MaxZoom
            Zoom = t2.Zoom
            t2 = nil
        end

        RunService:BindToRenderStep("CreatorDisguiseCamera", Enum.RenderPriority.Camera.Value - 1, function() -- line: 37
            -- upvalues: LocalPlayer (copy), Cameras (copy), t2 (ref), v1 (ref), n1 (ref), Zoom (ref)
            local CurrentCamera = workspace.CurrentCamera
            local Character = LocalPlayer.Character
            local v3, v4

            if Character then
                v3 = Character:FindFirstChildWhichIsA("Humanoid")
                v4 = Character:FindFirstChild("HumanoidRootPart")
                Character = Character:FindFirstChild("CreatorGuardDisguise")
            else
                v4 = Character
                v3 = Character
            end

            local Character2, v5

            if not v3 or v3.Health <= 0 then
                v5 = false
            elseif Character and Character:IsA("Model") then
                Character2 = Character
                v5 = true
            else
                v5 = false
            end

            if not v5 then
                Character2 = nil
            end

            if t2 and (t2.Model ~= Character2 or t2.Humanoid ~= v3) and t2 then
                if t2.Humanoid.Parent then
                    t2.Humanoid.CameraOffset = t2.Offset
                end

                LocalPlayer.CameraMaxZoomDistance = t2.MaxZoom
                Zoom = t2.Zoom
                t2 = nil
            end

            if not CurrentCamera or CurrentCamera.CameraType ~= Enum.CameraType.Custom or CurrentCamera.CameraSubject ~= v3 then
                return
            end

            if Zoom then
                Cameras:SetCameraToSubjectDistance(Zoom)
                Zoom = nil
            end

            if Character2 and v3 and v4 and v4:IsA("BasePart") then
                local CreatorCameraFocus = Character2:GetAttribute("CreatorCameraFocus")
                local CreatorCameraSize = Character2:GetAttribute("CreatorCameraSize")

                if typeof(CreatorCameraFocus) == "Vector3" and typeof(CreatorCameraSize) == "Vector3" then
                    if not t2 then
                        local CameraSubjectPosition = Cameras:GetCameraSubjectPosition()

                        if not CameraSubjectPosition then
                            return
                        end

                        t2 = {
                            Model = Character2,
                            Humanoid = v3,
                            Offset = v3.CameraOffset,
                            Zoom = Cameras:GetCameraToSubjectDistance() or (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude,
                            MaxZoom = LocalPlayer.CameraMaxZoomDistance
                        }
                        v3.CameraOffset += CreatorCameraFocus - v4.CFrame:PointToObjectSpace(CameraSubjectPosition)
                        v1 = Vector2.zero
                    end

                    if not (CurrentCamera.ViewportSize.X <= 0 or CurrentCamera.ViewportSize.Y <= 0) then
                        if v1 == CurrentCamera.ViewportSize then
                            if n1 ~= CurrentCamera.FieldOfView then
                                local ViewportSize, FieldOfView = CurrentCamera.ViewportSize, CurrentCamera.FieldOfView

                                v1 = ViewportSize
                                n1 = FieldOfView

                                local X = v1.X
                                local v9 = v1
                                local v10 = X / math.max(v9.Y, 1)
                                local v14 = math.atan(math.tan(math.rad(n1) / 2) * math.min(v10, 1))
                                local v16 = math.max(6, CreatorCameraSize.Magnitude * 0.55 / math.sin(v14))
                                local t4 = t2

                                LocalPlayer.CameraMaxZoomDistance = math.max(t4.MaxZoom, v16 * 1.5)

                                local t5 = t2

                                Cameras:SetCameraToSubjectDistance((math.max(t5.Zoom, v16)))
                            end
                        else
                            local ViewportSize, FieldOfView = CurrentCamera.ViewportSize, CurrentCamera.FieldOfView

                            v1 = ViewportSize
                            n1 = FieldOfView

                            local X = v1.X
                            local v19 = v1
                            local v20 = X / math.max(v19.Y, 1)
                            local v24 = math.atan(math.tan(math.rad(n1) / 2) * math.min(v20, 1))
                            local v26 = math.max(6, CreatorCameraSize.Magnitude * 0.55 / math.sin(v24))
                            local t6 = t2

                            LocalPlayer.CameraMaxZoomDistance = math.max(t6.MaxZoom, v26 * 1.5)

                            local t7 = t2

                            Cameras:SetCameraToSubjectDistance((math.max(t7.Zoom, v26)))
                        end
                    end
                end
            end
        end)

        return function() -- line: 121
            -- upvalues: LocalPlayer (copy), Cameras (copy), t2 (ref), Zoom (ref), RunService (copy)
            RunService:UnbindFromRenderStep("CreatorDisguiseCamera")

            if t2 then
                if t2.Humanoid.Parent then
                    t2.Humanoid.CameraOffset = t2.Offset
                end

                LocalPlayer.CameraMaxZoomDistance = t2.MaxZoom
                Zoom = t2.Zoom
                t2 = nil
            end

            if Zoom then
                Cameras:SetCameraToSubjectDistance(Zoom)
            end
        end
    end
}

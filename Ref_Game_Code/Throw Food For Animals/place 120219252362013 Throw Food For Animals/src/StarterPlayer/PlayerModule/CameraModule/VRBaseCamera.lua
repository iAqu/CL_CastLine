-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local VRService = game:GetService("VRService")
local _ = game:GetService("Players").LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))

require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")

local CameraGamepadResetAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraGamepadResetAction")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 36
    -- upvalues: CameraGamepadResetAction (copy), BaseCamera (copy), self (copy)
    local v3 = setmetatable(BaseCamera.new(), self)

    v3.gamepadZoomLevels = { 0, 7 }
    v3.headScale = 1
    v3:SetCameraToSubjectDistance(7)
    v3.VRFadeResetTimer = 0
    v3.VREdgeBlurTimer = 0
    v3.needsReset = true
    v3.recentered = false
    v3.gamepadResetConnection = CameraGamepadResetAction.Pressed:Connect(function() -- line: 55
        -- upvalues: v3 (copy)
        v3:GamepadReset()
    end)
    v3:Reset()

    return v3
end

function self.Reset(p1) -- line: 65
    p1.stepRotateTimeout = 0
end

function self.GetModuleName(_) -- line: 69
    return "VRBaseCamera"
end

function self.GamepadZoomPress(p3) -- line: 73
    -- upvalues: BaseCamera (copy)
    BaseCamera.GamepadZoomPress(p3)
    p3:GamepadReset()
    p3:ResetZoom()
end

function self.GamepadReset(p4) -- line: 81
    p4.stepRotateTimeout = 0
    p4.needsReset = true
end

function self.ResetZoom(p5) -- line: 86
    -- upvalues: ZoomController (copy)
    ZoomController.SetZoomParameters(p5.currentSubjectDistance, 0)
    ZoomController.ReleaseSpring()
end

function self.OnEnabledChanged(p6) -- line: 91
    -- upvalues: VRService (copy), Lighting (copy), CameraGamepadResetAction (copy), BaseCamera (copy)
    BaseCamera.OnEnabledChanged(p6)

    if p6.enabled then
        CameraGamepadResetAction.Enabled = true
        p6.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() -- line: 98
            -- upvalues: p6 (copy)
            p6:Reset()
        end)
        p6.vrRecentered = VRService.UserCFrameChanged:Connect(function(p7, _) -- line: 102
            -- upvalues: p6 (copy)
            if p7 == Enum.UserCFrame.Floor then
                p6.recentered = true
            end
        end)
    else
        if p6.inFirstPerson then
            p6:GamepadZoomPress()
        end

        if p6.thirdPersonOptionChanged then
            p6.thirdPersonOptionChanged:Disconnect()
            p6.thirdPersonOptionChanged = nil
        end

        if p6.vrRecentered then
            p6.vrRecentered:Disconnect()
            p6.vrRecentered = nil
        end

        if p6.cameraHeadScaleChangedConn then
            p6.cameraHeadScaleChangedConn:Disconnect()
            p6.cameraHeadScaleChangedConn = nil
        end

        CameraGamepadResetAction.Enabled = false

        local VRFade = Lighting:FindFirstChild("VRFade")

        if VRFade then
            VRFade.Brightness = 0
        end
    end
end

function self.OnCurrentCameraChanged(p9) -- line: 139
    -- upvalues: BaseCamera (copy)
    BaseCamera.OnCurrentCameraChanged(p9)

    if p9.cameraHeadScaleChangedConn then
        p9.cameraHeadScaleChangedConn:Disconnect()
        p9.cameraHeadScaleChangedConn = nil
    end

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    p9.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- line: 151
        -- upvalues: p9 (copy)
        p9:OnHeadScaleChanged()
    end)
    p9:OnHeadScaleChanged()
end

function self.OnHeadScaleChanged(p10) -- line: 156
    local HeadScale = workspace.CurrentCamera.HeadScale

    for v4, v5 in p10.gamepadZoomLevels do
        p10.gamepadZoomLevels[v4] = v5 * HeadScale / p10.headScale
    end

    p10:SetCameraToSubjectDistance(p10:GetCameraToSubjectDistance() * HeadScale / p10.headScale)
    p10.headScale = HeadScale
end

function self.GetVRFocus(p11, p12, p13) -- line: 172
    local v6 = p11.lastCameraFocus or p12

    p11.cameraTranslationConstraints = Vector3.new(p11.cameraTranslationConstraints.x, math.min(1, p11.cameraTranslationConstraints.y + p13), p11.cameraTranslationConstraints.z)

    local v9 = Vector3.new(0, p11:GetCameraHeight(), 0)

    return (CFrame.new(Vector3.new(p12.x, v6.y, p12.z):Lerp(p12 + v9, p11.cameraTranslationConstraints.y)))
end

function self.StartFadeFromBlack(p14) -- line: 188
    -- upvalues: Lighting (copy), UserGameSettings (copy)
    if UserGameSettings.VignetteEnabled == false then
        return
    end

    local VRFade = Lighting:FindFirstChild("VRFade")

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect")
        VRFade.Name = "VRFade"
        VRFade.Parent = Lighting
    end

    VRFade.Brightness = -1
    p14.VRFadeResetTimer = 0.1
end

function self.UpdateFadeFromBlack(p15, p16) -- line: 203
    -- upvalues: Lighting (copy)
    local VRFade = Lighting:FindFirstChild("VRFade")

    if p15.VRFadeResetTimer > 0 then
        p15.VRFadeResetTimer = math.max(p15.VRFadeResetTimer - p16, 0)

        local VRFade = Lighting:FindFirstChild("VRFade")

        if VRFade and VRFade.Brightness < 0 then
            VRFade.Brightness = math.min(VRFade.Brightness + p16 * 10, 0)
        end
    elseif VRFade then
        VRFade.Brightness = 0
    end
end

function self.StartVREdgeBlur(p17, p18, p19) -- line: 219
    -- upvalues: VRService (copy), RunService (copy), UserGameSettings (copy)
    if not p19 and UserGameSettings.VignetteEnabled == false then
        return
    end

    local VRBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart")

    if not VRBlurPart then
        VRBlurPart = Instance.new("Part")
        VRBlurPart.Name = "VRBlurPart"
        VRBlurPart.Parent = workspace.CurrentCamera
        VRBlurPart.CanTouch = false
        VRBlurPart.CanCollide = false
        VRBlurPart.CanQuery = false
        VRBlurPart.Anchored = true
        VRBlurPart.Size = Vector3.new(0.44, 0.47, 1)
        VRBlurPart.Transparency = 1
        VRBlurPart.CastShadow = false
        RunService.RenderStepped:Connect(function(_) -- line: 239
            -- upvalues: VRBlurPart (ref), VRService (copy)
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v12 = workspace.CurrentCamera.CFrame * (CFrame.new(UserCFrame.Position * workspace.CurrentCamera.HeadScale) * (UserCFrame - UserCFrame.Position))
            local VRBlurPart2 = VRBlurPart

            VRBlurPart2.CFrame = v12 * CFrame.Angles(0, 3.141592653589793, 0) + v12.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
            VRBlurPart2.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale
        end)
    end

    local VRBlurScreen = p18.PlayerGui:FindFirstChild("VRBlurScreen")
    local VRBlur = if VRBlurScreen then VRBlurScreen:FindFirstChild("VRBlur") else nil
    local ImageLabel

    if VRBlur then
        ImageLabel = VRBlur
    else
        local v13 = VRBlurScreen or Instance.new("SurfaceGui")

        v13.Name = "VRBlurScreen"
        v13.Parent = p18.PlayerGui
        v13.Adornee = VRBlurPart
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "VRBlur"
        ImageLabel.Parent = v13
        ImageLabel.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

        local v14 = workspace.CurrentCamera.ViewportSize.X * 2.3 / 512
        local v15 = workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512

        ImageLabel.Size = UDim2.fromScale(v14, v15)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Active = true
        ImageLabel.ScaleType = Enum.ScaleType.Stretch
    end

    ImageLabel.Visible = true
    ImageLabel.ImageTransparency = 0
    p17.VREdgeBlurTimer = 0.14
end

function self.UpdateEdgeBlur(p21, p22, p23) -- line: 288
    local VRBlurScreen = p22.PlayerGui:FindFirstChild("VRBlurScreen")
    local VRBlur = if VRBlurScreen then VRBlurScreen:FindFirstChild("VRBlur") else nil

    if VRBlur then
        if p21.VREdgeBlurTimer > 0 then
            p21.VREdgeBlurTimer -= p23

            local VRBlurScreen = p22.PlayerGui:FindFirstChild("VRBlurScreen")

            if VRBlurScreen then
                local VRBlur = VRBlurScreen:FindFirstChild("VRBlur")

                if VRBlur then
                    VRBlur.ImageTransparency = 1 - math.clamp(p21.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142
                end
            end
        else
            VRBlur.Visible = false
        end
    end
end

function self.GetCameraHeight(p24) -- line: 313
    if p24.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * p24.currentSubjectDistance
end

function self.GetSubjectCFrame(p25) -- line: 320
    -- upvalues: BaseCamera (copy)
    local v16 = BaseCamera.GetSubjectCFrame(p25)
    local CurrentCamera = workspace.CurrentCamera
    local v17 = CurrentCamera and CurrentCamera.CameraSubject

    if not v17 then
        return v16
    end

    local v18 = if v17:IsA("Humanoid") and v17:GetState() == Enum.HumanoidStateType.Dead and v17 == p25.lastSubject then p25.lastSubjectCFrame else v16

    if v18 then
        p25.lastSubjectCFrame = v18
    end

    return v18
end

function self.GetSubjectPosition(p26) -- line: 346
    -- upvalues: BaseCamera (copy)
    local v19 = BaseCamera.GetSubjectPosition(p26)
    local CurrentCamera = game.Workspace.CurrentCamera
    local v20 = CurrentCamera and CurrentCamera.CameraSubject

    if not v20 then
        return nil
    end

    if v20:IsA("Humanoid") then
        if v20:GetState() == Enum.HumanoidStateType.Dead and v20 == p26.lastSubject then
            v19 = p26.lastSubjectPosition
        end
    elseif v20:IsA("VehicleSeat") then
        v19 = v20.CFrame.Position + v20.CFrame:vectorToWorldSpace((Vector3.new(0, 4, 0)))
    end

    p26.lastSubjectPosition = v19

    return v19
end

function self.getRotation(p27, p28) -- line: 375
    -- upvalues: UserGameSettings (copy), CameraInput (copy)
    local v21 = CameraInput.getRotation(p28)

    if UserGameSettings.VRSmoothRotationEnabled then
        return v21.X
    end

    if math.abs(v21.X) > 0.03 then
        if p27.stepRotateTimeout > 0 then
            p27.stepRotateTimeout -= p28
        end

        if p27.stepRotateTimeout <= 0 then
            local v22 = (if v21.X < 0 then -1 else 1) * 0.5235987755982988

            p27:StartFadeFromBlack()
            p27.stepRotateTimeout = 0.25

            return v22
        end
    elseif math.abs(v21.X) < 0.02 then
        p27.stepRotateTimeout = 0
    end

    return 0
end

function self.HandleSubjectDistance(p29, p30) -- line: 410
    if p30 and p30.IsInFirstPerson and p30:IsInFirstPerson() then
        p29:SetCameraToSubjectDistance(0)
    end
end

return self

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function v1() -- line: 17
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end

local ok, result = pcall(v1)
local v2 = ok and result
local VRService = game:GetService("VRService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserCameraInputDt = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 41
    -- upvalues: BaseCamera (copy), self (copy)
    local v5 = setmetatable(BaseCamera.new(), self)

    v5.gamepadZoomLevels = { 0, 7 }
    v5.headScale = 1
    v5:SetCameraToSubjectDistance(7)
    v5.VRFadeResetTimer = 0
    v5.VREdgeBlurTimer = 0
    v5.gamepadResetConnection = nil
    v5.needsReset = true
    v5.recentered = false
    v5:Reset()

    return v5
end

function self.Reset(p1) -- line: 67
    p1.stepRotateTimeout = 0
end

function self.GetModuleName(_) -- line: 71
    return "VRBaseCamera"
end

function self.GamepadZoomPress(p3) -- line: 75
    -- upvalues: BaseCamera (copy)
    BaseCamera.GamepadZoomPress(p3)
    p3:GamepadReset()
    p3:ResetZoom()
end

function self.GamepadReset(p4) -- line: 83
    p4.stepRotateTimeout = 0
    p4.needsReset = true
end

function self.ResetZoom(p5) -- line: 88
    -- upvalues: ZoomController (copy)
    ZoomController.SetZoomParameters(p5.currentSubjectDistance, 0)
    ZoomController.ReleaseSpring()
end

function self.OnEnabledChanged(p6) -- line: 93
    -- upvalues: v2 (copy), VRService (copy), LocalPlayer (copy), Lighting (copy), CameraInput (copy), BaseCamera (copy)
    BaseCamera.OnEnabledChanged(p6)

    if p6.enabled then
        p6.gamepadResetConnection = CameraInput.gamepadReset:Connect(function() -- line: 97
            -- upvalues: p6 (copy)
            p6:GamepadReset()
        end)
        p6.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() -- line: 102
            -- upvalues: p6 (copy), v2 (copy)
            if v2 or not p6:IsInFirstPerson() then
                p6:Reset()
            end
        end)
        p6.vrRecentered = VRService.UserCFrameChanged:Connect(function(p7, _) -- line: 113
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

        if p6.gamepadResetConnection then
            p6.gamepadResetConnection:Disconnect()
            p6.gamepadResetConnection = nil
        end

        p6.VREdgeBlurTimer = 0
        p6:UpdateEdgeBlur(LocalPlayer, 1)

        local VRFade = Lighting:FindFirstChild("VRFade")

        if VRFade then
            VRFade.Brightness = 0
        end
    end
end

function self.OnCurrentCameraChanged(p9) -- line: 155
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

    p9.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- line: 167
        -- upvalues: p9 (copy)
        p9:OnHeadScaleChanged()
    end)
    p9:OnHeadScaleChanged()
end

function self.OnHeadScaleChanged(p10) -- line: 172
    local HeadScale = workspace.CurrentCamera.HeadScale

    for v6, v7 in p10.gamepadZoomLevels do
        p10.gamepadZoomLevels[v6] = v7 * HeadScale / p10.headScale
    end

    p10:SetCameraToSubjectDistance(p10:GetCameraToSubjectDistance() * HeadScale / p10.headScale)
    p10.headScale = HeadScale
end

function self.GetVRFocus(p11, p12, p13) -- line: 188
    local v8 = p11.lastCameraFocus or p12

    p11.cameraTranslationConstraints = Vector3.new(p11.cameraTranslationConstraints.x, math.min(1, p11.cameraTranslationConstraints.y + p13), p11.cameraTranslationConstraints.z)

    local v11 = Vector3.new(0, p11:GetCameraHeight(), 0)

    return (CFrame.new(Vector3.new(p12.x, v8.y, p12.z):Lerp(p12 + v11, p11.cameraTranslationConstraints.y)))
end

function self.StartFadeFromBlack(p14) -- line: 204
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

function self.UpdateFadeFromBlack(p15, p16) -- line: 219
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

function self.StartVREdgeBlur(p17, p18) -- line: 235
    -- upvalues: VRService (copy), RunService (copy), UserGameSettings (copy)
    if UserGameSettings.VignetteEnabled == false then
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
        RunService.RenderStepped:Connect(function(_) -- line: 255
            -- upvalues: VRBlurPart (ref), VRService (copy)
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v14 = workspace.CurrentCamera.CFrame * (CFrame.new(UserCFrame.p * workspace.CurrentCamera.HeadScale) * (UserCFrame - UserCFrame.p))
            local VRBlurPart2 = VRBlurPart

            VRBlurPart2.CFrame = v14 * CFrame.Angles(0, 3.141592653589793, 0) + v14.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
            VRBlurPart2.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale
        end)
    end

    local VRBlurScreen = p18.PlayerGui:FindFirstChild("VRBlurScreen")
    local VRBlur = if VRBlurScreen then VRBlurScreen:FindFirstChild("VRBlur") else nil
    local ImageLabel

    if VRBlur then
        ImageLabel = VRBlur
    else
        local v15 = VRBlurScreen or Instance.new("SurfaceGui") or Instance.new("ScreenGui")

        v15.Name = "VRBlurScreen"
        v15.Parent = p18.PlayerGui
        v15.Adornee = VRBlurPart
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "VRBlur"
        ImageLabel.Parent = v15
        ImageLabel.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

        local v16 = workspace.CurrentCamera.ViewportSize.X * 2.3 / 512
        local v17 = workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512

        ImageLabel.Size = UDim2.fromScale(v16, v17)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Active = true
        ImageLabel.ScaleType = Enum.ScaleType.Stretch
    end

    ImageLabel.Visible = true
    ImageLabel.ImageTransparency = 0
    p17.VREdgeBlurTimer = 0.14
end

function self.UpdateEdgeBlur(p20, p21, p22) -- line: 304
    local VRBlurScreen = p21.PlayerGui:FindFirstChild("VRBlurScreen")
    local VRBlur = if VRBlurScreen then VRBlurScreen:FindFirstChild("VRBlur") else nil

    if VRBlur then
        if p20.VREdgeBlurTimer > 0 then
            p20.VREdgeBlurTimer -= p22

            local VRBlurScreen = p21.PlayerGui:FindFirstChild("VRBlurScreen")

            if VRBlurScreen then
                local VRBlur = VRBlurScreen:FindFirstChild("VRBlur")

                if VRBlur then
                    VRBlur.ImageTransparency = 1 - math.clamp(p20.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142
                end
            end
        else
            VRBlur.Visible = false
        end
    end
end

function self.GetCameraHeight(p23) -- line: 329
    if p23.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * p23.currentSubjectDistance
end

function self.GetSubjectCFrame(p24) -- line: 336
    -- upvalues: BaseCamera (copy)
    local v18 = BaseCamera.GetSubjectCFrame(p24)
    local CurrentCamera = workspace.CurrentCamera
    local v19 = CurrentCamera and CurrentCamera.CameraSubject

    if not v19 then
        return v18
    end

    local v20 = if v19:IsA("Humanoid") and v19:GetState() == Enum.HumanoidStateType.Dead and v19 == p24.lastSubject then p24.lastSubjectCFrame else v18

    if v20 then
        p24.lastSubjectCFrame = v20
    end

    return v20
end

function self.GetSubjectPosition(p25) -- line: 362
    -- upvalues: BaseCamera (copy)
    local v21 = BaseCamera.GetSubjectPosition(p25)
    local CurrentCamera = game.Workspace.CurrentCamera
    local v22 = CurrentCamera and CurrentCamera.CameraSubject

    if not v22 then
        return nil
    end

    if v22:IsA("Humanoid") then
        if v22:GetState() == Enum.HumanoidStateType.Dead and v22 == p25.lastSubject then
            v21 = p25.lastSubjectPosition
        end
    elseif v22:IsA("VehicleSeat") then
        v21 = v22.CFrame.p + v22.CFrame:vectorToWorldSpace((Vector3.new(0, 4, 0)))
    end

    p25.lastSubjectPosition = v21

    return v21
end

function self.getRotation(p26, p27) -- line: 391
    -- upvalues: UserGameSettings (copy), CameraInput (copy), UserCameraInputDt (copy)
    local v23 = CameraInput.getRotation(p27)

    if UserGameSettings.VRSmoothRotationEnabled then
        if UserCameraInputDt then
            return v23.X
        end

        return v23.X * 40 * p27
    end

    if math.abs(v23.X) > 0.03 then
        if p26.stepRotateTimeout > 0 then
            p26.stepRotateTimeout -= p27
        end

        if p26.stepRotateTimeout <= 0 then
            local v24 = (if v23.X < 0 then -1 else 1) * 0.5235987755982988

            p26:StartFadeFromBlack()
            p26.stepRotateTimeout = 0.25

            return v24
        end
    elseif math.abs(v23.X) < 0.02 then
        p26.stepRotateTimeout = 0
    end

    return 0
end

return self

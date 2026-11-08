-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local t2 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock"
}
local t3 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode"
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils = require(script:WaitForChild("CameraUtils"))
local CameraInput = require(script:WaitForChild("CameraInput"))
local ZoomController = require(script:WaitForChild("ZoomController"))
local ClassicCamera = require(script:WaitForChild("ClassicCamera"))
local OrbitalCamera = require(script:WaitForChild("OrbitalCamera"))
local LegacyCamera = require(script:WaitForChild("LegacyCamera"))
local VehicleCamera = require(script:WaitForChild("VehicleCamera"))
local VRCamera = require(script:WaitForChild("VRCamera"))
local VRVehicleCamera = require(script:WaitForChild("VRVehicleCamera"))
local Invisicam = require(script:WaitForChild("Invisicam"))
local Poppercam = require(script:WaitForChild("Poppercam"))
local TransparencyController = require(script:WaitForChild("TransparencyController"))
local MouseLockController = require(script:WaitForChild("MouseLockController"))
local t4 = {}
local t5 = {}

assert(Players.LocalPlayer, "Strict typing check")

local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")

PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)

local UserRespectLegacyCameraOptions = FlagUtil.getUserFlag("UserRespectLegacyCameraOptions")
local UserPlayerConnectionMemoryLeak = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local UserPreferredInputPlayerScripts2 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2")
local UserPSFixCameraControllerReset = FlagUtil.getUserFlag("UserPSFixCameraControllerReset")

function t1.new() -- line: 173
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), Players (copy), RunService (copy), UserInputService (copy), UserGameSettings (copy), ConnectionUtil (copy), TransparencyController (copy), MouseLockController (copy), UserRespectLegacyCameraOptions (copy), UserPlayerConnectionMemoryLeak (copy), UserPreferredInputPlayerScripts2 (copy)
    local v1 = setmetatable({
        activeTransparencyController = TransparencyController.new(),
        connectionUtil = if UserPlayerConnectionMemoryLeak then ConnectionUtil.new() else nil
    }, t1)

    v1.activeCameraController = nil
    v1.activeOcclusionModule = nil
    v1.activeMouseLockController = nil
    v1.currentComputerCameraMovementMode = nil
    v1.pendingCameraToSubjectDistance = nil
    v1.cameraSubjectChangedConn = nil
    v1.cameraTypeChangedConn = nil

    for _, player in pairs(Players:GetPlayers()) do
        v1:OnPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(function(p1) -- line: 197
        -- upvalues: v1 (copy)
        v1:OnPlayerAdded(p1)
    end)

    if UserPlayerConnectionMemoryLeak then
        Players.PlayerRemoving:Connect(function(p2) -- line: 202
            -- upvalues: v1 (copy)
            v1:OnPlayerRemoving(p2)
        end)
    end

    v1.activeTransparencyController:Enable(true)

    if not UserInputService.TouchEnabled or UserPreferredInputPlayerScripts2 then
        v1.activeMouseLockController = MouseLockController.new()
        assert(v1.activeMouseLockController, "Strict typing check")

        local BindableToggleEvent = v1.activeMouseLockController:GetBindableToggleEvent()

        if BindableToggleEvent then
            BindableToggleEvent:Connect(function() -- line: 215
                -- upvalues: v1 (copy)
                v1:OnMouseLockToggled()
            end)
        end
    end

    if UserRespectLegacyCameraOptions then
        v1:ActivateCameraController()
    else
        v1:ActivateCameraController(v1:GetCameraControlChoice())
    end

    v1:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    v1:OnCurrentCameraChanged()
    RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(p3) -- line: 228
        -- upvalues: v1 (copy)
        v1:Update(p3)
    end)

    for _, v2 in pairs(t2) do
        Players.LocalPlayer:GetPropertyChangedSignal(v2):Connect(function() -- line: 234
            -- upvalues: v1 (copy), v2 (copy)
            v1:OnLocalPlayerCameraPropertyChanged(v2)
        end)
    end

    for _, v3 in pairs(t3) do
        UserGameSettings:GetPropertyChangedSignal(v3):Connect(function() -- line: 240
            -- upvalues: v1 (copy), v3 (copy)
            v1:OnUserGameSettingsPropertyChanged(v3)
        end)
    end

    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 244
        -- upvalues: v1 (copy)
        v1:OnCurrentCameraChanged()
    end)

    if UserPreferredInputPlayerScripts2 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 248
            -- upvalues: v1 (copy)
            v1:OnPreferredInputChanged()
        end)
    end

    return v1
end

function t1.GetCameraMovementModeFromSettings(_) -- line: 256
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), CameraUtils (copy), UserPreferredInputPlayerScripts2 (copy)
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
    end

    local v4 = if UserPreferredInputPlayerScripts2 then UserInputService.PreferredInput == Enum.PreferredInput.Touch else UserInputService.TouchEnabled
    local v5 = if v4 then CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode) else CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
    local v6 = if v4 then CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode) else CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)

    if v5 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v6
    end

    return v5
end

function t1.ActivateOcclusionModule(p5, p6) -- line: 286
    -- upvalues: Players (copy), Invisicam (copy), Poppercam (copy), t5 (copy)
    local v7

    if p6 == Enum.DevCameraOcclusionMode.Zoom then
        v7 = Poppercam
    else
        if p6 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")

            return
        end

        v7 = Invisicam
    end

    p5.occlusionMode = p6

    if p5.activeOcclusionModule and p5.activeOcclusionModule:GetOcclusionMode() == p6 then
        if not p5.activeOcclusionModule:GetEnabled() then
            p5.activeOcclusionModule:Enable(true)
        end
    else
        local activeOcclusionModule = p5.activeOcclusionModule

        p5.activeOcclusionModule = t5[v7]

        if not p5.activeOcclusionModule then
            p5.activeOcclusionModule = v7.new()

            if p5.activeOcclusionModule then
                t5[v7] = p5.activeOcclusionModule
            end
        end

        if not p5.activeOcclusionModule then
            return
        end

        if p5.activeOcclusionModule:GetOcclusionMode() ~= p6 then
            warn("CameraScript ActivateOcclusionModule mismatch: ", p5.activeOcclusionModule:GetOcclusionMode(), "~=", p6)
        end

        if activeOcclusionModule then
            if activeOcclusionModule == p5.activeOcclusionModule then
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
            else
                activeOcclusionModule:Enable(false)
            end
        end

        if p6 == Enum.DevCameraOcclusionMode.Invisicam then
            if Players.LocalPlayer.Character then
                p5.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer)
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player and player.Character then
                    p5.activeOcclusionModule:CharacterAdded(player.Character, player)
                end
            end

            p5.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
        end

        p5.activeOcclusionModule:Enable(true)
    end
end

function t1.ShouldUseVehicleCamera(p7) -- line: 370
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return false
    end

    local CameraType, CameraSubject = CurrentCamera.CameraType, CurrentCamera.CameraSubject
    local v8 = CameraType == Enum.CameraType.Custom or CameraType == Enum.CameraType.Follow
    local VehicleSeat = CameraSubject and CameraSubject:IsA("VehicleSeat") or false
    local v9 = p7.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam

    return VehicleSeat and v8 and v9
end

function t1.ActivateCameraController(p8, p9, p10) -- line: 386
    -- upvalues: VRService (copy), ClassicCamera (copy), OrbitalCamera (copy), LegacyCamera (copy), VehicleCamera (copy), VRCamera (copy), VRVehicleCamera (copy), t4 (copy), UserRespectLegacyCameraOptions (copy), UserPSFixCameraControllerReset (copy)
    local v10, v11

    if UserRespectLegacyCameraOptions then
        v10 = workspace.CurrentCamera.CameraType
        v11 = p8:GetCameraMovementModeFromSettings()
    else
        v11 = p9
        v10 = p10
    end

    local v12

    if UserRespectLegacyCameraOptions or v10 ~= nil then
        if v10 == Enum.CameraType.Scriptable then
            if p8.activeCameraController then
                p8.activeCameraController:Enable(false)
                p8.activeCameraController = nil
            end

            return
        end

        if v10 == Enum.CameraType.Custom then
            v11 = p8:GetCameraMovementModeFromSettings()
            v12 = nil
        elseif v10 == Enum.CameraType.Track then
            v11 = Enum.ComputerCameraMovementMode.Classic
            v12 = nil
        elseif v10 == Enum.CameraType.Follow then
            v11 = Enum.ComputerCameraMovementMode.Follow
            v12 = nil
        elseif v10 == Enum.CameraType.Orbital then
            v11 = Enum.ComputerCameraMovementMode.Orbital
            v12 = nil
        elseif v10 ~= Enum.CameraType.Attach and v10 ~= Enum.CameraType.Watch and v10 ~= Enum.CameraType.Fixed then
            v12 = nil
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", v10)
        else
            v12 = LegacyCamera
        end
    end

    if not v12 then
        if VRService.VREnabled then
            v12 = VRCamera
        elseif v11 ~= Enum.ComputerCameraMovementMode.Classic and v11 ~= Enum.ComputerCameraMovementMode.Follow and v11 ~= Enum.ComputerCameraMovementMode.Default and v11 ~= Enum.ComputerCameraMovementMode.CameraToggle then
            if v11 ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.")

                return
            end

            v12 = OrbitalCamera
        else
            v12 = ClassicCamera
        end
    end

    if p8:ShouldUseVehicleCamera() then
        v12 = if VRService.VREnabled then VRVehicleCamera else VehicleCamera
    end

    local v13

    if t4[v12] then
        v13 = t4[v12]

        if UserPSFixCameraControllerReset then
            if v13.Reset and p8.activeCameraController ~= v13 then
                v13:Reset()
            end
        elseif v13.Reset then
            v13:Reset()
        end
    else
        v13 = v12.new()
        t4[v12] = v13
    end

    if p8.activeCameraController then
        if p8.activeCameraController == v13 then
            if not p8.activeCameraController:GetEnabled() then
                p8.activeCameraController:Enable(true)
            end
        else
            p8.activeCameraController:Enable(false)
            p8.activeCameraController = v13
            p8.activeCameraController:Enable(true)
        end
    elseif v13 ~= nil then
        p8.activeCameraController = v13
        assert(p8.activeCameraController, "Strict typing check")
        p8.activeCameraController:Enable(true)
    end

    if p8.activeCameraController then
        if UserRespectLegacyCameraOptions then
            p8.activeCameraController:SetCameraMovementMode(v11)
            p8.activeCameraController:SetCameraType(v10)
        elseif v11 ~= nil then
            p8.activeCameraController:SetCameraMovementMode(v11)
        elseif v10 ~= nil then
            p8.activeCameraController:SetCameraType(v10)
        end
    end

    local pendingCameraToSubjectDistance = p8.pendingCameraToSubjectDistance

    if p8.activeCameraController ~= nil and pendingCameraToSubjectDistance ~= nil then
        p8.pendingCameraToSubjectDistance = nil
        p8.activeCameraController:SetCameraToSubjectDistance(pendingCameraToSubjectDistance)
    end
end

function t1.SetCameraToSubjectDistance(p11, p12, p13) -- line: 516
    local CurrentCamera = workspace.CurrentCamera
    local v14 = if p13 ~= nil then p13 elseif CurrentCamera == nil then p13 else CurrentCamera.CameraType

    if p11.activeCameraController == nil then
        if v14 == nil or v14 == Enum.CameraType.Scriptable then
            p11.pendingCameraToSubjectDistance = p12

            return p12
        end

        p11:ActivateCameraController(nil, v14)
    end

    local activeCameraController = p11.activeCameraController

    if activeCameraController == nil then
        return nil
    end

    return activeCameraController:SetCameraToSubjectDistance(p12)
end

function t1.GetCameraSubjectPosition(p14, p15) -- line: 543
    local CurrentCamera = workspace.CurrentCamera
    local v15 = if p15 ~= nil then p15 elseif CurrentCamera == nil then p15 else CurrentCamera.CameraType

    if p14.activeCameraController == nil and v15 ~= nil and v15 ~= Enum.CameraType.Scriptable then
        p14:ActivateCameraController(nil, v15)
    end

    local activeCameraController = p14.activeCameraController

    if activeCameraController == nil then
        return nil
    end

    return activeCameraController:GetSubjectPosition()
end

function t1.SetCameraToSubjectDistanceFromCFrame(p16, p17, p18) -- line: 566
    local CurrentCamera = workspace.CurrentCamera
    local v16 = if p18 ~= nil then p18 elseif CurrentCamera == nil then p18 else CurrentCamera.CameraType
    local CameraSubjectPosition = p16:GetCameraSubjectPosition(v16)

    if CameraSubjectPosition == nil then
        return nil
    end

    local activeCameraController = p16.activeCameraController

    if activeCameraController ~= nil then
        activeCameraController.lastCameraTransform = p17
        activeCameraController.lastCameraFocus = CFrame.new(CameraSubjectPosition)
        activeCameraController.resetCameraAngle = false
        activeCameraController.lastUserPanCamera = tick()
    end

    return p16:SetCameraToSubjectDistance((p17.Position - CameraSubjectPosition).Magnitude, v16)
end

function t1.CommitCameraCFrame(p19, p20, p21) -- line: 592
    -- upvalues: ZoomController (copy)
    local v17 = p19:SetCameraToSubjectDistanceFromCFrame(p20, p21)

    if v17 ~= nil then
        ZoomController.ReleaseSpring()
    end

    return v17
end

function t1.GetCameraToSubjectDistance(p22) -- line: 601
    local activeCameraController = p22.activeCameraController

    if activeCameraController == nil then
        return nil
    end

    return activeCameraController:GetCameraToSubjectDistance()
end

function t1.OnCameraSubjectChanged(p23) -- line: 611
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = if CurrentCamera then CurrentCamera.CameraSubject else nil

    if p23.activeTransparencyController then
        p23.activeTransparencyController:SetSubject(CameraSubject)
    end

    if p23.activeOcclusionModule then
        p23.activeOcclusionModule:OnCameraSubjectChanged(CameraSubject)
    end

    p23:ActivateCameraController(nil, if CurrentCamera then CurrentCamera.CameraType else nil)
end

function t1.OnCameraTypeChanged(p24, p25) -- line: 626
    -- upvalues: UserInputService (copy), CameraUtils (copy)
    if p25 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils.restoreMouseBehavior()
    end

    p24:ActivateCameraController(nil, p25)
end

function t1.OnCurrentCameraChanged(p26) -- line: 638
    local CurrentCamera = game.Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    if p26.cameraSubjectChangedConn then
        p26.cameraSubjectChangedConn:Disconnect()
    end

    if p26.cameraTypeChangedConn then
        p26.cameraTypeChangedConn:Disconnect()
    end

    p26.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 652
        -- upvalues: p26 (copy)
        p26:OnCameraSubjectChanged()
    end)
    p26.cameraTypeChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- line: 656
        -- upvalues: p26 (copy), CurrentCamera (copy)
        p26:OnCameraTypeChanged(CurrentCamera.CameraType)
    end)
    p26:OnCameraSubjectChanged()
    p26:OnCameraTypeChanged(CurrentCamera.CameraType)
end

function t1.OnLocalPlayerCameraPropertyChanged(p27, p28) -- line: 664
    -- upvalues: Players (copy), CameraUtils (copy)
    if p28 == "CameraMode" then
        if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                local CameraMovementModeFromSettings = p27:GetCameraMovementModeFromSettings()

                p27:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings))
            else
                warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
            end
        else
            if not p27.activeCameraController or p27.activeCameraController:GetModuleName() ~= "ClassicCamera" then
                p27:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic))
            end

            if p27.activeCameraController then
                p27.activeCameraController:UpdateForDistancePropertyChange()
            end
        end
    elseif p28 == "DevComputerCameraMode" or p28 == "DevTouchCameraMode" then
        local CameraMovementModeFromSettings = p27:GetCameraMovementModeFromSettings()

        p27:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings))
    elseif p28 == "DevCameraOcclusionMode" then
        p27:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    elseif (p28 == "CameraMinZoomDistance" or p28 == "CameraMaxZoomDistance") and p27.activeCameraController then
        p27.activeCameraController:UpdateForDistancePropertyChange()
    end
end

function t1.OnUserGameSettingsPropertyChanged(p29, p30) -- line: 698
    -- upvalues: CameraUtils (copy)
    if p30 == "ComputerCameraMovementMode" then
        local CameraMovementModeFromSettings = p29:GetCameraMovementModeFromSettings()

        p29:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings))
    end
end

function t1.OnPreferredInputChanged(p31) -- line: 705
    -- upvalues: CameraUtils (copy)
    local CameraMovementModeFromSettings = p31:GetCameraMovementModeFromSettings()

    p31:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(CameraMovementModeFromSettings))
end

function t1.Update(p32, p33) -- line: 716
    -- upvalues: CameraInput (copy)
    if p32.activeCameraController then
        p32.activeCameraController:UpdateMouseBehavior()

        local v18, v19 = p32.activeCameraController:Update(p33)

        if p32.activeOcclusionModule then
            v18, v19 = p32.activeOcclusionModule:Update(p33, v18, v19)
        end

        local CurrentCamera = game.Workspace.CurrentCamera

        CurrentCamera.CFrame = v18
        CurrentCamera.Focus = v19

        if p32.activeTransparencyController then
            p32.activeTransparencyController:Update(p33)
        end

        if CameraInput.getInputEnabled() then
            CameraInput.resetInputForFrameEnd()
        end
    end
end

function t1.GetCameraControlChoice(_) -- line: 744
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), CameraUtils (copy), UserRespectLegacyCameraOptions (copy)
    assert(not UserRespectLegacyCameraOptions, "CameraModule:GetCameraControlChoice should not be called when FFlagUserRespectLegacyCameraOptions is enabled")

    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch or UserInputService.TouchEnabled then
        if Players.LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
            return CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
        end

        return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
    end

    if Players.LocalPlayer.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
        return CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
    end

    local v21 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)

    return CameraUtils.ConvertCameraModeEnumToStandard(v21)
end

function t1.OnCharacterAdded(p35, p36, p37) -- line: 768
    if p35.activeOcclusionModule then
        p35.activeOcclusionModule:CharacterAdded(p36, p37)
    end
end

function t1.OnCharacterRemoving(p38, p39, p40) -- line: 774
    if p38.activeOcclusionModule then
        p38.activeOcclusionModule:CharacterRemoving(p39, p40)
    end
end

function t1.OnPlayerAdded(p41, p42) -- line: 780
    -- upvalues: UserPlayerConnectionMemoryLeak (copy)
    local connectionUtil

    if UserPlayerConnectionMemoryLeak then
        connectionUtil = p41.connectionUtil
    else
        p42.CharacterAdded:Connect(function(p43) -- line: 798
            -- upvalues: p41 (copy), p42 (copy)
            p41:OnCharacterAdded(p43, p42)
        end)
        p42.CharacterRemoving:Connect(function(p44) -- line: 801
            -- upvalues: p41 (copy), p42 (copy)
            p41:OnCharacterRemoving(p44, p42)
        end)
    end

    if (not UserPlayerConnectionMemoryLeak or connectionUtil) and UserPlayerConnectionMemoryLeak then
        p41.connectionUtil:trackConnection(("%*CharacterAdded"):format(p42.UserId), p42.CharacterAdded:Connect(function(p45) -- line: 786
            -- upvalues: p41 (copy), p42 (copy)
            p41:OnCharacterAdded(p45, p42)
        end))
        p41.connectionUtil:trackConnection(("%*CharacterRemoving"):format(p42.UserId), p42.CharacterRemoving:Connect(function(p46) -- line: 792
            -- upvalues: p41 (copy), p42 (copy)
            p41:OnCharacterRemoving(p46, p42)
        end))
    end
end

function t1.OnPlayerRemoving(p47, p48) -- line: 807
    if p47.connectionUtil then
        p47.connectionUtil:disconnect((("%*CharacterAdded"):format(p48.UserId)))
        p47.connectionUtil:disconnect((("%*CharacterRemoving"):format(p48.UserId)))
    end
end

function t1.OnMouseLockToggled(p49) -- line: 815
    if p49.activeMouseLockController then
        local IsMouseLocked = p49.activeMouseLockController:GetIsMouseLocked()
        local MouseLockOffset = p49.activeMouseLockController:GetMouseLockOffset()

        if p49.activeCameraController then
            p49.activeCameraController:SetIsMouseLocked(IsMouseLocked)
            p49.activeCameraController:SetMouseLockOffset(MouseLockOffset)
        end
    end
end

return (t1.new())

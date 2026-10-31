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
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"))
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local FlagUtil = CommonUtils.get("FlagUtil")
local CameraUtils = require(script:WaitForChild("CameraUtils"))

require(script:WaitForChild("CameraInput"))

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

if not Players.LocalPlayer then
    return {}
end

assert(Players.LocalPlayer, "Strict typing check")

local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")

PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)

local UserPlayerConnectionMemoryLeak = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local UserPSFixCameraControllerReset = FlagUtil.getUserFlag("UserPSFixCameraControllerReset")
local UserVRFixCameraCloseArticulation = FlagUtil.getUserFlag("UserVRFixCameraCloseArticulation")
local _FFlagUserOrthographicOcclusion = FFlagUserOrthographicOcclusion

if _FFlagUserOrthographicOcclusion then
    local function v1() -- line: 107
        return Instance.new("Camera").ProjectionType
    end

    _FFlagUserOrthographicOcclusion = pcall(v1)
end

local VRFirstPersonState = CommonUtils.get("VRFirstPersonState")

function t1.new() -- line: 151
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), Players (copy), UserInputService (copy), UserGameSettings (copy), ConnectionUtil (copy), TransparencyController (copy), MouseLockController (copy), UserPlayerConnectionMemoryLeak (copy)
    local v2 = setmetatable({
        activeTransparencyController = TransparencyController.new(),
        connectionUtil = if UserPlayerConnectionMemoryLeak then ConnectionUtil.new() else nil
    }, t1)

    v2.activeCameraController = nil
    v2.activeOcclusionModule = nil
    v2.activeMouseLockController = nil
    v2.currentComputerCameraMovementMode = nil
    v2.cameraSubjectChangedConn = nil
    v2.cameraTypeChangedConn = nil

    for _, player in pairs(Players:GetPlayers()) do
        v2:OnPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(function(p1) -- line: 174
        -- upvalues: v2 (copy)
        v2:OnPlayerAdded(p1)
    end)

    if UserPlayerConnectionMemoryLeak then
        Players.PlayerRemoving:Connect(function(p2) -- line: 179
            -- upvalues: v2 (copy)
            v2:OnPlayerRemoving(p2)
        end)
    end

    v2.activeTransparencyController:Enable(true)
    v2.activeMouseLockController = MouseLockController.new()
    assert(v2.activeMouseLockController, "Strict typing check")

    local BindableToggleEvent = v2.activeMouseLockController:GetBindableToggleEvent()

    if BindableToggleEvent then
        BindableToggleEvent:Connect(function() -- line: 191
            -- upvalues: v2 (copy)
            v2:OnMouseLockToggled()
        end)
    end

    v2:ActivateCameraController()
    v2:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    v2:OnCurrentCameraChanged()

    for _, v3 in pairs(t2) do
        Players.LocalPlayer:GetPropertyChangedSignal(v3):Connect(function() -- line: 201
            -- upvalues: v2 (copy), v3 (copy)
            v2:OnLocalPlayerCameraPropertyChanged(v3)
        end)
    end

    for _, v4 in pairs(t3) do
        UserGameSettings:GetPropertyChangedSignal(v4):Connect(function() -- line: 207
            -- upvalues: v2 (copy), v4 (copy)
            v2:OnUserGameSettingsPropertyChanged(v4)
        end)
    end

    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 211
        -- upvalues: v2 (copy)
        v2:OnCurrentCameraChanged()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 214
        -- upvalues: v2 (copy)
        v2:OnPreferredInputChanged()
    end)

    return v2
end

function t1.GetCameraMovementModeFromSettings(_) -- line: 221
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), CameraUtils (copy)
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
    end

    local v5, v6

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v5 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
        v6 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
    else
        v5 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
        v6 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
    end

    if v5 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v6
    end

    return v5
end

function t1.ActivateOcclusionModule(p4, p5) -- line: 246
    -- upvalues: Players (copy), Invisicam (copy), Poppercam (copy), t5 (copy)
    local v7

    if p5 == Enum.DevCameraOcclusionMode.Zoom then
        v7 = Poppercam
    else
        if p5 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")

            return
        end

        v7 = Invisicam
    end

    p4.occlusionMode = p5

    if p4.activeOcclusionModule and p4.activeOcclusionModule:GetOcclusionMode() == p5 then
        if not p4.activeOcclusionModule:GetEnabled() then
            p4.activeOcclusionModule:Enable(true)
        end
    else
        local activeOcclusionModule = p4.activeOcclusionModule

        p4.activeOcclusionModule = t5[v7]

        if not p4.activeOcclusionModule then
            p4.activeOcclusionModule = v7.new()

            if p4.activeOcclusionModule then
                t5[v7] = p4.activeOcclusionModule
            end
        end

        if not p4.activeOcclusionModule then
            return
        end

        if p4.activeOcclusionModule:GetOcclusionMode() ~= p5 then
            warn("CameraScript ActivateOcclusionModule mismatch: ", p4.activeOcclusionModule:GetOcclusionMode(), "~=", p5)
        end

        if activeOcclusionModule then
            if activeOcclusionModule == p4.activeOcclusionModule then
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
            else
                activeOcclusionModule:Enable(false)
            end
        end

        if p5 == Enum.DevCameraOcclusionMode.Invisicam then
            if Players.LocalPlayer.Character then
                p4.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer)
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player and player.Character then
                    p4.activeOcclusionModule:CharacterAdded(player.Character, player)
                end
            end

            p4.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
        end

        p4.activeOcclusionModule:Enable(true)
    end
end

function t1.ShouldUseVehicleCamera(p6) -- line: 325
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return false
    end

    local CameraType, CameraSubject = CurrentCamera.CameraType, CurrentCamera.CameraSubject
    local v8 = CameraType == Enum.CameraType.Custom or CameraType == Enum.CameraType.Follow
    local VehicleSeat = CameraSubject and CameraSubject:IsA("VehicleSeat") or false
    local v9 = p6.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam

    return VehicleSeat and v8 and v9
end

function t1.ActivateCameraController(p7) -- line: 341
    -- upvalues: VRService (copy), ClassicCamera (copy), OrbitalCamera (copy), LegacyCamera (copy), VehicleCamera (copy), VRCamera (copy), VRVehicleCamera (copy), t4 (copy), UserPSFixCameraControllerReset (copy)
    local CameraType = workspace.CurrentCamera.CameraType
    local CameraMovementModeFromSettings = p7:GetCameraMovementModeFromSettings()

    if CameraType == Enum.CameraType.Scriptable then
        if p7.activeCameraController then
            p7.activeCameraController:Enable(false)
            p7.activeCameraController = nil
        end
    else
        local v10

        if CameraType == Enum.CameraType.Custom then
            CameraMovementModeFromSettings = p7:GetCameraMovementModeFromSettings()
        elseif CameraType == Enum.CameraType.Track then
            CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Classic
        elseif CameraType == Enum.CameraType.Follow then
            CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Follow
        elseif CameraType == Enum.CameraType.Orbital then
            CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Orbital
        elseif CameraType ~= Enum.CameraType.Attach and CameraType ~= Enum.CameraType.Watch and CameraType ~= Enum.CameraType.Fixed then
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", CameraType)
        else
            v10 = LegacyCamera
        end

        if not v10 then
            if VRService.VREnabled then
                v10 = VRCamera
            elseif CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Classic and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Follow and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Default and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.CameraToggle then
                if CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Orbital then
                    warn("ActivateCameraController did not select a module.")

                    return
                end

                v10 = OrbitalCamera
            else
                v10 = ClassicCamera
            end
        end

        if p7:ShouldUseVehicleCamera() then
            v10 = if VRService.VREnabled then VRVehicleCamera else VehicleCamera
        end

        local v11

        if t4[v10] then
            v11 = t4[v10]

            if UserPSFixCameraControllerReset then
                if v11.Reset and p7.activeCameraController ~= v11 then
                    v11:Reset()
                end
            elseif v11.Reset then
                v11:Reset()
            end
        else
            v11 = v10.new()
            t4[v10] = v11
        end

        if p7.activeCameraController then
            if p7.activeCameraController == v11 then
                if not p7.activeCameraController:GetEnabled() then
                    p7.activeCameraController:Enable(true)
                end
            else
                if v11.HandleSubjectDistance then
                    v11:HandleSubjectDistance(p7.activeCameraController)
                end

                p7.activeCameraController:Enable(false)
                p7.activeCameraController = v11
                p7.activeCameraController:Enable(true)
            end
        elseif v11 ~= nil then
            p7.activeCameraController = v11
            assert(p7.activeCameraController, "Strict typing check")
            p7.activeCameraController:Enable(true)
        end

        if p7.activeCameraController then
            p7.activeCameraController:SetCameraMovementMode(CameraMovementModeFromSettings)
            p7.activeCameraController:SetCameraType(CameraType)
        end
    end
end

function t1.OnCameraSubjectChanged(p8) -- line: 450
    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = if CurrentCamera then CurrentCamera.CameraSubject else nil

    if p8.activeTransparencyController then
        p8.activeTransparencyController:SetSubject(CameraSubject)
    end

    if p8.activeOcclusionModule then
        p8.activeOcclusionModule:OnCameraSubjectChanged(CameraSubject)
    end

    p8:ActivateCameraController()
end

function t1.OnCameraTypeChanged(p9, p10) -- line: 465
    -- upvalues: UserInputService (copy), CameraUtils (copy)
    if p10 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils.restoreMouseBehavior()
    end

    p9:ActivateCameraController()
end

function t1.OnCurrentCameraChanged(p11) -- line: 477
    local CurrentCamera = game.Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    if p11.cameraSubjectChangedConn then
        p11.cameraSubjectChangedConn:Disconnect()
    end

    if p11.cameraTypeChangedConn then
        p11.cameraTypeChangedConn:Disconnect()
    end

    p11.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 489
        -- upvalues: p11 (copy)
        p11:OnCameraSubjectChanged()
    end)
    p11.cameraTypeChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- line: 493
        -- upvalues: p11 (copy), CurrentCamera (copy)
        p11:OnCameraTypeChanged(CurrentCamera.CameraType)
    end)
    p11:OnCameraSubjectChanged()
    p11:OnCameraTypeChanged(CurrentCamera.CameraType)
end

function t1.OnLocalPlayerCameraPropertyChanged(p12, p13) -- line: 501
    -- upvalues: Players (copy)
    if p13 == "CameraMode" then
        if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                p12:ActivateCameraController()
            else
                warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
            end
        else
            if not p12.activeCameraController or p12.activeCameraController:GetModuleName() ~= "ClassicCamera" then
                p12:ActivateCameraController()
            end

            if p12.activeCameraController then
                p12.activeCameraController:UpdateForDistancePropertyChange()
            end
        end
    elseif p13 == "DevComputerCameraMode" or p13 == "DevTouchCameraMode" then
        p12:ActivateCameraController()
    elseif p13 == "DevCameraOcclusionMode" then
        p12:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    elseif (p13 == "CameraMinZoomDistance" or p13 == "CameraMaxZoomDistance") and p12.activeCameraController then
        p12.activeCameraController:UpdateForDistancePropertyChange()
    end
end

function t1.OnUserGameSettingsPropertyChanged(p14, p15) -- line: 543
    if p15 == "ComputerCameraMovementMode" then
        p14:ActivateCameraController()
    end
end

function t1.OnPreferredInputChanged(p16) -- line: 549
    p16:ActivateCameraController()
end

function t1.Update(p17, _, p19) -- line: 559
    -- upvalues: VRService (copy), UserVRFixCameraCloseArticulation (copy), _FFlagUserOrthographicOcclusion (ref), VRFirstPersonState (copy)
    if p17.activeCameraController then
        p17.activeCameraController:UpdateMouseBehavior()

        local v12, v13 = p17.activeCameraController:Update(p19)

        if UserVRFixCameraCloseArticulation and VRService.VREnabled and p17.activeCameraController.IsInFirstPerson then
            VRFirstPersonState.inFirstPerson = p17.activeCameraController:IsInFirstPerson()
        end

        local CurrentCamera = game.Workspace.CurrentCamera

        if _FFlagUserOrthographicOcclusion then
            if p17.activeOcclusionModule and not p17.activeCameraController.skipOcclusion and CurrentCamera.ProjectionType ~= Enum.ProjectionType.Orthographic then
                v12, v13 = p17.activeOcclusionModule:Update(p19, v12, v13)
            end
        elseif p17.activeOcclusionModule and not p17.activeCameraController.skipOcclusion then
            v12, v13 = p17.activeOcclusionModule:Update(p19, v12, v13)
        end

        CurrentCamera.CFrame = v12
        CurrentCamera.Focus = v13

        if p17.activeTransparencyController then
            p17.activeTransparencyController:Update(p19)
        end
    elseif UserVRFixCameraCloseArticulation and VRService.VREnabled then
        VRFirstPersonState.inFirstPerson = false
    end
end

function t1.OnCharacterAdded(p20, p21, p22) -- line: 596
    if p20.activeOcclusionModule then
        p20.activeOcclusionModule:CharacterAdded(p21, p22)
    end
end

function t1.OnCharacterRemoving(p23, p24, p25) -- line: 602
    if p23.activeOcclusionModule then
        p23.activeOcclusionModule:CharacterRemoving(p24, p25)
    end
end

function t1.OnPlayerAdded(p26, p27) -- line: 608
    -- upvalues: UserPlayerConnectionMemoryLeak (copy)
    local connectionUtil

    if UserPlayerConnectionMemoryLeak then
        connectionUtil = p26.connectionUtil
    else
        p27.CharacterAdded:Connect(function(p28) -- line: 620
            -- upvalues: p26 (copy), p27 (copy)
            p26:OnCharacterAdded(p28, p27)
        end)
        p27.CharacterRemoving:Connect(function(p29) -- line: 623
            -- upvalues: p26 (copy), p27 (copy)
            p26:OnCharacterRemoving(p29, p27)
        end)
    end

    if (not UserPlayerConnectionMemoryLeak or connectionUtil) and UserPlayerConnectionMemoryLeak then
        p26.connectionUtil:trackConnection(("%*CharacterAdded"):format(p27.UserId), p27.CharacterAdded:Connect(function(p30) -- line: 612
            -- upvalues: p26 (copy), p27 (copy)
            p26:OnCharacterAdded(p30, p27)
        end))
        p26.connectionUtil:trackConnection(("%*CharacterRemoving"):format(p27.UserId), p27.CharacterRemoving:Connect(function(p31) -- line: 615
            -- upvalues: p26 (copy), p27 (copy)
            p26:OnCharacterRemoving(p31, p27)
        end))
    end
end

function t1.OnPlayerRemoving(p32, p33) -- line: 629
    if p32.connectionUtil then
        p32.connectionUtil:disconnect((("%*CharacterAdded"):format(p33.UserId)))
        p32.connectionUtil:disconnect((("%*CharacterRemoving"):format(p33.UserId)))
    end
end

function t1.OnMouseLockToggled(p34) -- line: 637
    if p34.activeMouseLockController then
        local IsMouseLocked = p34.activeMouseLockController:GetIsMouseLocked()
        local MouseLockOffset = p34.activeMouseLockController:GetMouseLockOffset()

        if p34.activeCameraController then
            p34.activeCameraController:SetIsMouseLocked(IsMouseLocked)
            p34.activeCameraController:SetMouseLockOffset(MouseLockOffset)
        end
    end
end

if RunService:IsClient() then
    return t1.new()
end

return t1

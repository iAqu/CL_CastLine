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

if Players.LocalPlayer then
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

    function t1.new() -- line: 144
        -- upvalues: t1 (copy), t2 (copy), t3 (copy), Players (copy), RunService (copy), UserInputService (copy), UserGameSettings (copy), ConnectionUtil (copy), TransparencyController (copy), MouseLockController (copy), UserPlayerConnectionMemoryLeak (copy)
        local v1 = setmetatable({
            activeTransparencyController = TransparencyController.new(),
            connectionUtil = if UserPlayerConnectionMemoryLeak then ConnectionUtil.new() else nil
        }, t1)

        v1.activeCameraController = nil
        v1.activeOcclusionModule = nil
        v1.activeMouseLockController = nil
        v1.currentComputerCameraMovementMode = nil
        v1.cameraSubjectChangedConn = nil
        v1.cameraTypeChangedConn = nil

        for _, player in pairs(Players:GetPlayers()) do
            v1:OnPlayerAdded(player)
        end

        Players.PlayerAdded:Connect(function(p1) -- line: 167
            -- upvalues: v1 (copy)
            v1:OnPlayerAdded(p1)
        end)

        if UserPlayerConnectionMemoryLeak then
            Players.PlayerRemoving:Connect(function(p2) -- line: 172
                -- upvalues: v1 (copy)
                v1:OnPlayerRemoving(p2)
            end)
        end

        v1.activeTransparencyController:Enable(true)
        v1.activeMouseLockController = MouseLockController.new()
        assert(v1.activeMouseLockController, "Strict typing check")

        local BindableToggleEvent = v1.activeMouseLockController:GetBindableToggleEvent()

        if BindableToggleEvent then
            BindableToggleEvent:Connect(function() -- line: 184
                -- upvalues: v1 (copy)
                v1:OnMouseLockToggled()
            end)
        end

        v1:ActivateCameraController()
        v1:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
        v1:OnCurrentCameraChanged()
        RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(p3) -- line: 192
            -- upvalues: v1 (copy)
            v1:Update(p3)
        end)

        for _, v2 in pairs(t2) do
            Players.LocalPlayer:GetPropertyChangedSignal(v2):Connect(function() -- line: 196
                -- upvalues: v1 (copy), v2 (copy)
                v1:OnLocalPlayerCameraPropertyChanged(v2)
            end)
        end

        for _, v3 in pairs(t3) do
            UserGameSettings:GetPropertyChangedSignal(v3):Connect(function() -- line: 202
                -- upvalues: v1 (copy), v3 (copy)
                v1:OnUserGameSettingsPropertyChanged(v3)
            end)
        end

        game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 206
            -- upvalues: v1 (copy)
            v1:OnCurrentCameraChanged()
        end)
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 209
            -- upvalues: v1 (copy)
            v1:OnPreferredInputChanged()
        end)

        return v1
    end

    function t1.GetCameraMovementModeFromSettings(_) -- line: 216
        -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), CameraUtils (copy)
        if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
            return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
        end

        local v4, v5

        if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            v4 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
            v5 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
        else
            v4 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
            v5 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
        end

        if v4 == Enum.DevComputerCameraMovementMode.UserChoice then
            return v5
        end

        return v4
    end

    function t1.ActivateOcclusionModule(p5, p6) -- line: 241
        -- upvalues: Players (copy), Invisicam (copy), Poppercam (copy), t5 (copy)
        local v6

        if p6 == Enum.DevCameraOcclusionMode.Zoom then
            v6 = Poppercam
        else
            if p6 ~= Enum.DevCameraOcclusionMode.Invisicam then
                warn("CameraScript ActivateOcclusionModule called with unsupported mode")

                return
            end

            v6 = Invisicam
        end

        p5.occlusionMode = p6

        if p5.activeOcclusionModule and p5.activeOcclusionModule:GetOcclusionMode() == p6 then
            if not p5.activeOcclusionModule:GetEnabled() then
                p5.activeOcclusionModule:Enable(true)
            end
        else
            local activeOcclusionModule = p5.activeOcclusionModule

            p5.activeOcclusionModule = t5[v6]

            if not p5.activeOcclusionModule then
                p5.activeOcclusionModule = v6.new()

                if p5.activeOcclusionModule then
                    t5[v6] = p5.activeOcclusionModule
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

    function t1.ShouldUseVehicleCamera(p7) -- line: 320
        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return false
        end

        local CameraType, CameraSubject = CurrentCamera.CameraType, CurrentCamera.CameraSubject
        local v7 = CameraType == Enum.CameraType.Custom or CameraType == Enum.CameraType.Follow
        local VehicleSeat = CameraSubject and CameraSubject:IsA("VehicleSeat") or false
        local v8 = p7.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam

        return VehicleSeat and v7 and v8
    end

    function t1.ActivateCameraController(p8) -- line: 336
        -- upvalues: VRService (copy), ClassicCamera (copy), OrbitalCamera (copy), LegacyCamera (copy), VehicleCamera (copy), VRCamera (copy), VRVehicleCamera (copy), t4 (copy), UserPSFixCameraControllerReset (copy)
        local CameraType = workspace.CurrentCamera.CameraType
        local CameraMovementModeFromSettings = p8:GetCameraMovementModeFromSettings()

        if CameraType == Enum.CameraType.Scriptable then
            if p8.activeCameraController then
                p8.activeCameraController:Enable(false)
                p8.activeCameraController = nil
            end
        else
            local v9

            if CameraType == Enum.CameraType.Custom then
                CameraMovementModeFromSettings = p8:GetCameraMovementModeFromSettings()
            elseif CameraType == Enum.CameraType.Track then
                CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Classic
            elseif CameraType == Enum.CameraType.Follow then
                CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Follow
            elseif CameraType == Enum.CameraType.Orbital then
                CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Orbital
            elseif CameraType ~= Enum.CameraType.Attach and CameraType ~= Enum.CameraType.Watch and CameraType ~= Enum.CameraType.Fixed then
                warn("CameraScript encountered an unhandled Camera.CameraType value: ", CameraType)
            else
                v9 = LegacyCamera
            end

            if not v9 then
                if VRService.VREnabled then
                    v9 = VRCamera
                elseif CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Classic and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Follow and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Default and CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.CameraToggle then
                    if CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Orbital then
                        warn("ActivateCameraController did not select a module.")

                        return
                    end

                    v9 = OrbitalCamera
                else
                    v9 = ClassicCamera
                end
            end

            if p8:ShouldUseVehicleCamera() then
                v9 = if VRService.VREnabled then VRVehicleCamera else VehicleCamera
            end

            local v10

            if t4[v9] then
                v10 = t4[v9]

                if UserPSFixCameraControllerReset then
                    if v10.Reset and p8.activeCameraController ~= v10 then
                        v10:Reset()
                    end
                elseif v10.Reset then
                    v10:Reset()
                end
            else
                v10 = v9.new()
                t4[v9] = v10
            end

            if p8.activeCameraController then
                if p8.activeCameraController == v10 then
                    if not p8.activeCameraController:GetEnabled() then
                        p8.activeCameraController:Enable(true)
                    end
                else
                    if v10.HandleSubjectDistance then
                        v10:HandleSubjectDistance(p8.activeCameraController)
                    end

                    p8.activeCameraController:Enable(false)
                    p8.activeCameraController = v10
                    p8.activeCameraController:Enable(true)
                end
            elseif v10 ~= nil then
                p8.activeCameraController = v10
                assert(p8.activeCameraController, "Strict typing check")
                p8.activeCameraController:Enable(true)
            end

            if p8.activeCameraController then
                p8.activeCameraController:SetCameraMovementMode(CameraMovementModeFromSettings)
                p8.activeCameraController:SetCameraType(CameraType)
            end
        end
    end

    function t1.OnCameraSubjectChanged(p9) -- line: 445
        local CurrentCamera = workspace.CurrentCamera
        local CameraSubject = if CurrentCamera then CurrentCamera.CameraSubject else nil

        if p9.activeTransparencyController then
            p9.activeTransparencyController:SetSubject(CameraSubject)
        end

        if p9.activeOcclusionModule then
            p9.activeOcclusionModule:OnCameraSubjectChanged(CameraSubject)
        end

        p9:ActivateCameraController()
    end

    function t1.OnCameraTypeChanged(p10, p11) -- line: 460
        -- upvalues: UserInputService (copy), CameraUtils (copy)
        if p11 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            CameraUtils.restoreMouseBehavior()
        end

        p10:ActivateCameraController()
    end

    function t1.OnCurrentCameraChanged(p12) -- line: 472
        local CurrentCamera = game.Workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        if p12.cameraSubjectChangedConn then
            p12.cameraSubjectChangedConn:Disconnect()
        end

        if p12.cameraTypeChangedConn then
            p12.cameraTypeChangedConn:Disconnect()
        end

        p12.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 484
            -- upvalues: p12 (copy)
            p12:OnCameraSubjectChanged()
        end)
        p12.cameraTypeChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- line: 488
            -- upvalues: p12 (copy), CurrentCamera (copy)
            p12:OnCameraTypeChanged(CurrentCamera.CameraType)
        end)
        p12:OnCameraSubjectChanged()
        p12:OnCameraTypeChanged(CurrentCamera.CameraType)
    end

    function t1.OnLocalPlayerCameraPropertyChanged(p13, p14) -- line: 496
        -- upvalues: Players (copy)
        if p14 == "CameraMode" then
            if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                    p13:ActivateCameraController()
                else
                    warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)
                end
            else
                if not p13.activeCameraController or p13.activeCameraController:GetModuleName() ~= "ClassicCamera" then
                    p13:ActivateCameraController()
                end

                if p13.activeCameraController then
                    p13.activeCameraController:UpdateForDistancePropertyChange()
                end
            end
        elseif p14 == "DevComputerCameraMode" or p14 == "DevTouchCameraMode" then
            p13:ActivateCameraController()
        elseif p14 == "DevCameraOcclusionMode" then
            p13:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
        elseif (p14 == "CameraMinZoomDistance" or p14 == "CameraMaxZoomDistance") and p13.activeCameraController then
            p13.activeCameraController:UpdateForDistancePropertyChange()
        end
    end

    function t1.OnUserGameSettingsPropertyChanged(p15, p16) -- line: 538
        if p16 == "ComputerCameraMovementMode" or p16 == "TouchCameraMovementMode" then
            p15:ActivateCameraController()
        end
    end

    function t1.OnPreferredInputChanged(p17) -- line: 544
        p17:ActivateCameraController()
    end

    function t1.Update(p18, p19) -- line: 554
        -- upvalues: CameraInput (copy)
        if p18.activeCameraController then
            p18.activeCameraController:UpdateMouseBehavior()

            local v11, v12 = p18.activeCameraController:Update(p19)

            if p18.activeOcclusionModule and not p18.activeCameraController.skipOcclusion then
                v11, v12 = p18.activeOcclusionModule:Update(p19, v11, v12)
            end

            local CurrentCamera = game.Workspace.CurrentCamera

            CurrentCamera.CFrame = v11
            CurrentCamera.Focus = v12

            if p18.activeTransparencyController then
                p18.activeTransparencyController:Update(p19)
            end

            if CameraInput.getInputEnabled() then
                CameraInput.resetInputForFrameEnd()
            end
        end
    end

    function t1.OnCharacterAdded(p20, p21, p22) -- line: 580
        if p20.activeOcclusionModule then
            p20.activeOcclusionModule:CharacterAdded(p21, p22)
        end
    end

    function t1.OnCharacterRemoving(p23, p24, p25) -- line: 586
        if p23.activeOcclusionModule then
            p23.activeOcclusionModule:CharacterRemoving(p24, p25)
        end
    end

    function t1.OnPlayerAdded(p26, p27) -- line: 592
        -- upvalues: UserPlayerConnectionMemoryLeak (copy)
        local connectionUtil

        if UserPlayerConnectionMemoryLeak then
            connectionUtil = p26.connectionUtil
        else
            p27.CharacterAdded:Connect(function(p28) -- line: 604
                -- upvalues: p26 (copy), p27 (copy)
                p26:OnCharacterAdded(p28, p27)
            end)
            p27.CharacterRemoving:Connect(function(p29) -- line: 607
                -- upvalues: p26 (copy), p27 (copy)
                p26:OnCharacterRemoving(p29, p27)
            end)
        end

        if (not UserPlayerConnectionMemoryLeak or connectionUtil) and UserPlayerConnectionMemoryLeak then
            p26.connectionUtil:trackConnection(("%*CharacterAdded"):format(p27.UserId), p27.CharacterAdded:Connect(function(p30) -- line: 596
                -- upvalues: p26 (copy), p27 (copy)
                p26:OnCharacterAdded(p30, p27)
            end))
            p26.connectionUtil:trackConnection(("%*CharacterRemoving"):format(p27.UserId), p27.CharacterRemoving:Connect(function(p31) -- line: 599
                -- upvalues: p26 (copy), p27 (copy)
                p26:OnCharacterRemoving(p31, p27)
            end))
        end
    end

    function t1.OnPlayerRemoving(p32, p33) -- line: 613
        if p32.connectionUtil then
            p32.connectionUtil:disconnect((("%*CharacterAdded"):format(p33.UserId)))
            p32.connectionUtil:disconnect((("%*CharacterRemoving"):format(p33.UserId)))
        end
    end

    function t1.OnMouseLockToggled(p34) -- line: 621
        if p34.activeMouseLockController then
            local IsMouseLocked = p34.activeMouseLockController:GetIsMouseLocked()
            local MouseLockOffset = p34.activeMouseLockController:GetMouseLockOffset()

            if p34.activeCameraController then
                p34.activeCameraController:SetIsMouseLocked(IsMouseLocked)
                p34.activeCameraController:SetMouseLockOffset(MouseLockOffset)
            end
        end
    end

    t1.new()
end

return {}

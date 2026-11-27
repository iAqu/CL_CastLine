-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("ContextActionService")

local UserInputService = game:GetService("UserInputService")

game:GetService("Players")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

game:GetService("VRService")

local GuiService = game:GetService("GuiService")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserPSTextboxResetCameraInput = FlagUtil.getUserFlag("UserPSTextboxResetCameraInput")
local UserPlayerScriptsSupportTVRemoteKeycodes = FlagUtil.getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
local CameraContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext")
local CameraRotationAction = CameraContext:WaitForChild("CameraRotationAction")
local CameraZoomAction = CameraContext:WaitForChild("CameraZoomAction")
local GamepadBinding = CameraRotationAction:WaitForChild("GamepadBinding")
local MicroGamepadBinding = if UserPlayerScriptsSupportTVRemoteKeycodes then CameraRotationAction:WaitForChild("MicroGamepadBinding") else nil
local MouseBinding = CameraRotationAction:WaitForChild("MouseBinding")
local TrackpadBinding = CameraRotationAction:WaitForChild("TrackpadBinding")
local CameraToggleAction = CameraContext:WaitForChild("CameraToggleAction")
local CameraPanActiveAction = CameraContext:WaitForChild("CameraPanActiveAction")
local n1 = 1

local function updateCameraYInvert() -- line: 38
    -- upvalues: UserGameSettings (copy), CameraRotationAction (copy), n1 (ref)
    local CameraYInvertValue = UserGameSettings:GetCameraYInvertValue()

    if CameraYInvertValue ~= n1 then
        n1 = CameraYInvertValue

        for _, child in CameraRotationAction:GetChildren() do
            if child:IsA("InputBinding") then
                local Vector2Scale = child.Vector2Scale

                child.Vector2Scale = Vector2.new(Vector2Scale.X, -Vector2Scale.Y)
            end
        end
    end
end

local function updateGamepadCameraSensitivity() -- line: 52
    -- upvalues: UserGameSettings (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy), GamepadBinding (copy), MicroGamepadBinding (copy)
    GamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity

    if UserPlayerScriptsSupportTVRemoteKeycodes and MicroGamepadBinding then
        MicroGamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity
    end
end

local function updateMouseCameraSensitivity() -- line: 59
    -- upvalues: UserGameSettings (copy), MouseBinding (copy), TrackpadBinding (copy)
    local MouseSensitivity = UserGameSettings.MouseSensitivity

    MouseBinding.Scale = MouseSensitivity
    TrackpadBinding.Scale = MouseSensitivity
end

UserGameSettings:GetPropertyChangedSignal("GamepadCameraSensitivity"):Connect(updateGamepadCameraSensitivity)
GamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity

if UserPlayerScriptsSupportTVRemoteKeycodes and MicroGamepadBinding then
    MicroGamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity
end

UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(updateMouseCameraSensitivity)

local MouseSensitivity = UserGameSettings.MouseSensitivity

MouseBinding.Scale = MouseSensitivity
TrackpadBinding.Scale = MouseSensitivity
updateCameraYInvert()

local function adjustTouchPitchSensitivity(p1) -- line: 75
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return p1
    end

    local v1 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

    if p1.Y * v1 >= 0 then
        return p1
    end

    local v2 = (1 - (math.abs(v1) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25

    return Vector2.new(1, v2) * p1
end

local t1 = {}
local n2 = 0

local function incPanInputCount() -- line: 106
    -- upvalues: n2 (ref)
    n2 = math.max(0, n2 + 1)
end

local function decPanInputCount() -- line: 110
    -- upvalues: n2 (ref)
    n2 = math.max(0, n2 - 1)
end

local function resetPanInputCount() -- line: 114
    -- upvalues: n2 (ref)
    n2 = 0
end

function t1.getRotationActivated() -- line: 118
    -- upvalues: CameraRotationAction (copy), n2 (ref)
    if n2 > 0 then
        return true
    end

    return CameraRotationAction:GetState().Magnitude > 0
end

function t1.getPanActivated() -- line: 123
    -- upvalues: n2 (ref)
    return n2 > 0
end

function t1.getRotation(p2) -- line: 127
    -- upvalues: UserInputService (copy), CameraRotationAction (copy), updateCameraYInvert (copy), adjustTouchPitchSensitivity (copy)
    updateCameraYInvert()

    local v5 = CameraRotationAction:GetState() * p2

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v5 = adjustTouchPitchSensitivity(v5)
    end

    return v5
end

function t1.getZoomDelta(p3) -- line: 136
    -- upvalues: CameraZoomAction (copy)
    return CameraZoomAction:GetState() * p3
end

CameraPanActiveAction.Pressed:Connect(incPanInputCount)
CameraPanActiveAction.Released:Connect(decPanInputCount)

local v6 = false

function t1.setInputEnabled(p4) -- line: 147
    -- upvalues: CameraRotationAction (copy), CameraZoomAction (copy), CameraPanActiveAction (copy), n2 (ref), v6 (ref)
    if v6 == p4 then
        return
    end

    v6 = p4
    n2 = 0

    if v6 then
        CameraZoomAction.Enabled = true
        CameraRotationAction.Enabled = true
        CameraPanActiveAction.Enabled = true
    else
        CameraZoomAction.Enabled = false
        CameraRotationAction.Enabled = false
        CameraPanActiveAction.Enabled = false
    end
end

function t1.getInputEnabled() -- line: 168
    -- upvalues: v6 (ref)
    return v6
end

UserInputService.WindowFocused:Connect(resetPanInputCount)
UserInputService.WindowFocusReleased:Connect(resetPanInputCount)
GuiService.MenuOpened:Connect(resetPanInputCount)

if UserPSTextboxResetCameraInput then
    UserInputService.TextBoxFocusReleased:Connect(resetPanInputCount)
end

local v7 = false
local v8 = false
local n3 = 0

function t1.getHoldPan() -- line: 187
    -- upvalues: v7 (ref)
    return v7
end

function t1.getTogglePan() -- line: 191
    -- upvalues: v8 (ref)
    return v8
end

function t1.getPanning() -- line: 195
    -- upvalues: v7 (ref), v8 (ref)
    return v8 or v7
end

function t1.setTogglePan(p5) -- line: 199
    -- upvalues: v8 (ref)
    v8 = p5
end

local v9 = false

CameraToggleAction.Pressed:Connect(function() -- line: 207
    -- upvalues: v7 (ref), n3 (ref)
    v7 = true
    n3 = tick()
end)
CameraToggleAction.Released:Connect(function() -- line: 212
    -- upvalues: UserInputService (copy), v7 (ref), v8 (ref), n3 (ref)
    v7 = false

    if tick() - n3 < 0.3 and (v8 or UserInputService:GetMouseDelta().Magnitude < 2) then
        v8 = not v8
    end
end)

function t1.enableCameraToggleInput() -- line: 219
    -- upvalues: CameraToggleAction (copy), v7 (ref), v8 (ref), v9 (ref)
    if v9 then
        return
    end

    v9 = true
    v7 = false
    v8 = false
    CameraToggleAction.Enabled = true
end

function t1.disableCameraToggleInput() -- line: 231
    -- upvalues: CameraToggleAction (copy), v9 (ref)
    if v9 then
        v9 = false
        CameraToggleAction.Enabled = false
    end
end

return t1

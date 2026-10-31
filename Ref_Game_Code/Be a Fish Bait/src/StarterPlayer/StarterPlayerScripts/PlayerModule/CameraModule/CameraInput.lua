-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

game:GetService("RunService")

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserPSSinkUnknownTouchEvents = FlagUtil.getUserFlag("UserPSSinkUnknownTouchEvents")
local UserPSTextboxResetCameraInput = FlagUtil.getUserFlag("UserPSTextboxResetCameraInput")
local UserFixVRCameraGamepadReset = FlagUtil.getUserFlag("UserFixVRCameraGamepadReset")
local UserPlayerScriptsSupportTVRemoteKeycodes = FlagUtil.getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
local LocalPlayer = Players.LocalPlayer
local Value = Enum.ContextActionPriority.Medium.Value
local v1 = Vector2.new(1, 0.77) * 0.06981317007977318 * 60
local v2 = Vector2.new(1, 0.77) * 0.008726646259971648
local v3 = Vector2.new(1, 0.77) * 0.12217304763960307
local v4 = Vector2.new(1, 0.66) * 0.017453292519943295
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")
local Event = BindableEvent.Event
local Event2 = BindableEvent2.Event

UserInputService.InputBegan:Connect(function(p1, p2) -- line: 46
    -- upvalues: BindableEvent (copy)
    if not p2 and p1.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire()
    end
end)
UserInputService.InputEnded:Connect(function(p3, _) -- line: 52
    -- upvalues: BindableEvent2 (copy)
    if p3.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent2:Fire()
    end
end)

local function thumbstickCurve(p5) -- line: 63
    local v6 = (math.exp((math.abs(p5) - 0.1) / 0.9 * 2) - 1) / 6.38905609893065

    return math.sign(p5) * math.clamp(v6, 0, 1)
end

local function adjustTouchPitchSensitivity(p6) -- line: 77
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return p6
    end

    local v7 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

    if p6.Y * v7 >= 0 then
        return p6
    end

    local v8 = (1 - (math.abs(v7) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25

    return Vector2.new(1, v8) * p6
end

local function isInDynamicThumbstickArea(p7) -- line: 103
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local TouchGui = PlayerGui and PlayerGui:FindFirstChild("TouchGui")
    local TouchControlFrame = TouchGui and TouchGui:FindFirstChild("TouchControlFrame")
    local DynamicThumbstickFrame = TouchControlFrame and TouchControlFrame:FindFirstChild("DynamicThumbstickFrame")

    if not DynamicThumbstickFrame or not TouchGui.Enabled then
        return false
    end

    local AbsolutePosition = DynamicThumbstickFrame.AbsolutePosition
    local v9 = AbsolutePosition + DynamicThumbstickFrame.AbsoluteSize

    if p7.X >= AbsolutePosition.X and p7.Y >= AbsolutePosition.Y and p7.X <= v9.X then
        return p7.Y <= v9.Y
    end

    return false
end

local t1 = {}
local t2 = {}
local n1 = 0

local function incPanInputCount() -- line: 133
    -- upvalues: n1 (ref)
    n1 = math.max(0, n1 + 1)
end

local function decPanInputCount() -- line: 137
    -- upvalues: n1 (ref)
    n1 = math.max(0, n1 - 1)
end

local function resetPanInputCount() -- line: 141
    -- upvalues: n1 (ref)
    n1 = 0
end

local t3 = {
    ButtonLeft = 0,
    ButtonRight = 0,
    Thumbstick2 = Vector2.new()
}
local t4 = {
    Left = 0,
    Right = 0,
    I = 0,
    O = 0
}
local t5 = {
    Wheel = 0,
    Pinch = 0,
    Movement = Vector2.new(),
    Pan = Vector2.new()
}
local t6 = {
    Pinch = 0,
    Move = Vector2.new()
}
local BindableEvent3 = Instance.new("BindableEvent")

t1.gamepadZoomPress = BindableEvent3.Event

local v12

if UserFixVRCameraGamepadReset then
    local BindableEvent = Instance.new("BindableEvent")

    v12 = BindableEvent
    t1.gamepadReset = BindableEvent.Event
else
    local v13 = VRService.VREnabled and Instance.new("BindableEvent") or nil

    v12 = v13

    if VRService.VREnabled then
        t1.gamepadReset = v13.Event
    end
end

function t1.getRotationActivated() -- line: 182
    -- upvalues: UserPlayerScriptsSupportTVRemoteKeycodes (copy), n1 (ref), t3 (copy)
    if UserPlayerScriptsSupportTVRemoteKeycodes then
        if n1 > 0 or t3.Thumbstick2.Magnitude > 0 then
            return true
        end

        return t3.ButtonRight - t3.ButtonLeft ~= 0
    end

    if n1 > 0 then
        return true
    end

    return t3.Thumbstick2.Magnitude > 0
end

function t1.getRotation(p8, p9) -- line: 192
    -- upvalues: UserGameSettings (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), adjustTouchPitchSensitivity (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
    local v14 = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
    local v15 = Vector2.new(t4.Right - t4.Left, 0) * p8
    local v16

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        local v17 = Vector2.new(t3.ButtonRight - t3.ButtonLeft, 0)

        v16 = (t3.Thumbstick2 + v17) * UserGameSettings.GamepadCameraSensitivity * p8
    else
        v16 = t3.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity * p8
    end

    local Movement, Pan = t5.Movement, t5.Pan
    local v18 = adjustTouchPitchSensitivity(t6.Move)

    if p9 then
        v15 = Vector2.new()
    end

    return (v15 * 2.0943951023931953 + v16 * v1 + Movement * v2 + Pan * v3 + v18 * v4) * v14
end

function t1.getZoomDelta() -- line: 223
    -- upvalues: t4 (copy), t5 (copy), t6 (copy)
    local v19 = t4.O - t4.I
    local v20 = -t5.Wheel + t5.Pinch
    local v21 = -t6.Pinch

    return v19 * 0.1 + v20 * 1 + v21 * 0.04
end

local function thumbstick(_, _, p12) -- line: 231
    -- upvalues: thumbstickCurve (copy), t3 (copy)
    local Position = p12.Position

    t3[p12.KeyCode.Name] = Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y))

    return Enum.ContextActionResult.Pass
end

local function directionalButtons(_, p14, p15) -- line: 237
    -- upvalues: thumbstickCurve (copy), t3 (copy)
    if p14 == Enum.UserInputState.Cancel then
        t3[p15.KeyCode.Name] = 0
    else
        t3[p15.KeyCode.Name] = thumbstickCurve(p15.Position.Z)
    end

    return Enum.ContextActionResult.Pass
end

local function mouseMovement(p16) -- line: 246
    -- upvalues: t5 (copy)
    local Delta = p16.Delta

    t5.Movement = Vector2.new(Delta.X, Delta.Y)
end

local function mouseWheel(_, _, p19) -- line: 251
    -- upvalues: t5 (copy)
    t5.Wheel = p19.Position.Z

    return Enum.ContextActionResult.Pass
end

local function keypress(_, p21, p22) -- line: 256
    -- upvalues: t4 (copy)
    t4[p22.KeyCode.Name] = p21 == Enum.UserInputState.Begin and 1 or 0
end

local function gamepadZoomPress(_, p24, _) -- line: 260
    -- upvalues: BindableEvent3 (copy)
    if p24 == Enum.UserInputState.Begin then
        BindableEvent3:Fire()
    end
end

local function gamepadReset(_, p27, _) -- line: 266
    -- upvalues: v12 (ref)
    if p27 == Enum.UserInputState.Begin then
        v12:Fire()
    end
end

local function resetInputDevices() -- line: 272
    -- upvalues: n1 (ref), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
    for _, v22 in pairs({ t3, t4, t5, t6 }) do
        for v23, v24 in pairs(v22) do
            if type(v24) == "boolean" then
                v22[v23] = false
            else
                v22[v23] *= 0
            end
        end
    end

    n1 = 0
end

local t7 = {}
local v25, Magnitude

local function touchBegan(p29, p30) -- line: 298
    -- upvalues: isInDynamicThumbstickArea (copy), n1 (ref), t7 (ref), v25 (ref)
    assert(p29.UserInputType == Enum.UserInputType.Touch)
    assert(p29.UserInputState == Enum.UserInputState.Begin)

    if v25 == nil and isInDynamicThumbstickArea(p29.Position) and not p30 then
        v25 = p29
    else
        if not p30 then
            n1 = math.max(0, n1 + 1)
        end

        local t8 = t7

        t8[p29] = p30
    end
end

local function touchEnded(p31, _) -- line: 318
    -- upvalues: n1 (ref), t7 (ref), v25 (ref), Magnitude (ref)
    assert(p31.UserInputType == Enum.UserInputType.Touch)
    assert(p31.UserInputState == Enum.UserInputState.End)

    if p31 == v25 then
        v25 = nil
    end

    if t7[p31] == false then
        Magnitude = nil
        n1 = math.max(0, n1 - 1)
    end

    local t9 = t7

    t9[p31] = nil
end

local function touchChanged(p33, p34) -- line: 337
    -- upvalues: UserPSSinkUnknownTouchEvents (copy), t6 (copy), t7 (ref), v25 (ref), Magnitude (ref)
    assert(p33.UserInputType == Enum.UserInputType.Touch)
    assert(p33.UserInputState == Enum.UserInputState.Change)

    if p33 == v25 then
        return
    end

    if t7[p33] == nil then
        if UserPSSinkUnknownTouchEvents then
            local t10 = t7

            t10[p33] = true
        else
            local t11 = t7

            t11[p33] = p34
        end
    end

    local t12 = {}

    for v34, v35 in pairs(t7) do
        if not v35 then
            table.insert(t12, v34)
        end
    end

    if #t12 == 1 and t7[p33] == false then
        local Delta = p33.Delta

        t6.Move += Vector2.new(Delta.X, Delta.Y)
    end

    if #t12 ~= 2 then
        Magnitude = nil

        return
    end

    local Magnitude2 = (t12[1].Position - t12[2].Position).Magnitude

    if Magnitude then
        t6.Pinch += Magnitude2 - Magnitude
    end

    Magnitude = Magnitude2
end

local function resetTouchState() -- line: 385
    -- upvalues: n1 (ref), t7 (ref), v25 (ref), Magnitude (ref)
    t7 = {}
    v25 = nil
    Magnitude = nil
    n1 = 0
end

local function pointerAction(p35, p36, p37, p38) -- line: 393
    -- upvalues: t5 (copy)
    if p38 then
        return
    end

    t5.Wheel = p35
    t5.Pan = p36
    t5.Pinch = -p37
end

local function inputBegan(p39, p40) -- line: 401
    -- upvalues: n1 (ref), touchBegan (copy)
    if p39.UserInputType == Enum.UserInputType.Touch then
        touchBegan(p39, p40)
    elseif p39.UserInputType == Enum.UserInputType.MouseButton2 and not p40 then
        n1 = math.max(0, n1 + 1)
    end
end

local function inputChanged(p41, p42) -- line: 410
    -- upvalues: t5 (copy), touchChanged (copy)
    if p41.UserInputType == Enum.UserInputType.Touch then
        touchChanged(p41, p42)
    elseif p41.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = p41.Delta

        t5.Movement = Vector2.new(Delta.X, Delta.Y)
    end
end

local function inputEnded(p43, p44) -- line: 419
    -- upvalues: n1 (ref), touchEnded (copy)
    if p43.UserInputType == Enum.UserInputType.Touch then
        touchEnded(p43, p44)
    elseif p43.UserInputType == Enum.UserInputType.MouseButton2 then
        n1 = math.max(0, n1 - 1)
    end
end

local v38 = false

function t1.setInputEnabled(p45) -- line: 430
    -- upvalues: ContextActionService (copy), UserInputService (copy), VRService (copy), GuiService (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy), Value (copy), t2 (ref), thumbstick (copy), directionalButtons (copy), keypress (copy), gamepadZoomPress (copy), gamepadReset (copy), resetInputDevices (copy), resetTouchState (copy), pointerAction (copy), inputBegan (copy), inputChanged (copy), inputEnded (copy), v38 (ref)
    if v38 == p45 then
        return
    end

    v38 = p45
    resetInputDevices()
    resetTouchState()

    if v38 then
        ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2)

        if UserPlayerScriptsSupportTVRemoteKeycodes then
            ContextActionService:BindActionAtPriority("RbxCameraDirectionalButtons", directionalButtons, false, Value, Enum.KeyCode.ButtonLeft, Enum.KeyCode.ButtonRight)
        end

        ContextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O)

        if VRService.VREnabled then
            ContextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3)
        end

        ContextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3)

        local t13 = t2

        table.insert(t13, UserInputService.InputBegan:Connect(inputBegan))

        local t14 = t2

        table.insert(t14, UserInputService.InputChanged:Connect(inputChanged))

        local t15 = t2

        table.insert(t15, UserInputService.InputEnded:Connect(inputEnded))

        local t16 = t2

        table.insert(t16, UserInputService.PointerAction:Connect(pointerAction))

        local t17 = t2

        table.insert(t17, GuiService.MenuOpened:connect(resetTouchState))
    else
        ContextActionService:UnbindAction("RbxCameraThumbstick")

        if UserPlayerScriptsSupportTVRemoteKeycodes then
            ContextActionService:UnbindAction("RbxCameraDirectionalButtons")
        end

        ContextActionService:UnbindAction("RbxCameraMouseMove")
        ContextActionService:UnbindAction("RbxCameraMouseWheel")
        ContextActionService:UnbindAction("RbxCameraKeypress")
        ContextActionService:UnbindAction("RbxCameraGamepadZoom")

        if VRService.VREnabled then
            ContextActionService:UnbindAction("RbxCameraGamepadReset")
        end

        for _, v39 in pairs(t2) do
            v39:Disconnect()
        end

        t2 = {}
    end
end

function t1.getInputEnabled() -- line: 513
    -- upvalues: v38 (ref)
    return v38
end

function t1.resetInputForFrameEnd() -- line: 517
    -- upvalues: t5 (copy), t6 (copy)
    t5.Movement = Vector2.new()
    t6.Move = Vector2.new()
    t6.Pinch = 0
    t5.Wheel = 0
    t5.Pan = Vector2.new()
    t5.Pinch = 0
end

UserInputService.WindowFocused:Connect(resetInputDevices)
UserInputService.WindowFocusReleased:Connect(resetInputDevices)

if UserPSTextboxResetCameraInput then
    UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
end

local v40 = false
local v41 = false
local n2 = 0

function t1.getHoldPan() -- line: 541
    -- upvalues: v40 (ref)
    return v40
end

function t1.getTogglePan() -- line: 545
    -- upvalues: v41 (ref)
    return v41
end

function t1.getPanning() -- line: 549
    -- upvalues: v40 (ref), v41 (ref)
    return v41 or v40
end

function t1.setTogglePan(p46) -- line: 553
    -- upvalues: v41 (ref)
    v41 = p46
end

local v42 = false
local connection, connection2

function t1.enableCameraToggleInput() -- line: 561
    -- upvalues: UserInputService (copy), Event (copy), Event2 (copy), v40 (ref), v41 (ref), n2 (ref), v42 (ref), connection (ref), connection2 (ref)
    if v42 then
        return
    end

    v42 = true
    v40 = false
    v41 = false

    if connection then
        connection:Disconnect()
    end

    if connection2 then
        connection2:Disconnect()
    end

    connection = Event:Connect(function() -- line: 578
        -- upvalues: v40 (ref), n2 (ref)
        v40 = true
        n2 = tick()
    end)
    connection2 = Event2:Connect(function() -- line: 583
        -- upvalues: UserInputService (copy), v40 (ref), v41 (ref), n2 (ref)
        v40 = false

        if tick() - n2 < 0.3 and (v41 or UserInputService:GetMouseDelta().Magnitude < 2) then
            v41 = not v41
        end
    end)
end

function t1.disableCameraToggleInput() -- line: 591
    -- upvalues: v42 (ref), connection (ref), connection2 (ref)
    if not v42 then
        return
    end

    v42 = false

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection2 then
        connection2:Disconnect()
        connection2 = nil
    end
end

return t1

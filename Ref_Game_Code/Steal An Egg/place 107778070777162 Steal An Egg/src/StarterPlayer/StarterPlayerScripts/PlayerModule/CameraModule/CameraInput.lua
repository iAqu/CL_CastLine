-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserCameraInputDt = FlagUtil.getUserFlag("UserCameraInputDt")
local UserPSSinkUnknownTouchEvents = FlagUtil.getUserFlag("UserPSSinkUnknownTouchEvents")
local UserPSTextboxResetCameraInput = FlagUtil.getUserFlag("UserPSTextboxResetCameraInput")
local LocalPlayer = Players.LocalPlayer
local Value = Enum.ContextActionPriority.Medium.Value
local v1 = Vector2.new(1, 0.77) * 0.06981317007977318
local v2 = v1
local v3 = Vector2.new(1, 0.77) * 0.008726646259971648
local v4 = Vector2.new(1, 0.77) * 0.12217304763960307
local v5 = Vector2.new(1, 0.66) * 0.017453292519943295

if UserCameraInputDt then
    v2 = v1 * 60
end

local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")
local Event = BindableEvent.Event
local Event2 = BindableEvent2.Event

UserInputService.InputBegan:Connect(function(p1, p2) -- line: 49
    -- upvalues: BindableEvent (copy)
    if not p2 and p1.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire()
    end
end)
UserInputService.InputEnded:Connect(function(p3, _) -- line: 55
    -- upvalues: BindableEvent2 (copy)
    if p3.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent2:Fire()
    end
end)

local function thumbstickCurve(p5) -- line: 66
    local v7 = (math.exp((math.abs(p5) - 0.1) / 0.9 * 2) - 1) / 6.38905609893065

    return math.sign(p5) * math.clamp(v7, 0, 1)
end

local function adjustTouchPitchSensitivity(p6) -- line: 80
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return p6
    end

    local v8 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

    if p6.Y * v8 >= 0 then
        return p6
    end

    local v9 = (1 - (math.abs(v8) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25

    return Vector2.new(1, v9) * p6
end

local function isInDynamicThumbstickArea(p7) -- line: 106
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local TouchGui = PlayerGui and PlayerGui:FindFirstChild("TouchGui")
    local TouchControlFrame = TouchGui and TouchGui:FindFirstChild("TouchControlFrame")
    local DynamicThumbstickFrame = TouchControlFrame and TouchControlFrame:FindFirstChild("DynamicThumbstickFrame")

    if not DynamicThumbstickFrame or not TouchGui.Enabled then
        return false
    end

    local AbsolutePosition = DynamicThumbstickFrame.AbsolutePosition
    local v10 = AbsolutePosition + DynamicThumbstickFrame.AbsoluteSize

    if p7.X >= AbsolutePosition.X and p7.Y >= AbsolutePosition.Y and p7.X <= v10.X then
        return p7.Y <= v10.Y
    end

    return false
end

local n1 = 0.016666666666666666

RunService.Stepped:Connect(function(_, p9) -- line: 131
    -- upvalues: n1 (ref)
    n1 = p9
end)

local t1 = {}
local t2 = {}
local n2 = 0

local function incPanInputCount() -- line: 141
    -- upvalues: n2 (ref)
    n2 = math.max(0, n2 + 1)
end

local function decPanInputCount() -- line: 145
    -- upvalues: n2 (ref)
    n2 = math.max(0, n2 - 1)
end

local function resetPanInputCount() -- line: 149
    -- upvalues: n2 (ref)
    n2 = 0
end

local t3 = {
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

local BindableEvent4 = VRService.VREnabled and Instance.new("BindableEvent") or nil

if VRService.VREnabled then
    t1.gamepadReset = BindableEvent4.Event
end

function t1.getRotationActivated() -- line: 182
    -- upvalues: n2 (ref), t3 (copy)
    if n2 > 0 then
        return true
    end

    return t3.Thumbstick2.Magnitude > 0
end

function t1.getRotation(p10, p11) -- line: 186
    -- upvalues: UserGameSettings (copy), UserCameraInputDt (copy), v2 (ref), v3 (copy), v4 (copy), v5 (copy), adjustTouchPitchSensitivity (copy), n1 (ref), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
    local v13 = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
    local v14 = if UserCameraInputDt then Vector2.new(t4.Right - t4.Left, 0) * p10 else Vector2.new(t4.Right - t4.Left, 0) * n1
    local v15 = t3.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity

    if UserCameraInputDt then
        v15 *= p10
    end

    local Movement, Pan = t5.Movement, t5.Pan
    local v16 = adjustTouchPitchSensitivity(t6.Move)

    if p11 then
        v14 = Vector2.new()
    end

    return (v14 * 2.0943951023931953 + v15 * v2 + Movement * v3 + Pan * v4 + v16 * v5) * v13
end

function t1.getZoomDelta() -- line: 220
    -- upvalues: t4 (copy), t5 (copy), t6 (copy)
    local v17 = t4.O - t4.I
    local v18 = -t5.Wheel + t5.Pinch
    local v19 = -t6.Pinch

    return v17 * 0.1 + v18 * 1 + v19 * 0.04
end

local function thumbstick(_, _, p14) -- line: 228
    -- upvalues: thumbstickCurve (copy), t3 (copy)
    local Position = p14.Position

    t3[p14.KeyCode.Name] = Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y))

    return Enum.ContextActionResult.Pass
end

local function mouseMovement(p15) -- line: 234
    -- upvalues: t5 (copy)
    local Delta = p15.Delta

    t5.Movement = Vector2.new(Delta.X, Delta.Y)
end

local function mouseWheel(_, _, p18) -- line: 239
    -- upvalues: t5 (copy)
    t5.Wheel = p18.Position.Z

    return Enum.ContextActionResult.Pass
end

local function keypress(_, p20, p21) -- line: 244
    -- upvalues: t4 (copy)
    t4[p21.KeyCode.Name] = p20 == Enum.UserInputState.Begin and 1 or 0
end

local function gamepadZoomPress(_, p23, _) -- line: 248
    -- upvalues: BindableEvent3 (copy)
    if p23 == Enum.UserInputState.Begin then
        BindableEvent3:Fire()
    end
end

local function gamepadReset(_, p26, _) -- line: 254
    -- upvalues: BindableEvent4 (copy)
    if p26 == Enum.UserInputState.Begin then
        BindableEvent4:Fire()
    end
end

local function resetInputDevices() -- line: 260
    -- upvalues: n2 (ref), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
    for _, v20 in pairs({ t3, t4, t5, t6 }) do
        for v21, v22 in pairs(v20) do
            if type(v22) == "boolean" then
                v20[v21] = false
            else
                v20[v21] *= 0
            end
        end
    end

    n2 = 0
end

local t7 = {}
local v23, Magnitude

local function touchBegan(p28, p29) -- line: 286
    -- upvalues: isInDynamicThumbstickArea (copy), n2 (ref), t7 (ref), v23 (ref)
    assert(p28.UserInputType == Enum.UserInputType.Touch)
    assert(p28.UserInputState == Enum.UserInputState.Begin)

    if v23 == nil and isInDynamicThumbstickArea(p28.Position) and not p29 then
        v23 = p28
    else
        if not p29 then
            n2 = math.max(0, n2 + 1)
        end

        local t8 = t7

        t8[p28] = p29
    end
end

local function touchEnded(p30, _) -- line: 306
    -- upvalues: n2 (ref), t7 (ref), v23 (ref), Magnitude (ref)
    assert(p30.UserInputType == Enum.UserInputType.Touch)
    assert(p30.UserInputState == Enum.UserInputState.End)

    if p30 == v23 then
        v23 = nil
    end

    if t7[p30] == false then
        Magnitude = nil
        n2 = math.max(0, n2 - 1)
    end

    local t9 = t7

    t9[p30] = nil
end

local function touchChanged(p32, p33) -- line: 325
    -- upvalues: UserPSSinkUnknownTouchEvents (copy), t6 (copy), t7 (ref), v23 (ref), Magnitude (ref)
    assert(p32.UserInputType == Enum.UserInputType.Touch)
    assert(p32.UserInputState == Enum.UserInputState.Change)

    if p32 == v23 then
        return
    end

    if t7[p32] == nil then
        if UserPSSinkUnknownTouchEvents then
            local t10 = t7

            t10[p32] = true
        else
            local t11 = t7

            t11[p32] = p33
        end
    end

    local t12 = {}

    for v32, v33 in pairs(t7) do
        if not v33 then
            table.insert(t12, v32)
        end
    end

    if #t12 == 1 and t7[p32] == false then
        local Delta = p32.Delta

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

local function resetTouchState() -- line: 373
    -- upvalues: n2 (ref), t7 (ref), v23 (ref), Magnitude (ref)
    t7 = {}
    v23 = nil
    Magnitude = nil
    n2 = 0
end

local function pointerAction(p34, p35, p36, p37) -- line: 381
    -- upvalues: t5 (copy)
    if p37 then
        return
    end

    t5.Wheel = p34
    t5.Pan = p35
    t5.Pinch = -p36
end

local function inputBegan(p38, p39) -- line: 389
    -- upvalues: n2 (ref), touchBegan (copy)
    if p38.UserInputType == Enum.UserInputType.Touch then
        touchBegan(p38, p39)
    elseif p38.UserInputType == Enum.UserInputType.MouseButton2 and not p39 then
        n2 = math.max(0, n2 + 1)
    end
end

local function inputChanged(p40, p41) -- line: 398
    -- upvalues: t5 (copy), touchChanged (copy)
    if p40.UserInputType == Enum.UserInputType.Touch then
        touchChanged(p40, p41)
    elseif p40.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = p40.Delta

        t5.Movement = Vector2.new(Delta.X, Delta.Y)
    end
end

local function inputEnded(p42, p43) -- line: 407
    -- upvalues: n2 (ref), touchEnded (copy)
    if p42.UserInputType == Enum.UserInputType.Touch then
        touchEnded(p42, p43)
    elseif p42.UserInputType == Enum.UserInputType.MouseButton2 then
        n2 = math.max(0, n2 - 1)
    end
end

local v36 = false

function t1.setInputEnabled(p44) -- line: 418
    -- upvalues: ContextActionService (copy), UserInputService (copy), VRService (copy), GuiService (copy), Value (copy), t2 (ref), thumbstick (copy), keypress (copy), gamepadZoomPress (copy), gamepadReset (copy), resetInputDevices (copy), resetTouchState (copy), pointerAction (copy), inputBegan (copy), inputChanged (copy), inputEnded (copy), v36 (ref)
    if v36 == p44 then
        return
    end

    v36 = p44
    resetInputDevices()
    resetTouchState()

    if v36 then
        ContextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value, Enum.KeyCode.Thumbstick2)
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
        ContextActionService:UnbindAction("RbxCameraMouseMove")
        ContextActionService:UnbindAction("RbxCameraMouseWheel")
        ContextActionService:UnbindAction("RbxCameraKeypress")
        ContextActionService:UnbindAction("RbxCameraGamepadZoom")

        if VRService.VREnabled then
            ContextActionService:UnbindAction("RbxCameraGamepadReset")
        end

        for _, v37 in pairs(t2) do
            v37:Disconnect()
        end

        t2 = {}
    end
end

function t1.getInputEnabled() -- line: 487
    -- upvalues: v36 (ref)
    return v36
end

function t1.resetInputForFrameEnd() -- line: 491
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

local v38 = false
local v39 = false
local n3 = 0

function t1.getHoldPan() -- line: 515
    -- upvalues: v38 (ref)
    return v38
end

function t1.getTogglePan() -- line: 519
    -- upvalues: v39 (ref)
    return v39
end

function t1.getPanning() -- line: 523
    -- upvalues: v38 (ref), v39 (ref)
    return v39 or v38
end

function t1.setTogglePan(p45) -- line: 527
    -- upvalues: v39 (ref)
    v39 = p45
end

local v40 = false
local connection, connection2

function t1.enableCameraToggleInput() -- line: 535
    -- upvalues: UserInputService (copy), Event (copy), Event2 (copy), v38 (ref), v39 (ref), n3 (ref), v40 (ref), connection (ref), connection2 (ref)
    if v40 then
        return
    end

    v40 = true
    v38 = false
    v39 = false

    if connection then
        connection:Disconnect()
    end

    if connection2 then
        connection2:Disconnect()
    end

    connection = Event:Connect(function() -- line: 552
        -- upvalues: v38 (ref), n3 (ref)
        v38 = true
        n3 = tick()
    end)
    connection2 = Event2:Connect(function() -- line: 557
        -- upvalues: UserInputService (copy), v38 (ref), v39 (ref), n3 (ref)
        v38 = false

        if tick() - n3 < 0.3 and (v39 or UserInputService:GetMouseDelta().Magnitude < 2) then
            v39 = not v39
        end
    end)
end

function t1.disableCameraToggleInput() -- line: 565
    -- upvalues: v40 (ref), connection (ref), connection2 (ref)
    if not v40 then
        return
    end

    v40 = false

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

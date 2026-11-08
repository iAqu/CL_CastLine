-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op, PointerKind, PointerState = Observability.Op, Observability.PointerKind, Observability.PointerState
local t1 = {
    [Enum.KeyCode.Thumbstick1] = true,
    [Enum.KeyCode.Thumbstick2] = true,
    [Enum.KeyCode.Unknown] = true
}
local t2 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
}

local function insetArea(p1) -- line: 53
    -- upvalues: GuiService (copy)
    local GetInsetArea = GuiService.GetInsetArea
    local ok, result = pcall(GetInsetArea, GuiService, p1)

    return if ok then result else nil
end

local t3 = {}

t3.__index = t3

function t3.new(p2) -- line: 61
    -- upvalues: GuiService (copy), UserInputService (copy), PointerKind (copy), PointerState (copy), t2 (copy), t3 (copy)
    local v1 = setmetatable({
        NextTouchId = 1,
        Selected = nil,
        SelectedDirty = false,
        LastViewport = "",
        Origin = nil,
        LastVirtualCursor = nil,
        Clock = p2,
        Events = {},
        Keys = {},
        Held = {},
        LastMove = {},
        PendingMove = {},
        TouchIds = setmetatable({}, {
            __mode = "k"
        }),
        Connections = {}
    }, t3)

    local function connect(p3, p4) -- line: 81
        -- upvalues: v1 (copy)
        table.insert(v1.Connections, p3:Connect(p4))
    end

    local InputBegan = UserInputService.InputBegan

    local function v2(p5) -- line: 85
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy), t2 (copy)
        local UserInputType = p5.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.MouseButton2 then
            if UserInputType == Enum.UserInputType.Keyboard or t2[UserInputType] then
                v1:_key(p5.KeyCode, true)
            end
        else
            v1:_pointer(PointerKind.Mouse, UserInputType == Enum.UserInputType.MouseButton1 and 1 or 2, PointerState.Down, nil)
        end
    end

    table.insert(v1.Connections, InputBegan:Connect(v2))

    local InputEnded = UserInputService.InputEnded

    local function v4(p6) -- line: 93
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy), t2 (copy)
        local UserInputType = p6.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.MouseButton2 then
            if UserInputType == Enum.UserInputType.Keyboard or t2[UserInputType] then
                v1:_key(p6.KeyCode, false)
            end
        else
            v1:_pointer(PointerKind.Mouse, UserInputType == Enum.UserInputType.MouseButton1 and 1 or 2, PointerState.Up, nil)
        end
    end

    table.insert(v1.Connections, InputEnded:Connect(v4))

    local WindowFocusReleased = UserInputService.WindowFocusReleased

    local function v6() -- line: 102
        -- upvalues: v1 (copy)
        v1:_releaseHeld()
    end

    table.insert(v1.Connections, WindowFocusReleased:Connect(v6))

    local InputChanged = UserInputService.InputChanged

    local function v7(p7) -- line: 105
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy)
        if p7.UserInputType == Enum.UserInputType.MouseMovement then
            v1:_pointer(PointerKind.Mouse, 0, PointerState.Move, nil)
        end
    end

    table.insert(v1.Connections, InputChanged:Connect(v7))

    local TouchStarted = UserInputService.TouchStarted

    local function v8(p8) -- line: 110
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy)
        local NextTouchId = v1.NextTouchId

        v1.NextTouchId = NextTouchId % 255 + 1
        v1.TouchIds[p8] = NextTouchId
        v1:_pointer(PointerKind.Touch, NextTouchId, PointerState.Down, p8.Position)
    end

    table.insert(v1.Connections, TouchStarted:Connect(v8))

    local TouchMoved = UserInputService.TouchMoved

    local function v9(p9) -- line: 116
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy)
        local v10 = v1.TouchIds[p9]

        if v10 then
            v1:_pointer(PointerKind.Touch, v10, PointerState.Move, p9.Position)
        end
    end

    table.insert(v1.Connections, TouchMoved:Connect(v9))

    local TouchEnded = UserInputService.TouchEnded

    local function v11(p10) -- line: 122
        -- upvalues: v1 (copy), PointerKind (copy), PointerState (copy)
        local v12 = v1.TouchIds[p10]

        if v12 then
            v1.TouchIds[p10] = nil
            v1:_pointer(PointerKind.Touch, v12, PointerState.Up, p10.Position)
        end
    end

    table.insert(v1.Connections, TouchEnded:Connect(v11))

    local SelectedObject = GuiService:GetPropertyChangedSignal("SelectedObject")

    local function v13() -- line: 129
        -- upvalues: v1 (copy), GuiService (copy)
        v1.Selected = GuiService.SelectedObject
        v1.SelectedDirty = true
    end

    table.insert(v1.Connections, SelectedObject:Connect(v13))

    return v1
end

function t3._pointer(p11, p12, p13, p14, p15) -- line: 138
    -- upvalues: GuiService (copy), UserInputService (copy), PointerState (copy)
    local v14 = p11.Clock()
    local v15, v16

    if p15 then
        local v17 = p11.Origin or GuiService:GetGuiInset()

        v15 = p15.X + v17.X
        v16 = p15.Y + v17.Y
    else
        local MouseLocation = UserInputService:GetMouseLocation()

        v15 = MouseLocation.X
        v16 = MouseLocation.Y
    end

    local t7 = {
        Ms = v14,
        Kind = p12,
        PointerId = p13,
        State = p14,
        X = v15,
        Y = v16
    }
    local v18 = ("%*:%*"):format(p12, p13)

    if p14 == PointerState.Move then
        local v19 = p11.LastMove[v18]

        if v19 and v14 - v19 < 33.333333333333336 then
            p11.PendingMove[v18] = t7

            return
        end

        p11.LastMove[v18] = v14
    end

    p11.PendingMove[v18] = nil
    table.insert(p11.Events, t7)
end

function t3._key(p16, p17, p18) -- line: 163
    -- upvalues: UserInputService (copy), t1 (copy)
    if t1[p17] then
        return
    end

    local Value = p17.Value

    if p18 then
        if p16.Held[Value] or UserInputService:GetFocusedTextBox() then
            return
        end

        p16.Held[Value] = true
    else
        if not p16.Held[Value] then
            return
        end

        p16.Held[Value] = nil
    end

    table.insert(p16.Keys, {
        Ms = p16.Clock(),
        Code = Value,
        Down = p18
    })
end

function t3._releaseHeld(p19) -- line: 182
    local v20 = p19.Clock()

    for v21 in p19.Held do
        table.insert(p19.Keys, {
            Down = false,
            Ms = v20,
            Code = v21
        })
    end

    table.clear(p19.Held)
end

function t3._sampleVirtualCursor(p20) -- line: 190
    -- upvalues: UserInputService (copy), PointerKind (copy), PointerState (copy), t2 (copy)
    if not t2[UserInputService:GetLastInputType()] then
        p20.LastVirtualCursor = nil

        return
    end

    local MouseLocation = UserInputService:GetMouseLocation()

    if p20.LastVirtualCursor ~= MouseLocation then
        p20.LastVirtualCursor = MouseLocation
        table.insert(p20.Events, {
            PointerId = 0,
            Ms = p20.Clock(),
            Kind = PointerKind.VirtualCursor,
            State = PointerState.Move,
            X = MouseLocation.X,
            Y = MouseLocation.Y
        })
    end
end

function t3.WriteViewport(p21, p22, p23) -- line: 210
    -- upvalues: GuiService (copy), Codec (copy), Op (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local GuiInset, GuiInset2 = GuiService:GetGuiInset()
    local None = Enum.ScreenInsets.None
    local GetInsetArea = GuiService.GetInsetArea
    local ok, result = pcall(GetInsetArea, GuiService, None)

    if not ok then
        result = nil
    end

    local DeviceSafeInsets = Enum.ScreenInsets.DeviceSafeInsets
    local GetInsetArea2 = GuiService.GetInsetArea
    local ok2, result2 = pcall(GetInsetArea2, GuiService, DeviceSafeInsets)

    if not ok2 then
        result2 = nil
    end

    local TopbarSafeInsets = Enum.ScreenInsets.TopbarSafeInsets
    local GetInsetArea3 = GuiService.GetInsetArea
    local ok3, result3 = pcall(GetInsetArea3, GuiService, TopbarSafeInsets)

    if not ok3 then
        result3 = nil
    end

    local t11 = if result and result2 and result3 then {
        result2.Min.X - result.Min.X,
        result2.Min.Y - result.Min.Y,
        result.Max.X - result2.Max.X,
        result.Max.Y - result2.Max.Y,
        result3.Min.X - result2.Min.X,
        result3.Min.Y - result2.Min.Y,
        result2.Max.X - result3.Max.X,
        result2.Max.Y - result3.Max.Y
    } else nil

    if result then
        p21.Origin = -result.Min
    else
        p21.Origin = nil
    end

    local v22 = ("%*,%*,%*,%*,%*,%*"):format(ViewportSize.X, ViewportSize.Y, GuiInset.X, GuiInset.Y, GuiInset2.X, GuiInset2.Y) .. (if t11 then "," .. table.concat(t11, ",") else "")

    if not p23 and v22 == p21.LastViewport then
        return
    end

    p21.LastViewport = v22

    local W = p22.W

    W:u8(Op.Viewport)
    W:u16((math.clamp(math.round(ViewportSize.X), 0, 65535)))
    W:u16((math.clamp(math.round(ViewportSize.Y), 0, 65535)))
    Codec.i16(W, GuiInset.X)
    Codec.i16(W, GuiInset.Y)
    Codec.i16(W, GuiInset2.X)
    Codec.i16(W, GuiInset2.Y)
    p22:EndRecord()

    if t11 then
        W:u8(Op.SafeArea)

        for _, v25 in t11 do
            Codec.i16(W, v25)
        end

        p22:EndRecord()
    end
end

function t3.Flush(p24, p25, p26) -- line: 258
    -- upvalues: Codec (copy), Op (copy)
    p24:_sampleVirtualCursor()

    local Events = p24.Events

    p24.Events = {}

    for v26, v27 in p24.PendingMove do
        p24.LastMove[v26] = v27.Ms
        table.insert(Events, v27)
    end

    table.clear(p24.PendingMove)

    for _, v28 in Events do
        p25:Time(v28.Ms)

        local W = p25.W

        W:u8(Op.Pointer)
        W:u8(v28.Kind)
        W:u8(v28.PointerId)
        W:u8(v28.State)
        Codec.i16(W, v28.X)
        Codec.i16(W, v28.Y)
        p25:EndRecord()
    end

    local Keys = p24.Keys

    if #Keys > 0 then
        p24.Keys = {}

        for _, v29 in Keys do
            p25:Time(v29.Ms)

            local W = p25.W

            W:u8(if v29.Down then Op.KeyDown else Op.KeyUp)
            Codec.varuint(W, v29.Code)
            p25:EndRecord()
        end
    end

    p25:Time(p24.Clock())
    p24:WriteViewport(p25)

    if p24.SelectedDirty then
        p24.SelectedDirty = false

        local v30 = p26(p24.Selected)
        local W = p25.W

        W:u8(Op.Selected)
        Codec.varuint(W, if v30 then v30 + 1 else 0)
        p25:EndRecord()
    end
end

function t3.Destroy(p27) -- line: 301
    for _, v31 in p27.Connections do
        v31:Disconnect()
    end

    table.clear(p27.Connections)
    p27.Events = {}
    p27.Keys = {}
    table.clear(p27.Held)
    p27.Selected = nil
end

return t3

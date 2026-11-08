-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local t1 = {}

t1.__index = t1

local v1

local function toGuiPosition(p1, p2) -- line: 14
    local ScreenGui = p1:FindFirstAncestorWhichIsA("ScreenGui")

    return p2 + (if ScreenGui then ScreenGui.AbsolutePosition else Vector2.zero)
end

local function disconnectAll(p3) -- line: 20
    for _, v2 in p3 do
        v2:Disconnect()
    end

    table.clear(p3)
end

local function isVisible(p4) -- line: 27
    while true do
        if not p4 then
            return false
        end

        if not p4:IsA("GuiObject") or p4.Visible then
            if p4:IsA("ScreenGui") then
                return p4.Enabled
            end

            p4 = p4.Parent
            continue
        end

        break
    end

    return false
end

local function inheritedScale(p5) -- line: 40
    local n1 = 1
    local v4 = p5

    while v4 and v4:IsA("GuiObject") do
        for _, child in v4:GetChildren() do
            if child:IsA("UIScale") then
                n1 *= child.Scale
            end
        end

        v4 = v4.Parent
    end

    return (math.max(n1, 0.001))
end

function t1.new(p6, p7) -- line: 54
    -- upvalues: t1 (copy)
    local v5 = setmetatable({
        Gesture = nil,
        SuppressActivationUntil = 0,
        DetectorHandledActivation = false,
        Destroyed = false,
        Button = p6,
        Options = p7,
        Connections = {},
        GestureConnections = {}
    }, t1)
    local UIDragDetector = Instance.new("UIDragDetector")

    UIDragDetector.Name = "SlotDragDetector"
    UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane
    UIDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
    UIDragDetector.Enabled = false
    UIDragDetector.Parent = p6
    v5.Detector = UIDragDetector
    table.insert(v5.Connections, UIDragDetector.DragStart:Connect(function(p8) -- line: 76
        -- upvalues: p6 (copy), v5 (copy)
        local ScreenGui = p6:FindFirstAncestorWhichIsA("ScreenGui")

        v5:_begin(p8 + (if ScreenGui then ScreenGui.AbsolutePosition else Vector2.zero))
    end))
    table.insert(v5.Connections, UIDragDetector.DragContinue:Connect(function(p9) -- line: 82
        -- upvalues: p6 (copy), v5 (copy)
        local ScreenGui = p6:FindFirstAncestorWhichIsA("ScreenGui")

        v5:_continue(p9 + (if ScreenGui then ScreenGui.AbsolutePosition else Vector2.zero))
    end))
    table.insert(v5.Connections, UIDragDetector.DragEnd:Connect(function(p10) -- line: 88
        -- upvalues: p6 (copy), v5 (copy)
        local ScreenGui = p6:FindFirstAncestorWhichIsA("ScreenGui")

        v5:_finish(p10 + (if ScreenGui then ScreenGui.AbsolutePosition else Vector2.zero), false)
    end))
    table.insert(v5.Connections, p6.InputBegan:Connect(function(p11) -- line: 94
        -- upvalues: v5 (copy), UIDragDetector (copy)
        if v5.Gesture and v5.InputConnection or p11.UserInputType ~= Enum.UserInputType.MouseButton1 and p11.UserInputType ~= Enum.UserInputType.Touch and p11.KeyCode ~= Enum.KeyCode.ButtonA then
            return
        end

        v5.DetectorHandledActivation = false

        if UIDragDetector.Enabled then
            if v5.InputConnection then
                v5.InputConnection:Disconnect()
            end

            v5.InputConnection = p11:GetPropertyChangedSignal("UserInputState"):Connect(function() -- line: 112
                -- upvalues: p11 (copy), v5 (copy)
                if p11.UserInputState == Enum.UserInputState.Cancel then
                    v5:Cancel()
                elseif p11.UserInputState == Enum.UserInputState.End and v5.InputConnection then
                    v5.InputConnection:Disconnect()
                    v5.InputConnection = nil
                end
            end)
        end
    end))
    table.insert(v5.Connections, p6.Destroying:Connect(function() -- line: 130
        -- upvalues: v5 (copy)
        v5:Destroy()
    end))

    return v5
end

function t1.SetEnabled(p12, p13) -- line: 137
    if not p12.Destroyed then
        if not p13 then
            p12:Cancel()
        end

        p12.Detector.Enabled = p13
    end
end

function t1.IsActivationSuppressed(p14) -- line: 147
    local Gesture = p14.Gesture

    if os.clock() < p14.SuppressActivationUntil then
        return true
    end

    return Gesture ~= nil and Gesture.Mode ~= "pending"
end

function t1.ShouldHandleNativeActivation(p15) -- line: 153
    if p15.Gesture == nil then
        return not p15:IsActivationSuppressed() and not p15.DetectorHandledActivation
    end

    return false
end

function t1._begin(p16, p17) -- line: 162
    -- upvalues: GuiService (copy), UserInputService (copy), v1 (ref), isVisible (copy)
    local LastInputType, v14, v15

    if p16.Destroyed or p16.Gesture or v1 then
        v15 = true
    elseif p16.Detector.Enabled and isVisible(p16.Button) and p16.Options.CanStart() then
        p16.DetectorHandledActivation = false
        LastInputType = UserInputService:GetLastInputType()
        v14 = LastInputType == Enum.UserInputType.Touch
        v15 = false
    else
        v15 = true
    end

    if v15 then
        return
    end

    local ScrollingFrame = if v14 then p16.Options.ScrollingFrame else nil

    if ScrollingFrame and not p16.Button:IsDescendantOf(ScrollingFrame) then
        ScrollingFrame = nil
    end

    local t3 = {
        Mode = "pending",
        StartPosition = p17,
        LastPosition = p17,
        Touch = v14,
        InputType = LastInputType,
        Scroller = ScrollingFrame
    }

    if ScrollingFrame then
        t3.CanvasPosition = ScrollingFrame.CanvasPosition
        t3.ScrollingEnabled = ScrollingFrame.ScrollingEnabled
    else
        t3.CanvasPosition = nil
        t3.ScrollingEnabled = nil
    end

    p16.Gesture = t3
    v1 = p16

    if ScrollingFrame then
        ScrollingFrame.ScrollingEnabled = false
    end

    local function cancel() -- line: 200
        -- upvalues: p16 (copy)
        p16:Cancel()
    end

    table.insert(p16.GestureConnections, UserInputService.WindowFocusReleased:Connect(cancel))
    table.insert(p16.GestureConnections, GuiService.MenuOpened:Connect(cancel))
    table.insert(p16.GestureConnections, p16.Button.AncestryChanged:Connect(cancel))

    local v16 = p16.Button

    while true do
        if v16 then
            if v16:IsA("GuiObject") then
                table.insert(p16.GestureConnections, v16:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 217
                    -- upvalues: p16 (copy), isVisible (copy)
                    if not isVisible(p16.Button) then
                        p16:Cancel()
                    end
                end))
            elseif not not v16:IsA("ScreenGui") then
                break
            end

            v16 = v16.Parent
            continue
        end

        return
    end

    table.insert(p16.GestureConnections, v16:GetPropertyChangedSignal("Enabled"):Connect(cancel))
end

function t1._createPreview(p18, p19) -- line: 234
    -- upvalues: inheritedScale (copy)
    local Button = p18.Button
    local ScreenGui = Button:FindFirstAncestorWhichIsA("ScreenGui")

    if not ScreenGui then
        return false
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "BackpackDragPreview"
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Active = false
    Frame.ZIndex = 100
    Frame.Parent = ScreenGui
    p19.PreviewLayer = Frame

    local clone = Button:Clone()
    local Descendants = clone:GetDescendants()

    table.insert(Descendants, clone)

    for _, v18 in Descendants do
        if v18:IsA("UIDragDetector") or v18:IsA("LuaSourceContainer") then
            v18:Destroy()
        else
            for _, v19 in v18:GetTags() do
                v18:RemoveTag(v19)
            end

            if v18:IsA("GuiObject") then
                v18.Active = false
                v18.Selectable = false
                v18.Interactable = false
            end
        end
    end

    for _, child in clone:GetChildren() do
        if child:IsA("UIScale") then
            child:Destroy()
        elseif child:IsA("UIAspectRatioConstraint") then
            child:Destroy()
        elseif child:IsA("UISizeConstraint") then
            child:Destroy()
        end
    end

    local v20 = inheritedScale(Button)
    local UIScale = Instance.new("UIScale")

    UIScale.Scale = v20
    UIScale.Parent = clone
    clone.Name = "Item"
    clone.AnchorPoint = Vector2.zero
    clone.Position = UDim2.fromOffset(0, 0)
    clone.Size = UDim2.fromOffset(Button.AbsoluteSize.X / v20, Button.AbsoluteSize.Y / v20)
    clone.AutomaticSize = Enum.AutomaticSize.None
    clone.Rotation = Button.AbsoluteRotation
    clone.ZIndex = 100
    clone.Visible = true

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Position"
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromOffset(0, 0)
    Frame2.ZIndex = 100
    Frame2.Parent = Frame
    clone.Parent = Frame2
    p19.PreviewHolder = Frame2
    p19.PreviewOrigin = Button.AbsolutePosition

    return true
end

function t1._continue(p20, p21) -- line: 307
    -- upvalues: isVisible (copy)
    local Gesture = p20.Gesture

    if Gesture then
        Gesture.LastPosition = p21

        if not (p20.Options.CanStart() and isVisible(p20.Button)) then
            p20:Cancel()
        else
            local v21 = p21 - Gesture.StartPosition

            if Gesture.Mode == "pending" then
                if (if Gesture.Touch then 12 else 8) > v21.Magnitude then
                    return
                end

                if not not (Gesture.Scroller and Gesture.ScrollingEnabled and math.abs(v21.Y) >= math.abs(v21.X)) then
                    Gesture.Mode = "scrolling"
                else
                    Gesture.Mode = "dragging"
                    p20.Options.OnDragStart()

                    if p20.Gesture ~= Gesture then
                        return
                    end

                    if not p20:_createPreview(Gesture) then
                        p20:Cancel()

                        return
                    end
                end
            end

            if Gesture.Mode == "scrolling" then
                local Scroller = Gesture.Scroller
                local v25 = math.max(0, Scroller.AbsoluteCanvasSize.Y - Scroller.AbsoluteWindowSize.Y)

                Scroller.CanvasPosition = Vector2.new(Gesture.CanvasPosition.X, (math.clamp(Gesture.CanvasPosition.Y - v21.Y, 0, v25)))
            elseif Gesture.Mode == "dragging" then
                local v27 = Gesture.PreviewOrigin + v21 - Gesture.PreviewLayer.AbsolutePosition

                Gesture.PreviewHolder.Position = UDim2.fromOffset(v27.X, v27.Y)
            end
        end
    end
end

function t1._finish(p22, p23, p24) -- line: 361
    -- upvalues: v1 (ref), isVisible (copy)
    local Gesture = p22.Gesture

    if not Gesture then
        return
    end

    p24 = p24 or not p22.Options.CanStart() or not isVisible(p22.Button)
    p22.Gesture = nil

    if v1 == p22 then
        v1 = nil
    end

    local GestureConnections = p22.GestureConnections

    for _, v29 in GestureConnections do
        v29:Disconnect()
    end

    table.clear(GestureConnections)

    if p22.InputConnection then
        p22.InputConnection:Disconnect()
        p22.InputConnection = nil
    end

    if Gesture.PreviewLayer then
        Gesture.PreviewLayer:Destroy()
    end

    if Gesture.Scroller and Gesture.Scroller.Parent then
        Gesture.Scroller.ScrollingEnabled = Gesture.ScrollingEnabled
    end

    if p24 or Gesture.Mode ~= "pending" then
        p22.SuppressActivationUntil = os.clock() + 0.2
    end

    if Gesture.Mode == "dragging" then
        p22.Options.OnDragEnd(p23, p24)
    elseif Gesture.Mode == "pending" and not p24 and p22.Options.CanStart() and isVisible(p22.Button) then
        local AbsolutePosition = p22.Button.AbsolutePosition
        local v30 = AbsolutePosition + p22.Button.AbsoluteSize

        if p23.X >= AbsolutePosition.X and p23.Y >= AbsolutePosition.Y and p23.X <= v30.X and p23.Y <= v30.Y then
            p22.DetectorHandledActivation = true
            p22.Options.OnActivate(Gesture.InputType)
        end
    end
end

function t1.Cancel(p25) -- line: 412
    local Gesture = p25.Gesture

    if Gesture then
        p25:_finish(Gesture.LastPosition, true)
    end
end

function t1.Destroy(p26) -- line: 419
    if p26.Destroyed then
        return
    end

    p26.Destroyed = true
    p26:Cancel()

    local Connections = p26.Connections

    for _, v31 in Connections do
        v31:Disconnect()
    end

    table.clear(Connections)

    if p26.InputConnection then
        p26.InputConnection:Disconnect()
        p26.InputConnection = nil
    end

    p26.Detector:Destroy()
end

return t1

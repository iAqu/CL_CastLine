-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local t1 = {
    Force = nil,
    BackPresses = 0
}
local BindableEvent = Instance.new("BindableEvent")

t1.Changed = BindableEvent.Event

local function isPad(p1) -- line: 24
    return string.sub(p1.Name, 1, 7) == "Gamepad"
end

local v1 = string.sub(UserInputService:GetLastInputType().Name, 1, 7) == "Gamepad"

function t1.Using() -- line: 29
    -- upvalues: t1 (copy), v1 (ref)
    if t1.Force == nil then
        return v1
    end

    return t1.Force
end

UserInputService.LastInputTypeChanged:Connect(function(p2) -- line: 36
    -- upvalues: t1 (copy), BindableEvent (copy), v1 (ref)
    local Name = p2.Name
    local v2 = false

    if string.sub(Name, 1, 7) == "Gamepad" then
        v2 = true
    elseif p2 ~= Enum.UserInputType.Keyboard and p2 ~= Enum.UserInputType.Touch and string.sub(p2.Name, 1, 5) ~= "Mouse" then
        return
    end

    if v2 ~= v1 then
        v1 = v2
        BindableEvent:Fire(t1.Using())
    end
end)

function t1.SetForce(p3) -- line: 52
    -- upvalues: t1 (copy), BindableEvent (copy)
    t1.Force = p3
    BindableEvent:Fire(t1.Using())
end

local t2 = {}

local function showIcon(p4, p5) -- line: 59
    -- upvalues: UserInputService (copy)
    if p5 and p4.img.Image == "" then
        p4.img.Image = UserInputService:GetImageForKeyCode(p4.key)
    end

    p4.img.Visible = p5 and p4.img.Image ~= ""
end

function t1.Icon(p6, p7, p8) -- line: 66
    -- upvalues: UserInputService (copy), t1 (copy), t2 (copy)
    p8 = p8 or {}

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Pad" .. p7.Name
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = p8.Size or UDim2.fromOffset(44, 44)
    ImageLabel.Position = p8.Position or UDim2.new()
    ImageLabel.AnchorPoint = p8.AnchorPoint or Vector2.zero
    ImageLabel.ZIndex = p8.ZIndex or 5
    ImageLabel.Image = UserInputService:GetImageForKeyCode(p7)
    ImageLabel.Parent = p6

    local t3 = {
        img = ImageLabel,
        key = p7
    }

    table.insert(t2, t3)

    local v4 = t1.Using()

    if v4 and t3.img.Image == "" then
        t3.img.Image = UserInputService:GetImageForKeyCode(t3.key)
    end

    t3.img.Visible = v4 and t3.img.Image ~= ""

    return ImageLabel
end

function t1.IconBeside(p9, p10, p11) -- line: 83
    -- upvalues: t1 (copy)
    p11 = p11 or 40

    local v6 = t1.Icon(p9, p10, {
        Size = UDim2.fromOffset(p11, p11),
        AnchorPoint = Vector2.new(1, 0.5),
        ZIndex = p9.ZIndex + 1
    })

    local function totalScale() -- line: 88
        -- upvalues: p9 (copy)
        local n1 = 1
        local v7 = p9

        while v7 do
            local UIScale = v7:FindFirstChildOfClass("UIScale")

            if UIScale then
                n1 *= UIScale.Scale
            end

            if v7:IsA("LayerCollector") then
                break
            end

            v7 = v7.Parent
        end

        return (math.max(n1, 0.01))
    end

    local function place() -- line: 103
        -- upvalues: p9 (copy), v6 (copy), totalScale (copy)
        local v8 = p9.TextBounds.X / totalScale()
        local v9 = if p9.TextXAlignment == Enum.TextXAlignment.Left then 0 elseif p9.TextXAlignment == Enum.TextXAlignment.Right then 1 else 0.5
        local v10 = if v9 == 0.5 then -v8 / 2 elseif v9 == 1 then -v8 else 0

        v6.Position = UDim2.new(v9, v10 - 8, 0.5, 0)
    end

    p9:GetPropertyChangedSignal("TextBounds"):Connect(place)
    place()

    return v6
end

BindableEvent.Event:Connect(function(p12) -- line: 114
    -- upvalues: UserInputService (copy), t2 (copy)
    for i = #t2, 1, -1 do
        local v11 = t2[i]

        if v11.img.Parent ~= nil then
            if p12 and v11.img.Image == "" then
                v11.img.Image = UserInputService:GetImageForKeyCode(v11.key)
            end

            v11.img.Visible = p12 and v11.img.Image ~= ""
        else
            table.remove(t2, i)
        end
    end
end)

function t1.SelectIn(p13, p14) -- line: 126
    -- upvalues: GuiService (copy), t1 (copy)
    if not t1.Using() then
        return
    end

    local function v12() -- line: 130
        -- upvalues: p13 (copy), GuiService (copy)
        GuiService:Select(p13)
    end

    pcall(v12)

    local SelectedObject = GuiService.SelectedObject

    if not (SelectedObject and SelectedObject:IsDescendantOf(p13)) and p14 then
        GuiService.SelectedObject = p14
    end
end

function t1.Select(p15) -- line: 139
    -- upvalues: GuiService (copy), t1 (copy)
    if p15 and t1.Using() then
        GuiService.SelectedObject = p15
    end
end

function t1.Deselect(p16) -- line: 145
    -- upvalues: GuiService (copy)
    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and (p16 == nil or SelectedObject == p16 or SelectedObject:IsDescendantOf(p16)) then
        GuiService.SelectedObject = nil
    end
end

local t4 = {}

local function onBack(_, p18) -- line: 155
    -- upvalues: t1 (copy), t4 (copy)
    if p18 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    local v13 = t4[#t4]

    if not v13 then
        return Enum.ContextActionResult.Pass
    end

    t1.BackPresses += 1
    task.spawn(v13.fn)

    return Enum.ContextActionResult.Sink
end

function t1.PopBack(p19) -- line: 168
    -- upvalues: ContextActionService (copy), t4 (copy)
    for i = #t4, 1, -1 do
        if t4[i].name == p19 then
            table.remove(t4, i)
        end
    end

    if #t4 == 0 then
        ContextActionService:UnbindAction("PadBack")
    end
end

function t1.PushBack(p20, p21) -- line: 179
    -- upvalues: ContextActionService (copy), t1 (copy), t4 (copy), onBack (copy)
    t1.PopBack(p20)
    table.insert(t4, {
        name = p20,
        fn = p21
    })

    if #t4 == 1 then
        ContextActionService:BindActionAtPriority("PadBack", onBack, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonB)
    end
end

function t1.Slider(p22, p23) -- line: 200
    -- upvalues: GuiService (copy), UserInputService (copy), RunService (copy)
    local t6 = {
        dragging = false,
        hit = nil
    }
    local v14 = p23.hit or Vector2.new(30, 24)
    local AnchorPoint = p22.AnchorPoint
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p22.Name .. "Grab"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.AnchorPoint = AnchorPoint
    TextButton.Size = UDim2.new(p22.Size.X.Scale, p22.Size.X.Offset + v14.X * 2, p22.Size.Y.Scale, p22.Size.Y.Offset + v14.Y * 2)
    TextButton.Position = UDim2.new(p22.Position.X.Scale, p22.Position.X.Offset + v14.X * (2 * AnchorPoint.X - 1), p22.Position.Y.Scale, p22.Position.Y.Offset + v14.Y * (2 * AnchorPoint.Y - 1))
    TextButton.ZIndex = p22.ZIndex + 10
    TextButton.Parent = p22.Parent
    t6.hit = TextButton

    local function fromX(p24) -- line: 217
        -- upvalues: p22 (copy), p23 (copy)
        local v16 = (p24 - p22.AbsolutePosition.X) / math.max(p22.AbsoluteSize.X, 1)

        p23.set(math.clamp(v16, 0, 1), false)
    end

    local v17 = nil

    TextButton.InputBegan:Connect(function(p25) -- line: 222
        -- upvalues: p22 (copy), p23 (copy), t6 (copy), v17 (ref)
        local UserInputType = p25.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch or t6.dragging then
            return
        end

        t6.dragging = true
        v17 = p25

        if p23.grab then
            p23.grab()
        end

        local v19 = (p25.Position.X - p22.AbsolutePosition.X) / math.max(p22.AbsoluteSize.X, 1)

        p23.set(math.clamp(v19, 0, 1), false)

        local connection

        connection = p25.Changed:Connect(function() -- line: 234
            -- upvalues: p25 (copy), connection (ref), p23 (copy), t6 (copy), v17 (ref)
            if p25.UserInputState ~= Enum.UserInputState.End and p25.UserInputState ~= Enum.UserInputState.Cancel then
                return
            end

            connection:Disconnect()

            if v17 ~= p25 then
                return
            end

            v17 = nil
            t6.dragging = false
            p23.done()
        end)
    end)
    UserInputService.InputChanged:Connect(function(p26) -- line: 245
        -- upvalues: p22 (copy), p23 (copy), t6 (copy), v17 (ref)
        if not t6.dragging or not v17 then
            return
        end

        if v17.UserInputType == Enum.UserInputType.MouseButton1 and p26.UserInputType == Enum.UserInputType.MouseMovement then
            local v21 = (p26.Position.X - p22.AbsolutePosition.X) / math.max(p22.AbsoluteSize.X, 1)

            p23.set(math.clamp(v21, 0, 1), false)
        else
            local v22 = v17

            if p26 == v22 then
                local v24 = (p26.Position.X - p22.AbsolutePosition.X) / math.max(p22.AbsoluteSize.X, 1)

                p23.set(math.clamp(v24, 0, 1), false)
            end
        end
    end)
    p22.Selectable = true
    p22.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    p22.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

    local v25 = p23.step or 0.025
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local elapsed

    local function selected() -- line: 261
        -- upvalues: p22 (copy), GuiService (copy)
        return GuiService.SelectedObject == p22
    end

    function t6.Nudge(p27) -- line: 264
        -- upvalues: p23 (copy), v25 (copy), elapsed (ref)
        if p23.nudge then
            p23.nudge(p27)
        else
            p23.set(math.clamp(p23.get() + p27 * v25, 0, 1), true)
        end

        elapsed = os.clock()
    end

    UserInputService.InputBegan:Connect(function(p28) -- line: 273
        -- upvalues: p22 (copy), p23 (copy), v25 (copy), n2 (ref), n3 (ref), elapsed (ref), GuiService (copy)
        if GuiService.SelectedObject ~= p22 then
            return
        end

        local v27 = if p28.KeyCode == Enum.KeyCode.DPadLeft then -1 elseif p28.KeyCode == Enum.KeyCode.DPadRight then 1 else 0

        if v27 ~= 0 then
            n2 = v27
            n3 = os.clock() + 0.35

            if p23.nudge then
                p23.nudge(v27)
            else
                p23.set(math.clamp(p23.get() + v27 * v25, 0, 1), true)
            end

            elapsed = os.clock()
        end
    end)
    UserInputService.InputEnded:Connect(function(p29) -- line: 284
        -- upvalues: n2 (ref)
        if p29.KeyCode == Enum.KeyCode.DPadLeft and n2 < 0 or p29.KeyCode == Enum.KeyCode.DPadRight and n2 > 0 then
            n2 = 0
        end
    end)
    UserInputService.InputChanged:Connect(function(p30) -- line: 289
        -- upvalues: n4 (ref)
        if p30.KeyCode == Enum.KeyCode.Thumbstick1 then
            n4 = p30.Position.X
        end
    end)

    local n5 = 0

    RunService.Heartbeat:Connect(function(p31) -- line: 295
        -- upvalues: p22 (copy), p23 (copy), v25 (copy), n2 (ref), n3 (ref), n4 (ref), elapsed (ref), n5 (ref), GuiService (copy)
        if GuiService.SelectedObject == p22 then
            if n2 ~= 0 and os.clock() >= n3 then
                n3 = os.clock() + 0.07

                local v31 = n2

                if p23.nudge then
                    p23.nudge(v31)
                else
                    p23.set(math.clamp(p23.get() + v31 * v25, 0, 1), true)
                end

                elapsed = os.clock()
            end

            local v33 = n4

            if math.abs(v33) > 0.3 then
                n5 += (math.abs(v33) - 0.3) / 0.7 * p31 * 40 * v25

                while n5 >= v25 do
                    n5 -= v25

                    local v35 = if v33 > 0 then 1 else -1

                    if p23.nudge then
                        p23.nudge(v35)
                    else
                        p23.set(math.clamp(p23.get() + v35 * v25, 0, 1), true)
                    end

                    elapsed = os.clock()
                end
            else
                n5 = 0
            end
        else
            n2 = 0
        end

        if elapsed and n2 == 0 and (math.abs(n4) <= 0.3 or GuiService.SelectedObject ~= p22) and os.clock() - elapsed > 0.45 then
            elapsed = nil
            p23.done()
        end
    end)

    return t6
end

return t1

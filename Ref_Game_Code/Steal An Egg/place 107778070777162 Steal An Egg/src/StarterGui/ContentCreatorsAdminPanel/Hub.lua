-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local v1 = Color3.fromRGB(112, 255, 24)
local v2 = Color3.fromRGB(68, 68, 86)
local v3 = Color3.fromRGB(85, 85, 105)
local v4 = Color3.fromRGB(207, 208, 223)
local v5 = Color3.fromRGB(255, 153, 116)
local v6 = Color3.fromRGB(114, 114, 135)
local v7 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v8 = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v9 = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v10 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t1 = {
    Colors = table.freeze({
        Accent = v1,
        Idle = v2,
        Off = v3,
        Muted = v4,
        Warning = v5,
        Danger = Color3.fromRGB(255, 50, 50)
    })
}

local function tween(p1, p2, p3) -- line: 28
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, p2, p3)

    tween:Play()

    return tween
end

local self = setmetatable({}, {
    __mode = "k"
})

local function bindCaption(p4) -- line: 36
    -- upvalues: self (copy)
    if p4:IsA("TextButton") and not self[p4] then
        local Caption = p4:FindFirstChild("Caption")

        if Caption and Caption:IsA("TextLabel") then
            self[p4] = true

            local function sync() -- line: 45
                -- upvalues: p4 (copy), Caption (copy)
                Caption.Text = p4.Text
                Caption.TextSize = if p4.Text == "X" then 30 else p4.TextSize
                Caption.TextColor3 = p4.TextColor3
                Caption.TextXAlignment = p4.TextXAlignment
                Caption.TextWrapped = p4.TextWrapped
            end

            for _, v13 in { "Text", "TextSize", "TextColor3", "TextXAlignment", "TextWrapped" } do
                p4:GetPropertyChangedSignal(v13):Connect(sync)
            end

            Caption.Text = p4.Text
            Caption.TextSize = if p4.Text == "X" then 30 else p4.TextSize
            Caption.TextColor3 = p4.TextColor3
            Caption.TextXAlignment = p4.TextXAlignment
            Caption.TextWrapped = p4.TextWrapped
        end
    end
end

function t1.BindCaptions(p5) -- line: 59
    -- upvalues: bindCaption (copy)
    for _, descendant in p5:GetDescendants() do
        bindCaption(descendant)
    end

    p5.DescendantAdded:Connect(bindCaption)
end

local self2 = setmetatable({}, {
    __mode = "k"
})
local t6 = {
    Resize = true,
    Track = true,
    Expand = true
}

local function spring(p6) -- line: 69
    -- upvalues: TweenService (copy), v7 (copy), v9 (copy), self2 (copy), t6 (copy)
    if not p6:IsA("GuiButton") or self2[p6] or t6[p6.Name] then
        return
    end

    self2[p6] = true

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Spring"
    UIScale.Parent = p6

    local v16 = false

    local function settle() -- line: 78
        -- upvalues: UIScale (copy), v16 (ref), TweenService (copy), v9 (copy)
        TweenService:Create(UIScale, v9, {
            Scale = v16 and 1.03 or 1
        }):Play()
    end

    p6.MouseEnter:Connect(function() -- line: 81
        -- upvalues: UIScale (copy), v16 (ref), TweenService (copy), v9 (copy)
        v16 = true
        TweenService:Create(UIScale, v9, {
            Scale = v16 and 1.03 or 1
        }):Play()
    end)
    p6.MouseLeave:Connect(function() -- line: 85
        -- upvalues: UIScale (copy), v16 (ref), TweenService (copy), v9 (copy)
        v16 = false
        TweenService:Create(UIScale, v9, {
            Scale = v16 and 1.03 or 1
        }):Play()
    end)
    p6.SelectionGained:Connect(function() -- line: 89
        -- upvalues: UIScale (copy), v16 (ref), TweenService (copy), v9 (copy)
        v16 = true
        TweenService:Create(UIScale, v9, {
            Scale = v16 and 1.03 or 1
        }):Play()
    end)
    p6.SelectionLost:Connect(function() -- line: 93
        -- upvalues: UIScale (copy), v16 (ref), TweenService (copy), v9 (copy)
        v16 = false
        TweenService:Create(UIScale, v9, {
            Scale = v16 and 1.03 or 1
        }):Play()
    end)
    p6.MouseButton1Down:Connect(function() -- line: 97
        -- upvalues: UIScale (copy), TweenService (copy), v7 (copy)
        TweenService:Create(UIScale, v7, {
            Scale = 0.95
        }):Play()
    end)
    p6.MouseButton1Up:Connect(settle)
    p6.Activated:Connect(settle)
end

local function flash(p7) -- line: 104
    -- upvalues: TweenService (copy), v1 (copy)
    if not (p7 and p7:IsA("UIStroke")) then
        return
    end

    local Color = p7.Color

    p7.Color = v1
    TweenService:Create(p7, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = Color
    }):Play()
end

local function lift(p8, p9) -- line: 113
    p8.ZIndex += p9

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex += p9
        end
    end
end

local function pressed(p10) -- line: 122
    if p10.UserInputType == Enum.UserInputType.MouseButton1 then
        return true
    end

    return p10.UserInputType == Enum.UserInputType.Touch
end

local function track(p11, p12, p13, p14) -- line: 127
    -- upvalues: UserInputService (copy)
    p11.InputBegan:Connect(function(p15) -- line: 133
        -- upvalues: p12 (copy), p13 (copy), p14 (copy), UserInputService (copy)
        if not ((p15.UserInputType == Enum.UserInputType.MouseButton1 or p15.UserInputType == Enum.UserInputType.Touch) and p12(p15)) then
            return
        end

        local Position = p15.Position
        local connection = UserInputService.InputChanged:Connect(function(p16) -- line: 138
            -- upvalues: p15 (copy), Position (copy), p13 (copy)
            if p16 == p15 or p16.UserInputType == Enum.UserInputType.MouseMovement then
                p13(p16, Vector2.new(p16.Position.X - Position.X, p16.Position.Y - Position.Y))
            end
        end)
        local connection2

        connection2 = p15.Changed:Connect(function() -- line: 150
            -- upvalues: p15 (copy), connection (copy), connection2 (ref), p14 (copy)
            if p15.UserInputState ~= Enum.UserInputState.End then
                return
            end

            connection:Disconnect()
            connection2:Disconnect()

            if p14 then
                p14()
            end
        end)
    end)
end

local t14 = {}

t14.__index = t14

function t14.Usable(p17) -- line: 164
    return not p17.Locked and not p17.Owner.Locked
end

function t14.SetLocked(p18, p19) -- line: 167
    p18.Locked = p19
    p18:Paint()
end

function t14.SetVisible(p20, p21) -- line: 171
    p20.Instance.Visible = p21
end

function t14.Paint(_) -- line: 174
end

local t15 = {}

t15.__index = t15

function t15._add(p23, p24, p25) -- line: 179
    -- upvalues: lift (copy)
    p23.Count += 1
    p24.LayoutOrder = p23.Count
    lift(p24, 3)
    p24.Visible = true
    p24.Parent = p23.Holder

    if p25 then
        p25.Instance = p24
        p25.Owner = p23
        table.insert(p23.Elements, p25)
        p25:Paint()
    end

    return p25
end

function t15.Section(p26, p27) -- line: 194
    -- upvalues: t14 (copy)
    local clone = p26.Kit.Section:Clone()

    clone.Text = string.upper(p27)

    return p26:_add(clone, (setmetatable({
        Locked = false
    }, t14)))
end

function t15.Paragraph(p28, p29) -- line: 200
    -- upvalues: t14 (copy)
    local clone = p28.Kit.Paragraph:Clone()

    clone.Text = p29

    local v18 = setmetatable({
        Locked = false
    }, t14)

    function v18.Set(_, p31) -- line: 204
        -- upvalues: clone (copy)
        clone.Text = p31
    end

    return p28:_add(clone, v18)
end

function t15.Button(p32, p33) -- line: 210
    -- upvalues: TweenService (copy), v3 (copy), v7 (copy), t14 (copy)
    local clone = p32.Kit[(p33.Style or "Primary") .. "Button"]:Clone()

    clone.Text = p33.Title
    clone.TextSize = 16
    clone.Size = UDim2.new(1, 0, 0, 44)

    local v19 = setmetatable({
        Locked = false,
        Base = clone.BackgroundColor3
    }, t14)

    function v19.Paint(p34) -- line: 216
        -- upvalues: clone (copy), TweenService (copy), v3 (copy), v7 (copy)
        local v20 = p34:Usable()

        TweenService:Create(clone, v7, {
            BackgroundColor3 = if v20 then p34.Base else v3
        }):Play()
        clone.AutoButtonColor = v20
    end

    function v19.SetTitle(_, p36) -- line: 221
        -- upvalues: clone (copy)
        clone.Text = p36
    end

    function v19.SetStyle(p37, p38) -- line: 224
        -- upvalues: p32 (copy)
        p37.Base = p32.Kit[p38 .. "Button"].BackgroundColor3
        p37:Paint()
    end

    clone.Activated:Connect(function() -- line: 228
        -- upvalues: p33 (copy), v19 (copy)
        if v19:Usable() and p33.Callback then
            p33.Callback()
        end
    end)

    return p32:_add(clone, v19)
end

function t15.Toggle(p39, p40) -- line: 237
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy), v8 (copy), v9 (copy), t14 (copy)
    local clone = p39.Kit.Toggle:Clone()

    clone.Label.Text = p40.Title

    local Switch = clone.Switch
    local v21 = setmetatable({
        Locked = false,
        Value = p40.Default == true
    }, t14)

    function v21.Paint(p41) -- line: 242
        -- upvalues: Switch (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy), v8 (copy), v9 (copy)
        TweenService:Create(Switch, v8, {
            BackgroundColor3 = if not p41:Usable() then v3 elseif p41.Value then v1 else v2
        }):Play()
        TweenService:Create(Switch.Knob, v9, {
            Position = if p41.Value then UDim2.new(1, -35, 0.5, -14) else UDim2.new(0, 5, 0.5, -14)
        }):Play()
    end

    function v21.Set(p42, p43) -- line: 255
        if p42.Value ~= p43 then
            p42.Value = p43
            p42:Paint()
        end
    end

    function v21.SetTitle(_, p45) -- line: 261
        -- upvalues: clone (copy)
        clone.Label.Text = p45
    end

    Switch.Activated:Connect(function() -- line: 264
        -- upvalues: p40 (copy), v21 (copy)
        if v21:Usable() then
            local v22 = not v21.Value

            if not p40.Callback or p40.Callback(v22) ~= false then
                v21:Set(v22)
            end
        end
    end)

    return p39:_add(clone, v21)
end

function t15.Input(p46, p47) -- line: 277
    -- upvalues: TweenService (copy), v1 (copy), v7 (copy), v8 (copy), t14 (copy)
    local clone = p46.Kit.Input:Clone()

    clone.Label.Text = p47.Title

    local Box = clone.Box

    Box.PlaceholderText = p47.Placeholder or ""
    Box.Text = if p47.Default == nil then "" else tostring(p47.Default)

    local v24 = setmetatable({
        Locked = false
    }, t14)

    local function read() -- line: 284
        -- upvalues: p47 (copy), Box (copy), v24 (copy)
        v24.Value = if p47.Numeric then tonumber(Box.Text) else Box.Text
    end

    v24.Value = if p47.Numeric then tonumber(Box.Text) else Box.Text

    function v24.Paint(p48) -- line: 288
        -- upvalues: Box (copy), TweenService (copy), v7 (copy)
        Box.TextEditable = p48:Usable()
        TweenService:Create(Box, v7, {
            TextTransparency = p48:Usable() and 0 or 0.6
        }):Play()
    end

    function v24.Set(_, p50) -- line: 292
        -- upvalues: Box (copy)
        Box.Text = if p50 == nil then "" else tostring(p50)
    end

    function v24.SetTitle(_, p52) -- line: 295
        -- upvalues: clone (copy)
        clone.Label.Text = p52
    end

    Box.Focused:Connect(function() -- line: 298
        -- upvalues: Box (copy), TweenService (copy), v1 (copy), v7 (copy)
        TweenService:Create(Box.Stroke, v7, {
            Color = v1
        }):Play()
    end)
    Box:GetPropertyChangedSignal("Text"):Connect(function() -- line: 301
        -- upvalues: p47 (copy), Box (copy), v24 (copy)
        v24.Value = if p47.Numeric then tonumber(Box.Text) else Box.Text

        if p47.Changed then
            p47.Changed(v24.Value)
        end
    end)
    Box.FocusLost:Connect(function(p53) -- line: 307
        -- upvalues: p46 (copy), p47 (copy), Box (copy), v24 (copy), TweenService (copy), v8 (copy)
        TweenService:Create(Box.Stroke, v8, {
            Color = p46.Kit.Input.Box.Stroke.Color
        }):Play()

        if p53 and p47.Callback and v24:Usable() then
            p47.Callback(v24.Value)
        end
    end)

    return p46:_add(clone, v24)
end

function t15.Slider(p54, p55) -- line: 317
    -- upvalues: TweenService (copy), UserInputService (copy), v1 (copy), v3 (copy), v7 (copy), v8 (copy), v9 (copy), t14 (copy)
    local clone = p54.Kit.Slider:Clone()

    clone.Label.Text = p55.Title

    local Track = clone.Track
    local Min, Max = p55.Min, p55.Max
    local v29 = p55.Step or 1
    local v30 = setmetatable({
        Locked = false,
        Value = Min
    }, t14)
    local v31 = false

    function v30.Set(p56, p57) -- line: 325
        -- upvalues: p55 (copy), clone (copy), Track (copy), Min (copy), Max (copy), v29 (copy), v31 (ref), TweenService (copy), v7 (copy), v8 (copy)
        p56.Value = math.clamp(math.round(p57 / v29) * v29, Min, Max)

        local v34 = (p56.Value - Min) / (Max - Min)
        local v35 = if v31 then v7 else v8

        TweenService:Create(Track.Fill, v35, {
            Size = UDim2.new(v34, 0, 1, 0)
        }):Play()
        TweenService:Create(Track.Knob, v35, {
            Position = UDim2.new(v34, 0, 0.5, 0)
        }):Play()
        clone.Value.Text = string.format("%g", p56.Value) .. (p55.Suffix or "")
    end

    function v30.Paint(p58) -- line: 333
        -- upvalues: Track (copy), TweenService (copy), v1 (copy), v3 (copy), v7 (copy)
        TweenService:Create(Track.Fill, v7, {
            BackgroundColor3 = if p58:Usable() then v1 else v3
        }):Play()
    end

    function v30.SetTitle(_, p60) -- line: 336
        -- upvalues: clone (copy)
        clone.Label.Text = p60
    end

    v30:Set(p55.Default or Min)

    local function at(p61) -- line: 340
        -- upvalues: p55 (copy), Track (copy), Min (copy), Max (copy), v30 (copy)
        local v37 = math.clamp((p61 - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)

        v30:Set(Min + (Max - Min) * v37)

        if p55.Changed then
            p55.Changed(v30.Value)
        end
    end

    local function v38(p62) -- line: 347
        -- upvalues: p55 (copy), Track (copy), Min (copy), Max (copy), v30 (copy), v31 (ref), TweenService (copy), v9 (copy)
        if not v30:Usable() then
            return false
        end

        v31 = true
        TweenService:Create(Track.Knob, v9, {
            Size = UDim2.fromOffset(22, 32)
        }):Play()

        local v40 = math.clamp((p62.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)

        v30:Set(Min + (Max - Min) * v40)

        if p55.Changed then
            p55.Changed(v30.Value)
        end

        return true
    end

    local function v41(p63) -- line: 355
        -- upvalues: p55 (copy), Track (copy), Min (copy), Max (copy), v30 (copy)
        local v43 = math.clamp((p63.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)

        v30:Set(Min + (Max - Min) * v43)

        if p55.Changed then
            p55.Changed(v30.Value)
        end
    end

    local function v44() -- line: 357
        -- upvalues: p55 (copy), Track (copy), v30 (copy), v31 (ref), TweenService (copy), v9 (copy)
        v31 = false
        TweenService:Create(Track.Knob, v9, {
            Size = UDim2.fromOffset(18, 26)
        }):Play()

        if p55.Callback then
            p55.Callback(v30.Value)
        end
    end

    Track.InputBegan:Connect(function(p64) -- line: 133
        -- upvalues: v38 (copy), v41 (copy), v44 (copy), UserInputService (copy)
        if not ((p64.UserInputType == Enum.UserInputType.MouseButton1 or p64.UserInputType == Enum.UserInputType.Touch) and v38(p64)) then
            return
        end

        local Position = p64.Position
        local connection = UserInputService.InputChanged:Connect(function(p65) -- line: 138
            -- upvalues: v41 (copy), p64 (copy), Position (copy)
            if p65 == p64 or p65.UserInputType == Enum.UserInputType.MouseMovement then
                v41(p65, Vector2.new(p65.Position.X - Position.X, p65.Position.Y - Position.Y))
            end
        end)
        local connection2

        connection2 = p64.Changed:Connect(function() -- line: 150
            -- upvalues: v44 (copy), p64 (copy), connection (copy), connection2 (ref)
            if p64.UserInputState ~= Enum.UserInputState.End then
                return
            end

            connection:Disconnect()
            connection2:Disconnect()

            if v44 then
                v44()
            end
        end)
    end)

    return p54:_add(clone, v30)
end

function t15.Dropdown(p66, p67) -- line: 369
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), v7 (copy), flash (copy), t14 (copy)
    local clone = p66.Kit.Dropdown:Clone()

    clone.Label.Text = p67.Title

    local Choose = clone.Choose
    local v45 = p67.Placeholder or "Choose..."
    local v46 = setmetatable({
        Locked = false,
        Value = if p67.Multi then {} else nil,
        Labels = {}
    }, t14)

    local function caption() -- line: 379
        -- upvalues: p67 (copy), v45 (copy), v46 (copy)
        if not p67.Multi then
            return v46.Labels[v46.Value] or v45
        end

        local t34 = {}

        for _, v47 in v46.Value do
            table.insert(t34, v46.Labels[v47] or tostring(v47))
        end

        if #t34 > 0 then
            return (table.concat(t34, ", "))
        end

        return v45
    end

    function v46.Set(p68, p69, p70) -- line: 389
        -- upvalues: p67 (copy), Choose (copy), caption (copy)
        if p67.Multi then
            p68.Value = p69 or {}
        else
            p68.Value = p69
        end

        if p70 and p69 ~= nil and not p67.Multi then
            p68.Labels[p69] = p70
        end

        Choose.Text = caption()
    end

    function v46.Paint(p71) -- line: 396
        -- upvalues: Choose (copy), TweenService (copy), v2 (copy), v3 (copy), v7 (copy)
        TweenService:Create(Choose, v7, {
            BackgroundColor3 = if p71:Usable() then v2 else v3
        }):Play()
    end

    function v46.SetTitle(_, p73) -- line: 399
        -- upvalues: clone (copy)
        clone.Label.Text = p73
    end

    function v46.Open(p74) -- line: 402
        -- upvalues: p66 (copy), p67 (copy), Choose (copy), flash (copy)
        local v49 = if type(p67.Options) == "function" then p67.Options() else p67.Options

        p66.Window:Pick({
            Title = p67.PickerTitle or p67.Title,
            Placeholder = p67.Search,
            Options = v49,
            Sorts = p67.Sorts,
            Focus = Choose,
            IsChosen = function(p75) -- IsChosen | line: 412
                -- upvalues: p74 (copy), p67 (copy)
                if p67.Multi then
                    return table.find(p74.Value, p75.Value) ~= nil
                end

                return p74.Value == p75.Value
            end,
            OnPick = function(p76) -- OnPick | line: 418
                -- upvalues: p74 (copy), p67 (copy), Choose (copy), flash (copy)
                p74.Labels[p76.Value] = p76.Label

                local v50, v51

                if not p67.Multi or p76.Clears then
                    v50 = p74

                    if p76.Clears then
                        v51 = {}
                    else
                        v51 = p76.Value
                    end

                    v50:Set(v51)

                    if p76.Clears then
                        Choose.Text = p76.Label
                    end
                else
                    local v53 = table.clone(p74.Value)
                    local v54 = table.find(v53, p76.Value)

                    if v54 then
                        table.remove(v53, v54)
                    else
                        table.insert(v53, p76.Value)
                    end

                    p74:Set(v53)
                end

                flash(Choose:FindFirstChild("Stroke"))

                if p67.Callback then
                    p67.Callback(p74.Value, p76)
                end

                return p67.Multi and not p76.Clears
            end
        })
    end

    Choose.Activated:Connect(function() -- line: 443
        -- upvalues: v46 (copy)
        if v46:Usable() then
            v46:Open()
        end
    end)
    v46:Set(v46.Value)

    return p66:_add(clone, v46)
end

function t15.Clear(p77) -- line: 452
    for _, v55 in p77.Elements do
        v55.Instance:Destroy()
    end

    table.clear(p77.Elements)
    p77.Count = 0
end

local self3 = setmetatable({}, {
    __index = t15
})

self3.__index = self3

function self3.SetStatus(p78, p79, p80) -- line: 463
    -- upvalues: TweenService (copy), v4 (copy), v8 (copy)
    local State = p78.Frame.Content.Head.State

    if State.Text ~= p79 and State.Text ~= "" then
        State.TextTransparency = 1
        TweenService:Create(State, v8, {
            TextTransparency = 0
        }):Play()
    end

    State.Text = p79
    State.TextColor3 = p80 or v4
end

function self3.SetLocked(p81, p82) -- line: 474
    if p81.Locked == (p82 ~= nil) and p81.Note.Text == (p82 or "") then
        return
    end

    p81.Locked = p82 ~= nil
    p81.Note.Text = p82 or ""
    p81.Note.Visible = p82 ~= nil

    for _, v57 in p81.Elements do
        v57:Paint()
    end
end

function self3.SetDescription(p83, p84) -- line: 486
    p83.Frame.Content.Description.Text = p84
    p83:_paintOpen()
end

function self3.SetExpanded(p85, p86) -- line: 491
    p85.Open = p86
    p85:_paintOpen()
end

function self3._paintOpen(p87) -- line: 496
    local v58 = p87.Open or p87.Window.Searching == true
    local Content = p87.Frame.Content

    Content.Head.Title.Text = (v58 and "–  " or "+  ") .. p87.Title
    Content.Body.Visible = v58
    Content.Description.Visible = v58 and Content.Description.Text ~= ""
end

function self3.SetVisible(p88, p89) -- line: 504
    if p88.Shown ~= p89 then
        p88.Shown = p89
        p88.Window:_filter()
    end
end

local self4 = setmetatable({}, {
    __index = t15
})

self4.__index = self4

function self4.Group(p90, p91) -- line: 515
    -- upvalues: TweenService (copy), v5 (copy), v8 (copy), lift (copy), self3 (copy)
    local clone = p90.Kit.Group:Clone()

    clone.Name = p91.Name or p91.Title
    clone.Accent.BackgroundColor3 = p90.Color
    clone.Content.Head.Title.Text = p91.Title
    clone.Content.Head.State.Text = ""
    p90.Count += 1
    clone.LayoutOrder = p90.Count
    clone.Visible = true
    clone.Parent = p90.Holder

    local clone2 = p90.Kit.Paragraph:Clone()

    clone2.Name = "Note"
    clone2.TextColor3 = v5
    clone2.LayoutOrder = 1E+05
    lift(clone2, 3)
    clone2.Parent = clone.Content.Body

    local Color = clone.Stroke.Color

    clone.MouseEnter:Connect(function() -- line: 532
        -- upvalues: p90 (copy), clone (copy), TweenService (copy), v8 (copy)
        TweenService:Create(clone.Stroke, v8, {
            Color = p90.Color
        }):Play()
    end)
    clone.MouseLeave:Connect(function() -- line: 535
        -- upvalues: clone (copy), Color (copy), TweenService (copy), v8 (copy)
        TweenService:Create(clone.Stroke, v8, {
            Color = Color
        }):Play()
    end)

    local v60 = setmetatable({
        Count = 0,
        Locked = false,
        Shown = true,
        Frame = clone,
        Holder = clone.Content.Body,
        Note = clone2,
        Tab = p90,
        Window = p90.Window,
        Kit = p90.Kit,
        Elements = {},
        Title = p91.Title,
        Open = p91.Open == true,
        Keywords = string.lower(p91.Title .. " " .. (p91.Description or "") .. " " .. (p91.Keywords or ""))
    }, self3)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Expand"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = clone.Content.Head.Title.ZIndex + 1
    TextButton.Parent = clone.Content.Head
    TextButton.Activated:Connect(function() -- line: 562
        -- upvalues: v60 (copy)
        v60:SetExpanded(not v60.Open)
    end)
    v60:SetDescription(p91.Description or "")
    clone2.Visible = false
    table.insert(p90.Groups, v60)

    return v60
end

function self4.SetVisible(p92, p93) -- line: 571
    p92.Shown = p93
    p92.Button.Visible = p93

    if not p93 and p92.Window.Selected == p92 then
        for _, v61 in p92.Window.TabList do
            if v61.Shown then
                p92.Window:SelectTab(v61.Name)

                return
            end
        end
    end
end

local t45 = {}

t45.__index = t45

function t1.Window(p94) -- line: 587
    -- upvalues: UserInputService (copy), spring (copy), t45 (copy)
    local Kit = p94.Kit
    local clone = Kit.Window:Clone()

    clone.Name = p94.Name or "Window"
    clone.Header.Title.Text = p94.Title
    clone.Header.Search.PlaceholderText = p94.SearchPlaceholder or "Search..."

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pop"
    UIScale.Parent = clone
    clone.Parent = p94.Parent

    local clone2 = Kit.Picker:Clone()

    clone2.Parent = clone.Overlay

    local clone3 = Kit.Toast:Clone()

    clone3.Parent = p94.Parent

    local v62 = setmetatable({
        Minimized = false,
        Placed = false,
        Picking = nil,
        PickSort = 1,
        PickLimit = 100,
        ToastRevision = 0,
        ShowRevision = 0,
        Frame = clone,
        Kit = Kit,
        Screen = p94.Parent,
        Tabs = {},
        TabList = {},
        Pages = clone.Pages,
        Overlay = clone.Overlay,
        Picker = clone2,
        Toast = clone3,
        ToastHome = clone3.Position,
        SearchBox = clone.Header.Search,
        Size = p94.Size or Vector2.new(940, 580),
        MinSize = p94.MinSize or Vector2.new(440, 320),
        OnClose = p94.OnClose,
        FocusTo = p94.Focus
    }, t45)

    for _, descendant in clone:GetDescendants() do
        spring(descendant)
    end

    clone.DescendantAdded:Connect(spring)

    local Title = clone.Header.Title

    local function v63() -- line: 631
        -- upvalues: clone (copy), v62 (copy)
        v62.DragFrom = clone.Position

        return true
    end

    local function v64(_, p96) -- line: 634
        -- upvalues: clone (copy), v62 (copy)
        local DragFrom = v62.DragFrom

        v62:_place(Vector2.new(DragFrom.X.Offset + p96.X, DragFrom.Y.Offset + p96.Y), Vector2.new(clone.Size.X.Offset, v62.Expanded or clone.Size.Y.Offset))
    end

    local InputBegan = Title.InputBegan
    local v65

    InputBegan:Connect(function(p97) -- line: 133
        -- upvalues: v63 (copy), v64 (copy), v65 (copy), UserInputService (copy)
        if not ((p97.UserInputType == Enum.UserInputType.MouseButton1 or p97.UserInputType == Enum.UserInputType.Touch) and v63(p97)) then
            return
        end

        local Position = p97.Position
        local connection = UserInputService.InputChanged:Connect(function(p98) -- line: 138
            -- upvalues: v64 (copy), p97 (copy), Position (copy)
            if p98 == p97 or p98.UserInputType == Enum.UserInputType.MouseMovement then
                v64(p98, Vector2.new(p98.Position.X - Position.X, p98.Position.Y - Position.Y))
            end
        end)
        local connection2

        connection2 = p97.Changed:Connect(function() -- line: 150
            -- upvalues: v65 (copy), p97 (copy), connection (copy), connection2 (ref)
            if p97.UserInputState ~= Enum.UserInputState.End then
                return
            end

            connection:Disconnect()
            connection2:Disconnect()

            if v65 then
                v65()
            end
        end)
    end)

    local Resize = clone.Resize

    local function v66() -- line: 641
        -- upvalues: clone (copy), v62 (copy)
        v62.ResizeFrom = Vector2.new(clone.Size.X.Offset, clone.Size.Y.Offset)

        return not v62.Minimized
    end

    local function v67(_, p100) -- line: 644
        -- upvalues: clone (copy), v62 (copy)
        local ResizeFrom = v62.ResizeFrom

        v62:_place(Vector2.new(clone.Position.X.Offset, clone.Position.Y.Offset), Vector2.new(ResizeFrom.X + p100.X, ResizeFrom.Y + p100.Y))
    end

    local InputBegan2 = Resize.InputBegan
    local v68

    InputBegan2:Connect(function(p101) -- line: 133
        -- upvalues: v66 (copy), v67 (copy), v68 (copy), UserInputService (copy)
        if not ((p101.UserInputType == Enum.UserInputType.MouseButton1 or p101.UserInputType == Enum.UserInputType.Touch) and v66(p101)) then
            return
        end

        local Position = p101.Position
        local connection = UserInputService.InputChanged:Connect(function(p102) -- line: 138
            -- upvalues: v67 (copy), p101 (copy), Position (copy)
            if p102 == p101 or p102.UserInputType == Enum.UserInputType.MouseMovement then
                v67(p102, Vector2.new(p102.Position.X - Position.X, p102.Position.Y - Position.Y))
            end
        end)
        local connection2

        connection2 = p101.Changed:Connect(function() -- line: 150
            -- upvalues: v68 (copy), p101 (copy), connection (copy), connection2 (ref)
            if p101.UserInputState ~= Enum.UserInputState.End then
                return
            end

            connection:Disconnect()
            connection2:Disconnect()

            if v68 then
                v68()
            end
        end)
    end)
    clone.Header.Minimize.Activated:Connect(function() -- line: 651
        -- upvalues: v62 (copy)
        v62:Minimize(not v62.Minimized)
    end)
    clone.Header.Close.Activated:Connect(function() -- line: 654
        -- upvalues: v62 (copy)
        if v62.OnClose then
            v62.OnClose()
        else
            v62:SetVisible(false)
        end
    end)
    clone.Header.Search:GetPropertyChangedSignal("Text"):Connect(function() -- line: 661
        -- upvalues: v62 (copy)
        v62:_filter()
    end)
    clone:GetPropertyChangedSignal("Size"):Connect(function() -- line: 664
        -- upvalues: v62 (copy)
        v62:_layout()
    end)
    p94.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 667
        -- upvalues: clone (copy), v62 (copy)
        if v62.Placed then
            v62:_place(Vector2.new(clone.Position.X.Offset, clone.Position.Y.Offset), Vector2.new(clone.Size.X.Offset, v62.Expanded or clone.Size.Y.Offset))
        end
    end)
    clone2.Back.Activated:Connect(function() -- line: 676
        -- upvalues: v62 (copy)
        v62:ClosePicker()
    end)
    clone2.Sort.Activated:Connect(function() -- line: 679
        -- upvalues: clone2 (copy), v62 (copy)
        local v71 = v62.Picking and v62.Picking.Sorts

        if not v71 then
            return
        end

        v62.PickSort = v62.PickSort % #v71 + 1
        clone2.Options.CanvasPosition = Vector2.zero
        v62:_renderPicker()
    end)
    clone2.Search:GetPropertyChangedSignal("Text"):Connect(function() -- line: 687
        -- upvalues: clone2 (copy), v62 (copy)
        if v62.Picking then
            v62.PickLimit = 100
            clone2.Options.CanvasPosition = Vector2.zero
            v62:_renderPicker()
        end
    end)
    clone2.Options:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 694
        -- upvalues: clone2 (copy), v62 (copy)
        if clone2.Visible then
            v62:_renderPicker()
        end
    end)
    v62:_layout()

    return v62
end

function t45._place(p103, p104, p105) -- line: 703
    local AbsoluteSize = p103.Screen.AbsoluteSize
    local v73 = math.clamp(p105.X, math.min(p103.MinSize.X, AbsoluteSize.X), AbsoluteSize.X)
    local v75 = math.clamp(p105.Y, math.min(p103.MinSize.Y, AbsoluteSize.Y), AbsoluteSize.Y)

    if p103.Minimized then
        p103.Expanded = v75
        v75 = 68
    end

    p103.Frame.Size = UDim2.fromOffset(v73, v75)
    p103.Frame.Position = UDim2.fromOffset(math.clamp(p104.X, 80 - v73, AbsoluteSize.X - 80), (math.clamp(p104.Y, 0, AbsoluteSize.Y - 68)))
end

function t45._layout(p106) -- line: 718
    local Frame = p106.Frame
    local Offset = Frame.Size.X.Offset
    local v80 = Offset < 640
    local v81 = if v80 then 62 else 150
    local v82 = if Offset < 720 then 150 else 250

    Frame.Tabs.Size = UDim2.new(0, v81, 1, -116)
    Frame.Pages.Position = UDim2.fromOffset(v81 + 26, 76)
    Frame.Pages.Size = UDim2.new(1, -(v81 + 40), 1, -116)
    Frame.Overlay.Position = Frame.Pages.Position
    Frame.Overlay.Size = Frame.Pages.Size
    Frame.Header.Search.Visible = Offset >= 520
    Frame.Header.Search.Size = UDim2.fromOffset(v82, 44)
    Frame.Header.Search.Position = UDim2.new(1, -(v82 + 114), 0, 6)
    Frame.Header.Title.Size = UDim2.new(1, -(if Frame.Header.Search.Visible then v82 + 140 else 130), 1, 0)
    Frame.Header.Title.TextSize = v80 and 22 or 28
    Frame.Status.Hint.Visible = not v80
    Frame.Status.Server.Size = UDim2.new(v80 and 1 or 0.5, -12, 1, 0)

    for _, v83 in p106.TabList do
        v83.Button.Caption.Visible = not v80

        local Icon = v83.Button.Icon

        if v80 then
            Icon.Position = UDim2.new(0.5, -14, 0.5, -14)
        else
            Icon.Position = UDim2.new(0, 10, 0.5, -14)
        end
    end

    local v84 = p106.Picker.AbsoluteSize.Y < 340

    p106.Picker.Title.Visible = not v84

    local Search = p106.Picker.Search

    if v84 then
        Search.Position = UDim2.fromOffset(124, 14)
    else
        Search.Position = UDim2.fromOffset(18, 77)
    end

    p106.Picker.Search.Size = UDim2.new(1, v84 and -142 or -36, 0, 44)
    p106.Picker.Options.Position = UDim2.fromOffset(14, v84 and 70 or 135)
    p106.Picker.Options.Size = UDim2.new(1, -28, 1, v84 and -82 or -150)
end

function t45.Tab(p107, p108) -- line: 757
    -- upvalues: v1 (copy), lift (copy), self4 (copy)
    local clone = p107.Kit.Tab:Clone()

    clone.Name = p108.Name
    clone.Text = p108.Title or p108.Name
    clone.LayoutOrder = #p107.TabList + 1
    clone.Visible = true

    if p108.Icon then
        local clone2 = p108.Icon:Clone()

        clone2.Visible = true
        lift(clone2, 5)
        clone2.Parent = clone.Icon
    end

    clone.Parent = p107.Frame.Tabs

    local clone2 = p107.Kit.Page:Clone()

    clone2.Name = p108.Name
    clone2.Parent = p107.Pages

    local v85 = setmetatable({
        Count = 0,
        Locked = false,
        Shown = true,
        Name = p108.Name,
        Button = clone,
        Holder = clone2,
        Window = p107,
        Kit = p107.Kit,
        Color = p108.Color or v1,
        Elements = {},
        Groups = {}
    }, self4)

    p107.Tabs[p108.Name] = v85
    table.insert(p107.TabList, v85)
    clone.Activated:Connect(function() -- line: 788
        -- upvalues: p107 (copy), p108 (copy)
        p107:SelectTab(p108.Name)
    end)

    if not p107.Selected then
        p107:SelectTab(p108.Name)
    end

    p107:_layout()

    return v85
end

function t45.SelectTab(p109, p110) -- line: 798
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v4 (copy), v8 (copy)
    local v86 = p109.Tabs[p110]

    assert(v86, "Unknown tab " .. p110)

    local v88 = p109.Selected ~= v86

    p109.Selected = v86

    for _, v89 in p109.TabList do
        local v90 = v89 == v86

        v89.Holder.Visible = v90

        local Button = v89.Button
        local t48 = {}

        if v90 then
            t48.BackgroundColor3 = v1
            t48.TextColor3 = Color3.new(1, 1, 1)
        else
            t48.BackgroundColor3 = v2
            t48.TextColor3 = v4
        end

        TweenService:Create(Button, v8, t48):Play()
    end

    TweenService:Create(p109.Pages.Accent, v8, {
        BackgroundColor3 = v86.Color
    }):Play()
    v86.Holder.CanvasPosition = Vector2.zero

    if not v88 then
        return
    end

    v86.Holder.Position = UDim2.fromOffset(18, 4)
    TweenService:Create(v86.Holder, v8, {
        Position = UDim2.fromOffset(0, 4)
    }):Play()
end

function t45._filter(p111) -- line: 819
    -- upvalues: TweenService (copy), v7 (copy)
    local v91 = string.lower(p111.SearchBox.Text)
    local v92 = v91 ~= ""

    p111.Searching = v92

    local v93

    for _, v94 in p111.TabList do
        local n1 = 0

        for _, v95 in v94.Groups do
            v95:_paintOpen()
            v95.Frame.Visible = v95.Shown and (not v92 or string.find(v95.Keywords, v91, 1, true) ~= nil)

            if v95.Frame.Visible then
                n1 += 1
            end
        end

        for _, v96 in v94.Elements do
            v96.Instance.Visible = not v92
        end

        TweenService:Create(v94.Button.Caption, v7, {
            TextTransparency = v92 and n1 == 0 and 0.6 or 0
        }):Play()

        if v94.Shown and n1 > 0 then
            v93 = v93 or v94
        end

        v94.Matches = n1
    end

    local Selected = p111.Selected

    if v92 and v93 and Selected and Selected.Matches == 0 then
        p111:SelectTab(v93.Name)
    end
end

function t45.SetVisible(p112, p113) -- line: 851
    -- upvalues: TweenService (copy), v8 (copy), v9 (copy), v10 (copy)
    local Frame = p112.Frame

    p112.ShowRevision += 1

    local ShowRevision = p112.ShowRevision

    if p113 then
        if not p112.Placed then
            p112.Placed = true

            local AbsoluteSize = p112.Screen.AbsoluteSize
            local v100 = Vector2.new(math.min(p112.Size.X, AbsoluteSize.X * 0.94), (math.min(p112.Size.Y, AbsoluteSize.Y * 0.9)))

            p112:_place((AbsoluteSize - v100) / 2, v100)
        end

        local FramePosition = Frame.Position

        if not Frame.Visible then
            Frame.Pop.Scale = 0.92
            Frame.Position = FramePosition + UDim2.fromOffset(0, 14)
        end

        Frame.Visible = true
        TweenService:Create(Frame.Pop, v9, {
            Scale = 1
        }):Play()
        TweenService:Create(Frame, v8, {
            Position = FramePosition
        }):Play()
    else
        p112:ClosePicker()

        if Frame.Visible then
            TweenService:Create(Frame.Pop, v10, {
                Scale = 0.94
            }):Play()
            task.delay(v10.Time, function() -- line: 861
                -- upvalues: p112 (copy), Frame (copy), ShowRevision (copy)
                if ShowRevision == p112.ShowRevision then
                    Frame.Visible = false
                end
            end)
        end
    end
end

function t45.Minimize(p114, p115) -- line: 887
    -- upvalues: TweenService (copy), v8 (copy)
    if p115 == p114.Minimized then
        return
    end

    local Frame = p114.Frame
    local Offset = Frame.Size.X.Offset

    p114.Minimized = p115
    Frame.Header.Minimize.Text = p115 and "+" or "–"

    if p115 then
        p114:ClosePicker()
        p114.Expanded = Frame.Size.Y.Offset

        for _, v101 in { "Tabs", "Pages", "Overlay", "Status", "Resize" } do
            Frame[v101].Visible = false
        end

        TweenService:Create(Frame, v8, {
            Size = UDim2.fromOffset(Offset, 68)
        }):Play()
    else
        local v102 = p114.Expanded or p114.Size.Y

        p114.Expanded = nil

        local tween = TweenService:Create(Frame, v8, {
            Size = UDim2.fromOffset(Offset, v102)
        })

        tween:Play()
        tween.Completed:Connect(function() -- line: 907
            -- upvalues: p114 (copy), Frame (copy), Offset (copy), v102 (copy)
            if p114.Minimized then
                return
            end

            for _, v103 in { "Tabs", "Pages", "Overlay", "Status", "Resize" } do
                Frame[v103].Visible = true
            end

            p114:_place(Vector2.new(Frame.Position.X.Offset, Frame.Position.Y.Offset), Vector2.new(Offset, v102))
        end)
    end
end

function t45.SetStatus(p116, p117, p118) -- line: 918
    p116.Frame.Status.Server.Text = p117
    p116.Frame.Status.Hint.Text = p118
end

function t45.Notify(p119, p120, p121) -- line: 923
    -- upvalues: TweenService (copy), v9 (copy), v10 (copy)
    p119.ToastRevision += 1

    local ToastRevision, Toast = p119.ToastRevision, p119.Toast

    Toast.Message.Text = p120

    local Stroke = Toast.Stroke

    if p121 == false then
        Stroke.Color = Color3.fromRGB(244, 160, 130)
    else
        Stroke.Color = Color3.fromRGB(160, 207, 159)
    end

    if not Toast.Visible then
        Toast.Position = p119.ToastHome - UDim2.fromOffset(0, 24)
    end

    Toast.Visible = true
    TweenService:Create(Toast, v9, {
        Position = p119.ToastHome
    }):Play()
    task.delay(7, function() -- line: 936
        -- upvalues: p119 (copy), ToastRevision (copy), Toast (copy), TweenService (copy), v10 (copy)
        if ToastRevision ~= p119.ToastRevision then
            return
        end

        TweenService:Create(Toast, v10, {
            Position = p119.ToastHome - UDim2.fromOffset(0, 24)
        }):Play()
        task.delay(v10.Time, function() -- line: 941
            -- upvalues: p119 (copy), ToastRevision (copy), Toast (copy)
            if ToastRevision == p119.ToastRevision then
                Toast.Visible = false
            end
        end)
    end)
end

function t45.AddPage(p122, p123) -- line: 950
    -- upvalues: TweenService (copy), v8 (copy)
    p123.Position = UDim2.new()
    p123.Size = UDim2.fromScale(1, 1)
    p123.Visible = false
    p123.Parent = p122.Overlay
    p123:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 955
        -- upvalues: p123 (copy), TweenService (copy), v8 (copy)
        if p123.Visible then
            p123.Position = UDim2.fromOffset(0, 16)
            TweenService:Create(p123, v8, {
                Position = UDim2.new()
            }):Play()
        end
    end)
end

function t45.Pick(p124, p125) -- line: 964
    -- upvalues: TweenService (copy), v8 (copy)
    p124.Picking = p125
    p124.PickSort = 1
    p124.PickLimit = 100
    p124.Picker.Search.Text = ""
    p124.Picker.Options.CanvasPosition = Vector2.zero
    p124.Picker.Position = UDim2.fromOffset(0, 16)
    p124.Picker.Visible = true
    TweenService:Create(p124.Picker, v8, {
        Position = UDim2.new()
    }):Play()
    p124:_renderPicker()
end

function t45.ClosePicker(p126) -- line: 976
    local Picking = p126.Picking

    p126.Picking = nil
    p126.Picker.Visible = false

    if Picking and p126.FocusTo and p126.Frame.Visible then
        p126.FocusTo(Picking.Focus)
    end
end

function t45._renderPicker(p127) -- line: 985
    -- upvalues: v1 (copy), v6 (copy), lift (copy)
    local Picking, Picker = p127.Picking, p127.Picker

    if not Picking then
        return
    end

    for _, child in Picker.Options:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local v105 = Picking.Sorts and Picking.Sorts[p127.PickSort]
    local v106 = string.lower(Picker.Search.Text)
    local t61 = {}
    local v107 = false
    local v108 = false

    for _, v109 in Picking.Options do
        v107 = v107 or v109.Image ~= nil
        v108 = v108 or v109.Subtitle ~= nil

        if string.find(string.lower(v109.Label .. " " .. tostring(v109.Value)), v106, 1, true) then
            table.insert(t61, v109)
        end
    end

    if v105 then
        table.sort(t61, function(p128, p129) -- line: 1015
            -- upvalues: v105 (copy)
            if p128.Clears or p129.Clears then
                if p128.Clears == true then
                    return p129.Clears ~= true
                end

                return false
            end

            local v110 = p128[v105.Key] or 0
            local v111 = p129[v105.Key] or 0

            if v110 == v111 then
                return p128.Label < p129.Label
            end

            if v105.Descending then
                return v111 < v110
            end

            return v110 < v111
        end)
    end

    local v112 = if v108 then p127.Kit.PlayerTile elseif v107 then p127.Kit.AssetTile else p127.Kit.Option
    local v113 = if v107 or v108 then math.max(1, (math.floor((Picker.Options.AbsoluteSize.X - 14) / 130))) else 1

    Picker.Options.Layout.CellSize = UDim2.new(1 / v113, -((v113 - 1) * 10 + 14) / v113, 0, if v108 then 124 elseif v107 then 112 else 48)
    Picker.Options.Layout.CellPadding = UDim2.fromOffset(10, 10)

    local function place(p130, p131) -- line: 1043
        -- upvalues: Picker (copy), lift (copy)
        p130.Name = "Option" .. p131
        lift(p130, 10)
        p130.Visible = true
        p130.LayoutOrder = p131
        p130.Parent = Picker.Options
    end

    for i = 1, math.min(#t61, p127.PickLimit) do
        local v117 = t61[i]
        local v118 = Picking.IsChosen and Picking.IsChosen(v117) == true
        local clone = v112:Clone()

        if v107 or v108 then
            clone.Image.Image = v117.Image or ""
            clone.Title.Text = v117.Title or v117.Label

            if v108 then
                clone.Subtitle.Text = v117.Subtitle or ""
            end

            clone.SelectionBadge.Visible = v118

            local Stroke = clone.Stroke

            if v118 then
                Stroke.Color = v1
            else
                Stroke.Color = v6
            end
        else
            if v118 then
                clone.Text = "✓  " .. v117.Label
            else
                clone.Text = v117.Label
            end

            clone.TextSize = 13
            clone.TextWrapped = true
        end

        clone.Name = "Option" .. i
        lift(clone, 10)
        clone.Visible = true
        clone.LayoutOrder = i
        clone.Parent = Picker.Options
        clone.Activated:Connect(function() -- line: 1068
            -- upvalues: p127 (copy), Picking (copy), v117 (copy)
            if p127.Picking == Picking then
                if Picking.OnPick(v117) == true then
                    p127:_renderPicker()
                else
                    p127:ClosePicker()
                end
            end
        end)
    end

    if #t61 > p127.PickLimit then
        local clone = v112:Clone()

        if v107 then
            clone.Image.Visible = false
            clone.SelectionBadge.Visible = false
            clone.Title.Text = "Load 100 more"

            if v108 then
                clone.Subtitle.Text = ""
            end
        elseif v108 then
            clone.Image.Visible = false
            clone.SelectionBadge.Visible = false
            clone.Title.Text = "Load 100 more"
            clone.Subtitle.Text = ""
        else
            clone.Text = "Load 100 more"
        end

        local v119 = p127.PickLimit + 1

        clone.Name = "Option" .. v119
        lift(clone, 10)
        clone.Visible = true
        clone.LayoutOrder = v119
        clone.Parent = Picker.Options
        clone.Activated:Connect(function() -- line: 1092
            -- upvalues: p127 (copy)
            p127.PickLimit += 100
            p127:_renderPicker()
        end)
    end

    local Title = Picker.Title

    if #t61 == 0 then
        Title.Text = "No matches"
    else
        Title.Text = Picking.Title or "Choose an option"
    end

    Picker.Search.PlaceholderText = Picking.Placeholder or "Search " .. #Picking.Options .. " options..."
    Picker.Sort.Visible = v105 ~= nil

    local Sort = Picker.Sort

    if v105 then
        Sort.Text = v105.Label
    else
        Sort.Text = ""
    end

    Picker.Title.Size = UDim2.new(1, Picker.Sort.Visible and -270 or -135, 0, 44)
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1, Stats, Hint, ExitButton, LeftButtons, Label, ImageLabel
local ButtonB = Enum.KeyCode.ButtonB
local v2
local v3 = false
local v4 = false
local v5 = true
local v6 = false
local t2 = {
    Money = 0,
    Strength = 0
}
local t3 = {}
local t4 = {}
local t5 = {}

local function formatStat(p1, p2) -- line: 52
    -- upvalues: Format (copy)
    local v8 = math.floor(p2 + 0.5)

    if p1 == "Money" then
        return (Format.money(v8))
    end

    return (Format.short(v8))
end

local function bindCounter(p3) -- line: 58
    -- upvalues: RunService (copy), Format (copy), UIUtil (copy), LocalPlayer (copy), Stats (ref), t2 (copy), t3 (copy), t4 (copy)
    local Value = Stats:WaitForChild(p3).Value

    t4[p3] = Value
    t2[p3] = LocalPlayer:GetAttribute(p3) or 0

    local v10 = math.floor(t2[p3] + 0.5)

    Value.Text = if p3 == "Money" then Format.money(v10) else Format.short(v10)

    local v12 = t2[p3]

    LocalPlayer:GetAttributeChangedSignal(p3):Connect(function() -- line: 65
        -- upvalues: p3 (copy), Value (copy), v12 (ref), UIUtil (copy), LocalPlayer (copy)
        local v13 = LocalPlayer:GetAttribute(p3) or 0

        if v12 < v13 then
            UIUtil.pop(Value, 1.12)
        end

        v12 = v13
    end)
    RunService.Heartbeat:Connect(function(p4) -- line: 72
        -- upvalues: p3 (copy), Value (copy), Format (copy), LocalPlayer (copy), t2 (copy), t3 (copy)
        local v14 = t3[p3]

        v14 = v14 or LocalPlayer:GetAttribute(p3) or 0

        local v15 = t2[p3]

        if v15 == v14 then
            return
        end

        local v18 = v15 + (v14 - v15) * math.min(1, p4 * 8)

        if math.abs(v14 - v18) < math.max(0.5, math.abs(v14) * 5E-04) then
            v18 = v14
        end

        t2[p3] = v18

        local v23 = math.floor(v18 + 0.5)

        Value.Text = if p3 == "Money" then Format.money(v23) else Format.short(v23)
    end)
end

function t1.override(p5, p6) -- line: 88
    -- upvalues: Format (copy), LocalPlayer (copy), t2 (copy), t3 (copy), t4 (copy)
    t3[p5] = p6

    local v25 = t4[p5]

    if p6 == nil and v25 then
        t2[p5] = LocalPlayer:GetAttribute(p5) or 0

        local v27 = math.floor(t2[p5] + 0.5)

        if p5 == "Money" then
            v25.Text = Format.money(v27)
        else
            v25.Text = Format.short(v27)
        end
    end
end

function t1.worldPopup(p7, p8, p9) -- line: 99
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Head = Character and Character:FindFirstChild("Head")

    if not Head then
        return
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromOffset(200, 50)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(math.random(-10, 10) / 10, 2.5, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = Head

    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.fromScale(0, 1)
    TextLabel.FontFace = Config.Font
    TextLabel.TextSize = 40
    TextLabel.Text = p7
    TextLabel.TextColor3 = p8

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(20, 20, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Frame

    local ImageLabel

    if p9 then
        local ImageLabel2 = Instance.new("ImageLabel")

        ImageLabel = ImageLabel2
        ImageLabel2.BackgroundTransparency = 1
        ImageLabel2.Image = p9
        ImageLabel2.ScaleType = Enum.ScaleType.Fit
        ImageLabel2.Size = UDim2.fromOffset(44, 44)
        ImageLabel2.LayoutOrder = 1
        ImageLabel2.Parent = Frame
    end

    Frame.Parent = BillboardGui
    BillboardGui.Parent = LocalPlayer.PlayerGui
    UIUtil.pop(Frame, 0.3)
    UIUtil.tween(BillboardGui, 1.1, {
        StudsOffsetWorldSpace = BillboardGui.StudsOffsetWorldSpace + Vector3.new(0, 3, 0)
    })
    task.delay(0.6, function() -- line: 148
        -- upvalues: TextLabel (copy), UIStroke (copy), ImageLabel (ref), UIUtil (copy)
        UIUtil.tween(TextLabel, 0.5, {
            TextTransparency = 1
        })
        UIUtil.tween(UIStroke, 0.5, {
            Transparency = 1
        })

        if ImageLabel then
            UIUtil.tween(ImageLabel, 0.5, {
                ImageTransparency = 1
            })
        end
    end)
    task.delay(1.2, function() -- line: 155
        -- upvalues: BillboardGui (copy)
        BillboardGui:Destroy()
    end)
end

function t1.cashPopup(p10) -- line: 161
    -- upvalues: UIUtil (copy), v1 (ref), Stats (ref)
    local Popups = v1.Popups
    local clone = v1.Toasts.ToastTemplate:Clone()

    clone.Name = "Cash"
    clone.Visible = true
    clone.Text = p10
    clone.TextColor3 = Color3.fromRGB(120, 255, 110)
    clone.AnchorPoint = Vector2.new(0.5, 0.5)
    clone.Size = UDim2.fromOffset(420, 70)
    clone.Position = UDim2.fromScale(0.5, 0.45)
    clone.Parent = Popups
    UIUtil.pop(clone, 0.3)
    task.delay(0.5, function() -- line: 173
        -- upvalues: clone (copy), UIUtil (copy), Stats (ref)
        local v29 = Stats.Money.Value.AbsolutePosition + Stats.Money.Value.AbsoluteSize / 2

        UIUtil.tween(clone, 0.45, {
            Position = UDim2.fromOffset(v29.X, v29.Y),
            Size = UDim2.fromOffset(160, 30)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.45)
        clone:Destroy()
        UIUtil.pop(Stats.Money.Value, 1.3)
    end)
end

local v30

function t1.setHint(p11) -- line: 184
    -- upvalues: UIUtil (copy), Hint (ref), v6 (ref), v30 (ref)
    v30 = p11

    if p11 ~= nil then
        if v6 then
            Hint.Text = p11
        elseif not Hint.Visible or Hint.Text ~= p11 then
            Hint.Text = p11
            Hint.Visible = true
            UIUtil.pop(Hint, 0.8)
        end
    else
        Hint.Visible = false
    end
end

local function refreshSides() -- line: 202
    -- upvalues: v1 (ref), ExitButton (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
    local v31 = v5
    local v32, v33

    if v31 then
        local v34 = not v6

        if v34 then
            local v35 = not v4

            if v35 then
                v32 = ExitButton.Visible and v3
                v33 = not v32
            else
                v33 = v35
            end
        else
            v33 = v34
        end
    else
        v33 = v31
    end

    v1.SideLeft.Visible = v33
    v1.SideRight.Visible = v33
end

local function refresh() -- line: 208
    -- upvalues: v1 (ref), Stats (ref), Hint (ref), ExitButton (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), t5 (copy), v30 (ref)
    local v36 = v5 and not v6

    Stats.Visible = v36
    v1.TopLeftButtons.Visible = v36 and not v4
    v1.TopRightButtons.Visible = v36 and not v4
    v1.LeftButtons.Visible = not v6

    local Hint2 = Hint

    if v30 ~= nil then
        Hint2.Visible = v36
    else
        Hint2.Visible = false
    end

    local v37 = v5
    local v38, v39

    if v37 then
        local v40 = not v6

        if v40 then
            local v41 = not v4

            if v41 then
                v38 = ExitButton.Visible and v3
                v39 = not v38
            else
                v39 = v41
            end
        else
            v39 = v40
        end
    else
        v39 = v37
    end

    v1.SideLeft.Visible = v39
    v1.SideRight.Visible = v39

    for _, v42 in t5 do
        task.spawn(v42, v36)
    end
end

function t1.onVisibility(p12) -- line: 222
    -- upvalues: v5 (ref), v6 (ref), t5 (copy)
    table.insert(t5, p12)
    p12(v5 and not v6)
end

function t1.setVisible(p13) -- line: 227
    -- upvalues: v5 (ref), v30 (ref), refresh (copy)
    v5 = p13

    if not p13 then
        v30 = nil
    end

    refresh()
end

local function placeExit() -- line: 238
    -- upvalues: LeftButtons (ref), v3 (ref)
    if v3 then
        local LeftButtons2 = LeftButtons

        LeftButtons2.AnchorPoint = Vector2.new(0, 0.5)

        local LeftButtons3 = LeftButtons

        LeftButtons3.Position = UDim2.new(0, 12, 0.5, 0)
    else
        local LeftButtons2 = LeftButtons

        LeftButtons2.AnchorPoint = Vector2.new(0.5, 1)

        local LeftButtons3 = LeftButtons

        LeftButtons3.Position = UDim2.fromScale(0.5, 0.88)
    end
end

local function exit() -- line: 248
    -- upvalues: t1 (copy), v2 (ref)
    local v43 = v2

    if v43 then
        t1.hideExit()
        v43()
    end
end

local Text, Position, Size

local function showExitKey() -- line: 259
    -- upvalues: UserInputService (copy), Label (ref), ImageLabel (ref), ButtonB (copy), Text (ref), Position (ref), Size (ref)
    local v44 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil

    ImageLabel.Visible = v44

    local Label2 = Label

    if v44 then
        Label2.Text = "EXIT"
    else
        Label2.Text = Text
    end

    local Label3 = Label

    if v44 then
        Label3.Position = UDim2.new(0.62, 0, Position.Y.Scale, Position.Y.Offset)
    else
        Label3.Position = Position
    end

    local Label4 = Label

    if v44 then
        Label4.Size = UDim2.new(0.56, 0, Size.Y.Scale, Size.Y.Offset)
    else
        Label4.Size = Size
    end

    local ImageForKeyCode = UserInputService:GetImageForKeyCode(ButtonB)

    if v44 and ImageLabel.Image ~= ImageForKeyCode then
        ImageLabel.Image = ImageForKeyCode
    end
end

function t1.showExit(p14, p15) -- line: 272
    -- upvalues: ContextActionService (copy), UIUtil (copy), v1 (ref), ExitButton (ref), ButtonB (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), placeExit (copy), exit (copy)
    if not v2 then
        ContextActionService:BindActionAtPriority("HudExit", function(_, p17) -- line: 274
            -- upvalues: exit (copy)
            if p17 == Enum.UserInputState.Begin then
                task.spawn(exit)
            end

            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value, ButtonB)
    end

    v2 = p14
    v3 = p15 == true
    placeExit()

    if not ExitButton.Visible then
        ExitButton.Visible = true
        UIUtil.pop(ExitButton, 0.6)
    end

    local v46 = v5
    local v47, v48

    if v46 then
        local v49 = not v6

        if v49 then
            local v50 = not v4

            if v50 then
                v47 = ExitButton.Visible and v3
                v48 = not v47
            else
                v48 = v50
            end
        else
            v48 = v49
        end
    else
        v48 = v46
    end

    v1.SideLeft.Visible = v48
    v1.SideRight.Visible = v48
end

function t1.hideExit() -- line: 291
    -- upvalues: ContextActionService (copy), v1 (ref), ExitButton (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
    v2 = nil
    ContextActionService:UnbindAction("HudExit")
    ExitButton.Visible = false

    local v51 = v5
    local v52, v53

    if v51 then
        local v54 = not v6

        if v54 then
            local v55 = not v4

            if v55 then
                v52 = ExitButton.Visible and v3
                v53 = not v52
            else
                v53 = v55
            end
        else
            v53 = v54
        end
    else
        v53 = v51
    end

    v1.SideLeft.Visible = v53
    v1.SideRight.Visible = v53
end

function t1.init() -- line: 298
    -- upvalues: GuiService (copy), UserInputService (copy), Config (copy), Format (copy), Remotes (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (ref), Stats (ref), Hint (ref), ExitButton (ref), LeftButtons (ref), Label (ref), ImageLabel (ref), v4 (ref), v6 (ref), t3 (copy), bindCounter (copy), refresh (copy), placeExit (copy), exit (copy), Text (ref), Position (ref), Size (ref), showExitKey (copy)
    v1 = UIUtil.gui("HUD")
    v1.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    Stats = v1:WaitForChild("Stats")
    Hint = v1:WaitForChild("Hint")

    local Toasts = v1:WaitForChild("Toasts")

    Toasts.ToastTemplate.Size = UDim2.new(1, 0, 0, 32)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "ToastScale"
    UIScale.Parent = Toasts
    UIUtil.onScale(function(p18) -- line: 309
        -- upvalues: UIScale (copy)
        UIScale.Scale = math.max(p18, 0.5)
    end)

    local SideLeft = v1:WaitForChild("SideLeft")
    local SideRight = v1:WaitForChild("SideRight")

    SideLeft.AnchorPoint = Vector2.new(0, 0.5)

    local n1 = 1

    local function placeSideLeft() -- line: 319
        -- upvalues: SideLeft (copy), SideRight (copy), n1 (ref), GuiService (copy), v1 (ref), Stats (ref)
        local v57 = v1.AbsolutePosition + GuiService:GetGuiInset()
        local v58 = GuiService.TopbarInset.Max.Y - v57.Y + 10
        local v59 = Stats.AbsolutePosition.Y - v1.AbsolutePosition.Y - 10
        local Offset = SideLeft.Size.Y.Offset
        local v60 = n1
        local v63 = math.min(v60, math.max(v59 - v58, 0) / Offset)

        SideLeft.Scale.Scale = v63
        SideRight.Scale.Scale = v63

        local v64 = Offset * v63 / 2
        local v70 = math.clamp(v1.AbsoluteSize.Y / 2, v58 + v64, (math.max(v59 - v64, v58 + v64)))

        SideLeft.Position = UDim2.new(0, 12, 0, (math.round(v70)))
    end

    for _, v71 in { v1, Stats } do
        v71:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeSideLeft)
    end

    Stats:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeSideLeft)
    SideLeft:GetPropertyChangedSignal("Size"):Connect(placeSideLeft)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(placeSideLeft)
    UIUtil.onScale(function(p19) -- line: 338
        -- upvalues: n1 (ref), placeSideLeft (copy), UIUtil (copy), v1 (ref)
        local v72 = p19 * UIUtil.smallScreenBoost(p19, 1.4)

        v1.LeftButtons.Scale.Scale = v72 * 0.75
        n1 = v72
        placeSideLeft()
    end)

    local TopLeftButtons = v1:WaitForChild("TopLeftButtons")
    local TopRightButtons = v1:WaitForChild("TopRightButtons")
    local n2 = 44

    local function sizeTopButton(p20) -- line: 351
        -- upvalues: n2 (ref)
        if p20:IsA("GuiObject") then
            p20.Size = UDim2.fromOffset(n2, n2)
        end
    end

    local function placeTopLeft() -- line: 356
        -- upvalues: TopLeftButtons (copy), TopRightButtons (copy), n2 (ref), GuiService (copy), v1 (ref)
        local TopbarInset = GuiService.TopbarInset
        local v73 = v1.AbsolutePosition + GuiService:GetGuiInset()
        local v74 = math.max(TopbarInset.Height, 58) / 58

        n2 = math.round(v74 * 44)

        local v76 = TopbarInset.Min.Y + math.max(TopbarInset.Height, 58) - v74 * 46

        TopLeftButtons.AnchorPoint = Vector2.zero
        TopLeftButtons.Position = UDim2.fromOffset(TopbarInset.Min.X - v73.X + 12, (math.round(v76 - v73.Y)))
        TopLeftButtons.Size = UDim2.fromOffset(0, n2)

        for _, child in TopLeftButtons:GetChildren() do
            if child:IsA("GuiObject") then
                child.Size = UDim2.fromOffset(n2, n2)
            end
        end

        TopRightButtons.AnchorPoint = Vector2.new(1, 0)
        TopRightButtons.Position = UDim2.fromOffset(TopbarInset.Max.X - v73.X - 12, (math.round(v76 - v73.Y)))
        TopRightButtons.Size = UDim2.fromOffset(0, n2)

        for _, child in TopRightButtons:GetChildren() do
            if child:IsA("GuiObject") then
                child.Size = UDim2.fromOffset(n2, n2)
            end
        end
    end

    placeTopLeft()
    TopLeftButtons.ChildAdded:Connect(sizeTopButton)
    TopRightButtons.ChildAdded:Connect(sizeTopButton)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(placeTopLeft)
    v1:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeTopLeft)
    LeftButtons = v1:WaitForChild("LeftButtons")
    placeExit()
    ExitButton = LeftButtons:WaitForChild("ExitButton")
    ExitButton.Visible = false
    UIUtil.bindButton(ExitButton, exit)
    Label = ExitButton:WaitForChild("Label")

    local Text2, Position2, Size2 = Label.Text, Label.Position, Label.Size

    Text = Text2
    Position = Position2
    Size = Size2
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "PadGlyph"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.07, 0.5)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6)
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = Label.ZIndex + 1
    ImageLabel.Parent = ExitButton
    showExitKey()
    UserInputService.LastInputTypeChanged:Connect(showExitKey)
    UserInputService.JumpRequest:Connect(exit)
    UIUtil.onPanelMode(function(p21) -- line: 402
        -- upvalues: v6 (ref), refresh (copy)
        v6 = p21
        refresh()
    end)

    local function watchTutorial() -- line: 406
        -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), v1 (ref), v4 (ref), refresh (copy)
        local Tutorial = LocalPlayer:GetAttribute("Tutorial")
        local v81 = v4

        v4 = Tutorial ~= nil and Tutorial < Config.TutorialDone
        refresh()

        if v81 and not v4 then
            for _, v82 in {
                    v1.SideLeft,
                    v1.SideRight,
                    v1.TopLeftButtons,
                    v1.TopRightButtons
                } do
                for _, descendant in v82:GetDescendants() do
                    if descendant:IsA("GuiButton") then
                        UIUtil.pop(descendant, 0.4)
                    end
                end
            end
        end
    end

    LocalPlayer:GetAttributeChangedSignal("Tutorial"):Connect(watchTutorial)
    watchTutorial()
    bindCounter("Money")
    bindCounter("Strength")

    for v83, v84 in {
            Money = Config.Icons.Cash,
            Strength = Config.Icons.Strength
        } do
        local Icon = Stats[v83]:FindFirstChild("Icon")

        if Icon and Icon:IsA("ImageLabel") then
            Icon.Image = v84
        end
    end

    local Rate = Stats.Money.Rate
    local Rate2 = Stats.Strength.Rate

    local function refreshRates() -- line: 434
        -- upvalues: Rate (copy), Rate2 (copy), Config (copy), Format (copy), LocalPlayer (copy), t3 (copy)
        local Income = t3.Income or LocalPlayer:GetAttribute("Income") or 0

        Rate.Text = if Income > 0 then ("+%*/s"):format((Format.money(Income))) else ""

        local Character = LocalPlayer.Character
        local Lifting = Character and Character:GetAttribute("Lifting")
        local v86 = (LocalPlayer:GetAttribute("StrengthRate") or 0) * Config.repsPerSecond(Character, workspace:GetServerTimeNow())

        Rate2.Text = if Lifting then ("+%* XP/s"):format((Format.short(v86))) else ""
    end

    LocalPlayer:GetAttributeChangedSignal("Income"):Connect(refreshRates)
    task.spawn(function() -- line: 443
        -- upvalues: refreshRates (copy)
        while true do
            refreshRates()
            task.wait(0.3)
        end
    end)
    Remotes.Notify.OnClientEvent:Connect(function(p22, p23, p24) -- line: 452
        -- upvalues: UIUtil (copy), t1 (copy)
        if p22 ~= "bought" and p22 ~= "upgraded" and p22 ~= "gift" and p22 ~= "task" then
            if p22 == "cash" then
                UIUtil.sound("Cash", 0.7)
                t1.cashPopup(p23)
            else
                if p22 == "purchase" then
                    UIUtil.sound("Cash", 0.6, 1.2)
                end

                UIUtil.toast(p23, p22)
            end
        else
            local sound, v88

            if type(p23) ~= "string" or p23 == "" then
                return
            else
                sound = UIUtil.sound
                v88 = if p22 == "upgraded" then "LevelUpAgain" else "Cash"
            end

            sound(v88, 0.6, 1.2)

            local v90 = if type(p24) ~= "string" or p24 == "" then ("%*!"):format(p23) else ("%*! %*"):format(p23, p24)

            UIUtil.toast(v90, (p22 == "upgraded" or p22 == "task") and "success" or "purchase")
        end
    end)
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local InputMode = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("InputMode"))
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local v1 = Font.new("rbxasset://fonts/families/FredokaOne.json")
local t2 = {
    REF_HEIGHT = 982,
    MIN_SCALE = 0.34,
    STUDS_OFFSET = Vector3.new(0, 0.5, 0),
    TILT = -45,
    SIZE = Vector2.new(210, 54),
    POP = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SHRINK = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    SPIN = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
    FADE = TweenInfo.new(0.625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    SHOWN = {
        circle = 0.15,
        key = 0,
        keyText = 0,
        keyStroke = 0.4,
        text = 0,
        stroke = 0.3
    }
}
local t1 = {}

t1.LOOK = t2
t1.FONT = v1

local function isTouch() -- line: 44
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType == Enum.UserInputType.Touch then
        return true
    end

    if LastInputType ~= Enum.UserInputType.Keyboard and LastInputType ~= Enum.UserInputType.MouseButton1 and LastInputType ~= Enum.UserInputType.MouseButton2 and LastInputType ~= Enum.UserInputType.MouseMovement and LastInputType ~= Enum.UserInputType.MouseWheel then
        return UserInputService.TouchEnabled
    end

    return false
end

t1.IsTouch = isTouch

local self = setmetatable({}, {
    __mode = "k"
})

local function refreshKeycaps() -- line: 53
    -- upvalues: InputMode (copy), isTouch (copy), self (copy)
    local v3 = isTouch()
    local v4 = InputMode.Pad()

    for v5, v6 in pairs(self) do
        v5.Text = v3 and v6.key.touch or v6.key.pc
        v6.bg.Visible = not v4
        v6.icon.Visible = v4

        if v4 then
            v6.icon.Image = InputMode.Icon(v6.key.pad or Enum.KeyCode.ButtonX)
        end
    end
end

UserInputService.LastInputTypeChanged:Connect(refreshKeycaps)
InputMode.Changed:Connect(refreshKeycaps)

function t1.ScreenScale() -- line: 67
    -- upvalues: t2 (copy)
    local CurrentCamera = workspace.CurrentCamera

    return (math.clamp((CurrentCamera and CurrentCamera.ViewportSize.Y or t2.REF_HEIGHT) / t2.REF_HEIGHT, t2.MIN_SCALE, 1))
end

local function label(p1, p2, p3) -- line: 72
    -- upvalues: v1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p2
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = p3
    TextLabel.TextTransparency = 1
    TextLabel.FontFace = v1
    TextLabel.TextScaled = true
    TextLabel.Parent = p1

    return TextLabel
end

local function stroke(p4, p5, p6) -- line: 83
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p5
    UIStroke.Color = p6
    UIStroke.Transparency = 1
    UIStroke.Parent = p4

    return UIStroke
end

local function textStroke(p7, p8) -- line: 92
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 0.09
    UIStroke.Color = p8
    UIStroke.Transparency = 1
    UIStroke.Parent = p7
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize

    return UIStroke
end

function t1.Billboard(p9, p10, p11, p12) -- line: 98
    -- upvalues: PlayerGui (copy), t2 (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = p10
    BillboardGui.Size = UDim2.fromOffset(p11.X, p11.Y)
    BillboardGui.StudsOffset = p12 or t2.STUDS_OFFSET
    BillboardGui.AlwaysOnTop = true
    BillboardGui.ResetOnSpawn = false
    BillboardGui.Enabled = false
    BillboardGui.Active = true
    BillboardGui.Adornee = p9
    BillboardGui.Parent = PlayerGui

    return BillboardGui
end

local self2 = setmetatable({}, {
    __mode = "k"
})

local function contentWidth(p13) -- line: 116
    -- upvalues: TextService (copy)
    local Offset = p13.wrapper.Parent.Size.X.Offset
    local Visible = p13.bottom.Visible
    local v9 = Visible and p13.size.Y / 2 - 1 or p13.size.Y * 0.62
    local n1 = 0

    for _, v10 in ipairs(Visible and {
            p13.top,
            p13.bottom
        } or { p13.top }) do
        n1 = math.max(n1, (math.min(TextService:GetTextSize(v10.Text, v9, Enum.Font.FredokaOne, Vector2.new(10000, 10000)).X, Offset - p13.left)))
    end

    return p13.left + n1
end

local function centre(p14) -- line: 128
    -- upvalues: self2 (copy), contentWidth (copy)
    local wrapperParent = p14.wrapper.Parent
    local t7 = {}
    local n2 = 0

    for v13 in pairs(self2) do
        local wrapperParent2 = v13.wrapper.Parent

        if wrapperParent2 and wrapperParent2.Adornee == wrapperParent.Adornee and (v13 == p14 or wrapperParent2.Enabled) then
            t7[#t7 + 1] = v13
            n2 = math.max(n2, (contentWidth(v13)))
        end
    end

    for _, v15 in ipairs(t7) do
        local v16 = (v15.wrapper.Parent.Size.X.Offset - n2) / 2

        v15.wrapper.Position = UDim2.new(0.5, v16 * (v15.scaleTo or 1), 0.5, 0)
    end
end

function t1.Row(p15, p16, p17, p18) -- line: 145
    -- upvalues: v1 (copy), self (copy), refreshKeycaps (copy), self2 (copy)
    p18 = p18 or {
        pc = "E",
        touch = "TAP"
    }

    local Frame = Instance.new("Frame")

    Frame.Name = "Wrapper"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.Parent = p15

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pop"
    UIScale.Scale = 0
    UIScale.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "KeyCircle"
    Frame2.AnchorPoint = Vector2.new(0, 0.5)
    Frame2.Position = UDim2.fromScale(0, 0.5)
    Frame2.Size = UDim2.fromOffset(p16.Y, p16.Y)
    Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame2.BackgroundTransparency = 1
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0.5, 0)
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "KeyBg"
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame3.Position = UDim2.fromScale(0.5, 0.5)
    Frame3.Size = UDim2.fromScale(0.56, 0.56)
    Frame3.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Frame3.BackgroundTransparency = 1
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 8)
    Frame3.Parent = Frame2

    local v18 = Color3.fromRGB(80, 80, 80)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 1.5
    UIStroke.Color = v18
    UIStroke.Transparency = 1
    UIStroke.Parent = Frame3

    local v19 = Color3.fromRGB(15, 15, 15)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "KeyLabel"
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = v19
    TextLabel.TextTransparency = 1
    TextLabel.FontFace = v1
    TextLabel.TextScaled = true
    TextLabel.Parent = Frame3
    TextLabel.Size = UDim2.fromScale(1, 1)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "PadIcon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ImageTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(0.74, 0.74)
    ImageLabel.Visible = false
    ImageLabel.Parent = Frame2
    self[TextLabel] = {
        key = p18,
        bg = Frame3,
        icon = ImageLabel
    }

    local v20 = p16.Y + 8
    local v21 = Color3.fromRGB(255, 255, 255)
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "TopLabel"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.TextColor3 = v21
    TextLabel2.TextTransparency = 1
    TextLabel2.FontFace = v1
    TextLabel2.TextScaled = true
    TextLabel2.Parent = Frame
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

    local v22 = Color3.new(0, 0, 0)
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 0.09
    UIStroke2.Color = v22
    UIStroke2.Transparency = 1
    UIStroke2.Parent = TextLabel2
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize

    local v23 = Color3.fromRGB(210, 210, 210)
    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "BottomLabel"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.TextColor3 = v23
    TextLabel3.TextTransparency = 1
    TextLabel3.FontFace = v1
    TextLabel3.TextScaled = true
    TextLabel3.Parent = Frame
    TextLabel3.Position = UDim2.new(0, v20, 0.5, 1)
    TextLabel3.Size = UDim2.new(1, -v20, 0.5, -1)
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left

    local v24 = Color3.new(0, 0, 0)
    local UIStroke3 = Instance.new("UIStroke")

    UIStroke3.Thickness = 0.09
    UIStroke3.Color = v24
    UIStroke3.Transparency = 1
    UIStroke3.Parent = TextLabel3
    UIStroke3.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "TapTarget"
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.Text = ""
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 10
    TextButton.Parent = Frame

    if p17 then
        TextButton.Activated:Connect(p17)
    end

    refreshKeycaps()

    local t8 = {
        token = 0,
        wrapper = Frame,
        pop = UIScale,
        top = TextLabel2,
        bottom = TextLabel3,
        tap = TextButton,
        left = v20,
        size = p16,
        fades = {
            { Frame2, "BackgroundTransparency", "circle" },
            { Frame3, "BackgroundTransparency", "key" },
            { TextLabel, "TextTransparency", "keyText" },
            { UIStroke, "Transparency", "keyStroke" },
            { ImageLabel, "ImageTransparency", "keyText" },
            { TextLabel2, "TextTransparency", "text" },
            { UIStroke2, "Transparency", "stroke" },
            { TextLabel3, "TextTransparency", "text" },
            { UIStroke3, "Transparency", "stroke" }
        }
    }

    if p15:IsA("BillboardGui") then
        self2[t8] = true
    end

    return t8
end

function t1.Build(p19, p20, p21, p22) -- line: 221
    -- upvalues: t1 (copy), t2 (copy)
    local v25 = t1.Billboard(p19, p20, t2.SIZE)
    local v26 = t1.Row(v25, t2.SIZE, p21, p22)

    v26.bb = v25

    return v26
end

local function fadeTo(p23, p24) -- line: 228
    -- upvalues: TweenService (copy), t2 (copy)
    for _, v27 in ipairs(p23.fades) do
        local t9 = {}

        t9[v27[2]] = p24 and t2.SHOWN[v27[3]] or 1
        TweenService:Create(v27[1], t2.FADE, t9):Play()
    end
end

function t1.Show(p25, p26, p27, p28) -- line: 236
    -- upvalues: TweenService (copy), t1 (copy), t2 (copy), self2 (copy), centre (copy), fadeTo (copy)
    local v28 = p27 ~= nil and p27 ~= ""
    local top, bottom = p25.top, p25.bottom

    p26 = p26 or ""
    p27 = p27 or ""
    top.Text = p26
    bottom.Text = p27
    p25.bottom.Visible = v28

    if v28 then
        p25.top.AnchorPoint = Vector2.new(0, 1)
        p25.top.Position = UDim2.new(0, p25.left, 0.5, -1)
        p25.top.Size = UDim2.new(1, -p25.left, 0.5, -1)
    else
        p25.top.AnchorPoint = Vector2.new(0, 0.5)
        p25.top.Position = UDim2.new(0, p25.left, 0.5, 0)
        p25.top.Size = UDim2.new(1, -p25.left, 0.62, 0)
    end

    p25.token += 1

    if p25.bb then
        p25.bb.Enabled = true
    end

    local tap, tap2 = p25.tap, p25.tap

    tap.Active = true
    tap2.Interactable = true

    local wrapper, pop = p25.wrapper, p25.pop

    wrapper.Rotation = t2.TILT
    pop.Scale = 0
    p25.scaleTo = p28 or t1.ScreenScale()

    if self2[p25] then
        centre(p25)
    end

    TweenService:Create(p25.pop, t2.POP, {
        Scale = p25.scaleTo
    }):Play()
    TweenService:Create(p25.wrapper, t2.SPIN, {
        Rotation = 0
    }):Play()
    fadeTo(p25, true)
end

function t1.Hide(p29, p30) -- line: 260
    -- upvalues: TweenService (copy), t2 (copy), fadeTo (copy)
    p29.token += 1

    local token = p29.token

    p29.tap.Interactable = false
    TweenService:Create(p29.pop, t2.SHRINK, {
        Scale = 0
    }):Play()
    TweenService:Create(p29.wrapper, t2.SPIN, {
        Rotation = t2.TILT
    }):Play()
    fadeTo(p29, false)
    task.delay(t2.FADE.Time, function() -- line: 267
        -- upvalues: p29 (copy), p30 (copy), token (copy)
        if p29.token == token then
            if p29.bb and p29.bb.Parent then
                p29.bb.Enabled = false
            end

            if p30 then
                p30()
            end
        end
    end)
end

return t1

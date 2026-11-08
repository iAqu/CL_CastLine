-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)
local Log = require(ReplicatedStorage.Packages.Log)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Vector2.new(0, 1)
local v2 = Vector2.new(1, 1)
local v3 = UDim2.fromScale(0.335, 0.965)
local v4 = UDim2.fromScale(0.085, 0.15)
local v5 = Color3.fromRGB(255, 255, 255)
local v6 = Color3.fromRGB(15, 15, 20)
local t1 = {}
local v7 = t.strict(t.string)
local v8 = Log.new()
local v9 = GUI.PlayerGui()
local t2 = {}
local n1 = 0
local n2 = 0
local v10, v11

local function build(p1, p2, p3) -- line: 51
    local v12 = Instance.new(p1)

    for v13, v14 in p3 do
        v12[v13] = v14
    end

    v12.Parent = p2

    return v12
end

local t3 = {
    DisplayOrder = 5,
    Name = "ActionPrompts",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}
local ScreenGui = Instance.new("ScreenGui")

for v15, v16 in t3 do
    ScreenGui[v15] = v16
end

ScreenGui.Parent = nil

local t4 = {
    BackgroundTransparency = 1,
    Name = "Holder",
    Visible = false,
    AnchorPoint = v1,
    AutomaticSize = Enum.AutomaticSize.X,
    Position = v3,
    Size = UDim2.new(0, 0, v4.Y.Scale, 0)
}
local Frame = Instance.new("Frame")

for v17, v18 in t4 do
    Frame[v17] = v18
end

Frame.Parent = ScreenGui

local t5 = {
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    Padding = UDim.new(0.06, 0),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom
}
local UIListLayout = Instance.new("UIListLayout")

for v19, v20 in t5 do
    UIListLayout[v19] = v20
end

UIListLayout.Parent = Frame
ScreenGui.Parent = v9

local function paint(p4) -- line: 87
    -- upvalues: InputIconsConfig (copy)
    local v21 = if p4.key then InputIconsConfig.Image(p4.key) else nil

    p4.glyph.Image = v21 or ""
    p4.glyph.Visible = v21 ~= nil

    local text = p4.text

    if not p4.key or v21 then
        text.Text = p4.caption
    else
        local v22 = if p4.key == Enum.KeyCode.ButtonR3 then "Press right stick" else p4.key.Name

        text.Text = ("%*: %*"):format(v22, p4.caption)
    end
end

local function republish() -- line: 96
    -- upvalues: PlatformController (copy), t2 (copy), n2 (ref), Frame (copy), paint (copy)
    local v24 = PlatformController.IsConsole() and next(t2) ~= nil and n2 == 0

    Frame.Visible = v24

    for _, v25 in t2 do
        paint(v25)
    end
end

local function reposition() -- line: 105
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v10 (ref), v11 (ref), Frame (copy)
    local v26 = v1
    local v27 = v3

    if v10 ~= nil then
        v27 = UDim2.fromScale(v10, v3.Y.Scale)
    elseif v11 ~= nil then
        v26 = v2
        v27 = UDim2.fromScale(v11, v3.Y.Scale)
    end

    Frame.AnchorPoint = v26
    Frame.Position = v27
end

local function mint(p5, p6) -- line: 117
    -- upvalues: v5 (copy), v6 (copy), n1 (ref), Frame (copy)
    n1 += 1

    local t6 = {
        BackgroundTransparency = 1,
        Name = "Prompt",
        AutomaticSize = Enum.AutomaticSize.X,
        LayoutOrder = n1,
        Size = UDim2.new(0, 0, 0.26, 0)
    }
    local Frame2 = Instance.new("Frame")

    for v28, v29 in t6 do
        Frame2[v28] = v29
    end

    Frame2.Parent = nil

    local t7 = {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }
    local UIListLayout = Instance.new("UIListLayout")

    for v30, v31 in t7 do
        UIListLayout[v30] = v31
    end

    UIListLayout.Parent = Frame2

    local t8 = {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Name = "Icon",
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeYY
    }
    local ImageLabel = Instance.new("ImageLabel")

    for v32, v33 in t8 do
        ImageLabel[v32] = v33
    end

    ImageLabel.Parent = Frame2

    local t9 = {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Name = "Label",
        TextSize = 18,
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 0, 0.58, 0),
        TextColor3 = v5,
        TextXAlignment = Enum.TextXAlignment.Left
    }
    local TextLabel = Instance.new("TextLabel")

    for v34, v35 in t9 do
        TextLabel[v34] = v35
    end

    TextLabel.Parent = Frame2

    local t10 = {
        Thickness = 2.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = v6
    }
    local UIStroke = Instance.new("UIStroke")

    for v36, v37 in t10 do
        UIStroke[v36] = v37
    end

    UIStroke.Parent = TextLabel
    Frame2.Parent = Frame

    return {
        key = p5,
        caption = p6,
        row = Frame2,
        glyph = ImageLabel,
        text = TextLabel
    }
end

function t1.Present(p7, p8, p9) -- line: 167
    -- upvalues: PlatformController (copy), v7 (copy), v8 (copy), t2 (copy), paint (copy), republish (copy), mint (copy)
    v7(p7)
    v7(p9)
    assert(typeof(p8) == "EnumItem", (("hint %* was handed a %* where a KeyCode belongs"):format(p7, (typeof(p8)))))

    local v40 = t2[p7]

    if v40 ~= nil and v40.key == p8 and v40.caption == p9 then
        return
    end

    if v40 ~= nil then
        v40.key = p8
        v40.caption = p9
    else
        v40 = mint(p8, p9)
        t2[p7] = v40
    end

    paint(v40)
    republish()
    v8:AtDebug():Log((("hint %* now reads %* off %*; gamepad %*, glyph %*"):format(p7, p9, p8.Name, PlatformController.IsConsole(), v40.glyph.Image)))
end

function t1.PresentStatus(p10, p11) -- line: 192
    -- upvalues: t2 (copy), paint (copy), republish (copy), mint (copy)
    local v41 = t2[p10]

    if v41 and v41.caption == p11 then
        return
    end

    if v41 then
        v41.caption = p11
    else
        v41 = mint(nil, p11)
        t2[p10] = v41
    end

    paint(v41)
    republish()
end

function t1.SetNavigationLayer(p12) -- line: 205
    -- upvalues: ScreenGui (copy)
    ScreenGui.DisplayOrder = if p12 then math.max(5, p12 + 1) else 5
end

function t1.Retract(p13) -- line: 209
    -- upvalues: v7 (copy), t2 (copy), republish (copy)
    v7(p13)

    local v44 = t2[p13]

    if v44 == nil then
        return
    end

    t2[p13] = nil
    v44.row:Destroy()
    republish()
end

function t1.IsPresent(p14) -- line: 222
    -- upvalues: v7 (copy), t2 (copy)
    v7(p14)

    return t2[p14] ~= nil
end

function t1.Hide() -- line: 228
    -- upvalues: n2 (ref), republish (copy)
    n2 += 1
    republish()

    local v45 = false

    return function() -- line: 232
        -- upvalues: v45 (ref), n2 (ref), republish (copy)
        if v45 then
            return
        end

        v45 = true
        n2 -= 1
        republish()
    end
end

function t1.PinLeft(p15) -- line: 242
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v10 (ref), v11 (ref), Frame (copy)
    v10 = p15

    local v46 = v1
    local v47 = v3

    if v10 ~= nil then
        v47 = UDim2.fromScale(v10, v3.Y.Scale)
    elseif v11 ~= nil then
        v46 = v2
        v47 = UDim2.fromScale(v11, v3.Y.Scale)
    end

    Frame.AnchorPoint = v46
    Frame.Position = v47
end

function t1.PinRight(p16) -- line: 247
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v10 (ref), v11 (ref), Frame (copy)
    v11 = p16

    local v48 = v1
    local v49 = v3

    if v10 ~= nil then
        v49 = UDim2.fromScale(v10, v3.Y.Scale)
    elseif v11 ~= nil then
        v48 = v2
        v49 = UDim2.fromScale(v11, v3.Y.Scale)
    end

    Frame.AnchorPoint = v48
    Frame.Position = v49
end

PlatformController.Changed:Connect(republish)
InputIconsConfig.Changed:Connect(republish)
republish()

return t1

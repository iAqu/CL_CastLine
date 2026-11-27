-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local ThrowCap = require(script.Parent.Parent.Fishing.ThrowCap)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(120, 128, 145)
local ScreenGui, ScrollingFrame, v2

local function row(p1, p2, p3) -- line: 32
    -- upvalues: Config (copy), Format (copy), UIUtil (copy), Kit (copy), Style (copy), ThrowCap (copy), v1 (copy), ScrollingFrame (ref)
    local v3 = p2 == 0
    local v4 = Config.Biomes[p2]
    local v6 = Style.card(ScrollingFrame, if v3 then Style.OCEAN else v4.Color, {
        Name = if v3 then "Full" else "Biome" .. p2,
        LayoutOrder = p1,
        Size = UDim2.new(1, -12, 0, 92)
    })

    Style.text(v6, if v3 then "💪 Full Power" else ("%* %*"):format(v4.Icon or "", v4.Name), {
        Name = "Title",
        ZIndex = 2,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(22, 10),
        Size = UDim2.new(1, -230, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Style.text(v6, if v3 then ("Throw your furthest: %*m"):format((Format.short((math.floor((ThrowCap.fullThrow())))))) else ("Casts land in here, up to %*m"):format((Format.short(Config.capMeters(p2)))), {
        Name = "Detail",
        ZIndex = 2,
        Position = UDim2.fromOffset(22, 52),
        Size = UDim2.new(1, -230, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(220, 228, 240)
    })

    local v9 = p2 == p3
    local button = Kit.button
    local v11 = if v9 then "ON" else "PICK"
    local v10 = if v9 then Style.BUY else v1

    button(v6, v11, v10, {
        Name = "Pick",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(170, 62)
    }, function() -- line: 63
        -- upvalues: p2 (copy), v9 (copy), UIUtil (copy), ThrowCap (copy)
        if not v9 then
            ThrowCap.set(p2)
            UIUtil.sound("Click", 0.6)
        end
    end).Label.ZIndex = 4
end

local function render() -- line: 73
    -- upvalues: ThrowCap (copy), ScreenGui (ref), ScrollingFrame (ref), v2 (ref), row (copy)
    if ScreenGui and ScreenGui.Enabled then
        local v12 = ThrowCap.topBiome()
        local v13 = ThrowCap.current()
        local v14 = ThrowCap.firstBiome()
        local v15 = ("%*/%*/%*"):format(v12, v13, v14)

        if v15 == v2 then
            return
        end

        v2 = v15

        for _, child in ScrollingFrame:GetChildren() do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        row(0, 0, v13)

        for i = v12 - 1, v14, -1 do
            row(v12 - i, i, v13)
        end
    end
end

local function build() -- line: 94
    -- upvalues: Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), ScrollingFrame (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PowerPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false

    local v16 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(780, 640),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v16, 24)
    Kit.stroke(v16, 6)
    Style.gradient(v16, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v16, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v16

    local v17 = Kit.frame(v16, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v17, 22)
    Kit.stroke(v17, 5)
    Style.gradient(v17, ColorSequence.new(Style.TEAL, Style.OCEAN), 0)
    Kit.studs(v17, 0.5, 48, 22)
    Style.bubble(v17, "💪", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })

    local v18 = Kit.text(v17, "POWER", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 24),
        Size = UDim2.fromOffset(460, 70),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Style.gradient(v18, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    Kit.button(v17, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 142
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4
    Style.text(v16, "Pick how far you throw. Go back for the animals you missed!", {
        Name = "Hint",
        StrokeThickness = 3,
        Position = UDim2.fromOffset(26, 130),
        Size = UDim2.new(1, -52, 0, 32),
        TextColor3 = Color3.fromRGB(200, 210, 230)
    })
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Position = UDim2.fromOffset(26, 174)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Size = UDim2.new(1, -52, 1, -200)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.CanvasSize = UDim2.new()
    ScrollingFrame.ScrollBarThickness = 8

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.ScrollingDirection = Enum.ScrollingDirection.Y

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 12)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    ScrollingFrame.Parent = v16

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function makeGear(p4, p5) -- line: 173
    -- upvalues: UIUtil (copy)
    local Value = p4:WaitForChild("Value")
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "PowerGear"
    TextButton.BackgroundTransparency = 1
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Size = UDim2.fromOffset(50, 50)
    TextButton.Text = "⚙️"
    TextButton.TextScaled = true
    TextButton.ZIndex = Value.ZIndex + 1
    TextButton.Parent = p4

    local function place() -- line: 184
        -- upvalues: p4 (copy), Value (copy), TextButton (copy)
        local v20 = math.max(if p4.Size.Y.Offset > 0 then p4.AbsoluteSize.Y / p4.Size.Y.Offset else 1, 0.001)
        local v21 = (Value.AbsolutePosition.X - p4.AbsolutePosition.X) / v20
        local v22 = (Value.AbsolutePosition.Y + Value.AbsoluteSize.Y / 2 - p4.AbsolutePosition.Y) / v20

        TextButton.Position = UDim2.fromOffset(v21 + Value.TextBounds.X / v20 + 8 + 25, v22)
    end

    Value:GetPropertyChangedSignal("TextBounds"):Connect(place)
    Value:GetPropertyChangedSignal("AbsolutePosition"):Connect(place)
    p4:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
    place()
    UIUtil.bindButton(TextButton, p5)
end

function t1.isOpen() -- line: 200
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open() -- line: 204
    -- upvalues: UIUtil (copy), t1 (copy), ScreenGui (ref), v2 (ref), render (copy)
    if t1.isOpen() then
        return
    end

    UIUtil.openPanel(ScreenGui)
    v2 = nil
    render()
end

function t1.close() -- line: 212
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    UIUtil.closePanel(ScreenGui)
end

function t1.init(p6, p7) -- line: 217
    -- upvalues: ThrowCap (copy), render (copy), build (copy), makeGear (copy)
    build()
    ThrowCap.init()
    ThrowCap.onChanged(render)
    makeGear(p6, p7)
end

return t1

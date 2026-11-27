-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local t1 = {
    HEIGHT = 44,
    BOTTOM_GAP = 2,
    DARK = Color3.fromRGB(18, 18, 21),
    Hidden = nil,
    Opened = 0
}
local ScreenGui, Frame

local function ensure() -- line: 23
    -- upvalues: GuiService (copy), Players (copy), RunService (copy), HUD (copy), t1 (copy), ScreenGui (ref), Frame (ref)
    if Frame then
        return Frame
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TopBar"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 11

    local ScreenGui2 = ScreenGui

    ScreenGui2.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    Frame = Instance.new("Frame")
    Frame.Name = "Row"
    Frame.BackgroundTransparency = 1

    local Frame2 = Frame

    Frame2.AutomaticSize = Enum.AutomaticSize.X

    local Frame3 = Frame

    Frame3.Size = UDim2.fromOffset(0, t1.HEIGHT)
    Frame.Parent = ScreenGui

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 12)
    UIListLayout.Parent = Frame

    local function place() -- line: 46
        -- upvalues: GuiService (copy), t1 (copy), Frame (ref)
        local TopbarInset = GuiService.TopbarInset
        local v1 = if TopbarInset.Height > 0 then TopbarInset.Height else 58

        Frame.Position = UDim2.fromOffset(math.max(TopbarInset.Min.X, 12) + 8, TopbarInset.Min.Y + math.max(v1 - t1.HEIGHT - t1.BOTTOM_GAP, 0))
    end

    local TopbarInset = GuiService.TopbarInset
    local v4 = if TopbarInset.Height > 0 then TopbarInset.Height else 58
    local Frame4 = Frame

    Frame4.Position = UDim2.fromOffset(math.max(TopbarInset.Min.X, 12) + 8, TopbarInset.Min.Y + math.max(v4 - t1.HEIGHT - t1.BOTTOM_GAP, 0))
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(place)
    RunService.RenderStepped:Connect(function() -- line: 53
        -- upvalues: HUD (copy), t1 (copy), ScreenGui (ref)
        local ScreenGui2 = ScreenGui

        if HUD.GetMode() == "cutscene" then
            ScreenGui2.Enabled = false
        else
            ScreenGui2.Enabled = not (t1.Hidden and t1.Hidden())
        end
    end)

    local ScreenGui3 = ScreenGui
    local Frame5 = Frame

    t1.Gui = ScreenGui3
    t1.Row = Frame5

    return Frame
end

function t1.Add(p1, p2) -- line: 61
    -- upvalues: ensure (copy)
    p1.LayoutOrder = p2
    p1.Parent = ensure()
end

function t1.RoundButton(p3, p4) -- line: 67
    -- upvalues: UIKit (copy), t1 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p3
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Size = UDim2.fromOffset(t1.HEIGHT, t1.HEIGHT)
    TextButton.BackgroundColor3 = t1.DARK
    TextButton.BackgroundTransparency = 0.08
    TextButton.BorderSizePixel = 0
    UIKit.corner(TextButton, t1.HEIGHT / 2)
    t1.Add(TextButton, p4)

    return TextButton
end

local function outline(p5, p6, p7, p8, p9, p10) -- line: 82
    -- upvalues: UIKit (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p6
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(p7.X, p7.Y)
    Frame.Position = p8
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    UIKit.corner(Frame, p9)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p10
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Parent = Frame
    Frame.Parent = p5

    return Frame
end

function t1.ToggleInventory() -- line: 99
    -- upvalues: UIKit (copy), t1 (copy)
    local MyFish = UIKit.Windows.MyFish

    if MyFish then
        MyFish.Toggle()
        t1.Opened += 1
    end
end

function t1.Init() -- line: 107
    -- upvalues: UserInputService (copy), UIKit (copy), HUD (copy), t1 (copy), ensure (copy), outline (copy)
    ensure()

    local v7 = t1.RoundButton("Backpack", 10)
    local Frame = Instance.new("Frame")

    Frame.Name = "Icon"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(26, 26)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Parent = v7
    outline(Frame, "Handle", Vector2.new(10, 7), UDim2.new(0.5, 0, 0, 3), 3, 2.5)
    outline(Frame, "Body", Vector2.new(20, 19), UDim2.new(0.5, 0, 0, 15.5), 6, 2.5)
    outline(Frame, "Pocket", Vector2.new(11, 6), UDim2.new(0.5, 0, 0, 19), 2, 2)
    UIKit.bindPress(v7, t1.ToggleInventory)

    local function refresh() -- line: 122
        -- upvalues: v7 (copy), HUD (copy)
        v7.Visible = HUD.IsTouch()
    end

    v7.Visible = HUD.IsTouch()
    HUD.TouchChanged:Connect(refresh)
    t1.BackpackButton = v7
    UserInputService.InputBegan:Connect(function(p11, p12) -- line: 130
        -- upvalues: HUD (copy), t1 (copy)
        if not p12 and p11.KeyCode == Enum.KeyCode.Backquote then
            local v8 = HUD.GetMode()

            if v8 == "normal" or v8 == "training" then
                t1.ToggleInventory()
            end
        end
    end)
end

return t1

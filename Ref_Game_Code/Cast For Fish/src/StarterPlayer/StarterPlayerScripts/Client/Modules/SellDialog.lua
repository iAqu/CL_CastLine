-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Events = require(Shared.Data.Events)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local FishIcons = require(script.Parent.FishIcons)
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local t1 = {}

t1.__index = t1
t1.ACCENT = Colors.Pink
t1.ACCENT2 = Colors.Magenta
t1.WIDTH = 640
t1.HEIGHT = 700
t1.COUNT_TIME = 0.55
t1.Opened = 0
t1.WARN_THRILL = 3

function t1:Needed() -- line: 27
    -- upvalues: Fish (copy), Sizes (copy), Roll (copy), t1 (copy)
    if self == nil or Fish.ById[self.id] == nil then
        return false
    end

    return Roll.thrill(self.id, self.v or 1, self.s or Sizes.NORMAL_INDEX) >= t1.WARN_THRILL
end

local function hex(p2) -- line: 31
    return string.format("#%02X%02X%02X", math.floor(p2.R * 255 + 0.5), math.floor(p2.G * 255 + 0.5), (math.floor(p2.B * 255 + 0.5)))
end

function t1.new() -- line: 35
    -- upvalues: UIKit (copy), Colors (copy), fromRGB (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.OnSell = nil
    self.Payout = 0
    self.OpenedAt = 0
    self.Conn = nil

    local v7 = UIKit.screenGui("SellConfirm", 15)

    v7.ScreenInsets = Enum.ScreenInsets.None
    v7.Enabled = false
    self.Gui = v7

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Dim"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 0.45
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.Position = UDim2.fromScale(0.5, 0.5)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.ZIndex = 1
    TextButton.Parent = v7
    TextButton.Activated:Connect(function() -- line: 59
        -- upvalues: self (copy)
        self:Close()
    end)
    self.Dim = TextButton

    local ACCENT, ACCENT2 = self.ACCENT, self.ACCENT2
    local v8 = UIKit.frame(v7, {
        Name = "Wrap",
        Transparency = 1,
        ZIndex = 10,
        Size = UDim2.fromOffset(self.WIDTH, self.HEIGHT),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    self.Wrap = v8

    local v9 = UIKit.frame(v8, {
        Name = "Panel",
        Transparency = 1,
        ZIndex = 10,
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    self.Panel = v9
    UIKit.image(v9, "Glow", {
        Transparency = 0.3,
        ZIndex = 9,
        Size = UDim2.new(1, 150, 1, 150),
        Position = UDim2.new(0.5, 0, 0.5, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(0, 0, 0)
    }).ScaleType = Enum.ScaleType.Stretch

    local v10 = UIKit.frame(v9, {
        Name = "Body",
        Corner = 26,
        Stroke = 7,
        ZIndex = 10,
        Color = ACCENT:Lerp(fromRGB(18, 20, 44), 0.74),
        Color2 = fromRGB(12, 13, 28)
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Pattern"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = UIKit.Art.Bubbles
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset(190, 190)
    ImageLabel.ImageColor3 = ACCENT:Lerp(fromRGB(255, 255, 255), 0.5)
    ImageLabel.ImageTransparency = 0.9
    ImageLabel.ZIndex = 10
    UIKit.corner(ImageLabel, 26)
    ImageLabel.Parent = v10

    local v11 = UIKit.frame(v10, {
        Name = "Rim",
        Transparency = 1,
        Corner = 22,
        ZIndex = 10,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5)
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = ACCENT:Lerp(fromRGB(255, 255, 255), 0.55)
    UIStroke.Transparency = 0.55
    UIStroke.Parent = v11

    local v12 = UIKit.frame(v9, {
        Name = "Header",
        Corner = 24,
        ZIndex = 11,
        Size = UDim2.new(1, 0, 0, 78),
        Color = ACCENT,
        Color2 = ACCENT2
    })

    UIKit.stroke(v12, 6)

    local v13 = UIKit.frame(v12, {
        Class = "CanvasGroup",
        Name = "SheenClip",
        Transparency = 1,
        Corner = 24,
        ZIndex = 11
    })

    UIKit.frame(v13, {
        Name = "Lip",
        Transparency = 0.72,
        ZIndex = 11,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        Color = fromRGB(0, 0, 0)
    })
    UIKit.frame(v13, {
        Name = "Gloss",
        Transparency = 0.7,
        Corner = 11,
        ZIndex = 11,
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.fromOffset(12, 7),
        Color = Colors.White
    })

    for i = 0, 2 do
        UIKit.frame(v13, {
            Name = "Sheen",
            Transparency = 0.8,
            ZIndex = 11,
            Size = UDim2.fromOffset(26 - i * 6, 200),
            Position = UDim2.new(0.62, i * 46, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Colors.White
        }).Rotation = 24
    end

    local v14 = UIKit.text(v9, {
        Name = "Title",
        Text = "Sell this fish?",
        TextSize = 50,
        Stroke = 6,
        ZIndex = 13,
        Size = UDim2.new(1, -200, 0, 74),
        Position = UDim2.fromOffset(106, 0),
        XAlign = Enum.TextXAlignment.Left
    })

    UIKit.gradient(v14, Colors.White, ACCENT:Lerp(Colors.White, 0.7))
    v14.TextScaled = true
    self.Title = v14

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 50
    UITextSizeConstraint.Parent = v14
    UIKit.icon(v9, "Cash", {
        ZIndex = 14,
        Rotation = -8,
        Size = UDim2.fromOffset(96, 96),
        Position = UDim2.fromOffset(6, -14)
    }).Name = "WindowIcon"
    UIKit.button(v9, {
        Name = "Close",
        Text = "X",
        Corner = 29,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.fromOffset(58, 58),
        Position = UDim2.new(1, -12, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 109
            -- upvalues: self (copy)
            self:Close()
        end
    })
    self.Rays = UIKit.image(v9, "Rays", {
        Transparency = 0.55,
        ZIndex = 11,
        Size = UDim2.fromOffset(330, 330),
        Position = UDim2.new(0.5, 0, 0, 196),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    self.Glow = UIKit.image(v9, "Glow", {
        Transparency = 0.4,
        ZIndex = 11,
        Size = UDim2.fromOffset(260, 260),
        Position = UDim2.new(0.5, 0, 0, 196),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    self.Tile = UIKit.frame(v9, {
        Name = "Tile",
        Corner = 24,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.fromOffset(176, 176),
        Position = UDim2.new(0.5, 0, 0, 196),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.Panel
    })
    UIKit.image(self.Tile, "Glow", {
        Transparency = 0.45,
        ZIndex = 12,
        Size = UDim2.fromScale(1.1, 1.1),
        Position = UDim2.fromScale(0.5, 0.55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.White
    })
    self.Picture = UIKit.frame(self.Tile, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.fromOffset(8, 8)
    })
    self.Tags = UIKit.text(v9, {
        Name = "Tags",
        Text = "",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, -60, 0, 32),
        Position = UDim2.fromOffset(30, 296)
    })
    self.Tags.RichText = true
    self.Name = UIKit.text(v9, {
        Name = "FishName",
        Text = "",
        TextSize = 50,
        Stroke = 6,
        ZIndex = 13,
        Size = UDim2.new(1, -60, 0, 56),
        Position = UDim2.fromOffset(30, 326)
    })
    self.Rate = UIKit.text(v9, {
        Name = "Rate",
        Text = "",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, -60, 0, 32),
        Position = UDim2.fromOffset(30, 382),
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })

    local v15 = UIKit.frame(v9, {
        Name = "Payout",
        Transparency = 0.45,
        Corner = 24,
        ZIndex = 12,
        Size = UDim2.new(1, -64, 0, 128),
        Position = UDim2.new(0.5, 0, 0, 432),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(6, 8, 20)
    })

    UIKit.text(v15, {
        Name = "Caption",
        Text = "YOU'LL GET",
        TextSize = 26,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.fromOffset(0, 12),
        Color = fromRGB(180, 190, 225)
    })

    local v16 = UIKit.frame(v15, {
        Name = "Row",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.new(1, 0, 0, 80),
        Position = UDim2.fromOffset(0, 42)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v16
    self.PayoutBox = v15
    self.CashIcon = UIKit.icon(v16, "Cash", {
        ZIndex = 14,
        Rotation = -6,
        Size = UDim2.fromOffset(78, 78)
    })
    self.CashIcon.LayoutOrder = 1
    self.Amount = UIKit.text(v16, {
        Name = "Amount",
        Text = "",
        TextSize = 64,
        Stroke = 7,
        ZIndex = 14,
        Size = UDim2.fromOffset(0, 74),
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    self.Amount.AutomaticSize = Enum.AutomaticSize.X
    self.Amount.LayoutOrder = 2
    self.CancelButton = UIKit.button(v9, {
        Name = "Cancel",
        Text = "CANCEL",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(260, 80),
        Position = UDim2.new(0.5, -142, 1, -24),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Grey,
        Color2 = Colors.GreyDark,
        OnClick = function() -- OnClick | line: 141
            -- upvalues: self (copy)
            self:Close()
        end
    })
    self.SellButton = UIKit.button(v9, {
        Name = "Sell",
        Text = "SELL",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(260, 80),
        Position = UDim2.new(0.5, 142, 1, -24),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 144
            -- upvalues: self (copy)
            self:Confirm()
        end
    })

    return self
end

function t1:Layout() -- line: 150
    -- upvalues: UIKit (copy)
    local Wrap = self.Wrap
    local v17 = Wrap:FindFirstChild("PhoneScale") or Instance.new("UIScale")

    v17.Name = "PhoneScale"
    v17.Parent = Wrap

    local FitScale = self.Gui:FindFirstChild("FitScale")
    local v19 = math.max(if FitScale then FitScale.Scale else 1, 0.05)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v20 = UIKit.topInset()

    v17.Scale = math.min((ViewportSize.Y - v20 - 16) / (self.HEIGHT * v19), 1)
    Wrap.Position = UDim2.new(0.5, 0, 0.5, v20 / v19 / 2)
end

function t1:Fill(p5) -- line: 164
    -- upvalues: Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), Events (copy), Roll (copy), NumberFormat (copy), FishIcons (copy), Colors (copy)
    local v22 = Fish.ById[p5.id]
    local v23 = Rarities.ById[v22 and v22.rarity or ""] or Rarities.ById.Common
    local v24 = Variants.List[p5.v] or Variants.List[1]
    local v25 = Sizes.List[p5.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local Tile = self.Tile

    Tile.BackgroundColor3 = Colors.White

    local v26 = Tile:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

    v26.Rotation = 90
    v26.Color = ColorSequence.new(v23.Color, v23.Color2 or v23.Color)
    v26.Parent = Tile
    self.Glow.ImageColor3 = v23.Color
    self.Rays.ImageColor3 = v23.Color:Lerp(Colors.White, 0.4)
    self.Picture:ClearAllChildren()
    FishIcons.Picture(self.Picture, p5.id, p5.v, 1.1)

    local v27 = v23.Color:Lerp(Colors.White, 0.25)
    local t6 = { ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(v27.R * 255 + 0.5), math.floor(v27.G * 255 + 0.5), (math.floor(v27.B * 255 + 0.5))), string.upper(v23.name or v23.id or "")) }
    local v33 = p5.e and Events.ById[p5.e]

    if v33 then
        local Color = v33.Color

        table.insert(t6, ("<font color=\"%s\">%s x%d</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v33.mutation), v33.mult))
    end

    if v24.index >= 2 then
        local Color = v24.Color

        table.insert(t6, ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v24.id)))
    end

    if v25.index ~= Sizes.NORMAL_INDEX then
        local Color = v25.Color

        table.insert(t6, ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v25.id)))
    end

    self.Tags.Text = table.concat(t6, "  ")

    local _, _, v53 = v23.Color:ToHSV()

    self.Name.Text = v22 and v22.name or "Fish"
    self.Name.TextColor3 = v23.Color:Lerp(Colors.White, v53 < 0.6 and 0.75 or 0.35)
    self.Rate.Text = "Earns " .. NumberFormat.rate(Roll.incomeOf(p5))
    self.Payout = Roll.sellOf(p5)
    self.Amount.Text = "+" .. NumberFormat.money(0)
end

function t1:Step() -- line: 199
    -- upvalues: NumberFormat (copy), UIKit (copy)
    local v54 = os.clock() - self.OpenedAt

    self.Rays.Rotation = v54 * 25
    self.Glow.ImageTransparency = 0.45 - math.sin(v54 * 3) * 0.15
    self.CashIcon.Rotation = math.sin(v54 * 4) * 5 + -6

    local v58 = math.clamp(v54 / self.COUNT_TIME, 0, 1)
    local v59 = self.Payout * (1 - (1 - v58) ^ 3)
    local Amount = self.Amount
    local money = NumberFormat.money

    if v58 >= 1 then
        v59 = self.Payout
    elseif v59 < 1E+15 then
        v59 = math.floor(v59)
    end

    Amount.Text = "+" .. money(v59)

    if not (v58 >= 1) or self.Landed then
        return
    end

    self.Landed = true
    UIKit.pop(self.Amount, 1.25)
    UIKit.sound("Coin")
end

function t1:Ask(p8, p9) -- line: 214
    -- upvalues: RunService (copy), Fish (copy), UIKit (copy), t1 (copy)
    if not (p8 and Fish.ById[p8.id]) then
        return
    end

    self.Title.Text = t1.Needed(p8) and "Sell this rare fish?" or "Sell this fish?"
    t1.Opened += 1
    self.OnSell = p9
    self:Fill(p8)
    self.OpenedAt = os.clock()
    self.Landed = false
    self:Layout()
    self.Dim.Size = UDim2.fromScale(1.05, 1.05)
    self.Gui.Enabled = true
    UIKit.pop(self.Panel, 0.8)
    UIKit.pop(self.Tile, 0.6)
    UIKit.sound("WindowOpen")

    if self.Conn then
        self.Conn:Disconnect()
    end

    self.Conn = RunService.RenderStepped:Connect(function() -- line: 233
        -- upvalues: self (copy)
        self:Step()
    end)
    game:GetService("ContextActionService"):BindActionAtPriority("SellDialogCancel", function(_, p11) -- line: 236
        -- upvalues: self (copy)
        if p11 == Enum.UserInputState.Begin then
            self:Close()
        end

        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.ButtonB)

    if game:GetService("UserInputService").GamepadEnabled then
        game:GetService("GuiService").SelectedObject = self.CancelButton
    end
end

function t1:Close() -- line: 247
    -- upvalues: UIKit (copy)
    game:GetService("ContextActionService"):UnbindAction("SellDialogCancel")

    local GuiService = game:GetService("GuiService")

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(self.Gui) then
        GuiService.SelectedObject = nil
    end

    if self.Conn then
        self.Conn:Disconnect()
        self.Conn = nil
    end

    self.OnSell = nil

    if self.Gui.Enabled then
        UIKit.sound("WindowClose")
    end

    self.Gui.Enabled = false
end

function t1:Confirm() -- line: 264
    -- upvalues: UIKit (copy)
    local OnSell = self.OnSell

    self:Close()

    if OnSell then
        UIKit.sound("Cash")
        OnSell()
    end
end

function t1:IsOpen() -- line: 273
    return self.Gui.Enabled
end

t1.Shared = t1.new()

return t1

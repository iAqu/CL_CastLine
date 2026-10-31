-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local Parent = script.Parent
local ShopUI = require(Parent.ShopUI)
local Sounds = require(Parent.Sounds)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 30
    -- upvalues: ShopUI (copy), t1 (copy)
    local self = setmetatable({}, t1)
    local v2 = ShopUI.Frame({
        Name = "AreaBanner",
        Transparency = 1,
        ZIndex = 28,
        Parent = p1,
        Size = UDim2.fromScale(0.62, 0.075),
        Position = UDim2.fromScale(0.5, 0.215),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(0, 0, 0)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.28, 0),
        NumberSequenceKeypoint.new(0.72, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v2
    self.Band = v2

    local v3 = ShopUI.Text({
        Name = "AreaName",
        Text = "",
        ZIndex = 29,
        Stroke = 4,
        Parent = v2,
        Size = UDim2.fromScale(0.8, 0.86),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local v4 = ShopUI.Text({
        Name = "Emoji",
        Text = "",
        ZIndex = 29,
        Stroke = false,
        Parent = v2,
        Size = UDim2.fromScale(1.1, 1.1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    v4.SizeConstraint = Enum.SizeConstraint.RelativeYY
    self.Name = v3
    self.NameStroke = v3:FindFirstChild("TextStroke")
    self.Emoji = v4
    self.NameScale = Instance.new("UIScale")
    self.NameScale.Parent = v3
    self.EmojiScale = Instance.new("UIScale")
    self.EmojiScale.Parent = v4

    local function layout() -- line: 51
        -- upvalues: v3 (copy), v4 (copy)
        local X = v3.TextBounds.X
        local X2 = v4.AbsoluteSize.X
        local v5 = X2 * 0.12
        local v6 = X + v5 + X2

        v3.Position = UDim2.new(0.5, -(v6 - X) / 2, 0.5, 0)
        v4.Position = UDim2.new(0.5, -v6 / 2 + X + v5, 0.5, 0)
    end

    v3:GetPropertyChangedSignal("TextBounds"):Connect(layout)
    v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    self.Index = nil
    self.Shown = false
    self.Dead = false

    return self
end

function t1:SetArea(p3) -- line: 67
    -- upvalues: AreasConfig (copy), ShopUI (copy), Sounds (copy)
    if self.Dead or p3 == self.Index then
        return
    end

    self.Index = p3

    local v7 = p3 and AreasConfig.Get(p3)

    if not v7 then
        self.Band.Visible = false

        return
    end

    self.Band.Visible = true
    self.Name.Text = v7.Name
    self.Name.TextColor3 = v7.Color

    if self.NameStroke then
        self.NameStroke.Color = v7.Color:Lerp(Color3.new(0, 0, 0), 0.68)
    end

    self.Emoji.Text = v7.Emoji or ""

    if not self.Shown then
        self.Shown = true
        ShopUI.Tween(self.Band, {
            BackgroundTransparency = 0.55
        }, 0.25)
    end

    self.NameScale.Scale = 1.3
    ShopUI.Tween(self.NameScale, {
        Scale = 1
    }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    self.EmojiScale.Scale = 0.3
    ShopUI.Tween(self.EmojiScale, {
        Scale = 1
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Sounds.Play("Pop", {
        Volume = 0.3
    })
end

function t1:FadeOut(p5) -- line: 92
    -- upvalues: ShopUI (copy)
    if self.Dead then
        return
    end

    p5 = p5 or 0.25
    ShopUI.Tween(self.Band, {
        BackgroundTransparency = 1
    }, p5)
    ShopUI.Tween(self.Name, {
        TextTransparency = 1
    }, p5)
    ShopUI.Tween(self.Emoji, {
        TextTransparency = 1
    }, p5)

    if self.NameStroke then
        ShopUI.Tween(self.NameStroke, {
            Transparency = 1
        }, p5)
    end

    task.delay(p5, function() -- line: 99
        -- upvalues: self (copy)
        self:Destroy()
    end)
end

function t1:Destroy() -- line: 102
    if not self.Dead then
        self.Dead = true
        self.Band:Destroy()
    end
end

return t1

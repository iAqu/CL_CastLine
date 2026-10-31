-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local UIKit = require(script.Parent.UIKit)
local t1 = {}

t1.__index = t1

local Colors = UITheme.Colors
local t2 = {
    Area = 0.12,
    Mutation = 0.17,
    Name = 0.32,
    Size = 0.2,
    Rarity = 0.18,
    Income = 0.2
}

local function setShown(p1, p2) -- line: 48
    p1.TextTransparency = p2 and 0 or 1

    local TextStroke = p1:FindFirstChild("TextStroke")

    if TextStroke then
        TextStroke.Transparency = p2 and 0 or 1
    end
end

function t1.new(p3, p4) -- line: 56
    -- upvalues: UITheme (copy), Mutations (copy), UIKit (copy), t1 (copy), Colors (copy), t2 (copy)
    p4 = p4 or {}

    local self = setmetatable({}, t1)

    self.Compact = p4.Compact ~= false

    local v3 = UIKit.Frame({
        Name = "RevealInfo",
        Transparency = 1,
        ZIndex = 20,
        Parent = p3,
        Size = UDim2.fromScale(0.5, 0.3),
        Position = p4.Position or UDim2.fromScale(0.5, 0.94),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.006, 0)
    UIListLayout.Parent = v3
    self.Block = v3
    self.Rows = {}

    local function line(p5, p6, p7, p8) -- line: 73
        -- upvalues: self (copy), v3 (copy), UIKit (copy), t2 (copy)
        local v4 = UIKit.Frame({
            Transparency = 1,
            ZIndex = 20,
            Parent = v3,
            Name = p5,
            Size = UDim2.fromScale(1, t2[p5])
        })

        v4.LayoutOrder = p6
        self.Rows[p5] = v4

        return UIKit.Text({
            Name = "Label",
            Text = "",
            ZIndex = 21,
            Parent = v4,
            Size = UDim2.fromScale(1, 1),
            Stroke = p7,
            Color = p8
        })
    end

    self.Area = line("Area", 1, 2)
    self.Area.Text = p4.Area or ""
    self.Area.TextTransparency = 0.25

    local Area = self.Rows.Area

    if p4.Area ~= nil then
        Area.Visible = p4.Area ~= ""
    else
        Area.Visible = false
    end

    self.Mutation = line("Mutation", 2, 3)
    self.Rows.Mutation.Visible = Mutations.NameGradient(p4.Mutation) ~= nil

    local Mutation = self.Mutation

    Mutation.TextTransparency = 1

    local TextStroke = Mutation:FindFirstChild("TextStroke")

    if TextStroke then
        TextStroke.Transparency = 1
    end

    self.Name = line("Name", 3, UITheme.Stroke.TextBig)
    self.Name.Text = "?????"
    self.SizeTitle = line("Size", 4, 3)
    self.Rows.Size.Visible = Mutations.SizeTitle(p4.Size) ~= nil

    local SizeTitle = self.SizeTitle

    SizeTitle.TextTransparency = 1

    local TextStroke2 = SizeTitle:FindFirstChild("TextStroke")

    if TextStroke2 then
        TextStroke2.Transparency = 1
    end

    self.Rarity = line("Rarity", 5, 3)
    self.Rarity.Text = "??????"

    local Rarity = self.Rarity

    Rarity.TextTransparency = 1

    local TextStroke3 = Rarity:FindFirstChild("TextStroke")

    if TextStroke3 then
        TextStroke3.Transparency = 1
    end

    if self.Compact then
        self.Rows.Area.Visible = false
        self.Rows.Rarity.Visible = false
    end

    self.Income = line("Income", 6, 3, Colors.Money)
    self.Income.RichText = true
    self.Income.Text = "$???/s"

    local Income = self.Income

    Income.TextTransparency = 1

    local TextStroke4 = Income:FindFirstChild("TextStroke")

    if TextStroke4 then
        TextStroke4.Transparency = 1
    end

    local v5 = UIKit.Frame({
        Name = "New",
        Corner = 10,
        Stroke = 4,
        ZIndex = 22,
        Parent = self.Rows.Name,
        Size = UDim2.fromScale(0.2, 0.86),
        Position = UDim2.fromScale(0.9, 0.02),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.YellowA,
        Gradient = {
            Colors.YellowA,
            Colors.YellowB,
            90
        }
    })

    v5.Rotation = -12
    v5.Visible = false
    self.BadgeLabel = UIKit.Text({
        Text = "NEW!",
        ZIndex = 23,
        Stroke = 3,
        Parent = v5,
        Size = UDim2.fromScale(0.9, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    self.Badge = v5
    UIKit.PopIn(v3, 0.35, 0.7)

    return self
end

function t1:SetName(p10) -- line: 113
    self.Name.Text = p10
end

function t1:LockIn(p12) -- line: 120
    -- upvalues: RarityConfig (copy), Mutations (copy), UIKit (copy)
    local v6 = RarityConfig.Get(p12.Rarity)

    self.Name.Text = string.upper(p12.Name)

    local v7 = Mutations.NameGradient(p12.Mutation)

    if v7 then
        self.Mutation.Text = string.upper(p12.Mutation)

        local UIGradient = self.Mutation:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient:Destroy()
        end

        UIKit.Gradient(self.Mutation, v7, 90)
        self.Rows.Mutation.Visible = true

        local Mutation = self.Mutation

        Mutation.TextTransparency = 0

        local TextStroke = Mutation:FindFirstChild("TextStroke")

        if TextStroke then
            TextStroke.Transparency = 0
        end

        UIKit.Punch(self.Mutation, 0.5, 0.6)
    end

    local v8, v9 = Mutations.SizeTitle(p12.Size)

    if v8 then
        self.SizeTitle.Text = v8
        self.SizeTitle.TextColor3 = v9 or Color3.new(1, 1, 1)
        self.Rows.Size.Visible = true

        local SizeTitle = self.SizeTitle

        SizeTitle.TextTransparency = 0

        local TextStroke = SizeTitle:FindFirstChild("TextStroke")

        if TextStroke then
            TextStroke.Transparency = 0
        end

        UIKit.Punch(self.SizeTitle, 0.5, 0.6)
    end

    if self.Compact then
        self.Name.TextColor3 = Color3.new(1, 1, 1)

        local UIGradient = self.Name:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient:Destroy()
        end

        UIKit.Gradient(self.Name, v6.Gradient, 90)
    else
        self.Rarity.Text = string.upper(p12.Rarity)
        self.Rarity.TextColor3 = Color3.new(1, 1, 1)

        local UIGradient = self.Rarity:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient:Destroy()
        end

        UIKit.Gradient(self.Rarity, v6.Gradient, 90)

        local Rarity = self.Rarity

        Rarity.TextTransparency = 0

        local TextStroke = Rarity:FindFirstChild("TextStroke")

        if TextStroke then
            TextStroke.Transparency = 0
        end

        UIKit.Punch(self.Rarity, 0.5, 0.6)
    end

    self.Income.Text = p12.IncomeText or ""

    local Income = self.Income

    Income.TextTransparency = 0

    local TextStroke = Income:FindFirstChild("TextStroke")

    if TextStroke then
        TextStroke.Transparency = 0
    end

    UIKit.Punch(self.Name, 0.35, 0.6)
    UIKit.Punch(self.Income, 0.3, 0.6)

    local v10 = if p12.IsNew then "NEW!" else p12.BadgeText

    if not v10 then
        return false
    end

    self.BadgeLabel.Text = v10

    if #v10 > 4 then
        self.Badge.Size = UDim2.fromScale(0.34, 0.86)
        self.Badge.Position = UDim2.fromScale(0.85, 0.02)
    end

    self.Badge.Visible = true
    UIKit.PopIn(self.Badge, 0.5, 0.2)

    return true
end

function t1:Destroy() -- line: 175
    if self.Block then
        self.Block:Destroy()
    end

    self.Block = nil
end

return t1

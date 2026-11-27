-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UIKit = require(script.Parent.UIKit)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.__index = t1
t1.HEIGHT = 46
t1.STYLES = {
    on = {
        fromRGB(255, 205, 60),
        fromRGB(240, 130, 20),
        fromRGB(255, 240, 150)
    },
    use = {
        fromRGB(80, 200, 100),
        fromRGB(30, 130, 60),
        fromRGB(14, 14, 22)
    },
    off = {
        fromRGB(110, 114, 130),
        fromRGB(70, 74, 90),
        fromRGB(14, 14, 22)
    },
    get = {
        fromRGB(255, 215, 60),
        fromRGB(220, 150, 20),
        fromRGB(14, 14, 22)
    },
    count = {
        fromRGB(40, 44, 64),
        fromRGB(26, 28, 44),
        fromRGB(14, 14, 22)
    }
}

local t2 = {}

t2.__index = t2

function t2.new(p1, p2, p3, p4) -- line: 20
    -- upvalues: UIKit (copy), t1 (copy), t2 (copy)
    local self = setmetatable({}, t2)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p2
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(0, t1.HEIGHT)
    TextButton.AutomaticSize = Enum.AutomaticSize.X
    TextButton.LayoutOrder = p3
    TextButton.Visible = false
    TextButton.Parent = p1

    local v2 = UIKit.frame(TextButton, {
        Name = "Body",
        Stroke = 4,
        Size = UDim2.fromScale(1, 1),
        Color = t1.STYLES.off[1],
        Color2 = t1.STYLES.off[2],
        Corner = t1.HEIGHT / 2
    })

    v2.AutomaticSize = Enum.AutomaticSize.X

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 18)
    UIPadding.PaddingRight = UDim.new(0, 18)
    UIPadding.Parent = v2

    local v3 = UIKit.text(v2, {
        Name = "Label",
        Text = "",
        TextSize = 26,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(0, t1.HEIGHT)
    })

    v3.AutomaticSize = Enum.AutomaticSize.X
    self.Button = TextButton
    self.Body = v2
    self.Label = v3
    self.Stroke = v2:FindFirstChildOfClass("UIStroke")
    self.State = nil

    if p4 then
        UIKit.bindPress(TextButton, p4)
    end

    return self
end

function t2:Set(p6, p7) -- line: 51
    -- upvalues: UIKit (copy), t1 (copy)
    if not p6 then
        self.Button.Visible = false
        self.State = nil

        return
    end

    local v4 = t1.STYLES[p6] or t1.STYLES.off
    local Stroke, v5

    if self.State ~= p6 then
        UIKit.setButtonColor(self.Body, v4[1], v4[2])

        if self.Stroke then
            self.Stroke.Color = v4[3]
            Stroke = self.Stroke
            v5 = if p6 == "on" then 5 else 4
            Stroke.Thickness = v5
        end
    end

    self.State = p6
    self.Label.Text = p7 or ""
    self.Button.Visible = true
end

function t2:Shown() -- line: 70
    return self.Button.Visible
end

function t2:Pop() -- line: 74
    -- upvalues: UIKit (copy)
    UIKit.pop(self.Button, 1.12)
end

function t1.new(p10, p11) -- line: 78
    -- upvalues: UIKit (copy), t1 (copy), t2 (copy)
    local self = setmetatable({}, t1)
    local v7 = UIKit.frame(p10, {
        Name = "Boosts",
        Transparency = 1,
        Size = UDim2.fromOffset(0, t1.HEIGHT),
        Position = p11,
        AnchorPoint = Vector2.new(0, 1)
    })

    v7.AutomaticSize = Enum.AutomaticSize.X

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = v7
    self.Row = v7
    self.OnAuto = nil
    self.OnLuck = nil
    self.Auto = t2.new(v7, "AutoCast", 1, function() -- line: 91
        -- upvalues: self (copy)
        if self.OnAuto then
            self.OnAuto()
        end
    end)
    self.Luck = t2.new(v7, "Luck", 2, function() -- line: 96
        -- upvalues: self (copy)
        if self.OnLuck then
            self.OnLuck()
        end
    end)
    self.Count = t2.new(v7, "Count", 3, function() -- line: 101
        -- upvalues: self (copy)
        if self.OnLuck then
            self.OnLuck()
        end
    end)

    return self
end

function t1:SetAuto(p13) -- line: 109
    local v8 = if p13 == "on" then "ON" elseif p13 == "get" then "GET" else "OFF"

    self.Auto:Set(p13, "AUTO CAST  " .. v8)
end

function t1:SetLuck(p15, p16) -- line: 114
    local v9 = if p15 == "on" then "ON" elseif p15 == "get" then "GET" else "USE"

    self.Luck:Set(p15, "100x LUCK  " .. v9)

    if p15 and p16 > 0 then
        self.Count:Set(p15 == "on" and "on" or "count", "x" .. p16)
    else
        self.Count:Set(nil)
    end
end

function t1:AutoShown() -- line: 124
    return self.Auto:Shown()
end

function t1:LuckShown() -- line: 128
    return self.Luck:Shown()
end

t1.Pill = t2

return t1

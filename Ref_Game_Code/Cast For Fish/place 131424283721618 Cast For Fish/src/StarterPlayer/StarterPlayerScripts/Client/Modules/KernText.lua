-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TextService = game:GetService("TextService")
local t1 = {}

t1.__index = t1

local v1 = Vector2.new(1E+05, 1E+05)

t1.Pairs = {
    FA = 0.13,
    PA = 0.1,
    TA = 0.1,
    VA = 0.07,
    WA = 0.05,
    YA = 0.1,
    AT = 0.1,
    AV = 0.07,
    AW = 0.05,
    AY = 0.1,
    LT = 0.12,
    LY = 0.12,
    LV = 0.08,
    LW = 0.06,
    TO = 0.05,
    TC = 0.05,
    TG = 0.05,
    TQ = 0.05,
    OT = 0.05,
    CT = 0.03,
    FO = 0.03,
    PO = 0.02,
    YO = 0.05,
    OY = 0.05,
    VO = 0.04,
    OV = 0.04,
    ["F."] = 0.1,
    ["P."] = 0.1,
    ["T."] = 0.1
}

function t1.new(p1, p2) -- line: 18
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Label = p1
    self.Font = p2 or p1.Font
    self.Stroke = p1:FindFirstChildOfClass("UIStroke")
    self.Holder = Instance.new("Frame")
    self.Holder.Name = "Kerned"
    self.Holder.BackgroundTransparency = 1
    self.Holder.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Holder.Position = UDim2.fromScale(0.5, 0.5)
    self.Holder.ZIndex = p1.ZIndex
    self.Scale = Instance.new("UIScale")
    self.Scale.Parent = self.Holder
    self.Holder.Parent = p1
    self.Text = ""
    p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 33
        -- upvalues: self (copy)
        self:Fit()
    end)

    return self
end

function t1:Width(p4) -- line: 39
    -- upvalues: TextService (copy), v1 (copy)
    return TextService:GetTextSize(p4, 100, self.Font, v1).X
end

function t1:Segments(p6) -- line: 43
    -- upvalues: t1 (copy)
    local t3 = {}
    local v3 = #p6 - 1
    local n1 = 1

    for i = 1, v3 do
        local v4 = t1.Pairs[p6:sub(i, i + 1)]

        if v4 then
            table.insert(t3, {
                text = p6:sub(n1, i),
                kern = v4
            })
            n1 = i + 1
        end
    end

    table.insert(t3, {
        kern = 0,
        text = p6:sub(n1)
    })

    local n2 = 0

    for _, v5 in ipairs(t3) do
        v5.x = n2
        v5.w = self:Width(v5.text)
        n2 += v5.w - v5.kern * 100
    end

    return t3, n2
end

function t1:Layout(p8) -- line: 63
    local AbsoluteSize = self.Label.AbsoluteSize
    local v6 = if AbsoluteSize.Y > 0 then AbsoluteSize.X / AbsoluteSize.Y else 4
    local v7 = string.split(p8, " ")
    local t6 = {
        p8
    }
    local _, v8 = self:Segments(p8)
    local v10 = math.min(v6 / v8, 0.01)

    for i = 1, #v7 - 1 do
        local v11 = table.concat(v7, " ", 1, i)
        local v12 = table.concat(v7, " ", i + 1)
        local _, v13 = self:Segments(v11)
        local _, v14 = self:Segments(v12)
        local v16 = math.min(v6 / math.max(v13, v14), 0.005)

        if v10 < v16 then
            v10 = v16
            t6 = { v11, v12 }
        end
    end

    return t6
end

function t1:Set(p10) -- line: 83
    self.Text = p10
    self.Label.Text = ""
    self.Holder:ClearAllChildren()
    self.Scale = Instance.new("UIScale")
    self.Scale.Parent = self.Holder

    local v17 = self:Layout(p10)

    self.Pieces = {}

    local n3 = 0

    for v18, v19 in ipairs(v17) do
        local v20, v21 = self:Segments(v19)

        n3 = math.max(n3, v21)

        local Frame = Instance.new("Frame")

        Frame.Name = "Line" .. v18
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromOffset(v21, 100)
        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.new(0.5, 0, 0, (v18 - 1) * 100)
        Frame.ZIndex = self.Label.ZIndex

        for _, v22 in ipairs(v20) do
            local TextLabel = Instance.new("TextLabel")

            TextLabel.BackgroundTransparency = 1
            TextLabel.Font = self.Font
            TextLabel.TextSize = 100
            TextLabel.Text = v22.text
            TextLabel.TextColor3 = self.Label.TextColor3
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Size = UDim2.fromOffset(v22.w + 2, 100)
            TextLabel.Position = UDim2.fromOffset(v22.x, 0)
            TextLabel.ZIndex = self.Label.ZIndex

            if self.Stroke then
                local clone = self.Stroke:Clone()

                clone.Parent = TextLabel
                table.insert(self.Pieces, clone)
            end

            TextLabel.Parent = Frame
        end

        Frame.Parent = self.Holder
    end

    self.Holder.Size = UDim2.fromOffset(n3, #v17 * 100)
    self:Fit()
end

function t1:Fit() -- line: 126
    local AbsoluteSize = self.Label.AbsoluteSize
    local AbsoluteSize2 = self.Holder.AbsoluteSize

    if not (AbsoluteSize2.X <= 0) and not (AbsoluteSize2.Y <= 0) and not (AbsoluteSize.X <= 0) then
        local v25 = math.min(AbsoluteSize.X / AbsoluteSize2.X, AbsoluteSize.Y / AbsoluteSize2.Y)

        self.Scale.Scale *= v25

        if self.Stroke then
            for _, v26 in ipairs(self.Pieces) do
                v26.Thickness = self.Stroke.Thickness / self.Scale.Scale
            end
        end
    end
end

return t1

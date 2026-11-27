-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TextService = game:GetService("TextService")
local t1 = {}

t1.__index = t1
t1.MIN_PX = 18
t1.MAIN_PX = 28

function t1.new(p1, p2) -- line: 9
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Frame = p1
    self.Main = p2 or {}
    self.Base = setmetatable({}, {
        __mode = "k"
    })
    self.Gui = p1:FindFirstAncestorOfClass("ScreenGui")
    self.Fit = self.Gui and self.Gui:FindFirstChild("FitScale")
    self.Pending = false

    return self
end

function t1:ScaleOf(p4) -- line: 20
    local n1 = 1
    local v2 = p4

    while v2 and v2 ~= self.Gui do
        for _, child in ipairs(v2:GetChildren()) do
            if child:IsA("UIScale") then
                n1 *= child.Scale
            end
        end

        v2 = v2.Parent
    end

    if self.Fit then
        n1 *= self.Fit.Scale
    end

    return (math.max(n1, 0.05))
end

function t1:IsMain(p6) -- line: 37
    local FullName = p6:GetFullName()

    for _, v3 in ipairs(self.Main) do
        if string.find(FullName, v3) then
            return true
        end
    end

    return false
end

function t1.Fits(_, p8, p9, p10) -- line: 47
    -- upvalues: TextService (copy)
    local AbsoluteSize = p8.AbsoluteSize

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        return false
    end

    local v4 = if p8.RichText then string.gsub(p8.Text, "<[^>]->", "") else p8.Text
    local v5 = if p8.TextWrapped then AbsoluteSize.X else 1E+05
    local GetTextSize = TextService.GetTextSize
    local v6 = p9 * p10
    local Font = p8.Font
    local new = Vector2.new
    local ok, result = pcall(GetTextSize, TextService, v4, v6, Font, new(v5, 1E+05))

    if not ok then
        return false
    end

    if result.X <= AbsoluteSize.X then
        return result.Y <= AbsoluteSize.Y
    end

    return false
end

function t1:ApplyOne(p12) -- line: 61
    if not (p12:IsA("TextLabel") or p12:IsA("TextButton")) then
        return
    end

    local TextFloor = p12:FindFirstChild("TextFloor")

    if TextFloor then
        TextFloor:Destroy()
    end

    if p12.TextScaled or p12.Text == "" then
        return
    end

    if self.Base[p12] == nil then
        self.Base[p12] = p12.TextSize
    end

    local v7 = self.Base[p12]
    local v8 = self:ScaleOf(p12)
    local v11 = math.max(v7, (math.ceil((if self:IsMain(p12) then self.MAIN_PX else self.MIN_PX) / v8)))

    while v7 < v11 and not self:Fits(p12, v11, v8) do
        v11 -= 1
    end

    if p12.TextSize ~= v11 then
        p12.TextSize = v11
    end

    return v7 < v11
end

function t1:Settle(p14) -- line: 89
    for _ = 1, 30 do
        task.wait()

        local t5 = {}

        for _, v13 in ipairs(p14) do
            local v14 = self.Base[v13]

            if v13.Parent and v14 and not v13.TextFits and v14 < v13.TextSize then
                v13.TextSize -= 1
                table.insert(t5, v13)
            end
        end

        if #t5 == 0 then
            return
        end

        p14 = t5
    end
end

function t1:Apply() -- line: 107
    if self.Frame.Visible then
        local t6 = {}

        for _, descendant in ipairs(self.Frame:GetDescendants()) do
            if self:ApplyOne(descendant) then
                table.insert(t6, descendant)
            end
        end

        if #t6 > 0 then
            task.spawn(self.Settle, self, t6)
        end
    end
end

function t1:Schedule() -- line: 122
    if self.Pending then
        return
    end

    self.Pending = true
    task.delay(0.45, function() -- line: 127
        -- upvalues: self (copy)
        self.Pending = false
        self:Apply()
    end)
end

function t1:Start() -- line: 133
    self.Frame.DescendantAdded:Connect(function() -- line: 134
        -- upvalues: self (copy)
        self:Schedule()
    end)

    if self.Fit then
        self.Fit:GetPropertyChangedSignal("Scale"):Connect(function() -- line: 138
            -- upvalues: self (copy)
            self:Schedule()
        end)
    end

    self.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 142
        -- upvalues: self (copy)
        if self.Frame.Visible then
            self:Schedule()
        end
    end)

    return self
end

t1.WINDOWS = {
    Index = { "Summary%.Percent%.Value$", "Summary%.Total%.Count$" },
    IndexRewards = { "Summary%.Found$" },
    Rebirth = { "Right%.Luck%.Text$" },
    Gifts = { "%.Prize$", "PlayedPill%.Played$" }
}

function t1:ForWindows() -- line: 157
    -- upvalues: t1 (copy)
    local t7 = {}

    for v15, v16 in pairs(t1.WINDOWS) do
        local v17 = self[v15]

        if v17 and v17.Frame then
            t7[v15] = t1.new(v17.Frame, v16):Start()
        end
    end

    return t7
end

return t1

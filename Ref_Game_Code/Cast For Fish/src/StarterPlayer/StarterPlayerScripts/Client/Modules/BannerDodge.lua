-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1
t1.GAP = 6
t1.INTERVAL = 0.25

function t1.new(p1, p2) -- line: 8
    -- upvalues: RunService (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Banner = p1
    self.Extra = p2 or {}
    self.Base = p1.Position
    self.Shift = 0
    self.Elapsed = 0
    self.Conn = RunService.Heartbeat:Connect(function(p3) -- line: 15
        -- upvalues: self (copy)
        self.Elapsed += p3

        if self.Elapsed >= self.INTERVAL then
            self.Elapsed = 0
            self:Update()
        end
    end)

    return self
end

function t1.Row(_) -- line: 25
    local _require = require
    local TopBar = script.Parent.TopBar
    local ok, result = pcall(_require, TopBar)
    local Row = ok and result.Row or nil

    return if Row and Row.Parent and Row:IsA("GuiObject") then Row else nil
end

function t1.RowBounds(_, p6) -- line: 34
    local n1 = 1e999
    local n2 = (-1e999)
    local n3 = (-1e999)

    for _, child in ipairs(p6:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            n1 = math.min(n1, child.AbsolutePosition.X)
            n2 = math.max(n2, child.AbsolutePosition.X + child.AbsoluteSize.X)
            n3 = math.max(n3, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
        end
    end

    return n1, n2, n3
end

function t1:Obstacles() -- line: 46
    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
    local t3 = {}
    local HUD = PlayerGui:FindFirstChild("HUD")

    HUD = HUD and HUD.Enabled and HUD:FindFirstChild("TipBubble")

    if HUD and HUD.Visible then
        table.insert(t3, {
            HUD.AbsolutePosition.X,
            HUD.AbsolutePosition.X + HUD.AbsoluteSize.X,
            HUD.AbsolutePosition.Y + HUD.AbsoluteSize.Y
        })
    end

    for _, v4 in ipairs(self.Extra) do
        local v5 = PlayerGui:FindFirstChild(v4[1])
        local LayerCollector = v5 and v5:IsA("LayerCollector") and v5.Enabled and v5:FindFirstChild(v4[2])

        if LayerCollector and LayerCollector:IsA("GuiObject") and LayerCollector.Visible and LayerCollector ~= self.Banner then
            local v6 = LayerCollector.AbsolutePosition.X
            local v7 = LayerCollector.AbsolutePosition.X + LayerCollector.AbsoluteSize.X
            local v8 = LayerCollector.AbsolutePosition.Y + LayerCollector.AbsoluteSize.Y

            for _, child in ipairs(LayerCollector:GetChildren()) do
                if child:IsA("TextLabel") and child.Visible and child.Text ~= "" then
                    local v10 = math.min(child.AbsoluteSize.X, child.TextBounds.X + 8)
                    local v11 = child.AbsolutePosition.X + (child.AbsoluteSize.X - v10) / 2

                    v6 = math.min(v6, v11)
                    v7 = math.max(v7, v11 + v10)
                    v8 = math.max(v8, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                end
            end

            table.insert(t3, {
                v6,
                v7,
                v8
            })
        end
    end

    return t3
end

function t1:Update() -- line: 75
    local Banner = self.Banner

    if not Banner.Parent then
        self.Conn:Disconnect()

        return
    end

    local v14 = self:Row()
    local Y = Banner.AbsoluteSize.Y
    local Offset = Banner.Size.Y.Offset
    local v15, v16, v17, X, v18, v19

    if v14 and not (Y <= 0) and not (Offset <= 0) then
        v15 = Offset / Y
        v16 = Banner.AbsolutePosition.Y - self.Shift / v15

        local v20, v21

        v20, v21, v17 = self:RowBounds(v14)
        X = Banner.AbsolutePosition.X
        v18 = X + Banner.AbsoluteSize.X
        v19 = X < v21 and v20 < v18 and v16 < v17

        for _, v22 in ipairs(self:Obstacles()) do
            if X < v22[2] and v22[1] < v18 and v16 < v22[3] then
                v17 = math.max(v17, v22[3])
                v19 = true
            end
        end

        local v24 = if v19 then math.ceil((v17 - v16 + self.GAP) * v15) else 0

        if v24 ~= self.Shift then
            self.Shift = v24
            Banner.Position = self.Base + UDim2.fromOffset(0, v24)
        end
    end
end

return t1

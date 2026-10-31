-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1
t1.Config = {
    FootZone = 0.08,
    MaxLower = 0.6,
    MaxRaise = 0.03,
    Smoothing = 30
}

local function bindWorldCFrame(p1, p2) -- line: 35
    -- upvalues: bindWorldCFrame (copy)
    local v1 = p2[p1]

    if v1 then
        return v1
    end

    local Parent = p1.Parent
    local v2

    if not (Parent and Parent:IsA("Bone")) then
        local BasePart = if Parent then Parent:IsA("BasePart") else nil

        v2 = if not Parent or not BasePart then p1.CFrame else Parent.CFrame * p1.CFrame
    else
        v2 = bindWorldCFrame(Parent, p2) * p1.CFrame
    end

    p2[p1] = v2

    return v2
end

function t1.new(p3) -- line: 53
    -- upvalues: t1 (copy), bindWorldCFrame (copy)
    local self = setmetatable({}, t1)

    self.Model = p3
    self.Feet = {}
    self.Current = 0

    local BoundingBox, BoundingBox2 = p3:GetBoundingBox()

    self.Height = BoundingBox2.Y

    local v4 = BoundingBox.Position.Y - BoundingBox2.Y / 2

    self.BottomOffset = p3:GetPivot().Position.Y - v4

    local t3 = {}
    local t4 = {}
    local Y = p3:GetPivot().Position.Y

    self.Body = {}

    local n1 = 1e999

    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("Bone") then
            table.insert(t4, descendant)
            n1 = math.min(n1, bindWorldCFrame(descendant, t3).Position.Y)

            local Parent = descendant.Parent

            if Parent:IsA("BasePart") or Parent:IsA("Bone") and Parent.Parent:IsA("BasePart") then
                table.insert(self.Body, {
                    Bone = descendant,
                    BindDY = bindWorldCFrame(descendant, t3).Position.Y - Y
                })
            end
        end
    end

    local v5 = n1 + t1.Config.FootZone * BoundingBox2.Y

    for _, v6 in ipairs(t4) do
        local v7 = bindWorldCFrame(v6, t3)

        if v7.Position.Y <= v5 then
            table.insert(self.Feet, {
                Bone = v6,
                Sole = v7:PointToObjectSpace((Vector3.new(v7.Position.X, v4, v7.Position.Z)))
            })
        end
    end

    return self
end

function t1:HasFeet() -- line: 95
    return #self.Feet > 0
end

function t1:Measure() -- line: 100
    -- upvalues: t1 (copy)
    if #self.Feet == 0 then
        return 0
    end

    local Y = self.Model:GetPivot().Position.Y
    local v8 = Y - self.BottomOffset
    local n2 = 1e999

    for _, v9 in ipairs(self.Feet) do
        local Y = v9.Bone.TransformedWorldCFrame:PointToWorldSpace(v9.Sole).Y

        if Y < n2 then
            n2 = Y
        end
    end

    local v10 = n2 - v8

    if v10 > 0 then
        local n3 = 0

        for _, v11 in ipairs(self.Body) do
            local v12 = v11.Bone.TransformedWorldCFrame.Position.Y - (Y + v11.BindDY)

            if n3 < v12 then
                n3 = v12
            end
        end

        v10 = math.max(v10 - n3, 0)
    end

    local Config = t1.Config

    return (math.clamp(v10, -Config.MaxRaise * self.Height, Config.MaxLower * self.Height))
end

function t1:Update(p7) -- line: 124
    -- upvalues: t1 (copy)
    local v16 = self:Measure()
    local v18 = 1 - math.exp(-(p7 or 0.016666666666666666) * t1.Config.Smoothing)

    self.Current += (v16 - self.Current) * v18

    return self.Current
end

return t1

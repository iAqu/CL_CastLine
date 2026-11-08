-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1
t1.__class = "SurfaceTracker"

local function clampToBox(p1, p2) -- line: 19
    local CFrame = p1.CFrame
    local v1 = p1.Size * 0.5

    return CFrame:PointToWorldSpace(CFrame:PointToObjectSpace(p2):Max(-v1):Min(v1))
end

function t1.new(p3, p4) -- line: 25
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.model = p3
    self.skip = p4
    self.solids = {}
    self.links = {}
    self.disposed = false
    self:Rescan()
    self.links = {
        p3.DescendantAdded:Connect(function(p5) -- line: 37
            -- upvalues: self (copy)
            if p5:IsA("BasePart") and p5 ~= self.skip and table.find(self.solids, p5) == nil then
                table.insert(self.solids, p5)
            end
        end),
        p3.DescendantRemoving:Connect(function(p6) -- line: 42
            -- upvalues: self (copy)
            local v3 = table.find(self.solids, p6)

            if v3 ~= nil then
                table.remove(self.solids, v3)
            end
        end)
    }

    return self
end

function t1:Destroy() -- line: 53
    if self.disposed then
        return
    end

    self.disposed = true

    for _, v4 in self.links do
        v4:Disconnect()
    end

    table.clear(self.links)
    table.clear(self.solids)
end

function t1:Rescan() -- line: 66
    local solids = self.solids

    table.clear(solids)

    for _, descendant in self.model:GetDescendants() do
        local BasePart = descendant:IsA("BasePart") and descendant ~= self.skip and descendant.Parent ~= nil

        if BasePart then
            solids[#solids + 1] = descendant
        end
    end
end

function t1:GetClosestSurfacePoint(p10, p11, p12) -- line: 78
    if self.disposed then
        return nil, nil
    end

    local v5 = p12 == nil
    local v6

    if not v5 then
        local BoundingBox, BoundingBox2 = self.model:GetBoundingBox()
        local v7 = (BoundingBox:PointToObjectSpace(p10):Abs() - BoundingBox2 * 0.5):Max((Vector3.new(0, 0, 0)))
        local v8 = math.max(p12, 0) + 0.01

        v6 = v7:Dot(v7) > v8 * v8
    end

    if not v5 and v6 then
        return nil, nil
    end

    local n1 = 1e999
    local v9

    for _, v10 in self.solids do
        local v11

        if v10:IsDescendantOf(self.model) then
            local CFrame = v10.CFrame
            local v12 = v10.Size * 0.5

            v11 = CFrame:PointToWorldSpace(CFrame:PointToObjectSpace(p10):Max(-v12):Min(v12))
        end

        local v13 = if v11 then (p10 - v11).Magnitude else 1e999

        if v13 < n1 then
            n1 = v13
            v9 = v11
        end
    end

    local v14 = if v9 then p10 - v9 else Vector3.new(0, 0, 0)
    local v15 = if v14.Magnitude < 1E-04 then Vector3.new(0, 1, 0) else v14.Unit
    local v16 = if v9 then v9 + v15 * (p11 or 0) else nil

    return v16, v16 and n1
end

return t1

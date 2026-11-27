-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 6
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Queue = p1
    self.Priority = p2.priority or 3
    self.Key = p2.key
    self.OnShow = p2.show
    self.OnHide = p2.hide
    self.Sticky = p2.sticky == true
    self.Seq = p3
    self.State = "pending"

    return self
end

function t1:IsActive() -- line: 19
    return self.State == "active"
end

function t1:Done() -- line: 23
    self.Queue:Finish(self)
end

local t3 = {}

t3.__index = t3
t3.CATCH = 1
t3.EQUIPMENT = 2
t3.TIP = 3
t3.MAX_ON_SCREEN = 2
t3.GAP = 0.3
t3.MAX_PENDING_PER_PRIORITY = 6

function t3.new() -- line: 37
    -- upvalues: t3 (copy)
    local self = setmetatable({}, t3)

    self.Active = {}
    self.Pending = {}
    self.LastShown = 0
    self.Seq = 0
    self.Shown = 0
    self.Peak = 0
    self.Paused = nil
    self.Blocked = nil

    return self
end

function t3:Find(p7) -- line: 50
    if not p7 then
        return nil
    end

    for _, v3 in ipairs(self.Active) do
        if v3.Key == p7 then
            return v3
        end
    end

    for _, v4 in ipairs(self.Pending) do
        if v4.Key == p7 then
            return v4
        end
    end

    return nil
end

function t3:Push(p9) -- line: 67
    -- upvalues: t1 (copy)
    local v5 = self:Find(p9.key)

    if v5 then
        return v5
    end

    self.Seq += 1

    local v6 = t1.new(self, p9, self.Seq)

    if self.Blocked and self.Blocked(p9) then
        v6.State = "dropped"

        return v6
    end

    table.insert(self.Pending, v6)

    local t5 = {}

    for _, v7 in ipairs(self.Pending) do
        if v7.Priority == v6.Priority then
            table.insert(t5, v7)
        end
    end

    for i = 1, #t5 - self.MAX_PENDING_PER_PRIORITY do
        local v8 = table.find(self.Pending, t5[i])

        if v8 then
            table.remove(self.Pending, v8)
            t5[i].State = "dropped"
        end
    end

    self:Pump()

    return v6
end

function t3:Finish(p11) -- line: 96
    local v9 = table.find(self.Active, p11)

    if v9 then
        table.remove(self.Active, v9)
    end

    local v10 = table.find(self.Pending, p11)

    if v10 then
        table.remove(self.Pending, v10)
    end

    p11.State = "done"
    self:Pump()
end

function t3:Sort() -- line: 109
    table.sort(self.Pending, function(p13, p14) -- line: 110
        if p13.Priority == p14.Priority then
            return p13.Seq < p14.Seq
        end

        return p13.Priority < p14.Priority
    end)
end

function t3:Weakest() -- line: 118
    local v11

    for _, v12 in ipairs(self.Active) do
        if v12.Sticky and v12.OnHide and (not v11 or v12.Priority > v11.Priority) then
            v11 = v12
        end
    end

    return v11
end

function t3:Activate(p17) -- line: 128
    table.remove(self.Pending, table.find(self.Pending, p17))
    p17.State = "active"
    table.insert(self.Active, p17)
    self.LastShown = os.clock()
    self.Shown += 1
    self.Peak = math.max(self.Peak, #self.Active)
    task.defer(function() -- line: 135
        -- upvalues: p17 (copy)
        if p17.State == "active" then
            p17.OnShow(p17)
        end
    end)
end

function t3:Pump() -- line: 142
    if #self.Pending == 0 or self.Paused and self.Paused() or os.clock() - self.LastShown < self.GAP then
        return
    end

    self:Sort()

    local v14 = self.Pending[1]

    if #self.Active < self.MAX_ON_SCREEN then
        self:Activate(v14)
    else
        local v15 = self:Weakest()

        if v15 and v15.Priority > v14.Priority then
            table.remove(self.Active, table.find(self.Active, v15))
            v15.State = "pending"
            table.insert(self.Pending, v15)
            task.spawn(v15.OnHide, v15)
            self:Activate(v14)
        end
    end
end

function t3:Start() -- line: 165
    -- upvalues: RunService (copy)
    if not self.Connection then
        self.Connection = RunService.Heartbeat:Connect(function() -- line: 169
            -- upvalues: self (copy)
            self:Pump()
        end)
    end

    return self
end

t3.Ticket = t1
t3.Shared = t3.new():Start()

return t3

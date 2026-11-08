-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Signal = require(script.Parent.Signal)
local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 73
    -- upvalues: Signal (copy), RunService (copy), t1 (copy)
    assert(type(p1) == "number", "Argument #1 to Timer.new must be a number; got " .. type(p1))
    assert(p1 >= 0, "Argument #1 to Timer.new must be greater or equal to 0; got " .. tostring(p1))

    local self = setmetatable({}, t1)

    self._runHandle = nil
    self.Interval = p1
    self.UpdateSignal = RunService.Heartbeat
    self.TimeFunction = time
    self.AllowDrift = true
    self.Tick = Signal.new()

    return self
end

function t1.Simple(p2, p3, p4, p5, p6) -- line: 103
    -- upvalues: RunService (copy)
    p5 = p5 or RunService.Heartbeat

    local v7 = p6 or time
    local v8 = v7() + p2

    if p4 then
        task.defer(p3)
    end

    return p5:Connect(function() -- line: 116
        -- upvalues: p2 (copy), p3 (copy), v7 (copy), v8 (ref)
        local v9 = v7()

        if v8 <= v9 then
            v8 = v9 + p2
            task.defer(p3)
        end
    end)
end

function t1.Is(p7) -- line: 128
    -- upvalues: t1 (copy)
    if type(p7) == "table" then
        return getmetatable(p7) == t1
    end

    return false
end

function t1:_startTimer() -- line: 132
    local TimeFunction = self.TimeFunction
    local v10 = TimeFunction() + self.Interval

    self._runHandle = self.UpdateSignal:Connect(function() -- line: 135
        -- upvalues: self (copy), TimeFunction (copy), v10 (ref)
        local v11 = TimeFunction()

        if v10 <= v11 then
            v10 = v11 + self.Interval
            self.Tick:Fire()
        end
    end)
end

function t1:_startTimerNoDrift() -- line: 144
    assert(self.Interval > 0, "Interval must be greater than 0 when AllowDrift is set to false")

    local TimeFunction = self.TimeFunction
    local n1 = 1
    local v13 = TimeFunction()
    local v14 = v13 + self.Interval

    self._runHandle = self.UpdateSignal:Connect(function() -- line: 150
        -- upvalues: self (copy), TimeFunction (copy), n1 (ref), v13 (copy), v14 (ref)
        local v15 = TimeFunction()

        while v14 <= v15 do
            n1 += 1
            v14 = v13 + self.Interval * n1
            self.Tick:Fire()
        end
    end)
end

function t1:Start() -- line: 167
    if not self._runHandle then
        if self.AllowDrift then
            self:_startTimer()
        else
            self:_startTimerNoDrift()
        end
    end
end

function t1:StartNow() -- line: 186
    if not self._runHandle then
        self.Tick:Fire()
        self:Start()
    end
end

function t1:Stop() -- line: 201
    if self._runHandle then
        self._runHandle:Disconnect()
        self._runHandle = nil
    end
end

function t1:IsRunning() -- line: 218
    return self._runHandle ~= nil
end

function t1:Destroy() -- line: 225
    self.Tick:Destroy()
    self:Stop()
end

return t1

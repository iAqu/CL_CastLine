-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new() -- line: 20
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self._events = {}

    return self
end

function t1:_getOrCreate(p2) -- line: 26
    if self._events[p2] then
        return self._events[p2]
    end

    local BindableEvent = Instance.new("BindableEvent")

    BindableEvent.Name = p2
    self._events[p2] = BindableEvent

    return self._events[p2]
end

function t1:publish(p4, ...) -- line: 35
    self:_getOrCreate(p4):Fire(...)
end

function t1:subscribe(p6) -- line: 40
    return self:_getOrCreate(p6).Event
end

return t1

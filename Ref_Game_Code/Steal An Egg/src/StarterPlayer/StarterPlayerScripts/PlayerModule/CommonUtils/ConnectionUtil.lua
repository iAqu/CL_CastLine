-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new() -- line: 25
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self._connections = {}

    return self
end

function t1:trackConnection(p2, p3) -- line: 33
    if self._connections[p2] then
        self._connections[p2]()
    end

    self._connections[p2] = function() -- line: 38
        -- upvalues: p3 (copy)
        p3:Disconnect()
    end
end

function t1:trackBoundFunction(p5, p6) -- line: 41
    if self._connections[p5] then
        self._connections[p5]()
    end

    self._connections[p5] = p6
end

function t1:disconnect(p8) -- line: 48
    if self._connections[p8] then
        self._connections[p8]()
        self._connections[p8] = nil
    end
end

function t1:disconnectAll() -- line: 55
    for _, v2 in pairs(self._connections) do
        v2()
    end

    self._connections = {}
end

return t1

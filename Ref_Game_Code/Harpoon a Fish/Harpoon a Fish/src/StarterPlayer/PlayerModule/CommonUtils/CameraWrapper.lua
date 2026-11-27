-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ConnectionUtil = require(script.Parent.ConnectionUtil)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 42
    -- upvalues: ConnectionUtil (copy), t1 (copy)
    return (setmetatable({
        _enabled = false,
        _camera = game.Workspace.CurrentCamera,
        _callbacks = {},
        _connectionUtil = ConnectionUtil.new()
    }, t1))
end

function t1._connectCallbacks(p1) -- line: 55
    p1._camera = game.Workspace.CurrentCamera

    if p1._camera then
        for v1, v2 in p1._callbacks do
            p1._connectionUtil:trackConnection(v1, p1._camera:GetPropertyChangedSignal(v1):Connect(v2))
            v2()
        end
    end
end

function t1.Enable(p2) -- line: 71
    if p2._enabled then
        return
    end

    p2._enabled = true
    p2._cameraChangedConnection = game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 78
        -- upvalues: p2 (copy)
        p2:_connectCallbacks()
    end)
    p2:_connectCallbacks()
end

function t1.Disable(p3) -- line: 85
    if p3._enabled then
        p3._enabled = false

        if p3._cameraChangedConnection then
            p3._cameraChangedConnection:Disconnect()
            p3._cameraChangedConnection = nil
        end

        p3._connectionUtil:disconnectAll()
    end
end

function t1.Connect(p4, p5, p6) -- line: 100
    p4._callbacks[p5] = p6

    if p4._camera then
        p4._connectionUtil:trackConnection(p5, p4._camera:GetPropertyChangedSignal(p5):Connect(p6))
    end
end

function t1.Disconnect(p7, p8) -- line: 110
    p7._connectionUtil:disconnect(p8)
    p7._callbacks[p8] = nil
end

function t1.getCamera(p9) -- line: 116
    return p9._camera
end

return t1

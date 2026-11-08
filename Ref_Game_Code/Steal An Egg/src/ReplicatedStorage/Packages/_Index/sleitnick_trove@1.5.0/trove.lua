-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = newproxy()
local v2 = newproxy()
local v3 = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" })

local function GetObjectCleanupFunction(p1, p2) -- line: 128
    -- upvalues: v1 (copy), v2 (copy), v3 (copy)
    local v4 = typeof(p1)

    if v4 == "function" then
        return v1
    end

    if v4 == "thread" then
        return v2
    end

    if p2 then
        return p2
    end

    if v4 == "Instance" or v4 == "Object" then
        return "Destroy"
    end

    if v4 == "RBXScriptConnection" then
        return "Disconnect"
    end

    if v4 == "table" then
        for _, v5 in v3 do
            if typeof(p1[v5]) == "function" then
                return v5
            end
        end
    end

    error(("failed to get cleanup function for object %*: %*"):format(v4, p1), 3)
end

local function AssertPromiseLike(p3) -- line: 156
    if typeof(p3) ~= "table" or typeof(p3.getStatus) ~= "function" or typeof(p3.finally) ~= "function" or typeof(p3.cancel) ~= "function" then
        error("did not receive a promise as an argument", 3)
    end
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 183
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self._objects = {}
    self._cleaning = false

    return self
end

function t1.is(p4) -- line: 197
    -- upvalues: t1 (copy)
    if typeof(p4) == "table" then
        return getmetatable(p4) == t1
    end

    return false
end

function t1:Add(p6, p7) -- line: 254
    -- upvalues: GetObjectCleanupFunction (copy)
    if self._cleaning then
        error("cannot call trove:Add() while cleaning", 2)
    end

    local v9 = GetObjectCleanupFunction(p6, p7)

    table.insert(self._objects, {
        p6,
        v9
    })

    return p6
end

function t1:Clone(p9) -- line: 276
    if self._cleaning then
        error("cannot call trove:Clone() while cleaning", 2)
    end

    return self:Add(p9:Clone())
end

function t1:Construct(p11, ...) -- line: 319
    if self._cleaning then
        error("Cannot call trove:Construct() while cleaning", 2)
    end

    local v10 = type(p11)
    local v11 = if v10 == "table" then p11.new(...) elseif v10 == "function" then p11(...) else nil

    return self:Add(v11)
end

function t1:Connect(p13, p14) -- line: 352
    if self._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2)
    end

    return self:Add(p13:Connect(p14))
end

function t1:BindToRenderStep(p16, p17, p18) -- line: 375
    -- upvalues: RunService (copy)
    if self._cleaning then
        error("cannot call trove:BindToRenderStep() while cleaning", 2)
    end

    RunService:BindToRenderStep(p16, p17, p18)
    self:Add(function() -- line: 382
        -- upvalues: p16 (copy), RunService (copy)
        RunService:UnbindFromRenderStep(p16)
    end)
end

function t1:AddPromise(p20) -- line: 412
    if self._cleaning then
        error("cannot call trove:AddPromise() while cleaning", 2)
    end

    if typeof(p20) ~= "table" or typeof(p20.getStatus) ~= "function" or typeof(p20.finally) ~= "function" or typeof(p20.cancel) ~= "function" then
        error("did not receive a promise as an argument", 3)
    end

    if p20:getStatus() == "Started" then
        p20:finally(function() -- line: 419
            -- upvalues: self (copy), p20 (copy)
            if not self._cleaning then
                self:_findAndRemoveFromObjects(p20, false)
            end
        end)
        self:Add(p20, "cancel")
    end

    return p20
end

function t1:Remove(p22, ...) -- line: 444
    if self._cleaning then
        error("cannot call trove:Remove() while cleaning", 2)
    end

    return self:_findAndRemoveFromObjects(p22, true, ...)
end

function t1:Extend() -- line: 473
    -- upvalues: t1 (copy)
    if self._cleaning then
        error("cannot call trove:Extend() while cleaning", 2)
    end

    return self:Construct(t1)
end

function t1:Clean() -- line: 493
    if self._cleaning then
        return
    end

    self._cleaning = true

    for _, v13 in self._objects do
        self:_cleanupObject(v13[1], v13[2])
    end

    table.clear(self._objects)
    self._cleaning = false
end

function t1.WrapClean(p25) -- line: 535
    return function() -- line: 536
        -- upvalues: p25 (copy)
        p25:Clean()
    end
end

function t1:_findAndRemoveFromObjects(p27, p28, ...) -- line: 541
    local _objects = self._objects

    for v14, v15 in _objects do
        if v15[1] == p27 then
            local v16 = #_objects

            _objects[v14] = _objects[v16]
            _objects[v16] = nil

            if p28 then
                self:_cleanupObject(v15[1], v15[2], ...)
            end

            return true
        end
    end

    return false
end

function t1._cleanupObject(_, p30, p31, ...) -- line: 561
    -- upvalues: v1 (copy), v2 (copy)
    if p31 == v1 then
        task.spawn(p30)
    elseif p31 == v2 then
        local cancel = task.cancel

        pcall(cancel, p30)
    elseif typeof(p31) == "function" then
        p31(p30, ...)
    else
        p30[p31](p30)
    end
end

function t1:AttachToInstance(p33) -- line: 603
    if self._cleaning then
        error("cannot call trove:AttachToInstance() while cleaning", 2)
    elseif not p33:IsDescendantOf(game) then
        error("instance is not a descendant of the game hierarchy", 2)
    end

    return self:Connect(p33.Destroying, function() -- line: 610
        -- upvalues: self (copy)
        self:Destroy()
    end)
end

function t1.Destroy(p34) -- line: 624
    p34:Clean()
end

return {
    new = t1.new,
    is = t1.is
}

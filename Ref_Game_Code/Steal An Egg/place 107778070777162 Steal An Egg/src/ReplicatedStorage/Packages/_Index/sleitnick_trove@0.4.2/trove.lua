-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = newproxy()
local v2 = newproxy()
local RunService = game:GetService("RunService")

local function GetObjectCleanupFunction(p1, p2) -- line: 10
    -- upvalues: v1 (copy), v2 (copy)
    local v3 = typeof(p1)

    if v3 == "function" then
        return v1
    end

    if v3 == "thread" then
        return v2
    end

    if p2 then
        return p2
    end

    if v3 == "Instance" then
        return "Destroy"
    end

    if v3 == "RBXScriptConnection" then
        return "Disconnect"
    end

    if v3 == "table" then
        if typeof(p1.Destroy) == "function" then
            return "Destroy"
        end

        if typeof(p1.Disconnect) == "function" then
            return "Disconnect"
        end
    end

    error("Failed to get cleanup function for object " .. v3 .. ": " .. tostring(p1), 3)
end

local function AssertPromiseLike(p3) -- line: 34
    if type(p3) ~= "table" or type(p3.getStatus) ~= "function" or type(p3.finally) ~= "function" or type(p3.cancel) ~= "function" then
        error("Did not receive a Promise as an argument", 3)
    end
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 57
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self._objects = {}

    return self
end

function t1:Extend() -- line: 82
    -- upvalues: t1 (copy)
    return self:Construct(t1)
end

function t1:Clone(p6) -- line: 90
    return self:Add(p6:Clone())
end

function t1:Construct(p8, ...) -- line: 127
    local v6 = type(p8)
    local v7 = if v6 == "table" then p8.new(...) elseif v6 == "function" then p8(...) else nil

    return self:Add(v7)
end

function t1:Connect(p10, p11) -- line: 153
    return self:Add(p10:Connect(p11))
end

function t1.BindToRenderStep(p12, p13, p14, p15) -- line: 170
    -- upvalues: RunService (copy)
    RunService:BindToRenderStep(p13, p14, p15)
    p12:Add(function() -- line: 172
        -- upvalues: p13 (copy), RunService (copy)
        RunService:UnbindFromRenderStep(p13)
    end)
end

function t1:AddPromise(p17) -- line: 200
    if type(p17) ~= "table" or type(p17.getStatus) ~= "function" or type(p17.finally) ~= "function" or type(p17.cancel) ~= "function" then
        error("Did not receive a Promise as an argument", 3)
    end

    if p17:getStatus() == "Started" then
        p17:finally(function() -- line: 203
            -- upvalues: self (copy), p17 (copy)
            return self:_findAndRemoveFromObjects(p17, false)
        end)
        self:Add(p17, "cancel")
    end

    return p17
end

function t1:Add(p19, p20) -- line: 259
    -- upvalues: GetObjectCleanupFunction (copy)
    local v9 = GetObjectCleanupFunction(p19, p20)

    table.insert(self._objects, {
        p19,
        v9
    })

    return p19
end

function t1:Remove(p22, ...) -- line: 275
    return self:_findAndRemoveFromObjects(p22, true, ...)
end

function t1:Clean() -- line: 284
    for _, v10 in ipairs(self._objects) do
        self:_cleanupObject(v10[1], v10[2])
    end

    table.clear(self._objects)
end

function t1:_findAndRemoveFromObjects(p25, p26, ...) -- line: 291
    local _objects = self._objects

    for v11, v12 in ipairs(_objects) do
        if v12[1] == p25 then
            local v13 = #_objects

            _objects[v11] = _objects[v13]
            _objects[v13] = nil

            if p26 then
                self:_cleanupObject(v12[1], v12[2], ...)
            end

            return true
        end
    end

    return false
end

function t1._cleanupObject(_, p28, p29, ...) -- line: 307
    -- upvalues: v1 (copy), v2 (copy)
    if p29 == v1 then
        p28()
    elseif p29 == v2 then
        coroutine.close(p28)
    elseif typeof(p29) == "function" then
        p29(p28, ...)
    else
        p28[p29](p28)
    end
end

function t1:AttachToInstance(p31) -- line: 332
    assert(p31:IsDescendantOf(game), "Instance is not a descendant of the game hierarchy")

    return self:Connect(p31.Destroying, function() -- line: 334
        -- upvalues: self (copy)
        self:Destroy()
    end)
end

function t1.Destroy(p32) -- line: 342
    p32:Clean()
end

return t1

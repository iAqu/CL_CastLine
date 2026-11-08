-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable)

local function DestroyThing(p1) -- line: 57
    if typeof(p1) == "RBXScriptConnection" then
        task.spawn(p1.Disconnect, p1)
    elseif typeof(p1) == "Instance" then
        if not (p1:IsA("AnimationTrack") and p1.IsPlaying) then
            task.spawn(p1.Destroy, p1)
        else
            task.spawn(function() -- line: 63
                -- upvalues: p1 (copy)
                p1:Stop(0.05)
                task.delay(0.11666666666666667, function() -- line: 65
                    -- upvalues: p1 (copy)
                    p1:Destroy()
                end)
            end)
        end
    elseif type(p1) == "thread" then
        local cancel = task.cancel

        pcall(cancel, p1)
    elseif type(p1) == "function" then
        task.spawn(p1)
    elseif type(p1) == "table" then
        task.spawn(function(p2) -- line: 77
            if p2.Destroy then
                p2:Destroy()
            elseif p2.Disconnect then
                p2:Disconnect()
            end
        end, p1)
    end
end

local function Destroy(p3) -- line: 87
    -- upvalues: DestroyThing (copy)
    if p3.Destroyed then
        return false
    end

    p3.Destroyed = true

    for _, v1 in ipairs(p3.Things) do
        DestroyThing(v1)
    end

    p3.Destroying:Fire()

    return true
end

local function IsDestroyed(p4) -- line: 99
    return p4.Destroyed
end

local function Add(p5, p6) -- line: 103
    -- upvalues: DestroyThing (copy)
    if p6 == nil then
        return p6
    end

    if typeof(p6) ~= "RBXScriptConnection" and typeof(p6) ~= "Instance" and type(p6) ~= "thread" and type(p6) ~= "function" then
        if type(p6) == "table" then
            if type(p6.Destroy) ~= "function" and type(p6.Disconnect) ~= "function" then
                error("Unknown thing: table (missing Destroy/Disconnect)")
            end
        else
            error((("Unknown thing: %*"):format((typeof(p6)))))
        end
    end

    if not p5.Destroyed then
        table.insert(p5.Things, p6)

        return p6
    end

    DestroyThing(p6)

    return p6
end

local t1 = {
    Destroy = Destroy,
    IsDestroyed = IsDestroyed,
    Add = Add
}
local v2 = table.freeze({
    __index = t1,
    __call = Add
})

table.freeze(t1)

local t2 = {
    new = function() -- new | line: 144
        -- upvalues: Bindable (copy), v2 (copy)
        return (setmetatable({
            Destroyed = false,
            Destroying = Bindable.new(),
            Things = {}
        }, v2))
    end
}

return table.freeze(t2)

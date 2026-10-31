-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
    -- upvalues: t1 (copy)
    return (setmetatable({
        _items = {}
    }, t1))
end

function t1.Add(p1, p2) -- line: 16
    table.insert(p1._items, p2)

    return p2
end

local function cleanItem(p3) -- line: 21
    local v1 = typeof(p3)

    if v1 == "RBXScriptConnection" then
        p3:Disconnect()
    elseif v1 == "Instance" then
        p3:Destroy()
    elseif v1 == "function" then
        p3()
    elseif v1 == "thread" then
        local cancel = task.cancel

        pcall(cancel, p3)
    elseif v1 == "table" then
        if p3.Destroy then
            p3:Destroy()
        elseif p3.Disconnect then
            p3:Disconnect()
        elseif p3.Cancel then
            p3:Cancel()
        end
    end
end

function t1.Cleanup(p4) -- line: 42
    -- upvalues: cleanItem (copy)
    local _items = p4._items

    p4._items = {}

    for i = #_items, 1, -1 do
        local v2 = _items[i]

        pcall(cleanItem, v2)
    end
end

t1.Destroy = t1.Cleanup

return t1

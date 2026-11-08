-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function observeChildren(p1, p2) -- line: 4
    local t1 = {}
    local connection

    local function OnInstanceRemoved(p3) -- line: 10
        -- upvalues: t1 (copy)
        local v1 = t1[p3]

        t1[p3] = nil

        if typeof(v1) == "function" then
            task.spawn(v1)
        end
    end

    local function OnInstanceAdded(p4) -- line: 19
        -- upvalues: p2 (copy), t1 (copy), connection (ref)
        if not connection.Connected or t1[p4] then
            return
        end

        t1[p4] = true
        t1[p4] = p2(p4)
    end

    connection = p1.ChildAdded:Connect(OnInstanceAdded)

    local connection2 = p1.ChildRemoved:Connect(OnInstanceRemoved)

    task.defer(function() -- line: 34
        -- upvalues: p1 (copy), connection (ref), OnInstanceAdded (copy)
        if connection.Connected then
            for _, child in p1:GetChildren() do
                task.spawn(OnInstanceAdded, child)
            end
        end
    end)

    return function() -- line: 45
        -- upvalues: t1 (copy), connection (ref), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()

        local v3 = next(t1)

        while v3 do
            local v4 = t1[v3]

            t1[v3] = nil

            if typeof(v4) == "function" then
                task.spawn(v4)
            end

            v3 = next(t1)
        end
    end
end

return observeChildren

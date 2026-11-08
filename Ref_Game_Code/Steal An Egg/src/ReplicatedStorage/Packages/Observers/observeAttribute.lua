-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function defaultGuard(_) -- line: 3
    return true
end

local function observeAttribute(p2, p3, p4, p5) -- line: 44
    -- upvalues: defaultGuard (copy)
    local v1, connection
    local n1 = 0
    local v2 = if p5 == nil then defaultGuard else p5

    local function OnAttributeChanged() -- line: 57
        -- upvalues: p2 (copy), p3 (copy), p4 (copy), v1 (ref), connection (ref), n1 (ref), v2 (copy)
        if v1 ~= nil then
            task.spawn(v1)
            v1 = nil
        end

        n1 += 1

        local v3 = n1
        local Attribute = p2:GetAttribute(p3)

        if Attribute ~= nil and v2(Attribute) then
            task.spawn(function() -- line: 69
                -- upvalues: v3 (copy), Attribute (copy), p4 (copy), v1 (ref), connection (ref), n1 (ref)
                local v4 = p4(Attribute)

                if typeof(v4) == "function" then
                    if v3 == n1 and connection.Connected then
                        v1 = v4
                    else
                        task.spawn(v4)
                    end
                end
            end)
        end
    end

    connection = p2:GetAttributeChangedSignal(p3):Connect(OnAttributeChanged)
    task.defer(function() -- line: 86
        -- upvalues: connection (ref), OnAttributeChanged (copy)
        if connection.Connected then
            OnAttributeChanged()
        end
    end)

    return function() -- line: 95
        -- upvalues: v1 (ref), connection (ref)
        connection:Disconnect()

        if v1 ~= nil then
            task.spawn(v1)
            v1 = nil
        end
    end
end

return observeAttribute

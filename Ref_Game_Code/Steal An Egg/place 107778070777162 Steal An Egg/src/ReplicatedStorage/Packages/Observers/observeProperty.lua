-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function observeProperty(p1, p2, p3) -- line: 19
    local v1, connection
    local n1 = 0

    local function OnPropertyChanged() -- line: 25
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), v1 (ref), connection (ref), n1 (ref)
        if v1 ~= nil then
            task.spawn(v1)
            v1 = nil
        end

        n1 += 1

        local v2 = n1
        local v3 = p1[p2]

        task.spawn(function() -- line: 36
            -- upvalues: v2 (copy), v3 (copy), p3 (copy), v1 (ref), connection (ref), n1 (ref)
            local v4 = p3(v3)

            if v2 ~= n1 or not connection.Connected then
                if v4 then
                    task.spawn(v4)
                end
            else
                v1 = v4
            end
        end)
    end

    connection = p1:GetPropertyChangedSignal(p2):Connect(OnPropertyChanged)
    task.defer(function() -- line: 50
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), v1 (ref), connection (ref), n1 (ref)
        if connection.Connected then
            if v1 ~= nil then
                task.spawn(v1)
                v1 = nil
            end

            n1 += 1

            local v5 = n1
            local v6 = p1[p2]

            task.spawn(function() -- line: 36
                -- upvalues: v5 (copy), v6 (copy), p3 (copy), v1 (ref), connection (ref), n1 (ref)
                local v7 = p3(v6)

                if v5 ~= n1 or not connection.Connected then
                    if v7 then
                        task.spawn(v7)
                    end
                else
                    v1 = v7
                end
            end)
        end
    end)

    return function() -- line: 58
        -- upvalues: v1 (ref), connection (ref)
        connection:Disconnect()

        if v1 ~= nil then
            task.spawn(v1)
            v1 = nil
        end
    end
end

return observeProperty

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function observeCharacter(p1, p2) -- line: 18
    local v1 = nil
    local connection

    local function OnCharacterAdded(p3) -- line: 23
        -- upvalues: p1 (copy), p2 (copy), v1 (ref), connection (ref)
        local v2

        task.defer(function() -- line: 27
            -- upvalues: p3 (copy), v2 (ref), p1 (copy), p2 (copy), v1 (ref), connection (ref)
            local v3 = p2(p1, p3)

            if typeof(v3) == "function" then
                if connection.Connected and p3.Parent then
                    v2 = v3
                    v1 = v3
                else
                    task.spawn(v3)
                end
            end
        end)

        local connection2

        connection2 = p3.AncestryChanged:Connect(function(_, p5) -- line: 43
            -- upvalues: v2 (ref), connection2 (ref), v1 (ref)
            if p5 == nil and connection2.Connected then
                connection2:Disconnect()

                if v2 ~= nil then
                    task.spawn(v2)

                    if v1 == v2 then
                        v1 = nil
                    end

                    v2 = nil
                end
            end
        end)
    end

    connection = p1.CharacterAdded:Connect(OnCharacterAdded)
    task.defer(function() -- line: 61
        -- upvalues: p1 (copy), connection (ref), OnCharacterAdded (copy)
        if p1.Character and connection.Connected then
            task.spawn(OnCharacterAdded, p1.Character)
        end
    end)

    return function() -- line: 68
        -- upvalues: v1 (ref), connection (ref)
        connection:Disconnect()

        if v1 ~= nil then
            task.spawn(v1)
            v1 = nil
        end
    end
end

return observeCharacter

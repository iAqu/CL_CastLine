-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")

function observeTagNoAncestry(p1, p2) -- line: 5
    -- upvalues: CollectionService (copy)
    local t1 = {}
    local connection

    local function OnInstanceAdded(p3) -- line: 11
        -- upvalues: p1 (copy), p2 (copy), t1 (copy), connection (ref)
        if connection.Connected then
            task.defer(function() -- line: 17
                -- upvalues: p3 (copy), p1 (copy), p2 (copy), t1 (copy)
                local function v1(p4) -- line: 19
                    -- upvalues: p2 (copy)
                    local v2 = p2(p4)

                    assert(typeof(v2) == "nil" or typeof(v2) == "function", "callback must return a function")

                    return v2
                end

                local traceback = debug.traceback
                local v4, v5 = xpcall(v1, traceback, p3)

                if v4 then
                    if type(v5) == "function" then
                        if not p3:HasTag(p1) then
                            task.spawn(v5)
                        else
                            t1[p3] = v5
                        end
                    end
                else
                    local v6 = string.split(v5, "\n")[1]
                    local v7 = string.find(v6, ": ")
                    local v8 = if v7 then v6:sub(v7 + 1) else ""

                    warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, v8, v5)))
                end
            end)
        end
    end

    local function OnInstanceRemoved(p5) -- line: 49
        -- upvalues: t1 (copy)
        local v9 = t1[p5]

        if typeof(v9) == "function" then
            task.spawn(v9)
        end
    end

    connection = CollectionService:GetInstanceAddedSignal(p1):Connect(OnInstanceAdded)

    local connection2 = CollectionService:GetInstanceRemovedSignal(p1):Connect(OnInstanceRemoved)

    task.defer(function() -- line: 61
        -- upvalues: p1 (copy), connection (ref), OnInstanceAdded (copy), CollectionService (copy)
        if connection.Connected then
            for _, v10 in CollectionService:GetTagged(p1) do
                task.spawn(OnInstanceAdded, v10)
            end
        end
    end)

    return function() -- line: 72
        -- upvalues: t1 (copy), connection (ref), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()

        local v11 = next(t1)

        while v11 do
            local v12 = t1[v11]

            if typeof(v12) == "function" then
                task.spawn(v12)
            end

            v11 = next(t1)
        end
    end
end

return observeTagNoAncestry

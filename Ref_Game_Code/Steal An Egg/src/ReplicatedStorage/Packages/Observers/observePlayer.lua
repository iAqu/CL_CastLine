-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

local function observePlayer(p1) -- line: 21
    -- upvalues: Players (copy)
    local connection
    local t1 = {}

    local function OnPlayerAdded(p2) -- line: 27
        -- upvalues: p1 (copy), connection (ref), t1 (copy)
        if connection.Connected then
            task.spawn(function() -- line: 32
                -- upvalues: p2 (copy), p1 (copy), connection (ref), t1 (copy)
                local v1 = p1(p2)

                if typeof(v1) == "function" then
                    if connection.Connected and p2.Parent then
                        t1[p2] = v1
                    else
                        task.spawn(v1)
                    end
                end
            end)
        end
    end

    local function OnPlayerRemoving(p3) -- line: 44
        -- upvalues: t1 (copy)
        local v2 = t1[p3]

        t1[p3] = nil

        if typeof(v2) == "function" then
            task.spawn(v2)
        end
    end

    connection = Players.PlayerAdded:Connect(OnPlayerAdded)

    local connection2 = Players.PlayerRemoving:Connect(OnPlayerRemoving)

    task.defer(function() -- line: 57
        -- upvalues: connection (ref), OnPlayerAdded (copy), Players (copy)
        if connection.Connected then
            for _, player in Players:GetPlayers() do
                task.spawn(OnPlayerAdded, player)
            end
        end
    end)

    return function() -- line: 68
        -- upvalues: connection (ref), t1 (copy), connection2 (copy)
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

return observePlayer

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Globals.Constants)

local Remotes = require(game:GetService("ReplicatedStorage").Shared.Remotes)

return {
    Start = function() -- Start | line: 23
        -- upvalues: Workspace (copy), Remotes (copy)
        local t2 = {}
        local t3 = {}

        local function cacheEventModule(p1) -- line: 33
            -- upvalues: t3 (copy)
            if not p1:IsA("ModuleScript") then
                return
            end

            local function v1() -- line: 38
                -- upvalues: p1 (copy), t3 (copy)
                t3[p1.Name] = require(p1)
            end

            local function v2(p2) -- line: 40
                warn((("[%*] %*"):format(script.Name, p2)))
            end

            xpcall(v1, v2)
        end

        for _, child in script.Events:GetChildren() do
            cacheEventModule(child)
        end

        script.Events.ChildAdded:Connect(cacheEventModule)
        Remotes.LiveEvents.Began.OnClientEvent:Connect(function(p3, p4, p5) -- line: 52
            -- upvalues: t2 (copy), t3 (copy)
            local v3 = os.time() + p4

            t2[p3] = v3

            if t3[p3] then
                t3[p3]:StartEvent(p4, p5)
                task.delay(p4, function() -- line: 62
                    -- upvalues: p3 (copy), v3 (copy), t2 (copy), t3 (copy)
                    if t2[p3] == v3 then
                        t3[p3]:StopEvent()
                        t2[p3] = nil
                    end
                end)
            end
        end)
        Remotes.LiveEvents.Ended.OnClientEvent:Connect(function(p6) -- line: 72
            -- upvalues: t2 (copy), t3 (copy)
            t2[p6] = nil

            if t3[p6] then
                t3[p6]:StopEvent()
            end
        end)

        local v4, v5 = Remotes.LiveEvents.FetchRunning:InvokeServer()

        for v6, v7 in v4 do
            if t3[v6] then
                local v8 = v5[v6] or {}
                local v9 = v7 - Workspace:GetServerTimeNow()

                task.spawn(function() -- line: 89
                    -- upvalues: t3 (copy), v6 (copy), v9 (copy), v8 (copy)
                    v8.WasInProgress = true
                    t3[v6]:StartEvent(v9, v8)
                end)
            end
        end
    end
}

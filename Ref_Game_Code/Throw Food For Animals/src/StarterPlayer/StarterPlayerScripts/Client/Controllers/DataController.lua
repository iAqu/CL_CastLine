-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataReplicator = require(ReplicatedStorage.Shared.DataReplicator)
local t1 = {
    Ready = require(ReplicatedStorage.Shared.Signal).new()
}
local LocalPlayer = Players.LocalPlayer
local v1

function t1.IsReady(_) -- line: 25
    -- upvalues: v1 (ref)
    return v1 ~= nil
end

function t1.WaitForReady(_) -- line: 29
    -- upvalues: v1 (ref)
    while not v1 do
        task.wait(0.1)
    end

    return v1
end

function t1.GetFolder(_) -- line: 34
    -- upvalues: v1 (ref)
    return v1
end

function t1.Get(_, p5) -- line: 38
    -- upvalues: DataReplicator (copy), v1 (ref)
    if v1 then
        local v2 = v1:FindFirstChild(p5)

        if v2 then
            return DataReplicator.Read(v2)
        end
    end

    return nil
end

function t1.GetPath(_, p7) -- line: 45
    -- upvalues: DataReplicator (copy), v1 (ref)
    if v1 then
        return DataReplicator.ReadPath(v1, p7)
    end

    return nil
end

function t1.Observe(p8, p9, p10) -- line: 51
    local t2 = {}

    local function hook(p11) -- line: 53
        -- upvalues: p10 (copy), t2 (copy)
        if p11 and p11:IsA("ValueBase") then
            table.insert(t2, p11.Changed:Connect(function(p12) -- line: 55
                -- upvalues: p10 (copy)
                p10(p12)
            end))
            p10(p11.Value)
        end
    end

    task.spawn(function() -- line: 61
        -- upvalues: p8 (copy), p9 (copy), t2 (copy), hook (copy)
        local v4 = p8:WaitForReady()

        hook(v4:FindFirstChild(p9) or v4:WaitForChild(p9, 10))
        table.insert(t2, v4.ChildAdded:Connect(function(p13) -- line: 65
            -- upvalues: p9 (copy), hook (copy)
            if p13.Name == p9 then
                hook(p13)
            end
        end))
    end)

    return function() -- line: 69
        -- upvalues: t2 (copy)
        for _, v7 in ipairs(t2) do
            v7:Disconnect()
        end
    end
end

function t1.ObserveTable(p14, p15, p16) -- line: 75
    -- upvalues: DataReplicator (copy)
    local t3 = {}
    local v8 = false

    local function fire(p17) -- line: 78
        -- upvalues: p16 (copy), v8 (ref), DataReplicator (copy)
        if v8 then
            return
        end

        v8 = true
        task.defer(function() -- line: 81
            -- upvalues: p17 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
            v8 = false

            if p17 and p17.Parent then
                p16(DataReplicator.Read(p17))
            end
        end)
    end

    local function hook(p18) -- line: 88
        -- upvalues: p16 (copy), t3 (copy), v8 (ref), DataReplicator (copy)
        if p18 then
            table.insert(t3, p18.DescendantAdded:Connect(function() -- line: 90
                -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                if v8 then
                    return
                end

                v8 = true
                task.defer(function() -- line: 81
                    -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                    v8 = false

                    if p18 and p18.Parent then
                        p16(DataReplicator.Read(p18))
                    end
                end)
            end))
            table.insert(t3, p18.DescendantRemoving:Connect(function() -- line: 91
                -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                if v8 then
                    return
                end

                v8 = true
                task.defer(function() -- line: 81
                    -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                    v8 = false

                    if p18 and p18.Parent then
                        p16(DataReplicator.Read(p18))
                    end
                end)
            end))

            local function hookValue(p19) -- line: 92
                -- upvalues: p18 (copy), p16 (copy), t3 (copy), v8 (ref), DataReplicator (copy)
                if not p19:IsA("ValueBase") then
                    return
                end

                table.insert(t3, p19.Changed:Connect(function() -- line: 94
                    -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                    if v8 then
                        return
                    end

                    v8 = true
                    task.defer(function() -- line: 81
                        -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                        v8 = false

                        if p18 and p18.Parent then
                            p16(DataReplicator.Read(p18))
                        end
                    end)
                end))
            end

            for _, descendant in ipairs(p18:GetDescendants()) do
                if descendant:IsA("ValueBase") then
                    table.insert(t3, descendant.Changed:Connect(function() -- line: 94
                        -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                        if v8 then
                            return
                        end

                        v8 = true
                        task.defer(function() -- line: 81
                            -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                            v8 = false

                            if p18 and p18.Parent then
                                p16(DataReplicator.Read(p18))
                            end
                        end)
                    end))
                end
            end

            table.insert(t3, p18.DescendantAdded:Connect(hookValue))

            if not v8 then
                v8 = true
                task.defer(function() -- line: 81
                    -- upvalues: p18 (copy), p16 (copy), v8 (ref), DataReplicator (copy)
                    v8 = false

                    if p18 and p18.Parent then
                        p16(DataReplicator.Read(p18))
                    end
                end)
            end
        end
    end

    task.spawn(function() -- line: 101
        -- upvalues: p14 (copy), p15 (copy), t3 (copy), hook (copy)
        local v13 = p14:WaitForReady()

        hook(v13:FindFirstChild(p15) or v13:WaitForChild(p15, 10))
        table.insert(t3, v13.ChildAdded:Connect(function(p20) -- line: 105
            -- upvalues: p15 (copy), hook (copy)
            if p20.Name == p15 then
                hook(p20)
            end
        end))
    end)

    return function() -- line: 109
        -- upvalues: t3 (copy)
        for _, v16 in ipairs(t3) do
            v16:Disconnect()
        end
    end
end

function t1.Init() -- line: 114
    -- upvalues: ReplicatedStorage (copy), t1 (copy), LocalPlayer (copy), v1 (ref)
    task.spawn(function() -- line: 115
        -- upvalues: ReplicatedStorage (copy), t1 (copy), LocalPlayer (copy), v1 (ref)
        local v17 = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(tostring(LocalPlayer.UserId), 120)

        if v17 then
            v1 = v17
            t1.Ready:Fire(v17)
        else
            warn("[DataController] Player data never replicated")
        end
    end)
end

return t1

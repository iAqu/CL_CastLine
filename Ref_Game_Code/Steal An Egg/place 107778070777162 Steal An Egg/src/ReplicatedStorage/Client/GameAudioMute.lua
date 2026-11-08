-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local t1 = {}
local n1 = 0
local t2 = {}
local t3 = {}
local t4 = {}
local Folder, connection, connection2
local t5 = {}

local function track(p1) -- line: 13
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), Folder (ref), t5 (copy)
    local t6, v1

    if not p1:IsA("Sound") or t2[p1] then
        return
    else
        local function originalGroup(p2) -- line: 18
            -- upvalues: t4 (copy), t5 (copy)
            local v3 = t4[p2]

            return if v3 ~= t5 then v3 or p2 else nil
        end

        t6 = {}

        local SoundGroup = p1.SoundGroup
        local v4 = t4[SoundGroup]

        if v4 ~= t5 then
            v1 = v4 or SoundGroup
        end
    end

    t6.group = v1
    t2[p1] = t6

    local function route() -- line: 26
        -- upvalues: p1 (copy), t6 (ref), t3 (copy), t4 (copy), Folder (ref), t5 (copy)
        local v5 = t6.group or t5
        local v6 = t3[v5]

        if not v6 then
            v6 = Instance.new("SoundGroup")
            v6.Name = "Muted"
            v6.Volume = 0
            t4[v6] = v5
            t3[v5] = v6
            v6.Parent = Folder
        end

        p1.SoundGroup = v6
    end

    t6.changed = p1:GetPropertyChangedSignal("SoundGroup"):Connect(function() -- line: 40
        -- upvalues: p1 (copy), t6 (ref), t3 (copy), t4 (copy), Folder (ref), t5 (copy)
        if t4[p1.SoundGroup] then
            return
        end

        t6.group = p1.SoundGroup

        local v7 = t6.group or t5
        local v8 = t3[v7]

        if not v8 then
            v8 = Instance.new("SoundGroup")
            v8.Name = "Muted"
            v8.Volume = 0
            t4[v8] = v7
            t3[v7] = v8
            v8.Parent = Folder
        end

        p1.SoundGroup = v8
    end)

    local v9 = t6.group or t5
    local v10 = t3[v9]

    if not v10 then
        v10 = Instance.new("SoundGroup")
        v10.Name = "Muted"
        v10.Volume = 0
        t4[v10] = v9
        t3[v9] = v10
        v10.Parent = Folder
    end

    p1.SoundGroup = v10
end

local function untrack(p3) -- line: 50
    -- upvalues: t2 (copy), t4 (copy)
    local v11 = t2[p3]

    if not v11 then
        return
    end

    t2[p3] = nil
    v11.changed:Disconnect()

    if t4[p3.SoundGroup] then
        p3.SoundGroup = v11.group
    end
end

function t1.Acquire() -- line: 62
    -- upvalues: SoundService (copy), n1 (ref), t2 (copy), t3 (copy), t4 (copy), Folder (ref), connection (ref), connection2 (ref), track (copy)
    n1 += 1

    if n1 == 1 then
        Folder = Instance.new("Folder")
        Folder.Name = "FullscreenAudioMute"
        Folder.Parent = SoundService
        connection = game.DescendantAdded:Connect(track)
        connection2 = game.DescendantRemoving:Connect(function(p4) -- line: 69
            -- upvalues: t2 (copy), t4 (copy)
            if t2[p4] then
                local v12 = t2[p4]

                if not v12 then
                    return
                end

                t2[p4] = nil
                v12.changed:Disconnect()

                if t4[p4.SoundGroup] then
                    p4.SoundGroup = v12.group
                end
            end
        end)

        for _, descendant in game:GetDescendants() do
            track(descendant)
        end
    end

    local v13 = false

    return function() -- line: 80
        -- upvalues: v13 (ref), n1 (ref), t2 (copy), t3 (copy), t4 (copy), Folder (ref), connection (ref), connection2 (ref)
        if v13 then
            return
        end

        v13 = true
        n1 -= 1

        if n1 > 0 then
            return
        end

        connection:Disconnect()
        connection2:Disconnect()

        for v14 in t2 do
            local v15 = t2[v14]

            if v15 then
                t2[v14] = nil
                v15.changed:Disconnect()

                if t4[v14.SoundGroup] then
                    v14.SoundGroup = v15.group
                end
            end
        end

        Folder:Destroy()
        Folder = nil
        table.clear(t3)
        table.clear(t4)
    end
end

return table.freeze(t1)

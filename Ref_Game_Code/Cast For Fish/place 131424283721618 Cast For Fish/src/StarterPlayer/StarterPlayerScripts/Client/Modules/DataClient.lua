-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local t1 = {
    Value = nil
}
local t2 = {}
local v1 = false

local function fire(p1) -- line: 10
    -- upvalues: t1 (copy), t2 (copy)
    local v2 = t2[p1]

    if v2 then
        for _, v3 in ipairs(v2) do
            task.spawn(v3, t1.Value[p1])
        end
    end
end

function t1.Observe(p2, p3) -- line: 20
    -- upvalues: t1 (copy), t2 (copy), v1 (ref)
    t2[p2] = t2[p2] or {}
    table.insert(t2[p2], p3)

    if v1 then
        task.spawn(p3, t1.Value[p2])
    end
end

function t1.Get(p4) -- line: 28
    -- upvalues: t1 (copy)
    return t1.Value and t1.Value[p4]
end

function t1.IsReady() -- line: 32
    -- upvalues: v1 (ref)
    return v1
end

function t1.Init() -- line: 36
    -- upvalues: Remotes (copy), t1 (copy), t2 (copy), v1 (ref), fire (copy)
    local t3 = {}

    Remotes.DataChanged.OnClientEvent:Connect(function(p5, p6) -- line: 38
        -- upvalues: t3 (copy), t1 (copy), v1 (ref), fire (copy)
        if v1 then
            t1.Value[p5] = p6
            fire(p5)
        else
            t3[p5] = { p6 }
        end
    end)

    local v5

    repeat
        v5 = Remotes.GetData:InvokeServer()

        if not v5 then
            task.wait(1)
        end
    until v5

    for v6, v7 in pairs(t3) do
        v5[v6] = v7[1]
    end

    t1.Value = v5
    v1 = true

    for v8 in pairs(t2) do
        fire(v8)
    end
end

return t1

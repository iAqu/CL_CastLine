-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {
    Reward = require(script.Reward),
    RiftSpawn = require(script.RiftSpawn),
    Toast = require(script.Toast)
}

local function channelFor(p1) -- line: 17
    -- upvalues: t1 (copy)
    local v1 = t1[p1]
    local v2 = typeof(v1) == "table"
    local v3 = if v2 then typeof(v1.Show) == "function" else nil

    if v2 and v3 then
        return v1
    end

    warn((("Alerts.Raise addressed an unknown notification channel: %*"):format((tostring(p1)))))

    return nil
end

Remotes.Alerts.Raise.OnClientEvent:Connect(function(p2) -- line: 26
    -- upvalues: t1 (copy)
    if typeof(p2) ~= "table" then
        warn((("Alerts.Raise expects a request table, got %*"):format((typeof(p2)))))

        return
    end

    local Type = p2.Type
    local v4 = t1[Type]

    if not (typeof(v4) == "table" and typeof(v4.Show) == "function") then
        v4 = nil
        warn((("Alerts.Raise addressed an unknown notification channel: %*"):format((tostring(Type)))))
    end

    if v4 ~= nil then
        local v7 = table.clone(p2)

        v7.Type = nil
        v4.Show(v7)
    end
end)

return table.freeze(t1)

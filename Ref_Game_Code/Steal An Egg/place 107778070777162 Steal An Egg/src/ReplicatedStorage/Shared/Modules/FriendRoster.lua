-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = require(ReplicatedStorage.Packages.Log).new()
local t1 = {
    RosterUpdated = require(ReplicatedStorage.Packages.Signal).new(),
    FriendsInServerAttribute = "FriendsInServer"
}
local t2 = {}

local function pairKey(p1, p2) -- line: 24
    if p1 < p2 then
        return (("%*:%*"):format(p1, p2))
    end

    return (("%*:%*"):format(p2, p1))
end

local function verdictFor(p3, p4) -- line: 28
    -- upvalues: t2 (copy)
    return t2[if p3 < p4 then ("%*:%*"):format(p3, p4) else ("%*:%*"):format(p4, p3)]
end

local function dropVerdicts(p5) -- line: 32
    -- upvalues: t2 (copy)
    local v3 = tostring(p5)

    for v4 in t2 do
        local v5, v6 = string.match(v4, "^(%d+):(%d+)$")

        if v5 == v3 or v6 == v3 then
            t2[v4] = nil
        end
    end
end

local function resolvePair(p6, p7) -- line: 44
    -- upvalues: v1 (copy), t2 (copy)
    local UserId = p6.UserId
    local UserId2 = p7.UserId
    local v7 = if UserId < UserId2 then ("%*:%*"):format(UserId, UserId2) else ("%*:%*"):format(UserId2, UserId)

    if t2[v7] == nil then
        t2[v7] = "asking"

        local IsFriendsWith = p6.IsFriendsWith
        local UserId = p7.UserId
        local ok, result = pcall(IsFriendsWith, p6, UserId)

        if p6.Parent == nil or p7.Parent == nil then
            t2[v7] = nil
        else
            if ok then
                t2[v7] = result == true

                return result == true
            end

            t2[v7] = nil
            v1:AtWarning():Log((("friendship check between %* and %* failed: %*"):format(p6.Name, p7.Name, result)))
        end
    end

    return nil
end

local function sweep(p8) -- line: 67
    -- upvalues: Players (copy), t1 (copy), t2 (copy), resolvePair (copy), sweep (copy)
    if p8.Parent == nil then
        return
    end

    local t3 = {
        p8
    }
    local v8 = false

    for _, player in Players:GetPlayers() do
        if player ~= p8 then
            if resolvePair(p8, player) then
                table.insert(t3, player)
            end

            if not v8 then
                local UserId = p8.UserId
                local UserId2 = player.UserId

                v8 = t2[if UserId < UserId2 then ("%*:%*"):format(UserId, UserId2) else ("%*:%*"):format(UserId2, UserId)] == nil
            end
        end
    end

    if p8.Parent ~= nil then
        for _, v10 in t3 do
            if v10.Parent ~= nil then
                t1.RosterUpdated:Fire(v10)
            end
        end

        if v8 then
            task.delay(45, sweep, p8)
        end
    end
end

if RunService:IsServer() then
    Players.PlayerAdded:Connect(sweep)
    Players.PlayerRemoving:Connect(function(p9) -- line: 99
        -- upvalues: dropVerdicts (copy)
        dropVerdicts(p9.UserId)
    end)

    for _, player in Players:GetPlayers() do
        task.spawn(sweep, player)
    end
end

local function friendsHere(p10) -- line: 107
    -- upvalues: Players (copy), t2 (copy)
    local t4 = {}

    for _, player in Players:GetPlayers() do
        if player ~= p10 then
            local UserId = p10.UserId
            local UserId2 = player.UserId

            if t2[if UserId < UserId2 then ("%*:%*"):format(UserId, UserId2) else ("%*:%*"):format(UserId2, UserId)] == true then
                table.insert(t4, player)
            end
        end
    end

    return t4
end

function t1.CountPresent(p11) -- line: 117
    -- upvalues: friendsHere (copy)
    return #friendsHere(p11)
end

function t1.IdList(p12) -- line: 121
    -- upvalues: friendsHere (copy)
    local t5 = {}

    for _, v12 in friendsHere(p12) do
        table.insert(t5, v12.UserId)
    end

    return t5
end

return table.freeze(t1)

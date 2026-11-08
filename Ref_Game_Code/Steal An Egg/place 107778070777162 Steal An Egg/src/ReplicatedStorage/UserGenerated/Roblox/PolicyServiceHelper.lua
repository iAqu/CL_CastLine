-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local RunService = game:GetService("RunService")
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local t1 = {
    Discord = 0,
    Facebook = 1,
    Twitch = 2,
    YouTube = 3,
    X = 4,
    GitHub = 5,
    Guilded = 6
}

table.freeze(t1)

local v1 = Cache.new({
    Callback = function(p1) -- Callback | line: 50
        -- upvalues: Players (copy), PolicyService (copy)
        local PlayerByUserId = Players:GetPlayerByUserId(p1)

        assert(PlayerByUserId, "PlayerNotOnline")

        return PolicyService:GetPolicyInfoForPlayerAsync(PlayerByUserId)
    end,
    AssertKey = Asserts.Integer
})

Players.PlayerRemoving:Connect(function(p2) -- line: 57
    -- upvalues: Players (copy), v1 (copy)
    local UserId = p2.UserId

    task.delay(60, function() -- line: 60
        -- upvalues: UserId (copy), Players (copy), v1 (copy)
        if not Players:GetPlayerByUserId(UserId) then
            v1:Delete(UserId)
        end
    end)
end)

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p3) -- line: 67
        -- upvalues: v1 (copy)
        v1:GetAsync(p3.UserId)
    end)
end

local t3 = {
    ExternalLinkReference = t1
}

function t3.ExternalLinkReferencesToInts(p4) -- line: 76
    -- upvalues: t1 (copy)
    local t4 = {}

    for _, v2 in ipairs(p4) do
        local v3 = t1[v2]

        if v3 then
            table.insert(t4, v3)
        end
    end

    return t4
end

function t3.GetPolicyInfoForPlayerAsync(p5, p6) -- line: 87
    -- upvalues: Asserts (copy), v1 (copy)
    Asserts.Player(p5)
    Asserts.Optional(Asserts.Boolean)(p6)

    if p6 then
        return v1:Get(p5.UserId)
    end

    return v1:GetAsync(p5.UserId)
end

return table.freeze(t3)

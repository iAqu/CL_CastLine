-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local RunService = game:GetService("RunService")
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = Cache.new({
    MaxAge = 1e999,
    Callback = function(p1) -- Callback | line: 38
        -- upvalues: GroupService (copy)
        return GroupService:GetGroupsAsync(p1)
    end,
    AssertKey = Asserts.Integer
})

Players.PlayerRemoving:Connect(function(p2) -- line: 44
    -- upvalues: Players (copy), v1 (copy)
    local UserId = p2.UserId

    task.delay(60, function() -- line: 47
        -- upvalues: UserId (copy), Players (copy), v1 (copy)
        if not Players:GetPlayerByUserId(UserId) then
            v1:Delete(UserId)
        end
    end)
end)

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p3) -- line: 54
        -- upvalues: v1 (copy)
        v1:GetAsync(p3.UserId)
    end)
else
    task.spawn(function() -- line: 58
        -- upvalues: Players (copy), v1 (copy)
        v1:GetAsync(Players.LocalPlayer.UserId)
    end)
end

local t2 = {
    Cache = v1
}

function t2.GetGroupsAsync(p4, p5) -- line: 67
    -- upvalues: Asserts (copy), v1 (copy)
    Asserts.Integer(p4)
    Asserts.Optional(Asserts.Boolean)(p5)

    if p5 then
        return v1:Get(p4)
    end

    return v1:GetAsync(p4)
end

return table.freeze(t2)

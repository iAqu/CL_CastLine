-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Cache = require(ReplicatedStorage.UserGenerated.Concurrency.Cache)
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = Cache.new({
    Callback = function(p1) -- Callback | line: 29
        -- upvalues: Players (copy), LocalizationService (copy)
        local PlayerByUserId = Players:GetPlayerByUserId(p1)

        assert(PlayerByUserId, "PlayerNotOnline")

        return LocalizationService:GetCountryRegionForPlayerAsync(PlayerByUserId)
    end,
    AssertKey = Asserts.Integer
})

Players.PlayerRemoving:Connect(function(p2) -- line: 36
    -- upvalues: Players (copy), v1 (copy)
    local UserId = p2.UserId

    task.delay(60, function() -- line: 39
        -- upvalues: UserId (copy), Players (copy), v1 (copy)
        if not Players:GetPlayerByUserId(UserId) then
            v1:Delete(UserId)
        end
    end)
end)

if RunService:IsServer() then
    Players.PlayerAdded:Connect(function(p3) -- line: 46
        -- upvalues: v1 (copy)
        v1:GetAsync(p3.UserId)
    end)
else
    task.spawn(function() -- line: 50
        -- upvalues: Players (copy), v1 (copy)
        v1:GetAsync(Players.LocalPlayer.UserId)
    end)
end

local t2 = {
    GetCountryRegionForPlayerAsync = function(p4, p5) -- GetCountryRegionForPlayerAsync | line: 57
        -- upvalues: Asserts (copy), v1 (copy)
        Asserts.Player(p4)
        Asserts.Optional(Asserts.Boolean)(p5)

        if p5 then
            return v1:Get(p4.UserId)
        end

        return v1:GetAsync(p4.UserId)
    end
}

return table.freeze(t2)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local Cache = require(game.ReplicatedStorage.UserGenerated.Concurrency.Cache)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)
local v1 = Cache.new({
    MaxAge = 1e999,
    Callback = function(p1) -- Callback | line: 27
        -- upvalues: VoiceChatService (copy)
        return VoiceChatService:IsVoiceEnabledForUserIdAsync(p1)
    end,
    AssertKey = Asserts.Integer
})

Players.PlayerRemoving:Connect(function(p2) -- line: 34
    -- upvalues: Players (copy), v1 (copy)
    local UserId = p2.UserId

    task.delay(60, function() -- line: 37
        -- upvalues: UserId (copy), Players (copy), v1 (copy)
        if not Players:GetPlayerByUserId(UserId) then
            v1:Delete(UserId)
        end
    end)
end)
task.spawn(function() -- line: 43
    -- upvalues: Players (copy), v1 (copy)
    v1:GetAsync(Players.LocalPlayer.UserId)
end)

local t2 = {
    IsVoiceEnabledForUserIdAsync = function(p3, p4) -- IsVoiceEnabledForUserIdAsync | line: 49
        -- upvalues: Asserts (copy), v1 (copy)
        Asserts.Integer(p3)
        Asserts.Optional(Asserts.Boolean)(p4)

        if p4 then
            return v1:Get(p3)
        end

        return v1:GetAsync(p3)
    end
}

return table.freeze(t2)

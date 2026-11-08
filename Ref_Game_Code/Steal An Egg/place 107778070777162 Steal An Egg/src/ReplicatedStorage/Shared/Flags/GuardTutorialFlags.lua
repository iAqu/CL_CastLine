-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t = require(ReplicatedStorage.Packages.t)

local function assertBoolean(p1) -- line: 11
    -- upvalues: t (copy)
    local v1, v2 = t.boolean(p1)

    assert(v1, v2)

    return p1
end

local t1 = {
    PauseNotificationEnabled = FastFlags.Replicated("Game.GuardTutorial.PauseNotificationEnabled", assertBoolean, false)
}

return table.freeze(t1)

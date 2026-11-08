-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Guards = require(ReplicatedStorage.Data.Guards)
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t1 = {
    IsEligible = function(p1) -- IsEligible | line: 14
        -- upvalues: Guards (copy), MonsterParasite (copy), TreadmillUtil (copy)
        local v1 = Guards.Directory[MonsterParasite.EligibilityGuardId]

        return v1 ~= nil and TreadmillUtil.SpeedPowerToWalkSpeed(p1) >= v1.WalkSpeed
    end
}

return table.freeze(t1)

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardRequirements = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardRequirements
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardEscapePrediction = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapePrediction)

require(ReplicatedStorage.Shared.Modules.GuardAreas.Types.Interface)

local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.table)

return {
    RequiredSpeedPower = function(p1) -- RequiredSpeedPower | line: 27
        -- upvalues: GuardRequirements (copy), GuardEscapePrediction (copy), TreadmillUtil (copy), v1 (copy)
        v1(p1)

        local v2 = GuardEscapePrediction.ResolvePlayerWalkSpeedRequirement(p1, GuardRequirements.CARRY_SPEED_RATIO)

        return TreadmillUtil.RoundSpeedPowerRequirement(TreadmillUtil.WalkSpeedToSpeedPower(v2) * GuardRequirements.REQUIREMENT_MARGIN)
    end
}

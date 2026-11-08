-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardReturn = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardReturn
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

return {
    Resolve = function(p1) -- Resolve | line: 21
        -- upvalues: GuardReturn (copy), t (copy)
        t.strict(t.string)(p1)

        return GuardReturn.RETURN_HOME_DISTANCE_BY_AREA_ID[p1] or GuardReturn.DEFAULT_RETURN_HOME_DISTANCE
    end
}

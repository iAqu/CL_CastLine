-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

return {
    BASELINE_RELEASE_VERSION = 1,
    BASELINE_MEDIA_COUNT = 246,
    CURRENT_RELEASE_VERSION = 3,
    ResolveEntryReleaseVersion = function(p1) -- ResolveEntryReleaseVersion | line: 22
        -- upvalues: t (copy)
        t.strict(t.intersection(t.integer, t.numberPositive))(p1)

        return p1
    end
}

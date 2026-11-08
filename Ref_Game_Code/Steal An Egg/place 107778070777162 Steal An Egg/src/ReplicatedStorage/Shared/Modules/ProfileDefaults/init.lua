-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Defaults = require(script.Defaults)
local Schema = require(script.Types.Schema)

local function verifyAuthoredProfile(p1) -- line: 9
    -- upvalues: Schema (copy)
    local v1, v2 = Schema(p1)

    if not v1 then
        error(("ProfileDefaults.Defaults violates the profile schema: %*"):format(v2), 0)
    end
end

if Constants.IS_STUDIO then
    local v3, v4 = Schema(Defaults)

    if not v3 then
        error(("ProfileDefaults.Defaults violates the profile schema: %*"):format(v4), 0)
    end
end

return Defaults

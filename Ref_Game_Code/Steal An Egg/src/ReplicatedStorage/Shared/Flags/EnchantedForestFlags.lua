-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local t1 = {
    Open = require(ReplicatedStorage.Shared.Flags.LiveEventFlags).Directory.EnchantedForestOpen
}

function t1.ShouldReveal() -- line: 10
    -- upvalues: Environment (copy), t1 (copy)
    local v1 = Environment.GetEnvironmentName()

    if v1 == "dev" or v1 == "test" or v1 == "prod" then
        return t1.Open:Get() == true
    end

    return false
end

return table.freeze(t1)

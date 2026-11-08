-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t1 = {
    Open = require(ReplicatedStorage.Shared.Flags.LiveEventFlags).Directory.StarHandlerOpen,
    ForceRevealed = FastFlags.Replicated("Game.StarHandler.ForceRevealed", Asserts.Boolean, false),
    WeeklyLimit = FastFlags.Replicated("Game.StarHandler.WeeklyLimit", Asserts.IntegerRange(0, 100), 5)
}

function t1.ShouldReveal() -- line: 19
    -- upvalues: t1 (copy)
    if t1.ForceRevealed:Get() == true then
        return true
    end

    return t1.Open:Get() == true
end

return table.freeze(t1)

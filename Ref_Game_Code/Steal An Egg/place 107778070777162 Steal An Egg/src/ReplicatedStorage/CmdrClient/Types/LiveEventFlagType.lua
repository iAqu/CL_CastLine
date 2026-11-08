-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LiveEventFlags = require(ReplicatedStorage.Shared.Flags.LiveEventFlags)
local t1 = {
    "set",
    "schedule",
    "reset",
    "status"
}

return function(p1) -- line: 11
    -- upvalues: LiveEventFlags (copy), t1 (copy)
    p1:RegisterType("liveEventFlagName", p1.Cmdr.Util.MakeEnumType("LiveEventFlagName", table.clone(LiveEventFlags.Names)))
    p1:RegisterType("liveEventFlagAction", p1.Cmdr.Util.MakeEnumType("LiveEventFlagAction", t1))
end

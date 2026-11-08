-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "status",
    "enable",
    "disable",
    "reset",
    "enter",
    "leave",
    "batch",
    "monsters",
    "event",
    "tokens",
    "buy",
    "progress",
    "resetprogress",
    "tutorial"
}

return function(p1) -- line: 20
    -- upvalues: t1 (copy)
    p1:RegisterType("halloweenAction", p1.Cmdr.Util.MakeEnumType("HalloweenAction", t1))
end

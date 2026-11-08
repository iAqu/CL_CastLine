-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "start",
    "quick",
    "join",
    "king",
    "cannon",
    "stun",
    "defeat",
    "timeup",
    "stop",
    "status"
}

return function(p1) -- line: 14
    -- upvalues: t1 (copy)
    p1:RegisterType("pumpkinAction", p1.Cmdr.Util.MakeEnumType("PumpkinAction", t1))
end

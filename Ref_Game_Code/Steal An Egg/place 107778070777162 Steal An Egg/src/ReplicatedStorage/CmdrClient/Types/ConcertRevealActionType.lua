-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = { "play", "reset", "now", "clear", "status" }

return function(p1) -- line: 10
    -- upvalues: t1 (copy)
    p1:RegisterType("concertRevealAction", p1.Cmdr.Util.MakeEnumType("ConcertRevealAction", t1))
end

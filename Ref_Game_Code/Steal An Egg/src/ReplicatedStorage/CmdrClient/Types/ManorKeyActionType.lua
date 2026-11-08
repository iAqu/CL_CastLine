-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = { "grant", "unlock", "reset" }

return function(p1) -- line: 7
    -- upvalues: t1 (copy)
    p1:RegisterType("manorKeyAction", p1.Cmdr.Util.MakeEnumType("ManorKeyAction", t1))
end

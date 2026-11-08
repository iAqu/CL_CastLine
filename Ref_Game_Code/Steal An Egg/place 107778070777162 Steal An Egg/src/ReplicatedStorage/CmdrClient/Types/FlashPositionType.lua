-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1) -- line: 2
    p1:RegisterType("flashPosition", p1.Cmdr.Util.MakeEnumType("Flash position", {
        "bottom",
        "top",
        "center",
        "left",
        "right"
    }))
end

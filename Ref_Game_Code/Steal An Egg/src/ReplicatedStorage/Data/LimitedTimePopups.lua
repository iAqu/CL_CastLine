-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function FromEDT(p1, p2, p3, p4) -- line: 10
    return DateTime.fromUniversalTime(p1, p2, p3, p4 + 4).UnixTimestamp
end

return {
    LuminousEgg = {
        Name = "LuminousEgg",
        StartTime = DateTime.fromUniversalTime(2026, 9, 23, 15).UnixTimestamp,
        EndTime = DateTime.fromUniversalTime(2026, 9, 26, 15).UnixTimestamp
    }
}

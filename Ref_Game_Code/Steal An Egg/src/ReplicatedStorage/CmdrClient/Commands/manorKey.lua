-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "manorKey",
    Description = "Manor Key test tools. grant: give the key and mark it claimed. unlock: unlock the chained manor door without using the key. reset: clear manor progress and remove the key.",
    Group = "Admin",
    Args = {
        {
            Type = "manorKeyAction",
            Name = "Action"
        }
    }
}

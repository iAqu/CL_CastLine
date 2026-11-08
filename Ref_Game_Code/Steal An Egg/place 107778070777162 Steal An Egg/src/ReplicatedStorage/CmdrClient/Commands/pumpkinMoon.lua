-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "pumpkinMoon",
    Description = "Starts or stops the Pumpkin Moon (Return Pumpkins) event in the Halloween dimension on this server.",
    Group = "Admin",
    Args = {
        {
            Type = "string",
            Name = "Action",
            Description = "start or stop",
            Default = "start"
        }
    }
}

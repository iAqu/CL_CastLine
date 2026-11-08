-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "previewFusion",
    Description = "Play a shrine fusion cinematic for yourself without pets, a partner or a reward.",
    Group = "Admin",
    Args = {
        {
            Type = "string",
            Name = "Shrine",
            Description = "Fusion shrine id: Enchanted, LightDark or Void.",
            Default = "Enchanted",
            Optional = true
        }
    }
}

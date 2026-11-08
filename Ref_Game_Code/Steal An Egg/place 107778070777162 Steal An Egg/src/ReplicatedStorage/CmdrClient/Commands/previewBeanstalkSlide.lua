-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "previewBeanstalkSlide",
    Description = "Preview the current Beanstalk descent in SAG DEV without rewards. Repeat to restart; true stops your preview.",
    Group = "Admin",
    Args = {
        {
            Type = "boolean",
            Name = "Stop",
            Optional = true
        }
    }
}

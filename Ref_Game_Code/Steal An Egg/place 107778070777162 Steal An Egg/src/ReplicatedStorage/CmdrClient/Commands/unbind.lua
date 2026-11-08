-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "unbind",
    Description = "Unbinds an input previously bound with Bind",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "userInput ! bindableResource @ player",
            Name = "Input/Key",
            Description = "The key or input type you'd like to unbind."
        }
    },
    ClientRun = function(p1, p2) -- ClientRun | line: 14
        local CMDR_Binds = p1:GetStore("CMDR_Binds")

        if not CMDR_Binds[p2] then
            return "That input wasn't bound."
        end

        CMDR_Binds[p2]:Disconnect()
        CMDR_Binds[p2] = nil

        return "Unbound command from input."
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "help",
    Description = "Displays a list of all commands, or inspects one command.",
    Group = "Help",
    Args = {
        {
            Type = "command",
            Name = "Command",
            Description = "The command to view information on",
            Optional = true
        }
    },
    ClientRun = function(p1, p2) -- ClientRun | line: 31
        if p2 then
            local Command = p1.Cmdr.Registry:GetCommand(p2)

            p1:Reply(("Command: %*"):format(Command.Name), Color3.fromRGB(230, 126, 34))

            if Command.Aliases and #Command.Aliases > 0 then
                p1:Reply(("Aliases: %*"):format((table.concat(Command.Aliases, ", "))), Color3.fromRGB(230, 230, 230))
            end

            p1:Reply(Command.Description, Color3.fromRGB(230, 230, 230))

            for v1, v2 in ipairs(Command.Args) do
                p1:Reply((("#%* %*%*: %* - %*"):format(v1, v2.Name, v2.Optional == true and "?" or "", v2.Type, v2.Description)))
            end
        else
            p1:Reply("Argument Shorthands\n-------------------\n.   Me/Self\n*   All/Everyone\n**  Others\n?   Random\n?N  List of N random values\n")
            p1:Reply("Tips\n----\n• Utilize the Tab key to automatically complete commands\n• Easily select and copy command output\n")

            local Commands = p1.Cmdr.Registry:GetCommands()

            table.sort(Commands, function(p3, p4) -- line: 49
                if p3.Group and p4.Group then
                    return p3.Group < p4.Group
                end

                return p3.Group
            end)

            local Group

            for _, v3 in ipairs(Commands) do
                v3.Group = v3.Group or "No Group"

                if Group ~= v3.Group then
                    p1:Reply((("\n%*\n%*"):format(v3.Group, (string.rep("-", #v3.Group)))))
                    Group = v3.Group
                end

                p1:Reply(if v3.Description then ("%* - %*"):format(v3.Name, v3.Description) else v3.Name)
            end
        end

        return ""
    end
}

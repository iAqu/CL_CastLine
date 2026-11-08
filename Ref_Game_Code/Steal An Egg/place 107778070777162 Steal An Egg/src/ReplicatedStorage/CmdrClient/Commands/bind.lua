-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")

return {
    Name = "bind",
    Description = "Binds a command string to a key or mouse input.",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "userInput ! bindableResource @ player",
            Name = "Input",
            Description = "The key or input type you'd like to bind the command to."
        },
        {
            Type = "command",
            Name = "Command",
            Description = "The command you want to run on this input"
        },
        {
            Type = "string",
            Name = "Arguments",
            Description = "The arguments for the command",
            Default = ""
        }
    },
    ClientRun = function(p1, p2, p3, p4) -- ClientRun | line: 27
        -- upvalues: UserInputService (copy)
        local v1 = p3
        local CMDR_Binds = p1:GetStore("CMDR_Binds")

        v1 = p3 .. " " .. p4

        if CMDR_Binds[p2] then
            CMDR_Binds[p2]:Disconnect()
        end

        local Name = p1:GetArgument(1).Type.Name

        if Name == "userInput" then
            CMDR_Binds[p2] = UserInputService.InputBegan:Connect(function(p5, p6) -- line: 39
                -- upvalues: v1 (ref), p1 (copy), p2 (copy)
                if p6 or p5.UserInputType ~= p2 and p5.KeyCode ~= p2 then
                    return
                end

                p1:Reply(p1.Dispatcher:EvaluateAndRun(p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, v1)))
            end)
        else
            if Name == "bindableResource" then
                return "Unimplemented..."
            end

            if Name == "player" then
                CMDR_Binds[p2] = p2.Chatted:Connect(function(p7) -- line: 51
                    -- upvalues: v1 (ref), p1 (copy), p2 (copy)
                    local t2 = {
                        p7
                    }
                    local v3 = p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, p1.Cmdr.Util.SubstituteArgs(v1, t2))

                    p1:Reply(("%s $ %s : %s"):format(p2.Name, v3, p1.Dispatcher:EvaluateAndRun(v3)), Color3.fromRGB(244, 92, 66))
                end)
            end
        end

        return "Bound command to input."
    end
}

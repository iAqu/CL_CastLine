-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    startsWith = function(p1, p2) -- startsWith | line: 2
        if p1:sub(1, #p2) == p2 then
            return p1:sub(#p2 + 1)
        end
    end
}

return {
    Name = "runif",
    Description = "Runs a given command string if a certain condition is met.",
    Group = "DefaultUtil",
    Aliases = {},
    Args = {
        {
            Type = "conditionFunction",
            Name = "Condition",
            Description = "The condition function"
        },
        {
            Type = "string",
            Name = "Argument",
            Description = "The argument to the condition function"
        },
        {
            Type = "string",
            Name = "Test against",
            Description = "The text to test against."
        },
        {
            Type = "string",
            Name = "Command",
            Description = "The command string to run if requirements are met. If omitted, return value from condition function is used.",
            Optional = true
        }
    },
    Run = function(p3, p4, p5, p6, p7) -- Run | line: 38
        -- upvalues: t1 (copy)
        local v1 = t1[p4]

        if not v1 then
            return ("Condition %q is not valid."):format(p4)
        end

        local v2 = v1(p6, p5)

        if v2 then
            return p3.Dispatcher:EvaluateAndRun(p3.Cmdr.Util.RunEmbeddedCommands(p3.Dispatcher, p7 or v2))
        end

        return ""
    end
}

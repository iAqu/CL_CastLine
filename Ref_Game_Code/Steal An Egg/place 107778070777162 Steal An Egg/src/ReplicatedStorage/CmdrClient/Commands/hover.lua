-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

return {
    Name = "hover",
    Description = "Returns the name of the player you are hovering over.",
    Group = "DefaultUtil",
    Args = {},
    ClientRun = function() -- ClientRun | line: 9
        -- upvalues: Players (copy)
        local Target = Players.LocalPlayer:GetMouse().Target

        if not Target then
            return ""
        end

        local PlayerFromCharacter = Players:GetPlayerFromCharacter(Target:FindFirstAncestorOfClass("Model"))

        return PlayerFromCharacter and PlayerFromCharacter.Name or ""
    end
}

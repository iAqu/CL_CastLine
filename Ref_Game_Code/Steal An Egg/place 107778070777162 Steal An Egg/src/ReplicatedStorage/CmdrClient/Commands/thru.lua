-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "thru",
    Description = "Teleports you through whatever your mouse is hovering over, placing you equidistantly from the wall.",
    Group = "DefaultDebug",
    Aliases = { "t", "through" },
    Args = {
        {
            Type = "number",
            Name = "Extra distance",
            Description = "Go through the wall an additional X studs.",
            Default = 0
        }
    },
    ClientRun = function(p1, p2) -- ClientRun | line: 15
        local Mouse = p1.Executor:GetMouse()
        local Character = p1.Executor.Character

        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local HumanoidRootPartPosition = Character.HumanoidRootPart.Position
            local v1 = Mouse.Hit.p - HumanoidRootPartPosition

            Character:MoveTo(v1 * 2 + v1.unit * p2 + HumanoidRootPartPosition)

            return "Blinked!"
        end

        return "You don't have a character."
    end
}

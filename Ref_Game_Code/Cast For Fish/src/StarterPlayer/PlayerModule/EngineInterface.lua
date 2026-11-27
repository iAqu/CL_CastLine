-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

require(script.Parent:WaitForChild("CommonUtils"))
require(script.Parent.Types)

return {
    update = function(p1) -- update | line: 20
        -- upvalues: Players (copy)
        local engineInterface = p1.engineInterface
        local LocalPlayer = Players.LocalPlayer
        local Character = if LocalPlayer then LocalPlayer.Character else nil
        local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

        if LocalPlayer == engineInterface.player and Character == engineInterface.character and Humanoid == engineInterface.humanoid then
            return
        end

        engineInterface.player = LocalPlayer
        engineInterface.character = Character
        engineInterface.humanoid = Humanoid
        engineInterface.characterChanged = true
    end,
    cleanDirty = function(p2) -- cleanDirty | line: 39
        p2.engineInterface.characterChanged = false
    end
}

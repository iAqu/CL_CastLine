-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 15
        -- upvalues: Remotes (copy), LocalPlayer (copy)
        local function requestCharacterReset(p1) -- line: 20
            -- upvalues: Remotes (copy)
            Remotes.RigSync.AskRigWipe:FireServer(p1)
        end

        local function bindCharacter(p2) -- line: 24
            -- upvalues: Remotes (copy)
            p2:WaitForChild("Humanoid").Died:Connect(function() -- line: 27
                -- upvalues: p2 (copy), Remotes (copy)
                Remotes.RigSync.AskRigWipe:FireServer(p2)
            end)
        end

        LocalPlayer.CharacterAdded:Connect(bindCharacter)

        if LocalPlayer.Character then
            local Character = LocalPlayer.Character

            Character:WaitForChild("Humanoid").Died:Connect(function() -- line: 27
                -- upvalues: Character (copy), Remotes (copy)
                Remotes.RigSync.AskRigWipe:FireServer(Character)
            end)
        end
    end
}

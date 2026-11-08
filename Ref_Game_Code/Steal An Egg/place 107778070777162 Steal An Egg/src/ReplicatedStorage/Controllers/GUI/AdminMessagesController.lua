-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Globals.Constants)

local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

return {
    Start = function() -- Start | line: 10
        -- upvalues: Toast (copy), Remotes (copy)
        Remotes.Broadcasts.RaiseNotice.OnClientEvent:Connect(function(p1, p2) -- line: 12
            -- upvalues: Toast (copy)
            Toast.Show({
                Lane = "Banner",
                ShowShadow = true,
                Text = p1,
                Seconds = p2,
                Color = Color3.new(1, 1, 1)
            })
        end)
    end
}

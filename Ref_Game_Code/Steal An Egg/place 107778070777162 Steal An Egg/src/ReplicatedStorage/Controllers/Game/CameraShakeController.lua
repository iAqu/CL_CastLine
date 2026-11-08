-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ShakeRequestData = require(ReplicatedStorage.Client.Types.ShakeRequestData)

return {
    Start = function() -- Start | line: 11
        -- upvalues: CameraShaker (copy), CameraShakerDriver (copy), Remotes (copy), ShakeRequestData (copy)
        local v1 = CameraShaker.new()

        CameraShakerDriver.Start(v1, Enum.RenderPriority.Last.Value)
        Remotes.SharedFx.JoltOnce.OnClientEvent:Connect(function(p1) -- line: 16
            -- upvalues: v1 (copy), ShakeRequestData (copy)
            assert(ShakeRequestData.SchemaValidation(p1))
            v1:ShakeOnce(p1.Magnitude or 1, p1.Roughness or 1, p1.FadeInTime or 0, p1.FadeOutTime, p1.PosInfluence, p1.RotInfluence)
        end)
    end
}

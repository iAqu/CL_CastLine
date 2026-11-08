-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(script.Parent.Parent.RaceCamera)
require(ReplicatedStorage.Packages.Trove)

local n1 = 0

return {
    Bind = function(p1, p2, p3, _) -- Bind | line: 29
        -- upvalues: RunService (copy), MountRaceFlags (copy), MountRace (copy), n1 (ref)
        local Pad = p2:FindFirstChild("Pad")

        assert(Pad ~= nil and Pad:IsA("BasePart"), (("%* needs a Pad part"):format((p2:GetFullName()))))
        n1 += 1

        local v3 = ("SlowPad%*"):format(n1)

        p1:Add(function() -- line: 39
            -- upvalues: p3 (copy), v3 (copy)
            p3:SetSpeedScale(v3, nil)
        end)
        p1:Connect(RunService.Heartbeat, function() -- line: 42
            -- upvalues: p2 (copy), p3 (copy), Pad (copy), v3 (copy), MountRaceFlags (copy), MountRace (copy)
            p3:SetSpeedScale(v3, if MountRace.IsInsidePart(Pad, p3.Rig.Mount.Hitbox.Position, (Vector3.new(0, 4, 0))) then MountRace.NumberAttribute(p2, "SlowMultiplier", MountRaceFlags.SlowPadMultiplier:Get()) else nil)
        end)
    end
}

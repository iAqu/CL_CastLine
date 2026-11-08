-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(script.Parent.Parent.RaceCamera)

local RaceEffects = require(script.Parent.Parent.RaceEffects)

require(ReplicatedStorage.Packages.Trove)

return {
    Bind = function(p1, p2, p3, p4) -- Bind | line: 27
        -- upvalues: RunService (copy), MountRaceFlags (copy), MountRace (copy), RaceEffects (copy)
        local Pad = p2:FindFirstChild("Pad")

        assert(Pad ~= nil and Pad:IsA("BasePart"), (("%* needs a Pad part"):format((p2:GetFullName()))))

        local v3 = false

        p1:Connect(RunService.Heartbeat, function() -- line: 36
            -- upvalues: p2 (copy), p3 (copy), p4 (copy), Pad (copy), v3 (ref), MountRaceFlags (copy), MountRace (copy), RaceEffects (copy)
            local v4 = MountRace.IsInsidePart(Pad, p3.Rig.Mount.Hitbox.Position, (Vector3.new(0, 4, 0)))

            if v4 and not v3 then
                p3:ApplyBoost(MountRace.NumberAttribute(p2, "BoostMultiplier", MountRaceFlags.BoostPadMultiplier:Get()), MountRace.NumberAttribute(p2, "BoostSeconds", MountRaceFlags.BoostPadSeconds:Get()))
                RaceEffects.Boost(p3, p4)
            end

            v3 = v4
        end)
    end
}

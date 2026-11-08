-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(script.Parent.Parent.RaceCamera)
require(ReplicatedStorage.Packages.Trove)

return {
    Bind = function(p1, p2, p3, _) -- Bind | line: 29
        -- upvalues: RunService (copy), MountRaceFlags (copy), MountRace (copy)
        local Start = p2:FindFirstChild("Start")
        local End = p2:FindFirstChild("End")

        assert(Start ~= nil and Start:IsA("BasePart"), (("%* needs a Start part"):format((p2:GetFullName()))))
        assert(End ~= nil and End:IsA("BasePart"), (("%* needs an End part"):format((p2:GetFullName()))))

        local elapsed
        local v5 = false

        local function release() -- line: 42
            -- upvalues: p3 (copy), elapsed (ref)
            elapsed = nil
            p3:SetStickMode(nil)
        end

        p1:Add(function() -- line: 46
            -- upvalues: p3 (copy), elapsed (ref)
            if elapsed ~= nil then
                elapsed = nil
                p3:SetStickMode(nil)
            end
        end)
        p1:Connect(RunService.Heartbeat, function() -- line: 52
            -- upvalues: p2 (copy), p3 (copy), Start (copy), End (copy), elapsed (ref), v5 (ref), MountRaceFlags (copy), MountRace (copy)
            local HitboxPosition = p3.Rig.Mount.Hitbox.Position
            local v6 = MountRace.IsInsidePart(Start, HitboxPosition, (Vector3.new(2, 6, 2)))
            local elapsed2 = elapsed

            if elapsed2 ~= nil then
                local v7 = os.clock() - elapsed2

                if p3.StickMinRatio == nil or v7 > 0.5 and MountRace.IsInsidePart(End, HitboxPosition, (Vector3.new(2, 6, 2))) or v7 > 10 then
                    elapsed = nil
                    p3:SetStickMode(nil)
                end
            elseif v6 and not v5 and p3.Speed > 0 then
                elapsed = os.clock()
                p3:SetStickMode(MountRace.NumberAttribute(p2, "MinSpeedRatio", MountRaceFlags.LoopMinSpeedRatio:Get()))
            end

            v5 = v6
        end)
    end
}

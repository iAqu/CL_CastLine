-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(script.Parent.Parent.RaceCamera)

local RaceEffects = require(script.Parent.Parent.RaceEffects)

require(ReplicatedStorage.Packages.Trove)

return {
    Bind = function(p1, p2, p3, p4) -- Bind | line: 41
        -- upvalues: RunService (copy), SoundService (copy), Workspace (copy), MountRaceFlags (copy), MountRace (copy), RaceEffects (copy)
        local Start = p2:FindFirstChild("Start")
        local End = p2:FindFirstChild("End")

        assert(Start ~= nil and Start:IsA("BasePart"), (("%* needs a Start part"):format((p2:GetFullName()))))
        assert(End ~= nil and End:IsA("BasePart"), (("%* needs an End part"):format((p2:GetFullName()))))

        local Rig = p3.Rig
        local Y = MountRace.RiderFrame(Rig.Mount, CFrame.identity).Position.Y
        local LaunchSpeedMultiplier = p2:GetAttribute("LaunchSpeedMultiplier")

        if type(LaunchSpeedMultiplier) ~= "number" then
            LaunchSpeedMultiplier = 1
        end

        local v5 = MountRace.NumberAttribute(p2, "MaxLandingFallSpeed", 0)
        local n1 = 0
        local v6 = false

        local function launch() -- line: 59
            -- upvalues: p1 (copy), p3 (copy), p4 (copy), End (copy), Rig (copy), Y (copy), LaunchSpeedMultiplier (ref), v5 (copy), n1 (ref), RunService (copy), SoundService (copy), Workspace (copy), MountRaceFlags (copy), MountRace (copy), RaceEffects (copy)
            local Root = Rig.Root
            local v7 = End.Position + Vector3.new(0, 1, 0) * Y - Root.Position
            local v8 = Vector3.new(v7.X, 0, v7.Z)

            if v8.Unit:Dot(p3.TravelDirection) < 0.3 then
                return
            end

            local v10 = math.max((Root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude, MountRaceFlags.TopSpeed:Get() * 0.8) * LaunchSpeedMultiplier
            local v11 = v8.Magnitude / v10
            local v12 = (v7.Y + 0.5 * Workspace.Gravity * v11 * v11) / v11

            p3:Launch(v8.Unit * v10 + Vector3.new(0, 1, 0) * v12)
            p3:PlayJumpAnimation()
            p3.Heading = v8.Unit
            SoundService:PlayLocalSound(MountRace.Sounds.HitJump)
            n1 += 1

            local v13 = n1

            p1:Add(p3.Landed:Once(function() -- line: 77
                -- upvalues: v13 (copy), p3 (copy), p4 (copy), n1 (ref), RaceEffects (copy)
                if v13 == n1 then
                    p3:ApplyBoost(1.15, 0.6)
                    RaceEffects.Boost(p3, p4)
                end
            end))
            task.delay(v11 + 1.5, function() -- line: 83
                -- upvalues: v13 (copy), p3 (copy), n1 (ref)
                if v13 == n1 then
                    p3.Launched = false
                end
            end)

            if not (v5 > 0) then
                return
            end

            local Hitbox = Rig.Mount.Hitbox
            local connection

            connection = p1:Connect(RunService.Heartbeat, function(p5) -- line: 92
                -- upvalues: Root (copy), v13 (copy), Hitbox (copy), connection (ref), p1 (copy), p3 (copy), v5 (copy), n1 (ref), Workspace (copy)
                if v13 ~= n1 or not p3.Launched then
                    p1:Remove(connection)
                else
                    local AssemblyLinearVelocity = Root.AssemblyLinearVelocity

                    if not (AssemblyLinearVelocity.Y >= -v5) then
                        local v14 = Hitbox.Size.Y / 2 - AssemblyLinearVelocity.Y * p5 * 2 + 2

                        if Workspace:Raycast(Hitbox.Position, Vector3.new(0, 1, 0) * -v14, p3.Params) ~= nil then
                            Root.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, -v5, AssemblyLinearVelocity.Z)
                        end
                    end
                end
            end)
        end

        p1:Connect(RunService.Heartbeat, function() -- line: 111
            -- upvalues: p3 (copy), Start (copy), Rig (copy), v6 (ref), launch (copy), MountRace (copy)
            local v16 = MountRace.IsInsidePart(Start, Rig.Mount.Hitbox.Position, (Vector3.new(0, 6, 0)))

            if v16 and not v6 and p3.Speed > 0 then
                launch()
            end

            v6 = v16
        end)
    end
}

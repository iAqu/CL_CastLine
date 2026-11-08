-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)
local GUI = require(ReplicatedStorage.Client.GUI)

require(script.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(ReplicatedStorage.Shared.Modules.RaceTrackPath)
require(ReplicatedStorage.Packages.Trove)

local function fade(p1, p2, p3) -- line: 33
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = p2
    })

    tween:Play()
    tween.Completed:Wait()
end

local function sparkle(p4) -- line: 43
    -- upvalues: EmitOnce (copy), MountRace (copy)
    local clone = MountRace.Effects.RespawnSparkle:Clone()

    clone.CFrame = p4
    clone.Parent = workspace

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            EmitOnce(descendant)
        end
    end

    task.delay(2, clone.Destroy, clone)
end

local function isUnderFloor(p5, p6) -- line: 56
    for _, v1 in p5 do
        local v2 = v1.CFrame:PointToObjectSpace(p6)
        local v3 = v1.Size / 2

        if v2.Y < v3.Y and math.abs(v2.X) <= v3.X and math.abs(v2.Z) <= v3.Z then
            return true
        end
    end

    return false
end

return {
    Run = function(p7, p8, p9, p10, p11) -- Run | line: 71
        -- upvalues: RunService (copy), SoundService (copy), TweenService (copy), MountRaceFlags (copy), GUI (copy), MountRace (copy), fade (copy), sparkle (copy), isUnderFloor (copy)
        local t2 = {}

        for _, child in p10.FallOffFloors:GetChildren() do
            assert(child:IsA("BasePart"), (("%* is not a BasePart"):format((child:GetFullName()))))
            table.insert(t2, child)
        end

        assert(#t2 > 0, (("%* has no floors"):format((p10.FallOffFloors:GetFullName()))))

        local v7 = GUI.FadeFrame()
        local v8 = p11:Project(p9.Root.Position, 0, p11.Length, p11.Length)
        local v9 = v8
        local v10 = false

        local function respawn() -- line: 89
            -- upvalues: p7 (copy), p8 (copy), p9 (copy), p11 (copy), v7 (copy), v8 (ref), v9 (ref), v10 (ref), RunService (copy), SoundService (copy), TweenService (copy), MountRaceFlags (copy), MountRace (copy), fade (copy), sparkle (copy)
            v10 = true
            p8:SetHold("Respawn", true)
            fade(v7, 0, MountRaceFlags.RespawnFadeSeconds:Get())

            local v11, v12 = p11:RespawnAt(v9)

            v8 = v12
            v9 = v12

            local v13 = MountRace.RiderFrame(p9.Mount, v11)

            p8:Place(v13 + v13.UpVector * 30)
            task.spawn(fade, v7, 1, MountRaceFlags.RespawnFadeSeconds:Get())

            local elapsed = os.clock()
            local v14 = p7:Extend()

            v14:Connect(RunService.Heartbeat, function() -- line: 103
                -- upvalues: v13 (copy), elapsed (copy), p8 (copy), TweenService (copy)
                local Value = TweenService:GetValue(math.min((os.clock() - elapsed) / 0.6, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local v17 = CFrame.Angles(0, (1 - Value) * 1 * 3.141592653589793 * 2, 0)

                p8:Place(v13 * CFrame.new(0, (1 - Value) * 30, 0) * v17)
            end)
            task.wait(0.6)
            v14:Destroy()
            p8:Place(v13)
            sparkle(v13)
            SoundService:PlayLocalSound(MountRace.Sounds.Respawn)
            p8:SetHold("Respawn", false)
            v10 = false
        end

        p7:Add(function() -- line: 118
            -- upvalues: v7 (copy)
            v7.BackgroundTransparency = 1
        end)
        p7:Connect(RunService.Heartbeat, function() -- line: 121
            -- upvalues: p7 (copy), p8 (copy), p9 (copy), p11 (copy), t2 (copy), v8 (ref), v9 (ref), v10 (ref), respawn (copy), MountRaceFlags (copy), isUnderFloor (copy)
            if v10 then
                return
            end

            v8 = p11:Project(p9.Root.Position, v8, 30, 80)

            if p8.Grounded then
                v9 = v8
            end

            local v18 = isUnderFloor(t2, p9.Root.Position)

            if not v18 then
                v18 = p8.AirSeconds > MountRaceFlags.AirFallSeconds:Get() and not p8.Launched
            end

            if v18 then
                p7:Add(task.spawn(respawn))
            end
        end)
    end
}

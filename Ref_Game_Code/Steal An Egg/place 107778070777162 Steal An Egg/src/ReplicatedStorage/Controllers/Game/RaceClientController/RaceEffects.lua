-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)

require(script.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(script.Parent.RaceCamera)

local v1 = NumberRange.new(20, 35)
local v2 = Random.new()

local function burst(p1, p2) -- line: 40
    -- upvalues: Workspace (copy), EmitOnce (copy)
    local clone = p1:Clone()

    clone.CFrame = p2
    clone.Parent = Workspace

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            EmitOnce(descendant)
        end
    end

    task.delay(3, clone.Destroy, clone)
end

local function flash() -- line: 52
    -- upvalues: Lighting (copy), TweenService (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Parent = Lighting

    local tween = TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.15), {
        Brightness = 0.35,
        Saturation = 0.3
    })

    tween:Play()
    tween.Completed:Wait()

    local tween2 = TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Saturation = 0
    })

    tween2:Play()
    tween2.Completed:Wait()
    ColorCorrectionEffect:Destroy()
end

return {
    Finish = function(p3, p4) -- Finish | line: 68
        -- upvalues: SoundService (copy), MountRace (copy), v1 (copy), v2 (copy), burst (copy), flash (copy)
        SoundService:PlayLocalSound(MountRace.Sounds.Finish)
        p4:PunchFov(20)
        task.spawn(flash)

        local _CFrame = p3.FinishLine.CFrame

        task.spawn(function() -- line: 73
            -- upvalues: _CFrame (copy), SoundService (copy), MountRace (copy), v1 (copy), v2 (copy), burst (copy)
            for _ = 1, 4 do
                local v5 = Vector3.new(v2:NextNumber(-25, 25), v2:NextNumber(v1.Min, v1.Max), 0)

                burst(MountRace.Effects.Fireworks, _CFrame * CFrame.new(v5))
                SoundService:PlayLocalSound(MountRace.Sounds.Firework)
                task.wait(0.35)
            end
        end)
    end,
    Boost = function(p5, p6) -- Boost | line: 87
        -- upvalues: SoundService (copy), MountRace (copy), burst (copy)
        SoundService:PlayLocalSound(MountRace.Sounds.Boost)
        p6:PunchFov(12)

        local Hitbox = p5.Rig.Mount.Hitbox

        burst(MountRace.Effects.BoostBurst, Hitbox.CFrame * CFrame.new(0, 0, Hitbox.Size.Z / 2))
    end
}

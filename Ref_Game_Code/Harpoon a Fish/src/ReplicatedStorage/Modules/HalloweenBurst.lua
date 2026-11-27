-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local GhostTriggerVFX = ReplicatedStorage:WaitForChild("HalloweenFx"):WaitForChild("GhostTriggerVFX")
local v1 = Color3.new(0, 0, 0)

task.spawn(function() -- line: 14
    -- upvalues: ContentProvider (copy), GhostTriggerVFX (copy)
    local function v2() -- line: 14
        -- upvalues: ContentProvider (copy), GhostTriggerVFX (copy)
        ContentProvider:PreloadAsync({
            GhostTriggerVFX
        })
    end

    pcall(v2)
end)

local t1 = {
    BACK = 2.7
}

function t1.Play(p1) -- line: 19
    -- upvalues: Debris (copy), GhostTriggerVFX (copy), v1 (copy)
    local clone = GhostTriggerVFX:Clone()

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.Transparency = 1
    clone.CFrame = CFrame.new(p1)

    local v3 = ColorSequence.new(v1)
    local n1 = 4

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local t2 = {}

            for _, v4 in ipairs(descendant.Size.Keypoints) do
                t2[#t2 + 1] = NumberSequenceKeypoint.new(v4.Time, v4.Value * 3, v4.Envelope * 3)
            end

            descendant.Size = NumberSequence.new(t2)
            descendant.Speed = NumberRange.new(descendant.Speed.Min * 3, descendant.Speed.Max * 3)
            descendant.Lifetime = NumberRange.new(descendant.Lifetime.Min * 3, descendant.Lifetime.Max * 3)
            descendant.Color = v3
            descendant.LightEmission = 0
            descendant.LightInfluence = 0

            local v5 = tonumber(descendant:GetAttribute("EmitCount")) or 20
            local v6 = tonumber(descendant:GetAttribute("EmitDelay")) or 0

            n1 = math.max(n1, v6 + descendant.Lifetime.Max + 1)
            task.delay(v6, function() -- line: 40
                -- upvalues: descendant (copy), v5 (copy)
                if descendant.Parent then
                    descendant:Emit(v5)
                end
            end)
        end
    end

    clone.Parent = workspace
    Debris:AddItem(clone, n1)
end

return t1

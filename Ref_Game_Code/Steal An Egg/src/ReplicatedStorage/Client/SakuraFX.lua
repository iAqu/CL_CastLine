-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Sakura = require(ReplicatedStorage.Data.Sakura)
local Audio = require(ReplicatedStorage.Shared.Audio)
local t1 = {}
local Sakura2 = ReplicatedStorage.Assets.VFX:WaitForChild("Sakura")

local function spawnAnchor(p1, p2) -- line: 39
    -- upvalues: Debris (copy), Workspace (copy)
    local Part = Instance.new("Part")

    Part.Name = "SakuraFXHost"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1) * p2
    Part.Position = p1
    Part.Parent = Workspace
    Debris:AddItem(Part, 6)

    return Part
end

local function cue(p3, p4, p5, p6, p7, p8) -- line: 54
    -- upvalues: Sakura (copy), Audio (copy)
    local v1 = Sakura.Sounds[p3]

    assert(v1 ~= nil, (("no sound id catalogued under Sakura.Sounds.%*"):format(p3)))

    return Audio.Play(v1, p4, {
        PlaybackSpeed = p6 or 1,
        Volume = p5 or 1,
        MaxDistance = p7 or 120,
        Looped = p8
    })
end

function t1.EmitBurst(p9, p10, p11, p12) -- line: 72
    -- upvalues: Debris (copy), Workspace (copy), Sakura2 (copy)
    local v4 = Sakura2:FindFirstChild(p9)

    assert(v4 ~= nil, (("no burst prefab named %* under Assets.VFX.Sakura"):format(p9)))
    p12 = p12 or 4

    local Part = Instance.new("Part")

    Part.Name = "SakuraFXHost"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1) * p12
    Part.Position = p10
    Part.Parent = Workspace
    Debris:AddItem(Part, 6)

    for _, child in v4:GetChildren() do
        if child:IsA("ParticleEmitter") then
            local clone = child:Clone()

            clone.Enabled = false
            clone.Parent = Part
            clone:Emit((math.max(1, (math.floor(p11 * math.max(child.Rate, 1) / 20)))))
        end
    end

    return Part
end

function t1.PlayCue(p13, p14, p15, p16, p17) -- line: 98
    -- upvalues: cue (copy)
    return cue(p13, p14, p15, p16, p17)
end

function t1.PlayLooped(p18, p19, p20, p21) -- line: 108
    -- upvalues: cue (copy)
    return cue(p18, p19, p20, p21, nil, true)
end

return t1

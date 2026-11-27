-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local Folder

local function getFolder() -- line: 10
    -- upvalues: Folder (ref)
    if Folder then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "Vfx"

    local Folder2 = Folder

    Folder2.Parent = workspace

    return Folder
end

function t1.folder() -- line: 20
    -- upvalues: Folder (ref)
    if Folder then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "Vfx"
    Folder.Parent = workspace

    return Folder
end

function t1.holder(p1, p2) -- line: 25
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = p2
    Part.CFrame = p1

    if not Folder then
        Folder = Instance.new("Folder")
        Folder.Name = "Vfx"
        Folder.Parent = workspace
    end

    Part.Parent = Folder

    return Part
end

function t1.emitter(p3, p4, p5) -- line: 40
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = p4
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Rate = 0

    for v1, v2 in p5 do
        ParticleEmitter[v1] = v2
    end

    ParticleEmitter.Parent = p3

    return ParticleEmitter
end

function t1.seq(...) -- line: 54
    local t2 = { ... }
    local t3 = {}

    for i = 1, #t2, 2 do
        table.insert(t3, NumberSequenceKeypoint.new(t2[i], t2[i + 1]))
    end

    return NumberSequence.new(t3)
end

return t1

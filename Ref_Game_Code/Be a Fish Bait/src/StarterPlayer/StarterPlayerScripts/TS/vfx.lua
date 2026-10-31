-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, ReplicatedStorage, SoundService, Workspace = services.Debris, services.ReplicatedStorage, services.SoundService, services.Workspace
local t1 = {}
local Speedlines = ReplicatedStorage:FindFirstChild("Speedlines")

assert(Speedlines, "Speedlines model not found in ReplicatedStorage")

local FlyingWave = ReplicatedStorage:FindFirstChild("FlyingWave")

assert(FlyingWave, "FlyingWave not found in ReplicatedStorage")

local RiftCrack = ReplicatedStorage:FindFirstChild("RiftCrack")

assert(RiftCrack, "RiftCrack model not found in ReplicatedStorage")

local function emitVFX(p1, p2) -- line: 15
    local v1 = if p2 == nil then 1 else p2

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")

            if EmitCount == nil then
                EmitCount = 1
            end

            descendant:Emit(EmitCount * v1)
        end
    end
end

local function setVFXEnabled(p3, p4) -- line: 30
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p4
        end
    end
end

local function findVfxTemplate(p5) -- line: 37
    -- upvalues: ReplicatedStorage (copy)
    local VFX = ReplicatedStorage:FindFirstChild("VFX")
    local RareFishSkillCheck = ReplicatedStorage:FindFirstChild("RareFishSkillCheck")

    if RareFishSkillCheck ~= nil then
        RareFishSkillCheck = RareFishSkillCheck:FindFirstChild("VFX")
    end

    if VFX ~= nil then
        VFX = VFX:FindFirstChild(p5)
    end

    if VFX ~= nil then
        return VFX
    end

    if RareFishSkillCheck == nil then
        return RareFishSkillCheck
    end

    return (RareFishSkillCheck:FindFirstChild(p5))
end

local function placeClonedVfx(p6, p7) -- line: 58
    -- upvalues: Workspace (copy)
    if p7 == nil then
        p6.Parent = Workspace

        return nil
    end

    if p6:IsA("Attachment") then
        p6.Parent = p7

        return nil
    end

    p6.Parent = Workspace

    if p6:IsA("BasePart") then
        p6.CFrame = p7.CFrame
        p6.Anchored = false
        p6.CanCollide = false

        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Part0 = p7
        WeldConstraint.Part1 = p6
        WeldConstraint.Parent = p6

        return nil
    end

    if p6:IsA("Model") then
        p6:PivotTo(p7.CFrame)
    end

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CFrame = p7.CFrame
            descendant.Anchored = false
            descendant.CanCollide = false

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = p7
            WeldConstraint.Part1 = descendant
            WeldConstraint.Parent = descendant
        end
    end
end

local function playClonedSound(p8, p9) -- line: 95
    -- upvalues: Debris (copy), ReplicatedStorage (copy), SoundService (copy)
    local v2 = if p9 == nil then {} else p9
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")
    local v3 = if Sounds == nil then Sounds else Sounds:FindFirstChild("sfx")
    local v4 = if v3 ~= nil then v3 elseif Sounds == nil then Sounds else Sounds:FindFirstChild("SFX")

    if v4 ~= nil then
        v4 = v4:FindFirstChild(p8)
    end

    local clone, v5

    if v4 ~= nil then
        if v4:IsA("Sound") then
            clone = v4:Clone()
            clone.Looped = false
            clone.Playing = false

            if v2.playbackSpeed ~= nil then
                clone.PlaybackSpeed = v2.playbackSpeed
            end

            v5 = false
        else
            v5 = true
        end
    else
        v5 = true
    end

    if v5 then
        warn((("[VFX] ReplicatedStorage.Sounds.sfx/%* not found or not a Sound"):format(p8)))

        return nil
    end

    if v2.volume ~= nil then
        clone.Volume = v2.volume
    end

    clone.Parent = SoundService

    local timePosition

    if v2.timePosition ~= nil then
        if clone.TimeLength > 0 then
            timePosition = math.clamp(v2.timePosition, 0, clone.TimeLength)
        else
            timePosition = v2.timePosition

            if timePosition == nil then
                timePosition = 0
            end
        end
    else
        timePosition = v2.timePosition

        if timePosition == nil then
            timePosition = 0
        end
    end

    clone.TimePosition = timePosition

    local connection

    connection = clone.Ended:Connect(function() -- line: 144
        -- upvalues: clone (ref), connection (ref)
        connection:Disconnect()
        clone:Destroy()
    end)
    clone:Play()

    local v6 = clone.TimeLength + 1

    Debris:AddItem(clone, (math.max(3, v6)))
end

local function playClonedVfxWithSound(p10, p11, p12) -- line: 151
    -- upvalues: Debris (copy), ReplicatedStorage (copy), emitVFX (copy), findVfxTemplate (copy), placeClonedVfx (copy)
    local v7 = if p12 == nil then {} else p12
    local playSound = v7.playSound

    if playSound == nil then
        playSound = true
    end

    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild("sfx")
    end

    local v8 = findVfxTemplate(p10)

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild(p11)
    end

    if v8 ~= nil then
        if not playSound or Sounds ~= nil then
            local clone = v8:Clone()
            local v9 = if not playSound then nil elseif Sounds == nil then Sounds else Sounds:Clone()

            placeClonedVfx(clone, v7.targetPart)

            if if v9 == nil then v9 else v9:IsA("Sound") then
                if v7.soundPlaybackSpeed ~= nil then
                    v9.PlaybackSpeed = v7.soundPlaybackSpeed
                end

                v9.Parent = clone

                local connection

                connection = v9.Ended:Connect(function() -- line: 203
                    -- upvalues: clone (copy), connection (ref)
                    connection:Disconnect()

                    if clone.Parent ~= nil then
                        clone:Destroy()
                    end
                end)
                v9:Play()
            elseif playSound then
                warn((("[VFX] ReplicatedStorage.Sounds.sfx.%* is not a Sound"):format(p11)))
            end

            emitVFX(clone)

            local lifetimeSeconds = v7.lifetimeSeconds

            if lifetimeSeconds == nil then
                lifetimeSeconds = 10
            end

            Debris:AddItem(clone, (math.max(0.1, lifetimeSeconds)))

            return
        end

        warn((("[VFX] ReplicatedStorage.Sounds.sfx.%* not found"):format(p11)))
    else
        warn((("[VFX] %* not found in ReplicatedStorage.VFX or ReplicatedStorage.RareFishSkillCheck.VFX"):format(p10)))
    end

    return nil
end

local function playClonedVfxAtCFrame(p13, p14, p15, p16) -- line: 221
    -- upvalues: Debris (copy), ReplicatedStorage (copy), Workspace (copy), t1 (copy), emitVFX (copy), findVfxTemplate (copy), placeClonedVfx (copy)
    local v10 = if p16 == nil then 10 else p16
    local VFX

    if p15 ~= nil then
        VFX = ReplicatedStorage:FindFirstChild("VFX")

        if VFX ~= nil then
            VFX = VFX:FindFirstChild(p15)

            if VFX ~= nil then
                VFX = VFX:FindFirstChild(p13)
            end
        end
    else
        VFX = findVfxTemplate(p13)
    end

    local v11 = if p15 == nil then p13 else ("%*/%*"):format(p15, p13)

    if VFX == nil then
        if t1[v11] == nil then
            t1[v11] = true
            warn((("[VFX] %* not found in ReplicatedStorage.VFX%*"):format(p13, if p15 == nil then "" else (".%*"):format(p15))))
        end

        return nil
    end

    local Part = Instance.new("Part")

    Part.Name = ("%*Holder"):format(p13)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.CFrame = p14
    Part.Parent = Workspace

    if p15 ~= nil then
        local clone = VFX:Clone()

        placeClonedVfx(clone, Part)
        emitVFX(clone)
        Debris:AddItem(clone, (math.max(0.1, v10)))
    else
        local clone = VFX:Clone()

        placeClonedVfx(clone, Part)
        emitVFX(clone)
        Debris:AddItem(clone, (math.max(0.1, v10)))
    end

    Debris:AddItem(Part, (math.max(0.1, v10)))
end

local function cloneScopedVfxAtCFrame(p17, p18, p19) -- line: 273
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), t1 (copy), emitVFX (copy)
    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild(p19)

        if VFX ~= nil then
            VFX = VFX:FindFirstChild(p17)
        end
    end

    local v12 = ("%*/%*"):format(p19, p17)

    if VFX == nil then
        if t1[v12] == nil then
            t1[v12] = true
            warn((("[VFX] %* not found in ReplicatedStorage.VFX.%*"):format(p17, p19)))
        end

        return nil
    end

    local clone = VFX:Clone()

    clone.Parent = Workspace

    if clone:IsA("Model") then
        clone:PivotTo(p18)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end
    elseif clone:IsA("BasePart") then
        clone.CFrame = p18
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
    end

    emitVFX(clone)

    return clone
end

return {
    emitVFX = emitVFX,
    setVFXEnabled = setVFXEnabled,
    playClonedSound = playClonedSound,
    playClonedVfxWithSound = playClonedVfxWithSound,
    playClonedVfxAtCFrame = playClonedVfxAtCFrame,
    cloneScopedVfxAtCFrame = cloneScopedVfxAtCFrame,
    playClonedSoundAtCFrame = function(p20, p21) -- playClonedSoundAtCFrame | line: 313
        -- upvalues: Debris (copy), ReplicatedStorage (copy), Workspace (copy), t1 (copy)
        local Sounds = ReplicatedStorage:FindFirstChild("Sounds")
        local v13 = if Sounds == nil then Sounds else Sounds:FindFirstChild("sfx")
        local v14 = if v13 ~= nil then v13 elseif Sounds == nil then Sounds else Sounds:FindFirstChild("SFX")

        if v14 ~= nil then
            v14 = v14:FindFirstChild(p20)
        end

        if not (if v14 == nil then v14 else v14:IsA("Sound")) then
            local v15 = ("sound/%*"):format(p20)

            if t1[v15] == nil then
                t1[v15] = true
                warn((("[VFX] ReplicatedStorage.Sounds.sfx.%* is missing or not a Sound"):format(p20)))
            end

            return nil
        end

        local Part = Instance.new("Part")

        Part.Name = ("%*Holder"):format(p20)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.CFrame = p21
        Part.Parent = Workspace

        local clone = v14:Clone()

        clone.Looped = false
        clone.Parent = Part
        clone:Play()
        Debris:AddItem(Part, (math.max(3, clone.TimeLength + 1)))
    end,
    speedlines = Speedlines,
    flyingWave = FlyingWave,
    riftCrack = RiftCrack
}

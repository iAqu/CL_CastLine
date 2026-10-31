-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, ReplicatedStorage, Workspace = services.Debris, services.ReplicatedStorage, services.Workspace
local v1
local v2 = false

local function getRareFishVfxFolder() -- line: 13
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), v1 (ref), v2 (ref)
    if v2 then
        return v1
    end

    v2 = true

    local RareFishSkillCheck = ReplicatedStorage:FindFirstChild("RareFishSkillCheck")

    if RareFishSkillCheck ~= nil then
        RareFishSkillCheck = RareFishSkillCheck:FindFirstChild("VFX")
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("RareFishSkillCheck")
    end

    local RareFishSkillCheck2 = Workspace:FindFirstChild("RareFishSkillCheck")

    if RareFishSkillCheck2 ~= nil then
        RareFishSkillCheck2 = RareFishSkillCheck2:FindFirstChild("VFX")
    end

    for _, v3 in { RareFishSkillCheck, VFX, RareFishSkillCheck2 } do
        if v3 ~= nil then
            v1 = v3

            return v1
        end
    end

    warn("[RareFishBossVFX] RareFishSkillCheck/VFX folder not found — boss VFX disabled")

    return nil
end

local function emitAll(p1) -- line: 40
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")

            if type(EmitCount) ~= "number" then
                EmitCount = 1
            end

            descendant:Emit(EmitCount)
        elseif descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Enabled = true
        end
    end

    if not p1:IsA("ParticleEmitter") then
        return
    end

    local EmitCount = p1:GetAttribute("EmitCount")

    if type(EmitCount) ~= "number" then
        EmitCount = 1
    end

    p1:Emit(EmitCount)
end

local function setRareFishVfxEnabled(p2, p3) -- line: 55
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Enabled = p3
        end
    end

    if p2:IsA("ParticleEmitter") or p2:IsA("Beam") or p2:IsA("Trail") then
        p2.Enabled = p3
    end
end

local function playRareFishVfx(p4) -- line: 72
    -- upvalues: Debris (copy), Workspace (copy), getRareFishVfxFolder (copy), emitAll (copy)
    local v4 = getRareFishVfxFolder()

    if v4 ~= nil then
        v4 = v4:FindFirstChild(p4.name)
    end

    if v4 == nil then
        warn((("[RareFishBossVFX] VFX \"%*\" not found — skipping"):format(p4.name)))

        return nil
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = p4.cframe or CFrame.new()
    Part.Parent = p4.parent or Workspace

    local clone = v4:Clone()

    clone.Parent = Part

    if clone:IsA("BasePart") then
        clone.Anchored = true
        clone.CanCollide = false
        clone.CFrame = Part.CFrame
    elseif clone:IsA("Model") then
        clone:PivotTo(Part.CFrame)
    end

    emitAll(clone)

    local cleanupAfterSeconds = p4.cleanupAfterSeconds

    if cleanupAfterSeconds == nil then
        cleanupAfterSeconds = 4
    end

    Debris:AddItem(Part, cleanupAfterSeconds)

    return Part
end

return {
    getRareFishVfxFolder = getRareFishVfxFolder,
    setRareFishVfxEnabled = setRareFishVfxEnabled,
    playRareFishVfx = playRareFishVfx,
    cloneRareFishVfx = function(p5, p6) -- cloneRareFishVfx | line: 117
        -- upvalues: getRareFishVfxFolder (copy)
        local v5 = getRareFishVfxFolder()

        if v5 ~= nil then
            v5 = v5:FindFirstChild(p5)
        end

        if v5 == nil then
            warn((("[RareFishBossVFX] VFX \"%*\" not found — skipping"):format(p5)))

            return nil
        end

        local clone = v5:Clone()

        if clone:IsA("BasePart") then
            clone.Anchored = true
            clone.CanCollide = false
        end

        clone.Parent = p6

        return clone
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Emit = require(ReplicatedStorage.UserGenerated.VFX.Emit)

local function PlayVFX(p1, p2, p3) -- line: 25
    -- upvalues: Debris (copy), Emit (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.CFrame = p1.CFrame:ToObjectSpace(p2)

    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Parent = Attachment
        end
    end

    if p3:IsA("ParticleEmitter") then
        p3.Parent = Attachment
    else
        p3:Destroy()
    end

    Attachment.Parent = p1
    Debris:AddItem(Attachment, Emit(Attachment))
end

return PlayVFX

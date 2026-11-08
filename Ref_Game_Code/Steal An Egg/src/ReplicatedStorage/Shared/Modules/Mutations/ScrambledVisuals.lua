-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    Clear = function(p1) -- Clear | line: 6
        for _, descendant in p1:GetDescendants() do
            if descendant:HasTag("Cleanup_Scrambled") then
                descendant:Destroy()
            end
        end
    end
}

local function emitter(p2, p3, p4) -- line: 12
    local clone = p2:Clone()
    local t2 = {}

    for _, v1 in p2.Size.Keypoints do
        table.insert(t2, NumberSequenceKeypoint.new(v1.Time, v1.Value * p4, v1.Envelope * p4))
    end

    clone.Size = NumberSequence.new(t2)
    clone.Speed = NumberRange.new(p2.Speed.Min * p4, p2.Speed.Max * p4)
    clone.Acceleration = p2.Acceleration * p4
    clone:AddTag("Cleanup_Scrambled")
    clone:AddTag("Effect")
    clone.Parent = p3
end

function t1.Apply(p5, p6) -- line: 26
    -- upvalues: ReplicatedStorage (copy), t1 (copy), emitter (copy)
    t1.Clear(p5)

    local Scrambled = ReplicatedStorage.Mutations:FindFirstChild("Scrambled")

    if Scrambled and p6 then
        local ReferenceSize = Scrambled:GetAttribute("ReferenceSize")
        local v4 = if typeof(ReferenceSize) == "Vector3" and ReferenceSize.Magnitude > 0 then math.clamp(p6.Size.Magnitude / ReferenceSize.Magnitude, 0.01, 100) else 1
        local Body = Scrambled:FindFirstChild("Body")

        if Body then
            for _, child in Body:GetChildren() do
                if child:IsA("ParticleEmitter") then
                    emitter(child, p6, v4)
                end
            end
        end

        local Eyes = Scrambled:FindFirstChild("Eyes")

        if not Eyes then
            return
        end

        local t3 = {}

        for _, descendant in p5:GetDescendants() do
            if descendant:IsA("Bone") and descendant.Name:lower():find("eye", 1, true) and not descendant.Name:lower():find("brow", 1, true) then
                table.insert(t3, descendant)
            end
        end

        if #t3 == 0 then
            for _, descendant in p5:GetDescendants() do
                if descendant:IsA("BasePart") and descendant:GetAttribute("IsEye") == true then
                    table.insert(t3, descendant)
                end
            end
        end

        for v6, v7 in t3 do
            if v6 > 8 then
                break
            end

            local Attachment = Instance.new("Attachment")

            Attachment.Name = "ScrambledEyeFX"

            local Attribute = Eyes:GetAttribute(v7.Name)

            if typeof(Attribute) == "CFrame" then
                Attachment.CFrame = Attribute.Rotation + Attribute.Position * v4
            end

            Attachment:AddTag("Cleanup_Scrambled")
            Attachment:AddTag("Effect")
            Attachment.Parent = v7

            for _, child in Eyes:GetChildren() do
                if child:IsA("ParticleEmitter") then
                    emitter(child, Attachment, v4)
                end
            end
        end
    end
end

return table.freeze(t1)

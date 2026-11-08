-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Attachment = true
}
local t2 = {
    BallSocketConstraint = true,
    HingeConstraint = true
}
local t3 = {
    Root = true,
    Neck = true
}
local t4 = {}

local function purgeTagged(p1, p2, p3, p4) -- line: 19
    local v1 = if p1 then p1:GetChildren() else {}

    for _, v2 in v1 do
        local v3 = p3[v2.ClassName] and v2:GetAttribute(p2)

        if v3 and (not p4 or v3 == p4) then
            v2:Destroy()
        end
    end
end

local function unrig(p5) -- line: 33
    -- upvalues: t1 (copy), t2 (copy), purgeTagged (copy)
    purgeTagged(p5.Parent, "RagdollConstraint", t2, p5.Name)
    purgeTagged(p5.Part0, "RagdollAttachment", t1, p5.Name)
    purgeTagged(p5.Part1, "RagdollAttachment", t1, p5.Name)
end

local function anchorPoint(p6, p7, p8, p9) -- line: 39
    local Attachment = Instance.new("Attachment")

    Attachment.Name = ("RagdollAttachment_%*_%*"):format(p7, p8)
    Attachment:SetAttribute("RagdollAttachment", p7)
    Attachment.Parent = p6
    Attachment.CFrame = p9

    return Attachment
end

local function rig(p10) -- line: 48
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), purgeTagged (copy)
    local Part0, Part1 = p10.Part0, p10.Part1

    if not Part0 or not Part1 then
        return nil
    end

    purgeTagged(p10.Parent, "RagdollConstraint", t2, p10.Name)
    purgeTagged(p10.Part0, "RagdollAttachment", t1, p10.Name)
    purgeTagged(p10.Part1, "RagdollAttachment", t1, p10.Name)

    local Name = p10.Name
    local BallSocketConstraint = Instance.new("BallSocketConstraint")
    local C0 = p10.C0
    local Attachment = Instance.new("Attachment")

    Attachment.Name = ("RagdollAttachment_%*_A"):format(Name)
    Attachment:SetAttribute("RagdollAttachment", Name)
    Attachment.Parent = Part0
    Attachment.CFrame = C0

    local C1 = p10.C1
    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = ("RagdollAttachment_%*_B"):format(Name)
    Attachment2:SetAttribute("RagdollAttachment", Name)
    Attachment2.Parent = Part1
    Attachment2.CFrame = C1
    BallSocketConstraint.Name = ("RagdollConstraint_%*"):format(Name)
    BallSocketConstraint:SetAttribute("RagdollConstraint", Name)
    BallSocketConstraint.Parent = p10.Parent
    BallSocketConstraint.Attachment0 = Attachment
    BallSocketConstraint.Attachment1 = Attachment2
    BallSocketConstraint.LimitsEnabled = true
    BallSocketConstraint.TwistLimitsEnabled = true

    if not t3[Name] then
        return BallSocketConstraint
    end

    BallSocketConstraint:Destroy()

    local HingeConstraint = Instance.new("HingeConstraint")

    HingeConstraint.Name = ("RagdollConstraint_%*"):format(Name)
    HingeConstraint:SetAttribute("RagdollConstraint", Name)
    HingeConstraint.Parent = p10.Parent
    HingeConstraint.Attachment0 = Attachment
    HingeConstraint.Attachment1 = Attachment2
    HingeConstraint.LimitsEnabled = true

    return HingeConstraint
end

local function joinsTool(p11) -- line: 89
    local Part1 = p11.Part1

    if p11:FindFirstAncestorOfClass("Tool") ~= nil then
        return true
    end

    return Part1 ~= nil and Part1:FindFirstAncestorOfClass("Tool") ~= nil
end

local function eachMotor(p12, p13) -- line: 95
    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("Motor6D") then
            local Part1 = descendant.Part1

            if descendant:FindFirstAncestorOfClass("Tool") == nil and (Part1 == nil or Part1:FindFirstAncestorOfClass("Tool") == nil) then
                p13(descendant)
            end
        end
    end
end

function t4.Bind(p14) -- line: 103
    -- upvalues: rig (copy), eachMotor (copy)
    eachMotor(p14, function(p15) -- line: 104
        -- upvalues: rig (copy)
        rig(p15)
        p15.Enabled = false
    end)
end

function t4.Release(p16) -- line: 110
    -- upvalues: t1 (copy), t2 (copy), purgeTagged (copy), eachMotor (copy)
    eachMotor(p16, function(p17) -- line: 111
        -- upvalues: t1 (copy), t2 (copy), purgeTagged (copy)
        if p17.Parent then
            purgeTagged(p17.Parent, "RagdollConstraint", t2, p17.Name)
            purgeTagged(p17.Part0, "RagdollAttachment", t1, p17.Name)
            purgeTagged(p17.Part1, "RagdollAttachment", t1, p17.Name)
            p17.Enabled = true
        end
    end)
end

return t4

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t1 = {
    "HumanoidRootPart",
    "Head",
    "UpperTorso",
    "LowerTorso",
    "Torso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

local function getAuraAsset(p1) -- line: 9
    -- upvalues: ReplicatedStorage (copy)
    if p1 == nil then
        return nil
    end

    local BaitAura = ReplicatedStorage:FindFirstChild("BaitAura")
    local v1 = if BaitAura == nil then BaitAura else BaitAura:FindFirstChild(p1)

    if v1 ~= nil then
        return v1
    end

    if p1 ~= "VoidsporeAura" then
        return nil
    end

    if BaitAura == nil then
        return BaitAura
    end

    return (BaitAura:FindFirstChild("RadioactiveAura"))
end

local function setVfxEnabled(p2, p3) -- line: 34
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") then
            descendant.Enabled = p3
        end
    end

    if p2:IsA("ParticleEmitter") or p2:IsA("Beam") or p2:IsA("Trail") or p2:IsA("Light") then
        p2.Enabled = p3
    end
end

local function scaleNumberRange(p4, p5) -- line: 44
    return NumberRange.new(p4.Min * p5, p4.Max * p5)
end

local function scaleNumberSequence(p6, p7) -- line: 47
    local Keypoints = p6.Keypoints
    local v2 = table.create(#Keypoints)

    for v3, v4 in Keypoints do
        local _ = v3 - 1

        v2[v3] = NumberSequenceKeypoint.new(v4.Time, v4.Value * p7, v4.Envelope * p7)
    end

    return NumberSequence.new(v2)
end

local function scaleParticleEmitter(p8, p9) -- line: 62
    -- upvalues: scaleNumberSequence (copy)
    local Speed = p8.Speed

    p8.Speed = NumberRange.new(Speed.Min * p9, Speed.Max * p9)
    p8.Size = scaleNumberSequence(p8.Size, p9)
end

local function resolveParticleEmitterScale(p10, p11, p12, p13) -- line: 76
    if p13 and p10 == "VoidsporeAura" and p11 == "Circle" then
        return 0.2
    end

    return p12
end

local function scaleAuraVfx(p14, p15, p16, p17) -- line: 82
    -- upvalues: scaleNumberSequence (copy)
    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local Name = descendant.Name
            local v5 = if p17 and p16 == "VoidsporeAura" and Name == "Circle" then 0.2 else p15
            local Speed = descendant.Speed

            descendant.Speed = NumberRange.new(Speed.Min * v5, Speed.Max * v5)
            descendant.Size = scaleNumberSequence(descendant.Size, v5)
        end
    end

    if p14:IsA("ParticleEmitter") then
        local Name = p14.Name
        local v6 = if p17 and p16 == "VoidsporeAura" and Name == "Circle" then 0.2 else p15
        local Speed = p14.Speed

        p14.Speed = NumberRange.new(Speed.Min * v6, Speed.Max * v6)
        p14.Size = scaleNumberSequence(p14.Size, v6)
    end
end

local function getRigRoot(p18) -- line: 92
    return p18:FindFirstChild("HumanoidRootPart", true) or p18.PrimaryPart or p18:FindFirstChildWhichIsA("BasePart", true)
end

local function getRigPartByName(p19, p20) -- line: 95
    local v7 = p19:FindFirstChild(p20, true)

    return if v7 ~= nil and v7:IsA("BasePart") then v7 else nil
end

local function rigHasAttachment(p21, p22) -- line: 102
    local v8 = p21:FindFirstChild(p22, true)

    return v8 ~= nil and (v8:IsA("Attachment"))
end

local function scaleAttachmentOffset(p23, p24) -- line: 114
    local _CFrame = p23.CFrame
    local CFramePosition = _CFrame.Position

    p23.CFrame = CFrame.fromMatrix(CFramePosition * p24, _CFrame.XVector, _CFrame.YVector, _CFrame.ZVector)
end

local function hasBodyPartContainers(p25) -- line: 120
    -- upvalues: t1 (copy)
    for _, descendant in p25:GetDescendants() do
        local Name = descendant.Name

        if table.find(t1, Name) ~= nil then
            return true
        end
    end

    for _, child in p25:GetChildren() do
        local Name = child.Name

        if table.find(t1, Name) ~= nil then
            return true
        end
    end

    return false
end

local function removeDecals(p26) -- line: 135
    for _, child in p26:GetChildren() do
        if child:IsA("Decal") then
            child:Destroy()
        end
    end
end

local isVfxInstance, hasQualifyingAncestor

local function parentAuraContainerToPart(p27, p28, p29, p30, p31, p32) -- line: 143
    -- upvalues: setVfxEnabled (copy), scaleAuraVfx (copy), removeDecals (copy), isVfxInstance (ref), hasQualifyingAncestor (ref)
    local v9 = false

    for _, descendant in p28:GetDescendants() do
        if isVfxInstance(descendant) or descendant:IsA("BasePart") then
            local hasQualifyingAncestor2 = hasQualifyingAncestor

            if not hasQualifyingAncestor2(descendant, p28, function(p33) -- line: 153
                -- upvalues: isVfxInstance (ref)
                return isVfxInstance(p33) or p33:IsA("BasePart")
            end) then
                local clone = descendant:Clone()
                local Name = descendant.Name

                clone.Name = "ActiveBaitAuraVfx"

                if clone:IsA("BasePart") then
                    clone.CFrame = p29.CFrame
                    clone.Anchored = false
                    clone.CanCollide = false
                    clone.CanTouch = false
                    clone.CanQuery = false
                    clone.Massless = true
                    clone.Transparency = 1

                    if p29.Name == "Head" then
                        removeDecals(clone)
                    end
                elseif clone:IsA("Attachment") then
                    local v10 = p27:FindFirstChild(Name, true)

                    if v10 == nil or not v10:IsA("Attachment") then
                        local _CFrame = clone.CFrame
                        local CFramePosition = _CFrame.Position

                        clone.CFrame = CFrame.fromMatrix(CFramePosition * p30, _CFrame.XVector, _CFrame.YVector, _CFrame.ZVector)
                    end
                end

                clone.Parent = p29

                if clone:IsA("BasePart") then
                    local WeldConstraint = Instance.new("WeldConstraint")

                    WeldConstraint.Part0 = clone
                    WeldConstraint.Part1 = p29
                    WeldConstraint.Parent = clone
                end

                scaleAuraVfx(clone, p30, p31, p32)
                v9 = true
                setVfxEnabled(clone, true)
            end
        end
    end

    return v9
end

function isVfxInstance(p34) -- line: 189
    return p34:IsA("Attachment") or p34:IsA("ParticleEmitter") or p34:IsA("Beam") or p34:IsA("Trail") or p34:IsA("Light")
end

function hasQualifyingAncestor(p35, p36, p37) -- line: 200
    local Parent = p35.Parent

    while true do
        if Parent == nil or Parent == p36 then
            return false
        end

        if p37(Parent) then
            break
        end

        Parent = Parent.Parent
    end

    return true
end

local function findBodyPartContainers(p38, p39) -- line: 218
    -- upvalues: t1 (copy)
    local t2 = {}

    for _, descendant in p39:GetDescendants() do
        local Name = descendant.Name

        if table.find(t1, Name) ~= nil then
            local v11 = p38:FindFirstChild(descendant.Name, true)

            if v11 ~= nil and not v11:IsA("BasePart") then
                v11 = nil
            end

            if v11 ~= nil then
                t2[descendant] = v11
            end
        end
    end

    return t2
end

local applyUnmappedAuraVfx

local function applyMappedAura(p40, p41, p42, p43, p44, p45) -- line: 233
    -- upvalues: parentAuraContainerToPart (copy), findBodyPartContainers (copy), applyUnmappedAuraVfx (ref)
    local v12 = false

    for v13, v14 in (findBodyPartContainers(p40, p41)) do
        v12 = parentAuraContainerToPart(p40, v13, v14, p43, p44, p45) or v12
    end

    if not v12 then
        applyUnmappedAuraVfx(p40, p41, p42, p43, p44, p45)
    end
end

function applyUnmappedAuraVfx(p46, p47, p48, p49, p50, p51) -- line: 248
    -- upvalues: setVfxEnabled (copy), scaleAuraVfx (copy), isVfxInstance (ref), hasQualifyingAncestor (ref)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "ActiveBaitAuraVfx"
    Attachment.Parent = p48

    local v15 = false

    for _, descendant in p47:GetDescendants() do
        if isVfxInstance(descendant) and (not descendant:IsA("Attachment") or #descendant:GetDescendants() ~= 0) and not hasQualifyingAncestor(descendant, p47, isVfxInstance) then
            local clone = descendant:Clone()
            local Name = descendant.Name

            clone.Name = "ActiveBaitAuraVfx"
            clone.Parent = Attachment

            if clone:IsA("Attachment") then
                local v16 = p46:FindFirstChild(Name, true)

                if v16 == nil or not v16:IsA("Attachment") then
                    local _CFrame = clone.CFrame
                    local CFramePosition = _CFrame.Position

                    clone.CFrame = CFrame.fromMatrix(CFramePosition * p49, _CFrame.XVector, _CFrame.YVector, _CFrame.ZVector)
                end
            end

            v15 = true
            scaleAuraVfx(clone, p49, p50, p51)
        end
    end

    if not v15 then
        Attachment:Destroy()

        return nil
    end

    setVfxEnabled(Attachment, true)
end

local function clearBaitAuraVfx(p52) -- line: 280
    local t3 = {}

    for _, descendant in p52:GetDescendants() do
        if descendant.Name == "ActiveBaitAuraVfx" then
            table.insert(t3, descendant)
        end
    end

    for _, v17 in t3 do
        v17:Destroy()
    end

    local ActiveBaitAuraVfx = p52:FindFirstChild("ActiveBaitAuraVfx")

    if ActiveBaitAuraVfx ~= nil then
        ActiveBaitAuraVfx:Destroy()
    end
end

return {
    activeBaitAuraVfxName = "ActiveBaitAuraVfx",
    miniRigAuraVfxScale = 0.5,
    getAuraAsset = getAuraAsset,
    clearBaitAuraVfx = clearBaitAuraVfx,
    applyBaitAuraVfx = function(p53, p54, p55, p56) -- applyBaitAuraVfx | line: 304
        -- upvalues: getAuraAsset (copy), hasBodyPartContainers (copy), applyUnmappedAuraVfx (ref), applyMappedAura (copy), clearBaitAuraVfx (copy)
        local v18 = if p55 == nil then 0.5 else p55
        local v19 = p56 == nil or p56

        clearBaitAuraVfx(p53)

        local v20 = getAuraAsset(p54)
        local v21 = p53:FindFirstChild("HumanoidRootPart", true) or p53.PrimaryPart or p53:FindFirstChildWhichIsA("BasePart", true)

        if v20 == nil or v21 == nil then
            return nil
        end

        if hasBodyPartContainers(v20) then
            applyMappedAura(p53, v20, v21, v18, p54, v19)

            return nil
        end

        applyUnmappedAuraVfx(p53, v20, v21, v18, p54, v19)
    end
}

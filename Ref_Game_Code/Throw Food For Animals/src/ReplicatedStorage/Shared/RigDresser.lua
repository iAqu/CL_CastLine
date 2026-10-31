-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {
    [Enum.AccessoryType.TShirt] = true,
    [Enum.AccessoryType.Shirt] = true,
    [Enum.AccessoryType.Pants] = true,
    [Enum.AccessoryType.Jacket] = true,
    [Enum.AccessoryType.Sweater] = true,
    [Enum.AccessoryType.Shorts] = true,
    [Enum.AccessoryType.LeftShoe] = true,
    [Enum.AccessoryType.RightShoe] = true,
    [Enum.AccessoryType.DressSkirt] = true
}
local t3 = {
    [Enum.AccessoryType.Hair] = "HairAttachment",
    [Enum.AccessoryType.Hat] = "HatAttachment",
    [Enum.AccessoryType.Face] = "FaceFrontAttachment",
    [Enum.AccessoryType.Eyebrow] = "FaceFrontAttachment",
    [Enum.AccessoryType.Eyelash] = "FaceFrontAttachment",
    [Enum.AccessoryType.Neck] = "NeckAttachment",
    [Enum.AccessoryType.Front] = "BodyFrontAttachment",
    [Enum.AccessoryType.Back] = "BodyBackAttachment",
    [Enum.AccessoryType.Waist] = "WaistCenterAttachment",
    [Enum.AccessoryType.Shoulder] = "RightCollarAttachment"
}

local function findAttachment(p1, p2) -- line: 64
    local DressedHead = p1:FindFirstChild("DressedHead")
    local Head = DressedHead and DressedHead:FindFirstChild("Head")

    if Head then
        local v1 = Head:FindFirstChild(p2)

        if v1 and v1:IsA("Attachment") then
            return v1, Head
        end
    end

    for _, child in ipairs(p1:GetChildren()) do
        if child:IsA("BasePart") then
            local v2 = child:FindFirstChild(p2)

            if v2 and v2:IsA("Attachment") then
                return v2, child
            end
        end
    end

    return nil
end

local function restoreLook(p3) -- line: 84
    local function fix(p4) -- line: 85
        if not (p4:IsA("BasePart") or p4:IsA("Decal")) then
            return
        end

        local OrigTransparency = p4:GetAttribute("OrigTransparency")

        if OrigTransparency ~= nil then
            p4.Transparency = OrigTransparency
            p4:SetAttribute("OrigTransparency", nil)
        end

        if p4:IsA("BasePart") then
            p4.LocalTransparencyModifier = 0
        end
    end

    fix(p3)

    for _, descendant in ipairs(p3:GetDescendants()) do
        fix(descendant)
    end
end

local function isClassicRig(p5) -- line: 100
    local Head = p5:FindFirstChild("Head")

    return Head ~= nil and not Head:IsA("MeshPart") and Head:FindFirstChildOfClass("SpecialMesh") ~= nil
end

local function weldAccessory(p6, p7, p8) -- line: 105
    -- upvalues: t2 (copy), t3 (copy), findAttachment (copy)
    local Handle = p7:FindFirstChild("Handle")

    if not Handle then
        return false
    end

    if p8 then
        if t2[p7.AccessoryType] then
            return false
        end

        for _, descendant in ipairs(Handle:GetDescendants()) do
            if descendant:IsA("WrapLayer") then
                descendant:Destroy()
            end
        end
    end

    for _, descendant in ipairs(Handle:GetDescendants()) do
        if descendant:IsA("JointInstance") then
            descendant:Destroy()
        elseif descendant:IsA("WeldConstraint") then
            descendant:Destroy()
        elseif descendant:IsA("Constraint") then
            descendant:Destroy()
        end
    end

    local child, v3, v4

    for _, child2 in ipairs(Handle:GetChildren()) do
        if child2:IsA("Attachment") then
            v3, v4 = findAttachment(p6, child2.Name)

            if v3 then
                child = child2
                break
            end
        end

        child = nil
        v3 = nil
        v4 = nil
    end

    local v5, v6, v7
    local v8 = v3
    local v9 = child
    local v10 = v4

    if not v3 then
        local v11 = t3[p7.AccessoryType]

        if v11 then
            v5, v6 = findAttachment(p6, v11)
            v10 = v6
            v7 = Handle:FindFirstChild(v11) or Handle:FindFirstChildOfClass("Attachment")
            v9 = v7
            v8 = v5
        end
    end

    if not v8 then
        return false
    end

    Handle.Anchored = false
    Handle.CanCollide = false
    Handle.CanQuery = false
    Handle.CanTouch = false
    Handle.Massless = true

    local Weld = Instance.new("Weld")

    Weld.Name = "AccessoryWeld"
    Weld.Part0 = v10
    Weld.Part1 = Handle
    Weld.C0 = v8.CFrame
    Weld.C1 = v9 and v9.CFrame or CFrame.identity
    Weld.Parent = Handle
    p7.Parent = v10.Parent ~= p6 and v10.Parent or p6

    return true
end

local function dressHead(p9, p10, p11, p12) -- line: 163
    -- upvalues: restoreLook (copy)
    local clone = p11:Clone()

    clone.Name = "Head"
    restoreLook(clone)

    for _, child in ipairs(clone:GetChildren()) do
        if not child:IsA("Attachment") and not child:IsA("Decal") and not child:IsA("SurfaceAppearance") and not child:IsA("FaceControls") then
            child:Destroy()
        end
    end

    clone.Anchored = false
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.Massless = true
    clone.CFrame = p10.CFrame

    local Weld = Instance.new("Weld")

    Weld.Name = "DressedHeadWeld"
    Weld.Part0 = p10
    Weld.Part1 = clone
    Weld.C0 = CFrame.new(0, (clone.Size.Y - p10.Size.Y) / 2, 0)
    Weld.Parent = clone

    local Model = Instance.new("Model")

    Model.Name = "DressedHead"

    local Humanoid = Instance.new("Humanoid")

    Humanoid.RigType = Enum.HumanoidRigType.R15
    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    Humanoid.EvaluateStateMachine = false
    Humanoid.RequiresNeck = false
    Humanoid.BreakJointsOnDeath = false
    Humanoid.Parent = Model

    local BodyColors = p12:FindFirstChildOfClass("BodyColors")
    local v12 = BodyColors and BodyColors:Clone() or Instance.new("BodyColors")

    v12.HeadColor3 = p11.Color
    v12.Parent = Model
    clone.Parent = Model
    Model.Parent = p9
    p10.Transparency = 1

    for _, child in ipairs(p10:GetChildren()) do
        if child:IsA("Decal") then
            child:Destroy()
        end
    end

    return true
end

function t1.Dress(p13, p14) -- line: 210
    -- upvalues: restoreLook (copy), weldAccessory (copy), dressHead (copy)
    if not p14 then
        return
    end

    local BodyColors = p13:FindFirstChildOfClass("BodyColors")

    if BodyColors then
        BodyColors:Destroy()
    end

    local BodyColors2 = p14:FindFirstChildOfClass("BodyColors")

    if BodyColors2 then
        BodyColors2:Clone().Parent = p13
    end

    for _, v13 in ipairs({ "Shirt", "Pants", "ShirtGraphic" }) do
        local v14 = p13:FindFirstChildOfClass(v13)

        if v14 then
            v14:Destroy()
        end

        local v15 = p14:FindFirstChildOfClass(v13)

        if v15 then
            v15:Clone().Parent = p13
        end
    end

    local Head = p13:FindFirstChild("Head")
    local v16 = Head ~= nil and not Head:IsA("MeshPart") and Head:FindFirstChildOfClass("SpecialMesh") ~= nil
    local DressedHead = p13:FindFirstChild("DressedHead")

    if DressedHead then
        DressedHead:Destroy()
    end

    local Head2 = p13:FindFirstChild("Head")
    local Head3 = p14:FindFirstChild("Head")

    if Head2 and Head3 then
        local MeshPart = if v16 then Head3:IsA("MeshPart") else nil

        if not v16 or not MeshPart then
            local Decal = Head3:FindFirstChildOfClass("Decal")

            if Decal then
                local Decal2 = Head2:FindFirstChildOfClass("Decal")

                if Decal2 then
                    Decal2:Destroy()
                end

                local clone = Decal:Clone()

                restoreLook(clone)
                clone.Parent = Head2
            end
        else
            dressHead(p13, Head2, Head3, p14)
        end
    end

    for _, child in ipairs(p13:GetChildren()) do
        if child:IsA("Accessory") then
            child:Destroy()
        end
    end

    for _, child in ipairs(p14:GetChildren()) do
        if child:IsA("Accessory") then
            local clone = child:Clone()

            if clone then
                restoreLook(clone)

                if not weldAccessory(p13, clone, v16) then
                    clone:Destroy()
                end
            end
        end
    end
end

function t1.PrepareRig(p15) -- line: 265
    for _, descendant in ipairs(p15:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Anchored = descendant.Name == "HumanoidRootPart"
        elseif descendant:IsA("BaseScript") then
            descendant:Destroy()
        end
    end

    local Humanoid = p15:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        Humanoid.NameDisplayDistance = 0
        Humanoid.HealthDisplayDistance = 0
        Humanoid.EvaluateStateMachine = false
    end

    if p15:FindFirstChild("HumanoidRootPart") then
        p15.PrimaryPart = p15.HumanoidRootPart
    end
end

function t1.SetCharacterVisible(p16, p17, p18) -- line: 290
    if not p16 then
        return
    end

    for _, descendant in ipairs(p16:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" or descendant:IsA("Decal") then
            if p18 and descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p17 and 0 or 1
            elseif p17 then
                local OrigTransparency = descendant:GetAttribute("OrigTransparency")

                if OrigTransparency ~= nil then
                    descendant.Transparency = OrigTransparency
                    descendant:SetAttribute("OrigTransparency", nil)
                end
            else
                if descendant:GetAttribute("OrigTransparency") == nil then
                    descendant:SetAttribute("OrigTransparency", descendant.Transparency)
                end

                descendant.Transparency = 1
            end
        elseif descendant:IsA("BillboardGui") then
            descendant.Enabled = p17
        end
    end
end

return t1

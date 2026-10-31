-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local useRootSelector = RuntimeLib.import(script, script.Parent, "reflex").useRootSelector
local selectLocalCharacterAppearance = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "selectors", "local-character-appearance.selectors").selectLocalCharacterAppearance
local v1 = RuntimeLib.import(script, script.Parent, "utils", "pickaxe-rig-utils")
local anchorToolPartsInRig, unanchorToolPartsInRig, weldToolsToRigRightHand = v1.anchorToolPartsInRig, v1.unanchorToolPartsInRig, v1.weldToolsToRigRightHand
local t1 = {
    BodyColors = true,
    Shirt = true,
    Pants = true,
    ShirtGraphic = true
}
local _ = {
    "BackAccessory",
    "FrontAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "WaistAccessory"
}
local t2 = {
    FaceCenterAttachment = true,
    FaceFrontAttachment = true,
    HairAttachment = true,
    HatAttachment = true
}

local function isHeadAccessory(p1, p2) -- line: 23
    -- upvalues: t2 (copy)
    if p1.AccessoryType == Enum.AccessoryType.Hat or p1.AccessoryType == Enum.AccessoryType.Hair or p1.AccessoryType == Enum.AccessoryType.Face then
        return true
    end

    local Handle = p1:FindFirstChild("Handle")

    if Handle ~= nil then
        if p2 ~= nil then
            local Head = p2:FindFirstChild("Head")

            if Head ~= nil and Head:IsA("BasePart") then
                for _, child in Handle:GetChildren() do
                    if (child:IsA("Weld") or child:IsA("WeldConstraint")) and (child.Part0 == Head or child.Part1 == Head) then
                        return true
                    end
                end
            end
        end

        for _, descendant in Handle:GetDescendants() do
            local Attachment = descendant:IsA("Attachment")

            Attachment = Attachment and t2[descendant.Name] ~= nil

            if Attachment then
                return true
            end
        end
    end

    return false
end

local function removeAccessories(p3, p4) -- line: 53
    -- upvalues: isHeadAccessory (copy)
    local v2 = p4 == nil or p4

    for _, child in p3:GetChildren() do
        if child:IsA("Accessory") and (not v2 or not isHeadAccessory(child)) then
            child:Destroy()
        end
    end
end

local function copyCharacterBodyParts(p5, p6) -- line: 63
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v3 = p6:FindFirstChild(descendant.Name, true)

            if v3 ~= nil and v3:IsA("BasePart") and v3.Name ~= "HumanoidRootPart" then
                v3.Color = descendant.Color
                v3.Material = descendant.Material
                v3.Reflectance = descendant.Reflectance
                v3.Transparency = descendant.Transparency
            end
        end
    end
end

local function copyCharacterChildren(p7, p8) -- line: 81
    -- upvalues: t1 (copy)
    for _, child in p8:GetChildren() do
        if t1[child.ClassName] ~= nil then
            child:Destroy()
        end
    end

    for _, child in p7:GetChildren() do
        if t1[child.ClassName] ~= nil then
            child:Clone().Parent = p8
        end
    end
end

local function copyHeadDecals(p9, p10) -- line: 96
    local Head = p9:FindFirstChild("Head")
    local v4 = p10:FindFirstChild("Head", true)

    if Head == nil or v4 == nil or not Head:IsA("BasePart") or not v4:IsA("BasePart") then
        return nil
    end

    for _, child in v4:GetChildren() do
        if child:IsA("Decal") then
            child:Destroy()
        elseif child:IsA("Texture") then
            child:Destroy()
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        end
    end

    for _, child in Head:GetChildren() do
        if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
            child:Clone().Parent = v4
        end
    end

    if Head:IsA("MeshPart") then
        if v4:IsA("MeshPart") then
            v4.TextureID = Head.TextureID
        else
            local SpecialMesh = v4:FindFirstChildWhichIsA("SpecialMesh")

            if SpecialMesh ~= nil then
                SpecialMesh.MeshType = Enum.MeshType.FileMesh
                SpecialMesh.MeshId = Head.MeshId
                SpecialMesh.TextureId = Head.TextureID
            end
        end
    end
end

local attachAccessoryToRig, attachAccessoryToRigHead, hasAccessoryJointToRig

local function copyAccessories(p11, p12, p13) -- line: 133
    -- upvalues: attachAccessoryToRig (ref), attachAccessoryToRigHead (ref), hasAccessoryJointToRig (ref)
    for _, child in p11:GetChildren() do
        if child:IsA("Accessory") and p12:FindFirstChild(child.Name) == nil then
            local clone = child:Clone()

            local function v5() -- line: 142
                -- upvalues: p13 (copy), clone (copy)
                return p13:AddAccessory(clone)
            end

            local ok, result = pcall(v5)

            if ok then
                if clone.Parent == nil or not hasAccessoryJointToRig(clone, p12) then
                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("Weld") then
                            descendant:Destroy()
                        elseif descendant:IsA("WeldConstraint") then
                            descendant:Destroy()
                        elseif descendant:IsA("Motor6D") then
                            descendant:Destroy()
                        end
                    end

                    local attachAccessoryToRig2 = attachAccessoryToRig

                    if not attachAccessoryToRig2(clone, p12) then
                        local attachAccessoryToRigHead2 = attachAccessoryToRigHead

                        if not attachAccessoryToRigHead2(clone, child, p11, p12) then
                            clone:Destroy()
                        end
                    end
                end
            elseif not attachAccessoryToRig(clone, p12) and not attachAccessoryToRigHead(clone, child, p11, p12) then
                clone:Destroy()
                warn("[src/client/react/hooks/use-apply-local-character-appearance-to-rig.ts:167]", "Rig AddAccessory failed:", result)
            end
        end
    end
end

function hasAccessoryJointToRig(p14, p15) -- line: 173
    local Handle = p14:FindFirstChild("Handle")

    if Handle ~= nil and Handle:IsA("BasePart") then
        for _, descendant in Handle:GetDescendants() do
            if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
                local v6 = if descendant.Part0 == Handle then descendant.Part1 else descendant.Part0

                if v6 ~= nil and v6:IsDescendantOf(p15) then
                    return true
                end
            end
        end
    end

    return false
end

local function copyLiveCharacterAppearanceToRig(p16, p17) -- line: 195
    -- upvalues: removeAccessories (copy), copyCharacterBodyParts (copy), copyCharacterChildren (copy), copyHeadDecals (copy), copyAccessories (copy)
    local Humanoid = p17:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        return nil
    end

    removeAccessories(p17, false)
    copyCharacterBodyParts(p16, p17)
    copyCharacterChildren(p16, p17)
    copyHeadDecals(p16, p17)
    copyAccessories(p16, p17, Humanoid)
end

function attachAccessoryToRig(p18, p19) -- line: 206
    local Handle = p18:FindFirstChild("Handle")

    if Handle ~= nil and Handle:IsA("BasePart") then
        for _, child in Handle:GetChildren() do
            if child:IsA("Attachment") then
                local v7 = p19:FindFirstChild(child.Name, true)

                if v7 ~= nil and v7:IsA("Attachment") then
                    local Parent = v7.Parent

                    if Parent ~= nil and Parent:IsA("BasePart") then
                        Handle.Anchored = false
                        Handle.CanCollide = false
                        Handle.CanTouch = false
                        Handle.CanQuery = false
                        p18.Parent = p19

                        local Weld = Instance.new("Weld")

                        Weld.Name = "AccessoryWeld"
                        Weld.Part0 = Parent
                        Weld.Part1 = Handle
                        Weld.C0 = v7.CFrame
                        Weld.C1 = child.CFrame
                        Weld.Parent = Handle

                        return true
                    end
                end
            end
        end
    end

    return false
end

function attachAccessoryToRigHead(p20, p21, p22, p23) -- line: 239
    local Handle = p20:FindFirstChild("Handle")
    local Handle2 = p21:FindFirstChild("Handle")
    local Head = p22:FindFirstChild("Head")
    local v8 = p23:FindFirstChild("Head", true)

    if Handle == nil
        or Handle2 == nil
        or Head == nil
        or v8 == nil
        or not Handle:IsA("BasePart")
        or not Handle2:IsA("BasePart")
        or not Head:IsA("BasePart")
        or not v8:IsA("BasePart") then
        return false
    end

    local v9 = Head.CFrame:ToObjectSpace(Handle2.CFrame)

    Handle.CFrame = v8.CFrame * v9
    Handle.Anchored = false
    Handle.CanCollide = false
    Handle.CanTouch = false
    Handle.CanQuery = false
    p20.Parent = p23

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Name = "AccessoryHeadWeld"
    WeldConstraint.Part0 = v8
    WeldConstraint.Part1 = Handle
    WeldConstraint.Parent = Handle

    return true
end

local function applyLocalCharacterAppearanceToRig(p24, p25, p26) -- line: 267
    -- upvalues: anchorToolPartsInRig (copy), unanchorToolPartsInRig (copy), weldToolsToRigRightHand (copy)
    local Humanoid = p24:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        if p26 ~= nil then
            local onComplete = p26.onComplete

            if onComplete ~= nil then
                onComplete()
            end
        end

        return nil
    end

    local v10 = if p26 == nil then p26 else p26.applyDescriptionAsync

    if v10 == nil then
        v10 = true
    end

    if not v10 or p25 == nil then
        if p26 ~= nil then
            local onComplete = p26.onComplete

            if onComplete ~= nil then
                onComplete()
            end
        end

        return nil
    end

    task.spawn(function() -- line: 298
        -- upvalues: p24 (copy), p25 (copy), p26 (copy), Humanoid (copy), anchorToolPartsInRig (copy), unanchorToolPartsInRig (copy), weldToolsToRigRightHand (copy)
        local function v11() -- line: 299
            -- upvalues: p24 (copy), p25 (copy), Humanoid (copy), anchorToolPartsInRig (copy), unanchorToolPartsInRig (copy), weldToolsToRigRightHand (copy)
            if p24.Parent == nil or Humanoid.Parent == nil then
                return nil
            end

            anchorToolPartsInRig(p24)
            Humanoid:ApplyDescriptionAsync(p25)

            if p24.Parent ~= nil and Humanoid.Parent ~= nil then
                weldToolsToRigRightHand(p24)
                unanchorToolPartsInRig(p24)

                for _, descendant in p24:GetDescendants() do
                    if descendant:IsA("Script") then
                        descendant.Enabled = true
                    end
                end
            end

            return nil
        end

        local ok, result = pcall(v11)

        if not ok then
            warn("[src/client/react/hooks/use-apply-local-character-appearance-to-rig.ts:341]", "Rig ApplyDescriptionAsync failed:", result)
        end

        if p26 ~= nil then
            local onComplete = p26.onComplete

            if onComplete ~= nil then
                onComplete()
            end
        end
    end)
end

return {
    copyLiveCharacterAppearanceToRig = copyLiveCharacterAppearanceToRig,
    applyLocalCharacterAppearanceToRig = applyLocalCharacterAppearanceToRig,
    useApplyLocalCharacterAppearanceToRig = function(p27, p28) -- useApplyLocalCharacterAppearanceToRig | line: 336
        -- upvalues: useEffect (copy), useRootSelector (copy), selectLocalCharacterAppearance (copy), applyLocalCharacterAppearanceToRig (copy)
        local v12 = useRootSelector(selectLocalCharacterAppearance)
        local v13 = if p28 == nil then p28 else p28.applyDescriptionAsync

        if v13 == nil then
            v13 = true
        end

        useEffect(function() -- line: 347
            -- upvalues: p27 (copy), v12 (copy), v13 (ref), applyLocalCharacterAppearanceToRig (copy)
            if not p27 then
                return nil
            end

            applyLocalCharacterAppearanceToRig(p27, v12, {
                applyDescriptionAsync = v13
            })
        end, { p27, v12, v13 })
    end
}

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PartBounds = require(ReplicatedStorage.Shared.Utils.PartBounds)
local Checksum = require(ReplicatedStorage.Shared.Utils.Checksum)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Darker = Color3.fromRGB(216, 158, 0),
    Lighter = Color3.fromRGB(251, 255, 0)
}
local t2 = {
    Darker = Color3.fromRGB(134, 134, 134),
    Lighter = Color3.fromRGB(192, 192, 192)
}
local t3 = {
    Darker = Color3.fromRGB(25, 0, 38),
    Lighter = Color3.fromRGB(47, 0, 70)
}
local v2 = Random.new()
local v3
local t4 = {}

local function getFxContainer(p1) -- line: 105
    -- upvalues: ReplicatedStorage (copy)
    local Mutations = ReplicatedStorage:FindFirstChild("Mutations")

    assert(Mutations, "Mutations folder is missing from ReplicatedStorage")

    local v4 = Mutations:FindFirstChild(p1)

    assert(v4, (("Mutation FX container \"%*\" not found in Mutations"):format(p1)))

    return v4
end

local function shouldSkipColoring(p2) -- line: 113
    if p2:GetAttribute("MutationsDontModify") == true or p2:GetAttribute("DontAddTexture") == true or p2:GetAttribute("IsEye") == true then
        return true
    end

    return p2:GetAttribute("MutationFXDontRender") == true
end

local function ensureUnionUsePartColor(p3) -- line: 120
    if p3:IsA("UnionOperation") then
        if p3:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
            p3:SetAttribute("Cleanup_OriginalUserPartColor", p3.UsePartColor)
        end

        p3.UsePartColor = true
    end
end

local function restoreUnionUsePartColor(p4) -- line: 132
    if p4:IsA("UnionOperation") then
        local Cleanup_OriginalUserPartColor = p4:GetAttribute("Cleanup_OriginalUserPartColor")

        if typeof(Cleanup_OriginalUserPartColor) == "boolean" then
            p4.UsePartColor = Cleanup_OriginalUserPartColor
            p4:SetAttribute("Cleanup_OriginalUserPartColor", nil)
        end
    end
end

local function rollColor(p5, p6) -- line: 146
    return p6.Darker:Lerp(p6.Lighter, p5:NextNumber())
end

local function applyPaletteColor(p7, p8) -- line: 150
    -- upvalues: v2 (copy), v3 (ref)
    if p7:IsA("UnionOperation") then
        if p7:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
            p7:SetAttribute("Cleanup_OriginalUserPartColor", p7.UsePartColor)
        end

        p7.UsePartColor = true
    end

    local v6 = v3 or v2

    p7.Color = p8.Darker:Lerp(p8.Lighter, v6:NextNumber())
end

local function getMaterialByName(p9) -- line: 155
    for _, v7 in Enum.Material:GetEnumItems() do
        if v7.Name == p9 then
            return v7
        end
    end

    return nil
end

local function getStoredOriginalMaterial(p10) -- line: 166
    for _, v8 in { "Mutation_OriginalMaterial", "OriginalMaterial", "Original_Material" } do
        local Attribute = p10:GetAttribute(v8)

        if typeof(Attribute) == "string" then
            local v9 = false
            local v10

            for _, v11 in Enum.Material:GetEnumItems() do
                if v11.Name == Attribute then
                    v10 = v11
                    v9 = true
                    break
                end
            end

            if not v9 then
                v10 = nil
            end

            if v10 then
                return v10
            end
        elseif typeof(Attribute) == "EnumItem" and Attribute.EnumType == Enum.Material then
            return Attribute
        end
    end

    return nil
end

local function getStoredOriginalMaterialVariant(p11) -- line: 182
    local Mutation_OriginalMaterialVariant = p11:GetAttribute("Mutation_OriginalMaterialVariant")

    return if typeof(Mutation_OriginalMaterialVariant) == "string" then Mutation_OriginalMaterialVariant else nil
end

local function setAndSaveMaterial(p12, p13) -- line: 191
    if not p12:GetAttribute("Mutation_OriginalMaterial") then
        p12:SetAttribute("Mutation_OriginalMaterial", p12.Material.Name)
    end

    p12.Material = p13
end

local function setAndSaveMaterialVariant(p14, p15) -- line: 199
    if not p14:GetAttribute("Mutation_OriginalMaterialVariant") then
        p14:SetAttribute("Mutation_OriginalMaterialVariant", p14.MaterialVariant)
    end

    p14.MaterialVariant = p15
end

local function hasMetalVisual(p16) -- line: 207
    return p16:HasTag("GoldenVisual") or p16:HasTag("SilverVisual")
end

local function setMetalMaterialVariant(p17) -- line: 211
    if not p17:GetAttribute("Mutation_OriginalMaterialVariant") then
        p17:SetAttribute("Mutation_OriginalMaterialVariant", p17.MaterialVariant)
    end

    p17.MaterialVariant = "StudsMetallic"
end

local function getPartVolume(p18) -- line: 215
    local Size = p18.Size

    return Size.X * Size.Y * Size.Z
end

local function collectMetalSizeGroups(p19) -- line: 220
    local t5 = {}

    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 and not descendant:HasTag("Effect") and descendant:GetAttribute("MutationsDontModify") ~= true and descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true and descendant:GetAttribute("MutationFXDontRender") ~= true then
            table.insert(t5, descendant)
        end
    end

    table.sort(t5, function(p20, p21) -- line: 235
        local Size = p20.Size
        local v12 = Size.X * Size.Y * Size.Z
        local Size2 = p21.Size

        return Size2.X * Size2.Y * Size2.Z < v12
    end)

    local t6 = {}
    local n1 = 0

    for _, v13 in t5 do
        local Size = v13.Size
        local v14 = Size.X * Size.Y * Size.Z
        local v15 = t6[#t6]

        if v15 then
            if math.abs(v15.PartVolume - v14) <= 0.001 then
                table.insert(v15.Parts, v13)
                v15.Weight += v14
            else
                table.insert(t6, {
                    Parts = {
                        v13
                    },
                    PartVolume = v14,
                    Weight = v14
                })
            end
        else
            table.insert(t6, {
                Parts = {
                    v13
                },
                PartVolume = v14,
                Weight = v14
            })
        end

        n1 += v14
    end

    table.sort(t6, function(p22, p23) -- line: 260
        return p22.Weight > p23.Weight
    end)

    return t6, n1
end

local function getSilverComboParts(p24, p25) -- line: 267
    -- upvalues: t4 (copy), collectMetalSizeGroups (copy)
    local v17, v18 = collectMetalSizeGroups(p24)
    local v19 = Random.new(t4.SeedFor(p25, "GoldenSilverPartition"))
    local t9 = {}
    local v20 = v18 / 2
    local v21 = v18 / 2

    for _, v22 in v17 do
        if if math.abs(v20 - v21) <= 0.001 then v19:NextNumber() < 0.5 else v21 < v20 then
            for _, v24 in v22.Parts do
                t9[v24] = true
            end

            v20 -= v22.Weight
        else
            v21 -= v22.Weight
        end
    end

    return t9
end

local function getNamedSurfaceAppearance(p26, p27) -- line: 295
    local descendant

    for _, descendant2 in p26:GetDescendants() do
        if descendant2:IsA("SurfaceAppearance") and descendant2.Name == p27 then
            local v25 = descendant == nil

            descendant = descendant2
            assert(v25, (("%* contains multiple %* SurfaceAppearances"):format(p26:GetFullName(), p27)))
        end
    end

    assert(descendant ~= nil, (("%* must contain a %* SurfaceAppearance"):format(p26:GetFullName(), p27)))

    return descendant
end

local function getTextureOverrideVisualModel(p28) -- line: 307
    if p28.Name == "Model" then
        return p28
    end

    local Model = p28:FindFirstChild("Model")

    assert(Model ~= nil and Model:IsA("Model"), (("%* enables TexturesOverride but has no direct Model child"):format((p28:GetFullName()))))

    return Model
end

local function getOriginalSurfaceAppearance(p29, p30, p31, p32, p33) -- line: 320
    local v31

    for _, descendant in p29:GetDescendants() do
        if descendant:IsA("SurfaceAppearance") and descendant:GetAttribute("Mutation_OriginalSurfaceAppearance") == true then
            local v32 = v31 == nil

            v31 = descendant
            assert(v32, (("%* contains multiple original SurfaceAppearances"):format((p29:GetFullName()))))
        end
    end

    if v31 == nil then
        for _, child in p30:GetChildren() do
            if child:IsA("SurfaceAppearance") and child ~= p31 and child ~= p32 and child ~= p33 then
                local v35 = v31 == nil

                v31 = child
                assert(v35, (("%* contains multiple original SurfaceAppearances"):format((p30:GetFullName()))))
            end
        end
    end

    assert(v31 ~= nil, (("%* must contain its original SurfaceAppearance"):format((p30:GetFullName()))))
    v31:SetAttribute("Mutation_OriginalSurfaceAppearance", true)

    return v31
end

local function getTextureOverrideBindings(p34) -- line: 364
    -- upvalues: getNamedSurfaceAppearance (copy), getOriginalSurfaceAppearance (copy)
    local t10 = {}

    if p34:IsA("Model") and p34:GetAttribute("TexturesOverride") == true then
        table.insert(t10, p34)
    end

    for _, descendant in p34:GetDescendants() do
        if descendant:IsA("Model") and descendant:GetAttribute("TexturesOverride") == true then
            table.insert(t10, descendant)
        end
    end

    if #t10 == 0 then
        return nil
    end

    local t11 = {}
    local t12 = {}

    for _, v39 in t10 do
        local Model

        if v39.Name == "Model" then
            Model = v39
        else
            Model = v39:FindFirstChild("Model")
            assert(Model ~= nil and Model:IsA("Model"), (("%* enables TexturesOverride but has no direct Model child"):format((v39:GetFullName()))))
        end

        if not t12[Model] then
            t12[Model] = true

            local v42 = Model:FindFirstChildWhichIsA("MeshPart", true)

            assert(v42 ~= nil, (("%* must contain a MeshPart for texture overrides"):format((Model:GetFullName()))))

            local GoldTextureOverride = getNamedSurfaceAppearance(Model, "GoldTextureOverride")
            local SilverTextureOverride = getNamedSurfaceAppearance(Model, "SilverTextureOverride")
            local GoldSilverTextureOverride = getNamedSurfaceAppearance(Model, "GoldSilverTextureOverride")

            table.insert(t11, {
                VisualModel = Model,
                TargetMesh = v42,
                Original = getOriginalSurfaceAppearance(Model, v42, GoldTextureOverride, SilverTextureOverride, GoldSilverTextureOverride),
                Golden = GoldTextureOverride,
                Silver = SilverTextureOverride,
                GoldenSilver = GoldSilverTextureOverride
            })
        end
    end

    assert(#t11 > 0, (("%* enables TexturesOverride but has no texture override bindings"):format((p34:GetFullName()))))

    return t11
end

local function getActiveSurfaceAppearance(p35) -- line: 414
    local child

    for _, child2 in p35.TargetMesh:GetChildren() do
        if child2:IsA("SurfaceAppearance") then
            local v47 = child == nil

            child = child2
            assert(v47, (("%* contains multiple active SurfaceAppearances"):format((p35.TargetMesh:GetFullName()))))
        end
    end

    assert(child ~= nil, (("%* must contain one active SurfaceAppearance"):format((p35.TargetMesh:GetFullName()))))

    return child
end

local function setActiveSurfaceAppearance(p36, p37) -- line: 432
    -- upvalues: getActiveSurfaceAppearance (copy)
    local v51 = getActiveSurfaceAppearance(p36)

    if v51 == p37 then
        return
    end

    local Cleanup_Rainbow = v51:HasTag("Cleanup_Rainbow")

    if Cleanup_Rainbow then
        v51:RemoveTag("RainbowPart")
        v51:RemoveTag("Cleanup_Rainbow")
    end

    v51.Parent = p36.VisualModel
    p37.Parent = p36.TargetMesh

    if Cleanup_Rainbow then
        p37:AddTag("RainbowPart")
        p37:AddTag("Cleanup_Rainbow")
    end
end

local function applyMetalTextureOverride(p38, p39, p40, p41) -- line: 456
    -- upvalues: setActiveSurfaceAppearance (copy)
    for _, v52 in p38 do
        local v53 = p39(v52)

        if p40 ~= nil then
            v53:AddTag(p40)
        end

        if p41 ~= nil then
            if v53:GetAttribute("Metal_OriginalSurfaceColor") == nil then
                v53:SetAttribute("Metal_OriginalSurfaceColor", v53.Color)
            end

            v53.Color = p41
        end

        setActiveSurfaceAppearance(v52, v53)
    end
end

local function removeMetalTextureOverride(p42, p43, p44, p45, p46) -- line: 477
    -- upvalues: setActiveSurfaceAppearance (copy)
    for _, v54 in p42 do
        local v55 = p43(v54)

        if v55:HasTag(p45) then
            v55:RemoveTag(p45)

            local Metal_OriginalSurfaceColor = v55:GetAttribute("Metal_OriginalSurfaceColor")

            if typeof(Metal_OriginalSurfaceColor) == "Color3" then
                v55.Color = Metal_OriginalSurfaceColor
                v55:SetAttribute("Metal_OriginalSurfaceColor", nil)
            end

            local v56 = p44(v54)

            if v56:HasTag(p46) then
                setActiveSurfaceAppearance(v54, v56)
            else
                setActiveSurfaceAppearance(v54, v54.Original)
            end
        end
    end
end

local function hasVisualTag(p47, p48) -- line: 505
    for _, descendant in p47:GetDescendants() do
        if descendant:HasTag(p48) then
            return true
        end
    end

    return false
end

local function getStoredOriginalColor(p49) -- line: 514
    local OriginalColor = p49:GetAttribute("OriginalColor")

    return if typeof(OriginalColor) == "Color3" then OriginalColor else nil
end

local function cloneFxInto(p50, p51, p52, p53, p54) -- line: 523
    -- upvalues: ReplicatedStorage (copy), t (copy)
    t.strict(t.instanceIsA("BasePart"))(p50)
    t.strict(t.string)(p51)
    t.strict(t.string)(p52)

    local Mutations = ReplicatedStorage:FindFirstChild("Mutations")

    assert(Mutations, "Mutations folder is missing from ReplicatedStorage")

    local v57 = Mutations:FindFirstChild(p51)

    assert(v57, (("Mutation FX container \"%*\" not found in Mutations"):format(p51)))

    for _, child in v57:GetChildren() do
        local clone = child:Clone()

        if p54 ~= nil and clone:IsA("ParticleEmitter") then
            local t14 = {}

            for _, v59 in clone.Size.Keypoints do
                table.insert(t14, NumberSequenceKeypoint.new(v59.Time, v59.Value * p54, v59.Envelope * p54))
            end

            clone.Size = NumberSequence.new(t14)
            clone.Speed = NumberRange.new(clone.Speed.Min * p54, clone.Speed.Max * p54)
            clone.Acceleration *= p54
        end

        clone.Parent = p50

        if p53 then
            clone.Enabled = true
        end

        clone:AddTag(p52)
        clone:AddTag("Effect")
    end
end

local function destroyTagged(p55, p56, p57) -- line: 559
    local v62 = if p57 then p55:GetDescendants() else p55:GetChildren()

    for _, v63 in v62 do
        if v63:HasTag(p56) then
            v63:Destroy()
        end
    end
end

local t15 = {
    FxFolder = "Golden",
    CleanupTag = "Cleanup_GoldenFX",
    VisualTag = "GoldenVisual",
    PartnerVisualTag = "SilverVisual",
    AppearanceColor = nil,
    Palette = t1,
    SelectAppearance = function(p58) -- SelectAppearance | line: 575
        return p58.Golden
    end,
    SelectPartnerAppearance = function(p59) -- SelectPartnerAppearance | line: 578
        return p59.Silver
    end
}
local t16 = {
    FxFolder = "Silver",
    CleanupTag = "Cleanup_SilverFX",
    VisualTag = "SilverVisual",
    PartnerVisualTag = "GoldenVisual",
    AppearanceColor = nil,
    Palette = t2,
    SelectAppearance = function(p60) -- SelectAppearance | line: 590
        return p60.Silver
    end,
    SelectPartnerAppearance = function(p61) -- SelectPartnerAppearance | line: 593
        return p61.Golden
    end
}
local t17 = {
    FxFolder = "Golden",
    CleanupTag = "Cleanup_BlackFX",
    VisualTag = "BlackVisual",
    PartnerVisualTag = "GoldenVisual",
    Palette = t3,
    AppearanceColor = t3.Lighter,
    SelectAppearance = function(p62) -- SelectAppearance | line: 605
        return p62.Golden
    end,
    SelectPartnerAppearance = function(p63) -- SelectPartnerAppearance | line: 608
        return p63.Golden
    end
}

local function clearMetal(p64, p65, p66) -- line: 613
    -- upvalues: getStoredOriginalMaterial (copy), getTextureOverrideBindings (copy), removeMetalTextureOverride (copy), destroyTagged (copy)
    if p65 then
        destroyTagged(p65, p66.CleanupTag)
    end

    local v64 = getTextureOverrideBindings(p64)

    if v64 ~= nil then
        removeMetalTextureOverride(v64, p66.SelectAppearance, p66.SelectPartnerAppearance, p66.VisualTag, p66.PartnerVisualTag)

        return
    end

    for _, descendant in p64:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:HasTag(p66.VisualTag) then
            descendant:RemoveTag(p66.VisualTag)

            local Mutation_OriginalColor = descendant:GetAttribute("Mutation_OriginalColor")

            if typeof(Mutation_OriginalColor) == "Color3" then
                descendant.Color = Mutation_OriginalColor
            end

            local v65 = getStoredOriginalMaterial(descendant)

            if v65 then
                descendant.Material = v65
            end

            local Mutation_OriginalMaterialVariant = descendant:GetAttribute("Mutation_OriginalMaterialVariant")

            if typeof(Mutation_OriginalMaterialVariant) ~= "string" then
                Mutation_OriginalMaterialVariant = nil
            end

            if Mutation_OriginalMaterialVariant then
                descendant.MaterialVariant = Mutation_OriginalMaterialVariant
            end

            if descendant:IsA("UnionOperation") then
                local Cleanup_OriginalUserPartColor = descendant:GetAttribute("Cleanup_OriginalUserPartColor")

                if typeof(Cleanup_OriginalUserPartColor) == "boolean" then
                    descendant.UsePartColor = Cleanup_OriginalUserPartColor
                    descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil)
                end
            end
        end
    end
end

local function applyMetal(p67, p68, p69, p70, p71) -- line: 656
    -- upvalues: ReplicatedStorage (copy), v2 (copy), v3 (ref), getTextureOverrideBindings (copy), applyMetalTextureOverride (copy), cloneFxInto (copy), clearMetal (copy)
    clearMetal(p67, p68, p69)

    if p68 then
        cloneFxInto(p68, p69.FxFolder, p69.CleanupTag)
    end

    local v66 = getTextureOverrideBindings(p67)

    if v66 ~= nil then
        applyMetalTextureOverride(v66, p69.SelectAppearance, p69.VisualTag, p69.AppearanceColor)

        return
    end

    for _, descendant in p67:GetDescendants() do
        if not descendant:IsA("BasePart")
            or descendant:HasTag("Effect")
            or descendant:GetAttribute("MutationsDontModify") == true
            or descendant:GetAttribute("DontAddTexture") == true
            or descendant:GetAttribute("IsEye") == true
            or descendant:GetAttribute("MutationFXDontRender") == true then
            if descendant:IsA("SurfaceAppearance") then
                local Parent = descendant.Parent

                if Parent and not (Parent:GetAttribute("MutationsDontModify") == true or Parent:GetAttribute("DontAddTexture") == true or Parent:GetAttribute("IsEye") == true or Parent:GetAttribute("MutationFXDontRender") == true) then
                    descendant:Destroy()
                end
            end
        else
            local Palette = p69.Palette

            if descendant:IsA("UnionOperation") then
                if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                    descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor)
                end

                descendant.UsePartColor = true
            end

            local v67 = v3 or v2

            descendant.Color = Palette.Darker:Lerp(Palette.Lighter, v67:NextNumber())

            local Plastic = Enum.Material.Plastic

            if not descendant:GetAttribute("Mutation_OriginalMaterial") then
                descendant:SetAttribute("Mutation_OriginalMaterial", descendant.Material.Name)
            end

            descendant.Material = Plastic

            if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant)
            end

            descendant.MaterialVariant = "StudsMetallic"
            descendant:AddTag(p69.VisualTag)

            if descendant:IsA("MeshPart") then
                descendant.TextureID = ""
            end
        end
    end

    if p68 and p70 and p71 then
        local Mutations = ReplicatedStorage:FindFirstChild("Mutations")

        if Mutations and Mutations:FindFirstChild(p70) then
            cloneFxInto(p68, p70, p71, true)
        end
    end
end

local function tintModel(p72, p73, p74) -- line: 703
    for _, descendant in p72:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:HasTag("NoTint") then
            local OriginalColor = descendant:GetAttribute("OriginalColor")

            if typeof(OriginalColor) ~= "Color3" then
                OriginalColor = nil
            end

            if not OriginalColor then
                descendant:SetAttribute("OriginalColor", descendant.Color)
                OriginalColor = descendant.Color
            end

            descendant.Color = OriginalColor:Lerp(p73, p74)

            local SurfaceAppearance = descendant:FindFirstChildOfClass("SurfaceAppearance")

            if SurfaceAppearance then
                if SurfaceAppearance:GetAttribute("Tint_OriginalSurfaceColor") == nil then
                    SurfaceAppearance:SetAttribute("Tint_OriginalSurfaceColor", SurfaceAppearance.Color)
                end

                SurfaceAppearance.Color = p73
            elseif descendant:IsA("MeshPart") and descendant.TextureID ~= "" then
                descendant:SetAttribute("Tint_OriginalTextureId", descendant.TextureID)
                descendant.TextureID = ""
            end
        end
    end
end

local function clearTint(p75) -- line: 729
    for _, descendant in p75:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:HasTag("NoTint") then
            local OriginalColor = descendant:GetAttribute("OriginalColor")

            if typeof(OriginalColor) ~= "Color3" then
                OriginalColor = nil
            end

            if OriginalColor then
                descendant:SetAttribute("OriginalColor", nil)
                descendant.Color = OriginalColor
            end

            local SurfaceAppearance = descendant:FindFirstChildOfClass("SurfaceAppearance")

            if SurfaceAppearance then
                local Tint_OriginalSurfaceColor = SurfaceAppearance:GetAttribute("Tint_OriginalSurfaceColor")

                if typeof(Tint_OriginalSurfaceColor) == "Color3" then
                    SurfaceAppearance.Color = Tint_OriginalSurfaceColor
                    SurfaceAppearance:SetAttribute("Tint_OriginalSurfaceColor", nil)
                end
            end

            local Tint_OriginalTextureId = descendant:GetAttribute("Tint_OriginalTextureId")

            if descendant:IsA("MeshPart") and typeof(Tint_OriginalTextureId) == "string" then
                descendant.TextureID = Tint_OriginalTextureId
                descendant:SetAttribute("Tint_OriginalTextureId", nil)
            end
        end
    end
end

function t4.SeedFor(p76, p77) -- line: 763
    -- upvalues: Checksum (copy)
    return (math.max(Checksum.PathSeed("MutationVisual", p76, p77) % 2147483647, 1))
end

function t4.WithVisualRandom(p78, p79) -- line: 767
    -- upvalues: v3 (ref)
    local v69 = v3

    if p78 ~= nil then
        v3 = p78
    end

    local ok, result = pcall(p79)

    v3 = v69

    if not ok then
        error(result, 0)
    end
end

function t4.GetFXPart(p80) -- line: 780
    -- upvalues: PartBounds (copy), Constants (copy), v1 (copy)
    if not p80 then
        warn("Mutations.Visuals.GetFXPart | No item given")

        return nil
    end

    local FXPart = p80:FindFirstChild("FXPart")

    if FXPart and FXPart:IsA("BasePart") then
        return FXPart
    end

    local v70 = if p80:IsA("Tool") then p80:FindFirstChild("Handle") or p80:FindFirstChild("Segment1") elseif p80:IsA("Model") then p80.PrimaryPart else nil

    if v70 then
        local t18 = {}

        for _, descendant in ipairs(p80:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 and descendant:GetAttribute("MutationFXDontRender") ~= true then
                table.insert(t18, descendant)
            end
        end

        local v71, v72

        if #t18 > 0 then
            v71, v72 = PartBounds(t18)
        else
            v71, v72 = p80:GetBoundingBox()
        end

        local Part = Instance.new("Part")

        Part.Name = "FXPart"
        Part.CFrame = v71
        Part.Size = v72
        Part.Transparency = 1
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.Anchored = false
        Part.Massless = true
        Part.Parent = p80

        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Part0 = Part
        WeldConstraint.Part1 = v70
        WeldConstraint.Parent = Part

        return Part
    end

    local v73 = ("Mutations.Visuals.GetFXPart | No primary part found for item '%*'"):format(p80.Name)

    if Constants.IS_STUDIO then
        error(v73)
    else
        v1:AtError():Log(v73)
    end

    return nil
end

function t4.ApplyGolden(p81, p82) -- line: 846
    -- upvalues: t15 (copy), applyMetal (copy)
    applyMetal(p81, p82, t15)
end

function t4.ClearGolden(p83, p84) -- line: 850
    -- upvalues: t15 (copy), clearMetal (copy)
    clearMetal(p83, p84, t15)
end

function t4.ApplyBlack(p85, p86, p87, p88) -- line: 854
    -- upvalues: t17 (copy), applyMetal (copy)
    applyMetal(p85, p86, t17, p87, p88)
end

function t4.ClearBlack(p89, p90) -- line: 858
    -- upvalues: t17 (copy), clearMetal (copy)
    clearMetal(p89, p90, t17)
end

function t4.ApplySilver(p91, p92) -- line: 862
    -- upvalues: t16 (copy), applyMetal (copy)
    applyMetal(p91, p92, t16)
end

function t4.ClearSilver(p93, p94) -- line: 866
    -- upvalues: t16 (copy), clearMetal (copy)
    clearMetal(p93, p94, t16)
end

function t4.ShouldApplyMetalCombo(p95, p96) -- line: 870
    if p96 == "Golden" then
        for _, descendant in p95:GetDescendants() do
            if descendant:HasTag("SilverVisual") then
                return true
            end
        end
    elseif p96 == "Silver" then
        for _, descendant in p95:GetDescendants() do
            if descendant:HasTag("GoldenVisual") then
                return true
            end
        end
    end

    return false
end

function t4.ApplyMetalCombo(p97, p98) -- line: 879
    -- upvalues: t1 (copy), t2 (copy), t4 (copy), getSilverComboParts (copy), getTextureOverrideBindings (copy), setActiveSurfaceAppearance (copy), t15 (copy), t16 (copy)
    local v74 = getTextureOverrideBindings(p97)

    if v74 ~= nil then
        local function v78(p99) -- line: 884
            return p99.GoldenSilver
        end

        for _, v79 in v74 do
            setActiveSurfaceAppearance(v79, v79.GoldenSilver)
        end
    else
        local v75 = getSilverComboParts(p97, p98)
        local v76 = Random.new(t4.SeedFor(p98, t15.FxFolder))
        local v77 = Random.new(t4.SeedFor(p98, t16.FxFolder))

        for _, descendant in p97:GetDescendants() do
            if descendant:IsA("BasePart") and not descendant:HasTag("Effect") and descendant:GetAttribute("MutationsDontModify") ~= true and descendant:GetAttribute("DontAddTexture") ~= true and descendant:GetAttribute("IsEye") ~= true and descendant:GetAttribute("MutationFXDontRender") ~= true then
                if descendant:IsA("UnionOperation") then
                    if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                        descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor)
                    end

                    descendant.UsePartColor = true
                end

                if v75[descendant] then
                    descendant.Color = t2.Darker:Lerp(t2.Lighter, v77:NextNumber())
                else
                    descendant.Color = t1.Darker:Lerp(t1.Lighter, v76:NextNumber())
                end
            end
        end
    end
end

function t4.ApplyRainbow(p100, p101) -- line: 905
    -- upvalues: t4 (copy), getTextureOverrideBindings (copy), getActiveSurfaceAppearance (copy), cloneFxInto (copy)
    t4.ClearRainbow(p100, p101)

    if p101 then
        cloneFxInto(p101, "Rainbow", "Cleanup_RainbowFX")
    end

    local v80 = getTextureOverrideBindings(p100)

    if v80 ~= nil then
        for _, v81 in v80 do
            local v82 = getActiveSurfaceAppearance(v81)

            v82:AddTag("RainbowPart")
            v82:AddTag("Cleanup_Rainbow")
        end
    else
        for _, descendant in p100:GetDescendants() do
            if descendant:IsA("BasePart") and descendant:GetAttribute("DontAddTexture") ~= true then
                if descendant:IsA("UnionOperation") then
                    if descendant:GetAttribute("Cleanup_OriginalUserPartColor") == nil then
                        descendant:SetAttribute("Cleanup_OriginalUserPartColor", descendant.UsePartColor)
                    end

                    descendant.UsePartColor = true
                end

                descendant:AddTag("RainbowPart")
                descendant:AddTag("Cleanup_Rainbow")

                if descendant:HasTag("GoldenVisual") or descendant:HasTag("SilverVisual") then
                    if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                        descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant)
                    end

                    descendant.MaterialVariant = "StudsMetallic"
                end
            end
        end
    end
end

function t4.ClearRainbow(p102, p103) -- line: 934
    -- upvalues: getTextureOverrideBindings (copy), destroyTagged (copy)
    if p103 then
        destroyTagged(p103, "Cleanup_RainbowFX")
    end

    local v83 = getTextureOverrideBindings(p102)

    if v83 ~= nil then
        for _, v84 in v83 do
            for _, v85 in {
                    v84.Original,
                    v84.Golden,
                    v84.Silver,
                    v84.GoldenSilver
                } do
                if v85:HasTag("Cleanup_Rainbow") then
                    v85:RemoveTag("RainbowPart")
                    v85:RemoveTag("Cleanup_Rainbow")
                end
            end
        end
    else
        for _, descendant in p102:GetDescendants() do
            if descendant:IsA("BasePart") and descendant:HasTag("Cleanup_Rainbow") then
                if descendant:IsA("UnionOperation") then
                    local Cleanup_OriginalUserPartColor = descendant:GetAttribute("Cleanup_OriginalUserPartColor")

                    if typeof(Cleanup_OriginalUserPartColor) == "boolean" then
                        descendant.UsePartColor = Cleanup_OriginalUserPartColor
                        descendant:SetAttribute("Cleanup_OriginalUserPartColor", nil)
                    end
                end

                descendant:RemoveTag("RainbowPart")
                descendant:RemoveTag("Cleanup_Rainbow")

                if descendant:HasTag("GoldenVisual") or descendant:HasTag("SilverVisual") then
                    if not descendant:GetAttribute("Mutation_OriginalMaterialVariant") then
                        descendant:SetAttribute("Mutation_OriginalMaterialVariant", descendant.MaterialVariant)
                    end

                    descendant.MaterialVariant = "StudsMetallic"
                end
            end
        end
    end
end

function t4.ApplyTint(p104, p105, p106) -- line: 966
    -- upvalues: tintModel (copy)
    tintModel(p104, p105, p106)
end

function t4.ClearTint(p107) -- line: 970
    -- upvalues: clearTint (copy)
    clearTint(p107)
end

function t4.ApplyBloom(p108, p109, p110, p111, p112, p113, p114) -- line: 974
    -- upvalues: ReplicatedStorage (copy), t4 (copy), cloneFxInto (copy), tintModel (copy)
    p113 = p113 or 0.65
    t4.ClearBloom(p108, p109, p111)

    if p109 then
        local Mutations = ReplicatedStorage:FindFirstChild("Mutations")

        if Mutations and Mutations:FindFirstChild(p110) then
            cloneFxInto(p109, p110, p111, true, p114)
        end
    end

    tintModel(p108, p112, p113)
end

function t4.ClearBloom(p115, p116, p117) -- line: 997
    -- upvalues: destroyTagged (copy), clearTint (copy)
    clearTint(p115)

    if p116 then
        destroyTagged(p116, p117, true)
    end

    destroyTagged(p115, p117, true)
end

return t4

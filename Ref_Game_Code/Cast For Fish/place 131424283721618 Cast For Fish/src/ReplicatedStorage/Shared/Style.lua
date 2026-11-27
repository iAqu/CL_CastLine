-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    STUD_IMAGE = "rbxassetid://83198771938629",
    STUD_TEXTURE = "rbxassetid://133177259551430",
    CHECKER_IMAGE = "rbxassetid://95102314677499",
    WORLD_STUD_SIZE = 2,
    MODEL_STUD_SIZE = 1
}
local EnumItems = Enum.NormalId:GetEnumItems()

local function addTexture(p1, p2, p3, p4, p5, p6) -- line: 15
    -- upvalues: EnumItems (copy)
    for _, v1 in p6 or EnumItems do
        local v2 = p2 .. "_" .. v1.Name
        local v3 = p1:FindFirstChild(v2)

        if not v3 then
            v3 = Instance.new("Texture")
            v3.Name = v2
            v3.Face = v1
            v3.Parent = p1
        end

        v3.Texture = p3
        v3.StudsPerTileU = p4
        v3.StudsPerTileV = p4
        v3.ZIndex = p5
    end
end

function t1.studPart(p7, p8) -- line: 36
    -- upvalues: t1 (copy)
    p7.Material = Enum.Material.SmoothPlastic
    p7.MaterialVariant = (p8 or t1.MODEL_STUD_SIZE) >= 2 and "Stud2" or "Stud1"

    if p7:IsA("Part") then
        p7.TopSurface = Enum.SurfaceType.Smooth
        p7.BottomSurface = Enum.SurfaceType.Smooth
    end
end

function t1.studTexture(p9, p10) -- line: 48
    -- upvalues: t1 (copy), addTexture (copy)
    p9.Material = Enum.Material.SmoothPlastic
    p9.MaterialVariant = ""

    if p9:IsA("Part") then
        p9.TopSurface = Enum.SurfaceType.Smooth
        p9.BottomSurface = Enum.SurfaceType.Smooth
    end

    addTexture(p9, "Stud", t1.STUD_TEXTURE, p10 or t1.MODEL_STUD_SIZE, 2)
end

function t1.studs(p11, p12) -- line: 59
    -- upvalues: t1 (copy)
    if p11:IsA("BasePart") and not p11:GetAttribute("NoStuds") then
        t1.studPart(p11, p12)
    end

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant:GetAttribute("NoStuds") then
            t1.studPart(descendant, p12)
        end
    end
end

function t1.checker(p13, p14, p15) -- line: 71
    -- upvalues: t1 (copy), addTexture (copy)
    addTexture(p13, "Checker", t1.CHECKER_IMAGE, p14 * 2, 1, p15)
end

return t1

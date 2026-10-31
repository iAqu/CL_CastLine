-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

ReplicatedStorage:WaitForChild("Animals")

local Food = ReplicatedStorage:WaitForChild("Food")
local AnimalScale = require(ReplicatedStorage.Config.AnimalScale)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local t1 = {
    ApplyIdlePose = function(p1) -- ApplyIdlePose | line: 37
        local Scale = p1:GetScale()

        for _, descendant in ipairs(p1:GetDescendants()) do
            if descendant:IsA("Bone") then
                local IdlePose = descendant:GetAttribute("IdlePose")

                if IdlePose then
                    descendant.Transform = IdlePose.Rotation + IdlePose.Position * Scale
                end
            end
        end
    end
}

function t1.ApplyScale(p2) -- line: 50
    -- upvalues: AnimalScale (copy), t1 (copy)
    local v1 = p2:GetAttribute("AnimalName") or p2.Name
    local v2 = AnimalScale.Get(v1).Scale or 1

    if v2 ~= 1 then
        p2:ScaleTo(p2:GetScale() * v2)
        t1.ApplyIdlePose(p2)
    end

    p2:SetAttribute("VisualScale", (p2:GetAttribute("VisualScale") or 1) * v2)

    return v2
end

function t1.GetGrounding(p3) -- line: 64
    -- upvalues: AnimalScale (copy)
    if p3:GetAttribute("PartMade") then
        return (p3:GetAttribute("GroundDrop") or 0) * p3:GetScale(), false
    end

    local v3 = p3:GetAttribute("AnimalName") or p3.Name
    local v4 = AnimalScale.Get(v3)
    local v5 = p3:GetAttribute("VisualScale") or 1

    return (v4.GroundOffset or 0) * v5, v4.TrackFeet ~= false
end

function t1.GetTemplate(p4) -- line: 75
    -- upvalues: AnimalTemplates (copy)
    return AnimalTemplates.Get(p4)
end

function t1.GetFoodTemplate(p5) -- line: 79
    -- upvalues: Food (copy)
    return Food:FindFirstChild(p5)
end

function t1.GetBoundingBox(p6) -- line: 86
    if p6:GetAttribute("PartMade") then
        local Bounds = p6:FindFirstChild("Bounds")

        if Bounds and Bounds:IsA("BasePart") then
            return Bounds.CFrame, Bounds.Size
        end
    end

    return p6:GetBoundingBox()
end

function t1.GetPosedBoundingBox(p7) -- line: 104
    -- upvalues: t1 (copy)
    local v6, v7 = t1.GetBoundingBox(p7)
    local v8, v9
    local v10 = nil
    local v11 = nil

    local function visit(p8, p9, p10) -- line: 107
        -- upvalues: v6 (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), visit (copy)
        local v12 = p9 * p8.CFrame
        local v13 = p10 * p8.CFrame * p8.Transform
        local v14 = v6:PointToObjectSpace(v12.Position)
        local v15 = v6:PointToObjectSpace(v13.Position)

        if v8 then
            local v16 = v8:Min(v14)
            local v17 = v9:Max(v14)
            local v18 = v10:Min(v15)
            local v19 = v11:Max(v15)

            v8 = v16
            v9 = v17
            v10 = v18
            v11 = v19
        else
            v8 = v14
            v9 = v14
            v10 = v15
            v11 = v15
        end

        for _, child in ipairs(p8:GetChildren()) do
            if child:IsA("Bone") then
                visit(child, v12, v13)
            end
        end
    end

    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("BasePart") then
            for _, child in ipairs(descendant:GetChildren()) do
                if child:IsA("Bone") then
                    visit(child, descendant.CFrame, descendant.CFrame)
                end
            end
        end
    end

    if not v8 then
        return v6, v7
    end

    local v20 = -v7 / 2 + (v10 - v8)
    local v21 = v7 / 2 + (v11 - v9)

    return v6 * CFrame.new((v20 + v21) / 2), (v21 - v20):Max(v7 * 0.4)
end

function t1.GetSize(p11) -- line: 135
    local TrueSize = p11:GetAttribute("TrueSize")
    local BuildScale = p11:GetAttribute("BuildScale")

    if p11:GetAttribute("PartMade") and TrueSize and BuildScale then
        return TrueSize * (p11:GetScale() / BuildScale)
    end

    local _, BoundingBox = p11:GetBoundingBox()

    return BoundingBox
end

function t1.GetLongestSide(p12) -- line: 144
    -- upvalues: t1 (copy)
    local v22 = t1.GetSize(p12)

    return (math.max(v22.X, v22.Y, v22.Z))
end

function t1.Create(p13) -- line: 150
    -- upvalues: ReplicatedStorage (copy), CollectionService (copy), AnimalScale (copy), AnimalTemplates (copy), t1 (copy)
    local v23 = AnimalTemplates.Get(p13)

    if v23 then
        local clone = v23:Clone()

        clone:SetAttribute("AnimalName", p13)

        local v24 = clone:GetAttribute("PartMade") and clone.PrimaryPart

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = not v24 or descendant == v24
                descendant.CanCollide = false
                descendant.CanQuery = true
                descendant.CanTouch = false
                descendant.CastShadow = true
            elseif descendant:IsA("Highlight") then
                descendant:Destroy()
            end
        end

        if not clone.PrimaryPart then
            clone.PrimaryPart = clone:FindFirstChildWhichIsA("BasePart")
        end

        local PrimaryPart = clone.PrimaryPart

        if PrimaryPart then
            local v25 = not v24 and AnimalScale.Get(p13).Rotation
            local identity = CFrame.identity

            if v25 then
                identity = CFrame.Angles(math.rad(v25[1] or 0), math.rad(v25[2] or 0), (math.rad(v25[3] or 0)))
            end

            PrimaryPart.PivotOffset = CFrame.new(PrimaryPart.PivotOffset.Position) * identity
        end

        CollectionService:AddTag(clone, "Animal")
        t1.ApplyIdlePose(clone)

        if clone:GetAttribute("StudioPieces") then
            local Bounds = clone:FindFirstChild("Bounds")

            if Bounds then
                Bounds.CanQuery = false
            end

            task.defer(function() -- line: 196
                -- upvalues: clone (copy), ReplicatedStorage (copy)
                if clone:GetAttribute("Look") == nil then
                    require(ReplicatedStorage.Shared.StudioPieces).Sync(clone)
                end
            end)
        end

        return clone
    end

    warn("[AnimalUtil] Unknown animal model: " .. tostring(p13))

    return nil
end

function t1.CreateFood(p14) -- line: 211
    -- upvalues: Food (copy)
    local v31 = Food:FindFirstChild(p14)

    if v31 then
        local Model

        if v31:IsA("Model") then
            Model = v31:Clone()
        else
            Model = Instance.new("Model")
            Model.Name = p14
            v31:Clone().Parent = Model
        end

        for _, descendant in ipairs(Model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
            end
        end

        local BoundingBox, BoundingBox2 = Model:GetBoundingBox()
        local Part = Instance.new("Part")

        Part.Name = "Handle"
        Part.Size = BoundingBox2
        Part.CFrame = BoundingBox
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.Massless = true
        Part.Parent = Model
        Model.PrimaryPart = Part

        return Model
    end

    warn("[AnimalUtil] Unknown food model: " .. tostring(p14))

    return nil
end

function t1.GetFoodLongest(p15) -- line: 251
    local ExtentsSize = p15:GetExtentsSize()

    return (math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z))
end

function t1.ScaleFoodToLongest(p16, p17) -- line: 257
    -- upvalues: t1 (copy)
    local v32 = t1.GetFoodLongest(p16)

    if v32 <= 0 then
        return 1
    end

    local v33 = p17 / v32

    p16:ScaleTo(p16:GetScale() * v33)

    return v33
end

function t1.ScaleToLongest(p18, p19) -- line: 267
    -- upvalues: t1 (copy)
    local v34 = t1.GetLongestSide(p18)

    if v34 <= 0 then
        return 1
    end

    local v35 = p19 / v34

    p18:ScaleTo(p18:GetScale() * v35)
    t1.ApplyIdlePose(p18)
    p18:SetAttribute("VisualScale", (p18:GetAttribute("VisualScale") or 1) * v35)

    return v35
end

function t1.FitWithin(p20, p21) -- line: 278
    -- upvalues: t1 (copy)
    if p21 < t1.GetLongestSide(p20) then
        return t1.ScaleToLongest(p20, p21)
    end

    return 1
end

function t1.SoftCapLongest(p22, p23, p24) -- line: 289
    if p22 <= p23 then
        return p22
    end

    return p23 * (1 + p24 * math.log(p22 / p23))
end

function t1.SoftCapSize(p25, p26, p27) -- line: 295
    -- upvalues: t1 (copy)
    local v37 = t1.GetLongestSide(p25)

    if v37 <= p26 then
        return 1
    end

    return t1.ScaleToLongest(p25, t1.SoftCapLongest(v37, p26, p27))
end

function t1.GetBottomOffset(p28) -- line: 302
    -- upvalues: t1 (copy)
    local v38, v39 = t1.GetBoundingBox(p28)

    return p28:GetPivot().Position.Y - (v38.Position.Y - v39.Y / 2)
end

function t1.PlaceOnGround(p29, p30, p31, p32) -- line: 310
    -- upvalues: t1 (copy)
    local v40 = (p32 or 0) - t1.GetGrounding(p29)
    local v41 = if not p31 or p31.Magnitude < 0.01 then Vector3.new(0, 0, -1) else p31
    local v42 = Vector3.new(v41.X, 0, v41.Z)

    if v42.Magnitude < 0.01 then
        v42 = Vector3.new(0, 0, -1)
    end

    local Unit = v42.Unit
    local v43 = CFrame.lookAt(Vector3.new(0, 0, 0), Unit)

    p29:PivotTo(v43 + p30)

    local v44, v45 = t1.GetBoundingBox(p29)
    local v46 = v44.Position.Y - v45.Y / 2
    local v48 = v43 + (p30 + Vector3.new(0, p30.Y + v40 - v46, 0))
    local v49 = t1.GetBoundingBox(p29)
    local v52 = v48 + Vector3.new(p30.X - v49.Position.X, 0, p30.Z - v49.Position.Z)

    p29:PivotTo(v52)

    return v52
end

local MaterialService = game:GetService("MaterialService")

local function scaledVariant(p33, p34) -- line: 342
    -- upvalues: AnimalTemplates (copy), MaterialService (copy)
    local v54 = 2 ^ (math.floor(math.log(p34, 2) * 4 + 0.5) / 4)

    if math.abs(v54 - 1) < 0.01 then
        return p33
    end

    local v56 = string.format("%s@%.3f", p33, v54)

    if not MaterialService:FindFirstChild(v56, true) then
        local v57 = MaterialService:FindFirstChild(p33, true)

        if not (v57 and v57:IsA("MaterialVariant")) or not (game:GetService("RunService"):IsServer() or AnimalTemplates.HasOverride()) then
            return p33
        end

        local clone = v57:Clone()

        clone.Name = v56
        clone.StudsPerTile = v57.StudsPerTile / v54
        clone.Parent = v57.Parent
    end

    return v56
end

function t1.UseCarriedStuds(p35) -- line: 358
    -- upvalues: scaledVariant (copy)
    local Scale = p35:GetScale()

    for _, descendant in ipairs(p35:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.MaterialVariant ~= "" then
            descendant.MaterialVariant = scaledVariant(string.match(descendant.MaterialVariant, "^(.-)@") or descendant.MaterialVariant, Scale)
        end
    end
end

function t1.MakeSilhouette(p36) -- line: 369
    p36:SetAttribute("Silhouette", true)

    for _, descendant in ipairs(p36:GetDescendants()) do
        if descendant:IsA("SurfaceAppearance") then
            descendant:Destroy()
        elseif descendant:IsA("MeshPart") then
            descendant.TextureID = ""
            descendant.Color = Color3.fromRGB(8, 8, 10)
            descendant.Material = Enum.Material.SmoothPlastic
        elseif descendant:IsA("BasePart") then
            if descendant:IsA("PartOperation") then
                descendant.UsePartColor = true
            end

            descendant.Color = Color3.fromRGB(8, 8, 10)
            descendant.Material = Enum.Material.SmoothPlastic
        end
    end
end

function t1.SetOutline(p37, p38, p39) -- line: 387
    local Outline = p37:FindFirstChild("Outline")

    if p39 == false then
        if Outline then
            Outline.Enabled = false
        end

        return Outline
    end

    if not Outline then
        Outline = Instance.new("Highlight")
        Outline.Name = "Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.DepthMode = Enum.HighlightDepthMode.Occluded
        Outline.Adornee = p37
        Outline.Parent = p37
    end

    Outline.OutlineColor = p38 or Color3.new(0, 0, 0)
    Outline.Enabled = true

    return Outline
end

t1.HOLD_BELOW = 2.2

function t1.HoldGrip(p40) -- line: 414
    -- upvalues: t1 (copy)
    local HoldProfile = p40:GetAttribute("HoldProfile")
    local BuildScale = p40:GetAttribute("BuildScale")

    if type(HoldProfile) ~= "string" or not BuildScale then
        return nil
    end

    local v59 = p40:GetScale() / BuildScale
    local t2 = {}

    for match in string.gmatch(HoldProfile, "[^|]+") do
        local v60, v61, v62 = match:match("([^,]+),([^,]+),([^,]+)")

        if v60 then
            table.insert(t2, Vector3.new(tonumber(v60), tonumber(v61), (tonumber(v62))) * v59)
        end
    end

    if #t2 == 0 then
        return nil
    end

    local v67, v68 = t1.GetBoundingBox(p40)
    local v71 = p40:GetPivot():PointToObjectSpace(v67.Position).Y - v68.Y / 2 + math.min(t1.HOLD_BELOW, v68.Y * 0.45)
    local v72

    for _, v73 in ipairs(t2) do
        if v73.Y <= v71 + 0.01 and (not v72 or v73.Y > v72.Y) then
            v72 = v73
        end
    end

    if not v72 then
        for _, v75 in ipairs(t2) do
            if not v72 or v75.Y < v72.Y then
                v72 = v75
            end
        end
    end

    return v72 + Vector3.new(0.12, 0, 0)
end

function t1.GetTopY(p41) -- line: 440
    -- upvalues: t1 (copy)
    local v76, v77 = t1.GetBoundingBox(p41)

    return v76.Position.Y + v77.Y / 2
end

return t1

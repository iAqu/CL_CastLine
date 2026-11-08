-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetPalette = require(ReplicatedStorage.Shared.Util.AssetPalette)
local Assets = require(ReplicatedStorage.Data.Assets)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggScaling = require(ReplicatedStorage.Shared.Util.EggScaling)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local ParasiteVisual = require(script.Parent.ParasiteVisual)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types)

local EggRarityVFX = ReplicatedStorage.Assets.Particles.EggRarityVFX
local t1 = {}

local function exceedsPlacedCollisionBounds(p1) -- line: 36
    if p1.X > 20 or p1.Y > 20 then
        return true
    end

    return p1.Z > 20
end

local function rarityVfxSource(p2) -- line: 44
    -- upvalues: EggRarityVFX (copy)
    local n1 = -1
    local child

    for _, child2 in EggRarityVFX:GetChildren() do
        local v1, v2 = string.match(child2.Name, "^RarityNumber(%d+)(%+?)$")

        assert(v1 ~= nil, (("EggRarityVFX child \"%*\" is not named RarityNumber<n>[+]"):format(child2.Name)))

        local v5 = tonumber(v1)

        if (if v2 == "+" then v5 <= p2 else p2 == v5) and n1 < v5 then
            n1 = v5
            child = child2
        end
    end

    return child
end

local function attachRarityVfx(p3, p4) -- line: 63
    -- upvalues: rarityVfxSource (copy)
    local v6 = rarityVfxSource(p4)

    if v6 == nil then
        return
    end

    local Hitbox = p3:FindFirstChild("Hitbox")

    assert(Hitbox ~= nil, (("Egg model %* is missing its Hitbox"):format(p3.Name)))
    assert(Hitbox:IsA("BasePart"), (("Egg model %* Hitbox must be a BasePart"):format(p3.Name)))

    local v11 = math.max(v6:GetAttribute("HitboxSizeY") or 5, 1)
    local Model = Instance.new("Model")

    for _, child in v6:GetChildren() do
        child:Clone().Parent = Model
    end

    Model:ScaleTo(Hitbox.Size.Y / v11)

    for _, child in Model:GetChildren() do
        child.Parent = Hitbox
    end

    Model:Destroy()
end

function t1.GetTemplate(p5) -- line: 94
    -- upvalues: EggRecords (copy), Eggs (copy)
    assert(Eggs.SchemaValidation.SavedEgg(p5), "Invalid saved egg record")

    return EggRecords.EggModelTemplate(p5.AssetCategory, p5.Mutations, p5.BaseMutation, p5.EggSkin)
end

function t1.DisableCollisions(p6) -- line: 105
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p6)

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

function t1.ApplyPlacedCollisionPolicy(p7) -- line: 115
    -- upvalues: ModelBounds (copy), t (copy)
    t.strict(t.instanceIsA("Model"))(p7)

    local _, v13 = ModelBounds(p7)

    v13 = p7.PrimaryPart and p7.PrimaryPart.Size or v13

    local v14 = not (v13.X > 20 or v13.Y > 20 or v13.Z > 20)

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = v14 and descendant.Transparency < 1
        end
    end
end

function t1.RenderVisual(p8, p9, p10) -- line: 128
    -- upvalues: AssetPalette (copy), Assets (copy), ModelBounds (copy), EggScaling (copy), Eggs (copy), Mutations (copy), ParasiteVisual (copy), t (copy), t1 (copy), attachRarityVfx (copy)
    t.strict(t.Instance)(p9)
    t.strict(t.number)(p8.OwnerUserId)
    t.strict(t.string)(p8.UID)
    t.strict(t.string)(p8.ModelName)
    assert(Eggs.SchemaValidation.SavedEgg(p8.Record), "Invalid saved egg record")

    local v16 = Assets.Directory[p8.Record.AssetCategory]

    assert(v16 ~= nil, (("Missing asset config for category %*"):format(p8.Record.AssetCategory)))

    local Egg = v16.Egg
    local clone = t1.GetTemplate(p8.Record):Clone()

    clone.Name = p8.ModelName
    attachRarityVfx(clone, v16.Rarity.Rank)

    local Scale = clone:GetScale()
    local AssetCategory = p8.Record.AssetCategory
    local v19 = if p8.ScaleMultiplier then EggScaling.LiftToFloor(Scale, p8.ScaleMultiplier, AssetCategory) else EggScaling.PreGrowthVisual(Scale, p8.Record.AssetScale, AssetCategory)
    local v21 = math.clamp(p8.ScaleAlpha or 1, 0.5, 1)

    clone:ScaleTo(EggScaling.LiftToFloor(Scale, v19 * v21, AssetCategory))

    if Mutations.EggModelName(p8.Record.Mutations, p8.Record.BaseMutation) == nil then
        AssetPalette.PaintModel(clone, p8.Record.AssetCategory, p8.Record.AssetEyeColor, p8.Record.AssetColorSeed, p8.Record.AssetColorIndex)
    end

    local PrimaryPart = clone.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)

    local v22, v23 = ModelBounds(clone)
    local v24 = v22.Position.Y - v23.Y * 0.5
    local Y = PrimaryPart.CFrame.Position.Y

    PrimaryPart.PivotOffset = CFrame.new(0, v24 - Y, 0)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = descendant.Transparency ~= 1
            descendant.CanTouch = false
            descendant.Massless = true
            descendant.Anchored = not p9:IsA("Tool") and descendant == PrimaryPart
        end
    end

    if p10 then
        t1.ApplyPlacedCollisionPolicy(clone)
    end

    clone.Parent = p9
    ParasiteVisual.Attach(clone, p8.Record.HasParasite)

    return {
        Model = clone,
        VisibleParts = { PrimaryPart },
        Config = Egg
    }
end

function t1.GetAuthoredScale(p11) -- line: 201
    -- upvalues: Eggs (copy), t1 (copy)
    assert(Eggs.SchemaValidation.SavedEgg(p11), "Invalid saved egg record")

    local Scale = t1.GetTemplate(p11):GetScale()

    assert(Scale > 0, (("Egg model %* scale must be greater than 0"):format(p11.AssetCategory)))

    return Scale
end

function t1.GetVisibleBounds(p12) -- line: 211
    -- upvalues: Assets (copy), ModelBounds (copy), Eggs (copy), t1 (copy)
    assert(Eggs.SchemaValidation.SavedEgg(p12), "Invalid saved egg record")
    assert(Assets.Directory[p12.AssetCategory] ~= nil, (("Missing asset config for category %*"):format(p12.AssetCategory)))

    local v31 = t1.GetTemplate(p12)
    local v32 = t1.GetAuthoredScale(p12)
    local _, v33 = ModelBounds(v31)

    return v33 / v32
end

return t1

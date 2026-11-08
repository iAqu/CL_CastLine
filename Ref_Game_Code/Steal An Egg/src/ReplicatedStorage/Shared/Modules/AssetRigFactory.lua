-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local AssetInvertedModelPresentation = require(ReplicatedStorage.Shared.Modules.AssetInvertedModelPresentation)
local SpecialLuckyBlockAsset = require(ReplicatedStorage.Shared.Util.SpecialLuckyBlockAsset)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local AssetPalette = require(ReplicatedStorage.Shared.Util.AssetPalette)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local Retry = require(ReplicatedStorage.Shared.Utils.Retry)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local AssetModels = require(ReplicatedStorage.Shared.Modules.AssetModels)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local v1 = require(ReplicatedStorage.Packages.Log).new()

local function markReplayOrigin(p1, p2) -- line: 29
    p1:SetAttribute("UG_REPLAY_BAKED_ORIGIN", p2:GetPivot():Inverse() * p1:GetPivot())
end

local t1 = {
    Scale = function(p3) -- Scale | line: 35
        if typeof(p3) == "number" then
            return (math.max(p3, 0))
        end

        return 1
    end
}

function t1.RigScale(p4, p5) -- line: 39
    -- upvalues: AssetModels (copy), t1 (copy)
    return t1.Scale(p5) * AssetModels.GetBaseModelScale(p4)
end

function t1.Mass(p6, p7) -- line: 43
    -- upvalues: Assets (copy), t1 (copy)
    return (tonumber(Assets.Directory[p6].ModelWeight) or 1) * t1.Scale(p7)
end

function t1.Resize(p8, p9, p10) -- line: 48
    -- upvalues: t1 (copy)
    local v2 = t1.RigScale(p9, p10)

    p8:ScaleTo(v2)

    return v2
end

function t1.Extents(p11) -- line: 54
    -- upvalues: AssetItem (copy), AssetModels (copy)
    assert(AssetItem.AssetItemData(p11))

    local v3 = AssetModels.GetVisibleBoundsData(p11.Category)

    assert(v3.TemplateScale > 0, (("template scale for %* is not above zero"):format(p11.Category)))

    return v3.Size / v3.TemplateScale
end

function t1.Build(p12, p13) -- line: 63
    -- upvalues: AssetItem (copy), AssetInvertedModelPresentation (copy), Mutations (copy), AssetPalette (copy), Personalities (copy), AssetModels (copy), t1 (copy)
    assert(AssetItem.AssetItemData(p12))

    local Category = p12.Category
    local v8 = assert(AssetModels.Resolve(Category), (("%* has no rig template"):format(Category)))
    local clone = v8:Clone()

    clone.PrimaryPart = clone:FindFirstChild("Segment1", true) or clone.PrimaryPart
    assert(clone.PrimaryPart, (("the %* rig template names no primary part"):format(Category)))
    clone:SetAttribute("UG_REPLAY_BAKED_ORIGIN", v8:GetPivot():Inverse() * clone:GetPivot())

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v10 = descendant.Transparency == 1

            descendant.Anchored = false
            descendant.CanQuery = not v10

            if v10 or p13 then
                descendant.CanCollide = false
            end
        end
    end

    local v11 = AssetPalette.SettleFields(Category, p12.EyeColor, p12.ColorSeed, p12.ColorIndex)

    AssetPalette.PaintModel(clone, Category, v11.EyeColor, v11.ColorSeed, v11.ColorIndex)

    for _, v12 in Mutations.Sanitize(p12.Mutations) do
        Mutations.ApplyTo(clone, v12, v11.ColorSeed)
    end

    t1.Resize(clone, Category, p12.Scale)

    if p12.Personality == Personalities.Personalities.InvertedModel then
        AssetInvertedModelPresentation.Invert(clone)
    end

    return clone
end

function t1.Strip(p14, p15, p16) -- line: 102
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p14)

    local v13 = p14.PrimaryPart or p14:FindFirstChild("HumanoidRootPart", true)
    local t2 = {}

    for _, descendant in ipairs(p14:GetDescendants()) do
        local v14 = descendant:IsA("AnimationController") or descendant:IsA("Animator")
        local Bone = descendant:IsA("Bone")

        if v14 and not p16 or Bone and not p15 or descendant:IsA("Humanoid") then
            t2[#t2 + 1] = descendant
        end
    end

    local elapsed = os.clock()

    for v15, v16 in ipairs(t2) do
        v16:Destroy()

        if v15 < #t2 and os.clock() - elapsed >= 0.002 then
            task.wait()
            elapsed = os.clock()
        end
    end

    if v13 and v13:IsA("BasePart") then
        p14.PrimaryPart = v13
    end
end

local function playIdleOnceInWorld(p17, p18, p19) -- line: 135
    -- upvalues: Retry (copy), v1 (copy)
    local connection

    connection = p17.AncestryChanged:Connect(function(_, p21) -- line: 137
        -- upvalues: p17 (copy), p18 (copy), p19 (copy), connection (ref), Retry (copy), v1 (copy)
        if not (p21 and p21:IsDescendantOf(workspace)) and p21 ~= workspace then
            return
        end

        connection:Disconnect()

        local v17, v18 = Retry(function() -- line: 144
            -- upvalues: p18 (copy), p19 (copy)
            return p18:LoadAnimation(p19)
        end):await()

        if v17 then
            v18.Looped = true
            v18.Priority = Enum.AnimationPriority.Idle
            v18:Play()

            return
        end

        v1:AtError():Log((("idle track refused to load on %*: %*"):format(p17.Name, v18)))
    end)
end

local function replaceRigController(p22, p23) -- line: 158
    -- upvalues: Constants (copy)
    local v19 = p22:FindFirstChildWhichIsA("AnimationController", true)

    if v19 then
        local Animator = v19:FindFirstChildWhichIsA("Animator")

        if Animator then
            Animator:Destroy()
        end

        v19:Destroy()
    end

    local AnimationController = Instance.new("AnimationController")

    AnimationController.Name = "AnimationController"
    AnimationController.Parent = p22:WaitForChild("Model")

    local Animator = Instance.new("Animator")

    if Constants.IS_SERVER then
        Animator:SetAttribute("ActiveAssetRarity", p23)
    end

    Animator.Parent = AnimationController

    return Animator
end

function t1.BuildActive(p24, p25, p26, p27, p28) -- line: 181
    -- upvalues: Assets (copy), SpecialLuckyBlockAsset (copy), Retry (copy), t (copy), v1 (copy), t1 (copy), replaceRigController (copy)
    t.strict(t.optional(t.string))(p24)

    local v20 = t1.Build(p25, true)

    assert(v20.PrimaryPart, "a freshly built rig lost its primary part").Anchored = true
    v20:SetAttribute("SpecialLuckyBlockAsset", SpecialLuckyBlockAsset.Matches(p25))

    local v21 = Assets.Directory[p25.Category]
    local Idle = v21.Animations.Idle

    if p26 and Idle and v20:GetAttribute("AnimationsDisabled") ~= true then
        assert(Idle, (("%* was asked to animate without an idle track"):format(p25.Category)))

        local v23 = replaceRigController(v20, v21.Rarity._id)
        local connection

        connection = v20.AncestryChanged:Connect(function(_, p30) -- line: 137
            -- upvalues: v20 (copy), Idle (copy), v23 (copy), connection (ref), Retry (copy), v1 (copy)
            if not (p30 and p30:IsDescendantOf(workspace)) and p30 ~= workspace then
                return
            end

            connection:Disconnect()

            local v24, v25 = Retry(function() -- line: 144
                -- upvalues: Idle (copy), v23 (copy)
                return v23:LoadAnimation(Idle)
            end):await()

            if v24 then
                v25.Looped = true
                v25.Priority = Enum.AnimationPriority.Idle
                v25:Play()

                return
            end

            v1:AtError():Log((("idle track refused to load on %*: %*"):format(v20.Name, v25)))
        end)

        if p24 then
            v20:SetAttribute("UID", p24)
        end

        return v20
    end

    t1.Strip(v20, v20:GetAttribute("DontRemoveBones") or p27, p28)

    if p24 then
        v20:SetAttribute("UID", p24)
    end

    return v20
end

function t1.BuildWandering(p31, p32, p33, p34) -- line: 216
    -- upvalues: AssetItem (copy), AssetModels (copy), t (copy), ModelBounds (copy), t1 (copy)
    t.strict(t.number)(p31)
    t.strict(t.string)(p32)
    t.strict(t.Instance)(p34)
    assert(AssetItem.AssetItemData(p33))

    local v26 = t1.Build(p33, true)

    v26.Name = ("%*_%*"):format(p31, p32)

    local v28 = assert(v26.PrimaryPart, (("the %* rig has no primary part"):format(p33.Category)))
    local v29, v30 = ModelBounds(v26)

    v28.PivotOffset = CFrame.new(0, v29.Position.Y - v30.Y * 0.5 - v28.Position.Y, 0)
    v26:SetAttribute("UG_REPLAY_BAKED_ORIGIN", assert(AssetModels.Resolve(p33.Category), (("%* has no rig template"):format(p33.Category))):GetPivot():Inverse() * v26:GetPivot())

    for _, descendant in v26:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = descendant.Transparency ~= 1
            descendant.CanTouch = false
            descendant.Massless = true
            descendant.Anchored = false
        end
    end

    v28.Anchored = true
    v26:SetAttribute("UID", p32)
    v26:SetAttribute("OwnerUserId", p31)
    v26.Parent = p34

    return v26
end

return t1

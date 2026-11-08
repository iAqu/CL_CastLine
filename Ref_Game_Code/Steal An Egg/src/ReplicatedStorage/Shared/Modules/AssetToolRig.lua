-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local AssetDisplayText = require(ReplicatedStorage.Shared.Modules.AssetDisplayText)
local AssetInfoBillboard = require(ReplicatedStorage.Shared.Modules.AssetInfoBillboard)
local Discard = require(ReplicatedStorage.Shared.Utils.VFX).Discard
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetInvertedModelPresentation = require(ReplicatedStorage.Shared.Modules.AssetInvertedModelPresentation)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local AssetPalette = require(ReplicatedStorage.Shared.Util.AssetPalette)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local AssetRigFactory = require(ReplicatedStorage.Shared.Modules.AssetRigFactory)
local Physics = require(ReplicatedStorage.Shared.Utils.Physics)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local AssetSounds = require(ReplicatedStorage.Shared.Util.AssetSounds)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local t1 = {
    Name = "Handle",
    Size = Vector3.new(0.2, 0.2, 0.2),
    Transparency = 1,
    CanCollide = false,
    CanQuery = false,
    CanTouch = false,
    Anchored = false,
    Massless = true
}
local t2 = {
    ["Cave Dragon"] = "HumanoidRootPart",
    Warden = "HumanoidRootPart",
    ["Eternal Lunar Dragon"] = "HumanoidRootPart",
    Unicorn = "HumanoidRootPartXZBoundsBottomY"
}
local t3 = {
    HumanoidRootPartXZBoundsBottomY = function(p1, p2) -- HumanoidRootPartXZBoundsBottomY | line: 52
        -- upvalues: ModelBounds (copy)
        local v1, v2 = ModelBounds(p1)

        return p2.CFrame.Rotation + Vector3.new(p2.Position.X, v1.Position.Y - v2.Y * 0.5, p2.Position.Z)
    end
}
local t4 = {}

local function pinHandleContract(p3) -- line: 61
    p3.RequiresHandle = true
    p3.CanBeDropped = false
end

local function stamp(p4, p5) -- line: 66
    for _, v4 in p5 do
        p4:SetAttribute(v4[1], v4[2])
    end
end

local function copyAttribute(p6, p7, p8) -- line: 72
    if p6:GetAttribute(p7) ~= p8 then
        p6:SetAttribute(p7, p8)
    end
end

local function ensureGrip(p9) -- line: 78
    -- upvalues: t1 (copy)
    local Handle = p9:FindFirstChild("Handle")

    if Handle and Handle:IsA("BasePart") then
        return Handle
    end

    local Part = Instance.new("Part")

    for v5, v6 in t1 do
        Part[v5] = v6
    end

    Part.Parent = p9
    p9.RequiresHandle = true
    p9.CanBeDropped = false

    return Part
end

local function seatRigOnGrip(p10, p11, p12, p13) -- line: 96
    -- upvalues: ModelBounds (copy), t3 (copy), ensureGrip (copy)
    p12 = p12 or 1
    assert(p12, "luau")

    local v9 = assert(p11.PrimaryPart, (("%* cannot be gripped without a root"):format((p11:GetFullName()))))
    local Pivot = p11:GetPivot()
    local v10 = ensureGrip(p10)
    local v11

    if p13 then
        local v12 = p11:FindFirstChild("HumanoidRootPart", true)

        assert(v12 ~= nil and v12:IsA("BasePart"), (("%* is missing the root its grip is anchored to"):format((p11:GetFullName()))))

        local v15 = t3[p13]

        v11 = if v15 then v15(p11, v12) else v12.CFrame
    else
        local v16, v17 = ModelBounds(p11)

        v11 = v16 * CFrame.new(0, v17.Y * -0.5, p12 * (v17.Z * 0.1))
    end

    p11:PivotTo(v10.CFrame * v11:ToObjectSpace(Pivot))

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = v9
    WeldConstraint.Part1 = v10
    WeldConstraint.Parent = v9

    return v10
end

local function ownedGamepassesFor(p14) -- line: 129
    -- upvalues: Constants (copy)
    if not Constants.IS_SERVER then
        return nil
    end

    local v18, v19 = require(game:GetService("ServerScriptService").Library.Database).UnsafeGetProfileAwait(p14)

    return if v18 and v19 then v19.Gamepasses else nil
end

function t4.Build(p15, p16, p17) -- line: 141
    -- upvalues: CollectionService (copy), Assets (copy), AssetItem (copy), AssetDisplayText (copy), AssetInfoBillboard (copy), Discard (copy), AssetEarnings (copy), AssetInvertedModelPresentation (copy), Simple (copy), AssetPalette (copy), Personalities (copy), AssetRigFactory (copy), Physics (copy), Constants (copy), AssetSounds (copy), t (copy), t2 (copy), ensureGrip (copy), seatRigOnGrip (copy)
    assert(AssetItem.AssetItemData(p15))
    t.strict(t.string)(p16)

    local Category = p15.Category
    local v20 = Assets.Directory[Category]
    local v21 = AssetPalette.SettleFields(Category, p15.EyeColor, p15.ColorSeed, p15.ColorIndex)
    local v22 = table.concat(p15.Mutations, ", ")
    local v23 = v20.DisplayName or Category
    local Tool = Instance.new("Tool")

    Tool.Name = AssetDisplayText.ForRecord(p15)
    Tool.RequiresHandle = true
    Tool.CanBeDropped = false

    for _, v24 in {
            { "GuardTransparencyExcluded", true },
            { "UID", p16 },
            { "Mutations", v22 },
            {
                "BaseMutation",
                p15.BaseMutation
            },
            { "DisplayName", v23 },
            {
                "Weight",
                AssetRigFactory.Mass(Category, p15.Scale)
            },
            {
                "Scale",
                p15.Scale
            },
            {
                "EyeColor",
                v21.EyeColor
            },
            {
                "ColorSeed",
                v21.ColorSeed
            },
            {
                "ColorIndex",
                v21.ColorIndex
            },
            {
                "Category",
                v20._id
            },
            {
                "Favorite",
                p15.IsFavorite or false
            },
            { "ItemType", "Asset" }
        } do
        Tool:SetAttribute(v24[1], v24[2])
    end

    CollectionService:AddTag(Tool, "AssetTool")

    local Configuration = Instance.new("Configuration")

    Configuration.Name = "Configuration"
    Configuration.Parent = Tool

    for _, v25 in {
            { "mutations", v22 },
            {
                "baseMutation",
                p15.BaseMutation
            },
            { "displayName", v23 },
            {
                "scale",
                p15.Scale
            },
            {
                "eyeColor",
                v21.EyeColor
            },
            {
                "colorSeed",
                v21.ColorSeed
            },
            {
                "colorIndex",
                v21.ColorIndex
            },
            {
                "rarity",
                v20.Rarity._id
            },
            {
                "money",
                p15.GeneratedMoney or 0
            }
        } do
        Configuration:SetAttribute(v25[1], v25[2])
    end

    local Gamepasses

    if Constants.IS_SERVER then
        local v26, v27 = require(game:GetService("ServerScriptService").Library.Database).UnsafeGetProfileAwait(p17)

        if v26 and v27 then
            Gamepasses = v27.Gamepasses
        end
    end

    for _, v28 in {
            {
                "perSecond",
                AssetEarnings.LiveRatePerSecond(p15, Gamepasses)
            },
            {
                "perSecondDisplay",
                AssetEarnings.RatePerSecond(p15, Gamepasses)
            }
        } do
        Configuration:SetAttribute(v28[1], v28[2])
    end

    local v29 = ensureGrip(Tool)
    local v30, v31, v32

    local function mirrorTags() -- line: 199
        -- upvalues: Tool (copy), Configuration (copy), v30 (ref)
        local Mutations = Tool:GetAttribute("Mutations")
        local BaseMutation = Tool:GetAttribute("BaseMutation")

        if Configuration:GetAttribute("mutations") ~= Mutations then
            Configuration:SetAttribute("mutations", Mutations)
        end

        if Configuration:GetAttribute("baseMutation") ~= BaseMutation then
            Configuration:SetAttribute("baseMutation", BaseMutation)
        end

        if not v30 then
            return
        end

        local v33 = v30

        if v33:GetAttribute("Mutations") ~= Mutations then
            v33:SetAttribute("Mutations", Mutations)
        end

        local v34 = v30

        if v34:GetAttribute("BaseMutation") ~= BaseMutation then
            v34:SetAttribute("BaseMutation", BaseMutation)
        end
    end

    local function dropCard() -- line: 212
        -- upvalues: v31 (ref), v32 (ref), Discard (copy)
        if v31 then
            Discard(v31, 0)
            v31 = nil
            v32 = nil
        end
    end

    local function dropRig() -- line: 220
        -- upvalues: v30 (ref), v31 (ref), v32 (ref), Discard (copy)
        if v31 then
            Discard(v31, 0)
            v31 = nil
            v32 = nil
        end

        if v30 then
            Discard(v30, 0)
            v30 = nil
        end
    end

    local function ensureRig() -- line: 229
        -- upvalues: p15 (copy), p16 (copy), Category (copy), Tool (copy), v29 (ref), v30 (ref), v31 (ref), v32 (ref), mirrorTags (copy), Discard (copy), AssetInvertedModelPresentation (copy), Personalities (copy), AssetRigFactory (copy), Physics (copy), t2 (copy), seatRigOnGrip (copy)
        if v30 and v30.Parent == Tool and v29.Parent == Tool then
            return v30
        end

        if v31 then
            Discard(v31, 0)
            v31 = nil
            v32 = nil
        end

        if v30 then
            Discard(v30, 0)
            v30 = nil
        end

        local v35 = p15.Personality == Personalities.Personalities.InvertedModel
        local v36 = p15

        if v35 then
            v36 = table.clone(p15)
            v36.Mutations = table.clone(p15.Mutations)
            v36.Personality = Personalities.Personalities.Normal
        end

        local v37 = AssetRigFactory.BuildActive(p16, v36, true, true)

        Physics.DisableAllPhysics(v37)
        Physics.SetAnchored(v37, false)
        v29 = seatRigOnGrip(Tool, v37, nil, t2[Category])

        if v35 then
            AssetInvertedModelPresentation.Invert(v37)
            Physics.SetAnchored(v37, false)
        end

        for _, descendant in v37:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant:SetAttribute("KillPartIgnore", true)
            end
        end

        v30 = v37
        v37.Parent = Tool
        mirrorTags()

        return v37
    end

    local function refreshCaptions() -- line: 267
        -- upvalues: Category (copy), Tool (copy), Configuration (copy), v31 (ref), v32 (ref), mirrorTags (copy), AssetDisplayText (copy), AssetInfoBillboard (copy), Simple (copy), AssetRigFactory (copy), AssetSounds (copy)
        local v38 = Configuration:GetAttribute("displayName") or ""
        local scale = Configuration:GetAttribute("scale")

        if typeof(scale) ~= "number" then
            scale = 1
        end

        local v39 = AssetRigFactory.Mass(Category, scale)
        local v40 = AssetSounds.ParseMutationList(Tool:GetAttribute("Mutations") or "")
        local BaseMutation = Tool:GetAttribute("BaseMutation")

        mirrorTags()
        Tool:SetAttribute("Weight", v39)
        Tool.Name = AssetDisplayText.WithMass(v38, v40, BaseMutation, v39)

        if v31 then
            AssetInfoBillboard.WriteTitle(v31, v38, v40, BaseMutation)

            if v32 then
                local perSecondDisplay = Configuration:GetAttribute("perSecondDisplay")

                if typeof(perSecondDisplay) ~= "number" then
                    perSecondDisplay = Configuration:GetAttribute("perSecond")
                end

                local v41 = v32

                v41.Text = ("$%*/s"):format((Simple.FormatCompact(perSecondDisplay)))
            end
        end
    end

    local function ensureCard() -- line: 295
        -- upvalues: p15 (copy), p17 (copy), Category (copy), v29 (ref), v31 (ref), v32 (ref), ensureRig (copy), refreshCaptions (copy), AssetInfoBillboard (copy)
        local v42 = ensureRig()

        if not v31 then
            local v43, _, v44 = AssetInfoBillboard.Attach(v42, Category, p15)

            if v43 then
                v31 = v43

                local Adornee = v43.Adornee

                v43.MaxDistance = math.max(v43.MaxDistance * 2.8, p17.CameraMaxZoomDistance + (Adornee.Position - v29.Position).Magnitude)
                v43.Enabled = true
                v32 = v44
                refreshCaptions()
            end
        end
    end

    local function rebuildCard() -- line: 318
        -- upvalues: v31 (ref), v32 (ref), mirrorTags (copy), refreshCaptions (copy), ensureCard (copy), Discard (copy)
        mirrorTags()

        if v31 then
            Discard(v31, 0)
            v31 = nil
            v32 = nil
            ensureCard()
        end

        refreshCaptions()
    end

    local t5 = {
        Configuration:GetAttributeChangedSignal("perSecondDisplay"):Connect(refreshCaptions),
        Configuration:GetAttributeChangedSignal("perSecond"):Connect(refreshCaptions),
        Configuration:GetAttributeChangedSignal("displayName"):Connect(refreshCaptions),
        Configuration:GetAttributeChangedSignal("scale"):Connect(refreshCaptions),
        Tool:GetAttributeChangedSignal("Mutations"):Connect(rebuildCard),
        Tool:GetAttributeChangedSignal("BaseMutation"):Connect(rebuildCard),
        Tool.Equipped:Connect(function() -- line: 334
            -- upvalues: refreshCaptions (copy), ensureCard (copy)
            ensureCard()
            refreshCaptions()
        end),
        Tool.Unequipped:Connect(dropRig)
    }

    Tool.Destroying:Connect(function() -- line: 341
        -- upvalues: v30 (ref), v31 (ref), v32 (ref), t5 (copy), Discard (copy)
        for _, v47 in t5 do
            v47:Disconnect()
        end

        if v31 then
            Discard(v31, 0)
            v31 = nil
            v32 = nil
        end

        if v30 then
            Discard(v30, 0)
            v30 = nil
        end
    end)
    Tool.Parent = p17:WaitForChild("Backpack")

    return Tool
end

return t4

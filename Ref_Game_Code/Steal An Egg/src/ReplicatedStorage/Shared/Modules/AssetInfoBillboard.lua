-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local AssetDisplayText = require(ReplicatedStorage.Shared.Modules.AssetDisplayText)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local AssetSounds = require(ReplicatedStorage.Shared.Util.AssetSounds)
local t = require(ReplicatedStorage.Packages.t)
local Data = ReplicatedStorage.Assets.Extra.Data
local v1 = Vector2.new(70, 30)
local t1 = {
    "Mutations",
    "BaseMutation"
}
local t2 = {}

local function dropGradients(p1) -- line: 27
    -- upvalues: SwapGradient (copy)
    SwapGradient(p1, nil)
end

local function showRate(p2, p3) -- line: 31
    -- upvalues: Simple (copy)
    p2.Visible = p3 > 0

    if p3 > 0 then
        p2.Text = ("$%*/s"):format((Simple.FormatCompact(p3)))
    else
        p2.Text = ""
    end
end

local function fitToAdornee(p4, p5) -- line: 36
    -- upvalues: v1 (copy)
    local Size = p4.Size

    p4.Size = UDim2.fromScale(math.min(v1.X, Size.X.Scale * (p5.Size.X / 0.8610000014305115)), (math.min(v1.Y, Size.Y.Scale * (p5.Size.Y / 0.7670000195503235))))
end

local function dressRarity(p6, p7) -- line: 44
    -- upvalues: SwapGradient (copy)
    local Rarity = p6:FindFirstChild("Rarity")

    if Rarity then
        SwapGradient(Rarity, nil)
        Rarity.Visible = false
        Rarity.Text = ""
    end

    local Odds = p6:FindFirstChild("Odds")

    if not Odds then
        return
    end

    SwapGradient(Odds, nil)

    local Rarity2 = p7.Rarity

    if Rarity2 and Rarity2.RarityGradient then
        Rarity2.RarityGradient:Clone().Parent = Odds
    end

    Odds.Text = p7.Rarity.DisplayName
    Odds.Visible = true
end

function t2.LiveMutations(p8, p9) -- line: 70
    -- upvalues: AssetSounds (copy)
    local BaseMutation, BaseMutation2 = AssetSounds.ReadMutationState(p8, "Mutations", "BaseMutation")

    if #BaseMutation > 0 or BaseMutation2 then
        return BaseMutation, BaseMutation2
    end

    if not p9 then
        return {}, nil
    end

    return p9.Mutations or {}, p9.BaseMutation
end

function t2.WriteTitle(p10, p11, p12, p13) -- line: 86
    -- upvalues: AssetDisplayText (copy)
    local DisplayName = p10:FindFirstChild("DisplayName")

    if DisplayName then
        DisplayName.RichText = true
        DisplayName.Text = AssetDisplayText.Compose(p11, p12, p13)
    end

    local Level = p10:FindFirstChild("Level")

    if Level then
        Level.Visible = false
        Level.Text = ""
    end
end

function t2.Range() -- line: 105
    -- upvalues: Data (copy)
    return Data.MaxDistance
end

function t2.SetRate(p14, p15) -- line: 107
    -- upvalues: Simple (copy), t (copy)
    t.strict(t.Instance)(p14)
    t.strict(t.number)(p15)

    local PerSecond = p14:FindFirstChild("PerSecond")

    assert(PerSecond ~= nil and PerSecond:IsA("TextLabel"), "an info card without a PerSecond label")
    PerSecond.Visible = p15 > 0

    if p15 > 0 then
        PerSecond.Text = ("$%*/s"):format((Simple.FormatCompact(p15)))
    else
        PerSecond.Text = ""
    end
end

function t2.Attach(p16, p17, p18, p19) -- line: 117
    -- upvalues: Assets (copy), AssetItem (copy), AssetEarnings (copy), Simple (copy), Personalities (copy), t (copy), Data (copy), v1 (copy), t1 (copy), t2 (copy), dressRarity (copy)
    t.strict(t.string)(p17)

    if p19 ~= nil then
        t.strict(t.number)(p19)
    end

    local CENTER = p16:FindFirstChild("CENTER")

    if not (CENTER and CENTER:IsA("BasePart")) then
        return nil
    end

    if p18 then
        assert(AssetItem.AssetItemData(p18))
    end

    local clone = Data:Clone()
    local v6 = p16:FindFirstChild("AssetInfoBillboardAnchor", true)

    clone.Adornee = if not v6 or not v6:IsA("Attachment") or v6:IsA("Bone") then CENTER else v6

    for _, v7 in t1 do
        local v8 = clone:FindFirstChild(v7)

        if v8 then
            v8:Destroy()
        end
    end

    local Size = clone.Size

    clone.Size = UDim2.fromScale(math.min(v1.X, Size.X.Scale * (CENTER.Size.X / 0.8610000014305115)), (math.min(v1.Y, Size.Y.Scale * (CENTER.Size.Y / 0.7670000195503235))))

    local v12 = Assets.Directory[p17]
    local DisplayName, PerSecond = clone.DisplayName, clone.PerSecond

    dressRarity(clone, v12)

    local v13, v14 = t2.LiveMutations(p16, p18)

    t2.WriteTitle(clone, v12.DisplayName, v13, v14)

    local result = p19

    if p19 == nil then
        local LiveRatePerSecond = AssetEarnings.LiveRatePerSecond
        local v15 = p18 or {
            BaseMutation = nil,
            Scale = 1,
            HasBeenFirstPlaced = true,
            Category = p17,
            Mutations = {},
            Personality = Personalities.Personalities.Normal
        }
        local ok

        ok, result = pcall(LiveRatePerSecond, v15, 0)

        if not ok then
            result = 0
        end
    end

    if PerSecond then
        PerSecond.Visible = result > 0

        if result > 0 then
            PerSecond.Text = ("$%*/s"):format((Simple.FormatCompact(result)))
        else
            PerSecond.Text = ""
        end
    end

    clone.Parent = p16

    return clone, DisplayName, PerSecond
end

return t2

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

local function colorAttribute(p1, p2) -- line: 46
    local Attribute = p1:GetAttribute(p2)

    assert(typeof(Attribute) == "Color3", (("%* is missing %*"):format(p1:GetFullName(), p2)))

    return Attribute
end

local function numberAttribute(p3, p4) -- line: 55
    local Attribute = p3:GetAttribute(p4)

    assert(typeof(Attribute) == "number", (("%* is missing %*"):format(p3:GetFullName(), p4)))

    return Attribute
end

local function stringAttribute(p5, p6) -- line: 64
    local Attribute = p5:GetAttribute(p6)

    assert(typeof(Attribute) == "string", (("%* is missing %*"):format(p5:GetFullName(), p6)))

    return Attribute
end

function t1.New(p7, p8, p9, p10, p11) -- line: 73
    -- upvalues: TweenService (copy), ButtonFX (copy), HoverCard (copy), Numbers (copy), Rarity (copy), SwapGradient (copy), Timer (copy), Trove (copy)
    local clone = p7:Clone()

    clone.Name = p9
    clone.Visible = true
    clone.Parent = p8

    local MasteryLabel, Fill, BGDecor = clone.MasteryLabel, clone.Fill, clone.BGDecor
    local v7 = clone:FindFirstChild("AccentStroke") or clone.StrokeHolder.AccentStroke
    local UIShadow = clone:FindFirstChildOfClass("UIShadow")
    local Claim = clone.Claim

    Claim.Active = true
    Claim.Selectable = true
    Claim.Interactable = true

    local UIGradient = Claim:FindFirstChildOfClass("UIGradient")
    local UIStroke, UIStrokeClr, Price = Claim.UIStroke, Claim.UIStrokeClr, Claim.Price
    local RewardTitle, RewardHolder = clone.RewardTitle, clone.RewardHolder
    local v8 = RewardHolder:FindFirstChild("Template") or RewardHolder.Chip
    local clone2 = v8:Clone()
    local Icon, Amount = clone2.Icon, clone2.Amount
    local ItemName = clone2:FindFirstChild("ItemName")
    local CompletedCheckmark = clone2.CompletedCheckmark
    local v9 = "Locked"
    local v10 = false
    local HoverTitle, HoverDescription
    local v11 = Trove.new()

    assert(UIShadow ~= nil, (("%* is missing UIShadow"):format((clone:GetFullName()))))
    assert(UIGradient ~= nil, (("%* is missing UIGradient"):format((Claim:GetFullName()))))
    v8.Visible = false
    clone2.Name = "Reward"
    clone2.Visible = true
    clone2.Parent = RewardHolder

    local function refreshIcon(p12) -- line: 127
        -- upvalues: Icon (copy), v11 (copy), TweenService (copy), Timer (copy)
        v11:Clean()
        Icon.Image = p12.Icon
        Icon.ImageTransparency = 0

        local CycleIcons = p12.CycleIcons

        if CycleIcons ~= nil and not (#CycleIcons <= 1) then
            local clone = Icon:Clone()

            clone.Name = "IncomingIcon"
            clone.Active = false
            clone.Selectable = false
            clone.ImageTransparency = 1
            clone.Parent = Icon.Parent
            v11:Add(clone)

            local v16 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local t2 = {
                [Icon] = v11:Add(TweenService:Create(Icon, v16, {
                    ImageTransparency = 0
                })),
                [clone] = v11:Add(TweenService:Create(clone, v16, {
                    ImageTransparency = 0
                }))
            }
            local t3 = {
                [Icon] = v11:Add(TweenService:Create(Icon, v16, {
                    ImageTransparency = 1
                })),
                [clone] = v11:Add(TweenService:Create(clone, v16, {
                    ImageTransparency = 1
                }))
            }
            local v17 = Icon
            local v18 = clone
            local n1 = 1
            local v19 = v11:Add(Timer.new(1.35))

            v11:Connect(v19.Tick, function() -- line: 172
                -- upvalues: CycleIcons (copy), t2 (copy), t3 (copy), v17 (ref), v18 (ref), n1 (ref)
                n1 = n1 % #CycleIcons + 1
                v18.Image = CycleIcons[n1]
                t3[v17]:Play()
                t2[v18]:Play()

                local v22 = v18
                local v23 = v17

                v17 = v22
                v18 = v23
            end)
            v19:Start()
        end
    end

    local function applyState(p13) -- line: 182
        -- upvalues: p11 (copy), clone (copy), Fill (copy), BGDecor (copy), UIShadow (copy), Claim (copy), UIGradient (copy), UIStroke (copy), UIStrokeClr (copy), Price (copy), CompletedCheckmark (copy), v9 (ref), v10 (ref), v7 (copy)
        v9 = p13

        local v24 = if p13 == "Claimable" then "Claimable" else "Locked"

        if not p11 then
            local v25 = v24 .. "FillColor"
            local Attribute = clone:GetAttribute(v25)

            assert(typeof(Attribute) == "Color3", (("%* is missing %*"):format(clone:GetFullName(), v25)))
            Fill.BackgroundColor3 = Attribute

            local v28 = v24 .. "ShadowColor"
            local Attribute2 = clone:GetAttribute(v28)

            assert(typeof(Attribute2) == "Color3", (("%* is missing %*"):format(clone:GetFullName(), v28)))
            UIShadow.Color = Attribute2

            local v31 = v24 .. "AccentColor"
            local Attribute3 = clone:GetAttribute(v31)

            assert(typeof(Attribute3) == "Color3", (("%* is missing %*"):format(clone:GetFullName(), v31)))
            v7.Color = Attribute3

            local v34 = v24 .. "DecorColor"
            local Attribute4 = clone:GetAttribute(v34)

            assert(typeof(Attribute4) == "Color3", (("%* is missing %*"):format(clone:GetFullName(), v34)))
            BGDecor.ImageColor3 = Attribute4

            local v37 = v24 .. "DecorTransparency"
            local Attribute5 = clone:GetAttribute(v37)

            assert(typeof(Attribute5) == "number", (("%* is missing %*"):format(clone:GetFullName(), v37)))
            BGDecor.ImageTransparency = Attribute5
        end

        local new = ColorSequence.new
        local v40 = v24 .. "ColorStart"
        local Attribute = Claim:GetAttribute(v40)

        assert(typeof(Attribute) == "Color3", (("%* is missing %*"):format(Claim:GetFullName(), v40)))

        local v43 = v24 .. "ColorEnd"
        local Attribute2 = Claim:GetAttribute(v43)

        assert(typeof(Attribute2) == "Color3", (("%* is missing %*"):format(Claim:GetFullName(), v43)))
        UIGradient.Color = new(Attribute, Attribute2)

        local v46 = v24 .. "BorderColor"
        local Attribute3 = Claim:GetAttribute(v46)

        assert(typeof(Attribute3) == "Color3", (("%* is missing %*"):format(Claim:GetFullName(), v46)))
        UIStroke.Color = Attribute3

        local v49 = v24 .. "HighlightColor"
        local Attribute4 = Claim:GetAttribute(v49)

        assert(typeof(Attribute4) == "Color3", (("%* is missing %*"):format(Claim:GetFullName(), v49)))
        UIStrokeClr.Color = Attribute4

        local Attribute5

        if v10 then
            Attribute5 = "Claiming..."
        elseif p13 == "Claimed" then
            local ClaimedText = Claim:GetAttribute("ClaimedText")

            Attribute5 = ClaimedText
            assert(typeof(ClaimedText) == "string", (("%* is missing ClaimedText"):format((Claim:GetFullName()))))
        elseif p13 == "Locked" then
            Attribute5 = "Locked"
        else
            local v54 = v24 .. "Text"

            Attribute5 = Claim:GetAttribute(v54)
            assert(typeof(Attribute5) == "string", (("%* is missing %*"):format(Claim:GetFullName(), v54)))
        end

        Price.Text = Attribute5
        CompletedCheckmark.Visible = p13 == "Claimed"
        Claim.AutoButtonColor = p13 == "Claimable" and not v10
    end

    local t4
    local v58 = ButtonFX(Claim, 1.05, function() -- line: 218
        -- upvalues: p9 (copy), p10 (copy), v9 (ref), v10 (ref), t4 (ref)
        if v9 == "Claimable" and not v10 then
            p10(p9, t4)
        end
    end)

    Icon.Active = true

    local v59 = HoverCard.Attach(Icon, function() -- line: 224
        -- upvalues: HoverTitle (ref), HoverDescription (ref)
        return if HoverTitle ~= nil and HoverDescription ~= nil then {
            {
                kind = "heading",
                text = HoverTitle
            },
            {
                kind = "rule"
            },
            {
                kind = "heading",
                text = HoverDescription
            }
        } else nil
    end)

    t4 = {
        Button = Claim,
        Refresh = function(p14, p15, p16, p17) -- Refresh | line: 237
            -- upvalues: clone (copy), MasteryLabel (copy), RewardTitle (copy), Amount (copy), ItemName (copy), HoverTitle (ref), HoverDescription (ref), refreshIcon (copy), applyState (copy), Numbers (copy), Rarity (copy), SwapGradient (copy)
            clone.LayoutOrder = p17
            MasteryLabel.Text = Numbers.AddCommas(p14)
            RewardTitle.Text = p15.Title

            if ItemName then
                ItemName.Text = p15.Label or p15.Rarity or p15.Title

                local v60 = if p15.Rarity then Rarity.Get(p15.Rarity) else nil

                SwapGradient(ItemName, if v60 then v60.RarityGradient else nil)
            end

            refreshIcon(p15)
            Amount.Text = p15.Amount
            HoverTitle = p15.HoverTitle
            HoverDescription = p15.HoverDescription
            applyState(p16)
        end,
        SetVisible = function(p18) -- SetVisible | line: 257
            -- upvalues: clone (copy)
            clone.Visible = p18
        end,
        SetPending = function(p19) -- SetPending | line: 260
            -- upvalues: v9 (ref), v10 (ref), applyState (copy)
            v10 = p19
            applyState(v9)
        end,
        Destroy = function() -- Destroy | line: 264
            -- upvalues: clone (copy), v11 (copy), v58 (copy), v59 (copy)
            v58()
            v59()
            v11:Destroy()
            clone:Destroy()
        end
    }

    return t4
end

return table.freeze(t1)

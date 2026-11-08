-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(script.Parent.Types.Interface)

local v1 = Color3.fromRGB(60, 255, 0)
local v2 = Color3.fromRGB(136, 255, 0)
local v3 = Color3.fromRGB(190, 255, 180)
local t1 = {}
local Color, Color2

local function applyClaimableLook(p1, p2) -- line: 31
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), Color (ref), Color2 (ref)
    local UIGradient = p1:FindFirstChildOfClass("UIGradient")

    if UIGradient ~= nil then
        if Color == nil then
            Color = UIGradient.Color
        end

        if p2 then
            local ClaimableColorStart = p1:GetAttribute("ClaimableColorStart")
            local ClaimableColorEnd = p1:GetAttribute("ClaimableColorEnd")

            UIGradient.Color = ColorSequence.new(ClaimableColorStart or v1, ClaimableColorEnd or v2)
        else
            UIGradient.Color = Color
        end
    end

    local UIStrokeClr = p1:FindFirstChild("UIStrokeClr")

    if UIStrokeClr ~= nil and UIStrokeClr:IsA("UIStroke") then
        if Color2 == nil then
            Color2 = UIStrokeClr.Color
        end

        if p2 then
            UIStrokeClr.Color = p1:GetAttribute("ClaimableStrokeColor") or v3
        else
            UIStrokeClr.Color = Color2
        end
    end
end

function t1.Render(p3, p4, p5, p6) -- line: 68
    -- upvalues: t (copy), AssetItems (copy), Simple (copy), Color (ref), Color2 (ref), applyClaimableLook (copy)
    t.strict(t.boolean)(p5)
    t.strict(t.boolean)(p6)

    local Claim = p3.Claim

    Claim.Active = p6

    if p4 ~= nil then
        p3.Rewards.SpeedReward.TextLabel.Text = "+" .. Simple.FormatCompact(AssetItems.IndexSpeedReward(p4.Category), ".#")
        p3.Rewards.MoneyReward.TextLabel.Text = "$" .. Simple.FormatCompact(AssetItems.IndexMoneyReward(p4.Category), ".#")
        Claim.TextLabel.Text = p5 and "CLAIMED!" or "CLAIM!"
        applyClaimableLook(Claim, p6)
    else
        Claim.TextLabel.Text = "CLAIM!"

        local UIGradient = Claim:FindFirstChildOfClass("UIGradient")

        if UIGradient ~= nil then
            if Color == nil then
                Color = UIGradient.Color
            end

            UIGradient.Color = Color
        end

        local UIStrokeClr = Claim:FindFirstChild("UIStrokeClr")

        if UIStrokeClr ~= nil then
            if not UIStrokeClr:IsA("UIStroke") then
                return
            end

            if Color2 == nil then
                Color2 = UIStrokeClr.Color
            end

            UIStrokeClr.Color = Color2
        end
    end
end

return t1

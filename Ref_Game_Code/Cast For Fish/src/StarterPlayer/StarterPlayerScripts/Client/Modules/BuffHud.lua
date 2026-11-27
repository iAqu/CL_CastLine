-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Parent = script.Parent
local Buffs = require(Shared.Data.Buffs)
local UIKit = require(Parent.UIKit)
local HUD = require(Parent.HUD)
local BannerDodge = require(Parent.BannerDodge)
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local LocalPlayer = Players.LocalPlayer
local v2 = fromRGB(220, 235, 255)
local v3 = fromRGB(170, 110, 60)
local v4 = fromRGB(255, 255, 255)
local t1 = {
    luck = "rbxassetid://110443674312508",
    cash = "rbxassetid://71045032151739",
    strength = "rbxassetid://125437131476533",
    cosmic = "rbxassetid://90276310321980"
}
local n1 = 0

local function activeCount() -- line: 37
    -- upvalues: Buffs (copy), LocalPlayer (copy)
    local n2 = 0

    for _, v5 in Buffs.List do
        if Buffs.Left(LocalPlayer, v5.id) > 0 then
            n2 += 1
        end
    end

    return n2
end

local function placeTipBubble(p1) -- line: 47
    -- upvalues: BannerDodge (copy), LocalPlayer (copy)
    local HUD = LocalPlayer.PlayerGui:FindFirstChild("HUD")
    local TipBubble = HUD and HUD:FindFirstChild("TipBubble")

    if not TipBubble then
        return
    end

    local v6 = (if p1 then 30 else 0) + 88
    local v7 = BannerDodge.Row(BannerDodge)
    local v8 = v7 and v7:FindFirstAncestorWhichIsA("ScreenGui")

    if v8 and not v8.Enabled then
        v7 = nil
    end

    local Y = TipBubble.AbsoluteSize.Y

    if v7 and Y > 0 then
        local v9 = TipBubble.Size.Y.Offset / Y
        local v10 = TipBubble.AbsolutePosition.Y - (TipBubble.Position.Y.Offset - v6) / v9
        local _, _, v11 = BannerDodge.RowBounds(BannerDodge, v7)

        if v10 < v11 + BannerDodge.GAP then
            v6 += math.ceil((v11 + BannerDodge.GAP - v10) * v9)
        end
    end

    if TipBubble.Position.Y.Offset ~= v6 then
        TipBubble.Position = UDim2.new(0.5, 0, 0, v6)
    end
end

local t2 = {
    BannerUp = false,
    Count = 0,
    Hidden = nil
}

function t2.Bottle(p2, p3, p4, p5) -- line: 78
    -- upvalues: UIKit (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy)
    p5 = p5 or 3

    local v14 = UIKit.frame(p2, {
        Name = "Bottle",
        Transparency = 1,
        Size = UDim2.fromOffset(p4, p4),
        ZIndex = p5
    })
    local v15 = t1[p3.id]

    if v15 then
        UIKit.image(v14, v15, {
            Size = UDim2.fromScale(1.18, 1.18),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v1,
            ZIndex = p5
        })
    else
        local v17 = UIKit.frame(v14, {
            Name = "Body",
            Stroke = 2,
            Size = UDim2.fromScale(0.78, 0.62),
            Position = UDim2.fromScale(0.5, 0.96),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = p3.Color,
            Color2 = p3.Color2,
            Corner = math.floor(p4 * 0.3),
            ZIndex = p5
        })

        UIKit.frame(v17, {
            Name = "Shine",
            Transparency = 0.35,
            Corner = 4,
            Size = UDim2.fromScale(0.22, 0.4),
            Position = UDim2.fromScale(0.2, 0.18),
            Color = v4,
            ZIndex = p5 + 1
        })
        UIKit.frame(v14, {
            Name = "Neck",
            Transparency = 0.15,
            Stroke = 2,
            Size = UDim2.fromScale(0.32, 0.26),
            Position = UDim2.fromScale(0.5, 0.38),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = v2,
            ZIndex = p5
        })
        UIKit.frame(v14, {
            Name = "Cork",
            Corner = 3,
            Stroke = 2,
            Size = UDim2.fromScale(0.4, 0.16),
            Position = UDim2.fromScale(0.5, 0.16),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = v3,
            ZIndex = p5
        })
    end

    return v14
end

function t2.Init() -- line: 93
    -- upvalues: RunService (copy), HUD (copy), n1 (ref), activeCount (copy), placeTipBubble (copy), t2 (copy)
    RunService.Heartbeat:Connect(function(p6) -- line: 94
        -- upvalues: HUD (copy), n1 (ref), activeCount (copy), placeTipBubble (copy), t2 (copy)
        n1 += p6

        if n1 < 0.2 then
            return
        end

        n1 = 0
        t2.Count = if HUD.GetMode() == "cutscene" or t2.Hidden ~= nil and t2.Hidden() == true then 0 else activeCount()
        placeTipBubble(t2.BannerUp)
    end)
end

return t2

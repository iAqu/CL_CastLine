-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    W = 212
}

local function buildTab(p1, p2, p3, p4) -- line: 20
    -- upvalues: UIUtil (copy), Kit (copy), Fx (copy), t1 (copy)
    local v1 = Kit.button(p1, "", p2.Color, {
        ZIndex = 3,
        Name = p2.Name,
        Position = UDim2.fromOffset(0, (p3 - 1) * 108),
        Size = UDim2.fromOffset(t1.W, 98)
    }, function() -- line: 26
        -- upvalues: p2 (copy), p4 (copy)
        p4(p2.Name)
    end)

    v1.Label:Destroy()
    v1.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v1.UIStroke.Thickness = 5
    UIUtil.centre(v1)

    local Position = v1.Position
    local v2 = Kit.frame(v1, {
        Name = "Notch",
        Rotation = 45,
        ZIndex = 2,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 2, 0.5, 0),
        Size = UDim2.fromOffset(30, 30)
    })

    Kit.corner(v2, 4)
    Kit.stroke(v2, 4, Color3.new(1, 1, 1))
    Kit.studs(v1, 0.7, 26, 12).ZIndex = 3

    local ImageLabel

    if p2.Image then
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p2.Image
        ImageLabel.ScaleType = Enum.ScaleType.Fit
    else
        ImageLabel = Instance.new("TextLabel")
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.TextScaled = true
        ImageLabel.Text = p2.Emoji
    end

    ImageLabel.Name = "Icon"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
    ImageLabel.Position = UDim2.new(0.5, 0, 0, 4)
    ImageLabel.Size = UDim2.fromOffset(60, 60)
    ImageLabel.Rotation = -6
    ImageLabel.ZIndex = 5
    ImageLabel.Parent = v1
    Kit.text(v1, string.upper(p2.Name), {
        Name = "Name",
        TextScaled = false,
        TextSize = 27,
        ZIndex = 5,
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, -12, 0, 30)
    })
    Fx.bob(ImageLabel, 3, 2.2, p3)

    local v3 = Kit.frame(v1, {
        Name = "Alert",
        ZIndex = 7,
        Visible = false,
        BackgroundColor3 = Color3.fromRGB(235, 55, 55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 6, 0, 8),
        Size = UDim2.fromOffset(46, 46)
    })

    Kit.corner(v3, 23)
    Kit.stroke(v3, 4)
    Kit.text(v3, "!", {
        ZIndex = 8,
        Size = UDim2.fromScale(1, 1)
    })
    Fx.wiggle(v3, 14, 1.4, p3)

    return v1, Position
end

local function buildGift(p5, p6, p7, p8) -- line: 98
    -- upvalues: Remotes (copy), Kit (copy), Style (copy), Fx (copy), LocalPlayer (copy)
    local v4 = Style.card(p5, Style.SEAFOAM, {
        Name = "Gift",
        ZIndex = 3,
        Position = UDim2.fromOffset(0, p6),
        Size = UDim2.new(1, 0, 1, -p6)
    })

    Style.polish(v4)

    local v5 = Style.bubble(v4, "🎁", {
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 8),
        Size = UDim2.fromOffset(76, 76)
    })

    Fx.bob(v5, 4, 3)
    Kit.text(v4, "FREE GIFT", {
        TextScaled = false,
        TextSize = 28,
        ZIndex = 4,
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 86),
        Size = UDim2.new(1, -24, 0, 32)
    })

    local v6 = Kit.text(v4, "", {
        Name = "Wait",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -30, 0, 38),
        TextColor3 = Style.YELLOW
    })
    local v7 = Kit.button(v4, "CLAIM!", Style.BUY, {
        Name = "Claim",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -12),
        Size = UDim2.new(1, -28, 0, 62)
    }, function() -- line: 136
        -- upvalues: Remotes (copy)
        Remotes.ClaimFreeGift:FireServer()
    end)

    v7.Label.ZIndex = 6
    Style.dress(v7, 12)
    Fx.shine(v7, 2.2)
    Fx.ping(v7, Style.YELLOW, 1.4, 12)
    p7(function() -- line: 143
        -- upvalues: p8 (copy), v6 (copy), v7 (copy), Style (copy), LocalPlayer (copy)
        local v8 = (LocalPlayer:GetAttribute("FreeGiftReady") or 1e999) - workspace:GetServerTimeNow()

        v7.Visible = v8 <= 0
        v6.Visible = v8 > 0 and v8 < 1e999
        v6.Text = "⏱ " .. Style.clock(v8)
        p8.Visible = v8 <= 0
    end)
end

function t1.build(p9, p10, p11, p12, p13, p14) -- line: 155
    -- upvalues: Kit (copy), t1 (copy), buildTab (copy), buildGift (copy)
    local v10 = Kit.frame(p9, {
        Name = "Tabs",
        BackgroundTransparency = 1,
        ZIndex = 3,
        Position = UDim2.fromOffset(p10, p11),
        Size = UDim2.new(0, t1.W, 1, -p11 - 24)
    })
    local t2 = {}
    local t3 = {}

    for v11, v12 in p12 do
        local Name, Name2 = v12.Name, v12.Name
        local v13, v14 = buildTab(v10, v12, v11, p14)

        t2[Name] = v13
        t3[Name2] = v14
    end

    buildGift(v10, #p12 * 108 + 8, p13, t2[p12[1].Name].Alert)

    return t2, t3
end

return t1

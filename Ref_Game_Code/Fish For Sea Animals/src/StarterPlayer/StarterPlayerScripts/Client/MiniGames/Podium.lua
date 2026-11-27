-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local Kit = require(script.Parent.Kit)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {}
local t2 = {
    {
        height = 210,
        color = Color3.fromRGB(255, 200, 40)
    },
    {
        height = 158,
        color = Color3.fromRGB(205, 215, 230)
    },
    {
        height = 116,
        color = Color3.fromRGB(215, 130, 60)
    }
}
local t3 = {
    165, 20, 310
}
local v1 = Color3.fromRGB(34, 36, 52)
local v2 = Color3.fromRGB(120, 255, 110)

local function headshot(p1) -- line: 21
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p1))
end

local function avatar(p2, p3, p4, p5, p6) -- line: 25
    -- upvalues: Kit (copy), v1 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundColor3 = v1
    ImageLabel.Size = UDim2.fromOffset(p4, p4)

    if p3 then
        ImageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p3.UserId)
    else
        ImageLabel.Image = ""
    end

    ImageLabel.ScaleType = Enum.ScaleType.Fit

    for v3, v4 in p6 do
        ImageLabel[v3] = v4
    end

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ImageLabel
    Kit.stroke(ImageLabel, 4, p5)

    if not p3 then
        Kit.text(ImageLabel, "?", {
            Size = UDim2.fromScale(1, 1),
            TextColor3 = Color3.fromRGB(120, 125, 150)
        })
    end

    ImageLabel.Parent = p2

    return ImageLabel
end

local function step(p7, p8, p9, p10) -- line: 46
    -- upvalues: Players (copy), Kit (copy), UIUtil (copy), t2 (copy), t3 (copy), v2 (copy), avatar (copy)
    local v5 = t2[p8]
    local v6 = Kit.frame(p7, {
        BackgroundTransparency = 1,
        Name = "Place" .. p8,
        Position = UDim2.fromOffset(t3[p8], 0),
        Size = UDim2.new(0, 135, 1, 0)
    })
    local v7 = Kit.frame(v6, {
        ClipsDescendants = true,
        BackgroundColor3 = v5.color,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromOffset(0, 548),
        Size = UDim2.fromOffset(135, 0)
    })

    Kit.corner(v7, 10)
    Kit.stroke(v7, 4)
    Kit.shade(v7, 0.7)
    Kit.studs(v7, 0.35, 40, 10)
    Kit.text(v7, tostring(p8), {
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 10),
        Size = UDim2.fromOffset(80, 70)
    })

    local v8 = 548 - v5.height
    local v9 = p9 and p9.UserId == Players.LocalPlayer.UserId
    local v11 = avatar(v6, p9, if p8 == 1 then 96 else 82, v5.color, {
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, v8 - 70)
    })

    if p8 == 1 then
        Kit.text(v11, "👑", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 0, 10),
            Size = UDim2.fromOffset(60, 50)
        }).UIStroke.Enabled = false
    end

    local v13 = Kit.text(v6, if p9 then p9.Name else "—", {
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, v8 - 38),
        Size = UDim2.fromOffset(155, 28),
        TextColor3 = if v9 then v2 else Color3.new(1, 1, 1)
    })
    local v15 = Kit.text(v6, if p9 then tostring(p9.Score) else "", {
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 0, v8 - 6),
        Size = UDim2.fromOffset(135, 30),
        TextColor3 = v5.color:Lerp(Color3.new(1, 1, 1), 0.3)
    })

    task.delay(p10, function() -- line: 100
        -- upvalues: p8 (copy), p9 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v11 (copy), v13 (copy), v15 (copy), Kit (copy), UIUtil (copy)
        UIUtil.tween(v7, 0.45, {
            Size = UDim2.fromOffset(135, v5.height)
        }, Enum.EasingStyle.Back)
        UIUtil.sound("Pop", 0.5, (4 - p8) * 0.15 + 0.8)
        task.wait(0.35)

        if v6.Parent then
            for _, v16 in { v11, v13, v15 } do
                v16.Visible = true
                UIUtil.pop(v16, 0.3)
            end

            if p8 == 1 and p9 then
                Kit.burst(v6, Vector2.new(67.5, v8 - 110), v5.color, 22, 120)
                UIUtil.sound("GoodCast", 0.5)
            end
        end
    end)
end

local function list(p11, p12) -- line: 119
    -- upvalues: Players (copy), Kit (copy), UIUtil (copy), v1 (copy), v2 (copy), avatar (copy)
    local v17 = Kit.frame(p11, {
        Name = "Ranks",
        BackgroundTransparency = 0.2,
        BackgroundColor3 = v1,
        Position = UDim2.fromOffset(476, 20),
        Size = UDim2.fromOffset(292, 432)
    })

    Kit.corner(v17, 12)
    Kit.stroke(v17, 4)

    for i = 4, 10 do
        local v18 = p12[i]
        local v19 = v18 and v18.UserId == Players.LocalPlayer.UserId
        local v20 = Kit.frame(v17, {
            BackgroundTransparency = 0.92,
            BackgroundColor3 = Color3.new(1, 1, 1),
            Position = UDim2.fromOffset(10, (i - 4) * 59 + 10),
            Size = UDim2.new(1, -20, 0, 52)
        })

        Kit.corner(v20, 8)

        if v19 then
            Kit.stroke(v20, 3, v2)
        end

        Kit.text(v20, ("#%*"):format(i), {
            Position = UDim2.fromOffset(6, 10),
            Size = UDim2.fromOffset(44, 32),
            TextColor3 = Color3.fromRGB(190, 195, 220)
        })
        avatar(v20, v18, 40, Color3.fromRGB(70, 75, 100), {
            Position = UDim2.fromOffset(54, 6)
        })
        Kit.text(v20, if v18 then v18.Name else "—", {
            Position = UDim2.fromOffset(102, 12),
            Size = UDim2.new(1, -190, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = if v19 then v2 else Color3.new(1, 1, 1)
        })
        Kit.text(v20, if v18 then tostring(v18.Score) else "", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -8, 0, 12),
            Size = UDim2.fromOffset(80, 28),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3.fromRGB(255, 225, 90)
        })
        v20.Visible = false
        task.delay((i - 4) * 0.06 + 0.9, function() -- line: 163
            -- upvalues: v20 (copy), UIUtil (copy)
            v20.Visible = true
            UIUtil.pop(v20, 0.6)
        end)
    end
end

function t1.build(p13, p14, p15, p16) -- line: 171
    -- upvalues: Kit (copy), step (copy), list (copy)
    local v23 = Kit.frame(p13, {
        Name = "Leaderboard",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local v24 = Kit.frame(v23, {
        BackgroundTransparency = 0.75,
        BackgroundColor3 = p16,
        Position = UDim2.fromOffset(12, 20),
        Size = UDim2.fromOffset(450, 528)
    })

    Kit.corner(v24, 14)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new(0.6, 0)
    UIGradient.Parent = v24

    for v25, v26 in { 0.05, 0.35, 0.6 } do
        step(v23, v25, p14[v25], v26)
    end

    list(v23, p14)

    local v27 = Kit.frame(v23, {
        BackgroundColor3 = Color3.fromRGB(70, 160, 70),
        Position = UDim2.fromOffset(476, 466),
        Size = UDim2.fromOffset(292, 82)
    })

    Kit.corner(v27, 12)
    Kit.stroke(v27, 4)
    Kit.shade(v27, 0.7)
    Kit.text(v27, "YOUR BEST", {
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.new(1, -24, 0, 26)
    })
    Kit.text(v27, tostring(p15), {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(12, 36),
        Size = UDim2.new(1, -24, 0, 38),
        TextColor3 = Color3.fromRGB(255, 230, 90)
    })

    return v23
end

return t1

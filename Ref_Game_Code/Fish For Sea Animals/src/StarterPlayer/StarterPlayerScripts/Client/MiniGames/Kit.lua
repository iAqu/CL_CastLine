-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Robux = require(script.Parent.Parent.Shop.Robux)
local t1 = {
    INK = Color3.fromRGB(22, 22, 30),
    DARK = Color3.fromRGB(24, 26, 36),
    frame = function(p1, p2) -- frame | line: 15
        local Frame = Instance.new("Frame")

        Frame.BorderSizePixel = 0

        for v1, v2 in p2 do
            Frame[v1] = v2
        end

        Frame.Parent = p1

        return Frame
    end,
    corner = function(p3, p4) -- corner | line: 25
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, p4)
        UICorner.Parent = p3

        return UICorner
    end
}

function t1.stroke(p5, p6, p7) -- line: 32
    -- upvalues: t1 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p6
    UIStroke.Color = p7 or t1.INK
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round

    if p5:IsA("TextLabel") or p5:IsA("TextButton") then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    else
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    UIStroke.Parent = p5

    return UIStroke
end

function t1.shade(p8, p9) -- line: 43
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    p9 = p9 or 0.75
    UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(p9, p9, p9))
    UIGradient.Parent = p8

    return UIGradient
end

function t1.text(p10, p11, p12) -- line: 52
    -- upvalues: Config (copy), t1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Text = p11

    for v4, v5 in p12 do
        if v4 ~= "StrokeThickness" then
            TextLabel[v4] = v5
        end
    end

    t1.stroke(TextLabel, p12.StrokeThickness or 3)
    TextLabel.Parent = p10

    return TextLabel
end

function t1.studs(p13, p14, p15, p16) -- line: 70
    -- upvalues: Config (copy), t1 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Studs"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = Config.Icons.Studs
    ImageLabel.ImageTransparency = (p14 or 0.45) * 0.4
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset((p15 or 48) * 8, (p15 or 48) * 8)
    ImageLabel.ZIndex = 0
    ImageLabel.Interactable = false

    if p16 then
        t1.corner(ImageLabel, p16)
    end

    ImageLabel.Parent = p13

    return ImageLabel
end

function t1.button(p17, p18, p19, p20, p21) -- line: 89
    -- upvalues: UIUtil (copy), t1 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = p19
    TextButton.BorderSizePixel = 0

    for v6, v7 in p20 do
        TextButton[v6] = v7
    end

    t1.corner(TextButton, 12)
    t1.stroke(TextButton, 4)
    t1.shade(TextButton)
    t1.text(TextButton, p18, {
        Name = "Label",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromScale(0.84, 0.6)
    })
    TextButton.Parent = p17
    UIUtil.bindButton(TextButton, p21)

    return TextButton
end

function t1.block(p22, p23) -- line: 113
    -- upvalues: t1 (copy)
    local v8 = t1.frame(p22, {
        Name = "Block",
        BackgroundColor3 = p23,
        Size = UDim2.fromScale(1, 1)
    })

    t1.corner(v8, 6)
    t1.stroke(v8, 2, Color3.new(0, 0, 0)).Transparency = 0.45
    t1.shade(v8, 0.7)
    t1.frame(v8, {
        Name = "Shine",
        BackgroundTransparency = 0.55,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.fromScale(0.14, 0.1),
        Size = UDim2.fromScale(0.72, 0.16)
    }).ZIndex = 2

    return v8
end

function t1.burst(p24, p25, p26, p27, p28) -- line: 133
    -- upvalues: UIUtil (copy), t1 (copy)
    p27 = p27 or 10
    p28 = p28 or 70

    for _ = 1, p27 do
        local v11 = math.random(8, 16)
        local v12 = t1.frame(p24, {
            ZIndex = 40,
            BackgroundColor3 = if math.random() < 0.25 then Color3.new(1, 1, 1) else p26,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(p25.X, p25.Y),
            Size = UDim2.fromOffset(v11, v11),
            Rotation = math.random(0, 90)
        })

        t1.corner(v12, 3)

        local v13 = math.random() * 3.141592653589793 * 2
        local v14 = p28 * (0.45 + math.random() * 0.55)
        local v15 = p25 + Vector2.new(math.cos(v13) * v14, math.sin(v13) * v14 * 0.8 + p28 * 0.35)
        local v16 = 0.45 + math.random() * 0.3

        UIUtil.tween(v12, v16, {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(v15.X, v15.Y),
            Rotation = v12.Rotation + math.random(-260, 260),
            Size = UDim2.fromOffset(v11 * 0.3, v11 * 0.3)
        }, Enum.EasingStyle.Quad)
        task.delay(v16, function() -- line: 157
            -- upvalues: v12 (copy)
            v12:Destroy()
        end)
    end
end

function t1.ring(p29, p30, p31, p32) -- line: 164
    -- upvalues: UIUtil (copy), t1 (copy)
    local v17 = t1.frame(p29, {
        BackgroundTransparency = 1,
        ZIndex = 39,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(p30.X, p30.Y),
        Size = UDim2.fromOffset(10, 10)
    })
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v17

    local v18 = t1.stroke(v17, 5, p31)

    p32 = p32 or 120
    UIUtil.tween(v17, 0.45, {
        Size = UDim2.fromOffset(p32, p32)
    }, Enum.EasingStyle.Quad)
    UIUtil.tween(v18, 0.45, {
        Transparency = 1,
        Thickness = 1
    })
    task.delay(0.45, function() -- line: 179
        -- upvalues: v17 (copy)
        v17:Destroy()
    end)
end

function t1.floatText(p33, p34, p35, p36, p37) -- line: 185
    -- upvalues: UIUtil (copy), t1 (copy)
    p37 = p37 or 40

    local v21 = t1.text(p33, p35, {
        ZIndex = 45,
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(p34.X, p34.Y),
        Size = UDim2.fromOffset(p37 * 8, p37),
        TextColor3 = p36 or Color3.fromRGB(255, 230, 90)
    })

    UIUtil.pop(v21, 0.3)
    UIUtil.tween(v21, 0.9, {
        Position = UDim2.fromOffset(p34.X, p34.Y - p37 * 1.6)
    }, Enum.EasingStyle.Quad)
    task.delay(0.5, function() -- line: 197
        -- upvalues: v21 (copy), UIUtil (copy)
        UIUtil.tween(v21, 0.4, {
            TextTransparency = 1
        })
        UIUtil.tween(v21.UIStroke, 0.4, {
            Transparency = 1
        })
    end)
    task.delay(0.95, function() -- line: 201
        -- upvalues: v21 (copy)
        v21:Destroy()
    end)

    return v21
end

function t1.flash(p38, p39, p40) -- line: 208
    -- upvalues: UIUtil (copy), t1 (copy)
    local v22 = t1.frame(p38, {
        ZIndex = 38,
        Interactable = false,
        BackgroundColor3 = p39 or Color3.new(1, 1, 1),
        BackgroundTransparency = 1 - (p40 or 0.5),
        Size = UDim2.fromScale(1, 1)
    })
    local UICorner = p38:FindFirstChildOfClass("UICorner")

    if UICorner then
        UICorner:Clone().Parent = v22
    end

    UIUtil.tween(v22, 0.3, {
        BackgroundTransparency = 1
    })
    task.delay(0.3, function() -- line: 221
        -- upvalues: v22 (copy)
        v22:Destroy()
    end)
end

function t1.shake(p41, p42, p43) -- line: 227
    local v23 = p41:GetAttribute("ShakeBase") or p41.Position

    p41:SetAttribute("ShakeBase", v23)

    local v24 = p42 or 6
    local v25 = p43 or 0.25
    local elapsed = os.clock()

    task.spawn(function() -- line: 232
        -- upvalues: p41 (copy), v23 (copy), v24 (copy), v25 (copy), elapsed (copy)
        while os.clock() - elapsed < v25 and p41.Parent do
            local v26 = 1 - (os.clock() - elapsed) / v25

            p41.Position = v23 + UDim2.fromOffset(math.random(-10, 10) / 10 * v24 * v26, math.random(-10, 10) / 10 * v24 * v26)
            task.wait()
        end

        p41.Position = v23
        p41:SetAttribute("ShakeBase", nil)
    end)
end

function t1.overlay(p44, p45, p46, p47, p48, p49) -- line: 245
    -- upvalues: UIUtil (copy), Robux (copy), t1 (copy)
    local v27 = t1.frame(p44, {
        Name = "Overlay",
        BackgroundTransparency = 0.35,
        ZIndex = 20,
        Active = true,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 1)
    })

    t1.corner(v27, 8)

    local v28 = t1.frame(v27, {
        ZIndex = 21,
        BackgroundColor3 = Color3.fromRGB(44, 44, 54),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(420, p49 and 350 or 260)
    })

    t1.corner(v28, 14)
    t1.stroke(v28, 5)
    t1.studs(v28, 0.4, 48, 14).ZIndex = 21
    t1.text(v28, p45, {
        ZIndex = 22,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.new(1, -40, 0, 60)
    })
    t1.text(v28, p46, {
        ZIndex = 22,
        Position = UDim2.fromOffset(20, 88),
        Size = UDim2.new(1, -40, 0, 40),
        TextColor3 = Color3.fromRGB(255, 220, 90)
    })
    t1.button(v28, p47, Color3.fromRGB(110, 225, 60), {
        ZIndex = 22,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -22),
        Size = UDim2.fromOffset(240, 72)
    }, p48).Label.ZIndex = 23

    if p49 then
        t1.button(v28, ("❤️ REVIVE  R$ %*"):format((Robux.price("Revive"))), Color3.fromRGB(255, 90, 120), {
            Name = "Revive",
            ZIndex = 22,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -108),
            Size = UDim2.fromOffset(320, 72)
        }, function() -- line: 286
            -- upvalues: p49 (copy), v27 (copy), Robux (copy)
            Robux.buy("Revive", function() -- line: 287
                -- upvalues: p49 (copy), v27 (copy)
                if v27.Parent then
                    v27:Destroy()
                    p49()
                end
            end)
        end).Label.ZIndex = 23
    end

    UIUtil.pop(v28, 0.6)

    return v27
end

return t1

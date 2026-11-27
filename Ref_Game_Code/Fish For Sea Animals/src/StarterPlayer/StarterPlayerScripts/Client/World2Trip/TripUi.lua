-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local LocalPlayer = Players.LocalPlayer
local ScreenGui
local t2 = {}
local v1, v2, v3, v4, v5, v6
local v7 = Color3.new(1, 1, 1)
local v8 = Color3.fromRGB(200, 225, 255)
local t1 = {}

function t1.gui() -- line: 28
    -- upvalues: ScreenGui (ref)
    return ScreenGui
end

local t3 = {}

function t1.hideScreens() -- line: 34
    -- upvalues: LocalPlayer (copy), ScreenGui (ref), t3 (copy)
    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Enabled and child ~= ScreenGui then
            child.Enabled = false
            t3[child] = true
        end
    end
end

function t1.showScreens() -- line: 43
    -- upvalues: t3 (copy)
    for v9 in t3 do
        if v9.Parent then
            v9.Enabled = true
        end
    end

    table.clear(t3)
end

function t1.letterbox(p1, p2) -- line: 52
    -- upvalues: UIUtil (copy), t2 (copy)
    for _, v10 in t2 do
        UIUtil.tween(v10, p2 or 0.6, {
            Size = UDim2.fromScale(1, p1 and 0.1 or 0)
        }, Enum.EasingStyle.Sine)
    end
end

function t1.fade(p3, p4) -- line: 59
    -- upvalues: UIUtil (copy), v1 (ref)
    UIUtil.tween(v1, p4 or 0.4, {
        BackgroundTransparency = p3 and 0 or 1
    }, Enum.EasingStyle.Sine).Completed:Wait()
end

function t1.wash(p5, p6) -- line: 66
    -- upvalues: UIUtil (copy), v2 (ref)
    v2.BackgroundColor3 = Color3.fromRGB(215, 240, 255)
    UIUtil.tween(v2, p6 or 0.6, {
        BackgroundTransparency = p5 and 0 or 1
    }, Enum.EasingStyle.Sine).Completed:Wait()
end

function t1.black(p7) -- line: 72
    -- upvalues: v1 (ref)
    v1.BackgroundTransparency = p7 and 0 or 1
end

function t1.flash(p8, p9, p10) -- line: 76
    -- upvalues: UIUtil (copy), v2 (ref), v7 (copy)
    v2.BackgroundColor3 = p8 or v7
    v2.BackgroundTransparency = p10 or 0
    UIUtil.tween(v2, p9 or 0.4, {
        BackgroundTransparency = 1
    })
end

function t1.shadowSweep(p11) -- line: 84
    -- upvalues: UIUtil (copy), v3 (ref)
    v3.Visible = true
    v3.Position = UDim2.fromScale(1.35, -0.35)
    UIUtil.tween(v3, p11, {
        Position = UDim2.fromScale(-0.35, 1.35)
    }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    task.delay(p11, function() -- line: 88
        -- upvalues: v3 (ref)
        v3.Visible = false
    end)
end

function t1.caption(p12, p13) -- line: 94
    -- upvalues: UIUtil (copy), v4 (ref), v8 (copy)
    if not p12 then
        UIUtil.tween(v4, 0.4, {
            TextTransparency = 1
        })
        UIUtil.tween(v4.UIStroke, 0.4, {
            Transparency = 1
        })

        return
    end

    v4.Text = p12
    v4.TextColor3 = p13 or v8
    v4.TextTransparency = 1
    v4.UIStroke.Transparency = 1
    UIUtil.tween(v4, 0.5, {
        TextTransparency = 0
    })
    UIUtil.tween(v4.UIStroke, 0.5, {
        Transparency = 0
    })
end

local function fadeOut(p14, p15, p16) -- line: 108
    -- upvalues: UIUtil (copy)
    task.delay(p15, function() -- line: 109
        -- upvalues: p14 (copy), p16 (copy), UIUtil (copy)
        for _, v22 in p14 do
            if v22.Parent then
                UIUtil.tween(v22, 0.35, {
                    TextTransparency = 1
                })

                local UIStroke = v22:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIUtil.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end
            end
        end

        task.wait(0.4)
        p16:Destroy()
    end)
end

function t1.title(p17, p18, p19, p20, p21) -- line: 126
    -- upvalues: UIUtil (copy), RarityText (copy), Kit (copy), ScreenGui (ref), v7 (copy), v8 (copy)
    local v23 = Kit.frame(ScreenGui, {
        Name = "Title",
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.36),
        Size = UDim2.fromOffset(1100, 230)
    })
    local v24 = Kit.text(v23, p17, {
        ZIndex = 6,
        StrokeThickness = 4,
        Size = UDim2.new(1, 0, 0, 56),
        TextColor3 = v8
    })
    local v25 = Kit.text(v23, p18, {
        ZIndex = 6,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(0, 60),
        Size = UDim2.new(1, 0, 0, 150),
        TextColor3 = p20 or v7
    })

    if p21 then
        RarityText.apply(v25, p21)
    end

    v24.Visible = false
    v25.Visible = false
    task.delay(0.05, function() -- line: 134
        -- upvalues: v24 (copy), UIUtil (copy)
        v24.Visible = true
        UIUtil.pop(v24, 0.4)
    end)
    task.delay(0.32, function() -- line: 138
        -- upvalues: v25 (copy), UIUtil (copy)
        v25.Visible = true
        UIUtil.pop(v25, 1.6)
    end)

    local t8 = {
        v24,
        v25
    }

    task.delay(p19, function() -- line: 109
        -- upvalues: v23 (copy), t8 (copy), UIUtil (copy)
        for _, v26 in t8 do
            if v26.Parent then
                UIUtil.tween(v26, 0.35, {
                    TextTransparency = 1
                })

                local UIStroke = v26:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIUtil.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end
            end
        end

        task.wait(0.4)
        v23:Destroy()
    end)

    return v23
end

function t1.biome(p22, p23, p24, p25) -- line: 147
    -- upvalues: UIUtil (copy), Kit (copy), ScreenGui (ref), v7 (copy), v8 (copy)
    local v27 = Kit.frame(ScreenGui, {
        Name = "Biome",
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0.06, 0, 0.86, 0),
        Size = UDim2.fromOffset(700, 130)
    })
    local v28 = Kit.text(v27, ("BIOME %* / %*"):format(p22, p23), {
        ZIndex = 6,
        Size = UDim2.new(1, 0, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = v8
    })
    local v30 = Kit.text(v27, string.upper(p24), {
        ZIndex = 6,
        StrokeThickness = 5,
        Position = UDim2.fromOffset(0, 42),
        Size = UDim2.new(1, 0, 0, 80),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = p25 or v7
    })

    for v31, v32 in { v28, v30 } do
        v32.Position += UDim2.fromOffset(-60, 0)
        v32.TextTransparency = 1
        task.delay((v31 - 1) * 0.08, function() -- line: 155
            -- upvalues: v32 (copy), UIUtil (copy)
            UIUtil.tween(v32, 0.3, {
                TextTransparency = 0,
                Position = v32.Position + UDim2.fromOffset(60, 0)
            }, Enum.EasingStyle.Back)
        end)
    end

    local t10 = {
        v28,
        v30
    }

    task.delay(0.95, function() -- line: 109
        -- upvalues: v27 (copy), t10 (copy), UIUtil (copy)
        for _, v33 in t10 do
            if v33.Parent then
                UIUtil.tween(v33, 0.35, {
                    TextTransparency = 1
                })

                local UIStroke = v33:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIUtil.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end
            end
        end

        task.wait(0.4)
        v27:Destroy()
    end)
end

local v34

function t1.stack(p26, p27) -- line: 165
    -- upvalues: UIUtil (copy), RarityText (copy), Kit (copy), t1 (copy), ScreenGui (ref), v7 (copy), v34 (ref)
    t1.clearStack()

    local v35 = Kit.frame(ScreenGui, {
        Name = "Stack",
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.13),
        Size = UDim2.fromOffset(1100, 600)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = v35
    v34 = v35

    local t11 = {}

    for v36, v37 in p26 do
        local v39 = Kit.text(v35, v37.text, {
            ZIndex = 6,
            LayoutOrder = v36,
            Size = UDim2.new(1, 0, 0, v37.size),
            TextColor3 = v37.color or v7,
            StrokeThickness = math.clamp(v37.size / 14, 3, 6)
        })

        if v37.rarity then
            RarityText.apply(v39, v37.rarity)
        end

        v39.Visible = false
        table.insert(t11, v39)
        task.delay((v36 - 1) * (p27 or 0.45), function() -- line: 182
            -- upvalues: v37 (copy), v39 (copy), UIUtil (copy)
            if v39.Parent then
                v39.Visible = true
                UIUtil.pop(v39, v37.size > 80 and 1.7 or 0.5)
                UIUtil.sound(v37.size > 80 and "Reveal" or "Pop", v37.size > 80 and 0.9 or 0.5, v37.size > 80 and 0.9 or 1.1)
            end
        end)
    end

    return t11
end

function t1.clearStack() -- line: 193
    -- upvalues: UIUtil (copy), v34 (ref)
    if not v34 then
        return
    end

    local v40 = v34

    v34 = nil

    local t13 = {}

    for _, child in v40:GetChildren() do
        if child:IsA("TextLabel") then
            table.insert(t13, child)
        end
    end

    task.delay(0, function() -- line: 109
        -- upvalues: v40 (copy), t13 (copy), UIUtil (copy)
        for _, v41 in t13 do
            if v41.Parent then
                UIUtil.tween(v41, 0.35, {
                    TextTransparency = 1
                })

                local UIStroke = v41:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIUtil.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end
            end
        end

        task.wait(0.4)
        v40:Destroy()
    end)
end

function t1.showSkip(p28, p29) -- line: 207
    -- upvalues: v5 (ref), v6 (ref)
    v5.Visible = p28
    v6 = p29
end

function t1.open() -- line: 212
    -- upvalues: t1 (copy), ScreenGui (ref)
    ScreenGui.Enabled = true
    t1.hideScreens()
end

function t1.close() -- line: 217
    -- upvalues: t1 (copy), ScreenGui (ref), v1 (ref), v3 (ref)
    t1.clearStack()
    t1.caption(nil)
    t1.showSkip(false)
    v3.Visible = false
    t1.letterbox(false, 0.4)
    t1.showScreens()
    task.delay(0.6, function() -- line: 224
        -- upvalues: ScreenGui (ref), v1 (ref)
        if v1.BackgroundTransparency > 0.99 then
            ScreenGui.Enabled = false
        end
    end)
end

function t1.init() -- line: 231
    -- upvalues: UIUtil (copy), Kit (copy), LocalPlayer (copy), ScreenGui (ref), t2 (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (copy), v8 (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "World2Trip"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.DisplayOrder = 30
    ScreenGui.Enabled = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    for _, v42 in { true, false } do
        local frame = Kit.frame
        local ScreenGui2 = ScreenGui

        table.insert(t2, frame(ScreenGui2, {
            Name = "Bar",
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, v42 and 0 or 1),
            Position = UDim2.fromScale(0, v42 and 0 or 1),
            Size = UDim2.fromScale(1, 0),
            BackgroundColor3 = Color3.new(0, 0, 0)
        }))
    end

    v3 = Kit.frame(ScreenGui, {
        Name = "Shadow",
        Rotation = 28,
        BackgroundTransparency = 0,
        ZIndex = 2,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromScale(1.6, 0.9),
        BackgroundColor3 = Color3.new(0, 0, 0)
    })

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 0.25),
        NumberSequenceKeypoint.new(0.65, 0.25),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v3
    v4 = Kit.text(t2[2], "", {
        Name = "Caption",
        ZIndex = 5,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.8, 0.5),
        TextColor3 = v8
    })
    v4.UIStroke.Transparency = 1
    v2 = Kit.frame(ScreenGui, {
        Name = "Flash",
        BackgroundTransparency = 1,
        ZIndex = 8,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = v7
    })
    v1 = Kit.frame(ScreenGui, {
        Name = "Fade",
        BackgroundTransparency = 1,
        ZIndex = 9,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    })
    v5 = Kit.button(ScreenGui, "SKIP ▶", Color3.fromRGB(60, 70, 90), {
        Name = "Skip",
        ZIndex = 10,
        Visible = false,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -24),
        Size = UDim2.fromOffset(170, 64)
    }, function() -- line: 253
        -- upvalues: v6 (ref)
        if v6 then
            v6()
        end
    end)
    v5.Label.ZIndex = 11
    UIUtil.onScale(function(p30) -- line: 259
        -- upvalues: v5 (ref)
        local v43 = math.max(p30, 0.55)

        v5.Size = UDim2.fromOffset(v43 * 170, v43 * 64)
    end)
    ScreenGui.ChildAdded:Connect(function(p31) -- line: 264
        if p31.Name ~= "Title" and p31.Name ~= "Biome" and p31.Name ~= "Stack" then
            return
        end

        local UIScale = Instance.new("UIScale")

        UIScale.Name = "Scale"
        UIScale.Parent = p31
    end)
end

return t1

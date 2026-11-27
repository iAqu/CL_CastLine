-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Parent.Shop.Robux)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(226, 68, 214)
local v2 = Color3.fromRGB(196, 66, 226)
local v3 = Color3.fromRGB(14, 14, 20)
local v4 = Color3.fromRGB(130, 245, 90)
local v5 = Color3.fromRGB(100, 215, 60)
local v6 = Color3.fromRGB(230, 70, 64)
local v7 = false

local function v8() -- line: 30
    return true
end

local function awayText(p1) -- line: 35
    local v10 = math.max(0, (math.floor(p1)))
    local v11 = v10 // 3600
    local v12 = v10 % 3600 // 60
    local v13 = v10 % 60

    if v11 > 0 then
        return (("%*h %*m %*s"):format(v11, v12, v13))
    end

    if v12 > 0 then
        return (("%*m %*s"):format(v12, v13))
    end

    return (("%*s"):format(v13))
end

local function block(p2, p3, p4, p5, p6) -- line: 45
    -- upvalues: UIUtil (copy), Kit (copy), Style (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = p4
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 3

    for v14, v15 in p5 do
        TextButton[v14] = v15
    end

    Kit.corner(TextButton, 18)
    Kit.stroke(TextButton, 5).ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Style.dress(TextButton, 18)
    Kit.text(TextButton, p3, {
        Name = "Label",
        ZIndex = 4,
        StrokeThickness = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.47),
        Size = UDim2.fromScale(0.84, 0.62)
    })
    TextButton.Parent = p2
    UIUtil.bindButton(TextButton, p6)

    return TextButton
end

local function show(p7, p8) -- line: 71
    -- upvalues: Format (copy), Remotes (copy), UIUtil (copy), Kit (copy), Robux (copy), Style (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (ref), block (copy)
    v7 = true

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "WelcomeBack"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 45

    local v16 = Kit.frame(ScreenGui, {
        Name = "Dim",
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 1)
    })

    UIUtil.tween(v16, 0.3, {
        BackgroundTransparency = 0.45
    })

    local v17 = Kit.frame(ScreenGui, {
        Name = "Holder",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(780, 560)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v17

    local v18 = Kit.frame(v17, {
        Name = "Card",
        BackgroundColor3 = v3,
        Size = UDim2.fromScale(1, 1)
    })

    Kit.corner(v18, 28)
    Kit.stroke(v18, 7, Color3.fromRGB(42, 42, 54))

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Clip"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Size = UDim2.fromScale(1, 1)
    CanvasGroup.Parent = v18
    Kit.corner(CanvasGroup, 28)

    local v19 = Kit.frame(CanvasGroup, {
        Name = "Header",
        ClipsDescendants = true,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 130)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(v1, v2)
    UIGradient.Parent = v19

    for i = 0, 9 do
        Kit.frame(v19, {
            Name = "Stripe",
            BackgroundTransparency = 0.9,
            Rotation = 28,
            BackgroundColor3 = Color3.new(1, 1, 1),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, i * 70 + 260, 0.5, 0),
            Size = UDim2.fromOffset(30, 260)
        })
    end

    Kit.text(v18, "Welcome Back!", {
        Name = "Title",
        ZIndex = 2,
        StrokeThickness = 7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 67),
        Size = UDim2.new(0.82, 0, 0, 92)
    })

    local text = Kit.text
    local v21 = math.max(0, (math.floor(p8)))
    local v22 = v21 // 3600
    local v23 = v21 % 3600 // 60
    local v24 = v21 % 60

    text(v18, ("You were offline for %*"):format(if v22 > 0 then ("%*h %*m %*s"):format(v22, v23, v24) elseif v23 > 0 then ("%*m %*s"):format(v23, v24) else ("%*s"):format(v24)), {
        Name = "Subtitle",
        ZIndex = 2,
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 150),
        Size = UDim2.new(0.9, 0, 0, 52),
        TextColor3 = Color3.fromRGB(240, 240, 250)
    })

    local v25 = Kit.frame(v18, {
        Name = "Strip",
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 46, 28),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 218),
        Size = UDim2.new(1, -90, 0, 140)
    })

    Kit.corner(v25, 24)

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.85)
    })
    UIGradient2.Parent = v25

    local v26 = Kit.text(v18, Format.money(p7), {
        Name = "Amount",
        ZIndex = 3,
        StrokeThickness = 7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 288),
        Size = UDim2.new(1, -150, 0, 110),
        TextColor3 = Color3.new(1, 1, 1)
    })
    local UIGradient3 = Instance.new("UIGradient")

    UIGradient3.Rotation = 90
    UIGradient3.Color = ColorSequence.new(v4:Lerp(Color3.new(1, 1, 1), 0.25), v4:Lerp(Color3.fromRGB(40, 150, 40), 0.45))
    UIGradient3.Parent = v26

    local v27 = false

    local function close() -- line: 169
        -- upvalues: ScreenGui (copy), v16 (copy), UIScale (copy), UIUtil (copy), v7 (ref)
        UIUtil.tween(UIScale, 0.18, {
            Scale = UIScale.Scale * 0.7
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        UIUtil.tween(v16, 0.2, {
            BackgroundTransparency = 1
        })
        task.delay(0.2, function() -- line: 172
            -- upvalues: ScreenGui (copy), v7 (ref)
            ScreenGui:Destroy()
            v7 = false
        end)
    end

    block(v18, "Double it!", v5, {
        Name = "Double",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 46, 1, -30),
        Size = UDim2.fromOffset(380, 116)
    }, function() -- line: 184
        -- upvalues: v27 (ref), close (copy), UIUtil (copy), Robux (copy)
        if not v27 then
            Robux.buy("OfflineX2", function() -- line: 188
                -- upvalues: v27 (ref), close (copy), UIUtil (copy)
                if v27 then
                    return
                end

                v27 = true
                UIUtil.sound("Cash", 0.8)
                close()
            end)
        end
    end)

    local v28 = Kit.frame(v18, {
        Name = "Price",
        BackgroundTransparency = 1,
        Rotation = 8,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 370, 1, -154),
        Size = UDim2.fromOffset(190, 66)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v28

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = Style.ROBUX
    ImageLabel.Size = UDim2.fromOffset(52, 52)
    ImageLabel.ZIndex = 5
    ImageLabel.Parent = v28

    local v29 = Kit.text(v28, tostring(Robux.price("OfflineX2")), {
        LayoutOrder = 1,
        TextScaled = false,
        TextSize = 56,
        ZIndex = 5,
        StrokeThickness = 5,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 66)
    })

    v29.TextWrapped = false
    Robux.onPrices(function() -- line: 230
        -- upvalues: v29 (copy), Robux (copy)
        v29.Text = tostring(Robux.price("OfflineX2"))
    end)
    block(v18, "Okay!", v6, {
        Name = "Okay",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -46, 1, -30),
        Size = UDim2.fromOffset(280, 116)
    }, function() -- line: 240
        -- upvalues: v27 (ref), close (copy), Format (copy), Remotes (copy), UIUtil (copy)
        if v27 then
            return
        end

        v27 = true

        local InvokeServer = Remotes.OfflineEarnings.InvokeServer
        local OfflineEarnings = Remotes.OfflineEarnings
        local claim, claim2 = pcall(InvokeServer, OfflineEarnings, "claim")

        if claim and type(claim2) == "number" and claim2 > 0 then
            UIUtil.sound("Cash", 0.8)
            UIUtil.toast(("+%*"):format((Format.money(claim2))), "cash")
        end

        close()
    end)
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    UIUtil.pop(v17, 0.6)
    UIUtil.sound("Reveal", 0.5, 1.15)
end

function t1.isShowing() -- line: 258
    -- upvalues: v7 (ref)
    return v7
end

function t1.setReadyCheck(p9) -- line: 263
    -- upvalues: v8 (ref)
    v8 = p9
end

function t1.init() -- line: 267
    -- upvalues: Remotes (copy), UIUtil (copy), Robux (copy), v8 (ref), show (copy)
    Robux.init()
    task.spawn(function() -- line: 269
        -- upvalues: Remotes (copy), UIUtil (copy), v8 (ref), show (copy)
        while true do
            task.wait(0.5)

            if not v8() then
                continue
            end

            if not UIUtil.panelMode() then
                break
            end
        end

        task.wait(1)

        local InvokeServer = Remotes.OfflineEarnings.InvokeServer
        local OfflineEarnings = Remotes.OfflineEarnings
        local check, check2, check3 = pcall(InvokeServer, OfflineEarnings, "check")

        if check and type(check2) == "number" and check2 > 0 and type(check3) == "number" then
            show(check2, check3)
        end
    end)
end

return t1

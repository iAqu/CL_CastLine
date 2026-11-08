-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = UDim2.fromScale(0.994, 0.089)
local v2 = UDim2.fromScale(0.147, 0.501)
local v3 = Color3.fromRGB(255, 0, 0)
local v4 = Color3.fromRGB(56, 0, 14)
local v5 = Color3.fromRGB(255, 255, 255)
local v6 = Font.new("rbxassetid://12187365977", Enum.FontWeight.Bold)
local v7 = UDim2.fromScale(0.8, 0.8)
local v8 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true)
local t1 = {}

t1.__index = t1

local function build(p1, p2) -- line: 60
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
    local AlertBadge = p1:FindFirstChild("AlertBadge")

    if AlertBadge ~= nil and AlertBadge:IsA("Frame") then
        return AlertBadge
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "AlertBadge"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = v3
    Frame.BorderSizePixel = 0
    Frame.Position = p2.Position or v1
    Frame.Size = p2.Size or v2
    Frame.Visible = false
    Frame.ZIndex = p2.ZIndex or 6
    Instance.new("UIAspectRatioConstraint").Parent = Frame

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = 1.3
    UIStroke.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = v6
    TextLabel.Name = "TextLabel"
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = v7
    TextLabel.Text = p2.Text or "!"
    TextLabel.TextColor3 = v5
    TextLabel.TextScaled = true
    TextLabel.ZIndex = Frame.ZIndex + 1

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 1.1
    UIStroke2.Parent = TextLabel
    TextLabel.Parent = Frame
    Frame.Parent = p1

    return Frame
end

function t1.new(p3, p4) -- line: 113
    -- upvalues: Signal (copy), t1 (copy), build (copy)
    p4 = p4 or {}

    local v10 = setmetatable({
        _shown = false,
        Dismissed = Signal.new(),
        _badges = {},
        _connections = {},
        _tweens = {},
        _pulse = p4.Pulse ~= false
    }, t1)

    for _, v11 in p3 do
        if v11:IsA("GuiObject") then
            table.insert(v10._badges, (build(v11, p4)))

            if p4.DismissOnActivated ~= false and v11:IsA("GuiButton") then
                table.insert(v10._connections, v11.Activated:Connect(function() -- line: 134
                    -- upvalues: v10 (copy)
                    v10:Dismiss()
                end))
            end
        end
    end

    return v10
end

function t1.Attach(p5, p6) -- line: 142
    -- upvalues: t1 (copy)
    return t1.new(if p5 == nil then {} else { p5 }, p6)
end

function t1.IsShown(p7) -- line: 146
    return p7._shown
end

function t1.SetText(p8, p9) -- line: 150
    for _, v14 in p8._badges do
        for _, descendant in v14:GetDescendants() do
            if descendant:IsA("TextLabel") then
                descendant.Text = p9
            end
        end
    end
end

function t1.Show(p10) -- line: 160
    -- upvalues: TweenService (copy), EnsureUIScale (copy), v8 (copy)
    if p10._shown then
        return
    end

    p10._shown = true

    for _, v15 in p10._badges do
        v15.Visible = true

        local v16 = EnsureUIScale(v15)

        if p10._pulse then
            v16.Scale = 0.8

            local tween = TweenService:Create(v16, v8, {
                Scale = 1.2
            })

            tween:Play()
            table.insert(p10._tweens, tween)
            continue
        end

        v16.Scale = 1
    end
end

function t1.Dismiss(p11) -- line: 181
    -- upvalues: EnsureUIScale (copy)
    if p11._shown then
        p11._shown = false

        for _, v17 in p11._tweens do
            v17:Cancel()
            v17:Destroy()
        end

        table.clear(p11._tweens)

        for _, v18 in p11._badges do
            EnsureUIScale(v18).Scale = 1
            v18.Visible = false
        end

        p11.Dismissed:Fire()
    end
end

function t1.Destroy(p12) -- line: 201
    p12:Dismiss()

    for _, v19 in p12._connections do
        v19:Disconnect()
    end

    table.clear(p12._connections)

    for _, v20 in p12._badges do
        v20:Destroy()
    end

    table.clear(p12._badges)
    p12.Dismissed:Destroy()
end

return t1

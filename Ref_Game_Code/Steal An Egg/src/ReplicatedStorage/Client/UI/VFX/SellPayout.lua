-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Hud = require(ReplicatedStorage.Client.Hud)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local OverlayRoot = require(script.Parent.OverlayRoot)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local v1 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local Quart = Enum.EasingStyle.Quart
local In = Enum.EasingDirection.In
local v2 = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.04)
local v5 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v7 = Color3.fromRGB(126, 255, 92)
local v8 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1 = {}
local v9 = Random.new()

local function money(p1) -- line: 76
    -- upvalues: Numbers (copy), Simple (copy)
    if p1 > 99999 then
        return "$" .. Simple.FormatCompact(math.round(p1), ".#")
    end

    return "$" .. Numbers.AddCommas((math.round(p1)))
end

local function namedScale(p2, p3) -- line: 83
    local v10 = p2:FindFirstChild(p3)

    if v10 and v10:IsA("UIScale") then
        return v10
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Name = p3
    UIScale.Parent = p2

    return UIScale
end

local function quadBezier(p4, p5, p6, p7) -- line: 95
    local v11 = 1 - p7

    return p4 * (v11 * v11) + p5 * (v11 * 2 * p7) + p6 * (p7 * p7)
end

local function playTween(p8, p9, p10) -- line: 100
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p8, p9, p10)

    tween:Play()

    return tween
end

local function readout() -- line: 106
    -- upvalues: Hud (copy)
    local Money = Hud.Find("Money")
    local MoneyIcon = Hud.Find("MoneyIcon")
    local MoneyValue = Hud.Find("MoneyValue")

    return if Money ~= nil and MoneyIcon ~= nil and MoneyValue ~= nil then {
        Plate = Money,
        Icon = MoneyIcon,
        Value = MoneyValue
    } else nil
end

local function iconCenter(p11) -- line: 116
    return p11.AbsolutePosition + p11.AbsoluteSize / 2
end

local function punch(p12, p13) -- line: 120
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
    local Plate, Icon, Value = p12.Plate, p12.Icon, p12.Value
    local v12 = if p13 % 2 == 0 then 1 else -1
    local PayoutPunch = Icon:FindFirstChild("PayoutPunch")

    if not (PayoutPunch and PayoutPunch:IsA("UIScale")) then
        PayoutPunch = Instance.new("UIScale")
        PayoutPunch.Name = "PayoutPunch"
        PayoutPunch.Parent = Icon
    end

    PayoutPunch.Scale = 1.32
    TweenService:Create(PayoutPunch, v2, {
        Scale = 1
    }):Play()

    local PayoutRotation = Icon:GetAttribute("PayoutRotation")

    if typeof(PayoutRotation) ~= "number" then
        PayoutRotation = Icon.Rotation
        Icon:SetAttribute("PayoutRotation", PayoutRotation)
    end

    Icon.Rotation = PayoutRotation + v12 * 14
    TweenService:Create(Icon, v3, {
        Rotation = PayoutRotation
    }):Play()

    local PayoutPunch2 = Value:FindFirstChild("PayoutPunch")

    if not (PayoutPunch2 and PayoutPunch2:IsA("UIScale")) then
        PayoutPunch2 = Instance.new("UIScale")
        PayoutPunch2.Name = "PayoutPunch"
        PayoutPunch2.Parent = Value
    end

    PayoutPunch2.Scale = 1.16
    TweenService:Create(PayoutPunch2, v4, {
        Scale = 1
    }):Play()

    local PayoutColor = Value:GetAttribute("PayoutColor")

    if typeof(PayoutColor) ~= "Color3" then
        PayoutColor = Value.TextColor3
        Value:SetAttribute("PayoutColor", PayoutColor)
    end

    Value.TextColor3 = v7
    TweenService:Create(Value, v5, {
        TextColor3 = PayoutColor
    }):Play()

    local PayoutShake = Plate:FindFirstChild("PayoutShake")

    if not (PayoutShake and PayoutShake:IsA("UIScale")) then
        PayoutShake = Instance.new("UIScale")
        PayoutShake.Name = "PayoutShake"
        PayoutShake.Parent = Plate
    end

    PayoutShake.Scale = 1.05
    TweenService:Create(PayoutShake, v6, {
        Scale = 1
    }):Play()
end

local function floatTotal(p14, p15) -- line: 153
    -- upvalues: TweenService (copy), Numbers (copy), OverlayRoot (copy), Simple (copy), v7 (copy), v8 (copy)
    local Plate, Value = p14.Plate, p14.Value
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "PayoutFloater"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "+" .. (if p15 > 99999 then "$" .. Simple.FormatCompact(math.round(p15), ".#") else "$" .. Numbers.AddCommas((math.round(p15))))
    TextLabel.TextColor3 = v7
    TextLabel.FontFace = Value.FontFace
    TextLabel.TextScaled = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Size = UDim2.fromOffset(Plate.AbsoluteSize.X, Plate.AbsoluteSize.Y * 0.8)
    TextLabel.Position = UDim2.fromOffset(Plate.AbsolutePosition.X, Plate.AbsolutePosition.Y)
    TextLabel.Parent = OverlayRoot()

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Parent = TextLabel
    TweenService:Create(TextLabel, v8, {
        TextTransparency = 1,
        Position = UDim2.fromOffset(Plate.AbsolutePosition.X, Plate.AbsolutePosition.Y - Plate.AbsoluteSize.Y * 1.6)
    }):Play()

    local tween = TweenService:Create(UIStroke, v8, {
        Transparency = 1
    })

    tween:Play()
    tween.Completed:Once(function() -- line: 182
        -- upvalues: TextLabel (copy)
        TextLabel:Destroy()
    end)
end

local function flyCoin(p16, p17, p18, p19, p20, p21) -- line: 185
    -- upvalues: TweenService (copy), OverlayRoot (copy), v1 (copy), Quart (copy), In (copy), v9 (copy)
    local Icon = p16.Icon
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Coin"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://119640363267627"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Size = UDim2.fromOffset(p18, p18)
    ImageLabel.Position = UDim2.fromOffset(p17.X, p17.Y)
    ImageLabel.ImageTransparency = 1
    ImageLabel.Parent = OverlayRoot()

    local v14 = p17 + Vector2.new(v9:NextNumber(-46, 46), v9:NextNumber(-46, 27.599999999999998))
    local v15 = Icon.AbsolutePosition + Icon.AbsoluteSize / 2
    local v16 = (v14 + v15) / 2 + Vector2.new(v9:NextNumber(-130, 130), -v9:NextNumber(65, 130))
    local v17 = v9:NextNumber(140, 320) * (if v9:NextInteger(0, 1) == 0 then -1 else 1)
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Changed:Connect(function(p22) -- line: 220
        -- upvalues: p18 (copy), ImageLabel (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy)
        if ImageLabel.Parent == nil then
            return
        end

        local v18 = 1 - p22
        local v19 = v14 * (v18 * v18) + v16 * (v18 * 2 * p22) + v15 * (p22 * p22)

        ImageLabel.Position = UDim2.fromOffset(v19.X, v19.Y)
        ImageLabel.Rotation = v17 * p22

        local v20 = p18 * (1 - p22 * 0.45)

        ImageLabel.Size = UDim2.fromOffset(v20, v20)
    end)
    task.delay(p19, function() -- line: 231
        -- upvalues: p20 (copy), p21 (copy), ImageLabel (copy), NumberValue (copy), TweenService (copy), v1 (copy), Quart (copy), In (copy), v9 (copy)
        if ImageLabel.Parent ~= nil then
            TweenService:Create(ImageLabel, v1, {
                ImageTransparency = 0
            }):Play()

            local tween = TweenService:Create(NumberValue, TweenInfo.new(0.55 + v9:NextNumber(-0.12, 0.12), Quart, In), {
                Value = 1
            })

            tween:Play()
            tween.Completed:Once(function() -- line: 248
                -- upvalues: p20 (copy), p21 (copy), ImageLabel (copy), NumberValue (copy)
                ImageLabel:Destroy()
                NumberValue:Destroy()
                p21(p20)
            end)
        else
            NumberValue:Destroy()
        end
    end)
end

function t1.Award(p23, p24) -- line: 260
    -- upvalues: Audio (copy), readout (copy), punch (copy), floatTotal (copy), flyCoin (copy)
    if p23 <= 0 then
        return
    end

    local v22 = readout()

    if v22 ~= nil then
        local v23 = p24 or {}
        local v25 = math.clamp(#v23, 5, 14)
        local v27 = math.clamp(v22.Icon.AbsoluteSize.Y * 0.9, 26, 72)
        local n1 = 0

        local function onArrive(p25) -- line: 277
            -- upvalues: p23 (copy), v22 (copy), v25 (copy), n1 (ref), Audio (copy), punch (copy), floatTotal (copy)
            n1 += 1
            punch(v22, p25)
            Audio.Play("rbxassetid://8807960350", script, {
                Volume = 0.165,
                PlaybackSpeed = p25 / v25 * 0.5 + 0.95
            })

            if n1 == v25 then
                Audio.Play("rbxassetid://134810204798705", script, {
                    Volume = 0.49500000000000005
                })
                floatTotal(v22, p23)
            end
        end

        for i = 1, v25 do
            local v28

            if #v23 > 0 then
                v28 = v23[(i - 1) % #v23 + 1]
            else
                local Icon = v22.Icon

                v28 = Icon.AbsolutePosition + Icon.AbsoluteSize / 2
            end

            flyCoin(v22, v28, v27, (i - 1) * 0.045, i, onArrive)
        end
    end
end

return table.freeze(t1)

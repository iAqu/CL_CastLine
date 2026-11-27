-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UIKit = require(script.Parent.UIKit)
local Pad = require(script.Parent.Pad)
local fromRGB = Color3.fromRGB
local v1, v2, v3, t2, Volume
local t1 = {}

t1.Pressed = 0

local function ensure() -- line: 22
    -- upvalues: UIKit (copy), Pad (copy), t1 (copy), fromRGB (copy), v1 (ref), v2 (ref), v3 (ref)
    if v1 then
        return
    end

    v1 = UIKit.screenGui("SkipCutscene", 45)

    local v4 = v1

    v4.ScreenInsets = Enum.ScreenInsets.None
    v3 = UIKit.frame(v1, {
        Name = "Cover",
        Transparency = 1,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(0, 0, 0)
    })
    v3.Visible = false

    local v5 = UIKit.frame(v1, {
        Name = "Corner",
        Transparency = 1,
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1)
    })
    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingRight = UDim.new(0, 34)
    UIPadding.PaddingBottom = UDim.new(0, 34)
    UIPadding.Parent = v5

    local v6, v7 = UIKit.button(v5, {
        Name = "Skip",
        Text = "SKIP  >>",
        Corner = 35,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 3,
        Size = UDim2.fromOffset(196, 70),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        Color = fromRGB(70, 76, 110),
        Color2 = fromRGB(34, 36, 60),
        OnClick = function() -- OnClick | line: 36
            -- upvalues: t1 (copy)
            t1.Press()
        end
    })

    v2 = v6
    v7.TextColor3 = fromRGB(255, 255, 255)
    Pad.Icon(v2, Enum.KeyCode.ButtonB, {
        ZIndex = 4,
        Size = UDim2.fromOffset(52, 52),
        Position = UDim2.new(0, -8, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    v2.Visible = false
end

function t1.Allowed() -- line: 46
    -- upvalues: Players (copy)
    return Players.LocalPlayer:GetAttribute("OwnsSkipCutscene") == true
end

function t1.Show(p1, p2) -- line: 50
    -- upvalues: UIKit (copy), t1 (copy), v2 (ref), t2 (ref), ensure (copy)
    if not t1.Allowed() then
        return
    end

    ensure()
    t2 = {
        fired = false,
        key = p1,
        onSkip = p2
    }
    v2.Visible = true

    local v8 = UIKit.scaleOf(v2)

    v8.Scale = 0
    UIKit.tween(v8, 0.3, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

function t1.Hide(p3) -- line: 62
    -- upvalues: v1 (ref), v2 (ref), t2 (ref)
    if not v1 or p3 and t2 and t2.key ~= p3 then
        return
    end

    t2 = nil
    v2.Visible = false
end

function t1.Showing() -- line: 70
    -- upvalues: v2 (ref), t2 (ref)
    return if t2 and v2.Visible then t2.key else nil
end

function t1.Press() -- line: 74
    -- upvalues: t1 (copy), v2 (ref), t2 (ref)
    local t3 = t2

    if not t3 or t3.fired or not v2.Visible then
        return
    end

    t3.fired = true
    t1.Pressed += 1
    v2.Visible = false
    task.spawn(t3.onSkip)
end

function t1.Cover(p4, p5) -- line: 86
    -- upvalues: SoundService (copy), TweenService (copy), v3 (ref), Volume (ref), ensure (copy)
    ensure()

    local Sfx = SoundService:FindFirstChild("Sfx")

    if p4 then
        v3.Visible = true
        TweenService:Create(v3, TweenInfo.new(p5 or 0.15), {
            BackgroundTransparency = 0
        }):Play()

        if Sfx and Sfx:IsA("SoundGroup") and Volume == nil then
            Volume = Sfx.Volume
            Sfx.Volume = 0
        end
    else
        local tween = TweenService:Create(v3, TweenInfo.new(p5 or 0.3), {
            BackgroundTransparency = 1
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 99
            -- upvalues: v3 (ref)
            if v3.BackgroundTransparency >= 0.99 then
                v3.Visible = false
            end
        end)

        if Sfx and Sfx:IsA("SoundGroup") and Volume ~= nil then
            Sfx.Volume = Volume
        end

        Volume = nil
    end
end

function t1.Init() -- line: 111
    -- upvalues: UserInputService (copy), t1 (copy), ensure (copy)
    ensure()
    UserInputService.InputBegan:Connect(function(p6, p7) -- line: 113
        -- upvalues: t1 (copy)
        if not p7 and (p6.KeyCode == Enum.KeyCode.Q or p6.KeyCode == Enum.KeyCode.ButtonB) then
            t1.Press()
        end
    end)
end

return t1

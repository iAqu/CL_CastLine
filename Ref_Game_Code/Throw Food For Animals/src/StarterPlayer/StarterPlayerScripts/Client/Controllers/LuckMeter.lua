-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local t1 = {}

t1.__index = t1

local t2 = {
    {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(205, 210, 225)
    },
    {
        Color3.fromRGB(255, 245, 140),
        Color3.fromRGB(255, 205, 40)
    },
    {
        Color3.fromRGB(255, 200, 110),
        Color3.fromRGB(255, 130, 30)
    },
    {
        Color3.fromRGB(255, 130, 130),
        Color3.fromRGB(235, 40, 40)
    },
    {
        Color3.fromRGB(255, 150, 230),
        Color3.fromRGB(235, 50, 190)
    },
    {
        Color3.fromRGB(210, 150, 255),
        Color3.fromRGB(140, 50, 235)
    },
    {
        Color3.fromRGB(140, 180, 255),
        Color3.fromRGB(50, 90, 235)
    },
    {
        Color3.fromRGB(150, 255, 255),
        Color3.fromRGB(40, 210, 230)
    },
    {
        Color3.fromRGB(170, 255, 150),
        Color3.fromRGB(50, 220, 80)
    },
    {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(20, 20, 25)
    },
    {
        Color3.fromRGB(70, 140, 255),
        Color3.fromRGB(160, 40, 230)
    },
    {
        Color3.fromRGB(255, 230, 60),
        Color3.fromRGB(230, 40, 30)
    },
    {
        Color3.fromRGB(60, 230, 120),
        Color3.fromRGB(30, 200, 230)
    },
    {
        Color3.fromRGB(255, 120, 200),
        Color3.fromRGB(255, 150, 40)
    },
    {
        Color3.fromRGB(255, 215, 80),
        Color3.fromRGB(255, 255, 255)
    },
    {
        Color3.fromRGB(190, 90, 255),
        Color3.fromRGB(25, 10, 40)
    },
    {
        Color3.fromRGB(180, 250, 255),
        Color3.fromRGB(90, 150, 255)
    },
    {
        Color3.fromRGB(180, 255, 80),
        Color3.fromRGB(255, 190, 40)
    },
    {
        Color3.fromRGB(255, 90, 60),
        Color3.fromRGB(40, 15, 15)
    },
    {
        Color3.fromRGB(60, 210, 190),
        Color3.fromRGB(20, 50, 130)
    },
    {
        Color3.fromRGB(255, 80, 220),
        Color3.fromRGB(60, 100, 255)
    },
    {
        Color3.fromRGB(255, 160, 60),
        Color3.fromRGB(110, 60, 30)
    },
    {
        Color3.fromRGB(230, 235, 245),
        Color3.fromRGB(90, 120, 200)
    },
    {
        Color3.fromRGB(255, 250, 120),
        Color3.fromRGB(60, 200, 90)
    },
    {
        Color3.fromRGB(220, 30, 70),
        Color3.fromRGB(255, 170, 210)
    },
    {
        Color3.fromRGB(150, 70, 255),
        Color3.fromRGB(60, 230, 255)
    },
    {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 80, 80)
    },
    {
        Color3.fromRGB(40, 230, 160),
        Color3.fromRGB(255, 240, 90)
    },
    {
        Color3.fromRGB(90, 100, 255),
        Color3.fromRGB(255, 255, 255)
    },
    {
        Color3.fromRGB(255, 140, 40),
        Color3.fromRGB(20, 20, 25)
    },
    {
        Color3.fromRGB(255, 200, 240),
        Color3.fromRGB(130, 40, 120)
    },
    {
        Color3.fromRGB(120, 255, 60),
        Color3.fromRGB(20, 60, 30)
    },
    {
        Color3.fromRGB(60, 240, 255),
        Color3.fromRGB(255, 60, 200)
    },
    {
        Color3.fromRGB(255, 240, 200),
        Color3.fromRGB(180, 110, 40)
    },
    {
        Color3.fromRGB(30, 30, 120),
        Color3.fromRGB(255, 220, 80)
    },
    {
        Color3.fromRGB(255, 100, 40),
        Color3.fromRGB(60, 220, 255)
    },
    {
        Color3.fromRGB(200, 255, 200),
        Color3.fromRGB(40, 120, 255)
    },
    {
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 230, 60)
    },
    {
        Color3.fromRGB(230, 200, 255),
        Color3.fromRGB(40, 10, 60)
    },
    {
        Color3.fromRGB(255, 250, 220),
        Color3.fromRGB(255, 160, 220)
    },
    {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 215, 60)
    }
}

local function styleFor(p1) -- line: 84
    -- upvalues: t2 (copy)
    local v2 = t2[math.clamp(p1, 1, #t2)]

    return v2[1], v2[2]
end

function t1.new(p2) -- line: 89
    -- upvalues: RunService (copy), GameConfig (copy), UITheme (copy), UIKit (copy), t1 (copy), t2 (copy), styleFor (copy)
    local self = setmetatable({}, t1)
    local Luck = GameConfig.Luck

    self.Config = Luck
    self.Target = 1
    self.Shown = 1
    self.LastStep = math.floor(1 / Luck.StepSound + 1E-06)
    self.LastWhole = 1
    self.Locked = false

    local v5 = UIKit.Frame({
        Name = "LuckMeter",
        Transparency = 1,
        ZIndex = 30,
        Parent = p2,
        Size = UDim2.fromScale(0.34, 0.12),
        Position = UDim2.fromScale(0.5, 0.085),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    self.Holder = v5

    local v6 = UIKit.Frame({
        Name = "Glow",
        Transparency = 0.9,
        Corner = 40,
        ZIndex = 30,
        Parent = v5,
        Size = UDim2.fromScale(0.9, 1.1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1)
    })

    self.Glow = v6

    local Gradient = UIKit.Gradient
    local v8 = t2[math.clamp(1, 1, #t2)]
    local v9 = v8[1]
    local _ = v8[2]

    self.GlowGradient = Gradient(v6, v9, select(2, styleFor(1)), 90)

    local v10 = UIKit.Text({
        Name = "Value",
        Text = "1.00X",
        ZIndex = 32,
        Parent = v5,
        Size = UDim2.fromScale(1, 0.74),
        Position = UDim2.fromScale(0.5, 0.36),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Stroke = UITheme.Stroke.TextBig + 1
    })

    v10.TextColor3 = Color3.new(1, 1, 1)
    self.Value = v10

    local Gradient2 = UIKit.Gradient
    local v12 = t2[math.clamp(1, 1, #t2)]
    local v13 = v12[1]
    local _ = v12[2]

    self.Gradient = Gradient2(v10, v13, select(2, styleFor(1)), 90)
    self.Word = UIKit.Text({
        Name = "Word",
        Text = "LUCK",
        ZIndex = 32,
        Stroke = 3,
        TextTransparency = 0.1,
        Parent = v5,
        Size = UDim2.fromScale(1, 0.3),
        Position = UDim2.fromScale(0.5, 0.86),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v5
    self.Scale = UIScale
    UIKit.PopIn(v5, 0.35, 0.5)
    self.Conn = RunService.RenderStepped:Connect(function(p3) -- line: 116
        -- upvalues: self (copy)
        self:_step(p3)
    end)

    return self
end

function t1:SetDistance(p5) -- line: 125
    -- upvalues: AreaUtil (copy)
    local v14 = AreaUtil.GetLaunchPosition().Z - math.max(p5, 0)
    local v15 = 1 + AreaUtil.LuckStepsForZ(v14)

    if self.Target < v15 then
        self.Target = v15
    end
end

function t1:_applyWhole(p7) -- line: 131
    -- upvalues: t2 (copy)
    local v17 = t2[math.clamp(p7, 1, #t2)]
    local v18 = v17[1]
    local v19 = v17[2]
    local v20 = ColorSequence.new(v18, v19)

    self.Gradient.Color = v20
    self.GlowGradient.Color = v20
end

function t1:_step(_) -- line: 138
    -- upvalues: UIKit (copy), Sounds (copy)
    if self.Holder then
        local Config = self.Config

        self.Shown = self.Target

        local v22 = math.floor(self.Shown * 100 + 1E-06) / 100

        self.Value.Text = string.format("%.2fX", v22)

        local v24 = math.floor(v22 / Config.StepSound + 1E-06)
        local v26 = math.floor(v22 / Config.WholeSound + 1E-06)

        if self.LastWhole < v26 then
            self.LastWhole = v26
            self.LastStep = v24
            self:_applyWhole(v26)
            Sounds.Play("LuckWhole", {
                Pitch = math.min((v26 - 1) * 0.06 + 1, 1.8)
            })
            UIKit.Punch(self.Holder, 0.45, 0.5)
            self.Glow.BackgroundTransparency = 0.55
            self.Glow.Size = UDim2.fromScale(1.15, 1.5)
            UIKit.Tween(self.Glow, {
                BackgroundTransparency = 0.9,
                Size = UDim2.fromScale(0.9, 1.1)
            }, 0.5)
            self.Holder.Rotation = v26 % 2 == 0 and -4 or 4
            UIKit.Tween(self.Holder, {
                Rotation = 0
            }, 0.4, Enum.EasingStyle.Elastic)
        elseif self.LastStep < v24 then
            self.LastStep = v24

            local v28 = v22 - v26

            Sounds.Play("LuckTick", {
                Pitch = v28 * 0.5 + 0.9 + math.min(v26 - 1, 6) * 0.05
            })
            self.Scale.Scale = 1.06
            UIKit.Tween(self.Scale, {
                Scale = 1
            }, 0.15)
        end
    end
end

function t1:Lock() -- line: 172
    -- upvalues: UIKit (copy)
    if self.Locked or not self.Holder then
        return
    end

    self.Locked = true
    self.Shown = self.Target
    self:_step(0)
    UIKit.Punch(self.Holder, 0.3, 0.5)
    self.Glow.BackgroundTransparency = 0.6
    UIKit.Tween(self.Glow, {
        BackgroundTransparency = 0.9
    }, 0.6)
    UIKit.Tween(self.Word, {
        TextTransparency = 0
    }, 0.2)
end

function t1:GetValue() -- line: 183
    return self.Target
end

function t1:FadeOut(p13) -- line: 188
    -- upvalues: UIKit (copy)
    if self.Holder then
        local Holder = self.Holder

        UIKit.PopOut(Holder, p13 or 0.25, 0.7).Completed:Once(function() -- line: 191
            -- upvalues: self (copy)
            self:Destroy()
        end)
    end
end

function t1:Destroy() -- line: 196
    if self.Conn then
        self.Conn:Disconnect()
        self.Conn = nil
    end

    if self.Holder then
        self.Holder:Destroy()
        self.Holder = nil
    end
end

return t1

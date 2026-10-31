-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LuckyCatch = require(ReplicatedStorage.Shared.LuckyCatch)
local Parent = script.Parent
local ShopUI = require(Parent.ShopUI)
local Sounds = require(Parent.Sounds)
local ScreenFX = require(Parent.ScreenFX)
local CameraRig = require(Parent.CameraRig)
local t1 = {}

t1.__index = t1

local Config = LuckyCatch.Config
local Tiers = Config.Tiers
local LocalPlayer = Players.LocalPlayer

local function rgb(p1, p2, p3) -- line: 56
    return Color3.fromRGB(p1, p2, p3)
end

local t2 = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 170, 40),
    Color3.fromRGB(255, 240, 60),
    Color3.fromRGB(70, 230, 90),
    Color3.fromRGB(60, 200, 255),
    Color3.fromRGB(90, 100, 255),
    rgb(200, 80, 255)
}

local function scaleOf(p4) -- line: 59
    local UIScale = p4:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p4
    end

    return UIScale
end

local function setGradient(p5, p6, p7) -- line: 68
    local UIGradient = p5:FindFirstChildOfClass("UIGradient")

    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = 90
        UIGradient.Parent = p5
    end

    UIGradient.Color = ColorSequence.new(p6, p7)
end

function t1.new(p8) -- line: 82
    -- upvalues: RunService (copy), LuckyCatch (copy), t1 (copy), Config (copy), Tiers (copy)
    local Lucky = p8.Lucky
    local self = setmetatable({}, t1)

    self.Result = p8
    self.OneIn = math.max(2, Lucky.OneIn or 2)
    self.LogN = math.log10(self.OneIn)
    self.Chance = Lucky.Chance or Config.MaxChance
    self.FinalTier = math.clamp(Lucky.Tier or 1, 1, #Tiers)
    self.Intensity = LuckyCatch.Intensity(self.Chance)
    self.Phase = "Idle"
    self.PhaseStart = os.clock()
    self.PhaseDuration = 1
    self.Log = 0
    self.HoldLog = 0
    self.Value = 1
    self.Digits = 1
    self.Tier = 0
    self.NextTick = 0
    self.LastDigitFx = 0
    self.Width = 0
    self.LineStrength = 0
    self.Sparkles = {}
    self.SparkleCarry = 0
    self.Rainbow = false
    self.Dead = false
    self:_build()
    self.Conn = RunService.RenderStepped:Connect(function(p9) -- line: 108
        -- upvalues: self (copy)
        self:_update(p9)
    end)

    return self
end

function t1:_build() -- line: 114
    -- upvalues: ShopUI (copy), Tiers (copy), LocalPlayer (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "LuckyCatch"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 220
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.Gui = ScreenGui

    local v5 = ShopUI.Frame({
        Name = "Counter",
        Transparency = 1,
        ZIndex = 5,
        Parent = ScreenGui,
        Size = UDim2.fromScale(0.36, 0.2),
        Position = UDim2.fromScale(0.5, 0.035),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    self.Root = v5

    local UIScale = v5:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = v5
    end

    self.RootScale = UIScale
    self.GlowParts = {}

    for v6, v7 in ipairs({ 1, 0.78, 0.56 }) do
        local v8 = ShopUI.Frame({
            Transparency = 1,
            ZIndex = 3,
            Parent = v5,
            Name = "Glow" .. v6,
            Size = UDim2.fromScale(0.95 * v7, 0.95 * v7),
            Position = UDim2.fromScale(0.5, 0.63),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Tiers[1].Colors[2],
            Corner = UDim.new(0.5, 0)
        })

        table.insert(self.GlowParts, v8)
    end

    self.GlowAlpha = 0.1

    local v9 = ShopUI.Text({
        Name = "Tier",
        Text = "",
        ZIndex = 8,
        Stroke = 4,
        Parent = v5,
        Size = UDim2.fromScale(2.6, 0.34),
        Position = UDim2.fromScale(0.5, 0.13),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Tiers[1].Colors[1],
            Tiers[1].Colors[2],
            90
        }
    })

    v9.SizeConstraint = Enum.SizeConstraint.RelativeYY
    v9.Visible = false
    self.TierLabel = v9

    local UIScale2 = v9:FindFirstChildOfClass("UIScale")

    if not UIScale2 then
        UIScale2 = Instance.new("UIScale")
        UIScale2.Parent = v9
    end

    self.TierScale = UIScale2

    local v10 = ShopUI.Text({
        Name = "Odds",
        Text = "1 in 1",
        ZIndex = 9,
        Stroke = 5,
        Parent = v5,
        Size = UDim2.fromScale(1, 0.6),
        Position = UDim2.fromScale(0.5, 0.63),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.new(1, 1, 1),
            Color3.fromRGB(255, 236, 150),
            90
        }
    })

    self.CountLabel = v10

    local UIScale3 = v10:FindFirstChildOfClass("UIScale")

    if not UIScale3 then
        UIScale3 = Instance.new("UIScale")
        UIScale3.Parent = v10
    end

    self.CountScale = UIScale3
    self.CountStroke = v10:FindFirstChild("TextStroke")
    self:_setText("1 in 1")
    self.RootScale.Scale = 0
    ShopUI.Tween(self.RootScale, {
        Scale = 1
    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function t1:_setText(p12) -- line: 155
    self.CountLabel.Text = p12

    local v12 = math.clamp(#p12 * 0.026 + 0.2, 0.34, 0.94)

    if math.abs(v12 - self.Width) > 0.001 then
        self.Width = v12
        self.Root.Size = UDim2.fromScale(v12, 0.2)
    end
end

function t1:_color() -- line: 164
    -- upvalues: Tiers (copy)
    if self.Rainbow then
        return Color3.fromHSV(os.clock() * 0.45 % 1, 0.55, 1)
    end

    return Tiers[math.max(self.Tier, 1)].Colors[2]
end

function t1:_center() -- line: 176
    local CountLabel = self.CountLabel

    return CountLabel.AbsolutePosition + CountLabel.AbsoluteSize / 2, CountLabel.AbsoluteSize
end

function t1:_spawnSparkle(p16, p17, p18, p19) -- line: 181
    if #self.Sparkles >= 170 then
        return
    end

    local v14 = self.Gui.AbsoluteSize.Y / 700
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Sparkle"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
    ImageLabel.ImageColor3 = p18
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ZIndex = 10

    local v15 = (16 + math.random() * 26) * v14

    ImageLabel.Size = UDim2.fromOffset(v15, v15)

    local v16 = p16 + Vector2.new((math.random() - 0.5) * p17.X, (math.random() - 0.5) * p17.Y)

    ImageLabel.Position = UDim2.fromOffset(v16.X, v16.Y)
    ImageLabel.Parent = self.Gui

    local v17 = math.random() * 3.141592653589793 * 2
    local v18 = (80 + math.random() * 360) * v14 * (p19 or 1)

    table.insert(self.Sparkles, {
        Age = 0,
        Image = ImageLabel,
        Pos = v16,
        Vel = Vector2.new(math.cos(v17), (math.sin(v17))) * v18,
        Life = 0.5 + math.random() * 0.7,
        Size = v15,
        Spin = math.random(-300, 300)
    })
end

function t1:_burst(p21, p22, p23) -- line: 201
    local v19, v20 = self:_center()

    for _ = 1, p21 do
        self:_spawnSparkle(v19, v20 * 0.8, p22 or self:_color(), p23)
    end
end

function t1:_updateSparkles(p25) -- line: 208
    for i = #self.Sparkles, 1, -1 do
        local v21 = self.Sparkles[i]

        v21.Age += p25

        local v22 = v21.Age / v21.Life

        if v22 >= 1 or not v21.Image.Parent then
            v21.Image:Destroy()
            table.remove(self.Sparkles, i)
        else
            v21.Vel = v21.Vel * math.exp(-p25 * 2.2)
            v21.Pos += v21.Vel * p25
            v21.Image.Position = UDim2.fromOffset(v21.Pos.X, v21.Pos.Y)
            v21.Image.Rotation += v21.Spin * p25

            local v25 = math.min(v22 / 0.2, 1)
            local v28 = v21.Size * v25 * (1 - math.max(0, v22 - 0.6) / 0.4 * 0.6)

            v21.Image.Size = UDim2.fromOffset(v28, v28)
            v21.Image.ImageTransparency = math.max(0, v22 - 0.55) / 0.45
        end
    end
end

function t1:_rays(p27, p28) -- line: 229
    -- upvalues: ShopUI (copy), Tiers (copy)
    if self.Rays then
        self.Rays:Destroy()
    end

    local v30 = Tiers[p27]
    local v33 = ShopUI.Rays(self.Root, v30.Colors[1], {
        ZIndex = 2,
        Width = 0.1,
        Size = UDim2.fromScale(2.3, 2.3),
        Position = UDim2.fromScale(0.5, 0.62),
        Count = 6 + p27 * 2,
        Alpha = math.max(0.25, 0.62 - 0.06 * p27),
        Speed = 20 + 22 * p27
    })
    local UIScale = v33:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = v33
    end

    UIScale.Scale = 0
    ShopUI.Tween(UIScale, {
        Scale = p28 or 0.8 + 0.08 * p27
    }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    self.Rays = v33
end

function t1:_ensureLines() -- line: 240
    if self.Lines then
        return self.Lines
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "SpeedLines"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 1
    Frame.Parent = self.Gui

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Square"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeXX
    Frame2.Size = UDim2.fromScale(1.6, 1.6)
    Frame2.ZIndex = 1
    Frame2.Parent = Frame

    local t7 = {}
    local v35 = math.max(1, self.Gui.AbsoluteSize.Y / 700)

    for i = 1, 40 do
        local Frame = Instance.new("Frame")

        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromScale(0.5, 0.5)
        Frame.Size = UDim2.new(0, math.random(2, 5) * v35, 1, 0)
        Frame.Rotation = (i - 1) * 180 / 40 + math.random() * 3
        Frame.ZIndex = 1

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.32, 1),
            NumberSequenceKeypoint.new(0.68, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
        UIGradient.Parent = Frame
        Frame.Parent = Frame2
        t7[i] = Frame
    end

    self.Lines = {
        Holder = Frame,
        Square = Frame2,
        Bars = t7
    }

    return self.Lines
end

function t1:_updateLines(_) -- line: 281
    if not self.Lines and self.LineStrength <= 0.01 then
        return
    end

    local v36 = self:_ensureLines()
    local LineStrength = self.LineStrength

    v36.Holder.Visible = LineStrength > 0.01

    if LineStrength <= 0.01 then
        return
    end

    v36.Square.Rotation = math.random() * 4.5

    local v37 = self.Rainbow and self:_color() or Color3.new(1, 1, 1)

    for _, v38 in ipairs(v36.Bars) do
        v38.BackgroundTransparency = 1 - LineStrength * (0.15 + math.random() * 0.55)
        v38.BackgroundColor3 = v37
    end
end

function t1:_rain(p33, p34, p35) -- line: 296
    -- upvalues: TweenService (copy)
    local Gui = self.Gui

    for _ = 1, p34 do
        task.delay(math.random() * (p35 or 1.2), function() -- line: 299
            -- upvalues: self (copy), p33 (copy), Gui (copy), TweenService (copy)
            if self.Dead or not Gui.Parent then
                return
            end

            local AbsoluteSize = Gui.AbsoluteSize
            local v39 = AbsoluteSize.Y * (0.045 + math.random() * 0.045)
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Rain"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = p33
            ImageLabel.Size = UDim2.fromOffset(v39, v39)
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)

            local v40 = math.random() * AbsoluteSize.X

            ImageLabel.Position = UDim2.fromOffset(v40, -v39)
            ImageLabel.Rotation = math.random(0, 360)
            ImageLabel.ZIndex = 2
            ImageLabel.Parent = Gui

            local v41 = 1.3 + math.random() * 1.1

            TweenService:Create(ImageLabel, TweenInfo.new(v41, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.fromOffset(v40 + (math.random() - 0.5) * AbsoluteSize.X * 0.25, AbsoluteSize.Y + v39),
                Rotation = ImageLabel.Rotation + math.random(-420, 420)
            }):Play()
            task.delay(v41, function() -- line: 319
                -- upvalues: ImageLabel (copy)
                ImageLabel:Destroy()
            end)
        end)
    end
end

function t1:_applyTier(p37) -- line: 329
    -- upvalues: ScreenFX (copy), Tiers (copy), t2 (copy)
    local v42 = Tiers[p37]

    self.TierLabel.Text = v42.Name

    local TierLabel = self.TierLabel
    local v43 = v42.Colors[1]
    local v44 = v42.Colors[2]
    local UIGradient = TierLabel:FindFirstChildOfClass("UIGradient")

    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = 90
        UIGradient.Parent = TierLabel
    end

    UIGradient.Color = ColorSequence.new(v43, v44)

    local CountLabel = self.CountLabel
    local v45 = Color3.new(1, 1, 1)
    local v46 = v42.Colors[1]
    local UIGradient2 = CountLabel:FindFirstChildOfClass("UIGradient")

    if not UIGradient2 then
        UIGradient2 = Instance.new("UIGradient")
        UIGradient2.Rotation = 90
        UIGradient2.Parent = CountLabel
    end

    UIGradient2.Color = ColorSequence.new(v45, v46)

    for _, v47 in ipairs(self.GlowParts) do
        v47.BackgroundColor3 = v42.Colors[2]
    end

    self.GlowAlpha = 0.1 + 0.03 * p37

    if p37 >= 2 or self.Phase == "Landed" then
        self:_rays(p37)
    end

    if not v42.Rainbow or self.Rainbow then
        return
    end

    self.Rainbow = true
    ScreenFX.SetVignetteStyle({
        Speed = 2.5,
        Rainbow = t2
    })
    ScreenFX.SetVignette(0.85, 0.25)
end

function t1:_digit(p39) -- line: 345
    -- upvalues: ShopUI (copy), Sounds (copy), CameraRig (copy)
    local v48 = math.min(p39, 22)

    self.CountScale.Scale = 1.1 + 0.08 * self.Intensity + v48 * 0.004
    ShopUI.Tween(self.CountScale, {
        Scale = 1
    }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Sounds.Play("LuckyDigit", {
        Pitch = v48 * 0.05 + 1,
        Volume = 0.45 + 0.25 * self.Intensity
    })

    if CameraRig.IsActive() then
        CameraRig.Shake(0.15 + 0.3 * self.Intensity + v48 * 0.015, 0.2, 22)
    end

    if self.CountStroke then
        self.CountStroke.Color = Color3.new(1, 1, 1)
        ShopUI.Tween(self.CountStroke, {
            Color = ShopUI.Outline
        }, 0.18)
    end

    self:_burst(v48 * 2 + 5, self:_color())
end

function t1:_tierUp(p41) -- line: 361
    -- upvalues: ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), Tiers (copy)
    local v49 = Tiers[p41]

    self:_applyTier(p41)
    self.TierLabel.Visible = true
    self.TierScale.Scale = 2.4
    ShopUI.Tween(self.TierScale, {
        Scale = 1
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    self.TierLabel.Rotation = p41 % 2 == 0 and 4 or -4
    self.CountScale.Scale = 1.35
    ShopUI.Tween(self.CountScale, {
        Scale = 1
    }, 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    Sounds.Play("LuckyTierUp", {
        Pitch = 1 + 0.08 * (p41 - 1)
    })
    Sounds.Play("LuckyTierBass", {
        Pitch = 1 + 0.05 * p41
    })
    ScreenFX.Flash(v49.Colors[2], 0.16 + 0.06 * p41, 0.5)
    ScreenFX.Ring(v49.Colors[1], 0.7, 60)

    if p41 >= 3 then
        task.delay(0.1, function() -- line: 375
            -- upvalues: v49 (copy), ScreenFX (copy)
            ScreenFX.Ring(v49.Colors[2], 0.8, 40)
        end)
        ScreenFX.PulseVignette(1, 0.7, v49.Colors[2])
        self.LineStrength = math.max(self.LineStrength, 0.55 + 0.1 * (p41 - 3))
    end

    if CameraRig.IsActive() then
        CameraRig.Shake(0.45 + 0.25 * p41, 0.45, 18)
        CameraRig.PunchFOV(3 + 2 * p41, 0.05, 0.45)
    end

    self:_burst(14 + 8 * p41, v49.Colors[2], 1.3)

    if p41 >= 2 then
        local v51 = self:_center()

        ShopUI.Confetti(self.Gui, v51, 16 + 14 * p41, {
            ZIndex = 11,
            Direction = 90,
            Spread = 80,
            MinSpeed = 150,
            MaxSpeed = 480,
            Gravity = 700
        })
    end

    if p41 >= 4 then
        self:_rain(ShopUI.Icons.Clover, 6 + 4 * p41, 0.6)
    end
end

function t1:_logAt(p43) -- line: 397
    -- upvalues: Config (copy)
    local Phase = self.Phase

    if Phase == "POV" then
        local v53 = math.clamp((p43 - self.PhaseStart) / self.PhaseDuration, 0, 1)

        return self.LogN * Config.POVShare * v53 ^ 1.7
    end

    if Phase == "Hold" then
        return self.HoldLog
    end

    if Phase == "Zoom" then
        local v55 = math.clamp((p43 - self.PhaseStart) / self.PhaseDuration, 0, 1)

        return self.HoldLog + (self.LogN - self.HoldLog) * v55 ^ 1.45
    end

    if Phase == "Landed" then
        return self.LogN
    end

    return self.Log
end

function t1:_update(p45) -- line: 413
    -- upvalues: LuckyCatch (copy), Sounds (copy)
    if not self.Dead then
        if self.Gui.Parent then
            local elapsed = os.clock()
            local v56 = self:_logAt(elapsed)
            local v58 = math.max(0, (v56 - self.Log) / math.max(p45, 0.004166666666666667))

            self.Log = v56

            local v59 = self.Phase == "POV" or self.Phase == "Zoom"
            local v60 = if self.Phase == "Landed" then self.OneIn else math.max(1, (math.min(math.floor(10 ^ v56), self.OneIn - 1)))

            if v60 ~= self.Value then
                self.Value = v60
                self:_setText(LuckyCatch.Text(v60))
            end

            if v59 and v58 > 0.01 and self.NextTick <= elapsed then
                local v65 = v56 / math.max(self.LogN, 1)

                Sounds.Play("LuckyTick", {
                    Pitch = 0.9 + v65 * 1.1 + self.Tier * 0.04,
                    Volume = 0.2 + 0.18 * v65
                })
                self.NextTick = elapsed + math.clamp(0.2 / (v58 * 1.2 + 0.35), 0.035, 0.22)
            end

            local v68 = math.floor(v56 + 1E-09) + 1

            if v59 and self.Digits < v68 then
                self.Digits = v68

                if elapsed - self.LastDigitFx > 0.07 then
                    self.LastDigitFx = elapsed
                    self:_digit(v68)
                end
            end

            while v59 and self.Tier < self.FinalTier and LuckyCatch.TierOdds(self.Tier + 1) <= v60 do
                self.Tier += 1
                self:_tierUp(self.Tier)
            end

            local v69 = self.Gui.AbsoluteSize.Y / 700

            if v59 then
                local v70 = math.min(v58, 8) * v69 * (0.4 + self.Intensity) * (if self.Tier >= 2 then 1.6 else 0.8)

                self.Root.Position = UDim2.new(0.5, (math.random() - 0.5) * v70, 0.035, (math.random() - 0.5) * v70)

                local v72 = math.min(2 + v58 * 6 * (0.5 + self.Intensity), 40)

                self.SparkleCarry += v72 * p45
            elseif self.Phase == "Landed" then
                self.Root.Position = UDim2.new(0.5, 0, 0.035, math.sin(elapsed * 3) * 4 * v69)
                self.SparkleCarry += (6 + 26 * self.Intensity) * p45
            else
                self.Root.Position = UDim2.fromScale(0.5, 0.035)
                self.SparkleCarry += 3 * p45
            end

            while self.SparkleCarry >= 1 do
                self.SparkleCarry -= 1

                local v74, v75 = self:_center()

                self:_spawnSparkle(v74, v75 * 1.1, self:_color(), 0.5)
            end

            self:_updateSparkles(p45)

            local v77 = self.GlowAlpha * (math.sin(elapsed * 5) * 0.2 + 0.8)

            for _, v78 in ipairs(self.GlowParts) do
                v78.BackgroundTransparency = 1 - v77 * (self.Tier > 0 and 1 or 0.6)
            end

            if self.Rainbow then
                local v79 = elapsed * 0.45 % 1
                local v80 = Color3.fromHSV(v79, 0.35, 1)
                local v81 = Color3.fromHSV((v79 + 0.18) % 1, 0.75, 1)
                local CountLabel = self.CountLabel
                local UIGradient = CountLabel:FindFirstChildOfClass("UIGradient")

                if not UIGradient then
                    UIGradient = Instance.new("UIGradient")
                    UIGradient.Rotation = 90
                    UIGradient.Parent = CountLabel
                end

                UIGradient.Color = ColorSequence.new(v80, v81)

                local TierLabel = self.TierLabel
                local v82 = Color3.new(1, 1, 1)
                local UIGradient2 = TierLabel:FindFirstChildOfClass("UIGradient")

                if not UIGradient2 then
                    UIGradient2 = Instance.new("UIGradient")
                    UIGradient2.Rotation = 90
                    UIGradient2.Parent = TierLabel
                end

                UIGradient2.Color = ColorSequence.new(v82, v81)

                for _, v83 in ipairs(self.GlowParts) do
                    v83.BackgroundColor3 = v81
                end

                if self.Rays then
                    for _, child in ipairs(self.Rays:GetChildren()) do
                        if child:IsA("Frame") then
                            child.BackgroundColor3 = v80
                        end
                    end
                end
            end

            if self.Phase ~= "Zoom" or not (self.FinalTier >= 3) then
                self.LineStrength = self.LineStrength * math.exp(-p45 * 2.2)
            else
                local v86 = math.clamp((elapsed - self.PhaseStart) / self.PhaseDuration, 0, 1)

                self.LineStrength = math.max(self.LineStrength * math.exp(-p45 * 2.5), 0.15 + v86 * 0.6 * self.Intensity)
            end

            self:_updateLines(p45)
        else
            self:Finish()
        end
    end
end

function t1:StartPOV(p47) -- line: 516
    -- upvalues: Sounds (copy)
    self.Phase = "POV"
    self.PhaseStart = os.clock()
    self.PhaseDuration = math.max(p47 or 5, 0.5)
    Sounds.Play("LuckyShine", {
        Volume = 0.5,
        Pitch = 1.5
    })
end

function t1:Hold() -- line: 524
    -- upvalues: ShopUI (copy), Sounds (copy)
    self.HoldLog = self.Log
    self.Phase = "Hold"
    task.spawn(function() -- line: 527
        -- upvalues: self (copy), ShopUI (copy), Sounds (copy)
        for i = 1, 2 do
            if self.Dead or self.Phase ~= "Hold" then
                return
            end

            Sounds.Play("LuckyHeartbeat", {
                Pitch = i * 0.06 + 0.5,
                Volume = 0.5 + 0.2 * self.Intensity
            })
            self.CountScale.Scale = 1.14
            ShopUI.Tween(self.CountScale, {
                Scale = 1
            }, 0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            self.GlowAlpha = math.min(self.GlowAlpha + 0.05, 0.35)
            task.wait(0.38)
        end
    end)
end

function t1:StartZoom(p50) -- line: 540
    -- upvalues: Sounds (copy), ScreenFX (copy), t2 (copy)
    self.HoldLog = self.Log
    self.Phase = "Zoom"
    self.PhaseStart = os.clock()
    self.PhaseDuration = math.max(p50 or 2, 0.2)
    self.Riser = Sounds.Play("LuckyRiser", {
        Start = math.max(0, 4 - self.PhaseDuration * 1.25),
        Volume = 0.55 + 0.35 * self.Intensity
    })

    if self.Rainbow then
        ScreenFX.SetVignetteStyle({
            Speed = 3,
            Rainbow = t2
        })
        ScreenFX.SetVignette(0.85, 0.2)
    end
end

function t1:Land(p52, p53, p54) -- line: 556
    -- upvalues: LuckyCatch (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), Tiers (copy), t2 (copy)
    if self.Dead then
        return
    end

    self.Phase = "Landed"
    self.Log = self.LogN
    self.Value = self.OneIn
    self:_setText(LuckyCatch.Text(self.OneIn))

    if self.Riser and self.Riser.Parent then
        self.Riser:Destroy()
    end

    if self.Tier < self.FinalTier then
        self.Tier = self.FinalTier
    end

    self:_applyTier(self.FinalTier)

    local Intensity, FinalTier = self.Intensity, self.FinalTier
    local v94 = Tiers[FinalTier]

    self.TierLabel.Visible = true
    self.TierScale.Scale = 2.8
    ShopUI.Tween(self.TierScale, {
        Scale = 1
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    self.CountScale.Scale = 2.1
    ShopUI.Tween(self.CountScale, {
        Scale = 1
    }, 0.9, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    self:_rays(math.max(FinalTier, 2), 1.15 + 0.1 * FinalTier)
    Sounds.Play("LuckySlam")
    Sounds.Play("LuckyBurst")
    Sounds.Play("LuckyShine", {
        Delay = 0.05
    })
    Sounds.Play("AnnounceBass", {
        Delay = 0.08
    })
    Sounds.Play("CoinBurst", {
        Delay = 0.12
    })

    if FinalTier >= 2 then
        Sounds.Play("LevelUp", {
            Delay = 0.2,
            Volume = 0.8
        })
    end

    if FinalTier >= 3 then
        Sounds.Play("LuckyTierUp", {
            Delay = 0.35,
            Pitch = 1.3
        })
    end

    if FinalTier >= 4 then
        Sounds.Play("LuckySlam", {
            Delay = 0.5,
            Pitch = 0.7
        })
        Sounds.Play("EggBurst", {
            Delay = 0.55
        })
    end

    ScreenFX.Flash(Color3.new(1, 1, 1), 0.5 + 0.25 * Intensity, 0.5)
    task.delay(0.1, function() -- line: 594
        -- upvalues: Intensity (copy), v94 (copy), ScreenFX (copy)
        ScreenFX.Flash(v94.Colors[2], 0.3 + 0.2 * Intensity, 1)
    end)

    for i = 1, 2 + FinalTier do
        task.delay((i - 1) * 0.07, function() -- line: 596
            -- upvalues: v94 (copy), i (copy), ScreenFX (copy)
            ScreenFX.Ring(i % 2 == 0 and v94.Colors[1] or v94.Colors[2], i * 0.1 + 0.8, 40)
        end)
    end

    if CameraRig.IsActive() then
        CameraRig.Shake(1 + 1.8 * Intensity, 0.6 + 0.6 * Intensity, 15)
        CameraRig.PunchFOV(10 + 12 * Intensity, 0.05, 0.8)
    end

    if FinalTier >= 3 then
        self.LineStrength = 1
    end

    local Gui = self.Gui
    local AbsoluteSize = Gui.AbsoluteSize
    local v95 = self:_center()

    ShopUI.Confetti(Gui, v95, math.floor(40 + 70 * Intensity), {
        ZIndex = 11,
        Direction = 90,
        Spread = 90,
        MinSpeed = 200,
        MaxSpeed = 620,
        Gravity = 800
    })
    ShopUI.Confetti(Gui, Vector2.new(AbsoluteSize.X * 0.05, AbsoluteSize.Y), math.floor(25 + 45 * Intensity), {
        ZIndex = 11,
        Direction = -62,
        Spread = 18
    })
    ShopUI.Confetti(Gui, Vector2.new(AbsoluteSize.X * 0.95, AbsoluteSize.Y), math.floor(25 + 45 * Intensity), {
        ZIndex = 11,
        Direction = -118,
        Spread = 18
    })
    self:_burst(math.floor(40 + 80 * Intensity), v94.Colors[2], 1.6)

    if FinalTier >= 3 then
        self:_rain(ShopUI.Icons.Clover, math.floor(14 + 26 * Intensity), 1.4)
    end

    if FinalTier >= 5 then
        self:_rain(ShopUI.Icons.Cash, 24, 1.8)
    end

    if FinalTier >= 4 then
        for i = 1, 3 do
            task.delay(i * 0.35, function() -- line: 622
                -- upvalues: self (copy), Intensity (copy), Gui (copy), AbsoluteSize (copy), ShopUI (copy), ScreenFX (copy), CameraRig (copy)
                if self.Dead then
                    return
                end

                for i = 1, 5 do
                    ShopUI.Confetti(Gui, Vector2.new(AbsoluteSize.X * ((i - 1) * 0.2 + 0.1), -10), 14, {
                        ZIndex = 11,
                        Direction = 90,
                        Spread = 35,
                        MinSpeed = 120,
                        MaxSpeed = 360,
                        Gravity = 520
                    })
                end

                ScreenFX.Ring(Color3.fromHSV(math.random(), 0.6, 1), 0.8, 40)

                if CameraRig.IsActive() then
                    CameraRig.Shake(0.5 + 0.5 * Intensity, 0.3, 18)
                end
            end)
        end
    end

    if p52 then
        self:_worldBurst(p52, p53, p54, v94)
    end

    if self.Rainbow then
        task.delay(1, function() -- line: 639
            -- upvalues: self (copy), ScreenFX (copy), t2 (copy)
            if not self.Dead then
                ScreenFX.SetVignetteStyle({
                    Speed = 1.6,
                    Rainbow = t2
                })
                ScreenFX.SetVignette(0.6, 0.4)
            end
        end)
    end
end

function t1:_worldBurst(p56, p57, p58, p59) -- line: 647
    -- upvalues: TweenService (copy)
    local v103 = p58
    local Intensity = self.Intensity
    local v104 = p57 and p57.Magnitude / 2 or 3

    v103 = p58 or workspace

    local function part(p60) -- line: 651
        -- upvalues: v103 (ref)
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false

        for v105, v106 in pairs(p60) do
            Part[v105] = v106
        end

        Part.Parent = v103

        return Part
    end

    local v108 = math.max(v104 * 1.5, 3)
    local t9 = {
        Transparency = 0.3,
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = p59.Colors[1],
        Size = Vector3.new(160, v108, v108),
        CFrame = CFrame.new(p56 + Vector3.new(0, 80 - v104, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false

    for v110, v111 in pairs(t9) do
        Part[v110] = v111
    end

    Part.Parent = v103
    TweenService:Create(Part, TweenInfo.new(1.6 + Intensity, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1,
        Size = Vector3.new(160, v108 * 0.15, v108 * 0.15)
    }):Play()

    local t11 = {
        Transparency = 0.15,
        Size = Vector3.new(0.2, 2, 2),
        Shape = Enum.PartType.Cylinder,
        Material = Enum.Material.Neon,
        Color = p59.Colors[2],
        CFrame = CFrame.new(p56 - Vector3.new(0, v104 * 0.8, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false

    for v116, v117 in pairs(t11) do
        Part2[v116] = v117
    end

    Part2.Parent = v103
    TweenService:Create(Part2, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.2, v104 * 10 + 30, v104 * 10 + 30)
    }):Play()

    local t13 = {
        Transparency = 1,
        Size = Vector3.new(1, 1, 1),
        Position = p56
    }
    local Part3 = Instance.new("Part")

    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanQuery = false
    Part3.CanTouch = false
    Part3.CastShadow = false

    for v121, v122 in pairs(t13) do
        Part3[v121] = v122
    end

    Part3.Parent = v103

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(p59.Colors[1], p59.Colors[2])
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, (math.clamp(v104 * 0.35, 0.8, 5))),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.8)
    ParticleEmitter.Speed = NumberRange.new(v104 * 3 + 8, v104 * 6 + 22)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 2
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part3
    ParticleEmitter:Emit((math.floor(60 + 160 * Intensity)))

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p59.Colors[2]
    PointLight.Range = math.min(v104 * 4 + 24, 60)
    PointLight.Brightness = 8
    PointLight.Parent = Part3
    TweenService:Create(PointLight, TweenInfo.new(2, Enum.EasingStyle.Quad), {
        Brightness = 0
    }):Play()

    if self.Rainbow then
        task.spawn(function() -- line: 690
            -- upvalues: Part (copy)
            local elapsed = os.clock()

            while Part.Parent and os.clock() - elapsed < 3 do
                Part.Color = Color3.fromHSV(os.clock() * 0.6 % 1, 0.6, 1)
                task.wait()
            end
        end)
    end

    task.delay(3, function() -- line: 698
        -- upvalues: Part (copy), Part2 (copy), Part3 (copy)
        Part:Destroy()
        Part2:Destroy()
        Part3:Destroy()
    end)
end

function t1:Finish() -- line: 705
    -- upvalues: ShopUI (copy), ScreenFX (copy)
    if self.Dead then
        return
    end

    self.Dead = true

    if self.Conn then
        self.Conn:Disconnect()
    end

    if self.Riser and self.Riser.Parent then
        self.Riser:Destroy()
    end

    if self.Rainbow then
        ScreenFX.SetVignetteStyle(nil)
    end

    local Gui = self.Gui

    if Gui.Parent then
        ShopUI.Tween(self.RootScale, {
            Scale = 0
        }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)

        if self.Lines then
            self.Lines.Holder.Visible = false
        end
    end

    task.delay(0.3, function() -- line: 716
        -- upvalues: Gui (copy)
        Gui:Destroy()
    end)
end

return t1

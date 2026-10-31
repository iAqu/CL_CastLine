-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

game:GetService("TweenService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local t1 = {}

t1.__index = t1

local function inTapZone(p1) -- line: 55
    -- upvalues: GuiService (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return true
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local GuiInset = GuiService:GetGuiInset()
    local X = p1.Position.X
    local v1 = p1.Position.Y + GuiInset.Y
    local v2 = ViewportSize.X * 0.06
    local v3 = ViewportSize.Y * 0.05

    if v2 <= X and X <= ViewportSize.X - v2 and v3 <= v1 then
        return v1 <= ViewportSize.Y - v3
    end

    return false
end

local function onObject(p2, p3) -- line: 67
    if not (p2 and p2.Parent and p2.Visible) then
        return false
    end

    local AbsolutePosition, AbsoluteSize = p2.AbsolutePosition, p2.AbsoluteSize
    local X, Y = p3.Position.X, p3.Position.Y

    if AbsolutePosition.X - 6 <= X and X <= AbsolutePosition.X + AbsoluteSize.X + 6 and AbsolutePosition.Y - 6 <= Y then
        return Y <= AbsolutePosition.Y + AbsoluteSize.Y + 6
    end

    return false
end

local function ratingFor(p4) -- line: 74
    -- upvalues: GameConfig (copy)
    for _, v4 in ipairs(GameConfig.Throw.MeterRatings) do
        if v4.Min <= p4 then
            return v4
        end
    end

    return GameConfig.Throw.MeterRatings[#GameConfig.Throw.MeterRatings]
end

function t1.new(p5) -- line: 81
    -- upvalues: UITheme (copy), UIKit (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Gui = p5

    local v6 = UIKit.Frame({
        Name = "Meter",
        Transparency = 1,
        ZIndex = 10,
        Parent = p5,
        Size = UDim2.fromScale(0.2, 0.7),
        Position = UDim2.fromScale(0.5, 0.52),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    self.Holder = v6

    local v7 = UIKit.Frame({
        Name = "Bar",
        Corner = 22,
        Stroke = 6,
        ZIndex = 11,
        Clip = false,
        Parent = v6,
        Size = UDim2.fromScale(1, 0.8),
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(255, 255, 255)
    })
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 0.2
    UIAspectRatioConstraint.Parent = v7

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 245, 90)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(150, 240, 70)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 215, 60)),
        ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 130, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 50, 50))
    })
    UIGradient.Parent = v7
    UIKit.Stripes(v7, 0, 0.92, 22)

    for i = 1, 5 do
        UIKit.Frame({
            Name = "Seg",
            ZIndex = 13,
            Parent = v7,
            Size = UDim2.new(1, 0, 0, 5),
            Position = UDim2.fromScale(0, i / 6),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = Color3.new(0, 0, 0)
        })
    end

    UIKit.Frame({
        Name = "Shine",
        Transparency = 0.7,
        Corner = 10,
        ZIndex = 12,
        Parent = v7,
        Size = UDim2.fromScale(0.22, 0.97),
        Position = UDim2.fromScale(0.1, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = Color3.new(1, 1, 1)
    }).Name = "Shine"

    local v8 = UIKit.Frame({
        Name = "Marker",
        Corner = 8,
        Stroke = 4,
        ZIndex = 15,
        Parent = v7,
        Size = UDim2.new(1.35, 0, 0.045, 0),
        Position = UDim2.fromScale(0.5, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1)
    })
    local v9 = UIKit.Frame({
        Name = "Glow",
        Transparency = 0.8,
        Corner = 12,
        ZIndex = 14,
        Parent = v8,
        Size = UDim2.new(1.15, 0, 2.6, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1)
    })

    self.Bar = v7
    self.Marker = v8
    self.Glow = v9
    self.MultLabel = UIKit.Text({
        Text = "+0",
        ZIndex = 16,
        Stroke = 3,
        Parent = v8,
        Size = UDim2.new(1.3, 0, 3.2, 0),
        Position = UDim2.new(1.25, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })
    self.Blockers = {}
    self.TapsBlocked = false
    self.Locked = false
    self.IgnoreUntil = 0

    local v10 = UIKit.Text({
        Name = "Prompt",
        Text = "TAP TO THROW!",
        ZIndex = 12,
        Parent = v6,
        Size = UDim2.fromScale(1.6, 0.11),
        Position = UDim2.fromScale(0.5, 0.9),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Stroke = UITheme.Stroke.TextBig
    })

    self.Prompt = v10

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v10
    self.PromptScale = UIScale
    UIKit.PopIn(v6, 0.45, 0.5)

    return self
end

function t1:Run() -- line: 139
    -- upvalues: UserInputService (copy), RunService (copy), GameConfig (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), t1 (copy), inTapZone (copy), onObject (copy)
    local Throw = GameConfig.Throw
    local n1 = 0
    local n2 = 1
    local v11 = true
    local n3 = 0
    local elapsed = os.clock()
    local v12 = false

    if t1.TestAutoTap then
        task.delay(t1.TestAutoTap, function() -- line: 148
            -- upvalues: v12 (ref)
            v12 = true
        end)
    end

    local connection = UserInputService.InputBegan:Connect(function(p7) -- line: 150
        -- upvalues: self (copy), elapsed (copy), v12 (ref), inTapZone (copy), onObject (copy)
        if v12 or self.TapsBlocked or os.clock() < self.IgnoreUntil then
            return
        end

        local UserInputType = p7.UserInputType

        if UserInputType ~= Enum.UserInputType.Touch or inTapZone(p7) then
            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                for _, v13 in ipairs(self.Blockers) do
                    if onObject(v13, p7) then
                        return
                    end
                end
            end

            if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.Keyboard and (p7.KeyCode == Enum.KeyCode.Space or p7.KeyCode == Enum.KeyCode.Return) or UserInputType == Enum.UserInputType.Gamepad1 and p7.KeyCode == Enum.KeyCode.ButtonA) and os.clock() - elapsed > 0.35 then
                v12 = true
            end
        end
    end)
    local connection2 = RunService.RenderStepped:Connect(function(p8) -- line: 169
        -- upvalues: self (copy), Throw (copy), n1 (ref), n2 (ref), v11 (ref), n3 (ref), v12 (ref), Sounds (copy)
        if v11 then
            if v12 then
                v11 = false
            else
                if self.Locked then
                    n1 += (1 - n1) * math.min(1, p8 * 14)

                    if n1 > 0.999 then
                        n1 = 1
                    end

                    self.Marker.Position = UDim2.fromScale(0.5, 1 - n1)
                    self.MultLabel.Text = string.format("+%d", Throw.MeterBonusStuds)
                else
                    local v18 = Throw.MeterBaseSpeed * (1 + (Throw.MeterTopSpeedFactor - 1) * n1)

                    n1 += n2 * v18 * p8

                    if n1 >= 1 then
                        n1 = 1
                        n2 = -1
                    elseif n1 <= 0 then
                        n1 = 0
                        n2 = 1
                    end

                    self.Marker.Position = UDim2.fromScale(0.5, 1 - n1)
                    self.MultLabel.Text = string.format("+%d", (math.floor(Throw.MeterBonusStuds * n1 + 0.5)))

                    local v22 = math.floor(n1 * 6)

                    if v22 ~= n3 then
                        n3 = v22
                        Sounds.Play("ThrowMeterTick", {
                            Volume = 0.25,
                            Pitch = n1 * 0.5 + 0.9
                        })
                    end
                end

                self.PromptScale.Scale = math.sin(os.clock() * 6) * 0.05 + 1
            end
        end
    end)

    while v11 do
        task.wait()
    end

    connection2:Disconnect()
    connection:Disconnect()

    local v24 = if self.Locked then 1 else n1
    local v25 = false
    local v26

    for _, v27 in ipairs(GameConfig.Throw.MeterRatings) do
        if v27.Min <= v24 then
            v26 = v27
            v25 = true
            break
        end
    end

    if not v25 then
        v26 = GameConfig.Throw.MeterRatings[#GameConfig.Throw.MeterRatings]
    end

    local v29 = math.floor(Throw.MeterBonusStuds * v24 + 0.5)

    self.Marker.BackgroundColor3 = v26.Color
    self.Glow.BackgroundColor3 = v26.Color
    UIKit.Tween(self.Glow, {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1.6, 0, 4, 0)
    }, 0.12)
    task.delay(0.12, function() -- line: 210
        -- upvalues: self (copy), UIKit (copy)
        UIKit.Tween(self.Glow, {
            BackgroundTransparency = 0.85,
            Size = UDim2.new(1.15, 0, 2.6, 0)
        }, 0.35)
    end)
    UIKit.Punch(self.Marker, 0.35, 0.4)
    self.Prompt.Text = v26.Text
    self.Prompt.TextColor3 = v26.Color
    UIKit.Punch(self.Prompt, 0.6, 0.5)
    Sounds.Play("ButtonClick", {
        Volume = 0.8,
        Pitch = 0.9 + v24 * 0.5
    })

    if v24 >= 0.92 then
        Sounds.Play("LevelUp", {
            Volume = 0.5,
            Pitch = 1.3
        })
        ScreenFX.Flash(v26.Color, 0.35, 0.35)
        CameraRig.PunchFOV(6, 0.05, 0.3)
    end

    CameraRig.Shake(0.3 + v24 * 0.4, 0.25, 22)
    UIKit.Popup(self.Gui, string.format("+%d POWER", v29), {
        Duration = 1,
        Position = UDim2.fromScale(0.62, 0.5),
        Size = UDim2.fromScale(0.2, 0.07),
        Color = v26.Color
    })

    return v24, v26, v29
end

function t1:AddBlocker(p10) -- line: 228
    table.insert(self.Blockers, p10)
end

function t1:SetTapsBlocked(p12) -- line: 235
    local v30 = p12 == true

    if self.TapsBlocked ~= v30 then
        self.TapsBlocked = v30

        if not v30 then
            self.IgnoreUntil = os.clock() + 0.45
        end
    end
end

function t1:SetLocked(p14) -- line: 246
    self.Locked = p14 == true
end

function t1:Hide() -- line: 250
    -- upvalues: UIKit (copy)
    if self.Holder then
        local Holder = self.Holder

        self.Holder = nil
        UIKit.PopOut(Holder, 0.25, 0.4).Completed:Once(function() -- line: 254
            -- upvalues: Holder (copy)
            Holder:Destroy()
        end)
    end
end

function t1:Destroy() -- line: 257
    if self.Holder then
        self.Holder:Destroy()
        self.Holder = nil
    end
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Parent = script.Parent
local ShopUI = require(Parent.ShopUI)
local UIScaler = require(Parent.UIScaler)
local Sounds = require(Parent.Sounds)
local ScreenFX = require(Parent.ScreenFX)
local CameraRig = require(Parent.CameraRig)
local RobuxPrices = require(Parent.RobuxPrices)
local DataController = require(Parent.DataController)
local HUDController = require(Parent.HUDController)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local SuperThrow = MonetizationConfig.SuperThrow
local v1 = SuperThrow and MonetizationConfig.Products[SuperThrow.Product]

local function rgb(p1, p2, p3) -- line: 79
    return Color3.fromRGB(p1, p2, p3)
end

local t2 = {
    Color3.fromRGB(214, 104, 255),
    rgb(116, 30, 214)
}
local v2 = Color3.fromRGB(62, 14, 120)
local t3 = {
    Color3.fromRGB(255, 248, 176),
    rgb(255, 176, 28)
}
local v3 = Color3.fromRGB(255, 198, 58)
local t4 = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 170, 40),
    Color3.fromRGB(255, 240, 60),
    Color3.fromRGB(70, 230, 90),
    Color3.fromRGB(60, 200, 255),
    Color3.fromRGB(90, 100, 255),
    rgb(200, 80, 255)
}
local t5 = {}

for v4, v5 in ipairs(t4) do
    table.insert(t5, ColorSequenceKeypoint.new((v4 - 1) / (#t4 - 1), v5))
end

local v7 = ColorSequence.new(t5)

local function rainbowAt(p4) -- line: 96
    -- upvalues: t4 (copy)
    local v8 = #t4
    local v9 = p4 % 1 * v8
    local v10 = math.floor(v9)

    return t4[v10 % v8 + 1]:Lerp(t4[(v10 + 1) % v8 + 1], v9 - v10)
end

local v11 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.4, rgb(255, 230, 120)),
    ColorSequenceKeypoint.new(1, rgb(255, 170, 30))
})
local t6 = {
    { 18, 0.86 },
    { 11, 0.78 },
    { 5, 0.66 }
}
local t7 = {}

t7.__index = t7

local v12
local v13 = false

local function savedCount() -- line: 131
    -- upvalues: DataController (copy)
    return (math.max(0, (math.floor(tonumber(DataController:Get("SuperThrows")) or 0))))
end

local function worldPart(p5, p6, p7) -- line: 135
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = p7 or Vector3.new(1, 1, 1)
    Part.CFrame = p6
    Part.Parent = p5

    return Part
end

local function emitter(p8, p9) -- line: 149
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = p9.Texture or "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = p9.Color or ColorSequence.new(Color3.new(1, 1, 1))
    ParticleEmitter.Size = p9.Size or NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.25, 0.6),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = p9.Transparency or NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = p9.Lifetime or NumberRange.new(0.8, 1.4)
    ParticleEmitter.Speed = p9.Speed or NumberRange.new(4, 10)
    ParticleEmitter.SpreadAngle = p9.Spread or Vector2.new(180, 180)
    ParticleEmitter.Acceleration = p9.Acceleration or Vector3.new(0, 0, 0)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = p9.RotSpeed or NumberRange.new(-120, 120)
    ParticleEmitter.LightEmission = p9.LightEmission or 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.EmissionDirection = p9.Direction or Enum.NormalId.Top
    ParticleEmitter.Rate = p9.Rate or 0

    if p9.Shape then
        ParticleEmitter.Shape = p9.Shape
    end

    ParticleEmitter.Parent = p8

    return ParticleEmitter
end

local function groundRing(p10, p11, p12, p13, p14, p15) -- line: 171
    -- upvalues: TweenService (copy)
    task.delay(p15 or 0, function() -- line: 172
        -- upvalues: p10 (copy), p11 (copy), p12 (copy), p13 (copy), p14 (copy), TweenService (copy)
        if p10.Parent then
            local v16 = CFrame.new(p11) * CFrame.Angles(0, 0, 1.5707963267948966)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.15, 1, 1)
            Part.CFrame = v16
            Part.Parent = p10
            Part.Shape = Enum.PartType.Cylinder
            Part.Material = Enum.Material.Neon
            Part.Color = p12
            Part.Transparency = 0.15
            TweenService:Create(Part, TweenInfo.new(p14 or 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = Vector3.new(0.15, p13, p13)
            }):Play()
            task.delay((p14 or 0.8) + 0.1, function() -- line: 180
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)
end

local function twinkle(p16, p17, p18, p19) -- line: 185
    -- upvalues: ShopUI (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Twinkle"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = p17
    Frame.Size = UDim2.fromOffset(p18, p18)
    Frame.Rotation = math.random(0, 45)
    Frame.ZIndex = p19

    for _, v18 in ipairs({ 0, 90 }) do
        local Frame2 = Instance.new("Frame")

        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Position = UDim2.fromScale(0.5, 0.5)
        Frame2.Size = UDim2.fromScale(1, 0.2)
        Frame2.Rotation = v18
        Frame2.ZIndex = p19

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = Frame2
        Frame2.Parent = Frame
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = Frame
    Frame.Parent = p16
    ShopUI.Tween(UIScale, {
        Scale = 1
    }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(0.2, function() -- line: 213
        -- upvalues: Frame (copy), UIScale (copy), ShopUI (copy)
        ShopUI.Tween(UIScale, {
            Scale = 0
        }, 0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        ShopUI.Tween(Frame, {
            Rotation = Frame.Rotation + 60
        }, 0.32)
    end)
    task.delay(0.6, function() -- line: 217
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local function luckWidgetReach() -- line: 223
    -- upvalues: PlayerGui (copy)
    local ServerLuckHUD = PlayerGui:FindFirstChild("ServerLuckHUD")
    local v19 = ServerLuckHUD and ServerLuckHUD.Enabled and ServerLuckHUD:FindFirstChild("Widget")
    local X

    if not v19 or not v19.Visible or v19.AbsoluteSize.X < 1 then
        return 0
    else
        X = v19.AbsolutePosition.X

        local Rays = v19:FindFirstChild("Rays")

        if Rays and Rays:IsA("GuiObject") and Rays.Visible then
            X = math.min(X, Rays.AbsolutePosition.X)
        end
    end

    return (math.max(0, ServerLuckHUD.AbsolutePosition.X + ServerLuckHUD.AbsoluteSize.X - X))
end

local function cornerOffset() -- line: 236
    -- upvalues: UIScaler (copy), t6 (copy), luckWidgetReach (copy)
    local v22 = luckWidgetReach()

    if v22 > 0 then
        return -v22 - 10 - math.round((UIScaler.Px(t6[1][1])))
    end

    return -14 - math.round((UIScaler.Px(26)))
end

function t1.Begin(p20) -- line: 246
    -- upvalues: RunService (copy), Remotes (copy), Janitor (copy), DataController (copy), PlayerGui (copy), SuperThrow (copy), t7 (copy), v12 (ref), v1 (copy)
    if v12 then
        v12:Destroy()
    end

    local self = setmetatable({}, t7)

    self.Gui = p20.Gui
    self.Meter = p20.Meter
    self.Rig = p20.Rig
    self.Food = p20.Food
    self.Folder = p20.Folder
    self.Launch = p20.Launch
    self.Janitor = Janitor.new()
    self.State = "Idle"
    self.Active = false
    self.Aiming = false
    self.MeterOver = false
    self.Dead = false
    self.Granted = false
    v12 = self

    if not (SuperThrow and v1) then
        return self
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "SuperThrowHUD"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
    ScreenGui.DisplayOrder = 151
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    self.Hud = ScreenGui
    self.Janitor:Add(ScreenGui)
    self.Janitor:Add(Remotes.Event("Throw_SuperGranted").OnClientEvent:Connect(function(p21) -- line: 279
        -- upvalues: self (copy)
        if type(p21) ~= "table" or not p21.Armed then
            return
        end

        self.Granted = true

        if self.State ~= "Prompting" and self.State ~= "Granting" and self:CanActivate() then
            self:Activate()
        end
    end))
    self.Janitor:Add(RunService.RenderStepped:Connect(function(p22) -- line: 286
        -- upvalues: self (copy)
        self:_step(p22)
    end))

    local v27 = p20.Start or {}

    if v27.SuperOffer and v1.Id ~= 0 then
        local v28 = tonumber(v27.Saved)

        if not v28 then
            v28 = math.max(0, (math.floor(tonumber(DataController:Get("SuperThrows")) or 0)))
        end

        self.SavedMode = v28 > 0
        self:ShowButton()
    end

    return self
end

function t7.CanActivate(p23) -- line: 297
    return not p23.Dead and not p23.Active and not p23.MeterOver
end

function t7.IsActive(p24) -- line: 301
    return p24.Active
end

function t7.ShowButton(p25) -- line: 309
    -- upvalues: ShopUI (copy), UIScaler (copy), Sounds (copy), RobuxPrices (copy), SuperThrow (copy), rgb (copy), t2 (copy), v2 (copy), t3 (copy), v3 (copy), v7 (copy), t6 (copy), luckWidgetReach (copy), v1 (copy)
    local v31, Frame, new, v32, v33

    if p25.Button or p25.Dead then
        v33 = true
    elseif p25.Hud then
        v31 = UIScaler.TouchBoost()
        Frame = Instance.new("Frame")
        Frame.Name = "SuperThrowButton"
        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(1, 0)
        new = UDim2.new

        local v34 = luckWidgetReach()

        v32 = if v34 > 0 then -v34 - 10 - math.round((UIScaler.Px(t6[1][1]))) else -14 - math.round((UIScaler.Px(26)))
        v33 = false
    else
        v33 = true
    end

    if v33 then
        return
    end

    Frame.Position = new(1, v32, 0, 14)
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    Frame.Size = UDim2.fromScale(0.4 * v31, 0.17 * v31)
    Frame.ZIndex = 40
    Frame.Parent = p25.Hud

    local v38 = ShopUI.Frame({
        Name = "Body",
        Transparency = 1,
        ZIndex = 40,
        Parent = Frame
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Breath"
    UIScale.Parent = v38

    local t10 = {}

    for v39, v40 in ipairs(t6) do
        local v42 = math.round(v40[1] * UIScaler.Factor() * v31)

        table.insert(t10, {
            Frame = ShopUI.Frame({
                ZIndex = 41,
                Parent = v38,
                Name = "Halo" .. v39,
                Size = UDim2.new(1, v42 * 2, 0.7, v42 * 2),
                Position = UDim2.fromScale(0.5, 0.35),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = v3,
                Transparency = v40[2],
                Corner = 16 + v40[1]
            }),
            Base = v40[2]
        })
    end

    ShopUI.Frame({
        Name = "Edge",
        Corner = 16,
        Stroke = 3,
        ZIndex = 42,
        Parent = v38,
        Size = UDim2.fromScale(1, 0.7),
        Position = UDim2.fromOffset(0, (math.round(5 * UIScaler.Factor() * v31))),
        Color = v2
    })

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Face"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton.Size = UDim2.fromScale(1, 0.7)
    TextButton.ZIndex = 43
    ShopUI.Corner(TextButton, 16)
    ShopUI.Gradient(TextButton, t2[1], t2[2], 90)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = TextButton

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = v7
    UIGradient.Parent = UIStroke
    TextButton.Parent = v38
    ShopUI.Stripes(TextButton, 0.9, 16, 20).ZIndex = 43
    ShopUI.Frame({
        Name = "Shine",
        Transparency = 0.8,
        Corner = 12,
        ZIndex = 44,
        Parent = TextButton,
        Size = UDim2.new(1, -10, 0.4, 0),
        Position = UDim2.fromOffset(5, 3)
    })

    local v44 = ShopUI.Frame({
        Name = "Sweep",
        Transparency = 0,
        Corner = 16,
        ZIndex = 44,
        Parent = TextButton
    })
    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Rotation = 20
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.45),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient2.Offset = Vector2.new(-1, 0)
    UIGradient2.Parent = v44

    local v45 = ShopUI.Frame({
        Name = "Veil",
        Transparency = 1,
        Corner = 16,
        ZIndex = 49,
        Parent = TextButton,
        Color = Color3.new(0, 0, 0)
    })

    ShopUI.Rays(TextButton, v3, {
        ZIndex = 45,
        Count = 7,
        Width = 0.13,
        Alpha = 0.5,
        Speed = 28,
        Size = UDim2.fromScale(1.9, 1.9),
        Position = UDim2.fromScale(0.17, 0.48)
    }).SizeConstraint = Enum.SizeConstraint.RelativeYY

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Clover"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Clover
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.17, 0.46)
    ImageLabel.Size = UDim2.fromScale(1.3, 1.3)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.ZIndex = 46
    ImageLabel.Parent = TextButton
    ShopUI.Text({
        Name = "Title",
        Text = "100x LUCK",
        ZIndex = 47,
        Stroke = 4,
        Parent = TextButton,
        Size = UDim2.fromScale(0.6, 0.66),
        Position = UDim2.fromScale(0.645, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            t3[1],
            t3[2],
            90
        }
    })

    local v46 = ShopUI.Frame({
        Name = "Price",
        Stroke = 3,
        ZIndex = 48,
        Parent = v38,
        Size = UDim2.fromScale(0.34, 0.34),
        Position = UDim2.fromScale(0.5, 0.64),
        AnchorPoint = Vector2.new(0.5, 0),
        Corner = UDim.new(0.5, 0),
        Gradient = {
            ShopUI.PillGradient[1],
            ShopUI.PillGradient[2],
            90
        }
    })
    local v47 = ShopUI.Frame({
        Name = "Content",
        Transparency = 1,
        ZIndex = 48,
        Parent = v46,
        Size = UDim2.fromScale(0.84, 0.72),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.05, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v47

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "RobuxIcon"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = ShopUI.RobuxIcon
    ImageLabel2.ScaleType = Enum.ScaleType.Fit
    ImageLabel2.Size = UDim2.fromScale(1, 0.95)
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel2.LayoutOrder = 1
    ImageLabel2.ZIndex = 48
    ImageLabel2.Parent = v47

    local v48 = ShopUI.Text({
        Name = "PriceLabel",
        ZIndex = 48,
        Stroke = 3,
        Parent = v47,
        Text = tostring(v1.Price),
        Size = UDim2.fromScale(0.5, 1),
        Gradient = {
            Color3.new(1, 1, 1),
            Color3.fromRGB(190, 255, 170),
            90
        }
    })

    v48.LayoutOrder = 2

    local UIGradient3 = v48:FindFirstChildOfClass("UIGradient")

    local function refreshPrice() -- line: 411
        -- upvalues: p25 (copy), ImageLabel2 (copy), v48 (copy), UIGradient3 (copy), ShopUI (copy), RobuxPrices (copy), SuperThrow (copy), rgb (copy), v7 (copy), v1 (copy)
        if p25.SavedMode then
            ImageLabel2.Image = SuperThrow.Icon or ShopUI.RobuxIcon
            ImageLabel2.Size = UDim2.fromScale(1.8, 1.8)
            v48.Text = "1"

            if UIGradient3 then
                UIGradient3.Color = v7
                UIGradient3.Rotation = 90
            end
        else
            ImageLabel2.Image = ShopUI.RobuxIcon
            ImageLabel2.Size = UDim2.fromScale(1, 0.95)
            v48.Text = tostring(RobuxPrices.Get(v1.Id, Enum.InfoType.Product, v1.Price))

            if UIGradient3 then
                UIGradient3.Color = ColorSequence.new(Color3.new(1, 1, 1), rgb(190, 255, 170))
                UIGradient3.Rotation = 90
            end
        end
    end

    refreshPrice()
    p25.Janitor:Add(RobuxPrices.Changed:Connect(function(p26) -- line: 432
        -- upvalues: v48 (copy), refreshPrice (copy), v1 (copy)
        if p26 == v1.Id and v48.Parent then
            refreshPrice()
        end
    end))

    local v50 = ShopUI.Frame({
        Name = "Twinkles",
        Transparency = 1,
        ZIndex = 50,
        Parent = v38
    })
    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "HitArea"
    TextButton2.Text = ""
    TextButton2.AutoButtonColor = false
    TextButton2.BackgroundTransparency = 1
    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton2.Position = UDim2.fromScale(0.5, 0.47)
    TextButton2.Size = UDim2.fromScale(1.06, 1.16)
    TextButton2.ZIndex = 60
    TextButton2.Parent = v38

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "JuiceScale"
    UIScale2.Parent = Frame

    local t14

    local function refresh() -- line: 456
        -- upvalues: p25 (copy), TextButton (copy), UIScale2 (copy), t14 (ref), ShopUI (copy)
        local v51 = if t14.Enabled and t14.Pressing then 1.04 elseif t14.Enabled and p25.Hover then 1.07 else 1

        ShopUI.Tween(UIScale2, {
            Scale = v51
        }, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        local Tween = ShopUI.Tween
        local v52, v53

        if t14.Enabled and t14.Pressing then
            local v54 = UDim2.fromOffset(0, 3)

            if v54 then
                v52 = v54
                v53 = true
            else
                v53 = false
            end
        else
            v53 = false
        end

        if not v53 then
            v52 = UDim2.new()
        end

        Tween(TextButton, {
            Position = v52
        }, 0.08)
    end

    TextButton2.MouseEnter:Connect(function() -- line: 462
        -- upvalues: p25 (copy), t14 (ref), refresh (copy), Sounds (copy)
        p25.Hover = true
        refresh()

        if t14.Enabled then
            Sounds.Play("ButtonHover")
        end
    end)
    TextButton2.MouseLeave:Connect(function() -- line: 467
        -- upvalues: p25 (copy), t14 (ref), refresh (copy)
        p25.Hover = false
        t14.Pressing = false
        refresh()
    end)
    TextButton2.MouseButton1Down:Connect(function() -- line: 472
        -- upvalues: t14 (ref), refresh (copy)
        t14.Pressing = true
        refresh()
    end)
    TextButton2.MouseButton1Up:Connect(function() -- line: 476
        -- upvalues: t14 (ref), refresh (copy)
        t14.Pressing = false
        refresh()
    end)
    TextButton2.Activated:Connect(function() -- line: 480
        -- upvalues: p25 (copy), t14 (ref), refresh (copy), Sounds (copy)
        t14.Pressing = false
        refresh()

        if p25.State == "Offer" and t14.Enabled then
            Sounds.Play("ButtonClick")

            if p25.SavedMode then
                p25:UseSaved()
            else
                p25:Buy()
            end
        end
    end)
    p25.Meter:AddBlocker(TextButton2)
    t14 = {
        Enabled = true,
        Pressing = false,
        Holder = Frame,
        Body = v38,
        Breath = UIScale,
        Face = TextButton,
        Halos = t10,
        Outline = UIGradient,
        Sweep = UIGradient2,
        Veil = v45,
        Clover = ImageLabel,
        Price = v48,
        Twinkles = v50,
        PriceGradient = UIGradient3,
        RefreshPrice = refreshPrice,
        Refresh = refresh,
        ShownAt = os.clock(),
        NextSweep = os.clock() + 0.6,
        NextWiggle = os.clock() + 2.4,
        NextTwinkle = os.clock() + 0.3
    }
    p25.Button = t14
    p25.State = "Offer"
    Sounds.Play("SuperAppear")
end

function t7._setButtonBusy(p27, p28) -- line: 502
    -- upvalues: ShopUI (copy)
    local Button = p27.Button

    if not Button then
        return
    end

    Button.Enabled = not p28
    Button.Refresh()
    ShopUI.Tween(Button.Veil, {
        BackgroundTransparency = p28 and 0.4 or 1
    }, 0.15)
end

function t7.HideButton(p29) -- line: 510
    -- upvalues: ShopUI (copy)
    local Button = p29.Button

    if not Button then
        return
    end

    p29.Button = nil
    ShopUI.PopOut(Button.Holder, 0.2, 0.5).Completed:Once(function() -- line: 514
        -- upvalues: Button (copy)
        Button.Holder:Destroy()
    end)
end

function t7._burstButton(p30) -- line: 518
    -- upvalues: ShopUI (copy), UIScaler (copy), Sounds (copy), rgb (copy), t2 (copy), t3 (copy), twinkle (copy)
    local Button = p30.Button

    if not Button then
        return
    end

    p30.Button = nil

    local Gui = p30.Gui
    local v55 = Button.Face.AbsolutePosition + Button.Face.AbsoluteSize / 2 - Gui.AbsolutePosition
    local UIScale = Button.Holder:FindFirstChildOfClass("UIScale")

    if UIScale then
        ShopUI.Tween(UIScale, {
            Scale = 1.25
        }, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.delay(0.1, function() -- line: 527
            -- upvalues: UIScale (copy), ShopUI (copy)
            ShopUI.Tween(UIScale, {
                Scale = 0
            }, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        end)
    end

    task.delay(0.32, function() -- line: 531
        -- upvalues: Button (copy)
        Button.Holder:Destroy()
    end)
    ShopUI.Confetti(Gui, v55, 36, {
        ZIndex = 70,
        Direction = 90,
        Spread = 160,
        MinSpeed = 200,
        MaxSpeed = 520,
        Colors = {
            t3[1],
            t3[2],
            Color3.new(1, 1, 1),
            t2[1],
            rgb(120, 236, 110)
        }
    })

    for _ = 1, 6 do
        twinkle(Gui, UDim2.fromOffset(v55.X + math.random(-110, 110), v55.Y + math.random(-30, 50)), math.round((UIScaler.Px(18))), 70)
    end

    Sounds.Play("SuperBurst")
end

function t7.Buy(p31) -- line: 543
    -- upvalues: MarketplaceService (copy), Remotes (copy), Sounds (copy), LocalPlayer (copy), SuperThrow (copy), v13 (ref), v1 (copy)
    if p31.State ~= "Offer" or p31.Dead then
        return
    end

    p31.State = "Prompting"
    p31.Meter:SetTapsBlocked(true)
    p31:_setButtonBusy(true)
    task.spawn(function() -- line: 548
        -- upvalues: p31 (copy), MarketplaceService (copy), Remotes (copy), Sounds (copy), LocalPlayer (copy), SuperThrow (copy), v13 (ref), v1 (copy)
        local v58 = false
        local v59 = false

        local function finish(p32) -- line: 550
            -- upvalues: v58 (ref), v59 (ref)
            if not v58 then
                v58 = true
                v59 = p32
            end
        end

        local t17 = {
            MarketplaceService.PromptProductPurchaseFinished:Connect(function(p33, p34, p35) -- line: 555
                -- upvalues: v58 (ref), v59 (ref), LocalPlayer (copy), v1 (copy)
                if p33 ~= LocalPlayer.UserId or p34 ~= v1.Id then
                    return
                end

                local v60 = p35 == true

                if v58 then
                    return
                end

                v58 = true
                v59 = v60
            end),
            Remotes.Event("Shop_PromptClosed").OnClientEvent:Connect(function(p36) -- line: 559
                -- upvalues: v58 (ref), v59 (ref), SuperThrow (copy)
                if type(p36) ~= "table" or p36.Key ~= SuperThrow.Product then
                    return
                end

                local v61 = p36.Purchased == true

                if v58 then
                    return
                end

                v58 = true
                v59 = v61
            end),
            Remotes.Event("Throw_SuperGranted").OnClientEvent:Connect(function(p37) -- line: 562
                -- upvalues: v58 (ref), v59 (ref)
                if type(p37) ~= "table" or not p37.Single or v58 then
                    return
                end

                v58 = true
                v59 = true
            end)
        }
        local v62 = Remotes.Invoke("Shop_Prompt", SuperThrow.Product)

        if not v62.Ok and v62.Reason == "Cooldown" then
            task.wait(0.45)
            v62 = Remotes.Invoke("Shop_Prompt", SuperThrow.Product)
        end

        if not v62.Ok then
            Sounds.Play("PurchaseFail", {
                Volume = 0.4
            })

            if not v58 then
                v58 = true
                v59 = false
            end
        end

        local elapsed = os.clock()

        while not v58 and not p31.Dead and os.clock() - elapsed < 30 do
            task.wait()
        end

        for _, v63 in ipairs(t17) do
            v63:Disconnect()
        end

        if not p31.Dead then
            if v59 then
                p31.State = "Granting"

                local elapsed = os.clock()

                while not p31.Granted and not p31.Dead and os.clock() - elapsed < 12 do
                    task.wait()
                end

                if not p31.Dead then
                    p31.State = "Over"

                    if p31.Granted then
                        p31:Activate()
                    else
                        v13 = true
                        p31:HideButton()
                        p31.Meter:SetTapsBlocked(false)
                    end
                end
            else
                p31.State = "Offer"
                p31:_setButtonBusy(false)
                p31.Meter:SetTapsBlocked(false)
            end
        end
    end)
end

function t7.UseSaved(p38) -- line: 606
    -- upvalues: Remotes (copy)
    if p38.State ~= "Offer" or p38.Dead then
        return
    end

    p38.State = "Using"
    p38.Meter:SetTapsBlocked(true)
    p38:_setButtonBusy(true)
    task.spawn(function() -- line: 611
        -- upvalues: p38 (copy), Remotes (copy)
        local function v64() -- line: 612
            -- upvalues: Remotes (copy)
            return Remotes.Invoke("Throw_UseSuper")
        end

        local ok, result = pcall(v64)

        if p38.Dead then
            return
        end

        if ok and type(result) == "table" and result.Ok then
            p38.State = "Over"

            if p38.OnUsedSaved then
                task.spawn(p38.OnUsedSaved)
            end

            if p38:CanActivate() then
                p38:Activate()
            else
                p38.Meter:SetTapsBlocked(false)
            end
        else
            p38.Meter:SetTapsBlocked(false)

            if not p38.MeterOver then
                if type(result) == "table" and result.Reason == "NoneSaved" then
                    p38.SavedMode = false

                    if p38.Button and p38.Button.RefreshPrice then
                        p38.Button.RefreshPrice()
                    end
                end

                p38.State = "Offer"
                p38:_setButtonBusy(false)
            end
        end
    end)
end

function t7.Activate(p39) -- line: 642
    -- upvalues: ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), t2 (copy), t3 (copy), v3 (copy)
    if not p39:CanActivate() then
        return
    end

    p39.Active = true
    p39.Aiming = true
    p39.State = "Active"
    p39.Meter:SetLocked(true)
    p39:_burstButton()
    p39:_superMeter()
    p39:_foodRainbow()
    p39:_rigAura()
    Sounds.Play("SuperRiser")
    ScreenFX.Flash(v3, 0.2, 0.3)
    task.delay(0.28, function() -- line: 655
        -- upvalues: p39 (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), t2 (copy), t3 (copy), v3 (copy)
        if p39.Dead then
            return
        end

        Sounds.Play("SuperSlam")
        Sounds.Play("SuperChime")
        Sounds.Play("SuperShine", {
            Delay = 0.08
        })
        ScreenFX.Flash(v3, 0.4, 0.55)
        ScreenFX.Ring(v3, 0.75, 60)
        CameraRig.Shake(0.9, 0.45, 18)
        CameraRig.PunchFOV(8, 0.05, 0.55)

        local Gui = p39.Gui
        local AbsoluteSize = Gui.AbsoluteSize

        for i = 1, 4 do
            task.delay(i * 0.05, function() -- line: 667
                -- upvalues: Gui (copy), AbsoluteSize (copy), i (copy), ShopUI (copy), t2 (copy), t3 (copy)
                ShopUI.Confetti(Gui, Vector2.new(AbsoluteSize.X * ((i - 1) * 0.24 + 0.14), -10), 18, {
                    ZIndex = 65,
                    Direction = 90,
                    Spread = 35,
                    MinSpeed = 120,
                    MaxSpeed = 360,
                    Gravity = 520,
                    Colors = {
                        t3[1],
                        t3[2],
                        Color3.new(1, 1, 1),
                        t2[1]
                    }
                })
            end)
        end
    end)
    task.delay(0.5, function() -- line: 674
        -- upvalues: p39 (copy)
        if p39.Dead or not p39.Active or p39.MeterOver then
            return
        end

        p39:_showBadge()
        p39.Meter:SetTapsBlocked(false)
    end)
end

function t7._superMeter(p40) -- line: 682
    -- upvalues: ShopUI (copy), t3 (copy), v3 (copy)
    local Meter = p40.Meter

    if Meter.Holder and not p40.MeterGlow then
        p40.MeterGlow = ShopUI.Frame({
            Name = "SuperGlow",
            Transparency = 0.5,
            Corner = 30,
            ZIndex = 10,
            Ratio = 0.25,
            Parent = Meter.Holder,
            Size = UDim2.fromScale(1, 0.86),
            Position = UDim2.fromScale(0.5, -0.03),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = v3
        })

        if Meter.Prompt then
            p40.PromptGradient = ShopUI.Gradient(Meter.Prompt, t3[1], t3[2], 90)
        end
    end
end

function t7._foodRainbow(p41) -- line: 692
    -- upvalues: CollectionService (copy), Mutations (copy), AnimalUtil (copy), v7 (copy), emitter (copy)
    local Food = p41.Food

    if not Food or not Food.Parent or p41.FoodDone then
        return
    end

    p41.FoodDone = true
    Mutations.Apply(Food, "Rainbow")
    Food:SetAttribute("Mutation", nil)

    local v65 = AnimalUtil.GetFoodLongest(Food) or 1.6

    for _, descendant in ipairs(Food:GetDescendants()) do
        if descendant:IsA("Texture") and CollectionService:HasTag(descendant, "MutationTexture") then
            descendant.StudsPerTileU = v65
            descendant.StudsPerTileV = v65
            descendant.Transparency = 0.08
            descendant:SetAttribute("ScrollU", v65 * 0.9)
            descendant:SetAttribute("ScrollV", v65 * 0.45)
        elseif descendant:IsA("ParticleEmitter") then
            descendant:Emit(10)
        end
    end

    local PrimaryPart = Food.PrimaryPart

    if not PrimaryPart then
        return
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Range = 9
    PointLight.Brightness = 3
    PointLight.Shadows = false
    PointLight.Parent = PrimaryPart
    p41.FoodLight = PointLight
    p41.FoodAura = emitter(PrimaryPart, {
        Rate = 16,
        Color = v7,
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(0.6, 1.8),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 0.32),
            NumberSequenceKeypoint.new(1, 0)
        })
    })
    p41.FoodAura:Emit(30)
end

function t7._rigAura(p42) -- line: 726
    -- upvalues: TweenService (copy), ShopUI (copy), v3 (copy), v11 (copy), emitter (copy)
    local v66, v67

    if p42.Aura then
        v67 = true
    elseif p42.Folder then
        v66 = p42.Rig and p42.Rig:FindFirstChild("HumanoidRootPart")
        v67 = false
    else
        v67 = true
    end

    if v67 then
        return
    end

    local v68 = p42.Launch or v66 and v66.Position - Vector3.new(0, 3, 0)

    if not v68 then
        return
    end

    local Folder = p42.Folder
    local v69 = CFrame.new(v68 + Vector3.new(0, 0.2, 0))
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(4.5, 0.4, 4.5)
    Part.CFrame = v69
    Part.Parent = Folder

    local v70 = emitter(Part, {
        Rate = 26,
        Acceleration = Vector3.new(0, 1.5, 0),
        Color = v11,
        Lifetime = NumberRange.new(1, 1.8),
        Speed = NumberRange.new(2.5, 5),
        Spread = Vector2.new(18, 18),
        Shape = Enum.ParticleEmitterShape.Box,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.25, 0.45),
            NumberSequenceKeypoint.new(1, 0)
        })
    })

    emitter(Part, {
        Acceleration = Vector3.new(0, -16, 0),
        LightEmission = 0.15,
        Texture = ShopUI.Icons.Clover,
        Color = ColorSequence.new(Color3.new(1, 1, 1)),
        Lifetime = NumberRange.new(1.1, 1.7),
        Speed = NumberRange.new(10, 18),
        Spread = Vector2.new(55, 55),
        RotSpeed = NumberRange.new(-220, 220),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 0.9),
            NumberSequenceKeypoint.new(1, 0.35)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }):Emit(28)
    v70:Emit(40)

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v3
    PointLight.Range = 15
    PointLight.Brightness = 2.4
    PointLight.Shadows = false
    PointLight.Parent = Part

    local Folder2 = p42.Folder
    local v71 = CFrame.new(v68 + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Transparency = 1
    Part2.Size = Vector3.new(0.1, 6.5, 6.5)
    Part2.CFrame = v71
    Part2.Parent = Folder2
    Part2.Shape = Enum.PartType.Cylinder
    Part2.Material = Enum.Material.Neon
    Part2.Color = v3
    Part2.Transparency = 0.6

    local Folder3 = p42.Folder
    local v72 = v68 + Vector3.new(0, 0.15, 0)
    local delay = task.delay
    local n1 = 0.8
    local n2 = 26

    delay(0.28, function() -- line: 172
        -- upvalues: Folder3 (copy), v72 (copy), n1 (copy), n2 (copy), TweenService (copy), v3 (copy)
        if Folder3.Parent then
            local v73 = CFrame.new(v72) * CFrame.Angles(0, 0, 1.5707963267948966)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.15, 1, 1)
            Part.CFrame = v73
            Part.Parent = Folder3
            Part.Shape = Enum.PartType.Cylinder
            Part.Material = Enum.Material.Neon
            Part.Color = v3
            Part.Transparency = 0.15
            TweenService:Create(Part, TweenInfo.new(n1 or 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = Vector3.new(0.15, n2, n2)
            }):Play()
            task.delay((n1 or 0.8) + 0.1, function() -- line: 180
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)

    local Folder4 = p42.Folder
    local v75 = v68 + Vector3.new(0, 0.16, 0)
    local v76 = Color3.new(1, 1, 1)
    local delay2 = task.delay
    local n3 = 0.6
    local n4 = 18

    delay2(0.4, function() -- line: 172
        -- upvalues: Folder4 (copy), v75 (copy), v76 (copy), n3 (copy), n4 (copy), TweenService (copy)
        if Folder4.Parent then
            local v77 = CFrame.new(v75) * CFrame.Angles(0, 0, 1.5707963267948966)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.15, 1, 1)
            Part.CFrame = v77
            Part.Parent = Folder4
            Part.Shape = Enum.PartType.Cylinder
            Part.Material = Enum.Material.Neon
            Part.Color = v76
            Part.Transparency = 0.15
            TweenService:Create(Part, TweenInfo.new(n3 or 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = Vector3.new(0.15, n4, n4)
            }):Play()
            task.delay((n3 or 0.8) + 0.1, function() -- line: 180
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)
    p42.Aura = {
        Base = Part,
        Sparkles = v70,
        Light = PointLight,
        Ring = Part2
    }
end

function t7._showBadge(p43) -- line: 758
    -- upvalues: ShopUI (copy), UIScaler (copy), Sounds (copy), t3 (copy), t6 (copy), luckWidgetReach (copy)
    local Frame, t20, new, v79, v80

    if p43.Badge or p43.Dead then
        v80 = true
    elseif p43.Hud then
        local v81 = UIScaler.TouchBoost()

        Frame = ShopUI.Frame
        t20 = {
            Name = "SuperBadge",
            Transparency = 1,
            ZIndex = 40,
            Parent = p43.Hud,
            Size = UDim2.fromScale(0.36 * v81, 0.085 * v81)
        }
        new = UDim2.new

        local v82 = luckWidgetReach()

        v79 = if v82 > 0 then -v82 - 10 - math.round((UIScaler.Px(t6[1][1]))) else -14 - math.round((UIScaler.Px(26)))
        v80 = false
    else
        v80 = true
    end

    if v80 then
        return
    end

    t20.Position = new(1, v79, 0, 14)
    t20.AnchorPoint = Vector2.new(1, 0)

    local v86 = Frame(t20)

    v86.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local v87 = ShopUI.Frame({
        Name = "Pill",
        Stroke = 3,
        ZIndex = 41,
        Parent = v86,
        Corner = UDim.new(0.5, 0),
        Gradient = {
            t3[1],
            t3[2],
            90
        }
    })

    ShopUI.Frame({
        Name = "Shine",
        Transparency = 0.6,
        ZIndex = 42,
        Parent = v87,
        Size = UDim2.new(1, -14, 0.42, 0),
        Position = UDim2.fromOffset(7, 2),
        Corner = UDim.new(0.5, 0)
    })
    ShopUI.Rays(v87, Color3.new(1, 1, 1), {
        ZIndex = 42,
        Count = 6,
        Width = 0.14,
        Alpha = 0.55,
        Speed = 40,
        Size = UDim2.fromScale(2, 2),
        Position = UDim2.fromScale(0.1, 0.5)
    }).SizeConstraint = Enum.SizeConstraint.RelativeYY

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Clover"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Clover
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.1, 0.48)
    ImageLabel.Size = UDim2.fromScale(1.45, 1.45)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.ZIndex = 43
    ImageLabel.Parent = v87
    ShopUI.Text({
        Name = "Label",
        Text = "100x LUCK",
        ZIndex = 44,
        Stroke = 3,
        Parent = v87,
        Size = UDim2.fromScale(0.72, 0.72),
        Position = UDim2.fromScale(0.58, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    p43.Badge = {
        Holder = v86,
        Pill = v87,
        Clover = ImageLabel
    }
    ShopUI.PopIn(v86, 0.4, 0.3)
    Sounds.Play("Pop", {
        Volume = 0.5
    })
end

function t7._hideBadge(p44) -- line: 784
    -- upvalues: ShopUI (copy)
    local Badge = p44.Badge

    if not Badge then
        return
    end

    p44.Badge = nil
    ShopUI.PopOut(Badge.Holder, 0.2, 0.4).Completed:Once(function() -- line: 788
        -- upvalues: Badge (copy)
        Badge.Holder:Destroy()
    end)
end

function t7._undo(p45) -- line: 792
    -- upvalues: Mutations (copy)
    p45.Active = false
    p45.Aiming = false
    p45.Meter:SetLocked(false)
    p45:_hideBadge()

    if p45.Food and p45.Food.Parent then
        Mutations.Apply(p45.Food, nil)
    end

    if p45.FoodLight then
        p45.FoodLight:Destroy()
        p45.FoodLight = nil
    end

    if p45.FoodAura then
        p45.FoodAura:Destroy()
        p45.FoodAura = nil
    end

    if p45.Aura then
        p45.Aura.Base:Destroy()
        p45.Aura.Ring:Destroy()
        p45.Aura = nil
    end

    if p45.MeterGlow then
        p45.MeterGlow:Destroy()
        p45.MeterGlow = nil
    end
end

function t7.MeterDone(p46) -- line: 812
    p46.MeterOver = true

    if p46.State ~= "Active" then
        p46.State = "Over"
    end

    p46:HideButton()

    if p46.PromptGradient then
        p46.PromptGradient:Destroy()
        p46.PromptGradient = nil
    end
end

function t7.Resolved(p47, p48) -- line: 822
    -- upvalues: Sounds (copy), ScreenFX (copy), v3 (copy)
    if p47.Dead or type(p48) ~= "table" then
        return
    end

    if p48.SuperThrow then
        if not p47.Active then
            p47.Active = true
            p47.Aiming = true
            p47.State = "Active"
            p47:_foodRainbow()
            p47:_rigAura()
            Sounds.Play("SuperChime")
            ScreenFX.Flash(v3, 0.3, 0.45)
        end
    elseif p47.Active then
        p47:_undo()
    end
end

function t7.Released(p49, p50) -- line: 842
    -- upvalues: ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy)
    local v88 = true

    if p49.Dead then
    elseif p49.Active then
        p49.Aiming = false
        p49:_hideBadge()

        local Aura = p49.Aura

        if Aura then
            Aura.Sparkles.Enabled = false
            ShopUI.Tween(Aura.Ring, {
                Transparency = 1
            }, 0.4)
            ShopUI.Tween(Aura.Light, {
                Brightness = 0
            }, 0.5)
        end

        v88 = false
    end

    if v88 then
        return
    end

    if p49.MeterGlow then
        ShopUI.Tween(p49.MeterGlow, {
            BackgroundTransparency = 1
        }, 0.2)
    end

    Sounds.Play("SuperWhoosh")
    Sounds.Play("SuperShine", {
        Delay = 0.05,
        Volume = 0.6
    })
    CameraRig.PunchFOV(6, 0.05, 0.5)
    ScreenFX.Flash(Color3.new(1, 1, 1), 0.2, 0.3)
    p49.Trail = p50
end

function t7.Landed(p51, p52) -- line: 862
    -- upvalues: TweenService (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), v3 (copy), v11 (copy), emitter (copy)
    if p51.Dead or not p51.Active then
        return 0
    end

    local Folder = p51.Folder
    local v89 = CFrame.new(p52 + Vector3.new(0, 0.6, 0))
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = v89
    Part.Parent = Folder
    emitter(Part, {
        Acceleration = Vector3.new(0, -28, 0),
        Color = v11,
        Lifetime = NumberRange.new(0.8, 1.4),
        Speed = NumberRange.new(16, 34),
        Spread = Vector2.new(70, 70),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.2, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        })
    }):Emit(90)
    emitter(Part, {
        Acceleration = Vector3.new(0, -18, 0),
        LightEmission = 0.15,
        Texture = ShopUI.Icons.Clover,
        Color = ColorSequence.new(Color3.new(1, 1, 1)),
        Lifetime = NumberRange.new(1.1, 1.7),
        Speed = NumberRange.new(12, 22),
        Spread = Vector2.new(60, 60),
        RotSpeed = NumberRange.new(-220, 220),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 1.1),
            NumberSequenceKeypoint.new(1, 0.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }):Emit(26)

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v3
    PointLight.Range = 30
    PointLight.Brightness = 8
    PointLight.Shadows = false
    PointLight.Parent = Part
    TweenService:Create(PointLight, TweenInfo.new(1.3, Enum.EasingStyle.Quad), {
        Brightness = 0
    }):Play()

    local Folder2 = p51.Folder
    local v90 = p52 + Vector3.new(0, 0.2, 0)
    local delay = task.delay
    local n5 = 0.75
    local n6 = 30

    delay(0, function() -- line: 172
        -- upvalues: Folder2 (copy), v90 (copy), n5 (copy), n6 (copy), TweenService (copy), v3 (copy)
        if Folder2.Parent then
            local v91 = CFrame.new(v90) * CFrame.Angles(0, 0, 1.5707963267948966)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.15, 1, 1)
            Part.CFrame = v91
            Part.Parent = Folder2
            Part.Shape = Enum.PartType.Cylinder
            Part.Material = Enum.Material.Neon
            Part.Color = v3
            Part.Transparency = 0.15
            TweenService:Create(Part, TweenInfo.new(n5 or 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = Vector3.new(0.15, n6, n6)
            }):Play()
            task.delay((n5 or 0.8) + 0.1, function() -- line: 180
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)

    local Folder3 = p51.Folder
    local v93 = p52 + Vector3.new(0, 0.22, 0)
    local v94 = Color3.new(1, 1, 1)
    local delay2 = task.delay
    local n7 = 0.6
    local n8 = 20

    delay2(0.12, function() -- line: 172
        -- upvalues: Folder3 (copy), v93 (copy), v94 (copy), n7 (copy), n8 (copy), TweenService (copy)
        if Folder3.Parent then
            local v95 = CFrame.new(v93) * CFrame.Angles(0, 0, 1.5707963267948966)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.15, 1, 1)
            Part.CFrame = v95
            Part.Parent = Folder3
            Part.Shape = Enum.PartType.Cylinder
            Part.Material = Enum.Material.Neon
            Part.Color = v94
            Part.Transparency = 0.15
            TweenService:Create(Part, TweenInfo.new(n7 or 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = Vector3.new(0.15, n8, n8)
            }):Play()
            task.delay((n7 or 0.8) + 0.1, function() -- line: 180
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)

    if p51.Food then
        for _, descendant in ipairs(p51.Food:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") and descendant.Enabled then
                descendant:Emit(14)
            end
        end
    end

    Sounds.Play("SuperBurst")
    Sounds.Play("SuperSlam", {
        Volume = 0.7
    })
    ScreenFX.Flash(v3, 0.28, 0.45)
    CameraRig.Shake(1.1, 0.5, 18)
    task.delay(2.5, function() -- line: 891
        -- upvalues: Part (copy)
        Part:Destroy()
    end)

    return 0.6
end

function t7._step(p53, p54) -- line: 896
    -- upvalues: ShopUI (copy), UIScaler (copy), rainbowAt (copy), t6 (copy), twinkle (copy), luckWidgetReach (copy)
    if p53.Dead then
        return
    end

    local elapsed = os.clock()
    local v97 = luckWidgetReach()
    local v98 = if v97 > 0 then -v97 - 10 - math.round((UIScaler.Px(t6[1][1]))) else -14 - math.round((UIScaler.Px(26)))
    local Button = p53.Button

    if Button and Button.Holder.Parent then
        local Offset = Button.Holder.Position.X.Offset

        Button.Holder.Position = UDim2.new(1, Offset + (v98 - Offset) * math.min(1, p54 * 12), 0, 14)

        local v104 = elapsed - Button.ShownAt

        Button.Outline.Rotation = (Button.Outline.Rotation + p54 * 110) % 360
        Button.Breath.Scale = math.sin(v104 * 2.6) * 0.018 + 1
        Button.Clover.Rotation = math.sin(v104 * 2.1) * 8

        local v109 = (if p53.Hover then 0.12 else 0) + math.sin(v104 * 3) * 0.05

        for _, v110 in ipairs(Button.Halos) do
            v110.Frame.BackgroundTransparency = math.clamp(v110.Base - v109, 0, 1)
        end

        if p53.State == "Offer" then
            if Button.NextSweep <= elapsed then
                Button.NextSweep = elapsed + 2.8
                Button.Sweep.Offset = Vector2.new(-1, 0)
                ShopUI.Tween(Button.Sweep, {
                    Offset = Vector2.new(1, 0)
                }, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            end

            if Button.NextWiggle <= elapsed then
                Button.NextWiggle = elapsed + 3.6
                ShopUI.Tween(Button.Body, {
                    Rotation = 4
                }, 0.08, Enum.EasingStyle.Sine)
                task.delay(0.08, function() -- line: 922
                    -- upvalues: Button (copy), ShopUI (copy)
                    if Button.Body.Parent then
                        ShopUI.Tween(Button.Body, {
                            Rotation = 0
                        }, 0.6, Enum.EasingStyle.Elastic)
                    end
                end)
            end

            if Button.NextTwinkle <= elapsed then
                Button.NextTwinkle = elapsed + 0.55 * (0.7 + math.random() * 0.6)

                local v112 = math.random() < 0.5 and math.random() * 0.25 or 0.75 + math.random() * 0.25

                twinkle(Button.Twinkles, UDim2.fromScale(v112, math.random() * 0.7), math.round((UIScaler.Px(12 + math.random() * 8))), 50)
            end
        end
    end

    local Badge = p53.Badge

    if Badge and Badge.Holder.Parent then
        local Offset = Badge.Holder.Position.X.Offset

        Badge.Holder.Position = UDim2.new(1, Offset + (v98 - Offset) * math.min(1, p54 * 12), 0, 14)
        Badge.Clover.Rotation = math.sin(elapsed * 2.4) * 9
    end

    if p53.MeterGlow and p53.MeterGlow.Parent and p53.Aiming then
        p53.MeterGlow.BackgroundTransparency = math.sin(elapsed * 4) * 0.12 + 0.55
    end

    if p53.FoodLight and p53.FoodLight.Parent then
        p53.FoodLight.Color = Color3.fromHSV(elapsed * 0.45 % 1, 0.65, 1)
    end

    local Trail = p53.Trail

    if Trail and Trail.Parent and Trail.Enabled then
        local v119 = elapsed * 1.6
        local v120 = table.create(15)

        for i = 0, 14 do
            local v121 = i / 14

            v120[i + 1] = ColorSequenceKeypoint.new(v121, rainbowAt(v121 - v119))
        end

        Trail.Color = ColorSequence.new(v120)
    end

    local Aura = p53.Aura

    if not (Aura and Aura.Ring.Parent and p53.Aiming) then
        return
    end

    local v123 = math.sin(elapsed * 3.2) * 0.5 + 6.5

    Aura.Ring.Size = Vector3.new(0.1, v123, v123)
    Aura.Ring.Transparency = math.sin(elapsed * 3.2) * 0.1 + 0.6
end

function t7.Destroy(p55) -- line: 964
    -- upvalues: DataController (copy), HUDController (copy), v12 (ref), v13 (ref)
    if p55.Dead then
        return
    end

    p55.Dead = true

    if v12 == p55 then
        v12 = nil
    end

    p55.Janitor:Cleanup()

    if v13 then
        v13 = false
        task.delay(1.5, function() -- line: 974
            -- upvalues: DataController (copy), HUDController (copy)
            if math.max(0, (math.floor(tonumber(DataController:Get("SuperThrows")) or 0))) > 0 and HUDController.PunchSavedThrows then
                HUDController.PunchSavedThrows()
            end
        end)
    end
end

function t1.Abort() -- line: 983
    -- upvalues: v12 (ref)
    if v12 then
        v12:Destroy()
    end
end

function t1.Init() -- line: 987
    -- upvalues: Remotes (copy), SuperThrow (copy), v12 (ref), v13 (ref), v1 (copy)
    if SuperThrow and v1 then
        Remotes.Event("Throw_SuperGranted").OnClientEvent:Connect(function(p56) -- line: 992
            -- upvalues: v12 (ref), v13 (ref)
            if type(p56) == "table" and not p56.Armed and p56.Single and v12 and not v12.Active then
                v13 = true
            end
        end)
    end
end

return t1

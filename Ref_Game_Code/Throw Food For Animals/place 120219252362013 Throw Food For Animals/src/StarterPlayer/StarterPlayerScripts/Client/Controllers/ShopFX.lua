-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonetizationConfig = require(ReplicatedStorage.Config.MonetizationConfig)
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LuckyCatch = require(ReplicatedStorage.Shared.LuckyCatch)
local MutationsConfig = require(ReplicatedStorage.Config.MutationsConfig)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local Parent = script.Parent
local ShopUI = require(Parent.ShopUI)
local Sounds = require(Parent.Sounds)
local ScreenFX = require(Parent.ScreenFX)
local CameraRig = require(Parent.CameraRig)
local ClientState = require(Parent.ClientState)
local ExclusiveShopController = require(Parent.ExclusiveShopController)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function rgb(p1, p2, p3) -- line: 54
    return Color3.fromRGB(p1, p2, p3)
end

local t2 = {}

for _, v1 in pairs(AnimalsData) do
    for _, v2 in ipairs(v1) do
        t2[v2.ModelName] = v2.Name
    end
end

local function newGui(p4, p5) -- line: 61
    -- upvalues: PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = p4
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = p5
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    return ScreenGui
end

local ScreenGui
local t3 = {}
local v3 = false

local function rewardItems(p6) -- line: 81
    -- upvalues: MonetizationConfig (copy), EggsConfig (copy), AnimalEconomy (copy), NumberFormat (copy), ShopUI (copy), t2 (copy)
    local t4 = {}

    if p6.Eggs then
        for _, v4 in ipairs(EggsConfig.Order) do
            local v5 = p6.Eggs[v4]

            if v5 then
                table.insert(t4, {
                    Title = EggsConfig.Get(v4).Name,
                    Count = v5,
                    Model = {
                        Egg = v4
                    },
                    Color = EggsConfig.Get(v4).Color
                })
            end
        end
    end

    if p6.Money then
        table.insert(t4, {
            Money = true,
            Title = NumberFormat.Money(p6.Money),
            Image = p6.Icon or ShopUI.Icons.Cash,
            Color = Color3.fromRGB(120, 230, 90)
        })
    end

    if p6.Power then
        table.insert(t4, {
            Title = "+" .. NumberFormat.Abbreviate(p6.Power) .. " Power",
            Image = p6.Icon or ShopUI.Icons.Power,
            Color = Color3.fromRGB(255, 214, 72)
        })
    end

    if p6.SuperThrows then
        local SuperThrow = MonetizationConfig.SuperThrow

        table.insert(t4, {
            Title = "+" .. NumberFormat.Abbreviate(p6.SuperThrows) .. " Lucky Throws",
            Image = p6.Icon or SuperThrow and SuperThrow.Icon or ShopUI.Icons.Clover,
            Color = Color3.fromRGB(206, 140, 255)
        })
    end

    if p6.Animals then
        for _, v6 in ipairs(p6.Animals) do
            local v7 = AnimalEconomy.Get(v6)

            table.insert(t4, {
                Title = t2[v6] or v6,
                Model = {
                    Animal = v6
                },
                Rarity = v7 and v7.Rarity,
                Income = not p6.OfBest and v7 and v7.Income or nil,
                OfBest = p6.OfBest
            })
        end
    end

    if p6.Pass then
        table.insert(t4, {
            Badge = "x2",
            Title = MonetizationConfig.Passes[p6.Pass].Name,
            Image = p6.Pass == "DoubleCash" and ShopUI.Icons.Cash or ShopUI.Icons.Power,
            Color = Color3.fromRGB(255, 214, 72)
        })
    end

    return t4
end

local function rewardHint(p7) -- line: 118
    if p7.Eggs then
        return "Hold the egg and click your plot to hatch it!"
    end

    if p7.Pass == "DoubleCash" then
        return "All your animals now make DOUBLE cash!"
    end

    if p7.Pass == "DoubleXp" then
        return "Every pull up now gives DOUBLE XP!"
    end

    if p7.Animals then
        return "Hold it and click your plot to place it!"
    end

    if p7.Power then
        return "Your throws now go further!"
    end

    if p7.Money then
        return "Buy better food and bars with it!"
    end

    if p7.SuperThrows then
        return "Use them when you throw!"
    end

    return "Enjoy!"
end

local function rewardTitle(p8) -- line: 137
    if p8.GiftFrom then
        return "GIFT FROM " .. string.upper(p8.GiftFrom.Name or "A FRIEND") .. "!"
    end

    if p8.Free then
        return "FREE ANIMAL!"
    end

    if p8.Pass then
        return "GAMEPASS UNLOCKED!"
    end

    return "PURCHASE SUCCESSFUL!"
end

local v8

local function showReward(p9) -- line: 150
    -- upvalues: RarityConfig (copy), NumberFormat (copy), ShopUI (copy), Sounds (copy), ScreenGui (ref), v3 (ref), rewardItems (copy), v8 (ref)
    v3 = true

    local Frame = Instance.new("Frame")

    Frame.Name = "Reward"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui

    local v9 = ShopUI.Dim(Frame, 1, 0.55)
    local v10 = false
    local v12 = ShopUI.Rays(Frame, p9.GiftFrom and Color3.fromRGB(255, 150, 215) or Color3.fromRGB(255, 222, 110), {
        ZIndex = 2,
        Count = 9,
        Width = 0.1,
        Alpha = 0.45,
        Speed = 18,
        Size = UDim2.fromScale(0.95, 0.95),
        Position = UDim2.fromScale(0.5, 0.43)
    })

    v12.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = v12
    ShopUI.Tween(UIScale, {
        Scale = 1
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local v13 = ShopUI.Frame({
        Name = "Glow",
        Transparency = 1,
        ZIndex = 2,
        Parent = Frame,
        Size = UDim2.fromScale(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.43),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = p9.GiftFrom and Color3.fromRGB(255, 170, 220) or Color3.fromRGB(255, 235, 150),
        Corner = UDim.new(0.5, 0)
    })

    v13.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v13
    ShopUI.Tween(v13, {
        BackgroundTransparency = 0.35
    }, 0.4)

    local v14 = ShopUI.Text({
        Name = "Title",
        ZIndex = 10,
        Stroke = 5,
        Parent = Frame,
        Text = if p9.GiftFrom then "GIFT FROM " .. string.upper(p9.GiftFrom.Name or "A FRIEND") .. "!"
            elseif p9.Free then "FREE ANIMAL!"
            elseif p9.Pass then "GAMEPASS UNLOCKED!"
            else "PURCHASE SUCCESSFUL!",
        Size = UDim2.fromScale(0.7, 0.1),
        Position = UDim2.fromScale(0.5, 0.15),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = p9.GiftFrom and {
            Color3.fromRGB(255, 235, 250),
            Color3.fromRGB(255, 120, 200),
            90
        } or {
            Color3.fromRGB(255, 250, 210),
            Color3.fromRGB(255, 185, 40),
            90
        }
    })
    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0.2
    UIScale2.Parent = v14
    ShopUI.Tween(UIScale2, {
        Scale = 1
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local v15 = rewardItems(p9)
    local v17 = math.max(#v15, 1)
    local v19 = math.min(0.2, 0.62 / v17)
    local v20 = ShopUI.Frame({
        Name = "Items",
        Transparency = 1,
        ZIndex = 5,
        Parent = Frame,
        Size = UDim2.fromScale(v19 * v17 + (v17 - 1) * 0.02, 0.3),
        Position = UDim2.fromScale(0.5, 0.43),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.02 / (v19 * v17 + (v17 - 1) * 0.02), 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v20

    local t13 = {}

    for v21, v22 in ipairs(v15) do
        local v23 = ShopUI.Frame({
            Transparency = 0.25,
            Corner = 18,
            Stroke = 4,
            ZIndex = 5,
            Ratio = 0.82,
            Parent = v20,
            Name = "Item" .. v21,
            Size = UDim2.fromScale(0, 1),
            Color = Color3.fromRGB(30, 34, 46)
        })

        v23.LayoutOrder = v21
        v23:FindFirstChildOfClass("UIAspectRatioConstraint").DominantAxis = Enum.DominantAxis.Height
        v23.Size = UDim2.fromScale(1, 1)

        local UIStroke = v23:FindFirstChildOfClass("UIStroke")

        if v22.Rarity then
            local v24 = RarityConfig.Get(v22.Rarity)

            UIStroke.Color = Color3.new(1, 1, 1)

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = v24.Gradient
            UIGradient.Rotation = 90
            UIGradient.Parent = UIStroke
        elseif v22.Color then
            UIStroke.Color = v22.Color
        end

        ShopUI.Frame({
            Name = "Shine",
            Transparency = 0.88,
            Corner = 14,
            ZIndex = 5,
            Parent = v23,
            Size = UDim2.new(1, -12, 0.35, 0),
            Position = UDim2.fromOffset(6, 5)
        })

        if v22.Model then
            local v25 = ShopUI.ItemModel(v22.Model)

            ShopUI.Viewport({
                Name = "Preview",
                ZIndex = 6,
                Pad = 1.05,
                Pitch = 0.17453292519943295,
                Parent = v23,
                Size = UDim2.fromScale(0.92, 0.68),
                Position = UDim2.fromScale(0.5, 0.05),
                AnchorPoint = Vector2.new(0.5, 0),
                Model = v25,
                Spin = v22.Model.Egg and 1.1 or 0.6,
                Bob = if v22.Model.Egg then 0.08 else nil
            })
        elseif v22.Image then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Icon"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = v22.Image
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Size = UDim2.fromScale(0.72, 0.56)
            ImageLabel.Position = UDim2.fromScale(0.5, 0.38)
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.ZIndex = 6
            ImageLabel.Parent = v23
        end

        ShopUI.Text({
            Name = "Name",
            ZIndex = 7,
            Stroke = 3,
            Parent = v23,
            Text = v22.Title,
            Size = UDim2.fromScale(0.9, 0.16),
            Position = UDim2.fromScale(0.5, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = v22.Money and Color3.fromRGB(140, 255, 90) or Color3.new(1, 1, 1)
        })

        if v22.OfBest then
            ShopUI.Text({
                Name = "OfBest",
                Rich = true,
                ZIndex = 7,
                Stroke = 2,
                Parent = v23,
                Text = NumberFormat.OfBest(v22.OfBest),
                Size = UDim2.fromScale(0.86, 0.1),
                Position = UDim2.fromScale(0.5, 0.93),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
        elseif v22.Income then
            ShopUI.Text({
                Name = "Income",
                ZIndex = 7,
                Stroke = 2,
                Parent = v23,
                Text = NumberFormat.PerSecond(v22.Income),
                Size = UDim2.fromScale(0.8, 0.1),
                Position = UDim2.fromScale(0.5, 0.93),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = Color3.fromRGB(140, 255, 90)
            })
        end

        if v22.Count and v22.Count > 1 or v22.Badge then
            local v26 = ShopUI.Frame({
                Name = "Count",
                Stroke = 3,
                ZIndex = 8,
                Parent = v23,
                Size = UDim2.fromScale(0.38, 0.18),
                Position = UDim2.fromScale(0.92, 0.06),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Corner = UDim.new(0.5, 0),
                Gradient = {
                    Color3.fromRGB(255, 226, 90),
                    Color3.fromRGB(255, 150, 20),
                    90
                }
            })

            v26.Rotation = 10
            ShopUI.Text({
                ZIndex = 9,
                Stroke = 2,
                Parent = v26,
                Text = v22.Badge or "x" .. v22.Count,
                Size = UDim2.fromScale(0.8, 0.78),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
        end

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = 0
        UIScale.Parent = v23
        table.insert(t13, {
            Frame = v23,
            Scale = UIScale
        })
        task.delay(0.25 + 0.18 * (v21 - 1), function() -- line: 242
            -- upvalues: v10 (ref), v21 (copy), UIScale (copy), ShopUI (copy), Sounds (copy)
            if not v10 then
                ShopUI.Tween(UIScale, {
                    Scale = 1
                }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                Sounds.Play("CoinBurst", {
                    Volume = 0.55,
                    Pitch = 1 + 0.08 * v21
                })
            end
        end)
    end

    local v27 = ShopUI.Text({
        Name = "Hint",
        ZIndex = 10,
        Stroke = 3,
        TextTransparency = 1,
        Parent = Frame,
        Text = if p9.Eggs then "Hold the egg and click your plot to hatch it!"
            elseif p9.Pass == "DoubleCash" then "All your animals now make DOUBLE cash!"
            elseif p9.Pass == "DoubleXp" then "Every pull up now gives DOUBLE XP!"
            elseif p9.Animals then "Hold it and click your plot to place it!"
            elseif p9.Power then "Your throws now go further!"
            elseif p9.Money then "Buy better food and bars with it!"
            elseif p9.SuperThrows then "Use them when you throw!"
            else "Enjoy!",
        Size = UDim2.fromScale(0.6, 0.045),
        Position = UDim2.fromScale(0.5, 0.65),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    task.delay(v17 * 0.18 + 0.5, function() -- line: 250
        -- upvalues: v10 (ref), v27 (copy), ShopUI (copy)
        if not v10 then
            ShopUI.Tween(v27, {
                TextTransparency = 0
            }, 0.35)
        end
    end)

    local function close() -- line: 254
        -- upvalues: Frame (copy), v9 (copy), v10 (ref), UIScale (copy), v13 (copy), UIScale2 (copy), v20 (copy), t13 (copy), v27 (copy), ShopUI (copy), Sounds (copy), v3 (ref), v8 (ref)
        if v10 then
            return
        end

        v10 = true
        Sounds.Play("Pop")

        for v28, v29 in ipairs(t13) do
            task.delay(0.05 * (v28 - 1), function() -- line: 260
                -- upvalues: v29 (copy), ShopUI (copy)
                ShopUI.Tween(v29.Scale, {
                    Scale = 0.2
                }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            end)
        end

        ShopUI.Tween(v20, {
            Position = UDim2.fromScale(0.5, 0.96)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        ShopUI.Tween(UIScale, {
            Scale = 0
        }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        ShopUI.Tween(UIScale2, {
            Scale = 0
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        ShopUI.Tween(v27, {
            TextTransparency = 1
        }, 0.2)
        ShopUI.Tween(v13, {
            BackgroundTransparency = 1
        }, 0.3)
        ShopUI.Tween(v9, {
            BackgroundTransparency = 1
        }, 0.45)
        task.delay(0.55, function() -- line: 270
            -- upvalues: Frame (copy), v3 (ref), v8 (ref)
            Frame:Destroy()
            v3 = false
            v8()
        end)
    end

    local v30 = ShopUI.Button({
        Name = "OkButton",
        Text = "AWESOME!",
        Color = "Green",
        ZIndex = 10,
        Ratio = 3.4,
        Parent = Frame,
        Size = UDim2.fromScale(0.2, 0.085),
        Position = UDim2.fromScale(0.5, 0.78),
        AnchorPoint = Vector2.new(0.5, 0.5),
        OnClick = close
    })

    v30.Holder.Visible = false
    task.delay(v17 * 0.18 + 0.6, function() -- line: 279
        -- upvalues: v10 (ref), v30 (copy), ShopUI (copy)
        if not v10 then
            v30.Holder.Visible = true
            ShopUI.PopIn(v30.Holder, 0.35, 0.3)
        end
    end)
    v9.Activated:Connect(function() -- line: 284
        -- upvalues: close (copy), v30 (copy)
        if v30.Holder.Visible then
            close()
        end
    end)
    task.delay(8, close)
    Sounds.Play("Purchase")
    Sounds.Play("RewardShine", {
        Delay = 0.15
    })

    if p9.GiftFrom or p9.Pass or p9.Money or p9.Power or p9.SuperThrows then
        Sounds.Play("LevelUp", {
            Volume = 0.55,
            Pitch = 1.1,
            Delay = 0.25
        })
    end

    local AbsoluteSize = ScreenGui.AbsoluteSize

    ShopUI.Confetti(ScreenGui, Vector2.new(AbsoluteSize.X * 0.5, AbsoluteSize.Y * 0.45), 50, {
        ZIndex = 20
    })
    task.delay(0.2, function() -- line: 297
        -- upvalues: AbsoluteSize (copy), ShopUI (copy), ScreenGui (ref)
        ShopUI.Confetti(ScreenGui, Vector2.new(AbsoluteSize.X * 0.15, AbsoluteSize.Y * 0.9), 28, {
            ZIndex = 20,
            Direction = -65,
            Spread = 20
        })
        ShopUI.Confetti(ScreenGui, Vector2.new(AbsoluteSize.X * 0.85, AbsoluteSize.Y * 0.9), 28, {
            ZIndex = 20,
            Direction = -115,
            Spread = 20
        })
    end)
end

local v31 = false

v8 = function() -- line: 304
    -- upvalues: ClientState (copy), t3 (copy), v3 (ref), v8 (ref), showReward (copy), v31 (ref)
    if not (v3 or v31) then
        if not (ClientState.OfflineOpen and #t3 > 0) then
            local v32 = table.remove(t3, 1)

            if v32 then
                showReward(v32)
            end
        else
            v31 = true
            task.spawn(function() -- line: 309
                -- upvalues: ClientState (copy), v8 (ref), v31 (ref)
                while ClientState.OfflineOpen do
                    task.wait(0.25)
                end

                v31 = false
                v8()
            end)
        end
    end
end

function t1.ShowReward(p10) -- line: 320
    -- upvalues: t3 (copy), v8 (ref)
    table.insert(t3, p10)
    v8()
end

local ScreenGui2
local t20 = {}
local v33 = false

local function worldCloverBurst(p11, p12) -- line: 333
    -- upvalues: Players (copy), TweenService (copy), ShopUI (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p11)

    PlayerByUserId = PlayerByUserId and PlayerByUserId.Character and PlayerByUserId.Character:FindFirstChild("HumanoidRootPart")

    if not PlayerByUserId then
        return
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Position = PlayerByUserId.Position
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = ShopUI.Icons.Clover
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.15, 1.6),
        NumberSequenceKeypoint.new(1, 0.4)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(1.2, 2)
    ParticleEmitter.Speed = NumberRange.new(14, 26)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Acceleration = Vector3.new(0, -18, 0)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-200, 200)
    ParticleEmitter.LightEmission = 0.2
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(40)

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter2.Color = ColorSequence.new(p12, Color3.new(1, 1, 1))
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 1.4),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter2.Lifetime = NumberRange.new(0.6, 1.2)
    ParticleEmitter2.Speed = NumberRange.new(10, 22)
    ParticleEmitter2.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Parent = Part
    ParticleEmitter2:Emit(60)

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p12
    PointLight.Range = 26
    PointLight.Brightness = 6
    PointLight.Parent = Part
    TweenService:Create(PointLight, TweenInfo.new(1.6, Enum.EasingStyle.Quad), {
        Brightness = 0
    }):Play()

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = p12
    Part2.Size = Vector3.new(0.2, 2, 2)
    Part2.CFrame = CFrame.new(PlayerByUserId.Position - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Transparency = 0.2
    Part2.Parent = workspace
    TweenService:Create(Part2, TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.2, 34, 34),
        Transparency = 1
    }):Play()
    task.delay(2.5, function() -- line: 391
        -- upvalues: Part (copy), Part2 (copy)
        Part:Destroy()
        Part2:Destroy()
    end)
end

local function buildBanner(p13, p14, p15) -- line: 397
    -- upvalues: ShopUI (copy), ScreenGui2 (ref)
    local v34 = ShopUI.Frame({
        Name = "Banner",
        Transparency = 1,
        ZIndex = 5,
        Parent = ScreenGui2,
        Size = UDim2.fromScale(p15 or 0.46, 0),
        Position = UDim2.fromScale(0.5, -0.3),
        AnchorPoint = Vector2.new(0.5, 0),
        Ratio = p14 or 4.3
    })
    local UIAspectRatioConstraint = v34:FindFirstChildOfClass("UIAspectRatioConstraint")

    v34.Size = UDim2.fromScale(p15 or 0.46, 1)
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
    ShopUI.Frame({
        Name = "Shadow",
        Transparency = 0.55,
        Corner = 18,
        ZIndex = 5,
        Parent = v34,
        Position = UDim2.fromOffset(5, 8),
        Color = Color3.new(0, 0, 0)
    })

    local v35 = ShopUI.Frame({
        Name = "Glow",
        Transparency = 0.6,
        Corner = 24,
        ZIndex = 5,
        Parent = v34,
        Size = UDim2.new(1, 18, 1, 18),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = p13[1]
    })
    local v36 = ShopUI.Frame({
        Name = "Face",
        Corner = 18,
        Stroke = 4,
        ZIndex = 6,
        Clip = true,
        Parent = v34,
        Color = Color3.new(1, 1, 1),
        Gradient = {
            p13[1],
            p13[2],
            90
        }
    })
    local v37 = ShopUI.Stripes(v36, 0.86, 18, 20)

    v37.Size = UDim2.fromScale(2, 1)
    ShopUI.Frame({
        Name = "Shine",
        Transparency = 0.8,
        Corner = 14,
        ZIndex = 6,
        Parent = v36,
        Size = UDim2.new(1, -16, 0.4, 0),
        Position = UDim2.fromOffset(8, 5)
    })

    local v38 = ShopUI.Frame({
        Name = "Sweep",
        ZIndex = 7,
        Parent = v36,
        Size = UDim2.fromScale(0.18, 2),
        Position = UDim2.fromScale(-0.2, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    v38.Rotation = 18

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v38

    return v34, v36, v35, v37, v38
end

local function playBanner(p16, _, p18, p19, p20, p21) -- line: 417
    -- upvalues: RunService (copy), ShopUI (copy)
    ShopUI.Tween(p16, {
        Position = UDim2.fromScale(0.5, 0.11)
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 421
        -- upvalues: p16 (copy), p18 (copy), p19 (copy), elapsed (copy), connection (ref)
        if not p16.Parent then
            connection:Disconnect()

            return
        end

        local v39 = os.clock() - elapsed

        p19.Position = UDim2.fromScale(-(v39 * 0.1 % 0.4), 0)
        p18.BackgroundTransparency = math.sin(v39 * 6) * 0.15 + 0.55
    end)
    task.delay(0.55, function() -- line: 428
        -- upvalues: p20 (copy), ShopUI (copy)
        if p20.Parent then
            ShopUI.Tween(p20, {
                Position = UDim2.fromScale(1.2, 0.5)
            }, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        end
    end)
    task.delay(p21, function() -- line: 433
        -- upvalues: p16 (copy), ShopUI (copy)
        ShopUI.Tween(p16, {
            Position = UDim2.fromScale(0.5, -0.3)
        }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.5, function() -- line: 435
            -- upvalues: p16 (copy)
            p16:Destroy()
        end)
    end)
end

local function announceLuck(p22) -- line: 441
    -- upvalues: MonetizationConfig (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), ClientState (copy), LocalPlayer (copy), rgb (copy), ScreenGui2 (ref), worldCloverBurst (copy), buildBanner (copy), playBanner (copy)
    local v41, v42, v43, v44, v45 = buildBanner({
        Color3.fromRGB(120, 236, 110),
        rgb(24, 160, 72)
    }, 4.3)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Clover"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Clover
    ImageLabel.Size = UDim2.fromScale(1.45, 1.45)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.1, 0.45)
    ImageLabel.ZIndex = 9
    ImageLabel.Rotation = -200
    ImageLabel.Parent = v41

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.2
    UIScale.Parent = ImageLabel

    local v46 = if p22.UserId == LocalPlayer.UserId then "YOU" else string.upper(p22.Name or "SOMEONE")
    local ServerLuck = MonetizationConfig.ServerLuck
    local v47 = p22.Extended == true or p22.From == p22.To and (p22.To or 0) >= ServerLuck.MaxMultiplier
    local Minutes = p22.Minutes

    if not Minutes then
        Minutes = math.floor((v47 and ServerLuck.ExtendDuration or ServerLuck.Duration) / 60 + 0.5)
    end

    local function timeLeft() -- line: 466
        -- upvalues: p22 (copy), ShopUI (copy)
        local ServerLuckEnd = workspace:GetAttribute("ServerLuckEnd") or p22.EndsAt or 0

        return ShopUI.FormatTime((math.max(0, ServerLuckEnd - workspace:GetServerTimeNow())))
    end

    local v50, v51, v52

    if v47 then
        v50 = "<font color=\"#FFF6B0\">" .. v46 .. "</font> EXTENDED SERVER LUCK!"
        v51 = "+" .. Minutes .. " MINUTES"

        local To = p22.To
        local ServerLuckEnd = workspace:GetAttribute("ServerLuckEnd") or p22.EndsAt or 0

        v52 = To .. "x MAX LUCK FOR EVERYONE  |  " .. ShopUI.FormatTime((math.max(0, ServerLuckEnd - workspace:GetServerTimeNow()))) .. " LEFT"
    else
        v50 = "<font color=\"#FFF6B0\">" .. v46 .. "</font> BOUGHT SERVER LUCK!"
        v51 = p22.From .. "x  ▶  " .. p22.To .. "x"
        v52 = p22.Max and p22.To .. "x MAX LUCK  |  +" .. Minutes .. " MINUTES FOR EVERYONE" or "+" .. Minutes .. " MINUTES FOR EVERYONE IN THE SERVER"
    end

    ShopUI.Text({
        Name = "Line1",
        Rich = true,
        ZIndex = 8,
        Stroke = 3,
        Parent = v42,
        Text = v50,
        Size = UDim2.fromScale(0.66, 0.24),
        Position = UDim2.fromScale(0.63, 0.2),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v54 = ShopUI.Text({
        Name = "Big",
        ZIndex = 8,
        Stroke = 5,
        Parent = v42,
        Text = v51,
        Size = UDim2.fromScale(0.6, 0.42),
        Position = UDim2.fromScale(0.63, 0.55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.fromRGB(255, 250, 200),
            Color3.fromRGB(255, 196, 40),
            90
        }
    })
    local v55 = ShopUI.Text({
        Name = "Line3",
        ZIndex = 8,
        Stroke = 2,
        Parent = v42,
        Text = v52,
        Size = UDim2.fromScale(0.66, 0.17),
        Position = UDim2.fromScale(0.63, 0.86),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0.4
    UIScale2.Parent = v54
    Sounds.Play("LuckUp")
    playBanner(v41, v42, v43, v44, v45, 4.8)
    task.delay(0.35, function() -- line: 489
        -- upvalues: ImageLabel (copy), UIScale (copy), ShopUI (copy)
        ShopUI.Tween(ImageLabel, {
            Rotation = -8
        }, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    task.delay(0.55, function() -- line: 493
        -- upvalues: p22 (copy), UIScale2 (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), ClientState (copy), rgb (copy), ScreenGui2 (ref), worldCloverBurst (copy)
        Sounds.Play("AnnounceBass")
        Sounds.Play("Announce")
        Sounds.Play("CoinBurst", {
            Delay = 0.1
        })
        ScreenFX.Flash(Color3.fromRGB(120, 255, 120), 0.22, 0.6)
        ScreenFX.Ring(Color3.fromRGB(140, 255, 120), 0.8, 60)

        if not ClientState.Busy then
            CameraRig.PunchFOV(5, 0.06, 0.5)
        end

        ShopUI.Tween(UIScale2, {
            Scale = 1
        }, 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

        local AbsoluteSize = ScreenGui2.AbsoluteSize

        for i = 1, 5 do
            task.delay(i * 0.06, function() -- line: 504
                -- upvalues: AbsoluteSize (copy), i (copy), ShopUI (copy), rgb (copy), ScreenGui2 (ref)
                ShopUI.Confetti(ScreenGui2, Vector2.new(AbsoluteSize.X * ((i - 1) * 0.2 + 0.1), -10), 22, {
                    ZIndex = 20,
                    Direction = 90,
                    Spread = 35,
                    MinSpeed = 120,
                    MaxSpeed = 360,
                    Gravity = 520,
                    Colors = {
                        Color3.fromRGB(120, 236, 110),
                        Color3.fromRGB(255, 214, 72),
                        Color3.new(1, 1, 1),
                        rgb(40, 190, 90)
                    }
                })
            end)
        end

        worldCloverBurst(p22.UserId, rgb(110, 255, 120))
    end)
    task.spawn(function() -- line: 511
        -- upvalues: p22 (copy), ImageLabel (copy), v55 (copy), v47 (copy), ShopUI (copy)
        local elapsed = os.clock()

        while ImageLabel.Parent do
            local v56 = os.clock() - elapsed

            if v56 > 1.2 then
                ImageLabel.Rotation = math.sin(v56 * 3) * 6 + -8
            end

            if v47 then
                local To = p22.To
                local ServerLuckEnd = workspace:GetAttribute("ServerLuckEnd") or p22.EndsAt or 0

                v55.Text = To .. "x MAX LUCK FOR EVERYONE  |  " .. ShopUI.FormatTime((math.max(0, ServerLuckEnd - workspace:GetServerTimeNow()))) .. " LEFT"
            end

            task.wait()
        end
    end)

    return 5.3
end

local function announceGift(p23) -- line: 525
    -- upvalues: ShopUI (copy), Sounds (copy), LocalPlayer (copy), rgb (copy), ScreenGui2 (ref), buildBanner (copy), playBanner (copy)
    local v59, v60, v61, v62, v63 = buildBanner({
        Color3.fromRGB(255, 150, 215),
        rgb(214, 60, 150)
    }, 4.8)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Gift"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Gift
    ImageLabel.Size = UDim2.fromScale(1.3, 1.3)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.09, 0.45)
    ImageLabel.ZIndex = 9
    ImageLabel.Parent = v59

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.2
    UIScale.Parent = ImageLabel

    local v64 = p23.ToUserId == LocalPlayer.UserId
    local v65 = p23.FromUserId == LocalPlayer.UserId
    local v66 = if v65 then "YOU" else string.upper(p23.FromName or "SOMEONE")
    local v67 = if v64 then "YOU" else string.upper(p23.ToName or "SOMEONE")

    ShopUI.Text({
        Rich = true,
        ZIndex = 8,
        Stroke = 3,
        Parent = v60,
        Text = "<font color=\"#FFF6B0\">" .. v66 .. "</font> GIFTED <font color=\"#FFF6B0\">" .. v67 .. "</font>",
        Size = UDim2.fromScale(0.7, 0.28),
        Position = UDim2.fromScale(0.6, 0.26),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v68 = ShopUI.Text({
        ZIndex = 8,
        Stroke = 5,
        Parent = v60,
        Text = string.upper(p23.ItemName or "A GIFT") .. "!",
        Size = UDim2.fromScale(0.7, 0.42),
        Position = UDim2.fromScale(0.6, 0.66),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 214, 240),
            90
        }
    })
    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0.4
    UIScale2.Parent = v68
    playBanner(v59, v60, v61, v62, v63, 3.6)
    task.delay(0.4, function() -- line: 551
        -- upvalues: UIScale (copy), v65 (copy), UIScale2 (copy), v64 (copy), ShopUI (copy), Sounds (copy), rgb (copy), ScreenGui2 (ref)
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        ShopUI.Tween(UIScale2, {
            Scale = 1
        }, 0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        Sounds.Play("GiftSent", {
            Volume = (v64 or v65) and 0.8 or 0.45
        })

        local AbsoluteSize = ScreenGui2.AbsoluteSize

        ShopUI.Confetti(ScreenGui2, Vector2.new(AbsoluteSize.X * 0.5, AbsoluteSize.Y * 0.2), 30, {
            ZIndex = 20,
            Colors = {
                Color3.fromRGB(255, 150, 215),
                Color3.fromRGB(255, 255, 255),
                rgb(255, 214, 72)
            }
        })
    end)

    return 4
end

local function announceLucky(p24) -- line: 563
    -- upvalues: Players (copy), LuckyCatch (copy), MutationsConfig (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), ClientState (copy), LocalPlayer (copy), rgb (copy), ScreenGui2 (ref), worldCloverBurst (copy), buildBanner (copy), playBanner (copy)
    local Tiers = LuckyCatch.Config.Tiers
    local v71 = math.clamp(p24.Tier or 1, 1, #Tiers)
    local v72 = Tiers[v71]
    local v73 = p24.UserId == LocalPlayer.UserId
    local v74 = Players:GetPlayerByUserId(p24.UserId) ~= nil
    local v76, v77, v78, v79, v80 = buildBanner({
        v72.Colors[1],
        v72.Colors[2]
    }, 4.2, (math.min(v71 * 0.015 + 0.42, 0.52)))

    if v71 >= 3 then
        ShopUI.Rays(v76, v72.Colors[1], {
            ZIndex = 4,
            Width = 0.12,
            Alpha = 0.5,
            Size = UDim2.fromScale(2.3, 2.3),
            Position = UDim2.fromScale(0.08, 0.45),
            Count = v71 * 2 + 4,
            Speed = v71 * 15 + 30
        }).SizeConstraint = Enum.SizeConstraint.RelativeYY
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Clover"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Clover
    ImageLabel.Size = UDim2.fromScale(1.4, 1.4)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.08, 0.45)
    ImageLabel.ZIndex = 9
    ImageLabel.Rotation = -200
    ImageLabel.Parent = v76

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.2
    UIScale.Parent = ImageLabel

    local v81 = if v73 then "YOU" else string.upper(p24.Name or "SOMEONE")

    ShopUI.Text({
        Name = "Line1",
        Rich = true,
        ZIndex = 8,
        Stroke = 3,
        Parent = v77,
        Text = "<font color=\"#FFF6B0\">" .. v81 .. "</font> CAUGHT",
        Size = UDim2.fromScale(0.64, 0.22),
        Position = UDim2.fromScale(0.63, 0.17),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local v82 = MutationsConfig.Get(p24.Mutation)
    local v83 = ShopUI.Text({
        Name = "Big",
        ZIndex = 8,
        Stroke = 4,
        Parent = v77,
        Text = LuckyCatch.Describe(p24.Mutation, p24.Size, p24.Animal),
        Size = UDim2.fromScale(0.64, 0.36),
        Position = UDim2.fromScale(0.63, 0.47),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    if v82 and v82.Gradient then
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = v82.Gradient
        UIGradient.Rotation = v82.Name == "Rainbow" and 0 or 90
        UIGradient.Parent = v83
    else
        ShopUI.Gradient(v83, Color3.new(1, 1, 1), Color3.fromRGB(255, 236, 170), 90)
    end

    local v84 = ShopUI.Text({
        Name = "Odds",
        ZIndex = 8,
        Stroke = 4,
        Parent = v77,
        Text = LuckyCatch.Text(p24.OneIn, true),
        Size = UDim2.fromScale(0.5, 0.3),
        Position = UDim2.fromScale(0.63, 0.81),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.new(1, 1, 1),
            Color3.fromRGB(255, 246, 176),
            90
        }
    })
    local v85 = ShopUI.Text({
        Name = "Tier",
        ZIndex = 10,
        Stroke = 4,
        Parent = v76,
        Text = v72.Name,
        Size = UDim2.fromScale(0.3, 0.34),
        Position = UDim2.fromScale(0.93, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            v72.Colors[1],
            v72.Colors[2],
            90
        }
    })

    v85.Rotation = 8

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0.4
    UIScale2.Parent = v84

    local UIScale3 = Instance.new("UIScale")

    UIScale3.Scale = 0
    UIScale3.Parent = v85

    local v87 = math.min(v71 * 0.55 + 3.6, 7)

    playBanner(v76, v77, v78, v79, v80, v87)
    task.delay(0.35, function() -- line: 614
        -- upvalues: ImageLabel (copy), UIScale (copy), ShopUI (copy)
        ShopUI.Tween(ImageLabel, {
            Rotation = -8
        }, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    task.delay(0.55, function() -- line: 618
        -- upvalues: p24 (copy), v71 (copy), v72 (copy), v76 (copy), UIScale2 (copy), UIScale3 (copy), v73 (copy), v74 (copy), ShopUI (copy), Sounds (copy), ScreenFX (copy), CameraRig (copy), ClientState (copy), rgb (copy), ScreenGui2 (ref), worldCloverBurst (copy)
        if v76.Parent then
            Sounds.Play("LuckyAnnounce", {
                Volume = (v73 or v74) and 0.85 or 0.5,
                Pitch = v71 * 0.05 + 1.1
            })

            if v71 >= 3 then
                Sounds.Play("AnnounceBass", {
                    Volume = v71 * 0.1 + 0.4
                })
            end

            if v73 or v74 then
                Sounds.Play("CoinBurst", {
                    Delay = 0.1,
                    Volume = 0.6
                })
            end

            ShopUI.Tween(UIScale2, {
                Scale = 1
            }, 0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
            UIScale3.Scale = 2.2
            ShopUI.Tween(UIScale3, {
                Scale = 1
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            ScreenFX.Flash(v72.Colors[2], (v73 and 0.22 or 0.07) + v71 * 0.03, 0.6)

            if v71 >= 3 then
                ScreenFX.Ring(v72.Colors[1], 0.8, 60)
            end

            if v71 >= 5 and not ClientState.Busy then
                CameraRig.PunchFOV(4, 0.06, 0.5)
            end

            local AbsoluteSize = ScreenGui2.AbsoluteSize
            local v90 = math.clamp(v71 + (if v73 then 1 else 0), 1, 5)

            for i = 1, v90 do
                task.delay(i * 0.06, function() -- line: 633
                    -- upvalues: AbsoluteSize (copy), v90 (copy), i (copy), v71 (copy), v72 (copy), ShopUI (copy), rgb (copy), ScreenGui2 (ref)
                    ShopUI.Confetti(ScreenGui2, Vector2.new(AbsoluteSize.X * ((i - 0.5) * 0.8 / v90 + 0.1), -10), v71 * 4 + 10, {
                        ZIndex = 20,
                        Direction = 90,
                        Spread = 35,
                        MinSpeed = 120,
                        MaxSpeed = 360,
                        Gravity = 520,
                        Colors = {
                            v72.Colors[1],
                            v72.Colors[2],
                            Color3.new(1, 1, 1),
                            rgb(255, 214, 72)
                        }
                    })
                end)
            end

            if v74 then
                worldCloverBurst(p24.UserId, v72.Colors[2])
            end
        end
    end)
    task.spawn(function() -- line: 640
        -- upvalues: v72 (copy), v77 (copy), v78 (copy), ImageLabel (copy), v85 (copy)
        local elapsed = os.clock()
        local UIGradient = v77:FindFirstChildOfClass("UIGradient")
        local UIGradient2 = v85:FindFirstChildOfClass("UIGradient")

        while ImageLabel.Parent do
            local v91 = os.clock() - elapsed

            if v91 > 1.2 then
                ImageLabel.Rotation = math.sin(v91 * 3) * 6 + -8
            end

            if v72.Rainbow then
                local v93 = os.clock() * 0.4 % 1

                if UIGradient then
                    UIGradient.Color = ColorSequence.new(Color3.fromHSV(v93, 0.45, 1), Color3.fromHSV((v93 + 0.2) % 1, 0.75, 0.95))
                end

                if UIGradient2 then
                    UIGradient2.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV((v93 + 0.5) % 1, 0.7, 1))
                end

                v78.BackgroundColor3 = Color3.fromHSV(v93, 0.6, 1)
            end

            task.wait()
        end
    end)

    return v87 + 0.5
end

local function screenBusy() -- line: 660
    -- upvalues: ClientState (copy)
    if ClientState.Busy == "Throw" or ClientState.Busy == "Hatch" or ClientState.Busy == "Release" then
        return true
    end

    return ClientState.ReleaseShow == true
end

local function runAnnouncements() -- line: 667
    -- upvalues: ClientState (copy), LocalPlayer (copy), t20 (copy), v33 (ref), announceLuck (copy), announceGift (copy), announceLucky (copy)
    if not v33 then
        v33 = true
        task.spawn(function() -- line: 670
            -- upvalues: ClientState (copy), LocalPlayer (copy), t20 (copy), v33 (ref), announceLuck (copy), announceGift (copy), announceLucky (copy)
            while #t20 > 0 do
                while true do
                    if ClientState.OfflineOpen then
                        task.wait(0.25)
                        continue
                    end

                    if ClientState.Busy == "Throw" or ClientState.Busy == "Hatch" or ClientState.Busy == "Release" or ClientState.ReleaseShow == true then
                        task.wait(0.25)
                        continue
                    end

                    break
                end

                local v94 = table.remove(t20, 1)
                local v95 = if v94.Type == "ServerLuck" then announceLuck(v94)
                    elseif v94.Type == "Gift" then announceGift(v94)
                    elseif v94.Type ~= "LuckyCatch" then 0
                    elseif (if v94.UserId == LocalPlayer.UserId then 120 else 40) >= os.clock() - (v94.ReceivedAt or os.clock()) then announceLucky(v94)
                    else 0

                task.wait(v95)
            end

            v33 = false
        end)
    end
end

local function luckyPriority(p25) -- line: 693
    -- upvalues: Players (copy), LocalPlayer (copy)
    local v96 = Players:GetPlayerByUserId(p25.UserId) ~= nil

    return (if p25.UserId == LocalPlayer.UserId then 2000 else 0) + (if v96 then 1000 else 0) + math.log10((math.max(tonumber(p25.OneIn) or 1, 1)))
end

function t1.Announce(p26) -- line: 698
    -- upvalues: Players (copy), ClientState (copy), LocalPlayer (copy), t20 (copy), v33 (ref), announceLuck (copy), announceGift (copy), announceLucky (copy)
    if p26.Type == "LuckyCatch" then
        p26.ReceivedAt = os.clock()

        local v100 = Players:GetPlayerByUserId(p26.UserId) ~= nil

        p26.Priority = (if p26.UserId == LocalPlayer.UserId then 2000 else 0) + (if v100 then 1000 else 0) + math.log10((math.max(tonumber(p26.OneIn) or 1, 1)))

        local t26 = {}

        for v104, v105 in ipairs(t20) do
            if v105.Type == "LuckyCatch" then
                table.insert(t26, v104)
            end
        end

        if #t26 >= 4 then
            local n1 = 1e999
            local v106

            for _, v107 in ipairs(t26) do
                if t20[v107].Priority < n1 then
                    v106 = v107
                    n1 = t20[v107].Priority
                end
            end

            if p26.Priority <= n1 then
                return
            end

            table.remove(t20, v106)
        end
    end

    table.insert(t20, p26)

    if not v33 then
        v33 = true
        task.spawn(function() -- line: 670
            -- upvalues: ClientState (copy), LocalPlayer (copy), t20 (copy), v33 (ref), announceLuck (copy), announceGift (copy), announceLucky (copy)
            while #t20 > 0 do
                while true do
                    if ClientState.OfflineOpen then
                        task.wait(0.25)
                        continue
                    end

                    if ClientState.Busy == "Throw" or ClientState.Busy == "Hatch" or ClientState.Busy == "Release" or ClientState.ReleaseShow == true then
                        task.wait(0.25)
                        continue
                    end

                    break
                end

                local v108 = table.remove(t20, 1)
                local v109 = if v108.Type == "ServerLuck" then announceLuck(v108)
                    elseif v108.Type == "Gift" then announceGift(v108)
                    elseif v108.Type ~= "LuckyCatch" then 0
                    elseif (if v108.UserId == LocalPlayer.UserId then 120 else 40) >= os.clock() - (v108.ReceivedAt or os.clock()) then announceLucky(v108)
                    else 0

                task.wait(v109)
            end

            v33 = false
        end)
    end
end

local TextButton, UIScale, v110, v111, v112, v113
local v114 = UDim2.new(1, -14, 0, 14)
local v115 = false
local n2 = 1

local function buildWidget() -- line: 731
    -- upvalues: RunService (copy), ShopUI (copy), Sounds (copy), ClientState (copy), ExclusiveShopController (copy), PlayerGui (copy), TextButton (ref), UIScale (ref), v110 (ref), v111 (ref), v112 (ref), v113 (ref), v114 (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ServerLuckHUD"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 4
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Widget"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1

    local TextButton2 = TextButton

    TextButton2.Size = UDim2.fromScale(0.19, 0.2)

    local TextButton3 = TextButton

    TextButton3.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local TextButton4 = TextButton

    TextButton4.AnchorPoint = Vector2.new(1, 0)
    TextButton.Position = v114
    TextButton.ZIndex = 2
    TextButton.Visible = false
    TextButton.Parent = ScreenGui
    UIScale = Instance.new("UIScale")
    UIScale.Parent = TextButton

    local v116 = ShopUI.Frame({
        Name = "Glow",
        Transparency = 0.5,
        ZIndex = 2,
        Parent = TextButton,
        Size = UDim2.fromScale(0.95, 0.95),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(120, 255, 120),
        Corner = UDim.new(0.5, 0)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = v116
    ShopUI.Rays(TextButton, Color3.fromRGB(170, 255, 150), {
        ZIndex = 2,
        Count = 6,
        Width = 0.12,
        Alpha = 0.6,
        Speed = 30,
        Size = UDim2.fromScale(1.25, 1.25),
        Position = UDim2.fromScale(0.5, 0.45)
    })

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Clover"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = ShopUI.Icons.Clover
    ImageLabel.Size = UDim2.fromScale(0.82, 0.82)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.44)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton
    v110 = ShopUI.Text({
        Name = "Multiplier",
        Text = "2x",
        ZIndex = 5,
        Stroke = 4,
        Parent = TextButton,
        Size = UDim2.fromScale(0.7, 0.36),
        Position = UDim2.fromScale(0.78, 0.14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Gradient = {
            Color3.fromRGB(255, 250, 200),
            Color3.fromRGB(255, 190, 30),
            90
        }
    })
    v110.Rotation = 10
    v112, v111 = ShopUI.Pill({
        Name = "Timer",
        Text = "15:00",
        ZIndex = 5,
        Parent = TextButton,
        Size = UDim2.fromScale(0.82, 0.24),
        Position = UDim2.fromScale(0.5, 0.9),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    v113 = ShopUI.Frame({
        Name = "Tooltip",
        Transparency = 0.1,
        Corner = 12,
        Stroke = 3,
        ZIndex = 8,
        Visible = false,
        Parent = TextButton,
        Size = UDim2.fromScale(2.6, 0.5),
        Position = UDim2.fromScale(-0.08, 0.45),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Color3.fromRGB(30, 34, 46)
    })

    local v117 = ShopUI.Text({
        Name = "Text",
        Rich = true,
        Text = "",
        ZIndex = 9,
        Stroke = 2,
        Wrap = true,
        Parent = v113,
        Size = UDim2.fromScale(0.92, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    TextButton.MouseEnter:Connect(function() -- line: 768
        -- upvalues: v117 (copy), ShopUI (copy), Sounds (copy), ClientState (copy), UIScale (ref), v113 (ref)
        if ClientState.Busy ~= "Throw" and ClientState.Busy ~= "Hatch" and ClientState.Busy ~= "Release" and ClientState.ReleaseShow ~= true then
            local v118 = workspace:GetAttribute("ServerLuck") or 1

            v117.Text = "<font color=\"#8CFF6A\">SERVER LUCK " .. v118 .. "x</font>\nEvery new animal rolls mutation + size " .. v118 .. " times - the best wins!"
            v113.Visible = true
            ShopUI.PopIn(v113, 0.25, 0.8)
        end

        ShopUI.Tween(UIScale, {
            Scale = 1.08
        }, 0.15, Enum.EasingStyle.Back)
        Sounds.Play("ButtonHover")
    end)
    TextButton.MouseLeave:Connect(function() -- line: 780
        -- upvalues: ShopUI (copy), UIScale (ref), v113 (ref)
        v113.Visible = false
        ShopUI.Tween(UIScale, {
            Scale = 1
        }, 0.15, Enum.EasingStyle.Back)
    end)
    TextButton.Activated:Connect(function() -- line: 784
        -- upvalues: Sounds (copy), ExclusiveShopController (copy)
        Sounds.Play("ButtonClick")
        ExclusiveShopController.Open("ServerLuck")
    end)
    RunService.RenderStepped:Connect(function() -- line: 789
        -- upvalues: v116 (copy), ImageLabel (copy), ClientState (copy), TextButton (ref), v113 (ref)
        if TextButton.Visible then
            if v113.Visible and (ClientState.Busy == "Throw" or ClientState.Busy == "Hatch" or ClientState.Busy == "Release" or ClientState.ReleaseShow == true) then
                v113.Visible = false
            end

            local elapsed = os.clock()

            ImageLabel.Rotation = math.sin(elapsed * 1.8) * 7
            ImageLabel.Position = UDim2.fromScale(0.5, math.sin(elapsed * 2.4) * 0.015 + 0.44)
            v116.BackgroundTransparency = math.sin(elapsed * 3) * 0.12 + 0.45
        end
    end)
end

local v122 = false

function t1.SetWidgetHidden(p27) -- line: 801
    -- upvalues: TweenService (copy), TextButton (ref), v114 (copy), v122 (ref)
    local v123

    if not TextButton or p27 == v122 then
        return
    else
        v122 = p27
        v123 = p27 and TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In) or TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    TweenService:Create(TextButton, v123, {
        Position = p27 and UDim2.new(1, 320, 0, 14) or v114
    }):Play()
end

local function refreshWidget(p28) -- line: 809
    -- upvalues: ShopUI (copy), TextButton (ref), UIScale (ref), v110 (ref), v111 (ref), v112 (ref), v115 (ref), n2 (ref)
    local v125 = workspace:GetAttribute("ServerLuck") or 1
    local v126 = (workspace:GetAttribute("ServerLuckEnd") or 0) - workspace:GetServerTimeNow()
    local v127 = v125 > 1 and v126 > 0

    if v127 then
        local v128 = v110

        v128.Text = v125 .. "x"

        local v129 = v111

        v129.Text = ShopUI.FormatTime(v126)

        local v130 = v126 < 60
        local v131 = v111

        v131.TextColor3 = v130 and Color3.fromRGB(255, 110, 110) or Color3.new(1, 1, 1)

        if v115 then
            if p28 and v125 ~= n2 then
                ShopUI.Punch(v110, 0.6, 0.6)
                ShopUI.Punch(v112, 0.25, 0.5)
            end
        else
            v115 = true
            TextButton.Visible = true
            UIScale.Scale = 0
            ShopUI.Tween(UIScale, {
                Scale = 1
            }, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    elseif v115 then
        v115 = false
        ShopUI.Tween(UIScale, {
            Scale = 0
        }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Once(function() -- line: 831
            -- upvalues: TextButton (ref), v115 (ref)
            if not v115 then
                TextButton.Visible = false
            end
        end)
    end

    if not v127 or not v125 then
        v125 = 1
    end

    n2 = v125
end

function t1.Init() -- line: 842
    -- upvalues: RunService (copy), Remotes (copy), ClientState (copy), t1 (copy), PlayerGui (copy), ScreenGui (ref), ScreenGui2 (ref), v115 (ref), buildWidget (copy), refreshWidget (copy)
    local ScreenGui3 = Instance.new("ScreenGui")

    ScreenGui3.Name = "ShopRewards"
    ScreenGui3.ResetOnSpawn = false
    ScreenGui3.IgnoreGuiInset = true
    ScreenGui3.DisplayOrder = 60
    ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui3.Parent = PlayerGui
    ScreenGui = ScreenGui3

    local ScreenGui4 = Instance.new("ScreenGui")

    ScreenGui4.Name = "Announcements"
    ScreenGui4.ResetOnSpawn = false
    ScreenGui4.IgnoreGuiInset = true
    ScreenGui4.DisplayOrder = 45
    ScreenGui4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui4.Parent = PlayerGui
    ScreenGui2 = ScreenGui4
    RunService.Heartbeat:Connect(function() -- line: 847
        -- upvalues: ClientState (copy), ScreenGui2 (ref)
        ScreenGui2.Enabled = not (ClientState.Busy == "Throw" or ClientState.Busy == "Hatch" or ClientState.Busy == "Release" or ClientState.ReleaseShow == true)
    end)
    buildWidget()
    Remotes.Event("Shop_Reward").OnClientEvent:Connect(function(p29) -- line: 851
        -- upvalues: t1 (copy)
        if type(p29) == "table" then
            t1.ShowReward(p29)
        end
    end)
    Remotes.Event("Shop_Announce").OnClientEvent:Connect(function(p30) -- line: 854
        -- upvalues: t1 (copy), refreshWidget (copy)
        if type(p30) == "table" then
            if p30.Type == "ServerLuckEnded" then
                refreshWidget(false)
            else
                t1.Announce(p30)
            end
        end
    end)
    workspace:GetAttributeChangedSignal("ServerLuck"):Connect(function() -- line: 862
        -- upvalues: refreshWidget (copy)
        refreshWidget(true)
    end)
    workspace:GetAttributeChangedSignal("ServerLuckEnd"):Connect(function() -- line: 863
        -- upvalues: refreshWidget (copy)
        refreshWidget(true)
    end)
    refreshWidget(false)
    task.spawn(function() -- line: 865
        -- upvalues: v115 (ref), refreshWidget (copy)
        while true do
            task.wait(0.25)

            if v115 or (workspace:GetAttribute("ServerLuck") or 1) > 1 then
                refreshWidget(false)
            end
        end
    end)
end

return t1

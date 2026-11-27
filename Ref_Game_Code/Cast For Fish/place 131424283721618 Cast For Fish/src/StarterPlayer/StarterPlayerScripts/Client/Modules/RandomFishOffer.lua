-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

game:GetService("TweenService")

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Products = require(Shared.Data.Products)
local RandomFish = require(Shared.Data.RandomFish)
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local Toasts = require(script.Parent.Toasts)
local FishIcons = require(script.Parent.FishIcons)
local LocalPlayer = Players.LocalPlayer
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local v2 = fromRGB(255, 255, 255)
local v3 = fromRGB(0, 0, 0)
local v4 = utf8.char(57346)

local function silhouette(p1, p2, p3, p4) -- line: 38
    -- upvalues: FishIcons (copy), v3 (copy)
    local v5 = FishIcons.Picture(p1, p2, 1, p3)

    if p4 and (v5:IsA("ImageLabel") or v5:IsA("ViewportFrame")) then
        v5.ImageColor3 = v3
    end

    return v5
end

local v6

local function picturedFish() -- line: 47
    -- upvalues: RandomFish (copy), FishIcons (copy), v6 (ref)
    if v6 then
        return v6
    end

    v6 = {}

    for _, v7 in ipairs(RandomFish.All()) do
        if FishIcons.Get(v7, 1) or FishIcons.Cell(v7, 1) then
            table.insert(v6, v7)
        end
    end

    if #v6 == 0 then
        v6 = RandomFish.All()
    end

    return v6
end

local function randomOther(p5, p6, p7) -- line: 62
    -- upvalues: randomOther (copy)
    local v9 = p6[p5:NextInteger(1, #p6)]

    if v9 ~= p7 or not (#p6 > 1) then
        return v9
    end

    return randomOther(p5, p6, p7)
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 73
    -- upvalues: UIKit (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Gui = UIKit.screenGui("RandomFishOdds", 12)
    self.Gui.ScreenInsets = Enum.ScreenInsets.None
    self.Gui.Enabled = false
    self.Opened = 0
    self:Build()

    return self
end

function t1:Build() -- line: 83
    -- upvalues: RandomFish (copy), Rarities (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy), v2 (copy), v3 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Shade"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v3
    TextButton.BackgroundTransparency = 0.45
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.Parent = self.Gui
    TextButton.Activated:Connect(function() -- line: 92
        -- upvalues: self (copy)
        self:Close()
    end)

    local v11 = RandomFish.Entries()
    local v13 = math.ceil(#v11 / 2)
    local v14 = v13 * 50 + 86 + 96
    local v15 = UIKit.frame(self.Gui, {
        Name = "Panel",
        Corner = 20,
        Stroke = 6,
        ZIndex = 2,
        Size = UDim2.fromOffset(900, v14),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = Colors.Dark
    })

    v15.Active = true
    self.Panel = v15

    local v16 = UIKit.text(v15, {
        Name = "Title",
        Text = "RANDOM FISH CHANCES",
        TextSize = 40,
        Stroke = 5,
        ZIndex = 3,
        Size = UDim2.new(1, -110, 0, 56),
        Position = UDim2.fromOffset(24, 10),
        XAlign = Enum.TextXAlignment.Left
    })

    UIKit.gradient(v16, fromRGB(255, 246, 150), fromRGB(255, 180, 50))
    UIKit.button(v15, {
        Name = "Close",
        Text = "X",
        Corner = 25,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.fromOffset(50, 50),
        Position = UDim2.new(1, -12, 0, 12),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 104
            -- upvalues: self (copy)
            self:Close()
        end
    })

    local v17 = RandomFish.Pool()
    local v18 = RandomFish.Total()

    for v19, v20 in v11 do
        local v21 = if v19 <= v13 then 0 else 1
        local v22 = if v21 == 0 then v19 - 1 else v19 - 1 - v13
        local v23 = Rarities.ById[v20.rarity]
        local v24 = UIKit.frame(v15, {
            Corner = 10,
            ZIndex = 3,
            Name = v20.rarity,
            Size = UDim2.fromOffset(418, 44),
            Position = UDim2.fromOffset(v21 * 434 + 24, 76 + v22 * 50),
            Color = Colors.Panel
        })

        UIKit.frame(v24, {
            Name = "Swatch",
            Corner = 5,
            ZIndex = 4,
            Size = UDim2.fromOffset(10, 32),
            Position = UDim2.fromOffset(6, 6),
            Color = v23.Color,
            Color2 = v23.Color2
        })

        local v25 = UIKit.text(v24, {
            Name = "Rarity",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 4,
            Text = string.upper(v20.rarity),
            Size = UDim2.fromOffset(190, 44),
            Position = UDim2.fromOffset(24, 0),
            XAlign = Enum.TextXAlignment.Left,
            Color = v2
        })

        UIKit.gradient(v25, v23.Color:Lerp(v2, 0.25), v23.Color2:Lerp(v2, 0.15))

        local v26 = #v17[v20.rarity]

        UIKit.text(v24, {
            Name = "Count",
            TextSize = 19,
            Stroke = 2,
            ZIndex = 4,
            Text = v26 .. " fish",
            Size = UDim2.fromOffset(90, 44),
            Position = UDim2.fromOffset(212, 0),
            XAlign = Enum.TextXAlignment.Left,
            Color = Colors.Grey
        })
        UIKit.text(v24, {
            Name = "Chance",
            TextSize = 26,
            Stroke = 3,
            ZIndex = 4,
            Text = string.format("%.4g%%", v20.chance / v18 * 100),
            Size = UDim2.fromOffset(120, 44),
            Position = UDim2.new(1, -12, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            XAlign = Enum.TextXAlignment.Right,
            Color = Colors.Gold
        })
    end

    UIKit.text(v15, {
        Name = "Note",
        Text = "You get exactly one fish. Every fish of a rarity has the same chance as the others of that rarity. Spirit, Cosmic and end-game fish are never included.",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 3,
        Size = UDim2.new(1, -48, 0, 70),
        Position = UDim2.new(0, 24, 1, -84),
        Color = fromRGB(200, 206, 230)
    }).TextWrapped = true
end

function t1:Open() -- line: 127
    -- upvalues: UIKit (copy)
    self.Opened += 1
    self.Gui.Enabled = true
    UIKit.pop(self.Panel, 0.75)
    UIKit.sound("WindowOpen")
end

function t1:Close() -- line: 134
    -- upvalues: UIKit (copy)
    if self.Gui.Enabled then
        self.Gui.Enabled = false
        UIKit.sound("WindowClose")
    end
end

local t4 = {}

t4.__index = t4

function t4.new() -- line: 144
    -- upvalues: UIKit (copy), t4 (copy)
    local self = setmetatable({}, t4)

    self.Gui = UIKit.screenGui("RandomFishReveal", 20)
    self.Gui.ScreenInsets = Enum.ScreenInsets.None
    self.Gui.Enabled = false
    self.Rng = Random.new()
    self.Playing = false
    self.Played = 0
    self.Stage = "idle"
    self.Last = nil
    self.Hold = nil

    return self
end

function t4:Clear() -- line: 158
    for _, child in self.Gui:GetChildren() do
        if not child:IsA("UIScale") then
            child:Destroy()
        end
    end
end

function t4:StartFrom(p13) -- line: 166
    local AbsoluteSize = self.Gui.AbsoluteSize

    if p13 and p13.Visible and p13.AbsoluteSize.X > 0 and AbsoluteSize.X > 0 then
        local v28 = p13.AbsolutePosition + p13.AbsoluteSize / 2

        return UDim2.fromScale(v28.X / AbsoluteSize.X, v28.Y / AbsoluteSize.Y)
    end

    return UDim2.new(1, 160, 0.5, 0)
end

function t4.Label(_, p15, p16, p17, p18, p19, p20, p21, p22) -- line: 175
    -- upvalues: UIKit (copy)
    local v31 = UIKit.text(p15, {
        ZIndex = 20,
        Name = p16,
        Text = p17,
        TextSize = p18,
        Size = UDim2.fromOffset(1400, p18 + 10),
        Position = UDim2.new(0.5, 0, 0, p19),
        AnchorPoint = Vector2.new(0.5, 0),
        Stroke = math.max(4, (math.floor(p18 / 11))),
        StrokeColor = p22
    })

    UIKit.gradient(v31, p20, p21)
    v31.Visible = false

    return v31
end

function t4:Play(p24, p25) -- line: 182
    -- upvalues: RunService (copy), Fish (copy), Rarities (copy), Roll (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), Colors (copy), fromRGB (copy), v1 (copy), v2 (copy), v3 (copy), picturedFish (copy), randomOther (copy)
    local v32 = Fish.ById[p24.fishId]
    local v33

    if not v32 or self.Playing then
        return
    else
        self.Playing = true
        self.Played += 1
        self.Last = p24
        self.Stage = "fly"
        UIKit.closeAllWindows()
        self:Clear()
        self.Gui.Enabled = true
        v33 = Rarities.ById[v32.rarity] or Rarities.List[1]
    end

    local v35 = UIKit.frame(self.Gui, {
        Name = "Shade",
        Transparency = 1,
        ZIndex = 1,
        Color = v3
    })

    v35.Size = UDim2.fromScale(1, 1)
    UIKit.tween(v35, 0.3, {
        BackgroundTransparency = 0.35
    })

    local v36 = UIKit.frame(self.Gui, {
        Name = "Stage",
        Transparency = 1,
        ZIndex = 5,
        Size = UDim2.fromOffset(420, 420),
        Position = self:StartFrom(p25),
        AnchorPoint = v1
    })
    local v37 = UIKit.scaleOf(v36)

    v37.Scale = 0.42

    local v38 = UIKit.image(v36, "Rays", {
        Transparency = 0.55,
        ZIndex = 5,
        Size = UDim2.fromOffset(820, 820),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 236, 150)
    })
    local v39 = UIKit.image(v36, "Glow", {
        Transparency = 0.5,
        ZIndex = 6,
        Size = UDim2.fromOffset(560, 560),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 245, 200)
    })
    local v40 = UIKit.frame(v36, {
        Name = "Fish",
        Transparency = 1,
        ZIndex = 8,
        Size = UDim2.fromOffset(330, 280),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1
    })
    local v41 = UIKit.text(v36, {
        Name = "Mystery",
        Text = "?",
        TextSize = 150,
        Stroke = 9,
        ZIndex = 12,
        Size = UDim2.fromOffset(200, 170),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = Colors.Red
    })
    local elapsed = os.clock()
    local n1 = 30
    local connection = RunService.RenderStepped:Connect(function() -- line: 207
        -- upvalues: v38 (copy), elapsed (copy), n1 (ref)
        v38.Rotation = (os.clock() - elapsed) * n1
    end)

    local function show(p26, p27) -- line: 211
        -- upvalues: v40 (copy), FishIcons (copy), v3 (copy)
        v40:ClearAllChildren()

        local v43 = FishIcons.Picture(v40, p26, 1, 1.15)

        if p27 and (v43:IsA("ImageLabel") or v43:IsA("ViewportFrame")) then
            v43.ImageColor3 = v3
        end
    end

    local v44 = picturedFish()
    local Rng = self.Rng
    local v45 = v44[Rng:NextInteger(1, #v44)]

    if v45 == nil and #v44 > 1 then
        v45 = randomOther(Rng, v44, nil)
    end

    v40:ClearAllChildren()

    local v46 = FishIcons.Picture(v40, v45, 1, 1.15)

    if v46:IsA("ImageLabel") or v46:IsA("ViewportFrame") then
        v46.ImageColor3 = v3
    end

    UIKit.tween(v36, 0.6, {
        Position = UDim2.fromScale(0.5, 0.52)
    }, Enum.EasingStyle.Quad)
    UIKit.tween(v37, 0.6, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.sound("Riser")
    task.wait(0.6)
    self.Stage = "cycle"

    local n2 = 0.06
    local v47

    for i = 1, 16 do
        if i == 16 then
            v47 = p24.fishId
        else
            local Rng = self.Rng
            local v48 = v44[Rng:NextInteger(1, #v44)]

            v47 = if v48 ~= v47 or not (#v44 > 1) then v48 else randomOther(Rng, v44, v47)
        end

        v40:ClearAllChildren()

        local v49 = FishIcons.Picture(v40, v47, 1, 1.15)

        if v49:IsA("ImageLabel") or v49:IsA("ViewportFrame") then
            v49.ImageColor3 = v3
        end

        UIKit.pop(v40, 1.08)
        UIKit.sound("LuckTick", i * 0.05 + 0.8)
        task.wait(n2)
        n2 *= 1.13
    end

    task.wait(0.25)
    self.Stage = "reveal"

    local v50 = UIKit.frame(self.Gui, {
        Name = "Flash",
        Transparency = 0,
        ZIndex = 30,
        Color = v2
    })

    v50.Size = UDim2.fromScale(1, 1)
    UIKit.tween(v50, 0.5, {
        BackgroundTransparency = 1
    })
    v41.Visible = false

    local fishId = p24.fishId

    v40:ClearAllChildren()
    FishIcons.Picture(v40, fishId, 1, 1.15)
    UIKit.pop(v40, 1.5)
    v38.ImageColor3 = v33.Color:Lerp(v2, 0.35)
    v38.ImageTransparency = 0.2
    v39.ImageColor3 = v33.Color:Lerp(v2, 0.5)
    v39.ImageTransparency = 0.15
    n1 = 55
    UIKit.sound(v33.order >= 8 and "RevealRare" or "RevealGood")

    local Rng2 = self.Rng

    for i = 1, 16 do
        local v51 = i / 16 * 3.141592653589793 * 2 + Rng2:NextNumber(-0.2, 0.2)
        local v52 = Rng2:NextInteger(26, 46)
        local v53 = UIKit.image(v36, "Sparkle", {
            ZIndex = 14,
            Size = UDim2.fromOffset(v52, v52),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v1,
            Color = if i % 2 == 0 then v33.Color:Lerp(v2, 0.4) else v2
        })
        local v54 = Rng2:NextInteger(200, 320)

        UIKit.tween(v53, 0.9, {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, math.cos(v51) * v54, 0.5, math.sin(v51) * v54),
            Size = UDim2.fromOffset(8, 8),
            Rotation = Rng2:NextInteger(-200, 200)
        }, Enum.EasingStyle.Quart).Completed:Once(function() -- line: 253
            -- upvalues: v53 (copy)
            v53:Destroy()
        end)
    end

    local v55 = UIKit.frame(self.Gui, {
        Name = "Labels",
        Transparency = 1,
        ZIndex = 20,
        Size = UDim2.new(1, 0, 0, 310)
    })
    local v56 = self:Label(v55, "FishName", v32.name, 86, 84, v2, fromRGB(230, 236, 255), fromRGB(20, 22, 40))
    local v57 = self:Label(v55, "Rarity", string.upper(v32.rarity), 52, 184, v33.Color:Lerp(v2, 0.2), v33.Color2, fromRGB(20, 22, 40))
    local v58 = p24.income or Roll.income(p24.fishId, p24.variant or 1, p24.size or 1, nil, p24.base)

    for v59, v60 in {
            v56,
            v57,
            (self:Label(v55, "Rate", NumberFormat.rate(v58), 48, 248, Colors.Cash, Colors.Cash, Colors.CashStroke))
        } do
        task.delay((v59 - 1) * 0.16, function() -- line: 263
            -- upvalues: v60 (copy), UIKit (copy)
            v60.Visible = true
            UIKit.pop(v60, 1.5)
        end)
    end

    local v61 = UIKit.text(self.Gui, {
        Name = "Hint",
        Text = "Tap to continue",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 20,
        Size = UDim2.fromOffset(600, 40),
        Position = UDim2.new(0.5, 0, 1, -60),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(220, 226, 245)
    })

    v61.Visible = false
    task.delay(0.9, function() -- line: 270
        -- upvalues: v61 (copy)
        v61.Visible = true
    end)

    local v62 = false
    local elapsed2 = os.clock()

    local function close() -- line: 275
        -- upvalues: self (copy), p24 (copy), v35 (copy), v37 (copy), connection (copy), v55 (copy), v61 (copy), v62 (ref), elapsed2 (ref), UIKit (copy)
        if v62 or os.clock() - elapsed2 < 0.8 then
            return
        end

        v62 = true
        self.Stage = "closing"
        UIKit.tween(v37, 0.25, {
            Scale = 0
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        UIKit.tween(v35, 0.25, {
            BackgroundTransparency = 1
        })
        v55.Visible = false
        v61.Visible = false
        task.wait(0.27)
        connection:Disconnect()
        self:Clear()
        self.Gui.Enabled = false
        self.Playing = false
        self.Stage = "idle"

        if self.Hold then
            local Hold = self.Hold
            local ok, result = pcall(Hold, p24)

            if not ok then
                warn("[RandomFishOffer] " .. tostring(result))
            end
        end
    end

    self.Close = close

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Catcher"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 40
    TextButton.Parent = self.Gui
    TextButton.Activated:Connect(function() -- line: 306
        -- upvalues: close (copy)
        task.spawn(close)
    end)
    task.delay(4, function() -- line: 309
        -- upvalues: elapsed2 (ref), close (copy)
        elapsed2 = 0
        close()
    end)
end

local t8 = {}

t8.__index = t8

function t8.new() -- line: 318
    -- upvalues: Products (copy), t8 (copy)
    local self = setmetatable({}, t8)

    self.Rng = Random.new()
    self.Current = nil
    self.Prompts = 0
    self.Product = Products.RandomFish

    return self
end

function t8:Buy() -- line: 327
    -- upvalues: MarketplaceService (copy), Toasts (copy), LocalPlayer (copy)
    local Product = self.Product

    self.Prompts += 1

    if not Product or Product.id == 0 then
        Toasts.Show("info", "Not on sale yet!")
    else
        local function v64() -- line: 334
            -- upvalues: Product (copy), MarketplaceService (copy), LocalPlayer (copy)
            MarketplaceService:PromptProductPurchase(LocalPlayer, Product.id)
        end

        pcall(v64)
    end
end

function t8:Build() -- line: 339
    -- upvalues: MarketplaceService (copy), UIKit (copy), HUD (copy), Colors (copy), fromRGB (copy), v1 (copy), v4 (copy)
    if HUD.Right and HUD.Left then
        local Frame = Instance.new("Frame")

        Frame.Name = "RandomFishDrawer"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromOffset(180, 170)
        Frame.AnchorPoint = Vector2.new(0.5, 1)
        Frame.ZIndex = 2
        self.Drawer = Frame

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "RandomFish"
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BackgroundTransparency = 1
        TextButton.Size = UDim2.fromOffset(180, 170)
        TextButton.ZIndex = 2
        TextButton.Parent = Frame

        local v65 = UIKit.image(TextButton, "Rays", {
            Transparency = 0.2,
            ZIndex = 2,
            Size = UDim2.fromOffset(234, 234),
            Position = UDim2.fromOffset(90, 88),
            AnchorPoint = v1,
            Color = fromRGB(255, 238, 160)
        })
        local v66 = UIKit.frame(TextButton, {
            Name = "Silhouette",
            Transparency = 1,
            ZIndex = 3,
            Size = UDim2.fromOffset(160, 100),
            Position = UDim2.fromOffset(90, 88),
            AnchorPoint = v1
        })
        local v67 = UIKit.text(TextButton, {
            Name = "Label",
            Text = "RANDOM FISH",
            TextSize = 30,
            Stroke = 4,
            ZIndex = 7,
            Size = UDim2.fromOffset(180, 34),
            Position = UDim2.fromOffset(90, 16),
            AnchorPoint = v1
        })

        v67.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 30
        UITextSizeConstraint.Parent = v67
        UIKit.gradient(v67, fromRGB(255, 246, 150), fromRGB(255, 180, 50))

        local v68 = UIKit.button(TextButton, {
            Name = "Info",
            Text = "i",
            Corner = 15,
            Stroke = 3,
            TextStroke = 3,
            ZIndex = 9,
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.fromOffset(166, 50),
            AnchorPoint = v1,
            Color = Colors.Blue,
            Color2 = Colors.BlueDark,
            OnClick = function() -- OnClick | line: 366
                -- upvalues: self (copy)
                self.Odds:Open()
            end
        })
        local v70 = UIKit.text(TextButton, {
            Name = "Price",
            TextSize = 32,
            Stroke = 4,
            ZIndex = 7,
            Text = v4 .. " " .. tostring(self.Product and self.Product.robux or ""),
            Size = UDim2.fromOffset(180, 36),
            Position = UDim2.fromOffset(90, 154),
            AnchorPoint = v1,
            Color = fromRGB(150, 250, 70)
        })

        if self.Product and self.Product.id ~= 0 then
            task.spawn(function() -- line: 371
                -- upvalues: self (copy), v70 (copy), MarketplaceService (copy), v4 (copy)
                local function v71() -- line: 372
                    -- upvalues: self (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(self.Product.id, Enum.InfoType.Product)
                end

                local ok, result = pcall(v71)

                if ok and result and type(result.PriceInRobux) == "number" then
                    v70.Text = v4 .. " " .. result.PriceInRobux
                end
            end)
        end

        local v72 = UIKit.scaleOf(TextButton)

        TextButton.MouseEnter:Connect(function() -- line: 381
            -- upvalues: v72 (copy), UIKit (copy)
            UIKit.tween(v72, 0.16, {
                Scale = 1.08
            }, Enum.EasingStyle.Back)
        end)
        TextButton.MouseLeave:Connect(function() -- line: 384
            -- upvalues: v72 (copy), UIKit (copy)
            UIKit.tween(v72, 0.2, {
                Scale = 1
            })
        end)
        TextButton.Activated:Connect(function() -- line: 387
            -- upvalues: self (copy), v72 (copy), UIKit (copy)
            v72.Scale = 1.14
            UIKit.tween(v72, 0.3, {
                Scale = 1
            }, Enum.EasingStyle.Back)
            UIKit.sound("Click")
            self:Buy()
        end)
        self.Card = TextButton
        self.Holder = v66
        self.Rays = v65
        self.InfoButton = v68
    end
end

function t8:Cycle() -- line: 396
    -- upvalues: UIKit (copy), FishIcons (copy), v3 (copy), picturedFish (copy), randomOther (copy)
    local v73 = picturedFish()
    local Rng, Current = self.Rng, self.Current
    local v74 = v73[Rng:NextInteger(1, #v73)]

    self.Current = if v74 == Current and #v73 > 1 then randomOther(Rng, v73, Current) else v74
    self.Holder:ClearAllChildren()

    local Holder, Current2 = self.Holder, self.Current
    local v75 = FishIcons.Picture(Holder, Current2, 1, 1.1)

    if v75:IsA("ImageLabel") or v75:IsA("ViewportFrame") then
        v75.ImageColor3 = v3
    end

    UIKit.pop(self.Holder, 1.1)
end

function t8:Place() -- line: 404
    -- upvalues: HUD (copy)
    local Drawer = self.Drawer

    if not Drawer then
        return
    end

    local v76 = HUD.IsTouch()
    local v77 = if v76 then HUD.Right else HUD.Left

    if Drawer.Parent ~= v77 then
        Drawer.Parent = v77
    end

    local v78 = if v76 then Vector2.new(1, 0) else Vector2.new(0, 1)

    if Drawer.AnchorPoint ~= v78 then
        Drawer.AnchorPoint = v78
    end

    local v79 = if v76 then UDim2.new(1, 0, 1, 14) else UDim2.new(0, 0, 0, -14)

    if Drawer.Position ~= v79 then
        Drawer.Position = v79
    end
end

function t8:TopRoom() -- line: 424
    -- upvalues: HUD (copy), LocalPlayer (copy)
    if self.Drawer and self.Card and not HUD.IsTouch() and LocalPlayer:GetAttribute("CratesAllowed") ~= false then
        return 184
    end

    return 0
end

function t8:RefreshVisible() -- line: 431
    -- upvalues: LocalPlayer (copy)
    if self.Card then
        local v80 = LocalPlayer:GetAttribute("CratesAllowed") == true

        self.Card.Visible = v80
    end
end

function t8:Start(p35) -- line: 438
    -- upvalues: RunService (copy), Remotes (copy), HUD (copy), LocalPlayer (copy), t1 (copy), t4 (copy)
    self.Odds = t1.new()
    self.Reveal = t4.new()
    self.Reveal.Hold = p35
    self:Build()

    if self.Card then
        self:Cycle()
        self:RefreshVisible()
        LocalPlayer:GetAttributeChangedSignal("CratesAllowed"):Connect(function() -- line: 448
            -- upvalues: self (copy)
            self:RefreshVisible()
        end)

        local elapsed = os.clock()
        local n3 = 0

        self:Place()

        HUD.LeftTopExtra = function() -- line: 454
            -- upvalues: self (copy)
            return self:TopRoom()
        end

        HUD.TouchChanged:Connect(function() -- line: 457
            -- upvalues: self (copy)
            self:Place()
        end)
        task.spawn(function() -- line: 460
            -- upvalues: self (copy)
            while self.Drawer and self.Drawer.Parent do
                self:Place()
                task.wait(0.5)
            end
        end)
        RunService.RenderStepped:Connect(function() -- line: 466
            -- upvalues: self (copy), elapsed (copy), n3 (ref), HUD (copy)
            if not self.Card.Visible or HUD.GetMode() == "cutscene" then
                return
            end

            local v81 = os.clock() - elapsed

            self.Rays.Rotation = v81 * 35

            if n3 <= v81 then
                n3 = v81 + 0.75
                self:Cycle()
            end
        end)
        Remotes:WaitForChild("RandomFish").OnClientEvent:Connect(function(p36) -- line: 478
            -- upvalues: self (copy), HUD (copy)
            local v82 = type(p36) == "table"
            local v83 = if v82 then type(p36.fishId) == "string" else nil

            if v82 and v83 then
                task.spawn(function() -- line: 482
                    -- upvalues: p36 (copy), self (copy), HUD (copy)
                    local v84 = os.clock() + 10

                    while HUD.GetMode() == "cutscene" and os.clock() < v84 do
                        task.wait(0.2)
                    end

                    self.Odds:Close()
                    self.Reveal:Play(p36, self.Card)
                end)
            end
        end)
    end

    return self
end

t8.Shared = t8.new()

return t8

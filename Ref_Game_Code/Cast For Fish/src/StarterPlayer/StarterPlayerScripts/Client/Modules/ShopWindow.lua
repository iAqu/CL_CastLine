-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Products = require(Shared.Data.Products)
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local Toasts = require(script.Parent.Toasts)
local PackCards = require(script.Parent.PackCards)
local VipCard = require(script.Parent.VipCard)
local FishIcons = require(script.Parent.FishIcons)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right
local v1 = utf8.char(57346)
local v2 = Vector2.new(0.5, 0.5)
local v3, v4
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local v5 = Color3.new(1, 1, 1)
local Shop, ScrollingFrame
local t6 = {}

local function addMover(p1, p2) -- line: 56
    -- upvalues: t6 (copy)
    table.insert(t6, {
        seen = false,
        gui = p1,
        step = p2
    })
end

local function onScreen(p3, p4, p5) -- line: 61
    -- upvalues: ScrollingFrame (ref)
    if not p3.Parent then
        return false
    end

    local v6 = p3

    while v6 and v6 ~= ScrollingFrame and v6:IsA("GuiObject") do
        if not v6.Visible then
            return false
        end

        v6 = v6.Parent
    end

    if v6 ~= ScrollingFrame then
        return true
    end

    local Y = p3.AbsolutePosition.Y

    if Y + p3.AbsoluteSize.Y >= p4 - 60 then
        return Y <= p5 + 60
    end

    return false
end

local function gleam(p6, p7) -- line: 80
    -- upvalues: UIKit (copy), t6 (copy)
    p7 = p7 or {}
    p7.Manual = true

    local _, v8 = UIKit.gleam(p6, p7)

    table.insert(t6, {
        seen = false,
        gui = p6,
        step = v8
    })
end

local function glowBehind(p8, p9, p10) -- line: 88
    -- upvalues: UIKit (copy), fromRGB (copy), v2 (copy), t6 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p8.Name .. "Glow"
    Frame.BackgroundTransparency = 1
    Frame.Size = p8.Size
    Frame.Position = p8.Position
    Frame.AnchorPoint = p8.AnchorPoint
    Frame.ZIndex = math.max(1, p8.ZIndex - 1)
    Frame.Parent = p8.Parent

    local v10 = p10 or 1
    local v11 = UIKit.image(Frame, "Glow", {
        Transparency = 0.5,
        Size = UDim2.fromScale(1.5 * v10, 2.4 * v10),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v2,
        Color = p9 or fromRGB(255, 250, 170),
        ZIndex = Frame.ZIndex
    })

    v11.ScaleType = Enum.ScaleType.Stretch

    local v12 = math.random() * 6

    table.insert(t6, {
        seen = false,
        gui = p8,
        step = function(p11) -- line: 101
            -- upvalues: v10 (copy), v11 (copy), v12 (copy)
            local v14 = math.sin(p11 * 2.6 + v12) * 0.5 + 0.5

            v11.ImageTransparency = 0.72 - v14 * 0.42
            v11.Size = UDim2.fromScale((v14 * 0.18 + 1.38) * v10, (v14 * 0.45 + 2.1) * v10)
        end
    })

    return v11
end

local function bob(p12, p13, p14, p15) -- line: 110
    -- upvalues: t6 (copy)
    local Position = p12.Position
    local v15 = p13 or 5
    local v16 = p14 or 1.8
    local v17 = p15 or math.random() * 6

    table.insert(t6, {
        seen = false,
        gui = p12,
        step = function(p16) -- line: 113
            -- upvalues: p12 (copy), Position (copy), v15 (copy), v16 (copy), v17 (copy)
            p12.Position = Position + UDim2.fromOffset(0, math.sin(p16 * v16 + v17) * v15)
        end
    })
end

local function sway(p17, p18, p19, p20) -- line: 119
    -- upvalues: t6 (copy)
    local Rotation = p17.Rotation
    local v20 = p18 or 4
    local v21 = p19 or 1.6
    local v22 = p20 or math.random() * 6

    table.insert(t6, {
        seen = false,
        gui = p17,
        step = function(p21) -- line: 122
            -- upvalues: p17 (copy), Rotation (copy), v20 (copy), v21 (copy), v22 (copy)
            p17.Rotation = Rotation + math.sin(p21 * v21 + v22) * v20
        end
    })
end

local function breathe(p22, p23, p24) -- line: 128
    -- upvalues: UIKit (copy), t6 (copy)
    local v25 = UIKit.scaleOf(p22)
    local v26 = p23 or 0.05
    local v27 = p24 or 2.4
    local v28 = math.random() * 6

    table.insert(t6, {
        seen = false,
        gui = p22,
        step = function(p25) -- line: 131
            -- upvalues: v25 (copy), v26 (copy), v27 (copy), v28 (copy)
            v25.Scale = 1 + v26 * (math.sin(p25 * v27 + v28) * 0.5 + 0.5)
        end
    })
end

local function heartbeat(p26) -- line: 137
    -- upvalues: UIKit (copy), t6 (copy)
    local v30 = UIKit.scaleOf(p26)
    local v31 = math.random()

    table.insert(t6, {
        seen = false,
        gui = p26,
        step = function(p27) -- line: 140
            -- upvalues: v30 (copy), v31 (copy)
            local v32 = (p27 * 0.9 + v31) % 1

            v30.Scale = math.exp(-((v32 - 0.1) / 0.045) ^ 2) * 0.14 + 1 + math.exp(-((v32 - 0.27) / 0.045) ^ 2) * 0.09
        end
    })
end

local v36 = UserInputService.MouseEnabled and not UserInputService.TouchEnabled

local function hoverLift(p28, p29) -- line: 148
    -- upvalues: UIKit (copy), v36 (copy)
    if not v36 then
        return
    end

    local v37 = UIKit.scaleOf(p28)

    p28.MouseEnter:Connect(function() -- line: 153
        -- upvalues: p29 (copy), v37 (copy), UIKit (copy)
        UIKit.tween(v37, 0.16, {
            Scale = p29 or 1.03
        })
    end)
    p28.MouseLeave:Connect(function() -- line: 156
        -- upvalues: v37 (copy), UIKit (copy)
        UIKit.tween(v37, 0.22, {
            Scale = 1
        })
    end)
end

local function burst(p30) -- line: 162
    -- upvalues: UIKit (copy), fromRGB (copy), v2 (copy), v5 (copy)
    local v38 = Random.new()

    for i = 1, 10 do
        local v39 = i / 10 * 3.141592653589793 * 2 + v38:NextNumber(-0.3, 0.3)
        local v40 = v38:NextInteger(18, 30)
        local v41 = UIKit.image(p30, "Sparkle", {
            Size = UDim2.fromOffset(v40, v40),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v2,
            ZIndex = p30.ZIndex + 6,
            Color = if i % 2 == 0 then fromRGB(255, 240, 150) else v5
        })
        local v42 = v38:NextInteger(80, 140)

        UIKit.tween(v41, 0.55, {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, math.cos(v39) * v42, 0.5, math.sin(v39) * v42 * 0.6),
            Size = UDim2.fromOffset(6, 6),
            Rotation = v38:NextInteger(-180, 180)
        }).Completed:Once(function() -- line: 170
            -- upvalues: v41 (copy)
            v41:Destroy()
        end)
    end
end

local function closePanel(p31) -- line: 177
    -- upvalues: UIKit (copy)
    if p31:GetAttribute("Closing") then
        return
    end

    p31:SetAttribute("Closing", true)
    UIKit.tween(UIKit.scaleOf(p31), 0.14, {
        Scale = 0.7
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Once(function() -- line: 183
        -- upvalues: p31 (copy)
        p31:Destroy()
    end)
end

local t16 = {}
local t17 = {}

local function wrapSections(p32) -- line: 193
    -- upvalues: v2 (copy), t16 (copy)
    local t18 = {}

    for _, child in ipairs(p32:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(t18, child)
        end
    end

    table.sort(t18, function(p33, p34) -- line: 200
        return p33.LayoutOrder < p34.LayoutOrder
    end)

    for _, v43 in ipairs(t18) do
        local Frame = Instance.new("Frame")

        Frame.Name = v43.Name .. "Slot"
        Frame.BackgroundTransparency = 1
        Frame.Size = v43.Size
        Frame.LayoutOrder = v43.LayoutOrder
        Frame.Visible = v43.Visible
        Frame.ZIndex = v43.ZIndex
        Frame.Parent = p32
        v43.AnchorPoint = v2
        v43.Position = UDim2.fromScale(0.5, 0.5)
        v43.Parent = Frame
        v43:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 215
            -- upvalues: Frame (copy), v43 (copy)
            Frame.Visible = v43.Visible
        end)
        v43:GetPropertyChangedSignal("Size"):Connect(function() -- line: 218
            -- upvalues: Frame (copy), v43 (copy)
            Frame.Size = v43.Size
        end)
        table.insert(t16, {
            holder = Frame,
            section = v43
        })
    end
end

local function resetEntrances() -- line: 224
    -- upvalues: UIKit (copy), t16 (copy), t17 (copy)
    table.clear(t17)

    for _, v44 in ipairs(t16) do
        UIKit.scaleOf(v44.section).Scale = 0.88
    end
end

local function revealStep() -- line: 230
    -- upvalues: UIKit (copy), TweenService (copy), ScrollingFrame (ref), t16 (copy), t17 (copy)
    local Y = ScrollingFrame.AbsolutePosition.Y
    local v45 = Y + ScrollingFrame.AbsoluteSize.Y
    local n1 = 0

    for _, v46 in ipairs(t16) do
        local holder = v46.holder

        if holder.Visible and not t17[holder] then
            local Y2 = holder.AbsolutePosition.Y

            if Y2 <= v45 - 10 and Y <= Y2 + holder.AbsoluteSize.Y then
                t17[holder] = true
                TweenService:Create(UIKit.scaleOf(v46.section), TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, n1 * 0.06), {
                    Scale = 1
                }):Play()
                n1 += 1
            elseif v45 < Y2 then
                break
            end
        end
    end
end

local function startMotion() -- line: 249
    -- upvalues: RunService (copy), Shop (ref), ScrollingFrame (ref), t6 (copy), onScreen (copy), revealStep (copy)
    local n2 = 0

    RunService.RenderStepped:Connect(function() -- line: 251
        -- upvalues: n2 (ref), Shop (ref), ScrollingFrame (ref), t6 (copy), onScreen (copy), revealStep (copy)
        if Shop and Shop.IsOpen and ScrollingFrame then
            local elapsed = os.clock()

            if n2 <= elapsed then
                n2 = elapsed + 0.2

                local Y = ScrollingFrame.AbsolutePosition.Y
                local v47 = Y + ScrollingFrame.AbsoluteSize.Y

                for _, v48 in ipairs(t6) do
                    v48.seen = onScreen(v48.gui, Y, v47)
                end
            end

            for _, v49 in ipairs(t6) do
                if v49.seen then
                    v49.step(elapsed)
                end
            end

            revealStep()
        end
    end)
end

local function shopArt(p35) -- line: 273
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Shop = Assets and Assets:FindFirstChild("Shop")

    return Shop and Shop:FindFirstChild(p35)
end

local function bestIncome(_) -- line: 281
    -- upvalues: Products (copy), DataClient (copy)
    return Products.SpiritBest({
        DataClient.Get("Backpack") or {},
        DataClient.Get("Placed") or {},
        DataClient.Get("Aquarium") or {}
    })
end

local t21 = {}

t21[1] = nil

local v53

local function buy(p37, p38) -- line: 289
    -- upvalues: MarketplaceService (copy), Remotes (copy), Toasts (copy), LocalPlayer (copy), t21 (copy), v53 (ref)
    if t21[1] and v53 then
        v53(p37, p38)

        return
    end

    if not p37.id or p37.id == 0 then
        Toasts.Show("info", "Not on sale yet!")
    else
        local ShopFunnel = Remotes:FindFirstChild("ShopFunnel")

        if ShopFunnel then
            ShopFunnel:FireServer("prompt", p37.id)
        end

        local function v56() -- line: 302
            -- upvalues: p37 (copy), p38 (copy), MarketplaceService (copy), LocalPlayer (copy)
            if p38 then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, p37.id)
            else
                MarketplaceService:PromptProductPurchase(LocalPlayer, p37.id)
            end
        end

        pcall(v56)
    end
end

local function robuxButton(p39, p40, p41, p42, p43, p44) -- line: 311
    -- upvalues: MarketplaceService (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy), t6 (copy), burst (copy), buy (copy)
    local v57
    local v58, v59 = UIKit.button(p39, {
        Name = "Buy",
        Corner = 12,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 20,
        Text = v1 .. " " .. p40.robux,
        Size = p41,
        Position = p42,
        AnchorPoint = p43,
        Color = fromRGB(150, 250, 70),
        Color2 = fromRGB(40, 190, 30),
        OnClick = function() -- OnClick | line: 313
            -- upvalues: p40 (copy), p44 (copy), v57 (ref), burst (copy), buy (copy)
            if v57.Active then
                burst(v57)
            end

            buy(p40, p44)
        end
    })

    v57 = v58
    UIKit.frame(v57, {
        Name = "Shine",
        Transparency = 0.6,
        Corner = 3,
        ZIndex = 21,
        Size = UDim2.new(1, -16, 0, 6),
        Position = UDim2.fromOffset(8, 5),
        Color = Colors.White
    })

    local v60 = {
        Corner = 12,
        ZIndex = 20,
        Strength = 0.8,
        Width = 0.12,
        Period = 2.6 + math.random() * 1.4,
        When = function() -- When | line: 322
            -- upvalues: v57 (ref)
            return v57.Active
        end
    } or {}

    v60.Manual = true

    local _, v61 = UIKit.gleam(v57, v60)

    table.insert(t6, {
        seen = false,
        gui = v57,
        step = v61
    })

    if p40.id and p40.id ~= 0 then
        task.spawn(function() -- line: 328
            -- upvalues: p40 (copy), p44 (copy), v59 (copy), MarketplaceService (copy), v1 (copy)
            local function v62() -- line: 329
                -- upvalues: p40 (copy), p44 (copy), MarketplaceService (copy)
                return MarketplaceService:GetProductInfo(p40.id, if p44 then Enum.InfoType.GamePass else Enum.InfoType.Product)
            end

            local ok, result = pcall(v62)

            if ok and result and type(result.PriceInRobux) == "number" and v59.Text == v1 .. " " .. p40.robux then
                v59.Text = v1 .. " " .. result.PriceInRobux
            end
        end)
    end

    return v57, v59
end

local function fishName(p45, p46, p47) -- line: 340
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy)
    local v64 = Variants.List[p46] or Variants.List[1]
    local v65 = Sizes.List[p47] or Sizes.List[Sizes.NORMAL_INDEX]
    local v66 = if v64.index >= 2 then v64.id .. " " else ""

    if v65.index ~= Sizes.NORMAL_INDEX then
        v66 ..= v65.id .. " "
    end

    return v66 .. Fish.ById[p45].name
end

local n3 = 0

local function showOverlay(p48, p49, p50) -- line: 357
    -- upvalues: RunService (copy), Products (copy), Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), Roll (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), Colors (copy), fromRGB (copy), v2 (copy), v4 (ref), n3 (ref)
    n3 += 1

    local v67 = n3

    v4:ClearAllChildren()
    v4.Visible = true
    v4.BackgroundTransparency = 1
    UIKit.tween(v4, 0.2, {
        BackgroundTransparency = 0.35
    })

    local v68 = UIKit.image(v4, "Rays", {
        Transparency = 0.55,
        Size = UDim2.fromOffset(1500, 1500),
        Position = UDim2.fromScale(0.5, 0.46),
        AnchorPoint = v2,
        Color = fromRGB(255, 235, 140)
    })

    UIKit.image(v4, "Glow", {
        Transparency = 0.4,
        Size = UDim2.fromOffset(900, 900),
        Position = UDim2.fromScale(0.5, 0.46),
        AnchorPoint = v2,
        Color = fromRGB(255, 240, 180)
    })

    local v69 = p49[1]
    local v70 = Fish.ById[v69.fishId]
    local v71 = Rarities.ById[v70.rarity]
    local v72 = UIKit.frame(v4, {
        Name = "Card",
        Corner = 20,
        Stroke = 6,
        Size = UDim2.fromOffset(320, 360),
        Position = UDim2.fromScale(0.5, 0.46),
        AnchorPoint = v2,
        Color = v71.Color,
        Color2 = v71.Color2,
        StrokeColor = fromRGB(150, 255, 110)
    })
    local v73 = UIKit.frame(v72, {
        Name = "Picture",
        Transparency = 1,
        Size = UDim2.new(1, -24, 0, 210),
        Position = UDim2.fromOffset(12, 12)
    })

    FishIcons.Picture(v73, v69.fishId, v69.variant)

    local text = UIKit.text
    local t24 = {
        Name = "FishName",
        Stroke = 5,
        ZIndex = 3
    }
    local fishId, variant, size = v69.fishId, v69.variant, v69.size
    local v74 = Variants.List[variant] or Variants.List[1]
    local v75 = Sizes.List[size] or Sizes.List[Sizes.NORMAL_INDEX]
    local v76 = if v74.index >= 2 then v74.id .. " " else ""

    if v75.index ~= Sizes.NORMAL_INDEX then
        v76 ..= v75.id .. " "
    end

    t24.Text = v76 .. Fish.ById[fishId].name
    t24.Size = UDim2.new(1, -20, 0, 44)
    t24.Position = UDim2.fromOffset(10, 226)
    text(v72, t24)
    UIKit.text(v72, {
        Name = "Rate",
        TextSize = 36,
        Stroke = 5,
        ZIndex = 3,
        Text = NumberFormat.rate(Roll.income(v69.fishId, v69.variant, v69.size, nil, v69.base)),
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 272),
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })

    if v69.pct then
        UIKit.text(v72, {
            Name = "Percent",
            TextSize = 24,
            Stroke = 4,
            ZIndex = 3,
            Text = v69.pct .. "% of your best fish!",
            Size = UDim2.new(1, 0, 0, 28),
            Position = UDim2.fromOffset(0, 314),
            Color = Colors.Gold
        })
    elseif v69.like then
        local v77 = Products.LikeZone({
            like = v69.like
        })

        if v77 then
            UIKit.text(v72, {
                Name = "Like",
                TextSize = 24,
                Stroke = 4,
                ZIndex = 3,
                Text = "As good as a Zone " .. v77 .. " fish!",
                Size = UDim2.new(1, 0, 0, 28),
                Position = UDim2.fromOffset(0, 314),
                Color = Colors.Gold
            })
        end
    end

    UIKit.pop(v72, 0.4)

    local CutsceneFx = require(script.Parent.CutsceneFx)
    local v78 = math.max(2, CutsceneFx.Thrill(v69.fishId, v69.variant, v69.size))

    CutsceneFx.Sting(v78)
    CutsceneFx.Grade(v71.Color, v78 * 0.1 + 0.5, 0.3)
    CutsceneFx.Haptic(v78 + 1)
    CutsceneFx.Shake(1, 0.4)
    task.delay(3.5, CutsceneFx.GradeOff, 0.6)

    local v79 = require(game:GetService("ReplicatedStorage").Shared.Data.Variants).List[v69.variant or 1]

    if v79 then
        CutsceneFx.Mutation(v79.id)
    end

    if #p49 > 1 then
        UIKit.text(v4, {
            Name = "More",
            TextSize = 36,
            Stroke = 5,
            Text = "+ " .. #p49 - 1 .. " more in your backpack!",
            Size = UDim2.fromOffset(900, 44),
            Position = UDim2.new(0.5, 0, 0.46, 200),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = Colors.Gold
        })
    end

    local v80 = UIKit.text(v4, {
        Name = "Title",
        TextSize = 100,
        Stroke = 9,
        Text = p48,
        Size = UDim2.fromOffset(1400, 110),
        Position = UDim2.new(0.5, 0, 0.46, -310),
        AnchorPoint = Vector2.new(0.5, 0),
        StrokeColor = fromRGB(110, 60, 0)
    })

    UIKit.gradient(v80, fromRGB(255, 245, 130), fromRGB(255, 170, 30))
    UIKit.pop(v80, 1.6)

    local text2 = UIKit.text
    local v81 = v4

    text2(v81, {
        Name = "Hint",
        TextSize = 38,
        Stroke = 5,
        Text = p50,
        Size = UDim2.fromOffset(1500, 46),
        Position = UDim2.new(0.5, 0, 0.46, #p49 > 1 and 250 or 206),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    local t26 = {
        fromRGB(255, 90, 90),
        fromRGB(90, 200, 255),
        fromRGB(255, 220, 70),
        fromRGB(130, 240, 90),
        fromRGB(240, 110, 230),
        fromRGB(255, 255, 255)
    }
    local v82 = Random.new()

    for i = 1, 46 do
        local v83 = if i % 2 == 0 then 0.12 else 0.88
        local v84 = UIKit.frame(v4, {
            Name = "Confetti",
            Size = UDim2.fromOffset(v82:NextInteger(10, 18), v82:NextInteger(8, 14)),
            Position = UDim2.new(v83, v82:NextInteger(-60, 60), 0.72, v82:NextInteger(-40, 40)),
            Color = t26[v82:NextInteger(1, #t26)]
        })

        v84.Rotation = v82:NextInteger(0, 360)

        local v85 = (if v83 < 0.5 then 1 else -1) * v82:NextInteger(-80, 380)

        UIKit.tween(v84, 0.45, {
            Position = v84.Position + UDim2.fromOffset(v85 * 0.5, -v82:NextInteger(260, 560)),
            Rotation = v84.Rotation + v82:NextInteger(-200, 200)
        }).Completed:Once(function() -- line: 416
            -- upvalues: v82 (copy), v84 (copy), v85 (copy), UIKit (copy)
            if v84.Parent then
                UIKit.tween(v84, v82:NextNumber(0.9, 1.6), {
                    BackgroundTransparency = 1,
                    Position = v84.Position + UDim2.fromOffset(v85 * 0.5, v82:NextInteger(500, 900)),
                    Rotation = v84.Rotation + v82:NextInteger(-300, 300)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            end
        end)
    end

    UIKit.sound("RevealGood")

    local elapsed = os.clock()

    local function close() -- line: 425
        -- upvalues: v67 (copy), elapsed (ref), v4 (ref), n3 (ref)
        if v67 ~= n3 or not v4.Visible or not (os.clock() - elapsed > 0.7) then
            return
        end

        n3 += 1
        v4.Visible = false
        v4:ClearAllChildren()
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 20
    TextButton.Parent = v4
    TextButton.Activated:Connect(close)
    task.spawn(function() -- line: 440
        -- upvalues: v67 (copy), v68 (copy), elapsed (ref), RunService (copy), v4 (ref), n3 (ref)
        while v67 == n3 and v4.Visible do
            v68.Rotation = (os.clock() - elapsed) * 20

            if os.clock() - elapsed > 6 then
                elapsed = 0

                if v67 == n3 and v4.Visible and os.clock() - elapsed > 0.7 then
                    n3 += 1
                    v4.Visible = false
                    v4:ClearAllChildren()
                end
            end

            RunService.RenderStepped:Wait()
        end
    end)
end

t1.ShowOverlay = showOverlay

local n4 = 0

local function nextOrder() -- line: 455
    -- upvalues: n4 (ref)
    n4 += 1

    return n4
end

local function divider(p51, p52) -- line: 460
    -- upvalues: UIKit (copy), Colors (copy), fromRGB (copy), v2 (copy), t6 (copy), n4 (ref)
    local v86 = UIKit.frame(p51, {
        Transparency = 1,
        ZIndex = 12,
        Name = p52 .. "Divider",
        Size = UDim2.fromOffset(1026, 60)
    })

    n4 += 1
    v86.LayoutOrder = n4
    UIKit.frame(v86, {
        Name = "Line",
        Corner = 2,
        ZIndex = 12,
        Size = UDim2.new(1, -40, 0, 4),
        Position = UDim2.new(0, 20, 0.5, -2),
        Color = Colors.PanelLight
    })

    local v87 = UIKit.frame(v86, {
        Name = "Pill",
        Corner = 26,
        Stroke = 5,
        ZIndex = 13,
        Size = UDim2.fromOffset(340, 52),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v2,
        Color = fromRGB(52, 60, 92),
        Color2 = fromRGB(34, 38, 62)
    })

    UIKit.text(v87, {
        Name = "Label",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 14,
        Text = p52
    })

    local v88 = {
        Corner = 26,
        ZIndex = 13,
        Period = 4.6,
        Sweep = 0.9,
        Strength = 0.4,
        Width = 0.12
    } or {}

    v88.Manual = true

    local _, v89 = UIKit.gleam(v87, v88)

    table.insert(t6, {
        seen = false,
        gui = v87,
        step = v89
    })
    UIKit.sparkle(v86, 22, {
        ZIndex = 14,
        Phase = 0,
        Position = UDim2.new(0.5, -186, 0.5, -4),
        Color = fromRGB(255, 240, 150)
    })
    UIKit.sparkle(v86, 18, {
        ZIndex = 14,
        Phase = 2.4,
        Position = UDim2.new(0.5, 186, 0.5, 4)
    })

    return v86
end

local function ribbon(p53, p54) -- line: 473
    -- upvalues: UIKit (copy), fromRGB (copy), t6 (copy)
    if not p54 then
        return
    end

    local t28 = {
        ["Good Value"] = {
            fromRGB(70, 170, 255),
            fromRGB(40, 110, 235)
        },
        ["Better Value"] = {
            fromRGB(255, 110, 190),
            fromRGB(225, 60, 150)
        },
        ["Great Value"] = {
            fromRGB(255, 180, 50),
            fromRGB(240, 120, 20)
        },
        ["Most Value"] = {
            fromRGB(255, 90, 200),
            fromRGB(170, 60, 240)
        }
    }
    local v90 = t28[p54] or t28["Good Value"]
    local v91 = UIKit.frame(p53, {
        Name = "Ribbon",
        Corner = 12,
        Stroke = 4,
        ZIndex = 25,
        Size = UDim2.new(1, -24, 0, 36),
        Position = UDim2.new(0.5, 0, 0, -10),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = v90[1],
        Color2 = v90[2]
    })

    UIKit.text(v91, {
        Name = "Label",
        TextSize = 25,
        Stroke = 3,
        ZIndex = 26,
        Text = p54
    })

    local v92 = p54 == "Most Value" or p54 == "Great Value"
    local v94 = if v92 then 3 else 1.6
    local v93 = if v92 then 3.2 else 2.2
    local Rotation = v91.Rotation
    local v95 = v94 or 4
    local v96 = v93 or 1.6
    local v97 = math.random() * 6

    table.insert(t6, {
        seen = false,
        gui = v91,
        step = function(p55) -- line: 122
            -- upvalues: v91 (copy), Rotation (copy), v95 (copy), v96 (copy), v97 (copy)
            v91.Rotation = Rotation + math.sin(p55 * v96 + v97) * v95
        end
    })

    local v100 = if v92 then 0.06 else 0.03
    local v101 = UIKit.scaleOf(v91)
    local v102 = v100 or 0.05
    local v103 = math.random() * 6
    local n5 = 3

    table.insert(t6, {
        seen = false,
        gui = v91,
        step = function(p56) -- line: 131
            -- upvalues: v101 (copy), v102 (copy), v103 (copy), n5 (copy)
            v101.Scale = 1 + v102 * (math.sin(p56 * n5 + v103) * 0.5 + 0.5)
        end
    })

    local v106 = {
        Corner = 12,
        ZIndex = 25,
        Strength = 0.55,
        Period = v92 and 2.4 or 3.6
    } or {}

    v106.Manual = true

    local _, v107 = UIKit.gleam(v91, v106)

    table.insert(t6, {
        seen = false,
        gui = v91,
        step = v107
    })

    return v91
end

local function sparkleBack(p57, p58, p59, p60, p61, p62) -- line: 491
    -- upvalues: UIKit (copy), Colors (copy), v2 (copy)
    local v108 = UIKit.backdrop(p57, p58, 12)

    UIKit.rays(v108, {
        Transparency = 0.72,
        ZIndex = 12,
        Speed = 10,
        Size = UDim2.fromOffset(p60, p60),
        Position = UDim2.fromOffset(p59.X, p59.Y),
        AnchorPoint = v2,
        Color = p61
    })
    UIKit.image(v108, "Glow", {
        Transparency = 0.45,
        ZIndex = 12,
        Size = UDim2.fromOffset(p60 * 0.62, p60 * 0.62),
        Position = UDim2.fromOffset(p59.X, p59.Y),
        AnchorPoint = v2,
        Color = p61
    })

    for v109, v110 in ipairs(p62 or {}) do
        UIKit.sparkle(v108, v110[3], {
            ZIndex = 13,
            Position = UDim2.fromOffset(v110[1], v110[2]),
            Color = v110[4] or Colors.White,
            Phase = v109 * 1.7
        })
    end

    return v108
end

local function oddsPanel(p63, p64) -- line: 501
    -- upvalues: Products (copy), Fish (copy), Rarities (copy), Variants (copy), Sizes (copy), Roll (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), Colors (copy), Left (copy), Right (copy), v2 (copy), closePanel (copy), bestIncome (copy)
    local Odds = p63.Frame:FindFirstChild("Odds")

    if Odds then
        Odds:Destroy()
    end

    local v112 = if p64.percent then bestIncome(p64) else 0
    local v113 = #p64.pool * 66
    local v114 = UIKit.frame(p63.Frame, {
        Name = "Odds",
        Corner = 18,
        Stroke = 6,
        ZIndex = 40,
        Size = UDim2.fromOffset(640, v113 + 166),
        Position = UDim2.fromScale(0.5, 0.54),
        AnchorPoint = v2,
        Color = Colors.Dark
    })

    UIKit.text(v114, {
        Name = "Title",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 41,
        Text = string.upper(p64.name) .. " ODDS",
        Size = UDim2.new(1, -80, 0, 50),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left
    })
    UIKit.button(v114, {
        Name = "Close",
        Text = "X",
        Corner = 10,
        Stroke = 4,
        ZIndex = 42,
        Size = UDim2.fromOffset(44, 44),
        Position = UDim2.new(1, -10, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 510
            -- upvalues: v114 (copy), closePanel (copy)
            closePanel(v114)
        end
    })

    for v115, v116 in ipairs(p64.pool) do
        local v117 = Fish.ById[v116.fish]
        local v118 = Rarities.ById[v117.rarity]
        local v119 = UIKit.frame(v114, {
            Corner = 10,
            ZIndex = 41,
            Name = v116.fish,
            Size = UDim2.new(1, -28, 0, 60),
            Position = UDim2.fromOffset(14, 66 + (v115 - 1) * 66),
            Color = Colors.Panel
        })
        local v120 = UIKit.frame(v119, {
            Name = "Tile",
            Corner = 8,
            ZIndex = 42,
            Size = UDim2.fromOffset(52, 52),
            Position = UDim2.fromOffset(4, 4),
            Color = v118.Color,
            Color2 = v118.Color2
        })

        FishIcons.Picture(v120, v116.fish, p64.v, 1.1)

        local text = UIKit.text
        local t35 = {
            Name = "FishName",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 42
        }
        local fish = v116.fish
        local v, s = p64.v, p64.s
        local v121 = Variants.List[v] or Variants.List[1]
        local v122 = Sizes.List[s] or Sizes.List[Sizes.NORMAL_INDEX]
        local v123 = if v121.index >= 2 then v121.id .. " " else ""

        if v122.index ~= Sizes.NORMAL_INDEX then
            v123 ..= v122.id .. " "
        end

        t35.Text = v123 .. Fish.ById[fish].name
        t35.Size = UDim2.new(1, -330, 0, 30)
        t35.Position = UDim2.fromOffset(66, (p64.percent or p64.fixed) and 3 or 15)
        t35.XAlign = Left
        text(v119, t35).TextTruncate = Enum.TextTruncate.AtEnd

        local v124, v125 = Products.LikeZone(v116)

        if p64.fixed and v124 then
            local v126 = UIKit.text(v119, {
                Name = "Like",
                TextSize = 19,
                Stroke = 3,
                ZIndex = 42,
                Text = ("Zone %d  •  %s"):format(v124, v125),
                Size = UDim2.new(1, -260, 0, 24),
                Position = UDim2.fromOffset(66, 32),
                XAlign = Left,
                Color = Colors.Gold
            })

            v126.TextScaled = true

            local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

            UITextSizeConstraint.MaxTextSize = 19
            UITextSizeConstraint.Parent = v126
        end

        if p64.percent then
            UIKit.text(v119, {
                Name = "Percent",
                TextSize = 19,
                Stroke = 3,
                ZIndex = 42,
                Text = v116.pct .. "% of your best fish",
                Size = UDim2.new(1, -330, 0, 24),
                Position = UDim2.fromOffset(66, 32),
                XAlign = Left,
                Color = Colors.Gold
            })
        end

        local v127 = Products.CrateIncome(p64, v116, v112) or Roll.income(v116.fish, p64.v, p64.s)

        UIKit.text(v119, {
            Name = "Rate",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 42,
            Text = NumberFormat.rate(v127),
            Size = UDim2.fromOffset(170, 60),
            Position = UDim2.new(1, -266, 0, 0),
            XAlign = Right,
            Color = Colors.Cash,
            StrokeColor = Colors.CashStroke
        })
        UIKit.text(v119, {
            Name = "Chance",
            TextSize = 30,
            Stroke = 4,
            ZIndex = 42,
            Text = v116.chance .. "%",
            Size = UDim2.fromOffset(86, 60),
            Position = UDim2.new(1, -90, 0, 0),
            Color = Colors.Gold
        })
    end

    local v128 = if p64.percent then "Each one opens into exactly one fish from this list. The $ shown is what each would earn for YOU right now: a percentage of your best fish (" .. NumberFormat.rate(v112) .. "). It keeps up by itself: catch a better fish and it earns more." elseif p64.fixed then "Each crate opens into exactly one fish from this list. It earns the $ shown, the same for everyone: as much as a middle fish of that zone." else "Each crate opens into exactly one fish from this list."

    UIKit.text(v114, {
        Name = "Note",
        TextSize = 19,
        Stroke = 3,
        ZIndex = 41,
        Text = v128,
        Size = UDim2.new(1, -28, 0, 76),
        Position = UDim2.new(0, 14, 1, -84),
        Color = Colors.Grey
    }).TextWrapped = true
    UIKit.pop(v114, 0.7)
end

local function crateBanner(p65, p66, p67, p68) -- line: 546
    -- upvalues: ReplicatedStorage (copy), Products (copy), NumberFormat (copy), UIKit (copy), FishIcons (copy), Colors (copy), fromRGB (copy), Left (copy), v2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), glowBehind (copy), hoverLift (copy), robuxButton (copy), n4 (ref), sparkleBack (copy), oddsPanel (copy)
    local v129 = if p67.percent then 372 elseif p67.fixed then 338 else 318
    local v130 = UIKit.frame(p65, {
        Corner = 20,
        Stroke = 6,
        ZIndex = 12,
        Name = p67.key,
        Size = UDim2.fromOffset(1026, v129),
        Color = p68.top,
        Color2 = p68.bottom,
        GradientRotation = p68.rotation
    })

    n4 += 1
    v130.LayoutOrder = n4
    table.insert(t3, v130)
    sparkleBack(v130, 20, Vector2.new(150, v129 / 2 + 14), 620, p68.tint, {
        { 40, 70, 38 },
        { 268, 96, 30 },
        {
            250, 268, 24,
            fromRGB(255, 240, 150)
        },
        {
            36, 250, 26,
            fromRGB(255, 240, 150)
        },
        { 560, 44, 26 },
        {
            880, 60, 34,
            fromRGB(255, 240, 150)
        },
        { 716, 30, 20 },
        { 992, 150, 24 },
        {
            452, 70, 18,
            fromRGB(255, 240, 150)
        }
    })

    local v131 = UIKit.frame(v130, {
        Name = "Art",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.fromOffset(270, 280),
        Position = UDim2.fromOffset(15, v129 / 2 + 14),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    local art = p68.art
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v132 = Assets and Assets:FindFirstChild("Shop")

    v129 = v132 and v132:FindFirstChild(art)

    if v129 then
        UIKit.viewModel(v131, v129, {
            ZIndex = 14,
            Spin = p68.spin,
            Zoom = p68.zoom or 0.8,
            Dir = p68.dir or Vector3.new(0.5, 0.22, -1)
        })
    end

    local Position = v131.Position
    local v133 = math.random() * 6
    local n6 = 1.8
    local n7 = 7

    table.insert(t6, {
        seen = false,
        gui = v131,
        step = function(p69) -- line: 113
            -- upvalues: v131 (copy), Position (copy), v133 (copy), n6 (copy), n7 (copy)
            v131.Position = Position + UDim2.fromOffset(0, math.sin(p69 * n6 + v133) * n7)
        end
    })

    local Rotation = v131.Rotation
    local v137 = math.random() * 6
    local n8 = 1.1
    local n9 = 3

    table.insert(t6, {
        seen = false,
        gui = v131,
        step = function(p70) -- line: 122
            -- upvalues: v131 (copy), Rotation (copy), v137 (copy), n8 (copy), n9 (copy)
            v131.Rotation = Rotation + math.sin(p70 * n8 + v137) * n9
        end
    })
    Assets = {
        Corner = 20,
        ZIndex = 15,
        Period = 5.5,
        Sweep = 1.3,
        Strength = 0.22,
        Width = 0.16,
        Rotation = 18
    } or {}
    Assets.Manual = true
    Assets, v132 = UIKit.gleam(v130, Assets)
    table.insert(t6, {
        seen = false,
        gui = v130,
        step = v132
    })

    local v142 = UIKit.text(v130, {
        Name = "Title",
        TextSize = 52,
        Stroke = 6,
        ZIndex = 16,
        Text = string.upper(p67.name),
        Size = UDim2.fromOffset(470, 58),
        Position = UDim2.fromOffset(286, 10),
        XAlign = Left,
        Color = Colors.White,
        StrokeColor = p68.titleStroke
    })

    UIKit.gradient(v142, p68.titleColor[1], p68.titleColor[2])
    art = if #p67.tag > 5 then 132 else 104

    local v143 = UIKit.frame(v130, {
        Name = "Tag",
        GradientRotation = 0,
        Corner = 10,
        Stroke = 4,
        ZIndex = 16,
        Size = UDim2.fromOffset(art, 40),
        Position = UDim2.fromOffset(286 + v142.TextBounds.X + 18, 20),
        Color = p68.tagColors[1],
        Color2 = p68.tagColors[2]
    })

    v143.Rotation = -4
    UIKit.text(v143, {
        Name = "Label",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 17,
        Text = p67.tag
    })

    local function placeTag() -- line: 575
        -- upvalues: v142 (copy), v143 (copy)
        local v144 = v142.AbsoluteSize.X / 470

        if v144 > 0 and v142.TextBounds.X > 0 then
            v143.Position = UDim2.fromOffset(286 + v142.TextBounds.X / v144 + 16, 20)
        end
    end

    v142:GetPropertyChangedSignal("TextBounds"):Connect(placeTag)
    v142:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeTag)
    v132 = UIKit.button

    local v138 = {
        Name = "Odds",
        Text = "ODDS",
        Corner = 12,
        Stroke = 5,
        ZIndex = 16,
        Size = UDim2.fromOffset(150, 50),
        Position = UDim2.new(1, -16, 0, 14),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(44, 40, 70),
        Color2 = fromRGB(22, 20, 40)
    }

    function v138.OnClick() -- line: 583
        -- upvalues: p66 (copy), p67 (copy), oddsPanel (copy)
        oddsPanel(p66, p67)
    end

    v132 = v132(v130, v138)

    local v134 = {
        Corner = 12,
        ZIndex = 16,
        Period = 4.2,
        Strength = 0.35
    } or {}

    v134.Manual = true
    v134, v138 = UIKit.gleam(v132, v134)
    table.insert(t6, {
        seen = false,
        gui = v132,
        step = v138
    })

    local Rotation2 = v143.Rotation
    local v145 = math.random() * 6
    local n10 = 3
    local n11 = 4

    table.insert(t6, {
        seen = false,
        gui = v143,
        step = function(p71) -- line: 122
            -- upvalues: v143 (copy), Rotation2 (copy), v145 (copy), n10 (copy), n11 (copy)
            v143.Rotation = Rotation2 + math.sin(p71 * n10 + v145) * n11
        end
    })

    local v147 = UIKit.scaleOf(v143)
    local v148 = math.random() * 6
    local n12 = 0.07
    local n13 = 3.4

    table.insert(t6, {
        seen = false,
        gui = v143,
        step = function(p72) -- line: 131
            -- upvalues: v147 (copy), v148 (copy), n12 (copy), n13 (copy)
            v147.Scale = 1 + n12 * (math.sin(p72 * n13 + v148) * 0.5 + 0.5)
        end
    })
    UIKit.text(v130, {
        Name = "Text",
        TextSize = 27,
        Stroke = 4,
        ZIndex = 16,
        Text = p67.text,
        Size = UDim2.fromOffset(600, 30),
        Position = UDim2.fromOffset(288, 66),
        XAlign = Left
    })
    v132 = #p67.pool

    local v141 = math.floor((710 - (v132 - 1) * 8) / v132)

    v134 = math.min(112, v141)
    v138 = if p67.percent or p67.fixed then 104 else 84

    local text, stroke

    for v150, v151 in ipairs(p67.pool) do
        local v152 = 300 + (v150 - 1) * (v134 + 8)
        local v153 = v150 == v132

        text = UIKit.text

        local v154 = {
            TextSize = 27,
            Stroke = 4,
            ZIndex = 16,
            Name = "Chance" .. v150,
            Text = v151.chance .. "%",
            Size = UDim2.fromOffset(v134, 28),
            Position = UDim2.fromOffset(v152, 100)
        }

        if v153 then
            v154.Color = Colors.Gold
        else
            v154.Color = Colors.White
        end

        text(v130, v154)

        local v155 = UIKit.frame(v130, {
            Class = "TextButton",
            Corner = 10,
            ZIndex = 15,
            Name = "Thumb" .. v150,
            Size = UDim2.fromOffset(v134, v138),
            Position = UDim2.fromOffset(v152, 130),
            Color = p68.tile[1],
            Color2 = p68.tile[2]
        })

        v155.Text = ""
        v155.AutoButtonColor = false
        stroke = UIKit.stroke

        local text2 = if v153 then 5 else 4

        stroke = stroke(v155, text2)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local v156

        if v153 then
            table.insert(t5, stroke)

            local v157 = UIKit.image(v130, "Glow", {
                Transparency = 0.35,
                ZIndex = 14,
                Size = UDim2.fromOffset(v134 + 70, v138 + 70),
                Position = UDim2.fromOffset(v152 + v134 / 2, v138 / 2 + 130),
                AnchorPoint = v2,
                Color = fromRGB(255, 240, 150)
            })
            local v158 = v134 + 70
            local v159 = v138 + 70

            v156 = function(p73) -- line: 609
                -- upvalues: v157 (copy), v158 (copy), v159 (copy)
                local v161 = math.sin(p73 * 3) * 0.5 + 0.5

                v157.ImageTransparency = 0.55 - v161 * 0.35
                v157.Size = UDim2.fromOffset(v158 * (v161 * 0.16 + 0.92), v159 * (v161 * 0.16 + 0.92))
            end

            table.insert(t6, {
                seen = false,
                gui = v157,
                step = v156
            })
            UIKit.sparkle(v130, 26, {
                ZIndex = 17,
                Phase = 1,
                Position = UDim2.fromOffset(v152 + v134 - 6, 136),
                Color = fromRGB(255, 240, 150)
            })
        end

        local Position = v155.Position
        local v162 = v150 * 0.9

        v156 = {
            seen = false,
            gui = v155,
            step = function(p74) -- line: 619
                -- upvalues: v153 (copy), v155 (copy), Position (copy), v162 (copy)
                v155.Position = Position + UDim2.fromOffset(0, math.sin(p74 * 2.2 + v162) * (v153 and 4 or 2.5))
            end
        }
        table.insert(t6, v156)
        hoverLift(v155, 1.08)
        v154 = UIKit.frame

        local t39 = {
            Name = "Picture",
            Transparency = 1,
            ZIndex = 15,
            Size = UDim2.new(1, -8, 0, (p67.percent or p67.fixed) and 72 or 76),
            Position = UDim2.fromOffset(4, 4)
        }

        v154 = v154(v155, t39)
        FishIcons.Picture(v154, v151.fish, p67.v, 1.18)

        if p67.percent or p67.fixed then
            v154 = UIKit.frame
            t39 = {
                Name = "Worth",
                Transparency = 0.2,
                Corner = 9,
                ZIndex = 17
            }
            t39.Size = UDim2.new(1, -8, 0, 28)
            t39.Position = UDim2.new(0.5, 0, 1, -4)
            t39.AnchorPoint = Vector2.new(0.5, 1)
            t39.Color = fromRGB(16, 12, 30)
            v154 = v154(v155, t39)
            text2 = UIKit.icon
            text2(v154, "Cash", {
                ZIndex = 18,
                Size = UDim2.fromOffset(34, 34),
                Position = UDim2.new(0, -2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            text2 = UIKit.text
            v156 = {
                Name = "Percent",
                TextSize = 22,
                Stroke = 3,
                ZIndex = 18
            }

            if p67.percent then
                v156.Text = v151.pct .. "%"
            else
                v156.Text = NumberFormat.rate(Products.FixedIncome(p67, v151)):gsub("^%$", "")
            end

            v156.Size = UDim2.new(1, -32, 1, 0)
            v156.Position = UDim2.fromOffset(30, 0)

            if v153 then
                v156.Color = Colors.Gold
            else
                v156.Color = Colors.White
            end

            text2(v154, v156)
        end

        v155.Activated:Connect(function() -- line: 630
            -- upvalues: p66 (copy), p67 (copy), UIKit (copy), oddsPanel (copy)
            UIKit.sound("Click")
            oddsPanel(p66, p67)
        end)
    end

    v134 = v138 + 130 + 6

    if p67.percent then
        v138 = UIKit.frame(v130, {
            Name = "Best",
            Transparency = 0.35,
            Corner = 10,
            ZIndex = 15,
            Size = UDim2.fromOffset(710, 30),
            Position = UDim2.fromOffset(300, v134),
            Color = fromRGB(16, 12, 30)
        })
        v141 = UIKit.text(v138, {
            Name = "Label",
            Text = "",
            TextSize = 21,
            Stroke = 3,
            ZIndex = 16,
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.fromOffset(8, 0)
        })
        v141.RichText = true
        t4[v141] = p67
        v134 += 34
    end

    v141 = #p67.buy

    local v136 = math.floor((710 - (v141 - 1) * 12) / v141)

    for v164, v165 in ipairs(p67.buy) do
        text = 300 + (v164 - 1) * (v136 + 12)
        UIKit.text(v130, {
            TextSize = 26,
            Stroke = 4,
            ZIndex = 16,
            Name = "Count" .. v164,
            Text = "Buy x" .. v165.count,
            Size = UDim2.fromOffset(v136, 28),
            Position = UDim2.fromOffset(text, v134)
        })
        stroke = robuxButton(v130, v165, UDim2.fromOffset(v136, 60), UDim2.fromOffset(text, v134 + 30))

        if v164 == v141 then
            glowBehind(stroke)
        end
    end

    return v130
end

local function refreshBest() -- line: 660
    -- upvalues: NumberFormat (copy), t4 (copy), bestIncome (copy)
    for v166, v167 in pairs(t4) do
        v166.Text = ("Each earns a <font color=\"#FFD23C\">%% of YOUR best fish</font>  •  Your best: <font color=\"#78EB5A\">%s</font>"):format(NumberFormat.rate(bestIncome(v167)))
    end
end

local function pct(p75) -- line: 666
    return string.format("%.4g%%", p75 * 100)
end

local function luckyOddsPanel(p76) -- line: 671
    -- upvalues: Sizes (copy), UIKit (copy), Colors (copy), fromRGB (copy), Left (copy), Right (copy), v2 (copy), closePanel (copy)
    local Odds = p76.Frame:FindFirstChild("Odds")

    if Odds then
        Odds:Destroy()
    end

    local v168 = UIKit.frame(p76.Frame, {
        Name = "Odds",
        Corner = 18,
        Stroke = 6,
        ZIndex = 40,
        Size = UDim2.fromOffset(680, #Sizes.List * 40 + 190),
        Position = UDim2.fromScale(0.5, 0.54),
        AnchorPoint = v2,
        Color = Colors.Dark
    })

    UIKit.clover(v168, 54, {
        ZIndex = 41,
        Position = UDim2.fromOffset(14, 6)
    })
    UIKit.text(v168, {
        Name = "Title",
        Text = "LUCKY CAST ODDS",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 41,
        Size = UDim2.new(1, -140, 0, 50),
        Position = UDim2.fromOffset(74, 8),
        XAlign = Left
    })
    UIKit.button(v168, {
        Name = "Close",
        Text = "X",
        Corner = 10,
        Stroke = 4,
        ZIndex = 42,
        Size = UDim2.fromOffset(44, 44),
        Position = UDim2.new(1, -10, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 680
            -- upvalues: v168 (copy), closePanel (copy)
            closePanel(v168)
        end
    })
    UIKit.text(v168, {
        Name = "H1",
        Text = "SIZE",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.fromOffset(200, 24),
        Position = UDim2.fromOffset(28, 64),
        XAlign = Left,
        Color = Colors.Grey
    })
    UIKit.text(v168, {
        Name = "H2",
        Text = "CASH",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.fromOffset(100, 24),
        Position = UDim2.fromOffset(228, 64),
        XAlign = Left,
        Color = Colors.Grey
    })
    UIKit.text(v168, {
        Name = "H3",
        Text = "NORMAL CAST",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.fromOffset(160, 24),
        Position = UDim2.new(1, -210, 0, 64),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Right,
        Color = Colors.Grey
    })
    UIKit.text(v168, {
        Name = "H4",
        Text = "LUCKY CAST",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.fromOffset(160, 24),
        Position = UDim2.new(1, -28, 0, 64),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Right,
        Color = fromRGB(120, 240, 120)
    })

    for v169, v170 in ipairs(Sizes.List) do
        local v171 = UIKit.frame(v168, {
            Corner = 8,
            ZIndex = 41,
            Name = v170.id,
            Size = UDim2.new(1, -28, 0, 36),
            Position = UDim2.fromOffset(14, 92 + (v169 - 1) * 40),
            Color = Colors.Panel
        })

        UIKit.text(v171, {
            Name = "Size",
            TextSize = 26,
            Stroke = 3,
            ZIndex = 42,
            Text = string.upper(v170.id),
            Size = UDim2.fromOffset(200, 36),
            Position = UDim2.fromOffset(14, 0),
            XAlign = Left,
            Color = v170.Color
        })
        UIKit.text(v171, {
            Name = "Mult",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 42,
            Text = "x" .. v170.mult,
            Size = UDim2.fromOffset(100, 36),
            Position = UDim2.fromOffset(214, 0),
            XAlign = Left,
            Color = Colors.Cash,
            StrokeColor = Colors.CashStroke
        })

        local text = UIKit.text
        local t42 = {
            Name = "Normal",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 42
        }
        local chance = v170.chance

        t42.Text = string.format("%.4g%%", chance * 100)
        t42.Size = UDim2.fromOffset(160, 36)
        t42.Position = UDim2.new(1, -196, 0, 0)
        t42.AnchorPoint = Vector2.new(1, 0)
        t42.XAlign = Right
        text(v171, t42)

        local text2 = UIKit.text
        local t43 = {
            Name = "Lucky",
            TextSize = 26,
            Stroke = 3,
            ZIndex = 42
        }
        local lucky = v170.lucky

        t43.Text = string.format("%.4g%%", lucky * 100)
        t43.Size = UDim2.fromOffset(160, 36)
        t43.Position = UDim2.new(1, -14, 0, 0)
        t43.AnchorPoint = Vector2.new(1, 0)
        t43.XAlign = Right
        t43.Color = Colors.Gold
        text2(v171, t43)
    end

    UIKit.text(v168, {
        Name = "Note",
        Text = "Tap USE on the dock to spend one on your next cast. It gives that cast 100x LUCK for which fish you hook, and rolls its size on the Lucky column above. Gold / Diamond / Rainbow chances stay the same.",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.new(1, -28, 0, 76),
        Position = UDim2.new(0, 14, 1, -84),
        Color = Colors.Grey
    }).TextWrapped = true
    UIKit.pop(v168, 0.7)
end

local t44 = {
    { 0, 6, 0 },
    { -40, 22, -12 },
    { 40, 22, 12 },
    { 0, 36, 4 },
    { -22, -18, -8 },
    { 24, -16, 10 }
}

local function packRow(p77, p78, p79, p80, p81, p82, p83) -- line: 702
    -- upvalues: UIKit (copy), fromRGB (copy), v2 (copy), t2 (copy), t6 (copy), glowBehind (copy), hoverLift (copy), robuxButton (copy), n4 (ref), ribbon (copy), sparkleBack (copy), t44 (copy)
    local v172 = UIKit.frame(p77, {
        Name = "Packs",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 276)
    })

    n4 += 1
    v172.LayoutOrder = n4

    for v173, v174 in ipairs(p78) do
        local v175 = UIKit.frame(v172, {
            Corner = 16,
            Stroke = 5,
            ZIndex = 12,
            Name = v174.key,
            Size = UDim2.fromOffset(247, 256),
            Position = UDim2.fromOffset((v173 - 1) * 259, 16),
            Color = p79,
            Color2 = p80
        })

        sparkleBack(v175, 16, Vector2.new(123.5, 104), 330, p81, {
            { 34, 58, 20 },
            {
                217, 74, 26,
                fromRGB(255, 240, 150)
            },
            { 203, 150, 16 },
            {
                40, 146, 18,
                fromRGB(255, 240, 150)
            }
        })
        ribbon(v175, v174.ribbon)

        local v176, v177 = p82(v174)
        local v180 = math.min(v173 + 2, #t44)

        for i = v180, 1, -1 do
            local v181 = t44[i]
            local v182 = (v180 - i) * 2 + 14
            local v183 = if i == 1 then 104 else 84
            local v184 = if UIKit.Icons[v176] then UIKit.icon(v175, v176, {
                Size = UDim2.fromOffset(v183 + 6, v183 + 6),
                Position = UDim2.new(0.5, v181[1], 0, 92 + v181[2]),
                AnchorPoint = v2,
                ZIndex = v182,
                Rotation = v181[3]
            })
                elseif v176 == "Clover" then UIKit.clover(v175, v183 - 4, {
                    Position = UDim2.new(0.5, v181[1], 0, 92 + v181[2]),
                    AnchorPoint = v2,
                    ZIndex = v182,
                    Rotation = v181[3]
                })
                else nil

            if typeof(v184) == "Instance" and v184:IsA("GuiObject") then
                local v185 = if i == 1 then 5 else 3.5
                local v186 = v173 * 1.3 + i * 0.7
                local Position = v184.Position
                local v187 = v185 or 5
                local v188 = v186 or math.random() * 6
                local n14 = 2

                table.insert(t6, {
                    seen = false,
                    gui = v184,
                    step = function(p84) -- line: 113
                        -- upvalues: v184 (copy), Position (copy), v187 (copy), n14 (copy), v188 (copy)
                        v184.Position = Position + UDim2.fromOffset(0, math.sin(p84 * n14 + v188) * v187)
                    end
                })

                if i == 1 then
                    local Rotation = v184.Rotation
                    local v191 = v173 or math.random() * 6
                    local n15 = 1.4
                    local n16 = 4

                    table.insert(t6, {
                        seen = false,
                        gui = v184,
                        step = function(p85) -- line: 122
                            -- upvalues: v184 (copy), Rotation (copy), n15 (copy), v191 (copy), n16 (copy)
                            v184.Rotation = Rotation + math.sin(p85 * n15 + v191) * n16
                        end
                    })
                end
            end
        end

        hoverLift(v175)

        local v194 = UIKit.frame(v175, {
            Name = "Amount",
            Transparency = 0.25,
            Corner = 12,
            ZIndex = 28,
            Size = UDim2.new(1, -20, 0, 38),
            Position = UDim2.new(0.5, 0, 1, -74),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = fromRGB(16, 18, 30)
        })
        local v195 = UIKit.text(v194, {
            Name = "Label",
            TextSize = 27,
            Stroke = 3,
            ZIndex = 29,
            Text = v177
        })

        if v174.minutes then
            t2[v174] = v195
        end

        local v196 = robuxButton(v175, v174, UDim2.new(1, -20, 0, 54), UDim2.new(0.5, 0, 1, -10), Vector2.new(0.5, 1))

        if v174.ribbon == "Most Value" or v174.ribbon == "Great Value" then
            glowBehind(v196, if v174.ribbon == "Most Value" then fromRGB(255, 200, 255) else nil, 0.9)
        end

        if p83 then
            p83(v175, v174)
        end
    end

    return v172
end

local t47 = {
    {
        fromRGB(90, 180, 255),
        fromRGB(40, 100, 230)
    },
    {
        fromRGB(90, 180, 255),
        fromRGB(40, 100, 230)
    },
    {
        fromRGB(190, 120, 255),
        fromRGB(120, 60, 220)
    },
    {
        fromRGB(190, 120, 255),
        fromRGB(120, 60, 220)
    },
    {
        fromRGB(255, 210, 70),
        fromRGB(240, 140, 20)
    },
    {
        fromRGB(255, 210, 70),
        fromRGB(240, 140, 20)
    },
    {
        fromRGB(255, 110, 200),
        fromRGB(200, 50, 160)
    },
    {
        fromRGB(255, 110, 200),
        fromRGB(200, 50, 160)
    }
}
local t48 = {
    fromRGB(255, 200, 40),
    fromRGB(200, 208, 230),
    fromRGB(215, 130, 70)
}

local function robuxText(p86) -- line: 757
    -- upvalues: NumberFormat (copy), v1 (copy)
    return v1 .. " " .. NumberFormat.commas((math.floor(p86 + 0.5)))
end

local function topDonators() -- line: 762
    -- upvalues: ReplicatedStorage (copy)
    local TopDonators = ReplicatedStorage:GetAttribute("TopDonators")

    if type(TopDonators) ~= "string" then
        return {}
    end

    local function v199() -- line: 767
        -- upvalues: TopDonators (copy)
        return game:GetService("HttpService"):JSONDecode(TopDonators)
    end

    local ok, result = pcall(v199)

    if not ok or type(result) ~= "table" then
        return {}
    end

    return result
end

local function donateSection(p87) -- line: 773
    -- upvalues: MarketplaceService (copy), ReplicatedStorage (copy), Products (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), LocalPlayer (copy), Colors (copy), fromRGB (copy), Left (copy), Right (copy), v1 (copy), v2 (copy), t6 (copy), hoverLift (copy), robuxButton (copy), n4 (ref), sparkleBack (copy), t47 (copy), t48 (copy), topDonators (copy)
    local v200 = UIKit.frame(p87, {
        Name = "DonateIntro",
        Corner = 20,
        Stroke = 6,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 150),
        Color = fromRGB(255, 120, 190),
        Color2 = fromRGB(150, 60, 220)
    })

    n4 += 1
    v200.LayoutOrder = n4
    sparkleBack(v200, 20, Vector2.new(92, 75), 300, Colors.White, {
        { 200, 24, 18 },
        {
            696, 30, 22,
            fromRGB(255, 240, 150)
        },
        { 170, 126, 16 }
    })

    local v201 = UIKit.text(v200, {
        Name = "Heart",
        TextSize = 120,
        Stroke = 7,
        ZIndex = 14,
        Text = utf8.char(9829),
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(20, -4),
        Color = fromRGB(255, 70, 120)
    })

    v201.Rotation = -8

    local v202 = UIKit.scaleOf(v201)
    local v203 = math.random()

    table.insert(t6, {
        seen = false,
        gui = v201,
        step = function(p88) -- line: 140
            -- upvalues: v202 (copy), v203 (copy)
            local v204 = (p88 * 0.9 + v203) % 1

            v202.Scale = math.exp(-((v204 - 0.1) / 0.045) ^ 2) * 0.14 + 1 + math.exp(-((v204 - 0.27) / 0.045) ^ 2) * 0.09
        end
    })

    local v208 = {
        Corner = 20,
        ZIndex = 13,
        Period = 6,
        Sweep = 1.3,
        Strength = 0.2,
        Width = 0.16
    } or {}

    v208.Manual = true

    local _, v209 = UIKit.gleam(v200, v208)

    table.insert(t6, {
        seen = false,
        gui = v200,
        step = v209
    })
    UIKit.text(v200, {
        Name = "Title",
        Text = "SUPPORT THE GAME!",
        TextSize = 44,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.new(1, -560, 0, 50),
        Position = UDim2.fromOffset(170, 14),
        XAlign = Left,
        Color = fromRGB(255, 246, 130)
    })
    UIKit.text(v200, {
        Name = "Text",
        Text = "Donations give no items, but they put you on the Top Donators board for everyone to see. Thank you!",
        TextSize = 25,
        Stroke = 4,
        ZIndex = 14,
        Size = UDim2.new(1, -560, 0, 70),
        Position = UDim2.fromOffset(170, 66),
        XAlign = Left,
        YAlign = Enum.TextYAlignment.Top
    }).TextWrapped = true

    local v210 = UIKit.frame(v200, {
        Name = "Mine",
        Transparency = 0.25,
        Corner = 16,
        Stroke = 4,
        ZIndex = 14,
        Size = UDim2.fromOffset(350, 112),
        Position = UDim2.new(1, -20, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = fromRGB(30, 20, 50)
    })

    UIKit.text(v210, {
        Name = "Label",
        Text = "YOU'VE DONATED",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.fromOffset(0, 10),
        Color = fromRGB(255, 200, 230)
    })

    local v211 = UIKit.text(v210, {
        Name = "Amount",
        TextSize = 40,
        Stroke = 4,
        ZIndex = 15,
        Text = v1 .. " " .. NumberFormat.commas(0),
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.fromOffset(0, 42),
        Color = Colors.Gold
    })
    local v212 = UIKit.text(v210, {
        Name = "Rank",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.fromOffset(0, 84),
        Color = fromRGB(255, 200, 230)
    })
    local Donations = Products.Donations
    local v214 = math.min(#Donations, 4)
    local v216 = math.floor((1026 - (v214 - 1) * 12) / v214)
    local v218 = math.ceil(#Donations / v214)
    local v219 = UIKit.frame(p87, {
        Name = "DonateButtons",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, v218 * 238 + 6)
    })

    n4 += 1
    v219.LayoutOrder = n4

    for v220, v221 in ipairs(Donations) do
        local v222 = t47[(v220 - 1) * 2 + 1] or t47[#t47]
        local v225 = UIKit.frame(v219, {
            Corner = 16,
            Stroke = 5,
            ZIndex = 12,
            Name = v221.key,
            Size = UDim2.fromOffset(v216, 226),
            Position = UDim2.fromOffset((v220 - 1) % v214 * (v216 + 12), math.floor((v220 - 1) / v214) * 238 + 6),
            Color = v222[1],
            Color2 = v222[2]
        })

        sparkleBack(v225, 16, Vector2.new(v216 / 2, 82), 260, Colors.White, {
            { 30, 40, 18 },
            {
                v216 - 30,
                60, 22,
                fromRGB(255, 240, 150)
            }
        })

        local v226 = UIKit.text(v225, {
            Name = "Heart",
            TextSize = 96,
            Stroke = 6,
            ZIndex = 14,
            Text = utf8.char(9829),
            Size = UDim2.fromOffset(140, 120),
            Position = UDim2.new(0.5, 0, 0, 82),
            AnchorPoint = v2,
            Color = fromRGB(255, 70, 120)
        })

        hoverLift(v225)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Picture"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Size = UDim2.fromOffset(142, 142)
        ImageLabel.Position = UDim2.new(0.5, 0, 0, 82)
        ImageLabel.AnchorPoint = v2
        ImageLabel.ZIndex = 15
        ImageLabel.Visible = false
        ImageLabel.Parent = v225

        local v227 = 3 + v220 * 0.5
        local v228 = v220 * 0.8
        local ImageLabelPosition = ImageLabel.Position
        local v229 = v227 or 5
        local v230 = v228 or math.random() * 6
        local n17 = 1.7

        table.insert(t6, {
            seen = false,
            gui = ImageLabel,
            step = function(p89) -- line: 113
                -- upvalues: ImageLabel (copy), ImageLabelPosition (copy), v229 (copy), n17 (copy), v230 (copy)
                ImageLabel.Position = ImageLabelPosition + UDim2.fromOffset(0, math.sin(p89 * n17 + v230) * v229)
            end
        })

        local v233 = 3 + v220 * 0.5
        local v234 = v220 * 0.8
        local Position = v226.Position
        local v235 = v233 or 5
        local v236 = v234 or math.random() * 6
        local n18 = 1.7

        table.insert(t6, {
            seen = false,
            gui = v226,
            step = function(p90) -- line: 113
                -- upvalues: v226 (copy), Position (copy), v235 (copy), n18 (copy), v236 (copy)
                v226.Position = Position + UDim2.fromOffset(0, math.sin(p90 * n18 + v236) * v235)
            end
        })

        if v221.id ~= 0 then
            task.spawn(function() -- line: 818
                -- upvalues: v226 (copy), ImageLabel (copy), v221 (copy), MarketplaceService (copy)
                local function v239() -- line: 819
                    -- upvalues: v221 (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(v221.id, Enum.InfoType.Product)
                end

                local ok, result = pcall(v239)
                local v240 = ok and result and result.IconImageAssetId

                if v240 and v240 ~= 0 then
                    ImageLabel.Image = "rbxassetid://" .. v240
                    ImageLabel.Visible = true
                    v226.Visible = false
                end
            end)
        end

        robuxButton(v225, v221, UDim2.new(1, -20, 0, 56), UDim2.new(0.5, 0, 1, -10), Vector2.new(0.5, 1))
    end

    local v241 = UIKit.frame(p87, {
        Name = "TopDonators",
        Corner = 20,
        Stroke = 6,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 818),
        Color = fromRGB(40, 30, 72),
        Color2 = fromRGB(24, 20, 46)
    })

    n4 += 1
    v241.LayoutOrder = n4

    local v242 = UIKit.frame(v241, {
        Name = "Title",
        Corner = 18,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.fromOffset(460, 60),
        Position = UDim2.new(0.5, 0, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(255, 120, 200),
        Color2 = fromRGB(255, 180, 70)
    })

    UIKit.text(v242, {
        Name = "Label",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 15,
        Text = utf8.char(9829) .. "  TOP DONATORS  " .. utf8.char(9829)
    })

    local v243 = {
        Corner = 18,
        ZIndex = 14,
        Period = 3.8,
        Strength = 0.5
    } or {}

    v243.Manual = true

    local _, v244 = UIKit.gleam(v242, v243)

    table.insert(t6, {
        seen = false,
        gui = v242,
        step = v244
    })

    local t55 = {}

    for i = 1, 10 do
        local v245 = t48[i]
        local frame = UIKit.frame
        local t56 = {
            Corner = 14,
            Stroke = 4,
            ZIndex = 13,
            Name = "Row" .. i,
            Size = UDim2.new(1, -40, 0, 64),
            Position = UDim2.fromOffset(20, (i - 1) * 72 + 88)
        }

        if v245 then
            t56.Color = v245:Lerp(fromRGB(40, 30, 72), 0.55)
            t56.Color2 = v245:Lerp(fromRGB(24, 20, 46), 0.7)
        else
            t56.Color = fromRGB(56, 48, 96)
            t56.Color2 = fromRGB(44, 38, 80)
        end

        local v246 = frame(v241, t56)
        local v247 = UIKit.frame(v246, {
            Name = "Rank",
            Corner = 25,
            Stroke = 4,
            ZIndex = 14,
            Size = UDim2.fromOffset(50, 50),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = v245 or fromRGB(90, 84, 130)
        })

        UIKit.text(v247, {
            Name = "N",
            TextSize = 28,
            Stroke = 3,
            ZIndex = 15,
            Text = tostring(i)
        })

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Face"
        ImageLabel.BackgroundColor3 = fromRGB(30, 26, 52)
        ImageLabel.Size = UDim2.fromOffset(50, 50)
        ImageLabel.Position = UDim2.new(0, 72, 0.5, 0)
        ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
        ImageLabel.ZIndex = 14
        ImageLabel.Parent = v246
        UIKit.corner(ImageLabel, 25)
        UIKit.stroke(ImageLabel, 3)

        local v248 = UIKit.text(v246, {
            Name = "Name",
            Text = "---",
            TextSize = 30,
            Stroke = 4,
            ZIndex = 14,
            Size = UDim2.new(1, -420, 1, 0),
            Position = UDim2.fromOffset(136, 0),
            XAlign = Left
        })

        v248.TextTruncate = Enum.TextTruncate.AtEnd
        t55[i] = {
            row = v246,
            face = ImageLabel,
            name = v248,
            amount = UIKit.text(v246, {
                Name = "Amount",
                Text = "",
                TextSize = 32,
                Stroke = 4,
                ZIndex = 14,
                Size = UDim2.fromOffset(260, 64),
                Position = UDim2.new(1, -18, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                XAlign = Right,
                Color = Colors.Gold
            }),
            stroke = v246:FindFirstChildOfClass("UIStroke")
        }
    end

    local function refresh() -- line: 863
        -- upvalues: v211 (copy), v212 (copy), t55 (copy), NumberFormat (copy), DataClient (copy), LocalPlayer (copy), Colors (copy), fromRGB (copy), v1 (copy), topDonators (copy)
        local v249 = topDonators()
        local v250

        for i = 1, 10 do
            local v251 = t55[i]
            local v252 = v249[i]

            if v252 then
                v251.face.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(v252.u) .. "&w=150&h=150"
                v251.name.Text = tostring(v252.n)

                local amount = v251.amount
                local v253 = tonumber(v252.v) or 0

                amount.Text = v1 .. " " .. NumberFormat.commas((math.floor(v253 + 0.5)))

                if v252.u == LocalPlayer.UserId then
                    v250 = i
                end
            else
                v251.face.Image = ""
                v251.name.Text = "---"
                v251.amount.Text = ""
            end

            local name = v251.name

            if not v252 or v252.u ~= LocalPlayer.UserId then
                name.TextColor3 = Colors.White
            else
                name.TextColor3 = fromRGB(150, 255, 120)
            end
        end

        local v255 = tonumber(DataClient.Get("Donated")) or 0

        v211.Text = v1 .. " " .. NumberFormat.commas((math.floor(v255 + 0.5)))
        v212.Text = if v250 then "You're #" .. v250 .. " on the board!" elseif v255 > 0 then "Thank you!" else "Donate to join the board!"
    end

    ReplicatedStorage:GetAttributeChangedSignal("TopDonators"):Connect(refresh)
    DataClient.Observe("Donated", refresh)
    refresh()

    return nil
end

local t58 = {}

t58.__index = t58

function t58.new(p91) -- line: 895
    -- upvalues: UIKit (copy), Colors (copy), fromRGB (copy), Left (copy), donateSection (copy), t58 (copy)
    local self = setmetatable({}, t58)

    self.Win = p91

    local v259 = UIKit.frame(p91.Frame, {
        Name = "Support",
        Corner = 18,
        Stroke = 6,
        ZIndex = 40,
        Size = UDim2.new(1, -24, 1, -100),
        Position = UDim2.new(0.5, 0, 1, -12),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Dark
    })

    UIKit.text(v259, {
        Name = "Title",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 41,
        Text = utf8.char(9829) .. " SUPPORT",
        Size = UDim2.new(1, -90, 0, 50),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left,
        Color = fromRGB(255, 140, 200)
    })
    UIKit.button(v259, {
        Name = "Close",
        Text = "X",
        Corner = 10,
        Stroke = 4,
        ZIndex = 42,
        Size = UDim2.fromOffset(44, 44),
        Position = UDim2.new(1, -10, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 900
            -- upvalues: self (copy)
            self:Hide()
        end
    })

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(0, 64)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -70)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 41
    ScrollingFrame.Parent = v259

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 12)
    UIPadding.Parent = ScrollingFrame
    donateSection(ScrollingFrame)

    for _, descendant in ipairs(ScrollingFrame:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex += 30
        end
    end

    v259.Visible = false
    self.Panel = v259

    return self
end

function t58:Show() -- line: 936
    -- upvalues: UIKit (copy)
    self.Panel.Visible = true
    UIKit.scaleOf(self.Panel).Scale = 1
    UIKit.pop(self.Panel, 0.7)

    local Close = self.Win.Frame:FindFirstChild("Close")

    if Close then
        Close.Visible = false
    end
end

function t58:Hide() -- line: 946
    self.Panel.Visible = false

    local Close = self.Win.Frame:FindFirstChild("Close")

    if Close then
        Close.Visible = true
    end
end

function t58:Toggle() -- line: 954
    if self.Panel.Visible then
        self:Hide()
    else
        self:Show()
    end
end

local t61 = {
    luck = {
        fromRGB(120, 235, 110),
        fromRGB(24, 150, 60),
        fromRGB(220, 255, 200)
    },
    cash = {
        fromRGB(255, 215, 80),
        fromRGB(230, 140, 20),
        fromRGB(255, 245, 200)
    },
    strength = {
        fromRGB(255, 160, 80),
        fromRGB(220, 80, 40),
        fromRGB(255, 225, 200)
    },
    cosmic = {
        fromRGB(190, 130, 255),
        fromRGB(110, 60, 220),
        fromRGB(240, 220, 255)
    }
}

local function potionRow(p95) -- line: 969
    -- upvalues: Shared (copy), Products (copy), UIKit (copy), fromRGB (copy), v2 (copy), t6 (copy), hoverLift (copy), robuxButton (copy), n4 (ref), sparkleBack (copy), t61 (copy)
    local BuffHud = require(script.Parent.BuffHud)
    local Buffs = require(Shared.Data.Buffs)
    local v260 = UIKit.frame(p95, {
        Name = "Potions",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 276)
    })

    n4 += 1
    v260.LayoutOrder = n4

    for v261, v262 in ipairs(Products.Potions) do
        local v263 = Buffs.ById[v262.buff]
        local v264 = t61[v262.buff] or t61.luck
        local v265 = UIKit.frame(v260, {
            Corner = 16,
            Stroke = 5,
            ZIndex = 12,
            Name = v262.key,
            Size = UDim2.fromOffset(247, 256),
            Position = UDim2.fromOffset((v261 - 1) * 259, 16),
            Color = v264[1],
            Color2 = v264[2]
        })

        sparkleBack(v265, 16, Vector2.new(123.5, 92), 330, v264[3], {
            { 34, 58, 20 },
            {
                217, 74, 26,
                fromRGB(255, 240, 150)
            },
            { 203, 150, 16 }
        })

        if v263 then
            local v266 = BuffHud.Bottle(v265, v263, 142, 14)

            v266.AnchorPoint = v2
            v266.Position = UDim2.new(0.5, 0, 0, 80)
            v266.Rotation = -8

            local v267 = v261 * 1.3
            local Position = v266.Position
            local v268 = v267 or math.random() * 6
            local n19 = 2
            local n20 = 5

            table.insert(t6, {
                seen = false,
                gui = v266,
                step = function(p96) -- line: 113
                    -- upvalues: v266 (copy), Position (copy), n19 (copy), v268 (copy), n20 (copy)
                    v266.Position = Position + UDim2.fromOffset(0, math.sin(p96 * n19 + v268) * n20)
                end
            })

            local Rotation = v266.Rotation
            local v271 = v261 or math.random() * 6
            local n21 = 1.4
            local n22 = 4

            table.insert(t6, {
                seen = false,
                gui = v266,
                step = function(p97) -- line: 122
                    -- upvalues: v266 (copy), Rotation (copy), n21 (copy), v271 (copy), n22 (copy)
                    v266.Rotation = Rotation + math.sin(p97 * n21 + v271) * n22
                end
            })
        end

        hoverLift(v265)

        local v274 = UIKit.frame(v265, {
            Name = "Amount",
            Transparency = 0.25,
            Corner = 12,
            ZIndex = 28,
            Size = UDim2.new(1, -20, 0, 38),
            Position = UDim2.new(0.5, 0, 1, -74),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = fromRGB(16, 18, 30)
        })
        local v276 = math.floor((v262.seconds or v263 and v263.seconds or 0) / 60)
        local v277 = UIKit.text(v274, {
            Name = "Label",
            TextSize = 25,
            Stroke = 3,
            ZIndex = 29,
            Text = (v263 and "x2 " .. v263.short or "") .. "  " .. v276 .. " min",
            Size = UDim2.new(1, -16, 1, -6),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v2
        })

        v277.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 25
        UITextSizeConstraint.Parent = v277
        robuxButton(v265, v262, UDim2.new(1, -20, 0, 54), UDim2.new(0.5, 0, 1, -10), Vector2.new(0.5, 1))
    end

    return v260
end

local function refreshCash() -- line: 1001
    -- upvalues: Products (copy), NumberFormat (copy), LocalPlayer (copy), t2 (copy)
    local v278 = LocalPlayer:GetAttribute("IncomePerSecond") or 0

    for v279, v280 in pairs(t2) do
        v280.Text = "+" .. NumberFormat.money(Products.CashFor(v279, v278))
    end
end

local function serverLuckSection(p98) -- line: 1011
    -- upvalues: MarketplaceService (copy), Products (copy), UIKit (copy), t1 (copy), Colors (copy), fromRGB (copy), Left (copy), v1 (copy), v2 (copy), t6 (copy), glowBehind (copy), burst (copy), buy (copy), n4 (ref), divider (copy), sparkleBack (copy)
    local ServerLuckHud = require(script.Parent.ServerLuckHud)
    local tiers, minutes = Products.ServerLuck.tiers, Products.ServerLuck.minutes
    local v281 = divider(p98, "Server Luck")
    local v282 = UIKit.frame(p98, {
        Name = "ServerLuck",
        GradientRotation = 20,
        Corner = 20,
        Stroke = 6,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 236),
        Color = fromRGB(130, 240, 90),
        Color2 = fromRGB(40, 170, 50)
    })

    n4 += 1
    v282.LayoutOrder = n4

    local UIGradient = v282:FindFirstChildOfClass("UIGradient")

    sparkleBack(v282, 20, Vector2.new(118, 118), 440, Colors.White, {
        { 210, 34, 22 },
        {
            986, 34, 26,
            fromRGB(255, 240, 150)
        },
        { 36, 206, 18 },
        { 640, 214, 20 },
        {
            470, 26, 16,
            fromRGB(255, 240, 150)
        }
    })
    UIKit.frame(v282, {
        Name = "Disc",
        Transparency = 0.72,
        Corner = 94,
        ZIndex = 13,
        Size = UDim2.fromOffset(188, 188),
        Position = UDim2.fromOffset(24, 118),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = Colors.White
    })

    local v283 = UIKit.clover(v282, 160, {
        ZIndex = 14,
        Position = UDim2.fromOffset(118, 104),
        AnchorPoint = v2
    })

    if typeof(v283) == "Instance" and v283:IsA("GuiObject") then
        local Rotation = v283.Rotation
        local v284 = math.random() * 6
        local n23 = 1.3
        local n24 = 8

        table.insert(t6, {
            seen = false,
            gui = v283,
            step = function(p99) -- line: 122
                -- upvalues: v283 (copy), Rotation (copy), v284 (copy), n23 (copy), n24 (copy)
                v283.Rotation = Rotation + math.sin(p99 * n23 + v284) * n24
            end
        })

        local Position = v283.Position
        local v287 = math.random() * 6
        local n25 = 1.9
        local n26 = 5

        table.insert(t6, {
            seen = false,
            gui = v283,
            step = function(p100) -- line: 113
                -- upvalues: v283 (copy), Position (copy), v287 (copy), n25 (copy), n26 (copy)
                v283.Position = Position + UDim2.fromOffset(0, math.sin(p100 * n25 + v287) * n26)
            end
        })
    end

    local v290 = UIKit.text(v282, {
        Name = "Next",
        Text = "x2",
        TextSize = 60,
        Stroke = 7,
        ZIndex = 15,
        Size = UDim2.fromOffset(188, 64),
        Position = UDim2.fromOffset(24, 152),
        Color = fromRGB(255, 240, 120)
    })
    local v291 = UIKit.scaleOf(v290)
    local v292 = math.random() * 6
    local n27 = 0.1
    local n28 = 3.2

    table.insert(t6, {
        seen = false,
        gui = v290,
        step = function(p101) -- line: 131
            -- upvalues: v291 (copy), v292 (copy), n27 (copy), n28 (copy)
            v291.Scale = 1 + n27 * (math.sin(p101 * n28 + v292) * 0.5 + 0.5)
        end
    })

    local v295 = {
        Corner = 20,
        ZIndex = 13,
        Period = 5,
        Sweep = 1.2,
        Strength = 0.22,
        Width = 0.16
    } or {}

    v295.Manual = true

    local _, v296 = UIKit.gleam(v282, v295)

    table.insert(t6, {
        seen = false,
        gui = v282,
        step = v296
    })
    UIKit.text(v282, {
        Name = "Title",
        Text = "SERVER LUCK",
        TextSize = 50,
        Stroke = 6,
        ZIndex = 16,
        Size = UDim2.fromOffset(460, 56),
        Position = UDim2.fromOffset(236, 10),
        XAlign = Left,
        Color = fromRGB(255, 246, 150)
    })
    UIKit.text(v282, {
        Name = "Text",
        TextSize = 24,
        Stroke = 4,
        ZIndex = 16,
        Text = "Everyone in this server gets more luck for " .. minutes .. " minutes!",
        Size = UDim2.fromOffset(770, 30),
        Position = UDim2.fromOffset(236, 66),
        XAlign = Left
    })

    local t69 = {}

    for v297, v298 in ipairs(tiers) do
        local v299 = UIKit.frame(v282, {
            Transparency = 0.35,
            Corner = 12,
            ZIndex = 16,
            Name = "Step" .. v298.mult,
            Size = UDim2.fromOffset(80, 44),
            Position = UDim2.fromOffset(236 + (v297 - 1) * 88, 106),
            Color = fromRGB(20, 22, 36)
        })

        t69[v297] = {
            frame = v299,
            stroke = UIKit.stroke(v299, 3),
            label = UIKit.text(v299, {
                Name = "Label",
                TextSize = 28,
                Stroke = 3,
                ZIndex = 17,
                Text = "x" .. v298.mult
            }),
            tier = v298
        }
    end

    local v300 = UIKit.text(v282, {
        Name = "Status",
        Text = "",
        TextSize = 24,
        Stroke = 4,
        ZIndex = 16,
        Size = UDim2.fromOffset(440, 56),
        Position = UDim2.fromOffset(236, 162),
        XAlign = Left,
        YAlign = Enum.TextYAlignment.Top
    })

    v300.TextWrapped = true
    v300.RichText = true

    local v301 = tiers[1]
    local t70 = {}

    for _, v302 in ipairs(tiers) do
        if v302.id ~= 0 then
            task.spawn(function() -- line: 1048
                -- upvalues: t70 (copy), v302 (copy), MarketplaceService (copy)
                local function v303() -- line: 1049
                    -- upvalues: v302 (copy), MarketplaceService (copy)
                    return MarketplaceService:GetProductInfo(v302.id, Enum.InfoType.Product)
                end

                local ok, result = pcall(v303)

                if ok and result and type(result.PriceInRobux) == "number" then
                    t70[v302] = result.PriceInRobux
                end
            end)
        end
    end

    local v304 = UIKit.text(v282, {
        Name = "Caption",
        Text = "NEXT STEP",
        TextSize = 24,
        Stroke = 4,
        ZIndex = 16,
        Size = UDim2.fromOffset(300, 28),
        Position = UDim2.new(1, -20, 1, -112),
        AnchorPoint = Vector2.new(1, 1),
        Color = fromRGB(255, 246, 150)
    })
    local v305, v306 = UIKit.button(v282, {
        Name = "Buy",
        Text = "",
        Corner = 14,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 20,
        Size = UDim2.fromOffset(300, 86),
        Position = UDim2.new(1, -20, 1, -20),
        AnchorPoint = Vector2.new(1, 1),
        Color = fromRGB(150, 250, 70),
        Color2 = fromRGB(40, 190, 30),
        OnClick = function() -- OnClick | line: 1059
            -- upvalues: v301 (ref), buy (copy)
            buy(v301)
        end
    })

    UIKit.frame(v305, {
        Name = "Shine",
        Transparency = 0.6,
        Corner = 3,
        ZIndex = 21,
        Size = UDim2.new(1, -16, 0, 6),
        Position = UDim2.fromOffset(8, 5),
        Color = Colors.White
    })

    local v307 = {
        Corner = 14,
        ZIndex = 20,
        Period = 2.6,
        Strength = 0.65
    } or {}

    v307.Manual = true

    local _, v308 = UIKit.gleam(v305, v307)

    table.insert(t6, {
        seen = false,
        gui = v305,
        step = v308
    })
    glowBehind(v305, nil, 0.9)
    v305.Activated:Connect(function() -- line: 1065
        -- upvalues: v305 (copy), burst (copy)
        burst(v305)
    end)

    local function refresh() -- line: 1068
        -- upvalues: ServerLuckHud (copy), tiers (copy), minutes (copy), UIGradient (copy), v290 (copy), t69 (copy), v300 (copy), v301 (ref), t70 (copy), v304 (copy), v306 (copy), Colors (copy), fromRGB (copy), v1 (copy)
        local v309, v310 = ServerLuckHud.Current()
        local v311

        for _, v312 in ipairs(tiers) do
            if v309 < v312.mult then
                v311 = v312
                break
            end
        end

        local v313 = true

        if v311 then
            v313 = false
        else
            v311 = tiers[#tiers]
        end

        v301 = v311

        local v314 = ServerLuckHud.Colors[v311.mult] or ServerLuckHud.Colors[2]

        UIGradient.Color = ColorSequence.new(v314[1], v314[2])
        v290.Text = "x" .. v311.mult
        v306.Text = (if v313 then "+" .. minutes .. " MIN  " else "x" .. v311.mult .. "  ") .. v1 .. " " .. tostring(t70[v311] or v311.robux)
        v304.Text = v313 and "ADD MORE TIME" or "NEXT STEP"
        v300.Text = if v309 > 1 then ("Running now: <font color=\"#FFF096\">x%d</font>  -  %s left"):format(v309, ServerLuckHud.Clock(v310)) else "Not running in this server right now"

        for _, v318 in ipairs(t69) do
            local v319 = v318.tier.mult == v309
            local v320 = v318.tier == v311 and not v313
            local frame = v318.frame

            if v319 then
                frame.BackgroundColor3 = fromRGB(255, 200, 50)
            else
                frame.BackgroundColor3 = fromRGB(20, 22, 36)
            end

            v318.frame.BackgroundTransparency = v319 and 0 or 0.35

            local stroke = v318.stroke

            if v320 then
                stroke.Color = Colors.White
            elseif v319 then
                stroke.Color = fromRGB(110, 60, 0)
            else
                stroke.Color = Colors.Outline
            end

            v318.stroke.Thickness = v320 and 4 or 3

            local label = v318.label

            if v318.tier.mult < v309 then
                label.TextColor3 = Colors.Grey
            else
                label.TextColor3 = Colors.White
            end
        end
    end

    refresh()
    task.spawn(function() -- line: 1100
        -- upvalues: v282 (copy), refresh (copy)
        while v282.Parent do
            refresh()
            task.wait(0.5)
        end
    end)

    t1.ScrollToServerLuck = function() -- line: 1107
        -- upvalues: p98 (copy), v281 (copy), UIKit (copy)
        local v321 = v281.AbsolutePosition.Y - p98.AbsolutePosition.Y + p98.CanvasPosition.Y
        local v323 = math.max(0, p98.AbsoluteCanvasSize.Y - p98.AbsoluteWindowSize.Y)

        UIKit.tween(p98, 0.45, {
            CanvasPosition = Vector2.new(0, (math.clamp(v321, 0, v323)))
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end

    return v281
end

local v324, v325, ImageLabel, UIListLayout
local t72 = {}

local function headshot(p102) -- line: 1119
    return "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p102) .. "&w=150&h=150"
end

local function setGiftTarget(p103) -- line: 1123
    -- upvalues: UIKit (copy), t21 (copy), v324 (ref), v325 (ref), ImageLabel (ref), UIListLayout (ref), t72 (copy)
    t21[1] = p103

    if v324 then
        local v326 = v324

        v326.Visible = p103 ~= nil

        if p103 then
            local v327 = v325

            v327.Text = "GIFTING TO " .. string.upper(p103.DisplayName)

            local ImageLabel2 = ImageLabel

            ImageLabel2.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p103.UserId) .. "&w=150&h=150"
            UIKit.pop(v324, 1.08)
        end
    end

    if UIListLayout then
        local UIListLayout2 = UIListLayout

        UIListLayout2.PaddingTop = UDim.new(0, p103 and 84 or 4)
    end

    for _, v328 in ipairs(t72) do
        v328()
    end
end

t1.SetGiftTarget = setGiftTarget
t1.MuteGiftPrompt = false
t1.LastGift = nil

v53 = function(p104, p105) -- line: 1145
    -- upvalues: Players (copy), MarketplaceService (copy), Remotes (copy), Products (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), t21 (copy), v324 (ref), UIListLayout (ref), t72 (copy)
    local v329 = t21[1]

    if not v329 or v329.Parent ~= Players then
        t21[1] = nil

        if v324 then
            v324.Visible = false
        end

        if UIListLayout then
            UIListLayout.PaddingTop = UDim.new(0, 4)
        end

        for _, v330 in ipairs(t72) do
            v330()
        end

        Toasts.Show("info", "They left the server")
    else
        local id = p104.id
        local v331 = id

        if p105 then
            v331 = 0
            id = 0

            for _, v332 in ipairs(Products.GiftPasses) do
                if v332.pass == p104.key then
                    id = v332.id
                    v331 = id
                end
            end
        end

        if not id or id == 0 then
            Toasts.Show("info", "That can't be gifted yet!")
        else
            local v333 = Products.FindProduct(id)

            if not (v333 and Products.Giftable[v333]) then
                Toasts.Show("info", if v333 == "serverLuck" then "Server Luck is already for everyone in the server!" elseif v333 == "donation" then "Donations can't be gifted" else "That can't be given as a gift")
            else
                t1.LastGift = {
                    target = v329.UserId,
                    productId = id
                }
                task.spawn(function() -- line: 1171
                    -- upvalues: v329 (copy), v331 (ref), MarketplaceService (copy), Remotes (copy), Toasts (copy), t1 (copy), LocalPlayer (copy)
                    local function v334() -- line: 1172
                        -- upvalues: v329 (copy), v331 (ref), Remotes (copy)
                        return Remotes.StartGift:InvokeServer(v329.UserId, v331)
                    end

                    local v335, v336, v337 = pcall(v334)

                    if v335 and v336 then
                        t1.LastGift.started = true

                        if not t1.MuteGiftPrompt then
                            local function v338() -- line: 1181
                                -- upvalues: v331 (ref), MarketplaceService (copy), LocalPlayer (copy)
                                MarketplaceService:PromptProductPurchase(LocalPlayer, v331)
                            end

                            pcall(v338)
                        end
                    else
                        local Show = Toasts.Show

                        if not v335 or type(v337) ~= "string" then
                            v337 = "Couldn't start the gift. Try again"
                        end

                        Show("error", v337)
                    end
                end)
            end
        end
    end
end

local function giftPanel(p106) -- line: 1189
    -- upvalues: Players (copy), UIKit (copy), LocalPlayer (copy), Colors (copy), fromRGB (copy), Left (copy), v2 (copy), closePanel (copy), setGiftTarget (copy)
    local GiftPicker = p106.Frame:FindFirstChild("GiftPicker")

    if GiftPicker then
        GiftPicker:Destroy()
    end

    local t73 = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(t73, player)
        end
    end

    local v340 = UIKit.frame(p106.Frame, {
        Name = "GiftPicker",
        Corner = 18,
        Stroke = 6,
        ZIndex = 40,
        Size = UDim2.fromOffset(800, 420),
        Position = UDim2.fromScale(0.5, 0.54),
        AnchorPoint = v2,
        Color = Colors.Dark
    })

    UIKit.image(v340, "Gift", {
        ZIndex = 42,
        Rotation = -8,
        Size = UDim2.fromOffset(84, 84),
        Position = UDim2.fromOffset(52, 46),
        AnchorPoint = v2
    })
    UIKit.text(v340, {
        Name = "Title",
        Text = "SEND A GIFT",
        TextSize = 40,
        Stroke = 5,
        ZIndex = 41,
        Size = UDim2.new(1, -170, 0, 50),
        Position = UDim2.fromOffset(100, 10),
        XAlign = Left
    })
    UIKit.text(v340, {
        Name = "Text",
        Text = "Pick who it's for, then buy anything in the shop: it goes straight to them!",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 41,
        Size = UDim2.new(1, -120, 0, 28),
        Position = UDim2.fromOffset(100, 58),
        XAlign = Left,
        Color = Colors.Grey
    })
    UIKit.button(v340, {
        Name = "Close",
        Text = "X",
        Corner = 10,
        Stroke = 4,
        ZIndex = 42,
        Size = UDim2.fromOffset(48, 48),
        Position = UDim2.new(1, -12, 0, 12),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 1204
            -- upvalues: v340 (copy), closePanel (copy)
            closePanel(v340)
        end
    })

    if #t73 == 0 then
        UIKit.text(v340, {
            Name = "Empty",
            Text = "Nobody else is in this server right now.\nInvite a friend to send them a gift!",
            TextSize = 32,
            Stroke = 4,
            ZIndex = 41,
            Size = UDim2.new(1, -60, 0, 140),
            Position = UDim2.new(0.5, 0, 0, 160),
            AnchorPoint = Vector2.new(0.5, 0)
        })
    else
        local v341 = #t73 * 176 + (#t73 - 1) * 16

        for v342, v343 in ipairs(t73) do
            local v344 = UIKit.frame(v340, {
                Class = "TextButton",
                Corner = 16,
                Stroke = 5,
                ZIndex = 41,
                Name = "Player" .. v342,
                Size = UDim2.fromOffset(176, 276),
                Position = UDim2.new(0.5, -v341 / 2 + (v342 - 1) * 192, 0, 112),
                Color = fromRGB(70, 180, 255),
                Color2 = fromRGB(40, 90, 225)
            })

            v344.Text = ""
            v344.AutoButtonColor = false
            UIKit.frame(v344, {
                Name = "Disc",
                Transparency = 0.7,
                Corner = 66,
                ZIndex = 42,
                Size = UDim2.fromOffset(132, 132),
                Position = UDim2.new(0.5, 0, 0, 12),
                AnchorPoint = Vector2.new(0.5, 0),
                Color = Colors.White
            })

            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "Face"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Size = UDim2.fromOffset(128, 128)
            ImageLabel.Position = UDim2.new(0.5, 0, 0, 14)
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
            ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(v343.UserId) .. "&w=150&h=150"
            ImageLabel.ZIndex = 43
            ImageLabel.Parent = v344
            UIKit.corner(ImageLabel, 64)
            UIKit.text(v344, {
                Name = "Name",
                TextSize = 26,
                Stroke = 4,
                ZIndex = 43,
                Text = v343.DisplayName,
                Size = UDim2.new(1, -12, 0, 30),
                Position = UDim2.fromOffset(6, 150)
            })
            UIKit.text(v344, {
                Name = "User",
                TextSize = 18,
                Stroke = 3,
                ZIndex = 43,
                Text = "@" .. v343.Name,
                Size = UDim2.new(1, -12, 0, 22),
                Position = UDim2.fromOffset(6, 180),
                Color = fromRGB(220, 235, 255)
            })

            local v345 = UIKit.frame(v344, {
                Name = "Pick",
                Corner = 12,
                Stroke = 4,
                ZIndex = 43,
                Size = UDim2.new(1, -24, 0, 46),
                Position = UDim2.new(0.5, 0, 1, -12),
                AnchorPoint = Vector2.new(0.5, 1),
                Color = fromRGB(150, 250, 70),
                Color2 = fromRGB(40, 190, 30)
            })

            UIKit.text(v345, {
                Name = "Label",
                Text = "GIFT",
                TextSize = 28,
                Stroke = 4,
                ZIndex = 44
            })
            UIKit.bindPress(v344, function() -- line: 1231
                -- upvalues: v340 (copy), v343 (copy), setGiftTarget (copy)
                v340:Destroy()
                setGiftTarget(v343)
            end)
        end
    end

    UIKit.pop(v340, 0.7)
end

local function showGiftOverlay(p107, p108, p109) -- line: 1241
    -- upvalues: RunService (copy), UIKit (copy), Colors (copy), fromRGB (copy), Left (copy), v2 (copy), v4 (ref), n3 (ref)
    n3 += 1

    local v346 = n3

    v4:ClearAllChildren()
    v4.Visible = true
    v4.BackgroundTransparency = 1
    UIKit.tween(v4, 0.2, {
        BackgroundTransparency = 0.35
    })

    local v347 = UIKit.frame(v4, {
        Name = "Stage",
        Transparency = 1,
        Size = UDim2.fromScale(0.25, 0.25),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v2
    })
    local v348 = UIKit.image(v347, "Rays", {
        Transparency = 0.55,
        Size = UDim2.fromOffset(1500, 1500),
        Position = UDim2.fromScale(0.5, 0.44),
        AnchorPoint = v2,
        Color = fromRGB(255, 180, 230)
    })

    UIKit.image(v347, "Glow", {
        Transparency = 0.4,
        Size = UDim2.fromOffset(900, 900),
        Position = UDim2.fromScale(0.5, 0.44),
        AnchorPoint = v2,
        Color = fromRGB(255, 220, 240)
    })

    local v349 = UIKit.image(v347, "Gift", {
        ZIndex = 3,
        Rotation = -6,
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.44),
        AnchorPoint = v2
    })

    UIKit.pop(v349, 0.4)

    local v350 = UIKit.text(v347, {
        Name = "Title",
        Text = "YOU GOT A GIFT!",
        TextSize = 100,
        Stroke = 9,
        ZIndex = 4,
        Size = UDim2.fromOffset(1400, 110),
        Position = UDim2.new(0.5, 0, 0.44, -300),
        AnchorPoint = Vector2.new(0.5, 0),
        StrokeColor = fromRGB(110, 30, 70)
    })

    UIKit.gradient(v350, fromRGB(255, 245, 130), fromRGB(255, 140, 200))
    UIKit.pop(v350, 1.6)

    local v351 = UIKit.frame(v347, {
        Name = "From",
        Transparency = 1,
        ZIndex = 4,
        Size = UDim2.fromOffset(620, 70),
        Position = UDim2.new(0.5, 0, 0.44, 160),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    if p108 then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Face"
        ImageLabel.BackgroundColor3 = Colors.White
        ImageLabel.Size = UDim2.fromOffset(66, 66)
        ImageLabel.Position = UDim2.new(0, 0, 0.5, 0)
        ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
        ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p108) .. "&w=150&h=150"
        ImageLabel.ZIndex = 5
        ImageLabel.Parent = v351
        UIKit.corner(ImageLabel, 33)
        UIKit.stroke(ImageLabel, 4)
    end

    UIKit.text(v351, {
        Name = "Label",
        TextSize = 44,
        Stroke = 5,
        ZIndex = 5,
        Text = "from " .. p107,
        Size = UDim2.new(1, p108 and -80 or 0, 1, 0),
        Position = UDim2.fromOffset(p108 and 80 or 0, 0),
        XAlign = if p108 then Left else Enum.TextXAlignment.Center
    })
    UIKit.text(v347, {
        Name = "What",
        TextSize = 56,
        Stroke = 6,
        ZIndex = 4,
        Text = p109,
        Size = UDim2.fromOffset(1400, 64),
        Position = UDim2.new(0.5, 0, 0.44, 238),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Gold
    })
    UIKit.text(v347, {
        Name = "Hint",
        Text = "Say thanks in the chat!",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.fromOffset(1400, 40),
        Position = UDim2.new(0.5, 0, 0.44, 312),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    local t76 = {
        fromRGB(255, 90, 90),
        fromRGB(90, 200, 255),
        fromRGB(255, 220, 70),
        fromRGB(130, 240, 90),
        fromRGB(240, 110, 230),
        fromRGB(255, 255, 255)
    }
    local v352 = Random.new()

    for i = 1, 46 do
        local v353 = if i % 2 == 0 then 0.12 else 0.88
        local v354 = UIKit.frame(v347, {
            Name = "Confetti",
            Size = UDim2.fromOffset(v352:NextInteger(10, 18), v352:NextInteger(8, 14)),
            Position = UDim2.new(v353, v352:NextInteger(-60, 60), 0.72, v352:NextInteger(-40, 40)),
            Color = t76[v352:NextInteger(1, #t76)]
        })

        v354.Rotation = v352:NextInteger(0, 360)

        local v355 = (if v353 < 0.5 then 1 else -1) * v352:NextInteger(-80, 380)

        UIKit.tween(v354, 0.45, {
            Position = v354.Position + UDim2.fromOffset(v355 * 0.5, -v352:NextInteger(260, 560)),
            Rotation = v354.Rotation + v352:NextInteger(-200, 200)
        }).Completed:Once(function() -- line: 1282
            -- upvalues: v352 (copy), v354 (copy), v355 (copy), UIKit (copy)
            if v354.Parent then
                UIKit.tween(v354, v352:NextNumber(0.9, 1.6), {
                    BackgroundTransparency = 1,
                    Position = v354.Position + UDim2.fromOffset(v355 * 0.5, v352:NextInteger(500, 900)),
                    Rotation = v354.Rotation + v352:NextInteger(-300, 300)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            end
        end)
    end

    UIKit.sound("RevealGood")

    local elapsed = os.clock()

    local function close() -- line: 1290
        -- upvalues: v346 (copy), elapsed (ref), v4 (ref), n3 (ref)
        if v346 ~= n3 or not v4.Visible or not (os.clock() - elapsed > 0.7) then
            return
        end

        n3 += 1
        v4.Visible = false
        v4:ClearAllChildren()
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 20
    TextButton.Parent = v4
    TextButton.Activated:Connect(close)
    task.spawn(function() -- line: 1305
        -- upvalues: v346 (copy), v348 (copy), elapsed (ref), RunService (copy), v4 (ref), n3 (ref)
        while v346 == n3 and v4.Visible do
            v348.Rotation = (os.clock() - elapsed) * 20

            if os.clock() - elapsed > 7 then
                elapsed = 0

                if v346 == n3 and v4.Visible and os.clock() - elapsed > 0.7 then
                    n3 += 1
                    v4.Visible = false
                    v4:ClearAllChildren()
                end
            end

            RunService.RenderStepped:Wait()
        end
    end)
end

t1.ShowGiftOverlay = showGiftOverlay

function t1.Init() -- line: 1319
    -- upvalues: Players (copy), RunService (copy), Remotes (copy), Products (copy), Fish (copy), Variants (copy), Sizes (copy), Roll (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), Toasts (copy), PackCards (copy), VipCard (copy), FishIcons (copy), t1 (copy), LocalPlayer (copy), Colors (copy), fromRGB (copy), Left (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref), t3 (copy), t5 (copy), Shop (ref), ScrollingFrame (ref), t6 (copy), onScreen (copy), gleam (copy), glowBehind (copy), bob (copy), sway (copy), hoverLift (copy), wrapSections (copy), resetEntrances (copy), revealStep (copy), t21 (copy), robuxButton (copy), showOverlay (copy), n4 (ref), nextOrder (copy), divider (copy), sparkleBack (copy), crateBanner (copy), refreshBest (copy), luckyOddsPanel (copy), packRow (copy), t58 (copy), potionRow (copy), refreshCash (copy), serverLuckSection (copy), v324 (ref), v325 (ref), ImageLabel (ref), UIListLayout (ref), t72 (copy), giftPanel (copy), showGiftOverlay (copy)
    local Shop2 = UIKit.Windows.Shop
    local Content = Shop2.Content
    local UIGradient = Shop2.Header:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Color = ColorSequence.new(fromRGB(255, 140, 30), fromRGB(255, 214, 60))
        UIGradient.Rotation = 0
    end

    local v356 = UIKit.button(Shop2.Frame, {
        Name = "Gift",
        Text = "    GIFT!",
        Corner = 12,
        Stroke = 5,
        ZIndex = 13,
        Size = UDim2.fromOffset(176, 54),
        Position = UDim2.new(1, -80, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(70, 180, 255),
        Color2 = fromRGB(40, 105, 235),
        OnClick = function() -- OnClick | line: 1329
            -- upvalues: Shop2 (copy), giftPanel (copy)
            giftPanel(Shop2)
        end
    })
    local v357 = UIKit.image(Shop2.Frame, "Gift", {
        ZIndex = 15,
        Rotation = -8,
        Size = UDim2.fromOffset(78, 78),
        Position = UDim2.new(1, -246, 0, 36),
        AnchorPoint = v2
    })

    Shop = Shop2

    local v358 = {
        Corner = 12,
        ZIndex = 13,
        Period = 3.4,
        Strength = 0.55
    } or {}

    v358.Manual = true

    local v359

    v358, v359 = UIKit.gleam(v356, v358)
    table.insert(t6, {
        seen = false,
        gui = v356,
        step = v359
    })
    table.insert(t6, {
        seen = false,
        gui = v357,
        step = function(p110) -- line: 1336
            -- upvalues: v357 (copy)
            local v361 = p110 % 3.2

            v357.Rotation = -8 + (if v361 < 0.5 then math.sin(v361 * 40) * 10 * (1 - v361 / 0.5) else 0)
        end
    })

    local v365

    if UIGradient then
        v365 = {
            seen = false,
            gui = Shop2.Header,
            step = function(p111) -- line: 1342
                -- upvalues: UIGradient (copy)
                UIGradient.Offset = Vector2.new(math.sin(p111 * 0.9) * 0.22, 0)
            end
        }
        table.insert(t6, v365)
    end

    local ScrollingFrame2 = Instance.new("ScrollingFrame")

    ScrollingFrame2.Name = "Sections"
    ScrollingFrame2.BackgroundTransparency = 1
    ScrollingFrame2.BorderSizePixel = 0
    ScrollingFrame2.Size = UDim2.fromScale(1, 1)
    ScrollingFrame2.ScrollBarThickness = 10
    ScrollingFrame2.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame2.CanvasSize = UDim2.new()
    ScrollingFrame2.ZIndex = 11
    ScrollingFrame2.Parent = Content
    ScrollingFrame = ScrollingFrame2

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0, 10)
    UIListLayout2.Parent = ScrollingFrame2
    UIListLayout2 = Instance.new("UIPadding")
    UIListLayout2.PaddingLeft = UDim.new(0, 6)
    UIListLayout2.PaddingTop = UDim.new(0, 4)
    UIListLayout2.PaddingBottom = UDim.new(0, 12)
    UIListLayout2.Parent = ScrollingFrame2
    UIListLayout = UIListLayout2
    v324 = UIKit.frame(Content, {
        Name = "GiftBanner",
        GradientRotation = 0,
        Corner = 16,
        Stroke = 5,
        ZIndex = 30,
        Size = UDim2.new(1, -28, 0, 72),
        Position = UDim2.new(0.5, 0, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(255, 110, 190),
        Color2 = fromRGB(200, 50, 160)
    })
    UIKit.image(v324, "Gift", {
        ZIndex = 32,
        Rotation = -8,
        Size = UDim2.fromOffset(70, 70),
        Position = UDim2.new(0, 40, 0.5, 0),
        AnchorPoint = v2
    })
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Face"
    v358 = ImageLabel
    v358.BackgroundColor3 = Colors.White
    v358 = ImageLabel
    v358.Size = UDim2.fromOffset(54, 54)
    v358 = ImageLabel
    v358.Position = UDim2.new(0, 84, 0.5, 0)
    v358 = ImageLabel
    v358.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.ZIndex = 32
    ImageLabel.Parent = v324
    UIKit.corner(ImageLabel, 27)
    UIKit.stroke(ImageLabel, 3)
    v325 = UIKit.text(v324, {
        Name = "Title",
        Text = "",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 31,
        Size = UDim2.new(1, -330, 0, 36),
        Position = UDim2.fromOffset(150, 4),
        XAlign = Left
    })
    UIKit.text(v324, {
        Name = "Text",
        Text = "Everything you buy now goes to them",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 31,
        Size = UDim2.new(1, -330, 0, 24),
        Position = UDim2.fromOffset(150, 40),
        XAlign = Left,
        Color = fromRGB(255, 235, 250)
    })
    UIKit.button(v324, {
        Name = "Cancel",
        Text = "CANCEL",
        Corner = 12,
        Stroke = 4,
        ZIndex = 32,
        Size = UDim2.fromOffset(150, 50),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 1386
            -- upvalues: t21 (copy), v324 (ref), UIListLayout (ref), t72 (copy)
            t21[1] = nil

            if v324 then
                v324.Visible = false
            end

            if UIListLayout then
                UIListLayout.PaddingTop = UDim.new(0, 4)
            end

            for _, v367 in ipairs(t72) do
                v367()
            end
        end
    })
    v358 = v324
    v358.Visible = false
    Players.PlayerRemoving:Connect(function(p112) -- line: 1390
        -- upvalues: Toasts (copy), t21 (copy), v324 (ref), UIListLayout (ref), t72 (copy)
        if p112 ~= t21[1] then
            return
        end

        t21[1] = nil

        if v324 then
            v324.Visible = false
        end

        if UIListLayout then
            UIListLayout.PaddingTop = UDim.new(0, 4)
        end

        for _, v368 in ipairs(t72) do
            v368()
        end

        Toasts.Show("info", p112.DisplayName .. " left the server")
    end)
    task.spawn(function() -- line: 1396
        -- upvalues: Remotes (copy), showGiftOverlay (copy)
        Remotes:WaitForChild("GiftReceived").OnClientEvent:Connect(function(p113) -- line: 1397
            -- upvalues: showGiftOverlay (copy)
            if type(p113) ~= "table" then
                return
            end

            if type(p113.text) == "string" then
                showGiftOverlay(tostring(p113.from or "Someone"), tonumber(p113.fromId), p113.text)
            end
        end)
    end)
    table.insert(t3, (divider(ScrollingFrame2, "FEATURED")))
    UIListLayout2 = require(script.Parent.TierLadderUI).Shared:ShopCard(ScrollingFrame2, 1026)
    n4 += 1
    UIListLayout2.LayoutOrder = n4

    local GoldenHarvest = Products.CrateByKey("GoldenHarvest")
    local v371

    if GoldenHarvest and GoldenHarvest.inShop ~= false and Products.OnSale(GoldenHarvest, workspace:GetServerTimeNow()) then
        local v372 = crateBanner(ScrollingFrame2, Shop2, GoldenHarvest, {
            rotation = 60,
            art = "GoldenHarvest",
            spin = 22,
            zoom = 0.86,
            top = fromRGB(255, 176, 60),
            bottom = fromRGB(186, 64, 28),
            tint = fromRGB(255, 232, 150),
            titleColor = {
                fromRGB(255, 250, 190),
                fromRGB(255, 204, 60)
            },
            titleStroke = fromRGB(110, 44, 10),
            tagColors = {
                fromRGB(255, 96, 60),
                fromRGB(200, 36, 40)
            },
            tile = {
                fromRGB(128, 62, 22),
                fromRGB(70, 30, 12)
            }
        })

        v358 = UIKit.frame(v372, {
            Name = "Countdown",
            Transparency = 0.15,
            Corner = 12,
            Stroke = 4,
            ZIndex = 18,
            Size = UDim2.fromOffset(250, 42),
            Position = UDim2.fromOffset(18, 14),
            Color = fromRGB(40, 18, 8)
        })

        local v373 = UIKit.text(v358, {
            Name = "Label",
            Text = "",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 19,
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            Color = fromRGB(255, 226, 120)
        })

        local function tick() -- line: 1416
            -- upvalues: GoldenHarvest (copy), v372 (copy), v373 (copy), Products (copy)
            local v374 = Products.SecondsLeft(GoldenHarvest, workspace:GetServerTimeNow()) or 0

            if v374 <= 0 then
                v372:SetAttribute("Ended", true)
                v372.Visible = false

                return false
            end

            local v375 = math.floor(v374)

            v373.Text = string.format("Leaves In: %dd:%02dh:%02dm:%02ds", v375 // 86400, v375 % 86400 // 3600, v375 % 3600 // 60, v375 % 60)

            return true
        end

        tick()
        task.spawn(function() -- line: 1428
            -- upvalues: v372 (copy), tick (copy)
            while v372.Parent and tick() do
                task.wait(1)
            end
        end)

        local v376 = UIKit.scaleOf(v358)
        local v377 = math.random() * 6
        local n29 = 0.04
        local n30 = 2.2

        v371 = {
            seen = false,
            gui = v358,
            step = function(p114) -- line: 131
                -- upvalues: v376 (copy), v377 (copy), n29 (copy), n30 (copy)
                v376.Scale = 1 + n29 * (math.sin(p114 * n30 + v377) * 0.5 + 0.5)
            end
        }
        table.insert(t6, v371)
    end

    crateBanner(ScrollingFrame2, Shop2, Products.Crates[1], {
        rotation = 60,
        art = "SpiritLantern",
        spin = 22,
        zoom = 0.84,
        top = fromRGB(96, 60, 200),
        bottom = fromRGB(196, 52, 120),
        tint = fromRGB(255, 220, 160),
        titleColor = {
            fromRGB(255, 246, 130),
            fromRGB(255, 190, 50)
        },
        titleStroke = fromRGB(110, 40, 20),
        tagColors = {
            fromRGB(80, 230, 255),
            fromRGB(90, 240, 130)
        },
        tile = {
            fromRGB(70, 40, 130),
            fromRGB(34, 20, 70)
        }
    })
    v359 = crateBanner(ScrollingFrame2, Shop2, Products.Crates[2], {
        rotation = 0,
        art = "RainbowCrate",
        zoom = 1.02,
        dir = Vector3.new(0.62, 0.5, -1),
        top = Colors.White,
        bottom = Colors.White,
        tint = Colors.White,
        titleColor = {
            Colors.White,
            fromRGB(255, 240, 200)
        },
        titleStroke = fromRGB(60, 30, 90),
        tagColors = {
            fromRGB(50, 44, 80),
            fromRGB(24, 22, 44)
        },
        tile = {
            fromRGB(255, 255, 255),
            fromRGB(214, 226, 255)
        }
    }):FindFirstChildOfClass("UIGradient")
    v359.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, fromRGB(255, 96, 110)),
        ColorSequenceKeypoint.new(0.25, fromRGB(255, 196, 70)),
        ColorSequenceKeypoint.new(0.5, fromRGB(96, 220, 120)),
        ColorSequenceKeypoint.new(0.75, fromRGB(80, 170, 255)),
        ColorSequenceKeypoint.new(1, fromRGB(214, 96, 240))
    })
    v359.Rotation = 20
    VipCard.Build({
        Width = 1026,
        Scroll = ScrollingFrame2,
        NextOrder = nextOrder,
        RobuxButton = robuxButton,
        Gleam = gleam,
        GlowBehind = glowBehind,
        Bob = bob,
        Sway = sway,
        SparkleBack = sparkleBack,
        Refreshers = t72,
        Gifting = function() -- Gifting | line: 1460
            -- upvalues: t21 (copy)
            return t21[1] ~= nil
        end,
        GiftTarget = function() -- GiftTarget | line: 1463
            -- upvalues: t21 (copy)
            return t21[1]
        end
    })
    table.insert(t3, (divider(ScrollingFrame2, "Lucky Casts")))

    local v379 = Products.LuckyPacks
    local v380 = fromRGB(170, 110, 255)

    table.insert(t3, (packRow(ScrollingFrame2, v379, v380, fromRGB(96, 50, 200), fromRGB(240, 220, 255), function(p115) -- line: 1471
        return "Clover", "+" .. p115.casts .. " Lucky Casts"
    end, function(p116) -- line: 1473
        -- upvalues: Shop2 (copy), UIKit (copy), fromRGB (copy), luckyOddsPanel (copy)
        UIKit.button(p116, {
            Name = "Odds",
            Text = "ODDS",
            Corner = 9,
            Stroke = 4,
            ZIndex = 28,
            Size = UDim2.fromOffset(88, 34),
            Position = UDim2.new(1, -8, 0, 32),
            AnchorPoint = Vector2.new(1, 0),
            Color = fromRGB(44, 40, 70),
            Color2 = fromRGB(22, 20, 40),
            OnClick = function() -- OnClick | line: 1474
                -- upvalues: Shop2 (copy), luckyOddsPanel (copy)
                luckyOddsPanel(Shop2)
            end
        })
    end)))
    PackCards.Build({
        Width = 1026,
        Scroll = ScrollingFrame2,
        NextOrder = nextOrder,
        RobuxButton = robuxButton,
        Gleam = gleam,
        GlowBehind = glowBehind,
        Bob = bob,
        Sway = sway,
        SparkleBack = sparkleBack,
        Rainbow = function(p117) -- Rainbow | line: 1489
            -- upvalues: t5 (copy)
            table.insert(t5, p117)
        end
    })
    serverLuckSection(ScrollingFrame2)
    divider(ScrollingFrame2, "Packs")
    packRow(ScrollingFrame2, Products.CashPacks, fromRGB(110, 235, 100), fromRGB(24, 150, 60), fromRGB(220, 255, 200), function(p118) -- line: 1499
        -- upvalues: NumberFormat (copy)
        return "Cash", "+" .. NumberFormat.money(p118.min)
    end)
    packRow(ScrollingFrame2, Products.PowerPacks, fromRGB(90, 170, 255), fromRGB(50, 80, 220), fromRGB(210, 230, 255), function(p119) -- line: 1502
        return "Power", "+" .. p119.power .. " Power"
    end)
    divider(ScrollingFrame2, "Potions")
    potionRow(ScrollingFrame2)
    divider(ScrollingFrame2, "Gamepasses")

    local v383 = {}

    for _, v384 in ipairs(Products.Gamepasses) do
        if not v384.featured then
            table.insert(v383, v384)
        end
    end

    local v364 = math.ceil(#v383 / 2)

    v364 = UIKit.frame(ScrollingFrame2, {
        Name = "Passes",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, v364 * 246 - 6)
    })
    n4 += 1
    v364.LayoutOrder = n4
    v358 = {
        DoubleCash = {
            fromRGB(70, 180, 255),
            fromRGB(40, 90, 225)
        },
        DoubleTraining = {
            fromRGB(176, 110, 255),
            fromRGB(96, 50, 200)
        },
        SkipCutscene = {
            fromRGB(255, 150, 70),
            fromRGB(225, 70, 50)
        },
        DoubleLuck = {
            fromRGB(110, 225, 90),
            fromRGB(28, 145, 70)
        },
        AutoCast = {
            fromRGB(60, 215, 230),
            fromRGB(30, 110, 200)
        },
        VIP = {
            fromRGB(255, 215, 70),
            fromRGB(230, 130, 20)
        },
        OfflinePro = {
            fromRGB(110, 120, 240),
            fromRGB(50, 50, 160)
        }
    }
    v365 = {
        DoubleCash = "Cash",
        DoubleTraining = "Power",
        DoubleLuck = "Clover"
    }

    local v360 = {
        VIP = "rbxassetid://125732863205647",
        OfflinePro = "rbxassetid://74427769899201"
    }

    local function autoArt(p120) -- line: 1533
        -- upvalues: UIKit (copy), Colors (copy), t6 (copy)
        local v385 = UIKit.frame(p120, {
            Name = "AutoArt",
            Transparency = 1,
            ZIndex = 14,
            Size = UDim2.fromOffset(150, 150),
            Position = UDim2.fromOffset(23, 63)
        })
        local v386 = UIKit.frame(v385, {
            Name = "Ring",
            Transparency = 1,
            ZIndex = 14,
            Size = UDim2.fromOffset(104, 104),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })

        UIKit.corner(v386, 52)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 24
        UIStroke.Color = Colors.Outline
        UIStroke.Parent = v386

        local v387 = UIKit.frame(v386, {
            Name = "Inner",
            Transparency = 1,
            ZIndex = 15,
            Size = UDim2.fromScale(1, 1)
        })

        UIKit.corner(v387, 52)

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Thickness = 14
        UIStroke2.Color = Colors.White
        UIStroke2.Parent = v387

        for _, v388 in ipairs({ UIStroke, UIStroke2 }) do
            local UIGradient = Instance.new("UIGradient")

            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.64, 0),
                NumberSequenceKeypoint.new(0.65, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = v388
        end

        UIKit.frame(v386, {
            Name = "Head",
            Stroke = 5,
            ZIndex = 16,
            Size = UDim2.fromOffset(34, 34),
            Position = UDim2.new(1, 0, 0.5, -10),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Colors.White
        }).Rotation = 45
        UIKit.text(v385, {
            Name = "Word",
            Text = "AUTO",
            TextSize = 34,
            Stroke = 5,
            ZIndex = 17,
            Size = UDim2.fromOffset(150, 40),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = Colors.Gold
        })
        table.insert(t6, {
            seen = false,
            gui = v386,
            step = function(p121) -- line: 1555
                -- upvalues: v386 (copy)
                v386.Rotation = p121 * 110 % 360
            end
        })

        return v385
    end

    local v390, fromOffset, v391, v392, v393, v394

    for v395, v396 in ipairs(v383) do
        v394 = v358[v396.key] or v358.DoubleCash
        v392 = UIKit.frame
        v390 = {
            Corner = 18,
            Stroke = 5,
            ZIndex = 12,
            Name = v396.key,
            Size = UDim2.fromOffset(506, 232)
        }
        fromOffset = UDim2.fromOffset
        v391 = if v395 == #v383 and v395 % 2 == 1 then 260 else (v395 - 1) % 2 * 520
        v390.Position = fromOffset(v391, math.floor((v395 - 1) / 2) * 246)
        v390.Color = v394[1]
        v390.Color2 = v394[2]
        v392 = v392(v364, v390)
        sparkleBack(v392, 18, Vector2.new(98, 138), 330, Colors.White, {
            { 190, 70, 20 },
            {
                470, 40, 26,
                fromRGB(255, 240, 150)
            },
            { 26, 60, 18 }
        })
        UIKit.text(v392, {
            Name = "Title",
            TextSize = 40,
            Stroke = 5,
            ZIndex = 14,
            Text = v396.name,
            Size = UDim2.new(1, -30, 0, 46),
            Position = UDim2.fromOffset(18, 10),
            XAlign = Left
        })
        UIKit.frame(v392, {
            Name = "Disc",
            Transparency = 0.72,
            Corner = 78,
            ZIndex = 13,
            Size = UDim2.fromOffset(156, 156),
            Position = UDim2.fromOffset(20, 60),
            Color = Colors.White
        })
        v393 = if v360[v396.key] then UIKit.image(v392, v360[v396.key], {
            ZIndex = 14,
            Rotation = -4,
            Size = UDim2.fromOffset(172, 172),
            Position = UDim2.fromOffset(90, 124),
            AnchorPoint = v2
        })
            elseif v365[v396.key] then UIKit.icon(v392, v365[v396.key], {
                ZIndex = 14,
                Rotation = -6,
                Size = UDim2.fromOffset(150, 150),
                Position = UDim2.fromOffset(23, 63)
            })
            elseif v396.key == "AutoCast" then autoArt(v392)
            else UIKit.text(v392, {
                Name = "Symbol",
                TextSize = 96,
                Stroke = 7,
                ZIndex = 14,
                Text = v396.symbol or "",
                Size = UDim2.fromOffset(150, 150),
                Position = UDim2.fromOffset(23, 56),
                Color = Colors.Gold
            })

        if typeof(v393) == "Instance" and v393:IsA("GuiObject") then
            fromOffset = v395 * 1.4

            local Position = v393.Position
            local v398 = fromOffset or math.random() * 6
            local v399 = v393
            local n31 = 1.9
            local n32 = 5

            table.insert(t6, {
                seen = false,
                gui = v393,
                step = function(p122) -- line: 113
                    -- upvalues: Position (copy), v399 (copy), n31 (copy), v398 (copy), n32 (copy)
                    v399.Position = Position + UDim2.fromOffset(0, math.sin(p122 * n31 + v398) * n32)
                end
            })

            local Rotation = v393.Rotation
            local v401 = v395 or math.random() * 6
            local n33 = 1.3
            local n34 = 5

            table.insert(t6, {
                seen = false,
                gui = v393,
                step = function(p123) -- line: 122
                    -- upvalues: v399 (copy), Rotation (copy), n33 (copy), v401 (copy), n34 (copy)
                    v399.Rotation = Rotation + math.sin(p123 * n33 + v401) * n34
                end
            })
        end

        fromOffset = {
            Corner = 18,
            ZIndex = 13,
            Period = 5,
            Sweep = 1.1,
            Strength = 0.2,
            Width = 0.15,
            Phase = v395 * 1.6
        } or {}
        fromOffset.Manual = true
        fromOffset, v391 = UIKit.gleam(v392, fromOffset)
        table.insert(t6, {
            seen = false,
            gui = v392,
            step = v391
        })
        hoverLift(v392, 1.025)
        v393 = UIKit.frame
        fromOffset = {
            Name = "x2",
            Corner = 19,
            Stroke = 4,
            ZIndex = 15
        }
        fromOffset.Size = UDim2.fromOffset(v396.badge and 96 or 70, 38)
        fromOffset.Position = UDim2.fromOffset(v396.badge and 100 or 126, 184)
        fromOffset.Color = fromRGB(30, 34, 50)
        v393 = v393(v392, fromOffset)
        v390 = UIKit.text
        v391 = {
            Name = "Label",
            TextSize = 27,
            Stroke = 3,
            ZIndex = 16
        }
        v391.Text = v396.badge or "x2"
        v391.Color = Colors.Gold
        v390(v393, v391)
        UIKit.text(v392, {
            Name = "Text",
            TextSize = 31,
            Stroke = 4,
            ZIndex = 14,
            Text = v396.text,
            Size = UDim2.new(1, -216, 0, 110),
            Position = UDim2.fromOffset(202, 52)
        }).TextWrapped = true

        local v403, v404 = robuxButton(v392, v396, UDim2.new(1, -226, 0, 58), UDim2.new(1, -14, 1, -12), Vector2.new(1, 1), true)
        local v405 = nil

        local function refreshOwned() -- line: 1588
            -- upvalues: v396 (copy), v403 (copy), v404 (copy), v405 (ref), UIKit (copy), LocalPlayer (copy), Colors (copy), fromRGB (copy), v1 (copy), t21 (copy)
            if t21[1] then
                v405 = v405 or v404.Text

                local v406 = t21[1]:GetAttribute("Owns" .. v396.key) == true

                if v406 then
                    v404.Text = "THEY HAVE IT"
                else
                    v404.Text = "GIFT  " .. v1 .. " " .. v396.robux
                end

                local setButtonColor = UIKit.setButtonColor
                local v408 = if v406 then Colors.GreyDark else fromRGB(150, 250, 70)
                local v407 = if v406 then fromRGB(64, 66, 80) else fromRGB(40, 190, 30)

                setButtonColor(v403, v408, v407)
                v403.Active = not v406
            else
                if v405 then
                    v404.Text = v405
                    v405 = nil
                    UIKit.setButtonColor(v403, fromRGB(150, 250, 70), fromRGB(40, 190, 30))
                    v403.Active = true
                end

                if LocalPlayer:GetAttribute("Owns" .. v396.key) then
                    v404.Text = "OWNED"
                    UIKit.setButtonColor(v403, Colors.GreyDark, fromRGB(64, 66, 80))
                    v403.Active = false
                end
            end
        end

        table.insert(t72, refreshOwned)
        LocalPlayer:GetAttributeChangedSignal("Owns" .. v396.key):Connect(refreshOwned)
        refreshOwned()
    end

    local v409 = t58.new(Shop2)

    divider(ScrollingFrame2, "Free Item")

    local FreeFish = Products.FreeFish

    v379 = UIKit.frame(ScrollingFrame2, {
        Name = "Free",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1026, 246)
    })
    n4 += 1
    v379.LayoutOrder = n4
    v379 = UIKit.frame(v379, {
        Name = "Card",
        Corner = 18,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.fromOffset(640, 236),
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(70, 180, 255),
        Color2 = fromRGB(40, 90, 225)
    })
    sparkleBack(v379, 18, Vector2.new(114, 114), 380, Colors.White, {
        { 232, 40, 22 },
        {
            600, 120, 26,
            fromRGB(255, 240, 150)
        },
        { 30, 206, 18 }
    })
    UIKit.frame(v379, {
        Name = "Disc",
        Transparency = 0.72,
        Corner = 98,
        ZIndex = 13,
        Size = UDim2.fromOffset(196, 196),
        Position = UDim2.fromOffset(16, 16),
        Color = Colors.White
    })

    local v410 = UIKit.frame(v379, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.fromOffset(186, 156),
        Position = UDim2.fromOffset(21, 36)
    })

    FishIcons.Picture(v410, FreeFish.fish, FreeFish.v, 1.15)

    local text = UIKit.frame(v379, {
        Name = "x1",
        Corner = 19,
        Stroke = 4,
        ZIndex = 15,
        Size = UDim2.fromOffset(70, 38),
        Position = UDim2.fromOffset(78, 190),
        Color = fromRGB(30, 34, 50)
    })

    UIKit.text(text, {
        Name = "Label",
        Text = "x1",
        TextSize = 27,
        Stroke = 3,
        ZIndex = 16
    })
    UIKit.text(v379, {
        Name = "Title",
        Text = "Free Fish!",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.fromOffset(390, 50),
        Position = UDim2.fromOffset(232, 12),
        XAlign = Left
    })
    text = UIKit.text

    local v381 = {
        Name = "Text",
        TextSize = 25,
        Stroke = 4,
        ZIndex = 14
    }

    v392 = FreeFish.fish
    v393 = FreeFish.v
    v390 = FreeFish.s
    v383 = Variants.List[v393] or Variants.List[1]
    v358 = Sizes.List[v390] or Sizes.List[Sizes.NORMAL_INDEX]
    fromOffset = if v383.index >= 2 then v383.id .. " " else ""

    if v358.index ~= Sizes.NORMAL_INDEX then
        fromOffset ..= v358.id .. " "
    end

    v381.Text = "Claim your free " .. (fromOffset .. Fish.ById[v392].name) .. "!"
    v381.Size = UDim2.fromOffset(396, 56)
    v381.Position = UDim2.fromOffset(232, 62)
    v381.XAlign = Left
    text(v379, v381).TextWrapped = true
    text = UIKit.text
    v381 = {
        Name = "Rate",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 14
    }
    v381.Text = NumberFormat.rate(Roll.income(FreeFish.fish, FreeFish.v, FreeFish.s))
    v381.Size = UDim2.fromOffset(360, 32)
    v381.Position = UDim2.fromOffset(232, 120)
    v381.XAlign = Left
    v381.Color = Colors.Cash
    v381.StrokeColor = Colors.CashStroke
    text(v379, v381)
    v381 = UIKit.button
    v371 = {
        Name = "Claim",
        Text = "CLAIM!",
        Corner = 12,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 14,
        Size = UDim2.fromOffset(390, 62),
        Position = UDim2.new(1, -16, 1, -14),
        AnchorPoint = Vector2.new(1, 1),
        Color = fromRGB(150, 250, 70),
        Color2 = fromRGB(40, 190, 30)
    }

    function v371.OnClick() -- line: 1633
        -- upvalues: FreeFish (copy), Remotes (copy), DataClient (copy), showOverlay (copy)
        if not DataClient.Get("FreeFishClaimed") then
            task.spawn(function() -- line: 1637
                -- upvalues: FreeFish (copy), Remotes (copy), showOverlay (copy)
                local function v411() -- line: 1638
                    -- upvalues: Remotes (copy)
                    return Remotes.ClaimFreeFish:InvokeServer()
                end

                local ok, result = pcall(v411)

                if ok and result then
                    showOverlay("FREE FISH!", {
                        {
                            fishId = FreeFish.fish,
                            variant = FreeFish.v,
                            size = FreeFish.s
                        }
                    }, "Tap the fish slot at the bottom, then tap your plot to place it!")
                end
            end)
        end
    end

    local v412, v413 = v381(v379, v371)

    v394 = {
        Corner = 12,
        ZIndex = 14,
        Period = 2.4,
        Strength = 0.65,
        When = function() -- canClaim | line: 1646
            -- upvalues: DataClient (copy)
            return not DataClient.Get("FreeFishClaimed")
        end
    } or {}
    v394.Manual = true
    v394, v392 = UIKit.gleam(v412, v394)
    table.insert(t6, {
        seen = false,
        gui = v412,
        step = v392
    })

    local v414 = glowBehind(v412, nil, 0.9)
    local Position = v410.Position
    local v415 = math.random() * 6
    local n35 = 1.8
    local n36 = 5

    v393 = function(p124) -- line: 113
        -- upvalues: v410 (copy), Position (copy), v415 (copy), n35 (copy), n36 (copy)
        v410.Position = Position + UDim2.fromOffset(0, math.sin(p124 * n35 + v415) * n36)
    end

    table.insert(t6, {
        seen = false,
        gui = v410,
        step = v393
    })
    hoverLift(v379, 1.025)
    DataClient.Observe("FreeFishClaimed", function(p125) -- line: 1653
        -- upvalues: v412 (copy), v413 (copy), v414 (copy), UIKit (copy), Colors (copy), fromRGB (copy)
        if p125 then
            v413.Text = "Claimed!"
            UIKit.setButtonColor(v412, Colors.GreyDark, fromRGB(64, 66, 80))
        end

        v414.Visible = not p125
    end)
    v371 = UIKit.button
    v394 = Shop2.Frame
    v392 = {
        Name = "Support",
        Corner = 12,
        Stroke = 5,
        ZIndex = 13,
        Text = utf8.char(9829) .. " SUPPORT",
        Size = UDim2.fromOffset(196, 54),
        Position = UDim2.new(1, -300, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(255, 110, 190),
        Color2 = fromRGB(210, 50, 150)
    }

    function v392.OnClick() -- line: 1663
        -- upvalues: v409 (copy)
        v409:Toggle()
    end

    v371 = v371(v394, v392)
    v392 = {
        Corner = 12,
        ZIndex = 13,
        Period = 3.4,
        Strength = 0.55,
        Phase = 1.7
    } or {}
    v392.Manual = true
    v392, v393 = UIKit.gleam(v371, v392)
    table.insert(t6, {
        seen = false,
        gui = v371,
        step = v393
    })
    t1.Support = v409

    t1.ScrollToDonate = function() -- line: 1668
        -- upvalues: Shop2 (copy)
        return (Shop2.Frame:FindFirstChild("Support"))
    end

    v3 = UIKit.screenGui("ShopOverlay", 25)
    v371 = v3
    v371.ScreenInsets = Enum.ScreenInsets.None
    v4 = UIKit.frame(v3, {
        Name = "Overlay",
        Transparency = 1,
        Size = UDim2.fromScale(4, 4),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v2,
        Color = fromRGB(0, 0, 0)
    })
    v4.Visible = false
    Remotes.CrateOpened.OnClientEvent:Connect(function(p126, p127) -- line: 1679
        -- upvalues: Roll (copy), showOverlay (copy)
        local showOverlay2, v417

        if type(p127) == "table" and #p127 ~= 0 then
            table.sort(p127, function(p128, p129) -- line: 1684
                -- upvalues: Roll (copy)
                return Roll.income(p128.fishId, p128.variant, p128.size, nil, p128.base) > Roll.income(p129.fishId, p129.variant, p129.size, nil, p129.base)
            end)
            showOverlay2 = showOverlay
            v417 = if p126 == "SpiritLantern" then "SPIRIT SUMMONED!" elseif p126 == "GoldenHarvest" then "HAPPY HARVEST!" else "YOU GOT!"
            showOverlay2(v417, p127, "Tap the fish slot at the bottom, then tap your plot to place it!")
        end
    end)

    local function refreshFeatured() -- line: 1691
        -- upvalues: LocalPlayer (copy), t3 (copy)
        local v418 = LocalPlayer:GetAttribute("CratesAllowed") == true

        for _, v419 in ipairs(t3) do
            v419.Visible = v418 and not v419:GetAttribute("Ended")
        end
    end

    LocalPlayer:GetAttributeChangedSignal("CratesAllowed"):Connect(refreshFeatured)
    refreshFeatured()
    wrapSections(ScrollingFrame2)

    Shop2.OnOpen = function() -- line: 1701
        -- upvalues: v409 (copy), Remotes (copy), resetEntrances (copy), t21 (copy), refreshBest (copy), refreshCash (copy), v324 (ref), UIListLayout (ref), t72 (copy)
        v409:Hide()
        t21[1] = nil

        if v324 then
            v324.Visible = false
        end

        if UIListLayout then
            UIListLayout.PaddingTop = UDim.new(0, 4)
        end

        for _, v420 in ipairs(t72) do
            v420()
        end

        local ShopFunnel = Remotes:FindFirstChild("ShopFunnel")

        if ShopFunnel then
            ShopFunnel:FireServer("open")
        end

        refreshCash()
        refreshBest()
        resetEntrances()
    end

    local n37 = 0

    RunService.RenderStepped:Connect(function() -- line: 251
        -- upvalues: n37 (ref), Shop (ref), ScrollingFrame (ref), t6 (copy), onScreen (copy), revealStep (copy)
        if Shop and Shop.IsOpen and ScrollingFrame then
            local elapsed = os.clock()

            if n37 <= elapsed then
                n37 = elapsed + 0.2

                local Y = ScrollingFrame.AbsolutePosition.Y
                local v421 = Y + ScrollingFrame.AbsoluteSize.Y

                for _, v422 in ipairs(t6) do
                    v422.seen = onScreen(v422.gui, Y, v421)
                end
            end

            for _, v423 in ipairs(t6) do
                if v423.seen then
                    v423.step(elapsed)
                end
            end

            revealStep()
        end
    end)

    function t1.OpenLuckyOdds() -- line: 1714
        -- upvalues: Shop2 (copy), luckyOddsPanel (copy)
        Shop2.Open()
        luckyOddsPanel(Shop2)
    end

    LocalPlayer:GetAttributeChangedSignal("IncomePerSecond"):Connect(refreshCash)
    DataClient.Observe("Backpack", refreshBest)
    DataClient.Observe("Placed", refreshBest)
    refreshCash()
    refreshBest()
    RunService.Heartbeat:Connect(function() -- line: 1725
        -- upvalues: Shop2 (copy), t5 (copy)
        if Shop2.IsOpen then
            local v424 = os.clock() * 0.35 % 1

            for _, v425 in ipairs(t5) do
                v425.Color = Color3.fromHSV(v424, 0.75, 1)
            end
        end
    end)
end

return t1

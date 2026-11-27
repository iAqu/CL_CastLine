-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TextChatService = game:GetService("TextChatService")
local CollectionService = game:GetService("CollectionService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TierLadder = require(Shared.Data.TierLadder)
local Products = require(Shared.Data.Products)
local Buffs = require(Shared.Data.Buffs)
local Baits = require(Shared.Data.Baits)
local Rods = require(Shared.Data.Rods)
local Rarities = require(Shared.Data.Rarities)
local Roll = require(Shared.Roll)
local Fish = require(Shared.Data.Fish)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local Toasts = require(script.Parent.Toasts)
local Windows = require(script.Parent.Windows)
local BuffHud = require(script.Parent.BuffHud)
local FishIcons = require(script.Parent.FishIcons)

require(Shared.FishModels)

local LocalPlayer = Players.LocalPlayer
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local v2 = fromRGB(255, 255, 255)
local v3 = utf8.char(57346)
local v4 = utf8.char(10003)
local v5 = utf8.char(10145)
local Left, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right
local Shown = TierLadder.Shown
local v6 = #TierLadder.Tiers
local v7 = (Shown - 1) * 224 + 96
local v8 = v7 + 18
local v10 = math.floor((1290 - (v8 + 30 + 216)) / 2)
local v11 = v10 + v8 + 30
local t1 = {
    fromRGB(255, 172, 52),
    fromRGB(214, 74, 30)
}
local t2 = {
    fromRGB(255, 252, 236),
    fromRGB(255, 202, 120)
}
local t3 = {
    fromRGB(255, 222, 70),
    fromRGB(236, 118, 14)
}
local t4 = {
    fromRGB(150, 242, 72),
    fromRGB(44, 178, 36)
}
local t5 = {
    fromRGB(210, 214, 226),
    fromRGB(148, 154, 172)
}
local v12 = fromRGB(120, 46, 10)
local v13 = fromRGB(255, 206, 50)
local t6 = {
    fromRGB(214, 150, 74),
    fromRGB(178, 112, 50),
    fromRGB(140, 82, 34)
}
local t7 = {
    fromRGB(255, 206, 70),
    fromRGB(255, 150, 40),
    fromRGB(230, 90, 40),
    fromRGB(196, 50, 50),
    fromRGB(255, 240, 170),
    fromRGB(150, 90, 40)
}

local function lowEnd() -- line: 81
    local function v14() -- line: 82
        return UserSettings().GameSettings.SavedQualityLevel.Value
    end

    local ok, result = pcall(v14)

    if ok then
        ok = result > 0 and result <= 4
    end

    return ok
end

local function glide(p1, p2, p3) -- line: 88
    -- upvalues: UIKit (copy)
    local v15 = p2.X.Offset - p1.Position.X.Offset
    local v16 = if v15 > 0 then 6 elseif v15 < 0 then -6 else 0
    local v17 = UIKit.tween(p1, p3 * 0.72, {
        Position = p2 + UDim2.fromOffset(v16, 0)
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    v17.Completed:Once(function(p4) -- line: 92
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), UIKit (copy)
        if p4 == Enum.PlaybackState.Completed and p1.Parent then
            UIKit.tween(p1, p3 * 0.38, {
                Position = p2
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        end
    end)

    return v17
end

local function fly(p5, p6, p7, p8, p9, p10, p11, p12) -- line: 100
    -- upvalues: RunService (copy)
    local v18 = (p7 + p8) / 2 - Vector2.new(0, p12)
    local elapsed = os.clock()
    local v19 = false
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 105
        -- upvalues: p5 (copy), p6 (copy), p7 (copy), p8 (copy), p9 (copy), p10 (copy), p11 (copy), v18 (copy), elapsed (copy), v19 (ref), connection (ref)
        local v21 = math.clamp((os.clock() - elapsed) / p11, 0, 1)
        local v22 = 1 - (1 - v21) ^ 3
        local v23 = 1 - v22
        local v24 = p7 * (v23 * v23) + v18 * (v23 * 2 * v22) + p8 * (v22 * v22)

        p5.Position = UDim2.fromOffset(v24.X, v24.Y)
        p5.Rotation = math.sin(v21 * 3.141592653589793) * (p8.X >= p7.X and 8 or -8)
        p6.Scale = p9 + (p10 - p9) * v22

        if not (v21 >= 1) then
            return
        end

        v19 = true
        connection:Disconnect()
    end)

    while not v19 do
        task.wait()
    end
end

local function chat(p13) -- line: 123
    -- upvalues: TextChatService (copy)
    local function v26() -- line: 124
        -- upvalues: p13 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local RBXGeneral = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if RBXGeneral then
            RBXGeneral:DisplaySystemMessage("<font color=\"#FFB347\"><b>[EVENT]</b></font> " .. p13)
        end
    end

    pcall(v26)
end

local function priceText(p14) -- line: 133
    -- upvalues: TierLadder (copy), v3 (copy)
    local v27 = TierLadder.Price(p14)

    return if v27 then v3 .. v27 else nil
end

local t8 = {}

t8.__index = t8

local t9 = {}

t9.__index = t9

function t9.new() -- line: 144
    -- upvalues: t9 (copy)
    local self = setmetatable({}, t9)

    self.Tiles = {}
    self.Queue = {}
    self.ShopCards = {}
    self.Celebrating = false
    self.Pending = nil
    self.Claiming = nil
    self.Claimed = 0
    self.Celebrations = 0
    self.Shown = -1
    self.First = nil
    self.WasLive = nil
    self.Greeted = false
    self.Started = false
    self.HoldTime = 1.7
    self.FishViews = {}

    return self
end

function t9.Progress(_) -- line: 164
    -- upvalues: TierLadder (copy), DataClient (copy)
    return TierLadder.Progress(DataClient.Get("Ladder"))
end

function t9.Allowed(_) -- line: 168
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("CratesAllowed") == true
end

function t9:Live() -- line: 172
    -- upvalues: TierLadder (copy)
    return TierLadder.Active() and self:Allowed()
end

function t9:Busy() -- line: 176
    local Celebrating = self.Celebrating

    if not Celebrating then
        Celebrating = self.Pending ~= nil or self.Claiming ~= nil
    end

    return Celebrating
end

function t9.RewardName(_, p20) -- line: 180
    -- upvalues: TierLadder (copy), Products (copy), Buffs (copy), Baits (copy), Rods (copy), Fish (copy), NumberFormat (copy), LocalPlayer (copy)
    if p20.kind == "cash" then
        return NumberFormat.money(TierLadder.Cash(p20, LocalPlayer:GetAttribute("IncomePerSecond") or 0)) .. " Cash"
    end

    if p20.kind == "lucky" then
        return p20.n .. " Lucky Cast" .. (if p20.n == 1 then "" else "s")
    end

    if p20.kind == "potion" then
        local v29 = p20.buff and Buffs.ById[p20.buff]
        local v30 = if v29 then v29.name else "Random Potion"
        local v31 = p20.n .. " " .. v30 .. (if p20.n > 1 then "s" else "")

        if p20.seconds then
            v31 ..= " (" .. math.floor(p20.seconds / 60) .. "m)"
        end

        return v31
    end

    if p20.kind == "bait" then
        local v33 = Baits.ById[p20.bait]

        if v33 then
            return v33.name
        end

        return p20.bait
    end

    if p20.kind == "rod" then
        local v34 = Rods.ById[p20.rod]

        if v34 then
            return v34.name
        end

        return p20.rod
    end

    if p20.kind == "egg" then
        local v35 = Products.CrateByKey(p20.key)
        local v36 = if v35 then v35.name else p20.key

        return p20.n .. " " .. v36 .. (if p20.n > 1 then "s" else "")
    end

    if p20.kind ~= "fish" then
        return ""
    end

    local v37 = Fish.ById[p20.fish]

    if v37 then
        return v37.name
    end

    return p20.fish
end

function t9.Count(_, p22) -- line: 210
    return not (p22.kind ~= "lucky" and p22.kind ~= "potion" and p22.kind ~= "egg") and p22.n or 1
end

function t9:Caption(p24) -- line: 217
    -- upvalues: Products (copy), Buffs (copy), Fish (copy)
    local v38 = if self:Count(p24) > 1 then "s" else ""

    if p24.kind == "lucky" then
        return "Lucky Cast" .. v38
    end

    if p24.kind == "potion" then
        local v39 = p24.buff and Buffs.ById[p24.buff]
        local v40 = (if v39 then v39.name else "Random Potion") .. v38

        if p24.seconds then
            v40 ..= " (" .. math.floor(p24.seconds / 60) .. "m)"
        end

        return v40
    end

    if p24.kind == "egg" then
        local v42 = Products.CrateByKey(p24.key)

        return (if v42 then v42.name else p24.key) .. v38
    end

    if p24.kind ~= "fish" then
        return self:RewardName(p24)
    end

    local v43 = Fish.ById[p24.fish]
    local v44 = if v43 then v43.name else p24.fish
    local _, v45 = Products.SpiritEntry(p24.fish)

    if v45 then
        return v44 .. "\n<font color=\"#D8620E\">" .. v45.pct .. "% best fish</font>"
    end

    return v44
end

function t9.Art(p25, p26, p27, p28, p29, p30) -- line: 244
    -- upvalues: ReplicatedStorage (copy), Buffs (copy), UIKit (copy), BuffHud (copy), Colors (copy), v1 (copy)
    local v46 = UIKit.frame(p26, {
        Name = "Art",
        Transparency = 1,
        Size = UDim2.fromOffset(p28, p28),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        ZIndex = p29
    })
    local v47 = p28 / 120

    if p27.kind == "cash" then
        local t11 = {
            { 0, 10, 0, 80 },
            { -34, 18, -14, 66 },
            { 34, 18, 14, 66 }
        }
        local v48 = if (p27.mins or 0) >= 10 then 3 else 1

        for i = v48, 1, -1 do
            local v49 = t11[i]

            UIKit.icon(v46, "Cash", {
                Size = UDim2.fromOffset(v49[4] * v47, v49[4] * v47),
                Position = UDim2.new(0.5, v49[1] * v47, 0.5, v49[2] * v47 - v47 * 8),
                AnchorPoint = v1,
                ZIndex = p29 + (v48 - i),
                Rotation = v49[3]
            })
        end
    elseif p27.kind == "lucky" then
        local v50 = math.clamp(p27.n, 1, 5)

        for i = 1, v50 do
            local v51 = i - (v50 + 1) / 2

            UIKit.clover(v46, (74 - math.abs(v51) * 8) * v47, {
                Position = UDim2.new(0.5, v51 * 26 * v47, 0.5, (math.abs(v51) * 7 + 2) * v47),
                AnchorPoint = v1,
                ZIndex = p29 + 4 - math.floor(math.abs(v51) * 2),
                Rotation = v51 * 14
            })
        end
    elseif p27.kind == "potion" then
        local v55 = p30 or (if p27.buff then table.create(math.min(p27.n, 3), p27.buff) elseif p27.n >= 2 then { "luck", "cash" } else { "luck" })

        if #v55 > 3 then
            v55 = {
                v55[1],
                v55[2],
                v55[3]
            }
        end

        local v56 = #v55

        for v57, v58 in v55 do
            local v59 = Buffs.ById[v58] or Buffs.List[1]
            local v60 = BuffHud.Bottle(v46, v59, (if v56 == 1 then 112 else 92) * v47, p29 + v57)

            v60.AnchorPoint = v1

            local v61 = v57 - (v56 + 1) / 2

            v60.Position = UDim2.new(0.5, v61 * 40 * v47, 0.5, math.abs(v61) * 6 * v47)
            v60.Rotation = v61 * 12
        end

        if not p30 and not p27.buff then
            UIKit.text(v46, {
                Name = "Mystery",
                Text = "?",
                Stroke = 5,
                TextSize = math.floor(v47 * 48),
                Size = UDim2.fromOffset(v47 * 50, v47 * 50),
                Position = UDim2.new(0.5, v47 * 34, 0.5, v47 * -30),
                AnchorPoint = v1,
                Color = Colors.Gold,
                ZIndex = p29 + 5
            })

            return v46
        end
    elseif p27.kind == "bait" or p27.kind == "rod" then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")

        Assets = Assets and Assets:FindFirstChild(if p27.kind == "bait" then "Baits" else "Rods")
        Assets = Assets and Assets:FindFirstChild(if p27.kind == "bait" then p27.bait else p27.rod)

        if Assets then
            UIKit.viewModel(v46, Assets, {
                ZIndex = p29 + 1,
                Zoom = p27.kind == "bait" and 0.98 or 0.66,
                Dir = if p27.kind == "bait" then Vector3.new(0.35, 0.15, -1) else Vector3.new(0.15, 0.1, -1)
            })

            return v46
        end
    else
        if p27.kind == "egg" then
            UIKit.eggPicture(v46, p27.key, {
                Size = UDim2.fromScale(1, 1),
                ZIndex = p29
            })

            return v46
        end

        if p27.kind == "fish" then
            p25:FishPicture(v46, p27.fish, p27.v, p29 + 1)
        end
    end

    return v46
end

function t9:RedrawFish() -- line: 292
    for v63 in pairs(self.FishViews) do
        local Model = v63:FindFirstChildOfClass("Model")

        if Model then
            Model.Parent = nil
            Model.Parent = v63
        end
    end
end

function t9:FishPicture(p33, p34, p35, p36) -- line: 302
    -- upvalues: FishIcons (copy)
    local v64 = FishIcons.Picture(p33, p34, p35 or 1, 1.05)

    v64.ZIndex = p36

    if v64:IsA("ViewportFrame") then
        self.FishViews[v64] = true
        v64.Destroying:Connect(function() -- line: 307
            -- upvalues: self (copy), v64 (copy)
            self.FishViews[v64] = nil
        end)
    end

    return v64
end

function t9.Basket(_, p38, p39) -- line: 314
    -- upvalues: UIKit (copy), fromRGB (copy), t6 (copy)
    local v65 = UIKit.frame(p38, {
        Name = "Cover",
        Corner = 16,
        Stroke = 3,
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.fromOffset(6, 6),
        Color = t6[3],
        Color2 = fromRGB(104, 58, 22),
        StrokeColor = fromRGB(96, 52, 20),
        ZIndex = p39
    })

    v65.ClipsDescendants = true

    for i = 0, 8 do
        local v66 = if i % 2 == 0 then 0 else -27.333333333333332

        for j = 0, 3 do
            UIKit.frame(v65, {
                Name = "Weave",
                Corner = 6,
                Size = UDim2.fromOffset(50.666666666666664, 20.666666666666668),
                Position = UDim2.fromOffset(v66 + j * 54.666666666666664 + 2, i * 24.666666666666668 + 4),
                Color = fromRGB(242, 190, 112),
                Color2 = t6[2],
                GradientRotation = (i + j) % 2 == 0 and 90 or 270,
                ZIndex = p39 + 1
            })
        end
    end

    UIKit.dress(v65, 16, fromRGB(255, 230, 180), p39 + 2)
    UIKit.text(v65, {
        Name = "MarkShadow",
        Text = "?",
        TextSize = 96,
        Stroke = 0,
        Rotation = -6,
        Position = UDim2.fromOffset(3, 5),
        Color = fromRGB(64, 32, 8),
        ZIndex = p39 + 3
    }).TextTransparency = 0.5

    local v67 = UIKit.text(v65, {
        Name = "Mark",
        Text = "?",
        TextSize = 96,
        Stroke = 6,
        Rotation = -6,
        StrokeColor = fromRGB(90, 46, 14),
        ZIndex = p39 + 4
    })

    UIKit.gradient(v67, fromRGB(255, 252, 238), fromRGB(255, 206, 110))

    return v65
end

function t8.new(p40, p41, p42) -- line: 337
    -- upvalues: TierLadder (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy), v2 (copy), v4 (copy), v5 (copy), Right (copy), t2 (copy), t3 (copy), t5 (copy), v12 (copy), v13 (copy), t8 (copy)
    local self = setmetatable({}, t8)

    self.Owner = p40
    self.Index = p41
    self.Tier = TierLadder.Tiers[p41]
    self.Covered = false
    self.State = ""

    local v69 = self.Tier.grand == true

    self.Grand = v69

    local v70 = if v69 then t3 else t2
    local v71 = UIKit.frame(p42 or p40.Track, {
        Transparency = 1,
        ZIndex = 12,
        Name = "Tier" .. p41,
        Size = UDim2.fromOffset(176, 306),
        AnchorPoint = v1
    })

    if v69 then
        local v72 = UIKit.image(v71, "Glow", {
            Transparency = 0,
            ZIndex = 11,
            Size = UDim2.fromOffset(352, 380.8),
            Position = UDim2.fromOffset(88, 119),
            AnchorPoint = v1,
            Color = fromRGB(255, 250, 200)
        })

        v72.ScaleType = Enum.ScaleType.Stretch
        self.Glow = v72
    end

    local v73 = UIKit.frame(v71, {
        Name = "Card",
        Corner = 22,
        ZIndex = 12,
        Size = if v69 then UDim2.fromOffset(188, 250) else UDim2.fromOffset(176, 238),
        Position = UDim2.fromOffset(88, 119),
        AnchorPoint = v1,
        Color = v70[1],
        Color2 = v70[2],
        Stroke = v69 and 7 or 5,
        StrokeColor = if v69 then fromRGB(120, 50, 0) else nil
    })

    UIKit.dress(v73, 22, if v69 then fromRGB(255, 250, 210) else v2, 12)

    if v69 then
        local v74 = UIKit.backdrop(v73, 22, 12)

        UIKit.rays(v74, {
            Transparency = 0.62,
            ZIndex = 12,
            Speed = 16,
            Size = UDim2.fromOffset(400, 400),
            Position = UDim2.fromOffset(94, 106),
            AnchorPoint = v1,
            Color = fromRGB(255, 250, 190)
        })

        local v75 = UIKit.frame(v73, {
            Name = "GoldRim",
            Transparency = 1,
            Corner = 18,
            ZIndex = 13,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.fromOffset(5, 5)
        })
        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 7
        UIStroke.Color = v2
        UIStroke.Parent = v75

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, fromRGB(255, 250, 200)),
            ColorSequenceKeypoint.new(0.5, v13),
            ColorSequenceKeypoint.new(1, fromRGB(255, 160, 30))
        })
        UIGradient.Rotation = 45
        UIGradient.Parent = UIStroke
        self.RimGradient = UIGradient
        UIKit.gleam(v73, {
            Corner = 22,
            ZIndex = 16,
            Period = 2.6,
            Sweep = 0.9,
            Strength = 0.75,
            Width = 0.2,
            Rotation = 20
        })
    end

    local v76 = UIKit.frame(v73, {
        Name = "ArtBox",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.fromOffset(140, 140),
        Position = UDim2.fromOffset(88, 100),
        AnchorPoint = v1
    })

    p40:Art(v76, self.Tier.reward, 134, 14)
    self.Art = v76
    self.ArtScale = UIKit.scaleOf(v76)

    local v77 = UIKit.text(v73, {
        Name = "Prize",
        TextSize = 24,
        Stroke = 0,
        ZIndex = 18,
        Text = t8.CaptionFor(p40, self.Tier),
        Size = UDim2.new(1, -14, 0, 62),
        Position = UDim2.new(0, 7, 1, -66),
        Color = v12
    })

    v77.TextWrapped = true
    v77.RichText = true
    v77.LineHeight = 0.92
    v77.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 30
    UITextSizeConstraint.MinTextSize = 1
    UITextSizeConstraint.Parent = v77

    if v69 then
        v77.TextColor3 = v2
        UIKit.stroke(v77, 3, fromRGB(110, 40, 0))
    end

    self.Caption = v77

    local v78 = p40:Count(self.Tier.reward)

    if v78 > 1 then
        self.Count = UIKit.text(v73, {
            Name = "Count",
            TextSize = 40,
            Stroke = 5,
            ZIndex = 19,
            Text = "x" .. v78,
            Size = UDim2.fromOffset(84, 44),
            Position = UDim2.new(1, -10, 0, 8),
            AnchorPoint = Vector2.new(1, 0),
            XAlign = Right
        })
    end

    if self.Tier.reward.kind == "egg" then
        self.Odds = UIKit.button(v73, {
            Name = "Odds",
            Text = "ODDS",
            Corner = 10,
            Stroke = 3,
            TextStroke = 3,
            ZIndex = 20,
            Size = UDim2.fromOffset(78, 34),
            Position = UDim2.fromOffset(10, 10),
            Color = fromRGB(70, 62, 110),
            Color2 = fromRGB(36, 30, 64),
            OnClick = function() -- OnClick | line: 393
                -- upvalues: p40 (copy), self (copy)
                p40:OddsPanel(self.Tier.reward.key)
            end
        })
    end

    if v69 then
        local v79 = UIKit.frame(v71, {
            Name = "Exclusive",
            Corner = 12,
            Stroke = 4,
            ZIndex = 22,
            Size = UDim2.fromOffset(156, 38),
            Position = UDim2.fromOffset(88, 0),
            AnchorPoint = v1,
            Color = fromRGB(255, 86, 86),
            Color2 = fromRGB(196, 24, 70)
        })

        UIKit.text(v79, {
            Name = "Label",
            Text = "EXCLUSIVE",
            TextSize = 25,
            Stroke = 4,
            ZIndex = 23
        })
        UIKit.gleam(v79, {
            Corner = 12,
            ZIndex = 22,
            Period = 2.2,
            Strength = 0.7,
            Width = 0.2
        })
        self.Tag = v79
        UIKit.sparkle(v73, 26, {
            ZIndex = 17,
            Phase = 1,
            Position = UDim2.fromOffset(24, 56),
            Color = fromRGB(255, 250, 200)
        })
        UIKit.sparkle(v73, 20, {
            ZIndex = 17,
            Phase = 3,
            Position = UDim2.fromOffset(152, 126)
        })
        UIKit.sparkle(v73, 16, {
            ZIndex = 17,
            Phase = 5,
            Position = UDim2.fromOffset(142, 42),
            Color = fromRGB(255, 240, 150)
        })
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Hit"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 19
    TextButton.Parent = v73
    TextButton.Activated:Connect(function() -- line: 413
        -- upvalues: p40 (copy), p41 (copy), self (copy), UIKit (copy)
        if self.State ~= "current" or p40:Busy() then
            if self.State == "locked" then
                p40:Locked()
            end
        else
            UIKit.sound("Click")
            p40:Act(p41)
        end
    end)
    self.Hit = TextButton

    local v80, v81 = UIKit.button(v71, {
        Name = "Buy",
        Text = "",
        Corner = 16,
        Stroke = 4,
        TextStroke = 4,
        ZIndex = 16,
        Size = UDim2.fromOffset(164, 58),
        Position = UDim2.new(0.5, 0, 0, 248),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = t5[1],
        Color2 = t5[2],
        OnClick = function() -- OnClick | line: 422
            -- upvalues: p40 (copy), p41 (copy), self (copy)
            if self.State ~= "current" or p40:Busy() then
                if self.State == "locked" then
                    p40:Locked()
                end
            else
                p40:Act(p41)
            end
        end
    })

    v81.RichText = true
    UIKit.gleam(v80, {
        Corner = 16,
        ZIndex = 16,
        Period = 2.4,
        Strength = 0.7,
        Width = 0.14,
        When = function() -- When | line: 430
            -- upvalues: self (copy), v80 (copy)
            if self.State == "current" then
                return v80.Active
            end

            return false
        end
    })
    self.Pill = v80
    self.PillText = v81
    self.Arrow = UIKit.text(v71, {
        Name = "Arrow",
        TextSize = 52,
        Stroke = 5,
        ZIndex = 13,
        Text = v5,
        Size = UDim2.fromOffset(48, 70),
        Position = UDim2.fromOffset(200, 119),
        AnchorPoint = v1
    })

    local v82 = UIKit.frame(v73, {
        Name = "Dim",
        Transparency = 0.3,
        Corner = 22,
        ZIndex = 23,
        Color = fromRGB(60, 62, 74)
    })

    self.Check = UIKit.text(v82, {
        Name = "Check",
        TextSize = 100,
        Stroke = 6,
        ZIndex = 24,
        Text = v4,
        Color = Colors.Green
    })
    v82.Visible = false
    self.Dim = v82
    self.Root = v71
    self.Card = v73
    self.Stroke = v73:FindFirstChildOfClass("UIStroke")
    self.Scale = UIKit.scaleOf(v71)

    return self
end

function t8:CaptionFor(p44) -- line: 446
    local v83 = self:Caption(p44.reward)

    if p44.grand then
        v83 = string.gsub(v83, "#D8620E", "#FFF4B8")
    end

    return v83
end

function t8:CaptionText() -- line: 454
    -- upvalues: t8 (copy)
    return t8.CaptionFor(self.Owner, self.Tier)
end

function t8:SetCovered(p47) -- line: 458
    if not p47 or self.Cover then
        if not p47 and self.Cover then
            self.Cover:Destroy()
            self.Cover = nil
        end
    else
        self.Cover = self.Owner:Basket(self.Card, 18)
    end

    self.Covered = p47
    self.Caption.Visible = not p47

    if self.Count then
        self.Count.Visible = not p47
    end

    if self.Odds then
        self.Odds.Visible = not p47
    end
end

function t8:Uncover() -- line: 475
    -- upvalues: UIKit (copy)
    local Cover = self.Cover

    if not Cover then
        return
    end

    self.Cover = nil
    self.Covered = false
    self.Caption.Visible = true

    if self.Count then
        self.Count.Visible = true
    end

    if self.Odds then
        self.Odds.Visible = true
    end

    UIKit.sound("Reveal")

    local t21 = {}

    for _, descendant in ipairs(Cover:GetDescendants()) do
        if descendant:IsA("Frame") then
            t21[descendant] = {
                BackgroundTransparency = 1
            }
        elseif descendant:IsA("TextLabel") then
            t21[descendant] = {
                TextTransparency = 1
            }
        elseif descendant:IsA("UIStroke") then
            t21[descendant] = {
                Transparency = 1
            }
        end
    end

    t21[Cover] = {
        BackgroundTransparency = 1
    }
    UIKit.tween(Cover, 0.45, {
        Position = Cover.Position - UDim2.fromOffset(0, 110)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    for v84, v85 in pairs(t21) do
        UIKit.tween(v84, 0.4, v85)
    end

    self.Owner:Stars(self.Card, 100, 10, 20)
    self.ArtScale.Scale = 0.4
    UIKit.tween(self.ArtScale, 0.5, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.sound("Twinkle")
    task.delay(0.5, function() -- line: 509
        -- upvalues: Cover (copy)
        Cover:Destroy()
    end)
end

function t8:SetState(p50) -- line: 514
    -- upvalues: Colors (copy), fromRGB (copy)
    self.State = p50

    local v86 = p50 == "current"
    local Dim = self.Dim

    if p50 == "claimed" then
        Dim.Visible = not self.Hold
    else
        Dim.Visible = false
    end

    self.Pill.Visible = p50 ~= "claimed"

    local v87 = p50 ~= "claimed" and not self.Covered

    self.Caption.Visible = v87

    if self.Count then
        self.Count.Visible = v87
    end

    if self.Odds then
        self.Odds.Visible = v87
    end

    if not v86 then
        local Stroke = self.Stroke

        if self.Grand then
            Stroke.Color = fromRGB(120, 50, 0)
        else
            Stroke.Color = Colors.Outline
        end

        self.Stroke.Thickness = self.Grand and 7 or 5
        self.Art.Rotation = 0
        self.ArtScale.Scale = 1
    end

    self:Refresh()
end

function t8:Refresh() -- line: 536
    -- upvalues: TierLadder (copy), UIKit (copy), v3 (copy), t4 (copy), t5 (copy)
    local Owner = self.Owner
    local v88 = self.State == "current"
    local v89 = Owner:Busy()
    local Index = self.Index
    local v90 = TierLadder.Price(Index)
    local v91 = if v90 then v3 .. v90 else nil

    self.PillText.Text = v91 or "FREE"

    if v88 then
        UIKit.setButtonColor(self.Pill, t4[1], t4[2])
    else
        UIKit.setButtonColor(self.Pill, t5[1], t5[2])
    end

    self.Pill.Active = v88 and not v89 or self.State == "locked"
    self.Hit.Active = self.Pill.Active

    if not self.Covered then
        self.Caption.Text = self:CaptionText()
    end
end

function t8:Step(p53) -- line: 554
    if self.Glow then
        self.Glow.ImageTransparency = math.sin(p53 * 2.4) * 0.14 + 0.08
    end

    if self.RimGradient then
        self.RimGradient.Rotation = p53 * 60 % 360
    end

    if self.Tag then
        self.Tag.Rotation = math.sin(p53 * 2.2) * 3
    end

    if self.State ~= "current" or self.Hold then
        return
    end

    self.Art.Rotation = math.sin(p53 * 3 + self.Index) * 5
    self.ArtScale.Scale = (math.sin(p53 * 4) * 0.5 + 0.5) * 0.05 + 1
end

function t8:Leave() -- line: 573
    -- upvalues: UIKit (copy)
    local Root = self.Root

    UIKit.tween(Root, 0.48, {
        Position = Root.Position - UDim2.fromOffset(224, 0)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    UIKit.tween(self.Scale, 0.48, {
        Scale = 0
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.65, function() -- line: 577
        -- upvalues: Root (copy)
        Root:Destroy()
    end)
end

function t9.SlotPosition(_, p56, p57) -- line: 582
    -- upvalues: Shown (copy), v7 (copy)
    p57 = p57 or Shown

    local v97 = if p57 < Shown then math.max(0, (v7 - (p57 * 176 + (p57 - 1) * 48)) / 2) else 0

    return UDim2.fromOffset(v97 + 18 + (p56 - 1) * 224 + 88, 173)
end

function t9:CenterOf(p59) -- line: 588
    local Board = self.Board
    local v99 = Board.AbsoluteSize.X / Board.Size.X.Offset
    local v100 = p59.AbsolutePosition + p59.AbsoluteSize / 2 - Board.AbsolutePosition

    if not (v99 > 0) then
        v99 = 1
    end

    return v100 / v99
end

function t9.Stars(_, p61, p62, p63, p64) -- line: 595
    -- upvalues: UIKit (copy), fromRGB (copy), v1 (copy), v2 (copy)
    local v101 = Random.new()

    for i = 1, p63 do
        local v102 = i / p63 * 3.141592653589793 * 2 + v101:NextNumber(-0.25, 0.25)
        local v103 = v101:NextInteger(22, 40)
        local v104 = if p62 then UDim2.new(0.5, 0, 0, p62) else UDim2.fromScale(0.5, 0.5)
        local v105 = UIKit.image(p61, "Sparkle", {
            Size = UDim2.fromOffset(v103, v103),
            Position = v104,
            AnchorPoint = v1,
            ZIndex = p64,
            Color = if i % 2 == 0 then fromRGB(255, 235, 120) else v2
        })
        local v107 = if p62 then 60 else 150
        local v106 = if p62 then 120 else 250
        local v108 = v101:NextInteger(v107, v106)

        UIKit.tween(v105, 0.75, {
            ImageTransparency = 1,
            Position = v104 + UDim2.fromOffset(math.cos(v102) * v108, math.sin(v102) * v108),
            Size = UDim2.fromOffset(8, 8),
            Rotation = v101:NextInteger(-200, 200)
        }, Enum.EasingStyle.Quart).Completed:Once(function() -- line: 604
            -- upvalues: v105 (copy)
            v105:Destroy()
        end)
    end
end

function t9:Confetti(p66) -- line: 610
    -- upvalues: RunService (copy), v1 (copy), t7 (copy)
    local FxGui = self.FxGui

    local function v109() -- line: 82
        return UserSettings().GameSettings.SavedQualityLevel.Value
    end

    local ok, result = pcall(v109)

    if ok then
        ok = result > 0 and result <= 4
    end

    local v110 = if ok then math.floor(p66 * 0.45) else p66
    local v112 = Random.new()
    local AbsoluteSize = FxGui.AbsoluteSize
    local Scale = FxGui:FindFirstChild("FitScale") and FxGui.FitScale.Scale or 1
    local v113 = AbsoluteSize.X / Scale
    local v114 = AbsoluteSize.Y / Scale
    local t23 = {}

    for i = 1, v110 do
        local v115 = i % 2 == 0
        local Frame = Instance.new("Frame")

        Frame.Name = "Confetti"
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = v1
        Frame.Size = UDim2.fromOffset(v112:NextInteger(12, 20), v112:NextInteger(7, 12))
        Frame.BackgroundColor3 = t7[v112:NextInteger(1, #t7)]
        Frame.ZIndex = 40
        table.insert(t23, {
            gui = Frame,
            x = if v115 then v112:NextNumber(-0.02, 0.18) * v113 else v112:NextNumber(0.82, 1.02) * v113,
            y = v114 * 1.02,
            vx = (v115 and 1 or -1) * v112:NextNumber(120, 520),
            vy = -v112:NextNumber(v114 * 1.1, v114 * 1.7),
            r = v112:NextNumber(0, 360),
            vr = v112:NextNumber(-420, 420),
            sway = v112:NextNumber(0, 6)
        })
        Frame.Parent = FxGui
    end

    local v116 = v114 * 1.9
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 644
        -- upvalues: v114 (copy), t23 (copy), v116 (copy), elapsed (ref), connection (ref)
        local elapsed2 = os.clock()
        local v118 = math.min(elapsed2 - elapsed, 0.05)

        elapsed = elapsed2

        local n1 = 0

        for _, v119 in ipairs(t23) do
            if v119.gui.Parent then
                v119.vy += v116 * v118

                if v119.vy > 0 then
                    v119.vx *= 0.97
                    v119.vy = math.min(v119.vy, v114 * 0.45)
                end

                v119.x = v119.x + (v119.vx + math.sin(elapsed2 * 4 + v119.sway) * 40) * v118
                v119.y += v119.vy * v118
                v119.r += v119.vr * v118

                if v119.y > v114 * 1.08 and v119.vy > 0 then
                    v119.gui:Destroy()
                else
                    n1 += 1
                    v119.gui.Position = UDim2.fromOffset(v119.x, v119.y)
                    v119.gui.Rotation = v119.r
                end
            end
        end

        if n1 == 0 then
            connection:Disconnect()
        end
    end)
    task.delay(6, function() -- line: 672
        -- upvalues: t23 (copy), connection (ref)
        if connection.Connected then
            connection:Disconnect()
        end

        for _, v122 in ipairs(t23) do
            if v122.gui.Parent then
                v122.gui:Destroy()
            end
        end
    end)
end

function t9:InShop() -- line: 684
    -- upvalues: UIKit (copy)
    local Shop = UIKit.Windows.Shop

    if self.ShopHost == nil or self.Board == nil or self.Board.Parent ~= self.ShopHost or Shop == nil then
        return false
    end

    return Shop.IsOpen
end

function t9:Visible() -- line: 689
    return self.Window.IsOpen or self:InShop()
end

function t9:HostFrame() -- line: 693
    -- upvalues: UIKit (copy)
    if self:InShop() then
        return UIKit.Windows.Shop.Frame
    end

    return self.Window.Frame
end

function t9:ScreenPop(p71) -- line: 700
    -- upvalues: UIKit (copy)
    local v123 = UIKit.scaleOf(p71 or self:HostFrame())
    local Scale = v123.Scale

    v123.Scale = Scale * 1.035
    UIKit.tween(v123, 0.35, {
        Scale = Scale
    }, Enum.EasingStyle.Back)

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local FieldOfView = CurrentCamera.FieldOfView

    UIKit.tween(CurrentCamera, 0.07, {
        FieldOfView = FieldOfView - 4
    }).Completed:Once(function() -- line: 709
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), UIKit (copy)
        UIKit.tween(CurrentCamera, 0.35, {
            FieldOfView = FieldOfView
        }, Enum.EasingStyle.Back)
    end)
end

function t9.PurchaseFx(p72) -- line: 715
    -- upvalues: UIKit (copy)
    UIKit.sound("RevealGood")
    p72:Confetti(55)

    local Shop = UIKit.Windows.Shop

    p72:ScreenPop(if not (Shop and Shop.IsOpen) then nil else Shop.Frame)
end

function t9:OddsPanel(p74) -- line: 722
    -- upvalues: Products (copy), Rarities (copy), Roll (copy), Fish (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), FishIcons (copy), Colors (copy), v1 (copy), Left (copy), Right (copy)
    local v124 = Products.CrateByKey(p74)

    if not v124 then
        return
    end

    UIKit.sound("Click")

    local Board = self.Board
    local Odds = Board:FindFirstChild("Odds")

    if Odds then
        Odds:Destroy()
    end

    local v128 = Products.SpiritBest({
        DataClient.Get("Backpack") or {},
        DataClient.Get("Placed") or {},
        DataClient.Get("Aquarium") or {}
    })
    local v129 = #v124.pool * 66
    local v130 = UIKit.frame(Board, {
        Name = "Odds",
        Corner = 18,
        Stroke = 6,
        ZIndex = 40,
        Size = UDim2.fromOffset(640, v129 + 166),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = Colors.Dark
    })

    UIKit.text(v130, {
        Name = "Title",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 41,
        Text = string.upper(v124.name) .. " ODDS",
        Size = UDim2.new(1, -80, 0, 50),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left
    })
    UIKit.button(v130, {
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
        OnClick = function() -- OnClick | line: 737
            -- upvalues: v130 (copy)
            v130:Destroy()
        end
    })

    for v131, v132 in ipairs(v124.pool) do
        local v133 = Fish.ById[v132.fish]
        local v134 = v133 and Rarities.ById[v133.rarity]
        local v135 = UIKit.frame(v130, {
            Corner = 10,
            ZIndex = 41,
            Name = v132.fish,
            Size = UDim2.new(1, -28, 0, 60),
            Position = UDim2.fromOffset(14, 66 + (v131 - 1) * 66),
            Color = Colors.Panel
        })
        local frame = UIKit.frame
        local t27 = {
            Name = "Tile",
            Corner = 8,
            ZIndex = 42,
            Size = UDim2.fromOffset(52, 52),
            Position = UDim2.fromOffset(4, 4)
        }

        if v134 then
            t27.Color = v134.Color
            t27.Color2 = v134.Color2
        else
            t27.Color = Colors.PanelLight
            t27.Color2 = Colors.Panel
        end

        local v136 = frame(v135, t27)

        FishIcons.Picture(v136, v132.fish, v124.v, 1.1)
        UIKit.text(v135, {
            Name = "FishName",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 42,
            Text = if v133 then v133.name else v132.fish,
            Size = UDim2.new(1, -330, 0, 30),
            Position = UDim2.fromOffset(66, 3),
            XAlign = Left
        }).TextTruncate = Enum.TextTruncate.AtEnd

        if v132.pct then
            UIKit.text(v135, {
                Name = "Percent",
                TextSize = 19,
                Stroke = 3,
                ZIndex = 42,
                Text = v132.pct .. "% of your best fish",
                Size = UDim2.new(1, -330, 0, 24),
                Position = UDim2.fromOffset(66, 32),
                XAlign = Left,
                Color = Colors.Gold
            })
        end

        local v137 = Products.CrateIncome(v124, v132, v128) or Roll.income(v132.fish, v124.v, v124.s)

        UIKit.text(v135, {
            Name = "Rate",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 42,
            Text = NumberFormat.rate(v137),
            Size = UDim2.fromOffset(170, 60),
            Position = UDim2.new(1, -266, 0, 0),
            XAlign = Right,
            Color = Colors.Cash,
            StrokeColor = Colors.CashStroke
        })
        UIKit.text(v135, {
            Name = "Chance",
            TextSize = 30,
            Stroke = 4,
            ZIndex = 42,
            Text = v132.chance .. "%",
            Size = UDim2.fromOffset(86, 60),
            Position = UDim2.new(1, -90, 0, 0),
            Color = Colors.Gold
        })
    end

    UIKit.text(v130, {
        Name = "Note",
        TextSize = 19,
        Stroke = 3,
        ZIndex = 41,
        Text = "Each " .. v124.name .. " opens into exactly one fish from this list. The $ shown is what it would earn for YOU right now: a percentage of your best fish (" .. NumberFormat.rate(v128) .. ").",
        Size = UDim2.new(1, -28, 0, 76),
        Position = UDim2.new(0, 14, 1, -84),
        Color = Colors.Grey
    }).TextWrapped = true
    UIKit.pop(v130, 0.7)
end

function t9.BuildClock(_, p76, p77) -- line: 759
    -- upvalues: UIKit (copy), Colors (copy), v2 (copy)
    local v138 = UIKit.frame(p76, {
        Name = "Clock",
        Corner = 16,
        Stroke = 3,
        Size = UDim2.fromOffset(32, 32),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = v2,
        ZIndex = p77
    })
    local v139 = UIKit.frame(v138, {
        Name = "Long",
        Corner = 2,
        Size = UDim2.fromOffset(4, 11),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Outline,
        ZIndex = p77 + 1
    })

    UIKit.frame(v138, {
        Name = "Short",
        Corner = 2,
        Size = UDim2.fromOffset(4, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Outline,
        ZIndex = p77 + 1
    }).Rotation = 90
    v139.Rotation = 0

    return v138
end

function t9:BuildWindow() -- line: 768
    -- upvalues: TierLadder (copy), UIKit (copy), Windows (copy), fromRGB (copy), v1 (copy), Left (copy), v6 (copy), v8 (copy), v10 (copy), v11 (copy), t1 (copy), t8 (copy)
    local v140 = UIKit.window(Windows.Gui, {
        Name = "Ladder",
        Title = TierLadder.Name,
        Size = UDim2.fromOffset(1290, 538),
        HeaderColor = t1[2]
    })

    self.Window = v140

    local Frame = v140.Frame

    v140.Header.Visible = false

    local Title = Frame:FindFirstChild("Title")

    if Title then
        Title.Visible = false
    end

    local Body = Frame:FindFirstChild("Body")

    if Body then
        local UIGradient = Body:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Color = ColorSequence.new(t1[1], t1[2])
            UIGradient.Rotation = 60
        end

        local Pattern = Body:FindFirstChild("Pattern")

        if Pattern then
            Pattern.ImageColor3 = fromRGB(255, 236, 180)
            Pattern.ImageTransparency = 0.75
        end

        local Rim = Body:FindFirstChild("Rim")
        local UIStroke = Rim and Rim:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = fromRGB(255, 226, 130)
            UIStroke.Transparency = 0.05
            UIStroke.Thickness = 4
        end
    end

    local Close = Frame:FindFirstChild("Close")

    if Close then
        Close.Size = UDim2.fromOffset(54, 54)
        Close.Position = UDim2.new(1, -16, 0, 14)
    end

    local Content = v140.Content

    Content.Position = UDim2.new()
    Content.Size = UDim2.fromScale(1, 1)
    self.WindowHost = Content

    local v141 = UIKit.frame(Content, {
        Name = "Board",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(1290, 538)
    })

    self.Board = v141
    self.BoardScale = UIKit.scaleOf(v141)

    local v142 = UIKit.frame(v141, {
        Name = "Timer",
        Transparency = 0.2,
        Corner = 25,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(0, 50),
        Position = UDim2.fromOffset(20, 18),
        Color = fromRGB(70, 22, 6)
    })

    v142.AutomaticSize = Enum.AutomaticSize.X

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 54)
    UIPadding.PaddingRight = UDim.new(0, 18)
    UIPadding.Parent = v142

    local v143 = UIKit.text(v142, {
        Name = "Text",
        Text = "",
        TextSize = 25,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.fromScale(0, 1),
        Color = fromRGB(255, 236, 150)
    })

    v143.AutomaticSize = Enum.AutomaticSize.X
    self.TimerText = v143
    self:BuildClock(UIKit.frame(v141, {
        Name = "ClockHolder",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(56, 50),
        Position = UDim2.fromOffset(22, 18)
    }), 14)

    local v144 = UIKit.text(v141, {
        Name = "Title",
        TextSize = 56,
        Stroke = 7,
        ZIndex = 13,
        Text = string.upper(TierLadder.Name),
        Size = UDim2.fromOffset(620, 72),
        Position = UDim2.new(0.5, 0, 0, 6),
        AnchorPoint = Vector2.new(0.5, 0),
        StrokeColor = fromRGB(110, 28, 8)
    })

    UIKit.gradient(v144, fromRGB(255, 252, 220), fromRGB(255, 206, 60))

    local v145 = UIKit.frame(v141, {
        Name = "Track",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(v8, 340),
        Position = UDim2.fromOffset(v10, 84)
    })

    v145.ClipsDescendants = true
    self.Track = v145

    local v146 = UIKit.frame(v141, {
        Name = "Pin",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.fromOffset(216, 340),
        Position = UDim2.fromOffset(v11, 84)
    })

    UIKit.frame(v146, {
        Name = "Divider",
        Corner = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(6, 266),
        Position = UDim2.new(0, -15, 0, 173),
        AnchorPoint = v1,
        Color = fromRGB(255, 236, 160),
        Color2 = fromRGB(255, 170, 50)
    }).BackgroundTransparency = 0.2
    self.Pin = v146
    self.PinTile = t8.new(self, v6, v146)
    self.PinTile.Root.Position = UDim2.fromOffset(108, 173)
    self.PinTile.Arrow.Visible = false
    self.PinTile:SetState("locked")

    local v147 = UIKit.text(v145, {
        Name = "Done",
        Text = "ALL REWARDS CLAIMED!",
        TextSize = 54,
        Stroke = 7,
        ZIndex = 14,
        Size = UDim2.new(1, 0, 0, 58),
        Position = UDim2.fromOffset(0, 268),
        StrokeColor = fromRGB(110, 28, 8)
    })

    UIKit.gradient(v147, fromRGB(255, 252, 220), fromRGB(255, 206, 60))
    v147.Visible = false
    self.Done = v147

    local v148 = UIKit.frame(v141, {
        Name = "Upcoming",
        Transparency = 0.45,
        Corner = 18,
        ZIndex = 12,
        Size = UDim2.fromOffset(v11 + 216 - v10 - 18, 86),
        Position = UDim2.fromOffset(v10 + 18, 430),
        Color = fromRGB(110, 34, 8)
    })
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = fromRGB(255, 214, 110)
    UIStroke.Transparency = 0.1
    UIStroke.Parent = v148
    UIKit.text(v148, {
        Name = "RewardsLabel",
        Text = "REWARDS:",
        TextSize = 23,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(0, 124, 1, 0),
        Position = UDim2.fromOffset(18, 0),
        XAlign = Left,
        StrokeColor = fromRGB(90, 30, 6)
    })

    local v149 = UIKit.frame(v148, {
        Name = "Clip",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.new(1, -152, 1, 24),
        Position = UDim2.fromOffset(138, -12)
    })

    v149.ClipsDescendants = true
    self.Upcoming = v148
    self.UpcomingRow = UIKit.frame(v149, {
        Name = "Row",
        Transparency = 1,
        ZIndex = 12
    })
    self.Fx = UIKit.frame(v141, {
        Name = "ClaimFx",
        Transparency = 1,
        ZIndex = 30
    })

    v140.OnOpen = function() -- line: 849
        -- upvalues: self (copy)
        self:Mount(self.WindowHost, 1)
        self:Sync(false)
    end

    v140.OnClose = function() -- line: 853
        -- upvalues: self (copy)
        if self.ShopHost then
            self:Mount(self.ShopHost, self.ShopScale or 1)
        end
    end
end

function t9:Mount(p80, p81) -- line: 860
    if self.Board then
        if self.Board.Parent ~= p80 then
            self.Board.Parent = p80
        end

        self.Board.Position = UDim2.new()
        self.BoardScale.Scale = p81
        self:FitHost()
    end
end

function t9:FitHost() -- line: 872
    if self.Board then
        local Offset = self.Board.Size.Y.Offset
        local Frame = self.Window.Frame

        if Frame.Size.Y.Offset ~= Offset then
            Frame.Size = UDim2.fromOffset(1290, Offset)
        end

        for _, v150 in ipairs(self.ShopCards) do
            local v152 = math.floor(Offset * (v150.width / 1290) + 0.5)

            if v150.card.Size.Y.Offset ~= v152 then
                v150.card.Size = UDim2.fromOffset(v150.width, v152)
            end
        end
    end
end

function t9:FirstShown() -- line: 889
    -- upvalues: v6 (copy)
    return (math.min(self:Progress() + 1, v6 + 1))
end

function t9:MiniPosition(p85, p86) -- line: 893
    -- upvalues: Shown (copy)
    local v155 = self.MiniStep or 74

    return UDim2.fromOffset((p85 - p86 - Shown) * v155 + 30 + 4, 55)
end

function t9.PinShown(_, p88) -- line: 898
    -- upvalues: Shown (copy), v6 (copy)
    return p88 + Shown - 2 < v6
end

function t9:StripLast(p90) -- line: 902
    -- upvalues: Shown (copy), v6 (copy)
    return (math.min(p90 + Shown - 1, if self:PinShown(p90) then v6 - 1 else v6))
end

function t9:TrayLast(p92) -- line: 906
    -- upvalues: v6 (copy)
    if self:PinShown(p92) then
        return v6 - 1
    end

    return v6
end

function t9:SetTray(p94) -- line: 910
    self.Upcoming.Visible = p94

    local v158 = if p94 then 538 else 440

    if self.Board.Size.Y.Offset ~= v158 then
        self.Board.Size = UDim2.fromOffset(1290, v158)
    end

    self:FitHost()
end

function t9:SyncUpcoming(p96, p97) -- line: 919
    -- upvalues: TierLadder (copy), UIKit (copy), fromRGB (copy), v1 (copy), Shown (copy), glide (copy)
    local UpcomingRow = self.UpcomingRow
    local t29 = {}

    for _, child in ipairs(UpcomingRow:GetChildren()) do
        local v159 = tonumber(string.match(child.Name, "^Mini(%d+)$"))

        if v159 then
            t29[v159] = child
        end
    end

    local v160 = self:TrayLast(p96)
    local v162 = math.max(v160 - (p96 + Shown) + 1, 0)
    local v163 = self.Upcoming.Size.X.Offset - 28 - 124 - 60 - 20

    self.MiniStep = if v162 > 1 then math.min(74, v163 / (v162 - 1)) else 74

    for i = p96 + Shown, v160 do
        if not t29[i] then
            local v166 = TierLadder.Tiers[i]
            local v167 = UIKit.frame(UpcomingRow, {
                Transparency = 1,
                ZIndex = 13,
                Name = "Mini" .. i,
                Size = UDim2.fromOffset(60, 60),
                Position = self:MiniPosition(i, p96) + (if p97 then UDim2.fromOffset(74, 0) else UDim2.new()),
                AnchorPoint = v1
            })

            if v166.grand then
                UIKit.image(v167, "Glow", {
                    Transparency = 0.4,
                    ZIndex = 13,
                    Size = UDim2.fromOffset(102, 102),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = v1,
                    Color = fromRGB(255, 214, 80)
                })
            end

            self:Art(v167, v166.reward, 54, 14)
            t29[i] = v167
        end
    end

    for v168, v169 in pairs(t29) do
        if v160 < v168 then
            v169:Destroy()
        elseif v168 < p96 + Shown then
            if p97 then
                UIKit.tween(v169, 0.6, {
                    Position = self:MiniPosition(v168, p96)
                }, Enum.EasingStyle.Quint)
                UIKit.tween(UIKit.scaleOf(v169), 0.3, {
                    Scale = 0
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                task.delay(0.65, function() -- line: 950
                    -- upvalues: v169 (copy)
                    v169:Destroy()
                end)
            else
                v169:Destroy()
            end
        elseif p97 then
            glide(v169, self:MiniPosition(v168, p96), 0.6)
        else
            v169.Position = self:MiniPosition(v168, p96)
        end
    end

    local v170 = p96 + Shown <= v160

    if not p97 or v170 then
        self:SetTray(v170)
    else
        task.delay(0.6, function() -- line: 964
            -- upvalues: self (copy), p96 (copy)
            if self.First == p96 then
                self:SetTray(false)
            end
        end)
    end
end

function t9:Sync(p99) -- line: 974
    -- upvalues: TierLadder (copy), UIKit (copy), Shown (copy), v6 (copy), v8 (copy), v10 (copy), glide (copy), t8 (copy)
    local v171 = self:Progress()

    self.Shown = v171

    local v172 = self:FirstShown()
    local v173 = p99 and self.First ~= nil and self.First < v172

    self.First = v172

    local v174 = self:StripLast(v172)
    local v175 = if self:PinShown(v172) then v172 else math.max(1, (math.min(v172, v6 - Shown + 2)))
    local v179 = math.max(v174 - v175 + 1, 0)
    local t31 = {}

    for i = v175, v174 do
        t31[i] = i - v175 + 1
    end

    for v180, v181 in pairs(self.Tiles) do
        if not t31[v180] then
            if v173 then
                v181:Leave()
            else
                v181.Root:Destroy()
            end

            self.Tiles[v180] = nil
        end
    end

    for v182, v183 in pairs(t31) do
        local v184 = self.Tiles[v182]
        local v185 = self:SlotPosition(v183, v179)
        local v186 = v183 == Shown and v171 + 1 < v182 and not TierLadder.Tiers[v182].grand

        if v184 then
            if v173 then
                glide(v184.Root, v185, 0.6)

                if v182 == v171 + 1 then
                    task.delay(0.44999999999999996, function() -- line: 1015
                        -- upvalues: v184 (ref), UIKit (copy)
                        if v184.Root.Parent then
                            v184.Scale.Scale = 1
                            UIKit.tween(v184.Scale, 0.16, {
                                Scale = 1.06
                            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out).Completed:Once(function() -- line: 1019
                                -- upvalues: v184 (ref), UIKit (copy)
                                UIKit.tween(v184.Scale, 0.32, {
                                    Scale = 1
                                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                            end)
                        end
                    end)
                end
            else
                v184.Root.Position = v185
            end

            if v184.Covered and not v186 then
                if v173 then
                    task.delay(0.6, function() -- line: 1030
                        -- upvalues: v184 (ref)
                        if v184.Root.Parent then
                            v184:Uncover()
                        end
                    end)
                else
                    v184:SetCovered(false)
                end
            end
        else
            v184 = t8.new(self, v182)
            self.Tiles[v182] = v184
            v184:SetCovered(v186)

            if v173 then
                v184.Root.Position = self:SlotPosition(v183 + 1, v179)
                glide(v184.Root, v185, 0.6)
            else
                v184.Root.Position = v185
            end
        end

        v184.Arrow.Visible = v183 < v179

        local v187 = if v182 <= v171 then "claimed" elseif v182 == v171 + 1 then "current" else "locked"

        v184:SetState(v187)
    end

    self.Done.Visible = v6 < v172

    local v188 = self:PinShown(v172)

    self.Pin.Visible = v188

    local v189 = if v188 then v10 else math.floor((1290 - v8) / 2)

    if self.Track.Position.X.Offset ~= v189 then
        if v173 then
            UIKit.tween(self.Track, 0.6, {
                Position = UDim2.fromOffset(v189, 84)
            }, Enum.EasingStyle.Quint)
        else
            self.Track.Position = UDim2.fromOffset(v189, 84)
        end
    end

    if v173 then
        UIKit.sound("CloseUp")
    end

    self:SyncUpcoming(v172, v173)
    self:Refresh()
end

function t9:Refresh() -- line: 1061
    -- upvalues: TierLadder (copy)
    local v191 = TierLadder.Now()

    self.TimerText.Text = "Leaves in " .. TierLadder.Clock(TierLadder.EndsAt - v191, true)

    for _, v192 in pairs(self.Tiles) do
        v192:Refresh()
    end

    if self.PinTile then
        self.PinTile:Refresh()
    end
end

function t9:ButtonText() -- line: 1072
    local v193 = self.Tiles[self:Progress() + 1]

    if v193 then
        return (string.gsub(v193.PillText.Text, "<[^>]+>", ""))
    end

    return "ALL CLAIMED"
end

function t9:Step(p103) -- line: 1080
    for _, v194 in pairs(self.Tiles) do
        v194:Step(p103)
    end

    if self.PinTile and self.Pin.Visible then
        self.PinTile:Step(p103)
    end
end

function t9:Locked() -- line: 1089
    -- upvalues: TierLadder (copy), UIKit (copy), Toasts (copy)
    if os.clock() - (self.LockedToastAt or 0) < 1.5 then
        return
    end

    self.LockedToastAt = os.clock()

    local v195 = self:Progress() + 1
    local v196 = if TierLadder.IsPaid(v195) then "buy" else "claim"

    Toasts.Show("info", "Rewards unlock in order! " .. v196:sub(1, 1):upper() .. v196:sub(2) .. " the green one first.")
    UIKit.sound("Click")
end

function t9:Act(p106) -- line: 1100
    -- upvalues: Remotes (copy), TierLadder (copy), Toasts (copy), v6 (copy)
    if not self.Celebrating and not self.Pending and not self.Claiming then
        if TierLadder.Active() then
            if p106 == self:Progress() + 1 and not (v6 < p106) then
                if TierLadder.IsPaid(p106) then
                    self.Pending = p106
                    self.PendingAt = os.clock()
                    self:Refresh()
                    task.spawn(function() -- line: 1115
                        -- upvalues: self (copy), p106 (copy), Remotes (copy), Toasts (copy)
                        local function v197() -- line: 1116
                            -- upvalues: p106 (copy), Remotes (copy)
                            return Remotes:WaitForChild("LadderBuy"):InvokeServer(p106)
                        end

                        local ok, result = pcall(v197)

                        if not ok or type(result) ~= "table" or not result.ok then
                            self.Pending = nil
                            Toasts.Show("error", if ok and type(result) == "table" and result.reason then result.reason else "Couldn't open the purchase. Try again")
                        end

                        self:Refresh()
                    end)
                else
                    self.Claiming = p106
                    self:Refresh()
                    task.spawn(function() -- line: 1128
                        -- upvalues: self (copy), p106 (copy), Remotes (copy), Toasts (copy)
                        local function v198() -- line: 1129
                            -- upvalues: p106 (copy), Remotes (copy)
                            return Remotes:WaitForChild("LadderClaim"):InvokeServer(p106)
                        end

                        local ok, result = pcall(v198)

                        self.Claiming = nil

                        if ok and type(result) == "table" and result.ok then
                            self.Claimed += 1
                        elseif ok and type(result) == "table" and result.reason then
                            Toasts.Show("error", result.reason)
                        end

                        self:Refresh()
                    end)
                end
            end
        else
            Toasts.Show("info", "The " .. TierLadder.Name .. " has ended")
        end
    end
end

function t9:Celebrate(p108) -- line: 1143
    -- upvalues: RunService (copy), TierLadder (copy), NumberFormat (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy), fly (copy)
    local tier = p108.tier
    local v199 = TierLadder.Tiers[tier]

    if not v199 then
        return
    end

    if not self:Visible() then
        self.Window.Open()
        task.wait(0.35)
    end

    self.Celebrations += 1
    self.Celebrating = true
    self:Refresh()

    local v200 = v199.grand == true
    local v201 = self.Tiles[tier]
    local v202 = v201

    if v201 then
        v202 = v201.Art
        v201.Hold = true
    end

    local Board, Fx = self.Board, self.Fx

    Fx:ClearAllChildren()

    local v203 = Vector2.new(Board.Size.X.Offset / 2, Board.Size.Y.Offset / 2 + 10)
    local v204 = v203

    if v202 then
        v204 = self:CenterOf(v202)
        v202.Visible = false
    end

    local v205 = UIKit.frame(Fx, {
        Name = "Scrim",
        Transparency = 1,
        Corner = 24,
        ZIndex = 30,
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.fromOffset(6, 6),
        Color = fromRGB(0, 0, 0)
    })

    UIKit.tween(v205, 0.25, {
        BackgroundTransparency = 0.4
    })

    local v206 = UIKit.frame(Fx, {
        Name = "Stage",
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(240, 240),
        Position = UDim2.fromOffset(v204.X, v204.Y),
        AnchorPoint = v1
    })
    local v207 = UIKit.image(v206, "Rays", {
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(620, 620),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 236, 150)
    })
    local v208 = UIKit.image(v206, "Glow", {
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(460, 460),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 248, 210)
    })
    local v209 = self:Art(v206, v199.reward, 200, 33, p108.potions)
    local v210 = UIKit.scaleOf(v209)

    v210.Scale = 0.55

    local kind = v199.reward.kind
    local v212 = UIKit.text(v206, {
        Name = "Amount",
        TextSize = 64,
        Stroke = 7,
        ZIndex = 40,
        Text = if kind == "cash" then "+" .. NumberFormat.money(p108.amount or 0) else "x" .. tostring(p108.amount or 1),
        Size = UDim2.fromOffset(420, 70),
        Position = UDim2.new(0.5, 0, 1, -16),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Gold,
        StrokeColor = fromRGB(110, 60, 0)
    })

    v212.Visible = false

    local v213 = UIKit.frame(Fx, {
        Name = "Ribbon",
        Corner = 14,
        Stroke = 5,
        ZIndex = 42,
        Size = UDim2.fromOffset(680, 58),
        Position = UDim2.fromOffset(Board.Size.X.Offset / 2, 52),
        AnchorPoint = v1,
        Color = fromRGB(120, 240, 90),
        Color2 = fromRGB(40, 170, 50)
    })

    UIKit.text(v213, {
        Name = "Label",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 43,
        Text = tostring(p108.text or ""),
        Size = UDim2.new(1, -20, 1, -6),
        Position = UDim2.fromOffset(10, 2)
    })
    UIKit.scaleOf(v213).Scale = 0
    UIKit.sound(v200 and "RevealRare" or "RevealGood")

    if kind == "cash" then
        UIKit.sound("Coins")
    end

    self:ScreenPop()
    UIKit.tween(UIKit.scaleOf(v213), 0.4, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.tween(v207, 0.5, {
        ImageTransparency = 0.25
    })
    UIKit.tween(v208, 0.5, {
        ImageTransparency = 0.15
    })

    local elapsed = os.clock()
    local connection = RunService.RenderStepped:Connect(function() -- line: 1193
        -- upvalues: v207 (copy), v208 (copy), elapsed (copy)
        local v215 = os.clock() - elapsed

        v207.Rotation = v215 * 50

        local v217 = math.sin(v215 * 5) * 22 + 460

        v208.Size = UDim2.fromOffset(v217, v217)
    end)

    fly(v206, v210, v204, v203, 0.55, 1.25, 0.6, 90)
    self:Confetti(v200 and 90 or 55)
    UIKit.tween(v210, 0.14, {
        Scale = 1.34
    }, Enum.EasingStyle.Sine).Completed:Once(function() -- line: 1202
        -- upvalues: v210 (copy), UIKit (copy)
        UIKit.tween(v210, 0.3, {
            Scale = 1.25
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    end)
    task.delay(0.1, function() -- line: 1205
        -- upvalues: self (copy), v206 (copy), kind (copy), v212 (copy), UIKit (copy)
        v212.Visible = kind ~= "fish" and kind ~= "bait" and kind ~= "rod"
        UIKit.pop(v212, 1.6)
        self:Stars(v206, nil, 14, 38)
        UIKit.sound("Twinkle")
    end)

    local v219 = tonumber(self.HoldTime) or 1.7
    local wait = task.wait

    if v200 then
        v219 += 1
    end

    wait(v219)

    local v220 = if v202 then self:CenterOf(v202) else v203

    UIKit.tween(v207, 0.3, {
        ImageTransparency = 1
    })
    UIKit.tween(v208, 0.3, {
        ImageTransparency = 1
    })
    UIKit.tween(v205, 0.4, {
        BackgroundTransparency = 1
    })
    v212.Visible = false
    fly(v206, v210, v203, v220, v210.Scale, 0.55, 0.45, 60)
    connection:Disconnect()
    v206:Destroy()
    v205:Destroy()

    if v202 then
        v202.Visible = true
    end

    if v201 then
        v201.Hold = false
    end

    UIKit.sound("Unlock")
    self.Celebrating = false
    self.Pending = nil
    self:Sync(true)

    if v201 and self.Tiles[tier] == v201 then
        UIKit.pop(v201.Check, 1.8)
        UIKit.pop(v201.Card, 1.08)
    end

    task.delay(0.9, function() -- line: 1236
        -- upvalues: v213 (copy), UIKit (copy)
        if v213.Parent then
            UIKit.tween(UIKit.scaleOf(v213), 0.2, {
                Scale = 0
            }, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Once(function() -- line: 1239
                -- upvalues: v213 (copy)
                v213:Destroy()
            end)
        end
    end)
    task.wait(1.2999999999999998)
end

function t9:RunQueue() -- line: 1247
    if self.Running then
        return
    end

    self.Running = true
    task.spawn(function() -- line: 1252
        -- upvalues: self (copy)
        while #self.Queue > 0 do
            local v221 = table.remove(self.Queue, 1)
            local Celebrate = self.Celebrate
            local ok, result = pcall(Celebrate, self, v221)

            if not ok then
                warn("[TierLadderUI] " .. tostring(result))
                self.Fx:ClearAllChildren()

                for _, v222 in pairs(self.Tiles) do
                    v222.Hold = false

                    if v222.Art then
                        v222.Art.Visible = true
                    end
                end

                self.Celebrating = false
                self.Pending = nil
                self:Sync(false)
            end
        end

        self.Running = false
    end)
end

function t9:ShopCard(p111, p112) -- line: 1274
    -- upvalues: UIKit (copy), fromRGB (copy), t1 (copy)
    local v224 = UIKit.frame(p111, {
        Name = "TierLadder",
        GradientRotation = 60,
        Corner = 22,
        Stroke = 6,
        ZIndex = 12,
        Size = UDim2.fromOffset(p112, (math.floor(p112 * 538 / 1290))),
        Color = t1[1],
        Color2 = t1[2]
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Pattern"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = UIKit.Art.Bubbles
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset(190, 190)
    ImageLabel.ImageColor3 = fromRGB(255, 236, 180)
    ImageLabel.ImageTransparency = 0.75
    ImageLabel.ZIndex = 12
    UIKit.corner(ImageLabel, 22)
    ImageLabel.Parent = v224
    UIKit.dress(v224, 22, fromRGB(255, 226, 130), 12)

    local v225 = UIKit.frame(v224, {
        Name = "Host",
        Transparency = 1,
        ZIndex = 12
    })

    self.ShopHost = v225
    self.ShopScale = p112 / 1290

    local v226 = UIKit.frame(v224, {
        Name = "Ends",
        GradientRotation = 0,
        Corner = 10,
        Stroke = 4,
        ZIndex = 40,
        Size = UDim2.fromOffset(230, 42),
        Position = UDim2.new(1, -18, 0, -8),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(255, 96, 60),
        Color2 = fromRGB(200, 36, 40)
    })

    v226.Rotation = 4
    UIKit.text(v226, {
        Name = "Label",
        Text = "ENDS SATURDAY",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 41
    })

    local t35 = {
        card = v224,
        width = p112
    }

    table.insert(self.ShopCards, t35)

    if self.Board and not self.Window.IsOpen then
        self:Mount(v225, self.ShopScale)
        self:Sync(false)
    end

    self:RefreshShopCard(t35)

    return v224
end

function t9:RefreshShopCard(p114) -- line: 1305
    p114.card.Visible = self:Live()
end

function t9:Sign(p116) -- line: 1309
    -- upvalues: UIKit (copy), Colors (copy), fromRGB (copy)
    if not p116:IsA("Model") then
        return
    end

    local Head = p116:FindFirstChild("Head")
    local BillboardGui, v227, v228

    if not Head or Head:FindFirstChild("LadderSign") then
        return
    else
        BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "LadderSign"
        BillboardGui.Size = UDim2.fromOffset(240, 84)
        BillboardGui.StudsOffset = Vector3.new(0, 4.4, 0)
        BillboardGui.MaxDistance = 120
        BillboardGui.LightInfluence = 0

        local v230 = UIKit.text(BillboardGui, {
            Name = "Here",
            Text = "HERE UNTIL SATURDAY",
            TextSize = 26,
            Stroke = 4,
            ZIndex = 2,
            Size = UDim2.new(1, 0, 0, 34)
        })

        UIKit.gradient(v230, fromRGB(255, 250, 190), fromRGB(255, 204, 60))

        local v231 = UIKit.frame(BillboardGui, {
            Name = "Countdown",
            Transparency = 0.2,
            Corner = 17,
            Stroke = 3,
            ZIndex = 1,
            Size = UDim2.fromOffset(0, 34),
            Position = UDim2.new(0.5, 0, 0, 40),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = fromRGB(20, 14, 40),
            StrokeColor = Colors.Gold
        })

        v231.AutomaticSize = Enum.AutomaticSize.X

        local UIPadding = Instance.new("UIPadding")

        UIPadding.PaddingLeft = UDim.new(0, 14)
        UIPadding.PaddingRight = UDim.new(0, 14)
        UIPadding.Parent = v231
        v227 = UIKit.text(v231, {
            Name = "Label",
            Text = "",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 2,
            Size = UDim2.fromScale(0, 1),
            Color = Colors.Gold
        })
        v227.AutomaticSize = Enum.AutomaticSize.X
        BillboardGui.Parent = Head
        v228 = self.Signs or {}
    end

    self.Signs = v228
    self.Signs[BillboardGui] = v227
    BillboardGui.Destroying:Connect(function() -- line: 1336
        -- upvalues: self (copy), BillboardGui (ref)
        self.Signs[BillboardGui] = nil
    end)
end

function t9:RefreshWorld() -- line: 1341
    -- upvalues: CollectionService (copy), TierLadder (copy)
    local v232 = self:Allowed()
    local v233 = TierLadder.Clock(TierLadder.EndsAt - TierLadder.Now(), true)

    for v234, v235 in pairs(self.Signs or {}) do
        v235.Text = v233
        v234.Enabled = v232
    end

    for _, v236 in ipairs(CollectionService:GetTagged("LadderNpc")) do
        local v237 = v236:FindFirstChild("LadderPrompt", true)

        if v237 and v237.Enabled ~= v232 then
            v237.Enabled = v232
        end

        local SignBoard = v236:FindFirstChild("SignBoard")

        if SignBoard then
            for _, child in ipairs(SignBoard:GetChildren()) do
                local v238 = child:IsA("SurfaceGui") and child:FindFirstChild("Countdown", true)

                if v238 and v238.Text ~= v233 then
                    v238.Text = v233
                end
            end
        end
    end
end

function t9:Open() -- line: 1365
    -- upvalues: TierLadder (copy), Toasts (copy)
    if self:Live() then
        self.Window.Open()
    else
        Toasts.Show("info", "The " .. TierLadder.Name .. " has ended")
    end
end

function t9:Tick() -- line: 1373
    -- upvalues: TextChatService (copy), TierLadder (copy), UIKit (copy), DataClient (copy)
    local v239 = self:Live()

    if self.WasLive == true and not v239 and not TierLadder.Active() then
        local v240 = "The " .. TierLadder.Npc .. " has packed up and left the lobby."

        local function v241() -- line: 124
            -- upvalues: v240 (copy), TextChatService (copy)
            local TextChannels = TextChatService:FindFirstChild("TextChannels")
            local RBXGeneral = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

            if RBXGeneral then
                RBXGeneral:DisplaySystemMessage("<font color=\"#FFB347\"><b>[EVENT]</b></font> " .. v240)
            end
        end

        pcall(v241)

        if self.Window.IsOpen then
            self.Window.Close()
        end
    end

    if v239 and not self.Greeted and DataClient.IsReady() then
        self.Greeted = true

        local v242 = "A special guest is in the lobby until Saturday."

        local function v243() -- line: 124
            -- upvalues: v242 (copy), TextChatService (copy)
            local TextChannels = TextChatService:FindFirstChild("TextChannels")
            local RBXGeneral = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

            if RBXGeneral then
                RBXGeneral:DisplaySystemMessage("<font color=\"#FFB347\"><b>[EVENT]</b></font> " .. v242)
            end
        end

        pcall(v243)
    end

    self.WasLive = v239

    if self.Pending and self.PendingAt and os.clock() - self.PendingAt > 20 then
        self.Pending = nil
    end

    for _, v244 in ipairs(self.ShopCards) do
        self:RefreshShopCard(v244)
    end

    local Shop = UIKit.Windows.Shop
    local v245 = Shop ~= nil and Shop.IsOpen

    if v245 and not self.ShopWasOpen then
        if self.ShopHost and not self.Window.IsOpen then
            self:Mount(self.ShopHost, self.ShopScale or 1)
            self:Sync(false)
        end

        self:RedrawFish()
    end

    self.ShopWasOpen = v245
    self:RefreshWorld()

    if self:Visible() and not self.Celebrating then
        if self.Shown ~= self:Progress() and #self.Queue == 0 then
            self:Sync(false)
        else
            self:Refresh()
        end
    end
end

function t9:Start() -- line: 1412
    -- upvalues: RunService (copy), MarketplaceService (copy), ProximityPromptService (copy), CollectionService (copy), Remotes (copy), TierLadder (copy), Products (copy), UIKit (copy), DataClient (copy), LocalPlayer (copy)
    if self.Started then
        return self
    end

    self.Started = true
    self.FxGui = UIKit.screenGui("LadderFx", 60)
    self.FxGui.IgnoreGuiInset = true
    self:BuildWindow()

    if self.ShopHost then
        self:Mount(self.ShopHost, self.ShopScale or 1)
        self:Sync(false)
    end

    Remotes:WaitForChild("LadderClaimed").OnClientEvent:Connect(function(p121) -- line: 1424
        -- upvalues: self (copy)
        local v246 = type(p121) == "table"
        local v247 = if v246 then type(p121.tier) == "number" else nil

        if v246 and v247 then
            self.Pending = nil
            table.insert(self.Queue, p121)
            self:RunQueue()
        end
    end)

    local t36 = {}

    for _, v248 in ipairs({ "SpiritLantern", "GoldenHarvest" }) do
        local v249 = Products.CrateByKey(v248)

        for _, v250 in ipairs(v249 and v249.buy or {}) do
            if v250.id and v250.id ~= 0 then
                t36[v250.id] = true
            end
        end
    end

    self.FxProducts = t36

    local function v251() -- line: 1442
        -- upvalues: self (copy), t36 (copy), MarketplaceService (copy), TierLadder (copy), LocalPlayer (copy)
        MarketplaceService.PromptProductPurchaseFinished:Connect(function(p122, p123, p124) -- line: 1443
            -- upvalues: self (copy), t36 (copy), TierLadder (copy), LocalPlayer (copy)
            if p122 == LocalPlayer.UserId and p124 and t36[p123] then
                self:PurchaseFx()
            elseif p122 == LocalPlayer.UserId and not p124 and self.Pending and TierLadder.FindProduct(p123) == self.Pending then
                self.Pending = nil
                self:Refresh()
            end
        end)
    end

    pcall(v251)
    ProximityPromptService.PromptTriggered:Connect(function(p125) -- line: 1457
        -- upvalues: self (copy)
        if p125.Name == "LadderPrompt" then
            self:Open()
        end
    end)

    local function watch(p126) -- line: 1462
        -- upvalues: self (copy)
        task.defer(function() -- line: 1463
            -- upvalues: p126 (copy), self (copy)
            self:Sign(p126)
            self:RefreshWorld()
        end)
    end

    for _, v252 in ipairs(CollectionService:GetTagged("LadderNpc")) do
        task.defer(function() -- line: 1463
            -- upvalues: self (copy), v252 (copy)
            self:Sign(v252)
            self:RefreshWorld()
        end)
    end

    CollectionService:GetInstanceAddedSignal("LadderNpc"):Connect(watch)
    DataClient.Observe("Ladder", function() -- line: 1472
        -- upvalues: self (copy)
        task.delay(0.3, function() -- line: 1473
            -- upvalues: self (copy)
            if self:Visible() and not self.Celebrating and #self.Queue == 0 and self.Shown ~= self:Progress() then
                self:Sync(false)
            end
        end)
    end)
    LocalPlayer:GetAttributeChangedSignal("CratesAllowed"):Connect(function() -- line: 1479
        -- upvalues: self (copy)
        self:RefreshWorld()

        for _, v253 in ipairs(self.ShopCards) do
            self:RefreshShopCard(v253)
        end
    end)

    local n2 = 0

    RunService.Heartbeat:Connect(function(p127) -- line: 1486
        -- upvalues: self (copy), n2 (ref)
        if self:Visible() then
            self:Step(os.clock())
        end

        n2 += p127

        if n2 >= 0.5 then
            n2 = 0
            self:Tick()
        end
    end)

    return self
end

t9.Shared = t9.new()

return t9

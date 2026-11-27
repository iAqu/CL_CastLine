-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local LevelRewards = require(Modules:WaitForChild("LevelRewards"))
local Loc = require(Modules:WaitForChild("Loc"))

local function pctNum(p1) -- line: 38
    -- upvalues: LevelRewards (copy)
    return (LevelRewards.Percent(p1):gsub("%%$", ""))
end

local TextService = game:GetService("TextService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local XPGui = PlayerGui:WaitForChild("XPGui")
local Panel = XPGui:WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local Close = Main:WaitForChild("Close")
local Profile = Main:WaitForChild("Profile")
local XPBar = Main:WaitForChild("XPBar")
local FillClip = XPBar:WaitForChild("FillClip")
local Fill = FillClip:WaitForChild("Fill")
local LevelStar = XPBar:WaitForChild("LevelStar")
local NextStar = XPBar:WaitForChild("NextStar")
local View = Main:WaitForChild("View")
local Tiles = Main:WaitForChild("TilesClip"):WaitForChild("Tiles")
local UIListLayout = Tiles:WaitForChild("UIListLayout")
local Button = PlayerGui:WaitForChild("MenuButtons"):WaitForChild("SmallRow"):WaitForChild("HarpoonSlot"):WaitForChild("Button")
local Side = XPGui:WaitForChild("Side")
local Scale2 = Side:WaitForChild("Scale")
local Tabs = Side:WaitForChild("Tabs")
local XP = Tabs:WaitForChild("XP")
local Leaderboards = Tabs:WaitForChild("Leaderboards")
local Leaderboards2 = XPGui:WaitForChild("Leaderboards")
local Scale3 = Leaderboards2:WaitForChild("Scale")
local Leaderboards3 = require(script:WaitForChild("Leaderboards"))
local Achievements = Tabs:WaitForChild("Achievements")
local Achievements2 = XPGui:WaitForChild("Achievements")
local Scale4 = Achievements2:WaitForChild("Scale")
local Achievements3 = require(script:WaitForChild("Achievements"))

Panel.Visible = false
Leaderboards2.Visible = false
Achievements2.Visible = false
Side.Visible = false

local t1 = {
    STAR_FIRST = 0.1,
    FILL_FIRST = 0.14,
    FILL_TIME = 0.55,
    TILE_FIRST = 0.16,
    TILE_STEP = 0.05,
    TILE_POP = 0.3,
    TILE_HOVER = 1.06,
    HIGHLIGHT_FADE = 0.8,
    SCROLL_BAR = 0.032857142857142856,
    STAR_POP = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FILL_CHANGE = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

Profile:WaitForChild("Card"):WaitForChild("Head").Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
Profile:WaitForChild("Username").AutoLocalize = false
Profile.Username.Text = LocalPlayer.Name

local FishCaught = Profile:WaitForChild("FishCaught")

FishCaught.AutoLocalize = false

local v1 = {}

local function showFish() -- line: 97
    -- upvalues: Loc (copy), FishCaught (copy), v1 (ref)
    local n1 = 0

    for _, v2 in pairs(v1) do
        n1 += type(v2) == "table" and v2.caught or 0
    end

    FishCaught.Text = Loc.F("xp.fish_caught", "Fish caught: {n}", {
        n = tostring(n1)
    })
end

Remotes:WaitForChild("IndexState").OnClientEvent:Connect(function(p2, p3) -- line: 102
    -- upvalues: v1 (ref), showFish (copy)
    if type(p2) ~= "table" then
        return
    end

    if p3 then
        v1 = p2
    else
        for v3, v4 in pairs(p2) do
            v1[v3] = v4
        end
    end

    showFish()
end)

local IndexRecords = Remotes:WaitForChild("IndexRecords")

local function refreshFish() -- line: 108
    -- upvalues: v1 (ref), showFish (copy), IndexRecords (copy)
    task.spawn(function() -- line: 109
        -- upvalues: v1 (ref), showFish (copy), IndexRecords (copy)
        local InvokeServer = IndexRecords.InvokeServer
        local v6, _, v7 = pcall(InvokeServer, IndexRecords)

        if v6 and type(v7) == "table" then
            v1 = v7
            showFish()
        end
    end)
end

showFish()

local NumberValue = Instance.new("NumberValue")

local function pose() -- line: 121
    -- upvalues: FillClip (copy), Fill (copy), NumberValue (copy)
    local v8 = math.clamp(NumberValue.Value, 0, 1)

    FillClip.Visible = v8 > 0.001
    FillClip.Size = UDim2.fromScale(math.max(v8, 0.001), 1)
    Fill.Size = UDim2.fromScale(1 / math.max(v8, 0.001), 1)
end

NumberValue.Changed:Connect(pose)

local function xpFraction() -- line: 128
    -- upvalues: LocalPlayer (copy)
    local XP = LocalPlayer:GetAttribute("XP")
    local XPNeed = LocalPlayer:GetAttribute("XPNeed")

    if type(XP) ~= "number" or type(XPNeed) ~= "number" or XPNeed <= 0 then
        return 0
    end

    return (math.clamp(XP / XPNeed, 0, 1))
end

local MoneyBoost = Profile:WaitForChild("MoneyBoost")
local LuckBoost = Profile:WaitForChild("LuckBoost")

MoneyBoost.AutoLocalize = false
LuckBoost.AutoLocalize = false

local v10 = LuckBoost.Position.X.Scale - (MoneyBoost.Position.X.Scale + MoneyBoost.Size.X.Scale)
local v11 = Profile.Size.X.Scale / Profile.Size.Y.Scale * Panel:WaitForChild("UIAspectRatioConstraint").AspectRatio

local function lineWidth(p4) -- line: 140
    -- upvalues: TextService (copy), v11 (copy)
    return (TextService:GetTextSize(p4.Text, 100, Enum.Font.FredokaOne, Vector2.new(1E+06, 1E+06)).X / 100 + 0.04) * p4.Size.Y.Scale / v11
end

local function showBoosts(p5) -- line: 144
    -- upvalues: LevelRewards (copy), Loc (copy), TextService (copy), MoneyBoost (copy), LuckBoost (copy), v10 (copy), v11 (copy)
    local F = Loc.F
    local v12 = LevelRewards.Money(p5)

    MoneyBoost.Text = F("xp.money", "+{p}% Money", {
        p = LevelRewards.Percent(v12):gsub("%%$", "")
    })

    local F2 = Loc.F
    local v13 = LevelRewards.Luck(p5)

    LuckBoost.Text = F2("xp.mutation_luck", "+{p}% Mutation luck", {
        p = LevelRewards.Percent(v13):gsub("%%$", "")
    })

    local v14 = (TextService:GetTextSize(MoneyBoost.Text, 100, Enum.Font.FredokaOne, Vector2.new(1E+06, 1E+06)).X / 100 + 0.04) * MoneyBoost.Size.Y.Scale / v11

    MoneyBoost.Size = UDim2.fromScale(v14, MoneyBoost.Size.Y.Scale)
    LuckBoost.Position = UDim2.fromScale(MoneyBoost.Position.X.Scale + v14 + v10, LuckBoost.Position.Y.Scale)
    LuckBoost.Size = UDim2.fromScale((TextService:GetTextSize(LuckBoost.Text, 100, Enum.Font.FredokaOne, Vector2.new(1E+06, 1E+06)).X / 100 + 0.04) * LuckBoost.Size.Y.Scale / v11, LuckBoost.Size.Y.Scale)
end

local function showLevels() -- line: 152
    -- upvalues: LocalPlayer (copy), LevelStar (copy), NextStar (copy), showBoosts (copy)
    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    LevelStar.Level.Text = tostring(Level)
    NextStar.Level.Text = tostring(Level + 1)
    showBoosts(Level)
end

local v16 = false
local v17 = false
local v18 = false

local function xpChanged() -- line: 161
    -- upvalues: TweenService (copy), LocalPlayer (copy), LevelStar (copy), NextStar (copy), t1 (copy), NumberValue (copy), showBoosts (copy), v16 (ref), v18 (ref)
    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    LevelStar.Level.Text = tostring(Level)
    NextStar.Level.Text = tostring(Level + 1)
    showBoosts(Level)

    if v16 then
        if not v18 then
            local FILL_CHANGE = t1.FILL_CHANGE
            local XP = LocalPlayer:GetAttribute("XP")
            local XPNeed = LocalPlayer:GetAttribute("XPNeed")

            TweenService:Create(NumberValue, FILL_CHANGE, {
                Value = if type(XP) == "number" and type(XPNeed) == "number" and not (XPNeed <= 0) then math.clamp(XP / XPNeed, 0, 1) else 0
            }):Play()
        end
    else
        local XP = LocalPlayer:GetAttribute("XP")
        local XPNeed = LocalPlayer:GetAttribute("XPNeed")

        NumberValue.Value = if type(XP) == "number" and type(XPNeed) == "number" and not (XPNeed <= 0) then math.clamp(XP / XPNeed, 0, 1) else 0
    end
end

for _, v23 in ipairs({ "XP", "XPNeed", "Level" }) do
    LocalPlayer:GetAttributeChangedSignal(v23):Connect(xpChanged)
end

local Level = LocalPlayer:GetAttribute("Level")

if type(Level) ~= "number" or not Level then
    Level = 1
end

LevelStar.Level.Text = tostring(Level)
NextStar.Level.Text = tostring(Level + 1)
showBoosts(Level)

local v24 = LocalPlayer:GetAttribute("XP")
local XPNeed = LocalPlayer:GetAttribute("XPNeed")

Level = if type(v24) == "number" and type(XPNeed) == "number" and not (XPNeed <= 0) then math.clamp(v24 / XPNeed, 0, 1) else 0
NumberValue.Value = Level
Level = math.clamp(NumberValue.Value, 0, 1)
FillClip.Visible = Level > 0.001
FillClip.Size = UDim2.fromScale(math.max(Level, 0.001), 1)
Fill.Size = UDim2.fromScale(1 / math.max(Level, 0.001), 1)
Loc.Changed:Connect(function() -- line: 173
    -- upvalues: LocalPlayer (copy), LevelStar (copy), NextStar (copy), showFish (copy), showBoosts (copy)
    showFish()

    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    LevelStar.Level.Text = tostring(Level)
    NextStar.Level.Text = tostring(Level + 1)
    showBoosts(Level)
end)

local function popStar(p6, p7) -- line: 178
    -- upvalues: TweenService (copy), t1 (copy)
    local Pop = p6:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 0
        TweenService:Create(Pop, TweenInfo.new(t1.STAR_POP.Time, t1.STAR_POP.EasingStyle, t1.STAR_POP.EasingDirection, 0, false, p7), {
            Scale = 1
        }):Play()
    end
end

local function sweepFill() -- line: 185
    -- upvalues: TweenService (copy), LocalPlayer (copy), LevelStar (copy), NextStar (copy), t1 (copy), NumberValue (copy), v16 (ref), v18 (ref), xpChanged (copy), popStar (copy)
    v18 = true
    NumberValue.Value = 0

    local v27 = TweenInfo.new(t1.FILL_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, t1.FILL_FIRST)
    local XP = LocalPlayer:GetAttribute("XP")
    local XPNeed = LocalPlayer:GetAttribute("XPNeed")
    local tween = TweenService:Create(NumberValue, v27, {
        Value = if type(XP) == "number" and type(XPNeed) == "number" and not (XPNeed <= 0) then math.clamp(XP / XPNeed, 0, 1) else 0
    })

    tween.Completed:Once(function() -- line: 190
        -- upvalues: LocalPlayer (copy), NumberValue (copy), v16 (ref), v18 (ref), xpChanged (copy)
        v18 = false

        if not v16 then
            return
        end

        local Value = NumberValue.Value
        local XP = LocalPlayer:GetAttribute("XP")
        local XPNeed = LocalPlayer:GetAttribute("XPNeed")
        local n2 = 0

        if type(XP) == "number" and type(XPNeed) == "number" then
            n2 = if XPNeed <= 0 then 0 else math.clamp(XP / XPNeed, 0, 1)
        end

        if math.abs(Value - n2) > 0.001 then
            xpChanged()
        end
    end)
    tween:Play()
    popStar(LevelStar, t1.STAR_FIRST)
    popStar(NextStar, t1.FILL_FIRST + t1.FILL_TIME * 0.85)
end

local t6 = {}
local Frame

for _, child in ipairs(Tiles:GetChildren()) do
    Frame = child:IsA("Frame") and child:FindFirstChild("Card")

    if Frame then
        ButtonHover.Attach(Frame, {
            shine = false,
            tile = 1,
            buttonScale = t1.TILE_HOVER
        })
        t6[#t6 + 1] = {
            card = Frame,
            order = child.LayoutOrder
        }
    end
end

table.sort(t6, function(p8, p9) -- line: 208
    return p8.order < p9.order
end)

local function popTiles() -- line: 209
    -- upvalues: TweenService (copy), t1 (copy), t6 (copy)
    for v31, v32 in ipairs(t6) do
        local HoverScale = v32.card:FindFirstChild("HoverScale")

        if HoverScale then
            HoverScale.Scale = 0
            TweenService:Create(HoverScale, TweenInfo.new(t1.TILE_POP, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, t1.TILE_FIRST + (v31 - 1) * t1.TILE_STEP), {
                Scale = 1
            }):Play()
        end
    end
end

local function fitCanvas() -- line: 223
    -- upvalues: Tiles (copy), UIListLayout (copy)
    Tiles.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X, 0)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
Tiles.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X, 0)

local function fitBar() -- line: 230
    -- upvalues: Tiles (copy), t1 (copy)
    Tiles.ScrollBarThickness = math.max(2, (math.round(t1.SCROLL_BAR * Tiles.AbsoluteSize.Y)))
end

Tiles:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBar)
Tiles.ScrollBarThickness = math.max(2, (math.round(t1.SCROLL_BAR * Tiles.AbsoluteSize.Y)))

local Back = Main:WaitForChild("Back")
local Levels = Main:WaitForChild("LevelsClip"):WaitForChild("Levels")
local UIListLayout2 = Levels:WaitForChild("UIListLayout")
local Collapse = Levels:WaitForChild("Collapse")
local Template = Levels:WaitForChild("Template")
local t7 = {
    Profile,
    Main:WaitForChild("StreakTitle"),
    Tiles
}
local XPBarPosition = XPBar.Position
local ViewPosition = View.Position
local v36 = UDim2.fromScale(XPBarPosition.X.Scale, Levels:GetAttribute("BarTop") or 0.215)
local v37 = UDim2.fromScale(ViewPosition.X.Scale, Levels:GetAttribute("BackBottom") or 0.885)
local t8 = {
    ROW_FIRST = 0.18,
    ROW_STEP = 0.035,
    ROW_POP = 0.26,
    ROWS = 20,
    MOVE = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FOLD_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    FOLD_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SWAP_OUT = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    SWAP_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    LIST_OUT = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}
local v38 = View:GetAttribute("Corner") or 0.25

ButtonHover.Attach(View, {
    shine = false,
    tile = 1,
    highlight = true,
    icon = View:FindFirstChild("Icon"),
    highlightFade = t1.HIGHLIGHT_FADE,
    highlightCorner = v38,
    corner = v38
})
ButtonHover.Attach(Back, {
    shine = false,
    tile = 1
})

local HoverScale = View:WaitForChild("HoverScale")
local HoverScale2 = Back:WaitForChild("HoverScale")
local KeyConfig = require(Modules:WaitForChild("KeyConfig"))
local v39 = KeyConfig.KEYS[LevelRewards.KEY]

local function keyLook(p10, p11, p12) -- line: 285
    return {
        ColorSequence.new(p10, p11),
        p12
    }
end

local v40 = Color3.fromRGB(255, 225, 190)
local v41 = Color3.fromRGB(215, 120, 45)
local v42 = Color3.fromRGB(70, 30, 5)
local t9 = {}

t9.Wood = {
    ColorSequence.new(v40, v41),
    v42
}
v40 = Color3.fromRGB(240, 240, 245)
v41 = Color3.fromRGB(150, 155, 165)
v42 = Color3.fromRGB(40, 44, 52)
t9.Stone = {
    ColorSequence.new(v40, v41),
    v42
}
v40 = Color3.fromRGB(255, 245, 200)
v41 = Color3.fromRGB(255, 190, 30)
v42 = Color3.fromRGB(90, 50, 0)
t9.Gold = {
    ColorSequence.new(v40, v41),
    v42
}
v40 = Color3.fromRGB(255, 190, 190)
v41 = Color3.fromRGB(220, 40, 60)
v42 = Color3.fromRGB(80, 0, 12)
t9.Ruby = {
    ColorSequence.new(v40, v41),
    v42
}
v40 = Color3.fromRGB(220, 245, 255)
v41 = Color3.fromRGB(70, 175, 255)
v42 = Color3.fromRGB(8, 45, 95)
t9.Diamond = {
    ColorSequence.new(v40, v41),
    v42
}
v40 = Color3.fromRGB(225, 225, 235)
v41 = Color3.fromRGB(110, 110, 125)
v42 = Color3.fromRGB(15, 15, 20)
t9.Secret = {
    ColorSequence.new(v40, v41),
    v42
}

local Scale5 = Template.Body.Reward.Position.X.Scale
local v43 = Template.UIAspectRatioConstraint.AspectRatio * Template.Body.Size.X.Scale / Template.Body.Size.Y.Scale
local v44 = (v39.rect[3] - v39.rect[1]) / (v39.rect[4] - v39.rect[2]) / v43

local function dressReward(p13, p14) -- line: 298
    -- upvalues: LevelRewards (copy), Loc (copy), MoneyBoost (copy), LuckBoost (copy), KeyConfig (copy), v39 (copy), t9 (copy), Scale5 (copy), v44 (copy)
    local level = p14.level

    p13.Name = "Level" .. level .. (p14.kind == "Key" and p14.key or "")
    p13.Body.Star.Level.Text = tostring(level)

    local Reward = p13.Body.Reward

    Reward.AutoLocalize = false

    local Key = p13.Body:FindFirstChild("Key")

    if Key then
        Key:Destroy()
    end

    Reward.Position = UDim2.fromScale(Scale5, Reward.Position.Y.Scale)

    local v45, v46

    if p14.kind == "Money" then
        local t10 = {
            MoneyBoost.UIGradient.Color,
            MoneyBoost.UIStroke.Color
        }

        if t10 then
            v45 = t10
            v46 = true
        elseif p14.kind == "Luck" then
            local t11 = {
                LuckBoost.UIGradient.Color,
                LuckBoost.UIStroke.Color
            }

            if t11 then
                v45 = t11
                v46 = true
            else
                v46 = false
            end
        else
            v46 = false
        end
    elseif p14.kind == "Luck" then
        local t12 = {
            LuckBoost.UIGradient.Color,
            LuckBoost.UIStroke.Color
        }

        if t12 then
            v45 = t12
            v46 = true
        else
            v46 = false
        end
    else
        v46 = false
    end

    if not v46 then
        v45 = t9[p14.key] or t9.Ruby
    end

    local UIGradient, UIStroke = Reward.UIGradient, Reward.UIStroke
    local v47 = v45[1]
    local v48 = v45[2]

    UIGradient.Color = v47
    UIStroke.Color = v48

    if p14.kind == "Key" then
        local v49 = KeyConfig.KEYS[p14.key] or v39

        Reward.Text = Loc.T("+" .. p14.amount .. " " .. p14.key .. " key")

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Key"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = v49.image
        ImageLabel.ImageRectOffset = Vector2.new(v49.rect[1], v49.rect[2])
        ImageLabel.ImageRectSize = Vector2.new(v49.rect[3] - v49.rect[1], v49.rect[4] - v49.rect[2])
        ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
        ImageLabel.Position = UDim2.fromScale(Scale5, 0.5)
        ImageLabel.Size = UDim2.fromScale(v44, 1)
        ImageLabel.ZIndex = Reward.ZIndex
        ImageLabel.Parent = p13.Body
        Reward.Position = UDim2.fromScale(Scale5 - v44 - 0.01, Reward.Position.Y.Scale)
    else
        local v50 = p14.kind == "Money"
        local v51

        if v50 then
            local F = Loc.F
            local amount = p14.amount

            v51 = F("xp.money", "+{p}% Money", {
                p = LevelRewards.Percent(amount):gsub("%%$", "")
            })
        end

        if not v50 or not v51 then
            local F = Loc.F
            local amount = p14.amount

            v51 = F("xp.mutation_luck", "+{p}% Mutation luck", {
                p = LevelRewards.Percent(amount):gsub("%%$", "")
            })
        end

        Reward.Text = v51
    end
end

local t15 = {}

local function upcoming(p15) -- line: 335
    -- upvalues: LevelRewards (copy), t8 (copy)
    local t16 = {}
    local v52 = p15

    while #t16 < t8.ROWS do
        v52 = math.min(LevelRewards.Next(v52), (LevelRewards.Milestone(LevelRewards.MilestonesUpTo(v52) + 1)))

        local v55 = LevelRewards.At(v52)

        if v55 then
            t16[#t16 + 1] = {
                level = v52,
                kind = v55.kind,
                amount = v55.amount,
                key = v55.kind == "Key" and LevelRewards.KEY or nil
            }
        end

        local v57 = LevelRewards.MilestoneAt(v52)

        if v57 then
            t16[#t16 + 1] = {
                kind = "Key",
                amount = 1,
                level = v52,
                key = v57
            }
        end
    end

    while #t16 > t8.ROWS do
        table.remove(t16)
    end

    return t16
end

local function fillRows(p16) -- line: 349
    -- upvalues: Levels (copy), Template (copy), t8 (copy), dressReward (copy), t15 (copy), upcoming (copy)
    local v58 = upcoming(p16)

    for i = 1, t8.ROWS do
        local v59 = t15[i]

        if not v59 then
            v59 = Template:Clone()
            v59.LayoutOrder = i
            v59.Visible = true
            v59.Parent = Levels
            t15[i] = v59
        end

        dressReward(v59, v58[i])
    end
end

local function fitLevelsCanvas() -- line: 363
    -- upvalues: Levels (copy), UIListLayout2 (copy)
    Levels.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y)
end

UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitLevelsCanvas)

local function fitLevelsBar() -- line: 367
    -- upvalues: Levels (copy)
    Levels.ScrollBarThickness = math.max(2, (math.round(0.013740458015267175 * Levels.AbsoluteSize.Y)))
end

Levels:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitLevelsBar)
Levels.ScrollBarThickness = math.max(2, (math.round(0.013740458015267175 * Levels.AbsoluteSize.Y)))

local function showRows(p17) -- line: 373
    -- upvalues: TweenService (copy), Levels (copy), UIListLayout2 (copy), t8 (copy), t15 (copy)
    Levels.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y)

    local v64 = t15[1]
    local Y = v64 and v64.AbsoluteSize.Y or 0

    if Y <= 0 then
        return
    end

    local v66 = math.max(0, Levels.AbsoluteCanvasSize.Y - Levels.AbsoluteWindowSize.Y)

    Levels.CanvasPosition = Vector2.new(0, (math.clamp((p17 - 1) * Y, 0, v66)))

    local v69 = math.floor(Levels.CanvasPosition.Y / Y + 0.5) + 1
    local v71 = math.ceil(Levels.AbsoluteWindowSize.Y / Y) + 1

    for v72, v73 in pairs(t15) do
        local Pop = v73.Body.Pop

        if v69 <= v72 and v72 < v69 + v71 then
            Pop.Scale = 0
            TweenService:Create(Pop, TweenInfo.new(t8.ROW_POP, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, t8.ROW_FIRST + (v72 - v69) * t8.ROW_STEP), {
                Scale = 1
            }):Play()
        else
            Pop.Scale = 1
        end
    end
end

local v74 = false
local v75 = false

local function myLevel() -- line: 395
    -- upvalues: LocalPlayer (copy)
    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    return Level
end

local function levelsIn() -- line: 399
    -- upvalues: TweenService (copy), PanelFocus (copy), LocalPlayer (copy), XPBar (copy), View (copy), v17 (ref), Back (copy), Levels (copy), Collapse (copy), t7 (copy), ViewPosition (copy), v36 (copy), v37 (copy), t8 (copy), HoverScale (copy), HoverScale2 (copy), fillRows (copy), showRows (copy), v74 (ref), v75 (ref)
    if v17 or v75 or v74 then
        return
    end

    v75 = true
    v74 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

    for _, v76 in ipairs(t7) do
        local tween = TweenService:Create(v76.Collapse, t8.FOLD_OUT, {
            Scale = 0
        })

        tween.Completed:Once(function(p18) -- line: 406
            -- upvalues: v76 (copy), v74 (ref)
            if p18 == Enum.PlaybackState.Completed and v74 then
                v76.Visible = false
            end
        end)
        tween:Play()
    end

    TweenService:Create(XPBar, t8.MOVE, {
        Position = v36
    }):Play()
    TweenService:Create(HoverScale, t8.SWAP_OUT, {
        Scale = 0
    }):Play()
    task.delay(t8.SWAP_OUT.Time, function() -- line: 414
        -- upvalues: View (copy), v74 (ref)
        if v74 then
            View.Visible = false
        end
    end)
    Back.Position = ViewPosition
    HoverScale2.Scale = 0
    Back.Visible = true
    TweenService:Create(HoverScale2, t8.SWAP_IN, {
        Scale = 1
    }):Play()
    TweenService:Create(Back, t8.MOVE, {
        Position = v37
    }):Play()
    task.delay(t8.MOVE.Time, function() -- line: 420
        -- upvalues: v74 (ref), v75 (ref)
        if v74 then
            v75 = false
        end
    end)

    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    fillRows(Level)
    Collapse.Scale = 1
    Levels.Visible = true
    showRows(1)
end

local function levelsOut() -- line: 427
    -- upvalues: TweenService (copy), PanelFocus (copy), XPBar (copy), View (copy), v17 (ref), Back (copy), Levels (copy), Collapse (copy), t7 (copy), XPBarPosition (copy), ViewPosition (copy), v37 (copy), t8 (copy), HoverScale (copy), HoverScale2 (copy), v74 (ref), v75 (ref)
    if v17 or v75 or not v74 then
        return
    end

    v75 = true
    v74 = false
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)

    local tween = TweenService:Create(Collapse, t8.LIST_OUT, {
        Scale = 0
    })

    tween.Completed:Once(function(p19) -- line: 432
        -- upvalues: Levels (copy), v74 (ref)
        if p19 == Enum.PlaybackState.Completed and not v74 then
            Levels.Visible = false
        end
    end)
    tween:Play()
    TweenService:Create(XPBar, t8.MOVE, {
        Position = XPBarPosition
    }):Play()
    TweenService:Create(HoverScale2, t8.SWAP_OUT, {
        Scale = 0
    }):Play()
    task.delay(t8.SWAP_OUT.Time, function() -- line: 437
        -- upvalues: Back (copy), v74 (ref)
        if not v74 then
            Back.Visible = false
        end
    end)
    View.Position = v37
    HoverScale.Scale = 0
    View.Visible = true
    TweenService:Create(HoverScale, t8.SWAP_IN, {
        Scale = 1
    }):Play()
    TweenService:Create(View, t8.MOVE, {
        Position = ViewPosition
    }):Play()
    task.delay(t8.MOVE.Time, function() -- line: 443
        -- upvalues: v74 (ref), v75 (ref)
        if not v74 then
            v75 = false
        end
    end)

    for _, v77 in ipairs(t7) do
        v77.Collapse.Scale = 0
        v77.Visible = true
        TweenService:Create(v77.Collapse, t8.FOLD_IN, {
            Scale = 1
        }):Play()
    end
end

local function levelsReset() -- line: 451
    -- upvalues: XPBar (copy), View (copy), Back (copy), Levels (copy), Collapse (copy), t7 (copy), XPBarPosition (copy), ViewPosition (copy), HoverScale (copy), HoverScale2 (copy), v74 (ref), v75 (ref)
    v74 = false
    v75 = false

    for _, v78 in ipairs(t7) do
        v78.Visible = true
        v78.Collapse.Scale = 1
    end

    XPBar.Position = XPBarPosition
    View.Visible = true
    HoverScale.Scale = 1
    View.Position = ViewPosition
    Back.Visible = false
    HoverScale2.Scale = 1
    Back.Position = ViewPosition
    Levels.Visible = false
    Collapse.Scale = 1
end

levelsReset()
View.Activated:Connect(levelsIn)
Back.Activated:Connect(levelsOut)

local t18 = {
    XP = {
        panel = Panel,
        scale = Scale,
        tab = XP
    },
    Leaderboards = {
        panel = Leaderboards2,
        scale = Scale3,
        tab = Leaderboards
    },
    Achievements = {
        panel = Achievements2,
        scale = Scale4,
        tab = Achievements
    }
}
local PanelPosition = Panel.Position
local v79 = Random.new()
local v80 = "XP"

local function twist() -- line: 476
    -- upvalues: v79 (copy)
    if v79:NextInteger(0, 1) == 0 then
        return -15
    end

    return 15
end

local function enterXP() -- line: 478
    -- upvalues: LocalPlayer (copy), LevelStar (copy), NextStar (copy), Tiles (copy), v1 (ref), showFish (copy), IndexRecords (copy), showBoosts (copy), sweepFill (copy), popTiles (copy)
    task.spawn(function() -- line: 109
        -- upvalues: v1 (ref), showFish (copy), IndexRecords (copy)
        local InvokeServer = IndexRecords.InvokeServer
        local v81, _, v82 = pcall(InvokeServer, IndexRecords)

        if v81 and type(v82) == "table" then
            v1 = v82
            showFish()
        end
    end)

    local Level = LocalPlayer:GetAttribute("Level")

    if type(Level) ~= "number" or not Level then
        Level = 1
    end

    LevelStar.Level.Text = tostring(Level)
    NextStar.Level.Text = tostring(Level + 1)
    showBoosts(Level)
    Tiles.CanvasPosition = Vector2.zero
    sweepFill()
    popTiles()
end

local function hideAll() -- line: 486
    -- upvalues: Side (copy), Leaderboards3 (copy), Achievements3 (copy), levelsReset (copy), t18 (copy), PanelPosition (copy), v80 (ref)
    for _, v84 in pairs(t18) do
        v84.panel.Visible = false

        local panel, panel2 = v84.panel, v84.panel

        panel.Position = PanelPosition
        panel2.Rotation = 0
    end

    Side.Visible = false
    levelsReset()
    Leaderboards3.Hidden()
    Achievements3.Hidden()
    v80 = "XP"
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local close

local function open(p20) -- line: 502
    -- upvalues: TweenService (copy), PanelFocus (copy), LocalPlayer (copy), XPGui (copy), Panel (copy), Close (copy), LevelStar (copy), NextStar (copy), Tiles (copy), Side (copy), Scale2 (copy), Leaderboards3 (copy), Achievements2 (copy), Achievements3 (copy), v1 (ref), showFish (copy), IndexRecords (copy), showBoosts (copy), v16 (ref), v17 (ref), sweepFill (copy), popTiles (copy), t18 (copy), PanelPosition (copy), v80 (ref), PadMenu (copy), close (ref)
    if v17 or v16 then
        return
    end

    v17 = true
    v16 = true
    v80 = t18[p20] and p20 or "XP"

    local v85 = t18[v80]

    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    PanelFocus.MakeWay(function() -- line: 508
        -- upvalues: v16 (ref)
        return v16
    end)
    Leaderboards3.Prefetch()

    if v85.panel == Panel then
        task.spawn(function() -- line: 109
            -- upvalues: v1 (ref), showFish (copy), IndexRecords (copy)
            local InvokeServer = IndexRecords.InvokeServer
            local v86, _, v87 = pcall(InvokeServer, IndexRecords)

            if v86 and type(v87) == "table" then
                v1 = v87
                showFish()
            end
        end)

        local Level = LocalPlayer:GetAttribute("Level")
        local v88 = type(Level) == "number" and Level or 1

        LevelStar.Level.Text = tostring(v88)
        NextStar.Level.Text = tostring(v88 + 1)
        showBoosts(v88)
        Tiles.CanvasPosition = Vector2.zero
        sweepFill()
        popTiles()
    elseif v85.panel == Achievements2 then
        Achievements3.Shown()
    else
        Leaderboards3.Shown()
    end

    local panel, panel2 = v85.panel, v85.panel

    panel.Position = PanelPosition
    panel2.Rotation = 0

    local scale = v85.scale
    local FROM, FROM2 = PanelFocus.FEEL.FROM, PanelFocus.FEEL.FROM

    scale.Scale = FROM
    Scale2.Scale = FROM2
    v85.panel.Visible = true
    Side.Visible = true
    PanelFocus.Focus(true)
    TweenService:Create(Scale2, PanelFocus.popIn, {
        Scale = 1
    }):Play()

    local tween = TweenService:Create(v85.scale, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 517
        -- upvalues: v17 (ref)
        v17 = false
    end)
    tween:Play()
    PadMenu.Open(XPGui, function() -- line: 519
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close
    })
end

local function close2() -- line: 521
    -- upvalues: TweenService (copy), PanelFocus (copy), XPGui (copy), Scale2 (copy), Leaderboards3 (copy), v16 (ref), v17 (ref), v75 (ref), t18 (copy), v80 (ref), hideAll (copy), PadMenu (copy)
    if v17 or not v16 or v75 or Leaderboards3.Busy() then
        return
    end

    v17 = true
    v16 = false
    PadMenu.Close(XPGui)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)

    local v90 = t18[v80]

    TweenService:Create(Scale2, PanelFocus.popOut, {
        Scale = 0
    }):Play()

    local tween = TweenService:Create(v90.scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 530
        -- upvalues: PanelFocus (copy), v17 (ref), hideAll (copy)
        hideAll()
        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 533
            -- upvalues: v17 (ref)
            v17 = false
        end)
    end)
    tween:Play()
end

local function tabSpot(p21) -- line: 538
    -- upvalues: XPGui (copy), Side (copy)
    local v91 = p21.AbsolutePosition + p21.AbsoluteSize / 2 - XPGui.AbsolutePosition

    return UDim2.fromScale(v91.X / XPGui.AbsoluteSize.X, v91.Y / XPGui.AbsoluteSize.Y), p21.AbsoluteSize.X / math.max(Side.AbsoluteSize.X, 1)
end

local function switchTo(p22) -- line: 543
    -- upvalues: TweenService (copy), PanelFocus (copy), LocalPlayer (copy), XPGui (copy), Panel (copy), LevelStar (copy), NextStar (copy), Tiles (copy), Side (copy), Leaderboards3 (copy), Achievements2 (copy), Achievements3 (copy), v1 (ref), showFish (copy), IndexRecords (copy), showBoosts (copy), v16 (ref), v17 (ref), sweepFill (copy), popTiles (copy), v75 (ref), levelsReset (copy), t18 (copy), PanelPosition (copy), v79 (copy), v80 (ref)
    local v93, v94, v95, panel, panel2, scale, v96, v97

    if v17 then
        v97 = true
    elseif not v16 or v80 == p22 or v75 or Leaderboards3.Busy() then
        v97 = true
    else
        v17 = true

        local v98 = t18[v80]

        v93 = t18[p22]
        v80 = p22
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

        local panel3 = v98.panel
        local panel4 = v93.panel

        panel3.ZIndex = 4
        panel4.ZIndex = 5

        local tween = TweenService:Create(v98.scale, PanelFocus.popOut, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 551
            -- upvalues: p22 (copy), v98 (copy), Panel (copy), Leaderboards3 (copy), Achievements2 (copy), Achievements3 (copy), levelsReset (copy), PanelPosition (copy), v80 (ref)
            if v80 ~= p22 then
                return
            end

            v98.panel.Visible = false

            local panel, panel2 = v98.panel, v98.panel

            panel.Position = PanelPosition
            panel2.Rotation = 0

            if v98.panel == Panel then
                levelsReset()
            elseif v98.panel == Achievements2 then
                Achievements3.Hidden()
            else
                Leaderboards3.Hidden()
            end
        end)
        tween:Play()

        local tab = v93.tab
        local v99 = tab.AbsolutePosition + tab.AbsoluteSize / 2 - XPGui.AbsolutePosition

        v94 = UDim2.fromScale(v99.X / XPGui.AbsoluteSize.X, v99.Y / XPGui.AbsoluteSize.Y)
        v95 = tab.AbsoluteSize.X / math.max(Side.AbsoluteSize.X, 1)
        panel = v93.panel
        panel2 = v93.panel
        scale = v93.scale
        v96 = if v79:NextInteger(0, 1) == 0 then -15 else 15
        v97 = false
    end

    if v97 then
        return
    end

    panel.Position = v94
    panel2.Rotation = v96
    scale.Scale = v95
    v93.panel.Visible = true

    if v93.panel == Panel then
        task.spawn(function() -- line: 109
            -- upvalues: v1 (ref), showFish (copy), IndexRecords (copy)
            local InvokeServer = IndexRecords.InvokeServer
            local v100, _, v101 = pcall(InvokeServer, IndexRecords)

            if v100 and type(v101) == "table" then
                v1 = v101
                showFish()
            end
        end)

        local Level = LocalPlayer:GetAttribute("Level")
        local v102 = type(Level) == "number" and Level or 1

        LevelStar.Level.Text = tostring(v102)
        NextStar.Level.Text = tostring(v102 + 1)
        showBoosts(v102)
        Tiles.CanvasPosition = Vector2.zero
        sweepFill()
        popTiles()
    elseif v93.panel == Achievements2 then
        Achievements3.Shown()
    else
        Leaderboards3.Shown()
    end

    TweenService:Create(v93.panel, PanelFocus.popIn, {
        Rotation = 0,
        Position = PanelPosition
    }):Play()

    local tween = TweenService:Create(v93.scale, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 564
        -- upvalues: v17 (ref)
        v17 = false
    end)
    tween:Play()
end

local Badge = require(Modules:WaitForChild("Badge"))
local RewardScreen = require(Modules:WaitForChild("RewardScreen"))
local DailyClaim = Remotes:WaitForChild("DailyClaim")
local v104 = Badge.Attach(Button, {
    text = "!",
    size = 0.6,
    period = 1.2,
    icon = Button:FindFirstChild("Icon"),
    at = Vector2.new(0.9, 0.1)
})
local t19 = {
    text = "!",
    size = 0.34,
    zIndex = 6,
    at = Vector2.new(0.12, 0.32)
}
local t20 = {}

for v105, v106 in ipairs(t6) do
    t20[v105] = Badge.Attach(v106.card, t19)
end

local function fitStrike(p23) -- line: 591
    local Strike = p23:FindFirstChild("Strike")

    if not (Strike and p23.AbsoluteSize.X > 0) then
        return
    end

    Strike.Size = UDim2.fromScale(math.min(1, p23.TextBounds.X / p23.AbsoluteSize.X * 1.2), Strike.Size.Y.Scale)
end

local function dressClaimed() -- line: 597
    -- upvalues: LocalPlayer (copy), t6 (copy)
    local v108 = LocalPlayer:GetAttribute("DailyClaimed") or 0

    for v109, v110 in ipairs(t6) do
        local v111 = v109 <= v108
        local v112 = if v111 then 0.45 else 0

        v110.card.ImageTransparency = v112

        local Icon = v110.card:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v112
        end

        local MimicView = v110.card:FindFirstChild("MimicView")

        if MimicView then
            MimicView.Viewport.ImageTransparency = v112
        end

        local Count = v110.card:FindFirstChild("Count")
        local Strike = Count and Count:FindFirstChild("Strike")

        if Strike then
            Strike.Visible = v111

            local Strike2 = Count:FindFirstChild("Strike")

            if Strike2 and Count.AbsoluteSize.X > 0 then
                Strike2.Size = UDim2.fromScale(math.min(1, Count.TextBounds.X / Count.AbsoluteSize.X * 1.2), Strike2.Size.Y.Scale)
            end
        end
    end
end

for _, v114 in ipairs(t6) do
    local Count = v114.card:FindFirstChild("Count")

    if Count then
        Count:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 618
            -- upvalues: Count (copy)
            local Strike = Count:FindFirstChild("Strike")

            if not (Strike and Count.AbsoluteSize.X > 0) then
                return
            end

            Strike.Size = UDim2.fromScale(math.min(1, Count.TextBounds.X / Count.AbsoluteSize.X * 1.2), Strike.Size.Y.Scale)
        end)
        Count:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 619
            -- upvalues: Count (copy)
            local Strike = Count:FindFirstChild("Strike")

            if not (Strike and Count.AbsoluteSize.X > 0) then
                return
            end

            Strike.Size = UDim2.fromScale(math.min(1, Count.TextBounds.X / Count.AbsoluteSize.X * 1.2), Strike.Size.Y.Scale)
        end)
    end
end

local t21 = {}
local t22 = {}
local Day

for v117, v118 in ipairs(t6) do
    Day = v118.card:FindFirstChild("Day")

    if Day then
        local Text = Day.Text

        t21[v117] = Day
        t22[v117] = Text
    end
end

local function secondsLeft() -- line: 634
    -- upvalues: LocalPlayer (copy)
    local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")

    return DailyOpensAt and DailyOpensAt + 1 - workspace:GetServerTimeNow() or nil
end

local function readyTile() -- line: 639
    -- upvalues: LocalPlayer (copy)
    local DailyReady = LocalPlayer:GetAttribute("DailyReady")

    if DailyReady then
        return DailyReady
    end

    local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")
    local v119 = DailyOpensAt and DailyOpensAt + 1 - workspace:GetServerTimeNow() or nil

    return if v119 and v119 <= 0 then (LocalPlayer:GetAttribute("DailyClaimed") or 0) + 1 else nil
end

local function clockText(p24) -- line: 646
    local v121 = math.max(0, (math.floor(p24)))

    return string.format("%d:%02d:%02d", v121 // 3600, v121 % 3600 // 60, v121 % 60)
end

local n3 = 0
local v122

v122 = function() -- line: 652
    -- upvalues: v122 (ref), LocalPlayer (copy), Achievements3 (copy), v104 (copy), t20 (copy), dressClaimed (copy), t21 (copy), t22 (copy), n3 (ref)
    local DailyReady = LocalPlayer:GetAttribute("DailyReady")

    if not DailyReady then
        local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")
        local v123 = DailyOpensAt and DailyOpensAt + 1 - workspace:GetServerTimeNow() or nil

        DailyReady = if not (v123 and v123 <= 0) then nil else (LocalPlayer:GetAttribute("DailyClaimed") or 0) + 1
    end

    v104.Set((DailyReady or Achievements3.NewCount() > 0) and 1 or 0)

    for v124, v125 in ipairs(t20) do
        v125.Set(v124 == DailyReady and 1 or 0)
    end

    dressClaimed()

    local v126 = not DailyReady
    local v127, v128

    if v126 then
        local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")

        if DailyOpensAt then
            local v129 = DailyOpensAt + 1 - workspace:GetServerTimeNow()

            if v129 then
                v127 = v129
                v128 = true
            else
                v128 = false
            end
        else
            v128 = false
        end
    else
        v127 = v126
        v128 = true
    end

    if not v128 then
        v127 = nil
    end

    local v130, v131

    if v127 and v127 > 0 then
        local v132 = (LocalPlayer:GetAttribute("DailyClaimed") or 0) + 1

        if v132 then
            v130 = v132
            v131 = true
        else
            v131 = false
        end
    else
        v131 = false
    end

    if not v131 then
        v130 = nil
    end

    for v133, v134 in pairs(t21) do
        if v133 ~= v130 then
            v134.Text = t22[v133]
        end
    end

    n3 += 1

    local v135 = n3
    local v136 = v130 and t21[v130]

    if v136 then
        task.spawn(function() -- line: 667
            -- upvalues: v135 (copy), v136 (copy), v122 (ref), LocalPlayer (copy), n3 (ref)
            while true do
                if v135 == n3 then
                    local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")
                    local v137 = if DailyOpensAt then DailyOpensAt + 1 - workspace:GetServerTimeNow() else nil
                    local v138 = if not DailyOpensAt or not v137 then nil else v137
                    local wait, v139

                    if not v138 or v138 <= 0 then
                        break
                    else
                        local v142 = math.max(0, (math.floor(v138)))

                        v136.Text = string.format("%d:%02d:%02d", v142 // 3600, v142 % 3600 // 60, v142 % 60)

                        local v143 = v138 % 1

                        wait = task.wait
                        v139 = v143 > 0.05 and v143 or 1
                    end

                    wait(v139)
                    continue
                end

                return
            end

            v122()
        end)
    end
end

LocalPlayer:GetAttributeChangedSignal("DailyReady"):Connect(v122)
LocalPlayer:GetAttributeChangedSignal("DailyClaimed"):Connect(v122)
LocalPlayer:GetAttributeChangedSignal("DailyOpensAt"):Connect(v122)
v122()
Achievements3.OnNew(function() -- line: 683
    -- upvalues: LocalPlayer (copy), Achievements3 (copy), v104 (copy)
    local Set = v104.Set
    local DailyReady = LocalPlayer:GetAttribute("DailyReady")

    if not DailyReady then
        local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")
        local v144 = DailyOpensAt and DailyOpensAt + 1 - workspace:GetServerTimeNow() or nil

        DailyReady = if not (v144 and v144 <= 0) then nil else (LocalPlayer:GetAttribute("DailyClaimed") or 0) + 1
    end

    Set((DailyReady or Achievements3.NewCount() > 0) and 1 or 0)
end)

local DailyConfig = require(Modules:WaitForChild("DailyConfig"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local MimicConfig = require(Modules:WaitForChild("MimicConfig"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local RunService = game:GetService("RunService")
local v145 = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
local t23 = {
    FOV = 40,
    BOB = 0.25,
    BOB_SPEED = 2.2,
    CAM = CFrame.lookAt(Vector3.new(0, -1.1, 10), (Vector3.new(0, -1.1, 0)))
}
local v146 = CFrame.Angles(-1.5707963267948966, 0, 0)
local PrimaryPart, v147

local function buildMimicView(p25) -- line: 702
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), RarityDisplay (copy), MimicConfig (copy), RarityStyle (copy), t23 (copy), v146 (copy), PrimaryPart (ref), v147 (ref)
    p25.Rarity.Text = RarityDisplay.Exclusive.display
    RarityStyle.Apply(p25.Rarity, RarityDisplay.Exclusive.color)
    p25.Title.Text = string.upper(MimicConfig.NAME)
    p25.Boost.Text = "+" .. MimicConfig.Boost(1) .. "%"
    p25.Visible = true
    task.spawn(function() -- line: 708
        -- upvalues: p25 (copy), ReplicatedStorage (copy), LocalPlayer (copy), t23 (copy), v146 (copy), PrimaryPart (ref), v147 (ref)
        local v148 = ReplicatedStorage:WaitForChild("MimicPreviews"):WaitForChild((tostring(LocalPlayer.UserId)))
        local clone = v148:Clone()
        local PrimaryPart2 = clone.PrimaryPart
        local Humanoid = clone:FindFirstChildOfClass("Humanoid")

        if not PrimaryPart2 then
            clone:Destroy()

            return
        end

        v147 = CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(-1, 0, 0))) * v146
        clone:PivotTo(v147)
        clone.Parent = p25.Viewport.World
        PrimaryPart = PrimaryPart2

        local Camera = Instance.new("Camera")

        Camera.FieldOfView = t23.FOV
        Camera.CFrame = t23.CAM
        Camera.Parent = p25.Viewport
        p25.Viewport.CurrentCamera = Camera

        local SwimId = v148:GetAttribute("SwimId")

        if Humanoid and SwimId then
            local v150 = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            local Animation = Instance.new("Animation")

            Animation.AnimationId = SwimId

            local function v151() -- line: 729
                -- upvalues: Animation (copy), v150 (copy)
                return v150:LoadAnimation(Animation)
            end

            local ok, result = pcall(v151)

            if ok and result then
                result.Looped = true
                result:Play()
            end
        end
    end)
end

RunService.RenderStepped:Connect(function() -- line: 737
    -- upvalues: v16 (ref), t23 (copy), PrimaryPart (ref), v147 (ref)
    if not (PrimaryPart and v16) then
        return
    end

    PrimaryPart.CFrame = v147 + Vector3.new(0, math.sin(os.clock() * t23.BOB_SPEED) * t23.BOB, 0)
end)

local v155 = false
local t24 = {
    HellEgg = "rbxassetid://132837374984423",
    MassiveEgg = "rbxassetid://92978738810887",
    VoidEgg = "rbxassetid://110465827776065"
}

local function dressTiles(p26) -- line: 749
    -- upvalues: t6 (copy), KeyConfig (copy), DailyConfig (copy), v145 (copy), buildMimicView (copy), v155 (ref), t24 (copy)
    for v156 in ipairs(DailyConfig.DAYS) do
        local v157 = DailyConfig.Day(v156, p26)
        local v158 = t6[v156] and t6[v156].card
        local v159, v160

        if v158 then
            v159 = v158:FindFirstChild("Icon")
            v160 = v158:FindFirstChild("Count")
            v158 = v158:FindFirstChild("MimicView")
        else
            v160 = v158
            v159 = v158
        end

        if v159 then
            if v157.mimic then
                if v158 then
                    v159.Visible = false

                    if v155 then
                        v158.Visible = true
                    else
                        v155 = true
                        buildMimicView(v158)
                    end
                else
                    v159.Image = v145

                    local zero, zero2 = Vector2.zero, Vector2.zero

                    v159.ImageRectOffset = zero
                    v159.ImageRectSize = zero2
                end

                if v160 then
                    v160.Text = "x1"
                end
            elseif v157.egg and t24[v157.egg] then
                if v158 then
                    v158.Visible = false
                end

                v159.Visible = true
                v159.Image = t24[v157.egg]

                local zero, zero2 = Vector2.zero, Vector2.zero

                v159.ImageRectOffset = zero
                v159.ImageRectSize = zero2

                if v160 then
                    v160.Text = "x1"
                end
            elseif v157.key and KeyConfig.KEYS[v157.key] then
                if v158 then
                    v158.Visible = false
                end

                v159.Visible = true

                local v161 = KeyConfig.KEYS[v157.key]

                v159.Image = v161.image
                v159.ImageRectOffset = Vector2.new(v161.rect[1], v161.rect[2])
                v159.ImageRectSize = Vector2.new(v161.rect[3] - v161.rect[1], v161.rect[4] - v161.rect[2])

                if v160 then
                    v160.Text = "x" .. v157.count
                end
            end
        end
    end
end

dressTiles(LocalPlayer:GetAttribute("DailyLoop") or 1)
LocalPlayer:GetAttributeChangedSignal("DailyLoop"):Connect(function() -- line: 783
    -- upvalues: LocalPlayer (copy), dressTiles (copy)
    dressTiles(LocalPlayer:GetAttribute("DailyLoop") or 1)
end)

local Exclusive = RarityDisplay.Exclusive

local function keyReward(p27) -- line: 788
    -- upvalues: KeyConfig (copy), v145 (copy), Exclusive (copy)
    if p27.mimic then
        return {
            setup = function(p28) -- setup | line: 791
                -- upvalues: v145 (copy), Exclusive (copy)
                p28.Main.Icon.Image = v145
                p28.Main.Title.Text = "Mimic"
                p28.Main.Rarity.Text = Exclusive.display

                local UIGradient = p28.Main.Rarity:FindFirstChildOfClass("UIGradient")

                if UIGradient then
                    UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 120, 130), Exclusive.color)
                end
            end
        }
    end

    return {
        setup = function(p29) -- setup | line: 801
            -- upvalues: p27 (copy), KeyConfig (copy)
            local v162 = KeyConfig.KEYS[p27.key]
            local Icon = p29.Main.Icon

            if v162 then
                Icon.Image = v162.image
                Icon.ImageRectOffset = Vector2.new(v162.rect[1], v162.rect[2])
                Icon.ImageRectSize = Vector2.new(v162.rect[3] - v162.rect[1], v162.rect[4] - v162.rect[2])
            end

            p29.Main.Title.Text = p27.key .. " Key"
            p29.Main.Rarity.Text = "x" .. p27.count
        end
    }
end

local v163 = false
local GuiService = game:GetService("GuiService")
local v164

for v165, v166 in ipairs(t6) do
    local CanvasPosition = nil

    v166.card.Selectable = true

    local function isPress(p30) -- line: 825
        if p30.UserInputType == Enum.UserInputType.MouseButton1 then
            return true
        end

        return p30.UserInputType == Enum.UserInputType.Touch
    end

    v166.card.InputBegan:Connect(function(p31) -- line: 828
        -- upvalues: Tiles (copy), CanvasPosition (ref)
        if p31.UserInputType == Enum.UserInputType.MouseButton1 or p31.UserInputType == Enum.UserInputType.Touch then
            CanvasPosition = Tiles.CanvasPosition
        end
    end)
    v166.card.InputEnded:Connect(function(p32) -- line: 831
        -- upvalues: Tiles (copy), v164 (ref), CanvasPosition (ref), v166 (copy), v165 (copy)
        if not ((p32.UserInputType == Enum.UserInputType.MouseButton1 or p32.UserInputType == Enum.UserInputType.Touch) and CanvasPosition) then
            return
        end

        local Magnitude = (Tiles.CanvasPosition - CanvasPosition).Magnitude

        CanvasPosition = nil

        if not (Magnitude > 8) then
            v164(v165, v166)
        end
    end)
end

v164 = function(p33, p34) -- line: 839
    -- upvalues: ButtonHover (copy), LocalPlayer (copy), close2 (copy), RewardScreen (copy), DailyClaim (copy), keyReward (copy), v163 (ref)
    if v163 then
        return
    end

    local DailyReady = LocalPlayer:GetAttribute("DailyReady")

    if not DailyReady then
        local DailyOpensAt = LocalPlayer:GetAttribute("DailyOpensAt")

        if DailyOpensAt then
            local v167 = DailyOpensAt + 1 - workspace:GetServerTimeNow()

            DailyReady = if v167 and v167 <= 0 then (LocalPlayer:GetAttribute("DailyClaimed") or 0) + 1 else nil
        else
            DailyReady = nil
        end
    end

    if DailyReady ~= p33 then
        return
    end

    v163 = true
    ButtonHover.Press(p34.card)
    task.spawn(function() -- line: 844
        -- upvalues: p33 (copy), close2 (copy), RewardScreen (copy), DailyClaim (copy), keyReward (copy), v163 (ref)
        local function v168() -- line: 845
            -- upvalues: p33 (copy), DailyClaim (copy)
            return DailyClaim:InvokeServer(p33)
        end

        local ok, result = pcall(v168)

        if ok and type(result) == "table" and result[1] and result[1].egg then
            close2()
        elseif ok and type(result) == "table" and #result > 0 then
            local t26 = {}

            for _, v169 in ipairs(result) do
                table.insert(t26, (keyReward(v169)))
            end

            RewardScreen.Show(t26)
        end

        v163 = false
    end)
end

game:GetService("UserInputService").InputBegan:Connect(function(p35) -- line: 858
    -- upvalues: t6 (copy), GuiService (copy), v164 (ref)
    if p35.KeyCode ~= Enum.KeyCode.ButtonA then
        return
    end

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject then
        for v171, v172 in ipairs(t6) do
            if SelectedObject == v172.card then
                v164(v171, v172)

                return
            end
        end
    end
end)

for v173, v174 in pairs(t18) do
    ButtonHover.Attach(v174.tab, {
        shine = false,
        tile = 1,
        highlight = true,
        highlightFade = t1.HIGHLIGHT_FADE,
        highlightCorner = v38,
        corner = v38
    })
    v174.tab.Activated:Connect(function() -- line: 871
        -- upvalues: ButtonHover (copy), switchTo (copy), v174 (copy), v173 (copy)
        ButtonHover.Press(v174.tab)
        switchTo(v173)
    end)
end

close = close2
Leaderboards3.Init({
    close = function() -- close | line: 877
        -- upvalues: close2 (copy)
        close2()
    end
})

local InputBegan = Achievements3.Init
local t27 = {}

function t27.close() -- line: 878
    -- upvalues: close2 (copy)
    close2()
end

t27.tab = Achievements
InputBegan(t27)
Button.Activated:Connect(open)
Close.Activated:Connect(close2)
LocalPlayer:GetAttributeChangedSignal("OpenAchievements"):Connect(function() -- line: 884
    -- upvalues: LocalPlayer (copy), v16 (ref), v17 (ref), open (copy), switchTo (copy)
    if not LocalPlayer:GetAttribute("OpenAchievements") then
        return
    end

    local v175 = LocalPlayer.PlayerGui:FindFirstChild("ShopGui") and LocalPlayer.PlayerGui.ShopGui:FindFirstChild("Panel")

    task.spawn(function() -- line: 887
        -- upvalues: v175 (copy), LocalPlayer (copy), v16 (ref), v17 (ref), open (copy), switchTo (copy)
        local elapsed = os.clock()

        while true do
            if (v175 and v175.Visible or v17) and os.clock() - elapsed < 3 then
                task.wait()
                continue
            end

            break
        end

        LocalPlayer:SetAttribute("OpenAchievements", nil)

        if v16 then
            switchTo("Achievements")
        else
            open("Achievements")
        end
    end)
end)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 895
    -- upvalues: PanelFocus (copy), XPGui (copy), v16 (ref), v17 (ref), hideAll (copy), PadMenu (copy)
    if not v16 then
        return
    end

    v16 = false
    v17 = false
    PadMenu.Close(XPGui)
    PanelFocus.Focus(false, true)
    hideAll()
    PanelFocus.GiveBackRight()
end)

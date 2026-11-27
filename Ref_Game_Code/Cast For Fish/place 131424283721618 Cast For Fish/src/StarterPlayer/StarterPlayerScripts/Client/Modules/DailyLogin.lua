-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local DailyRewards = require(Shared.Data.DailyRewards)
local Buffs = require(Shared.Data.Buffs)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local Toasts = require(script.Parent.Toasts)
local HUD = require(script.Parent.HUD)
local Windows = require(script.Parent.Windows)
local TopBar = require(script.Parent.TopBar)
local BuffHud = require(script.Parent.BuffHud)
local LocalPlayer = Players.LocalPlayer
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local v2 = fromRGB(255, 255, 255)
local v3 = utf8.char(10003)
local t1 = {
    {
        fromRGB(110, 190, 255),
        fromRGB(40, 90, 210)
    },
    {
        fromRGB(110, 190, 255),
        fromRGB(40, 90, 210)
    },
    {
        fromRGB(110, 190, 255),
        fromRGB(40, 90, 210)
    },
    {
        fromRGB(200, 130, 255),
        fromRGB(110, 50, 210)
    },
    {
        fromRGB(200, 130, 255),
        fromRGB(110, 50, 210)
    },
    {
        fromRGB(200, 130, 255),
        fromRGB(110, 50, 210)
    },
    {
        fromRGB(255, 120, 200),
        fromRGB(255, 190, 60)
    }
}
local t2 = {
    { 0, 10, 0, 80 },
    { -34, 18, -14, 66 },
    { 34, 18, 14, 66 }
}
local t3 = {}

t3.__index = t3

function t3.new() -- line: 46
    -- upvalues: t3 (copy)
    local self = setmetatable({}, t3)

    self.Tiles = {}
    self.Claiming = false
    self.AutoOpened = false
    self.Blocked = nil
    self.Claimed = 0
    self.Celebrations = 0
    self.LastResult = nil
    self.HoldTime = 1.7

    return self
end

function t3.Now(_) -- line: 59
    return workspace:GetServerTimeNow()
end

function t3:State() -- line: 63
    -- upvalues: DailyRewards (copy), DataClient (copy)
    return DailyRewards.State(DataClient.Get("DailyLogin"), DailyRewards.Today(self:Now()))
end

function t3.Clock(_, p4) -- line: 67
    local v6 = math.max(0, (math.floor(p4)))

    return string.format("%02d:%02d:%02d", v6 // 3600, v6 % 3600 // 60, v6 % 60)
end

function t3.RewardText(_, p6) -- line: 72
    -- upvalues: DailyRewards (copy), NumberFormat (copy), LocalPlayer (copy)
    if p6.kind == "cash" then
        return NumberFormat.money(DailyRewards.Cash(p6, LocalPlayer:GetAttribute("IncomePerSecond") or 0)) .. " Cash"
    end

    if p6.kind == "lucky" then
        return p6.n .. " Lucky Casts"
    end

    if p6.kind == "potion" then
        return p6.n .. " Random Potion" .. (if p6.n == 1 then "" else "s")
    end

    if p6.kind ~= "egg" then
        return ""
    end

    return (if p6.n > 1 then p6.n .. " " else "") .. "Cosmic Egg"
end

function t3.Art(_, p8, p9, p10, p11, p12) -- line: 85
    -- upvalues: Buffs (copy), UIKit (copy), BuffHud (copy), Colors (copy), v1 (copy), t2 (copy)
    local v7 = UIKit.frame(p8, {
        Name = "Art",
        Transparency = 1,
        Size = UDim2.fromOffset(p10, p10),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        ZIndex = p11
    })
    local v8 = p10 / 120

    if p9.kind == "cash" then
        local v9 = if (p9.mins or 0) >= 15 then 3 else 1

        for i = v9, 1, -1 do
            local v10 = t2[i]

            UIKit.icon(v7, "Cash", {
                Size = UDim2.fromOffset(v10[4] * v8, v10[4] * v8),
                Position = UDim2.new(0.5, v10[1] * v8, 0.5, v10[2] * v8 - v8 * 8),
                AnchorPoint = v1,
                ZIndex = p11 + (v9 - i),
                Rotation = v10[3]
            })
        end
    elseif p9.kind == "lucky" then
        local v11 = math.clamp(p9.n, 1, 5)

        for i = 1, v11 do
            local v12 = i - (v11 + 1) / 2
            local v13 = (74 - math.abs(v12) * 8) * v8

            UIKit.clover(v7, v13, {
                Position = UDim2.new(0.5, v12 * 26 * v8, 0.5, (math.abs(v12) * 7 + 2) * v8),
                AnchorPoint = v1,
                ZIndex = p11 + 4 - math.floor(math.abs(v12) * 2),
                Rotation = v12 * 14
            })
        end
    elseif p9.kind == "potion" then
        local v16 = p12 or (if p9.n >= 2 then { "luck", "cash" } else { "luck" })
        local v17 = #v16

        for v18, v19 in v16 do
            local v20 = Buffs.ById[v19] or Buffs.List[1]
            local v21 = (if v17 == 1 then 112 else 92) * v8
            local v22 = BuffHud.Bottle(v7, v20, v21, p11 + v18)

            v22.AnchorPoint = v1

            local v23 = v18 - (v17 + 1) / 2

            v22.Position = UDim2.new(0.5, v23 * 40 * v8, 0.5, math.abs(v23) * 6 * v8)
            v22.Rotation = v23 * 12
        end

        if not p12 then
            UIKit.text(v7, {
                Name = "Mystery",
                Text = "?",
                Stroke = 5,
                TextSize = math.floor(v8 * 48),
                Size = UDim2.fromOffset(v8 * 50, v8 * 50),
                Position = UDim2.new(0.5, v8 * 34, 0.5, v8 * -30),
                AnchorPoint = v1,
                Color = Colors.Gold,
                ZIndex = p11 + 5
            })

            return v7
        end
    elseif p9.kind == "egg" then
        UIKit.eggPicture(v7, p9.key, {
            Size = UDim2.fromScale(1, 1),
            ZIndex = p11
        })
    end

    return v7
end

function t3:BuildButton() -- line: 122
    -- upvalues: UIKit (copy), TopBar (copy), Colors (copy), v1 (copy)
    local v25 = TopBar.RoundButton("Daily", 25)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Calendar"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://102372135171341"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromOffset(32, 32)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.AnchorPoint = v1
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v25

    local Frame = Instance.new("Frame")

    Frame.Name = "Ready"
    Frame.BackgroundColor3 = Colors.Red
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromOffset(14, 14)
    Frame.Position = UDim2.new(1, -1, 0, 1)
    Frame.AnchorPoint = v1
    Frame.ZIndex = 3
    UIKit.corner(Frame, 7)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = TopBar.DARK
    UIStroke.Parent = Frame
    Frame.Visible = false
    Frame.Parent = v25
    UIKit.bindPress(v25, function() -- line: 149
        -- upvalues: self (copy)
        self.Window.Toggle()
    end)
    self.Button = v25
    self.Dot = Frame
end

function t3:BuildTile(p15, p16) -- line: 156
    -- upvalues: DailyRewards (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy), v2 (copy), v3 (copy), t1 (copy)
    local v26 = DailyRewards.List[p15]
    local v27 = p15 == #DailyRewards.List
    local v28 = if v27 then 230 else 140
    local v29 = t1[p15]
    local v30 = UIKit.frame(self.Window.Content, {
        Corner = 18,
        Stroke = 5,
        ZIndex = 12,
        Name = "Day" .. p15,
        Size = UDim2.fromOffset(v28, 270),
        Position = UDim2.fromOffset(p16, 88),
        Color = v29[1],
        Color2 = v29[2]
    })

    UIKit.dress(v30, 18, v29[1]:Lerp(v2, 0.6), 12)

    local v31 = UIKit.backdrop(v30, 18, 12)
    local v32 = UIKit.rays(v31, {
        Transparency = 0.6,
        ZIndex = 12,
        Speed = 30,
        Size = UDim2.fromOffset(v28 * 2.4, v28 * 2.4),
        Position = UDim2.fromOffset(v28 / 2, 118),
        AnchorPoint = v1
    })
    local v33 = UIKit.image(v31, "Glow", {
        Transparency = 0.45,
        ZIndex = 12,
        Size = UDim2.fromOffset(v28 * 1.4, v28 * 1.4),
        Position = UDim2.fromOffset(v28 / 2, 118),
        AnchorPoint = v1,
        Color = fromRGB(255, 245, 190)
    })

    UIKit.text(v30, {
        Name = "Header",
        Stroke = 4,
        ZIndex = 15,
        Text = "DAY " .. p15,
        TextSize = v27 and 36 or 30,
        Size = UDim2.new(1, -12, 0, 38),
        Position = UDim2.fromOffset(6, 6)
    })

    local v34 = UIKit.frame(v30, {
        Name = "ArtBox",
        Transparency = 1,
        ZIndex = 14,
        Size = UDim2.fromOffset(v27 and 170 or 120, v27 and 140 or 120),
        Position = UDim2.fromOffset(v28 / 2, 118),
        AnchorPoint = v1
    })

    self:Art(v34, v26, v27 and 150 or 112, 14)

    local v35 = UIKit.text(v30, {
        Name = "Prize",
        Text = "",
        Stroke = 3,
        ZIndex = 15,
        TextSize = v27 and 30 or 22,
        Size = UDim2.new(1, -14, 0, 46),
        Position = UDim2.fromOffset(7, 176)
    })

    v35.TextWrapped = true

    local v36 = UIKit.frame(v30, {
        Name = "State",
        Transparency = 0.35,
        Corner = 18,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.new(1, -18, 0, 36),
        Position = UDim2.new(0.5, 0, 1, -9),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(14, 16, 40)
    })
    local v37 = UIKit.text(v36, {
        Name = "Text",
        Text = "",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 16
    })
    local v38 = UIKit.frame(v30, {
        Name = "Dim",
        Transparency = 0.25,
        Corner = 18,
        ZIndex = 17,
        Color = fromRGB(70, 72, 84)
    })
    local v39 = UIKit.text(v38, {
        Name = "Check",
        TextSize = 84,
        Stroke = 6,
        ZIndex = 18,
        Text = v3,
        Size = UDim2.fromScale(1, 0.7),
        Color = Colors.Green
    })

    UIKit.text(v38, {
        Name = "Done",
        Text = "CLAIMED",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 18,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -44)
    })
    v38.Visible = false

    if v27 then
        local v40 = UIKit.frame(v30, {
            Name = "Best",
            Corner = 10,
            Stroke = 4,
            ZIndex = 19,
            Size = UDim2.fromOffset(84, 30),
            Position = UDim2.new(1, 12, 0, -28),
            AnchorPoint = Vector2.new(1, 0),
            Color = Colors.Red,
            Color2 = Colors.RedDark
        })

        v40.Rotation = 6
        UIKit.text(v40, {
            Name = "Label",
            Text = "BEST!",
            TextSize = 20,
            Stroke = 3,
            ZIndex = 20
        })
        UIKit.sparkle(v30, 26, {
            ZIndex = 16,
            Phase = 1,
            Position = UDim2.fromOffset(24, 70),
            Color = fromRGB(255, 245, 170)
        })
        UIKit.sparkle(v30, 20, {
            ZIndex = 16,
            Phase = 3,
            Position = UDim2.fromOffset(v28 - 26, 160)
        })
    end

    local UIStroke = v30:FindFirstChildOfClass("UIStroke")

    self.Tiles[p15] = {
        tile = v30,
        art = v34,
        label = v35,
        pill = v36,
        pillText = v37,
        dim = v38,
        check = v39,
        rays = v32,
        glow = v33,
        stroke = UIStroke,
        reward = v26
    }
end

function t3:BuildWindow() -- line: 188
    -- upvalues: DailyRewards (copy), UIKit (copy), Windows (copy), Colors (copy), fromRGB (copy)
    local v41 = UIKit.window(Windows.Gui, {
        Name = "Daily",
        Title = "Daily Rewards",
        GradientRotation = 0,
        Size = UDim2.fromOffset(1180, 600),
        HeaderColor = fromRGB(255, 196, 60),
        HeaderColor2 = fromRGB(255, 110, 70)
    })

    self.Window = v41

    local Content = v41.Content

    UIKit.text(Content, {
        Name = "Sub",
        Text = "Log in every day for bigger rewards! Miss a day and your streak starts again from Day 1.",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.fromOffset(0, 2),
        Color = fromRGB(255, 236, 214)
    })

    local v42 = UIKit.frame(Content, {
        Name = "Streak",
        Transparency = 0.2,
        Corner = 19,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(0, 38),
        Position = UDim2.new(0.5, 0, 0, 40),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(20, 14, 40),
        StrokeColor = Colors.Gold
    })

    v42.AutomaticSize = Enum.AutomaticSize.X

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 20)
    UIPadding.PaddingRight = UDim.new(0, 20)
    UIPadding.Parent = v42

    local v43 = UIKit.text(v42, {
        Name = "Text",
        Text = "",
        TextSize = 26,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.fromScale(0, 1),
        Color = Colors.Gold
    })

    v43.AutomaticSize = Enum.AutomaticSize.X
    self.StreakText = v43

    local n1 = 5

    for i = 1, #DailyRewards.List do
        self:BuildTile(i, n1)
        n1 += (if i == #DailyRewards.List then 230 else 140) + 12
    end

    local v45, v46 = UIKit.button(Content, {
        Name = "Claim",
        Text = "CLAIM",
        Corner = 18,
        Stroke = 6,
        TextStroke = 5,
        ZIndex = 14,
        Size = UDim2.fromOffset(380, 84),
        Position = UDim2.new(0.5, 0, 0, 372),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(150, 250, 70),
        Color2 = fromRGB(40, 190, 30),
        OnClick = function() -- OnClick | line: 208
            -- upvalues: self (copy)
            self:Claim()
        end
    })

    UIKit.gleam(v45, {
        Corner = 18,
        ZIndex = 14,
        Period = 2.4,
        Strength = 0.7,
        Width = 0.12,
        When = function() -- When | line: 211
            -- upvalues: v45 (copy)
            return v45.Active
        end
    })
    self.ClaimButton = v45
    self.ClaimLabel = v46
    self.Timer = UIKit.text(Content, {
        Name = "Timer",
        Text = "",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.fromOffset(0, 466),
        Color = fromRGB(214, 226, 255)
    })
    self.Fx = UIKit.frame(v41.Frame, {
        Name = "ClaimFx",
        Transparency = 1,
        ZIndex = 30
    })

    v41.OnOpen = function() -- line: 217
        -- upvalues: self (copy)
        self:Refresh()
    end
end

function t3:Refresh() -- line: 222
    -- upvalues: DailyRewards (copy), UIKit (copy), Colors (copy), fromRGB (copy)
    local v47, v48 = self:State()
    local elapsed = os.clock()

    for v49, v50 in self.Tiles do
        local v51 = if v48 then v49 < v47 else v49 <= v47
        local v52 = v48 and v49 == v47

        v50.label.Text = self:RewardText(v50.reward)
        v50.dim.Visible = v51 and not v50.hold
        v50.rays.Visible = v52
        v50.glow.Visible = v52

        if v50.stroke then
            local stroke = v50.stroke

            if v52 then
                stroke.Color = Colors.Gold
            else
                stroke.Color = Colors.Outline
            end

            local stroke2 = v50.stroke

            if v52 then
                stroke2.Thickness = math.sin(elapsed * 6) * 1.5 + 6
            else
                stroke2.Thickness = 5
            end
        end

        if v52 then
            v50.pillText.Text = "TODAY!"
            v50.pill.BackgroundColor3 = Colors.Green
            v50.pill.BackgroundTransparency = 0

            if not v50.hold then
                v50.art.Rotation = math.sin(elapsed * 7 + v49) * 7
                UIKit.scaleOf(v50.art).Scale = (math.sin(elapsed * 5) * 0.5 + 0.5) * 0.06 + 1
            end
        else
            local pillText = v50.pillText

            if v51 then
                pillText.Text = ""
            else
                pillText.Text = "DAY " .. v49
            end

            v50.pill.BackgroundColor3 = fromRGB(14, 16, 40)
            v50.pill.BackgroundTransparency = v51 and 1 or 0.35
            v50.art.Rotation = 0
            UIKit.scaleOf(v50.art).Scale = 1
        end
    end

    local v57 = if v48 then v47 - 1 else v47

    self.StreakText.Text = "STREAK: " .. v57 .. " DAY" .. (v57 == 1 and "" or "S")

    local v58 = v48 and not self.Claiming

    self.ClaimButton.Active = v58

    local ClaimLabel = self.ClaimLabel

    if v48 then
        ClaimLabel.Text = "CLAIM DAY " .. v47
    else
        ClaimLabel.Text = "CLAIMED!"
    end

    local setButtonColor = UIKit.setButtonColor
    local ClaimButton = self.ClaimButton
    local v60 = if v48 then fromRGB(150, 250, 70) else Colors.GreyDark
    local v59 = if v48 then fromRGB(40, 190, 30) else fromRGB(64, 66, 80)

    setButtonColor(ClaimButton, v60, v59)

    local Timer = self.Timer

    if v48 then
        Timer.Text = "Today's reward is ready!"
    else
        Timer.Text = "Next reward in " .. self:Clock(DailyRewards.SecondsLeft(self:Now()))
    end

    local Timer2 = self.Timer

    if v48 then
        Timer2.TextColor3 = Colors.Gold
    else
        Timer2.TextColor3 = fromRGB(214, 226, 255)
    end
end

function t3:RefreshDot() -- line: 262
    -- upvalues: UIKit (copy), DataClient (copy)
    local _, v61 = self:State()
    local Visible = self.Dot.Visible

    self.Dot.Visible = v61 and DataClient.IsReady()

    if self.Dot.Visible and not Visible then
        UIKit.pop(self.Dot, 1.6)
    end
end

function t3:Claim() -- line: 271
    -- upvalues: Remotes (copy), Toasts (copy)
    local _, v62 = self:State()

    if self.Claiming or not v62 then
        return
    end

    self.Claiming = true
    self:Refresh()
    task.spawn(function() -- line: 278
        -- upvalues: self (copy), Remotes (copy), Toasts (copy)
        local function v63() -- line: 279
            -- upvalues: Remotes (copy)
            return Remotes:WaitForChild("ClaimDaily"):InvokeServer()
        end

        local ok, result = pcall(v63)

        if ok and type(result) == "table" and result.ok then
            self.Claimed += 1
            self.LastResult = result
            self:Celebrate(result)
        elseif ok and type(result) == "table" and result.reason then
            Toasts.Show("error", result.reason)
        end

        self.Claiming = false
        self:Refresh()
    end)
end

function t3:CenterOf(p22) -- line: 294
    local Frame = self.Window.Frame
    local v64 = Frame.AbsoluteSize.X / Frame.Size.X.Offset
    local v65 = p22.AbsolutePosition + p22.AbsoluteSize / 2 - Frame.AbsolutePosition

    if not (v64 > 0) then
        v64 = 1
    end

    return v65 / v64
end

function t3:ScreenPop() -- line: 301
    -- upvalues: UIKit (copy)
    local v66 = UIKit.scaleOf(self.Window.Frame)
    local Scale = v66.Scale

    v66.Scale = Scale * 1.035
    UIKit.tween(v66, 0.35, {
        Scale = Scale
    }, Enum.EasingStyle.Back)

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local FieldOfView = CurrentCamera.FieldOfView

    UIKit.tween(CurrentCamera, 0.07, {
        FieldOfView = FieldOfView - 4
    }).Completed:Once(function() -- line: 310
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), UIKit (copy)
        UIKit.tween(CurrentCamera, 0.35, {
            FieldOfView = FieldOfView
        }, Enum.EasingStyle.Back)
    end)
end

function t3.Stars(_, p25, p26) -- line: 316
    -- upvalues: UIKit (copy), fromRGB (copy), v1 (copy), v2 (copy)
    local v67 = Random.new()

    for i = 1, 14 do
        local v68 = i / 14 * 3.141592653589793 * 2 + v67:NextNumber(-0.25, 0.25)
        local v69 = v67:NextInteger(22, 40)
        local v70 = UIKit.image(p25, "Sparkle", {
            Size = UDim2.fromOffset(v69, v69),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v1,
            ZIndex = p26,
            Color = if i % 2 == 0 then fromRGB(255, 235, 120) else v2
        })
        local v71 = v67:NextInteger(150, 250)

        UIKit.tween(v70, 0.75, {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, math.cos(v68) * v71, 0.5, math.sin(v68) * v71),
            Size = UDim2.fromOffset(8, 8),
            Rotation = v67:NextInteger(-200, 200)
        }, Enum.EasingStyle.Quart).Completed:Once(function() -- line: 324
            -- upvalues: v70 (copy)
            v70:Destroy()
        end)
    end
end

function t3:Celebrate(p28) -- line: 330
    -- upvalues: RunService (copy), DailyRewards (copy), NumberFormat (copy), UIKit (copy), Colors (copy), fromRGB (copy), v1 (copy)
    local v72 = self.Tiles[p28.day]

    if not v72 then
        return
    end

    self.Celebrations += 1

    local Fx = self.Fx

    Fx:ClearAllChildren()
    v72.hold = true
    v72.art.Visible = false

    local v73 = self:CenterOf(v72.art)
    local Frame = self.Window.Frame
    local v74 = Vector2.new(Frame.Size.X.Offset / 2, Frame.Size.Y.Offset / 2 - 14)
    local v75 = UIKit.frame(Fx, {
        Name = "Scrim",
        Transparency = 1,
        Corner = 20,
        ZIndex = 30,
        Size = UDim2.new(1, -20, 1, -92),
        Position = UDim2.fromOffset(10, 82),
        Color = fromRGB(0, 0, 0)
    })

    UIKit.tween(v75, 0.25, {
        BackgroundTransparency = 0.4
    })

    local v76 = UIKit.frame(Fx, {
        Name = "Stage",
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(240, 240),
        Position = UDim2.fromOffset(v73.X, v73.Y),
        AnchorPoint = v1
    })
    local v77 = UIKit.image(v76, "Rays", {
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(620, 620),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 236, 150)
    })
    local v78 = UIKit.image(v76, "Glow", {
        Transparency = 1,
        ZIndex = 31,
        Size = UDim2.fromOffset(460, 460),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(255, 248, 210)
    })
    local v79 = DailyRewards.List[p28.day]
    local v80 = self:Art(v76, v79, 200, 33, p28.potions)
    local v81 = UIKit.scaleOf(v80)

    v81.Scale = 0.55

    local v83 = UIKit.text(v76, {
        Name = "Amount",
        TextSize = 64,
        Stroke = 7,
        ZIndex = 40,
        Text = if v79.kind == "cash" then "+" .. NumberFormat.money(p28.amount or 0) else "x" .. tostring(p28.amount or 1),
        Size = UDim2.fromOffset(420, 70),
        Position = UDim2.new(0.5, 0, 1, -16),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Gold,
        StrokeColor = fromRGB(110, 60, 0)
    })

    v83.Visible = false

    local v84 = UIKit.frame(Fx, {
        Name = "Ribbon",
        Corner = 14,
        Stroke = 5,
        ZIndex = 42,
        Size = UDim2.fromOffset(720, 58),
        Position = UDim2.fromOffset(Frame.Size.X.Offset / 2, 104),
        AnchorPoint = v1,
        Color = fromRGB(120, 240, 90),
        Color2 = fromRGB(40, 170, 50)
    })

    UIKit.text(v84, {
        Name = "Label",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 43,
        Text = tostring(p28.text or ""),
        Size = UDim2.new(1, -20, 1, -6),
        Position = UDim2.fromOffset(10, 2)
    })
    UIKit.scaleOf(v84).Scale = 0
    UIKit.sound("RevealGood")

    if v79.kind == "cash" then
        UIKit.sound("Coins")
    end

    self:ScreenPop()
    UIKit.tween(UIKit.scaleOf(v84), 0.4, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    UIKit.tween(v76, 0.42, {
        Position = UDim2.fromOffset(v74.X, v74.Y)
    }, Enum.EasingStyle.Back)
    UIKit.tween(v81, 0.42, {
        Scale = 1.25
    }, Enum.EasingStyle.Back)
    UIKit.tween(v77, 0.3, {
        ImageTransparency = 0.25
    })
    UIKit.tween(v78, 0.3, {
        ImageTransparency = 0.15
    })
    task.delay(0.3, function() -- line: 367
        -- upvalues: self (copy), v76 (copy), v83 (copy), UIKit (copy)
        v83.Visible = true
        UIKit.pop(v83, 1.6)
        self:Stars(v76, 38)
        UIKit.sound("Twinkle")
    end)

    local elapsed = os.clock()
    local connection = RunService.RenderStepped:Connect(function() -- line: 374
        -- upvalues: v77 (copy), v78 (copy), elapsed (copy)
        local v86 = os.clock() - elapsed

        v77.Rotation = v86 * 70
        v78.Size = UDim2.fromOffset(math.sin(v86 * 6) * 26 + 460, math.sin(v86 * 6) * 26 + 460)
    end)

    task.delay(self.HoldTime, function() -- line: 379
        -- upvalues: self (copy), v72 (copy), v75 (copy), v76 (copy), v77 (copy), v78 (copy), v81 (copy), v83 (copy), v84 (copy), connection (copy), UIKit (copy)
        local v90 = self:CenterOf(v72.art)

        UIKit.tween(v76, 0.32, {
            Position = UDim2.fromOffset(v90.X, v90.Y)
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        UIKit.tween(v81, 0.32, {
            Scale = 0.5
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        UIKit.tween(v77, 0.25, {
            ImageTransparency = 1
        })
        UIKit.tween(v78, 0.25, {
            ImageTransparency = 1
        })
        UIKit.tween(v75, 0.3, {
            BackgroundTransparency = 1
        })
        v83.Visible = false
        task.wait(0.32)
        connection:Disconnect()
        v76:Destroy()
        v75:Destroy()
        v72.hold = false
        v72.art.Visible = true
        self:Refresh()
        UIKit.pop(v72.check, 1.8)
        UIKit.pop(v72.tile, 1.08)
        UIKit.sound("Unlock")
        task.wait(0.9)

        if v84.Parent then
            UIKit.tween(UIKit.scaleOf(v84), 0.2, {
                Scale = 0
            }, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Once(function() -- line: 400
                -- upvalues: v84 (copy)
                v84:Destroy()
            end)
        end
    end)
end

function t3:AutoOpen() -- line: 407
    -- upvalues: UIKit (copy), HUD (copy)
    if self.AutoOpened then
        return
    end

    local v91 = os.clock() + 180

    while true do
        if os.clock() < v91 then
            local _, v92 = self:State()

            if not v92 then
                break
            end

            if not (self.Blocked ~= nil and self.Blocked()) and HUD.GetMode() == "normal" and not UIKit.anyWindowOpen() then
                self.AutoOpened = true
                self.Window.Open()

                return
            end

            task.wait(1)
            continue
        end

        return
    end
end

function t3:Start() -- line: 427
    -- upvalues: RunService (copy), ContentProvider (copy), DataClient (copy)
    self:BuildWindow()
    self:BuildButton()
    task.spawn(function() -- line: 430
        -- upvalues: self (copy), ContentProvider (copy)
        local t15 = {}

        for _, v93 in self.Tiles do
            for _, descendant in v93.art:GetDescendants() do
                if descendant:IsA("ImageLabel") then
                    table.insert(t15, descendant)
                end
            end
        end

        local function v94() -- line: 439
            -- upvalues: t15 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t15)
        end

        pcall(v94)
    end)
    DataClient.Observe("DailyLogin", function() -- line: 443
        -- upvalues: self (copy)
        self:RefreshDot()

        if self.Window.IsOpen and not self.Claiming then
            self:Refresh()
        end
    end)
    RunService.Heartbeat:Connect(function() -- line: 449
        -- upvalues: self (copy)
        if self.Window.IsOpen then
            self:Refresh()
        end
    end)
    task.spawn(function() -- line: 454
        -- upvalues: self (copy)
        while true do
            self:RefreshDot()
            task.wait(1)
        end
    end)
    task.spawn(function() -- line: 460
        -- upvalues: self (copy), DataClient (copy)
        while not DataClient.IsReady() do
            task.wait(0.5)
        end

        task.wait(2.5)
        self:AutoOpen()
    end)

    return self
end

t3.Shared = t3.new()

return t3

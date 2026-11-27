-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SocialService = game:GetService("SocialService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local SpawnClockConfig = require(Modules:WaitForChild("SpawnClockConfig"))
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local Toast = require(Modules:WaitForChild("Toast"))
local Loc = require(Modules:WaitForChild("Loc"))
local PotionConfig = require(Modules:WaitForChild("PotionConfig"))
local WeatherConfig = require(Modules:WaitForChild("WeatherConfig"))
local AdminAbuseConfig = require(Modules:WaitForChild("AdminAbuseConfig"))
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local EffectsGui = PlayerGui:WaitForChild("EffectsGui")
local Stack = EffectsGui:WaitForChild("Stack")
local Pop = Stack:WaitForChild("Pop")
local Template = Stack:WaitForChild("Template")

Template.Visible = false
Template:WaitForChild("Value").AutoLocalize = false

local t1 = {
    ROLL_ICON = "rbxassetid://138818103926341",
    LUCK_ICON = "rbxassetid://122946700214787",
    CASH_ICON = "rbxassetid://129156943051821",
    RESTART_ICON = "rbxassetid://72276219732393",
    ADMIN_ICON = "rbxassetid://93241348152774",
    FAT_ICON = "rbxassetid://135825676122341",
    ADMIN_MUTATION_ICON = "rbxassetid://118165331738222",
    X_DESK = 0.988,
    X_TOUCH = 0.82,
    LAST = 10,
    RED = {
        Color3.fromRGB(255, 230, 230),
        Color3.fromRGB(255, 95, 95),
        Color3.fromRGB(70, 0, 0)
    },
    WHITE = {
        Color3.new(1, 1, 1),
        Color3.fromRGB(215, 235, 255),
        Color3.new(0, 0, 0)
    },
    GOLD = {
        Color3.fromRGB(255, 212, 85),
        Color3.fromRGB(222, 150, 25),
        Color3.fromRGB(95, 50, 0)
    },
    GREEN = {
        Color3.fromRGB(225, 255, 225),
        Color3.fromRGB(90, 230, 90),
        Color3.fromRGB(10, 60, 20)
    },
    PINK = {
        Color3.fromRGB(255, 205, 235),
        Color3.fromRGB(255, 80, 170),
        Color3.fromRGB(80, 0, 45)
    },
    BLUE = {
        Color3.fromRGB(215, 240, 255),
        Color3.fromRGB(70, 160, 255),
        Color3.fromRGB(0, 30, 80)
    },
    ORANGE = {
        Color3.fromRGB(255, 225, 190),
        Color3.fromRGB(255, 135, 30),
        Color3.fromRGB(90, 35, 0)
    },
    IN = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    OUT = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    BEAT = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local function look(p1, p2) -- line: 118
    local UIGradient = p1:FindFirstChildOfClass("UIGradient")

    if not UIGradient then
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = 90
        UIGradient.Parent = p1
    end

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p2[1]),
        ColorSequenceKeypoint.new(0.4, p2[1]),
        ColorSequenceKeypoint.new(1, p2[2])
    })

    local UIStroke = p1:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p2[3]
    end
end

local function beat(p3, p4) -- line: 131
    -- upvalues: TweenService (copy), t1 (copy)
    local tween = TweenService:Create(p3, t1.BEAT, {
        Scale = p4
    })

    tween.Completed:Once(function() -- line: 133
        -- upvalues: p3 (copy), TweenService (copy), t1 (copy)
        TweenService:Create(p3, t1.IN, {
            Scale = 1
        }):Play()
    end)
    tween:Play()
end

local t2 = {}

local function row(p5, p6, p7, p8) -- line: 139
    -- upvalues: Stack (copy), Template (copy), t2 (copy)
    local clone = Template:Clone()

    clone.Name = p5
    clone.LayoutOrder = p6
    clone.Icon.Image = p7
    clone.Caption.Text = p8 or ""
    clone.Caption.Visible = p8 ~= nil

    if not p8 then
        clone.Value.AnchorPoint = Vector2.new(1, 0.5)
        clone.Value.Position = UDim2.fromScale(clone.Value.Position.X.Scale, 0.5)
        clone.Value.Size = UDim2.fromScale(clone.Value.Size.X.Scale, 0.56)
    end

    clone.Visible = false
    clone.Pop.Scale = 0
    clone.Parent = Stack

    local t3 = {
        on = false,
        token = 0,
        gui = clone
    }

    t2[p5] = t3

    return t3
end

local ROLL_ICON = t1.ROLL_ICON
local clone = Template:Clone()

clone.Name = "Roll"
clone.LayoutOrder = 9
clone.Icon.Image = ROLL_ICON
clone.Caption.Text = "NEXT SPAWN"
clone.Caption.Visible = true
clone.Visible = false
clone.Pop.Scale = 0
clone.Parent = Stack

local t4 = {
    on = false,
    token = 0,
    gui = clone
}

t2.Roll = t4
clone = WeatherConfig.NEXT_ICON

local clone2 = Template:Clone()

clone2.Name = "Weather"
clone2.LayoutOrder = 8
clone2.Icon.Image = clone
clone2.Caption.Text = "NEXT WEATHER"
clone2.Caption.Visible = true
clone2.Visible = false
clone2.Pop.Scale = 0
clone2.Parent = Stack

local t5 = {
    on = false,
    token = 0,
    gui = clone2
}

t2.Weather = t5
clone2 = t1.ADMIN_ICON

local clone3 = Template:Clone()

clone3.Name = "AdminCountdown"
clone3.LayoutOrder = 6
clone3.Icon.Image = clone2
clone3.Caption.Text = "ADMIN ABUSE"
clone3.Caption.Visible = true
clone3.Visible = false
clone3.Pop.Scale = 0
clone3.Parent = Stack

local t6 = {
    on = false,
    token = 0,
    gui = clone3
}

t2.AdminCountdown = t6

local v1 = row("AdminFat", 5, t1.FAT_ICON, ("X%d FAT"):format(AdminAbuseConfig.FAT))
local v4 = row("AdminSize", 7, t1.ADMIN_ICON, ("+%d%% BIGGER FISH"):format((math.floor((AdminAbuseConfig.SIZE - 1) * 100 + 0.5))))
local ADMIN_MUTATION_ICON = t1.ADMIN_MUTATION_ICON
local v2 = Template:Clone()

v2.Name = "AdminMutation"
v2.LayoutOrder = 6
v2.Icon.Image = ADMIN_MUTATION_ICON
v2.Caption.Text = "ADMIN MUTATION"
v2.Caption.Visible = true
v2.Visible = false
v2.Pop.Scale = 0
v2.Parent = Stack

local t7 = {
    on = false,
    token = 0,
    gui = v2
}

t2.AdminMutation = t7

local v5 = row("AdminLuck", 6, t1.LUCK_ICON, ("X%d SERVER LUCK"):format(AdminAbuseConfig.LEVEL3.LUCK))
local LUCK_ICON = t1.LUCK_ICON
local clone4 = Template:Clone()

clone4.Name = "Luck"
clone4.LayoutOrder = 4
clone4.Icon.Image = LUCK_ICON
clone4.Caption.Text = "X3 SERVER LUCK"
clone4.Caption.Visible = true
clone4.Visible = false
clone4.Pop.Scale = 0
clone4.Parent = Stack

local t8 = {
    on = false,
    token = 0,
    gui = clone4
}

t2.Luck = t8
clone4 = Template:Clone()
clone4.Name = "AdminTrader"
clone4.LayoutOrder = 6
clone4.Icon.Image = "rbxassetid://132409368513754"
clone4.Caption.Text = "CROWN SHOP CLOSES"
clone4.Caption.Visible = true
clone4.Visible = false
clone4.Pop.Scale = 0
clone4.Parent = Stack

local t9 = {
    on = false,
    token = 0,
    gui = clone4
}

t2.AdminTrader = t9

local v6 = row("Potion", 3, PotionConfig.TIERS.T1.icon, PotionConfig.Title("T1"))
local v7 = row("BagPotion", 2, PotionConfig.TIERS.B1.icon, PotionConfig.Title("B1"))
local t10 = {}
local v8

for _, v9 in ipairs(PotionConfig.TIMED) do
    if v9 ~= "Fat" and v9 ~= "Bag" then
        v8 = nil

        for _, v10 in ipairs(PotionConfig.ORDER) do
            if PotionConfig.TIERS[v10].kind == v9 then
                v8 = v10
                break
            end
        end

        t10[#t10 + 1] = {
            kind = v9,
            entry = row(v9 .. "Potion", 3, PotionConfig.TIERS[v8].icon, PotionConfig.Title(v8))
        }
    end
end

local v11 = row("Cash", 1, t1.CASH_ICON)
local RESTART_ICON = t1.RESTART_ICON
local clone5 = Template:Clone()

clone5.Name = "Restart"
clone5.LayoutOrder = 0
clone5.Icon.Image = RESTART_ICON
clone5.Caption.Text = "UPDATE IN:"
clone5.Caption.Visible = true
clone5.Visible = false
clone5.Pop.Scale = 0
clone5.Parent = Stack

local t11 = {
    on = false,
    token = 0,
    gui = clone5
}

t2.Restart = t11
clone5 = WeatherConfig.HALLOWEEN.icon

local clone6 = Template:Clone()

clone6.Name = "Halloween"
clone6.LayoutOrder = 7
clone6.Icon.Image = clone5
clone6.Caption.Text = "HALLOWEEN"
clone6.Caption.Visible = true
clone6.Visible = false
clone6.Pop.Scale = 0
clone6.Parent = Stack

local t12 = {
    on = false,
    token = 0,
    gui = clone6
}

t2.Halloween = t12
clone6 = TitanConfig.ICON
v8 = Template:Clone()
v8.Name = "Titan"
v8.LayoutOrder = 6
v8.Icon.Image = clone6
v8.Caption.Text = "TITAN RISING IN"
v8.Caption.Visible = true
v8.Visible = false
v8.Pop.Scale = 0
v8.Parent = Stack

local t13 = {
    on = false,
    token = 0,
    gui = v8
}

t2.Titan = t13

local ThanksgivingConfig = require(Modules:WaitForChild("ThanksgivingConfig"))
local ICON = ThanksgivingConfig.ICON
local clone7 = Template:Clone()

clone7.Name = "Thanksgiving"
clone7.LayoutOrder = 7
clone7.Icon.Image = ICON
clone7.Caption.Text = "THANKSGIVING!"
clone7.Caption.Visible = true
clone7.Visible = false
clone7.Pop.Scale = 0
clone7.Parent = Stack

local t14 = {
    on = false,
    token = 0,
    gui = clone7
}

t2.Thanksgiving = t14

local v12, v13

look(t4.gui.Value, t1.WHITE)
look(t5.gui.Value, t1.WHITE)
look(t12.gui.Value, t1.WHITE)
look(t13.gui.Value, t1.WHITE)

local Icon = t13.gui.Caption:FindFirstChildOfClass("UIGradient")

if Icon then
    Icon.Name = "Grad"
    Icon.Rotation = 0
end

RarityStyle.Track(t13.gui.Caption, (require(Modules:WaitForChild("WorldConfig")).IsJurassic() and RarityStyle.JURASSIC_TITAN or RarityStyle.TITAN).COLOR)
look(t8.gui.Value, t1.GREEN)
look(v4.gui.Value, t1.RED)
look(t7.gui.Value, t1.RED)
look(v5.gui.Value, t1.GREEN)
look(t6.gui.Value, t1.RED)
look(v1.gui.Value, t1.PINK)
look(v6.gui.Value, t1.PINK)
look(v7.gui.Value, t1.BLUE)
look(v11.gui.Value, t1.GOLD)
look(t11.gui.Value, t1.RED)

local TitanEventConfig = require(Modules:WaitForChild("TitanEventConfig"))
local t15 = {
    lastCount = nil,
    lastBonus = nil
}
local Caption = TitanConfig.ICON
local JURASSIC_TITAN = Template:Clone()

JURASSIC_TITAN.Name = "TitanEventCountdown"
JURASSIC_TITAN.LayoutOrder = 6
JURASSIC_TITAN.Icon.Image = Caption
JURASSIC_TITAN.Caption.Text = "TITAN EVENT"
JURASSIC_TITAN.Caption.Visible = true
JURASSIC_TITAN.Visible = false
JURASSIC_TITAN.Pop.Scale = 0
JURASSIC_TITAN.Parent = Stack

local t16 = {
    on = false,
    token = 0,
    gui = JURASSIC_TITAN
}

t2.TitanEventCountdown = t16
t15.countdown = t16
t15.fat = row("TitanEventFat", 5, t1.FAT_ICON, ("X%d FAT"):format(TitanEventConfig.FAT))
t15.luck = row("TitanEventLuck", 5, TitanEventConfig.LUCK_ICON, ("X%d MUTATION LUCK"):format(TitanEventConfig.LUCK))
look(t15.countdown.gui.Value, t1.WHITE)
look(t15.fat.gui.Value, t1.PINK)
look(t15.luck.gui.Value, t1.GREEN)

local BoostEventConfig = require(Modules:WaitForChild("BoostEventConfig"))
local t17 = {
    last = nil
}
local MutationDisplay = t1.FAT_ICON
local clone8 = Template:Clone()

clone8.Name = "BoostFat"
clone8.LayoutOrder = 5
clone8.Icon.Image = MutationDisplay
clone8.Caption.Text = "X2 FAT"
clone8.Caption.Visible = true
clone8.Visible = false
clone8.Pop.Scale = 0
clone8.Parent = Stack
JURASSIC_TITAN = {
    on = false,
    token = 0,
    gui = clone8
}
t2.BoostFat = JURASSIC_TITAN
t17.fat = JURASSIC_TITAN
MutationDisplay = t1.CASH_ICON
clone8 = Template:Clone()
clone8.Name = "BoostCash"
clone8.LayoutOrder = 5
clone8.Icon.Image = MutationDisplay
clone8.Caption.Text = "X2 CASH"
clone8.Caption.Visible = true
clone8.Visible = false
clone8.Pop.Scale = 0
clone8.Parent = Stack
JURASSIC_TITAN = {
    on = false,
    token = 0,
    gui = clone8
}
t2.BoostCash = JURASSIC_TITAN
t17.cash = JURASSIC_TITAN
MutationDisplay = TitanEventConfig.LUCK_ICON
clone8 = Template:Clone()
clone8.Name = "BoostLuck"
clone8.LayoutOrder = 5
clone8.Icon.Image = MutationDisplay
clone8.Caption.Text = "X2 MUTATION LUCK"
clone8.Caption.Visible = true
clone8.Visible = false
clone8.Pop.Scale = 0
clone8.Parent = Stack
JURASSIC_TITAN = {
    on = false,
    token = 0,
    gui = clone8
}
t2.BoostLuck = JURASSIC_TITAN
t17.luck = JURASSIC_TITAN
look(t17.fat.gui.Value, t1.PINK)
look(t17.cash.gui.Value, t1.GOLD)
look(t17.luck.gui.Value, t1.GREEN)
JURASSIC_TITAN = require(Modules:WaitForChild("PumpkinShopConfig"))
MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))

local t18 = {}
local v14

for _, v15 in ipairs(JURASSIC_TITAN.SHOP) do
    if v15.kind == "boost" and v15.attr then
        v14 = MutationDisplay[v15.mutation]

        local v16 = row("Pumpkin" .. v15.key, 3, v14 and v14.icon or "", ("X%d %s"):format(v15.mult, v14 and v14.display or string.upper(v15.mutation)))

        look(v16.gui.Value, v15.mutation == "Ghost" and t1.GREEN or t1.ORANGE)
        t18[#t18 + 1] = {
            last = nil,
            entry = v16,
            attr = v15.attr
        }
    end
end

for _, v18 in ipairs(require(Modules:WaitForChild("TurkeyShopConfig")).SHOP) do
    if v18.kind == "boost" and v18.attr then
        JURASSIC_TITAN = MutationDisplay[v18.mutation]
        v14 = row("Turkey" .. v18.key, 3, JURASSIC_TITAN and JURASSIC_TITAN.icon or "", ("X%d %s"):format(v18.mult, JURASSIC_TITAN and JURASSIC_TITAN.display or string.upper(v18.mutation)))
        look(v14.gui.Value, t1.ORANGE)
        t18[#t18 + 1] = {
            last = nil,
            entry = v14,
            attr = v18.attr
        }
    end
end

local v19 = false
local t19 = {
    [v5] = true,
    [t7] = true
}

local function setOn(p9, p10) -- line: 264
    -- upvalues: TweenService (copy), t1 (copy), v19 (ref), t19 (copy)
    p9.want = p10

    local v20 = if not v19 then p10 elseif t19[p9] then p10 else false

    if p9.on == v20 then
        return
    end

    p9.on = v20
    p9.token += 1

    local token, gui = p9.token, p9.gui

    if v20 then
        gui.Visible = true
        gui.Pop.Scale = 0
        TweenService:Create(gui.Pop, t1.IN, {
            Scale = 1
        }):Play()
    else
        local tween = TweenService:Create(gui.Pop, t1.OUT, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 278
            -- upvalues: p9 (copy), token (copy), gui (copy)
            if p9.token == token then
                gui.Visible = false
            end
        end)
        tween:Play()
    end
end

local function clock(p11) -- line: 285
    local v22 = math.max(0, (math.ceil(p11)))

    if v22 >= 3600 then
        return string.format("%d:%02d:%02d", v22 // 3600, v22 % 3600 // 60, v22 % 60)
    end

    return string.format("%d:%02d", v22 // 60, v22 % 60)
end

local v23, Value, v24, Value2, Value3, v25, v26, v27, v28, v29, v30, Value4, Value5
local v31 = false
local v32, v33, v34
local v35 = false
local v36, v37, v38, Value6
local v39 = false
local v40
local v41 = false
local v42 = false
local n1 = 0

RunService.Heartbeat:Connect(function(p12) -- line: 303
    -- upvalues: SpawnClockConfig (copy), Loc (copy), WeatherConfig (copy), AdminAbuseConfig (copy), TitanConfig (copy), LocalPlayer (copy), t1 (copy), look (copy), beat (copy), t2 (copy), t4 (copy), t5 (copy), t6 (copy), v1 (copy), v4 (copy), t7 (copy), v5 (copy), t8 (copy), t9 (copy), v6 (copy), v7 (copy), t10 (copy), t11 (copy), t12 (copy), t13 (copy), ThanksgivingConfig (copy), t14 (copy), v12 (ref), v13 (ref), TitanEventConfig (copy), t15 (copy), BoostEventConfig (copy), t17 (copy), t18 (copy), v19 (ref), setOn (copy), v23 (ref), Value (ref), v24 (ref), Value2 (ref), Value3 (ref), v25 (ref), v26 (ref), v27 (ref), v28 (ref), v29 (ref), v30 (ref), Value4 (ref), Value5 (ref), v31 (ref), v32 (ref), v33 (ref), v34 (ref), v35 (ref), v36 (ref), v37 (ref), v38 (ref), Value6 (ref), v39 (ref), v40 (ref), v41 (ref), v42 (ref), n1 (ref)
    n1 += p12

    if n1 < 0.1 then
        return
    end

    n1 = 0

    local ServerTimeNow = workspace:GetServerTimeNow()
    local v43 = TitanConfig.Hijacked(TitanConfig.Now())

    if v43 ~= v42 then
        v42 = v43
        setOn(t4, not v43)
    end

    local Value7 = SpawnClockConfig.SecondsLeft(ServerTimeNow)

    v43 = math.ceil(Value7)

    local Value8, v44

    if v43 ~= v23 then
        if v23 and v23 < v43 then
            beat(t4.gui.Icon.Pop, 1.3)
        end

        v23 = v43
        Value7 = t4.gui.Value
        v44 = math.ceil(v43)

        local v45 = math.max(0, v44)

        if v45 >= 3600 then
            Value7.Text = string.format("%d:%02d:%02d", v45 // 3600, v45 % 3600 // 60, v45 % 60)
        else
            Value7.Text = string.format("%d:%02d", v45 // 60, v45 % 60)
        end

        Value7 = v43 <= t1.LAST

        if Value7 ~= v31 then
            v31 = Value7
            Value8 = t4.gui.Value
            look(Value8, Value7 and t1.GOLD or t1.WHITE)
        end

        if Value7 then
            beat(t4.gui.Value.Pop, 1.18)
        end
    end

    v43 = WeatherConfig.Now()
    Value7 = WeatherConfig.Started(v43)

    if Value7 ~= Value5 then
        Value5 = Value7
        setOn(t5, Value7)
        v32 = nil
    end

    local v46 = math.ceil(WeatherConfig.SlotEnd(WeatherConfig.SlotOf(v43)) - v43)
    local v47, v48, v49, v50, v51, v52, Value9, GOLD

    if Value7 and v46 ~= v32 then
        v32 = v46
        v47 = WeatherConfig.At(v43)

        local v53 = v46 <= WeatherConfig.EVENT and v47.id or nil

        v48 = v53 ~= nil
        v44 = not v48

        local v54

        if v44 then
            v44 = WeatherConfig.Live()

            if v44 then
                v54 = v47.startsAt - WeatherConfig.FIRST
                v44 = math.abs(v54) < 1
            end
        end

        local v55 = if not v48 then WeatherConfig.TicketNext(v43) else nil

        if v48 or not v55 then
            v55 = nil
        end

        if v48 ~= v33 or v53 ~= v34 or v44 ~= v36 or v55 ~= v37 then
            v33 = v48
            v34 = v53
            v36 = v44
            v37 = v55

            local v56 = v53 and WeatherConfig.WEATHERS[v53]

            v54 = v55 and WeatherConfig.WEATHERS[v55]

            local Caption = t5.gui.Icon
            local v57, v58

            if v56 then
                local icon = v56.icon

                if icon then
                    v57 = icon
                    v58 = true
                elseif v54 then
                    icon = v54.icon

                    if icon then
                        v57 = icon
                        v58 = true
                    else
                        v58 = false
                    end
                else
                    v58 = false
                end
            elseif v54 then
                local icon = v54.icon

                if icon then
                    v57 = icon
                    v58 = true
                else
                    v58 = false
                end
            else
                v58 = false
            end

            if not v58 then
                v57 = WeatherConfig.NEXT_ICON
            end

            Caption.Image = v57
            Caption = t5.gui.Caption

            local v59 = false

            if v56 then
                v57 = v56.buff

                if v57 then
                    v49 = v57
                    v59 = true
                elseif v54 then
                    v57 = Loc.F("weather.ticketIn", "{w} IN", {
                        w = Loc.T(v54.name)
                    })

                    if v57 then
                        v49 = v57
                        v59 = true
                    end
                end
            elseif v54 then
                v57 = Loc.F("weather.ticketIn", "{w} IN", {
                    w = Loc.T(v54.name)
                })

                if v57 then
                    v49 = v57
                    v59 = true
                end
            end

            if not v59 then
                v49 = if v44 then "THE UPDATE" else "NEXT WEATHER"
            end

            Caption.Text = v49
            v35 = false
            v49 = t5.gui.Value

            local v60, v61

            if v56 then
                if v53 == "PinkMoon" then
                    local PINK = t1.PINK

                    if PINK then
                        v60 = PINK
                        v61 = true
                    else
                        PINK = t1.BLUE

                        if PINK then
                            v60 = PINK
                            v61 = true
                        else
                            v61 = false
                        end
                    end
                else
                    local PINK = t1.BLUE

                    if PINK then
                        v60 = PINK
                        v61 = true
                    else
                        v61 = false
                    end
                end
            else
                v61 = false
            end

            if not v61 then
                v60 = t1.WHITE
            end

            look(v49, v60)

            if v56 or v54 then
                beat(t5.gui.Icon.Pop, 1.3)
            end
        end

        local v62 = if not v48 then WeatherConfig.NextStorm(v43) else nil

        if v48 or not v62 then
            v62 = nil
        end

        local v63 = false

        if v48 and v46 then
            v50 = v46
            v63 = true
        elseif v62 then
            v53 = v62 - v43

            if v53 then
                v50 = v53
                v63 = true
            end
        end

        if not v63 then
            v50 = v46 - WeatherConfig.EVENT
        end

        v55 = t5.gui.Value
        v51 = math.ceil(v50)
        v49 = math.max(0, v51)

        if v49 >= 3600 then
            v55.Text = string.format("%d:%02d:%02d", v49 // 3600, v49 % 3600 // 60, v49 % 60)
        else
            v55.Text = string.format("%d:%02d", v49 // 60, v49 % 60)
        end

        if not v48 then
            v52 = v50 <= t1.LAST

            if v52 ~= v35 then
                v35 = v52
                Value9 = t5.gui.Value
                GOLD = v52 and t1.GOLD or t1.WHITE
                look(Value9, GOLD)
            end

            if v52 then
                beat(t5.gui.Value.Pop, 1.18)
            end
        end
    end

    v46 = WeatherConfig.HalloweenNext(v43)
    Value7 = v46 ~= nil and v46.startsAt <= v43

    local v64, v65

    if v46 then
        v50 = (Value7 and v46.endsAt or v46.startsAt) - v43
        v47 = math.ceil(v50)

        if v47 then
            v64 = v47
            v65 = true
        else
            v65 = false
        end
    else
        v65 = false
    end

    if not v65 then
        v64 = nil
    end

    local v66, Value10

    if v64 ~= v38 then
        v38 = v64
        setOn(t12, v46 ~= nil)

        local v67 = false
        local v68 = false
        local v69 = false
        local v70 = false

        if v46 then
            v67 = true
        else
            v70 = true
        end

        if v67 then
            if Value7 == Value6 then
                v70 = false
            else
                v68 = true
            end
        end

        v67 = false

        local Caption

        if v68 then
            Value6 = Value7
            Caption = t12.gui.Caption

            if Value7 then
                v69 = true
            else
                v67 = true
            end
        end

        v68 = false

        local v71

        if v67 then
            v71 = "HALLOWEEN"
            v68 = true
        end

        v67 = false

        if v69 then
            v48 = WeatherConfig.HALLOWEEN.buff

            if v48 then
                v71 = v48
                v68 = true
            else
                v67 = true
            end
        end

        v69 = false

        if v67 then
            v71 = "HALLOWEEN!"
            v68 = true
        end

        v67 = false

        local Icon

        if v68 then
            Caption.Text = v71
            Icon = t12.gui.Icon

            if Value7 then
                v67 = true
            else
                v69 = true
            end
        end

        v68 = false

        local v72

        if v67 then
            v71 = WeatherConfig.HALLOWEEN.icon

            if v71 then
                v72 = v71
                v68 = true
            else
                v69 = true
            end
        end

        v67 = false

        if v69 then
            v72 = WeatherConfig.HALLOWEEN.soonIcon
            v68 = true
        end

        v69 = false

        local look2, Value

        if v68 then
            Icon.Image = v72
            v39 = false
            look2 = look
            Value = t12.gui.Value

            if Value7 then
                v69 = true
            else
                v67 = true
            end
        end

        v68 = false

        local v73

        if v69 then
            v52 = t1.ORANGE

            if v52 then
                v73 = v52
                v68 = true
            else
                v67 = true
            end
        end

        if v67 then
            v73 = t1.WHITE
            v68 = true
        end

        v67 = false

        if v68 then
            look2(Value, v73)

            if Value7 then
                v67 = true
            else
                v70 = false
            end
        end

        if v67 then
            v70 = false
            beat(t12.gui.Icon.Pop, 1.3)
        end

        if not v70 then
            Icon = t12.gui.Value
            GOLD = math.ceil(v64)
            v66 = math.max(0, GOLD)

            if v66 >= 3600 then
                Icon.Text = string.format("%d:%02d:%02d", v66 // 3600, v66 % 3600 // 60, v66 % 60)
            else
                Icon.Text = string.format("%d:%02d", v66 // 60, v66 % 60)
            end

            if not Value7 then
                local v74 = v64 <= t1.LAST

                if v74 ~= v39 then
                    v39 = v74
                    Value10 = t12.gui.Value
                    look(Value10, v74 and t1.GOLD or t1.WHITE)
                end

                if v74 then
                    beat(t12.gui.Value.Pop, 1.18)
                end
            end
        end
    end

    v64 = ThanksgivingConfig.Phase()

    if v64 ~= v13 then
        v13 = v64
        v12 = nil
        setOn(t14, v64 ~= nil)

        if v64 then
            t14.gui.Caption.Text = v64 == "grace" and "TURKEY LEAVES IN" or "THANKSGIVING!"
            look(t14.gui.Value, {
                Color3.fromRGB(255, 225, 190),
                ThanksgivingConfig.ORANGE,
                Color3.fromRGB(80, 35, 5)
            })
            beat(t14.gui.Icon.Pop, 1.3)
        end
    end

    local Value11

    if v64 then
        Value10 = ThanksgivingConfig.Left()

        local v75 = math.ceil(Value10)

        if v75 ~= v12 then
            v12 = v75
            Value11 = t14.gui.Value

            local v76

            if v75 >= 86400 then
                v76 = string.format("%dd %dh", v75 // 86400, v75 % 86400 // 3600)

                if not v76 then
                    GOLD = math.ceil(v75)
                    v66 = math.max(0, GOLD)
                    v76 = if v66 >= 3600 then string.format("%d:%02d:%02d", v66 // 3600, v66 % 3600 // 60, v66 % 60) else string.format("%d:%02d", v66 // 60, v66 % 60)
                end
            else
                GOLD = math.ceil(v75)
                v66 = math.max(0, GOLD)
                v76 = if v66 >= 3600 then string.format("%d:%02d:%02d", v66 // 3600, v66 % 3600 // 60, v66 % 60) else string.format("%d:%02d", v66 // 60, v66 % 60)
            end

            Value11.Text = v76
        end
    end

    Value11 = TitanConfig.SecondsLeft(TitanConfig.Now())
    v64 = math.ceil(Value11)

    if v64 ~= v40 then
        if v40 ~= nil then
            if v40 < v64 then
                beat(t13.gui.Icon.Pop, 1.3)
            end
        else
            setOn(t13, true)
        end

        v40 = v64
        Value11 = t13.gui.Value
        GOLD = math.ceil(v64)
        v66 = math.max(0, GOLD)

        if v66 >= 3600 then
            Value11.Text = string.format("%d:%02d:%02d", v66 // 3600, v66 % 3600 // 60, v66 % 60)
        else
            Value11.Text = string.format("%d:%02d", v66 // 60, v66 % 60)
        end

        Value7 = v64 <= t1.LAST

        local Value12

        if Value7 ~= v41 then
            v41 = Value7
            Value12 = t13.gui.Value
            look(Value12, Value7 and t1.GOLD or t1.WHITE)
        end

        if Value7 then
            beat(t13.gui.Value.Pop, 1.18)
        end
    end

    v64 = AdminAbuseConfig.Now()

    local v77 = math.ceil(AdminAbuseConfig.START - v64)
    local Value13

    if v77 ~= v26 then
        v26 = v77
        setOn(t6, v77 > 0)

        if v77 > 0 then
            Value13 = t6.gui.Value
            v49 = math.ceil(v77)
            Value9 = math.max(0, v49)

            if Value9 >= 3600 then
                Value13.Text = string.format("%d:%02d:%02d", Value9 // 3600, Value9 % 3600 // 60, Value9 % 60)
            else
                Value13.Text = string.format("%d:%02d", Value9 // 60, Value9 % 60)
            end

            if v77 <= t1.LAST then
                beat(t6.gui.Value.Pop, 1.18)
            end
        end
    end

    v77 = TitanEventConfig.Now()
    Value13 = math.ceil(TitanEventConfig.START - v77)

    local v79 = if Value13 > 0 and Value13 <= TitanEventConfig.COUNTDOWN and Value13 then Value13 else 0

    if v79 ~= t15.lastCount then
        t15.lastCount = v79
        setOn(t15.countdown, v79 > 0)

        if v79 > 0 then
            local Value = t15.countdown.gui.Value

            v51 = math.ceil(v79)
            v49 = math.max(0, v51)

            if v49 >= 3600 then
                Value.Text = string.format("%d:%02d:%02d", v49 // 3600, v49 % 3600 // 60, v49 % 60)
            else
                Value.Text = string.format("%d:%02d", v49 // 60, v49 % 60)
            end

            if v79 <= t1.LAST then
                beat(t15.countdown.gui.Value.Pop, 1.18)
            end
        end
    end

    local n2 = 0

    if TitanEventConfig.Bonus(v77) then
        v66 = TitanEventConfig.END - v77
        n2 = math.ceil(v66) or 0
    end

    local Value14

    if n2 ~= t15.lastBonus then
        Value13 = t15.lastBonus
        t15.lastBonus = n2
        setOn(t15.fat, n2 > 0)
        setOn(t15.luck, n2 > 0)

        if n2 > 0 then
            Value14 = t15.fat.gui.Value
            v51 = math.ceil(n2)
            v49 = math.max(0, v51)

            if v49 >= 3600 then
                Value14.Text = string.format("%d:%02d:%02d", v49 // 3600, v49 % 3600 // 60, v49 % 60)
            else
                Value14.Text = string.format("%d:%02d", v49 // 60, v49 % 60)
            end

            Value14 = t15.luck.gui.Value
            v51 = math.ceil(n2)
            v49 = math.max(0, v51)

            if v49 >= 3600 then
                Value14.Text = string.format("%d:%02d:%02d", v49 // 3600, v49 % 3600 // 60, v49 % 60)
            else
                Value14.Text = string.format("%d:%02d", v49 // 60, v49 % 60)
            end

            if not Value13 or Value13 <= 0 then
                beat(t15.fat.gui.Icon.Pop, 1.3)
                beat(t15.luck.gui.Icon.Pop, 1.3)
            end
        end
    end

    local v80

    Value14, v80 = BoostEventConfig.Active()

    local n3 = 0

    if Value14 then
        v49 = Value14.to - v80
        n3 = math.ceil(v49) or 0
    end

    local T, name, v81, v82, v83

    if n3 ~= t17.last then
        v80 = t17.last
        t17.last = n3

        for _, v84 in ipairs({ "fat", "cash", "luck" }) do
            v77 = Value14 and Value14[v84] or 1
            T = t17[v84]
            v81 = n3 > 0 and v77 > 1
            setOn(T, v81)

            if n3 > 0 and v77 > 1 then
                name = T.gui.Value
                v82 = math.max(0, (math.ceil(n3)))

                if v82 >= 3600 then
                    name.Text = string.format("%d:%02d:%02d", v82 // 3600, v82 % 3600 // 60, v82 % 60)
                else
                    name.Text = string.format("%d:%02d", v82 // 60, v82 % 60)
                end

                name = T.gui.Caption
                v83 = if v84 == "luck" then "X%s MUTATION LUCK" elseif v84 == "cash" then "X%s CASH" else "X%s FAT"
                name.Text = v83:format(v77)

                if not v80 or v80 <= 0 then
                    beat(T.gui.Icon.Pop, 1.3)
                end
            end
        end
    end

    n3, v49 = AdminAbuseConfig.Fattening(v64)

    local n4 = 0

    if n3 then
        v51 = v49 - v64
        n4 = math.ceil(v51) or 0
    end

    local Value15

    if n4 ~= v27 then
        v49 = v27
        v27 = n4
        setOn(v1, n4 > 0)

        if n4 > 0 then
            Value15 = v1.gui.Value
            v83 = math.ceil(n4)
            T = math.max(0, v83)

            if T >= 3600 then
                Value15.Text = string.format("%d:%02d:%02d", T // 3600, T % 3600 // 60, T % 60)
            else
                Value15.Text = string.format("%d:%02d", T // 60, T % 60)
            end

            v1.gui.Caption.Text = ("X%d FAT"):format(n3)

            if not v49 or v49 <= 0 then
                beat(v1.gui.Icon.Pop, 1.3)
            end
        end
    end

    local v86

    Value15, v86 = AdminAbuseConfig.Boost(v64)

    local n5 = 0

    if Value15 then
        T = v86 - v64
        n5 = math.ceil(T) or 0
    end

    local Value16

    if n5 ~= v25 then
        v86 = v25
        v25 = n5
        setOn(v4, n5 > 0)

        if n5 > 0 then
            Value16 = v4.gui.Value
            v82 = math.ceil(n5)
            v83 = math.max(0, v82)

            if v83 >= 3600 then
                Value16.Text = string.format("%d:%02d:%02d", v83 // 3600, v83 % 3600 // 60, v83 % 60)
            else
                Value16.Text = string.format("%d:%02d", v83 // 60, v83 % 60)
            end

            v83 = (Value15 - 1) * 100 + 0.5
            Value16 = ("+%d%% BIGGER FISH"):format((math.floor(v83)))

            if v4.gui.Caption.Text ~= Value16 then
                v4.gui.Caption.Text = Value16

                if v86 and v86 > 0 then
                    beat(v4.gui.Value.Pop, 1.3)
                end
            end

            if not v86 or v86 <= 0 then
                beat(v4.gui.Icon.Pop, 1.3)
            end
        end
    end

    local v87

    Value16, v87, name = AdminAbuseConfig.HitMutation(v64)

    local n6 = 0

    if Value16 then
        v81 = name - v64
        n6 = math.ceil(v81) or 0
    end

    local Value17, v88, v89

    if n6 ~= v28 then
        name = v28
        v28 = n6
        setOn(t7, n6 > 0)

        if n6 > 0 then
            Value17 = t7.gui.Value
            v88 = math.ceil(n6)
            v89 = math.max(0, v88)

            if v89 >= 3600 then
                Value17.Text = string.format("%d:%02d:%02d", v89 // 3600, v89 % 3600 // 60, v89 % 60)
            else
                Value17.Text = string.format("%d:%02d", v89 // 60, v89 % 60)
            end

            Value16 = AdminAbuseConfig.LEVEL2

            if v87 == Value16.CHANCE then
                n3 = "ADMIN MUTATION"
            elseif v87 == Value16.MORE_CHANCE then
                n3 = "ADMIN MUTATION (x2 chance)"
            else
                v89 = 1 / v87 + 0.5
                n3 = ("ADMIN MUTATION (1 IN %d)"):format((math.floor(v89)))
            end

            if n3 ~= v29 then
                v29 = n3
                t7.gui.Caption.Text = n3

                if name and name > 0 then
                    beat(t7.gui.Value.Pop, 1.3)
                end
            end

            if not name or name <= 0 then
                beat(t7.gui.Icon.Pop, 1.3)
            end
        else
            v29 = nil
        end
    end

    Value17 = AdminAbuseConfig.Finale(v64)

    if Value17 ~= v19 then
        v19 = Value17

        for _, v90 in pairs(t2) do
            setOn(v90, v90.want == true)
        end
    end

    local v91

    Value17, v91 = AdminAbuseConfig.LuckMul(v64)

    local n7 = 0

    if Value17 then
        v89 = v91 - v64
        n7 = math.ceil(v89) or 0
    end

    local Value18, v92

    if n7 ~= v30 then
        v91 = v30
        v30 = n7
        setOn(v5, n7 > 0)

        if n7 > 0 then
            Value18 = v5.gui.Value
            v92 = math.ceil(n7)
            v88 = math.max(0, v92)

            if v88 >= 3600 then
                Value18.Text = string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60)
            else
                Value18.Text = string.format("%d:%02d", v88 // 60, v88 % 60)
            end

            Value15 = (workspace:GetAttribute("ServerLuckEnd") or 0) > workspace:GetServerTimeNow()

            local v93 = if Value15 then Value17 * 2 else nil

            if Value15 and v93 then
                Value17 = v93
            end

            Value18 = ("X%d SERVER LUCK"):format(Value17)

            if v5.gui.Caption.Text ~= Value18 then
                v5.gui.Caption.Text = Value18

                if v91 and v91 > 0 then
                    beat(v5.gui.Value.Pop, 1.3)
                end
            end

            if not v91 or v91 <= 0 then
                beat(v5.gui.Icon.Pop, 1.3)
            end
        end
    end

    Value18 = math.ceil(AdminAbuseConfig.END + AdminAbuseConfig.TRADER.AFTER - v64)

    if v64 < AdminAbuseConfig.END or Value18 < 0 then
        Value18 = 0
    end

    local Value19

    if Value18 ~= Value4 then
        v87 = Value4
        Value4 = Value18
        setOn(t9, Value18 > 0)

        if Value18 > 0 then
            Value19 = t9.gui.Value
            v92 = math.ceil(Value18)
            v88 = math.max(0, v92)

            if v88 >= 3600 then
                Value19.Text = string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60)
            else
                Value19.Text = string.format("%d:%02d", v88 // 60, v88 % 60)
            end

            if not v87 or v87 <= 0 then
                beat(t9.gui.Icon.Pop, 1.3)
            end
        end
    end

    Value19 = math.ceil((workspace:GetAttribute("ServerLuckEnd") or 0) - ServerTimeNow)

    local Value20

    if Value19 ~= Value then
        Value = Value19
        setOn(t8, Value19 > 0)

        if Value19 > 0 then
            Value20 = t8.gui.Value
            v92 = math.ceil(Value19)
            v88 = math.max(0, v92)

            if v88 >= 3600 then
                Value20.Text = string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60)
            else
                Value20.Text = string.format("%d:%02d", v88 // 60, v88 % 60)
            end
        end
    end

    Value20 = math.ceil((LocalPlayer:GetAttribute("FatPotionEnd") or 0) - ServerTimeNow)

    local Value21

    if Value20 ~= Value2 then
        if Value2 and Value2 + 1 < Value20 and v6.on then
            beat(v6.gui.Value.Pop, 1.25)
        end

        Value2 = Value20
        setOn(v6, Value20 > 0)

        if Value20 > 0 then
            Value21 = v6.gui.Value
            v92 = math.ceil(Value20)
            v88 = math.max(0, v92)

            if v88 >= 3600 then
                Value21.Text = string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60)
            else
                Value21.Text = string.format("%d:%02d", v88 // 60, v88 % 60)
            end
        end
    end

    local v97 = (LocalPlayer:GetAttribute("BagPotionEnd") or 0) - ServerTimeNow

    Value21 = math.ceil(v97)

    if Value21 ~= Value3 then
        Value3 = Value21
        setOn(v7, Value21 > 0)

        if Value21 > 0 then
            local Value = v7.gui.Value

            v92 = math.ceil(Value21)
            v88 = math.max(0, v92)

            if v88 >= 3600 then
                Value.Text = string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60)
            else
                Value.Text = string.format("%d:%02d", v88 // 60, v88 % 60)
            end
        end
    end

    local v98, v99, v100, v101

    for _, v102 in ipairs(t10) do
        v98 = (LocalPlayer:GetAttribute(v102.kind .. "PotionEnd") or 0) - ServerTimeNow
        v99 = math.ceil(v98)

        if v99 ~= v102.last then
            if v102.last and v102.last + 1 < v99 and v102.entry.on then
                beat(v102.entry.gui.Value.Pop, 1.25)
            end

            v102.last = v99
            setOn(v102.entry, v99 > 0)

            if v99 > 0 then
                v92 = v102.entry.gui.Value
                v100 = math.ceil(v99)
                v101 = math.max(0, v100)

                if v101 >= 3600 then
                    v92.Text = string.format("%d:%02d:%02d", v101 // 3600, v101 % 3600 // 60, v101 % 60)
                else
                    v92.Text = string.format("%d:%02d", v101 // 60, v101 % 60)
                end
            end
        end
    end

    for _, v103 in ipairs(t18) do
        v98 = (tonumber(LocalPlayer:GetAttribute(v103.attr)) or 0) - ServerTimeNow
        v99 = math.ceil(v98)

        if v99 ~= v103.last then
            if v103.last and v103.last + 1 < v99 and v103.entry.on then
                beat(v103.entry.gui.Value.Pop, 1.25)
            end

            v103.last = v99
            setOn(v103.entry, v99 > 0)

            if v99 > 0 then
                v92 = v103.entry.gui.Value
                v100 = math.ceil(v99)
                v101 = math.max(0, v100)

                if v101 >= 3600 then
                    v92.Text = string.format("%d:%02d:%02d", v101 // 3600, v101 % 3600 // 60, v101 % 60)
                else
                    v92.Text = string.format("%d:%02d", v101 // 60, v101 % 60)
                end
            end
        end
    end

    local n8 = 0

    if LocalPlayer:GetAttribute("RestartRow") then
        v97 = (workspace:GetAttribute("ServerRestartAt") or 0) - ServerTimeNow
        n8 = math.ceil(v97) or 0
    end

    if n8 == v24 then
        return
    end

    v24 = n8
    setOn(t11, n8 > 0)

    if not (n8 > 0) then
        return
    end

    local Value22 = t11.gui.Value
    local v104 = math.max(0, (math.ceil(n8)))

    if v104 >= 3600 then
        Value22.Text = string.format("%d:%02d:%02d", v104 // 3600, v104 % 3600 // 60, v104 % 60)
    else
        Value22.Text = string.format("%d:%02d", v104 // 60, v104 % 60)
    end

    if n8 <= t1.LAST then
        beat(t11.gui.Value.Pop, 1.18)
    end
end)
setOn(t4, true)

local function dressPotion() -- line: 640
    -- upvalues: PotionConfig (copy), LocalPlayer (copy), v6 (copy), v7 (copy), t10 (copy)
    local t22 = {
        { v6, "FatPotionTier" },
        { v7, "BagPotionTier" }
    }

    for _, v105 in ipairs(t10) do
        table.insert(t22, {
            v105.entry,
            v105.kind .. "PotionTier"
        })
    end

    for _, v106 in ipairs(t22) do
        local Attribute = LocalPlayer:GetAttribute(v106[2])
        local v107 = PotionConfig.Get(Attribute)

        if v107 then
            v106[1].gui.Icon.Image = v107.icon
            v106[1].gui.Caption.Text = PotionConfig.Title(Attribute)
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("FatPotionTier"):Connect(dressPotion)
LocalPlayer:GetAttributeChangedSignal("BagPotionTier"):Connect(dressPotion)

for _, v108 in ipairs(t10) do
    LocalPlayer:GetAttributeChangedSignal(v108.kind .. "PotionTier"):Connect(dressPotion)
end

dressPotion()

local function dressCash() -- line: 658
    -- upvalues: Loc (copy), LocalPlayer (copy), beat (copy), v11 (copy), setOn (copy)
    local v109 = tonumber(LocalPlayer:GetAttribute("FriendBoost")) or 0

    if v109 > 0 then
        local Text = v11.gui.Value.Text

        v11.gui.Value.Text = Loc.F("fx.cash", "+{pct}% CASH", {
            pct = tostring(v109)
        })

        if v11.on and Text ~= v11.gui.Value.Text then
            beat(v11.gui.Value.Pop, 1.15)
        end
    end

    setOn(v11, v109 > 0)
end

LocalPlayer:GetAttributeChangedSignal("FriendBoost"):Connect(dressCash)
Loc.Changed:Connect(dressCash)
dressCash()

local v110 = UserInputService.TouchEnabled

local function place() -- line: 674
    -- upvalues: Stack (copy), t1 (copy), v110 (ref)
    Stack.Position = UDim2.fromScale(v110 and t1.X_TOUCH or t1.X_DESK, Stack.Position.Y.Scale)
end

UserInputService.LastInputTypeChanged:Connect(function(p13) -- line: 677
    -- upvalues: Stack (copy), t1 (copy), v110 (ref)
    local v111 = v110

    if p13 == Enum.UserInputType.Touch then
        v110 = true
    elseif p13 == Enum.UserInputType.Keyboard or p13.Name:find("Mouse") or p13.Name:find("Gamepad") then
        v110 = false
    end

    if v110 == v111 then
        return
    end

    Stack.Position = UDim2.fromScale(v110 and t1.X_TOUCH or t1.X_DESK, Stack.Position.Y.Scale)
end)
Stack.Position = UDim2.fromScale(v110 and t1.X_TOUCH or t1.X_DESK, Stack.Position.Y.Scale)

local t24 = {}

for _, v112 in ipairs({ "AquariumGui", "FeedGui" }) do
    local v113 = PlayerGui:WaitForChild(v112, 30)
    local v114 = v113 and v113:WaitForChild("Panel", 10)

    if v114 then
        t24[#t24 + 1] = v114
    end
end

local v115 = false
local n9 = 1

local function stepAside() -- line: 696
    -- upvalues: TweenService (copy), LocalPlayer (copy), Pop (copy), t1 (copy), t24 (copy), v115 (ref), n9 (ref)
    local v116 = LocalPlayer:GetAttribute("PanelOpen") == true or LocalPlayer:GetAttribute("Cinematic") == true

    for _, v117 in ipairs(t24) do
        if v117.Visible then
            v116 = true
        end
    end

    if v116 == v115 then
        return
    end

    v115 = v116
    TweenService:Create(Pop, v116 and t1.OUT or t1.IN, {
        Scale = if v116 then 0 else n9
    }):Play()
end

for _, v118 in ipairs({ "PanelOpen", "Cinematic" }) do
    LocalPlayer:GetAttributeChangedSignal(v118):Connect(stepAside)
end

for _, v119 in ipairs(t24) do
    v119:GetPropertyChangedSignal("Visible"):Connect(stepAside)
end

stepAside()

local UIListLayout = Stack:FindFirstChildOfClass("UIListLayout")
local PlaytimeSlot = PlayerGui:WaitForChild("SideButtons"):WaitForChild("PlaytimeSlot")
local UIScale = PlaytimeSlot:FindFirstChildOfClass("UIScale")
local v120

local function refit() -- line: 720
    -- upvalues: TweenService (copy), EffectsGui (copy), Stack (copy), Pop (copy), t1 (copy), v115 (ref), n9 (ref), UIListLayout (copy), PlaytimeSlot (copy), UIScale (copy), v120 (ref)
    local Scale = UIScale and UIScale.Scale or 1

    if Scale > 0.05 then
        v120 = PlaytimeSlot.AbsoluteSize.Y / Scale / 2
    end

    local Scale2 = Pop.Scale
    local v121

    if not v120 or Scale2 < 0.05 then
        return
    else
        local v123 = PlaytimeSlot.AbsolutePosition + PlaytimeSlot.AbsoluteSize / 2
        local v124 = Stack.AbsolutePosition.X + Stack.AbsoluteSize.X

        if v124 - Stack.AbsoluteSize.X / Scale2 < v123.X + v120 and v123.X - v120 < v124 then
            local v125 = Stack.AbsolutePosition.Y + Stack.AbsoluteSize.Y - (v123.Y + v120) - 0.008 * EffectsGui.AbsoluteSize.Y
            local v126 = UIListLayout.AbsoluteContentSize.Y / Scale2

            v121 = if v126 > 0 then math.clamp(v125 / v126, 0.35, 1) else 1
        else
            v121 = 1
        end
    end

    if math.abs(v121 - n9) < 0.01 then
        return
    end

    n9 = v121
    Stack:SetAttribute("Fit", n9)

    if not v115 then
        TweenService:Create(Pop, t1.BEAT, {
            Scale = n9
        }):Play()
    end
end

Stack:SetAttribute("Fit", n9)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refit)
Stack:GetPropertyChangedSignal("AbsoluteSize"):Connect(refit)
Stack:GetPropertyChangedSignal("AbsolutePosition"):Connect(refit)
PlaytimeSlot:GetPropertyChangedSignal("AbsolutePosition"):Connect(refit)
PlaytimeSlot:GetPropertyChangedSignal("AbsoluteSize"):Connect(refit)
EffectsGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refit)
refit()

local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Plus = PlayerGui:WaitForChild("MoneyGui"):WaitForChild("Money"):WaitForChild("Icon"):WaitForChild("Plus")

local function showPlus() -- line: 768
    -- upvalues: Plus (copy)
    Plus.Visible = false
end

LocalPlayer:GetAttributeChangedSignal("ShopUnlocked"):Connect(showPlus)
Plus.Visible = false
ButtonHover.Attach(Plus, {
    tile = 1,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8
})

local Panel = PlayerGui:WaitForChild("InviteGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local OK = Panel:WaitForChild("OK")
local Close = Panel:WaitForChild("Main"):WaitForChild("Close")

Panel.Visible = false

local v131 = false
local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local closeMenu

local function openMenu() -- line: 782
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), OK (copy), Close (copy), v131 (ref), PadMenu (copy), closeMenu (ref)
    if v131 then
        return
    end

    v131 = true
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    }):Play()
    PadMenu.Open(Panel, function() -- line: 789
        -- upvalues: closeMenu (ref)
        if closeMenu then
            closeMenu()
        end
    end, {
        first = OK,
        closeButton = Close
    })
end

local function closeMenu2() -- line: 792
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), v131 (ref), PadMenu (copy)
    if not v131 then
        return nil
    end

    v131 = false
    PadMenu.Close(Panel)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 798
        -- upvalues: Panel (copy), v131 (ref)
        if not v131 then
            Panel.Visible = false
        end
    end)
    tween:Play()

    return tween
end

closeMenu = closeMenu2
Plus.Activated:Connect(function() -- line: 803
    -- upvalues: ButtonHover (copy), Plus (copy), openMenu (copy)
    ButtonHover.Press(Plus)
    openMenu()
end)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Close.Activated:Connect(closeMenu2)
ButtonHover.Attach(OK, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
OK.Activated:Connect(function() -- line: 811
    -- upvalues: SocialService (copy), ButtonHover (copy), Toast (copy), LocalPlayer (copy), OK (copy), closeMenu2 (copy)
    ButtonHover.Press(OK)

    local v132 = closeMenu2()

    if v132 then
        v132.Completed:Once(function() -- line: 815
            -- upvalues: SocialService (copy), Toast (copy), LocalPlayer (copy)
            local CanSendGameInviteAsync = SocialService.CanSendGameInviteAsync
            local ok, result = pcall(CanSendGameInviteAsync, SocialService, LocalPlayer)

            if not ok or not result then
                Toast.Show("You can't send invites right now!", "", nil, Toast.RED, "deny")
            else
                local PromptGameInvite = SocialService.PromptGameInvite

                pcall(PromptGameInvite, SocialService, LocalPlayer)
            end
        end)
    end
end)
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 825
    -- upvalues: Panel (copy), v131 (ref)
    if v131 then
        v131 = false
        Panel.Visible = false
    end
end)

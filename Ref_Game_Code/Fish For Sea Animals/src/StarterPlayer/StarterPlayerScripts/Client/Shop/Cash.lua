-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Robux = require(script.Parent.Robux)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local Boosts = require(script.Parent.Boosts)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    "GREAT DEAL!",
    "BEST VALUE!"
}
local t3

local function short() -- line: 26
    -- upvalues: LocalPlayer (copy), t3 (ref)
    if t3 then
        local v1 = t3.target - (LocalPlayer:GetAttribute("Money") or 0)

        if v1 > 0 then
            return v1
        end
    end

    return nil
end

function t1.setNeed(p1, p2) -- line: 35
    -- upvalues: LocalPlayer (copy), t3 (ref)
    if not p1 or not p2 then
        t3 = nil
    else
        t3 = {
            target = (LocalPlayer:GetAttribute("Money") or 0) + p1,
            what = p2
        }
    end
end

local function picture(p3, p4, p5, p6) -- line: 40
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Picture"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p4
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 3

    for v2, v3 in p6 do
        ImageLabel[v2] = v3
    end

    ImageLabel.Parent = p3
    task.spawn(function() -- line: 53
        -- upvalues: p5 (copy), ImageLabel (copy)
        local n1 = 0

        while true do
            if ImageLabel.Parent then
                if ImageLabel.IsLoaded then
                    return
                end

                task.wait(1)

                local ScreenGui = ImageLabel:FindFirstAncestorOfClass("ScreenGui")
                local ScrollingFrame = ImageLabel:FindFirstAncestorOfClass("ScrollingFrame")
                local Y = ImageLabel.AbsolutePosition.Y

                if ScreenGui and ScreenGui.Enabled and ScrollingFrame and Y < ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteSize.Y and Y + ImageLabel.AbsoluteSize.Y > ScrollingFrame.AbsolutePosition.Y then
                    n1 += 1
                end

                if n1 >= 8 then
                    break
                end

                continue
            end

            return
        end

        ImageLabel.Image = p5
    end)

    return ImageLabel
end

local function minutesText(p7) -- line: 72
    if p7 >= 60 then
        return (`{ p7 // 60 }h`)
    end

    return (("%*m"):format(p7))
end

local function ladder(p8, p9, p10, p11, p12, p13, p14, p15, p16) -- line: 78
    -- upvalues: Format (copy), Products (copy), Robux (copy), Style (copy), Fx (copy), LocalPlayer (copy), t2 (copy), t3 (ref), picture (copy)
    local t4 = {}
    local n2 = 0

    for v4, v5 in p16 do
        local v6 = v5[1]
        local v7 = v5[2]
        local v8 = Style.row(p8, v7, p9 + v4 - 1)
        local v9 = Style.split(v6)

        for i = 1, v6 do
            n2 += 1

            local v10 = p11[n2]

            if not v10 then
                break
            end

            local v11 = t2[n2 - (#p11 - #t2)]
            local v12 = n2 == #p11
            local v13 = Style.card(v8, if v12 then Style.GOLD elseif v11 then p14:Lerp(Style.GOLD, 0.3) else p14, {
                Name = v10.Key,
                Position = UDim2.fromOffset((i - 1) * (v9 + Style.GAP), 0),
                Size = UDim2.fromOffset(v9, v7)
            })

            Style.polish(v13)

            if v11 then
                v13.UIStroke.Thickness = 6
                Fx.turn(Style.gradient(v13.UIStroke, if v12 then Style.RAINBOW else ColorSequence.new(Style.YELLOW, Color3.new(1, 1, 1)), 0), 80)
                Fx.sparkles(v13, v12 and 7 or 4, Color3.new(1, 1, 1), 26, 2)

                local v14 = Style.tag(v13, v11, if v12 then Style.CORAL else Style.ABYSS, {
                    Rotation = -3,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0, 2),
                    Size = UDim2.fromOffset(230, 50)
                })

                Fx.wiggle(v14, 5, 3, n2)
            end

            local v16 = Style.text(v13, string.upper(v10.Name), {
                StrokeThickness = 5,
                ZIndex = 3,
                Position = UDim2.fromOffset(22, v11 and 34 or 18),
                Size = UDim2.new(1, -44, 0, 44)
            })

            if v12 then
                Style.gradient(v16, Style.RAINBOW, 0)
            end

            local v19 = math.min(v7 - 200, n2 * 22 + 110)
            local v20 = (if v11 then 82 else 66) + v19 / 2

            Fx.rays(v13, v19 * 1.9 / v7, 0.5, v20 / v7, 1).ImageTransparency = 0.55

            local v21 = picture(v13, v10.Image, p15, {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0, v20),
                Size = UDim2.fromOffset(v19, v19)
            })

            Fx.bob(v21, 5, 2.4, n2)

            local v22 = Style.text(v13, "", {
                Name = "Amount",
                StrokeThickness = 6,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -128),
                Size = UDim2.new(1, -40, 0, 70)
            })

            Style.gradient(v22, ColorSequence.new(Color3.new(1, 1, 1), if p12 == "Cash" then Style.MINT else Style.SAND))

            local text2 = Style.text
            local Minutes = v10.Minutes

            text2(v13, ("%* of %*"):format(if Minutes >= 60 then ("%*h"):format(Minutes // 60) else ("%*m"):format(Minutes), p12 == "Cash" and "income" or "training"), {
                Name = "Minutes",
                ZIndex = 4,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -98),
                Size = UDim2.new(1, -40, 0, 28),
                TextColor3 = Style.SAND
            })

            local v23 = Style.seal(v13, "", "MORE", {
                Name = "Bonus",
                Rotation = 12,
                Visible = false,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -70, 0, v20 + 6),
                Size = UDim2.fromOffset(120, 120)
            })

            Fx.wiggle(v23, 7, 3.2, n2 * 0.4)

            local v24 = Style.tag(v13, "✔ ENOUGH!", Style.BUY, {
                Name = "Enough",
                Rotation = -8,
                Visible = false,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromOffset(-8, v20 + v19 * 0.15),
                Size = UDim2.fromOffset(170, 46)
            })

            Fx.wiggle(v24, 8, 1.8, n2)

            local v25 = Style.price(v13, v10.Key, {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -20),
                Size = UDim2.new(1, -48, 0, 70)
            })

            Fx.shine(v25, 3, n2 * 0.45)

            if v12 then
                Fx.ping(v25, Style.YELLOW, 1.8)
                Fx.breathe(v25, 0.04, 3)
            end

            t4[n2] = {
                def = v10,
                label = v22,
                seal = v23,
                enough = v24
            }
        end
    end

    p10(function() -- line: 179
        -- upvalues: p12 (copy), p13 (copy), t4 (copy), Format (copy), Products (copy), Robux (copy), LocalPlayer (copy), t3 (ref)
        local v26 = LocalPlayer:GetAttribute(p13) or 0
        local v27

        if p12 == "Cash" and t3 then
            v27 = t3.target - (LocalPlayer:GetAttribute("Money") or 0)

            if not (v27 > 0) then
                v27 = nil
            end
        end

        local v28

        for v29, v30 in t4 do
            local v31 = Products.scaled(v26, v30.def.Minutes, v30.def.Min)
            local label = v30.label

            if p12 == "Cash" then
                label.Text = Format.money(v31)
            else
                label.Text = ("+%* XP"):format((Format.short(v31)))
            end

            local v32 = v31 / Robux.price(v30.def.Key)

            v28 = v28 or v32

            local v34 = math.floor((v32 / v28 - 1) * 100 + 0.5)
            local seal = v30.seal

            if v29 > 1 then
                seal.Visible = v34 >= 10
            else
                seal.Visible = false
            end

            v30.seal.Top.Text = ("+%*%%"):format((Format.short(v34)))

            local enough = v30.enough

            if v27 ~= nil then
                enough.Visible = v27 <= v31
            else
                enough.Visible = false
            end
        end
    end)
end

local function needBanner(p17, p18, p19) -- line: 198
    -- upvalues: Format (copy), Style (copy), Fx (copy), LocalPlayer (copy), t3 (ref)
    local v35 = Style.row(p17, 124, p18)
    local v36 = Style.card(v35, Style.CORAL, {
        Name = "Need",
        Size = UDim2.fromScale(1, 1)
    })

    Style.polish(v36)

    local v37 = Style.bubble(v36, "💸", {
        ZIndex = 3,
        Position = UDim2.fromOffset(18, 10),
        Size = UDim2.fromOffset(104, 104)
    })

    Fx.wiggle(v37, 10, 2.2)

    local v38 = Style.text(v36, "", {
        StrokeThickness = 5,
        ZIndex = 3,
        Position = UDim2.fromOffset(136, 14),
        Size = UDim2.new(1, -160, 0, 56),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v39 = Style.text(v36, "", {
        ZIndex = 3,
        Position = UDim2.fromOffset(138, 74),
        Size = UDim2.new(1, -160, 0, 36),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Style.YELLOW
    })

    p19(function() -- line: 218
        -- upvalues: v35 (copy), v38 (copy), v39 (copy), Format (copy), LocalPlayer (copy), t3 (ref)
        v35.Visible = t3 ~= nil

        if not t3 then
            return
        end

        local v40 = t3.target - (LocalPlayer:GetAttribute("Money") or 0)

        if not (v40 > 0) then
            v40 = nil
        end

        if v40 then
            v38.Text = ("You need <font color=\"#96FFAA\">%*</font> more for %*!"):format(Format.money(v40), t3.what)
            v39.Text = "Any pack marked ✔ ENOUGH covers it right now"
        else
            v38.Text = ("You can afford %* now! 🎉"):format(t3.what)
            v39.Text = "Go and get it!"
        end
    end)
end

function t1.buildCash(p20, p21, p22) -- line: 234
    -- upvalues: Config (copy), Products (copy), Style (copy), ladder (copy), needBanner (copy)
    needBanner(p20, p21, p22)
    ladder(p20, p21 + 1, p22, Products.CashPacks, "Cash", "Income", Style.KELP, Config.Icons.Cash, {
        { 3, 400 },
        { 2, 440 }
    })

    return p21 + 3
end

function t1.buildStrength(p23, p24, p25) -- line: 240
    -- upvalues: Config (copy), Products (copy), Style (copy), Boosts (copy), ladder (copy)
    ladder(p23, p24, p25, Products.StrengthPacks, "Strength", "StrengthRate", Style.OCEAN, Config.Icons.Strength, { { 3, 460 } })

    return Boosts.buildTraining(p23, p24 + 1, p25)
end

return t1

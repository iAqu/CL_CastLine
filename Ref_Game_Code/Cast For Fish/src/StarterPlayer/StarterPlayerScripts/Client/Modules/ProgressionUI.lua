-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local Products = require(Shared.Data.Products)
local Progression = require(Shared.Data.Progression)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local Toasts = require(script.Parent.Toasts)
local HUD = require(script.Parent.HUD)
local Windows = require(script.Parent.Windows)
local IndexIcons = require(script.Parent.IndexIcons)
local KernText = require(script.Parent.KernText)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local v1 = Vector2.new(0.5, 0.5)
local Left = Enum.TextXAlignment.Left
local t1 = {}

t1.Claimed = 0
t1.Celebrated = 0

local function badge(p1, p2) -- line: 36
    -- upvalues: UIKit (copy), Colors (copy), v1 (copy)
    local v2 = UIKit.frame(p1, {
        Name = "Badge",
        Corner = 23,
        Stroke = 4,
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, -6, 0, 6),
        AnchorPoint = v1,
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        ZIndex = p2
    })
    local v3 = UIKit.text(v2, {
        Name = "Count",
        Text = "",
        TextSize = 28,
        Stroke = 3,
        Size = UDim2.fromScale(1, 1),
        ZIndex = p2 + 1
    })

    v2.Visible = false

    return function(p3) -- line: 40
        -- upvalues: v2 (copy), v3 (copy), UIKit (copy)
        local Visible = v2.Visible

        v2.Visible = p3 > 0
        v3.Text = if p3 > 9 then "9+" else tostring(p3)

        if p3 > 0 and not Visible then
            UIKit.pop(v2, 1.5)
        end
    end
end

local function crateName(p4) -- line: 50
    -- upvalues: Products (copy)
    for _, v5 in ipairs(Products.Crates) do
        if v5.key == p4 then
            return v5.name
        end
    end

    return p4
end

local function prizeText(p5) -- line: 60
    -- upvalues: Products (copy), NumberFormat (copy), LocalPlayer (copy)
    local t2 = {}

    for _, v6 in ipairs(p5) do
        if v6.kind == "cash" then
            local v7 = LocalPlayer:GetAttribute("IncomePerSecond") or 0

            table.insert(t2, NumberFormat.money((math.max(v6.min or 0, (math.floor(v7 * 60 * (v6.mins or 1)))))) .. " Cash")
        elseif v6.kind == "lucky" then
            table.insert(t2, v6.n .. " Lucky Cast" .. (if v6.n == 1 then "" else "s"))
        elseif v6.kind == "crate" then
            local v13 = if v6.n > 1 then v6.n .. "x " else ""
            local key = v6.key
            local v14 = false
            local v15

            for _, v16 in ipairs(Products.Crates) do
                if v16.key == key then
                    v15 = v16.name
                    v14 = true
                    break
                end
            end

            if not v14 then
                v15 = key
            end

            table.insert(t2, v13 .. v15)
        end
    end

    return table.concat(t2, " + ")
end

local function clock(p6) -- line: 75
    local v19 = math.max(0, (math.ceil(p6)))

    if v19 >= 3600 then
        return string.format("%d:%02d:%02d", v19 // 3600, v19 % 3600 // 60, v19 % 60)
    end

    return string.format("%d:%02d", v19 // 60, v19 % 60)
end

local t3 = {}

t3[1] = 0

local elapsed = os.clock()
local t4 = {}

t4[1] = -1

local v20 = {}

local function readyGifts() -- line: 97
    -- upvalues: Progression (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref)
    local n1 = 0

    for v21 in ipairs(Progression.Gifts) do
        local v23 = t4[1] == Progression.Day()

        if v23 then
            local v24 = v20

            v23 = v24[tostring(v21)]
        end

        local v22

        if v23 then
            v22 = "opened"
        else
            local v25 = t4[1]
            local v26 = 0

            if v25 == Progression.Day() then
                local v27 = t3[1]
                local elapsed2 = os.clock()
                local elapsed3 = elapsed

                v26 = v27 + (elapsed2 - elapsed3)
            end

            v22 = if Progression.Gifts[v21].at * 60 <= v26 then "ready" else "locked"
        end

        if v22 == "ready" then
            n1 += 1
        end
    end

    return n1
end

local t5 = {
    { 0, 12, 0, 82 },
    { -40, 20, -14, 68 },
    { 40, 20, 14, 68 },
    { 0, 30, 5, 68 },
    { -24, -14, -9, 62 },
    { 26, -12, 11, 62 }
}

local function giftArt(p7, p8, p9) -- line: 113
    -- upvalues: ReplicatedStorage (copy), Progression (copy), UIKit (copy), fromRGB (copy), v1 (copy), t5 (copy)
    local v28 = p9 == #Progression.Gifts
    local v29 = UIKit.frame(p7, {
        Name = "Art",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(v28 and 176 or 156, v28 and 112 or 100),
        Position = UDim2.new(0.5, 0, 0, 62),
        AnchorPoint = v1
    })

    local function rankOf(p10) -- line: 116
        -- upvalues: p9 (copy), Progression (copy)
        local n2 = 0

        for i = 1, p9 do
            local v30 = Progression.Gifts[i].give[1]

            if v30 and v30.kind == p10 then
                n2 += 1
            end
        end

        return n2
    end

    local v31 = p8.give[1]

    if v31 and v31.kind == "crate" then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local Shop = Assets and Assets:FindFirstChild("Shop")
        local v32 = Shop and Shop:FindFirstChild(v31.key)

        if v32 then
            UIKit.viewModel(v29, v32, {
                ZIndex = 13,
                Spin = 30,
                Zoom = 0.68,
                Dir = Vector3.new(0.5, 0.22, -1)
            })
        else
            UIKit.image(v29, "Gift", {
                ZIndex = 13,
                Size = UDim2.fromOffset(100, 100),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = v1
            })
        end

        for _, v33 in ipairs(p8.give) do
            if v33.kind == "lucky" then
                UIKit.clover(v29, 52, {
                    ZIndex = 15,
                    Rotation = -16,
                    Position = UDim2.new(0.5, -64, 1, -16),
                    AnchorPoint = v1
                })
                UIKit.clover(v29, 58, {
                    ZIndex = 15,
                    Rotation = 14,
                    Position = UDim2.new(0.5, 62, 1, -12),
                    AnchorPoint = v1
                })
                break
            end
        end
    else
        local v34 = if v31 then v31.kind == "lucky" else nil

        if not v31 or not v34 then
            local v36 = math.clamp(rankOf("cash"), 1, #t5)

            for i = v36, 1, -1 do
                local v37 = t5[i]

                UIKit.icon(v29, "Cash", {
                    Size = UDim2.fromOffset(v37[4], v37[4]),
                    Position = UDim2.new(0.5, v37[1], 0.5, v37[2] - 8),
                    AnchorPoint = v1,
                    ZIndex = v36 - i + 13,
                    Rotation = v37[3]
                })
            end
        else
            local v38 = math.clamp(rankOf("lucky"), 1, 5)

            for i = 1, v38 do
                local v39 = i - (v38 + 1) / 2
                local v41 = math.floor(78 - math.abs(v39) * 8)

                UIKit.clover(v29, v41, {
                    Position = UDim2.new(0.5, v39 * 32, 0.5, math.abs(v39) * 8 + 2),
                    AnchorPoint = v1,
                    ZIndex = 20 - math.floor(math.abs(v39) * 2),
                    Rotation = v39 * 14
                })
            end
        end
    end

    UIKit.sparkle(v29, if v28 then 30 else 24, {
        ZIndex = 21,
        Position = UDim2.new(0.5, v28 and 74 or 62, 0, 8),
        Color = fromRGB(255, 245, 170),
        Phase = p9
    })

    return v29
end

local t9 = {
    {
        fromRGB(110, 190, 255),
        fromRGB(40, 90, 210)
    },
    {
        fromRGB(200, 130, 255),
        fromRGB(110, 50, 210)
    },
    {
        fromRGB(255, 214, 90),
        fromRGB(235, 130, 30)
    },
    {
        fromRGB(255, 120, 200),
        fromRGB(255, 190, 60)
    }
}

local function buildGifts() -- line: 170
    -- upvalues: RunService (copy), Progression (copy), UIKit (copy), Toasts (copy), Windows (copy), Remotes (copy), t1 (copy), Colors (copy), fromRGB (copy), v1 (copy), Left (copy), prizeText (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref), readyGifts (copy), giftArt (copy), t9 (copy)
    local v44 = UIKit.window(Windows.Gui, {
        Name = "Gifts",
        Title = "Playtime Gifts",
        GradientRotation = 0,
        Size = UDim2.fromOffset(980, 808),
        HeaderColor = fromRGB(255, 120, 180),
        HeaderColor2 = fromRGB(190, 70, 230)
    })
    local Content = v44.Content

    UIKit.image(v44.Frame, "Gift", {
        ZIndex = 14,
        Rotation = -8,
        Size = UDim2.fromOffset(92, 92),
        Position = UDim2.fromOffset(8, -12)
    })

    local Title = v44.Frame:FindFirstChild("Title")

    if Title then
        Title.Position = UDim2.fromOffset(104, 0)
    end

    UIKit.text(Content, {
        Name = "Sub",
        Text = "Play to open them all. Every one is better than the last, and they come back every day!",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.fromOffset(0, 2),
        Color = fromRGB(214, 226, 255)
    })

    local v45 = UIKit.frame(Content, {
        Name = "PlayedPill",
        Transparency = 0.2,
        Corner = 18,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(0, 36),
        Position = UDim2.new(0.5, 0, 0, 40),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(20, 14, 40),
        StrokeColor = Colors.Gold
    })

    v45.AutomaticSize = Enum.AutomaticSize.X

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 18)
    UIPadding.PaddingRight = UDim.new(0, 18)
    UIPadding.Parent = v45

    local v46 = UIKit.text(v45, {
        Name = "Played",
        Text = "",
        TextSize = 26,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.fromScale(0, 1),
        Color = Colors.Gold
    })

    v46.AutomaticSize = Enum.AutomaticSize.X

    local v47 = false
    local v48, v49 = UIKit.button(v44.Frame, {
        Name = "ClaimAll",
        Text = "CLAIM ALL",
        Corner = 18,
        Stroke = 3,
        TextStroke = 3,
        ZIndex = 13,
        Size = UDim2.fromOffset(190, 50),
        Position = UDim2.new(1, -84, 0, 13),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Green,
        Color2 = Colors.Green,
        OnClick = function() -- OnClick | line: 190
            -- upvalues: v47 (ref), Progression (copy), UIKit (copy), Toasts (copy), Remotes (copy), t1 (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref)
            if v47 then
                return
            end

            local t10 = {}

            for v50 in ipairs(Progression.Gifts) do
                local v52 = t4[1] == Progression.Day()

                if v52 then
                    local v53 = v20

                    v52 = v53[tostring(v50)]
                end

                local v51

                if v52 then
                    v51 = "opened"
                else
                    local v54 = t4[1]
                    local v55 = 0

                    if v54 == Progression.Day() then
                        local v56 = t3[1]
                        local elapsed2 = os.clock()
                        local elapsed3 = elapsed

                        v55 = v56 + (elapsed2 - elapsed3)
                    end

                    v51 = if Progression.Gifts[v50].at * 60 <= v55 then "ready" else "locked"
                end

                if v51 == "ready" then
                    table.insert(t10, v50)
                end
            end

            if #t10 == 0 then
                Toasts.Show("info", "No gifts ready yet!")
            else
                v47 = true
                task.spawn(function() -- line: 205
                    -- upvalues: t10 (copy), v47 (ref), UIKit (copy), Toasts (copy), Remotes (copy), t1 (copy), v20 (ref)
                    local n3 = 0

                    for _, v57 in ipairs(t10) do
                        local function v58() -- line: 208
                            -- upvalues: v57 (copy), Remotes (copy)
                            return Remotes.ClaimGift:InvokeServer(v57)
                        end

                        local ok, result = pcall(v58)

                        if ok and type(result) == "table" and result.ok then
                            n3 += 1
                            t1.Claimed += 1
                            v20[tostring(v57)] = true

                            local v60 = t1.GiftTiles and t1.GiftTiles[v57]

                            if v60 then
                                UIKit.pop(v60.tile, 1.15)
                            end

                            Toasts.Show("gold", "Gift #" .. v57 .. ": " .. tostring(result.text))
                        end
                    end

                    if n3 > 0 then
                        UIKit.sound("Unlock")
                    end

                    v47 = false
                    t1.RefreshGifts()
                end)
            end
        end
    })
    local v61
    local t11 = {}

    for v62, v63 in ipairs(Progression.Gifts) do
        local v64 = (v62 - 1) % 4
        local v65 = (v62 - 1) // 4
        local v67 = t9[if v62 == #Progression.Gifts then 4
            elseif v62 >= 9 then 3
            elseif v62 >= 5 then 2
            else 1]
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Gift" .. v62
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BackgroundColor3 = Colors.White
        TextButton.Size = UDim2.fromOffset(224, 200)
        TextButton.Position = UDim2.fromOffset(10 + v64 * 236, 88 + v65 * 206)
        TextButton.ZIndex = 12
        UIKit.corner(TextButton, 18)
        UIKit.stroke(TextButton, 5).ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIKit.gradient(TextButton, v67[1], v67[2])
        TextButton.Parent = Content
        UIKit.dress(TextButton, 18, v67[1]:Lerp(Colors.White, 0.6), 12)

        local v68 = UIKit.backdrop(TextButton, 18, 12)
        local v69 = UIKit.rays(v68, {
            Transparency = 0.7,
            ZIndex = 12,
            Speed = 14,
            Size = UDim2.fromOffset(300, 300),
            Position = UDim2.new(0.5, 0, 0, 62),
            AnchorPoint = v1
        })

        UIKit.text(TextButton, {
            Name = "Number",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 14,
            Text = "#" .. v62,
            Size = UDim2.fromOffset(60, 28),
            Position = UDim2.fromOffset(10, 6),
            XAlign = Left
        })

        local v70 = giftArt(TextButton, v63, v62)
        local v71 = UIKit.text(TextButton, {
            Name = "Prize",
            Text = "",
            Stroke = 3,
            ZIndex = 14,
            Size = UDim2.new(1, -16, 0, 42),
            Position = UDim2.fromOffset(8, 106)
        })
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 24
        UITextSizeConstraint.Parent = v71

        local v72 = UIKit.frame(TextButton, {
            Name = "State",
            Transparency = 0.35,
            Corner = 18,
            Stroke = 3,
            ZIndex = 14,
            Size = UDim2.new(1, -20, 0, 36),
            Position = UDim2.new(0.5, 0, 1, -10),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = fromRGB(14, 16, 40)
        })
        local v73 = UIKit.text(v72, {
            Name = "Text",
            Text = "",
            TextSize = 24,
            Stroke = 3,
            ZIndex = 15,
            Size = UDim2.fromScale(1, 1)
        })
        local v74 = UIKit.frame(TextButton, {
            Name = "Dim",
            Transparency = 0.5,
            Corner = 18,
            ZIndex = 16,
            Size = UDim2.fromScale(1, 1),
            Color = fromRGB(0, 0, 0)
        })

        UIKit.text(v74, {
            Name = "Check",
            Text = "OPENED",
            TextSize = 34,
            Rotation = -12,
            Stroke = 4,
            ZIndex = 17,
            Size = UDim2.fromScale(1, 1),
            Color = Colors.Green
        })
        v74.Visible = false
        UIKit.bindPress(TextButton, function() -- line: 260
            -- upvalues: v62 (copy), TextButton (copy), v63 (copy), Progression (copy), UIKit (copy), Toasts (copy), Remotes (copy), t1 (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref)
            local v76 = t4[1] == Progression.Day()

            v76 = v76 and v20[tostring(v62)]

            local v75

            if v76 then
                v75 = "opened"
            else
                local v78 = t4[1]
                local v79 = if v78 == Progression.Day() then t3[1] + (os.clock() - elapsed) else 0

                v75 = if Progression.Gifts[v62].at * 60 <= v79 then "ready" else "locked"
            end

            if v75 ~= "opened" then
                if v75 == "locked" then
                    local Show = Toasts.Show
                    local v83 = math.max(0, (math.ceil(v63.at * 60 - (if t4[1] == Progression.Day() then t3[1] + (os.clock() - elapsed) else 0))))

                    Show("info", "Gift #" .. v62 .. " opens in " .. (if v83 >= 3600 then string.format("%d:%02d:%02d", v83 // 3600, v83 % 3600 // 60, v83 % 60) else string.format("%d:%02d", v83 // 60, v83 % 60)))
                else
                    task.spawn(function() -- line: 268
                        -- upvalues: v62 (copy), TextButton (copy), UIKit (copy), Toasts (copy), Remotes (copy), t1 (copy), v20 (ref)
                        local function v84() -- line: 269
                            -- upvalues: v62 (copy), Remotes (copy)
                            return Remotes.ClaimGift:InvokeServer(v62)
                        end

                        local ok, result = pcall(v84)

                        if ok and type(result) == "table" and result.ok then
                            t1.Claimed += 1
                            v20[tostring(v62)] = true
                            UIKit.sound("Unlock")
                            UIKit.pop(TextButton, 1.15)
                            Toasts.Show("gold", "Gift #" .. v62 .. ": " .. tostring(result.text))
                        elseif ok and type(result) == "table" and result.reason then
                            Toasts.Show("error", result.reason)
                        end

                        t1.RefreshGifts()
                    end)
                end
            end
        end)
        t11[v62] = {
            tile = TextButton,
            box = v70,
            rays = v69,
            prize = v71,
            state = v72,
            stateText = v73,
            dim = v74
        }
    end

    t1.GiftTiles = t11

    local function refresh() -- line: 287
        -- upvalues: v46 (copy), v48 (copy), v49 (copy), v61 (ref), t11 (copy), Progression (copy), UIKit (copy), Colors (copy), fromRGB (copy), prizeText (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref), readyGifts (copy)
        local v86 = if t4[1] == Progression.Day() then t3[1] + (os.clock() - elapsed) else 0
        local v88 = math.max(0, (math.ceil(v86)))

        v46.Text = "Played today: " .. (if v88 >= 3600 then string.format("%d:%02d:%02d", v88 // 3600, v88 % 3600 // 60, v88 % 60) else string.format("%d:%02d", v88 // 60, v88 % 60))

        local v90 = readyGifts() > 0

        if v90 ~= v61 then
            v61 = v90
            UIKit.setButtonColor(v48, if v90 then Colors.Green else Colors.GreyDark, if v90 then Colors.Green else Colors.GreyDark)
            v49.TextTransparency = v90 and 0 or 0.3
        end

        for v93, v94 in ipairs(Progression.Gifts) do
            local v95 = t11[v93]
            local v97 = t4[1] == Progression.Day()

            if v97 then
                local v98 = v20

                v97 = v98[tostring(v93)]
            end

            local v96

            if v97 then
                v96 = "opened"
            else
                local v99 = t4[1]
                local v100 = 0

                if v99 == Progression.Day() then
                    local v101 = t3[1]
                    local elapsed2 = os.clock()
                    local elapsed3 = elapsed

                    v100 = v101 + (elapsed2 - elapsed3)
                end

                v96 = if Progression.Gifts[v93].at * 60 <= v100 then "ready" else "locked"
            end

            v95.prize.Text = prizeText(v94.give)
            v95.dim.Visible = v96 == "opened"
            v95.rays.Visible = v96 == "ready"

            if v96 == "ready" then
                v95.stateText.Text = "OPEN!"
                v95.state.BackgroundColor3 = Colors.Green
                v95.state.BackgroundTransparency = 0
                v95.box.Rotation = math.sin(os.clock() * 8 + v93) * 8
            else
                if v96 == "opened" then
                    v95.stateText.Text = ""
                    v95.state.BackgroundTransparency = 1
                else
                    local stateText = v95.stateText
                    local v105 = math.max(0, (math.ceil(v94.at * 60 - v86)))

                    if v105 >= 3600 then
                        stateText.Text = string.format("%d:%02d:%02d", v105 // 3600, v105 % 3600 // 60, v105 % 60)
                    else
                        stateText.Text = string.format("%d:%02d", v105 // 60, v105 % 60)
                    end

                    v95.state.BackgroundColor3 = fromRGB(14, 16, 40)
                    v95.state.BackgroundTransparency = 0.35
                end

                v95.box.Rotation = 0
            end
        end
    end

    t1.RefreshGifts = refresh
    v44.OnOpen = refresh
    RunService.Heartbeat:Connect(function() -- line: 322
        -- upvalues: v44 (copy), refresh (copy)
        if v44.IsOpen then
            refresh()
        end
    end)

    return v44
end

local function ownsFish(p11) -- line: 331
    -- upvalues: DataClient (copy)
    for _, v106 in ipairs({ "Backpack", "Placed" }) do
        for _, v107 in ipairs(DataClient.Get(v106) or {}) do
            if v107.id == p11 then
                return true
            end
        end
    end

    return false
end

local function rebirthReady() -- line: 341
    -- upvalues: Progression (copy), DataClient (copy), ownsFish (copy)
    local v108 = Progression.Rebirths[(DataClient.Get("Rebirths") or 0) + 1]

    return v108 ~= nil and (ownsFish(v108.need))
end

function t1.BoostWords(p12) -- line: 347
    local v109 = p12.cash or 1
    local v110 = p12.luck or 1
    local v111 = p12.strength or 1

    if v109 ~= v110 or v110 ~= v111 then
        return "BOOSTED", ("CASH x%d  •  LUCK x%d  •  STRENGTH x%d"):format(v109, v110, v111)
    end

    return "x" .. v110, "CASH  •  LUCK  •  STRENGTH"
end

local function celebrate(p13, p14, p15, p16) -- line: 356
    -- upvalues: Progression (copy), UIKit (copy), t1 (copy), Colors (copy), fromRGB (copy), v1 (copy)
    t1.Celebrated += 1

    local v112 = Progression.Rebirths[p13] or {
        luck = p14,
        cash = p15 or p14,
        strength = p16 or p14
    }
    local v113 = v112.cash or 1
    local v114 = v112.luck or 1
    local v115 = v112.strength or 1
    local v116, v117

    if v113 ~= v114 or v114 ~= v115 then
        v116 = "BOOSTED"
        v117 = ("CASH x%d  •  LUCK x%d  •  STRENGTH x%d"):format(v113, v114, v115)
    else
        v116 = "x" .. v114
        v117 = "CASH  •  LUCK  •  STRENGTH"
    end

    local v118 = UIKit.screenGui("RebirthFx", 40)
    local v119 = UIKit.frame(v118, {
        Name = "Shade",
        Transparency = 1,
        Size = UDim2.new(1, 2000, 1, 2000),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1,
        Color = fromRGB(10, 6, 30)
    })

    UIKit.tween(v119, 0.3, {
        BackgroundTransparency = 0.25
    })

    local v120 = UIKit.frame(v118, {
        Name = "Holder",
        Transparency = 1,
        ZIndex = 2,
        Size = UDim2.fromOffset(1200, 700),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = v1
    })
    local v121 = UIKit.rays(v120, {
        Transparency = 0.35,
        ZIndex = 2,
        Speed = 25,
        Size = UDim2.fromOffset(1100, 1100),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = v1,
        Color = fromRGB(255, 220, 120)
    })

    UIKit.image(v120, "Glow", {
        Transparency = 0.3,
        ZIndex = 3,
        Size = UDim2.fromOffset(700, 700),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = v1,
        Color = fromRGB(255, 240, 190)
    })

    local v122 = UIKit.text(v120, {
        Name = "Title",
        TextSize = 150,
        Stroke = 10,
        ZIndex = 5,
        Text = "REBIRTH " .. Progression.Roman(p13),
        Size = UDim2.new(1, 0, 0, 170),
        Position = UDim2.new(0.5, 0, 0.36, 0),
        AnchorPoint = v1,
        Color = Colors.Gold,
        StrokeColor = fromRGB(110, 50, 0)
    })
    local v123 = UIKit.text(v120, {
        Name = "Luck",
        TextSize = 92,
        Stroke = 8,
        ZIndex = 5,
        Text = v116 .. "!",
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0.5, 0, 0.57, 0),
        AnchorPoint = v1,
        Color = Colors.Green,
        StrokeColor = fromRGB(10, 70, 20)
    })

    UIKit.text(v120, {
        Name = "What",
        TextSize = 50,
        Stroke = 6,
        ZIndex = 5,
        Text = v117,
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0.5, 0, 0.69, 0),
        AnchorPoint = v1,
        Color = fromRGB(200, 255, 210),
        StrokeColor = fromRGB(10, 60, 20)
    })
    UIKit.text(v120, {
        Name = "Note",
        Text = "A fresh start, with more cash, luck and strength than ever",
        TextSize = 38,
        Stroke = 5,
        ZIndex = 5,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        AnchorPoint = v1
    })

    for i = 1, 10 do
        local v124 = i / 10 * 3.141592653589793 * 2

        UIKit.sparkle(v120, i % 3 * 24 + 60, {
            ZIndex = 4,
            Position = UDim2.new(0.5, math.cos(v124) * 470, 0.45, math.sin(v124) * 260),
            Color = if i % 2 == 0 then Colors.Gold else Colors.White
        })
    end

    UIKit.pop(v122, 2.2)
    task.delay(0.35, function() -- line: 375
        -- upvalues: v123 (copy), UIKit (copy)
        UIKit.pop(v123, 1.8)
        UIKit.sound("LevelUp")
    end)
    UIKit.sound("Unlock")

    local _require = require
    local CutsceneFx = script.Parent.CutsceneFx
    local ok, result = pcall(_require, CutsceneFx)

    if ok and result then
        local Burst = result.Burst
        local Gold, White = Colors.Gold, Colors.White

        pcall(Burst, "star", Gold, 16, White)

        local Burst2 = result.Burst
        local v126 = fromRGB(255, 240, 160)
        local Gold2 = Colors.Gold

        pcall(Burst2, "spark", v126, 30, Gold2)

        local Haptic = result.Haptic

        pcall(Haptic, 3)
    end

    task.delay(3.6, function() -- line: 386
        -- upvalues: v118 (copy), v119 (copy), v120 (copy), v121 (copy), UIKit (copy)
        UIKit.tween(v119, 0.4, {
            BackgroundTransparency = 1
        })

        for _, descendant in ipairs(v120:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                UIKit.tween(descendant, 0.4, {
                    TextTransparency = 1
                })
            elseif descendant:IsA("ImageLabel") then
                UIKit.tween(descendant, 0.4, {
                    ImageTransparency = 1
                })
            elseif descendant:IsA("UIStroke") then
                UIKit.tween(descendant, 0.4, {
                    Transparency = 1
                })
            end
        end

        task.wait(0.45)
        v121:Destroy()
        v118:Destroy()
    end)
end

t1.Celebrate = celebrate

local function buildRebirth() -- line: 404
    -- upvalues: RunService (copy), ContentProvider (copy), Fish (copy), Rarities (copy), Progression (copy), UIKit (copy), DataClient (copy), Toasts (copy), Windows (copy), IndexIcons (copy), KernText (copy), Remotes (copy), t1 (copy), Colors (copy), fromRGB (copy), v1 (copy), Left (copy), ownsFish (copy), celebrate (copy)
    local v127 = UIKit.window(Windows.Gui, {
        Name = "Rebirth",
        KeepRendered = true,
        Title = "Rebirth",
        GradientRotation = 0,
        Image = "Sparkle",
        Size = UDim2.fromOffset(1000, 720),
        HeaderColor = fromRGB(90, 230, 170),
        HeaderColor2 = fromRGB(255, 196, 60),
        ImageColor = Colors.Gold
    })
    local Content = v127.Content
    local v128 = UIKit.frame(Content, {
        Name = "Need",
        Corner = 20,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.fromOffset(360, 452),
        Color = fromRGB(70, 80, 150),
        Color2 = fromRGB(28, 30, 70)
    })

    UIKit.dress(v128, 20, fromRGB(170, 190, 255))

    local UIGradient = v128:FindFirstChildOfClass("UIGradient")
    local v129 = UIKit.backdrop(v128, 20, 12)

    UIKit.rays(v129, {
        Transparency = 0.75,
        ZIndex = 12,
        Speed = 10,
        Size = UDim2.fromOffset(560, 560),
        Position = UDim2.new(0.5, 0, 0, 170),
        AnchorPoint = v1
    })
    UIKit.text(v128, {
        Name = "Label",
        Text = "IT NEEDS",
        TextSize = 28,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.fromOffset(0, 12),
        Color = fromRGB(214, 226, 255)
    })

    local v130 = UIKit.image(v128, "Glow", {
        Transparency = 0.3,
        ZIndex = 12,
        Size = UDim2.fromOffset(420, 330),
        Position = UDim2.new(0.5, 0, 0, 175),
        AnchorPoint = v1
    })

    v130.ScaleType = Enum.ScaleType.Stretch

    local v131 = UIKit.frame(v128, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(330, 230),
        Position = UDim2.new(0.5, 0, 0, 60),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local Position = v131.Position
    local v132
    local t13 = {
        tidefather = "rbxassetid://124219036981155",
        seraphion = "rbxassetid://90678530368123",
        charybdis = "rbxassetid://129762437221110",
        kronos = "rbxassetid://101029304400025",
        khaos = "rbxassetid://81259525125713"
    }
    local t14 = {}

    task.spawn(function() -- line: 430
        -- upvalues: t13 (copy), ContentProvider (copy)
        local t15 = {}

        for _, v133 in t13 do
            table.insert(t15, v133)
        end

        local function v134() -- line: 435
            -- upvalues: t15 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t15)
        end

        pcall(v134)
    end)

    local function needPicture(p17, p18) -- line: 439
        -- upvalues: v131 (copy), t13 (copy), t14 (copy), IndexIcons (copy), v1 (copy)
        local v135 = t13[p17]
        local ImageLabel, v136

        if not v135 or t14[v135] then
            return IndexIcons.Picture(v131, p17, p18)
        else
            ImageLabel = Instance.new("ImageLabel")
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = v135
            v136 = if p18 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)
        end

        ImageLabel.ImageColor3 = v136
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.AnchorPoint = v1
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ZIndex = v131.ZIndex + 1
        ImageLabel.Parent = v131
        task.delay(4, function() -- line: 454
            -- upvalues: p17 (copy), p18 (copy), v135 (copy), ImageLabel (ref), v131 (copy), t14 (copy), IndexIcons (copy)
            if ImageLabel.Parent ~= v131 or ImageLabel.IsLoaded then
                return
            end

            t14[v135] = true

            local Name = ImageLabel.Name

            ImageLabel:Destroy()
            IndexIcons.Picture(v131, p17, p18).Name = Name
        end)

        return ImageLabel
    end

    local function showNeed(p19, p20, p21) -- line: 465
        -- upvalues: v130 (copy), v131 (copy), v132 (ref), needPicture (copy)
        v130.ImageColor3 = p21

        local v138 = p19 .. "|" .. tostring(p20)

        if v132 == v138 and v131:FindFirstChildWhichIsA("GuiObject") then
            return
        end

        v132 = v138
        v131:ClearAllChildren()
        needPicture(p19, not p20).Name = p20 and "Fish" or "Silhouette"
    end

    RunService.Heartbeat:Connect(function() -- line: 477
        -- upvalues: v127 (copy), v130 (copy), v131 (copy), Position (copy)
        if v127.IsOpen then
            local elapsed = os.clock()

            v131.Position = Position + UDim2.fromOffset(0, math.sin(elapsed * 1.6) * 6)

            local v141 = math.sin(elapsed * 2.3) * 0.5 + 0.5

            v130.ImageTransparency = 0.42 - v141 * 0.28

            local Rim = v131:FindFirstChild("Rim")

            if Rim then
                Rim.ImageTransparency = 0.22 - v141 * 0.2
            end
        end
    end)

    local v142 = UIKit.text(v128, {
        Name = "FishName",
        Text = "",
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.new(1, -24, 0, 50),
        Position = UDim2.fromOffset(12, 296)
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 44
    UITextSizeConstraint.Parent = v142

    local v143 = UIKit.text(v128, {
        Name = "Rarity",
        Text = "",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 14,
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, 346)
    })
    local v144 = UIKit.frame(v128, {
        Name = "Have",
        Corner = 14,
        Stroke = 4,
        ZIndex = 14,
        Size = UDim2.new(1, -36, 0, 46),
        Position = UDim2.new(0.5, 0, 1, -16),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Green,
        Color2 = Colors.GreenDark
    })
    local v145 = UIKit.text(v144, {
        Name = "Text",
        Text = "",
        TextSize = 26,
        Stroke = 3,
        ZIndex = 15,
        Size = UDim2.fromScale(1, 1)
    })
    local v146 = UIKit.frame(Content, {
        Name = "Right",
        Transparency = 1,
        ZIndex = 12,
        Size = UDim2.new(1, -380, 0, 452),
        Position = UDim2.fromOffset(380, 0)
    })
    local v147 = UIKit.text(v146, {
        Name = "Title",
        Text = "",
        TextSize = 64,
        Stroke = 6,
        ZIndex = 14,
        Size = UDim2.new(1, 0, 0, 70),
        Color = Colors.Gold,
        StrokeColor = fromRGB(110, 50, 0)
    })
    local v148 = UIKit.frame(v146, {
        Name = "Luck",
        Corner = 18,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, 0, 0, 84),
        Position = UDim2.fromOffset(0, 76),
        Color = fromRGB(30, 110, 60),
        Color2 = fromRGB(10, 40, 24)
    })

    UIKit.dress(v148, 18, fromRGB(140, 255, 170))
    UIKit.clover(v148, 64, {
        ZIndex = 14,
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    local v149 = UIKit.text(v148, {
        Name = "Text",
        Text = "",
        TextSize = 42,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.new(1, -96, 0, 46),
        Position = UDim2.fromOffset(90, 4),
        XAlign = Left,
        Color = Colors.Green,
        StrokeColor = fromRGB(10, 50, 20)
    })
    local v150 = UIKit.text(v148, {
        Name = "What",
        Text = "",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -96, 0, 28),
        Position = UDim2.fromOffset(90, 50),
        XAlign = Left,
        Color = fromRGB(200, 255, 210),
        StrokeColor = fromRGB(10, 50, 20)
    })

    local function listBox(p22, p23, p24, p25, p26, p27) -- line: 505
        -- upvalues: v146 (copy), UIKit (copy), Colors (copy), fromRGB (copy), Left (copy)
        local v151 = UIKit.frame(v146, {
            Corner = 16,
            Stroke = 4,
            ZIndex = 13,
            Name = p22,
            Size = UDim2.new(0.5, -8, 0, 276),
            Position = UDim2.new(p23, p23 > 0 and 8 or 0, 0, 176),
            Color = p25:Lerp(fromRGB(26, 30, 66), 0.8),
            Color2 = fromRGB(14, 16, 40)
        })

        UIKit.dress(v151, 16, p25:Lerp(Colors.White, 0.5))

        local v152 = UIKit.frame(v151, {
            Name = "Head",
            Corner = 14,
            Stroke = 3,
            ZIndex = 14,
            Size = UDim2.new(1, 0, 0, 44),
            Color = p25,
            Color2 = p26
        })

        UIKit.frame(v152, {
            Name = "Shine",
            Transparency = 0.65,
            Corner = 5,
            ZIndex = 14,
            Size = UDim2.new(1, -16, 0, 10),
            Position = UDim2.fromOffset(8, 5),
            Color = Colors.White
        })
        UIKit.text(v152, {
            Name = "Text",
            TextSize = 28,
            Stroke = 3,
            ZIndex = 15,
            Text = p24,
            Size = UDim2.fromScale(1, 1)
        })

        for v153, v154 in ipairs(p27) do
            UIKit.text(v151, {
                TextSize = 22,
                Stroke = 3,
                ZIndex = 14,
                Name = "Line" .. v153,
                Text = v154,
                Size = UDim2.new(1, -24, 0, 30),
                Position = UDim2.fromOffset(14, 50 + (v153 - 1) * 31),
                XAlign = Left,
                Color = fromRGB(225, 232, 255)
            })
        end
    end

    listBox("Lose", 0, "YOU START AGAIN", Colors.Red, Colors.RedDark, { "- Cash", "- Cast Power & level", "- Dumbbells", "- Baits & rods", "- Plot size", "- Every fish you caught", "  (the one it needs too)" })
    listBox("Keep", 0.5, "YOU KEEP", Colors.Green, Colors.GreenDark, { "+ Your Fish Index", "+ Crate & lantern fish", "+ Lucky Casts & crates", "+ Gamepasses & codes", "+ Index reward luck", "+ All your rebirths", "" })

    local t17 = {}

    for i = 1, #Progression.Rebirths do
        local v155 = UIKit.frame(Content, {
            Corner = 39,
            Stroke = 4,
            ZIndex = 12,
            Name = "Pip" .. i,
            Size = UDim2.fromOffset(78, 78),
            Position = UDim2.fromOffset((i - 1) * 92 + 10, 484),
            Color = fromRGB(30, 34, 70)
        })

        UIKit.dress(v155, 39)
        t17[i] = {
            frame = v155,
            text = UIKit.text(v155, {
                Name = "Text",
                TextSize = 32,
                Stroke = 3,
                ZIndex = 13,
                Text = Progression.Roman(i),
                Size = UDim2.fromScale(1, 1)
            })
        }
    end

    UIKit.text(Content, {
        Name = "PipsLabel",
        Text = "Each rebirth doubles your cash, luck and strength",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 12,
        Size = UDim2.fromOffset(460, 28),
        Position = UDim2.fromOffset(10, 572),
        XAlign = Left,
        Color = fromRGB(190, 205, 255)
    })

    local n4 = 0
    local v156, v157 = UIKit.button(Content, {
        Name = "Go",
        Text = "REBIRTH",
        Corner = 22,
        Stroke = 6,
        ZIndex = 12,
        Size = UDim2.fromOffset(400, 110),
        Position = UDim2.new(1, -6, 0, 478),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Green,
        Color2 = Colors.GreenDark
    })

    v157.TextScaled = true

    local v158 = KernText.new(v157)

    local function refresh() -- line: 530
        -- upvalues: UIGradient (copy), v130 (copy), v131 (copy), v132 (ref), needPicture (copy), v142 (copy), v143 (copy), v144 (copy), v145 (copy), v147 (copy), v149 (copy), v150 (copy), t17 (copy), n4 (ref), v156 (copy), v158 (copy), Fish (copy), Rarities (copy), Progression (copy), UIKit (copy), DataClient (copy), Colors (copy), fromRGB (copy), v1 (copy), ownsFish (copy)
        local v159 = DataClient.Get("Rebirths") or 0
        local v160 = Progression.Rebirths[v159 + 1]

        for v161, v162 in ipairs(t17) do
            local frame = v162.frame

            if v161 <= v159 then
                frame.BackgroundColor3 = Colors.Gold
            elseif v161 == v159 + 1 then
                frame.BackgroundColor3 = fromRGB(70, 150, 110)
            else
                frame.BackgroundColor3 = fromRGB(30, 34, 70)
            end

            local text = v162.text

            if v161 <= v159 then
                text.TextColor3 = fromRGB(110, 60, 0)
            else
                text.TextColor3 = Colors.White
            end
        end

        v130.ImageColor3 = Colors.Gold

        if v160 then
            local v163 = Fish.ById[v160.need]
            local v164 = Rarities.ById[v163.rarity]

            v147.Text = "REBIRTH " .. Progression.Roman(v159 + 1)

            local v165 = Progression.Rebirths[v159] or {
                cash = 1,
                luck = 1,
                strength = 1
            }
            local v166 = v160.cash or 1
            local v167 = v160.luck or 1
            local v168 = v160.strength or 1
            local v169, v170

            if v166 ~= v167 or v167 ~= v168 then
                v169 = "BOOSTED"
                v170 = ("CASH x%d  •  LUCK x%d  •  STRENGTH x%d"):format(v166, v167, v168)
            else
                v169 = "x" .. v167
                v170 = "CASH  •  LUCK  •  STRENGTH"
            end

            local v171 = v165.cash or 1
            local v172 = v165.luck or 1
            local v173 = v165.strength or 1
            local v174

            if v171 ~= v172 or v172 ~= v173 then
                v174 = "BOOSTED";
                ("CASH x%d  •  LUCK x%d  •  STRENGTH x%d"):format(v171, v172, v173)
            else
                v174 = "x" .. v172
            end

            v149.Text = if v169 == "BOOSTED" then "BOOSTED" else v174 .. "  >>  " .. v169
            v150.Text = v170

            local function bright(p28) -- line: 567
                return p28.R * 0.3 + p28.G * 0.59 + p28.B * 0.11
            end

            local v176 = if not v164 then Colors.White elseif bright(v164.Color) >= bright(v164.Color2) then v164.Color else v164.Color2

            v142.Text = v163.name
            v142.TextColor3 = v176
            v143.Text = if v164 then v164.name else ""
            v143.TextColor3 = v176:Lerp(Colors.White, 0.35)

            if UIGradient and v164 then
                UIGradient.Color = ColorSequence.new(v164.Color:Lerp(fromRGB(30, 30, 60), 0.55), fromRGB(20, 20, 46))
            end

            local v179 = ownsFish(v160.need)
            local need = v160.need

            v130.ImageColor3 = if not v164 then Colors.White else v176

            local v180 = need .. "|" .. tostring(v179)

            if v132 ~= v180 or not v131:FindFirstChildWhichIsA("GuiObject") then
                v132 = v180
                v131:ClearAllChildren()
                needPicture(need, not v179).Name = v179 and "Fish" or "Silhouette"
            end

            v145.Text = v179 and "YOU HAVE ONE!" or "CATCH ONE FIRST"

            local setButtonColor = UIKit.setButtonColor
            local v182 = if v179 then Colors.Green else Colors.Red
            local v181 = if v179 then Colors.GreenDark else Colors.RedDark

            setButtonColor(v144, v182, v181)

            if v179 then
                if os.clock() < n4 then
                    v158:Set("TAP AGAIN TO CONFIRM")
                    UIKit.setButtonColor(v156, Colors.Orange, Colors.OrangeDark)
                else
                    v158:Set("REBIRTH")
                    UIKit.setButtonColor(v156, Colors.Green, Colors.GreenDark)
                end
            else
                v158:Set("MISSING " .. string.upper((string.gsub(v163.name, "^The ", ""))))
                UIKit.setButtonColor(v156, Colors.Grey, Colors.GreyDark)
            end
        else
            v131:ClearAllChildren()
            v132 = nil
            v147.Text = "MAX REBIRTH!"

            local v183 = Progression.Rebirths[v159] or {
                cash = 1,
                luck = 1,
                strength = 1
            }
            local v184 = v183.cash or 1
            local v185 = v183.luck or 1
            local v186 = v183.strength or 1
            local v187, v188

            if v184 ~= v185 or v185 ~= v186 then
                v187 = "BOOSTED"
                v188 = ("CASH x%d  •  LUCK x%d  •  STRENGTH x%d"):format(v184, v185, v186)
            else
                v187 = "x" .. v185
                v188 = "CASH  •  LUCK  •  STRENGTH"
            end

            v149.Text = v187
            v150.Text = v188
            v142.Text = "Every rebirth done"
            v142.TextColor3 = Colors.Gold
            v143.Text = ""
            v145.Text = "YOU ARE A LEGEND"
            UIKit.setButtonColor(v144, Colors.Gold, Colors.GoldDark)
            v158:Set("MAXED")
            UIKit.setButtonColor(v156, Colors.Grey, Colors.GreyDark)
            UIKit.image(v131, "Trophy", {
                ZIndex = 14,
                Size = UDim2.fromOffset(200, 200),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = v1
            })
        end
    end

    t1.RefreshRebirth = refresh

    v127.OnOpen = function() -- line: 594
        -- upvalues: n4 (ref), refresh (copy)
        n4 = 0
        refresh()
    end

    local v189 = false

    v156.Activated:Connect(function() -- line: 599
        -- upvalues: v127 (copy), n4 (ref), refresh (copy), v189 (ref), Fish (copy), Progression (copy), DataClient (copy), Toasts (copy), Remotes (copy), ownsFish (copy)
        local v190 = DataClient.Get("Rebirths") or 0
        local v191 = Progression.Rebirths[v190 + 1]

        if v191 and not v189 then
            if ownsFish(v191.need) then
                if os.clock() >= n4 then
                    n4 = os.clock() + 4
                    refresh()
                    task.delay(4.05, function() -- line: 612
                        -- upvalues: v127 (copy), refresh (copy)
                        if v127.IsOpen then
                            refresh()
                        end
                    end)
                else
                    v189 = true
                    n4 = 0
                    task.spawn(function() -- line: 621
                        -- upvalues: v127 (copy), refresh (copy), v189 (ref), Toasts (copy), Remotes (copy)
                        local function v192() -- line: 622
                            -- upvalues: Remotes (copy)
                            return Remotes.Rebirth:InvokeServer()
                        end

                        local ok, result = pcall(v192)

                        v189 = false

                        if ok then
                            if type(result) == "table" and result.ok then
                                v127.Close()
                            elseif type(result) == "table" and result.reason then
                                Toasts.Show("error", result.reason)
                                refresh()
                            end
                        end
                    end)
                end
            else
                Toasts.Show("error", "Catch " .. Fish.ById[v191.need].name .. " first!")
            end
        end
    end)
    Remotes.Reborn.OnClientEvent:Connect(function(p29, p30, p31, p32) -- line: 634
        -- upvalues: celebrate (copy)
        celebrate(p29, p30, p31, p32)
    end)

    return v127
end

local function claimableIndex() -- line: 641
    -- upvalues: Progression (copy), DataClient (copy)
    local v193 = Progression.IndexCount(DataClient.Get("Index"))
    local v194 = DataClient.Get("IndexClaimed") or {}
    local n5 = 0

    for _, v195 in ipairs(Progression.IndexRewards) do
        if v195.at <= v193 and not v194[tostring(v195.at)] then
            n5 += 1
        end
    end

    return n5
end

local function buildIndexRewards() -- line: 653
    -- upvalues: Progression (copy), UIKit (copy), DataClient (copy), Toasts (copy), Windows (copy), Remotes (copy), t1 (copy), Colors (copy), fromRGB (copy), Left (copy), prizeText (copy)
    local v196 = UIKit.window(Windows.Gui, {
        Name = "IndexRewards",
        Title = "Index Rewards",
        GradientRotation = 0,
        Size = UDim2.fromOffset(1000, 800),
        HeaderColor = fromRGB(70, 200, 255),
        HeaderColor2 = fromRGB(120, 84, 250)
    })
    local Content = v196.Content

    UIKit.image(v196.Frame, "Trophy", {
        ZIndex = 14,
        Rotation = -8,
        Size = UDim2.fromOffset(92, 92),
        Position = UDim2.fromOffset(8, -12)
    })

    local Title = v196.Frame:FindFirstChild("Title")

    if Title then
        Title.Position = UDim2.fromOffset(104, 0)
    end

    local v197 = UIKit.frame(Content, {
        Name = "Summary",
        Corner = 18,
        Stroke = 5,
        ZIndex = 12,
        Size = UDim2.new(1, 0, 0, 92),
        Color = fromRGB(70, 92, 190),
        Color2 = fromRGB(36, 42, 104)
    })
    local v198 = UIKit.text(v197, {
        Name = "Found",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(0.5, -20, 1, 0),
        Position = UDim2.fromOffset(20, 0),
        XAlign = Left
    })
    local v199 = UIKit.text(v197, {
        Name = "Luck",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(0.5, -230, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        XAlign = Left,
        Color = Colors.Green
    })

    UIKit.button(v197, {
        Name = "Back",
        Text = "INDEX",
        Corner = 14,
        ZIndex = 13,
        Size = UDim2.fromOffset(190, 60),
        Position = UDim2.new(1, -16, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.Blue,
        Color2 = Colors.BlueDark,
        OnClick = function() -- OnClick | line: 664
            -- upvalues: UIKit (copy)
            local Index = UIKit.Windows.Index

            if Index then
                Index.Open()
            end
        end
    })

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -106)
    ScrollingFrame.Position = UDim2.fromOffset(0, 106)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 12
    ScrollingFrame.Parent = Content

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local t18 = {}

    for v200, v201 in ipairs(Progression.IndexRewards) do
        local v202 = UIKit.frame(ScrollingFrame, {
            Corner = 16,
            Stroke = 4,
            ZIndex = 13,
            Name = "Reward" .. v200,
            Size = UDim2.new(1, -18, 0, 104),
            Color = fromRGB(46, 56, 120),
            Color2 = fromRGB(24, 28, 66)
        })

        v202.LayoutOrder = v200

        local v203 = UIKit.frame(v202, {
            Name = "At",
            Corner = 42,
            Stroke = 4,
            ZIndex = 14,
            Size = UDim2.fromOffset(84, 84),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Color = fromRGB(255, 214, 90),
            Color2 = fromRGB(235, 130, 30)
        })

        UIKit.text(v203, {
            Name = "Text",
            TextSize = 34,
            Stroke = 4,
            ZIndex = 15,
            Text = tostring(v201.at),
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.fromOffset(0, 12)
        })
        UIKit.text(v203, {
            Name = "Caption",
            Text = "SPECIES",
            TextSize = 14,
            Stroke = 2,
            ZIndex = 15,
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.fromOffset(0, 52)
        })

        local v204 = UIKit.text(v202, {
            Name = "Prize",
            Text = "",
            Stroke = 3,
            ZIndex = 14,
            Size = UDim2.new(1, -350, 0, 34),
            Position = UDim2.fromOffset(112, 10),
            XAlign = Left
        })
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 28
        UITextSizeConstraint.Parent = v204
        UIKit.text(v202, {
            Name = "LuckLine",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 14,
            Text = if v201.luck > 0 then "+" .. math.floor(v201.luck * 100 + 0.5) .. "% luck forever" else "",
            Size = UDim2.new(1, -350, 0, 26),
            Position = UDim2.fromOffset(112, 44),
            XAlign = Left,
            Color = Colors.Green
        })

        local v206 = UIKit.frame(v202, {
            Name = "Bar",
            Corner = 9,
            ZIndex = 14,
            Size = UDim2.new(1, -350, 0, 18),
            Position = UDim2.fromOffset(112, 76),
            Color = fromRGB(10, 12, 30)
        })
        local v207 = UIKit.frame(v206, {
            Name = "Fill",
            Corner = 9,
            ZIndex = 15,
            Size = UDim2.fromScale(0, 1),
            Color = Colors.Green,
            Color2 = Colors.GreenDark
        })
        local v208, v209 = UIKit.button(v202, {
            Name = "Claim",
            Text = "",
            Corner = 16,
            ZIndex = 14,
            Size = UDim2.fromOffset(210, 70),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = Colors.Green,
            Color2 = Colors.GreenDark
        })

        v208.Activated:Connect(function() -- line: 701
            -- upvalues: v200 (copy), v202 (copy), v201 (copy), Progression (copy), UIKit (copy), DataClient (copy), Toasts (copy), Remotes (copy), t1 (copy)
            local v210 = Progression.IndexCount(DataClient.Get("Index"))

            if not (DataClient.Get("IndexClaimed") or {})[tostring(v201.at)] then
                if v210 < v201.at then
                    Toasts.Show("info", "Discover " .. v201.at - v210 .. " more species to claim this")
                else
                    task.spawn(function() -- line: 711
                        -- upvalues: v200 (copy), v202 (copy), UIKit (copy), Toasts (copy), Remotes (copy), t1 (copy)
                        local function v212() -- line: 712
                            -- upvalues: v200 (copy), Remotes (copy)
                            return Remotes.ClaimIndexReward:InvokeServer(v200)
                        end

                        local ok, result = pcall(v212)

                        if ok then
                            if type(result) == "table" and result.ok then
                                t1.Claimed += 1
                                UIKit.sound("Unlock")
                                UIKit.pop(v202, 1.06)
                                Toasts.Show("gold", "Index reward: " .. tostring(result.text))
                            elseif type(result) == "table" and result.reason then
                                Toasts.Show("error", result.reason)
                            end
                        end
                    end)
                end
            end
        end)
        t18[v200] = {
            row = v202,
            prize = v204,
            fill = v207,
            button = v208,
            label = v209
        }
    end

    local function refresh() -- line: 727
        -- upvalues: v198 (copy), v199 (copy), t18 (copy), Progression (copy), UIKit (copy), DataClient (copy), Colors (copy), fromRGB (copy), prizeText (copy)
        local v213 = Progression.IndexCount(DataClient.Get("Index"))
        local v214 = DataClient.Get("IndexClaimed") or {}

        v198.Text = "SPECIES FOUND  " .. v213 .. " / " .. Progression.CATCHABLE
        v199.Text = "LUCK BONUS +" .. math.floor((Progression.IndexLuck(v214) - 1) * 100 + 0.5) .. "%"

        for v216, v217 in ipairs(Progression.IndexRewards) do
            local v218 = t18[v216]

            v218.prize.Text = prizeText(v217.give)
            v218.fill.Size = UDim2.fromScale(math.clamp(v213 / v217.at, 0, 1), 1)

            if v214[tostring(v217.at)] then
                v218.label.Text = "CLAIMED"
                UIKit.setButtonColor(v218.button, Colors.Grey, Colors.GreyDark)
            elseif v217.at <= v213 then
                v218.label.Text = "CLAIM!"
                UIKit.setButtonColor(v218.button, Colors.Green, Colors.GreenDark)
            else
                v218.label.Text = v213 .. " / " .. v217.at
                UIKit.setButtonColor(v218.button, fromRGB(60, 66, 110), fromRGB(36, 40, 76))
            end
        end
    end

    t1.RefreshIndexRewards = refresh
    v196.OnOpen = refresh

    return v196
end

function t1.Init() -- line: 754
    -- upvalues: Progression (copy), UIKit (copy), DataClient (copy), Toasts (copy), HUD (copy), t1 (copy), Colors (copy), fromRGB (copy), badge (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref), readyGifts (copy), buildGifts (copy), ownsFish (copy), buildRebirth (copy), claimableIndex (copy), buildIndexRewards (copy)
    UIKit.HudThemes.Gifts = {
        top = fromRGB(255, 150, 200),
        bottom = fromRGB(225, 60, 150),
        rim = fromRGB(170, 30, 110),
        rim2 = fromRGB(120, 16, 76),
        edge = fromRGB(255, 214, 236),
        glow = fromRGB(255, 236, 246)
    }
    UIKit.HudThemes.Rebirth = {
        top = fromRGB(120, 245, 180),
        bottom = fromRGB(24, 160, 120),
        rim = fromRGB(14, 112, 86),
        rim2 = fromRGB(8, 72, 56),
        edge = fromRGB(204, 255, 232),
        glow = fromRGB(236, 255, 246)
    }
    UIKit.Art.GiftsIcon = UIKit.Art.Gift
    UIKit.Art.RebirthIcon = "rbxassetid://129641969238866"

    local v220 = buildGifts()
    local v221 = buildRebirth()
    local v222 = buildIndexRewards()
    local Left = HUD.Left or HUD.Gui and HUD.Gui:FindFirstChild("Left")
    local v223

    if Left then
        local v224 = HUD.BUTTON_GAP or 166

        v223 = UIKit.hudButton(Left, "Rebirth", "Rebirth", fromRGB(204, 255, 232), function() -- line: 768
            -- upvalues: v221 (copy)
            v221.Toggle()
        end)
        v223.Position = UDim2.fromOffset(0, v224 * 2)

        local RebirthIcon = v223:FindFirstChild("RebirthIcon")

        if RebirthIcon then
            RebirthIcon.Size = UDim2.fromOffset(112, 112)
            RebirthIcon.Position = UDim2.new(0.5, 0, 0, 4)
        end

        UIKit.sparkle(v223, 46, {
            ZIndex = 3,
            Position = UDim2.new(0.78, 0, 0.22, 0),
            Color = Colors.White
        })
        t1.RebirthButton = v223
    end

    local TopBar = require(script.Parent.TopBar)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Gifts"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.AutomaticSize = Enum.AutomaticSize.X
    TextButton.Size = UDim2.fromOffset(0, TopBar.HEIGHT)
    TextButton.BackgroundColor3 = TopBar.DARK
    TextButton.BackgroundTransparency = 0.08
    TextButton.BorderSizePixel = 0
    UIKit.corner(TextButton, TopBar.HEIGHT / 2)

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 16)
    UIPadding.Parent = TextButton

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.Parent = TextButton
    UIKit.image(TextButton, "Gift", {
        Size = UDim2.fromOffset(32, 32)
    }).LayoutOrder = 1

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromOffset(0, TopBar.HEIGHT)
    TextLabel.Font = Enum.Font.BuilderSansBold
    TextLabel.TextSize = 20
    TextLabel.TextColor3 = Colors.White
    TextLabel.Text = "GIFTS"
    TextLabel.LayoutOrder = 2
    TextLabel.Parent = TextButton

    local Frame = Instance.new("Frame")

    Frame.Name = "Count"
    Frame.Size = UDim2.fromOffset(24, 24)
    Frame.Position = UDim2.new(1, 26, 0, -4)
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.BackgroundColor3 = Colors.White
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    UIKit.corner(Frame, 12)
    Frame.Parent = TextLabel

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.Font = Enum.Font.BuilderSansBold
    TextLabel2.TextSize = 16
    TextLabel2.TextColor3 = TopBar.DARK
    TextLabel2.ZIndex = 4
    TextLabel2.Parent = Frame
    Frame.Visible = false
    UIKit.bindPress(TextButton, function() -- line: 838
        -- upvalues: v220 (copy)
        v220.Toggle()
    end)
    TopBar.Add(TextButton, 20)
    t1.GiftsButton = TextButton

    local v226 = nil

    local function giftBadge(p33) -- line: 844
        -- upvalues: TopBar (copy), TextLabel (copy), Frame (copy), TextLabel2 (copy), v226 (ref), Progression (copy), UIKit (copy), Colors (copy), fromRGB (copy), t3 (copy), elapsed (ref), t4 (copy), v20 (ref)
        local v227

        if p33 > 0 then
            v227 = "CLAIM!"
        else
            local v228

            for v229, v230 in ipairs(Progression.Gifts) do
                local v232 = t4[1] == Progression.Day()

                v232 = v232 and v20[tostring(v229)]

                local v231

                if v232 then
                    v231 = "opened"
                else
                    local v234 = t4[1]
                    local v235 = if v234 == Progression.Day() then t3[1] + (os.clock() - elapsed) else 0

                    v231 = if Progression.Gifts[v229].at * 60 <= v235 then "ready" else "locked"
                end

                if v231 == "locked" then
                    v228 = v230.at * 60 - (if t4[1] == Progression.Day() then t3[1] + (os.clock() - elapsed) else 0)
                    break
                end

                v228 = nil
            end

            if v228 then
                local v238 = math.max(0, (math.ceil(v228)))

                v227 = if v238 >= 3600 then string.format("%d:%02d:%02d", v238 // 3600, v238 % 3600 // 60, v238 % 60) else string.format("%d:%02d", v238 // 60, v238 % 60)
            else
                v227 = "GIFTS"
            end
        end

        TextLabel.Text = v227
        TextLabel.Size = UDim2.fromOffset(game:GetService("TextService"):GetTextSize(v227, TextLabel.TextSize, TextLabel.Font, Vector2.new(1000, TopBar.HEIGHT)).X + 2, TopBar.HEIGHT)
        TextLabel2.Text = if p33 > 9 then "9+" else tostring(p33)

        local Visible = Frame.Visible

        Frame.Visible = p33 > 0

        if p33 > 0 and not Visible then
            UIKit.pop(Frame, 1.5)
        end

        local v240 = v226

        if v240 == (p33 > 0) then
            return
        end

        v226 = p33 > 0
        TextLabel.TextColor3 = if p33 > 0 then fromRGB(255, 225, 90) else Colors.White
    end

    local v242 = v223 and badge(v223, 6)
    local v243 = HUD.IndexButton and badge(HUD.IndexButton, 6)
    local Index = UIKit.Windows.Index
    local v244

    if Index then
        v244 = badge(UIKit.button(Index.Frame, {
            Name = "Rewards",
            Text = "REWARDS",
            Corner = 12,
            Stroke = 5,
            ZIndex = 13,
            Size = UDim2.fromOffset(210, 56),
            Position = UDim2.new(1, -82, 0, 9),
            AnchorPoint = Vector2.new(1, 0),
            Color = Colors.Gold,
            Color2 = Colors.GoldDark,
            OnClick = function() -- OnClick | line: 878
                -- upvalues: v222 (copy)
                v222.Open()
            end
        }), 15)

        local Close = v222.Frame:FindFirstChild("Close")

        if Close and Close:IsA("GuiButton") then
            Close.Activated:Connect(function() -- line: 884
                -- upvalues: Index (copy)
                Index.Open()
            end)
        end
    end

    DataClient.Observe("Playtime", function(p34) -- line: 891
        -- upvalues: t3 (copy), elapsed (ref), t4 (copy), v20 (ref)
        if type(p34) ~= "table" then
            return
        end

        local v246 = tonumber(p34.secs) or 0
        local elapsed2 = os.clock()
        local v247 = tonumber(p34.day) or -1

        t3[1] = v246
        elapsed = elapsed2
        t4[1] = v247
        v20 = if type(p34.got) == "table" then p34.got else {}
    end)

    local function refreshRebirthBits() -- line: 897
        -- upvalues: v221 (copy), v242 (copy), Progression (copy), DataClient (copy), t1 (copy), ownsFish (copy)
        if v242 then
            local v248 = Progression.Rebirths[(DataClient.Get("Rebirths") or 0) + 1]

            v242(v248 ~= nil and ownsFish(v248.need) and 1 or 0)
        end

        if v221.IsOpen then
            t1.RefreshRebirth()
        end
    end

    for _, v250 in ipairs({ "Backpack", "Placed", "Rebirths", "Index" }) do
        DataClient.Observe(v250, refreshRebirthBits)
    end

    local function refreshIndexBits() -- line: 908
        -- upvalues: v222 (copy), v244 (ref), v243 (copy), t1 (copy), claimableIndex (copy)
        local v251 = claimableIndex()

        if v243 then
            v243(v251)
        end

        if v244 then
            v244(v251)
        end

        if v222.IsOpen then
            t1.RefreshIndexRewards()
        end
    end

    DataClient.Observe("Index", refreshIndexBits)
    DataClient.Observe("IndexClaimed", refreshIndexBits)

    local v252

    task.spawn(function() -- line: 924
        -- upvalues: giftBadge (copy), v252 (ref), DataClient (copy), Toasts (copy), HUD (copy), readyGifts (copy)
        while true do
            if not DataClient.IsReady() then
                task.wait(1)
                continue
            end

            local v253 = readyGifts()

            if giftBadge then
                giftBadge(v253)
            end

            if v252 and v252 < v253 and HUD.GetMode() == "normal" then
                Toasts.Show("gold", "A playtime gift is ready! Tap Gifts to open it")
            end

            v252 = v253
            task.wait(1)
        end
    end)
end

return t1

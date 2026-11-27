-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local Loc = require(Modules:WaitForChild("Loc"))
local AchievementConfig = require(Modules:WaitForChild("AchievementConfig"))
local Look = require(script:WaitForChild("Look"))
local Badge = require(Modules:WaitForChild("Badge"))
local LocalPlayer = Players.LocalPlayer
local Achievements = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("XPGui"):WaitForChild("Achievements")
local Scale = Achievements:WaitForChild("Scale")
local Main = Achievements:WaitForChild("Main")
local Close = Main:WaitForChild("Close")
local List = Main:WaitForChild("ListClip"):WaitForChild("List")

require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Watch(List.Parent)

local UIListLayout = List:WaitForChild("UIListLayout")
local Template = List:WaitForChild("Template")

Template.Visible = false

local t2 = {
    ROW_FIRST = 0.1,
    ROW_STEP = 0.05,
    BAR_DELAY = 0.12,
    ROW_POP = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BAR_SWEEP = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BAR_CHANGE = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DRIFT = TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
}
local v1 = utf8.char(57346)
local t3 = {
    image = "rbxassetid://77726347193438",
    offset = Vector2.zero,
    size = Vector2.new(971, 124)
}
local t4 = {
    equip = {
        image = "rbxassetid://110298054021846",
        text = "EQUIP",
        edge = Color3.fromRGB(12, 45, 10)
    },
    equipped = {
        image = "rbxassetid://126280039051194",
        text = "EQUIPPED",
        edge = Color3.fromRGB(60, 40, 0)
    },
    locked = {
        image = "rbxassetid://126635458206164",
        text = "LOCKED",
        edge = Color3.fromRGB(60, 0, 8)
    }
}
local AchEquip = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AchEquip")
local t5 = {
    Deadeye = "FLAWLESS CATCHES (3+ BEATS)",
    Thief = "FISH STOLEN FROM PLAYERS",
    Caretaker = "FISH GROWN TO PRIMORDIAL",
    Completionist = "ZONES WITH A FULL INDEX",
    Glutton = "TIME SPENT EATING",
    Extinctionist = "FISH CAUGHT",
    HighRoller = "ROBUX SPENT",
    [AchievementConfig.TRUE.key] = "MAX ALL BUT HIGH ROLLER"
}

local function commas(p1) -- line: 90
    local v3 = tostring((math.floor(p1)))

    repeat
        local v4

        v3, v4 = v3:gsub("^(%d+)(%d%d%d)", "%1,%2")
    until v4 == 0

    return v3
end

local t6 = {
    Glutton = function(p2) -- clock | line: 96
        local v5 = math.floor(p2)
        local v6 = v5 // 3600
        local v7 = v5 % 3600 // 60

        if v6 > 0 then
            return v7 > 0 and v6 .. "h " .. v7 .. "m" or v6 .. "h"
        end

        if v7 > 0 then
            return v7 .. "m"
        end

        return v5 .. "s"
    end,
    HighRoller = function(p3) -- HighRoller | line: 105
        -- upvalues: v1 (copy), commas (copy)
        return v1 .. commas(p3)
    end
}

local function fmt(p4, p5) -- line: 107
    -- upvalues: commas (copy), t6 (copy)
    return (t6[p4] or commas)(p5)
end

local function numeral(p6) -- line: 108
    -- upvalues: AchievementConfig (copy)
    return AchievementConfig.NUMERALS[p6] or tostring(p6)
end

local function twoLines(p7) -- line: 110
    local v8 = #p7 / 2
    local v10

    for i = 1, #p7 do
        local v11 = v10

        if p7:sub(i, i) == " " and (not v10 or math.abs(i - v8) < math.abs(v10 - v8)) then
            v11 = i
        end

        v10 = v11
    end

    return v10 and p7:sub(1, v10 - 1) .. "\n" .. p7:sub(v10 + 1) or p7
end

local t7 = {}
local t8 = {}
local v16 = table.clone(AchievementConfig.ORDER)

table.insert(v16, AchievementConfig.TRUE.key)

local nextStar, Changed

for v17, v18 in ipairs(v16) do
    local v19 = v18 == AchievementConfig.TRUE.key
    local TRUE = v19 and AchievementConfig.TRUE or AchievementConfig.TRACKS[v18]
    local clone = Template:Clone()

    clone.Name = v18
    clone.LayoutOrder = v17

    local Card = clone:WaitForChild("Card")
    local Bar = Card:WaitForChild("Bar")
    local t9 = {
        target = 0,
        key = v18,
        isTrue = v19,
        name = string.upper(TRUE.name),
        frame = clone,
        card = Card,
        pop = Card:WaitForChild("Pop"),
        title = Card:WaitForChild("Title"),
        sub = Card:WaitForChild("Sub"),
        hint = Card:WaitForChild("Hint"),
        bar = Bar,
        fill = Bar:WaitForChild("Fill"),
        count = Bar:WaitForChild("Count"),
        levelStar = Bar:WaitForChild("LevelStar"),
        nextStar = Bar:WaitForChild("NextStar"),
        button = Card:WaitForChild("Button"),
        amount = Instance.new("NumberValue")
    }

    t9.levelNum = t9.levelStar:WaitForChild("Level")
    t9.nextNum = t9.nextStar:WaitForChild("Level")
    t9.nextBonus = t9.nextStar:WaitForChild("Bonus")
    t9.buttonLabel = t9.button:WaitForChild("Label")
    t9.hint.Text = Loc.T(t5[v18] or "")
    t9.gradients = Look.Dress(Card, TRUE, v19)

    local hint

    if v19 then
        hint = t9.levelStar
        nextStar = t9.nextStar
        hint.Visible = false
        nextStar.Visible = false
    end

    hint = t3.offset

    local size = t3.size

    t9.fill.Image = t3.image
    t9.fill.ImageRectOffset = hint
    Changed = t9.amount.Changed
    Changed:Connect(function(p8) -- line: 150
        -- upvalues: t9 (copy), size (copy)
        local v20 = math.clamp(p8, 0, 1)

        t9.fill.Visible = v20 > 0.001
        t9.fill.Size = UDim2.fromScale(v20, 1)
        t9.fill.ImageRectSize = Vector2.new(size.X * v20, size.Y)
    end)
    clone.Visible = true
    clone.Parent = List
    t7[v17] = t9
    t8[v18] = t9
end

local function fitCanvas() -- line: 163
    -- upvalues: List (copy), UIListLayout (copy)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)

local function atRest() -- line: 170
    -- upvalues: Scale (copy), t7 (copy)
    if Scale.Scale ~= 1 then
        return false
    end

    for _, v21 in ipairs(t7) do
        if v21.pop.Scale ~= 1 then
            return false
        end
    end

    return true
end

local function width(p9, p10) -- line: 177
    -- upvalues: TextService (copy)
    return TextService:GetTextSize(p9, p10, Enum.Font.FredokaOne, Vector2.new(1E+05, 1E+05)).X
end

local function shareSize(p11) -- line: 180
    -- upvalues: TextService (copy), t7 (copy)
    local AbsoluteSize = t7[1][p11].AbsoluteSize

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end

    local v22 = AbsoluteSize.X * 0.96
    local v23 = math.floor(AbsoluteSize.Y)

    for _, v24 in ipairs(t7) do
        local X = TextService:GetTextSize(v24[p11].Text, v23, Enum.Font.FredokaOne, Vector2.new(1E+05, 1E+05)).X

        if v22 < X then
            v23 = math.floor(v23 * v22 / X)
        end
    end

    for _, v26 in ipairs(t7) do
        v26[p11].TextScaled = false
        v26[p11].TextWrapped = false
        v26[p11].TextSize = math.max(v23, 1)
    end
end

local function shareSizeWrapped(p12) -- line: 198
    -- upvalues: TextService (copy), t7 (copy)
    local AbsoluteSize = t7[1][p12].AbsoluteSize

    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
        local v27 = Vector2.new(AbsoluteSize.X * 0.96, 1E+05)
        local v28 = math.floor(AbsoluteSize.Y)

        while v28 > 1 do
            local v29 = true

            for _, v30 in ipairs(t7) do
                local Text = v30[p12].Text

                if Text ~= "" then
                    local TextSize = TextService:GetTextSize(Text, v28, Enum.Font.FredokaOne, v27)

                    if TextSize.Y > AbsoluteSize.Y * 0.96 or TextSize.X > v27.X then
                        v29 = false
                        break
                    end
                end
            end

            if v29 then
                break
            end

            v28 -= 1
        end

        for _, v31 in ipairs(t7) do
            v31[p12].TextScaled = false
            v31[p12].TextWrapped = true
            v31[p12].TextSize = v28
        end
    end
end

local function fitText() -- line: 221
    -- upvalues: AchievementConfig (copy), Scale (copy), t7 (copy), t8 (copy), shareSize (copy), shareSizeWrapped (copy)
    local v32

    if Scale.Scale == 1 then
        local v33 = false

        for _, v34 in ipairs(t7) do
            if v34.pop.Scale ~= 1 then
                v32 = false
                v33 = true
                break
            end
        end

        if not v33 then
            v32 = true
        end
    else
        v32 = false
    end

    if not v32 then
        return
    end

    for _, v35 in ipairs({ "title", "hint", "count", "nextBonus" }) do
        shareSize(v35)
    end

    shareSizeWrapped("sub")

    for _, v36 in ipairs(t7) do
        v36.nextBonus.TextSize = math.min(v36.nextBonus.TextSize, v36.sub.TextSize)
    end

    local v37 = t8[AchievementConfig.TRUE.key].card:FindFirstChild("Rewards") and t8[AchievementConfig.TRUE.key].card.Rewards:FindFirstChild("Word")

    if not v37 then
        return
    end

    v37.TextScaled = false
    v37.TextWrapped = false
    v37.TextSize = math.min(t7[1].sub.TextSize, (math.floor(v37.AbsoluteSize.Y)))
end

local v39 = false

local function fitSoon() -- line: 237
    -- upvalues: fitText (copy), v39 (ref)
    if not v39 then
        v39 = true
        task.defer(function() -- line: 240
            -- upvalues: fitText (copy), v39 (ref)
            v39 = false
            fitText()
        end)
    end
end

t7[1].hint:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitSoon)

local function setButton(p13, p14) -- line: 249
    -- upvalues: Loc (copy), LocalPlayer (copy), t4 (copy)
    if p14 then
        if LocalPlayer:GetAttribute("AchTitle") == p13.key then
            p13.state = "equipped"
        else
            p13.state = "equip"
        end
    else
        p13.state = "locked"
    end

    local v40 = t4[p13.state]

    p13.button.Image = v40.image
    p13.buttonLabel.Text = Loc.T(v40.text)
    p13.buttonLabel:FindFirstChildOfClass("UIStroke").Color = v40.edge
end

local function read(p15) -- line: 257
    -- upvalues: Loc (copy), AchievementConfig (copy), LocalPlayer (copy), commas (copy), t6 (copy), twoLines (copy), setButton (copy)
    if p15.isTrue then
        local n1 = 0

        for _, v41 in ipairs(AchievementConfig.TRUE.needs) do
            if (LocalPlayer:GetAttribute("Ach_" .. v41) or 0) >= AchievementConfig.MaxTier(v41) then
                n1 += 1
            end
        end

        local v42 = LocalPlayer:GetAttribute("Ach_" .. AchievementConfig.TRUE.key) == true

        p15.title.Text = p15.name
        p15.sub.Text = ""
        p15.count.Text = v42 and Loc.T("UNLOCKED") or n1 .. "/" .. #AchievementConfig.TRUE.needs
        setButton(p15, v42)

        if v42 then
            return 1
        end

        return n1 / #AchievementConfig.TRUE.needs
    end

    local v43 = LocalPlayer:GetAttribute("Ach_" .. p15.key) or 0
    local v44 = LocalPlayer:GetAttribute("AchN_" .. p15.key) or 0
    local v45 = AchievementConfig.Tiers(p15.key)
    local title = p15.title
    local v46, v47

    if v43 > 0 then
        local v48 = p15.name .. " " .. (AchievementConfig.NUMERALS[v43] or tostring(v43))

        if v48 then
            v46 = v48
            v47 = true
        else
            v47 = false
        end
    else
        v47 = false
    end

    title.Text = if not v47 then p15.name else v46
    p15.sub.Text = twoLines(AchievementConfig.BonusText(p15.key, v43))

    local levelNum = p15.levelNum
    local v49, v50

    if v43 > 0 then
        local v51 = AchievementConfig.NUMERALS[v43]

        if v51 then
            v49 = v51
            v50 = true
        else
            v51 = tostring(v43)

            if v51 then
                v49 = v51
                v50 = true
            else
                v50 = false
            end
        end
    else
        v50 = false
    end

    levelNum.Text = if not v50 then "0" else v49
    setButton(p15, v43 > 0)

    if #v45 <= v43 then
        p15.nextStar.Visible = false
        p15.count.Text = Loc.T("MAX")

        return 1
    end

    p15.nextStar.Visible = true

    local nextNum = p15.nextNum
    local v52 = v43 + 1

    nextNum.Text = AchievementConfig.NUMERALS[v52] or tostring(v52)
    p15.nextBonus.Text = AchievementConfig.BonusShort(p15.key, v43 + 1)

    local v53 = v45[v43 + 1]

    p15.count.Text = (t6[p15.key] or commas)(v44) .. "/" .. (t6[p15.key] or commas)(v53)

    return (math.clamp(v44 / v53, 0, 1))
end

local v56 = false

local function refresh(p16, p17) -- line: 291
    -- upvalues: TweenService (copy), t2 (copy), read (copy)
    p16.target = read(p16)

    if p17 then
        TweenService:Create(p16.amount, t2.BAR_CHANGE, {
            Value = p16.target
        }):Play()
    end
end

for _, v57 in ipairs(t7) do
    v57.target = read(v57)
    v57.amount.Value = v57.target
end

local function watch(p18, p19) -- line: 299
    -- upvalues: LocalPlayer (copy), fitText (copy), v39 (ref), v56 (ref), refresh (copy)
    LocalPlayer:GetAttributeChangedSignal(p18):Connect(function() -- line: 300
        -- upvalues: p19 (copy), fitText (copy), v39 (ref), v56 (ref), refresh (copy)
        refresh(p19, v56)

        if not v56 then
            p19.amount.Value = p19.target
        end

        if not v56 or v39 then
            return
        end

        v39 = true
        task.defer(function() -- line: 240
            -- upvalues: fitText (copy), v39 (ref)
            v39 = false
            fitText()
        end)
    end)
end

for _, v58 in ipairs(t7) do
    if v58.isTrue then
        Changed = LocalPlayer:GetAttributeChangedSignal("Ach_" .. AchievementConfig.TRUE.key)
        Changed:Connect(function() -- line: 300
            -- upvalues: fitText (copy), v39 (ref), v56 (ref), refresh (copy), v58 (copy)
            refresh(v58, v56)

            if not v56 then
                v58.amount.Value = v58.target
            end

            if not v56 or v39 then
                return
            end

            v39 = true
            task.defer(function() -- line: 240
                -- upvalues: fitText (copy), v39 (ref)
                v39 = false
                fitText()
            end)
        end)

        for _, v59 in ipairs(AchievementConfig.TRUE.needs) do
            LocalPlayer:GetAttributeChangedSignal("Ach_" .. v59):Connect(function() -- line: 300
                -- upvalues: fitText (copy), v39 (ref), v56 (ref), refresh (copy), v58 (copy)
                refresh(v58, v56)

                if not v56 then
                    v58.amount.Value = v58.target
                end

                if not v56 or v39 then
                    return
                end

                v39 = true
                task.defer(function() -- line: 240
                    -- upvalues: fitText (copy), v39 (ref)
                    v39 = false
                    fitText()
                end)
            end)
        end
    else
        Changed = LocalPlayer:GetAttributeChangedSignal("Ach_" .. v58.key)
        Changed:Connect(function() -- line: 300
            -- upvalues: fitText (copy), v39 (ref), v56 (ref), refresh (copy), v58 (copy)
            refresh(v58, v56)

            if not v56 then
                v58.amount.Value = v58.target
            end

            if not v56 or v39 then
                return
            end

            v39 = true
            task.defer(function() -- line: 240
                -- upvalues: fitText (copy), v39 (ref)
                v39 = false
                fitText()
            end)
        end)
        LocalPlayer:GetAttributeChangedSignal("AchN_" .. v58.key):Connect(function() -- line: 300
            -- upvalues: fitText (copy), v39 (ref), v56 (ref), refresh (copy), v58 (copy)
            refresh(v58, v56)

            if not v56 then
                v58.amount.Value = v58.target
            end

            if not v56 or v39 then
                return
            end

            v39 = true
            task.defer(function() -- line: 240
                -- upvalues: fitText (copy), v39 (ref)
                v39 = false
                fitText()
            end)
        end)
    end

    nextStar = LocalPlayer:GetAttributeChangedSignal("AchTitle")
    nextStar:Connect(function() -- line: 300
        -- upvalues: fitText (copy), v39 (ref), v56 (ref), refresh (copy), v58 (copy)
        refresh(v58, v56)

        if not v56 then
            v58.amount.Value = v58.target
        end

        if not v56 or v39 then
            return
        end

        v39 = true
        task.defer(function() -- line: 240
            -- upvalues: fitText (copy), v39 (ref)
            v39 = false
            fitText()
        end)
    end)
end

for _, v60 in ipairs(t7) do
    ButtonHover.Attach(v60.button, {
        shine = false,
        tile = 1
    })
    nextStar = v60.button.Activated
    nextStar:Connect(function() -- line: 319
        -- upvalues: ButtonHover (copy), AchEquip (copy), v60 (copy)
        if v60.state == "locked" then
            return
        end

        ButtonHover.Press(v60.button)
        AchEquip:FireServer(v60.key)
    end)
end

local AchSeen = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AchSeen")
local t10 = {
    text = "!",
    size = 0.34,
    at = Vector2.new(0.035, 0.17)
}
local t11 = {
    text = "!",
    size = 0.62,
    at = Vector2.new(0.955, 0.2)
}

local function isNew(p20) -- line: 334
    -- upvalues: AchievementConfig (copy), LocalPlayer (copy)
    if p20 ~= AchievementConfig.TRUE.key then
        return (LocalPlayer:GetAttribute("Ach_" .. p20) or 0) > (LocalPlayer:GetAttribute("AchSeen_" .. p20) or 0)
    end

    if LocalPlayer:GetAttribute("Ach_" .. p20) == true then
        return LocalPlayer:GetAttribute("AchSeen_" .. p20) ~= true
    end

    return false
end

function t1.NewCount() -- line: 340
    -- upvalues: t7 (copy), isNew (copy)
    local n2 = 0

    for _, v61 in ipairs(t7) do
        if isNew(v61.key) then
            n2 += 1
        end
    end

    return n2
end

local t12 = {}
local v62

function t1.OnNew(p21) -- line: 348
    -- upvalues: t12 (copy)
    table.insert(t12, p21)
end

local function topZ(p22) -- line: 349
    local v63 = p22.ZIndex

    for _, descendant in ipairs(p22:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            v63 = math.max(v63, descendant.ZIndex)
        end
    end

    return v63
end

local function markRows() -- line: 356
    -- upvalues: Badge (copy), t7 (copy), t10 (copy), isNew (copy), topZ (copy)
    for _, v64 in ipairs(t7) do
        if isNew(v64.key) then
            v64.newMark = true
        end

        if v64.newMark and not v64.badge then
            local v65 = table.clone(t10)

            v65.zIndex = topZ(v64.card) + 2
            v64.badge = Badge.Attach(v64.card, v65)
        end

        if v64.badge then
            v64.badge.Set(v64.newMark and 1 or 0)
        end
    end
end

local function newChanged() -- line: 367
    -- upvalues: t1 (copy), v56 (ref), AchSeen (copy), t12 (copy), v62 (ref), markRows (copy)
    if v56 then
        markRows()

        if t1.NewCount() > 0 then
            AchSeen:FireServer()
        end
    end

    if v62 then
        v62.Set(t1.NewCount())
    end

    for _, v66 in ipairs(t12) do
        task.spawn(v66)
    end
end

for _, v67 in ipairs(t7) do
    LocalPlayer:GetAttributeChangedSignal("Ach_" .. v67.key):Connect(newChanged)
    LocalPlayer:GetAttributeChangedSignal("AchSeen_" .. v67.key):Connect(newChanged)
end

local n3 = 0
local t13 = {}

function t1.Shown() -- line: 383
    -- upvalues: t1 (copy), TweenService (copy), AchievementConfig (copy), List (copy), t2 (copy), t7 (copy), t8 (copy), fitText (copy), read (copy), v56 (ref), AchSeen (copy), markRows (copy), n3 (ref), t13 (copy)
    v56 = true
    n3 += 1

    local v68 = n3

    List.CanvasPosition = Vector2.zero
    markRows()

    if t1.NewCount() > 0 then
        AchSeen:FireServer()
    end

    for v69, v70 in ipairs(t7) do
        v70.target = read(v70)
        v70.pop.Scale = 0
        v70.amount.Value = 0
        task.delay(t2.ROW_FIRST + (v69 - 1) * t2.ROW_STEP, function() -- line: 394
            -- upvalues: v68 (copy), v70 (copy), TweenService (copy), t2 (copy), n3 (ref)
            if n3 == v68 then
                TweenService:Create(v70.pop, t2.ROW_POP, {
                    Scale = 1
                }):Play()
                task.delay(t2.BAR_DELAY, function() -- line: 397
                    -- upvalues: v68 (copy), v70 (copy), TweenService (copy), t2 (copy), n3 (ref)
                    if n3 == v68 then
                        TweenService:Create(v70.amount, t2.BAR_SWEEP, {
                            Value = v70.target
                        }):Play()
                    end
                end)
            end
        end)
    end

    task.delay(t2.ROW_FIRST + #t7 * t2.ROW_STEP + t2.ROW_POP.Time + 0.05, function() -- line: 404
        -- upvalues: v68 (copy), fitText (copy), n3 (ref)
        if n3 == v68 then
            fitText()
        end
    end)

    for _, v71 in ipairs(t8[AchievementConfig.TRUE.key].gradients or {}) do
        v71.Offset = Vector2.new(-0.3, 0)

        local tween = TweenService:Create(v71, t2.DRIFT, {
            Offset = Vector2.new(0.3, 0)
        })

        tween:Play()
        table.insert(t13, tween)
    end
end

function t1.Hidden() -- line: 415
    -- upvalues: t7 (copy), v56 (ref), n3 (ref), t13 (copy)
    v56 = false
    n3 += 1

    for _, v72 in ipairs(t13) do
        v72:Cancel()
    end

    table.clear(t13)

    for _, v73 in ipairs(t7) do
        v73.pop.Scale = 1
        v73.amount.Value = v73.target
        v73.newMark = false

        if v73.badge then
            v73.badge.Set(0)
        end
    end
end

function t1.Init(p23) -- line: 427
    -- upvalues: t1 (copy), ButtonHover (copy), Badge (copy), Close (copy), t11 (copy), v62 (ref), topZ (copy)
    ButtonHover.Attach(Close, {
        shine = false,
        tile = 1,
        icon = Close:FindFirstChild("X")
    })
    Close.Activated:Connect(function() -- line: 429
        -- upvalues: p23 (copy)
        p23.close()
    end)

    if p23.tab then
        local v74 = table.clone(t11)

        v74.zIndex = topZ(p23.tab) + 2
        v62 = Badge.Attach(p23.tab, v74)
        v62.Set(t1.NewCount())
    end
end

return t1

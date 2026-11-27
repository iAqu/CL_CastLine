-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Format = require(Modules:WaitForChild("Format"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local Loc = require(Modules:WaitForChild("Loc"))
local LeaderboardGet = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LeaderboardGet")
local LocalPlayer = Players.LocalPlayer
local Leaderboards = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("XPGui"):WaitForChild("Leaderboards")
local AspectRatio = Leaderboards:WaitForChild("UIAspectRatioConstraint").AspectRatio
local Main = Leaderboards:WaitForChild("Main")
local Close = Main:WaitForChild("Close")
local ListClip = Main:WaitForChild("ListClip")
local Collapse = ListClip:WaitForChild("Collapse")
local List = ListClip:WaitForChild("List")
local UIListLayout = List:WaitForChild("UIListLayout")
local TopClip = Main:WaitForChild("TopClip")
local Top = TopClip:WaitForChild("Top")
local Back = Main:WaitForChild("Back")
local RanksClip = Main:WaitForChild("RanksClip")
local Collapse2 = RanksClip:WaitForChild("Collapse")
local Ranks = RanksClip:WaitForChild("Ranks")

require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Watch(ListClip)
require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Watch(RanksClip)

local UIListLayout2 = Ranks:WaitForChild("UIListLayout")
local Template = Ranks:WaitForChild("Template")
local Me = Main:WaitForChild("Me")
local Pop = Me:WaitForChild("Pop")
local Label = Me:WaitForChild("Label")
local t2 = {
    "Money",
    "XP",
    "Fish",
    "Time",
    "Fat",
    "Donate"
}
local t3 = {}

for v1, v2 in ipairs(t2) do
    t3[v2] = List:WaitForChild("Board" .. v1)
end

local TopPosition = Top.Position
local BackPosition = Back.Position
local t4 = {
    BOARD_FIRST = 0.1,
    BOARD_STEP = 0.08,
    PIECE_STEP = 0.035,
    ROW_FIRST = 0.18,
    ROW_STEP = 0.03,
    ME_AT = 0.3,
    HIGHLIGHT_FADE = 0.8,
    BAR_FRAC = 0.009448818897637795,
    PIECE_POP = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    MOVE = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FOLD_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    FOLD_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SWAP_OUT = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    SWAP_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    LIST_OUT = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    ROW_POP = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local v3 = Vector2.new(1E+06, 1E+06)
local FredokaOne = Enum.Font.FredokaOne

local function textW(p1) -- line: 101
    -- upvalues: TextService (copy), v3 (copy), FredokaOne (copy)
    return TextService:GetTextSize(p1, 100, FredokaOne, v3).X / 100
end

local v4 = TextService:GetTextSize("a a", 100, FredokaOne, v3).X / 100 - TextService:GetTextSize("aa", 100, FredokaOne, v3).X / 100
local clone = t3.XP:WaitForChild("Rank2"):WaitForChild("Star"):Clone()
local clone2 = t3.Fish:WaitForChild("Rank2"):WaitForChild("Fish"):Clone()
local t5 = {
    "Star",
    "Fish",
    "Amount"
}

local function partOf(p2, p3, p4) -- line: 107
    -- upvalues: clone (copy), clone2 (copy)
    local v5 = p2:FindFirstChild(p4)

    if v5 then
        return v5
    end

    local clone3 = if p4 == "Star" then clone:Clone() elseif p4 == "Fish" then clone2:Clone() else p3:Clone()

    clone3.Name = p4
    clone3.Parent = p2

    return clone3
end

local function layout(p5, p6, p7, p8, p9, p10, p11) -- line: 120
    -- upvalues: TextService (copy), v3 (copy), FredokaOne (copy), v4 (copy), clone (copy), clone2 (copy), t5 (copy)
    p7.AutoLocalize = false
    p7.Text = p10
    p7.TextXAlignment = Enum.TextXAlignment.Left

    local v6 = TextService:GetTextSize(p10, 100, FredokaOne, v3).X / 100 + 0.04

    for _, v7 in ipairs(p11) do
        local v8 = v6 + v4

        v6 = if v7.kind == "star" then v8 + 1.33625 elseif v7.kind == "fish" then v8 + 1.3 else v8 + (TextService:GetTextSize(v7.text, 100, FredokaOne, v3).X / 100 + 0.04)
    end

    local v10 = math.min(p9, ((1 - p8) * p6 - 0.05) / v6)
    local v11 = p8 * p6
    local v12 = (TextService:GetTextSize(p10, 100, FredokaOne, v3).X / 100 + 0.04) * v10

    p7.AnchorPoint = Vector2.new(0, 0.5)
    p7.Position = UDim2.fromScale(v11 / p6, 0.5)
    p7.Size = UDim2.fromScale(v12 / p6, v10)
    v11 += v12

    local t6 = {}

    for _, v13 in ipairs(p11) do
        v11 += v4 * v10

        if v13.kind == "star" then
            local Star = p5:FindFirstChild("Star")

            if not Star then
                Star = clone:Clone()
                Star.Name = "Star"
                Star.Parent = p5
            end

            Star.Level.Text = tostring(v13.level)

            local v14 = v10 * 1.33625
            local v15 = v10 * 1.25

            Star.AnchorPoint = Vector2.new(0, 0.5)
            Star.Position = UDim2.fromScale(v11 / p6, 0.5)
            Star.Size = UDim2.fromScale(v14 / p6, v15)
            v11 += v14
        elseif v13.kind == "fish" then
            local Fish = p5:FindFirstChild("Fish")

            if not Fish then
                Fish = clone2:Clone()
                Fish.Name = "Fish"
                Fish.Parent = p5
            end

            Fish.Image = v13.image or ""

            local v16 = v10 * 1.3
            local v17 = v10 * 1.3

            Fish.AnchorPoint = Vector2.new(0, 0.5)
            Fish.Position = UDim2.fromScale(v11 / p6, 0.5)
            Fish.Size = UDim2.fromScale(v16 / p6, v17)
            v11 += v16
        else
            local Amount = p5:FindFirstChild("Amount")

            if not Amount then
                Amount = p7:Clone()
                Amount.Name = "Amount"
                Amount.Parent = p5
            end

            Amount.AutoLocalize = false
            Amount.Text = v13.text
            Amount.TextXAlignment = Enum.TextXAlignment.Left
            Amount.UIGradient.Color = p7.UIGradient.Color

            local v18 = (TextService:GetTextSize(v13.text, 100, FredokaOne, v3).X / 100 + 0.04) * v10

            Amount.AnchorPoint = Vector2.new(0, 0.5)
            Amount.Position = UDim2.fromScale(v11 / p6, 0.5)
            Amount.Size = UDim2.fromScale(v18 / p6, v10)
            v11 += v18
        end

        t6[if v13.kind == "star" then "Star" elseif v13.kind == "fish" then "Fish" else "Amount"] = true
    end

    for _, v19 in ipairs(t5) do
        local v20 = p5:FindFirstChild(v19)

        if v20 then
            v20.Visible = t6[v19] == true
        end
    end
end

local function amountText(p12, p13) -- line: 168
    -- upvalues: Format (copy)
    if p12 == "Money" then
        return "(" .. Format.money(p13) .. "/s)"
    end

    if p12 == "Time" then
        return "(" .. Format.time(p13) .. ")"
    end

    if p12 == "Fish" then
        return "(" .. Format.kg(p13) .. ")"
    end

    if p12 == "Fat" then
        return "(" .. Format.short(p13) .. ")"
    end

    if p12 ~= "Donate" then
        return nil
    end

    local v23 = tostring((math.floor(p13 or 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    return "(" .. utf8.char(57346) .. " " .. v23:gsub("^,", "") .. ")"
end

local function partsOf(p14, p15, p16) -- line: 180
    -- upvalues: FishDisplay (copy), amountText (copy)
    if p14 == "XP" then
        return {
            {
                kind = "star",
                level = p15
            }
        }
    end

    if p14 == "Fish" then
        local v24 = p16 and FishDisplay[p16]
        local t7 = {}

        if v24 and v24.icon then
            t7[1] = {
                kind = "fish",
                image = v24.icon
            }
        end

        t7[#t7 + 1] = {
            kind = "text",
            text = amountText(p14, p15)
        }

        return t7
    end

    if p14 == "Fat" then
        return {
            {
                kind = "fish",
                image = "rbxassetid://135825676122341"
            },
            {
                kind = "text",
                text = amountText(p14, p15)
            }
        }
    end

    return {
        {
            kind = "text",
            text = amountText(p14, p15)
        }
    }
end

local function headOf(p17) -- line: 193
    return "rbxthumb://type=AvatarHeadShot&id=" .. (if not (p17 > 0) or not p17 then 1 else p17) .. "&w=420&h=420"
end

local t8 = {
    version = nil,
    lists = {},
    me = {}
}
local t9 = {}
local v25 = false

local function fetch() -- line: 201
    -- upvalues: LeaderboardGet (copy), t8 (copy), t9 (copy), v25 (ref)
    if not v25 then
        v25 = true
        task.spawn(function() -- line: 204
            -- upvalues: LeaderboardGet (copy), t8 (copy), t9 (copy), v25 (ref)
            local InvokeServer = LeaderboardGet.InvokeServer
            local version = t8.version
            local ok, result = pcall(InvokeServer, LeaderboardGet, version)

            v25 = false

            if not ok or type(result) ~= "table" then
                return
            end

            if type(result.lists) == "table" then
                t8.lists = result.lists
            end

            t8.version = result.version

            if type(result.me) == "table" then
                t8.me = result.me
            end

            for _, v26 in ipairs(t9) do
                v26()
            end
        end)
    end
end

local t10 = {}

for v27, v28 in pairs(t3) do
    t10[v27] = v28:WaitForChild("First"):WaitForChild("Label").Position.X.Scale
end

local function holderAspect(p18, p19) -- line: 218
    return p19.Size.X.Scale / p19.Size.Y.Scale * p18.UIAspectRatioConstraint.AspectRatio
end

local function fillBoard(p20) -- line: 221
    -- upvalues: t3 (copy), layout (copy), amountText (copy), partsOf (copy), t8 (copy), t10 (copy)
    local v29 = t3[p20]
    local v30 = t8.lists[p20] or {}
    local v31 = v30[1]

    v29.Head.Visible = v31 ~= nil

    if v31 then
        local Head = v29.Head
        local v32 = v31[1]

        Head.Image = "rbxthumb://type=AvatarHeadShot&id=" .. (v32 > 0 and v32 or 1) .. "&w=420&h=420"
    end

    local First = v29.First

    First.Visible = v31 ~= nil

    for i = 2, 5 do
        local v33 = v29["Rank" .. i]
        local v34 = v30[i]

        v33.Visible = v34 ~= nil

        if v34 then
            local Label = v33:IsA("TextLabel") and v33 or v33.Label

            if v33:IsA("TextLabel") then
                v33.Text = i .. ". " .. v34[2] .. " " .. amountText(p20, v34[3])
            else
                layout(v33, v33.Size.X.Scale / v33.Size.Y.Scale * v29.UIAspectRatioConstraint.AspectRatio, Label, 0, 1, i .. ". " .. v34[2], (partsOf(p20, v34[3], v34[4])))
            end
        end
    end

    if not v31 then
        return
    end

    local Label = First.Label

    if p20 == "Money" or p20 == "Time" or p20 == "Donate" then
        Label.Text = v31[2] .. " " .. amountText(p20, v31[3])
    else
        layout(First, First.Size.X.Scale / First.Size.Y.Scale * v29.UIAspectRatioConstraint.AspectRatio, Label, t10[p20], 0.8, v31[2], (partsOf(p20, v31[3], v31[4])))
    end
end

local function fillBoards() -- line: 251
    -- upvalues: t2 (copy), fillBoard (copy)
    for _, v35 in ipairs(t2) do
        fillBoard(v35)
    end
end

local function popBoards() -- line: 255
    -- upvalues: TweenService (copy), t2 (copy), t3 (copy), t4 (copy)
    for v36, v37 in ipairs(t2) do
        local v38 = t3[v37]
        local t11 = {
            v38.Title,
            v38.Head,
            v38.First,
            v38.Rank2,
            v38.Rank3,
            v38.Rank4,
            v38.Rank5
        }

        for v39, v40 in ipairs(t11) do
            local Pop = v40:FindFirstChild("Pop")

            if Pop then
                Pop.Scale = 0
                TweenService:Create(Pop, TweenInfo.new(t4.PIECE_POP.Time, t4.PIECE_POP.EasingStyle, t4.PIECE_POP.EasingDirection, 0, false, t4.BOARD_FIRST + (v36 - 1) * t4.BOARD_STEP + (v39 - 1) * t4.PIECE_STEP), {
                    Scale = 1
                }):Play()
            end
        end

        local HoverScale = v38.View:FindFirstChild("HoverScale")

        if HoverScale then
            HoverScale.Scale = 0
            TweenService:Create(HoverScale, TweenInfo.new(t4.PIECE_POP.Time, t4.PIECE_POP.EasingStyle, t4.PIECE_POP.EasingDirection, 0, false, t4.BOARD_FIRST + (v36 - 1) * t4.BOARD_STEP + #t11 * t4.PIECE_STEP), {
                Scale = 1
            }):Play()
        end
    end
end

local function fitCanvas(p21, p22) -- line: 278
    p21.CanvasSize = UDim2.fromOffset(0, p22.AbsoluteContentSize.Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 279
    -- upvalues: List (copy), UIListLayout (copy)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)
end)
UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 280
    -- upvalues: Ranks (copy), UIListLayout2 (copy)
    Ranks.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y)
end)

local function fitBars() -- line: 281
    -- upvalues: List (copy), Ranks (copy), t4 (copy)
    List.ScrollBarThickness = math.max(2, (math.round(t4.BAR_FRAC * List.AbsoluteSize.Y)))
    Ranks.ScrollBarThickness = List.ScrollBarThickness
end

List:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBars)
List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)
List.ScrollBarThickness = math.max(2, (math.round(t4.BAR_FRAC * List.AbsoluteSize.Y)))
Ranks.ScrollBarThickness = List.ScrollBarThickness

local AspectRatio2 = Template:WaitForChild("UIAspectRatioConstraint").AspectRatio
local Color = Template.Body.Label.UIGradient.Color
local Color2 = t3.Money.First.Label.UIGradient.Color
local Scale = Template.Body.Label.Position.X.Scale
local v45 = Template.Body.Icon.Size.Y.Scale * Template.Body.Icon.UIAspectRatioConstraint.AspectRatio / AspectRatio2
local t12 = {}

local function rowAt(p23) -- line: 296
    -- upvalues: Ranks (copy), Template (copy), t12 (copy)
    local v46 = t12[p23]

    if not v46 then
        v46 = Template:Clone()
        v46.Name = "Row" .. p23
        v46.LayoutOrder = p23
        v46.Parent = Ranks
        t12[p23] = v46
    end

    return v46
end

local function fillRanks(p24) -- line: 307
    -- upvalues: Ranks (copy), Template (copy), layout (copy), partsOf (copy), t8 (copy), AspectRatio2 (copy), Color (copy), Color2 (copy), Scale (copy), v45 (copy), t12 (copy)
    local v47 = t8.lists[p24] or {}

    for v48, v49 in ipairs(v47) do
        local v50 = t12[v48]

        if not v50 then
            v50 = Template:Clone()
            v50.Name = "Row" .. v48
            v50.LayoutOrder = v48
            v50.Parent = Ranks
            t12[v48] = v50
        end

        v50.Visible = true

        local Body = v50.Body

        Body.Icon.Visible = v48 == 1
        Body.Label.UIGradient.Color = v48 == 1 and Color2 or Color

        local v51 = v48 == 1 and Scale + v45 + 0.01 or Scale
        local v52 = v48 == 1 and v49[2] or v48 .. ". " .. v49[2]

        layout(Body, AspectRatio2, Body.Label, v51, 0.7, v52, (partsOf(p24, v49[3], v49[4])))
    end

    for i = #v47 + 1, #t12 do
        t12[i].Visible = false
    end
end

local v53 = Me.Size.X.Scale / Me.Size.Y.Scale * AspectRatio

local function commas(p25) -- line: 323
    return (tostring((math.floor(p25))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function fillMe(p26) -- line: 327
    -- upvalues: Loc (copy), LocalPlayer (copy), Me (copy), Label (copy), layout (copy), partsOf (copy), t8 (copy), Scale (copy), v53 (copy)
    local v55 = t8.me[p26]

    Me.Visible = v55 ~= nil

    if not v55 then
        return
    end

    local v56 = v55[1]
    local v57 = v55[2]
    local v58 = v55[3]
    local v59 = if v56 then tostring((math.floor(v56))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. ". " or "250+ " else "250+ "
    local v61 = partsOf(p26, v57, v58)
    local v62 = if (p26 == "Fish" or p26 == "Donate" or p26 == "Fat") and (v57 or 0) <= 0 then {
        {
            kind = "text",
            text = Loc.T("(none yet)")
        }
    } else v61

    layout(Me, v53, Label, Scale, 0.62, v59 .. LocalPlayer.Name, v62)
end

local function popRows() -- line: 337
    -- upvalues: TweenService (copy), Ranks (copy), t4 (copy), AspectRatio2 (copy), t12 (copy)
    Ranks.CanvasPosition = Vector2.zero

    local AbsoluteWindowSize = Ranks.AbsoluteWindowSize
    local v63 = if AbsoluteWindowSize.X > 0 then math.ceil(AbsoluteWindowSize.Y / (AbsoluteWindowSize.X / AspectRatio2)) + 1 else 10

    for v65, v66 in ipairs(t12) do
        local Pop = v66.Body.Pop

        if v66.Visible and v65 <= v63 then
            Pop.Scale = 0
            TweenService:Create(Pop, TweenInfo.new(t4.ROW_POP.Time, t4.ROW_POP.EasingStyle, t4.ROW_POP.EasingDirection, 0, false, t4.ROW_FIRST + (v65 - 1) * t4.ROW_STEP), {
                Scale = 1
            }):Play()
        else
            Pop.Scale = 1
        end
    end
end

local v67 = false
local n1 = 0
local v68 = nil
local v69 = false
local v70, v71, v72, clone3
local v73 = nil

Collapse:GetPropertyChangedSignal("Scale"):Connect(function() -- line: 360
    -- upvalues: Collapse (copy), List (copy), v73 (ref)
    if v73 then
        List.CanvasPosition = v73 * Collapse.Scale
    end
end)

local HoverScale

local function spotIn(p27, p28) -- line: 364
    -- upvalues: Main (copy)
    p28 = p28 or Main

    local v76 = p27.AbsolutePosition + p27.AbsoluteSize / 2 - p28.AbsolutePosition

    return UDim2.fromScale(v76.X / p28.AbsoluteSize.X, v76.Y / p28.AbsoluteSize.Y)
end

local function expandIn(p29) -- line: 370
    -- upvalues: TweenService (copy), PanelFocus (copy), Main (copy), ListClip (copy), Collapse (copy), List (copy), TopClip (copy), Top (copy), Back (copy), RanksClip (copy), Collapse2 (copy), Pop (copy), t3 (copy), TopPosition (copy), BackPosition (copy), t4 (copy), fillRanks (copy), fillMe (copy), popRows (copy), v67 (ref), n1 (ref), v68 (ref), v69 (ref), v70 (ref), v71 (ref), v72 (ref), v73 (ref), HoverScale (ref)
    local v77, Title, v78, v79

    if v69 or v68 then
        v79 = true
    elseif not v67 or os.clock() - n1 < PanelFocus.FEEL.OPEN_TIME then
        v79 = true
    else
        v69 = true
        v68 = p29
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
        v77 = t3[p29]
        Title = v77.Title
        v78 = TopClip or Main
        v79 = false
    end

    if v79 then
        return
    end

    local v80 = Title.AbsolutePosition + Title.AbsoluteSize / 2 - v78.AbsolutePosition

    v70 = UDim2.fromScale(v80.X / v78.AbsoluteSize.X, v80.Y / v78.AbsoluteSize.Y)
    Top.Label.Text = v77.Title.Label.Text
    Top.Size = UDim2.fromScale(v77.Title.AbsoluteSize.X / TopClip.AbsoluteSize.X, 1)
    Top.Position = v70
    TopClip.Visible = true
    v77.Title.Visible = false
    TweenService:Create(Top, t4.MOVE, {
        Position = TopPosition
    }):Play()

    local View = v77.View
    local v81 = View.AbsolutePosition + View.AbsoluteSize / 2 - Main.AbsolutePosition

    v71 = UDim2.fromScale(v81.X / Main.AbsoluteSize.X, v81.Y / Main.AbsoluteSize.Y)
    v72 = v77.View.AbsoluteSize.X / Main.AbsoluteSize.X
    Back.Position = v71
    HoverScale.Scale = 0
    Back.Visible = true
    TweenService:Create(HoverScale, t4.SWAP_IN, {
        Scale = 1
    }):Play()
    TweenService:Create(Back, t4.MOVE, {
        Position = BackPosition
    }):Play()
    v73 = List.CanvasPosition / math.max(Collapse.Scale, 0.001)

    local tween = TweenService:Create(Collapse, t4.FOLD_OUT, {
        Scale = 0
    })

    tween.Completed:Once(function(p30) -- line: 395
        -- upvalues: p29 (copy), ListClip (copy), v68 (ref)
        if p30 == Enum.PlaybackState.Completed and v68 == p29 then
            ListClip.Visible = false
        end
    end)
    tween:Play()
    fillRanks(p29)
    Collapse2.Scale = 1
    RanksClip.Visible = true
    popRows()
    fillMe(p29)
    Pop.Scale = 0
    TweenService:Create(Pop, TweenInfo.new(t4.SWAP_IN.Time, t4.SWAP_IN.EasingStyle, t4.SWAP_IN.EasingDirection, 0, false, t4.ME_AT), {
        Scale = 1
    }):Play()
    task.delay(t4.MOVE.Time, function() -- line: 408
        -- upvalues: p29 (copy), v68 (ref), v69 (ref)
        if v68 == p29 then
            v69 = false
        end
    end)
end

local function expandOut() -- line: 411
    -- upvalues: TweenService (copy), PanelFocus (copy), Main (copy), ListClip (copy), Collapse (copy), List (copy), TopClip (copy), Top (copy), Back (copy), RanksClip (copy), Collapse2 (copy), Me (copy), Pop (copy), t3 (copy), BackPosition (copy), t4 (copy), v68 (ref), v69 (ref), v70 (ref), v71 (ref), v72 (ref), clone3 (ref), v73 (ref), HoverScale (ref)
    local v82, v83

    if v69 then
        v83 = true
    elseif v68 then
        v82 = t3[v68]
        v69 = true
        v68 = nil
        PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)

        local tween = TweenService:Create(Collapse2, t4.LIST_OUT, {
            Scale = 0
        })

        tween.Completed:Once(function(p31) -- line: 419
            -- upvalues: RanksClip (copy), v68 (ref)
            if p31 == Enum.PlaybackState.Completed and not v68 then
                RanksClip.Visible = false
            end
        end)
        tween:Play()

        local tween2 = TweenService:Create(Pop, t4.LIST_OUT, {
            Scale = 0
        })

        tween2.Completed:Once(function(p32) -- line: 422
            -- upvalues: Me (copy), v68 (ref)
            if p32 == Enum.PlaybackState.Completed and not v68 then
                Me.Visible = false
            end
        end)
        tween2:Play()
        ListClip.Visible = true
        Collapse.Scale = 0

        local tween3 = TweenService:Create(Collapse, t4.FOLD_IN, {
            Scale = 1
        })

        tween3.Completed:Once(function() -- line: 428
            -- upvalues: List (copy), v68 (ref), v73 (ref)
            if v73 then
                List.CanvasPosition = v73
            end

            if not v68 then
                v73 = nil
            end
        end)
        tween3:Play()
        TweenService:Create(Top, t4.MOVE, {
            Position = v70
        }):Play()
        TweenService:Create(HoverScale, t4.SWAP_OUT, {
            Scale = 0
        }):Play()
        task.delay(t4.SWAP_OUT.Time, function() -- line: 437
            -- upvalues: Back (copy), v68 (ref)
            if not v68 then
                Back.Visible = false
            end
        end)

        if clone3 then
            clone3:Destroy()
        end

        v83 = false
    else
        v83 = true
    end

    if v83 then
        return
    end

    clone3 = v82.View:Clone()
    clone3.Name = "ViewFly"
    clone3.AnchorPoint = Vector2.new(0.5, 0.5)
    clone3.Size = UDim2.fromScale(v72, 1)
    clone3.Position = BackPosition
    clone3.ZIndex = 6

    local HoverScale2 = clone3:FindFirstChild("HoverScale")

    if HoverScale2 then
        HoverScale2.Scale = 0
        TweenService:Create(HoverScale2, t4.SWAP_IN, {
            Scale = 1
        }):Play()
    end

    clone3.Parent = Main
    v82.View.Visible = false
    TweenService:Create(clone3, t4.MOVE, {
        Position = v71
    }):Play()
    task.delay(t4.MOVE.Time, function() -- line: 450
        -- upvalues: v82 (ref), TopClip (copy), v68 (ref), v69 (ref), clone3 (ref)
        if clone3 then
            clone3:Destroy()
            clone3 = nil
        end

        v82.View.Visible = true
        v82.Title.Visible = true

        if not v68 then
            TopClip.Visible = false
        end

        v69 = false
    end)
end

local function expandReset() -- line: 460
    -- upvalues: ListClip (copy), Collapse (copy), TopClip (copy), Back (copy), RanksClip (copy), Collapse2 (copy), Me (copy), Pop (copy), t3 (copy), v68 (ref), v69 (ref), clone3 (ref), v73 (ref), HoverScale (ref)
    v68 = nil
    v69 = false

    if clone3 then
        clone3:Destroy()
        clone3 = nil
    end

    v73 = nil
    ListClip.Visible = true
    Collapse.Scale = 1
    RanksClip.Visible = false
    Collapse2.Scale = 1
    Me.Visible = false
    Pop.Scale = 1
    TopClip.Visible = false
    Back.Visible = false

    if HoverScale then
        HoverScale.Scale = 1
    end

    for _, v85 in pairs(t3) do
        v85.Title.Visible = true
        v85.View.Visible = true
    end
end

ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
ButtonHover.Attach(Back, {
    shine = false,
    tile = 1
})
HoverScale = Back:WaitForChild("HoverScale")
Back.Activated:Connect(expandOut)

for _, v86 in ipairs(t2) do
    local View = t3[v86].View

    ButtonHover.Attach(View, {
        shine = false,
        tile = 1,
        highlight = true,
        icon = View:FindFirstChild("Icon"),
        highlightFade = t4.HIGHLIGHT_FADE,
        highlightCorner = View:GetAttribute("Corner") or 0.3,
        corner = View:GetAttribute("Corner") or 0.3
    })
    View.Activated:Connect(function() -- line: 485
        -- upvalues: ButtonHover (copy), expandIn (copy), v86 (copy), View (copy)
        ButtonHover.Press(View)
        expandIn(v86)
    end)
end

table.insert(t9, function() -- line: 492
    -- upvalues: t2 (copy), fillBoard (copy), fillRanks (copy), fillMe (copy), v67 (ref), v68 (ref)
    if not v67 then
        return
    end

    for _, v88 in ipairs(t2) do
        fillBoard(v88)
    end

    if v68 then
        fillRanks(v68)
        fillMe(v68)
    end
end)

function t1.Init(p33) -- line: 501
    -- upvalues: Close (copy)
    Close.Activated:Connect(function() -- line: 502
        -- upvalues: p33 (copy)
        p33.close()
    end)
end

function t1.Shown() -- line: 504
    -- upvalues: LeaderboardGet (copy), List (copy), t2 (copy), t8 (copy), t9 (copy), v25 (ref), fillBoard (copy), popBoards (copy), v67 (ref), n1 (ref), expandReset (copy)
    local elapsed = os.clock()

    v67 = true
    n1 = elapsed
    expandReset()
    List.CanvasPosition = Vector2.zero

    for _, v89 in ipairs(t2) do
        fillBoard(v89)
    end

    if not v25 then
        v25 = true
        task.spawn(function() -- line: 204
            -- upvalues: LeaderboardGet (copy), t8 (copy), t9 (copy), v25 (ref)
            local InvokeServer = LeaderboardGet.InvokeServer
            local version = t8.version
            local ok, result = pcall(InvokeServer, LeaderboardGet, version)

            v25 = false

            if not ok or type(result) ~= "table" then
                return
            end

            if type(result.lists) == "table" then
                t8.lists = result.lists
            end

            t8.version = result.version

            if type(result.me) == "table" then
                t8.me = result.me
            end

            for _, v90 in ipairs(t9) do
                v90()
            end
        end)
    end

    popBoards()
end

function t1.Hidden() -- line: 512
    -- upvalues: v67 (ref), expandReset (copy)
    v67 = false
    expandReset()
end

function t1.Prefetch() -- line: 516
    -- upvalues: LeaderboardGet (copy), t8 (copy), t9 (copy), v25 (ref)
    if not v25 then
        v25 = true
        task.spawn(function() -- line: 204
            -- upvalues: LeaderboardGet (copy), t8 (copy), t9 (copy), v25 (ref)
            local InvokeServer = LeaderboardGet.InvokeServer
            local version = t8.version
            local ok, result = pcall(InvokeServer, LeaderboardGet, version)

            v25 = false

            if not ok or type(result) ~= "table" then
                return
            end

            if type(result.lists) == "table" then
                t8.lists = result.lists
            end

            t8.version = result.version

            if type(result.me) == "table" then
                t8.me = result.me
            end

            for _, v91 in ipairs(t9) do
                v91()
            end
        end)
    end
end

function t1.Busy() -- line: 519
    -- upvalues: v69 (ref)
    return v69
end

expandReset()

for _, v92 in ipairs(t2) do
    fillBoard(v92)
end

return t1

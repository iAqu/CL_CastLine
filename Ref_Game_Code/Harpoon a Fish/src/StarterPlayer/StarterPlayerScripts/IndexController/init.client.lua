-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

game:GetService("SoundService")

local ContentProvider = game:GetService("ContentProvider")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local IndexZones = require(Modules:WaitForChild("IndexZones"))
local Format = require(Modules:WaitForChild("Format"))
local Loc = require(Modules:WaitForChild("Loc"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local IndexState = Remotes:WaitForChild("IndexState")
local IndexRecords = Remotes:WaitForChild("IndexRecords")
local IndexClaim = Remotes:WaitForChild("IndexClaim")
local Badge = require(Modules:WaitForChild("Badge"))
local KeyConfig = require(Modules:WaitForChild("KeyConfig"))
local IndexLadder = require(Modules:WaitForChild("IndexLadder"))
local PotionConfig = require(Modules:WaitForChild("PotionConfig"))
local IndexSpecial = require(Modules:WaitForChild("IndexSpecial"))
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local HarpoonSkins = require(Modules:WaitForChild("HarpoonSkins"))
local ClaimFx = require(script:WaitForChild("ClaimFx"))
local Owners = require(script:WaitForChild("Owners"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IndexGui = PlayerGui:WaitForChild("IndexGui")
local Templates = IndexGui:WaitForChild("Templates")
local Panel = IndexGui:WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local List = Main:WaitForChild("List")
local UIListLayout = List:WaitForChild("UIListLayout")
local UIPadding = List:WaitForChild("UIPadding")
local Tabs = Main:WaitForChild("Tabs")
local ModeTabs = Main:WaitForChild("ModeTabs")
local Islands = Main:WaitForChild("Islands")
local Pop = Islands:WaitForChild("Pop")
local Row = Islands:WaitForChild("Row")
local t1 = {
    "Origins",
    "Jurassic"
}
local t2 = {}

local function islandOf(p1) -- line: 101
    if type(p1) == "number" and p1 >= 8 and p1 <= 10 then
        return "Jurassic"
    end

    return "Origins"
end

local v1 = if require(Modules:WaitForChild("WorldConfig")).IsJurassic() then 8 else 1
local t3 = {}

local function tabButton(p2) -- line: 109
    -- upvalues: IndexSpecial (copy), Tabs (copy)
    return Tabs:FindFirstChild((if IndexSpecial.BY_ID[p2] then "Tab" else "Zone") .. p2)
end

local function ownRewards(p3) -- line: 113
    -- upvalues: IndexSpecial (copy)
    local v3 = IndexSpecial.BY_ID[p3]

    return v3 ~= nil and not v3.ladder
end

local function modeOf(p4) -- line: 117
    -- upvalues: IndexSpecial (copy)
    local v4 = IndexSpecial.BY_ID[p4]

    return v4 and v4.mode or "NORMAL"
end

local function zoneOf(p5) -- line: 122
    -- upvalues: IndexZones (copy), IndexSpecial (copy)
    return IndexZones[p5] or IndexSpecial.TAB_OF[p5]
end

local Close = Main:WaitForChild("Close")
local Side = Panel:WaitForChild("Side")
local Scale2 = Side:WaitForChild("Scale")
local t4 = {
    icon = Side:WaitForChild("Icon"),
    bar = Side:WaitForChild("NameBar"),
    stats = Side:WaitForChild("Stats")
}

t4.name = t4.bar:WaitForChild("Label")
t4.rarityStars = t4.stats:WaitForChild("RarityStars")
t4.caught = t4.stats:WaitForChild("Caught")
t4.biggest = t4.stats:WaitForChild("Biggest")
t4.record = t4.stats:WaitForChild("Record")
t4.recordBy = t4.stats:WaitForChild("RecordBy")
t4.recordHead = t4.stats:WaitForChild("RecordHead")
t4.caughtBy = t4.stats:WaitForChild("CaughtBy")
t4.caughtBy.AutoLocalize = false
t4.how = Side:WaitForChild("HowGot")
t4.how.AutoLocalize = false

local t5 = {
    text = t4.how.TextColor3,
    stroke = t4.how:FindFirstChildOfClass("UIStroke") and t4.how:FindFirstChildOfClass("UIStroke").Color
}
local t6 = {
    text = Color3.fromRGB(255, 140, 40),
    stroke = Color3.fromRGB(80, 30, 0)
}

t4.copies = Side:WaitForChild("Copies")
t4.copies.AutoLocalize = false

local t7 = {}
local Frame = Instance.new("Frame")

Frame.Name = "TitanHow"
Frame.BackgroundTransparency = 1

local AnchorPoint, howPosition, Size, v5 = t4.how.AnchorPoint, t4.how.Position, t4.how.Size, t4.how.ZIndex

Frame.AnchorPoint = AnchorPoint
Frame.Position = howPosition
Frame.Size = Size
Frame.ZIndex = v5
Frame.Visible = false

local Frame2 = Instance.new("Frame")

Frame2.Name = "Buff"
Frame2.BackgroundTransparency = 1
Frame2.Size = UDim2.fromScale(1, 0.5)
Frame2.ZIndex = Frame.ZIndex
howPosition = Instance.new("UIListLayout")
howPosition.FillDirection = Enum.FillDirection.Horizontal
howPosition.HorizontalAlignment = Enum.HorizontalAlignment.Center
howPosition.VerticalAlignment = Enum.VerticalAlignment.Center
howPosition.SortOrder = Enum.SortOrder.LayoutOrder
howPosition.Padding = UDim.new(0.012, 0)
howPosition.Parent = Frame2

local t8 = {}

local function text(p6, p7) -- line: 185
    -- upvalues: t4 (copy), Frame2 (copy), t8 (copy)
    local clone = t4.copies:Clone()

    clone.Name = p6
    clone.Visible = true
    clone.LayoutOrder = p7

    local zero = Vector2.zero
    local v6 = UDim2.new()

    clone.AnchorPoint = zero
    clone.Position = v6
    clone.TextScaled = false
    clone.TextWrapped = false
    clone.AutomaticSize = Enum.AutomaticSize.X
    clone.Size = UDim2.fromScale(0, 1)
    clone.Parent = Frame2
    t8[#t8 + 1] = clone

    return clone
end

local function icon(p8, p9) -- line: 198
    -- upvalues: Frame (copy), Frame2 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = p8
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.LayoutOrder = p9
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = Frame.ZIndex

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel
    ImageLabel.Parent = Frame2

    return ImageLabel
end

local v7 = icon("LowIcon", 1)
local v8 = text("Low", 2)

t7.lowIcon = v7
t7.low = v8
t7.dash = text("Dash", 3)
v7 = icon("HighIcon", 4)
v8 = text("High", 5)
t7.highIcon = v7
t7.high = v8
t7.dash.Text = "-"
Frame2.Parent = Frame
v5 = t4.how:Clone()
v5.Name = "Rise"
v5.Visible = true
v5.TextWrapped = false
v7 = Vector2.new(0.5, 0)
v8 = UDim2.fromScale(0.5, 0.5)

local v9 = UDim2.fromScale(1, 0.5)

v5.AnchorPoint = v7
v5.Position = v8
v5.Size = v9
v5.TextColor3 = RarityDisplay.Titan.color:Lerp(Color3.new(1, 1, 1), 0.45)
v7 = v5:FindFirstChildOfClass("UIStroke")

if v7 then
    v7.Color = Color3.fromRGB(8, 18, 60)
end

v5.Parent = Frame
t7.rise = v5

local function fit() -- line: 227
    -- upvalues: Frame2 (copy), t8 (copy)
    local v12 = math.max(1, (math.floor(Frame2.AbsoluteSize.Y * 0.95)))

    for _, v13 in ipairs(t8) do
        v13.TextSize = v12
    end
end

Frame2:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
v7 = math.max(1, (math.floor(Frame2.AbsoluteSize.Y * 0.95)))

for _, v15 in ipairs(t8) do
    v15.TextSize = v7
end

Frame.Parent = Side
t7.box = Frame

local function showTitan(p10) -- line: 237
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), Loc (copy), IndexSpecial (copy), TitanConfig (copy), PlayerGui (copy), t7 (copy)
    local v16 = TitanConfig.SPECIES[p10]
    local n1 = 1e999
    local n2 = (-1e999)

    for _, v17 in ipairs(v16.bands) do
        n1 = math.min(n1, v17[2])
        n2 = math.max(n2, v17[3])
    end

    local v20 = TitanConfig.StatGradient(PlayerGui:FindFirstChild("HUD"), v16.stat)

    for _, v21 in ipairs({
            {
                t7.lowIcon,
                t7.low,
                n1
            },
            {
                t7.highIcon,
                t7.high,
                n2
            }
        }) do
        TitanConfig.StatIcon(v21[1], v16.stat)
        v21[2].Text = TitanConfig.Signed(p10, v21[3])

        local UIGradient = v21[2]:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Color = v20 and v20.Color or ColorSequence.new(Color3.new(1, 1, 1))
            UIGradient.Rotation = v20 and v20.Rotation or 0
        end
    end

    local v22 = p10

    for v23, v24 in pairs(TitanConfig.SPECIES) do
        if v24.shiny == p10 then
            v22 = v23
        end
    end

    local v25 = TitanConfig.ORIGIN_RISES

    for _, v26 in ipairs(TitanConfig.JURASSIC_RISES) do
        if v26.species == v22 then
            v25 = TitanConfig.JURASSIC_RISES
        end
    end

    local n3 = 0
    local n4 = 0

    for _, v27 in ipairs(v25) do
        n4 += v27.odds

        if v27.species == v22 then
            n3 = v27.odds
        end
    end

    local v28, v29

    if n4 > 0 then
        local v30 = n3 / n4 * 100 / (v22 ~= p10 and TitanConfig.SHINY_ODDS or 1)

        if v30 then
            v28 = v30
            v29 = true
        else
            v29 = false
        end
    else
        v29 = false
    end

    if not v29 then
        v28 = 0
    end

    local v31 = ("%.2f"):format(v28):gsub("%.?0+$", "")

    t7.rise.Text = Loc.F("idx.titan_rise", "{n}% chance to rise", {
        n = v31
    })

    local v32 = RarityDisplay[(FishDisplay[p10] or {}).shown or "Titan"] or RarityDisplay.Titan

    t7.rise.TextColor3 = v32.color:Lerp(Color3.new(1, 1, 1), 0.45)

    local UIStroke = t7.rise:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = v32 == RarityDisplay.Titan and Color3.fromRGB(8, 18, 60) or IndexSpecial.JURASSIC_TITAN.stroke
    end
end

local ZoneBar = Main:WaitForChild("ZoneBar")
local FillClip = ZoneBar:WaitForChild("FillClip")
local Fill = FillClip:WaitForChild("Fill")
local Count = ZoneBar:WaitForChild("Count")
local FishIcon = ZoneBar:WaitForChild("FishIcon")
local Square = ZoneBar:WaitForChild("Square")
local Pop2 = Square:WaitForChild("Pop")
local Icon = Square:WaitForChild("Icon")
local Title = Square:WaitForChild("Title")
local Time = Square:WaitForChild("Time")

for _, v33 in ipairs({ Count, Title, Time }) do
    v33.AutoLocalize = false
end

local Button = PlayerGui:WaitForChild("MenuButtons"):WaitForChild("IndexSlot"):WaitForChild("Button")
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local v34 = {
    CARD_POP = 0.9,
    CARD_POP_TIME = 0.16,
    TAB_BIG = 1.2,
    TAB_GROW = 0.28,
    TAB_SHRINK = 0.18
}
local t9 = {
    IN = 0.18,
    HOLD = 0.12,
    OUT = 0.45,
    SPIN = 90,
    POOL = 4,
    EVERY = { 0.6, 1.2 },
    SIZE = { 0.35, 0.6 },
    AREA_X = { 0.08, 0.92 },
    AREA_Y = { 0.2, 0.8 }
}
local t10 = {
    Common = 131250975971988,
    Uncommon = 108479850651916,
    Rare = 116943864493134,
    Epic = 73083343273396,
    Legendary = 121448081442480,
    Mythic = 123449060769508,
    Exotic = 75764260288528,
    Secret = 131250975971988,
    Celestial = 137758308737373
}
local v35 = Vector2.new(128, 256)
local t11 = {
    Common = 1,
    Uncommon = 1.5,
    Rare = 2,
    Epic = 2.5,
    Legendary = 3,
    Mythic = 4,
    Exotic = 5,
    Secret = 6,
    Unknown = 7,
    Celestial = 6,
    Apex = 8,
    Exclusive = 8,
    Titan = 8
}
local t12 = {
    Halloween = true,
    Thanksgiving = true,
    Unknown = true,
    Exclusive = true,
    Titan = true,
    JurassicTitan = true,
    Apex = true
}
local v36 = Color3.new(1, 1, 1)
local v37 = Color3.new(0, 0, 0)
local v38 = Color3.fromRGB(230, 40, 40)
local color = RarityDisplay.Exotic.color
local v39 = Random.new()
local v40 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v41 = {}
local v42 = {}
local v43 = {}
local t13 = {}
local v44 = nil
local v45 = nil
local v46 = false
local v47 = false
local t14 = {}

local function range(p11) -- line: 346
    -- upvalues: v39 (copy)
    return v39:NextNumber(p11[1], p11[2])
end

local function isNeon(p12) -- line: 351
    -- upvalues: RarityStyle (copy)
    return RarityStyle.Glows(p12)
end

local function dressBar(p13, p14, p15) -- line: 356
    -- upvalues: RarityDisplay (copy), RarityStyle (copy), t10 (copy), v36 (copy)
    local v48 = RarityDisplay[p15] or RarityDisplay.Common
    local color = v48.color

    p13.Image = "rbxassetid://" .. (t10[p15] or 131250975971988)
    p13.ImageColor3 = v48.squareTint or v36

    local v49 = RarityStyle.Glows(color)

    if not v49 or not color then
        p14.TextColor3 = v36
    else
        p14.TextColor3 = color
    end

    p14.UIStroke.Color = RarityStyle.StrokeOf(color)
    p14.UIGradient.Color = v49 and ColorSequence.new(v36) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, v36),
        ColorSequenceKeypoint.new(0.4, v36),
        ColorSequenceKeypoint.new(1, v36:Lerp(color, 0.55))
    })
end

local function dressSpecial(p16, p17, p18, p19) -- line: 374
    -- upvalues: v36 (copy), dressBar (copy)
    if not p19 then
        dressBar(p16, p17, p18)

        return
    end

    p16.Image = "rbxassetid://" .. 131250975971988
    p16.ImageColor3 = p19.bar
    p17.TextColor3 = v36
    p17.UIStroke.Color = p19.stroke
    p17.UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v36),
        ColorSequenceKeypoint.new(0.35, v36),
        ColorSequenceKeypoint.new(1, p19.ink)
    })
end

local function starColor(p20) -- line: 390
    -- upvalues: v36 (copy), v37 (copy), v38 (copy), color (copy)
    if p20 <= 3 then
        return v36
    end

    if p20 < 5 then
        return v38
    end

    if p20 == 5 then
        return color
    end

    return v37
end

local function fillStars(p21, p22, p23) -- line: 398
    -- upvalues: v35 (copy), v36 (copy), v37 (copy), v38 (copy), color (copy)
    local v50 = math.clamp(p22, 0, 8)

    for _, child in ipairs(p21:GetChildren()) do
        if child.Name:match("^Star") then
            child:Destroy()
        end
    end

    p23 = p23 or (if v50 <= 3 then v36
        elseif v50 < 5 then v38
        elseif v50 == 5 then color
        else v37)

    local v52 = math.floor(v50)
    local v53 = v50 - v52 >= 0.5

    for i = 1, v52 + (if v53 then 1 else 0) do
        local v54 = v53 and i == v52 + 1
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Star" .. i
        ImageLabel.LayoutOrder = i
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://91418645780131"
        ImageLabel.ImageColor3 = p23

        local v55 = if v54 then v35 else nil

        if not v54 or not v55 then
            ImageLabel.ImageRectSize = Vector2.zero
        else
            ImageLabel.ImageRectSize = v55
        end

        ImageLabel.ScaleType = Enum.ScaleType.Stretch
        ImageLabel.ZIndex = 7

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = v54 and 0.5 or 1
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
        UIAspectRatioConstraint.Parent = ImageLabel
        ImageLabel.Parent = p21
    end
end

local t15 = {}

local function headOf(p24, p25) -- line: 431
    -- upvalues: Players (copy), t15 (copy)
    if type(p24.id) ~= "number" or not (p24.id > 0) then
        local v56 = t15[p24.by]

        if v56 then
            p25(v56)
        elseif v56 ~= false then
            task.spawn(function() -- line: 436
                -- upvalues: p24 (copy), p25 (copy), Players (copy), t15 (copy)
                local GetUserIdFromNameAsync = Players.GetUserIdFromNameAsync
                local by = p24.by
                local ok, result = pcall(GetUserIdFromNameAsync, Players, by)

                t15[p24.by] = if ok and type(result) == "number" and result > 0 and result then result else false

                if t15[p24.by] then
                    p25(t15[p24.by])
                end
            end)
        end
    else
        p25(p24.id)
    end
end

local function showCard(p26) -- line: 442
    -- upvalues: TweenService (copy), FishDisplay (copy), RarityDisplay (copy), IndexZones (copy), Format (copy), Loc (copy), IndexSpecial (copy), TitanConfig (copy), Owners (copy), Scale2 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), showTitan (copy), t11 (copy), t12 (copy), v36 (copy), v37 (copy), v40 (copy), v41 (ref), v42 (ref), v43 (ref), v45 (ref), v46 (ref), v47 (ref), t14 (copy), dressBar (copy), fillStars (copy), headOf (copy)
    local v58 = FishDisplay[p26]

    if not v58 then
        return
    end

    local v59 = p26 ~= v45

    v45 = p26

    local v60 = IndexZones[p26] or IndexSpecial.TAB_OF[p26]

    if v60 then
        t14[v60] = p26
    end

    local v61 = v41[p26]
    local v62 = v61 ~= nil and (v61.caught or 0) > 0

    t4.icon.Image = v58.icon or ""
    t4.icon.ImageColor3 = v62 and v36 or v37
    dressBar(t4.bar, t4.name, v58.shown or v58.rarity)

    local v63 = v58.rarity == "Exclusive"
    local v64 = TitanConfig.IsTitan(p26)
    local name = t4.name
    local v65, v66

    if v62 or v63 or v64 or IndexSpecial.TAB_OF[p26] == 104 then
        local display = v58.display

        if display then
            v65 = display
            v66 = true
        else
            v66 = false
        end
    else
        v66 = false
    end

    name.Text = if not v66 then "???" else v65

    local v67 = IndexSpecial.HOW_HALLOWEEN[p26]
    local v68 = v63 and IndexSpecial.HOW[p26] or v67
    local how = t4.how

    if v68 ~= nil then
        how.Visible = not v64
    else
        how.Visible = false
    end

    t7.box.Visible = v64

    if v64 then
        showTitan(p26)
    end

    t4.how.Text = v68 and Loc.T(v68) or ""

    local v69 = v67 and t6 or t5

    t4.how.TextColor3 = v69.text

    local UIStroke = t4.how:FindFirstChildOfClass("UIStroke")

    if UIStroke and v69.stroke then
        UIStroke.Color = v69.stroke
    end

    local v70 = if not v63 or IndexSpecial.NO_COPIES[p26] then nil else v43[p26] or 0

    t4.copies.Visible = v70 ~= nil
    t4.copies.Text = v70 and Loc.F("idx.copies", "COPIES: {n}", {
        n = tostring(v70):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    }) or ""

    local v71 = v58.shown or v58.rarity

    fillStars(t4.rarityStars, t11[v58.rarity] or 1, t12[v71] and RarityDisplay[v71].color or nil)

    for _, v74 in ipairs({
            t4.caught,
            t4.biggest,
            t4.record,
            t4.recordBy
        }) do
        v74.AutoLocalize = false
    end

    t4.caught.Text = Loc.F("idx.caught", "CAUGHT: {n}", {
        n = tostring(v61 and v61.caught or 0)
    })
    t4.biggest.Text = Loc.F("idx.biggest", "BIGGEST: {kg}", {
        kg = v62 and Format.kg(v61.best or 0) or "?"
    })

    local v75 = v42[p26]

    local function red(p27) -- line: 480
        if p27 == "" then
            return ""
        end

        return "<font color=\"" .. "#FF2828" .. "\">" .. p27:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
    end

    local v76 = Loc.F("idx.record", "WORLD RECORD: {kg}", {
        kg = "\000"
    })
    local v77 = v76:find("\000", 1, true)
    local v78 = (v75 and Format.kg(v75.kg) or "?"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

    t4.record.RichText = true

    local record = t4.record
    local v79, v80

    if v77 then
        local v81 = v76:sub(1, v77 - 1)
        local v82 = if v81 == "" then "" else "<font color=\"" .. "#FF2828" .. "\">" .. v81:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
        local v83 = v76:sub(v77 + 1)
        local v84 = v82 .. v78 .. (if v83 == "" then "" else "<font color=\"" .. "#FF2828" .. "\">" .. v83:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>")

        if v84 then
            v79 = v84
            v80 = true
        else
            v80 = false
        end
    else
        v80 = false
    end

    if not v80 then
        v79 = if v76 == "" then "" else "<font color=\"" .. "#FF2828" .. "\">" .. v76:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
    end

    record.Text = v79
    t4.recordBy.Text = v75 and v75.by or ""
    t4.recordBy.TextColor3 = Color3.fromHex("#FF2828")
    t4.recordBy.Visible = v75 ~= nil
    t4.recordHead.Visible = v75 ~= nil
    t4.recordHead.Face.Image = ""
    t4.caughtBy.Visible = v75 ~= nil
    t4.caughtBy.Text = Loc.T("Caught by:")

    if v75 then
        headOf(v75, function(p28) -- line: 498
            -- upvalues: p26 (copy), v75 (copy), t4 (copy), v42 (ref), v45 (ref)
            if v45 == p26 and v42[p26] == v75 then
                t4.recordHead.Face.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(p28)
            end
        end)
    end

    Owners.Show(p26, "#FF2828")

    if v59 and v46 and not v47 then
        Scale2.Scale = 0.9
        TweenService:Create(Scale2, v40, {
            Scale = 1
        }):Play()
    end
end

local t18 = {
    GAP = 0.13,
    MIN_GAP = 0.05,
    MAX_TIME = 2.8,
    PAD = 0.35,
    TAIL = 0.12,
    SCROLL = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}
local t19 = {
    text = "!",
    size = 0.36,
    zIndex = 9,
    at = Vector2.new(0.16, 0.16)
}
local t20 = {
    text = "!",
    size = 0.62,
    at = Vector2.new(0.955, 0.2)
}
local t21 = {
    FINISH = 1.15,
    SQUARE_POP = 1.3,
    COUNT_GAP = 0.012,
    LATER_ICON = "rbxassetid://138818103926341",
    STEP = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TOP_UP = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    OWED = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    SQUARE_UP = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SQUARE_SETTLE = TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    NEXT_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    HARPOON = {
        square = "Secret",
        color = Color3.fromRGB(190, 120, 255),
        text = RarityDisplay.Secret.color,
        ink = {
            Color3.new(1, 1, 1),
            Color3.new(1, 1, 1),
            RarityStyle.StrokeOf(RarityDisplay.Secret.color)
        }
    },
    KEY = {
        square = "Secret",
        title = "SECRET KEY",
        color = Color3.fromRGB(190, 190, 205),
        ink = {
            Color3.new(1, 1, 1),
            Color3.fromRGB(190, 190, 205),
            Color3.new(0, 0, 0)
        }
    },
    CASH = {
        icon = "rbxassetid://117252679272986",
        square = "Uncommon",
        color = Color3.fromRGB(0, 206, 7),
        ink = {
            Color3.fromRGB(225, 255, 0),
            Color3.fromRGB(0, 206, 7),
            Color3.new(0, 0, 0)
        }
    },
    EGG = {
        icon = "rbxassetid://92978738810887",
        square = "Legendary",
        title = "MASSIVE EGG",
        color = Color3.fromRGB(255, 190, 40),
        ink = {
            Color3.fromRGB(255, 230, 90),
            Color3.fromRGB(255, 140, 0),
            Color3.fromRGB(60, 18, 0)
        }
    }
}
local t22 = {}

for v85, v86 in pairs(IndexZones) do
    local v87 = FishDisplay[v85]

    if type(v86) == "number" and v87 and KeyConfig.INDEX[v87.rarity] then
        t22[v86] = t22[v86] or {}
        table.insert(t22[v86], v85)
    end
end

for _, v89 in ipairs(IndexSpecial.TABS) do
    if v89.claims then
        t22[v89.id] = v89.species
    end
end

local function popOf(p29, p30) -- line: 585
    -- upvalues: KeyConfig (copy), PotionConfig (copy), IndexSpecial (copy)
    local v90 = IndexSpecial.BY_ID[p29]
    local each = v90 and v90.each or {
        byRarity = true
    }

    if each.potion then
        return {
            image = (PotionConfig.Get(each.potion) or {}).icon
        }
    end

    if each.key then
        return each.key
    end

    return if each.byRarity then KeyConfig.INDEX[p30] else nil
end

local v91 = {}
local v92 = {}
local v93 = false
local t24 = {}
local t25 = {}
local v94 = false
local n5 = 0

ClaimFx.Init(IndexGui:WaitForChild("Fx"), Templates:WaitForChild("Sparkle").Image)

local function isFound(p31) -- line: 603
    -- upvalues: v41 (ref)
    local v95 = v41[p31]

    return v95 ~= nil and (v95.caught or 0) > 0
end

local function isNew(p32) -- line: 607
    -- upvalues: v41 (ref), v91 (ref), v93 (ref)
    local v96 = v93

    if not v96 then
        return v96
    end

    local v97 = v41[p32]

    return v97 ~= nil and (v97.caught or 0) > 0 and not v91[p32]
end

local function markSlot(p33, p34, p35) -- line: 611
    -- upvalues: Badge (copy), t19 (copy), t24 (copy)
    local v98 = t24[p33]

    if p35 and not v98 then
        v98 = Badge.Attach(p34, t19)
        t24[p33] = v98
    end

    if not v98 then
        return
    end

    v98.Set(p35 and 1 or 0)
end

local t26 = {}

local function markTabNew(p36, p37) -- line: 622
    -- upvalues: Badge (copy), IndexSpecial (copy), Tabs (copy), t20 (copy), t26 (copy)
    local v99 = t26[p36]
    local Tabs2, v100, v101

    if not p37 or v99 then
        v101 = v99
    else
        Tabs2 = Tabs
        v100 = if IndexSpecial.BY_ID[p36] then "Tab" else "Zone"

        local v102 = Tabs2:FindFirstChild(v100 .. p36)

        if not v102 then
            return
        end

        local v103 = v102.ZIndex

        for _, descendant in ipairs(v102:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                v103 = math.max(v103, descendant.ZIndex)
            end
        end

        local v104 = table.clone(t20)

        v104.zIndex = v103 + 2
        v101 = Badge.Attach(v102, v104)
        t26[p36] = v101
    end

    if not v101 then
        return
    end

    v101.Set(p37 and 1 or 0)
end

local t27 = {
    red = Color3.fromRGB(255, 190, 40),
    flash = Color3.fromRGB(255, 248, 215)
}
local t28 = {
    text = "!",
    size = 0.36,
    zIndex = 9,
    at = Vector2.new(0.84, 0.16),
    red = t27.red,
    flash = t27.flash
}
local t29 = {
    text = "!",
    size = 0.62,
    at = Vector2.new(0.955, 0.8),
    red = t27.red,
    flash = t27.flash
}
local t30 = {}
local t31 = {}
local t32 = {}

local function readWorld() -- line: 650
    -- upvalues: LocalPlayer (copy), t30 (copy)
    table.clear(t30)

    for match in string.gmatch(LocalPlayer:GetAttribute("IndexWorld") or "", "[^,]+") do
        t30[match] = true
    end
end

table.clear(t30)

for match in string.gmatch(LocalPlayer:GetAttribute("IndexWorld") or "", "[^,]+") do
    t30[match] = true
end

local function goldSlot(p38, p39, p40) -- line: 655
    -- upvalues: Badge (copy), t28 (copy), t31 (copy)
    local v105 = t31[p38]

    if p40 and not v105 then
        v105 = Badge.Attach(p39, t28)
        t31[p38] = v105
    end

    if not v105 then
        return
    end

    v105.Set(p40 and 1 or 0)
end

local function goldTab(p41, p42) -- line: 663
    -- upvalues: Badge (copy), IndexSpecial (copy), Tabs (copy), t29 (copy), t32 (copy)
    local v106 = t32[p41]
    local Tabs2, v107, v108

    if not p42 or v106 then
        v108 = v106
    else
        Tabs2 = Tabs
        v107 = if IndexSpecial.BY_ID[p41] then "Tab" else "Zone"

        local v109 = Tabs2:FindFirstChild(v107 .. p41)

        if not v109 then
            return
        end

        local v110 = v109.ZIndex

        for _, descendant in ipairs(v109:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                v110 = math.max(v110, descendant.ZIndex)
            end
        end

        local v111 = table.clone(t29)

        v111.zIndex = v110 + 2
        v108 = Badge.Attach(v109, v111)
        t32[p41] = v108
    end

    if not v108 then
        return
    end

    v108.Set(p42 and 1 or 0)
end

local t33 = {
    text = "!",
    size = 0.5,
    at = Vector2.new(0.92, 0.12)
}
local t34 = {}

local function markModeNew(p43, p44) -- line: 682
    -- upvalues: Badge (copy), ModeTabs (copy), t33 (copy), t34 (copy)
    local v112 = t34[p43]

    if p44 and not v112 then
        local v113 = ModeTabs:FindFirstChild(p43:sub(1, 1) .. p43:sub(2):lower())

        if not v113 then
            return
        end

        local v114 = v113.ZIndex

        for _, descendant in ipairs(v113:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                v114 = math.max(v114, descendant.ZIndex)
            end
        end

        local v115 = table.clone(t33)

        v115.zIndex = v114 + 2
        v112 = Badge.Attach(v113, v115)
        t34[p43] = v112
    end

    if not v112 then
        return
    end

    v112.Set(p44 and 1 or 0)
end

local t35 = {}

local function markIslandNew(p45, p46) -- line: 699
    -- upvalues: Badge (copy), Row (copy), t33 (copy), t35 (copy)
    local v116 = t35[p45]

    if p46 and not v116 then
        local v117 = Row:FindFirstChild(p45)

        if not v117 then
            return
        end

        local v118 = v117.ZIndex

        for _, descendant in ipairs(v117:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                v118 = math.max(v118, descendant.ZIndex)
            end
        end

        local v119 = table.clone(t33)

        v119.zIndex = v118 + 2
        v116 = Badge.Attach(v117, v119)
        t35[p45] = v116
    end

    if not v116 then
        return
    end

    v116.Set(p46 and 1 or 0)
end

local function zoneHasWorld(p47) -- line: 715
    -- upvalues: IndexZones (copy), IndexSpecial (copy), t30 (copy)
    for v120 in pairs(t30) do
        if (IndexZones[v120] or IndexSpecial.TAB_OF[v120]) == p47 then
            return true
        end
    end

    return false
end

local function zoneHasNew(p48) -- line: 722
    -- upvalues: v41 (ref), t22 (copy), v91 (ref), v93 (ref), t25 (copy)
    for _, v121 in ipairs(t22[p48] or {}) do
        if t25[v121] then
            return true
        end

        local v122 = v93

        if v122 then
            local v123 = v41[v121]

            v122 = v123 ~= nil and (v123.caught or 0) > 0 and not v91[v121]
        end

        if v122 then
            return true
        end
    end

    return false
end

local function refreshMarks() -- line: 730
    -- upvalues: IndexZones (copy), Badge (copy), IndexSpecial (copy), t1 (copy), t3 (copy), v41 (ref), t13 (copy), v44 (ref), v46 (ref), t19 (copy), v91 (ref), v93 (ref), t24 (copy), t25 (copy), markTabNew (copy), t28 (copy), t30 (copy), t31 (copy), goldTab (copy), markModeNew (copy), markIslandNew (copy), zoneHasNew (copy)
    for v124, v125 in pairs(t13) do
        for v126, v127 in pairs(v125.slots) do
            local v128 = v46

            if v128 then
                if v124 == v44 then
                    if t25[v126] == true then
                        v128 = true
                    else
                        v128 = v93

                        if v128 then
                            local v129 = v41[v126]

                            v128 = v129 ~= nil and (v129.caught or 0) > 0 and not v91[v126]
                        end
                    end
                else
                    v128 = false
                end
            end

            local v130 = t24[v126]

            if v128 and not v130 then
                v130 = Badge.Attach(v127, t19)
                t24[v126] = v130
            end

            if v130 then
                v130.Set(v128 and 1 or 0)
            end

            local v131 = v46 and v124 == v44 and t30[v126] == true
            local v132 = t31[v126]

            if v131 and not v132 then
                v132 = Badge.Attach(v127, t28)
                t31[v126] = v132
            end

            if v132 then
                v132.Set(v131 and 1 or 0)
            end
        end
    end

    local t36 = {}
    local t37 = {}

    for _, v133 in ipairs(t3) do
        local v134 = v46 and zoneHasNew(v133)

        markTabNew(v133, v134)

        local v135 = v46
        local v136

        if v135 then
            local v137 = false

            for v138 in pairs(t30) do
                if (IndexZones[v138] or IndexSpecial.TAB_OF[v138]) == v133 then
                    v136 = true
                    v137 = true
                    break
                end
            end

            if not v137 then
                v136 = false
            end
        else
            v136 = v135
        end

        goldTab(v133, v136)

        if v134 then
            local v139 = IndexSpecial.BY_ID[v133]

            t36[v139 and v139.mode or "NORMAL"] = true

            local v140 = IndexSpecial.BY_ID[v133]

            if (v140 and v140.mode or "NORMAL") == "NORMAL" then
                t37[type(v133) == "number" and v133 >= 8 and v133 <= 10 and "Jurassic" or "Origins"] = true
            end
        end
    end

    for _, v141 in ipairs(IndexSpecial.MODES) do
        markModeNew(v141, t36[v141] == true)
    end

    for _, v142 in ipairs(t1) do
        markIslandNew(v142, t37[v142] == true)
    end
end

local function seeWorld(p49) -- line: 750
    -- upvalues: IndexClaim (copy), t30 (copy), refreshMarks (copy)
    if t30[p49] then
        t30[p49] = nil
        refreshMarks()
        task.spawn(pcall, IndexClaim.InvokeServer, IndexClaim, "WorldSeen", p49)
    end
end

local NumberValue = Instance.new("NumberValue")

local function poseBar() -- line: 759
    -- upvalues: FillClip (copy), Fill (copy), NumberValue (copy)
    local v143 = math.clamp(NumberValue.Value, 0, 1)

    FillClip.Visible = v143 > 0.001
    FillClip.Size = UDim2.fromScale(math.max(v143, 0.001), 1)
    Fill.Size = UDim2.fromScale(1 / math.max(v143, 0.001), 1)
end

NumberValue.Changed:Connect(poseBar)

local function placeCount() -- line: 768
    -- upvalues: ZoneBar (copy), Count (copy), FishIcon (copy), t21 (copy)
    local X = ZoneBar.AbsoluteSize.X

    if X <= 0 then
        return
    end

    local v144 = Count.TextBounds.X / X
    local v145 = FishIcon.AbsoluteSize.X / X
    local v146 = 0.5 - (v145 + t21.COUNT_GAP + v144) / 2

    FishIcon.Position = UDim2.fromScale(v146 + v145, FishIcon.Position.Y.Scale)
    Count.Position = UDim2.fromScale(v146 + v145 + t21.COUNT_GAP + v144 / 2, Count.Position.Y.Scale)
end

Count:GetPropertyChangedSignal("TextBounds"):Connect(placeCount)
ZoneBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeCount)

local UIGradient = Title:FindFirstChildOfClass("UIGradient")
local UIStroke = Title:FindFirstChildOfClass("UIStroke")

local function dressSquare(p50) -- line: 783
    -- upvalues: RarityDisplay (copy), Format (copy), Loc (copy), KeyConfig (copy), IndexLadder (copy), PotionConfig (copy), HarpoonSkins (copy), LocalPlayer (copy), Square (copy), Icon (copy), Title (copy), Time (copy), t21 (copy), UIGradient (copy), UIStroke (copy)
    local v147 = p50 and p50.potion
    local v148 = PotionConfig.Get(v147)
    local v149 = PotionConfig.Kind(v147)
    local v150, v151

    if p50 then
        if p50.cash then
            local CASH = t21.CASH

            if CASH then
                v150 = CASH
                v151 = true
            elseif p50.egg then
                local EGG = t21.EGG

                if EGG then
                    v150 = EGG
                    v151 = true
                elseif p50.harpoon then
                    local HARPOON = t21.HARPOON

                    if HARPOON then
                        v150 = HARPOON
                        v151 = true
                    elseif p50.key then
                        local KEY = t21.KEY

                        if KEY then
                            v150 = KEY
                            v151 = true
                        else
                            v151 = false
                        end
                    else
                        v151 = false
                    end
                elseif p50.key then
                    local KEY = t21.KEY

                    if KEY then
                        v150 = KEY
                        v151 = true
                    else
                        v151 = false
                    end
                else
                    v151 = false
                end
            elseif p50.harpoon then
                local HARPOON = t21.HARPOON

                if HARPOON then
                    v150 = HARPOON
                    v151 = true
                elseif p50.key then
                    local KEY = t21.KEY

                    if KEY then
                        v150 = KEY
                        v151 = true
                    else
                        v151 = false
                    end
                else
                    v151 = false
                end
            elseif p50.key then
                local KEY = t21.KEY

                if KEY then
                    v150 = KEY
                    v151 = true
                else
                    v151 = false
                end
            else
                v151 = false
            end
        elseif p50.egg then
            local EGG = t21.EGG

            if EGG then
                v150 = EGG
                v151 = true
            elseif p50.harpoon then
                local HARPOON = t21.HARPOON

                if HARPOON then
                    v150 = HARPOON
                    v151 = true
                elseif p50.key then
                    local KEY = t21.KEY

                    if KEY then
                        v150 = KEY
                        v151 = true
                    else
                        v151 = false
                    end
                else
                    v151 = false
                end
            elseif p50.key then
                local KEY = t21.KEY

                if KEY then
                    v150 = KEY
                    v151 = true
                else
                    v151 = false
                end
            else
                v151 = false
            end
        elseif p50.harpoon then
            local HARPOON = t21.HARPOON

            if HARPOON then
                v150 = HARPOON
                v151 = true
            elseif p50.key then
                local KEY = t21.KEY

                if KEY then
                    v150 = KEY
                    v151 = true
                else
                    v151 = false
                end
            else
                v151 = false
            end
        elseif p50.key then
            local KEY = t21.KEY

            if KEY then
                v150 = KEY
                v151 = true
            else
                v151 = false
            end
        else
            v151 = false
        end
    else
        v151 = false
    end

    if not v151 then
        v150 = nil
    end

    local square, v152

    if v149 then
        local square2 = v149.square

        if square2 then
            square = square2
            v152 = true
        elseif v150 then
            local square2 = RarityDisplay[v150.square].square

            if square2 then
                square = square2
                v152 = true
            else
                v152 = false
            end
        else
            v152 = false
        end
    elseif v150 then
        local square2 = RarityDisplay[v150.square].square

        if square2 then
            square = square2
            v152 = true
        else
            v152 = false
        end
    else
        v152 = false
    end

    Square.Image = if not v152 then RarityDisplay.Common.square else square

    local v153, v154

    if v149 then
        v154 = false
    elseif v150 then
        local squareTint = RarityDisplay[v150.square].squareTint

        if squareTint then
            v153 = squareTint
            v154 = true
        else
            v154 = false
        end
    else
        v154 = false
    end

    Square.ImageColor3 = if not v154 then Color3.new(1, 1, 1) else v153

    local v155 = p50 and p50.harpoon and HarpoonSkins.Get(p50.harpoon)
    local v156 = p50 and p50.key and KeyConfig.KEYS[p50.key]
    local v157, v158

    if v148 then
        local icon = v148.icon

        if icon then
            v157 = icon
            v158 = true
        elseif v155 then
            local icon = v155.icon

            if icon then
                v157 = icon
                v158 = true
            else
                v158 = false
            end
        else
            v158 = false
        end
    elseif v155 then
        local icon = v155.icon

        if icon then
            v157 = icon
            v158 = true
        else
            v158 = false
        end
    else
        v158 = false
    end

    if not v158 then
        local v159 = false

        if v156 then
            local image = v156.image

            if image then
                v157 = image
                v159 = true
            elseif v150 then
                local icon = v150.icon

                if icon then
                    v157 = icon
                    v159 = true
                end
            end
        elseif v150 then
            local icon = v150.icon

            if icon then
                v157 = icon
                v159 = true
            end
        end

        if not v159 then
            v157 = t21.LATER_ICON
        end
    end

    Icon.Image = v157
    Icon.ImageRectOffset = v156 and Vector2.new(v156.rect[1], v156.rect[2]) or Vector2.zero
    Icon.ImageRectSize = v156 and Vector2.new(v156.rect[3] - v156.rect[1], v156.rect[4] - v156.rect[2]) or Vector2.zero

    local v162 = v148 ~= nil or v150 ~= nil
    local v163 = v148 ~= nil

    Title.Visible = v162
    Time.Visible = v163

    if v148 then
        Title.Text = PotionConfig.Title(v147, Loc)
        Time.Text = "(" .. Loc.F(PotionConfig.LenKey(v147), PotionConfig.Length(v147)) .. ")"
    elseif v150 then
        Title.Text = p50.cash and Format.money(IndexLadder.Cash(p50, LocalPlayer:GetAttribute("PenRate"))) or v155 and Loc.T(string.upper(v155.name)) or Loc.T(v150.title or "?")
    else
        return
    end

    local ink = if v148 then v149.ink or v150.ink else v150.ink
    local text = if v148 then Color3.new(1, 1, 1) else v150.text or Color3.new(1, 1, 1)

    Title.TextColor3 = text

    if UIGradient then
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ink[1]),
            ColorSequenceKeypoint.new(1, ink[2])
        })
    end

    if UIStroke then
        UIStroke.Color = ink[3]
    end
end

local function zoneCount(p51) -- line: 818
    -- upvalues: t22 (copy), v91 (ref), t25 (copy)
    local n6 = 0

    for _, v166 in ipairs(t22[p51] or {}) do
        if v91[v166] and not t25[v166] then
            n6 += 1
        end
    end

    return n6
end

local v167

local function showRung(p52, p53, p54) -- line: 828
    -- upvalues: TweenService (copy), Loc (copy), IndexLadder (copy), IndexSpecial (copy), Count (copy), t21 (copy), t22 (copy), NumberValue (copy), dressSquare (copy), v167 (ref)
    local v168 = t22[p52]

    if not v168 then
        return
    end

    local v169 = IndexSpecial.BY_ID[p52]

    if not v169 or v169.ladder then
        local v175, v176, v177, v178, v179 = IndexLadder.At(#v168, p53, p52)
        local v180 = p52 .. ":" .. v175

        if v180 ~= v167 then
            v167 = v180
            dressSquare(v178[v175] and v178[v175].reward)
        end

        Count.Text = v179 and Loc.F("idx.ladder_done", "COMPLETE!") or v176 .. "/" .. v177

        local v183 = if v179 then 1 else v176 / math.max(v177, 1)

        if p54 then
            TweenService:Create(NumberValue, t21.STEP, {
                Value = v183
            }):Play()
        else
            NumberValue.Value = v183
        end
    else
        local v171 = p52 .. ":special"

        if v171 ~= v167 then
            v167 = v171
            dressSquare(v169.done or v169.each and not v169.each.byRarity and v169.each or nil)
        end

        local v172 = #v168

        Count.Text = v172 <= p53 and Loc.F("idx.ladder_done", "COMPLETE!") or p53 .. "/" .. v172

        local v174 = p53 / math.max(v172, 1)

        if p54 then
            TweenService:Create(NumberValue, t21.STEP, {
                Value = v174
            }):Play()
        else
            NumberValue.Value = v174
        end
    end
end

local function finishRung(p55, p56, p57, p58, p59) -- line: 871
    -- upvalues: TweenService (copy), IndexLadder (copy), PotionConfig (copy), ClaimFx (copy), Count (copy), Square (copy), Pop2 (copy), t21 (copy), t22 (copy), n5 (ref), NumberValue (copy), dressSquare (copy), v167 (ref), showRung (copy)
    local v184 = t22[p55]
    local v185 = IndexLadder.Rungs(#v184, p55)[p56]
    local v186 = p55 .. ":" .. p56

    if v186 ~= v167 then
        v167 = v186
        dressSquare(v185.reward)
    end

    Count.Text = v185.size .. "/" .. v185.size
    p59 = p59 or t21.TOP_UP
    TweenService:Create(NumberValue, p59, {
        Value = 1
    }):Play()
    task.wait(p59.Time)

    if n5 ~= p58 then
        return
    end

    local tween = TweenService:Create(Pop2, t21.SQUARE_UP, {
        Scale = t21.SQUARE_POP
    })

    tween.Completed:Once(function() -- line: 886
        -- upvalues: TweenService (copy), Pop2 (copy), t21 (copy)
        TweenService:Create(Pop2, t21.SQUARE_SETTLE, {
            Scale = 1
        }):Play()
    end)
    tween:Play()

    local v188 = PotionConfig.Get(v185.reward.potion)
    local v189 = PotionConfig.Kind(v185.reward.potion)
    local v190, v191

    if v185.reward.cash then
        local CASH = t21.CASH

        if CASH then
            v190 = CASH
            v191 = true
        elseif v185.reward.egg then
            local EGG = t21.EGG

            if EGG then
                v190 = EGG
                v191 = true
            else
                v191 = false
            end
        else
            v191 = false
        end
    elseif v185.reward.egg then
        local EGG = t21.EGG

        if EGG then
            v190 = EGG
            v191 = true
        else
            v191 = false
        end
    else
        v191 = false
    end

    if not v191 then
        v190 = nil
    end

    local Rung = ClaimFx.Rung
    local icon = v188 and v188.icon or v190 and v190.icon
    local v192, v193

    if v189 then
        local color = v189.color

        if color then
            v192 = color
            v193 = true
        elseif v190 then
            local color = v190.color

            if color then
                v192 = color
                v193 = true
            else
                v193 = false
            end
        else
            v193 = false
        end
    elseif v190 then
        local color = v190.color

        if color then
            v192 = color
            v193 = true
        else
            v193 = false
        end
    else
        v193 = false
    end

    if not v193 then
        v192 = Color3.new(1, 1, 1)
    end

    Rung(Square, icon, v192)
    task.wait(t21.FINISH)

    if n5 == p58 then
        local _, _, _, _, v194 = IndexLadder.At(#v184, p57, p55)

        if v194 then
            showRung(p55, p57, false)
        else
            NumberValue.Value = 0
            Pop2.Scale = 0.4
            showRung(p55, p57, false)
            TweenService:Create(Pop2, t21.NEXT_IN, {
                Scale = 1
            }):Play()
        end
    end
end

local function finishDone(p60, p61, p62) -- line: 907
    -- upvalues: TweenService (copy), IndexSpecial (copy), HarpoonSkins (copy), ClaimFx (copy), Square (copy), Pop2 (copy), v44 (ref), t21 (copy), n5 (ref), NumberValue (copy), v167 (ref), showRung (copy)
    local v195 = IndexSpecial.BY_ID[p60]

    if not v195 or not v195.done or v44 ~= p60 then
        return
    end

    v167 = nil
    showRung(p60, #v195.species, false)
    NumberValue.Value = if p62 then 0 else NumberValue.Value
    p62 = p62 or t21.TOP_UP
    TweenService:Create(NumberValue, p62, {
        Value = 1
    }):Play()
    task.wait(p62.Time)

    if n5 ~= p61 then
        return
    end

    local tween = TweenService:Create(Pop2, t21.SQUARE_UP, {
        Scale = t21.SQUARE_POP
    })

    tween.Completed:Once(function() -- line: 918
        -- upvalues: TweenService (copy), Pop2 (copy), t21 (copy)
        TweenService:Create(Pop2, t21.SQUARE_SETTLE, {
            Scale = 1
        }):Play()
    end)
    tween:Play()

    local v198 = v195.done.harpoon and HarpoonSkins.Get(v195.done.harpoon)

    ClaimFx.Rung(Square, v198 and v198.icon or t21.LATER_ICON, t21.HARPOON.color)
    task.wait(t21.FINISH)
end

local function barStep(p63, p64, p65, p66) -- line: 926
    -- upvalues: IndexLadder (copy), IndexSpecial (copy), v44 (ref), t22 (copy), n5 (ref), showRung (copy), finishRung (copy)
    if v44 ~= p63 then
        return
    end

    local v199 = IndexSpecial.BY_ID[p63]

    if v199 ~= nil and not v199.ladder then
        showRung(p63, p65, true)
    else
        local v200 = #(t22[p63] or {})
        local v201 = IndexLadder.Filled(v200, p64, p63)
        local v202 = IndexLadder.Filled(v200, p65, p63)

        if v201 < v202 then
            for i = v201 + 1, v202 do
                finishRung(p63, i, p65, p66)

                if n5 ~= p66 then
                    return
                end
            end
        else
            showRung(p63, p65, true)
        end
    end
end

local function contentY(p67) -- line: 945
    -- upvalues: List (copy)
    return p67.AbsolutePosition.Y - List.AbsolutePosition.Y + List.CanvasPosition.Y
end

local function shuffle(p68) -- line: 948
    -- upvalues: v39 (copy)
    for i = #p68, 2, -1 do
        local v203 = v39:NextInteger(1, i)
        local v204 = p68[v203]
        local v205 = p68[i]

        p68[i] = v204
        p68[v203] = v205
    end
end

local function runOrder(p69, p70, p71) -- line: 956
    -- upvalues: List (copy), shuffle (copy)
    local t38 = {}

    for _, v206 in ipairs(p70) do
        local v207 = p69 and p69.slots[v206]

        if v207 then
            t38[#t38 + 1] = {
                name = v206,
                slot = v207,
                y = v207.AbsolutePosition.Y - List.AbsolutePosition.Y + List.CanvasPosition.Y,
                x = v207.AbsolutePosition.X
            }
        end
    end

    table.sort(t38, function(p72, p73) -- line: 962
        if math.abs(p72.y - p73.y) > 1 then
            return p72.y < p73.y
        end

        return p72.x < p73.x
    end)

    if #t38 == 0 or t38[1].name == p71 then
        return t38
    end

    local v209 = math.max(1, List.AbsoluteWindowSize.Y)
    local Y2 = List.CanvasPosition.Y
    local t39 = {}
    local t40 = {}
    local v210

    for _, v211 in ipairs(t38) do
        if v211.name == p71 then
            v210 = v211
        else
            local v212 = if v211.y >= Y2 - 1 and v211.y + v211.slot.AbsoluteSize.Y <= Y2 + v209 + 1 then 0 else math.floor(v211.y / v209) + 1

            if not t39[v212] then
                t39[v212] = {}
                t40[#t40 + 1] = v212
            end

            table.insert(t39[v212], v211)
        end
    end

    table.sort(t40)

    local t41 = {
        v210
    }

    for _, v215 in ipairs(t40) do
        local v216 = t39[v215]
        local n7 = 1e999

        for _, v217 in ipairs(v216) do
            n7 = math.min(n7, v217.y)
        end

        shuffle(v216)

        if v215 > 0 then
            v216[1].pageTop = n7
        end

        for _, v218 in ipairs(v216) do
            t41[#t41 + 1] = v218
        end
    end

    return t41
end

local function scrollTo(p74, p75) -- line: 998
    -- upvalues: TweenService (copy), List (copy), t18 (copy)
    local v220 = math.max(0, List.AbsoluteCanvasSize.Y - List.AbsoluteWindowSize.Y)
    local v222 = math.clamp(p74 - p75 * t18.PAD, 0, v220)

    if math.abs(v222 - List.CanvasPosition.Y) < 1 then
        return false
    end

    TweenService:Create(List, t18.SCROLL, {
        CanvasPosition = Vector2.new(List.CanvasPosition.X, v222)
    }):Play()

    return true
end

local function onScreen(p76) -- line: 1005
    -- upvalues: List (copy)
    local v224 = p76.AbsolutePosition.Y - List.AbsolutePosition.Y + List.CanvasPosition.Y
    local Y = List.CanvasPosition.Y

    if Y - 1 <= v224 then
        return v224 + p76.AbsoluteSize.Y <= Y + List.AbsoluteWindowSize.Y + 1
    end

    return false
end

local function sweep(p77, p78, p79) -- line: 1010
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), ClaimFx (copy), Scale (copy), List (copy), t18 (copy), popOf (copy), t24 (copy), t25 (copy), n5 (ref), zoneCount (copy), barStep (copy), scrollTo (copy)
    local v225 = #p78
    local v227 = math.clamp(t18.MAX_TIME / math.max(v225, 1), t18.MIN_GAP, t18.GAP)

    for v228, v229 in ipairs(p78) do
        if n5 ~= p79 then
            return
        end

        local Y = v229.slot.AbsoluteSize.Y

        if v229.pageTop and scrollTo(v229.pageTop, Y) then
            task.wait(t18.SCROLL.Time)

            local v230 = n5

            if v230 ~= p79 then
                return
            end
        else
            local slot = v229.slot
            local v231 = slot.AbsolutePosition.Y - List.AbsolutePosition.Y + List.CanvasPosition.Y
            local Y2 = List.CanvasPosition.Y

            if not (Y2 - 1 <= v231 and v231 + slot.AbsoluteSize.Y <= Y2 + List.AbsoluteWindowSize.Y + 1) and scrollTo(v229.slot.AbsolutePosition.Y - List.AbsolutePosition.Y + List.CanvasPosition.Y, Y) then
                task.wait(t18.SCROLL.Time)

                local v233 = n5

                if v233 ~= p79 then
                    return
                end
            end
        end

        local v234 = zoneCount(p77)

        t25[v229.name] = nil

        local name, _ = v229.name, v229.slot
        local v235 = t24[name]

        if v235 then
            v235.Set(0)
        end

        local rarity = FishDisplay[v229.name].rarity
        local v236 = RarityDisplay[rarity]

        v236 = v236 or RarityDisplay.Common
        ClaimFx.Pop(v229.slot, v229.slot:FindFirstChild("Icon"), v236.color, popOf(p77, rarity), v225 > 1 and (v228 - 1) / (v225 - 1) or 0)
        barStep(p77, v234, zoneCount(p77), p79)

        local v237 = n5

        if v237 ~= p79 then
            return
        end

        if v228 < v225 then
            task.wait(v227)
        end
    end

    task.wait(t18.TAIL)

    if n5 == p79 then
        ClaimFx.Thump(Scale)
    end
end

local function playOwed(p80) -- line: 1070
    -- upvalues: IndexClaim (copy), IndexLadder (copy), IndexSpecial (copy), v44 (ref), v46 (ref), t21 (copy), t22 (copy), v92 (ref), v93 (ref), v94 (ref), n5 (ref), NumberValue (copy), zoneCount (copy), v167 (ref), showRung (copy), finishRung (copy), finishDone (copy)
    local v238 = t22[p80]

    if v94 or not v93 or not v46 or not v238 then
        return
    end

    local v239 = IndexSpecial.BY_ID[p80]

    if not v239 or v239.ladder then
        local v240 = IndexLadder.Filled(#v238, zoneCount(p80), p80)
        local v241 = v92

        if not (v240 <= (v241["z" .. p80] or 0)) then
            v94 = true

            local v242 = n5

            task.spawn(function() -- line: 1093
                -- upvalues: p80 (copy), v238 (copy), v242 (copy), IndexClaim (copy), IndexLadder (copy), v44 (ref), t21 (copy), v92 (ref), v94 (ref), n5 (ref), NumberValue (copy), zoneCount (copy), v167 (ref), showRung (copy), finishRung (copy)
                local InvokeServer = IndexClaim.InvokeServer
                local ok, result = pcall(InvokeServer, IndexClaim, "Rungs", p80)

                if ok and type(result) == "table" and #result > 0 then
                    local v243 = v92
                    local v244 = "z" .. p80
                    local v246 = v92

                    v243[v244] = math.max(v246["z" .. p80] or 0, result[#result])

                    local v248 = IndexLadder.Rungs(#v238, p80)
                    local v249 = zoneCount(p80)

                    for v250, v251 in ipairs(result) do
                        if n5 ~= v242 or v44 ~= p80 then
                            break
                        end

                        local n8 = 0

                        for i = 1, v251 do
                            n8 += v248[i].size
                        end

                        v167 = nil
                        NumberValue.Value = 0
                        finishRung(p80, v251, v250 == #result and v249 or n8, v242, t21.OWED)
                    end
                end

                v94 = false

                if not v94 then
                    if not v44 then
                        return
                    end

                    showRung(v44, zoneCount(v44), false)
                end
            end)
        end
    else
        local v252 = v239.done

        if v252 then
            local v253 = v92

            v252 = not ((v253["t" .. p80] or 0) >= 1)
        end

        if v252 and not (zoneCount(p80) < #v238) then
            v94 = true

            local v254 = n5

            task.spawn(function() -- line: 1079
                -- upvalues: p80 (copy), v254 (copy), IndexClaim (copy), v44 (ref), t21 (copy), v92 (ref), v94 (ref), zoneCount (copy), showRung (copy), finishDone (copy)
                local InvokeServer = IndexClaim.InvokeServer
                local ok, result = pcall(InvokeServer, IndexClaim, "Rungs", p80)

                if ok and type(result) == "table" and #result > 0 then
                    v92["t" .. p80] = 1
                    finishDone(p80, v254, t21.OWED)
                end

                v94 = false

                if not v94 then
                    if not v44 then
                        return
                    end

                    showRung(v44, zoneCount(v44), false)
                end
            end)
        end
    end
end

local v256 = Badge.Attach(Button, {
    icon = Button:FindFirstChild("Icon"),
    at = Vector2.new(0.9, 0.1)
})

local function syncButton() -- line: 1115
    -- upvalues: LocalPlayer (copy), v256 (copy)
    v256.Set(LocalPlayer:GetAttribute("IndexNew") or 0)
end

LocalPlayer:GetAttributeChangedSignal("IndexNew"):Connect(syncButton)
syncButton()

local v257 = Badge.Attach(Button, {
    text = "!",
    at = Vector2.new(0.1, 0.1),
    red = t27.red,
    flash = t27.flash
})

local function syncGold() -- line: 1123
    -- upvalues: LocalPlayer (copy), t30 (copy), refreshMarks (copy), v257 (copy)
    table.clear(t30)

    for match in string.gmatch(LocalPlayer:GetAttribute("IndexWorld") or "", "[^,]+") do
        t30[match] = true
    end

    v257.Set(next(t30) and 1 or 0)
    refreshMarks()
end

LocalPlayer:GetAttributeChangedSignal("IndexWorld"):Connect(syncGold)
syncGold()
Loc.Changed:Connect(function() -- line: 1130
    -- upvalues: v44 (ref), v94 (ref), zoneCount (copy), v167 (ref), showRung (copy)
    v167 = nil

    if not v94 then
        if not v44 then
            return
        end

        showRung(v44, zoneCount(v44), false)
    end
end)

local function paintSlot(p81, p82) -- line: 1136
    -- upvalues: v36 (copy), v37 (copy), v41 (ref)
    local v258 = v41[p81]
    local Icon = p82.Icon

    if v258 and (v258.caught or 0) > 0 and v36 then
        Icon.ImageColor3 = v36
    else
        Icon.ImageColor3 = v37
    end
end

local function fitCanvas() -- line: 1141
    -- upvalues: List (copy), UIListLayout (copy), UIPadding (copy), t13 (copy)
    local X = List.AbsoluteWindowSize.X

    if X <= 0 then
        return
    end

    UIListLayout.Padding = UDim.new(0, (List:GetAttribute("SectionGap") or 0.03) * X)
    UIPadding.PaddingTop = UDim.new(0, (List:GetAttribute("EdgeTop") or 0.02) * X)
    UIPadding.PaddingBottom = UDim.new(0, (List:GetAttribute("EdgeBottom") or 0.03) * X)

    local v259 = (List:GetAttribute("RowGap") or 0.025) * X

    for _, v260 in pairs(t13) do
        for _, v261 in ipairs(v260.frames) do
            local UIGridLayout = v261:FindFirstChildOfClass("UIGridLayout")

            if UIGridLayout then
                UIGridLayout.CellPadding = UDim2.new(UIGridLayout.CellPadding.X.Scale, 0, 0, v259)
            end
        end
    end

    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
end

local function buildZone(p83) -- line: 1157
    -- upvalues: ContentProvider (copy), ButtonHover (copy), FishDisplay (copy), RarityDisplay (copy), IndexZones (copy), IndexClaim (copy), IndexSpecial (copy), Templates (copy), List (copy), v36 (copy), v37 (copy), v41 (ref), t13 (copy), v44 (ref), v46 (ref), dressBar (copy), dressSpecial (copy), showCard (copy), v91 (ref), v92 (ref), v93 (ref), t25 (copy), v94 (ref), n5 (ref), t30 (copy), refreshMarks (copy), zoneCount (copy), showRung (copy), finishDone (copy), runOrder (copy), sweep (copy)
    local t42 = {
        frames = {},
        slots = {},
        secret = {}
    }
    local v262 = p83 * 1000
    local t43 = {}
    local v263 = IndexSpecial.BY_ID[p83]

    if v263 then
        for _, v264 in ipairs(v263.sections) do
            t43[#t43 + 1] = {
                special = true,
                key = v264.key,
                title = v264.title,
                species = v264.species,
                look = v264.look
            }
        end
    else
        for _, v265 in ipairs(RarityDisplay.order) do
            local t44 = {}

            for v266, v267 in pairs(IndexZones) do
                local v268 = FishDisplay[v266]

                if v267 == p83 and v268 and v268.rarity == v265 then
                    t44[#t44 + 1] = v266
                end
            end

            table.sort(t44, function(p84, p85) -- line: 1174
                -- upvalues: FishDisplay (copy)
                return FishDisplay[p84].display < FishDisplay[p85].display
            end)
            t43[#t43 + 1] = {
                key = v265,
                title = (RarityDisplay[v265] or {}).display or string.upper(v265),
                species = t44,
                rarity = v265
            }
        end
    end

    for _, v270 in ipairs(t43) do
        local species = v270.species

        if #species > 0 then
            t42.first = t42.first or species[1]

            local v271 = v262 + 1
            local clone = Templates.SectionHeader:Clone()

            clone.Name = v270.key .. "Header"
            clone.LayoutOrder = v271
            clone.Label.Text = v270.title

            if v270.special then
                dressSpecial(clone, clone.Label, v270.key, v270.look)
            else
                dressBar(clone, clone.Label, v270.rarity)
            end

            clone.Visible = false
            clone.Parent = List
            t42.frames[#t42.frames + 1] = clone

            if v270.rarity == "Secret" or v270.special then
                t42.secret[#t42.secret + 1] = clone
            end

            v262 = v271 + 1

            local clone2 = Templates.SectionGrid:Clone()

            clone2.Name = v270.key .. "Grid"
            clone2.LayoutOrder = v262
            clone2.Visible = false
            clone2.Parent = List
            t42.frames[#t42.frames + 1] = clone2

            for v272, v273 in ipairs(species) do
                local clone = Templates.Slot:Clone()

                clone.Name = v273
                clone.LayoutOrder = v272
                clone.Visible = true
                clone.Icon.Image = FishDisplay[v273].icon or ""

                local v274 = v41[v273]

                clone.Icon.ImageColor3 = v274 and (v274.caught or 0) > 0 and v36 or v37
                clone.Parent = clone2
                t42.slots[v273] = clone
                ButtonHover.Attach(clone, {
                    shine = false,
                    tile = 1,
                    corner = 0.2,
                    icon = clone.Icon
                })
                clone.Activated:Connect(function() -- line: 1210
                    -- upvalues: p83 (copy), clone (copy), v273 (copy), ButtonHover (copy), IndexClaim (copy), IndexSpecial (copy), v41 (ref), t13 (copy), v44 (ref), v46 (ref), showCard (copy), v91 (ref), v92 (ref), v93 (ref), t25 (copy), v94 (ref), n5 (ref), t30 (copy), refreshMarks (copy), zoneCount (copy), showRung (copy), finishDone (copy), runOrder (copy), sweep (copy)
                    ButtonHover.Press(clone)
                    showCard(v273)

                    if t30[v273] then
                        t30[v273] = nil
                        refreshMarks()
                        task.spawn(pcall, IndexClaim.InvokeServer, IndexClaim, "WorldSeen", v273)
                    end

                    local v275 = v93

                    if v275 then
                        local v276 = v41[v273]

                        v275 = v276 ~= nil and (v276.caught or 0) > 0 and not v91[v273]
                    end

                    if not v275 or v94 or not v93 then
                        return
                    end

                    v94 = true

                    local v277 = n5

                    task.spawn(function() -- line: 1040
                        -- upvalues: v277 (copy), p83 (copy), v273 (copy), IndexClaim (copy), IndexSpecial (copy), t13 (copy), v44 (ref), v46 (ref), v91 (ref), v92 (ref), t25 (copy), v94 (ref), n5 (ref), refreshMarks (copy), zoneCount (copy), showRung (copy), finishDone (copy), runOrder (copy), sweep (copy)
                        local InvokeServer = IndexClaim.InvokeServer
                        local v278, v279, v280 = pcall(InvokeServer, IndexClaim, "Fish", p83)

                        if v278 and type(v279) == "table" then
                            for _, v281 in ipairs(v279) do
                                v91[v281] = true
                                t25[v281] = true
                            end

                            local v283 = IndexSpecial.BY_ID[p83]
                            local v284 = (if v283 ~= nil and not v283.ladder then "t" else "z") .. p83

                            if type(v280) == "table" and #v280 > 0 then
                                v92[v284] = math.max(v92[v284] or 0, v280[#v280])
                            end

                            if #v279 > 0 and n5 == v277 and v46 and v44 == p83 then
                                sweep(p83, runOrder(t13[p83], v279, v273), v277)

                                local v288 = IndexSpecial.BY_ID[p83]

                                if v288 ~= nil and not v288.ladder and type(v280) == "table" and #v280 > 0 and n5 == v277 then
                                    finishDone(p83, v277)
                                end
                            end
                        end

                        table.clear(t25)
                        v94 = false
                        refreshMarks()

                        if not v94 then
                            if not v44 then
                                return
                            end

                            showRung(v44, zoneCount(v44), false)
                        end
                    end)
                end)
            end
        end
    end

    t13[p83] = t42
    task.spawn(function() -- line: 1221
        -- upvalues: t42 (copy), ContentProvider (copy)
        local t46 = {}

        for _, v289 in pairs(t42.slots) do
            t46[#t46 + 1] = v289.Icon
        end

        local PreloadAsync = ContentProvider.PreloadAsync

        pcall(PreloadAsync, ContentProvider, t46)
    end)

    return t42
end

local t47 = {}
local v290 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v291 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function markTab(p86) -- line: 1233
    -- upvalues: TweenService (copy), IndexSpecial (copy), Tabs (copy), t47 (copy), v290 (copy), v291 (copy)
    for v292, v293 in pairs(t47) do
        local v295 = Tabs:FindFirstChild((if IndexSpecial.BY_ID[v292] then "Tab" else "Zone") .. v292)
        local v296 = UDim2.new(v293.X.Scale, v293.X.Offset, v293.Y.Scale * (if v292 == p86 then 1.2 else 1), v293.Y.Offset)

        if v295.Size ~= v296 then
            TweenService:Create(v295, v292 == p86 and v290 or v291, {
                Size = v296
            }):Play()
        end
    end
end

local t48 = {
    on = Color3.fromRGB(110, 225, 70),
    off = Color3.fromRGB(205, 208, 214),
    time = TweenInfo.new(0.15)
}
local v298
local v299 = islandOf(v1)
local t49 = {}
local t50 = {}
local v300 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v301 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v302 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function setMode(p87, p88) -- line: 1252
    -- upvalues: TweenService (copy), IndexSpecial (copy), Tabs (copy), ModeTabs (copy), Islands (copy), Pop (copy), Row (copy), t1 (copy), t2 (copy), t3 (copy), t48 (copy), v298 (ref), v299 (ref), v300 (copy), v301 (copy), v302 (copy)
    p88 = p88 or v299

    if v298 == p87 and v299 == p88 then
        return
    end

    local v304 = v298 ~= p87

    v298 = p87
    v299 = p88

    local v305 = p87 == "NORMAL"

    for _, v306 in ipairs(t3) do
        local v308 = Tabs:FindFirstChild((if IndexSpecial.BY_ID[v306] then "Tab" else "Zone") .. v306)

        if v308 then
            local v309 = IndexSpecial.BY_ID[v306]
            local v310

            if (v309 and v309.mode or "NORMAL") == p87 then
                v310 = not v305

                if not v310 then
                    v310 = (if type(v306) == "number" and v306 >= 8 and v306 <= 10 then "Jurassic" else "Origins") == p88
                end
            else
                v310 = false
            end

            v308.Visible = v310
        end
    end

    for v311, v312 in pairs(t2) do
        for _, v313 in ipairs(v312) do
            local v314 = Tabs:FindFirstChild(v313)

            if v314 then
                v314.Visible = v305 and v311 == p88
            end
        end
    end

    for _, v315 in ipairs(t1) do
        local v316 = Row:FindFirstChild(v315)

        if v316 then
            TweenService:Create(v316, t48.time, {
                ImageColor3 = v315 == p88 and t48.on or t48.off
            }):Play()
        end
    end

    if v304 then
        local Attribute = Tabs:GetAttribute(if v305 then "NormalY" else "OtherY")

        if Attribute then
            TweenService:Create(Tabs, v302, {
                Position = UDim2.new(Tabs.Position.X.Scale, Tabs.Position.X.Offset, Attribute, 0)
            }):Play()
        end

        if v305 then
            if not Islands.Visible then
                Pop.Scale = 0
            end

            Islands.Visible = true
            TweenService:Create(Pop, v300, {
                Scale = 1
            }):Play()
        elseif Islands.Visible then
            local tween = TweenService:Create(Pop, v301, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 1282
                -- upvalues: Islands (copy), v298 (ref)
                if v298 ~= "NORMAL" then
                    Islands.Visible = false
                end
            end)
            tween:Play()
        end
    end

    for _, v318 in ipairs(IndexSpecial.MODES) do
        local v319 = ModeTabs:FindFirstChild(v318:sub(1, 1) .. v318:sub(2):lower())

        if v319 then
            TweenService:Create(v319, t48.time, {
                ImageColor3 = v318 == p87 and t48.on or t48.off
            }):Play()
        end
    end
end

local function showZone(p89) -- line: 1294
    -- upvalues: IndexSpecial (copy), List (copy), ZoneBar (copy), t13 (copy), v44 (ref), t14 (copy), showCard (copy), v94 (ref), n5 (ref), refreshMarks (copy), zoneCount (copy), showRung (copy), playOwed (copy), fitCanvas (copy), buildZone (copy), markTab (copy), t49 (copy), t50 (copy), setMode (copy)
    if v44 == p89 then
        return
    end

    n5 += 1

    local v320 = IndexSpecial.BY_ID[p89]
    local v321 = (v320 and v320.mode or "NORMAL") == "NORMAL"
    local v322 = IndexSpecial.BY_ID[p89]

    setMode(v322 and v322.mode or "NORMAL", if not v321 then nil elseif type(p89) == "number" and p89 >= 8 and p89 <= 10 then "Jurassic" else "Origins")

    local v324 = IndexSpecial.BY_ID[p89]

    t49[v324 and v324.mode or "NORMAL"] = p89

    if v321 then
        t50[type(p89) == "number" and p89 >= 8 and p89 <= 10 and "Jurassic" or "Origins"] = p89
    end

    local v326 = IndexSpecial.BY_ID[p89]

    ZoneBar.Visible = not v326 or v326.claims
    markTab(p89)

    for v327, v328 in pairs(t13) do
        if v327 ~= p89 then
            for _, v329 in ipairs(v328.frames) do
                v329.Visible = false
            end
        end
    end

    local v330 = t13[p89] or buildZone(p89)

    for _, v331 in ipairs(v330.frames) do
        v331.Visible = true
    end

    v44 = p89
    List.CanvasPosition = Vector2.zero
    fitCanvas()

    local v332 = t14[p89] or v330.first

    if v332 then
        showCard(v332)
    end

    if not v94 and v44 then
        showRung(v44, zoneCount(v44), false)
    end

    refreshMarks()
    playOwed(p89)
end

local function repaint() -- line: 1322
    -- upvalues: v36 (copy), v37 (copy), v41 (ref), t13 (copy), v44 (ref), v45 (ref), showCard (copy), v94 (ref), refreshMarks (copy), zoneCount (copy), showRung (copy), playOwed (copy)
    for _, v333 in pairs(t13) do
        for v334, v335 in pairs(v333.slots) do
            local v336 = v41[v334]

            v335.Icon.ImageColor3 = v336 and (v336.caught or 0) > 0 and v36 or v37
        end
    end

    if v45 then
        showCard(v45)
    end

    refreshMarks()

    if not v94 and v44 then
        showRung(v44, zoneCount(v44), false)
    end

    if v44 then
        playOwed(v44)
    end
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)

local Zones = require(Modules:WaitForChild("Zones"))

Modules = 1

while Tabs:FindFirstChild("Zone" .. Modules) do
    t3[#t3 + 1] = Modules
    Modules += 1
end

for _, v337 in ipairs(IndexSpecial.TABS) do
    if Tabs:FindFirstChild("Tab" .. v337.id) then
        t3[#t3 + 1] = v337.id
    end
end

local Label

for _, v338 in ipairs(t3) do
    local v339 = tabButton(v338)

    t47[v338] = v339.Size
    Label = v339:FindFirstChild("Label")

    local v340 = IndexSpecial.BY_ID[v338]

    if Label then
        if v340 then
            Label.Text = v340.title
        elseif Zones.NAMES[v338] then
            Label.Text = string.upper(Zones.NAMES[v338])
        end
    end

    ButtonHover.Attach(v339, {
        shine = true,
        tile = 1,
        corner = 0.3
    })
    v339.Activated:Connect(function() -- line: 1368
        -- upvalues: ButtonHover (copy), showZone (copy), v338 (copy), v339 (copy)
        ButtonHover.Press(v339)
        showZone(v338)
    end)
end

for _, v341 in ipairs(IndexSpecial.MODES) do
    local v342 = ModeTabs:WaitForChild(v341:sub(1, 1) .. v341:sub(2):lower())

    ButtonHover.Attach(v342, {
        shine = true,
        tile = 1,
        icon = v342:FindFirstChild("Icon")
    })
    v342.Activated:Connect(function() -- line: 1377
        -- upvalues: ButtonHover (copy), IndexSpecial (copy), t3 (copy), t49 (copy), showZone (copy), v341 (copy), v342 (copy)
        ButtonHover.Press(v342)

        local v343 = t49[v341]

        if not v343 then
            for _, v344 in ipairs(t3) do
                local v345 = IndexSpecial.BY_ID[v344]

                if (v345 and v345.mode or "NORMAL") == v341 then
                    v343 = v344
                    break
                end
            end
        end

        if v343 then
            showZone(v343)
        end
    end)
end

for _, v346 in ipairs(t1) do
    local v347 = Row:WaitForChild(v346)

    ButtonHover.Attach(v347, {
        shine = true,
        tile = 1,
        icon = v347:FindFirstChild("Icon")
    })
    Label = v347.Activated
    Label:Connect(function() -- line: 1393
        -- upvalues: ButtonHover (copy), IndexSpecial (copy), t3 (copy), t50 (copy), showZone (copy), v346 (copy), v347 (copy)
        ButtonHover.Press(v347)

        local v348 = t50[v346]

        if not v348 then
            for _, v349 in ipairs(t3) do
                local v350 = IndexSpecial.BY_ID[v349]

                if (v350 and v350.mode or "NORMAL") == "NORMAL" and (if type(v349) == "number" and v349 >= 8 and v349 <= 10 then "Jurassic" else "Origins") == v346 then
                    v348 = v349
                    break
                end
            end
        end

        if v348 then
            showZone(v348)
        end
    end)
end

do
    local t53 = {}

    for i = 1, t9.POOL do
        local clone = Templates.Sparkle:Clone()

        clone.Name = "Sparkle" .. i
        t53[i] = {
            busy = false,
            gui = clone,
            pop = clone:WaitForChild("Pop")
        }
    end

    local v351 = TweenInfo.new(t9.IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v352 = TweenInfo.new(t9.OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v353 = t9.IN + t9.HOLD + t9.OUT

    local function twinkle() -- line: 1416
        -- upvalues: TweenService (copy), t9 (copy), v39 (copy), t13 (copy), v44 (ref), v46 (ref), range (copy), t53 (copy), v351 (copy), v352 (copy), v353 (copy)
        if not (v46 and v44) then
            return
        end

        local v354 = t13[v44] and t13[v44].secret

        if not v354 or #v354 == 0 then
            return
        end

        local v355, v356

        for _, v357 in ipairs(t53) do
            if not v357.busy then
                v355 = v357
                v356 = v357
                break
            end
        end

        if v356 then
            v356.busy = true

            local gui = v356.gui
            local SIZE = t9.SIZE
            local v358 = v39:NextNumber(SIZE[1], SIZE[2])

            gui.Parent = v354[v39:NextInteger(1, #v354)]

            local fromScale = UDim2.fromScale
            local AREA_X = t9.AREA_X

            gui.Position = fromScale(v39:NextNumber(AREA_X[1], AREA_X[2]), range(t9.AREA_Y))
            gui.Size = UDim2.fromScale(v358, v358)
            gui.Rotation = v39:NextNumber(0, 90)
            gui.ImageTransparency = 0
            v356.pop.Scale = 0
            gui.Visible = true

            local v359 = (if v39:NextInteger(0, 1) == 0 then -1 else 1) * t9.SPIN

            TweenService:Create(gui, TweenInfo.new(v353, Enum.EasingStyle.Linear), {
                Rotation = gui.Rotation + v359
            }):Play()
            TweenService:Create(v356.pop, v351, {
                Scale = 1
            }):Play()
            task.delay(t9.IN + t9.HOLD, function() -- line: 1438
                -- upvalues: v355 (ref), gui (copy), TweenService (copy), v352 (copy)
                TweenService:Create(gui, v352, {
                    ImageTransparency = 1
                }):Play()

                local tween = TweenService:Create(v355.pop, v352, {
                    Scale = 0.4
                })

                tween.Completed:Once(function() -- line: 1441
                    -- upvalues: v355 (ref), gui (copy)
                    gui.Visible = false
                    v355.busy = false
                end)
                tween:Play()
            end)
        end
    end

    task.spawn(function() -- line: 1449
        -- upvalues: t9 (copy), range (copy), twinkle (copy)
        while true do
            task.wait(range(t9.EVERY))
            twinkle()
        end
    end)
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local close

local function open() -- line: 1473
    -- upvalues: TweenService (copy), IndexRecords (copy), Panel (copy), Scale (copy), tabButton (copy), Close (copy), Side (copy), Scale2 (copy), PanelFocus (copy), v41 (ref), v42 (ref), v43 (ref), t13 (copy), v44 (ref), v46 (ref), v47 (ref), t14 (copy), showCard (copy), v91 (ref), v92 (ref), v93 (ref), v94 (ref), refreshMarks (copy), zoneCount (copy), showRung (copy), showZone (copy), repaint (copy), PadMenu (copy), close (ref), v1 (copy)
    if v47 or v46 then
        return
    end

    v47 = true
    v46 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    task.spawn(function() -- line: 1458
        -- upvalues: IndexRecords (copy), v41 (ref), v42 (ref), v43 (ref), v91 (ref), v92 (ref), v93 (ref), v94 (ref), repaint (copy)
        local InvokeServer = IndexRecords.InvokeServer
        local v360, v361, v362, v363, v364, v365 = pcall(InvokeServer, IndexRecords)

        if not v360 then
            return
        end

        if type(v361) == "table" then
            v42 = v361
        end

        if type(v365) == "table" then
            v43 = v365
        end

        if type(v362) == "table" then
            v41 = v362
        end

        if type(v363) == "table" and not v94 then
            v91 = v363

            local v366 = type(v364) == "table" and v364 or {}

            v92 = v366
            v93 = true
        end

        repaint()
    end)
    PanelFocus.MakeWay(function() -- line: 1479
        -- upvalues: v46 (ref)
        return v46
    end)
    showZone(v44 or v1)

    local v367 = t14[v44]

    v367 = v367 or t13[v44] and t13[v44].first

    if v367 then
        showCard(v367)
    end

    if not v94 and v44 then
        showRung(v44, zoneCount(v44), false)
    end

    refreshMarks()
    Side.Rotation = 0
    Scale2.Scale = 1
    Side.Visible = true
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    PanelFocus.Focus(true)

    local tween = TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 1493
        -- upvalues: v47 (ref)
        v47 = false
    end)
    tween:Play()
    PadMenu.Open(Panel, function() -- line: 1495
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close,
        first = function() -- first | line: 1496
            -- upvalues: tabButton (copy), v44 (ref), v1 (copy)
            return tabButton(v44 or v1)
        end
    })
end

local function close2() -- line: 1499
    -- upvalues: TweenService (copy), Owners (copy), Panel (copy), Scale (copy), PanelFocus (copy), v46 (ref), v47 (ref), n5 (ref), refreshMarks (copy), PadMenu (copy)
    if v47 or not v46 then
        return
    end

    v47 = true
    v46 = false
    n5 += 1
    refreshMarks()
    Owners.Reset()
    PadMenu.Close(Panel)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 1510
        -- upvalues: Panel (copy), PanelFocus (copy), v47 (ref)
        Panel.Visible = false
        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 1513
            -- upvalues: v47 (ref)
            v47 = false
        end)
    end)
    tween:Play()
end

close = close2
Button.Activated:Connect(open)
Close.Activated:Connect(close2)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 1525
    -- upvalues: Panel (copy), PanelFocus (copy), v46 (ref), v47 (ref), n5 (ref), refreshMarks (copy), PadMenu (copy)
    if not v46 then
        return
    end

    v46 = false
    v47 = false
    n5 += 1
    refreshMarks()
    PadMenu.Close(Panel)
    PanelFocus.Focus(false, true)
    Panel.Visible = false
    PanelFocus.GiveBackRight()
end)
IndexState.OnClientEvent:Connect(function(p90, p91, p92, p93) -- line: 1538
    -- upvalues: v41 (ref), v91 (ref), v92 (ref), v93 (ref), v94 (ref), repaint (copy)
    if type(p90) ~= "table" then
        return
    end

    if p91 then
        v41 = p90

        if type(p92) == "table" and not v94 then
            v91 = p92

            local v369 = type(p93) == "table" and p93 or {}

            v92 = v369
            v93 = true
        end
    else
        for v370, v371 in pairs(p90) do
            v41[v370] = v371
        end
    end

    repaint()
end)

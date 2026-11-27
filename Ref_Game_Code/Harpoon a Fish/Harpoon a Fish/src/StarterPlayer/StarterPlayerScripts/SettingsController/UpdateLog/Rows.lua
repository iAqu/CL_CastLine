-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local t2 = {
    TITLE_W = 0.9,
    TITLE_AR = 10,
    NEW_W = 0.24,
    NEW_AR = 5,
    NEW = Color3.fromRGB(255, 62, 84),
    NEW_TOP = Color3.fromRGB(255, 120, 135),
    NEW_EDGE = Color3.fromRGB(120, 10, 30),
    DATE_W = 0.45,
    DATE_AR = 14,
    FEEDBACK = "WE APPRECIATE AND READ ALL FEEDBACK",
    FEEDBACK_ICON = "rbxassetid://136955683015884",
    FEEDBACK_W = 0.9,
    FEEDBACK_AR = 16,
    FEEDBACK_TEXT = 0.62,
    FEEDBACK_ICON_H = 1.5,
    TEXT = 0.044,
    CARD_W = 0.97,
    CARD = Color3.fromRGB(255, 255, 255),
    CARD_FADE = 0.06,
    CARD_PAD = 0.9,
    CARD_GAP = 0.75,
    CARD_CORNER = 0.7,
    PILL_H = 1.5,
    DOT = 0.32,
    TEXT_X = 0.03,
    INK = Color3.fromRGB(32, 62, 102),
    SOFT = Color3.fromRGB(84, 106, 138),
    MUT_FONT = "rbxasset://fonts/families/GothamSSm.json",
    MUT_EDGE = 0.15,
    SECTIONS = {
        NEW = {
            word = "NEW",
            w = 6,
            color = Color3.fromRGB(70, 200, 95),
            edge = Color3.fromRGB(16, 80, 30)
        },
        HALLOWEEN = {
            word = "HALLOWEEN",
            w = 8,
            color = Color3.fromRGB(255, 140, 40),
            edge = Color3.fromRGB(110, 45, 0)
        },
        COSMIC = {
            word = "COSMIC ZONE",
            w = 9.5,
            color = Color3.fromRGB(255, 105, 200),
            edge = Color3.fromRGB(120, 20, 85)
        },
        CELESTIAL = {
            word = "CELESTIAL",
            w = 8.5,
            color = Color3.fromRGB(255, 224, 138),
            edge = Color3.fromRGB(120, 85, 10)
        },
        ACHIEVEMENTS = {
            word = "ACHIEVEMENTS",
            w = 10.5,
            color = Color3.fromRGB(255, 185, 20),
            edge = Color3.fromRGB(110, 65, 0)
        },
        TITANS = {
            word = "TITANS",
            w = 6.5,
            color = Color3.fromRGB(36, 86, 214),
            edge = Color3.fromRGB(10, 25, 80)
        },
        JURASSIC = {
            word = "JURASSIC",
            w = 7.5,
            color = Color3.fromRGB(95, 185, 60),
            edge = Color3.fromRGB(25, 70, 15)
        },
        WEATHERS = {
            word = "WEATHERS",
            w = 8,
            color = Color3.fromRGB(90, 200, 255),
            edge = Color3.fromRGB(10, 60, 110)
        },
        EXTINCTION = {
            word = "EXTINCTION",
            w = 9,
            color = Color3.fromRGB(92, 98, 110),
            edge = Color3.fromRGB(14, 14, 18)
        },
        BLACKMARKET = {
            word = "BLACK MARKET",
            w = 10.5,
            color = Color3.fromRGB(196, 150, 60),
            edge = Color3.fromRGB(70, 45, 10)
        },
        THANKSGIVING = {
            word = "THANKSGIVING",
            w = 10.5,
            color = Color3.fromRGB(230, 130, 45),
            edge = Color3.fromRGB(100, 45, 10)
        },
        CHANGES = {
            word = "CHANGES",
            w = 6.5,
            color = Color3.fromRGB(60, 150, 255),
            edge = Color3.fromRGB(12, 50, 110)
        },
        FIXES = {
            word = "FIXES",
            w = 6,
            color = Color3.fromRGB(235, 75, 75),
            edge = Color3.fromRGB(105, 15, 15)
        }
    },
    TAB_W = 0.94,
    TAB_AR = 2.5,
    TAB_TITLE = 0.22,
    TAB_DATE = 0.15,
    TAB_GAP = 0.1,
    TAB = Color3.fromRGB(255, 255, 255),
    TAB_ON = Color3.fromRGB(226, 241, 255),
    TAB_EDGE = Color3.fromRGB(164, 205, 238),
    TAB_EDGE_ON = Color3.fromRGB(60, 150, 255),
    TAB_STROKE = 0.025,
    TAB_STROKE_ON = 0.05
}
local t1 = {}

t1.LOOK = t2

local v1 = Font.new("rbxasset://fonts/families/FredokaOne.json")

local function aspect(p1, p2) -- line: 75
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = p2
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
    UIAspectRatioConstraint.Parent = p1

    return UIAspectRatioConstraint
end

local function corner(p3, p4) -- line: 82
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(p4, 0)
    UICorner.Parent = p3

    return UICorner
end

local function blank(p5, p6, p7) -- line: 88
    local Frame = Instance.new("Frame")

    Frame.Name = p5
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(p6, 0)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = p7
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
    UIAspectRatioConstraint.Parent = Frame

    return Frame
end

local function word(p8, p9, p10, p11) -- line: 96
    -- upvalues: v1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = v1
    TextLabel.AutoLocalize = false
    TextLabel.Text = p9
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextScaled = true
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = p11
    TextLabel.ZIndex = p8.ZIndex + 1
    TextLabel.Parent = p8

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p10
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.Thickness = 0.1
    UIStroke.Parent = TextLabel

    return TextLabel
end

local function colourText(p12, p13, p14) -- line: 118
    -- upvalues: RarityStyle (copy)
    local clone = p12:Clone()

    clone.Visible = true
    clone.AutoLocalize = false
    clone.Text = p13
    clone.TextXAlignment = Enum.TextXAlignment.Center

    local UIAspectRatioConstraint = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Destroy()
    end

    local UIGradient = clone:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Name = "Grad"

        if p14 then
            UIGradient.Rotation = 0
        end
    end

    if p14 then
        RarityStyle.Apply(clone, p14)
    end

    return clone
end

local function plain(p15, p16) -- line: 134
    local clone = p15:Clone()

    clone.Visible = true
    clone.AutoLocalize = false
    clone.Text = p16

    local UIAspectRatioConstraint = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Destroy()
    end

    return clone
end

local function hex(p17) -- line: 143
    return ("#%02X%02X%02X"):format(math.floor(p17.R * 255 + 0.5), math.floor(p17.G * 255 + 0.5), (math.floor(p17.B * 255 + 0.5)))
end

local function rich(p18) -- line: 146
    return (tostring(p18):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function sectionsOf(p19) -- line: 150
    if p19.sections then
        return p19.sections
    end

    if p19.features and #p19.features > 0 then
        local t3 = {}

        for _, v7 in ipairs(p19.features) do
            t3[#t3 + 1] = {
                name = v7.title,
                text = v7.text
            }
        end

        return {
            {
                kind = "NEW",
                rows = t3
            }
        }
    end

    return {}
end

local function translated(p20, p21) -- line: 166
    local v8 = p21(p20)

    if v8 ~= p20 or not p20:find("\n") then
        return v8
    end

    local t4 = {}

    for match in (p20 .. "\n"):gmatch("(.-)\n") do
        t4[#t4 + 1] = p21(match)
    end

    return table.concat(t4, "\n")
end

local function lineText(p22, p23, p24) -- line: 173
    -- upvalues: MutationDisplay (copy), t2 (copy), translated (copy)
    local INK = t2.INK
    local v19 = ("<font color=\"%s\">%s</font>"):format(("#%02X%02X%02X"):format(math.floor(INK.R * 255 + 0.5), math.floor(INK.G * 255 + 0.5), (math.floor(INK.B * 255 + 0.5))), (tostring((p23(p22.name))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))) .. (if p22.text then "\n" .. tostring((translated(p22.text, p23))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") or "" else "")

    for _, v20 in ipairs(p22.mutations or {}) do
        local v21 = MutationDisplay[v20]

        if v21 then
            local v24 = math.max(1, (math.floor(p24 * t2.MUT_EDGE + 0.5)))
            local v25 = "%f[%w]" .. v21.display .. "%f[%W]"
            local MUT_FONT = t2.MUT_FONT
            local v26 = v21.textColor or v21.color

            v19 = v19:gsub(v25, ("<font family=\"%s\" weight=\"bold\" color=\"%s\"><stroke color=\"#000000\" thickness=\"%d\" joins=\"round\">%s</stroke></font>"):format(MUT_FONT, ("#%02X%02X%02X"):format(math.floor(v26.R * 255 + 0.5), math.floor(v26.G * 255 + 0.5), (math.floor(v26.B * 255 + 0.5))), v24, v21.display))
        end
    end

    return v19
end

local function titleColourOf(p25) -- line: 186
    -- upvalues: RarityDisplay (copy)
    local v32 = p25.rarity and RarityDisplay[p25.rarity]

    return v32 and v32.color or p25.color
end

function t1.Build(p26, p27, p28, p29, p30, p31) -- line: 193
    -- upvalues: RarityDisplay (copy), t2 (copy), v1 (copy), word (copy), colourText (copy), sectionsOf (copy), lineText (copy)
    local t5 = {}
    local t6 = {}
    local t7 = {}
    local t8 = {}
    local t9 = {}
    local t10
    local n1 = 1
    local v33
    local UIListLayout = p27:FindFirstChildOfClass("UIListLayout")
    local UIPadding = p27:FindFirstChildOfClass("UIPadding")

    local function remake() -- line: 201
        -- upvalues: t5 (copy), t6 (copy), t7 (copy)
        table.clear(t5)

        for _, v34 in ipairs(t6) do
            t5[#t5 + 1] = v34.gui
        end

        for _, v35 in ipairs(t7) do
            t5[#t5 + 1] = v35
        end
    end

    local n2 = 0

    local function note(p32) -- line: 207
        -- upvalues: p26 (copy), t7 (copy), n2 (ref)
        n2 += 1
        p32.LayoutOrder = n2
        p32.Parent = p26
        t7[#t7 + 1] = p32

        return p32
    end

    local function card(p33) -- line: 216
        -- upvalues: p31 (copy), t8 (copy), t9 (copy), t2 (copy), v1 (copy), word (copy), lineText (copy)
        local v36 = t2.SECTIONS[p33.kind] or t2.SECTIONS.NEW
        local Frame = Instance.new("Frame")

        Frame.Name = "Card"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = t2.CARD
        Frame.BackgroundTransparency = t2.CARD_FADE
        Frame.Size = UDim2.fromScale(t2.CARD_W, 0)
        Frame.AutomaticSize = Enum.AutomaticSize.Y
        Frame.ZIndex = 5

        local t11 = {}
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 0)
        UICorner.Parent = Frame
        t11.corner = UICorner
        t11.pad = Instance.new("UIPadding")
        t11.layout = Instance.new("UIListLayout")
        t11.pad.Parent = Frame
        t11.layout.SortOrder = Enum.SortOrder.LayoutOrder
        t11.layout.Parent = Frame
        t8[#t8 + 1] = t11

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Pill"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v36.color
        Frame2.LayoutOrder = 0
        Frame2.ZIndex = 6
        Frame2.Parent = Frame

        local w = v36.w

        t11.pill = Frame2
        t11.pillW = w

        local UICorner2 = Instance.new("UICorner")

        UICorner2.CornerRadius = UDim.new(0.5, 0)
        UICorner2.Parent = Frame2
        word(Frame2, p31(v36.word), v36.edge, UDim2.fromScale(0.8, 0.68))

        for v37, v38 in ipairs(p33.rows or {}) do
            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Line" .. v37
            Frame2.BackgroundTransparency = 1
            Frame2.Size = UDim2.fromScale(1, 0)
            Frame2.AutomaticSize = Enum.AutomaticSize.Y
            Frame2.LayoutOrder = v37
            Frame2.ZIndex = 6
            Frame2.Parent = Frame

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "Dot"
            Frame3.BorderSizePixel = 0
            Frame3.BackgroundColor3 = v36.color
            Frame3.AnchorPoint = Vector2.new(0, 0.5)
            Frame3.ZIndex = 7
            Frame3.Parent = Frame2

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = Frame3

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Words"
            TextLabel.BackgroundTransparency = 1
            TextLabel.FontFace = v1
            TextLabel.AutoLocalize = false
            TextLabel.RichText = true
            TextLabel.Text = lineText(v38, p31, 14)
            TextLabel.TextColor3 = t2.SOFT
            TextLabel.TextWrapped = true
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel.Position = UDim2.fromScale(t2.TEXT_X, 0)
            TextLabel.Size = UDim2.fromScale(1 - t2.TEXT_X, 0)
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y
            TextLabel.ZIndex = 7
            TextLabel.Parent = Frame2
            t9[#t9 + 1] = {
                words = TextLabel,
                dot = Frame3,
                item = v38.mutations and v38 or nil
            }
        end

        return Frame
    end

    local v40 = table.clone(p30)

    table.sort(v40, function(p34, p35) -- line: 281
        return p34.id > p35.id
    end)

    local id = nil

    local function show(p36) -- line: 283
        -- upvalues: p26 (copy), p28 (copy), p29 (copy), p31 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (ref), n1 (ref), v33 (ref), remake (copy), n2 (ref), card (copy), v40 (copy), id (ref), RarityDisplay (copy), t2 (copy), word (copy), colourText (copy), sectionsOf (copy)
        for _, v41 in ipairs(t7) do
            v41:Destroy()
        end

        table.clear(t7)
        table.clear(t8)
        table.clear(t9)
        n2 = 0
        id = p36.id

        if p36 == v40[1] and p36.popup ~= false then
            local NEW_W, NEW_AR = t2.NEW_W, t2.NEW_AR
            local Frame = Instance.new("Frame")

            Frame.Name = "New"
            Frame.BackgroundTransparency = 1
            Frame.Size = UDim2.fromScale(NEW_W, 0)

            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

            UIAspectRatioConstraint.AspectRatio = NEW_AR
            UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
            UIAspectRatioConstraint.Parent = Frame
            n2 += 1
            Frame.LayoutOrder = n2
            Frame.Parent = p26
            t7[#t7 + 1] = Frame
            Frame.BackgroundTransparency = 0
            Frame.BackgroundColor3 = Color3.new(1, 1, 1)
            Frame.BorderSizePixel = 0

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = 90
            UIGradient.Color = ColorSequence.new(t2.NEW_TOP, t2.NEW)
            UIGradient.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = t2.NEW_EDGE
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            UIStroke.Thickness = 0.07
            UIStroke.Parent = Frame
            word(Frame, p31("NEW UPDATE"), t2.NEW_EDGE, UDim2.fromScale(0.82, 0.66))
        end

        local v42 = p31(p36.title)
        local v43 = p36.rarity and RarityDisplay[p36.rarity]
        local v44 = colourText(p28, v42, v43 and v43.color or p36.color)

        v44.Name = "Title"
        v44.Size = UDim2.fromScale(t2.TITLE_W, 0)

        local TITLE_AR = t2.TITLE_AR
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = TITLE_AR
        UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
        UIAspectRatioConstraint.Parent = v44
        n2 += 1
        v44.LayoutOrder = n2
        v44.Parent = p26
        t7[#t7 + 1] = v44

        if p36.date then
            local v45 = p31(p36.date)
            local clone = p29:Clone()

            clone.Visible = true
            clone.AutoLocalize = false
            clone.Text = v45

            local UIAspectRatioConstraint = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

            if UIAspectRatioConstraint then
                UIAspectRatioConstraint:Destroy()
            end

            clone.Name = "Date"
            clone.TextXAlignment = Enum.TextXAlignment.Center
            clone.Size = UDim2.fromScale(t2.DATE_W, 0)

            local DATE_AR = t2.DATE_AR
            local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

            UIAspectRatioConstraint2.AspectRatio = DATE_AR
            UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize
            UIAspectRatioConstraint2.Parent = clone
            n2 += 1
            clone.LayoutOrder = n2
            clone.Parent = p26
            t7[#t7 + 1] = clone
        end

        local FEEDBACK_W, FEEDBACK_AR = t2.FEEDBACK_W, t2.FEEDBACK_AR
        local Frame = Instance.new("Frame")

        Frame.Name = "Feedback"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(FEEDBACK_W, 0)

        local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint2.AspectRatio = FEEDBACK_AR
        UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize
        UIAspectRatioConstraint2.Parent = Frame
        n2 += 1
        Frame.LayoutOrder = n2
        Frame.Parent = p26
        t7[#t7 + 1] = Frame

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0.015, 0)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = t2.FEEDBACK_ICON
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(1, t2.FEEDBACK_ICON_H)
        ImageLabel.LayoutOrder = 2
        ImageLabel.ZIndex = 6
        ImageLabel.Parent = Frame

        local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint3.AspectRatio = 1
        UIAspectRatioConstraint3.AspectType = Enum.AspectType.ScaleWithParentSize
        UIAspectRatioConstraint3.Parent = ImageLabel
        UIAspectRatioConstraint3.DominantAxis = Enum.DominantAxis.Height
        UIAspectRatioConstraint3.AspectType = Enum.AspectType.FitWithinMaxSize

        local v46 = p31(t2.FEEDBACK)
        local clone = p29:Clone()

        clone.Visible = true
        clone.AutoLocalize = false
        clone.Text = v46

        local UIAspectRatioConstraint4 = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

        if UIAspectRatioConstraint4 then
            UIAspectRatioConstraint4:Destroy()
        end

        clone.Name = "Words"
        clone.TextScaled = false
        clone.TextWrapped = false
        clone.Size = UDim2.fromScale(0, 1)
        clone.AutomaticSize = Enum.AutomaticSize.X
        clone.LayoutOrder = 1
        clone.ZIndex = 6
        clone.Parent = Frame
        t10 = {
            row = Frame,
            words = clone
        }

        for _, v47 in ipairs((sectionsOf(p36))) do
            local v48 = card(v47)

            n2 += 1
            v48.LayoutOrder = n2
            v48.Parent = p26
            t7[#t7 + 1] = v48
        end

        for _, v49 in ipairs(t6) do
            local v50 = v49.id == id

            v49.gui.BackgroundColor3 = v50 and t2.TAB_ON or t2.TAB
            v49.edge.Color = v50 and t2.TAB_EDGE_ON or t2.TAB_EDGE
            v49.edge.Thickness = v50 and t2.TAB_STROKE_ON or t2.TAB_STROKE
            v49.gui:SetAttribute("Shown", v50)
        end

        remake()
        p26.CanvasPosition = Vector2.zero

        if v33 then
            task.defer(v33, n1)
        end
    end

    for v51, v52 in ipairs(v40) do
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Tab"
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BorderSizePixel = 0
        TextButton.BackgroundColor3 = t2.TAB
        TextButton.Size = UDim2.fromScale(t2.TAB_W, 0)
        TextButton.LayoutOrder = v51
        TextButton.ZIndex = 5

        local TAB_AR = t2.TAB_AR
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = TAB_AR
        UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
        UIAspectRatioConstraint.Parent = TextButton

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.18, 0)
        UICorner.Parent = TextButton

        local UIStroke = Instance.new("UIStroke")

        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        UIStroke.Color = t2.TAB_EDGE
        UIStroke.Thickness = t2.TAB_STROKE
        UIStroke.Parent = TextButton

        local v53 = p31(v52.tab or v52.title)
        local v54 = v52.rarity and RarityDisplay[v52.rarity]
        local v55 = colourText(p28, v53, v54 and v54.color or v52.color)

        v55.Name = "Title"
        v55.TextScaled = false
        v55.TextWrapped = true
        v55.TextXAlignment = Enum.TextXAlignment.Left
        v55.TextYAlignment = Enum.TextYAlignment.Center
        v55.Position = UDim2.fromScale(0.07, 0.08)
        v55.Size = UDim2.fromScale(0.86, 0.54)
        v55.ZIndex = 6
        v55.Parent = TextButton

        local v56, v57

        if v52.tab3 then
            v55.Position = UDim2.fromScale(0.07, 0.05)
            v55.Size = UDim2.fromScale(0.86, 0.19)
            v55.TextWrapped = false
            v56 = colourText(p28, p31(v52.tab2 or ""), v52.tab2Color)
            v57 = colourText(p28, p31(v52.tab3), v52.tab3Color)

            for v58, v59 in ipairs({ v56, v57 }) do
                v59.Name = "Title" .. v58 + 1
                v59.TextScaled = false
                v59.TextXAlignment = Enum.TextXAlignment.Left
                v59.TextYAlignment = Enum.TextYAlignment.Center
                v59.Position = UDim2.fromScale(0.07, 0.05 + 0.19 * v58)
                v59.Size = UDim2.fromScale(0.86, 0.19)
                v59.ZIndex = 6
                v59.Parent = TextButton
            end
        elseif v52.tab2 then
            v55.Size = UDim2.fromScale(0.86, 0.27)
            v55.TextWrapped = false
            v56 = colourText(p28, p31(v52.tab2), v52.tab2Color)
            v56.Name = "Title2"
            v56.TextScaled = false
            v56.TextXAlignment = Enum.TextXAlignment.Left
            v56.TextYAlignment = Enum.TextYAlignment.Center
            v56.Position = UDim2.fromScale(0.07, 0.35)
            v56.Size = UDim2.fromScale(0.86, 0.27)
            v56.ZIndex = 6
            v56.Parent = TextButton
        end

        local v60 = p31(v52.date or "")
        local clone = p29:Clone()

        clone.Visible = true
        clone.AutoLocalize = false
        clone.Text = v60

        local UIAspectRatioConstraint2 = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

        if UIAspectRatioConstraint2 then
            UIAspectRatioConstraint2:Destroy()
        end

        clone.Name = "Date"
        clone.TextScaled = false
        clone.TextXAlignment = Enum.TextXAlignment.Left
        clone.Position = UDim2.fromScale(0.07, 0.66)
        clone.Size = UDim2.fromScale(0.6, 0.22)
        clone.ZIndex = 6
        clone.Parent = TextButton

        if v51 == 1 and v52.popup ~= false then
            local Frame = Instance.new("Frame")

            Frame.Name = "New"
            Frame.BackgroundTransparency = 1
            Frame.Size = UDim2.fromScale(0.25, 0)

            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

            UIAspectRatioConstraint.AspectRatio = 2.6
            UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
            UIAspectRatioConstraint.Parent = Frame
            Frame.AnchorPoint = Vector2.new(1, 0.5)
            Frame.Position = UDim2.fromScale(0.94, 0.77)
            Frame.BackgroundTransparency = 0
            Frame.BackgroundColor3 = t2.NEW
            Frame.ZIndex = 6
            Frame.Parent = TextButton

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = Frame
            word(Frame, p31("NEW"), t2.NEW_EDGE, UDim2.fromScale(0.78, 0.7))
        end

        TextButton.Parent = p27
        t6[#t6 + 1] = {
            gui = TextButton,
            edge = UIStroke,
            title = v55,
            title2 = v56,
            title3 = v57,
            date = clone,
            id = v52.id
        }
        TextButton.Activated:Connect(function() -- line: 448
            -- upvalues: id (ref), show (copy), v52 (copy)
            if id ~= v52.id then
                show(v52)
            end
        end)
    end

    if v40[1] then
        show(v40[1])
    end

    v33 = function(p37) -- line: 455
        -- upvalues: p26 (copy), p31 (copy), t6 (copy), t8 (copy), t9 (copy), t10 (ref), n1 (ref), UIListLayout (copy), UIPadding (copy), t2 (copy), lineText (copy)
        local v62 = math.max(p37 or n1, 0.05)

        n1 = v62

        local v65 = math.max(1, (math.floor(p26.AbsoluteWindowSize.Y / v62 * t2.TEXT)))

        if t10 then
            t10.words.TextSize = math.max(1, (math.floor(t10.row.AbsoluteSize.Y / v62 * t2.FEEDBACK_TEXT)))
        end

        for _, v68 in ipairs(t8) do
            local v70 = math.floor(v65 * t2.CARD_PAD)
            local pad, pad2 = v68.pad, v68.pad
            local v71 = UDim.new(0, v70)
            local v72 = UDim.new(0, v70)

            pad.PaddingTop = v71
            pad2.PaddingBottom = v72

            local pad3, pad4 = v68.pad, v68.pad
            local v73 = UDim.new(0, v70)
            local v74 = UDim.new(0, v70)

            pad3.PaddingLeft = v73
            pad4.PaddingRight = v74
            v68.layout.Padding = UDim.new(0, (math.floor(v65 * t2.CARD_GAP)))
            v68.corner.CornerRadius = UDim.new(0, (math.floor(v65 * t2.CARD_CORNER)))
            v68.pill.Size = UDim2.fromOffset(math.floor(v65 * v68.pillW), (math.floor(v65 * t2.PILL_H)))
        end

        for _, v80 in ipairs(t9) do
            v80.words.TextSize = v65

            if v80.item then
                v80.words.Text = lineText(v80.item, p31, v65)
            end

            local v83 = math.max(2, (math.floor(v65 * t2.DOT)))

            v80.dot.Size = UDim2.fromOffset(v83, v83)
            v80.dot.Position = UDim2.new(0, 0, 0, (math.floor(v65 * 0.55)))
        end

        local n3 = 0

        for _, v85 in ipairs(t6) do
            n3 = v85.gui.AbsoluteSize.Y / v62
            v85.title.TextSize = math.max(1, (math.floor(n3 * t2.TAB_TITLE)))

            if v85.title3 then
                v85.title.TextSize = math.max(1, (math.floor(n3 * t2.TAB_TITLE * 0.78)))
            end

            if v85.title2 then
                v85.title2.TextSize = v85.title.TextSize
            end

            if v85.title3 then
                v85.title3.TextSize = v85.title.TextSize
            end

            v85.date.TextSize = math.max(1, (math.floor(n3 * t2.TAB_DATE)))
        end

        if UIListLayout then
            UIListLayout.Padding = UDim.new(0, (math.floor(n3 * t2.TAB_GAP)))
        end

        if not UIPadding then
            return
        end

        local v94 = math.floor(n3 * 0.06)
        local v95 = UDim.new(0, v94)
        local v96 = UDim.new(0, v94)

        UIPadding.PaddingTop = v95
        UIPadding.PaddingBottom = v96
    end

    v33()

    return t5, v33
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Panel = PlayerGui:WaitForChild("CratesGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local Close = Main:WaitForChild("Close")
local List = Main:WaitForChild("List")
local Detail = Main:WaitForChild("Detail")
local Scale2 = Detail:WaitForChild("Scale")
local Scale3 = List:WaitForChild("Scale")
local Back = Detail:WaitForChild("Back")
local CrateIcon = Detail:WaitForChild("CrateIcon")
local CrateName = Detail:WaitForChild("CrateName")
local Button = PlayerGui:WaitForChild("MenuButtons"):WaitForChild("CrateSlot"):WaitForChild("Button")
local KeyConfig = require(Modules:WaitForChild("KeyConfig"))
local CrateConfig = require(Modules:WaitForChild("CrateConfig"))
local HarpoonView = require(Modules:WaitForChild("HarpoonView"))
local Loc = require(Modules:WaitForChild("Loc"))
local KeysBar = Main:WaitForChild("KeysBar")
local v1

for v2, v3 in ipairs(KeyConfig.ORDER) do
    local Count = KeysBar:WaitForChild("Key" .. v2):WaitForChild("Count")
    local v4 = KeyConfig.Attr(v3)

    local function show() -- line: 62
        -- upvalues: LocalPlayer (copy), Count (copy), v4 (copy)
        Count.Text = "x" .. tostring(LocalPlayer:GetAttribute(v4) or 0)
    end

    LocalPlayer:GetAttributeChangedSignal(v4):Connect(show)
    v1 = LocalPlayer:GetAttribute(v4) or 0
    Count.Text = "x" .. tostring(v1)
end

local TextService = game:GetService("TextService")

local function layoutUse(p1) -- line: 72
    -- upvalues: TextService (copy)
    local Label = p1:FindFirstChild("Label")
    local Key = p1:FindFirstChild("Key")

    if Label and Key then
        task.spawn(function() -- line: 75
            -- upvalues: p1 (copy), Label (copy), Key (copy), TextService (copy)
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

            GetTextBoundsParams.Text = Label.Text
            GetTextBoundsParams.Font = Label.FontFace
            GetTextBoundsParams.Size = 100
            GetTextBoundsParams.Width = 1E+05

            local GetTextBoundsAsync = TextService.GetTextBoundsAsync
            local ok, result = pcall(GetTextBoundsAsync, TextService, GetTextBoundsParams)
            local v6

            if not ok or result.Y <= 0 then
                return
            else
                local UIAspectRatioConstraint = p1:FindFirstChildOfClass("UIAspectRatioConstraint")

                v6 = UIAspectRatioConstraint and UIAspectRatioConstraint.AspectRatio or 3.4
            end

            local v8 = result.X / result.Y * Label.Size.Y.Scale / v6
            local Scale = Key.Size.X.Scale
            local v9 = (1 - (v8 + 0.04 + Scale)) / 2

            Label.Size = UDim2.fromScale(v8 * 1.04, Label.Size.Y.Scale)
            Label.Position = UDim2.fromScale(v9, 0.5)
            Key.Position = UDim2.fromScale(v9 + v8 + 0.04, 0.5)
        end)
    end
end

local _ = {
    CARD_FIRST = 0.1,
    CARD_STEP = 0.045,
    CARD_POP = 0.3,
    SLOT_FIRST = 0.12,
    SLOT_STEP = 0.035,
    SLOT_POP = 0.26,
    SLOT_HOVER = 1.06,
    HIGHLIGHT_FADE = 0.8
}

local function hoverOpts(p2, p3) -- line: 107
    local t1 = {
        shine = false,
        tile = 1,
        highlight = true,
        highlightFade = 0.8,
        highlightCorner = p2:GetAttribute("Corner") or 0.2,
        corner = p2:GetAttribute("Corner") or 0.2
    }

    for v10, v11 in pairs(p3 or {}) do
        t1[v10] = v11
    end

    return t1
end

local t2 = {}
local t3 = {}

for _, child in ipairs(List:GetChildren()) do
    if child:IsA("Frame") then
        t2[#t2 + 1] = child
    end
end

table.sort(t2, function(p4, p5) -- line: 117
    return p4.Position.X.Scale < p5.Position.X.Scale
end)

local v12 = List:GetAttribute("ScrollBarFrac") or 0.0175

local function fitBar() -- line: 124
    -- upvalues: List (copy), v12 (copy)
    List.ScrollBarThickness = math.max(2, (math.round(v12 * List.AbsoluteSize.Y)))
end

List:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBar)
List.ScrollBarThickness = math.max(2, (math.round(v12 * List.AbsoluteSize.Y)))

local Grid = Detail:WaitForChild("Grid")
local v16 = Grid:GetAttribute("ScrollBarFrac") or 0.014

local function fitGridBar() -- line: 132
    -- upvalues: Grid (copy), v16 (copy)
    Grid.ScrollBarThickness = math.max(2, (math.round(v16 * Grid.AbsoluteWindowSize.Y)))
end

Grid:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitGridBar)
Grid.ScrollBarThickness = math.max(2, (math.round(v16 * Grid.AbsoluteWindowSize.Y)))

local function popCards() -- line: 139
    -- upvalues: TweenService (copy), t2 (copy)
    for v20, v21 in ipairs(t2) do
        local HoverScale = v21:FindFirstChild("HoverScale")

        if HoverScale then
            HoverScale.Scale = 0
            TweenService:Create(HoverScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.1 + (v20 - 1) * 0.045), {
                Scale = 1
            }):Play()
        end
    end
end

local v22 = Grid:GetAttribute("PerRow") or 6

local function popDrops() -- line: 150
    -- upvalues: TweenService (copy), t3 (copy), Grid (copy)
    Grid.CanvasPosition = Vector2.zero

    local Y = Grid.AbsolutePosition.Y
    local Y2 = Grid.AbsoluteWindowSize.Y

    for _, v23 in ipairs(t3) do
        v23.scale.Scale = 1

        if v23.slot.Visible and v23.slot.AbsolutePosition.Y - Y < Y2 then
            v23.scale.Scale = 0
            TweenService:Create(v23.scale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.12 + v23.step * 0.035), {
                Scale = 1
            }):Play()
        else
            v23.scale.Scale = 1
        end
    end
end

local t4 = {
    canvasY = Grid.CanvasSize.Y.Scale
}
local t5 = {}
local v24, v25

for _, child in ipairs(Grid:GetChildren()) do
    v24 = child:IsA("Frame")

    if v24 then
        v25 = child.Name
        v24 = tonumber(v25:match("^Slot(%d+)$"))
    end

    if v24 then
        t5[v24] = child
    end
end

t4.rows = math.ceil(#t5 / v22)
t4.y0 = t5[1].Position.Y.Scale * t4.canvasY
t4.dy = (t5[v22 + 1].Position.Y.Scale - t5[1].Position.Y.Scale) * t4.canvasY

local n1 = 0

for _, v27 in pairs(CrateConfig.DROPS) do
    n1 = math.max(n1, #v27)
end

local v29 = #t5 + 1
local v30

for i = v29, n1 do
    v30 = t5[(i - 1) % #t5 + 1]:Clone()
    v30.Name = "Slot" .. i
    v30.Visible = false
    v30.Parent = Grid
end

for _, child in ipairs(Grid:GetChildren()) do
    v30 = child:IsA("Frame") and child:FindFirstChild("HoverScale")

    if v30 then
        v24 = tonumber(child.Name:match("%d+")) or 1
        v25 = #t3 + 1

        local v31 = {
            slot = child,
            scale = v30
        }

        v31.step = (v24 - 1) % v22 + math.floor((v24 - 1) / v22)
        t3[v25] = v31
        ButtonHover.Attach(child, {
            shine = false,
            tile = 1,
            buttonScale = 1.06
        })
        v25 = child.MouseEnter
        v25:Connect(function() -- line: 194
            -- upvalues: HarpoonView (copy), child (copy)
            HarpoonView.Spin(child.Icon:FindFirstChild("HarpoonView"))
        end)
    end
end

local t6 = {}

for _, v34 in ipairs(t3) do
    v25 = v34.slot.Name
    t6[tonumber(v25:match("%d+"))] = v34.slot
end

local function textLook(p6) -- line: 204
    return {
        color = p6.TextColor3,
        grad = p6:FindFirstChildOfClass("UIGradient").Color,
        stroke = p6:FindFirstChildOfClass("UIStroke").Color
    }
end

local t7 = {}

for i = 1, #t6 do
    v24 = t6[i]
    v25 = v24.Title.Text

    if not t7[v25] then
        local Fill = v24:FindFirstChild("Fill")
        local t8 = {
            stroke = v24:FindFirstChildOfClass("UIStroke").Color,
            bg = v24.BackgroundColor3
        }

        t8.fill = Fill and Fill.Color
        t8.fillT = Fill and Fill.Transparency

        local Title = v24.Title

        t8.title = {
            color = Title.TextColor3,
            grad = Title:FindFirstChildOfClass("UIGradient").Color,
            stroke = Title:FindFirstChildOfClass("UIStroke").Color
        }
        Title = v24.Chance
        t8.chance = {
            color = Title.TextColor3,
            grad = Title:FindFirstChildOfClass("UIGradient").Color,
            stroke = Title:FindFirstChildOfClass("UIStroke").Color
        }
        t7[v25] = t8
    end
end

local function dressText(p7, p8) -- line: 221
    p7.TextColor3 = p8.color
    p7:FindFirstChildOfClass("UIGradient").Color = p8.grad
    p7:FindFirstChildOfClass("UIStroke").Color = p8.stroke
end

local function dressSlot(p9, p10) -- line: 227
    -- upvalues: KeyConfig (copy), CrateConfig (copy), HarpoonView (copy), t7 (copy)
    local v35 = t7[p10.rarity] or t7.Common

    if v35 then
        p9:FindFirstChildOfClass("UIStroke").Color = v35.stroke
        p9.BackgroundColor3 = v35.bg

        local Fill = p9:FindFirstChild("Fill")

        if Fill and v35.fill then
            local fill, fillT = v35.fill, v35.fillT

            Fill.Color = fill
            Fill.Transparency = fillT
        end

        local Title = p9.Title
        local title = v35.title

        Title.TextColor3 = title.color
        Title:FindFirstChildOfClass("UIGradient").Color = title.grad
        Title:FindFirstChildOfClass("UIStroke").Color = title.stroke

        local Chance = p9.Chance
        local chance = v35.chance

        Chance.TextColor3 = chance.color
        Chance:FindFirstChildOfClass("UIGradient").Color = chance.grad
        Chance:FindFirstChildOfClass("UIStroke").Color = chance.stroke
    end

    p9.Title.Text = CrateConfig.Title(p10)
    p9.Chance.Text = CrateConfig.ChanceText(p10)

    local Icon = p9.Icon

    Icon.ScaleType = Enum.ScaleType.Fit

    local v36 = p10.key and KeyConfig.KEYS[p10.key]

    if p10.harpoon then
        Icon.Image = ""

        local zero, zero2 = Vector2.zero, Vector2.zero

        Icon.ImageRectOffset = zero
        Icon.ImageRectSize = zero2
        HarpoonView.Mount(Icon, p10.harpoon, Icon.ZIndex)
    else
        HarpoonView.Unmount(Icon)

        if v36 then
            local rect = v36.rect

            Icon.Image = v36.image
            Icon.ImageRectOffset = Vector2.new(rect[1], rect[2])
            Icon.ImageRectSize = Vector2.new(rect[3] - rect[1], rect[4] - rect[2])
        else
            Icon.Image = CrateConfig.PLACEHOLDER_ICON

            local zero, zero2 = Vector2.zero, Vector2.zero

            Icon.ImageRectOffset = zero
            Icon.ImageRectSize = zero2
        end
    end
end

local function showDrops(p11) -- line: 259
    -- upvalues: CrateConfig (copy), Grid (copy), v22 (copy), t4 (copy), t6 (copy), dressSlot (copy)
    local v37 = CrateConfig.DROPS[p11] or {}

    for v38, v39 in pairs(t6) do
        local v40 = v37[v38]

        v39.Visible = v40 ~= nil

        if v40 then
            dressSlot(v39, v40)
        end
    end

    local v43 = math.max(1, (math.ceil(#v37 / v22)))
    local v44 = t4.canvasY + (v43 - t4.rows) * t4.dy

    Grid.CanvasSize = UDim2.new(Grid.CanvasSize.X.Scale, Grid.CanvasSize.X.Offset, v44, 0)

    for v45, v46 in pairs(t6) do
        local v48 = math.floor((v45 - 1) / v22)

        v46.Position = UDim2.new(v46.Position.X.Scale, v46.Position.X.Offset, (t4.y0 + v48 * t4.dy) / v44, 0)
    end

    local v49 = Grid.Size.Y.Scale + 0.001 < v44

    Grid.ScrollingEnabled = v49
    Grid.ScrollBarImageTransparency = v49 and 0 or 1
end

local v50, v51

for _, v52 in ipairs(t2) do
    local Left = v52:FindFirstChild("Left")
    local Title = v52:FindFirstChild("Title")

    if Left and Title and Left:FindFirstChild("Label") then
        local v53 = KeyConfig.Attr(Title.Text)

        Left.Label.AutoLocalize = false

        local function showCount() -- line: 290
            -- upvalues: LocalPlayer (copy), Loc (copy), layoutUse (copy), Left (copy), v53 (copy)
            Left.Label.Text = Loc.F("crate.use", "USE x{n}", {
                n = tostring(LocalPlayer:GetAttribute(v53) or 0)
            })
            layoutUse(Left)
        end

        LocalPlayer:GetAttributeChangedSignal(v53):Connect(showCount)
        Loc.Changed:Connect(showCount)
        showCount()
    end
end

v25 = require(Modules:WaitForChild("Badge"))

local t10 = {}

for _, v55 in ipairs(t2) do
    local Title = v55:FindFirstChild("Title")

    if Title then
        t10[#t10 + 1] = {
            badge = v25.Attach(v55, {
                text = "!",
                size = 0.13,
                zIndex = 12,
                at = Vector2.new(0.9, 0.07)
            }),
            attr = KeyConfig.Attr(Title.Text)
        }
    end
end

local function refresh() -- line: 318
    -- upvalues: LocalPlayer (copy), t10 (copy)
    for _, v56 in ipairs(t10) do
        v56.badge.Set((LocalPlayer:GetAttribute(v56.attr) or 0) >= 1 and 1 or 0)
    end
end

for _, v57 in ipairs(t10) do
    LocalPlayer:GetAttributeChangedSignal(v57.attr):Connect(refresh)
end

refresh()

for _, v58 in ipairs(t2) do
    for _, v59 in ipairs({ "Left", "Right" }) do
        local v60 = v58:FindFirstChild(v59)

        if v60 then
            ButtonHover.Attach(v60, (hoverOpts(v60, {
                icon = v60:FindFirstChild("Key")
            })))
            v60.Activated:Connect(function() -- line: 331
                -- upvalues: ButtonHover (copy), v50 (ref), v51 (ref), v59 (copy), v60 (copy), v58 (copy)
                ButtonHover.Press(v60)

                if v59 == "Left" and v50 then
                    v50(v58)
                end

                if v59 == "Right" and v51 then
                    v51(v58)
                end
            end)
        end
    end
end

local DetailPosition = Detail.Position

Panel.Visible = false
Detail.Visible = false
List.Visible = true
Scale3.Scale = 1

local v61 = nil
local v62, v63
local v64 = TweenInfo.new(PanelFocus.FEEL.CLOSE_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local v65 = TweenInfo.new(PanelFocus.FEEL.CLOSE_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v66 = false
local v67 = nil

Scale3:GetPropertyChangedSignal("Scale"):Connect(function() -- line: 357
    -- upvalues: List (copy), Scale3 (copy), v67 (ref)
    if v67 then
        List.CanvasPosition = v67 * Scale3.Scale
    end
end)

local function viewSpot(p12) -- line: 360
    -- upvalues: Main (copy), Detail (copy)
    local v69 = p12.AbsolutePosition + p12.AbsoluteSize / 2 - Main.AbsolutePosition

    return UDim2.fromScale(v69.X / Main.AbsoluteSize.X, v69.Y / Main.AbsoluteSize.Y), p12.AbsoluteSize.X / math.max(Detail.Size.X.Scale * Main.AbsoluteSize.X, 1)
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local closeDetail, close

local function openDetail(p13) -- line: 370
    -- upvalues: TweenService (copy), PanelFocus (copy), List (copy), Detail (copy), Scale2 (copy), Scale3 (copy), CrateIcon (copy), CrateName (copy), popDrops (copy), showDrops (copy), DetailPosition (copy), v61 (ref), v62 (ref), v63 (ref), v64 (copy), v66 (ref), v67 (ref), viewSpot (copy), PadMenu (copy), closeDetail (ref)
    if v66 or v61 then
        return
    end

    v66 = true
    v61 = p13

    local Parent = p13.Parent
    local Icon = Parent:FindFirstChild("Icon")

    if Icon then
        local Image, ImageRectOffset, ImageRectSize = Icon.Image, Icon.ImageRectOffset, Icon.ImageRectSize

        CrateIcon.Image = Image
        CrateIcon.ImageRectOffset = ImageRectOffset
        CrateIcon.ImageRectSize = ImageRectSize
    end

    local Title = Parent:FindFirstChild("Title")

    if Title then
        CrateName.Text = Title.Text .. " Crate"
        showDrops(Title.Text)
    end

    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    v67 = List.CanvasPosition / math.max(Scale3.Scale, 0.001)

    local v72, v73 = viewSpot(p13)

    v62 = v72
    v63 = v73
    Detail.Position = v72
    Scale2.Scale = v73
    Detail.Visible = true
    TweenService:Create(Detail, PanelFocus.popIn, {
        Position = DetailPosition
    }):Play()

    local tween = TweenService:Create(Scale2, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 392
        -- upvalues: v66 (ref)
        v66 = false
    end)
    tween:Play()
    popDrops()
    PadMenu.Open(Detail, function() -- line: 395
        -- upvalues: closeDetail (ref)
        if closeDetail then
            closeDetail()
        end
    end, {})

    local tween2 = TweenService:Create(Scale3, v64, {
        Scale = 0
    })

    tween2.Completed:Once(function(p14) -- line: 397
        -- upvalues: p13 (copy), List (copy), v61 (ref)
        if p14 == Enum.PlaybackState.Completed and v61 == p13 then
            List.Visible = false
        end
    end)
    tween2:Play()
end

local function closeDetail2() -- line: 402
    -- upvalues: TweenService (copy), PanelFocus (copy), List (copy), Detail (copy), Scale2 (copy), Scale3 (copy), v61 (ref), v62 (ref), v63 (ref), v65 (copy), v66 (ref), v67 (ref), PadMenu (copy)
    if v66 or not v61 then
        return
    end

    v66 = true
    PadMenu.Close(Detail)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    List.Visible = true

    local tween = TweenService:Create(Scale3, v65, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 409
        -- upvalues: List (copy), v61 (ref), v67 (ref)
        if v67 then
            List.CanvasPosition = v67
        end

        if not v61 then
            v67 = nil
        end
    end)
    tween:Play()
    TweenService:Create(Detail, PanelFocus.popOut, {
        Position = v62
    }):Play()

    local tween2 = TweenService:Create(Scale2, PanelFocus.popOut, {
        Scale = v63
    })

    tween2.Completed:Once(function() -- line: 416
        -- upvalues: Detail (copy), v61 (ref), v66 (ref)
        Detail.Visible = false
        v61 = nil
        v66 = false
    end)
    tween2:Play()
end

for _, child in ipairs(List:GetChildren()) do
    local v74 = child:IsA("Frame") and child:FindFirstChild("View")

    if v74 then
        ButtonHover.Attach(v74, (hoverOpts(v74, {
            icon = v74:FindFirstChild("Icon")
        })))
        v74.Activated:Connect(function() -- line: 432
            -- upvalues: ButtonHover (copy), openDetail (copy), v74 (copy)
            ButtonHover.Press(v74)
            openDetail(v74)
        end)
    end
end

Back.Activated:Connect(closeDetail2)
ButtonHover.Attach(Back, {
    shine = false,
    tile = 1,
    icon = Back:FindFirstChild("X")
})

local Toast = require(Modules:WaitForChild("Toast"))
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local CrateOpenGui = PlayerGui:WaitForChild("CrateOpenGui")
local Dim = CrateOpenGui:WaitForChild("Dim")
local Glow = CrateOpenGui:WaitForChild("Glow")
local Flash = CrateOpenGui:WaitForChild("Flash")
local Crate = CrateOpenGui:WaitForChild("Crate")
local Image = Crate:WaitForChild("Image")
local Pop = Crate:WaitForChild("Pop")
local Rewards = Main:WaitForChild("Rewards")
local OK = Main:WaitForChild("OK")
local CrateOpen = Remotes:WaitForChild("CrateOpen")
local t11 = {
    STRIP_OUT = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    SLIDE = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SIZE = 0.6,
    SWELL = 1.3,
    SHAKE_MOVE = { 0.004, 0.035 },
    SHAKE_TURN = { 1, 9 },
    DIM = 0.2,
    DIM_IN = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    GLOW = { 0.9, 0.25 },
    GLOW_SIZE = { 1.1, 1.9 },
    GLOW_SPIN = 60,
    BUILD_SOUND = "rbxassetid://1839997904",
    BUILD_VOLUME = 0.5,
    BUILD_FADE = 0.45,
    BURST_SOUND = "rbxassetid://76357092271646",
    BURST_VOLUME = 0.6,
    BURST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BURST_SCALE = 1.8,
    GLOW_OUT = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FLASH = 0.35,
    FLASH_TIME = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    CARD_FIRST = 0.06,
    CARD_STEP = 0.08,
    CARDS_SPAN = 1.2,
    CARD_POP = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    OWNED_LOOK = {
        color = Color3.new(1, 1, 1),
        grad = ColorSequence.new(Color3.fromRGB(140, 255, 120), Color3.fromRGB(60, 205, 80)),
        stroke = Color3.fromRGB(15, 70, 20)
    },
    CARD_SOUND = "rbxassetid://137392628136734",
    CARD_VOLUME = 0.5,
    CARD_PITCH = { 0.95, 1.05 },
    OK_SOUND = "rbxassetid://873617644",
    OK_VOLUME = 0.5,
    OK_AT = 0.45,
    SPIN_AFTER = 0.12,
    COMPACT_LOOK = {
        color = Color3.new(1, 1, 1),
        grad = ColorSequence.new(Color3.fromRGB(255, 225, 50), Color3.fromRGB(255, 170, 20)),
        stroke = Color3.fromRGB(90, 50, 0)
    },
    OK_POP = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    CLEAR = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    UNDIM = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MUSIC_DUCK = 0.2
}

local function lerp(p15, p16) -- line: 511
    return p15[1] + (p15[2] - p15[1]) * p16
end

local function sound(p17, p18) -- line: 512
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound")

    Sound.SoundId = p17
    Sound.Volume = p18
    Sound.Parent = SoundService

    return Sound
end

local BUILD_SOUND, BURST_SOUND = t11.BUILD_SOUND, t11.BUILD_VOLUME
local Sound = Instance.new("Sound")

Sound.SoundId = BUILD_SOUND
Sound.Volume = BURST_SOUND
Sound.Parent = SoundService
BURST_SOUND = t11.BURST_SOUND

local CARD_SOUND = t11.BURST_VOLUME
local Sound2 = Instance.new("Sound")

Sound2.SoundId = BURST_SOUND
Sound2.Volume = CARD_SOUND
Sound2.Parent = SoundService
CARD_SOUND = t11.CARD_SOUND

local spawn = t11.CARD_VOLUME
local Sound3 = Instance.new("Sound")

Sound3.SoundId = CARD_SOUND
Sound3.Volume = spawn
Sound3.Parent = SoundService
spawn = t11.OK_SOUND

local OK_VOLUME = t11.OK_VOLUME
local Sound4 = Instance.new("Sound")

Sound4.SoundId = spawn
Sound4.Volume = OK_VOLUME
Sound4.Parent = SoundService
task.spawn(function() -- line: 522
    -- upvalues: Sound (copy), Sound2 (copy), Sound3 (copy), Sound4 (copy)
    game:GetService("ContentProvider"):PreloadAsync({
        Sound,
        Sound2,
        Sound3,
        Sound4
    })
end)

local function playCardSound() -- line: 524
    -- upvalues: SoundService (copy), t11 (copy), Sound3 (copy)
    local clone = Sound3:Clone()

    clone.PlaybackSpeed = t11.CARD_PITCH[1] + (t11.CARD_PITCH[2] - t11.CARD_PITCH[1]) * math.random()
    clone.Parent = SoundService
    clone.Ended:Once(function() -- line: 528
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    clone:Play()
    task.delay(5, function() -- line: 530
        -- upvalues: clone (copy)
        if clone.Parent then
            clone:Destroy()
        end
    end)
end

ButtonHover.Attach(OK, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})

local HoverScale = OK:WaitForChild("HoverScale")
local v75 = false
local v76 = false
local connection, finishOpening

local function overlaySpot(p19) -- line: 539
    -- upvalues: CrateOpenGui (copy)
    local v77 = p19.AbsolutePosition + p19.AbsoluteSize / 2 - CrateOpenGui.AbsolutePosition

    return UDim2.fromScale(v77.X / CrateOpenGui.AbsoluteSize.X, v77.Y / CrateOpenGui.AbsoluteSize.Y)
end

local function overlaySquare(p20) -- line: 543
    -- upvalues: CrateOpenGui (copy)
    return UDim2.fromScale(p20 / CrateOpenGui.AbsoluteSize.X, p20 / CrateOpenGui.AbsoluteSize.Y)
end

local function emptyRow() -- line: 546
    -- upvalues: Rewards (copy)
    for _, child in ipairs(Rewards:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function clearOpening() -- line: 552
    -- upvalues: LocalPlayer (copy), PadMenu (copy), Dim (copy), Glow (copy), Flash (copy), Crate (copy), Rewards (copy), OK (copy), Sound (copy), v75 (ref), v76 (ref), connection (ref), emptyRow (copy)
    v75 = false
    v76 = false
    PadMenu.Close(OK)
    LocalPlayer:SetAttribute("MusicDuck", nil)

    if connection then
        connection:Disconnect()
        connection = nil
    end

    Sound:Stop()
    Dim.Visible = false
    Glow.Visible = false
    Crate.Visible = false
    Flash.Visible = false
    Rewards.Visible = false
    OK.Visible = false
    emptyRow()
end

local CellShape = Rewards:WaitForChild("Grid"):WaitForChild("CellShape")
local v78 = Rewards:GetAttribute("CardWidth") or 0.78
local v79 = Rewards:GetAttribute("ScrollBarFrac") or 0.014

local function fitRewardsBar() -- line: 568
    -- upvalues: Rewards (copy), v79 (copy)
    Rewards.ScrollBarThickness = math.max(2, (math.round(v79 * Rewards.AbsoluteWindowSize.Y)))
end

Rewards:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitRewardsBar)
Rewards.ScrollBarThickness = math.max(2, (math.round(v79 * Rewards.AbsoluteWindowSize.Y)))

local Grid2 = Rewards:WaitForChild("Grid")

local function fitRewardsCanvas() -- line: 574
    -- upvalues: Rewards (copy), Grid2 (copy)
    Rewards.CanvasSize = UDim2.fromOffset(0, Grid2.AbsoluteContentSize.Y)
end

Grid2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitRewardsCanvas)
Rewards.CanvasSize = UDim2.fromOffset(0, Grid2.AbsoluteContentSize.Y)

local function burst(p21, p22) -- line: 581
    -- upvalues: TweenService (copy), CrateConfig (copy), HarpoonView (copy), Loc (copy), t6 (copy), dressSlot (copy), PadMenu (copy), Toast (copy), Dim (copy), Glow (copy), Flash (copy), Crate (copy), Image (copy), Pop (copy), Rewards (copy), OK (copy), t11 (copy), Sound (copy), Sound2 (copy), playCardSound (copy), HoverScale (copy), v75 (ref), connection (ref), finishOpening (ref), emptyRow (copy), CellShape (copy), v78 (copy)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    TweenService:Create(Sound, TweenInfo.new(t11.BUILD_FADE), {
        Volume = 0
    }):Play()
    task.delay(t11.BUILD_FADE, function() -- line: 584
        -- upvalues: Sound (copy)
        Sound:Stop()
    end)
    Sound2:Play()
    TweenService:Create(Pop, t11.BURST, {
        Scale = Pop.Scale * t11.BURST_SCALE
    }):Play()
    TweenService:Create(Image, t11.BURST, {
        ImageTransparency = 1
    }):Play()

    local Size = Glow.Size

    TweenService:Create(Glow, t11.GLOW_OUT, {
        ImageTransparency = 1,
        Size = UDim2.fromScale(Size.X.Scale * 1.6, Size.Y.Scale * 1.6)
    }):Play()
    Flash.BackgroundTransparency = t11.FLASH
    Flash.Visible = true
    TweenService:Create(Flash, t11.FLASH_TIME, {
        BackgroundTransparency = 1
    }):Play()

    local tween = TweenService:Create(Dim, t11.UNDIM, {
        BackgroundTransparency = 1
    })

    tween.Completed:Once(function() -- line: 595
        -- upvalues: Dim (copy), v75 (ref)
        if v75 then
            Dim.Visible = false
        end
    end)
    tween:Play()
    task.delay(t11.GLOW_OUT.Time, function() -- line: 597
        -- upvalues: Glow (copy), Flash (copy), Crate (copy), v75 (ref)
        if not v75 then
            return
        end

        Crate.Visible = false
        Glow.Visible = false
        Flash.Visible = false
    end)

    local v84 = CrateConfig.DROPS[p21]
    local t12 = {}
    local _ipairs = ipairs
    local v85 = if type(p22) ~= "table" or not p22 then {} else p22

    for _, v86 in _ipairs(v85) do
        local v87 = v84 and v84[v86.index]
        local v88 = v86.count or 0

        if v87 and v88 > 0 then
            if v87.harpoon and v86.new then
                t12[#t12 + 1] = {
                    count = 1,
                    clean = true,
                    drop = v87,
                    index = v86.index
                }

                if v88 > 1 then
                    t12[#t12 + 1] = {
                        owned = true,
                        drop = v87,
                        index = v86.index,
                        count = v88 - 1,
                        compact = v86.compact
                    }
                end
            else
                t12[#t12 + 1] = {
                    drop = v87,
                    index = v86.index,
                    count = v88,
                    owned = v87.harpoon ~= nil,
                    compact = v86.compact
                }
            end
        end
    end

    table.sort(t12, function(p23, p24) -- line: 616
        local v90 = p23.drop.key ~= nil
        local v91 = p24.drop.key ~= nil

        if v90 ~= v91 then
            return v91
        end

        if p23.drop.chance ~= p24.drop.chance then
            return p23.drop.chance > p24.drop.chance
        end

        if p23.index ~= p24.index then
            return p23.index < p24.index
        end

        if p23.clean == true then
            return p24.clean ~= true
        end

        return false
    end)
    emptyRow()

    local t14 = {}

    for v92, v93 in ipairs(t12) do
        local Frame = Instance.new("Frame")

        Frame.Name = "Reward" .. v92
        Frame.BackgroundTransparency = 1
        Frame.LayoutOrder = v92

        local clone = t6[1]:Clone()

        clone.Name = "Card"
        clone.Visible = true
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.Position = UDim2.fromScale(0.5, 0.5)
        clone.Size = UDim2.fromScale(v78, v78 * CellShape.AspectRatio)
        dressSlot(clone, v93.drop)

        local Chance = clone.Chance

        if v93.clean then
            Chance.Text = ""
        else
            Chance.Text = "x" .. v93.count
        end

        if (v93.compact or 0) > 0 then
            local clone2 = clone.Chance:Clone()

            clone2.Name = "Duplicate"
            clone2.AutoLocalize = false
            clone2.Text = Loc.T("DUPLICATE")
            clone2.AnchorPoint = Vector2.new(0.5, 0.5)
            clone2.Position = UDim2.fromScale(0.5, 0.5)
            clone2.Size = UDim2.fromScale(1.08, 0.3)
            clone2.TextXAlignment = Enum.TextXAlignment.Center
            clone2.ZIndex = clone.Icon.ZIndex + 5

            local COMPACT_LOOK = t11.COMPACT_LOOK

            clone2.TextColor3 = COMPACT_LOOK.color
            clone2:FindFirstChildOfClass("UIGradient").Color = COMPACT_LOOK.grad
            clone2:FindFirstChildOfClass("UIStroke").Color = COMPACT_LOOK.stroke
            clone2.Parent = clone
        end

        if v93.owned then
            local clone2 = clone.Chance:Clone()

            clone2.Name = "Owned"
            clone2.Text = "OWNED"
            clone2.AnchorPoint = Vector2.new(0.5, 1)
            clone2.Position = UDim2.fromScale(0.5, -0.12)

            local OWNED_LOOK = t11.OWNED_LOOK

            clone2.TextColor3 = OWNED_LOOK.color
            clone2:FindFirstChildOfClass("UIGradient").Color = OWNED_LOOK.grad
            clone2:FindFirstChildOfClass("UIStroke").Color = OWNED_LOOK.stroke
            clone2.Parent = clone
        end

        local v94 = clone:FindFirstChild("HoverScale") or Instance.new("UIScale", clone)

        v94.Scale = 0
        clone.Parent = Frame
        Frame.Parent = Rewards
        t14[v92] = {
            holder = Frame,
            card = clone,
            scale = v94
        }
    end

    if #t12 == 0 then
        Toast.Show("Couldn't open that crate!", "", nil, Toast.RED, "deny")
    end

    Rewards.CanvasPosition = Vector2.zero
    Rewards.Visible = true
    task.wait()

    if not v75 then
        return
    end

    local Y = Rewards.AbsoluteWindowSize.Y

    Rewards.ScrollBarImageTransparency = Rewards.AbsoluteCanvasSize.Y > Y + 1 and 0 or 1

    local t15 = {}

    for _, v95 in ipairs(t14) do
        if v95.holder.AbsolutePosition.Y - Rewards.AbsolutePosition.Y < Y then
            t15[#t15 + 1] = v95
        else
            v95.scale.Scale = 1
        end
    end

    local v98 = math.min(t11.CARD_STEP, t11.CARDS_SPAN / math.max(#t15, 1))

    for v99, v100 in ipairs(t15) do
        local v101 = t11.CARD_FIRST + (v99 - 1) * v98

        TweenService:Create(v100.scale, TweenInfo.new(t11.CARD_POP.Time, t11.CARD_POP.EasingStyle, t11.CARD_POP.EasingDirection, 0, false, v101), {
            Scale = 1
        }):Play()
        task.delay(v101, function() -- line: 695
            -- upvalues: playCardSound (copy), v75 (ref)
            if v75 then
                playCardSound()
            end
        end)
        task.delay(v101 + t11.SPIN_AFTER, function() -- line: 696
            -- upvalues: v100 (copy), HarpoonView (copy), v75 (ref)
            if v75 then
                HarpoonView.Spin(v100.card.Icon:FindFirstChild("HarpoonView"))
            end
        end)
    end

    task.delay(t11.OK_AT + (math.max(#t15, 1) - 1) * v98, function() -- line: 701
        -- upvalues: TweenService (copy), PadMenu (copy), OK (copy), t11 (copy), HoverScale (copy), v75 (ref), finishOpening (ref)
        if not v75 then
            return
        end

        HoverScale.Scale = 0
        OK.Visible = true
        TweenService:Create(HoverScale, t11.OK_POP, {
            Scale = 1
        }):Play()
        PadMenu.Open(OK, function() -- line: 707
            -- upvalues: finishOpening (ref)
            if finishOpening then
                finishOpening()
            end
        end, {
            first = OK
        })
    end)
end

v50 = function(p25, p26) -- line: 711
    -- upvalues: TweenService (copy), LocalPlayer (copy), Main (copy), List (copy), Scale3 (copy), KeyConfig (copy), CrateConfig (copy), v61 (ref), v66 (ref), v67 (ref), Toast (copy), RunService (copy), CrateOpenGui (copy), Dim (copy), Glow (copy), Crate (copy), Image (copy), Pop (copy), CrateOpen (copy), t11 (copy), Sound (copy), v75 (ref), connection (ref), burst (copy)
    if v75 or v61 or v66 then
        return false
    end

    local Text = p25.Title.Text

    if p26 or not ((LocalPlayer:GetAttribute(KeyConfig.Attr(Text)) or 0) < 1) then
        v75 = true

        local v103
        local v104 = false

        if p26 then
            v103 = p26
            v104 = true
        else
            task.spawn(function() -- line: 724
                -- upvalues: Text (copy), v103 (ref), v104 (ref), CrateOpen (copy)
                local InvokeServer = CrateOpen.InvokeServer
                local ok, result = pcall(InvokeServer, CrateOpen, Text)

                if not ok or not result then
                    result = nil
                end

                v103 = result
                v104 = true
            end)
        end

        v67 = List.CanvasPosition / math.max(Scale3.Scale, 0.001)
        TweenService:Create(Scale3, t11.STRIP_OUT, {
            Scale = 0
        }):Play()
        task.delay(t11.STRIP_OUT.Time, function() -- line: 732
            -- upvalues: List (copy), v75 (ref)
            if v75 then
                List.Visible = false
            end
        end)

        local Icon = p25.Icon
        local Image2, ImageRectOffset, ImageRectSize = Icon.Image, Icon.ImageRectOffset, Icon.ImageRectSize

        Image.Image = Image2
        Image.ImageRectOffset = ImageRectOffset
        Image.ImageRectSize = ImageRectSize

        local v105 = UDim2.fromScale(0.5, 0.5)

        Image.ImageTransparency = 0
        Image.Rotation = 0
        Image.Position = v105

        local v106 = Icon.AbsolutePosition + Icon.AbsoluteSize / 2 - CrateOpenGui.AbsolutePosition

        Crate.Position = UDim2.fromScale(v106.X / CrateOpenGui.AbsoluteSize.X, v106.Y / CrateOpenGui.AbsoluteSize.Y)

        local v107 = math.min(Icon.AbsoluteSize.X, Icon.AbsoluteSize.Y)

        Crate.Size = UDim2.fromScale(v107 / CrateOpenGui.AbsoluteSize.X, v107 / CrateOpenGui.AbsoluteSize.Y)
        Pop.Scale = 1
        Crate.Visible = true

        local v108 = Main.AbsolutePosition + Main.AbsoluteSize / 2 - CrateOpenGui.AbsolutePosition
        local v109 = UDim2.fromScale(v108.X / CrateOpenGui.AbsoluteSize.X, v108.Y / CrateOpenGui.AbsoluteSize.Y)
        local v110 = t11.SIZE * Main.AbsoluteSize.Y
        local v111 = UDim2.fromScale(v110 / CrateOpenGui.AbsoluteSize.X, v110 / CrateOpenGui.AbsoluteSize.Y)

        TweenService:Create(Crate, t11.SLIDE, {
            Position = v109,
            Size = v111
        }):Play()
        Dim.BackgroundTransparency = 1
        Dim.Visible = true
        TweenService:Create(Dim, t11.DIM_IN, {
            BackgroundTransparency = t11.DIM
        }):Play()
        LocalPlayer:SetAttribute("MusicDuck", t11.MUSIC_DUCK)
        Glow.ImageTransparency = 1
        Glow.Rotation = 0
        Glow.Visible = true
        Sound.Volume = t11.BUILD_VOLUME
        Sound.TimePosition = 0
        Sound:Play()

        local elapsed = os.clock()

        connection = RunService.RenderStepped:Connect(function(p27) -- line: 755
            -- upvalues: elapsed (copy), CrateConfig (copy), Glow (copy), Crate (copy), Image (copy), Pop (copy), t11 (copy)
            local v113 = math.clamp((os.clock() - elapsed) / CrateConfig.BURST_AT, 0, 1)
            local v114 = v113 * v113
            local SHAKE_MOVE = t11.SHAKE_MOVE
            local v115 = SHAKE_MOVE[1] + (SHAKE_MOVE[2] - SHAKE_MOVE[1]) * v114

            Image.Position = UDim2.fromScale(0.5 + (math.random() * 2 - 1) * v115, 0.5 + (math.random() * 2 - 1) * v115)

            local v116 = math.random() * 2 - 1
            local SHAKE_TURN = t11.SHAKE_TURN

            Image.Rotation = v116 * (SHAKE_TURN[1] + (SHAKE_TURN[2] - SHAKE_TURN[1]) * v114)
            Pop.Scale = 1 + (t11.SWELL - 1) * v114

            local GLOW_SIZE = t11.GLOW_SIZE
            local v117 = (GLOW_SIZE[1] + (GLOW_SIZE[2] - GLOW_SIZE[1]) * v114) * Pop.Scale

            Glow.Position = Crate.Position
            Glow.Size = UDim2.fromScale(Crate.Size.X.Scale * v117, Crate.Size.Y.Scale * v117)

            local GLOW = t11.GLOW

            Glow.ImageTransparency = GLOW[1] + (GLOW[2] - GLOW[1]) * v113
            Glow.Rotation = (Glow.Rotation + t11.GLOW_SPIN * p27) % 360
        end)
        task.delay(CrateConfig.BURST_AT, function() -- line: 769
            -- upvalues: Text (copy), v103 (ref), v104 (ref), v75 (ref), burst (copy)
            local v118 = os.clock() + 3

            while v75 and not v104 and os.clock() < v118 do
                task.wait()
            end

            if v75 then
                burst(Text, v103)
            end
        end)

        return true
    end

    Toast.Show("No " .. Text .. " Keys!", "", nil, Toast.RED, "deny")

    return false
end

local function finishOpening2() -- line: 778
    -- upvalues: TweenService (copy), LocalPlayer (copy), List (copy), Scale3 (copy), v65 (copy), v67 (ref), PadMenu (copy), Dim (copy), Rewards (copy), OK (copy), t11 (copy), Sound4 (copy), HoverScale (copy), v75 (ref), v76 (ref), clearOpening (copy)
    local v119 = v75

    if not v119 or v76 then
        return
    end

    v76 = true
    PadMenu.Close(OK)
    Sound4:Play()

    for _, child in ipairs(Rewards:GetChildren()) do
        local Frame = child:IsA("Frame") and child:FindFirstChild("Card") and child.Card:FindFirstChild("HoverScale")

        if Frame then
            TweenService:Create(Frame, t11.CLEAR, {
                Scale = 0
            }):Play()
        end
    end

    TweenService:Create(HoverScale, t11.CLEAR, {
        Scale = 0
    }):Play()
    TweenService:Create(Dim, t11.UNDIM, {
        BackgroundTransparency = 1
    }):Play()
    LocalPlayer:SetAttribute("MusicDuck", nil)
    List.Visible = true

    local tween = TweenService:Create(Scale3, v65, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 792
        -- upvalues: List (copy), v67 (ref)
        if v67 then
            List.CanvasPosition = v67
        end

        v67 = nil
    end)
    tween:Play()
    task.delay(math.max(t11.CLEAR.Time, t11.UNDIM.Time), function() -- line: 797
        -- upvalues: v76 (ref), clearOpening (copy)
        if v76 then
            clearOpening()
        end
    end)
end

finishOpening = finishOpening2
OK.Activated:Connect(finishOpening2)
clearOpening()

local PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local t16 = {}

local function dressCratePrices() -- line: 819
    -- upvalues: LocalPlayer (copy), t2 (copy), t16 (copy)
    local v120 = LocalPlayer:GetAttribute("NoPaidRandom") == true

    for _, v121 in ipairs(t2) do
        local Right = v121:FindFirstChild("Right")
        local Label = Right and Right:FindFirstChild("Label")

        if Label then
            if v120 then
                Label.Text = "RESTRICTED"
            elseif t16[v121] then
                Label.Text = t16[v121]
            end

            Right.ImageTransparency = v120 and 0.4 or 0
            Label.TextTransparency = v120 and 0.4 or 0
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dressCratePrices)

v51 = function(p28) -- line: 832
    -- upvalues: LocalPlayer (copy), v61 (ref), v66 (ref), Toast (copy), v75 (ref), PurchaseFX (copy), ShopConfig (copy)
    if not v75 and not v61 and not v66 then
        if LocalPlayer:GetAttribute("NoPaidRandom") then
            Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
        else
            local v122 = ShopConfig.CrateRow(p28.Title.Text)

            if v122 then
                PurchaseFX.Buy(v122.product)
            end
        end
    end
end

task.spawn(function() -- line: 841
    -- upvalues: MarketplaceService (copy), t2 (copy), ShopConfig (copy), t16 (copy), dressCratePrices (copy)
    for _, v123 in ipairs(t2) do
        local v124 = ShopConfig.CrateRow(v123.Title.Text)
        local v125 = v124 and v123:FindFirstChild("Right") and v123.Right:FindFirstChild("Label")

        if v125 then
            local v126 = utf8.char(57346)

            v125.Text = v126 .. " " .. v124.price

            local GetProductInfo = MarketplaceService.GetProductInfo
            local product = v124.product
            local Product = Enum.InfoType.Product
            local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

            if ok and result and type(result.PriceInRobux) == "number" then
                v125.Text = v126 .. " " .. result.PriceInRobux
            end

            t16[v123] = v125.Text
        end
    end

    dressCratePrices()
end)
dressCratePrices()
Remotes:WaitForChild("PurchaseGranted").OnClientEvent:Connect(function(p29, p30) -- line: 856
    -- upvalues: Panel (copy), t2 (copy), v50 (ref), Toast (copy), PurchaseFX (copy)
    if p29 == "Crate" and type(p30) == "table" then
        PurchaseFX.Success()

        local v127

        for _, v128 in ipairs(t2) do
            if v128.Title.Text == p30.crate then
                v127 = v128
            end
        end

        if v127 and Panel.Visible and not not v50(v127, p30.results or {}) then
            return
        end

        Toast.Show(tostring(p30.crate) .. " Crate opened!", "", nil, nil, "equip")
    end
end)

local KeysInfo = PlayerGui:WaitForChild("CratesGui"):WaitForChild("KeysInfo")
local Dim2 = KeysInfo:WaitForChild("Dim")
local Card = KeysInfo:WaitForChild("Card")
local Scale4 = Card:WaitForChild("Scale")
local OK2 = Card:WaitForChild("OK")
local Info = Main:WaitForChild("KeysBar"):WaitForChild("Info")
local t17 = {
    DIM = 0.45,
    TWIST = -16,
    ROW_FIRST = 0.12,
    ROW_STEP = 0.07,
    DIM_IN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    POP = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ROW_POP = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    CLOSE = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
}
local CardPosition = Card.Position
local t18 = {
    Card:WaitForChild("Chest"),
    Card:WaitForChild("Daily"),
    Card:WaitForChild("Index"),
    Card:WaitForChild("Shop")
}
local v130 = false
local v131 = false

KeysInfo.Visible = false

local v132

local function showKeysInfo() -- line: 894
    -- upvalues: TweenService (copy), PanelFocus (copy), v61 (ref), v66 (ref), PadMenu (copy), v75 (ref), KeysInfo (copy), Dim2 (copy), Card (copy), Scale4 (copy), OK2 (copy), Info (copy), t17 (copy), CardPosition (copy), t18 (copy), v130 (ref), v131 (ref), v132 (ref)
    if v130 or v131 or v75 or v61 or v66 then
        return
    end

    v130 = true
    v131 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

    local v133 = Info.AbsolutePosition + Info.AbsoluteSize / 2 - KeysInfo.AbsolutePosition

    Card.Position = UDim2.fromScale(v133.X / math.max(1, KeysInfo.AbsoluteSize.X), v133.Y / math.max(1, KeysInfo.AbsoluteSize.Y))
    Card.Rotation = t17.TWIST
    Scale4.Scale = 0
    Dim2.BackgroundTransparency = 1

    for _, v135 in ipairs(t18) do
        v135.Pop.Scale = 0
    end

    KeysInfo.Visible = true
    TweenService:Create(Dim2, t17.DIM_IN, {
        BackgroundTransparency = t17.DIM
    }):Play()
    TweenService:Create(Card, t17.POP, {
        Rotation = 0,
        Position = CardPosition
    }):Play()

    local tween = TweenService:Create(Scale4, t17.POP, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 909
        -- upvalues: v131 (ref)
        v131 = false
    end)
    tween:Play()

    for v136, v137 in ipairs(t18) do
        TweenService:Create(v137.Pop, TweenInfo.new(t17.ROW_POP.Time, t17.ROW_POP.EasingStyle, t17.ROW_POP.EasingDirection, 0, false, t17.ROW_FIRST + (v136 - 1) * t17.ROW_STEP), {
            Scale = 1
        }):Play()
    end

    PadMenu.Open(KeysInfo, function() -- line: 915
        -- upvalues: v132 (ref)
        if v132 then
            v132()
        end
    end, {
        first = OK2
    })
end

local function hideKeysInfo(p31) -- line: 917
    -- upvalues: TweenService (copy), PanelFocus (copy), PadMenu (copy), KeysInfo (copy), Dim2 (copy), Scale4 (copy), t17 (copy), v130 (ref), v131 (ref)
    if v130 then
        if p31 then
            PadMenu.Close(KeysInfo)
            v130 = false
            v131 = false
            KeysInfo.Visible = false
        elseif not v131 then
            v131 = true
            PadMenu.Close(KeysInfo)
            PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
            TweenService:Create(Dim2, t17.CLOSE, {
                BackgroundTransparency = 1
            }):Play()

            local tween = TweenService:Create(Scale4, t17.CLOSE, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 931
                -- upvalues: KeysInfo (copy), v130 (ref), v131 (ref)
                KeysInfo.Visible = false
                v130 = false
                v131 = false
            end)
            tween:Play()
        end
    end
end

v132 = function() -- line: 937
    -- upvalues: Sound4 (copy), v131 (ref), hideKeysInfo (copy)
    if not v131 then
        Sound4:Play()
        hideKeysInfo()
    end
end

ButtonHover.Attach(Info, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8,
    icon = Info:WaitForChild("Icon")
})
Info.Activated:Connect(function() -- line: 943
    -- upvalues: ButtonHover (copy), Info (copy), showKeysInfo (copy)
    ButtonHover.Press(Info)
    showKeysInfo()
end)
ButtonHover.Attach(OK2, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
OK2.Activated:Connect(function() -- line: 948
    -- upvalues: ButtonHover (copy), Sound4 (copy), OK2 (copy), hideKeysInfo (copy)
    ButtonHover.Press(OK2)
    Sound4:Play()
    hideKeysInfo()
end)

local v138 = false
local v139 = false

local function open() -- line: 956
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), Close (copy), List (copy), popCards (copy), PadMenu (copy), close (ref), v138 (ref), v139 (ref)
    if v139 or v138 then
        return
    end

    v139 = true
    v138 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    PanelFocus.MakeWay(function() -- line: 960
        -- upvalues: v138 (ref)
        return v138
    end)
    List.CanvasPosition = Vector2.zero
    popCards()
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    PanelFocus.Focus(true)

    local tween = TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 967
        -- upvalues: v139 (ref)
        v139 = false
    end)
    tween:Play()
    PadMenu.Open(Panel, function() -- line: 969
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close
    })
end

local function close2() -- line: 971
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), List (copy), Detail (copy), Scale3 (copy), v61 (ref), v66 (ref), v67 (ref), PadMenu (copy), clearOpening (copy), KeysInfo (copy), v130 (ref), v131 (ref), v138 (ref), v139 (ref)
    if v139 or not v138 then
        return
    end

    v139 = true
    v138 = false
    PadMenu.Close(Detail)
    PadMenu.Close(Panel)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 979
        -- upvalues: PanelFocus (copy), Panel (copy), List (copy), Detail (copy), Scale3 (copy), v61 (ref), v66 (ref), v67 (ref), PadMenu (copy), clearOpening (copy), KeysInfo (copy), v130 (ref), v131 (ref), v139 (ref)
        Panel.Visible = false
        Detail.Visible = false
        List.Visible = true
        v67 = nil
        Scale3.Scale = 1
        v61 = nil
        v66 = false
        clearOpening()

        if v130 then
            PadMenu.Close(KeysInfo)
            v130 = false
            v131 = false
            KeysInfo.Visible = false
        end

        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 985
            -- upvalues: v139 (ref)
            v139 = false
        end)
    end)
    tween:Play()
end

close = close2
closeDetail = closeDetail2
Button.Activated:Connect(open)
Close.Activated:Connect(close2)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 994
    -- upvalues: PanelFocus (copy), Panel (copy), List (copy), Detail (copy), Scale3 (copy), v61 (ref), v66 (ref), v67 (ref), PadMenu (copy), clearOpening (copy), KeysInfo (copy), v130 (ref), v131 (ref), v138 (ref), v139 (ref)
    if not v138 then
        return
    end

    v138 = false
    v139 = false
    PadMenu.Close(Detail)
    PadMenu.Close(Panel)
    PanelFocus.Focus(false, true)
    Panel.Visible = false
    Detail.Visible = false
    List.Visible = true
    v67 = nil
    Scale3.Scale = 1
    v61 = nil
    v66 = false
    clearOpening()

    if v130 then
        PadMenu.Close(KeysInfo)
        v130 = false
        v131 = false
        KeysInfo.Visible = false
    end

    PanelFocus.GiveBackRight()
end)

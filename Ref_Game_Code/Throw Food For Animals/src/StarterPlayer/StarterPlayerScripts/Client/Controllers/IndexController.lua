-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Config.UITheme)

local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local AnimalEconomy = require(ReplicatedStorage.Config.AnimalEconomy)
local AnimalsData = require(ReplicatedStorage.AnimalsData)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local HUDController = require(Parent.HUDController)
local ClientState = require(Parent.ClientState)
local t1 = {}
local v1 = Color3.fromRGB(120, 235, 70)
local v2 = Color3.fromRGB(60, 180, 30)
local v3, v4, ScrollingFrame, v5, v6
local t2 = {}
local v7 = false

local function discovered() -- line: 51
    -- upvalues: DataController (copy)
    return DataController:Get("Index") or {}
end

local function layoutSection(p1, p2) -- line: 59
    local v10 = math.max(4, (math.round(p2 * 0.012)))
    local v12 = math.round(p2 * 0.19)
    local v13 = v12 + v10 * 2
    local v15 = math.floor((p2 - v13 - v10 - v10 * 3) / 4)
    local v17 = math.floor(v15 * 0.92)
    local v19 = math.floor(v17 * 0.36)
    local v21 = math.ceil(#p1.Cards / 4)
    local v22 = v21 * v17 + (v21 - 1) * v10 + v10 + v19

    p1.Frame.Size = UDim2.new(1, 0, 0, v22)
    p1.Tile.Size = UDim2.fromOffset(v12, v22)

    for v23, v24 in ipairs(p1.Cards) do
        local v25 = (v23 - 1) % 4
        local v27 = math.floor((v23 - 1) / 4)

        v24.Frame.Size = UDim2.fromOffset(v15, v17)
        v24.Frame.Position = UDim2.fromOffset(v13 + v25 * (v15 + v10), v27 * (v17 + v10))
    end

    p1.Bar.Size = UDim2.fromOffset(v15 * 4 + v10 * 3, v19)
    p1.Bar.Position = UDim2.fromOffset(v13, v22 - v19)
end

local function layoutAll() -- line: 81
    -- upvalues: v4 (ref), ScrollingFrame (ref), t2 (copy), layoutSection (copy)
    if not ScrollingFrame then
        return
    end

    local UIScale = v4.Root:FindFirstChildOfClass("UIScale")
    local v28, v29

    if UIScale and UIScale.Scale > 0.05 then
        local Scale = UIScale.Scale

        if Scale then
            v28 = Scale
            v29 = true
        else
            v29 = false
        end
    else
        v29 = false
    end

    if not v29 then
        v28 = 1
    end

    local v30 = ScrollingFrame.AbsoluteWindowSize.X / v28 - 6

    if not (v30 < 50) then
        for _, v31 in ipairs(t2) do
            layoutSection(v31, v30)
        end
    end
end

local function setPreview(p3, p4) -- line: 95
    -- upvalues: AnimalUtil (copy), AnimalTemplates (copy), UIKit (copy)
    if p3.Viewport and p3.Known == p4 and p3.Version == AnimalTemplates.Version() and (p3.Viewport.Model or not AnimalUtil.GetTemplate(p3.Entry.ModelName)) then
        return
    end

    if p3.Viewport then
        p3.Viewport:Destroy()
        p3.Viewport = nil
    end

    p3.Known = p4
    p3.Version = AnimalTemplates.Version()

    local v32 = UIKit.Viewport({
        ZIndex = 7,
        Rotate = false,
        Yaw = -0.6108652381980153,
        Pitch = -0.20943951023931956,
        Padding = 1.05,
        Parent = p3.Frame,
        Size = UDim2.fromScale(0.9, 0.7),
        Position = UDim2.fromScale(0.5, 0.25),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local v33 = AnimalUtil.GetTemplate(p3.Entry.ModelName) and AnimalUtil.Create(p3.Entry.ModelName)

    if v33 then
        v32:SetModel(v33, not p4)

        if p4 then
            UIKit.AnimateViewportModel(v33)
        end
    end

    p3.Viewport = v32
end

local function clearPreviews(p5) -- line: 112
    for _, v34 in ipairs(p5.Cards) do
        if v34.Viewport then
            v34.Viewport:Destroy()
            v34.Viewport = nil
        end
    end

    p5.Loaded = false
end

local function updatePreviews() -- line: 119
    -- upvalues: DataController (copy), ScrollingFrame (ref), t2 (copy), v7 (ref), setPreview (copy), clearPreviews (copy)
    if not (v7 and ScrollingFrame) then
        return
    end

    local v35 = DataController:Get("Index") or {}
    local Y = ScrollingFrame.AbsolutePosition.Y
    local Y2 = ScrollingFrame.AbsoluteWindowSize.Y

    for _, v36 in ipairs(t2) do
        local v37 = v36.Frame.AbsolutePosition.Y - Y

        if v37 + v36.Frame.AbsoluteSize.Y > -Y2 and v37 < Y2 * 2 then
            v36.Loaded = true

            for _, v38 in ipairs(v36.Cards) do
                setPreview(v38, v35[v38.Entry.ModelName] == true and not v36.Cover)
            end
        elseif v36.Loaded then
            clearPreviews(v36)
        end
    end
end

local function refresh() -- line: 143
    -- upvalues: DataController (copy), v5 (ref), v6 (ref), t2 (copy), updatePreviews (copy)
    local v40 = DataController:Get("Index") or {}
    local n1 = 0
    local n2 = 0

    for _, v41 in ipairs(t2) do
        local n3 = 0

        for _, v42 in ipairs(v41.Cards) do
            local v43 = v40[v42.Entry.ModelName] == true

            if v43 then
                n3 += 1
            end

            v42.Name.Text = v43 and not v41.Cover and v42.Entry.Name or "???"
        end

        if not v41.Cover then
            n1 += #v41.Cards
            n2 += n3
        end

        local v44 = #v41.Cards > 0 and n3 / #v41.Cards or 0

        v41.Fill.Size = UDim2.fromScale(v44, 1)
        v41.Fill.Visible = n3 > 0
        v41.Count.Text = n3 .. "/" .. #v41.Cards
    end

    local v45 = v5

    v45.Size = UDim2.fromScale(n1 > 0 and n2 / n1 or 0, 1)

    local v46 = v5

    v46.Visible = n2 > 0

    local v47 = v6

    v47.Text = "Unlocked: " .. n2 .. "/" .. n1
    updatePreviews()
end

local function progressBar(p6, p7, p8) -- line: 173
    -- upvalues: UIKit (copy), v1 (copy), v2 (copy)
    local v48 = UIKit.Frame({
        Corner = 10,
        Stroke = 3,
        Clip = true,
        Parent = p6,
        Name = p7,
        Color = Color3.fromRGB(26, 26, 32),
        StrokeColor = Color3.new(0, 0, 0),
        ZIndex = p8
    })

    return v48, UIKit.Frame({
        Name = "Fill",
        Corner = 10,
        Parent = v48,
        Size = UDim2.fromScale(0, 1),
        Color = v1,
        Gradient = { v1, v2, 90 },
        ZIndex = p8 + 1
    }), (UIKit.Text({
        Name = "Count",
        Text = "0/0",
        Stroke = 3,
        Parent = v48,
        Size = UDim2.fromScale(0.6, 0.72),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = p8 + 2
    }))
end

local function buildSection(p9, p10) -- line: 180
    -- upvalues: AnimalEconomy (copy), AnimalsData (copy), UIKit (copy), ScrollingFrame (ref), t2 (copy), progressBar (copy)
    local v49 = UIKit.Frame({
        Transparency = 1,
        ZIndex = 5,
        Parent = ScrollingFrame,
        Name = p9.Key
    })

    v49.LayoutOrder = p10

    local v50 = UIKit.Frame({
        Name = "Tile",
        Corner = 12,
        Stroke = 3,
        ZIndex = 6,
        Parent = v49,
        Color = p9.Color,
        StrokeColor = Color3.new(0, 0, 0),
        Gradient = {
            p9.Color,
            p9.Color:Lerp(Color3.new(0, 0, 0), 0.35),
            90
        }
    })

    UIKit.Stripes(v50, 20, 0.92, 12)
    UIKit.Text({
        Name = "AreaName",
        ZIndex = 8,
        Stroke = 3,
        Parent = v50,
        Text = p9.Name,
        Size = UDim2.fromScale(0.9, 0.16),
        Position = UDim2.fromScale(0.5, 0.05),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    UIKit.Text({
        Name = "Emoji",
        ZIndex = 8,
        Stroke = false,
        Parent = v50,
        Text = p9.Emoji or "",
        Size = UDim2.fromScale(0.8, 0.8),
        Position = UDim2.fromScale(0.5, 0.6),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }).SizeConstraint = Enum.SizeConstraint.RelativeXX

    local t3 = {
        Area = p9,
        Frame = v49,
        Tile = v50,
        Cards = {}
    }

    for v51, v52 in ipairs(AnimalsData[p9.Key] or {}) do
        local v53 = AnimalEconomy.Get(v52.ModelName) or {
            Rarity = "Common"
        }
        local v54 = UIKit.Card({
            ZIndex = 6,
            Parent = v49,
            Name = "Card" .. v51,
            Rarity = v53.Rarity
        })
        local v55 = UIKit.Text({
            Name = "AnimalName",
            Text = "???",
            ZIndex = 9,
            Stroke = 3,
            Parent = v54,
            Size = UDim2.fromScale(0.92, 0.18),
            Position = UDim2.fromScale(0.5, 0.04),
            AnchorPoint = Vector2.new(0.5, 0)
        })

        table.insert(t3.Cards, {
            Frame = v54,
            Name = v55,
            Entry = v52
        })
    end

    local v56, v57, v58 = progressBar(v49, "Progress", 6)

    t3.Bar = v56
    t3.Fill = v57
    t3.Count = v58
    table.insert(t2, t3)

    return t3
end

local function coverSection(p11) -- line: 203
    -- upvalues: UIKit (copy)
    if p11.Cover then
        return
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "ReleaseCover"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BackgroundTransparency = 0
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.new(1, 4, 1, 4)
    TextButton.Position = UDim2.fromScale(0.5, 0.5)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.ZIndex = 20
    TextButton.Parent = p11.Frame
    UIKit.Corner(TextButton, 12)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.06),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    UIGradient.Parent = TextButton
    UIKit.Text({
        Name = "Lead",
        Text = "NEW AREA IN",
        ZIndex = 21,
        Stroke = 3,
        Parent = TextButton,
        Size = UDim2.fromScale(0.6, 0.16),
        Position = UDim2.fromScale(0.5, 0.3),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(215, 205, 235)
    })

    local v59 = UIKit.Text({
        Name = "Time",
        Text = "",
        ZIndex = 21,
        Stroke = 4,
        Parent = TextButton,
        Size = UDim2.fromScale(0.6, 0.3),
        Position = UDim2.fromScale(0.5, 0.56),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    UIKit.Gradient(v59, Color3.fromRGB(255, 255, 255), p11.Area.Color, 90)
    p11.Cover = TextButton
    p11.CoverTime = v59
end

local function updateCovers() -- line: 232
    -- upvalues: ReleaseConfig (copy), t2 (copy)
    for _, v60 in ipairs(t2) do
        if v60.Cover then
            local v61 = ReleaseConfig.TimeLeft(v60.Area.Release)

            v60.CoverTime.Text = v61 and ReleaseConfig.FormatTime(v61) or "SOON"
        end
    end
end

local function syncCovers() -- line: 242
    -- upvalues: AreasConfig (copy), t2 (copy), coverSection (copy), updateCovers (copy)
    for _, v62 in ipairs(t2) do
        local AreaName = v62.Tile:FindFirstChild("AreaName")

        if AreasConfig.IsPlayable(v62.Area) then
            if v62.Cover then
                v62.Cover:Destroy()
                v62.Cover = nil
                v62.CoverTime = nil
            end

            if AreaName then
                AreaName.Text = v62.Area.Name
            end
        else
            coverSection(v62)

            if AreaName then
                AreaName.Text = "???"
            end

            for _, v63 in ipairs(v62.Cards) do
                v63.Name.Text = "???"
            end
        end
    end

    updateCovers()
end

local function build() -- line: 260
    -- upvalues: AreasConfig (copy), UIKit (copy), t1 (copy), v3 (ref), v4 (ref), ScrollingFrame (ref), v5 (ref), v6 (ref), layoutAll (copy), updatePreviews (copy), progressBar (copy), buildSection (copy), syncCovers (copy)
    v3 = UIKit.ScreenGui("IndexGui", 12, true)
    v3.Enabled = false
    v4 = UIKit.Panel({
        Name = "IndexPanel",
        Ratio = 1.62,
        Title = "Animal Index",
        HeaderHeight = 0.12,
        Parent = v3,
        Size = UDim2.fromScale(0.72, 0.82),
        OnClose = function() -- OnClose | line: 263
            -- upvalues: t1 (copy)
            t1.Close()
        end
    })

    local Content = v4.Content
    local ZIndex = Content.ZIndex
    local v64 = UIKit.Frame({
        Name = "Well",
        Corner = 12,
        Stroke = 3,
        Parent = Content,
        Size = UDim2.fromScale(0.96, 0.8),
        Position = UDim2.fromScale(0.5, 0.025),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(36, 36, 44),
        StrokeColor = Color3.new(0, 0, 0),
        ZIndex = ZIndex + 1
    })

    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "List"

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Size = UDim2.new(1, -12, 1, -12)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Position = UDim2.fromScale(0.5, 0.5)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.AnchorPoint = Vector2.new(0.5, 0.5)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 210)

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    local ScrollingFrame7 = ScrollingFrame

    ScrollingFrame7.ScrollingDirection = Enum.ScrollingDirection.Y

    local ScrollingFrame8 = ScrollingFrame

    ScrollingFrame8.CanvasSize = UDim2.new()

    local ScrollingFrame9 = ScrollingFrame

    ScrollingFrame9.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ScrollingFrame10 = ScrollingFrame

    ScrollingFrame10.ZIndex = ZIndex + 2
    ScrollingFrame.Parent = v64

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 18)
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 6)
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.Parent = ScrollingFrame

    for v65, v66 in ipairs(AreasConfig.All) do
        buildSection(v66, v65)
    end

    syncCovers()

    local v67 = UIKit.Frame({
        Name = "Unlocked",
        Transparency = 1,
        Parent = Content,
        Size = UDim2.fromScale(0.88, 0.12),
        Position = UDim2.fromScale(0.54, 0.975),
        AnchorPoint = Vector2.new(0.5, 1),
        ZIndex = ZIndex + 1
    })
    local v68, v69, v70 = progressBar(v67, "Bar", ZIndex + 1)

    v5 = v69
    v6 = v70
    v68.Size = UDim2.fromScale(1, 1)

    local v71 = v6

    v71.Size = UDim2.fromScale(0.8, 0.7)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Book"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://72945207836197"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(1.5, 1.5)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0, 0.5)
    ImageLabel.Rotation = -10
    ImageLabel.ZIndex = ZIndex + 5
    ImageLabel.Parent = v67
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 318
        -- upvalues: layoutAll (copy), updatePreviews (copy)
        layoutAll()
        updatePreviews()
    end)
    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updatePreviews)
end

function t1.Open() -- line: 329
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), v3 (ref), v4 (ref), v7 (ref), layoutAll (copy), updatePreviews (copy), refresh (copy)
    if v7 or ClientState.Busy or ClientState.ShopOpen or ClientState.OfflineOpen then
        return
    end

    if ClientState.ExclusiveShopOpen then
        local _require = require
        local ExclusiveShopController = script.Parent.ExclusiveShopController
        local ok, result = pcall(_require, ExclusiveShopController)

        if ok then
            result.Close()
        end
    end

    if ClientState.AnimalsOpen then
        local _require = require
        local AnimalsPanel = script.Parent.AnimalsPanel
        local ok, result = pcall(_require, AnimalsPanel)

        if ok then
            result.Close()
        end
    end

    v7 = true
    ClientState.IndexOpen = true
    v3.Enabled = true
    UIKit.PopIn(v4.Root, 0.35, 0.75)
    Sounds.Play("Slide")
    layoutAll()
    refresh()
    task.defer(function() -- line: 348
        -- upvalues: layoutAll (copy), updatePreviews (copy)
        layoutAll()
        updatePreviews()
    end)
end

function t1.Close() -- line: 354
    -- upvalues: UIKit (copy), Sounds (copy), ClientState (copy), v3 (ref), v4 (ref), t2 (copy), v7 (ref), clearPreviews (copy)
    if not v7 then
        return
    end

    v7 = false
    ClientState.IndexOpen = false
    Sounds.Play("Slide", {
        Volume = 0.2
    })
    UIKit.PopOut(v4.Root, 0.2, 0.8).Completed:Once(function() -- line: 359
        -- upvalues: v3 (ref), v4 (ref), t2 (copy), v7 (ref), clearPreviews (copy)
        if not v7 then
            v3.Enabled = false

            for _, v72 in ipairs(t2) do
                clearPreviews(v72)
            end
        end

        v4.Root.Visible = true
    end)
end

function t1.IsOpen() -- line: 368
    -- upvalues: v7 (ref)
    return v7
end

function t1.Init() -- line: 372
    -- upvalues: RunService (copy), ReleaseConfig (copy), DataController (copy), HUDController (copy), t1 (copy), v7 (ref), refresh (copy), updateCovers (copy), syncCovers (copy), build (copy)
    build()
    HUDController.IndexRequested:Connect(function() -- line: 374
        -- upvalues: t1 (copy), v7 (ref)
        if v7 then
            t1.Close()
        else
            t1.Open()
        end
    end)
    DataController:ObserveTable("Index", function() -- line: 377
        -- upvalues: v7 (ref), refresh (copy)
        if v7 then
            refresh()
        end
    end)
    ReleaseConfig.OnChanged(function() -- line: 381
        -- upvalues: v7 (ref), refresh (copy), syncCovers (copy)
        syncCovers()

        if v7 then
            refresh()
        end
    end)

    local n4 = 0

    RunService.Heartbeat:Connect(function() -- line: 387
        -- upvalues: n4 (ref), v7 (ref), updateCovers (copy)
        if v7 and not (os.clock() - n4 < 0.25) then
            n4 = os.clock()
            updateCovers()
        end
    end)
end

return t1

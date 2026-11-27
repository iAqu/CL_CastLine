-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.UIUtil)
local Viewport = require(script.Parent.Viewport)
local RarityText = require(script.Parent.RarityText)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.fromRGB(120, 128, 145)
local v4 = Color3.fromRGB(120, 255, 120)
local v5 = Color3.fromRGB(60, 150, 255)
local v6 = Color3.fromRGB(120, 255, 90)
local v7, Panel, List, SectionTemplate, CardTemplate
local v8 = {}
local t2 = {}
local t3 = {}
local v9 = false
local v10, t4, Total, BackgroundColor3

local function addBanner(p1, p2) -- line: 49
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Banner"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p2
    ImageLabel.ScaleType = Enum.ScaleType.Crop
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = p1.ZIndex

    local UICorner = p1:FindFirstChildOfClass("UICorner")

    if UICorner then
        UICorner:Clone().Parent = ImageLabel
    end

    ImageLabel.Parent = p1
    p1.Icon.Visible = false
    p1.BiomeName.ZIndex = p1.ZIndex + 1
end

local function setBar(p3, p4, p5, p6) -- line: 66
    p3.Fill.Size = UDim2.fromScale(if p5 > 0 then p4 / p5 else 0, 1)
    p3.Fill.Visible = p4 > 0
    p3.Label.Text = p6
end

local function claimedSet() -- line: 72
    -- upvalues: LocalPlayer (copy)
    local t5 = {}

    for match in string.gmatch(LocalPlayer:GetAttribute("CardsClaimed") or "", "[^,]+") do
        t5[match] = true
    end

    return t5
end

function t1.claimable() -- line: 85
    -- upvalues: Animals (copy), v8 (ref), claimedSet (copy)
    local v11 = claimedSet()
    local n1 = 0

    for _, v12 in Animals.ByBiome do
        for _, v14 in v12 do
            local Id = v14.Id

            if v8[Id] == true and not v11[Id] and Animals.cardReward(Id) ~= nil then
                n1 += 1
            end
        end
    end

    return n1
end

local function makeBadge(p7) -- line: 98
    -- upvalues: Kit (copy)
    local v15 = Kit.frame(p7, {
        Name = "Badge",
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = Color3.fromRGB(235, 50, 60),
        ZIndex = p7.ZIndex + 5
    })

    Kit.corner(v15, 15)
    Kit.stroke(v15, 2)
    Kit.text(v15, "!", {
        StrokeThickness = 2,
        Size = UDim2.fromScale(1, 1),
        ZIndex = v15.ZIndex + 1
    })

    return v15
end

local function paintDetail() -- line: 114
    -- upvalues: Config (copy), Animals (copy), AnimalModel (copy), Format (copy), Viewport (copy), RarityText (copy), Style (copy), v1 (copy), v2 (copy), v3 (copy), v8 (ref), v10 (ref), t4 (ref), claimedSet (copy)
    if not (t4 and v10) then
        return
    end

    local v16 = v10
    local v17 = Animals.get(v16)

    if not v17 then
        return
    end

    local v18 = claimedSet()
    local v19 = v8[v16] == true
    local v20 = Config.RarityByName[v17.Rarity]

    if t4.shown ~= v16 then
        t4.shown = v16

        for _, child in t4.view:GetChildren() do
            if child:IsA("Model") or child:IsA("Camera") then
                child:Destroy()
            end
        end

        local v21 = AnimalModel.clone(v16, 4)

        if v21 then
            Viewport.show(t4.view, v21, 50, 0.85)
        end
    end

    local view = t4.view

    if v19 then
        view.ImageColor3 = v1
    else
        view.ImageColor3 = v2
    end

    local name = t4.name

    if v19 then
        name.Text = v17.Name
    else
        name.Text = "???"
    end

    t4.rarity.Text = v17.Rarity

    if v20 then
        RarityText.apply(t4.rarity, v20)
    end

    local rate = t4.rate

    if v19 then
        rate.Text = ("%*/s"):format((Format.money(v17.Income)))
    else
        rate.Text = "$???/s"
    end

    local v22, v23 = Animals.cardReward(v16)

    t4.cash.Text = Format.money(v22 or 0)
    t4.xp.Text = ("+%*"):format((Format.short(v23 or 0)))

    local Label = t4.claim.Label

    if v18[v16] then
        t4.claim.BackgroundColor3 = v3
        Label.Text = "Claimed"
    elseif v19 then
        t4.claim.BackgroundColor3 = Style.BUY
        Label.Text = "Claim!"
    else
        t4.claim.BackgroundColor3 = Color3.fromRGB(70, 78, 100)
        Label.Text = "Catch it first"
    end
end

local function select(p8) -- line: 163
    -- upvalues: v4 (copy), t3 (copy), v10 (ref), paintDetail (copy)
    if v10 and t3[v10] then
        local v24 = t3[v10]

        v24.UIStroke.Color = v24:GetAttribute("StrokeColor")
        v24.UIStroke.Thickness = v24:GetAttribute("StrokeThickness")
    end

    v10 = p8

    local v25 = t3[p8]

    if v25 then
        v25.UIStroke.Color = v4
        v25.UIStroke.Thickness = 5
    end

    paintDetail()
end

local function refresh() -- line: 178
    -- upvalues: Animals (copy), v1 (copy), v2 (copy), v5 (copy), v8 (ref), t2 (copy), t3 (copy), Total (ref), BackgroundColor3 (ref), claimedSet (copy), paintDetail (copy)
    local v26 = claimedSet()
    local n2 = 0
    local n3 = 0
    local n4 = 0

    for v27, v28 in Animals.ByBiome do
        local n5 = 0

        for _, v29 in v28 do
            local v31 = v8
            local v30 = v31[v29.Id] == true

            if v30 then
                n5 += 1
            end

            local Id = v29.Id

            if v8[Id] == true and not v26[Id] and Animals.cardReward(Id) ~= nil then
                n2 += 1
            end

            local v32 = t3[v29.Id]

            if v32 then
                local NameLabel = v32.NameLabel

                if v30 then
                    NameLabel.Text = v29.Name
                else
                    NameLabel.Text = "???"
                end

                local Viewport = v32.Viewport

                if v30 then
                    Viewport.ImageColor3 = v1
                else
                    Viewport.ImageColor3 = v2
                end

                local Badge = v32.Badge
                local Id = v29.Id

                if v8[Id] == true then
                    Badge.Visible = not v26[Id] and Animals.cardReward(Id) ~= nil
                else
                    Badge.Visible = false
                end
            end
        end

        local v33 = t2[v27]

        if v33 then
            local Progress = v33.Progress
            local v34 = #v28
            local v35 = ("%*/%*"):format(n5, #v28)

            Progress.Fill.Size = UDim2.fromScale(if v34 > 0 then n5 / v34 else 0, 1)
            Progress.Fill.Visible = n5 > 0
            Progress.Label.Text = v35
        end

        n3 += n5
        n4 += #v28
    end

    if Total then
        if n2 > 0 then
            Total.BackgroundColor3 = v5
            Total.Fill.Visible = false
            Total.Label.Text = ("Claim! (%*)"):format(n2)
        else
            Total.BackgroundColor3 = BackgroundColor3

            local Total2 = Total
            local v36 = ("Unlocked: %*/%*"):format(n3, n4)

            Total2.Fill.Size = UDim2.fromScale(if n4 > 0 then n3 / n4 else 0, 1)
            Total2.Fill.Visible = n3 > 0
            Total2.Label.Text = v36
        end
    end

    paintDetail()
end

local function build() -- line: 219
    -- upvalues: Config (copy), Animals (copy), AnimalModel (copy), UIUtil (copy), Viewport (copy), RarityText (copy), v1 (copy), Panel (ref), List (ref), SectionTemplate (ref), CardTemplate (ref), v8 (ref), t2 (copy), t3 (copy), v9 (ref), addBanner (copy), claimedSet (copy), makeBadge (copy), select (copy), refresh (copy)
    v9 = true

    local Offset = SectionTemplate.Grid.UIGridLayout.CellPadding.Y.Offset
    local v37 = SectionTemplate.Size.Y.Offset - SectionTemplate.Grid.Size.Y.Offset
    local v38

    for v39, v40 in Animals.ByBiome do
        local v41 = Config.Biomes[v39]
        local clone = SectionTemplate:Clone()

        clone.Name = "Biome" .. v39
        clone.LayoutOrder = v39
        clone.Visible = true
        clone.Biome.Size = UDim2.new(0, 160, 1, 0)
        clone.Biome.BackgroundColor3 = v41.Color
        clone.Biome.BiomeName.Text = v41.Name
        clone.Biome.Icon.Text = v41.Icon

        if v41.Banner then
            addBanner(clone.Biome, v41.Banner)
        end

        for _, v42 in {
                clone.Grid,
                clone.Progress
            } do
            v42.Position = UDim2.new(0, 172, v42.Position.Y.Scale, v42.Position.Y.Offset)
            v42.Size = UDim2.new(1, -172, v42.Size.Y.Scale, v42.Size.Y.Offset)
        end

        clone.Parent = List

        local v43 = Panel.AbsoluteSize.X / 1180
        local v45 = math.floor(((if v43 > 0 then clone.Grid.AbsoluteSize.X / v43 else 600) - 3 * Offset) / 4)
        local v47 = math.floor(v45 * 0.8823529411764706)

        clone.Grid.UIGridLayout.CellSize = UDim2.fromOffset(v45, v47)

        local v49 = math.ceil(#v40 / 4)
        local v50 = v49 * v47 + (v49 - 1) * Offset

        clone.Grid.Size = UDim2.new(clone.Grid.Size.X, UDim.new(0, v50))
        clone.Size = UDim2.new(1, -10, 0, (math.max(v50 + v37, 220)))

        for v52, v53 in v40 do
            local clone2 = CardTemplate:Clone()

            clone2.Name = v53.Id
            clone2.LayoutOrder = v52
            clone2.Visible = true
            clone2.BackgroundColor3 = v1
            RarityText.paint(clone2, Config.RarityByName[v53.Rarity])
            clone2:SetAttribute("StrokeColor", clone2.UIStroke.Color)
            clone2:SetAttribute("StrokeThickness", clone2.UIStroke.Thickness)

            local v54 = AnimalModel.clone(v53.Id, 4)

            if v54 then
                Viewport.show(clone2.Viewport, v54, 50, 0.85)
            end

            makeBadge(clone2)

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Hit"
            TextButton.BackgroundTransparency = 1
            TextButton.Text = ""
            TextButton.Size = UDim2.fromScale(1, 1)
            TextButton.ZIndex = clone2.ZIndex + 4
            TextButton.Parent = clone2
            UIUtil.bindButton(TextButton, function() -- line: 275
                -- upvalues: v53 (copy), select (copy)
                select(v53.Id)
            end, clone2)
            clone2.Parent = clone.Grid
            t3[v53.Id] = clone2
            v38 = v38 or v53.Id
        end

        t2[v39] = clone
        task.wait()
    end

    local v55 = claimedSet()
    local Id, Id2

    for i = 1, #Config.Biomes do
        for _, v57 in Animals.ByBiome[i] or {} do
            if not Id then
                local Id2 = v57.Id

                if v8[Id2] == true and not v55[Id2] and Animals.cardReward(Id2) ~= nil then
                    Id = v57.Id
                end
            end

            local v58 = not Id2

            v58 = v58 and v8[v57.Id]

            if v58 then
                Id2 = v57.Id
            end
        end
    end

    local v60 = Id or Id2 or v38

    if v60 then
        select(v60)
    end

    refresh()
end

local function buildDetail() -- line: 306
    -- upvalues: Config (copy), Animals (copy), Remotes (copy), UIUtil (copy), Kit (copy), Style (copy), v3 (copy), v6 (copy), Panel (ref), v8 (ref), v10 (ref), t4 (ref), claimedSet (copy)
    local v61 = Kit.frame(Panel, {
        Name = "Detail",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 116),
        Size = UDim2.new(0, 300, 1, -212)
    })
    local v62 = Style.card(v61, Color3.fromRGB(225, 230, 240), {
        Name = "Card",
        Size = UDim2.new(1, 0, 0, 280)
    })
    local v63 = Kit.frame(v62, {
        Name = "ViewBackdrop",
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(95, 102, 120),
        Position = UDim2.fromOffset(14, 14),
        Size = UDim2.new(1, -28, 0, 140)
    })

    Kit.corner(v63, 10)

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Viewport"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Position = v63.Position
    ViewportFrame.Size = v63.Size
    ViewportFrame.ZIndex = 3
    ViewportFrame.Parent = v62

    local v64 = Kit.text(v62, "", {
        Name = "AnimalName",
        ZIndex = 3,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(10, 158),
        Size = UDim2.new(1, -20, 0, 42)
    })
    local v65 = Kit.text(v62, "", {
        Name = "Rarity",
        ZIndex = 3,
        StrokeThickness = 3,
        Position = UDim2.fromOffset(10, 200),
        Size = UDim2.new(1, -20, 0, 32)
    })
    local v66 = Kit.text(v62, "", {
        Name = "Rate",
        ZIndex = 3,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(10, 234),
        Size = UDim2.new(1, -20, 0, 38),
        TextColor3 = v6
    })
    local v67 = Style.card(v61, Style.KELP, {
        Name = "Rewards",
        Position = UDim2.fromOffset(0, 290),
        Size = UDim2.new(1, 0, 1, -290)
    })

    Kit.text(v67, "Rewards:", {
        ZIndex = 3,
        StrokeThickness = 3,
        Position = UDim2.fromOffset(14, 4),
        Size = UDim2.new(0, 150, 0, 26),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local function tile(p9, p10) -- line: 344
        -- upvalues: v67 (copy), Kit (copy)
        local v68 = Kit.frame(v67, {
            Name = "Tile",
            ZIndex = 3,
            Position = UDim2.new(p9, p9 == 0 and 14 or 4, 0, 32),
            Size = UDim2.new(0.5, -18, 0, 54),
            BackgroundColor3 = Color3.fromRGB(45, 48, 60)
        })

        Kit.corner(v68, 10)
        Kit.stroke(v68, 3)

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p10
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Position = UDim2.fromOffset(4, 4)
        ImageLabel.Size = UDim2.new(0, 40, 1, -8)
        ImageLabel.ZIndex = 4
        ImageLabel.Parent = v68

        return (Kit.text(v68, "", {
            ZIndex = 4,
            StrokeThickness = 3,
            Position = UDim2.fromOffset(46, 8),
            Size = UDim2.new(1, -50, 1, -16)
        }))
    end

    local v69 = tile(0, Config.Icons.Cash)
    local v70 = tile(0.5, Config.Icons.Strength)
    local v71 = Kit.button(v67, "", v3, {
        Name = "Claim",
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -10),
        Size = UDim2.new(1, -28, 0, 42)
    }, function() -- line: 373
        -- upvalues: Animals (copy), Remotes (copy), UIUtil (copy), v8 (ref), v10 (ref), claimedSet (copy)
        if v10 then
            local v72 = v10
            local v73 = claimedSet()

            if v8[v72] == true and not v73[v72] and Animals.cardReward(v72) ~= nil then
                Remotes.ClaimIndex:FireServer(v10)

                return
            end
        end

        if v10 and not v8[v10] then
            UIUtil.toast("Catch it to claim its reward!", "info")
        end
    end)

    v71.Label.ZIndex = 4
    t4 = {
        shown = nil,
        view = ViewportFrame,
        name = v64,
        rarity = v65,
        rate = v66,
        cash = v69,
        xp = v70,
        claim = v71
    }
end

function t1.isOpen() -- line: 384
    -- upvalues: v7 (ref)
    return v7 ~= nil and v7.Enabled
end

function t1.open() -- line: 388
    -- upvalues: UIUtil (copy), v7 (ref), v9 (ref), build (copy)
    UIUtil.openPanel(v7)

    if not v9 then
        task.spawn(build)
    end
end

function t1.close() -- line: 395
    -- upvalues: UIUtil (copy), v7 (ref)
    UIUtil.closePanel(v7)
end

function t1.init() -- line: 399
    -- upvalues: Remotes (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v7 (ref), Panel (ref), List (ref), SectionTemplate (ref), CardTemplate (ref), v8 (ref), v9 (ref), Total (ref), BackgroundColor3 (ref), refresh (copy), buildDetail (copy)
    v7 = UIUtil.gui("IndexPanel")
    Panel = v7.Panel
    Panel.Size = UDim2.fromOffset(1180, Panel.Size.Y.Offset)

    local Body = Panel.Body

    Body.Size = UDim2.new(1, -344, Body.Size.Y.Scale, Body.Size.Y.Offset)
    List = Body.List
    SectionTemplate = List.SectionTemplate
    CardTemplate = SectionTemplate.CardTemplate
    CardTemplate.Parent = nil
    SectionTemplate.Parent = nil
    UIUtil.bindButton(Panel.Header.Close, t1.close)
    buildDetail()
    Total = Panel.Footer.Total
    BackgroundColor3 = Total.BackgroundColor3

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "ClaimAll"
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 10
    TextButton.Parent = Total
    UIUtil.bindButton(TextButton, function() -- line: 422
        -- upvalues: Remotes (copy), t1 (copy)
        if t1.claimable() > 0 then
            Remotes.ClaimIndex:FireServer("all")
        end
    end, Total)
    Remotes.Inventory.OnClientEvent:Connect(function(_, _, p13) -- line: 427
        -- upvalues: v8 (ref), v9 (ref), refresh (copy)
        v8 = p13 or {}

        if v9 then
            refresh()
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("CardsClaimed"):Connect(function() -- line: 433
        -- upvalues: v9 (ref), refresh (copy)
        if v9 then
            refresh()
        end
    end)
end

return t1

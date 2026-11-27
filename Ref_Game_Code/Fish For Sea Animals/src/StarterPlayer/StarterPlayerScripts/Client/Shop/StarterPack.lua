-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local BoostButton = require(script.Parent.BoostButton)
local HudIcon = require(script.Parent.HudIcon)
local Offers = require(script.Parent.Offers)
local PassCycle = require(script.Parent.PassCycle)
local Style = require(script.Parent.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Left = Enum.TextXAlignment.Left
local v1 = false

local function v2() -- line: 42
    return false
end

local function v3() -- line: 45
    return false
end

local function tutorialOver() -- line: 49
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    return Tutorial ~= nil and Config.TutorialDone <= Tutorial
end

local function def(p1) -- line: 54
    -- upvalues: Products (copy)
    for _, v4 in Products.Packs do
        if v4.Key == (p1 or "StarterPack") then
            return v4
        end
    end

    return nil
end

local function bought() -- line: 63
    -- upvalues: LocalPlayer (copy)
    return table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), "StarterPack") ~= nil
end

local function piece(p2, p3, p4, p5, p6, p7, p8) -- line: 68
    -- upvalues: Kit (copy), Style (copy)
    local v5 = Kit.frame(p2, {
        Name = "Piece",
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(p4, p5),
        Size = UDim2.fromScale(p6, p6),
        Rotation = p8
    })

    if p3 then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p3
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.ZIndex = 4
        ImageLabel.Parent = v5
    end

    local v6 = Kit.text(v5, p7, {
        Name = "Badge",
        ZIndex = 6,
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.55, 0.88),
        Size = UDim2.fromScale(1.1, 0.34)
    })

    Style.gradient(v6, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))

    return v5
end

function t1.bundle(p9, p10, p11) -- line: 103
    -- upvalues: ContentProvider (copy), RunService (copy), AnimalModel (copy), Config (copy), Format (copy), Products (copy), Viewport (copy), Kit (copy), LocalPlayer (copy), piece (copy)
    local v7 = false
    local v8

    for _, v9 in Products.Packs do
        if v9.Key == (p11 or "StarterPack") then
            v8 = v9
            v7 = true
            break
        end
    end

    if not v7 then
        v8 = nil
    end

    local v10 = Kit.frame(p9, {
        Name = "Bundle",
        BackgroundTransparency = 1,
        ZIndex = 2,
        Size = UDim2.fromOffset(p10, p10)
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Shine"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://86205314584043"
    ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(1.25, 1.25)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v10

    local v11 = Kit.frame(v10, {
        Name = "Pile",
        BackgroundTransparency = 1,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(p10 * 0.8, p10 * 0.8)
    })
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Animal"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Ambient = Color3.fromRGB(200, 200, 210)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.42)
    ViewportFrame.Size = UDim2.fromScale(0.78, 0.78)
    ViewportFrame.ZIndex = 3
    ViewportFrame.Parent = v11

    local v12 = AnimalModel.clone(v8.Animal, 6)

    if v12 then
        Viewport.show(ViewportFrame, v12, 50, 0.7)

        local spawn = task.spawn
        local v13 = v8

        spawn(function() -- line: 146
            -- upvalues: ViewportFrame (copy), v12 (copy), v13 (copy), ContentProvider (copy), AnimalModel (copy), Viewport (copy)
            ContentProvider:PreloadAsync({
                v12
            })

            if v12.Parent == ViewportFrame then
                Viewport.show(ViewportFrame, AnimalModel.clone(v13.Animal, 6), 50, 0.7)
            end
        end)
    end

    local t2 = {
        piece(v11, Config.Icons.Cash, 0.2, 0.78, 0.42, "", -12),
        (piece(v11, Config.Icons.Strength, 0.8, 0.78, 0.4, "", 10))
    }
    local t3 = {
        { 0.84, 14 },
        { 0.16, -14 }
    }

    for _, v14 in Products.PackPotions do
        local v15 = v8.Potions[v14.Stat]
        local v16 = v15 and t3[1]

        if v16 then
            table.remove(t3, 1)
            table.insert(t2, (piece(v11, v14.Image, v16[1], 0.2, 0.34, `{ v15 // 60 }m`, v16[2])))
        end
    end

    local function amounts() -- line: 167
        -- upvalues: v8 (ref), t2 (copy), Format (copy), Products (copy), LocalPlayer (copy)
        local v18 = LocalPlayer:GetAttribute("Income") or 0
        local v19 = LocalPlayer:GetAttribute("StrengthRate") or 0

        t2[1].Badge.Text = Format.money(Products.packCash(v8, v18))
        t2[2].Badge.Text = ("+%* XP"):format((Format.short(Products.packStrength(v8, v19))))
    end

    amounts()

    local elapsed = os.clock()
    local v20 = p10 * 0.8

    task.spawn(function() -- line: 176
        -- upvalues: p10 (copy), v10 (copy), ImageLabel (copy), v11 (copy), t2 (copy), elapsed (copy), v20 (copy), RunService (copy)
        while v10.Parent do
            local ScreenGui = v10:FindFirstAncestorOfClass("ScreenGui")
            local v21, v22, v23, v24, v25

            if not ScreenGui or ScreenGui.Enabled then
                v21 = os.clock() - elapsed
                ImageLabel.Rotation = v21 * 35 % 360

                local v33 = v21 % 2.6

                if v33 < 0.5 then
                    v22 = -math.sin(v33 / 0.5 * 3.141592653589793) * p10 * 0.12
                    v23 = 0.94
                    v24 = 1.07
                    v25 = 0
                else
                    if v33 < 0.75 then
                        local v36 = math.sin((v33 - 0.5) / 0.25 * 3.141592653589793)

                        v23 = v36 * 0.14 + 1
                        v24 = 1 - v36 * 0.12
                        v25 = 0
                    else
                        if v33 >= 1.4 and v33 < 1.95 then
                            local v37 = (v33 - 1.4) / 0.55

                            v25 = math.sin(v37 * 3.141592653589793 * 7) * 9 * (1 - v37)
                        else
                            v25 = 0
                        end

                        v23 = 1
                        v24 = 1
                    end

                    v22 = 0
                end

                v11.Position = UDim2.new(0.5, 0, 0.5, v22)
                v11.Size = UDim2.fromOffset(v20 * v23, v20 * v24)
                v11.Rotation = v25

                for v39, v40 in t2 do
                    v40.Position = UDim2.new(v40.Position.X, UDim.new(v40.Position.Y.Scale, math.sin(v21 * 3 + v39 * 2) * p10 * 0.015))
                end

                RunService.RenderStepped:Wait()
            else
                task.wait(0.25)
            end
        end
    end)

    return v10, amounts
end

local function animalText(p12) -- line: 213
    -- upvalues: Animals (copy), Config (copy)
    local v42 = Animals.get(p12)

    if v42.Exclusive then
        return (("%* <font color=\"#FFE25A\">(%*x your best!)</font>"):format(v42.Name, v42.Mult))
    end

    local v43 = Config.RarityByName[v42.Rarity]

    return (("%* <font color=\"#%*\">(%*)</font>"):format(v42.Name, v43.Color:ToHex(), v42.Rarity))
end

local function line(p13, p14, p15, p16, p17) -- line: 222
    -- upvalues: Style (copy), Left (copy)
    local v44 = (p14 - 1) * 52 + 140
    local v45

    if p17 then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p17
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Position = UDim2.fromOffset(410, v44 - 4)
        ImageLabel.Size = UDim2.fromOffset(46, 46)
        ImageLabel.ZIndex = 3
        v45 = 54
        ImageLabel.Parent = p13
    else
        v45 = 0
    end

    local v46 = v45 + 410

    Style.text(p13, p15, {
        ZIndex = 3,
        Position = UDim2.fromOffset(v46, v44),
        Size = UDim2.fromOffset(820 - v46 - 30, 40),
        TextXAlignment = Left,
        TextColor3 = p16
    })
end

function t1.offer() -- line: 244
    -- upvalues: Animals (copy), Config (copy), Format (copy), Products (copy), UIUtil (copy), Offers (copy), Style (copy), LocalPlayer (copy), t1 (copy), Left (copy), v1 (ref), line (copy)
    local v47 = false
    local v48

    for _, v49 in Products.Packs do
        if v49.Key == "StarterPack" then
            v48 = v49
            v47 = true
            break
        end
    end

    if not v47 then
        v48 = nil
    end

    if not v48 or table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), "StarterPack") ~= nil then
        return
    end

    if Offers.show("Center", 820, 470, Style.SEAFOAM, 25, function(p18, p19) -- line: 249
        -- upvalues: v48 (ref), Animals (copy), Config (copy), Format (copy), Products (copy), Style (copy), LocalPlayer (copy), t1 (copy), Left (copy), line (copy)
        t1.bundle(p18, 380).Position = UDim2.fromOffset(16, 39)

        local v50 = Style.text(p18, "STARTER PACK", {
            StrokeThickness = 6,
            ZIndex = 3,
            Position = UDim2.fromOffset(408, 22),
            Size = UDim2.fromOffset(360, 74),
            TextXAlignment = Left
        })

        Style.gradient(v50, ColorSequence.new(Style.YELLOW, Style.GOLD))
        Style.text(p18, "The perfect head start!", {
            ZIndex = 3,
            Position = UDim2.fromOffset(410, 94),
            Size = UDim2.fromOffset(380, 32),
            TextXAlignment = Left,
            TextColor3 = Style.SAND
        })
        Style.tag(p18, "ONE TIME!", Style.CORAL, {
            Rotation = -8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(90, 18),
            Size = UDim2.fromOffset(170, 50)
        })

        local v51 = LocalPlayer:GetAttribute("Income") or 0
        local v52 = LocalPlayer:GetAttribute("StrengthRate") or 0

        line(p18, 1, Format.money(Products.packCash(v48, v51)) .. " Cash", Style.MINT, Config.Icons.Cash)
        line(p18, 2, Format.short(Products.packStrength(v48, v52)) .. " XP", Style.SAND, Config.Icons.Strength)

        local t4 = {}

        for _, v53 in Products.PackPotions do
            local v54 = v48.Potions[v53.Stat]

            if v54 then
                table.insert(t4, (("2x %* · %*m"):format(v53.Stat, v54 // 60)))
            end
        end

        line(p18, 3, "🧪 " .. table.concat(t4, " / "), Color3.fromRGB(215, 180, 255))

        local Animal = v48.Animal
        local v56 = Animals.get(Animal)
        local v57

        if v56.Exclusive then
            v57 = ("%* <font color=\"#FFE25A\">(%*x your best!)</font>"):format(v56.Name, v56.Mult)
        else
            local v58 = Config.RarityByName[v56.Rarity]

            v57 = ("%* <font color=\"#%*\">(%*)</font>"):format(v56.Name, v58.Color:ToHex(), v56.Rarity)
        end

        line(p18, 4, "🐟 " .. v57, Color3.new(1, 1, 1))
        Style.price(p18, "StarterPack", {
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 410, 1, -30),
            Size = UDim2.fromOffset(380, 76)
        }, p19)
    end) then
        v1 = true
        UIUtil.sound("Reveal", 0.5, 1.1)
    end
end

local function hudButtons() -- line: 302
    -- upvalues: ContentProvider (copy), AnimalModel (copy), Products (copy), UIUtil (copy), Viewport (copy), BoostButton (copy), HudIcon (copy), PassCycle (copy), LocalPlayer (copy), t1 (copy), v3 (ref)
    local SideRight = UIUtil.gui("HUD"):WaitForChild("SideRight")
    local Animals = SideRight:WaitForChild("Animals")
    local Offset = Animals.Size.Y.Offset
    local Offset2 = SideRight.UIListLayout.Padding.Offset
    local Offset3 = SideRight.Size.Y.Offset
    local v59 = false
    local v60

    for _, v61 in Products.Packs do
        if v61.Key == "StarterPack" then
            v60 = v61
            v59 = true
            break
        end
    end

    if not v59 then
        v60 = nil
    end

    local v62, v63 = HudIcon.new(Offset, "STARTER PACK")

    v62.Name = "StarterPack"
    v62.LayoutOrder = Animals.LayoutOrder - 1
    HudIcon.wiggle(v62)

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "Animal"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Ambient = Color3.fromRGB(200, 200, 210)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.ZIndex = 2
    ViewportFrame.Parent = v63

    local v64 = v60 and AnimalModel.clone(v60.Animal, 6)

    if v64 then
        Viewport.show(ViewportFrame, v64, 50, 0.7)

        local spawn = task.spawn
        local v65 = v60

        spawn(function() -- line: 326
            -- upvalues: ViewportFrame (copy), v64 (copy), v65 (copy), ContentProvider (copy), AnimalModel (copy), Viewport (copy)
            ContentProvider:PreloadAsync({
                v64
            })

            if v64.Parent == ViewportFrame then
                Viewport.show(ViewportFrame, AnimalModel.clone(v65.Animal, 6), 50, 0.7)
            end
        end)
    end

    v62.Visible = false
    v62.Parent = SideRight
    UIUtil.bindButton(v62, function() -- line: 335
        -- upvalues: t1 (copy)
        t1.offer()
    end)

    local v66, v67 = PassCycle.new(Offset)

    v66.LayoutOrder = v62.LayoutOrder - 1
    v66.Visible = false
    v66.Parent = SideRight
    BoostButton.init(function() -- line: 344
        -- upvalues: v3 (ref)
        return v3()
    end)

    local function refresh() -- line: 349
        -- upvalues: SideRight (copy), Offset (copy), Offset2 (copy), Offset3 (copy), v62 (copy), v66 (copy), v67 (copy), LocalPlayer (copy)
        local v68 = LocalPlayer:GetAttribute("PacksBought") ~= nil and table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), "StarterPack") == nil
        local v69 = v67()

        v62.Visible = v68
        v66.Visible = v69

        local v70 = (if v68 then 1 else 0) + (if v69 then 1 else 0)

        SideRight.Size = UDim2.new(SideRight.Size.X, UDim.new(0, Offset3 + v70 * (Offset + Offset2)))
    end

    task.spawn(function() -- line: 357
        -- upvalues: refresh (copy)
        while true do
            refresh()
            task.wait(0.25)
        end
    end)
end

function t1.setBusyCheck(p20) -- line: 365
    -- upvalues: v2 (ref)
    v2 = p20
end

function t1.setLiftingCheck(p21) -- line: 370
    -- upvalues: v3 (ref)
    v3 = p21
end

function t1.need() -- line: 376
    -- upvalues: Config (copy), Remotes (copy), LocalPlayer (copy), t1 (copy), v1 (ref)
    if v1 then
        return false
    end

    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    if Tutorial ~= nil and Config.TutorialDone <= Tutorial and table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), "StarterPack") == nil and LocalPlayer:GetAttribute("StarterPackOffered") == false then
        t1.offer()

        if v1 then
            Remotes.Tutorial:FireServer("StarterPackOffered")
        end

        return v1
    end

    return false
end

function t1.init() -- line: 389
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v2 (ref), hudButtons (copy)
    task.spawn(hudButtons)
    task.spawn(function() -- line: 391
        -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v2 (ref)
        while true do
            local Tutorial = LocalPlayer:GetAttribute("Tutorial")

            if Tutorial ~= nil and Config.TutorialDone <= Tutorial then
                break
            end

            task.wait(1)
        end

        task.wait(600)

        while true do
            if v1 then
                return
            end

            if LocalPlayer:GetAttribute("PacksBought") == nil then
                task.wait(1)
                continue
            end

            if table.find(string.split(LocalPlayer:GetAttribute("PacksBought") or "", ","), "StarterPack") == nil and LocalPlayer:GetAttribute("StarterPackOffered") == false then
                if not v2() and not UIUtil.panelMode() then
                    t1.need()
                end

                task.wait(1)
                continue
            end

            break
        end
    end)
end

return t1

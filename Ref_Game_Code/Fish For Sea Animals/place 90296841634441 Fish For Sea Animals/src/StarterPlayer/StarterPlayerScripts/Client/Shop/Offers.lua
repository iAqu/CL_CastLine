-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Products = require(ReplicatedStorage.Shared.Products)
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local Kit = require(script.Parent.Parent.MiniGames.Kit)

require(script.Parent.Robux)

local Style = require(script.Parent.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local n1 = (-1e999)
local ScreenGui, t2
local t3 = {}
local v1 = os.clock() - 1800 + 240
local v2 = true
local n2 = (-1e999)

local function v3() -- line: 54
    return false
end

local function v4() -- line: 57
    return false
end

local function v5() -- line: 60
    return false
end

local function v6() -- line: 63
    return false
end

local function dismiss(p1) -- line: 68
    -- upvalues: UIUtil (copy), t3 (copy)
    if not p1 or p1.gone then
        return
    else
        p1.gone = true

        if t3[p1.slot] == p1 then
            t3[p1.slot] = nil
        end
    end

    local body = p1.body

    UIUtil.tween(body, 0.3, {
        Position = p1.away
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)

    if p1.dim then
        UIUtil.tween(p1.dim, 0.3, {
            BackgroundTransparency = 1
        })
    end

    task.delay(0.3, function() -- line: 81
        -- upvalues: p1 (copy)
        p1.root:Destroy()

        if p1.onClosed then
            task.spawn(p1.onClosed)
        end
    end)
end

function t1.isShowing(p2) -- line: 89
    -- upvalues: t3 (copy)
    return t3[p2] ~= nil
end

function t1.luckCardArea() -- line: 95
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    if not ScreenGui then
        return 1e999, (-1e999)
    end

    local scale = UIUtil.scale

    return ScreenGui.AbsolutePosition.X + ScreenGui.AbsoluteSize.X / 2 - 468 * scale / 2, ScreenGui.AbsolutePosition.Y + 211 * scale
end

function t1.show(p3, p4, p5, p6, p7, p8) -- line: 107
    -- upvalues: UIUtil (copy), Kit (copy), Style (copy), ScreenGui (ref), t2 (ref), t3 (copy), dismiss (copy)
    local v8

    if not ScreenGui or t3[p3] then
        return nil
    else
        v8 = if p3 == "Center" then UDim2.fromOffset(0, 1400) else UDim2.new(0.5, 0, 0, -p5 - 320)
    end

    local t4 = {
        slot = p3,
        duration = p7,
        left = p7,
        away = v8
    }

    t3[p3] = t4

    local v10 = Kit.frame(t2[p3], {
        Name = "Card",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    t4.root = v10

    if p3 == "Top" then
        v10.AnchorPoint = Vector2.new(0.5, 0)
        v10.Position = UDim2.fromScale(0.5, 0)

        local UIScale = Instance.new("UIScale")

        UIScale.Name = "Zoom"
        UIScale.Scale = 1.3
        UIScale.Parent = v10
    end

    if p3 == "Center" then
        t4.dim = Kit.frame(v10, {
            Name = "Dim",
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(8000, 8000)
        })
        UIUtil.tween(t4.dim, 0.35, {
            BackgroundTransparency = 0.55
        })
    end

    local v11 = Style.card(v10, p6, {
        Name = "Body",
        AnchorPoint = if p3 == "Center" then Vector2.new(0.5, 0.5) else Vector2.new(0.5, 0),
        Size = UDim2.fromOffset(p4, p5),
        Position = v8
    })

    t4.body = v11

    local function close() -- line: 144
        -- upvalues: t4 (copy), dismiss (copy)
        dismiss(t4)
    end

    local v12 = Kit.frame(v11, {
        Name = "Timer",
        BackgroundTransparency = 0.3,
        ZIndex = 6,
        BackgroundColor3 = Style.DEEP,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, -28, 0, 7)
    })

    Kit.corner(v12, 7)

    local v13 = Kit.frame(v12, {
        Name = "Fill",
        ZIndex = 7,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromScale(1, 1)
    })

    Kit.corner(v13, 7)
    Style.gradient(v13, ColorSequence.new(Style.YELLOW, Style.GOLD), 0)
    t4.fill = v13
    Kit.button(v11, "X", Color3.fromRGB(225, 70, 70), {
        Name = "Close",
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.fromOffset(p3 == "Center" and 54 or 34, p3 == "Center" and 54 or 34)
    }, close).Label.ZIndex = 9
    p8(v11, close)

    local v15 = if p3 == "Center" then UDim2.fromOffset(0, 0) else UDim2.fromScale(0.5, 0)

    UIUtil.tween(v11, 0.45, {
        Position = v15
    }, Enum.EasingStyle.Back)

    local v16 = Kit.frame(v11, {
        Name = "Glint",
        BackgroundTransparency = 0.6,
        Rotation = 20,
        ZIndex = 10,
        Interactable = false,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(0, -80, 0, -30),
        Size = UDim2.new(0, 30, 1, 60)
    })

    v11.ClipsDescendants = true
    task.delay(0.45, function() -- line: 189
        -- upvalues: v11 (copy), v16 (copy), UIUtil (copy)
        UIUtil.tween(v16, 0.55, {
            Position = UDim2.new(1, 50, 0, -30)
        }, Enum.EasingStyle.Sine)
        task.wait(0.55)
        v16:Destroy()
        v11.ClipsDescendants = false
    end)
    UIUtil.sound("GoodCast", 0.4, 1.15)

    return t4
end

local t7 = {
    NextRod = function() -- NextRod | line: 201
        -- upvalues: Config (copy), RodBuilder (copy), Viewport (copy), LocalPlayer (copy)
        local n3 = 1

        for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
            n3 = math.max(n3, tonumber(match) or 1)
        end

        local v18 = n3 + 1
        local v19 = Config.Rods[v18]

        return if v19 then {
            name = v19.Name,
            price = Config.rodPrice(v18, LocalPlayer:GetAttribute("LegacyPrices") == true),
            color = Config.RarityByName[v19.Rarity].Color,
            picture = function(p9) -- picture | line: 215
                -- upvalues: v18 (copy), RodBuilder (copy), Viewport (copy)
                local v20 = RodBuilder.build(v18)

                v20:PivotTo(CFrame.Angles(0.7853981633974483, 0, 0))
                Viewport.show(p9, v20, 90, 0.45)
            end
        } else nil
    end,
    NextBarbell = function() -- NextBarbell | line: 222
        -- upvalues: ReplicatedStorage (copy), Config (copy), Products (copy), Viewport (copy), LocalPlayer (copy)
        local v21 = (LocalPlayer:GetAttribute("BarbellTier") or 1) + 1
        local v22 = Config.Barbells[v21]
        local v23 = if v22 then Config.barbellPrice(v21, LocalPlayer:GetAttribute("LegacyPrices") == true) else 0

        return if v22 and Products.canSkipBarbell(v23, LocalPlayer:GetAttribute("Income") or 0) then {
            name = ("Barbell Tier %*"):format(v21),
            price = v23,
            color = Color3.fromRGB(235, 80, 70),
            picture = function(p10) -- picture | line: 234
                -- upvalues: v22 (copy), ReplicatedStorage (copy), Viewport (copy)
                local v24 = ReplicatedStorage.Assets.Barbells:FindFirstChild(v22.Model)

                if not v24 then
                    return
                end

                local clone = v24:Clone()

                clone:PivotTo(CFrame.new())
                Viewport.show(p10, clone, 20, 0.8)
            end
        } else nil
    end
}

local function pictureTile(p11, p12, p13) -- line: 246
    -- upvalues: Kit (copy)
    local v25 = Kit.frame(p11, {
        Name = "Picture",
        ZIndex = 2,
        BackgroundColor3 = p12,
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(p13, p13)
    })

    Kit.corner(v25, 14)
    Kit.stroke(v25, 3)
    Kit.shade(v25, 0.6)

    return v25
end

local function upgradeCard(p14) -- line: 260
    -- upvalues: Format (copy), Style (copy), LocalPlayer (copy), t1 (copy), v1 (ref), t7 (copy), pictureTile (copy)
    local v26 = t7[p14]()

    if v26 and not ((LocalPlayer:GetAttribute("Money") or 0) >= v26.price) and t1.show("Top", 360, 150, Style.PURPLE, 12, function(p15, p16) -- line: 265
        -- upvalues: p14 (copy), v26 (copy), Format (copy), Style (copy), LocalPlayer (copy), pictureTile (copy)
        local v27 = pictureTile(p15, v26.color, 120)
        local ViewportFrame = Instance.new("ViewportFrame")

        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.Size = UDim2.fromScale(1, 1)
        ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
        ViewportFrame.LightDirection = Vector3.new(-1, -1, -0.5)
        ViewportFrame.ZIndex = 3
        ViewportFrame.Parent = v27
        v26.picture(ViewportFrame)

        local v28 = Style.text(p15, "SKIP THE GRIND!", {
            StrokeThickness = 4,
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 10),
            Size = UDim2.fromOffset(186, 30),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Style.gradient(v28, ColorSequence.new(Style.YELLOW, Style.GOLD))
        Style.text(p15, v26.name, {
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 42),
            Size = UDim2.fromOffset(202, 28),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local v29 = v26.price - (LocalPlayer:GetAttribute("Money") or 0)

        Style.text(p15, ("Need %* more"):format((Format.money(v29))), {
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 72),
            Size = UDim2.fromOffset(202, 22),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Style.SAND
        })
        Style.price(p15, p14, {
            ZIndex = 4,
            Position = UDim2.fromOffset(144, 98),
            Size = UDim2.fromOffset(200, 36),
            BackgroundColor3 = Style.BUY
        }, p16)
    end) then
        v1 = os.clock()
    end
end

function t1.needRod() -- line: 291
    -- upvalues: t1 (copy), n1 (ref), upgradeCard (copy)
    if not (os.clock() - n1 < 300 or t1.isShowing("Top")) then
        n1 = os.clock()
        upgradeCard("NextRod")
    end
end

local function luckCard() -- line: 300
    -- upvalues: RunService (copy), Config (copy), Products (copy), Style (copy), t1 (copy)
    local v30 = (workspace:GetAttribute("ServerLuckUntil") or 0) - workspace:GetServerTimeNow() > 0 and workspace:GetAttribute("ServerLuckMult") or 1

    if Products.ServerLuckMax <= v30 then
        return false
    end

    local v31, v32 = Products.serverLuckOffer(v30)
    local v33 = t1.show("Top", 360, 150, Style.SEAFOAM, 12, function(p17, p18) -- line: 307
        -- upvalues: v30 (copy), v31 (copy), v32 (copy), RunService (copy), Config (copy), Products (copy), Style (copy)
        local v34 = Style.bubble(p17, "", {
            ZIndex = 2,
            Position = UDim2.fromOffset(12, 12),
            Size = UDim2.fromOffset(120, 120)
        })
        local v35 = Style.icon(v34, Config.Icons.Luck)

        task.spawn(function() -- line: 310
            -- upvalues: v35 (copy), RunService (copy)
            while v35.Parent do
                v35.Rotation = math.sin(os.clock() * 3) * 12
                RunService.RenderStepped:Wait()
            end
        end)

        local v37 = Style.text(p17, "SERVER LUCK!", {
            StrokeThickness = 4,
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 8),
            Size = UDim2.fromOffset(186, 30),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Style.gradient(v37, ColorSequence.new(Color3.new(1, 1, 1), Style.MINT))
        Style.text(p17, ("%*x  ›  <font color=\"#FFE25A\">%*x</font> Luck"):format(v30, v32), {
            StrokeThickness = 4,
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 40),
            Size = UDim2.fromOffset(202, 32),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Style.text(p17, `+{ Products.ServerLuckTime // 60 } min for EVERYONE`, {
            ZIndex = 3,
            Position = UDim2.fromOffset(144, 74),
            Size = UDim2.fromOffset(202, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Style.SAND
        })
        Style.price(p17, v31, {
            ZIndex = 4,
            Position = UDim2.fromOffset(144, 98),
            Size = UDim2.fromOffset(200, 36)
        }, p18)
    end)

    if v33 then
        v33.untilCast = true
        v33.root.Position = UDim2.new(0.5, 0, 0, -96)
    end

    return v33 ~= nil
end

function t1.luckMoment() -- line: 332
    -- upvalues: v2 (ref), n2 (ref)
    if os.clock() - n2 >= 600 then
        v2 = true
    end
end

function t1.escapeSave(p19) -- line: 341
    -- upvalues: Config (copy), Format (copy), Animals (copy), AnimalModel (copy), UIUtil (copy), Viewport (copy), Style (copy), t1 (copy), pictureTile (copy)
    local v38 = Animals.get(p19.Id)
    local v39 = v38 and Config.RarityByName[v38.Rarity]

    if not v39 then
        return
    end

    local v40 = t1.show("Center", 660, 330, Style.CORAL, 12, function(p20, p21) -- line: 347
        -- upvalues: p19 (copy), v38 (copy), v39 (copy), Format (copy), AnimalModel (copy), Viewport (copy), Style (copy), pictureTile (copy)
        local v41 = pictureTile(p20, v39.Color, 270)

        v41.Position = UDim2.fromOffset(22, 26)

        local ViewportFrame = Instance.new("ViewportFrame")

        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.Size = UDim2.fromScale(1, 1)
        ViewportFrame.Ambient = Color3.fromRGB(200, 200, 210)
        ViewportFrame.LightColor = Color3.new(1, 1, 1)
        ViewportFrame.LightDirection = Vector3.new(-1, -1, -1)
        ViewportFrame.ZIndex = 3
        ViewportFrame.Parent = v41

        local v42 = AnimalModel.clone(p19.Id, 6)

        if v42 then
            Viewport.show(ViewportFrame, v42, 50, 0.7)
        end

        local Left = Enum.TextXAlignment.Left
        local v43 = Style.text(p20, "IT GOT AWAY!", {
            StrokeThickness = 6,
            ZIndex = 3,
            Position = UDim2.fromOffset(314, 22),
            Size = UDim2.fromOffset(292, 60),
            TextXAlignment = Left
        })

        Style.gradient(v43, ColorSequence.new(Color3.fromRGB(255, 150, 150), Color3.fromRGB(255, 70, 80)))
        Style.text(p20, ("%* <font color=\"#%*\">(%*)</font>"):format(v38.Name, v39.Color:ToHex(), v38.Rarity), {
            ZIndex = 3,
            Position = UDim2.fromOffset(314, 88),
            Size = UDim2.fromOffset(322, 38),
            TextXAlignment = Left
        })
        Style.text(p20, ("1 in %*"):format((Format.short(p19.Odds or 0))), {
            ZIndex = 3,
            Position = UDim2.fromOffset(314, 130),
            Size = UDim2.fromOffset(322, 30),
            TextXAlignment = Left,
            TextColor3 = Style.YELLOW
        })
        Style.text(p20, "PULL IT BACK!", {
            ZIndex = 3,
            Position = UDim2.fromOffset(314, 172),
            Size = UDim2.fromOffset(322, 34),
            TextXAlignment = Left,
            TextColor3 = Style.SAND
        })
        Style.price(p20, "Revive", {
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 314, 1, -30),
            Size = UDim2.fromOffset(322, 76)
        }, p21)
    end)

    if v40 then
        v40.untilCast = true
        UIUtil.sound("Reveal", 0.5, 0.9)
    end
end

function t1.setBusyCheck(p22) -- line: 379
    -- upvalues: v3 (ref)
    v3 = p22
end

function t1.setFishingCheck(p23) -- line: 384
    -- upvalues: v4 (ref)
    v4 = p23
end

function t1.setCastingCheck(p24) -- line: 389
    -- upvalues: v5 (ref)
    v5 = p24
end

function t1.setLuckHeldCheck(p25) -- line: 394
    -- upvalues: v6 (ref)
    v6 = p25
end

local function unaffordable() -- line: 399
    -- upvalues: LocalPlayer (copy), t7 (copy)
    local v44 = LocalPlayer:GetAttribute("Money") or 0
    local t10 = {}

    for v45, v46 in t7 do
        local v47 = v46()

        if v47 and v44 < v47.price then
            table.insert(t10, v45)
        end
    end

    return t10
end

function t1.init() -- line: 411
    -- upvalues: RunService (copy), UIUtil (copy), Kit (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), t2 (ref), t3 (copy), v1 (ref), v2 (ref), n2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), dismiss (copy), t7 (copy), upgradeCard (copy), luckCard (copy), unaffordable (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Offers"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 9

    local v48 = Kit.frame(ScreenGui, {
        Name = "Top",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 112),
        Size = UDim2.fromOffset(360, 150)
    })
    local v49 = Kit.frame(ScreenGui, {
        Name = "Center",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0)
    })

    for _, v50 in { v48, v49 } do
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "Scale"
        UIScale.Parent = v50
    end

    t2 = {
        Top = v48,
        Center = v49
    }
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    UIUtil.onScale(function(p26) -- line: 440
        -- upvalues: v48 (copy)
        v48.Position = UDim2.new(0.5, 0, 0, (math.round(112 * p26)))
    end)
    RunService.Heartbeat:Connect(function(p27) -- line: 445
        -- upvalues: UIUtil (copy), t2 (ref), t3 (copy), v5 (ref), dismiss (copy)
        local v52 = UIUtil.panelMode()

        for _, v53 in t2 do
            v53.Visible = not v52
        end

        if not v52 then
            for _, v54 in t3 do
                if v54.untilCast and v5() then
                    dismiss(v54)
                else
                    v54.left -= p27
                    v54.fill.Size = UDim2.fromScale(math.max(v54.left / v54.duration, 0), 1)

                    if v54.left <= 0 then
                        dismiss(v54)
                    end
                end
            end
        end
    end)
    task.spawn(function() -- line: 467
        -- upvalues: UIUtil (copy), v1 (ref), v3 (ref), upgradeCard (copy), unaffordable (copy)
        while true do
            task.wait(45)

            if os.clock() - v1 >= 1800 and not v3() and not UIUtil.panelMode() and math.random() < 0.4 then
                local v56 = unaffordable()

                if #v56 > 0 then
                    upgradeCard(v56[math.random(#v56)])
                end
            end
        end
    end)
    task.spawn(function() -- line: 480
        -- upvalues: v2 (ref), n2 (ref), v4 (ref), v5 (ref), v6 (ref), luckCard (copy)
        local v58 = false
        local v57

        while true do
            task.wait(0.5)

            if v4() and not v5() and not v6() then
                local v59 = v57 or os.clock()

                if not v58 and v2 and os.clock() - v59 >= 1.5 then
                    v58 = luckCard()

                    if v58 then
                        v2 = false
                        n2 = os.clock()
                    end
                end

                v57 = v59
                continue
            end

            v57 = nil
            v58 = false
        end
    end)
    workspace:GetAttributeChangedSignal("ServerLuckUntil"):Connect(t1.luckMoment)

    if RunService:IsStudio() then
        LocalPlayer:GetAttributeChangedSignal("OfferTest"):Connect(function() -- line: 505
            -- upvalues: LocalPlayer (copy), t1 (copy), t7 (copy), upgradeCard (copy), luckCard (copy)
            local OfferTest = LocalPlayer:GetAttribute("OfferTest")

            if OfferTest == "Luck" then
                luckCard()
            elseif t7[OfferTest] then
                upgradeCard(OfferTest)
            elseif type(OfferTest) == "string" and OfferTest ~= "" then
                t1.escapeSave({
                    Odds = 12345,
                    Id = OfferTest
                })
            end
        end)
    end
end

return t1

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ButtonHover = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ButtonHover"))
local LocalPlayer = Players.LocalPlayer
local MenuButtons = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuButtons")
local _ = {
    ICON_TILT = 20,
    PANEL_CORNER = 0.135,
    HIGHLIGHT_FADE = 0.8,
    BURST_LAP = 20,
    BREATHE_MAX = 1.1,
    BREATHE_TIME = 1
}
local t1 = {
    IN = 0.18,
    HOLD = 0.12,
    OUT = 0.45,
    SPIN = 90,
    POOL = 4,
    EVERY = { 0.6, 1.2 },
    SIZE = { 0.14, 0.26 },
    AREA_X = { 0.18, 0.82 },
    AREA_Y = { 0.14, 0.72 }
}
local _ = {
    OUT = 0.12,
    IN = 0.28
}
local v1 = Random.new()

for _, v2 in ipairs({ "ShopSlot", "CrateSlot", "IndexSlot" }) do
    local Button = MenuButtons:WaitForChild(v2):WaitForChild("Button")

    ButtonHover.Attach(Button, {
        tile = 1,
        iconTilt = 20,
        highlight = true,
        highlightCorner = 0.135,
        highlightFade = 0.8,
        icon = Button:WaitForChild("Icon"),
        shine = v2 == "ShopSlot"
    })
    Button.Activated:Connect(function() -- line: 72
        -- upvalues: ButtonHover (copy), Button (copy)
        ButtonHover.Press(Button)
    end)
end

local SmallRow = MenuButtons:WaitForChild("SmallRow")
local Activated

for _, v3 in ipairs({ "SettingsSlot", "HarpoonSlot" }) do
    local Button = SmallRow:WaitForChild(v3):WaitForChild("Button")

    ButtonHover.Attach(Button, {
        shine = false,
        tile = 1,
        iconTilt = 20,
        highlight = true,
        highlightCorner = 0.135,
        highlightFade = 0.8,
        icon = Button:WaitForChild("Icon")
    })
    Activated = Button.Activated
    Activated:Connect(function() -- line: 78
        -- upvalues: ButtonHover (copy), Button (copy)
        ButtonHover.Press(Button)
    end)
end

local Burst = MenuButtons.ShopSlot.Button:WaitForChild("Burst")

TweenService:Create(Burst, TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
    Rotation = Burst.Rotation + 360
}):Play()
TweenService:Create(Burst, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Size = UDim2.fromScale(1.1, 1.1)
}):Play()

local Button = MenuButtons.ShopSlot.Button
local Sparkle = Button:WaitForChild("Sparkle")
local t2 = {}

for i = 1, t1.POOL do
    Activated = Sparkle:Clone()
    Activated.Name = "Sparkle" .. i
    Activated.Parent = Button
    t2[i] = {
        busy = false,
        gui = Activated,
        pop = Activated:WaitForChild("Pop")
    }
end

local v4 = TweenInfo.new(t1.IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(t1.OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v6 = t1.IN + t1.HOLD + t1.OUT

local function range(p1) -- line: 104
    -- upvalues: v1 (copy)
    return v1:NextNumber(p1[1], p1[2])
end

local v7 = false

local function twinkle() -- line: 108
    -- upvalues: TweenService (copy), t1 (copy), v1 (copy), t2 (copy), v4 (copy), v5 (copy), v6 (copy), range (copy), v7 (ref)
    if v7 then
        return
    end

    local v8, v9

    for _, v10 in ipairs(t2) do
        if not v10.busy then
            v8 = v10
            v9 = v10
            break
        end
    end

    if not v9 then
        return
    end

    v9.busy = true

    local gui = v9.gui
    local SIZE = t1.SIZE
    local v11 = v1:NextNumber(SIZE[1], SIZE[2])
    local fromScale = UDim2.fromScale
    local AREA_X = t1.AREA_X

    gui.Position = fromScale(v1:NextNumber(AREA_X[1], AREA_X[2]), range(t1.AREA_Y))
    gui.Size = UDim2.fromScale(v11, v11)
    gui.Rotation = v1:NextNumber(0, 90)
    gui.ImageTransparency = 0
    v9.pop.Scale = 0
    gui.Visible = true

    local v12 = (if v1:NextInteger(0, 1) == 0 then -1 else 1) * t1.SPIN

    TweenService:Create(gui, TweenInfo.new(v6, Enum.EasingStyle.Linear), {
        Rotation = gui.Rotation + v12
    }):Play()
    TweenService:Create(v9.pop, v4, {
        Scale = 1
    }):Play()
    task.delay(t1.IN + t1.HOLD, function() -- line: 127
        -- upvalues: v8 (ref), gui (copy), TweenService (copy), v5 (copy)
        TweenService:Create(gui, v5, {
            ImageTransparency = 1
        }):Play()

        local tween = TweenService:Create(v8.pop, v5, {
            Scale = 0.4
        })

        tween.Completed:Once(function() -- line: 130
            -- upvalues: v8 (ref), gui (copy)
            gui.Visible = false
            v8.busy = false
        end)
        tween:Play()
    end)
end

task.spawn(function() -- line: 138
    -- upvalues: t1 (copy), range (copy), twinkle (copy)
    while true do
        task.wait(range(t1.EVERY))
        twinkle()
    end
end)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local t3 = {}
local v13

for _, v14 in ipairs({ "ShopSlot", "CrateSlot", "IndexSlot" }) do
    v13 = MenuButtons:WaitForChild(v14)
    t3[#t3 + 1] = {
        slot = v13,
        scale = v13:WaitForChild("Scale")
    }
end

for _, v15 in ipairs({ "SettingsSlot", "HarpoonSlot" }) do
    v13 = SmallRow:WaitForChild(v15)
    t3[#t3 + 1] = {
        slot = v13,
        scale = v13:WaitForChild("Scale")
    }
end

local v16 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local v17 = false
local v18 = false
local FatBoost = MenuButtons:WaitForChild("FatBoost")
local Scale = FatBoost:WaitForChild("Scale")
local v19 = false

local function fatShown(p2) -- line: 168
    -- upvalues: TweenService (copy), v16 (copy), FatBoost (copy), Scale (copy), v19 (ref)
    if p2 == v19 then
        return
    end

    v19 = p2

    if p2 then
        FatBoost.Visible = true
        Scale.Scale = 0
        TweenService:Create(Scale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.12), {
            Scale = 1
        }):Play()
    else
        local tween = TweenService:Create(Scale, v16, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 177
            -- upvalues: FatBoost (copy), v19 (ref)
            if not v19 then
                FatBoost.Visible = false
            end
        end)
        tween:Play()
    end
end

local function refreshAway() -- line: 181
    -- upvalues: TweenService (copy), LocalPlayer (copy), v7 (ref), t3 (copy), v16 (copy), v17 (ref), v18 (ref), fatShown (copy)
    fatShown(v18 and not v17 and not LocalPlayer:GetAttribute("PanelOpen"))

    local v21 = v17 or v18

    if v21 ~= v7 then
        v7 = v21

        for _, v22 in ipairs(t3) do
            if v21 then
                local tween = TweenService:Create(v22.scale, v16, {
                    Scale = 0
                })

                tween.Completed:Once(function() -- line: 189
                    -- upvalues: v22 (copy), v7 (ref)
                    if v7 then
                        v22.slot.Visible = false
                    end
                end)
                tween:Play()
            else
                v22.slot.Visible = true
                v22.scale.Scale = 0
                TweenService:Create(v22.scale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, v18 == false and 0.12 or 0), {
                    Scale = 1
                }):Play()
            end
        end
    end
end

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 199
    -- upvalues: v17 (ref), refreshAway (copy)
    v17 = true
    refreshAway()
end)
Remotes:WaitForChild("HarpoonExit").OnClientEvent:Connect(function() -- line: 200
    -- upvalues: v17 (ref), refreshAway (copy)
    v17 = false
    refreshAway()
end)
LocalPlayer:GetAttributeChangedSignal("LocalEating"):Connect(function() -- line: 201
    -- upvalues: LocalPlayer (copy), v18 (ref), refreshAway (copy)
    v18 = LocalPlayer:GetAttribute("LocalEating") == true
    refreshAway()
end)
LocalPlayer:GetAttributeChangedSignal("PanelOpen"):Connect(function() -- line: 205
    -- upvalues: LocalPlayer (copy), v17 (ref), v18 (ref), fatShown (copy)
    fatShown(v18 and not v17 and not LocalPlayer:GetAttribute("PanelOpen"))
end)

local ShopButton = FatBoost:WaitForChild("ShopButton")

ButtonHover.Attach(ShopButton, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.3,
    highlightFade = 0.8,
    icon = ShopButton:WaitForChild("Icon")
})
ShopButton.Activated:Connect(function() -- line: 212
    -- upvalues: ButtonHover (copy), ShopButton (copy)
    ButtonHover.Press(ShopButton)
end)

local ShopConfig = require(ReplicatedStorage.Modules:WaitForChild("ShopConfig"))
local PurchaseFX = require(ReplicatedStorage.Modules:WaitForChild("PurchaseFX"))
local Loc = require(ReplicatedStorage.Modules:WaitForChild("Loc"))
local Button2 = FatBoost:WaitForChild("Button")

Button2:WaitForChild("Price").AutoLocalize = false

local v25, v26

for _, v27 in ipairs(ShopConfig.PASSES) do
    if v27.key == "Fat2x" then
        v26 = v27
        v25 = v27
    end
end

local v28 = v26.price

local function owned() -- line: 228
    -- upvalues: LocalPlayer (copy), ShopConfig (copy), v25 (ref)
    return LocalPlayer:GetAttribute(ShopConfig.PassAttr(v25.key)) == true
end

local function dressFat() -- line: 229
    -- upvalues: LocalPlayer (copy), ShopConfig (copy), Loc (copy), Button2 (copy), v25 (ref), v28 (ref)
    Button2.Title.Text = v25.title

    local Price = Button2.Price
    local v29 = LocalPlayer:GetAttribute(ShopConfig.PassAttr(v25.key)) == true
    local OWNED = if v29 then Loc.T("OWNED") else nil

    Price.Text = if not v29 or not OWNED then Loc.F("fat.only", "ONLY {robux}", {
        robux = utf8.char(57346) .. " " .. tostring(v28)
    }) else OWNED
end

task.spawn(function() -- line: 233
    -- upvalues: v25 (ref), v28 (ref), dressFat (copy)
    local function v32() -- line: 234
        -- upvalues: v25 (ref)
        return game:GetService("MarketplaceService"):GetProductInfo(v25.pass, Enum.InfoType.GamePass)
    end

    local ok, result = pcall(v32)

    if ok and result and tonumber(result.PriceInRobux) then
        v28 = result.PriceInRobux
        dressFat()
    end
end)
LocalPlayer:GetAttributeChangedSignal(ShopConfig.PassAttr(v25.key)):Connect(dressFat)
Loc.Changed:Connect(dressFat)
dressFat()
ButtonHover.Attach(Button2, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.3,
    highlightFade = 0.8,
    icon = Button2:WaitForChild("Icon")
})

local spawn = Button2:WaitForChild("RayClip"):WaitForChild("Burst")

TweenService:Create(spawn, TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
    Rotation = spawn.Rotation + 360
}):Play()

local function buyFat(p3) -- line: 246
    -- upvalues: TweenService (copy), ButtonHover (copy), LocalPlayer (copy), ShopConfig (copy), PurchaseFX (copy), v25 (ref)
    ButtonHover.Press(p3)

    if LocalPlayer:GetAttribute(ShopConfig.PassAttr(v25.key)) ~= true then
        PurchaseFX.BuyPass(v25.pass)

        return
    end

    local tween = TweenService:Create(p3, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true), {
        Rotation = 6
    })

    tween.Completed:Once(function() -- line: 252
        -- upvalues: p3 (copy)
        p3.Rotation = 0
    end)
    tween:Play()
end

Button2.Activated:Connect(function() -- line: 256
    -- upvalues: Button2 (copy), buyFat (copy)
    buyFat(Button2)
end)

local GuiService = game:GetService("GuiService")
local Format = require(ReplicatedStorage.Modules:WaitForChild("Format"))
local PassPerks = require(ReplicatedStorage.Modules:WaitForChild("PassPerks"))

ReplicatedStorage = {
    1, 2, 3, 4, 5, 6, 7, 8
}

local _ = {
    EVERY = 1.6,
    OUT = 0.1,
    IN = 0.22
}
local _ = {
    SLIDE = 0.32,
    AWAY = 0.12,
    BACK_IN = 0.28,
    FACE = 0.1,
    ROWS_AT = 0.22,
    ROW = 0.3,
    STAGGER = 0.045,
    UP = 0.14,
    UP_STAGGER = 0.025,
    PAIR_GAP = 0.03
}
local Packs = FatBoost:WaitForChild("Packs")
local Face = Packs:WaitForChild("Face")
local CloseFace = Packs:WaitForChild("CloseFace")
local Amount = Face:WaitForChild("Amount")
local Pop = Amount:WaitForChild("Pop")
local PackList = FatBoost:WaitForChild("PackList")
local Clip = PackList:WaitForChild("Clip")
local PacksPosition = Packs.Position
local v33 = UDim2.new(PacksPosition.X.Scale, PacksPosition.X.Offset, Packs:GetAttribute("OpenY"), 0)
local t5 = {
    Button2,
    ShopButton
}
local t6 = {}
local TextBounds

for v34, v35 in ipairs(ReplicatedStorage) do
    TextBounds = Clip:WaitForChild("Row" .. v34)
    t6[v34] = {
        row = ShopConfig.FAT_TIME[v35],
        button = TextBounds,
        shown = TextBounds.Position,
        hidden = UDim2.new(TextBounds.Position.X.Scale, 0, -TextBounds.Size.Y.Scale, 0)
    }
    TextBounds.Position = t6[v34].hidden
end

local function packAmount(p4) -- line: 306
    -- upvalues: LocalPlayer (copy), ShopConfig (copy), Format (copy), PassPerks (copy)
    return "+" .. Format.short(ShopConfig.FatFor(p4, LocalPlayer:GetAttribute("TableLevel") or 1, PassPerks.FatMul(LocalPlayer)))
end

local function centre(p5) -- line: 310
    local X = p5.AbsoluteSize.X

    if X <= 0 then
        return
    end

    local v36 = p5.Amount.TextBounds.X / X
    local v37 = p5.Icon.AbsoluteSize.X / X
    local v38 = (1 - (v36 + 0.03 + v37)) / 2

    p5.Amount.Position = UDim2.fromScale(v38 + v36, p5.Amount.Position.Y.Scale)
    p5.Icon.Position = UDim2.fromScale(v38 + v36 + 0.03, p5.Icon.Position.Y.Scale)
end

for _, v39 in ipairs(t6) do
    TextBounds = v39.button.Amount:GetPropertyChangedSignal("TextBounds")
    TextBounds:Connect(function() -- line: 319
        -- upvalues: centre (copy), v39 (copy)
        centre(v39.button)
    end)
    TextBounds = v39.button:GetPropertyChangedSignal("AbsoluteSize")
    TextBounds:Connect(function() -- line: 320
        -- upvalues: centre (copy), v39 (copy)
        centre(v39.button)
    end)
end

local n1 = 1

local function dressPacks() -- line: 323
    -- upvalues: LocalPlayer (copy), ShopConfig (copy), Format (copy), PassPerks (copy), Amount (copy), t6 (copy), n1 (ref)
    for _, v40 in ipairs(t6) do
        local Amount = v40.button.Amount
        local row = v40.row

        Amount.Text = "+" .. Format.short(ShopConfig.FatFor(row, LocalPlayer:GetAttribute("TableLevel") or 1, PassPerks.FatMul(LocalPlayer)))
    end

    local row = t6[n1].row

    Amount.Text = "+" .. Format.short(ShopConfig.FatFor(row, LocalPlayer:GetAttribute("TableLevel") or 1, PassPerks.FatMul(LocalPlayer)))
end

LocalPlayer:GetAttributeChangedSignal("TableLevel"):Connect(dressPacks)
LocalPlayer:GetAttributeChangedSignal(ShopConfig.PassAttr(v25.key)):Connect(dressPacks)
dressPacks()

local v41 = false
local n2 = 0

local function tween(p6, p7, p8, p9, p10) -- line: 333
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p6, TweenInfo.new(p7, p8, p9), p10)

    tween:Play()

    return tween
end

local RedBar = Packs:WaitForChild("RedBar")

local function faces(p11, p12, p13) -- line: 339
    -- upvalues: TweenService (copy), Face (copy), CloseFace (copy), n2 (ref), RedBar (copy)
    local v42 = p11 and CloseFace or Face
    local v43 = p11 and Face or CloseFace

    if p12 then
        local Pop = v42.Pop
        local Pop2 = v43.Pop
        local v44 = if p11 then 0 else 1

        Pop.Scale = 1
        Pop2.Scale = 0
        RedBar.ImageTransparency = v44
    else
        local Sine = Enum.EasingStyle.Sine
        local InOut = Enum.EasingDirection.InOut
        local t7 = {
            ImageTransparency = p11 and 0 or 1
        }

        TweenService:Create(RedBar, TweenInfo.new(0.2, Sine, InOut), t7):Play()

        local Pop = v43.Pop
        local Quad = Enum.EasingStyle.Quad
        local In = Enum.EasingDirection.In
        local t8 = {
            Scale = 0
        }

        TweenService:Create(Pop, TweenInfo.new(0.1, Quad, In), t8):Play()

        local delay = task.delay

        delay(0.1, function() -- line: 344
            -- upvalues: p13 (copy), v42 (copy), TweenService (copy), n2 (ref)
            if n2 ~= p13 then
                return
            end

            local Pop = v42.Pop
            local Back = Enum.EasingStyle.Back
            local Out = Enum.EasingDirection.Out
            local t9 = {
                Scale = 1
            }

            TweenService:Create(Pop, TweenInfo.new(0.2, Back, Out), t9):Play()
        end)
    end
end

local function setPacksOpen(p14, p15) -- line: 348
    -- upvalues: TweenService (copy), ButtonHover (copy), FatBoost (copy), v19 (ref), GuiService (copy), Packs (copy), Face (copy), CloseFace (copy), PackList (copy), PacksPosition (copy), v33 (copy), t5 (copy), t6 (copy), v41 (ref), n2 (ref), RedBar (copy), faces (copy)
    if p14 == v41 and not p15 then
        return
    end

    v41 = p14
    n2 += 1

    local v46 = n2
    local Packs2, v47, v48

    if p15 then
        Packs2 = Packs
        v47 = p14 and v33 or PacksPosition
        v48 = false
    elseif v19 then
        v48 = true
    else
        Packs2 = Packs
        v47 = p14 and v33 or PacksPosition
        v48 = false
    end

    if v48 then
        if p14 then
            for _, v49 in ipairs(t5) do
                local HoverScale = v49:FindFirstChild("HoverScale")

                if HoverScale then
                    local Quad = Enum.EasingStyle.Quad
                    local In = Enum.EasingDirection.In
                    local t10 = {
                        Scale = 0
                    }
                    local tween = TweenService:Create(HoverScale, TweenInfo.new(0.12, Quad, In), t10)

                    tween:Play()
                    tween.Completed:Once(function() -- line: 367
                        -- upvalues: v46 (copy), v49 (copy), n2 (ref)
                        if n2 == v46 then
                            v49.Visible = false
                        end
                    end)
                    continue
                end

                v49.Visible = false
            end

            local Back = Enum.EasingStyle.Back
            local Out = Enum.EasingDirection.Out
            local t11 = {
                Position = v33
            }

            TweenService:Create(Packs, TweenInfo.new(0.32, Back, Out), t11):Play()
            faces(true, false, v46)
            PackList.Visible = true

            for v50, v51 in ipairs(t6) do
                task.delay(0.22 + (v50 - 1) * 0.045, function() -- line: 378
                    -- upvalues: v46 (copy), v51 (copy), TweenService (copy), n2 (ref)
                    if n2 ~= v46 then
                        return
                    end

                    local button = v51.button
                    local Back = Enum.EasingStyle.Back
                    local Out = Enum.EasingDirection.Out
                    local t12 = {
                        Position = v51.shown
                    }

                    TweenService:Create(button, TweenInfo.new(0.3, Back, Out), t12):Play()
                end)
            end
        else
            local v52 = #t6

            for v53, v54 in ipairs(t6) do
                task.delay((v52 - v53) * 0.025, function() -- line: 385
                    -- upvalues: v46 (copy), v54 (copy), TweenService (copy), n2 (ref)
                    if n2 ~= v46 then
                        return
                    end

                    local button = v54.button
                    local Quad = Enum.EasingStyle.Quad
                    local In = Enum.EasingDirection.In
                    local t13 = {
                        Position = v54.hidden
                    }

                    TweenService:Create(button, TweenInfo.new(0.14, Quad, In), t13):Play()
                end)
            end

            task.delay(0.14 + (v52 - 1) * 0.025, function() -- line: 390
                -- upvalues: v46 (copy), TweenService (copy), ButtonHover (copy), Packs (copy), PackList (copy), PacksPosition (copy), t5 (copy), n2 (ref), faces (copy)
                if n2 ~= v46 then
                    return
                end

                PackList.Visible = false

                local Back = Enum.EasingStyle.Back
                local Out = Enum.EasingDirection.Out
                local t14 = {
                    Position = PacksPosition
                }

                TweenService:Create(Packs, TweenInfo.new(0.32, Back, Out), t14):Play()
                faces(false, false, v46)

                for _, v55 in ipairs(t5) do
                    v55.Visible = true

                    local HoverScale = v55:FindFirstChild("HoverScale")

                    if HoverScale then
                        HoverScale.Scale = 0

                        local Back = Enum.EasingStyle.Back
                        local Out = Enum.EasingDirection.Out
                        local t15 = {
                            Scale = ButtonHover.Rest(v55)
                        }

                        TweenService:Create(HoverScale, TweenInfo.new(0.28, Back, Out), t15):Play()
                    end
                end
            end)
        end
    else
        Packs2.Position = v47

        local v56 = if p14 then CloseFace else nil

        if not p14 or not v56 then
            v56 = Face
        end

        local v57 = if p14 then Face else nil

        if not p14 or not v57 then
            v57 = CloseFace
        end

        local Pop = v56.Pop
        local Pop2 = v57.Pop
        local v58 = if p14 then 0 else 1

        Pop.Scale = 1
        Pop2.Scale = 0
        RedBar.ImageTransparency = v58

        for _, v59 in ipairs(t5) do
            v59.Visible = not p14

            local HoverScale = v59:FindFirstChild("HoverScale")

            if HoverScale then
                HoverScale.Scale = 1
            end
        end

        PackList.Visible = p14

        for _, v60 in ipairs(t6) do
            v60.button.Position = p14 and v60.shown or v60.hidden
        end
    end

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and SelectedObject:IsDescendantOf(FatBoost) then
        GuiService.SelectedObject = p14 and t6[1].button or Packs
    end
end

FatBoost:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 409
    -- upvalues: FatBoost (copy), v41 (ref), setPacksOpen (copy)
    if not FatBoost.Visible and v41 then
        setPacksOpen(false, true)
    end
end)
ButtonHover.Attach(Packs, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.3,
    highlightFade = 0.8,
    icon = Face:WaitForChild("Icon")
})
Packs.Activated:Connect(function() -- line: 414
    -- upvalues: ButtonHover (copy), Packs (copy), v41 (ref), setPacksOpen (copy)
    ButtonHover.Press(Packs)
    setPacksOpen(not v41)
end)

for _, v61 in ipairs(t6) do
    ButtonHover.Attach(v61.button, {
        tile = 1,
        iconTilt = 20,
        highlight = true,
        highlightCorner = 0.3,
        highlightFade = 0.8,
        icon = v61.button:WaitForChild("Icon")
    })
    v61.button.Activated:Connect(function() -- line: 417
        -- upvalues: ButtonHover (copy), PurchaseFX (copy), v61 (copy)
        ButtonHover.Press(v61.button)
        PurchaseFX.Buy(v61.row.product)
    end)
end

local v62 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v63 = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

task.spawn(function() -- line: 426
    -- upvalues: TweenService (copy), LocalPlayer (copy), v19 (ref), ShopConfig (copy), Format (copy), PassPerks (copy), Amount (copy), Pop (copy), t6 (copy), n1 (ref), v41 (ref), v62 (copy), v63 (copy)
    while true do
        task.wait(1.6)

        if v19 and not v41 then
            local tween = TweenService:Create(Pop, v62, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 431
                -- upvalues: TweenService (copy), LocalPlayer (copy), ShopConfig (copy), Format (copy), PassPerks (copy), Amount (copy), Pop (copy), t6 (copy), n1 (ref), v63 (copy)
                n1 = n1 % #t6 + 1

                local row = t6[n1].row

                Amount.Text = "+" .. Format.short(ShopConfig.FatFor(row, LocalPlayer:GetAttribute("TableLevel") or 1, PassPerks.FatMul(LocalPlayer)))
                TweenService:Create(Pop, v63, {
                    Scale = 1
                }):Play()
            end)
            tween:Play()
        end
    end
end)

local Plus = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Fat"):WaitForChild("Icon"):WaitForChild("Plus")

local function showPlus() -- line: 447
    -- upvalues: Plus (copy)
    Plus.Visible = false
end

LocalPlayer:GetAttributeChangedSignal("ShopUnlocked"):Connect(showPlus)
Plus.Visible = false

local Icon = Button:WaitForChild("Icon")
local Size = Icon.Size
local t16 = {
    {
        hold = 16,
        image = Icon.Image
    },
    {
        image = "rbxassetid://92978738810887",
        hold = 2
    },
    {
        image = "rbxassetid://135825676122341",
        hold = 2
    },
    {
        image = "rbxassetid://109430127148383",
        hold = 2,
        ends = ShopConfig.VOID_EGG_ENDS
    },
    {
        image = "rbxassetid://117252679272986",
        hold = 2
    },
    {
        image = "rbxassetid://92978738810887",
        hold = 2
    }
}
local _ = {
    OUT = 0.12,
    IN = 0.38,
    TWIST = 25
}
local v65 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v66 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

task.spawn(function() -- line: 476
    -- upvalues: TweenService (copy), v17 (ref), v18 (ref), Icon (copy), Size (copy), t16 (copy), v65 (copy), v66 (copy)
    local t17 = {}

    for _, v67 in ipairs(t16) do
        t17[#t17 + 1] = v67.image
    end

    local function v68() -- line: 479
        -- upvalues: t17 (copy)
        game:GetService("ContentProvider"):PreloadAsync(t17)
    end

    pcall(v68)

    local n3 = 1

    while true do
        task.wait(t16[n3].hold)

        if not (v17 or v18) then
            local v69 = n3 % #t16 + 1
            local ends = t16[v69].ends

            if ends and ends <= workspace:GetServerTimeNow() then
                v69 = v69 % #t16 + 1
            end

            local tween = TweenService:Create(Icon, v65, {
                Size = UDim2.fromScale(0, 0)
            })

            tween.Completed:Once(function() -- line: 489
                -- upvalues: v69 (ref), TweenService (copy), Icon (copy), Size (copy), t16 (copy), v66 (copy)
                Icon.Image = t16[v69].image
                TweenService:Create(Icon, v66, {
                    Size = Size
                }):Play()

                if Icon.Rotation == 0 then
                    Icon.Rotation = -25
                    TweenService:Create(Icon, v66, {
                        Rotation = 0
                    }):Play()
                end
            end)
            tween:Play()
            n3 = v69
        end
    end
end)

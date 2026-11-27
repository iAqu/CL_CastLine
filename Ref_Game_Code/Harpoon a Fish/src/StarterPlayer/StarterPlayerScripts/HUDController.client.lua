-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local HUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local FishDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDisplay"))
local MutationDisplay = require(ReplicatedStorage.Modules:WaitForChild("MutationDisplay"))
local HudFit = require(ReplicatedStorage.Modules:WaitForChild("HudFit"))
local RarityDisplay = require(ReplicatedStorage.Modules:WaitForChild("RarityDisplay"))
local Loc = require(ReplicatedStorage.Modules:WaitForChild("Loc"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CatchAnnounce = Remotes:WaitForChild("CatchAnnounce")
local HarpoonEnter = Remotes:WaitForChild("HarpoonEnter")
local BagReveal = Remotes:WaitForChild("BagReveal")
local HarpoonExit = Remotes:WaitForChild("HarpoonExit")

local function formatKg(p1) -- line: 30
    local v1, v2 = string.format("%.1f", p1):match("^(%d+)%.(%d)$")

    return v1:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. (v2 ~= "0" and "." .. v2 or "") .. "kg"
end

local v3 = Color3.fromRGB(255, 80, 70)
local v4 = Color3.fromRGB(255, 250, 240)
local Weight = HUD.Bag.Weight
local TextService = game:GetService("TextService")
local n1 = 0

local function fitWeight() -- line: 54
    -- upvalues: Weight (copy), TextService (copy), n1 (ref)
    n1 += 1

    local v5 = n1
    local AbsoluteSize = Weight.AbsoluteSize

    if not (AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0) then
        task.spawn(function() -- line: 59
            -- upvalues: v5 (copy), AbsoluteSize (copy), Weight (copy), TextService (copy), n1 (ref)
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

            GetTextBoundsParams.Text = Weight.Text
            GetTextBoundsParams.Font = Weight.FontFace
            GetTextBoundsParams.Size = 100
            GetTextBoundsParams.Width = 1E+05

            local GetTextBoundsAsync = TextService.GetTextBoundsAsync
            local ok, result = pcall(GetTextBoundsAsync, TextService, GetTextBoundsParams)

            if not ok or v5 ~= n1 or result.X <= 0 or result.Y <= 0 then
                return
            end

            Weight.TextScaled = false
            Weight.TextWrapped = false
            Weight.TextSize = math.max(1, (math.floor(math.min(AbsoluteSize.X / result.X, AbsoluteSize.Y / result.Y) * 90)))
        end)
    end
end

Weight:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitWeight)
Weight:GetPropertyChangedSignal("Text"):Connect(fitWeight)

local Count = HUD.Bag.Count
local v10 = false
local v11 = false
local v12 = false

local function setBag() -- line: 80
    -- upvalues: LocalPlayer (copy), formatKg (copy), v3 (copy), v4 (copy), Weight (copy), Count (copy)
    Weight.Text = formatKg(LocalPlayer:GetAttribute("BagWeight") or 0)

    local v13 = LocalPlayer:GetAttribute("BagCount") or 0
    local v14 = LocalPlayer:GetAttribute("BagCap") or 0

    Count.Text = v13 .. "/" .. v14
    Count.TextColor3 = if v14 > 0 and v14 <= v13 and v3 then v3 else v4
end

local function bagChanged() -- line: 86
    -- upvalues: v10 (ref), v11 (ref), setBag (copy)
    if not (v10 or v11) then
        task.delay(0.15, function() -- line: 88
            -- upvalues: v10 (ref), v11 (ref), setBag (copy)
            if not v10 and not v11 then
                setBag()
            end
        end)
    end
end

for _, v16 in ipairs({ "BagWeight", "BagCount", "BagCap" }) do
    LocalPlayer:GetAttributeChangedSignal(v16):Connect(bagChanged)
end

setBag()

local t1 = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }

local function formatShort(p2) -- line: 101
    -- upvalues: t1 (copy)
    if p2 < 1000 then
        return (tostring((math.floor(p2))))
    end

    local v18 = p2
    local n2 = 0

    while v18 >= 1000 and n2 < #t1 do
        v18 /= 1000
        n2 += 1
    end

    return string.format("%.1f", v18):gsub("%.0$", "") .. t1[n2]
end

local Value = HUD.Fat.Value
local Boost = HUD.Fat:WaitForChild("Boost")
local ShopConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ShopConfig"))
local PassPerks = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PassPerks"))

local function placeBoost() -- line: 120
    -- upvalues: LocalPlayer (copy), HUD (copy), Value (copy), Boost (copy), PassPerks (copy)
    local v19 = PassPerks.FatMul(LocalPlayer)

    Boost.Visible = v19 > 1
    Boost.Text = "(x" .. string.format("%.2f", v19):gsub("%.?0+$", "") .. ")"

    local X = HUD.Fat.AbsoluteSize.X

    if X > 0 then
        Boost.Position = UDim2.new(Value.Position.X.Scale + Value.TextBounds.X / X + 0.02, 0, Value.Position.Y.Scale, 0)
    end
end

local function setFatLabel(p3) -- line: 131
    -- upvalues: formatShort (copy), Value (copy), placeBoost (copy)
    Value.Text = formatShort(p3)
    placeBoost()
end

LocalPlayer:GetAttributeChangedSignal(ShopConfig.PassAttr("Fat2x")):Connect(placeBoost)
LocalPlayer:GetAttributeChangedSignal("TitanFat"):Connect(placeBoost)
Value:GetPropertyChangedSignal("TextBounds"):Connect(placeBoost)

local t2 = {
    25, 155
}
local FatPop = HUD:FindFirstChild("FatPop")
local t3 = {}
local n3 = 0
local v20 = false
local n4 = 0
local v21

local function releasePiece(p4) -- line: 164
    -- upvalues: TweenService (copy), LocalPlayer (copy), HUD (copy), formatShort (copy), Value (copy), placeBoost (copy), t2 (copy), FatPop (copy), t3 (copy), n3 (ref), n4 (ref)
    n3 += p4
    Value.Text = formatShort(n3)
    placeBoost()

    local Pop = HUD.Fat:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 1.09
        TweenService:Create(Pop, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Head = Character and Character:FindFirstChild("Head")

    if FatPop and HumanoidRootPart and Head then
        local v25 = math.rad(t2[1] + (t2[2] - t2[1]) * (n4 * 0.618034 % 1))

        n4 += 1

        local clone = FatPop:Clone()

        clone.Frame.Text.Text = "+" .. formatShort(p4)
        clone.Adornee = HumanoidRootPart
        clone.Enabled = true
        clone.Parent = LocalPlayer.PlayerGui
        t3[#t3 + 1] = {
            gui = clone,
            t0 = os.clock(),
            from = workspace.CurrentCamera.CFrame:VectorToObjectSpace(Head.Position - HumanoidRootPart.Position),
            travel = Vector3.new(math.cos(v25), math.sin(v25), 0) * 6 * (0.85 + 0.3 * math.random())
        }
    end
end

local function stepPiece(p5, p6) -- line: 193
    local v29 = p6 - p5.t0
    local Adornee = p5.gui.Adornee
    local v30, v31

    if not (v29 >= 0.6) and Adornee and Adornee.Parent then
        local v32 = 1 - (1 - v29 / 0.6) ^ 4

        p5.gui.StudsOffset = p5.from + p5.travel * v32

        if v29 < 0.1 then
            v30 = 1.5 * (1 - (1 - v29 / 0.1) ^ 2)
            v31 = 0
        elseif v29 < 0.4 then
            v30 = (math.cos(3.141592653589793 * ((v29 - 0.1) / 0.30000000000000004)) * 0.5 + 0.5) * 0.5 + 1
            v31 = 0
        else
            v31 = (v29 - 0.4) / 0.19999999999999996
            v30 = v31 * -0.6 + 1
        end

        local Frame = p5.gui.Frame

        Frame.Scale.Scale = v30
        Frame.Text.TextTransparency = v31
        Frame.Text.UIStroke.Transparency = v31
        Frame.Icon.ImageTransparency = v31

        return true
    end

    p5.gui:Destroy()

    return false
end

local function fatStep() -- line: 223
    -- upvalues: t3 (copy), v21 (ref), stepPiece (copy)
    local elapsed = os.clock()

    for i = #t3, 1, -1 do
        if not stepPiece(t3[i], elapsed) then
            table.remove(t3, i)
        end
    end

    if #t3 ~= 0 then
        return
    end

    v21:Disconnect()
    v21 = nil
end

local function fatChanged() -- line: 235
    -- upvalues: RunService (copy), LocalPlayer (copy), formatShort (copy), Value (copy), placeBoost (copy), n3 (ref), v20 (ref), v21 (ref), releasePiece (copy), fatStep (copy)
    local Fat = LocalPlayer:GetAttribute("Fat")

    if Fat ~= nil then
        local v34 = Fat - n3

        if v20 and not (v34 <= 0) then
            releasePiece(v34)
            v21 = v21 or RunService.RenderStepped:Connect(fatStep)

            return
        end

        v20 = true
        n3 = Fat
        Value.Text = formatShort(Fat)
    else
        Value.Text = formatShort(0)
    end

    placeBoost()
end

LocalPlayer:GetAttributeChangedSignal("Fat"):Connect(fatChanged)
fatChanged()

local HudSize = require(ReplicatedStorage.Modules:WaitForChild("HudSize"))
local v35 = HudSize.TopRowY()
local v36 = v35
local v37 = false
local v38
local v39 = v35

local function pillPx() -- line: 296
    -- upvalues: HUD (copy), HudFit (copy)
    local AbsoluteSize, Fat = HUD.AbsoluteSize, HUD.Fat
    local AspectRatio = Fat:FindFirstChildOfClass("UIAspectRatioConstraint").AspectRatio

    return math.min(Fat.Size.Y.Scale * AbsoluteSize.Y, Fat.Size.X.Scale * AbsoluteSize.X / AspectRatio) * HudFit.Factor(AbsoluteSize.X, AbsoluteSize.Y)
end

local function slideFat(p7, p8) -- line: 301
    -- upvalues: TweenService (copy), HUD (copy), v38 (ref), v39 (ref), pillPx (copy)
    if v38 then
        v38:Cancel()
    end

    v39 = p7

    local X = HUD.Fat.Position.X
    local v42 = UDim2.new(X.Scale, X.Offset, 0.975, -(0.975 - p7) / HUD.Fat.Size.Y.Scale * pillPx())

    if p8 then
        v38 = nil
        HUD.Fat.Position = v42
    else
        v38 = TweenService:Create(HUD.Fat, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.05), {
            Position = v42
        })
        v38:Play()
    end
end

local _ = {
    FROM = 0.35,
    TIME = 0.32,
    OUT = 0.2
}

local function popBagIn() -- line: 324
    -- upvalues: TweenService (copy), HUD (copy)
    local Pop = HUD.Bag:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 0.35
        TweenService:Create(Pop, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function popBagOut() -- line: 337
    -- upvalues: TweenService (copy), HUD (copy)
    local Pop = HUD.Bag:FindFirstChild("Pop")

    if Pop and HUD.Bag.Visible then
        local tween = TweenService:Create(Pop, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0.35
        })

        tween.Completed:Once(function() -- line: 342
            -- upvalues: Pop (copy), HUD (copy)
            HUD.Bag.Visible = false
            Pop.Scale = 1
        end)
        tween:Play()
    end
end

HarpoonExit.OnClientEvent:Connect(function() -- line: 348
    -- upvalues: LocalPlayer (copy), v11 (ref), v12 (ref), popBagOut (copy)
    v12 = false

    if not v11 and not ((LocalPlayer:GetAttribute("BagCount") or 0) > 0) then
        popBagOut()
    end
end)

local function tutorialHides(p9) -- line: 358
    -- upvalues: LocalPlayer (copy)
    return string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", "," .. p9 .. ",", 1, true) ~= nil
end

local function refreshSlot() -- line: 362
    -- upvalues: LocalPlayer (copy), HUD (copy), v11 (ref), v36 (ref), v37 (ref), slideFat (copy), popBagIn (copy)
    local v43 = if v37 then "Bag" elseif LocalPlayer:GetAttribute("LocalEating") == true then "Fat" else "Both"

    if not v11 then
        local v44 = v43 == "Bag"
        local v45 = v44 and not HUD.Bag.Visible

        HUD.Bag.Visible = v44

        if v45 then
            popBagIn()
        end
    end

    local Visible = HUD.Fat.Visible
    local Fat = HUD.Fat

    if v43 == "Bag" then
        Fat.Visible = false
    else
        Fat.Visible = string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",HUD.Fat,", 1, true) == nil
    end

    if HUD.Fat.Visible then
        slideFat(if v43 == "Fat" then 0.975 else v36, not Visible)
    end

    LocalPlayer:SetAttribute("HudSlot", v43)
end

local function showBag(p10) -- line: 379
    -- upvalues: v37 (ref), refreshSlot (copy)
    v37 = p10
    refreshSlot()
end

LocalPlayer:GetAttributeChangedSignal("LocalEating"):Connect(refreshSlot)
LocalPlayer:GetAttributeChangedSignal("TutorialHides"):Connect(refreshSlot)
v37 = false
refreshSlot()
HUD:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 387
    -- upvalues: HUD (copy), v38 (ref), v39 (ref), pillPx (copy)
    if HUD.Fat.Visible then
        local v47 = v39

        if v38 then
            v38:Cancel()
        end

        v39 = v47

        local X = HUD.Fat.Position.X
        local v48 = UDim2.new(X.Scale, X.Offset, 0.975, -(0.975 - v47) / HUD.Fat.Size.Y.Scale * pillPx())

        v38 = nil
        HUD.Fat.Position = v48
    end
end)
HudSize.Changed:Connect(function() -- line: 391
    -- upvalues: HUD (copy), HudSize (copy), v36 (ref), v38 (ref), v39 (ref), pillPx (copy)
    local v49 = v39 ~= 0.975

    v36 = HudSize.TopRowY()

    if v49 then
        v39 = v36
    end

    if HUD.Fat.Visible then
        local v50 = v39

        if v38 then
            v38:Cancel()
        end

        v39 = v50

        local X = HUD.Fat.Position.X
        local v51 = UDim2.new(X.Scale, X.Offset, 0.975, -(0.975 - v50) / HUD.Fat.Size.Y.Scale * pillPx())

        v38 = nil
        HUD.Fat.Position = v51
    end
end)

local function setHotbar(p11) -- line: 402
    -- upvalues: LocalPlayer (copy)
    local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

    if BackpackGui then
        BackpackGui.Enabled = p11
    end
end

local v52

HarpoonEnter.OnClientEvent:Connect(function() -- line: 407
    -- upvalues: LocalPlayer (copy), v12 (ref), v37 (ref), refreshSlot (copy)
    v12 = true

    local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

    if BackpackGui then
        BackpackGui.Enabled = false
    end

    v37 = true
    refreshSlot()
end)
BagReveal.OnClientEvent:Connect(function(p12) -- line: 416
    -- upvalues: LocalPlayer (copy), v11 (ref), v37 (ref), refreshSlot (copy), v52 (ref)
    if #p12 > 0 and not v11 and v52 then
        task.spawn(v52, p12)
    else
        local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

        if BackpackGui then
            BackpackGui.Enabled = true
        end

        v37 = false
        refreshSlot()
    end
end)

local v53 = Vector2.new(0.5, 0.42)
local v54 = Vector2.new(-0.35, -0.45)
local t5 = {
    0.95, 1.05
}
local t6 = {
    New = "NEW!",
    Biggest = "BIGGEST CATCH!",
    World = "WORLD RECORD!",
    Double = "DOUBLE CATCH!"
}
local t7 = {
    New = {
        UDim2.fromScale(0.72, 0.3),
        UDim2.fromScale(0.08, 0.12)
    },
    Biggest = {
        UDim2.fromScale(1.1, 0.22),
        UDim2.fromScale(0.14, 0.1)
    },
    World = {
        UDim2.fromScale(1.5, 0.3),
        UDim2.fromScale(0.2, 0.08)
    },
    Double = {
        UDim2.fromScale(1.1, 0.22),
        UDim2.fromScale(0.14, 0.1)
    }
}
local t8 = {
    SOUND = 140606681115907,
    VOLUME = 1,
    IN = 0.8,
    SAFE = 2,
    NO_LENGTH = 20,
    EDGE = Color3.fromRGB(5, 54, 94)
}
local Sound = Instance.new("Sound")

Sound.Name = "WorldRecordSound"
Sound.SoundId = "rbxassetid://" .. t8.SOUND
Sound.Volume = 0
Sound.Parent = SoundService
task.spawn(function() -- line: 484
    -- upvalues: ContentProvider (copy), Sound (copy)
    ContentProvider:PreloadAsync({
        Sound
    })
end)

local function worldMoment() -- line: 485
    -- upvalues: TweenService (copy), LocalPlayer (copy), t8 (copy), Sound (copy)
    local v55 = LocalPlayer:GetAttribute("MusicDuck") == nil

    if v55 then
        LocalPlayer:SetAttribute("MusicDuck", 0)
    end

    local v56 = false

    local function release() -- line: 489
        -- upvalues: v55 (copy), v56 (ref), LocalPlayer (copy)
        if not v56 then
            v56 = true

            if v55 and LocalPlayer:GetAttribute("MusicDuck") == 0 then
                LocalPlayer:SetAttribute("MusicDuck", nil)
            end
        end
    end

    Sound.Volume = 0
    Sound.TimePosition = 0
    Sound:Play()
    TweenService:Create(Sound, TweenInfo.new(t8.IN, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Volume = t8.VOLUME
    }):Play()
    Sound.Ended:Once(release)
    task.delay((Sound.TimeLength > 0 and Sound.TimeLength or t8.NO_LENGTH) + t8.SAFE, release)
end

local Sound2 = Instance.new("Sound")

Sound2.Name = "CatchTagSound"
Sound2.SoundId = "rbxassetid://96359585058783"
Sound2.Volume = 1.5
Sound2.Parent = SoundService
task.spawn(function() -- line: 508
    -- upvalues: ContentProvider (copy), Sound2 (copy)
    ContentProvider:PreloadAsync({
        Sound2
    })
end)

local Sound3 = Instance.new("Sound")

Sound3.Name = "DoubleCatchSound"
Sound3.SoundId = "rbxassetid://132246461855375"
Sound3.Volume = 1
Sound3.Parent = SoundService
task.spawn(function() -- line: 517
    -- upvalues: ContentProvider (copy), Sound3 (copy)
    ContentProvider:PreloadAsync({
        Sound3
    })
end)

local v57 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 60)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 130, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 35, 15))
})
local v58 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 50)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 255, 50)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(50, 150, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(130, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 150))
})

local function legible(p13) -- line: 539
    local v59 = math.max(p13.R, p13.G, p13.B)

    if v59 >= 0.55 then
        return p13
    end

    if v59 <= 0 then
        return Color3.fromRGB(140, 35, 140)
    end

    local v60 = 0.55 / v59

    return Color3.new(math.min(1, p13.R * v60), math.min(1, p13.G * v60), (math.min(1, p13.B * v60)))
end

local function popBag() -- line: 547
    -- upvalues: TweenService (copy), LocalPlayer (copy), HUD (copy), v10 (ref), setBag (copy)
    v10 = false
    LocalPlayer:SetAttribute("CatchCardInFlight", nil)
    LocalPlayer:SetAttribute("CatchCardFlying", nil)
    setBag()

    local Pop = HUD.Bag:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 1.25
        TweenService:Create(Pop, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function makeCard(p14, p15, p16, p17) -- line: 562
    -- upvalues: ReplicatedStorage (copy), HUD (copy), FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), Loc (copy), formatKg (copy), v58 (copy), legible (copy)
    local v66 = FishDisplay[p14]
    local FlyIcon = HUD:FindFirstChild("FlyIcon")

    if not (v66 and v66.icon and FlyIcon) then
        return nil
    end

    local clone = FlyIcon:Clone()
    local Image = clone.Image

    Image.Image = v66.icon

    local v67 = p15 and MutationDisplay[p15]
    local Species = clone.Species

    Species.AutoLocalize = false
    Species.Text = Loc.Fish(v67 and v67.prefix, v66.display or p14)

    local Rainbow = Species:FindFirstChild("Rainbow")
    local textColor, v68

    if v67 then
        if v67.cycle then
            v68 = true
        else
            textColor = v67.textColor or legible(v67.color) or Color3.new(1, 1, 1)
            v68 = false
        end
    else
        textColor = Color3.new(1, 1, 1)
        v68 = false
    end

    if v68 then
        Species.TextColor3 = Color3.new(1, 1, 1)

        if Rainbow then
            Rainbow.Color = v58
            Rainbow.Enabled = true
        end
    else
        Species.TextColor3 = textColor

        if Rainbow then
            Rainbow.Enabled = false
        end
    end

    local RarityStyle = require(ReplicatedStorage.Modules.RarityStyle)

    local function edge(p18) -- line: 591
        -- upvalues: RarityStyle (copy)
        p18.UIStroke.Color = RarityStyle.Glows(p18.TextColor3) and RarityStyle.StrokeOf(p18.TextColor3) or Color3.new(0, 0, 0)
    end

    Species.UIStroke.Color = RarityStyle.Glows(Species.TextColor3) and RarityStyle.StrokeOf(Species.TextColor3) or Color3.new(0, 0, 0)

    if v67 and v67.glow and not v67.cycle then
        Species.UIStroke.Color = v67.glow
    end

    local rarity = v66.rarity

    rarity = rarity and RarityDisplay[v66.shown or v66.rarity]
    clone.Rarity.Text = rarity and rarity.display or ""
    clone.Rarity.TextColor3 = rarity and rarity.color or Color3.new(1, 1, 1)

    local Rarity = clone.Rarity

    Rarity.UIStroke.Color = RarityStyle.Glows(Rarity.TextColor3) and RarityStyle.StrokeOf(Rarity.TextColor3) or Color3.new(0, 0, 0)
    require(ReplicatedStorage.Modules.RarityStyle).Track(clone.Rarity, rarity and rarity.color)
    clone.Weight.Text = formatKg(p16 or 0)

    local Badge = Image:FindFirstChild("Badge")

    if Badge then
        Badge.Image = v67 and v67.icon or ""

        if v67 ~= nil then
            Badge.Visible = v67.icon ~= nil
        else
            Badge.Visible = false
        end

        if p17 then
            local clone = Badge:Clone()

            clone.Name = "CrownBadge"

            if p17 == true then
                clone.Image = "rbxassetid://132409368513754"
            else
                clone.Image = require(game:GetService("ReplicatedStorage").Modules.ThanksgivingConfig).HatIcon(p17 == "hat" or p17) or "rbxassetid://132409368513754"
            end

            clone.AnchorPoint = Vector2.new(1 - Badge.AnchorPoint.X, Badge.AnchorPoint.Y)
            clone.Position = UDim2.new(1 - Badge.Position.X.Scale, -Badge.Position.X.Offset, Badge.Position.Y.Scale, Badge.Position.Y.Offset)
            clone.Visible = true
            clone.Parent = Image
        end
    end

    return clone
end

local function popCard(p19, p20) -- line: 624
    -- upvalues: TweenService (copy)
    local Pop = p19.Pop

    Pop.Scale = 0.25 * p20
    TweenService:Create(Pop, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = p20
    }):Play()

    local v70 = TweenInfo.new(0.27, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, v71 in ipairs({
            p19.Image,
            p19.Burst,
            p19.Image:FindFirstChild("Badge"),
            p19.Image:FindFirstChild("CrownBadge")
        }) do
        v71.ImageTransparency = 1
        TweenService:Create(v71, v70, {
            ImageTransparency = 0
        }):Play()
    end

    for _, v72 in ipairs({
            p19.Species,
            p19.Rarity,
            p19.Weight
        }) do
        v72.TextTransparency = 1
        v72.UIStroke.Transparency = 1
        TweenService:Create(v72, v70, {
            TextTransparency = 0
        }):Play()
        TweenService:Create(v72.UIStroke, v70, {
            Transparency = 0
        }):Play()
    end
end

local function spinCard(p21, p22, p23) -- line: 642
    p21.Burst.Rotation = (p21.Burst.Rotation + 40 * p22) % 360

    local Rainbow = p21.Species:FindFirstChild("Rainbow")

    if Rainbow and Rainbow.Enabled then
        Rainbow.Rotation = p23 * 55 % 360
    end

    if not p21:GetAttribute("WorldTag") then
        return
    end

    local New = p21.Image:FindFirstChild("New")
    local UIGradient = New and New:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Rotation = p23 * 55 % 360
    end
end

local function flyTag(p24, p25) -- line: 655
    -- upvalues: TweenService (copy), v54 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), Sound2 (copy), Sound3 (copy), v57 (copy), v58 (copy)
    local New = p24.Image:FindFirstChild("New")
    local UIStroke, v73, v74, v75

    if New then
        v74 = New:FindFirstChild("Pop")

        if v74 and t6[p25] then
            UIStroke = New:FindFirstChildOfClass("UIStroke")
            v73 = t7[p25][2]

            if p25 == "World" then
                local UIGradient = New:FindFirstChildOfClass("UIGradient")

                if UIGradient then
                    UIGradient.Color = v58
                end

                if UIStroke then
                    UIStroke.Color = t8.EDGE
                end

                p24:SetAttribute("WorldTag", true)
            elseif p25 == "Double" then
                local UIGradient = New:FindFirstChildOfClass("UIGradient")

                if UIGradient then
                    UIGradient.Color = v57
                end
            end

            v75 = false
        else
            v75 = true
        end
    else
        v74 = New
        v75 = true
    end

    if v75 then
        return
    end

    New.Text = t6[p25]
    New.Size = t7[p25][1]
    New.Position = UDim2.fromScale(v73.X.Scale + v54.X, v73.Y.Scale + v54.Y)
    New.TextTransparency = 1

    if UIStroke then
        UIStroke.Transparency = 1
    end

    v74.Scale = 4
    New.Visible = true
    task.delay(0.6, function() -- line: 679
        -- upvalues: p24 (copy), p25 (copy), New (copy), UIStroke (ref), v73 (ref), v74 (ref), TweenService (copy), t5 (copy), Sound2 (copy), Sound3 (copy)
        if p24.Parent then
            local v76 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local tween = TweenService:Create(v74, v76, {
                Scale = 0.88
            })

            TweenService:Create(New, v76, {
                TextTransparency = 0,
                Position = v73
            }):Play()

            if UIStroke then
                TweenService:Create(UIStroke, v76, {
                    Transparency = 0
                }):Play()
            end

            tween.Completed:Once(function() -- line: 685
                -- upvalues: p24 (copy), p25 (copy), v74 (ref), TweenService (copy), t5 (copy), Sound2 (copy), Sound3 (copy)
                if p24.Parent then
                    if p25 == "Double" then
                        Sound3:Play()
                    else
                        Sound2.PlaybackSpeed = t5[1] + (t5[2] - t5[1]) * math.random()
                        Sound2:Play()
                    end

                    TweenService:Create(v74, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Scale = 1
                    }):Play()

                    local tween = TweenService:Create(p24.Pop, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Scale = 0.9
                    })

                    tween.Completed:Once(function() -- line: 696
                        -- upvalues: p24 (copy), TweenService (copy)
                        if p24.Parent then
                            TweenService:Create(p24.Pop, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                Scale = 1
                            }):Play()
                        end
                    end)
                    tween:Play()
                end
            end)
            tween:Play()
        end
    end)
end

local function flyCatch(p26, p27, p28, p29, p30) -- line: 706
    -- upvalues: RunService (copy), SoundService (copy), LocalPlayer (copy), HUD (copy), v10 (ref), v53 (copy), t6 (copy), worldMoment (copy), popBag (copy), makeCard (copy), popCard (copy), spinCard (copy), flyTag (copy)
    local v77 = makeCard(p26, p27, p28, p30)

    if not v77 then
        popBag()

        return
    end

    local v78 = if t6[p29] then 2.4 else 1.5

    v10 = true
    LocalPlayer:SetAttribute("CatchCardInFlight", true)
    v77.Position = UDim2.fromScale(v53.X, v53.Y)
    v77.Visible = true
    v77.Parent = HUD
    popCard(v77, 1)

    if t6[p29] then
        flyTag(v77, p29)
    end

    if p29 == "World" then
        worldMoment()
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local CatchSound = HarpoonSFX and HarpoonSFX:FindFirstChild("CatchSound")

    if CatchSound then
        CatchSound:Play()
    end

    local Pop, Burst = v77.Pop, v77.Burst
    local elapsed = os.clock()
    local v79 = false
    local connection

    connection = RunService.RenderStepped:Connect(function(p31) -- line: 728
        -- upvalues: v77 (copy), Pop (copy), Burst (copy), elapsed (copy), v79 (ref), connection (ref), v78 (copy), LocalPlayer (copy), HUD (copy), v53 (copy), popBag (copy), spinCard (copy)
        if not v77.Parent then
            connection:Disconnect()

            return
        end

        local v80 = os.clock() - elapsed

        spinCard(v77, p31, v80)

        if not (v80 < v78) then
            if not v79 then
                v79 = true
                LocalPlayer:SetAttribute("CatchCardFlying", 0.4)
            end

            local v82 = math.min(1, (v80 - v78) / 0.4)
            local v83 = v82 * v82 * v82
            local Bag = HUD.Bag
            local v84 = (Bag.AbsolutePosition + Bag.AbsoluteSize / 2 - HUD.AbsolutePosition) / HUD.AbsoluteSize
            local v85 = (v53 + v84) / 2 + Vector2.new(0, -0.22)
            local v86 = (1 - v83) ^ 2 * v53 + (1 - v83) * 2 * v83 * v85 + v83 * v83 * v84

            v77.Position = UDim2.fromScale(v86.X, v86.Y)
            Pop.Scale = 1 - v83 * 0.35
            Burst.ImageTransparency = v83

            if v82 >= 1 then
                connection:Disconnect()
                v77:Destroy()
                popBag()
            end
        end
    end)
end

local v87 = string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",HUD.Fat,", 1, true) ~= nil

LocalPlayer:GetAttributeChangedSignal("TutorialHides"):Connect(function() -- line: 779
    -- upvalues: TweenService (copy), LocalPlayer (copy), HUD (copy), v87 (ref)
    local v88 = string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",HUD.Fat,", 1, true) ~= nil
    local Pop = HUD.Fat:FindFirstChild("Pop")

    if v87 and not v88 and HUD.Fat.Visible and Pop then
        Pop.Scale = 0.4
        TweenService:Create(Pop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    v87 = v88
end)

local function sideRoom() -- line: 809
    -- upvalues: LocalPlayer (copy), HUD (copy)
    local X = HUD.AbsoluteSize.X
    local X2 = HUD.AbsolutePosition.X
    local v89 = 0.012 * X
    local v90 = 0.988 * X

    local function shown(p32) -- line: 812
        while p32 and p32:IsA("GuiObject") do
            if not p32.Visible then
                return false
            end

            p32 = p32.Parent
        end

        if p32 == nil then
            return true
        end

        return not p32:IsA("ScreenGui") or p32.Enabled
    end

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

    for _, v92 in ipairs({
            { "MenuButtons", true },
            { "SideButtons", false }
        }) do
        local v93 = PlayerGui and PlayerGui:FindFirstChild(v92[1])

        if v93 and v93.Enabled then
            for _, child in ipairs(v93:GetChildren()) do
                if child:IsA("GuiObject") and shown(child) and child.AbsoluteSize.X > 0 then
                    if v92[2] then
                        v89 = math.max(v89, child.AbsolutePosition.X - X2 + child.AbsoluteSize.X + 0.012 * X)
                    else
                        v90 = math.min(v90, child.AbsolutePosition.X - X2 - 0.012 * X)
                    end
                end
            end
        end
    end

    return v89, (math.max(v89 + 1, v90))
end

local function cardLayout(p33) -- line: 838
    -- upvalues: HUD (copy), sideRoom (copy)
    local X, Y = HUD.AbsoluteSize.X, HUD.AbsoluteSize.Y
    local v101 = math.min(0.3 * X, 0.3 * Y)
    local v102 = if p33 > 5 then 2 else 1
    local v104 = math.ceil(p33 / v102)
    local v105, v106 = sideRoom()
    local v107 = X / 2
    local v111 = math.max(1, (math.min(v107 - v105, v106 - v107))) * 2
    local v112 = 0.17 * X
    local v113 = v101 * 0.7 * 1.8
    local v115 = math.min(v112, v111 / (v104 - 1 + v113 / v112))
    local v116 = v115 * 0.7 / v112
    local v117 = v116

    if v102 == 2 then
        v117 = 0.8 * Y / (v101 * 3.35)

        if v117 < v116 then
            v115 *= v117 / v116
        else
            v117 = v116
        end
    end

    local v118 = v101 * v117 * 1.75
    local t9 = {}

    for i = 1, p33 do
        local v119 = if v102 ~= 2 or not (v104 < i) then 1 else 2
        local v120 = v119 == 1
        local v121 = if v120 then math.min(p33, v104) else nil
        local v122 = if not v120 or not v121 then p33 - v104 else v121
        local v123 = v107 + ((if v119 ~= 1 or not i then i - v104 else i) - (v122 + 1) / 2) * v115
        local v124 = 0.5 * Y
        local v125, v126

        if v102 == 2 then
            if v119 == 1 then
                local v127 = -v118 / 2

                if v127 then
                    v125 = v127
                    v126 = true
                else
                    local v128 = v118 / 2

                    if v128 then
                        v125 = v128
                        v126 = true
                    else
                        v126 = false
                    end
                end
            else
                local v129 = v118 / 2

                if v129 then
                    v125 = v129
                    v126 = true
                else
                    v126 = false
                end
            end
        else
            v126 = false
        end

        if not v126 then
            v125 = 0
        end

        local v130 = v124 + v125

        t9[i] = UDim2.fromScale(v123 / X, v130 / Y)
    end

    return t9, v117
end

local function fadeBag(p34, p35) -- line: 877
    -- upvalues: TweenService (copy), HUD (copy)
    local Bag = HUD.Bag
    local v131 = TweenInfo.new(p35 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(Bag.Icon, v131, {
        ImageTransparency = p34
    }):Play()

    for _, v132 in ipairs({
            Bag.Count,
            Bag.Weight
        }) do
        TweenService:Create(v132, v131, {
            TextTransparency = p34
        }):Play()

        local UIStroke = v132:FindFirstChild("UIStroke")

        if UIStroke then
            TweenService:Create(UIStroke, v131, {
                Transparency = p34
            }):Play()
        end
    end
end

local t10 = {}
local n5 = 1

task.spawn(function() -- line: 892
    -- upvalues: ContentProvider (copy), SoundService (copy), t10 (copy)
    local v133 = SoundService:WaitForChild("HarpoonSFX", 10)
    local v134 = v133 and v133:WaitForChild("CatchSound", 10)

    if v134 then
        for i = 1, 6 do
            local clone = v134:Clone()

            clone.Parent = SoundService
            t10[i] = clone
        end

        ContentProvider:PreloadAsync(t10)
    end
end)

v52 = function(p36) -- line: 909
    -- upvalues: RunService (copy), TweenService (copy), LocalPlayer (copy), HUD (copy), v11 (ref), v12 (ref), setBag (copy), v37 (ref), refreshSlot (copy), makeCard (copy), popCard (copy), spinCard (copy), cardLayout (copy), fadeBag (copy), t10 (copy), n5 (ref)
    v11 = true
    LocalPlayer:SetAttribute("SurfaceReveal", true)

    local Bag = HUD.Bag
    local Pop = Bag:FindFirstChild("Pop")
    local Burst = Bag:FindFirstChild("Burst")
    local BagPosition, AnchorPoint = Bag.Position, Bag.AnchorPoint
    local v135 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(Bag, v135, {
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }):Play()

    if Pop then
        TweenService:Create(Pop, v135, {
            Scale = 1.6
        }):Play()
    end

    v37 = false
    refreshSlot()

    local v136 = HUD.Fat.Visible and HUD.Fat:FindFirstChild("Pop")

    if v136 then
        v136.Scale = 0.4
        TweenService:Create(v136, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    task.wait(0.3)

    if Pop then
        TweenService:Create(Pop, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 2.9
        }):Play()
    end

    fadeBag(1, 0.22)

    local Glow = Bag:FindFirstChild("Glow")

    if Glow then
        Glow.Size = UDim2.fromScale(1.15, 1.15)
        Glow.ImageTransparency = 0.3
        Glow.Visible = true
        TweenService:Create(Glow, TweenInfo.new(0.35200000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
            Size = UDim2.fromScale(1.6, 1.6)
        }):Play()
    end

    if Burst then
        Burst.Rotation = 0
        Burst.Size = UDim2.fromScale(1.7, 1.7)
        Burst.ImageTransparency = 0
        Burst.Visible = true
        TweenService:Create(Burst, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1,
            Size = UDim2.fromScale(3.4, 3.4)
        }):Play()
    end

    table.sort(p36, function(p37, p38) -- line: 957
        return (p37.rate or 0) > (p38.rate or 0)
    end)

    local t11 = {}
    local elapsed = os.clock()
    local connection = RunService.RenderStepped:Connect(function(p39) -- line: 960
        -- upvalues: Burst (copy), t11 (copy), elapsed (copy), spinCard (copy)
        local v137 = os.clock() - elapsed

        if Burst and Burst.Visible then
            Burst.Rotation = (Burst.Rotation + 40 * p39) % 360
        end

        for _, v138 in ipairs(t11) do
            spinCard(v138, p39, v137)
        end
    end)

    task.delay(0.4, function() -- line: 965
        -- upvalues: Bag (copy), Burst (copy), Glow (copy)
        Bag.Visible = false

        if Burst then
            Burst.Visible = false
        end

        if Glow then
            Glow.Visible = false
        end
    end)

    local v139, v140 = cardLayout(#p36)

    for v141, v142 in ipairs(p36) do
        local name, mutation, weight, crown = v142.name, v142.mutation, v142.weight, v142.crown

        if not crown then
            crown = if v142.hat == true then "hat" else v142.hat or nil
        end

        local v143 = makeCard(name, mutation, weight, crown)

        if v143 then
            v143.Position = v139[v141]
            v143.Visible = true
            v143.Parent = HUD
            popCard(v143, v140)

            if #t10 ~= 0 then
                t10[n5]:Play()
                n5 = n5 % #t10 + 1
            end

            t11[#t11 + 1] = v143
        end

        task.wait(0.06)
    end

    task.wait(1)

    local v145 = not v12
    local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

    if BackpackGui then
        BackpackGui.Enabled = v145
    end

    local v146 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    for _, v147 in ipairs(t11) do
        TweenService:Create(v147.Pop, v146, {
            Scale = v140 * 0.75
        }):Play()

        for _, v148 in ipairs({
                v147.Image,
                v147.Burst,
                v147.Image:FindFirstChild("Badge"),
                v147.Image:FindFirstChild("CrownBadge")
            }) do
            TweenService:Create(v148, v146, {
                ImageTransparency = 1
            }):Play()
        end

        for _, v149 in ipairs({
                v147.Species,
                v147.Rarity,
                v147.Weight
            }) do
            TweenService:Create(v149, v146, {
                TextTransparency = 1
            }):Play()
            TweenService:Create(v149.UIStroke, v146, {
                Transparency = 1
            }):Play()
        end
    end

    task.wait(0.15)
    connection:Disconnect()

    for _, v150 in ipairs(t11) do
        v150:Destroy()
    end

    if Pop then
        Pop.Scale = 1
    end

    Bag.Position = BagPosition
    Bag.AnchorPoint = AnchorPoint
    fadeBag(0)
    v11 = false
    LocalPlayer:SetAttribute("SurfaceReveal", nil)
    setBag()
    v37 = v12
    refreshSlot()
end

CatchAnnounce.OnClientEvent:Connect(function(p40, p41, p42, p43, p44, _, p46, p47, p48) -- line: 1011
    -- upvalues: LocalPlayer (copy), v10 (ref), flyCatch (copy)
    if p40 ~= LocalPlayer.Name then
        return
    end

    local v151 = p46 == true or (if p47 == true then "hat" else p47 or false)

    flyCatch(p41, p42, p43, p44, v151)

    if p48 ~= true then
        return
    end

    task.spawn(function() -- line: 1017
        -- upvalues: p41 (copy), p42 (copy), p43 (copy), v151 (copy), v10 (ref), flyCatch (copy)
        local elapsed = os.clock()

        repeat
            task.wait(0.1)
        until not v10 or os.clock() - elapsed > 6

        flyCatch(p41, p42, p43, "Double", v151)
    end)
end)
Remotes:WaitForChild("PurchaseGranted").OnClientEvent:Connect(function(p49, p50) -- line: 1027
    -- upvalues: LocalPlayer (copy), flyCatch (copy)
    local v152, v153

    if p49 == "Recover" and type(p50) == "table" then
        if type(p50.name) == "string" then
            v152 = LocalPlayer.PlayerGui:FindFirstChild("RecoverGui") and LocalPlayer.PlayerGui.RecoverGui:FindFirstChild("Panel")
            v153 = false
        else
            v153 = true
        end
    else
        v153 = true
    end

    if v153 then
        return
    end

    task.spawn(function() -- line: 1030
        -- upvalues: p50 (copy), v152 (ref), flyCatch (copy)
        task.wait()

        while v152 and v152.Visible do
            task.wait(0.1)
        end

        flyCatch(p50.name, p50.mutation, p50.weight, p50.tag)
    end)
end)

local IndexZones = require(ReplicatedStorage.Modules:WaitForChild("IndexZones"))
local n6 = 0

local function warm(p51) -- line: 1044
    -- upvalues: ContentProvider (copy), HUD (copy)
    local t12 = {}

    for _, v154 in ipairs(p51) do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Image = v154
        ImageLabel.Visible = false
        ImageLabel.Parent = HUD
        t12[#t12 + 1] = ImageLabel
    end

    local function v155() -- line: 1053
        -- upvalues: t12 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t12)
    end

    pcall(v155)

    for _, v156 in ipairs(t12) do
        v156:Destroy()
    end
end

local function warmZones() -- line: 1056
    -- upvalues: LocalPlayer (copy), FishDisplay (copy), MutationDisplay (copy), IndexZones (copy), n6 (ref), warm (copy)
    local v157 = (LocalPlayer:GetAttribute("ReachZone") or 1) + 1

    if v157 <= n6 then
        return
    end

    local t13 = {}

    if n6 == 0 then
        t13[1] = "rbxassetid://76566560352940"

        for v158, v159 in pairs(FishDisplay) do
            if v159.icon and not IndexZones[v158] and not v159.world then
                t13[#t13 + 1] = v159.icon
            end
        end

        for _, v160 in pairs(MutationDisplay) do
            if v160.icon then
                t13[#t13 + 1] = v160.icon
            end
        end
    end

    for v161, v162 in pairs(FishDisplay) do
        local v163 = IndexZones[v161]

        if v162.icon and v163 and n6 < v163 and v163 <= v157 then
            t13[#t13 + 1] = v162.icon
        end
    end

    n6 = v157
    task.spawn(warm, t13)
end

warmZones()
LocalPlayer:GetAttributeChangedSignal("ReachZone"):Connect(warmZones)

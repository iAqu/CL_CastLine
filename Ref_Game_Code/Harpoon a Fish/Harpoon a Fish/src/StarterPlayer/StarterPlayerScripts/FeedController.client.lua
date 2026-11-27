-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local Format = require(Modules:WaitForChild("Format"))
local Toast = require(Modules:WaitForChild("Toast"))
local GrowthDisplay = require(Modules:WaitForChild("GrowthDisplay"))
local Loc = require(Modules:WaitForChild("Loc"))
local FishGroupOrder = require(Modules:WaitForChild("FishGroupOrder"))
local Funnel = require(Modules:WaitForChild("Funnel"))
local TelemetryReport = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TelemetryReport")

local function log(p1, p2) -- line: 46
    -- upvalues: TelemetryReport (copy)
    TelemetryReport:FireServer("feeding", p1, p2)
end

local LocalPlayer = Players.LocalPlayer

local function serverNow() -- line: 55
    return (math.floor((workspace:GetServerTimeNow())))
end

local PassPerks = require(Modules:WaitForChild("PassPerks"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
local v1 = utf8.char(57346)
local t1 = {}

local function rarityOfRow(p3) -- line: 70
    -- upvalues: FishDisplay (copy)
    local v2 = FishDisplay[p3:GetAttribute("Species") or ""]

    return v2 and v2.rarity or "Common"
end

local function capCredit(p4) -- line: 74
    -- upvalues: LocalPlayer (copy)
    return (LocalPlayer:GetAttribute("CapCredit" .. p4) or 0) > 0
end

local function dressCap(p5) -- line: 75
    -- upvalues: FishDisplay (copy), Loc (copy), LocalPlayer (copy), ShopConfig (copy), v1 (copy), t1 (copy)
    local Body = p5:FindFirstChild("Body")
    local Cap = Body and Body:FindFirstChild("Cap")
    local Text = Cap and Cap:FindFirstChild("Text")

    if not Text then
        return
    end

    local v3 = FishDisplay[p5:GetAttribute("Species") or ""]
    local rarity = v3 and v3.rarity or "Common"
    local v4 = ShopConfig.CAP[rarity]

    Text.AutoLocalize = false

    if (LocalPlayer:GetAttribute("CapCredit" .. rarity) or 0) > 0 then
        Text.Text = Loc.T("FREE +1 CAP")
    elseif v4 then
        Text.Text = Loc.F("feed.robux_cap", "{robux} +1 CAP", {
            robux = v1 .. " " .. tostring(t1[rarity] or v4.price)
        })
    else
        Text.Text = Loc.T("+1 CAP")
    end
end

local function dressAllCaps() -- line: 87
    -- upvalues: LocalPlayer (copy), dressCap (copy)
    for _, descendant in ipairs(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("FeedGui"):GetDescendants()) do
        if descendant.Name == "Cap" and descendant.Parent and descendant.Parent.Name == "Body" and descendant.Parent.Parent and descendant.Parent.Parent:GetAttribute("Id") then
            dressCap(descendant.Parent.Parent)
        end
    end
end

task.spawn(function() -- line: 94
    -- upvalues: ShopConfig (copy), t1 (copy), dressAllCaps (copy)
    local MarketplaceService = game:GetService("MarketplaceService")

    for v6, v7 in pairs(ShopConfig.CAP) do
        local GetProductInfo = MarketplaceService.GetProductInfo
        local product = v7.product
        local Product = Enum.InfoType.Product
        local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

        if ok and result and type(result.PriceInRobux) == "number" then
            t1[v6] = result.PriceInRobux
        end
    end

    dressAllCaps()
end)

for v8 in pairs(ShopConfig.CAP) do
    LocalPlayer:GetAttributeChangedSignal("CapCredit" .. v8):Connect(dressAllCaps)
end

local function realLeft(p6) -- line: 107
    local v9 = p6:GetAttribute("StageEnd") or 0

    if not (v9 > 0) then
        return 0
    end

    return math.ceil(v9 - workspace:GetServerTimeNow()) or 0
end

local function growSpeed() -- line: 111
    -- upvalues: LocalPlayer (copy), PassPerks (copy)
    return PassPerks.GrowSpeed(LocalPlayer)
end

local function shownLeft(p7) -- line: 112
    -- upvalues: LocalPlayer (copy), PassPerks (copy)
    return (p7 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)
end

local FeedGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("FeedGui")
local SideButtons = LocalPlayer.PlayerGui:WaitForChild("SideButtons")
local FeedSlot = SideButtons:WaitForChild("FeedSlot")
local Button = FeedSlot:WaitForChild("Button")
local Scale = FeedSlot:WaitForChild("Scale")
local FishSlot = SideButtons:WaitForChild("FishSlot")
local Scale2 = FishSlot:WaitForChild("Scale")
local Panel = FeedGui:WaitForChild("Panel")
local Scale3 = Panel:WaitForChild("Scale")
local Close = Panel:WaitForChild("Close")
local Side = Panel:WaitForChild("Side")
local Scale4 = Side:WaitForChild("Scale")
local Square = Side:WaitForChild("Square")
local Icon = Square:WaitForChild("Icon")
local Title = Side:WaitForChild("Title")
local Stage = Side:WaitForChild("Stage")

local function placeStage() -- line: 139
    -- upvalues: Side (copy), Title (copy), Stage (copy)
    local X = Side.AbsoluteSize.X

    if not (X < 1) then
        Stage.Position = UDim2.new(Title.Position.X.Scale + Title.TextBounds.X / X + 0.012, 0, Title.Position.Y.Scale, 0)
    end
end

Title:GetPropertyChangedSignal("TextBounds"):Connect(placeStage)
Side:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeStage)

local Timer = Side:WaitForChild("Timer")
local Skip = Side:WaitForChild("Skip")

for _, v11 in ipairs({ Title, Stage, Timer, Skip }) do
    v11.AutoLocalize = false
end

local Grid = Side:WaitForChild("GridClip"):WaitForChild("Grid")
local v12
local UIListLayout = Grid:WaitForChild("UIListLayout")
local Scale5 = Close.Position.X.Scale
local List = Panel:WaitForChild("Body"):WaitForChild("ListClip"):WaitForChild("List")

require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Watch(List.Parent)

local UIListLayout2 = List:WaitForChild("UIListLayout")
local UIPadding = List:WaitForChild("UIPadding")
local t3 = {
    TWIST = 15,
    FROM = 0.35,
    OPEN_TIME = 0.32,
    CLOSE_TIME = 0.2,
    BUTTON_OUT = 0.12,
    BUTTON_IN = 0.28,
    OPEN_SOUND = "PanelOpen",
    CLOSE_SOUND = "PanelClose",
    FEED_SOUND = "FeedPress",
    FEED_PITCH = { 0.95, 1.05 }
}
local v13 = TweenInfo.new(t3.OPEN_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v14 = TweenInfo.new(t3.CLOSE_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local v15 = TweenInfo.new(t3.BUTTON_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v16 = TweenInfo.new(t3.BUTTON_IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v17 = Random.new()
local v18 = false
local v19 = false
local v20 = false
local v21 = false
local v22

local function playSound(p8, p9) -- line: 188
    -- upvalues: SoundService (copy), v17 (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v23 = HarpoonSFX and HarpoonSFX:FindFirstChild(p8)

    if v23 then
        if p9 then
            v23.PlaybackSpeed = v17:NextNumber(p9[1], p9[2])
        end

        v23:Play()
    end
end

local function twist() -- line: 196
    -- upvalues: t3 (copy), v17 (copy)
    return v17:NextInteger(0, 1) == 0 and -t3.TWIST or t3.TWIST
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local close

local function open() -- line: 203
    -- upvalues: TweenService (copy), SoundService (copy), Funnel (copy), TelemetryReport (copy), FeedGui (copy), FeedSlot (copy), Scale (copy), FishSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), Close (copy), t3 (copy), v13 (copy), v15 (copy), v17 (copy), v18 (ref), v19 (ref), PadMenu (copy), close (ref)
    if v18 or v19 then
        return
    end

    v18 = true
    v19 = true
    Funnel.Report("feed_panel")
    TelemetryReport:FireServer("feeding", "open", nil)

    local OPEN_SOUND = t3.OPEN_SOUND
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v24 = HarpoonSFX and HarpoonSFX:FindFirstChild(OPEN_SOUND)

    if v24 then
        v24:Play()
    end

    for _, v25 in ipairs({
            { FeedSlot, Scale },
            { FishSlot, Scale2 }
        }) do
        local v26 = v25[1]
        local tween = TweenService:Create(v25[2], v15, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 214
            -- upvalues: v26 (copy), v19 (ref)
            if v19 then
                v26.Visible = false
            end
        end)
        tween:Play()
    end

    Scale3.Scale = t3.FROM
    Panel.Rotation = v17:NextInteger(0, 1) == 0 and -t3.TWIST or t3.TWIST
    Panel.Visible = true
    TweenService:Create(Panel, v13, {
        Rotation = 0
    }):Play()

    local tween = TweenService:Create(Scale3, v13, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 223
        -- upvalues: v18 (ref)
        v18 = false
    end)
    tween:Play()
    PadMenu.Open(FeedGui, function() -- line: 225
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close
    })
end

local AspectRatio = Side:WaitForChild("UIAspectRatioConstraint").AspectRatio
local AspectRatio2 = Panel:WaitForChild("UIAspectRatioConstraint").AspectRatio

local function arrowOutX() -- line: 234
    -- upvalues: Side (copy), AspectRatio (copy), AspectRatio2 (copy)
    local v29 = Side.Size.Y.Scale * AspectRatio / AspectRatio2

    return Side.Position.X.Scale - v29 - 0.025
end

local function showRow(p10) -- line: 240
    -- upvalues: Square (copy), Icon (copy), Title (copy), v12 (ref), v22 (ref)
    local Square2 = p10.Body:FindFirstChild("Square")
    local Icon2 = Square2 and Square2:FindFirstChild("Icon")

    if not Icon2 then
        return
    end

    local Image, ImageRectOffset, ImageRectSize = Square2.Image, Square2.ImageRectOffset, Square2.ImageRectSize

    Square.Image = Image
    Square.ImageRectOffset = ImageRectOffset
    Square.ImageRectSize = ImageRectSize
    Square.ImageColor3 = Square2.ImageColor3

    local Image2, ImageRectOffset2, ImageRectSize2 = Icon2.Image, Icon2.ImageRectOffset, Icon2.ImageRectSize

    Icon.Image = Image2
    Icon.ImageRectOffset = ImageRectOffset2
    Icon.ImageRectSize = ImageRectSize2

    local Title2 = p10.Body:FindFirstChild("Title")

    if Title2 then
        local Grad = Title2:FindFirstChild("Grad")
        local Grad2 = Title:FindFirstChild("Grad")

        if Grad and Grad2 then
            Grad2.Color = Grad.Color
        end

        Title.UIStroke.Color = Title2.UIStroke.Color
    end

    v22 = p10
    v12()
end

local function popSide() -- line: 258
    -- upvalues: TweenService (copy), SoundService (copy), Close (copy), Side (copy), Scale4 (copy), t3 (copy), v13 (copy), v17 (copy), v21 (ref), AspectRatio (copy), AspectRatio2 (copy)
    local OPEN_SOUND = t3.OPEN_SOUND
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v30 = HarpoonSFX and HarpoonSFX:FindFirstChild(OPEN_SOUND)

    if v30 then
        v30:Play()
    end

    Scale4.Scale = t3.FROM
    Side.Rotation = v17:NextInteger(0, 1) == 0 and -t3.TWIST or t3.TWIST
    Side.Visible = true
    TweenService:Create(Side, v13, {
        Rotation = 0
    }):Play()

    local fromScale = UDim2.fromScale
    local v32 = Side.Size.Y.Scale * AspectRatio / AspectRatio2

    TweenService:Create(Close, v13, {
        Position = fromScale(Side.Position.X.Scale - v32 - 0.025, 0.5)
    }):Play()

    local tween = TweenService:Create(Scale4, v13, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 266
        -- upvalues: v21 (ref)
        v21 = false
    end)
    tween:Play()
end

local function openSide(p11) -- line: 272
    -- upvalues: TweenService (copy), Funnel (copy), TelemetryReport (copy), Close (copy), Side (copy), Scale4 (copy), Scale5 (copy), t3 (copy), v14 (copy), v17 (copy), v18 (ref), v19 (ref), v20 (ref), v21 (ref), v22 (ref), showRow (copy), popSide (copy)
    if v18 or not v19 or v21 or p11 == v22 then
        return
    end

    v21 = true
    Funnel.Report("feed_drawer")
    TelemetryReport:FireServer("feeding", "drawer", nil)

    if v20 then
        TweenService:Create(Side, v14, {
            Rotation = v17:NextInteger(0, 1) == 0 and -t3.TWIST or t3.TWIST
        }):Play()
        TweenService:Create(Close, v14, {
            Position = UDim2.fromScale(Scale5, 0.5)
        }):Play()

        local tween = TweenService:Create(Scale4, v14, {
            Scale = t3.FROM
        })

        tween.Completed:Once(function() -- line: 285
            -- upvalues: p11 (copy), v19 (ref), showRow (copy), popSide (copy)
            if v19 then
                showRow(p11)
                popSide()
            end
        end)
        tween:Play()
    else
        v20 = true
        showRow(p11)
        popSide()
    end
end

local v33

local function close2() -- line: 296
    -- upvalues: TweenService (copy), SoundService (copy), TelemetryReport (copy), FeedGui (copy), FeedSlot (copy), Scale (copy), FishSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), Close (copy), Side (copy), Scale4 (copy), Scale5 (copy), t3 (copy), v14 (copy), v16 (copy), v17 (copy), v18 (ref), v19 (ref), v20 (ref), v21 (ref), v22 (ref), PadMenu (copy), v33 (ref)
    local v34, v35

    if v18 then
        v35 = true
    elseif v19 then
        v18 = true
        v19 = false
        TelemetryReport:FireServer("feeding", "close", nil)
        PadMenu.Close(FeedGui)

        local CLOSE_SOUND = t3.CLOSE_SOUND
        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")

        v34 = HarpoonSFX and HarpoonSFX:FindFirstChild(CLOSE_SOUND)
        v35 = false
    else
        v35 = true
    end

    if v35 then
        return
    end

    if v34 then
        v34:Play()
    end

    TweenService:Create(Panel, v14, {
        Rotation = v17:NextInteger(0, 1) == 0 and -t3.TWIST or t3.TWIST
    }):Play()

    local tween = TweenService:Create(Scale3, v14, {
        Scale = t3.FROM
    })

    tween.Completed:Once(function() -- line: 306
        -- upvalues: TweenService (copy), FeedSlot (copy), Scale (copy), FishSlot (copy), Scale2 (copy), Panel (copy), Close (copy), Side (copy), Scale4 (copy), Scale5 (copy), t3 (copy), v16 (copy), v18 (ref), v20 (ref), v21 (ref), v22 (ref), v33 (ref)
        Panel.Visible = false
        Panel.Rotation = 0
        Side.Visible = false
        Side.Rotation = 0
        Scale4.Scale = 1
        v20 = false
        v33()
        v21 = false
        v22 = nil
        Close.Position = UDim2.fromScale(Scale5, 0.5)

        for _, v36 in ipairs({
                { FeedSlot, Scale },
                { FishSlot, Scale2 }
            }) do
            v36[1].Visible = true
            v36[2].Scale = 0
            TweenService:Create(v36[2], v16, {
                Scale = 1
            }):Play()
        end

        task.delay(t3.BUTTON_IN, function() -- line: 323
            -- upvalues: v18 (ref)
            v18 = false
        end)
    end)
    tween:Play()
end

ButtonHover.Attach(Button, {
    shine = false,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8,
    icon = Button:WaitForChild("Icon")
})
ButtonHover.Attach(Close, {
    shine = false,
    iconTilt = 0,
    icon = Close:WaitForChild("Arrow")
})

local t7 = {
    shine = false,
    buttonScale = 1.03
}
local v37 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v38 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function wireRow(p12) -- line: 342
    -- upvalues: TweenService (copy), Modules (copy), ButtonHover (copy), FishDisplay (copy), Loc (copy), LocalPlayer (copy), ShopConfig (copy), PurchaseFX (copy), Panel (copy), openSide (copy), t7 (copy), v37 (copy), v38 (copy)
    if p12:IsA("ImageLabel") and p12.Name ~= "Entry" then
        local Body = p12:WaitForChild("Body")

        ButtonHover.Attach(Body, t7)

        local Feed = Body:FindFirstChild("Feed")

        if not Feed then
            return
        end

        ButtonHover.Attach(Feed, {
            shine = false,
            highlight = true
        })

        local Skip = Body:FindFirstChild("Skip")

        if Skip then
            Skip.Text.AutoLocalize = false
            Skip.Text.Text = Loc.T("GROW NOW")

            local v39 = Skip:GetAttribute("Corner") or 0.2

            ButtonHover.Attach(Skip, {
                shine = false,
                highlight = true,
                tile = 1,
                corner = v39,
                highlightCorner = v39
            })
            Skip.Activated:Connect(function() -- line: 359
                -- upvalues: p12 (copy), Body (copy), Skip (copy), Modules (copy), ButtonHover (copy), FishDisplay (copy), Panel (copy)
                ButtonHover.Press(Skip)

                local Square = Body:FindFirstChild("Square")
                local Icon = Square and Square:FindFirstChild("Icon")
                local Press = require(Modules:WaitForChild("GrowNowCard")).Press
                local t8 = {
                    id = p12:GetAttribute("Id")
                }
                local v40 = p12:GetAttribute("StageEnd") or 0

                t8.left = v40 > 0 and math.ceil(v40 - workspace:GetServerTimeNow()) or 0
                t8.icon = Icon and Icon.Image
                t8.rect = Icon and {
                    Icon.ImageRectOffset,
                    Icon.ImageRectSize
                }

                local v42 = FishDisplay[p12:GetAttribute("Species") or ""]

                t8.rarity = v42 and v42.rarity or "Common"
                t8.nextStage = (p12:GetAttribute("Stage") or 1) + 1
                t8.host = Panel
                Press(t8, p12)
            end)
        end

        local Max = Body:FindFirstChild("Max")
        local Cap = Body:FindFirstChild("Cap")

        for _, v43 in ipairs({ Max, Cap }) do
            local v44 = v43:GetAttribute("Corner") or 0.2

            ButtonHover.Attach(v43, {
                shine = false,
                highlight = true,
                tile = 1,
                corner = v44,
                highlightCorner = v44
            })
        end

        Max.Activated:Connect(function() -- line: 377
            -- upvalues: Max (copy), ButtonHover (copy)
            ButtonHover.Press(Max)
        end)
        Cap.Activated:Connect(function() -- line: 378
            -- upvalues: p12 (copy), Cap (copy), ButtonHover (copy), FishDisplay (copy), LocalPlayer (copy), ShopConfig (copy), PurchaseFX (copy)
            ButtonHover.Press(Cap)

            local Id = p12:GetAttribute("Id")

            if not Id then
                return
            end

            local v45 = FishDisplay[p12:GetAttribute("Species") or ""]
            local rarity = v45 and v45.rarity or "Common"
            local v46 = ShopConfig.CAP[rarity]
            local v47 = (LocalPlayer:GetAttribute("CapCredit" .. rarity) or 0) > 0

            if v46 or v47 then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AquariumAction"):FireServer("Cap", Id)

                if not v47 then
                    PurchaseFX.Buy(v46.product)
                end
            end
        end)

        for _, v48 in ipairs({ "Title", "Stage" }) do
            local v49 = Body:FindFirstChild(v48)

            if v49 then
                local v50 = v49:FindFirstChild("Scale") or Instance.new("UIScale")

                v50.Name = "Scale"
                v50.Parent = v49

                for _, v51 in ipairs({ Feed, Skip, Max, Cap }) do
                    v51.MouseEnter:Connect(function() -- line: 397
                        -- upvalues: v50 (copy), TweenService (copy), v37 (copy)
                        TweenService:Create(v50, v37, {
                            Scale = 0.9
                        }):Play()
                    end)
                    v51.MouseLeave:Connect(function() -- line: 398
                        -- upvalues: v50 (copy), TweenService (copy), v38 (copy)
                        TweenService:Create(v50, v38, {
                            Scale = 1
                        }):Play()
                    end)
                    v51.SelectionGained:Connect(function() -- line: 400
                        -- upvalues: v50 (copy), TweenService (copy), v37 (copy)
                        TweenService:Create(v50, v37, {
                            Scale = 0.9
                        }):Play()
                    end)
                    v51.SelectionLost:Connect(function() -- line: 401
                        -- upvalues: v50 (copy), TweenService (copy), v38 (copy)
                        TweenService:Create(v50, v38, {
                            Scale = 1
                        }):Play()
                    end)
                end
            end
        end

        Feed.Activated:Connect(function() -- line: 405
            -- upvalues: p12 (copy), openSide (copy)
            openSide(p12)
        end)
    end
end

for _, child in ipairs(List:GetChildren()) do
    wireRow(child)
end

List.ChildAdded:Connect(wireRow)

local t9 = {
    shine = false,
    highlight = true
}
local FeedButton = Side:WaitForChild("FeedButton")

ButtonHover.Attach(FeedButton, t9)

local Scale6 = Square:WaitForChild("Scale")
local Scale7 = Title:WaitForChild("Scale")
local Scale8 = Timer:WaitForChild("Scale")
local Scale9 = Skip:WaitForChild("Scale")

local function sideAside() -- line: 419
    -- upvalues: TweenService (copy), v37 (copy), Scale6 (copy), Scale7 (copy), Scale8 (copy), Scale9 (copy)
    for _, v52 in ipairs({ Scale6, Scale7, Scale8, Scale9 }) do
        TweenService:Create(v52, v37, {
            Scale = 0.9
        }):Play()
    end
end

local function sideBack() -- line: 424
    -- upvalues: TweenService (copy), v38 (copy), Scale6 (copy), Scale7 (copy), Scale8 (copy), Scale9 (copy)
    for _, v53 in ipairs({ Scale6, Scale7, Scale8, Scale9 }) do
        TweenService:Create(v53, v38, {
            Scale = 1
        }):Play()
    end
end

FeedButton.MouseEnter:Connect(sideAside)
FeedButton.MouseLeave:Connect(sideBack)
FeedButton.SelectionGained:Connect(sideAside)
FeedButton.SelectionLost:Connect(sideBack)

local t10 = {}
local t11 = {
    0.95, 1.05
}
local t12 = {
    0.8, 0.9
}
local v54 = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v55 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local v56 = TweenInfo.new(1.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local t13 = {}

local function showFeedButton() -- line: 460
    -- upvalues: Panel (copy), v19 (ref), FeedButton (copy), sideBack (copy), t13 (copy)
    local v57 = next(t13) ~= nil

    if FeedButton.Visible == v57 then
        return
    end

    if v57 or v19 or not Panel.Visible then
        FeedButton.Visible = v57

        if not v57 then
            sideBack()
        end
    end
end

local v58 = next(t13) ~= nil

if FeedButton.Visible ~= v58 and (v58 or v19 or not Panel.Visible) then
    FeedButton.Visible = v58

    if not v58 then
        sideBack()
    end
end

local function tickSide() -- line: 475
    -- upvalues: Format (copy), LocalPlayer (copy), PassPerks (copy), Timer (copy), v22 (ref)
    local v59 = v22

    if not v59 then
        return
    end

    local v60 = v59:GetAttribute("StageEnd") or 0

    Timer.Text = v60 > 0 and Format.time((v60 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)) or ""
end

v12 = function() -- line: 481
    -- upvalues: Format (copy), GrowthDisplay (copy), LocalPlayer (copy), PassPerks (copy), Side (copy), Title (copy), Stage (copy), Timer (copy), Skip (copy), v22 (ref), t13 (copy)
    local v62 = v22

    if not v62 then
        return
    end

    Title.Text = v62.Body.Title.Text:match("^[^\n]*") or ""

    local v63 = v62:GetAttribute("Stage") or 1
    local v64 = GrowthDisplay.Hex(v63)

    Stage.Text = GrowthDisplay.stages[v63] and "<font color=\"" .. v64 .. "\">(</font>" .. GrowthDisplay.Span(v63, true, v62:GetAttribute("Inf")) .. "<font color=\"" .. v64 .. "\">)</font>" or ""

    local X = Side.AbsoluteSize.X

    if not (X < 1) then
        Stage.Position = UDim2.new(Title.Position.X.Scale + Title.TextBounds.X / X + 0.012, 0, Title.Position.Y.Scale, 0)
    end

    local v66 = v22

    if v66 then
        local v67 = v66:GetAttribute("StageEnd") or 0

        Timer.Text = v67 > 0 and Format.time((v67 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)) or ""
    end

    local n1 = 0
    local n2 = 0

    for v69 in pairs(t13) do
        n1 += v69:GetAttribute("Skip") or 0
        n2 += 1
    end

    local v70 = ((v62:GetAttribute("StageEnd") or 0) - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)

    if n2 > 0 and v70 > 0 and LocalPlayer:GetAttribute("TutorialFeedReadies") then
        n1 = (math.floor(v70 / 60) + 1) * 60
    end

    Skip.Text = n2 > 0 and "-" .. Format.time(n1) or ""
end

LocalPlayer:GetAttributeChangedSignal("TutorialFeedReadies"):Connect(function() -- line: 502
    -- upvalues: v12 (ref)
    v12()
end)

local function setSelected(p13, p14, p15) -- line: 504
    -- upvalues: TweenService (copy), SoundService (copy), Funnel (copy), TelemetryReport (copy), Panel (copy), v12 (ref), v17 (copy), v19 (ref), FeedButton (copy), sideBack (copy), t11 (copy), t12 (copy), v54 (copy), v55 (copy), v56 (copy), t13 (copy)
    local Body = p13.Body
    local Scale, Glow = Body.Scale, Body.Glow

    p13:SetAttribute("Selected", p14 or nil)

    if p14 then
        Funnel.Report("food_selected")
        TelemetryReport:FireServer("feeding", "food", nil)
        t13[p13] = t13[p13] or true
    else
        local v73 = t13[p13]

        t13[p13] = nil

        if v73 ~= true and v73 then
            v73:Cancel()
        end
    end

    local v74 = next(t13) ~= nil

    if FeedButton.Visible ~= v74 and (v74 or v19 or not Panel.Visible) then
        FeedButton.Visible = v74

        if not v74 then
            sideBack()
        end
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

    if TileSelect and not p15 then
        local v75 = p14 and t11 or t12

        TileSelect.PlaybackSpeed = v17:NextNumber(v75[1], v75[2])
        TileSelect:Play()
    end

    if not p15 then
        v12()
    end

    if p14 then
        Glow.Band.Rotation = 0

        local tween = TweenService:Create(Glow.Band, v56, {
            Rotation = 360
        })

        tween:Play()
        t13[p13] = tween
        TweenService:Create(Scale, v54, {
            Scale = 0.75
        }):Play()
        TweenService:Create(Glow, v54, {
            Transparency = 0
        }):Play()
    else
        TweenService:Create(Scale, v55, {
            Scale = 1
        }):Play()

        local tween = TweenService:Create(Glow, v55, {
            Transparency = 1
        })

        tween.Completed:Once(function() -- line: 536
            -- upvalues: p13 (copy), Glow (copy), t13 (copy)
            local Band = Glow:FindFirstChild("Band")

            if Band and not t13[p13] then
                Band.Rotation = 0
            end
        end)
        tween:Play()
    end
end

v33 = function() -- line: 547
    -- upvalues: Panel (copy), v19 (ref), FeedButton (copy), sideBack (copy), t13 (copy)
    for v76, v77 in pairs(t13) do
        if v77 ~= true then
            v77:Cancel()
        end

        v76:SetAttribute("Selected", nil)
        v76.Body.Scale.Scale = 1
        v76.Body.Glow.Transparency = 1
        v76.Body.Glow.Band.Rotation = 0
    end

    table.clear(t13)

    local v78 = next(t13) ~= nil

    if FeedButton.Visible == v78 then
        return
    end

    if v78 or v19 or not Panel.Visible then
        FeedButton.Visible = v78

        if not v78 then
            sideBack()
        end
    end
end

local v79 = false
local v80

local function paint(p16) -- line: 564
    -- upvalues: t13 (copy), setSelected (copy), v80 (ref)
    if t13[p16] ~= nil ~= v80 then
        setSelected(p16, v80)
    end
end

local _ = {
    AMP = 0.12,
    SPEED = 6.3,
    GLOW = 0.2
}
local t14 = {}

local function beckonTile(p17) -- line: 575
    -- upvalues: TweenService (copy), v55 (copy), t13 (copy), t14 (copy)
    local Body, Scale, v81

    if t14[p17] then
        v81 = true
    elseif p17:GetAttribute("TutorialBeckon") then
        Body = p17:FindFirstChild("Body")
        Scale = Body and Body:FindFirstChild("Scale")
        v81 = false
    else
        v81 = true
    end

    if v81 then
        return
    end

    local Glow = Body and Body:FindFirstChild("Glow")

    if not (Scale and Glow) then
        return
    end

    t14[p17] = true
    task.spawn(function() -- line: 581
        -- upvalues: p17 (copy), Scale (ref), Glow (copy), TweenService (copy), v55 (copy), t13 (copy), t14 (copy)
        local Heartbeat = game:GetService("RunService").Heartbeat
        local elapsed = os.clock()

        while p17.Parent and p17:GetAttribute("TutorialBeckon") and t13[p17] == nil do
            local v83 = math.sin((os.clock() - elapsed) * 6.3) * 0.5 + 0.5

            Scale.Scale = 1 + 0.12 * v83
            Glow.Transparency = 1 - 0.8 * v83
            Heartbeat:Wait()
        end

        t14[p17] = nil

        if p17.Parent and t13[p17] == nil then
            TweenService:Create(Scale, v55, {
                Scale = 1
            }):Play()
            TweenService:Create(Glow, v55, {
                Transparency = 1
            }):Play()
        end
    end)
end

local function wireTile(p18) -- line: 598
    -- upvalues: ButtonHover (copy), Grid (copy), t10 (copy), t13 (copy), setSelected (copy), v79 (ref), v80 (ref), beckonTile (copy)
    if not p18:IsA("ImageButton") or p18.Name == "Tile" then
        return
    end

    p18:GetAttributeChangedSignal("TutorialBeckon"):Connect(function() -- line: 600
        -- upvalues: p18 (copy), beckonTile (copy)
        beckonTile(p18)
    end)

    local Face = p18:WaitForChild("Body"):WaitForChild("Face")

    ButtonHover.Attach(Face, {
        shine = false,
        icon = Face:WaitForChild("IconGroup")
    })
    t10[p18] = true
    p18.AncestryChanged:Connect(function() -- line: 604
        -- upvalues: p18 (copy), Grid (copy), t10 (copy)
        if not p18:IsDescendantOf(Grid) then
            t10[p18] = nil
        end
    end)
    p18.InputBegan:Connect(function(p19) -- line: 605
        -- upvalues: p18 (copy), t13 (copy), setSelected (copy), v79 (ref), v80 (ref)
        if p19.UserInputType ~= Enum.UserInputType.MouseButton1 and p19.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        v79 = true
        v80 = t13[p18] == nil
        setSelected(p18, v80)
    end)
    p18.MouseEnter:Connect(function() -- line: 611
        -- upvalues: p18 (copy), t13 (copy), setSelected (copy), v79 (ref), v80 (ref)
        if v79 and t13[p18] ~= nil ~= v80 then
            setSelected(p18, v80)
        end
    end)
    p18.Activated:Connect(function(p20) -- line: 614
        -- upvalues: p18 (copy), t13 (copy), setSelected (copy)
        if p20 and p20.UserInputType.Name:find("Gamepad") then
            setSelected(p18, t13[p18] == nil)
        end
    end)
end

UserInputService.InputEnded:Connect(function(p21) -- line: 620
    -- upvalues: v79 (ref)
    if p21.UserInputType == Enum.UserInputType.MouseButton1 or p21.UserInputType == Enum.UserInputType.Touch then
        v79 = false
    end
end)
UserInputService.InputChanged:Connect(function(p22) -- line: 624
    -- upvalues: GuiService (copy), t10 (copy), t13 (copy), setSelected (copy), v79 (ref), v80 (ref)
    if not v79 or p22.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local v85 = Vector2.new(p22.Position.X, p22.Position.Y) - GuiService:GetGuiInset()

    for v86 in pairs(t10) do
        local AbsolutePosition, AbsoluteSize = v86.AbsolutePosition, v86.AbsoluteSize

        if v85.X >= AbsolutePosition.X and v85.Y >= AbsolutePosition.Y and v85.X <= AbsolutePosition.X + AbsoluteSize.X and v85.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
            if t13[v86] ~= nil == v80 then
                break
            end

            setSelected(v86, v80)

            return
        end
    end
end)

for _, child in ipairs(Grid:GetChildren()) do
    wireTile(child)
end

Grid.ChildAdded:Connect(wireTile)

local SelectAll = Side:WaitForChild("SelectAll")

ButtonHover.Attach(SelectAll, t9)

local Scale10 = SelectAll.Position.Y.Scale

local function nudgeDown() -- line: 644
    -- upvalues: TweenService (copy), v37 (copy), SelectAll (copy), Scale10 (copy)
    TweenService:Create(SelectAll, v37, {
        Position = UDim2.fromScale(SelectAll.Position.X.Scale, Scale10 + 0.006)
    }):Play()
end

local function nudgeBack() -- line: 647
    -- upvalues: TweenService (copy), v38 (copy), SelectAll (copy), Scale10 (copy)
    TweenService:Create(SelectAll, v38, {
        Position = UDim2.fromScale(SelectAll.Position.X.Scale, Scale10)
    }):Play()
end

SelectAll.MouseEnter:Connect(nudgeDown)
SelectAll.MouseLeave:Connect(nudgeBack)
SelectAll.SelectionGained:Connect(nudgeDown)
SelectAll.SelectionLost:Connect(nudgeBack)
SelectAll.Activated:Connect(function() -- line: 654
    -- upvalues: SoundService (copy), v12 (ref), v17 (copy), v19 (ref), v20 (ref), t10 (copy), t11 (copy), t12 (copy), t13 (copy), setSelected (copy)
    if not (v19 and v20) then
        return
    end

    local t15 = {}
    local v87 = false

    for v88 in pairs(t10) do
        t15[#t15 + 1] = v88

        if t13[v88] == nil and not v88:GetAttribute("Titan") then
            v87 = true
        end
    end

    for _, v89 in ipairs(t15) do
        if t13[v89] ~= nil ~= v87 and (not v87 or not v89:GetAttribute("Titan")) then
            setSelected(v89, v87, true)
        end
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

    if TileSelect then
        local v90 = v87 and t11 or t12

        TileSelect.PlaybackSpeed = v17:NextNumber(v90[1], v90[2])
        TileSelect:Play()
    end

    v12()
end)

local SelectWorst = Side:WaitForChild("SelectWorst")

ButtonHover.Attach(SelectWorst, t9)

local Scale11 = SelectWorst.Position.Y.Scale

local function nudgeWorst(p23) -- line: 688
    -- upvalues: TweenService (copy), v37 (copy), v38 (copy), SelectWorst (copy), Scale11 (copy)
    TweenService:Create(SelectWorst, p23 and v37 or v38, {
        Position = UDim2.fromScale(SelectWorst.Position.X.Scale, Scale11 + (p23 and 0.006 or 0))
    }):Play()
end

SelectWorst.MouseEnter:Connect(function() -- line: 691
    -- upvalues: nudgeWorst (copy)
    nudgeWorst(true)
end)
SelectWorst.MouseLeave:Connect(function() -- line: 692
    -- upvalues: TweenService (copy), v38 (copy), SelectWorst (copy), Scale11 (copy)
    TweenService:Create(SelectWorst, v38, {
        Position = UDim2.fromScale(SelectWorst.Position.X.Scale, Scale11 + 0)
    }):Play()
end)
SelectWorst.SelectionGained:Connect(function() -- line: 693
    -- upvalues: TweenService (copy), v37 (copy), v38 (copy), SelectWorst (copy), Scale11 (copy)
    TweenService:Create(SelectWorst, v37 or v38, {
        Position = UDim2.fromScale(SelectWorst.Position.X.Scale, Scale11 + 0.006)
    }):Play()
end)
SelectWorst.SelectionLost:Connect(function() -- line: 694
    -- upvalues: TweenService (copy), v38 (copy), SelectWorst (copy), Scale11 (copy)
    TweenService:Create(SelectWorst, v38, {
        Position = UDim2.fromScale(SelectWorst.Position.X.Scale, Scale11 + 0)
    }):Play()
end)
SelectWorst.Activated:Connect(function() -- line: 695
    -- upvalues: SoundService (copy), Toast (copy), Loc (copy), LocalPlayer (copy), PassPerks (copy), v12 (ref), v17 (copy), v19 (ref), v20 (ref), v22 (ref), t10 (copy), t11 (copy), t13 (copy), setSelected (copy)
    if not (v19 and v20 and v22) then
        return
    end

    local v92 = LocalPlayer:GetAttribute("TutorialFeedReadies") == true
    local v93 = ((v22:GetAttribute("StageEnd") or 0) - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)

    if v93 <= 0 and not v92 then
        Toast.Show(Loc.T("Ready to grow!"), "", nil, Toast.ORANGE, "deny")

        return
    end

    local t17 = {}

    for _, v94 in ipairs({
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            LocalPlayer.Character
        }) do
        if v94 then
            for _, child in ipairs(v94:GetChildren()) do
                local v95 = child:IsA("Tool") and child:GetAttribute("BagId")

                if v95 then
                    t17[v95] = child
                end
            end
        end
    end

    local t18 = {}

    for v96 in pairs(t10) do
        local Id = v96:GetAttribute("Id")
        local v97 = Id and t17[Id]

        if v97 and (v96:GetAttribute("Skip") or 0) > 0 and not v96:GetAttribute("Titan") then
            local v98 = tonumber(v97:GetAttribute("Rate")) or 0
            local v99 = v98 / 2 ^ ((tonumber(v97:GetAttribute("Stage")) or 1) - 1)

            t18[#t18 + 1] = {
                tile = v96,
                base = v99,
                rate = v98,
                kg = tonumber(v97:GetAttribute("Weight")) or 0,
                id = Id
            }
        end
    end

    table.sort(t18, function(p24, p25) -- line: 724
        if p24.base ~= p25.base then
            return p24.base < p25.base
        end

        if p24.rate ~= p25.rate then
            return p24.rate < p25.rate
        end

        if p24.kg == p25.kg then
            return p24.id < p25.id
        end

        return p24.kg < p25.kg
    end)

    local t19 = {}
    local n3 = 0

    for _, v100 in ipairs(t18) do
        if v93 <= n3 and next(t19) then
            break
        end

        t19[v100.tile] = true
        n3 += v100.tile:GetAttribute("Skip") or 0

        if v92 then
            break
        end
    end

    for v101 in pairs(t10) do
        local v102 = t19[v101] == true

        if t13[v101] ~= nil ~= v102 then
            setSelected(v101, v102, true)
        end
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

    if TileSelect then
        TileSelect.PlaybackSpeed = v17:NextNumber(t11[1], t11[2])
        TileSelect:Play()
    end

    v12()
end)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PenState = Remotes:WaitForChild("PenState")
local FeedFish = Remotes:WaitForChild("FeedFish")
local AquariumAction = Remotes:WaitForChild("AquariumAction")
local Entry = List:WaitForChild("Entry")
local Tile = Grid:WaitForChild("Tile")
local Empty = Side.GridClip:WaitForChild("Empty")

Entry.Body:WaitForChild("Title").AutoLocalize = false
Entry.Body:WaitForChild("Stage").AutoLocalize = false
Tile:WaitForChild("Body"):WaitForChild("Face"):WaitForChild("FishName").AutoLocalize = false

local t20 = {}
local t21 = {}
local t22

local function describe(p26, p27, p28) -- line: 786
    -- upvalues: FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), Loc (copy)
    local v103 = FishDisplay[p26]
    local v104 = p27 and MutationDisplay[p27]
    local v105, v106

    if v103 then
        local shown = v103.shown

        if shown then
            v105 = shown
            v106 = true
        else
            local rarity = v103.rarity

            if rarity then
                v105 = rarity
                v106 = true
            else
                v106 = false
            end
        end
    else
        v106 = false
    end

    if not v106 then
        v105 = "Common"
    end

    local v107 = RarityDisplay[v105]
    local v108

    if p28 then
        v108 = p28
    else
        local Fish = Loc.Fish
        local v109 = v104 and v104.prefix
        local display = if v103 then v103.display else nil

        if not v103 or not display then
            display = tostring(p26)
        end

        v108 = Fish(v109, display)
    end

    return v108, v107, v103
end

local function tickRow(p29) -- line: 794
    -- upvalues: Format (copy), GrowthDisplay (copy), LocalPlayer (copy), PassPerks (copy), v22 (ref)
    local v110 = p29:GetAttribute("Stage") or 1
    local v111 = p29:GetAttribute("StageEnd") or 0
    local v112 = GrowthDisplay.Span(v110, v111 > 0, p29:GetAttribute("Inf"))
    local Stage = p29.Body.Stage

    v112 = v111 > 0 and v112 .. "  " .. Format.time((v111 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)) or v112
    Stage.Text = v112

    local v114 = not (v111 > 0 and v111 <= math.floor((workspace:GetServerTimeNow())))

    if not v114 then
        v114 = p29 == v22 or LocalPlayer:GetAttribute("TutorialFeedReadies") == true
    end

    p29.Visible = v114

    local v115 = v111 <= 0 and GrowthDisplay.gradients[v110] or nil

    p29.Body.Stage.Grad.Enabled = v115 ~= nil

    if v115 then
        p29.Body.Stage.Grad.Color = v115
    end
end

local v116 = #GrowthDisplay.stages - 1

local function setButtons(p30) -- line: 819
    -- upvalues: v116 (copy)
    local Body = p30.Body
    local v117 = p30:GetAttribute("Stage") or 1
    local v118 = p30:GetAttribute("Plus") == true
    local v119 = not p30:GetAttribute("Infinite") and (v118 and v116 + 1 or v116) <= v117

    Body.Feed.Visible = not v119
    Body.Skip.Visible = not v119
    Body.Max.Visible = v119
    Body.Cap.Visible = v119 and not v118 and not p30:GetAttribute("NoPlus")
end

local function dressRow(p31, p32) -- line: 831
    -- upvalues: FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Format (copy), Loc (copy), dressCap (copy), tickRow (copy), setButtons (copy)
    local name, mutation, nick = p32.name, p32.mutation, p32.nick
    local v120 = FishDisplay[name]
    local v121 = mutation and MutationDisplay[mutation]
    local v122, v123

    if v120 then
        local shown = v120.shown

        if shown then
            v122 = shown
            v123 = true
        else
            local rarity = v120.rarity

            if rarity then
                v122 = rarity
                v123 = true
            else
                v123 = false
            end
        end
    else
        v123 = false
    end

    if not v123 then
        v122 = "Common"
    end

    local v124 = RarityDisplay[v122]

    if not nick then
        local Fish = Loc.Fish
        local v125 = v121 and v121.prefix
        local display = if v120 then v120.display else nil

        if not v120 or not display then
            display = tostring(name)
        end

        nick = Fish(v125, display)
    end

    p31.Body.Title.Text = nick .. "\n(" .. Format.kg(p32.weight or 0) .. ")"
    RarityStyle.Apply(p31.Body.Title, v124.color)
    p31.Body.Square.Image = v124.square
    p31.Body.Square.ImageColor3 = v124.squareTint or Color3.new(1, 1, 1)

    local Square, Square2 = p31.Body.Square, p31.Body.Square
    local offset, size = RarityDisplay.squareRect.offset, RarityDisplay.squareRect.size

    Square.ImageRectOffset = offset
    Square2.ImageRectSize = size
    p31.Body.Square.Icon.Image = v120 and v120.icon or ""
    p31:SetAttribute("Id", p32.id)
    p31:SetAttribute("Stage", p32.stage or 1)
    p31:SetAttribute("StageEnd", p32.stageEnd or 0)
    p31:SetAttribute("Carry", p32.carry or 0)
    p31:SetAttribute("Plus", p32.plus == true)
    p31:SetAttribute("Species", p32.name)
    p31:SetAttribute("Inf", p32.inf or 0)
    p31:SetAttribute("Infinite", v120 ~= nil and v120.infinite == true)
    p31:SetAttribute("NoPlus", v120 ~= nil and v120.noPlus == true)
    dressCap(p31)
    tickRow(p31)
    setButtons(p31)
end

local function babyRate(p33) -- line: 857
    return (p33.rate or 0) / 2 ^ ((p33.stage or 1) - 1)
end

local function rankOf(p34) -- line: 860
    local v126 = table.clone(p34)

    table.sort(v126, function(p35, p36) -- line: 862
        local v127 = (p35.rate or 0) / 2 ^ ((p35.stage or 1) - 1)
        local v128 = (p36.rate or 0) / 2 ^ ((p36.stage or 1) - 1)

        if v127 ~= v128 then
            return v128 < v127
        end

        if (p35.rate or 0) == (p36.rate or 0) then
            return (p35.weight or 0) > (p36.weight or 0)
        end

        return (p35.rate or 0) > (p36.rate or 0)
    end)

    local t23 = {}

    for v129, v130 in ipairs(v126) do
        t23[v130.id] = v129
    end

    return t23
end

local function rebuild(p37) -- line: 873
    -- upvalues: FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), Format (copy), Toast (copy), Loc (copy), LocalPlayer (copy), PassPerks (copy), List (copy), v20 (ref), v22 (ref), showRow (copy), close2 (copy), Entry (copy), t20 (copy), t22 (ref), dressRow (copy), rankOf (copy)
    local t24 = {}
    local v131 = rankOf(p37)

    for v132, v133 in ipairs(p37) do
        t24[v133.id] = true

        local v134 = t20[v133.id]

        if not v134 then
            v134 = Entry:Clone()
            v134.Name = "Row"
            v134.Visible = true
            t20[v133.id] = v134
        end

        if t22 and v133.id == t22.id and t22.stageEnd > 0 then
            local v135 = (t22.stageEnd - (v133.stageEnd or 0) + ((v133.carry or 0) - t22.carry)) * PassPerks.GrowSpeed(LocalPlayer)

            if (v133.stage or 1) > t22.stage or v135 > 0 then
                local name, mutation, nick = v133.name, v133.mutation, v133.nick
                local v136 = FishDisplay[name]

                mutation = mutation and MutationDisplay[mutation]

                local v137 = RarityDisplay[if v136 then v136.shown or v136.rarity or "Common" else "Common"]

                nick = nick or Loc.Fish(mutation and mutation.prefix, v136 and v136.display or tostring(name))
                Toast.Show(Loc.F("feed.fed", "Fed! -{time}", {
                    time = Format.time((math.max(0, v135)))
                }), nick, v137.color, Toast.ORANGE, nil, true)
            end
        end

        dressRow(v134, v133)
        v134.LayoutOrder = v131[v133.id] or v132
        v134.Parent = List

        if v134 == v22 and v20 then
            showRow(v134)
        end
    end

    for v138, v139 in pairs(t20) do
        if not t24[v138] then
            t20[v138] = nil

            if v139 == v22 then
                close2()
            end

            v139:Destroy()
        end
    end

    t22 = nil
end

PenState.OnClientEvent:Connect(rebuild)
AquariumAction:FireServer("Sync")

local function dressTile(p38, p39) -- line: 915
    -- upvalues: FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Format (copy), Loc (copy), LocalPlayer (copy), PassPerks (copy)
    local Species = p39:GetAttribute("Species")
    local Mutation = p39:GetAttribute("Mutation")
    local Nick = p39:GetAttribute("Nick")
    local v140 = FishDisplay[Species]
    local v141 = Mutation and MutationDisplay[Mutation]
    local v142, v143

    if v140 then
        local shown = v140.shown

        if shown then
            v142 = shown
            v143 = true
        else
            local rarity = v140.rarity

            if rarity then
                v142 = rarity
                v143 = true
            else
                v143 = false
            end
        end
    else
        v143 = false
    end

    if not v143 then
        v142 = "Common"
    end

    local v144 = RarityDisplay[v142]

    if not Nick then
        local Fish = Loc.Fish
        local v145 = v141 and v141.prefix
        local display = if v140 then v140.display else nil

        if not v140 or not display then
            display = tostring(Species)
        end

        Nick = Fish(v145, display)
    end

    local Face = p38.Body.Face

    Face.FishName.Text = Nick .. " (" .. Format.kg(p39:GetAttribute("Weight") or 0) .. ")"
    RarityStyle.Apply(Face.FishName, v144.color)
    Face.IconGroup.Icon.Image = v140 and v140.icon or ""
    Face.IconGroup.IconShadow.Image = v140 and v140.icon or ""

    local v146 = p39:GetAttribute("Hat") and p39:GetAttribute("Crown") ~= true
    local Cap = p39:GetAttribute("Cap")
    local v147, v148

    if v146 or p39:GetAttribute("Crown") == true then
        v148 = false
    elseif type(Cap) == "string" and game:GetService("ReplicatedStorage"):FindFirstChild("HatProps") then
        local v149 = game:GetService("ReplicatedStorage").HatProps:FindFirstChild(Cap)

        if v149 then
            v147 = v149
            v148 = true
        else
            v148 = false
        end
    else
        v148 = false
    end

    if not v148 then
        v147 = nil
    end

    local CrownBadge = Face.IconGroup:FindFirstChild("CrownBadge")
    local ImageLabel

    if p39:GetAttribute("Crown") ~= true and not v146 and not v147 or CrownBadge then
        ImageLabel = CrownBadge
    else
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "CrownBadge"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Image = "rbxassetid://132409368513754"
        ImageLabel.Position = UDim2.fromScale(0, 0)
        ImageLabel.Size = UDim2.fromScale(0.34, 0.34)
        ImageLabel.ZIndex = Face.IconGroup.Icon.ZIndex + 2
        Instance.new("UIAspectRatioConstraint").Parent = ImageLabel
        ImageLabel.Parent = Face.IconGroup
    end

    if ImageLabel then
        if p39:GetAttribute("Crown") == true then
            ImageLabel.Visible = true
        else
            ImageLabel.Visible = v146 or v147 ~= nil
        end

        local v150

        if v147 then
            v150 = v147:GetAttribute("Icon") or ""
        else
            if v146 then
                v150 = require(game:GetService("ReplicatedStorage").Modules.ThanksgivingConfig).HatIcon(p39:GetAttribute("Hat"))
            end

            if not v146 or not v150 then
                v150 = "rbxassetid://132409368513754"
            end
        end

        ImageLabel.Image = v150
    end

    p38:SetAttribute("Skip", (p39:GetAttribute("FeedSkip") or 0) * PassPerks.FeedMul(LocalPlayer))
    p38:SetAttribute("Id", p39:GetAttribute("BagId"))
    p38:SetAttribute("Titan", not not (v140 and v140.rarity == "Titan") or nil)
end

local function fishTools() -- line: 960
    -- upvalues: FishDisplay (copy), LocalPlayer (copy)
    local t26 = {}

    for _, v151 in ipairs({
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            LocalPlayer.Character
        }) do
        if v151 then
            for _, child in ipairs(v151:GetChildren()) do
                local v152 = child:IsA("Tool") and FishDisplay[child:GetAttribute("Species") or ""]
                local Tool = child:IsA("Tool") and child:GetAttribute("Species") ~= "Mimic" and not child:GetAttribute("Boost") and not child:GetAttribute("Copy") and not child:GetAttribute("Favorite") and not (v152 and v152.rarity == "Exclusive") and child:GetAttribute("BagId")

                if Tool then
                    t26[Tool] = child
                end
            end
        end
    end

    return t26
end

local v153 = false

local function refreshTiles() -- line: 977
    -- upvalues: FishGroupOrder (copy), Grid (copy), v12 (ref), t13 (copy), setSelected (copy), Tile (copy), Empty (copy), t21 (copy), dressTile (copy), fishTools (copy), v153 (ref)
    v153 = false

    local v154 = fishTools()

    for v155, v156 in pairs(v154) do
        if not t21[v155] then
            local clone = Tile:Clone()

            clone.Name = "Fish"
            clone.Visible = true
            t21[v155] = clone
            dressTile(clone, v156)
            clone.LayoutOrder = FishGroupOrder.Of(v156:GetAttribute("Species")) * 3E+06 - math.floor(math.min(math.log((v156:GetAttribute("Weight") or 0) + 1), 29) * 1E+05 + 0.5)
            clone.Parent = Grid
        end
    end

    local v161 = false

    for v162, v163 in pairs(t21) do
        if not v154[v162] then
            t21[v162] = nil

            if t13[v163] ~= nil then
                v161 = true
                setSelected(v163, false, true)
            end

            v163:Destroy()
        end
    end

    if v161 then
        v12()
    end

    Empty.Visible = next(t21) == nil
end

local function queueRefresh() -- line: 1010
    -- upvalues: v153 (ref), refreshTiles (copy)
    if not v153 then
        v153 = true
        task.defer(refreshTiles)
    end
end

local function watchHolder(p40) -- line: 1015
    -- upvalues: v153 (ref), refreshTiles (copy), queueRefresh (copy)
    p40.ChildAdded:Connect(queueRefresh)
    p40.ChildRemoved:Connect(queueRefresh)

    if not v153 then
        v153 = true
        task.defer(refreshTiles)
    end
end

watchHolder(LocalPlayer:WaitForChild("Backpack"))
LocalPlayer.ChildAdded:Connect(function(p41) -- line: 1021
    -- upvalues: v153 (ref), refreshTiles (copy), queueRefresh (copy)
    if not p41:IsA("Backpack") then
        return
    end

    p41.ChildAdded:Connect(queueRefresh)
    p41.ChildRemoved:Connect(queueRefresh)

    if v153 then
        return
    end

    v153 = true
    task.defer(refreshTiles)
end)
Loc.Changed:Connect(function() -- line: 1023
    -- upvalues: v12 (ref), v22 (ref), AquariumAction (copy), t21 (copy), dressTile (copy), fishTools (copy)
    AquariumAction:FireServer("Sync")

    local v164 = fishTools()

    for v165, v166 in pairs(t21) do
        if v164[v165] then
            dressTile(v166, v164[v165])
        end
    end

    if v22 then
        v12()
    end
end)
LocalPlayer:GetAttributeChangedSignal(ShopConfig.PassAttr("Feed2x")):Connect(function() -- line: 1032
    -- upvalues: v12 (ref), v22 (ref), t21 (copy), dressTile (copy), fishTools (copy)
    local v167 = fishTools()

    for v168, v169 in pairs(t21) do
        if v167[v168] then
            dressTile(v169, v167[v168])
        end
    end

    if v22 then
        v12()
    end
end)

if LocalPlayer.Character then
    watchHolder(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(watchHolder)
FeedButton.Activated:Connect(function() -- line: 1046
    -- upvalues: SoundService (copy), ButtonHover (copy), TelemetryReport (copy), LocalPlayer (copy), t3 (copy), v17 (copy), v19 (ref), v20 (ref), v22 (ref), close2 (copy), FeedButton (copy), t13 (copy), FeedFish (copy), t22 (ref)
    if v19 and v20 and v22 and next(t13) == nil then
        TelemetryReport:FireServer("feeding", "nofood", nil)
    end

    if not v19 or not v20 or not v22 or next(t13) == nil then
        return
    end

    local t27 = {}

    for v170 in pairs(t13) do
        local Id = v170:GetAttribute("Id")

        if Id then
            t27[#t27 + 1] = Id
        end
    end

    if #t27 == 0 then
        return
    end

    ButtonHover.Press(FeedButton)

    local FEED_SOUND, FEED_PITCH = t3.FEED_SOUND, t3.FEED_PITCH
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v171 = HarpoonSFX and HarpoonSFX:FindFirstChild(FEED_SOUND)

    if v171 then
        if FEED_PITCH then
            v171.PlaybackSpeed = v17:NextNumber(FEED_PITCH[1], FEED_PITCH[2])
        end

        v171:Play()
    end

    t22 = {
        id = v22:GetAttribute("Id"),
        stage = v22:GetAttribute("Stage") or 1,
        stageEnd = v22:GetAttribute("StageEnd") or 0,
        carry = v22:GetAttribute("Carry") or 0
    }
    FeedFish:FireServer(t22.id, t27)
    TelemetryReport:FireServer("feeding", "press", #t27)
    LocalPlayer:SetAttribute("TutorialSent", "FishFed@" .. os.clock())
    close2()
end)

local Scale12 = UIListLayout2.Padding.Scale
local Scale13 = UIPadding.PaddingTop.Scale

local function fitCanvas() -- line: 1072
    -- upvalues: List (copy), UIListLayout2 (copy), UIPadding (copy), Scale12 (copy), Scale13 (copy)
    local Y = List.AbsoluteWindowSize.Y

    UIListLayout2.Padding = UDim.new(0, Scale12 * Y)
    UIPadding.PaddingTop = UDim.new(0, Scale13 * Y)
    UIPadding.PaddingBottom = UDim.new(0, Scale13 * Y)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y + 2 * Scale13 * Y)
end

UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)
fitCanvas()

local Scale14 = UIListLayout.Padding.Scale

local function fitGrid() -- line: 1089
    -- upvalues: Grid (copy), UIListLayout (copy), Scale14 (copy)
    UIListLayout.Padding = UDim.new(0, Scale14 * Grid.AbsoluteWindowSize.X)
    Grid.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitGrid)
Grid:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitGrid)
fitGrid()

local Scroll = Side:WaitForChild("Scroll")
local Track = Scroll:WaitForChild("Track")
local Knob = Track:WaitForChild("Knob")
local v173
local n4 = 0

local function scrollRoom() -- line: 1112
    -- upvalues: Grid (copy)
    return (math.max(0, Grid.AbsoluteCanvasSize.Y - Grid.AbsoluteWindowSize.Y))
end

local function placeKnob() -- line: 1115
    -- upvalues: Grid (copy), Scroll (copy), Knob (copy)
    local Y = Grid.AbsoluteCanvasSize.Y
    local Y2 = Grid.AbsoluteWindowSize.Y
    local v176 = math.max(0, Grid.AbsoluteCanvasSize.Y - Grid.AbsoluteWindowSize.Y)

    Scroll.Visible = v176 > 0.5

    if v176 <= 0.5 then
        return
    end

    local v178 = math.clamp(Y2 / Y, 0.15, 1)

    Knob.Size = UDim2.fromScale(Knob.Size.X.Scale, v178)
    Knob.Position = UDim2.fromScale(Knob.Position.X.Scale, (1 - v178) * math.clamp(Grid.CanvasPosition.Y / v176, 0, 1))
end

local function scrollTo(p42) -- line: 1125
    -- upvalues: Grid (copy), Track (copy), Knob (copy), n4 (ref)
    local Y = Track.AbsoluteSize.Y
    local Scale = Knob.Size.Y.Scale

    if Y <= 0 or Scale >= 1 then
        return
    end

    local v181 = (p42 - Track.AbsolutePosition.Y) / Y - n4 * Scale

    Grid.CanvasPosition = Vector2.new(Grid.CanvasPosition.X, math.clamp(v181 / (1 - Scale), 0, 1) * math.max(0, Grid.AbsoluteCanvasSize.Y - Grid.AbsoluteWindowSize.Y))
end

Scroll.InputBegan:Connect(function(p43) -- line: 1132
    -- upvalues: GuiService (copy), Knob (copy), v173 (ref), n4 (ref), scrollTo (copy)
    if v173 or p43.UserInputType ~= Enum.UserInputType.MouseButton1 and p43.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    v173 = p43

    local v185 = p43.Position.Y - GuiService:GetGuiInset().Y
    local Y = Knob.AbsolutePosition.Y
    local Y2 = Knob.AbsoluteSize.Y
    local v186, v187

    if Y <= v185 and v185 <= Y + Y2 and Y2 > 0 then
        local v188 = (v185 - Y) / Y2

        if v188 then
            v186 = v188
            v187 = true
        else
            v187 = false
        end
    else
        v187 = false
    end

    if not v187 then
        v186 = 0.5
    end

    n4 = v186
    scrollTo(v185)
end)
UserInputService.InputChanged:Connect(function(p44) -- line: 1143
    -- upvalues: GuiService (copy), v173 (ref), scrollTo (copy)
    if v173 and (p44 == v173 or v173.UserInputType == Enum.UserInputType.MouseButton1 and p44.UserInputType == Enum.UserInputType.MouseMovement) then
        scrollTo(p44.Position.Y - GuiService:GetGuiInset().Y)
    end
end)
UserInputService.InputEnded:Connect(function(p45) -- line: 1149
    -- upvalues: v173 (ref)
    if p45 == v173 or v173 and p45.UserInputType == v173.UserInputType then
        v173 = nil
    end
end)
Grid:GetPropertyChangedSignal("CanvasPosition"):Connect(placeKnob)
Grid:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(placeKnob)
Grid:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(placeKnob)
placeKnob()
task.spawn(function() -- line: 1159
    -- upvalues: ContentProvider (copy), FeedGui (copy)
    ContentProvider:PreloadAsync(FeedGui:GetDescendants())
end)
task.spawn(function() -- line: 1165
    -- upvalues: Format (copy), LocalPlayer (copy), PassPerks (copy), Panel (copy), Timer (copy), v20 (ref), v22 (ref), t20 (copy), tickRow (copy)
    while true do
        task.wait(1 / PassPerks.GrowSpeed(LocalPlayer))

        if not Panel.Visible then
            continue
        end

        for _, v189 in pairs(t20) do
            tickRow(v189)
        end

        local Timer2, v190

        if v20 then
            local v191 = v22

            if v191 then
                local v192 = v191:GetAttribute("StageEnd") or 0

                Timer2 = Timer
                v190 = v192 > 0 and Format.time((v192 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)) or ""
                Timer2.Text = v190
            end
        end
    end
end)
Button.Activated:Connect(function() -- line: 1176
    -- upvalues: LocalPlayer (copy), open (copy)
    if not LocalPlayer:GetAttribute("TutorialNoFeed") then
        open()
    end
end)
close = close2
Close.Activated:Connect(close2)

local v193 = TweenInfo.new(0)

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 1188
    -- upvalues: TweenService (copy), FeedGui (copy), FeedSlot (copy), Scale (copy), FishSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), Close (copy), Side (copy), Scale4 (copy), Scale5 (copy), v18 (ref), v19 (ref), v20 (ref), v21 (ref), v22 (ref), PadMenu (copy), v33 (ref), v193 (copy)
    if not v19 then
        return
    end

    v19 = false
    v18 = false
    PadMenu.Close(FeedGui)
    TweenService:Create(Scale3, v193, {
        Scale = 1
    }):Play()
    TweenService:Create(Panel, v193, {
        Rotation = 0
    }):Play()
    Panel.Visible = false
    TweenService:Create(Scale4, v193, {
        Scale = 1
    }):Play()
    TweenService:Create(Side, v193, {
        Rotation = 0
    }):Play()
    TweenService:Create(Close, v193, {
        Position = UDim2.fromScale(Scale5, 0.5)
    }):Play()
    Side.Visible = false
    v20 = false
    v33()
    v21 = false
    v22 = nil

    for _, v194 in ipairs({
            { FeedSlot, Scale },
            { FishSlot, Scale2 }
        }) do
        TweenService:Create(v194[2], v193, {
            Scale = 1
        }):Play()
        v194[1].Visible = true
    end
end)

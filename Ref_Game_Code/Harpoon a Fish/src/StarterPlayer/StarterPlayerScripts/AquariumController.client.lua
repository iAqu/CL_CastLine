-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local PenConfig = require(Modules:WaitForChild("PenConfig"))
local Format = require(Modules:WaitForChild("Format"))
local Toast = require(Modules:WaitForChild("Toast"))
local GrowthDisplay = require(Modules:WaitForChild("GrowthDisplay"))
local Badge = require(Modules:WaitForChild("Badge"))
local Loc = require(Modules:WaitForChild("Loc"))
local Funnel = require(Modules:WaitForChild("Funnel"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AquariumAction = Remotes:WaitForChild("AquariumAction")
local PenState = Remotes:WaitForChild("PenState")
local PenUpgrade = Remotes:WaitForChild("PenUpgrade")
local LocalPlayer = Players.LocalPlayer

local function serverNow() -- line: 52
    return (math.floor((workspace:GetServerTimeNow())))
end

local PassPerks = require(Modules:WaitForChild("PassPerks"))

local function shownLeft(p1) -- line: 58
    -- upvalues: LocalPlayer (copy), PassPerks (copy)
    return (p1 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)
end

local AquariumGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AquariumGui")
local SideButtons = LocalPlayer.PlayerGui:WaitForChild("SideButtons")
local FishSlot = SideButtons:WaitForChild("FishSlot")
local Button = FishSlot:WaitForChild("Button")
local Scale = FishSlot:WaitForChild("Scale")

local function tutorialHold() -- line: 72
    -- upvalues: LocalPlayer (copy), Button (copy)
    Button.Visible = not string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",SideButtons.FishSlot,", 1, true)
end

LocalPlayer:GetAttributeChangedSignal("TutorialHides"):Connect(tutorialHold)
Button.Visible = not string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",SideButtons.FishSlot,", 1, true)

local FeedSlot = SideButtons:WaitForChild("FeedSlot")
local Scale2 = FeedSlot:WaitForChild("Scale")
local Panel = AquariumGui:WaitForChild("Panel")
local Scale3 = Panel:WaitForChild("Scale")
local Close = Panel:WaitForChild("Close")
local ListClip = Panel:WaitForChild("Body"):WaitForChild("ListClip")
local List = ListClip:WaitForChild("List")

require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Watch(ListClip)

local UIListLayout = List:WaitForChild("UIListLayout")
local UIPadding = List:WaitForChild("UIPadding")
local Entry = List:WaitForChild("Entry")

Entry:WaitForChild("Title").AutoLocalize = false
Entry:WaitForChild("Stage").AutoLocalize = false

local Title = Entry:WaitForChild("GrowNow"):WaitForChild("Text")

Title.AutoLocalize = false
Title.Text = Loc.T("GROW NOW")

local t1 = {
    TWIST = 15,
    FROM = 0.35,
    OPEN_TIME = 0.32,
    CLOSE_TIME = 0.2,
    BUTTON_OUT = 0.12,
    BUTTON_IN = 0.28,
    OPEN_SOUND = "PanelOpen",
    CLOSE_SOUND = "PanelClose"
}
local v1 = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local v3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v4 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = Random.new()
local v6 = false
local v7 = false

local function playSound(p2) -- line: 121
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v8 = HarpoonSFX and HarpoonSFX:FindFirstChild(p2)

    if v8 then
        v8:Play()
    end
end

local function twist() -- line: 127
    -- upvalues: v5 (copy)
    if v5:NextInteger(0, 1) == 0 then
        return -15
    end

    return 15
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local close, hidePicker

local function open() -- line: 135
    -- upvalues: TweenService (copy), SoundService (copy), Funnel (copy), AquariumGui (copy), FishSlot (copy), Scale (copy), FeedSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), Close (copy), t1 (copy), v1 (copy), v3 (copy), v5 (copy), v6 (ref), v7 (ref), PadMenu (copy), close (ref)
    if v6 or v7 then
        return
    end

    v6 = true
    v7 = true
    Funnel.Report("aquarium_panel")

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local PanelOpen = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelOpen")

    if PanelOpen then
        PanelOpen:Play()
    end

    for _, v9 in ipairs({
            { FishSlot, Scale },
            { FeedSlot, Scale2 }
        }) do
        local v10 = v9[1]
        local tween = TweenService:Create(v9[2], v3, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 145
            -- upvalues: v10 (copy), v7 (ref)
            if v7 then
                v10.Visible = false
            end
        end)
        tween:Play()
    end

    Scale3.Scale = 0.35
    Panel.Rotation = v5:NextInteger(0, 1) == 0 and -t1.TWIST or t1.TWIST
    Panel.Visible = true
    TweenService:Create(Panel, v1, {
        Rotation = 0
    }):Play()

    local tween = TweenService:Create(Scale3, v1, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 154
        -- upvalues: v6 (ref)
        v6 = false
    end)
    tween:Play()
    PadMenu.Open(AquariumGui, function() -- line: 156
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close
    })
end

local function close2(p3) -- line: 160
    -- upvalues: TweenService (copy), SoundService (copy), LocalPlayer (copy), AquariumGui (copy), FishSlot (copy), Scale (copy), FeedSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), t1 (copy), v2 (copy), v4 (copy), v5 (copy), v6 (ref), v7 (ref), PadMenu (copy), hidePicker (ref)
    if v6 or not v7 or not p3 and string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",AquariumGui.Close,", 1, true) or hidePicker and hidePicker() and not p3 then
        return
    end

    v6 = true
    v7 = false
    PadMenu.Close(AquariumGui)

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local PanelClose = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelClose")

    if PanelClose then
        PanelClose:Play()
    end

    TweenService:Create(Panel, v2, {
        Rotation = v5:NextInteger(0, 1) == 0 and -t1.TWIST or t1.TWIST
    }):Play()

    local tween = TweenService:Create(Scale3, v2, {
        Scale = 0.35
    })

    tween.Completed:Once(function() -- line: 175
        -- upvalues: TweenService (copy), FishSlot (copy), Scale (copy), FeedSlot (copy), Scale2 (copy), Panel (copy), v4 (copy), v6 (ref)
        Panel.Visible = false
        Panel.Rotation = 0

        for _, v13 in ipairs({
                { FishSlot, Scale },
                { FeedSlot, Scale2 }
            }) do
            v13[1].Visible = true
            v13[2].Scale = 0
            TweenService:Create(v13[2], v4, {
                Scale = 1
            }):Play()
        end

        task.delay(0.28, function() -- line: 183
            -- upvalues: v6 (ref)
            v6 = false
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

local v14 = Badge.Attach(Button, {
    icon = Button.Icon
})

ButtonHover.Attach(Close, {
    shine = false,
    iconTilt = 0,
    icon = Close:WaitForChild("Arrow")
})

local t3 = {
    shine = false
}
local t4 = {
    shine = false,
    highlight = true
}
local Equip = Panel:WaitForChild("Header"):WaitForChild("Equip")

ButtonHover.Attach(Equip, t4)

local Count = Equip.Parent:WaitForChild("Count")
local Scale4 = Count:WaitForChild("Scale")
local Scale5 = Count.Position.X.Scale
local v15 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v16 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function countAside() -- line: 210
    -- upvalues: TweenService (copy), Count (copy), Scale4 (copy), Scale5 (copy), v15 (copy)
    TweenService:Create(Scale4, v15, {
        Scale = 0.9
    }):Play()
    TweenService:Create(Count, v15, {
        Position = UDim2.fromScale(Scale5 - 0.025, 0.5)
    }):Play()
end

local function countBack() -- line: 214
    -- upvalues: TweenService (copy), Count (copy), Scale4 (copy), Scale5 (copy), v16 (copy)
    TweenService:Create(Scale4, v16, {
        Scale = 1
    }):Play()
    TweenService:Create(Count, v16, {
        Position = UDim2.fromScale(Scale5, 0.5)
    }):Play()
end

Equip.MouseEnter:Connect(countAside)
Equip.MouseLeave:Connect(countBack)
Equip.SelectionGained:Connect(countAside)
Equip.SelectionLost:Connect(countBack)

local t5 = {
    shine = false,
    highlight = true,
    buttonScale = 1.04
}

ButtonHover.Attach(Panel:WaitForChild("EquipBest"), t5)
ButtonHover.Attach(Panel:WaitForChild("EquipBestBase"), t5)

local v17 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v18 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function hoverRow(p4) -- line: 234
    -- upvalues: TweenService (copy), ButtonHover (copy), t3 (copy), v17 (copy), v18 (copy)
    if p4:IsA("ImageLabel") and p4.Name ~= "Entry" then
        ButtonHover.Attach(p4, t3)

        local Unequip = p4:FindFirstChild("Unequip")

        if not Unequip then
            return
        end

        ButtonHover.Attach(Unequip, {
            shine = false,
            highlight = true
        })

        local Grow = p4:FindFirstChild("Grow")

        if Grow then
            ButtonHover.Attach(Grow, {
                shine = false,
                highlight = true
            })
        end

        local GrowNow = p4:FindFirstChild("GrowNow")

        if GrowNow then
            local v19 = GrowNow:GetAttribute("Corner") or 0.2

            ButtonHover.Attach(GrowNow, {
                shine = false,
                highlight = true,
                tile = 1,
                corner = v19,
                highlightCorner = v19
            })
        end

        local Title = p4:FindFirstChild("Title")

        if Title then
            local v20 = Title:FindFirstChild("Scale") or Instance.new("UIScale")

            v20.Name = "Scale"
            v20.Parent = Title

            for _, v21 in ipairs({ Unequip, Grow, GrowNow }) do
                if v21 then
                    v21.MouseEnter:Connect(function() -- line: 257
                        -- upvalues: v20 (copy), TweenService (copy), v17 (copy)
                        TweenService:Create(v20, v17, {
                            Scale = 0.9
                        }):Play()
                    end)
                    v21.MouseLeave:Connect(function() -- line: 258
                        -- upvalues: v20 (copy), TweenService (copy), v18 (copy)
                        TweenService:Create(v20, v18, {
                            Scale = 1
                        }):Play()
                    end)
                    v21.SelectionGained:Connect(function() -- line: 259
                        -- upvalues: v20 (copy), TweenService (copy), v17 (copy)
                        TweenService:Create(v20, v17, {
                            Scale = 0.9
                        }):Play()
                    end)
                    v21.SelectionLost:Connect(function() -- line: 260
                        -- upvalues: v20 (copy), TweenService (copy), v18 (copy)
                        TweenService:Create(v20, v18, {
                            Scale = 1
                        }):Play()
                    end)
                end
            end
        end
    end
end

for _, child in ipairs(List:GetChildren()) do
    hoverRow(child)
end

List.ChildAdded:Connect(hoverRow)

local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {
    text = "!",
    size = 0.5,
    at = Vector2.new(-0.02, 0.14)
}
local v22 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local t10 = {
    0.8, 0.9
}
local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://77120543307812"
Sound.Parent = AquariumGui

local t11 = {
    0.95, 1.05
}
local Sound2 = Instance.new("Sound")

Sound2.SoundId = "rbxassetid://111815218120844"
Sound2.Parent = AquariumGui

local t12 = {}

for v23, v24 in ipairs({ "rbxassetid://109044565945764", "rbxassetid://72585820436023" }) do
    local Sound = Instance.new("Sound")

    Sound.Name = "Grow" .. v23
    Sound.SoundId = v24
    Sound.Parent = AquariumGui
    t12[v23] = Sound
end

local function describe(p5) -- line: 294
    -- upvalues: FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), Loc (copy)
    local v25 = FishDisplay[p5.name]
    local v26 = p5.mutation and MutationDisplay[p5.mutation]
    local v27, v28

    if v25 then
        local shown = v25.shown

        if shown then
            v27 = shown
            v28 = true
        else
            local rarity = v25.rarity

            if rarity then
                v27 = rarity
                v28 = true
            else
                v28 = false
            end
        end
    else
        v28 = false
    end

    if not v28 then
        v27 = "Common"
    end

    local v29 = RarityDisplay[v27]
    local nick = p5.nick

    if not nick then
        local Fish = Loc.Fish
        local v30 = v26 and v26.prefix
        local display = if v25 then v25.display else nil

        if not v25 or not display then
            display = p5.name
        end

        nick = Fish(v30, display)
    end

    return nick .. (p5.serial and " #" .. p5.serial or ""), v29, v25
end

local t13 = {
    pos = Entry.Unequip.Position,
    size = Entry.Unequip.Size
}
local t14 = {
    pos = UDim2.fromScale(Entry.Unequip.Position.X.Scale, 0.5),
    size = Entry.Grow.Size
}

local function tickRow(p6) -- line: 310
    -- upvalues: Format (copy), GrowthDisplay (copy), LocalPlayer (copy), PassPerks (copy), t8 (copy), t13 (copy), t14 (copy)
    local v31 = p6:GetAttribute("Stage") or 1
    local v32 = p6:GetAttribute("StageEnd") or 0
    local v33 = GrowthDisplay.Span(v31, v32 > 0, p6:GetAttribute("Inf"))
    local v34 = v32 > 0 and v32 <= math.floor((workspace:GetServerTimeNow()))

    p6.Grow.Visible = v34
    p6.Unequip.Visible = not v34

    local v35 = v32 > 0 and not v34

    p6.GrowNow.Visible = v35
    p6.Unequip.Position = v35 and t13.pos or t14.pos
    p6.Unequip.Size = v35 and t13.size or t14.size
    p6.LayoutOrder = (p6:GetAttribute("BaseOrder") or 0) - (v34 and 1E+05 or 0)

    local v36 = t8[p6]

    if v36 then
        v36.Set(v34 and 1 or 0)
    end

    local Stage = p6.Stage

    v33 = v32 > 0 and v33 .. "  " .. Format.time((v32 - workspace:GetServerTimeNow()) * PassPerks.GrowSpeed(LocalPlayer)) or v33
    Stage.Text = v33

    local v37 = v32 <= 0 and GrowthDisplay.gradients[v31] or nil

    p6.Stage.Grad.Enabled = v37 ~= nil

    if v37 then
        p6.Stage.Grad.Color = v37
    end
end

local function dressRow(p7, p8) -- line: 338
    -- upvalues: RarityDisplay (copy), RarityStyle (copy), Format (copy), describe (copy), tickRow (copy)
    local v38, v39, v40 = describe(p8)
    local Title = p7.Title

    Title.Text = v38 .. "\n(" .. Format.kg(p8.weight or 0) .. ")"
    RarityStyle.Apply(Title, v39.color)
    p7.Square.Image = v39.square
    p7.Square.ImageColor3 = v39.squareTint or Color3.new(1, 1, 1)

    local Square, Square2 = p7.Square, p7.Square
    local offset, size = RarityDisplay.squareRect.offset, RarityDisplay.squareRect.size

    Square.ImageRectOffset = offset
    Square2.ImageRectSize = size
    p7.Square.Icon.Image = v40 and v40.icon or ""
    p7:SetAttribute("Stage", p8.stage or 1)
    p7:SetAttribute("StageEnd", p8.stageEnd or 0)
    p7:SetAttribute("Inf", p8.inf or 0)
    p7:SetAttribute("Infinite", v40 ~= nil and v40.infinite == true)
    tickRow(p7)
end

local function collapseRow(p9, p10) -- line: 363
    -- upvalues: TweenService (copy), Toast (copy), ListClip (copy), List (copy), v5 (copy), t6 (copy), t7 (copy), v22 (copy), t10 (copy), Sound (copy), describe (copy)
    local v41 = t6[p9]

    if not v41 then
        return
    end

    t6[p9] = nil

    local v42 = t7[p9]

    t7[p9] = nil

    if v42 and not p10 then
        local v43, v44 = describe(v42)

        Toast.Show("Unequipped", v43 .. "!", v44.color, Toast.RED)
    end

    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.Size = v41.Size
    Frame.LayoutOrder = v41.LayoutOrder

    local UIAspectRatioConstraint = v41:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Clone().Parent = Frame
    end

    local v45 = v41.AbsolutePosition + v41.AbsoluteSize / 2 - ListClip.AbsolutePosition
    local AbsoluteSize = v41.AbsoluteSize

    Frame.Parent = List

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint:Destroy()
    end

    local UIScale = v41:FindFirstChildOfClass("UIScale")

    if UIScale then
        UIScale:Destroy()
    end

    v41.AnchorPoint = Vector2.new(0.5, 0.5)
    v41.Position = UDim2.fromOffset(v45.X, v45.Y)
    v41.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    v41.ZIndex = 6
    v41.Parent = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ClipSwap")).Holder(ListClip)

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Parent = v41
    Sound.PlaybackSpeed = v5:NextNumber(t10[1], t10[2])
    Sound:Play()
    TweenService:Create(UIScale2, v22, {
        Scale = 0
    }):Play()

    local tween = TweenService:Create(Frame, v22, {
        Size = UDim2.fromScale(0, 0)
    })

    tween.Completed:Once(function() -- line: 397
        -- upvalues: v41 (copy), Frame (copy)
        Frame:Destroy()
        v41:Destroy()
    end)
    tween:Play()
end

local v46 = false

local function rankOf(p11) -- line: 408
    local v47 = table.clone(p11)

    table.sort(v47, function(p12, p13) -- line: 410
        if (p12.rate or 0) == (p13.rate or 0) then
            return (p12.weight or 0) > (p13.weight or 0)
        end

        return (p12.rate or 0) > (p13.rate or 0)
    end)

    local t15 = {}

    for v48, v49 in ipairs(v47) do
        t15[v49.id] = v48
    end

    return t15
end

local function rebuild(p14) -- line: 418
    -- upvalues: Modules (copy), ButtonHover (copy), FishDisplay (copy), Toast (copy), GrowthDisplay (copy), Badge (copy), Loc (copy), AquariumAction (copy), LocalPlayer (copy), Panel (copy), List (copy), Entry (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t12 (copy), describe (copy), tickRow (copy), dressRow (copy), collapseRow (copy), v46 (ref), rankOf (copy)
    local t16 = {}
    local v50 = rankOf(p14)
    local t17 = {}

    for v51, v52 in ipairs(p14) do
        t16[v52.id] = true

        local v53 = t6[v52.id]

        if v53 then
            local v54 = t7[v52.id]

            if v54 then
                if (v52.stage or 1) > (v54.stage or 1) then
                    local v55, v56 = describe(v52)

                    Toast.Show("Grew to " .. (GrowthDisplay.stages[v52.stage] or "") .. "!", v55, v56.color, Toast.ORANGE, nil, true)
                elseif (v52.inf or 0) > (v54.inf or 0) then
                    local v57, v58 = describe(v52)

                    Toast.Show("Grew to " .. GrowthDisplay.InfWord(v52.inf) .. "!", v57, v58.color, Toast.ORANGE, nil, true)
                end
            end

            dressRow(v53, v52)
            t7[v52.id] = v52
        else
            t17[#t17 + 1] = v52
            v53 = Entry:Clone()
            v53.Name = "Row"
            v53.Visible = true
            dressRow(v53, v52)
            v53.Unequip.Activated:Connect(function() -- line: 444
                -- upvalues: v52 (copy), AquariumAction (copy), collapseRow (copy)
                AquariumAction:FireServer("Unequip", v52.id)
                collapseRow(v52.id)
            end)
            v53.Grow.Activated:Connect(function() -- line: 453
                -- upvalues: v52 (copy), v53 (ref), ButtonHover (copy), AquariumAction (copy), LocalPlayer (copy), t12 (copy)
                ButtonHover.Press(v53.Grow)
                ButtonHover.Press(v53)

                for _, v59 in ipairs(t12) do
                    v59:Play()
                end

                AquariumAction:FireServer("Grow", v52.id)
                LocalPlayer:SetAttribute("TutorialSent", "FishGrew@" .. os.clock())
            end)
            v53.GrowNow.Activated:Connect(function() -- line: 460
                -- upvalues: v52 (copy), v53 (ref), Modules (copy), ButtonHover (copy), FishDisplay (copy), Panel (copy)
                ButtonHover.Press(v53.GrowNow)

                local v60 = v53:GetAttribute("StageEnd") or 0
                local v61 = FishDisplay[v52.name]

                require(Modules:WaitForChild("GrowNowCard")).Press({
                    id = v52.id,
                    left = v60 > 0 and math.ceil(v60 - workspace:GetServerTimeNow()) or 0,
                    icon = v53.Square.Icon.Image,
                    rarity = v61 and v61.rarity or "Common",
                    nextStage = (v53:GetAttribute("Stage") or 1) + 1,
                    host = Panel
                }, v53)
            end)

            local v63 = Badge.Attach(v53, t9)

            t8[v53] = v63
            v53.Destroying:Connect(function() -- line: 471
                -- upvalues: v53 (ref), t8 (copy)
                t8[v53] = nil
            end)
            tickRow(v53)
            t6[v52.id] = v53
            t7[v52.id] = v52
            v53.Parent = List
        end

        local v64 = v50[v52.id] or v51

        v53:SetAttribute("BaseOrder", v64)
        tickRow(v53)
    end

    local t19 = {}

    for v65 in pairs(t6) do
        if not t16[v65] then
            t19[#t19 + 1] = t7[v65]
            collapseRow(v65, true)
        end
    end

    if v46 and #t17 == 1 then
        local v66, v67 = describe(t17[1])

        Toast.Show("Successfully equipped", v66 .. "!", v67.color, nil, "equip")
    elseif v46 and #t17 > 1 then
        Toast.Show("Successfully equipped", Loc.F("aq.n_fish", "{n} fish!", {
            n = tostring(#t17)
        }), Color3.new(1, 1, 1), nil, "equip")
    elseif not v46 or #t19 ~= 1 then
        if v46 and #t19 > 1 then
            Toast.Show("Unequipped", Loc.F("aq.n_fish", "{n} fish!", {
                n = tostring(#t19)
            }), Color3.new(1, 1, 1), Toast.RED)
        end
    else
        local v70, v71 = describe(t19[1])

        Toast.Show("Unequipped", v70 .. "!", v71.color, Toast.RED)
    end

    v46 = true
end

PenState.OnClientEvent:Connect(rebuild)
AquariumAction:FireServer("Sync")

local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local InputMode = require(Modules:WaitForChild("InputMode"))
local ClipSwap = require(Modules:WaitForChild("ClipSwap"))
local Scale6 = UIListLayout.Padding.Scale
local Scale7 = UIPadding.PaddingTop.Scale
local Titan = RarityDisplay.Titan

local function tierOf(p15) -- line: 533
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), Titan (copy)
    local v72 = FishDisplay[p15]
    local v73, v74

    if v72 then
        local v75 = RarityDisplay[v72.shown or v72.rarity]

        if v75 then
            v73 = v75
            v74 = true
        else
            v74 = false
        end
    else
        v74 = false
    end

    if not v74 then
        v73 = Titan
    end

    return v73
end

local HUD = LocalPlayer.PlayerGui:WaitForChild("HUD")
local t22 = {
    shine = false,
    highlight = true
}

local function dressSquare(p16, p17, p18) -- line: 541
    -- upvalues: RarityDisplay (copy), Titan (copy)
    p18 = p18 or Titan
    p16.Square.Image = p18.square
    p16.Square.ImageColor3 = p18.squareTint or Color3.new(1, 1, 1)

    local Square, Square2 = p16.Square, p16.Square
    local offset, size = RarityDisplay.squareRect.offset, RarityDisplay.squareRect.size

    Square.ImageRectOffset = offset
    Square2.ImageRectSize = size
    p16.Square.Icon.Image = p17 or ""
end

local function setBonus(p19, p20, p21) -- line: 549
    -- upvalues: TitanConfig (copy), HUD (copy)
    local Stage = p19.Stage
    local Bonus = p19:FindFirstChild("Bonus")

    if not Bonus then
        Bonus = Instance.new("Frame")
        Bonus.Name = "Bonus"
        Bonus.BackgroundTransparency = 1

        local AnchorPoint, StagePosition, Size, ZIndex = Stage.AnchorPoint, Stage.Position, Stage.Size, Stage.ZIndex

        Bonus.AnchorPoint = AnchorPoint
        Bonus.Position = StagePosition
        Bonus.Size = Size
        Bonus.ZIndex = ZIndex

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.42, 0.5)
        ImageLabel.Size = UDim2.fromScale(0.3, 1.35)
        ImageLabel.ZIndex = Stage.ZIndex

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
        UIAspectRatioConstraint.Parent = ImageLabel
        ImageLabel.Parent = Bonus

        local clone = Stage:Clone()

        clone.Name = "Text"
        clone.Visible = true
        clone.AnchorPoint = Vector2.new(0, 0.5)
        clone.Position = UDim2.fromScale(0.45, 0.5)
        clone.Size = UDim2.fromScale(0.55, 1)
        clone.TextXAlignment = Enum.TextXAlignment.Left
        clone.Parent = Bonus
        Bonus.Parent = p19
    end

    local v77 = TitanConfig.SPECIES[p20]
    local v78 = v77 and TitanConfig.StatGradient(HUD, v77.stat)

    TitanConfig.StatIcon(Bonus.Icon, v77 and v77.stat)
    Bonus.Text.Text = TitanConfig.Signed(p20, p21)
    Bonus.Text.Grad.Enabled = v78 ~= nil

    if v78 then
        local Grad, Grad2 = Bonus.Text.Grad, Bonus.Text.Grad
        local Color, Rotation = v78.Color, v78.Rotation

        Grad.Color = Color
        Grad2.Rotation = Rotation
    end

    Stage.Visible = false
    Bonus.Visible = true
end

local function ownedTools() -- line: 589
    -- upvalues: LocalPlayer (copy), TitanConfig (copy)
    local t23 = {}

    for _, v79 in ipairs({
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            LocalPlayer.Character
        }) do
        for _, v80 in ipairs(v79 and v79:GetChildren() or {}) do
            if v80:IsA("Tool") and v80:GetAttribute("BagId") and TitanConfig.IsTitan(v80:GetAttribute("Species")) then
                t23[#t23 + 1] = v80
            end
        end
    end

    table.sort(t23, function(p22, p23) -- line: 596
        return (p22:GetAttribute("TitanBonus") or 0) > (p23:GetAttribute("TitanBonus") or 0)
    end)

    return t23
end

local function line(p24, p25, p26, p27) -- line: 602
    -- upvalues: Entry (copy)
    local clone = Entry.Title:Clone()

    clone.Name = p24
    clone.Position = UDim2.fromScale(0.47, p26)
    clone.Size = UDim2.fromScale(0.26, p27)
    clone.Text = p25

    return clone
end

local clone = Entry:Clone()

clone.Name = "TitanRow"
clone.LayoutOrder = -3E+05
clone.Visible = false
clone.GrowNow.Visible = false

local Unequip = Loc.T("TITAN SLOT")
local Unequip2 = Entry.Title:Clone()

Unequip2.Name = "SlotTitle"
Unequip2.Position = UDim2.fromScale(0.47, 0.2)
Unequip2.Size = UDim2.fromScale(0.26, 0.24)
Unequip2.Text = Unequip
Unequip2.Parent = clone
RarityStyle.Apply(Unequip2, Titan.color)
clone.Title.Position = UDim2.fromScale(0.47, 0.48)
clone.Title.Size = UDim2.fromScale(0.26, 0.26)
clone.Stage.Position = UDim2.fromScale(0.47, 0.78)
clone.Stage.Size = UDim2.fromScale(0.26, 0.2)
clone.Stage.Visible = false
Unequip = clone.Unequip
Unequip2 = clone.Unequip

local pos, size = t14.pos, t14.size

Unequip.Position = pos
Unequip2.Size = size

local Grow = clone.Grow

Grow.Name = "Equip"
Grow.AnchorPoint = Vector2.new(0.5, 0.5)
Grow.Position = UDim2.fromScale(0.47, 0.79)
Grow.Size = UDim2.fromScale(1, 0.3)
Grow.Text.AutoLocalize = false
Grow.Text.Text = Loc.T("EQUIP")
ButtonHover.Attach(Grow, t22)

local Frame = Instance.new("Frame")

Frame.Name = "TitanGap"
Frame.BackgroundTransparency = 1
Frame.Size = Entry.Size
Frame.LayoutOrder = -299999
Frame.Visible = false
Unequip = Instance.new("UIAspectRatioConstraint")
Unequip.AspectRatio = 40
Unequip.AspectType = Enum.AspectType.ScaleWithParentSize
Unequip.Parent = Frame

local clone2 = List:Clone()

for _, child in ipairs(clone2:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
        child:Destroy()
    end
end

clone2.Name = "TitanPicker"
clone2.Visible = false

local UIListLayout2 = clone2:FindFirstChildOfClass("UIListLayout")
local UIPadding2 = clone2:FindFirstChildOfClass("UIPadding")

local function fitPicker() -- line: 655
    -- upvalues: Scale6 (copy), Scale7 (copy), clone2 (copy), UIListLayout2 (copy), UIPadding2 (copy)
    local Y = clone2.AbsoluteWindowSize.Y

    UIListLayout2.Padding = UDim.new(0, Scale6 * Y)

    local v81 = UDim.new(0, Scale7 * Y)
    local v82 = UDim.new(0, Scale7 * Y)

    UIPadding2.PaddingTop = v81
    UIPadding2.PaddingBottom = v82
    clone2.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y + 2 * Scale7 * Y)
end

UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitPicker)
clone2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitPicker)
clone2.Parent = ClipSwap.Holder(ListClip)

local function slotButton() -- line: 666
    -- upvalues: clone (copy), Grow (copy)
    return Grow.Visible and Grow or clone.Unequip
end

local function hidePicker2() -- line: 669
    -- upvalues: List (copy), GuiService (copy), InputMode (copy), clone (copy), Grow (copy), clone2 (copy)
    if not clone2.Visible then
        return false
    end

    clone2.Visible = false
    List.Visible = true

    for _, child in ipairs(clone2:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    if InputMode.Pad() and clone.Visible then
        local v83

        if Grow.Visible then
            v83 = Grow

            if not Grow then
                v83 = clone.Unequip
            end
        else
            v83 = clone.Unequip
        end

        GuiService.SelectedObject = v83
    end

    return true
end

hidePicker = hidePicker2

local function pick(p28) -- line: 680
    -- upvalues: AquariumAction (copy), v5 (copy), t11 (copy), Sound2 (copy), hidePicker2 (copy)
    Sound2.PlaybackSpeed = v5:NextNumber(t11[1], t11[2])
    Sound2:Play()
    AquariumAction:FireServer("Equip", p28)
    hidePicker2()
end

local function showPicker() -- line: 686
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Format (copy), Loc (copy), AquariumAction (copy), List (copy), Entry (copy), v5 (copy), hoverRow (copy), t11 (copy), Sound2 (copy), t14 (copy), GuiService (copy), InputMode (copy), Titan (copy), dressSquare (copy), setBonus (copy), ownedTools (copy), clone2 (copy), fitPicker (copy), hidePicker2 (copy)
    local v84 = ownedTools()

    if #v84 ~= 0 and not clone2.Visible then
        local Frame = Instance.new("Frame")

        Frame.Name = "PickTitle"
        Frame.BackgroundTransparency = 1
        Frame.Size = Entry.Size
        Frame.LayoutOrder = 0

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 9
        UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
        UIAspectRatioConstraint.Parent = Frame

        local v85 = Loc.T("CHOOSE A TITAN")
        local clone = Entry.Title:Clone()

        clone.Name = "Text"
        clone.Position = UDim2.fromScale(0.47, 0.5)
        clone.Size = UDim2.fromScale(0.26, 1)
        clone.Text = v85
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.Position = UDim2.fromScale(0.5, 0.5)
        clone.Size = UDim2.fromScale(1, 1)
        clone.Parent = Frame
        Frame.Parent = clone2
        RarityStyle.Apply(clone, Titan.color)

        local v86

        for v87, v88 in ipairs(v84) do
            local Species = v88:GetAttribute("Species")
            local BagId = v88:GetAttribute("BagId")
            local v89 = FishDisplay[Species]
            local clone = Entry:Clone()

            clone.Name = "TitanPick"
            clone.Visible = true
            clone.LayoutOrder = v87
            clone.Title.Text = (v89 and v89.display or Species) .. "\n(" .. Format.kg(v88:GetAttribute("Weight") or 0) .. ")"

            local Apply = RarityStyle.Apply
            local Title = clone.Title
            local v90 = FishDisplay[Species]
            local v91

            if v90 then
                v91 = RarityDisplay[v90.shown or v90.rarity]
                v91 = v91 or Titan
            else
                v91 = Titan
            end

            Apply(Title, v91.color)

            local v92 = v89 and v89.icon
            local v93 = FishDisplay[Species]
            local v94

            if v93 then
                v94 = RarityDisplay[v93.shown or v93.rarity]
                v94 = v94 or Titan
            else
                v94 = Titan
            end

            dressSquare(clone, v92, v94)
            setBonus(clone, Species, v88:GetAttribute("TitanBonus"))

            local Unequip, GrowNow = clone.Unequip, clone.GrowNow

            Unequip.Visible = false
            GrowNow.Visible = false

            local Grow = clone.Grow

            Grow.Visible = true

            local pos, size = t14.pos, t14.size

            Grow.Position = pos
            Grow.Size = size
            Grow.Text.AutoLocalize = false
            Grow.Text.Text = Loc.T("EQUIP")
            Grow.Activated:Connect(function() -- line: 723
                -- upvalues: BagId (copy), AquariumAction (copy), v5 (copy), t11 (copy), Sound2 (copy), hidePicker2 (copy)
                Sound2.PlaybackSpeed = v5:NextNumber(t11[1], t11[2])
                Sound2:Play()
                AquariumAction:FireServer("Equip", BagId)
                hidePicker2()
            end)

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Hit"
            TextButton.BackgroundTransparency = 1
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton.Selectable = false
            TextButton.Size = UDim2.fromScale(1, 1)
            TextButton.ZIndex = clone.ZIndex
            TextButton.Activated:Connect(function() -- line: 733
                -- upvalues: BagId (copy), AquariumAction (copy), v5 (copy), t11 (copy), Sound2 (copy), hidePicker2 (copy)
                Sound2.PlaybackSpeed = v5:NextNumber(t11[1], t11[2])
                Sound2:Play()
                AquariumAction:FireServer("Equip", BagId)
                hidePicker2()
            end)
            TextButton.Parent = clone
            clone.Parent = clone2
            hoverRow(clone)
            v86 = v86 or Grow
        end

        clone2.CanvasPosition = Vector2.zero
        List.Visible = false
        clone2.Visible = true
        fitPicker()

        if InputMode.Pad() and v86 then
            GuiService.SelectedObject = v86
        end
    end
end

Grow.Activated:Connect(function() -- line: 745
    -- upvalues: ButtonHover (copy), Grow (copy), showPicker (copy)
    ButtonHover.Press(Grow)
    showPicker()
end)

local v95, v96, v97
local v98 = false

clone.Unequip.Activated:Connect(function() -- line: 751
    -- upvalues: AquariumAction (copy), v95 (ref)
    if v95 then
        AquariumAction:FireServer("Unequip", v95)
    end
end)

local function refresh() -- line: 754
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Toast (copy), Loc (copy), LocalPlayer (copy), HttpService (copy), GuiService (copy), InputMode (copy), Titan (copy), dressSquare (copy), setBonus (copy), ownedTools (copy), clone (copy), Grow (copy), Frame (copy), clone2 (copy), hidePicker2 (copy), v95 (ref), v96 (ref), v97 (ref), v98 (ref)
    local TitanSlot = LocalPlayer:GetAttribute("TitanSlot")

    local function v100() -- line: 756
        -- upvalues: TitanSlot (copy), HttpService (copy)
        return TitanSlot and HttpService:JSONDecode(TitanSlot)
    end

    local ok, result = pcall(v100)
    local result2 = if ok and type(result) == "table" and result then result else nil
    local v101 = ownedTools()
    local v102 = result2 ~= nil or #v101 > 0
    local SelectedObject = GuiService.SelectedObject

    clone.Visible = v102
    Frame.Visible = v102

    local v103, v104, v105

    if result2 then
        v103 = FishDisplay[result2.n]

        if v103 then
            local display = v103.display

            if display then
                v104 = display
                v105 = true
            else
                v105 = false
            end
        else
            v105 = false
        end
    else
        v103 = result2
        v104 = result2
        v105 = true
    end

    if not v105 then
        v104 = result2.n
    end

    if result2 then
        clone.Title.Text = v104

        local Apply = RarityStyle.Apply
        local Title = clone.Title
        local v106 = FishDisplay[result2.n]
        local v107

        if v106 then
            v107 = RarityDisplay[v106.shown or v106.rarity]
            v107 = v107 or Titan
        else
            v107 = Titan
        end

        Apply(Title, v107.color)
        setBonus(clone, result2.n, result2.b)
    else
        clone.Title.Text = Loc.T("EMPTY")
        RarityStyle.Apply(clone.Title, RarityDisplay.Common.color)

        local Bonus = clone:FindFirstChild("Bonus")

        if Bonus then
            Bonus.Visible = false
        end
    end

    local v108 = v103 and v103.icon
    local v109, v110

    if result2 then
        local v111 = FishDisplay[result2.n]

        if v111 then
            local v112 = RarityDisplay[v111.shown or v111.rarity]

            if v112 then
                v109 = v112
                v110 = true
            else
                v110 = false
            end
        else
            v110 = false
        end
    else
        v109 = result2
        v110 = true
    end

    if not v110 then
        v109 = Titan
    end

    dressSquare(clone, v108, v109)
    clone.Unequip.Visible = result2 ~= nil
    Grow.Visible = result2 == nil

    if InputMode.Pad() and (SelectedObject == Grow or SelectedObject == clone.Unequip) then
        local GuiService2, v113

        if SelectedObject ~= (Grow.Visible and Grow or clone.Unequip) and v102 then
            GuiService2 = GuiService

            if Grow.Visible then
                v113 = Grow

                if not Grow then
                    v113 = clone.Unequip
                end
            else
                v113 = clone.Unequip
            end

            GuiService2.SelectedObject = v113
        end
    end

    if clone2.Visible and (result2 or #v101 == 0) then
        hidePicker2()
    end

    local v114 = result2 and result2.i

    if v98 and v114 ~= v95 then
        if v114 then
            local Show = Toast.Show
            local v115 = v104 .. "!"
            local v116 = FishDisplay[result2.n]
            local v117

            if v116 then
                v117 = RarityDisplay[v116.shown or v116.rarity]
                v117 = v117 or Titan
            else
                v117 = Titan
            end

            Show("Successfully equipped", v115, v117.color, nil, "equip")
        else
            local Show = Toast.Show
            local v118 = (v96 or "") .. "!"
            local color, v119

            if v97 then
                local v120 = v97
                local v121 = FishDisplay[v120]
                local v122

                if v121 then
                    v122 = RarityDisplay[v121.shown or v121.rarity]
                    v122 = v122 or Titan
                else
                    v122 = Titan
                end

                local color2 = v122.color

                if color2 then
                    color = color2
                    v119 = true
                else
                    v119 = false
                end
            else
                v119 = false
            end

            if not v119 then
                color = Titan.color
            end

            Show("Unequipped", v118, color, Toast.RED)
        end
    end

    local v123 = result2 and result2.n

    v95 = v114
    v96 = v104
    v97 = v123
    v98 = true
end

local function watch(p29) -- line: 794
    -- upvalues: refresh (copy)
    if p29 then
        p29.ChildAdded:Connect(function(p30) -- line: 796
            -- upvalues: refresh (copy)
            if p30:IsA("Tool") then
                refresh()
            end
        end)
        p29.ChildRemoved:Connect(function(p31) -- line: 797
            -- upvalues: refresh (copy)
            if p31:IsA("Tool") then
                refresh()
            end
        end)
    end
end

watch(LocalPlayer:FindFirstChildOfClass("Backpack"))
watch(LocalPlayer.Character)
LocalPlayer.ChildAdded:Connect(function(p32) -- line: 801
    -- upvalues: refresh (copy), watch (copy)
    if p32:IsA("Backpack") then
        watch(p32)
        refresh()
    end
end)
LocalPlayer.CharacterAdded:Connect(watch)
LocalPlayer:GetAttributeChangedSignal("TitanSlot"):Connect(refresh)
clone.Parent = List
Frame.Parent = List
refresh()
Count.AutoLocalize = false

local function refreshCount() -- line: 810
    -- upvalues: Loc (copy), LocalPlayer (copy), Count (copy)
    Count.Text = Loc.F("aq.active", "{count}/{cap} Active", {
        count = tostring(LocalPlayer:GetAttribute("PenCount") or 0),
        cap = tostring(LocalPlayer:GetAttribute("PenCap") or 0)
    })
end

LocalPlayer:GetAttributeChangedSignal("PenCount"):Connect(refreshCount)
LocalPlayer:GetAttributeChangedSignal("PenCap"):Connect(refreshCount)
refreshCount()

local Text = Equip:WaitForChild("Text")

Text.AutoLocalize = false

local function refreshEquip() -- line: 822
    -- upvalues: PenConfig (copy), Format (copy), Loc (copy), LocalPlayer (copy), Text (copy)
    local v126 = LocalPlayer:GetAttribute("PenLevel") or 1
    local v127 = PenConfig.UpgradeCost(v126)

    if not v127 then
        Text.Text = Loc.T("MAX LEVEL")

        return
    end

    local FREE = LocalPlayer:GetAttribute("TutorialFreePen") and Loc.T("FREE") or Format.money(v127)

    Text.Text = Loc.F("aq.equip_slots", "+{slots} EQUIP [{price}]", {
        slots = tostring(PenConfig.Slots(v126 + 1) - PenConfig.Slots(v126)),
        price = FREE
    })
end

LocalPlayer:GetAttributeChangedSignal("PenLevel"):Connect(refreshEquip)
LocalPlayer:GetAttributeChangedSignal("TutorialFreePen"):Connect(refreshEquip)
refreshEquip()
Loc.Changed:Connect(function() -- line: 839
    -- upvalues: t6 (copy), t7 (copy), dressRow (copy), refreshCount (copy), refreshEquip (copy)
    for v129, v130 in pairs(t6) do
        if t7[v129] then
            dressRow(v130, t7[v129])
        end
    end

    refreshCount()
    refreshEquip()
end)

local PenLevel = LocalPlayer:GetAttribute("PenLevel")

LocalPlayer:GetAttributeChangedSignal("PenLevel"):Connect(function() -- line: 850
    -- upvalues: PenConfig (copy), Toast (copy), LocalPlayer (copy), PenLevel (ref)
    local PenLevel2 = LocalPlayer:GetAttribute("PenLevel")

    if PenLevel and PenLevel2 and PenLevel < PenLevel2 then
        local v131 = PenConfig.Slots(PenLevel2) - PenConfig.Slots(PenLevel)

        Toast.Show("Aquarium UPGRADED!", "(+" .. v131 .. (v131 == 1 and " slot)" or " slots)"), Color3.new(1, 1, 1), nil, "equip")
    end

    PenLevel = PenLevel2
end)
Equip.Activated:Connect(function() -- line: 859
    -- upvalues: PenConfig (copy), PenUpgrade (copy), LocalPlayer (copy)
    if PenConfig.UpgradeCost(LocalPlayer:GetAttribute("PenLevel") or 1) then
        PenUpgrade:FireServer()
        LocalPlayer:SetAttribute("TutorialSent", "PenUpgraded@" .. os.clock())
    end
end)
Panel.EquipBest.Activated:Connect(function() -- line: 868
    -- upvalues: ButtonHover (copy), AquariumAction (copy), Panel (copy), v5 (copy), t11 (copy), Sound2 (copy)
    ButtonHover.Press(Panel.EquipBest)
    Sound2.PlaybackSpeed = v5:NextNumber(t11[1], t11[2])
    Sound2:Play()
    AquariumAction:FireServer("EquipBest")
end)
Panel.EquipBestBase.Activated:Connect(function() -- line: 876
    -- upvalues: ButtonHover (copy), AquariumAction (copy), Panel (copy), v5 (copy), t11 (copy), Sound2 (copy)
    ButtonHover.Press(Panel.EquipBestBase)
    Sound2.PlaybackSpeed = v5:NextNumber(t11[1], t11[2])
    Sound2:Play()
    AquariumAction:FireServer("EquipBestBase")
end)

local Scale8 = UIListLayout.Padding.Scale
local Scale9 = UIPadding.PaddingTop.Scale

local function fitCanvas() -- line: 893
    -- upvalues: List (copy), UIListLayout (copy), UIPadding (copy), Scale8 (copy), Scale9 (copy)
    local Y = List.AbsoluteWindowSize.Y

    UIListLayout.Padding = UDim.new(0, Scale8 * Y)
    UIPadding.PaddingTop = UDim.new(0, Scale9 * Y)
    UIPadding.PaddingBottom = UDim.new(0, Scale9 * Y)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 2 * Scale9 * Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)
fitCanvas()
task.spawn(function() -- line: 906
    -- upvalues: ContentProvider (copy), AquariumGui (copy), SideButtons (copy)
    ContentProvider:PreloadAsync(AquariumGui:GetDescendants())
    ContentProvider:PreloadAsync(SideButtons:GetDescendants())
end)
task.spawn(function() -- line: 913
    -- upvalues: LocalPlayer (copy), PassPerks (copy), Panel (copy), v14 (copy), t6 (copy), tickRow (copy)
    while true do
        task.wait(1 / PassPerks.GrowSpeed(LocalPlayer))

        local n1 = 0

        for _, v132 in pairs(t6) do
            if Panel.Visible then
                tickRow(v132)
            end

            local v133 = v132:GetAttribute("StageEnd") or 0

            if v133 > 0 and v133 <= math.floor((workspace:GetServerTimeNow())) then
                n1 += 1
            end
        end

        v14.Set(n1)
    end
end)
Panel:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 926
    -- upvalues: Panel (copy), t6 (copy), tickRow (copy)
    if Panel.Visible then
        for _, v134 in pairs(t6) do
            tickRow(v134)
        end
    end
end)

local v135 = false

Button.Activated:Connect(open)
LocalPlayer:GetAttributeChangedSignal("QuestOpen"):Connect(function() -- line: 937
    -- upvalues: LocalPlayer (copy), open (copy), v135 (ref)
    local QuestOpen = LocalPlayer:GetAttribute("QuestOpen")

    if type(QuestOpen) == "string" and QuestOpen:sub(1, 9) == "Aquarium@" and not v135 then
        open()
    end
end)
close = close2
Close.Activated:Connect(function() -- line: 942
    -- upvalues: close2 (copy)
    close2()
end)

local function syncClose() -- line: 945
    -- upvalues: LocalPlayer (copy), Close (copy)
    Close.Visible = not string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",AquariumGui.Close,", 1, true)
end

LocalPlayer:GetAttributeChangedSignal("TutorialHides"):Connect(syncClose)
Close.Visible = not string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",AquariumGui.Close,", 1, true)
Remotes:WaitForChild("TutorialUpdate").OnClientEvent:Connect(function(p33, p34) -- line: 954
    -- upvalues: close2 (copy)
    if p33 == "Show" and type(p34) == "table" and p34.show and p34.show.closeAquarium then
        close2(true)
    end
end)

local v136 = TweenInfo.new(0)

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 963
    -- upvalues: TweenService (copy), AquariumGui (copy), FishSlot (copy), Scale (copy), FeedSlot (copy), Scale2 (copy), Panel (copy), Scale3 (copy), v6 (ref), v7 (ref), PadMenu (copy), v136 (copy)
    if not v7 then
        return
    end

    v7 = false
    v6 = false
    PadMenu.Close(AquariumGui)
    TweenService:Create(Scale3, v136, {
        Scale = 1
    }):Play()
    TweenService:Create(Panel, v136, {
        Rotation = 0
    }):Play()
    Panel.Visible = false

    for _, v137 in ipairs({
            { FishSlot, Scale },
            { FeedSlot, Scale2 }
        }) do
        TweenService:Create(v137[2], v136, {
            Scale = 1
        }):Play()
        v137[1].Visible = true
    end
end)

local function sideAway(p35) -- line: 981
    -- upvalues: TweenService (copy), FishSlot (copy), Scale (copy), FeedSlot (copy), Scale2 (copy), v3 (copy), v4 (copy), v135 (ref)
    for _, v138 in ipairs({
            { FishSlot, Scale },
            { FeedSlot, Scale2 }
        }) do
        local v139 = v138[1]
        local v140 = v138[2]

        if p35 then
            local tween = TweenService:Create(v140, v3, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 986
                -- upvalues: v139 (copy), v135 (ref)
                if v135 then
                    v139.Visible = false
                end
            end)
            tween:Play()
        else
            v139.Visible = true
            v140.Scale = 0
            TweenService:Create(v140, v4, {
                Scale = 1
            }):Play()
        end
    end
end

local function comeBack() -- line: 995
    -- upvalues: LocalPlayer (copy), v7 (ref), v135 (ref), sideAway (copy), comeBack (copy)
    if not (v135 or v7) then
        if LocalPlayer:GetAttribute("PanelOpen") then
            local connection

            connection = LocalPlayer:GetAttributeChangedSignal("PanelOpen"):Connect(function() -- line: 999
                -- upvalues: connection (ref), LocalPlayer (copy), comeBack (copy)
                if LocalPlayer:GetAttribute("PanelOpen") then
                    return
                end

                connection:Disconnect()
                comeBack()
            end)
        else
            sideAway(false)
        end
    end
end

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 1008
    -- upvalues: v135 (ref), sideAway (copy)
    v135 = true
    task.defer(function() -- line: 1010
        -- upvalues: v135 (ref), sideAway (copy)
        if v135 then
            sideAway(true)
        end
    end)
end)
Remotes:WaitForChild("HarpoonExit").OnClientEvent:Connect(function() -- line: 1012
    -- upvalues: v135 (ref), comeBack (copy)
    v135 = false
    comeBack()
end)

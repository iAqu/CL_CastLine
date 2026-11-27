-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Plots = workspace:WaitForChild("Plots")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TutorialUpdate = Remotes:WaitForChild("TutorialUpdate")
local TutorialAction = Remotes:WaitForChild("TutorialAction")
local NameFish = Remotes:WaitForChild("NameFish")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Toast = require(Modules:WaitForChild("Toast"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local NamePanel = require(script:WaitForChild("NamePanel"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local Loc = require(Modules:WaitForChild("Loc"))
local TutorialGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TutorialGui")
local Banner = TutorialGui:WaitForChild("Banner")
local Text = Banner:WaitForChild("Text")
local UIStroke = Text:WaitForChild("UIStroke")
local Pop = Banner:WaitForChild("Pop")
local Counter = TutorialGui:WaitForChild("Counter")
local Text2 = Counter:WaitForChild("Text")
local UIStroke2 = Text2:WaitForChild("UIStroke")
local Pop2 = Counter:WaitForChild("Pop")
local Sub = TutorialGui:WaitForChild("Sub")
local Text3 = Sub:WaitForChild("Text")
local UIStroke3 = Text3:WaitForChild("UIStroke")
local Pop3 = Sub:WaitForChild("Pop")

Text.AutoLocalize = false
Text3.AutoLocalize = false

local t1 = {
    gold = { "RewardScreen", "Choices", "Right", "Above", "Amount" },
    green = { "MoneyGui", "Money", "Amount" },
    red = { "HUD", "Fat", "Value" }
}
local t2 = {
    "gold",
    "green",
    "red"
}
local t3 = {}

local function gradientOf(p1) -- line: 109
    -- upvalues: LocalPlayer (copy), t1 (copy), t3 (copy)
    if t3[p1] ~= nil then
        return t3[p1] or nil
    end

    local v1 = LocalPlayer.PlayerGui

    for _, v2 in ipairs(t1[p1]) do
        v1 = v1 and v1:FindFirstChild(v2)
    end

    local UIGradient = v1 and v1:FindFirstChildOfClass("UIGradient")

    t3[p1] = UIGradient and UIGradient.Color or false

    return t3[p1] or nil
end

local function midOf(p2) -- line: 118
    local Keypoints = p2.Keypoints

    for i = 1, #Keypoints - 1 do
        if Keypoints[i + 1].Time >= 0.5 then
            return Keypoints[i].Value:Lerp(Keypoints[i + 1].Value, (0.5 - Keypoints[i].Time) / math.max(Keypoints[i + 1].Time - Keypoints[i].Time, 1E-06))
        end
    end

    return Keypoints[#Keypoints].Value
end

local function esc(p3) -- line: 127
    return (p3:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function colourable(p4) -- line: 129
    p4.RichText = true

    local t4 = {
        shown = nil,
        label = p4,
        overlays = {}
    }

    p4:GetPropertyChangedSignal("TextTransparency"):Connect(function() -- line: 133
        -- upvalues: p4 (copy), t4 (copy)
        for _, v5 in pairs(t4.overlays) do
            v5.TextTransparency = p4.TextTransparency
        end
    end)

    return t4
end

local function overlayFor(p5, p6) -- line: 138
    -- upvalues: gradientOf (copy)
    local v6 = p5.overlays[p6]

    if not v6 then
        v6 = p5.label:Clone()
        v6.Name = p5.label.Name .. p6

        for _, child in ipairs(v6:GetChildren()) do
            child:Destroy()
        end

        v6.ZIndex = p5.label.ZIndex + 1

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Color = gradientOf(p6)
        UIGradient.Parent = v6
        v6.Parent = p5.label.Parent
        p5.overlays[p6] = v6
    end

    return v6
end

local function setLine(p7, p8, p9) -- line: 155
    -- upvalues: t2 (copy), gradientOf (copy), midOf (copy), overlayFor (copy)
    p7.shown = p8

    local t5 = {}

    for _, v7 in ipairs(t2) do
        local v8 = p9[v7]

        if v8 and gradientOf(v7) then
            for _, v9 in ipairs(v8) do
                local v10, v11 = string.find(p8, v9, 1, true)

                if v10 then
                    table.insert(t5, {
                        a = v10,
                        b = v11,
                        colour = v7
                    })
                    break
                end
            end
        end
    end

    table.sort(t5, function(p10, p11) -- line: 167
        return p10.a < p11.a
    end)

    for i = #t5, 2, -1 do
        if t5[i].a <= t5[i - 1].b then
            table.remove(t5, i)
        end
    end

    local function build(p12) -- line: 172
        -- upvalues: p8 (copy), t5 (copy), gradientOf (copy), midOf (copy)
        local t7 = {}

        local function hidden(p13) -- line: 174
            -- upvalues: p12 (copy)
            local v12, v13

            if not p12 or p13 == "" then
                v13 = false
            else
                local v14 = "<font transparency=\"1\">" .. p13 .. "</font>"

                if v14 then
                    v12 = v14
                    v13 = true
                else
                    v13 = false
                end
            end

            if not v13 then
                v12 = p13
            end

            return v12
        end

        local n1 = 1

        for _, v15 in ipairs(t5) do
            local v16 = p8:sub(n1, v15.a - 1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

            if p12 and v16 ~= "" then
                v16 = "<font transparency=\"1\">" .. v16 .. "</font>" or v16
            end

            table.insert(t7, v16)

            local v17 = p8:sub(v15.a, v15.b):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

            if p12 then
                if (v15.colour ~= p12 or not v17) and v17 ~= "" then
                    v17 = "<font transparency=\"1\">" .. v17 .. "</font>" or v17
                end

                table.insert(t7, v17)
            else
                table.insert(t7, "<font color=\"#" .. midOf((gradientOf(v15.colour))):ToHex() .. "\">" .. v17 .. "</font>")
            end

            n1 = v15.b + 1
        end

        local v19 = p8:sub(n1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v20, v21

        if not p12 or v19 == "" then
            v21 = false
        else
            local v22 = "<font transparency=\"1\">" .. v19 .. "</font>"

            if v22 then
                v20 = v22
                v21 = true
            else
                v21 = false
            end
        end

        if not v21 then
            v20 = v19
        end

        table.insert(t7, v20)

        return table.concat(t7)
    end

    p7.label.Text = build(nil)

    local t8 = {}

    for _, v23 in ipairs(t5) do
        t8[v23.colour] = true

        local v24 = overlayFor(p7, v23.colour)

        v24.Text = build(v23.colour)
        v24.TextTransparency = p7.label.TextTransparency
        v24.Visible = true
    end

    for v25, v26 in pairs(p7.overlays) do
        if not t8[v25] then
            v26.Visible = false
        end
    end
end

local v27 = colourable(Text3)
local v28 = colourable(Text)

local function subWords(p14) -- line: 203
    return {
        gold = p14.subGold,
        green = p14.subGreen
    }
end

local function bannerWords(p15) -- line: 204
    return {
        red = p15 and p15.show and p15.show.bannerRed
    }
end

local t10 = {
    ["FEED {name}"] = "tut.feed",
    ["EVOLVE {name}"] = "tut.evolve"
}
local Hand = TutorialGui:WaitForChild("Hand")
local Ref = TutorialGui:WaitForChild("Ref")
local TutorialSpotlight = LocalPlayer.PlayerGui:WaitForChild("TutorialSpotlight")
local Ref2 = TutorialSpotlight:WaitForChild("Ref")
local t11 = {
    TutorialSpotlight:WaitForChild("Top"),
    TutorialSpotlight:WaitForChild("Bottom"),
    TutorialSpotlight:WaitForChild("Left"),
    TutorialSpotlight:WaitForChild("Right")
}

TutorialSpotlight = {
    TEXTURE = "rbxassetid://124105837947066",
    WIDTH = 5.5,
    Z_OFFSET = 4,
    CHECK = 0.25
}

local _ = {
    WIDTH = 2.6,
    EVERY = 2,
    TRAVEL = 0.45,
    HALF = 0.12
}
local v29 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v30 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v31 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t12 = {
    DIM = 0.1,
    PAD = 6,
    FOLLOW = 6,
    OVERSCAN = 600,
    OUT = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}
local id = nil
local v32
local n2 = 0
local v33 = false
local v34 = false
local BannerPosition = Banner.Position
local n3 = 1

local function topbarSpot() -- line: 236
    -- upvalues: Banner (copy), BannerPosition (copy)
    local Height = game:GetService("GuiService").TopbarInset.Height
    local v35 = Banner.Size.Y.Scale * Banner.Parent.AbsoluteSize.Y + Banner.Size.Y.Offset

    if Height <= 0 or v35 <= 0 then
        return BannerPosition, 1
    end

    local v37 = math.min(1, Height * 0.85 / v35)

    return UDim2.new(BannerPosition.X.Scale, BannerPosition.X.Offset, 0, -Height / 2 - v35 * v37 / 2), v37
end

local v38, v39, goal, id2
local n4 = 0
local _ = {
    FLY = 4,
    LAND = 2
}
local Folder = Instance.new("Folder")

Folder.Name = "TutorialPointer"
Folder.Parent = workspace

local function myPlot() -- line: 254
    -- upvalues: LocalPlayer (copy), Plots (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child
        end
    end

    return nil
end

local function resolve(p16) -- line: 262
    -- upvalues: myPlot (copy)
    local v40 = myPlot()

    for match in string.gmatch(p16, "[^%.]+") do
        v40 = v40 and v40:FindFirstChild(match)
    end

    return if v40 and v40:IsA("BasePart") then v40 else nil
end

local function setFade(p17) -- line: 270
    -- upvalues: Banner (copy), Text (copy), UIStroke (copy)
    Banner.BackgroundTransparency = p17
    Text.TextTransparency = p17
    UIStroke.Transparency = p17
end

local function lightSequence(p18) -- line: 276
    local t13 = {}

    for i = 0, 12 do
        local v41 = i / 12
        local v44 = math.clamp(1 - math.abs(v41 - p18) / 0.12, 0, 1)

        table.insert(t13, NumberSequenceKeypoint.new(v41, 1 - v44))
    end

    return NumberSequence.new(t13)
end

local function drawBeam(p19, p20) -- line: 287
    -- upvalues: Folder (copy), lightSequence (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "TutorialBeam0"
    Attachment.Position = Vector3.new(0, 1.5, 0)
    Attachment.Parent = p19

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "TutorialBeam1"
    Attachment2.Parent = p20

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.FaceCamera = true
    Beam.Width0 = 5.5
    Beam.Width1 = 5.5
    Beam.Texture = "rbxassetid://124105837947066"
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.TextureLength = 6
    Beam.TextureSpeed = 1.4
    Beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
    Beam.LightEmission = 0
    Beam.Transparency = NumberSequence.new(0)
    Beam.ZOffset = 4
    Beam.Segments = 16
    Beam.Parent = Folder

    local Beam2 = Instance.new("Beam")

    Beam2.Attachment0 = Attachment
    Beam2.Attachment1 = Attachment2
    Beam2.FaceCamera = true
    Beam2.Width0 = 2.6
    Beam2.Width1 = 2.6
    Beam2.Color = ColorSequence.new(Color3.fromRGB(190, 225, 255))
    Beam2.Brightness = 3
    Beam2.LightEmission = 1
    Beam2.ZOffset = 4.1
    Beam2.Segments = 24
    Beam2.Transparency = NumberSequence.new(1)
    Beam2.Parent = Folder
    task.spawn(function() -- line: 323
        -- upvalues: Beam2 (copy), lightSequence (copy)
        while true do
            if Beam2.Parent then
                local elapsed = os.clock()

                while Beam2.Parent do
                    local v46 = (os.clock() - elapsed) / 0.45

                    if v46 >= 1 then
                        break
                    end

                    Beam2.Transparency = lightSequence(-0.12 + v46 * 1.24)
                    task.wait()
                end

                if Beam2.Parent then
                    Beam2.Transparency = NumberSequence.new(1)
                    task.wait(1.55)
                    continue
                end
            end

            break
        end
    end)

    return { Attachment, Attachment2, Beam, Beam2 }
end

local _ = {
    IMAGE = "rbxassetid://93029437217022",
    PX = 225,
    MIN_SCALE = 0.34,
    OFFSET = Vector3.new(2, 0, 1.5),
    WIGGLE = 20,
    SPEED = 12
}
local t14 = {
    SPEED = 6.3,
    FILL = Color3.fromRGB(255, 224, 105),
    OUTLINE = Color3.fromRGB(255, 247, 205)
}

local function resolveAny(p21) -- line: 347
    -- upvalues: myPlot (copy)
    local v47 = myPlot()

    for match in string.gmatch(p21, "[^%.]+") do
        v47 = v47 and v47:FindFirstChild(match)
    end

    return v47
end

local function showing(p22) -- line: 357
    while p22 and p22:IsA("GuiObject") do
        if not p22.Visible then
            return false
        end

        p22 = p22.Parent
    end

    local v49, v50

    if p22 ~= nil then
        if p22:IsA("ScreenGui") then
            v50 = false
        else
            local BillboardGui = p22:IsA("BillboardGui")

            if BillboardGui then
                v50 = false
            else
                v49 = BillboardGui
                v50 = true
            end
        end
    else
        v49 = false
        v50 = true
    end

    if not v50 then
        v49 = p22.Enabled
    end

    return v49
end

local v51 = Vector2.new(0.29, 0.21)
local GuiService = game:GetService("GuiService")
local InputMode = require(Modules:WaitForChild("InputMode"))
local _ = {
    SIZE = 0.075,
    PULSE = 0.12,
    SPEED = 5,
    INSET = 0.12
}
local _ = {
    H = 0.36,
    WIDE = 8
}
local t15 = {}

game:GetService("ProximityPromptService").PromptShown:Connect(function(p23) -- line: 391
    -- upvalues: t15 (copy)
    t15[p23] = true
    p23.PromptHidden:Once(function() -- line: 393
        -- upvalues: p23 (copy), t15 (copy)
        t15[p23] = nil
    end)
end)

local PadWorldPrompt = require(Modules:WaitForChild("PadWorldPrompt"))

local function promptOn(p24) -- line: 396
    -- upvalues: t15 (copy), PadWorldPrompt (copy)
    if PadWorldPrompt.ShownOn(p24) then
        return true
    end

    for v52 in pairs(t15) do
        if v52.Parent and p24 and v52:IsDescendantOf(p24) then
            return true
        end
    end

    return false
end

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "PadPress"
ImageLabel.BackgroundTransparency = 1
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Size = UDim2.fromScale(0.075, 0.075)
ImageLabel.ZIndex = Hand.ZIndex
ImageLabel.Visible = false

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
UIAspectRatioConstraint.Parent = ImageLabel

local UIScale = Instance.new("UIScale")

UIScale.Parent = ImageLabel
ImageLabel.Parent = Hand.Parent

local v53 = InputMode.Prompt(Hand.Parent, {
    text = "HOLD FISH",
    height = 0.055,
    name = "PadHoldHint",
    keys = {
        Enum.KeyCode.ButtonL1,
        Enum.KeyCode.ButtonR1
    },
    anchor = Vector2.new(0.5, 1),
    zIndex = Hand.ZIndex
})

local function padKeyed(p25) -- line: 420
    return p25:FindFirstChild("PadKey") ~= nil
end

local function inHotbar(p26) -- line: 421
    -- upvalues: LocalPlayer (copy)
    local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

    return BackpackGui ~= nil and (p26:IsDescendantOf(BackpackGui))
end

local function holdingFish() -- line: 427
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")

    return Tool ~= nil and Tool:GetAttribute("Species") ~= nil
end

local function guiTarget(p27) -- line: 436
    -- upvalues: LocalPlayer (copy), showing (copy)
    for _, v54 in ipairs(p27) do
        local v55 = LocalPlayer.PlayerGui:FindFirstChild(v54.gui)

        if v55 then
            local v56 = v54.under and v55:FindFirstChild(v54.under, true) or not v54.under and v55

            if v55.Enabled and v56 then
                if v54.emptyHand then
                    local Character = LocalPlayer.Character
                    local Tool = Character and Character:FindFirstChildOfClass("Tool")

                    if Tool == nil or Tool:GetAttribute("Species") == nil then
                        for _, v57 in ipairs(v54.under and v56:GetChildren() or v56:GetDescendants()) do
                            if v54.attr then
                                if (v57:GetAttribute(v54.attr) == true or v57.Name == v54.button) and v57:IsA("GuiObject") and v57.AbsoluteSize.X > 1 and showing(v57) and (not v54.unselected or not v57:GetAttribute("Selected")) then
                                    return v57
                                end
                            elseif v57.Name == v54.button and v57:IsA("GuiObject") and v57.AbsoluteSize.X > 1 and showing(v57) and (not v54.unselected or not v57:GetAttribute("Selected")) then
                                return v57
                            end
                        end
                    end
                else
                    for _, v58 in ipairs(v54.under and v56:GetChildren() or v56:GetDescendants()) do
                        if v54.attr then
                            if (v58:GetAttribute(v54.attr) == true or v58.Name == v54.button) and v58:IsA("GuiObject") and v58.AbsoluteSize.X > 1 and showing(v58) and (not v54.unselected or not v58:GetAttribute("Selected")) then
                                return v58
                            end
                        elseif v58.Name == v54.button and v58:IsA("GuiObject") and v58.AbsoluteSize.X > 1 and showing(v58) and (not v54.unselected or not v58:GetAttribute("Selected")) then
                            return v58
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function guiCentre(p28) -- line: 454
    -- upvalues: Ref (copy)
    local BillboardGui = p28:FindFirstAncestorWhichIsA("BillboardGui")

    if not BillboardGui then
        return p28.AbsolutePosition - Ref.AbsolutePosition + p28.AbsoluteSize / 2
    end

    local CurrentCamera = workspace.CurrentCamera
    local Adornee = BillboardGui.Adornee
    local v59, v60

    if Adornee then
        if Adornee:IsA("Attachment") then
            local WorldPosition = Adornee.WorldPosition

            if WorldPosition then
                v59 = WorldPosition
                v60 = true
            elseif Adornee:IsA("BasePart") then
                local AdorneePosition = Adornee.Position

                if AdorneePosition then
                    v59 = AdorneePosition
                    v60 = true
                else
                    v60 = false
                end
            else
                v60 = false
            end
        elseif Adornee:IsA("BasePart") then
            local AdorneePosition = Adornee.Position

            if AdorneePosition then
                v59 = AdorneePosition
                v60 = true
            else
                v60 = false
            end
        else
            v60 = false
        end
    else
        v60 = false
    end

    if not v60 then
        v59 = nil
    end

    if not CurrentCamera or not v59 then
        return nil
    end

    local v61, v62 = CurrentCamera:WorldToScreenPoint(v59 + CurrentCamera.CFrame:VectorToWorldSpace(BillboardGui.StudsOffset) + BillboardGui.StudsOffsetWorldSpace)

    if not v62 then
        return nil
    end

    local v63 = p28.AbsolutePosition + p28.AbsoluteSize / 2 - (BillboardGui.AbsolutePosition + BillboardGui.AbsoluteSize / 2)

    return Vector2.new(v61.X, v61.Y) + v63 - Ref.AbsolutePosition
end

local function keepGuiPointer(p29, p30) -- line: 467
    -- upvalues: RunService (copy), LocalPlayer (copy), Hand (copy), Ref (copy), t12 (copy), n2 (ref), v51 (copy), InputMode (copy), v53 (copy), guiTarget (copy), guiCentre (copy)
    local v64, v65

    local function beckon(p31) -- line: 470
        -- upvalues: v65 (ref)
        if p31 == v65 then
            return
        end

        if v65 then
            v65:SetAttribute("TutorialBeckon", nil)
        end

        v65 = p31

        if p31 then
            p31:SetAttribute("TutorialBeckon", true)
        end
    end

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function(p32) -- line: 478
        -- upvalues: p29 (copy), p30 (copy), v64 (ref), v65 (ref), elapsed (copy), connection (ref), LocalPlayer (copy), Hand (copy), Ref (copy), t12 (copy), n2 (ref), v51 (copy), InputMode (copy), v53 (copy), guiTarget (copy), guiCentre (copy)
        local v66 = n2 == p30 and guiTarget(p29) or nil

        if v66 ~= v65 then
            if v65 then
                v65:SetAttribute("TutorialBeckon", nil)
            end

            v65 = v66

            if v66 then
                v66:SetAttribute("TutorialBeckon", true)
            end
        end

        if v66 then
            if InputMode.Pad() then
                Hand.Visible = false
                v64 = nil

                local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

                if BackpackGui ~= nil and v66:IsDescendantOf(BackpackGui) then
                    local v67 = v66.AbsolutePosition - Ref.AbsolutePosition

                    v53.gui.Position = UDim2.fromOffset(v67.X + v66.AbsoluteSize.X / 2, v67.Y - 6)
                    v53.Show(true)
                else
                    v53.Show(false)
                end
            else
                v53.Show(false)

                local v68 = guiCentre(v66)

                if v68 then
                    local v69 = v64
                    local v70 = if v69 then v64:Lerp(v68, 1 - math.exp(-t12.FOLLOW * p32)) else nil

                    if v69 and v70 then
                        v68 = v70
                    end

                    v64 = v68

                    local AbsoluteSize = Hand.AbsoluteSize

                    Hand.Position = UDim2.fromOffset(v64.X + AbsoluteSize.X * v51.X, v64.Y + AbsoluteSize.Y * v51.Y)
                    Hand.Rotation = 20 * math.sin((os.clock() - elapsed) * 12)
                    Hand.Visible = true
                else
                    Hand.Visible = false
                    v64 = nil
                end
            end
        else
            Hand.Visible = false
            v53.Show(false)
            v64 = nil

            if n2 ~= p30 then
                connection:Disconnect()
            end
        end
    end)
end

local function destroyAll(p33) -- line: 588
    for _, v74 in ipairs(p33 or {}) do
        if v74.Parent then
            v74:Destroy()
        end
    end
end

local function firstShowing(p34, p35) -- line: 633
    -- upvalues: showing (copy)
    local v75 = p34:FindFirstChild(p35, true)

    if v75 and v75:IsA("GuiObject") and v75.AbsoluteSize.X > 1 and showing(v75) then
        return v75
    end

    for _, descendant in ipairs(p34:GetDescendants()) do
        if descendant.Name == p35 and descendant ~= v75 and descendant:IsA("GuiObject") and descendant.AbsoluteSize.X > 1 and showing(descendant) then
            return descendant
        end
    end

    return nil
end

local function spotTarget(p36) -- line: 643
    -- upvalues: LocalPlayer (copy), Ref2 (copy), firstShowing (copy)
    for _, v76 in ipairs(p36) do
        local v77 = LocalPlayer.PlayerGui:FindFirstChild(v76.gui)
        local button2 = type(v76.button) == "table" and v76.button or {
            v76.button
        }
        local v78, v79

        for _, v80 in ipairs(button2) do
            local v81 = v77 and v77.Enabled and firstShowing(v77, v80)

            if v81 then
                local v82 = v81.AbsolutePosition - Ref2.AbsolutePosition
                local v83 = v82 + v81.AbsoluteSize

                v78 = v78 and v78:Min(v82) or v82
                v79 = v79 and v79:Max(v83) or v83
            end
        end

        if v78 then
            return (v78 + v79) / 2, (v79 - v78) / 2
        end
    end

    return nil
end

local function cutHole(p37, p38, p39, p40) -- line: 664
    -- upvalues: Ref2 (copy), t11 (copy), t12 (copy)
    local AbsoluteSize = Ref2.AbsoluteSize
    local OVERSCAN = t12.OVERSCAN
    local v86 = math.floor(math.clamp(p37 - p39, 0, AbsoluteSize.X) + 0.5)
    local v89 = math.floor(math.clamp(p37 + p39, 0, AbsoluteSize.X) + 0.5)
    local v92 = math.floor(math.clamp(p38 - p40, 0, AbsoluteSize.Y) + 0.5)
    local v95 = math.floor(math.clamp(p38 + p40, 0, AbsoluteSize.Y) + 0.5)
    local v96 = t11[1]
    local v97 = t11[1]
    local v98 = UDim2.fromOffset(-OVERSCAN, -OVERSCAN)
    local v99 = UDim2.fromOffset(AbsoluteSize.X + 2 * OVERSCAN, v92 + OVERSCAN)

    v96.Position = v98
    v97.Size = v99

    local v100 = t11[2]
    local v101 = t11[2]
    local v102 = UDim2.fromOffset(-OVERSCAN, v95)
    local v103 = UDim2.fromOffset(AbsoluteSize.X + 2 * OVERSCAN, AbsoluteSize.Y - v95 + OVERSCAN)

    v100.Position = v102
    v101.Size = v103

    local v104 = t11[3]
    local v105 = t11[3]
    local v106 = UDim2.fromOffset(-OVERSCAN, v92)
    local v107 = UDim2.fromOffset(v86 + OVERSCAN, v95 - v92)

    v104.Position = v106
    v105.Size = v107

    local v108 = t11[4]
    local v109 = t11[4]
    local v110 = UDim2.fromOffset(v89, v92)
    local v111 = UDim2.fromOffset(AbsoluteSize.X - v89 + OVERSCAN, v95 - v92)

    v108.Position = v110
    v109.Size = v111

    if v89 - v86 >= 2 then
        return v95 - v92 >= 2
    end

    return false
end

local v112 = nil
local t16 = {}
local t17
local n5 = 1
local n6 = (-1e999)
local UserInputService = game:GetService("UserInputService")
local t18 = {
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true
}

UserInputService.InputBegan:Connect(function(p41) -- line: 761
    -- upvalues: n6 (ref), t18 (copy)
    if t18[p41.KeyCode] then
        n6 = os.clock()
    end
end)
UserInputService.InputChanged:Connect(function(p42) -- line: 764
    -- upvalues: n6 (ref)
    if p42.KeyCode == Enum.KeyCode.Thumbstick1 and p42.Position.Magnitude > 0.5 then
        n6 = os.clock()
    end
end)

local function padWorthy(p43) -- line: 768
    -- upvalues: LocalPlayer (copy)
    local v113, v114

    if p43 ~= nil then
        local GuiButton = p43:IsA("GuiButton")

        if GuiButton then
            v113 = p43:FindFirstChild("PadKey") ~= nil

            local v115 = not v113

            if v115 then
                local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

                v114 = not (BackpackGui ~= nil and p43:IsDescendantOf(BackpackGui))
            else
                v114 = v115
            end
        else
            v114 = GuiButton
        end
    else
        v114 = false
    end

    return v114
end

local function spotButton(p44) -- line: 769
    -- upvalues: LocalPlayer (copy), showing (copy), firstShowing (copy)
    for _, v116 in ipairs(p44 or {}) do
        local v117 = LocalPlayer.PlayerGui:FindFirstChild(v116.gui)

        if v117 and v117.Enabled then
            local _ipairs = ipairs
            local button = v116.button

            for _, v118 in _ipairs(type(button) == "table" and v116.button or {
                    v116.button
                }) do
                local v119 = firstShowing(v117, v118)

                if v119 and not v119:IsA("GuiButton") then
                    v119 = v119:FindFirstChild("Button")

                    if not (v119 and v119:IsA("GuiButton") and showing(v119)) then
                        v119 = nil
                    end
                end

                if v119 then
                    return v119
                end
            end
        end
    end

    return nil
end

local function keepPadFocus(p45, p46) -- line: 785
    -- upvalues: RunService (copy), LocalPlayer (copy), Ref (copy), n2 (ref), showing (copy), GuiService (copy), InputMode (copy), ImageLabel (copy), UIScale (copy), guiTarget (copy), n6 (ref), spotButton (copy)
    if not (p45.guiPointer or p45.spotlight) then
        return
    end

    local t19 = {}
    local _ipairs = ipairs
    local t20 = {
        p45.guiPointer or {},
        p45.spotlight or {}
    }

    for _, v122 in _ipairs(t20) do
        for _, v123 in ipairs(v122) do
            t19[v123.gui] = true
        end
    end

    local function ours(p47) -- line: 791
        -- upvalues: t19 (copy), LocalPlayer (copy)
        while p47 and p47.Parent ~= LocalPlayer.PlayerGui do
            p47 = p47.Parent
        end

        return p47 ~= nil and t19[p47.Name] == true
    end

    task.spawn(function() -- line: 796
        -- upvalues: p45 (copy), p46 (copy), t19 (copy), RunService (copy), LocalPlayer (copy), Ref (copy), n2 (ref), showing (copy), GuiService (copy), InputMode (copy), ImageLabel (copy), UIScale (copy), guiTarget (copy), n6 (ref), spotButton (copy)
        local v125, v126

        while n2 == p46 do
            if not InputMode.Pad() or GuiService.MenuIsOpen then
                v125 = nil
            else
                local v127 = p45.guiPointer and guiTarget(p45.guiPointer)
                local v129

                if v127 then
                    local GuiButton

                    if v127 ~= nil then
                        GuiButton = v127:IsA("GuiButton")

                        if GuiButton then
                            if v127:FindFirstChild("PadKey") ~= nil then
                                GuiButton = false
                            else
                                local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

                                GuiButton = not (BackpackGui ~= nil and v127:IsDescendantOf(BackpackGui))
                            end
                        end
                    else
                        GuiButton = false
                    end

                    if GuiButton and v127 then
                        v129 = v127
                    end
                else
                    v129 = spotButton(p45.spotlight)

                    local v130, v131

                    if v129 ~= nil then
                        local GuiButton = v129:IsA("GuiButton")

                        if GuiButton then
                            v130 = v129:FindFirstChild("PadKey") ~= nil

                            local v132 = not v130

                            if v132 then
                                local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")

                                v131 = not (BackpackGui ~= nil and v129:IsDescendantOf(BackpackGui))
                            else
                                v131 = v132
                            end
                        else
                            v131 = GuiButton
                        end
                    else
                        v131 = false
                    end

                    if not v131 or not v129 then
                        v129 = nil
                    end
                end

                local SelectedObject = GuiService.SelectedObject
                local v133 = os.clock() - n6 < 2

                if v129 and SelectedObject ~= v129 then
                    if v129 == v125 and SelectedObject and showing(SelectedObject) then
                        if not v133 then
                            while SelectedObject and SelectedObject.Parent ~= LocalPlayer.PlayerGui do
                                SelectedObject = SelectedObject.Parent
                            end

                            if SelectedObject ~= nil and t19[SelectedObject.Name] == true then
                                GuiService.SelectedObject = v129
                            end
                        end
                    else
                        GuiService.SelectedObject = v129
                    end
                end

                v125 = v129
                v126 = v126 or RunService.RenderStepped:Connect(function() -- line: 816
                    -- upvalues: v125 (ref), Ref (copy), showing (copy), GuiService (copy), InputMode (copy), ImageLabel (copy), UIScale (copy)
                    local v134 = v125

                    if not InputMode.Pad() or not v134 or not v134.Parent or not showing(v134) or GuiService.SelectedObject ~= v134 then
                        ImageLabel.Visible = false

                        return
                    end

                    local v135 = v134.AbsolutePosition - Ref.AbsolutePosition
                    local AbsoluteSize = v134.AbsoluteSize

                    ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonA)
                    ImageLabel.Position = UDim2.fromOffset(v135.X + AbsoluteSize.X * 0.88, v135.Y + AbsoluteSize.Y * 0.88)
                    UIScale.Scale = 1 + 0.12 * (math.sin(os.clock() * 5) * 0.5 + 0.5)
                    ImageLabel.Visible = true
                end)
            end

            task.wait(0.15)
        end

        if v126 then
            v126:Disconnect()
        end

        ImageLabel.Visible = false
    end)
end

local t21 = {}

local function setHiddenGuis(p48, p49) -- line: 845
    -- upvalues: LocalPlayer (copy), n2 (ref), t21 (copy)
    local v137, v138

    if p48 and #p48 > 0 then
        local v139 = table.concat(p48, ",")

        if v139 then
            v137 = v139
            v138 = true
        else
            v138 = false
        end
    else
        v138 = false
    end

    if not v138 then
        v137 = nil
    end

    LocalPlayer:SetAttribute("TutorialHides", v137)

    local t22 = {}

    for _, v140 in ipairs(p48 or {}) do
        t22[v140] = true
    end

    for v141, v142 in pairs(t21) do
        if not t22[v141] then
            local v143 = LocalPlayer.PlayerGui:FindFirstChild(v141)

            if v143 then
                v143.Enabled = v142
            end

            t21[v141] = nil
        end
    end

    for v144 in pairs(t22) do
        if not string.find(v144, ".", 1, true) and t21[v144] == nil then
            task.spawn(function() -- line: 858
                -- upvalues: p49 (copy), v144 (copy), LocalPlayer (copy), n2 (ref), t21 (copy)
                local v145 = LocalPlayer.PlayerGui:WaitForChild(v144, 5)

                if n2 == p49 and t21[v144] == nil and v145 and v145:IsA("ScreenGui") then
                    t21[v144] = v145.Enabled
                    v145.Enabled = false
                end
            end)
        end
    end
end

local function popIn(p50, p51, p52, p53) -- line: 870
    -- upvalues: TweenService (copy), v29 (copy), v30 (copy)
    p50.BackgroundTransparency = 1
    p52.TextTransparency = 1
    p53.Transparency = 1
    p50.Visible = true
    p51.Scale = 0.85
    TweenService:Create(p51, v29, {
        Scale = 1
    }):Play()
    TweenService:Create(p50, v30, {
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(p52, v30, {
        TextTransparency = 0
    }):Play()
    TweenService:Create(p53, v30, {
        Transparency = 0
    }):Play()
end

local function fadeAway(p54, p55, p56, p57) -- line: 880
    -- upvalues: TweenService (copy), v31 (copy), n2 (ref)
    TweenService:Create(p54, v31, {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(p55, v31, {
        TextTransparency = 1
    }):Play()
    TweenService:Create(p56, v31, {
        Transparency = 1
    }):Play()
    task.delay(v31.Time, function() -- line: 884
        -- upvalues: p54 (copy), p57 (copy), n2 (ref)
        if n2 == p57 then
            p54.Visible = false
        end
    end)
end

local t23 = {
    PEAK = 1.3,
    UP = TweenInfo.new(0.08, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    DOWN = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local function setCounter(p58, p59) -- line: 891
    -- upvalues: TweenService (copy), Text2 (copy), Pop2 (copy), v39 (ref), t23 (copy)
    local v146 = math.min(p58, p59)

    Text2.Text = tostring(v146) .. "/" .. tostring(p59)

    if v39 ~= nil and v146 ~= v39 then
        local tween = TweenService:Create(Pop2, t23.UP, {
            Scale = t23.PEAK
        })

        tween.Completed:Once(function() -- line: 896
            -- upvalues: TweenService (copy), Pop2 (copy), t23 (copy)
            TweenService:Create(Pop2, t23.DOWN, {
                Scale = 1
            }):Play()
        end)
        tween:Play()
    end

    v39 = v146
end

local function hideBanner(p60) -- line: 902
    -- upvalues: TweenService (copy), Banner (copy), Text (copy), UIStroke (copy), v31 (copy), n2 (ref), v33 (ref)
    v33 = false
    TweenService:Create(Banner, v31, {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(Text, v31, {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke, v31, {
        Transparency = 1
    }):Play()
    task.delay(v31.Time, function() -- line: 907
        -- upvalues: p60 (copy), Banner (copy), n2 (ref)
        if n2 == p60 then
            Banner.Visible = false
        end
    end)
end

local function bannerFor(p61) -- line: 913
    -- upvalues: FishDisplay (copy), Loc (copy), t10 (copy)
    local v147 = p61.show or {}
    local v148 = p61.info and FishDisplay[p61.info.species or ""]
    local info = p61.info and (p61.info.name or v148 and Loc.T(v148.display))

    if v147.bannerNamed and info then
        return Loc.F(t10[v147.bannerNamed] or "", v147.bannerNamed, {
            name = info
        })
    end

    return v147.banner and Loc.T(v147.banner)
end

local function show(p62) -- line: 923
    -- upvalues: TweenService (copy), RunService (copy), LocalPlayer (copy), NameFish (copy), FishDisplay (copy), NamePanel (copy), Loc (copy), Banner (copy), Text (copy), UIStroke (copy), Pop (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), Sub (copy), Text3 (copy), UIStroke3 (copy), Pop3 (copy), setLine (copy), v27 (copy), v28 (copy), Ref2 (copy), t11 (copy), v29 (copy), v30 (copy), t12 (copy), id (ref), v32 (ref), n2 (ref), v33 (ref), v34 (ref), BannerPosition (copy), n3 (ref), topbarSpot (copy), v38 (ref), v39 (ref), goal (ref), Folder (copy), resolve (copy), drawBeam (copy), t14 (copy), resolveAny (copy), InputMode (copy), promptOn (copy), keepGuiPointer (copy), destroyAll (copy), spotTarget (copy), cutHole (copy), v112 (ref), t16 (copy), t17 (ref), n5 (ref), keepPadFocus (copy), setHiddenGuis (copy), popIn (copy), fadeAway (copy), setCounter (copy), hideBanner (copy), bannerFor (copy)
    if p62.id == id then
        if p62.goal then
            setCounter(p62.count or 0, p62.goal)

            if not Counter.Visible and not v34 then
                popIn(Counter, Pop2, Text2, UIStroke2)
            end
        end
    else
        id = p62.id
        v34 = false
        Banner.Rotation = 0
        Banner.Position = BannerPosition
        v32 = p62
        n2 += 1

        local v149 = n2

        destroyAll(v38)
        v38 = nil

        local v150 = p62.show or {}

        n3 = 1

        if v150.bannerTopbar then
            local v151, v152 = topbarSpot()

            Banner.Position = v151
            n3 = v152
        end

        local v153 = bannerFor(p62)

        if v153 and (not v33 or v28.shown ~= v153) then
            setLine(v28, v153, {
                red = p62 and p62.show and p62.show.bannerRed
            })
            Banner.BackgroundTransparency = 1
            Text.TextTransparency = 1
            UIStroke.Transparency = 1
            Banner.Visible = true
            v33 = true
            Pop.Scale = n3 * 0.85
            TweenService:Create(Pop, v29, {
                Scale = n3
            }):Play()
            TweenService:Create(Banner, v30, {
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(Text, v30, {
                TextTransparency = 0
            }):Play()
            TweenService:Create(UIStroke, v30, {
                Transparency = 0
            }):Play()
        elseif not v153 and v33 then
            hideBanner(v149)
        end

        if p62.goal then
            v39 = nil
            goal = p62.goal
            setCounter(p62.count or 0, p62.goal)

            if v150.countOnEat and (p62.count or 0) == 0 and not LocalPlayer:GetAttribute("LocalEating") then
                Counter.Visible = false

                local connection

                connection = LocalPlayer:GetAttributeChangedSignal("LocalEating"):Connect(function() -- line: 969
                    -- upvalues: v149 (copy), connection (ref), LocalPlayer (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), n2 (ref), popIn (copy)
                    if n2 == v149 then
                        if LocalPlayer:GetAttribute("LocalEating") then
                            connection:Disconnect()

                            if not Counter.Visible then
                                popIn(Counter, Pop2, Text2, UIStroke2)
                            end
                        end
                    else
                        connection:Disconnect()
                    end
                end)
            else
                popIn(Counter, Pop2, Text2, UIStroke2)
            end
        else
            goal = nil

            if Counter.Visible then
                v39 = nil
                fadeAway(Counter, Text2, UIStroke2, v149)
            end
        end

        if v150.sub then
            if not Sub.Visible or v27.shown ~= Loc.T(v150.sub) then
                setLine(v27, Loc.T(v150.sub), {
                    gold = v150.subGold,
                    green = v150.subGreen
                })
                popIn(Sub, Pop3, Text3, UIStroke3)
            end
        elseif Sub.Visible then
            fadeAway(Sub, Text3, UIStroke3, v149)
        end

        if v150.beam then
            local beam, beamUntilEat = v150.beam, v150.beamUntilEat

            task.spawn(function() -- line: 598
                -- upvalues: v149 (copy), beam (copy), beamUntilEat (copy), LocalPlayer (copy), n2 (ref), v38 (ref), resolve (copy), drawBeam (copy), destroyAll (copy)
                local v154

                local function eating() -- line: 600
                    -- upvalues: beamUntilEat (copy), LocalPlayer (copy)
                    return beamUntilEat and LocalPlayer:GetAttribute("LocalEating") == true
                end

                local function refresh() -- line: 603
                    -- upvalues: v149 (copy), beam (copy), beamUntilEat (copy), LocalPlayer (copy), n2 (ref), v38 (ref), resolve (copy), drawBeam (copy), destroyAll (copy), v154 (ref)
                    if n2 ~= v149 then
                        return
                    end

                    if beamUntilEat and LocalPlayer:GetAttribute("LocalEating") == true then
                        destroyAll(v154)
                        v154 = nil
                    elseif not (v154 and v154[1].Parent and v154[2].Parent) then
                        destroyAll(v154)
                        v154 = nil

                        local Character = LocalPlayer.Character
                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                        local v155 = resolve(beam)

                        if HumanoidRootPart and v155 then
                            v154 = drawBeam(HumanoidRootPart, v155)
                            v38 = v154
                        end
                    end
                end

                local v156 = beamUntilEat and LocalPlayer:GetAttributeChangedSignal("LocalEating"):Connect(refresh)

                while n2 == v149 do
                    refresh()
                    task.wait(0.25)
                end

                if v156 then
                    v156:Disconnect()
                end

                destroyAll(v154)
            end)
        end

        if v150.spotlight then
            local spotlight = v150.spotlight

            local function dimAway() -- line: 687
                -- upvalues: v149 (copy), TweenService (copy), t11 (copy), t12 (copy), v112 (ref), t16 (copy), t17 (ref)
                if v112 ~= v149 then
                    return
                end

                v112 = nil

                for _, v157 in ipairs(t11) do
                    local tween = TweenService:Create(v157, t12.OUT, {
                        BackgroundTransparency = 1
                    })

                    table.insert(t16, tween)
                    tween:Play()
                end

                task.delay(t12.OUT.Time, function() -- line: 695
                    -- upvalues: t11 (copy), v112 (ref), t17 (ref)
                    if v112 then
                        return
                    end

                    for _, v158 in ipairs(t11) do
                        v158.Visible = false
                    end

                    t17 = nil
                end)
            end

            local connection

            connection = RunService.RenderStepped:Connect(function(p63) -- line: 702
                -- upvalues: v149 (copy), spotlight (copy), dimAway (copy), connection (ref), Ref2 (copy), t11 (copy), t12 (copy), n2 (ref), spotTarget (copy), cutHole (copy), v112 (ref), t16 (copy), t17 (ref), n5 (ref)
                if n2 ~= v149 then
                    connection:Disconnect()
                    dimAway()

                    return
                end

                local v159, v160 = spotTarget(spotlight)

                if not v159 then
                    dimAway()

                    return
                end

                if v112 ~= v149 then
                    v112 = v149

                    for _, v161 in ipairs(t16) do
                        v161:Cancel()
                    end

                    table.clear(t16)

                    if not (t17 and t11[1].Visible) then
                        local AbsoluteSize = Ref2.AbsoluteSize

                        t17 = {
                            cx = AbsoluteSize.X / 2,
                            cy = AbsoluteSize.Y / 2,
                            hw = AbsoluteSize.X / 2 + 1,
                            hh = AbsoluteSize.Y / 2 + 1
                        }
                        n5 = 1
                    else
                        n5 = t11[1].BackgroundTransparency
                    end
                end

                local v163 = 1 - math.exp(-t12.FOLLOW * p63)

                t17.cx += (v159.X - t17.cx) * v163
                t17.cy += (v159.Y - t17.cy) * v163
                t17.hw += (v160.X + t12.PAD - t17.hw) * v163
                t17.hh += (v160.Y + t12.PAD - t17.hh) * v163
                n5 += (t12.DIM - n5) * v163

                if not cutHole(t17.cx, t17.cy, t17.hw, t17.hh) then
                    dimAway()

                    return
                end

                for _, v165 in ipairs(t11) do
                    v165.BackgroundTransparency = n5
                    v165.Visible = true
                end
            end)
        end

        if v150.pointer then
            local pointer, padPointer = v150.pointer, v150.padPointer
            local v166 = padPointer and Enum.KeyCode[padPointer.key]

            task.spawn(function() -- line: 521
                -- upvalues: v149 (copy), pointer (copy), padPointer (copy), v166 (copy), n2 (ref), Folder (copy), resolve (copy), InputMode (copy), promptOn (copy)
                local elapsed = os.clock()
                local BillboardGui, ImageLabel, v167
                local n7 = 0

                while n2 == v149 do
                    local BillboardGui2

                    if BillboardGui and BillboardGui.Parent and BillboardGui.Adornee and BillboardGui.Adornee.Parent then
                        BillboardGui2 = BillboardGui
                    else
                        if BillboardGui then
                            BillboardGui:Destroy()
                        end

                        local v168 = resolve(pointer)

                        if v168 then
                            local CurrentCamera = workspace.CurrentCamera
                            local v170 = math.clamp((CurrentCamera and CurrentCamera.ViewportSize.Y or 982) / 982, 0.34, 1)

                            BillboardGui2 = Instance.new("BillboardGui")
                            BillboardGui2.Name = "TutorialHand"
                            BillboardGui2.Adornee = v168
                            n7 = 225 * v170
                            BillboardGui2.Size = UDim2.fromOffset(n7, n7)
                            BillboardGui2.StudsOffset = Vector3.new(2, 0, 1.5)
                            BillboardGui2.AlwaysOnTop = true
                            BillboardGui2.LightInfluence = 0
                            ImageLabel = Instance.new("ImageLabel")
                            ImageLabel.BackgroundTransparency = 1
                            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                            ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
                            ImageLabel.Size = UDim2.fromScale(1, 1)
                            ImageLabel.Image = "rbxassetid://93029437217022"
                            ImageLabel.Parent = BillboardGui2
                            v167 = v166 and InputMode.Prompt(BillboardGui2, {
                                height = 1,
                                name = "PadPointer",
                                key = v166,
                                text = padPointer.text
                            })

                            if v167 then
                                v167.Show(true)
                            end

                            BillboardGui2.Parent = Folder
                        end
                    end

                    BillboardGui = BillboardGui2

                    if BillboardGui2 and ImageLabel then
                        local v171 = v167 ~= nil and InputMode.Pad()

                        ImageLabel.Visible = not v171

                        if v167 then
                            v167.Show(not (v171 and promptOn(BillboardGui2.Adornee)))
                        end

                        local v172 = if v171 then UDim2.fromOffset(n7 * 0.36 * 8, n7 * 0.36) else nil
                        local v173 = if not v171 or not v172 then UDim2.fromOffset(n7, n7) else v172

                        if BillboardGui2.Size ~= v173 then
                            BillboardGui2.Size = v173
                        end

                        ImageLabel.Rotation = 20 * math.sin((os.clock() - elapsed) * 12)
                    end

                    task.wait()
                end

                if BillboardGui then
                    BillboardGui:Destroy()
                end
            end)
        end

        if v150.highlight then
            local highlight = v150.highlight

            task.spawn(function() -- line: 569
                -- upvalues: v149 (copy), highlight (copy), RunService (copy), n2 (ref), Folder (copy), t14 (copy), resolveAny (copy)
                local Highlight = Instance.new("Highlight")

                Highlight.Name = "TutorialGlow"
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded

                local FILL, OUTLINE = t14.FILL, t14.OUTLINE

                Highlight.FillColor = FILL
                Highlight.OutlineColor = OUTLINE
                Highlight.FillTransparency = 1
                Highlight.OutlineTransparency = 1
                Highlight.Parent = Folder

                local elapsed = os.clock()

                while n2 == v149 do
                    if not (Highlight.Adornee and Highlight.Adornee.Parent) then
                        Highlight.Adornee = resolveAny(highlight)
                    end

                    local v176 = math.sin((os.clock() - elapsed) * t14.SPEED) * 0.5 + 0.5

                    Highlight.FillTransparency = 0.85 - v176 * 0.2
                    Highlight.OutlineTransparency = 0.35 - v176 * 0.35
                    RunService.Heartbeat:Wait()
                end

                Highlight:Destroy()
            end)
        end

        if v150.guiPointer then
            keepGuiPointer(v150.guiPointer, v149)
        end

        keepPadFocus(v150, v149)

        if v150.namePanel then
            local v177 = p62.info and p62.info.id
            local v178 = p62.info and FishDisplay[p62.info.species]

            NamePanel.Open(function(p64) -- line: 1004
                -- upvalues: v177 (copy), LocalPlayer (copy), NameFish (copy)
                NameFish:FireServer(v177, p64)
                LocalPlayer:SetAttribute("TutorialSent", "FishNamed@" .. os.clock())
            end, v178 and v178.display)
        end

        setHiddenGuis(v150.hideGui, v149)
    end
end

local function swapBanner(p65, p66) -- line: 1024
    -- upvalues: TweenService (copy), Banner (copy), Pop (copy), setLine (copy), v28 (copy), v29 (copy), v32 (ref), BannerPosition (copy), n3 (ref), topbarSpot (copy)
    local v179 = v32

    setLine(v28, p65, {
        red = v179 and v179.show and v179.show.bannerRed
    })

    local v180 = BannerPosition
    local n8 = 1

    if p66 then
        v180, n8 = topbarSpot()
    end

    n3 = n8
    Pop.Scale = n8 * 0.8
    Banner.Rotation = -7
    TweenService:Create(Pop, v29, {
        Scale = n8
    }):Play()
    TweenService:Create(Banner, v29, {
        Rotation = 0,
        Position = v180
    }):Play()
end

Remotes:WaitForChild("ReelState").OnClientEvent:Connect(function(p67) -- line: 1034
    -- upvalues: ReplicatedStorage (copy), Loc (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), id (ref), v32 (ref), n2 (ref), v33 (ref), v34 (ref), popIn (copy), fadeAway (copy), bannerFor (copy), swapBanner (copy)
    local v181 = v32
    local v182 = v181 and v181.show
    local v183 = type(p67) == "table"

    if v183 then
        local v184 = v182

        if v184 then
            local v185 = v182.reelBanner

            v185 = v185 and id == v181.id and v33
            v184 = v185
        end

        v183 = v184
    end

    if not v183 then
        return
    end

    local TouchEnabled, v186

    if p67.action ~= "start" or v34 then
        if (p67.action == "caught" or p67.action == "escaped") and v34 then
            v34 = false
            swapBanner(bannerFor(v181) or "", false)

            if v181.goal and not Counter.Visible then
                popIn(Counter, Pop2, Text2, UIStroke2)
            end
        end
    else
        v34 = true
        TouchEnabled = game:GetService("UserInputService").TouchEnabled
        v186 = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode")).Pad() and v182.reelBannerPad

        local T = Loc.T
        local v188, v189

        if v186 then
            v188 = v186
            v189 = true
        elseif TouchEnabled then
            local reelBanner = v182.reelBanner

            if reelBanner then
                v188 = reelBanner
                v189 = true
            else
                v189 = false
            end
        else
            v189 = false
        end

        if not v189 then
            v188 = v182.reelBannerPC or v182.reelBanner
        end

        swapBanner(T(v188), true)

        if Counter.Visible then
            fadeAway(Counter, Text2, UIStroke2, n2)
        end
    end
end)

local function quiet(p68) -- line: 1062
    -- upvalues: id (ref), v32 (ref), n2 (ref), v38 (ref), destroyAll (copy), show (copy)
    local v190 = v32
    local v191 = v190 and not v190.goal

    if v191 then
        local v192 = v190.trigger == p68

        if v192 then
            local id2 = id

            v192 = id2 == v190.id
        end

        v191 = v192
    end

    if not v191 then
        return
    end

    n2 += 1

    local v193 = n2

    destroyAll(v38)
    v38 = nil
    task.delay(3, function() -- line: 1069
        -- upvalues: v190 (copy), v193 (copy), id (ref), n2 (ref), show (copy)
        local v194 = n2 == v193

        v194 = v194 and id == v190.id

        if v194 then
            id = nil
            show(v190)
        end
    end)
end

LocalPlayer:GetAttributeChangedSignal("TutorialSent"):Connect(function() -- line: 1075
    -- upvalues: LocalPlayer (copy), quiet (copy)
    local TutorialSent = LocalPlayer:GetAttribute("TutorialSent")

    if type(TutorialSent) == "string" then
        quiet(string.match(TutorialSent, "^[^@]+"))
    end
end)

local function hide() -- line: 1080
    -- upvalues: Counter (copy), Text2 (copy), UIStroke2 (copy), Sub (copy), Text3 (copy), UIStroke3 (copy), id (ref), n2 (ref), v33 (ref), v38 (ref), v39 (ref), destroyAll (copy), setHiddenGuis (copy), fadeAway (copy), hideBanner (copy)
    id = nil
    n2 += 1
    destroyAll(v38)
    v38 = nil
    setHiddenGuis(nil, n2)

    if v33 then
        hideBanner(n2)
    end

    if Counter.Visible then
        v39 = nil
        fadeAway(Counter, Text2, UIStroke2, n2)
    end

    if Sub.Visible then
        fadeAway(Sub, Text3, UIStroke3, n2)
    end
end

local function collapse(p69, p70, p71, p72, p73) -- line: 1095
    -- upvalues: TweenService (copy)
    if p69.Visible then
        local v195 = TweenInfo.new(p73, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(p70, v195, {
            Scale = 0
        }):Play()
        TweenService:Create(p69, v195, {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(p71, v195, {
            TextTransparency = 1
        }):Play()
        TweenService:Create(p72, v195, {
            Transparency = 1
        }):Play()
    end
end

local function holdForQuip(p74) -- line: 1136
    -- upvalues: Toast (copy), FishDisplay (copy), MutationDisplay (copy), RarityDisplay (copy), Loc (copy), id2 (ref), n4 (ref), show (copy)
    id2 = p74.id
    n4 += 1

    local v196 = n4
    local info = p74.info
    local v197 = FishDisplay[info.species]
    local v198 = info.mutation and MutationDisplay[info.mutation]
    local v199, v200

    if v197 then
        local shown = v197.shown

        if shown then
            v199 = shown
            v200 = true
        else
            local rarity = v197.rarity

            if rarity then
                v199 = rarity
                v200 = true
            else
                v200 = false
            end
        end
    else
        v200 = false
    end

    if not v200 then
        v199 = "Common"
    end

    local v201 = RarityDisplay[v199]
    local Fish = Loc.Fish
    local v202 = v198 and v198.prefix
    local display = if v197 then v197.display else nil

    if not v197 or not display then
        display = tostring(info.species)
    end

    local v203 = Fish(v202, display)

    if not v197 or info.name ~= v197.display then
        Toast.Show(Loc.F("tut.named_to", "Named {fish} to", {
            fish = v203
        }), info.name .. "!", v201 and v201.color, nil, "equip")
    end

    if n4 == v196 then
        id2 = nil
        show(p74)
    end
end

Loc.Changed:Connect(function() -- line: 1157
    -- upvalues: Loc (copy), Sub (copy), setLine (copy), v27 (copy), v28 (copy), v32 (ref), v33 (ref), bannerFor (copy)
    if not v32 then
        return
    end

    local v204 = v33 and bannerFor(v32)

    if v204 then
        local v205 = v32

        setLine(v28, v204, {
            red = v205 and v205.show and v205.show.bannerRed
        })
    end

    local v206 = v32.show or {}

    if v206.sub and Sub.Visible then
        setLine(v27, Loc.T(v206.sub), {
            gold = v206.subGold,
            green = v206.subGreen
        })
    end
end)

local t31 = {
    COUNT = 44,
    GRAVITY = 1500,
    LIFE = 1.1,
    FADE = 0.45,
    GREENS = {
        Color3.fromRGB(60, 220, 90),
        Color3.fromRGB(120, 240, 140),
        Color3.fromRGB(30, 180, 70),
        Color3.fromRGB(170, 255, 180)
    }
}
local t32 = {
    PEAK = 1.3,
    SOUND = "rbxassetid://129840040992692",
    FLASH = Color3.fromRGB(120, 255, 140)
}
local TutorialConfetti = LocalPlayer.PlayerGui:WaitForChild("TutorialConfetti")
local Sound = Instance.new("Sound")

Sound.Name = "TutorialSuccess"
Sound.SoundId = t32.SOUND
Sound.Parent = game:GetService("SoundService")

local function spawnConfetti(p75) -- line: 1183
    -- upvalues: RunService (copy), t31 (copy), TutorialConfetti (copy)
    local v207 = TutorialConfetti.AbsoluteSize.Y / 982
    local t33 = {}

    for _ = 1, t31.COUNT do
        local Frame = Instance.new("Frame")

        Frame.Size = UDim2.fromOffset(math.random(8, 16) * v207, math.random(12, 22) * v207)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.fromOffset(p75.X, p75.Y)
        Frame.BackgroundColor3 = t31.GREENS[math.random(#t31.GREENS)]
        Frame.BorderSizePixel = 0
        Frame.Rotation = math.random(0, 360)
        Frame.Parent = TutorialConfetti

        local v209 = math.rad((math.random(0, 360)))
        local v210 = math.random(320, 760) * v207

        table.insert(t33, {
            p = Frame,
            x = p75.X,
            y = p75.Y,
            vx = math.cos(v209) * v210,
            vy = math.sin(v209) * v210 - math.random(220, 520) * v207,
            spin = (math.random() > 0.5 and 1 or -1) * math.random(160, 320)
        })
    end

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function(p76) -- line: 1205
        -- upvalues: v207 (copy), t33 (copy), elapsed (copy), connection (ref), t31 (copy)
        local v212 = math.clamp((os.clock() - elapsed - t31.LIFE) / t31.FADE, 0, 1)

        for _, v213 in ipairs(t33) do
            v213.vy += t31.GRAVITY * v207 * p76
            v213.x += v213.vx * p76
            v213.y += v213.vy * p76
            v213.p.Position = UDim2.fromOffset(v213.x, v213.y)
            v213.p.Rotation += v213.spin * p76
            v213.p.BackgroundTransparency = v212
        end

        if not (v212 >= 1) then
            return
        end

        connection:Disconnect()

        for _, v214 in ipairs(t33) do
            v214.p:Destroy()
        end
    end)
end

local function celebrate() -- line: 1223
    -- upvalues: TweenService (copy), Banner (copy), Text (copy), Pop (copy), n3 (ref), t32 (copy), Sound (copy), spawnConfetti (copy)
    Pop.Scale = n3

    local tween = TweenService:Create(Pop, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = t32.PEAK * n3
    })

    tween.Completed:Once(function() -- line: 1227
        -- upvalues: TweenService (copy), Pop (copy), n3 (ref)
        TweenService:Create(Pop, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = n3
        }):Play()
    end)
    tween:Play()
    task.spawn(function() -- line: 1231
        -- upvalues: TweenService (copy), Text (copy), t32 (copy)
        local TextColor3 = Text.TextColor3

        for _ = 1, 2 do
            TweenService:Create(Text, TweenInfo.new(0.07), {
                TextColor3 = t32.FLASH
            }):Play()
            task.wait(0.09)
            TweenService:Create(Text, TweenInfo.new(0.07), {
                TextColor3 = TextColor3
            }):Play()
            task.wait(0.09)
        end

        Text.TextColor3 = TextColor3
    end)
    spawnConfetti(Banner.AbsolutePosition + Banner.AbsoluteSize / 2)
    Sound:Play()
end

local Reward = TutorialGui:WaitForChild("Reward")

TutorialGui = {
    POP = 0.45,
    FROM = 0.25,
    SPIN = 40,
    HOLD = 2.6,
    OUT = 0.25
}

local v215 = Color3.new(1, 1, 1)

local function popReward(p77) -- line: 1254
    -- upvalues: TweenService (copy), RunService (copy), RarityStyle (copy), Reward (copy), v215 (copy)
    Reward.Title.Text = p77.title or ""
    Reward.Reward.Text = p77.reward or ""
    RarityStyle.Apply(Reward.Reward, v215)

    local Pop = Reward.Pop

    Pop.Scale = 0.25
    Reward.Visible = true
    TweenService:Create(Pop, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    local v216 = TweenInfo.new(0.27, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, v217 in ipairs({
            Reward.Image,
            Reward.Burst
        }) do
        v217.ImageTransparency = 1
        TweenService:Create(v217, v216, {
            ImageTransparency = 0
        }):Play()
    end

    for _, v218 in ipairs({
            Reward.Title,
            Reward.Reward
        }) do
        v218.TextTransparency = 1
        v218.UIStroke.Transparency = 1
        TweenService:Create(v218, v216, {
            TextTransparency = 0
        }):Play()
        TweenService:Create(v218.UIStroke, v216, {
            Transparency = 0
        }):Play()
    end

    local HarpoonSFX = game:GetService("SoundService"):FindFirstChild("HarpoonSFX")
    local CatchSound = HarpoonSFX and HarpoonSFX:FindFirstChild("CatchSound")

    if CatchSound then
        CatchSound:Play()
    end

    local elapsed = os.clock()
    local v219 = false
    local connection

    connection = RunService.RenderStepped:Connect(function(p78) -- line: 1279
        -- upvalues: Pop (copy), elapsed (copy), v219 (ref), connection (ref), TweenService (copy), Reward (copy)
        Reward.Burst.Rotation = (Reward.Burst.Rotation + 40 * p78) % 360

        if v219 or not (os.clock() - elapsed >= 2.6) then
            return
        end

        v219 = true

        local v220 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tween = TweenService:Create(Pop, v220, {
            Scale = 0
        })

        for _, v221 in ipairs({
                Reward.Image,
                Reward.Burst
            }) do
            TweenService:Create(v221, v220, {
                ImageTransparency = 1
            }):Play()
        end

        for _, v222 in ipairs({
                Reward.Title,
                Reward.Reward
            }) do
            TweenService:Create(v222, v220, {
                TextTransparency = 1
            }):Play()
            TweenService:Create(v222.UIStroke, v220, {
                Transparency = 1
            }):Play()
        end

        tween.Completed:Once(function() -- line: 1290
            -- upvalues: connection (ref), Reward (copy)
            connection:Disconnect()
            Reward.Visible = false
        end)
        tween:Play()
    end)
end

local v223

local function complete(p79) -- line: 1302
    -- upvalues: Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), id (ref), n2 (ref), v33 (ref), v38 (ref), destroyAll (copy), popIn (copy), setCounter (copy), celebrate (copy), v223 (ref)
    v223 = p79.show and p79.show.complete or {}
    n2 += 1
    id = nil
    destroyAll(v38)
    v38 = nil

    if p79.goal then
        setCounter(p79.goal, p79.goal)

        if not Counter.Visible then
            popIn(Counter, Pop2, Text2, UIStroke2)
        end
    end

    if v33 then
        celebrate()
    end
end

local function unlock(p80) -- line: 1317
    -- upvalues: PanelFocus (copy), Banner (copy), Text (copy), UIStroke (copy), Pop (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), Sub (copy), Text3 (copy), UIStroke3 (copy), Pop3 (copy), id (ref), n2 (ref), v33 (ref), v39 (ref), goal (ref), setHiddenGuis (copy), collapse (copy), popReward (copy)
    id = nil
    n2 += 1

    local v224 = n2

    setHiddenGuis(nil, v224)
    PanelFocus.Arrive()

    if v33 then
        collapse(Banner, Pop, Text, UIStroke, 0.25)
    end

    collapse(Counter, Pop2, Text2, UIStroke2, 0.25)
    collapse(Sub, Pop3, Text3, UIStroke3, 0.25)
    task.delay(0.25, function() -- line: 1326
        -- upvalues: v224 (copy), Banner (copy), Pop (copy), Counter (copy), Pop2 (copy), Sub (copy), Pop3 (copy), n2 (ref), v33 (ref), v39 (ref), goal (ref)
        if n2 ~= v224 then
            return
        end

        Banner.Visible = false
        Counter.Visible = false
        Sub.Visible = false
        Pop.Scale = 1
        Pop2.Scale = 1
        Pop3.Scale = 1
        v33 = false
        v39 = nil
        goal = nil
    end)
    popReward(p80)
end

local t35 = {
    bait = {
        {
            gui = "BaitGui",
            attr = "QuestBait"
        },
        {
            gui = "SideButtons",
            under = "BaitSlot",
            button = "Button"
        }
    },
    bonzo = {
        {
            gui = "BonzoBaitsUI",
            attr = "QuestCraft"
        },
        {
            gui = "BonzoBaitsUI",
            attr = "QuestGo"
        },
        {
            gui = "BonzoTalkUI",
            attr = "QuestReply"
        },
        {
            gui = "BonzoPromptUI",
            button = "TapTarget"
        }
    }
}
local t36 = {
    bait = {
        {
            gui = "BaitGui",
            attr = "QuestBait"
        }
    }
}

local function questPointer() -- line: 1356
    -- upvalues: LocalPlayer (copy), id (ref), n2 (ref), keepGuiPointer (copy), keepPadFocus (copy), t35 (copy), t36 (copy)
    if id then
        return
    end

    n2 += 1

    local v225 = LocalPlayer:GetAttribute("QuestPointer") or ""
    local v226 = t35[v225]

    if v226 then
        keepGuiPointer(v226, n2)
    end

    if t36[v225] then
        keepPadFocus({
            guiPointer = t36[v225]
        }, n2)
    end
end

LocalPlayer:GetAttributeChangedSignal("QuestPointer"):Connect(questPointer)
TutorialUpdate.OnClientEvent:Connect(function(p81, p82) -- line: 1366
    -- upvalues: LocalPlayer (copy), Banner (copy), Text (copy), UIStroke (copy), Pop (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), Sub (copy), Text3 (copy), UIStroke3 (copy), Pop3 (copy), id (ref), v33 (ref), v39 (ref), goal (ref), id2 (ref), n4 (ref), setCounter (copy), show (copy), hide (copy), collapse (copy), holdForQuip (copy), v223 (ref), complete (copy), unlock (copy)
    local holdLock, v227

    if p81 == "Show" and type(p82) == "table" and p82.show then
        local holdLock2 = p82.show.holdLock

        if holdLock2 then
            holdLock = holdLock2
            v227 = true
        else
            v227 = false
        end
    else
        v227 = false
    end

    if not v227 then
        holdLock = nil
    end

    LocalPlayer:SetAttribute("TutorialHoldLock", holdLock)

    if p81 == "Complete" and type(p82) == "table" then
        id2 = nil
        n4 += 1
        complete(p82)
    elseif p81 == "Hide" and v223 then
        local v228 = v223

        v223 = nil
        id2 = nil
        n4 += 1
        unlock(v228)
    elseif p81 ~= "Show" or type(p82) ~= "table" then
        if p81 == "Hide" then
            id2 = nil
            n4 += 1
            hide()
        end
    elseif p82.id ~= id2 then
        if p82.show and p82.show.namedQuip and p82.id ~= id and p82.info and p82.info.name then
            holdForQuip(p82)
        else
            local v229, v230

            if not p82.show or not p82.show.afterCatchCard or p82.id == id then
                v230 = true
            elseif LocalPlayer:GetAttribute("CatchCardInFlight") then
                id2 = p82.id
                n4 += 1
                v229 = n4

                if goal then
                    setCounter(goal, goal)
                end

                v230 = false
            else
                v230 = true
            end

            if not v230 then
                local spawn = task.spawn
                local v231 = v229

                spawn(function() -- line: 1110
                    -- upvalues: p82 (copy), v231 (copy), LocalPlayer (copy), Banner (copy), Text (copy), UIStroke (copy), Pop (copy), Counter (copy), Text2 (copy), UIStroke2 (copy), Pop2 (copy), Sub (copy), Text3 (copy), UIStroke3 (copy), Pop3 (copy), v33 (ref), v39 (ref), id2 (ref), n4 (ref), show (copy), collapse (copy)
                    local elapsed = os.clock()

                    while n4 == v231 and LocalPlayer:GetAttribute("CatchCardInFlight") and not LocalPlayer:GetAttribute("CatchCardFlying") and os.clock() - elapsed < 4 do
                        task.wait()
                    end

                    if n4 ~= v231 then
                        return
                    end

                    local v232 = tonumber(LocalPlayer:GetAttribute("CatchCardFlying")) or 0.4

                    if v33 then
                        collapse(Banner, Pop, Text, UIStroke, v232)
                    end

                    collapse(Counter, Pop2, Text2, UIStroke2, v232)
                    collapse(Sub, Pop3, Text3, UIStroke3, v232)

                    local elapsed2 = os.clock()

                    while n4 == v231 and LocalPlayer:GetAttribute("CatchCardInFlight") and os.clock() - elapsed2 < 2 do
                        task.wait()
                    end

                    if n4 ~= v231 then
                        return
                    end

                    id2 = nil
                    Banner.Visible = false
                    Counter.Visible = false
                    Sub.Visible = false
                    Pop.Scale = 1
                    Pop2.Scale = 1
                    Pop3.Scale = 1
                    v33 = false
                    v39 = nil
                    show(p82)
                end)
            else
                id2 = nil
                n4 += 1
                show(p82)
            end
        end
    end
end)
TutorialAction:FireServer("Ready")

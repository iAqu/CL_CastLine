-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local ButtonHover = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ButtonHover"))
local _require = require
local ok, result = pcall(_require, ReplicatedStorage:WaitForChild("Purse"))
local Funnel = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Funnel"))
local InputMode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode"))
local HudFit = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HudFit"))
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer
local Dive = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DiveGui"):WaitForChild("Dive")
local HarpoonDive = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HarpoonDive")
local Plots = workspace:WaitForChild("Plots")
local _ = {
    FROM = 0.35,
    IN_TIME = 0.22,
    OUT_TIME = 0.15,
    IN_SOUND = "PanelOpen",
    OUT_SOUND = "PanelClose"
}
local v1 = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In)

ButtonHover.Attach(Dive, {
    shine = false,
    highlight = true
})

local HoverScale = Dive:WaitForChild("HoverScale")
local v3 = false
local v4
local t1 = {}
local ProximityPromptService = game:GetService("ProximityPromptService")
local PadWorldPrompt = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PadWorldPrompt"))

local function xPromptUp() -- line: 55
    -- upvalues: t1 (copy), PadWorldPrompt (copy)
    if next(t1) == nil then
        return (PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX))
    end

    return true
end

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "PadKey"
ImageLabel.BackgroundTransparency = 1
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.fromScale(0.22, 0.5)
ImageLabel.Size = UDim2.fromScale(1, 0.56)
ImageLabel.ZIndex = Dive.ZIndex + 3

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
UIAspectRatioConstraint.Parent = ImageLabel
ImageLabel.Parent = Dive

local function dressPad() -- line: 69
    -- upvalues: InputMode (copy), t1 (copy), PadWorldPrompt (copy), ImageLabel (copy)
    ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonX)
    ImageLabel.Visible = InputMode.Pad() and not (next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX))
end

InputMode.Changed:Connect(dressPad)
PadWorldPrompt.Changed:Connect(dressPad)
ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonX)
ImageLabel.Visible = InputMode.Pad() and not (next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX))
ProximityPromptService.PromptShown:Connect(function(p1) -- line: 76
    -- upvalues: InputMode (copy), t1 (copy), PadWorldPrompt (copy), ImageLabel (copy)
    if p1.GamepadKeyCode ~= Enum.KeyCode.ButtonX then
        return
    end

    t1[p1] = true
    ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonX)
    ImageLabel.Visible = InputMode.Pad() and not (next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX))
    p1.PromptHidden:Once(function() -- line: 80
        -- upvalues: p1 (copy), InputMode (copy), t1 (copy), PadWorldPrompt (copy), ImageLabel (copy)
        t1[p1] = nil
        ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonX)
        ImageLabel.Visible = InputMode.Pad() and not (next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX))
    end)
end)

local function bindPad(p2) -- line: 87
    -- upvalues: ContextActionService (copy), v4 (ref), t1 (copy), PadWorldPrompt (copy)
    if p2 then
        ContextActionService:BindActionAtPriority("PadDive", function(_, p4) -- line: 89
            -- upvalues: v4 (ref), t1 (copy), PadWorldPrompt (copy)
            if next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX) then
                return Enum.ContextActionResult.Pass
            end

            if p4 == Enum.UserInputState.Begin and v4 then
                v4()
            end

            return Enum.ContextActionResult.Sink
        end, false, 3000, Enum.KeyCode.ButtonX)
    else
        ContextActionService:UnbindAction("PadDive")
    end
end

local function playSound(p5) -- line: 101
    -- upvalues: SoundService (copy), LocalPlayer (copy)
    if LocalPlayer:GetAttribute("Cinematic") then
        return
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v9 = HarpoonSFX and HarpoonSFX:FindFirstChild(p5)

    if v9 then
        v9:Play()
    end
end

local v10 = UDim2.fromScale(0.425, 0.175)
local DiveParent = Dive.Parent
local Leave = DiveParent:WaitForChild("Leave")
local SpaceHint = DiveParent:WaitForChild("SpaceHint")
local Fire = DiveParent:WaitForChild("Fire")
local FeedSlot = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SideButtons"):WaitForChild("FeedSlot")

if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
    Dive.Size = v10
    Leave.Size = UDim2.fromScale(v10.X.Scale * 0.6, v10.Y.Scale * 0.6)
end

local Hotbar

local function unscaledHalf(p6) -- line: 149
    local UIScale = p6:FindFirstChildOfClass("UIScale")
    local Scale = UIScale and UIScale.Scale or 1

    return p6.AbsoluteSize.Y / math.max(Scale, 0.01) / 2
end

local function hotbarShowing() -- line: 158
    -- upvalues: Hotbar (ref)
    if not Hotbar then
        return false
    end

    for _, child in ipairs(Hotbar:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            return true
        end
    end

    return false
end

local function place() -- line: 165
    -- upvalues: HudFit (copy), Dive (copy), DiveParent (copy), Leave (copy), SpaceHint (copy), Fire (copy), FeedSlot (copy), Hotbar (ref), hotbarShowing (copy)
    if not Hotbar then
        return
    end

    local v11 = 0.93 * DiveParent.AbsoluteSize.Y
    local v12 = if hotbarShowing() then math.min(v11, Hotbar.AbsolutePosition.Y - DiveParent.AbsolutePosition.Y - 0.012 * DiveParent.AbsoluteSize.Y) else v11
    local new = UDim2.new
    local UIScale = Dive:FindFirstChildOfClass("UIScale")
    local Scale = UIScale and UIScale.Scale or 1

    Dive.Position = new(0.5, 0, 0, v12 - Dive.AbsoluteSize.Y / math.max(Scale, 0.01) / 2)

    local new2 = UDim2.new
    local v14 = 0.985 * DiveParent.AbsoluteSize.Y
    local UIScale2 = Leave:FindFirstChildOfClass("UIScale")
    local Scale2 = UIScale2 and UIScale2.Scale or 1

    Leave.Position = new2(0.5, 0, 0, v14 - Leave.AbsoluteSize.Y / math.max(Scale2, 0.01) / 2)

    local FeedSlotParent = FeedSlot.Parent
    local v17 = math.min(FeedSlot.Size.X.Scale * FeedSlotParent.AbsoluteSize.X, FeedSlot.Size.Y.Scale * FeedSlotParent.AbsoluteSize.Y * HudFit.Factor(FeedSlotParent.AbsoluteSize.X, FeedSlotParent.AbsoluteSize.Y))
    local v18 = FeedSlotParent.AbsolutePosition.X - DiveParent.AbsolutePosition.X + FeedSlot.Position.X.Scale * FeedSlotParent.AbsoluteSize.X - v17
    local v19 = 0.9 * DiveParent.AbsoluteSize.X
    local UIScale3 = Fire:FindFirstChildOfClass("UIScale")
    local Scale3 = UIScale3 and UIScale3.Scale or 1
    local v21 = math.min(v19, v18 - Fire.AbsoluteSize.Y / math.max(Scale3, 0.01) / 2)
    local new3 = UDim2.new
    local UIScale4 = Fire:FindFirstChildOfClass("UIScale")
    local Scale4 = UIScale4 and UIScale4.Scale or 1

    Fire.Position = new3(0, v21, 0, v11 - Fire.AbsoluteSize.Y / math.max(Scale4, 0.01) / 2)

    local UIScale5 = SpaceHint:FindFirstChildOfClass("UIScale")
    local Scale5 = UIScale5 and UIScale5.Scale or 1
    local v22 = SpaceHint.AbsoluteSize.Y / math.max(Scale5, 0.01) / 2

    SpaceHint.Position = UDim2.new(0.5, 0, 0, v11 - 1.32 * v22 + v22)
end

task.spawn(function() -- line: 183
    -- upvalues: LocalPlayer (copy), DiveParent (copy), Hotbar (ref), place (copy)
    Hotbar = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BackpackGui"):WaitForChild("Backpack"):WaitForChild("Hotbar")
    Hotbar:GetPropertyChangedSignal("AbsolutePosition"):Connect(place)
    Hotbar:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
    DiveParent:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)

    local function watchSlot(p7) -- line: 189
        -- upvalues: place (copy)
        if p7:IsA("GuiObject") then
            p7:GetPropertyChangedSignal("Visible"):Connect(place)
        end
    end

    for _, child in ipairs(Hotbar:GetChildren()) do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(place)
        end
    end

    Hotbar.ChildAdded:Connect(function(p8) -- line: 193
        -- upvalues: place (copy)
        if p8:IsA("GuiObject") then
            p8:GetPropertyChangedSignal("Visible"):Connect(place)
        end

        place()
    end)
    Hotbar.ChildRemoved:Connect(place)
    place()
end)

local _ = {
    GROW = 1.6,
    TIME = 0.28
}
local v23 = false
local Position
local n1 = (-1e999)

local function hotbarCollapse() -- line: 208
    -- upvalues: TweenService (copy), ok (copy), result (copy), Hotbar (ref), v23 (ref), Position (ref)
    if not Hotbar or v23 then
        return
    end

    v23 = true
    Position = Hotbar.Position

    local v24 = UDim2.new(Position.X.Scale, Position.X.Offset, 1, Hotbar.AbsoluteSize.Y)

    TweenService:Create(Hotbar, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = v24
    }):Play()

    if ok and result.IsOpen and result.OpenClose then
        result.OpenClose()
    end
end

local function hotbarReturn() -- line: 216
    -- upvalues: TweenService (copy), Hotbar (ref), v23 (ref), Position (ref)
    if Hotbar and v23 then
        v23 = false
        TweenService:Create(Hotbar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = Position
        }):Play()
    end
end

local function growAway() -- line: 221
    -- upvalues: TweenService (copy), ContextActionService (copy), Dive (copy), HoverScale (copy), v3 (ref), n1 (ref)
    if not v3 then
        return
    end

    v3 = false
    ContextActionService:UnbindAction("PadDive")
    n1 = os.clock()

    local v25 = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Text = Dive:FindFirstChild("Text")
    local UIStroke = Text and Text:FindFirstChildOfClass("UIStroke")
    local t2 = {
        TweenService:Create(HoverScale, v25, {
            Scale = 1.6
        }),
        TweenService:Create(Dive, v25, {
            ImageTransparency = 1
        })
    }

    if Text then
        table.insert(t2, TweenService:Create(Text, v25, {
            TextTransparency = 1
        }))
    end

    if UIStroke then
        table.insert(t2, TweenService:Create(UIStroke, v25, {
            Transparency = 1
        }))
    end

    t2[#t2].Completed:Once(function() -- line: 237
        -- upvalues: Text (copy), UIStroke (copy), Dive (copy), HoverScale (copy), v3 (ref)
        Dive.ImageTransparency = 0

        if Text then
            Text.TextTransparency = 0
        end

        if UIStroke then
            UIStroke.Transparency = 0
        end

        if not v3 then
            Dive.Visible = false
            HoverScale.Scale = 1
        end
    end)

    for _, v26 in ipairs(t2) do
        v26:Play()
    end
end

local function show() -- line: 249
    -- upvalues: TweenService (copy), SoundService (copy), Funnel (copy), ContextActionService (copy), LocalPlayer (copy), Dive (copy), v1 (copy), HoverScale (copy), v3 (ref), v4 (ref), t1 (copy), PadWorldPrompt (copy)
    if v3 then
        return
    end

    v3 = true
    ContextActionService:BindActionAtPriority("PadDive", function(_, p10) -- line: 89
        -- upvalues: v4 (ref), t1 (copy), PadWorldPrompt (copy)
        if next(t1) ~= nil or PadWorldPrompt.KeyShown(Enum.KeyCode.ButtonX) then
            return Enum.ContextActionResult.Pass
        end

        if p10 == Enum.UserInputState.Begin and v4 then
            v4()
        end

        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.ButtonX)
    HoverScale.Scale = 0.35
    Dive.Visible = true
    Funnel.Report("dive_button")

    if not LocalPlayer:GetAttribute("Cinematic") then
        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local PanelOpen = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelOpen")

        if PanelOpen then
            PanelOpen:Play()
        end
    end

    TweenService:Create(HoverScale, v1, {
        Scale = 1
    }):Play()
end

local function hide() -- line: 260
    -- upvalues: TweenService (copy), SoundService (copy), ContextActionService (copy), LocalPlayer (copy), Dive (copy), v2 (copy), HoverScale (copy), v3 (ref)
    if not v3 then
        return
    end

    v3 = false
    ContextActionService:UnbindAction("PadDive")

    if not LocalPlayer:GetAttribute("Cinematic") then
        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local PanelClose = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelClose")

        if PanelClose then
            PanelClose:Play()
        end
    end

    local tween = TweenService:Create(HoverScale, v2, {
        Scale = 0.35
    })

    tween.Completed:Once(function() -- line: 266
        -- upvalues: Dive (copy), v3 (ref)
        if not v3 then
            Dive.Visible = false
        end
    end)
    tween:Play()
end

local function myHarpoon() -- line: 270
    -- upvalues: LocalPlayer (copy), Plots (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child:FindFirstChild("Harpoon")
        end
    end

    return nil
end

local function nearMyChair() -- line: 279
    -- upvalues: LocalPlayer (copy), myHarpoon (copy)
    local v27 = myHarpoon()
    local StandPoint = v27 and v27:FindFirstChild("StandPoint")
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if StandPoint and HumanoidRootPart and (v27:GetAttribute("OccupantUserId") or 0) == 0 then
        return (HumanoidRootPart.Position - StandPoint.Position).Magnitude <= 20
    end

    return false
end

local n2 = 0

RunService.Heartbeat:Connect(function(p11) -- line: 290
    -- upvalues: LocalPlayer (copy), v23 (ref), n1 (ref), hotbarReturn (copy), show (copy), hide (copy), myHarpoon (copy), nearMyChair (copy), n2 (ref)
    n2 += p11

    if n2 < 0.2 then
        return
    end

    n2 = 0

    local v28 = os.clock() - n1 > 1.5
    local v29 = string.find("," .. (LocalPlayer:GetAttribute("TutorialHides") or "") .. ",", ",DiveGui.Dive,", 1, true) ~= nil
        or LocalPlayer:GetAttribute("GroupRewardOpen") == true
        or LocalPlayer:GetAttribute("BonzoTalking") == true
        or LocalPlayer:GetAttribute("PumpkinTalking") == true
        or LocalPlayer:GetAttribute("TurkeyTalking") == true
        or LocalPlayer:GetAttribute("CaptainTalking") == true
        or LocalPlayer:GetAttribute("PanelOpen") == true
        or LocalPlayer:GetAttribute("AdminHold") == true

    if not nearMyChair() or v29 then
        hide()
    elseif v28 then
        show()
    end

    if v23 and v28 then
        local v30 = myHarpoon()

        if not v30 or (v30:GetAttribute("OccupantUserId") or 0) ~= LocalPlayer.UserId then
            hotbarReturn()
        end
    end
end)
LocalPlayer:GetAttributeChangedSignal("GroupRewardOpen"):Connect(function() -- line: 326
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("BonzoTalking"):Connect(function() -- line: 327
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("PumpkinTalking"):Connect(function() -- line: 328
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("TurkeyTalking"):Connect(function() -- line: 329
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("CaptainTalking"):Connect(function() -- line: 330
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("PanelOpen"):Connect(function() -- line: 331
    -- upvalues: n2 (ref)
    n2 = 0.2
end)
LocalPlayer:GetAttributeChangedSignal("AdminHold"):Connect(function() -- line: 332
    -- upvalues: n2 (ref)
    n2 = 0.2
end)

v4 = function() -- line: 334
    -- upvalues: LocalPlayer (copy), HarpoonDive (copy), v3 (ref), hotbarCollapse (copy), growAway (copy), nearMyChair (copy)
    if nearMyChair() and v3 and not LocalPlayer:GetAttribute("GroupRewardOpen") and not LocalPlayer:GetAttribute("PanelOpen") and not LocalPlayer:GetAttribute("BonzoTalking") and not LocalPlayer:GetAttribute("PumpkinTalking") and not LocalPlayer:GetAttribute("TurkeyTalking") and not LocalPlayer:GetAttribute("CaptainTalking") and not LocalPlayer:GetAttribute("AdminHold") then
        growAway()
        hotbarCollapse()
        HarpoonDive:FireServer()
    end
end

Dive.Activated:Connect(v4)
LocalPlayer:GetAttributeChangedSignal("AutoDive"):Connect(function() -- line: 347
    -- upvalues: LocalPlayer (copy), n1 (ref), hotbarCollapse (copy), growAway (copy)
    if not LocalPlayer:GetAttribute("AutoDive") then
        return
    end

    growAway()
    n1 = os.clock()
    hotbarCollapse()
end)
require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ImageWarm")).KeepAll(Dive.Parent)

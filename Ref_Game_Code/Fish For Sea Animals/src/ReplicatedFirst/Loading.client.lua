-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(44, 45, 50)
local v2 = Color3.fromRGB(30, 30, 36)
local v3 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "Loading"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ScreenInsets = Enum.ScreenInsets.None
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000

local Frame = Instance.new("Frame")

Frame.Name = "Background"
Frame.BackgroundColor3 = v1
Frame.BorderSizePixel = 0
Frame.Size = UDim2.fromScale(1, 1)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Percent"
TextLabel.BackgroundTransparency = 1
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.fromScale(0.5, 0.5)
TextLabel.Size = UDim2.fromScale(0.3, 0.09)
TextLabel.FontFace = v3
TextLabel.TextScaled = true
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Text = "0%"

local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 5
UIStroke.Color = v2
UIStroke.Parent = TextLabel

local UIScale = Instance.new("UIScale")

UIScale.Parent = TextLabel
TextLabel.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Name = "Skip"
TextButton.BackgroundTransparency = 1
TextButton.AnchorPoint = Vector2.new(1, 1)
TextButton.Position = UDim2.new(1, -28, 1, -24)
TextButton.Size = UDim2.fromScale(0.14, 0.06)
TextButton.FontFace = v3
TextButton.TextScaled = true
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextTransparency = 1
TextButton.TextXAlignment = Enum.TextXAlignment.Right
TextButton.Text = "SKIP ⏩"
TextButton.AutoButtonColor = false
TextButton.Visible = false

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Thickness = 3.5
UIStroke2.Color = v2
UIStroke2.Transparency = 1
UIStroke2.Parent = TextButton

local UISizeConstraint = Instance.new("UISizeConstraint")

UISizeConstraint.MinSize = Vector2.new(100, 30)
UISizeConstraint.MaxSize = Vector2.new(200, 48)
UISizeConstraint.Parent = TextButton

local UIScale2 = Instance.new("UIScale")

UIScale2.Parent = TextButton
TextButton.Parent = Frame

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
ScreenGui.Parent = PlayerGui
ReplicatedFirst:RemoveDefaultLoadingScreen()

local n1 = 0
local n2 = 0
local n3 = -1
local elapsed = os.clock()
local v4 = false

local function relabel(p1) -- line: 98
    -- upvalues: TextButton (copy)
    TextButton.Text = p1.Name:find("^Gamepad") and "SKIP (X)" or "SKIP ⏩"
end

TextButton.Text = UserInputService:GetLastInputType().Name:find("^Gamepad") and "SKIP (X)" or "SKIP ⏩"

local function skip() -- line: 103
    -- upvalues: TweenService (copy), TextButton (copy), UIStroke2 (copy), n1 (ref), n2 (ref), v4 (ref)
    if v4 or n1 >= 100 or not TextButton.Visible then
        return
    end

    v4 = true
    n1 = 100
    n2 = 100
    TextButton.Active = false
    TweenService:Create(TextButton, TweenInfo.new(0.15), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke2, TweenInfo.new(0.15), {
        Transparency = 1
    }):Play()
end

local t1 = {
    TextButton.Activated:Connect(skip),
    UserInputService.LastInputTypeChanged:Connect(relabel),
    UserInputService.InputBegan:Connect(function(p2) -- line: 117
        -- upvalues: skip (copy)
        if p2.KeyCode == Enum.KeyCode.ButtonX then
            skip()
        end
    end),
    TextButton.MouseEnter:Connect(function() -- line: 122
        -- upvalues: TweenService (copy), UIScale2 (copy)
        TweenService:Create(UIScale2, TweenInfo.new(0.12), {
            Scale = 1.08
        }):Play()
    end),
    TextButton.MouseLeave:Connect(function() -- line: 125
        -- upvalues: TweenService (copy), UIScale2 (copy)
        TweenService:Create(UIScale2, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)
}

task.delay(1.5, function() -- line: 130
    -- upvalues: TweenService (copy), ScreenGui (copy), TextButton (copy), UIStroke2 (copy), n1 (ref), v4 (ref)
    if v4 or n1 >= 100 or not ScreenGui.Parent then
        return
    end

    TextButton.Visible = true

    local v5 = TweenInfo.new(0.35, Enum.EasingStyle.Sine)

    TweenService:Create(TextButton, v5, {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke2, v5, {
        Transparency = 0
    }):Play()
end)

local connection = RunService.Heartbeat:Connect(function(p3) -- line: 142
    -- upvalues: TweenService (copy), TextLabel (copy), UIScale (copy), n1 (ref), n2 (ref), n3 (ref), elapsed (copy)
    n2 += (n1 - n2) * math.min(1, p3 * 12)

    if n1 - n2 < 0.3 then
        n2 = n1
    end

    local v10 = math.floor(n2)

    if v10 ~= n3 then
        n3 = v10
        TextLabel.Text = ("%*%%"):format(v10)
        UIScale.Scale = 1.07
        TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play()
    end

    local v11 = os.clock() - elapsed
    local v13 = (1 - math.cos(v11 * 3)) / 2

    TextLabel.Position = UDim2.new(0.5, 0, 0.5, -v13 * 14)
    TextLabel.Rotation = math.sin(v11 * 1.5) * 1.5
end)

local function preloadAll(p4, p5, p6) -- line: 169
    -- upvalues: ContentProvider (copy), n1 (ref), elapsed (copy), v4 (ref)
    local v15 = #p4
    local n4 = 0

    for _, v16 in p4 do
        task.spawn(function() -- line: 172
            -- upvalues: p5 (copy), p6 (copy), v15 (copy), n4 (ref), v16 (copy), ContentProvider (copy), n1 (ref), v4 (ref)
            local PreloadAsync = ContentProvider.PreloadAsync
            local t2 = {
                v16
            }

            pcall(PreloadAsync, ContentProvider, t2)
            n4 += 1

            local v17 = p5 + (p6 - p5) * n4 / v15

            if not v4 then
                n1 = math.max(n1, v17)
            end
        end)
    end

    while n4 < v15 and not v4 and os.clock() < elapsed + 5 do
        task.wait()
    end

    if not v4 then
        n1 = math.max(n1, p6)
    end
end

local function needsIntro(p7) -- line: 185
    -- upvalues: LocalPlayer (copy)
    local v20 = os.clock() + 2

    while LocalPlayer:GetAttribute("Tutorial") == nil and os.clock() < v20 do
        task.wait()
    end

    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    if Tutorial ~= nil and p7 then
        return Tutorial < p7.TutorialDone and LocalPlayer:GetAttribute("CutsceneSeen") == false
    end

    return true
end

local v22 = false

task.spawn(function() -- line: 198
    -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), LocalPlayer (copy), n1 (ref), v4 (ref), preloadAll (copy), needsIntro (copy), v22 (ref)
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    if not v4 then
        n1 = math.max(n1, 30)
    end

    local _require = require
    local Shared = ReplicatedStorage:WaitForChild("Shared")
    local ok, result = pcall(_require, Shared:WaitForChild("Config"))
    local World1 = workspace:WaitForChild("Map"):WaitForChild("World1")
    local t3 = {
        World1:WaitForChild("FishingDock"),
        World1:WaitForChild("Base")
    }
    local Animals = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("Animals")
    local A_CosmicGreatWhite = Animals and Animals:FindFirstChild("A_CosmicGreatWhite")

    if A_CosmicGreatWhite then
        table.insert(t3, A_CosmicGreatWhite)
    end

    if ok then
        for _, v24 in result.Sounds do
            local Sound = Instance.new("Sound")

            Sound.SoundId = v24
            table.insert(t3, Sound)
        end
    end

    local v25 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    if not ok or not result then
        result = nil
    end

    if needsIntro(result) then
        table.insert(t3, v25)
        preloadAll(t3, 30, 100)
    else
        task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, t3)
        preloadAll({ v25 }, 30, 100)
    end

    v22 = true
end)

while not v22 and not v4 do
    task.wait()
end

n1 = 100

if TextButton.Visible and not v4 then
    TextButton.Active = false
    TweenService:Create(TextButton, TweenInfo.new(0.2), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke2, TweenInfo.new(0.2), {
        Transparency = 1
    }):Play()
end

while n2 < 100 do
    RunService.Heartbeat:Wait()
end

task.wait(0.05)
LocalPlayer:SetAttribute("Loaded", true)

local v26 = os.clock() + (if v4 then 3 else 6)

while not LocalPlayer:GetAttribute("IntroReady") and os.clock() < v26 do
    task.wait(0.05)
end

local v27 = TweenInfo.new(0.3, Enum.EasingStyle.Sine)

TweenService:Create(Frame, v27, {
    BackgroundTransparency = 1
}):Play()
TweenService:Create(TextLabel, v27, {
    TextTransparency = 1
}):Play()
TweenService:Create(UIStroke, v27, {
    Transparency = 1
}):Play()
task.wait(0.32)
connection:Disconnect()

for _, v28 in t1 do
    v28:Disconnect()
end

ScreenGui:Destroy()

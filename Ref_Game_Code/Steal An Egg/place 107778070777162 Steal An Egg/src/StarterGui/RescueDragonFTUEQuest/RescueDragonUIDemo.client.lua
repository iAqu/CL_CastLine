-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local _ = {
    QuestsPerSet = 3,
    GoNowStepTime = 0.22,
    GoNowSteps = 6,
    AutoClaimDelay = 0.45,
    SetSwapDelay = 0.35,
    OpenOnStart = true
}
local t1 = {
    "Steal 1x Egg from Desert Zone",
    "Hatch a Scorpion",
    "Steal 10x Eggs",
    "Hatch a Desert Drake",
    "Win 3x Zone Battles",
    "Steal 25x Eggs",
    "Reach Level 10",
    "Hatch a Legendary",
    "Steal 50x Eggs",
    "Unlock the Volcano Zone",
    "Hatch 5x Rare Pets",
    "Steal 100x Eggs"
}
local t2 = {
    1, 1, 10
}
local Parent = script.Parent
local RescueDragonAPI = Parent:WaitForChild("RescueDragonAPI")

local function event(p1) -- line: 47
    -- upvalues: RescueDragonAPI (copy)
    return RescueDragonAPI:WaitForChild(p1)
end

local Open = RescueDragonAPI:WaitForChild("Open")
local Close = RescueDragonAPI:WaitForChild("Close")
local LoadQuestSet = RescueDragonAPI:WaitForChild("LoadQuestSet")
local SetQuest = RescueDragonAPI:WaitForChild("SetQuest")
local ClaimQuest = RescueDragonAPI:WaitForChild("ClaimQuest")
local ResetAll = RescueDragonAPI:WaitForChild("ResetAll")
local ClaimClicked = RescueDragonAPI:WaitForChild("ClaimClicked")
local GoNowClicked = RescueDragonAPI:WaitForChild("GoNowClicked")
local CloseClicked = RescueDragonAPI:WaitForChild("CloseClicked")
local LockUnlocked = RescueDragonAPI:WaitForChild("LockUnlocked")
local AllLocksUnlocked = RescueDragonAPI:WaitForChild("AllLocksUnlocked")
local FTUEQuestMain = Parent:WaitForChild("FTUEQuestMain")
local v1 = (function() -- countLocks | line: 70
    -- upvalues: FTUEQuestMain (copy)
    local n1 = 0

    for _, child in ipairs(FTUEQuestMain:GetChildren()) do
        if child.Name:match("^Lock%d+$") then
            n1 += 1
        end
    end

    return n1
end)()
local t3 = {
    setIndex = 1,
    menuOpen = false,
    autoFinishing = false,
    sets = {},
    busyRows = {}
}

local function buildSets() -- line: 90
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), t3 (copy)
    t3.sets = {}

    for i = 1, v1 do
        local t4 = {}

        for j = 1, 3 do
            t4[j] = {
                Current = 0,
                State = "InProgress",
                Title = t1[((i - 1) * 3 + j - 1) % #t1 + 1],
                Goal = t2[(j - 1) % #t2 + 1]
            }
        end

        t3.sets[i] = t4
    end
end

local function currentSet() -- line: 107
    -- upvalues: t3 (copy)
    return t3.sets[t3.setIndex]
end

local function loadCurrentSet() -- line: 111
    -- upvalues: LoadQuestSet (copy), t3 (copy)
    local v2 = t3.sets[t3.setIndex]

    if v2 then
        LoadQuestSet:Fire(v2)
    end
end

local function startDemo(p2) -- line: 118
    -- upvalues: Open (copy), LoadQuestSet (copy), ResetAll (copy), t3 (copy), buildSets (copy)
    buildSets()
    t3.setIndex = 1
    t3.autoFinishing = false
    t3.busyRows = {}
    ResetAll:Fire()

    local v3 = t3.sets[t3.setIndex]

    if v3 then
        LoadQuestSet:Fire(v3)
    end

    if p2 then
        Open:Fire()
        t3.menuOpen = true
    end
end

local function runQuestProgress(p3) -- line: 132
    -- upvalues: SetQuest (copy), t3 (copy)
    local v4 = t3.sets[t3.setIndex]
    local v5 = v4 and v4[p3]

    if not v5 or v5.State ~= "InProgress" or t3.busyRows[p3] then
        return
    end

    t3.busyRows[p3] = true

    local v8 = math.max(1, (math.ceil(v5.Goal / 6)))

    while v5.Current < v5.Goal do
        v5.Current = math.min(v5.Current + v8, v5.Goal)
        SetQuest:Fire(p3, {
            Current = v5.Current,
            Goal = v5.Goal
        })
        task.wait(0.22)
    end

    v5.State = "Claimable"
    SetQuest:Fire(p3, {
        State = "Claimable",
        Current = v5.Current,
        Goal = v5.Goal
    })
    t3.busyRows[p3] = nil
end

local function claim(p4) -- line: 153
    -- upvalues: ClaimQuest (copy), t3 (copy)
    local v10 = t3.sets[t3.setIndex]
    local v11 = v10 and v10[p4]

    if v11 and v11.State ~= "Claimed" then
        v11.Current = v11.Goal
        v11.State = "Claimed"
        ClaimQuest:Fire(p4)
    end
end

local function finishCurrentSet() -- line: 168
    -- upvalues: ClaimQuest (copy), t3 (copy)
    local v12 = t3.sets[t3.setIndex]

    if v12 then
        for v13, v14 in ipairs(v12) do
            if v14.State ~= "Claimed" then
                local v15 = t3.sets[t3.setIndex]
                local v16 = v15 and v15[v13]

                if v16 and v16.State ~= "Claimed" then
                    v16.Current = v16.Goal
                    v16.State = "Claimed"
                    ClaimQuest:Fire(v13)
                end

                task.wait(0.45)
            end
        end
    end
end

GoNowClicked.Event:Connect(function(p5) -- line: 186
    -- upvalues: runQuestProgress (copy)
    task.spawn(runQuestProgress, p5)
end)
ClaimClicked.Event:Connect(function(p6) -- line: 190
    -- upvalues: ClaimQuest (copy), t3 (copy)
    local v17 = t3.sets[t3.setIndex]
    local v18 = v17 and v17[p6]

    if not v18 or v18.State == "Claimed" then
        return
    end

    v18.Current = v18.Goal
    v18.State = "Claimed"
    ClaimQuest:Fire(p6)
end)
CloseClicked.Event:Connect(function() -- line: 194
    -- upvalues: t3 (copy)
    t3.menuOpen = false
end)
LockUnlocked.Event:Connect(function() -- line: 198
    -- upvalues: LoadQuestSet (copy), t3 (copy), finishCurrentSet (copy)
    if t3.setIndex >= #t3.sets then
        return
    end

    t3.setIndex += 1
    task.wait(0.35)

    local v19 = t3.sets[t3.setIndex]

    if v19 then
        LoadQuestSet:Fire(v19)
    end

    if t3.autoFinishing then
        task.wait(0.35)
        finishCurrentSet()
    end
end)
AllLocksUnlocked.Event:Connect(function() -- line: 213
    -- upvalues: t3 (copy)
    t3.autoFinishing = false
    print("[RescueDragonUIDemo] All locks unlocked - dragon freed.")
end)

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "RescueDragonDemoControls"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 1000
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Name = "Panel"
Frame.AnchorPoint = Vector2.new(0, 1)
Frame.Position = UDim2.new(0, 16, 1, -16)
Frame.Size = UDim2.fromOffset(220, 148)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Title"
TextLabel.LayoutOrder = 0
TextLabel.Size = UDim2.new(1, 0, 0, 18)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(150, 150, 175)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Text = "RESCUE DRAGON - UI DEMO"
TextLabel.Parent = Frame

local function makeButton(p7, p8, p9, p10) -- line: 271
    -- upvalues: TweenService (copy), Frame (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p8:gsub("%s", "")
    TextButton.LayoutOrder = p7
    TextButton.Size = UDim2.new(1, 0, 0, 30)
    TextButton.BackgroundColor3 = p9
    TextButton.BorderSizePixel = 0
    TextButton.AutoButtonColor = false
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 13
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.Text = p8
    TextButton.Parent = Frame

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = TextButton

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton

    local function tweenScale(p11) -- line: 292
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = p11
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 298
        -- upvalues: tweenScale (copy)
        tweenScale(1.04)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 301
        -- upvalues: tweenScale (copy)
        tweenScale(1)
    end)
    TextButton.MouseButton1Down:Connect(function() -- line: 304
        -- upvalues: tweenScale (copy)
        tweenScale(0.95)
    end)
    TextButton.MouseButton1Up:Connect(function() -- line: 307
        -- upvalues: tweenScale (copy)
        tweenScale(1.04)
    end)
    TextButton.MouseButton1Click:Connect(function() -- line: 310
        -- upvalues: p10 (copy)
        task.spawn(p10)
    end)

    return TextButton
end

makeButton(1, "Reset All State", Color3.fromRGB(60, 64, 92), function() -- line: 317
    -- upvalues: t3 (copy), startDemo (copy)
    startDemo(t3.menuOpen or true)
end)
makeButton(2, "Finish All Quests", Color3.fromRGB(46, 130, 78), function() -- line: 321
    -- upvalues: t3 (copy), finishCurrentSet (copy)
    if not t3.autoFinishing then
        t3.autoFinishing = true
        finishCurrentSet()
    end
end)
makeButton(3, "Toggle Menu", Color3.fromRGB(52, 56, 80), function() -- line: 329
    -- upvalues: Open (copy), Close (copy), t3 (copy)
    if t3.menuOpen then
        Close:Fire()
        t3.menuOpen = false
    else
        Open:Fire()
        t3.menuOpen = true
    end
end)
task.defer(function() -- line: 343
    -- upvalues: Open (copy), LoadQuestSet (copy), ResetAll (copy), t3 (copy), buildSets (copy)
    buildSets()
    t3.setIndex = 1
    t3.autoFinishing = false
    t3.busyRows = {}
    ResetAll:Fire()

    local v20 = t3.sets[t3.setIndex]

    if v20 then
        LoadQuestSet:Fire(v20)
    end

    Open:Fire()
    t3.menuOpen = true
end)

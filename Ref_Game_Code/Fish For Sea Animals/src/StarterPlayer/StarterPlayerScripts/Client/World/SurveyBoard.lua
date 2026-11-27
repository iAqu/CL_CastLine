-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

require(script.Parent.Parent.MiniGames.Kit)

local Style = require(script.Parent.Parent.Shop.Style)
local Menus = require(script.Parent.Parent.UI.Menus)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

local function answered() -- line: 22
    -- upvalues: Config (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute("SurveyDone") == Config.Survey.Id
end

local function tutorialDone() -- line: 26
    -- upvalues: Config (copy), LocalPlayer (copy)
    return (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone
end

local function buildSign(p1) -- line: 31
    -- upvalues: Config (copy), Style (copy), LocalPlayer (copy)
    local SurfaceGui = Instance.new("SurfaceGui")

    SurfaceGui.Name = "Sign"
    SurfaceGui.Face = Enum.NormalId.Front
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui.PixelsPerStud = 50
    SurfaceGui.LightInfluence = 0

    local v1 = Style.card(SurfaceGui, Style.ABYSS, {
        Name = "Card",
        Size = UDim2.fromScale(1, 1)
    })
    local v2 = Style.text(v1, "📋 SURVEY", {
        StrokeThickness = 6,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.06),
        Size = UDim2.fromScale(0.9, 0.3)
    })

    Style.gradient(v2, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))

    local v3 = Style.text(v1, "", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.4),
        Size = UDim2.fromScale(0.86, 0.3)
    })
    local v4 = Style.text(v1, "", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.73),
        Size = UDim2.fromScale(0.8, 0.17),
        TextColor3 = Style.MINT
    })

    SurfaceGui.Parent = p1

    return function() -- line: 58
        -- upvalues: v3 (copy), v4 (copy), Config (copy), LocalPlayer (copy)
        local Survey = Config.Survey

        if LocalPlayer:GetAttribute("SurveyDone") == Config.Survey.Id then
            v3.Text = "✔ Thanks for answering!"
            v4.Text = "We read every answer 💙"
        else
            v3.Text = `{#Survey.Questions} quick questions:\nhelp us pick what's next!`
            v4.Text = ("🎁 FREE 2x %*!"):format(Survey.RewardStat)
        end
    end
end

local t2 = {}

local function setup(p2) -- line: 73
    -- upvalues: Config (copy), Menus (copy), LocalPlayer (copy), buildSign (copy), t2 (copy)
    local v5 = p2:WaitForChild("Board", 15)
    local ProximityPrompt, v6

    if not v5 or not v5:IsA("BasePart") or v5:FindFirstChild("Sign") then
        return
    else
        local v8 = buildSign(v5)
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "PromptSpot"
        Attachment.Position = Vector3.new(0, -v5.Size.Y / 2, -3)
        Attachment.Parent = v5
        ProximityPrompt = Instance.new("ProximityPrompt")
        ProximityPrompt.Name = "SurveyPrompt"
        ProximityPrompt.ActionText = "Take Survey"
        ProximityPrompt.ObjectText = "Survey"
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt.MaxActivationDistance = 5
        ProximityPrompt.RequiresLineOfSight = false
        ProximityPrompt.Triggered:Connect(function() -- line: 90
            -- upvalues: Menus (copy)
            Menus.open("Survey")
        end)
        ProximityPrompt.Parent = Attachment

        local ProximityPrompt2 = ProximityPrompt

        local function refresh() -- line: 94
            -- upvalues: v8 (copy), ProximityPrompt2 (copy), Config (copy), LocalPlayer (copy)
            v8()
            ProximityPrompt2.Enabled = (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone and LocalPlayer:GetAttribute("SurveyDone") ~= Config.Survey.Id
        end

        table.insert(t2, refresh)
        v8()
        v6 = (LocalPlayer:GetAttribute("Tutorial") or 1) >= Config.TutorialDone
    end

    ProximityPrompt.Enabled = v6 and LocalPlayer:GetAttribute("SurveyDone") ~= Config.Survey.Id
end

local function refreshAll() -- line: 102
    -- upvalues: t2 (copy)
    for _, v11 in t2 do
        v11()
    end
end

function t1.init() -- line: 108
    -- upvalues: LocalPlayer (copy), setup (copy), refreshAll (copy)
    LocalPlayer:GetAttributeChangedSignal("SurveyDone"):Connect(refreshAll)
    LocalPlayer:GetAttributeChangedSignal("Tutorial"):Connect(refreshAll)
    workspace.ChildAdded:Connect(function(p3) -- line: 111
        -- upvalues: setup (copy)
        if p3.Name == "SurveyBoard" then
            task.spawn(setup, p3)
        end
    end)

    for _, child in workspace:GetChildren() do
        if child.Name == "SurveyBoard" then
            task.spawn(setup, child)
        end
    end
end

return t1

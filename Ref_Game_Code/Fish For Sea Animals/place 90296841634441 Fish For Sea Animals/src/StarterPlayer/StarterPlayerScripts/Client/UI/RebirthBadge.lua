-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(40, 150, 255)
local v2 = Color3.fromRGB(235, 50, 60)
local v3 = Color3.fromRGB(20, 20, 30)
local Frame, TextLabel
local v4 = false
local v5

local function v6() -- line: 23
    return false
end

local function progress() -- line: 27
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v7 = LocalPlayer:GetAttribute("Rebirths") or 0

    return (math.clamp(math.min((LocalPlayer:GetAttribute("Strength") or 0) / Config.rebirthStrength(v7), (LocalPlayer:GetAttribute("Money") or 0) / Config.rebirthCost(v7)), 0, 1))
end

local function refresh() -- line: 34
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), v2 (copy), Frame (ref), TextLabel (ref), v4 (ref), v5 (ref), v6 (ref), progress (copy)
    local v11 = progress()

    v4 = v11 >= 1

    if v4 then
        TextLabel.Text = "!"
        Frame.BackgroundColor3 = v2
    else
        local TextLabel2 = TextLabel

        TextLabel2.Text = ("%*%%"):format((math.min(math.floor(v11 * 100), 99)))
        Frame.BackgroundColor3 = v1
    end

    local v14 = LocalPlayer:GetAttribute("Rebirths") or 0

    if not v4 or v5 == v14 or v6() then
        return
    end

    v5 = v14
    UIUtil.sound("GoodCast", 0.6, 1.1)
    UIUtil.toast(("🔥 You can REBIRTH! Strength x%* awaits!"):format((Config.rebirthMultiplier(v14 + 1))), "purchase")
end

function t1.setQuietCheck(p1) -- line: 54
    -- upvalues: v6 (ref)
    v6 = p1
end

function t1.init() -- line: 58
    -- upvalues: RunService (copy), Config (copy), UIUtil (copy), LocalPlayer (copy), v1 (copy), v3 (copy), Frame (ref), TextLabel (ref), v4 (ref), refresh (copy)
    local Rebirth = UIUtil.gui("HUD"):WaitForChild("SideLeft"):WaitForChild("Rebirth")

    Frame = Instance.new("Frame")
    Frame.Name = "Badge"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(1, -16, 0, 18)
    Frame.Size = UDim2.fromOffset(62, 40)
    Frame.BackgroundColor3 = v1
    Frame.ZIndex = 5

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v3
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame
    TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.ZIndex = 6

    local UIPadding = Instance.new("UIPadding")
    local v15 = UDim.new(0, 6)
    local v16 = UDim.new(0, 6)

    UIPadding.PaddingTop = v15
    UIPadding.PaddingBottom = v16

    local v17 = UDim.new(0, 6)
    local v18 = UDim.new(0, 6)

    UIPadding.PaddingLeft = v17
    UIPadding.PaddingRight = v18
    UIPadding.Parent = TextLabel

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 2
    UIStroke2.Color = v3
    UIStroke2.Parent = TextLabel
    TextLabel.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pulse"
    UIScale.Parent = Frame
    Frame.Parent = Rebirth

    for _, v19 in { "Rebirths", "Strength", "Money" } do
        LocalPlayer:GetAttributeChangedSignal(v19):Connect(refresh)
    end

    refresh()
    RunService.RenderStepped:Connect(function() -- line: 101
        -- upvalues: UIScale (copy), v4 (ref)
        UIScale.Scale = if v4 then math.abs((math.sin(os.clock() * 5))) * 0.18 + 1 else 1
    end)
end

return t1

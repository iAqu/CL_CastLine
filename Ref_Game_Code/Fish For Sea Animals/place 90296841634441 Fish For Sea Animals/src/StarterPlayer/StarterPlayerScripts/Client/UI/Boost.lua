-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local ButtonY = Enum.KeyCode.ButtonY
local BoostColor = Config.BoostColor
local v1 = Color3.fromRGB(225, 185, 255)
local v2 = Color3.fromRGB(35, 10, 60)
local v3 = Random.new()
local ScreenGui, Frame, TextButton, Frame2

local function v4() -- line: 29
    return false
end

local function boostLeft() -- line: 33
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local BoostUntil = Character and Character:GetAttribute("BoostUntil")

    if BoostUntil then
        return BoostUntil - workspace:GetServerTimeNow()
    end

    return 0
end

local function round(p1) -- line: 39
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = p1
end

local function stroke(p2, p3, p4) -- line: 45
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p3
    UIStroke.Thickness = p4
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p2

    return UIStroke
end

local function text(p5, p6, p7) -- line: 54
    -- upvalues: Config (copy), v1 (copy), v2 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p6
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.Text = p7
    TextLabel.TextColor3 = Color3.new(1, 1, 1)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v2
    UIStroke.Parent = TextLabel

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), v1)
    UIGradient.Rotation = 90
    UIGradient.Parent = TextLabel
    TextLabel.Parent = p5

    return TextLabel
end

local function build() -- line: 74
    -- upvalues: LocalPlayer (copy), BoostColor (copy), v1 (copy), v2 (copy), ScreenGui (ref), Frame (ref), TextButton (ref), Frame2 (ref), text (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BoostGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 20
    Frame = Instance.new("Frame")
    Frame.Name = "Spot"
    Frame.BackgroundTransparency = 1

    local Frame3 = Frame

    Frame3.Size = UDim2.fromOffset(0, 0)
    Frame.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Ring"
    Frame2.BackgroundTransparency = 1

    local Frame4 = Frame2

    Frame4.AnchorPoint = Vector2.new(0.5, 0.5)

    local Frame5 = Frame2

    Frame5.Size = UDim2.fromOffset(110, 110)

    local Frame6 = Frame2
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame6

    local Frame7 = Frame2
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v1
    UIStroke.Thickness = 5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame7
    Frame2.Parent = Frame
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Bubble"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false

    local TextButton2 = TextButton

    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)

    local TextButton3 = TextButton

    TextButton3.Size = UDim2.fromOffset(110, 110)

    local TextButton4 = TextButton

    TextButton4.BackgroundColor3 = Color3.new(1, 1, 1)

    local TextButton5 = TextButton
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = TextButton5

    local TextButton6 = TextButton
    local v5 = Color3.new(1, 1, 1)
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = v5
    UIStroke2.Thickness = 5
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = TextButton6

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(v1, BoostColor:Lerp(v2, 0.3))
    UIGradient.Rotation = 60
    UIGradient.Parent = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Cursor"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://284663799"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(0.7, 0.7)
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Parent = TextButton

    local v6 = text(TextButton, "Label", "2x")

    v6.AnchorPoint = Vector2.new(0.5, 0)
    v6.Position = UDim2.new(0.5, 0, 1, 6)
    v6.Size = UDim2.fromOffset(140, 56)
    TextButton.Parent = Frame
    Frame.Parent = ScreenGui

    local ScreenGui2 = ScreenGui

    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function offer() -- line: 133
    -- upvalues: ContextActionService (copy), RunService (copy), UserInputService (copy), Config (copy), Remotes (copy), UIUtil (copy), ButtonY (copy), v3 (copy), Frame (ref), TextButton (ref), Frame2 (ref), v4 (ref)
    local v7 = false
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Frame3 = Frame

    Frame3.Position = UDim2.fromOffset(ViewportSize.X * v3:NextNumber(0.18, 0.82), ViewportSize.Y * v3:NextNumber(0.22, 0.66))
    TextButton.BackgroundTransparency = 0
    TextButton.Rotation = 0
    Frame.Visible = true
    UIUtil.pop(TextButton, 0.3)
    UIUtil.sound("Pop", 0.6, 1.3)

    local connection = TextButton.Activated:Connect(function() -- line: 142
        -- upvalues: v7 (ref)
        v7 = true
    end)
    local v8 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
    local Cursor = TextButton.Cursor

    if v8 then
        Cursor.Image = UserInputService:GetImageForKeyCode(ButtonY)
    else
        Cursor.Image = "rbxassetid://284663799"
    end

    ContextActionService:BindActionAtPriority("BoostPop", function(_, p9) -- line: 147
        -- upvalues: v7 (ref)
        if p9 == Enum.UserInputState.Begin then
            v7 = true
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, ButtonY)

    local elapsed = os.clock()

    while not v7 do
        if os.clock() - elapsed < Config.BoostWindow then
            local v10 = (os.clock() - elapsed) / Config.BoostWindow
            local v11 = 110 * (2.4 - 1.4 * v10)
            local Frame = Frame2

            Frame.Size = UDim2.fromOffset(v11, v11)
            Frame2.UIStroke.Transparency = 0.6 - 0.6 * v10

            local TextButton2 = TextButton

            TextButton2.Rotation = math.sin(os.clock() * 9) * 6
            TextButton.UIStroke.Thickness = math.abs((math.sin(os.clock() * 6))) * 3 + 4

            if v4() then
                if UIUtil.panelMode() then
                    break
                end

                RunService.RenderStepped:Wait()
                continue
            end
        end

        break
    end

    connection:Disconnect()
    ContextActionService:UnbindAction("BoostPop")
    Frame2.UIStroke.Transparency = 1

    if v7 then
        Remotes.Boost:FireServer()
        UIUtil.sound("SpeedUp", 0.8)
        UIUtil.pop(TextButton, 1.5)
    end

    UIUtil.tween(TextButton, 0.25, {
        BackgroundTransparency = 1
    })
    task.wait(0.25)
    Frame.Visible = false
end

function t1.isShowing() -- line: 179
    -- upvalues: Frame (ref)
    return Frame ~= nil and Frame.Visible
end

function t1.setReadyCheck(p10) -- line: 184
    -- upvalues: v4 (ref)
    v4 = p10
end

function t1.init() -- line: 188
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), v3 (copy), v4 (ref), build (copy), offer (copy)
    build()
    task.spawn(function() -- line: 191
        -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), v3 (copy), v4 (ref), offer (copy)
        local function canOffer() -- line: 192
            -- upvalues: UIUtil (copy), LocalPlayer (copy), v4 (ref)
            local v15 = v4()
            local v16

            if not v15 then
                v16 = v15

                return v16
            end

            local v17 = not UIUtil.panelMode()

            if not v17 then
                v16 = v17

                return v16
            end

            local Character = LocalPlayer.Character
            local BoostUntil = Character and Character:GetAttribute("BoostUntil")

            return (if BoostUntil then BoostUntil - workspace:GetServerTimeNow() else 0) <= 0
        end

        while true do
            local v18 = v4()
            local BoostUntil, v19

            if v18 then
                local v20 = not UIUtil.panelMode()

                if v20 then
                    local Character = LocalPlayer.Character

                    BoostUntil = Character and Character:GetAttribute("BoostUntil")
                    v19 = (if BoostUntil then BoostUntil - workspace:GetServerTimeNow() else 0) <= 0
                else
                    v19 = v20
                end
            else
                v19 = v18
            end

            if not v19 then
                task.wait(0.5)
                continue
            end

            task.wait(v3:NextNumber(Config.BoostEvery[1], Config.BoostEvery[2]))

            local v21 = v4()
            local BoostUntil2, v22

            if v21 then
                local v23 = not UIUtil.panelMode()

                if v23 then
                    local Character = LocalPlayer.Character

                    BoostUntil2 = Character and Character:GetAttribute("BoostUntil")
                    v22 = (if BoostUntil2 then BoostUntil2 - workspace:GetServerTimeNow() else 0) <= 0
                else
                    v22 = v23
                end
            else
                v22 = v21
            end

            if v22 then
                offer()
            end
        end
    end)
end

return t1

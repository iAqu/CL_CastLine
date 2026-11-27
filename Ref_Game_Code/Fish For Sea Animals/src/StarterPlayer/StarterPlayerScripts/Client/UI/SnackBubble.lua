-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local UIUtil = require(script.Parent.UIUtil)
local Robux = require(script.Parent.Parent.Shop.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Products.StrengthPacks[1]
local t2 = {
    180, 300
}
local v2 = Color3.fromRGB(255, 150, 40)
local v3 = Color3.fromRGB(255, 225, 150)
local v4 = Color3.fromRGB(255, 80, 95)
local v5 = Color3.fromRGB(255, 205, 210)
local v6 = Color3.fromRGB(70, 30, 5)
local v7 = Random.new()
local ScreenGui, Frame, TextButton, Frame2, v8, Frame3, UIGradient, ImageLabel
local v9 = true

local function v10() -- line: 35
    return false
end

local function v11() -- line: 38
    return false
end

local function round(p1) -- line: 42
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = p1
end

local function stroke(p2, p3, p4) -- line: 48
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p3
    UIStroke.Thickness = p4
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p2

    return UIStroke
end

local function text(p5, p6) -- line: 57
    -- upvalues: Config (copy), v6 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p6
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v6
    UIStroke.Parent = TextLabel
    TextLabel.Parent = p5

    return TextLabel
end

local function build() -- line: 72
    -- upvalues: LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v6 (copy), ScreenGui (ref), Frame (ref), TextButton (ref), Frame2 (ref), v8 (ref), Frame3 (ref), UIGradient (ref), ImageLabel (ref), text (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SnackBubble"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 20
    Frame = Instance.new("Frame")
    Frame.Name = "Spot"
    Frame.BackgroundTransparency = 1

    local Frame4 = Frame

    Frame4.Size = UDim2.fromOffset(0, 0)
    Frame.Visible = false

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Ring"
    Frame2.BackgroundTransparency = 1

    local Frame5 = Frame2

    Frame5.AnchorPoint = Vector2.new(0.5, 0.5)

    local Frame6 = Frame2

    Frame6.Size = UDim2.fromOffset(124, 124)

    local Frame7 = Frame2
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame7

    local Frame8 = Frame2
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v3
    UIStroke.Thickness = 5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame8
    Frame2.Parent = Frame
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Bubble"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false

    local TextButton2 = TextButton

    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)

    local TextButton3 = TextButton

    TextButton3.Size = UDim2.fromOffset(124, 124)

    local TextButton4 = TextButton

    TextButton4.BackgroundColor3 = Color3.new(1, 1, 1)

    local TextButton5 = TextButton
    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = TextButton5

    local TextButton6 = TextButton
    local v12 = Color3.new(1, 1, 1)
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = v12
    UIStroke2.Thickness = 5
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = TextButton6
    UIGradient = Instance.new("UIGradient")

    local UIGradient2 = UIGradient

    UIGradient2.Color = ColorSequence.new(v3, v2:Lerp(v6, 0.25))
    UIGradient.Rotation = 60
    UIGradient.Parent = TextButton
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Snack"
    ImageLabel.BackgroundTransparency = 1

    local ImageLabel2 = ImageLabel

    ImageLabel2.Image = v1.Image

    local ImageLabel3 = ImageLabel

    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)

    local ImageLabel4 = ImageLabel

    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5)

    local ImageLabel5 = ImageLabel

    ImageLabel5.Size = UDim2.fromScale(0.8, 0.8)

    local ImageLabel6 = ImageLabel

    ImageLabel6.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Parent = TextButton
    v8 = text(TextButton, "Amount")

    local v13 = v8

    v13.AnchorPoint = Vector2.new(0.5, 1)

    local v14 = v8

    v14.Position = UDim2.new(0.5, 0, 0, -4)

    local v15 = v8

    v15.Size = UDim2.fromOffset(190, 40)
    Frame3 = Instance.new("Frame")
    Frame3.Name = "Price"

    local Frame9 = Frame3

    Frame9.AnchorPoint = Vector2.new(0.5, 0)

    local Frame10 = Frame3

    Frame10.Position = UDim2.new(0.5, 0, 1, 4)

    local Frame11 = Frame3

    Frame11.Size = UDim2.fromOffset(112, 38)

    local Frame12 = Frame3

    Frame12.BackgroundColor3 = Color3.fromRGB(70, 205, 85)

    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0, 12)
    UICorner3.Parent = Frame3

    local Frame13 = Frame3
    local UIStroke3 = Instance.new("UIStroke")

    UIStroke3.Color = v6
    UIStroke3.Thickness = 3
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke3.Parent = Frame13

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame3

    local ImageLabel7 = Instance.new("ImageLabel")

    ImageLabel7.BackgroundTransparency = 1
    ImageLabel7.Image = "rbxasset://textures/ui/common/robux.png"
    ImageLabel7.Size = UDim2.fromOffset(22, 22)
    ImageLabel7.Parent = Frame3

    local Label = text(Frame3, "Label")

    Label.LayoutOrder = 1
    Label.TextScaled = false
    Label.TextSize = 24
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Size = UDim2.fromOffset(60, 30)
    Frame3.Parent = TextButton
    TextButton.Parent = Frame
    Frame.Parent = ScreenGui

    local ScreenGui2 = ScreenGui

    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function t1.isShowing() -- line: 161
    -- upvalues: Frame (ref)
    return Frame ~= nil and Frame.Visible
end

local function boostStep() -- line: 166
    -- upvalues: RunService (copy), Products (copy), LocalPlayer (copy)
    local _, v16 = Products.strengthBoostNow(LocalPlayer)

    if not (Products.StrengthBoostMax <= v16) then
        local v17, v18 = Products.strengthBoostOffer(v16)

        if Products.get(v17).Id ~= 0 or RunService:IsStudio() then
            return v17, v18
        end
    end

    return nil
end

local function offer() -- line: 179
    -- upvalues: RunService (copy), Config (copy), Format (copy), Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), Frame (ref), TextButton (ref), Frame2 (ref), v8 (ref), Frame3 (ref), UIGradient (ref), ImageLabel (ref), v9 (ref), v10 (ref)
    local v19 = false
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Frame4 = Frame

    Frame4.Position = UDim2.fromOffset(ViewportSize.X * v7:NextNumber(0.62, 0.82), ViewportSize.Y * v7:NextNumber(0.28, 0.6))

    local v20, v21

    if not v9 then
        local _, v22 = Products.strengthBoostNow(LocalPlayer)
        local v23, v24

        if not (Products.StrengthBoostMax <= v22) then
            v23, v24 = Products.strengthBoostOffer(v22)

            if Products.get(v23).Id == 0 and not RunService:IsStudio() then
                v23 = nil
                v24 = nil
            end
        end

        v21 = v24
        v20 = v23
    end

    v9 = not v9

    if v20 then
        local v25 = v8

        v25.Text = ("%*x 💪 +%*m"):format(v21, Products.StrengthBoostTime // 60)

        local ImageLabel2 = ImageLabel

        ImageLabel2.Image = Config.Icons.Strength

        local UIGradient2 = UIGradient

        UIGradient2.Color = ColorSequence.new(v5, v4:Lerp(v6, 0.25))
        Frame2.UIStroke.Color = v5
    else
        v20 = v1.Key

        local v26 = v8

        v26.Text = ("+%* 💪"):format((Format.short(Products.scaled(LocalPlayer:GetAttribute("StrengthRate") or 0, v1.Minutes, v1.Min))))

        local ImageLabel2 = ImageLabel

        ImageLabel2.Image = v1.Image

        local UIGradient2 = UIGradient

        UIGradient2.Color = ColorSequence.new(v3, v2:Lerp(v6, 0.25))
        Frame2.UIStroke.Color = v3
    end

    Frame3.Label.Text = tostring(Robux.price(v20))
    TextButton.BackgroundTransparency = 0
    Frame.Visible = true
    UIUtil.pop(TextButton, 0.3)
    UIUtil.sound("Pop", 0.6, 1.1)

    local connection = TextButton.Activated:Connect(function() -- line: 206
        -- upvalues: v19 (ref)
        v19 = true
    end)
    local elapsed = os.clock()

    while not v19 do
        if os.clock() - elapsed < 6 then
            local v27 = (os.clock() - elapsed) / 6
            local v28 = 124 * (2.4 - 1.4 * v27)
            local Frame = Frame2

            Frame.Size = UDim2.fromOffset(v28, v28)
            Frame2.UIStroke.Transparency = 0.6 - 0.6 * v27

            local TextButton2 = TextButton

            TextButton2.Rotation = math.sin(os.clock() * 7) * 7
            TextButton.UIStroke.Thickness = math.abs((math.sin(os.clock() * 6))) * 3 + 4

            if v10() then
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
    Frame2.UIStroke.Transparency = 1

    if v19 then
        UIUtil.sound("Click", 0.6)
        UIUtil.pop(TextButton, 1.4)
        Robux.buy(v20)
    end

    UIUtil.tween(TextButton, 0.25, {
        BackgroundTransparency = 1
    })
    task.wait(0.25)
    Frame.Visible = false
end

function t1.setReadyCheck(p7) -- line: 235
    -- upvalues: v10 (ref)
    v10 = p7
end

function t1.setBlockedCheck(p8) -- line: 240
    -- upvalues: v11 (ref)
    v11 = p8
end

function t1.init() -- line: 244
    -- upvalues: UIUtil (copy), t2 (copy), v7 (copy), v10 (ref), v11 (ref), build (copy), offer (copy)
    build()
    task.spawn(function() -- line: 247
        -- upvalues: UIUtil (copy), t2 (copy), v7 (copy), v10 (ref), v11 (ref), offer (copy)
        local n1 = 60
        local n2 = 0

        while true do
            task.wait(1)

            if v10() and not UIUtil.panelMode() then
                n2 += 1

                if n1 <= n2 and not v11() then
                    offer()
                    n1 = v7:NextInteger(t2[1], t2[2])
                    n2 = 0
                end
            end
        end
    end)
end

return t1

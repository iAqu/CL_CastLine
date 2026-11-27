-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Products = require(ReplicatedStorage.Shared.Products)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Robux)
local Style = require(script.Parent.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(255, 205, 40)
local v2 = Color3.fromRGB(92, 52, 8)

local function boostKey() -- line: 27
    -- upvalues: RunService (copy), Products (copy), LocalPlayer (copy)
    local _, v3 = Products.strengthBoostNow(LocalPlayer)

    if not (Products.StrengthBoostMax <= v3) then
        local v4, v5 = Products.strengthBoostOffer(v3)

        if Products.get(v4).Id ~= 0 or RunService:IsStudio() then
            return v4, v5
        end
    end

    return nil
end

local function tutorialOver() -- line: 39
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    return Tutorial ~= nil and Config.TutorialDone <= Tutorial
end

function t1.init(p1) -- line: 45
    -- upvalues: RunService (copy), Config (copy), Products (copy), UIUtil (copy), Kit (copy), Robux (copy), Style (copy), LocalPlayer (copy), v1 (copy), v2 (copy)
    local LeftButtons = UIUtil.gui("HUD"):WaitForChild("LeftButtons")
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "StrengthBoost"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v1
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(0.5, 1)
    TextButton.Position = UDim2.new(0.5, 0, 0, -108)
    TextButton.Size = UDim2.fromOffset(200, 80)
    TextButton.ZIndex = 2
    TextButton.Visible = false
    Kit.corner(TextButton, 16)
    Kit.stroke(TextButton, 5, v2).ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Style.dress(TextButton, 16)

    local v6 = Kit.frame(TextButton, {
        Name = "Clip",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 3,
        Interactable = false,
        Size = UDim2.fromScale(1, 1)
    })
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Rays"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://86205314584043"
    ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
    ImageLabel.ImageTransparency = 0.25
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromOffset(240, 240)
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = v6

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "Icon"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = Config.Icons.Strength
    ImageLabel2.ScaleType = Enum.ScaleType.Fit
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.2)
    ImageLabel2.Size = UDim2.fromOffset(88, 88)
    ImageLabel2.ZIndex = 4
    ImageLabel2.Parent = TextButton

    local v7 = Kit.text(TextButton, "x2 Strength", {
        Name = "Title",
        ZIndex = 5,
        StrokeThickness = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.42),
        Size = UDim2.new(1, -16, 0, 35.2)
    })

    v7.UIStroke.Color = v2
    Style.gradient(v7, ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 246, 214)))

    local v8 = Kit.frame(TextButton, {
        Name = "Price",
        BackgroundTransparency = 1,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.77),
        Size = UDim2.new(1, 0, 0, 27.200000000000003)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v8

    local v9 = Kit.text(v8, "", {
        Name = "Label",
        TextScaled = false,
        TextSize = 25,
        ZIndex = 5,
        StrokeThickness = 4,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 27.200000000000003)
    })

    v9.TextWrapped = false
    v9.UIStroke.Color = v2

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Name = "Robux"
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Image = Style.ROBUX
    ImageLabel3.LayoutOrder = 1
    ImageLabel3.Size = UDim2.fromOffset(24, 24)
    ImageLabel3.ZIndex = 5
    ImageLabel3.Parent = v8
    TextButton.Parent = LeftButtons
    UIUtil.bindButton(TextButton, function() -- line: 140
        -- upvalues: RunService (copy), Products (copy), Robux (copy), LocalPlayer (copy)
        local _, v10 = Products.strengthBoostNow(LocalPlayer)
        local v11

        if not (Products.StrengthBoostMax <= v10) then
            v11 = Products.strengthBoostOffer(v10)

            if Products.get(v11).Id == 0 and not RunService:IsStudio() then
                v11 = nil
            end
        end

        if v11 then
            Robux.buy(v11)
        end
    end)

    local function refresh() -- line: 147
        -- upvalues: p1 (copy), TextButton (copy), v7 (copy), v9 (copy), RunService (copy), Config (copy), Products (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy)
        local _, v12 = Products.strengthBoostNow(LocalPlayer)
        local v13, v14

        if not (Products.StrengthBoostMax <= v12) then
            v13, v14 = Products.strengthBoostOffer(v12)

            if Products.get(v13).Id == 0 and not RunService:IsStudio() then
                v13 = nil
                v14 = nil
            end
        end

        if v13 then
            v7.Text = ("x%* Strength"):format(v14)
            v9.Text = ("ONLY %*"):format((Robux.price(v13)))
        end

        local v15 = p1()

        if v15 then
            local Tutorial = LocalPlayer:GetAttribute("Tutorial")

            v15 = Tutorial ~= nil and Config.TutorialDone <= Tutorial and v13 ~= nil
        end

        if v15 and not TextButton.Visible then
            UIUtil.pop(TextButton, 0.6)
        end

        TextButton.Visible = v15
    end

    task.spawn(function() -- line: 159
        -- upvalues: refresh (copy)
        while true do
            refresh()
            task.wait(0.25)
        end
    end)

    local elapsed = os.clock()

    RunService.RenderStepped:Connect(function() -- line: 168
        -- upvalues: TextButton (copy), ImageLabel (copy), ImageLabel2 (copy), elapsed (copy)
        if TextButton.Visible then
            local v16 = os.clock() - elapsed

            ImageLabel.Rotation = v16 * 30 % 360
            ImageLabel2.Position = UDim2.new(0.5, 0, 0.2, math.sin(v16 * 3) * 3)
            ImageLabel2.Rotation = math.sin(v16 * 2) * 6 + -8
        end
    end)
end

return t1

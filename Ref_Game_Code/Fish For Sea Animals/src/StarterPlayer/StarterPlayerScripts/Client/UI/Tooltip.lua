-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local RarityText = require(script.Parent.RarityText)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(22, 22, 30)
local Frame, v2, v3, v4, v5, v6
local t2 = {}

t2[1] = nil

local function label(p1, p2, p3, p4) -- line: 23
    -- upvalues: Config (copy), v1 (copy), Frame (ref)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p1
    TextLabel.LayoutOrder = p2
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 0, p3)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextColor3 = p4

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 2
    UIStroke.Color = v1
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Frame

    return TextLabel
end

local function build() -- line: 41
    -- upvalues: LocalPlayer (copy), v1 (copy), Frame (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), label (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "Tooltip"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 50
    Frame = Instance.new("Frame")
    Frame.Name = "Card"
    Frame.Visible = false

    local Frame2 = Frame

    Frame2.BackgroundColor3 = Color3.fromRGB(30, 32, 46)
    Frame.BackgroundTransparency = 0.08

    local Frame3 = Frame

    Frame3.Size = UDim2.fromOffset(210, 0)

    local Frame4 = Frame

    Frame4.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Interactable = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v1
    UIStroke.Parent = Frame

    local UIPadding = Instance.new("UIPadding")
    local v7 = UDim.new(0, 8)
    local v8 = UDim.new(0, 8)

    UIPadding.PaddingTop = v7
    UIPadding.PaddingBottom = v8

    local v9 = UDim.new(0, 12)
    local v10 = UDim.new(0, 12)

    UIPadding.PaddingLeft = v9
    UIPadding.PaddingRight = v10
    UIPadding.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame
    v3 = label("Mutation", 0, 20, Color3.new(1, 1, 1))
    v2 = label("Title", 1, 26, Color3.new(1, 1, 1))
    v4 = label("Rarity", 2, 18, Color3.new(1, 1, 1))
    v5 = label("Weight", 3, 22, Color3.fromRGB(255, 225, 120))
    Frame.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function follow() -- line: 91
    -- upvalues: UserInputService (copy), Frame (ref), v6 (ref), t2 (copy)
    if Frame.Visible then
        local v11 = false

        if t2[1] then
            local LayerCollector = t2[1]:FindFirstAncestorWhichIsA("LayerCollector")

            v11 = not t2[1].Visible or not LayerCollector or not LayerCollector.Enabled or not t2[1]:IsDescendantOf(game)
        end

        if v11 then
            v6 = nil
            t2[1] = nil
            Frame.Visible = false
        else
            local MouseLocation = UserInputService:GetMouseLocation()
            local ViewportSize = workspace.CurrentCamera.ViewportSize
            local AbsoluteSize = Frame.AbsoluteSize
            local v12 = if MouseLocation.X + 18 + AbsoluteSize.X > ViewportSize.X then MouseLocation.X - 12 - AbsoluteSize.X else MouseLocation.X + 18
            local v13 = if MouseLocation.Y + 18 + AbsoluteSize.Y > ViewportSize.Y then MouseLocation.Y - 12 - AbsoluteSize.Y else MouseLocation.Y + 18
            local Frame2 = Frame

            Frame2.Position = UDim2.fromOffset(v12, v13)
        end
    end
end

function t1.show(p5, p6, p7, p8, p9, p10) -- line: 110
    -- upvalues: Config (copy), Animals (copy), RarityText (copy), Frame (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), t2 (copy), build (copy), follow (copy)
    local v14 = Animals.get(p6)

    if not v14 then
        return
    end

    if not Frame then
        build()
    end

    local v15 = Config.RarityByName[v14.Rarity]

    v6 = p5
    t2[1] = p8
    v2.Text = v14.Name
    v4.Text = string.upper(Animals.rarityText(v14))
    RarityText.apply(v4, v15)

    local v18 = p9 and Config.MutationByName[p9]
    local v19 = p10 and Config.SizeByName[p10]
    local v20 = v3

    if v18 ~= nil then
        v20.Visible = true
    else
        v20.Visible = v19 ~= nil
    end

    local v21, upper, v22, v23

    if v18 then
        v21 = v3
        upper = string.upper
        v22 = if v19 then v19.Name .. " " else ""
        v23 = false
    elseif v19 then
        v21 = v3
        upper = string.upper
        v22 = v19.Name .. " "
        v23 = false
    else
        v23 = true
    end

    if not v23 then
        v21.Text = upper((("%*%*"):format(v22, if v18 then v18.Name else "")))
        RarityText.apply(v3, v18 or v19)
    end

    v5.Text = Animals.formatWeight(p7 or v14.Weight)
    Frame.Visible = true
    follow()
end

function t1.hide(p11) -- line: 136
    -- upvalues: Frame (ref), v6 (ref), t2 (copy)
    if v6 ~= p11 or not Frame then
        return
    end

    v6 = nil
    t2[1] = nil
    Frame.Visible = false
end

function t1.owner() -- line: 143
    -- upvalues: v6 (ref)
    return v6
end

function t1.bind(p12, p13) -- line: 148
    -- upvalues: t1 (copy)
    local v25 = "gui:" .. p12:GetFullName() .. tostring(p12)

    p12.MouseEnter:Connect(function() -- line: 150
        -- upvalues: p12 (copy), p13 (copy), v25 (copy), t1 (copy)
        local v26 = p13()

        if v26 then
            t1.show(v25, v26.Id, v26.Weight, p12, v26.Mutation, v26.Size)
        end
    end)
    p12.MouseLeave:Connect(function() -- line: 156
        -- upvalues: v25 (copy), t1 (copy)
        t1.hide(v25)
    end)
    p12.AncestryChanged:Connect(function() -- line: 159
        -- upvalues: p12 (copy), v25 (copy), t1 (copy)
        if not p12:IsDescendantOf(game) then
            t1.hide(v25)
        end
    end)
    p12:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 164
        -- upvalues: p12 (copy), v25 (copy), t1 (copy)
        if not p12.Visible then
            t1.hide(v25)
        end
    end)
end

function t1.init() -- line: 171
    -- upvalues: RunService (copy), build (copy), follow (copy)
    build()
    RunService.RenderStepped:Connect(follow)
end

return t1

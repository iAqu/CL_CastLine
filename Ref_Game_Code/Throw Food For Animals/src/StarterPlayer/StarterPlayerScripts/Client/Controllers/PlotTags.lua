-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local FenceConfig = require(ReplicatedStorage.Config.FenceConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local v1 = Vector2.new(15, 10.5)
local t2 = {}

local function headshot(p1) -- line: 34
    return "rbxthumb://type=AvatarHeadShot&id=" .. p1 .. "&w=150&h=150"
end

local function tagPosition(p2) -- line: 39
    -- upvalues: FenceConfig (copy)
    local v2 = (p2:GetAttribute("FenceGrow") or 0) * FenceConfig.SegmentLength
    local v3 = p2.Position.Y + p2.Size.Y / 2

    return (Vector3.new(p2.Position.X, v3 + 26, p2.Position.Z + v2 / 2))
end

local function removeTag(p3) -- line: 45
    -- upvalues: t2 (copy)
    local v6 = t2[p3]

    if not v6 then
        return
    end

    t2[p3] = nil

    for _, v7 in ipairs(v6.Conns) do
        v7:Disconnect()
    end

    v6.Attachment:Destroy()
end

local function buildTag(p4, p5) -- line: 53
    -- upvalues: FenceConfig (copy), NumberFormat (copy), UIKit (copy), Colors (copy), LocalPlayer (copy), v1 (copy), t2 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "OwnerTag"
    Attachment.Parent = p4

    local v8 = (p4:GetAttribute("FenceGrow") or 0) * FenceConfig.SegmentLength
    local v9 = p4.Position.Y + p4.Size.Y / 2

    Attachment.WorldPosition = Vector3.new(p4.Position.X, v9 + 26, p4.Position.Z + v8 / 2)

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "OwnerTag"
    BillboardGui.Size = UDim2.fromScale(v1.X, v1.Y)
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 500
    BillboardGui.AlwaysOnTop = false
    BillboardGui.Adornee = Attachment

    local v12 = p5 == LocalPlayer
    local v13 = UIKit.Frame({
        Name = "Headshot",
        ZIndex = 2,
        Parent = BillboardGui,
        Size = UDim2.fromScale(0.6, 0.6),
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Panel
    })

    v13.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = v13
    UIKit.Gradient(v13, Colors.PanelGradientA, Colors.PanelGradientB, 90)
    UIKit.Stroke(v13, 4, v12 and Colors.YellowA or Color3.fromRGB(235, 240, 245)).Name = "Ring"

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Image"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p5.UserId .. "&w=150&h=150"
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = 3

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = ImageLabel
    ImageLabel.Parent = v13

    local v14 = UIKit.Text({
        Name = "Name",
        ZIndex = 4,
        Stroke = 3,
        Parent = BillboardGui,
        Text = p5.Name,
        Size = UDim2.fromScale(1, 0.2),
        Position = UDim2.fromScale(0.5, 0.63),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    if v12 then
        v14.TextColor3 = Color3.new(1, 1, 1)
        UIKit.Gradient(v14, Color3.fromRGB(255, 245, 160), Colors.YellowB, 90)
    end

    local v15 = UIKit.Text({
        Name = "Income",
        Text = "",
        ZIndex = 4,
        Stroke = 3,
        Parent = BillboardGui,
        Size = UDim2.fromScale(1, 0.17),
        Position = UDim2.fromScale(0.5, 0.83),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Money
    })

    BillboardGui.Parent = Attachment

    local function refreshIncome() -- line: 96
        -- upvalues: p5 (copy), v15 (copy), NumberFormat (copy)
        v15.Text = NumberFormat.PerSecond(p5:GetAttribute("IncomeRate") or 0)
    end

    v15.Text = NumberFormat.PerSecond(p5:GetAttribute("IncomeRate") or 0)
    t2[p4] = {
        Attachment = Attachment,
        Billboard = BillboardGui,
        Conns = {
            p5:GetAttributeChangedSignal("IncomeRate"):Connect(refreshIncome),
            p4:GetAttributeChangedSignal("FenceGrow"):Connect(function() -- line: 102
                -- upvalues: p4 (copy), Attachment (copy), FenceConfig (copy)
                if Attachment.Parent then
                    local v16 = (p4:GetAttribute("FenceGrow") or 0) * FenceConfig.SegmentLength
                    local v17 = p4.Position.Y + p4.Size.Y / 2

                    Attachment.WorldPosition = Vector3.new(p4.Position.X, v17 + 26, p4.Position.Z + v16 / 2)
                end
            end)
        },
        UserId = p5.UserId
    }
end

local function refresh(p6) -- line: 109
    -- upvalues: Players (copy), t2 (copy), removeTag (copy), buildTag (copy)
    local v20 = p6:GetAttribute("OwnerUserId") or 0
    local v21 = t2[p6]

    if not v21 or v21.UserId ~= v20 then
        removeTag(p6)

        if v20 ~= 0 then
            local PlayerByUserId = Players:GetPlayerByUserId(v20)

            if PlayerByUserId then
                buildTag(p6, PlayerByUserId)
            end
        end
    end
end

local function watch(p7) -- line: 119
    -- upvalues: refresh (copy)
    if not p7:IsA("BasePart") then
        return
    end

    p7:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line: 121
        -- upvalues: p7 (copy), refresh (copy)
        refresh(p7)
    end)
    refresh(p7)
end

function t1.Init() -- line: 125
    -- upvalues: Players (copy), GameConfig (copy), t2 (copy), removeTag (copy), refresh (copy), watch (copy)
    task.spawn(function() -- line: 126
        -- upvalues: GameConfig (copy), watch (copy)
        local v22 = workspace:WaitForChild("Plots", 30)

        if v22 then
            for i = 1, GameConfig.PlotCount do
                local v23 = v22:WaitForChild(tostring(i), 10)

                if v23 then
                    watch(v23)
                end
            end
        end
    end)
    Players.PlayerAdded:Connect(function(p8) -- line: 135
        -- upvalues: t2 (copy), refresh (copy)
        for v24 in pairs(t2) do
            if v24:GetAttribute("OwnerUserId") == p8.UserId then
                refresh(v24)
            end
        end

        local Plots = workspace:FindFirstChild("Plots")

        if Plots then
            for _, child in ipairs(Plots:GetChildren()) do
                if child:IsA("BasePart") and child:GetAttribute("OwnerUserId") == p8.UserId then
                    refresh(child)
                end
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(p9) -- line: 145
        -- upvalues: t2 (copy), removeTag (copy)
        for v25, v26 in pairs(t2) do
            if v26.UserId == p9.UserId then
                removeTag(v25)
            end
        end
    end)
end

return t1

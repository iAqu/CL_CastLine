-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local FenceConfig = require(ReplicatedStorage.Config.FenceConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local t1 = {}
local Colors = UITheme.Colors
local v1 = Color3.fromRGB(165, 104, 54)
local v2 = Color3.fromRGB(218, 146, 63)
local t2 = {
    2.45, 3.56, 4.67
}

local function part(p1, p2, p3, p4, p5, p6) -- line: 47
    -- upvalues: v1 (copy), v2 (copy)
    local Part = Instance.new("Part")

    Part.Name = p2
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.Plastic
    Part.MaterialVariant = p6 and "Studs" or ""

    for _, v3 in ipairs({ "Top", "Bottom", "Front", "Back", "Left", "Right" }) do
        Part[v3 .. "Surface"] = Enum.SurfaceType.Universal
    end

    Part.Size = p3
    Part.CFrame = p4
    Part.Color = p5 == "Rail" and v2 or v1
    Part:SetAttribute("SignRole", p5)
    Part.Parent = p1

    return Part
end

function t1.BuildModel(p7) -- line: 68
    -- upvalues: t2 (copy), part (copy)
    local Model = Instance.new("Model")

    Model.Name = "PlotUpgradeSign"

    for v4, v5 in ipairs({ -3.2, 3.2 }) do
        part(Model, "Post" .. v4, Vector3.new(1, 5.2, 1), p7 * CFrame.new(v5, 2.6, 0), "Post", true)
    end

    for v6, v7 in ipairs(t2) do
        part(Model, "Plank" .. v6, Vector3.new(7.4, 1.05, 0.5), p7 * CFrame.new(0, v7, -0.5), "Rail", false)
    end

    part(Model, "Cap", Vector3.new(8.2, 0.5, 1.5), p7 * CFrame.new(0, 5.45, -0.2), "Post", true)
    part(Model, "Trim", Vector3.new(7.7, 0.4, 0.9), p7 * CFrame.new(0, t2[1] - 0.525 - 0.2, -0.35), "Post", true)

    local Part = Instance.new("Part")

    Part.Name = "Face"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = true
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(7.2, 3.27, 0.05)
    Part.CFrame = p7 * CFrame.new(0, t2[2], -0.78)
    Part.Parent = Model
    Model.PrimaryPart = Part

    return Model, Part
end

function t1.ApplyStyle(p8, p9) -- line: 99
    -- upvalues: FenceConfig (copy), v1 (copy), v2 (copy)
    local v8 = FenceConfig.Styles[p9 or "Wood"] or FenceConfig.Styles.Wood

    for _, child in ipairs(p8:GetChildren()) do
        local v9 = child:IsA("BasePart") and child:GetAttribute("SignRole")

        if v9 then
            if v9 == "Rail" then
                child.Color = v8.Rail or v2
            else
                child.Color = v8.Post or v1
            end

            child.Reflectance = v8.Reflectance or 0
        end
    end
end

function t1.BuildFace(p10, p11) -- line: 115
    -- upvalues: NumberFormat (copy), UIKit (copy), Colors (copy)
    local v10 = UIKit.Frame({
        Name = "Root",
        Transparency = 1,
        Parent = p10,
        Size = UDim2.fromScale(1, 1)
    })
    local v11 = UIKit.Frame({
        Name = "Slots",
        Transparency = 1,
        ZIndex = 2,
        Parent = v10,
        Size = UDim2.fromScale(0.94, 0.54),
        Position = UDim2.fromScale(0.5, 0.03),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0.02, 0)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v11

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Paw"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://105642295248032"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.LayoutOrder = 1
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = v11

    local v12 = UIKit.Text({
        Name = "Text",
        Text = "10",
        Stroke = 5,
        Rich = true,
        ZIndex = 3,
        Parent = v11,
        Size = UDim2.fromScale(0.62, 1),
        XAlign = Enum.TextXAlignment.Left
    })

    v12.LayoutOrder = 2
    v12.TextScaled = false
    v12.AutomaticSize = Enum.AutomaticSize.X
    v12.Size = UDim2.fromScale(0, 1)

    local v13, v14 = UIKit.Button({
        Name = "Upgrade",
        Text = "",
        ZIndex = 4,
        Rich = true,
        TextStroke = 4,
        Parent = v10,
        Size = UDim2.fromScale(0.66, 0.38),
        Position = UDim2.fromScale(0.5, 0.95),
        AnchorPoint = Vector2.new(0.5, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        OnClick = p11
    })
    local v15 = UIKit.Frame({
        Name = "Max",
        Corner = 12,
        Stroke = 4,
        ZIndex = 4,
        Parent = v10,
        Size = UDim2.fromScale(0.5, 0.38),
        Position = UDim2.fromScale(0.5, 0.95),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.YellowA,
        StrokeColor = Color3.new(0, 0, 0),
        Gradient = {
            Colors.YellowA,
            Colors.YellowB,
            90
        }
    })

    UIKit.Text({
        Text = "MAX",
        Stroke = 4,
        ZIndex = 5,
        Parent = v15,
        Size = UDim2.fromScale(0.9, 0.8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    local function fitSlots() -- line: 147
        -- upvalues: v11 (copy), v12 (copy)
        local Y = v11.AbsoluteSize.Y

        if Y > 0 then
            v12.TextSize = math.floor(Y * 1)
        end
    end

    v11:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitSlots)

    local Y = v11.AbsoluteSize.Y

    if Y > 0 then
        v12.TextSize = math.floor(Y * 1)
    end

    local t3 = {
        Root = v10,
        Button = v13
    }

    function t3.Show(p12) -- line: 155
        -- upvalues: v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), NumberFormat (copy), UIKit (copy), Colors (copy)
        local Y = v11.AbsoluteSize.Y

        if Y > 0 then
            v12.TextSize = math.floor(Y * 1)
        end

        if p12.Next then
            v12.Text = p12.Current .. " <font color=\"#FFD84A\">></font> <font color=\"#8CFF3C\">" .. p12.Next .. "</font>"
            v14.Text = "▲ " .. NumberFormat.Money(p12.Price)
            UIKit.SetButtonColors(v13, p12.CanBuy and {
                Colors.GreenA,
                Colors.GreenB
            } or {
                Colors.GrayA,
                Colors.GrayB
            })
            v13.Visible = true
            v15.Visible = false
        else
            v12.Text = "<font color=\"#FFD84A\">" .. p12.Current .. "</font>"
            v13.Visible = false
            v15.Visible = true
        end
    end

    return t3
end

return t1

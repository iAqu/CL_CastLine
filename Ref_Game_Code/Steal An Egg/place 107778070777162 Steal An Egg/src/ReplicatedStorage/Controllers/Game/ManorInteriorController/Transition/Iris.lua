-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(10, 4, 14)
local v2 = Vector2.new(0.5, 0.4)
local v3 = Color3.fromRGB(255, 214, 170)
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 92, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 120, 60)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 190, 90)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(150, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 92, 255))
})
local v5
local t1 = {}

local function edge(p1, p2) -- line: 71
    -- upvalues: v1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p2
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = v1
    Frame.Size = UDim2.fromScale(0, 0)
    Frame.ZIndex = 1
    Frame.Parent = p1

    return Frame
end

local function aspect() -- line: 82
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v6 = if CurrentCamera == nil then Vector2.new(16, 9) else CurrentCamera.ViewportSize

    if v6.Y > 0 then
        return v6.X / v6.Y
    end

    return 1.7777777777777777
end

local function openHeight(p3) -- line: 88
    return math.sqrt(p3 * p3 + 1) * 0.54 / 0.15
end

local function sweepHud(p4, p5) -- line: 92
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= p4.Gui and child.Enabled then
                child.Enabled = false
                table.insert(p5, child)
            end
        end
    end
end

local function hideHud(p6) -- line: 105
    -- upvalues: sweepHud (copy)
    local t2 = {}

    p6.Hidden = t2
    sweepHud(p6, t2)
    p6.Trove:Add(function() -- line: 109
        -- upvalues: t2 (copy)
        for _, v8 in t2 do
            if v8.Parent ~= nil then
                v8.Enabled = true
            end
        end
    end)
end

local function layout(p7) -- line: 118
    -- upvalues: Workspace (copy), v2 (copy), v3 (copy), sweepHud (copy), hideHud (copy)
    local Value, Hidden = p7.Value, p7.Hidden

    if Hidden ~= nil then
        sweepHud(p7, Hidden)
    elseif Value < 0.999 then
        hideHud(p7)
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v9 = if CurrentCamera == nil then Vector2.new(16, 9) else CurrentCamera.ViewportSize
    local v10 = if v9.Y > 0 then v9.X / v9.Y else 1.7777777777777777
    local v11

    if Value > 0 then
        v11 = (math.sqrt(v10 * v10 + 1) * 0.54 / 0.15 / 0.035) ^ Value * 0.035

        if Value < 0.06 then
            v11 *= Value / 0.06
        end
    else
        v11 = 0
    end

    local v13 = v11 / v10
    local v14 = 0.5 - v13 * v2.X
    local v15 = 0.5 - v11 * v2.Y
    local v16 = v14 + v13
    local v17 = v15 + v11

    for _, v18 in {
            p7.Mask,
            p7.Glow
        } do
        v18.Size = UDim2.fromScale(v13, v11)
        v18.Visible = v11 > 0
    end

    local Edges = p7.Edges
    local v20 = math.clamp(v14 + 0.002, 0, 1)
    local v22 = math.clamp(v16 - 0.002, 0, 1)
    local v24 = math.clamp(v15 + 0.002, 0, 1)
    local v26 = math.clamp(v17 - 0.002, 0, 1)

    if v11 <= 0 then
        v22 = 0.5
        v26 = 0.5
        v24 = 0.5
        v20 = 0.5
    end

    Edges[1].Position = UDim2.fromScale(0, 0)
    Edges[1].Size = UDim2.fromScale(v20, 1)
    Edges[2].Position = UDim2.fromScale(v22, 0)
    Edges[2].Size = UDim2.fromScale(1 - v22, 1)
    Edges[3].Position = UDim2.fromScale(v20, 0)
    Edges[3].Size = UDim2.fromScale(v22 - v20, v24)
    Edges[4].Position = UDim2.fromScale(v20, v26)
    Edges[4].Size = UDim2.fromScale(v22 - v20, 1 - v26)

    local v27 = 1 - Value
    local v28 = 0.85 + math.noise(p7.Clock * 9, 0.4) * 0.3
    local v30 = math.clamp(v27 * 1.6, 0, 1) * v28

    p7.Glow.ImageTransparency = 1 - math.clamp(v30, 0, 1)

    local Gradient = p7.Gradient

    if p7.Calm then
        Gradient.Rotation = 0
    else
        Gradient.Rotation = p7.Spin
    end

    local v32 = math.clamp(v27 * 1.4, 0, 1)

    p7.Grade.TintColor = Color3.new(1, 1, 1):Lerp(v3, v32)
    p7.Grade.Brightness = v32 * 0.06
    p7.Grade.Contrast = v32 * 0.1
    p7.Bloom.Intensity = v32 * 0.8
end

local function destroy(p8) -- line: 172
    -- upvalues: v5 (ref)
    if v5 == p8 then
        v5 = nil
    end

    p8.Trove:Destroy()
end

local function build() -- line: 179
    -- upvalues: GuiService (copy), RunService (copy), TweenService (copy), Workspace (copy), Trove (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v4 (copy), v5 (ref), layout (copy)
    local v33 = Trove.new()
    local v34 = v33:Add(Instance.new("ScreenGui"))

    v34.Name = "ManorIris"
    v34.IgnoreGuiInset = true
    v34.ResetOnSpawn = false
    v34.DisplayOrder = 1100
    v34.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Mask"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://79612262551499"
    ImageLabel.AnchorPoint = v2
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v34

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "Glow"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = "rbxassetid://122134504251595"
    ImageLabel2.AnchorPoint = v2
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel2.ImageTransparency = 1
    ImageLabel2.ZIndex = 3
    ImageLabel2.Parent = v34

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = v4
    UIGradient.Parent = ImageLabel2

    local Frame = Instance.new("Frame")

    Frame.Name = "Left"
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = v1
    Frame.Size = UDim2.fromScale(0, 0)
    Frame.ZIndex = 1
    Frame.Parent = v34

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Right"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v1
    Frame2.Size = UDim2.fromScale(0, 0)
    Frame2.ZIndex = 1
    Frame2.Parent = v34

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Top"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v1
    Frame3.Size = UDim2.fromScale(0, 0)
    Frame3.ZIndex = 1
    Frame3.Parent = v34

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Bottom"
    Frame4.BorderSizePixel = 0
    Frame4.BackgroundColor3 = v1
    Frame4.Size = UDim2.fromScale(0, 0)
    Frame4.ZIndex = 1
    Frame4.Parent = v34

    local t3 = {
        Frame,
        Frame2,
        Frame3,
        Frame4
    }
    local CurrentCamera = Workspace.CurrentCamera
    local v35 = v33:Add(Instance.new("ColorCorrectionEffect"))

    v35.Name = "ManorIris"
    v35.Parent = CurrentCamera

    local v36 = v33:Add(Instance.new("BloomEffect"))

    v36.Name = "ManorIris"
    v36.Intensity = 0
    v36.Size = 36
    v36.Threshold = 0.85
    v36.Parent = CurrentCamera

    local t4 = {
        From = 1,
        To = 1,
        Value = 1,
        Elapsed = 0,
        Seconds = 0,
        Spin = 0,
        Clock = 0,
        Trove = v33,
        Gui = v34,
        Mask = ImageLabel,
        Glow = ImageLabel2,
        Gradient = UIGradient,
        Edges = t3,
        Grade = v35,
        Bloom = v36,
        Style = Enum.EasingStyle.Quad,
        Direction = Enum.EasingDirection.Out,
        Calm = GuiService.ReducedMotionEnabled
    }

    v33:Connect(RunService.RenderStepped, function(p9) -- line: 243
        -- upvalues: t4 (copy), TweenService (copy), v5 (ref), layout (copy)
        t4.Clock += p9
        t4.Elapsed += p9
        t4.Spin = (t4.Spin + p9 * 160) % 360

        local v37 = if t4.Seconds > 0 then math.clamp(t4.Elapsed / t4.Seconds, 0, 1) else 1
        local Value = TweenService:GetValue(v37, t4.Style, t4.Direction)

        t4.Value = t4.From + (t4.To - t4.From) * Value
        layout(t4)

        if v37 >= 1 and t4.To >= 1 then
            if v5 == t4 then
                v5 = nil
            end

            t4.Trove:Destroy()
        end
    end)
    layout(t4)
    v34.Parent = LocalPlayer:WaitForChild("PlayerGui")

    return t4
end

local function move(p10, p11, p12, p13) -- line: 262
    -- upvalues: v5 (ref), build (copy)
    local v39 = v5

    if v39 == nil then
        if p10 >= 1 then
            return
        end

        v39 = build()
        v5 = v39
    end

    v39.From = v39.Value
    v39.To = p10
    v39.Elapsed = 0
    v39.Seconds = p11
    v39.Style = p12
    v39.Direction = p13
end

function t1.Close(p14) -- line: 289
    -- upvalues: v5 (ref), build (copy)
    local Quad = Enum.EasingStyle.Quad
    local In = Enum.EasingDirection.In
    local v40 = v5

    if v40 == nil then
        v40 = build()
        v5 = v40
    end

    v40.From = v40.Value
    v40.To = 0
    v40.Elapsed = 0
    v40.Seconds = p14
    v40.Style = Quad
    v40.Direction = In
end

function t1.Open(p15) -- line: 293
    -- upvalues: v5 (ref)
    local Quad = Enum.EasingStyle.Quad
    local Out = Enum.EasingDirection.Out
    local v41 = v5

    if v41 == nil then
        return
    end

    v41.From = v41.Value
    v41.To = 1
    v41.Elapsed = 0
    v41.Seconds = p15
    v41.Style = Quad
    v41.Direction = Out
end

function t1.Shut() -- line: 297
    -- upvalues: v5 (ref), build (copy)
    local Linear = Enum.EasingStyle.Linear
    local Out = Enum.EasingDirection.Out
    local v42 = v5

    if v42 == nil then
        v42 = build()
        v5 = v42
    end

    v42.From = v42.Value
    v42.To = 0
    v42.Elapsed = 0
    v42.Seconds = 0
    v42.Style = Linear
    v42.Direction = Out
end

function t1.Clear() -- line: 301
    -- upvalues: v5 (ref)
    local v43 = v5

    if v43 ~= nil then
        if v5 == v43 then
            v5 = nil
        end

        v43.Trove:Destroy()
    end
end

function t1.Closed() -- line: 308
    -- upvalues: v5 (ref)
    local v44 = v5

    return v44 ~= nil and v44.Value <= 0
end

return table.freeze(t1)
